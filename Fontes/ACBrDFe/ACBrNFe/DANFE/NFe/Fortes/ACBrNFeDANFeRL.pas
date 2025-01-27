{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Peterson de Cerqueira Matos                     }
{                              Wemerson Souto                                  }
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
unit ACBrNFeDANFeRL;

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, Qt,
  {$ELSE}
  Graphics, Controls, Forms, synautil,
  {$ENDIF}
  ACBrNFeDANFeRLClass, ACBrDFeReportFortes,
  ACBrNFe.Classes, RLReport, RLPDFFilter, RLFilters;

type

  { TfrlDANFeRL }

  TfrlDANFeRL = class(TForm)
    RLNFe: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
    procedure FormCreate(Sender: TObject);

  private
    procedure AdicionaInformacaoPDF;
    procedure AjustarEscala;

  protected
    fpNFe: TNFe;
    fpDANFe: TACBrNFeDANFeRL;
    fpCorDestaqueProdutos: TColor;
    fpLinhasUtilizadas: Integer;
    fpAuxDiferencaPDF: Integer;
    fpQuantItens: Integer;
    fpItemAtual: Integer;

  public
    class procedure Imprimir(ADANFe: TACBrNFeDANFeRL; ANotas: array of TNFe);
    class procedure SalvarPDF(ADANFe: TACBrNFeDANFeRL; ANFe: TNFe; const AFile: String); overload;
    class procedure SalvarPDF(ADANFe: TACBrNFeDANFeRL; ANFe: TNFe; AStream: TStream); overload;

  end;

implementation

uses
  StrUtils, Math,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime;

{$IfNDef FPC}
 {$R *.dfm}
{$Else}
 {$R *.lfm}
{$EndIf}

procedure TfrlDANFeRL.AdicionaInformacaoPDF;
var LNNF : String;
begin

  if fpDANFe.FormatarNumeroDocumento then
   LNNF := FormatFloat('000,000,000', fpNFe.Ide.nNF)
  else
   LNNF := IntToStr(fpNFe.Ide.nNF);

  RLPDFFilter1.DocumentInfo.Title := ACBrStr('DANFE - Nota fiscal n� ') + LNNF;
  RLPDFFilter1.DocumentInfo.KeyWords := ACBrStr('N�mero:' + LNNF +
    '; Data de emiss�o: ' + FormatDateBr(fpNFe.Ide.dEmi) + '; Destinat�rio: ' + fpNFe.Dest.xNome +
    '; CNPJ: ' + fpNFe.Dest.CNPJCPF + '; Valor total: ' + FormatFloatBr(fpNFe.Total.ICMSTot.vNF));
end;

class procedure TfrlDANFeRL.Imprimir(ADANFe: TACBrNFeDANFeRL; ANotas: array of TNFe);
var
  Report: TRLReport;
  ReportNext: TRLCustomReport;
  i: Integer;
  DANFeReport: TfrlDANFeRL;
  ReportArray: array of TfrlDANFeRL;
begin
  if (Length(ANotas) < 1) then
    Exit;

  DANFeReport := nil;
  try
    SetLength(ReportArray, Length(ANotas));

    for i := 0 to High(ANotas) do
    begin
      DANFeReport := Create(nil);
      DANFeReport.fpNFe := ANotas[i];
      DANFeReport.fpDANFe := ADANFe;
      DANFeReport.AjustarEscala;

      DANFeReport.RLNFe.CompositeOptions.ResetPageNumber := True;
      DANFeReport.fpAuxDiferencaPDF := 0;
      ReportArray[i] := DANFeReport;
    end;

    Report := ReportArray[0].RLNFe;
    //Associa cada Report com o pr�ximo;
    for i := 1 to High(ReportArray) do
    begin
      ReportNext := Report;
      while (ReportNext.NextReport <> nil) do
      begin
        ReportNext := ReportNext.NextReport;
      end;
      ReportNext.NextReport := ReportArray[i].RLNFe;
    end;

    TDFeReportFortes.AjustarReport(Report, ADANFe);

    if ADANFe.MostraPreview then
    begin
      if Assigned(DANFeReport) then
        SelectedFilter := DANFeReport.RLPDFFilter1;

      Report.PreviewModal;
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

class procedure TfrlDANFeRL.SalvarPDF(ADANFe: TACBrNFeDANFeRL; ANFe: TNFe; const AFile: String);
var
  DANFeReport: TfrlDANFeRL;
begin
  DANFeReport := Create(nil);
  try
    DANFeReport.fpNFe := ANFe;
    DANFeReport.fpDANFe := ADANFe;
    DANFeReport.AjustarEscala;

    TDFeReportFortes.AjustarReport(DANFeReport.RLNFe, DANFeReport.fpDANFe);
    TDFeReportFortes.AjustarFiltroPDF(DANFeReport.RLPDFFilter1, DANFeReport.fpDANFe, AFile);

    DANFeReport.AdicionaInformacaoPDF;

    DANFeReport.fpAuxDiferencaPDF := 10;
    DANFeReport.RLNFe.Prepare;
    DANFeReport.RLPDFFilter1.FilterPages(DANFeReport.RLNFe.Pages);
  finally
    FreeAndNil(DANFeReport);
  end;
end;

class procedure TfrlDANFeRL.SalvarPDF(ADANFe: TACBrNFeDANFeRL; ANFe: TNFe; AStream: TStream);
var
  DANFeReport: TfrlDANFeRL;
begin
  DANFeReport := Create(nil);
  try
    DANFeReport.fpNFe := ANFe;
    DANFeReport.fpDANFe := ADANFe;
    DANFeReport.AjustarEscala;

    TDFeReportFortes.AjustarReport(DANFeReport.RLNFe, DANFeReport.fpDANFe);
    DANFeReport.RLPDFFilter1.ShowProgress := DANFeReport.fpDANFe.MostraStatus;

    DANFeReport.AdicionaInformacaoPDF;

    DANFeReport.fpAuxDiferencaPDF := 10;
    DANFeReport.RLNFe.Prepare;
    DANFeReport.RLPDFFilter1.FilterPages(DANFeReport.RLNFe.Pages, AStream);
  finally
    FreeAndNil(DANFeReport);
  end;
end;

procedure TfrlDANFeRL.AjustarEscala;
begin
  if fpDANFe.AlterarEscalaPadrao then
  begin
    Scaled := False;
    ScaleBy(fpDANFe.NovaEscala, Screen.PixelsPerInch);
  end;
end;

procedure TfrlDANFeRL.FormCreate(Sender: TObject);
begin
  {$IfNDef FPC}
  Self.Scaled := False;
  {$EndIf}
  fpCorDestaqueProdutos := StringToColor('$00E5E5E5');
end;

end.
