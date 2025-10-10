{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrNFSeDANFSeFR;

interface

uses
  SysUtils, Classes,
  ACBrBase, ACBrNFSeDANFSeClass, pnfsNFSe, pnfsConversao, pcnauxiliar, frxClass,
  DB, DBClient, frxDBSet, frxExportPDF, frxBarcode, ACBrValidador;

type
  EACBrNFSeDANFSeFR = class(Exception);
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNFSeDANFSeFR = class(TACBrNFSeDANFSeClass)
  private
    FFastFile        : String;
    FEspessuraBorda  : Integer;
    FDANFSeClassOwner: TACBrNFSeDANFSeClass;
    function GetPreparedReport: TfrxReport;
    function PrepareReport(ANFSe: TNFSe = nil): Boolean;
    procedure CriarDataSetsFrx;
    procedure CarregaDados(ANFSe: TNFSe);
    procedure CarregaIdentificacao(ANFSe: TNFSe);
    procedure CarregaItensServico(ANFSe: TNFSe);
    procedure CarregaParametros(ANFSe: TNFSe);
    procedure CarregaPrestador(ANFSe: TNFSe);
    procedure CarregaServicos(ANFSe: TNFSe);
    procedure CarregaTomador(ANFSe: TNFSe);
    procedure CarregaTransortadora(ANFSe: TNFSe);
    procedure CarregaLogoPrefeitura;
    procedure CarregaImagemPrestadora;

    function ManterDocumento(const sCpfCnpj: String): string;
    procedure frxReportBeforePrint(Sender: TfrxReportComponent);
		procedure SetDataSetsToFrxReport;
    procedure AjustaMargensReports;
  public
    frxReport   : TfrxReport; // Est� como public, pois quando declarado em datamodule, tem acesso externo, e pode ser que alguem esteja usando.
    frxPDFExport: TfrxPDFExport;
    // CDSs
    cdsIdentificacao: TClientDataSet;
    cdsPrestador    : TClientDataSet;
    cdsServicos     : TClientDataSet;
    cdsParametros   : TClientDataSet;
    cdsTomador      : TClientDataSet;
	  cdsTransportadora : TClientDataSet;
    cdsItensServico : TClientDataSet;

    // FrxDBs
    frxIdentificacao: TfrxDBDataset;
    frxPrestador    : TfrxDBDataset;
    frxTomador      : TfrxDBDataset;
    frxTransportadora: TfrxDBDataset;
    frxServicos     : TfrxDBDataset;
    frxParametros   : TfrxDBDataset;
    frxItensServico : TfrxDBDataset;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirDANFSe(NFSe: TNFSe = nil); override;
    procedure ImprimirDANFSePDF(NFSe: TNFSe = nil); override;

    property DANFSeClassOwner: TACBrNFSeDANFSeClass read FDANFSeClassOwner;
  published
    property FastFile      : String read FFastFile write FFastFile;
    property EspessuraBorda: Integer read FEspessuraBorda write FEspessuraBorda;
    property PreparedReport: TfrxReport read GetPreparedReport;
  end;

implementation

uses
  ACBrNFSe,
  ACBrUtil.Base,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  StrUtils, ACBrDFeUtil, Math;

constructor TACBrNFSeDANFSeFR.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDANFSeClassOwner := TACBrNFSeDANFSeClass(Self);
  FFastFile         := '';
  FEspessuraBorda   := 1;

  CriarDataSetsFrx;
end;

destructor TACBrNFSeDANFSeFR.Destroy;
begin
  frxIdentificacao.Free;
  frxPrestador.Free;
  frxTomador.Free;
  frxTransportadora.Free;
  frxServicos.Free;
  frxParametros.Free;
  frxItensServico.Free;

  cdsIdentificacao.Free;
  cdsPrestador.Free;
  cdsServicos.Free;
  cdsParametros.Free;
  cdsTomador.Free;
  cdsTransportadora.Free;
  cdsItensServico.Free;

  frxReport.Free;
  frxPDFExport.Free;

  inherited Destroy;
end;

function TACBrNFSeDANFSeFR.GetPreparedReport: TfrxReport;
begin
  if Trim(FFastFile) = '' then
    Result := nil
  else
  begin
    if PrepareReport(nil) then
      Result := frxReport
    else
      Result := nil;
  end;
end;

procedure TACBrNFSeDANFSeFR.ImprimirDANFSe(NFSe: TNFSe);
begin
  if PrepareReport(NFSe) then
  begin
    if MostraPreview then
      frxReport.ShowPreparedReport
    else
      frxReport.Print;
  end;
end;

procedure TACBrNFSeDANFSeFR.ImprimirDANFSePDF(NFSe: TNFSe);
const
  TITULO_PDF = 'Nota Fiscal de Servi�o Eletr�nica';
var
  I         : Integer;
  LArquivoPDF: string;
  OldShowDialog: Boolean;
begin
  if PrepareReport(NFSe) then
  begin
    frxPDFExport.Author        := Sistema;
    frxPDFExport.Creator       := Sistema;
    frxPDFExport.Subject       := TITULO_PDF;
    frxPDFExport.EmbeddedFonts := False;
    frxPDFExport.Background    := False;

    OldShowDialog := frxPDFExport.ShowDialog;
    try
      frxPDFExport.ShowDialog := False;
      for I := 0 to TACBrNFSe(ACBrNFSe).NotasFiscais.Count - 1 do
      begin

        LArquivoPDF := Trim(DANFSEClassOwner.NomeDocumento);
        if EstaVazio(LArquivoPDF) then
          LArquivoPDF :=  TACBrNFSe(ACBrNFSe).NumID[TACBrNFSe(ACBrNFSe).NotasFiscais.Items[I].NFSe] + '-nfse.pdf';
        frxPDFExport.FileName := PathWithDelim(DANFSEClassOwner.PathPDF) + LArquivoPDF;

        if not DirectoryExists(ExtractFileDir(frxPDFExport.FileName)) then
          ForceDirectories(ExtractFileDir(frxPDFExport.FileName));

        frxReport.Export(frxPDFExport);

        FPArquivoPDF := frxPDFExport.FileName;
      end;
    finally
      frxPDFExport.ShowDialog := OldShowDialog;
    end;
  end;
end;

procedure TACBrNFSeDANFSeFR.AjustaMargensReports;
var
  Page: TfrxReportPage;
  I: Integer;
begin
  for I := 0 to (frxReport.PreviewPages.Count - 1) do
  begin
    Page := frxReport.PreviewPages.Page[I];
    if (MargemSuperior > 0) then
      Page.TopMargin := MargemSuperior;
    if (MargemInferior > 0) then
      Page.BottomMargin := MargemInferior;
    if (MargemEsquerda > 0) then
      Page.LeftMargin := MargemEsquerda;
    if (MargemDireita > 0) then
      Page.RightMargin := MargemDireita;
    frxReport.PreviewPages.ModifyPage(I, Page);
  end;
end;

procedure TACBrNFSeDANFSeFR.SetDataSetsToFrxReport;
begin
  frxReport.EnabledDataSets.Clear;
  frxReport.EnabledDataSets.Add(frxIdentificacao);
  frxReport.EnabledDataSets.Add(frxPrestador);
  frxReport.EnabledDataSets.Add(frxTomador);
  frxReport.EnabledDataSets.Add(frxTransportadora);
  frxReport.EnabledDataSets.Add(frxServicos);
  frxReport.EnabledDataSets.Add(frxParametros);
  frxReport.EnabledDataSets.Add(frxItensServico);
end;

function TACBrNFSeDANFSeFR.PrepareReport(ANFSe: TNFSe): Boolean;
var
  I: Integer;
	wProjectStream: TStringStream;
begin
  Result := False;

  SetDataSetsToFrxReport;
  if Trim(FastFile) <> '' then
  begin
    if not (uppercase(copy(FastFile,length(FastFile)-3,4))='.FR3') then
    begin
      wProjectStream:=TStringStream.Create(FastFile);
      frxReport.FileName := '';
			wProjectStream.Position := 0;
      frxReport.LoadFromStream(wProjectStream);
      wProjectStream.Free;
    end
    else
    begin
      if FileExists(FastFile) then
        frxReport.LoadFromFile(FastFile)
      else
        raise EACBrNFSeDANFSeFR.CreateFmt('Caminho do arquivo de impress�o do DANFSe "%s" inv�lido.', [FastFile]);
    end;
  end
  else
    raise EACBrNFSeDANFSeFR.Create('Caminho do arquivo de impress�o do DANFSe n�o assinalado.');

  frxReport.PrintOptions.Copies      := NumCopias;
  frxReport.PrintOptions.ShowDialog  := MostraSetup;
  frxReport.ShowProgress             := MostraStatus;
  frxReport.PreviewOptions.AllowEdit := False;

  // Define a impressora
  if NaoEstaVazio(frxReport.PrintOptions.Printer) then
    frxReport.PrintOptions.Printer := Impressora;

  if Assigned(ANFSe) then
  begin
    CarregaDados(ANFSe);
    Result := frxReport.PrepareReport;
  end
  else
  begin
    if Assigned(ACBrNFSe) then
    begin
      for I := 0 to TACBrNFSe(ACBrNFSe).NotasFiscais.Count - 1 do
      begin

        CarregaDados(TACBrNFSe(ACBrNFSe).NotasFiscais.Items[I].NFSe);

        if (I > 0) then
          Result := frxReport.PrepareReport(False)
        else
          Result := frxReport.PrepareReport;
      end;
    end
    else
      raise EACBrNFSeDANFSeFR.Create('Propriedade ACBrNFSe n�o assinalada.');
  end;

  AjustaMargensReports;

end;

procedure TACBrNFSeDANFSeFR.CriarDataSetsFrx;
begin
  frxReport := TfrxReport.Create(nil);
	frxReport.PreviewOptions.Buttons := [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind,
    pbOutline, pbPageSetup, pbTools, pbNavigator, pbExportQuick];
	frxReport.EngineOptions.UseGlobalDataSetList := False;
  with frxReport do
  begin
    Tag := 1;
    // Version := '5.2.3'
    DotMatrixReport           := False;
    IniFile                   := '\Software\Fast Reports';
    PreviewOptions.Buttons    := [pbPrint, pbZoom, pbFind, pbNavigator, pbExportQuick];
    PreviewOptions.Zoom       := 1.000000000000000000;
    PrintOptions.Printer      := 'Padr�o';
    PrintOptions.PrintOnSheet := 0;
    ScriptLanguage            := 'PascalScript';
    StoreInDFM                := False;
    OnBeforePrint             := frxReportBeforePrint;
    OnReportPrint             := 'frxReportOnReportPrint';
  end;

  frxPDFExport := TfrxPDFExport.Create(nil);
  with frxPDFExport do
  begin
    UseFileCache    := True;
    ShowProgress    := True;
    OverwritePrompt := False;
    PrintOptimized  := True;
    Outline         := False;
    Background      := True;
    HTMLTags        := True;
    Author          := 'FastReport';
    Subject         := 'Exportando o DANFSe para PDF';
    HideToolbar     := False;
    HideMenubar     := False;
    HideWindowUI    := False;
    FitWindow       := False;
    CenterWindow    := False;
    PrintScaling    := False;
  end;

  RttiSetProp(frxPDFExport, 'Transparency', 'False');

  cdsIdentificacao := TClientDataSet.Create(nil);
  with cdsIdentificacao do
  begin
    Close;
    with FieldDefs do
    begin
      Clear;
      Add('id', ftString, 10);
      Add('Numero', ftString, 16);
      Add('Serie', ftString, 5);
      Add('Tipo', ftString, 1);
      Add('Competencia', ftString, 20);
      Add('NumeroNFSe', ftString, 16);
      Add('NFSeSubstituida', ftString, 16);
      Add('DataEmissao', ftString, 19);
      Add('CodigoVerificacao', ftString, 50);
      Add('LinkNFSe', ftString, 500);
    end;
    CreateDataSet;
    LogChanges := False;
  end;

  cdsPrestador := TClientDataSet.Create(nil);
  with cdsPrestador do
  begin
    Close;
    with FieldDefs do
    begin
      Clear;
      Add('Cnpj', ftString, 18);
      Add('InscricaoMunicipal', ftString, 15);
      Add('InscricaoEstadual', ftString, 15);
      Add('RazaoSocial', ftString, 60);
      Add('NomeFantasia', ftString, 60);
      Add('Endereco', ftString, 60);
      Add('Numero', ftString, 60);
      Add('Complemento', ftString, 60);
      Add('Bairro', ftString, 60);
      Add('CodigoMunicipio', ftString, 7);
      Add('UF', ftString, 2);
      Add('CEP', ftString, 9);
      Add('xMunicipio', ftString, 60);
      Add('CodigoPais', ftString, 4);
      Add('Telefone', ftString, 15);
      Add('Email', ftString, 60);
    end;
    CreateDataSet;
    LogChanges := False;
  end;

  cdsServicos := TClientDataSet.Create(nil);
  with cdsServicos do
  begin
    Close;
    with FieldDefs do
    begin
      Clear;
      Add('ItemListaServico', ftString, 6);
      Add('CodigoCnae', ftString, 15);
      Add('CodigoTributacaoMunicipio', ftString, 20);
      Add('Discriminacao', ftString, 2000);
      Add('CodigoPais', ftString, 4);
      Add('NumeroProcesso', ftString, 10);
      Add('xItemListaServico', ftString, 300);
      Add('ResponsavelRetencao', ftString, 1);
      Add('Descricao', ftString, 80);
      Add('ValorServicos', ftCurrency);
      Add('ValorDeducoes', ftCurrency);
      Add('ValorPis', ftCurrency);
      Add('ValorCofins', ftCurrency);
      Add('ValorInss', ftCurrency);
      Add('ValorIr', ftCurrency);
      Add('ValorCsll', ftCurrency);
      Add('IssRetido', ftString, 1);
      Add('ValorIss', ftCurrency);
      Add('OutrasRetencoes', ftCurrency);
      Add('BaseCalculo', ftCurrency);
      Add('Aliquota', ftCurrency);
      Add('ValorLiquidoNfse', ftCurrency);
      Add('ValorIssRetido', ftCurrency);
      Add('DescontoCondicionado', ftCurrency);
      Add('DescontoIncondicionado', ftCurrency);
      Add('TotalServicos', ftCurrency); // Nao usado - mantido por compatibilidade era calcfield
      Add('TotalNota', ftCurrency); // Nao usado - mantido por compatibilidade era calcfield
      Add('Tributacao', ftString, 1);
      Add('OutrosDescontos', ftCurrency);
      Add('DescricaoTotalRetDemo', ftString, 19);
      Add('Descri��oTributosFederais', ftString, 35);

      // Provedor SP
      Add('ValorCargaTributaria', ftCurrency);
      Add('PercentualCargaTributaria', ftCurrency);
      Add('FonteCargaTributaria', ftString, 10);
    end;
    CreateDataSet;
    LogChanges := False;
  end;

  cdsParametros := TClientDataSet.Create(nil);
  with cdsParametros do
  begin
    Close;
    with FieldDefs do
    begin
      Add('ExigibilidadeISS', ftString, 60);
      Add('CodigoMunicipio', ftString, 60);
      Add('MunicipioIncidencia', ftString, 60);
      Add('OutrasInformacoes', ftString, 1000);
      Add('InformacoesComplementares', ftString, 1000);
      Add('CodigoObra', ftString, 60);
      Add('Art', ftString, 60);
      Add('Imagem', ftString, 256);
      Add('LogoExpandido', ftString, 1);
      Add('LogoCarregado', ftBlob); // Carregar foto
      Add('imgPrefeitura', ftString, 256);
      Add('LogoPrefExpandido', ftString, 1);
      Add('LogoPrefCarregado', ftBlob);
      Add('Nome_Prefeitura', ftString, 256);
      Add('Mensagem0', ftString, 50);
      Add('Sistema', ftString, 150);
      Add('Usuario', ftString, 50);
      Add('Site', ftString, 50);
      Add('NaturezaOperacao', ftString, 50);
      Add('RegimeEspecialTributacao', ftString, 80);
      Add('OptanteSimplesNacional', ftString, 30);
      Add('IncentivadorCultural', ftString, 10);
      Add('TipoRecolhimento', ftString, 15);
      //
      Add('ValorCredito', ftCurrency);
    end;
    CreateDataSet;
    LogChanges := False;
  end;

  cdsTomador := TClientDataSet.Create(nil);
  with cdsTomador do
  begin
    Close;
    with FieldDefs do
    begin
      Clear;
      Add('CpfCnpj', ftString, 18);
      Add('InscricaoMunicipal', ftString, 15);
      Add('InscricaoEstadual', ftString, 15);
      Add('RazaoSocial', ftString, 60);
      Add('NomeFantasia', ftString, 60);
      Add('Endereco', ftString, 60);
      Add('Numero', ftString, 60);
      Add('Complemento', ftString, 60);
      Add('Bairro', ftString, 60);
      Add('CodigoMunicipio', ftString, 7);
      Add('UF', ftString, 2);
      Add('CEP', ftString, 9);
      Add('xMunicipio', ftString, 60);
      Add('CodigoPais', ftString, 4);
      Add('Telefone', ftString, 15);
      Add('Email', ftString, 60);
    end;
    CreateDataSet;
    LogChanges := False;
  end;

  cdsTransportadora := TClientDataSet.Create(nil);
  with cdsTransportadora do
  begin
    Close;
    with FieldDefs do
    begin
      Clear;
      Add('Cnpj', ftString, 18);
      Add('InscicaoEstadual', ftString, 15);
      Add('RazaoSocial', ftString, 60);
      Add('Placa', ftString, 7);
      Add('Endereco', ftString, 60);
      Add('CodigoMunicipio', ftInteger);
      Add('NomeMunicipio', ftString, 60);
      Add('Sigla', ftString, 2);
      Add('BacenPais', ftInteger);
      Add('NomePais', ftString, 60);
      Add('TipoFrete', ftInteger);
    end;
    CreateDataSet;
    LogChanges := False;
  end;

  cdsItensServico := TClientDataSet.Create(nil);
  with cdsItensServico do
  begin
    Close;
    with FieldDefs do
    begin
      Clear;
      Add('DiscriminacaoServico', ftString, 256);
      Add('Quantidade', ftString, 10);
      Add('ValorUnitario', ftString, 30);
      Add('ValorTotal', ftString, 30);
      Add('Tributavel', ftString, 1);
      Add('Unidade', ftString, 3);
      Add('Aliquota', ftString, 30);
      Add('AliquotaISSST', ftString, 30);
      Add('ValorISSST', ftString, 30);
      Add('DescontoIncondicionado', ftString, 30);
    end;
    CreateDataSet;
    LogChanges := False;
  end;

  frxIdentificacao := TfrxDBDataset.Create(Self);
  with frxIdentificacao do
  begin
    UserName        := 'Identificacao';
    Enabled         := False;
    CloseDataSource := False;
    OpenDataSource  := False;
    with FieldAliases do
    begin
      Clear;
      Add('id=id');
      Add('Numero=Numero');
      Add('Serie=Serie');
      Add('Tipo=Tipo');
      Add('Competencia=Competencia');
      Add('NumeroNFSe=NumeroNFSe');
      Add('NFSeSubstituida=NFSeSubstituida');
      Add('DataEmissao=DataEmissao');
      Add('CodigoVerificacao=CodigoVerificacao');
      Add('LinkNFSe=LinkNFSe');
    end;
    DataSet       := cdsIdentificacao;
    BCDToCurrency := False;
  end;

  frxPrestador := TfrxDBDataset.Create(Self);
  with frxPrestador do
  begin
    UserName        := 'Prestador';
    Enabled         := False;
    CloseDataSource := False;
    OpenDataSource  := False;
    with FieldAliases do
    begin
      Clear;
      Add('Cnpj=Cnpj');
      Add('InscricaoMunicipal=InscricaoMunicipal');
      Add('InscricaoEstadual=InscricaoEstadual');
      Add('RazaoSocial=RazaoSocial');
      Add('NomeFantasia=NomeFantasia');
      Add('Endereco=Endereco');
      Add('Numero=Numero');
      Add('Complemento=Complemento');
      Add('Bairro=Bairro');
      Add('CodigoMunicipio=CodigoMunicipio');
      Add('UF=UF');
      Add('CEP=CEP');
      Add('xMunicipio=xMunicipio');
      Add('CodigoPais=CodigoPais');
      Add('Telefone=Telefone');
      Add('Email=Email');
      DataSet       := cdsPrestador;
      BCDToCurrency := False;
    end;

    frxTomador := TfrxDBDataset.Create(Self);
    with frxTomador do
    begin
      UserName        := 'Tomador';
      Enabled         := False;
      CloseDataSource := False;
      OpenDataSource  := False;
      with FieldAliases do
      begin
        Clear;
        Add('CpfCnpj=CpfCnpj');
        Add('InscricaoMunicipal=InscricaoMunicipal');
        Add('InscricaoEstadual=InscricaoEstadual');
        Add('RazaoSocial=RazaoSocial');
        Add('NomeFantasia=NomeFantasia');
        Add('Endereco=Endereco');
        Add('Numero=Numero');
        Add('Complemento=Complemento');
        Add('Bairro=Bairro');
        Add('CodigoMunicipio=CodigoMunicipio');
        Add('UF=UF');
        Add('CEP=CEP');
        Add('xMunicipio=xMunicipio');
        Add('CodigoPais=CodigoPais');
        Add('Telefone=Telefone');
        Add('Email=Email');
      end;
      DataSet       := cdsTomador;
      BCDToCurrency := False;
    end;

    frxTransportadora := TfrxDBDataset.Create(Self);
    with frxTransportadora do
    begin
      UserName        := 'Transportadora';
      CloseDataSource := False;
      OpenDataSource  := False;
      with FieldAliases do
      begin
        Clear;
        Add('Cnpj=Cnpj');
        Add('InscicaoEstadual=InscicaoEstadual');
        Add('RazaoSocial=RazaoSocial');
        Add('Placa=Placa');
        Add('Endereco=Endereco');
        Add('CodigoMunicipio=CodigoMunicipio');
        Add('NomeMunicipio=NomeMunicipio');
        Add('Sigla=Sigla');
        Add('BacenPais=BacenPais');
        Add('NomePais=NomePais');
        Add('TipoFrete=TipoFrete');
      end;
      DataSet       := cdsTransportadora;
      BCDToCurrency := False;
    end;

    frxServicos := TfrxDBDataset.Create(Self);
    with frxServicos do
    begin
      UserName        := 'Servicos';
      Enabled         := False;
      CloseDataSource := False;
      OpenDataSource  := False;
      with FieldAliases do
      begin
        Clear;
        Add('ItemListaServico=ItemListaServico');
        Add('CodigoCnae=CodigoCnae');
        Add('CodigoTributacaoMunicipio=CodigoTributacaoMunicipio');
        Add('Discriminacao=Discriminacao');
        Add('CodigoMunicipio=CodigoMunicipio');
        Add('CodigoPais=CodigoPais');
        Add('ExigibilidadeISS=ExigibilidadeISS');
        Add('MunicipioIncidencia=MunicipioIncidencia');
        Add('NumeroProcesso=NumeroProcesso');
        Add('xItemListaServico=xItemListaServico');
        Add('ResponsavelRetencao=ResponsavelRetencao');
        Add('Descricao=Descricao');
        Add('ValorServicos=ValorServicos');
        Add('ValorDeducoes=ValorDeducoes');
        Add('ValorPis=ValorPis');
        Add('ValorCofins=ValorCofins');
        Add('ValorInss=ValorInss');
        Add('ValorIr=ValorIr');
        Add('ValorCsll=ValorCsll');
        Add('IssRetido=IssRetido');
        Add('ValorIss=ValorIss');
        Add('OutrasRetencoes=OutrasRetencoes');
        Add('BaseCalculo=BaseCalculo');
        Add('Aliquota=Aliquota');
        Add('ValorLiquidoNfse=ValorLiquidoNfse');
        Add('ValorIssRetido=ValorIssRetido');
        Add('DescontoCondicionado=DescontoCondicionado');
        Add('DescontoIncondicionado=DescontoIncondicionado');
        Add('TotalNota=TotalNota');
        Add('Tributacao=Tributacao');
        Add('OutrosDescontos=OutrosDescontos');
        Add('DescricaoTotalRetDemo=DescricaoTotalRetDemo');
        Add('Descri��oTributosFederais=Descri��oTributosFederais');
        // Provedor SP
        Add('ValorCargaTributaria=ValorCargaTributaria');
        Add('PercentualCargaTributaria=PercentualCargaTributaria');
        Add('FonteCargaTributaria=FonteCargaTributaria');
      end;
      DataSet       := cdsServicos;
      BCDToCurrency := False;
    end;

    frxParametros := TfrxDBDataset.Create(Self);
    with frxParametros do
    begin
      UserName        := 'Parametros';
      Enabled         := False;
      CloseDataSource := False;
      OpenDataSource  := False;
      with FieldAliases do
      begin
        Clear;
        Add('ExigibilidadeISS=ExigibilidadeISS');
        Add('CodigoMunicipio=CodigoMunicipio');
        Add('MunicipioIncidencia=MunicipioIncidencia');
        Add('OutrasInformacoes=OutrasInformacoes');
        Add('InformacoesComplementares=InformacoesComplementares');
        Add('CodigoObra=CodigoObra');
        Add('Art=Art');
        Add('Imagem=Imagem');
        Add('LogoExpandido=LogoExpandido');
        Add('LogoCarregado=LogoCarregado');
        Add('imgPrefeitura=imgPrefeitura');
        Add('LogoPrefExpandido=LogoPrefExpandido');
        Add('LogoPrefCarregado=LogoPrefCarregado');
        Add('Nome_Prefeitura=Nome_Prefeitura');
        Add('Mensagem0=Mensagem0');
        Add('Sistema=Sistema');
        Add('Usuario=Usuario');
        Add('Site=Site');
        Add('IncentivadorCultural=IncentivadorCultural');
        Add('OptanteSimplesNacional=OptanteSimplesNacional');
        Add('RegimeEspecialTributacao=RegimeEspecialTributacao');
        Add('NaturezaOperacao=NaturezaOperacao');
        Add('TipoRecolhimento=TipoRecolhimento');
        Add('ValorCredito=ValorCredito');
      end;
      DataSet       := cdsParametros;
      BCDToCurrency := False;
    end;

    frxItensServico := TfrxDBDataset.Create(Self);
    with frxItensServico do
    begin
      UserName        := 'ItensServico';
      Enabled         := False;
      CloseDataSource := False;
      OpenDataSource  := False;
      with FieldAliases do
      begin
        Clear;
        Add('DiscriminacaoServico=DiscriminacaoServico');
        Add('Quantidade=Quantidade');
        Add('ValorUnitario=ValorUnitario');
        Add('ValorTotal=ValorTotal');
        Add('Tributavel=Tributavel');
        Add('Unidade=Unidade');
        Add('Aliquota=Aliquota');
        Add('AliquotaISSST=AliquotaISSST');
        Add('ValorISSST=ValorISSST');
        Add('DescontoIncondicionado=DescontoIncondicionado');
      end;
      DataSet       := cdsItensServico;
      BCDToCurrency := False;
    end;
  end;
end;

procedure TACBrNFSeDANFSeFR.CarregaDados(ANFSe: TNFSe);
begin
  CarregaIdentificacao(ANFSe);
  CarregaPrestador(ANFSe);
  CarregaTomador(ANFSe);
  CarregaServicos(ANFSe);
  CarregaItensServico(ANFSe);
  CarregaParametros(ANFSe);
  CarregaTransortadora(ANFSe);
end;

procedure TACBrNFSeDANFSeFR.CarregaIdentificacao(ANFSe: TNFSe);
begin
  with cdsIdentificacao do
  begin
    EmptyDataSet;
    Append;

    with ANFSe do
    begin
			FieldByName('Id').AsString := IdentificacaoRps.Numero + IdentificacaoRps.Serie;

			if(FormatarNumeroDocumentoNFSe) then
		  	FieldByName('Numero').AsString := FormatarNumeroDocumentoFiscalNFSe(IdentificacaoRps.Numero)
			else
		  	FieldByName('Numero').AsString := IdentificacaoRps.Numero;

      FieldByName('Serie').AsString       := IdentificacaoRPS.Serie;
			FieldByName('Competencia').AsString := Competencia;

			if(FormatarNumeroDocumentoNFSe) then
		  	FieldByName('NFSeSubstituida').AsString := FormatarNumeroDocumentoFiscalNFSe(NfseSubstituida)
			else
		  	FieldByName('NFSeSubstituida').AsString := ANFSe.NfseSubstituida;

			if(FormatarNumeroDocumentoNFSe) then
		  	FieldByName('NumeroNFSe').AsString := FormatarNumeroDocumentoFiscalNFSe(Numero)
			else
		  	FieldByName('NumeroNFSe').AsString := ANFSe.Numero;

			if(Provedor in [proGINFES, proBetha, proDSFSJC] ) then  // Felipe - Otimizy Sistemas
				FieldByName('DataEmissao').AsString := FormatDateTimeBr(ANFSe.DataEmissao)
			else
				FieldByName('DataEmissao').AsString := FormatDateBr(DataEmissao);

      FieldByName('CodigoVerificacao').AsString := CodigoVerificacao;
      FieldByName('LinkNFSe').AsString          := Link;
    end;
    Post;
  end;
end;

procedure TACBrNFSeDANFSeFR.CarregaItensServico(ANFSe: TNFSe);
var
  I: Integer;
begin
  with cdsItensServico do
  begin
    EmptyDataSet;

    for I := 0 to ANFSe.Servico.ItemServico.Count - 1 do
      with ANFSe.Servico.ItemServico.Items[I] do
      begin
        Append;
        cdsItensServico.FieldByName('DiscriminacaoServico').AsString := Descricao;
        cdsItensServico.FieldByName('Quantidade').AsString           := FloatToStr( Quantidade );
        cdsItensServico.FieldByName('ValorUnitario').AsString        := FormatFloatBr( ValorUnitario, ',0.00');
        cdsItensServico.FieldByName('ValorTotal').AsString           := FormatFloatBr( ValorTotal, ',0.00');
        cdsItensServico.FieldByName('Tributavel').AsString           := SimNaoToStr(Tributavel);
        cdsItensServico.FieldByName('Aliquota').AsString             := FormatFloatBr( Aliquota, '0.00');
        cdsItensServico.FieldByName('Unidade').AsString              := Unidade;
        cdsItensServico.FieldByName('AliquotaISSST').AsString        := FormatFloatBr( AlicotaISSST, '0.00');
        cdsItensServico.FieldByName('ValorISSST').AsString           := FormatFloatBr( ValorISSST, '0.00');
        cdsItensServico.FieldByName('DescontoIncondicionado').AsString := FormatFloatBr( DescontoIncondicionado, '0.00');
        Post;
      end;
  end;
end;

procedure TACBrNFSeDANFSeFR.CarregaParametros(ANFSe: TNFSe);
begin
  with cdsParametros do
  begin
    EmptyDataSet;
    Append;

    with ANFSe do
    begin
      FieldByName('OutrasInformacoes').AsString := OutrasInformacoes;
      FieldByName('NaturezaOperacao').AsString  := NaturezaOperacaoDescricao(NaturezaOperacao);

      if Provedor = proEL then
      begin
        if RegimeEspecialTributacao = retNenhum then
          FieldByName('RegimeEspecialTributacao').AsString := 'Tributa��o Normal'
        else
          FieldByName('RegimeEspecialTributacao').AsString := nfseRegimeEspecialTributacaoDescricao(RegimeEspecialTributacao);

        if OptanteSimplesNacional = snSim then
          FieldByName('OptanteSimplesNacional').AsString := 'Optante'
        else
          FieldByName('OptanteSimplesNacional').AsString := 'N�o Optante';

        FieldByName('IncentivadorCultural').AsString := SimNao(Integer(IncentivadorCultural));

        with Servico do
        begin
          FieldByName('CodigoMunicipio').AsString  := CodCidadeToCidade(StrToIntDef(IfThen(CodigoMunicipio <> '', CodigoMunicipio, ''),0));
          FieldByName('ExigibilidadeISS').AsString := ExigibilidadeISSDescricao(ExigibilidadeISS);

          if NaturezaOperacao = no2 then
            FieldByName('MunicipioIncidencia').AsString := 'Fora do Munic�pio'
          else
            FieldByName('MunicipioIncidencia').AsString := 'No Munic�pio';

          if Valores.IssRetido = stRetencao then
            FieldByName('TipoRecolhimento').AsString := 'Retido na Fonte'
          else
            FieldByName('TipoRecolhimento').AsString := 'N�o Retido';
        end;
      end
      else
      begin
        FieldByName('RegimeEspecialTributacao').AsString := nfseRegimeEspecialTributacaoDescricao(RegimeEspecialTributacao);

        if Provedor = proAdm then
        begin
          if OptanteSimplesNacional = snSim then
            FieldByName('OptanteSimplesNacional').AsString := 'Simples Nacinal / MEI'
          else
            FieldByName('OptanteSimplesNacional').AsString := 'N�o Optante';
        end
        else
          FieldByName('OptanteSimplesNacional').AsString   := SimNao(Integer(OptanteSimplesNacional));

        FieldByName('IncentivadorCultural').AsString     := SimNao(Integer(IncentivadorCultural));

        with Servico do
        begin
          FieldByName('ExigibilidadeISS').AsString    := ExigibilidadeISSDescricao(ExigibilidadeISS);
          FieldByName('TipoRecolhimento').AsString    := TipoRecolhimento;

          if Provedor = proAdm then
          begin
            FieldByName('CodigoMunicipio').AsString     := CodigoMunicipio;
            FieldByName('MunicipioIncidencia').AsString := CodCidadeToCidade(MunicipioIncidencia);
          end
          else
          begin
            FieldByName('CodigoMunicipio').AsString     := CodCidadeToCidade(StrToIntDef(IfThen(CodigoMunicipio <> '', CodigoMunicipio, ''),0));
            FieldByName('MunicipioIncidencia').AsString := CodCidadeToCidade(StrToIntDef(CodigoMunicipio, 0)); // Antes:
          end;
        end;
      end;

      with ConstrucaoCivil do
      begin
        FieldByName('CodigoObra').AsString := CodigoObra;
        FieldByName('Art').AsString        := Art;
      end;

      FieldByName('InformacoesComplementares').AsString := InformacoesComplementares;
      FieldByName('ValorCredito').AsCurrency := ValorCredito;
    end;

    CarregaLogoPrefeitura;
    CarregaImagemPrestadora;

    FieldByName('Sistema').AsString := IfThen( DANFSeClassOwner.Sistema <> '' , DANFSeClassOwner.Sistema, 'Projeto ACBr - http://acbr.sf.net');
    FieldByName('Usuario').AsString := DANFSeClassOwner.Usuario;
    FieldByName('Site').AsString    := DANFSeClassOwner.Site;

    if Provedor = proEL then
      FieldByName('Mensagem0').AsString := IfThen(ANFSe.Cancelada = snSim, 'CANCELADA', '')
    else
      FieldByName('Mensagem0').AsString := IfThen(ANFSe.Cancelada = snSim, 'NFSe CANCELADA', '');  // LUIZ

    if (ANFSe.Producao = snNao) then
      FieldByName('Mensagem0').AsString := Trim(FieldByName('Mensagem0').AsString + sLineBreak + ACBrStr('AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL'));

    Post;
  end;
end;

procedure TACBrNFSeDANFSeFR.CarregaPrestador(ANFSe: TNFSe);
begin
  with cdsPrestador do
  begin
    EmptyDataSet;
    Append;

    with ANFSe.PrestadorServico do
    begin
      FieldByName('RazaoSocial').AsString  := RazaoSocial;
      FieldByName('NomeFantasia').AsString := NomeFantasia;

      with IdentificacaoPrestador do
      begin
        FieldByName('Cnpj').AsString               := FormatarCNPJ(Cnpj);
        FieldByName('InscricaoMunicipal').AsString := InscricaoMunicipal;
        FieldByName('InscricaoEstadual').AsString  := FormatarIE(InscricaoEstadual, Endereco.UF);
      end;

      with Endereco do
      begin
        FieldByName('Endereco').AsString        := Endereco;
        FieldByName('Numero').AsString          := Numero;
        FieldByName('Complemento').AsString     := Complemento;
        FieldByName('Bairro').AsString          := Bairro;
        FieldByName('CodigoMunicipio').AsString := CodigoMunicipio;
        FieldByName('UF').AsString              := UF;
        FieldByName('CEP').AsString             := FormatarCEP(CEP);
        FieldByName('xMunicipio').AsString      := xMunicipio;
        FieldByName('CodigoPais').AsString      := IntToStr(CodigoPais);
      end;

      with Contato do
      begin
        FieldByName('Telefone').AsString := FormatarFone(Telefone);
        FieldByName('Email').AsString    := Email;
      end;
    end;

    with TACBrNFSe(DANFSeClassOwner.ACBrNFSe).Configuracoes.Geral do
      if Emitente.DadosEmitente.Endereco <> EmptyStr then
      begin
        FieldByName('RazaoSocial').AsString  := Emitente.RazSocial;
        FieldByName('NomeFantasia').AsString := Emitente.DadosEmitente.NomeFantasia;

        FieldByName('Cnpj').AsString               := FormatarCNPJ(Emitente.CNPJ);
        FieldByName('InscricaoMunicipal').AsString := Emitente.InscMun;
        FieldByName('InscricaoEstadual').AsString  := FormatarIE(Emitente.DadosEmitente.InscricaoEstadual, Emitente.DadosEmitente.UF);

        FieldByName('Endereco').AsString        := Emitente.DadosEmitente.Endereco;
        FieldByName('Numero').AsString          := Emitente.DadosEmitente.Numero;
        FieldByName('Complemento').AsString     := Emitente.DadosEmitente.Complemento;
        FieldByName('Bairro').AsString          := Emitente.DadosEmitente.Bairro;
        FieldByName('CodigoMunicipio').AsString := Emitente.DadosEmitente.CodigoMunicipio;
        FieldByName('UF').AsString              := Emitente.DadosEmitente.UF;
        FieldByName('CEP').AsString             := FormatarCEP(Emitente.DadosEmitente.CEP);
        FieldByName('xMunicipio').AsString      := Emitente.DadosEmitente.Municipio;

        FieldByName('Telefone').AsString := FormatarFone(Emitente.DadosEmitente.Telefone);
        FieldByName('Email').AsString    := Emitente.DadosEmitente.Email;
      end;

    Post;
  end;
end;

procedure TACBrNFSeDANFSeFR.CarregaServicos(ANFSe: TNFSe);
begin
  with cdsServicos do
  begin
    EmptyDataSet;
    Append;

    with ANFSe.Servico do
    begin
      if Provedor = proEL then
      begin
        FieldByName('ItemListaServico').AsString  := ItemListaServico;
        FieldByName('xItemListaServico').AsString := CodigoToDesc(StringReplace(ItemListaServico, '.', '', [rfReplaceAll, rfIgnoreCase]));
      end
      else
      begin
        FieldByName('ItemListaServico').AsString  := ItemListaServico;
        FieldByName('xItemListaServico').AsString := xItemListaServico;
      end;

      FieldByName('CodigoCnae').AsString                := CodigoCnae;
      FieldByName('CodigoTributacaoMunicipio').AsString := CodigoTributacaoMunicipio;
      FieldByName('Discriminacao').AsString := StringReplace(Discriminacao, TACBrNFSe(DANFSeClassOwner.ACBrNFSe).Configuracoes.WebServices.QuebradeLinha, #13, [rfReplaceAll, rfIgnoreCase]);
      FieldByName('CodigoPais').AsString                := IntToStr(CodigoPais);
      FieldByName('NumeroProcesso').AsString            := NumeroProcesso;
      FieldByName('Descricao').AsString                 := Descricao;
      FieldByName('ResponsavelRetencao').AsString       := ResponsavelRetencaoToStr(ResponsavelRetencao);
      FieldByName('Tributacao').AsString                := TributacaoToStr(Tributacao);

      with Valores do
      begin
        FieldByName('ValorServicos').AsFloat          := ValorServicos;
        FieldByName('ValorDeducoes').AsFloat          := ValorDeducoes;
        FieldByName('ValorPis').AsFloat               := ValorPis;
        FieldByName('ValorCofins').AsFloat            := ValorCofins;
        FieldByName('ValorInss').AsFloat              := ValorInss;
        FieldByName('ValorIr').AsFloat                := ValorIr;
        FieldByName('ValorCsll').AsFloat              := ValorCsll;
        FieldByName('IssRetido').AsString             := SituacaoTributariaDescricao(IssRetido);
        FieldByName('ValorIss').AsFloat               := ValorIss;
        FieldByName('OutrasRetencoes').AsFloat        := OutrasRetencoes;
        FieldByName('BaseCalculo').AsFloat            := BaseCalculo;
        FieldByName('Aliquota').AsFloat               := Aliquota;
        FieldByName('ValorLiquidoNfse').AsFloat       := ValorLiquidoNfse;
        FieldByName('ValorIssRetido').AsFloat         := ValorIssRetido;
        FieldByName('DescontoCondicionado').AsFloat   := DescontoCondicionado;
        FieldByName('DescontoIncondicionado').AsFloat := DescontoIncondicionado;
        FieldByName('OutrosDescontos').AsCurrency     := OutrosDescontos;

        if IssRetido = stRetencao then
        begin
          FieldByName('DescricaoTotalRetDemo').AsString     := 'TOTAL RETEN��ES';
          FieldByName('Descri��oTributosFederais').AsString := 'RETEN��ES DOS TRIBUTOS FEDERAIS';
        end
        else
        begin
          FieldByName('DescricaoTotalRetDemo').AsString     := 'TOTAL DEMONSTRATIVO';
          FieldByName('Descri��oTributosFederais').AsString := 'DEMONSTRATIVO DOS TRIBUTOS FEDERAIS';
        end;

        // Provedor SP
        FieldByName('ValorCargaTributaria').AsCurrency := ValorCargaTributaria;
        FieldByName('PercentualCargaTributaria').AsCurrency := PercentualCargaTributaria;
        FieldByName('FonteCargaTributaria').AsString := FonteCargaTributaria;
      end;
    end;
    Post;
  end;
end;

procedure TACBrNFSeDANFSeFR.CarregaTomador(ANFSe: TNFSe);
begin
  with cdsTomador do
  begin
    EmptyDataSet;
    Append;

    with ANFSe.Tomador do
    begin
      FieldByName('RazaoSocial').AsString        := RazaoSocial;
      FieldByName('CpfCnpj').AsString            := ManterDocumento(IdentificacaoTomador.CpfCnpj);
      FieldByName('InscricaoMunicipal').AsString := IdentificacaoTomador.InscricaoMunicipal;
      FieldByName('InscricaoEstadual').AsString  := IdentificacaoTomador.InscricaoEstadual;

      with Endereco do
      begin
        FieldByName('Endereco').AsString        := Endereco;
        FieldByName('Numero').AsString          := Numero;
        FieldByName('Complemento').AsString     := Complemento;
        FieldByName('Bairro').AsString          := Bairro;
        FieldByName('CodigoMunicipio').AsString := CodigoMunicipio;
        FieldByName('UF').AsString              := UF;
        FieldByName('CEP').AsString             := FormatarCEP(CEP);
        FieldByName('xMunicipio').AsString      := xMunicipio;
        FieldByName('CodigoPais').AsString      := IntToStr(CodigoPais);
      end;

      with Contato do
      begin
        FieldByName('Telefone').AsString := FormatarFone(Telefone);
        FieldByName('Email').AsString    := Email;
      end;
    end;
    Post;
  end;
end;

procedure TACBrNFSeDANFSeFR.CarregaTransortadora(ANFSe: TNFSe);
begin
  with cdsTransportadora do
  begin
    EmptyDataSet;
    Append;
    with ANFSe.Transportadora do
    begin
      FieldByName('Cnpj').AsString              := xCpfCnpjTrans;
      FieldByName('RazaoSocial').AsString       := xNomeTrans;
      FieldByName('InscicaoEstadual').AsString  := xInscEstTrans;
      FieldByName('Placa').AsString             := xPlacaTrans;
      FieldByName('Endereco').AsString          := xEndTrans;
      FieldByName('CodigoMunicipio').AsInteger  := cMunTrans;
      FieldByName('NomeMunicipio').AsString     := xMunTrans;
      FieldByName('Sigla').AsString             := xUFTrans;
      FieldByName('NomePais').AsString          := xPaisTrans;
      FieldByName('BacenPais').AsInteger        := cPaisTrans;
      FieldByName('TipoFrete').AsInteger        := Ord(vTipoFreteTrans);
    end;
    Post;
  end;
end;

procedure TACBrNFSeDANFSeFR.CarregaLogoPrefeitura;
var
  vStream      : TMemoryStream;
  vStringStream: TStringStream;
begin
  With DANFSeClassOwner do
  begin
    cdsParametros.FieldByName('LogoPrefExpandido').AsString := IfThen(ExpandeLogoMarca, '0', '1'); // Prefeitura
    cdsParametros.FieldByName('Nome_Prefeitura').AsString := Prefeitura;
    if NaoEstaVazio(DANFSeClassOwner.Logo) then
    begin
      cdsParametros.FieldByName('imgPrefeitura').AsString   := Logo;
      vStream := TMemoryStream.Create;
      try
        if FileExists(Logo) then
          vStream.LoadFromFile(Logo)
        else
        begin
          vStringStream := TStringStream.Create(Logo);
          try
            vStream.LoadFromStream(vStringStream);
          finally
            vStringStream.Free;
          end;
        end;
        vStream.Position := 0;
        TBlobField(cdsParametros.FieldByName('LogoPrefCarregado')).LoadFromStream(vStream);
      finally
        vStream.Free;
      end;
    end;
  end;
end;

procedure TACBrNFSeDANFSeFR.CarregaImagemPrestadora;
var
  vStream      : TMemoryStream;
  vStringStream: TStringStream;
begin
  With DANFSeClassOwner do
  begin
    cdsParametros.FieldByName('LogoExpandido').AsString := IfThen(ExpandeLogoMarca, '0', '1'); // Prestador

    if NaoEstaVazio(PrestLogo) then
    begin
      cdsParametros.FieldByName('Imagem').AsString := PrestLogo;

      vStream := TMemoryStream.Create;
      try
        if FileExists(PrestLogo) then
          vStream.LoadFromFile(PrestLogo)
        else
        begin
          vStringStream := TStringStream.Create(PrestLogo);
          try
            vStream.LoadFromStream(vStringStream);
          finally
            vStringStream.Free;
          end;
        end;
        vStream.Position := 0;
        TBlobField(cdsParametros.FieldByName('LogoCarregado')).LoadFromStream(vStream);
      finally
        vStream.Free;
      end;
    end;
  end;
end;

function TACBrNFSeDANFSeFR.ManterDocumento(const sCpfCnpj: String): string;
begin
  Result := sCpfCnpj;
  if NaoEstaVazio(Result) then
  begin
    if Length(Result) > 11 then
      Result := FormatarCNPJ(Result)
    else
      Result := FormatarCPF(Result);
  end;
end;

procedure TACBrNFSeDANFSeFR.frxReportBeforePrint(Sender: TfrxReportComponent);
begin
  if Provedor <> proEL then
  begin
    with frxReport do
    begin
      //validando se encontra cada memo no relat�rio (permitindo melhor personaliza��o dos DANFSe)
      if FindObject('Memo23') <> nil then FindObject('Memo23').Visible := DANFSeClassOwner.ImprimeCanhoto;
      if FindObject('Memo75') <> nil then FindObject('Memo75').Visible := DANFSeClassOwner.ImprimeCanhoto;
      if FindObject('Memo77') <> nil then FindObject('Memo77').Visible := DANFSeClassOwner.ImprimeCanhoto;
      if FindObject('Memo68') <> nil then FindObject('Memo68').Visible := DANFSeClassOwner.ImprimeCanhoto;
      if FindObject('Memo73') <> nil then FindObject('Memo73').Visible := DANFSeClassOwner.ImprimeCanhoto;
    end;
  end;
end;

end.
