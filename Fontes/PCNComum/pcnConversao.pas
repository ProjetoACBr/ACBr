////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar NFe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml da NFe          //
//                                                                            //
//        site: www.projetocooperar.org/nfe                                   //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_nfe/        //
//     projeto: http://code.google.com/p/projetocooperar/                     //
//         svn: http://projetocooperar.googlecode.com/svn/trunk/              //
//                                                                            //
// Coordena��o: (c) 2009 - Paulo Casagrande                                   //
//                                                                            //
//      Equipe: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
// Desenvolvimento                                                            //
//         de Cte: Wiliam Zacarias da Silva Rosa                              //
//                                                                            //
//      Vers�o: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//     Licen�a: GNU Lesser General Public License (GNU LGPL)                  //
//                                                                            //
//              - Este programa � software livre; voc� pode redistribu�-lo    //
//              e/ou modific�-lo sob os termos da Licen�a P�blica Geral GNU,  //
//              conforme publicada pela Free Software Foundation; tanto a     //
//              vers�o 2 da Licen�a como (a seu crit�rio) qualquer vers�o     //
//              mais nova.                                                    //
//                                                                            //
//              - Este programa � distribu�do na expectativa de ser �til,     //
//              mas SEM QUALQUER GARANTIA; sem mesmo a garantia impl�cita de  //
//              COMERCIALIZA��O ou de ADEQUA��O A QUALQUER PROP�SITO EM       //
//              PARTICULAR. Consulte a Licen�a P�blica Geral GNU para obter   //
//              mais detalhes. Voc� deve ter recebido uma c�pia da Licen�a    //
//              P�blica Geral GNU junto com este programa; se n�o, escreva    //
//              para a Free Software Foundation, Inc., 59 Temple Place,       //
//              Suite 330, Boston, MA - 02111-1307, USA ou consulte a         //
//              licen�a oficial em http://www.gnu.org/licenses/gpl.txt        //
//                                                                            //
//    Nota (1): - Esta  licen�a  n�o  concede  o  direito  de  uso  do nome   //
//              "PCN  -  Projeto  Cooperar  NFe", n�o  podendo o mesmo ser    //
//              utilizado sem previa autoriza��o.                             //
//                                                                            //
//    Nota (2): - O uso integral (ou parcial) das units do projeto esta       //
//              condicionado a manuten��o deste cabe�alho junto ao c�digo     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

{$I ACBr.inc}

unit pcnConversao;

interface

uses
  SysUtils, StrUtils, Classes;

