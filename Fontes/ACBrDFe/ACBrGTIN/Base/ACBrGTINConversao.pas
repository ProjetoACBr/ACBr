{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit ACBrGTINConversao;

interface

uses
  SysUtils, StrUtils, Classes,
  ACBrXmlBase;

type
  TStatusACBrGTIN = (stGTINIdle, stGTINConsulta, stGTINEnvioWebService);

  TVersaoGTIN     = (ve100);

const
  TVersaoGTINArrayStrings: array[TVersaoGTIN] of string = ('1.00');
  TVersaoGTINArrayDouble: array[TVersaoGTIN] of Double = (1.00);

type
  TSchemaGTIN     = (schErro, schconsGTIN);

const
  TSchemaGTINArrayStrings: array[TSchemaGTIN] of string = ('', '');

type
  TLayOutGTIN     = (LayGTINConsulta);

const
  TLayOutGTINArrayStrings: array[TLayOutGTIN] of string = ('GTINConsulta');

{
  Declara��o das fun��es de convers�o
}
function LayOutToSchema(const t: TLayOutGTIN): TSchemaGTIN;

function LayOutToServico(const t: TLayOutGTIN): string;
function ServicoToLayOut(out ok: Boolean; const s: string): TLayOutGTIN;

function SchemaGTINToStr(const t: TSchemaGTIN): string;
function StrToSchemaGTIN(const s: string): TSchemaGTIN;

function StrToVersaoGTIN(out ok: Boolean; const s: string): TVersaoGTIN;
function VersaoGTINToStr(const t: TVersaoGTIN): string;

function DblToVersaoGTIN(out ok: Boolean; const d: Double): TVersaoGTIN;
function VersaoGTINToDbl(const t: TVersaoGTIN): Double;

//function TipoAmbToStr(const t: TACBrTipoAmbiente): string;
//function StrToTipoAmb(out ok: boolean; const s: string): TACBrTipoAmbiente;

implementation

uses
  typinfo,
  ACBrBase;

function LayOutToSchema(const t: TLayOutGTIN): TSchemaGTIN;
begin
  case t of
    LayGTINConsulta: Result := schconsGTIN;
  else
    Result := schErro;
  end;
end;

function LayOutToServico(const t: TLayOutGTIN): string;
begin
  result := TLayOutGTINArrayStrings[t];
end;

function ServicoToLayOut(out ok: Boolean; const s: string): TLayOutGTIN;
var
  idx: TLayOutGTIN;
begin
  ok := True;

  for idx := Low(TLayOutGTINArrayStrings) to High(TLayOutGTINArrayStrings) do
  begin
    if (TLayOutGTINArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TLayOutGTIN: %s', [s]);
end;

function SchemaGTINToStr(const t: TSchemaGTIN): string;
begin
  Result := GetEnumName(TypeInfo(TSchemaGTIN), Integer(t));
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function StrToSchemaGTIN(const s: string): TSchemaGTIN;
var
  P: Integer;
  SchemaStr: string;
  CodSchema: Integer;
begin
  P := pos('_', s);

  if P > 0 then
    SchemaStr := copy(s, 1, P-1)
  else
    SchemaStr := s;

  if LeftStr(SchemaStr, 3) <> 'sch' then
    SchemaStr := 'sch' + SchemaStr;

  CodSchema := GetEnumValue(TypeInfo(TSchemaGTIN), SchemaStr);

  if CodSchema = -1 then
    raise Exception.Create(Format('"%s" n�o � um valor TSchemaGTIN v�lido.', [SchemaStr]));

  Result := TSchemaGTIN(CodSchema);
end;

function StrToVersaoGTIN(out ok: Boolean; const s: string): TVersaoGTIN;
var
  idx: TVersaoGTIN;
begin
  ok := True;

  for idx := Low(TVersaoGTINArrayStrings) to High(TVersaoGTINArrayStrings) do
  begin
    if (TVersaoGTINArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TVersaoGTIN: %s', [s]);
end;

function VersaoGTINToStr(const t: TVersaoGTIN): string;
begin
  result := TVersaoGTINArrayStrings[t];
end;

function DblToVersaoGTIN(out ok: Boolean; const d: Double): TVersaoGTIN;
var
  idx: TVersaoGTIN;
begin
  for idx := Low(TVersaoGTINArrayDouble) to High(TVersaoGTINArrayDouble) do
  begin
    if (TVersaoGTINArrayDouble[idx] = d) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TVersaoGTIN: %s',
    [FormatFloat('0.00', d)]);
end;

function VersaoGTINToDbl(const t: TVersaoGTIN): Double;
begin
 result := TVersaoGTINArrayDouble[t];
 end;
{
function TipoAmbToStr(const t: TACBrTipoAmbiente): string;
begin
  result := TACBrTipoAmbienteArrayStrings[t];
end;

function StrToTipoAmb(out ok: boolean; const s: string): TACBrTipoAmbiente;
var
  idx: TACBrTipoAmbiente;
begin
  ok := True;

  for idx := Low(TACBrTipoAmbienteArrayStrings) to High(TACBrTipoAmbienteArrayStrings) do
  begin
    if (TACBrTipoAmbienteArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TACBrTipoAmbiente: %s', [s]);
end;
}
end.

