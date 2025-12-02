{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

(*

  Documentação:
  - https://dev.pagseguro.uol.com.br/reference/pix-intro

*)

{$I ACBr.inc}

unit ACBrPIXPSPPagSeguro;

interface

uses
  Classes, SysUtils,
  {$IFDEF RTL230_UP}ACBrBase,{$ENDIF RTL230_UP}
  ACBrPIXCD;

const
  cPagSeguroURLProducao = 'https://secure.api.pagseguro.com';
  cPagSeguroURLProducaoNoAuth = 'https://api.pagseguro.com';
  cPagSeguroURLSandbox = 'https://secure.sandbox.api.pagseguro.com';
  cPagSeguroURLSandboxNoAuth = 'https://sandbox.api.pagseguro.com';
  cPagSeguroURLPay = 'https://sandbox.api.pagseguro.com/pix';
  cPagSeguroPathCredentials = '/oauth2/application';
  cPagSeguroPathAuth = '/pix/oauth2';
  cPagSeguroPathChallenge = '/oauth2/token';
  cPagSeguroPathCertificate = '/certificates';
  cPagSeguroPathAPIPix = '/instant-payments';
  cPagSeguroEndPointPay = '/pay';
  cPagSeguroHeaderChallenge = 'X_CHALLENGE: ';

resourcestring
  sPagSeguroErroTokenPay = 'Token para simular pagamento não informado';

type

  { TACBrPSPPagSeguro }

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrPSPPagSeguro = class(TACBrPSPCertificate)
  private
    fTokenPay: String;

    procedure QuandoAcessarEndPoint(const aEndPoint: String; var aURL: String; var aMethod: String);
  protected
    procedure ConfigurarHeaders(const aMethod, aURL: String); override;
    procedure ConfigurarAutenticacao(const aMethod, aEndPoint: String); override;
    function ObterURLAmbiente(const aAmbiente: TACBrPixCDAmbiente): String; override;
    function ObterURLAmbienteNoAuth(const aAmbiente: TACBrPixCDAmbiente): String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Autenticar; override;

    function SimularPagamentoPIX(const aTxID: String): Boolean;

    function SolicitarCredenciais(const aNomeAplicacao: String; var aClientID: String; var aClientSecret: String): Boolean;
    function SolicitarDesafioCertificado(out Challenge: String; out TokenChallenge: String): Boolean;
    function SolicitarCertificado(const aToken: String; const aChallenge: String; out idCertificado: String;
      out Certificado: AnsiString; out ChavePrivada: AnsiString): Boolean;
  published
    property TokenPay: String read fTokenPay write fTokenPay;
  end;

implementation

uses
  synacode, synautil, DateUtils, ACBrJSON,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrPIXUtil;

{ TACBrPSPPagSeguro }

procedure TACBrPSPPagSeguro.QuandoAcessarEndPoint(const aEndPoint: String;
  var aURL: String; var aMethod: String);
begin
  // PagSeguro não possui POST para endpoint /cob
   if (LowerCase(aEndPoint) = cEndPointCob) and (UpperCase(aMethod) = ChttpMethodPOST) then
  begin
    aMethod := ChttpMethodPUT;
    aURL := URLComDelimitador(aURL) + CriarTxId;
  end;
end;

procedure TACBrPSPPagSeguro.ConfigurarHeaders(const aMethod, aURL: String);
begin
  inherited ConfigurarHeaders(aMethod, aURL);

  if (Pos('secure', aURL) <= 0) then
  begin
    Http.Sock.SSL.CertificateFile := EmptyStr;
    Http.Sock.SSL.Certificate := EmptyStr;
    Http.Sock.SSL.PrivateKeyFile := EmptyStr;
    Http.Sock.SSL.PrivateKey := EmptyStr;
  end;
end;

procedure TACBrPSPPagSeguro.ConfigurarAutenticacao(const aMethod,
  aEndPoint: String);
begin
  if (NivelLog > 2) then
    RegistrarLog('ConfigurarAutenticacao( ' + aMethod + ', ' + aEndPoint + ' )');

  if (aEndPoint = cPagSeguroEndPointPay) then
  begin
    if NaoEstaVazio(TokenPay) then
      Http.Headers.Insert(0, ChttpHeaderAuthorization + ChttpAuthorizationBearer+' '+TokenPay);
  end
  else if NaoEstaVazio(fpToken) then
    Http.Headers.Insert(0, ChttpHeaderAuthorization + ChttpAuthorizationBearer+' '+fpToken);
end;

function TACBrPSPPagSeguro.ObterURLAmbiente(const aAmbiente: TACBrPixCDAmbiente): String;
begin
  if (aAmbiente = ambProducao) then
    Result := cPagSeguroURLProducao + cPagSeguroPathAPIPix
  else
    Result := cPagSeguroURLSandbox + cPagSeguroPathAPIPix;
end;

function TACBrPSPPagSeguro.ObterURLAmbienteNoAuth(const aAmbiente: TACBrPixCDAmbiente): String;
begin
  Result := cPagSeguroURLSandboxNoAuth;
  if (aAmbiente = ambProducao) then
    Result := cPagSeguroURLProducaoNoAuth;
end;

constructor TACBrPSPPagSeguro.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fTokenPay := EmptyStr;
  fpQuandoAcessarEndPoint := QuandoAcessarEndPoint;
end;

procedure TACBrPSPPagSeguro.Autenticar;
var
  wURL: String;
  wRespostaHttp: AnsiString;
  wResultCode, sec: Integer;
  js: TACBrJSONObject;
begin
  LimparHTTP;

  if (ACBrPixCD.Ambiente = ambProducao) then
    wURL := cPagSeguroURLProducao + cPagSeguroPathAuth
  else
    wURL := cPagSeguroURLSandbox + cPagSeguroPathAuth;

  js := TACBrJSONObject.Create;
  try
    js.AddPair('grant_type', 'client_credentials'); 
    js.AddPair('scope', ScopesToString(Scopes));
    Http.Protocol := '1.1';
    Http.MimeType := CContentTypeApplicationJSon;
    WriteStrToStream(Http.Document, js.ToJSON);
  finally
    js.Free;
  end;

  Http.UserName := ClientID;
  Http.Password := ClientSecret;
  TransmitirHttp(ChttpMethodPOST, wURL, wResultCode, wRespostaHttp);

  if (wResultCode = HTTP_OK) then
  begin
    js := TACBrJSONObject.Parse(wRespostaHttp);
    try
      fpToken := js.AsString['access_token'];
      sec := js.AsInteger['expires_in'];
      fpRefreshToken := js.AsString['refresh_token'];
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

function TACBrPSPPagSeguro.SimularPagamentoPIX(const aTxID: String): Boolean;
var
  wBody, aURL: String;
  wRespostaHttp: AnsiString;
  wResultCode: Integer;
  js: TACBrJSONObject;
begin
  if EstaVazio(Trim(aTxID)) then
    DispararExcecao(EACBrPSPException.CreateFmt(ACBrStr(sErroParametroInvalido), ['txID']));

  if EstaVazio(TokenPay) then
    DispararExcecao(EACBrPSPException.Create(ACBrStr(sPagSeguroErroTokenPay)));

  js := TACBrJSONObject.Create;
  try
    js.AddPair('status', 'PAID');
    js.AddPair('tx_id', aTxID);
    wBody := js.ToJSON;
  finally
    js.Free;
  end;

  LimparHTTP;
  WriteStrToStream(Http.Document, wBody);
  Http.Protocol := '1.1';
  Http.MimeType := CContentTypeApplicationJSon;
  ConfigurarAutenticacao(ChttpMethodPOST, cPagSeguroEndPointPay);

  aURL := cPagSeguroURLPay + cPagSeguroEndPointPay + '/' + Trim(aTxID);
  TransmitirHttp(ChttpMethodPOST, aURL, wResultCode, wRespostaHttp);

  Result := (wResultCode = HTTP_OK);
  if (not (wResultCode = HTTP_OK)) then
    DispararExcecao(EACBrPixHttpException.CreateFmt(sErroHttp, [Http.ResultCode, ChttpMethodPOST, aURL]));
end;

function TACBrPSPPagSeguro.SolicitarCredenciais(const aNomeAplicacao: String;
  var aClientID: String; var aClientSecret: String): Boolean;
var
  aURL: String;
  jo, js: TACBrJSONObject;
  wResultCode: Integer;
  wRespostaHttp: AnsiString;
begin
  Result := False;
  VerificarPIXCDAtribuido;

  if EstaVazio(TokenPay) then
    DispararExcecao(EACBrPSPException.Create(ACBrStr(sPagSeguroErroTokenPay)));

  LimparHTTP;
  Http.Protocol := '1.1';
  Http.Headers.Add(ChttpHeaderAuthorization + ChttpAuthorizationBearer + ' ' + TokenPay);
  Http.MimeType := CContentTypeApplicationJSon;

  aURL := ObterURLAmbienteNoAuth(ACBrPixCD.Ambiente) + cPagSeguroPathCredentials;
  jo := TACBrJSONObject.Create;
  try
    jo.AddPair('name', aNomeAplicacao);
    WriteStrToStream(Http.Document, jo.ToJSON);
  finally
    jo.Free;
  end;

  Result := TransmitirHttp(ChttpMethodPOST, aURL, wResultCode, wRespostaHttp);
  Result := Result and (wResultCode = HTTP_CREATED);

  if not Result then
    DispararExcecao(EACBrPixHttpException.CreateFmt(sErroHttp, [Http.ResultCode, ChttpMethodPOST, aURL]));

  try
    js := TACBrJSONObject.Parse(wRespostaHttp);
    js.Value('client_id', aClientID)
      .Value('client_secret', aClientSecret);
  finally
    if Assigned(js) then
      js.Free;
  end;
end;

function TACBrPSPPagSeguro.SolicitarDesafioCertificado(out Challenge: String; out TokenChallenge: String): Boolean;
var
  aURL: String;
  js, jr: TACBrJSONObject;
  wBody: String;
  wRespostaHttp: AnsiString;
  wResultCode: Integer;
begin
  Result := False;
  Challenge := EmptyStr;
  TokenChallenge := EmptyStr;
  VerificarPIXCDAtribuido;

  if EstaVazio(TokenPay) then
    DispararExcecao(EACBrPSPException.Create(ACBrStr(sPagSeguroErroTokenPay)));

  aURL := cPagSeguroURLSandboxNoAuth;
  if (ACBrPixCD.Ambiente = ambProducao) then
    aURL := cPagSeguroURLProducaoNoAuth;

  aURL := aURL + cPagSeguroPathChallenge;

  js := TACBrJSONObject.Create;
  try
    js.AddPair('grant_type', 'challenge');
    js.AddPair('scope', 'certificate.create');
    wBody := js.ToJSON;
  finally
    js.Free;
  end;

  LimparHTTP;
  Http.Headers.Insert(0, ChttpHeaderAuthorization + ChttpAuthorizationBearer+' '+TokenPay);

  WriteStrToStream(Http.Document, wBody);
  Http.MimeType := CContentTypeApplicationJSon;
  Http.Protocol := '1.1';

  TransmitirHttp(ChttpMethodPOST, aURL, wResultCode, wRespostaHttp);
  Result := (wResultCode = HTTP_OK);

  if Result then
  begin
    jr := TACBrJSONObject.Parse(wRespostaHttp);
    try
      jr.Value('challenge', Challenge);
      jr.Value('access_token', TokenChallenge);
    finally
      jr.Free;
    end;
  end
  else
    DispararExcecao(EACBrPixHttpException.CreateFmt(sErroHttp, [Http.ResultCode, ChttpMethodPOST, aURL]));
end;

function TACBrPSPPagSeguro.SolicitarCertificado(const aToken: String; const aChallenge: String;
  out idCertificado: String; out Certificado: AnsiString; out ChavePrivada: AnsiString): Boolean;
var
  aURL, CertB64, ChaveB64: String;
  wRespostaHttp: AnsiString;
  wResultCode: Integer;
  jo: TACBrJSONObject;
begin
  CertB64 := EmptyStr;
  ChaveB64 := EmptyStr;
  Certificado := EmptyStr;
  ChavePrivada := EmptyStr;
  idCertificado := EmptyStr;
  VerificarPIXCDAtribuido;

  if EstaVazio(aToken) then
    DispararExcecao(EACBrPSPException.Create(ACBrStr(sPagSeguroErroTokenPay)));

  aURL := cPagSeguroURLSandboxNoAuth;
  if (ACBrPixCD.Ambiente = ambProducao) then
    aURL := cPagSeguroURLProducaoNoAuth;

  aURL := aURL + cPagSeguroPathCertificate;

  LimparHTTP;
  Http.Headers.Insert(0, ChttpHeaderAuthorization + ChttpAuthorizationBearer+' '+aToken);
  Http.Headers.Insert(1, cPagSeguroHeaderChallenge + aChallenge);

  Http.MimeType := CContentTypeApplicationJSon;
  Http.Protocol := '1.1';

  TransmitirHttp(ChttpMethodPOST, aURL, wResultCode, wRespostaHttp);
  Result := (wResultCode in [HTTP_OK, HTTP_CREATED]);
  if Result then
  begin
    try                                        
      jo := TACBrJSONObject.Parse(wRespostaHttp);
      jo.Value('id', idCertificado)
        .Value('pem', CertB64)
        .Value('key', ChaveB64);
      Certificado := DecodeBase64(CertB64);
      ChavePrivada := DecodeBase64(ChaveB64);
    finally
      if Assigned(jo) then
        jo.Free;
    end;
  end
  else
    DispararExcecao(EACBrPixHttpException.CreateFmt(sErroHttp, [Http.ResultCode, ChttpMethodPOST, aURL]));
end;

end.

