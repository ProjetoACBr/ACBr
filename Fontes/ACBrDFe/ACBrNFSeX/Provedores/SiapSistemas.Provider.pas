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

unit SiapSistemas.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml, ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceSiapSistemas203 = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNamespace: string;
    function GetSoapAction: string;
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(const ACabecalho, AMSG: String): string; override;
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    property Namespace: string read GetNamespace;
    property SoapAction: string read GetSoapAction;
  end;

  TACBrNFSeProviderSiapSistemas203 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;
  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, SiapSistemas.GravarXml, SiapSistemas.LerXml;

{ TACBrNFSeProviderSiapSistemas203 }

procedure TACBrNFSeProviderSiapSistemas203.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.ConsultaNFSe := False;

  with ConfigGeral.ServicosDisponibilizados do
  begin
    ConsultarRps := False;
    ConsultarFaixaNfse := False;
    ConsultarServicoPrestado := False;
    ConsultarServicoTomado := False;
    SubstituirNfse := False;
  end;

  ConfigAssinar.IncluirURI := False;

  ConfigWebServices.AtribVerLote := '';

  with ConfigMsgDados do
  begin
    LoteRps.DocElemento := 'nfse:Enviarloterpsenvio';
    ConsultarLote.DocElemento := 'nfse:Consultarloterpsenvio';
    CancelarNFSe.DocElemento := 'nfse:Cancelarnfseenvio';
    GerarNFSe.DocElemento := 'nfse:Gerarnfseenvio';
    LoteRpsSincrono.DocElemento := 'nfse:Enviarloterpssincronoenvio';

    DadosCabecalho := '<nfse:Cabecalho xmlns="http://www.abrasf.org.br/nfse.xsd">' +
                        '<Versao>1.0</Versao>' +
                        '<versaoDados>2.03</versaoDados>' +
                      '</nfse:Cabecalho>';

  end;

  // Provedor ainda n�o disponibilizou os schemas.
  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderSiapSistemas203.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SiapSistemas203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSiapSistemas203.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SiapSistemas203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSiapSistemas203.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceSiapSistemas203.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderSiapSistemas203.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
  Prestador: string;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  with Params do
  begin
    if Response.ModoEnvio in [meLoteAssincrono, meLoteSincrono] then
    begin
      Prestador := '<' + Prefixo2 + 'Cnpj>' +
                     GetCpfCnpj(Emitente.CNPJ, Prefixo2) +
                   '</' + Prefixo2 + 'Cnpj>' +
                   GetInscMunic(Emitente.InscMun, Prefixo2);

      Response.ArquivoEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                             '<' + Prefixo + 'LoteRps' + NameSpace2 + '>' +
                               '<' + Prefixo2 + 'NumeroLote>' +
                                  Response.NumeroLote +
                               '</' + Prefixo2 + 'NumeroLote>' +
                               Prestador +
                               '<' + Prefixo2 + 'QuantidadeRps>' +
                                  IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count) +
                               '</' + Prefixo2 + 'QuantidadeRps>' +
                               '<' + Prefixo2 + 'ListaRps>' +
                                  Xml +
                               '</' + Prefixo2 + 'ListaRps>' +

                               '<' + Prefixo2 + 'Id>' +
                                  'Lote_' + Response.NumeroLote +
                               '</' + Prefixo2 + 'Id>' +
                               '<' + Prefixo2 + 'Versao>' +
                                  ConfigWebServices.VersaoDados +
                               '</' + Prefixo2 + 'Versao>' +

                             '</' + Prefixo + 'LoteRps>' +
                           '</' + Prefixo + TagEnvio + '>';
    end
    else
      Response.ArquivoEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                              Xml +
                           '</' + Prefixo + TagEnvio + '>';
  end;
end;

{ TACBrNFSeXWebserviceSiapSistemas203 }

function TACBrNFSeXWebserviceSiapSistemas203.GetNamespace: string;
begin
  Result := 'xmlns:nfse="' +
    TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.Params.ValorParametro('AliasCidade') +
    'RPS"';
end;

function TACBrNFSeXWebserviceSiapSistemas203.GetSoapAction: string;
begin
  Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.Params.ValorParametro('AliasCidade') +
    'RPSaction/';
end;

function TACBrNFSeXWebserviceSiapSistemas203.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:RecepcionarLoteRps.Execute>';
  Request := Request + ACabecalho;
  Request := Request + AMSG;
  Request := Request + '</nfse:RecepcionarLoteRps.Execute>';

  Result := Executar(SoapAction + 'ARECEPCIONARLOTERPS.Execute', Request,
                     ['Enviarloterpsresposta'], [NameSpace]);
end;

function TACBrNFSeXWebserviceSiapSistemas203.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:RecepcionarLoteRpsSincrono.Execute>';
  Request := Request + ACabecalho;
  Request := Request + AMSG;
  Request := Request + '</nfse:RecepcionarLoteRpsSincrono.Execute>';

  Result := Executar(SoapAction + 'ARECEPCIONARLOTERPSSINCRONO.Execute', Request,
                     ['Enviarloterpssincronoresposta'], [NameSpace]);
end;

function TACBrNFSeXWebserviceSiapSistemas203.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:GerarNfse.Execute>';
  Request := Request + ACabecalho;
  Request := Request + AMSG;
  Request := Request + '</nfse:GerarNfse.Execute>';

  Result := Executar(SoapAction + 'AGERARNFSE.Execute', Request,
                     ['Gerarnfseresposta'], [NameSpace]);
end;

function TACBrNFSeXWebserviceSiapSistemas203.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarLoteRps.Execute>';
  Request := Request + ACabecalho;
  Request := Request + AMSG;
  Request := Request + '</nfse:ConsultarLoteRps.Execute>';

  Result := Executar(SoapAction + 'ACONSULTARLOTERPS.Execute', Request,
                     ['Consultarloterpsresposta'], [NameSpace]);
end;

function TACBrNFSeXWebserviceSiapSistemas203.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:CancelarNfse.Execute>';
  Request := Request + ACabecalho;
  Request := Request + AMSG;
  Request := Request + '</nfse:CancelarNfse.Execute>';

  Result := Executar(SoapAction + 'ACANCELARNFSE.Execute', Request,
                     ['Cancelarnfseresposta'], [NameSpace]);
end;

end.
