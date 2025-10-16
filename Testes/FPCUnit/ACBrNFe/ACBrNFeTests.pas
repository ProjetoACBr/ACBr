unit ACBrNFeTests;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils, ACBrTests.Util, synautil,
  ACBrNFe;

const
  XML_UTF8_SEMACENTOS = '..\..\..\..\Recursos\NFe\NFe-UTF8-SemAcento.xml';
  XML_UTF8_COMACENTOS = '..\..\..\..\Recursos\NFe\NFe-UTF8-ComAcento.xml';
  XML_UTF8BOM_SEMACENTOS = '..\..\..\..\Recursos\NFe\NFe-UTF8BOM-SemAcento.xml';
  XML_UTF8BOM_COMACENTOS = '..\..\..\..\Recursos\NFe\NFe-UTF8BOM-ComAcento.xml';
  XML_ANSI_SEMACENTOS = '..\..\..\..\Recursos\NFe\NFe-ANSI-SemAcento.xml';
  XML_ANSI_COMACENTOS = '..\..\..\..\Recursos\NFe\NFe-ANSI-ComAcento.xml';

type

  { ACBrNFeBaseTest }

  ACBrNFeBaseTest = class(TTestCase)
  private
    FACBrNFe1: TACBrNFe;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure AoCriarComponente_ContadorDeNotas_DeveSerZero;
  end;

  { TACBrNFeFromFileTest }

  { TACBrNFeLoadFromTest }

  TACBrNFeLoadFromTest = class(TTestCase)
  private
    FACBrNFe: TACBrNFe;
  public
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure LoadFromFile_UTF8_SemAcentos;
    procedure LoadFromFile_UTF8_ComAcentos;
    procedure LoadFromFile_UTF8BOM_SemAcentos;
    procedure LoadFromFile_UTF8BOM_ComAcentos;
    procedure LoadFromFile_ANSI_SemAcentos;
    procedure LoadFromFile_ANSI_ComAcentos;
    procedure LoadFromString_UTF8_SemAcentos;
    procedure LoadFromString_UTF8_ComAcentos;
    procedure LoadFromString_UTF8BOM_SemAcentos;
    procedure LoadFromString_UTF8BOM_ComAcentos;
    procedure LoadFromString_ANSI_SemAcentos;
    procedure LoadFromString_ANSI_ComAcentos;
    procedure LoadFromStream_UTF8_SemAcentos;
    procedure LoadFromStream_UTF8_ComAcentos;
    procedure LoadFromStream_UTF8BOM_SemAcentos;
    procedure LoadFromStream_UTF8BOM_ComAcentos;
    procedure LoadFromStream_ANSI_SemAcentos;
    procedure LoadFromStream_ANSI_ComAcentos;

  end;

  


implementation

uses
  ACBrConsts, ACBrUtil.Strings;

{ ACBrNFeBaseTest }

procedure ACBrNFeBaseTest.SetUp;
begin
  inherited SetUp;

  FACBrNFe1 := TACBrNFe.Create(nil);
end;

procedure ACBrNFeBaseTest.TearDown;
begin
  FACBrNFe1.Free;

  inherited TearDown;
end;

procedure ACBrNFeBaseTest.AoCriarComponente_ContadorDeNotas_DeveSerZero;
begin
  CheckEquals(0, FACBrNFe1.NotasFiscais.Count, 'Contador de NFeS Não é zero');
end;

{ TACBrNFeLoadFromTest }

procedure TACBrNFeLoadFromTest.Setup;
begin
  inherited Setup;
  FACBrNFe := TACBrNFe.Create(nil);
end;

procedure TACBrNFeLoadFromTest.TearDown;
begin
  FACBrNFe.Free;
  inherited TearDown;
end;

procedure TACBrNFeLoadFromTest.LoadFromFile_UTF8_SemAcentos;
var
  lTestStr: String;
begin
  FACBrNFe.NotasFiscais.Clear;
  FACBrNFe.NotasFiscais.LoadFromFile(XML_UTF8_SEMACENTOS);
  Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
  lTestStr := 'RAZAO SOCIAL';
  Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
