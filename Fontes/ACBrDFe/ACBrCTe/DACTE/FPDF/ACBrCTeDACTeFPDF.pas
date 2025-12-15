{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor H. Gonzales - Pandaaa                    }
{                              Antonio Carlos Junior                           }
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

unit ACBrCTeDACTeFPDF;

interface

uses
  Classes, SysUtils, StrUtils, DateUtils, Math, ACBr_fpdf, ACBr_fpdf_ext,
  ACBr_fpdf_report, ACBrCTe.Classes, ACBrDFe.Conversao, pcteConversaoCTe,
  ACBrValidador, ACBrUtil.DateTime, ACBrUtil.Strings, ACBrUtil.FilesIO,
  ACBrDFeUtil, ACBrUtil.Compatibilidade, ACBrCTe, ACBrBase, ACBrCTeUtilsFPDF,
  ACBrCTeDACTEClass, ACBrImage, DB, DBClient;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}

  { TCTeDACTeFPDF }

  TCTeDACTeFPDF = class(TFPDFReport)
  private
    FCTe: TCTe;
    FCTeUtils: TCTeUtilsFPDF;
    FDACTEClassOwner: TACBrCTeDACTEClass;
    FCancelada: boolean;
    FCanhoto: TPosRecibo;
    FLogo: TBytes;
    FLogoStretched: boolean;
    FLogoAlign: TLogoAlign;
    FMensagemRodape: string;
    FInitialized: boolean;
    FFontFamily: string;


  protected
    procedure OnStartReport(Args: TFPDFReportEventArgs); override;

  public
    constructor Create(ACTe: TCTe; AACBrCTeDACTEClass: TACBrCTeDACTEClass); reintroduce;
    destructor Destroy; override;
    property Cancelada: boolean read FCancelada write FCancelada;
    property PosCanhoto: TPosRecibo read FCanhoto write FCanhoto;
    property LogoBytes: TBytes read FLogo write FLogo;
    property LogoStretched: boolean read FLogoStretched write FLogoStretched;
    property LogoAlign: TLogoAlign read FLogoAlign write FLogoAlign;
    property MensagemRodape: string read FMensagemRodape write FMensagemRodape;
  end;


  { TACBrCTeDACTeFPDF }

  TACBrCTeDACTeFPDF = class(TACBrCTeDACTEClass)
  private
    FFPDFReport: TCTeDACTeFPDF;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDACTE(CTE: TCTe = nil); override;
    procedure ImprimirDACTEPDF(CTE: TCTe = nil); override;
    procedure ImprimirDACTEPDF(AStream: TStream; ACTe: TCTe = nil); override;

  published
  end;

type
  TBlocoCanhoto = class(TFPDFBand)
  private
    FAlign: TPosRecibo;
    FCTeUtils: TCTeUtilsFPDF;
    procedure DrawCanhoto(Args: TFPDFBandDrawArgs; vX, vY, vW, vH: double);
    procedure DrawTopBottom(Args: TFPDFBandDrawArgs);
    procedure DrawLeft(Args: TFPDFBandDrawArgs);
    procedure DrawRight(Args: TFPDFBandDrawArgs);

  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;

  public
    constructor Create(AAlign: TPosRecibo; ACTeUtils: TCTeUtilsFPDF); reintroduce;
  end;
    { TBlocoDadosCTe }

  TBlocoDadosCTe = class(TFPDFBand)
  private
    FCTeUtils: TCTeUtilsFPDF;

    FLogo: TBytes;
    FLogoStretched: Boolean;
    FLogoAlign: TLogoAlign;
    FImageUtils: TImageUtils;
  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;
  public
    constructor Create(ACTeUtils: TCTeUtilsFPDF; ALogo: TBytes; ALogoStretched: Boolean; ALogoAlign: TLogoAlign); reintroduce;
    destructor Destroy; override;
  end;

  { TBlocoDocAuxiliarCTe }
  TBlocoDocAuxiliarCTe = class(TFPDFBand)
  private
    FCTeUtils: TCTeUtilsFPDF;
  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;
  public
    constructor Create(ACTeUtils: TCTeUtilsFPDF); reintroduce;
  end;

  { TBlocoRodape }
  TBlocoRodape = class(TFPDFBand)
  private
    FCTeUtils: TCTeUtilsFPDF;
  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;
  public
    constructor Create(ACTeUtils: TCTeUtilsFPDF); reintroduce;
  end;
  { TBlocoInformacoesRemDestExpRecebCTe }

  TBlocoInformacoesRemDestExpRecebCTe = class(TFPDFBand)
  private
    FCTeUtils: TCTeUtilsFPDF;
  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;
  public
    constructor Create(ACTeUtils: TCTeUtilsFPDF); reintroduce;
  end;

  { TBlocoInformacoesCTe }
  TBlocoInformacoesCTe = class(TFPDFBand)
  private
    FCTeUtils: TCTeUtilsFPDF;
  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;
  public
    constructor Create(ACTeUtils: TCTeUtilsFPDF); reintroduce;
  end;

    { TBlocoModalRodoviarioCTe }
  TBlocoModalRodoviarioCTe = class(TFPDFBand)
  private
    FCTeUtils: TCTeUtilsFPDF;
  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;
  public
    constructor Create(ACTeUtils: TCTeUtilsFPDF); reintroduce;
  end;
    { TBlocoModalCTeOSCTe }

  TBlocoModalCTeOSCTe = class(TFPDFBand)
  private
    FCTeUtils: TCTeUtilsFPDF;
  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;
  public
    constructor Create(ACTeUtils: TCTeUtilsFPDF); reintroduce;
  end;
    { TBlocoModalAquaviarioCTe }

  TBlocoModalAquaviarioCTe = class(TFPDFBand)
  private
    FCTeUtils: TCTeUtilsFPDF;
  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;
  public
    constructor Create(ACTeUtils: TCTeUtilsFPDF); reintroduce;
  end;
    { TBlocoModalAereoCTe }

  TBlocoModalAereoCTe = class(TFPDFBand)
  private
    FCTeUtils: TCTeUtilsFPDF;
  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;
  public
    constructor Create(ACTeUtils: TCTeUtilsFPDF); reintroduce;
  end;
    { TBlocoModalFerroviarioCTe }

  TBlocoModalFerroviarioCTe = class(TFPDFBand)
  private
    FCTeUtils: TCTeUtilsFPDF;
  protected
    procedure OnInit(Args: TFPDFBandInitArgs); override;
    procedure OnDraw(Args: TFPDFBandDrawArgs); override;
  public
    constructor Create(ACTeUtils: TCTeUtilsFPDF); reintroduce;
  end;

implementation

const
  cDefaultFontFamily = 'Times';

function ManterCep(const ACep: Integer): string;
begin
  Result := '';
  if ACep > 0 then
    Result := FormatarCEP(Poem_Zeros(ACep, 8));
end;

{ TBlocoCanhoto }

constructor TBlocoCanhoto.Create(AAlign: TPosRecibo; ACTeUtils: TCTeUtilsFPDF);
begin
  FAlign := AAlign;

  case FAlign of
    prCabecalho:
      inherited Create(btTopMargin);
    prEsquerda:
      inherited Create(btLeftMargin);
    //caRight:
    //  inherited Create(btRightMargin);
    prRodape:
      inherited Create(btBottomMargin);
  else
    inherited Create(btTopMargin);
    Visible := False;
  end;

  FCTeUtils := ACTeUtils;
end;

procedure TBlocoCanhoto.DrawTopBottom(Args: TFPDFBandDrawArgs);
begin
  DrawCanhoto(Args, 0, 0, Width, 10);
end;

procedure TBlocoCanhoto.DrawRight(Args: TFPDFBandDrawArgs);
var
  x, y: double;
begin
  x := 0;
  y := Height;

  Args.PDF.Rotate(90, x, y);
  try
    DrawCanhoto(Args, x, y, Height, 10);
  finally
    Args.PDF.Rotate(0, x, y);
  end;
end;

procedure TBlocoCanhoto.DrawCanhoto(Args: TFPDFBandDrawArgs; vX, vY, vW, vH: double);
var
  LCTe: TCTe;
  LPDF: IFPDF;

  procedure aFont;
  begin
    LPDF.SetFont(cDefaultFontFamily, '', 7);
  end;

  procedure aFontSmall;
  begin
    LPDF.SetFont(cDefaultFontFamily, '', 6);
  end;

var
  oldX, x, y, w, h, w1, w2, w3: double;
  x1: double;
  LTexto: string;
  LnumCTe, Lserie: string;
begin
  LCTe := FCTeUtils.CTe;
  LPDF := Args.PDF;

  x := vX;
  y := vY;

  oldX := x;

  if FAlign in [prRodape] then
  begin
    y := y + 1;
    LPDF.DashedLine(x, y, x + vW, y, 1);
    y := y + 1;
  end;

  w := RoundTo(vW, 0);
  h := 5;
  LTexto := 'DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE';
  aFont;
  LPDF.TextBox(x, y, w, h, LTexto, 'C', 'C', 1, '', true);

  LnumCTe := FormatarNumeroDocumentoFiscal(IntToStr(LCTe.Ide.nCT));
  Lserie := FormatFloat('000', LCTe.Ide.serie, FCTeUtils.FormatSettings);

  w := RoundTo(vW * 0.81, 0);
  h := 18;

  LTexto := '';
  aFont;
  y := y + 5;
  LPDF.TextBox(x, y, w, h, LTexto, 'T', 'C', 1, '', false);
  x1 := x + w;
  w1 := vW - w;
  LTexto := 'CT-e';
  LPDF.SetFont(14, 'B');
  LPDF.TextBox(x1, y, w1, 18, LTexto, 'T', 'C', True);
  LTexto := 'No. ' + LnumCTe + sLineBreak;
  LTexto := LTexto + 'Série ' + Lserie;
  LPDF.SetFont(10, 'B');
  LPDF.TextBox(x1, y + 2, w1, 18, LTexto, 'C', 'C', 0, '');

  w := RoundTo(vW * 0.3095, 0);
  LTexto := 'NOME:';
  aFont;
  LPDF.TextBox(x, y, w, h, LTexto, 'T', 'L', 1, '', false);

  w := RoundTo(vW * 0.1905, 0);
  x := RoundTo(vW * 0.619, 0);
  LTexto := 'TÉRMINO DA PRESTAÇÃO:';
  aFont;
  LPDF.TextBox(x, y, w, h, LTexto, 'T', 'L', 1, '', false);

  w := RoundTo(vW * 0.3095, 0);
  x := w;
  LTexto := 'ASSINATURA / CARIMBO:';
  aFont;
  LPDF.TextBox(x, y, w, h, LTexto, 'B', 'C', 1, '', false);

  y := y + 9;
  h := 9;

  w := RoundTo(vW * 0.3095, 0);
  x := 0;
  LTexto := 'RG:';
  aFont;
  LPDF.TextBox(x, y, w, h, LTexto, 'T', 'L', 1, '', false);

  w := RoundTo(vW * 0.1905, 0);
  x := RoundTo(vW * 0.619, 0);
  LTexto := 'ÍNICIO DA PRESTAÇÃO:';
  aFont;
  LPDF.TextBox(x, y, w, h, LTexto, 'T', 'L', 1, '', false);

  if FAlign in [prCabecalho, prEsquerda] then
  begin
    y := y + 14;
    x := 0;
    LPDF.DashedLine(x, y, x + vW, y, 1);
  end;
end;

procedure TBlocoCanhoto.DrawLeft(Args: TFPDFBandDrawArgs);
var
  x, y: double;
begin
  x := 0;
  y := Height;

  Args.PDF.Rotate(90, x, y);
  try
    DrawCanhoto(Args, x, y, Height, 10);
  finally
    Args.PDF.Rotate(0, x, y);
  end;
end;

procedure TBlocoCanhoto.OnDraw(Args: TFPDFBandDrawArgs);
begin
  case FAlign of
    prCabecalho, prRodape:
      DrawTopBottom(Args);
    prEsquerda:
      DrawLeft(Args);
    //caRight:
    //  DrawRight(Args);
  else
    //
  end;

  // Para n o ser exibido nas pr ximas p ginas
  Visible := False;
end;

procedure TBlocoCanhoto.OnInit(Args: TFPDFBandInitArgs);
begin
  case FAlign of
    prCabecalho, prRodape:
      Height := 33;
    prEsquerda:
      Width := 33;
  else
    //
  end;

  // Por causa do double pass
  Visible := True;
end;

{ TCTeDACTeFPDF }

procedure TCTeDACTeFPDF.OnStartReport(Args: TFPDFReportEventArgs);
var
  LLogoStringStream: TStringStream;
  LStream: TMemoryStream;
  LOrientation: TFPDFOrientation;
begin
  if not FInitialized then
  begin
    if FCTE = nil then
      raise Exception.Create('FACBrCTe not initialized');

    if FCTeUtils.CTe.Ide.tpImp = tiPaisagem then
      LOrientation := poLandscape
    else
      LOrientation := poPortrait;

    if FDACTEClassOwner.Logo <> '' then
    begin
      LStream := TMemoryStream.Create;
      try
        if FileExists(FDACTEClassOwner.Logo) then
          LStream.LoadFromFile(FDACTEClassOwner.Logo)
        else
        begin
          LLogoStringStream := TStringStream.Create(FDACTEClassOwner.Logo);
          try
            LStream.LoadFromStream(LLogoStringStream);
            LStream.Position := 0;
          finally
            LLogoStringStream.Free;
          end;
        end;
        if IsPNG(LStream, false) then
        begin
          SetLength(FLogo, LStream.Size);
          LStream.Position := 0;
          LStream.Read(FLogo[0], LStream.Size);
        end;
      finally
        LStream.Free;
      end;
    end;
    SetMargins(3, 4, 3, 4);
    AddPage(LOrientation);

    //Canhoto
    AddBand(TBlocoCanhoto.Create(PosCanhoto, FCTeUtils));

    //Emitente
    AddBand(TBlocoDadosCTe.Create(FCTeUtils, FLogo, FLogoStretched, FLogoAlign));

    //DocAuxiliarCTe
    AddBand(TBlocoDocAuxiliarCTe.Create(FCTeUtils));

    AddBand(TBlocoInformacoesRemDestExpRecebCTe.Create(FCTeUtils));

    AddBand(TBlocoInformacoesCTe.Create(FCTeUtils));

    case FCTe.ide.modal of
      mdRodoviario:
        begin
        //  if FCTe.ide.modelo = 67 then  //CTeOS
        //ok    AddBand(TBlocoModalCTeOSCTe.Create(FCTeUtils))
        //  else
        //ok    AddBand(TBlocoModalRodoviarioCTe.Create(FCTeUtils)); //CTe
        end;
      mdAereo:
        AddBand(TBlocoModalAereoCTe.Create(FCTeUtils));
      mdAquaviario:
        AddBand(TBlocoModalAquaviarioCTe.Create(FCTeUtils));
