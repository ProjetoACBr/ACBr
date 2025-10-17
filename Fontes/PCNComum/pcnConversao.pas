////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar NFe                                    //
//                                                                            //
//   Descrição: Classes para geração/leitura dos arquivos xml da NFe          //
//                                                                            //
//        site: www.projetocooperar.org/nfe                                   //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_nfe/        //
//     projeto: http://code.google.com/p/projetocooperar/                     //
//         svn: http://projetocooperar.googlecode.com/svn/trunk/              //
//                                                                            //
// Coordenação: (c) 2009 - Paulo Casagrande                                   //
//                                                                            //
//      Equipe: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
// Desenvolvimento                                                            //
//         de Cte: Wiliam Zacarias da Silva Rosa                              //
//                                                                            //
//      Versão: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//     Licença: GNU Lesser General Public License (GNU LGPL)                  //
//                                                                            //
//              - Este programa é software livre; você pode redistribuí-lo    //
//              e/ou modificá-lo sob os termos da Licença Pública Geral GNU,  //
//              conforme publicada pela Free Software Foundation; tanto a     //
//              versão 2 da Licença como (a seu critério) qualquer versão     //
//              mais nova.                                                    //
//                                                                            //
//              - Este programa é distribuído na expectativa de ser útil,     //
//              mas SEM QUALQUER GARANTIA; sem mesmo a garantia implícita de  //
//              COMERCIALIZAÇÃO ou de ADEQUAÇÃO A QUALQUER PROPÓSITO EM       //
//              PARTICULAR. Consulte a Licença Pública Geral GNU para obter   //
//              mais detalhes. Você deve ter recebido uma cópia da Licença    //
//              Pública Geral GNU junto com este programa; se não, escreva    //
//              para a Free Software Foundation, Inc., 59 Temple Place,       //
//              Suite 330, Boston, MA - 02111-1307, USA ou consulte a         //
//              licença oficial em http://www.gnu.org/licenses/gpl.txt        //
//                                                                            //
//    Nota (1): - Esta  licença  não  concede  o  direito  de  uso  do nome   //
//              "PCN  -  Projeto  Cooperar  NFe", não  podendo o mesmo ser    //
//              utilizado sem previa autorização.                             //
//                                                                            //
//    Nota (2): - O uso integral (ou parcial) das units do projeto esta       //
//              condicionado a manutenção deste cabeçalho junto ao código     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

{$I ACBr.inc}

unit pcnConversao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Utilize a unit ACBrDFe.Conversao no lugar dessa' {$ENDIF};

interface

uses
  SysUtils, StrUtils, Classes,
  ACBrDFe.Conversao;

{$IFDEF FPC}
  {$DEFINE SUPPORTS_SCOPEDENUMS}
{$ENDIF}
{$IFDEF DELPHI2009_UP}
  {$DEFINE SUPPORTS_SCOPEDENUMS}
{$ENDIF}

type
  TpcnTipoCampo = ACBrDFe.Conversao.TACBrTipoCampo;
  TpcnTagAssinatura = ACBrDFe.Conversao.TACBrTagAssinatura;
  TpcnTipoImpressao = ACBrDFe.Conversao.TACBrTipoImpressao;
  TpcnTipoEmissao = ACBrDFe.Conversao.TACBrTipoEmissao;
  TpcnTipoAmbiente = ACBrDFe.Conversao.TACBrTipoAmbiente;
  TpcnProcessoEmissao = ACBrDFe.Conversao.TACBrProcessoEmissao;
  TpcnTpEvento = ACBrDFe.Conversao.TACBrTipoEvento;
  TpcteModal = ACBrDFe.Conversao.TModal;
  TIndicador = ACBrDFe.Conversao.TIndicador;
  TIndicadorEx = ACBrDFe.Conversao.TIndicadorEx;
  TSituacaoDFe = ACBrDFe.Conversao.TSituacaoDFe;
  TpcnTipoNFe = ACBrDFe.Conversao.TTipoNFe;
  TSchemaDFe = ACBrDFe.Conversao.TSchemaDFe;
  TpcnOrigemMercadoria = ACBrDFe.Conversao.TOrigemMercadoria;
  TpcnCSTIcms = ACBrDFe.Conversao.TCSTIcms;
  TpcnCSOSNIcms = ACBrDFe.Conversao.TCSOSNIcms;
  TpcnCstPis = ACBrDFe.Conversao.TCSTPis;
  TpcnCstCofins = ACBrDFe.Conversao.TCSTCofins;
  TpcteTipoRodado = ACBrDFe.Conversao.TTipoRodado;
  TpcteTipoCarroceria = ACBrDFe.Conversao.TTipoCarroceria;
  TPosRecibo = ACBrDFe.Conversao.TPosRecibo;
  TPosReciboLayout = ACBrDFe.Conversao.TPosReciboLayout;
  TtpIntegra = ACBrDFe.Conversao.TtpIntegra;
  TpcnUnidTransp = ACBrDFe.Conversao.TUnidTransp;
  TpcnUnidCarga  = ACBrDFe.Conversao.TUnidCarga;
  TpcteProp = ACBrDFe.Conversao.TtpProp;
  TUnidMed = ACBrDFe.Conversao.TUnidMed;
  TTipoNavegacao = ACBrDFe.Conversao.TTipoNavegacao;
  TpcnindIEDest = ACBrDFe.Conversao.TindIEDest;
  TpcnRegTribISSQN = ACBrDFe.Conversao.TRegTribISSQN;
  TpcnindIncentivo = ACBrDFe.Conversao.TindIncentivo;
  // SAT
  TpcnRegTrib = ACBrDFe.Conversao.TRegTrib;
  TpcnindRatISSQN = ACBrDFe.Conversao.TindRatISSQN;
  TpcnindRegra = ACBrDFe.Conversao.TindRegra;
  TpcnCodigoMP = ACBrDFe.Conversao.TCodigoMP;



  // Enumerados do TACBrTipoCampo
const
  tcStr = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcStr deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcInt = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcInt deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDat = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDat deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDatHor = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDatHor deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcEsp = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcEsp deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDe2 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDe2 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDe3 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDe3 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDe4 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDe4 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDe5 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDe5 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDe6 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDe6 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDe7 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDe7 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDe8 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDe8 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDe10 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDe10 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcHor = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcHor deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDatCFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDatCFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcHorCFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcHorCFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDatVcto = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDatVcto deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDatHorCFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDatHorCFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcBoolStr = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcBoolStr deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcStrOrig = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcStrOrig deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcNumStr = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcNumStr deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcInt64 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcInt64 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDe1 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDe1 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcDatBol = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoCampo.{$ENDIF}tcDatBol deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoCampo da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TACBrTagAssinatura
const
  taSempre = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTagAssinatura.{$ENDIF}taSempre deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTagAssinatura da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  taNunca = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTagAssinatura.{$ENDIF}taNunca deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTagAssinatura da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  taSomenteSeAssinada = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTagAssinatura.{$ENDIF}taSomenteSeAssinada deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTagAssinatura da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  taSomenteParaNaoAssinada = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTagAssinatura.{$ENDIF}taSomenteParaNaoAssinada deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTagAssinatura da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TACBrTipoImpressao
const
  tiSemGeracao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoImpressao.{$ENDIF}tiSemGeracao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoImpressao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tiRetrato = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoImpressao.{$ENDIF}tiRetrato deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoImpressao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tiPaisagem = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoImpressao.{$ENDIF}tiPaisagem deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoImpressao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tiSimplificado = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoImpressao.{$ENDIF}tiSimplificado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoImpressao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tiNFCe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoImpressao.{$ENDIF}tiNFCe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoImpressao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tiMsgEletronica = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoImpressao.{$ENDIF}tiMsgEletronica deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoImpressao da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TACBrTipoEmissao
const
  teNormal = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEmissao.{$ENDIF}teNormal deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teContingencia = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEmissao.{$ENDIF}teContingencia deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teSCAN = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEmissao.{$ENDIF}teSCAN deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teDPEC = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEmissao.{$ENDIF}teDPEC deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teFSDA = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEmissao.{$ENDIF}teFSDA deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teSVCAN = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEmissao.{$ENDIF}teSVCAN deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teSVCRS = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEmissao.{$ENDIF}teSVCRS deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teSVCSP = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEmissao.{$ENDIF}teSVCSP deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teOffLine = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEmissao.{$ENDIF}teOffLine deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TACBrTipoAmbiente
const
  taHomologacao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoAmbiente.{$ENDIF}taHomologacao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoAmbiente da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  taProducao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoAmbiente.{$ENDIF}taProducao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoAmbiente da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TACBrProcessoEmissao
const
  peAplicativoContribuinte = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrProcessoEmissao.{$ENDIF}peAplicativoContribuinte deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrProcessoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  peAvulsaFisco = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrProcessoEmissao.{$ENDIF}peAvulsaFisco deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrProcessoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  peAvulsaContribuinte = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrProcessoEmissao.{$ENDIF}peAvulsaContribuinte deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrProcessoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  peContribuinteAplicativoFisco = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrProcessoEmissao.{$ENDIF}peContribuinteAplicativoFisco deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrProcessoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TACBrTipoEvento
