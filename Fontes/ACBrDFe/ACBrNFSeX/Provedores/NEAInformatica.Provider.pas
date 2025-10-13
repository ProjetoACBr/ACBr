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

unit NEAInformatica.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceNEAInformatica200 = class(TACBrNFSeXWebserviceSoap11)
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

  TACBrNFSeProviderNEAInformatica200 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrDFeException,
  NEAInformatica.GravarXml, NEAInformatica.LerXml;

{ TACBrNFSeProviderNEAInformatica200 }

procedure TACBrNFSeProviderNEAInformatica200.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.QuebradeLinha := '|';

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;
end;

function TACBrNFSeProviderNEAInformatica200.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_NEAInformatica200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderNEAInformatica200.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_NEAInformatica200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderNEAInformatica200.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceNEAInformatica200.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceNEAInformatica200 }

function TACBrNFSeXWebserviceNEAInformatica200.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:RecepcionarLoteRps>';
  Request := Request + '<EnviarLoteRpsEnvio>' + IncluirCDATA(AMSG) + '</EnviarLoteRpsEnvio>';
  Request := Request + '</nfse:RecepcionarLoteRps>';

  Result := Executar('', Request,
                     ['outputXML', 'RecepcionarLoteRpsResponse'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceNEAInformatica200.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:RecepcionarLoteRpsSincrono>';
  Request := Request + '<EnviarLoteRpsSincronoEnvio>' + IncluirCDATA(AMSG) + '</EnviarLoteRpsSincronoEnvio>';
  Request := Request + '</nfse:RecepcionarLoteRpsSincrono>';

  Result := Executar('', Request,
                     ['outputXML', 'RecepcionarLoteRpsSincronoResponse'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceNEAInformatica200.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:GerarNfse>';
  Request := Request + '<GerarNfseEnvio>' + IncluirCDATA(AMSG) + '</GerarNfseEnvio>';
  Request := Request + '</nfse:GerarNfse>';

  Result := Executar('', Request,
                     ['outputXML', 'GerarNfseResponse'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceNEAInformatica200.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarLoteRps>';
  Request := Request + '<ConsultarLoteRpsEnvio>' + IncluirCDATA(AMSG) + '</ConsultarLoteRpsEnvio>';
  Request := Request + '</nfse:ConsultarLoteRps>';

  Result := Executar('', Request,
                     ['outputXML', 'ConsultarLoteRpsResponse'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceNEAInformatica200.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfsePorFaixa>';
  Request := Request + '<ConsultarNfsePorFaixaEnvio>' + IncluirCDATA(AMSG) + '</ConsultarNfsePorFaixaEnvio>';
  Request := Request + '</nfse:ConsultarNfsePorFaixa>';

  Result := Executar('', Request,
                     ['outputXML', 'ConsultarNfsePorFaixaResponse'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceNEAInformatica200.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfsePorRps>';
  Request := Request + '<ConsultarNfsePorRpsEnvio>' + IncluirCDATA(AMSG) + '</ConsultarNfsePorRpsEnvio>';
  Request := Request + '</nfse:ConsultarNfsePorRps>';

  Result := Executar('', Request,
                     ['outputXML', 'ConsultarNfsePorRpsResponse'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceNEAInformatica200.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfseServicoPrestado>';
  Request := Request + '<ConsultarNfseServicoPrestadoEnvio>' + IncluirCDATA(AMSG) + '</ConsultarNfseServicoPrestadoEnvio>';
  Request := Request + '</nfse:ConsultarNfseServicoPrestado>';

  Result := Executar('', Request,
                     ['outputXML', 'ConsultarNfseServicoPrestadoResponse'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceNEAInformatica200.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfseServicoTomado>';
  Request := Request + '<ConsultarNfseServicoTomadoEnvio>' + IncluirCDATA(AMSG) + '</ConsultarNfseServicoTomadoEnvio>';
  Request := Request + '</nfse:ConsultarNfseServicoTomado>';

  Result := Executar('', Request,
                     ['outputXML', 'ConsultarNfseServicoTomadoResponse'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceNEAInformatica200.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:CancelarNfse>';
  Request := Request + '<CancelarNfseEnvio>' + IncluirCDATA(AMSG) + '</CancelarNfseEnvio>';
  Request := Request + '</nfse:CancelarNfse>';

  Result := Executar('', Request,
                     ['outputXML', 'CancelarNfseResponse'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceNEAInformatica200.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:SubstituirNfse>';
  Request := Request + '<SubstituirNfseEnvio>' + IncluirCDATA(AMSG) + '</SubstituirNfseEnvio>';
  Request := Request + '</nfse:SubstituirNfse>';

  Result := Executar('', Request,
                     ['outputXML', 'SubstituirNfseResponse'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

end.
