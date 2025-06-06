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

unit ACBrEscDaruma;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};


type

  { TACBrEscDaruma }

  TACBrEscDaruma = class(TACBrPosPrinterClass)
  private
    FConfigurado: Boolean;
  protected
    function ComandoConfiguraDaruma(Byte30: Char): AnsiString;
  public
    constructor Create(AOwner: TACBrPosPrinter);

    procedure Configurar; override;
    function ComandoInicializa: AnsiString; override;

    function ComandoCodBarras(const ATag: String; const ACodigo: AnsiString): AnsiString;
      override;
    function ComandoQrCode(const ACodigo: AnsiString): AnsiString; override;
    function ComandoLogo: AnsiString; override;
    function ComandoGaveta(NumGaveta: Integer = 1): AnsiString; override;

    procedure LerStatus(var AStatus: TACBrPosPrinterStatus); override;
    function LerInfo: String; override;
  end;


implementation

Uses
  Math, ACBrConsts, ACBrUtil.FilesIO, ACBrUtil.Strings, ACBrUtil.Math;

{ TACBrEscDaruma }

function TACBrEscDaruma.ComandoConfiguraDaruma(Byte30: Char): AnsiString;
begin
  Result := Esc + #198 + StringOfChar('X',30) +
                         Byte30 +
                         StringOfChar('X',9)
end;

constructor TACBrEscDaruma.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscDaruma';
  FConfigurado := False;
  RazaoColunaFonte.Condensada := 0.8421;    // 48 / 57

{(*}
  with Cmd  do
  begin
    Zera                    := ESC + '@';
    PuloDeLinha             := LF;
    EspacoEntreLinhasPadrao := ESC + '2';
    EspacoEntreLinhas       := ESC + '3';
    FonteNormal             := ESC + '!' + #0 + DC2;
    FonteA                  := DC4;
    FonteB                  := ESC + SI;
    LigaNegrito             := ESC + 'E';
    DesligaNegrito          := ESC + 'F';
    LigaExpandido           := ESC + 'W' + #1;
    DesligaExpandido        := ESC + 'W' + #0;
    LigaAlturaDupla         := ESC + 'w' + #1;
    DesligaAlturaDupla      := ESC + 'w' + #0;
    LigaSublinhado          := ESC + '-' + #1;
    DesligaSublinhado       := ESC + '-' + #0;
    LigaItalico             := ESC + '4' + #1;
    DesligaItalico          := ESC + '4' + #0;
    LigaInvertido           := '';  // Existe ?
    DesligaInvertido        := '';  // Existe ?
    LigaCondensado          := ESC + SI;
    DesligaCondensado       := DC2;
    AlinhadoEsquerda        := ESC + 'j' + #0;
    AlinhadoCentro          := ESC + 'j' + #1;
    AlinhadoDireita         := ESC + 'j' + #2;
    CorteTotal              := ESC + 'm';
    CorteParcial            := ESC + 'm';
    Beep                    := BELL;
  end;
  {*)}

  TagsNaoSuportadas.Add( cTagBarraCode128c );
  TagsNaoSuportadas.Add( cTagModoPaginaLiga );
end;

procedure TACBrEscDaruma.Configurar;
var
  SL: TStringList;
  ColunasInfo, ModeloInfo: Integer;
  Byte30: Char;
begin
  FConfigurado := False;

  { Lendo as informa��es da Impressora, para auto configura��o das colunas }
  if (fpPosPrinter.Device.IsSerialPort or
      fpPosPrinter.Device.IsTCPPort or
      fpPosPrinter.Device.IsDLLPort) then
  begin
    SL := TStringList.Create;
    try
      SL.Text := LerInfo;
      ColunasInfo := StrToIntDef( SL.Values['Colunas'], fpPosPrinter.ColunasFonteNormal);
      ModeloInfo  := StrToIntDef( SL.Values['Modelo'], 0);
    finally
      SL.Free;
    end;

    fpPosPrinter.ColunasFonteNormal := ColunasInfo;

    if ModeloInfo > 20000 then // 20001-DR800 L, 20002-DR800 H, 20003-DR800 ETH
    begin
      Byte30 := '0';  // '0' = 64 colunas em modo condensado
      RazaoColunaFonte.Condensada := 0.75;    // 48 / 64
    end
    else
    begin
      Byte30 := '1';  // '1' = 57 colunas em modo condensado
      RazaoColunaFonte.Condensada := 0.8421;    // 48 / 57
    end;

    fpPosPrinter.Device.EnviaString( ComandoConfiguraDaruma(Byte30) );
    FConfigurado := True;
  end;
end;

function TACBrEscDaruma.ComandoInicializa: AnsiString;
begin
  Result := inherited ComandoInicializa;

  if not FConfigurado then
    Result := ComandoConfiguraDaruma('1') + Result ;  // '1' = 57 colunas em modo condensado

{
  - Programando para sempre usar 48 por 57 colunas, em modo condensado.
  - Se a porta for Serial ou Eth, a configura��o ser� autom�tica, em "Configurar"
}
end;

function TACBrEscDaruma.ComandoCodBarras(const ATag: String; const ACodigo: AnsiString
  ): AnsiString;
var
  L, A, M : Integer ;
  CmdBarCode: Byte;