//      mdFerroviario: AddBand(TBlocoModalFerroviarioCTe.Create(FCTeUtils));
    end;
    AddBand(TBlocoModalFerroviarioCTe.Create(FCTeUtils));
    AddBand(TBlocoRodape.Create(FCTeUtils));
    FInitialized := True;
  end;

end;

constructor TCTeDACTeFPDF.Create(ACTe: TCTe; AACBrCTeDACTEClass: TACBrCTeDACTEClass);
var
  LFormatSettings: TFormatSettings;
begin
  inherited Create;
  FCTeUtils := TCTeUtilsFPDF.Create(ACTe, AACBrCTeDACTEClass);
  FCTe := ACTe;
  Self.FDACTEClassOwner := AACBrCTeDACTEClass;
  {$IFDEF HAS_FORMATSETTINGS}
  LFormatSettings := CreateFormatSettings;
  {$ENDIF}
  LFormatSettings.DecimalSeparator := ',';
  LFormatSettings.ThousandSeparator := '.';
  FCTeUtils.FormatSettings := LFormatSettings;

  SetFont('Times');
  SetUTF8(false);
  EngineOptions.DoublePass := True;
end;

destructor TCTeDACTeFPDF.Destroy;
begin
  FCTeUtils.Free;
  inherited;
end;

{ TACBrCTeDACTeFPDF }

constructor TACBrCTeDACTeFPDF.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TACBrCTeDACTeFPDF.Destroy;
begin
  FFPDFReport.Free;
  inherited;
end;

procedure TACBrCTeDACTeFPDF.ImprimirDACTE(CTE: TCTe);
begin
  inherited;
end;

procedure TACBrCTeDACTeFPDF.ImprimirDACTEPDF(AStream: TStream; ACTe: TCTe);
begin
  inherited ImprimirDACTEPDF(AStream, ACTe);
end;

procedure TACBrCTeDACTeFPDF.ImprimirDACTEPDF(CTE: TCTe);
var
  Report: TFPDFReport;
  Engine: TFPDFEngine;
  I: Integer;
  LCTe: TCTe;
  LPath: string;
begin
  for I := 0 to Pred(TACBrCTe(ACBrCTe).Conhecimentos.Count) do
  begin
    LCTe := TACBrCTe(ACBrCTe).Conhecimentos[I].CTE;
    Report := TCTeDACTeFPDF.Create(LCTe, TACBrCTeDACTEClass(TACBrCTe(ACBrCTe).DACTE));

    FIndexImpressaoIndividual := I;

    TCTeDACTeFPDF(Report).PosCanhoto := TCTeDACTeFPDF(TACBrCTe(ACBrCTe).DACTE).PosCanhoto;

    TCTeDACTeFPDF(Report).MensagemRodape := Self.Sistema;

    try
      Engine := TFPDFEngine.Create(Report, False);
      try
        Engine.Compressed := True;

        LPath := DefinirNomeArquivo(TACBrCTe(ACBrCTe).DACTE.PathPDF, OnlyNumber(LCTe.infCTe.ID) + '-cte.pdf', TACBrCTe(ACBrCTe).DACTE.NomeDocumento);

        ForceDirectories(ExtractFilePath(LPath));

        Engine.SaveToFile(LPath);
        FPArquivoPDF := LPath;
      finally
        Engine.Free;
      end;
    finally
      Report.Free;
    end;
  end;
end;

{ TBlocoRodape }

constructor TBlocoRodape.Create(ACTeUtils: TCTeUtilsFPDF);
begin
  inherited Create(btPageFooter);
  FCTeUtils := ACTeUtils;
end;

procedure TBlocoRodape.OnDraw(Args: TFPDFBandDrawArgs);
var
  LPDF: IFPDF;
  LCTe: TCTe;
  LTexto: string;
  x, y, y1, vY: Double;
  i: integer;
begin
  LPDF := Args.PDF;
  LCTe := FCTeUtils.CTe;
  vY := 206;
  x := 0;
  y := 0;
  //coluna 1
  LPDF.SetFont(7, 'B');
  LTexto := 'USO EXCLUSIVO DO EMISSOR DO CT-E';
  LPDF.TextBox(x, y, 140, 4, LTexto, 'C', 'C', True);

  if LCTe.compl.ObsCont.Count > 0 then
  begin
    LTexto := '';
    for i := 0 to LCTe.compl.ObsCont.Count - 1 do
      LTexto := LTexto + LCTe.compl.ObsCont[i].xCampo + ' : ' + LCTe.compl.ObsCont[i].xTexto + '|';

    if Trim(LTexto) <> '' then
      LTexto := StringReplace(LTexto, '|', sLineBreak, [rfReplaceAll, rfIgnoreCase])
    else
      LTexto := '';
  end
  else
    LTexto := '';
  LPDF.SetFont(7, '');
  LPDF.TextBox(x, y + 4, 140, 37, LTexto, 'T', 'L', true);

  //coluna 2
  LPDF.SetFont(7, 'B');
  LTexto := 'RESERVADO AO FISCO';
  LPDF.TextBox(140, y, 64, 4, LTexto, 'C', 'C', true);
  y := y + 4;
  LPDF.SetFont(7, '');
  LTexto := LCTe.Imp.infAdFisco;
  LPDF.TextBox(140, y, 64, 37, LTexto, 'T', 'L', true);
  y := y + 35;
end;

procedure TBlocoRodape.OnInit(Args: TFPDFBandInitArgs);
begin
  Height := 38;
end;

{ TBlocoDadosCTe }

constructor TBlocoDadosCTe.Create(ACTeUtils: TCTeUtilsFPDF; ALogo: TBytes; ALogoStretched: Boolean; ALogoAlign: TLogoAlign);
begin
  inherited Create(btData);
  FCTeUtils := ACTeUtils;
end;

destructor TBlocoDadosCTe.Destroy;
begin

  inherited;
end;

procedure TBlocoDadosCTe.OnDraw(Args: TFPDFBandDrawArgs);
var
  LPDF: IFPDF;
  LCTE: TCTe;
  OldX, OldY: double;
  x, y, w, h, w1, w2, w3, wx: double;
  HEmit1, HEmit2: double;
  Emit1FontSize: double;
  nImgW, nImgH, xImg, yImg, logoWmm, logoHmm: double;
  logoW, logoH: word;
  x1, y1, tw, th, bW, bH: double;
  LEmitente_conteudo1, LEmitente_conteudo2: string;
  LTexto: string;
  LCampoVariavel1Descricao, LCampoVariavel1Valor: string;
  LCampoVariavel2Descricao, LCampoVariavel2Valor: string;
  HasLogo: boolean;
  Stream: TMemoryStream;
  LLogoStringStream: TStringStream;
  i: integer;
  PosicoesX: array[0..3] of Integer;
begin
  LPDF := Args.PDF;
  LCTE := FCTeUtils.CTE;

  x := 0;
  y := 0;

  OldX := x;
  OldY := y;
  HasLogo := False;

  //####################################################################################
  //coluna esquerda identifica  o do emitente
  w := RoundTo(Width * 0.41, 0);
  if LPDF.Orientation = poPortrait then
    LPDF.SetFont(6, 'I')
  else
    LPDF.SetFont(7, 'B');

  w1 := w;
  h := 32;
  OldY := OldY + h;
  LPDF.TextBox(x, y, w, h);
  LTexto := 'IDENTIFICAÇÃO DO EMITENTE';
  LPDF.TextBox(x, y, w, 5, LTexto, 'T', 'C', 0, '');

  x1 := x;
  //y1 := RoundTo(h / 3 + y, 0);
  y1 := y;
  tw := w;
  th := h;

  //estabelecer o alinhamento
  //pode ser left L, center C, right R, full logo L
  //se for left separar 1/3 da largura para o tamanho da imagem
  //os outros 2/3 ser o usados para os dados do emitente
  //se for center separar 1/2 da altura para o logo e 1/2 para os dados
  //se for right separa 2/3 para os dados e o ter o seguinte para o logo
  //se n o houver logo centraliza dos dados do emitente
  // coloca o logo
  if Args.FinalPass and (Length(FLogo) > 0) and FImageUtils.GetImageSize(FLogo, logoW, logoH) then
  begin
    HasLogo := True;
    xImg := 0;
    yImg := 0;
    nImgW := 0;
    nImgH := 0;
    logoWmm := (logoW / 72) * 25.4;
    logoHmm := (logoH / 72) * 25.4;
    if FLogoAlign = laLeft then
    begin
      nImgW := RoundTo(w / 3, 0);
      if FLogoStretched then
        nImgH := h - 5
      else
        nImgH := RoundTo(logoHmm * (nImgW / logoWmm), 0);
      if nImgH > (h - 5) then
      begin
        nImgH := h - 5;
        nImgW := RoundTo(logoWmm * (nImgH / logoHmm), 0);
      end;
      xImg := x + 1;
      yImg := RoundTo((h - nImgH) / 2, 0) + y;
      //estabelecer posições do LTexto
      x1 := RoundTo(xImg + nImgW + 1, 0);
      //y1 := RoundTo(h / 3 + y, 0);
      tw := RoundTo(2 * w / 3, 0);
    end
    else if FLogoAlign = laCenter then
    begin
      nImgH := RoundTo(h / 3, 0);
      if FLogoStretched then
        nImgW := w
      else
        nImgW := RoundTo(logoWmm * (nImgH / logoHmm), 0);
      xImg := RoundTo((w - nImgW) / 2 + x, 0);
      yImg := y + 3;
      x1 := x;
      //y1 := RoundTo(yImg + nImgH + 1, 0);
      y1 := y1 + nImgH;
      tw := w;
      th := th - nImgH;
    end
    else if FLogoAlign = laRight then
    begin
      nImgW := RoundTo(w / 3, 0);
      if FLogoStretched then
        nImgH := h - 5
      else
        nImgH := RoundTo(logoHmm * (nImgW / logoWmm), 0);
      if nImgH > (h - 5) then
      begin
        nImgH := h - 5;
        nImgW := RoundTo(logoWmm * (nImgH / logoHmm), 0);
      end;
      xImg := RoundTo(x + (w - (1 + nImgW)), 0);
      yImg := RoundTo((h - nImgH) / 2, 0) + y;
      x1 := x;
      //y1 := RoundTo(h/3+y, 0);
      tw := RoundTo(2 * w / 3, 0);
    end
    else if FLogoAlign = laFull then
    begin
      nImgH := RoundTo(h - 5, 0);
      if FLogoStretched then
        nImgW := RoundTo(w - 5, 0)
      else
      begin
        nImgW := RoundTo(logoWmm * (nImgH / logoHmm), 0);
        if nImgW > RoundTo(w, 0) then
        begin
          nImgW := RoundTo(w - 5, 0);
          nImgH := RoundTo(logoHmm * (nImgW / logoWmm), 0);
        end;
      end;
      xImg := RoundTo((w - nImgW) / 2 + x, 0);
      yImg := RoundTo((h - nImgH) / 2, 0) + y;
      x1 := x;
      //y1 := RoundTo(yImg + nImgH + 1, 0);
      tw := w;
    end;

    if (Length(FLogo) > 0) then
    begin
      Stream := TMemoryStream.Create;
      try
        Stream.Write(FLogo[0], Length(FLogo));
        LPDF.Image(xImg, yImg, nImgW, nImgH, Stream);
      finally
        Stream.Free;
      end;
    end;
  end;

  // monta as informações apenas se diferente de full logo
  if (not HasLogo) or (FLogoAlign <> laFull) then
  begin
    LEmitente_conteudo1 := LCTE.Emit.xNome;
    LEmitente_conteudo2 := LCTE.Emit.EnderEmit.xLgr + ', ' + LCTE.Emit.EnderEmit.nro;
    if LCTE.Emit.EnderEmit.xCpl <> '' then
      LEmitente_conteudo2 := LEmitente_conteudo2 + ' - ' + LCTE.Emit.EnderEmit.xCpl;
    LEmitente_conteudo2 := LEmitente_conteudo2 + sLineBreak + LCTE.Emit.EnderEmit.xBairro + ' - ' + LCTE.Emit.EnderEmit.xMun + ' - ' + LCTE.Emit.EnderEmit.UF + sLineBreak + 'CEP: ' + IfThen(LCTE.Emit.EnderEmit.CEP > 0, FormatarCEP(LCTE.Emit.EnderEmit.CEP));
    if LCTE.Emit.EnderEmit.fone <> '' then
      LEmitente_conteudo2 := LEmitente_conteudo2 + sLineBreak + 'Fone/Fax: ' + LCTE.Emit.EnderEmit.fone;

    x1 := x1 + 1;
    tw := tw - 2;

    LPDF.SetFont(7, '');
    LPDF.WordWrap(LEmitente_conteudo2, tw);
    HEmit2 := LPDF.GetStringHeight(LEmitente_conteudo2, tw);

    Emit1FontSize := 12.5;
    repeat
      if Emit1FontSize <= 8 then
        Break;
      Emit1FontSize := Emit1FontSize - 0.5;
      LTexto := LEmitente_conteudo1;
      LPDF.SetFont(Emit1FontSize, 'B');
      LPDF.WordWrap(LTexto, tw);
      HEmit1 := LPDF.GetStringHeight(LTexto, tw);
    until HEmit1 + HEmit2 < th - 2;

    //Nome emitente
    LPDF.SetFont(Emit1FontSize, 'B');

    y1 := y1 + ((th - (HEmit1 + HEmit2)) / 2) + 1;

    y1 := y1 + LPDF.TextBox(x1, y1, tw, HEmit1, LEmitente_conteudo1, 'T', 'C', False);
    //endereço
    //y1 := y1 + 5;
    LPDF.SetFont(7, '');
    LPDF.TextBox(x1, y1, tw, HEmit2, LEmitente_conteudo2, 'T', 'C', 0, '');
  end;
