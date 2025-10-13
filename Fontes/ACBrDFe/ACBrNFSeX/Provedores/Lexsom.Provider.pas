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

unit Lexsom.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceLexsom = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderLexsom = class (TACBrNFSeProviderABRASFv1)
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
  Lexsom.GravarXml, Lexsom.LerXml;

{ TACBrNFSeProviderLexsom }

procedure TACBrNFSeProviderLexsom.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
    Identificador := 'id';
  end;

  with ConfigAssinar do
  begin
    LoteRps := True;
    CancelarNFSe := True;
  end;
end;

function TACBrNFSeProviderLexsom.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Lexsom.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderLexsom.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Lexsom.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderLexsom.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceLexsom.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceLexsom }

function TACBrNFSeXWebserviceLexsom.Recepcionar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecebeLoteRPS xmlns="http://tempuri.org/">';
  Request := Request + '<xml>' + AMSG + '</xml>';
  Request := Request + '</RecebeLoteRPS>';

  Result := Executar('http://tempuri.org/RecebeLoteRPS', Request,
                     ['RecebeLoteRPSResult', 'EnviarLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceLexsom.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarLoteRPS xmlns="http://tempuri.org/">';
  Request := Request + '<xml>' + AMSG + '</xml>';
  Request := Request + '</ConsultarLoteRPS>';

  Result := Executar('http://tempuri.org/ConsultarLoteRPS', Request,
                     ['ConsultarLoteRPSResult', 'ConsultarLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceLexsom.ConsultarSituacao(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarSituacaoLoteRPS xmlns="http://tempuri.org/">';
  Request := Request + '<xml>' + AMSG + '</xml>';
  Request := Request + '</ConsultarSituacaoLoteRPS>';

  Result := Executar('http://tempuri.org/ConsultarSituacaoLoteRPS', Request,
                     ['ConsultarSituacaoLoteRPSResult', 'ConsultarSituacaoLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceLexsom.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNFSEPorRPS xmlns="http://tempuri.org/">';
  Request := Request + '<xml>' + AMSG + '</xml>';
  Request := Request + '</ConsultarNFSEPorRPS>';

  Result := Executar('http://tempuri.org/ConsultarNFSEPorRPS', Request,
                     ['ConsultarNFSEPorRPSResult', 'ConsultarNfseRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceLexsom.ConsultarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultaNFSE xmlns="http://tempuri.org/">';
  Request := Request + '<xml>' + AMSG + '</xml>';
  Request := Request + '</ConsultaNFSE>';

  Result := Executar('http://tempuri.org/ConsultaNFSE', Request,
                     ['ConsultaNFSEResult', 'ConsultarNfseResposta'],
                     []);
end;

function TACBrNFSeXWebserviceLexsom.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<CancelamentoNFSE xmlns="http://tempuri.org/">';
  Request := Request + '<xml>' + AMSG + '</xml>';
  Request := Request + '</CancelamentoNFSE>';

  Result := Executar('http://tempuri.org/CancelamentoNFSE', Request,
                     ['CancelamentoNFSEResult', 'CancelarNfseResposta'],
                     []);
end;

end.