const
  teNaoMapeado = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teNaoMapeado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCCe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCCe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancelamento = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancelamento deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teManifDestConfirmacao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teManifDestConfirmacao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teManifDestCiencia = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teManifDestCiencia deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teManifDestDesconhecimento = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teManifDestDesconhecimento deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teManifDestOperNaoRealizada = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teManifDestOperNaoRealizada deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teEncerramento = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teEncerramento deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teEPEC = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teEPEC deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teInclusaoCondutor = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teInclusaoCondutor deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teMultiModal = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teMultiModal deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teRegistroPassagem = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teRegistroPassagem deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teRegistroPassagemBRId = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teRegistroPassagemBRId deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teEPECNFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teEPECNFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teRegistroCTe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teRegistroCTe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teRegistroPassagemNFeCancelado = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teRegistroPassagemNFeCancelado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teRegistroPassagemNFeRFID = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teRegistroPassagemNFeRFID deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCTeCancelado = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCTeCancelado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teMDFeCancelado = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teMDFeCancelado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teVistoriaSuframa = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teVistoriaSuframa deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tePedProrrog1 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}tePedProrrog1 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tePedProrrog2 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}tePedProrrog2 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCanPedProrrog1 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCanPedProrrog1 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCanPedProrrog2 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCanPedProrrog2 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teEventoFiscoPP1 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teEventoFiscoPP1 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teEventoFiscoPP2 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teEventoFiscoPP2 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teEventoFiscoCPP1 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teEventoFiscoCPP1 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teEventoFiscoCPP2 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teEventoFiscoCPP2 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teRegistroPassagemNFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teRegistroPassagemNFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teConfInternalizacao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teConfInternalizacao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCTeAutorizado = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCTeAutorizado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teMDFeAutorizado = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teMDFeAutorizado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tePrestDesacordo = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}tePrestDesacordo deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teGTV = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teGTV deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teMDFeAutorizado2 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teMDFeAutorizado2 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teNaoEmbarque = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teNaoEmbarque deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teMDFeCancelado2 = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teMDFeCancelado2 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teMDFeAutorizadoComCTe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teMDFeAutorizadoComCTe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teRegPasNfeProMDFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teRegPasNfeProMDFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teRegPasNfeProMDFeCte = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teRegPasNfeProMDFeCte deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teRegPasAutMDFeComCte = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teRegPasAutMDFeComCte deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancelamentoMDFeAutComCTe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancelamentoMDFeAutComCTe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teAverbacaoExportacao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teAverbacaoExportacao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teAutCteComplementar = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teAutCteComplementar deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancCteComplementar = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancCteComplementar deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCTeSubstituicao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCTeSubstituicao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCTeAnulacao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCTeAnulacao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teLiberacaoEPEC = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teLiberacaoEPEC deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teLiberacaoPrazoCanc = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teLiberacaoPrazoCanc deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teAutorizadoRedespacho = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teAutorizadoRedespacho deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teautorizadoRedespIntermed = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teautorizadoRedespIntermed deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teAutorizadoSubcontratacao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teAutorizadoSubcontratacao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teautorizadoServMultimodal = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teautorizadoServMultimodal deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancSubst = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancSubst deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teAlteracaoPoltrona = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teAlteracaoPoltrona deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teComprEntrega = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teComprEntrega deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancComprEntrega = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancComprEntrega deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teInclusaoDFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teInclusaoDFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teAutorizadoSubstituicao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teAutorizadoSubstituicao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teAutorizadoAjuste = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teAutorizadoAjuste deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teLiberacaoPrazoCancelado = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teLiberacaoPrazoCancelado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tePagamentoOperacao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}tePagamentoOperacao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teExcessoBagagem = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teExcessoBagagem deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teEncerramentoFisco = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teEncerramentoFisco deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teComprEntregaNFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teComprEntregaNFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancComprEntregaNFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancComprEntregaNFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teAtorInteressadoNFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teAtorInteressadoNFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teComprEntregaCTe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teComprEntregaCTe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancComprEntregaCTe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancComprEntregaCTe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teConfirmaServMDFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teConfirmaServMDFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teAlteracaoPagtoServMDFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teAlteracaoPagtoServMDFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancPrestDesacordo = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancPrestDesacordo deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teInsucessoEntregaCTe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teInsucessoEntregaCTe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancInsucessoEntregaCTe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancInsucessoEntregaCTe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teInsucessoEntregaNFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teInsucessoEntregaNFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancInsucessoEntregaNFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancInsucessoEntregaNFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teConcFinanceira = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teConcFinanceira deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teCancConcFinanceira = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancConcFinanceira deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teRegistroPassagemMDFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teRegistroPassagemMDFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  // Reforma Tributária
  teCancGenerico = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teCancGenerico deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tePagIntegLibCredPresAdq = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}tePagIntegLibCredPresAdq deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teImporALCZFM = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teImporALCZFM deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tePerecPerdaRouboFurtoTranspContratFornec = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}tePerecPerdaRouboFurtoTranspContratFornec deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teFornecNaoRealizPagAntec = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teFornecNaoRealizPagAntec deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teSolicApropCredPres = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teSolicApropCredPres deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teDestItemConsPessoal = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teDestItemConsPessoal deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tePerecPerdaRouboFurtoTranspContratAqu = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}tePerecPerdaRouboFurtoTranspContratAqu deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teAceiteDebitoApuracaoNotaCredito = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teAceiteDebitoApuracaoNotaCredito deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teImobilizacaoItem = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teImobilizacaoItem deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teSolicApropCredCombustivel = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teSolicApropCredCombustivel deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teSolicApropCredBensServicos = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teSolicApropCredBensServicos deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teManifPedTransfCredIBSSucessao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teManifPedTransfCredIBSSucessao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  teManifPedTransfCredCBSSucessao = {$IFDEF SUPPORTS_SCOPEDENUMS}TACBrTipoEvento.{$ENDIF}teManifPedTransfCredCBSSucessao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TACBrTipoEvento da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TModal
const
  mdRodoviario = {$IFDEF SUPPORTS_SCOPEDENUMS}TModal.{$ENDIF}mdRodoviario deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TModal da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mdAereo = {$IFDEF SUPPORTS_SCOPEDENUMS}TModal.{$ENDIF}mdAereo deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TModal da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mdAquaviario = {$IFDEF SUPPORTS_SCOPEDENUMS}TModal.{$ENDIF}mdAquaviario deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TModal da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mdFerroviario = {$IFDEF SUPPORTS_SCOPEDENUMS}TModal.{$ENDIF}mdFerroviario deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TModal da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mdDutoviario = {$IFDEF SUPPORTS_SCOPEDENUMS}TModal.{$ENDIF}mdDutoviario deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TModal da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mdMultimodal = {$IFDEF SUPPORTS_SCOPEDENUMS}TModal.{$ENDIF}mdMultimodal deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TModal da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TIndicador
const
  tiSim = {$IFDEF SUPPORTS_SCOPEDENUMS}TIndicador.{$ENDIF}tiSim deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TIndicador da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tiNao = {$IFDEF SUPPORTS_SCOPEDENUMS}TIndicador.{$ENDIF}tiNao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TIndicador da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TIndicadorEx
const
  tieNenhum = {$IFDEF SUPPORTS_SCOPEDENUMS}TIndicadorEx.{$ENDIF}tieNenhum deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TIndicadorEx da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tieSim = {$IFDEF SUPPORTS_SCOPEDENUMS}TIndicadorEx.{$ENDIF}tieSim deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TIndicadorEx da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tieNao = {$IFDEF SUPPORTS_SCOPEDENUMS}TIndicadorEx.{$ENDIF}tieNao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TIndicadorEx da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TSituacaoDFe
const
  snAutorizado = {$IFDEF SUPPORTS_SCOPEDENUMS}TSituacaoDFe.{$ENDIF}snAutorizado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSituacaoDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  snDenegado = {$IFDEF SUPPORTS_SCOPEDENUMS}TSituacaoDFe.{$ENDIF}snDenegado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSituacaoDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  snCancelado = {$IFDEF SUPPORTS_SCOPEDENUMS}TSituacaoDFe.{$ENDIF}snCancelado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSituacaoDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  snEncerrado = {$IFDEF SUPPORTS_SCOPEDENUMS}TSituacaoDFe.{$ENDIF}snEncerrado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSituacaoDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TTipoNFe
const
  tnEntrada = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoNFe.{$ENDIF}tnEntrada deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoNFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tnSaida = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoNFe.{$ENDIF}tnSaida deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoNFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TSchemaDFe
const
  schresNFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schresNFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schresEvento = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schresEvento deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocNFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocNFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocEventoNFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocEventoNFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schresCTe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schresCTe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocCTe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocCTe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocCTeOS = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocCTeOS deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocEventoCTe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocEventoCTe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schresMDFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schresMDFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocMDFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocMDFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocEventoMDFe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocEventoMDFe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schresBPe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schresBPe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocBPe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocBPe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocEventoBPe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocEventoBPe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocGTVe = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocGTVe deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  schprocCTeSimp = {$IFDEF SUPPORTS_SCOPEDENUMS}TSchemaDFe.{$ENDIF}schprocCTeSimp deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TOrigemMercadoria
const
  oeNacional = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeNacional deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  oeEstrangeiraImportacaoDireta = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeEstrangeiraImportacaoDireta deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  oeEstrangeiraAdquiridaBrasil = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeEstrangeiraAdquiridaBrasil deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  oeNacionalConteudoImportacaoSuperior40 = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeNacionalConteudoImportacaoSuperior40 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  oeNacionalProcessosBasicos = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeNacionalProcessosBasicos deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  oeNacionalConteudoImportacaoInferiorIgual40 = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeNacionalConteudoImportacaoInferiorIgual40 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  oeEstrangeiraImportacaoDiretaSemSimilar = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeEstrangeiraImportacaoDiretaSemSimilar deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  oeEstrangeiraAdquiridaBrasilSemSimilar = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeEstrangeiraAdquiridaBrasilSemSimilar deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  oeNacionalConteudoImportacaoSuperior70 = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeNacionalConteudoImportacaoSuperior70 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  oeReservadoParaUsoFuturo = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeReservadoParaUsoFuturo deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  oeVazio = {$IFDEF SUPPORTS_SCOPEDENUMS}TOrigemMercadoria.{$ENDIF}oeVazio deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TOrigemMercadoria da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TCSTIcms
