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
  https://developer.santander.com.br/

*)

{$I ACBr.inc}

unit ACBrPIXPSPSantander;

interface

uses
  Classes, SysUtils,
  {$IFDEF RTL230_UP}ACBrBase,{$ENDIF RTL230_UP}
  ACBrPIXCD;

const
  cSantanderPathApiPIXv1 = '/api/v1';
  cSantanderPathApiPIXv2 = '/api/v2';
  cSantanderURLSandbox = 'https://pix.santander.com.br' + cSantanderPathApiPIXv1 + '/sandbox';
  cSantanderURLPreProducao = 'https://trust-pix-h.santander.com.br' + cSantanderPathApiPIXv1;
  cSantanderURLProducao = 'https://trust-pix.santander.com.br' + cSantanderPathApiPIXv1;

  cSantanderURLAuthTeste = 'https://pix.santander.com.br/sandbox/oauth/token';
  cSantanderURLAuthPreProducao = 'https://trust-pix-h.santander.com.br/oauth/token';
  cSantanderURLAuthProducao = 'https://trust-pix.santander.com.br/oauth/token';

resourcestring
  sErroClienteIdDiferente = 'Cliente_Id diferente do Informado';

type

  { TACBrPSPSantander }
  
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrPSPSantander = class(TACBrPSPCertificate)
  private
    fRefreshURL: String;
    function GetConsumerKey: String;
    function GetConsumerSecret: String;
    procedure SetConsumerKey(AValue: String);
    procedure SetConsumerSecret(AValue: String);
    procedure QuandoReceberRespostaEndPoint(const aEndPoint, aURL, aMethod: String;
      var aResultCode: Integer; var aRespostaHttp: AnsiString);
    procedure QuandoAcessarEndPoint(const aEndPoint: String; var aURL: String; var aMethod: String);
  protected
    function ObterURLAmbiente(const aAmbiente: TACBrPixCDAmbiente): String; override;
    procedure ConfigurarQueryParameters(const Method, EndPoint: String); override;
    function VerificarSeIncluiPFX(const Method, AURL: String): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Autenticar; override;
    procedure RenovarToken; override;
  published
    property APIVersion;
    property ConsumerKey: String read GetConsumerKey write SetConsumerKey;
    property ConsumerSecret: String read GetConsumerSecret write SetConsumerSecret;
  end;

implementation

uses
  synautil, DateUtils,
  ACBrJSON, ACBrPIXUtil,
  ACBrUtil.FilesIO,
  ACBrUtil.Strings,
  ACBrUtil.DateTime;

{ TACBrPSPSantander }

constructor TACBrPSPSantander.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fpQuandoReceberRespostaEndPoint := QuandoReceberRespostaEndPoint;
  fpQuandoAcessarEndPoint := QuandoAcessarEndPoint;
  fRefreshURL := EmptyStr;
end;

procedure TACBrPSPSantander.Autenticar;
var
  AURL, Body, client_id: String;
  RespostaHttp: AnsiString;
  ResultCode, sec: Integer;
  js: TACBrJSONObject;
  qp: TACBrQueryParams;
begin
  LimparHTTP;

  case ACBrPixCD.Ambiente of
    ambProducao: AURL := cSantanderURLAuthProducao;
    ambPreProducao: AURL := cSantanderURLAuthPreProducao;
  else
    AURL := cSantanderURLAuthTeste;
  end;

  AURL := AURL + '?grant_type=client_credentials';

  qp := TACBrQueryParams.Create;
  try
    qp.Values['client_id'] := ClientID;
    qp.Values['client_secret'] := ClientSecret;
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
      client_id := Trim(js.AsString['client_id']);
      if (client_id <> ClientID) then
        raise EACBrPixHttpException.Create(ACBrStr(sErroClienteIdDiferente));
      fpToken := js.AsString['access_token'];
      sec := js.AsInteger['expires_in'];
      fRefreshURL := js.AsString['refresh_token'];
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
       [Http.ResultCode, ChttpMethodPOST, AURL]));
end;

procedure TACBrPSPSantander.RenovarToken;
begin
  // TODO: ??
  inherited RenovarToken;
end;

function TACBrPSPSantander.GetConsumerKey: String;
begin
  Result := ClientID;
end;

function TACBrPSPSantander.GetConsumerSecret: String;
begin
  Result := ClientSecret;
end;

procedure TACBrPSPSantander.SetConsumerKey(AValue: String);
begin
  ClientID := AValue;
  fpAutenticado := False;  // For�a uma nova autentica��o
end;

procedure TACBrPSPSantander.SetConsumerSecret(AValue: String);
begin
  ClientSecret := AValue;
  fpAutenticado := False;  // For�a uma nova autentica��o
end;

procedure TACBrPSPSantander.QuandoReceberRespostaEndPoint(const aEndPoint,
  aURL, aMethod: String; var aResultCode: Integer; var aRespostaHttp: AnsiString);
begin
  // Santander responde OK a esse EndPoint, de forma diferente da especificada
  if (UpperCase(AMethod) = ChttpMethodPOST) and (AEndPoint = cEndPointCob) and (AResultCode = HTTP_OK) then
    AResultCode := HTTP_CREATED;
end;

procedure TACBrPSPSantander.QuandoAcessarEndPoint(const aEndPoint: String; var aURL: String; var aMethod: String);
begin
  // Santander n�o possui POST para endpoint /cob
  if (LowerCase(aEndPoint) = cEndPointCob) and (UpperCase(aMethod) = ChttpMethodPOST) then
  begin
    aMethod := ChttpMethodPUT;
    aURL := URLComDelimitador(aURL) + CriarTxId;
  end;
  
  // Santander usa v2 para Revisar Cobran�a (metodo PATCH)
  if (aMethod = ChttpMethodPATCH) and ((aEndPoint = cEndPointCob) or (aEndPoint = cEndPointCobV)) then
    aURL := StringReplace(aURL, cSantanderPathApiPIXv1, cSantanderPathApiPIXv2, [rfReplaceAll]);
end;

procedure TACBrPSPSantander.ConfigurarQueryParameters(const Method,
  EndPoint: String);
const
  cDtFormat: string = 'yyyy''-''mm''-''dd''T''hh'':''nn'':''ss''Z''';
begin
  // Santander s� aceita par�metros de data SEM milissegundos
  if (EndPoint = cEndPointPix) and (Method = ChttpMethodGET) and (URLQueryParams.Count > 0) then
  begin
    URLQueryParams.Values['inicio'] := FormatDateTime(cDtFormat, Iso8601ToDateTime(URLQueryParams.Values['inicio']));
    URLQueryParams.Values['fim'] := FormatDateTime(cDtFormat, Iso8601ToDateTime(URLQueryParams.Values['fim']));
  end;
end;

function TACBrPSPSantander.ObterURLAmbiente(const aAmbiente: TACBrPixCDAmbiente): String;
begin
  case aAmbiente of
    ambProducao: Result := cSantanderURLProducao;
    ambPreProducao: Result := cSantanderURLPreProducao;
  else
    Result := cSantanderURLSandbox;
  end;
end;

function TACBrPSPSantander.VerificarSeIncluiPFX(const Method, AURL: String): Boolean;
begin
  Result := (inherited VerificarSeIncluiPFX(Method, AURL));
end;

end.


