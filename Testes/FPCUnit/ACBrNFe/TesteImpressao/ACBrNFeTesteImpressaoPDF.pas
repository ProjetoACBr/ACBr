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
    FACBrNFeDANFEFR  : TACBrNFeDANFEFR;
    FACBrNFeDANFCEFR : TACBrNFeDANFCEFR;
    procedure CarregarXMLsNFe;
  public
    procedure SetUp; override;
    procedure TearDown; override;
    procedure PreparaNFe;
  published
    procedure TestNFeImpressaoPares;
    procedure TestNFeImpressaoImpares;
    procedure TestNFeImpressaoIndice0;
    procedure TestNFeImpressaoIndice5;
    procedure TestNFeImpressaoTodosPorIndex;
    procedure TestNFeImpressaoTodosUnicoComando;
    procedure TestNFeNomeArquivosPadrao;
    procedure TestNFeQuantidadeCorretaDePDFs;
    procedure TestNFeImpressaoComPathIndividual;
    procedure TestNFeImpressaoSemPathIndividual;
    procedure TestNFeImpressaoComPathIndividualIndex0;
    procedure TestNFeImpressaoComPathIndividualIndex5;
    procedure TestNFeImpressaoSemPathIndividualIndex0;
    procedure TestNFeImpressaoSemPathIndividualIndex5;
    procedure TestNFeTodasNotasPreview;

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


procedure TTestImpressaoPDF.PreparaNFe;
begin
  FACBrNFe.DANFE := FACBrNFeDANFEFR;
  DeleteFilesInDirectory(FACBrNFeDANFEFR.PathPDF, '*.pdf');
  CarregarXMLsNFe;
end;

