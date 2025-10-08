program ACBrLibNF3eTest;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, ACBrLibNF3eStaticImportMT, GuiTestRunner,
  ACBrLibConsts, ACBrLibNF3eTestCase;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

