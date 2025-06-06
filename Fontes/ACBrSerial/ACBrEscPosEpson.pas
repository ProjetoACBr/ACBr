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

{$I ACBr.inc}

unit ACBrEscPosEpson;

interface

uses
  Classes, SysUtils, Types,
  ACBrPosPrinter, ACBrBase;

const
  MAX_LEN_CMD = 65535;
  cTimeOutTxRxCheque = 2000;

type

  { TACBrEscPosEpson }

  TACBrEscPosEpson = class(TACBrPosPrinterClass)
  protected
    function ComandoEsperaCheque(const SegundosEspera: Byte): AnsiString;
    procedure VerificarKeyCodes; virtual;

  public
    constructor Create(AOwner: TACBrPosPrinter);

    function ComandoFonte(TipoFonte: TACBrPosTipoFonte; Ligar: Boolean): AnsiString;
      override;
    function ComandoCodBarras(const ATag: String; const ACodigo: AnsiString): AnsiString;
      override;
    function ComandoQrCode(const ACodigo: AnsiString): AnsiString; override;
    function ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo): AnsiString;
      override;
    function ComandoGaveta(NumGaveta: Integer = 1): AnsiString; override;
    function ComandoConfiguraModoPagina: AnsiString; override;
    function ComandoPosicionaModoPagina(APoint: TPoint): AnsiString; override;
    function ComandoCarregaCheque(LerCMC7: Boolean=True; SegundosEspera: Byte=5): AnsiString; override;
    function ComandoEjetarCheque: AnsiString; override;

    procedure LerStatus(var AStatus: TACBrPosPrinterStatus); override;
    function LerInfo: String; override;
    function ComandoLerCMC7(SegundosEspera: Byte = 0): AnsiString; override;
    function LeituraCheque: AnsiString; override;

    function ComandoImprimirImagemRasterStr(const RasterStr: AnsiString; AWidth: Integer;
      AHeight: Integer): AnsiString; override;

    function ComandoLogo: AnsiString; override;
    function ComandoGravarLogoRasterStr(const RasterStr: AnsiString; AWidth: Integer;
      AHeight: Integer): AnsiString; override;
    function ComandoApagarLogo: AnsiString; override;
  end;

  function ComandoCodBarrasEscPosEpson(const ATag: String; ACodigo: AnsiString;
    const AMostrarCodigo: Boolean; const AAltura, ALarguraLinha: Integer): AnsiString;
  function ComandoCodBarrasEscPosNo128ABC(const ATag: String; const ACodigo: AnsiString;
    const AMostrarCodigo: Boolean; const AAltura, ALarguraLinha: Integer): AnsiString;

  function ComandoImprimirImagemColumnStr(APosPrinter: TACBrPosPrinter;
    const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer;
    AddLF: Boolean = True): AnsiString;
  function AjustarKeyCodeUnico(AKeyCode: Byte): Byte;
  function ComandoGravarLogoColumnStr(const RasterStr: AnsiString; AWidth: Integer;
    AHeight: Integer; KeyCode: Byte): AnsiString;

implementation

uses
  StrUtils, Math, ACBrImage, ACBrConsts,
  ACBrUtil.FilesIO, ACBrUtil.Strings, ACBrUtil.Math;

function ComandoCodBarrasEscPosEpson(const ATag: String; ACodigo: AnsiString;
  const AMostrarCodigo: Boolean; const AAltura, ALarguraLinha: Integer): AnsiString;
var
  L, A, M : Integer ;
  CmdBarCode: Char;
  ACodBar, Cmd128, Code128c: AnsiString;
  i, s: Integer;
