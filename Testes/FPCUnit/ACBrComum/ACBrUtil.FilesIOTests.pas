unit ACBrUtil.FilesIOTests;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils, ACBrTests.Util;

type

  { TStringISJSONTests }

  TStringISJSONTests = class(TTestCase)
  published
    procedure StringEhCaminhoDeArquivo;
    procedure StringEhJSONValidoVazio;
    procedure StringEhJSONValido;
    procedure StringEhJSONInvalido;
    procedure StringEhJSONArrayValidoVazio;
    procedure StringEhJSONArrayValido;
    procedure StringEhJSONArrayInvalido;
  end;

implementation

uses
  ACBrUtil.FilesIO;

{ TStringISJSONTests }

procedure TStringISJSONTests.StringEhCaminhoDeArquivo;
var
  lOK: Boolean;
  lTeste: String;
begin
  lTeste := '..\..\..\..\Recursos\Arquivos-Comparacao\NFeNFCe\JSON\NFCe-Completa.JSON';
  lOK := StringIsJSON(lTeste);
  Check(not lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era FALSE', [lTeste]));
end;

procedure TStringISJSONTests.StringEhJSONValidoVazio;
var
  lOK: Boolean;
  lTeste: String;
begin
  lTeste := '{}';
  lOK := StringISJSON(lTeste);
  Check(lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era TRUE', [lTeste]));
end;

procedure TStringISJSONTests.StringEhJSONValido;
var
  lOK: Boolean;
  lTeste: String;
begin
  lTeste := '{"teste":"testado"}';
  lOK := StringIsJSON(lTeste);
  Check(lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era TRUE', [lTeste]));
end;

procedure TStringISJSONTests.StringEhJSONInvalido;
var
  lOK: Boolean;
  lTeste: String;
begin
  lTeste := '{"teste":}';
  lOK := StringISJSON(lTeste);
  Check(not lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era FALSE', [lTeste]));

  //O Parse consegue ler o "array vazio" [] e ignora o resto
  lTeste := '[]dsw\57xa3 w5';
  lOK := StringIsJSON(lTeste);
  Check(lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era TRUE', [lTeste]));
  //

  lTeste := '[dsw\57xa3 w5]';
  lOK := StringIsJSON(lTeste);
  Check(not lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era FALSE', [lTeste]));
end;

procedure TStringISJSONTests.StringEhJSONArrayValidoVazio;
var
  lOK: Boolean;
  lTeste: String;
begin
  lTeste := '[]';
  lOK := StringIsJSON(lTeste);
  Check(lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era TRUE', [lTeste]));
end;

procedure TStringISJSONTests.StringEhJSONArrayValido;
var
  lTeste: String;
  lOK: Boolean;
begin
  lTeste := '{"lista":[{"teste":"testado1"},{"teste":"testado2"}]}';
  lOK := StringIsJSON(lTeste);
  Check(lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era TRUE', [lTeste]));
  lTeste := '[{"teste":"testado1"},{"teste":"testado2"}]';
  lOK := StringIsJSON(lTeste);
  Check(lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era TRUE', [lTeste]));
end;

procedure TStringISJSONTests.StringEhJSONArrayInvalido;
var
  lOK: Boolean;
  lTeste: String;
begin
  //O Parse consegue ler o "JSON vazio" e ignora o resto'
  lTeste := '{}hdahdjaid';
  lOK := StringISJSON(lTeste);
  Check(lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era TRUE', [lTeste]));
  //
  lTeste := '{hdahdjaid}';
  lOK := StringISJSON(lTeste);
  Check(not lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era FALSE', [lTeste]));
  lTeste := '[{"teste":"testado1"},{"teste":"testado2"}';
  lOK := StringISJSON(lTeste);
  Check(not lOK, Format('StringISJSON falhou!|String testada: %s |Result esperado era FALSE', [lTeste]));
end;

initialization
  _RegisterTest('ACBrComum.ACBrUtil.FilesIO.StringIsJSON', TStringISJSONTests);

end.

