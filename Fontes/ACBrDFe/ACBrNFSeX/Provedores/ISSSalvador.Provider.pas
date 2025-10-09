{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit ISSSalvador.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml, ACBrNFSeXProviderABRASFv1,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceISSSalvador = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderISSSalvador = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
  end;

implementation

uses
  ACBrUtil.XMLHTML, ACBrUtil.Strings,
  ACBrDFe.Conversao,
  ACBrDFeException, ACBrNFSeX, ACBrNFSeXConsts,
  ISSSalvador.GravarXml, ISSSalvador.LerXml;

{ TACBrNFSeXWebserviceISSSalvador }

function TACBrNFSeXWebserviceISSSalvador.Recepcionar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:EnviarLoteRPS>';
  Request := Request + '<tem:loteXML>' + IncluirCDATA(AMSG) + '</tem:loteXML>';
  Request := Request + '</tem:EnviarLoteRPS>';

  Result := Executar('http://tempuri.org/IEnvioLoteRPS/EnviarLoteRPS', Request,
                     ['EnviarLoteRPSResult', 'EnviarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceISSSalvador.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarLoteRPS>';
  Request := Request + '<tem:loteXML>' + IncluirCDATA(AMSG) + '</tem:loteXML>';
  Request := Request + '</tem:ConsultarLoteRPS>';

  Result := Executar('http://tempuri.org/IConsultaLoteRPS/ConsultarLoteRPS', Request,
                     ['ConsultarLoteRPSResult', 'ConsultarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceISSSalvador.ConsultarSituacao(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarSituacaoLoteRPS>';
  Request := Request + '<tem:loteXML>' + IncluirCDATA(AMSG) + '</tem:loteXML>';
  Request := Request + '</tem:ConsultarSituacaoLoteRPS>';

  Result := Executar('http://tempuri.org/IConsultaSituacaoLoteRPS/ConsultarSituacaoLoteRPS', Request,
                     ['ConsultarSituacaoLoteRPSResult', 'ConsultarSituacaoLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceISSSalvador.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfseRPS>';
  Request := Request + '<tem:consultaxml>' + IncluirCDATA(AMSG) + '</tem:consultaxml>';
  Request := Request + '</tem:ConsultarNfseRPS>';

  Result := Executar('http://tempuri.org/IConsultaNfseRPS/ConsultarNfseRPS', Request,
                     ['ConsultarNfseRPSResult', 'ConsultarNfseRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceISSSalvador.ConsultarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfse>';
  Request := Request + '<tem:consultaxml>' + IncluirCDATA(AMSG) + '</tem:consultaxml>';
  Request := Request + '</tem:ConsultarNfse>';

  Result := Executar('http://tempuri.org/IConsultaNfse/ConsultarNfse', Request,
                     ['ConsultarNfseResult', 'ConsultarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceISSSalvador.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
end;

{ TACBrNFSeProviderISSSalvador }

procedure TACBrNFSeProviderISSSalvador.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.Identificador := 'id';

  ConfigGeral.ServicosDisponibilizados.CancelarNfse := False;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;
end;

function TACBrNFSeProviderISSSalvador.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ISSSalvador.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSSalvador.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ISSSalvador.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSSalvador.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceISSSalvador.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderISSSalvador.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  AErro := Response.Erros.New;
  AErro.Codigo := Cod001;
  AErro.Descricao := ACBrStr(Desc001);

  TACBrNFSeX(FAOwner).SetStatus(stNFSeIdle);
end;

procedure TACBrNFSeProviderISSSalvador.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
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

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;
      Response.Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataRecebimento'), tcDatVcto);
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Protocolo'), tcStr);
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

end.
