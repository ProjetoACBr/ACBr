﻿unit ACBrMDFeRetEnvEventoTests;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils,
  ACBrTests.Util,
  ACBrMDFe.RetEnvEvento;

type

  { ACBrMDFeRetEnvEventoTest }

  ACBrMDFeRetEnvEventoTest = class(TTestCase)
  private
    FRetEnvEvento: TRetEventoMDFe;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure LoadFromFile_RetEnvEvento;
    procedure LoadFromFile_Ret_Vazio;

  end;

implementation

uses
  pcnConversao,
  ACBrUtil.XMLHTML,
  ACBrUtil.DateTime,
  ACBrMDFeConstantesTests;

{ ACBrMDFeRetEnvEventoTest }

procedure ACBrMDFeRetEnvEventoTest.SetUp;
begin
  inherited SetUp;

  FRetEnvEvento := TRetEventoMDFe.Create;
end;

procedure ACBrMDFeRetEnvEventoTest.TearDown;
begin
  FRetEnvEvento.Free;

  inherited TearDown;
end;

procedure ACBrMDFeRetEnvEventoTest.LoadFromFile_RetEnvEvento;
var
  sxml: string;
begin
  sxml := sxml_RetEnvEvento;

  FRetEnvEvento.XmlRetorno := ParseText(sxml);
  FRetEnvEvento.LerXML;

  CheckEquals('2', tpAmbToStr(FRetEnvEvento.retEvento[0].RetInfEvento.tpAmb), 'tpAmb valor incorreto');
  CheckEquals('SP-MDFe-2023-10-05-1', FRetEnvEvento.retEvento[0].RetInfEvento.verAplic, 'verAplic valor incorreto');
  CheckEquals(35, FRetEnvEvento.retEvento[0].RetInfEvento.cOrgao, 'cOrgao valor incorreto');
  CheckEquals(135, FRetEnvEvento.retEvento[0].RetInfEvento.cStat, 'cStat valor incorreto');
  CheckEquals('Evento registrado', FRetEnvEvento.retEvento[0].RetInfEvento.xMotivo, 'xMotivo valor incorreto');
  CheckEquals('12345678901234567890123456789012345678901234', FRetEnvEvento.retEvento[0].RetInfEvento.chMDFe, 'chMDFe valor incorreto');
  CheckEquals('110111', TpEventoToStr(FRetEnvEvento.retEvento[0].RetInfEvento.tpEvento), 'tpEvento valor incorreto');
  CheckEquals(1, FRetEnvEvento.retEvento[0].RetInfEvento.nSeqEvento, 'nSeqEvento valor incorreto');
  CheckEquals(EncodeDataHora('2023-10-23T17:15:05-03:00'), FRetEnvEvento.retEvento[0].RetInfEvento.dhRegEvento, 'dhRegEvento valor incorreto');
  CheckEquals('123456789012345', FRetEnvEvento.retEvento[0].RetInfEvento.nProt, 'nProt valor incorreto');
end;

procedure ACBrMDFeRetEnvEventoTest.LoadFromFile_Ret_Vazio;
var
  sxml: string;
begin
  sxml := sxml_Ret_Vazio;

  FRetEnvEvento.XmlRetorno := ParseText(sxml);
  FRetEnvEvento.LerXML;

  if FRetEnvEvento.retEvento.Count > 0 then
  begin
    CheckEquals('1', tpAmbToStr(FRetEnvEvento.retEvento[0].RetInfEvento.tpAmb), 'tpAmb valor incorreto');
    CheckEquals('', FRetEnvEvento.retEvento[0].RetInfEvento.verAplic, 'verAplic valor incorreto');
    CheckEquals(0, FRetEnvEvento.retEvento[0].RetInfEvento.cOrgao, 'cOrgao valor incorreto');
    CheckEquals(0, FRetEnvEvento.retEvento[0].RetInfEvento.cStat, 'cStat valor incorreto');
    CheckEquals('', FRetEnvEvento.retEvento[0].RetInfEvento.xMotivo, 'xMotivo valor incorreto');
    CheckEquals('', FRetEnvEvento.retEvento[0].RetInfEvento.chMDFe, 'chMDFe valor incorreto');
    CheckEquals('110111', TpEventoToStr(FRetEnvEvento.retEvento[0].RetInfEvento.tpEvento), 'tpEvento valor incorreto');
    CheckEquals(1, FRetEnvEvento.retEvento[0].RetInfEvento.nSeqEvento, 'nSeqEvento valor incorreto');
    CheckEquals(EncodeDataHora('2023-10-23T17:15:05-03:00'), FRetEnvEvento.retEvento[0].RetInfEvento.dhRegEvento, 'dhRegEvento valor incorreto');
    CheckEquals('', FRetEnvEvento.retEvento[0].RetInfEvento.nProt, 'nProt valor incorreto');
  end;
end;

initialization

  _RegisterTest('ACBrMDFeRetEnvEventoTests', ACBrMDFeRetEnvEventoTest);

end.
