{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{ - MaagraowaR                                                                 }
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
  https://developer.ailos.coop.br/api-portal/pt-br

*)

{$I ACBr.inc}

unit ACBrPIXPSPAilos;

interface

uses
  Classes, SysUtils,
  {$IFDEF RTL230_UP}ACBrBase,{$ENDIF RTL230_UP}
  ACBrPIXCD, ACBrOpenSSLUtils;

const
  cAilosURLSandbox      = 'https://apiendpointhml.ailos.coop.br/qa/ailos/pix-cobranca/api/v1';
  cAilosURLProducao     = 'https://pixcobranca.ailos.coop.br/ailos/pix-cobranca/api/v1';
  cAilosPathAuthToken   = '/client/connect/token';
  cAilosURLAuthTeste    = cAilosURLSandbox+cAilosPathAuthToken;
  cAilosURLAuthProducao = cAilosURLProducao+cAilosPathAuthToken;

type

  { TACBrPSPAilos }

  TACBrPSPAilos = class(TACBrPSPCertificate)
  private
    fRootCrt: String;
    procedure QuandoReceberRespostaEndPoint(const AEndPoint, AURL, AMethod: String;
      var AResultCode: Integer; var RespostaHttp: AnsiString);
  protected
    function ObterURLAmbiente(const aAmbiente: TACBrPixCDAmbiente): String; override;
    procedure ConfigurarHeaders(const Method, AURL: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear; override;
    procedure Autenticar; override;
  published
    property RootCrt: String read fRootCrt write fRootCrt;
  end;

implementation

uses
  synautil, DateUtils, ACBrJSON,
  ACBrUtil.Base,
  ACBrUtil.Strings;

{ TACBrPSPAilos }

procedure TACBrPSPAilos.Autenticar;
var
  wURL, Body: String;
  wRespostaHttp: AnsiString;
  wResultCode, sec: Integer;
  js: TACBrJSONObject;
  qp: TACBrQueryParams;
begin
  LimparHTTP;

  if (ACBrPixCD.Ambiente = ambProducao) then
    wURL := cAilosURLAuthProducao
  else
    wURL := cAilosURLAuthTeste;

  qp := TACBrQueryParams.Create;
  try
    qp.Values['client_id'] := ClientID;
    qp.Values['client_secret'] := ClientSecret;
    qp.Values['scope'] := ScopesToString(Scopes);
    qp.Values['cacert'] := RootCrt;
    Body := qp.AsURL;
    WriteStrToStream(Http.Document, Body);
    Http.MimeType := CContentTypeApplicationWwwFormUrlEncoded;
  finally
    qp.Free;
  end;

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

constructor TACBrPSPAilos.Create(AOwner: TComponent);
begin
  inherited;
  fpQuandoReceberRespostaEndPoint := QuandoReceberRespostaEndPoint;
  Clear;
end;

procedure TACBrPSPAilos.Clear;
begin
  inherited Clear;
  fRootCrt := '';
end;

function TACBrPSPAilos.ObterURLAmbiente(const aAmbiente: TACBrPixCDAmbiente): String;
begin
  if (aAmbiente = ambProducao) then
    Result := cAilosURLProducao
  else
    Result := cAilosURLSandbox;
end;

procedure TACBrPSPAilos.ConfigurarHeaders(const Method, AURL: String);
begin
  inherited ConfigurarHeaders(Method, AURL);

  if NaoEstaVazio(fRootCrt) then
    Http.Sock.SSL.CertCAFile := fRootCrt;
end;

procedure TACBrPSPAilos.QuandoReceberRespostaEndPoint(const AEndPoint, AURL,
  AMethod: String; var AResultCode: Integer; var RespostaHttp: AnsiString);
begin
  // Ailos responde OK a esse EndPoint, de forma diferente da especificada
  if (UpperCase(AMethod) = ChttpMethodPUT) and (AEndPoint = cEndPointPix) and (AResultCode = HTTP_OK) then
    AResultCode := HTTP_CREATED;

  if (UpperCase(AMethod) = ChttpMethodPOST) and (AEndPoint = cEndPointCob) and (AResultCode = HTTP_OK) then
    AResultCode := HTTP_CREATED;
end;

end.