const
  cst00 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst00 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst10 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst10 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst20 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst20 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst30 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst30 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst40 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst40 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst41 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst41 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst45 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst45 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst50 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst50 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst51 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst51 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst60 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst60 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst70 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst70 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst80 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst80 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst81 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst81 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst90 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst90 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cstPart10 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cstPart10 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cstPart90 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cstPart90 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cstRep41 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cstRep41 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cstVazio = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cstVazio deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cstICMSOutraUF = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cstICMSOutraUF deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cstICMSSN = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cstICMSSN deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cstRep60 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cstRep60 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst02 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst02 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst15 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst15 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst53 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst53 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst61 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst61 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst01 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst01 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst12 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst12 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst13 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst13 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst14 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst14 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst21 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst21 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst72 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst72 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst73 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst73 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cst74 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTIcms.{$ENDIF}cst74 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TCSOSNIcms
const
  csosnVazio = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosnVazio deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  csosn101 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosn101 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  csosn102 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosn102 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  csosn103 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosn103 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  csosn201 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosn201 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  csosn202 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosn202 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  csosn203 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosn203 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  csosn300 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosn300 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  csosn400 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosn400 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  csosn500 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosn500 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  csosn900 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSOSNIcms.{$ENDIF}csosn900 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TCSTPis
const
  pis01 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis01 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis02 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis02 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis03 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis03 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis04 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis04 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis05 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis05 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis06 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis06 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis07 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis07 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis08 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis08 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis09 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis09 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis49 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis49 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis50 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis50 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis51 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis51 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis52 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis52 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis53 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis53 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis54 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis54 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis55 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis55 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis56 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis56 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis60 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis60 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis61 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis61 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis62 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis62 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis63 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis63 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis64 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis64 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis65 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis65 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis66 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis66 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis67 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis67 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis70 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis70 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis71 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis71 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis72 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis72 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis73 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis73 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis74 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis74 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis75 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis75 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis98 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis98 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  pis99 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTPis.{$ENDIF}pis99 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTPis da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TCSTCofins
const
  cof01 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof01 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof02 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof02 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof03 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof03 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof04 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof04 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof05 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof05 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof06 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof06 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof07 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof07 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof08 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof08 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof09 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof09 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof49 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof49 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof50 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof50 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof51 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof51 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof52 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof52 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof53 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof53 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof54 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof54 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof55 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof55 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof56 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof56 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof60 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof60 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof61 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof61 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof62 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof62 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof63 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof63 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof64 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof64 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof65 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof65 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof66 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof66 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof67 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof67 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof70 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof70 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof71 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof71 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof72 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof72 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof73 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof73 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof74 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof74 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof75 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof75 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof98 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof98 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  cof99 = {$IFDEF SUPPORTS_SCOPEDENUMS}TCSTCofins.{$ENDIF}cof99 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCSTCofins da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TTipoRodado
const
  trNaoAplicavel = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoRodado.{$ENDIF}trNaoAplicavel deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoRodado da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  trTruck = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoRodado.{$ENDIF}trTruck deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoRodado da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  trToco = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoRodado.{$ENDIF}trToco deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoRodado da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  trCavaloMecanico = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoRodado.{$ENDIF}trCavaloMecanico deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoRodado da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  trVAN = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoRodado.{$ENDIF}trVAN deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoRodado da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  trUtilitario = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoRodado.{$ENDIF}trUtilitario deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoRodado da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  trOutros = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoRodado.{$ENDIF}trOutros deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoRodado da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TTipoCarroceria
const
  tcNaoAplicavel = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoCarroceria.{$ENDIF}tcNaoAplicavel deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoCarroceria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcAberta = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoCarroceria.{$ENDIF}tcAberta deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoCarroceria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcFechada = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoCarroceria.{$ENDIF}tcFechada deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoCarroceria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcGraneleira = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoCarroceria.{$ENDIF}tcGraneleira deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoCarroceria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcPortaContainer = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoCarroceria.{$ENDIF}tcPortaContainer deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoCarroceria da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tcSider = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoCarroceria.{$ENDIF}tcSider deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoCarroceria da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TtpIntegra
const
  tiNaoInformado = {$IFDEF SUPPORTS_SCOPEDENUMS}TtpIntegra.{$ENDIF}tiNaoInformado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TtpIntegra da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tiPagIntegrado = {$IFDEF SUPPORTS_SCOPEDENUMS}TtpIntegra.{$ENDIF}tiPagIntegrado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TtpIntegra da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tiPagNaoIntegrado = {$IFDEF SUPPORTS_SCOPEDENUMS}TtpIntegra.{$ENDIF}tiPagNaoIntegrado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TtpIntegra da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TUnidTransp
const
  utRodoTracao = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidTransp.{$ENDIF}utRodoTracao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidTransp da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  utRodoReboque = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidTransp.{$ENDIF}utRodoReboque deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidTransp da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  utNavio = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidTransp.{$ENDIF}utNavio deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidTransp da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  utBalsa = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidTransp.{$ENDIF}utBalsa deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidTransp da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  utAeronave = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidTransp.{$ENDIF}utAeronave deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidTransp da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  utVagao = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidTransp.{$ENDIF}utVagao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidTransp da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  utOutros = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidTransp.{$ENDIF}utOutros deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidTransp da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TUnidCarga
const
  ucContainer = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidCarga.{$ENDIF}ucContainer deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidCarga da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  ucULD = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidCarga.{$ENDIF}ucULD deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidCarga da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  ucPallet = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidCarga.{$ENDIF}ucPallet deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidCarga da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  ucOutros = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidCarga.{$ENDIF}ucOutros deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidCarga da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TtpProp
const
  tpTACAgregado = {$IFDEF SUPPORTS_SCOPEDENUMS}TtpProp.{$ENDIF}tpTACAgregado deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TtpProp da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tpTACIndependente = {$IFDEF SUPPORTS_SCOPEDENUMS}TtpProp.{$ENDIF}tpTACIndependente deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TtpProp da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tpOutros = {$IFDEF SUPPORTS_SCOPEDENUMS}TtpProp.{$ENDIF}tpOutros deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TtpProp da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TUnidMed
const
  uM3 = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidMed.{$ENDIF}uM3 deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidMed da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  uKG = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidMed.{$ENDIF}uKG deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidMed da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  uTON = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidMed.{$ENDIF}uTON deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidMed da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  uUNIDADE = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidMed.{$ENDIF}uUNIDADE deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidMed da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  uLITROS = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidMed.{$ENDIF}uLITROS deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidMed da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  uMMBTU = {$IFDEF SUPPORTS_SCOPEDENUMS}TUnidMed.{$ENDIF}uMMBTU deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TUnidMed da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TTipoNavegacao
const
  tnInterior = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoNavegacao.{$ENDIF}tnInterior deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoNavegacao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  tnCabotagem = {$IFDEF SUPPORTS_SCOPEDENUMS}TTipoNavegacao.{$ENDIF}tnCabotagem deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TTipoNavegacao da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TindIEDest
const
  inContribuinte = {$IFDEF SUPPORTS_SCOPEDENUMS}TindIEDest.{$ENDIF}inContribuinte deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TindIEDest da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  inIsento = {$IFDEF SUPPORTS_SCOPEDENUMS}TindIEDest.{$ENDIF}inIsento deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TindIEDest da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  inNaoContribuinte = {$IFDEF SUPPORTS_SCOPEDENUMS}TindIEDest.{$ENDIF}inNaoContribuinte deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TindIEDest da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TRegTribISSQN
const
  RTISSMicroempresaMunicipal = {$IFDEF SUPPORTS_SCOPEDENUMS}TRegTribISSQN.{$ENDIF}RTISSMicroempresaMunicipal deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TRegTribISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  RTISSEstimativa = {$IFDEF SUPPORTS_SCOPEDENUMS}TRegTribISSQN.{$ENDIF}RTISSEstimativa deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TRegTribISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  RTISSSociedadeProfissionais = {$IFDEF SUPPORTS_SCOPEDENUMS}TRegTribISSQN.{$ENDIF}RTISSSociedadeProfissionais deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TRegTribISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  RTISSCooperativa = {$IFDEF SUPPORTS_SCOPEDENUMS}TRegTribISSQN.{$ENDIF}RTISSCooperativa deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TRegTribISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  RTISSMEI = {$IFDEF SUPPORTS_SCOPEDENUMS}TRegTribISSQN.{$ENDIF}RTISSMEI deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TRegTribISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  RTISSMEEPP = {$IFDEF SUPPORTS_SCOPEDENUMS}TRegTribISSQN.{$ENDIF}RTISSMEEPP deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TRegTribISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  RTISSNenhum = {$IFDEF SUPPORTS_SCOPEDENUMS}TRegTribISSQN.{$ENDIF}RTISSNenhum deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TRegTribISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TindIncentivo
const
  iiSim = {$IFDEF SUPPORTS_SCOPEDENUMS}TindIncentivo.{$ENDIF}iiSim deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TindIncentivo da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  iiNao = {$IFDEF SUPPORTS_SCOPEDENUMS}TindIncentivo.{$ENDIF}iiNao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TindIncentivo da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TRegTrib
const
  RTSimplesNacional = {$IFDEF SUPPORTS_SCOPEDENUMS}TRegTrib.{$ENDIF}RTSimplesNacional deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TRegTrib da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  RTRegimeNormal = {$IFDEF SUPPORTS_SCOPEDENUMS}TRegTrib.{$ENDIF}RTRegimeNormal deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TRegTrib da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TindRatISSQN
