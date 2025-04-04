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

unit Fisco.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceFisco203 = class(TACBrNFSeXWebserviceSoap12)
  private
    function GetSoapAction: string;
    function GetNameSpace: string;
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(const ACabecalho, AMSG: String): string; override;
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoPrestado(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoTomado(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;

    property SoapAction: string read GetSoapAction;
    property NameSpace: string read GetNameSpace;
  end;

  TACBrNFSeProviderFisco203 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrDFeException,
  Fisco.GravarXml, Fisco.LerXml;

{ TACBrNFSeProviderFisco203 }

procedure TACBrNFSeProviderFisco203.Configuracao;
begin
  inherited Configuracao;

  FpFormatoDataRecebimento := tcDatVcto;
  FpFormatoDataEmissao := tcDatVcto;
  FpFormatoDataHora := tcDatVcto;

  ConfigGeral.ConsultaPorFaixaPreencherNumNfseFinal := True;

  with ConfigWebServices do
  begin
    VersaoDados := '2.03';
    VersaoAtrib := '2.03';
    AtribVerLote := 'versao';
  end;
end;

function TACBrNFSeProviderFisco203.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Fisco203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderFisco203.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Fisco203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderFisco203.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceFisco203.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderFisco203.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
begin
  inherited ValidarSchema(Response, aMetodo);

  Response.ArquivoEnvio := StringReplace(Response.ArquivoEnvio,
                             ' xmlns="http://www.abrasf.org.br/nfse.xsd"', '',
                             [rfReplaceAll]);
end;

{ TACBrNFSeXWebserviceFisco203 }

function TACBrNFSeXWebserviceFisco203.GetSoapAction: string;
begin
  // 1 - Produ��o
  // 2 - Homologa��o
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
    Result := 'https://www.fisco.net.br/wsnfseabrasf/ServicosNFSEAbrasf.asmx/'
  else
    Result := 'https://www.fisco.net.br/wsnfseabrasf/ServicosNFSEAbrasfHomologacao.asmx/';
end;

function TACBrNFSeXWebserviceFisco203.GetNameSpace: string;
begin
  // 1 - Produ��o
  // 2 - Homologa��o
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
    Result := 'xmlns:nfse="https://www.fisco.net.br/wsnfseabrasf/ServicosNFSEAbrasf.asmx"'
  else
    Result := 'xmlns:nfse="https://www.fisco.net.br/wsnfseabrasf/ServicosNFSEAbrasfHomologacao.asmx"'
end;

function TACBrNFSeXWebserviceFisco203.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:recepcionarLoteRps>';
  Request := Request + '<nfse:xml>' + IncluirCDATA(AMSG) + '</nfse:xml>';
  Request := Request + '</nfse:recepcionarLoteRps>';

  Result := Executar(SoapAction + 'recepcionarLoteRps', Request,
                     ['recepcionarLoteRpsResult', 'EnviarLoteRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceFisco203.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:recepcionarLoteRpsSincrono>';
  Request := Request + '<nfse:xml>' + IncluirCDATA(AMSG) + '</nfse:xml>';
  Request := Request + '</nfse:recepcionarLoteRpsSincrono>';

  Result := Executar(SoapAction + 'recepcionarLoteRpsSincrono', Request,
                     ['recepcionarLoteRpsSincronoResult', 'EnviarLoteRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceFisco203.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:gerarNfse>';
  Request := Request + '<nfse:xml>' + IncluirCDATA(AMSG) + '</nfse:xml>';
  Request := Request + '</nfse:gerarNfse>';

  Result := Executar(SoapAction + 'gerarNfse', Request,
                     ['gerarNfseResult', 'GerarNfseResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceFisco203.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:consultarLoteRps>';
  Request := Request + '<nfse:xml>' + IncluirCDATA(AMSG) + '</nfse:xml>';
  Request := Request + '</nfse:consultarLoteRps>';

  Result := Executar(SoapAction + 'consultarLoteRps', Request,
                     ['consultarLoteRpsResult', 'ConsultarLoteRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceFisco203.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:consultarNfsePorFaixa>';
  Request := Request + '<nfse:xml>' + IncluirCDATA(AMSG) + '</nfse:xml>';
  Request := Request + '</nfse:consultarNfsePorFaixa>';

  Result := Executar(SoapAction + 'consultarNfsePorFaixa', Request,
                     ['consultarNfsePorFaixaResult', 'ConsultarNfseFaixaResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceFisco203.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:consultarNfsePorRps>';
  Request := Request + '<nfse:xml>' + IncluirCDATA(AMSG) + '</nfse:xml>';
  Request := Request + '</nfse:consultarNfsePorRps>';

  Result := Executar(SoapAction + 'consultarNfsePorRps', Request,
                     ['consultarNfsePorRpsResult', 'ConsultarNfseRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceFisco203.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:consultarNfseServicoPrestado>';
  Request := Request + '<nfse:xml>' + IncluirCDATA(AMSG) + '</nfse:xml>';
  Request := Request + '</nfse:consultarNfseServicoPrestado>';

  Result := Executar(SoapAction + 'consultarNfseServicoPrestado', Request,
                     ['consultarNfseServicoPrestadoResult', 'ConsultarNfseServicoPrestadoResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceFisco203.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:consultarNfseServicoTomado>';
  Request := Request + '<nfse:xml>' + IncluirCDATA(AMSG) + '</nfse:xml>';
  Request := Request + '</nfse:consultarNfseServicoTomado>';

  Result := Executar(SoapAction + 'consultarNfseServicoTomado', Request,
                     ['consultarNfseServicoTomadoResult', 'ConsultarNfseServicoTomadoResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceFisco203.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:cancelarNfse>';
  Request := Request + '<nfse:xml>' + IncluirCDATA(AMSG) + '</nfse:xml>';
  Request := Request + '</nfse:cancelarNfse>';

  Result := Executar(SoapAction + 'cancelarNfse', Request,
                     ['cancelarNfseResult', 'CancelarNfseResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceFisco203.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:substituirNfse>';
  Request := Request + '<nfse:xml>' + IncluirCDATA(AMSG) + '</nfse:xml>';
  Request := Request + '</nfse:substituirNfse>';

  Result := Executar(SoapAction + 'substituirNfse', Request,
                     ['substituirNfseResult', 'SubstituirNfseResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceFisco203.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
end;

end.