type

                  // tcEsp = String: somente numeros;
  TpcnTipoCampo = (tcStr, tcInt, tcDat, tcDatHor, tcEsp, tcDe2, tcDe3, tcDe4,
                   tcDe5, tcDe6, tcDe7, tcDe8, tcDe10, tcHor, tcDatCFe, tcHorCFe, tcDatVcto,
                   tcDatHorCFe, tcBoolStr, tcStrOrig, tcNumStr, tcInt64, tcDe1,
                   tcDatBol);

  TpcnTagAssinatura = (taSempre, taNunca, taSomenteSeAssinada, taSomenteParaNaoAssinada);

  TpcnTipoImpressao = (tiSemGeracao, tiRetrato, tiPaisagem, tiSimplificado,
                       tiNFCe, tiMsgEletronica);

  TpcnTipoEmissao = (teNormal, teContingencia, teSCAN, teDPEC, teFSDA, teSVCAN, teSVCRS, teSVCSP, teOffLine);
  TpcnTipoAmbiente = (taProducao, taHomologacao);

  TpcnProcessoEmissao = (peAplicativoContribuinte, peAvulsaFisco, peAvulsaContribuinte, peContribuinteAplicativoFisco);
  TpcnOrigemMercadoria = (oeNacional, oeEstrangeiraImportacaoDireta, oeEstrangeiraAdquiridaBrasil,
                          oeNacionalConteudoImportacaoSuperior40, oeNacionalProcessosBasicos,
                          oeNacionalConteudoImportacaoInferiorIgual40,
                          oeEstrangeiraImportacaoDiretaSemSimilar, oeEstrangeiraAdquiridaBrasilSemSimilar,
                          oeNacionalConteudoImportacaoSuperior70, oeReservadoParaUsoFuturo,
                          oeVazio);

  TpcnCSTIcms = (cst00, cst10, cst20, cst30, cst40, cst41, cst45, cst50, cst51,
                 cst60, cst70, cst80, cst81, cst90, cstPart10, cstPart90,
                 cstRep41, cstVazio, cstICMSOutraUF, cstICMSSN, cstRep60,
                 cst02, cst15, cst53, cst61, cst01, cst12, cst13, cst14, cst21, cst72, cst73, cst74); //80 e 81 apenas para CTe

  TpcnCSOSNIcms = (csosnVazio,csosn101, csosn102, csosn103, csosn201, csosn202, csosn203, csosn300, csosn400, csosn500,csosn900 );

  TpcnCstPis = (pis01, pis02, pis03, pis04, pis05, pis06, pis07, pis08, pis09, pis49, pis50, pis51, pis52, pis53,
                pis54, pis55, pis56, pis60, pis61, pis62, pis63, pis64, pis65, pis66, pis67, pis70, pis71, pis72,
                pis73, pis74, pis75, pis98, pis99);
  TpcnCstCofins = (cof01, cof02, cof03, cof04, cof05, cof06, cof07, cof08, cof09, cof49, cof50, cof51, cof52, cof53,
                   cof54, cof55, cof56, cof60, cof61, cof62, cof63, cof64, cof65, cof66, cof67, cof70, cof71, cof72,
                   cof73, cof74, cof75, cof98, cof99);



  TpcteTipoRodado = (trNaoAplicavel, trTruck, trToco, trCavaloMecanico, trVAN, trUtilitario, trOutros);
  TpcteTipoCarroceria = (tcNaoAplicavel, tcAberta, tcFechada, tcGraneleira, tcPortaContainer, tcSider);

  TPosRecibo = (prCabecalho, prRodape, prEsquerda);
  TPosReciboLayout = (prlPadrao, prlBarra);

  TpcnTpEvento = (teNaoMapeado, teCCe, teCancelamento,
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
                  teRegistroPassagemMDFe);

  TpcnTamanhoPapel = (tpA4, tpA4_2vias, tpA5);

  TpcnRegTrib = (RTSimplesNacional, RTRegimeNormal);
  TpcnRegTribISSQN = (RTISSMicroempresaMunicipal, RTISSEstimativa, RTISSSociedadeProfissionais, RTISSCooperativa, RTISSMEI, RTISSMEEPP, RTISSNenhum);
  TpcnindRatISSQN = (irSim, irNao);
  TpcnindRegra = (irArredondamento, irTruncamento);
  TpcnCodigoMP = (mpDinheiro, mpCheque, mpCartaodeCredito, mpCartaodeDebito, mpCreditoLoja,
                  mpValeAlimentacao, mpValeRefeicao, mpValePresente, mpValeCombustivel,
                  mpBoletoBancario, mpDepositoBancario, mpPagamentoInstantaneo,
                  mpTransfBancario, mpProgramaFidelidade, mpSemPagamento, mpOutros);
  TpcnUnidTransp = ( utRodoTracao, utRodoReboque, utNavio, utBalsa, utAeronave, utVagao, utOutros );
  TpcnUnidCarga  = ( ucContainer, ucULD, ucPallet, ucOutros );
  TpcnindIEDest = (inContribuinte, inIsento, inNaoContribuinte);

  TpcnindIncentivo = (iiSim, iiNao);

  TpcteModal = (mdRodoviario, mdAereo, mdAquaviario, mdFerroviario, mdDutoviario, mdMultimodal);
  TpcteProp = (tpTACAgregado, tpTACIndependente, tpOutros);
  TUnidMed = (uM3,uKG, uTON, uUNIDADE, uLITROS, uMMBTU);

  TSituacaoDFe = (snAutorizado, snDenegado, snCancelado, snEncerrado);

  TTipoNavegacao = (tnInterior, tnCabotagem);

  TtpIntegra = (tiNaoInformado, tiPagIntegrado, tiPagNaoIntegrado);

  TIndicador = (tiSim, tiNao);
  TIndicadorEx = (tieNenhum, tieSim, tieNao);

  TpcnTipoNFe = (tnEntrada, tnSaida);

  TSchemaDFe = (schresNFe, schresEvento, schprocNFe, schprocEventoNFe,
                schresCTe, schprocCTe, schprocCTeOS, schprocEventoCTe,
                schresMDFe, schprocMDFe, schprocEventoMDFe,
                schresBPe, schprocBPe, schprocEventoBPe,
                schprocGTVe);


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

