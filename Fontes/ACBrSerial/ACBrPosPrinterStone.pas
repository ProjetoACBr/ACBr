{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrPosPrinterStone;

interface

uses
  Classes, SysUtils, Types, NetEncoding,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$Else}
   Contnrs,
  {$IfEnd}
  {$IfDef ANDROID}
   System.Messaging,
   Androidapi.JNI.Media, Androidapi.JNI.GraphicsContentViewText,
  {$EndIf}
{$IFNDEF FMX}
  Vcl.Graphics, Vcl.Printers, Vcl.Forms,
{$ELSE}
  FMX.Printer, FMX.Graphics, FMX.Types, FMX.Surfaces, FMX.Platform,
{$ENDIF}
  ACBrDevice, ACBrPosPrinter, ACBrBase, ACBrImage, ACBrDelphiZXingQRCode, AJBarcode;

const
  CmodPrintText = 'text';
  CmodPrintLine = 'line';
  CmodPrintImage = 'image';

  CColunasImpressoraSmartPosStone = 32;
  cTimeoutResp = 5000; // 5 seg
  CRequestCodeImpressora = 30;

  //Impressão
  URI_HostPrint = 'print';
  URI_SchemePrint = 'printer-app';
  URI_AuthorityPrint = 'print';

type

  EACBrPosPrinterStone = class(Exception);

  {$IfDef ANDROID}
   TACBrPosPrinterStoneErroMsg = procedure(const MsgErro: string) of object;
  {$EndIf}

  { TStoneJsonImp }

  TStoneJsonImp = class(TObjectList{$IfDef HAS_SYSTEM_GENERICS}<TACBrInformacoes>{$EndIf})
  private
    function GetItem(Index: Integer): TACBrInformacoes;
    procedure SetItem(Index: Integer; const Value: TACBrInformacoes);
  public
    function Add (Obj: TACBrInformacoes): Integer;
    procedure Insert (Index: Integer; Obj: TACBrInformacoes);
    function New: TACBrInformacoes;
    function GetJSON: String;

    property Items[Index: Integer]: TACBrInformacoes read GetItem write SetItem; default;
  end;

  TStonePrinters = (prnSmartPOS);

  { TACBrPosPrinterStone }

  TACBrPosPrinterStone = class(TACBrPosPrinterClass)
  private
    fStoneJsonImp: TStoneJsonImp;
    fModelo: TStonePrinters;
    fPastaEntradaStone: String;
    fPastaSaidaStone: String;
    fSeqArqStone: Integer;
    fIPePortaStone: String;
    fREspostaStone: String;
    fPrinting: Boolean;
    fDestroyAfter: Boolean;
    fScheme: String;

    {$IfDef ANDROID}
     fMessageSubscriptionID: Integer;
     fOnErroImpressao: TACBrPosPrinterStoneErroMsg;
    {$EndIf}
  protected
    procedure Imprimir(const LinhasImpressao: String; var Tratado: Boolean);

    {$IfDef ANDROID}
     procedure EnviarPorIntent(const LinhasImpressao: String);
     procedure HandleActivityMessage(const Sender: TObject; const M: TMessage);
    {$Else}
     procedure EnviarPorTCP(const LinhasImpressao: String);
     procedure EnviarPorTXT(const LinhasImpressao: String);
    {$EndIf}

    procedure AddCmdAbreConexaoImpressora;
    procedure AddCmdFechaConexaoImpressora;
    procedure AddCmdImprimirTexto(const ConteudoBloco: String);
    procedure AddCmdImprimirQrCode(const ConteudoBloco: String; const Tamanho: Integer; const NivelCorrecao: Integer);
    procedure AddCmdImprimirImagem(const ConteudoBloco: String; const Scala: Integer);
    procedure AddCmdImprimirBarras(const ConteudoBloco: String; const Tipo: Integer; const Altura: Integer; const LarguraLinha: Integer; const HRI: Integer);
    procedure AddCmdPuloDeLinhas(const Linhas: Integer);
  public
    constructor Create(AOwner: TACBrPosPrinter; aScheme: String);
    destructor Destroy; override;

    procedure Configurar; override;

    procedure AntesDecodificar(var ABinaryString: AnsiString); override;
    procedure AdicionarBlocoResposta(const ConteudoBloco: AnsiString); override;
    procedure DepoisDecodificar(var ABinaryString: AnsiString); override;
    function TraduzirTag(const ATag: AnsiString; var TagTraduzida: AnsiString): Boolean;
      override;
    function TraduzirTagBloco(const ATag, ConteudoBloco: AnsiString;
      var BlocoTraduzido: AnsiString): Boolean; override;

    function ComandoFonte(TipoFonte: TACBrPosTipoFonte; Ligar: Boolean): AnsiString;
      override;
    function ComandoConfiguraModoPagina: AnsiString; override;
    function ComandoPosicionaModoPagina(APoint: TPoint): AnsiString; override;

    procedure LerStatus(var AStatus: TACBrPosPrinterStatus); override;
    function LerInfo: String; override;

    procedure DestroyAfterPrint;

    property StoneJsonImp: TStoneJsonImp read fStoneJsonImp;
    property Modelo: TStonePrinters read fModelo write fModelo;
    property PastaEntradaStone: String read fPastaEntradaStone write fPastaEntradaStone;
    property PastaSaidaStone: String read fPastaSaidaStone write fPastaSaidaStone;
    property IPePortaStone: String read fIPePortaStone write fIPePortaStone;
    property REspostaStone: string read fREspostaStone;
    {$IfDef ANDROID}
     property OnErroImpressao: TACBrPosPrinterStoneErroMsg read fOnErroImpressao write fOnErroImpressao;
    {$EndIf}
  end;

