{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ELT.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrDFeSSL,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrANeDocumentos,
  ACBrANe.Classes, ACBrANe.Conversao,
  ACBrANe.ProviderProprio,
  ACBrANe.WebServicesBase, ACBrANe.WebServicesResponse;

type
  TACBrANeWebserviceELT = class(TACBrANeWebserviceSoap11)
  public
    function Enviar(const ACabecalho, AMSG: string): string; override;

  end;

  TACBrANeProviderELT = class (TACBrANeProviderProprio)
  protected
    procedure Configuracao; override;

    function CriarServiceClient(const AMetodo: TMetodo): TACBrANeWebservice; override;

    procedure PrepararEnviar(Response: TANeEnviarResponse); override;
    procedure TratarRetornoEnviar(Response: TANeEnviarResponse); override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TANeWebserviceResponse;
                                     const AListTag: string = '';
                                     const AMessageTag: string = ''); override;
  end;

var
  XmlDocumento: string;

implementation

uses
  synacode,
  ACBrUtil.Strings,
  ACBrANe.Consts,
  ACBrDFeException,
  ACBrANe;

{ TACBrANeProviderELT }

procedure TACBrANeProviderELT.Configuracao;
begin
  inherited Configuracao;

  with ConfigSchemas do
  begin
    Enviar := 'ANe.xsd';
    Consultar := '***';

    Validar := False;
  end;
end;

function TACBrANeProviderELT.CriarServiceClient(
  const AMetodo: TMetodo): TACBrANeWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrANeWebserviceELT.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrANeProviderELT.ProcessarMensagemErros(RootNode: TACBrXmlNode;
  Response: TANeWebserviceResponse; const AListTag, AMessageTag: string);
var
  ANode: TACBrXmlNode;
  AErro: TANeEventoCollectionItem;
  AAlerta: TANeEventoCollectionItem;
  Codigo, Mensagem: string;
begin
  ANode := RootNode;

  if ANode = nil then
    Exit;

  Codigo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Codigo'), tcStr);
  Mensagem := ACBrStr(ObterConteudoTag(ANode.Childrens.FindAnyNs('Resultado'), tcStr));

  if (Codigo = '3') or (Codigo = '7') then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Codigo;
    AErro.Descricao := ACBrStr(Mensagem);
    AErro.Correcao := '';
  end;

  if Codigo = '1' then
  begin
    AAlerta := Response.Alertas.New;
    AAlerta.Codigo := Codigo;
    AAlerta.Descricao := ACBrStr(Mensagem);
    AAlerta.Correcao := '';
  end;
end;

procedure TACBrANeProviderELT.PrepararEnviar(Response: TANeEnviarResponse);
var
//  AErro: TANeEventoCollectionItem;
  Documento: TDocumento;
begin
  Documento := TACBrANe(FAOwner).Documentos.Items[0];

  XmlDocumento := Documento.ANe.xmlDFe;

  with ConfigMsgDados do
  begin
    DadosCabecalho := '<tem:Length>' +
                         IntToStr(Length(XmlDocumento)) +
                      '</tem:Length>' +
                      '<tem:FileName>' +
                         Documento.ANe.NomeArq +
                      '</tem:FileName>' +
                      '<tem:CNPJ>' +
                         Documento.ANe.CNPJ +
                      '</tem:CNPJ>';
  end;

  Response.ArquivoEnvio := '<tem:FileByteStream>' +
                              EncodeBase64(XmlDocumento) +
                           '</tem:FileByteStream>';
end;

procedure TACBrANeProviderELT.TratarRetornoEnviar(Response: TANeEnviarResponse);
var
  Document: TACBrXmlDocument;
  AErro: TANeEventoCollectionItem;
  ANode, ANodeAux: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      Response.CNPJCliente := ObterConteudoTag(ANode.Childrens.FindAnyNs('CNPJ'), tcStr);
      Response.NumeroAverbacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('CTE'), tcStr);
      Response.DataHora := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataHora'), tcDatHor);
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Protocolo'), tcStr);
      Response.Status := ObterConteudoTag(ANode.Childrens.FindAnyNs('status'), tcStr);
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

{ TACBrANeWebserviceELT }

function TACBrANeWebserviceELT.Enviar(const ACabecalho, AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := '<ANe xmlns:tem="http://tempuri.org/">' +
                  XmlDocumento +
               '</ANe>';

  Request := '<tem:RemoteFileInfo>';
  Request := Request + AMSG;
  Request := Request + '</tem:RemoteFileInfo>';

  Result := Executar('http://tempuri.org/IELTAverbaService/FileUpload', Request,
                     ACabecalho, [''], ['xmlns:tem="http://tempuri.org/"']);
end;

end.