end;

procedure TACBrNFeLoadFromTest.LoadFromFile_UTF8_ComAcentos;
var
  lTestStr: String;
begin
  FACBrNFe.NotasFiscais.Clear;
  FACBrNFe.NotasFiscais.LoadFromFile(XML_UTF8_COMACENTOS);
  Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
  lTestStr := 'RAZAO SOCIAL - ÁÀÃáàãÈÉéèÌÍíìÒÓóòÚÙÜúùüÇç';
  Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
end;

procedure TACBrNFeLoadFromTest.LoadFromFile_UTF8BOM_SemAcentos;
var
  lTestStr: String;
begin
  FACBrNFe.NotasFiscais.Clear;
  FACBrNFe.NotasFiscais.LoadFromFile(XML_UTF8BOM_SEMACENTOS);
  Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
  lTestStr := 'RAZAO SOCIAL';
  Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
end;

procedure TACBrNFeLoadFromTest.LoadFromFile_UTF8BOM_ComAcentos;
var
  lTestStr: String;
begin
  FACBrNFe.NotasFiscais.Clear;
  FACBrNFe.NotasFiscais.LoadFromFile(XML_UTF8BOM_COMACENTOS);
  Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
  lTestStr := 'RAZAO SOCIAL - ÁÀÃáàãÈÉéèÌÍíìÒÓóòÚÙÜúùüÇç';
  Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
end;

procedure TACBrNFeLoadFromTest.LoadFromFile_ANSI_SemAcentos;
var
  lTestStr: String;
begin
  FACBrNFe.NotasFiscais.Clear;
  FACBrNFe.NotasFiscais.LoadFromFile(XML_ANSI_SEMACENTOS);
  Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
  lTestStr := 'RAZAO SOCIAL';
  Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
end;

procedure TACBrNFeLoadFromTest.LoadFromFile_ANSI_ComAcentos;
var
  lTestStr: String;
begin
  FACBrNFe.NotasFiscais.Clear;
  FACBrNFe.NotasFiscais.LoadFromFile(XML_ANSI_COMACENTOS);
  Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
  lTestStr := 'RAZAO SOCIAL - ÁÀÃáàãÈÉéèÌÍíìÒÓóòÚÙÜúùüÇç';
  Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
end;

procedure TACBrNFeLoadFromTest.LoadFromString_UTF8_SemAcentos;
var
  lTestStr, lTempStr: String;
  lTempStream: TMemoryStream;
begin
  lTempStream := TMemoryStream.Create;
  try
    lTempStream.LoadFromFile(XML_UTF8_SEMACENTOS);
    lTempStream.Position := 0;
    lTempStr := ReadStrFromStream(lTempStream, lTempStream.Size);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromString(lTempStr);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromString_UTF8_ComAcentos;
var
  lTestStr, lTempStr: String;
  lTempStream: TMemoryStream;
begin
  lTempStream := TMemoryStream.Create;
  try
    lTempStream.LoadFromFile(XML_UTF8_COMACENTOS);
    lTempStream.Position := 0;
    lTempStr := ReadStrFromStream(lTempStream, lTempStream.Size);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromString(lTempStr);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL - ÁÀÃáàãÈÉéèÌÍíìÒÓóòÚÙÜúùüÇç';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromString_UTF8BOM_SemAcentos;
var
  lTestStr, lTempStr: String;
  lTempStream: TMemoryStream;
begin
  lTempStream := TMemoryStream.Create;
  try
    lTempStream.LoadFromFile(XML_UTF8BOM_SEMACENTOS);
    lTempStream.Position := 0;
    lTempStr := ReadStrFromStream(lTempStream, lTempStream.Size);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromString(lTempStr);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromString_UTF8BOM_ComAcentos;
var
  lTestStr, lTempStr: String;
  lTempStream: TMemoryStream;
