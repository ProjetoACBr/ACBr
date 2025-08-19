{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit ACBrDFe.Conversao;

interface

uses
  SysUtils, StrUtils, Classes;

type
// Reforma Tributária
  TtpEnteGov = (tcgNenhum, tcgUniao, tcgEstados, tcgDistritoFederal,
                tcgMunicipios, tcgOutro);

const
  TtpEnteGovArrayStrings: array[TtpEnteGov] of string = ('', '1', '2', '3', '4',
    '9');

type
  TtpOperGov = (togNenhum, togFornecimento, togRecebimentoPag);

const
  TtpOperGovArrayStrings: array[TtpOperGov] of string = ('', '1', '2');

type
  TCSTIBSCBS = (cstNenhum,
    cst000, cst010, cst011, cst200, cst210, cst220, cst221, cst222, cst400,
    cst410, cst510, cst550, cst620, cst800, cst810, cst820, cst830);

const
  TCSTIBSCBSArrayStrings: array[TCSTIBSCBS] of string = ('',
    '000', '010', '011', '200', '210', '220', '221', '222', '400', '410', '510',
    '550', '620', '800', '810', '820', '830');

type
  TcCredPres = (cpNenhum,
    cp01, cp02, cp03, cp04, cp05, cp06, cp07, cp08, cp09, cp10, cp11, cp12, cp13);

const
  TcCredPresArrayStrings: array[TcCredPres] of string = ('',
    '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13');

{
  Declaração das funções de conversão
}

// Reforma Tributária
function tpEnteGovToStr(const t: TtpEnteGov): string;
function StrTotpEnteGov(const s: string): TtpEnteGov;

function tpOperGovToStr(const t: TtpOperGov): string;
function StrTotpOperGov(const s: string): TtpOperGov;

function CSTIBSCBSToStr(const t: TCSTIBSCBS): string;
function StrToCSTIBSCBS(const s: string): TCSTIBSCBS;

function cCredPresToStr(const t: TcCredPres): string;
function StrTocCredPres(const s: string): TcCredPres;

implementation

uses
  ACBrBase;

// Reforma Tributária
function tpEnteGovToStr(const t: TtpEnteGov): string;
begin
  Result := TtpEnteGovArrayStrings[t];
end;

function StrTotpEnteGov(const s: string): TtpEnteGov;
var
  idx: TtpEnteGov;
begin
  for idx := Low(TtpEnteGovArrayStrings) to High(TtpEnteGovArrayStrings) do
  begin
    if (TtpEnteGovArrayStrings[idx] = s) then
    begin
      Result := idx;
      exit;
    end;
  end;
  raise EACBrException.CreateFmt('Valor string inválido para TtpEnteGov: %s', [s]);
end;

function tpOperGovToStr(const t: TtpOperGov): string;
begin
  Result := TtpOperGovArrayStrings[t];
end;

function StrTotpOperGov(const s: string): TtpOperGov;
var
  idx: TtpOperGov;
begin
  for idx := Low(TtpOperGovArrayStrings) to High(TtpOperGovArrayStrings) do
  begin
    if (TtpOperGovArrayStrings[idx] = s) then
    begin
      Result := idx;
      exit;
    end;
  end;
  raise EACBrException.CreateFmt('Valor string inválido para TtpOperGov: %s', [s]);
end;

function CSTIBSCBSToStr(const t: TCSTIBSCBS): string;
begin
  Result := TCSTIBSCBSArrayStrings[t];
end;

function StrToCSTIBSCBS(const s: string): TCSTIBSCBS;
var
  idx: TCSTIBSCBS;
begin
  for idx := Low(TCSTIBSCBSArrayStrings) to High(TCSTIBSCBSArrayStrings) do
  begin
    if (TCSTIBSCBSArrayStrings[idx] = s) then
    begin
      Result := idx;
      exit;
    end;
  end;
  raise EACBrException.CreateFmt('Valor string inválido para TCSTIBSCBS: %s', [s]);
end;

function cCredPresToStr(const t: TcCredPres): string;
begin
  Result := TcCredPresArrayStrings[t];
end;

function StrTocCredPres(const s: string): TcCredPres;
var
  idx: TcCredPres;
begin
  for idx := Low(TcCredPresArrayStrings) to High(TcCredPresArrayStrings) do
  begin
    if (TcCredPresArrayStrings[idx] = s) then
    begin
      Result := idx;
      exit;
    end;
  end;
  raise EACBrException.CreateFmt('Valor string inválido para TcCredPres: %s', [s]);
end;

end.

