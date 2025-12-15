{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit Giss.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils, IniFiles,
  ACBrXmlDocument,
  ACBrNFSeXClass,
  ACBrNFSeXGravarXml_ABRASFv2;

type
  { TNFSeW_Giss204 }

  TNFSeW_Giss204 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

    function GerarCodigoPaisServico: TACBrXmlNode; override;
    function GerarCodigoPaisTomador: TACBrXmlNode; override;
    function GerarCodigoPaisTomadorExterior: TACBrXmlNode; override;
    function GerarServico: TACBrXmlNode; override;
    function GerarValores: TACBrXmlNode; override;
    function GerarTrib(trib: Ttrib): TACBrXmlNode;
    function GerarXMLTributacaoFederal: TACBrXmlNode;
    function GerarXMLTributacaoOutrosPisCofins: TACBrXmlNode;
    function GerarXMLTotalTributos: TACBrXmlNode;
    function GerarXMLPercentualTotalTributos: TACBrXmlNode;
    function GerarcomExt: TACBrXmlNode;
    function GerarEnderecoExteriorTomador: TACBrXmlNode; override;

    function GerarXMLIBSCBSValores(valores: Tvalorestrib): TACBrXmlNode; override;

    procedure GerarINISecaoValores(const AINIRec: TMemIniFile); override;
    procedure GerarINIValoresTribFederal(AINIRec: TMemIniFile);
    procedure GerarINIValoresTotalTrib(AINIRec: TMemIniFile);
    procedure GerarINIComercioExterior(AINIRec: TMemIniFile);
  end;

implementation

uses
  ACBrXmlBase,
  ACBrDFe.Conversao,
  ACBrNFSeXConsts,
  ACBrNFSeXConversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Giss
//==============================================================================

{ TNFSeW_Giss204 }

procedure TNFSeW_Giss204.Configuracao;
begin
  inherited Configuracao;

  NrOcorrCodigoPaisServico := 0;

  NrOcorrCodigoPaisTomador := -1;
  NrOcorrcCredPres := -1;
  NrOcorrDiscriminacao_1 := -1;
  NrOcorrCodigoMunic_1 := -1;

  NrOcorrDiscriminacao_2 := 1;
  NrOcorrCodigoMunic_2 := 1;
  NrOcorrExigibilidadeISS := 1;

  GerarDest := False;
  GerarImovel := False;
  GerarTribRegular := False;
  GerargDif := False;

  TagTomador := 'TomadorServico';
end;

function TNFSeW_Giss204.GerarCodigoPaisServico: TACBrXmlNode;
begin
  Result := AddNode(tcInt, '#35', 'CodigoPais', 4, 4, NrOcorrCodigoPaisServico,
                       CodIBGEPaisToCodISO(NFSe.Servico.CodigoPais), DSC_CPAIS);
end;

function TNFSeW_Giss204.GerarCodigoPaisTomador: TACBrXmlNode;
begin
  Result := AddNode(tcInt, '#44', 'CodigoPais', 4, 4, NrOcorrCodigoPaisTomador,
              CodIBGEPaisToCodISO(NFSe.Tomador.Endereco.CodigoPais), DSC_CPAIS);
end;

function TNFSeW_Giss204.GerarCodigoPaisTomadorExterior: TACBrXmlNode;
begin
  Result := AddNode(tcInt, '#38', 'CodigoPais', 4, 4, 0,
              CodIBGEPaisToCodISO(NFSe.Tomador.Endereco.CodigoPais), DSC_CPAIS);
end;

function TNFSeW_Giss204.GerarTrib(trib: Ttrib): TACBrXmlNode;
begin
  Result := CreateElement('trib');

  Result.AppendChild(GerarXMLTributacaoFederal);
  Result.AppendChild(GerarXMLTotalTributos);
end;

function TNFSeW_Giss204.GerarServico: TACBrXmlNode;
begin
  Result := inherited GerarServico;

    Result.AppendChild(GerarcomExt);
end;

function TNFSeW_Giss204.GerarcomExt: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Servico.comExt.vServMoeda > 0 then
  begin
    Result := CreateElement('comExt');

    Result.AppendChild(AddNode(tcStr, '#1', 'mdPrestacao', 1, 1, 1,
                        mdPrestacaoToStr(NFSe.Servico.comExt.mdPrestacao), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'vincPrest', 1, 1, 1,
                            vincPrestToStr(NFSe.Servico.comExt.vincPrest), ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'tpMoeda', 3, 3, 1,
                                              NFSe.Servico.comExt.tpMoeda, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vServMoeda', 1, 15, 1,
                                           NFSe.Servico.comExt.vServMoeda, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'mecAFComexP', 2, 2, 1,
                        mecAFComexPToStr(NFSe.Servico.comExt.mecAFComexP), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'mecAFComexT', 2, 2, 1,
                        mecAFComexTToStr(NFSe.Servico.comExt.mecAFComexT), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'movTempBens', 1, 1, 1,
                        movTempBensToStr(NFSe.Servico.comExt.movTempBens), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'nDI', 1, 12, 0,
                                                  NFSe.Servico.comExt.nDI, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'nRE', 1, 12, 0,
                                                  NFSe.Servico.comExt.nRE, ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'mdic', 1, 1, 1,
                                                 NFSe.Servico.comExt.mdic, ''));
  end;
end;

function TNFSeW_Giss204.GerarEnderecoExteriorTomador: TACBrXmlNode;
begin
  Result := inherited GerarEnderecoExteriorTomador;

  if NFSe.Tomador.Endereco.CEP <> '' then
  begin
    Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                                NFSe.Tomador.Endereco.CEP, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                         NFSe.Tomador.Endereco.xMunicipio, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                                 NFSe.Tomador.Endereco.UF, ''));
  end;
