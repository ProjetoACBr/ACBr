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

unit ACBrEscBematech;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrConsts
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

const
  ModoEscBema = GS + #249 + #32 + #0;

type

  { TACBrEscBematech }

  TACBrEscBematech = class(TACBrPosPrinterClass)
  private
    procedure VerificarKeyCodes;
  public
    constructor Create(AOwner: TACBrPosPrinter);

    function ComandoCodBarras(const ATag: String; const ACodigo: AnsiString): AnsiString;
      override;
    function ComandoQrCode(const ACodigo: AnsiString): AnsiString; override;
    function ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo): AnsiString;
      override;
    function ComandoImprimirImagemRasterStr(const RasterStr: AnsiString;
      AWidth: Integer; AHeight: Integer): AnsiString; override;
    function ComandoLogo: AnsiString; override;
    function ComandoGravarLogoRasterStr(const RasterStr: AnsiString; AWidth: Integer;
      AHeight: Integer): AnsiString; override;
    function ComandoApagarLogo: AnsiString; override;
    function ComandoGaveta(NumGaveta: Integer = 1): AnsiString; override;
    function ComandoInicializa: AnsiString; override;

    procedure LerStatus(var AStatus: TACBrPosPrinterStatus); override;
    function LerInfo: String; override;
  end;


implementation

Uses
  strutils, Math, ACBrEscPosEpson, ACBrUtil.FilesIO, ACBrUtil.Strings, ACBrUtil.Math;

{ TACBrEscBematech }

constructor TACBrEscBematech.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscBematech';

{(*}
  with Cmd  do
  begin
    Zera                    := ESC + '@';
    PuloDeLinha             := LF;
    EspacoEntreLinhasPadrao := ESC + '2';
    EspacoEntreLinhas       := ESC + '3';
    LigaNegrito             := ESC + 'E';
    DesligaNegrito          := ESC + 'F';
    LigaExpandido           := ESC + 'W' + #1;
    DesligaExpandido        := ESC + 'W' + #0;
    LigaAlturaDupla         := ESC + 'd' + #1;
    DesligaAlturaDupla      := ESC + 'd' + #0;
    LigaSublinhado          := ESC + '-' + #1;
    DesligaSublinhado       := ESC + '-' + #0;
    LigaInvertido           := '';  // Modo EscBema n�o suporta
    DesligaInvertido        := '';  // Modo EscBema n�o suporta
    LigaItalico             := ESC + '4';
    DesligaItalico          := ESC + '5';
    LigaCondensado          := ESC + SI;
    DesligaCondensado       := ESC + 'H';
    AlinhadoEsquerda        := ESC + 'a' + #0;
    AlinhadoCentro          := ESC + 'a' + #1;
    AlinhadoDireita         := ESC + 'a' + #2;
    CorteTotal              := ESC + 'w';
    CorteParcial            := ESC + 'm';
    FonteNormal             := ESC + '!' + #0 + DesligaCondensado + DesligaItalico;
    FonteA                  := DesligaCondensado;
    FonteB                  := LigaCondensado;
    Beep                    := ESC + '(A' + #4 + #0 + #1 + #2 + #1 + #0;
  end;
  {*)}

  TagsNaoSuportadas.Add( cTagBarraMSI );
  TagsNaoSuportadas.Add( cTagBarraCode128c );
  TagsNaoSuportadas.Add( cTagModoPaginaLiga );
end;

function TACBrEscBematech.ComandoCodBarras(const ATag: String;
  const ACodigo: AnsiString): AnsiString;
begin
  with fpPosPrinter.ConfigBarras do
  begin
    Result := ComandoCodBarrasEscPosNo128ABC(ATag, ACodigo, MostrarCodigo, Altura, LarguraLinha);
  end ;
end;

function TACBrEscBematech.ComandoQrCode(const ACodigo: AnsiString): AnsiString;
begin
  with fpPosPrinter.ConfigQRCode do
  begin
    Result := GS  + 'kQ' + // Codigo QRCode
              AnsiChr(ErrorLevel) +         // N1 Error correction level 0 - L, 1 - M, 2 - Q, 3 - H
              AnsiChr(LarguraModulo * 2) +  // N2 - MSB; 0 = default = 4
              AnsiChr(0) +                  // N3 - Precisa computar Version QRCode ???
              AnsiChr(1) +                  // N4, Encoding modes: 0 � Numeric only, 1 � Alphanumeric, 2 � Binary (8 bits), 3 � Kanji,
              IntToLEStr( Length(ACodigo) ) +  // N5 e N6
              ACodigo;
  end;
end;

function TACBrEscBematech.ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo
  ): AnsiString;
var
  CmdPag: Integer;
