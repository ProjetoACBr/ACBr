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

unit Ginfes.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils, IniFiles,
  ACBrXmlDocument,
  ACBrNFSeXClass,
  ACBrDFe.Conversao,
  ACBrNFSeXConversao,
  ACBrNFSeXGravarXml_ABRASFv1;

type
  { TNFSeW_Ginfes }

  TNFSeW_Ginfes = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

    function GerarCodigoPaisTomador: TACBrXmlNode;
    function GerarCodigoPaisTomadorExterior: TACBrXmlNode;
    function GerarServico: TACBrXmlNode; override;
    function GerarValores: TACBrXmlNode; override;
    function GerarTrib(trib: Ttrib): TACBrXmlNode;
    function GerarXMLTributacaoFederal: TACBrXmlNode;
    function GerarXMLTributacaoOutrosPisCofins: TACBrXmlNode;
    function GerarXMLTotalTributos: TACBrXmlNode;
    function GerarXMLPercentualTotalTributos: TACBrXmlNode;
    function GerarcomExt: TACBrXmlNode;
    function GerarTomador: TACBrXmlNode; override;
    function GerarEnderecoExteriorTomador: TACBrXmlNode;

    function GerarXMLIBSCBSTribValores(valores: Tvalorestrib): TACBrXmlNode; override;

    procedure GerarINISecaoValores(const AINIRec: TMemIniFile); override;
    procedure GerarINIValoresTribFederal(AINIRec: TMemIniFile);
    procedure GerarINIValoresTotalTrib(AINIRec: TMemIniFile);
    procedure GerarINIComercioExterior(AINIRec: TMemIniFile);
  public
    function GerarXml: Boolean; Override;

  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrNFSeXConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Ginfes
//==============================================================================

{ TNFSeW_Ginfes }

procedure TNFSeW_Ginfes.Configuracao;
begin
  inherited Configuracao;

  NrOcorrValorPis := 1;
  NrOcorrValorCofins := 1;
  NrOcorrValorInss := 1;
  NrOcorrValorIr := 1;
  NrOcorrValorCsll := 1;
  NrOcorrValorIss := 1;
  DivAliq100  := True;

  if FpAOwner.ConfigGeral.Params.TemParametro('NaoDividir100') then
    DivAliq100 := False;

  PrefixoPadrao := 'ns4';

  GerarTagTomadorMesmoVazia := True;
end;

function TNFSeW_Ginfes.GerarCodigoPaisTomador: TACBrXmlNode;
begin
  Result := AddNode(tcInt, '#44', 'CodigoPais', 4, 4, NrOcorrCodigoPaisTomador,
              CodIBGEPaisToCodISO(NFSe.Tomador.Endereco.CodigoPais), DSC_CPAIS);
end;

function TNFSeW_Ginfes.GerarCodigoPaisTomadorExterior: TACBrXmlNode;
begin
  Result := AddNode(tcInt, '#38', 'CodigoPais', 4, 4, 0,
              CodIBGEPaisToCodISO(NFSe.Tomador.Endereco.CodigoPais), DSC_CPAIS);
end;

function TNFSeW_Ginfes.GerarTomador: TACBrXmlNode;
begin
  Result := nil;

  if GerarTagTomadorMesmoVazia then
    Result := CreateElement('Tomador');

  if (NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '') or
     (NFSe.Tomador.RazaoSocial <> '') or
     (NFSe.Tomador.Endereco.Endereco <> '') or
     (NFSe.Tomador.Contato.Telefone <> '') or
     (NFSe.Tomador.Contato.Email <>'') then
  begin
    if not GerarTagTomadorMesmoVazia then
      Result := CreateElement('Tomador');

    if (NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '') or
       (NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal <> '') then
    begin
      Result.AppendChild(GerarIdentificacaoTomador);
    end;

    Result.AppendChild(AddNode(tcStr, '#38', 'RazaoSocial', 1, 115, 0,
                                          NFSe.Tomador.RazaoSocial, DSC_XNOME));

    if (NFSe.Tomador.Endereco.CodigoPais <> 1058) then
      Result.AppendChild(GerarEnderecoExteriorTomador)
    else
      Result.AppendChild(GerarEnderecoTomador);

    Result.AppendChild(GerarContatoTomador);
  end;
