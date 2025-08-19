{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
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

unit ACBrDFe.Conversao;

interface

uses
  SysUtils, StrUtils, Classes;

type
// Reforma Tribut�ria
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
  Declara��o das fun��es de convers�o
}

// Reforma Tribut�ria
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

// Reforma Tribut�ria
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
  raise EACBrException.CreateFmt('Valor string inv�lido para TtpEnteGov: %s', [s]);
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
  raise EACBrException.CreateFmt('Valor string inv�lido para TtpOperGov: %s', [s]);
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
  raise EACBrException.CreateFmt('Valor string inv�lido para TCSTIBSCBS: %s', [s]);
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
  raise EACBrException.CreateFmt('Valor string inv�lido para TcCredPres: %s', [s]);
end;

end.