implementation

uses
  StrUtils, Math, DateUtils,
  System.IOUtils,
  {$IfDef ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.App,
  Androidapi.JNI.Net,
  FMX.Platform.Android,
  {$Else}
   blcksock,
  {$EndIf}
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
    JsonDataObjects_ACBr,
  {$Else}
    Jsons,
  {$EndIf}
  ACBrUtil.Base,
  ACBrUtil.FilesIO,
  ACBrUtil.Strings,
  ACBrUtil.Math,
  ACBrConsts;

{ TACBrPosPrinterStone }

constructor TACBrPosPrinterStone.Create(AOwner: TACBrPosPrinter; aScheme: String);
begin
  inherited Create(AOwner);

  fStoneJsonImp := TStoneJsonImp.Create;
  fpModeloStr := 'PosPrinterStone';
  fModelo := prnSmartPOS;
  fPastaEntradaStone := '';
  fPastaSaidaStone := '';
  fIPePortaStone := '';
  fREspostaStone := '';
  fSeqArqStone := 0;
  fPrinting := False;
  fDestroyAfter := False;

  fScheme:= aScheme;

  TagsNaoSuportadas.Add( cTagBarraMSI );
  TagsNaoSuportadas.Add( cTagLigaNegrito );
  TagsNaoSuportadas.Add( cTagDesligaNegrito );
  TagsNaoSuportadas.Add( cTagLigaItalico );
  TagsNaoSuportadas.Add( cTagDesligaItalico );
  TagsNaoSuportadas.Add( cTagLigaSublinhado );
  TagsNaoSuportadas.Add( cTagDesligaSublinhado );
  TagsNaoSuportadas.Add( cTagLigaAlturaDupla );
  TagsNaoSuportadas.Add( cTagDesligaAlturaDupla );
  TagsNaoSuportadas.Add( cTagLigaInvertido );
  TagsNaoSuportadas.Add( cTagDesligaInvertido );
  TagsNaoSuportadas.Add( '<fa>' );
  TagsNaoSuportadas.Add( cTagFonteA );
  TagsNaoSuportadas.Add( '<fb>' );
  TagsNaoSuportadas.Add( cTagFonteB );

  {$IfDef ANDROID}
  fMessageSubscriptionID := 0;
  fOnErroImpressao := Nil;
  {$EndIf}
end;

destructor TACBrPosPrinterStone.Destroy;
begin
  fStoneJsonImp.Free;

  inherited Destroy;
end;

procedure TACBrPosPrinterStone.DestroyAfterPrint;
begin
  if not fPrinting then
    Self.Destroy
  else
    fDestroyAfter:= True;
end;

procedure TACBrPosPrinterStone.Configurar;
begin
  //fpPosPrinter.PaginaDeCodigo := pcNone;
  fpPosPrinter.Porta := 'NULL';
  Cmd.Clear;
  fpPosPrinter.OnEnviarStringDevice := Imprimir;
end;

procedure TACBrPosPrinterStone.AntesDecodificar(var ABinaryString: AnsiString);
begin
  // Troca todos Pulo de Linha, por Tag, para conseguir pegar os Blocos de impressão em TagProcessos
  ABinaryString := StringReplace(ABinaryString, Cmd.PuloDeLinha, cTagPulodeLinha, [rfReplaceAll]);
  AddCmdAbreConexaoImpressora;
end;

procedure TACBrPosPrinterStone.AdicionarBlocoResposta(
  const ConteudoBloco: AnsiString);
begin
  AddCmdImprimirTexto(ConteudoBloco);
end;

procedure TACBrPosPrinterStone.DepoisDecodificar(var ABinaryString: AnsiString);
begin
  AddCmdFechaConexaoImpressora;
  ABinaryString := fStoneJsonImp.GetJSON;
end;

function TACBrPosPrinterStone.TraduzirTag(const ATag: AnsiString;
  var TagTraduzida: AnsiString): Boolean;
begin
  TagTraduzida := '';

  if ((ATag = cTagZera) or (ATag = cTagReset)) then
  begin
    if not (fModelo in [prnSmartPOS]) then
    begin

    end;
  end

  else if ATag = cTagPuloDeLinhas then
  begin
    AddCmdPuloDeLinhas(fpPosPrinter.LinhasEntreCupons);
    Result := True;
  end

  else if ((ATag = cTagCorteParcial) or ( (ATag = cTagCorte) and (fpPosPrinter.TipoCorte = ctParcial) )) or
          ((ATag = cTagCorteTotal) or ( (ATag = cTagCorte) and (fpPosPrinter.TipoCorte = ctTotal) ) ) then
  begin
    AddCmdPuloDeLinhas(fpPosPrinter.LinhasEntreCupons);

    if fpPosPrinter.CortaPapel and (fModelo <> prnSmartPOS) then
    begin

    end;

    Result := True;
  end

  else if ATag = cTagAbreGaveta then
  begin
    if (fModelo <> prnSmartPOS)  then
    begin

    end;

    Result := True;
  end

  else if ATag = cTagBeep then
  begin
    if not (fModelo in [prnSmartPOS])  then
    begin

    end
    {$IfDef ANDROID}
    else
      // https://stackoverflow.com/questions/30938946/how-do-i-make-a-beep-sound-in-android-using-delphi-and-the-api
      TJToneGenerator.JavaClass.init( TJAudioManager.JavaClass.ERROR,
                                      TJToneGenerator.JavaClass.MAX_VOLUME)
        .startTone( TJToneGenerator.JavaClass.TONE_DTMF_0, 200 )
    {$EndIf};
    Result := True;
  end

  else if ATag = cTagLogotipo then
  begin
    if not fpPosPrinter.ConfigLogo.IgnorarLogo then
    begin
      //Logo armazenado
    end;
    Result := True;
  end

  else if ATag = cTagPulodeLinha then
  begin
//    AddCmdPuloDeLinhas(1);
    Result := True;
  end

  else if ATag = cTagModoPaginaLiga then
  begin

  end else if ATag = cTagModoPaginaDesliga then
  begin

  end

  else if ATag = cTagModoPaginaImprimir then
  begin
    Result := True;
  end else
    Result := False;
end;

function TACBrPosPrinterStone.TraduzirTagBloco(const ATag,
  ConteudoBloco: AnsiString; var BlocoTraduzido: AnsiString): Boolean;
var
  tipoCodBarras: Integer;
  ACodBar: AnsiString;
begin
  if ATag = cTagAbreGavetaEsp then
  begin
    Result := True;
  end

  else if ATag = cTagQRCode then
  begin
    AddCmdImprimirQrCode(ConteudoBloco, max(min(fpPosPrinter.ConfigQRCode.LarguraModulo, 6), 1), max(min(fpPosPrinter.ConfigQRCode.ErrorLevel, 4), 1));

    Result := True;
  end

  else if ATag = cTagBMP then
  begin
    if FileExists(ConteudoBloco) then
    begin
      AddCmdImprimirImagem(ConteudoBloco, fpPosPrinter.ConfigLogo.FatorX);
    end
    else
      AddCmdImprimirTexto('Arquivo não encontrado: '+ConteudoBloco);

    Result := True;
  end

  else if (AnsiIndexText(ATag, cTAGS_BARRAS) >= 0) then
  begin
    tipoCodBarras := -1;
    ACodBar := ConteudoBloco;
    if (ATag = cTagBarraUPCA) then
    begin
      ACodBar := AnsiString(OnlyNumber(ConteudoBloco));
      if (Length(ACodBar) < 11) then
        ACodBar := PadLeftA(ACodBar, 11, '0');
      tipoCodBarras := 0;
    end
    else if (ATag = cTagBarraUPCE) then
    begin
      ACodBar := OnlyNumber(ConteudoBloco);
      tipoCodBarras := 1;
    end
    else if ATag = cTagBarraEAN13 then
    begin
      ACodBar := AnsiString(OnlyNumber(ConteudoBloco));
      if (Length(ACodBar) < 12) then
        ACodBar := PadLeftA(ACodBar, 12, '0');
      tipoCodBarras := 2;
    end
    else if ATag = cTagBarraEAN8 then
    begin
      ACodBar := AnsiString(OnlyNumber(ConteudoBloco));
      if (Length(ACodBar) < 7) then
        ACodBar := PadLeftA(ACodBar, 7, '0');
      tipoCodBarras := 3;
    end
    else if ATag = cTagBarraCode39 then
    begin
      ACodBar := AnsiString(OnlyCharsInSet(ConteudoBloco,
        ['0'..'9', 'A'..'Z', ' ', '$', '%', '*', '+', '-', '.', '/']));
      tipoCodBarras := 4;
    end
    else if ATag = cTagBarraInter then
    begin
      // Interleaved 2of5. Somente números, Tamanho deve ser PAR
      ACodBar := AnsiString(OnlyNumber(ConteudoBloco));
      if (Length(ACodBar) mod 2) <> 0 then  // Tamanho é Par ?
        ACodBar := '0' + ACodBar;
      tipoCodBarras := 5;
    end
    else if ATag = cTagBarraCodaBar then
    begin
      // Qualquer tamanho.. Aceita: 0~9, A~D, a~d, $, +, -, ., /, :
      ACodBar := AnsiString(OnlyCharsInSet(ConteudoBloco,
        ['0'..'9', 'A'..'D', 'a'..'d', '$', '+', '-', '.', '/', ':']));
      tipoCodBarras := 6;
    end
    else if ATag = cTagBarraCode93 then
    begin
      ACodBar := AnsiString(OnlyCharsInSet(ConteudoBloco, [#0..#127]));
      tipoCodBarras := 7;
    end
    else if (ATag = cTagBarraCode128) or (ATag = cTagBarraCode128b)  then
    begin
      ACodBar := AnsiString(OnlyCharsInSet(ConteudoBloco, [#0..#127]));
      tipoCodBarras := 8;
    end
    else if (ATag = cTagBarraCode128a) then
    begin
      ACodBar := AnsiString(OnlyCharsInSet(ConteudoBloco, [#0..#127]));
      tipoCodBarras := 8;
    end
    else if (ATag = cTagBarraCode128c) then
    begin
      ACodBar := AnsiString(OnlyNumber(ConteudoBloco));
      if (Length(ACodBar) mod 2) <> 0 then  // Tamanho deve ser Par
        ACodBar := '0' + ACodBar;

      tipoCodBarras := 8;
    end;

    if tipoCodBarras >= 0 then
    begin
      AddCmdImprimirBarras(ACodBar, tipoCodBarras, IfThen(fpPosPrinter.ConfigBarras.Altura<=0, 50, max(min(fpPosPrinter.ConfigBarras.Altura, 255), 1)), IfThen(fpPosPrinter.ConfigBarras.LarguraLinha<=0, 2, max(min(fpPosPrinter.ConfigBarras.LarguraLinha, 6), 1)), IfThen(fpPosPrinter.ConfigBarras.MostrarCodigo, 2, 4));
    end
    else
      AddCmdImprimirTexto(ConteudoBloco);

    Result := True;
  end

  else
    Result := False;

  if Result then
    BlocoTraduzido := '';
end;

function TACBrPosPrinterStone.ComandoFonte(TipoFonte: TACBrPosTipoFonte;
  Ligar: Boolean): AnsiString;
begin
  Result := '';
end;

function TACBrPosPrinterStone.ComandoConfiguraModoPagina: AnsiString;
begin
  Result := '';
end;

function TACBrPosPrinterStone.ComandoPosicionaModoPagina(
  APoint: TPoint): AnsiString;
begin
  Result := '';
end;

procedure TACBrPosPrinterStone.LerStatus(var AStatus: TACBrPosPrinterStatus);
begin
  inherited;
end;

function TACBrPosPrinterStone.LerInfo: String;
begin
  Result := inherited LerInfo;
end;

procedure TACBrPosPrinterStone.AddCmdAbreConexaoImpressora;
begin
  // Limpa o objeto com o StoneJson
  fStoneJsonImp.Clear;
end;

procedure TACBrPosPrinterStone.AddCmdFechaConexaoImpressora;
begin
  //
end;

procedure TACBrPosPrinterStone.AddCmdImprimirTexto(
  const ConteudoBloco: String);
var
  align, tamanho: String;
begin
  if (ConteudoBloco <> '') then
  begin
    align:= IfThen(fpPosPrinter.Alinhamento = alDireita, 'right',
            IfThen(fpPosPrinter.Alinhamento = alCentro, 'center', 'left'));

    tamanho:= 'medium'; //ftNormal

    if ftCondensado in fpPosPrinter.FonteStatus then
      tamanho:= 'small';
    if ftExpandido in fpPosPrinter.FonteStatus then
      tamanho:= 'big';

    with fStoneJsonImp.New do
    begin
      AddField('type').AsString:=    CmodPrintText;
      AddField('content').AsString:= ConteudoBloco;
      AddField('align').AsString:=   align;
      AddField('size').AsString:=    tamanho;
    end;
  end;
end;

function Base64FromStream(Image: TMemoryStream): String;
var
  Input:  TBytesStream;
  Output: TStringStream;
  base64: TBase64Encoding;
begin
  Input:= TBytesStream.Create;
  base64:= TBase64Encoding.Create(0);

  try
    Input.LoadFromStream(Image);

    Input.Position:= 0;
    Output:= TStringStream.Create('', TEncoding.ASCII);

    try
      base64.Encode(Input, Output);
      Result:= Output.DataString;
    finally
      Output.Free;
      base64.Free;
    end;
  finally
    Input.Free;
  end;
end;

procedure TACBrPosPrinterStone.AddCmdImprimirQrCode(const ConteudoBloco: String;
  const Tamanho, NivelCorrecao: Integer);
var
  nTamanho:     Integer;
  sImagem:      String;
  BarCodeImage: TBitmap;
  QrCodeImage:  TBitmap;
  ImageStream:  TMemoryStream;
begin
  try
    BarCodeImage:= nil;
    QrCodeImage:=  nil;
    ImageStream:=  nil;

    BarCodeImage:= TBitmap.Create;

    QrCodeImage:= TBitmap.Create;
    PintarQRCode(ConteudoBloco, QrCodeImage, qrUTF8BOM);

    case Tamanho of
      1: nTamanho:= 080;
      2: nTamanho:= 120;
      3: nTamanho:= 160;
      4: nTamanho:= 200;
      5: nTamanho:= 240;
      6: nTamanho:= 280;
    end;

    BarCodeImage.Width:=  nTamanho;
    BarCodeImage.Height:= nTamanho;

{$IFNDEF FMX}
    BarCodeImage.Canvas.StretchDraw(Rect(0, 0, BarCodeImage.Width, BarCodeImage.Height), QrCodeImage);
{$ELSE}
    BarCodeImage.Canvas.BeginScene;
    BarCodeImage.Canvas.DrawBitmap(QrCodeImage, Rect(0, 0, QrCodeImage.Width, QrCodeImage.Height), Rect(0, 0, BarCodeImage.Width, BarCodeImage.Height), 1, True);
    BarCodeImage.Canvas.EndScene;
{$ENDIF}

    ImageStream:= TMemoryStream.Create;
    BarCodeImage.SaveToStream(ImageStream);

    sImagem:= Base64FromStream(ImageStream);
  finally
    if BarCodeImage <> nil then
      FreeAndNil(BarCodeImage);

    if QrCodeImage <> nil then
      FreeAndNil(QrCodeImage);

    if ImageStream <> nil then
      FreeAndNil(ImageStream);
  end;

  with fStoneJsonImp.New do
  begin
    AddField('type').AsString:=      CmodPrintImage;
    AddField('imagePath').AsString:= sImagem;
  end;
end;

procedure TACBrPosPrinterStone.AddCmdImprimirImagem(
  const ConteudoBloco: String; const Scala: Integer);
var
  sImagem:     String;
  ImageStream: TMemoryStream;
begin
  try
    ImageStream:= TMemoryStream.Create;
    ImageStream.LoadFromFile(ConteudoBloco);

    sImagem:= Base64FromStream(ImageStream);
  finally
    if ImageStream <> nil then
      FreeAndNil(ImageStream);
  end;

  with fStoneJsonImp.New do
  begin
    AddField('type').AsString:=      CmodPrintImage;
    AddField('imagePath').AsString:= sImagem;
  end;
end;

procedure TACBrPosPrinterStone.AddCmdImprimirBarras(const ConteudoBloco: String;
  const Tipo, Altura, LarguraLinha, HRI: Integer);
var
  sImagem:      String;
  Barcode1:     TAsBarcode;
  BarCodeImage: TBitmap;
  ImageStream:  TMemoryStream;
begin
  try
    Barcode1:=     nil;
    BarCodeImage:= nil;
    ImageStream:=  nil;

    Barcode1:= TAsBarcode.Create(nil);
    Barcode1.Height:= Altura;
    Barcode1.Modul:= 2;

    case Tipo of
      0: Barcode1.Typ:= bcCodeUPC_A;
      1: Barcode1.Typ:= bcCodeUPC_E0;
      2: Barcode1.Typ:= bcCodeEAN13;
      3: Barcode1.Typ:= bcCodeEAN8;
      4: Barcode1.Typ:= bcCode39;
      5: Barcode1.Typ:= bcCode_2_5_interleaved;
      6: Barcode1.Typ:= bcCodeCodabar;
      7: Barcode1.Typ:= bcCode93;
      8: Barcode1.Typ:= bcCode128A;
    end;

    BarCodeImage:= TBitmap.Create;

    Barcode1.Text:= ConteudoBloco;
    Barcode1.Ratio:= LarguraLinha;

    if HRI = 2 then
    begin
      Barcode1.ShowText:= bcoCode;
      Barcode1.ShowTextPosition:= stpBottomCenter;
    end;

    BarCodeImage.Height:= Barcode1.CanvasHeight;
    BarCodeImage.Width:=  Barcode1.CanvasWidth;
    Barcode1.DrawBarcode(BarCodeImage.Canvas);

    ImageStream:= TMemoryStream.Create;
    BarCodeImage.SaveToStream(ImageStream);

    sImagem:= Base64FromStream(ImageStream);
  finally
    if Barcode1 <> nil then
      FreeAndNil(Barcode1);

    if BarCodeImage <> nil then
      FreeAndNil(BarCodeImage);

    if ImageStream <> nil then
      FreeAndNil(ImageStream);
  end;

  with fStoneJsonImp.New do
  begin
    AddField('type').AsString:=      CmodPrintImage;
    AddField('imagePath').AsString:= sImagem;
  end;
end;

procedure TACBrPosPrinterStone.AddCmdPuloDeLinhas(const Linhas: Integer);
var
  I: Integer;
  tamanho: Integer;
begin
  tamanho:= 32; //ftNormal

  if ftCondensado in fpPosPrinter.FonteStatus then
    tamanho:= 42;
  if ftExpandido in fpPosPrinter.FonteStatus then
    tamanho:= 24;

  for I:= 1 to Linhas do
    AddCmdImprimirTexto(StringOfChar(' ', tamanho));
end;

procedure TACBrPosPrinterStone.Imprimir(const LinhasImpressao: String;
  var Tratado: Boolean);
var
  I: Integer;
begin
  Tratado := True;
  fREspostaStone := '';
  fPrinting:= True;

  {$IfNDef ANDROID}
  if (fIPePortaStone <> '') then
    EnviarPorTCP(fStoneJsonImp.GetJSON)
  else
    EnviarPorTXT(fStoneJsonImp.GetJSON);

  fPrinting:= False;
  {$ELSE}
  EnviarPorIntent(fStoneJsonImp.GetJSON);
  {$ENDIF}
end;

{$IfDef ANDROID}
procedure TACBrPosPrinterStone.EnviarPorIntent(const LinhasImpressao: String);
var
  fUriDados:   String;
  intentPrint: JIntent;
  fUriEnvio:   TACBrURI;
begin
  fUriEnvio:= TACBrURI.Create(URI_SchemePrint, URI_AuthorityPrint, '');

  fUriEnvio.Params.AddField('SHOW_FEEDBACK_SCREEN').AsString:= 'true';
  fUriEnvio.Params.AddField('SCHEME_RETURN').AsString:=        Self.fScheme;
  fUriEnvio.Params.AddField('PRINTABLE_CONTENT').AsString:=    LinhasImpressao;

  fUriDados:= fUriEnvio.URI;

  MainActivity.registerIntentAction(TJIntent.JavaClass.ACTION_VIEW);
  fMessageSubscriptionID:= TMessageManager.DefaultManager.SubscribeToMessage(TMessageReceivedNotification, HandleActivityMessage);

  intentPrint:= TJIntent.Create;

  intentPrint.setAction(TJIntent.JavaClass.ACTION_VIEW);
  intentPrint.addFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
  intentPrint.setData(TJnet_Uri.JavaClass.parse(StringToJString(fUriDados)));

  try
    if MainActivity.getPackageManager.queryIntentActivities(intentPrint, TJPackageManager.JavaClass.MATCH_DEFAULT_ONLY).size > 0 then
      MainActivity.startActivity(intentPrint)
    else begin
      TMessageManager.DefaultManager.Unsubscribe(TMessageReceivedNotification, fMessageSubscriptionID);
      fMessageSubscriptionID := 0;
    end;
  except on E: Exception do
    begin
      TMessageManager.DefaultManager.Unsubscribe(TMessageReceivedNotification, fMessageSubscriptionID);
      fMessageSubscriptionID := 0;

      if Assigned(fOnErroImpressao) then
      begin
        fOnErroImpressao('Erro na impressão.' + sLineBreak + E.Message);
      end;
    end;
  end;
end;

procedure TACBrPosPrinterStone.HandleActivityMessage(const Sender: TObject; const M: TMessage);
var
  jsRetorno: JString;
begin
  if M is TMessageReceivedNotification then
  begin
    TMessageManager.DefaultManager.Unsubscribe(TMessageReceivedNotification, fMessageSubscriptionID);
    fMessageSubscriptionID := 0;

    try
      if TMessageReceivedNotification(M).Value <> nil then
      begin
        jsRetorno:= TMessageReceivedNotification(M).Value.getDataString;

        if jsRetorno <> nil then
        begin
          fPrinting:= False;

          if fDestroyAfter then
            Self.Destroy;
        end;
      end;
    except on E: Exception do
      if Assigned(fOnErroImpressao) then
      begin
        fOnErroImpressao('Erro na impressão.' + sLineBreak + E.Message);
      end;
    end;
  end;
end;

{$Else}
procedure TACBrPosPrinterStone.EnviarPorTCP(const LinhasImpressao: String);
 var
   ASocket: TBlockSocket;
   IP, Porta: String;
   Resp: AnsiString;
   p: Integer;
 begin
   fREspostaStone := '';
   ASocket := TBlockSocket.Create;
   try
     IP := fIPePortaStone;
     p := pos(':',IP);
     if (p=0) then
       Porta := '89'
     else
     begin
       Porta := Copy(IP, P+1, Length(IP));
       IP := copy(IP, 1, P-1);
     end;

     ASocket.Connect(IP, Porta);
     ASocket.SendString(LinhasImpressao);
     Resp := ASocket.RecvPacket(cTimeoutResp);
     if (ASocket.LastError = 0) then
     begin
       fREspostaStone := StringReplace(Resp, LF+'}'+LF+'{', ',', [rfReplaceAll]);
       //DEBUG
       //WriteToFile('c:\temp\E1JsonResp.txt', fREspostaE1);
     end;
   finally
     ASocket.Free;
   end;
end;

procedure TACBrPosPrinterStone.EnviarPorTXT(const LinhasImpressao: String);
 var
   ArqIN, ArqOUT: String;
   TempoLimite: TDateTime;
   SL: TStringList;
   Ok: Boolean;
 begin
   inc(fSeqArqStone);
   if fSeqArqStone > 999 then
     fSeqArqStone := 1;

   if (fPastaEntradaStone = '') then
      ArqIN := ApplicationPath + 'Stone'+PathDelim+'pathIN'
    else
      ArqIN := fPastaEntradaStone;
   ArqIN := PathWithDelim(ArqIN) + 'Comando' + IntToStrZero(fSeqArqStone, 3) + '.txt';

   if (fPastaSaidaStone = '') then
      ArqOUT := ApplicationPath + 'Stone'+PathDelim+'pathOUT'
    else
      ArqOUT := fPastaSaidaStone;
   ArqOUT := PathWithDelim(ArqOUT) + 'Comando' + IntToStrZero(fSeqArqStone, 3) + '*.txt';

   WriteToFile(ArqIN, LinhasImpressao);
   Exit;

   Ok := False;
   TempoLimite  := IncMilliSecond(Now, cTimeoutResp);
   SL := TStringList.Create;
   try
     while (Now < TempoLimite) do
     begin
       FindFiles(ArqOUT, SL);
       if (SL.Count > 0) then
       begin
         ArqOUT := SL[0];
         SL.Clear;
         SL.LoadFromFile(ArqOUT);
         fREspostaStone := SL.Text;
         SysUtils.DeleteFile(ArqOUT);
         Ok := True;
         Break;
       end;

//       Sleep(200);
     end;
   finally
     SL.Free;
   end;

//   if (not Ok) then
//     raise EACBrPosPrinterStone.Create('TimeOut');
end;
{$EndIf}

{ TStoneJsonImp }

function TStoneJsonImp.GetItem(Index: Integer): TACBrInformacoes;
begin
  Result := TACBrInformacoes(inherited Items[Index]);
end;

procedure TStoneJsonImp.SetItem(Index: Integer; const Value: TACBrInformacoes);
begin
  inherited Items[Index] := Value;
end;

function TStoneJsonImp.Add(Obj: TACBrInformacoes): Integer;
begin
  Result := inherited Add(Obj);
end;

procedure TStoneJsonImp.Insert(Index: Integer; Obj: TACBrInformacoes);
begin
  inherited Insert(Index, Obj);
end;

function TStoneJsonImp.New: TACBrInformacoes;
begin
  Result := TACBrInformacoes.Create;
  inherited Add(Result);
end;

function TStoneJsonImp.GetJSON: String;
var
  i, j: Integer;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon: TJsonArray;
   JSContent: TJsonObject;
  {$Else}
   AJSon: TJson;
   JSComandos, JSParametros: TJsonArray;
   JSParamPair: TJsonPair;
   JSParametro: TJsonValue;
  {$EndIf}
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon := TJsonArray.Create;
   try
     for i := 0 to Count-1 do
     begin
       JSContent:= AJSon.AddObject;

       for j := 0 to Items[i].Count-1 do
       begin
         case Items[i].Items[j].Tipo of
           tiBoolean:
             JSContent.B[ Items[i].Items[j].Nome ] := Items[i].Items[j].AsBoolean;
           tiFloat:
             JSContent.F[ Items[i].Items[j].Nome ] := Items[i].Items[j].AsFloat;
           tiInteger, tiInt64:
             JSContent.I[ Items[i].Items[j].Nome ] := Items[i].Items[j].AsInteger;
         else
           JSContent.S[ Items[i].Items[j].Nome ] := Items[i].Items[j].AsString;
         end;
       end;
     end;

     Result := AJSon.ToString;
   finally
     AJSon.Free;
   end;
  {$Else}
   AJSon := TJson.Create;
   try
     AJSon[CnModulo].AsString := FModulo;
     JSComandos := AJSon[CnComando].AsArray;

     for i := 0 to FComandos.Count-1 do
     begin
       JSComando := JSComandos.Add.AsObject;
       JSComando[CnFuncao].AsString := FComandos[i].Funcao;
       if FComandos[i].Parametros.Count > 0 then
       begin
         JSParametros := JSComando[CnParametros].AsArray;
         JSParametro := JSParametros.Add;

         for j := 0 to FComandos[i].Parametros.Count-1 do
         begin
           JSParamPair := JSParametro.AsObject.Add( FComandos[i].Parametros.Items[j].Nome);

           case FComandos[i].Parametros.Items[j].Tipo of
             tiBoolean:
               JSParamPair.Value.AsBoolean := FComandos[i].Parametros.Items[j].AsBoolean;
             tiFloat:
               JSParamPair.Value.AsNumber := FComandos[i].Parametros.Items[j].AsFloat;
             tiInteger, tiInt64:
               JSParamPair.Value.AsInteger := FComandos[i].Parametros.Items[j].AsInteger;
           else
              JSParamPair.Value.AsString := FComandos[i].Parametros.Items[j].AsString;
           end;
         end;
       end;
     end;

     Result := AJSon.Stringify;
   finally
     AJSon.Free;
   end;
  {$EndIf}
end;

end.
