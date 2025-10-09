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

unit geNFe.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebservicegeNFe = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProvidergeNFe = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrDFeException,
  ACBrDFe.Conversao,
  geNFe.GravarXml, geNFe.LerXml;

{ TACBrNFSeProvidergeNFe }

procedure TACBrNFSeProvidergeNFe.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := 'id';
    UseCertificateHTTP := False;
  end;

  with ConfigAssinar do
  begin
    LoteRps := True;
    ConsultarSituacao := True;
    ConsultarLote := True;
    ConsultarNFSeRps := True;
    CancelarNFSe := True;
  end;
end;

function TACBrNFSeProvidergeNFe.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_geNFe.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProvidergeNFe.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_geNFe.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProvidergeNFe.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebservicegeNFe.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebservicegeNFe }

function TACBrNFSeXWebservicegeNFe.Recepcionar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:RecepcionarLoteRPSRequest xmlns:ns1="urn:NFSE">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</ns1:RecepcionarLoteRPSRequest>';

  Result := Executar('urn:NFSE#RecepcionarLoteRPS', Request,
                     ['outputXML', 'EnviarLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebservicegeNFe.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:ConsultarLoteRpsRequest xmlns:ns1="urn:NFSE">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</ns1:ConsultarLoteRpsRequest>';

  Result := Executar('urn:NFSE#ConsultarLoteRps', Request,
                     ['outputXML', 'ConsultarLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebservicegeNFe.ConsultarSituacao(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:ConsultarSituacaoLoteRpsRequest xmlns:ns1="urn:NFSE">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</ns1:ConsultarSituacaoLoteRpsRequest>';

  Result := Executar('urn:NFSE#ConsultarSituacaoLoteRps', Request,
                     ['outputXML', 'ConsultarSituacaoLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebservicegeNFe.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:ConsultarNfseRpsRequest xmlns:ns1="urn:NFSE">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</ns1:ConsultarNfseRpsRequest>';

  Result := Executar('urn:NFSE#ConsultarNfseRps', Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
                     []);
end;

function TACBrNFSeXWebservicegeNFe.ConsultarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:ConsultarNfseRequest xmlns:ns1="urn:NFSE">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</ns1:ConsultarNfseRequest>';

  Result := Executar('urn:NFSE#ConsultarNfse', Request,
                     ['outputXML', 'ConsultarNfseResposta'],
                     []);
end;

function TACBrNFSeXWebservicegeNFe.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:CancelarNfseRequest xmlns:ns1="urn:NFSE">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</ns1:CancelarNfseRequest>';

  Result := Executar('urn:NFSE#CancelarNfse', Request,
                     ['outputXML', 'CancelarNfseResposta'],
                     []);
end;

end.
