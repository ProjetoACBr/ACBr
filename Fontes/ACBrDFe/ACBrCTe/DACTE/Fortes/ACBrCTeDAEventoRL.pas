{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
{                              Mark dos Santos Gon�alves                       }
{                              Juliomar Marchetti                              }
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

unit ACBrCTeDAEventoRL;

interface

uses
  SysUtils, Variants, Classes, StrUtils,
  {$IFDEF CLX}QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt,
  {$ELSE}{$IFDEF MSWINDOWS}Windows, Messages, {$ENDIF}
  Graphics, Controls, Forms, Dialogs, ExtCtrls, {$ENDIF}
  {$IFDEF BORLAND} DBClient, {$ELSE} BufDataset, {$ENDIF} DB,
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts, RLBarcode,
  ACBrCTe, ACBrCTeDACTeRLClass,
  pcteCTe, pcnConversao, ACBrCTe.EnvEvento;

type

  { TfrmCTeDAEventoRL }

  TfrmCTeDAEventoRL = class(TForm)
    Datasource1: TDatasource;
    RLCTeEvento: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  protected
    fpACBrCTe: TACBrCTe;
    fpDACTe: TACBrCTeDACTeRL;
    fpCTe: TCTe;
    fpEventoCTe: TInfEventoCollectionItem;

    cdsDocumentos: {$IFDEF BORLAND} TClientDataSet {$ELSE} TBufDataset{$ENDIF};
    procedure ConfigDataSet;

  public
    class procedure Imprimir(aDACTe: TACBrCTeDACTeRL; AEventoCTe: TInfEventoCollectionItem; ACTe: TCTe = nil);
    class procedure SalvarPDF(aDACTe: TACBrCTeDACTeRL; AEventoCTe: TInfEventoCollectionItem; AFile: string;
                              ACTe: TCTe = nil); overload;
    class procedure SalvarPDF(ADACTe: TACBrCTeDACTeRL; FEventoCTe: TInfEventoCollectionItem; AStream: TStream;
                              ACTe: TCTe = nil); overload;
  end;

implementation

uses
  MaskUtils,
  ACBrUtil.Strings, ACBrUtil.Base, ACBrUtil.DateTime,
  ACBrDFeReportFortes;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

class procedure TfrmCTeDAEventoRL.Imprimir(aDACTe: TACBrCTeDACTeRL; AEventoCTe: TInfEventoCollectionItem;
  ACTe: TCTe= nil);
var
  DACTeEvReport: TfrmCTeDAEventoRL;
begin
  DACTeEvReport := Create(nil);
  try
    DACTeEvReport.fpDACTe := aDACTe;
    DACTeEvReport.fpEventoCTe := AEventoCTe;
    if aDACTe.AlterarEscalaPadrao then
    begin
      DACTeEvReport.Scaled := False;
      DACTeEvReport.ScaleBy(aDACTe.NovaEscala , Screen.PixelsPerInch);
    end;
    TDFeReportFortes.AjustarReport(DACTeEvReport.RLCTeEvento, DACTeEvReport.fpDACTe);
    TDFeReportFortes.AjustarMargem(DACTeEvReport.RLCTeEvento, DACTeEvReport.fpDACTe);

    if ACTe <> nil then
      DACTeEvReport.fpCTe := ACTe;

    if aDACTe.MostraPreview = True then
      DACTeEvReport.RLCTeEvento.PreviewModal
    else
      DACTeEvReport.RLCTeEvento.Print;

  finally
    DACTeEvReport.Free;
  end;
end;

class procedure TfrmCTeDAEventoRL.SalvarPDF(aDACTe: TACBrCTeDACTeRL; AEventoCTe: TInfEventoCollectionItem;
  AFile: string; ACTe: TCTe = nil);
var
  DACTeEvReport: TfrmCTeDAEventoRL;
begin
  DACTeEvReport := Create(nil);
  try
    DACTeEvReport.fpDACTe := aDACTe;
    DACTeEvReport.fpEventoCTe := AEventoCTe;
    if aDACTe.AlterarEscalaPadrao then
    begin
      DACTeEvReport.Scaled := False;
      DACTeEvReport.ScaleBy(aDACTe.NovaEscala , Screen.PixelsPerInch);
    end;
    TDFeReportFortes.AjustarReport(DACTeEvReport.RLCTeEvento, DACTeEvReport.fpDACTe);
    TDFeReportFortes.AjustarMargem(DACTeEvReport.RLCTeEvento, DACTeEvReport.fpDACTe);
    TDFeReportFortes.AjustarFiltroPDF(DACTeEvReport.RLPDFFilter1, DACTeEvReport.fpDACTe, AFile);

    if ACTe <> nil then
    begin
      DACTeEvReport.fpCTe := ACTe;

      with DACTeEvReport.RLPDFFilter1.DocumentInfo do
      begin
        Title := ACBrStr('DACTE - Conhecimento n� ') +
          FormatFloat('000,000,000', DACTeEvReport.fpCTe.Ide.nCT);
        KeyWords := ACBrStr('N�mero:') + FormatFloat('000,000,000', DACTeEvReport.fpCTe.Ide.nCT) +
          ACBrStr('; Data de emiss�o: ') + FormatDateTime('dd/mm/yyyy', DACTeEvReport.fpCTe.Ide.dhEmi) +
          ACBrStr('; Destinat�rio: ') + DACTeEvReport.fpCTe.Dest.xNome +
          '; CNPJ: ' + DACTeEvReport.fpCTe.Dest.CNPJCPF;
      end;
    end;

    DACTeEvReport.RLCTeEvento.Prepare;
    DACTeEvReport.RLPDFFilter1.FilterPages(DACTeEvReport.RLCTeEvento.Pages);
  finally
    DACTeEvReport.Free;
  end;
end;

class procedure TfrmCTeDAEventoRL.SalvarPDF(ADACTe: TACBrCTeDACTeRL;
  FEventoCTe: TInfEventoCollectionItem; AStream: TStream; ACTe: TCTe);
var
  DACTeReport: TfrmCTeDAEventoRL;
begin
  DACTeReport := Create(nil);
  try;
    DACTeReport.fpDACTe := ADACTe;
    DACTeReport.fpEventoCTe := FEventoCTe;

    if ADACTe.AlterarEscalaPadrao then
    begin
      DACTeReport.Scaled := False;
      DACTeReport.ScaleBy(ADACTe.NovaEscala , Screen.PixelsPerInch);
    end;

    TDFeReportFortes.AjustarReport(DACTeReport.RLCTeEvento, DACTeReport.fpDACTe);
    DACTeReport.RLPDFFilter1.ShowProgress := DACTeReport.fpDACTe.MostraStatus;

    if (ACTe <> nil) then
    begin
      DACTeReport.fpCTe := ACTe;

      with DACTeReport.RLPDFFilter1.DocumentInfo do
      begin
        Title := ACBrStr('Evento - Nota fiscal n� ') +
          FormatFloat('000,000,000', DACTeReport.fpCTe.Ide.nCT);
        KeyWords := ACBrStr(
          'N�mero:' + FormatFloat('000,000,000', DACTeReport.fpCTe.Ide.nCT) +
          '; Data de emiss�o: ' + FormatDateBr(DACTeReport.fpCTe.Ide.dhEmi) +
          '; Destinat�rio: ' + DACTeReport.fpCTe.Dest.xNome +
          '; CNPJ: ' + DACTeReport.fpCTe.Dest.CNPJCPF);
      end;
    end;

    DACTeReport.RLCTeEvento.Prepare;
    DACTeReport.RLPDFFilter1.FilterPages(DACTeReport.RLCTeEvento.Pages, AStream);
  finally
    DACTeReport.Free;
  end;
end;

procedure TfrmCTeDAEventoRL.FormDestroy(Sender: TObject);
begin
//  RLPrinter.Free;
  RLCTeEvento.Free;
  FreeAndNil(cdsDocumentos);
end;

procedure TfrmCTeDAEventoRL.FormCreate(Sender: TObject);
begin
  ConfigDataSet;
end;

procedure TfrmCTeDAEventoRL.ConfigDataSet;
begin
  if not Assigned(cdsDocumentos) then
    cdsDocumentos :=
{$IFDEF BORLAND}  TClientDataSet.create(nil)  {$ELSE}
      TBufDataset.Create(nil)
{$ENDIF}
  ;

  if cdsDocumentos.Active then
  begin
   {$IFDEF BORLAND}
    if cdsDocumentos is TClientDataSet then
    TClientDataSet(cdsDocumentos).EmptyDataSet;
   {$ENDIF}
    cdsDocumentos.Active := False;
  end;

   {$IFDEF BORLAND}
   if cdsDocumentos is TClientDataSet then
    begin
    TClientDataSet(cdsDocumentos).StoreDefs := False;
    TClientDataSet(cdsDocumentos).IndexDefs.Clear;
    TClientDataSet(cdsDocumentos).IndexFieldNames := '';
    TClientDataSet(cdsDocumentos).IndexName := '';
    TClientDataSet(cdsDocumentos).Aggregates.Clear;
    TClientDataSet(cdsDocumentos).AggFields.Clear;
    end;
   {$ELSE}
  if cdsDocumentos is TBufDataset then
  begin
    TBufDataset(cdsDocumentos).IndexDefs.Clear;
    TBufDataset(cdsDocumentos).IndexFieldNames := '';
    TBufDataset(cdsDocumentos).IndexName := '';
  end;
   {$ENDIF}

  with cdsDocumentos do
    if FieldCount = 0 then
    begin
      FieldDefs.Clear;
      Fields.Clear;
      FieldDefs.Add('TIPO_1', ftString, 14);
      FieldDefs.Add('CNPJCPF_1', ftString, 70);
      FieldDefs.Add('DOCUMENTO_1', ftString, 33);
      FieldDefs.Add('TIPO_2', ftString, 14);
      FieldDefs.Add('CNPJCPF_2', ftString, 70);
      FieldDefs.Add('DOCUMENTO_2', ftString, 33);

     {$IFDEF BORLAND}
      if cdsDocumentos is TClientDataSet then
      TClientDataSet(cdsDocumentos).CreateDataSet;
     {$ELSE}
      if cdsDocumentos is TBufDataset then
        TBufDataset(cdsDocumentos).CreateDataSet;
     {$ENDIF}
    end;

   {$IFDEF BORLAND}
    if cdsDocumentos is TClientDataSet then
    TClientDataSet(cdsDocumentos).StoreDefs := False;
   {$ENDIF}

  if not cdsDocumentos.Active then
    cdsDocumentos.Active := True;

    {$IFDEF BORLAND}
     if cdsDocumentos is TClientDataSet then
     if cdsDocumentos.Active then
     TClientDataSet(cdsDocumentos).LogChanges := False;
   {$ENDIF}

  DataSource1.dataset := cdsDocumentos;
end;

end.













