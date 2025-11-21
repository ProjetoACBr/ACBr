{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
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

unit ACBrDFe.Conversao;

interface

uses
  SysUtils, StrUtils, Classes;

type
  // Tipos que não tem funções de conversão
  TACBrTipoCampo = (tcStr, tcInt, tcInt64, tcDat, tcDatHor, tcEsp, tcDe1, tcDe2,
                    tcDe3, tcDe4, tcDe5, tcDe6, tcDe7, tcDe8, tcDe10, tcHor, tcDatCFe,
                    tcHorCFe, tcDatVcto, tcDatHorCFe, tcBool, tcStrOrig,
                    tcNumStr, tcDatUSA, tcBoolStr, tcDatBol);

  TACBrTagAssinatura = (taSempre, taNunca, taSomenteSeAssinada,
                        taSomenteParaNaoAssinada);

  // CTe e NFe
  TPosRecibo = (prCabecalho, prRodape, prEsquerda);

  // CTe e NFe
  TPosReciboLayout = (prlPadrao, prlBarra);

  // Tipos que tem funções de conversão
  TACBrTipoImpressao = (tiSemGeracao, tiRetrato, tiPaisagem, tiSimplificado,
                        tiNFCe, tiMsgEletronica);

const
  TACBrTipoImpressaoArrayStrings: array[TACBrTipoImpressao] of string = ('0', '1',
    '2', '3', '4', '5');

type
  TACBrTipoAmbiente = (taProducao, taHomologacao);

const
  TACBrTipoAmbienteArrayStrings: array[TACBrTipoAmbiente] of string = ('1', '2');

type
  TACBrTipoEmissao = (teNormal, teContingencia, teSCAN, teDPEC, teFSDA, teSVCAN,
                      teSVCRS, teSVCSP, teOffLine);

const
  TACBrTipoEmissaoArrayStrings: array[TACBrTipoEmissao] of string = ('1', '2',
    '3', '4', '5', '6', '7', '8', '9');

type
  TACBrProcessoEmissao = (peAplicativoContribuinte, peAvulsaFisco,
                          peAvulsaContribuinte, peContribuinteAplicativoFisco);

const
  TACBrProcessoEmissaoArrayStrings: array[TACBrProcessoEmissao] of string = ('0',
    '1', '2', '3');

type
  TACBrTipoEvento = (teNaoMapeado, teCCe, teCancelamento,
                  teManifDestConfirmacao, teManifDestCiencia, teManifDestDesconhecimento,
                  teManifDestOperNaoRealizada, teEncerramento, teEPEC,
                  teInclusaoCondutor, teMultiModal, teRegistroPassagem,
                  teRegistroPassagemBRId, teEPECNFe, teRegistroCTe,
                  teRegistroPassagemNFeCancelado, teRegistroPassagemNFeRFID, teCTeCancelado,
                  teMDFeCancelado, teVistoriaSuframa, tePedProrrog1,
                  tePedProrrog2, teCanPedProrrog1, teCanPedProrrog2,
                  teEventoFiscoPP1, teEventoFiscoPP2, teEventoFiscoCPP1,
                  teEventoFiscoCPP2, teRegistroPassagemNFe, teConfInternalizacao,
                  teCTeAutorizado, teMDFeAutorizado, tePrestDesacordo,
                  teGTV, teMDFeAutorizado2, teNaoEmbarque,
                  teMDFeCancelado2, teMDFeAutorizadoComCTe, teRegPasNfeProMDFe,
                  teRegPasNfeProMDFeCte, teRegPasAutMDFeComCte, teCancelamentoMDFeAutComCTe,
                  teAverbacaoExportacao, teAutCteComplementar, teCancCteComplementar,
                  teCTeSubstituicao, teCTeAnulacao, teLiberacaoEPEC,
                  teLiberacaoPrazoCanc, teAutorizadoRedespacho, teautorizadoRedespIntermed,
                  teAutorizadoSubcontratacao, teautorizadoServMultimodal, teCancSubst,
                  teAlteracaoPoltrona, teComprEntrega, teCancComprEntrega,
                  teInclusaoDFe, teAutorizadoSubstituicao, teAutorizadoAjuste,
                  teLiberacaoPrazoCancelado, tePagamentoOperacao, teExcessoBagagem,
                  teEncerramentoFisco, teComprEntregaNFe, teCancComprEntregaNFe,
                  teAtorInteressadoNFe, teComprEntregaCTe, teCancComprEntregaCTe,
                  teConfirmaServMDFe, teAlteracaoPagtoServMDFe,
                  teCancPrestDesacordo, teInsucessoEntregaCTe,
                  teCancInsucessoEntregaCTe, teInsucessoEntregaNFe,
                  teCancInsucessoEntregaNFe, teConcFinanceira, teCancConcFinanceira,
                  teRegistroPassagemMDFe, teCancGenerico, tePagIntegLibCredPresAdq,
                  teImporALCZFM, tePerecPerdaRouboFurtoTranspContratFornec,
                  teFornecNaoRealizPagAntec, teSolicApropCredPres,
                  teDestItemConsPessoal, tePerecPerdaRouboFurtoTranspContratAqu,
                  teAceiteDebitoApuracaoNotaCredito, teImobilizacaoItem,
                  teSolicApropCredCombustivel, teSolicApropCredBensServicos,
                  teManifPedTransfCredIBSSucessao, teManifPedTransfCredCBSSucessao,
                  teAtualizacaoDataPrevisaoEntrega);

const
  TACBrTipoEventoArrayStrings: array[TACBrTipoEvento] of string = ('-99999', '110110',
    '110111', '210200', '210210', '210220', '210240', '110112', '110113',
    '110114', '110160', '310620', '510620', '110140', '610600', '610501',
    '610550', '610601', '610611', '990900', '111500', '111501', '111502',
    '111503', '411500', '411501', '411502', '411503', '610500', '990910',
    '000000', '610610', '610110', '110170', '310610', '110115', '310611',
    '610614', '610510', '610514', '610554', '610615', '790700', '240130',
    '240131', '240140', '240150', '240160', '240170', '440130', '440140',
    '440150', '440160', '110112', '110116', '110180', '110181', '110115',
    '240140', '240150', '240170', '110116', '110117', '310112', '110130',
    '110131', '110150', '610130', '610131', '110117', '110118', '610111',
    '110190', '110191', '110192', '110193', '110750', '110751', '510630',
    '110001', '112110', '112120', '112130', '112140', '211110', '211120',
    '211124', '211128', '211130', '211140', '211150', '212110', '212120',
    '112150');

  TACBrTipoEventoDescricaoArrayStrings: array[TACBrTipoEvento] of string = ('NaoMapeado',
    'CCe', 'Cancelamento', 'ManifDestConfirmacao', 'ManifDestCiencia',
    'ManifDestDesconhecimento', 'ManifDestOperNaoRealizada', 'Encerramento',
    'EPEC', 'InclusaoCondutor', 'MultiModal', 'RegistroPassagem',
    'RegistroPassagemBRId', 'EPECNFe', 'RegistroCTe',
    'RegistroPassagemNFeCancelado', 'RegistroPassagemNFeRFID', 'CTeCancelado',
    'MDFeCancelado', 'VistoriaSuframa', 'PedProrrog1', 'PedProrrog2',
    'CanPedProrrog1', 'CanPedProrrog2', 'EventoFiscoPP1', 'EventoFiscoPP2',
    'EventoFiscoCPP1', 'EventoFiscoCPP2', 'RegistroPassagemNFe',
    'ConfInternalizacao', 'CTeAutorizado', 'MDFeAutorizado', 'PrestDesacordo',
    'GTV', 'MDFeAutorizado2', 'NaoEmbarque', 'MDFeCancelado2',
    'MDFeAutorizadoComCTe', 'RegPasNfeProMDFe', 'RegPasNfeProMDFeCte',
    'RegPasAutMDFeComCte', 'CancelamentoMDFeAutComCTe', 'AverbacaoExportacao',
    'AutCteComplementar', 'CancCteComplementar', 'CTeSubstituicao',
    'CTeAnulacao', 'LiberacaoEPEC', 'LiberacaoPrazoCanc', 'AutorizadoRedespacho',
    'AutorizadoRedespIntermed', 'AutorizadoSubcontratacao',
    'AutorizadoServMultimodal', 'CancelamentoPorSubstituicao',
    'AlteracaoPoltrona', 'ComprEntrega', 'CancComprEntrega', 'InclusaoDFe',
    'AutorizadoSubstituicao', 'AutorizadoAjuste', 'LiberacaoPrazoCancelado',
    'PagamentoOperacao', 'ExcessoBagagem', 'EncerramentoFisco',
    'ComprEntregaNFe', 'CancComprEntregaNFe', 'AtorInteressadoNFe',
    'ComprEntregaCTe', 'CancComprEntregaCTe', 'ConfirmaServMDFe',
    'AlteracaoPagtoServMDFe', 'CancPrestDesacordo',
    'InsucessoEntregaCTe', 'CancInsucessoEntregaCTe', 'InsucessoEntregaNFe',
    'CancInsucessoEntregaNFe', 'ConcFinanceira', 'CancConcFinanceira',
  	'RegistroPassagemMDFe', 'CancGenerico', 'PagIntegLibCredPresAdq',
    'ImporALCZFM', 'PerecPerdaRouboFurtoTranspContratFornec',
    'FornecNaoRealizPagAntec', 'SolicApropCredPres', 'DestItemConsPessoal',
    'PerecPerdaRouboFurtoTranspContratAqu',
    'AceiteDebitoApuracaoNotaCredito', 'ImobilizacaoItem',
    'SolicApropCredCombustivel', 'SolicApropCredBensServicos',
    'ManifPedTransfCredIBSSucessao', 'ManifPedTransfCredCBSSucessao',
    'AtualizacaoDataPrevisaoEntrega');

type
  TStrToTpEvento = function (out ok: boolean; const s: string): TACBrTipoEvento;

  TStrToTpEventoDFe = record
    StrToTpEventoMethod: TStrToTpEvento;
    NomeDFe: string;
  end;

  TModal = (mdRodoviario, mdAereo, mdAquaviario, mdFerroviario, mdDutoviario,
            mdMultimodal);

const
  TModalArrayStrings: array[TModal] of string = ('01','02', '03', '04', '05',
    '06');

  TModalDescricaoArrayStrings: array[TModal] of string = ('RODOVIÁRIO',
    'AÉREO', 'AQUAVIÁRIO', 'FERROVIÁRIO', 'DUTOVIÁRIO', 'MULTIMODAL');

type
  TIndicador = (tiSim, tiNao);

const
  TIndicadorArrayStrings: array[TIndicador] of string = ('1', '0');

type
  TIndicadorEx = (tieNenhum, tieSim, tieNao);

const
  TIndicadorExArrayStrings: array[TIndicadorEx] of string = ('', '1', '0');

type
  TSituacaoDFe = (snAutorizado, snDenegado, snCancelado, snEncerrado);

const
  TSituacaoDFeArrayStrings: array[TSituacaoDFe] of string = ('1', '2', '3', '4');

type
  TTipoNFe = (tnEntrada, tnSaida);

const
  TTipoNFeArrayStrings: array[TTipoNFe] of string = ('0', '1');

type
  TSchemaDFe = (schresNFe, schresEvento, schprocNFe, schprocEventoNFe,
                schresCTe, schprocCTe, schprocCTeOS, schprocEventoCTe,
                schresMDFe, schprocMDFe, schprocEventoMDFe,
                schresBPe, schprocBPe, schprocEventoBPe,
                schprocGTVe, schprocCTeSimp);

  // NFe e SAT
  TOrigemMercadoria = (oeNacional, oeEstrangeiraImportacaoDireta, oeEstrangeiraAdquiridaBrasil,
                       oeNacionalConteudoImportacaoSuperior40, oeNacionalProcessosBasicos,
                       oeNacionalConteudoImportacaoInferiorIgual40,
                       oeEstrangeiraImportacaoDiretaSemSimilar, oeEstrangeiraAdquiridaBrasilSemSimilar,
                       oeNacionalConteudoImportacaoSuperior70, oeReservadoParaUsoFuturo,
                       oeVazio);

const
  TOrigemMercadoriaArrayStrings: array[TOrigemMercadoria] of string = ('0', '1',
    '2', '3', '4', '5', '6', '7', '8', '9', '');

  TOrigemMercadoriaDescricaoArrayStrings: array[TOrigemMercadoria] of string = (
    '0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8. ',
    '1 - Estrangeira - Importação direta, exceto a indicada no código 6.',
    '2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7.',
    '3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%.',
    '4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes.',
    '5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%. ',
    '6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural. ',
    '7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.',
    '8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%.',
    '9',
    '');

type
  // CTe, NFe e SAT
  TCSTIcms = (cstVazio, cst00, cst10, cst20, cst30, cst40, cst41, cst45, cst50,
    cst51, cst60, cst70, cst80, cst81, cst90, cstICMSOutraUF, cstICMSSN,
    cstPart10, cstPart90, cstRep41, cstRep60, cst02, cst15, cst53, cst61, cst01,
    cst12, cst13, cst14, cst21, cst72, cst73, cst74); //80 e 81 apenas para CTe

const
  TCSTIcmsArrayStringsEnt: array[TCSTIcms] of string = ('', '00', '10', '20', '30',
    '40', '41', '45', '50', '51', '60', '70', '80', '81', '90', '91', 'SN',
    '10part', '90part', '41rep', '60rep', '02', '15', '53', '61', '01', '12',
    '13', '14', '21', '72', '73', '74');

  TCSTIcmsArrayStringsSai: array[TCSTIcms] of string = ('', '00', '10', '20', '30',
    '40', '41', '45', '50', '51', '60', '70', '80', '81', '90', '90', 'SN',
    '10', '90', '41', '60', '02', '15', '53', '61', '01', '12', '13', '14', '21',
    '72', '73', '74');

  TCSTIcmsDescricaoArrayStrings: array[TCSTIcms] of string = ('VAZIO',
    '00 - TRIBUTAÇÃO NORMAL DO ICMS',
    '10 - TRIBUTAÇÃO COM COBRANÇA DO ICMS POR SUBST. TRIBUTÁRIA',
    '20 - TRIBUTAÇÃO COM REDUÇÃO DE BC DO ICMS',
    '30 - TRIBUTAÇÃO ISENTA E COM COBRANÇA DO ICMS POR SUBST. TRIBUTÁRIA',
    '40 - ICMS ISENÇÃO',
    '41 - ICMS NÃO TRIBUTADO',
    '45 - ICMS ISENTO, NÃO TRIBUTADO OU DIFERIDO',
    '50 - ICMS SUSPENSÃO',
    '51 - ICMS DIFERIDO',
    '60 - ICMS COBRADO POR SUBSTITUIÇÃO TRIBUTÁRIA',
    '70 - TRIBUTAÇÃO COM REDUÇÃO DE BC E COBRANÇA DO ICMS POR SUBST. TRIBUTÁRIA',
    '80 - RESPONSABILIDADE DO RECOLHIMENTO DO ICMS ATRIBUÍDO AO TOMADOR OU 3° POR ST',
    '81 - ICMS DEVIDO À OUTRA UF',
    '90 - ICMS OUTROS',
    '90 - ICMS DEVIDO A UF DE ORIGEM DA PRESTACAO, QUANDO DIFERENTE DA UF DO EMITENTE',
    '90 - SIMPLES NACIONAL',
    '10 - TRIBUTADA E COM COBRANÇA DO ICMS POR SUBSTITUIÇÃO TRIBUTÁRIA - PARTILHA',
    '90 - OUTROS - PARTILHA',
    '41 - NÃO TRIBUTADO - REPASSE',
    '60 - COBRADO ANTERIORMENTE POR SUBSTITUIÇÃO TRIBUTÁRIA - REPASSE',
    '02 - Tributação monofásica própria sobre combustíveis',
    '15 - Tributação monofásica própria e com responsabilidade pela retenção sobre combustíveis',
    '53 - Tributação monofásica sobre combustíveis com recolhimento diferido',
    '61 - Tributação monofásica sobre combustíveis cobrada anteriormente',
    '01',
    '12',
    '13',
    '14',
    '21',
    '72',
    '73',
    '74');

type
  // NFe e SAT
  TCSOSNIcms = (csosnVazio, csosn101, csosn102, csosn103, csosn201, csosn202,
                csosn203, csosn300, csosn400, csosn500, csosn900);

const
  TCSOSNIcmsArrayStrings: array[TCSOSNIcms] of string = ('','101', '102', '103',
    '201', '202', '203', '300', '400', '500','900');

  TCSOSNIcmsDescricaoArrayStrings: array[TCSOSNIcms] of string = ('VAZIO',
    '101 - Tributada pelo Simples Nacional com permissão de crédito',
    '102 - Tributada pelo Simples Nacional sem permissão de crédito',
    '103 - Isenção do ICMS no Simples Nacional para faixa de receita bruta',
    '201 - Tributada pelo Simples Nacional com permissão de crédito e com cobrança do ICMS por substituição tributária',
    '202 - Tributada pelo Simples Nacional sem permissão de crédito e com cobrança do ICMS por substituição tributária',
    '203 - Isenção do ICMS no Simples Nacional para faixa de receita bruta e com cobrança do ICMS por substituição tributária',
    '300 - Imune',
    '400 - Não tributada pelo Simples Nacional',
    '500 - ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação',
    '900 - Outros');

type
  // NFe e SAT
  TCSTPis = (pis01, pis02, pis03, pis04, pis05, pis06, pis07, pis08, pis09,
             pis49, pis50, pis51, pis52, pis53, pis54, pis55, pis56, pis60,
             pis61, pis62, pis63, pis64, pis65, pis66, pis67, pis70, pis71,
             pis72, pis73, pis74, pis75, pis98, pis99);

const
  TCSTPisArrayStrings: array[TCSTPis] of string = ('01', '02', '03', '04', '05',
    '06', '07', '08', '09', '49', '50', '51', '52', '53', '54', '55', '56', '60',
    '61', '62', '63', '64', '65', '66', '67', '70', '71', '72', '73', '74', '75',
    '98', '99');

  TCSTPisDescricaoArrayStrings: array[TCSTPis] of string = (
    '01 - Operação Tributável com Alíquota Básica',
    '02 - Operação Tributável com Alíquota Diferenciada',
    '03 - Operação Tributável com Alíquota por Unidade de Medida de Produto',
    '04 - Operação Tributável Monofásica - Revenda a Alíquota Zero',
    '05 - Operação Tributável por Substituição Tributária',
    '06 - Operação Tributável a Alíquota Zero',
    '07 - Operação Isenta da Contribuição',
    '08 - Operação sem Incidência da Contribuição',
    '09 - Operação com Suspensão da Contribuição',
    '49 - Outras Operações de Saída',
    '50 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno',
    '51 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno',
    '52 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação',
    '53 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno',
    '54 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação',
    '55 - Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação',
    '56 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação',
    '60 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno',
    '61 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno',
    '62 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação',
    '63 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno',
    '64 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação',
    '65 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação',
    '66 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação',
    '67 - Crédito Presumido - Outras Operações',
    '70 - Operação de Aquisição sem Direito a Crédito',
    '71 - Operação de Aquisição com Isenção',
    '72 - Operação de Aquisição com Suspensão',
    '73 - Operação de Aquisição a Alíquota Zero',
    '74 - Operação de Aquisição sem Incidência da Contribuição',
    '75 - Operação de Aquisição por Substituição Tributária',
    '98 - Outras Operações de Entrada',
    '99 - Outras Operações');

type
  // NFe e SAT
  TCSTCofins = (cof01, cof02, cof03, cof04, cof05, cof06, cof07, cof08, cof09,
                cof49, cof50, cof51, cof52, cof53, cof54, cof55, cof56, cof60,
                cof61, cof62, cof63, cof64, cof65, cof66, cof67, cof70, cof71,
                cof72, cof73, cof74, cof75, cof98, cof99);

const
  TCSTCofinsArrayStrings: array[TCSTCofins] of string = ('01', '02', '03', '04',
    '05', '06', '07', '08', '09', '49', '50', '51', '52', '53', '54', '55', '56',
    '60', '61', '62', '63', '64', '65', '66', '67', '70', '71', '72', '73', '74',
    '75', '98', '99');

  TCSTCofinsDescricaoArrayStrings: array[TCSTCofins] of string = (
    '01 - Operação Tributável com Alíquota Básica',
    '02 - Operação Tributável com Alíquota Diferenciada',
    '03 - Operação Tributável com Alíquota por Unidade de Medida de Produto',
    '04 - Operação Tributável Monofásica - Revenda a Alíquota Zero',
    '05 - Operação Tributável por Substituição Tributária',
    '06 - Operação Tributável a Alíquota Zero',
    '07 - Operação Isenta da Contribuição',
    '08 - Operação sem Incidência da Contribuição',
    '09 - Operação com Suspensão da Contribuição',
    '49 - Outras Operações de Saída',
    '50 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno',
    '51 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno',
    '52 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação',
    '53 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno',
    '54 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação',
    '55 - Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação',
    '56 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação',
    '60 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno',
    '61 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno',
    '62 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação',
    '63 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno',
    '64 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação',
    '65 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação',
    '66 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação',
    '67 - Crédito Presumido - Outras Operações',
    '70 - Operação de Aquisição sem Direito a Crédito',
    '71 - Operação de Aquisição com Isenção',
    '72 - Operação de Aquisição com Suspensão',
    '73 - Operação de Aquisição a Alíquota Zero',
    '74 - Operação de Aquisição sem Incidência da Contribuição',
    '75 - Operação de Aquisição por Substituição Tributária',
    '98 - Outras Operações de Entrada',
    '99 - Outras Operações');

type
  // CTe e MDFe
  TTipoRodado = (trNaoAplicavel, trTruck, trToco, trCavaloMecanico, trVAN,
                 trUtilitario, trOutros);

const
  TTipoRodadoArrayStrings: array[TTipoRodado] of string = ('00', '01', '02',
    '03', '04', '05', '06');

type
  // CTe e MDFe
  TTipoCarroceria = (tcNaoAplicavel, tcAberta, tcFechada, tcGraneleira,
                     tcPortaContainer, tcSider);

const
  TTipoCarroceriaArrayStrings: array[TTipoCarroceria] of string = ('00', '01',
    '02', '03', '04', '05');

type
  // BPe e NFe
  TtpIntegra = (tiNaoInformado, tiPagIntegrado, tiPagNaoIntegrado);

const
  TtpIntegraArrayStrings: array[TtpIntegra] of string = ('', '1', '2');

type
  // CTe e MDFe
  TUnidTransp = (utRodoTracao, utRodoReboque, utNavio, utBalsa, utAeronave,
                 utVagao, utOutros);

const
  TUnidTranspArrayStrings: array[TUnidTransp] of string = ('1', '2', '3', '4',
    '5', '6', '7');

type
  // CTe e MDFe
  TUnidCarga = (ucContainer, ucULD, ucPallet, ucOutros);

const
  TUnidCargaArrayStrings: array[TUnidCarga] of string = ('1', '2', '3', '4');

type
  // CTe e MDFe
  TtpProp = (tpTACAgregado, tpTACIndependente, tpOutros);

const
  TtpPropArrayStrings: array[TtpProp] of string = ('0', '1', '2');

type
  // CTe e MDFe
  TUnidMed = (uM3, uKG, uTON, uUNIDADE, uLITROS, uMMBTU);

const
  TUnidMedArrayStrings: array[TUnidMed] of string = ('00', '01', '02', '03',
    '04', '05');

  TUnidMedDescricaoArrayStrings: array[TUnidMed] of string = ('M3', 'KG', 'TON',
    'UND', 'LT', 'MMBTU');

type
  // CTe e MDFe
  TTipoNavegacao = (tnInterior, tnCabotagem);

const
  TTipoNavegacaoArrayStrings: array[TTipoNavegacao] of string = ('0', '1');

type
  // CTe e NFe
  TindIEDest = (inContribuinte, inIsento, inNaoContribuinte);

const
  TindIEDestArrayStrings: array[TindIEDest] of string = ('1', '2', '9');

type
  // NFe e SAT
  TRegTribISSQN = (RTISSMicroempresaMunicipal, RTISSEstimativa,
                   RTISSSociedadeProfissionais, RTISSCooperativa, RTISSMEI,
                   RTISSMEEPP, RTISSNenhum);

const
  TRegTribISSQNArrayStrings: array[TRegTribISSQN] of string = ('1', '2', '3',
    '4', '5', '6', '0');

type
  // NFe e SAT
  TindIncentivo = (iiSim, iiNao);

const
  TindIncentivoArrayStrings: array[TindIncentivo] of string = ('1', '2');

  TindIncentivoDescricaoArrayStrings: array[TindIncentivo] of string = (
    '1 - Sim', '2 - Não');

type
  // SAT
  TRegTrib = (RTRegimeNormal, RTSimplesNacional{, RTRegimeNormal});

const
  TRegTribArrayStrings: array[TRegTrib] of string = ('0', '1'{, '3'});

type
  // SAT
  TindRatISSQN = (irSim, irNao);

const
  TindRatISSQNArrayStrings: array[TindRatISSQN] of string = ('S', 'N');

type
  // SAT
  TindRegra = (irArredondamento, irTruncamento);

const
  TindRegraArrayStrings: array[TindRegra] of string = ('A', 'T');

type
  // SAT
  TCodigoMP = (mpDinheiro, mpCheque, mpCartaodeCredito, mpCartaodeDebito, mpCreditoLoja,
               mpValeAlimentacao, mpValeRefeicao, mpValePresente, mpValeCombustivel,
               mpBoletoBancario, mpDepositoBancario, mpPagamentoInstantaneo,
               mpTransfBancario, mpProgramaFidelidade, mpSemPagamento, mpOutros);

const
  TCodigoMPArrayStrings: array[TCodigoMP] of string = ('01', '02', '03', '04',
    '05', '10', '11', '12', '13', '15', '16', '17', '18', '19', '90', '99');

  TCodigoMPDescricaoArrayStrings: array[TCodigoMP] of string = (
    'Dinheiro', 'Cheque', 'Cartão de Crédito', 'Cartão de Débito',
    'Crédito Loja', 'Vale Alimentação', 'Vale Refeição', 'Vale Presente',
    'Vale Combustível', 'Boleto Bancário', 'Depósito Bancário',
    'Pagamento Instantâneo (PIX)', 'Transferência Bancária',
    'Programa de Fidelidade', 'Sem Pagamento', 'Outros');

  // Reforma Tributária
type
  TtpEnteGov = (tcgNenhum, tcgUniao, tcgEstados, tcgDistritoFederal,
                tcgMunicipios);

const
  TtpEnteGovArrayStrings: array[TtpEnteGov] of string = ('', '1', '2', '3', '4');

type
  TtpOperGov = (togNenhum, togFornecimento, togRecebimentoPag);

const
  TtpOperGovArrayStrings: array[TtpOperGov] of string = ('', '1', '2');

type
  TCSTIBSCBS = (cstNenhum,
    cst000, cst010, cst011, cst200, cst220, cst221, cst222, cst400, cst410,
    cst510, cst515, cst550, cst620, cst800, cst810, cst811, cst820, cst830);

const
  TCSTIBSCBSArrayStrings: array[TCSTIBSCBS] of string = ('',
    '000', '010', '011', '200', '220', '221', '222', '400', '410', '510', '515',
    '550', '620', '800', '810', '811', '820', '830');

type
  TcCredPres = (cpNenhum,
    cp01, cp02, cp03, cp04, cp05, cp06, cp07, cp08, cp09, cp10, cp11, cp12, cp13);

const
  TcCredPresArrayStrings: array[TcCredPres] of string = ('',
    '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13');

const
  DFeUF: array[0..26] of String =
  ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA',
   'PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO');

  DFeUFCodigo: array[0..26] of Integer =
  (12,27,16,13,29,23,53,32,52,21,51,50,31,15,25,41,26,22,33,24,43,11,14,42,35,28,17);

