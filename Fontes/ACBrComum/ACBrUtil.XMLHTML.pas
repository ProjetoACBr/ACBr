{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
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
{                                                                              }
{  Algumas fun�oes dessa Unit foram extraidas de outras Bibliotecas, veja no   }
{ cabe�alho das Fun�oes no c�digo abaixo a origem das informa�oes, e autores...}
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

{$IFDEF FPC}
 {$IFNDEF NOGUI}
  {$DEFINE USE_LCLIntf}
 {$ENDIF}
{$ENDIF}

unit ACBrUtil.XMLHTML;

interface

Uses
  SysUtils, Math, Classes,
  ACBrBase, ACBrConsts, IniFiles,
  {$IfDef COMPILER6_UP} StrUtils, DateUtils {$Else} ACBrD5, FileCtrl {$EndIf}
  {$IfDef FPC}
    ,dynlibs, LazUTF8, LConvEncoding, LCLType
    {$IfDef USE_LCLIntf} ,LCLIntf {$EndIf}
  {$EndIf}
  {$IfDef MSWINDOWS}
    ,Windows, ShellAPI
  {$Else}
    {$IfNDef FPC}
      {$IfDef ANDROID}
      ,System.IOUtils
      {$EndIf}
      {$IfDef  POSIX}
      ,Posix.Stdlib
      ,Posix.Unistd
      ,Posix.Fcntl
      {$Else}
      ,Libc
      {$EndIf}
    {$Else}
      ,unix, BaseUnix
    {$EndIf}
    {$IfNDef NOGUI}
      {$IfDef FMX}
        ,FMX.Forms
      {$Else}
        ,Forms
      {$EndIf}
    {$EndIf}
  {$EndIf} ;

const
  // Array contendo as HTML entities a serem tratadas
  HTML_ENTITIES_ARRAY: array[0..57] of string = (
    '&nbsp;', '&amp;', '&lt;', '&gt;', '&quot;', '&#39;',
    '&cent;', '&pound;', '&yen;', '&euro;', '&copy;', '&reg;',
    '&Agrave;', '&Aacute;', '&Acirc;', '&Atilde;', '&Auml;', '&Ccedil;',
    '&Egrave;', '&Eacute;', '&Ecirc;', '&Euml;',
    '&Igrave;', '&Iacute;', '&Icirc;', '&Iuml;',
    '&Ograve;', '&Oacute;', '&Ocirc;', '&Otilde;', '&Ouml;',
    '&Ugrave;', '&Uacute;', '&Ucirc;', '&Uuml;',
    '&agrave;', '&aacute;', '&acirc;', '&atilde;', '&auml;',
    '&ccedil;',
    '&egrave;', '&eacute;', '&ecirc;', '&euml;',
    '&igrave;', '&iacute;', '&icirc;', '&iuml;',
    '&ograve;', '&oacute;', '&ocirc;', '&otilde;', '&ouml;',
    '&ugrave;', '&uacute;', '&ucirc;', '&uuml;'
  );

  // Array com os s�mbolos correspondentes �s HTML entities acima
  HTML_SYMBOLS_ARRAY: array[0..57] of string = (
    ' ', '&', '<', '>', '"', '''',
    '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�',
    '�', '�', '�', '�',
    '�', '�', '�', '�', '�',
    '�', '�', '�', '�',
    '�', '�', '�', '�', '�',
    '�',
    '�', '�', '�', '�',
    '�', '�', '�', '�',
    '�', '�', '�', '�', '�',
    '�', '�', '�', '�'
  );


function ParseText( const Texto : AnsiString; const Decode : Boolean = True;
   const IsUTF8: Boolean = True) : String;

function LerTagXML( const AXML, ATag: String; IgnoreCase: Boolean = True) : String; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o m�todo SeparaDados()' {$ENDIF};
function XmlEhUTF8(const AXML: String): Boolean;
function XmlEhUTF8BOM(const AXML: String): Boolean;
function ConverteXMLtoUTF8(const AXML: String): String;
function ConverteXMLtoNativeString(const AXML: String): String;
function ObtemDeclaracaoXML(const AXML: String): String;
function RemoverDeclaracaoXML(const AXML: String; aTodas: Boolean = False): String;
function InserirDeclaracaoXMLSeNecessario(const AXML: String;
   const ADeclaracao: String = CUTF8DeclaracaoXML): String;

function SeparaDados(const AString: String; const Chave: String; const MantemChave : Boolean = False;
  const PermitePrefixo: Boolean = True; const AIgnoreCase: Boolean = True) : String;
function SeparaDadosArray(const AArray: Array of String; const AString: String; const MantemChave: Boolean = False;
  const PermitePrefixo: Boolean = True; const AIgnoreCase: Boolean = True) : String;
procedure EncontrarInicioFinalTag(const aText, ATag: String; var PosIni, PosFim: integer;const PosOffset: integer = 0);
function StripHTML(const AHTMLString : String) : String;
procedure AcharProximaTag(const ABinaryString: AnsiString; const PosIni: Integer; var ATag: AnsiString; var PosTag: Integer);

function FiltrarTextoXML(const RetirarEspacos: boolean; aTexto: String;
  RetirarAcentos: boolean = True; SubstituirQuebrasLinha: Boolean = True;
  const QuebraLinha: String = ';'): String;
function ReverterFiltroTextoXML(aTexto: String): String;
function GetNamedEntity(const Entity: string): string;
function DecodeHTMLEntities(const S: string): string;
function xml4line(texto: String): String;

implementation

uses
  ACBrUtil.Compatibilidade, ACBrUtil.Base, ACBrUtil.Strings,
  ACBrUtil.Math,
  StrUtilsEx;

{------------------------------------------------------------------------------
   Realiza o tratamento de uma String recebida de um Servi�o Web
   Transforma caracteres HTML Entity em ASCII ou vice versa.
   No caso de decodifica��o, tamb�m transforma o Encoding de UTF8 para a String
   nativa da IDE
 ------------------------------------------------------------------------------}
function ParseText( const Texto : AnsiString; const Decode : Boolean = True;
   const IsUTF8: Boolean = True ) : String;
var
  AStr: String;

  function InternalStringReplace(const S, OldPatern, NewPattern: String ): String;
  begin
    if pos(OldPatern, S) > 0 then
      Result := FastStringReplace(S, OldPatern, ACBrStr(NewPattern), [rfReplaceAll])
    else
      Result := S;
  end;

begin
  if Decode then
  begin
    Astr := DecodeToString( Texto, IsUTF8 ) ;

    Astr := InternalStringReplace(AStr, '&amp;'   , '&');
    AStr := InternalStringReplace(AStr, '&lt;'    , '<');
    AStr := InternalStringReplace(AStr, '&gt;'    , '>');
    AStr := InternalStringReplace(AStr, '&quot;'  , '"');
    AStr := InternalStringReplace(AStr, '&#39;'   , #39);
    AStr := InternalStringReplace(AStr, '&#45;'   , '-');
    AStr := InternalStringReplace(AStr, '&aacute;', '�');
    AStr := InternalStringReplace(AStr, '&Aacute;', '�');
    AStr := InternalStringReplace(AStr, '&acirc;' , '�');
    AStr := InternalStringReplace(AStr, '&Acirc;' , '�');
    AStr := InternalStringReplace(AStr, '&atilde;', '�');
    AStr := InternalStringReplace(AStr, '&Atilde;', '�');
    AStr := InternalStringReplace(AStr, '&agrave;', '�');
    AStr := InternalStringReplace(AStr, '&Agrave;', '�');
    AStr := InternalStringReplace(AStr, '&eacute;', '�');
    AStr := InternalStringReplace(AStr, '&Eacute;', '�');
    AStr := InternalStringReplace(AStr, '&ecirc;' , '�');
    AStr := InternalStringReplace(AStr, '&Ecirc;' , '�');
    AStr := InternalStringReplace(AStr, '&iacute;', '�');
    AStr := InternalStringReplace(AStr, '&Iacute;', '�');
    AStr := InternalStringReplace(AStr, '&oacute;', '�');
    AStr := InternalStringReplace(AStr, '&Oacute;', '�');
    AStr := InternalStringReplace(AStr, '&otilde;', '�');
    AStr := InternalStringReplace(AStr, '&Otilde;', '�');
    AStr := InternalStringReplace(AStr, '&ocirc;' , '�');
    AStr := InternalStringReplace(AStr, '&Ocirc;' , '�');
    AStr := InternalStringReplace(AStr, '&uacute;', '�');
    AStr := InternalStringReplace(AStr, '&Uacute;', '�');
    AStr := InternalStringReplace(AStr, '&uuml;'  , '�');
    AStr := InternalStringReplace(AStr, '&Uuml;'  , '�');
    AStr := InternalStringReplace(AStr, '&ccedil;', '�');
    AStr := InternalStringReplace(AStr, '&Ccedil;', '�');
    AStr := InternalStringReplace(AStr, '&apos;'  , '''');

    if IsUTF8 then
      Result := NativeStringToUTF8(AStr)
    else
      Result := AStr;
  end
  else
  begin
    AStr := string(Texto);
    AStr := StringReplace(AStr, '&', '&amp;' , [rfReplaceAll]);
    AStr := StringReplace(AStr, '<', '&lt;'  , [rfReplaceAll]);
    AStr := StringReplace(AStr, '>', '&gt;'  , [rfReplaceAll]);
    AStr := StringReplace(AStr, '"', '&quot;', [rfReplaceAll]);
    AStr := StringReplace(AStr, #39, '&#39;' , [rfReplaceAll]);
    AStr := StringReplace(AStr, '''','&apos;', [rfReplaceAll]);

    Result := AStr;
  end;
end;

{------------------------------------------------------------------------------
   Retorna o conteudo de uma Tag dentro de um arquivo XML
 ------------------------------------------------------------------------------}
function LerTagXML(const AXML, ATag: String; IgnoreCase: Boolean): String;
begin
  Result := SeparaDados(AXML, ATag, False, True, IgnoreCase);
end ;

{------------------------------------------------------------------------------
   Retorna True se o XML cont�m a TAG de encoding em UTF8, no seu in�cio.
 ------------------------------------------------------------------------------}
function XmlEhUTF8(const AXML: String): Boolean;
var
  XmlStart: String;
  P: Integer;
begin
  XmlStart := LowerCase(LeftStr(AXML, 50));
  P := pos('encoding', XmlStart);
  Result := (P > 0) and (pos('utf-8', XmlStart) > P);
end;

{------------------------------------------------------------------------------
   Retorna True se o XML cont�m a os bytes do BOM em seu in�cio;
 ------------------------------------------------------------------------------}
function XmlEhUTF8BOM(const AXML: String): Boolean;
const
  UTF8BOM: array[0..2] of Byte = ($EF, $BB, $BF);
var
  LBytesOfXML: array[0..2] of Byte;
  i: Integer;
begin
  for i := 1 to 3 do
    LBytesOfXML[i-1] := Byte(ord(AXML[i]));

  Result := (LBytesOfXML[0] = UTF8BOM[0]) and
            (LBytesOfXML[1] = UTF8BOM[1]) and
            (LBytesOfXML[2] = UTF8BOM[2]) ;
end;

{------------------------------------------------------------------------------
   Se XML n�o contiver a TAG de encoding em UTF8, no seu in�cio, adiciona a TAG
   e converte o conteudo do mesmo para UTF8 (se necess�rio, dependendo da IDE)
 ------------------------------------------------------------------------------}
function ConverteXMLtoUTF8(const AXML: String): String;
var
  UTF8Str: AnsiString;
begin
  if not XmlEhUTF8(AXML) then   // J� foi convertido antes ou montado em UTF8 ?
  begin
    UTF8Str := NativeStringToUTF8(AXML);
    Result := CUTF8DeclaracaoXML + String(UTF8Str);
  end
  else
    Result := AXML;
end;

{------------------------------------------------------------------------------
   Retorna a Declara��o do XML, Ex: <?xml version="1.0"?>
   http://www.tizag.com/xmlTutorial/xmlprolog.php
 ------------------------------------------------------------------------------}
function ObtemDeclaracaoXML(const AXML: String): String;
var
  P1, P2: Integer;
begin
  Result := '';
  P1 := pos('<?', AXML);
  if P1 > 0 then
  begin
    P2 := PosEx('?>', AXML, P1+2);
    if P2 > 0 then
      Result := copy(AXML, P1, P2-P1+2);
  end;
end;

{------------------------------------------------------------------------------
   Retorna XML sem a Declara��o, Ex: <?xml version="1.0"?>
 ------------------------------------------------------------------------------}
function RemoverDeclaracaoXML(const AXML: String; aTodas: Boolean = False): String;
var
  DeclaracaoXML: String;
begin
  DeclaracaoXML := ObtemDeclaracaoXML(AXML);

  if DeclaracaoXML <> '' then
  begin
    if aTodas then
      Result := FastStringReplace(AXML, DeclaracaoXML, '', [rfReplaceAll])
    else
      Result := FastStringReplace(AXML, DeclaracaoXML, '', []);
  end
  else
    Result := AXML;
end;

{------------------------------------------------------------------------------
   Insere uma Declara��o no XML, caso o mesmo n�o tenha nenhuma
   Se "ADeclaracao" n�o for informado, usar� '<?xml version="1.0" encoding="UTF-8"?>'
 ------------------------------------------------------------------------------}
function InserirDeclaracaoXMLSeNecessario(const AXML: String;
  const ADeclaracao: String): String;
var
  DeclaracaoXML: String;
begin
 Result := AXML;

 // Verificando se a Declara��o informada � v�lida
  if (LeftStr(ADeclaracao,2) <> '<?') or (RightStr(ADeclaracao,2) <> '?>') then
    Exit;

  DeclaracaoXML := ObtemDeclaracaoXML(AXML);
  if EstaVazio(DeclaracaoXML) then
    Result := ADeclaracao + Result;
end;

{------------------------------------------------------------------------------
   Se XML contiver a TAG de encoding em UTF8, no seu in�cio, remove a TAG
   e converte o conteudo do mesmo para String Nativa da IDE (se necess�rio, dependendo da IDE)
 ------------------------------------------------------------------------------}
function ConverteXMLtoNativeString(const AXML: String): String;
begin
  if XmlEhUTF8(AXML) then   // J� foi convertido antes ou montado em UTF8 ?
  begin
    Result := UTF8ToNativeString(AnsiString(AXML));
    {$IfNDef FPC}
     Result := RemoverDeclaracaoXML(Result);
    {$EndIf}
  end
  else
    Result := AXML;
end;

function SeparaDados(const AString: String; const Chave: String; const MantemChave: Boolean = False;
  const PermitePrefixo: Boolean = True; const AIgnoreCase: Boolean = True): String;
var
  PosIni, PosFim: Integer;
  UTexto, UChave: String;
  Prefixo: String;
begin
  Result := '';
  PosFim := 0;
  Prefixo := '';

  if AIgnoreCase then
  begin
    UTexto := AnsiUpperCase(AString);
    UChave := AnsiUpperCase(Chave);
  end
  else
  begin
    UTexto := AString;
    UChave := Chave;
  end;

  PosIni := Pos('<' + UChave, UTexto);
  while (PosIni > 0) and not CharInSet(UTexto[PosIni + Length('<' + UChave)], ['>', ' ']) do
    PosIni := PosEx('<' + UChave, UTexto, PosIni + 1);

  if PosIni > 0 then
  begin
    if MantemChave then
      PosFim := Pos('/' + UChave, UTexto) + length(UChave) + 3
    else
    begin
      PosIni := PosIni + Pos('>', copy(UTexto, PosIni, length(UTexto)));
      PosFim := Pos('/' + UChave + '>', UTexto);
    end;
  end;

  if (PosFim = 0) and PermitePrefixo then
  begin
    PosIni := Pos(':' + Chave, AString);
    if PosIni > 1 then
    begin
      while (PosIni > 1) and (AString[PosIni - 1] <> '<') do
      begin
        Prefixo := AString[PosIni - 1] + Prefixo;
        PosIni := PosIni - 1;
      end;
      Result := SeparaDados(AString, Prefixo + ':' + Chave, MantemChave, False, AIgnoreCase);
    end
  end
  else
    Result := copy(AString, PosIni, PosFim - (PosIni + 1));
end;

function SeparaDadosArray(const AArray: array of String; const AString: String; const MantemChave: Boolean = False;
  const PermitePrefixo: Boolean = True; const AIgnoreCase: Boolean = True): String;
var
  I : Integer;
begin
  Result := '';
 for I:=Low(AArray) to High(AArray) do
 begin
   Result := Trim(SeparaDados(AString,AArray[I], MantemChave, PermitePrefixo, AIgnoreCase));
   if Result <> '' then
      Exit;
 end;
end;

{------------------------------------------------------------------------------
   Retorna a posi��o inicial e final da Tag do XML
 ------------------------------------------------------------------------------}
procedure EncontrarInicioFinalTag(const aText, ATag: String;
  var PosIni, PosFim: integer; const PosOffset: integer = 0);
begin
  PosFim := 0;
  PosIni := PosEx('<' + ATag + '>', aText, PosOffset);
  if (PosIni > 0) then
  begin
    PosIni := PosIni + Length(ATag) + 1;
    PosFim := PosLast('</' + ATag + '>', aText);
    if PosFim < PosIni then
      PosFim := 0;
  end;
end;

{-----------------------------------------------------------------------------
   Localiza uma Tag dentro de uma String, iniciando a busca em PosIni.
   Se encontrar uma Tag, Retorna a mesma em ATag, e a posi��o inicial dela em PosTag
 ---------------------------------------------------------------------------- }
procedure AcharProximaTag(const ABinaryString: AnsiString;
  const PosIni: Integer; var ATag: AnsiString; var PosTag: Integer);
var
  PosTagAux, FimTag, LenTag : Integer ;
begin
  ATag   := '';
  PosTag := PosExA( '<', ABinaryString, PosIni);
  if PosTag > 0 then
  begin
    PosTagAux := PosExA( '<', ABinaryString, PosTag + 1);  // Verificando se Tag � inv�lida
    FimTag    := PosExA( '>', ABinaryString, PosTag + 1);
    if FimTag = 0 then                             // Tag n�o fechada ?
    begin
      PosTag := 0;
      exit ;
    end ;

    while (PosTagAux > 0) and (PosTagAux < FimTag) do  // Achou duas aberturas Ex: <<e>
    begin
      PosTag    := PosTagAux;
      PosTagAux := PosExA( '<', ABinaryString, PosTag + 1);
    end ;

    LenTag := FimTag - PosTag + 1 ;
    ATag   := LowerCase( copy( ABinaryString, PosTag, LenTag ) );
  end ;
end ;

{-----------------------------------------------------------------------------
   Remove todas as TAGS de HTML de uma String, retornando a String alterada
 ---------------------------------------------------------------------------- }
function StripHTML(const AHTMLString: String): String;
var
  ATag, VHTMLString: AnsiString;
  PosTag, LenTag: Integer;
begin
  VHTMLString := AHTMLString;
  ATag   := '';
  PosTag := 0;

  AcharProximaTag( VHTMLString, 1, ATag, PosTag);
  while ATag <> '' do
  begin
    LenTag := Length( ATag );
    Delete(VHTMLString, PosTag, LenTag);

    ATag := '';
    AcharProximaTag( VHTMLString, PosTag, ATag, PosTag );
  end ;
  Result := VHTMLString;
end;

function FiltrarTextoXML(const RetirarEspacos: boolean; aTexto: String;
  RetirarAcentos: boolean; SubstituirQuebrasLinha: Boolean; const QuebraLinha: String): String;
begin
  if RetirarAcentos then
     aTexto := TiraAcentos(aTexto);

  aTexto := ParseText(AnsiString(aTexto), False );

  if RetirarEspacos then
  begin
    while pos('  ', aTexto) > 0 do
      aTexto := StringReplace(aTexto, '  ', ' ', [rfReplaceAll]);
  end;

  if SubstituirQuebrasLinha then
    aTexto := ChangeLineBreak( aTexto, QuebraLinha);

  Result := Trim(aTexto);
end;

function ReverterFiltroTextoXML(aTexto: String): String;
var
  p1,p2:Integer;
  vHex,vStr:String;
  vStrResult:AnsiString;
begin
  if Pos('<![CDATA[', aTexto) > 0 then
  begin
    aTexto := StringReplace(aTexto, '<![CDATA[', '', []);
    aTexto := StringReplace(aTexto, ']]>', '', []);
  end
  else
  begin
    aTexto := StringReplace(aTexto, '&amp;', '&', [rfReplaceAll]);
    aTexto := StringReplace(aTexto, '&lt;', '<', [rfReplaceAll]);
    aTexto := StringReplace(aTexto, '&gt;', '>', [rfReplaceAll]);
    aTexto := StringReplace(aTexto, '&quot;', '"', [rfReplaceAll]);
    aTexto := StringReplace(aTexto, '&#39;', #39, [rfReplaceAll]);
    p1:=Pos('&#x',aTexto);
    while p1>0 do begin
      for p2:=p1 to Length(aTexto) do
          if aTexto[p2]=';' then
             break;
      vHex:=Copy(aTexto,p1,p2-p1+1);
      vStr:=StringReplace(vHex,'&#x','',[rfReplaceAll]);
      vStr:=StringReplace(vStr,';','',[rfReplaceAll]);
      if not TryHexToAscii(vStr, vStrResult) then
        vStrResult := AnsiString(vStr);
      aTexto:=StringReplace(aTexto,vHex,String(vStrResult),[rfReplaceAll]);
      p1:=Pos('&#x',aTexto);
    end;
  end;
  result := Trim(aTexto);
end;


function GetNamedEntity(const Entity: string): string;
var
  i: Integer;
begin
  for i := Low(HTML_ENTITIES_ARRAY) to High(HTML_ENTITIES_ARRAY) do
  begin
    if Entity = HTML_ENTITIES_ARRAY[i] then
    begin
      Result := HTML_SYMBOLS_ARRAY[i];
      Exit;
    end;
  end;
  Result := Entity;
end;

function DecodeHTMLEntities(const S: string): string;
var
  i, j, Code: Integer;
  ResultStr, Entity, NumberStr: string;
begin
  ResultStr := '';
  i := 1;
  while i <= Length(S) do
  begin
    if S[i] = '&' then
    begin
      j := i;
      while (j <= Length(S)) and (S[j] <> ';') do
        Inc(j);
      if j <= Length(S) then
      begin
        Entity := Copy(S, i, j - i + 1);
        if (Length(Entity) >= 3) and (Entity[2] = '#') then
        begin
          if (Length(Entity) > 3) and ((Entity[3] = 'x') or (Entity[3] = 'X')) then
          begin
            try
              Code := StrToInt('$' + Copy(Entity, 4, Length(Entity) - 4));
              ResultStr := ResultStr + ACBrStr(Chr(Code));
            except
              ResultStr := ResultStr + Entity;
            end;
          end
          else
          begin
            try
              NumberStr := Copy(Entity, 3, Length(Entity) - 3);
              Code := StrToInt(NumberStr);
              ResultStr := ResultStr + ACBrStr(Chr(Code));
            except
              ResultStr := ResultStr + Entity;
            end;
          end;
        end
        else
          ResultStr := ResultStr + GetNamedEntity(Entity);
        i := j + 1;
      end
      else
      begin
        ResultStr := ResultStr + S[i];
        Inc(i);
      end;
    end
    else
    begin
      ResultStr := ResultStr + S[i];
      Inc(i);
    end;
  end;
  Result := ResultStr;
end;

{------------------------------------------------------------------------------
   Esta fun��o insere um quebra de linha entre os caracteres >< do xml
   Usada para facilitar os teste de compara��o de arquivos
 ------------------------------------------------------------------------------}
function xml4line(texto: String): String;
var
  xml: TStringList;
  i: integer;
begin
  Texto := Texto + '<';
  Texto := stringreplace(Texto, #$D#$A, '', [rfReplaceAll]);
  Xml := TStringList.create;
  try
    Result := '';
    while length(texto) > 1 do
    begin
      i := pos('><', Texto);
      Xml.Add(copy(Texto, 1, i));
      Texto := copy(Texto, i + 1, maxInt);
    end;
    Result := Xml.Text;
  finally
    Xml.Free;
  end;
end;

end.