const
  irSim = {$IFDEF SUPPORTS_SCOPEDENUMS}TindRatISSQN.{$ENDIF}irSim deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TindRatISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  irNao = {$IFDEF SUPPORTS_SCOPEDENUMS}TindRatISSQN.{$ENDIF}irNao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TindRatISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TindRegra
const
  irArredondamento = {$IFDEF SUPPORTS_SCOPEDENUMS}TindRegra.{$ENDIF}irArredondamento deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TindRegra da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  irTruncamento = {$IFDEF SUPPORTS_SCOPEDENUMS}TindRegra.{$ENDIF}irTruncamento deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TindRegra da Unit ACBrDFe.Conversao.pas' {$ENDIF};

  // Enumerados do TCodigoMP
const
  mpDinheiro = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpDinheiro deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpCheque = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpCheque deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpCartaodeCredito = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpCartaodeCredito deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpCartaodeDebito = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpCartaodeDebito deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpCreditoLoja = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpCreditoLoja deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpValeAlimentacao = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpValeAlimentacao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpValeRefeicao = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpValeRefeicao deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpValePresente = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpValePresente deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpValeCombustivel = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpValeCombustivel deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpBoletoBancario = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpBoletoBancario deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpDepositoBancario = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpDepositoBancario deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpPagamentoInstantaneo = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpPagamentoInstantaneo deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpTransfBancario = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpTransfBancario deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpProgramaFidelidade = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpProgramaFidelidade deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpSemPagamento = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpSemPagamento deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
  mpOutros = {$IFDEF SUPPORTS_SCOPEDENUMS}TCodigoMP.{$ENDIF}mpOutros deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o tipo TCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};

type
  TStrToTpEvento = function (out ok: boolean; const s: String): TpcnTpEvento;

  TStrToTpEventoDFe = record
    StrToTpEventoMethod: TStrToTpEvento;
    NomeDFe: String;
  end;

const
  TpcnTpEventoString : array[0..78] of String =('-99999', '110110', '110111',
                                                '210200', '210210', '210220',
                                                '210240', '110112', '110113',
                                                '110114', '110160', '310620',
                                                '510620', '110140', '610600',
                                                '610501', '610550', '610601',
                                                '610611', '990900', '111500',
                                                '111501', '111502', '111503',
                                                '411500', '411501', '411502',
                                                '411503', '610500', '990910',
                                                '000000', '610610', '610110',
                                                '110170', '310610', '110115',
                                                '310611', '610614', '610510',
                                                '610514', '610554', '610615',
                                                '790700', '240130', '240131',
                                                '240140', '240150', '240160',
                                                '240170', '440130', '440140',
                                                '440150', '440160', '110112',
                                                '110116', '110180', '110181',
                                                '110115', '240140', '240150',
                                                '240170', '110116', '110117',
                                                '310112', '110130', '110131',
                                                '110150', '610130', '610131',
                                                '110117', '110118', '610111',
                                                '110190', '110191', '110192',
                                                '110193', '110750', '110751',
                                                '510630');

  DFeUF: array[0..26] of String =
  ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA',
   'PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO');

  DFeUFCodigo: array[0..26] of Integer =
  (12,27,16,13,29,23,53,32,52,21,51,50,31,15,25,41,26,22,33,24,43,11,14,42,35,28,17);

  Msg_ICMS_123_2006 = 'ICMS a ser recolhido conforme LC 123/2006 - Simples Nacional' ;

  LineBreak = #13#10;

function StrToHex(const S: String): String;
function StrToEnumerado(out ok: boolean; const s: string; const AString: array of string;
  const AEnumerados: array of variant): variant;
function EnumeradoToStr(const t: variant; const AString:
  array of string; const AEnumerados: array of variant): variant;

function StrToEnumerado2(out ok: boolean;  const s: string; Const AString: array of string ): variant;
function EnumeradoToStr2(const t: variant; const AString: array of string ): variant;

function UFtoCUF(const UF: String): Integer; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método UFparaCodigoUF da Unit ACBrUtil.Base.pas' {$ENDIF};
function CUFtoUF(CUF: Integer): String; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CodigoUFparaUF da Unit ACBrUtil.Base.pas' {$ENDIF};

function TpModalToStr(const t: TpcteModal): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TpModalToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function TpModalToStrText(const t: TpcteModal): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TpModalToStrText da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTpModal(out ok: boolean; const s: string): TpcteModal; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTpModal da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function TpImpToStr(const t: TpcnTipoImpressao): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TpImpToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTpImp(out ok: boolean; const s: string): TpcnTipoImpressao; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTpImp da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function TpEmisToStr(const t: TpcnTipoEmissao): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TipoEmissaoToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTpEmis(out ok: boolean; const s: string): TpcnTipoEmissao; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTipoEmissao da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function TpAmbToStr(const t: TpcnTipoAmbiente): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TipoAmbienteToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTpAmb(out ok: boolean; const s: string): TpcnTipoAmbiente; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTipoAmbiente da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function procEmiToStr(const t: TpcnProcessoEmissao): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método procEmiToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToprocEmi(out ok: boolean; const s: string): TpcnProcessoEmissao; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToprocEmi da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function OrigToStr(const t: TpcnOrigemMercadoria): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método OrigToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToOrig(out ok: boolean; const s: string): TpcnOrigemMercadoria; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToOrig da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function OrigToStrTagPosText(const t: TpcnOrigemMercadoria): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método OrigToStrTagPosText da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function CSTICMSToStr(const t: TpcnCSTIcms): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSTICMSToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToCSTICMS(out ok: boolean; const s: string): TpcnCSTIcms; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToCSTICMS da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function CSTICMSToStrTagPos(const t: TpcnCSTIcms): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSTICMSToStrTagPos da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function CSTICMSToStrTagPosText(const t: TpcnCSTIcms): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSTICMSToStrTagPosText da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function CSOSNIcmsToStr(const t: TpcnCSOSNIcms): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSOSNIcmsToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToCSOSNIcms(out ok: boolean; const s: string): TpcnCSOSNIcms; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToCSOSNIcms da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function CSOSNToStrTagPos(const t: TpcnCSOSNIcms): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSOSNToStrTagPos da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function CSOSNToStrID(const t: TpcnCSOSNIcms): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSOSNToStrID da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function CSOSNToStrTagPosText(const t: TpcnCSOSNIcms): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSOSNToStrTagPosText da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function CSTPISToStr(const t: TpcnCstPIS): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSTPISToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToCSTPIS(out ok: boolean; const s: string): TpcnCstPIS; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToCSTPIS da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function CSTPISToStrTagPosText(const t: TpcnCstPis): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSTPISToStrTagPosText da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function CSTCOFINSToStr(const t: TpcnCstCOFINS): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSTCOFINSToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToCSTCOFINS(out ok: boolean; const s: string): TpcnCstCOFINS; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToCSTCOFINS da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function CSTCOFINSToStrTagPosText(const t: TpcnCstCofins): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CSTCOFINSToStrTagPosText da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function TpRodadoToStr(const t: TpcteTipoRodado): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TpRodadoToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTpRodado(out ok: boolean; const s: string): TpcteTipoRodado; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTpRodado da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function TpCarroceriaToStr(const t: TpcteTipoCarroceria): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TpCarroceriaToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTpCarroceria(out ok: boolean; const s: string): TpcteTipoCarroceria; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTpCarroceria da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function StrToTpEvento_Old(out ok: boolean; const s: string): TpcnTpEvento;
function TpEventoToStr(const t: TpcnTpEvento): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TpEventoToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function TpEventoToDescStr(const t: TpcnTpEvento): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TpEventoToDescStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function RegTribToStr(const t: TpcnRegTrib ): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método RegTribToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToRegTrib(out ok: boolean; const s: string): TpcnRegTrib; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToRegTrib da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function RegTribISSQNToStr(const t: TpcnRegTribISSQN ): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método RegTribISSQNToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToRegTribISSQN(out ok: boolean; const s: string): TpcnRegTribISSQN ; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToRegTribISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function indRatISSQNToStr(const t: TpcnindRatISSQN ): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método indRatISSQNToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToindRatISSQN(out ok: boolean; const s: string): TpcnindRatISSQN ; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToindRatISSQN da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function indRegraToStr(const t: TpcnindRegra ): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método indRegraToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToindRegra(out ok: boolean; const s: string): TpcnindRegra ; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToindRegra da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function CodigoMPToStr(const t: TpcnCodigoMP ): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CodigoMPToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToCodigoMP(out ok: boolean; const s: string): TpcnCodigoMP ; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToCodigoMP da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function CodigoMPToDescricao(const t: TpcnCodigoMP ): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método CodigoMPToDescricao da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function UnidTranspToStr(const t: TpcnUnidTransp):string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método UnidTranspToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToUnidTransp(out ok: boolean; const s: string): TpcnUnidTransp; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToUnidTransp da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function UnidCargaToStr(const t: TpcnUnidCarga):string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método UnidCargaToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToUnidCarga(out ok: boolean; const s: string):TpcnUnidCarga; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToUnidCarga da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function indIEDestToStr(const t: TpcnindIEDest ): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método indIEDestToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToindIEDest(out ok: boolean; const s: string): TpcnindIEDest; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToindIEDest da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function indIncentivoToStr(const t: TpcnindIncentivo ): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método indIncentivoToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToindIncentivo(out ok: boolean; const s: string): TpcnindIncentivo; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToindIncentivo da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function TpPropToStr(const t: TpcteProp): String; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TpPropToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTpProp(out ok: boolean; const s: String ): TpcteProp; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTpProp da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function UnidMedToStr(const t: TUnidMed): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método UnidMedToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToUnidMed(out ok: boolean; const s: String ): TUnidMed; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToUnidMed da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function UnidMedToDescricaoStr(const t: TUnidMed): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método UnidMedToDescricaoStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function SituacaoDFeToStr(const t: TSituacaoDFe): String; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método SituacaoDFeToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToSituacaoDFe(out ok: Boolean; const s: String): TSituacaoDFe; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToSituacaoDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function TpNavegacaoToStr(const t: TTipoNavegacao): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TpNavegacaoToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTpNavegacao(out ok: boolean; const s: string): TTipoNavegacao; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTpNavegacao da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function tpIntegraToStr(const t: TtpIntegra): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método tpIntegraToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrTotpIntegra(out ok: boolean; const s: string): TtpIntegra; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrTotpIntegra da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function TIndicadorToStr(const t: TIndicador): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TIndicadorToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTIndicador(out ok: boolean; const s: string): TIndicador; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTIndicador da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function TIndicadorExToStr(const t: TIndicadorEx): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método TIndicadorExToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTIndicadorEx(out ok: boolean; const s: string): TIndicadorEx; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTIndicadorEx da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function tpNFToStr(const t: TpcnTipoNFe): String; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método tpNFToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToTpNF(out ok: Boolean; const s: String): TpcnTipoNFe; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTpNF da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function SchemaDFeToStr(const t: TSchemaDFe): String; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método SchemaDFeToStr da Unit ACBrDFe.Conversao.pas' {$ENDIF};
function StrToSchemaDFe(const s: String): TSchemaDFe; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToSchemaDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function indIncentivoToStrTagPosText(const t: TpcnindIncentivo ): string; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método indIncentivoToStrTagPosText da Unit ACBrDFe.Conversao.pas' {$ENDIF};