end;

function TNFSeW_Giss204.GerarValores: TACBrXmlNode;
begin
  Result := inherited GerarValores;

  // Reforma Tributária
  if NFSe.Servico.Valores.tribFed.CST <> cstVazio then
    Result.AppendChild(GerarTrib(NFSe.IBSCBS.valores.trib));

  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
    Result.AppendChild(GerarXMLIBSCBS(NFSe.IBSCBS));
end;

function TNFSeW_Giss204.GerarXMLIBSCBSValores(
  valores: Tvalorestrib): TACBrXmlNode;
begin
  Result := inherited GerarXMLIBSCBSValores(valores);

  Result.AppendChild(AddNode(tcInt, '#1', 'cLocalidadeIncid', 7, 7, 1,
                                     NFSe.infNFSe.IBSCBS.cLocalidadeIncid, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedutor', 1, 7, 1,
                                             NFSe.infNFSe.IBSCBS.pRedutor, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vBC', 1, 15, 0,
                                          NFSe.infNFSe.IBSCBS.Valores.vBC, ''));
end;

function TNFSeW_Giss204.GerarXMLTributacaoFederal: TACBrXmlNode;
begin
  Result := CreateElement('tribFed');

  if NFSe.Servico.Valores.tribFed.CST <> cstVazio then
    Result.AppendChild(GerarXMLTributacaoOutrosPisCofins);
  {
  if (NFSe.Servico.Valores.tribFed.vRetCP > 0) or
     (NFSe.Servico.Valores.tribFed.vRetIRRF > 0) or
     (NFSe.Servico.Valores.tribFed.vRetCSLL > 0) then
  begin
    Result.AppendChild(AddNode(tcDe2, '#1', 'vRetCP', 1, 15, 0,
                                      NFSe.Servico.Valores.tribFed.vRetCP, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vRetIRRF', 1, 15, 0,
                                    NFSe.Servico.Valores.tribFed.vRetIRRF, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vRetCSLL', 1, 15, 0,
                                    NFSe.Servico.Valores.tribFed.vRetCSLL, ''));
  end;
  }
