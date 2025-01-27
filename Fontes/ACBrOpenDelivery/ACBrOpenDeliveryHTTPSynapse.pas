{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Gabriel Baltazar                               }
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

unit ACBrOpenDeliveryHTTPSynapse;

interface

uses
  ACBrOpenDeliveryHTTP,
  ACBrJSON,
  ACBrCompress,
  ACBrUtil.Strings,
  blcksock,
  synsock,
  httpsend,
  ssl_openssl,
  synautil,
  {$IFDEF MSWINDOWS}
  Windows,
  WinInet,
  {$ENDIF}
  SysUtils,
  Variants,
  Classes;

type
  TACBrOpenDeliveryHTTPRequestSynapse = class(TACBrOpenDeliveryHTTPRequest)
  protected
    FHTTPSend: THTTPSend;
    FIsUTF8: Boolean;

    function GetFullUrl: string;
    function GetMethodType: string;

    procedure PrepareRequest;
    procedure PrepareRequestProxy;
    procedure PrepareRequestAuth;
    procedure PrepareRequestHeaders;
    procedure PrepareRequestBody;

  public
    procedure Clear; override;
    function Send: TACBrOpenDeliveryHTTPResponse; override;

    constructor Create(const ARequestId: string = ''); override;
    destructor Destroy; override;
  end;

  TACBrOpenDeliveryHTTPResponseSynapse = class(TACBrOpenDeliveryHTTPResponse)
  private
    function GetHeaderValue(const AName: string; AHTTPSend: THTTPSend): string;

  public
    constructor Create(AHTTPSend: THTTPSend);
  end;

implementation

{ TACBrOpenDeliveryHTTPRequestSynapse }

procedure TACBrOpenDeliveryHTTPRequestSynapse.Clear;
begin
  inherited;
  FHTTPSend.Clear;
  FHeaders.Clear;
  FQuery.Clear;
  FEnvio.Clear;
  FResposta.Clear;
  FBody := EmptyStr;
end;

constructor TACBrOpenDeliveryHTTPRequestSynapse.Create(const ARequestId: string);
begin
  inherited Create(ARequestId);
  FHTTPSend := THTTPSend.Create;
  FHTTPSend.Protocol := '1.1';
  FIsUTF8 := False;
end;

destructor TACBrOpenDeliveryHTTPRequestSynapse.Destroy;
begin
  FHTTPSend.Free;
  inherited;
end;

function TACBrOpenDeliveryHTTPRequestSynapse.GetFullUrl: string;
var
  LResource: string;
  I: Integer;
begin
  Result := FBaseUrl;

  if Copy(FBaseUrl, Length(FBaseUrl), 1) <> '/' then
    Result := Result + '/';

  if Trim(FAPIVersion) <> '' then
  begin
    Result := Result + FAPIVersion;
    if Copy(Result, Length(Result), 1) <> '/' then
      Result := Result + '/';
  end;

  LResource := FResource;
  if Copy(LResource, 1, 1) = '/' then
    LResource := Copy(LResource, 2, Length(LResource) - 1);

  Result := Result + LResource;

  for I := 0 to Pred(Self.FQuery.Count) do
  begin
    if I = 0 then
      Result := Result + '?'
    else
      Result := Result + '&';
    Result := Result + FQuery.Names[I] + '=' + FQuery.ValueFromIndex[I];
  end;
end;

function TACBrOpenDeliveryHTTPRequestSynapse.GetMethodType: string;
begin
  case FMethodType of
    mtGET: Result := 'GET';
    mtPOST: Result := 'POST';
    mtPUT: Result := 'PUT';
    mtDELETE: Result := 'DELETE';
    mtPATCH: Result := 'PATCH';
  else
    raise EResNotFound.Create('Verbo Http n�o suportado.');
  end;
end;

procedure TACBrOpenDeliveryHTTPRequestSynapse.PrepareRequest;
begin
  FEnvio.Clear;
  FResposta.Clear;
  FHTTPSend.Clear;
  FHTTPSend.Timeout := FTimeout;
  FHTTPSend.Sock.ConnectionTimeout := FTimeout;
  FHTTPSend.Sock.InterPacketTimeout := False;
  FHTTPSend.Sock.NonblockSendTimeout := FTimeout;
  FHTTPSend.Sock.SocksTimeout := FTimeout;
  FHTTPSend.Sock.HTTPTunnelTimeout := FTimeout;
  FHTTPSend.Sock.SSL.SSLType := LT_all;
  FHTTPSend.AddPortNumberToHost := False;

  PrepareRequestProxy;
  PrepareRequestAuth;
  PrepareRequestHeaders;
  PrepareRequestBody;
end;

