{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit Kalana.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceKalana = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetChave: string;
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;

    property Chave: string read GetChave;
  end;

  TACBrNFSeProviderKalana = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrNFSeXConfiguracoes,
  Kalana.GravarXml, Kalana.LerXml;

{ TACBrNFSeProviderKalana }

procedure TACBrNFSeProviderKalana.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;

    Autenticacao.RequerCertificado := False;
    Autenticacao.RequerChaveAcesso := True;
  end;
end;

function TACBrNFSeProviderKalana.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Kalana.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderKalana.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Kalana.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderKalana.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceKalana.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceKalana }

function TACBrNFSeXWebserviceKalana.GetChave: string;
begin
  Result := TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente.WSChaveAcesso
end;

function TACBrNFSeXWebserviceKalana.Recepcionar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:EnviarLoteRpsEnvio>';
  Request := Request + '<Chave>' + Chave + '</Chave>';
  Request := Request + SeparaDados(AMSG, 'EnviarLoteRpsEnvio');
  Request := Request + '</wsn:EnviarLoteRpsEnvio>';

  Result := Executar('', Request,
                     ['EnviarLoteRpsResposta'],
                     ['xmlns:wsn="https://www.kalana.com.br/wsnfe"']);
end;

function TACBrNFSeXWebserviceKalana.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:ConsultarLoteRpsEnvio>';
  Request := Request + '<Chave>' + Chave + '</Chave>';
  Request := Request + SeparaDados(AMSG, 'ConsultarLoteRpsEnvio');
  Request := Request + '</wsn:ConsultarLoteRpsEnvio>';

  Result := Executar('', Request,
                     ['ConsultarLoteRpsResposta'],
                     ['xmlns:wsn="https://www.kalana.com.br/wsnfe"']);
end;

function TACBrNFSeXWebserviceKalana.ConsultarSituacao(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:ConsultarSituacaoLoteRpsEnvio>';
  Request := Request + SeparaDados(AMSG, 'ConsultarSituacaoLoteRpsEnvio');
  Request := Request + '<Chave>' + Chave + '</Chave>';
  Request := Request + '</wsn:ConsultarSituacaoLoteRpsEnvio>';

  Result := Executar('', Request,
                     ['ConsultarSituacaoLoteRpsResposta'],
                     ['xmlns:wsn="https://www.kalana.com.br/wsnfe"']);
end;

function TACBrNFSeXWebserviceKalana.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:ConsultarNfsePorRpsEnvio>';
  Request := Request + '<Chave>' + Chave + '</Chave>';
  Request := Request + SeparaDados(AMSG, 'ConsultarNfseRpsEnvio');
  Request := Request + '</wsn:ConsultarNfsePorRpsEnvio>';

  Result := Executar('', Request,
                     ['ConsultarNfsePorRpsResposta'],
                     ['xmlns:wsn="https://www.kalana.com.br/wsnfe"']);
end;

function TACBrNFSeXWebserviceKalana.ConsultarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:ConsultarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</wsn:ConsultarNfseRequest>';

  Result := Executar('', Request,
                     ['outputXML', 'ConsultarNfseResposta'],
                     []);
end;

function TACBrNFSeXWebserviceKalana.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:CancelarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</wsn:CancelarNfseRequest>';

  Result := Executar('', Request,
                     ['outputXML', 'CancelarNfseResposta'],
                     []);
end;

function TACBrNFSeXWebserviceKalana.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
end;

end.