end;

function TNFSeW_Giss204.GerarXMLTributacaoOutrosPisCofins: TACBrXmlNode;
var
  NOcorr: Integer;
begin
  Result := CreateElement('piscofins');

  Result.AppendChild(AddNode(tcStr, '#1', 'CST', 2, 2, 1,
                               CSTToStr(NFSe.Servico.Valores.tribFed.CST), ''));

  if (NFSe.Servico.Valores.tribFed.vBCPisCofins > 0) or
     (NFSe.Servico.Valores.tribFed.pAliqPis > 0) or
     (NFSe.Servico.Valores.tribFed.pAliqCofins > 0) or
     (NFSe.Servico.Valores.tribFed.vPis > 0) or
     (NFSe.Servico.Valores.tribFed.vCofins > 0) or
     (NFSe.Servico.Valores.tribFed.CST in [cst04, cst06]) then
  begin
    NOcorr := 0;

    if NFSe.Servico.Valores.tribFed.CST in [cst04, cst06] then
      NOcorr := 1;

    Result.AppendChild(AddNode(tcDe2, '#1', 'vBCPisCofins', 1, 15, 0,
                                NFSe.Servico.Valores.tribFed.vBCPisCofins, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqPis', 1, 5, NOcorr,
                                    NFSe.Servico.Valores.tribFed.pAliqPis, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqCofins', 1, 5, NOcorr,
                                 NFSe.Servico.Valores.tribFed.pAliqCofins, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vPis', 1, 15, 0,
                                        NFSe.Servico.Valores.tribFed.vPis, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vCofins', 1, 15, 0,
                                     NFSe.Servico.Valores.tribFed.vCofins, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'tpRetPisCofins', 1, 1, 0,
         tpRetPisCofinsToStr(NFSe.Servico.Valores.tribFed.tpRetPisCofins), ''));
  end;
end;

function TNFSeW_Giss204.GerarXMLTotalTributos: TACBrXmlNode;
begin
  Result := CreateElement('totTrib');

  if (NFSe.Servico.Valores.totTrib.pTotTribFed > 0) or
     (NFSe.Servico.Valores.totTrib.pTotTribEst > 0) or
     (NFSe.Servico.Valores.totTrib.pTotTribMun > 0) then
    Result.AppendChild(GerarXMLPercentualTotalTributos)
  else
    Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribSN', 1, 5, 1,
                                  NFSe.Servico.Valores.totTrib.pTotTribSN, ''));
end;

function TNFSeW_Giss204.GerarXMLPercentualTotalTributos: TACBrXmlNode;
begin
  Result := CreateElement('pTotTrib');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribFed', 1, 5, 1,
                                 NFSe.Servico.Valores.totTrib.pTotTribFed, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribEst', 1, 5, 1,
                                 NFSe.Servico.Valores.totTrib.pTotTribEst, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribMun', 1, 5, 1,
                                 NFSe.Servico.Valores.totTrib.pTotTribMun, ''));
end;

procedure TNFSeW_Giss204.GerarINISecaoValores(const AINIRec: TMemIniFile);
begin
  GerarINIComercioExterior(AINIRec);

  inherited GerarINISecaoValores(AINIRec);

  GerarINIValoresTribFederal(AINIRec);
  GerarINIValoresTotalTrib(AINIRec);

  // Reforma Tributária
  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
  begin
    GerarINIIBSCBS(AINIRec, NFSe.IBSCBS);
//    GerarINIIBSCBSNFSe(AINIRec, NFSe.infNFSe.IBSCBS);
  end;
end;