function UFtoCUF(const UF: String): Integer;
function CUFtoUF(CUF: Integer): String;

function TpModalToStr(const t: TpcteModal): string;
function TpModalToStrText(const t: TpcteModal): string;
function StrToTpModal(out ok: boolean; const s: string): TpcteModal;

function TpImpToStr(const t: TpcnTipoImpressao): string;
function StrToTpImp(out ok: boolean; const s: string): TpcnTipoImpressao;

function TpEmisToStr(const t: TpcnTipoEmissao): string;
function StrToTpEmis(out ok: boolean; const s: string): TpcnTipoEmissao;
function TpAmbToStr(const t: TpcnTipoAmbiente): string;
function StrToTpAmb(out ok: boolean; const s: string): TpcnTipoAmbiente;

function procEmiToStr(const t: TpcnProcessoEmissao): string;
function StrToprocEmi(out ok: boolean; const s: string): TpcnProcessoEmissao;
function OrigToStr(const t: TpcnOrigemMercadoria): string;
function StrToOrig(out ok: boolean; const s: string): TpcnOrigemMercadoria;
function CSTICMSToStr(const t: TpcnCSTIcms): string;
function StrToCSTICMS(out ok: boolean; const s: string): TpcnCSTIcms;
function CSOSNIcmsToStr(const t: TpcnCSOSNIcms): string;
function StrToCSOSNIcms(out ok: boolean; const s: string): TpcnCSOSNIcms;
function CSTICMSToStrTagPos(const t: TpcnCSTIcms): string;
function CSTICMSToStrTagPosText(const t: TpcnCSTIcms): string;
function CSOSNToStrTagPos(const t: TpcnCSOSNIcms): string;
function CSOSNToStrID(const t: TpcnCSOSNIcms): string;
function CSOSNToStrTagPosText(const t: TpcnCSOSNIcms): string;
function OrigToStrTagPosText(const t: TpcnOrigemMercadoria): string;
function CSTPISToStrTagPosText(const t: TpcnCstPis): string;
function CSTCOFINSToStrTagPosText(const t: TpcnCstCofins): string;

function CSTPISToStr(const t: TpcnCstPIS): string;
function StrToCSTPIS(out ok: boolean; const s: string): TpcnCstPIS;
function CSTCOFINSToStr(const t: TpcnCstCOFINS): string;
function StrToCSTCOFINS(out ok: boolean; const s: string): TpcnCstCOFINS;

function TpRodadoToStr(const t: TpcteTipoRodado): string;
function StrToTpRodado(out ok: boolean; const s: string): TpcteTipoRodado;
function TpCarroceriaToStr(const t: TpcteTipoCarroceria): string;
function StrToTpCarroceria(out ok: boolean; const s: string): TpcteTipoCarroceria;

function StrToTpEvento_Old(out ok: boolean; const s: string): TpcnTpEvento;
function TpEventoToStr(const t: TpcnTpEvento): string;
function TpEventoToDescStr(const t: TpcnTpEvento): string;

function RegTribToStr(const t: TpcnRegTrib ): string;
function StrToRegTrib(out ok: boolean; const s: string): TpcnRegTrib ;
function RegTribISSQNToStr(const t: TpcnRegTribISSQN ): string;
function StrToRegTribISSQN(out ok: boolean; const s: string): TpcnRegTribISSQN ;
function indRatISSQNToStr(const t: TpcnindRatISSQN ): string;
function StrToindRatISSQN(out ok: boolean; const s: string): TpcnindRatISSQN ;
function indRegraToStr(const t: TpcnindRegra ): string;
function StrToindRegra(out ok: boolean; const s: string): TpcnindRegra ;
function CodigoMPToStr(const t: TpcnCodigoMP ): string;
function StrToCodigoMP(out ok: boolean; const s: string): TpcnCodigoMP ;
function CodigoMPToDescricao(const t: TpcnCodigoMP ): string;