end;

function TNFSeW_Ginfes.GerarTrib(trib: Ttrib): TACBrXmlNode;
begin
  Result := CreateElement('trib');

  Result.AppendChild(GerarXMLTributacaoFederal);
  Result.AppendChild(GerarXMLTotalTributos);
end;

function TNFSeW_Ginfes.GerarServico: TACBrXmlNode;
begin
  Result := inherited GerarServico;

  if Now >= EncodeDate(2026, 1, 1) then
    Result.AppendChild(AddNode(tcStr, '#32', 'CodigoNbs', 1, 9, 0,
                                 OnlyNumber(NFSe.Servico.CodigoNBS), DSC_CMUN));

  Result.AppendChild(GerarcomExt);
end;

function TNFSeW_Ginfes.GerarcomExt: TACBrXmlNode;
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

function TNFSeW_Ginfes.GerarEnderecoExteriorTomador: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Tomador.Endereco.Endereco <> '' then
  begin
    Result := CreateElement('EnderecoExterior');

    Result.AppendChild(GerarCodigoPaisTomadorExterior);

    Result.AppendChild(AddNode(tcStr, '#39', 'EnderecoCompletoExterior', 1, 255, 0,
                                     NFSe.Tomador.Endereco.Endereco, DSC_XLGR));

    Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                                NFSe.Tomador.Endereco.CEP, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                         NFSe.Tomador.Endereco.xMunicipio, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                                 NFSe.Tomador.Endereco.UF, ''));
  end;
end;

function TNFSeW_Ginfes.GerarValores: TACBrXmlNode;
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

function TNFSeW_Ginfes.GerarXMLIBSCBSTribValores(
  valores: Tvalorestrib): TACBrXmlNode;
begin
  Result := inherited GerarXMLIBSCBSTribValores(valores);

  Result.AppendChild(AddNode(tcInt, '#1', 'cLocalidadeIncid', 7, 7, 1,
                                     NFSe.infNFSe.IBSCBS.cLocalidadeIncid, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedutor', 1, 7, 1,
                                             NFSe.infNFSe.IBSCBS.pRedutor, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vBC', 1, 15, 0,
                                          NFSe.infNFSe.IBSCBS.Valores.vBC, ''));
end;

function TNFSeW_Ginfes.GerarXMLTributacaoFederal: TACBrXmlNode;
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

function TNFSeW_Ginfes.GerarXMLTributacaoOutrosPisCofins: TACBrXmlNode;
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

function TNFSeW_Ginfes.GerarXMLTotalTributos: TACBrXmlNode;
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

function TNFSeW_Ginfes.GerarXMLPercentualTotalTributos: TACBrXmlNode;
begin
  Result := CreateElement('pTotTrib');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribFed', 1, 5, 1,
                                 NFSe.Servico.Valores.totTrib.pTotTribFed, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribEst', 1, 5, 1,
                                 NFSe.Servico.Valores.totTrib.pTotTribEst, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribMun', 1, 5, 1,
                                 NFSe.Servico.Valores.totTrib.pTotTribMun, ''));
end;

procedure TNFSeW_Ginfes.GerarINISecaoValores(const AINIRec: TMemIniFile);
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

procedure TNFSeW_Ginfes.GerarINIValoresTribFederal(AINIRec: TMemIniFile);
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

procedure TNFSeW_Ginfes.GerarINIValoresTotalTrib(AINIRec: TMemIniFile);
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

procedure TNFSeW_Ginfes.GerarINIComercioExterior(AINIRec: TMemIniFile);
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

function TNFSeW_Ginfes.GerarXml: Boolean;
begin
  if NFSe.OptanteSimplesNacional = snSim then
    NrOcorrAliquota := 1;

  Result := inherited GerarXml;
end;

end.
