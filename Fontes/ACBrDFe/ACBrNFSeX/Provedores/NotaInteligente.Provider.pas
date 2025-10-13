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

unit NotaInteligente.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceNotaInteligente200 = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNamespace: string;
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;

    property Namespace: string read GetNamespace;
  end;

  TACBrNFSeProviderNotaInteligente200 = class (TACBrNFSeProviderABRASFv2)
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
  ACBrNFSeXNotasFiscais, NotaInteligente.GravarXml, NotaInteligente.LerXml;

{ TACBrNFSeProviderNotaInteligente200 }

procedure TACBrNFSeProviderNotaInteligente200.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    ModoEnvio := meLoteAssincrono;
    ConsultaNFSe := False;

    ServicosDisponibilizados.EnviarLoteSincrono := False;
    ServicosDisponibilizados.ConsultarRps := False;
    ServicosDisponibilizados.ConsultarFaixaNfse := False;
    ServicosDisponibilizados.ConsultarServicoPrestado := False;
    ServicosDisponibilizados.ConsultarServicoTomado := False;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
    RpsSubstituirNFSe := True;
  end;
end;

function TACBrNFSeProviderNotaInteligente200.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_NotaInteligente200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderNotaInteligente200.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_NotaInteligente200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderNotaInteligente200.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceNotaInteligente200.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceNotaInteligente200 }

function TACBrNFSeXWebserviceNotaInteligente200.GetNamespace: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 2 then
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Homologacao.NameSpace
  else
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Producao.NameSpace;

  Result := 'xmlns="' + Result + '"';
end;

function TACBrNFSeXWebserviceNotaInteligente200.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecepcionarLoteRps>';
  Request := Request + '<Body>' + XmlToStr(AMSG) + '</Body>';
  Request := Request + '</RecepcionarLoteRps>';

  Result := Executar('RecepcionarLoteRps', Request, [], [NameSpace]);
end;

function TACBrNFSeXWebserviceNotaInteligente200.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<GerarNfse>';
  Request := Request + '<Body>' + XmlToStr(AMSG) + '</Body>';
  Request := Request + '</GerarNfse>';

  Result := Executar('GerarNfse', Request, [], [NameSpace]);
end;

function TACBrNFSeXWebserviceNotaInteligente200.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarLoteRps>';
  Request := Request + '<Body>' + XmlToStr(AMSG) + '</Body>';
  Request := Request + '</ConsultarLoteRps>';

  Result := Executar('ConsultarLoteRps', Request, [], [NameSpace]);
end;

function TACBrNFSeXWebserviceNotaInteligente200.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<CancelarNfse>';
  Request := Request + '<Body>' + XmlToStr(AMSG) + '</Body>';
  Request := Request + '</CancelarNfse>';

  Result := Executar('CancelarNfse', Request, [], [NameSpace]);
end;

function TACBrNFSeXWebserviceNotaInteligente200.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<SubstituirNfse>';
  Request := Request + '<Body>' + XmlToStr(AMSG) + '</Body>';
  Request := Request + '</SubstituirNfse>';

  Result := Executar('SubstituirNfse', Request, [], [NameSpace]);
end;

function TACBrNFSeXWebserviceNotaInteligente200.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := RemoverIdentacao(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
end;

end.