begin
  if ATag = cTagBarraUPCA then
    CmdBarCode := 'A'
  else if ATag = cTagBarraUPCE then
    CmdBarCode := 'B'
  else if ATag = cTagBarraEAN13 then
    CmdBarCode := 'C'
  else if ATag = cTagBarraEAN8 then
    CmdBarCode := 'D'
  else if ATag = cTagBarraCode39 then
    CmdBarCode := 'E'
  else if ATag = cTagBarraInter then
    CmdBarCode := 'F'
  else if ATag = cTagBarraCodaBar then
    CmdBarCode := 'G'
  else if ATag = cTagBarraCode93 then
    CmdBarCode := 'H'
  else if (ATag = cTagBarraCode128) or (ATag = cTagBarraCode128b) then
  begin
    CmdBarCode := 'I';
    Cmd128 := '{B';
  end
  else if ATag = cTagBarraCode128a then
  begin
    CmdBarCode := 'I';
    Cmd128 := '{A';
  end
  else if ATag = cTagBarraCode128c then
  begin
    CmdBarCode := 'I';
    Cmd128 := '{C';

    // Apenas n�meros,
    ACodigo := AnsiString(OnlyNumber(String(ACodigo)));

    s := Length(ACodigo);
    if s mod 2 <> 0 then  // Tamanho deve ser Par
    begin
      ACodigo := '0'+ACodigo;
      Inc(s);
    end;

    Code128c := '';
    i := 1;
    while i < s do
    begin
      Code128c := Code128c + AnsiChr(StrToInt(copy(String(ACodigo),i,2)));
      i := i + 2;
    end;

    ACodigo := Code128c;
  end
  else if ATag = cTagBarraMSI then     // Apenas Bematech suporta
    CmdBarCode := 'R'
  else
  begin
    Result := ACodigo;
    Exit;
  end;

  ACodBar := ACodigo;

  if CmdBarCode = 'I' then // Cod128
  begin
    if Copy(String(ACodBar),1,1) <> '{' then
      ACodBar := Cmd128 + ACodBar;
  end;

  L := IfThen( ALarguraLinha = 0, 2, max(min(ALarguraLinha,4),1) );
  A := IfThen( AAltura = 0, 50, max(min(AAltura,255),1) );
  M := IfThen( AMostrarCodigo, 2, 0 );

  Result := GS + 'w' + AnsiChr( L ) + // Largura
            GS + 'h' + AnsiChr( A ) + // Altura
            GS + 'H' + AnsiChr( M ) + // HRI (numero impresso abaixo do cod.barras)
            GS + 'k' + CmdBarCode + AnsiChr( Length(ACodBar) ) + ACodBar;
end;

function ComandoCodBarrasEscPosNo128ABC(const ATag: String; const ACodigo: AnsiString;
  const AMostrarCodigo: Boolean; const AAltura, ALarguraLinha: Integer): AnsiString;
var
  P: Integer;
  BTag: String;
begin
  // EscBema n�o suporta Code128C
  if (ATag = cTagBarraCode128a) or
     (ATag = cTagBarraCode128b) or
     (ATag = cTagBarraCode128c) then
    BTag := cTagBarraCode128
  else
    BTag := ATag;

  Result := ComandoCodBarrasEscPosEpson(BTag, ACodigo, AMostrarCodigo, AAltura, ALarguraLinha);

  // Sem suporte a nota��o para COD128 A, B e C do padr�o EscPos
  if (BTag = cTagBarraCode128) then
  begin
    P := pos('{',Result);
    if P > 0 then
    begin
      Delete(Result,P,2);
      //Alterando o caracter que cont�m o tamanho do c�digo de barras
      Result[P-1] := AnsiChr(Length(ACodigo));
    end;
  end;
end;

//https://bitbucket.org/bernd_summerswell/delphi_escpos_bitmap/overview
function ComandoImprimirImagemColumnStr( APosPrinter: TACBrPosPrinter;
  const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer;
  AddLF: Boolean): AnsiString;
var
  Slices: TAnsiStringList;
  i: Integer;
  ASlice: AnsiString;
begin
  with APosPrinter do
  begin
    Result := PosPrinter.ComandoEspacoEntreLinhas(16);  // 24 dots

    Slices := TAnsiStringList.Create;
    try
      RasterStrToColumnStr(RasterStr, AWidth, Slices, 3);

      For i := 0 to Slices.Count-1 do
      begin
        ASlice := Slices[i];
        Result := Result + ESC +
                           '*' + // Bit image mode
                           #33 + // 24-dot double density
                           IntToLEStr(AWidth) +
                           ASlice;
        if AddLF then
          Result := Result + LF;
      end;
    finally
      Slices.Free;
    end;

    Result := Result + PosPrinter.ComandoEspacoEntreLinhas( APosPrinter.EspacoEntreLinhas );
  end;
end;

function AjustarKeyCodeUnico(AKeyCode: Byte): Byte;
begin
  if (AKeyCode >= 48) and (AKeyCode <= 57) then  // '0'..'9'
    Result := StrToInt( chr(AKeyCode) )
  else
    Result := AKeyCode;
end;

