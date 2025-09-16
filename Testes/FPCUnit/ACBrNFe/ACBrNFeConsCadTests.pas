unit ACBrNFeConsCadTests;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils, ACBrTests.Util,
  pcnConsCad, // Unit antiga que se encontra dentro da pasta PCNComum
  ACBrDFeComum.ConsCad; // Unit nova que se encontra dentro da pasta Comum

type

  { ACBrNFeRetConsSitTest }

  ACBrNFeRetConsSitTest = class(TTestCase)
  private
    FConsCad_Old: pcnConsCad.TConsCad;
    FConsCad_New: TConsCad;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure GerarXml_ConsCad;

  end;

implementation

uses
  ACBrConsts, ACBrXmlBase,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime,
  pcnConversao;

const
  SArquivoRetornoSoap  = '..\..\..\..\Recursos\NFSe\RetornoSoap.xml';
  SArquivoRetorno  = '..\..\..\..\Recursos\NFSe\Retorno.xml';
  UmMunicipioWebFisco = 3169356;

{ ACBrNFeRetConsSitTest }

procedure ACBrNFeRetConsSitTest.SetUp;
begin
  inherited SetUp;

  FConsCad_Old := pcnConsCad.TConsCad.Create;
end;

procedure ACBrNFeRetConsSitTest.TearDown;
begin
  FConsCad_Old.Free;

  inherited TearDown;
end;

procedure ACBrNFeRetConsSitTest.GerarXml_ConsCad;
var
  sxml_old, sxml_new: string;
begin
  sxml_old := '';
  sxml_new := '';

  //FConsCad_Old.Versao :=
  Fail('Não implementado');

  //FConsCad_Old.XmlRetorno := ParseText(sxml);
  //FConsCad_Old.LerXML;
  //
  //// Leitura do grupo <retConsSitNFe>
  //CheckEquals('4.00', FConsCad_Old.versao, 'Versao valor incorreto');
  //CheckEquals('2', tpAmbToStr(FConsCad_Old.tpAmb), 'tpAmb valor incorreto');
  //CheckEquals('SP_NFE_PL_006e', FConsCad_Old.verAplic, 'verAplic valor incorreto');
  //CheckEquals(100, FConsCad_Old.cStat, 'cStat valor incorreto');
  //CheckEquals('Autorizado o uso da NF-e', FConsCad_Old.xMotivo, 'xMotivo valor incorreto');
  //CheckEquals(35, FConsCad_Old.cUF, 'cUF valor incorreto');
  //CheckEquals('35100804550110000188550010000000101204117493', FConsCad_Old.chNFe, 'chNFe valor incorreto');
  //
  //// Leitura do grupo <infProt> que esta dentro do grupo <protNFe>
  //CheckEquals('2', TipoAmbienteToStr(FConsCad_Old.protNFe.tpAmb), 'tpAmb valor incorreto');
  //CheckEquals('SP_NFE_PL_006e', FConsCad_Old.protNFe.verAplic, 'verAplic valor incorreto');
  //CheckEquals('35100804550110000188550010000000101204117493', FConsCad_Old.protNFe.chDFe, 'chNFe valor incorreto');
  //CheckEquals(EncodeDataHora('2010-08-31T19:20:22'), FConsCad_Old.protNFe.dhRecbto, 'dhRecbto valor incorreto');
  //CheckEquals('135100025493261', FConsCad_Old.protNFe.nProt, 'nProt valor incorreto');
  //CheckEquals('PNG7OJ2WYLQyhkL2kWBykEGSVQA=', FConsCad_Old.protNFe.digVal, 'digVal valor incorreto');
  //CheckEquals(100, FConsCad_Old.protNFe.cStat, 'cStat valor incorreto');
  //CheckEquals('Autorizado o uso da NF-e', FConsCad_Old.protNFe.xMotivo, 'xMotivo valor incorreto');
  //CheckEquals(1, FConsCad_Old.protNFe.cMsg, 'cMsg valor incorreto');
  //CheckEquals('Autorizado', FConsCad_Old.protNFe.xMsg, 'xMsg valor incorreto');
  //
  //// Leitura do grupo <procEventoNFe>
  //CheckEquals('1.00', FConsCad_Old.procEventoNFe[0].RetEventoNFe.versao, 'Versao valor incorreto');
  //
  //// Leitura do grupo <infEvento> que esta dentro do grupo <evento>
  //CheckEquals(35, FConsCad_Old.procEventoNFe[0].RetEventoNFe.cOrgao, 'cOrgao valor incorreto');
  //CheckEquals('1', tpAmbToStr(FConsCad_Old.procEventoNFe[0].RetEventoNFe.tpAmb), 'tpAmb valor incorreto');
  //{
  //        idLote := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.idLote;
  //        tpAmb := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.tpAmb;
  //        verAplic := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.verAplic;
  //        cOrgao := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.cOrgao;
  //        cStat := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.cStat;
  //        xMotivo := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.xMotivo;
  //        XML := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.XML;
  //        }
end;

initialization

  _RegisterTest('ACBrNFeRetConsSitTests', ACBrNFeRetConsSitTest);

end.