begin
  case APagCodigo of
    pc437: CmdPag := 3;
    pc850: CmdPag := 2;
    pc860: CmdPag := 4;
    pcUTF8: CmdPag := 8;
  else
    begin
      Result := '';
      Exit;
    end;
  end;

  Result := ESC + 't' + AnsiChr( CmdPag );
end;

procedure TACBrEscBematech.VerificarKeyCodes;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    if (KeyCode1 <> 1) or (KeyCode2 <> 0) then
      raise EPosPrinterException.Create('Bematech apenas aceitas KeyCode1=1, KeyCode2=0');
  end;
end;

function TACBrEscBematech.ComandoImprimirImagemRasterStr(
  const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer): AnsiString;
begin
  Result := ComandoImprimirImagemColumnStr(fpPosPrinter, RasterStr, AWidth, AHeight)
end;

function TACBrEscBematech.ComandoLogo: AnsiString;
var
  m, KeyCode: Integer;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    if (KeyCode2 = 0) then
    begin
      if (KeyCode1 >= 48) and (KeyCode1 <= 57) then  // '0'..'9'
        KeyCode := StrToInt( chr(KeyCode1) )
      else
        KeyCode := KeyCode1 ;
    end
    else
      KeyCode := StrToIntDef( chr(KeyCode1) + chr(KeyCode2), 1);

    m := 0;
    if FatorX > 1 then
      m := m + 1;
    if Fatory > 1 then
      m := m + 2;

    Result := FS + 'p' + AnsiChr(KeyCode) + AnsiChr(m);
  end;
end;

function TACBrEscBematech.ComandoGravarLogoRasterStr(
  const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer): AnsiString;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    VerificarKeyCodes;
    Result := ComandoGravarLogoColumnStr(RasterStr, AWidth, AHeight, KeyCode1);
  end;
end;

function TACBrEscBematech.ComandoApagarLogo: AnsiString;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    VerificarKeyCodes;
    Result := ComandoGravarLogoColumnStr(#0, 1, 1, KeyCode1);
  end;
end;

function TACBrEscBematech.ComandoGaveta(NumGaveta: Integer): AnsiString;
var
  Tempo: Integer;
begin
  with fpPosPrinter.ConfigGaveta do
  begin
    Tempo := max(TempoON, TempoOFF);

    if NumGaveta > 1 then
      Result := ESC + #128 + AnsiChr( Tempo )
    else
      Result := ESC + 'v' + AnsiChr( Tempo )
  end;
end;

function TACBrEscBematech.ComandoInicializa: AnsiString;
begin
  Result := inherited ComandoInicializa ;
  Result := ModoEscBema + Result;
end;

procedure TACBrEscBematech.LerStatus(var AStatus: TACBrPosPrinterStatus);
var
  B: Byte;
  Ret: AnsiString;
begin
  try
    Ret := fpPosPrinter.TxRx( GS + #248 + '1', 5 );
    if Length(Ret) < 2 then
      raise EPosPrinterException.Create( ACBrStr('Leitura Status, retorno inv�lido'));

    B := Ord(Ret[1]);
    if TestBit(B, 2) then
      AStatus := AStatus + [stImprimindo];  // Overrun
    if TestBit(B, 3) then
      AStatus := AStatus + [stOffLine];
    if TestBit(B, 4) then
      AStatus := AStatus + [stImprimindo];

    B := Ord(Ret[2]);
    if TestBit(B, 1) then
      AStatus := AStatus + [stPoucoPapel];
    if TestBit(B, 2) then
      AStatus := AStatus + [stSemPapel];
    if not TestBit(B, 4) then
      AStatus := AStatus + [stGavetaAberta];
    if TestBit(B, 5) then
      AStatus := AStatus + [stSemPapel];
    if TestBit(B, 6) then
      AStatus := AStatus + [stErro];
    if not TestBit(B, 7) then
      AStatus := AStatus + [stTampaAberta];
  except
    AStatus := AStatus + [stErroLeitura];
  end;
end;

function TACBrEscBematech.LerInfo: String;
var
  Ret, InfoCmd: AnsiString;
  b: Byte;
begin
  Result := '';
  Info.Clear;

  InfoCmd := GS + #249 + #39;

  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( InfoCmd + #0, 10 );
  except
  end;
  AddInfo(cKeyModelo, Ret);

  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( InfoCmd + #1, 0 );
  except
  end;
  AddInfo(cKeySerial, Ret);

  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( InfoCmd + #3, 3 );
  except
  end;
  AddInfo(cKeyFirmware, Ret);

  try
    Ret := fpPosPrinter.TxRx( GS + #248 + '1', 5 );
    if Length(Ret) >= 3 then
    begin
      b := Ord(Ret[3]);
      AddInfo(cKeyGuilhotina, not TestBit(b, 2)) ;
    end;
  except
  end;

  Result := Info.Text;
end;

end.