type
  TIndAceitacao = (iaNaoAceite, iaAceite);

const
  TIndAceitacaoArrayStrings: array[TIndAceitacao] of string = ('0', '1');

{
  Declaração das funções de conversão
}

function StrToEnumerado(out ok: boolean; const s: string; const AString: array of string;
  const AEnumerados: array of variant): variant;
function EnumeradoToStr(const t: variant; const AString:
  array of string; const AEnumerados: array of variant): variant;

function TpImpToStr(const t: TACBrTipoImpressao): string;
function TryStrToTpImp(const s: string; out Value: TACBrTipoImpressao): Boolean;
function StrToTpImp(const s: string): TACBrTipoImpressao;

function TipoEmissaoToStr(const t: TACBrTipoEmissao): string;
function TryStrToTipoEmissao(const s: string; out Value: TACBrTipoEmissao): Boolean;
function StrToTipoEmissao(const s: string): TACBrTipoEmissao;

function TipoAmbienteToStr(const t: TACBrTipoAmbiente): string;
function TryStrToTipoAmbiente(const s: string; out Value: TACBrTipoAmbiente): Boolean;
function StrToTipoAmbiente(const s: string): TACBrTipoAmbiente;

function procEmiToStr(const t: TACBrProcessoEmissao): string;
function TryStrToProcEmi(const s: string; out Value: TACBrProcessoEmissao): Boolean;
function StrToprocEmi(const s: string): TACBrProcessoEmissao;