function ComandoGravarLogoColumnStr( const RasterStr: AnsiString; AWidth: Integer;
  AHeight: Integer; KeyCode: Byte): AnsiString;
var
  SLColumnStr: TAnsiStringList;
  HeightInBytes, LenBuffer, LenK: Integer;
  Buffer: AnsiString;
begin
  if KeyCode <> 1 then
    raise EPosPrinterException.Create(ACBrStr('ACBrPosPrinter gravando Logo em modo Legado (FS q), somente aceita a posi��o "1"'));

  SLColumnStr := TAnsiStringList.Create;
  try
    RasterStrToColumnStr(RasterStr, AWidth, SLColumnStr, 0);
    Buffer := SLColumnStr.Text;
  finally
    SLColumnStr.Free;
  end;

  HeightInBytes := ceil(AHeight/8);
  LenBuffer := Length(Buffer);
  LenK := AWidth*(HeightInBytes*8);
  Buffer := Buffer + StringOfChar(#0, max(LenK - LenBuffer,0));

  Result := FS + 'q' +      // Comando (obsoleto) para grava��o de NV ABit Image (em modo coluna)
                  #1 +      // Uma Imagem
                  IntToLEStr(AWidth)  +
                  IntToLEStr(HeightInBytes) +
                  Buffer;
end;

{ TACBrEscPosEpson }

procedure TACBrEscPosEpson.VerificarKeyCodes;
  procedure VerificarKeyCode(AkeyCode: Integer; NomeKeyCode: String);
  begin
    if (AKeyCode < 32) or (AkeyCode > 126) then
      raise EPosPrinterException.Create(NomeKeyCode+' deve estar entre 32 a 126');
  end;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    VerificarKeyCode(KeyCode1, 'KeyCode1');
    VerificarKeyCode(KeyCode2, 'KeyCode2');
  end;
end;

constructor TACBrEscPosEpson.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscPosEpson';

{(*}
  with Cmd  do
  begin
    Zera                    := ESC + '@';
    PuloDeLinha             := LF;
    PuloDePagina            := FF;
    EspacoEntreLinhasPadrao := ESC + '2';
    EspacoEntreLinhas       := ESC + '3';
    FonteNormal             := ESC + '!' + #0;
    FonteA                  := ESC + 'M' + #0;
    FonteB                  := ESC + 'M' + #1;
    LigaNegrito             := ESC + 'E' + #1;
    DesligaNegrito          := ESC + 'E' + #0;
    LigaExpandido           := GS  + '!' + #16;
    DesligaExpandido        := GS  + '!' + #0;
    LigaAlturaDupla         := GS  + '!' + #1;
    DesligaAlturaDupla      := GS  + '!' + #0;
    LigaSublinhado          := ESC + '-' + #1;
    DesligaSublinhado       := ESC + '-' + #0;
    LigaInvertido           := GS  + 'B' + #1;
    DesligaInvertido        := GS  + 'B' + #0;
    LigaCondensado          := SI;
    DesligaCondensado       := DC2;
    AlinhadoEsquerda        := ESC + 'a' + #0;
    AlinhadoCentro          := ESC + 'a' + #1;
    AlinhadoDireita         := ESC + 'a' + #2;
    CorteTotal              := GS  + 'V' + #0;
    CorteParcial            := GS  + 'V' + #1;
    Beep                    := ESC + '(A' + #5 + #0 + #97 + #100 + #1 + #50 + #50;
    LigaModoPagina          := ESC + 'L';
    DesligaModoPagina       := ESC + 'S';
    ImprimePagina           := ESC + FF;
  end;
  {*)}

  TagsNaoSuportadas.Add( cTagBarraMSI );
  TagsNaoSuportadas.Add( cTagLigaItalico );
  TagsNaoSuportadas.Add( cTagDesligaItalico );
end;

function TACBrEscPosEpson.ComandoFonte(TipoFonte: TACBrPosTipoFonte;
  Ligar: Boolean): AnsiString;
var
  NovoFonteStatus: TACBrPosFonte;
  AByte: Integer;
  AChar: AnsiChar;
begin
  Result := '';
  NovoFonteStatus := fpPosPrinter.FonteStatus;
  if Ligar then
    NovoFonteStatus := NovoFonteStatus + [TipoFonte]
  else
    NovoFonteStatus := NovoFonteStatus - [TipoFonte];

  if TipoFonte in [ftCondensado, ftNegrito, ftExpandido, ftSublinhado, ftAlturaDupla] then
  begin
    AByte := 0;

    if ftCondensado in NovoFonteStatus then
      SetBit(AByte, 0);

    if ftNegrito in NovoFonteStatus then
      SetBit(AByte, 3);

    if ftAlturaDupla in NovoFonteStatus then
      SetBit(AByte, 4);

    if ftExpandido in NovoFonteStatus then
      SetBit(AByte, 5);

    if ftSublinhado in NovoFonteStatus then
      SetBit(AByte, 7);

    Result := ESC + '!';
    AChar := AnsiChr(Byte(AByte));
    Result := Result + AChar;

    // ESC ! desliga Invertido, enviando o comando novamente
    if ftInvertido in NovoFonteStatus then
      Result := Result + Cmd.LigaInvertido;

    if ftItalico in NovoFonteStatus then
      Result := Result + Cmd.LigaItalico;
  end
  else
    Result := inherited ComandoFonte(TipoFonte, Ligar);

end;

function TACBrEscPosEpson.ComandoCodBarras(const ATag: String;
  const ACodigo: AnsiString): AnsiString;
begin
  with fpPosPrinter.ConfigBarras do
  begin
    Result := ComandoCodBarrasEscPosEpson(ATag, ACodigo, MostrarCodigo, Altura, LarguraLinha);
  end ;
end;

function TACBrEscPosEpson.ComandoQrCode(const ACodigo: AnsiString): AnsiString;
begin
  with fpPosPrinter.ConfigQRCode do
  begin
     Result := GS + '(k' + #4 + #0 + '1A' + AnsiString(IntToStr(Tipo)) + #0 +  // Tipo
               GS + '(k' + #3 + #0 + '1C' + AnsiChr(LarguraModulo) +   // Largura Modulo
               GS + '(k' + #3 + #0 + '1E' + AnsiString(IntToStr(ErrorLevel)) + // Error Level
               GS + '(k' + IntToLEStr(length(ACodigo)+3)+'1P0' + ACodigo +  // Codifica
               GS + '(k' + #3 + #0 +'1Q0';  // Imprime
  end;
end;

function TACBrEscPosEpson.ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo
  ): AnsiString;
