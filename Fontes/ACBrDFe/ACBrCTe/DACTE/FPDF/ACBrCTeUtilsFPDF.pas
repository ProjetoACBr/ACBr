{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Antonio Carlos Junior                           }
{                              Victor H. Gonzales - Pandaaa                    }
{                                                                              }
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

unit ACBrCTeUtilsFPDF;

interface

uses
  SysUtils,
  StrUtils,
  ACBrCTe.Classes,
  pcnConversao,
  pcteConversaoCTe,
  ACBrCTe,
  ACBrCTeDACTEClass,
  StrUtilsEx;

type
  TLogoAlign = (laLeft, laCenter, laRight, laFull);

  TPosRecibo = (prCabecalho, prRodape, prEsquerda);

  { TCTeUtilsFPDF }

  TCTeUtilsFPDF = class
    private
      FDACTEClassOwner: TACBrCTeDACTEClass;
      FCTe: TCTe;
      FFormatSettings: TFormatSettings;

    public
      function NotaCancelada: boolean;
      function GetChaveContingencia: string;

    public
      property CTe: TCTe read FCTe;

    public
      constructor Create(ACTe: TCTe; ADACTEClassOwner : TACBrCTeDACTEClass); overload;
      destructor Destroy; override;
      property FormatSettings: TFormatSettings read FFormatSettings write FFormatSettings;
  end;

  function TipoDocumentoAnteriorStr(const ATpDoc : TpcteTipoDocumentoAnterior):String;

implementation

{ TCTeUtilsFPDF }

function TCTeUtilsFPDF.NotaCancelada: boolean;
var
  cStat: integer;
begin
  cStat := CTe.procCTe.cStat;
  Result :=
    (cStat = 101) or
    (cStat = 151) or
    (cStat = 155);
end;

function TCTeUtilsFPDF.GetChaveContingencia: string;
var
  ACBrCTe: TACBrCTe;
begin
  ACBrCTe := TACBrCTe.Create(nil);
  try
    Result := ACBrCTe.GerarChaveContingencia(CTe);
  finally
    ACBrCTe.Free;
  end;
end;

constructor TCTeUtilsFPDF.Create(ACTe: TCTe; ADACTEClassOwner: TACBrCTeDACTEClass);
begin
  FCTe := ACTe;
  FDACTEClassOwner := ADACTEClassOwner;
end;

destructor TCTeUtilsFPDF.Destroy;
begin
  inherited;
end;

function TipoDocumentoAnteriorStr(const ATpDoc : TpcteTipoDocumentoAnterior):String;
begin
  case ATpDoc of
    daCTRC  : Result := 'CTRC';
    daCTAC  : Result := 'CTAC';
    daACT   : Result := 'ACT';
    daNF7   : Result := 'NF 7';
    daNF27  : Result := 'NF 27';
    daCAN   : Result := 'CAN';
    daCTMC  : Result := 'CTMC';
    daATRE  : Result := 'ATRE';
    daDTA   : Result := 'DTA';
    daCAI   : Result := 'CAI';
    daCCPI  : Result := 'CCPI';
    daCA    : Result := 'CA';
    daTIF   : Result := 'TIF';
    daOutros: Result := 'OUTROS';
    daBL    : Result := 'BL';
  end;
end;

end.
