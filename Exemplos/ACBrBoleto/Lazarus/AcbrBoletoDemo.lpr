program AcbrBoletoDemo;

uses
  Forms, Interfaces,
  uDemoBoleto in 'uDemoBoleto.pas' {frmDemoBoleto};


begin
  Application.Initialize;
  Application.CreateForm(TfrmDemoBoleto, frmDemoBoleto);
  Application.Run;
end.
