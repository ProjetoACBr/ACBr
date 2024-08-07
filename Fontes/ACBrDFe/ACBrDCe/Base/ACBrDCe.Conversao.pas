{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrDCe.Conversao;

interface

uses
  SysUtils, StrUtils, Classes,
  pcnConversao;

type
  TStatusDCe = (stDCeIdle, stDCeStatusServico, stDCeAutorizacao, stDCeConsulta,
                stDCeEmail, stDCeEvento, stDCeEnvioWebService);

  TVersaoDCe = (ve100);

const
  TVersaoDCeArrayStrings: array[TVersaoDCe] of string = ('1.00');
  TVersaoDCeArrayDouble: array[TVersaoDCe] of Double = (1.00);

type
  TSchemaDCe = (schErroDCe, schDCe, schEventoDCe, schconsSitDCe,
                schconsStatServDCe, schevCancDCe);

const
  TSchemaDCeArrayStrings: array[TSchemaDCe] of string = ('', '', '', '', '',
    'evCancDCe');

type
  TLayOutDCe = (LayDCeAutorizacao, LayDCeConsulta, LayDCeStatusServico,
                LayDCeEvento, LayDCeURLQRCode, LayURLConsultaDCe);

const
  TLayOutDCeArrayStrings: array[TLayOutDCe] of string = ('Autorizacao',
    'Consulta', 'StatusServico', 'RecepcaoEvento', 'URL-QRCode', 'URL-Consulta');

type
  TEmitenteDCe = (teFisco, teMarketplace, teEmissorProprio, teTransportadora);

const
  TEmitenteDCeArrayStrings: array[TEmitenteDCe] of string = ('0', '1', '2', '3');

type
  TModTrans = (mtCorreios, mtPropria, mtTransportadora);

const
  TModTransArrayStrings: array[TModTrans] of string = ('0', '1', '2');
  TModTransArrayStringsDesc: array[TModTrans] of string = ('0=Transporte pelos correios',
    '1=Transporte por contra pr�pria', '2=Transporte por empresa transportadora');

{
  Declara��o das fun��es de convers�o
}
function StrTotpEventoDCe(out ok: boolean; const s: string): TpcnTpEvento;

function StrToVersaoDCe(const s: String): TVersaoDCe;
function VersaoDCeToStr(const t: TVersaoDCe): String;

function DblToVersaoDCe(const d: Double): TVersaoDCe;
function VersaoDCeToDbl(const t: TVersaoDCe): Double;

function SchemaDCeToStr(const t: TSchemaDCe): String;
function StrToSchemaDCe(const s: String): TSchemaDCe;

function LayOutDCeToSchema(const t: TLayOutDCe): TSchemaDCe;

function LayOutDCeToServico(const t: TLayOutDCe): String;
function ServicoToLayOutDCe(const s: String): TLayOutDCe;

function EmitenteDCeToStr(const t: TEmitenteDCe): String;
function StrToEmitenteDCe(const s: String): TEmitenteDCe;

function ModTransToStr(const t: TModTrans): String;
function StrToModTrans(const s: String): TModTrans;
function ModTransToDesc(const t: TModTrans): String;

implementation

uses
  typinfo,
  ACBrBase;

function StrTotpEventoDCe(out ok: boolean; const s: string): TpcnTpEvento;
begin
  Result := StrToEnumerado(ok, s,
            ['-99999', '110111', '110112', '110114', '110115', '110116',
             '310112', '510620'],
            [teNaoMapeado, teCancelamento, teEncerramento, teInclusaoCondutor,
             teInclusaoDFe, tePagamentoOperacao, teEncerramentoFisco,
             teRegistroPassagemBRId]);
end;

function StrToVersaoDCe(const s: String): TVersaoDCe;
var
  idx: TVersaoDCe;
begin
  for idx := Low(TVersaoDCeArrayStrings) to High(TVersaoDCeArrayStrings) do
  begin
    if (TVersaoDCeArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TVersaoDCe: %s', [s]);
end;

function VersaoDCeToStr(const t: TVersaoDCe): String;
begin
  result := TVersaoDCeArrayStrings[t];
end;

function DblToVersaoDCe(const d: Double): TVersaoDCe;
var
  idx: TVersaoDCe;
begin
  for idx := Low(TVersaoDCeArrayDouble) to High(TVersaoDCeArrayDouble) do
  begin
    if (TVersaoDCeArrayDouble[idx] = d) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TVersaoDCe: %s',
    [FormatFloat('0.00', d)]);
end;

function VersaoDCeToDbl(const t: TVersaoDCe): Double;
begin
  result := TVersaoDCeArrayDouble[t];
end;

function SchemaDCeToStr(const t: TSchemaDCe): String;
begin
  Result := GetEnumName(TypeInfo(TSchemaDCe), Integer(t));
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function StrToSchemaDCe(const s: String): TSchemaDCe;
var
  P: Integer;
  SchemaStr: String;
  CodSchema: Integer;
begin
  P := pos('_', s);

  if P > 0 then
    SchemaStr := copy(s, 1, P-1)
  else
    SchemaStr := s;

  if LeftStr(SchemaStr, 3) <> 'sch' then
    SchemaStr := 'sch' + SchemaStr;

  CodSchema := GetEnumValue(TypeInfo(TSchemaDCe), SchemaStr);

  if CodSchema = -1 then
    raise Exception.Create(Format('"%s" n�o � um valor TSchemaDCe v�lido.', [SchemaStr]));

  Result := TSchemaDCe(CodSchema);
end;

function LayOutDCeToSchema(const t: TLayOutDCe): TSchemaDCe;
begin
  case t of
    LayDCeAutorizacao:   Result := schDCe;
    LayDCeConsulta:      Result := schconsSitDCe;
    LayDCeStatusServico: Result := schconsStatServDCe;
    LayDCeEvento:        Result := schEventoDCe;
  else
    Result := schErroDCe;
  end;
end;

function LayOutDCeToServico(const t: TLayOutDCe): String;
begin
  result := TLayOutDCeArrayStrings[t];
end;

function ServicoToLayOutDCe(const s: String): TLayOutDCe;
var
  idx: TLayOutDCe;
begin
  for idx := Low(TLayOutDCeArrayStrings) to High(TLayOutDCeArrayStrings) do
  begin
    if (TLayOutDCeArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TLayOutDCe: %s', [s]);
end;

function EmitenteDCeToStr(const t: TEmitenteDCe): String;
begin
  result := TEmitenteDCeArrayStrings[t];
end;

function StrToEmitenteDCe(const s: String): TEmitenteDCe;
var
  idx: TEmitenteDCe;
begin
  for idx := Low(TEmitenteDCeArrayStrings) to High(TEmitenteDCeArrayStrings) do
  begin
    if (TEmitenteDCeArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TEmitenteDCe: %s', [s]);
end;

function ModTransToStr(const t: TModTrans): String;
begin
  result := TModTransArrayStrings[t];
end;

function StrToModTrans(const s: String): TModTrans;
var
  idx: TModTrans;
begin
  for idx := Low(TModTransArrayStrings) to High(TModTransArrayStrings) do
  begin
    if (TModTransArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TModTrans: %s', [s]);
end;

function ModTransToDesc(const t: TModTrans): String;
begin
  result := TModTransArrayStringsDesc[t];
end;

initialization
  RegisterStrToTpEventoDFe(StrTotpEventoDCe, 'DCe');

end.

