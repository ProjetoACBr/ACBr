{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor H Gonzales - Pandaaa                     }
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
unit ACBr.Auth.JWT;

interface
uses
  Classes;

type
  TACBrJWTAuth = class
    FSecretKey: String;
  private
    function Base64UrlEncode(const AInput: String; AEncodeBase64 : boolean = true): String;
    function HMACSHA256(const AData, AKey: String): String;
  public
    constructor Create(const ASecretKey: String);
    function GenerateJWT(const APayload: String): String;
    function ValidateJWT(const AToken: String): Boolean;
  end;

implementation

uses
  synacode,
  SysUtils,
  ACBrUtil.Strings,
  ACBrOpenSSLUtils;

{ TACBrJWTAuth }

constructor TACBrJWTAuth.Create(const ASecretKey: String);
begin
  FSecretKey := ASecretKey;
end;

function TACBrJWTAuth.HMACSHA256(const AData, AKey: String): String;
var LACBrSSLUtils : TACBrOpenSSLUtils;
begin
  LACBrSSLUtils := TACBrOpenSSLUtils.Create(nil);
  try
    Result := LACBrSSLUtils.HMACFromString(AData, AKey, algSHA256);
  finally
    LACBrSSLUtils.Free;
  end;
end;

function TACBrJWTAuth.Base64UrlEncode(const AInput: String; AEncodeBase64 : boolean = true): String;
begin
  Result := AInput;
  if AEncodeBase64 then
    Result := synacode.EncodeBase64(Result);
  Result := StringReplace(Result, '+', '-', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '=', '', [rfReplaceAll]);
end;

function TACBrJWTAuth.GenerateJWT(const APayload: String): String;
var
  LHeader, LToken, LSignature: String;
  LACBrOpenSSLUtils : TACBrOpenSSLUtils;
begin
  LHeader := '{"alg": "RS256","typ": "JWT"}';
  LToken := Base64UrlEncode(AnsiString(LHeader)) + '.' + Base64UrlEncode(AnsiString(APayload));
  LACBrOpenSSLUtils := TACBrOpenSSLUtils.Create(nil);
  try
    LACBrOpenSSLUtils.LoadPrivateKeyFromString(FSecretKey);
    LSignature := Base64UrlEncode(LACBrOpenSSLUtils.CalcHashFromString(LToken, algSHA256, sttBase64, True), False);
  finally
    LACBrOpenSSLUtils.Free;
  end;
  Result := LToken + '.' + LSignature;
end;

function TACBrJWTAuth.ValidateJWT(const AToken: String): Boolean;
var
  LHeaderPayload, LSignature, LExpectedSignature: String;
  LPosDelimiter: Integer;
begin

  LPosDelimiter := PosLast('.', AToken);
  LHeaderPayload := Copy(AToken, 1, LPosDelimiter - 1);
  LSignature := Copy(AToken, LPosDelimiter + 1, Length(AToken) - LPosDelimiter);
  LExpectedSignature := synacode.EncodeBase64(HMACSHA256(LHeaderPayload, FSecretKey));

  Result := LExpectedSignature = LSignature;
end;


end.
