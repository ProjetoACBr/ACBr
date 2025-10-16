program ACBrLibExtratoAPITest;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, ACBrLibExtratoAPIStaticImportMT, GuiTestRunner,
  ACBrLibConsts, ACBrLibExtratoAPITestCase;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

