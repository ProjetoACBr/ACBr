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

unit ISSJoinville.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceISSJoinville204 = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNamespace: string;
    function GetSoapAction: string;
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;

    property Namespace: string read GetNamespace;
    property SoapAction: string read GetSoapAction;
  end;

  TACBrNFSeProviderISSJoinville204 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
  public
    function GetSchemaPath: string; override;
  end;

implementation

uses
  ACBrDFeException, ACBrUtil.Strings,
  ACBrXmlDocument, ACBrXmlReader,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXNotasFiscais, ACBrNFSeXConsts,
  ISSJoinville.GravarXml, ISSJoinville.LerXml;

{ TACBrNFSeProviderISSJoinville204 }

procedure TACBrNFSeProviderISSJoinville204.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    QuebradeLinha := '\n';
    ModoEnvio := meLoteAssincrono;
    ConsultaNFSe := False;

    ServicosDisponibilizados.EnviarLoteSincrono := False;
    ServicosDisponibilizados.EnviarUnitario := False;
    ServicosDisponibilizados.ConsultarFaixaNfse := False;
    ServicosDisponibilizados.ConsultarServicoPrestado := False;
    ServicosDisponibilizados.ConsultarServicoTomado := False;
    ServicosDisponibilizados.SubstituirNfse := False;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.04';
    VersaoAtrib := '2.04';
  end;

  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 1 then
    SetXmlNameSpace('http://nfemws.joinville.sc.gov.br')
  else
    SetXmlNameSpace('http://nfemwshomologacao.joinville.sc.gov.br');

  ConfigMsgDados.GerarPrestadorLoteRps := True;

  SetNomeXSD('nfse_v2-04.xsd');
end;

function TACBrNFSeProviderISSJoinville204.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ISSJoinville204.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSJoinville204.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ISSJoinville204.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSJoinville204.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceISSJoinville204.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderISSJoinville204.GetSchemaPath: string;
begin
  Result := inherited GetSchemaPath;

  if ConfigGeral.Ambiente = taProducao then
    Result := Result + '\Producao\'
  else
    Result := Result + '\Homologacao\';
end;

procedure TACBrNFSeProviderISSJoinville204.TratarRetornoConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  ANota: TNotaFiscal;
  NumRps: String;
  I: Integer;
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

      Response.Situacao := '3'; // Processado com Falhas

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'ListaMensagemRetornoLote', 'MensagemRetornoLote');

      Response.Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('Situacao'), tcStr);

      ANode := ANode.Childrens.FindAnyNs('ListaNfse');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod202;
        AErro.Descricao := ACBrStr(Desc202);
        Exit;
      end;

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');
      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := ACBrStr(Desc203);
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('Nfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('NumeroRps'), tcStr);

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
        SalvarXmlNfse(ANota);

        Response.Situacao := '4'; // Processado com sucesso pois retornou a nota
      end;
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

{ TACBrNFSeXWebserviceISSJoinville204 }

function TACBrNFSeXWebserviceISSJoinville204.GetNamespace: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
    Result := 'xmlns="https://nfemws.joinville.sc.gov.br/"'
  else
    Result := 'xmlns="https://nfemwshomologacao.joinville.sc.gov.br/"';
end;

function TACBrNFSeXWebserviceISSJoinville204.GetSoapAction: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
    Result := 'https://nfemws.joinville.sc.gov.br/'
  else
    Result := 'https://nfemwshomologacao.joinville.sc.gov.br/';
end;

function TACBrNFSeXWebserviceISSJoinville204.Recepcionar(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar(SoapAction + 'EnviarLoteRpsEnvio', AMSG,
                     ['EnviarLoteRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceISSJoinville204.ConsultarLote(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar(SoapAction + 'ConsultarLoteRpsEnvio', AMSG,
                     ['ConsultarLoteRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceISSJoinville204.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar(SoapAction + 'ConsultarNfseRpsEnvio', AMSG,
                     ['ConsultarNfseRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceISSJoinville204.Cancelar(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar(SoapAction + 'CancelarNfseEnvio', AMSG,
                     ['CancelarNfseResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceISSJoinville204.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := RemoverPrefixosDesnecessarios(Result);
end;

end.
