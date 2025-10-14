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

unit Tributus.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceTributus204 = class(TACBrNFSeXWebserviceSoap11)
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

  TACBrNFSeProviderTributus204 = class (TACBrNFSeProviderABRASFv2)
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
  ACBrNFSeXNotasFiscais, Tributus.GravarXml, Tributus.LerXml;

{ TACBrNFSeProviderTributus204 }

procedure TACBrNFSeProviderTributus204.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.Identificador := 'id';

  ConfigGeral.Autenticacao.RequerChaveAutorizacao := True;

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
    VersaoDados := '2.04';
    VersaoAtrib := '2.04';
  end;

  with ConfigMsgDados do
  begin
    DadosCabecalho := GetCabecalho('');
    GerarPrestadorLoteRps := True;
  end;
end;

function TACBrNFSeProviderTributus204.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Tributus204.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTributus204.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Tributus204.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTributus204.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);
  URL := URL + '?tokenAuth=' +
    trim(TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.WSChaveAutoriz);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceTributus204.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceTributus204 }

function TACBrNFSeXWebserviceTributus204.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<api:RecepcionarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + IncluirCDATA(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</api:RecepcionarLoteRpsRequest>';

  Result := Executar('https://tributosmunicipais.com.br/nfse/api/RecepcionarLoteRps', Request,
                     ['outputXML', 'EnviarLoteRpsResposta'],
                     ['xmlns:api="https://tributosmunicipais.com.br/nfse/api/"']);
end;

function TACBrNFSeXWebserviceTributus204.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<api:RecepcionarLoteRpsSincronoRequest>';
  Request := Request + '<nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + IncluirCDATA(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</api:RecepcionarLoteRpsSincronoRequest>';

  Result := Executar('https://tributosmunicipais.com.br/nfse/api/RecepcionarLoteRpsSincrono', Request,
                     ['outputXML', 'EnviarLoteRpsSincronoResposta'],
                     ['xmlns:api="https://tributosmunicipais.com.br/nfse/api/"']);
end;

function TACBrNFSeXWebserviceTributus204.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<api:GerarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + IncluirCDATA(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</api:GerarNfseRequest>';

  Result := Executar('https://tributosmunicipais.com.br/nfse/api/GerarNfse', Request,
                     ['outputXML', 'GerarNfseResposta'],
                     ['xmlns:api="https://tributosmunicipais.com.br/nfse/api/"']);
end;

function TACBrNFSeXWebserviceTributus204.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<api:ConsultarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + IncluirCDATA(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</api:ConsultarLoteRpsRequest>';

  Result := Executar('https://tributosmunicipais.com.br/nfse/api/ConsultarLoteRps', Request,
                     ['outputXML', 'ConsultarLoteRpsResposta'],
                     ['xmlns:api="https://tributosmunicipais.com.br/nfse/api/"',
                      'xmlns:xd="http://www.w3.org/2000/09/xmldsig#"']);
end;

function TACBrNFSeXWebserviceTributus204.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<api:ConsultarNfsePorFaixaRequest>';
  Request := Request + '<nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + IncluirCDATA(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</api:ConsultarNfsePorFaixaRequest>';

  Result := Executar('https://tributosmunicipais.com.br/nfse/api/ConsultarNfsePorFaixa', Request,
                     ['outputXML', 'ConsultarNfseFaixaResposta'],
                     ['xmlns:api="https://tributosmunicipais.com.br/nfse/api/"',
                      'xmlns:xd="http://www.w3.org/2000/09/xmldsig#"']);
end;

function TACBrNFSeXWebserviceTributus204.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<api:ConsultarNfsePorRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + IncluirCDATA(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</api:ConsultarNfsePorRpsRequest>';

  Result := Executar('https://tributosmunicipais.com.br/nfse/api/ConsultarNfsePorRps', Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
                     ['xmlns:api="https://tributosmunicipais.com.br/nfse/api/"',
                      'xmlns:xd="http://www.w3.org/2000/09/xmldsig#"']);
end;

function TACBrNFSeXWebserviceTributus204.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<api:ConsultarNfseServicoPrestadoRequest>';
  Request := Request + '<nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + IncluirCDATA(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</api:ConsultarNfseServicoPrestadoRequest>';

  Result := Executar('https://tributosmunicipais.com.br/nfse/api/ConsultarNfseServicoPrestado', Request,
                     ['outputXML', 'ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns:api="https://tributosmunicipais.com.br/nfse/api/"',
                      'xmlns:xd="http://www.w3.org/2000/09/xmldsig#"']);
end;

function TACBrNFSeXWebserviceTributus204.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<api:ConsultarNfseServicoTomadoRequest>';
  Request := Request + '<nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + IncluirCDATA(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</api:ConsultarNfseServicoTomadoRequest>';

  Result := Executar('https://tributosmunicipais.com.br/nfse/api/ConsultarNfseServicoTomado', Request,
                     ['outputXML', 'ConsultarNfseServicoTomadoResposta'],
                     ['xmlns:api="https://tributosmunicipais.com.br/nfse/api/"',
                      'xmlns:xd="http://www.w3.org/2000/09/xmldsig#"']);
end;

function TACBrNFSeXWebserviceTributus204.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<api:CancelarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + IncluirCDATA(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</api:CancelarNfseRequest>';

  Result := Executar('https://tributosmunicipais.com.br/nfse/api/CancelarNfse', Request,
                     ['outputXML', 'CancelarNfseResposta'],
                     ['xmlns:api="https://tributosmunicipais.com.br/nfse/api/"',
                      'xmlns:xd="http://www.w3.org/2000/09/xmldsig#"']);
end;

function TACBrNFSeXWebserviceTributus204.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<api:SubstituirNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + IncluirCDATA(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</api:SubstituirNfseRequest>';

  Result := Executar('https://tributosmunicipais.com.br/nfse/api/SubstituirNfse', Request,
                     ['outputXML', 'SubstituirNfseResposta'],
                     ['xmlns:api="https://tributosmunicipais.com.br/nfse/api/"',
                      'xmlns:xd="http://www.w3.org/2000/09/xmldsig#"']);
end;

end.