function UnidTranspToStr(const t: TpcnUnidTransp):string;
function StrToUnidTransp(out ok: boolean; const s: string): TpcnUnidTransp;
function UnidCargaToStr(const t: TpcnUnidCarga):string;
function StrToUnidCarga(out ok: boolean; const s: string):TpcnUnidCarga;
function indIEDestToStr(const t: TpcnindIEDest ): string;
function StrToindIEDest(out ok: boolean; const s: string): TpcnindIEDest;

function indIncentivoToStr(const t: TpcnindIncentivo ): string;
function StrToindIncentivo(out ok: boolean; const s: string): TpcnindIncentivo;

function TpPropToStr(const t: TpcteProp): String;
function StrToTpProp(out ok: boolean; const s: String ): TpcteProp;

function UnidMedToStr(const t: TUnidMed): string;
function StrToUnidMed(out ok: boolean; const s: String ): TUnidMed;
function UnidMedToDescricaoStr(const t: TUnidMed): string;

function SituacaoDFeToStr(const t: TSituacaoDFe): String;
function StrToSituacaoDFe(out ok: Boolean; const s: String): TSituacaoDFe;

function TpNavegacaoToStr(const t: TTipoNavegacao): string;
function StrToTpNavegacao(out ok: boolean; const s: string): TTipoNavegacao;

function tpIntegraToStr(const t: TtpIntegra): string;
function StrTotpIntegra(out ok: boolean; const s: string): TtpIntegra;

function TIndicadorToStr(const t: TIndicador): string;
function StrToTIndicador(out ok: boolean; const s: string): TIndicador;

function TIndicadorExToStr(const t: TIndicadorEx): string;
function StrToTIndicadorEx(out ok: boolean; const s: string): TIndicadorEx;

function tpNFToStr(const t: TpcnTipoNFe): String;
function StrToTpNF(out ok: Boolean; const s: String): TpcnTipoNFe;

function SchemaDFeToStr(const t: TSchemaDFe): String;
function StrToSchemaDFe(const s: String): TSchemaDFe;

function indIncentivoToStrTagPosText(const t: TpcnindIncentivo ): string;

function StrToTpEventoDFe(out ok: boolean; const s, aDFe: string): TpcnTpEvento;

procedure RegisterStrToTpEventoDFe(AConvertProcedure: TStrToTpEvento; ADFe: String);

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

// B21 - Formato de Impress�o do DANFE *****************************************
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

// B22 - Forma de Emiss�o da NF-e **********************************************
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

// B24 - Identifica��o do Ambiente *********************************************
 function TpAmbToStr(const t: TpcnTipoAmbiente): string;
begin
  result := EnumeradoToStr(t, ['1', '2'], [taProducao, taHomologacao]);
end;

function StrToTpAmb(out ok: boolean; const s: string): TpcnTipoAmbiente;
begin
  result := StrToEnumerado(ok, s, ['1', '2'], [taProducao, taHomologacao]);
end;

