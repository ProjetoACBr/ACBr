{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit Horus.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceHorus = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNamespace: string;
    function GetSoapAction: string;
    function GetAliasCidade: string;
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;

    property Namespace: string read GetNamespace;
    property SoapAction: string read GetSoapAction;
    property AliasCidade: string read GetAliasCidade;
  end;

  TACBrNFSeProviderHorus = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrDFeException,
  ACBrDFe.Conversao,
  ACBrNFSeX, ACBrUtil.XMLHTML,
  Horus.GravarXml, Horus.LerXml;

{ TACBrNFSeProviderHorus }

procedure TACBrNFSeProviderHorus.Configuracao;
begin
  inherited Configuracao;

  SetXmlNameSpace('http://www.abrasf.org.br/nfse.xsd');

  with ConfigWebServices do
  begin
    VersaoDados := '1.00';
    VersaoAtrib := '1.00';
    AtribVerLote := 'versao';
  end;
end;

function TACBrNFSeProviderHorus.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Horus.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderHorus.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Horus.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderHorus.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceHorus.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceHorus }

function TACBrNFSeXWebserviceHorus.GetAliasCidade: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 2 then
    Result := 'teste'
  else
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.Params.ValorParametro('AliasCidade');
end;

function TACBrNFSeXWebserviceHorus.GetNamespace: string;
begin
  Result := 'xmlns:ser="http://' + AliasCidade + '.horusdm.com.br/service?wsdl"';
end;

function TACBrNFSeXWebserviceHorus.GetSoapAction: string;
begin
  Result := 'http://' + AliasCidade + '.horusdm.com.br/service?wsdl#';
end;

function TACBrNFSeXWebserviceHorus.Recepcionar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ser:EnviarLoteRpsEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</ser:EnviarLoteRpsEnvio>';

  Result := Executar(SoapAction + 'EnviarLoteRpsEnvio', Request,
                     ['return', 'EnviarLoteRpsResposta'],
                     [Namespace]);
end;

function TACBrNFSeXWebserviceHorus.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ser:ConsultarLoteRpsEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</ser:ConsultarLoteRpsEnvio>';

  Result := Executar(SoapAction + 'ConsultarLoteRpsEnvio', Request,
                     ['return', 'ConsultarLoteRpsResposta'],
                     [Namespace]);
end;

function TACBrNFSeXWebserviceHorus.ConsultarSituacao(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ser:ConsultarSituacaoLoteRpsEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</ser:ConsultarSituacaoLoteRpsEnvio>';

  Result := Executar(SoapAction + 'ConsultarSituacaoLoteRpsEnvio', Request,
                     ['return', 'ConsultarSituacaoLoteRpsResposta'],
                     [Namespace]);
end;

function TACBrNFSeXWebserviceHorus.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ser:ConsultarNfseRpsEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</ser:ConsultarNfseRpsEnvio>';

  Result := Executar(SoapAction + 'ConsultarNfseRpsEnvio', Request,
                     ['return', 'ConsultarNfseRpsResposta'],
                     [Namespace]);
end;

function TACBrNFSeXWebserviceHorus.ConsultarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ser:ConsultarNfseEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</ser:ConsultarNfseEnvio>';

  Result := Executar(SoapAction + 'ConsultarNfseEnvio', Request,
                     ['return', 'ConsultarNfseResposta'],
                     [Namespace]);
end;

function TACBrNFSeXWebserviceHorus.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ser:CancelarNfseEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</ser:CancelarNfseEnvio>';

  Result := Executar(SoapAction + 'CancelarNfseEnvio', Request,
                     ['return', 'CancelarNfseResposta'],
                     [Namespace]);
end;

function TACBrNFSeXWebserviceHorus.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverIdentacao(Result);
  Result := RemoverDeclaracaoXML(Result);
end;

end.