function StrToTpEventoDFe(out ok: boolean; const s, aDFe: string): TpcnTpEvento; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método StrToTpEventoDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};

procedure RegisterStrToTpEventoDFe(AConvertProcedure: TStrToTpEvento; ADFe: String); deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o método RegisterStrToTpEventoDFe da Unit ACBrDFe.Conversao.pas' {$ENDIF};

var
  StrToTpEventoDFeList: array of TStrToTpEventoDFe;

implementation

uses
  typinfo;

function StrToHex(const S: String): String;
var I: Integer;
begin
  Result:= '';
  for I := 1 to length (S) do
    Result:= Result+IntToHex(ord(S[i]),2);
end;

function StrToEnumerado(out ok: boolean; const s: string; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := -1;
  for i := Low(AString) to High(AString) do
    if AnsiSameText(s, AString[i]) then
      result := AEnumerados[i];
  ok := result <> -1;
  if not ok then
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

function UFtoCUF(const UF: String): Integer;
var
  i: Integer;
begin
  Result := -1 ;
  for i:= Low(DFeUF) to High(DFeUF) do
  begin
    if DFeUF[I] = UF then
    begin
      Result := DFeUFCodigo[I];
      exit;
    end;
  end;
end;

function CUFtoUF(CUF: Integer): String;
var
  i: Integer;
begin
  Result := '' ;
  for i:= Low(DFeUFCodigo) to High(DFeUFCodigo) do
  begin
    if DFeUFCodigo[I] = CUF then
    begin
      Result := DFeUF[I];
      exit;
    end;
  end;
end;

// B21 - Formato de Impressão do DANFE *****************************************
function TpImpToStr(const t: TpcnTipoImpressao): string;
begin
  result := EnumeradoToStr(t, ['0', '1', '2', '3', '4', '5'],
                              [tiSemGeracao, tiRetrato, tiPaisagem, tiSimplificado,
                               tiNFCe, tiMsgEletronica]);
end;

function StrToTpImp(out ok: boolean; const s: string): TpcnTipoImpressao;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2', '3', '4', '5'],
                                  [tiSemGeracao, tiRetrato, tiPaisagem, tiSimplificado,
                                   tiNFCe, tiMsgEletronica]);
end;

// B22 - Forma de Emissão da NF-e **********************************************
function TpEmisToStr(const t: TpcnTipoEmissao): string;
begin
  result := EnumeradoToStr(t, ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
                              [teNormal, teContingencia, teSCAN, teDPEC, teFSDA, teSVCAN, teSVCRS, teSVCSP, teOffLine]);
end;

function StrToTpEmis(out ok: boolean; const s: string): TpcnTipoEmissao;
begin
  result := StrToEnumerado(ok, s, ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
                                  [teNormal, teContingencia, teSCAN, teDPEC, teFSDA, teSVCAN, teSVCRS, teSVCSP, teOffLine]);
end;

// B24 - Identificação do Ambiente *********************************************
function TpAmbToStr(const t: TpcnTipoAmbiente): string;
begin
  result := EnumeradoToStr(t, ['1', '2'], [taProducao, taHomologacao]);
end;

function StrToTpAmb(out ok: boolean; const s: string): TpcnTipoAmbiente;
begin
  result := StrToEnumerado(ok, s, ['1', '2'], [taProducao, taHomologacao]);
end;

// B26 - Processo de emissão da NF-e *******************************************
function procEmiToStr(const t: TpcnProcessoEmissao): string;
begin
  // 0 - emissão de NF-e com aplicativo do contribuinte;
  // 1 - emissão de NF-e avulsa pelo Fisco;
  // 2 - emissão de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site do Fisco;
  // 3 - emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
  result := EnumeradoToStr(t, ['0', '1', '2', '3'], [peAplicativoContribuinte, peAvulsaFisco, peAvulsaContribuinte, peContribuinteAplicativoFisco]);
end;

function StrToprocEmi(out ok: boolean; const s: string): TpcnProcessoEmissao;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2', '3'], [peAplicativoContribuinte, peAvulsaFisco, peAvulsaContribuinte, peContribuinteAplicativoFisco]);
end;

// N11 - Origem da mercadoria **************************************************
function OrigToStr(const t: TpcnOrigemMercadoria): string;
begin
  result := EnumeradoToStr(t, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ''],
     [oeNacional, oeEstrangeiraImportacaoDireta, oeEstrangeiraAdquiridaBrasil,
      oeNacionalConteudoImportacaoSuperior40, oeNacionalProcessosBasicos,
      oeNacionalConteudoImportacaoInferiorIgual40,
      oeEstrangeiraImportacaoDiretaSemSimilar, oeEstrangeiraAdquiridaBrasilSemSimilar,
      oeNacionalConteudoImportacaoSuperior70, oeReservadoParaUsoFuturo,
      oeVazio]);
end;

function StrToOrig(out ok: boolean; const s: string): TpcnOrigemMercadoria;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ''],
     [oeNacional, oeEstrangeiraImportacaoDireta, oeEstrangeiraAdquiridaBrasil,
      oeNacionalConteudoImportacaoSuperior40, oeNacionalProcessosBasicos,
      oeNacionalConteudoImportacaoInferiorIgual40,
      oeEstrangeiraImportacaoDiretaSemSimilar, oeEstrangeiraAdquiridaBrasilSemSimilar,
      oeNacionalConteudoImportacaoSuperior70, oeReservadoParaUsoFuturo,
      oeVazio]);
end;

function CSTPISToStrTagPosText(const t: TpcnCstPis): string;
begin
     result := EnumeradoToStr(t,
          ['01 - Operação Tributável com Alíquota Básica',
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
          '99 - Outras Operações'],
          [pis01, pis02, pis03, pis04, pis05, pis06, pis07, pis08, pis09, pis49, pis50, pis51, pis52, pis53, pis54, pis55, pis56, pis60, pis61, pis62, pis63, pis64, pis65, pis66, pis67, pis70, pis71, pis72, pis73, pis74, pis75, pis98, pis99]);
end;

function CSTCOFINSToStrTagPosText(const t: TpcnCstCofins): string;
begin
     result := EnumeradoToStr(t,
          ['01 - Operação Tributável com Alíquota Básica',
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
          '99 - Outras Operações'],
          [cof01, cof02, cof03, cof04, cof05, cof06, cof07, cof08, cof09, cof49, cof50, cof51, cof52, cof53, cof54, cof55, cof56, cof60, cof61, cof62, cof63, cof64, cof65, cof66, cof67, cof70, cof71, cof72, cof73, cof74, cof75, cof98, cof99]);
end;

function OrigToStrTagPosText(const t: TpcnOrigemMercadoria): string;
begin
  result := EnumeradoToStr(t,
   ['0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8. ',
    '1 - Estrangeira - Importação direta, exceto a indicada no código 6.',
    '2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7.',
    '3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% e inferior ou igual a 70%.',
    '4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam as legislações citadas nos Ajustes.',
    '5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40%. ',
    '6 - Estrangeira - Importação direta, sem similar nacional, constante em lista da CAMEX e gás natural. ',
    '7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e gás natural.',
    '8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%.'],
    [oeNacional, oeEstrangeiraImportacaoDireta, oeEstrangeiraAdquiridaBrasil,
      oeNacionalConteudoImportacaoSuperior40, oeNacionalProcessosBasicos,
      oeNacionalConteudoImportacaoInferiorIgual40,
      oeEstrangeiraImportacaoDiretaSemSimilar, oeEstrangeiraAdquiridaBrasilSemSimilar,
      oeNacionalConteudoImportacaoSuperior70]);
end;

//CST CSON ICMS ***********************************************************
function CSOSNIcmsToStr(const t: TpcnCSOSNIcms): string;
begin
  result := EnumeradoToStr(t, ['','101', '102', '103', '201', '202', '203', '300', '400', '500','900'],
    [csosnVazio,csosn101, csosn102, csosn103, csosn201, csosn202, csosn203, csosn300, csosn400, csosn500,csosn900]);
