unit ACBrNFeTesteImpressaoPDF;
interface
uses
  ACBrTests.Util,
  ACBrNFe,
  ACBrNFeDANFEFR,
  System.Classes;

type
  TTestImpressaoPDF = class(TTestCase)
  private
    FACBrNFe: TACBrNFe;
    FACBrNFeDANFEFR : TACBrNFeDANFEFR;
    procedure CarregarXMLs;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestImpressaoPares;
    procedure TestImpressaoImpares;
    procedure TestImpressaoIndice5;
    procedure TestImpressaoTodosPorIndex;
    procedure TestImpressaoTodosUnicoComando;
    procedure TestNomeArquivosPadrao;
    procedure TestQuantidadeCorretaDePDFs;
    procedure TestTodasNotasPreview;

  end;

implementation

uses
  System.AnsiStrings,
  System.SysUtils,
  System.IOUtils;

procedure DeleteFilesInDirectory(const Dir, Mask: string);
var
  FileName: string;
begin
  for FileName in TDirectory.GetFiles(Dir, Mask, TSearchOption.soTopDirectoryOnly) do
    TFile.Delete(FileName);
end;

function ObterArquivosPDF(const Dir: string): TStringList;
begin
  Result := TStringList.Create;
  Result.AddStrings(TDirectory.GetFiles(Dir, '*.pdf', TSearchOption.soTopDirectoryOnly));
end;


procedure TTestImpressaoPDF.SetUp;
begin
  FACBrNFe := TACBrNFe.Create(nil);
  FACBrNFeDANFEFR := TACBrNFeDANFEFR.Create(FACBrNFe);
  FACBrNFe.DANFE := FACBrNFeDANFEFR;

  FACBrNFeDANFEFR.PathPDF  := ExtractFilePath(ParamStr(0)) + 'pdfs\';
  FACBrNFeDANFEFR.FastFile             := '..\..\..\Exemplos\ACBrDFe\ACBrNFe\Delphi\Report\NFe\DANFeRetrato.fr3';
  FACBrNFeDANFEFR.FastFileEvento       := '..\..\..\Exemplos\ACBrNFe\Delphi\Report\NFe\EVENTOS.fr3';
  FACBrNFeDANFEFR.FastFileInutilizacao := '..\..\..\Exemplos\ACBrDFe\ACBrNFe\Delphi\Report\NFe\INUTILIZACAO.fr3';

  CarregarXMLs;
end;

procedure TTestImpressaoPDF.CarregarXMLs;
var
  I: Integer;
begin
  // Simula o carregamento de 9 arquivos
  FACBrNFe.NotasFiscais.Clear;
  for I := 1 to 9 do
    FACBrNFe.NotasFiscais.LoadFromFile(Format('..\..\Recursos\NFe\XML\NFe_%d.xml', [I]));
end;

procedure TTestImpressaoPDF.TearDown;
begin
  FACBrNFeDANFEFR.Free;
  FACBrNFe.Free;
end;

procedure TTestImpressaoPDF.TestImpressaoPares;
var
  i: Integer;
  ArquivosPDF: TStringList;
begin
  DeleteFilesInDirectory(FACBrNFeDANFEFR.PathPDF, '*.pdf');
  for i := 0 to Pred(FACBrNFe.NotasFiscais.Count) do
    if (i mod 2 = 0) then
      FACBrNFe.NotasFiscais[I].ImprimirPDF;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(5, ArquivosPDF.Count, 'Quantidade de PDFs gerados para arquivos pares está incorreta.');
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestImpressaoImpares;
var
  i: Integer;
  ArquivosPDF: TStringList;
begin
  DeleteFilesInDirectory(FACBrNFeDANFEFR.PathPDF, '*.pdf');
  for i := 0 to Pred(FACBrNFe.NotasFiscais.Count) do
    if (i mod 2 = 1) then
      FACBrNFe.NotasFiscais[I].ImprimirPDF;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(4, ArquivosPDF.Count, 'Quantidade de PDFs gerados para arquivos ímpares está incorreta.');
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestImpressaoIndice5;
var
  ArquivosPDF: TStringList;
begin
  DeleteFilesInDirectory(FACBrNFeDANFEFR.PathPDF, '*.pdf');
  FACBrNFe.NotasFiscais[5].ImprimirPDF;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(1, ArquivosPDF.Count, 'Apenas 1 PDF deveria ser gerado para o índice 5.');
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestImpressaoTodosPorIndex;
var
  i: Integer;
  ArquivosPDF: TStringList;
begin
  DeleteFilesInDirectory(FACBrNFeDANFEFR.PathPDF, '*.pdf');
  for i := 0 to Pred(FACBrNFe.NotasFiscais.Count) do
  begin
    FACBrNFe.NotasFiscais[I].ImprimirPDF;
  end;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(9, ArquivosPDF.Count, 'Quantidade de PDFs gerados para todos os arquivos está incorreta.');
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestImpressaoTodosUnicoComando;
var
    ArquivosPDF: TStringList;
begin
  DeleteFilesInDirectory(FACBrNFeDANFEFR.PathPDF, '*.pdf');
  FACBrNFe.NotasFiscais.ImprimirPDF;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(9, ArquivosPDF.Count, 'Quantidade de PDFs gerados para todos os arquivos está incorreta.');
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestNomeArquivosPadrao;
var
  ArquivosPDF: TStringList;
  i: Integer;
begin
  TestImpressaoTodosPorIndex; // Gera os arquivos

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    for i := 0 to Pred(ArquivosPDF.Count) do
      CheckTrue(FileExists(ArquivosPDF[i]), Format('Arquivo PDF não encontrado: %s', [ArquivosPDF[i]]));
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestQuantidadeCorretaDePDFs;
var
  ArquivosPDF: TStringList;
begin
  TestImpressaoTodosPorIndex;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(9, ArquivosPDF.Count, 'A quantidade total de PDFs não corresponde à quantidade de XMLs processados.');
  finally
    ArquivosPDF.Free;
  end;
end;




procedure TTestImpressaoPDF.TestTodasNotasPreview;
begin
  FACBrNFe.DANFE.MostraPreview := True;
  FACBrNFe.NotasFiscais.Imprimir;
end;

initialization
  _RegisterTest('Teste de Impressão', TTestImpressaoPDF);
end.