begin
  lTempStream := TMemoryStream.Create;
  try
    lTempStream.LoadFromFile(XML_UTF8_COMACENTOS);
    lTempStream.Position := 0;
    lTempStr := ReadStrFromStream(lTempStream, lTempStream.Size);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromString(lTempStr);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL - ÁÀÃáàãÈÉéèÌÍíìÒÓóòÚÙÜúùüÇç';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromString_ANSI_SemAcentos;
var
  lTestStr, lTempStr: String;
  lTempStream: TMemoryStream;
begin
  lTempStream := TMemoryStream.Create;
  try
    lTempStream.LoadFromFile(XML_ANSI_SEMACENTOS);
    lTempStream.Position := 0;
    lTempStr := ReadStrFromStream(lTempStream, lTempStream.Size);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromString(lTempStr);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromString_ANSI_ComAcentos;
var
  lTestStr, lTempStr: String;
  lTempStream: TMemoryStream;
begin
  lTempStream := TMemoryStream.Create;
  try
    lTempStream.LoadFromFile(XML_ANSI_COMACENTOS);
    lTempStream.Position := 0;
    lTempStr := ReadStrFromStream(lTempStream, lTempStream.Size);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromString(lTempStr);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL - ÁÀÃáàãÈÉéèÌÍíìÒÓóòÚÙÜúùüÇç';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromStream_UTF8_SemAcentos;
var
  lTestStr: String;
  lTempStream: TStringStream;
begin
  lTempStream := TStringStream.Create;
  try
    lTempStream.LoadFromFile(XML_UTF8_SEMACENTOS);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromStream(lTempStream);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromStream_UTF8_ComAcentos;
var
  lTestStr: String;
  lTempStream: TStringStream;
begin
  lTempStream := TStringStream.Create;
  try
    lTempStream.LoadFromFile(XML_UTF8_COMACENTOS);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromStream(lTempStream);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL - ÁÀÃáàãÈÉéèÌÍíìÒÓóòÚÙÜúùüÇç';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromStream_UTF8BOM_SemAcentos;
var
  lTestStr: String;
  lTempStream: TStringStream;
begin
  lTempStream := TStringStream.Create;
  try
    lTempStream.LoadFromFile(XML_UTF8BOM_SEMACENTOS);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromStream(lTempStream);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromStream_UTF8BOM_ComAcentos;
var
  lTestStr: String;
  lTempStream: TStringStream;
begin
  lTempStream := TStringStream.Create;
  try
    lTempStream.LoadFromFile(XML_UTF8BOM_COMACENTOS);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromStream(lTempStream);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL - ÁÀÃáàãÈÉéèÌÍíìÒÓóòÚÙÜúùüÇç';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromStream_ANSI_SemAcentos;
var
  lTestStr: String;
  lTempStream: TStringStream;
begin
  lTempStream := TStringStream.Create;
  try
    lTempStream.LoadFromFile(XML_ANSI_SEMACENTOS);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromStream(lTempStream);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;

procedure TACBrNFeLoadFromTest.LoadFromStream_ANSI_ComAcentos;
var
  lTestStr: String;
  lTempStream: TStringStream;
begin
  lTempStream := TStringStream.Create;
  try
    lTempStream.LoadFromFile(XML_ANSI_COMACENTOS);
    FACBrNFe.NotasFiscais.Clear;
    FACBrNFe.NotasFiscais.LoadFromStream(lTempStream);
    Check(FACBrNFe.NotasFiscais.Count > 0, 'Falhou: NotasFiscais.Count deveria ser maior do que zero');
    lTestStr := 'RAZAO SOCIAL - ÁÀÃáàãÈÉéèÌÍíìÒÓóòÚÙÜúùüÇç';
    Check(FACBrNFe.NotasFiscais[0].NFe.Emit.xNome = lTestStr, Format('NFe.Emit.xNome divergente|Esperado:%s|Obtido:%s', [lTestStr, FACBrNFe.NotasFiscais[0].NFe.Emit.xNome]));
  finally
    lTempStream.Free;
  end;
end;


initialization

  _RegisterTest('ACBrNFeTests', ACBrNFeBaseTest);
  _RegisterTest('ACBrNFeTests.LoadFromTests', TACBrNFeLoadFromTest);

end.
