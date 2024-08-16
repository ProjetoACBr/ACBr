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

unit ISSVitoria.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceISSVitoria200 = class(TACBrNFSeXWebserviceSoap11)
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
  end;

  TACBrNFSeProviderISSVitoria200 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function VerificarAlerta(const ACodigo, AMensagem, ACorrecao: string): Boolean; override;
    function VerificarErro(const ACodigo, AMensagem, ACorrecao: string): Boolean; override;
  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, ISSVitoria.GravarXml, ISSVitoria.LerXml;

{ TACBrNFSeProviderISSVitoria200 }

procedure TACBrNFSeProviderISSVitoria200.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
    RpsSubstituirNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.01';
    VersaoDados := '2.01';
  end;

  SetXmlNameSpace('http://www.abrasf.org.br/nfse.xsd');
end;

function TACBrNFSeProviderISSVitoria200.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ISSVitoria200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSVitoria200.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ISSVitoria200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSVitoria200.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceISSVitoria200.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderISSVitoria200.VerificarAlerta(const ACodigo,
  AMensagem, ACorrecao: string): Boolean;
begin
  if ACodigo = 'A31' then
    Result := True
  else
    Result := inherited VerificarAlerta(ACodigo, AMensagem, ACorrecao);
end;

function TACBrNFSeProviderISSVitoria200.VerificarErro(const ACodigo,
  AMensagem, ACorrecao: string): Boolean;
begin
  if ACodigo = 'A31' then
    Result := False
  else
    Result := inherited VerificarErro(ACodigo, AMensagem, ACorrecao);
end;

{ TACBrNFSeXWebserviceISSVitoria200 }

function TACBrNFSeXWebserviceISSVitoria200.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecepcionarLoteRps xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</RecepcionarLoteRps>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/RecepcionarLoteRps', Request,
                     ['RecepcionarLoteRpsResult', 'EnviarLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSVitoria200.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecepcionarLoteRpsSincrono xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</RecepcionarLoteRpsSincrono>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/RecepcionarLoteRpsSincrono', Request,
                     ['RecepcionarLoteRpsSincronoResult', 'EnviarLoteRpsSincronoResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSVitoria200.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<GerarNfse xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</GerarNfse>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/GerarNfse', Request,
                     ['GerarNfseResult', 'GerarNfseResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSVitoria200.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarLoteRps xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</ConsultarLoteRps>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/ConsultarLoteRps', Request,
                     ['ConsultarLoteRpsResult', 'ConsultarLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSVitoria200.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseFaixa xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</ConsultarNfseFaixa>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/ConsultarNfseFaixa', Request,
                     ['ConsultarNfseFaixaResult', 'ConsultarNfseFaixaResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSVitoria200.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfsePorRps xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</ConsultarNfsePorRps>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/ConsultarNfsePorRps', Request,
                     ['ConsultarNfsePorRpsResult', 'ConsultarNfseRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSVitoria200.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseServicoPrestado xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</ConsultarNfseServicoPrestado>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/ConsultarNfseServicoPrestado', Request,
                     ['ConsultarNfseServicoPrestadoResult', 'ConsultarNfseServicoPrestadoResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSVitoria200.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseServicoTomado xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</ConsultarNfseServicoTomado>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/ConsultarNfseServicoTomado', Request,
                     ['ConsultarNfseServicoTomadoResult', 'ConsultarNfseServicoTomadoResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSVitoria200.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<CancelarNfse xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</CancelarNfse>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/CancelarNfse', Request,
                     ['CancelarNfseResult', 'CancelarNfseResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSVitoria200.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<SubstituirNfse xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</SubstituirNfse>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/SubstituirNfse', Request,
                     ['SubstituirNfseResult', 'SubstituirNfseResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSVitoria200.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := RemoverCaracteresDesnecessarios(Result);
  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverIdentacao(Result);
end;

end.
