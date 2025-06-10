{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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

unit ACBrTXTClass;

interface

uses
  SysUtils, Classes, DateUtils, Math, Variants, ACBrBase;

type
  EACBrTXTClassErro            = class(Exception) ;

  TErrorEvent = procedure(const MsnError: String) of object;

  { TACBrTXTClass }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrTXTClass = class
  private
    FLinhasBuffer: Integer;
    FNomeArquivo: String;
    FOnError: TErrorEvent;
    FDelimitador: String;     /// Caracter delimitador de campos
    FTrimString: boolean;     /// Retorna a string sem espa�os em branco iniciais e finais
    FCurMascara: String;      /// Mascara para valores tipo currency
    FReplaceDelimitador: boolean; ///remove do texto o caracter delimitador, somente usado no LFill com parametro value:string;

    FConteudo : TStringList;


    procedure AssignError(const MsnError: String);
    procedure SetLinhasBuffer(const AValue: Integer);
    procedure SetNomeArquivo(const AValue: String);
    procedure SetReplaceDelimitador(const Value: boolean);
  public
    constructor Create ;
    destructor Destroy ; override ;

    procedure WriteBuffer ;
    procedure SaveToFile ;
    procedure LoadFromFile ;
    procedure Reset ;
    function Add( const AString : String; AddDelimiter : Boolean = True ) : Integer;
    function DFill(Value: Double;
                   Decimal: Integer = 2;
                   Nulo: Boolean = false): String;
    function LFill(const Value: String;
                   Size: Integer = 0;
                   Nulo: Boolean = false;
                   Caracter: Char = '0'): String; overload;
    function LFill(Value: Extended;
                   Size: Integer;
                   Decimal: Integer = 2;
                   Nulo: Boolean = false;
                   Caracter: Char = '0';
                   const Mascara: String = ''): String; overload;
    function LFill(Value: Int64; Size: Integer; Nulo: Boolean = false; Caracter: Char = '0'): String; overload;
    function LFill(Value: TDateTime; const Mask: String = 'ddmmyyyy'; Nulo: Boolean = True): String; overload;
    function RFill(const Value: String;
                   Size: Integer = 0;
                   Caracter: Char = ' '): String;

    function VDFill(Value: Variant;
                    Decimal: Integer = 2): String;
    function VLFill(Value: Variant;
                    Size: Integer;
                    Decimal: Integer = 2;
                    Caracter: Char = '0';
                    const Mascara: String = ''): String;
    ///
    procedure Check(Condicao: Boolean; const Msg: String); overload;
    procedure Check(Condicao: Boolean; const Msg: String; Fmt: array of const); overload;
    ///
    property NomeArquivo : String read FNomeArquivo write SetNomeArquivo ;
    property LinhasBuffer : Integer read FLinhasBuffer write SetLinhasBuffer ;
    property Delimitador: String read FDelimitador write FDelimitador;
    property ReplaceDelimitador:boolean read FReplaceDelimitador write SetReplaceDelimitador;
    property TrimString: boolean read FTrimString write FTrimString;
    property CurMascara: String read FCurMascara write FCurMascara;
    property OnError: TErrorEvent read FOnError write FOnError;

    property Conteudo : TStringList read FConteudo write FConteudo;
  end;

implementation

Uses
  {$IFDEF MSWINDOWS} Windows, {$ENDIF MSWINDOWS}
  ACBrUtil.Base,
  ACBrConsts, ACBrUtil.Strings, ACBrUtil.FilesIO ;

(* TACBrTXTClass *)

constructor TACBrTXTClass.Create;
begin
   FConteudo           := TStringList.Create ;
   {$IFDEF FPC}
   FConteudo.LineBreak := CRLF;
   {$ELSE}
     {$IFDEF DELPHI2006_UP}
     FConteudo.LineBreak := CRLF;
     {$ENDIF}
   {$ENDIF}
   FOnError            := Nil;
   FNomeArquivo        := '';
   FDelimitador        := '';
   FTrimString         := False;
   FCurMascara         := '';
   FLinhasBuffer       := 0 ; // 0 = Sem tratamento de buffer
   FReplaceDelimitador := False;
end;

destructor TACBrTXTClass.Destroy;
begin
  FConteudo.Free;

  inherited destroy;
end;

procedure TACBrTXTClass.WriteBuffer;
var
  FS : TFileStream ;
begin
  if NomeArquivo = '' then
     raise EACBrTXTClassErro.Create( ACBrStr('"NomeArquivo" n�o especificado') ) ;

  if (not FileExists( NomeArquivo )) then
     {$IFDEF UNICODE}
      WriteToTXT( NomeArquivo, FConteudo.Text, False, False )
     {$ELSE}
      FConteudo.SaveToFile( NomeArquivo ) // SaveToFile nativo deixa arquivo como UTF-8
     {$ENDIF}
  else
   begin
      FS := TFileStream.Create( NomeArquivo, fmOpenReadWrite or fmShareExclusive );
      try
         FS.Seek(0, soEnd);  // vai para EOF
         FConteudo.SaveToStream( FS );
      finally
         FS.Free ;
      end;
   end;

  if (FLinhasBuffer > 0) then
     FConteudo.Clear;
end;

procedure TACBrTXTClass.SaveToFile ;
begin
  WriteBuffer;
end;

procedure TACBrTXTClass.LoadFromFile ;
begin
   if NomeArquivo = '' then
      raise EACBrTXTClassErro.Create( ACBrStr('"Nome do Arquivo" n�o especificado') ) ;

   FConteudo.LoadFromFile( NomeArquivo );
end;

procedure TACBrTXTClass.Reset;
begin
   FConteudo.Clear;

   if FNomeArquivo <> '' then
      if FileExists( FNomeArquivo ) then
         SysUtils.DeleteFile( FNomeArquivo );
end;

function TACBrTXTClass.Add(const AString: String; AddDelimiter: Boolean
   ): Integer;
Var
  S : String ;
begin
   if TrimString then
     S := Trim( AString )
   else
     S := AString;

   Result := -1 ;
   if S = '' then
     exit ;

   if AddDelimiter then
     S := S + Delimitador;

   Result := FConteudo.Add( S );

   if FLinhasBuffer > 0 then
      if FConteudo.Count >= FLinhasBuffer then
         WriteBuffer ;
end;

procedure TACBrTXTClass.Check(Condicao: Boolean; const Msg: String);
begin
  if not Condicao then AssignError(Msg);
end;

procedure TACBrTXTClass.Check(Condicao: Boolean; const Msg: String; Fmt: array of const);
begin
  Check(Condicao, Format(Msg, Fmt));
end;

function TACBrTXTClass.RFill(const Value: String;
                             Size: Integer = 0;
                             Caracter: Char = ' '): String;
begin
  Result := Value;
  /// Se a propriedade TrimString = true, Result retorna sem espa�os em branco
  /// iniciais e finais.
  if FTrimString then
     Result := Trim(Result);

  if (Size > 0) and (Length(Result) > Size) then
     Result := Copy(Result, 1, Size)
  else
     Result := Result + StringOfChar(Caracter, Size - Length(Result));

  if Caracter = '?' then
     Result := FDelimitador + StringReplace(Result, ' ', Caracter, [rfReplaceAll])
  else
     Result := FDelimitador + Result;
end;

function TACBrTXTClass.LFill(const Value: String;
                             Size: Integer = 0;
                             Nulo: Boolean = false;
                             Caracter: Char = '0'): String;
begin
  if (Nulo) and (Length(Value) = 0) then
  begin
     Result := FDelimitador;
     Exit;
  end;
  if FReplaceDelimitador then
    Result := StringReplace(Value,FDelimitador,'',[rfReplaceAll])
  else
    Result := Value;
  /// Se a propriedade TrimString = true, Result retorna sem espa�os em branco
  /// iniciais e finais.
  if FTrimString then
     Result := Trim(Result);

  if (Size > 0) and (Length(Result) > Size) then
     Result := Copy(Result, 1, Size)
  else
     Result := StringOfChar(Caracter, Size - Length(Result)) + Result;

  Result := FDelimitador + Result;
end;

function TACBrTXTClass.LFill(Value: Extended;
                        Size: Integer;
                        Decimal: Integer = 2;
                        Nulo: Boolean = false;
                        Caracter: Char = '0';
                        const Mascara: String = ''): String;
var
strCurMascara: string;
AStr: String;
begin
  strCurMascara := FCurMascara;
  // Se recebeu uma mascara como parametro substitue a principal
  if Mascara <> '' then
     strCurMascara := Mascara;

  /// Se o parametro Nulo = true e Value = 0, ser� retornado '|'
  if (Nulo) and (Value = 0) then
  begin
     Result := FDelimitador;
     Exit;
  end;

  if (strCurMascara <> '#') and (strCurMascara <> '') then
     Result := FDelimitador + FormatCurr(strCurMascara, Value)
  else
  begin
     AStr := FormatFloatBr(Value, FloatMask(Decimal, False));
     if Decimal > 0 then
       Delete( AStr, Length(AStr)-Decimal, 1) ;

     if Nulo then
       Result := LFill(StrToInt64(AStr), Size, Nulo, Caracter)
     else
       Result := LFill(AStr, Size, Nulo, Caracter);
  end;
end;

function TACBrTXTClass.DFill(Value: Double;
                        Decimal: Integer = 2;
                        Nulo: Boolean = false): String;
begin
  /// Se o parametro Nulo = true e Value = 0, ser� retornado '|'
  if (Nulo) and (Value = 0) then
  begin
     Result := FDelimitador;
     Exit;
  end;
  Result := FDelimitador + FormatFloatBr(Value, FloatMask(Decimal, False)); //FormatCurr n�o permite precis�o acima de 4 casas decimais
end;

function TACBrTXTClass.VDFill(Value: Variant;
                        Decimal: Integer = 2): String;
begin
  /// Se o parametro Value � Null ou Undefined ser� retornado '|'
  if VarIsNull(Value) or VarIsEmpty(Value) then
  begin
     Result := FDelimitador;
     Exit;
  end;
  Result := FDelimitador + FormatFloatBr(Value, FloatMask(Decimal, False)); //FormatCurr n�o permite precis�o acima de 4 casas decimais
end;

function TACBrTXTClass.LFill(Value: Int64; Size: Integer; Nulo: Boolean;
  Caracter: Char): String;
begin
  /// Se o parametro Nulo = true e Value = 0, ser� retornado '|'
  if (Nulo) and (Value = 0) then
  begin
     Result := FDelimitador;
     Exit;
  end;
  Result := LFill(IntToStr(Value), Size, False, Caracter);
end;

function TACBrTXTClass.LFill(Value: TDateTime; const Mask: String = 'ddmmyyyy'; Nulo: Boolean = True): String;
begin
  /// Se o parametro Value = 0, ser� retornado '|'
  if (Nulo) and (Value = 0) then
  begin
     Result := FDelimitador;
     Exit;
  end;
  Result := FDelimitador + FormatDateTime(Mask, Value);
end;

procedure TACBrTXTClass.AssignError(const MsnError: String);
begin
  if Assigned(FOnError) then FOnError( ACBrStr(MsnError) );
end;

procedure TACBrTXTClass.SetLinhasBuffer(const AValue: Integer);
begin
   if FLinhasBuffer = AValue then exit;
   FLinhasBuffer := max(AValue,0);   // Sem valores negativos
end;

procedure TACBrTXTClass.SetNomeArquivo(const AValue: String);
begin
   if FNomeArquivo = AValue then exit;
   FNomeArquivo := AValue;
end;

procedure TACBrTXTClass.SetReplaceDelimitador(const Value: boolean);
begin
  FReplaceDelimitador := Value;
end;

function TACBrTXTClass.VLFill(Value: Variant;
                             Size: Integer;
                             Decimal: Integer;
                             Caracter: Char;
                             const Mascara: String): String;
var
AExt: Extended;
begin
  // Se o parametro Value = Null ou n�o foi preenchido ser� retornado '|'
  if VarIsNull(Value) or VarIsEmpty(Value) then
  begin
     Result := FDelimitador;
     Exit;
  end;

  // Checa se � um valor num�rico
  if not VarIsNumeric(Value) then
     raise EACBrTXTClassErro.Create( ACBrStr('Par�metro "Value" n�o possui um valor num�rico.'));

  AExt := Value;

  Result := LFill(AExt, Size, Decimal, False, Caracter, Mascara);
end;

end.
