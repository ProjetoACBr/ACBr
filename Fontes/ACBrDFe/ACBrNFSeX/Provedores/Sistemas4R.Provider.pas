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

unit Sistemas4R.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebservice4R200 = class(TACBrNFSeXWebserviceSoap11)

  public
    function RecepcionarSincrono(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProvider4R200 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrDFeException, Sistemas4R.GravarXml, Sistemas4R.LerXml;

{ TACBrNFSeXWebservice4R200 }

function TACBrNFSeXWebservice4R200.RecepcionarSincrono(const ACabecalho, AMSG: String): string;
var
  Request: string;
  xTag, xSoap: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
  begin
    xTag := 'RecepcionarLoteRpsSincrono.Execute';
    xSoap := 'Abrasf2action/ARECEPCIONARLOTERPSSINCRONO.Execute';
  end
  else
  begin
    xTag := 'hRecepcionarLoteRpsSincrono.Execute';
    xSoap := 'Abrasf2action/AHRECEPCIONARLOTERPSSINCRONO.Execute';
  end;

  FPMsgOrig := AMSG;

  Request := '<' + xTag + ' xmlns="Abrasf2">';
  Request := Request + '<Entrada>' + XmlToStr(AMSG) + '</Entrada>';
  Request := Request + '</' + xTag + '>';

  Result := Executar(xSoap, Request, ['Resposta', 'EnviarLoteRpsSincronoResposta'], []);
end;

function TACBrNFSeXWebservice4R200.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
  xTag, xSoap: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
  begin
    xTag := 'ConsultarLoteRps.Execute';
    xSoap := 'AbrasfNFSeactionACONSULTARLOTERPS.Execute';
  end
  else
  begin
    xTag := 'hConsultarLoteRps.Execute';
    xSoap := 'AbrasfNFSeactionAHCONSULTARLOTERPS.Execute';
  end;

  FPMsgOrig := AMSG;

  Request := '<' + xTag + ' xmlns="AbrasfNFSe">';
  Request := Request + '<Entrada>' + XmlToStr(AMSG) + '</Entrada>';
  Request := Request + '</' + xTag + '>';

  Result := Executar(xSoap, Request, ['Resposta', 'ConsultarLoteRpsResposta'], []);
end;

function TACBrNFSeXWebservice4R200.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
  xTag, xSoap: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
  begin
    xTag := 'ConsultarNfsePorRps.Execute';
    xSoap := 'Abrasf2action/ACONSULTARNFSEPORRPS.Execute';
  end
  else
  begin
    xTag := 'hConsultarNfsePorRps.Execute';
    xSoap := 'Abrasf2action/AHCONSULTARNFSEPORRPS.Execute';
  end;

  FPMsgOrig := AMSG;

  Request := '<' + xTag + ' xmlns="Abrasf2">';
  Request := Request + '<Entrada>' + XmlToStr(AMSG) + '</Entrada>';
  Request := Request + '</' + xTag + '>';

  Result := Executar(xSoap, Request, ['Resposta', 'ConsultarNfseRpsResposta'], []);
end;

function TACBrNFSeXWebservice4R200.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
  xTag, xSoap: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
  begin
    xTag := 'CancelarNfse.Execute';
    xSoap := 'Abrasf2action/ACANCELARNFSE.Execute';
  end
  else
  begin
    xTag := 'hCancelarNfse.Execute';
    xSoap := 'Abrasf2action/AHCANCELARNFSE.Execute';
  end;

  FPMsgOrig := AMSG;

  Request := '<' + xTag + ' xmlns="Abrasf2">';
  Request := Request + '<Entrada>' + XmlToStr(AMSG) + '</Entrada>';
  Request := Request + '</' + xTag + '>';

  Result := Executar(xSoap, Request, ['Resposta', 'CancelarNfseResposta'], []);
end;

function TACBrNFSeXWebservice4R200.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := RemoverCaracteresDesnecessarios(Result);
  Result := ParseText(Result);
  Result := StringReplace(Result, '&amp;', '&', [rfReplaceAll]);
  Result := RemoverIdentacao(Result);
end;

{ TACBrNFSeProvider4R200 }

procedure TACBrNFSeProvider4R200.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    QuebradeLinha := '&lt;br&gt;';
    ConsultaNFSe := False;

    ServicosDisponibilizados.EnviarLoteAssincrono := False;
    ServicosDisponibilizados.EnviarUnitario := False;
    ServicosDisponibilizados.ConsultarFaixaNfse := False;
    ServicosDisponibilizados.ConsultarServicoPrestado := False;
    ServicosDisponibilizados.ConsultarServicoTomado := False;
    ServicosDisponibilizados.SubstituirNfse := False;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
  end;

  with ConfigMsgDados.XmlRps do
  begin
    InfElemento := 'Rps';
    DocElemento := 'Rps';
  end;
end;

function TACBrNFSeProvider4R200.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Sistemas4R200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProvider4R200.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Sistemas4R200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProvider4R200.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebservice4R200.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

end.
