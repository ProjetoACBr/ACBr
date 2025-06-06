{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrNFSeXGravarXml_ABRASFv1;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlDocument, INIFiles, ACBrNFSeXClass,
  ACBrNFSeXGravarXml;

type
  { TNFSeW_ABRASFv1 }

  TNFSeW_ABRASFv1 = class(TNFSeWClass)
  private
    FpSecao: String;

    FNrOcorrComplTomador: Integer;
    FNrOcorrOutrasRet: Integer;
    FNrOcorrAliquota: Integer;
    FNrOcorrBaseCalc: Integer;
    FNrOcorrDescIncond: Integer;
    FNrOcorrDescCond: Integer;
    FNrOcorrFoneTomador: Integer;
    FNrOcorrEmailTomador: Integer;
    FNrOcorrValLiq: Integer;
    FNrOcorrOptanteSN: Integer;
    FNrOcorrIncentCult: Integer;
    FNrOcorrCodigoCnae: Integer;
    FNrOcorrCodTribMun: Integer;
    FNrOcorrValorISSRetido_1: Integer;
    FNrOcorrValorISSRetido_2: Integer;
    FNrOcorrValorTotalRecebido: Integer;
    FNrOcorrInformacoesComplemetares: Integer;
    FNrOcorrInscEstTomador: Integer;
    FNrOcorrOutrasInformacoes: Integer;
    FNrOcorrNaturezaOperacao: Integer;
    FNrOcorrRegimeEspecialTributacao: Integer;
    FNrOcorrValorDeducoes: Integer;
    FNrOcorrRazaoSocialInterm: Integer;
    FNrOcorrRespRetencao: Integer;
    FNrOcorrMunIncid: Integer;
    FNrOcorrIdCidade: Integer;
    FNrOcorrCodigoPaisTomador: Integer;
    FNrOcorrStatus: Integer;
    FNrOcorrValorPis: Integer;
    FNrOcorrValorInss: Integer;
    FNrOcorrValorIr: Integer;
    FNrOcorrValorCsll: Integer;
    FNrOcorrValorIss: Integer;
    FNrOcorrValorCofins: Integer;
    FNrOcorrInscMunTomador: Integer;
    FGerarTagTomadorMesmoVazia: Boolean;

  protected
    procedure Configuracao; override;

    //======Arquivo XML==========================================
    function GerarInfRps: TACBrXmlNode; virtual;
    function GerarIdentificacaoRPS: TACBrXmlNode; virtual;
    function GerarRPSSubstituido: TACBrXmlNode; virtual;
    function GerarServico: TACBrXmlNode; virtual;
    function GerarValores: TACBrXmlNode; virtual;
    function GerarItensServico: TACBrXmlNodeArray; virtual;
    function GerarPrestador: TACBrXmlNode; virtual;
    function GerarTomador: TACBrXmlNode; virtual;
    function GerarIdentificacaoTomador: TACBrXmlNode; virtual;
    function GerarEnderecoTomador: TACBrXmlNode; virtual;
    function GerarContatoTomador: TACBrXmlNode; virtual;
    function GerarIntermediarioServico: TACBrXmlNode; virtual;
    function GerarConstrucaoCivil: TACBrXmlNode; virtual;
    function GerarCondicaoPagamento: TACBrXmlNode; virtual;
    function GerarParcelas: TACBrXmlNodeArray; virtual;

    function GerarServicoCodigoMunicipio: TACBrXmlNode; virtual;
    function GerarCodigoMunicipioUF: TACBrXmlNodeArray; virtual;

    //======Arquivo INI===========================================
    procedure GerarINISecaoIdentificacaoNFSe(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoIdentificacaoRps(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoRpsSubstituido(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoNFSeSubstituicao(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoNFSeCancelamento(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoPrestador(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoTomador(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoIntermediario(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoTransportadora(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoConstrucaoCivil(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoServico(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoDeducoes(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoQuartos(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoEmail(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoGenericos(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoDespesas(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoItens(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoDadosDeducao(const AINIRec: TMemIniFile; const AIndice: Integer); virtual;
    procedure GerarINISecaoDadosProssionalParceiro(const AINIRec: TMemIniFile; const AIndice: Integer); virtual;
    procedure GerarINISecaoComercioExterior(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoLocacaoSubLocacao(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoEvento(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoRodoviaria(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoInformacoesComplementares(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoValores(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoValoresNFSe(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoDocumentosDeducoes(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoDocumentosDeducoesFornecedor(const AINIRec: TMemIniFile; const AIndice: Integer); virtual;
    procedure GerarINISecaotribMun(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaotribFederal(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaototTrib(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoCondicaoPagamento(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoOrgaoGerador(const AINIRec: TMemIniFile); virtual;
    procedure GerarINISecaoParcelas(const AINIRec: TMemIniFile); virtual;

  public
    function GerarXml: Boolean; override;
    function GerarIni: string; override;

    property NrOcorrComplTomador: Integer read FNrOcorrComplTomador write FNrOcorrComplTomador;
    property NrOcorrOutrasRet: Integer    read FNrOcorrOutrasRet    write FNrOcorrOutrasRet;
    property NrOcorrAliquota: Integer     read FNrOcorrAliquota     write FNrOcorrAliquota;
    property NrOcorrValorPis: Integer     read FNrOcorrValorPis     write FNrOcorrValorPis;
    property NrOcorrValorCofins: Integer  read FNrOcorrValorCofins  write FNrOcorrValorCofins;
    property NrOcorrValorInss: Integer    read FNrOcorrValorInss    write FNrOcorrValorInss;
    property NrOcorrValorIr: Integer      read FNrOcorrValorIr      write FNrOcorrValorIr;
    property NrOcorrValorCsll: Integer    read FNrOcorrValorCsll    write FNrOcorrValorCsll;
    property NrOcorrValorIss: Integer     read FNrOcorrValorIss     write FNrOcorrValorIss;
    property NrOcorrBaseCalc: Integer     read FNrOcorrBaseCalc     write FNrOcorrBaseCalc;
    property NrOcorrDescIncond: Integer   read FNrOcorrDescIncond   write FNrOcorrDescIncond;
    property NrOcorrDescCond: Integer     read FNrOcorrDescCond     write FNrOcorrDescCond;
    property NrOcorrFoneTomador: Integer  read FNrOcorrFoneTomador  write FNrOcorrFoneTomador;
    property NrOcorrEmailTomador: Integer read FNrOcorrEmailTomador write FNrOcorrEmailTomador;
    property NrOcorrValLiq: Integer       read FNrOcorrValLiq       write FNrOcorrValLiq;
    property NrOcorrOptanteSN: Integer    read FNrOcorrOptanteSN    write FNrOcorrOptanteSN;
    property NrOcorrIncentCult: Integer   read FNrOcorrIncentCult   write FNrOcorrIncentCult;
    property NrOcorrCodigoCnae: Integer   read FNrOcorrCodigoCnae   write FNrOcorrCodigoCnae;
    property NrOcorrCodTribMun: Integer   read FNrOcorrCodTribMun   write FNrOcorrCodTribMun;
    property NrOcorrRespRetencao: Integer read FNrOcorrRespRetencao write FNrOcorrRespRetencao;
    property NrOcorrMunIncid: Integer     read FNrOcorrMunIncid     write FNrOcorrMunIncid;
    property NrOcorrIdCidade: Integer     read FNrOcorrIdCidade     write FNrOcorrIdCidade;
    property NrOcorrStatus: Integer       read FNrOcorrStatus       write FNrOcorrStatus;

    property NrOcorrValorDeducoes: Integer      read FNrOcorrValorDeducoes      write FNrOcorrValorDeducoes;
    property NrOcorrNaturezaOperacao: Integer   read FNrOcorrNaturezaOperacao   write FNrOcorrNaturezaOperacao;
    property NrOcorrOutrasInformacoes: Integer  read FNrOcorrOutrasInformacoes  write FNrOcorrOutrasInformacoes;
    property NrOcorrValorTotalRecebido: Integer read FNrOcorrValorTotalRecebido write FNrOcorrValorTotalRecebido;
    property NrOcorrValorISSRetido_1: Integer   read FNrOcorrValorISSRetido_1   write FNrOcorrValorISSRetido_1;
    property NrOcorrValorISSRetido_2: Integer   read FNrOcorrValorISSRetido_2   write FNrOcorrValorISSRetido_2;
    property NrOcorrInscEstTomador: Integer     read FNrOcorrInscEstTomador     write FNrOcorrInscEstTomador;
    property NrOcorrCodigoPaisTomador: Integer  read FNrOcorrCodigoPaisTomador  write FNrOcorrCodigoPaisTomador;
    property NrOcorrRazaoSocialInterm: Integer  read FNrOcorrRazaoSocialInterm  write FNrOcorrRazaoSocialInterm;
    property NrOcorrInscMunTomador: Integer     read FNrOcorrInscMunTomador     write FNrOcorrInscMunTomador;

    property NrOcorrRegimeEspecialTributacao: Integer read FNrOcorrRegimeEspecialTributacao write FNrOcorrRegimeEspecialTributacao;
    property NrOcorrInformacoesComplemetares: Integer read FNrOcorrInformacoesComplemetares write FNrOcorrInformacoesComplemetares;

    property GerarTagTomadorMesmoVazia: Boolean read FGerarTagTomadorMesmoVazia write FGerarTagTomadorMesmoVazia;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrXmlBase,
  ACBrNFSeXConversao, ACBrNFSeXConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS dos provedores:
//     que seguem a vers�o 1.xx do layout da ABRASF
//==============================================================================

{ TNFSeW_ABRASFv1 }

procedure TNFSeW_ABRASFv1.Configuracao;
begin
  // Executa a Configura��o Padr�o
  inherited Configuracao;

  // Numero de Ocorrencias Minimas de uma tag
  // se for  0 s� gera a tag se o conteudo for diferente de vazio ou zero
  // se for  1 sempre vai gerar a tag
  // se for -1 nunca gera a tag

  // Por padr�o as tags abaixo s�o opcionais
  FNrOcorrComplTomador := 0;
  FNrOcorrFoneTomador := 0;
  FNrOcorrEmailTomador := 0;
  FNrOcorrOutrasRet := 0;
  FNrOcorrAliquota := 0;

  FNrOcorrValorPis := 0;
  FNrOcorrValorCofins := 0;
  FNrOcorrValorInss := 0;
  FNrOcorrValorIr := 0;
  FNrOcorrValorCsll := 0;
  FNrOcorrValorIss := 0;
  FNrOcorrBaseCalc := 0;
  FNrOcorrDescIncond := 0;
  FNrOcorrDescCond := 0;
  FNrOcorrValLiq := 0;
  FNrOcorrCodigoCnae := 0;
  FNrOcorrCodTribMun := 0;
  FNrOcorrMunIncid := 0;
  FNrOcorrInscMunTomador := 0;
  FNrOcorrCodigoPaisTomador := 0;

  FNrOcorrRazaoSocialInterm := 0;
  FNrOcorrValorDeducoes := 0;
  FNrOcorrValorISSRetido_1 := 0;

  FNrOcorrRegimeEspecialTributacao := 0;

  // Por padr�o as tags abaixo s�o obrigat�rias
  FNrOcorrOptanteSN := 1;
  FNrOcorrIncentCult := 1;
  FNrOcorrStatus := 1;

  FNrOcorrNaturezaOperacao := 1;

  // Por padr�o as tags abaixo n�o devem ser geradas
  FNrOcorrRespRetencao := -1;
  FNrOcorrIdCidade := -1;
  FNrOcorrValorISSRetido_2 := -1;
  FNrOcorrValorTotalRecebido := -1;
  FNrOcorrInscEstTomador := -1;
  FNrOcorrOutrasInformacoes := -1;

  FNrOcorrInformacoesComplemetares := -1;

  FGerarTagTomadorMesmoVazia := False;
end;

function TNFSeW_ABRASFv1.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado

  ListaDeAlertas.Clear;

  FDocument.Clear();

  NFSeNode := CreateElement('Rps');

  if FpAOwner.ConfigMsgDados.XmlRps.xmlns <> '' then
    NFSeNode.SetNamespace(FpAOwner.ConfigMsgDados.XmlRps.xmlns, Self.PrefixoPadrao);

  FDocument.Root := NFSeNode;

  if FormatoDiscriminacao <> fdNenhum then
    ConsolidarVariosItensServicosEmUmSo;

  xmlNode := GerarInfRps;
  NFSeNode.AppendChild(xmlNode);

  Result := True;
end;

function TNFSeW_ABRASFv1.GerarInfRps: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := CreateElement('InfRps');

  DefinirIDRps;

  if (FpAOwner.ConfigGeral.Identificador <> '') then
    Result.SetAttribute(FpAOwner.ConfigGeral.Identificador, NFSe.infID.ID);

  Result.AppendChild(GerarIdentificacaoRPS);

  Result.AppendChild(AddNode(FormatoEmissao, '#4', 'DataEmissao', 19, 19, 1,
                                                  NFSe.DataEmissao, DSC_DHEMI));

  Result.AppendChild(AddNode(tcStr, '#5', 'NaturezaOperacao', 1, 3, NrOcorrNaturezaOperacao,
                   NaturezaOperacaoToStr(NFSe.NaturezaOperacao), DSC_INDNATOP));

  if (NFSe.RegimeEspecialTributacao <> retNenhum) then
    Result.AppendChild(AddNode(tcStr, '#6', 'RegimeEspecialTributacao', 1, 1, NrOcorrRegimeEspecialTributacao,
   FpAOwner.RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao), DSC_REGISSQN));

  Result.AppendChild(AddNode(tcStr, '#7', 'OptanteSimplesNacional', 1, 1, NrOcorrOptanteSN,
   FpAOwner.SimNaoToStr(NFSe.OptanteSimplesNacional), DSC_INDOPSN));

  Result.AppendChild(AddNode(tcStr, '#8', 'IncentivadorCultural', 1, 1, NrOcorrIncentCult,
   FpAOwner.SimNaoToStr(NFSe.IncentivadorCultural), DSC_INDINCCULT));

  Result.AppendChild(AddNode(tcStr, '#9', 'Status', 1, 1, NrOcorrStatus,
                       FpAOwner.StatusRPSToStr(NFSe.StatusRps), DSC_INDSTATUS));

  Result.AppendChild(AddNode(tcStr, '#11', 'OutrasInformacoes', 1, 255, NrOcorrOutrasInformacoes,
    StringReplace(NFSe.OutrasInformacoes, Opcoes.QuebraLinha,
           FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), DSC_OUTRASINF));

  Result.AppendChild(GerarRPSSubstituido);
  Result.AppendChild(GerarServico);
  Result.AppendChild(GerarPrestador);
  Result.AppendChild(GerarTomador);
  Result.AppendChild(GerarIntermediarioServico);
  Result.AppendChild(GerarConstrucaoCivil);
  Result.AppendChild(GerarCondicaoPagamento);
end;

function TNFSeW_ABRASFv1.GerarIdentificacaoRPS: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := CreateElement('IdentificacaoRps');

  Result.AppendChild(AddNode(tcStr, '#1', 'Numero', 1, 15, 1,
                         OnlyNumber(NFSe.IdentificacaoRps.Numero), DSC_NUMRPS));

  Result.AppendChild(AddNode(tcStr, '#2', 'Serie', 1, 5, 1,
                                    NFSe.IdentificacaoRps.Serie, DSC_SERIERPS));

  Result.AppendChild(AddNode(tcStr, '#3', 'Tipo', 1, 1, 1,
               FpAOwner.TipoRPSToStr(NFSe.IdentificacaoRps.Tipo), DSC_TIPORPS));
end;

function TNFSeW_ABRASFv1.GerarRPSSubstituido: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := nil;

  if NFSe.RpsSubstituido.Numero <> '' then
  begin
    Result := CreateElement('RpsSubstituido');

    Result.AppendChild(AddNode(tcStr, '#1', 'Numero', 1, 15, 1,
                        OnlyNumber(NFSe.RpsSubstituido.Numero), DSC_NUMRPSSUB));

    Result.AppendChild(AddNode(tcStr, '#2', 'Serie', 1, 5, 1,
                                   NFSe.RpsSubstituido.Serie, DSC_SERIERPSSUB));

    Result.AppendChild(AddNode(tcStr, '#3', 'Tipo', 1, 1, 1,
              FpAOwner.TipoRPSToStr(NFSe.RpsSubstituido.Tipo), DSC_TIPORPSSUB));
  end;
end;

function TNFSeW_ABRASFv1.GerarServico: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
  item: string;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := CreateElement('Servico');

  Result.AppendChild(GerarValores);

  item := FormatarItemServico(NFSe.Servico.ItemListaServico, FormatoItemListaServico);

  Result.AppendChild(AddNode(tcStr, '#29', 'ItemListaServico', 1, 5, NrOcorrItemListaServico,
                                                          item, DSC_CLISTSERV));

  Result.AppendChild(AddNode(tcStr, '#30', 'CodigoCnae', 1, 7, NrOcorrCodigoCnae,
                                OnlyNumber(NFSe.Servico.CodigoCnae), DSC_CNAE));

  Result.AppendChild(AddNode(tcStr, '#31', 'CodigoTributacaoMunicipio', 1, 20, NrOcorrCodTribMun,
                     NFSe.Servico.CodigoTributacaoMunicipio, DSC_CSERVTRIBMUN));

  Result.AppendChild(AddNode(tcStr, '#32', 'Discriminacao', 1, 2000, 1,
    StringReplace(NFSe.Servico.Discriminacao, Opcoes.QuebraLinha,
               FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), DSC_DISCR));

  Result.AppendChild(AddNode(tcStr, '#', 'InformacoesComplementares', 1, 255, NrOcorrInformacoesComplemetares,
    StringReplace(NFSe.InformacoesComplementares, Opcoes.QuebraLinha,
                      FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), ''));

  Result.AppendChild(GerarServicoCodigoMunicipio);

  nodeArray := GerarItensServico;
  if nodeArray <> nil then
  begin
    for i := 0 to Length(nodeArray) - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

function TNFSeW_ABRASFv1.GerarValores: TACBrXmlNode;
var
  Aliquota: Double;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := CreateElement('Valores');

  Result.AppendChild(AddNode(tcDe2, '#13', 'ValorServicos', 1, 15, 1,
                             NFSe.Servico.Valores.ValorServicos, DSC_VSERVICO));

  Result.AppendChild(AddNode(tcDe2, '#14', 'ValorDeducoes', 1, 15, NrOcorrValorDeducoes,
                            NFSe.Servico.Valores.ValorDeducoes, DSC_VDEDUCISS));

  Result.AppendChild(AddNode(tcDe2, '#14', 'ValorTotalRecebido', 1, 15, NrOcorrValorTotalRecebido,
                         NFSe.Servico.Valores.ValorTotalRecebido, DSC_VTOTREC));

  Result.AppendChild(AddNode(tcDe2, '#15', 'ValorPis', 1, 15, NrOcorrValorPis,
                                      NFSe.Servico.Valores.ValorPis, DSC_VPIS));

  Result.AppendChild(AddNode(tcDe2, '#16', 'ValorCofins', 1, 15, NrOcorrValorCofins,
                                NFSe.Servico.Valores.ValorCofins, DSC_VCOFINS));

  Result.AppendChild(AddNode(tcDe2, '#17', 'ValorInss', 1, 15, NrOcorrValorInss,
                                    NFSe.Servico.Valores.ValorInss, DSC_VINSS));

  Result.AppendChild(AddNode(tcDe2, '#18', 'ValorIr', 1, 15, NrOcorrValorIr,
                                        NFSe.Servico.Valores.ValorIr, DSC_VIR));

  Result.AppendChild(AddNode(tcDe2, '#19', 'ValorCsll', 1, 15, NrOcorrValorCsll,
                                    NFSe.Servico.Valores.ValorCsll, DSC_VCSLL));

  Result.AppendChild(AddNode(tcStr, '#20', 'IssRetido', 1, 1, 1,
    FpAOwner.SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), DSC_INDISSRET));

  Result.AppendChild(AddNode(tcDe2, '#21', 'ValorIss', 1, 15, NrOcorrValorIss,
                                      NFSe.Servico.Valores.ValorIss, DSC_VISS));

  Result.AppendChild(AddNode(tcDe2, '#22', 'ValorIssRetido', 1, 15, NrOcorrValorISSRetido_1,
                               NFSe.Servico.Valores.ValorIssRetido, DSC_VNFSE));

  Result.AppendChild(AddNode(tcDe2, '#23', 'OutrasRetencoes', 1, 15, NrOcorrOutrasRet,
                    NFSe.Servico.Valores.OutrasRetencoes, DSC_OUTRASRETENCOES));

  Result.AppendChild(AddNode(tcDe2, '#24', 'BaseCalculo', 1, 15, NrOcorrBaseCalc,
                                 NFSe.Servico.Valores.BaseCalculo, DSC_VBCISS));

  Aliquota := NormatizarAliquota(NFSe.Servico.Valores.Aliquota, DivAliq100);

  Result.AppendChild(AddNode(FormatoAliq, '#25', 'Aliquota', 1, 5, NrOcorrAliquota,
                                                          Aliquota, DSC_VALIQ));

  Result.AppendChild(AddNode(tcDe2, '#26', 'ValorLiquidoNfse', 1, 15, NrOcorrValLiq,
                             NFSe.Servico.Valores.ValorLiquidoNfse, DSC_VNFSE));

  Result.AppendChild(AddNode(tcDe2, '#22', 'ValorIssRetido', 1, 15, NrOcorrValorISSRetido_2,
                               NFSe.Servico.Valores.ValorIssRetido, DSC_VNFSE));

  Result.AppendChild(AddNode(tcDe2, '#27', 'DescontoIncondicionado', 1, 15, NrOcorrDescIncond,
                 NFSe.Servico.Valores.DescontoIncondicionado, DSC_VDESCINCOND));

  Result.AppendChild(AddNode(tcDe2, '#28', 'DescontoCondicionado', 1, 15, NrOcorrDescCond,
                     NFSe.Servico.Valores.DescontoCondicionado, DSC_VDESCCOND));
end;

function TNFSeW_ABRASFv1.GerarServicoCodigoMunicipio: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  // No provedor ISSNet o nome da tag � diferente do padr�o
  Result := AddNode(tcStr, '#33', 'CodigoMunicipio', 1, 7, 1,
                            OnlyNumber(NFSe.Servico.CodigoMunicipio), DSC_CMUN);
end;

function TNFSeW_ABRASFv1.GerarCodigoMunicipioUF: TACBrXmlNodeArray;
begin
  SetLength(Result, 3);

  Result[0] := AddNode(tcStr, '#43', 'CodigoMunicipio', 7, 7, 0,
                   OnlyNumber(NFSe.Tomador.Endereco.CodigoMunicipio), DSC_CMUN);

  Result[1] := AddNode(tcStr, '#44', 'Uf', 2, 2, 0,
                                              NFSe.Tomador.Endereco.UF, DSC_UF);

  if (OnlyNumber(NFSe.Tomador.Endereco.CodigoMunicipio) = '9999999') or
     (NrOcorrCodigoPaisTomador = 1) then
    Result[2] := AddNode(tcInt, '#45', 'CodigoPais', 4, 4, NrOcorrCodigoPaisTomador,
                                   NFSe.Tomador.Endereco.CodigoPais, DSC_CPAIS);
end;

function TNFSeW_ABRASFv1.GerarItensServico: TACBrXmlNodeArray;
begin
  // Aqui n�o fazer nada, pois por padr�o ABRASF V1 n�o tem lista de servi�os
  Result := nil;
end;

function TNFSeW_ABRASFv1.GerarPrestador: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := CreateElement('Prestador');

  Result.AppendChild(GerarCNPJ(NFSe.Prestador.IdentificacaoPrestador.CpfCnpj));

  Result.AppendChild(AddNode(tcStr, '#35', 'InscricaoMunicipal', 1, 15, 0,
             NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal, DSC_IM));
end;

function TNFSeW_ABRASFv1.GerarTomador: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
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

    Result.AppendChild(GerarEnderecoTomador);
    Result.AppendChild(GerarContatoTomador);
  end;
end;

function TNFSeW_ABRASFv1.GerarIdentificacaoTomador: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := CreateElement('IdentificacaoTomador');

  if NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '' then
    Result.AppendChild(GerarCPFCNPJ(NFSe.Tomador.IdentificacaoTomador.CpfCnpj));

  Result.AppendChild(AddNode(tcStr, '#37', 'InscricaoMunicipal', 1, 15, NrOcorrInscMunTomador,
                 NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, DSC_IM));

  Result.AppendChild(AddNode(tcStr, '#38', 'InscricaoEstadual', 1, 20, NrocorrInscEstTomador,
                  NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, DSC_IE));
end;

function TNFSeW_ABRASFv1.GerarEnderecoTomador: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := nil;

  if (NFSe.Tomador.Endereco.Endereco <> '') or (NFSe.Tomador.Endereco.Numero <> '') or
     (NFSe.Tomador.Endereco.Bairro <> '') or (NFSe.Tomador.Endereco.CodigoMunicipio <> '') or
     (NFSe.Tomador.Endereco.UF <> '') or (NFSe.Tomador.Endereco.CEP <> '') then
  begin
    Result := CreateElement('Endereco');

    Result.AppendChild(AddNode(tcStr, '#39', 'Endereco', 1, 125, 0,
                                     NFSe.Tomador.Endereco.Endereco, DSC_XLGR));

    Result.AppendChild(AddNode(tcStr, '#40', 'Numero', 1, 10, 0,
                                        NFSe.Tomador.Endereco.Numero, DSC_NRO));

    Result.AppendChild(AddNode(tcStr, '#41', 'Complemento', 1, 60, NrOcorrComplTomador,
                                  NFSe.Tomador.Endereco.Complemento, DSC_XCPL));

    Result.AppendChild(AddNode(tcStr, '#42', 'Bairro', 1, 60, 0,
                                    NFSe.Tomador.Endereco.Bairro, DSC_XBAIRRO));

    nodeArray := GerarCodigoMunicipioUF;

    if nodeArray <> nil then
    begin
      for i := 0 to Length(nodeArray) - 1 do
      begin
        Result.AppendChild(nodeArray[i]);
      end;
    end;

    Result.AppendChild(AddNode(tcStr, '#45', 'Cep', 8, 8, 0,
                               OnlyNumber(NFSe.Tomador.Endereco.CEP), DSC_CEP));
  end;
end;

function TNFSeW_ABRASFv1.GerarContatoTomador: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := nil;

  if (NFSe.Tomador.Contato.Telefone <> '') or (NFSe.Tomador.Contato.Email <> '') then
  begin
    Result := CreateElement('Contato');

    Result.AppendChild(AddNode(tcStr, '#46', 'Telefone', 1, 11, NrOcorrFoneTomador,
                          OnlyNumber(NFSe.Tomador.Contato.Telefone), DSC_FONE));

    Result.AppendChild(AddNode(tcStr, '#47', 'Email', 1, 80, NrOcorrEmailTomador,
                                        NFSe.Tomador.Contato.Email, DSC_EMAIL));
  end;
end;

function TNFSeW_ABRASFv1.GerarIntermediarioServico: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := nil;

  if (NFSe.Intermediario.RazaoSocial <> '') or
     (NFSe.Intermediario.Identificacao.CpfCnpj <> '') then
  begin
    Result := CreateElement('IntermediarioServico');

    Result.AppendChild(AddNode(tcStr, '#48', 'RazaoSocial', 1, 115, 1,
                                    NFSe.Intermediario.RazaoSocial, DSC_XNOME));

    Result.AppendChild(GerarCPFCNPJ(NFSe.Intermediario.Identificacao.CpfCnpj));

    Result.AppendChild(AddNode(tcStr, '#50', 'InscricaoMunicipal', 1, 15, 0,
                  NFSe.Intermediario.Identificacao.InscricaoMunicipal, DSC_IM));
  end;
end;

function TNFSeW_ABRASFv1.GerarConstrucaoCivil: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := nil;

  if (NFSe.ConstrucaoCivil.CodigoObra <> '') then
  begin
    Result := CreateElement('ConstrucaoCivil');

    Result.AppendChild(AddNode(tcStr, '#51', 'CodigoObra', 1, 15, 1,
                                   NFSe.ConstrucaoCivil.CodigoObra, DSC_COBRA));

    Result.AppendChild(AddNode(tcStr, '#52', 'Art', 1, 15, 1,
                                            NFSe.ConstrucaoCivil.Art, DSC_ART));
  end;
end;

function TNFSeW_ABRASFv1.GerarCondicaoPagamento: TACBrXmlNode;
begin
  // Aqui n�o fazer nada
  Result := nil;
end;

function TNFSeW_ABRASFv1.GerarParcelas: TACBrXmlNodeArray;
begin
  // Aqui n�o fazer nada
  Result := nil;
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoIdentificacaoNFSe(const AINIRec: TMemIniFile);
begin
  FpSecao:= 'IdentificacaoNFSe';

  if NFSe.tpXML = txmlRPS then
    AINIRec.WriteString(FpSecao, 'TipoXML', 'RPS')
  else
    AINIRec.WriteString(FpSecao, 'TipoXML', 'NFSE');

  AINIRec.WriteString(FpSecao, 'Numero', NFSe.Numero);
  AINIRec.WriteString(FpSecao, 'StatusNFSe', StatusNFSeToStr(NFSe.SituacaoNfse));

  if NFSe.CodigoVerificacao <> '' then
    AINIRec.WriteString(FpSecao, 'CodigoVerificacao', NFSe.CodigoVerificacao);

  if NFSe.InfNFSe.Id <> '' then
    AINIRec.WriteString(FpSecao, 'ID', NFSe.InfNFse.ID);

  if NFSe.NfseSubstituida <> '' then
    AINIRec.WriteString(FpSecao, 'NfseSubstituida', NFSe.NfseSubstituida);

  if NFSe.NfseSubstituidora <> '' then
    AINIRec.WriteString(FpSecao, 'NfseSubstituidora', NFSe.NfseSubstituidora);

  AINIRec.WriteFloat(FpSecao, 'ValorCredito', NFSe.ValorCredito);
  AINIRec.WriteString(FpSecao, 'Link', NFSe.Link);
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoIdentificacaoRps(const AINIRec: TMemIniFile);
begin
  FpSecao:= 'IdentificacaoRps';
  AINIRec.WriteString(FpSecao, 'Status', FpAOwner.StatusRPSToStr(NFSe.StatusRps));
  AINIRec.WriteString(FpSecao, 'OutrasInformacoes', StringReplace(NFSe.OutrasInformacoes, sLineBreak, FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]));
  AINIRec.WriteString(FpSecao, 'TipoRecolhimento', NFSe.TipoRecolhimento);

  // Provedores ISSDSF e Siat
  AINIRec.WriteString(FpSecao, 'Numero', NFSe.IdentificacaoRps.Numero);
  AINIRec.WriteString(FpSecao, 'Serie', NFSe.IdentificacaoRps.Serie);
  AINIRec.WriteString(FpSecao, 'Tipo', FpAOwner.TipoRPSToStr(NFSe.IdentificacaoRps.Tipo));

  if NFSe.DataEmissao > 0 then
    AINIRec.WriteDateTime(FpSecao, 'DataEmissao', NFSe.DataEmissao)
  else
    AINIRec.WriteDateTime(FpSecao, 'DataEmissao', Now);

  if NFSe.DataEmissaoRps > 0 then
    AINIRec.WriteDateTime(FpSecao, 'DataEmissaoRps', NFSe.DataEmissaoRps);

  if NFSe.Competencia > 0 then
    AINIRec.WriteDate(FpSecao, 'Competencia', NFSe.Competencia)
  else
    AINIRec.WriteDate(FpSecao, 'Competencia', Now);

  AINIRec.WriteString(FpSecao, 'NaturezaOperacao', NaturezaOperacaoToStr(NFSe.NaturezaOperacao));

  AINIRec.WriteString(FpSecao, 'InformacoesComplementares', NFSe.InformacoesComplementares);
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoRpsSubstituido(const AINIRec: TMemIniFile);
begin
  if NFSe.RpsSubstituido.Numero <> '' then
  begin
    FpSecao:= 'RpsSubstituido';
    AINIRec.WriteString(FpSecao, 'Numero', NFSe.RpsSubstituido.Numero);
    AINIRec.WriteString(FpSecao, 'Serie', NFSe.RpsSubstituido.Serie);
    AINIRec.WriteString(FpSecao, 'Tipo', FpAOwner.TipoRPSToStr(NFSe.RpsSubstituido.Tipo));
  end;
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoNFSeSubstituicao(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoNFSeCancelamento(const AINIRec: TMemIniFile);
begin
  if (NFSe.NfseCancelamento.DataHora > 0) or (Trim(NFSe.MotivoCancelamento) <> '')then
  begin
    FpSecao := 'NFSeCancelamento';
    AINIRec.WriteString(FpSecao, 'NumeroNFSe', NFSe.NFSeCancelamento.Pedido.IdentificacaoNfse.Numero);
    AINIRec.WriteString(FpSecao, 'CNPJ', NFSe.NfseCancelamento.Pedido.IdentificacaoNfse.Cnpj);
    AINIRec.WriteString(FpSecao, 'InscricaoMunicipal', NFSe.NFSeCancelamento.Pedido.IdentificacaoNfse.InscricaoMunicipal);
    AINIRec.WriteString(FpSecao, 'CodigoMunicipio', NFSe.NFSeCancelamento.Pedido.IdentificacaoNfse.CodigoMunicipio);
    AINIRec.WriteString(FpSecao, 'CodCancel', NFSe.NfseCancelamento.Pedido.CodigoCancelamento);
    AINIRec.WriteDateTime(FpSecao, 'DataHora', NFSe.NfSeCancelamento.DataHora);
  end;
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoPrestador(const AINIRec: TMemIniFile);
begin
  FpSecao:= 'Prestador';
  AINIRec.WriteString(FpSecao, 'Regime', FpAOwner.RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao));
  AINIRec.WriteString(FpSecao, 'OptanteSN', FpAOwner.SimNaoToStr(NFSe.OptanteSimplesNacional));
  AINIRec.WriteString(FpSecao, 'IncentivadorCultural', FpAOwner.SimNaoToStr(NFSe.IncentivadorCultural));
  AINIRec.WriteString(FpSecao, 'CNPJ', NFSe.Prestador.IdentificacaoPrestador.CpfCnpj);
  AINIRec.WriteString(FpSecao, 'InscricaoMunicipal', NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal);
  AINIRec.WriteString(FpSecao, 'RazaoSocial', NFSe.Prestador.RazaoSocial);
  AINIRec.WriteString(FpSecao, 'NomeFantasia', NFSe.Prestador.NomeFantasia);
  AINIRec.WriteString(FpSecao, 'Logradouro', NFSe.Prestador.Endereco.Endereco);
  AINIRec.WriteString(FpSecao, 'Numero', NFSe.Prestador.Endereco.Numero);
  AINIRec.WriteString(FpSecao, 'Complemento', NFSe.Prestador.Endereco.Complemento);
  AINIRec.WriteString(FpSecao, 'Bairro', NFSe.Prestador.Endereco.Bairro);
  AINIRec.WriteString(FpSecao, 'CodigoMunicipio', NFSe.Prestador.Endereco.CodigoMunicipio);
  AINIRec.WriteString(FpSecao, 'xMunicipio', NFSe.Prestador.Endereco.xMunicipio);
  AINIRec.WriteString(FpSecao, 'UF',  NFSe.Prestador.Endereco.UF);
  AINIRec.WriteInteger(FpSecao, 'CodigoPais', NFSe.Prestador.Endereco.CodigoPais);
  AINIRec.WriteString(FpSecao, 'CEP', NFSe.Prestador.Endereco.CEP);
  AINIRec.WriteString(FpSecao, 'Telefone', NFSe.Prestador.Contato.Telefone);
  AINIRec.WriteString(FpSecao, 'Email', NFSe.Prestador.Contato.Email);
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoTomador(const AINIRec: TMemIniFile);
begin
  FpSecao:= 'Tomador';
  AINIRec.WriteString(FpSecao, 'CNPJCPF', NFSe.Tomador.IdentificacaoTomador.CpfCnpj);
  AINIRec.WriteString(FpSecao, 'InscricaoMunicipal', NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal);
  AINIRec.WriteString(FpSecao, 'InscricaoEstadual', NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual);
  AINIRec.WriteString(FpSecao, 'RazaoSocial', NFSe.Tomador.RazaoSocial);
  AINIRec.WriteString(FpSecao, 'Logradouro', NFSe.Tomador.Endereco.Endereco);
  AINIRec.WriteString(FpSecao, 'Numero', NFSe.Tomador.Endereco.Numero);
  AINIRec.WriteString(FpSecao, 'Complemento', NFSe.Tomador.Endereco.Complemento);
  AINIRec.WriteString(FpSecao, 'Bairro', NFSe.Tomador.Endereco.Bairro);
  AINIRec.WriteString(FpSecao, 'CodigoMunicipio', NFSe.Tomador.Endereco.CodigoMunicipio);
  AINIRec.WriteString(FpSecao, 'xMunicipio', NFSe.Tomador.Endereco.xMunicipio);
  AINIRec.WriteString(FpSecao, 'UF', NFSe.Tomador.Endereco.UF);
  AINIRec.WriteString(FpSecao, 'CEP', NFSe.Tomador.Endereco.CEP);
  AINIRec.WriteInteger(FpSecao, 'CodigoPais', NFSe.Tomador.Endereco.CodigoPais);
  AINIRec.WriteString(FpSecao, 'Telefone', NFSe.Tomador.Contato.Telefone);
  AINIRec.WriteString(FpSecao, 'Email', NFSe.Tomador.Contato.Email);
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoIntermediario(const AINIRec: TMemIniFile);
begin
  if NFSe.Intermediario.Identificacao.CpfCnpj <> '' then
  begin
    FpSecao:= 'Intermediario';
    AINIRec.WriteString(FpSecao, 'CNPJCPF', NFSe.Intermediario.Identificacao.CpfCnpj);
    AINIRec.WriteString(FpSecao, 'InscricaoMunicipal', NFSe.Intermediario.Identificacao.InscricaoMunicipal);
    AINIRec.WriteString(FpSecao, 'RazaoSocial', NFSe.Intermediario.RazaoSocial);
  end;
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoTransportadora(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoConstrucaoCivil(const AINIRec: TMemIniFile);
begin
  if NFSe.ConstrucaoCivil.CodigoObra <> '' then
  begin
    FpSecao:= 'ConstrucaoCivil';
    AINIRec.WriteString(FpSecao, 'CodigoObra', NFSe.ConstrucaoCivil.CodigoObra);
    AINIRec.WriteString(FpSecao, 'Art', NFSe.ConstrucaoCivil.Art);
  end;
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoServico(const AINIRec: TMemIniFile);
begin
  FpSecao:= 'Servico';
  AINIRec.WriteString(FpSecao, 'ItemListaServico', NFSe.Servico.ItemListaServico);
  AINIRec.WriteString(FpSecao, 'xItemListaServico', NFSe.Servico.xItemListaServico);
  AINIRec.WriteString(FpSecao, 'CodigoCnae', NFSe.Servico.CodigoCnae);
  AINIRec.WriteString(FpSecao, 'CodigoTributacaoMunicipio', NFSe.Servico.CodigoTributacaoMunicipio);
  AINIRec.WriteString(FpSecao, 'Discriminacao', ChangeLineBreak(NFSe.Servico.Discriminacao, FpAOwner.ConfigGeral.QuebradeLinha));
  AINIRec.WriteString(FpSecao, 'CodigoMunicipio', NFSe.Servico.CodigoMunicipio);
  AINIRec.WriteInteger(FpSecao, 'MunicipioIncidencia', NFSe.Servico.MunicipioIncidencia);
  AINIRec.WriteString(FpSecao, 'xMunicipioIncidencia',NFSe.Servico.xMunicipioIncidencia);
  AINIRec.WriteString(FpSecao, 'MunicipioPrestacaoServico', NFSe.Servico.MunicipioPrestacaoServico);
  AINIRec.WriteFloat(FpSecao,'ValorTotalRecebido', NFSe.Servico.ValorTotalRecebido);
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoDeducoes(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoQuartos(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoEmail(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoGenericos(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoDespesas(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoItens(const AINIRec: TMemIniFile);
var
  I: Integer;
begin
  //Para quando informar Lista Tabulada ou em JSON na Discrimina��o
  for I := 0 to NFSe.Servico.ItemServico.Count - 1 do
  begin
    FpSecao:= 'Itens' + IntToStrZero(I + 1, 3);
    AINIRec.WriteString(FpSecao, 'Descricao', ChangeLineBreak(NFSe.Servico.ItemServico.Items[I].Descricao, FpAOwner.ConfigGeral.QuebradeLinha));
    AINIRec.WriteString(FpSecao, 'ItemListaServico', NFSe.Servico.ItemServico.Items[I].ItemListaServico);
    AINIRec.WriteString(FpSecao, 'xItemListaServico', NFSe.Servico.ItemServico.Items[I].xItemListaServico);
    AINIRec.WriteFloat(FpSecao, 'Quantidade', NFSe.Servico.ItemServico.Items[I].Quantidade);
    AINIRec.WriteFloat(FpSecao, 'ValorUnitario', NFSe.Servico.ItemServico.Items[I].ValorUnitario);
    AINIRec.WriteFloat(FpSecao, 'ValorIss', NFSe.Servico.ItemServico.Items[I].ValorISS);
    AINIRec.WriteFloat(FpSecao, 'Aliquota', NFSe.Servico.ItemServico.Items[I].Aliquota);
    AINIRec.WriteFloat(FpSecao, 'BaseCalculo', NFSe.Servico.ItemServico.Items[I].BaseCalculo);
    AINIRec.WriteFloat(FpSecao, 'ValorTotal', NFSe.Servico.ItemServico.Items[I].ValorTotal);

    GerarINISecaoDadosDeducao(AINIRec, I);
    GerarINISecaoDadosProssionalParceiro(AINIRec, I);
  end;
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoDadosDeducao(const AINIRec: TMemIniFile; const AIndice: Integer);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoDadosProssionalParceiro(const AINIRec: TMemIniFile; const AIndice: Integer);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoComercioExterior(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoLocacaoSubLocacao(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoEvento(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoRodoviaria(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoInformacoesComplementares(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoValores(const AINIRec: TMemIniFile);
begin
  FpSecao:= 'Valores';
  AINIRec.WriteFloat(FpSecao, 'ValorServicos', NFSe.Servico.Valores.ValorServicos);
  AINIRec.WriteFloat(FpSecao, 'ValorDeducoes', NFSe.Servico.Valores.ValorDeducoes);
  AINIRec.WriteFloat(FpSecao, 'ValorPis', NFSe.Servico.Valores.ValorPis);
  AINIRec.WriteFloat(FpSecao, 'ValorCofins', NFSe.Servico.Valores.ValorCofins);
  AINIRec.WriteFloat(FpSecao, 'ValorInss', NFSe.Servico.Valores.ValorInss);
  AINIRec.WriteFloat(FpSecao, 'ValorIr', NFSe.Servico.Valores.ValorIr);
  AINIRec.WriteFloat(FpSecao, 'ValorCsll', NFSe.Servico.Valores.ValorCsll);
  AINIRec.WriteString(FpSecao, 'ISSRetido', FpAOwner.SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido));
  AINIRec.WriteFloat(FpSecao, 'OutrasRetencoes', NFSe.Servico.Valores.OutrasRetencoes);
  AINIRec.WriteFloat(FpSecao, 'BaseCalculo', NFSe.Servico.Valores.BaseCalculo);
  AINIRec.WriteFloat(FpSecao, 'Aliquota', NFSe.Servico.Valores.Aliquota);
  AINIRec.WriteFloat(FpSecao, 'ValorIss', NFSe.Servico.Valores.ValorIss);
  AINIRec.WriteFloat(FpSecao, 'ValorIssRetido', NFSe.Servico.Valores.ValorIssRetido);
  AINIRec.WriteFloat(FpSecao, 'ValorLiquidoNfse', NFSe.Servico.Valores.ValorLiquidoNfse);
  AINIRec.WriteFloat(FpSecao, 'ValorTotalNotaFiscal', NFSe.Servico.Valores.ValorTotalNotaFiscal);
  AINIRec.WriteFloat(FpSecao, 'ValorTotalTributos', NFSe.Servico.Valores.ValorTotalTributos);
  AINIRec.WriteFloat(FpSecao, 'RetencoesFederais', NFSe.Servico.Valores.RetencoesFederais);
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoValoresNFSe(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoDocumentosDeducoes(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoDocumentosDeducoesFornecedor(const AINIRec: TMemIniFile; const AIndice: Integer);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaotribMun(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaotribFederal(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaototTrib(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoCondicaoPagamento(const AINIRec: TMemIniFile);
begin
  //N�o faz neste leiaute...
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoOrgaoGerador(const AINIRec: TMemIniFile);
begin
  if Trim(NFSe.OrgaoGerador.Uf) <> '' then
  begin
    FpSecao := 'OrgaoGerador';
    AINIRec.WriteString(FpSecao, 'CodigoMunicipio', NFSe.OrgaoGerador.CodigoMunicipio);
    AINIRec.WriteString(FpSecao, 'UF', NFSe.OrgaoGerador.Uf);
  end;
end;

procedure TNFSeW_ABRASFv1.GerarINISecaoParcelas(const AINIRec: TMemIniFile);
begin
  //N�o faz nada neste leiaute...
end;

function TNFSeW_ABRASFv1.GerarIni: string;
var
  LINIRec: TMemIniFile;
  LIniNFSe: TStringList;
begin
  Result := '';
  LINIRec := TMemIniFile.Create('');
  try
    GerarINISecaoIdentificacaoNFSe(LINIRec);
    GerarINISecaoIdentificacaoRps(LINIRec);
    GerarINISecaoRpsSubstituido(LINIRec);
    GerarINISecaoNFSeSubstituicao(LINIRec);
    GerarINISecaoNFSeCancelamento(LINIRec);
    GerarINISecaoPrestador(LINIRec);
    GerarINISecaoTomador(LINIRec);
    GerarINISecaoIntermediario(LINIRec);
    GerarINISecaoTransportadora(LINIRec);
    GerarINISecaoConstrucaoCivil(LINIRec);
    GerarINISecaoServico(LINIRec);
    GerarINISecaoDeducoes(LINIRec);
    GerarINISecaoQuartos(LINIRec);
    GerarINISecaoEmail(LINIRec);
    GerarINISecaoGenericos(LINIRec);
    GerarINISecaoDespesas(LINIRec);
    GerarINISecaoItens(LINIRec);
    GerarINISecaoComercioExterior(LINIRec);
    GerarINISecaoLocacaoSubLocacao(LINIRec);
    GerarINISecaoEvento(LINIRec);
    GerarINISecaoRodoviaria(LINIRec);
    GerarINISecaoInformacoesComplementares(LINIRec);
    GerarINISecaoValores(LINIRec);
    GerarINISecaoValoresNFSe(LINIRec);
    GerarINISecaoDocumentosDeducoes(LINIRec);
    GerarINISecaotribMun(LINIRec);
    GerarINISecaotribFederal(LINIRec);
    GerarINISecaototTrib(LINIRec);
    GerarINISecaoCondicaoPagamento(LINIRec);
    GerarINISecaoOrgaoGerador(LINIRec);
    GerarINISecaoParcelas(LINIRec);
  finally
    LIniNFSe := TStringList.Create;
    try
      LINIRec.GetStrings(LIniNFSe);
      LINIRec.Free;

      Result := StringReplace(LIniNFSe.Text, sLineBreak + sLineBreak, sLineBreak, [rfReplaceAll]);
    finally
      LIniNFSe.Free;
    end;
  end;
end;

end.
