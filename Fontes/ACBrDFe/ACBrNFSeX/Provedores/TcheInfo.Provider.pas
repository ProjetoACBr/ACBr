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

unit TcheInfo.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceTcheInfo204 = class(TACBrNFSeXWebserviceSoap11)
  public
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderTcheInfo204 = class (TACBrNFSeProviderABRASFv2)
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
  ACBrNFSeXNotasFiscais, TcheInfo.GravarXml, TcheInfo.LerXml;

{ TACBrNFSeProviderTcheInfo204 }

procedure TACBrNFSeProviderTcheInfo204.Configuracao;
var
  CodigoIBGE: string;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := '';
    UseCertificateHTTP := False;
    ModoEnvio := meUnitario;
    ConsultaNFSe := False;

    Autenticacao.RequerLogin := True;

    ServicosDisponibilizados.EnviarLoteAssincrono := False;
    ServicosDisponibilizados.EnviarLoteSincrono := False;
    ServicosDisponibilizados.ConsultarLote := False;
    ServicosDisponibilizados.ConsultarFaixaNfse := False;
    ServicosDisponibilizados.ConsultarServicoPrestado := False;
    ServicosDisponibilizados.ConsultarServicoTomado := False;
    ServicosDisponibilizados.SubstituirNfse := False;
  end;

  with ConfigAssinar do
  begin
    CancelarNFSe := True;
    RpsGerarNFSe := True;
    IncluirURI := False;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.04';
    VersaoAtrib := '2.04';
  end;

  with ConfigMsgDados do
  begin
    GerarPrestadorLoteRps := True;

    if TACBrNFSeX(FAOwner).Configuracoes.WebServices.AmbienteCodigo = 1 then
      CodigoIBGE := IntToStr(TACBrNFSeX(FAOwner).Configuracoes.Geral.CodigoMunicipio)
    else
      CodigoIBGE := '9999999';

    DadosCabecalho := '<cabecalho versao="1.00" xmlns="http://www.abrasf.org.br/nfse.xsd">' +
                      '<versaoDados>2.04</versaoDados>' +
                      '<CodigoIBGE>' + CodigoIBGE + '</CodigoIBGE>' +
                      '<CpfCnpj>' + TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.WSUser + '</CpfCnpj>' +
                      '<Token>' + TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.WSSenha + '</Token>' +
                      '</cabecalho>';
  end;
end;

function TACBrNFSeProviderTcheInfo204.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_TcheInfo204.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTcheInfo204.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_TcheInfo204.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTcheInfo204.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceTcheInfo204.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceTcheInfo204 }

function TACBrNFSeXWebserviceTcheInfo204.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:NfseWebService.GERARNFSE>';
  Request := Request + '<nfse:Nfsecabecmsg>' + XmlToStr(ACabecalho) + '</nfse:Nfsecabecmsg>';
  Request := Request + '<nfse:Nfsedadosmsg>' + XmlToStr(AMSG) + '</nfse:Nfsedadosmsg>';
  Request := Request + '</nfse:NfseWebService.GERARNFSE>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsdaction/ANFSEWEBSERVICE.GERARNFSE',
                     Request,
                     ['Outputxml', 'GerarNfseResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/nfse.xsd"']);
end;

function TACBrNFSeXWebserviceTcheInfo204.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
end;

function TACBrNFSeXWebserviceTcheInfo204.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:NfseWebService.CONSULTARNFSERPS>';
  Request := Request + '<nfse:Nfsecabecmsg>' + XmlToStr(ACabecalho) + '</nfse:Nfsecabecmsg>';
  Request := Request + '<nfse:Nfsedadosmsg>' + XmlToStr(AMSG) + '</nfse:Nfsedadosmsg>';
  Request := Request + '</nfse:NfseWebService.CONSULTARNFSERPS>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsdaction/ANFSEWEBSERVICE.CONSULTARNFSERPS',
                     Request,
                     ['Outputxml', 'ConsultarNfseRpsResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/nfse.xsd"']);
end;

function TACBrNFSeXWebserviceTcheInfo204.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:NfseWebService.CANCELARNFSE>';
  Request := Request + '<nfse:Nfsecabecmsg>' + XmlToStr(ACabecalho) + '</nfse:Nfsecabecmsg>';
  Request := Request + '<nfse:Nfsedadosmsg>' + XmlToStr(AMSG) + '</nfse:Nfsedadosmsg>';
  Request := Request + '</nfse:NfseWebService.CANCELARNFSE>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsdaction/ANFSEWEBSERVICE.CANCELARNFSE',
                     Request,
                     ['Outputxml', 'CancelarNfseResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/nfse.xsd"']);
end;

end.
