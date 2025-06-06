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

// Equipamentos compat�veis com esse Modelo:
// - D2 Mini - TecToy/Sunmi,
// - GPOS800 - Gertec

{$I ACBr.inc}

unit ACBrEscPosStar;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrEscPosEpson
  {$IfDef NEXTGEN}
   ,ACBrBase
  {$EndIf};

type

  { TACBrEscPosStar }

  TACBrEscPosStar = class(TACBrEscPosEpson)
  public
    constructor Create(AOwner: TACBrPosPrinter);
    function ComandoGaveta(NumGaveta: Integer = 1): AnsiString; override;
    function ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo): AnsiString; override;
    function ComandoQrCode(const ACodigo: AnsiString): AnsiString; override;
    function ComandoImprimirImagemRasterStr(const RasterStr: AnsiString; AWidth: Integer;
      AHeight: Integer): AnsiString; override;
    procedure LerStatus(var AStatus: TACBrPosPrinterStatus); override;
  end;

implementation

uses
  ACBrConsts,
  ACBrUtil.Strings, ACBrUtil.Math;

{ TACBrEscPosStar }

constructor TACBrEscPosStar.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscPosStar';

  with Cmd  do
  begin
    Beep := ESC + GS + BELL + #1 + #2 + #5;
  end;
end;

function TACBrEscPosStar.ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo): AnsiString;
//var
//  CmdPag: Integer;
begin
  Result := FS +'.' +   // Cancel Chinese character mode
            inherited ComandoPaginaCodigo(APagCodigo);
  {
  //Nota: pc850, n�o funcinou corretamente no G800.
  case APagCodigo of
    pcUTF8: CmdPag := 0;
    pc437: CmdPag := 1;
    pc852: CmdPag := 5;
    pc860: CmdPag := 6;
    pc1252: CmdPag := 32;
  else
    CmdPag := -1;
  end;

  if (CmdPag < 0) then
    Result := inherited ComandoPaginaCodigo(APagCodigo)
  else
    Result := FS +'.' +   // Cancel Chinese character mode
              ESC + GS + 't' + AnsiChr( CmdPag );
  }
end;

function TACBrEscPosStar.ComandoQrCode(const ACodigo: AnsiString): AnsiString;
begin
  Result := inherited ComandoQrCode(ACodigo);

  // Comando padr�o da Star, n�o funcinou corretamente no G800.
  //with fpPosPrinter.ConfigQRCode do
  //begin
  //  Result := ESC + GS + 'yS0'+ AnsiChr(Tipo) +
  //            ESC + GS + 'yS1'+ AnsiChr(ErrorLevel) +
  //            ESC + GS + 'yS2'+ AnsiChr(min(LarguraModulo,8)) +
  //            ESC + GS + 'yD10'+ IntToLEStr(length(ACodigo)) + ACodigo +  // Codifica
  //            ESC + GS + 'yP';  // Imprime
  //end;
end;

function TACBrEscPosStar.ComandoGaveta(NumGaveta: Integer): AnsiString;
var
  CharGav: AnsiChar;
begin
  with fpPosPrinter.ConfigGaveta do
  begin
    if SinalInvertido then
      CharGav := #1
    else
      CharGav := #0;

    Result := DLE + DC4 + #1 + CharGav + AnsiChar(Trunc(TempoOFF/31));
  end;
end;

function TACBrEscPosStar.ComandoImprimirImagemRasterStr(
  const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer): AnsiString;
begin
  // Gerando RasterStr, sem LF, a cada fatia
  Result := ComandoImprimirImagemColumnStr(fpPosPrinter, RasterStr, AWidth, AHeight, False)
end;

procedure TACBrEscPosStar.LerStatus(var AStatus: TACBrPosPrinterStatus);
var
  b: Byte;
  c: AnsiString;
begin
  try
    fpPosPrinter.Ativo := True;

    c := fpPosPrinter.TxRx( GS + 'r' + #1 );
    if (Length(c) > 0) then
    begin
      b := Ord(c[1]);
      if TestBit(b, 0) or TestBit(b, 1) then
        AStatus := AStatus + [stPoucoPapel];
      if TestBit(b, 2) or TestBit(b, 3) then
        AStatus := AStatus + [stSemPapel];
    end;

    c := fpPosPrinter.TxRx( GS + 'r' + #2 );
    if (Length(c) > 0) then
    begin
      b := Ord(c[1]);
      if TestBit(b, 0) then
        AStatus := AStatus + [stGavetaAberta];
    end;
  except
    AStatus := AStatus + [stErroLeitura];
  end;
end;

end.

