{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}
{$I ACBr.inc}

unit ACBrBALRamuza;

interface

uses
  Classes,
  ACBrBALSelfCheckout
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type

  { TACBrBALRamuza }

  TACBrBALRamuza = class(TACBrBALSelfCheckout)
  private
    fpProtocolo: AnsiString;
    fpDecimais: Integer;

    function ProtocoloSOF5ADectado(const wPosIni: Integer; const aResposta: AnsiString): Boolean;
    function InterpretarProtocoloSOF5A(const aResposta: AnsiString): AnsiString;
    function InterpretarProtocoloSOF06(const aResposta: AnsiString): AnsiString;
  public
    constructor Create(AOwner: TComponent);
    procedure LeSerial( MillisecTimeOut : Integer = 500) ; override;
    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
    function EnviarPrecoKg(const aValor: Currency; aMillisecTimeOut: Integer = 3000): Boolean; override;
  end;

implementation

uses
  {$IFDEF COMPILER6_UP}
  DateUtils, StrUtils,
  {$ELSE}
  ACBrD5, Windows,
  {$ENDIF}
  SysUtils,
  ACBrConsts,
  ACBrUtil.Compatibilidade,
  ACBrUtil.Math,
  ACBrUtil.Strings,
  ACBrUtil.Base;

{ TACBrBALRamuza }


function TACBrBALRamuza.ProtocoloSOF5ADectado(const  wPosIni:Integer; const aResposta: AnsiString): Boolean;
begin
  Result := (PosEx(ETX, aResposta, wPosIni + 1) > 0);
end;



function TACBrBALRamuza.InterpretarProtocoloSOF5A(const aResposta: AnsiString): AnsiString;
var
  wPosIni, wPosFim: Integer;
begin
  // equivalente ao Protocolo B da Toledo
  { Protocolo SOF5A = [ ENQ ] [ STX ] [ PESO ] [ ETX ]
    Linha Automacao:
      [ STX ] [ PPPPP ] [ ETX ]  - Peso Estável;
      [ STX ] [ IIIII ] [ ETX ]  - Peso Instável;
      [ STX ] [ NNNNN ] [ ETX ]  - Peso Negativo;
      [ STX ] [ SSSSS ] [ ETX ]  - Peso Acima (Sobrecarga) }

  wPosIni     := PosLast(STX, aResposta);
  wPosFim     := PosEx(ETX, aResposta, wPosIni + 1);

  if (wPosFim > 0) then
    fpProtocolo := 'Protocolo SOF5A'
  else
    wPosFim := Length(aResposta) + 1;  // Não achou? ...Usa a String inteira

  Result := Trim(Copy(aResposta, wPosIni + 1, wPosFim - wPosIni - 1));
end;

function TACBrBALRamuza.InterpretarProtocoloSOF06(const aResposta: AnsiString): AnsiString;
var
  wPosIni, wPosFim: Integer;
  vRetorno : String;
begin

  // Esse é o equivalente ao Protocolo C da Toledo
  { Protocolo SOF06 = [ STX ] [ PESO ] [ CR ]
    Linha Automacao:
      [ STX ] [ PPPPP ] [ ETX ]  - Peso Estável;
      [ STX ] [ IIIII ] [ ETX ]  - Peso Instável;
      [ STX ] [ NNNNN ] [ ETX ]  - Peso Negativo;
      [ STX ] [ SSSSS ] [ ETX ]  - Peso Acima (Sobrecarga) }

  wPosIni     := PosLast(STX, aResposta);
  wPosFim     := PosEx(CR, aResposta, wPosIni + 1);

  if (wPosFim > 0) then
    fpProtocolo := 'Protocolo SOF06'
  else
    wPosFim := Length(aResposta) + 1;  // Não achou? ...Usa a String inteira

  vRetorno := Trim(Copy(aResposta, wPosIni + 1, wPosFim - wPosIni - 1));
  // A linha abaixo é para o modelo 9098... Veja: https://www.projetoacbr.com.br/forum/topic/58381-ajuste-leitura-peso-balan%C3%A7a-toleto-9098/
  vRetorno := StringReplace(vRetorno, 'kg', '', [rfReplaceAll]);
  Result := vRetorno;
end;

constructor TACBrBALRamuza.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Ramuza';
  fpProtocolo := 'Não Definido';
  fpDecimais  := 1000;
end;

procedure TACBrBALRamuza.LeSerial(MillisecTimeOut: Integer);
begin
  // Reescreve LeSerial para incluir Protocolo no Log
  fpUltimoPesoLido := 0;
  fpUltimaResposta := '';

  try
    fpUltimaResposta := fpDevice.LeString(MillisecTimeOut);
    GravarLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' RX <- ' + fpUltimaResposta);

    fpUltimoPesoLido := InterpretarRepostaPeso(fpUltimaResposta);
  except
    { Peso não foi recebido (TimeOut) }
    fpUltimoPesoLido := -9;
  end;

  GravarLog('              UltimoPesoLido: ' + FloatToStr(fpUltimoPesoLido) +
            ' - Resposta: ' + fpUltimaResposta + ' - Protocolo: ' + fpProtocolo);
end;

function TACBrBALRamuza.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wPosIni: Integer;
  wResposta: AnsiString;
begin
  Result  := 0;

  if (aResposta = EmptyStr) then Exit;

  wPosIni := PosLast(STX, aResposta);

  if ProtocoloSOF5ADectado(wPosIni, aResposta) then
    wResposta := InterpretarProtocoloSOF5A(aResposta)
  else
    //protocolo P05
    wResposta := InterpretarProtocoloSOF06(aResposta);

  { Convertendo novos formatos de retorno para balanças com pesagem maior que 30 kg}
  wResposta := CorrigirRespostaPeso(wResposta);

  if  (wResposta = EmptyStr) then Exit;

  { Ajustando o separador de Decimal corretamente }
  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  try
    { Já existe ponto decimal ? }
    if (Pos(DecimalSeparator, wResposta) > 0) then
      Result := StrToFloat(wResposta)
    else
      Result := (StrToInt(wResposta) / fpDecimais);
  except
    case PadLeft(Trim(wResposta),1)[1] of
      'I': Result := -1;   { Instavel }
      'N': Result := -2;   { Peso Negativo }
      'S': Result := -10;  { Sobrecarga de Peso }
      'C': Result := -11;  { Indica peso em captura inicial de zero (dispositivo não está pronta para pesar) }
      'E': Result := -12;  { indica erro de calibração. }
    else
      Result := 0;
    end;
  end;
end;

function TACBrBALRamuza.EnviarPrecoKg(const aValor: Currency;
  aMillisecTimeOut: Integer): Boolean;
var
  s, cmd: String;
begin
  s := PadLeft(FloatToIntStr(aValor), 6, '0');
  cmd := STX + s + ETX;

  GravarLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' TX -> ' + cmd);

  fpDevice.Limpar;
  fpDevice.EnviaString(cmd);
  Sleep(200);

  Result := (fpDevice.LeString(aMillisecTimeOut) = ACK);
end;

end.
