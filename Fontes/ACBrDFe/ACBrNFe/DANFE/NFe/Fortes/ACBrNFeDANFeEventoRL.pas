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

unit ACBrNFeDANFeEventoRL;

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QControls, QForms, QExtCtrls, Qt,
  {$ELSE}
  Controls, Forms, ExtCtrls,
  {$ENDIF}
  ACBrNFe.EnvEvento,
  pcnNFe,
  ACBrNFeDANFeRLClass, ACBrDFeReportFortes,
  RLReport, RLPDFFilter, RLFilters;

type

  { TfrlDANFeEventoRL }

  TfrlDANFeEventoRL = class(TForm)
    RLEvento: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
  protected
    fpNFe: TNFe;
    fpDANFe: TACBrNFeDANFeRL;
    fpEventoNFe: TInfEventoCollectionItem;
  public
    { Public declarations }
    class procedure Imprimir(ADANFe: TACBrNFeDANFeRL; FEventoNFe: TInfEventoCollectionItem; ANFe: TNFe = nil);
    class procedure SalvarPDF(ADANFe: TACBrNFeDANFeRL; FEventoNFe: TInfEventoCollectionItem; const AFile: String;
                              ANFe: TNFe = nil); overload;
    class procedure SalvarPDF(ADANFe: TACBrNFeDANFeRL; FEventoNFe: TInfEventoCollectionItem; AStream: TStream;
                              ANFe: TNFe = nil); overload;

  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime;

{$IfNDef FPC}
  {$R *.dfm}
{$Else}
  {$R *.lfm}
{$EndIf}

class procedure TfrlDANFeEventoRL.Imprimir(ADANFe: TACBrNFeDANFeRL; FEventoNFe: TInfEventoCollectionItem;
                                           ANFe: TNFe = nil);
var
  DANFeReport: TfrlDANFeEventoRL;
begin
  DANFeReport := Create(nil);
  try
    DANFeReport.fpDANFe := ADANFe;
    DANFeReport.fpEventoNFe := FEventoNFe;
    if ADANFe.AlterarEscalaPadrao then
    begin
      DANFeReport.Scaled := False;
      DANFeReport.ScaleBy(ADANFe.NovaEscala , Screen.PixelsPerInch);
    end;
    TDFeReportFortes.AjustarReport(DANFeReport.RLEvento, DANFeReport.fpDANFe);

    if (ANFe <> nil) then
      DANFeReport.fpNFe := ANFe;

    if ADANFe.MostraPreview then 
    begin
      if Assigned(DANFeReport) then
        SelectedFilter := DANFeReport.RLPDFFilter1;
      if Assigned(DANFeReport.fpNFe) then
      begin
        DANFeReport.RLEvento.Title := OnlyNumber(DANFeReport.fpNFe.InfNFe.Id);
      end;
      DANFeReport.RLEvento.PreviewModal
    end
    else
      DANFeReport.RLEvento.Print;
  finally
    DANFeReport.Free;
  end;
end;

class procedure TfrlDANFeEventoRL.SalvarPDF(ADANFe: TACBrNFeDANFeRL; FEventoNFe: TInfEventoCollectionItem;
                                            const AFile: String; ANFe: TNFe = nil);
var
  DANFeReport: TfrlDANFeEventoRL;
  LNNF : string;
begin
  DANFeReport := Create(nil);
  try;
    DANFeReport.fpDANFe := ADANFe;
    DANFeReport.fpEventoNFe := FEventoNFe;
    if ADANFe.AlterarEscalaPadrao then
    begin
      DANFeReport.Scaled := False;
      DANFeReport.ScaleBy(ADANFe.NovaEscala , Screen.PixelsPerInch);
    end;
    TDFeReportFortes.AjustarReport(DANFeReport.RLEvento, DANFeReport.fpDANFe);
    TDFeReportFortes.AjustarFiltroPDF(DANFeReport.RLPDFFilter1, DANFeReport.fpDANFe, AFile);

    if (ANFe <> nil) then
    begin
      DANFeReport.fpNFe := ANFe;

      with DANFeReport.RLPDFFilter1.DocumentInfo do
      begin
        if DANFeReport.fpDANFe.FormatarNumeroDocumento then
          LNNF := FormatFloat('000,000,000', DANFeReport.fpNFe.Ide.nNF)
        else
          IntToStr(DANFeReport.fpNFe.Ide.nNF);

        Title := ACBrStr('Evento - Nota fiscal n� ') + LNNF;
        KeyWords := ACBrStr(
          'N�mero:' + LNNF +
          '; Data de emiss�o: ' + FormatDateBr(DANFeReport.fpNFe.Ide.dEmi) +
          '; Destinat�rio: ' + DANFeReport.fpNFe.Dest.xNome +
          '; CNPJ: ' + DANFeReport.fpNFe.Dest.CNPJCPF +
          '; Valor total: ' + FormatFloatBr(DANFeReport.fpNFe.Total.ICMSTot.vNF));
      end;
    end;

    DANFeReport.RLEvento.Prepare;
    DANFeReport.RLPDFFilter1.FilterPages(DANFeReport.RLEvento.Pages);
  finally
    DANFeReport.Free;
  end;
end;

class procedure TfrlDANFeEventoRL.SalvarPDF(ADANFe: TACBrNFeDANFeRL; FEventoNFe: TInfEventoCollectionItem;
                                            AStream: TStream; ANFe: TNFe = nil);
var
  DANFeReport: TfrlDANFeEventoRL;
  LNNF : string;
begin
  DANFeReport := Create(nil);
  try;
    DANFeReport.fpDANFe := ADANFe;
    DANFeReport.fpEventoNFe := FEventoNFe;

    if ADANFe.AlterarEscalaPadrao then
    begin
      DANFeReport.Scaled := False;
      DANFeReport.ScaleBy(ADANFe.NovaEscala , Screen.PixelsPerInch);
    end;

    TDFeReportFortes.AjustarReport(DANFeReport.RLEvento, DANFeReport.fpDANFe);
    DANFeReport.RLPDFFilter1.ShowProgress := DANFeReport.fpDANFe.MostraStatus;

    if (ANFe <> nil) then
    begin
      DANFeReport.fpNFe := ANFe;

      with DANFeReport.RLPDFFilter1.DocumentInfo do
      begin
        if DANFeReport.fpDANFe.FormatarNumeroDocumento then
          LNNF := FormatFloat('000,000,000', DANFeReport.fpNFe.Ide.nNF)
        else
          LNNF := IntToStr(DANFeReport.fpNFe.Ide.nNF);

        Title := ACBrStr('Evento - Nota fiscal n� ') + LNNF;
        KeyWords := ACBrStr(
          'N�mero:' + LNNF +
          '; Data de emiss�o: ' + FormatDateBr(DANFeReport.fpNFe.Ide.dEmi) +
          '; Destinat�rio: ' + DANFeReport.fpNFe.Dest.xNome +
          '; CNPJ: ' + DANFeReport.fpNFe.Dest.CNPJCPF +
          '; Valor total: ' + FormatFloatBr(DANFeReport.fpNFe.Total.ICMSTot.vNF));
      end;
    end;

    DANFeReport.RLEvento.Prepare;
    DANFeReport.RLPDFFilter1.FilterPages(DANFeReport.RLEvento.Pages, AStream);
  finally
    DANFeReport.Free;
  end;
end;

end.
