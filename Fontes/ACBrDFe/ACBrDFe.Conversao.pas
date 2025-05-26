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
  TtpEnteGov = (tcgUniao, tcgEstados, tcgDistritoFederal, tcgMunicipios);

const
  TtpEnteGovArrayStrings: array[TtpEnteGov] of string = ('1', '2', '3', '4');

type
  TCSTIBSCBS = (cstNenhum,
    cst000, cst010, cst011, cst200, cst210, cst220, cst221, cst400, cst410,
    cst510, cst550, cst620, cst800, cst810, cst820);

const
  TCSTIBSCBSArrayStrings: array[TCSTIBSCBS] of string = ('',
    '000', '010', '011', '200', '210', '220', '221', '400', '410', '510', '550',
    '620', '800', '810', '820');

type
  TcClassTrib = (ctNenhum,
    ct000001, ct000002, ct000003, ct000004, ct010001, ct011001, ct011002,
    ct011003, ct011004, ct011005, ct200001, ct200002, ct200003, ct200004,
    ct200005, ct200006, ct200007, ct200008, ct200009, ct200010, ct200011,
    ct200012, ct200013, ct200014, ct200015, ct200016, ct200017, ct200018,
    ct200019, ct200020, ct200021, ct200022, ct200023, ct200024, ct200025,
    ct200026, ct200027, ct200028, ct200029, ct200030, ct200031, ct200032,
    ct200033, ct200034, ct200035, ct200036, ct200037, ct200038, ct200039,
    ct200040, ct200041, ct200042, ct200043, ct200044, ct200045, ct200046,
    ct200047, ct200048, ct200049, ct200450, ct200051, ct200052, ct210001,
    ct210002, ct210003, ct220001, ct220002, ct220003, ct221001, ct400001,
    ct410001, ct410002, ct410003, ct410004, ct410005, ct410006, ct410007,
    ct410008, ct410009, ct410010, ct410011, ct410012, ct410013, ct410014,
    ct410015, ct410016, ct410017, ct410018, ct410019, ct410020, ct510001,
    ct510002, ct550001, ct550002, ct550003, ct550004, ct550005, ct550006,
    ct550007, ct550008, ct550009, ct550010, ct550011, ct550012, ct550013,
    ct550014, ct550015, ct550016, ct550017, ct550018, ct550019, ct550020,
    ct620001, ct620002, ct620003, ct620004, ct620005, ct800001, ct800002,
    ct810001, ct820001, ct820002, ct820003, ct820004, ct820005);

const
  TcClassTribArrayStrings: array[TcClassTrib] of string = ('',
    '000001', '000002', '000003', '000004', '010001', '011001', '011002',
    '011003', '011004', '011005', '200001', '200002', '200003', '200004',
    '200005', '200006', '200007', '200008', '200009', '200010', '200011',
    '200012', '200013', '200014', '200015', '200016', '200017', '200018',
    '200019', '200020', '200021', '200022', '200023', '200024', '200025',
    '200026', '200027', '200028', '200029', '200030', '200031', '200032',
    '200033', '200034', '200035', '200036', '200037', '200038', '200039',
    '200040', '200041', '200042', '200043', '200044', '200045', '200046',
    '200047', '200048', '200049', '200450', '200051', '200052', '210001',
    '210002', '210003', '220001', '220002', '220003', '221001', '400001',
    '410001', '410002', '410003', '410004', '410005', '410006', '410007',
    '410008', '410009', '410010', '410011', '410012', '410013', '410014',
    '410015', '410016', '410017', '410018', '410019', '410020', '510001',
    '510002', '550001', '550002', '550003', '550004', '550005', '550006',
    '550007', '550008', '550009', '550010', '550011', '550012', '550013',
    '550014', '550015', '550016', '550017', '550018', '550019', '550020',
    '620001', '620002', '620003', '620004', '620005', '800001', '800002',
    '810001', '820001', '820002', '820003', '820004', '820005');

type
  TcCredPres = (cpNenhum,
    cp00);

const
  TcCredPresArrayStrings: array[TcCredPres] of string = ('',
    '00');

{
  Declara��o das fun��es de convers�o
}
// Reforma Tribut�ria
function tpEnteGovToStr(const t: TtpEnteGov): string;
function StrTotpEnteGov(const s: string): TtpEnteGov;

function CSTIBSCBSToStr(const t: TCSTIBSCBS): string;
function StrToCSTIBSCBS(const s: string): TCSTIBSCBS;

function cClassTribToStr(const t: TcClassTrib): string;
function StrTocClassTrib(const s: string): TcClassTrib;

function cCredPresToStr(const t: TcCredPres): string;
function StrTocCredPres(const s: string): TcCredPres;

implementation

uses
  typinfo,
  ACBrBase;

function tpEnteGovToStr(const t: TtpEnteGov): string;
begin
  Result := TtpEnteGovArrayStrings[t];
end;

function StrTotpEnteGov(const s: string): TtpEnteGov;
var
  idx: TtpEnteGov;
begin
  for idx:= Low(TtpEnteGovArrayStrings) to High(TtpEnteGovArrayStrings) do
  begin
    if(TtpEnteGovArrayStrings[idx] = s)then
    begin
      Result := idx;
      exit;
    end;
  end;
  raise EACBrException.CreateFmt('Valor string inv�lido para TtpEnteGov: %s', [s]);
end;

function CSTIBSCBSToStr(const t: TCSTIBSCBS): string;
begin
  Result := TCSTIBSCBSArrayStrings[t];
end;

function StrToCSTIBSCBS(const s: string): TCSTIBSCBS;
var
  idx: TCSTIBSCBS;
begin
  for idx:= Low(TCSTIBSCBSArrayStrings) to High(TCSTIBSCBSArrayStrings) do
  begin
    if(TCSTIBSCBSArrayStrings[idx] = s)then
    begin
      Result := idx;
      exit;
    end;
  end;
  raise EACBrException.CreateFmt('Valor string inv�lido para TCSTIBSCBS: %s', [s]);
end;

function cClassTribToStr(const t: TcClassTrib): string;
begin
  Result := TcClassTribArrayStrings[t];
end;

function StrTocClassTrib(const s: string): TcClassTrib;
var
  idx: TcClassTrib;
begin
  for idx:= Low(TcClassTribArrayStrings) to High(TcClassTribArrayStrings) do
  begin
    if(TcClassTribArrayStrings[idx] = s)then
    begin
      Result := idx;
      exit;
    end;
  end;
  raise EACBrException.CreateFmt('Valor string inv�lido para TcClassTrib: %s', [s]);
end;

function cCredPresToStr(const t: TcCredPres): string;
begin
  Result := TcCredPresArrayStrings[t];
end;

function StrTocCredPres(const s: string): TcCredPres;
var
  idx: TcCredPres;
begin
  for idx:= Low(TcCredPresArrayStrings) to High(TcCredPresArrayStrings) do
  begin
    if(TcCredPresArrayStrings[idx] = s)then
    begin
      Result := idx;
      exit;
    end;
  end;
  raise EACBrException.CreateFmt('Valor string inv�lido para TcCredPres: %s', [s]);
end;

end.