function TpEventoToStr(const t: TACBrTipoEvento): string;
function TpEventoToDescStr(const t: TACBrTipoEvento): string;

function StrTotpEventoDFe(out ok: boolean; const s, aDFe: string): TACBrTipoEvento;

procedure RegisterStrToTpEventoDFe(AConvertProcedure: TStrToTpEvento; ADFe: string);

function TpModalToStr(const t: TModal): string;
function TpModalToStrText(const t: TModal): string;
function TryStrToTpModal(const s: string; out Value: TModal): Boolean;
function StrToTpModal(const s: string): TModal;

function TIndicadorToStr(const t: TIndicador): string;
function TryStrToTIndicador(const S: string; out Value: TIndicador ):boolean;
function StrToTIndicador(const s: string): TIndicador;

function TIndicadorExToStr(const t: TIndicadorEx): string;
function TryStrToTIndicadorEx(const s: string; out Value: TIndicadorEx): Boolean;
function StrToTIndicadorEx(const s: string): TIndicadorEx;

function SituacaoDFeToStr(const t: TSituacaoDFe): String;
function TryStrToSituacaoDFe(const s: string; out Value: TSituacaoDFe): Boolean;
function StrToSituacaoDFe(const s: String): TSituacaoDFe;

function tpNFToStr(const t: TTipoNFe): String;
function TryStrToTpNF(const s: string; out Value: TTipoNFe): Boolean;
function StrToTpNF(const s: String): TTipoNFe;

