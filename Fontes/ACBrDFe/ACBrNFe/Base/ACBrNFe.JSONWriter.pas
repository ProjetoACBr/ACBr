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

unit ACBrNFe.JSONWriter;

interface

uses
  Classes, SysUtils, ACBrJSON, ACBrNFe.Classes, pcnConversao, pcnConversaoNFe;

type
  TNFeJSONWriter = class
  private
    FNFe: TNFe;

    procedure GerarInfNFe(AJSONObject: TACBrJSONObject);
    procedure GerarIde(const AIde: TIde; AJSONObject: TACBrJSONObject);
    procedure GerarIdeNFref(const ANFRef: TNFrefCollection; AJSONObject: TACBrJSONObject);
    procedure GerarEmit(const AEmit: TEmit; AJSONObject: TACBrJSONObject);
    procedure GerarEmitEnderEmit(const AEnderEmit: TenderEmit; AJSONObject: TACBrJSONObject);
    procedure GerarAvulsa(const AAvulsa: TAvulsa; AJSONObject: TACBrJSONObject);
    procedure GerarDest(const ADest: TDest; AJSONObject: TACBrJSONObject);
    procedure GerarDestEnderDest(const AEnderDest: TEnderDest; AJSONObject: TACBrJSONObject);
    procedure GerarRetirada(const ARetirada: TRetirada; AJSONObject: TACBrJSONObject);
    procedure GerarEntrega(const AEntrega: TEntrega; AJSONObject: TACBrJSONObject);
    procedure GerarAutXML(const AAutXML: TautXMLCollection; AJSONObject: TACBrJSONObject);
    procedure GerarDet(const ADet: TDetCollection; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd(const AProd: TProd; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_CredPresumido(const ACredPresumido: TCredPresumidoCollection; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_NVE(const ANVe: TNVECollection; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_DI(const ADI: TDICollection; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_DIAdi(const AAdi: TAdiCollection; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_DetExport(const ADetExport: TdetExportCollection; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_Rastro(const ARastro: TRastroCollection; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_VeicProd(const AVeicProd: TveicProd; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_Med(const AMed: TMedCollection; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_Arma(const AArma: TArmaCollection; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_Comb(const AComb: TComb; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_CombCide(const ACide: TCIDE; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_CombEncerrante(const AEncerrante: TEncerrante; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_CombOrigComb(const AOrigComb: TorigCombCollection; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_CombICMSComb(const AICMS: TICMSComb; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_CombICMSInter(const AICMS: TICMSInter; AJSONObject: TACBrJSONObject);
    procedure GerarDetProd_CombICMSCons(const AICMS: TICMSCons; AJSONObject: TACBrJSONObject);
    procedure GerarDetImposto(const AImposto: TImposto; AJSONObject: TACBrJSONObject);
    procedure GerarDetImposto_ICMS(const AICMS: TICMS; AJSONObject: TACBrJSONObject);
    procedure GerarDetImposto_ICMSICMSUFDest(const AICMSUfDest: TICMSUFDest; AJSONObject: TACBrJSONObject);
    procedure GerarDetImposto_IPI(const AIPI: TIPI; AJSONObject: TACBrJSONObject);
    procedure GerarDetImposto_II(const AII: TII; AJSONObject: TACBrJSONObject);
    procedure GerarDetImposto_PIS(const APIS: TPIS; AJSONObject: TACBrJSONObject);
    procedure GerarDetImposto_PISST(const APISST: TPISST; AJSONObject: TACBrJSONObject);
    procedure GerarDetImposto_COFINS(const ACOFINS: TCOFINS; AJSONObject: TACBrJSONObject);
    procedure GerarDetImposto_COFINSST(const ACOFINSST: TCOFINSST; AJSONObject: TACBrJSONObject);
    procedure GerarDetImposto_ISSQN(const AISSQN: TISSQN; AJSONObject: TACBrJSONObject);
    procedure GerarDetObs(const AObs: TobsItem; const AKeyName: String; AJSONObject: TACBrJSONObject);
    procedure GerarTotal(const ATotal: TTotal; AJSONObject: TACBrJSONObject);
    procedure GerarTotal_ICMSTot(const AICMSTot: TICMSTot; AJSONObject: TACBrJSONObject);
    procedure GerarTotal_ISSQNTot(const AISSQNTot: TISSQNtot; AJSONObject: TACBrJSONObject);
    procedure GerarTotal_retTrib(const ARetTrib: TretTrib; AJSONObject: TACBrJSONObject);
    procedure GerarTransp(const ATransp: TTransp; AJSONObject: TACBrJSONObject);
    procedure GerarTransp_Transporta(const ATransporta: TTransporta; AJSONObject: TACBrJSONObject);
    procedure GerarTransp_retTransp(const ARetTransp: TretTransp; AJSONObject: TACBrJSONObject);
    procedure GerarTransp_veicTransp(const AVeicTransp: TveicTransp; AJSONObject: TACBrJSONObject);
    procedure GerarTransp_reboque(const AReboque: TReboqueCollection; AJSONObject: TACBrJSONObject);
    procedure GerarTransp_Vol(const AVol: TVolCollection; AJSONObject: TACBrJSONObject);
    procedure GerarTransp_VolLacres(const ALacres: TLacresCollection; AJSONObject: TACBrJSONObject);
    procedure GerarCobr(const ACobr: TCobr; AJSONObject: TACBrJSONObject);
    procedure GerarCobr_fat(const AFat: TFat; AJSONObject: TACBrJSONObject);
    procedure GerarCobr_dup(const ADup: TDupCollection; AJSONObject: TACBrJSONObject);
    procedure GerarPag(const APag: TpagCollection; AJSONObject: TACBrJSONObject);
    procedure GerarInfIntermed(const AInfIntermed: TinfIntermed; AJSONObject: TACBrJSONObject);
    procedure GerarInfAdic(const AInfAdic: TInfAdic; AJSONObject: TACBrJSONObject);
    procedure GerarInfAdic_obsCont(const AObsCont: TobsContCollection; AJSONObject: TACBrJSONObject);
    procedure GerarInfAdic_obsFisco(const AObsFisco: TobsFiscoCollection; AJSONObject: TACBrJSONObject);
    procedure GerarInfAdic_procRef(const AProcRef: TprocRefCollection; AJSONObject: TACBrJSONObject);
    procedure GerarExporta(const AExporta: TExporta; AJSONObject: TACBrJSONObject);
    procedure GerarCompra(const ACompra: TCompra; AJSONObject: TACBrJSONObject);
    procedure GerarCana(const ACana: Tcana; AJSONObject: TACBrJSONObject);
    procedure GerarCana_fordia(const AForDia: TForDiaCollection; AJSONObject: TACBrJSONObject);
    procedure GerarCana_deduc(const ADeduc: TDeducCollection; AJSONObject: TACBrJSONObject);
    procedure GerarInfRespTec(const AInfRespTec: TinfRespTec; AJSONObject: TACBrJSONObject);
    procedure GerarInfNFeSupl(const AInfNFeSupl: TinfNFeSupl; AJSONObj: TACBrJSONObject);
    procedure GerarAgropecuario(const AAgropecuario: Tagropecuario; AJSONObject: TACBrJSONObject);
    procedure Gerar_defensivo(const ADefensivo: TdefensivoCollection; AJSONObject: TACBrJSONObject);
    procedure Gerar_guiaTransito(const AGuiaTransito: TguiaTransito; AJSONObject: TACBrJSONObject);

    // Reforma Tributria
    procedure Gerar_gCompraGov(const AgCompraGov: TgCompraGov; AJSONObject: TACBrJSONObject);
    procedure Gerar_gPagAntecipado(const AGPagAntecipado: TgPagAntecipadoCollection; AJSONObject: TACBrJSONObject);
    procedure Gerar_ISel(const AISel: TgIS; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS(const AIBSCBS: TIBSCBS; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBS(const AGIBSCBS: TgIBSCBS; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBSMono(const AIBSCBSMono: TgIBSCBSMono; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBSMono_gMonoPadrao(const AGMonoPadrao: TgMonoPadrao; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBSMono_gMonoReten(const AGMonoReten: TgMonoReten; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBSMono_gMonoRet(const AGMonoRet: TgMonoRet; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBSMono_gMonoDif(const AGMonoDif: TgMonoDif; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gTransfCred(const AGTransfCred: TgTransfCred; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gCredPresIBSZFM(const AGCredPresIBSZFM: TCredPresIBSZFM; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBS_gIBSUF(const AIBSUF: TgIBSUF; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBS_gIBSCBSUFMun_gDevTrib(const AGDevTrib: TgDevTrib; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBS_gIBSCBSUFMun_gRed(const AGRed: TgRed; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBS_gIBSMun(const AIBSMun: TgIBSMun; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBS_gCBS(const AGCBS: TgCBS; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBS__gDif(const AGDif: TgDif; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBS_gTribRegular(const AGTribRegular: TgTribRegular; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBS_gIBSCBSCredPres(const AGIBSCredPres: TgIBSCBSCredPres; const AKeyName: String; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBS_gIBSCBS_gTribCompraGov(const AGTribCompraGov: TgTribCompraGov; AJSONObject: TACBrJSONObject);
    procedure Gerar_Det_DFeReferenciado(const ADFeReferenciado: TDFeReferenciado; AJSONObject: TACBrJSONObject);
    procedure Gerar_ISTot(const AISTot: TISTot; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBSTot(const AIBSCBSTot: TIBSCBSTot; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBSTot_gIBS(const AGIBS: TgIBSTot; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBSTot_gIBS_gIBSUFTot(const AGIBSUFTot: TgIBSUFTot; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBSTot_gIBS_gIBSMunTot(const AGIBSMunTot: TgIBSMunTot; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBSTot_gCBS(const AGCBS: TgCBSTot; AJSONObject: TACBrJSONObject);
    procedure Gerar_IBSCBSTot_gMono(const AGMono: TgMono; AJSONObject: TACBrJSONObject);
  public
    constructor Create(AOwner: TNFe); reintroduce;
    destructor Destroy; override;

    function GerarJSON: string;

    property NFe: TNFe read FNFe;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrDFe.Conversao;

{ TNFeJSONWriter }

constructor TNFeJSONWriter.Create(AOwner: TNFe);
begin
  inherited Create;
  FNFe := AOwner;
end;

destructor TNFeJSONWriter.Destroy;
begin
  inherited;
end;

function TNFeJSONWriter.GerarJSON: string;
var
  lRootJSONObj, lNFeJSONObj: TACBrJSONObject;
begin
  lRootJSONObj := TACBrJSONObject.Create;
  try
    lNFeJSONObj := TACBrJSONObject.Create;
    try
      GerarInfNFe(lNFeJSONObj);
      GerarInfNFeSupl(FNFe.infNFeSupl, lNFeJSONObj);
      lRootJSONObj.AddPair('NFe', lNFeJSONObj);
      Result := lRootJSONObj.ToJSON;
    finally
      //lNFeJSONObj.Free; --> lRootJSONObj é Owner e vai liberar
    end;
  finally
    lRootJSONObj.Free;
  end;
end;

procedure TNFeJSONWriter.GerarInfNFe(AJSONObject: TACBrJSONObject);
var
  lInfNFeJSONObj: TACBrJSONObject;
begin
  lInfNFeJSONObj := TACBrJSONObject.Create;
  lInfNFeJSONObj.AddPair('Id', FNFe.infNFe.Id);
  lInfNFeJSONObj.AddPair('versao', FloatToStr(FNFe.infNFe.Versao));
  GerarIde(FNFe.Ide, lInfNFeJSONObj);
  GerarEmit(FNFe.Emit, lInfNFeJSONObj);
  GerarAvulsa(FNFe.Avulsa, lInfNFeJSONObj);
  GerarDest(FNFe.Dest, lInfNFeJSONObj);
  GerarRetirada(FNFe.Retirada, lInfNFeJSONObj);
  GerarEntrega(FNFe.Entrega, lInfNFeJSONObj);
  GerarAutXML(FNFe.autXML, lInfNFeJSONObj);
  GerarDet(FNFe.Det, lInfNFeJSONObj);
  GerarTotal(FNFe.Total, lInfNFeJSONObj);
  GerarTransp(FNFe.Transp, lInfNFeJSONObj);
  GerarCobr(FNFe.Cobr, lInfNFeJSONObj);
  GerarPag(FNFe.pag, lInfNFeJSONObj);
  GerarInfIntermed(FNFe.infIntermed, lInfNFeJSONObj);
  GerarInfAdic(FNFe.InfAdic, lInfNFeJSONObj);
  GerarExporta(FNFe.exporta, lInfNFeJSONObj);
  GerarCompra(FNFe.compra, lInfNFeJSONObj);
  GerarCana(FNFe.cana, lInfNFeJSONObj);
  GerarInfRespTec(FNFe.infRespTec, lInfNFeJSONObj);
  GerarAgropecuario(FNFe.agropecuario, lInfNFeJSONObj);

  AJSONObject.AddPair('infNFe', lInfNFeJSONObj);
end;

procedure TNFeJSONWriter.GerarIde(const AIde: TIde; AJSONObject: TACBrJSONObject);
var
  lIdeJSONObj: TACBrJSONObject;
begin
  lIdeJSONObj := TACBrJSONObject.Create;

  lIdeJSONObj.AddPair('cUF', AIde.cUF);
  lIdeJSONObj.AddPair('cNF', AIde.cNF);
  lIdeJSONObj.AddPair('natOp', AIde.natOp);
  lIdeJSONObj.AddPair('indPag', IndpagToStrEX(AIde.indPag));
  lIdeJSONObj.AddPair('mod', AIde.modelo);
  lIdeJSONObj.AddPair('serie', AIde.serie);
  lIdeJSONObj.AddPair('nNF', AIde.nNF);
  lIdeJSONObj.AddPairISODateTime('dhEmi', AIde.dEmi);
  lIdeJSONObj.AddPairISODateTime('dhSaiEnt', AIde.dSaiEnt);
  lIdeJSONObj.AddPair('tpNF', tpNFToStr(AIde.tpNF));
  lIdeJSONObj.AddPair('idDest', DestinoOperacaoToStr(AIde.idDest));
  lIdeJSONObj.AddPair('cMunFG', AIde.cMunFG);
  lIdeJSONObj.AddPair('cMunFGIBS', AIde.cMunFGIBS);
  lIdeJSONObj.AddPair('tpImp', TpImpToStr(AIde.tpImp));
  lIdeJSONObj.AddPair('tpEmis', TpEmisToStr(AIde.tpEmis));
  lIdeJSONObj.AddPair('cDV', AIde.cDV);
  lIdeJSONObj.AddPair('tpAmb', TpAmbToStr(AIde.tpAmb));
  lIdeJSONObj.AddPair('finNFe', FinNFeToStr(AIde.finNFe));
  lIdeJSONObj.AddPair('tpNFDebito', tpNFDebitoToStr(AIde.tpNFDebito));
  lIdeJSONObj.AddPair('tpNFCredito', tpNFCreditoToStr(AIde.tpNFCredito));
  lIdeJSONObj.AddPair('indFinal', ConsumidorFinalToStr(AIde.indFinal));
  lIdeJSONObj.AddPair('indPres', PresencaCompradorToStr(AIde.indPres));
  lIdeJSONObj.AddPair('indIntermed', IndIntermedToStr(AIde.indIntermed));
  lIdeJSONObj.AddPair('procEmi', procEmiToStr(AIde.procEmi));
  lIdeJSONObj.AddPair('verProc', AIde.verProc);
  lIdeJSONObj.AddPairISODateTime('dhCont', AIde.dhCont);
  lIdeJSONObj.AddPair('xJust', AIde.xJust);

  GerarIdeNFref(AIde.NFref, lIdeJSONObj);
  Gerar_gCompraGov(AIde.gCompraGov, lIdeJSONObj);
  Gerar_gPagAntecipado(AIde.gPagAntecipado, lIdeJSONObj);

  AJSONObject.AddPair('ide', lIdeJSONObj);
end;

procedure TNFeJSONWriter.GerarIdeNFref(const ANFRef: TNFrefCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lNfRefJSONArray: TACBrJSONArray;
  lRefJSONObj, lRefDocNaoEletronicoJSONObj: TACBrJSONObject;
begin
  if ANFRef.Count = 0 then
    exit;

  lNfRefJSONArray := TACBrJSONArray.Create;
  for i := 0 to ANFRef.Count - 1 do
  begin
    if Trim(ANFRef[i].refNFe) <> '' then
    begin
      lRefJSONObj := TACBrJSONObject.Create;
      lRefJSONObj.AddPair('refNFe', ANFRef[i].refNFe);
      lNfRefJSONArray.AddElementJSON(lRefJSONObj);
      continue;
    end;
    if Trim(ANFRef[i].refNFeSig) <> '' then
    begin
      lRefJSONObj := TACBrJSONObject.Create;
      lRefJSONObj.AddPair('refNFeSig', ANFRef[i].refNFeSig);
      lNfRefJSONArray.AddElementJSON(lRefJSONObj);
      continue;
    end;
    if Trim(ANFRef[i].refCTe) <> '' then
    begin
      lRefJSONObj := TACBrJSONObject.Create;
      lRefJSONObj.AddPair('refCTe', ANFRef[i].refCTe);
      lNfRefJSONArray.AddElementJSON(lRefJSONObj);
      continue;
    end;

    if (ANFRef[i].RefNF.nNF > 0) and (ANFRef[i].RefNF.cUF > 0) then
    begin
      lRefDocNaoEletronicoJSONObj := TACBrJSONObject.Create;
      lRefDocNaoEletronicoJSONObj.AddPair('AAMM', ANFRef[i].RefNF.AAMM);
      lRefDocNaoEletronicoJSONObj.AddPair('CNPJ', ANFRef[i].RefNF.CNPJ);
      lRefDocNaoEletronicoJSONObj.AddPair('cUF', ANFRef[i].RefNF.cUF);
      lRefDocNaoEletronicoJSONObj.AddPair('modelo', ANFRef[i].RefNF.modelo);
      lRefDocNaoEletronicoJSONObj.AddPair('nNF', ANFRef[i].RefNF.nNF);
      lRefDocNaoEletronicoJSONObj.AddPair('serie', ANFRef[i].RefNF.serie);

      lRefJSONObj := TACBrJSONObject.Create;
      lRefJSONObj.AddPair('refNF', lRefDocNaoEletronicoJSONObj);
      lNfRefJSONArray.AddElementJSON(lRefJSONObj);
      continue;
    end;

    if (ANFRef[i].RefNFP.nNF > 0) and (ANFRef[i].RefNFP.cUF > 0) then
    begin
      lRefDocNaoEletronicoJSONObj := TACBrJSONObject.Create;
      lRefDocNaoEletronicoJSONObj.AddPair('nNF', ANFRef[i].RefNFP.nNF);
      lRefDocNaoEletronicoJSONObj.AddPair('modelo', ANFRef[i].RefNFP.modelo);
      lRefDocNaoEletronicoJSONObj.AddPair('cUF', ANFRef[i].RefNFP.cUF);
      lRefDocNaoEletronicoJSONObj.AddPair('AAMM', ANFRef[i].RefNFP.AAMM);
      lRefDocNaoEletronicoJSONObj.AddPair('CNPJCPF', ANFRef[i].RefNFP.CNPJCPF);
      lRefDocNaoEletronicoJSONObj.AddPair('IE', ANFRef[i].RefNFP.IE);
      lRefDocNaoEletronicoJSONObj.AddPair('serie', ANFRef[I].RefNFP.serie);

      lRefJSONObj := TACBrJSONObject.Create;
      lRefJSONObj.AddPair('refNFP', lRefDocNaoEletronicoJSONObj);
      lNfRefJSONArray.AddElementJSON(lRefJSONObj);
      continue;
    end;

    if Trim(ANFRef[i].RefECF.nECF) <> '' then
    begin
      lRefDocNaoEletronicoJSONObj := TACBrJSONObject.Create;
      lRefDocNaoEletronicoJSONObj.AddPair('modelo', ECFModRefToStr(ANFRef[i].RefECF.modelo));
      lRefDocNaoEletronicoJSONObj.AddPair('nCOO', ANFRef[i].RefECF.nCOO);
      lRefDocNaoEletronicoJSONObj.AddPair('nECF', ANFRef[i].RefECF.nECF);

      lRefJSONObj := TACBrJSONObject.Create;
      lRefJSONObj.AddPair('refECF', lRefDocNaoEletronicoJSONObj);
      lNfRefJSONArray.AddElementJSON(lRefJSONObj);
      continue;
    end;
  end;

  AJSONObject.AddPair('NFref', lNfRefJSONArray);
end;

procedure TNFeJSONWriter.GerarEmit(const AEmit: TEmit; AJSONObject: TACBrJSONObject);
var
  lEmitJSONObj: TACBrJSONObject;
begin
  lEmitJSONObj := TACBrJSONObject.Create;

  if Length(AEmit.CNPJCPF) = 14 then
    lEmitJSONObj.AddPair('CNPJ', AEmit.CNPJCPF)
  else if Length(AEmit.CNPJCPF) = 11 then
    lEmitJSONObj.AddPair('CPF', AEmit.CNPJCPF);

  lEmitJSONObj.AddPair('xNome', AEmit.xNome);
  lEmitJSONObj.AddPair('xFant', AEmit.xFant);
  lEmitJSONObj.AddPair('IE', AEmit.IE);
  lEmitJSONObj.AddPair('IEST', AEmit.IEST);
  lEmitJSONObj.AddPair('IM', AEmit.IM);
  lEmitJSONObj.AddPair('CNAE', AEmit.CNAE);
  lEmitJSONObj.AddPair('CRT', CRTToStr(AEmit.CRT));

  GerarEmitEnderEmit(AEmit.enderEmit, lEmitJSONObj);

  AJSONObject.AddPair('emit', lEmitJSONObj);
end;

procedure TNFeJSONWriter.GerarEmitEnderEmit(const AEnderEmit: TenderEmit; AJSONObject: TACBrJSONObject);
var
  lEnderEmitJSONObj: TACBrJSONObject;
begin
  lEnderEmitJSONObj := TACBrJSONObject.Create;
  lEnderEmitJSONObj.AddPair('xLgr', AEnderEmit.xLgr);
  lEnderEmitJSONObj.AddPair('nro', AEnderEmit.nro);
  lEnderEmitJSONObj.AddPair('xCpl', AEnderEmit.xCpl);
  lEnderEmitJSONObj.AddPair('xBairro', AEnderEmit.xBairro);
  lEnderEmitJSONObj.AddPair('cMun', AEnderEmit.cMun);
  lEnderEmitJSONObj.AddPair('xMun', AEnderEmit.xMun);
  lEnderEmitJSONObj.AddPair('UF', AEnderEmit.UF);
  lEnderEmitJSONObj.AddPair('CEP', AEnderEmit.CEP);
  lEnderEmitJSONObj.AddPair('cPais', AEnderEmit.cPais);
  lEnderEmitJSONObj.AddPair('xPais', AEnderEmit.xPais);
  lEnderEmitJSONObj.AddPair('fone', AEnderEmit.fone);

  AJSONObject.AddPair('enderEmit', lEnderEmitJSONObj);
end;

procedure TNFeJSONWriter.GerarAvulsa(const AAvulsa: TAvulsa; AJSONObject: TACBrJSONObject);
var
  lAvulsaJSONObj: TACBrJSONObject;
begin
  if Trim(AAvulsa.CNPJ) = '' then
    exit;

  lAvulsaJSONObj := TACBrJSONObject.Create;
  lAvulsaJSONObj.AddPair('CNPJ', AAvulsa.CNPJ);
  lAvulsaJSONObj.AddPair('xOrgao', AAvulsa.xOrgao);
  lAvulsaJSONObj.AddPair('matr', AAvulsa.matr);
  lAvulsaJSONObj.AddPair('xAgente', AAvulsa.xAgente);
  lAvulsaJSONObj.AddPair('fone', AAvulsa.fone);
  lAvulsaJSONObj.AddPair('UF', AAvulsa.UF);
  lAvulsaJSONObj.AddPair('nDAR', AAvulsa.nDAR);
  lAvulsaJSONObj.AddPairISODate('dEmi', AAvulsa.dEmi);
  lAvulsaJSONObj.AddPair('vDAR', AAvulsa.vDAR);
  lAvulsaJSONObj.AddPair('repEmi', AAvulsa.repEmi);
  lAvulsaJSONObj.AddPairISODate('dPag', AAvulsa.dPag);

  AJSONObject.AddPair('avulsa', lAvulsaJSONObj);
end;

procedure TNFeJSONWriter.GerarDest(const ADest: TDest; AJSONObject: TACBrJSONObject);
var
  lDestJSONObj: TACBrJSONObject;
begin
  if Trim(ADest.xNome) = '' then
    exit;

  lDestJSONObj := TACBrJSONObject.Create;
  if Length(ADest.CNPJCPF) = 14 then
    lDestJSONObj.AddPair('CNPJ', ADest.CNPJCPF)
  else if Length(ADest.CNPJCPF) = 11 then
    lDestJSONObj.AddPair('CPF', ADest.CNPJCPF);

  lDestJSONObj.AddPair('idEstrangeiro', ADest.idEstrangeiro);
  lDestJSONObj.AddPair('xNome', ADest.xNome);
  lDestJSONObj.AddPair('indIEDest', indIEDestToStr(ADest.indIEDest));
  lDestJSONObj.AddPair('IE', ADest.IE);
  lDestJSONObj.AddPair('ISUF', ADest.ISUF);
  lDestJSONObj.AddPair('IM', ADest.IM);
  lDestJSONObj.AddPair('email', ADest.Email);

  GerarDestEnderDest(ADest.EnderDest, lDestJSONObj);

  AJSONObject.AddPair('dest', lDestJSONObj);
end;

procedure TNFeJSONWriter.GerarDestEnderDest(const AEnderDest: TEnderDest; AJSONObject: TACBrJSONObject);
var
  lEnderDestJSONObj: TACBrJSONObject;
begin
  lEnderDestJSONObj := TACBrJSONObject.Create;
  lEnderDestJSONObj.AddPair('xLgr', AEnderDest.xLgr);
  lEnderDestJSONObj.AddPair('nro', AEnderDest.nro);
  lEnderDestJSONObj.AddPair('xCpl', AEnderDest.xCpl);
  lEnderDestJSONObj.AddPair('xBairro', AEnderDest.xBairro);
  lEnderDestJSONObj.AddPair('cMun', AEnderDest.cMun);
  lEnderDestJSONObj.AddPair('xMun', AEnderDest.xMun);
  lEnderDestJSONObj.AddPair('UF', AEnderDest.UF);
  lEnderDestJSONObj.AddPair('CEP', AEnderDest.CEP);
  lEnderDestJSONObj.AddPair('cPais', AEnderDest.cPais);
  lEnderDestJSONObj.AddPair('xPais', AEnderDest.xPais);
  lEnderDestJSONObj.AddPair('fone', AEnderDest.fone);

  AJSONObject.AddPair('enderDest', lEnderDestJSONObj);
end;

procedure TNFeJSONWriter.GerarRetirada(const ARetirada: TRetirada; AJSONObject: TACBrJSONObject);
var
  lRetiradaJSONObj: TACBrJSONObject;
begin
  if Trim(ARetirada.CNPJCPF) = '' then
    exit;

  lRetiradaJSONObj := TACBrJSONObject.Create;

  if Length(ARetirada.CNPJCPF) = 14 then
    lRetiradaJSONObj.AddPair('CNPJ', ARetirada.CNPJCPF)
  else if Length(ARetirada.CNPJCPF) = 11 then
    lRetiradaJSONObj.AddPair('CPF', ARetirada.CNPJCPF);

  lRetiradaJSONObj.AddPair('xNome', ARetirada.xNome);
  lRetiradaJSONObj.AddPair('xLgr', ARetirada.xLgr);
  lRetiradaJSONObj.AddPair('nro', ARetirada.nro);
  lRetiradaJSONObj.AddPair('xCpl', ARetirada.xCpl);
  lRetiradaJSONObj.AddPair('xBairro', ARetirada.xBairro);
  lRetiradaJSONObj.AddPair('cMun', ARetirada.cMun);
  lRetiradaJSONObj.AddPair('xMun', ARetirada.xMun);
  lRetiradaJSONObj.AddPair('UF', ARetirada.UF);
  lRetiradaJSONObj.AddPair('CEP', ARetirada.CEP);
  lRetiradaJSONObj.AddPair('cPais', ARetirada.cPais);
  lRetiradaJSONObj.AddPair('xPais', ARetirada.xPais);
  lRetiradaJSONObj.AddPair('fone', ARetirada.fone);
  lRetiradaJSONObj.AddPair('email', ARetirada.Email);
  lRetiradaJSONObj.AddPair('IE', ARetirada.IE);

  AJSONObject.AddPair('retirada', lRetiradaJSONObj);
end;

procedure TNFeJSONWriter.GerarEntrega(const AEntrega: TEntrega; AJSONObject: TACBrJSONObject);
var
  lEntregaJSONObj: TACBrJSONObject;
begin
  if (Trim(AEntrega.CNPJCPF) = '') and (Trim(AEntrega.xLgr) = '') then
    exit;

  lEntregaJSONObj := TACBrJSONObject.Create;
  if Length(AEntrega.CNPJCPF) = 14 then
    lEntregaJSONObj.AddPair('CNPJ', AEntrega.CNPJCPF)
  else if Length(AEntrega.CNPJCPF) = 11 then
    lEntregaJSONObj.AddPair('CPF', AEntrega.CNPJCPF);

  lEntregaJSONObj.AddPair('xNome', AEntrega.xNome);
  lEntregaJSONObj.AddPair('xLgr', AEntrega.xLgr);
  lEntregaJSONObj.AddPair('nro', AEntrega.nro);
  lEntregaJSONObj.AddPair('xCpl', AEntrega.xCpl);
  lEntregaJSONObj.AddPair('xBairro', AEntrega.xBairro);
  lEntregaJSONObj.AddPair('cMun', AEntrega.cMun);
  lEntregaJSONObj.AddPair('xMun', AEntrega.xMun);
  lEntregaJSONObj.AddPair('UF', AEntrega.UF);
  lEntregaJSONObj.AddPair('CEP', AEntrega.CEP);
  lEntregaJSONObj.AddPair('cPais', AEntrega.cPais);
  lEntregaJSONObj.AddPair('xPais', AEntrega.xPais);
  lEntregaJSONObj.AddPair('fone', AEntrega.fone);
  lEntregaJSONObj.AddPair('email', AEntrega.Email);
  lEntregaJSONObj.AddPair('IE', AEntrega.IE);

  AJSONObject.AddPair('entrega', lEntregaJSONObj);
end;

procedure TNFeJSONWriter.GerarAutXML(const AAutXML: TautXMLCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lAutXMLJSONArray: TACBrJSONArray;
  lAutXMLJSONObj: TACBrJSONObject;
begin
  if AAutXML.Count = 0 then
    exit;

  lAutXMLJSONArray := TACBrJSONArray.Create;
  for i := 0 to AAutXML.Count - 1 do
  begin
    lAutXMLJSONObj := TACBrJSONObject.Create;
    try
      if Length(AAutXML[i].CNPJCPF) = 14 then
        lAutXMLJSONObj.AddPair('CNPJ', AAutXML[i].CNPJCPF)
      else if Length(AAutXML[i].CNPJCPF) = 11 then
        lAutXMLJSONObj.AddPair('CPF', AAutXML[i].CNPJCPF);

      lAutXMLJSONArray.AddElementJSON(lAutXMLJSONObj);
    finally
      //lAutXMLJSONObj.Free; -> O Array passa a ser o owner.
    end;
  end;

  AJSONObject.AddPair('autXML', lAutXMLJSONArray);
end;

procedure TNFeJSONWriter.GerarDet(const ADet: TDetCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lDetJSONArray: TACBrJSONArray;
  lDetJSONObj, lImpostoDevolJSONObj, lIPIJSONObj, lObsItemJSONObj: TACBrJSONObject;
  lDetItem: TDetCollectionItem;
begin
  if ADet.Count = 0 then
    exit;

  lDetJSONArray := TACBrJSONArray.Create;
  for i := 0 to ADet.Count - 1 do
  begin
    lDetItem := ADet[i];
    lDetJSONObj := TACBrJSONObject.Create;
    try
      lDetJSONObj.AddPair('nItem', lDetItem.prod.nItem);
      GerarDetProd(lDetItem.Prod, lDetJSONObj);
      GerarDetImposto(lDetItem.Imposto, lDetJSONObj);
      lDetJSONObj.AddPair('infAdProd', lDetItem.infAdProd);

      if lDetItem.pDevol > 0 then
      begin
        lImpostoDevolJSONObj := TACBrJSONObject.Create;
        try
          lImpostoDevolJSONObj.AddPair('pDevol', lDetItem.pDevol);

          if lDetItem.vIPIDevol > 0 then
          begin
            lIPIJSONObj := TACBrJSONObject.Create;
            try
              lIPIJSONObj.AddPair('vIPIDevol', lDetItem.vIPIDevol);
              lImpostoDevolJSONObj.AddPair('IPI', lIPIJSONObj);
            finally
              //lIPIJSONObj.Free;
            end;
          end;

          lDetJSONObj.AddPair('impostoDevol', lImpostoDevolJSONObj);
        finally
          //lImpostoDevolJSONObj.Free;
        end;
      end;

      if (lDetItem.obsCont.xCampo <> '') or (lDetItem.obsFisco.xCampo <> '') then
      begin
        lObsItemJSONObj := TACBrJSONObject.Create;
        try
          GerarDetObs(lDetItem.obsCont, 'obsCont', lObsItemJSONObj);
          GerarDetObs(lDetItem.obsFisco, 'obsFisco', lObsItemJSONObj);
          lDetJSONObj.AddPair('obsItem', lObsItemJSONObj);
        finally
          //lObsItemJSONObj.Free;
        end;
      end;

      if lDetItem.vItem > 0 then
        lDetJSONObj.AddPair('vItem', lDetItem.vItem);

      Gerar_Det_DFeReferenciado(lDetItem.DFeReferenciado, lDetJSONObj);

      lDetJSONArray.AddElementJSON(lDetJSONObj);
    finally
      //lDetJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('det', lDetJSONArray);
end;

procedure TNFeJSONWriter.GerarDetProd(const AProd: TProd; AJSONObject: TACBrJSONObject);
var
  lProdJSONObj: TACBrJSONObject;
begin
  lProdJSONObj := TACBrJSONObject.Create;
  lProdJSONObj.AddPair('cProd', AProd.cProd);
  lProdJSONObj.AddPair('cEAN', AProd.cEAN);
  lProdJSONObj.AddPair('cBarra', AProd.cBarra);
  lProdJSONObj.AddPair('xProd', AProd.xProd);
  lProdJSONObj.AddPair('NCM', AProd.NCM);
  lProdJSONObj.AddPair('CEST', AProd.CEST);
  if AProd.indEscala <> ieNenhum then
    lProdJSONObj.AddPair('indEscala', indEscalaToStr(AProd.indEscala));
  lProdJSONObj.AddPair('CNPJFab', AProd.CNPJFab);
  lProdJSONObj.AddPair('cBenef', AProd.cBenef);
  lProdJSONObj.AddPair('EXTIPI', AProd.EXTIPI);
  lProdJSONObj.AddPair('CFOP', AProd.CFOP);
  lProdJSONObj.AddPair('uCom', AProd.uCom);
  lProdJSONObj.AddPair('qCom', AProd.qCom);
  lProdJSONObj.AddPair('vUnCom', AProd.vUnCom);
  lProdJSONObj.AddPair('vProd', AProd.vProd);
  lProdJSONObj.AddPair('cEANTrib', AProd.cEANTrib);
  lProdJSONObj.AddPair('cBarraTrib', AProd.cBarraTrib);
  lProdJSONObj.AddPair('uTrib', AProd.uTrib);
  lProdJSONObj.AddPair('qTrib', AProd.qTrib);
  lProdJSONObj.AddPair('vUnTrib', AProd.vUnTrib);
  lProdJSONObj.AddPair('vFrete', AProd.vFrete);
  lProdJSONObj.AddPair('vSeg', AProd.vSeg);
  lProdJSONObj.AddPair('vDesc', AProd.vDesc);
  lProdJSONObj.AddPair('vOutro', AProd.vOutro);
  lProdJSONObj.AddPair('indTot', indTotToStr(AProd.IndTot));
  lProdJSONObj.AddPair('xPed', AProd.xPed);
  lProdJSONObj.AddPair('nItemPed', AProd.nItemPed);
  lProdJSONObj.AddPair('nRECOPI', AProd.nRECOPI);
  lProdJSONObj.AddPair('nFCI', AProd.nFCI);
  // Reforma Tributria
  lProdJSONObj.AddPair('indBemMovelUsado', TIndicadorExToStr(AProd.indBemMovelUsado));

  GerarDetProd_CredPresumido(AProd.CredPresumido, lProdJSONObj);
  GerarDetProd_NVE(AProd.NVE, lProdJSONObj);
  GerarDetProd_DI(AProd.DI, lProdJSONObj);
  GerarDetProd_DetExport(AProd.detExport, lProdJSONObj);
  GerarDetProd_Rastro(AProd.rastro, lProdJSONObj);
  GerarDetProd_veicProd(AProd.veicProd, lProdJSONObj);
  GerarDetProd_Med(AProd.med, lProdJSONObj);
  GerarDetProd_Arma(AProd.arma, lProdJSONObj);
  GerarDetProd_Comb(AProd.comb, lProdJSONObj);

  AJSONObject.AddPair('prod', lProdJSONObj);
end;

procedure TNFeJSONWriter.GerarDetProd_CredPresumido(const ACredPresumido: TCredPresumidoCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lCredPresumidoJSONArray: TACBrJSONArray;
  lCredPresumidoJSONObj: TACBrJSONObject;
begin
  if ACredPresumido.Count = 0 then
    exit;

  lCredPresumidoJSONArray := TACBrJSONArray.Create;
  for i := 0 to ACredPresumido.Count - 1 do
  begin
    lCredPresumidoJSONObj := TACBrJSONObject.Create;
    try
      lCredPresumidoJSONObj.AddPair('cCredPresumido', ACredPresumido[i].cCredPresumido);
      lCredPresumidoJSONObj.AddPair('pCredPresumido', ACredPresumido[i].pCredPresumido);
      lCredPresumidoJSONObj.AddPair('vCredPresumido', ACredPresumido[i].vCredPresumido);
      lCredPresumidoJSONArray.AddElementJSON(lCredPresumidoJSONObj);
    finally
      //lCredPresumidoJSONObj.Free;
    end;
  end;
  AJSONObject.AddPair('gCred', lCredPresumidoJSONArray);
end;

procedure TNFeJSONWriter.GerarDetProd_NVE(const ANVe: TNVECollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lNVEJSONArray: TACBrJSONArray;
  lNVEJSONObj: TACBrJSONObject;
begin
  if ANVe.Count = 0 then
    exit;

  lNVEJSONArray := TACBrJSONArray.Create;
  for i := 0 to ANVe.Count - 1 do
  begin
    lNVEJSONObj := TACBrJSONObject.Create;
    try
      lNVEJSONObj.AddPair('NVE', ANVE[i].NVE);
      lNVEJSONArray.AddElementJSON(lNVEJSONObj);
    finally
      //lNVEJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('NVE', lNVEJSONArray);
end;

procedure TNFeJSONWriter.GerarDetProd_DI(const ADI: TDICollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lDIJSONArray: TACBrJSONArray;
  lDIJSONObj: TACBrJSONObject;
begin
  if ADI.Count = 0 then
    exit;

  lDIJSONArray := TACBrJSONArray.Create;
  for i := 0 to ADI.Count - 1 do
  begin
    lDIJSONObj := TACBrJSONObject.Create;
    try
      lDIJSONObj.AddPair('nDI', ADI[i].nDI);
      lDIJSONObj.AddPairISODate('dDI', ADI[i].dDI);
      lDIJSONObj.AddPair('xLocDesemb', ADI[i].xLocDesemb);
      lDIJSONObj.AddPair('UFDesemb', ADI[i].UFDesemb);
      lDIJSONObj.AddPairISODate('dDesemb', ADI[i].dDesemb);
      lDIJSONObj.AddPair('tpViaTransp', TipoViaTranspToStr(ADI[i].tpViaTransp));
      lDIJSONObj.AddPair('vAFRMM', ADI[i].vAFRMM);
      lDIJSONObj.AddPair('tpIntermedio', TipoIntermedioToStr(ADI[i].tpIntermedio));

      if Length(ADI[i].CNPJ) = 14 then
        lDIJSONObj.AddPair('CNPJ', ADI[i].CNPJ)
      else if Length(ADI[i].CNPJ) = 11 then
        lDIJSONObj.AddPair('CPF', ADI[i].CNPJ);

      lDIJSONObj.AddPair('UFTerceiro', ADI[i].UFTerceiro);
      lDIJSONObj.AddPair('cExportador', ADI[i].cExportador);

      GerarDetProd_DIAdi(ADI[i].adi, lDIJSONObj);

      lDIJSONArray.AddElementJSON(lDIJSONObj);
    finally
      //lDIJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('DI', lDIJSONArray);
end;

procedure TNFeJSONWriter.GerarDetProd_DIAdi(const AAdi: TAdiCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lAdiJSONArray: TACBrJSONArray;
  lAdiJSONObj: TACBrJSONObject;
begin
  if AAdi.Count = 0 then
    exit;

  lAdiJSONArray := TACBrJSONArray.Create;
  for i := 0 to AAdi.Count - 1 do
  begin
    lAdiJSONObj := TACBrJSONObject.Create;
    try
      lAdiJSONObj.AddPair('nAdicao', AAdi[i].nAdicao);
      lAdiJSONObj.AddPair('nSeqAdic', AAdi[i].nSeqAdi);
      lAdiJSONObj.AddPair('cFabricante', AAdi[i].cFabricante);
      lAdiJSONObj.AddPair('vDescDI', AAdi[i].vDescDI);
      lAdiJSONObj.AddPair('nDraw', AAdi[i].nDraw);
      lAdiJSONArray.AddElementJSON(lAdiJSONObj);
    finally
      //lAdiJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('adi', lAdiJSONArray);
end;

procedure TNFeJSONWriter.GerarDetProd_DetExport(const ADetExport: TdetExportCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lDetExportJSONArray: TACBrJSONArray;
  lDetExportJSONObj, lExportIndJSONObj: TACBrJSONObject;
begin
  if ADetExport.Count = 0 then
    exit;

  lDetExportJSONArray := TACBrJSONArray.Create;
  for i := 0 to ADetExport.Count - 1 do
  begin
    lDetExportJSONObj := TACBrJSONObject.Create;
    try
      lDetExportJSONObj.AddPair('nDraw', ADetExport[i].nDraw);

      if (ADetExport[i].nRE <> '') or (ADetExport[i].chNFe <> '') or (ADetExport[i].qExport > 0) then
      begin
        lExportIndJSONObj := TACBrJSONObject.Create;
        try
          lExportIndJSONObj.AddPair('nRE', ADetExport[i].nRE);
          lExportIndJSONObj.AddPair('chNFe', ADetExport[i].chNFe);
          lExportIndJSONObj.AddPair('qExport', ADetExport[i].qExport);
          lDetExportJSONObj.AddPair('exportInd', lExportIndJSONObj);
        finally
          //lExportIndJSONObj.Free;
        end;
      end;

      lDetExportJSONArray.AddElementJSON(lDetExportJSONObj);
    finally
      //lDetExportJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('detExport', lDetExportJSONArray);
end;

procedure TNFeJSONWriter.GerarDetProd_Rastro(const ARastro: TRastroCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lRastroJSONArray: TACBrJSONArray;
  lRastroJSONObj: TACBrJSONObject;
begin
  if ARastro.Count = 0 then
    exit;

  lRastroJSONArray := TACBrJSONArray.Create;
  for i := 0 to ARastro.Count - 1 do
  begin
    lRastroJSONObj := TACBrJSONObject.Create;
    try
      lRastroJSONObj.AddPair('nLote', ARastro[i].nLote);
      lRastroJSONObj.AddPair('qLote', ARastro[i].qLote);
      lRastroJSONObj.AddPairISODate('dFab', ARastro[i].dFab);
      lRastroJSONObj.AddPairISODate('dVal', ARastro[i].dVal);
      lRastroJSONObj.AddPair('cAgreg', ARastro[i].cAgreg);
      lRastroJSONArray.AddElementJSON(lRastroJSONObj);
    finally
      //lRastroJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('rastro', lRastroJSONArray);
end;

procedure TNFeJSONWriter.GerarDetProd_VeicProd(const AVeicProd: TveicProd; AJSONObject: TACBrJSONObject);
var
  lVeicProd: TACBrJSONObject;
begin
  if Trim(AVeicProd.chassi) = '' then
    exit;

  lVeicProd := TACBrJSONObject.Create;
  try
    lVeicProd.AddPair('tpOp', TpOPToStr(AVeicProd.tpOP));
    lVeicProd.AddPair('chassi', AVeicProd.chassi);
    lVeicProd.AddPair('cCor', AVeicProd.cCor);
    lVeicProd.AddPair('xCor', AVeicProd.xCor);
    lVeicProd.AddPair('pot', AVeicProd.pot);
    lVeicProd.AddPair('cilin', AVeicProd.Cilin);
    lVeicProd.AddPair('pesoL', AVeicProd.pesoL);
    lVeicProd.AddPair('pesoB', AVeicProd.pesoB);
    lVeicProd.AddPair('nSerie', AVeicProd.nSerie);
    lVeicProd.AddPair('tpComb', AVeicProd.tpComb);
    lVeicProd.AddPair('nMotor', AVeicProd.nMotor);
    lVeicProd.AddPair('CMT', AVeicProd.CMT);
    lVeicProd.AddPair('dist', AVeicProd.dist);
    lVeicProd.AddPair('anoMod', AVeicProd.anoMod);
    lVeicProd.AddPair('anoFab', AVeicProd.anoFab);
    lVeicProd.AddPair('tpPint', AVeicProd.tpPint);
    lVeicProd.AddPair('tpVeic', AVeicProd.tpVeic);
    lVeicProd.AddPair('espVeic', AVeicProd.espVeic);
    lVeicProd.AddPair('VIN', AVeicProd.VIN);
    lVeicProd.AddPair('condVeic', CondVeicToStr(AVeicProd.condVeic));
    lVeicProd.AddPair('cMod', AVeicProd.cMod);
    lVeicProd.AddPair('cCorDENATRAN', AVeicProd.cCorDENATRAN);
    lVeicProd.AddPair('lota', AVeicProd.lota);
    lVeicProd.AddPair('tpRest', AVeicProd.tpRest);

    AJSONObject.AddPair('veicProd', lVeicProd);
  finally
    //lVeicProd.Free AJSONObect é o Owner e vai liberar da memória.
  end;
end;

procedure TNFeJSONWriter.GerarDetProd_Med(const AMed: TMedCollection; AJSONObject: TACBrJSONObject);
var
  lMedJSONObj: TACBrJSONObject;
begin
  if (AMed.Count = 0) then
    exit;

  lMedJSONObj := TACBrJSONObject.Create;
  try
    lMedJSONObj.AddPair('cProdANVISA', AMed[0].cProdANVISA);
    lMedJSONObj.AddPair('xMotivoIsencao', AMed[0].xMotivoIsencao);
    lMedJSONObj.AddPair('nLote', AMed[0].nLote);
    lMedJSONObj.AddPair('qLote', AMed[0].qLote);
    lMedJSONObj.AddPairISODate('dFab', AMed[0].dFab);
    lMedJSONObj.AddPairISODate('dVal', AMed[0].dVal);
    lMedJSONObj.AddPair('vPMC', AMed[0].vPMC);

    AJSONObject.AddPair('med', lMedJSONObj);
  finally
    //lMedJSONObj.Free AJSONObject é o Owner e vai liberar da memória.
  end;
end;

procedure TNFeJSONWriter.GerarDetProd_Arma(const AArma: TArmaCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lArmaJSONArray: TACBrJSONArray;
  lArmaJSONObj: TACBrJSONObject;
begin
  if AArma.Count = 0 then
    exit;

  lArmaJSONArray := TACBrJSONArray.Create;
  for i := 0 to AArma.Count - 1 do
  begin
    lArmaJSONObj := TACBrJSONObject.Create;
    try
      lArmaJSONObj.AddPair('tpArma', TpArmaToStr(AArma[i].tpArma));
      lArmaJSONObj.AddPair('nSerie', AArma[i].nSerie);
      lArmaJSONObj.AddPair('nCano', AArma[i].nCano);
      lArmaJSONObj.AddPair('descr', AArma[i].descr);
      lArmaJSONArray.AddElementJSON(lArmaJSONObj);
    finally
      //lArmaJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('arma', lArmaJSONArray);
end;

procedure TNFeJSONWriter.GerarDetProd_Comb(const AComb: TComb; AJSONObject: TACBrJSONObject);
var
  lCombJSONObj: TACBrJSONObject;
begin
  if AComb.cProdANP = 0 then
    exit;

  lCombJSONObj := TACBrJSONObject.Create;
  lCombJSONObj.AddPair('cProdANP', AComb.cProdANP);
  lCombJSONObj.AddPair('qMixGN', AComb.pMixGN);
  lCombJSONObj.AddPair('descANP', AComb.descANP);
  lCombJSONObj.AddPair('pGLP', AComb.pGLP);
  lCombJSONObj.AddPair('pGNn', AComb.pGNn);
  lCombJSONObj.AddPair('pGNi', AComb.pGNi);
  lCombJSONObj.AddPair('vPart', AComb.vPart);
  lCombJSONObj.AddPair('CODIF', AComb.CODIF);
  lCombJSONObj.AddPair('qTemp', AComb.qTemp);
  lCombJSONObj.AddPair('UFCons', AComb.UFcons);
  lCombJSONObj.AddPair('pBio', AComb.pBio);

  GerarDetProd_CombCide(AComb.CIDE, lCombJSONObj);
  GerarDetProd_CombEncerrante(AComb.encerrante, lCombJSONObj);
  GerarDetProd_CombOrigComb(AComb.origComb, lCombJSONObj);
  GerarDetProd_CombICMSComb(AComb.ICMS, lCombJSONObj);
  GerarDetProd_CombICMSInter(AComb.ICMSInter, lCombJSONObj);
  GerarDetProd_CombICMSCons(AComb.ICMSCons, lCombJSONObj);

  AJSONObject.AddPair('comb', lCombJSONObj);
end;

procedure TNFeJSONWriter.GerarDetProd_CombCide(const ACide: TCIDE; AJSONObject: TACBrJSONObject);
var
  lCideJSONObj: TACBrJSONObject;
begin
  if ACIDE.qBCprod = 0 then
    exit;

  lCideJSONObj := TACBrJSONObject.Create;
  lCideJSONObj.AddPair('qBCProd', ACIDE.qBCprod);
  lCideJSONObj.AddPair('vAliqProd', ACIDE.vAliqProd);
  lCideJSONObj.AddPair('vCIDE', ACIDE.vCIDE);

  AJSONObject.AddPair('CIDE', lCideJSONObj);
end;

procedure TNFeJSONWriter.GerarDetProd_CombEncerrante(const AEncerrante: TEncerrante; AJSONObject: TACBrJSONObject);
var
  lEncerranteJSONObj: TACBrJSONObject;
begin
  if AEncerrante.nBico = 0 then
    exit;

  lEncerranteJSONObj := TACBrJSONObject.Create;
  lEncerranteJSONObj.AddPair('nBico', AEncerrante.nBico);
  lEncerranteJSONObj.AddPair('nBomba', AEncerrante.nBomba);
  lEncerranteJSONObj.AddPair('nTanque', AEncerrante.nTanque);
  lEncerranteJSONObj.AddPair('vEncIni', AEncerrante.vEncIni);
  lEncerranteJSONObj.AddPair('vEncFin', AEncerrante.vEncFin);

  AJSONObject.AddPair('encerrante', lEncerranteJSONObj);
end;

procedure TNFeJSONWriter.GerarDetProd_CombOrigComb(const AOrigComb: TorigCombCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lOrigCombJSONArray: TACBrJSONArray;
  lOrigCombJSONObj: TACBrJSONObject;
begin
  if AOrigComb.Count = 0 then
    exit;

  lOrigCombJSONArray := TACBrJSONArray.Create;
  for i := 0 to AOrigComb.Count - 1 do
  begin
    lOrigCombJSONObj := TACBrJSONObject.Create;
    try
      lOrigCombJSONObj.AddPair('indImport', indImportToStr(AOrigComb[i].indImport));
      lOrigCombJSONObj.AddPair('cUFOrig', AOrigComb[i].cUFOrig);
      lOrigCombJSONObj.AddPair('pOrig', AOrigComb[i].pOrig);
      lOrigCombJSONArray.AddElementJSON(lOrigCombJSONObj);
    finally
      //lOrigCombJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('origComb', lOrigCombJSONArray);
end;

procedure TNFeJSONWriter.GerarDetProd_CombICMSComb(const AICMS: TICMSComb; AJSONObject: TACBrJSONObject);
var
  lICMSCombJSONObj: TACBrJSONObject;
begin
  if AICMS.vBCICMS = 0 then
    exit;

  lICMSCombJSONObj := TACBrJSONObject.Create;
  lICMSCombJSONObj.AddPair('vBCICMS', AICMS.vBCICMS);
  lICMSCombJSONObj.AddPair('vICMS', AICMS.vICMS);
  lICMSCombJSONObj.AddPair('vBCICMSST', AICMS.vBCICMSST);
  lICMSCombJSONObj.AddPair('vICMSST', AICMS.vICMSST);

  AJSONObject.AddPair('ICMSComb', lICMSCombJSONObj);
end;

procedure TNFeJSONWriter.GerarDetProd_CombICMSInter(const AICMS: TICMSInter; AJSONObject: TACBrJSONObject);
var
  lICMSInterJSONObj: TACBrJSONObject;
begin
  if AICMS.vBCICMSSTDest = 0 then
    exit;

  lICMSInterJSONObj := TACBrJSONObject.Create;
  lICMSInterJSONObj.AddPair('vBCICMSSTDest', AICMS.vBCICMSSTDest);
  lICMSInterJSONObj.AddPair('vICMSSTDest', AICMS.vICMSSTDest);

  AJSONObject.AddPair('ICMSInter', lICMSInterJSONObj);
end;

procedure TNFeJSONWriter.GerarDetProd_CombICMSCons(const AICMS: TICMSCons; AJSONObject: TACBrJSONObject);
var
  lICMSConsJSONObj: TACBrJSONObject;
begin
  if AICMS.vBCICMSSTCons = 0 then
    exit;

  lICMSConsJSONObj := TACBrJSONObject.Create;
  lICMSConsJSONObj.AddPair('vBCICMSSTCons', AICMS.vBCICMSSTCons);
  lICMSConsJSONObj.AddPair('vICMSSTCons', AICMS.vICMSSTCons);
  lICMSConsJSONObj.AddPair('UFCons', AICMS.UFcons);

  AJSONObject.AddPair('ICMSCons', lICMSConsJSONObj);
end;

procedure TNFeJSONWriter.GerarDetImposto(const AImposto: TImposto; AJSONObject: TACBrJSONObject);
var
  lImpostoJSONObj: TACBrJSONObject;
begin
  lImpostoJSONObj := TACBrJSONObject.Create;
  lImpostoJSONObj.AddPair('vTotTrib', AImposto.vTotTrib);

  GerarDetImposto_ICMS(AImposto.ICMS, lImpostoJSONObj);
  GerarDetImposto_ICMSICMSUFDest(AImposto.ICMSUFDest, lImpostoJSONObj);
  GerarDetImposto_IPI(AImposto.IPI, lImpostoJSONObj);
  GerarDetImposto_II(AImposto.II, lImpostoJSONObj);
  GerarDetImposto_PIS(AImposto.PIS, lImpostoJSONObj);
  GerarDetImposto_PISST(AImposto.PISST, lImpostoJSONObj);
  GerarDetImposto_COFINS(AImposto.COFINS, lImpostoJSONObj);
  GerarDetImposto_COFINSST(AImposto.COFINSST, lImpostoJSONObj);
  GerarDetImposto_ISSQN(AImposto.ISSQN, lImpostoJSONObj);

  // Reforma Tributria
  Gerar_ISel(AImposto.ISel, lImpostoJSONObj);
  Gerar_IBSCBS(AImposto.IBSCBS, lImpostoJSONObj);

  AJSONObject.AddPair('imposto', lImpostoJSONObj);
end;

procedure TNFeJSONWriter.GerarDetImposto_ICMS(const AICMS: TICMS; AJSONObject: TACBrJSONObject);
var
  lNomeCST: string;
  lICMSJSONObj, lICMSCSTJSONObj: TACBrJSONObject;
begin
  if (AICMS.CST = cstVazio) and (AICMS.CSOSN = csosnVazio) then
    exit;

  lICMSCSTJSONObj := TACBrJSONObject.Create;
  lICMSCSTJSONObj.AddPair('orig', OrigToStr(AICMS.orig));
  case AICMS.CST of
    cst02, cst15, cst53, cst61:
      begin
        lICMSCSTJSONObj.AddPair('CST', CSTICMSToStr(AICMS.CST));
        case AICMS.CST of
          cst02:
            begin
              lNomeCST := 'ICMS02';
              lICMSCSTJSONObj.AddPair('qBCMono', AICMS.qBCMono);
              lICMSCSTJSONObj.AddPair('adRemICMS', AICMS.adRemICMS);
              lICMSCSTJSONObj.AddPair('vICMSMono', AICMS.vICMSMono);
            end;
          cst15:
            begin
              lNomeCST := 'ICMS15';
              lICMSCSTJSONObj.AddPair('qBCMono', AICMS.qBCMono);
              lICMSCSTJSONObj.AddPair('adRemICMS', AICMS.adRemICMS);
              lICMSCSTJSONObj.AddPair('vICMSMono', AICMS.vICMSMono);
              lICMSCSTJSONObj.AddPair('qBCMonoReten', AICMS.qBCMonoReten);
              lICMSCSTJSONObj.AddPair('adRemICMSReten', AICMS.adRemICMSReten);
              lICMSCSTJSONObj.AddPair('vICMSMonoReten', AICMS.vICMSMonoReten);
              if (AICMS.pRedAdRem > 0) then
              begin
                lICMSCSTJSONObj.AddPair('pRedAdRem', AICMS.pRedAdRem);
                lICMSCSTJSONObj.AddPair('motRedAdRem', motRedAdRemToStr(AICMS.motRedAdRem));
              end;
            end;
          cst53:
            begin
              lNomeCST := 'ICMS53';
              lICMSCSTJSONObj.AddPair('qBCMono', AICMS.qBCMono);
              lICMSCSTJSONObj.AddPair('adRemICMS', AICMS.adRemICMS);
              lICMSCSTJSONObj.AddPair('vICMSMonoOp', AICMS.vICMSMonoOp);
              lICMSCSTJSONObj.AddPair('pDif', AICMS.pDif);
              lICMSCSTJSONObj.AddPair('vICMSMonoDif', AICMS.vICMSMonoDif);
              lICMSCSTJSONObj.AddPair('vICMSMono', AICMS.vICMSMono);
            end;
          cst61:
            begin
              lNomeCST := 'ICMS61';
              lICMSCSTJSONObj.AddPair('qBCMonoRet', AICMS.qBCMonoRet);
              lICMSCSTJSONObj.AddPair('adRemICMSRet', AICMS.adRemICMSRet);
              lICMSCSTJSONObj.AddPair('vICMSMonoRet', AICMS.vICMSMonoRet);
            end;
        end;
      end;
    else
      begin
        case NFe.Emit.CRT of
          crtRegimeNormal, crtSimplesExcessoReceita:
            begin
              lICMSCSTJSONObj.AddPair('CST', CSTICMSToStr(AICMS.CST));
              case AICMS.CST of
                cst00:
                  begin
                    lNomeCST := 'ICMS00';
                    lICMSCSTJSONObj.AddPair('modBC', modBCToStr(AICMS.modBC));
                    lICMSCSTJSONObj.AddPair('vBC', AICMS.vBC);
                    lICMSCSTJSONObj.AddPair('pICMS', AICMS.pICMS);
                    lICMSCSTJSONObj.AddPair('vICMS', AICMS.vICMS);
                    if (AICMS.pFCP > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('pFCP', AICMS.pFCP);
                      lICMSCSTJSONObj.AddPair('vFCP', AICMS.vFCP);
                    end;
                  end;
                cst10:
                  begin
                    lNomeCST := 'ICMS10';
                    lICMSCSTJSONObj.AddPair('modBC', ModBCToStr(AICMS.modBC));
                    lICMSCSTJSONObj.AddPair('vBC', AICMS.vBC);
                    lICMSCSTJSONObj.AddPair('pICMS', AICMS.pICMS);
                    lICMSCSTJSONObj.AddPair('vICMS', AICMS.vICMS);
                    if (AICMS.vBCFCP > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCP', AICMS.vBCFCP);
                      lICMSCSTJSONObj.AddPair('pFCP', AICMS.pFCP);
                      lICMSCSTJSONObj.AddPair('vFCP', AICMS.vFCP);
                    end;
                    lICMSCSTJSONObj.AddPair('modBCST', ModBCSTToStr(AICMS.modBCST));
                    lICMSCSTJSONObj.AddPair('pMVAST', AICMS.pMVAST);
                    lICMSCSTJSONObj.AddPair('pRedBCST', AICMS.pRedBCST);
                    lICMSCSTJSONObj.AddPair('vBCST', AICMS.vBCST);
                    lICMSCSTJSONObj.AddPair('pICMSST', AICMS.pICMSST);
                    lICMSCSTJSONObj.AddPair('vICMSST', AICMS.vICMSST);
                    if (AICMS.vBCFCPST > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCPST', AICMS.vBCFCPST);
                      lICMSCSTJSONObj.AddPair('pFCPST', AICMS.pFCPST);
                      lICMSCSTJSONObj.AddPair('vFCPST', AICMS.vFCPST);
                    end;
                    lICMSCSTJSONObj.AddPair('vICMSSTDeson', AICMS.vICMSSTDeson);
                    lICMSCSTJSONObj.AddPair('motDesICMSST', motDesICMSToStr(AICMS.motDesICMSST));
                  end;
                cst20:
                  begin
                    lNomeCST := 'ICMS20';
                    lICMSCSTJSONObj.AddPair('modBC', ModBCToStr(AICMS.modBC));
                    lICMSCSTJSONObj.AddPair('pRedBC', AICMS.pRedBC);
                    lICMSCSTJSONObj.AddPair('vBC', AICMS.vBC);
                    lICMSCSTJSONObj.AddPair('pICMS', AICMS.pICMS);
                    lICMSCSTJSONObj.AddPair('vICMS', AICMS.vICMS);
                    if (AICMS.vBCFCP > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCP', AICMS.vBCFCP);
                      lICMSCSTJSONObj.AddPair('pFCP', AICMS.pFCP);
                      lICMSCSTJSONObj.AddPair('vFCP', AICMS.vFCP);
                    end;
                    if (AICMS.vICMSDeson > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vICMSDeson', AICMS.vICMSDeson);
                      lICMSCSTJSONObj.AddPair('motDesICMS', motDesICMSToStr(AICMS.motDesICMS));
                      lICMSCSTJSONObj.AddPair('indDeduzDeson', TIndicadorExToStr(AICMS.indDeduzDeson));
                    end;
                  end;
                cst30:
                  begin
                    lNomeCST := 'ICMS30';
                    lICMSCSTJSONObj.AddPair('modBCST', ModBCSTToStr(AICMS.modBCST));
                    lICMSCSTJSONObj.AddPair('pMVAST', AICMS.pMVAST);
                    lICMSCSTJSONObj.AddPair('pRedBCST', AICMS.pRedBCST);
                    lICMSCSTJSONObj.AddPair('vBCST', AICMS.vBCST);
                    lICMSCSTJSONObj.AddPair('pICMSST', AICMS.pICMSST);
                    lICMSCSTJSONObj.AddPair('vICMSST', AICMS.vICMSST);
                    if (AICMS.vBCFCPSTRet > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCPST', AICMS.vBCFCPST);
                      lICMSCSTJSONObj.AddPair('pFCPST', AICMS.pFCPST);
                      lICMSCSTJSONObj.AddPair('vFCPST', AICMS.vFCPST);
                    end;
                    if (AICMS.vICMSDeson > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vICMSDeson', AICMS.vICMSDeson);
                      lICMSCSTJSONObj.AddPair('motDesICMS', motDesICMSToStr(AICMS.motDesICMS));
                      lICMSCSTJSONObj.AddPair('indDeduzDeson', TIndicadorExToStr(AICMS.indDeduzDeson));
                    end;
                  end;
                cst40,
                cst41,
                cst50:
                  begin
                    lNomeCST := 'ICMS40';
                    lICMSCSTJSONObj.AddPair('vICMSDeson', AICMS.vICMSDeson);
                    lICMSCSTJSONObj.AddPair('motDesICMS', motDesICMSToStr(AICMS.motDesICMS));
                    lICMSCSTJSONObj.AddPAir('indDeduzDeson', TIndicadorExToStr(AICMS.indDeduzDeson));
                  end;
                cst51:
                  begin
                    lNomeCST := 'ICMS51';
                    lICMSCSTJSONObj.AddPair('modBC', ModBCToStr(AICMS.modBC));
                    lICMSCSTJSONObj.AddPair('pRedBC', AICMS.pRedBC);
                    lICMSCSTJSONObj.AddPair('cBenefRBC', AICMS.cBenefRBC);
                    lICMSCSTJSONObj.AddPair('vBC', AICMS.vBC);
                    lICMSCSTJSONObj.AddPair('pICMS', AICMS.pICMS);
                    lICMSCSTJSONObj.AddPair('vICMSOp', AICMS.vICMSOp);
                    lICMSCSTJSONObj.AddPair('pDif', AICMS.pDif);
                    lICMSCSTJSONObj.AddPair('vICMSDif', AICMS.vICMSDif);
                    lICMSCSTJSONObj.AddPair('vICMS', AICMS.vICMS);
                    if (AICMS.vBCFCP > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCP', AICMS.vBCFCP);
                      lICMSCSTJSONObj.AddPair('pFCP', AICMS.pFCP);
                      lICMSCSTJSONObj.AddPair('vFCP', AICMS.vFCP);
                    end;
                    if (AICMS.pFCPDif > 0)then
                    begin
                      lICMSCSTJSONObj.AddPair('pFCPDif', AICMS.pFCPDif);
                      lICMSCSTJSONObj.AddPair('vFCPDif', AICMS.vFCPDif);
                      lICMSCSTJSONObj.AddPair('vFCPEfet', AICMS.vFCPEfet);
                    end;
                  end;
                cst60:
                  begin
                    lNomeCST := 'ICMS60';
                    if (AICMS.vBCSTRet > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCSTRet', AICMS.vBCSTRet);
                      lICMSCSTJSONObj.AddPair('pST', AICMS.pST);
                      lICMSCSTJSONObj.AddPair('vICMSSubstituto', AICMS.vICMSSubstituto);
                      lICMSCSTJSONObj.AddPair('vICMSSTRet', AICMS.vICMSSTRet);
                    end;
                    if (AICMS.vBCFCPSTRet > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCPSTRet', AICMS.vBCFCPSTRet);
                      lICMSCSTJSONObj.AddPair('pFCPSTRet', AICMS.pFCPSTRet);
                      lICMSCSTJSONObj.AddPair('vFCPSTRet', AICMS.vFCPSTRet);
                    end;
                    if (AICMS.pRedBCEfet > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('pRedBCEfet', AICMS.pRedBCEfet);
                      lICMSCSTJSONObj.AddPair('vBCEfet', AICMS.vBCEfet);
                      lICMSCSTJSONObj.AddPair('pICMSEfet', AICMS.pICMSEfet);
                      lICMSCSTJSONObj.AddPair('vICMSEfet', AICMS.vICMSEfet);
                    end;
                  end;
                cst70:
                  begin
                    lNomeCST := 'ICMS70';
                    lICMSCSTJSONObj.AddPair('modBC', ModBCToStr(AICMS.modBC));
                    lICMSCSTJSONObj.AddPair('pRedBC', AICMS.pRedBC);
                    lICMSCSTJSONObj.AddPair('vBC', AICMS.vBC);
                    lICMSCSTJSONObj.AddPair('pICMS', AICMS.pICMS);
                    lICMSCSTJSONObj.AddPair('vICMS', AICMS.vICMS);
                    if (AICMS.vBCFCP > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCP', AICMS.vBCFCP);
                      lICMSCSTJSONObj.AddPair('pFCP', AICMS.pFCP);
                      lICMSCSTJSONObj.AddPair('vFCP', AICMS.vFCP);
                    end;
                    lICMSCSTJSONObj.AddPair('modBCST', ModBCSTToStr(AICMS.modBCST));
                    lICMSCSTJSONObj.AddPair('pMVAST', AICMS.pMVAST);
                    lICMSCSTJSONObj.AddPair('pRedBCST', AICMS.pRedBCST);
                    lICMSCSTJSONObj.AddPair('vBCST', AICMS.vBCST);
                    lICMSCSTJSONObj.AddPair('pICMSST', AICMS.pICMSST);
                    lICMSCSTJSONObj.AddPair('vICMSST', AICMS.vICMSST);
                    if (AICMS.vBCFCPST > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCPST', AICMS.vBCFCPST);
                      lICMSCSTJSONObj.AddPair('pFCPST', AICMS.pFCPST);
                      lICMSCSTJSONObj.AddPair('vFCPST', AICMS.vFCPST);
                    end;
                    if (AICMS.vICMSDeson > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vICMSDeson', AICMS.vICMSDeson);
                      lICMSCSTJSONObj.AddPair('motDesICMS', motDesICMSToStr(AICMS.motDesICMS));
                      lICMSCSTJSONObj.AddPair('indDeduzDeson', TIndicadorExToStr(AICMS.indDeduzDeson));
                    end;
                    if (AICMS.vICMSSTDeson > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vICMSSTDeson', AICMS.vICMSSTDeson);
                      lICMSCSTJSONObj.AddPair('motDesICMSST', motDesICMSToStr(AICMS.motDesICMSST));
                    end;
                  end;
                cst90:
                  begin
                    lNomeCST := 'ICMS90';
                    if (AICMS.vBC > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('modBC', ModBCToStr(AICMS.modBC));
                      lICMSCSTJSONObj.AddPair('pRedBC', AICMS.pRedBC);
                      lICMSCSTJSONObj.AddPair('vBC', AICMS.vBC);
                      lICMSCSTJSONObj.AddPair('pICMS', AICMS.pICMS);
                      lICMSCSTJSONObj.AddPair('vICMS', AICMS.vICMS);
                      if (AICMS.vBCFCP > 0) then
                      begin
                        lICMSCSTJSONObj.AddPair('vBCFCP', AICMS.vBCFCP);
                        lICMSCSTJSONObj.AddPair('pFCP', AICMS.pFCP);
                        lICMSCSTJSONObj.AddPair('vFCP', AICMS.vFCP);
                      end;
                    end;
                    if (AICMS.vBCST > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('modBCST', ModBCSTToStr(AICMS.modBCST));
                      lICMSCSTJSONObj.AddPair('pMVAST', AICMS.pMVAST);
                      lICMSCSTJSONObj.AddPair('pRedBCST', AICMS.pRedBCST);
                      lICMSCSTJSONObj.AddPair('vBCST', AICMS.vBCST);
                      lICMSCSTJSONObj.AddPair('pICMSST', AICMS.pICMSST);
                      lICMSCSTJSONObj.AddPair('vICMSST', AICMS.vICMSST);
                      if (AICMS.vFCPST > 0) then
                      begin
                        lICMSCSTJSONObj.AddPair('vBCFCPST', AICMS.vBCFCPST);
                        lICMSCSTJSONObj.AddPair('pFCPST', AICMS.pFCPST);
                        lICMSCSTJSONObj.AddPair('vFCPST', AICMS.vFCPST);
                      end;
                    end;
                    if (AICMS.vICMSDeson > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vICMSDeson', AICMS.vICMSDeson);
                      lICMSCSTJSONObj.AddPair('motDesICMS', motDesICMSToStr(AICMS.motDesICMS));
                      lICMSCSTJSONObj.AddPair('indDeduzDeson', TIndicadorExToStr(AICMS.indDeduzDeson));
                    end;
                    if (AICMS.vICMSSTDeson > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vICMSSTDeson', AICMS.vICMSSTDeson);
                      lICMSCSTJSONObj.AddPair('motDesICMSST', motDesICMSToStr(AICMS.motDesICMSST));
                    end;
                  end;
                cstPart10,
                cstPart90:
                  begin
                    lNomeCST := 'ICMSPart';
                    lICMSCSTJSONObj.AddPair('modBC', ModBCToStr(AICMS.modBC));
                    lICMSCSTJSONObj.AddPair('vBC', AICMS.vBC);
                    lICMSCSTJSONObj.AddPair('pRedBC', AICMS.pRedBC);
                    lICMSCSTJSONObj.AddPair('pICMS', AICMS.pICMS);
                    lICMSCSTJSONObj.AddPair('vICMS', AICMS.vICMS);
                    lICMSCSTJSONObj.AddPair('modBCST', ModBCSTToStr(AICMS.modBCST));
                    lICMSCSTJSONObj.AddPair('pMVAST', AICMS.pMVAST);
                    lICMSCSTJSONObj.AddPair('pRedBCST', AICMS.pRedBCST);
                    lICMSCSTJSONObj.AddPair('vBCST', AICMS.vBCST);
                    lICMSCSTJSONObj.AddPair('pICMSST', AICMS.pICMSST);
                    lICMSCSTJSONObj.AddPair('vICMSST', AICMS.vICMSST);
                    lICMSCSTJSONObj.AddPair('pBCOp', AICMS.pBCOp);
                    lICMSCSTJSONObj.AddPair('UFST', AICMS.UFST);
                  end;
                cstRep41,
                cstRep60:
                  begin
                    lNomeCST := 'ICMSST';
                    lICMSCSTJSONObj.AddPair('vBCSTRet', AICMS.vBCSTRet);
                    lICMSCSTJSONObj.AddPair('pST', AICMS.pST);
                    lICMSCSTJSONObj.AddPair('vICMSSubstituto', AICMS.vICMSSubstituto);
                    lICMSCSTJSONObj.AddPair('vICMSSTRet', AICMS.vICMSSTRet);

                    if (AICMS.vBCFCPSTRet > 0) or
                       (AICMS.pFCPSTRet > 0) or
                       (AICMS.vFCPSTRet > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCPSTRet', AICMS.vBCFCPSTRet);
                      lICMSCSTJSONObj.AddPair('pFCPSTRet', AICMS.pFCPSTRet);
                      lICMSCSTJSONObj.AddPair('vFCPSTRet', AICMS.vFCPSTRet);
                    end;

                    lICMSCSTJSONObj.AddPair('vBCSTDest', AICMS.vBCSTDest);
                    lICMSCSTJSONObj.AddPair('vICMSSTDest', AICMS.vICMSSTDest);

                    if (AICMS.pRedBCEfet > 0) or (AICMS.vBCEfet > 0) or
                       (AICMS.pICMSEfet > 0) or (AICMS.vICMSEfet > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('pRedBCEfet', AICMS.pRedBCEfet);
                      lICMSCSTJSONObj.AddPair('vBCEfet', AICMS.vBCEfet);
                      lICMSCSTJSONObj.AddPair('pICMSEfet', AICMS.pICMSEfet);
                      lICMSCSTJSONObj.AddPair('vICMSEfet', AICMS.vICMSEfet);
                    end;
                  end;
              end;
            end;
          crtSimplesNacional, crtMEI:
            begin
              lICMSCSTJSONObj.AddPair('CSOSN', CSOSNIcmsToStr(AICMS.CSOSN));
              case AICMS.CSOSN of
                csosn101:
                  begin
                    lNomeCST := 'ICMSSN101';
                    lICMSCSTJSONObj.AddPair('pCredSN', AICMS.pCredSN);
                    lICMSCSTJSONObj.AddPair('vCredICMSSN', AICMS.vCredICMSSN);
                  end;
                csosn102,
                csosn103,
                csosn300,
                csosn400:
                  begin
                    lNomeCST := 'ICMSSN102';
                    //Elementos orig e CSOSN já adicionados.
                  end;
                csosn201:
                  begin
                    lNomeCST := 'ICMSSN201';
                    lICMSCSTJSONObj.AddPair('modBCST', modBCSTToStr(AICMS.modBCST));
                    lICMSCSTJSONObj.AddPair('pMVAST', AICMS.pMVAST);
                    lICMSCSTJSONObj.AddPair('pRedBCST', AICMS.pRedBCST);
                    lICMSCSTJSONObj.AddPair('vBCST', AICMS.vBCST);
                    lICMSCSTJSONObj.AddPair('pICMSST', AICMS.pICMSST);
                    lICMSCSTJSONObj.AddPair('vICMSST', AICMS.vICMSST);

                    if (AICMS.vBCFCPST > 0) or (AICMS.pFCPST > 0) or (AICMS.vFCPST > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCPST', AICMS.vBCFCPST);
                      lICMSCSTJSONObj.AddPair('pFCPST', AICMS.pFCPST);
                      lICMSCSTJSONObj.AddPair('vFCPST', AICMS.vFCPST);
                    end;
                    lICMSCSTJSONObj.AddPair('pCredSN', AICMS.pCredSN);
                    lICMSCSTJSONObj.AddPair('vCredICMSSN', AICMS.vCredICMSSN);
                  end;
                csosn202,
                csosn203:
                  begin
                    lNomeCST := 'ICMSSN202';
                    lICMSCSTJSONObj.AddPair('modBCST', modBCSTToStr(AICMS.modBCST));
                    lICMSCSTJSONObj.AddPair('pMVAST', AICMS.pMVAST);
                    lICMSCSTJSONObj.AddPair('pRedBCST', AICMS.pRedBCST);
                    lICMSCSTJSONObj.AddPair('vBCST', AICMS.vBCST);
                    lICMSCSTJSONObj.AddPair('pICMSST', AICMS.pICMSST);
                    lICMSCSTJSONObj.AddPair('vICMSST', AICMS.vICMSST);

                    if (AICMS.vBCFCPST > 0) or (AICMS.pFCPST > 0) or (AICMS.vFCPST > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCPST', AICMS.vBCFCPST);
                      lICMSCSTJSONObj.AddPair('pFCPST', AICMS.pFCPST);
                      lICMSCSTJSONObj.AddPair('vFCPST', AICMS.vFCPST);
                    end;
                  end;
                csosn500:
                  begin
                    lNomeCST := 'ICMSSN500';
                    if (AICMS.vBCSTRET > 0) or (AICMS.pST > 0) or (AICMS.vICMSSubstituto > 0) or (AICMS.vICMSSTRET > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCSTRet', AICMS.vBCSTRET);
                      lICMSCSTJSONObj.AddPair('pST', AICMS.pST);
                      lICMSCSTJSONObj.AddPair('vICMSSubstituto', AICMS.vICMSSubstituto);
                      lICMSCSTJSONObj.AddPair('vICMSSTRet', AICMS.vICMSSTRet);
                    end;
                    if (AICMS.vBCFCPSTRet > 0) or (AICMS.pFCPSTRet > 0) or (AICMS.vFCPSTRet > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCPSTRet', AICMS.vBCFCPSTRet);
                      lICMSCSTJSONObj.AddPair('pFCPSTRet', AICMS.pFCPSTRet);
                      lICMSCSTJSONObj.AddPair('vFCPSTRet', AICMS.vFCPSTRet);
                    end;
                    if (AICMS.pRedBCEfet > 0) or (AICMS.vBCEfet > 0) or
                       (AICMS.pICMSEfet > 0) or (AICMS.vICMSEfet > 0)then
                    begin
                      lICMSCSTJSONObj.AddPair('pRedBCEfet', AICMS.pRedBCEfet);
                      lICMSCSTJSONObj.AddPair('vBCEfet', AICMS.vBCEfet);
                      lICMSCSTJSONObj.AddPair('pICMSEfet', AICMS.pICMSEfet);
                      lICMSCSTJSONObj.AddPair('vICMSEfet', AICMS.vICMSEfet);
                    end;
                  end;
                csosn900:
                  begin
                    lNomeCST := 'ICMSSN900';
                    if (AICMS.vBC > 0) or (AICMS.vICMS > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('modBC', modBCToStr(AICMS.modBC));
                      lICMSCSTJSONObj.AddPair('vBC', AICMS.vBC);
                      lICMSCSTJSONObj.AddPair('pRedBC', AICMS.pRedBC);
                      lICMSCSTJSONObj.AddPair('pICMS', AICMS.pICMS);
                      lICMSCSTJSONObj.AddPair('vICMS', AICMS.vICMS);
                    end;
                    if (AICMS.vBCST > 0) or (AICMS.vICMSST > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('modBCST', modBCSTToStr(AICMS.modBCST));
                      lICMSCSTJSONObj.AddPair('pMVAST', AICMS.pMVAST);
                      lICMSCSTJSONObj.AddPair('pRedBCST', AICMS.pRedBCST);
                      lICMSCSTJSONObj.AddPair('vBCST', AICMS.vBCST);
                      lICMSCSTJSONObj.AddPair('pICMSST', AICMS.pICMSST);
                      lICMSCSTJSONObj.AddPair('vICMSST', AICMS.vICMSST);
                    end;
                    if (AICMS.vBCFCPST > 0) or (AICMS.pFCPST > 0) or (AICMS.vBCFCPST > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('vBCFCPST', AICMS.vBCFCPST);
                      lICMSCSTJSONObj.AddPair('pFCPST', AICMS.pFCPST);
                      lICMSCSTJSONObj.AddPair('vFCPST', AICMS.vFCPST);
                    end;
                    if (AICMS.pCredSN > 0) then
                    begin
                      lICMSCSTJSONObj.AddPair('pCredSN', AICMS.pCredSN);
                      lICMSCSTJSONObj.AddPair('vCredICMSSN', AICMS.vCredICMSSN);
                    end;
                  end;
              end;
            end;
        end;
      end;
  end;
  lICMSJSONObj := TACBrJSONObject.Create;
  lICMSJSONObj.AddPair(lNomeCST, lICMSCSTJSONObj);
  AJSONObject.AddPair('ICMS', lICMSJSONObj);
end;

procedure TNFeJSONWriter.GerarDetImposto_ICMSICMSUFDest(const AICMSUfDest: TICMSUFDest; AJSONObject: TACBrJSONObject);
var
  lICMSUFDestJSONObj: TACBrJSONObject;
begin
  if AICMSUfDest.vBCUFDest = 0 then
    exit;

  lICMSUFDestJSONObj := TACBrJSONObject.Create;
  lICMSUFDestJSONObj.AddPair('vBCUFDest', AICMSUfDest.vBCUFDest);
  lICMSUFDestJSONObj.AddPair('vBCFCPUFDest', AICMSUfDest.vBCFCPUFDest);
  lICMSUFDestJSONObj.AddPair('pFCPUFDest', AICMSUfDest.pFCPUFDest);
  lICMSUFDestJSONObj.AddPair('pICMSUFDest', AICMSUfDest.pICMSUFDest);
  lICMSUFDestJSONObj.AddPair('pICMSInter', AICMSUfDest.pICMSInter);
  lICMSUFDestJSONObj.AddPair('pICMSInterPart', AICMSUfDest.pICMSInterPart);
  lICMSUFDestJSONObj.AddPair('vFCPUFDest', AICMSUfDest.vFCPUFDest);
  lICMSUFDestJSONObj.AddPair('vICMSUFDest', AICMSUfDest.vICMSUFDest);
  lICMSUFDestJSONObj.AddPair('vICMSUFRemet', AICMSUfDest.vICMSUFRemet);

  AJSONObject.AddPair('ICMSUFDest', lICMSUFDestJSONObj);
end;

procedure TNFeJSONWriter.GerarDetImposto_IPI(const AIPI: TIPI; AJSONObject: TACBrJSONObject);
var
  lIPITribJSONObj, lIPITribCSTJSONObj: TACBrJSONObject;
begin
  lIPITribJSONObj := TACBrJSONObject.Create;
  lIPITribJSONObj.AddPair('CNPJProd', AIPI.CNPJProd);
  lIPITribJSONObj.AddPair('cSelo', AIPI.cSelo);
  lIPITribJSONObj.AddPair('qSelo', AIPI.qSelo);
  lIPITribJSONObj.AddPair('cEnq', AIPI.cEnq);

  case AIPI.CST of
    ipi00, ipi49, ipi50, ipi99:
      begin
        lIPITribCSTJSONObj := TACBrJSONObject.Create;
        try
          lIPITribCSTJSONObj.AddPair('CST', CSTIPIToStr(AIPI.CST));
          if (AIPI.qUnid + AIPI.vUnid > 0) then
          begin
            lIPITribCSTJSONObj.AddPair('qUnid', AIPI.qUnid);
            lIPITribCSTJSONObj.AddPair('vUnid', AIPI.vUnid);
          end else
          begin
            lIPITribCSTJSONObj.AddPair('vBC', AIPI.vBC);
            lIPITribCSTJSONObj.AddPair('pIPI', AIPI.pIPI);
          end;
          lIPITribCSTJSONObj.AddPair('vIPI', AIPI.vIPI);

          lIPITribJSONObj.AddPair('IPITrib', lIPITribCSTJSONObj);
        finally
          //  lIPITribCSTJSONObj.Free;
        end;
      end;
    ipi01, ipi02, ipi03, ipi04, ipi05, ipi51, ipi52, ipi53, ipi54, ipi55:
      begin
        lIPITribCSTJSONObj := TACBrJSONObject.Create;
        try
          lIPITribCSTJSONObj.AddPair('CST', CSTIPIToStr(AIPI.CST));
          lIPITribJSONObj.AddPair('IPINT', lIPITribCSTJSONObj);
        finally
          //  lIPITribCSTJSONObj.Free;
        end;
      end;
  end;

  AJSONObject.AddPair('IPI', lIPITribJSONObj);
end;

procedure TNFeJSONWriter.GerarDetImposto_II(const AII: TII; AJSONObject: TACBrJSONObject);
var
  lIIJSONObj: TACBrJSONObject;
begin
  if AII.vBC = 0 then
    exit;

  lIIJSONObj := TACBrJSONObject.Create;
  lIIJSONObj.AddPair('vBC', AII.vBC);
  lIIJSONObj.AddPair('vDespAdu', AII.vDespAdu);
  lIIJSONObj.AddPair('vII', AII.vII);
  lIIJSONObj.AddPair('vIOF', AII.vIOF);

  AJSONObject.AddPair('II', lIIJSONObj);
end;

procedure TNFeJSONWriter.GerarDetImposto_PIS(const APIS: TPIS; AJSONObject: TACBrJSONObject);
var
  lPISJSONObj, lPISCSTJSONObj: TACBrJSONObject;
begin
  lPISJSONObj := TACBrJSONObject.Create;
  lPISCSTJSONObj := TACBrJSONObject.Create;
  lPISCSTJSONObj.AddPair('CST', CSTPISToStr(APIS.CST));
  case APIS.CST of
    pis01, pis02:
      begin
        lPISCSTJSONObj.AddPair('vBC', APIS.vBC);
        lPISCSTJSONObj.AddPair('pPIS', APIS.pPIS);
        lPISCSTJSONObj.AddPair('vPIS', APIS.vPIS);
        lPISJSONObj.AddPair('PISAliq', lPISCSTJSONObj);
      end;
    pis03:
      begin
        lPISCSTJSONObj.AddPair('qBCProd', APIS.qBCProd);
        lPISCSTJSONObj.AddPair('vAlidProd', APIS.vAliqProd);
        lPISCSTJSONObj.AddPair('vPIS', APIS.vPIS);
        lPISJSONObj.AddPair('PISQtde', lPISCSTJSONObj);
      end;
    pis04, pis05, pis06, pis07, pis08, pis09:
      begin
        lPISJSONObj.AddPair('PISNT', lPISCSTJSONObj);
      end;
    pis49, pis50, pis51, pis52, pis53, pis54, pis55, pis56,
    pis60, pis61, pis62, pis63, pis64, pis65, pis66, pis67,
    pis70, pis71, pis72, pis73, pis74, pis75,
    pis98, pis99:
      begin
        lPISJSONObj.AddPair('PISOutr', lPISCSTJSONObj);
      end;
  end;

  AJSONObject.AddPair('PIS', lPISJSONObj);
end;

procedure TNFeJSONWriter.GerarDetImposto_PISST(const APISST: TPISST; AJSONObject: TACBrJSONObject);
var
  lPISSTJSONObj: TACBrJSONObject;
begin
  if (APISST.vBc = 0) and (APISST.qBCProd = 0) then
    exit;

  lPISSTJSONObj := TACBrJSONObject.Create;
  if (APISST.vBc + APISST.pPis > 0) then
  begin
    lPISSTJSONObj.AddPair('vBC', APISST.vBc);
    lPISSTJSONObj.AddPair('pPIS', APISST.pPis);
  end else
  begin
    lPISSTJSONObj.AddPair('qBCProd', APISST.qBCProd);
    lPISSTJSONObj.AddPair('vAliqProd', APISST.vAliqProd);
  end;
  lPISSTJSONObj.AddPair('vPIS', APISST.vPIS);
  if APISST.indSomaPISST <> ispNenhum then
    lPISSTJSONObj.AddPair('indSomaPISST', indSomaPISSTToStr(APISST.indSomaPISST));

  AJSONObject.AddPair('PISST', lPISSTJSONObj);
end;

procedure TNFeJSONWriter.GerarDetImposto_COFINS(const ACOFINS: TCOFINS; AJSONObject: TACBrJSONObject);
var
  lCOFINSJSONObj, lCOFINSCSTJSONObj: TACBrJSONObject;
begin
  lCOFINSJSONObj := TACBrJSONObject.Create;
  lCOFINSCSTJSONObj := TACBrJSONObject.Create;
  lCOFINSCSTJSONObj.AddPair('CST', CSTCOFINSToStr(ACOFINS.CST));
  try
    case ACOFINS.CST of
      cof01, cof02:
        begin
          lCOFINSCSTJSONObj.AddPair('vBC', ACOFINS.vBC);
          lCOFINSCSTJSONObj.AddPair('pCOFINS', ACOFINS.pCOFINS);
          lCOFINSCSTJSONObj.AddPair('vCOFINS', ACOFINS.vCOFINS);
          lCOFINSJSONObj.AddPair('COFINSAliq', lCOFINSCSTJSONObj);
        end;
      cof03:
        begin
          lCOFINSCSTJSONObj.AddPair('qBCProd', ACOFINS.qBCProd);
          lCOFINSCSTJSONObj.AddPair('vAliqProd', ACOFINS.vAliqProd);
          lCOFINSCSTJSONObj.AddPair('vCOFINS', ACOFINS.vCOFINS);
          lCOFINSJSONObj.AddPair('COFINSQtde', lCOFINSCSTJSONObj);
        end;
      cof04, cof05, cof06, cof07, cof08, cof09:
        begin
          lCOFINSJSONObj.AddPair('COFINSNT', lCOFINSCSTJSONObj);
        end;
      cof49, cof50, cof51, cof52, cof53, cof54, cof55, cof56,
      cof60, cof61, cof62, cof63, cof64, cof65, cof66, cof67,
      cof70, cof71, cof72, cof73, cof74, cof75,
      cof98, cof99:
        begin
          if (ACOFINS.vBC > 0) then
          begin
            lCOFINSCSTJSONObj.AddPair('vBC', ACOFINS.vBC);
            lCOFINSCSTJSONObj.AddPair('pCOFINS', ACOFINS.pCOFINS);
          end;
          if (ACOFINS.vCOFINS > 0) then
          begin
            lCOFINSCSTJSONObj.AddPair('qBCProd', ACOFINS.qBCProd);
            lCOFINSCSTJSONObj.AddPair('vAliqProd', ACOFINS.vAliqProd);
            lCOFINSCSTJSONObj.AddPair('vCOFINS', ACOFINS.vCOFINS);
          end;
          lCOFINSJSONObj.AddPair('COFINSOutr', lCOFINSCSTJSONObj);
        end;
    end;
  finally
    //...
  end;
  AJSONObject.AddPair('COFINS', lCOFINSJSONObj);
end;

procedure TNFeJSONWriter.GerarDetImposto_COFINSST(const ACOFINSST: TCOFINSST; AJSONObject: TACBrJSONObject);
var
  lCOFINSSTJSONObj: TACBrJSONObject;
begin
  if (ACOFINSST.vBC = 0) and (ACOFINSST.qBCProd = 0) then
    exit;

  lCOFINSSTJSONObj := TACBrJSONObject.Create;
  if (ACOFINSST.vBC + ACOFINSST.pCOFINS > 0) then
  begin
    lCOFINSSTJSONObj.AddPair('vBC', ACOFINSST.vBC);
    lCOFINSSTJSONObj.AddPair('pCOFINS', ACOFINSST.pCOFINS);
  end else
  begin
    lCOFINSSTJSONObj.AddPair('qBCProd', ACOFINSST.qBCProd);
    lCOFINSSTJSONObj.AddPair('vAliqProd', ACOFINSST.vAliqProd);
  end;
  lCOFINSSTJSONObj.AddPair('vCOFINS', ACOFINSST.vCOFINS);
  if ACOFINSST.indSomaCOFINSST <> iscNenhum then
    lCOFINSSTJSONObj.AddPair('indSomaCOFINSST', indSomaCOFINSSTToStr(ACOFINSST.indSomaCOFINSST));

  AJSONObject.AddPair('COFINSST', lCOFINSSTJSONObj);
end;

procedure TNFeJSONWriter.GerarDetImposto_ISSQN(const AISSQN: TISSQN; AJSONObject: TACBrJSONObject);
var
  lISSQNJSONObj: TACBrJSONObject;
begin
  if AISSQN.vBC = 0 then
    exit;

  lISSQNJSONObj := TACBrJSONObject.Create;
  lISSQNJSONObj.AddPair('vBC', AISSQN.vBC);
  lISSQNJSONObj.AddPair('vAliq', AISSQN.vAliq);
  lISSQNJSONObj.AddPair('vISSQN', AISSQN.vISSQN);
  lISSQNJSONObj.AddPair('cMunFG', AISSQN.cMunFG);
  lISSQNJSONObj.AddPair('cListServ', AISSQN.cListServ);
  lISSQNJSONObj.AddPair('cSitTrib', ISSQNcSitTribToStr(AISSQN.cSitTrib));
  lISSQNJSONObj.AddPair('vDeducao', AISSQN.vDeducao);
  lISSQNJSONObj.AddPair('vOutro', AISSQN.vOutro);
  lISSQNJSONObj.AddPair('vDescIncond', AISSQN.vDescIncond);
  lISSQNJSONObj.AddPair('vDescCond', AISSQN.vDescCond);
  lISSQNJSONObj.AddPair('vISSRet', AISSQN.vISSRet);
  lISSQNJSONObj.AddPair('indISS', indISSToStr(AISSQN.indISS));
  lISSQNJSONObj.AddPair('cServico', AISSQN.cServico);
  lISSQNJSONObj.AddPair('cMun', AISSQN.cMun);
  lISSQNJSONObj.AddPair('cPais', AISSQN.cPais);
  lISSQNJSONObj.AddPair('nProcesso', AISSQN.nProcesso);
  lISSQNJSONObj.AddPair('indIncentivo', indIncentivoToStr(AISSQN.indIncentivo));

  AJSONObject.AddPair('ISSQN', lISSQNJSONObj);
end;

procedure TNFeJSONWriter.GerarDetObs(const AObs: TobsItem; const AKeyName: String; AJSONObject: TACBrJSONObject);
var
  lObsItemJSONObj: TACBrJSONObject;
begin
  if Trim(AObs.xCampo) = '' then
    exit;

  lObsItemJSONObj := TACBrJSONObject.Create;
  lObsItemJSONObj.AddPair('xCampo', AObs.xCampo);
  lObsItemJSONObj.AddPair('xTexto', AObs.xTexto);

  AJSONObject.AddPair(AKeyName, lObsItemJSONObj);
end;

procedure TNFeJSONWriter.GerarTotal(const ATotal: TTotal; AJSONObject: TACBrJSONObject);
var
  lTotalJSONObj: TACBrJSONObject;
begin
  lTotalJSONObj := TACBrJSONObject.Create;
  GerarTotal_ICMSTot(ATotal.ICMSTot, lTotalJSONObj);
  GerarTotal_ISSQNTot(ATotal.ISSQNtot, lTotalJSONObj);
  GerarTotal_retTrib(ATotal.retTrib, lTotalJSONObj);

  // Reforma Tributria
  Gerar_ISTot(ATotal.ISTot, lTotalJSONObj);
  Gerar_IBSCBSTot(ATotal.IBSCBSTot, lTotalJSONObj);

  lTotalJSONObj.AddPair('vNFTot', ATotal.vNFTot);

  AJSONObject.AddPair('total', lTotalJSONObj);
end;

procedure TNFeJSONWriter.GerarTotal_ICMSTot(const AICMSTot: TICMSTot; AJSONObject: TACBrJSONObject);
var
  lICMSTotJSONObj: TACBrJSONObject;
begin
  if AICMSTot.vNF = 0 then
    exit;

  lICMSTotJSONObj := TACBrJSONObject.Create;
  lICMSTotJSONObj.AddPair('vBC', AICMSTot.vBC);
  lICMSTotJSONObj.AddPair('vICMS', AICMSTot.vICMS);
  lICMSTotJSONObj.AddPair('vICMSDeson', AICMSTot.vICMSDeson);
  lICMSTotJSONObj.AddPair('vFCPUFDest', AICMSTot.vFCPUFDest);
  lICMSTotJSONObj.AddPair('vICMSUFDest', AICMSTot.vICMSUFDest);
  lICMSTotJSONObj.AddPair('vICMSUFRemet', AICMSTot.vICMSUFRemet);
  lICMSTotJSONObj.AddPair('vFCP', AICMSTot.vFCP);
  lICMSTotJSONObj.AddPair('vBCST', AICMSTot.vBCST);
  lICMSTotJSONObj.AddPair('vST', AICMSTot.vST);
  lICMSTotJSONObj.AddPair('vFCPST', AICMSTot.vFCPST);
  lICMSTotJSONObj.AddPair('vFCPSTRet', AICMSTot.vFCPSTRet);
  lICMSTotJSONObj.AddPair('qBCMono', AICMSTot.qBCMono);
  lICMSTotJSONObj.AddPair('vICMSMono', AICMSTot.vICMSMono);
  lICMSTotJSONObj.AddPair('qBCMonoReten', AICMSTot.qBCMonoReten);
  lICMSTotJSONObj.AddPair('vICMSMonoReten', AICMSTot.vICMSMonoReten);
  lICMSTotJSONObj.AddPair('qBCMonoRet', AICMSTot.qBCMonoRet);
  lICMSTotJSONObj.AddPair('vICMSMonoRet', AICMSTot.vICMSMonoRet);
  lICMSTotJSONObj.AddPair('vProd', AICMSTot.vProd);
  lICMSTotJSONObj.AddPair('vFrete', AICMSTot.vFrete);
  lICMSTotJSONObj.AddPair('vSeg', AICMSTot.vSeg);
  lICMSTotJSONObj.AddPair('vDesc', AICMSTot.vDesc);
  lICMSTotJSONObj.AddPair('vII', AICMSTot.vII);
  lICMSTotJSONObj.AddPair('vIPI', AICMSTot.vIPI);
  lICMSTotJSONObj.AddPair('vIPIDevol', AICMSTot.vIPIDevol);
  lICMSTotJSONObj.AddPair('vPIS', AICMSTot.vPIS);
  lICMSTotJSONObj.AddPair('vCOFINS', AICMSTot.vCOFINS);
  lICMSTotJSONObj.AddPair('vOutro', AICMSTot.vOutro);
  lICMSTotJSONObj.AddPair('vNF', AICMSTot.vNF);
  lICMSTotJSONObj.AddPair('vTotTrib', AICMSTot.vTotTrib);

  AJSONObject.AddPair('ICMSTot', lICMSTotJSONObj);
end;

procedure TNFeJSONWriter.GerarTotal_ISSQNTot(const AISSQNTot: TISSQNtot; AJSONObject: TACBrJSONObject);
var
  lISSQNTotJSONObj: TACBrJSONObject;
begin
  if AISSQNTot.vServ = 0 then
    exit;

  lISSQNTotJSONObj := TACBrJSONObject.Create;
  lISSQNTotJSONObj.AddPair('vServ', AISSQNTot.vServ);
  lISSQNTotJSONObj.AddPair('vBC', AISSQNTot.vBC);
  lISSQNTotJSONObj.AddPair('vISS', AISSQNTot.vISS);
  lISSQNTotJSONObj.AddPair('vPIS', AISSQNTot.vPIS);
  lISSQNTotJSONObj.AddPair('vCOFINS', AISSQNTot.vCOFINS);
  lISSQNTotJSONObj.AddPairISODate('dCompet', AISSQNTot.dCompet);
  lISSQNTotJSONObj.AddPair('vDeducao', AISSQNTot.vDeducao);
  lISSQNTotJSONObj.AddPair('vOutro', AISSQNTot.vOutro);
  lISSQNTotJSONObj.AddPair('vDescIncond', AISSQNTot.vDescIncond);
  lISSQNTotJSONObj.AddPair('vDescCond', AISSQNTot.vDescCond);
  lISSQNTotJSONObj.AddPair('vISSRet', AISSQNTot.vISSRet);
  if AISSQNTot.cRegTrib <> RTISSNenhum then
    lISSQNTotJSONObj.AddPair('cRegTrib', RegTribISSQNToStr(AISSQNTot.cRegTrib));

  AJSONObject.AddPair('ISSQNtot', lISSQNTotJSONObj);
end;

procedure TNFeJSONWriter.GerarTotal_retTrib(const ARetTrib: TretTrib; AJSONObject: TACBrJSONObject);
var
  lRetTribJSONObj: TACBrJSONObject;
begin
  if ARetTrib.vRetPIS = 0 then
    exit;

  lRetTribJSONObj := TACBrJSONObject.Create;
  lRetTribJSONObj.AddPair('vRetPIS', ARetTrib.vRetPIS);
  lRetTribJSONObj.AddPair('vRetCOFINS', ARetTrib.vRetCOFINS);
  lRetTribJSONObj.AddPair('vRetCSLL', ARetTrib.vRetCSLL);
  lRetTribJSONObj.AddPair('vBCIRRF', ARetTrib.vBCIRRF);
  lRetTribJSONObj.AddPair('vIRRF', ARetTrib.vIRRF);
  lRetTribJSONObj.AddPair('vBCRetPrev', ARetTrib.vBCRetPrev);
  lRetTribJSONObj.AddPair('vRetPrev', ARetTrib.vRetPrev);

  AJSONObject.AddPair('retTrib', lRetTribJSONObj);
end;

procedure TNFeJSONWriter.GerarTransp(const ATransp: TTransp; AJSONObject: TACBrJSONObject);
var
  lTranspJSONObj: TACBrJSONObject;
begin
  lTranspJSONObj := TACBrJSONObject.Create;
  lTranspJSONObj.AddPair('modFrete', ModFreteToStr(ATransp.modFrete));

  GerarTransp_Transporta(ATransp.Transporta, lTranspJSONObj);
  GerarTransp_retTransp(ATransp.retTransp, lTranspJSONObj);
  GerarTransp_veicTransp(ATransp.veicTransp, lTranspJSONObj);
  GerarTransp_reboque(ATransp.Reboque, lTranspJSONObj);

  lTranspJSONObj.AddPair('vagao', ATransp.vagao);
  lTranspJSONObj.AddPair('balsa', ATransp.balsa);
  GerarTransp_Vol(ATransp.Vol, lTranspJSONObj);

  AJSONObject.AddPair('transp', lTranspJSONObj);
end;

procedure TNFeJSONWriter.GerarTransp_Transporta(const ATransporta: TTransporta; AJSONObject: TACBrJSONObject);
var
  lTransportaJSONObj: TACBrJSONObject;
begin
  if (Trim(ATransporta.CNPJCPF) = '') and (Trim(ATransporta.xNome) = '') then
    exit;

  lTransportaJSONObj := TACBrJSONObject.Create;
  if Length(ATransporta.CNPJCPF) = 14 then
    lTransportaJSONObj.AddPair('CNPJ', ATransporta.CNPJCPF)
  else if Length(ATransporta.CNPJCPF) = 11 then
    lTransportaJSONObj.AddPair('CPF', ATransporta.CNPJCPF);

  lTransportaJSONObj.AddPair('xNome', ATransporta.xNome);
  lTransportaJSONObj.AddPair('IE', ATransporta.IE);
  lTransportaJSONObj.AddPair('xEnder', ATransporta.xEnder);
  lTransportaJSONObj.AddPair('xMun', ATransporta.xMun);
  lTransportaJSONObj.AddPair('UF', ATransporta.UF);

  AJSONObject.AddPair('transporta', lTransportaJSONObj);
end;

procedure TNFeJSONWriter.GerarTransp_retTransp(const ARetTransp: TretTransp; AJSONObject: TACBrJSONObject);
var
  lRetTranspJSONObj: TACBrJSONObject;
begin
  if ARetTransp.vServ = 0 then
    exit;

  lRetTranspJSONObj := TACBrJSONObject.Create;
  lRetTranspJSONObj.AddPair('vServ', ARetTransp.vServ);
  lRetTranspJSONObj.AddPair('vBCRet', ARetTransp.vBCRet);
  lRetTranspJSONObj.AddPair('pICMSRet', ARetTransp.pICMSRet);
  lRetTranspJSONObj.AddPair('vICMSRet', ARetTransp.vICMSRet);
  lRetTranspJSONObj.AddPair('CFOP', ARetTransp.CFOP);
  lRetTranspJSONObj.AddPair('cMunFG', ARetTransp.cMunFG);

  AJSONObject.AddPair('retTransp', lRetTranspJSONObj);
end;

procedure TNFeJSONWriter.GerarTransp_veicTransp(const AVeicTransp: TveicTransp; AJSONObject: TACBrJSONObject);
var
  lVeicTranspJSONObj: TACBrJSONObject;
begin
  if Trim(AVeicTransp.placa) = '' then
    exit;

  lVeicTranspJSONObj := TACBrJSONObject.Create;
  lVeicTranspJSONObj.AddPair('placa', AVeicTransp.placa);
  lVeicTranspJSONObj.AddPair('UF', AVeicTransp.UF);
  lVeicTranspJSONObj.AddPair('RNTC', AVeicTransp.RNTC);

  AJSONObject.AddPair('veicTransp', lVeicTranspJSONObj);
end;

procedure TNFeJSONWriter.GerarTransp_reboque(const AReboque: TReboqueCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lReboqueJSONArray: TACBrJSONArray;
  lReboqueJSONObj: TACBrJSONObject;
begin
  if AReboque.Count = 0 then
    exit;

  lReboqueJSONArray := TACBrJSONArray.Create;
  for i := 0 to AReboque.Count - 1 do
  begin
    lReboqueJSONObj := TACBrJSONObject.Create;
    try
      lReboqueJSONObj.AddPair('placa', AReboque[i].placa);
      lReboqueJSONObj.AddPair('UF', AReboque[i].UF);
      lReboqueJSONObj.AddPair('RNTC', AReboque[i].RNTC);
      lReboqueJSONArray.AddElementJSON(lReboqueJSONObj);
    finally
      //lReboqueJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('reboque', lReboqueJSONArray);
end;

procedure TNFeJSONWriter.GerarTransp_Vol(const AVol: TVolCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lVolJSONArray: TACBrJSONArray;
  lVolJSONObj: TACBrJSONObject;
begin
  if AVol.Count = 0 then
    exit;

  lVolJSONArray := TACBrJSONArray.Create;
  for i := 0 to AVol.Count - 1 do
  begin
    lVolJSONObj := TACBrJSONObject.Create;
    try
      lVolJSONObj.AddPair('qVol', AVol[i].qVol);
      lVolJSONObj.AddPair('esp', AVol[i].esp);
      lVolJSONObj.AddPair('marca', AVol[i].marca);
      lVolJSONObj.AddPair('nVol', AVol[i].nVol);
      lVolJSONObj.AddPair('pesoL', AVol[i].pesoL);
      lVolJSONObj.AddPair('pesoB', AVol[i].pesoB);

      GerarTransp_VolLacres(AVol[i].Lacres, lVolJSONObj);

      lVolJSONArray.AddElementJSON(lVolJSONObj);
    finally
      //lVolJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('vol', lVolJSONArray);
end;

procedure TNFeJSONWriter.GerarTransp_VolLacres(const ALacres: TLacresCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lLacresJSONArray: TACBrJSONArray;
  lLacreJSONObj: TACBrJSONObject;
begin
  if ALacres.Count = 0 then
    exit;

  lLacresJSONArray := TACBrJSONArray.Create;
  for i := 0 to ALacres.Count - 1 do
  begin
    lLacreJSONObj := TACBrJSONObject.Create;
    try
      lLacreJSONObj.AddPair('nLacre', ALacres[i].nLacre);
      lLacresJSONArray.AddElementJSON(lLacreJSONObj);
    finally
      //lLacreJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('lacres', lLacresJSONArray);
end;

procedure TNFeJSONWriter.GerarCobr(const ACobr: TCobr; AJSONObject: TACBrJSONObject);
var
  lCobrJSONObj: TACBrJSONObject;
begin
  if ((ACobr.Fat.nFat = '') or (ACobr.Fat.vOrig = 0) or (ACobr.Fat.vDesc = 0) or (ACobr.Fat.vLiq = 0)) and
     (ACobr.Dup.Count = 0) then
    exit;

  lCobrJSONObj := TACBrJSONObject.Create;
  GerarCobr_fat(ACobr.Fat, lCobrJSONObj);
  GerarCobr_dup(ACobr.Dup, lCobrJSONObj);

  AJSONObject.AddPair('cobr', lCobrJSONObj);
end;

procedure TNFeJSONWriter.GerarCobr_fat(const AFat: TFat; AJSONObject: TACBrJSONObject);
var
  lFatJSONObj: TACBrJSONObject;
begin
  if Trim(AFat.nFat) = '' then
    exit;

  lFatJSONObj := TACBrJSONObject.Create;
  lFatJSONObj.AddPair('nFat', AFat.nFat);
  lFatJSONObj.AddPair('vOrig', AFat.vOrig);
  lFatJSONObj.AddPair('vDesc', AFat.vDesc);
  lFatJSONObj.AddPair('vLiq', AFat.vLiq);

  AJSONObject.AddPair('fat', lFatJSONObj);
end;

procedure TNFeJSONWriter.GerarCobr_dup(const ADup: TDupCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lDupJSONArray: TACBrJSONArray;
  lDupJSONObj: TACBrJSONObject;
begin
  if ADup.Count = 0 then
    exit;

  lDupJSONArray := TACBrJSONArray.Create;
  for i := 0 to ADup.Count - 1 do
  begin
    lDupJSONObj := TACBrJSONObject.Create;
    try
      lDupJSONObj.AddPair('nDup', ADup[i].nDup);
      lDupJSONObj.AddPairISODate('dVenc', ADup[i].dVenc);
      lDupJSONObj.AddPair('vDup', ADup[i].vDup);
      lDupJSONArray.AddElementJSON(lDupJSONObj);
    finally
      //lDupJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('dup', lDupJSONArray);
end;

procedure TNFeJSONWriter.GerarPag(const APag: TpagCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lDetPagJSONArray: TACBrJSONArray;
  lPagJSONObj, lDetPagJSONObj, lCardJSONObj: TACBrJSONObject;
begin
  if APag.Count = 0 then
    exit;

  lPagJSONObj := TACBrJSONObject.Create;
  try
    lDetPagJSONArray := TACBrJSONArray.Create;
    try
      for i := 0 to APag.Count - 1 do
      begin
        lDetPagJSONObj := TACBrJSONObject.Create;
        try
          lDetPagJSONObj.AddPair('indPag', IndpagToStrEX(APag[i].indPag));
          lDetPagJSONObj.AddPair('tPag', FormaPagamentoToStr(APag[i].tPag));
          if Trim(APag[i].xPag) <> '' then
            lDetPagJSONObj.AddPair('xPag', APag[i].xPag);
          lDetPagJSONObj.AddPair('vPag', APag[i].vPag);
          if (APag[i].dPag > 0) then
            lDetPagJSONObj.AddPairISODateTime('dPag', APag[i].dPag);

          lDetPagJSONObj.AddPair('CNPJPag', APag[i].CNPJPag);
          lDetPagJSONObj.AddPair('UFPag', APag[i].UFPag);

          if (APag[i].tpIntegra <> tiNaoInformado) then
          begin
            lCardJSONObj := TACBrJSONObject.Create;
            try
              lCardJSONObj.AddPair('tpIntegra', tpIntegraToStr(APag[i].tpIntegra));
              lCardJSONObj.AddPair('CNPJ', APag[i].CNPJ);
              lCardJSONObj.AddPair('tBand', BandeiraCartaoToStr(APag[i].tBand));
              lCardJSONObj.AddPair('cAut', APag[i].cAut);
              lCardJSONObj.AddPair('CNPJReceb', APag[i].CNPJReceb);
              lCardJSONObj.AddPair('idTermPag', APag[i].idTermPag);
              lDetPagJSONObj.AddPair('card', lCardJSONObj);
            finally
              // lCardJSONObj is owned by lDetPagJSONObj
            end;
          end;

          lDetPagJSONArray.AddElementJSON(lDetPagJSONObj);
        finally
          // lDetPagJSONObj is owned by lDetPagJSONArray
        end;
      end;
    finally
      // lDetPagJSONArray is owned by lPagJSONObj
    end;
    lPagJSONObj.AddPair('detPag', lDetPagJSONArray);
  finally
    //lPagJSONObj is owner by AJSONObject
  end;
  AJSONObject.AddPair('pag', lPagJSONObj);
end;

procedure TNFeJSONWriter.GerarInfIntermed(const AInfIntermed: TinfIntermed; AJSONObject: TACBrJSONObject);
var
  lInfIntermedJSONObj: TACBrJSONObject;
begin
  if Trim(AInfIntermed.CNPJ) = '' then
    exit;

  lInfIntermedJSONObj := TACBrJSONObject.Create;
  lInfIntermedJSONObj.AddPair('CNPJ', AInfIntermed.CNPJ);
  lInfIntermedJSONObj.AddPair('idCadIntTran', AInfIntermed.idCadIntTran);

  AJSONObject.AddPair('infIntermed', lInfIntermedJSONObj);
end;

procedure TNFeJSONWriter.GerarInfAdic(const AInfAdic: TInfAdic; AJSONObject: TACBrJSONObject);
var
  lInfAdicJSONObj: TACBrJSONObject;
begin
  if (Trim(AInfAdic.infAdFisco) = '') and
     (Trim(AInfAdic.infCpl) = '') and
     (AInfAdic.obsCont.Count = 0) and
     (AInfAdic.obsFisco.Count = 0) and
     (AInfAdic.procRef.Count = 0) then
    exit;

  lInfAdicJSONObj := TACBrJSONObject.Create;
  lInfAdicJSONObj.AddPair('infAdFisco', AInfAdic.infAdFisco);
  lInfAdicJSONObj.AddPair('infCpl', AInfAdic.infCpl);
  GerarInfAdic_obsCont(AInfAdic.obsCont, lInfAdicJSONObj);
  GerarInfAdic_obsFisco(AInfAdic.obsFisco, lInfAdicJSONObj);
  GerarInfAdic_procRef(AInfAdic.procRef, lInfAdicJSONObj);

  AJSONObject.AddPair('infAdic', lInfAdicJSONObj);
end;

procedure TNFeJSONWriter.GerarInfAdic_obsCont(const AObsCont: TobsContCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lObsContJSONArray: TACBrJSONArray;
  lObsContJSONObj: TACBrJSONObject;
begin
  if AObsCont.Count = 0 then
    exit;

  lObsContJSONArray := TACBrJSONArray.Create;
  for i := 0 to AObsCont.Count - 1 do
  begin
    lObsContJSONObj := TACBrJSONObject.Create;
    try
      lObsContJSONObj.AddPair('xCampo', AObsCont[i].xCampo);
      lObsContJSONObj.AddPair('xTexto', AObsCont[i].xTexto);
      lObsContJSONArray.AddElementJSON(lObsContJSONObj);
    finally
      //lObsContJSONObj.Free;
    end;
  end;
  AJSONObject.AddPair('obsCont', lObsContJSONArray);
end;

procedure TNFeJSONWriter.GerarInfAdic_obsFisco(const AObsFisco: TobsFiscoCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lObsFiscoJSONArray: TACBrJSONArray;
  lObsFiscoJSONObj: TACBrJSONObject;
begin
  if AObsFisco.Count = 0 then
    exit;

  lObsFiscoJSONArray := TACBrJSONArray.Create;
  for i := 0 to AObsFisco.Count - 1 do
  begin
    lObsFiscoJSONObj := TACBrJSONObject.Create;
    try
      lObsFiscoJSONObj.AddPair('xCampo', AObsFisco[i].xCampo);
      lObsFiscoJSONObj.AddPair('xTexto', AObsFisco[i].xTexto);
      lObsFiscoJSONArray.AddElementJSON(lObsFiscoJSONObj);
    finally
      //lObsFiscoJSONObj.Free;
    end;
  end;
  AJSONObject.AddPair('obsFisco', lObsFiscoJSONArray);
end;

procedure TNFeJSONWriter.GerarInfAdic_procRef(const AProcRef: TprocRefCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lProcRefJSONArray: TACBrJSONArray;
  lProcRefJSONObj: TACBrJSONObject;
begin
  if AProcRef.Count = 0 then
    exit;

  lProcRefJSONArray := TACBrJSONArray.Create;
  for i := 0 to AProcRef.Count - 1 do
  begin
    lProcRefJSONObj := TACBrJSONObject.Create;
    try
      lProcRefJSONObj.AddPair('nProc', AProcRef[i].nProc);
      lProcRefJSONObj.AddPair('indProc', IndProcToStr(AProcRef[i].indProc));
      lProcRefJSONObj.AddPair('tpAto', tpAtoToStr(AProcRef[i].tpAto));
      lProcRefJSONArray.AddElementJSON(lProcRefJSONObj);
    finally
      //lProcRefJSONObj.Free;
    end;
  end;
  AJSONObject.AddPair('procRef', lProcRefJSONArray);
end;

procedure TNFeJSONWriter.GerarExporta(const AExporta: TExporta; AJSONObject: TACBrJSONObject);
var
  lExportaJSONObj: TACBrJSONObject;
begin
  if Trim(AExporta.UFembarq) = '' then
    exit;

  lExportaJSONObj := TACBrJSONObject.Create;
  lExportaJSONObj.AddPair('UFEmbarq', AExporta.UFembarq);
  lExportaJSONObj.AddPair('xLocEmbarq', AExporta.xLocEmbarq);

  AJSONObject.AddPair('exporta', lExportaJSONObj);
end;

procedure TNFeJSONWriter.GerarCompra(const ACompra: TCompra; AJSONObject: TACBrJSONObject);
var
  lCompraJSONObj: TACBrJSONObject;
begin
  if (Trim(ACompra.xNEmp) = '') and
     (Trim(ACompra.xPed) = '') and
     (Trim(ACompra.xCont) = '') then
    exit;

  lCompraJSONObj := TACBrJSONObject.Create;
  lCompraJSONObj.AddPair('xNEmp', ACompra.xNEmp);
  lCompraJSONObj.AddPair('xPed', ACompra.xPed);
  lCompraJSONObj.AddPair('xCont', ACompra.xCont);

  AJSONObject.AddPair('compra', lCompraJSONObj);
end;

procedure TNFeJSONWriter.GerarCana(const ACana: Tcana; AJSONObject: TACBrJSONObject);
var
  lCanaJSONObj: TACBrJSONObject;
begin
  if Trim(ACana.safra) = '' then
    exit;

  lCanaJSONObj := TACBrJSONObject.Create;
  lCanaJSONObj.AddPair('safra', ACana.safra);
  lCanaJSONObj.AddPair('ref', ACana.ref);
  lCanaJSONObj.AddPair('qTotMes', ACana.qTotMes);
  lCanaJSONObj.AddPair('qTotAnt', ACana.qTotAnt);
  lCanaJSONObj.AddPair('qTotGer', ACana.qTotGer);
  lCanaJSONObj.AddPair('vFor', ACana.vFor);
  lCanaJSONObj.AddPair('vTotDed', ACana.vTotDed);
  lCanaJSONObj.AddPair('vLiqFor', ACana.vLiqFor);

  GerarCana_fordia(ACana.fordia, lCanaJSONObj);
  GerarCana_deduc(ACana.deduc, lCanaJSONObj);

  AJSONObject.AddPair('cana', lCanaJSONObj);
end;

procedure TNFeJSONWriter.GerarCana_fordia(const AForDia: TForDiaCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lForDiaJSONArray: TACBrJSONArray;
  lForDiaJSONObj: TACBrJSONObject;
begin
  if AForDia.Count = 0 then
    exit;

  lForDiaJSONArray := TACBrJSONArray.Create;
  for i := 0 to AForDia.Count - 1 do
  begin
    lForDiaJSONObj := TACBrJSONObject.Create;
    try
      lForDiaJSONObj.AddPair('dia', AForDia[i].dia);
      lForDiaJSONObj.AddPair('qtde', AForDia[i].qtde);
      lForDiaJSONArray.AddElementJSON(lForDiaJSONObj);
    finally
      //lForDiaJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('forDia', lForDiaJSONArray);
end;

procedure TNFeJSONWriter.GerarCana_deduc(const ADeduc: TDeducCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lDeducJSONArray: TACBrJSONArray;
  lDeducJSONObj: TACBrJSONObject;
begin
  if ADeduc.Count = 0 then
    exit;

  lDeducJSONArray := TACBrJSONArray.Create;
  for i := 0 to ADeduc.Count - 1 do
  begin
    lDeducJSONObj := TACBrJSONObject.Create;
    try
      lDeducJSONObj.AddPair('xDed', ADeduc[i].xDed);
      lDeducJSONObj.AddPair('vDed', ADeduc[i].vDed);
      lDeducJSONArray.AddElementJSON(lDeducJSONObj);
    finally
      //lDeducJSONObj.Free;
    end;
  end;

  AJSONObject.AddPair('deduc', lDeducJSONArray);
end;

procedure TNFeJSONWriter.GerarInfRespTec(const AInfRespTec: TinfRespTec; AJSONObject: TACBrJSONObject);
var
  lInfRespTecJSONObj: TACBrJSONObject;
begin
  if Trim(AInfRespTec.CNPJ) = '' then
    exit;

  lInfRespTecJSONObj := TACBrJSONObject.Create;
  lInfRespTecJSONObj.AddPair('CNPJ', AInfRespTec.CNPJ);
  lInfRespTecJSONObj.AddPair('xContato', AInfRespTec.xContato);
  lInfRespTecJSONObj.AddPair('email', AInfRespTec.email);
  lInfRespTecJSONObj.AddPair('fone', AInfRespTec.fone);
  lInfRespTecJSONObj.AddPair('idCSRT', AInfRespTec.idCSRT);
  lInfRespTecJSONObj.AddPair('hashCSRT', AInfRespTec.hashCSRT);

  AJSONObject.AddPair('infRespTec', lInfRespTecJSONObj);
end;

procedure TNFeJSONWriter.GerarInfNFeSupl(const AInfNFeSupl: TinfNFeSupl; AJSONObj: TACBrJSONObject);
var
  lInfNFeSuplJSONObj: TACBrJSONObject;
begin
  if Trim(AInfNFeSupl.qrCode) = '' then
    exit;

  lInfNFeSuplJSONObj := TACBrJSONObject.Create;
  lInfNFeSuplJSONObj.AddPair('qrCode', AInfNFeSupl.qrCode);
  lInfNFeSuplJSONObj.AddPair('urlChave', AInfNFeSupl.urlChave);

  AJSONObj.AddPair('infNFeSupl', lInfNFeSuplJSONObj);
end;

procedure TNFeJSONWriter.GerarAgropecuario(const AAgropecuario: Tagropecuario; AJSONObject: TACBrJSONObject);
var
  lAgropecuarioJSONObj: TACBrJSONObject;
begin
  if (AAgropecuario.defensivo.Count = 0) and (Trim(AAgropecuario.guiaTransito.nGuia) = '') then
    exit;

  lAgropecuarioJSONObj := TACBrJSONObject.Create;
  Gerar_defensivo(AAgropecuario.defensivo, lAgropecuarioJSONObj);
  Gerar_guiaTransito(AAgropecuario.guiaTransito, lAgropecuarioJSONObj);

  AJSONObject.AddPair('agropecuario', lAgropecuarioJSONObj);
end;

procedure TNFeJSONWriter.Gerar_defensivo(const ADefensivo: TdefensivoCollection; AJSONObject: TACBrJSONObject);
var
  i: Integer;
  lDefensivoJSONArray: TACBrJSONArray;
  lDefensivoJSON: TACBrJSONObject;
begin
  if ADefensivo.Count = 0 then
    exit;

  lDefensivoJSONArray := TACBrJSONArray.Create;
  for i := 0 to ADefensivo.Count - 1 do
  begin
    lDefensivoJSON := TACBrJSONObject.Create;
    try
      lDefensivoJSON.AddPair('nReceituario', ADefensivo[i].nReceituario);
      lDefensivoJSON.AddPair('CPFRespTec', ADefensivo[i].CPFRespTec);
      lDefensivoJSONArray.AddElementJSON(lDefensivoJSON);
    finally
      //lDefensivoJSON.Free;
    end;
  end;
  AJSONObject.AddPair('defensivo', lDefensivoJSONArray);
end;

procedure TNFeJSONWriter.Gerar_guiaTransito(const AGuiaTransito: TguiaTransito; AJSONObject: TACBrJSONObject);
var
  lGuiaTransitoJSONObj: TACBrJSONObject;
begin
  if Trim(AGuiaTransito.nGuia) = '' then
    exit;

  lGuiaTransitoJSONObj := TACBrJSONObject.Create;
  lGuiaTransitoJSONObj.AddPair('UFGuia', AGuiaTransito.UFGuia);
  lGuiaTransitoJSONObj.AddPair('tpGuia', TtpGuiaToStr(AGuiaTransito.tpGuia));
  lGuiaTransitoJSONObj.AddPair('serieGuia', AGuiaTransito.serieGuia);
  lGuiaTransitoJSONObj.AddPair('nGuia', AGuiaTransito.nGuia);

  AJSONObject.AddPair('guiaTransito', lGuiaTransitoJSONObj);
end;

procedure TNFeJSONWriter.Gerar_gCompraGov(const AgCompraGov: TgCompraGov; AJSONObject: TACBrJSONObject);
var
  lGCompraGovJSONObj: TACBrJSONObject;
begin
  if AgCompraGov.tpEnteGov = tcgNenhum then
    exit;

  lGCompraGovJSONObj := TACBrJSONObject.Create;

  lGCompraGovJSONObj.AddPair('tpEnteGov', tpEnteGovToStr(AgCompraGov.tpEnteGov));
  lGCompraGovJSONObj.AddPair('pRedutor', AgCompraGov.pRedutor);
  lGCompraGovJSONObj.AddPair('tpOperGov', tpOperGovToStr(AgCompraGov.tpOperGov));

  AJSONObject.AddPair('gCompraGov', lGCompraGovJSONObj);
end;

procedure TNFeJSONWriter.Gerar_gPagAntecipado(const AGPagAntecipado: TgPagAntecipadoCollection; AJSONObject: TACBrJSONObject);
var
  i: integer;
  lGPagAtecipadoJSONArray: TACBrJSONArray;
begin
  if AGPagAntecipado.Count = 0 then
    exit;

  lGPagAtecipadoJSONArray := TACBrJSONArray.Create;
  for i := 0 to AGPagAntecipado.Count - 1 do
  begin
    lGPagAtecipadoJSONArray.AddElement(AGPagAntecipado[i].refNFe);
  end;

  AJSONObject.AddPair('gPagAntecipado', lGPagAtecipadoJSONArray);
end;

procedure TNFeJSONWriter.Gerar_ISel(const AISel: TgIS; AJSONObject: TACBrJSONObject);
var
  lISelJSONObj: TACBrJSONObject;
begin
  if AISel.vBCIS = 0 then
    exit;

  lISelJSONObj := TACBrJSONObject.Create;
  //Usar string até a publicação de uma tabela de CSTs oficial para o IS
  //lISelJSONObj.AddPair('CSTIS', CSTISToStr(AISel.CSTIS));
  lISelJSONObj.AddPair('CSTIS', AISel.CSTIS);
  lISelJSONObj.AddPair('cClassTribIS', AISel.cClassTribIS);
  lISelJSONObj.AddPair('vBCIS', AISel.vBCIS);
  lISelJSONObj.AddPair('pIS', AISel.pIS);
  lISelJSONObj.AddPair('pISEspec', AISel.pISEspec);
  lISelJSONObj.AddPair('uTrib', AISel.uTrib);
  lISelJSONObj.AddPair('qTrib', AISel.qTrib);
  lISelJSONObj.AddPair('vIS', AISel.vIS);

  AJSONObject.AddPair('IS', lISelJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS(const AIBSCBS: TIBSCBS; AJSONObject: TACBrJSONObject);
var
  lIBSCBSJSONObj: TACBrJSONObject;
begin
  if AIBSCBS.CST = cstNenhum then
    exit;

  lIBSCBSJSONObj := TACBrJSONObject.Create;
  lIBSCBSJSONObj.AddPair('CST', CSTIBSCBSToStr(AIBSCBS.CST));
  lIBSCBSJSONObj.AddPair('cClassTrib', AIBSCBS.cClassTrib);
  case AIBSCBS.CST of
    cst000, cst200, cst220, cst510:
      Gerar_IBSCBS_gIBSCBS(AIBSCBS.gIBSCBS, lIBSCBSJSONObj);

    cst550:
      if (NFe.Ide.modelo = 55) then
        Gerar_IBSCBS_gIBSCBS(AIBSCBS.gIBSCBS, lIBSCBSJSONObj);

    cst620:
      Gerar_IBSCBS_gIBSCBSMono(AIBSCBS.gIBSCBSMono, lIBSCBSJSONObj);

    cst800:
      if (NFe.Ide.modelo = 55) then
        Gerar_IBSCBS_gTransfCred(AIBSCBS.gTransfCred, lIBSCBSJSONObj);

    cst810:
      if (NFe.Ide.modelo = 55) and (AIBSCBS.gCredPresIBSZFM.tpCredPresIBSZFM <> tcpNenhum) then
        Gerar_IBSCBS_gCredPresIBSZFM(AIBSCBS.gCredPresIBSZFM, lIBSCBSJSONObj);
  end;

  AJSONObject.AddPair('IBSCBS', lIBSCBSJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBS(const AGIBSCBS: TgIBSCBS; AJSONObject: TACBrJSONObject);
var
  lGIBSCBSJSONObj: TACBrJSONObject;
begin
  if AGIBSCBS.vBC = 0 then
    exit;

  lGIBSCBSJSONObj := TACBrJSONObject.Create;
  lGIBSCBSJSONObj.AddPair('vBC', AGIBSCBS.vBC);
  lGIBSCBSJSONObj.AddPair('vIBS', AGIBSCBS.vIBS);
  Gerar_IBSCBS_gIBSCBS_gIBSUF(AGIBSCBS.gIBSUF, lGIBSCBSJSONObj);
  Gerar_IBSCBS_gIBSCBS_gIBSMun(AGIBSCBS.gIBSMun, lGIBSCBSJSONObj);
  Gerar_IBSCBS_gIBSCBS_gCBS(AGIBSCBS.gCBS, lGIBSCBSJSONObj);
  Gerar_IBSCBS_gIBSCBS_gTribRegular(AGIBSCBS.gTribRegular, lGIBSCBSJSONObj);
//  Gerar_IBSCBS_gIBSCBS_gIBSCBSCredPres(AGIBSCBS.gIBSCredPres, 'gIBSCredPres', lGIBSCBSJSONObj);
//  Gerar_IBSCBS_gIBSCBS_gIBSCBSCredPres(AGIBSCBS.gCBSCredPres, 'gCBSCredPres', lGIBSCBSJSONObj);
  Gerar_IBSCBS_gIBSCBS_gTribCompraGov(AGIBSCBS.gTribCompraGov, lGIBSCBSJSONObj);

  AJSONObject.AddPair('gIBSCBS', lGIBSCBSJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBSMono(const AIBSCBSMono: TgIBSCBSMono; AJSONObject: TACBrJSONObject);
var
  lIBSCBSMonoJSONObj: TACBrJSONObject;

  function PossuigMonoPadrao: Boolean;
  begin
    Result := (AIBSCBSMono.gMonoPadrao.adRemIBS > 0) or (AIBSCBSMono.gMonoPadrao.adRemCBS > 0) or
              (AIBSCBSMono.gMonoPadrao.vIBSMono > 0) or (AIBSCBSMono.gMonoPadrao.vCBSMono > 0);
  end;

  function PossuigMonoReten: Boolean;
  begin
    Result := (AIBSCBSMono.gMonoReten.adRemIBSReten > 0) or (AIBSCBSMono.gMonoReten.vIBSMonoReten > 0) or
              (AIBSCBSMono.gMonoReten.adRemCBSReten > 0) or (AIBSCBSMono.gMonoReten.vCBSMonoReten > 0);
  end;
  function PossuigMonoRet: Boolean;
  begin
    Result := (AIBSCBSMono.gMonoRet.adRemIBSRet > 0) or (AIBSCBSMono.gMonoRet.vIBSMonoRet > 0) or
              (AIBSCBSMono.gMonoRet.adRemCBSRet > 0) or (AIBSCBSMono.gMonoRet.vCBSMonoRet > 0);
  end;

  function PossuigMonoDif: Boolean;
  begin
    Result := (AIBSCBSMono.gMonoDif.pDifIBS > 0) or (AIBSCBSMono.gMonoDif.vIBSMonoDif > 0) or
              (AIBSCBSMono.gMonoDif.pDifCBS > 0) or (AIBSCBSMono.gMonoDif.vCBSMonoDif > 0);
  end;

  function PossuiIBSCBSMono: Boolean;
  begin
    Result := (AIBSCBSMono.vTotIBSMonoItem > 0) or (AIBSCBSMono.vTotIBSMonoItem > 0) or
              PossuigMonoPadrao or
              PossuigMonoReten or
              PossuigMonoRet or
              PossuigMonoDif;
  end;

begin
  if not PossuiIBSCBSMono then
    exit;

  lIBSCBSMonoJSONObj := TACBrJSONObject.Create;
  if PossuigMonoPadrao then
    Gerar_IBSCBS_gIBSCBSMono_gMonoPadrao(AIBSCBSMono.gMonoPadrao, lIBSCBSMonoJSONObj);

  if PossuigMonoReten then
    Gerar_IBSCBS_gIBSCBSMono_gMonoReten(AIBSCBSMono.gMonoReten, lIBSCBSMonoJSONObj);

  if PossuigMonoRet then
    Gerar_IBSCBS_gIBSCBSMono_gMonoRet(AIBSCBSMono.gMonoRet, lIBSCBSMonoJSONObj);

  if PossuigMonoDif then
    Gerar_IBSCBS_gIBSCBSMono_gMonoDif(AIBSCBSMono.gMonoDif, lIBSCBSMonoJSONObj);

  lIBSCBSMonoJSONObj.AddPair('vTotIBSMonoItem', AIBSCBSMono.vTotIBSMonoItem);
  lIBSCBSMonoJSONObj.AddPair('vTotCBSMonoItem', AIBSCBSMono.vTotCBSMonoItem);

  AJSONObject.AddPair('gIBSCBSMono', lIBSCBSMonoJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBSMono_gMonoDif(const AGMonoDif: TgMonoDif; AJSONObject: TACBrJSONObject);
var
  lGMonoDifJSONObj: TACBrJSONObject;
begin
  lGMonoDifJSONObj := TACBrJSONObject.Create;
  lGMonoDifJSONObj.AddPair('pDifIBS', AGMonoDif.pDifIBS);
  lGMonoDifJSONObj.AddPair('vIBSMonoDif', AGMonoDif.vIBSMonoDif);
  lGMonoDifJSONObj.AddPair('pDifCBS', AGMonoDif.pDifCBS);
  lGMonoDifJSONObj.AddPair('vCBSMonoDif', AGMonoDif.vCBSMonoDif);
  AJSONObject.AddPair('gMonoDif', lGMonoDifJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBSMono_gMonoPadrao(const AGMonoPadrao: TgMonoPadrao; AJSONObject: TACBrJSONObject);
var
  lGMonoPadraoJSONObj: TACBrJSONObject;
begin
  lGMonoPadraoJSONObj := TACBrJSONObject.Create;
  lGMonoPadraoJSONObj.AddPair('qBCMono', AGMonoPadrao.qBCMono);
  lGMonoPadraoJSONObj.AddPair('adRemIBS', AGMonoPadrao.adRemIBS);
  lGMonoPadraoJSONObj.AddPair('adRemCBS', AGMonoPadrao.adRemCBS);
  lGMonoPadraoJSONObj.AddPair('vIBSMono', AGMonoPadrao.vIBSMono);
  lGMonoPadraoJSONObj.AddPair('vCBSMono', AGMonoPadrao.vCBSMono);

  AJSONObject.AddPair('gMonoPadrao', lGMonoPadraoJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBSMono_gMonoRet(const AGMonoRet: TgMonoRet; AJSONObject: TACBrJSONObject);
var
  lGMonoRetJSONObj: TACBrJSONObject;
begin
  lGMonoRetJSONObj := TACBrJSONObject.Create;
  lGMonoRetJSONObj.AddPair('qBCMonoRet', AGMonoRet.qBCMonoRet);
  lGMonoRetJSONObj.AddPair('adRemIBSRet', AGMonoRet.adRemIBSRet);
  lGMonoRetJSONObj.AddPair('vIBSMonoRet', AGMonoRet.vIBSMonoRet);
  lGMonoRetJSONObj.AddPair('adRemCBSRet', AGMonoRet.adRemCBSRet);
  lGMonoRetJSONObj.AddPair('vCBSMonoRet', AGMonoRet.vCBSMonoRet);
  AJSONObject.AddPair('gMonoRet', lGMonoRetJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBSMono_gMonoReten(const AGMonoReten: TgMonoReten; AJSONObject: TACBrJSONObject);
var
  lGMonoRetenJSONObj: TACBrJSONObject;
begin
  lGMonoRetenJSONObj := TACBrJSONObject.Create;
  
  lGMonoRetenJSONObj.AddPair('qBCMonoReten', AGMonoReten.qBCMonoReten);
  lGMonoRetenJSONObj.AddPair('adRemIBSReten', AGMonoReten.adRemIBSReten);
  lGMonoRetenJSONObj.AddPair('vIBSMonoReten', AGMonoReten.vIBSMonoReten);
  lGMonoRetenJSONObj.AddPair('adRemCBSReten', AGMonoReten.adRemCBSReten);
  lGMonoRetenJSONObj.AddPair('vCBSMonoReten', AGMonoReten.vCBSMonoReten);
  
  AJSONObject.AddPair('gMonoReten', lGMonoRetenJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gTransfCred(const AGTransfCred: TgTransfCred; AJSONObject: TACBrJSONObject);
var
  lGTransfCredJSONObj: TACBrJSONObject;
begin
  if (AGTransfCred.vIBS = 0) and (AGTransfCred.vCBS = 0) then
    exit;

  lGTransfCredJSONObj := TACBrJSONObject.Create;
  lGTransfCredJSONObj.AddPair('vIBS', AGTransfCred.vIBS);
  lGTransfCredJSONObj.AddPair('vCBS', AGTransfCred.vCBS);

  AJSONObject.AddPair('gTransfCred', lGTransfCredJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gCredPresIBSZFM(const AGCredPresIBSZFM: TCredPresIBSZFM; AJSONObject: TACBrJSONObject);
var
  lGCredPresIBSZFMJSONObj: TACBrJSONObject;
begin
  if AGCredPresIBSZFM.vCredPresIBSZFM = 0 then
    exit;

  lGCredPresIBSZFMJSONObj := TACBrJSONObject.Create;
  lGCredPresIBSZFMJSONObj.AddPair('tpCredPresIBSZFM', tpCredPresIBSZFMToStr(AGCredPresIBSZFM.tpCredPresIBSZFM));
  lGCredPresIBSZFMJSONObj.AddPair('vCredPresIBSZFM', AGCredPresIBSZFM.vCredPresIBSZFM);

  AJSONObject.AddPair('gCredPresIBSZFM', lGCredPresIBSZFMJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBS_gIBSUF(const AIBSUF: TgIBSUF; AJSONObject: TACBrJSONObject);
var
  lGIBSUFJSONObj: TACBrJSONObject;
begin
  if AIBSUF.pIBSUF = 0 then
    exit;

  lGIBSUFJSONObj := TACBrJSONObject.Create;
  lGIBSUFJSONObj.AddPair('pIBSUF', AIBSUF.pIBSUF);
  Gerar_IBSCBS_gIBSCBS__gDif(AIBSUF.gDif, lGIBSUFJSONObj);
  Gerar_IBSCBS_gIBSCBS_gIBSCBSUFMun_gDevTrib(AIBSUF.gDevTrib, lGIBSUFJSONObj);
  Gerar_IBSCBS_gIBSCBS_gIBSCBSUFMun_gRed(AIBSUF.gRed, lGIBSUFJSONObj);
  lGIBSUFJSONObj.AddPair('vIBSUF', AIBSUF.vIBSUF);

  AJSONObject.AddPair('gIBSUF', lGIBSUFJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBS_gIBSCBSUFMun_gDevTrib(const AGDevTrib: TgDevTrib; AJSONObject: TACBrJSONObject);
var
  lGDevTribJSONObj: TACBrJSONObject;
begin
  if AGDevTrib.vDevTrib = 0 then
    exit;

  lGDevTribJSONObj := TACBrJSONObject.Create;
  lGDevTribJSONObj.AddPair('vDevTrib', AGDevTrib.vDevTrib);

  AJSONObject.AddPair('gDevTrib', lGDevTribJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBS_gIBSCBSUFMun_gRed(const AGRed: TgRed; AJSONObject: TACBrJSONObject);
var
  lGRedJSONObject: TACBrJSONObject;
begin
  if AGRed.pRedAliq = 0 then
    exit;

  lGRedJSONObject := TACBrJSONObject.Create;
  lGRedJSONObject.AddPair('pRedAliq', AGRed.pRedAliq);
  lGRedJSONObject.AddPair('pAliqEfet', AGRed.pAliqEfet);

  AJSONObject.AddPair('gRed', lGRedJSONObject);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBS_gIBSMun(const AIBSMun: TgIBSMun; AJSONObject: TACBrJSONObject);
var
  lGIBSMunJSONObject: TACBrJSONObject;
begin
  if AIBSMun.pIBSMun = 0 then
    exit;

  lGIBSMunJSONObject := TACBrJSONObject.Create;
  lGIBSMunJSONObject.AddPair('pIBSMun', AIBSMun.pIBSMun);
  Gerar_IBSCBS_gIBSCBS__gDif(AIBSMun.gDif, lGIBSMunJSONObject);
  Gerar_IBSCBS_gIBSCBS_gIBSCBSUFMun_gDevTrib(AIBSMun.gDevTrib, lGIBSMunJSONObject);
  Gerar_IBSCBS_gIBSCBS_gIBSCBSUFMun_gRed(AIBSMun.gRed, lGIBSMunJSONObject);
  lGIBSMunJSONObject.AddPair('vIBSMun', AIBSMun.vIBSMun);

  AJSONObject.AddPair('gIBSMun', lGIBSMunJSONObject);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBS_gCBS(const AGCBS: TgCBS; AJSONObject: TACBrJSONObject);
var
  lGCBSJSONObj: TACBrJSONObject;
begin
  if AGCBS.pCBS = 0 then
    exit;

  lGCBSJSONObj := TACBrJSONObject.Create;
  lGCBSJSONObj.AddPair('pCBS', AGCBS.pCBS);
  Gerar_IBSCBS_gIBSCBS__gDif(AGCBS.gDif, lGCBSJSONObj);
  Gerar_IBSCBS_gIBSCBS_gIBSCBSUFMun_gDevTrib(AGCBS.gDevTrib, lGCBSJSONObj);
  Gerar_IBSCBS_gIBSCBS_gIBSCBSUFMun_gRed(AGCBS.gRed, lGCBSJSONObj);
  lGCBSJSONObj.AddPair('vCBS', AGCBS.vCBS);

  AJSONObject.AddPair('gCBS', lGCBSJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBS__gDif(const AGDif: TgDif; AJSONObject: TACBrJSONObject);
var
  lGDifJSONObj: TACBrJSONObject;
begin
  if AGDif.pDif = 0 then
    exit;

  lGDifJSONObj := TACBrJSONObject.Create;
  lGDifJSONObj.AddPair('pDif', AGDif.pDif);
  lGDifJSONObj.AddPair('vDif', AGDif.vDif);

  AJSONObject.AddPair('gDif', lGDifJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBS_gTribRegular(const AGTribRegular: TgTribRegular; AJSONObject: TACBrJSONObject);
var
  lGTribRegularJSONObj: TACBrJSONObject;
begin
  if AGTribRegular.CSTReg = cstNenhum then
    exit;

  lGTribRegularJSONObj := TACBrJSONObject.Create;
  lGTribRegularJSONObj.AddPair('CSTReg', CSTIBSCBSToStr(AGTribRegular.CSTReg));
  lGTribRegularJSONObj.AddPair('cClassTribReg', AGTribRegular.cClassTribReg);
  lGTribRegularJSONObj.AddPair('pAliqEfetRegIBSUF', AGTribRegular.pAliqEfetRegIBSUF);
  lGTribRegularJSONObj.AddPair('vTribRegIBSUF', AGTribRegular.vTribRegIBSUF);
  lGTribRegularJSONObj.AddPair('pAliqEfetRegIBSMun', AGTribRegular.pAliqEfetRegIBSMun);
  lGTribRegularJSONObj.AddPair('vTribRegIBSMun', AGTribRegular.vTribRegIBSMun);
  lGTribRegularJSONObj.AddPair('pAliqEfetRegCBS', AGTribRegular.pAliqEfetRegCBS);
  lGTribRegularJSONObj.AddPair('vTribRegCBS', AGTribRegular.vTribRegCBS);

  AJSONObject.AddPair('gTribRegular', lGTribRegularJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBS_gIBSCBSCredPres(const AGIBSCredPres: TgIBSCBSCredPres; const AKeyName: String; AJSONObject: TACBrJSONObject);
var
  lGIBSCredPresJSONObj: TACBrJSONObject;
begin
{
  if AGIBSCredPres.cCredPres = cpNenhum then
    exit;

  lGIBSCredPresJSONObj := TACBrJSONObject.Create;
  lGIBSCredPresJSONObj.AddPair('cCredPres', cCredPresToStr(AGIBSCredPres.cCredPres));
  lGIBSCredPresJSONObj.AddPair('pCredPres', AGIBSCredPres.pCredPres);
  if AGIBSCredPres.vCredPres > 0 then
    lGIBSCredPresJSONObj.AddPair('vCredPres', AGIBSCredPres.vCredPres)
  else
    lGIBSCredPresJSONObj.AddPair('vCredPresCondSus', AGIBSCredPres.vCredPresCondSus);

  AJSONObject.AddPair(AKeyName, lGIBSCredPresJSONObj);
  }
end;

procedure TNFeJSONWriter.Gerar_IBSCBS_gIBSCBS_gTribCompraGov(const AGTribCompraGov: TgTribCompraGov; AJSONObject: TACBrJSONObject);
var
  lGTribCompraGovJSONObj: TACBrJSONObject;
begin
  if AGTribCompraGov.pAliqIBSUF = 0 then
    exit;

  lGTribCompraGovJSONObj := TACBrJSONObject.Create;
  lGTribCompraGovJSONObj.AddPair('pAliqIBSUF', AGTribCompraGov.pAliqIBSUF);
  lGTribCompraGovJSONObj.AddPair('vTribIBSUF', AGTribCompraGov.vTribIBSUF);
  lGTribCompraGovJSONObj.AddPair('pAliqIBSMun', AGTribCompraGov.pAliqIBSMun);
  lGTribCompraGovJSONObj.AddPair('vTribIBSMun', AGTribCompraGov.vTribIBSMun);
  lGTribCompraGovJSONObj.AddPair('pAliqCBS', AGTribCompraGov.pAliqCBS);
  lGTribCompraGovJSONObj.AddPair('vTribCBS', AGTribCompraGov.vTribCBS);

  AJSONObject.AddPair('gTribCompraGov', lGTribCompraGovJSONObj);
end;

procedure TNFeJSONWriter.Gerar_Det_DFeReferenciado(const ADFeReferenciado: TDFeReferenciado; AJSONObject: TACBrJSONObject);
var
  lDFeReferenciadoJSONObj: TACBrJSONObject;
begin
  if Trim(ADFeReferenciado.chaveAcesso) = '' then
    exit;

  lDFeReferenciadoJSONObj := TACBrJSONObject.Create;
  lDFeReferenciadoJSONObj.AddPair('chaveAcesso', ADFeReferenciado.chaveAcesso);
  lDFeReferenciadoJSONObj.AddPair('nItem', ADFeReferenciado.nItem);

  AJSONObject.AddPair('DFeReferenciado', lDFeReferenciadoJSONObj);
end;

procedure TNFeJSONWriter.Gerar_ISTot(const AISTot: TISTot; AJSONObject: TACBrJSONObject);
var
  lISTotJSONObj: TACBrJSONObject;
begin
  if AISTot.vIS = 0 then
    exit;

  lISTotJSONObj := TACBrJSONObject.Create;
  lISTotJSONObj.AddPair('vIS', AISTot.vIS);

  AJSONObject.AddPair('ISTot', lISTotJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBSTot(const AIBSCBSTot: TIBSCBSTot; AJSONObject: TACBrJSONObject);
var
  lIBSCBSTotJSONObj: TACBrJSONObject;
begin
  if AIBSCBSTot.vBCIBSCBS = 0 then
    exit;

  lIBSCBSTotJSONObj := TACBrJSONObject.Create;
  lIBSCBSTotJSONObj.AddPair('vBCIBSCBS', AIBSCBSTot.vBCIBSCBS);
  Gerar_IBSCBSTot_gIBS(AIBSCBSTot.gIBS, lIBSCBSTotJSONObj);
  Gerar_IBSCBSTot_gCBS(AIBSCBSTot.gCBS, lIBSCBSTotJSONObj);
  Gerar_IBSCBSTot_gMono(AIBSCBSTot.gMono, lIBSCBSTotJSONObj);

  AJSONObject.AddPair('IBSCBSTot', lIBSCBSTotJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBSTot_gIBS(const AGIBS: TgIBSTot; AJSONObject: TACBrJSONObject);
var
  lGIBSJSONObj: TACBrJSONObject;
begin
  if AGIBS.vIBS = 0 then
    exit;

  lGIBSJSONObj := TACBrJSONObject.Create;

  Gerar_IBSCBSTot_gIBS_gIBSUFTot(AGIBS.gIBSUFTot, lGIBSJSONObj);
  Gerar_IBSCBSTot_gIBS_gIBSMunTot(AGIBS.gIBSMunTot, lGIBSJSONObj);

  lGIBSJSONObj.AddPair('vIBS', AGIBS.vIBS);
  lGIBSJSONObj.AddPair('vCredPres', AGIBS.vCredPres);
  lGIBSJSONObj.AddPair('vCredPresCondSus', AGIBS.vCredPresCondSus);

  AJSONObject.AddPair('gIBS', lGIBSJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBSTot_gIBS_gIBSUFTot(const AGIBSUFTot: TgIBSUFTot; AJSONObject: TACBrJSONObject);
var
  lGIBSUFTotJSONObj: TACBrJSONObject;
begin
  if AGIBSUFTot.vIBSUF = 0 then
    exit;

  lGIBSUFTotJSONObj := TACBrJSONObject.Create;
  lGIBSUFTotJSONObj.AddPair('vDif', AGIBSUFTot.vDif);
  lGIBSUFTotJSONObj.AddPair('vDevTrib', AGIBSUFTot.vDevTrib);
  lGIBSUFTotJSONObj.AddPair('vIBSUF', AGIBSUFTot.vIBSUF);

  AJSONObject.AddPair('gIBSUFTot', lGIBSUFTotJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBSTot_gIBS_gIBSMunTot(const AGIBSMunTot: TgIBSMunTot; AJSONObject: TACBrJSONObject);
var
  lGIBSMunTotJSONObj: TACBrJSONObject;
begin
  if AGIBSMunTot.vIBSMun = 0 then
    exit;

  lGIBSMunTotJSONObj := TACBrJSONObject.Create;
  lGIBSMunTotJSONObj.AddPair('vDif', AGIBSMunTot.vDif);
  lGIBSMunTotJSONObj.AddPair('vDevTrib', AGIBSMunTot.vDevTrib);
  lGIBSMunTotJSONObj.AddPair('vIBSMun', AGIBSMunTot.vIBSMun);

  AJSONObject.AddPair('gIBSMunTot', lGIBSMunTotJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBSTot_gCBS(const AGCBS: TgCBSTot; AJSONObject: TACBrJSONObject);
var
  lGCBSJSONObj: TACBrJSONObject;
begin
  if AGCBS.vCBS = 0 then
    exit;

  lGCBSJSONObj := TACBrJSONObject.Create;
  lGCBSJSONObj.AddPair('vDif', AGCBS.vDif);
  lGCBSJSONObj.AddPair('vDevTrib', AGCBS.vDevTrib);
  lGCBSJSONObj.AddPair('vCBS', AGCBS.vCBS);
  lGCBSJSONObj.AddPair('vCredPres', AGCBS.vCredPres);
  lGCBSJSONObj.AddPair('vCredPresCondSus', AGCBS.vCredPresCondSus);

  AJSONObject.AddPair('gCBS', lGCBSJSONObj);
end;

procedure TNFeJSONWriter.Gerar_IBSCBSTot_gMono(const AGMono: TgMono; AJSONObject: TACBrJSONObject);
var
  lGMonoJSONObj: TACBrJSONObject;
begin
  if (AGMono.vIBSMono = 0) and (AGMono.vCBSMono = 0) then
    exit;

  lGMonoJSONObj := TACBrJSONObject.Create;
  lGMonoJSONObj.AddPair('vIBSMono', AGMono.vIBSMono);
  lGMonoJSONObj.AddPair('vCBSMono', AGMono.vCBSMono);
  lGMonoJSONObj.AddPair('vIBSMonoReten', AGMono.vIBSMonoReten);
  lGMonoJSONObj.AddPair('vCBSMonoReten', AGMono.vCBSMonoReten);
  lGMonoJSONObj.AddPair('vIBSMonoRet', AGMono.vIBSMonoRet);
  lGMonoJSONObj.AddPair('vCBSMonoRet', AGMono.vCBSMonoRet);

  AJSONObject.AddPair('gMono', lGMonoJSONObj);
end;


end.

