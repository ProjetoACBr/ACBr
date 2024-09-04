{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

{$I ACBr.inc}

unit ACBrAPIBase;

interface

uses
  Classes, SysUtils, ACBrJSON, ACBrBase;

resourcestring
  sErroMetodoNaoImplementado = 'M�todo %s n�o implementado para Classe %s';

type

  EACBrAPIException = class(EACBrException);

  { TACBrAPISchema }

  TACBrAPISchema = class
  private
    function GetAsJSON: String; virtual;
    procedure SetAsJSON(AValue: String); virtual;

    function GetJSONContext(AJSon: TACBrJSONObject): TACBrJSONObject;
  protected
    fpObjectName: String;

    procedure AssignSchema(ASource: TACBrAPISchema); virtual;
    procedure DoWriteToJSon(AJSon: TACBrJSONObject); virtual;
    procedure DoReadFromJSon(AJSon: TACBrJSONObject); virtual;

  public
    constructor Create(const ObjectName: String = ''); virtual;
    procedure Clear; virtual;
    function IsEmpty: Boolean; virtual;
    procedure WriteToJSon(AJSon: TACBrJSONObject);
    procedure ReadFromJSon(AJSon: TACBrJSONObject);

    property AsJSON: String read GetAsJSON write SetAsJSON;
  end;

  { TACBrAPISchemaArray }

  TACBrAPISchemaArray = class(TACBrObjectList)
  private
    function GetAsJSON: String;
    procedure SetAsJSON(AValue: String);
  protected
    fpArrayName: String;
    function NewSchema: TACBrAPISchema; virtual;
  public
    constructor Create(const ArrayName: String);
    procedure Clear; override;
    function IsEmpty: Boolean; virtual;
    procedure Assign(Source: TACBrObjectList); virtual;

    procedure WriteToJSon(AJSon: TACBrJSONObject); virtual;
    procedure ReadFromJSon(AJSon: TACBrJSONObject); virtual;

    property AsJSON: String read GetAsJSON write SetAsJSON;
  end;

implementation

uses
  ACBrUtil.Strings;

{ TACBrAPISchema }

constructor TACBrAPISchema.Create(const ObjectName: String);
begin
  inherited Create;
  fpObjectName := ObjectName;
  Clear;
end;

procedure TACBrAPISchema.Clear;
begin
  raise EACBrAPIException.CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['Clear', ClassName]);
end;

function TACBrAPISchema.IsEmpty: Boolean;
begin
  Result := False;
end;

procedure TACBrAPISchema.AssignSchema(ASource: TACBrAPISchema);
begin
  raise EACBrAPIException.CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['AssignSchema', ClassName]);
end;

function TACBrAPISchema.GetAsJSON: String;
var
  js: TACBrJSONObject;
begin
  js := TACBrJSONObject.Create;
  try
    WriteToJSon(js);
    Result := js.ToJSON;
  finally
    js.Free;
  end;
end;

procedure TACBrAPISchema.SetAsJSON(AValue: String);
var
  js: TACBrJSONObject;
begin
  Clear;
  js := TACBrJSONObject.Parse(AValue) as TACBrJSONObject;
  try
    ReadFromJSon(js);
  finally
    js.Free;
  end;
end;

function TACBrAPISchema.GetJSONContext(AJSon: TACBrJSONObject): TACBrJSONObject;
begin
  if (fpObjectName <> '') then
  begin
    Result := AJSon.AsJSONObject[fpObjectName];
    if (not Assigned(Result)) then
    begin
      AJSon.AddPairJSONObject(fpObjectName, EmptyStr);
      Result := AJSon.AsJSONObject[fpObjectName];
    end;
  end
  else
    Result := AJSon;
end;

procedure TACBrAPISchema.WriteToJSon(AJSon: TACBrJSONObject);
begin
  if IsEmpty then
    Exit;

  if Assigned(GetJSONContext(AJSon)) then
    DoWriteToJSon(GetJSONContext(AJSon));
end;

procedure TACBrAPISchema.DoWriteToJSon(AJSon: TACBrJSONObject);
begin
  raise EACBrAPIException.CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['DoWriteToJSon', ClassName]);
end;

procedure TACBrAPISchema.ReadFromJSon(AJSon: TACBrJSONObject);
begin
  Clear;
  DoReadFromJSon(GetJSONContext(AJSon));
end;

procedure TACBrAPISchema.DoReadFromJSon(AJSon: TACBrJSONObject);
begin
  raise EACBrAPIException.CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['DoReadFromJSon', ClassName]);
end;

{ TACBrAPISchemaArray }

constructor TACBrAPISchemaArray.Create(const ArrayName: String);
begin
  inherited Create(True);
  fpArrayName := ArrayName;
end;

procedure TACBrAPISchemaArray.Clear;
begin
  inherited Clear;
end;

function TACBrAPISchemaArray.IsEmpty: Boolean;
begin
  Result := (Count < 1);
end;

function TACBrAPISchemaArray.NewSchema: TACBrAPISchema;
begin
  {$IfDef FPC}Result := Nil;{$EndIf}
  raise EACBrAPIException.CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['NewSchema', ClassName]);
end;

procedure TACBrAPISchemaArray.Assign(Source: TACBrObjectList);
var
  i: Integer;
begin
  Clear;
  for i := 0 to Source.Count-1 do
    NewSchema.AssignSchema(TACBrAPISchema(Source[i]));
end;

procedure TACBrAPISchemaArray.WriteToJSon(AJSon: TACBrJSONObject);
var
  i: Integer;
  ja: TACBrJsonArray;
begin
  if IsEmpty then
    Exit;

  ja := TACBrJSONArray.Create;
  try
    for i := 0 to Count - 1 do
      ja.AddElementJSONString(TACBrAPISchema(Items[i]).AsJSON);

    AJSon.AddPair(fpArrayName, ja);
  except
    ja.Free;
    raise;
  end;
end;

procedure TACBrAPISchemaArray.ReadFromJSon(AJSon: TACBrJSONObject);
var
  i: Integer;
  ja: TACBrJsonArray;
begin
  Clear;

  ja := AJSon.AsJSONArray[fpArrayName];
  for i := 0 to ja.Count - 1 do
    NewSchema.ReadFromJSon(ja.ItemAsJSONObject[i]);
end;

function TACBrAPISchemaArray.GetAsJSON: String;
var
  js: TACBrJSONObject;
begin
  js := TACBrJSONObject.Create;
  try
    WriteToJSon(js);
    Result := js.ToJSON;
  finally
    js.Free;
  end;
end;

procedure TACBrAPISchemaArray.SetAsJSON(AValue: String);
var
  js: TACBrJSONObject;
begin
  Clear;
  js := TACBrJSONObject.Parse(AValue) as TACBrJSONObject;
  try
    ReadFromJSon(js);
  finally
    js.Free;
  end;
end;

end.