end;

function StrToCSOSNIcms(out ok: boolean; const s: string): TpcnCSOSNIcms;
begin
  result := StrToEnumerado(ok, s, [ '','101', '102', '103', '201', '202', '203', '300', '400', '500','900'],
    [csosnVazio, csosn101, csosn102, csosn103, csosn201, csosn202, csosn203, csosn300, csosn400, csosn500,csosn900]);
end;

function CSOSNToStrTagPos(const t: TpcnCSOSNIcms): string;
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

function CSOSNToStrID(const t: TpcnCSOSNIcms): string;
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

function CSOSNToStrTagPosText(const t: TpcnCSOSNIcms): string;
begin
  result := EnumeradoToStr(t,
   ['VAZIO',
    '101 - Tributada pelo Simples Nacional com permissão de crédito',
    '102 - Tributada pelo Simples Nacional sem permissão de crédito ',
    '103 - Isenção do ICMS no Simples Nacional para faixa de receita bruta',
    '201 - Tributada pelo Simples Nacional com permissão de crédito e com cobrança do ICMS por substituição tributária',
    '202 - Tributada pelo Simples Nacional sem permissão de crédito e com cobrança do ICMS por substituição tributária',
    '203 - Isenção do ICMS no Simples Nacional para faixa de receita bruta e com cobrança do ICMS por substituição tributária',
    '300 - Imune',
    '400 - Não tributada pelo Simples Nacional',
    '500 - ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação',
    '900 - Outros'],
    [csosnVazio, csosn101, csosn102, csosn103, csosn201, csosn202, csosn203, csosn300, csosn400, csosn500,csosn900]);
end;

//***************************************************************************

// CST ICMS ********************************************************************
function CSTICMSToStr(const t: TpcnCSTIcms): string;
begin
  // ID -> N02  - Tributada integralmente
  // ID -> N03  - Tributada e com cobrança do ICMS por substituição tributária
  // ID -> N04  - Com redução de base de cálculo
  // ID -> N05  - Isenta ou não tributada e com cobrança do ICMS por substituição tributária
  // ID -> N06  - Isenta
  // ID -> N06  - Não tributada
  // ID -> N06  - Suspensão
  // ID -> N07  - Diferimento A exigência do preenchimento das informações do ICMS diferido fica à critério de cada UF.
  // ID -> N08  - ICMS cobrado anteriormente por substituição
  // ID -> N09  - Com redução de base de cálculo e cobrança do ICMS por substituição tributária
  // ID -> N10  - ICMS pagto atribuído ao tomador ou ao terceiro previsto na legislação p/ ST
  // ID -> N10a - Operação interestadual para consumidor final com partilhado ICMS devido na operaçãoentre a UF de origem e a UF do destinatário ou a UF definida na legislação. (Ex. UF daconcessionária de entrega do veículos) (v2.0)
  // ID -> N10b - Grupo de informação do ICMS ST devido para a UF de destino,nas operações interestaduais de produtos que tiveram retenção antecipada de ICMS por ST na UF do remetente. Repasse via Substituto Tributário. (v2.0)
  // ID -> N11  - ICMS devido para outras UF
  // ID -> N12  - Outros
  result := EnumeradoToStr(t, ['', '00', '10', '20', '30', '40', '41', '45', '50', '51',
                               '60', '70', '80', '81', '90', '90', 'SN',
                               '10', '90', '41', '60', '02', '15', '53', '61'],
                              [cstVazio, cst00, cst10, cst20, cst30, cst40, cst41, cst45, cst50, cst51,
                              cst60, cst70, cst80, cst81, cst90, cstICMSOutraUF, cstICMSSN,
                              cstPart10, cstPart90, cstRep41, cstRep60,
                              cst02, cst15, cst53, cst61]);
end;

function StrToCSTICMS(out ok: boolean; const s: string): TpcnCSTIcms;
begin
  result := StrToEnumerado(ok, s, ['', '00', '10', '20', '30', '40', '41', '45', '50', '51', '60',
                                   '70', '80', '81', '90', '91', 'SN',
                                   '10part', '90part', '41rep', '60rep',
                                   '02', '15', '53', '61'],
                                  [cstVazio, cst00, cst10, cst20, cst30, cst40, cst41, cst45, cst50, cst51, cst60,
                                   cst70, cst80, cst81, cst90, cstICMSOutraUF, cstICMSSN,
                                   cstPart10, cstPart90, cstRep41, cstRep60,
                                   cst02, cst15, cst53, cst61]);
end;

function CSTICMSToStrTagPos(const t: TpcnCSTIcms): string;
begin
  result := EnumeradoToStr(t, ['02', '03', '04', '05', '06', '06', '06', '07',
                     '08', '09', '10', '11', '12', '10a', '10a', '10b', '10b',
                     '13', '14', '15', '16'],
    [cst00, cst10, cst20, cst30, cst40, cst41, cst50, cst51, cst60, cst70,
     cst80, cst81, cst90, cstPart10 , cstPart90 , cstRep41, cstRep60,
     cst02, cst15, cst53, cst61]);
end;

function CSTICMSToStrTagPosText(const t: TpcnCSTIcms): string;
begin
  result := EnumeradoToStr(t,
   ['VAZIO',
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
    '61 - Tributação monofásica sobre combustíveis cobrada anteriormente'
    ],
    [cstVazio, cst00, cst10, cst20, cst30, cst40, cst41, cst45, cst50, cst51, cst60, cst70,
    cst80, cst81, cst90, cstICMSOutraUF, cstICMSSN, cstPart10, cstPart90, cstRep41, cstRep60,
    cst02, cst15, cst53, cst61]);
end;

// CST PIS *********************************************************************
function CSTPISToStr(const t: TpcnCstPIS): string;
begin
  result := EnumeradoToStr(t, ['01', '02', '03', '04', '05', '06', '07', '08', '09', '49', '50', '51', '52', '53', '54', '55', '56', '60', '61', '62', '63', '64', '65', '66', '67', '70', '71', '72', '73', '74', '75', '98', '99'],
    [pis01, pis02, pis03, pis04, pis05, pis06, pis07, pis08, pis09, pis49, pis50, pis51, pis52, pis53, pis54, pis55, pis56, pis60, pis61, pis62, pis63, pis64, pis65, pis66, pis67, pis70, pis71, pis72, pis73, pis74, pis75, pis98, pis99]);
end;

function StrToCSTPIS(out ok: boolean; const s: string): TpcnCstPIS;
begin
  result := StrToEnumerado(ok, s, ['01', '02', '03', '04', '05', '06', '07', '08', '09', '49', '50', '51', '52', '53', '54', '55', '56', '60', '61', '62', '63', '64', '65', '66', '67', '70', '71', '72', '73', '74', '75', '98', '99'],
    [pis01, pis02, pis03, pis04, pis05, pis06, pis07, pis08, pis09, pis49, pis50, pis51, pis52, pis53, pis54, pis55, pis56, pis60, pis61, pis62, pis63, pis64, pis65, pis66, pis67, pis70, pis71, pis72, pis73, pis74, pis75, pis98, pis99]);
end;

// CST COFINS ******************************************************************
function CSTCOFINSToStr(const t: TpcnCstCOFINS): string;
begin
  result := EnumeradoToStr(t, ['01', '02', '03', '04', '05', '06', '07', '08', '09', '49', '50', '51', '52', '53', '54', '55', '56', '60', '61', '62', '63', '64', '65', '66', '67', '70', '71', '72', '73', '74', '75', '98', '99'],
    [cof01, cof02, cof03, cof04, cof05, cof06, cof07, cof08, cof09, cof49, cof50, cof51, cof52, cof53, cof54, cof55, cof56, cof60, cof61, cof62, cof63, cof64, cof65, cof66, cof67, cof70, cof71, cof72, cof73, cof74, cof75, cof98, cof99]);
end;

function StrToCSTCOFINS(out ok: boolean; const s: string): TpcnCstCOFINS;
begin
  result := StrToEnumerado(ok, s, ['01', '02', '03', '04', '05', '06', '07', '08', '09', '49', '50', '51', '52', '53', '54', '55', '56', '60', '61', '62', '63', '64', '65', '66', '67', '70', '71', '72', '73', '74', '75', '98', '99'],
    [cof01, cof02, cof03, cof04, cof05, cof06, cof07, cof08, cof09, cof49, cof50, cof51, cof52, cof53, cof54, cof55, cof56, cof60, cof61, cof62, cof63, cof64, cof65, cof66, cof67, cof70, cof71, cof72, cof73, cof74, cof75, cof98, cof99]);
end;

function TpRodadoToStr(const t: TpcteTipoRodado): string;
begin
  result := EnumeradoToStr(t, ['00','01','02','03','04','05','06'],
   [trNaoAplicavel, trTruck, trToco, trCavaloMecanico, trVAN, trUtilitario, trOutros]);
end;

function StrToTpRodado(out ok: boolean; const s: string): TpcteTipoRodado;
begin
  result := StrToEnumerado(ok, s, ['00','01','02','03','04','05','06'],
   [trNaoAplicavel, trTruck, trToco, trCavaloMecanico, trVAN, trUtilitario, trOutros]);
end;

function TpCarroceriaToStr(const t: TpcteTipoCarroceria): string;
begin
  result := EnumeradoToStr(t, ['00','01','02','03','04','05'],
   [tcNaoAplicavel, tcAberta, tcFechada, tcGraneleira, tcPortaContainer, tcSider]);
end;

function StrToTpCarroceria(out ok: boolean; const s: string): TpcteTipoCarroceria;
begin
  result := StrToEnumerado(ok, s, ['00','01','02','03','04','05'],
   [tcNaoAplicavel, tcAberta, tcFechada, tcGraneleira, tcPortaContainer, tcSider]);