var
  CmdPag: Integer;
begin
  case APagCodigo of
    pc437: CmdPag := 0;
    pc850: CmdPag := 2;
    pc852: CmdPag := 18;
    pc860: CmdPag := 3;
    pc1252: CmdPag := 16;
  else
    begin
      Result := '';
      Exit;
    end;
  end;

  Result := ESC + 't' + AnsiChr( CmdPag );
end;

function TACBrEscPosEpson.ComandoLogo: AnsiString;
var
  m, KeyCode: Byte;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    {
      Verificando se informou o KeyCode compat�vel com o comando Novo ou Antigo.

      Nota: O Comando novo da Epson "GS + '(L'", n�o � compat�vel em alguns
      Equipamentos (n�o Epson), mas que usam EscPosEpson...
      Nesse caso, vamos usar o comando "FS + 'p'", para tal, informe:
      KeyCode1 := 1..255; KeyCode2 := 0
    }

    if (KeyCode2 = 0) then
    begin
      KeyCode := AjustarKeyCodeUnico(KeyCode1);

      m := 0;
      if FatorX > 1 then
        m := m + 1;
      if Fatory > 1 then
        m := m + 2;

      Result := FS + 'p' + AnsiChr(KeyCode) + AnsiChr(m);
    end
    else
    begin
      VerificarKeyCodes;

      Result := GS + '(L' + #6 + #0 + #48 + #69 +
                AnsiChr(KeyCode1) + AnsiChr(KeyCode2) +
                AnsiChr(FatorX)   + AnsiChr(FatorY);
    end;
  end;
end;

function TACBrEscPosEpson.ComandoGravarLogoRasterStr(
  const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer): AnsiString;