// B26 - Processo de emiss�o da NF-e *******************************************
function procEmiToStr(const t: TpcnProcessoEmissao): string;
begin
  // 0 - emiss�o de NF-e com aplicativo do contribuinte;
  // 1 - emiss�o de NF-e avulsa pelo Fisco;
  // 2 - emiss�o de NF-e avulsa, pelo contribuinte com seu certificado digital, atrav�s do site do Fisco;
  // 3 - emiss�o NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
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
          ['01 - Opera��o Tribut�vel com Al�quota B�sica',
          '02 - Opera��o Tribut�vel com Al�quota Diferenciada',
          '03 - Opera��o Tribut�vel com Al�quota por Unidade de Medida de Produto',
          '04 - Opera��o Tribut�vel Monof�sica - Revenda a Al�quota Zero',
          '05 - Opera��o Tribut�vel por Substitui��o Tribut�ria',
          '06 - Opera��o Tribut�vel a Al�quota Zero',
          '07 - Opera��o Isenta da Contribui��o',
          '08 - Opera��o sem Incid�ncia da Contribui��o',
          '09 - Opera��o com Suspens�o da Contribui��o',
          '49 - Outras Opera��es de Sa�da',
          '50 - Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno',
          '51 - Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita N�o Tributada no Mercado Interno',
          '52 - Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita de Exporta��o',
          '53 - Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno',
          '54 - Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o',
          '55 - Opera��o com Direito a Cr�dito - Vinculada a Receitas N�o-Tributadas no Mercado Interno e de Exporta��o',
          '56 - Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno, e de Exporta��o',
          '60 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita Tributada no Mercado Interno',
          '61 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita N�o-Tributada no Mercado Interno',
          '62 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita de Exporta��o',
          '63 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno',
          '64 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o',
          '65 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas N�o-Tributadas no Mercado Interno e de Exporta��o',
          '66 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno, e de Exporta��o',
          '67 - Cr�dito Presumido - Outras Opera��es',
          '70 - Opera��o de Aquisi��o sem Direito a Cr�dito',
          '71 - Opera��o de Aquisi��o com Isen��o',
          '72 - Opera��o de Aquisi��o com Suspens�o',
          '73 - Opera��o de Aquisi��o a Al�quota Zero',
          '74 - Opera��o de Aquisi��o sem Incid�ncia da Contribui��o',
          '75 - Opera��o de Aquisi��o por Substitui��o Tribut�ria',
          '98 - Outras Opera��es de Entrada',
          '99 - Outras Opera��es'],
          [pis01, pis02, pis03, pis04, pis05, pis06, pis07, pis08, pis09, pis49, pis50, pis51, pis52, pis53, pis54, pis55, pis56, pis60, pis61, pis62, pis63, pis64, pis65, pis66, pis67, pis70, pis71, pis72, pis73, pis74, pis75, pis98, pis99]);
end;

function CSTCOFINSToStrTagPosText(const t: TpcnCstCofins): string;
begin
     result := EnumeradoToStr(t,
          ['01 - Opera��o Tribut�vel com Al�quota B�sica',
          '02 - Opera��o Tribut�vel com Al�quota Diferenciada',
          '03 - Opera��o Tribut�vel com Al�quota por Unidade de Medida de Produto',
          '04 - Opera��o Tribut�vel Monof�sica - Revenda a Al�quota Zero',
          '05 - Opera��o Tribut�vel por Substitui��o Tribut�ria',
          '06 - Opera��o Tribut�vel a Al�quota Zero',
          '07 - Opera��o Isenta da Contribui��o',
          '08 - Opera��o sem Incid�ncia da Contribui��o',
          '09 - Opera��o com Suspens�o da Contribui��o',
          '49 - Outras Opera��es de Sa�da',
          '50 - Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno',
          '51 - Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita N�o Tributada no Mercado Interno',
          '52 - Opera��o com Direito a Cr�dito - Vinculada Exclusivamente a Receita de Exporta��o',
          '53 - Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno',
          '54 - Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o',
          '55 - Opera��o com Direito a Cr�dito - Vinculada a Receitas N�o-Tributadas no Mercado Interno e de Exporta��o',
          '56 - Opera��o com Direito a Cr�dito - Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno, e de Exporta��o',
          '60 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita Tributada no Mercado Interno',
          '61 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita N�o-Tributada no Mercado Interno',
          '62 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada Exclusivamente a Receita de Exporta��o',
          '63 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno',
          '64 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas no Mercado Interno e de Exporta��o',
          '65 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas N�o-Tributadas no Mercado Interno e de Exporta��o',
          '66 - Cr�dito Presumido - Opera��o de Aquisi��o Vinculada a Receitas Tributadas e N�o-Tributadas no Mercado Interno, e de Exporta��o',
          '67 - Cr�dito Presumido - Outras Opera��es',
          '70 - Opera��o de Aquisi��o sem Direito a Cr�dito',
          '71 - Opera��o de Aquisi��o com Isen��o',
          '72 - Opera��o de Aquisi��o com Suspens�o',
          '73 - Opera��o de Aquisi��o a Al�quota Zero',
          '74 - Opera��o de Aquisi��o sem Incid�ncia da Contribui��o',
          '75 - Opera��o de Aquisi��o por Substitui��o Tribut�ria',
          '98 - Outras Opera��es de Entrada',
          '99 - Outras Opera��es'],
          [cof01, cof02, cof03, cof04, cof05, cof06, cof07, cof08, cof09, cof49, cof50, cof51, cof52, cof53, cof54, cof55, cof56, cof60, cof61, cof62, cof63, cof64, cof65, cof66, cof67, cof70, cof71, cof72, cof73, cof74, cof75, cof98, cof99]);
