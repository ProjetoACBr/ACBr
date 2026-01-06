{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit Tinus.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXWebservicesResponse,
  ACBrNFSeXProviderABRASFv1,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceTinus = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNameSpace: string;
    function GetSoapAction: string;
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    property NameSpace: string read GetNameSpace;
    property SoapAction: string read GetSoapAction;
  end;

  TACBrNFSeProviderTinus = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  end;

  TACBrNFSeProviderTinus102 = class (TACBrNFSeProviderTinus)
  protected
    procedure Configuracao; override;

  end;

  TACBrNFSeXWebserviceTinus203 = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(const ACabecalho, AMSG: String): string; override;
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    {
    function ConsultarNFSePorFaixa(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoPrestado(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoTomado(const ACabecalho, AMSG: String): string; override;
    }
    function Cancelar(const ACabecalho, AMSG: String): string; override;
//    function SubstituirNFSe(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderTinus203 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;
  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrDFe.Conversao,
  ACBrNFSeX,
  ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, Tinus.GravarXml, Tinus.LerXml;

{ TACBrNFSeXWebserviceTinus }

function TACBrNFSeXWebserviceTinus.GetNameSpace: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
    Result := 'http://www.tinus.com.br'
  else
    Result := 'http://www2.tinus.com.br';

  if TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.Versao = ve102 then
    Result := 'http://www.abrasf.org.br/nfse.xsd';

  Result := 'xmlns:tin="' + Result + '"';
end;

function TACBrNFSeXWebserviceTinus.GetSoapAction: string;
begin
  if TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.Versao = ve102 then
    Result := 'http://www.abrasf.org.br/nfse.xsd/WSNFSE.'
  else
    Result := 'http://www.tinus.com.br/WSNFSE.';
end;

function TACBrNFSeXWebserviceTinus.Recepcionar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tin:RecepcionarLoteRps>';
  Request := Request + AMSG;
  Request := Request + '</tin:RecepcionarLoteRps>';

  Result := Executar(SoapAction + 'RecepcionarLoteRps.RecepcionarLoteRps', Request,
                     ['RecepcionarLoteRpsResult'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceTinus.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tin:ConsultarLoteRps>';
  Request := Request + AMSG;
  Request := Request + '</tin:ConsultarLoteRps>';

  Result := Executar(SoapAction + 'ConsultarLoteRps.ConsultarLoteRps', Request,
                     ['ConsultarLoteRpsResult'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceTinus.ConsultarSituacao(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tin:ConsultarSituacaoLoteRps>';
  Request := Request + AMSG;
  Request := Request + '</tin:ConsultarSituacaoLoteRps>';

  Result := Executar(SoapAction + 'ConsultarSituacaoLoteRps.ConsultarSituacaoLoteRps', Request,
                     ['ConsultarSituacaoLoteRpsResult'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceTinus.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tin:ConsultarNfsePorRps>';
  Request := Request + AMSG;
  Request := Request + '</tin:ConsultarNfsePorRps>';

  Result := Executar(SoapAction + 'ConsultarNfsePorRps.ConsultarNfsePorRps', Request,
                     ['ConsultarNfsePorRpsResult'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceTinus.ConsultarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tin:ConsultarNfse>';
  Request := Request + AMSG;
  Request := Request + '</tin:ConsultarNfse>';

  Result := Executar(SoapAction + 'ConsultarNfse.ConsultarNfse', Request,
                     ['ConsultarNfseResult'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceTinus.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tin:CancelarNfse>';
  Request := Request + AMSG;
  Request := Request + '</tin:CancelarNfse>';

  Result := Executar(SoapAction + 'CancelarNfse.CancelarNfse', Request,
                     ['CancelarNfseResult'],
                     [NameSpace]);
end;

{ TACBrNFSeProviderTinus }

procedure TACBrNFSeProviderTinus.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.Identificador := 'id';

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
  end;

  SetXmlNameSpace('http://www.tinus.com.br');

  SetNomeXSD('nfsetinus.xsd');
end;

function TACBrNFSeProviderTinus.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Tinus.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTinus.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Tinus.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTinus.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceTinus.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderTinus.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
var
  xXml: string;
begin
  inherited ValidarSchema(Response, aMetodo);

  xXml := Response.ArquivoEnvio;

  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
    xXml := StringReplace(xXml, 'www.tinus', 'www2.tinus', [rfReplaceAll]);

  if ConfigGeral.Versao = ve100 then
  begin
    case aMetodo of
        tmRecepcionar:
          xXml := StringReplace(xXml, 'EnviarLoteRpsEnvio', 'Arg', [rfReplaceAll]);

        tmConsultarSituacao:
          xXml := StringReplace(xXml, 'ConsultarSituacaoLoteRpsEnvio', 'Arg', [rfReplaceAll]);

        tmConsultarLote:
          xXml := StringReplace(xXml, 'ConsultarLoteRpsEnvio', 'Arg', [rfReplaceAll]);

        tmConsultarNFSePorRps:
          xXml := StringReplace(xXml, 'ConsultarNfseRpsEnvio', 'Arg', [rfReplaceAll]);

        tmConsultarNFSe:
          xXml := StringReplace(xXml, 'ConsultarNfseEnvio', 'Arg', [rfReplaceAll]);

        tmCancelarNFSe:
          xXml := StringReplace(xXml, 'CancelarNfseEnvio', 'Arg', [rfReplaceAll]);
    else
      Response.ArquivoEnvio := xXml;
    end;
  end;

  Response.ArquivoEnvio := xXml;
end;

{ TACBrNFSeProviderTinus102 }

procedure TACBrNFSeProviderTinus102.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.Identificador := 'Id';

  SetXmlNameSpace('http://www.abrasf.org.br/nfse.xsd');

  SetNomeXSD('nfse.xsd');
end;

{ TACBrNFSeXWebserviceTinus203 }

function TACBrNFSeXWebserviceTinus203.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/WSNFSE203.Service2.nfseSOAP.EnviarLoteRpsEnvio',
                     Request,
                     ['outputXML', 'EnviarLoteRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceTinus203.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/WSNFSE203.Service2.nfseSOAP.EnviarLoteRpsSincronoEnvio',
                     Request,
                     ['outputXML', 'EnviarLoteRpsSincronoResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceTinus203.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/WSNFSE203.Service2.nfseSOAP.GerarNfseEnvio',
                     Request,
                     ['outputXML', 'GerarNfseResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceTinus203.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/WSNFSE203.Service2.nfseSOAP.ConsultarLoteRpsEnvio',
                     Request,
                     ['outputXML', 'ConsultarLoteRpsResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceTinus203.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/WSNFSE203.Service2.nfseSOAP.ConsultarNfseRpsEnvio',
                     Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;
(*
function TACBrNFSeXWebserviceTinus203.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfsePorFaixaRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarNfsePorFaixaRequest>';

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfsePorFaixa',
                     Request,
                     ['outputXML', 'ConsultarNfseFaixaResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceTinus203.ConsultarNFSeServicoPrestado(
  const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfseServicoPrestadoRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarNfseServicoPrestadoRequest>';

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfseServicoPrestado',
                     Request,
                     ['outputXML', 'ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceTinus203.ConsultarNFSeServicoTomado(
  const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfseServicoTomadoRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarNfseServicoTomadoRequest>';

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfseServicoTomado',
                     Request,
                     ['outputXML', 'ConsultarNfseServicoTomadoResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;
*)
function TACBrNFSeXWebserviceTinus203.Cancelar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/WSNFSE203.Service2.nfseSOAP.CancelarNfseEnvio',
                     Request,
                     ['outputXML', 'CancelarNfseResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;
(*
function TACBrNFSeXWebserviceTinus203.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:SubstituirNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:SubstituirNfseRequest>';

  Result := Executar('http://nfse.abrasf.org.br/SubstituirNfse', Request,
                     ['outputXML', 'SubstituirNfseResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;
*)
function TACBrNFSeXWebserviceTinus203.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
end;

{ TACBrNFSeProviderTinus203 }

procedure TACBrNFSeProviderTinus203.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    QuebradeLinha := '\s\n';
    ConsultaPorFaixaPreencherNumNfseFinal := True;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.03';
    VersaoAtrib := '2.03';
  end;

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderTinus203.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Tinus203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTinus203.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Tinus203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTinus203.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceTinus203.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

end.
