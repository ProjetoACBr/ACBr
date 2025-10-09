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

unit Desenvolve.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceDesenvolve203 = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(const ACabecalho, AMSG: String): string; override;
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderDesenvolve203 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrUtil.XMLHTML,
  ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, Desenvolve.GravarXml, Desenvolve.LerXml;

{ TACBrNFSeProviderDesenvolve203 }

procedure TACBrNFSeProviderDesenvolve203.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
    ConsultaNFSe := False;

    ServicosDisponibilizados.ConsultarFaixaNfse := False;
    ServicosDisponibilizados.ConsultarServicoPrestado := False;
    ServicosDisponibilizados.ConsultarServicoTomado := False;
    ServicosDisponibilizados.SubstituirNfse := False;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    ConsultarLote := True;
    ConsultarNFSeRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.03';
    VersaoAtrib := '2.03';
  end;
end;

function TACBrNFSeProviderDesenvolve203.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Desenvolve203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderDesenvolve203.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Desenvolve203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderDesenvolve203.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceDesenvolve203.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceDesenvolve203 }

function TACBrNFSeXWebserviceDesenvolve203.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:enviarLoteRpsEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</tns:enviarLoteRpsEnvio>';

  Result := Executar('', Request,
                     ['return', 'EnviarLoteRpsResposta'],
                     ['xmlns:tns="http://ws.integracao.nfsd.desenvolve/"']);
end;

function TACBrNFSeXWebserviceDesenvolve203.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:enviarLoteRpsSincronoEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</tns:enviarLoteRpsSincronoEnvio>';

  Result := Executar('', Request,
                     ['return', 'EnviarLoteRpsSincronoResposta'],
                     ['xmlns:tns="http://ws.integracao.nfsd.desenvolve/"']);
end;

function TACBrNFSeXWebserviceDesenvolve203.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:gerarNfseEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</tns:gerarNfseEnvio>';

  Result := Executar('', Request,
                     ['return', 'GerarNfseResposta'],
                     ['xmlns:tns="http://ws.integracao.nfsd.desenvolve/"']);
end;

function TACBrNFSeXWebserviceDesenvolve203.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:consultarLoteRpsEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</tns:consultarLoteRpsEnvio>';

  Result := Executar('', Request,
                     ['return', 'ConsultarLoteRpsResposta'],
                     ['xmlns:tns="http://ws.integracao.nfsd.desenvolve/"']);
end;

function TACBrNFSeXWebserviceDesenvolve203.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:consultarNfseRpsEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</tns:consultarNfseRpsEnvio>';

  Result := Executar('', Request,
                     ['return', 'ConsultarNfseRpsResposta'],
                     ['xmlns:tns="http://ws.integracao.nfsd.desenvolve/"']);
end;

function TACBrNFSeXWebserviceDesenvolve203.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:cancelarNfseEnvio>';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</tns:cancelarNfseEnvio>';

  Result := Executar('', Request,
                     ['return', 'CancelarNfseResposta'],
                     ['xmlns:tns="http://ws.integracao.nfsd.desenvolve/"']);
end;

function TACBrNFSeXWebserviceDesenvolve203.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
end;

end.