end;

function OrigToStrTagPosText(const t: TpcnOrigemMercadoria): string;
begin
  result := EnumeradoToStr(t,
   ['0 - Nacional, exceto as indicadas nos c�digos 3, 4, 5 e 8. ',
    '1 - Estrangeira - Importa��o direta, exceto a indicada no c�digo 6.',
    '2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no c�digo 7.',
    '3 - Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 40% e inferior ou igual a 70%.',
    '4 - Nacional, cuja produ��o tenha sido feita em conformidade com os processos produtivos b�sicos de que tratam as legisla��es citadas nos Ajustes.',
    '5 - Nacional, mercadoria ou bem com Conte�do de Importa��o inferior ou igual a 40%. ',
    '6 - Estrangeira - Importa��o direta, sem similar nacional, constante em lista da CAMEX e g�s natural. ',
    '7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista da CAMEX e g�s natural.',
    '8 - Nacional, mercadoria ou bem com Conte�do de Importa��o superior a 70%.'],
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
    '101 - Tributada pelo Simples Nacional com permiss�o de cr�dito',
    '102 - Tributada pelo Simples Nacional sem permiss�o de cr�dito ',
    '103 - Isen��o do ICMS no Simples Nacional para faixa de receita bruta',
    '201 - Tributada pelo Simples Nacional com permiss�o de cr�dito e com cobran�a do ICMS por substitui��o tribut�ria',
    '202 - Tributada pelo Simples Nacional sem permiss�o de cr�dito e com cobran�a do ICMS por substitui��o tribut�ria',
    '203 - Isen��o do ICMS no Simples Nacional para faixa de receita bruta e com cobran�a do ICMS por substitui��o tribut�ria',
    '300 - Imune',
    '400 - N�o tributada pelo Simples Nacional',
    '500 - ICMS cobrado anteriormente por substitui��o tribut�ria (substitu�do) ou por antecipa��o',
    '900 - Outros'],
    [csosnVazio, csosn101, csosn102, csosn103, csosn201, csosn202, csosn203, csosn300, csosn400, csosn500,csosn900]);
end;

//***************************************************************************

