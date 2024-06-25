{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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
unit ACBrConsultaCNPJ.WS;

interface
uses
  ACBrJSON,
  SysUtils,
  ACBrValidador,
  httpsend,
  Classes;
type
  TParams =
    record  prName,PrValue:string;
  end;
  EACBrConsultaCNPJWSException = class ( Exception );
  TACBrConsultaCNPJWSResposta = class (TObject)
    NaturezaJuridica     : string ;
    EmpresaTipo          : string;
    Abertura             : TDateTime;
    RazaoSocial          : string;
    Fantasia             : string;
    Porte                : string;
    CNAE1                : string;
    CNAE2                : TStringList;
    Endereco             : string;
    Numero               : string;
    Complemento          : string;
    CEP                  : string;
    Bairro               : string;
    Cidade               : string;
    UF                   : string;
    Situacao             : string;
    SituacaoEspecial     : string;
    CNPJ                 : string;
    DataSituacao         : TDateTime;
    DataSituacaoEspecial : TDateTime;
    EndEletronico        : string;
    Telefone             : string;
    EFR                  : string;
    MotivoSituacaoCad    : string;
    CodigoIBGE           : string;
    InscricaoEstadual    : string;
    CapitalSocial        : Double;
  end;
  { TACBrConsultaCNPJWS }
  TACBrConsultaCNPJWS = class( TObject )
    FCNPJ : string;
    FUsuario : String;
    FSenha : String;
    FResposta : TACBrConsultaCNPJWSResposta;
    FHeaderParamsList : Array of TParams;
    FDefasagemMaxima : Integer;
    FProxyHost: String;
    FProxyPort: String;
    FProxyUser: String;
    FProxyPass: String;
    private
    FHTTPSend: THTTPSend;
    FResultString : String;
    public
      constructor Create(const ACNPJ : string; const AUsuario : string = ''; const ASenha: string = ''; const ADefasagemMaxima : Integer = 0);
      destructor Destroy; override;
      function Executar : boolean; virtual;
      function SendHttp(const AMethod : string; const AURL : String; out LRetorno : String):Integer;
      function AddHeaderParam(const AParamName, AParamValue : String) : TACBrConsultaCNPJWS;
      procedure ClearHeaderParams;

      property ProxyHost: String read FProxyHost;
      property ProxyPort: String read FProxyPort;
      property ProxyUser: String read FProxyUser;
      property ProxyPass: String read FProxyPass;
      property ResultString: String read FResultString;

  end;
implementation

uses
  blcksock,
  synautil,
  ACBrUtil.XMLHTML;

{ TACBrConsultaCNPJWS }

function TACBrConsultaCNPJWS.AddHeaderParam(const AParamName, AParamValue: String): TACBrConsultaCNPJWS;
begin
  Result := Self;
  SetLength(FHeaderParamsList,Length(FHeaderParamsList)+1);
  FHeaderParamsList[Length(FHeaderParamsList)-1].prName  := AParamName;
  FHeaderParamsList[Length(FHeaderParamsList)-1].prValue := AParamValue;
end;

procedure TACBrConsultaCNPJWS.ClearHeaderParams;
begin
  SetLength(FHeaderParamsList,0);
end;

constructor TACBrConsultaCNPJWS.Create(const ACNPJ : string; const AUsuario : string = ''; const ASenha: string = ''; const ADefasagemMaxima : Integer = 0);
begin
  FCNPJ     := ACNPJ;
  FUsuario  := AUsuario;
  FSenha    := ASenha;
  FResposta := TACBrConsultaCNPJWSResposta.Create;
  FResposta.CNAE2     := TStringList.Create;
  FDefasagemMaxima := ADefasagemMaxima;
end;

destructor TACBrConsultaCNPJWS.Destroy;
begin
  FResposta.CNAE2.Free;
  FResposta.Free;
  inherited;
end;

function TACBrConsultaCNPJWS.Executar: boolean;
var LErro : String;
begin
  Result := False;
  LErro := ValidarCNPJ( FCNPJ ) ;
  if LErro <> '' then
    raise EACBrConsultaCNPJWSException.Create(LErro);
end;

function TACBrConsultaCNPJWS.SendHttp(const AMethod: string; const AURL: String; out LRetorno: String): Integer;
var
  LStream : TStringStream;
  LHeaders : TStringList;
  I : Integer;
begin
  FHTTPSend := THTTPSend.Create;
  LStream  := TStringStream.Create('');
  try
    FHTTPSend.Clear;

    FHTTPSend.ProxyHost := ProxyHost;
    FHTTPSend.ProxyPort := ProxyPort;
    FHTTPSend.ProxyUser := ProxyUser;
    FHTTPSend.ProxyPass := ProxyPass;
    FHTTPSend.OutputStream := LStream;

    FHTTPSend.Headers.Clear;
    FHTTPSend.Headers.Add('Accept: application/json');

    LHeaders := TStringList.Create;
    try
      for I := 0  to Length(FHeaderParamsList) -1 do
        LHeaders.Add(FHeaderParamsList[I].prName+': '+FHeaderParamsList[I].prValue);
      FHTTPSend.Headers.AddStrings(LHeaders);
    finally
      LHeaders.Free;
    end;

    FHTTPSend.Sock.SSL.SSLType := LT_TLSv1_2;

    FHTTPSend.HTTPMethod(AMethod, AURL);

    FHTTPSend.Document.Position:= 0;

    LRetorno := ReadStrFromStream(LStream, LStream.Size);

    Result := FHTTPSend.ResultCode;
    FResultString := ParseText( FHTTPSend.ResultString );
    if (Result >= 300) then
      FResultString := FResultString +' '+ FHTTPSend.Sock.LastErrorDesc;

  finally
    LStream.Free;
    FHTTPSend.Free;
  end;
end;

end.