procedure TNFSeW_Giss204.GerarINIValoresTribFederal(AINIRec: TMemIniFile);
begin
  LSecao := 'tribFederal';

  AINIRec.WriteString(LSecao, 'CST', CSTToStr(NFSe.Servico.Valores.tribFed.CST));
  AINIRec.WriteFloat(LSecao, 'vBCPisCofins', NFSe.Servico.Valores.tribFed.vBCPisCofins);
  AINIRec.WriteFloat(LSecao, 'pAliqPis', NFSe.Servico.Valores.tribFed.pAliqPis);
  AINIRec.WriteFloat(LSecao, 'pAliqCofins', NFSe.Servico.Valores.tribFed.pAliqCofins);
  AINIRec.WriteFloat(LSecao, 'vPis', NFSe.Servico.Valores.tribFed.vPis);
  AINIRec.WriteFloat(LSecao, 'vCofins', NFSe.Servico.Valores.tribFed.vCofins);
  AINIRec.WriteString(LSecao, 'tpRetPisCofins', tpRetPisCofinsToStr(NFSe.Servico.Valores.tribFed.tpRetPisCofins));
  AINIRec.WriteFloat(LSecao, 'vRetCP', NFSe.Servico.Valores.tribFed.vRetCP);
  AINIRec.WriteFloat(LSecao, 'vRetIRRF', NFSe.Servico.Valores.tribFed.vRetIRRF);
  AINIRec.WriteFloat(LSecao, 'vRetCSLL', NFSe.Servico.Valores.tribFed.vRetCSLL);
end;

procedure TNFSeW_Giss204.GerarINIValoresTotalTrib(AINIRec: TMemIniFile);
begin
  LSecao := 'totTrib';

  AINIRec.WriteString(LSecao, 'indTotTrib', indTotTribToStr(NFSe.Servico.Valores.totTrib.indTotTrib));
  AINIRec.WriteFloat(LSecao, 'pTotTribSN', NFSe.Servico.Valores.totTrib.pTotTribSN);
  AINIRec.WriteFloat(LSecao, 'vTotTribFed', NFSe.Servico.Valores.totTrib.vTotTribFed);
  AINIRec.WriteFloat(LSecao, 'vTotTribEst', NFSe.Servico.Valores.totTrib.vTotTribEst);
  AINIRec.WriteFloat(LSecao, 'vTotTribMun', NFSe.Servico.Valores.totTrib.vTotTribMun);
  AINIRec.WriteFloat(LSecao, 'pTotTribFed', NFSe.Servico.Valores.totTrib.pTotTribFed);
  AINIRec.WriteFloat(LSecao, 'pTotTribEst', NFSe.Servico.Valores.totTrib.pTotTribEst);
  AINIRec.WriteFloat(LSecao, 'pTotTribMun', NFSe.Servico.Valores.totTrib.pTotTribMun);
end;

procedure TNFSeW_Giss204.GerarINIComercioExterior(AINIRec: TMemIniFile);
begin
  LSecao := 'ComercioExterior';

  AINIRec.WriteString(LSecao, 'mdPrestacao', mdPrestacaoToStr(NFSe.Servico.comExt.mdPrestacao));
  AINIRec.WriteString(LSecao, 'vincPrest', vincPrestToStr(NFSe.Servico.comExt.vincPrest));
  AINIRec.WriteInteger(LSecao, 'tpMoeda', NFSe.Servico.comExt.tpMoeda);
  AINIRec.WriteFloat(LSecao, 'vServMoeda', NFSe.Servico.comExt.vServMoeda);
  AINIRec.WriteString(LSecao, 'mecAFComexP', mecAFComexPToStr(NFSe.Servico.comExt.mecAFComexP));
  AINIRec.WriteString(LSecao, 'mecAFComexT', mecAFComexTToStr(NFSe.Servico.comExt.mecAFComexT));
  AINIRec.WriteString(LSecao, 'movTempBens', MovTempBensToStr(NFSe.Servico.comExt.movTempBens));
  AINIRec.WriteString(LSecao, 'nDI', NFSe.Servico.comExt.nDI);
  AINIRec.WriteString(LSecao, 'nRE', NFSe.Servico.comExt.nRE);
  AINIRec.WriteInteger(LSecao, 'mdic', NFSe.Servico.comExt.mdic);
end;

end.