// CST ICMS ********************************************************************
function CSTICMSToStr(const t: TpcnCSTIcms): string;
begin
  // ID -> N02  - Tributada integralmente
  // ID -> N03  - Tributada e com cobran�a do ICMS por substitui��o tribut�ria
  // ID -> N04  - Com redu��o de base de c�lculo
  // ID -> N05  - Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria
  // ID -> N06  - Isenta
  // ID -> N06  - N�o tributada
  // ID -> N06  - Suspens�o
  // ID -> N07  - Diferimento A exig�ncia do preenchimento das informa��es do ICMS diferido fica � crit�rio de cada UF.
  // ID -> N08  - ICMS cobrado anteriormente por substitui��o
  // ID -> N09  - Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria
  // ID -> N10  - ICMS pagto atribu�do ao tomador ou ao terceiro previsto na legisla��o p/ ST
  // ID -> N10a - Opera��o interestadual para consumidor final com partilhado ICMS devido na opera��oentre a UF de origem e a UF do destinat�rio ou a UF definida na legisla��o. (Ex. UF daconcession�ria de entrega do ve�culos) (v2.0)
  // ID -> N10b - Grupo de informa��o do ICMS ST devido para a UF de destino,nas opera��es interestaduais de produtos que tiveram reten��o antecipada de ICMS por ST na UF do remetente. Repasse via Substituto Tribut�rio. (v2.0)
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
    '00 - TRIBUTA��O NORMAL DO ICMS',
    '10 - TRIBUTA��O COM COBRAN�A DO ICMS POR SUBST. TRIBUT�RIA',
    '20 - TRIBUTA��O COM REDU��O DE BC DO ICMS',
    '30 - TRIBUTA��O ISENTA E COM COBRAN�A DO ICMS POR SUBST. TRIBUT�RIA',
    '40 - ICMS ISEN��O',
    '41 - ICMS N�O TRIBUTADO',
    '45 - ICMS ISENTO, N�O TRIBUTADO OU DIFERIDO',
    '50 - ICMS SUSPENS�O',
    '51 - ICMS DIFERIDO',
    '60 - ICMS COBRADO POR SUBSTITUI��O TRIBUT�RIA',
    '70 - TRIBUTA��O COM REDU��O DE BC E COBRAN�A DO ICMS POR SUBST. TRIBUT�RIA',
    '80 - RESPONSABILIDADE DO RECOLHIMENTO DO ICMS ATRIBU�DO AO TOMADOR OU 3� POR ST',
    '81 - ICMS DEVIDO � OUTRA UF',
    '90 - ICMS OUTROS',
    '90 - ICMS DEVIDO A UF DE ORIGEM DA PRESTACAO, QUANDO DIFERENTE DA UF DO EMITENTE',
    '90 - SIMPLES NACIONAL',
    '10 - TRIBUTADA E COM COBRAN�A DO ICMS POR SUBSTITUI��O TRIBUT�RIA - PARTILHA',
    '90 - OUTROS - PARTILHA',
    '41 - N�O TRIBUTADO - REPASSE',
    '60 - COBRADO ANTERIORMENTE POR SUBSTITUI��O TRIBUT�RIA - REPASSE',
    '02 - Tributa��o monof�sica pr�pria sobre combust�veis',
    '15 - Tributa��o monof�sica pr�pria e com responsabilidade pela reten��o sobre combust�veis',
    '53 - Tributa��o monof�sica sobre combust�veis com recolhimento diferido',
    '61 - Tributa��o monof�sica sobre combust�veis cobrada anteriormente'
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
              'ConcFinanceira', 'CancConcFinanceira', 'RegistroPassagemMDFe'],
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
              teRegistroPassagemMDFe]);
end;


function StrToEnumerado2(out ok: boolean; const s: string;
  const AString: array of string): variant;
// Atencao  n�o Funciona em Alguns Enumerados ja existentes
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
// Atencao n�o Funciona em Alguns Enumerados ja existentes
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

  result := EnumeradoToStr(t, ['Dinheiro', 'Cheque', 'Cart�o de Cr�dito',
                               'Cart�o de D�bito', 'Cr�dito Loja', 'Vale Alimenta��o',
                               'Vale Refei��o', 'Vale Presente', 'Vale Combust�vel',
                               'Boleto Banc�rio', 'Dep�sito Banc�rio',
                               'Pagamento Instant�neo (PIX)', 'Transfer�ncia Banc�ria',
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
     result := 'N�O DEFINIDO';
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
  result := EnumeradoToStr(t, ['RODOVI�RIO','A�REO', 'AQUAVI�RIO', 'FERROVI�RIO', 'DUTOVI�RIO', 'MULTIMODAL'],
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
    raise Exception.Create(Format('"%s" n�o � um valor TSchemaDFe v�lido.',[SchemaStr]));
  end;

  Result := TSchemaDFe( CodSchema );
end;

function indIncentivoToStrTagPosText(const t: TpcnindIncentivo): string;
begin
  result := EnumeradoToStr(t, ['1 - Sim', '2 - N�o'],
                              [iiSim, iiNao]);
end;

function StrToTpEventoDFe(out ok: boolean; const s, aDFe: string): TpcnTpEvento;
var
  LenList, i: Integer;
  UpperDFe: String;
begin
  Result := teNaoMapeado;
  UpperDFe := UpperCase(aDFe);
  // Varrendo lista de M�todos registrados, para ver se algum conhe�e o "aDFe"
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
  // Verificando se j� foi registrado antes...
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

