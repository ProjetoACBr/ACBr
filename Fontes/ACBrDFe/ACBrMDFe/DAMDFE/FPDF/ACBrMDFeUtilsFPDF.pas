{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Antonio Carlos Junior                           }
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

unit ACBrMDFeUtilsFPDF;

interface

uses
  SysUtils,
  StrUtils,
  ACBrMDFe.Classes,
  pcnConversao,
  ACBrMDFe,
  ACBrMDFeDAMDFeClass,
  StrUtilsEx;

type
  TLogoAlign = (laLeft, laCenter, laRight, laFull);

  TPosRecibo = (prCabecalho, prRodape, prEsquerda);

  { TMDFeUtilsFPDF }

  TMDFeUtilsFPDF = class
    private
      FDAMDFEClassOwner: TACBrMDFeDAMDFEClass;
      FMDFe: TMDFe;
      FFormatSettings: TFormatSettings;

    public
      function NotaCancelada: boolean;
      function GetChaveContingencia: string;

    public
      property MDFe: TMDFe read FMDFe;

    public
      constructor Create(AMDFe: TMDFe; ADAMDFEClassOwner : TACBrMDFeDAMDFEClass); overload;
      destructor Destroy; override;
      property FormatSettings: TFormatSettings read FFormatSettings write FFormatSettings;
  end;

implementation

{ TMDFeUtilsFPDF }

function TMDFeUtilsFPDF.NotaCancelada: boolean;
var
  cStat: integer;
begin
  cStat := MDFe.procMDFe.cStat;
  Result :=
    (cStat = 101) or
    (cStat = 151) or
    (cStat = 155);
end;

function TMDFeUtilsFPDF.GetChaveContingencia: string;
var
  ACBrMDFe: TACBrMDFe;
begin
  ACBrMDFe := TACBrMDFe.Create(nil);
  try
    Result := ACBrMDFe.GerarChaveContingencia(MDFe);
  finally
    ACBrMDFe.Free;
  end;
end;

constructor TMDFeUtilsFPDF.Create(AMDFe: TMDFe; ADAMDFEClassOwner: TACBrMDFeDAMDFEClass);
begin
  FMDFe := AMDFe;
end;

destructor TMDFeUtilsFPDF.Destroy;
begin
  inherited;
end;

end.