end;

function StrToTpEvento_Old(out ok: boolean;const s: string): TpcnTpEvento;
begin
  result  := TpcnTpEvento( StrToEnumerado2(ok , s, TpcnTpEventoString ) );
end;

function TpEventoToStr(const t: TpcnTpEvento): string;
begin
  result := EnumeradoToStr2( t , TpcnTpEventoString );
end;

function TpEventoToDescStr(const t: TpcnTpEvento): string;
begin
  result := EnumeradoToStr(t,
             ['NaoMapeado', 'CCe', 'Cancelamento', 'ManifDestConfirmacao', 'ManifDestCiencia',
              'ManifDestDesconhecimento', 'ManifDestOperNaoRealizada',
              'Encerramento', 'EPEC', 'InclusaoCondutor', 'MultiModal',
              'RegistroPassagem', 'RegistroPassagemBRId', 'EPECNFe',
              'RegistroCTe', 'RegistroPassagemNFeCancelado',
              'RegistroPassagemNFeRFID', 'CTeCancelado', 'MDFeCancelado',
              'VistoriaSuframa', 'PedProrrog1', 'PedProrrog2',
              'CanPedProrrog1', 'CanPedProrrog2', 'EventoFiscoPP1',
              'EventoFiscoPP2', 'EventoFiscoCPP1', 'EventoFiscoCPP2',
              'RegistroPassagemNFe', 'ConfInternalizacao', 'CTeAutorizado',
              'MDFeAutorizado', 'PrestDesacordo', 'GTV', 'MDFeAutorizado2',
              'NaoEmbarque', 'MDFeCancelado2', 'MDFeAutorizadoComCTe',
              'RegPasNfeProMDFe', 'RegPasNfeProMDFeCte', 'RegPasAutMDFeComCte',
              'CancelamentoMDFeAutComCTe', 'AverbacaoExportacao', 'AutCteComplementar',
              'CancCteComplementar', 'CTeSubstituicao',
              'CTeAnulacao', 'LiberacaoEPEC', 'LiberacaoPrazoCanc',
              'AutorizadoRedespacho', 'AutorizadoRedespIntermed', 'AutorizadoSubcontratacao',
              'AutorizadoServMultimodal', 'CancelamentoPorSubstituicao',
              'AlteracaoPoltrona', 'ExcessoBagagem', 'EncerramentoFisco',
              'ComprEntregaNFe', 'CancComprEntregaNFe',
              'AtorInteressadoNFe', 'ComprEntregaCTe', 'CancComprEntregaCTe',
              'CancPrestDesacordo', 'InsucessoEntregaCTe', 'CancInsucessoEntregaCTe',
              'ConcFinanceira', 'CancConcFinanceira', 'RegistroPassagemMDFe',
              'CancGenerico', 'PagIntegLibCredPresAdq', 'ImporALCZFM',
              'PerecPerdaRouboFurtoTranspContratFornec', 'FornecNaoRealizPagAntec',
              'SolicApropCredPres', 'DestItemConsPessoal',
              'PerecPerdaRouboFurtoTranspContratAqu',
              'AceiteDebitoApuracaoNotaCredito', 'ImobilizacaoItem',
              'SolicApropCredCombustivel', 'SolicApropCredBensServicos',
              'ManifPedTransfCredIBSSucessao', 'ManifPedTransfCredCBSSucessao'],
             [teNaoMapeado, teCCe, teCancelamento, teManifDestConfirmacao, teManifDestCiencia,
              teManifDestDesconhecimento, teManifDestOperNaoRealizada,
              teEncerramento, teEPEC, teInclusaoCondutor, teMultiModal,
              teRegistroPassagem, teRegistroPassagemBRId, teEPECNFe,
              teRegistroCTe, teRegistroPassagemNFeCancelado,
              teRegistroPassagemNFeRFID, teCTeCancelado, teMDFeCancelado,
              teVistoriaSuframa, tePedProrrog1, tePedProrrog2,
              teCanPedProrrog1, teCanPedProrrog2, teEventoFiscoPP1,
              teEventoFiscoPP2, teEventoFiscoCPP1, teEventoFiscoCPP2,
              teRegistroPassagemNFe, teConfInternalizacao, teCTeAutorizado,
              teMDFeAutorizado, tePrestDesacordo, teGTV, teMDFeAutorizado2,
              teNaoEmbarque, teMDFeCancelado2, teMDFeAutorizadoComCTe,
              teRegPasNfeProMDFe, teRegPasNfeProMDFeCte, teRegPasAutMDFeComCte,
              teCancelamentoMDFeAutComCTe, teAverbacaoExportacao, teAutCteComplementar,
              teCancCteComplementar, teCTeSubstituicao,
              teCTeAnulacao, teLiberacaoEPEC, teLiberacaoPrazoCanc,
              teAutorizadoRedespacho, teautorizadoRedespIntermed, teAutorizadoSubcontratacao,
              teautorizadoServMultimodal, teCancSubst, teAlteracaoPoltrona,
              teExcessoBagagem, teEncerramentoFisco, teComprEntregaNFe,
              teCancComprEntregaNFe, teAtorInteressadoNFe, teComprEntregaCTe,
              teCancComprEntregaCTe, teCancPrestDesacordo, teInsucessoEntregaCTe,
              teCancInsucessoEntregaCTe, teConcFinanceira, teCancConcFinanceira,
              teRegistroPassagemMDFe, teCancGenerico, tePagIntegLibCredPresAdq,
              teImporALCZFM, tePerecPerdaRouboFurtoTranspContratFornec,
              teFornecNaoRealizPagAntec, teSolicApropCredPres,
              teDestItemConsPessoal, tePerecPerdaRouboFurtoTranspContratAqu,
              teAceiteDebitoApuracaoNotaCredito, teImobilizacaoItem,
              teSolicApropCredCombustivel, teSolicApropCredBensServicos,
              teManifPedTransfCredIBSSucessao, teManifPedTransfCredCBSSucessao]);
end;

function StrToEnumerado2(out ok: boolean; const s: string;
  const AString: array of string): variant;
// Atencao  não Funciona em Alguns Enumerados ja existentes
var
  i: integer;
begin
  Result  := 0;
  ok      := False;
  try
    for i := Low(AString) to High(AString) do
      if AnsiSameText(s, AString[i]) then
      begin
        result  := i;
        ok      := True;
        exit;
      end;
  Except
    ok := False;
  End;
end;

function EnumeradoToStr2(const t: variant; const AString: array of string ): variant;
// Atencao não Funciona em Alguns Enumerados ja existentes
begin
  result := AString[ integer( t ) ];
end;


function RegTribToStr(const t: TpcnRegTrib ): string;
begin
  result := EnumeradoToStr(t, ['0','1', '3'], [RTRegimeNormal, RTSimplesNacional, RTRegimeNormal]);
end;

function StrToRegTrib(out ok: boolean; const s: string): TpcnRegTrib ;
begin
  result := StrToEnumerado(ok, s, ['0','1', '3'],[RTRegimeNormal, RTSimplesNacional, RTRegimeNormal]);
end;

function RegTribISSQNToStr(const t: TpcnRegTribISSQN ): string;
begin
  result := EnumeradoToStr(t, ['0', '1', '2', '3', '4', '5', '6'],
                              [ RTISSNenhum, RTISSMicroempresaMunicipal, RTISSEstimativa, RTISSSociedadeProfissionais,
                               RTISSCooperativa, RTISSMEI, RTISSMEEPP]);
end;

function StrToRegTribISSQN(out ok: boolean; const s: string): TpcnRegTribISSQN ;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2', '3', '4', '5', '6'],
                                  [RTISSNenhum, RTISSMicroempresaMunicipal, RTISSEstimativa, RTISSSociedadeProfissionais,
                                   RTISSCooperativa, RTISSMEI, RTISSMEEPP]);
end;

function indRatISSQNToStr(const t: TpcnindRatISSQN ): string;
begin
  result := EnumeradoToStr(t, ['S', 'N'], [irSim, irNao]);
end;

function StrToindRatISSQN(out ok: boolean; const s: string): TpcnindRatISSQN ;
begin
  result := StrToEnumerado(ok, s, ['S', 'N'],[irSim, irNao]);
end;

function indRegraToStr(const t: TpcnindRegra  ): string;
begin
  result := EnumeradoToStr(t, ['A', 'T'], [irArredondamento, irTruncamento]);
end;

function StrToindRegra(out ok: boolean; const s: string): TpcnindRegra  ;
begin
  result := StrToEnumerado(ok, s, ['A', 'T'],[irArredondamento, irTruncamento]);
end;

function CodigoMPToStr(const t: TpcnCodigoMP ): string;
begin
  result := EnumeradoToStr(t, ['01', '02', '03', '04', '05', '10', '11', '12',
                               '13', '15', '16', '17', '18', '19', '90', '99'],
                              [MPDinheiro, MPCheque, MPCartaodeCredito, MPCartaodeDebito,
                              MPCreditoLoja, MPValeAlimentacao, MPValeRefeicao, MPValePresente,
                              MPValeCombustivel, MPBoletoBancario, MPDepositoBancario,
                              MPPagamentoInstantaneo, MPTransfBancario, MPProgramaFidelidade,
                              MPSemPagamento, MPOutros]);
end;

