program ACBrDCe_Exemplo;

{$MODE Delphi}

uses
  Forms, Interfaces,
  Frm_ACBrDCe in 'Frm_ACBrDCe.pas' {frmACBrNFe},
  Frm_SelecionarCertificado in 'Frm_SelecionarCertificado.pas' {frmSelecionarCertificado},
  Frm_Status in 'Frm_Status.pas' {frmStatus};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmACBrDCe, frmACBrDCe);
  Application.CreateForm(TfrmSelecionarCertificado, frmSelecionarCertificado);
  Application.CreateForm(TfrmStatus, frmStatus);
  Application.Run;
end.
