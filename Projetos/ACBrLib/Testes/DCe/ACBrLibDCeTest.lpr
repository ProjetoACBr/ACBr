program ACBrLibDCeTest;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, ACBrLibDCeStaticImportMT, GuiTestRunner,
  ACBrLibConsts, ACBrLibDCeTestCase;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

