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

unit ACBrEscCustomPos;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrEscPosEpson
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type

  { TACBrEscCustomPos }

  TACBrEscCustomPos = class(TACBrEscPosEpson)
  protected
    procedure VerificarKeyCodes; override;
  public
    constructor Create(AOwner: TACBrPosPrinter);

    function ComandoFonte(TipoFonte: TACBrPosTipoFonte; Ligar: Boolean): AnsiString;
      override;
    function ComandoQrCode(const ACodigo: AnsiString): AnsiString; override;
    function ComandoConfiguraModoPagina: AnsiString; override;
    function ComandoImprimirImagemRasterStr(const RasterStr: AnsiString;
      AWidth: Integer; AHeight: Integer): AnsiString; override;

    function ComandoGravarLogoRasterStr(const RasterStr: AnsiString; AWidth: Integer;
      AHeight: Integer): AnsiString; override;
    function ComandoApagarLogo: AnsiString; override;

    function LerInfo: String; override;
  end;

implementation

uses
  strutils, math,
  ACBrUtil.Strings,
  ACBrUtil.Math,
  ACBrUtil.FilesIO,
  ACBrConsts;

{ TACBrEscCustomPos }

constructor TACBrEscCustomPos.Create(AOwner: TACBrPosPrinter);
var
  i: Integer;
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscCustomPos';

  with Cmd do
  begin
    CorteTotal   := ESC + 'i';
    CorteParcial := ESC + 'm';

    //Comandos n�o existentes na Custom
    Beep              := '';
    ImprimePagina     := '';
    LigaModoPagina    := '';
    DesligaModoPagina := '';

    // Custom suporta os comandos abaixo por ESC !, veja "ComandoFonte", abaixo
    LigaItalico       := '';
    DesligaItalico    := '';
    LigaCondensado    := '';
    DesligaCondensado := '';
  end;

  TagsNaoSuportadas.Add( cTagBeep );
  TagsNaoSuportadas.Add( cTagModoPaginaLiga );
  TagsNaoSuportadas.Add( cTagModoPaginaDesliga );
  TagsNaoSuportadas.Add( cTagModoPaginaImprimir );
  TagsNaoSuportadas.Add( cTagModoPaginaDirecao );
  TagsNaoSuportadas.Add( cTagModoPaginaPosEsquerda );
  TagsNaoSuportadas.Add( cTagModoPaginaPosTopo );
  TagsNaoSuportadas.Add( cTagModoPaginaLargura );
  TagsNaoSuportadas.Add( cTagModoPaginaAltura );
  TagsNaoSuportadas.Add( cTagModoPaginaEspaco );
  TagsNaoSuportadas.Add( cTagModoPaginaConfigurar );

  i := TagsNaoSuportadas.IndexOf( cTagLigaItalico );
  if i >= 0 then
    TagsNaoSuportadas.Delete(i);
  i := TagsNaoSuportadas.IndexOf( cTagDesligaItalico );
  if i >= 0 then
    TagsNaoSuportadas.Delete(i);
end;

function TACBrEscCustomPos.ComandoFonte(TipoFonte: TACBrPosTipoFonte;
  Ligar: Boolean): AnsiString;
var
  NovoFonteStatus: TACBrPosFonte;
  AByte: Integer;
begin
  Result := '';
  NovoFonteStatus := fpPosPrinter.FonteStatus;
  if Ligar then
    NovoFonteStatus := NovoFonteStatus + [TipoFonte]
  else
    NovoFonteStatus := NovoFonteStatus - [TipoFonte];

  if TipoFonte in [ftCondensado, ftNegrito, ftExpandido, ftItalico, ftSublinhado, ftAlturaDupla] then
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

    if ftItalico in NovoFonteStatus then
      SetBit(AByte, 6);

    if ftSublinhado in NovoFonteStatus then
      SetBit(AByte, 7);

    Result := ESC + '!' + AnsiChr(Byte(AByte));

    // ESC ! desliga Invertido, enviando o comando novamente
    if ftInvertido in NovoFonteStatus then
      Result := Result + Cmd.LigaInvertido;
  end
  else
    Result := inherited ComandoFonte(TipoFonte, Ligar);

end;

