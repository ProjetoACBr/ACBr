{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Wemerson Souto                                  }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
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

unit ACBrNFeDANFEFR;

interface

uses
  SysUtils, Classes, Forms,
  ACBrBase, ACBrNFeDANFEClass, ACBrNFeDANFEFRDM,
  pcnNFe, pcnConversao, frxClass;

type
  EACBrNFeDANFEFR = class(Exception);

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNFeDANFEFR = class( TACBrNFeDANFEClass )
  private
    FdmDanfe: TACBrNFeFRClass;
    FEspessuraBorda: Integer;
    FMarcaDaguaMSG: string;

    function GetPreparedReport: TfrxReport;
    function GetPreparedReportEvento: TfrxReport;
    function GetPreparedReportInutilizacao: TfrxReport;

    function GetFastFile: String;
    function GetFastFileEvento: String;
    function GetFastFileInutilizacao: String;
    function GetPrintMode: TfrxPrintMode;
    function GetPrintOnSheet: Integer;
    function GetExibeCaptionButton: Boolean;
    function GetZoomModePadrao: TfrxZoomMode;
    {$IFNDEF FMX}
    function GetBorderIcon: TBorderIcons;
    {$ENDIF}
    function GetIncorporarBackgroundPdf: Boolean;
    function GetIncorporarFontesPdf: Boolean;
    function GetOtimizaImpressaoPdf :Boolean;
    function GetThreadSafe: Boolean;

    procedure SetFastFile(const Value: String);
    procedure SetFastFileEvento(const Value: String);
    procedure SetFastFileInutilizacao(const Value: String);
    procedure SetPrintMode(const Value: TfrxPrintMode);
    procedure SetPrintOnSheet(const Value: Integer);
    procedure SetExibeCaptionButton(const Value: Boolean);
    procedure SetZoomModePadrao(const Value: TfrxZoomMode);
    {$IFNDEF FMX}
    procedure SetBorderIcon(const Value: TBorderIcons);
    {$ENDIF}
    procedure SetIncorporarBackgroundPdf(const Value: Boolean);
    procedure SetIncorporarFontesPdf(const Value: Boolean);
    procedure SetOtimizaImpressaoPdf(const Value: Boolean);
    procedure SetThreadSafe(const Value: Boolean);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDANFE(NFE: TNFe = nil); override;
    procedure ImprimirDANFEResumido(NFE: TNFe = nil); override;
    procedure ImprimirDANFEPDF(NFE: TNFe = nil); override;
    procedure ImprimirDANFEPDF(AStream: TStream; ANFe: TNFe = nil); override;
    procedure ImprimirEVENTO(NFE: TNFe = nil); override;
    procedure ImprimirEVENTOPDF(NFE: TNFe = nil); override;
    procedure ImprimirEVENTOPDF(AStream: TStream; ANFe: TNFe = nil); override;
    procedure ImprimirINUTILIZACAO(NFE: TNFe = nil); override;
    procedure ImprimirINUTILIZACAOPDF(NFE: TNFe = nil); override;
    procedure ImprimirINUTILIZACAOPDF(AStream: TStream; ANFe: TNFe = nil); override;

    property PreparedReport: TfrxReport read GetPreparedReport;
    property PreparedReportEvento: TfrxReport read GetPreparedReportEvento;
    property PreparedReportInutilizacao: TfrxReport read GetPreparedReportInutilizacao;

  published
    property FastFile: String read GetFastFile write SetFastFile;
    property FastFileEvento: String read GetFastFileEvento write SetFastFileEvento;
    property FastFileInutilizacao: String read GetFastFileInutilizacao write SetFastFileInutilizacao;
    property EspessuraBorda: Integer read FEspessuraBorda write FEspessuraBorda;
    property MarcaDaguaMSG: string read FMarcaDaguaMSG write FMarcaDaguaMSG;
    property IncorporarBackgroundPdf: Boolean read GetIncorporarBackgroundPdf write SetIncorporarBackgroundPdf default True;
    property IncorporarFontesPdf: Boolean read GetIncorporarFontesPdf write SetIncorporarFontesPdf default True;
    property OtimizaImpressaoPdf: Boolean read GetOtimizaImpressaoPdf write SetOtimizaImpressaoPdf default True;
    property PrintMode: TfrxPrintMode read GetPrintMode write SetPrintMode default pmDefault;
    property PrintOnSheet: Integer read GetPrintOnSheet write SetPrintOnSheet default 0;
    {$IFNDEF FMX}
    property BorderIcon: TBorderIcons read GetBorderIcon write SetBorderIcon;
    {$ENDIF}
    property ExibeCaptionButton: Boolean read GetExibeCaptionButton write SetExibeCaptionButton default False;
    property ZoomModePadrao: TfrxZoomMode read GetZoomModePadrao write SetZoomModePadrao default ZMDEFAULT;
    property ThreadSafe: Boolean read GetThreadSafe write SetThreadSafe;
  end;

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNFeDANFCEFR = class( TACBrNFeDANFCEClass )
  private
    FdmDanfe: TACBrNFeFRClass;

    function GetPreparedReport: TfrxReport;
    function GetPreparedReportEvento: TfrxReport;
    function GetPreparedReportInutilizacao: TfrxReport;

    function GetFastFile: String;
    function GetFastFileEvento: String;
    function GetFastFileInutilizacao: String;
    function GetPrintMode: TfrxPrintMode;
    function GetPrintOnSheet: Integer;
    function GetExibeCaptionButton: Boolean;
    function GetZoomModePadrao: TfrxZoomMode;
    {$IFNDEF FMX}
    function GetBorderIcon: TBorderIcons;
    {$ENDIF}
    procedure SetFastFile(const Value: String);
    procedure SetFastFileEvento(const Value: String);
    procedure SetFastFileInutilizacao(const Value: String);
    procedure SetPrintMode(const Value: TfrxPrintMode);
    procedure SetPrintOnSheet(const Value: Integer);
    procedure SetExibeCaptionButton(const Value: Boolean);
    procedure SetZoomModePadrao(const Value: TfrxZoomMode);
    {$IFNDEF FMX}
    procedure SetBorderIcon(const Value: TBorderIcons);
    {$ENDIF}
    function GetIncorporarBackgroundPdf: Boolean;
    function GetIncorporarFontesPdf: Boolean;
    procedure SetIncorporarBackgroundPdf(const Value: Boolean);
    procedure SetIncorporarFontesPdf(const Value: Boolean);
    function GetOtimizaImpressaoPdf: Boolean;
    procedure SetOtimizaImpressaoPdf(const Value: Boolean);
    function GetThreadSafe: Boolean;
    procedure SetThreadSafe(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDANFE(NFE: TNFe = nil); override;
    procedure ImprimirDANFEResumido(NFE: TNFe = nil); override;
    procedure ImprimirDANFEPDF(NFE: TNFe = nil); override;
    procedure ImprimirDANFEPDF(AStream: TStream; ANFe: TNFe = nil); override;
    procedure ImprimirEVENTO(NFE: TNFe = nil); override;
    procedure ImprimirEVENTOPDF(NFE: TNFe = nil); override;
    procedure ImprimirEVENTOPDF(AStream: TStream; ANFe: TNFe = nil); override;
    procedure ImprimirINUTILIZACAO(NFE: TNFe = nil); override;
    procedure ImprimirINUTILIZACAOPDF(NFE: TNFe = nil); override;
    procedure ImprimirINUTILIZACAOPDF(AStream: TStream; ANFe: TNFe = nil); override;

    property PreparedReport: TfrxReport read GetPreparedReport;
    property PreparedReportEvento: TfrxReport read GetPreparedReportEvento;
    property PreparedReportInutilizacao: TfrxReport read GetPreparedReportInutilizacao;

  published
    property FastFile: String read GetFastFile write SetFastFile;
    property FastFileEvento: String read GetFastFileEvento write SetFastFileEvento;
    property FastFileInutilizacao: String read GetFastFileInutilizacao write SetFastFileInutilizacao;
    property PrintMode: TfrxPrintMode read GetPrintMode write SetPrintMode default pmDefault;
    property PrintOnSheet: Integer read GetPrintOnSheet write SetPrintOnSheet default 0;
    {$IFNDEF FMX}
    property BorderIcon: TBorderIcons read GetBorderIcon write SetBorderIcon;
    {$ENDIF}
    property ExibeCaptionButton: Boolean read GetExibeCaptionButton write SetExibeCaptionButton default False;
    property ZoomModePadrao: TfrxZoomMode read GetZoomModePadrao write SetZoomModePadrao default ZMDEFAULT;
    property IncorporarBackgroundPdf: Boolean read GetIncorporarBackgroundPdf write SetIncorporarBackgroundPdf default True;
    property IncorporarFontesPdf: Boolean read GetIncorporarFontesPdf write SetIncorporarFontesPdf default True;
    property OtimizaImpressaoPdf: Boolean read GetOtimizaImpressaoPdf write SetOtimizaImpressaoPdf default True;
    property ThreadSafe: Boolean read GetThreadSafe write SetThreadSafe;
  end;

implementation

uses
  ACBrNFe, ACBrUtil.Strings, StrUtils, pcnConversaoNFe;

constructor TACBrNFeDANFEFR.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  FEspessuraBorda := 1;
  FMarcaDaguaMSG  :='';
  FdmDanfe        := TACBrNFeFRClass.Create(Self);
end;

destructor TACBrNFeDANFEFR.Destroy;
begin
  FdmDanfe.Free;
  inherited Destroy;
end;
{$IFNDEF FMX}
function TACBrNFeDANFEFR.GetBorderIcon: TBorderIcons;
begin
  Result := FdmDanfe.BorderIcon;
end;
{$ENDIF}

function TACBrNFeDANFEFR.GetExibeCaptionButton: Boolean;
begin
  Result := FdmDanfe.ExibeCaptionButton;
end;

function TACBrNFeDANFEFR.GetZoomModePadrao: TfrxZoomMode;
begin
  Result := FdmDanfe.ZoomModePadrao;
end;

function TACBrNFeDANFEFR.GetFastFile: String;
begin
  Result := FdmDanfe.FastFile;
end;

function TACBrNFeDANFEFR.GetFastFileEvento: String;
begin
  Result := FdmDanfe.FastFileEvento;
end;

function TACBrNFeDANFEFR.GetFastFileInutilizacao: String;
begin
  Result := FdmDanfe.FastFileInutilizacao;
end;

function TACBrNFeDANFEFR.GetIncorporarBackgroundPdf: Boolean;
begin
  Result := FdmDanfe.IncorporarBackgroundPdf;
end;

function TACBrNFeDANFEFR.GetOtimizaImpressaoPdf: Boolean;
begin
  Result := FdmDanfe.OtimizaImpressaoPdf;
end;

function TACBrNFeDANFEFR.GetIncorporarFontesPdf: Boolean;
begin
  Result := FdmDanfe.IncorporarFontesPdf;
end;

function TACBrNFeDANFEFR.GetPreparedReport: TfrxReport;
begin
  Result := FdmDanfe.GetPreparedReport;
end;

function TACBrNFeDANFEFR.GetPreparedReportEvento: TfrxReport;
begin
  Result := FdmDanfe.GetPreparedReportEvento;
end;

function TACBrNFeDANFEFR.GetPreparedReportInutilizacao: TfrxReport;
begin
  Result := FdmDanfe.GetPreparedReportInutilizacao;
end;

function TACBrNFeDANFEFR.GetPrintMode: TfrxPrintMode;
begin
  Result := FdmDanfe.PrintMode;
end;

function TACBrNFeDANFEFR.GetPrintOnSheet: Integer;
begin
  Result := FdmDanfe.PrintOnSheet;
end;

function TACBrNFeDANFEFR.GetThreadSafe: Boolean;
begin
  Result := FdmDanfe.ThreadSafe;
end;
{$IFNDEF FMX}
procedure TACBrNFeDANFEFR.SetBorderIcon(const Value: TBorderIcons);
begin
  FdmDanfe.BorderIcon := Value;
end;
{$ENDIF}
procedure TACBrNFeDANFEFR.SetExibeCaptionButton(const Value: Boolean);
begin
  FdmDanfe.ExibeCaptionButton := Value;
end;

procedure TACBrNFeDANFEFR.SetZoomModePadrao(const Value: TfrxZoomMode);
begin
  FdmDanfe.ZoomModePadrao := Value;
end;

procedure TACBrNFeDANFEFR.SetFastFile(const Value: String);
begin
  FdmDanfe.FastFile := Value;
end;

procedure TACBrNFeDANFEFR.SetFastFileEvento(const Value: String);
begin
  FdmDanfe.FastFileEvento := Value;
end;

procedure TACBrNFeDANFEFR.SetFastFileInutilizacao(const Value: String);
begin
  FdmDanfe.FastFileInutilizacao := Value;
end;

procedure TACBrNFeDANFEFR.SetIncorporarBackgroundPdf(const Value: Boolean);
begin
  FdmDanfe.IncorporarBackgroundPdf := Value;
end;

procedure TACBrNFeDANFEFR.SetIncorporarFontesPdf(const Value: Boolean);
begin
  FdmDanfe.IncorporarFontesPdf := Value;
end;

procedure TACBrNFeDANFEFR.SetOtimizaImpressaoPdf(const Value: Boolean);
begin
  FdmDanfe.OtimizaImpressaoPdf := Value;
end;

procedure TACBrNFeDANFEFR.SetPrintMode(const Value: TfrxPrintMode);
begin
  FdmDanfe.PrintMode := Value;
end;

procedure TACBrNFeDANFEFR.SetPrintOnSheet(const Value: Integer);
begin
  FdmDanfe.PrintOnSheet := Value;
end;

procedure TACBrNFeDANFEFR.SetThreadSafe(const Value: Boolean);
begin
  FdmDanfe.ThreadSafe := Value;
end;

procedure TACBrNFeDANFEFR.ImprimirDANFE(NFE: TNFe);
begin
  FdmDanfe.ImprimirDANFE(NFE);
end;

procedure TACBrNFeDANFEFR.ImprimirDANFEPDF(AStream: TStream; ANFe: TNFe);
begin
  FdmDanfe.ImprimirDANFEPDF(ANFe,AStream);
end;

procedure TACBrNFeDANFEFR.ImprimirDANFEResumido(NFE: TNFe);
begin
  FdmDanfe.ImprimirDANFEResumido(NFE);
end;

procedure TACBrNFeDANFEFR.ImprimirDANFEPDF(NFE: TNFe);
begin
  FdmDanfe.ImprimirDANFEPDF(NFE);
  FPArquivoPDF := FdmDanfe.frxPDFExport.FileName;
end;

procedure TACBrNFeDANFEFR.ImprimirEVENTO(NFE: TNFe);
begin
  FdmDanfe.ImprimirEVENTO(NFE);
end;

procedure TACBrNFeDANFEFR.ImprimirEVENTOPDF(AStream: TStream; ANFe: TNFe);
begin
  FdmDanfe.ImprimirEVENTOPDF(ANFe, AStream);
end;

procedure TACBrNFeDANFEFR.ImprimirEVENTOPDF(NFE: TNFe);
begin
  FdmDanfe.ImprimirEVENTOPDF(NFE);
  FPArquivoPDF := FdmDanfe.frxPDFExport.FileName;
end;

procedure TACBrNFeDANFEFR.ImprimirINUTILIZACAO(NFE: TNFe);
begin
  FdmDanfe.ImprimirINUTILIZACAO(NFE);
end;

procedure TACBrNFeDANFEFR.ImprimirINUTILIZACAOPDF(AStream: TStream; ANFe: TNFe);
begin
  FdmDanfe.ImprimirINUTILIZACAOPDF(ANFe, AStream);
end;

procedure TACBrNFeDANFEFR.ImprimirINUTILIZACAOPDF(NFE: TNFe);
begin
  FdmDanfe.ImprimirINUTILIZACAOPDF(NFE);
  FPArquivoPDF := FdmDanfe.frxPDFExport.FileName;
end;

{ TACBrNFeDANFCEFR }

constructor TACBrNFeDANFCEFR.Create(AOwner: TComponent);
begin
  inherited;
  FdmDanfe := TACBrNFeFRClass.Create(Self);
end;

destructor TACBrNFeDANFCEFR.Destroy;
begin
  FdmDanfe.Free;
  inherited;
end;
{$IFNDEF FMX}
function TACBrNFeDANFCEFR.GetBorderIcon: TBorderIcons;
begin
  Result := FdmDanfe.BorderIcon;
end;
{$ENDIF}
function TACBrNFeDANFCEFR.GetExibeCaptionButton: Boolean;
begin
  Result := FdmDanfe.ExibeCaptionButton;
end;

function TACBrNFeDANFCEFR.GetZoomModePadrao: TfrxZoomMode;
begin
  Result := FdmDanfe.ZoomModePadrao;
end;

function TACBrNFeDANFCEFR.GetFastFile: String;
begin
  Result := FdmDanfe.FastFile;
end;

function TACBrNFeDANFCEFR.GetFastFileEvento: String;
begin
  Result := FdmDanfe.FastFileEvento;
end;

function TACBrNFeDANFCEFR.GetFastFileInutilizacao: String;
begin
  Result := FdmDanfe.FastFileInutilizacao;
end;

function TACBrNFeDANFCEFR.GetIncorporarBackgroundPdf: Boolean;
begin
  Result := FdmDanfe.IncorporarBackgroundPdf;
end;

function TACBrNFeDANFCEFR.GetIncorporarFontesPdf: Boolean;
begin
  Result := FdmDanfe.IncorporarFontesPdf;
end;

function TACBrNFeDANFCEFR.GetOtimizaImpressaoPdf: Boolean;
begin
  Result := FdmDanfe.OtimizaImpressaoPdf;
end;

function TACBrNFeDANFCEFR.GetPreparedReport: TfrxReport;
begin
  Result := FdmDanfe.GetPreparedReport;
end;

function TACBrNFeDANFCEFR.GetPreparedReportEvento: TfrxReport;
begin
  Result := FdmDanfe.GetPreparedReportEvento;
end;

function TACBrNFeDANFCEFR.GetPreparedReportInutilizacao: TfrxReport;
begin
  Result := FdmDanfe.GetPreparedReportInutilizacao;
end;

function TACBrNFeDANFCEFR.GetPrintMode: TfrxPrintMode;
begin
  Result := FdmDanfe.PrintMode;
end;

function TACBrNFeDANFCEFR.GetPrintOnSheet: Integer;
begin
  Result := FdmDanfe.PrintOnSheet;
end;

function TACBrNFeDANFCEFR.GetThreadSafe: Boolean;
begin
  Result := FdmDanfe.ThreadSafe;
end;

procedure TACBrNFeDANFCEFR.ImprimirDANFE(NFE: TNFe);
begin
  FdmDanfe.ImprimirDANFE(NFE);
end;

procedure TACBrNFeDANFCEFR.ImprimirDANFEPDF(AStream: TStream; ANFe: TNFe);
begin
  FdmDanfe.ImprimirDANFEPDF(ANFe,AStream);
end;

procedure TACBrNFeDANFCEFR.ImprimirDANFEPDF(NFE: TNFe);
begin
  FdmDanfe.ImprimirDANFEPDF(NFE);
  FPArquivoPDF := FdmDanfe.frxPDFExport.FileName;
end;

procedure TACBrNFeDANFCEFR.ImprimirDANFEResumido(NFE: TNFe);
begin
  FdmDanfe.ImprimirDANFEResumido(NFE);
end;

procedure TACBrNFeDANFCEFR.ImprimirEVENTO(NFE: TNFe);
begin
  FdmDanfe.ImprimirEVENTO(NFE);
end;

procedure TACBrNFeDANFCEFR.ImprimirEVENTOPDF(AStream: TStream; ANFe: TNFe);
begin
  FdmDanfe.ImprimirEVENTOPDF(ANFe, AStream);
end;

procedure TACBrNFeDANFCEFR.ImprimirEVENTOPDF(NFE: TNFe);
begin
  FdmDanfe.ImprimirEVENTOPDF(NFE);
  FPArquivoPDF := FdmDanfe.frxPDFExport.FileName;
end;

procedure TACBrNFeDANFCEFR.ImprimirINUTILIZACAO(NFE: TNFe);
begin
  FdmDanfe.ImprimirINUTILIZACAO(NFE);
end;

procedure TACBrNFeDANFCEFR.ImprimirINUTILIZACAOPDF(AStream: TStream;ANFe: TNFe);
begin
  FdmDanfe.ImprimirINUTILIZACAOPDF(ANFe, AStream);
end;

procedure TACBrNFeDANFCEFR.ImprimirINUTILIZACAOPDF(NFE: TNFe);
begin
  FdmDanfe.ImprimirINUTILIZACAOPDF(NFE);
  FPArquivoPDF := FdmDanfe.frxPDFExport.FileName;
end;
{$IFNDEF FMX}
procedure TACBrNFeDANFCEFR.SetBorderIcon(const Value: TBorderIcons);
begin
  FdmDanfe.BorderIcon := Value;
end;
{$ENDIF}
procedure TACBrNFeDANFCEFR.SetExibeCaptionButton(const Value: Boolean);
begin
  FdmDanfe.ExibeCaptionButton := Value;
end;

procedure TACBrNFeDANFCEFR.SetZoomModePadrao(const Value: TfrxZoomMode);
begin
  FdmDanfe.ZoomModePadrao := Value;
end;

procedure TACBrNFeDANFCEFR.SetFastFile(const Value: String);
begin
  FdmDanfe.FastFile := Value;
end;

procedure TACBrNFeDANFCEFR.SetFastFileEvento(const Value: String);
begin
  FdmDanfe.FastFileEvento := Value;
end;

procedure TACBrNFeDANFCEFR.SetFastFileInutilizacao(const Value: String);
begin
  FdmDanfe.FastFileInutilizacao := Value;
end;

procedure TACBrNFeDANFCEFR.SetIncorporarBackgroundPdf(
  const Value: Boolean);
begin
  FdmDanfe.IncorporarBackgroundPdf := Value;
end;

procedure TACBrNFeDANFCEFR.SetIncorporarFontesPdf(const Value: Boolean);
begin
  FdmDanfe.IncorporarFontesPdf := Value;
end;

procedure TACBrNFeDANFCEFR.SetOtimizaImpressaoPdf(const Value: Boolean);
begin
  FdmDanfe.OtimizaImpressaoPdf := Value;
end;

procedure TACBrNFeDANFCEFR.SetPrintMode(const Value: TfrxPrintMode);
begin
  FdmDanfe.PrintMode := Value;
end;

procedure TACBrNFeDANFCEFR.SetPrintOnSheet(const Value: Integer);
begin
  FdmDanfe.PrintOnSheet := Value;
end;

procedure TACBrNFeDANFCEFR.SetThreadSafe(const Value: Boolean);
begin
  FdmDanfe.ThreadSafe := Value;
end;

end.
