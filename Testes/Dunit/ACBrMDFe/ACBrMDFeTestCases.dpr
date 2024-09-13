program ACBrMDFeTestCases;

{
  Esse � um projeto de testes com a ajuda da ACBrTests.Runner.pas
  -------------------------
  Este projeto deve funcionar tanto em DUnit/DUnitX/TestInsight
  Por padr�o ele ir� utilizar DUnit e Interface (GUI)

  Para mudar o comportamento, adicione os seguintes "conditional defines" nas
  op��es do projeto (project->options):
  * "NOGUI"       - Transforma os testes em uma aplica��o CONSOLE
  * "DUNITX"      - Passa a usar a DUnitX ao inv�s da Dunit
  * "TESTINSIGHT" - Passa a usar o TestInsight
  * "CI"          - Caso use integra��o continua (por exemplo com o Continua CI ou Jenkins)
                  --/ Geralmente usado em conjunto com NOGUI
  * "FMX"         - Para usar Firemonkey (FMX) ao inv�s de VCL. (Testado apenas com DUnitX)

  ATEN��O: 1) OS defines PRECISAM estar nas op��es do projeto. N�o basta definir no arquivo de projeto.
           2) Fa�a um Build sempre que fizer altera��es de Defines.
  Para mais informa��es veja o arquivo: ACBrTests.Runner.pas
}

{$I ACBr.inc}

{$IFDEF NOGUI}
{$APPTYPE CONSOLE}
{$ENDIF}

{$IFDEF DUNITX}
  {$STRONGLINKTYPES ON}
{$ENDIF}

{$R *.RES}

uses
  ACBrTests.Util in '..\..\ACBrTests.Util.pas',
  ACBrTests.Runner in '..\..\ACBrTests.Runner.pas',
  ACBrMDFeTests in '..\..\FPCUnit\ACBrMDFe\ACBrMDFeTests.pas',
  ACBrMDFeConstantesTests in '..\..\FPCUnit\ACBrMDFe\ACBrMDFeConstantesTests.pas',
  ACBrMDFeConsSitTests in '..\..\FPCUnit\ACBrMDFe\ACBrMDFeConsSitTests.pas',
  ACBrMDFeConsNaoEncTests in '..\..\FPCUnit\ACBrMDFe\ACBrMDFeConsNaoEncTests.pas',
  ACBrMDFeEnvEventoTests in '..\..\FPCUnit\ACBrMDFe\ACBrMDFeEnvEventoTests.pas',
  ACBrMDFeRetConsSitTests in '..\..\FPCUnit\ACBrMDFe\ACBrMDFeRetConsSitTests.pas',
  ACBrMDFeRetConsNaoEncTests in '..\..\FPCUnit\ACBrMDFe\ACBrMDFeRetConsNaoEncTests.pas',
  ACBrMDFeRetEnvEventoTests in '..\..\FPCUnit\ACBrMDFe\ACBrMDFeRetEnvEventoTests.pas';

begin
  ACBrRunTests;
end.