var
  KeyCode: Byte;
  LenCMD: Integer;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    {
      Verificando se informou o KeyCode compat�vel com o comando Novo ou Antigo.

      Nota: O Comando novo da Epson "GS + '(L'", n�o � compat�vel em alguns
      Equipamentos (n�o Epson), mas que usam EscPosEpson...
      Nesse caso, vamos usar o comando "FS + 'q'", para tal, informe:
      KeyCode1 := 1; KeyCode2 := 0
    }

    if (KeyCode2 = 0) then
    begin
      KeyCode := AjustarKeyCodeUnico(KeyCode1);
      Result := ComandoGravarLogoColumnStr(RasterStr, AWidth, AHeight, KeyCode);
    end
    else
    begin
      VerificarKeyCodes;

      // Comando para gravar Raster Img na mem�ria
      Result := #48 + #67 + #48 +   // m + fn + a
                AnsiChr(KeyCode1) + AnsiChr(KeyCode2) +
                #1 +                // b - 1 Cor, Mono
                IntToLEStr(AWidth)  +
                IntToLEStr(AHeight) +
                '1' +               // Inicio cor 1
                RasterStr +
                #1;                 // Fim, cor 1

      LenCMD := Length(Result);

      if LenCMD <= MAX_LEN_CMD then
        Result := GS + '(L' + IntToLEStr(LenCMD) + Result
      else
        Result := GS + '8L' + IntToLEStr(LenCMD,4) + Result;
    end;
  end;
end;

