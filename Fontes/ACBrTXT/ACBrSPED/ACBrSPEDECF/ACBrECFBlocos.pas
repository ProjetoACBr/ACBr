{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliomar Marchetti e Isaque Pinheiro            }
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

{******************************************************************************
|* Historico
|* 11/09/2015 - Ariel Guareschi - Identar no padrao utilizado pela ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrECFBlocos;

interface

uses
  SysUtils, Classes, DateUtils, ACBrTXTClass, StrUtils;

const
  /// C�digo da Situa��o Tribut�ria referente ao IPI.
  ipiEntradaRecuperacaoCredito = '00'; // Entrada com recupera��o de cr�dito
  ipiEntradaTributradaZero = '01'; // Entrada tributada com al�quota zero
  ipiEntradaIsenta  = '02'; // Entrada isenta
  ipiEntradaNaoTributada = '03'; // Entrada n�o-tributada
  ipiEntradaImune   = '04'; // Entrada imune
  ipiEntradaComSuspensao = '05'; // Entrada com suspens�o
  ipiOutrasEntradas = '49'; // Outras entradas
  ipiSaidaTributada = '50'; // Sa�da tributada
  ipiSaidaTributadaZero = '51'; // Sa�da tributada com al�quota zero
  ipiSaidaIsenta    = '52'; // Sa�da isenta
  ipiSaidaNaoTributada = '53'; // Sa�da n�o-tributada
  ipiSaidaImune     = '54'; // Sa�da imune
  ipiSaidaComSuspensao = '55'; // Sa�da com suspens�o
  ipiOutrasSaidas   = '99'; // Outras sa�das

  /// C�digo da Situa��o Tribut�ria referente ao PIS.
  pisValorAliquotaNormal = '01';
 // Opera��o Tribut�vel (base de c�lculo = valor da opera��o al�quota normal (cumulativo/n�o cumulativo)).
  pisValorAliquotaDiferenciada = '02';
 // Opera��o Tribut�vel (base de c�lculo = valor da opera��o (al�quota diferenciada)).
  pisQtdeAliquotaUnidade = '03';
 // Opera��o Tribut�vel (base de c�lculo = quantidade vendida x al�quota por unidade de produto).
  pisMonofaticaAliquotaZero = '04';
 // Opera��o Tribut�vel (tributa��o monof�sica (al�quota zero)).
  pisValorAliquotaPorST = '05';
 // Opera��o Tribut�vel por Substitui��o Tribut�ria
  pisAliquotaZero    = '06'; // Opera��o Tribut�vel (al�quota zero).
  pisIsentaContribuicao = '07'; // Opera��o Isenta da Contribui��o.
  pisSemIncidenciaContribuicao = '08';
 // Opera��o Sem Incid�ncia da Contribui��o.
  pisSuspensaoContribuicao = '09';
  // Opera��o com Suspens�o da Contribui��o.
  //in�cio altera��o Raphael - Ts1Desenvolvedor
  pisOutrasOperacoesSaida = '49'; // Outras Opera��es de Sa�da
  pisOperCredExcRecTribMercInt = '50';
 // Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
  pisOperCredExcRecNaoTribMercInt = '51';
 // Opera��o com Direito a Cr�dito � Vinculada Exclusivamente a Receita N�o Tributada no Mercado Interno
  pisOperCredExcRecExportacao = '52';
 // Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita de Exporta��o
  pisOperCredRecTribNaoTribMercInt = '53';
 // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno
  pisOperCredRecTribMercIntEExportacao = '54';
 // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o
  pisOperCredRecNaoTribMercIntEExportacao = '55';
 // Opera��o com Direito a Cr�dito - Vinculada a Receitas N�o-Tributadas no Mercado Interno e de Exporta��o
  pisOperCredRecTribENaoTribMercIntEExportacao = '56';
 // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno, e de Exporta��o
  pisCredPresAquiExcRecTribMercInt = '60';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita Tributada no Mercado Interno
  pisCredPresAquiExcRecNaoTribMercInt = '61';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita N�o-Tributada no Mercado Interno
  pisCredPresAquiExcExcRecExportacao = '62';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita de Exporta��o
  pisCredPresAquiRecTribNaoTribMercInt = '63';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno
  pisCredPresAquiRecTribMercIntEExportacao = '64';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o
  pisCredPresAquiRecNaoTribMercIntEExportacao = '65';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas N�o-Tributadas no Mercado Interno e de Exporta��o
  pisCredPresAquiRecTribENaoTribMercIntEExportacao = '66';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno, e de Exporta��o
  pisOutrasOperacoes_CredPresumido = '67'; // Cr�dito Presumido - Outras Opera��es
  pisOperAquiSemDirCredito = '70';
 // Opera��o de Aquisi��o sem Direito a Cr�dito
  pisOperAquiComIsensao = '71'; // Opera��o de Aquisi��o com Isen��o
  pisOperAquiComSuspensao = '72'; // Opera��o de Aquisi��o com Suspens�o
  pisOperAquiAliquotaZero = '73';
 // Opera��o de Aquisi��o a Al�quota Zero
  pisOperAqui_SemIncidenciaContribuicao = '74';
 // Opera��o de Aquisi��o sem Incid�ncia da Contribui��o
  pisOperAquiPorST   = '75';
  // Opera��o de Aquisi��o por Substitui��o Tribut�ria
  pisOutrasOperacoesEntrada = '98'; // Outras Opera��es de Entrada
  //fim altera��o Raphael - Ts1Desenvolvedor
  pisOutrasOperacoes = '99'; // Outras Opera��es,

  /// C�digo da Situa��o Tribut�ria referente ao COFINS.
  cofinsValorAliquotaNormal = '01';
 // Opera��o Tribut�vel (base de c�lculo = valor da opera��o al�quota normal (cumulativo/n�o cumulativo)).
  cofinsValorAliquotaDiferenciada = '02';
 // Opera��o Tribut�vel (base de c�lculo = valor da opera��o (al�quota diferenciada)).
  cofinsQtdeAliquotaUnidade = '03';
 // Opera��o Tribut�vel (base de c�lculo = quantidade vendida x al�quota por unidade de produto).
  cofinsMonofaticaAliquotaZero = '04';
 // Opera��o Tribut�vel (tributa��o monof�sica (al�quota zero)).
  cofinsValorAliquotaPorST = '05';
 // Opera��o Tribut�vel por Substitui��o Tribut�ria
  cofinsAliquotaZero    = '06';
 // Opera��o Tribut�vel (al�quota zero).
  cofinsIsentaContribuicao = '07'; // Opera��o Isenta da Contribui��o.
  cofinsSemIncidenciaContribuicao = '08';
 // Opera��o Sem Incid�ncia da Contribui��o.
  cofinsSuspensaoContribuicao = '09';
  // Opera��o com Suspens�o da Contribui��o.
  //in�cio altera��o Raphael - Ts1Desenvolvedor
  cofinsOutrasOperacoesSaida = '49'; // Outras Opera��es de Sa�da
  cofinsOperCredExcRecTribMercInt = '50';
 // Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
  cofinsOperCredExcRecNaoTribMercInt = '51';
 // Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita N�o-Tributada no Mercado Interno
  cofinsOperCredExcRecExportacao = '52';
 // Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita de Exporta��o
  cofinsOperCredRecTribNaoTribMercInt = '53';
 // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno
  cofinsOperCredRecTribMercIntEExportacao = '54';
 // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o
  cofinsOperCredRecNaoTribMercIntEExportacao = '55';
 // Opera��o com Direito a Cr�dito - Vinculada a Receitas N�o Tributadas no Mercado Interno e de Exporta��o
  cofinsOperCredRecTribENaoTribMercIntEExportacao = '56';
 // Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno e de Exporta��o
  cofinsCredPresAquiExcRecTribMercInt = '60';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita Tributada no Mercado Interno
  cofinsCredPresAquiExcRecNaoTribMercInt = '61';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita N�o-Tributada no Mercado Interno
  cofinsCredPresAquiExcExcRecExportacao = '62';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita de Exporta��o
  cofinsCredPresAquiRecTribNaoTribMercInt = '63';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno
  cofinsCredPresAquiRecTribMercIntEExportacao = '64';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o
  cofinsCredPresAquiRecNaoTribMercIntEExportacao = '65';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas N�o-Tributadas no Mercado Interno e de Exporta��o
  cofinsCredPresAquiRecTribENaoTribMercIntEExportacao = '66';
 // Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno e de Exporta��o
  cofinsOutrasOperacoes_CredPresumido = '67';
 // Cr�dito Presumido - Outras Opera��es
  cofinsOperAquiSemDirCredito = '70';
 // Opera��o de Aquisi��o sem Direito a Cr�dito
  cofinsOperAquiComIsensao = '71'; // Opera��o de Aquisi��o com Isen��o
  cofinsOperAquiComSuspensao = '72';
 // Opera��o de Aquisi��o com Suspens�o
  cofinsOperAquiAliquotaZero = '73';
 // Opera��o de Aquisi��o a Al�quota Zero
  cofinsOperAqui_SemIncidenciaContribuicao = '74';
 // Opera��o de Aquisi��o sem Incid�ncia da Contribui��o
  cofinsOperAquiPorST   = '75';
  // Opera��o de Aquisi��o por Substitui��o Tribut�ria
  cofinsOutrasOperacoesEntrada = '98'; // Outras Opera��es de Entrada
  //fim altera��o Raphael - Ts1Desenvolvedor
  cofinsOutrasOperacoes = '99'; // Outras Opera��es,

type
  /// Indicador de Dados - TOpenBlocos
  TACBrIndDad = (idComDados, // 0- Bloco com dados informados;
    idSemDados  // 1- Bloco sem dados informados.
    );
  TACBrIndicadorDados = TACBrIndDad;

  /// Vers�o do Leiaute do arquivo - TRegistro0000
  TACBrECFCodVer = (ECFVersao100, ECFVersao200, ECFVersao300, ECFVersao400, ECFVersao500, ECFVersao600, ECFVersao700, ECFVersao800, ECFVersao900, ECFVersao1000, ECFVersao1100);
//  TACBrECFVersaoLeiaute = TACBrECFCodVer;

  /// C�digo da finalidade do arquivo - TRegistro0000
  TACBrCodFin = (raOriginal,     // 0 - Remessa do arquivo original
    raSubstituto    // 1 - Remessa do arquivo substituto
    );
  TACBrCodFinalidade = TACBrCodFin;

  /// Tipo do item � Atividades Industriais, Comerciais e Servi�os:
  TACBrTipoItem     = (tiMercadoriaRevenda,    // 00 � Mercadoria para Revenda
    tiMateriaPrima,         // 01 � Mat�ria-Prima;
    tiEmbalagem,            // 02 � Embalagem;
    tiProdutoProcesso,      // 03 � Produto em Processo;
    tiProdutoAcabado,       // 04 � Produto Acabado;
    tiSubproduto,           // 05 � Subproduto;
    tiProdutoIntermediario, // 06 � Produto Intermedi�rio;
    tiMaterialConsumo,      // 07 � Material de Uso e Consumo;
    tiAtivoImobilizado,     // 08 � Ativo Imobilizado;
    tiServicos,             // 09 � Servi�os;
    tiOutrosInsumos,        // 10 � Outros Insumos;
    tiOutras                // 99 � Outras
    );
  /// Indicador do tipo de opera��o:
  TACBrIndOper      = (tpEntradaAquisicao, // 0 - Entrada
    tpSaidaPrestacao    // 1 - Sa�da
    );
  TACBrTipoOperacao = TACBrIndOper;

  /// Indicador do emitente do documento fiscal
  TACBrIndEmit  = (edEmissaoPropria,         // 0 - Emiss�o pr�pria
    edTerceiros               // 1 - Terceiro
    );
  TACBrEmitente = TACBrIndEmit;

  /// Indicador do tipo de pagamento
  TACBrIndPgto = (tpVista,             // 0 - � Vista
    tpPrazo,             // 1 - A Prazo
    tpOutros,            // 2 - Outros
    tpSemPagamento,      // 9 - Sem pagamento
    tpNenhum             // Preencher vazio
    );
  TACBrTipoPagamento = TACBrIndPgto;

  /// Indicador do tipo do frete
  TACBrIndFrt    = (tfPorContaEmitente,      // 0 - Por conta do emitente
    tfPorContaDestinatario,  // 1 - Por conta do destinat�rio
    tfPorContaTerceiros,     // 2 - Por conta de terceiros
    tfSemCobrancaFrete,      // 9 - Sem cobran�a de frete
    tfNenhum                 // Preencher vazio
    );
  TACBrTipoFrete = TACBrIndFrt;

  /// Indicador do tipo do frete da opera��o de redespacho
  TACBrTipoFreteRedespacho = (frSemRedespacho,         // 0 � Sem redespacho
    frPorContaEmitente,      // 1 - Por conta do emitente
    frPorContaDestinatario,  // 2 - Por conta do destinat�rio
    frOutros,                // 9 � Outros
    frNenhum                 // Preencher vazio
    );
  /// Indicador da origem do processo
  TACBrOrigemProcesso = (opSefaz,            // 0 - Sefaz
    opJusticaFederal,   // 1 - Justi�a Federal
    opJusticaEstadual,  // 2 - Justi�a Estadual
    opSecexRFB,         // 3 - Secex/RFB
    opOutros,           // 9 - Outros
    opNenhum           // Preencher vazio
    );
  /// Indicador do tipo de opera��o
  TACBrIndOperST      = (toCombustiveisLubrificantes, // 0 - Combust�veis e Lubrificantes
    toLeasingVeiculos            // 1 - leasing de ve�culos ou faturamento direto
    );
  TACBrTipoOperacaoST = TACBrIndOperST;

  TACBrDoctoArrecada  = (daEstadualArrecadacao,  // 0 - Documento Estadual de Arrecada��o
    daGNRE                  // 1 - GNRE
    );
  /// Indicador do tipo de transporte
  TACBrTipoTransporte = (ttRodoviario,         // 0 � Rodovi�rio
    ttFerroviario,        // 1 � Ferrovi�rio
    ttRodoFerroviario,    // 2 � Rodo-Ferrovi�rio
    ttAquaviario,         // 3 � Aquavi�rio
    ttDutoviario,         // 4 � Dutovi�rio
    ttAereo,              // 5 � A�reo
    ttOutros              // 9 � Outros
    );
  /// Documento de importa��o
  TACBrDoctoImporta   = (diImportacao,           // 0 � Declara��o de Importa��o
    diSimplificadaImport    // 1 � Declara��o Simplificada de Importa��o
    );
  /// Indicador do tipo de t�tulo de cr�dito
  TACBrTipoTitulo     = (tcDuplicata,             // 00- Duplicata
    tcCheque,                // 01- Cheque
    tcPromissoria,           // 02- Promiss�ria
    tcRecibo,                // 03- Recibo
    tcOutros                 // 99- Outros (descrever)
    );

  /// Movimenta��o f�sica do ITEM/PRODUTO:
  TACBrIndMovFisica = (mfSim,           // 0 - Sim
    mfNao            // 1 - N�o
    );
  TACBrMovimentacaoFisica = TACBrIndMovFisica;

  /// Indicador de per�odo de apura��o do IPI
  TACBrApuracaoIPI  = (iaMensal,               // 0 - Mensal
    iaDecendial,             // 1 - Decendial
    iaNenhum                // Vazio
    );
  /// Indicador de tipo de refer�ncia da base de c�lculo do ICMS (ST) do produto farmac�utico
  TACBrTipoBaseMedicamento = (bmCalcTabeladoSugerido,
  // 0 - Base de c�lculo referente ao pre�o tabelado ou pre�o m�ximo sugerido;
    bmCalMargemAgregado,
// 1 - Base c�lculo � Margem de valor agregado;
    bmCalListNegativa,
// 2 - Base de c�lculo referente � Lista Negativa;
    bmCalListaPositiva,
// 3 - Base de c�lculo referente � Lista Positiva;
    bmCalListNeutra                                   // 4 - Base de c�lculo referente � Lista Neutra
    );
  /// Tipo Produto
  TACBrTipoProduto  = (tpSimilar,   // 0 - Similar
    tpGenerico,  // 1 - Gen�rico
    tpMarca      // 2 - �tico ou de Marca
    );
  /// Indicador do tipo da arma de fogo
  TACBrTipoArmaFogo = (tafPermitido,     // 0 - Permitido
    tafRestrito       // 1 - Restrito
    );
  /// Indicador do tipo de opera��o com ve�culo
  TACBrIndVeicOper  = (tovVendaPConcess,   // 0 - Venda para concession�ria
    tovFaturaDireta,    // 1 - Faturamento direto
    tovVendaDireta,     // 2 - Venda direta
    tovVendaDConcess,   // 3 - Venda da concession�ria
    tovVendaOutros      // 9 - Outros
    );
  TACBrTipoOperacaoVeiculo = TACBrIndVeicOper;

  /// Indicador do tipo de receita
  TACBrIndRec      = (trPropria,   // 0 - Receita pr�pria
    trTerceiro   // 1 - Receita de terceiros
    );
  TACBrTipoReceita = TACBrIndRec;

  /// Indicador do tipo do ve�culo transportador
  TACBrTipoVeiculo = (tvEmbarcacao,
    tvEmpuradorRebocador
    );
  /// Indicador do tipo da navega��o
  TACBrTipoNavegacao = (tnInterior,
    tnCabotagem
    );
  /// Situa��o do Documento
  TACBrCodSit = (sdRegular,    // 00 - Documento regular
    sdExtempRegular,           // 01 - Escritura��o extempor�nea de documento regular
    sdCancelado,               // 02 - Documento cancelado
    sdCanceladoExtemp,         // 03 - Escritura��o extempor�nea de documento cancelado
    sdDoctoDenegado,           // 04 - NF-e ou CT-e - denegado
    sdDoctoNumInutilizada,     // 05 - NF-e ou CT-e - Numera��o inutilizada
    sdFiscalCompl,             // 06 - Documento Fiscal Complementar
    sdExtempCompl,             // 07 - Escritura��o extempor�nea de documento complementar
    sdRegimeEspecNEsp          // 08 - Documento Fiscal emitido com base em Regime Especial ou Norma Espec�fica
    );
  TACBrSituacaoDocto = TACBrCodSit;

  /// Indicador do tipo de tarifa aplicada:
  TACBrTipoTarifa     = (tipExp,     // 0 - Exp
    tipEnc,     // 1 - Enc
    tipCI,      // 2 - CI
    tipOutra    // 9 - Outra
    );
  /// Indicador da natureza do frete
  TACBrNaturezaFrete  = (nfNegociavel,      // 0 - Negociavel
    nfNaoNegociavel    // 1 - N�o Negociavel
    );
  /// Indicador do tipo de receita
  TACBrIndReceita     = (recServicoPrestado,          // 0 - Receita pr�pria - servi�os prestados;
    recCobrancaDebitos,          // 1 - Receita pr�pria - cobran�a de d�bitos;
    recVendaMerc,                // 2 - Receita pr�pria - venda de mercadorias;
    recServicoPrePago,
           // 3 - Receita pr�pria - venda de servi�o pr�-pago;
    recOutrasProprias,           // 4 - Outras receitas pr�prias;
    recTerceiroCoFaturamento,    // 5 - Receitas de terceiros (co-faturamento);
    recTerceiroOutras            // 9 - Outras receitas de terceiros
    );
  TACBrIndTipoReceita = TACBrIndReceita;

  /// Indicador do tipo de servi�o prestado
  TACBrServicoPrestado = (spTelefonia,                // 0- Telefonia;
    spComunicacaoDados,         // 1- Comunica��o de dados;
    spTVAssinatura,             // 2- TV por assinatura;
    spAcessoInternet,           // 3- Provimento de acesso � Internet;
    spMultimidia,               // 4- Multim�dia;
    spOutros                    // 9- Outros
    );
  /// Indicador de movimento
  TACBrMovimentoST = (mstSemOperacaoST,   // 0 - Sem opera��es com ST
    mstComOperacaoST    // 1 - Com opera��es de ST
    );
  /// Indicador do tipo de ajuste
  TACBrTipoAjuste  = (ajDebito,            // 0 - Ajuste a d�bito;
    ajCredito            // 1- Ajuste a cr�dito
    );
  /// Indicador da origem do documento vinculado ao ajuste
  TACBrOrigemDocto = (odPorcessoJudicial, // 0 - Processo Judicial;
    odProcessoAdminist, // 1 - Processo Administrativo;
    odPerDcomp,         // 2 - PER/DCOMP;
    odOutros            //9 � Outros.
    );
  /// Indicador de propriedade/posse do item
  TACBrIndProp     = (piInformante,
           // 0- Item de propriedade do informante e em seu poder;
    piInformanteNoTerceiro,
 // 1- Item de propriedade do informante em posse de terceiros;
    piTerceiroNoInformante  // 2- Item de propriedade de terceiros em posse do informante
    );
  TACBrPosseItem   = TACBrIndProp;
  /// Informe o tipo de documento
  TACBrTipoDocto = (docDeclaracaoExportacao,           // 0 - Declara��o de Exporta��o;
    docDeclaracaoSimplesExportacao,    // 1 - Declara��o Simplificada de Exporta��o;
    docDeclaracaoUnicaExportacao       // 2 - Declara��o �nica de Exporta��o.
    );
  /// Preencher com
  TACBrExportacao  = (exDireta,             // 0 - Exporta��o Direta
    exIndireta            // 1 - Exporta��o Indireta
    );
  /// Indicador Tipo de Estoque K200
  TACBrIndEstoque  = (estPropInformantePoder,
 // 0 = Estoque de propriedade do informante e em seu poder
    estPropInformanteTerceiros,
// 1 = Estoque de propriedade do informante e em posse de terceiros;
    estPropTerceirosInformante
 // 2 = Estoque de propriedade de terceiros e em posse do informante
    );
  /// Informa��o do tipo de conhecimento de embarque
  TACBrConhecEmbarque = (ceAWB,            //01 � AWB;
    ceMAWB,           //02 � MAWB;
    ceHAWB,           //03 � HAWB;
    ceCOMAT,          //04 � COMAT;
    ceRExpressas,     //06 � R. EXPRESSAS;
    ceEtiqREspressas, //07 � ETIQ. REXPRESSAS;
    ceHrExpressas,    //08 � HR. EXPRESSAS;
    ceAV7,            //09 � AV7;
    ceBL,             //10 � BL;
    ceMBL,            //11 � MBL;
    ceHBL,            //12 � HBL;
    ceCTR,            //13 � CRT;
    ceDSIC,           //14 � DSIC;
    ceComatBL,        //16 � COMAT BL;
    ceRWB,            //17 � RWB;
    ceHRWB,           //18 � HRWB;
    ceTifDta,         //19 � TIF/DTA;
    ceCP2,            //20 � CP2;
    ceNaoIATA,        //91 � N�O IATA;
    ceMNaoIATA,       //92 � MNAO IATA;
    ceHNaoIATA,       //93 � HNAO IATA;
    ceCOutros         //99 � OUTROS.
    );
  /// Identificador de medi��o
  TACBrMedicao     = (medAnalogico,            // 0 - anal�gico;
    medDigital               // 1 � digital
    );
  /// Tipo de movimenta��o do bem ou componente
  TACBrMovimentoBens = (mbcSI,             // SI = Saldo inicial de bens imobilizados
    mbcIM,             // IM = Imobiliza��o de bem individual
    mbcIA,             // IA = Imobiliza��o em Andamento - Componente
    mbcCI,
// CI = Conclus�o de Imobiliza��o em Andamento � Bem Resultante
    mbcMC,             // MC = Imobiliza��o oriunda do Ativo Circulante
    mbcBA,
// BA = Baixa do Saldo de ICMS - Fim do per�odo de apropria��o
    mbcAT,             // AT = Aliena��o ou Transfer�ncia
    mbcPE,             // PE = Perecimento, Extravio ou Deteriora��o
    mbcOT              // OT = Outras Sa�das do Imobilizado
    );
  /// C�digo de grupo de tens�o
  TACBrGrupoTensao = (gtNenhum,      // '' - Vazio. Para uso quando o documento for cancelado.
    gtA1,          // 01 - A1 - Alta Tens�o (230kV ou mais)
    gtA2,          // 02 - A2 - Alta Tens�o (88 a 138kV)
    gtA3,          // 03 - A3 - Alta Tens�o (69kV)
    gtA3a,         // 04 - A3a - Alta Tens�o (30kV a 44kV)
    gtA4,          // 05 - A4 - Alta Tens�o (2,3kV a 25kV)
    gtAS,          // 06 - AS - Alta Tens�o Subterr�neo 06
    gtB107,        // 07 - B1 - Residencial 07
    gtB108,        // 08 - B1 - Residencial Baixa Renda 08
    gtB209,        // 09 - B2 - Rural 09
    gtB2Rural,     // 10 - B2 - Cooperativa de Eletrifica��o Rural
    gtB2Irrigacao, // 11 - B2 - Servi�o P�blico de Irriga��o
    gtB3,          // 12 - B3 - Demais Classes
    gtB4a,         // 13 - B4a - Ilumina��o P�blica - rede de distribui��o
    gtB4b          // 14 - B4b - Ilumina��o P�blica - bulbo de l�mpada
    );
  /// C�digo de classe de consumo de energia el�trica ou g�s
  TACBrClasseConsumo = (ccComercial,         // 01 - Comercial
    ccConsumoProprio,    // 02 - Consumo Pr�prio
    ccIluminacaoPublica, // 03 - Ilumina��o P�blica
    ccIndustrial,        // 04 - Industrial
    ccPoderPublico,      // 05 - Poder P�blico
    ccResidencial,       // 06 - Residencial
    ccRural,             // 07 - Rural
    ccServicoPublico     // 08 -Servi�o P�blico
    );
  /// C�digo de tipo de Liga��o
  TACBrTpLigacao   = (tlNenhum,              // '' - Para uso quando o documento for cancelado
    tlMonofasico,          // 1 - Monof�sico
    tlBifasico,            // 2 - Bif�sico
    tlTrifasico            // 3 - Trif�sico
    );
  TACBrTipoLigacao = TACBrTpLigacao;

  /// C�digo dispositivo autorizado
  TACBrDispositivo   = (cdaFormSeguranca,  // 00 - Formul�rio de Seguran�a
    cdaFSDA,
// 01 - FS-DA � Formul�rio de Seguran�a para Impress�o de DANFE
    cdaNFe,            // 02 � Formul�rio de seguran�a - NF-e
    cdaFormContinuo,   // 03 - Formul�rio Cont�nuo
    cdaBlocos,         // 04 � Blocos
    cdaJogosSoltos     // 05 - Jogos Soltos
    );
  /// C�digo do Tipo de Assinante
  TACBrTpAssinante   = (assComercialIndustrial,    // 1 - Comercial/Industrial
    assPodrPublico,            // 2 - Poder P�blico
    assResidencial,            // 3 - Residencial/Pessoa f�sica
    assPublico,                // 4 - P�blico
    assSemiPublico,            // 5 - Semi-P�blico
    assOutros,                 // 6 - Outros
    assNenhum                  // Preencher vazio
    );
  TACBrTipoAssinante = TACBrTpAssinante;

  /// Motivo do Invent�rio
  TACBrMotInv = (miFinalPeriodo,
    miMudancaTributacao,
    miBaixaCadastral,
    miRegimePagamento,
    miDeterminacaoFiscos
    );
  TACBrMotivoInventario = TACBrMotInv;

  ///C�digo da Situa��o Tribut�ria referente ao ICMS.
  TACBrCstIcms = (
    sticmsTributadaIntegralmente,
 // '000' //	Tributada integralmente
    sticmsTributadaComCobracaPorST,
 // '010' //	Tributada e com cobran�a do ICMS por substitui��o tribut�ria
    sticmsComReducao,
 // '020' //	Com redu��o de base de c�lculo
    sticmsIsentaComCobracaPorST,
 // '030' //	Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
    sticmsIsenta, // '040' //	Isenta
    sticmsNaoTributada,
 // '041' //	N�o tributada
    sticmsSuspensao,
 // '050' //	Suspens�o
    sticmsDiferimento,
 // '051' //	Diferimento
    sticmsCobradoAnteriormentePorST,
 // '060' //	ICMS cobrado anteriormente por substitui��o tribut�ria
    sticmsComReducaoPorST,
 // '070' //	Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
    sticmsOutros, // '090' //	Outros
    sticmsEstrangeiraImportacaoDiretaTributadaIntegralmente,
 // '100' // Estrangeira - Importa��o direta - Tributada integralmente
    sticmsEstrangeiraImportacaoDiretaTributadaComCobracaPorST,
 // '110' // Estrangeira - Importa��o direta - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
    sticmsEstrangeiraImportacaoDiretaComReducao,
 // '120' // Estrangeira - Importa��o direta - Com redu��o de base de c�lculo
    sticmsEstrangeiraImportacaoDiretaIsentaComCobracaPorST,
 // '130' // Estrangeira - Importa��o direta - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
    sticmsEstrangeiraImportacaoDiretaIsenta,
 // '140' // Estrangeira - Importa��o direta - Isenta
    sticmsEstrangeiraImportacaoDiretaNaoTributada,
 // '141' // Estrangeira - Importa��o direta - N�o tributada
    sticmsEstrangeiraImportacaoDiretaSuspensao,
 // '150' // Estrangeira - Importa��o direta - Suspens�o
    sticmsEstrangeiraImportacaoDiretaDiferimento,
 // '151' // Estrangeira - Importa��o direta - Diferimento
    sticmsEstrangeiraImportacaoDiretaCobradoAnteriormentePorST,
 // '160' // Estrangeira - Importa��o direta - ICMS cobrado anteriormente por substitui��o tribut�ria
    sticmsEstrangeiraImportacaoDiretaComReducaoPorST,
 // '170' // Estrangeira - Importa��o direta - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
    sticmsEstrangeiraImportacaoDiretaOutros,
 // '190' // Estrangeira - Importa��o direta - Outras
    sticmsEstrangeiraAdqMercIntTributadaIntegralmente,
 // '200' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
    sticmsEstrangeiraAdqMercIntTributadaComCobracaPorST,
 // '210' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
    sticmsEstrangeiraAdqMercIntComReducao,
 // '220' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
    sticmsEstrangeiraAdqMercIntIsentaComCobracaPorST,
 // '230' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
    sticmsEstrangeiraAdqMercIntIsenta,
 // '240' // Estrangeira - Adquirida no mercado interno - Isenta
    sticmsEstrangeiraAdqMercIntNaoTributada,
 // '241' // Estrangeira - Adquirida no mercado interno - N�o tributada
    sticmsEstrangeiraAdqMercIntSuspensao,
 // '250' // Estrangeira - Adquirida no mercado interno - Suspens�o
    sticmsEstrangeiraAdqMercIntDiferimento,
 // '251' // Estrangeira - Adquirida no mercado interno - Diferimento
    sticmsEstrangeiraAdqMercIntCobradoAnteriormentePorST,
 // '260' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
    sticmsEstrangeiraAdqMercIntComReducaoPorST,
 // '270' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
    sticmsEstrangeiraAdqMercIntOutros,
 // '290' // Estrangeira - Adquirida no mercado interno - Outras
    csticms300,
 // '300' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
    csticms310,
 // '310' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms320,
 // '320' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
    csticms330,
 // '330' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms340, // '340' // Estrangeira - Adquirida no mercado interno - Isenta
    csticms341,
 // '341' // Estrangeira - Adquirida no mercado interno - N�o tributada
    csticms350, // '350' // Estrangeira - Adquirida no mercado interno - Suspens�o
    csticms351, // '351' // Estrangeira - Adquirida no mercado interno - Diferimento
    csticms360,
 // '360' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
    csticms370,
 // '370' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
    csticms390, // '390' // Estrangeira - Adquirida no mercado interno - Outras
    csticms400,
 // '400' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
    csticms410,
 // '410' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms420,
 // '420' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
    csticms430,
 // '430' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms440, // '440' // Estrangeira - Adquirida no mercado interno - Isenta
    csticms441,
 // '441' // Estrangeira - Adquirida no mercado interno - N�o tributada
    csticms450, // '450' // Estrangeira - Adquirida no mercado interno - Suspens�o
    csticms451, // '451' // Estrangeira - Adquirida no mercado interno - Diferimento
    csticms460,
 // '460' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
    csticms470,
 // '470' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
    csticms490, // '490' // Estrangeira - Adquirida no mercado interno - Outras
    csticms500,
 // '500' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
    csticms510,
 // '510' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms520,
 // '520' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
    csticms530,
 // '530' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms540, // '540' // Estrangeira - Adquirida no mercado interno - Isenta
    csticms541,
 // '541' // Estrangeira - Adquirida no mercado interno - N�o tributada
    csticms550, // '550' // Estrangeira - Adquirida no mercado interno - Suspens�o
    csticms551, // '551' // Estrangeira - Adquirida no mercado interno - Diferimento
    csticms560,
 // '560' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
    csticms570,
 // '570' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
    csticms590, // '590' // Estrangeira - Adquirida no mercado interno - Outras
    csticms600,
 // '600' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
    csticms610,
 // '610' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms620,
 // '620' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
    csticms630,
 // '630' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms640, // '640' // Estrangeira - Adquirida no mercado interno - Isenta
    csticms641,
 // '641' // Estrangeira - Adquirida no mercado interno - N�o tributada
    csticms650, // '650' // Estrangeira - Adquirida no mercado interno - Suspens�o
    csticms651, // '651' // Estrangeira - Adquirida no mercado interno - Diferimento
    csticms660,
 // '660' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
    csticms670,
 // '670' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
    csticms690, // '690' // Estrangeira - Adquirida no mercado interno - Outras
    csticms700,
 // '700' // Estrangeira - Adquirida no mercado interno - Tributada integralmente
    csticms710,
 // '710' // Estrangeira - Adquirida no mercado interno - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms720,
 // '720' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo
    csticms730,
 // '730' // Estrangeira - Adquirida no mercado interno - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms740, // '740' // Estrangeira - Adquirida no mercado interno - Isenta
    csticms741,
 // '741' // Estrangeira - Adquirida no mercado interno - N�o tributada
    csticms750, // '750' // Estrangeira - Adquirida no mercado interno - Suspens�o
    csticms751, // '751' // Estrangeira - Adquirida no mercado interno - Diferimento
    csticms760,
 // '760' // Estrangeira - Adquirida no mercado interno - ICMS cobrado anteriormente por substitui��o tribut�ria
    csticms770,
 // '770' // Estrangeira - Adquirida no mercado interno - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
    csticms790, // '790' // Estrangeira - Adquirida no mercado interno - Outras
    csticms800,
 // '800' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Tributada integralmente
    csticms810,
 // '810' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms820,
 // '820' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Com redu��o de base de c�lculo
    csticms830,
 // '830' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
    csticms840,
 // '840' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Isenta
    csticms841,
 // '841' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - N�o tributada
    csticms850,
 // '850' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Suspens�o
    csticms851,
 // '851' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Diferimento
    csticms860,
 // '860' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - ICMS cobrado anteriormente por substitui��o tribut�ria
    csticms870,
 // '870' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
    csticms890,
 // '890' // Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70% (setenta por cento) - Outras

    sticmsSimplesNacionalTributadaComPermissaoCredito,
 // '101' // Simples Nacional - Tributada pelo Simples Nacional com permiss�o de cr�dito
    sticmsSimplesNacionalTributadaSemPermissaoCredito,
 // '102' // Simples Nacional - Tributada pelo Simples Nacional sem permiss�o de cr�dito
    sticmsSimplesNacionalIsencaoPorFaixaReceitaBruta,
 // '103' // Simples Nacional - Isen��o do ICMS no Simples Nacional para faixa de receita bruta
    sticmsSimplesNacionalTributadaComPermissaoCreditoComST,
 // '201' // Simples Nacional - Tributada pelo Simples Nacional com permiss�o de cr�dito e com cobran�a do ICMS por substitui��o tribut�ria
    sticmsSimplesNacionalTributadaSemPermissaoCreditoComST,
 // '202' // Simples Nacional - Tributada pelo Simples Nacional sem permiss�o de cr�dito e com cobran�a do ICMS por substitui��o tribut�ria
    sticmsSimplesNacionalIsencaoPorFaixaReceitaBrutaComST,
 // '203' // Simples Nacional - Isen��o do ICMS no Simples Nacional para faixa de receita bruta e com cobran�a do ICMS por substitui��o tribut�ria
    sticmsSimplesNacionalImune,
 // '300' // Simples Nacional - Imune
    sticmsSimplesNacionalNaoTributada,
 // '400' // Simples Nacional - N�o tributada pelo Simples Nacional
    sticmsSimplesNacionalCobradoAnteriormentePorST,
 // '500' // Simples Nacional - ICMS cobrado anteriormente por substitui��o tribut�ria (substitu�do) ou por antecipa��o
    sticmsSimplesNacionalOutros
                                 // '900' // Simples Nacional - Outros
    );
  TACBrSituacaoTribICMS = TACBrCstIcms;

  TACBrQualificacaoAssinante = (
    qaDiretor,
    qaConselheirodeAdministracao,
    qaAdministrador,
    qaAdministradordoGrupo,
    qaAdministradordeSociedadeFiliada,
    qaAdministradorJudicialPF,
    qaAdministradorJudicialPJ,
    qaAdministradorJudicialGestor,
    qaGestoJudicial,
    qaProcurador,
    qaInventariante,
    qaLiquidante,
    qaInterventor,
    qaTitualarPF,
    qaEmpresario,
    qaContador,
    qaContabilista,
    qaOutros);

  TACBrIndicador = (
    idSim,
    idNao);

  TACBrFormaTributacaoLucro = (
    ftlLucroReal,
    ftlLucroRealArbitrado,
    ftlLucroPresumidoReal,
    ftlLucroPresumidoRealArbitrado,
    ftlLucroPresumido,
    ftlLucroArbitrado,
    ftlLucroPresumidoArbitrado,
    ftlImuneIRPJ,
    ftlIsentoIRPJ);

  // Crit�rio de reconhecimento de receitas para empresas tributadas pelo Lucro Presumido
  TACBrIndRecReceita = (irrRegimeCaixa, irrRegimeCompetencia, irrNenhum);

  // Qualifica��o do representante legal;
  TACBrQualificacaoRepLegal = (qrlProcurador,
                               qrlCurador,
                               qrlMae,
                               qrlPai,
                               qrlTutor,
                               qrlOutro,
                               qrlNenhum);

  /// Tipo de ajustes do pre�o par�metro que foram realizados (x305)
  TACBrAjustePrecoParametro305 = (
    appPremio ,               //  1 - Pr�mio (art. 34, �7�)
    appPrazo,                 //  2 - Prazo para pagamento (art. 34, �10, I)
    appQuantidades,           //  3 - Quantidades negociadas (art. 34, �10, II)
    appInfluencia,            //  4 - Influ�ncias clim�ticas nas caracter�sticas do bem exportado (art. 34, �10, III)
    appCustoInter,            //  5 - Custos de intermedia��o - Custos de intermedia��o, nas opera��es de compra e venda praticadas pelas....
    appAcondicionamento,      //  6 - Acondicionamento (art. 34, �10, V)
    appFreteSeguroArt34,      //  7 - Frete e seguro (art. 34, �10, VI)
    appCustoDesembarqueArt34, //  8 - Custos de desembarque no porto, de transporte interno, de armazenagem e de desembara�o...
    appPrazoPagto,            //  9 - Prazo para pagamento (art. 22, �1�, I)
    appQtdeNegociada,         //  10 - Quantidades negociadas (art. 22, �1�, II)
    appGarantia,              //  11 - Garantia de funcionamento do bem ou da aplicabilidade do servi�o ou direito (art. 22, �1�, III)
    appPromocao,              //  12 - Promo��o do bem, servi�o ou direito (art. 22, �1�, IV)
    appCustosFiscalizacao,    //  13 - Custos de fiscaliza��o de qualidade, de padr�o dos servi�os e das condi��es de higiene (art. 22, �1�, V)
    appCustoIntermediacao,    //  14 - Custos de intermedia��o (art. 22, �1�, VI)
    appAcondicionamentoArt22, //  15 - Acondicionamento (art. 22, �1�, VII)
    appFreteSeguroArt22,      //  16 - Frete e seguro (art. 22, �1�, VIII)
    appRiscoCredito,          //  17 - Riscos de cr�dito (art. 22, �1�, IX)
    appCustoDesembarqueArt22,      //  18 - Custos de desembarque no porto, de transporte interno, de armazenagem e de desembara�o....
    appSimilaridade,          //  19 - Similaridade (art. 24)
    appVariacao,              //  20 - Varia��o cambial (art. 25)
    appOutros                 //  99 - Outros ajustes - essa op��o deve ser utilizada apenas em caso de altera��o da Instru��o Normativa RFB n� 1.312/2012
                              //      com previs�o de ajustes n�o contemplados nos c�digos anteriores
      );

    /// Fonte da Cota��o: Descri��o da fonte utilizada para a busca do pre�o par�metro informado (x320)

  TACBrFonteCotacao = (
   fcChicagoBoard,          // 101 ChicagoBoard of Trade (CBOT) - Chicago - EUA;
   fcChicagoMercantile,     // 102 Chicago Mercantile Exchange (CME) - Chicago - EUA;
   fcNewYorkMercantile,     // 103 New York Mercantile Exchange (NYMEX) - Nova York - EUA;
   fcCommodity,             // 104 Commodity Exchange (COMEX) - Nova York - EUA;
   fcIntercontinentalExchange, // 105 Intercontinental Exchange (ICE US) - Atlanta - EUA;
   fcBolsaMercadoria,       // 106 Bolsa de Mercadorias & Futuros (BM&F) - S�o Paulo - Brasil;
   fcLifeNyse,              // 107 Life NYSE Euronext (LIFFE) - Londres - Reino Unido;
   fcLondonMetal,           // 108 London Metal Exchange (LME) - Londres - Reino Unido;
   fcIntercontinental,      // 109 Intercontinental Exchange (ICE Europe) - Londres - Reino Unido;
   fcTokioCommodity,        // 110 Tokio Commodity Exchange (TOCOM) - T�quio - Jap�o;
   fcTokioGrain,            // 111 Tokio Grain Exchange (TGE) - T�quio - Jap�o;
   fcSingapore,             // 112 Singapore Commodity Exchange (SICOM) - Cidade de Cingapura - Cingapura;
   fcHongKongm,             // 113 Hong Kong Commodity Exchange (HKE) - Hong Kong � China;
   fcMultiCommodity,        // 114 Multi Commodity Exchange (MCX) - Bombain - �ndia;
   fcNational,              // 115 National Commodity & Derivatives Exchange Limited (NCDEX) - Bombain - �ndia;
   fcAgricultural,          // 116 Agricultural Futures Exchange of Thailand (AFET) - Bangkok - Tail�ndia;
   fcAustralian,            // 117 Australian Securities Exchange (ASX) - Sidney - Austr�lia;
   fcJSE,                   // 118 JSE Safex APD (SAFEX) � Johannesburg - �frica do Sul;
   fcKorea,                 // 119 Korea Exchange (KRX) - Busan - Cor�ia do Sul;
   fcChina,                 // 120 China Beijing International Mining Exchange, (CBMX);
   fcGlobalORE,             // 121 GlobalORE;
   fcLondonBullion,         // 122 London Bullion Market Association (LBMA);
   fcBeijing,               // 123 Beijing Iron Ore Trading Center Corporation (COREX). (Inclu�do pela IN RFB n� 1.870/2019)
   fcPLATTS,                // 201 PLATTS;
   fcARGUS,                 // 202 ARGUS;
   fcCMA,                   // 203 CMA;
   fcESALQ,                 // 204 ESALQ;
   fcTSI,                   // 205 TSI;
   fcBULLETIN,              // 206 THE METAL BULLETIN;
   fcCRU,                   // 207 CRU MONITOR;
   fcCIS,                   // 208 CIS; (Inclu�do pela IN RFB n� 1.395, de 13/09/2013)
   fcCMAI,                  // 209 CMAI; (Inclu�do pela IN RFB n� 1.395, de 13/09/2013)
   fcPOTEN,                 // 210 POTEN&PARTNERS; (Inclu�do pela IN RFB n� 1.395, de 13/09/2013)
   fcBLOOMERG,              // 211 BLOOMBERG; (Inclu�do pela IN RFB n� 1.395, de 13/09/2013)
   fcICIS,                  // 212 ICIS HEREN; (Inclu�do pela IN RFB n� 1.395, de 13/09/2013)
   fcUSEnergy,              // 213 U.S. Energy Information Administration (EIA). (Inclu�do pela IN RFB n� 1.395, de 13/09/2013)
   fcAgencias);               // 999 Ag�ncias ou �rg�os reguladores (art. 36, inciso II)

   /// Tipo de ajustes do pre�o par�metro que foram realizados (x325)
  TACBrAjustePrecoParametro325 = (
    appPremioArt34,           //  1 - Pr�mio (art. 34, �7�)
    appPrazoArt34,            //  2 - Prazo para pagamento (art. 34, �10, I)
    appQuantidadesArt34,      //  3 - Quantidades negociadas (art. 34, �10, II)
    appInfluenciaArt34,       //  4 - Influ�ncias clim�ticas nas caracter�sticas do bem exportado (art. 34, �10, III)
    appCustoIntermedicao,     //  5 - Custos de intermedia��o - Custos de intermedia��o, nas opera��es de compra e venda praticadas pelas....
    appAcondicionamentoArt34, //  6 - Acondicionamento (art. 34, �10, V)
    appFreteSeguroArt16,      //  7 - Frete e seguro (art. 16, �9�, VI)
    appCustoDesembarque,      //  8 - Custos de desembarque no porto, de transporte interno, de armazenagem e de desembara�o...
    appPrazoPagtoArt22,       //  9 - Prazo para pagamento (art. 22, �1�, I)
    appQtdeNegociadaArt22,    //  10 - Quantidades negociadas (art. 22, �1�, II)
    appGarantiaArt22,         //  11 - Garantia de funcionamento do bem ou da aplicabilidade do servi�o ou direito (art. 22, �1�, III)
    appPromocaoArt22,         //  12 - Promo��o do bem, servi�o ou direito (art. 22, �1�, IV)
    appCustosFiscalizacaoArt22, //  13 - Custos de fiscaliza��o de qualidade, de padr�o dos servi�os e das condi��es de higiene (art. 22, �1�, V)
    appCustoIntermediacaoArt22,    //  14 - Custos de intermedia��o (art. 22, �1�, VI)
    appAcondicionamentoArt9,  //  Acondicionamento (art. 9, �1�, VII)
    appFreteSeguroArt9,       //  16 - Frete e seguro (art. 9, �1�, VIII)
    appCustoDesembarque325,   //  17 - Custos de desembarque no porto
    appSimilaridadeArt10,     //  18 - Similaridade (art. 10)
    appVariacaoCambial24,     //  19 - Varia��o cambial (art. 24)
    appVariacaoCambial11,     //  20 - Varia��o cambial (art. 11, �1� ou art. 15, �7�)
    appOutros325              //  99 - Outros ajustes - essa op��o deve ser utilizada apenas em caso de altera��o da Instru��o Normativa RFB n� 1.312/2012
                              //      com previs�o de ajustes n�o contemplados nos c�digos anteriores
      );

  { TBlocos }

  TBlocos = class
  private
    FREG: string;
  public
    constructor Create;overload;
    property REG: string read FREG;
  end;

	{ TOpenBlocos }

  TOpenBlocos = class(TBlocos)
  private
    FIND_DAD: TACBrIndDad;
 /// Indicador de movimento: 0- Bloco com dados informados, 1- Bloco sem dados informados.
  public
    constructor Create;
    property IND_DAD: TACBrIndDad read FIND_DAD write FIND_DAD;
  end;

  { TCloseBlocos }

  TCloseBlocos = class(TBlocos)
  private
    FQTD_LIN: integer; /// quantidade de linhas
  public
    property QTD_LIN: integer read FQTD_LIN write FQTD_LIN;
  end;

  // Fu��es do ACBrECFBlocos.
function CodVerToStr(AValue: TACBrECFCodVer): string;
function StrToCodVer(const AValue: string): TACBrECFCodVer;

function IndOperToStr(AVAlue: TACBrIndOper): string;
function StrToIndOper(const AVAlue: string): TACBrIndOper;
function TipoItemToStr(AValue: TACBrTipoItem): string;
function StrToTipoItem(const AValue: string): TACBrTipoItem;
function IndEmitToStr(AValue: TACBrIndEmit): string;
function StrToIndEmit(const AValue: string): TACBrIndEmit;
function CodSitToStr(AValue: TACBrCodSit): string;
function StrToCodSit(const AValue: string): TACBrCodSit;
function IndPgtoToStr(AValue: TACBrIndPgto): string;
function StrToIndPgto(const AValue: string): TACBrIndPgto;
function IndFrtToStr(AValue: TACBrIndFrt): string;
function StrToIndFrt(const AValue: string): TACBrIndFrt;
function IndMovFisicaToStr(AValue: TACBrIndMovFisica): string;
function StrToIndMovFisica(const AValue: string): TACBrIndMovFisica;
 //  function CstIcmsToStr(AValue: TACBrCstIcms): string;
 //  function StrToCstIcms(AValue: String): TACBrCstIcms;
function StrToMotInv(const AValue: string): TACBrMotInv;
function MotInvToStr(AValue: TACBrMotInv): string;
function IndPropToStr(AValue: TACBrIndProp): string;
function StrToIndProp(const AValue: string): TACBrIndProp;
function TpLigacaoToStr(AValue: TACBrTpLigacao): string;
function StrToTpLigacao(const AValue: string): TACBrTpLigacao;
function GrupoTensaoToStr(AValue: TACBrGrupoTensao): string;
function StrToGrupoTensao(const AValue: string): TACBrGrupoTensao;
function IndRecToStr(AValue: TACBrIndRec): string;
function StrToIndRec(const AValue: string): TACBrIndRec;
function TpAssinanteToStr(AValue: TACBrTpAssinante): string;
function StrToTpAssinante(const AValue: string): TACBrTpAssinante;
function IndReceitaToStr(AValue: TACBrIndReceita): string;
function StrToIndReceita(const AValue: string): TACBrIndReceita;
function StrToAjustePrecoParametro305(const AValue: string): TACBrAjustePrecoParametro305;
function AjustePrecoParametro305ToStr(AValue: TACBrAjustePrecoParametro305): string;
function StrToFonteCotacao(const AValue: string): TACBrFonteCotacao;
function FonteCotacaoToStr(AValue: TACBrFonteCotacao): string;
function StrToAjustePrecoParametro325(const AValue: string): TACBrAjustePrecoParametro325;
function AjustePrecoParametro325ToStr(AValue: TACBrAjustePrecoParametro325): string;


implementation

{ TOpenBlocos }
function StrToCodVer(const AValue: string): TACBrECFCodVer;
begin
  if AValue = '0001' then
    Result := ECFVersao100
  else
  if AValue = '0002' then
    Result := ECFVersao200
  else
  if AValue = '0003' then
    Result := ECFVersao300
  else
  if AValue = '0004' then
    Result := ECFVersao400
  else
  if AValue = '0005' then
    Result := ECFVersao500
  else
  if AValue = '0006' then
    Result := ECFVersao600
  else
  if AValue = '0007' then
    Result := ECFVersao700
  else
  if AValue = '0008' then
    Result := ECFVersao800
  else
  if AValue = '0009' then
    Result := ECFVersao900
  else
  if AValue = '0010' then
    Result := ECFVersao1000
  else
  if AValue = '0011' then
    Result := ECFVersao1100
  else
    raise Exception.CreateFmt('Valor informado [%s] deve estar entre (0001 e 0010)', [AValue]);
end;

function CodVerToStr(AValue: TACBrECFCodVer): string;
begin
  if AValue = ECFVersao100 then
    Result := '0001'
  else
  if AValue = ECFVersao200 then
    Result := '0002'
  else
  if AValue = ECFVersao300 then
    Result := '0003'
  else
  if AValue = ECFVersao400 then
    Result := '0004'
  else
  if AValue = ECFVersao500 then
    Result := '0005'
  else
  if AValue = ECFVersao600 then
    Result := '0006'
  else
  if AValue = ECFVersao700 then
    Result := '0007'
  else
  if AValue = ECFVersao800 then
    Result := '0008'
  else
  if AValue = ECFVersao900 then
    Result := '0009'
  else
  if AValue = ECFVersao1000 then
    Result := '0010'
  else
  if AValue = ECFVersao1100 then
    Result := '0011'
  else
    raise Exception.Create('Valor informado inv�lido para ser convertido em TACBrECFCodVer');
end;

function IndOperToStr(AValue: TACBrIndOper): string;
begin
  Result := IntToStr(integer(AValue));
end;

function StrToIndOper(const AValue: string): TACBrIndOper;
begin
  Result := TACBrIndOper(StrToIntDef(AValue, 0));
end;

function TipoItemToStr(AValue: TACBrTipoItem): string;
begin
  if AValue = tiOutras then
    Result := '99'
  else
    Result := FormatFloat('00', integer(AValue));
end;

function StrToTipoItem(const AValue: string): TACBrTipoItem;
begin
  if AValue = '99' then
    Result := tiOutras
  else
    Result := TACBrTipoItem(StrToIntDef(AValue, 0));
end;

function IndEmitToStr(AValue: TACBrIndEmit): string;
begin
  Result := IntToStr(integer(AValue) + 1);
end;

function StrToIndEmit(const AValue: string): TACBrIndEmit;
begin
  Result := TACBrIndEmit(StrToIntDef(AValue, 0));
end;

function CodSitToStr(AValue: TACBrCodSit): string;
begin
  Result := FormatFloat('00', integer(AValue));
end;

function StrToCodSit(const AValue: string): TACBrCodSit;
begin
  Result := TACBrCodSit(StrToIntDef(AValue, 0));
end;

function IndPgtoToStr(AValue: TACBrIndPgto): string;
begin
  if AValue = tpSemPagamento then
    Result := '9'
  else
  if AValue = tpNenhum then
    Result := ''
  else
    Result := IntToStr(integer(AValue));
end;

function StrToIndPgto(const AValue: string): TACBrIndPgto;
begin
  if AValue = '9' then
    Result := tpSemPagamento
  else
  if AValue = '' then
    Result := tpNenhum
  else
    Result := TACBrIndPgto(StrToIntDef(AValue, 9));
end;

function IndFrtToStr(AValue: TACBrIndFrt): string;
begin
  if AValue = tfSemCobrancaFrete then
  begin
    Result := '9';
    Exit;
  end
  else
  if AValue = tfNenhum then
  begin
    Result := '';
    Exit;
  end;
  Result := IntToStr(integer(AValue));
end;

function StrToIndFrt(const AValue: string): TACBrIndFrt;
begin
  if AValue = '9' then
  begin
    Result := tfSemCobrancaFrete;
    Exit;
  end
  else
  if AValue = '' then
  begin
    Result := tfNenhum;
    Exit;
  end;
  Result := TACBrIndFrt(StrToIntDef(AValue, 0));
end;

function IndMovFisicaToStr(AValue: TACBrIndMovFisica): string;
begin
  Result := IntToStr(integer(AValue));
end;

function StrToIndMovFisica(const AValue: string): TACBrIndMovFisica;
begin
  Result := TACBrIndMovFisica(StrToIntDef(AValue, 0));
end;

{
function CstIcmsToStr(AValue: TACBrCstIcms): string;
begin
   Result := CstIcms[ Integer( AValue ) ];
end;

function StrToCstIcms(AValue: String): TACBrCstIcms;
var
ifor: Integer;
begin
   for ifor := 0 to High(CstIcms) do
   begin
      if AValue = CstIcms[ifor] then
      begin
         Result := TACBrCstIcms( ifor );
         Break;
      end;
   end;
end;
}

function StrToMotInv(const AValue: string): TACBrMotInv;
begin
  if AValue = '01' then
    Result := miFinalPeriodo
  else
  if AValue = '02' then
    Result := miMudancaTributacao
  else
  if AValue = '03' then
    Result := miBaixaCadastral
  else
  if AValue = '04' then
    Result := miRegimePagamento
  else
  if AValue = '05' then
    Result := miDeterminacaoFiscos
  else
    raise Exception.CreateFmt('O motivo do invent�rio "%s" n�o � um valor v�lido.', [AValue]);
end;

function MotInvToStr(AValue: TACBrMotInv): string;
begin
  if AValue = miFinalPeriodo then
    Result := '01'
  else
  if AValue = miMudancaTributacao then
    Result := '02'
  else
  if AValue = miBaixaCadastral then
    Result := '03'
  else
  if AValue = miRegimePagamento then
    Result := '04'
  else
  if AValue = miDeterminacaoFiscos then
    Result := '05'
  else
    raise Exception.Create('Valor informado inv�lido para ser convertido em TACBrMotInv');
end;

function IndPropToStr(AValue: TACBrIndProp): string;
begin
  Result := FormatFloat('00', integer(AValue));
end;

function StrToIndProp(const AValue: string): TACBrIndProp;
begin
  Result := TACBrIndProp(StrToIntDef(AValue, 0));
end;

function TpLigacaoToStr(AValue: TACBrTpLigacao): string;
begin
  Result := IntToStr(integer(AValue) + 1);
end;

function StrToTpLigacao(const AValue: string): TACBrTpLigacao;
begin
  Result := TACBrTpLigacao(StrToIntDef(AValue, 0));
end;

function GrupoTensaoToStr(AValue: TACBrGrupoTensao): string;
begin
  if AValue = gtNenhum then
    Result := ''
  else
    Result := FormatFloat('00', integer(AValue) + 1);
end;

function StrToGrupoTensao(const AValue: string): TACBrGrupoTensao;
begin
  if AValue = '' then
    Result := gtNenhum
  else
    Result := TACBrGrupoTensao(StrToIntDef(AValue, 0));
end;

function IndRecToStr(AValue: TACBrIndRec): string;
begin
  Result := IntToStr(integer(AValue));
end;

function StrToIndRec(const AValue: string): TACBrIndRec;
begin
  Result := TACBrIndRec(StrToIntDef(AValue, 0));
end;

function TpAssinanteToStr(AValue: TACBrTpAssinante): string;
begin
  Result := IntToStr(integer(AValue));
end;

function StrToTpAssinante(const AValue: string): TACBrTpAssinante;
begin
  if AValue = '' then
    Result := assNenhum
  else
    Result := TACBrTpAssinante(StrToIntDef(AValue, 6));
end;

function IndReceitaToStr(AValue: TACBrIndReceita): string;
begin
  if AValue = recTerceiroOutras then
    Result := '9'
  else
    Result := IntToStr(integer(AValue));
end;

function StrToIndReceita(const AValue: string): TACBrIndReceita;
begin
  if AValue = '9' then
    Result := recTerceiroOutras
  else
    Result := TACBrIndReceita(StrToIntDef(AValue, 6));
end;

function StrToAjustePrecoParametro305(const AValue: string): TACBrAjustePrecoParametro305;
begin
  if AValue = '1' then
    Result := appPremio
  else
  if AValue ='2'  then
    Result := appPrazo
  else
  if AValue = '3' then
    Result := appQuantidades
  else
  if AValue = '4' then
    Result := appInfluencia
  else
  if AValue = '5' then
    Result := appCustoInter
  else
  if AValue = '6' then
    Result := appAcondicionamento
  else
  if AValue = '7' then
    Result := appFreteSeguroArt34
  else
  if AValue = '8' then
    Result := appCustoDesembarqueArt34
  else
  if AValue = '9' then
    Result := appPrazoPagto
  else
  if AValue = '10' then
    Result := appQtdeNegociada
  else
  if AValue = '11' then
    Result := appGarantia
  else
  if AValue = '12' then
    Result := appPromocao
  else
  if AValue = '13' then
    Result := appCustosFiscalizacao
  else
  if AValue = '14' then
    Result := appCustoIntermediacao
  else
  if AValue = '15' then
    Result := appAcondicionamentoArt22
  else
  if AValue = '16' then
    Result := appFreteSeguroArt22
  else
  if AValue = '17' then
    Result := appRiscoCredito
  else
  if AValue = '18' then
    Result := appCustoDesembarqueArt22
  else
  if AValue = '19' then
    Result := appSimilaridade
  else
  if AValue = '20' then
    Result := appVariacao
  else
  if AValue = '99' then
    Result := appOutros
  else
    raise Exception.Create('Valor informado inv�lido para ser convertido em TACBrAjustePrecoParametro');

end;

function AjustePrecoParametro305ToStr(AValue: TACBrAjustePrecoParametro305): String;
begin
  if AValue = appPremio then
    Result := '1'
  else
  if AValue = appPrazo then
    Result := '2'
  else
  if AValue = appQuantidades then
    Result := '3'
  else
  if AValue = appInfluencia then
    Result := '4'
  else
  if AValue = appCustoInter then
    Result := '5'
  else
  if AValue = appAcondicionamento then
    Result := '6'
  else
  if AValue = appFreteSeguroArt34 then
    Result := '7'
  else
  if AValue = appCustoDesembarqueArt34 then
    Result := '8'
  else
  if AValue = appPrazoPagto then
    Result := '9'
  else
  if AValue = appQtdeNegociada then
    Result := '10'
  else
  if AValue = appGarantia then
    Result := '11'
  else
  if AValue = appPromocao then
    Result := '12'
  else
  if AValue = appCustosFiscalizacao then
    Result := '13'
  else
  if AValue = appCustoIntermediacao then
    Result := '14'
  else
  if AValue = appAcondicionamentoArt22 then
    Result := '15'
  else
  if AValue = appFreteSeguroArt22 then
    Result := '16'
  else
  if AValue = appRiscoCredito then
    Result := '17'
  else
  if AValue = appCustoDesembarqueArt22 then
    Result := '18'
  else
  if AValue = appSimilaridade then
    Result := '19'
  else
  if AValue = appVariacao then
    Result := '20'
  else
  if AValue = appOutros then
    Result := '99'
  else
    raise Exception.Create('Valor informado inv�lido para ser convertido em TACBrAjustePrecoParametro');


end;

function StrToFonteCotacao(const AValue: string): TACBrFonteCotacao;
begin
   if AValue = '101' then
    Result := fcChicagoBoard
  else
  if AValue = '102' then
    Result := fcChicagoMercantile
  else
  if AValue = '103' then
    Result := fcNewYorkMercantile
  else
  if AValue = '104' then
    Result := fcCommodity
  else
  if AValue = '105' then
    Result := fcIntercontinentalExchange
  else
  if AValue = '106' then
    Result := fcBolsaMercadoria
  else
  if AValue = '107' then
    Result := fcLifeNyse
  else
  if AValue = '108' then
    Result := fcLondonMetal
  else
  if AValue = '109' then
    Result := fcIntercontinental
  else
  if AValue = '110' then
    Result := fcTokioCommodity
  else
  if AValue = '111' then
    Result := fcTokioGrain
  else
  if AValue = '112' then
    Result := fcSingapore
  else
  if AValue = '113' then
    Result := fcHongKongm
  else
  if AValue = '114' then
    Result := fcMultiCommodity
  else
  if AValue = '115' then
    Result := fcNational
  else
  if AValue = '116' then
    Result := fcAgricultural
  else
  if AValue = '117' then
    Result := fcAustralian
  else
  if AValue = '118' then
    Result := fcJSE
  else
  if AValue = '119' then
    Result := fcKorea
  else
  if AValue = '120' then
    Result := fcChina
  else
  if AValue = '121' then
    Result := fcGlobalORE
  else
  if AValue = '122' then
    Result := fcLondonBullion
  else
  if AValue = '123' then
    Result := fcBeijing
  else
  if AValue = '201' then
    Result := fcPLATTS
  else
  if AValue = '202' then
    Result := fcARGUS
  else
  if AValue = '203' then
    Result := fcCMA
  else
  if AValue = '204' then
    Result := fcESALQ
  else
  if AValue = '205' then
    Result := fcTSI
  else
  if AValue = '206' then
    Result := fcBULLETIN
  else
  if AValue = '207' then
    Result := fcCRU
  else
  if AValue = '208' then
    Result := fcCIS
  else
  if AValue = '209' then
    Result := fcCMAI
  else
  if AValue = '210' then
    Result := fcPOTEN
  else
  if AValue = '211' then
    Result := fcBLOOMERG
  else
  if AValue = '212' then
    Result := fcICIS
  else
  if AValue = '213' then
    Result := fcUSEnergy
  else
  if AValue = '999' then
    Result := fcAgencias
  else
    raise Exception.Create('Valor informado inv�lido para ser convertido em TACBrFonteCotacao');
end;

function FonteCotacaoToStr(AValue: TACBrFonteCotacao): String;
begin
  if AValue = fcChicagoBoard then
    Result := '101'
  else
  if AValue = fcChicagoMercantile then
    Result := '102'
  else
  if AValue = fcNewYorkMercantile then
    Result := '103'
  else
  if AValue = fcCommodity then
    Result := '104'
  else
  if AValue = fcIntercontinentalExchange then
    Result := '105'
  else
  if AValue = fcBolsaMercadoria then
    Result := '106'
  else
  if AValue = fcLifeNyse then
    Result := '107'
  else
  if AValue = fcLondonMetal then
    Result := '108'
  else
  if AValue = fcIntercontinental then
    Result := '109'
  else
  if AValue = fcTokioCommodity then
    Result :=  '110'
  else
  if AValue = fcTokioGrain then
    Result := '111'
  else
  if AValue = fcSingapore then
    Result := '112'
  else
  if AValue = fcHongKongm then
    Result := '113'
  else
  if AValue = fcMultiCommodity then
    Result := '114'
  else
  if AValue = fcNational then
    Result := '115'
  else
  if AValue = fcAgricultural then
    Result := '116'
  else
  if AValue = fcAustralian then
    Result := '117'
  else
  if AValue = fcJSE then
    Result := '118'
  else
  if AValue = fcKorea then
    Result := '119'
  else
  if AValue = fcChina then
    Result := '120'
  else
  if AValue = fcGlobalORE then
    Result := '121'
  else
  if AValue = fcLondonBullion then
    Result := '122'
  else
  if AValue = fcBeijing then
    Result := '123'
  else
  if AValue = fcPLATTS then
    Result := '201'
  else
  if AValue = fcARGUS then
    Result := '202'
  else
  if AValue = fcCMA then
    Result := '203'
  else
  if AValue = fcESALQ then
    Result :=  '204'
  else
  if AValue = fcTSI then
    Result := '205'
  else
  if AValue = fcBULLETIN then
    Result :=  '206'
  else
  if AValue = fcCRU then
    Result := '207'
  else
  if AValue = fcCIS then
    Result := '208'
  else
  if AValue = fcCMAI then
    Result := '209'
  else
  if AValue = fcPOTEN then
    Result := '210'
  else
  if AValue = fcBLOOMERG then
    Result := '211'
  else
  if AValue = fcICIS then
    Result := '212'
  else
  if AValue = fcUSEnergy then
    Result := '213'
  else
  if AValue = fcAgencias then
    Result := '999'
  else
    raise Exception.Create('Valor informado inv�lido para ser convertido em TACBrFonteCotacao');

end;

function StrToAjustePrecoParametro325(const AValue: string): TACBrAjustePrecoParametro325;
begin
  if AValue = '1' then
    Result := appPremioArt34
  else
  if AValue ='2'  then
    Result := appPrazoArt34
  else
  if AValue = '3' then
    Result := appQuantidadesArt34
  else
  if AValue = '4' then
    Result := appInfluenciaArt34
  else
  if AValue = '5' then
    Result := appCustoIntermedicao
  else
  if AValue = '6' then
    Result := appAcondicionamentoArt34
  else
  if AValue = '7' then
    Result := appFreteSeguroArt16
  else
  if AValue = '8' then
    Result := appCustoDesembarque
  else
  if AValue = '9' then
    Result := appPrazoPagtoArt22
  else
  if AValue = '10' then
    Result := appQtdeNegociadaArt22
  else
  if AValue = '11' then
    Result := appGarantiaArt22
  else
  if AValue = '12' then
    Result := appPromocaoArt22
  else
  if AValue = '13' then
    Result := appCustosFiscalizacaoArt22
  else
  if AValue = '14' then
    Result := appCustoIntermediacaoArt22
  else
  if AValue = '15' then
    Result := appAcondicionamentoArt9
  else
  if AValue = '16' then
    Result := appFreteSeguroArt9
  else
  if AValue = '17' then
    Result := appCustoDesembarque325
  else
  if AValue = '18' then
    Result := appSimilaridadeArt10
  else
  if AValue = '19' then
    Result := appVariacaoCambial24
  else
  if AValue = '20' then
    Result := appVariacaoCambial11
  else
  if AValue = '99' then
    Result := appOutros325
  else
    raise Exception.Create('Valor informado inv�lido para ser convertido em TACBrAjustePrecoParametro');

end;

function AjustePrecoParametro325ToStr(AValue: TACBrAjustePrecoParametro325): String;
begin
  if AValue = appPremioArt34 then
    Result := '1'
  else
  if AValue = appPrazoArt34 then
    Result := '2'
  else
  if AValue = appQuantidadesArt34 then
    Result := '3'
  else
  if AValue = appInfluenciaArt34 then
    Result := '4'
  else
  if AValue = appCustoIntermedicao then
    Result := '5'
  else
  if AValue = appAcondicionamentoArt34 then
    Result := '6'
  else
  if AValue = appFreteSeguroArt16 then
    Result := '7'
  else
  if AValue = appCustoDesembarque then
    Result := '8'
  else
  if AValue = appPrazoPagtoArt22 then
    Result := '9'
  else
  if AValue = appQtdeNegociadaArt22 then
    Result := '10'
  else
  if AValue = appGarantiaArt22 then
    Result := '11'
  else
  if AValue = appPromocaoArt22 then
    Result := '12'
  else
  if AValue = appCustosFiscalizacaoArt22 then
    Result := '13'
  else
  if AValue = appCustoIntermediacaoArt22 then
    Result := '14'
  else
  if AValue = appAcondicionamentoArt9 then
    Result := '15'
  else
  if AValue = appFreteSeguroArt9 then
    Result := '16'
  else
  if AValue = appCustoDesembarque325 then
    Result := '17'
  else
  if AValue = appSimilaridadeArt10 then
    Result := '18'
  else
  if AValue = appVariacaoCambial24 then
    Result := '19'
  else
  if AValue =  appVariacaoCambial11 then
    Result := '20'
  else
  if AValue = appOutros325 then
    Result := '99'
  else
    raise Exception.Create('Valor informado inv�lido para ser convertido em TACBrAjustePrecoParametro');

end;


constructor TOpenBlocos.Create;
begin
  inherited;
  FIND_DAD := idSemDados;
end;

{ TBlocos }

constructor TBlocos.Create;
begin
  FREG := UpperCase(MidStr(ClassName, Length(ClassName) - 3, 4));
  if Length(FREG) <> 4 then
    raise Exception.Create('O tipo do Registro n�o foi informado corretamente!');
  //FREG := AREG;
end;

end.