end;

procedure TBlocoDadosCTe.OnInit(Args: TFPDFBandInitArgs);
begin
  Height := 80;
end;
{ TBlocoDocAuxiliarCTe }

constructor TBlocoDocAuxiliarCTe.Create(ACTeUtils: TCTeUtilsFPDF);
begin
  inherited Create(btData);
  FCTeUtils := ACTeUtils;
end;

procedure TBlocoDocAuxiliarCTe.OnDraw(Args: TFPDFBandDrawArgs);
var
  LPDF: IFPDF;
  LCTE: TCTe;
  x, y: double;
  x1, y1: double;
  LTexto: string;
begin
  inherited OnDraw(Args);

  LPDF := Args.PDF;
  LCTE := FCTeUtils.CTe;

  //Posição Inicial
  x := 0;
  y := 0;

  // Documento auxiliar
  //Borda Doc Auxiliar
  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 84;
  y1 := y - 80;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 52, 10, LTexto, 'T', 'C', True);
  //-------

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 103;
  y1 := y - 80;
  LTexto := 'DACTE';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'C', False);

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 84;
  y1 := y - 77;
  LTexto := 'Documento Auxiliar do Conhecimento';
  LPDF.TextBox(x1, y1, 50, 4, LTexto, 'T', 'C', False);

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 95;
  y1 := y - 74;
  LTexto := 'de Transporte Eletrônico';
  LPDF.TextBox(x1, y1, 35, 4, LTexto, 'T', 'C', False);

  //Modal
  //Borda Modal
  LPDF.SetFont('Arial', '', 8);
  x1 := x + 136;
  y1 := y - 80;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 33, 10, LTexto, 'C', 'C', True);
  //-------

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 137;
  y1 := y - 80;
  LTexto := 'MODAL';
  LPDF.TextBox(x1, y1, 33, 4, LTexto, 'T', 'L', False);

  LPDF.SetFont('Arial', '', 8);
  x1 := x + 137;
  y1 := y - 77;
  LTexto := TpModalToStrText(LCTE.ide.modal);
  LPDF.TextBox(x1, y1, 33, 6, LTexto, 'C', 'L', False);

  //Número de Páginas
  //Borda Num Paginas
  LPDF.SetFont('Arial', '', 8);
  x1 := x + 169;
  y1 := y - 80;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 35, 10, LTexto, 'T', 'C', True);
  //-------

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 169;
  y1 := y - 80;
  LTexto := 'FOLHA';
  LPDF.TextBox(x1, y1, 35, 4, LTexto, 'T', 'L', False);

  LPDF.SetFont('Arial', '', 8);
  x1 := x + 169;
  y1 := y - 77;
  LTexto := IntToStr(LPDF.CurrentPage) + '/' + IntToStr(Args.TotalPages);
  LPDF.TextBox(x1, y1, 35, 4, LTexto, 'T', 'L', False);

  //Modelo
  //Borda Modelo
  x1 := x + 84;
  y1 := y - 70;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 15, 7, LTexto, 'T', 'C', True);
  //-------

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 84;
  y1 := y - 70;
  LTexto := 'MODELO';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'C', False);

  LPDF.SetFont('Arial', '', 8);
  x1 := x + 84;
  y1 := y - 67;
  LTexto := IntToStr(LCTE.Ide.modelo);
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'C', False);

  //Série
  //Borda Série
  x1 := x + 99;
  y1 := y - 70;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 13, 7, LTexto, 'T', 'C', True);
  //-------

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 99;
  y1 := y - 70;
  LTexto := 'SÉRIE';
  LPDF.TextBox(x1, y1, 13, 4, LTexto, 'T', 'C', False);

  LPDF.SetFont('Arial', '', 8);
  x1 := x + 99;
  y1 := y - 67;
  LTexto := FormatFloat('000', LCTE.Ide.serie, FCTeUtils.FormatSettings);
  LPDF.TextBox(x1, y1, 13, 4, LTexto, 'T', 'C', False);

  //Numero
  //Borda Número
  x1 := x + 112;
  y1 := y - 70;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 19, 7, LTexto, 'T', 'L', True);
  //-------

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 112;
  y1 := y - 70;
  LTexto := 'NÚMERO';
  LPDF.TextBox(x1, y1, 19, 4, LTexto, 'T', 'L', False);

  LPDF.SetFont('Arial', '', 8);
  x1 := x + 112;
  y1 := y - 67;
  LTexto := FormatarNumeroDocumentoFiscal(IntToStr(LCTE.Ide.nCT));
  LPDF.TextBox(x1, y1, 18, 4, LTexto, 'T', 'C', False);

  //Data e Hora Emissão
  //Borda Data e hora
  x1 := x + 131;
  y1 := y - 70;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 26, 7, LTexto, 'T', 'C', True);
  //-------

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 131;
  y1 := y - 70;
  LTexto := 'DATA E HORA';
  LPDF.TextBox(x1, y1, 25, 4, LTexto, 'T', 'C', False);

  LPDF.SetFont('Arial', '', 8);
  x1 := x + 131;
  y1 := y - 67;
  LTexto := DateTimeToStr(LCTE.Ide.dhEmi);
  LPDF.TextBox(x1, y1, 25, 4, LTexto, 'T', 'C', False);

  //Insc Suframa Dest.
  //Borda Insc Suframa
  x1 := x + 157;
  y1 := y - 70;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 47, 7, LTexto, 'T', 'L', True);
  //-------

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x + 157;
  y1 := y - 70;
  LTexto := 'INSC SUFRAMA DESTINATÁRIO';
  LPDF.TextBox(x1, y1, 47, 4, LTexto, 'T', 'L', False);

  LPDF.SetFont('Arial', '', 8);
  x1 := x + 157;
  y1 := y - 67;
  LTexto := LCTE.dest.ISUF;
  LPDF.TextBox(x1, y1, 47, 4, LTexto, 'T', 'C', False);

  //Tipo CTe
  //Borda Tipo CTe
  x1 := x;
  y1 := y - 48;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 84, 7, LTexto, 'T', 'L', True);
  //-------

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x;
  y1 := y - 48;
  LTexto := 'TIPO DO CT-e';
  LPDF.TextBox(x1, y1, 84, 4, LTexto, 'T', 'L', False);

  LPDF.SetFont('Arial', '', 8);
  x1 := x;
  y1 := y - 45;
  LTexto := tpCTToStrText(LCTE.ide.tpCTe);
  LPDF.TextBox(x1, y1, 84, 4, LTexto, 'T', 'L', False);

  //Tipo do Serviço
  //Borda Tipo do Serviço
  LPDF.SetFont('Arial', '', 8);
  x1 := x;
  y1 := y - 41;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 84, 7, LTexto, 'T', 'L', True);
  //-------

  LPDF.SetFont('Arial', 'B', 8);
  x1 := x;
  y1 := y - 41;
  LTexto := 'TIPO DO SERVIÇO';
  LPDF.TextBox(x1, y1, 84, 4, LTexto, 'T', 'L', False);

  LPDF.SetFont('Arial', '', 8);
  x1 := x;
  y1 := y - 38;
  LTexto := TpServToStrText(LCTE.ide.tpServ);
  LPDF.TextBox(x1, y1, 84, 4, LTexto, 'T', 'L', False);

  //Indicador do CT-e Globalizado
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 34;
  LTexto := 'IND. CT-E GLOBALIZADO';
  LPDF.TextBox(x1, y1, 42, 7, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');

  LTexto := ifthen(LCTE.ide.indGlobalizado = tiSim, 'X', '');
  x1 := x + 10;
  y1 := y - 30.5;
  LPDF.TextBox(x1, y1, 3, 3, LTexto, 'C', 'C', True);
  LTexto := 'SIM';
  x1 := x + 14;
  y1 := y - 31;
  LPDF.TextBox(x1, y1, 8, 3, LTexto, 'T', 'L', False);

  LTexto := ifthen(LCTE.ide.indGlobalizado = tiNao, 'X', '');
  x1 := x + 24;
  y1 := y - 30.5;
  LPDF.TextBox(x1, y1, 3, 3, LTexto, 'C', 'C', True);
  LTexto := 'NÃO';
  x1 := x + 28;
  y1 := y - 31;
  LPDF.TextBox(x1, y1, 8, 3, LTexto, 'T', 'L', False);

  //Inform. do CT-e Globalizado
  LPDF.SetFont(7, 'B');
  x1 := x + 46;
  y1 := y - 34;
  LTexto := 'INF. CT-E GLOBALIZADO';
  LPDF.TextBox(x1, y1, 38, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := LCTE.infCTeNorm.infGlobalizado.xObs;
  x1 := x + 46;
  y1 := y - 31;
  LPDF.TextBox(x1, y1, 38, 4, LTexto, 'C', 'L', False);

  //Natureza da Operação
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 27;
  LTexto := 'NATUREZA DA OPERAÇÃO';
  LPDF.TextBox(x1, y1, 84, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := LCTE.ide.natOp;
  x1 := x;
  y1 := y - 24;
  LPDF.TextBox(x1, y1, 84, 4, LTexto, 'C', 'L', False);

  //Protocolo de autorização do uso
  LPDF.SetFont(7, 'B');
  x1 := x + 84;
  y1 := y - 27;
  LTexto := 'Protocolo de Autorização do Uso';
  LPDF.TextBox(x1, y1, 120, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := LCTE.procCTe.nProt + ' ' + DateTimeToStr(LCTE.procCTe.dhRecbto);
  x1 := x + 84;
  y1 := y - 24;
  LPDF.TextBox(x1, y1, 120, 4, LTexto, 'C', 'L', False);

  //Codigo de Barras.
    //QRCode.
  LPDF.SetFont(6, 'B');

  x1 := 86;
  y1 := -60;
  LPDF.QRCode(x1 + 89, y1, 29, LCTE.infCTeSupl.qrCodCTe);
  LPDF.Code128(OnlyNumber(LCTE.infCTe.Id), x1, y1, 8, 86);
  LPDF.SetFont(7, 'B');
  LPDF.TextBox(x1 - 2, y1 + 10, 88, 7, 'Chave de acesso', 'T', 'L', False);
  LPDF.SetFont(7, '');
  LPDF.TextBox(x1, y1 + 13, 88, 4, FormatarChaveAcesso(OnlyNumber(LCTE.infCTe.Id)), 'T', 'C', False);
  //LPDF.TextBox(x1, y1 + 2, 86, 18, LTexto, 'C', 'C', False);
  //codigo de barras
  y1 := -65;
  if (LCTE.Ide.tpEmis in [teFSDA]) and not (LCTE.ide.tpEmis = teDPEC) then
  begin
    y1 := -60;
     //Codigo de Barras Contigencia.
    LPDF.SetFont(7, '');
    LPDF.TextBox(x1, y1 + 20, 86, 12, FormatarChaveAcesso(FCTeUtils.GetChaveContingencia), 'C', 'C', False);
     //codigo de barras
    LPDF.Code128(FCTeUtils.GetChaveContingencia, x1, y1 + 18, 6, 86);
     //linhas divisorias
    LPDF.SetFont(7, '');
  end;
  //linhas divisorias
  LPDF.SetFont(7, 'B');
  LTexto := 'Chave de Acesso para consulta de autenticidade no site http://www.cte.fazenda.gov.br';
  LPDF.TextBox(x1 - 2, y1 + 26.5, 88, 7, LTexto, 'T', 'C', False);
end;

procedure TBlocoDocAuxiliarCTe.OnInit(Args: TFPDFBandInitArgs);
begin
  Height := 80;
end;

{ TBlocoInformacoesCTe }

constructor TBlocoInformacoesCTe.Create(ACTeUtils: TCTeUtilsFPDF);
begin
  inherited Create(btData);
  FCTeUtils := ACTeUtils;
end;

procedure TBlocoInformacoesCTe.OnDraw(Args: TFPDFBandDrawArgs);
var
  LPDF: IFPDF;
  LCTE: TCTe;
  x, y, w: double;
  x1, y1: double;
  aliquota, baseCalculo, vICMS, RedBC: double;
  i, ii, iii: integer;
  LTexto: string;
  PosicoesX: array[0..3] of Integer;
  LCNPJ, LXNome, LXFant, LIE, LXlgr, LNro, LXCpl, LXBairro, LCMun, LXMun, LUF, LCEP, LCPais, LXPais, LFone, LEmail, LNDoc, LTpDocAnt, LCNPJDocAnt, LSerieNumDocAnt: string;
  cdsDocAnt: TClientDataSet;
begin
  inherited OnDraw(Args);
  LPDF := Args.PDF;
  LCTE := FCTeUtils.CTe;

  if ((LCTE.ide.modelo in [57, 67]) or (LCTE.ide.tpCTe = tcCTeSimp)) and (LCTE.toma.xNome <> '') then  //67-CTeOS
  begin
    LCNPJ := FormatarCNPJouCPF(LCTE.toma.CNPJCPF);
    LXNome := LCTE.toma.xNome;
    LXFant := LCTE.toma.XFant;
    LIE := LCTE.toma.IE;
    LXlgr := LCTE.toma.enderToma.XLgr;
    LNro := LCTE.toma.enderToma.Nro;
    LXCpl := LCTE.toma.enderToma.XCpl;
    LXBairro := LCTE.toma.enderToma.XBairro;
    LCMun := IntToStr(LCTE.toma.enderToma.CMun);
    LXMun := LCTE.toma.enderToma.XMun;
    LUF := LCTE.toma.enderToma.UF;
    LCEP := ManterCep(LCTE.toma.enderToma.CEP);
    LCPais := IntToStr(LCTE.toma.enderToma.CPais);
    LXPais := LCTE.toma.enderToma.XPais;
    LFone := FormatarFone(LCTE.toma.Fone);
    LEmail := LCTE.toma.email;
  end
  else
  begin
    case LCTE.ide.Toma03.Toma of
      tmRemetente:
        begin
          LCNPJ := FormatarCNPJouCPF(LCTE.Rem.CNPJCPF);
          LXNome := LCTE.Rem.xNome;
          LXFant := LCTE.Rem.XFant;
          LIE := LCTE.Rem.IE;
          LXlgr := LCTE.Rem.EnderReme.XLgr;
          LNro := LCTE.Rem.EnderReme.Nro;
          LXCpl := LCTE.Rem.EnderReme.XCpl;
          LXBairro := LCTE.Rem.EnderReme.XBairro;
          LCMun := IntToStr(LCTE.Rem.EnderReme.CMun);
          LXMun := LCTE.Rem.EnderReme.XMun;
          LUF := LCTE.Rem.EnderReme.UF;
          LCEP := ManterCep(LCTE.Rem.EnderReme.CEP);
          LCPais := IntToStr(LCTE.Rem.EnderReme.CPais);
          LXPais := LCTE.Rem.EnderReme.XPais;
          LFone := FormatarFone(LCTE.Rem.Fone);
        end;

      tmDestinatario:
        begin
          LCNPJ := FormatarCNPJouCPF(LCTE.Dest.CNPJCPF);
          LXNome := LCTE.Dest.xNome;
          LIE := LCTE.Dest.IE;
          LXlgr := LCTE.Dest.EnderDest.XLgr;
          LNro := LCTE.Dest.EnderDest.Nro;
          LXCpl := LCTE.Dest.EnderDest.XCpl;
          LXBairro := LCTE.Dest.EnderDest.XBairro;
          LCMun := IntToStr(LCTE.Dest.EnderDest.CMun);
          LXMun := LCTE.Dest.EnderDest.XMun;
          LUF := LCTE.Dest.EnderDest.UF;
          LCEP := ManterCep(LCTE.Dest.EnderDest.CEP);
          LCPais := IntToStr(LCTE.Dest.EnderDest.CPais);
          LXPais := LCTE.Dest.EnderDest.XPais;
          LFone := FormatarFone(LCTE.Dest.Fone);
        end;

      tmExpedidor:
        begin
          LCNPJ := FormatarCNPJouCPF(LCTE.Exped.CNPJCPF);
          LXNome := LCTE.Exped.xNome;
          LIE := LCTE.Exped.IE;
          LXlgr := LCTE.Exped.EnderExped.XLgr;
          LNro := LCTE.Exped.EnderExped.Nro;
          LXCpl := LCTE.Exped.EnderExped.XCpl;
          LXBairro := LCTE.Exped.EnderExped.XBairro;
          LCMun := IntToStr(LCTE.Exped.EnderExped.CMun);
          LXMun := LCTE.Exped.EnderExped.XMun;
          LUF := LCTE.Exped.EnderExped.UF;
          LCEP := ManterCep(LCTE.Exped.EnderExped.CEP);
          LCPais := IntToStr(LCTE.Exped.EnderExped.CPais);
          LXPais := LCTE.Exped.EnderExped.XPais;
          LFone := FormatarFone(LCTE.Exped.Fone);
        end;

      tmRecebedor:
        begin
          LCNPJ := FormatarCNPJouCPF(LCTE.Receb.CNPJCPF);
          LXNome := LCTE.Receb.xNome;
          LIE := LCTE.Receb.IE;
          LXlgr := LCTE.Receb.EnderReceb.XLgr;
          LNro := LCTE.Receb.EnderReceb.Nro;
          LXCpl := LCTE.Receb.EnderReceb.XCpl;
          LXBairro := LCTE.Receb.EnderReceb.XBairro;
          LCMun := IntToStr(LCTE.Receb.EnderReceb.CMun);
          LXMun := LCTE.Receb.EnderReceb.XMun;
          LUF := LCTE.Receb.EnderReceb.UF;
          LCEP := ManterCep(LCTE.Receb.EnderReceb.CEP);
          LCPais := IntToStr(LCTE.Receb.EnderReceb.CPais);
          LXPais := LCTE.Receb.EnderReceb.XPais;
          LFone := FormatarFone(LCTE.Receb.Fone);
        end;
    end;

    case LCTE.ide.Toma4.Toma of
      tmOutros:
        begin
          LCNPJ := FormatarCNPJouCPF(LCTE.ide.Toma4.CNPJCPF);
          LXNome := LCTE.ide.Toma4.xNome;
          LIE := LCTE.ide.Toma4.IE;
          LXlgr := LCTE.ide.Toma4.EnderToma.XLgr;
          LNro := LCTE.ide.Toma4.EnderToma.Nro;
          LXCpl := LCTE.ide.Toma4.EnderToma.XCpl;
          LXBairro := LCTE.ide.Toma4.EnderToma.XBairro;
          LCMun := IntToStr(LCTE.ide.Toma4.EnderToma.CMun);
          LXMun := LCTE.ide.Toma4.EnderToma.XMun;
          LUF := LCTE.ide.Toma4.EnderToma.UF;
          LCEP := ManterCep(LCTE.ide.Toma4.EnderToma.CEP);
          LCPais := IntToStr(LCTE.ide.Toma4.EnderToma.CPais);
          LXPais := LCTE.ide.Toma4.EnderToma.XPais;
          LFone := FormatarFone(LCTE.ide.Toma4.Fone);
        end;
    end;
  end;

  x := 0;
  y := 80;
  //Tomador do Serviço
  //Borda Tomador do Serviço
  x1 := x;
  y1 := y - 143;
  LPDF.TextBox(x1, y1, 204, 12, EmptyStr, 'T', 'L', True);
  //-----

  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 141;
  LTexto := 'TOMADOR DO SERVIÇO:';
  LPDF.TextBox(x1, y1, 30, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LXNome;
  x1 := x + 30;
  y1 := y - 141;
  LPDF.TextBox(x1, y1, 79, 4, LTexto, 'T', 'L', False);

  //Tomador do Serviço Municipio
  LPDF.SetFont(7, 'B');
  x1 := x + 106;
  y1 := y - 141;
  LTexto := 'MUNICÍPIO:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LXMun;
  x1 := x + 121;
  y1 := y - 141;
  LPDF.TextBox(x1, y1, 61, 4, LTexto, 'T', 'L', False);

  //Tomador do Serviço CEP
  LPDF.SetFont(7, 'B');
  x1 := x + 183;
  y1 := y - 141;
  LTexto := 'CEP:';
  LPDF.TextBox(x1, y1, 8, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := FormatarCEP(LCEP);
  x1 := x + 190;
  y1 := y - 141;
  LPDF.TextBox(x1, y1, 22, 4, LTexto, 'T', 'L', False);

  //Endereço Tomador do Serviço
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 138;
  LTexto := 'ENDEREÇO:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LXlgr + ' ' + LNro + ' ' + LXCpl + ' ' + LXBairro;
  x1 := x + 15;
  y1 := y - 138;
  LPDF.TextBox(x1, y1, 120, 4, LTexto, 'T', 'L', False);

  //UF Tomador do Serviço
  LPDF.SetFont(7, 'B');
  x1 := x + 136;
  y1 := y - 138;
  LTexto := 'UF:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LUF;
  x1 := x + 141;
  y1 := y - 138;
  LPDF.TextBox(x1, y1, 25, 4, LTexto, 'T', 'L', False);

  //País Tomador do Serviço
  LPDF.SetFont(7, 'B');
  x1 := x + 167;
  y1 := y - 138;
  LTexto := 'PAÍS:';
  LPDF.TextBox(x1, y1, 8, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LXPais;
  x1 := x + 175;
  y1 := y - 138;
  LPDF.TextBox(x1, y1, 38, 4, LTexto, 'T', 'L', False);

  //CNPJ/CPF Tomador do Serviço
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 135;
  LTexto := 'CNPJ/CPF:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCNPJ;
  x1 := x + 14;
  y1 := y - 135;
  LPDF.TextBox(x1, y1, 60, 4, LTexto, 'T', 'L', False);

  //IE Tomador do Serviço
  LPDF.SetFont(7, 'B');
  x1 := x + 76;
  y1 := y - 135;
  LTexto := 'IE:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LIE;
  x1 := x + 81;
  y1 := y - 135;
  LPDF.TextBox(x1, y1, 60, 4, LTexto, 'T', 'L', False);

  //Fone Tomador do Serviço
  LPDF.SetFont(7, 'B');
  x1 := x + 142;
  y1 := y - 135;
  LTexto := 'FONE:';
  LPDF.TextBox(x1, y1, 8, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LFone;
  x1 := x + 150;
  y1 := y - 135;
  LPDF.TextBox(x1, y1, 63, 4, LTexto, 'T', 'L', False);



  //Produto Predominante
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 131;
  LTexto := 'PRODUTO PREDOMINANTE:';
  LPDF.TextBox(x1, y1, 71, 6, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := LCTE.infCTeNorm.infCarga.proPred;
  x1 := x;
  y1 := y - 128;
  LPDF.TextBox(x1, y1, 71, 4, LTexto, 'T', 'L', False);

  //Outras Caracteristicas da Carga
  LPDF.SetFont(7, 'B');
  x1 := x + 71;
  y1 := y - 131;
  LTexto := 'OUTRAS CARACTERISTICAS DA CARGA:';
  LPDF.TextBox(x1, y1, 71, 6, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := LCTE.infCTeNorm.infCarga.xOutCat;
  x1 := x + 71;
  y1 := y - 128;
  LPDF.TextBox(x1, y1, 71, 4, LTexto, 'T', 'L', False);

  //Valor total da carga
  LPDF.SetFont(7, 'B');
  x1 := x + 142;
  y1 := y - 131;
  LTexto := 'VALOR TOTAL DA CARGA:';
  LPDF.TextBox(x1, y1, 62, 6, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  //Validar se realmente é este campo
  LTexto := 'R$ ' + FormatFloat('#,0.00', LCTE.infCTeNorm.infCarga.vCarga);
  x1 := x + 142;
  y1 := y - 128;
  LPDF.TextBox(x1, y1, 62, 4, LTexto, 'T', 'L', False);

  //QTD
  //Borda
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 125;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 204, 7, LTexto, 'T', 'L', True);
  //----

  LPDF.SetFont(7, '');
  x1 := x;
  y1 := y - 125;
  LTexto := 'QTD:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, 'B');
  for i := 0 to LCTE.infCTeNorm.infCarga.infQ.Count - 1 do
  begin
    LTexto := FormatFloat('#,0', LCTE.infCTeNorm.infCarga.infQ[i].qCarga);
  end;
  x1 := x;
  y1 := y - 122;
  LPDF.TextBox(x1, y1, 9, 4, LTexto, 'T', 'L', False);

  //Carga
  LPDF.SetFont(7, 'B');
  x1 := x + 10;
  y1 := y - 125;
  LTexto := 'CARGA:';
  LPDF.TextBox(x1, y1, 10, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.infCTeNorm.infCarga.proPred;
  x1 := x + 10;
  y1 := y - 122;
  LPDF.TextBox(x1, y1, 10, 4, LTexto, 'T', 'L', False);

  //Peso Bruto KG
  LPDF.SetFont(7, 'B');
  x1 := x + 21;
  y1 := y - 125;
  LTexto := 'PESO BRUTO (KG):';
  LPDF.TextBox(x1, y1, 30, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  for i := 0 to LCTE.infCTeNorm.infCarga.infQ.Count - 1 do
  begin
    LTexto := FormatFloat('#,0.000', LCTE.infCTeNorm.infCarga.infQ[i].qCarga);
  end;
  x1 := x + 21;
  y1 := y - 122;
  LPDF.TextBox(x1, y1, 36, 4, LTexto, 'T', 'L', False);

  //Peso Base Cálculo KG
  LPDF.SetFont(7, 'B');
  x1 := x + 59;
  y1 := y - 125;
  LTexto := 'PESO BASE CÁLCULO (KG):';
  LPDF.TextBox(x1, y1, 30, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  for i := 0 to LCTE.infCTeNorm.infCarga.infQ.Count - 1 do
  begin
    LTexto := FormatFloat('#,0.000', LCTE.infCTeNorm.infCarga.infQ[i].qCarga);
  end;
  x1 := x + 59;
  y1 := y - 122;
  LPDF.TextBox(x1, y1, 36, 4, LTexto, 'T', 'L', False);

  //Peso Aferido KG
  LPDF.SetFont(7, 'B');
  x1 := x + 97;
  y1 := y - 125;
  LTexto := 'PESO AFERIDO (KG):';
  LPDF.TextBox(x1, y1, 30, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  for i := 0 to LCTE.infCTeNorm.infCarga.infQ.Count - 1 do
  begin
    LTexto := FormatFloat('#,0.000', LCTE.infCTeNorm.infCarga.infQ[i].qCarga);
  end;
  x1 := x + 97;
  y1 := y - 122;
  LPDF.TextBox(x1, y1, 36, 4, LTexto, 'T', 'L', False);

  //Cubagem M3
  LPDF.SetFont(7, 'B');
  x1 := x + 135;
  y1 := y - 125;
  LTexto := 'CUBAGEM (M3):';
  LPDF.TextBox(x1, y1, 30, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  for i := 0 to LCTE.infCTeNorm.infCarga.infQ.Count - 1 do
  begin
    LTexto := UniMedToStr(TpUniMed(LCTE.infCTeNorm.infCarga.infQ[i].cUnid));
  end;
  x1 := x + 135;
  y1 := y - 122;
  LPDF.TextBox(x1, y1, 36, 4, LTexto, 'T', 'L', False);

  //Quantidade de Volumes (UND)
  LPDF.SetFont(7, 'B');
  x1 := x + 173;
  y1 := y - 125;
  LTexto := 'QUANTIDADE DE VOLUMES (UND):';
  LPDF.TextBox(x1, y1, 30, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  for i := 0 to LCTE.infCTeNorm.infCarga.infQ.Count - 1 do
  begin
    LTexto := CurrToStr(LCTE.infCTeNorm.infCarga.infQ[i].qCarga);
  end;
  x1 := x + 173;
  y1 := y - 122;
  LPDF.TextBox(x1, y1, 36, 4, LTexto, 'T', 'L', False);

  //Componentes do Valor da Prestação de Serviço
  LPDF.SetFont(7, 'B');
  x1 := x + 0;
  y1 := y - 118;
  LTexto := 'COMPONENTES DO VALOR DA PRESTAÇÃO DE SERVIÇO';
  LPDF.TextBox(x1, y1, 210, 4, LTexto, 'T', 'C', False);

  //Títulos: NOME e VALOR (fixos)
  PosicoesX[0] := 0;
  PosicoesX[1] := 35;
  PosicoesX[2] := 70;
  PosicoesX[3] := 105;

  LPDF.SetFont(7, 'B');
  for i := 0 to 3 do
  begin
    x1 := x + PosicoesX[i];
    y1 := y - 115;
    LTexto := 'NOME';
    LPDF.TextBox(x1, y1, 35, 15, LTexto, 'T', 'L', True);

    x1 := x + PosicoesX[i] + 24;
    LTexto := 'VALOR';
    LPDF.TextBox(x1, y1, 10, 4, LTexto, 'C', 'C', False);
  end;
  LPDF.SetFont(7, '');
  // Valores reais de Nome e Valor
  for i := 0 to Min(3, LCTE.vPrest.Comp.Count - 1) do
  begin
    // Nome
    x1 := x + PosicoesX[i];
    y1 := y - 113;
    LTexto := LCTE.vPrest.Comp[i].xNome;
    LPDF.TextBox(x1, y1, 10, 13, LTexto, 'T', 'L', False);

    // Valor
    x1 := x + PosicoesX[i] + 24;
    LTexto := FormatFloat('#,0.00', LCTE.vPrest.Comp[i].vComp);
    LPDF.TextBox(x1, y1, 10, 13, LTexto, 'T', 'L', False);
  end;

  //Valor Total da Prestação do Serviço
  LPDF.SetFont(7, 'B');
  x1 := x + 140;
  y1 := y - 115;
  LTexto := 'VALOR TOTAL DA PRESTAÇÃO DO SERVIÇO';
  LPDF.TextBox(x1, y1, 64, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := 'R$ ' + FormatFloat('#,0.00', LCTE.vPrest.vTPrest);
  x1 := x + 140;
  y1 := y - 112;
  LPDF.TextBox(x1, y1, 64, 4, LTexto, 'T', 'L', False);

  //Valor a Receber
  LPDF.SetFont(7, 'B');
  x1 := x + 140;
  y1 := y - 108;
  LTexto := 'VALOR A RECEBER';
  LPDF.TextBox(x1, y1, 64, 8, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := 'R$ ' + FormatFloat('#,0.00', LCTE.vPrest.vRec);
  x1 := x + 140;
  y1 := y - 104;
  LPDF.TextBox(x1, y1, 64, 4, LTexto, 'T', 'L', False);

  //Informações Relativas ao Imposto
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 100;
  LTexto := 'INFORMAÇÕES RELATIVAS AO IMPOSTO';
  LPDF.TextBox(x1, y1, 210, 4, LTexto, 'T', 'C', False);

  //Classificação Tributária do Serviço
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 97;
  LTexto := 'CLASSIFICAÇÃO TRIBUTÁRIA DO SERVIÇO';
  LPDF.TextBox(x1, y1, 103, 6, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := CSTICMSToStrTagPosText(LCTE.Imp.ICMS.SituTrib);
  x1 := x + 1;
  y1 := y - 94;
  LPDF.TextBox(x1, y1, 102, 4, LTexto, 'T', 'L', False);

  case LCTE.Imp.ICMS.SituTrib of
    cst00:
      begin
        baseCalculo := LCTE.Imp.ICMS.ICMS00.vBC;
        aliquota := LCTE.Imp.ICMS.ICMS00.pICMS;
        vICMS := LCTE.Imp.ICMS.ICMS00.vICMS;
      end;
    cst20:
      begin
        RedBC := LCTE.Imp.ICMS.ICMS20.pRedBC;
        baseCalculo := LCTE.Imp.ICMS.ICMS20.vBC;
        aliquota := LCTE.Imp.ICMS.ICMS20.pICMS;
        vICMS := LCTE.Imp.ICMS.ICMS20.vICMS;
      end;
    cst60:
      begin
        baseCalculo := LCTE.Imp.ICMS.ICMS60.vBCSTRet;
        aliquota := LCTE.Imp.ICMS.ICMS60.pICMSSTRet;
        vICMS := LCTE.Imp.ICMS.ICMS60.vICMSSTRet;
      end;
    cst90:
      begin
        RedBC := LCTE.Imp.ICMS.ICMS90.pRedBC;
        baseCalculo := LCTE.Imp.ICMS.ICMS90.vBC;
        aliquota := LCTE.Imp.ICMS.ICMS90.pICMS;
        vICMS := LCTE.Imp.ICMS.ICMS90.vICMS;
      end;
    cstICMSOutraUF:
      begin
        RedBC := LCTE.Imp.ICMS.ICMSOutraUF.pRedBCOutraUF;
        baseCalculo := LCTE.Imp.ICMS.ICMSOutraUF.vBCOutraUF;
        aliquota := LCTE.Imp.ICMS.ICMSOutraUF.pICMSOutraUF;
        vICMS := LCTE.Imp.ICMS.ICMSOutraUF.vICMSOutraUF;
      end;
  else
    begin
      baseCalculo := 0;
      aliquota := 0;
      vICMS := 0;
      RedBC := 0;
    end;
  end;

  // Base de Cálculo
  LPDF.SetFont(7, 'B');
  x1 := x + 103;
  y1 := y - 97;
  LTexto := 'BASE DE CÁLCULO';
  LPDF.TextBox(x1, y1, 26, 6, LTexto, 'T', 'C', True);
  LPDF.SetFont(7, '');
  LTexto := FormatFloat('#,0.00', baseCalculo);
  x1 := x + 103;
  y1 := y - 94;
  LPDF.TextBox(x1, y1, 26, 4, LTexto, 'T', 'L', False);

  //AlÍquota do ICMS
  LPDF.SetFont(7, 'B');
  x1 := x + 129;
  y1 := y - 97;
  LTexto := 'ALÍQUOTA DO ICMS';
  LPDF.TextBox(x1, y1, 25, 6, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := FormatFloat('#,0.00', aliquota);
  x1 := x + 129;
  y1 := y - 94;
  LPDF.TextBox(x1, y1, 25, 4, LTexto, 'T', 'L', False);

  //Valor do ICMS
  LPDF.SetFont(7, 'B');
  x1 := x + 154;
  y1 := y - 97;
  LTexto := 'VALOR DO ICMS';
  LPDF.TextBox(x1, y1, 26, 6, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := FormatFloat('#,0.00', vICMS);
  x1 := x + 154;
  y1 := y - 94;
  LPDF.TextBox(x1, y1, 26, 4, LTexto, 'T', 'L', False);

  //% RED BC. CALC
  LPDF.SetFont(7, 'B');
  x1 := x + 180;
  y1 := y - 97;
  LTexto := '% RED BC. CALC';
  LPDF.TextBox(x1, y1, 24, 6, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := FormatFloat('#,0.00', RedBC);
  x1 := x + 180;
  y1 := y - 94;
  LPDF.TextBox(x1, y1, 24, 4, LTexto, 'T', 'L', False);

  //Documentos Originários
  LPDF.SetFont(7, 'B');
  x1 := x + 1;
  y1 := y - 90;
  LTexto := 'DOCUMENTOS ORIGINÁRIOS';
  LPDF.TextBox(x1, y1, 208, 4, LTexto, 'T', 'C', False);

  //TP DOC
  //Borda
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 87;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 102, 7, LTexto, 'T', 'C', True);
  //----

  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 87;
  LTexto := 'TP DOC.';
  LPDF.TextBox(x1, y1, 11, 4, LTexto, 'T', 'C', False);

  //CNPJ/CPF EMITENTE
  x1 := x + 11;
  y1 := y - 87;
  LTexto := 'CNPJ/CPF EMITENTE';
  LPDF.TextBox(x1, y1, 20, 4, LTexto, 'T', 'C', False);

  //SÉRIE/N DOCUMENTO
  x1 := x + 71;
  y1 := y - 87;
  LTexto := 'SÉRIE/N DOCUMENTO';
  LPDF.TextBox(x1, y1, 33, 4, LTexto, 'T', 'C', False);

  x1 := x + 102;
  y1 := y - 87;
  LTexto := 'TP DOC.';
  LPDF.TextBox(x1, y1, 33, 4, LTexto, 'T', 'C', False);

  x1 := x + 135;
  y1 := y - 87;
  LTexto := 'CNPJ/CPF EMITENTE';
  LPDF.TextBox(x1, y1, 33, 4, LTexto, 'T', 'C', False);

  x1 := x + 168;
  y1 := y - 87;
  LTexto := 'SÉRIE/N DOCUMENTO';
  LPDF.TextBox(x1, y1, 33, 4, LTexto, 'T', 'C', False);

  //TP DOC
  //Borda
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 87;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 102, 7, LTexto, 'T', 'C', True);

  LPDF.SetFont(7, '');

  cdsDocAnt := TClientDataSet.Create(nil);
  try
    cdsDocAnt.FieldDefs.Clear;
    cdsDocAnt.FieldDefs.Add('TipoDoc', ftString, 20);
    cdsDocAnt.FieldDefs.Add('CNPJCPF', ftString, 14);
    cdsDocAnt.FieldDefs.Add('Serie', ftString, 10);
    cdsDocAnt.FieldDefs.Add('Numero', ftString, 15);
    cdsDocAnt.FieldDefs.Add('Chave', ftString, 44);
    cdsDocAnt.FieldDefs.Add('DataEmissao', ftDate);
    cdsDocAnt.CreateDataSet;
    for i := 0 to LCTE.infCTeNorm.docAnt.emiDocAnt.Count - 1 do
      for ii := 0 to Pred(LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt.Count) do
        for iii := 0 to Pred(LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt[ii].idDocAntPap.Count) do
        begin
          cdsDocAnt.Append;

          cdsDocAnt.FieldByName('TipoDoc').AsString := TTipoDocumentoAnteriorArrayStrings[LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt[ii].idDocAntPap[iii].tpDoc];
          cdsDocAnt.FieldByName('Serie').AsString := LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt[ii].idDocAntPap[iii].serie;
          cdsDocAnt.FieldByName('Numero').AsString := LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt[ii].idDocAntPap[iii].nDoc;
          cdsDocAnt.FieldByName('DataEmissao').AsDateTime := LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt[ii].idDocAntPap[iii].dEmi;

          cdsDocAnt.Post;
        end;
    for i := 0 to LCTE.infCTeNorm.docAnt.emiDocAnt.Count - 1 do
      for ii := 0 to Pred(LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt.Count) do
        for iii := 0 to Pred(LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt[ii].idDocAntEle.Count) do
        begin
          with LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt[ii].idDocAntEle[iii] do
          begin
            cdsDocAnt.Append;
            cdsDocAnt.FieldByName('TipoDoc').AsString := 'CT-e';
            cdsDocAnt.FieldByName('CNPJCPF').AsString := LCTE.infCTeNorm.docAnt.emiDocAnt[i].CNPJCPF;

            if LCTE.infCTe.versao >= 3 then
              cdsDocAnt.FieldByName('Chave').AsString := LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt[ii].idDocAntEle[iii].chCTe
            else
              cdsDocAnt.FieldByName('Chave').AsString := LCTE.infCTeNorm.docAnt.emiDocAnt[i].idDocAnt[ii].idDocAntEle[iii].chave;

            cdsDocAnt.FieldByName('Serie').AsString := Copy(cdsDocAnt.FieldByName('Chave').AsString, 23, 3);
            cdsDocAnt.FieldByName('Numero').AsString := Copy(cdsDocAnt.FieldByName('Chave').AsString, 26, 9);
            cdsDocAnt.FieldByName('DataEmissao').AsDateTime := EncodeDate(StrToInt(Copy(cdsDocAnt.FieldByName('Chave').AsString, 3, 2)), StrToInt(Copy(cdsDocAnt.FieldByName('Chave').AsString, 5, 2)), 1);

            cdsDocAnt.Post;
          end;
        end;
    cdsDocAnt.First;
    LPDF.SetFont(7, '');
    while not cdsDocAnt.Eof do
    begin
      //esquerda
      x1 := x;
      y1 := y - 87;
      LPDF.TextBox(x1, y1, 11, 4, cdsDocAnt.FieldByName('TipoDoc').AsString, 'T', 'C', False);

      x1 := x + 36;
      y1 := y - 84;
      LPDF.TextBox(x1, y1, 33, 4, cdsDocAnt.FieldByName('CNPJCPF').AsString, 'T', 'C', False);

      x1 := x + 102;
      y1 := y - 84;
      LPDF.TextBox(x1, y1, 33, 4, cdsDocAnt.FieldByName('Chave').AsString, 'T', 'C', False);

      //direita
      x1 := x + 71;
      y1 := y - 84;
      LPDF.TextBox(x1, y1, 33, 4, cdsDocAnt.FieldByName('TipoDoc').AsString, 'T', 'C', False);

      x1 := x + 135;
      y1 := y - 84;
      LPDF.TextBox(x1, y1, 33, 4, cdsDocAnt.FieldByName('CNPJCPF').AsString, 'T', 'C', False);

      LTexto := '';
      x1 := x + 168;
      y1 := y - 84;
      LPDF.TextBox(x1, y1, 33, 4, cdsDocAnt.FieldByName('Chave').AsString, 'T', 'C', False);

      cdsDocAnt.Next;
    end;

  finally
    cdsDocAnt.Free;
  end;


  //Previsão do Fluxo da Carga
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 80;
  LTexto := 'PREVISÃO DO FLUXO DA CARGA';
  LPDF.TextBox(x1, y1, 210, 4, LTexto, 'T', 'C', False);

  //Sigla ou código interno da Filial/Porto/Estação/ Aeroporto de Origem
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 77;
  LTexto := 'SIGLA OU CÓD INT. DA FILIAL, PORTO ,ESTAÇÃO';
  LPDF.TextBox(x1, y1, 69, 7, LTexto, 'T', 'C', True);
  LPDF.SetFont(7, 'B');
  LTexto := LCTE.compl.fluxo.xOrig;
  x1 := x;
  y1 := y - 74;
  LPDF.TextBox(x1, y1, 69, 4, LTexto, 'T', 'L', False);

  //Sigla ou código interno da Filial/Porto/Estação/Aeroporto de Passagem
  LPDF.SetFont(7, 'B');
  x1 := x + 69;
  y1 := y - 77;
  LTexto := 'SIGLA OU CÓD INT. DA FILIAL, PORTO ,ESTAÇÃO';
  LPDF.TextBox(x1, y1, 69, 7, LTexto, 'T', 'C', True);
  LPDF.SetFont(7, 'B');
  LTexto := LCTE.compl.fluxo.xOrig;
  x1 := x + 69;
  y1 := y - 74;
  LPDF.TextBox(x1, y1, 68, 4, LTexto, 'T', 'L', False);

  //Sigla ou código interno da Filial/Porto/Estação/Aeroporto de Destino
  LPDF.SetFont(7, 'B');
  x1 := x + 138;
  y1 := y - 77;
  LTexto := 'SIGLA OU CÓD INT. DA FILIAL, PORTO ,ESTAÇÃO';
  LPDF.TextBox(x1, y1, 66, 7, LTexto, 'T', 'C', True);
  LPDF.SetFont(7, 'B');
  LTexto := LCTE.compl.fluxo.xDest;
  x1 := x + 138;
  y1 := y - 74;
  LPDF.TextBox(x1, y1, 66, 4, LTexto, 'T', 'L', False);

  //Observações Gerais
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 69;
  LTexto := 'OBSERVAÇÕES GERAIS';
  LPDF.TextBox(x1, y1, 204, 3, LTexto, 'T', 'C', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.compl.xObs;
  x1 := x;
  y1 := y - 66;
  LPDF.TextBox(x1, y1, 204, 10, LTexto, 'T', 'L', True);
end;

procedure TBlocoInformacoesCTe.OnInit(Args: TFPDFBandInitArgs);
begin
  Height := 1;
end;

{ TBlocoInformacoesRemDestExpRecebCTe }

constructor TBlocoInformacoesRemDestExpRecebCTe.Create(ACTeUtils: TCTeUtilsFPDF);
begin
  inherited Create(btData);
  FCTeUtils := ACTeUtils;
end;

procedure TBlocoInformacoesRemDestExpRecebCTe.OnDraw(Args: TFPDFBandDrawArgs);
var
  LPDF: IFPDF;
  LCTE: TCTe;
  x, y: double;
  x1, y1: double;
  LTexto: string;
begin
  inherited OnDraw(Args);

  LPDF := Args.PDF;
  LCTE := FCTeUtils.CTe;

  //Posição Inicial
  x := 0;
  y := 80;

  //Inicio da Prestação
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 180;
  LTexto := 'INICIO DA PRESTAÇÃO';
  LPDF.TextBox(x1, y1, 104, 6, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := LCTE.ide.xMunIni;
  x1 := x;
  y1 := y - 177;
  LPDF.TextBox(x1, y1, 100, 4, LTexto, 'T', 'L', False);

  //Término da Prestação
  LPDF.SetFont(7, 'B');
  x1 := x + 104;
  y1 := y - 180;
  LTexto := 'TÉRMINO DA PRESTAÇÃO';
  LPDF.TextBox(x1, y1, 100, 6, LTexto, 'T', 'L', True);
  LPDF.SetFont(7, '');
  LTexto := LCTE.ide.xMunFim;
  x1 := x + 104;
  y1 := y - 177;
  LPDF.TextBox(x1, y1, 100, 4, LTexto, 'T', 'L', False);

  //Remetente
  //Borda Remetente
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 174;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 102, 16, LTexto, 'T', 'L', True);
  //------

  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 173;
  LTexto := 'REMETENTE:';
  LPDF.TextBox(x1, y1, 18, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.rem.xNome;
  x1 := x + 16;
  y1 := y - 173;
  LPDF.TextBox(x1, y1, 89, 4, LTexto, 'T', 'L', False);

  //Endereço Remetente
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 170;
  LTexto := 'ENDEREÇO:';
  LPDF.TextBox(x1, y1, 18, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.rem.enderReme.xLgr + ' ' + LCTE.rem.enderReme.nro + ' ' + LCTE.rem.enderReme.xCpl + ' ' + LCTE.rem.enderReme.xBairro;
  x1 := x + 15;
  y1 := y - 170;
  LPDF.TextBox(x1, y1, 89, 4, LTexto, 'T', 'L', False);

  //Municipio Remetente
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 167;
  LTexto := 'MUNICÍPIO:';
  LPDF.TextBox(x1, y1, 18, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.rem.enderReme.xMun;
  x1 := x + 14;
  y1 := y - 167;
  LPDF.TextBox(x1, y1, 63, 4, LTexto, 'T', 'L', False);

  //CEP Remetente
  LPDF.SetFont(7, 'B');
  x1 := x + 78;
  y1 := y - 167;
  LTexto := 'CEP:';
  LPDF.TextBox(x1, y1, 7, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  if LCTE.rem.enderReme.CEP > 0 then
    LTexto := FormatarCEP(LCTE.rem.enderReme.CEP)
  else
    LTexto := '';
  x1 := x + 85;
  y1 := y - 167;
  LPDF.TextBox(x1, y1, 21, 4, LTexto, 'T', 'L', False);

  //CNPJ/CPF Remetente
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 164;
  LTexto := 'CNPJ/CPF:';
  LPDF.TextBox(x1, y1, 18, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := FormatarCNPJouCPF(LCTE.rem.CNPJCPF);
  x1 := x + 13;
  y1 := y - 164;
  LPDF.TextBox(x1, y1, 56, 4, LTexto, 'T', 'L', False);

  //Inscrição Estadual Remetente
  LPDF.SetFont(7, 'B');
  x1 := x + 71;
  y1 := y - 164;
  LTexto := 'IE:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.rem.IE;
  x1 := x + 76;
  y1 := y - 164;
  LPDF.TextBox(x1, y1, 28, 4, LTexto, 'T', 'L', False);

  //UF Remetente
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 161;
  LTexto := 'UF:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.rem.enderReme.UF;
  x1 := x + 5;
  y1 := y - 161;
  LPDF.TextBox(x1, y1, 12, 4, LTexto, 'T', 'L', False);

  //País Remetente
  LPDF.SetFont(7, 'B');
  x1 := x + 17;
  y1 := y - 161;
  LTexto := 'PAÍS:';
  LPDF.TextBox(x1, y1, 7, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.rem.enderReme.xPais;
  x1 := x + 24;
  y1 := y - 161;
  LPDF.TextBox(x1, y1, 56, 4, LTexto, 'T', 'L', False);

  //Fone Remetente
  LPDF.SetFont(7, 'B');
  x1 := x + 76;
  y1 := y - 161;
  LTexto := 'FONE:';
  LPDF.TextBox(x1, y1, 8, 4, LTexto, 'T', 'C', False);
  LPDF.SetFont(7, '');
  LTexto := FormatarFone(LCTE.rem.fone);
  x1 := x + 85;
  y1 := y - 161;
  LPDF.TextBox(x1, y1, 21, 4, LTexto, 'T', 'L', False);

  //Expedidor
  //Borda Expedidor
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 158;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 102, 16, LTexto, 'T', 'C', True);
  //-----

  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 157;
  LTexto := 'EXPEDIDOR:';
  LPDF.TextBox(x1, y1, 16, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.exped.xNome;
  x1 := x + 16;
  y1 := y - 157;
  LPDF.TextBox(x1, y1, 89, 4, LTexto, 'T', 'L', False);

  //Endereço Expedidor
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 154;
  LTexto := 'ENDEREÇO:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.exped.enderExped.xLgr + ' ' + LCTE.exped.enderExped.nro + ' ' + LCTE.exped.enderExped.xCpl + ' ' + LCTE.exped.enderExped.xBairro;
  x1 := x + 15;
  y1 := y - 154;
  LPDF.TextBox(x1, y1, 89, 4, LTexto, 'T', 'L', False);

  //Municipio Expedidor
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 151;
  LTexto := 'MUNICÍPIO:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.exped.enderExped.xMun;
  x1 := x + 15;
  y1 := y - 151;
  LPDF.TextBox(x1, y1, 63, 4, LTexto, 'T', 'L', False);

  //CEP Expedidor
  LPDF.SetFont(7, 'B');
  x1 := x + 78;
  y1 := y - 151;
  LTexto := 'CEP:';
  LPDF.TextBox(x1, y1, 7, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  if LCTE.exped.enderExped.CEP > 0 then
    LTexto := FormatarCEP(LCTE.exped.enderExped.CEP)
  else
    LTexto := '';

  x1 := x + 85;
  y1 := y - 151;
  LPDF.TextBox(x1, y1, 21, 4, LTexto, 'T', 'L', False);

  //CNPJ/CPF Expedidor
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 148;
  LTexto := 'CNPJ/CPF:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := FormatarCNPJouCPF(LCTE.exped.CNPJCPF);
  x1 := x + 15;
  y1 := y - 148;
  LPDF.TextBox(x1, y1, 56, 4, LTexto, 'T', 'L', False);

  //Inscrição Estadual Expedidor
  LPDF.SetFont(7, 'B');
  x1 := x + 71;
  y1 := y - 148;
  LTexto := 'IE:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.exped.IE;
  x1 := x + 76;
  y1 := y - 148;
  LPDF.TextBox(x1, y1, 28, 4, LTexto, 'T', 'L', False);

  //UF Expedidor
  LPDF.SetFont(7, 'B');
  x1 := x;
  y1 := y - 145;
  LTexto := 'UF:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.exped.enderExped.UF;
  x1 := x + 5;
  y1 := y - 145;
  LPDF.TextBox(x1, y1, 12, 4, LTexto, 'T', 'L', False);

  //País Expedidor
  LPDF.SetFont(7, 'B');
  x1 := x + 17;
  y1 := y - 145;
  LTexto := 'PAÍS:';
  LPDF.TextBox(x1, y1, 7, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.exped.enderExped.xPais;
  x1 := x + 24;
  y1 := y - 145;
  LPDF.TextBox(x1, y1, 56, 4, LTexto, 'T', 'L', False);

  //Fone Expedidor
  LPDF.SetFont(7, 'B');
  x1 := x + 76;
  y1 := y - 145;
  LTexto := 'FONE:';
  LPDF.TextBox(x1, y1, 8, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := FormatarFone(LCTE.exped.fone);
  x1 := x + 85;
  y1 := y - 145;
  LPDF.TextBox(x1, y1, 21, 4, LTexto, 'T', 'L', False);

  //Destinatário
  //Borda Destinatário
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 174;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 102, 16, LTexto, 'T', 'L', True);
  //----

  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 173;
  LTexto := 'DESTINATÁRIO:';
  LPDF.TextBox(x1, y1, 20, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.dest.xNome;
  x1 := x + 122;
  y1 := y - 173;
  LPDF.TextBox(x1, y1, 83, 4, LTexto, 'T', 'L', False);

  //Endereço Destinatário
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 170;
  LTexto := 'ENDEREÇO:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.dest.enderDest.xLgr + ' ' + LCTE.dest.enderDest.nro + ' ' + LCTE.dest.enderDest.xCpl + ' ' + LCTE.dest.enderDest.xBairro;
  x1 := x + 117;
  y1 := y - 170;
  LPDF.TextBox(x1, y1, 89, 4, LTexto, 'T', 'L', False);

  //Municipio Destinatário
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 167;
  LTexto := 'MUNICÍPIO:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.dest.enderDest.xMun;
  x1 := x + 116;
  y1 := y - 167;
  LPDF.TextBox(x1, y1, 62, 4, LTexto, 'T', 'L', False);

  //CEP Destinatário
  LPDF.SetFont(7, 'B');
  x1 := x + 180;
  y1 := y - 167;
  LTexto := 'CEP:';
  LPDF.TextBox(x1, y1, 7, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  if LCTE.dest.enderDest.CEP > 0 then
    LTexto := FormatarCEP(LCTE.dest.enderDest.CEP)
  else
    LTexto := '';

  x1 := x + 186;
  y1 := y - 167;
  LPDF.TextBox(x1, y1, 21, 4, LTexto, 'T', 'L', False);

  //CNPJ/CPF Destinatário
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 164;
  LTexto := 'CNPJ/CPF:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := FormatarCNPJouCPF(LCTE.dest.CNPJCPF);
  x1 := x + 116;
  y1 := y - 164;
  LPDF.TextBox(x1, y1, 55, 4, LTexto, 'T', 'L', False);

  //Inscrição Estadual Destinatário
  LPDF.SetFont(7, 'B');
  x1 := x + 176;
  y1 := y - 164;
  LTexto := 'IE:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.dest.IE;
  x1 := x + 180;
  y1 := y - 164;
  LPDF.TextBox(x1, y1, 29, 4, LTexto, 'T', 'L', False);

  //UF Destinatário
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 161;
  LTexto := 'UF:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.dest.enderDest.UF;
  x1 := x + 107;
  y1 := y - 161;
  LPDF.TextBox(x1, y1, 12, 4, LTexto, 'T', 'L', False);

  //País Destinatário
  LPDF.SetFont(7, 'B');
  x1 := x + 120;
  y1 := y - 161;
  LTexto := 'PAÍS:';
  LPDF.TextBox(x1, y1, 8, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.dest.enderDest.xPais;
  x1 := x + 127;
  y1 := y - 161;
  LPDF.TextBox(x1, y1, 55, 4, LTexto, 'T', 'L', False);

  //Fone Destinatário
  LPDF.SetFont(7, 'B');
  x1 := x + 179;
  y1 := y - 161;
  LTexto := 'FONE:';
  LPDF.TextBox(x1, y1, 8, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := FormatarFone(LCTE.dest.fone);
  x1 := x + 187;
  y1 := y - 161;
  LPDF.TextBox(x1, y1, 22, 4, LTexto, 'T', 'L', False);

  //Recebedor
  //Borda Recebedor
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 158;
  LTexto := EmptyStr;
  LPDF.TextBox(x1, y1, 102, 16, LTexto, 'T', 'L', True);
  //----

  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 157;
  LTexto := 'RECEBEDOR:';
  LPDF.TextBox(x1, y1, 17, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.receb.xNome;
  x1 := x + 118;
  y1 := y - 157;
  LPDF.TextBox(x1, y1, 89, 4, LTexto, 'T', 'L', False);

  //Endereço Recebedor
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 154;
  LTexto := 'ENDEREÇO:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.receb.enderReceb.xLgr + ' ' + LCTE.receb.enderReceb.nro + ' ' + LCTE.receb.enderReceb.xCpl + ' ' + LCTE.receb.enderReceb.xBairro;
  x1 := x + 121;
  y1 := y - 154;
  LPDF.TextBox(x1, y1, 89, 4, LTexto, 'T', 'L', False);

  //Municipio Recebedor
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 151;
  LTexto := 'MUNICÍPIO:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.receb.enderReceb.xMun;
  x1 := x + 121;
  y1 := y - 151;
  LPDF.TextBox(x1, y1, 62, 4, LTexto, 'T', 'L', False);

  //CEP Recebedor
  LPDF.SetFont(7, 'B');
  x1 := x + 180;
  y1 := y - 151;
  LTexto := 'CEP:';
  LPDF.TextBox(x1, y1, 7, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  if LCTE.receb.enderReceb.CEP > 0 then
    LTexto := FormatarCEP(LCTE.receb.enderReceb.CEP)
  else
    LTexto := '';
  x1 := x + 186;
  y1 := y - 151;
  LPDF.TextBox(x1, y1, 21, 4, LTexto, 'T', 'L', False);

  //CNPJ/CPF Recebedor
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 148;
  LTexto := 'CNPJ/CPF:';
  LPDF.TextBox(x1, y1, 15, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := FormatarCNPJouCPF(LCTE.receb.CNPJCPF);
  x1 := x + 121;
  y1 := y - 148;
  LPDF.TextBox(x1, y1, 55, 4, LTexto, 'T', 'L', False);

  //Inscrição Estadual Recebedor
  LPDF.SetFont(7, 'B');
  x1 := x + 176;
  y1 := y - 148;
  LTexto := 'IE:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, '');
  LTexto := LCTE.receb.IE;
  x1 := x + 181;
  y1 := y - 148;
  LPDF.TextBox(x1, y1, 29, 4, LTexto, 'T', 'L', False);

  //UF Recebedor
  LPDF.SetFont(7, 'B');
  x1 := x + 102;
  y1 := y - 145;
  LTexto := 'UF:';
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, 'B');
  LTexto := LCTE.receb.enderReceb.UF;
  x1 := x + 111;
  y1 := y - 145;
  LPDF.TextBox(x1, y1, 12, 4, LTexto, 'T', 'L', False);

  //País Recebedor
  LPDF.SetFont(7, 'B');
  x1 := x + 120;
  y1 := y - 145;
  LTexto := 'PAÍS:';
  LPDF.TextBox(x1, y1, 7, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, 'B');
  LTexto := LCTE.receb.enderReceb.xPais;
  x1 := x + 127;
  y1 := y - 145;
  LPDF.TextBox(x1, y1, 55, 4, LTexto, 'T', 'L', False);

  //Fone Recebedor
  LPDF.SetFont(7, 'B');
  x1 := x + 179;
  y1 := y - 145;
  LTexto := 'FONE:';
  LPDF.TextBox(x1, y1, 8, 4, LTexto, 'T', 'L', False);
  LPDF.SetFont(7, 'B');
  LTexto := FormatarFone(LCTE.receb.fone);
  x1 := x + 186;
  y1 := y - 145;
  LPDF.TextBox(x1, y1, 22, 4, LTexto, 'T', 'L', False);
end;

procedure TBlocoInformacoesRemDestExpRecebCTe.OnInit(Args: TFPDFBandInitArgs);
begin
  Height := 1;
end;

{ TBlocoModalRodoviarioCTe }

constructor TBlocoModalRodoviarioCTe.Create(ACTeUtils: TCTeUtilsFPDF);
begin
  inherited Create(btData);
  FCTeUtils := ACTeUtils;
end;

procedure TBlocoModalRodoviarioCTe.OnDraw(Args: TFPDFBandDrawArgs);
var
  LPDF: IFPDF;
  LCTE: TCTe;
  x, y, w: double;
  x1, y1: double;
  LTexto: string;
begin
  inherited OnDraw(Args);
  LPDF := Args.PDF;
  LCTE := FCTeUtils.CTe;


  //Informações Específicas do modal Rodoviário
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y + 24;
  LTexto := 'INFORMAÇÕES ESPECÍFICAS DO MODAL RODOVIÁRIO';
  LPDF.TextBox(x1, y1, 208, 4, LTexto, 'C', 'C', False);
  LTexto := 'RNTRC DA EMPRESA';//LCTE.infCTeNorm.rodo.RNTRC;
  x1 := x;
  y1 := y + 28;
  LPDF.TextBox(x1, y1, 50, 8, LTexto, 'T', 'L', True);
  LPDF.TextBox(x1 + 50, y1, 154, 8, '', 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.rodo.RNTRC;
  x1 := x;
  y1 := y + 32;
  LPDF.TextBox(x1, y1, 50, 4, LTexto, 'T', 'L', False);
end;

procedure TBlocoModalRodoviarioCTe.OnInit(Args: TFPDFBandInitArgs);
begin
  Height := 1;
end;

{ TBlocoModalCTeOSCTe }

constructor TBlocoModalCTeOSCTe.Create(ACTeUtils: TCTeUtilsFPDF);
begin
  inherited Create(btData);
  FCTeUtils := ACTeUtils;
end;

procedure TBlocoModalCTeOSCTe.OnDraw(Args: TFPDFBandDrawArgs);
var
  LPDF: IFPDF;
  LCTE: TCTe;
  x, y: double;
  x1, y1: double;
  i: integer;
  LTexto: string;
begin
  inherited OnDraw(Args);

  LPDF := Args.PDF;
  LCTE := FCTeUtils.CTe;
  //Posição Inicial
  x := 0;
  y := 65;

    //Seguro da Viagem
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 42;
  LTexto := 'SEGURO DA VIAGEM';
  LPDF.TextBox(x1, y1, 208, 4, LTexto, 'T', 'C', False);
  LPDF.SetFont(8, '');

  //Responsável
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 38;
  LTexto := 'RESPONSÁVEL';
  LPDF.TextBox(x1, y1, 69, 8, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := '';
  for i := 0 to LCTE.infCTeNorm.seg.Count - 1 do
  begin
    LTexto := TpRspSeguroToStr(LCTE.infCTeNorm.seg.Items[i].respSeg);
  end;
  x1 := x;
  y1 := y - 35;
  LPDF.TextBox(x1, y1, 69, 4, LTexto, 'C', 'L', False);

  //Nome da Seguradora
  LPDF.SetFont(8, 'B');
  x1 := x + 69;
  y1 := y - 38;
  LTexto := 'NOME DA SEGURADORA';
  LPDF.TextBox(x1, y1, 70, 8, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := '';
  for i := 0 to LCTE.infCTeNorm.seg.Count - 1 do
  begin
    LTexto := LCTE.infCTeNorm.seg.Items[i].xSeg;
  end;
  x1 := x + 70;
  y1 := y - 35;
  LPDF.TextBox(x1, y1, 69, 4, LTexto, 'C', 'L', False);

  //Número da Apólice
  LPDF.SetFont(8, 'B');
  x1 := x + 139;
  y1 := y - 38;
  LTexto := 'NÚMERO DA APÓLICE';
  LPDF.TextBox(x1, y1, 65, 8, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := '';
  for i := 0 to LCTE.infCTeNorm.seg.Count - 1 do
  begin
    LTexto := LCTE.infCTeNorm.seg.Items[i].nApol;
  end;
  x1 := x + 139;
  y1 := y - 35;
  LPDF.TextBox(x1, y1, 65, 4, LTexto, 'C', 'L', False);

  //Informações Específicas do modal Rodoviário
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 30;
  LTexto := 'INFORMAÇÕES ESPECÍFICAS DO MODAL RODOVIÁRIO';
  LPDF.TextBox(x1, y1, 210, 4, LTexto, 'C', 'C', False);
  LPDF.SetFont(8, 'B');

  //Termo de Autorização de Fretamento
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 27;
  LTexto := 'TERMO AUT. DE FRETAMENTO';
  LPDF.TextBox(x1, y1, 50, 8, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.rodoOS.veic.Prop.TAF;
  x1 := x;
  y1 := y - 24;
  LPDF.TextBox(x1, y1, 50, 4, LTexto, 'T', 'L', False);

  //N de Registro Estadual
  LPDF.SetFont(8, 'B');
  x1 := x + 50;
  y1 := y - 27;
  LTexto := 'N DE REGISTRO ESTADUAL';
  LPDF.TextBox(x1, y1, 43, 8, LTexto, 'T', 'C', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.rodoOS.veic.prop.NroRegEstadual;
  x1 := x + 50;
  y1 := y - 24;
  LPDF.TextBox(x1, y1, 43, 4, LTexto, 'T', 'L', False);

  //Placa do Veículo
  LPDF.SetFont(8, 'B');
  x1 := x + 93;
  y1 := y - 27;
  LTexto := 'PLACA DO VEÍCULO';
  LPDF.TextBox(x1, y1, 34, 8, LTexto, 'T', 'C', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.rodoOS.veic.placa;
  x1 := x + 93;
  y1 := y - 24;
  LPDF.TextBox(x1, y1, 34, 4, LTexto, 'T', 'L', False);

  //Renavam do Veículo
  LPDF.SetFont(8, 'B');
  x1 := x + 127;
  y1 := y - 27;
  LTexto := 'RENAVAM DO VEÍCULO';
  LPDF.TextBox(x1, y1, 35, 8, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.rodoOS.veic.RENAVAM;
  x1 := x + 127;
  y1 := y - 24;
  LPDF.TextBox(x1, y1, 41, 4, LTexto, 'T', 'L', False);

  //CNPJ/CPF
  LPDF.SetFont(8, 'B');
  x1 := x + 162;
  y1 := y - 27;
  LTexto := 'CNPJ/CPF';
  LPDF.TextBox(x1, y1, 42, 8, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := FormatarCNPJouCPF(LCTE.infCTeNorm.rodoOS.veic.prop.CNPJCPF);
  x1 := x + 162;
  y1 := y - 24;
  LPDF.TextBox(x1, y1, 42, 4, LTexto, 'T', 'L', False);
end;

procedure TBlocoModalCTeOSCTe.OnInit(Args: TFPDFBandInitArgs);
begin
  Height := 1;
end;

{ TBlocoModalAquaviarioCTe }

constructor TBlocoModalAquaviarioCTe.Create(ACTeUtils: TCTeUtilsFPDF);
begin
  inherited Create(btData);
  FCTeUtils := ACTeUtils;
end;

procedure TBlocoModalAquaviarioCTe.OnDraw(Args: TFPDFBandDrawArgs);
var
  LPDF: IFPDF;
  LCTE: TCTe;
  x, y: double;
  x1, y1: double;
  i: integer;
  LTexto: string;
begin
  inherited OnDraw(Args);

  LPDF := Args.PDF;
  LCTE := FCTeUtils.CTe;

  //Posição Inicial
  x := 0;
  y := 56;

  //Informações Específicas do modal Aquaviário(II)
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 32;
  LTexto := 'INFORMAÇÕES ESPECÍFICAS DO MODAL AQUAVIÁRIO (II)';
  LPDF.TextBox(x1, y1, 210, 4, LTexto, 'T', 'C', False);

  //Identificação do Navio/Rebocador
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 28;
  LTexto := 'IDENTIFICAÇÃO DO NAVIO / REBOCADOR';
  LPDF.TextBox(x1, y1, 71, 8, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.aquav.xNavio;
  x1 := x + 1;
  y1 := y - 25;
  LPDF.TextBox(x1, y1, 71, 4, LTexto, 'T', 'L', False);

  //Identificação da Balsa
  LPDF.SetFont(8, 'B');
  x1 := x + 71;
  y1 := y - 28;
  LTexto := 'IDENTIFICAÇÃO DA BALSA';
  LPDF.TextBox(x1, y1, 68, 8, LTexto, 'T', 'L', True);
  LTexto := '';
  LPDF.SetFont(8, '');
  for i := 0 to LCTE.infCTeNorm.aquav.balsa.Count - 1 do
  begin
    LTexto := LCTE.infCTeNorm.aquav.balsa.Items[i].xBalsa;
  end;
  x1 := x + 71;
  y1 := y - 25;
  LPDF.TextBox(x1, y1, 68, 4, LTexto, 'T', 'L', False);

  //Valor do AFRMM
  LPDF.SetFont(8, 'B');
  x1 := x + 139;
  y1 := y - 28;
  LTexto := 'VLR. DO AFRMM';
  LPDF.TextBox(x1, y1, 65, 8, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := 'R$ ' + FormatFloat('#,0.00', LCTE.infCTeNorm.aquav.vAFRMM);
  x1 := x + 139;
  y1 := y - 25;
  LPDF.TextBox(x1, y1, 65, 4, LTexto, 'T', 'L', False);

end;

procedure TBlocoModalAquaviarioCTe.OnInit(Args: TFPDFBandInitArgs);
begin
  Height := 1;
end;

{ TBlocoModalAereoCTe }

constructor TBlocoModalAereoCTe.Create(ACTeUtils: TCTeUtilsFPDF);
begin
  inherited Create(btData);
  FCTeUtils := ACTeUtils;
end;

procedure TBlocoModalAereoCTe.OnDraw(Args: TFPDFBandDrawArgs);
var
  LPDF: IFPDF;
  LCTE: TCTe;
  x, y: double;
  x1, y1: double;
  i: integer;
  LTexto: string;
begin
  inherited OnDraw(Args);

  LPDF := Args.PDF;
  LCTE := FCTeUtils.CTe;

  //Posição Inicial
  x := 0;
  y := 69;
//Informações Específicas do modal Aéreo
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 46;
  LTexto := 'INFORMAÇÕES ESPECÍFICAS DO MODAL AÉREO';
  LPDF.TextBox(x1, y1, 210, 4, LTexto, 'T', 'C', False);

  //Número Operacional do Conhecimento Aéreo
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 42;
  LTexto := 'NÚMERO OPERACIONAL DO CONHECIMENTO AÉREO';
  LPDF.TextBox(x1, y1, 75, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.aereo.nOCA;
  x1 := x;
  y1 := y - 39;
  LPDF.TextBox(x1, y1, 75, 4, LTexto, 'T', 'L', False);

  //Classe
  LPDF.SetFont(8, 'B');
  x1 := x + 75;
  y1 := y - 42;
  LTexto := 'CLASSE';
  LPDF.TextBox(x1, y1, 50, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.aereo.tarifa.CL;
  x1 := x + 75;
  y1 := y - 39;
  LPDF.TextBox(x1, y1, 50, 4, LTexto, 'T', 'L', False);

  //Código da Tarifa
  LPDF.SetFont(8, 'B');
  x1 := x + 125;
  y1 := y - 42;
  LTexto := 'CÓDIGO DA TARIFA';
  LPDF.TextBox(x1, y1, 40, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.aereo.tarifa.cTar;
  x1 := x + 125;
  y1 := y - 39;
  LPDF.TextBox(x1, y1, 40, 4, LTexto, 'T', 'L', False);

  //Valor da Tarifa
  LPDF.SetFont(8, 'B');
  x1 := x + 165;
  y1 := y - 42;
  LTexto := 'VALOR DA TARIFA';
  LPDF.TextBox(x1, y1, 39, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := 'R$ ' + FormatFloat('#,0.00', LCTE.infCTeNorm.aereo.tarifa.vTar);
  x1 := x + 168;
  y1 := y - 39;
  LPDF.TextBox(x1, y1, 39, 4, LTexto, 'T', 'L', False);

  //Número da Minuta
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 35;
  LTexto := 'NÚMERO DA MINUTA';
  LPDF.TextBox(x1, y1, 75, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := IntToStr(LCTE.infCTeNorm.aereo.nMinu);
  x1 := x;
  y1 := y - 32;
  LPDF.TextBox(x1, y1, 75, 4, LTexto, 'T', 'L', False);

  //Retira
  LPDF.SetFont(8, 'B');
  x1 := x + 75;
  y1 := y - 35;
  LTexto := 'RETIRA';
  LPDF.TextBox(x1, y1, 30, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := ifthen(LCTE.ide.indGlobalizado = tiSim, 'X', '');
  x1 := x + 75;
  y1 := y - 32;
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', True);
  LTexto := 'SIM';
  x1 := x + 81;
  y1 := y - 32;
  LPDF.TextBox(x1, y1, 8, 4, LTexto, 'T', 'L', False);
  LTexto := ifthen(LCTE.ide.indGlobalizado = tiNao, 'X', '');
  x1 := x + 89;
  y1 := y - 32;
  LPDF.TextBox(x1, y1, 5, 4, LTexto, 'T', 'L', True);
  LTexto := 'NÃO';
  x1 := x + 94;
  y1 := y - 32;
  LPDF.TextBox(x1, y1, 8, 4, LTexto, 'T', 'L', False);

  //Dados relativos a retirada da carga
  LPDF.SetFont(8, 'B');
  x1 := x + 105;
  y1 := y - 35;
  LTexto := 'DADOS RELATIVOS A RETIRADA DA CARGA';
  LPDF.TextBox(x1, y1, 99, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := '';
  x1 := x + 105;
  y1 := y - 32;
  LPDF.TextBox(x1, y1, 99, 4, LTexto, 'T', 'L', False);

  //Caracteristicas adicional do serviço
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 28;
  LTexto := 'CARAC. ADICIONAL DO SERVIÇO';
  LPDF.TextBox(x1, y1, 53, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := '';
  x1 := x + 1;
  y1 := y - 25;
  LPDF.TextBox(x1, y1, 53, 4, LTexto, 'T', 'L', False);

  //Data prevista da entrega
  LPDF.SetFont(8, 'B');
  x1 := x + 53;
  y1 := y - 28;
  LTexto := 'DATA PREVISTA DA ENTREGA';
  LPDF.TextBox(x1, y1, 45, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  if LCTE.infCTeNorm.aereo.dPrevAereo > 0 then
    LTexto := DateToStr(LCTE.infCTeNorm.aereo.dPrevAereo)
  else
    LTexto := '';
  x1 := x + 53;
  y1 := y - 25;
  LPDF.TextBox(x1, y1, 45, 4, LTexto, 'T', 'L', False);

  //Natureza da Carga
  LPDF.SetFont(8, 'B');
  x1 := x + 98;
  y1 := y - 28;
  LTexto := 'NATUREZA DA CARGA';
  LPDF.TextBox(x1, y1, 43, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');

  //Dimensão
  LPDF.SetFont(8, 'B');
  LTexto := 'DIMENSÃO';
  x1 := x + 141;
  y1 := y - 28;
  LPDF.TextBox(x1, y1, 19, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.aereo.natCarga.xDime;
  x1 := x + 141;
  y1 := y - 25;
  LPDF.TextBox(x1, y1, 19, 4, LTexto, 'T', 'L', False);

  //Informações do Manuseio
  LPDF.SetFont(8, 'B');
  LTexto := 'INFO. DE MANUSEIO';
  x1 := x + 160;
  y1 := y - 28;
  LPDF.TextBox(x1, y1, 44, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := '';
  for i := 0 to Pred(LCTE.infCTeNorm.aereo.natCarga.cinfManu.Count) do
  begin
    LTexto := TpInfManuToStr(LCTE.infCTeNorm.aereo.natCarga.cinfManu[i].nInfManu);
  end;
  x1 := x + 160;
  y1 := y - 25;
  LPDF.TextBox(x1, y1, 44, 4, LTexto, 'T', 'L', False);
end;

procedure TBlocoModalAereoCTe.OnInit(Args: TFPDFBandInitArgs);
begin
  Height := 1;
end;

{ TBlocoModalFerroviarioCTe }

constructor TBlocoModalFerroviarioCTe.Create(ACTeUtils: TCTeUtilsFPDF);
begin
  inherited Create(btData);
  FCTeUtils := ACTeUtils;
end;

procedure TBlocoModalFerroviarioCTe.OnDraw(Args: TFPDFBandDrawArgs);
var
  LPDF: IFPDF;
  LCTE: TCTe;
  x, y: double;
  x1, y1: double;
  i: integer;
  LTexto: string;

begin
  inherited OnDraw(Args);

  LPDF := Args.PDF;
  LCTE := FCTeUtils.CTe;

  //Posição Inicial
  x := 0;
  y := 69;

  //Informações Específicas do modal Ferroviário
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 46;
  LTexto := 'INFORMAÇÕES ESPECÍFICAS DO MODAL FERROVIÁRIO';
  LPDF.TextBox(x1, y1, 208, 4, LTexto, 'T', 'C', False);
  LPDF.SetFont(8, 'B');

  //Tipo de Trafego
  LPDF.SetFont(8, 'B');
  x1 := x;
  y1 := y - 42;
  LTexto := 'TIPO DE TRÁFEGO';
  LPDF.TextBox(x1, y1, 42, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := TpTrafegoToStr(LCTE.infCTeNorm.ferrov.tpTraf);
  x1 := x;
  y1 := y - 39;
  LPDF.TextBox(x1, y1, 42, 4, LTexto, 'T', 'L', False);

  //Fluxo Ferroviário
  LPDF.SetFont(8, 'B');
  x1 := x + 42;
  y1 := y - 42;
  LTexto := 'FLUXO FERROVIÁRIO';
  LPDF.TextBox(x1, y1, 41, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := LCTE.infCTeNorm.ferrov.fluxo;
  x1 := x + 42;
  y1 := y - 39;
  LPDF.TextBox(x1, y1, 41, 4, LTexto, 'T', 'L', False);

  //Ferrovia Responsável pelo Faturamento
  LPDF.SetFont(8, 'B');
  x1 := x + 83;
  y1 := y - 42;
  LTexto := 'FERROVIA RESP. PELO FAT.';
  LPDF.TextBox(x1, y1, 41, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := TrafegoMutuoToStr(LCTE.infCTeNorm.ferrov.trafMut.respFat);
  x1 := x + 83;
  y1 := y - 39;
  LPDF.TextBox(x1, y1, 41, 4, LTexto, 'T', 'L', False);

  //Ferrovia Emitente do CT-E
  LPDF.SetFont(8, 'B');
  x1 := x + 124;
  y1 := y - 42;
  LTexto := 'FERROVIA EMIT. DO CT-E';
  LPDF.TextBox(x1, y1, 41, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := TrafegoMutuoToStr(LCTE.infCTeNorm.ferrov.trafMut.ferrEmi);
  x1 := x + 125;
  y1 := y - 39;
  LPDF.TextBox(x1, y1, 41, 4, LTexto, 'T', 'L', False);

  //Valor do Frete
  LPDF.SetFont(8, 'B');
  x1 := x + 165;
  y1 := y - 42;
  LTexto := 'VALOR DO FRETE';
  LPDF.TextBox(x1, y1, 39, 7, LTexto, 'T', 'L', True);
  LPDF.SetFont(8, '');
  LTexto := 'R$' + FormatFloat('#,0.00', LCTE.infCTeNorm.ferrov.vFrete);
  x1 := x + 165;
  y1 := y - 39;
  LPDF.TextBox(x1, y1, 39, 4, LTexto, 'T', 'L', False);

  //Informações das Ferrovias envolvidas
  LPDF.SetFont(8, 'B');

  y1 := y - 35;
  LTexto := 'INFORMAÇÕES DAS FERROVIAS ENVOLVIDAS';
  LPDF.TextBox(x1, y1, 208, 4, LTexto, 'T', 'C', False);
  for I := 0 to 1 do
  begin
    //CNPJ
    LPDF.SetFont(8, 'B');
    if I = 1 then
      x := x + 102;
    x1 := x;
    y1 := y - 31;
    LTexto := 'CNPJ';
    LPDF.TextBox(x1, y1, 40, 7, LTexto, 'T', 'L', True);
    LPDF.SetFont(8, '');
    LTexto := '';
    if (I = 1) and (LCTE.infCTeNorm.ferrov.ferroEnv.Count > 1) then
      LTexto := LCTE.infCTeNorm.ferrov.ferroEnv.Items[1].cInt
    else
    if (I = 0) and (LCTE.infCTeNorm.ferrov.ferroEnv.Count > 0) then
      LTexto := LCTE.infCTeNorm.ferrov.ferroEnv.Items[0].CNPJ;
    x1 := x;
    y1 := y - 28;
    LPDF.TextBox(x1, y1, 40, 4, LTexto, 'T', 'L', False);

    //IE
    LPDF.SetFont(8, 'B');
    x1 := x;
    y1 := y - 24;
    LTexto := 'IE';
    LPDF.TextBox(x1, y1, 40, 7, LTexto, 'T', 'L', True);
    LPDF.SetFont(8, '');
    LTexto := '';
    if (I = 1) and (LCTE.infCTeNorm.ferrov.ferroEnv.Count > 1) then
      LTexto := LCTE.infCTeNorm.ferrov.ferroEnv.Items[1].cInt
    else
    if (I = 0) and (LCTE.infCTeNorm.ferrov.ferroEnv.Count > 0) then
      LTexto := LCTE.infCTeNorm.ferrov.ferroEnv.Items[0].IE;
    x1 := x;
    y1 := y - 21;
    LPDF.TextBox(x1, y1, 40, 4, LTexto, 'T', 'L', False);

    //Código Interno
    LPDF.SetFont(8, 'B');
    x1 := x + 40;
    y1 := y - 31;
    LTexto := 'COD. INTERNO';
    LPDF.TextBox(x1, y1, 62, 7, LTexto, 'T', 'L', True);
    LPDF.SetFont(8, '');
    LTexto := '';
    if (I = 1) and (LCTE.infCTeNorm.ferrov.ferroEnv.Count > 1) then
      LTexto := LCTE.infCTeNorm.ferrov.ferroEnv.Items[1].cInt
    else
    if (I = 0) and (LCTE.infCTeNorm.ferrov.ferroEnv.Count > 0) then
      LTexto := LCTE.infCTeNorm.ferrov.ferroEnv.Items[0].cInt;

    x1 := x + 40;
    y1 := y - 28;
    LPDF.TextBox(x1, y1, 62, 4, LTexto, 'T', 'L', False);

    //Razão Social
    LPDF.SetFont(8, 'B');
    x1 := x + 40;
    y1 := y - 24;
    LTexto := 'RAZÃO SOCIAL';
    LPDF.TextBox(x1, y1, 62, 7, LTexto, 'T', 'L', True);
    LPDF.SetFont(8, '');
    LTexto := '';
    if (I = 1) and (LCTE.infCTeNorm.ferrov.ferroEnv.Count > 1) then
      LTexto := LCTE.infCTeNorm.ferrov.ferroEnv.Items[1].cInt
    else
    if (I = 0) and (LCTE.infCTeNorm.ferrov.ferroEnv.Count > 0) then
      LTexto := LCTE.infCTeNorm.ferrov.ferroEnv.Items[0].xNome;

    x1 := x + 40;
    y1 := y - 21;
    LPDF.TextBox(x1, y1, 62, 4, LTexto, 'T', 'L', False);
  end;
end;

procedure TBlocoModalFerroviarioCTe.OnInit(Args: TFPDFBandInitArgs);
begin
  Height := 1;
end;

end.