function StrToCodigoMP(out ok: boolean; const s: string): TpcnCodigoMP ;
begin
  result := StrToEnumerado(ok, s, ['01', '02', '03', '04', '05', '10', '11', '12',
                                   '13', '15', '16', '17', '18', '19', '90', '99'],
                                  [MPDinheiro, MPCheque, MPCartaodeCredito, MPCartaodeDebito,
                                  MPCreditoLoja, MPValeAlimentacao, MPValeRefeicao, MPValePresente,
                                  MPValeCombustivel, MPBoletoBancario, MPDepositoBancario,
                                  MPPagamentoInstantaneo, MPTransfBancario, MPProgramaFidelidade,
                                  MPSemPagamento, MPOutros]);
end;

function CodigoMPToDescricao(const t: TpcnCodigoMP ): string;
begin

  result := EnumeradoToStr(t, ['Dinheiro', 'Cheque', 'Cartão de Crédito',
                               'Cartão de Débito', 'Crédito Loja', 'Vale Alimentação',
                               'Vale Refeição', 'Vale Presente', 'Vale Combustível',
                               'Boleto Bancário', 'Depósito Bancário',
                               'Pagamento Instantâneo (PIX)', 'Transferência Bancária',
                               'Programa de Fidelidade', 'Sem Pagamento', 'Outros'],
                               [MPDinheiro, MPCheque, MPCartaodeCredito,
                               MPCartaodeDebito, MPCreditoLoja, MPValeAlimentacao,
                               MPValeRefeicao, MPValePresente, MPValeCombustivel,
                               MPBoletoBancario, MPDepositoBancario,
                               MPPagamentoInstantaneo, MPTransfBancario,
                               MPProgramaFidelidade, MPSemPagamento, MPOutros]);

end;

// Tipo da Unidade de Transporte ***********************************************

function UnidTranspToStr(const t: TpcnUnidTransp):string;
begin
  result := EnumeradoToStr(t,
                           ['1', '2', '3', '4', '5', '6', '7'],
                           [utRodoTracao, utRodoReboque, utNavio, utBalsa,
                            utAeronave, utVagao, utOutros]);
end;

function StrToUnidTransp(out ok: boolean; const s: string): TpcnUnidTransp;
begin
  result := StrToEnumerado(ok, s,
                           ['1', '2', '3', '4', '5', '6', '7'],
                           [utRodoTracao, utRodoReboque, utNavio, utBalsa,
                            utAeronave, utVagao, utOutros]);
end;

// Tipo da Unidade de Carga ****************************************************

function UnidCargaToStr(const t: TpcnUnidCarga):string;
begin
  result := EnumeradoToStr(t,
                           ['1', '2', '3', '4'],
                           [ucContainer, ucULD, ucPallet, ucOutros]);
end;

function StrToUnidCarga(out ok: boolean; const s: string): TpcnUnidCarga;
begin
  result := StrToEnumerado(ok, s,
                           ['1', '2', '3', '4'],
                           [ucContainer, ucULD, ucPallet, ucOutros]);
end;

function indIEDestToStr(const t: TpcnindIEDest ): string;
begin
  result := EnumeradoToStr(t, ['1', '2', '9'], [inContribuinte, inIsento, inNaoContribuinte]);
end;

function StrToindIEDest(out ok: boolean; const s: string): TpcnindIEDest;
begin
  result := StrToEnumerado(ok, s, ['1', '2', '9'], [inContribuinte, inIsento, inNaoContribuinte]);
end;

function indIncentivoToStr(const t: TpcnindIncentivo ): string;
begin
  result := EnumeradoToStr(t, ['1', '2'],
                              [iiSim, iiNao]);
end;

function StrToindIncentivo(out ok: boolean; const s: string): TpcnindIncentivo;
begin
  result := StrToEnumerado(ok, s, ['1', '2'],
                                  [iiSim, iiNao]);
end;

function TpPropToStr(const t: TpcteProp): String;
begin
  result := EnumeradoToStr(t, ['0', '1', '2'], [tpTACAgregado, tpTACIndependente, tpOutros]);
end;

function StrToTpProp(out ok: boolean; const s: String ): TpcteProp;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2'], [tpTACAgregado, tpTACIndependente, tpOutros]);
end;

function UnidMedToStr(const t: TUnidMed): string;
begin
  result := EnumeradoToStr(t, ['00', '01', '02', '03', '04', '05'],
   [uM3,uKG, uTON, uUNIDADE, uLITROS, uMMBTU]);
end;

function UnidMedToDescricaoStr(const t: TUnidMed): string;
begin
  case t of
    uM3       : result := 'M3';
    uKG       : result := 'KG';
    uTON      : result := 'TON';
    uUNIDADE  : result := 'UND';
    uLITROS   : result := 'LT';
    uMMBTU    : result := 'MMBTU';
    else
     result := 'NÃO DEFINIDO';
  end;
end;

function StrToUnidMed(out ok: boolean; const s: String ): TUnidMed;
begin
  result := StrToEnumerado(ok, s, ['00', '01', '02', '03', '04', '05'],
   [uM3,uKG, uTON, uUNIDADE, uLITROS, uMMBTU]);
end;

function SituacaoDFeToStr(const t: TSituacaoDFe): String;
begin
  Result := EnumeradoToStr(t, ['1', '2', '3', '4'], [snAutorizado,
    snDenegado, snCancelado, snEncerrado]);
end;

function StrToSituacaoDFe(out ok: Boolean; const s: String): TSituacaoDFe;
begin
  Result := StrToEnumerado(ok, s, ['1', '2', '3', '4'], [snAutorizado,
    snDenegado, snCancelado, snEncerrado]);
end;

function TpModalToStr(const t: TpcteModal): string;
begin
  result := EnumeradoToStr(t, ['01','02', '03', '04', '05', '06'],
                              [mdRodoviario, mdAereo, mdAquaviario, mdFerroviario, mdDutoviario, mdMultimodal]);
end;

function TpModalToStrText(const t: TpcteModal): string;
begin
  result := EnumeradoToStr(t, ['RODOVIÁRIO','AÉREO', 'AQUAVIÁRIO', 'FERROVIÁRIO', 'DUTOVIÁRIO', 'MULTIMODAL'],
                              [mdRodoviario, mdAereo, mdAquaviario, mdFerroviario, mdDutoviario, mdMultimodal]);
end;

function StrToTpModal(out ok: boolean; const s: string): TpcteModal;
begin
  result := StrToEnumerado(ok, s, ['01', '02', '03', '04', '05', '06'],
                                  [mdRodoviario, mdAereo, mdAquaviario, mdFerroviario, mdDutoviario, mdMultimodal]);
end;

function TpNavegacaoToStr(const t: TTipoNavegacao): string;
begin
  result := EnumeradoToStr(t, ['0','1'],
                              [tnInterior, tnCabotagem]);
end;

function StrToTpNavegacao(out ok: boolean; const s: string): TTipoNavegacao;
begin
  result := StrToEnumerado(ok, s, ['0','1'],
                                  [tnInterior, tnCabotagem]);
end;


function tpIntegraToStr(const t: TtpIntegra): string;
begin
  result := EnumeradoToStr(t, ['', '1', '2'], [tiNaoInformado, tiPagIntegrado, tiPagNaoIntegrado]);
end;

function StrTotpIntegra(out ok: boolean; const s: string): TtpIntegra;
begin
  result := StrToEnumerado(ok, s, ['', '1', '2'], [tiNaoInformado, tiPagIntegrado, tiPagNaoIntegrado]);
end;

function TIndicadorToStr(const t: TIndicador): string;
begin
  Result := EnumeradoToStr(t, ['1', '0'], [tiSim, tiNao]);
end;

function StrToTIndicador(out ok: boolean; const s: string): TIndicador;
begin
  Result := StrToEnumerado(ok, s, ['1', '0'], [tiSim, tiNao]);
end;

function TIndicadorExToStr(const t: TIndicadorEx): string;
begin
  Result := EnumeradoToStr(t, ['', '1', '0'], [tieNenhum, tieSim, tieNao]);
end;

function StrToTIndicadorEx(out ok: boolean; const s: string): TIndicadorEx;
begin
  Result := StrToEnumerado(ok, s, ['', '1', '0'], [tieNenhum, tieSim, tieNao]);
end;

function tpNFToStr(const t: TpcnTipoNFe): String;
begin
  Result := EnumeradoToStr(t, ['0', '1'], [tnEntrada, tnSaida]);
end;

function StrToTpNF(out ok: Boolean; const s: String): TpcnTipoNFe;
begin
  Result := StrToEnumerado(ok, s, ['0', '1'], [tnEntrada, tnSaida]);
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
    raise Exception.Create(Format('"%s" não é um valor TSchemaDFe válido.',[SchemaStr]));
  end;

  Result := TSchemaDFe( CodSchema );
end;

function indIncentivoToStrTagPosText(const t: TpcnindIncentivo): string;
begin
  result := EnumeradoToStr(t, ['1 - Sim', '2 - Não'],
                              [iiSim, iiNao]);
end;

function StrToTpEventoDFe(out ok: boolean; const s, aDFe: string): TpcnTpEvento;
var
  LenList, i: Integer;
  UpperDFe: String;
begin
  Result := teNaoMapeado;
  UpperDFe := UpperCase(aDFe);
  // Varrendo lista de Métodos registrados, para ver se algum conheçe o "aDFe"
  LenList := Length(StrToTpEventoDFeList);
  For i := 0 to LenList-1 do
    if (StrToTpEventoDFeList[i].NomeDFe = UpperDFe) then
       Result := StrToTpEventoDFeList[i].StrToTpEventoMethod(ok, s);
end;

procedure RegisterStrToTpEventoDFe(AConvertProcedure: TStrToTpEvento;
  ADFe: String);
var
  LenList, i: Integer;
  UpperDFe: String;
begin
  UpperDFe := UpperCase(ADFe);
  LenList := Length(StrToTpEventoDFeList);
  // Verificando se já foi registrado antes...
  For i := 0 to LenList-1 do
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

end.