function SchemaDFeToStr(const t: TSchemaDFe): String;
function StrToSchemaDFe(const s: String): TSchemaDFe;

function OrigToStr(const t: TOrigemMercadoria): string;
function TryStrToOrig(const s: string; out Value: TOrigemMercadoria): Boolean;
function StrToOrig(const s: string): TOrigemMercadoria;
function OrigToStrTagPosText(const t: TOrigemMercadoria): string;

function CSTICMSToStr(const t: TCSTIcms): string;
function TryStrToCSTICMS(const s: string; out Value: TCSTIcms): Boolean;
function StrToCSTICMS(const s: string): TCSTIcms;
function CSTICMSToStrTagPos(const t: TCSTIcms): string;
function CSTICMSToStrTagPosText(const t: TCSTIcms): string;

function CSOSNIcmsToStr(const t: TCSOSNIcms): string;
function TryStrToCSOSNIcms(const s: string; out Value: TCSOSNIcms): Boolean;
function StrToCSOSNIcms(const s: string): TCSOSNIcms;

function CSOSNToStrTagPos(const t: TCSOSNIcms): string;
function CSOSNToStrID(const t: TCSOSNIcms): string;
function CSOSNToStrTagPosText(const t: TCSOSNIcms): string;

function CSTPISToStr(const t: TCSTPIS): string;
function TryStrToCSTPIS(const s: string; out Value: TCSTPIS): Boolean;
function StrToCSTPIS(const s: string): TCSTPIS;
function CSTPISToStrTagPosText(const t: TCSTPIS): string;

