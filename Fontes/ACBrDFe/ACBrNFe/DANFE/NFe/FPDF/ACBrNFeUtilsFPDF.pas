{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Arimateia Jr - https://nuvemfiscal.com.br       }
{                              Victor H. Gonzales - Pandaaa                    }
{                                                                              }
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

unit ACBrNFeUtilsFPDF;

interface

uses
  SysUtils,
  StrUtils,
  pcnNFe,
  pcnConversao,
  pcnConversaoNFe,
  ACBrNFe,
  ACBrNFeDANFEClass,
  StrUtilsEx,
  ACBrDFeDANFeReport;

type
  TLogoAlign = (laLeft, laCenter, laRight, laFull);

  TPosRecibo = (prCabecalho, prRodape, prEsquerda);

  TNFeUtilsFPDF = class
  private
    FDANFEClassOwner: TACBrDFeDANFeReport;
    FNFe: TNFe;
    FFormatSettings: TFormatSettings;
  public
    function NotaCancelada: boolean;
    function NotaDenegada: boolean;
    function NotaEPEC: boolean;
    function GetChaveContingencia: string;
    function GetTextoFatura: string;
    function GetTextoAdicional: string;
  public
    property DANFEClassOwner: TACBrDFeDANFeReport read FDANFEClassOwner;
    property NFe: TNFe read FNFe;
  public
    constructor Create(ANFe: TNFe; ADANFEClassOwner : TACBrNFeDANFEClass); overload;
    constructor Create(ANFe: TNFe; ADANFCEClassOwner : TACBrNFeDANFCEClass); overload;
    destructor Destroy; override;
    property FormatSettings: TFormatSettings read FFormatSettings write FFormatSettings;
  end;

implementation

{ TNFeUtilsFPDF }

constructor TNFeUtilsFPDF.Create(ANFe: TNFe; ADANFEClassOwner : TACBrNFeDANFEClass);
begin
  FNFe := ANFe;
  FDANFEClassOwner := ADANFEClassOwner;
end;

constructor TNFeUtilsFPDF.Create(ANFe: TNFe; ADANFCEClassOwner : TACBrNFeDANFCEClass);
begin
  FNFe := ANFe;
  FDANFEClassOwner := ADANFCEClassOwner;
end;

destructor TNFeUtilsFPDF.Destroy;
begin
  inherited;
end;

function TNFeUtilsFPDF.GetChaveContingencia: string;
var
  ACBrNFe: TACBrNFe;
begin
  ACBrNFe := TACBrNFe.Create(nil);
  try
    Result := ACBrNFe.GerarChaveContingencia(NFe);
  finally
    ACBrNFe.Free;
  end;
end;

function TNFeUtilsFPDF.GetTextoAdicional: string;
begin
  Result := TACBrNFeDANFEClass(DANFEClassOwner).ManterInformacoesDadosAdicionais(NFe);
  Result := FastStringReplace(Result, ';', sLineBreak, [rfReplaceAll]);
end;

function TNFeUtilsFPDF.GetTextoFatura: string;
var
  textoIndPag: string;
  Separador: string;
begin
  if NFe.Cobr.Fat.nFat = '' then
    result := '';

  textoIndPag := '';
  if NFe.Ide.indPag = ipVista then
    textoIndPag := 'Pagamento � Vista - '
  else if NFe.Ide.indPag = ipPrazo then
    textoIndPag := 'Pagamento � Prazo - ';

  Separador := '   -   ';

  Result :=
    textoIndPag +
    IfThen(NFe.Cobr.Fat.nFat <> '', Format('Fatura: %s%s', [NFe.Cobr.Fat.nFat, separador])) +
    FormatFloat('Valor Original: R$ #,0.00', NFe.Cobr.Fat.vOrig, FFormatSettings) + separador +
    FormatFloat('Desconto: R$ #,0.00', NFe.Cobr.Fat.vDesc, FFormatSettings) + separador +
    FormatFloat('Valor L�quido: R$ #,0.00', NFe.Cobr.Fat.vLiq, FFormatSettings);
end;

function TNFeUtilsFPDF.NotaCancelada: boolean;
var
  cStat: integer;
begin
  cStat := NFe.procNFe.cStat;
  Result :=
    (cStat = 101) or
    (cStat = 151) or
    (cStat = 155);
end;

function TNFeUtilsFPDF.NotaDenegada: boolean;
var
  cStat: integer;
begin
  cStat := NFe.procNFe.cStat;
  Result :=
    (cStat = 110) or
    (cStat = 301) or
    (cStat = 302) or
    (cStat = 303);
end;

function TNFeUtilsFPDF.NotaEPEC: boolean;
begin
  Result := NFe.Ide.tpEmis = teDPEC;
end;

end.
