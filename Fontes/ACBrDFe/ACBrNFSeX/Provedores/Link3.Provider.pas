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

unit Link3.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceLink3200 = class(TACBrNFSeXWebserviceSoap11)
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

  end;

  TACBrNFSeProviderLink3200 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, Link3.GravarXml, Link3.LerXml;

{ TACBrNFSeProviderLink3200 }

procedure TACBrNFSeProviderLink3200.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;
end;

function TACBrNFSeProviderLink3200.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Link3200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderLink3200.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Link3200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderLink3200.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceLink3200.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceLink3200 }

function TACBrNFSeXWebserviceLink3200.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:recepcionarLoteRps>';
  Request := Request + XmlToStr(AMSG);
  Request := Request + '</tns:recepcionarLoteRps>';

  Result := Executar('recepcionarLoteRps', Request,
                     ['return', 'outputXML', 'EnviarLoteRpsResposta'],
                     ['xmlns:tns="http://impl.nfse.services.l3grp.link3.com.br/"']);
end;

function TACBrNFSeXWebserviceLink3200.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:recepcionarLoteRpsSincrono>';
  Request := Request + XmlToStr(AMSG);
  Request := Request + '</tns:recepcionarLoteRpsSincrono>';

  Result := Executar('recepcionarLoteRpsSincrono', Request,
                     ['return', 'outputXML', 'EnviarLoteRpsSincronoResposta'],
                     ['xmlns:tns="http://impl.nfse.services.l3grp.link3.com.br/"']);
end;

function TACBrNFSeXWebserviceLink3200.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:gerarNfse>';
  Request := Request + XmlToStr(AMSG);
  Request := Request + '</tns:gerarNfse>';

  Result := Executar('gerarNfse', Request,
                     ['return', 'outputXML', 'GerarNfseResposta'],
                     ['xmlns:tns="http://impl.nfse.services.l3grp.link3.com.br/"']);
end;

function TACBrNFSeXWebserviceLink3200.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:consultarLoteRps>';
  Request := Request + XmlToStr(AMSG);
  Request := Request + '</tns:consultarLoteRps>';

  Result := Executar('consultarLoteRps', Request,
                     ['return', 'outputXML', 'ConsultarLoteRpsResposta'],
                     ['xmlns:tns="http://impl.nfse.services.l3grp.link3.com.br/"']);
end;

function TACBrNFSeXWebserviceLink3200.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:consultarNfsePorFaixa>';
  Request := Request + XmlToStr(AMSG);
  Request := Request + '</tns:consultarNfsePorFaixa>';

  Result := Executar('consultarNfsePorFaixa', Request,
                     ['return', 'outputXML', 'ConsultarNfsePorFaixaResposta'],
                     ['xmlns:tns="http://impl.nfse.services.l3grp.link3.com.br/"']);
end;

function TACBrNFSeXWebserviceLink3200.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:consultarNfsePorRps>';
  Request := Request + XmlToStr(AMSG);
  Request := Request + '</tns:consultarNfsePorRps>';

  Result := Executar('consultarNfsePorRps', Request,
                     ['return', 'outputXML', 'ConsultarNfseRpsResposta'],
                     ['xmlns:tns="http://impl.nfse.services.l3grp.link3.com.br/"']);
end;

function TACBrNFSeXWebserviceLink3200.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:consultarNfseServicoPrestado>';
  Request := Request + XmlToStr(AMSG);
  Request := Request + '</tns:consultarNfseServicoPrestado>';

  Result := Executar('consultarNfseServicoPrestado', Request,
                     ['return', 'outputXML', 'ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns:tns="http://impl.nfse.services.l3grp.link3.com.br/"']);
end;

function TACBrNFSeXWebserviceLink3200.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:consultarNfseServicoTomado>';
  Request := Request + XmlToStr(AMSG);
  Request := Request + '</tns:consultarNfseServicoTomado>';

  Result := Executar('consultarNfseServicoTomado', Request,
                     ['return', 'outputXML', 'ConsultarNfseServicoTomadoResposta'],
                     ['xmlns:tns="http://impl.nfse.services.l3grp.link3.com.br/"']);
end;

function TACBrNFSeXWebserviceLink3200.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:cancelarNfse>';
  Request := Request + XmlToStr(AMSG);
  Request := Request + '</tns:cancelarNfse>';

  Result := Executar('cancelarNfse', Request,
                     ['return', 'outputXML', 'CancelarNfseResposta'],
                     ['xmlns:tns="http://impl.nfse.services.l3grp.link3.com.br/"']);
end;

function TACBrNFSeXWebserviceLink3200.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:substituirNfse>';
  Request := Request + XmlToStr(AMSG);
  Request := Request + '</tns:substituirNfse>';

  Result := Executar('substituirNfse', Request,
                     ['return', 'outputXML', 'SubstituirNfseResposta'],
                     ['xmlns:tns="http://impl.nfse.services.l3grp.link3.com.br/"']);
end;

end.
