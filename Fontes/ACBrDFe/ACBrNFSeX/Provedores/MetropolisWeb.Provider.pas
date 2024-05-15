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

unit MetropolisWeb.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceMetropolisWeb = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderMetropolisWeb = class (TACBrNFSeProviderABRASFv1)
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
  MetropolisWeb.GravarXml, MetropolisWeb.LerXml;

{ TACBrNFSeProviderMetropolisWeb }

procedure TACBrNFSeProviderMetropolisWeb.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    QuebradeLinha := '&#xd;';
    UseCertificateHTTP := False;
    Identificador := 'id';
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
  end;
end;

function TACBrNFSeProviderMetropolisWeb.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_MetropolisWeb.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderMetropolisWeb.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_MetropolisWeb.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderMetropolisWeb.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceMetropolisWeb.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceMetropolisWeb }

function TACBrNFSeXWebserviceMetropolisWeb.Recepcionar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<end:RecepcionarLoteRps>';
  Request := Request + '<RecepcionarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</RecepcionarLoteRpsRequest>';
  Request := Request + '</end:RecepcionarLoteRps>';

  Result := Executar('', Request,
                     ['RecepcionarLoteRpsResponse', 'outputXML', 'EnviarLoteRpsResposta'],
                     ['xmlns:end="http://endpoint.nfse.ws.webservicenfse.edza.com.br/"']);
end;

function TACBrNFSeXWebserviceMetropolisWeb.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<end:ConsultarLoteRps>';
  Request := Request + '<ConsultarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</ConsultarLoteRpsRequest>';
  Request := Request + '</end:ConsultarLoteRps>';

  Result := Executar('', Request,
                     ['ConsultarLoteRpsResponse', 'outputXML', 'ConsultarLoteRpsResposta'],
                     ['xmlns:end="http://endpoint.nfse.ws.webservicenfse.edza.com.br/"']);
end;

function TACBrNFSeXWebserviceMetropolisWeb.ConsultarSituacao(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<end:ConsultarSituacaoLoteRps>';
  Request := Request + '<ConsultarSituacaoLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</ConsultarSituacaoLoteRpsRequest>';
  Request := Request + '</end:ConsultarSituacaoLoteRps>';

  Result := Executar('', Request,
                     ['ConsultarSituacaoLoteRpsResponse', 'outputXML', 'ConsultarSituacaoLoteRpsResposta'],
                     ['xmlns:end="http://endpoint.nfse.ws.webservicenfse.edza.com.br/"']);
end;

function TACBrNFSeXWebserviceMetropolisWeb.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<end:ConsultarNfsePorRps>';
  Request := Request + '<ConsultarNfsePorRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</ConsultarNfsePorRpsRequest>';
  Request := Request + '</end:ConsultarNfsePorRps>';

  Result := Executar('', Request,
                     ['ConsultarNfsePorRpsResponse', 'outputXML', 'ConsultarNfseRpsResposta'],
                     ['xmlns:end="http://endpoint.nfse.ws.webservicenfse.edza.com.br/"']);
end;

function TACBrNFSeXWebserviceMetropolisWeb.ConsultarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<end:ConsultarNfse>';
  Request := Request + '<ConsultarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</ConsultarNfseRequest>';
  Request := Request + '</end:ConsultarNfse>';

  Result := Executar('', Request,
                     ['ConsultarNfseResponse', 'outputXML', 'ConsultarNfseResposta'],
                     ['xmlns:end="http://endpoint.nfse.ws.webservicenfse.edza.com.br/"']);
end;

function TACBrNFSeXWebserviceMetropolisWeb.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<end:CancelarNfse>';
  Request := Request + '<CancelarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</CancelarNfseRequest>';
  Request := Request + '</end:CancelarNfse>';

  Result := Executar('', Request,
                     ['CancelarNfseResponse', 'outputXML', 'CancelarNfseResposta'],
                     ['xmlns:end="http://endpoint.nfse.ws.webservicenfse.edza.com.br/"']);
end;

function TACBrNFSeXWebserviceMetropolisWeb.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
end;

end.
