{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ACBrTCP;

{$warn 5023 off : no warning about unused units}
interface

uses
  ACBrTCPReg, ACBrAPIBase, ACBrSocket, ACBrCEP, ACBrIBGE, ACBrCNIEE, 
  ACBrSuframa, ACBrDownload, ACBrDownloadClass, ACBrNFPws, ACBrConsultaCNPJ, 
  ACBrIBPTax, ACBrNCMs, ACBrCotacao, ACBrMail, ACBrConsultaCPF, 
  ACBrSpedTabelas, ACBrSedex, ACBrWinReqRespClass, ACBrWinHTTPReqResp, 
  ACBrWinINetReqResp, ACBrFeriado, ACBrFeriadoWSCalendario, 
  ACBrFeriadoWSClass, ACBrFeriadoWSJSON, ACBrConsultaCNPJ.WS, 
  ACBrConsultaCNPJ.WS.BrasilAPI, ACBrConsultaCNPJ.WS.ReceitaWS, 
  ACBrConsultaCNPJ.WS.CNPJWS, ACBr.Auth.JWT, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ACBrTCPReg', @ACBrTCPReg.Register);
end;

initialization
  RegisterPackage('ACBrTCP', @Register);
end.
