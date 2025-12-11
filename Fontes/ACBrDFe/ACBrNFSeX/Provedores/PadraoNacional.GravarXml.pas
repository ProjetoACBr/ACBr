{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit PadraoNacional.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils, IniFiles,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXClass,
  ACBrNFSeXGravarXml;

type
  { TNFSeW_PadraoNacional }

  TNFSeW_PadraoNacional = class(TNFSeWClass)
  private
    FpVersao: string;

  protected
    LSecao: string;

    function GerarChaveDPS(const AcMun, ACNPJCPF, ASerie, ANumero: string): string;
    function GerarChaveNFSe(const AcMun, AAmbGer, ACNPJCPF,
      ANumero, AUF: string; ADataEmis: TDateTime; ACodNum: Int64): string;

    function GerarXMLNFSe: TACBrXmlNode;
    function GerarXMLInfNFSe: TACBrXmlNode;
    function GerarXMLEmitente: TACBrXmlNode;
    function GerarXMLEnderecoEmitente: TACBrXmlNode;
    function GerarXMLValoresNFSe: TACBrXmlNode;
    function GerarXMLDPS: TACBrXmlNode;

    function GerarXMLInfDps: TACBrXmlNode;

    function GerarXMLSubstituicao: TACBrXmlNode;

    function GerarXMLPrestador: TACBrXmlNode;
    function GerarXMLEnderecoPrestador: TACBrXmlNode;
    function GerarXMLEnderecoNacionalPrestador: TACBrXmlNode;
    function GerarXMLEnderecoExteriorPrestador: TACBrXmlNode;
    function GerarXMLRegimeTributacaoPrestador: TACBrXmlNode;

    function GerarXMLTomador: TACBrXmlNode;
    function GerarXMLEnderecoTomador: TACBrXmlNode;
    function GerarXMLEnderecoNacionalTomador: TACBrXmlNode;
    function GerarXMLEnderecoExteriorTomador: TACBrXmlNode;

    function GerarXMLIntermediario: TACBrXmlNode;
    function GerarXMLEnderecoIntermediario: TACBrXmlNode;
    function GerarXMLEnderecoNacionalIntermediario: TACBrXmlNode;
    function GerarXMLEnderecoExteriorIntermediario: TACBrXmlNode;

    function GerarXMLServico: TACBrXmlNode;
    function GerarXMLLocalPrestacao: TACBrXmlNode;
    function GerarXMLCodigoServico: TACBrXmlNode;
    function GerarXMLComercioExterior: TACBrXmlNode;
    function GerarXMLLocacaoSubLocacao: TACBrXmlNode;
    function GerarXMLObra: TACBrXmlNode;
    function GerarXMLEnderecoObra: TACBrXmlNode;
    function GerarXMLEnderecoExteriorObra: TACBrXmlNode;
    function GerarXMLAtividadeEvento: TACBrXmlNode;
    function GerarXMLEnderecoEvento: TACBrXmlNode;
    function GerarXMLEnderecoExteriorEvento: TACBrXmlNode;
    function GerarXMLExploracaoRodoviaria: TACBrXmlNode;
    function GerarXMLInformacoesComplementares: TACBrXmlNode;

    function GerarXMLValores: TACBrXmlNode;

    function GerarXMLServicoPrestado: TACBrXmlNode;
    function GerarXMLDescontos: TACBrXmlNode;
    function GerarXMLDeducoes: TACBrXmlNode;
    function GerarXMLDocDeducoes: TACBrXmlNode;
    function GerarXMLListaDocDeducoes: TACBrXmlNodeArray;
    function GerarXMLNFSeMunicipio(Item: Integer): TACBrXmlNode;
    function GerarXMLNFNFS(Item: Integer): TACBrXmlNode;

    function GerarXMLFornecedor(Item: Integer): TACBrXmlNode;
    function GerarXMLEnderecoFornecedor(Item: Integer): TACBrXmlNode;
    function GerarXMLEnderecoNacionalFornecedor(Item: Integer): TACBrXmlNode;
    function GerarXMLEnderecoExteriorFornecedor(Item: Integer): TACBrXmlNode;

    function GerarXMLTributacao: TACBrXmlNode;
    function GerarXMLTributacaoMunicipal: TACBrXmlNode;
    function GerarXMLBeneficioMunicipal: TACBrXmlNode;
    function GerarXMLExigibilidadeSuspensa: TACBrXmlNode;
    function GerarXMLTributacaoFederal: TACBrXmlNode;
    function GerarXMLTributacaoOutrosPisCofins: TACBrXmlNode;
    function GerarXMLTotalTributos: TACBrXmlNode;
    function GerarXMLValorTotalTributos: TACBrXmlNode;
    function GerarXMLPercentualTotalTributos: TACBrXmlNode;

    //====== Gerar o Arquivo INI=========================================
    procedure GerarINIIdentificacaoNFSe(const AINIRec: TMemIniFile);
    procedure GerarINIIdentificacaoRps(AINIRec: TMemIniFile);
    procedure GerarININFSeSubstituicao(AINIRec: TMemIniFile);
    procedure GerarINIDadosPrestador(AINIRec: TMemIniFile);
    procedure GerarINIDadosTomador(AINIRec: TMemIniFile);
    procedure GerarINIDadosIntermediario(AINIRec: TMemIniFile);
    procedure GerarINIDadosServico(AINIRec: TMemIniFile);
    procedure GerarINIComercioExterior(AINIRec: TMemIniFile);
    procedure GerarINILocacaoSubLocacao(AINIRec: TMemIniFile);
    procedure GerarINIConstrucaoCivil(AINIRec: TMemIniFile);
    procedure GerarINIEvento(AINIRec: TMemIniFile);
    procedure GerarINIRodoviaria(AINIRec: TMemIniFile);
    procedure GerarINIInformacoesComplementares(AINIRec: TMemIniFile);
    procedure GerarINIValores(AINIRec: TMemIniFile);
    procedure GerarINIDocumentosDeducoes(AINIRec: TMemIniFile);
    procedure GerarINIDocumentosDeducoesFornecedor(AINIRec: TMemIniFile;
      fornec: TInfoPessoa; Indice: Integer);
    procedure GerarINIValoresTribMun(AINIRec: TMemIniFile);
    procedure GerarINIValoresTribFederal(AINIRec: TMemIniFile);
    procedure GerarINIValoresTotalTrib(AINIRec: TMemIniFile);
    // NFS-e
    procedure GerarINIDadosEmitente(const AINIRec: TMemIniFile);
    procedure GerarINIValoresNFSe(const AINIRec: TMemIniFile);

    procedure GerarIniRps(AINIRec: TMemIniFile);
    procedure GerarIniNfse(AINIRec: TMemIniFile);
  public
    function GerarXml: Boolean; override;
    function GerarIni: string; override;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrNFSeXConsts,
  ACBrDFe.Conversao,
  ACBrNFSeXConversao,
  ACBrValidador;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     PadraoNacional
//==============================================================================

{ TNFSeW_PadraoNacional }

function TNFSeW_PadraoNacional.GerarChaveDPS(const AcMun, ACNPJCPF, ASerie,
  ANumero: string): string;
var
  cMun, vSerie, vNumero, vCNPJ, tpInsc: string;
begin
  {
  A regra de formação do identificador de 45 posições da DPS é:
  "DPS" + Cód.Mun (7) + Tipo de Inscrição Federal (1) +
  Inscrição Federal (14 - CPF completar com 000 à esquerda) + Série DPS (5)+
  Núm. DPS (15)
  }
  cMun  := Poem_Zeros(AcMun, 7);
  vCNPJ := OnlyNumber(ACNPJCPF);

  if Length(vCNPJ) = 11 then
    tpInsc := '1'
  else
    tpInsc := '2';

  vCNPJ   := PadLeft(vCNPJ, 14, '0');
  vSerie  := Poem_Zeros(ASerie, 5);
  vNumero := Poem_Zeros(ANumero, 15);

  Result := cMun + tpInsc + vCNPJ + vSerie + vNumero;
end;

function TNFSeW_PadraoNacional.GerarChaveNFSe(const AcMun, AAmbGer, ACNPJCPF,
  ANumero, AUF: string; ADataEmis: TDateTime; ACodNum: Int64): string;
var
  cMun, vCodNum, vNumero, vCNPJ, tpInsc, vDataEmis: string;
begin
    {
    A formação do identificador de 53 posições da NFS é:

    "NFS" + Cód.Mun. (7) + Amb.Ger. (1) + Tipo de Inscrição Federal (1) +
    Inscrição Federal (14 - CPF completar com 000 à esquerda) +
    nNFSe (13) + AnoMes Emis. da DPS (4) + Cód.Num. (9) + DV (1)

    Código numérico de 9 Posições numérico, aleatório,
    gerado automaticamente pelo sistema gerador da NFS-e.
    }

  cMun  := Poem_Zeros(AcMun, 7);
  vCNPJ := OnlyNumber(ACNPJCPF);

  if Length(vCNPJ) = 11 then
    tpInsc := '1'
  else
    tpInsc := '2';

  vCNPJ   := PadLeft(vCNPJ, 14, '0');
  vNumero := Poem_Zeros(ANumero, 13);
  vDataEmis := FormatDateTime('YYMM', AjustarDataHoraParaUf(ADataEmis, AUF));
  vCodNum  := Poem_Zeros(ACodNum, 9);

  Result := cMun + AAmbGer + tpInsc + vCNPJ + vNumero + vDataEmis + vCodNum;
  Result := Result + Modulo11(Result);
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoEmitente: TACBrXmlNode;
begin
  Result := CreateElement('enderNac');

  Result.AppendChild(AddNode(tcStr, '#1', 'xLgr', 1, 255, 1,
                                          NFSe.Emitente.Endereco.Endereco, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'nro', 1, 60, 1,
                                            NFSe.Emitente.Endereco.Numero, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCpl', 1, 156, 0,
                                       NFSe.Emitente.Endereco.Complemento, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xBairro', 1, 60, 1,
                                            NFSe.Emitente.Endereco.Bairro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cMun', 7, 7, 1,
                                   NFSe.Emitente.Endereco.CodigoMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'UF', 2, 2, 1,
                                                NFSe.Emitente.Endereco.UF, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 8, 8, 1,
                                               NFSe.Emitente.Endereco.CEP, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLEmitente: TACBrXmlNode;
begin
  Result := CreateElement('emit');

  if NFSe.Emitente.IdentificacaoPrestador.CpfCnpj <> '' then
    Result.AppendChild(AddNodeCNPJCPF('#1', '#1',
                                  NFSe.Emitente.IdentificacaoPrestador.CpfCnpj))
  else
  begin
    if NFSe.Emitente.IdentificacaoPrestador.Nif <> '' then
      Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                  NFSe.Emitente.IdentificacaoPrestador.Nif, ''))
    else
      Result.AppendChild(AddNode(tcStr, '#1', 'cNaoNIF', 1, 1, 1,
                NaoNIFToStr(NFSe.Emitente.IdentificacaoPrestador.cNaoNIF), ''));
  end;

  Result.AppendChild(AddNode(tcStr, '#1', 'CAEPF', 1, 14, 0,
                               NFSe.Emitente.IdentificacaoPrestador.CAEPF, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IM', 1, 15, 0,
                  NFSe.Emitente.IdentificacaoPrestador.InscricaoMunicipal, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 300, 0,
                                                NFSe.Emitente.RazaoSocial, ''));

  Result.AppendChild(GerarXMLEnderecoEmitente);

  Result.AppendChild(AddNode(tcStr, '#1', 'fone', 6, 20, 0,
                                           NFSe.Emitente.Contato.Telefone, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'email', 1, 80, 0,
                                              NFSe.Emitente.Contato.Email, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLValoresNFSe: TACBrXmlNode;
var
  vISSQN, vTotalRet: Double;
begin
  Result := CreateElement('valores');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vBC', 1, 15, 0,
                                         NFSe.infNFSe.Valores.BaseCalculo, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqAplic', 1, 15, 0,
                                            NFSe.infNFSe.Valores.Aliquota, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vISSQN', 1, 15, 0,
                                            NFSe.infNFSe.Valores.ValorIss, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vTotalRet', 1, 15, 0,
                                           NFSe.infNFSe.Valores.vTotalRet, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vLiq', 1, 15, 0,
                                    NFSe.infNFSe.Valores.ValorLiquidoNfse, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLDPS: TACBrXmlNode;
var
  chave: string;
  xmlNode: TACBrXmlNode;
begin
  chave := GerarChaveDPS(NFSe.Prestador.Endereco.CodigoMunicipio,
                         NFSe.Prestador.IdentificacaoPrestador.CpfCnpj,
                         NFSe.IdentificacaoRps.Serie,
                         NFSe.IdentificacaoRps.Numero);

  NFSe.InfID.ID := 'DPS' + chave;

  Result := CreateElement('DPS');
  Result.SetAttribute('versao', FpVersao);
  Result.SetNamespace(FpAOwner.ConfigMsgDados.LoteRps.xmlns, Self.PrefixoPadrao);

  xmlNode := GerarXMLInfDps;
  Result.AppendChild(xmlNode);
end;

function TNFSeW_PadraoNacional.GerarXMLInfNFSe: TACBrXmlNode;
var
  chave, xLocEmi, xUF, xLocPrestacao, xLocIncid: string;
  xmlNode: TACBrXmlNode;
begin
  chave := GerarChaveNFSe(NFSe.Prestador.Endereco.CodigoMunicipio,
                         ambGerToStr(NFSe.infNFSe.ambGer),
                         NFSe.Prestador.IdentificacaoPrestador.CpfCnpj,
                         NFSe.infNFSe.nNFSe,
                         NFSe.Prestador.Endereco.UF,
                         NFSe.infNFSe.dhProc,
                         StrToInt64Def(NFSe.infNFSe.nDFSe, 1));

  chave := 'NFS' + chave;

  Result := CreateElement('infNFSe');
  Result.SetAttribute(FpAOwner.ConfigGeral.Identificador, chave);

  if NFSe.cLocEmi <> '' then
    xLocEmi := ObterNomeMunicipioUF(StrToIntDef(NFSe.cLocEmi, 0), xUF)
  else
  begin
    case NFSe.tpEmit of
      teTomador:
        xLocEmi := ObterNomeMunicipioUF(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0), xUF);
      teIntermediario:
        xLocEmi := ObterNomeMunicipioUF(StrToIntDef(NFSe.Intermediario.Endereco.CodigoMunicipio, 0), xUF);
    else
      xLocEmi := ObterNomeMunicipioUF(StrToIntDef(NFSe.Prestador.Endereco.CodigoMunicipio, 0), xUF);
    end;
  end;

  Result.AppendChild(AddNode(tcStr, '#1', 'xLocEmi', 1, 1, 1, xLocEmi, ''));

  xLocPrestacao := ObterNomeMunicipioUF(StrToIntDef(NFSe.Servico.CodigoMunicipio, 0), xUF);

  Result.AppendChild(AddNode(tcStr, '#1', 'xLocPrestacao', 1, 1, 1,
                                                            xLocPrestacao, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'nNFSe', 1, 1, 1,
                                                       NFSe.infNFSe.nNFSe, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cLocIncid', 1, 1, 1,
                                  NFSe.Prestador.Endereco.CodigoMunicipio, ''));

  xLocIncid := ObterNomeMunicipioUF(StrToIntDef(NFSe.Prestador.Endereco.CodigoMunicipio, 0), xUF);

  Result.AppendChild(AddNode(tcStr, '#1', 'xLocIncid', 1, 1, 1,
                                                            xLocIncid, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xTribNac', 1, 1, 1,
                                            NFSe.Servico.ItemListaServico, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'verAplic', 1, 20, 1,
                                                            NFSe.verAplic, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'ambGer', 1, 1, 1,
                                         ambGerToStr(NFSe.infNFSe.ambGer), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tpEmis', 1, 1, 1,
                                         tpEmisToStr(NFSe.infNFSe.tpEmis), ''));

  Result.AppendChild(AddNode(tcInt, '#1', 'cStat', 1, 3, 1, '100', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tpAmb', 1, 1, NrOcorrtpAmb,
                                              TipoAmbienteToStr(Ambiente), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'dhProc', 25, 25, 1,
                  DateTimeTodh(NFSe.infNFSe.dhProc) +
                  GetUTC(NFSe.Prestador.Endereco.UF, NFSe.infNFSe.dhProc), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'nDFSe', 1, 9, 1,
                                                       NFSe.infNFSe.nDFSe, ''));

  xmlNode := GerarXMLEmitente;
  Result.AppendChild(xmlNode);

  xmlNode := GerarXMLValoresNFSe;
  Result.AppendChild(xmlNode);

  xmlNode := GerarXMLDPS;
  Result.AppendChild(xmlNode);
end;

function TNFSeW_PadraoNacional.GerarXMLNFSe: TACBrXmlNode;
var
  xmlNode: TACBrXmlNode;
begin
  FpVersao := VersaoNFSeToStr(VersaoNFSe);

  Result := CreateElement('NFSe');
  Result.SetAttribute('versao', FpVersao);
  Result.SetNamespace(FpAOwner.ConfigMsgDados.LoteRps.xmlns, Self.PrefixoPadrao);

  xmlNode := GerarXMLInfNFSe;
  Result.AppendChild(xmlNode);
end;

function TNFSeW_PadraoNacional.GerarXMLInfDps: TACBrXmlNode;
begin
  Result := CreateElement('infDPS');

  if (FpAOwner.ConfigGeral.Identificador <> '') then
    Result.SetAttribute(FpAOwner.ConfigGeral.Identificador, NFSe.infID.ID);

  Result.AppendChild(AddNode(tcStr, '#1', 'tpAmb', 1, 1, 1,
                                              TipoAmbienteToStr(Ambiente), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'dhEmi', 25, 25, 1,
               DateTimeTodh(NFSe.DataEmissao) +
               GetUTC(NFSe.Prestador.Endereco.UF, NFSe.DataEmissao), DSC_DEMI));

  Result.AppendChild(AddNode(tcStr, '#1', 'verAplic', 1, 20, 1,
                                                            NFSe.verAplic, ''));

  Result.AppendChild(AddNode(tcInt, '#1', 'serie', 1, 5, 1,
                              StrToIntDef(NFSe.IdentificacaoRps.Serie, 0), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'nDPS', 15, 15, 1,
                                             NFSe.IdentificacaoRps.Numero, ''));

  Result.AppendChild(AddNode(tcDat, '#1', 'dCompet', 10, 10, 1,
                                                         NFSe.Competencia, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tpEmit', 1, 1, 1,
                                                 tpEmitToStr(NFSe.tpEmit), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cMotivoEmisTI', 1, 1, 0,
                                   cMotivoEmisTIToStr(NFSe.cMotivoEmisTI), ''));

  if NFSe.cLocEmi <> '' then
    Result.AppendChild(AddNode(tcStr, '#1', 'cLocEmi', 7, 7, 1,
                                                              NFSe.cLocEmi, ''))
  else
  begin
    case NFSe.tpEmit of
      teTomador:
        Result.AppendChild(AddNode(tcStr, '#1', 'cLocEmi', 7, 7, 1,
                                    NFSe.Tomador.Endereco.CodigoMunicipio, ''));
      teIntermediario:
        Result.AppendChild(AddNode(tcStr, '#1', 'cLocEmi', 7, 7, 1,
                              NFSe.Intermediario.Endereco.CodigoMunicipio, ''));
    else
      Result.AppendChild(AddNode(tcStr, '#1', 'cLocEmi', 7, 7, 1,
                                  NFSe.Prestador.Endereco.CodigoMunicipio, ''));
    end;
  end;

  Result.AppendChild(GerarXMLSubstituicao);
  Result.AppendChild(GerarXMLPrestador);
  Result.AppendChild(GerarXMLTomador);
  Result.AppendChild(GerarXMLIntermediario);
  Result.AppendChild(GerarXMLServico);
  Result.AppendChild(GerarXMLValores);

  // Reforma Tributária
  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
    Result.AppendChild(GerarXMLIBSCBS(NFSe.IBSCBS));
end;

function TNFSeW_PadraoNacional.GerarXMLSubstituicao: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.subst.chSubstda <> '' then
  begin
    Result := CreateElement('subst');

    Result.AppendChild(AddNode(tcStr, '#1', 'chSubstda', 1, 50, 1,
                                                     NFSe.subst.chSubstda, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'cMotivo', 2, 2, 1,
                                         cMotivoToStr(NFSe.subst.cMotivo), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xMotivo', 15, 255, 0,
                                                       NFSe.subst.xMotivo, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLPrestador: TACBrXmlNode;
begin
  Result := CreateElement('prest');

  if NFSe.Prestador.IdentificacaoPrestador.CpfCnpj <> '' then
    Result.AppendChild(AddNodeCNPJCPF('#1', '#1',
                                 NFSe.Prestador.IdentificacaoPrestador.CpfCnpj))
  else
  begin
    if NFSe.Prestador.IdentificacaoPrestador.Nif <> '' then
      Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                 NFSe.Prestador.IdentificacaoPrestador.Nif, ''))
    else
      Result.AppendChild(AddNode(tcStr, '#1', 'cNaoNIF', 1, 1, 1,
               NaoNIFToStr(NFSe.Prestador.IdentificacaoPrestador.cNaoNIF), ''));
  end;

  Result.AppendChild(AddNode(tcStr, '#1', 'CAEPF', 1, 14, 0,
                              NFSe.Prestador.IdentificacaoPrestador.CAEPF, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IM', 1, 15, 0,
                 NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 300, 0,
                                               NFSe.Prestador.RazaoSocial, ''));

  if NFSe.tpEmit <> tePrestador then
    Result.AppendChild(GerarXMLEnderecoPrestador);

  Result.AppendChild(AddNode(tcStr, '#1', 'fone', 6, 20, 0,
                                          NFSe.Prestador.Contato.Telefone, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'email', 1, 80, 0,
                                             NFSe.Prestador.Contato.Email, ''));

  Result.AppendChild(GerarXMLRegimeTributacaoPrestador);
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoPrestador: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Prestador.Endereco.Endereco <> '' then
  begin
    Result := CreateElement('end');

    if (NFSe.Prestador.Endereco.CodigoMunicipio <> '') then
      Result.AppendChild(GerarXMLEnderecoNacionalPrestador)
    else
      Result.AppendChild(GerarXMLEnderecoExteriorPrestador);

    Result.AppendChild(AddNode(tcStr, '#1', 'xLgr', 1, 255, 1,
                                         NFSe.Prestador.Endereco.Endereco, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'nro', 1, 60, 1,
                                           NFSe.Prestador.Endereco.Numero, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xCpl', 1, 156, 0,
                                      NFSe.Prestador.Endereco.Complemento, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xBairro', 1, 60, 1,
                                           NFSe.Prestador.Endereco.Bairro, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoNacionalPrestador: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Prestador.Endereco.CEP <> '' then
  begin
    Result := CreateElement('endNac');

    Result.AppendChild(AddNode(tcStr, '#1', 'cMun', 7, 7, 1,
                                  NFSe.Prestador.Endereco.CodigoMunicipio, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 8, 8, 1,
                                              NFSe.Prestador.Endereco.CEP, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoExteriorPrestador: TACBrXmlNode;
begin
  Result := CreateElement('endExt');

  Result.AppendChild(AddNode(tcStr, '#1', 'cPais', 2, 2, 1,
               CodIBGEPaisToSiglaISO2(NFSe.Prestador.Endereco.CodigoPais), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                              NFSe.Prestador.Endereco.CEP, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                       NFSe.Prestador.Endereco.xMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                               NFSe.Prestador.Endereco.UF, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLRegimeTributacaoPrestador: TACBrXmlNode;
begin
  Result := CreateElement('regTrib');

  Result.AppendChild(AddNode(tcStr, '#1', 'opSimpNac', 1, 1, 1,
                                  OptanteSNToStr(NFSe.OptanteSN), DSC_INDOPSN));

  if NFSe.OptanteSN = osnOptanteMEEPP then
    Result.AppendChild(AddNode(tcStr, '#1', 'regApTribSN', 1, 1, 1,
                             RegimeApuracaoSNToStr(NFSe.RegimeApuracaoSN), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'regEspTrib', 1, 1, 1,
   FpAOwner.RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao), DSC_REGISSQN));
end;

function TNFSeW_PadraoNacional.GerarXMLTomador: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Tomador.RazaoSocial <> '' then
  begin
    Result := CreateElement('toma');

    if NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '' then
      Result.AppendChild(AddNodeCNPJCPF('#1', '#1',
                                     NFSe.Tomador.IdentificacaoTomador.CpfCnpj))
    else
    if NFSe.Tomador.IdentificacaoTomador.Nif <> '' then
      Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                     NFSe.Tomador.IdentificacaoTomador.Nif, ''))
    else
      Result.AppendChild(AddNode(tcStr, '#1', 'cNaoNIF', 1, 1, 1,
                   NaoNIFToStr(NFSe.Tomador.IdentificacaoTomador.cNaoNIF), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'CAEPF', 1, 14, 0,
                                  NFSe.Tomador.IdentificacaoTomador.CAEPF, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'IM', 1, 15, 0,
                     NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 300, 1,
                                                 NFSe.Tomador.RazaoSocial, ''));

    Result.AppendChild(GerarXMLEnderecoTomador);

    Result.AppendChild(AddNode(tcStr, '#1', 'fone', 6, 20, 0,
                                            NFSe.Tomador.Contato.Telefone, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'email', 1, 80, 0,
                                               NFSe.Tomador.Contato.Email, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoTomador: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.Tomador.Endereco.CodigoMunicipio <> '') or
     (NFSe.Tomador.Endereco.CodigoPais <> 0) then
  begin
    Result := CreateElement('end');

    if (NFSe.Tomador.Endereco.CodigoMunicipio <> '') then
      Result.AppendChild(GerarXMLEnderecoNacionalTomador)
    else
      Result.AppendChild(GerarXMLEnderecoExteriorTomador);

    Result.AppendChild(AddNode(tcStr, '#1', 'xLgr', 1, 255, 1,
                                           NFSe.Tomador.Endereco.Endereco, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'nro', 1, 60, 1,
                                             NFSe.Tomador.Endereco.Numero, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xCpl', 1, 156, 0,
                                        NFSe.Tomador.Endereco.Complemento, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xBairro', 1, 60, 1,
                                             NFSe.Tomador.Endereco.Bairro, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoNacionalTomador: TACBrXmlNode;
begin
  Result := CreateElement('endNac');

  Result.AppendChild(AddNode(tcStr, '#1', 'cMun', 7, 7, 1,
                                    NFSe.Tomador.Endereco.CodigoMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 8, 8, 1,
                                                NFSe.Tomador.Endereco.CEP, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoExteriorTomador: TACBrXmlNode;
begin
  Result := CreateElement('endExt');

  Result.AppendChild(AddNode(tcStr, '#1', 'cPais', 2, 2, 1,
                 CodIBGEPaisToSiglaISO2(NFSe.Tomador.Endereco.CodigoPais), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                                NFSe.Tomador.Endereco.CEP, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                         NFSe.Tomador.Endereco.xMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                                 NFSe.Tomador.Endereco.UF, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLIntermediario: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Intermediario.RazaoSocial <> '' then
  begin
    Result := CreateElement('interm');

    if NFSe.Intermediario.Identificacao.CpfCnpj <> '' then
      Result.AppendChild(AddNodeCNPJCPF('#1', '#1',
                                      NFSe.Intermediario.Identificacao.CpfCnpj))
    else
    if NFSe.Intermediario.Identificacao.Nif <> '' then
      Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                      NFSe.Intermediario.Identificacao.Nif, ''))
    else
      Result.AppendChild(AddNode(tcStr, '#1', 'cNaoNIF', 1, 1, 1,
                    NaoNIFToStr(NFSe.Intermediario.Identificacao.cNaoNIF), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'CAEPF', 1, 14, 0,
                                   NFSe.Intermediario.Identificacao.CAEPF, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'IM', 1, 15, 0,
                      NFSe.Intermediario.Identificacao.InscricaoMunicipal, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 300, 1,
                                           NFSe.Intermediario.RazaoSocial, ''));

    Result.AppendChild(GerarXMLEnderecoIntermediario);

    Result.AppendChild(AddNode(tcStr, '#1', 'fone', 6, 20, 0,
                                      NFSe.Intermediario.Contato.Telefone, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'email', 1, 80, 0,
                                         NFSe.Intermediario.Contato.Email, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoIntermediario: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.Intermediario.Endereco.CodigoMunicipio <> '') or
     (NFSe.Intermediario.Endereco.CodigoPais <> 0) then
  begin
    Result := CreateElement('end');

    if (NFSe.Intermediario.Endereco.CodigoMunicipio <> '') then
      Result.AppendChild(GerarXMLEnderecoNacionalIntermediario)
    else
      Result.AppendChild(GerarXMLEnderecoExteriorIntermediario);

    Result.AppendChild(AddNode(tcStr, '#1', 'xLgr', 1, 255, 1,
                                     NFSe.Intermediario.Endereco.Endereco, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'nro', 1, 60, 1,
                                       NFSe.Intermediario.Endereco.Numero, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xCpl', 1, 156, 0,
                                  NFSe.Intermediario.Endereco.Complemento, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xBairro', 1, 60, 1,
                                       NFSe.Intermediario.Endereco.Bairro, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoNacionalIntermediario: TACBrXmlNode;
begin
  Result := CreateElement('endNac');

  Result.AppendChild(AddNode(tcStr, '#1', 'cMun', 7, 7, 1,
                              NFSe.Intermediario.Endereco.CodigoMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 8, 8, 1,
                                          NFSe.Intermediario.Endereco.CEP, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoExteriorIntermediario: TACBrXmlNode;
begin
  Result := CreateElement('endExt');

  Result.AppendChild(AddNode(tcStr, '#1', 'cPais', 2, 2, 1,
           CodIBGEPaisToSiglaISO2(NFSe.Intermediario.Endereco.CodigoPais), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                          NFSe.Intermediario.Endereco.CEP, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                   NFSe.Intermediario.Endereco.xMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                           NFSe.Intermediario.Endereco.UF, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLServico: TACBrXmlNode;
begin
  Result := CreateElement('serv');

  Result.AppendChild(GerarXMLLocalPrestacao);
  Result.AppendChild(GerarXMLCodigoServico);
  Result.AppendChild(GerarXMLComercioExterior);
  Result.AppendChild(GerarXMLLocacaoSubLocacao);
  Result.AppendChild(GerarXMLObra);
  Result.AppendChild(GerarXMLAtividadeEvento);
  Result.AppendChild(GerarXMLExploracaoRodoviaria);
  Result.AppendChild(GerarXMLInformacoesComplementares);
end;

function TNFSeW_PadraoNacional.GerarXMLLocalPrestacao: TACBrXmlNode;
begin
  Result := CreateElement('locPrest');

  if NFSe.Servico.CodigoMunicipio <> '' then
    Result.AppendChild(AddNode(tcStr, '#1', 'cLocPrestacao', 7, 7, 1,
                                              NFSe.Servico.CodigoMunicipio, ''))
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'cPaisPrestacao', 2, 2, 1,
                          CodIBGEPaisToSiglaISO2(NFSe.Servico.CodigoPais), ''));
end;

function TNFSeW_PadraoNacional.GerarXMLCodigoServico: TACBrXmlNode;
begin
  Result := CreateElement('cServ');

  Result.AppendChild(AddNode(tcStr, '#1', 'cTribNac', 6, 6, 1,
                                            NFSe.Servico.ItemListaServico, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cTribMun', 3, 3, 0,
                                   NFSe.Servico.CodigoTributacaoMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xDescServ', 1, 2000, 1,
    StringReplace(NFSe.Servico.Discriminacao, Opcoes.QuebraLinha,
                          FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll])));

  Result.AppendChild(AddNode(tcStr, '#1', 'cNBS', 9, 9, 0,
                                                   NFSe.Servico.CodigoNBS, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cIntContrib', 1, 20, 0,
                                            NFSe.Servico.CodigoInterContr, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLComercioExterior: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Servico.comExt.tpMoeda > 0 then
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

function TNFSeW_PadraoNacional.GerarXMLLocacaoSubLocacao: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Servico.Locacao.extensao <> '' then
  begin
    Result := CreateElement('lsadppu');

    Result.AppendChild(AddNode(tcStr, '#1', 'categ', 1, 1, 1,
                                   categToStr(NFSe.Servico.Locacao.categ), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'objeto', 1, 1, 1,
                                 objetoToStr(NFSe.Servico.Locacao.objeto), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'extensao', 1, 5, 1,
                                            NFSe.Servico.Locacao.extensao, ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'nPostes', 1, 6, 1,
                                             NFSe.Servico.Locacao.nPostes, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLObra: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.ConstrucaoCivil.inscImobFisc <> '' then
  begin
    Result := CreateElement('obra');
    Result.AppendChild(AddNode(tcStr, '#1', 'inscImobFisc', 1, 30, 1,
                                        NFSe.ConstrucaoCivil.inscImobFisc, ''));
    exit;
  end;

  if NFSe.ConstrucaoCivil.CodigoObra <> '' then
  begin
    Result := CreateElement('obra');
    Result.AppendChild(AddNode(tcStr, '#1', 'cObra', 1, 30, 1,
                                          NFSe.ConstrucaoCivil.CodigoObra, ''));
    exit;
  end;

  if (NFSe.ConstrucaoCivil.Endereco.CEP <> '') or
     (NFSe.ConstrucaoCivil.Endereco.Endereco <> '') then
  begin
    Result := CreateElement('obra');
    Result.AppendChild(GerarXMLEnderecoObra);
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoObra: TACBrXmlNode;
begin
  Result := CreateElement('end');

  if (NFSe.ConstrucaoCivil.Endereco.CodigoPais = 0) or
     (NFSe.ConstrucaoCivil.Endereco.CodigoPais = 1058) then
    Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 8, 8, 1,
                                         NFSe.ConstrucaoCivil.Endereco.CEP, ''))
  else
    Result.AppendChild(GerarXMLEnderecoExteriorObra);

  Result.AppendChild(AddNode(tcStr, '#1', 'xLgr', 1, 255, 1,
                                   NFSe.ConstrucaoCivil.Endereco.Endereco, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'nro', 1, 60, 1,
                                     NFSe.ConstrucaoCivil.Endereco.Numero, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCpl', 1, 156, 0,
                                NFSe.ConstrucaoCivil.Endereco.Complemento, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xBairro', 1, 60, 1,
                                     NFSe.ConstrucaoCivil.Endereco.Bairro, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoExteriorObra: TACBrXmlNode;
begin
  Result := CreateElement('endExt');

  Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                        NFSe.ConstrucaoCivil.Endereco.CEP, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                 NFSe.ConstrucaoCivil.Endereco.xMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                         NFSe.ConstrucaoCivil.Endereco.UF, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLAtividadeEvento: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Servico.Evento.xNome <> '' then
  begin
    Result := CreateElement('atvEvento');

    Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 255, 1,
                                                NFSe.Servico.Evento.xNome, ''));

    Result.AppendChild(AddNode(tcDat, '#1', 'dtIni', 10, 10, 1,
                                                NFSe.Servico.Evento.dtIni, ''));

    Result.AppendChild(AddNode(tcDat, '#1', 'dtFim', 10, 10, 1,
                                                NFSe.Servico.Evento.dtFim, ''));

    if NFSe.Servico.Evento.idAtvEvt <> '' then
      Result.AppendChild(AddNode(tcStr, '#1', 'idAtvEvt', 1, 30, 1,
                                              NFSe.Servico.Evento.idAtvEvt, ''))
    else
      Result.AppendChild(GerarXMLEnderecoEvento);
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoEvento: TACBrXmlNode;
begin
  Result := CreateElement('end');

  if (NFSe.Servico.Evento.Endereco.UF = '') then
    Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 8, 8, 1,
                                          NFSe.Servico.Evento.Endereco.CEP, ''))
  else
    Result.AppendChild(GerarXMLEnderecoExteriorEvento);

  Result.AppendChild(AddNode(tcStr, '#1', 'xLgr', 1, 255, 1,
                                    NFSe.Servico.Evento.Endereco.Endereco, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'nro', 1, 60, 1,
                                      NFSe.Servico.Evento.Endereco.Numero, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCpl', 1, 156, 0,
                                 NFSe.Servico.Evento.Endereco.Complemento, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xBairro', 1, 60, 1,
                                      NFSe.Servico.Evento.Endereco.Bairro, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoExteriorEvento: TACBrXmlNode;
begin
  Result := CreateElement('endExt');

  Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                         NFSe.Servico.Evento.Endereco.CEP, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                  NFSe.Servico.Evento.Endereco.xMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                          NFSe.Servico.Evento.Endereco.UF, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLExploracaoRodoviaria: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Servico.explRod.nEixos > 0 then
  begin
    Result := CreateElement('explRod');

    Result.AppendChild(AddNode(tcStr, '#1', 'categVeic', 2, 2, 1,
                           categVeicToStr(NFSe.Servico.explRod.categVeic), ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'nEixos', 1, 2, 1,
                                              NFSe.Servico.explRod.nEixos, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'rodagem', 1, 1, 1,
                               rodagemToStr(NFSe.Servico.explRod.rodagem), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'sentido', 1, 3, 1,
                                             NFSe.Servico.explRod.sentido, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'placa', 7, 7, 1,
                                               NFSe.Servico.explRod.placa, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'codAcessoPed', 10, 10, 1,
                                        NFSe.Servico.explRod.codAcessoPed, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'codContrato', 4, 4, 1,
                                         NFSe.Servico.explRod.codContrato, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLInformacoesComplementares: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.Servico.infoCompl.idDocTec <> '') or
     (NFSe.Servico.infoCompl.docRef <> '') or
     (NFSe.Servico.infoCompl.xInfComp <> '') then
  begin
    Result := CreateElement('infoCompl');

    Result.AppendChild(AddNode(tcStr, '#1', 'idDocTec', 1, 40, 0,
                                          NFSe.Servico.infoCompl.idDocTec, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'docRef', 1, 255, 0,
                                            NFSe.Servico.infoCompl.docRef, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xInfComp', 1, 2000, 0,
                                          NFSe.Servico.infoCompl.xInfComp, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLValores: TACBrXmlNode;
begin
  Result := CreateElement('valores');

  Result.AppendChild(GerarXMLServicoPrestado);
  Result.AppendChild(GerarXMLDescontos);
  Result.AppendChild(GerarXMLDeducoes);
  Result.AppendChild(GerarXMLTributacao);
end;

function TNFSeW_PadraoNacional.GerarXMLServicoPrestado: TACBrXmlNode;
begin
  Result := CreateElement('vServPrest');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vReceb', 1, 15, 0,
                                       NFSe.Servico.Valores.ValorRecebido, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vServ', 1, 15, 0,
                                       NFSe.Servico.Valores.ValorServicos, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLDescontos: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.Servico.Valores.DescontoIncondicionado > 0) or
     (NFSe.Servico.Valores.DescontoCondicionado > 0) then
  begin
    Result := CreateElement('vDescCondIncond');

    Result.AppendChild(AddNode(tcDe2, '#1', 'vDescIncond', 1, 15, 0,
                              NFSe.Servico.Valores.DescontoIncondicionado, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vDescCond', 1, 15, 0,
                                NFSe.Servico.Valores.DescontoCondicionado, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLDeducoes: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.Servico.Valores.AliquotaDeducoes > 0) then
  begin
    Result := CreateElement('vDedRed');
    Result.AppendChild(AddNode(tcDe2, '#1', 'pDR', 1, 5, 1,
                                    NFSe.Servico.Valores.AliquotaDeducoes, ''));
    exit;
  end;

  if (NFSe.Servico.Valores.ValorDeducoes > 0) then
  begin
    Result := CreateElement('vDedRed');
    Result.AppendChild(AddNode(tcDe2, '#1', 'vDR', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorDeducoes, ''));
    exit;
  end;

  if (NFSe.Servico.Valores.DocDeducao.Count > 0) then
  begin
    Result := CreateElement('vDedRed');
    Result.AppendChild(GerarXMLDocDeducoes);
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLDocDeducoes: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := CreateElement('documentos');

  nodeArray := GerarXMLListaDocDeducoes;

  if nodeArray <> nil then
  begin
    for i := 0 to Length(nodeArray) - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLListaDocDeducoes: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.Servico.Valores.DocDeducao.Count);

  for i := 0 to NFSe.Servico.Valores.DocDeducao.Count - 1 do
  begin
    Result[i] := CreateElement('docDedRed');

    if NFSe.Servico.Valores.DocDeducao.Items[i].chNFSe <> '' then
      Result[i].AppendChild(AddNode(tcStr, '#1', 'chNFSe', 50, 50, 1,
                           NFSe.Servico.Valores.DocDeducao.Items[i].chNFSe, ''))
    else
    begin
      if NFSe.Servico.Valores.DocDeducao.Items[i].chNFe <> '' then
        Result[i].AppendChild(AddNode(tcStr, '#1', 'chNFe', 44, 44, 1,
                            NFSe.Servico.Valores.DocDeducao.Items[i].chNFe, ''))
      else
      begin
        if NFSe.Servico.Valores.DocDeducao.Items[i].NFSeMun.cMunNFSeMun <> '' then
          Result[i].AppendChild(GerarXMLNFSeMunicipio(i))
        else
        begin
          if NFSe.Servico.Valores.DocDeducao.Items[i].NFNFS.nNFS <> '' then
            Result[i].AppendChild(GerarXMLNFNFS(i))
          else
          begin
            if NFSe.Servico.Valores.DocDeducao.Items[i].nDocFisc <> '' then
              Result[i].AppendChild(AddNode(tcStr, '#1', 'nDocFisc', 1, 255, 1,
                         NFSe.Servico.Valores.DocDeducao.Items[i].nDocFisc, ''))
            else
              Result[i].AppendChild(AddNode(tcStr, '#1', 'nDoc', 1, 255, 0,
                            NFSe.Servico.Valores.DocDeducao.Items[i].nDoc, ''));
          end;
        end;
      end;
    end;

    Result[i].AppendChild(AddNode(tcStr, '#1', 'tpDedRed', 1, 2, 1,
         tpDedRedToStr(NFSe.Servico.Valores.DocDeducao.Items[i].tpDedRed), ''));

    Result[i].AppendChild(AddNode(tcStr, '#1', 'xDescOutDed', 1, 150, 0,
                     NFSe.Servico.Valores.DocDeducao.Items[i].xDescOutDed, ''));

    Result[i].AppendChild(AddNode(tcDat, '#1', 'dtEmiDoc', 10, 10, 1,
                        NFSe.Servico.Valores.DocDeducao.Items[i].dtEmiDoc, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#1', 'vDedutivelRedutivel', 1, 15, 1,
             NFSe.Servico.Valores.DocDeducao.Items[i].vDedutivelRedutivel, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#1', 'vDeducaoReducao', 1, 15, 1,
                 NFSe.Servico.Valores.DocDeducao.Items[i].vDeducaoReducao, ''));

    Result[i].AppendChild(GerarXMLFornecedor(i))
  end;

  if NFSe.Servico.Valores.DocDeducao.Count > 1000 then
    wAlerta('#1', 'docDedRed', '', ERR_MSG_MAIOR_MAXIMO + '1000');
end;

function TNFSeW_PadraoNacional.GerarXMLNFSeMunicipio(Item: Integer): TACBrXmlNode;
begin
  Result := CreateElement('NFSeMun');

  Result.AppendChild(AddNode(tcStr, '#1', 'cMunNFSeMun', 7, 7, 1,
          NFSe.Servico.Valores.DocDeducao.Items[item].NFSeMun.cMunNFSeMun, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'nNFSeMun', 15, 15, 1,
             NFSe.Servico.Valores.DocDeducao.Items[item].NFSeMun.nNFSeMun, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cVerifNFSeMun', 1, 9, 1,
        NFSe.Servico.Valores.DocDeducao.Items[item].NFSeMun.cVerifNFSeMun, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLNFNFS(Item: Integer): TACBrXmlNode;
begin
  Result := CreateElement('NFNFS');

  Result.AppendChild(AddNode(tcStr, '#1', 'nNFS', 7, 7, 1,
                   NFSe.Servico.Valores.DocDeducao.Items[item].NFNFS.nNFS, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'modNFS', 15, 15, 1,
                 NFSe.Servico.Valores.DocDeducao.Items[item].NFNFS.modNFS, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'serieNFS', 1, 15, 1,
               NFSe.Servico.Valores.DocDeducao.Items[item].NFNFS.serieNFS, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLFornecedor(Item: Integer): TACBrXmlNode;
begin
  Result := nil;

  with NFSe.Servico.Valores.DocDeducao.Items[Item].fornec do
  begin
    if RazaoSocial <> '' then
    begin
      Result := CreateElement('fornec');

      if Identificacao.CpfCnpj <> '' then
        Result.AppendChild(AddNodeCNPJCPF('#1', '#1', Identificacao.CpfCnpj))
      else
      if Identificacao.Nif <> '' then
        Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                                         Identificacao.Nif, ''))
      else
        Result.AppendChild(AddNode(tcStr, '#1', 'cNaoNIF', 1, 1, 1,
                                       NaoNIFToStr(Identificacao.cNaoNIF), ''));

      Result.AppendChild(AddNode(tcStr, '#1', 'CAEPF', 1, 14, 0,
                                                      Identificacao.CAEPF, ''));

      Result.AppendChild(AddNode(tcStr, '#1', 'IM', 1, 15, 0,
                                         Identificacao.InscricaoMunicipal, ''));

      Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 300, 1,
                                                              RazaoSocial, ''));

      Result.AppendChild(GerarXMLEnderecoFornecedor(Item));

      Result.AppendChild(AddNode(tcStr, '#1', 'fone', 6, 20, 0,
                                                         Contato.Telefone, ''));

      Result.AppendChild(AddNode(tcStr, '#1', 'email', 1, 80, 0,
                                                            Contato.Email, ''));
    end;
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoFornecedor(
  Item: Integer): TACBrXmlNode;
begin
  Result := nil;

  with NFSe.Servico.Valores.DocDeducao.Items[Item].fornec.Endereco do
  begin
    if (CodigoMunicipio <> '') or (CodigoPais <> 0) then
    begin
      Result := CreateElement('end');

      if (CodigoMunicipio <> '') then
        Result.AppendChild(GerarXMLEnderecoNacionalFornecedor(Item))
      else
        Result.AppendChild(GerarXMLEnderecoExteriorFornecedor(Item));

      Result.AppendChild(AddNode(tcStr, '#1', 'xLgr', 1, 255, 1, Endereco, ''));

      Result.AppendChild(AddNode(tcStr, '#1', 'nro', 1, 60, 1, Numero, ''));

      Result.AppendChild(AddNode(tcStr, '#1', 'xCpl', 1, 156, 0, Complemento, ''));

      Result.AppendChild(AddNode(tcStr, '#1', 'xBairro', 1, 60, 1, Bairro, ''));
    end;
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoNacionalFornecedor(
  Item: Integer): TACBrXmlNode;
begin
  Result := CreateElement('endNac');

  with NFSe.Servico.Valores.DocDeducao.Items[Item].fornec.Endereco do
  begin
    Result.AppendChild(AddNode(tcStr, '#1', 'cMun', 7, 7, 1, CodigoMunicipio, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 8, 8, 1, CEP, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLEnderecoExteriorFornecedor(
  Item: Integer): TACBrXmlNode;
begin
  Result := CreateElement('endExt');

  with NFSe.Servico.Valores.DocDeducao.Items[Item].fornec.Endereco do
  begin
    Result.AppendChild(AddNode(tcStr, '#1', 'cPais', 2, 2, 1,
                                       CodIBGEPaisToSiglaISO2(CodigoPais), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1, CEP, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1, xMunicipio, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1, UF, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLTributacao: TACBrXmlNode;
begin
  Result := CreateElement('trib');

  Result.AppendChild(GerarXMLTributacaoMunicipal);

  if NFSe.OptanteSN <> osnOptanteMEI then
    Result.AppendChild(GerarXMLTributacaoFederal);

  Result.AppendChild(GerarXMLTotalTributos);
end;

function TNFSeW_PadraoNacional.GerarXMLTributacaoMunicipal: TACBrXmlNode;
begin
  Result := CreateElement('tribMun');

  Result.AppendChild(AddNode(tcStr, '#1', 'tribISSQN', 1, 1, 1,
                   tribISSQNToStr(NFSe.Servico.Valores.tribMun.tribISSQN), ''));

  if NFSe.Servico.Valores.tribMun.cPaisResult > 0 then
    Result.AppendChild(AddNode(tcStr, '#1', 'cPaisResult', 2, 2, 0,
         CodIBGEPaisToSiglaISO2(NFSe.Servico.Valores.tribMun.cPaisResult), ''));

  if NFSe.Servico.Valores.tribMun.tribISSQN = tiImunidade then
    Result.AppendChild(AddNode(tcStr, '#1', 'tpImunidade', 1, 1, 0,
               tpImunidadeToStr(NFSe.Servico.Valores.tribMun.tpImunidade), ''));

  Result.AppendChild(GerarXMLExigibilidadeSuspensa);
  Result.AppendChild(GerarXMLBeneficioMunicipal);

  Result.AppendChild(AddNode(tcStr, '#1', 'tpRetISSQN', 2, 2, 1,
                 tpRetISSQNToStr(NFSe.Servico.Valores.tribMun.tpRetISSQN), ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliq', 1, 3, 0,
                                       NFSe.Servico.Valores.tribMun.pAliq, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLBeneficioMunicipal: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Servico.Valores.tribMun.nBM <> '' then
  begin
    Result := CreateElement('BM');

//    Result.AppendChild(AddNode(tcStr, '#1', 'tpBM', 1, 1, 1,
//                             tpBMToStr(NFSe.Servico.Valores.tribMun.tpBM), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'nBM', 14, 14, 1,
                                         NFSe.Servico.Valores.tribMun.nBM, ''));

    if NFSe.Servico.Valores.tribMun.vRedBCBM > 0 then
      Result.AppendChild(AddNode(tcDe2, '#1', 'vRedBCBM', 1, 15, 1,
                                     NFSe.Servico.Valores.tribMun.vRedBCBM, ''))
    else
      Result.AppendChild(AddNode(tcDe2, '#1', 'pRedBCBM', 1, 5, 1,
                                    NFSe.Servico.Valores.tribMun.pRedBCBM, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLExigibilidadeSuspensa: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.Servico.Valores.tribMun.nProcesso <> '' then
  begin
    Result := CreateElement('exigSusp');

    Result.AppendChild(AddNode(tcStr, '#1', 'tpSusp', 1, 1, 1,
                         tpSuspToStr(NFSe.Servico.Valores.tribMun.tpSusp), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'nProcesso', 30, 30, 1,
                                   NFSe.Servico.Valores.tribMun.nProcesso, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLTributacaoFederal: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.Servico.Valores.tribFed.vRetCP > 0) or
     (NFSe.Servico.Valores.tribFed.vRetIRRF > 0) or
     (NFSe.Servico.Valores.tribFed.vRetCSLL > 0) or
     (NFSe.Servico.Valores.tribFed.CST <> cstVazio) then
  begin
    Result := CreateElement('tribFed');

    if NFSe.Servico.Valores.tribFed.CST <> cstVazio then
      Result.AppendChild(GerarXMLTributacaoOutrosPisCofins);

    Result.AppendChild(AddNode(tcDe2, '#1', 'vRetCP', 1, 15, 0,
                                      NFSe.Servico.Valores.tribFed.vRetCP, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vRetIRRF', 1, 15, 0,
                                    NFSe.Servico.Valores.tribFed.vRetIRRF, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vRetCSLL', 1, 15, 0,
                                    NFSe.Servico.Valores.tribFed.vRetCSLL, ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLTributacaoOutrosPisCofins: TACBrXmlNode;
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

    Result.AppendChild(AddNode(tcDe2, '#1', 'vPis', 1, 15, NOcorr,
                                        NFSe.Servico.Valores.tribFed.vPis, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vCofins', 1, 15, NOcorr,
                                     NFSe.Servico.Valores.tribFed.vCofins, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'tpRetPisCofins', 1, 1, 0,
         tpRetPisCofinsToStr(NFSe.Servico.Valores.tribFed.tpRetPisCofins), ''));
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLTotalTributos: TACBrXmlNode;
begin
  Result := CreateElement('totTrib');

  if (NFSe.Servico.Valores.totTrib.vTotTribFed > 0) or
     (NFSe.Servico.Valores.totTrib.vTotTribEst > 0) or
     (NFSe.Servico.Valores.totTrib.vTotTribMun > 0) then
    Result.AppendChild(GerarXMLValorTotalTributos)
  else
  begin
    if (NFSe.Servico.Valores.totTrib.pTotTribFed > 0) or
       (NFSe.Servico.Valores.totTrib.pTotTribEst > 0) or
       (NFSe.Servico.Valores.totTrib.pTotTribMun > 0) then
      Result.AppendChild(GerarXMLPercentualTotalTributos)
    else
    begin
      if NFSe.Servico.Valores.totTrib.pTotTribSN > 0 then
        Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribSN', 1, 5, 1,
                                   NFSe.Servico.Valores.totTrib.pTotTribSN, ''))
      else
      begin
        if NFSe.Servico.Valores.totTrib.indTotTrib <> indSim then
          Result.AppendChild(AddNode(tcStr, '#1', 'indTotTrib', 1, 1, 1,
                 indTotTribToStr(NFSe.Servico.Valores.totTrib.indTotTrib), ''));
      end;
    end;
  end;
end;

function TNFSeW_PadraoNacional.GerarXMLValorTotalTributos: TACBrXmlNode;
begin
  Result := CreateElement('vTotTrib');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vTotTribFed', 1, 15, 1,
                                 NFSe.Servico.Valores.totTrib.vTotTribFed, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vTotTribEst', 1, 15, 1,
                                 NFSe.Servico.Valores.totTrib.vTotTribEst, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vTotTribMun', 1, 15, 1,
                                 NFSe.Servico.Valores.totTrib.vTotTribMun, ''));
end;

function TNFSeW_PadraoNacional.GerarXMLPercentualTotalTributos: TACBrXmlNode;
begin
  Result := CreateElement('pTotTrib');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribFed', 1, 5, 1,
                                 NFSe.Servico.Valores.totTrib.pTotTribFed, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribEst', 1, 5, 1,
                                 NFSe.Servico.Valores.totTrib.pTotTribEst, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pTotTribMun', 1, 5, 1,
                                 NFSe.Servico.Valores.totTrib.pTotTribMun, ''));
end;

function TNFSeW_PadraoNacional.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
  chave: string;
begin
  Configuracao;

  ListaDeAlertas.Clear;

  FDocument.Clear();

  FpVersao := VersaoNFSeToStr(VersaoNFSe);

  chave := GerarChaveDPS(NFSe.Prestador.Endereco.CodigoMunicipio,
                         NFSe.Prestador.IdentificacaoPrestador.CpfCnpj,
                         NFSe.IdentificacaoRps.Serie,
                         NFSe.IdentificacaoRps.Numero);

  NFSe.InfID.ID := 'DPS' + chave;

  NFSeNode := CreateElement('DPS');
  NFSeNode.SetAttribute('versao', FpVersao);
  NFSeNode.SetNamespace(FpAOwner.ConfigMsgDados.LoteRps.xmlns, Self.PrefixoPadrao);

  FDocument.Root := NFSeNode;

  xmlNode := GerarXMLInfDps;
  NFSeNode.AppendChild(xmlNode);

  Result := True;
end;

//====== Gerar o Arquivo INI=========================================
function TNFSeW_PadraoNacional.GerarIni: string;
var
  INIRec: TMemIniFile;
  IniNFSe: TStringList;
begin
  Result:= '';
// Usar FpAOwner no lugar de FProvider

  INIRec := TMemIniFile.Create('');
  try
    if NFSe.tpXML = txmlRPS then
      GerarIniRps(INIRec)
    else
      GerarIniNfse(INIRec);
  finally
    IniNFSe := TStringList.Create;
    try
      INIRec.GetStrings(IniNFSe);
      INIRec.Free;

      Result := StringReplace(IniNFSe.Text, sLineBreak + sLineBreak, sLineBreak, [rfReplaceAll]);
    finally
      IniNFSe.Free;
    end;
  end;
end;

procedure TNFSeW_PadraoNacional.GerarIniNfse(AINIRec: TMemIniFile);
begin
  GerarINIIdentificacaoNFSe(AINIRec);
  GerarINIDadosEmitente(AINIRec);
  GerarINIValoresNFSe(AINIRec);
  // Gerar dados do DPS que esta na NFSe
  GerarINIIdentificacaoRps(AINIRec);
  GerarININFSeSubstituicao(AINIRec);
  GerarINIDadosPrestador(AINIRec);
  GerarINIDadosTomador(AINIRec);
  GerarINIDadosIntermediario(AINIRec);
  GerarINIDadosServico(AINIRec);
  GerarINIComercioExterior(AINIRec);
  GerarINILocacaoSubLocacao(AINIRec);
  GerarINIConstrucaoCivil(AINIRec);
  GerarINIEvento(AINIRec);
  GerarINIRodoviaria(AINIRec);
  GerarINIInformacoesComplementares(AINIRec);
  GerarINIValores(AINIRec);
  GerarINIDocumentosDeducoes(AINIRec);
  GerarINIValoresTribMun(AINIRec);
  GerarINIValoresTribFederal(AINIRec);
  GerarINIValoresTotalTrib(AINIRec);

  // Reforma Tributária
  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
  begin
    GerarINIIBSCBS(AINIRec, NFSe.IBSCBS);
    GerarINIIBSCBSNFSe(AINIRec, NFSe.infNFSe.IBSCBS);
  end;
end;

procedure TNFSeW_PadraoNacional.GerarIniRps(AINIRec: TMemIniFile);
begin
  GerarINIIdentificacaoNFSe(AINIRec);
  GerarINIIdentificacaoRps(AINIRec);
  GerarININFSeSubstituicao(AINIRec);
  GerarINIDadosPrestador(AINIRec);
  GerarINIDadosTomador(AINIRec);
  GerarINIDadosIntermediario(AINIRec);
  GerarINIDadosServico(AINIRec);
  GerarINIComercioExterior(AINIRec);
  GerarINILocacaoSubLocacao(AINIRec);
  GerarINIConstrucaoCivil(AINIRec);
  GerarINIEvento(AINIRec);
  GerarINIRodoviaria(AINIRec);
  GerarINIInformacoesComplementares(AINIRec);
  GerarINIValores(AINIRec);
  GerarINIDocumentosDeducoes(AINIRec);
  GerarINIValoresTribMun(AINIRec);
  GerarINIValoresTribFederal(AINIRec);
  GerarINIValoresTotalTrib(AINIRec);

  // Reforma Tributária
  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
    GerarINIIBSCBS(AINIRec, NFSe.IBSCBS);
end;

procedure TNFSeW_PadraoNacional.GerarINIIdentificacaoNFSe(
  const AINIRec: TMemIniFile);
begin
  LSecao:= 'IdentificacaoNFSe';

  if NFSe.tpXML = txmlRPS then
    AINIRec.WriteString(LSecao, 'TipoXML', 'RPS')
  else
  begin
    AINIRec.WriteString(LSecao, 'TipoXML', 'NFSE');

    AINIRec.WriteString(LSecao, 'Id', NFSe.infNFSe.ID);
    AINIRec.WriteString(LSecao, 'xLocEmi', NFSe.infNFSe.xLocEmi);
    AINIRec.WriteString(LSecao, 'xLocPrestacao', NFSe.infNFSe.xLocPrestacao);
    AINIRec.WriteString(LSecao, 'nNFSe', NFSe.infNFSe.nNFSe);
    AINIRec.WriteInteger(LSecao, 'cLocIncid', NFSe.infNFSe.cLocIncid);
    AINIRec.WriteString(LSecao, 'xLocIncid', NFSe.infNFSe.xLocIncid);
    AINIRec.WriteString(LSecao, 'xTribNac', NFSe.infNFSe.xTribNac);
    AINIRec.WriteString(LSecao, 'xTribMun', NFSe.infNFSe.xTribMun);
    AINIRec.WriteString(LSecao, 'xNBS', NFSe.infNFSe.xNBS);
    AINIRec.WriteString(LSecao, 'verAplic', NFSe.infNFSe.verAplic);
    AINIRec.WriteString(LSecao, 'ambGer', ambGerToStr(NFSe.infNFSe.ambGer));
    AINIRec.WriteString(LSecao, 'tpEmis', tpEmisToStr(NFSe.infNFSe.tpEmis));
    AINIRec.WriteString(LSecao, 'procEmi', procEmisToStr(NFSe.infNFSe.procEmi));
    AINIRec.WriteInteger(LSecao, 'cStat', NFSe.infNFSe.cStat);
    AINIRec.WriteString(LSecao, 'dhProc', DateTimeTodh(NFSe.infNFSe.dhProc));
    AINIRec.WriteString(LSecao, 'nDFSe', NFSe.infNFSe.nDFSe);
  end;
end;

procedure TNFSeW_PadraoNacional.GerarINIIdentificacaoRps(AINIRec: TMemIniFile);
begin
  LSecao := 'IdentificacaoRps';

  AINIRec.WriteString(LSecao, 'Numero', NFSe.IdentificacaoRps.Numero);
  AINIRec.WriteString(LSecao, 'Serie', NFSe.IdentificacaoRps.Serie);
  AINIRec.WriteString(LSecao, 'DataEmissao', DateTimeTodh(NFSe.DataEmissao));
  AINIRec.WriteString(LSecao, 'Competencia', DateTimeTodh(NFSe.Competencia));
  AINIRec.WriteString(LSecao, 'verAplic', NFSe.verAplic);
  AINIRec.WriteString(LSecao, 'tpEmit', tpEmitToStr(NFSe.tpEmit));
  AINIRec.WriteString(LSecao, 'cMotivoEmisTI', cMotivoEmisTIToStr(NFSe.cMotivoEmisTI));
  AINIRec.WriteString(LSecao, 'cLocEmi', NFSe.cLocEmi);
end;

procedure TNFSeW_PadraoNacional.GerarININFSeSubstituicao(AINIRec: TMemIniFile);
begin
  LSecao := 'NFSeSubstituicao';

  AINIRec.WriteString(LSecao, 'chSubstda', NFSe.subst.chSubstda);
  AINIRec.WriteString(LSecao, 'cMotivo', cMotivoToStr(NFSe.subst.cMotivo));
  AINIRec.WriteString(LSecao, 'xMotivo', NFSe.subst.xMotivo);
end;

procedure TNFSeW_PadraoNacional.GerarINIDadosPrestador(AINIRec: TMemIniFile);
begin
  LSecao := 'Prestador';

  AINIRec.WriteString(LSecao, 'CNPJ', NFSe.Prestador.IdentificacaoPrestador.CpfCnpj);
  AINIRec.WriteString(LSecao, 'InscricaoMunicipal', NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal);
  AINIRec.WriteString(LSecao, 'NIF', NFSe.Prestador.IdentificacaoPrestador.NIF);
  AINIRec.WriteString(LSecao, 'cNaoNIF', NaoNIFToStr(NFSe.Prestador.IdentificacaoPrestador.cNaoNIF));
  AINIRec.WriteString(LSecao, 'CAEPF', NFSe.Prestador.IdentificacaoPrestador.CAEPF);

  AINIRec.WriteString(LSecao, 'RazaoSocial', NFSe.Prestador.RazaoSocial);

  AINIRec.WriteString(LSecao, 'CodigoMunicipio', NFSe.Prestador.Endereco.CodigoMunicipio);
  AINIRec.WriteString(LSecao, 'CEP', NFSe.Prestador.Endereco.CEP);
  AINIRec.WriteInteger(LSecao, 'CodigoPais', NFSe.Prestador.Endereco.CodigoPais);
  AINIRec.WriteString(LSecao, 'xMunicipio', NFSe.Prestador.Endereco.xMunicipio);
  AINIRec.WriteString(LSecao, 'UF', NFSe.Prestador.Endereco.UF);
  AINIRec.WriteString(LSecao, 'Logradouro', NFSe.Prestador.Endereco.Endereco);
  AINIRec.WriteString(LSecao, 'Numero', NFSe.Prestador.Endereco.Numero);
  AINIRec.WriteString(LSecao, 'Complemento', NFSe.Prestador.Endereco.Complemento);
  AINIRec.WriteString(LSecao, 'Bairro', NFSe.Prestador.Endereco.Bairro);

  AINIRec.WriteString(LSecao, 'Telefone', NFSe.Prestador.Contato.Telefone);
  AINIRec.WriteString(LSecao, 'Email', NFSe.Prestador.Contato.Email);

  AINIRec.WriteString(LSecao, 'opSimpNac', OptanteSNToStr(NFSe.OptanteSN));
  AINIRec.WriteString(LSecao, 'RegimeApuracaoSN', RegimeApuracaoSNToStr(NFSe.RegimeApuracaoSN));
  AINIRec.WriteString(LSecao, 'Regime', FpAOwner.RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao));
end;

procedure TNFSeW_PadraoNacional.GerarINIDadosTomador(AINIRec: TMemIniFile);
begin
  LSecao := 'Tomador';

  AINIRec.WriteString(LSecao, 'CNPJCPF', NFSe.Tomador.IdentificacaoTomador.CpfCnpj);
  AINIRec.WriteString(LSecao, 'InscricaoMunicipal', NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal);
  AINIRec.WriteString(LSecao, 'NIF', NFSe.Tomador.IdentificacaoTomador.NIF);
  AINIRec.WriteString(LSecao, 'cNaoNIF', NaoNIFToStr(NFSe.Tomador.IdentificacaoTomador.cNaoNIF));
  AINIRec.WriteString(LSecao, 'CAEPF', NFSe.Tomador.IdentificacaoTomador.CAEPF);

  AINIRec.WriteString(LSecao, 'RazaoSocial', NFSe.Tomador.RazaoSocial);

  AINIRec.WriteString(LSecao, 'CodigoMunicipio', NFSe.Tomador.Endereco.CodigoMunicipio);
  AINIRec.WriteString(LSecao, 'CEP', NFSe.Tomador.Endereco.CEP);
  AINIRec.WriteInteger(LSecao, 'CodigoPais', NFSe.Tomador.Endereco.CodigoPais);
  AINIRec.WriteString(LSecao, 'xMunicipio', NFSe.Tomador.Endereco.xMunicipio);
  AINIRec.WriteString(LSecao, 'UF', NFSe.Tomador.Endereco.UF);
  AINIRec.WriteString(LSecao, 'Logradouro', NFSe.Tomador.Endereco.Endereco);
  AINIRec.WriteString(LSecao, 'Numero', NFSe.Tomador.Endereco.Numero);
  AINIRec.WriteString(LSecao, 'Complemento', NFSe.Tomador.Endereco.Complemento);
  AINIRec.WriteString(LSecao, 'Bairro', NFSe.Tomador.Endereco.Bairro);

  AINIRec.WriteString(LSecao, 'Telefone', NFSe.Tomador.Contato.Telefone);
  AINIRec.WriteString(LSecao, 'Email', NFSe.Tomador.Contato.Email);
end;

procedure TNFSeW_PadraoNacional.GerarINIDadosIntermediario(
  AINIRec: TMemIniFile);
begin
  LSecao := 'Intermediario';

  AINIRec.WriteString(LSecao, 'CNPJCPF', NFSe.Intermediario.Identificacao.CpfCnpj);
  AINIRec.WriteString(LSecao, 'InscricaoMunicipal', NFSe.Intermediario.Identificacao.InscricaoMunicipal);
  AINIRec.WriteString(LSecao, 'NIF', NFSe.Intermediario.Identificacao.NIF);
  AINIRec.WriteString(LSecao, 'cNaoNIF', NaoNIFToStr(NFSe.Intermediario.Identificacao.cNaoNIF));
  AINIRec.WriteString(LSecao, 'CAEPF', NFSe.Intermediario.Identificacao.CAEPF);

  AINIRec.WriteString(LSecao, 'RazaoSocial', NFSe.Intermediario.RazaoSocial);

  AINIRec.WriteString(LSecao, 'CodigoMunicipio', NFSe.Intermediario.Endereco.CodigoMunicipio);
  AINIRec.WriteString(LSecao, 'CEP', NFSe.Intermediario.Endereco.CEP);
  AINIRec.WriteInteger(LSecao, 'CodigoPais', NFSe.Intermediario.Endereco.CodigoPais);
  AINIRec.WriteString(LSecao, 'xMunicipio', NFSe.Intermediario.Endereco.xMunicipio);
  AINIRec.WriteString(LSecao, 'UF', NFSe.Intermediario.Endereco.UF);
  AINIRec.WriteString(LSecao, 'Logradouro', NFSe.Intermediario.Endereco.Endereco);
  AINIRec.WriteString(LSecao, 'Numero', NFSe.Intermediario.Endereco.Numero);
  AINIRec.WriteString(LSecao, 'Complemento', NFSe.Intermediario.Endereco.Complemento);
  AINIRec.WriteString(LSecao, 'Bairro', NFSe.Intermediario.Endereco.Bairro);

  AINIRec.WriteString(LSecao, 'Telefone', NFSe.Intermediario.Contato.Telefone);
  AINIRec.WriteString(LSecao, 'Email', NFSe.Intermediario.Contato.Email);
end;

procedure TNFSeW_PadraoNacional.GerarINIDadosServico(AINIRec: TMemIniFile);
begin
  LSecao := 'Servico';

  AINIRec.WriteString(LSecao, 'CodigoMunicipio', NFSe.Servico.CodigoMunicipio);
  AINIRec.WriteInteger(LSecao, 'CodigoPais', NFSe.Servico.CodigoPais);
  AINIRec.WriteString(LSecao, 'ItemListaServico', NFSe.Servico.ItemListaServico);
  AINIRec.WriteString(LSecao, 'CodigoTributacaoMunicipio', NFSe.Servico.CodigoTributacaoMunicipio);
  AINIRec.WriteString(LSecao, 'Discriminacao', NFSe.Servico.Discriminacao);
  AINIRec.WriteString(LSecao, 'CodigoNBS', NFSe.Servico.CodigoNBS);
  AINIRec.WriteString(LSecao, 'CodigoInterContr', NFSe.Servico.CodigoInterContr);
end;

procedure TNFSeW_PadraoNacional.GerarINIComercioExterior(AINIRec: TMemIniFile);
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

procedure TNFSeW_PadraoNacional.GerarINILocacaoSubLocacao(AINIRec: TMemIniFile);
begin
  LSecao := 'LocacaoSubLocacao';

  AINIRec.WriteString(LSecao, 'categ', categToStr(NFSe.Servico.Locacao.categ));
  AINIRec.WriteString(LSecao, 'objeto', objetoToStr(NFSe.Servico.Locacao.objeto));
  AINIRec.WriteString(LSecao, 'extensao', NFSe.Servico.Locacao.extensao);
  AINIRec.WriteInteger(LSecao, 'nPostes', NFSe.Servico.Locacao.nPostes);
end;

procedure TNFSeW_PadraoNacional.GerarINIConstrucaoCivil(AINIRec: TMemIniFile);
begin
  LSecao := 'ConstrucaoCivil';

  AINIRec.WriteString(LSecao, 'CodigoObra', NFSe.ConstrucaoCivil.CodigoObra);
  AINIRec.WriteString(LSecao, 'inscImobFisc', NFSe.ConstrucaoCivil.inscImobFisc);

  AINIRec.WriteString(LSecao, 'CEP', NFSe.ConstrucaoCivil.Endereco.CEP);
  AINIRec.WriteString(LSecao, 'xMunicipio', NFSe.ConstrucaoCivil.Endereco.xMunicipio);
  AINIRec.WriteString(LSecao, 'UF', NFSe.ConstrucaoCivil.Endereco.UF);
  AINIRec.WriteString(LSecao, 'Logradouro', NFSe.ConstrucaoCivil.Endereco.Endereco);
  AINIRec.WriteString(LSecao, 'Numero', NFSe.ConstrucaoCivil.Endereco.Numero);
  AINIRec.WriteString(LSecao, 'Complemento', NFSe.ConstrucaoCivil.Endereco.Complemento);
  AINIRec.WriteString(LSecao, 'Bairro', NFSe.ConstrucaoCivil.Endereco.Bairro);
end;

procedure TNFSeW_PadraoNacional.GerarINIEvento(AINIRec: TMemIniFile);
begin
  LSecao := 'Evento';

  AINIRec.WriteString(LSecao, 'xNome', NFSe.Servico.Evento.xNome);
  AINIRec.WriteString(LSecao, 'dtIni', DateToStr(NFSe.Servico.Evento.dtIni));
  AINIRec.WriteString(LSecao, 'dtFim', DateToStr(NFSe.Servico.Evento.dtFim));
  AINIRec.WriteString(LSecao, 'idAtvEvt', NFSe.Servico.Evento.idAtvEvt);

  AINIRec.WriteString(LSecao, 'CEP', NFSe.Servico.Evento.Endereco.CEP);
  AINIRec.WriteString(LSecao, 'xMunicipio', NFSe.Servico.Evento.Endereco.xMunicipio);
  AINIRec.WriteString(LSecao, 'UF', NFSe.Servico.Evento.Endereco.UF);
  AINIRec.WriteString(LSecao, 'Logradouro', NFSe.Servico.Evento.Endereco.Endereco);
  AINIRec.WriteString(LSecao, 'Numero', NFSe.Servico.Evento.Endereco.Numero);
  AINIRec.WriteString(LSecao, 'Complemento', NFSe.Servico.Evento.Endereco.Complemento);
  AINIRec.WriteString(LSecao, 'Bairro', NFSe.Servico.Evento.Endereco.Bairro);
end;

procedure TNFSeW_PadraoNacional.GerarINIRodoviaria(AINIRec: TMemIniFile);
begin
  LSecao := 'Rodoviaria';

  AINIRec.WriteString(LSecao, 'categVeic', categVeicToStr(NFSe.Servico.explRod.categVeic));
  AINIRec.WriteInteger(LSecao, 'nEixos', NFSe.Servico.explRod.nEixos);
  AINIRec.WriteString(LSecao, 'rodagem', rodagemToStr(NFSe.Servico.explRod.rodagem));
  AINIRec.WriteString(LSecao, 'sentido', NFSe.Servico.explRod.sentido);
  AINIRec.WriteString(LSecao, 'placa', NFSe.Servico.explRod.placa);
  AINIRec.WriteString(LSecao, 'codAcessoPed', NFSe.Servico.explRod.codAcessoPed);
  AINIRec.WriteString(LSecao, 'codContrato', NFSe.Servico.explRod.codContrato);
end;

procedure TNFSeW_PadraoNacional.GerarINIInformacoesComplementares(
  AINIRec: TMemIniFile);
begin
  LSecao := 'InformacoesComplementares';

  AINIRec.WriteString(LSecao, 'idDocTec', NFSe.Servico.infoCompl.idDocTec);
  AINIRec.WriteString(LSecao, 'docRef', NFSe.Servico.infoCompl.docRef);
  AINIRec.WriteString(LSecao, 'xInfComp', NFSe.Servico.infoCompl.xInfComp);
end;

procedure TNFSeW_PadraoNacional.GerarINIValores(AINIRec: TMemIniFile);
begin
  LSecao := 'Valores';

  AINIRec.WriteFloat(LSecao, 'ValorRecebido', NFSe.Servico.Valores.ValorRecebido);
  AINIRec.WriteFloat(LSecao, 'ValorServicos', NFSe.Servico.Valores.ValorServicos);
  AINIRec.WriteFloat(LSecao, 'DescontoIncondicionado', NFSe.Servico.Valores.DescontoIncondicionado);
  AINIRec.WriteFloat(LSecao, 'DescontoCondicionado', NFSe.Servico.Valores.DescontoCondicionado);
  AINIRec.WriteFloat(LSecao, 'AliquotaDeducoes', NFSe.Servico.Valores.AliquotaDeducoes);
  AINIRec.WriteFloat(LSecao, 'ValorDeducoes', NFSe.Servico.Valores.ValorDeducoes);
end;

procedure TNFSeW_PadraoNacional.GerarINIDocumentosDeducoes(
  AINIRec: TMemIniFile);
var
  i: Integer;
begin
  for i := 0 to NFSe.Servico.Valores.DocDeducao.Count - 1 do
  begin
    LSecao := 'DocumentosDeducoes' + IntToStrZero(i+1, 3);

    AINIRec.WriteString(LSecao, 'chNFSe', NFSe.Servico.Valores.DocDeducao[i].chNFSe);
    AINIRec.WriteString(LSecao, 'chNFe', NFSe.Servico.Valores.DocDeducao[i].chNFe);
    AINIRec.WriteString(LSecao, 'nDocFisc', NFSe.Servico.Valores.DocDeducao[i].nDocFisc);
    AINIRec.WriteString(LSecao, 'nDoc', NFSe.Servico.Valores.DocDeducao[i].nDoc);
    AINIRec.WriteString(LSecao, 'tpDedRed', tpDedRedToStr(NFSe.Servico.Valores.DocDeducao[i].tpDedRed));
    AINIRec.WriteString(LSecao, 'xDescOutDed', NFSe.Servico.Valores.DocDeducao[i].xDescOutDed);
    AINIRec.WriteString(LSecao, 'dtEmiDoc', DateToStr(NFSe.Servico.Valores.DocDeducao[i].dtEmiDoc));
    AINIRec.WriteFloat(LSecao, 'vDedutivelRedutivel', NFSe.Servico.Valores.DocDeducao[i].vDedutivelRedutivel);
    AINIRec.WriteFloat(LSecao, 'vDeducaoReducao', NFSe.Servico.Valores.DocDeducao[i].vDeducaoReducao);

    AINIRec.WriteString(LSecao, 'cMunNFSeMun', NFSe.Servico.Valores.DocDeducao[i].NFSeMun.cMunNFSeMun);
    AINIRec.WriteString(LSecao, 'nNFSeMun', NFSe.Servico.Valores.DocDeducao[i].NFSeMun.nNFSeMun);
    AINIRec.WriteString(LSecao, 'cVerifNFSeMun', NFSe.Servico.Valores.DocDeducao[i].NFSeMun.cVerifNFSeMun);

    AINIRec.WriteString(LSecao, 'nNFS', NFSe.Servico.Valores.DocDeducao[i].NFNFS.nNFS);
    AINIRec.WriteString(LSecao, 'modNFS', NFSe.Servico.Valores.DocDeducao[i].NFNFS.modNFS);
    AINIRec.WriteString(LSecao, 'serieNFS', NFSe.Servico.Valores.DocDeducao[i].NFNFS.serieNFS);

    GerarINIDocumentosDeducoesFornecedor(AINIRec, NFSe.Servico.Valores.DocDeducao[i].fornec, i);
  end;
end;

procedure TNFSeW_PadraoNacional.GerarINIDocumentosDeducoesFornecedor(
  AINIRec: TMemIniFile; fornec: TInfoPessoa; Indice: Integer);
begin
  LSecao := 'DocumentosDeducoesFornecedor' + IntToStrZero(Indice+1, 3);

  AINIRec.WriteString(LSecao, 'CNPJCPF', fornec.Identificacao.CpfCnpj);
  AINIRec.WriteString(LSecao, 'InscricaoMunicipal', fornec.Identificacao.InscricaoMunicipal);
  AINIRec.WriteString(LSecao, 'NIF', fornec.Identificacao.NIF);
  AINIRec.WriteString(LSecao, 'cNaoNIF', NaoNIFToStr(fornec.Identificacao.cNaoNIF));
  AINIRec.WriteString(LSecao, 'CAEPF', fornec.Identificacao.CAEPF);

  AINIRec.WriteString(LSecao, 'CEP', fornec.Endereco.CEP);
  AINIRec.WriteString(LSecao, 'xMunicipio', fornec.Endereco.xMunicipio);
  AINIRec.WriteString(LSecao, 'UF', fornec.Endereco.UF);
  AINIRec.WriteString(LSecao, 'Logradouro', fornec.Endereco.Endereco);
  AINIRec.WriteString(LSecao, 'Numero', fornec.Endereco.Numero);
  AINIRec.WriteString(LSecao, 'Complemento', fornec.Endereco.Complemento);
  AINIRec.WriteString(LSecao, 'Bairro', fornec.Endereco.Bairro);

  AINIRec.WriteString(LSecao, 'Telefone', fornec.Contato.Telefone);
  AINIRec.WriteString(LSecao, 'Email', fornec.Contato.Email);
end;

procedure TNFSeW_PadraoNacional.GerarINIValoresTribMun(AINIRec: TMemIniFile);
begin
  LSecao := 'tribMun';

  AINIRec.WriteString(LSecao, 'tribISSQN', tribISSQNToStr(NFSe.Servico.Valores.tribMun.tribISSQN));
  AINIRec.WriteInteger(LSecao, 'cPaisResult', NFSe.Servico.Valores.tribMun.cPaisResult);
//  AINIRec.WriteString(LSecao, 'tpBM', tpBMToStr(NFSe.Servico.Valores.tribMun.tpBM));
  AINIRec.WriteFloat(LSecao, 'vRedBCBM', NFSe.Servico.Valores.tribMun.vRedBCBM);
  AINIRec.WriteFloat(LSecao, 'pRedBCBM', NFSe.Servico.Valores.tribMun.pRedBCBM);
  AINIRec.WriteString(LSecao, 'tpSusp', tpSuspToStr(NFSe.Servico.Valores.tribMun.tpSusp));
  AINIRec.WriteString(LSecao, 'nProcesso', NFSe.Servico.Valores.tribMun.nProcesso);
  AINIRec.WriteString(LSecao, 'tpImunidade', tpImunidadeToStr(NFSe.Servico.Valores.tribMun.tpImunidade));
  AINIRec.WriteFloat(LSecao, 'pAliq', NFSe.Servico.Valores.tribMun.pAliq);
  AINIRec.WriteString(LSecao, 'tpRetISSQN', tpRetISSQNToStr(NFSe.Servico.Valores.tribMun.tpRetISSQN));
end;

procedure TNFSeW_PadraoNacional.GerarINIValoresTribFederal(
  AINIRec: TMemIniFile);
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

procedure TNFSeW_PadraoNacional.GerarINIValoresTotalTrib(AINIRec: TMemIniFile);
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

procedure TNFSeW_PadraoNacional.GerarINIDadosEmitente(
  const AINIRec: TMemIniFile);
begin
  LSecao := 'Emitente';

  AINIRec.WriteString(LSecao, 'CNPJ', NFSe.infNFSe.emit.Identificacao.CpfCnpj);
  AINIRec.WriteString(LSecao, 'InscricaoMunicipal', NFSe.infNFSe.emit.Identificacao.InscricaoMunicipal);

  AINIRec.WriteString(LSecao, 'RazaoSocial', NFSe.infNFSe.emit.RazaoSocial);
  AINIRec.WriteString(LSecao, 'NomeFantasia', NFSe.infNFSe.emit.NomeFantasia);

  AINIRec.WriteString(LSecao, 'Logradouro', NFSe.infNFSe.emit.Endereco.Endereco);
  AINIRec.WriteString(LSecao, 'Numero', NFSe.infNFSe.emit.Endereco.Numero);
  AINIRec.WriteString(LSecao, 'Complemento', NFSe.infNFSe.emit.Endereco.Complemento);
  AINIRec.WriteString(LSecao, 'Bairro', NFSe.infNFSe.emit.Endereco.Bairro);
  AINIRec.WriteString(LSecao, 'CodigoMunicipio', NFSe.infNFSe.emit.Endereco.CodigoMunicipio);
  AINIRec.WriteString(LSecao, 'CEP', NFSe.infNFSe.emit.Endereco.CEP);
  AINIRec.WriteString(LSecao, 'xMunicipio', NFSe.infNFSe.emit.Endereco.xMunicipio);
  AINIRec.WriteString(LSecao, 'UF', NFSe.infNFSe.emit.Endereco.UF);

  AINIRec.WriteString(LSecao, 'Telefone', NFSe.infNFSe.emit.Contato.Telefone);
  AINIRec.WriteString(LSecao, 'Email', NFSe.infNFSe.emit.Contato.Email);
end;

procedure TNFSeW_PadraoNacional.GerarINIValoresNFSe(const AINIRec: TMemIniFile);
begin
  LSecao := 'ValoresNFSe';

  AINIRec.WriteFloat(LSecao, 'vCalcDR', NFSe.infNFSe.valores.vCalcDR);
  AINIRec.WriteString(LSecao, 'tpBM', NFSe.infNFSe.valores.tpBM);
  AINIRec.WriteFloat(LSecao, 'vCalcBM', NFSe.infNFSe.valores.vCalcBM);
  AINIRec.WriteFloat(LSecao, 'vBC', NFSe.infNFSe.valores.BaseCalculo);
  AINIRec.WriteFloat(LSecao, 'pAliqAplic', NFSe.infNFSe.valores.Aliquota);
  AINIRec.WriteFloat(LSecao, 'vISSQN', NFSe.infNFSe.valores.ValorIss);
  AINIRec.WriteFloat(LSecao, 'vTotalRet', NFSe.infNFSe.valores.vTotalRet);
  AINIRec.WriteFloat(LSecao, 'vLiq', NFSe.infNFSe.valores.ValorLiquidoNfse);

  AINIRec.WriteString(LSecao, 'xOutInf', NFSe.OutrasInformacoes);
end;

end.
