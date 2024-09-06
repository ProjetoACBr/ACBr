{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

unit ACBrMDFeDAEventoRL;

interface

uses
  SysUtils, 
  Variants, 
  Classes, 
  Graphics, 
  Controls, 
  Forms, 
  Dialogs, 
  ExtCtrls,
  {$IFDEF BORLAND}
	DB, 
	DBClient, 
  {$ELSE}
	BufDataset, 
	DB, 
	RLFilters, 
  {$ENDIF}
  RLReport, 
  RLPDFFilter, 
  RLPrinters,
  ACBrMDFe, 
  ACBrMDFeDAMDFeRLClass, 
  ACBrDFeReportFortes,
  pmdfeMDFe, 
  pcnConversao, 
  pmdfeEnvEventoMDFe;

type

  { TfrmMDFeDAEventoRL }

  TfrmMDFeDAEventoRL = class(TForm)
    Datasource1: TDatasource;
    RLMDFeEvento: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
    procedure FormDestroy(Sender: TObject);
  private
    procedure AdicionaInformacaoPDF;
    procedure AjustarEscala;
  protected
    fpACBrMDFe: TACBrMDFe;
    fpMDFe: TMDFe;
    fpEventoMDFe: TInfEventoCollectionItem;
    fpDAMDFe: TACBrMDFeDAMDFeRL;

  public
    class procedure Imprimir(ADAMDFe: TACBrMDFeDAMDFeRL;
      AEventoMDFe: TInfEventoCollectionItem; AMDFe: TMDFe = nil);
    class procedure SalvarPDF(ADAMDFe: TACBrMDFeDAMDFeRL;
      AEventoMDFe: TInfEventoCollectionItem; AFile: string; AMDFe: TMDFe = nil); overload;
    class procedure SalvarPDF(ADAMDFe: TACBrMDFeDAMDFeRL;
      AEventoMDFe: TInfEventoCollectionItem; AStream: TStream; AMDFe: TMDFe = nil); overload;
  end;

implementation

uses
  ACBrUtil.Strings;

{$ifdef FPC}
 {$R *.lfm}
{$else}
 {$R *.dfm}

{$endif}

class procedure TfrmMDFeDAEventoRL.Imprimir(ADAMDFe: TACBrMDFeDAMDFeRL;
  AEventoMDFe: TInfEventoCollectionItem; AMDFe: TMDFe);
var
  DAMDFeReport: TfrmMDFeDAEventorl;
begin
  DAMDFeReport := Create(nil);
  try
    DAMDFeReport.fpDAMDFe := ADAMDFe;
    DAMDFeReport.fpEventoMDFe := AEventoMDFe;

    DAMDFeReport.AjustarEscala;

    TDFeReportFortes.AjustarReport(DAMDFeReport.RLMDFeEvento, DAMDFeReport.fpDAMDFe);
    TDFeReportFortes.AjustarMargem(DAMDFeReport.RLMDFeEvento, DAMDFeReport.fpDAMDFe);

    if (AMDFe <> nil) then
      DAMDFeReport.fpMDFe := AMDFe;

    if DAMDFeReport.fpDAMDFe.MostraPreview then
      DAMDFeReport.RLMDFeEvento.PreviewModal
    else
      DAMDFeReport.RLMDFeEvento.Print;
  finally
    DAMDFeReport.Free;
  end;
end;

class procedure TfrmMDFeDAEventoRL.SalvarPDF(ADAMDFe: TACBrMDFeDAMDFeRL;
  AEventoMDFe: TInfEventoCollectionItem; AFile: string; AMDFe: TMDFe);
var
  DAMDFeReport: TfrmMDFeDAEventorl;
begin
  DAMDFeReport := Create(nil);
  try;
    DAMDFeReport.fpDAMDFe := ADAMDFe;
    DAMDFeReport.fpEventoMDFe := AEventoMDFe;

    DAMDFeReport.AjustarEscala;

    TDFeReportFortes.AjustarReport(DAMDFeReport.RLMDFeEvento, DAMDFeReport.fpDAMDFe);
    TDFeReportFortes.AjustarMargem(DAMDFeReport.RLMDFeEvento, DAMDFeReport.fpDAMDFe);
    TDFeReportFortes.AjustarFiltroPDF(DAMDFeReport.RLPDFFilter1, DAMDFeReport.fpDAMDFe, AFile);

    if (AMDFe <> nil) then
      DAMDFeReport.fpMDFe := AMDFe;

    DAMDFeReport.AdicionaInformacaoPDF;

    DAMDFeReport.RLMDFeEvento.Prepare;
    DAMDFeReport.RLPDFFilter1.FilterPages(DAMDFeReport.RLMDFeEvento.Pages);
  finally
    DAMDFeReport.Free;
  end;
end;

class procedure TfrmMDFeDAEventoRL.SalvarPDF(ADAMDFe: TACBrMDFeDAMDFeRL;
  AEventoMDFe: TInfEventoCollectionItem; AStream: TStream; AMDFe: TMDFe);
var
  DAMDFeReport: TfrmMDFeDAEventorl;
begin
  DAMDFeReport := Create(nil);
  try;
    DAMDFeReport.fpDAMDFe := ADAMDFe;
    DAMDFeReport.fpEventoMDFe := AEventoMDFe;

    DAMDFeReport.AjustarEscala;

    TDFeReportFortes.AjustarReport(DAMDFeReport.RLMDFeEvento, DAMDFeReport.fpDAMDFe);
    TDFeReportFortes.AjustarMargem(DAMDFeReport.RLMDFeEvento, DAMDFeReport.fpDAMDFe);
//    TDFeReportFortes.AjustarFiltroPDF(DAMDFeReport.RLPDFFilter1, DAMDFeReport.fpDAMDFe, AFile);

    if (AMDFe <> nil) then
      DAMDFeReport.fpMDFe := AMDFe;
    DAMDFeReport.AdicionaInformacaoPDF;

    DAMDFeReport.RLMDFeEvento.Prepare;
    DAMDFeReport.RLPDFFilter1.FilterPages(DAMDFeReport.RLMDFeEvento.Pages,AStream);
  finally
    DAMDFeReport.Free;
  end;
end;

procedure TfrmMDFeDAEventoRL.FormDestroy(Sender: TObject);
begin
  RLMDFeEvento.Free;
end;

procedure TfrmMDFeDAEventoRL.AdicionaInformacaoPDF;
begin
  with RLPDFFilter1.DocumentInfo do
  begin
      Title := ACBrStr(Format('DAMDFe EVENTO - MDFe %s', [fpEventoMDFe.RetInfEvento.chMDFe]));
      KeyWords := ACBrStr(Format('N�mero: %s; Data de emiss�o: %s; CNPJ: %s',
        [FormatFloat('000,000,000', fpEventoMDFe.RetInfEvento.nSeqEvento),
        FormatDateTime('dd/mm/yyyy', fpEventoMDFe.RetInfEvento.dhRegEvento),
        fpEventoMDFe.InfEvento.CNPJCPF]));
  end;
end;

procedure TfrmMDFeDAEventoRL.AjustarEscala;
begin
  if fpDAMDFe.AlterarEscalaPadrao then
  begin
    Scaled := False;
    ScaleBy(fpDAMDFe.NovaEscala, Screen.PixelsPerInch);
  end;
end;

end.
