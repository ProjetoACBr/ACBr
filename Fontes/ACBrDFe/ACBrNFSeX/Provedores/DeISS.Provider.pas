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

unit DeISS.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceDeISS203 = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNamespace: string;
    function GetSoapAction: string;

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

    property Namespace: string read GetNamespace;
    property SoapAction: string read GetSoapAction;
  end;

  TACBrNFSeProviderDeISS203 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, DeISS.GravarXml, DeISS.LerXml;

{ TACBrNFSeProviderDeISS203 }

procedure TACBrNFSeProviderDeISS203.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
    RpsSubstituirNFSe := True;
    SubstituirNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.03';
    VersaoAtrib := '2.03';
  end;

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');
end;

function TACBrNFSeProviderDeISS203.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_DeISS203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderDeISS203.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_DeISS203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderDeISS203.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceDeISS203.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceDeISS203 }

function TACBrNFSeXWebserviceDeISS203.GetNamespace: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
    Result := 'xmlns:tns="' + TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Producao.NameSpace + '"'
  else
    Result := 'xmlns:tns="' + TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Homologacao.NameSpace + '"';
end;

function TACBrNFSeXWebserviceDeISS203.GetSoapAction: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Producao.SoapAction
  else
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Homologacao.SoapAction;
end;

function TACBrNFSeXWebserviceDeISS203.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:RecepcionarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:RecepcionarLoteRpsRequest>';

  Result := Executar(SoapAction + 'RecepcionarLoteRps', Request,
                     ['outputXML', 'EnviarLoteRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceDeISS203.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:RecepcionarLoteRpsSincronoRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:RecepcionarLoteRpsSincronoRequest>';

  Result := Executar(SoapAction + 'RecepcionarLoteRpsSincrono', Request,
                     ['outputXML', 'EnviarLoteRpsSincronoResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceDeISS203.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:GerarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:GerarNfseRequest>';

  Result := Executar(SoapAction + 'GerarNfse', Request,
                     ['outputXML', 'GerarNfseResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceDeISS203.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:ConsultarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:ConsultarLoteRpsRequest>';

  Result := Executar(SoapAction + 'ConsultarLoteRps', Request,
                     ['outputXML', 'ConsultarLoteRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceDeISS203.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:ConsultarNfsePorFaixaRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:ConsultarNfsePorFaixaRequest>';

  Result := Executar(SoapAction + 'ConsultarNfsePorFaixa', Request,
                     ['outputXML', 'ConsultarNfseFaixaResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceDeISS203.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:ConsultarNfsePorRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:ConsultarNfsePorRpsRequest>';

  Result := Executar(SoapAction + 'ConsultarNfsePorRps', Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceDeISS203.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:ConsultarNfseServicoPrestadoRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:ConsultarNfseServicoPrestadoRequest>';

  Result := Executar(SoapAction + 'ConsultarNfseServicoPrestado', Request,
                     ['outputXML', 'ConsultarNfseServicoPrestadoResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceDeISS203.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:ConsultarNfseServicoTomadoRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:ConsultarNfseServicoTomadoRequest>';

  Result := Executar(SoapAction + 'ConsultarNfseServicoTomado', Request,
                     ['outputXML', 'ConsultarNfseServicoTomadoResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceDeISS203.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:CancelarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:CancelarNfseRequest>';

  Result := Executar(SoapAction + 'CancelarNfse', Request,
                     ['outputXML', 'CancelarNfseResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceDeISS203.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:SubstituirNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:SubstituirNfseRequest>';

  Result := Executar(SoapAction + 'SubstituirNfse', Request,
                     ['outputXML', 'SubstituirNfseResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceDeISS203.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := ConverteANSItoUTF8(aXML);
  Result := RemoverDeclaracaoXML(Result);

  Result := inherited TratarXmlRetornado(Result);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
end;

end.
