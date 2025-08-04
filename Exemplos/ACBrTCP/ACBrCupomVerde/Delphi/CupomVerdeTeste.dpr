program CupomVerdeTeste;

uses
  Forms,
  Principal in 'Principal.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrPrincipal, frPrincipal);
  Application.Run;
end.
