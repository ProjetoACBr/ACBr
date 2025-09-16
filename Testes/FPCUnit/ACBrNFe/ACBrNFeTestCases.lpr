program ACBrNFeTestCases;

{$mode objfpc}{$H+}

uses
  Interfaces,
  Forms,
  ACBrNFeTests,
  ACBrTests.Util,
  GuiTestRunner,
  ACBrNFeAdmCSCTests,
  ACBrNFeConsCadTests,
  ACBrNFeConsSitTests,
  ACBrNFeConstantesTests,
  ACBrNFeEnvEventoTests,
  ACBrNFeInutTests,
  ACBrNFeRetAdmCSCTests,
  ACBrNFeRetConsSitTests,
  ACBrNFeRetEnvEventoTests,
  ACBrNFeRetInutTests,
  ACBrNFeJSONTests;





{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