function CSTCOFINSToStr(const t: TCSTCofins): string;
function TryStrToCSTCOFINS(const s: string; out Value: TCSTCofins): Boolean;
function StrToCSTCOFINS(const s: string): TCSTCofins;
function CSTCOFINSToStrTagPosText(const t: TCSTCofins): string;

function TpRodadoToStr(const t: TTipoRodado): string;
function TryStrToTpRodado(const s: string; out Value: TTipoRodado): Boolean;
function StrToTpRodado(const s: string): TTipoRodado;

function TpCarroceriaToStr(const t: TTipoCarroceria): string;
function TryStrToTpCarroceria(const s: string; out Value: TTipoCarroceria): Boolean;
function StrToTpCarroceria(const s: string): TTipoCarroceria;

function tpIntegraToStr(const t: TtpIntegra): string;
function TryStrTotpIntegra(const s: string; out Value: TtpIntegra): Boolean;
function StrTotpIntegra(const s: string): TtpIntegra;

function UnidTranspToStr(const t: TUnidTransp):string;
function TryStrToUnidTransp(const s: string; out Value: TUnidTransp): Boolean;
function StrToUnidTransp(const s: string): TUnidTransp;

function UnidCargaToStr(const t: TUnidCarga): string;
function TryStrToUnidCarga(const s: string; out Value: TUnidCarga): Boolean;
function StrToUnidCarga(const s: string): TUnidCarga;

function TpPropToStr(const t: TtpProp): string;
function TryStrToTpProp(const s: string; out Value: TtpProp): Boolean;
function StrToTpProp(const s: string): TtpProp;

function UnidMedToStr(const t: TUnidMed): string;
function TryStrToUnidMed(const s: string; out Value: TUnidMed): Boolean;
function StrToUnidMed(const s: String): TUnidMed;
function UnidMedToDescricaoStr(const t: TUnidMed): string;

function TpNavegacaoToStr(const t: TTipoNavegacao): string;
function TryStrToTpNavegacao(const s: string; out Value: TTipoNavegacao): Boolean;
function StrToTpNavegacao(const s: string): TTipoNavegacao;

function indIEDestToStr(const t: TindIEDest): string;
function TryStrToindIEDest(const s: string; out Value: TindIEDest): Boolean;
function StrToindIEDest(const s: string): TindIEDest;

function RegTribISSQNToStr(const t: TRegTribISSQN): string;
function TryStrToRegTribISSQN(const s: string; out Value: TRegTribISSQN): Boolean;
function StrToRegTribISSQN(const s: string): TRegTribISSQN;

function indIncentivoToStr(const t: TindIncentivo): string;
function TryStrToindIncentivo(const s: string; out Value: TindIncentivo): Boolean;
function StrToindIncentivo(const s: string): TindIncentivo;
function indIncentivoToStrTagPosText(const t: TindIncentivo): string;

// SAT
function RegTribToStr(const t: TRegTrib): string;
function TryStrToRegTrib(const s: string; out Value: TRegTrib): Boolean;
function StrToRegTrib(const s: string): TRegTrib;

function indRatISSQNToStr(const t: TindRatISSQN): string;
function TryStrToindRatISSQN(const s: string; out Value: TindRatISSQN): Boolean;
function StrToindRatISSQN(const s: string): TindRatISSQN ;

function indRegraToStr(const t: TindRegra): string;
function TryStrToindRegra(const s: string; out Value: TindRegra): Boolean;
function StrToindRegra(const s: string): TindRegra;

function CodigoMPToStr(const t: TCodigoMP): string;
function TryStrToCodigoMP(const s: string; out Value: TCodigoMP): Boolean;
function StrToCodigoMP(const s: string): TCodigoMP;
function CodigoMPToDescricao(const t: TCodigoMP): string;

// Reforma Tributária
function tpEnteGovToStr(const t: TtpEnteGov): string;
function TryStrTotpEnteGov(const s: string; out Value: TtpEnteGov): Boolean;
function StrTotpEnteGov(const s: string): TtpEnteGov;

function tpOperGovToStr(const t: TtpOperGov): string;
function TryStrTotpOperGov(const s: string; out Value: TtpOperGov): Boolean;
function StrTotpOperGov(const s: string): TtpOperGov;

function CSTIBSCBSToStr(const t: TCSTIBSCBS): string;
function TryStrToCSTIBSCBS(const s: string; out Value: TCSTIBSCBS): Boolean;
function StrToCSTIBSCBS(const s: string): TCSTIBSCBS;

function cCredPresToStr(const t: TcCredPres): string;
function TryStrTocCredPres(const s: string; out Value: TcCredPres): Boolean;
function StrTocCredPres(const s: string): TcCredPres;

function indAceitacaoToStr(const t: TIndAceitacao): string;
function TryStrToIndAceitacao(const s: string; out Value: TIndAceitacao): Boolean;
function StrToIndAceitacao(const s: string): TIndAceitacao;

var
  StrToTpEventoDFeList: array of TStrToTpEventoDFe;

implementation

uses
  typinfo,
  ACBrBase;

