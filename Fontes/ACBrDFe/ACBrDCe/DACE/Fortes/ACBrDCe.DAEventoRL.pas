{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrDCe.DAEventoRL;

interface

uses
  SysUtils, Variants, Classes, StrUtils,
  {$IFDEF CLX}QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt,
  {$ELSE}{$IFDEF MSWINDOWS}Windows, Messages, {$ENDIF}
  Graphics, Controls, Forms, Dialogs, ExtCtrls, {$ENDIF}
  {$IFDEF BORLAND} DBClient, {$ELSE} BufDataset, {$ENDIF} DB,
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts, RLBarcode,
  ACBrDCe, ACBrDCe.DACERLClass,
  ACBrDCe.Classes, pcnConversao, ACBrDCe.EnvEvento;

type

  { TfrmDCeDAEventoRL }

  TfrmDCeDAEventoRL = class(TForm)
    Datasource1: TDatasource;
    RLDCeEvento: TRLReport;
    RLPDFFilter1: TRLPDFFilter;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  protected
    fpACBrDCe: TACBrDCe;
    fpDADCe: TACBrDCeDACERL;
    fpDCe: TDCe;
    fpEventoDCe: TInfEventoCollectionItem;

    FcdsDocumentos: {$IFDEF BORLAND} TClientDataSet {$ELSE} TBufDataset{$ENDIF};

    procedure ConfigDataSet;
  public
    class procedure Imprimir(aDADCe: TACBrDCeDACERL;
                             AEventoDCe: TInfEventoCollectionItem;
                             ADCe: TDCe = nil);
    class procedure SalvarPDF(aDADCe: TACBrDCeDACERL;
                              AEventoDCe: TInfEventoCollectionItem; const AFile: string;
                              ADCe: TDCe = nil); overload;
    class procedure SalvarPDF(ADADCe: TACBrDCeDACERL;
                              FEventoDCe: TInfEventoCollectionItem; AStream: TStream;
                              ADCe: TDCe = nil); overload;
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

class procedure TfrmDCeDAEventoRL.Imprimir(aDADCe: TACBrDCeDACERL; AEventoDCe: TInfEventoCollectionItem;
  ADCe: TDCe= nil);
var
  DADCeEvReport: TfrmDCeDAEventoRL;
begin
  DADCeEvReport := Create(nil);
  try
    DADCeEvReport.fpDADCe := aDADCe;
    DADCeEvReport.fpEventoDCe := AEventoDCe;

    if aDADCe.AlterarEscalaPadrao then
    begin
      DADCeEvReport.Scaled := False;
      DADCeEvReport.ScaleBy(aDADCe.NovaEscala, Screen.PixelsPerInch);
    end;

    TDFeReportFortes.AjustarReport(DADCeEvReport.RLDCeEvento, DADCeEvReport.fpDADCe);
    TDFeReportFortes.AjustarMargem(DADCeEvReport.RLDCeEvento, DADCeEvReport.fpDADCe);

    if ADCe <> nil then
      DADCeEvReport.fpDCe := ADCe;

    if aDADCe.MostraPreview then
      DADCeEvReport.RLDCeEvento.PreviewModal
    else
      DADCeEvReport.RLDCeEvento.Print;

  finally
    DADCeEvReport.Free;
  end;
end;

class procedure TfrmDCeDAEventoRL.SalvarPDF(aDADCe: TACBrDCeDACERL; AEventoDCe: TInfEventoCollectionItem;
  const AFile: string; ADCe: TDCe = nil);
var
  DADCeEvReport: TfrmDCeDAEventoRL;
begin
  DADCeEvReport := Create(nil);
  try
    DADCeEvReport.fpDADCe := aDADCe;
    DADCeEvReport.fpEventoDCe := AEventoDCe;

    if aDADCe.AlterarEscalaPadrao then
    begin
      DADCeEvReport.Scaled := False;
      DADCeEvReport.ScaleBy(aDADCe.NovaEscala, Screen.PixelsPerInch);
    end;

    TDFeReportFortes.AjustarReport(DADCeEvReport.RLDCeEvento, DADCeEvReport.fpDADCe);
    TDFeReportFortes.AjustarMargem(DADCeEvReport.RLDCeEvento, DADCeEvReport.fpDADCe);
    TDFeReportFortes.AjustarFiltroPDF(DADCeEvReport.RLPDFFilter1, DADCeEvReport.fpDADCe, AFile);

    if ADCe <> nil then
    begin
      DADCeEvReport.fpDCe := ADCe;

      with DADCeEvReport.RLPDFFilter1.DocumentInfo do
      begin
        Title := ACBrStr('DAEvento - Declara��o n� ') +
          FormatFloat('000,000,000', DADCeEvReport.fpDCe.Ide.nDC);
        KeyWords := ACBrStr('N�mero:') + FormatFloat('000,000,000', DADCeEvReport.fpDCe.Ide.nDC) +
          ACBrStr('; Data de emiss�o: ') + FormatDateTime('dd/mm/yyyy', DADCeEvReport.fpDCe.Ide.dhEmi) +
          ACBrStr('; Destinat�rio: ') + DADCeEvReport.fpDCe.Dest.xNome +
          '; CNPJ: ' + DADCeEvReport.fpDCe.Dest.CNPJCPF;
      end;
    end;

    DADCeEvReport.RLDCeEvento.Prepare;
    DADCeEvReport.RLPDFFilter1.FilterPages(DADCeEvReport.RLDCeEvento.Pages);
  finally
    DADCeEvReport.Free;
  end;
end;

class procedure TfrmDCeDAEventoRL.SalvarPDF(ADADCe: TACBrDCeDACERL;
  FEventoDCe: TInfEventoCollectionItem; AStream: TStream; ADCe: TDCe);
var
  DADCeReport: TfrmDCeDAEventoRL;
begin
  DADCeReport := Create(nil);
  try;
    DADCeReport.fpDADCe := ADADCe;
    DADCeReport.fpEventoDCe := FEventoDCe;

    if ADADCe.AlterarEscalaPadrao then
    begin
      DADCeReport.Scaled := False;
      DADCeReport.ScaleBy(ADADCe.NovaEscala, Screen.PixelsPerInch);
    end;

    TDFeReportFortes.AjustarReport(DADCeReport.RLDCeEvento, DADCeReport.fpDADCe);
    DADCeReport.RLPDFFilter1.ShowProgress := DADCeReport.fpDADCe.MostraStatus;

    if (ADCe <> nil) then
    begin
      DADCeReport.fpDCe := ADCe;

      with DADCeReport.RLPDFFilter1.DocumentInfo do
      begin
        Title := ACBrStr('DAEvento - Declara��o n� ') +
          FormatFloat('000,000,000', DADCeReport.fpDCe.Ide.nDC);
        KeyWords := ACBrStr(
          'N�mero:' + FormatFloat('000,000,000', DADCeReport.fpDCe.Ide.nDC) +
          '; Data de emiss�o: ' + FormatDateBr(DADCeReport.fpDCe.Ide.dhEmi) +
          '; Destinat�rio: ' + DADCeReport.fpDCe.Dest.xNome +
          '; CNPJ: ' + DADCeReport.fpDCe.Dest.CNPJCPF);
      end;
    end;

    DADCeReport.RLDCeEvento.Prepare;
    DADCeReport.RLPDFFilter1.FilterPages(DADCeReport.RLDCeEvento.Pages, AStream);
  finally
    DADCeReport.Free;
  end;
end;

procedure TfrmDCeDAEventoRL.FormDestroy(Sender: TObject);
begin
//  RLPrinter.Free;
  RLDCeEvento.Free;
  FreeAndNil(FcdsDocumentos);
end;

procedure TfrmDCeDAEventoRL.FormCreate(Sender: TObject);
begin
  ConfigDataSet;
end;

procedure TfrmDCeDAEventoRL.ConfigDataSet;
begin
  if not Assigned(FcdsDocumentos) then
    FcdsDocumentos :=
{$IFDEF BORLAND}  TClientDataSet.create(nil)  {$ELSE}
      TBufDataset.Create(nil)
{$ENDIF}
  ;

  if FcdsDocumentos.Active then
  begin
   {$IFDEF BORLAND}
    if FcdsDocumentos is TClientDataSet then
    TClientDataSet(FcdsDocumentos).EmptyDataSet;
   {$ENDIF}
    FcdsDocumentos.Active := False;
  end;

  {$IFDEF BORLAND}
  if FcdsDocumentos is TClientDataSet then
  begin
    TClientDataSet(FcdsDocumentos).StoreDefs := False;
    TClientDataSet(FcdsDocumentos).IndexDefs.Clear;
    TClientDataSet(FcdsDocumentos).IndexFieldNames := '';
    TClientDataSet(FcdsDocumentos).IndexName := '';
    TClientDataSet(FcdsDocumentos).Aggregates.Clear;
    TClientDataSet(FcdsDocumentos).AggFields.Clear;
  end;
  {$ELSE}
  if FcdsDocumentos is TBufDataset then
  begin
    TBufDataset(FcdsDocumentos).IndexDefs.Clear;
    TBufDataset(FcdsDocumentos).IndexFieldNames := '';
    TBufDataset(FcdsDocumentos).IndexName := '';
  end;
  {$ENDIF}

  with FcdsDocumentos do
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
      if FcdsDocumentos is TClientDataSet then
        TClientDataSet(FcdsDocumentos).CreateDataSet;
     {$ELSE}
      if FcdsDocumentos is TBufDataset then
        TBufDataset(FcdsDocumentos).CreateDataSet;
     {$ENDIF}
    end;

  {$IFDEF BORLAND}
  if FcdsDocumentos is TClientDataSet then
    TClientDataSet(FcdsDocumentos).StoreDefs := False;
  {$ENDIF}

  if not FcdsDocumentos.Active then
    FcdsDocumentos.Active := True;

  {$IFDEF BORLAND}
  if FcdsDocumentos is TClientDataSet then
    if FcdsDocumentos.Active then
      TClientDataSet(FcdsDocumentos).LogChanges := False;
  {$ENDIF}

  DataSource1.dataset := FcdsDocumentos;
end;

end.
