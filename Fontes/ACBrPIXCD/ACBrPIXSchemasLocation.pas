{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
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

  Documenta��o:
  https://github.com/bacen/pix-api

*)

{$I ACBr.inc}

unit ACBrPIXSchemasLocation;

interface

uses
  Classes, SysUtils, ACBrJSON, ACBrPIXBase;

type

  { TACBrPIXLocationBase }

  TACBrPIXLocationBase = class(TACBrPIXSchema)
  private
    fcriacao: TDateTime;
    fcriacao_Bias: Integer;
    fid: Int64;
    fidRec: String;
    flocation: String;
    ftipoCob: TACBrPIXTipoCobranca;
    ftxId: String;
    procedure SetidRec(AValue: String);
    procedure SetTxId(AValue: String);
  protected
    property id: Int64 read fid write fid;
    property txId: String read ftxId write SetTxId;
    property location: String read flocation write flocation;
    property idRec: String read fidRec write SetidRec;

    property criacao: TDateTime read fcriacao;
    property criacao_Bias: Integer read fcriacao_Bias;

    procedure DoWriteToJSon(AJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(AJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXLocationBase);

    property tipoCob: TACBrPIXTipoCobranca read ftipoCob write ftipoCob;
  end;

  { TACBrPIXLocationCobSolicitada }

  TACBrPIXLocationCobSolicitada = class(TACBrPIXLocationBase)
  public
    property id;
  end;

  { TACBrPIXLocation }

  TACBrPIXLocation = class(TACBrPIXLocationBase)
  public
    property id;
    property location;
    property criacao;
    property criacao_Bias;
  end;

  { TACBrPIXLocationCompleta }

  TACBrPIXLocationCompleta = class(TACBrPIXLocationBase)
  public
    property id;
    property txId;
    property location;
    property criacao;
    property criacao_Bias;
  end;

  { TACBrPIXRecLocation }

  TACBrPIXRecLocation = class(TACBrPIXLocationBase)
  public
    property id;
    property location;
    property criacao;
    property criacao_Bias;
    property idRec;
  end;

implementation

uses
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrUtil.Base,
  ACBrPIXUtil;

{ TACBrPIXLocationBase }

constructor TACBrPIXLocationBase.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrPIXLocationBase.Clear;
begin
  fcriacao := 0;
  fcriacao_Bias := 0;
  fid := 0;
  flocation := '';
  ftipoCob := tcoNenhuma;
  ftxId := '';
  fidRec := '';
end;

function TACBrPIXLocationBase.IsEmpty: Boolean;
begin
  Result := (fcriacao = 0) and
            (fcriacao_Bias = 0) and
            (fid = 0) and
            (flocation = '') and
            (ftipoCob = tcoNenhuma) and
            (ftxId = '') and
            (fidRec = '');
end;

procedure TACBrPIXLocationBase.Assign(Source: TACBrPIXLocationBase);
begin
  fcriacao := Source.criacao;
  fcriacao_Bias := Source.criacao_Bias;
  fid := Source.id;
  flocation := Source.location;
  ftipoCob := Source.tipoCob;
  ftxId := Source.txId;
  fidRec := Source.idRec;
end;

procedure TACBrPIXLocationBase.DoWriteToJSon(AJSon: TACBrJSONObject);
begin
  if (fid <> 0) then
    AJSon.AddPair('id', fid, False);
  if (ftipoCob <> tcoNenhuma) then
    AJSon.AddPair('tipoCob', PIXTipoCobrancaToString(ftipoCob));
  if (fcriacao > 0) then
    AJSon.AddPair('criacao', DateTimeToIso8601(fcriacao, BiasToTimeZone(fcriacao_Bias)));

  AJSon
    .AddPair('txid', ftxId, False)
    .AddPair('location', flocation, False)
    .AddPair('idRec', fidRec, False);
end;

procedure TACBrPIXLocationBase.DoReadFromJSon(AJSon: TACBrJSONObject);
var
  s, wC: String;
begin 
  {$IfDef FPC}
  s := EmptyStr;
  wC := EmptyStr;
  {$EndIf}

  AJSon
    .Value('id', fid)
    .Value('txid', ftxId)
    .Value('location', flocation)
    .Value('tipoCob', s)
    .Value('criacao', wC)
    .Value('idRec', fidRec);

  ftipoCob := StringToPIXTipoCobranca(s);

  if NaoEstaVazio(wC) then
  begin
    fcriacao := Iso8601ToDateTime(wC);
    fcriacao_Bias := TimeZoneToBias(wC);
  end;
end;

procedure TACBrPIXLocationBase.SetTxId(AValue: String);
var
  s, e: String;
begin
  if ftxid = AValue then
    Exit;

  s := Trim(AValue);
  if (s <> '') and fIsBacen then
  begin
    e := ValidarTxId(s, 35, 26);
    if (e <> '') then
      raise EACBrPixException.Create(ACBrStr(e));
  end;

  fTxId := s;
end;

procedure TACBrPIXLocationBase.SetidRec(AValue: String);
var
  s, e: String;
begin
  if fidRec = AValue then Exit;

  s := Trim(AValue);
  if NaoEstaVazio(s) and fIsBacen then
  begin
    e := ValidarIdRec(s);
    if NaoEstaVazio(e) then
      raise EACBrPixException.Create(ACBrStr(e));
  end;

  fidRec := s;
end;

end.