function TACBrEscPosEpson.ComandoApagarLogo: AnsiString;
var
  KeyCode: Byte;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    {
      Verificando se informou o KeyCode compat�vel com o comando Novo ou Antigo.

      Nota: O Comando novo da Epson "GS + '(L'", n�o � compat�vel em alguns
      Equipamentos (n�o Epson), mas que usam EscPosEpson...
      Nesse caso, vamos usar o comando "FS + 'q'", para tal, informe:
      KeyCode1 := 1; KeyCode2 := 0
    }

    if (KeyCode2 = 0) then
    begin
      KeyCode := AjustarKeyCodeUnico(KeyCode1);
      Result := ComandoGravarLogoColumnStr(#0, 1, 1, KeyCode);
    end
    else
    begin
      VerificarKeyCodes;

      Result := GS + '(L' + #4 + #0 + #48 + #66 +
                AnsiChr(KeyCode1) + AnsiChr(KeyCode2);
    end;
  end;
end;

function TACBrEscPosEpson.ComandoGaveta(NumGaveta: Integer): AnsiString;
var
  CharGav: AnsiChar;
begin
  if NumGaveta > 1 then
    CharGav := #1
  else
    CharGav := #0;

  with fpPosPrinter.ConfigGaveta do
  begin
    Result := ESC + 'p' + CharGav + AnsiChar(TempoON) + AnsiChar(TempoOFF);
  end;
end;

function TACBrEscPosEpson.ComandoConfiguraModoPagina: AnsiString;
var
  CharDir: AnsiChar;
begin
  with fpPosPrinter.ConfigModoPagina do
  begin
    //https://stackoverflow.com/questions/42597358/esc-pos-set-page-size-esc-w-cmd
    case Direcao of
      dirBaixoParaTopo: CharDir := #1;
      dirDireitaParaEsquerda: CharDir := #2;
      dirTopoParaBaixo: CharDir := #3;
    else
      CharDir := #0;  // dirEsquerdaParaDireita
    end;

    Result := ESC + 'T' + CharDir +                  // Ajusta a Direcao
              ComandoEspacoEntreLinhas(EspacoEntreLinhas) +
              ESC + 'W' + IntToLEStr(Esquerda) +     // Ajusta a Regiao
                          IntToLEStr(Topo) +
                          IntToLEStr(Largura) +
                          IntToLEStr(Altura);
  end;
end;

function TACBrEscPosEpson.ComandoPosicionaModoPagina(APoint: TPoint): AnsiString;
begin
  Result := ESC + '$' + IntToLEStr(APoint.x)+
            GS  + '$' + IntToLEStr(APoint.y);
end;

function TACBrEscPosEpson.ComandoEsperaCheque(const SegundosEspera: Byte): AnsiString;
begin
  Result := ESC + '=' + #1 +                                 // ESC = n - Select peripheral device, n = 1 Specifies printer only
            ESC + 'f' + #0 + AnsiChr(SegundosEspera * 10) +  // ESC f t1 t2 - Set cut sheet wait time
            ESC + 'J' + #0;                                  // ESC J n - Print and feed paper
end;

function TACBrEscPosEpson.ComandoCarregaCheque(LerCMC7: Boolean; SegundosEspera: Byte): AnsiString;
begin
  if LerCMC7 then
    Result := ComandoLerCMC7
  else
    Result := ComandoEsperaCheque(SegundosEspera);

  Result := Result +
            GS + '(G' +#2+#0+ #48+#4 +    //GS ( G pL pH fn m - <Function 48> - Select the side of the slip (#4 = face or #68 = back).
            GS + '(G' +#2+#0+ #84+#1;     //GS ( G pL pH fn m - <Function 84> - Feed to the print starting position for the slip.;
end;

function TACBrEscPosEpson.ComandoEjetarCheque: AnsiString;
begin
  Result := DLE + ENQ + #3 +   // Real-time request to printer; 3=Cancels the slip waiting status after clearing the receive and print buffers
            #24 +              // CAN Cancel print data in page mode
            Cmd.DesligaModoPagina +
            FS  + 'a2'+        // Ejects check paper in MICR mode
            Cmd.PuloDePagina;  // FF - Eject
end;

function TACBrEscPosEpson.ComandoLerCMC7(SegundosEspera: Byte): AnsiString;
begin
  // FS ( f pL pH [n m]1...[n m]k - Select MICR data handling
  //              #3+#0 -> Header = '_'
  Result := ComandoEsperaCheque(SegundosEspera) +
            FS  + '(f' +#8+#0+ #0+#255 +#1+#1 +#2+#1 + #3+#0 +
            FS  + 'a0' +#1;  // FS a 0 n - Read check paper - #1 = CMC7
end;

function TACBrEscPosEpson.LeituraCheque: AnsiString;
var
  Resp: AnsiString;
  b: Byte;
  p, t: Integer;
begin
  Result := '';
  t := max(fpPosPrinter.Device.TimeOutMilissegundos, cTimeOutTxRxCheque);
  Resp := fpPosPrinter.TxRx( FS + 'b', 0, t, True );

  // Verificando o Header
  if copy(Resp,1,1) = '_' then        // Header formarto 1
    p := 2
  else if copy(Resp,1,2) = '7*' then  // Header formarto 2
    p := 3
  else if copy(Resp,1,1) = '=' then   // Resposta por Hook da DLL
    p := 1
  else
    p := 0;

  // Verificando o Byte de Status
  if (p > 0) and (p <= Length(Resp)) then
  begin
    if (p > 1) then
    begin
      b := Ord(Resp[p]);
      if not TestBit(b, 5) then   // Reading normal ?
        Result := Trim(copy(Resp, p+1, Length(Resp)));  // Remove Header e Status
    end
    else
      Result := Trim(Resp);   // Resposta por Hook da DLL
  end;

  if (Result <> '') then
  begin
    // Remove espa�os dos blocos
    Result := StringReplace(Result,' ','',[rfReplaceAll]);

    // Acha Inicio do Bloco CMC7
    p := pos('=', Result);
    if (p < 0) then
      p := 1;

    Result := Copy(Result, p, Length(Result));
  end;
end;

procedure TACBrEscPosEpson.LerStatus(var AStatus: TACBrPosPrinterStatus);
var
  b: Byte;
  c: AnsiString;
begin
  try
    fpPosPrinter.Ativo := True;

    c := fpPosPrinter.TxRx( DLE + EOT + #1 );
    if (Length(c) > 0) then
    begin
      b := Ord(c[1]);
      if not TestBit(b, 2) then
        AStatus := AStatus + [stGavetaAberta];
      if TestBit(b, 3) then
        AStatus := AStatus + [stOffLine];
      if TestBit(b, 5) then
        AStatus := AStatus + [stErro];  // Waiting for online recovery
      if TestBit(b, 6) then
        AStatus := AStatus + [stImprimindo]; // Paper is being fed by the paper feed button
    end;

    c := fpPosPrinter.TxRx( DLE + EOT + #2 );
    if (Length(c) > 0) then
    begin
      b := Ord(c[1]);
      if TestBit(b, 2) then
        AStatus := AStatus + [stTampaAberta];
      if TestBit(b, 3) then
        AStatus := AStatus + [stImprimindo]; // Paper is being fed by the paper feed button
      if TestBit(b, 5) then
        AStatus := AStatus + [stSemPapel];
      if TestBit(b, 6) then
        AStatus := AStatus + [stErro];
    end;

    c := fpPosPrinter.TxRx( DLE + EOT + #4 );
    if (Length(c) > 0) then
    begin
      b := Ord(c[1]);
      if TestBit(b, 2) and TestBit(b, 3) then
        AStatus := AStatus + [stPoucoPapel];
      if TestBit(b, 5) and TestBit(b, 6) then
        AStatus := AStatus + [stSemPapel];
    end;

    if (fpPosPrinter.TemCheque = 1) then
    begin
      c := fpPosPrinter.TxRx( DLE + EOT + #5 );
      if (Length(c) > 0) then
      begin
        b := Ord(c[1]);
        if not TestBit(b, 2) then
          AStatus := AStatus + [stSlip];
        if TestBit(b, 3) then
          AStatus := AStatus + [stAguardandoSlip];
        if not TestBit(b, 5) then
          AStatus := AStatus + [stTOF];
        if not TestBit(b, 6) then
          AStatus := AStatus + [stBOF];
      end;

      c := fpPosPrinter.TxRx( DLE + EOT + BS + #1 );
      if (Length(c) > 0) then
      begin
        b := Ord(c[1]);
        if not TestBit(b, 2) then
          AStatus := AStatus + [stMICR];
        if TestBit(b, 3) then
          AStatus := AStatus + [stAguardandoSlip];
        if not TestBit(b, 5) then
          AStatus := AStatus + [stTOF];
        if not TestBit(b, 6) then
          AStatus := AStatus + [stBOF];
      end;
    end;

  except
    AStatus := AStatus + [stErroLeitura];
  end;
end;

function TACBrEscPosEpson.LerInfo: String;
var
  Ret: AnsiString;
  b: Byte;
begin
  Result := '';
  Info.Clear;

  // Lendo o Fabricante
  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( GS + 'IB', 0, 0, True );
  except
  end;
  AddInfo(cKeyFabricante, Ret);
  if (Ret = '') and (not (Self is TACBrEscPosEpson)) then   // Nem todas GPrinter`s suportam leitura de Info
    Exit;

  // Lendo a vers�o do Firmware
  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( GS + 'IA', 0, 0, True );
  except
  end;
  AddInfo(cKeyFirmware, Ret);

  // Lendo o Modelo
  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( GS + 'IC', 0, 0, True );
  except
  end;
  AddInfo(cKeyModelo, Ret);

  // Lendo o N�mero Serial
  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( GS + 'ID', 0, 0, True );
    if (Ret = '') then
      Ret := fpPosPrinter.TxRx( GS + 'ID', 0, 0, False );
  except
  end;
  AddInfo('Serial', Ret);

  // Lendo Bit de presen�a de Guilhotina
  try
    Ret := fpPosPrinter.TxRx( GS + 'I2', 1, 0, False );
    if Length(Ret) > 0 then
    begin
      b := Ord(Ret[1]);
      AddInfo(cKeyGuilhotina, TestBit(b, 1) );
      AddInfo(cKeyCheque, TestBit(b, 3) );
      AddInfo(cKeyMICR, TestBit(b, 3) );
      AddInfo(cKeyAutenticacao, TestBit(b, 6) );
    end;
  except
  end;

  Result := Info.Text;
end;

function TACBrEscPosEpson.ComandoImprimirImagemRasterStr(
  const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer): AnsiString;
var
  LenCMD: Integer;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    {
      Verificando se informou o KeyCode compat�vel com o comando Novo ou Antigo.

      Nota: O Comando novo da Epson "GS + '(L'", n�o � compat�vel em alguns
      Equipamentos (n�o Epson), mas que usam EscPosEpson...
      Nesse caso, vamos usar o comando "GS + '*'", para tal, informe:
      KeyCode1 := 1; KeyCode2 := 0
    }

    if (KeyCode2 = 0) then
      Result := ComandoImprimirImagemColumnStr(fpPosPrinter, RasterStr, AWidth, AHeight)
    else
    begin
      // Comando para gravar Raster Img na mem�ria
      Result := #48 + #112 + #48 +  // m + fn + a
                #01 + #01 +         // bx + by
                '1' +               // c - 1 Cor, Mono
                IntToLEStr(AWidth)  +
                IntToLEStr(AHeight) +
                RasterStr;

      LenCMD := Length(Result);

      if LenCMD <= MAX_LEN_CMD then
        Result := GS + '(L' + IntToLEStr(LenCMD) + Result
      else
        Result := GS + '8L' + IntToLEStr(LenCMD,4) + Result;


      // Novo Comando... Para imprimir Raster image gravada com o comando antereior, na impressora
      Result := Result + GS  + '(L' + #2 + #0 + #48 +#50;

      //DEBUG
      //WriteToFile('c:\temp\Raster.txt', Result);
    end;
  end;
end;

end.