function StrToEnumerado(out ok: boolean; const s: string; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  ok := False;
  result := -1;
  for i := Low(AString) to High(AString) do
    if AnsiSameText(s, AString[i]) then
    begin
      result := AEnumerados[i];
      ok := True;
      exit;
    end;
 result := AEnumerados[0];
end;

function EnumeradoToStr(const t: variant; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := '';
  for i := Low(AEnumerados) to High(AEnumerados) do
    if t = AEnumerados[i] then
      result := AString[i];
end;

function TpImpToStr(const t: TACBrTipoImpressao): string;
begin
  Result := TACBrTipoImpressaoArrayStrings[t];
end;

function TryStrToTpImp(const s: string; out Value: TACBrTipoImpressao): Boolean;
var
  idx: TACBrTipoImpressao;
begin
  Result := False;
  for idx := Low(TACBrTipoImpressaoArrayStrings) to High(TACBrTipoImpressaoArrayStrings) do
  begin
    if TACBrTipoImpressaoArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTpImp(const s: string): TACBrTipoImpressao;
begin
  if not TryStrToTpImp(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TACBrTipoImpressao: %s', [s]);
end;

function TipoEmissaoToStr(const t: TACBrTipoEmissao): string;
begin
  Result := TACBrTipoEmissaoArrayStrings[t];
end;

function TryStrToTipoEmissao(const s: string; out Value: TACBrTipoEmissao): Boolean;
var
  idx: TACBrTipoEmissao;
begin
  Result := False;
  for idx := Low(TACBrTipoEmissaoArrayStrings) to High(TACBrTipoEmissaoArrayStrings) do
  begin
    if TACBrTipoEmissaoArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTipoEmissao(const s: string): TACBrTipoEmissao;
begin
  if not TryStrToTipoEmissao(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TACBrTipoEmissao: %s', [s]);
end;

function TipoAmbienteToStr(const t: TACBrTipoAmbiente): string;
begin
  Result := TACBrTipoAmbienteArrayStrings[t];
end;

function TryStrToTipoAmbiente(const s: string; out Value: TACBrTipoAmbiente): Boolean;
var
  idx: TACBrTipoAmbiente;
begin
  Result := False;
  for idx := Low(TACBrTipoAmbienteArrayStrings) to High(TACBrTipoAmbienteArrayStrings) do
  begin
    if TACBrTipoAmbienteArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTipoAmbiente(const s: string): TACBrTipoAmbiente;
begin
  if not TryStrToTipoAmbiente(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TACBrTipoAmbiente: %s', [s]);
end;

function procEmiToStr(const t: TACBrProcessoEmissao): string;
begin
  Result := TACBrProcessoEmissaoArrayStrings[t];
end;

function TryStrToProcEmi(const s: string; out Value: TACBrProcessoEmissao): Boolean;
var
  idx: TACBrProcessoEmissao;
begin
  Result := False;
  for idx := Low(TACBrProcessoEmissaoArrayStrings) to High(TACBrProcessoEmissaoArrayStrings) do
  begin
    if TACBrProcessoEmissaoArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToProcEmi(const s: string): TACBrProcessoEmissao;
begin
  if not TryStrToProcEmi(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TACBrProcessoEmissao: %s', [s]);
end;

function TpEventoToStr(const t: TACBrTipoEvento): string;
begin
  result := TACBrTipoEventoArrayStrings[t];
end;

function TpEventoToDescStr(const t: TACBrTipoEvento): string;
begin
  result := TACBrTipoEventoDescricaoArrayStrings[t];
end;

function StrToTpEventoDFe(out ok: boolean; const s, aDFe: string): TACBrTipoEvento;
var
  LenList, i: Integer;
  UpperDFe: string;
begin
  Result := teNaoMapeado;
  UpperDFe := UpperCase(aDFe);
  // Varrendo lista de Métodos registrados, para ver se algum conheçe o "aDFe"
  LenList := Length(StrToTpEventoDFeList);

  for i := 0 to LenList-1 do
    if (StrToTpEventoDFeList[i].NomeDFe = UpperDFe) then
       Result := StrToTpEventoDFeList[i].StrToTpEventoMethod(ok, s);
end;

procedure RegisterStrToTpEventoDFe(AConvertProcedure: TStrToTpEvento;
  ADFe: string);
var
  LenList, i: Integer;
  UpperDFe: string;
begin
  UpperDFe := UpperCase(ADFe);
  LenList := Length(StrToTpEventoDFeList);

  // Verificando se já foi registrado antes...
  for i := 0 to LenList-1 do
    if (StrToTpEventoDFeList[i].NomeDFe = UpperDFe) then
      Exit;

  // Adicionando Novo Item na Lista
  SetLength(StrToTpEventoDFeList, LenList+1);
  with StrToTpEventoDFeList[LenList] do
  begin
    NomeDFe := UpperDFe;
    StrToTpEventoMethod := AConvertProcedure;
  end;
end;

function TpModalToStr(const t: TModal): string;
begin
  Result := TModalArrayStrings[t];
end;

function TpModalToStrText(const t: TModal): string;
begin
  Result := TModalDescricaoArrayStrings[t];
end;

function TryStrToTpModal(const s: string; out Value: TModal): Boolean;
var
  idx: TModal;
begin
  Result := False;
  for idx := Low(TModalArrayStrings) to High(TModalArrayStrings) do
  begin
    if TModalArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTpModal(const s: string): TModal;
begin
  if not TryStrToTpModal(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TModal: %s', [s]);
end;

function TIndicadorToStr(const t: TIndicador): string;
begin
  Result := TIndicadorArrayStrings[t];
end;

function TryStrToTIndicador(const S: string; out Value: TIndicador ):boolean;
var
  idx: TIndicador;
begin
  Result := False;
  for idx := Low(TIndicadorArrayStrings) to High(TIndicadorArrayStrings) do
  begin
    if (TIndicadorArrayStrings[idx] = S) then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTIndicador(const s: string): TIndicador;
begin
  if not TryStrToTIndicador(s, Result) then
  raise EACBrException.CreateFmt('Valor string inválido para TIndicador: %s', [s]);
end;

function TIndicadorExToStr(const t: TIndicadorEx): string;
begin
  Result := TIndicadorExArrayStrings[t];
end;

function TryStrToTIndicadorEx(const s: string; out Value: TIndicadorEx): Boolean;
var
  idx: TIndicadorEx;
begin
  Result := False;
  for idx := Low(TIndicadorExArrayStrings) to High(TIndicadorExArrayStrings) do
  begin
    if TIndicadorExArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTIndicadorEx(const s: string): TIndicadorEx;
begin
  if not TryStrToTIndicadorEx(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TIndicadorEx: %s', [s]);
end;

function SituacaoDFeToStr(const t: TSituacaoDFe): String;
begin
  Result := TSituacaoDFeArrayStrings[t];
end;

function TryStrToSituacaoDFe(const s: string; out Value: TSituacaoDFe): Boolean;
var
  idx: TSituacaoDFe;
begin
  Result := False;
  for idx := Low(TSituacaoDFeArrayStrings) to High(TSituacaoDFeArrayStrings) do
  begin
    if TSituacaoDFeArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToSituacaoDFe(const s: string): TSituacaoDFe;
begin
  if not TryStrToSituacaoDFe(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TSituacaoDFe: %s', [s]);
end;

function tpNFToStr(const t: TTipoNFe): String;
begin
  Result := TTipoNFeArrayStrings[t];
end;

function TryStrToTpNF(const s: string; out Value: TTipoNFe): Boolean;
var
  idx: TTipoNFe;
begin
  Result := False;
  for idx := Low(TTipoNFeArrayStrings) to High(TTipoNFeArrayStrings) do
  begin
    if TTipoNFeArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTpNF(const s: string): TTipoNFe;
begin
  if not TryStrToTpNF(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TTipoNFe: %s', [s]);
end;

function SchemaDFeToStr(const t: TSchemaDFe): String;
begin
  Result := GetEnumName(TypeInfo(TSchemaDFe), Integer( t ) );
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function StrToSchemaDFe(const s: String): TSchemaDFe;
var
  P: Integer;
  SchemaStr: String;
  CodSchema: Integer;
begin
  P := pos('_',s);
  if p > 0 then
    SchemaStr := copy(s,1,P-1)
  else
    SchemaStr := s;

  if LeftStr(SchemaStr,3) <> 'sch' then
    SchemaStr := 'sch' + SchemaStr;

  CodSchema := GetEnumValue(TypeInfo(TSchemaDFe), SchemaStr );

  if CodSchema = -1 then
  begin
    raise EACBrException.Create(Format('"%s" não é um valor TSchemaDFe válido.',[SchemaStr]));
  end;

  Result := TSchemaDFe( CodSchema );
end;

function OrigToStr(const t: TOrigemMercadoria): string;
begin
  Result := TOrigemMercadoriaArrayStrings[t];
end;

function TryStrToOrig(const s: string; out Value: TOrigemMercadoria): Boolean;
var
  idx: TOrigemMercadoria;
begin
  Result := False;
  for idx := Low(TOrigemMercadoriaArrayStrings) to High(TOrigemMercadoriaArrayStrings) do
  begin
    if TOrigemMercadoriaArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToOrig(const s: string): TOrigemMercadoria;
begin
  if not TryStrToOrig(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TOrigemMercadoria: %s', [s]);
end;

function OrigToStrTagPosText(const t: TOrigemMercadoria): string;
begin
  Result := TOrigemMercadoriaDescricaoArrayStrings[t];
end;

function CSTICMSToStr(const t: TCSTIcms): string;
begin
  Result := TCSTIcmsArrayStringsSai[t];
end;

function TryStrToCSTICMS(const s: string; out Value: TCSTIcms): Boolean;
var
  idx: TCSTIcms;
begin
  Result := False;
  for idx := Low(TCSTIcmsArrayStringsEnt) to High(TCSTIcmsArrayStringsEnt) do
  begin
    if TCSTIcmsArrayStringsEnt[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToCSTICMS(const s: string): TCSTIcms;
begin
  if not TryStrToCSTICMS(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TCSTIcms: %s', [s]);
end;

function CSTICMSToStrTagPos(const t: TCSTIcms): string;
begin
  Result := EnumeradoToStr(t, ['02', '03', '04', '05', '06', '06', '06', '07',
                     '08', '09', '10', '11', '12', '10a', '10a', '10b', '10b',
                     '13', '14', '15', '16'],
    [cst00, cst10, cst20, cst30, cst40, cst41, cst50, cst51, cst60, cst70,
     cst80, cst81, cst90, cstPart10 , cstPart90 , cstRep41, cstRep60,
     cst02, cst15, cst53, cst61]);
end;

function CSTICMSToStrTagPosText(const t: TCSTIcms): string;
begin
  Result := TCSTIcmsDescricaoArrayStrings[t];
end;

function CSOSNIcmsToStr(const t: TCSOSNIcms): string;
begin
  Result := TCSOSNIcmsArrayStrings[t];
end;

function TryStrToCSOSNIcms(const s: string; out Value: TCSOSNIcms): Boolean;
var
  idx: TCSOSNIcms;
begin
  Result := False;
  for idx := Low(TCSOSNIcmsArrayStrings) to High(TCSOSNIcmsArrayStrings) do
  begin
    if TCSOSNIcmsArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToCSOSNIcms(const s: string): TCSOSNIcms;
begin
  if not TryStrToCSOSNIcms(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TCSOSNIcms: %s', [s]);
end;

function CSOSNToStrTagPos(const t: TCSOSNIcms): string;
begin
  case  t of
    csosn101                               : result := '101';
    csosn102, csosn103, csosn300, csosn400 : result := '102';
    csosn201                               : result := '201';
    csosn202,csosn203                      : result := '202';
    csosn500                               : result := '500';
    csosn900                               : result := '900';
  end;
end;

function CSOSNToStrID(const t: TCSOSNIcms): string;
begin
  case  t of
    csosn101                               : result := '10c';
    csosn102, csosn103, csosn300, csosn400 : result := '10d';
    csosn201                               : result := '10e';
    csosn202,csosn203                      : result := '10f';
    csosn500                               : result := '10g';
    csosn900                               : result := '10h';
  end;
end;

function CSOSNToStrTagPosText(const t: TCSOSNIcms): string;
begin
  Result := TCSOSNIcmsDescricaoArrayStrings[t];
end;

function CSTPISToStr(const t: TCSTPIS): string;
begin
  Result := TCSTPISArrayStrings[t];
end;

function TryStrToCSTPIS(const s: string; out Value: TCSTPIS): Boolean;
var
  idx: TCSTPIS;
begin
  Result := False;
  for idx := Low(TCSTPISArrayStrings) to High(TCSTPISArrayStrings) do
  begin
    if TCSTPISArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToCSTPIS(const s: string): TCSTPIS;
begin
  if not TryStrToCSTPIS(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TCSTPIS: %s', [s]);
end;

function CSTPISToStrTagPosText(const t: TCSTPIS): string;
begin
  Result := TCSTPISDescricaoArrayStrings[t];
end;

function CSTCOFINSToStr(const t: TCSTCofins): string;
begin
  Result := TCSTCofinsArrayStrings[t];
end;

function TryStrToCSTCOFINS(const s: string; out Value: TCSTCofins): Boolean;
var
  idx: TCSTCofins;
begin
  Result := False;
  for idx := Low(TCSTCofinsArrayStrings) to High(TCSTCofinsArrayStrings) do
  begin
    if TCSTCofinsArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToCSTCOFINS(const s: string): TCSTCofins;
begin
  if not TryStrToCSTCOFINS(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TCSTCofins: %s', [s]);
end;

function CSTCOFINSToStrTagPosText(const t: TCSTCofins): string;
begin
  Result := TCSTCofinsDescricaoArrayStrings[t];
end;

function TpRodadoToStr(const t: TTipoRodado): string;
begin
  Result := TTipoRodadoArrayStrings[t];
end;

function TryStrToTpRodado(const s: string; out Value: TTipoRodado): Boolean;
var
  idx: TTipoRodado;
begin
  Result := False;
  for idx := Low(TTipoRodadoArrayStrings) to High(TTipoRodadoArrayStrings) do
  begin
    if TTipoRodadoArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTpRodado(const s: string): TTipoRodado;
begin
  if not TryStrToTpRodado(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TTipoRodado: %s', [s]);
end;

function TpCarroceriaToStr(const t: TTipoCarroceria): string;
begin
  Result := TTipoCarroceriaArrayStrings[t];
end;

function TryStrToTpCarroceria(const s: string; out Value: TTipoCarroceria): Boolean;
var
  idx: TTipoCarroceria;
begin
  Result := False;
  for idx := Low(TTipoCarroceriaArrayStrings) to High(TTipoCarroceriaArrayStrings) do
  begin
    if TTipoCarroceriaArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTpCarroceria(const s: string): TTipoCarroceria;
begin
  if not TryStrToTpCarroceria(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TTipoCarroceria: %s', [s]);
end;

function tpIntegraToStr(const t: TtpIntegra): string;
begin
  Result := TtpIntegraArrayStrings[t];
end;

function TryStrTotpIntegra(const s: string; out Value: TtpIntegra): Boolean;
var
  idx: TtpIntegra;
begin
  Result := False;
  for idx := Low(TtpIntegraArrayStrings) to High(TtpIntegraArrayStrings) do
  begin
    if TtpIntegraArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrTotpIntegra(const s: string): TtpIntegra;
begin
  if not TryStrTotpIntegra(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TtpIntegra: %s', [s]);
end;

function UnidTranspToStr(const t: TUnidTransp): string;
begin
  Result := TUnidTranspArrayStrings[t];
end;

function TryStrToUnidTransp(const s: string; out Value: TUnidTransp): Boolean;
var
  idx: TUnidTransp;
begin
  Result := False;
  for idx := Low(TUnidTranspArrayStrings) to High(TUnidTranspArrayStrings) do
  begin
    if TUnidTranspArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToUnidTransp(const s: string): TUnidTransp;
begin
  if not TryStrToUnidTransp(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TUnidTransp: %s', [s]);
end;

function UnidCargaToStr(const t: TUnidCarga): string;
begin
  Result := TUnidCargaArrayStrings[t];
end;

function TryStrToUnidCarga(const s: string; out Value: TUnidCarga): Boolean;
var
  idx: TUnidCarga;
begin
  Result := False;
  for idx := Low(TUnidCargaArrayStrings) to High(TUnidCargaArrayStrings) do
  begin
    if TUnidCargaArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToUnidCarga(const s: string): TUnidCarga;
begin
  if not TryStrToUnidCarga(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TUnidCarga: %s', [s]);
end;

function TpPropToStr(const t: TtpProp): string;
begin
  Result := TtpPropArrayStrings[t];
end;

function TryStrToTpProp(const s: string; out Value: TtpProp): Boolean;
var
  idx: TtpProp;
begin
  Result := False;
  for idx := Low(TtpPropArrayStrings) to High(TtpPropArrayStrings) do
  begin
    if TtpPropArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTpProp(const s: string): TtpProp;
begin
  if not TryStrToTpProp(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TtpProp: %s', [s]);
end;

function UnidMedToStr(const t: TUnidMed): string;
begin
  Result := TUnidMedArrayStrings[t];
end;

function TryStrToUnidMed(const s: string; out Value: TUnidMed): Boolean;
var
  idx: TUnidMed;
begin
  Result := False;
  for idx := Low(TUnidMedArrayStrings) to High(TUnidMedArrayStrings) do
  begin
    if TUnidMedArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToUnidMed(const s: string): TUnidMed;
begin
  if not TryStrToUnidMed(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TUnidMed: %s', [s]);
end;

function UnidMedToDescricaoStr(const t: TUnidMed): string;
begin
  Result := TUnidMedDescricaoArrayStrings[t];
end;

function TpNavegacaoToStr(const t: TTipoNavegacao): string;
begin
  Result := TTipoNavegacaoArrayStrings[t];
end;

function TryStrToTpNavegacao(const s: string; out Value: TTipoNavegacao): Boolean;
var
  idx: TTipoNavegacao;
begin
  Result := False;
  for idx := Low(TTipoNavegacaoArrayStrings) to High(TTipoNavegacaoArrayStrings) do
  begin
    if TTipoNavegacaoArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToTpNavegacao(const s: string): TTipoNavegacao;
begin
  if not TryStrToTpNavegacao(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TTipoNavegacao: %s', [s]);
end;

function indIEDestToStr(const t: TindIEDest): string;
begin
  Result := TindIEDestArrayStrings[t];
end;

function TryStrToindIEDest(const s: string; out Value: TindIEDest): Boolean;
var
  idx: TindIEDest;
begin
  Result := False;
  for idx := Low(TindIEDestArrayStrings) to High(TindIEDestArrayStrings) do
  begin
    if TindIEDestArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToindIEDest(const s: string): TindIEDest;
begin
  if not TryStrToindIEDest(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TindIEDest: %s', [s]);
end;

function RegTribISSQNToStr(const t: TRegTribISSQN): string;
begin
  Result := TRegTribISSQNArrayStrings[t];
end;

function TryStrToRegTribISSQN(const s: string; out Value: TRegTribISSQN): Boolean;
var
  idx: TRegTribISSQN;
begin
  Result := False;
  for idx := Low(TRegTribISSQNArrayStrings) to High(TRegTribISSQNArrayStrings) do
  begin
    if TRegTribISSQNArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToRegTribISSQN(const s: string): TRegTribISSQN;
begin
  if not TryStrToRegTribISSQN(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TRegTribISSQN: %s', [s]);
end;

function indIncentivoToStr(const t: TindIncentivo): string;
begin
  Result := TindIncentivoArrayStrings[t];
end;

function TryStrToindIncentivo(const s: string; out Value: TindIncentivo): Boolean;
var
  idx: TindIncentivo;
begin
  Result := False;
  for idx := Low(TindIncentivoArrayStrings) to High(TindIncentivoArrayStrings) do
  begin
    if TindIncentivoArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToindIncentivo(const s: string): TindIncentivo;
begin
  if not TryStrToindIncentivo(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TindIncentivo: %s', [s]);
end;

function indIncentivoToStrTagPosText(const t: TindIncentivo): string;
begin
  Result := TindIncentivoDescricaoArrayStrings[t];
end;

function RegTribToStr(const t: TRegTrib): string;
begin
  Result := TRegTribArrayStrings[t];
end;

function TryStrToRegTrib(const s: string; out Value: TRegTrib): Boolean;
var
  idx: TRegTrib;
begin
  Result := False;
  for idx := Low(TRegTribArrayStrings) to High(TRegTribArrayStrings) do
  begin
    if TRegTribArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToRegTrib(const s: string): TRegTrib;
begin
  if not TryStrToRegTrib(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TRegTrib: %s', [s]);
end;

function indRatISSQNToStr(const t: TindRatISSQN): string;
begin
  Result := TindRatISSQNArrayStrings[t];
end;

function TryStrToindRatISSQN(const s: string; out Value: TindRatISSQN): Boolean;
var
  idx: TindRatISSQN;
begin
  Result := False;
  for idx := Low(TindRatISSQNArrayStrings) to High(TindRatISSQNArrayStrings) do
  begin
    if TindRatISSQNArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToindRatISSQN(const s: string): TindRatISSQN;
begin
  if not TryStrToindRatISSQN(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TindRatISSQN: %s', [s]);
end;

function indRegraToStr(const t: TindRegra): string;
begin
  Result := TindRegraArrayStrings[t];
end;

function TryStrToindRegra(const s: string; out Value: TindRegra): Boolean;
var
  idx: TindRegra;
begin
  Result := False;
  for idx := Low(TindRegraArrayStrings) to High(TindRegraArrayStrings) do
  begin
    if TindRegraArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToindRegra(const s: string): TindRegra;
begin
  if not TryStrToindRegra(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TindRegra: %s', [s]);
end;

function CodigoMPToStr(const t: TCodigoMP): string;
begin
  Result := TCodigoMPArrayStrings[t];
end;

function TryStrToCodigoMP(const s: string; out Value: TCodigoMP): Boolean;
var
  idx: TCodigoMP;
begin
  Result := False;
  for idx := Low(TCodigoMPArrayStrings) to High(TCodigoMPArrayStrings) do
  begin
    if TCodigoMPArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToCodigoMP(const s: string): TCodigoMP;
begin
  if not TryStrToCodigoMP(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TCodigoMP: %s', [s]);
end;

function CodigoMPToDescricao(const t: TCodigoMP): string;
begin
  Result := TCodigoMPDescricaoArrayStrings[t];
end;

function tpEnteGovToStr(const t: TtpEnteGov): string;
begin
  Result := TtpEnteGovArrayStrings[t];
end;

function TryStrTotpEnteGov(const s: string; out Value: TtpEnteGov): Boolean;
var
  idx: TtpEnteGov;
begin
  Result := False;
  for idx := Low(TtpEnteGovArrayStrings) to High(TtpEnteGovArrayStrings) do
  begin
    if TtpEnteGovArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrTotpEnteGov(const s: string): TtpEnteGov;
begin
  if not TryStrTotpEnteGov(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TtpEnteGov: %s', [s]);
end;

function tpOperGovToStr(const t: TtpOperGov): string;
begin
  Result := TtpOperGovArrayStrings[t];
end;

function TryStrTotpOperGov(const s: string; out Value: TtpOperGov): Boolean;
var
  idx: TtpOperGov;
begin
  Result := False;
  for idx := Low(TtpOperGovArrayStrings) to High(TtpOperGovArrayStrings) do
  begin
    if TtpOperGovArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrTotpOperGov(const s: string): TtpOperGov;
begin
  if not TryStrTotpOperGov(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TtpOperGov: %s', [s]);
end;

function CSTIBSCBSToStr(const t: TCSTIBSCBS): string;
begin
  Result := TCSTIBSCBSArrayStrings[t];
end;

function TryStrToCSTIBSCBS(const s: string; out Value: TCSTIBSCBS): Boolean;
var
  idx: TCSTIBSCBS;
begin
  Result := False;
  for idx := Low(TCSTIBSCBSArrayStrings) to High(TCSTIBSCBSArrayStrings) do
  begin
    if TCSTIBSCBSArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToCSTIBSCBS(const s: string): TCSTIBSCBS;
begin
  if not TryStrToCSTIBSCBS(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TCSTIBSCBS: %s', [s]);
end;

function cCredPresToStr(const t: TcCredPres): string;
begin
  Result := TcCredPresArrayStrings[t];
end;

function TryStrTocCredPres(const s: string; out Value: TcCredPres): Boolean;
var
  idx: TcCredPres;
begin
  Result := False;
  for idx := Low(TcCredPresArrayStrings) to High(TcCredPresArrayStrings) do
  begin
    if TcCredPresArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrTocCredPres(const s: string): TcCredPres;
begin
  if not TryStrTocCredPres(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TcCredPres: %s', [s]);
end;

function indAceitacaoToStr(const t: TIndAceitacao): string;
begin
  Result := TIndAceitacaoArrayStrings[t];
end;

function TryStrToIndAceitacao(const s: string; out Value: TIndAceitacao): Boolean;
var
  idx: TIndAceitacao;
begin
  Result := False;
  for idx := Low(TIndAceitacaoArrayStrings) to High(TIndAceitacaoArrayStrings) do
  begin
    if TIndAceitacaoArrayStrings[idx] = s then
    begin
      Value := idx;
      Result := True;
      Exit;
    end;
  end;
end;

function StrToIndAceitacao(const s: string): TIndAceitacao;
begin
  if not TryStrToIndAceitacao(s, Result) then
    raise EACBrException.CreateFmt('Valor string inválido para TIndAceitacao: %s', [s]);
end;

end.