begin
  if ATag = cTagBarraEAN13 then
    CmdBarCode := 1
  else if ATag = cTagBarraEAN8 then
    CmdBarCode := 2
  else if ATag = cTagBarraStd then
    CmdBarCode := 3
  else if ATag = cTagBarraInter then
    CmdBarCode := 4
  else if (ATag = cTagBarraCode128)  or (ATag = cTagBarraCode128a) or
          (ATag = cTagBarraCode128b) or (ATag = cTagBarraCode128c) then
    CmdBarCode := 5
  else if ATag = cTagBarraCode39 then
    CmdBarCode := 6
  else if ATag = cTagBarraCode93 then
    CmdBarCode := 7
  else if ATag = cTagBarraUPCA then
    CmdBarCode := 8
  else if ATag = cTagBarraCodaBar then
    CmdBarCode := 9
  else if ATag = cTagBarraMSI then
    CmdBarCode := 10
  else if ATag = cTagBarraCode11 then
    CmdBarCode := 11
  else
  begin
    Result := ACodigo;
    Exit;
  end;

  with fpPosPrinter.ConfigBarras do
  begin
    L := IfThen( LarguraLinha = 0, 2, max(min(LarguraLinha,5),2) );
    A := IfThen( Altura = 0, 50, max(min(Altura,200),50) );
    M := IfThen( MostrarCodigo, 1, 0 );
  end ;

  Result := ESC + 'b' +
            AnsiChr( CmdBarCode ) +
            AnsiChr( L ) + // Largura
            AnsiChr( A ) + // Altura
            AnsiChr( M ) + // HRI (numero impresso abaixo do cod.barras)
            ACodigo +
            NUL;
end;

function TACBrEscDaruma.ComandoQrCode(const ACodigo: AnsiString): AnsiString;
var
  L, LenQrCode: Integer;
  E: AnsiChar;
begin
  LenQrCode := Length(ACodigo);

  with fpPosPrinter.ConfigQRCode do
  begin
    L := IfThen( LarguraModulo = 0, 5, max(min(LarguraModulo,7),3) );

    case ErrorLevel of
      1: E := 'M';
      2: E := 'Q';
      3: E := 'H';
    else
      E := #0;
    end;

    if LenQrCode > 256 then
    begin
      if LarguraModulo < 4 then
        LarguraModulo := 4;

      if E = #0 then
        E := 'M';
    end;

    Result := ESC + #129 +
              IntToLEStr( LenQrCode+2 ) +
              AnsiChr(L) + E + ACodigo;
  end;
end;

function TACBrEscDaruma.ComandoLogo: AnsiString;
begin
  Result := SYN + BS + SYN + TAB;  //TODO: Testar
end;

function TACBrEscDaruma.ComandoGaveta(NumGaveta: Integer): AnsiString;
begin
  // EscDaruma n�o tem comando para abertura de Gaveta 1 e 2 ou Tempos de abertura
  Result := ESC + 'p';
end;

procedure TACBrEscDaruma.LerStatus(var AStatus: TACBrPosPrinterStatus);
var
  b: Byte;
  c: AnsiString;
begin
  try
    c := fpPosPrinter.TxRx( ENQ );
    if (Length(c) > 0) then
    begin
      b := Ord(c[1]);
      if TestBit(b, 0) then
        AStatus := AStatus + [stImprimindo];
      if TestBit(b, 3) then
        AStatus := AStatus + [stErro];
      if not TestBit(b, 4) then
        AStatus := AStatus + [stOffLine];
      if TestBit(b, 5) then
        AStatus := AStatus + [stSemPapel];
      if TestBit(b, 7) then
        AStatus := AStatus + [stTampaAberta];
    end;

    c := fpPosPrinter.TxRx( GS + ENQ );
    if (Length(c) > 0) then
    begin
      b := Ord(c[1]);
      if TestBit(b, 0) then
        AStatus := AStatus + [stPoucoPapel];
      if TestBit(b, 1) then
        AStatus := AStatus + [stSemPapel];
      if TestBit(b, 3) then
        AStatus := AStatus + [stOffLine];
      if not TestBit(b, 4) then
        AStatus := AStatus + [stTampaAberta];  // Sem papel sobre o sensor
      if TestBit(b, 6) then
        AStatus := AStatus + [stErro];  // Impressora em falha
      if TestBit(b, 7) then
        AStatus := AStatus + [stGavetaAberta];  // Impressora em falha
    end;
  except
    AStatus := AStatus + [stErroLeitura];
  end;
end;

function TACBrEscDaruma.LerInfo: String;
var
  Ret, b: AnsiString;
begin
  Result := '';
  Info.Clear;

  AddInfo(cKeyFabricante, ':Daruma');

  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( ESC + #199, 13, 0, True );
  except
  end;
  AddInfo(cKeyFirmware, Ret);

  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( ESC + #195, 13, 0, True );
  except
  end;
  AddInfo(cKeyModelo, Ret);

  //Ret := fpPosPrinter.TxRx( ESC + #199, 13, 0, True );  // N�o encontrado
  //AddInfo('Serial', ':');

  try
    Ret := fpPosPrinter.TxRx( ESC + #229, 13, 0, True );
    AddInfo(cKeyGuilhotina, Copy(Ret,9,1));

    b := Copy(Ret,12,1);
    AddInfo(ckeyColunas, IntToStr(ifthen(b='2',34,ifthen(b='1',52,48))));

    b := Copy(Ret,40,1);
    AddInfo(cKeyCodPage, b) ;
  except
  end;

  Result := Info.Text;
end;

end.

