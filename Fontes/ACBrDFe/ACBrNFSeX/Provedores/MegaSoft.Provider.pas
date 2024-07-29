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

unit MegaSoft.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceMegaSoft200 = class(TACBrNFSeXWebserviceSoap11)
  public
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderMegaSoft200 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, MegaSoft.GravarXml, MegaSoft.LerXml;

{ TACBrNFSeProviderMegaSoft200 }

procedure TACBrNFSeProviderMegaSoft200.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    ModoEnvio := meUnitario;
    ConsultaNFSe := False;
    ImprimirOptanteSN := False;

    ServicosDisponibilizados.EnviarLoteAssincrono := False;
    ServicosDisponibilizados.EnviarLoteSincrono := False;
    ServicosDisponibilizados.ConsultarLote := False;
    ServicosDisponibilizados.ConsultarFaixaNfse := False;
    ServicosDisponibilizados.ConsultarServicoPrestado := False;
    ServicosDisponibilizados.ConsultarServicoTomado := False;
    ServicosDisponibilizados.CancelarNfse := False;
    ServicosDisponibilizados.SubstituirNfse := False;
  end;

  ConfigAssinar.RpsGerarNFSe := True;

  with ConfigWebServices do
  begin
    VersaoDados := '1.00';
    VersaoAtrib := '1.00';
  end;

  SetXmlNameSpace('http://megasoftarrecadanet.com.br/xsd/nfse_v01.xsd');

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');

  SetNomeXSD('***');

  with ConfigSchemas do
  begin
    GerarNFSe := 'nfse_v01.xsd';
    ConsultarNFSeRps := 'nfse_v01.xsd';
  end;
end;

function TACBrNFSeProviderMegaSoft200.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_MegaSoft200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderMegaSoft200.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_MegaSoft200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderMegaSoft200.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceMegaSoft200.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderMegaSoft200.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
var
  xXml: string;
  i, j: Integer;
begin
  xXml := Response.ArquivoEnvio;

  // Remove as tags Serie e Tipo ao realizar a consulta da NFS-e por Rps.
  case aMetodo of
    tmConsultarNFSePorRps:
      begin
        i := Pos('<Serie>', xXml);
        j := Pos('</IdentificacaoRps>', xXml);

        xXml := Copy(xXml, 1, i -1) + Copy(xXml, j, length(xXml));
        Response.ArquivoEnvio := xXml;
      end;
  else
    Response.ArquivoEnvio := xXml;
  end;

  inherited ValidarSchema(Response, aMetodo);
end;

{ TACBrNFSeXWebserviceMegaSoft200 }

function TACBrNFSeXWebserviceMegaSoft200.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:GerarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</ws:GerarNfseRequest>';

  Result := Executar('http://ws.megasoftarrecadanet.com.br/GerarNfse', Request,
                     ['outputXML', 'GerarNfseResposta'],
                     ['xmlns:ws="http://ws.megasoftarrecadanet.com.br"']);
end;

function TACBrNFSeXWebserviceMegaSoft200.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:ConsultarNfsePorRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</ws:ConsultarNfsePorRpsRequest>';

  Result := Executar('http://ws.megasoftarrecadanet.com.br/ConsultarNfsePorRps', Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
                     ['xmlns:ws="http://ws.megasoftarrecadanet.com.br"']);
end;

function TACBrNFSeXWebserviceMegaSoft200.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
  Result := RemoverIdentacao(Result);
end;

end.