procedure TTestImpressaoPDF.SetUp;
begin
  FACBrNFe := TACBrNFe.Create(nil);
  FACBrNFeDANFEFR  := TACBrNFeDANFEFR.Create(FACBrNFe);
  FACBrNFeDANFCEFR := TACBrNFeDANFCEFR.Create(FACBrNFe);

  FACBrNFeDANFEFR.UsaSeparadorPathPDF := False;
  FACBrNFeDANFCEFR.UsaSeparadorPathPDF := False;
  FACBrNFe.Configuracoes.Arquivos.SepararPorCNPJ := True;
  FACBrNFe.Configuracoes.Arquivos.SepararPorIE := True;
  FACBrNFe.Configuracoes.Arquivos.SepararPorModelo := True;
  FACBrNFe.Configuracoes.Arquivos.SepararPorAno := True;
  FACBrNFe.Configuracoes.Arquivos.SepararPorMes := True;
  FACBrNFe.Configuracoes.Arquivos.SepararPorDia := True;

  var LPath := ExtractFilePath(ParamStr(0));

  ForceDirectories(LPath + 'nfe\');

  FACBrNFeDANFEFR.PathPDF  := LPath + 'nfe\';
  FACBrNFeDANFEFR.FastFile             := '..\..\..\Exemplos\ACBrDFe\ACBrNFe\Delphi\Report\NFe\DANFeRetrato.fr3';
  FACBrNFeDANFEFR.FastFileEvento       := '..\..\..\Exemplos\ACBrNFe\Delphi\Report\NFe\EVENTOS.fr3';
  FACBrNFeDANFEFR.FastFileInutilizacao := '..\..\..\Exemplos\ACBrDFe\ACBrNFe\Delphi\Report\NFe\INUTILIZACAO.fr3';

  ForceDirectories(LPath + 'nfce\');

  FACBrNFeDANFCEFR.PathPDF  := LPath + 'nfce\';
  FACBrNFeDANFCEFR.FastFile             := '..\..\..\Exemplos\ACBrDFe\ACBrNFe\Delphi\Report\NFCe\DANFeNFCe5_00.fr3';
  FACBrNFeDANFCEFR.FastFileEvento       := '..\..\..\Exemplos\ACBrNFe\Delphi\Report\NFCe\EventosNFCe.fr3';
  FACBrNFeDANFCEFR.FastFileInutilizacao := '..\..\..\Exemplos\ACBrDFe\ACBrNFe\Delphi\Report\NFCe\INUTILIZACAONFCE.fr3';

end;

procedure TTestImpressaoPDF.CarregarXMLsNFe;
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
  FACBrNFeDANFCEFR.Free;
  FACBrNFe.Free;
end;

procedure TTestImpressaoPDF.TestNFeImpressaoPares;
var
  i: Integer;
  ArquivosPDF: TStringList;
begin
  PreparaNFe;
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

procedure TTestImpressaoPDF.TestNFeImpressaoComPathIndividual;
var LUsaSeparadorPathPDF : Boolean;
begin
  PreparaNFe;
  LUsaSeparadorPathPDF := FACBrNFeDANFEFR.UsaSeparadorPathPDF;

  var LPath := 'C:\ACBr\Testes\Dunit\ACBrNFe\nfe\';

  if TDirectory.Exists(LPath) then
    TDirectory.Delete(LPath, True);

  try
    FACBrNFe.DANFE.UsaSeparadorPathPDF := True;
    TestNFeImpressaoTodosUnicoComando;
  finally
    FACBrNFeDANFEFR.UsaSeparadorPathPDF := LUsaSeparadorPathPDF;
  end;
end;

procedure TTestImpressaoPDF.TestNFeImpressaoComPathIndividualIndex0;
var LUsaSeparadorPathPDF : Boolean;
  ArquivosPDF: TStringList;
begin
  FACBrNFe.DANFE := FACBrNFeDANFEFR;
  LUsaSeparadorPathPDF := FACBrNFeDANFEFR.UsaSeparadorPathPDF;

  FACBrNFe.DANFE.UsaSeparadorPathPDF := True;

  FACBrNFeDANFEFR.PathPDF;

  var LPath := 'C:\ACBr\Testes\Dunit\ACBrNFe\nfe\';

  if TDirectory.Exists(LPath) then
    TDirectory.Delete(LPath, True);

  FACBrNFe.NotasFiscais.Clear;
  FACBrNFe.NotasFiscais.LoadFromFile(Format('..\..\Recursos\NFe\XML\NFe_%d.xml', [1]));
  FACBrNFe.NotasFiscais[0].ImprimirPDF;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(1, ArquivosPDF.Count, 'Apenas 1 PDF deveria ser gerado para o índice 0.');
    FACBrNFeDANFEFR.UsaSeparadorPathPDF := LUsaSeparadorPathPDF;
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestNFeImpressaoComPathIndividualIndex5;
var LUsaSeparadorPathPDF : Boolean;
begin
  PreparaNFe;
  LUsaSeparadorPathPDF := FACBrNFeDANFEFR.UsaSeparadorPathPDF;
  try
    FACBrNFe.DANFE.UsaSeparadorPathPDF := True;
    TestNFeImpressaoIndice5;
  finally
    FACBrNFeDANFEFR.UsaSeparadorPathPDF := LUsaSeparadorPathPDF;
    var Path := ExtractFilePath(FACBrNFeDANFEFR.ArquivoPDF);
    var Arquivo := Path+'352505123456789000161550020000007831478256711-nfe.pdf';
    CheckEquals( True , FileExists(Arquivo),
                   'Não encontrado ' + Arquivo);
  end;
end;

procedure TTestImpressaoPDF.TestNFeImpressaoSemPathIndividual;
var LUsaSeparadorPathPDF : Boolean;
begin
  PreparaNFe;
  LUsaSeparadorPathPDF := FACBrNFe.DANFE.UsaSeparadorPathPDF;
  try
    FACBrNFe.DANFE.UsaSeparadorPathPDF := False;
    TestNFeImpressaoTodosUnicoComando;
  finally
    FACBrNFeDANFEFR.UsaSeparadorPathPDF := LUsaSeparadorPathPDF;
  end;
end;

procedure TTestImpressaoPDF.TestNFeImpressaoSemPathIndividualIndex0;
var LUsaSeparadorPathPDF : Boolean;
begin
  PreparaNFe;
  LUsaSeparadorPathPDF := FACBrNFeDANFEFR.UsaSeparadorPathPDF;
  try
    FACBrNFeDANFEFR.UsaSeparadorPathPDF := False;
    TestNFeImpressaoIndice0;
  finally
    FACBrNFeDANFEFR.UsaSeparadorPathPDF := LUsaSeparadorPathPDF;
  end;
end;

procedure TTestImpressaoPDF.TestNFeImpressaoSemPathIndividualIndex5;
var LUsaSeparadorPathPDF : Boolean;
begin
  PreparaNFe;
  LUsaSeparadorPathPDF := FACBrNFeDANFEFR.UsaSeparadorPathPDF;
  try
    FACBrNFeDANFEFR.UsaSeparadorPathPDF := False;
    TestNFeImpressaoIndice5;
  finally
    FACBrNFeDANFEFR.UsaSeparadorPathPDF := LUsaSeparadorPathPDF;
  end;
end;

procedure TTestImpressaoPDF.TestNFeImpressaoImpares;
var
  i: Integer;
  ArquivosPDF: TStringList;
begin
  PreparaNFe;
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

procedure TTestImpressaoPDF.TestNFeImpressaoIndice0;
var
  ArquivosPDF: TStringList;
begin
  FACBrNFe.DANFE := FACBrNFeDANFEFR;
  DeleteFilesInDirectory(FACBrNFeDANFEFR.PathPDF, '*.pdf');
  FACBrNFe.NotasFiscais.Clear;
  FACBrNFe.NotasFiscais.LoadFromFile(Format('..\..\Recursos\NFe\XML\NFe_%d.xml', [1]));
  FACBrNFe.NotasFiscais[0].ImprimirPDF;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(1, ArquivosPDF.Count, 'Apenas 1 PDF deveria ser gerado para o índice 0.');
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestNFeImpressaoIndice5;
var
  ArquivosPDF: TStringList;
begin
  PreparaNFe;
  DeleteFilesInDirectory(FACBrNFeDANFEFR.PathPDF, '*.pdf');
  FACBrNFe.NotasFiscais[5].ImprimirPDF;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(1, ArquivosPDF.Count, 'Apenas 1 PDF deveria ser gerado para o índice 5.');
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestNFeImpressaoTodosPorIndex;
var
  i: Integer;
  ArquivosPDF: TStringList;
begin
  PreparaNFe;
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

procedure TTestImpressaoPDF.TestNFeImpressaoTodosUnicoComando;
var
    ArquivosPDF: TStringList;
begin
  PreparaNFe;
  DeleteFilesInDirectory(FACBrNFeDANFEFR.PathPDF, '*.pdf');
  FACBrNFe.NotasFiscais.ImprimirPDF;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(9, ArquivosPDF.Count, 'Quantidade de PDFs gerados para todos os arquivos está incorreta.');
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestNFeNomeArquivosPadrao;
var
  ArquivosPDF: TStringList;
  i: Integer;
begin
  TestNFeImpressaoTodosPorIndex; // Gera os arquivos

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    for i := 0 to Pred(ArquivosPDF.Count) do
      CheckTrue(FileExists(ArquivosPDF[i]), Format('Arquivo PDF não encontrado: %s', [ArquivosPDF[i]]));
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestNFeQuantidadeCorretaDePDFs;
var
  ArquivosPDF: TStringList;
begin
  TestNFeImpressaoTodosPorIndex;

  ArquivosPDF := ObterArquivosPDF(FACBrNFeDANFEFR.PathPDF);
  try
    CheckEquals(9, ArquivosPDF.Count, 'A quantidade total de PDFs não corresponde à quantidade de XMLs processados.');
  finally
    ArquivosPDF.Free;
  end;
end;

procedure TTestImpressaoPDF.TestNFeTodasNotasPreview;
begin
  PreparaNFe;
  FACBrNFe.DANFE.MostraPreview       := True;
  FACBrNFe.DANFE.UsaSeparadorPathPDF := False;
  FACBrNFe.NotasFiscais.Imprimir;
end;

initialization
  _RegisterTest('Teste de Impressão', TTestImpressaoPDF);
end.
