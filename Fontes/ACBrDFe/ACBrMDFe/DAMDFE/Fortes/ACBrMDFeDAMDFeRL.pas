{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit ACBrMDFeDAMDFeRL;

interface

uses
  SysUtils, 
  Variants, 
  Classes, 
  Graphics, 
  Controls, 
  Forms, 
  ExtCtrls,
  RLReport, 
  RLFilters, 
  RLPrinters, 
  RLPDFFilter, 
  RLConsts,
  ACBrMDFe.Classes,
  ACBrMDFe, 
  ACBrMDFeDAMDFeRLClass, 
  ACBrDFeReportFortes;

type

  { TfrlDAMDFeRL }

  TfrlDAMDFeRL = class(TForm)
    RLMDFe: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
  private
    procedure AdicionaInformacaoPDF;
    procedure AjustarEscala;
  protected
    fpACBrMDFe: TACBrMDFe;
    fpMDFe: TMDFe;
    fpDAMDFe: TACBrMDFeDAMDFeRL;
    fpAfterPreview: boolean;
    fpChangedPos: boolean;
    fpSemValorFiscal: boolean;
    fpAuxDiferencaPDF: Integer;

    procedure rllSemValorFiscalPrint(Sender: TObject; var Value: string);
  public
    { Public declarations }
    class procedure Imprimir(ADAMDFe: TACBrMDFeDAMDFeRL; AMDFes: array of TMDFe);
    class procedure SalvarPDF(ADAMDFe: TACBrMDFeDAMDFeRL; AMDFe: TMDFe; const AFile: String); overload;
    class procedure SalvarPDF(ADANFe: TACBrMDFeDAMDFeRL; AMDFe: TMDFe; AStream: TStream); overload;

  end;

implementation

uses
  ACBrUtil.Strings, ACBrUtil.DateTime;

{$ifdef FPC}
 {$R *.lfm}
{$else}
 {$R *.dfm}
{$endif}

procedure TfrlDAMDFeRL.AdicionaInformacaoPDF;
begin
  with RLPDFFilter1.DocumentInfo do
  begin
    Title := ACBrStr('DAMDFe - MDFe n� ') +
        FormatFloat('000,000,000', fpMDFe.Ide.nMDF);
    KeyWords := ACBrStr('N�mero:') + FormatFloat('000,000,000', fpMDFe.Ide.nMDF) +
        ACBrStr('; Data de emiss�o: ') + FormatDateTime('dd/mm/yyyy', fpMDFe.Ide.dhEmi) +
        '; CNPJ: ' + fpMDFe.emit.CNPJCPF;
  end;
end;

procedure TfrlDAMDFeRL.AjustarEscala;
begin
  if fpDAMDFe.AlterarEscalaPadrao then
  begin
    Scaled := False;
    ScaleBy(fpDAMDFe.NovaEscala, Screen.PixelsPerInch);
  end;
end;

class procedure TfrlDAMDFeRL.Imprimir(ADAMDFe: TACBrMDFeDAMDFeRL; AMDFes: array of TMDFe);
var
  Report: TRLReport;
  ReportNext: TRLCustomReport;
  i: Integer;
  DAMDFeReport: TfrlDAMDFeRL;
  ReportArray: array of TfrlDAMDFeRL;
begin
  if (Length(AMDFes) < 1) then
    Exit;

  DAMDFeReport := nil;

  try
    SetLength(ReportArray, Length(AMDFes));

    for i := 0 to High(AMDFes) do
    begin
      DAMDFeReport := Create(nil);
      DAMDFeReport.fpMDFe := AMDFes[i];
      DAMDFeReport.fpDAMDFe := ADAMDFe;
      DAMDFeReport.AjustarEscala;

      DAMDFeReport.RLMDFe.CompositeOptions.ResetPageNumber := True;
      DAMDFeReport.fpAuxDiferencaPDF := 0;
      ReportArray[i] := DAMDFeReport;
    end;

    if Length(ReportArray) = 0 then
      raise Exception.Create('Nenhum relatorio foi inicializado.');

    Report := ReportArray[0].RLMDFe;
    for i := 1 to High(ReportArray) do
    begin
      if (Report.NextReport = nil) then
        Report.NextReport := ReportArray[i].RLMDFe
      else
      begin
        ReportNext := Report.NextReport;

        repeat
          if (ReportNext.NextReport <> nil) then
            ReportNext := ReportNext.NextReport;
        until (ReportNext.NextReport = nil);

        ReportNext.NextReport := ReportArray[i].RLMDFe;
      end;
    end;

    TDFeReportFortes.AjustarReport(Report, ADAMDFe);
    TDFeReportFortes.AjustarMargem(Report, ADAMDFe);

    if ADAMDFe.MostraPreview then
    begin
      if Assigned(DAMDFeReport) then
        SelectedFilter := DAMDFeReport.RLPDFFilter1;
      Report.PreviewModal
    end
    else
      Report.Print;
  finally
    if (ReportArray <> nil) then
    begin
      for i := 0 to High(ReportArray) do
        FreeAndNil(ReportArray[i]);

      SetLength(ReportArray, 0);
      Finalize(ReportArray);
      ReportArray := nil;
    end;
  end;
end;

class procedure TfrlDAMDFeRL.SalvarPDF(ADAMDFe: TACBrMDFeDAMDFeRL; AMDFe: TMDFe;
  const AFile: String);
var
  DAMDFeReport: TfrlDAMDFeRL;
//  ADir: String;
begin
  DAMDFeReport := Create(nil);
  try
    DAMDFeReport.fpMDFe := AMDFe;
    DAMDFeReport.fpDAMDFe := ADAMDFe;

    DAMDFeReport.AjustarEscala;

    TDFeReportFortes.AjustarReport(DAMDFeReport.RLMDFe, DAMDFeReport.fpDAMDFe);
    TDFeReportFortes.AjustarFiltroPDF(DAMDFeReport.RLPDFFilter1, DAMDFeReport.fpDAMDFe, AFile);

    DAMDFeReport.AdicionaInformacaoPDF;

    DAMDFeReport.fpAuxDiferencaPDF := 10;
    DAMDFeReport.RLMDFe.Prepare;
    DAMDFeReport.RLPDFFilter1.FilterPages(DAMDFeReport.RLMDFe.Pages);
  finally
    FreeAndNil(DAMDFeReport);
  end;
end;

class procedure TfrlDAMDFeRL.SalvarPDF(ADANFe: TACBrMDFeDAMDFeRL; AMDFe: TMDFe;
  AStream: TStream);
var
  DAMDFeReport: TfrlDAMDFeRL;
begin
  DAMDFeReport := Create(nil);
  try
    DAMDFeReport.fpMDFe := AMDFe;
    DAMDFeReport.fpDAMDFe := ADANFe;
    DAMDFeReport.AjustarEscala;

    TDFeReportFortes.AjustarReport(DAMDFeReport.RLMDFe, DAMDFeReport.fpDAMDFe);
    DAMDFeReport.RLPDFFilter1.ShowProgress := DAMDFeReport.fpDAMDFe.MostraStatus;

    DAMDFeReport.AdicionaInformacaoPDF;

    DAMDFeReport.fpAuxDiferencaPDF := 10;
    DAMDFeReport.RLMDFe.Prepare;
    DAMDFeReport.RLPDFFilter1.FilterPages(DAMDFeReport.RLMDFe.Pages, AStream);
  finally
    FreeAndNil(DAMDFeReport);
  end;
end;

procedure TfrlDAMDFeRL.rllSemValorFiscalPrint(Sender: TObject; var Value: string);
begin
  inherited;
  if fpSemValorFiscal then
    Value := '';
end;

end.
