{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ACBr_Boleto;

{$warn 5023 off : no warning about unused units}
interface

uses
  ACBrBoleto, ACBrBancoBradesco, ACBrBancoBrasil, ACBrBancoItau, 
  ACBrBancoSicredi, ACBrBancoMercantil, ACBrBancoBanrisul, ACBrBancoSantander, 
  ACBrBancoSicoob, ACBrBancoHSBC, ACBrBancoNordeste, ACBrBancoBRB, 
  ACBrBancoBic, ACBrBancoBanestes, ACBrBancoAilos, ACBrBancoCaixa, 
  ACBrBancoCaixaSICOB, ACBrBancoBrasilSicoob, ACBrBancoCitiBank, 
  ACBrBancoPine, ACBrBancoPineBradesco, ACBrBoletoReg, ACBrBoletoWS, 
  ACBrBoletoConversao, ACBrBoletoPcnConsts, ACBrBoletoW_Caixa, 
  ACBrBoletoRet_Caixa, ACBrBoletoRetorno, ACBrBoletoW_BancoBrasil, 
  ACBrBoletoRet_BancoBrasil, ACBrBoletoW_BancoBrasil_API, 
  ACBrBoletoRet_BancoBrasil_API, ACBrBancoPenseBank, 
  ACBrBoletoW_PenseBank_API, ACBrBoletoRet_PenseBank_API, 
  ACBrBoletoW_Santander, ACBrBoletoRet_Santander, ACBrBancoABCBrasil, 
  ACBrBancoAlfa, ACBrBancoAmazonia, ACBrBancoBanese, 
  ACBrBancoBradescoMoneyPlus, ACBrBancoBradescoSICOOB, ACBrBancoBS2, 
  ACBrBancoBTGPactual, ACBrBancoC6, ACBrBancoCredisis, ACBrBancoCresol, 
  ACBrBancoCresolSCRS, ACBrBancoDaycoval, ACBrBancoInter, ACBrBancoOriginal, 
  ACBrBancoRendimento, ACBrBancoSafra, ACBrBancoSafraBradesco, 
  ACBrBancoSofisaSantander, ACBrBancoUnicredES, ACBrBancoUnicredRS, 
  ACBrBancoUnicredSC, ACBrBoletoWS.Rest.OAuth, ACBrBoletoWS.Rest, 
  ACBrBoletoWS.SOAP, ACBrUniprime, ACBrSisprime, ACBrBoletoRet_Credisis, 
  ACBrBoletoRet_Inter_API, ACBrBoletoRet_Itau, ACBrBoletoRet_Sicredi_APIECOMM, 
  ACBrBoletoW_Credisis, ACBrBoletoW_Inter_API, ACBrBoletoW_Itau, 
  ACBrBoletoW_Sicredi_APIECOMM, ACBrBancoVotorantim, 
  ACBrBoletoRet_Sicredi_APIV2, ACBrBoletoW_Sicredi_APIV2, 
  ACBrBoletoRet_Sicoob, ACBrBoletoW_Sicoob, ACBrBancoPefisa, ACBrBancoFibra, 
  ACBrBancoSofisaItau, ACBrBoletoRet_Santander_API, ACBrBoletoW_Santander_API, 
  ACBrBancoAthenaBradesco, ACBrBancoIndustrialBrasil, ACBrBancoQITech, 
  ACBrBoletoRet_Itau_API, ACBrBoletoW_Itau_API, ACBrBancoBocomBBM, 
  ACBrBoletoRet_Cresol, ACBrBoletoW_Cresol, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ACBrBoletoReg', @ACBrBoletoReg.Register);
end;

initialization
  RegisterPackage('ACBr_Boleto', @Register);
end.
