{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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
  https://developers.sicoob.com.br

*)

{$I ACBr.inc}

unit ACBrPIXPSPSicoob;

interface

uses
  Classes, SysUtils,
  {$IFDEF RTL230_UP}ACBrBase,{$ENDIF RTL230_UP}
  ACBrPIXCD, ACBrOpenSSLUtils;

const
  cSicoobURLSandbox      = 'https://sandbox.sicoob.com.br/sicoob/sandbox';
  cSicoobURLProducao     = 'https://api.sicoob.com.br';
  cSicoobURLAuth         = 'https://auth.sicoob.com.br';
  cSicoobPathAuthToken   = '/auth/realms/cooperado/protocol/openid-connect/token';
  cSicoobPathAPIPix      = '/pix/api/v2';
  cSicoobURLAuthProducao = cSicoobURLAuth+cSicoobPathAuthToken;

resourcestring
  sErroTokenSandboxNaoInformado = 'Access Token para o ambiente Sandbox n�o foi informado!';

type

  { TACBrPSPSicoob }

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrPSPSicoob = class(TACBrPSPCertificate)
  private
    fSandboxStatusCode: String;
    fTokenSandbox : String;
    fxCorrelationID: String;
    fArquivoCertificado: String;
    fArquivoChavePrivada: String;
    fQuandoNecessitarCredenciais: TACBrQuandoNecessitarCredencial;

    procedure QuandoReceberRespostaEndPoint(const AEndPoint, AURL, AMethod: String;
      var AResultCode: Integer; var RespostaHttp: AnsiString);
  protected
    function ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String; override;
    procedure ConfigurarQueryParameters(const Method, EndPoint: String); override;
    procedure ConfigurarHeaders(const Method, AURL: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear; override;
    procedure Autenticar; override;

  published
    property APIVersion;

    //Token fornecido pelo Sicoob na �rea de SandBox
    property TokenSandbox: String read fTokenSandbox write fTokenSandbox;

    property SandboxStatusCode: String read fSandboxStatusCode write fSandboxStatusCode;
    property QuandoNecessitarCredenciais: TACBrQuandoNecessitarCredencial
      read fQuandoNecessitarCredenciais write fQuandoNecessitarCredenciais;
  end;

implementation

uses
  synautil, DateUtils,
  ACBrJSON, ACBrUtil.Strings, ACBrUtil.Base;

{ TACBrPSPSicoob }

constructor TACBrPSPSicoob.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fpQuandoReceberRespostaEndPoint := QuandoReceberRespostaEndPoint;
  Clear;
end;

procedure TACBrPSPSicoob.Clear;
begin
  inherited Clear;
  fxCorrelationID := '';
  fSandboxStatusCode := '';
  fArquivoCertificado := '';
  fArquivoChavePrivada := '';
  fQuandoNecessitarCredenciais := Nil;
end;

procedure TACBrPSPSicoob.Autenticar;
var
  AURL, Body: String;
  RespostaHttp: AnsiString;
  ResultCode, sec: Integer;
  js: TACBrJSONObject;
  qp: TACBrQueryParams;
begin
  LimparHTTP;

  // Sicoob j� disponibiliza o Token para ambiente Sandbox no portal
  if (ACBrPixCD.Ambiente <> ambProducao) then
  begin
    if EstaVazio(Trim(fTokenSandbox)) then
      DispararExcecao(EACBrPixHttpException.Create(ACBrStr(sErroTokenSandboxNaoInformado)));

    fpToken := fTokenSandbox;
    fpValidadeToken := IncSecond(Now, 86400);
    fpAutenticado := True;
    Exit;
  end;

  AURL := cSicoobURLAuthProducao;
  qp := TACBrQueryParams.Create;
  try
    qp.Values['grant_type'] := 'client_credentials';
    qp.Values['client_id'] := ClientID;
    qp.Values['scope'] := ScopesToString(Scopes);
    Body := qp.AsURL;
    WriteStrToStream(Http.Document, Body);
    Http.MimeType := CContentTypeApplicationWwwFormUrlEncoded;
  finally
    qp.Free;
  end;

  TransmitirHttp(ChttpMethodPOST, AURL, ResultCode, RespostaHttp);

  if (ResultCode = HTTP_OK) then
  begin
    js := TACBrJSONObject.Parse(RespostaHttp);
    try
      fpToken := js.AsString['access_token'];
      sec := js.AsInteger['expires_in'];
    finally
      js.Free;
    end;

   if (Trim(fpToken) = '') then
     DispararExcecao(EACBrPixHttpException.Create(ACBrStr(sErroAutenticacao)));

   fpValidadeToken := IncSecond(Now, sec);
   fpAutenticado := True;
  end
  else
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
      [Http.ResultCode, ChttpMethodGET, AURL]));
end;

procedure TACBrPSPSicoob.QuandoReceberRespostaEndPoint(const AEndPoint, AURL,
  AMethod: String; var AResultCode: Integer; var RespostaHttp: AnsiString);
begin
  // Sicoob responde OK a esse EndPoint, de forma diferente da especificada
  if (UpperCase(AMethod) = ChttpMethodPUT) and (AEndPoint = cEndPointPix) and (AResultCode = HTTP_OK) then
    AResultCode := HTTP_CREATED;

  // Ajuste no Json de Resposta alterando 'brcode' para 'pixCopiaECola'
  if (((UpperCase(AMethod) = ChttpMethodPUT) and (AEndPoint = cEndPointCobV)) or
     (((UpperCase(AMethod) = ChttpMethodPUT) or (UpperCase(AMethod) = ChttpMethodPOST)) and (AEndPoint = cEndPointCob))) and (AResultCode = HTTP_CREATED) then
    RespostaHttp := StringReplace(RespostaHttp, 'brcode', 'pixCopiaECola', [rfReplaceAll]);
end;

function TACBrPSPSicoob.ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String;
begin
  if (Ambiente = ambProducao) then
    Result := cSicoobURLProducao
  else
    Result := cSicoobURLSandbox;

  Result := Result + cSicoobPathAPIPix;
end;

procedure TACBrPSPSicoob.ConfigurarHeaders(const Method, AURL: String);
begin
  inherited ConfigurarHeaders(Method, AURL);

  if NaoEstaVazio(ClientID) then
    Http.Headers.Add('client_id: ' + ClientID);
end;

procedure TACBrPSPSicoob.ConfigurarQueryParameters(const Method, EndPoint: String);
begin
  if NaoEstaVazio(fSandboxStatusCode) then
    URLQueryParams.Values['status_code'] := fSandboxStatusCode;
end;

end.
