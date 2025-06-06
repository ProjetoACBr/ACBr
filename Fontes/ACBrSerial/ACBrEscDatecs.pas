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

unit ACBrEscDatecs;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrEscPosEpson
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type

  { TACBrEscDatecs }

  TACBrEscDatecs = class(TACBrEscPosEpson)
  protected
    procedure VerificarKeyCodes; override;
  public
    constructor Create(AOwner: TACBrPosPrinter);

    function ComandoQrCode(const ACodigo: AnsiString): AnsiString; override;
    function LerInfo: String; override;
  end;

implementation

uses
  StrUtils, Math, ACBrConsts, ACBrUtil.FilesIO, ACBrUtil.Strings, ACBrUtil.Math;

constructor TACBrEscDatecs.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscDatecs';

  {(*}
    with Cmd  do
    begin
      Beep := BELL;
    end;
    {*)}
end;

procedure TACBrEscDatecs.VerificarKeyCodes;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    if (KeyCode1 <> 1) or (KeyCode2 <> 0) then
      raise EPosPrinterException.Create(fpModeloStr+' apenas aceitas KeyCode1=1, KeyCode2=0');
  end;
end;

function TACBrEscDatecs.ComandoQrCode(const ACodigo: AnsiString): AnsiString;
begin
  with fpPosPrinter.ConfigQRCode do
  begin
     Result := GS + 'S' + #0                  + // Set Cell size 3
               GS + 'Q'                       + // 2-D Barcodes
               #6                             + // QRCode
               AnsiChr(min(14,LarguraModulo)) + // Size 1,4,6,8,10,12,14
               AnsiChr(ErrorLevel+1)          + // ECCL 1-4
               IntToLEStr(length(ACodigo))    + // nL + nH
               ACodigo;
  end;
end;

function TACBrEscDatecs.LerInfo: String;
var
  Ret: AnsiString;
begin
  Result := '';
  Info.Clear;

  AddInfo(cKeyFabricante, 'Datecs');

  // Lendo Modelo e Firmware
  Ret := '';
  try
    Ret := fpPosPrinter.TxRx( ESC + 'Z', 0, 0, False );
  except
  end;
  AddInfo(cKeyFirmware, Trim(copy(Ret, 23, 3)));
  AddInfo(cKeyModelo, Trim(copy(Ret,1 ,22)));

  // Lendo o N�mero Serial
  Ret := '';
  try
    Ret := Trim(fpPosPrinter.TxRx( ESC + 'N', 0, 0, False ));
  except
  end;
  AddInfo(cKeySerial, Ret);

  AddInfo(cKeyGuilhotina, False); ;

  Result := Info.Text;
end;

end.

