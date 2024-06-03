{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliomar Marchetti                              }
{                              Daniel Simoes de Almeida                        }
{                              Andr� Ferreira de Moraes                        }
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

unit ACBrNFeDAInutRL;


interface

uses
  SysUtils, Classes,
  {$IFNDEF NOGUI}
	{$IFDEF CLX}
	  QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt,
	{$ELSE}
	  Graphics, Controls, Forms, Dialogs, ExtCtrls,
	{$ENDIF}
  {$ENDIF}
  pcnNFe,
  ACBrNFe.Inut,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime,
  ACBrNFeDANFeRLClass, ACBrDFeReportFortes,
  RLReport, RLFilters, RLPDFFilter;

type

  { TfrmNFeDAInutRL }

  TfrmNFeDAInutRL = class(TForm)
    RLNFeInut: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
  protected
    fpInutNFe: TInutNFe;
    fpNFe: TNFe;
    fpDANFe: TACBrNFeDANFeRL;
  public
    class procedure Imprimir(aDANFe: TACBrNFeDANFeRL; AInutNFe: TInutNFe; ANFe: TNFe = nil);
    class procedure SalvarPDF(aDANFe: TACBrNFeDANFeRL; AInutNFe: TInutNFe; const AFile: String = ''; ANFe: TNFe = nil); overload;
    class procedure SalvarPDF(aDANFe: TACBrNFeDANFeRL; AInutNFe: TInutNFe; AStream: TStream; ANFe: TNFe = nil); overload;

  end;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

class procedure TfrmNFeDAInutRL.Imprimir(aDANFe: TACBrNFeDANFeRL; AInutNFe: TInutNFe; ANFe: TNFe = nil);
Var
   DANFeReport: TfrmNFeDAInutRL;
begin
  DANFeReport := Create(nil);
  try
    DANFeReport.fpDANFe := aDANFe;
    DANFeReport.fpInutNFe := AInutNFe;
    if ADANFe.AlterarEscalaPadrao then
    begin
      DANFeReport.Scaled := False;
      DANFeReport.ScaleBy(ADANFe.NovaEscala , Screen.PixelsPerInch);
    end;
    TDFeReportFortes.AjustarReport(DANFeReport.RLNFeInut, DANFeReport.fpDANFe);

    if ANFe <> nil then
      DANFeReport.fpNFe := ANFe;

    if aDANFe.MostraPreview then
      DANFeReport.RLNFeInut.PreviewModal
    else
      DANFeReport.RLNFeInut.Print;
  finally
     DANFeReport.Free;
  end;
end;

class procedure TfrmNFeDAInutRL.SalvarPDF(aDANFe: TACBrNFeDANFeRL; AInutNFe: TInutNFe; const AFile: String = ''; ANFe: TNFe = nil);
var
   i :integer;
   DANFeReport: TfrmNFeDAInutRL;
begin
  DANFeReport := Create(nil);
  try
    DANFeReport.fpDANFe := aDANFe;
    DANFeReport.fpInutNFe := AInutNFe;
    if ADANFe.AlterarEscalaPadrao then
    begin
      DANFeReport.Scaled := False;
      DANFeReport.ScaleBy(ADANFe.NovaEscala , Screen.PixelsPerInch);
    end;
    TDFeReportFortes.AjustarReport(DANFeReport.RLNFeInut, DANFeReport.fpDANFe);
    TDFeReportFortes.AjustarFiltroPDF(DANFeReport.RLPDFFilter1, DANFeReport.fpDANFe, AFile);

    if ANFe <> nil then
    begin
      DANFeReport.fpNFe := ANFe;

      with DANFeReport.RLPDFFilter1.DocumentInfo do
      begin
        Title := ACBrStr('Inutiliza��o - Nota fiscal n� ' +
          FormatFloat('000,000,000', DANFeReport.fpNFe.Ide.nNF));
        KeyWords := ACBrStr('N�mero:' + FormatFloat('000,000,000', DANFeReport.fpNFe.Ide.nNF) +
          '; Data de emiss�o: ' + FormatDateTime('dd/mm/yyyy', DANFeReport.fpNFe.Ide.dEmi) +
          '; Destinat�rio: ' + DANFeReport.fpNFe.Dest.xNome +
          '; CNPJ: ' + DANFeReport.fpNFe.Dest.CNPJCPF);
      end;
    end;

    for i := 0 to DANFeReport.ComponentCount -1 do
    begin
      if (DANFeReport.Components[i] is TRLDraw) and (TRLDraw(DANFeReport.Components[i]).DrawKind = dkRectangle) then
      begin
       TRLDraw(DANFeReport.Components[i]).DrawKind := dkRectangle;
       TRLDraw(DANFeReport.Components[i]).Pen.Width := 1;
      end;
    end;

    DANFeReport.RLNFeInut.Prepare;
    DANFeReport.RLPDFFilter1.FilterPages(DANFeReport.RLNFeInut.Pages);
  finally
     DANFeReport.Free;
  end;
end;

class procedure TfrmNFeDAInutRL.SalvarPDF(aDANFe: TACBrNFeDANFeRL; AInutNFe: TInutNFe; AStream: TStream; ANFe: TNFe = nil);
var
   i :integer;
   DANFeReport: TfrmNFeDAInutRL;
begin
  DANFeReport := Create(nil);
  try
    DANFeReport.fpDANFe := aDANFe;
    DANFeReport.fpInutNFe := AInutNFe;
    if ADANFe.AlterarEscalaPadrao then
    begin
      DANFeReport.Scaled := False;
      DANFeReport.ScaleBy(ADANFe.NovaEscala , Screen.PixelsPerInch);
    end;
    TDFeReportFortes.AjustarReport(DANFeReport.RLNFeInut, DANFeReport.fpDANFe);
    DANFeReport.RLPDFFilter1.ShowProgress := DANFeReport.fpDANFe.MostraStatus;

    if ANFe <> nil then
    begin
      DANFeReport.fpNFe := ANFe;

      with DANFeReport.RLPDFFilter1.DocumentInfo do
      begin
        Title := ACBrStr('Inutiliza��o - Nota fiscal n� ' +
          FormatFloat('000,000,000', DANFeReport.fpNFe.Ide.nNF));
        KeyWords := ACBrStr('N�mero:' + FormatFloat('000,000,000', DANFeReport.fpNFe.Ide.nNF) +
          '; Data de emiss�o: ' + FormatDateTime('dd/mm/yyyy', DANFeReport.fpNFe.Ide.dEmi) +
          '; Destinat�rio: ' + DANFeReport.fpNFe.Dest.xNome +
          '; CNPJ: ' + DANFeReport.fpNFe.Dest.CNPJCPF);
      end;
    end;

    for i := 0 to DANFeReport.ComponentCount -1 do
    begin
      if (DANFeReport.Components[i] is TRLDraw) and (TRLDraw(DANFeReport.Components[i]).DrawKind = dkRectangle) then
      begin
       TRLDraw(DANFeReport.Components[i]).DrawKind := dkRectangle;
       TRLDraw(DANFeReport.Components[i]).Pen.Width := 1;
      end;
    end;

    DANFeReport.RLNFeInut.Prepare;
    DANFeReport.RLPDFFilter1.FilterPages(DANFeReport.RLNFeInut.Pages, AStream);
  finally
     DANFeReport.Free;
  end;
end;

end.