procedure TACBrOpenDeliveryHTTPRequestSynapse.PrepareRequestAuth;
begin
  if FToken <> '' then
    FHTTPSend.Headers.Add('Authorization: Bearer ' + FToken)
  else
  if (FUsername <> '') and (FPassword <> '') then
  begin
    FHTTPSend.UserName := FUsername;
    FHTTPSend.Password := FPassword;
  end;
end;

procedure TACBrOpenDeliveryHTTPRequestSynapse.PrepareRequestBody;
var
  I: Integer;
  LUrlData: string;
begin
  if FFormUrlEncoded.Count > 0 then
  begin
    for I := 0 to Pred(FFormUrlEncoded.Count) do
    begin
      if I > 0 then
        LUrlData := LUrlData + '&';
      LUrlData := LUrlData + Format('%s=%s', [FFormUrlEncoded.Names[I], FFormUrlEncoded.ValueFromIndex[I]]);
    end;

    WriteStrToStream(FHTTPSend.Document, LUrlData);
    FEnvio.Body := LUrlData;
  end
  else
  if FBody <> '' then
  begin
    WriteStrToStream(FHTTPSend.Document, AnsiString(FBody));
    FEnvio.Body := AnsiString(FBody);
  end
  else
    FHTTPSend.Headers.Add('Content-Length:0');
end;

procedure TACBrOpenDeliveryHTTPRequestSynapse.PrepareRequestHeaders;
var
  I: Integer;
  LName: string;
  LValue: string;
begin
  if not Assigned(FHeaders) then
    exit;

  for I := 0 to Pred(FHeaders.Count) do
  begin
    LName := FHeaders.Names[I];
    LValue := FHeaders.ValueFromIndex[I];
    FHTTPSend.Headers.Add(Format('%s:%s', [LName, LValue]));
    FEnvio.Headers.Values[LName] := LValue;
  end;

  if FContentType <> EmptyStr then
    FHTTPSend.MimeType := FContentType;

  if FAccept <> EmptyStr then
    FHTTPSend.Headers.Add(Format('Accept:%s', [FAccept]));
end;

procedure TACBrOpenDeliveryHTTPRequestSynapse.PrepareRequestProxy;
begin
  if FProxyHost <> '' then
  begin
    FHTTPSend.ProxyHost := FProxyHost;
    FHTTPSend.ProxyPort := FProxyPort;
    FHTTPSend.ProxyUser := FProxyUser;
    FHTTPSend.ProxyPass := FProxyPass;
  end;
end;

function TACBrOpenDeliveryHTTPRequestSynapse.Send: TACBrOpenDeliveryHTTPResponse;
var
  LUrl: String;
begin
  LUrl := GetFullUrl;
  if LUrl[Length(LUrl)] = '/' then
    LUrl := Copy(LUrl, 1, Length(LUrl) - 1);
  PrepareRequest;
  try
    FEnvio.URL := LUrl;
    FEnvio.Data := Now;
    FEnvio.Method := GetMethodType;
    FHTTPSend.HTTPMethod(FEnvio.Method, LUrl);
    FResposta.Data := Now;
    FResposta.URL := LUrl;

    Result := TACBrOpenDeliveryHTTPResponseSynapse.Create(FHTTPSend);
    FResposta.Body := Result.GetContent;
    FResposta.Status := Result.StatusCode;
  finally
    if Assigned(FOnHTTPEnvio) then
      FOnHTTPEnvio(FEnvio);

    if Assigned(FOnHTTPResposta) then
      FOnHTTPResposta(FResposta);
    Clear;
  end;
end;

{ TACBrOpenDeliveryHTTPResponseSynapse }

constructor TACBrOpenDeliveryHTTPResponseSynapse.Create(AHTTPSend: THTTPSend);
begin
  FStatusText := AHTTPSend.ResultString;
  FStatusCode := AHTTPSend.ResultCode;
  FHeaders := TStringList.Create;
  FHeaders.Text := AHTTPSend.Headers.Text;

  if AHTTPSend.Document <> nil then
  begin
    AHTTPSend.Document.Position := 0;
    FBodyText := ReadStrFromStream(AHTTPSend.Document, AHTTPSend.Document.Size);
  end;
end;

function TACBrOpenDeliveryHTTPResponseSynapse.GetHeaderValue(const AName: string; AHTTPSend: THTTPSend): string;
var
  I: Integer ;
  AHeaderLine: string ;
begin
  Result := '' ;
  I := 0 ;

  while (Result = '') and (I < AHTTPSend.Headers.Count) do
  begin
    AHeaderLine := AHTTPSend.Headers[I];

    if (Pos(AName, AHeaderLine) = 1) then
      Result := Trim(Copy(AHeaderLine, Length(AName)+1, Length(AHeaderLine) )) ;

    Inc(I);
  end;
end;

end.
