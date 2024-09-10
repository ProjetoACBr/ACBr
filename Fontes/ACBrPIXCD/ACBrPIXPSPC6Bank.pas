{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{ - Cristian Carvalho                                                          }
{ - Sidnei Alves                                                               }
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

(*

  Documenta��o
  https://developers.c6bank.com.br/pix-api

*) 

{$I ACBr.inc}

unit ACBrPIXPSPC6Bank;

interface

uses
  Classes, SysUtils,
  {$IFDEF RTL230_UP}ACBrBase,{$ENDIF RTL230_UP}
  ACBrPIXCD, ACBrOpenSSLUtils;

const
  cC6URLSandbox      = 'https://baas-api-sandbox.c6bank.info';
  cC6URLProducao     = 'https://baas-api.c6bank.info';
  cC6PathAuthToken   = '/v1/auth';
  cC6PathAPIPix      = '/v2/pix';
  cC6URLAuthTeste    = cC6URLSandbox + cC6PathAuthToken;
  cC6URLAuthProducao = cC6URLProducao + cC6PathAuthToken;

type

  { TACBrPSPC6Bank }

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrPSPC6Bank = class(TACBrPSPCertificate)
  private
    procedure QuandoReceberRespostaEndPoint(const aEndPoint, aURL, aMethod: String; var aResultCode: Integer; var aRespostaHttp: AnsiString);
  protected
    function ObterURLAmbiente(const aAmbiente: TACBrPixCDAmbiente): String; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Autenticar; override;
  published
    property ClientID;
    property ClientSecret;
  end;

implementation

uses
  synautil, blcksock, DateUtils, ACBrJSON, ACBrUtil.Strings;

{ TACBrPSPC6Bank }

procedure TACBrPSPC6Bank.QuandoReceberRespostaEndPoint(const aEndPoint, aURL, aMethod: String; var aResultCode: Integer; var aRespostaHttp: AnsiString);
begin
  if (UpperCase(AMethod) = ChttpMethodPOST) and (AEndPoint = cEndPointCob) and (aResultCode = HTTP_OK) then
    AResultCode := HTTP_CREATED;

  if (UpperCase(AMethod) = ChttpMethodPUT) and (AEndPoint = cEndPointCob) and (aResultCode = HTTP_OK) then
    AResultCode := HTTP_CREATED;
end;

function TACBrPSPC6Bank.ObterURLAmbiente(const aAmbiente: TACBrPixCDAmbiente): String;
begin
  if (aAmbiente = ambProducao) then
    Result := cC6URLProducao + cC6PathAPIPix
  else
    Result := cC6URLSandbox + cC6PathAPIPix;
end;

constructor TACBrPSPC6Bank.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fpQuandoReceberRespostaEndPoint := QuandoReceberRespostaEndPoint;
end;

procedure TACBrPSPC6Bank.Autenticar;
var
  wURL, Body: String;
  wRespostaHttp: AnsiString;
  wResultCode, sec: Integer;
  js: TACBrJSONObject;
  qp: TACBrQueryParams;
begin
  LimparHTTP;

  if (ACBrPixCD.Ambiente = ambProducao) then
    wURL := cC6URLAuthProducao
  else
    wURL := cC6URLAuthTeste;

  qp := TACBrQueryParams.Create;
  try
    qp.Values['grant_type'] := 'client_credentials';
    //qp.Values['scope'] := ScopesToString(Scopes);
    Body := qp.AsURL;
    WriteStrToStream(Http.Document, Body);
    Http.MimeType := CContentTypeApplicationWwwFormUrlEncoded;
  finally
    qp.Free;
  end;

  Http.UserName := ClientID;
  Http.Password := ClientSecret;
  http.Sock.SSL.SSLType := LT_TLSv1_2;
  Http.Protocol := '1.1';
  TransmitirHttp(ChttpMethodPOST, wURL, wResultCode, wRespostaHttp);

  if (wResultCode = HTTP_OK) then
  begin
    js := TACBrJSONObject.Parse(wRespostaHttp);
    try
      fpToken := js.AsString['access_token'];
      sec := js.AsInteger['expires_in'];
    finally
      js.Free;
    end;

    if (Trim(fpToken) = EmptyStr) then
      DispararExcecao(EACBrPixHttpException.Create(ACBrStr(sErroAutenticacao)));

    fpValidadeToken := IncSecond(Now, sec);
    fpAutenticado := True;
  end
  else
    DispararExcecao(EACBrPixHttpException.CreateFmt(sErroHttp, [Http.ResultCode, ChttpMethodPOST, wURL]));
end;

end.