function TACBrEscCustomPos.ComandoQrCode(const ACodigo: AnsiString): AnsiString;
begin
  with fpPosPrinter.ConfigQRCode do
  begin
     Result := GS + '(k' + #3 + #0 + '1A' + AnsiChr(IfThen(Tipo=2,0,1)) +     // Tipo 0-QRCode, 1-MicroQR
               GS + '(k' + #3 + #0 + '1B' + AnsiChr(max(2,LarguraModulo)) +   // Largura Modulo 2-18
               GS + '(k' + #3 + #0 + '1E' + AnsiChr(ErrorLevel) +             // Error Level
               GS + '(k' + IntToLEStr(length(ACodigo)+3)+'1P1'  + ACodigo +   // Codifica
               GS + '(k' + #3 + #0 +'1Q1';  // Imprime
  end;
end;

function TACBrEscCustomPos.ComandoConfiguraModoPagina: AnsiString;
begin
  Result := '';   // N�o h� suporte de PageMode na Custom
end;

procedure TACBrEscCustomPos.VerificarKeyCodes;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    if (KeyCode1 <> 1) or (KeyCode2 <> 0) then
      raise EPosPrinterException.Create('Custom apenas aceitas KeyCode1=1, KeyCode2=0');
  end;
end;

function TACBrEscCustomPos.ComandoImprimirImagemRasterStr(
  const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer): AnsiString;
//var
//  m: Byte;
begin
  //with fpPosPrinter.ConfigLogo do
  //begin
  //  m := 0;
  //  if FatorX > 1 then
  //    m := m + 1;
  //  if Fatory > 1 then
  //    m := m + 2;
  //
  // O comando NATIVO (abaixo), apresentou muitos problemas de impress�o
  //  Result := GS + 'v0' + AnsiChr(m) +
  //                        IntToLEStr(ceil(AWidth/8))  +
  //                        IntToLEStr(AHeight) +
  //                        RasterStr;
  //end;
  Result := ComandoImprimirImagemColumnStr(fpPosPrinter, RasterStr, AWidth, AHeight)
end;

function TACBrEscCustomPos.ComandoGravarLogoRasterStr(
  const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer): AnsiString;
begin
  Result := '';
  raise EPosPrinterException.Create('Comando GravarLogoRasterStr ainda n�o suportado na CustomPos');
end;

function TACBrEscCustomPos.ComandoApagarLogo: AnsiString;
begin
  Result := '';
  raise EPosPrinterException.Create('Comando ApagarLogo ainda n�o suportado na CustomPos');
end;

function TACBrEscCustomPos.LerInfo: String;
var
  Ret: AnsiString;
  Desc: String;
  b: Byte;
begin
  Result := '';
  Info.Clear;

  AddInfo(cKeyFabricante, 'CUSTOM');

  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( GS + 'I'+#3, 4, 0, False );
  except
  end;
  AddInfo(cKeyFirmware, Ret);

  Ret := '';
  Desc := '';
  try
    Ret := fpPosPrinter.TxRx( GS + 'I'+#1, 1, 0, False );
    if (Ret = #142) or (Ret = #255) then
    begin
      Ret := fpPosPrinter.TxRx( GS + 'I'+#255, 2, 0, False );
      if (Ret = #02+#10) then
        Desc := 'K3'
      else if (Ret = #02+#41) then
        Desc := 'Q3X'
      else if (Ret = #02+#79) then
        Desc := 'Q3X ETH';
    end
    else if (Ret = #95) or (Ret = #101) then
    begin
      Ret := fpPosPrinter.TxRx( GS + 'I'+#5, 1, 0, False );
      if (Ret = #188) then
        Desc := 'KUBE II'
      else if (Ret = #166) then
        Desc := 'KUBE II ETH'
    end;
  except
  end;

  if (Desc = '') and (Ret <> '') then
    Desc := TranslateUnprintable(Ret);
  AddInfo(cKeyModelo, Desc);

  // Aparentemente n�o h� comando que retorne o N�mero Serial
  //Ret := fpPosPrinter.TxRx( GS + 'ID', 0, 0, True );
  //AddInfo(cKeySerial, Ret);

  try
    Ret := fpPosPrinter.TxRx( GS + 'I' + #02, 1, 0, False );
    if Length(Ret) > 0 then
    begin
      b := Ord(Ret[1]);
      AddInfo(cKeyGuilhotina, TestBit(b, 1)) ;
    end;
  except
  end;

  Result := Info.Text;
end;


end.

