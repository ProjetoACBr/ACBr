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

unit ACBrNFe.JSONReader;

interface

uses
  Classes, SysUtils, ACBrJSON, ACBrNFe.Classes;

type
  { TNFeJSONReader }
  TNFeJSONReader = class
  private
    FNFe: TNFe;

    procedure LerInfNFe(const AJSONObject: TACBrJSONObject);
    procedure LerIde(const AJSONObject: TACBrJSONObject; AIde: TIde);
    procedure LerIdeNFref(const AJSONArray: TACBrJSONArray; ANFRef: TNFrefCollection);
    procedure LerEmit(const AJSONObject: TACBrJSONObject; AEmit: TEmit);
    procedure LerEmitEnderEmit(const AJSONObject: TACBrJSONObject; AEnderEmit: TenderEmit);
    procedure LerAvulsa(const AJSONObject: TACBrJSONObject; AAvulsa: TAvulsa);
    procedure LerDest(const AJSONObject: TACBrJSONObject; ADest: TDest);
    procedure LerDestEnderDest(const AJSONObject: TACBrJSONObject; AEnderDest: TEnderDest);
    procedure LerRetirada(const AJSONObject: TACBrJSONObject; ARetirada: TRetirada);
    procedure LerEntrega(const AJSONObject: TACBrJSONObject; AEntrega: TEntrega);
    procedure LerAutXML(const AJSONArray: TACBrJSONArray; AAutXML: TautXMLCollection);
    procedure LerDet(const AJSONArray: TACBrJSONArray; ADet: TDetCollection);
    procedure LerDetProd(const AJSONObject: TACBrJSONObject; AProd: TProd);
    procedure LerDetProd_CredPresumido(const AJSONArray: TACBrJSONArray; ACredPresumido: TCredPresumidoCollection);
    procedure LerDetProd_NVE(const AJSONArray: TACBrJSONArray; ANVe: TNVECollection);
    procedure LerDetProd_DI(const AJSONArray: TACBrJSONArray; ADI: TDICollection);
    procedure LerDetProd_DIAdi(const AJSONArray: TACBrJSONArray; AAdi: TAdiCollection);
    procedure LerDetProd_DetExport(const AJSONArray: TACBrJSONArray; ADetExport: TdetExportCollection);
    procedure LerDetProd_Rastro(const AJSONArray: TACBrJSONArray; ARastro: TRastroCollection);
    procedure LerDetProd_VeicProd(const AJSONObject: TACBrJSONObject; AVeicProd: TveicProd);
    procedure LerDetProd_Med(const AJSONObject: TACBrJSONObject; AMed: TMedCollection);
    procedure LerDetProd_Arma(const AJSONArray: TACBrJSONArray; AArma: TArmaCollection);
    procedure LerDetProd_Comb(const AJSONObject: TACBrJSONObject; AComb: TComb);
    procedure LerDetProd_CombCide(const AJSONObject: TACBrJSONObject; ACide: TCIDE);
    procedure LerDetProd_CombEncerrante(const AJSONObject: TACBrJSONObject; AEncerrante: TEncerrante);
    procedure LerDetProd_CombOrigComb(const AJSONArray: TACBrJSONArray; AOrigComb: TorigCombCollection);
    procedure LerDetProd_CombICMSComb(const AJSONObject: TACBrJSONObject; AICMS: TICMSComb);
    procedure LerDetProd_CombICMSInter(const AJSONObject: TACBrJSONObject; AICMS: TICMSInter);
    procedure LerDetProd_CombICMSCons(const AJSONObject: TACBrJSONObject; AICMS: TICMSCons);
    procedure LerDetImposto(const AJSONObject: TACBrJSONObject; AImposto: TImposto);
    procedure LerDetImposto_ICMS(const AJSONObject: TACBrJSONObject; AICMS: TICMS);
    procedure LerDetImposto_ICMSICMSUFDest(const AJSONObject: TACBrJSONObject; AICMSUfDest: TICMSUFDest);
    procedure LerDetImposto_IPI(const AJSONObject: TACBrJSONObject; AIPI: TIPI);
    procedure LerDetImposto_II(const AJSONObject: TACBrJSONObject; AII: TII);
    procedure LerDetImposto_PIS(const AJSONObject: TACBrJSONObject; APIS: TPIS);
    procedure LerDetImposto_PISST(const AJSONObject: TACBrJSONObject; APISST: TPISST);
    procedure LerDetImposto_COFINS(const AJSONObject: TACBrJSONObject; ACOFINS: TCOFINS);
    procedure LerDetImposto_COFINSST(const AJSONObject: TACBrJSONObject; ACOFINSST: TCOFINSST);
    procedure LerDetImposto_ISSQN(const AJSONObject: TACBrJSONObject; AISSQN: TISSQN);
    procedure LerDetObs(const AJSONObject: TACBrJSONObject; AObs: TobsItem);
    procedure LerTotal(const AJSONObject: TACBrJSONObject; ATotal: TTotal);
    procedure LerTotal_ICMSTot(const AJSONObject: TACBrJSONObject; AICMSTot: TICMSTot);
    procedure LerTotal_ISSQNTot(const AJSONObject: TACBrJSONObject; AISSQNTot: TISSQNtot);
    procedure LerTotal_retTrib(const AJSONObject: TACBrJSONObject; ARetTrib: TretTrib);
    procedure LerTransp(const AJSONObject: TACBrJSONObject; ATransp: TTransp);
    procedure LerTransp_Transporta(const AJSONObject: TACBrJSONObject; ATransporta: TTransporta);
    procedure LerTransp_retTransp(const AJSONObject: TACBrJSONObject; ARetTransp: TretTransp);
    procedure LerTransp_veicTransp(const AJSONObject: TACBrJSONObject; AVeicTransp: TveicTransp);
    procedure LerTransp_reboque(const AJSONArray: TACBrJSONArray; AReboque: TReboqueCollection);
    procedure LerTransp_Vol(const AJSONArray: TACBrJSONArray; AVol: TVolCollection);
    procedure LerTransp_VolLacres(const AJSONArray: TACBrJSONArray; ALacres: TLacresCollection);
    procedure LerCobr(const AJSONObject: TACBrJSONObject; ACobr: TCobr);
    procedure LerCobr_fat(const AJSONObject: TACBrJSONObject; AFat: TFat);
    procedure LerCobr_dup(const AJSONArray: TACBrJSONArray; ADup: TDupCollection);
    procedure LerPag(const AJSONObject: TACBrJSONObject; APag: TpagCollection);
    procedure LerInfIntermed(const AJSONObject: TACBrJSONObject; AInfIntermed: TinfIntermed);
    procedure LerInfAdic(const AJSONObject: TACBrJSONObject; AInfAdic: TInfAdic);
    procedure LerInfAdic_obsCont(const AJSONArray: TACBrJSONArray; AObsCont: TobsContCollection);
    procedure LerInfAdic_obsFisco(const AJSONArray: TACBrJSONArray; AObsFisco: TobsFiscoCollection);
    procedure LerInfAdic_procRef(const AJSONArray: TACBrJSONArray; AProcRef: TprocRefCollection);
    procedure LerExporta(const AJSONObject: TACBrJSONObject; AExporta: TExporta);
    procedure LerCompra(const AJSONObject: TACBrJSONObject; ACompra: TCompra);
    procedure LerCana(const AJSONObject: TACBrJSONObject; ACana: Tcana);
    procedure LerCana_fordia(const AJSONArray: TACBrJSONArray; AForDia: TForDiaCollection);
    procedure LerCana_deduc(const AJSONArray: TACBrJSONArray; ADeduc: TDeducCollection);
    procedure LerInfRespTec(const AJSONObject: TACBrJSONObject; AInfRespTec: TinfRespTec);
    procedure LerInfNFeSupl(const AJSONObject: TACBrJSONObject; AInfNFeSupl: TinfNFeSupl);
    procedure LerAgropecuario(const AJSONObject: TACBrJSONObject; AAgropecuario: Tagropecuario);
    procedure Ler_defensivo(const AJSONArray: TACBrJSONArray; ADefensivo: TdefensivoCollection);
    procedure Ler_guiaTransito(const AJSONObject: TACBrJSONObject; AGuiaTransito: TguiaTransito);

    // Reforma Tributria
    procedure Ler_gCompraGov(const AJSONObject: TACBrJSONObject; AgCompraGov: TgCompraGov);
    procedure Ler_gPagAntecipado(const AJSONArray: TACBrJSONArray; AgPagAntecipado: TgPagAntecipadoCollection);
    procedure Ler_ISel(const AJSONObject: TACBrJSONObject; AISel: TgIS);
    procedure Ler_IBSCBS(const AJSONObject: TACBrJSONObject; AIBSCBS: TIBSCBS);
    procedure Ler_IBSCBS_gIBSCBS(const AJSONObject: TACBrJSONObject; AGIBSCBS: TgIBSCBS);
    procedure Ler_IBSCBS_gIBSCBSMono(const AJSONObject: TACBrJSONObject; AIBSCBSMono: TgIBSCBSMono);
    procedure Ler_IBSCBS_gIBSCBSMono_gMonoPadrao(const AJSONObject: TACBrJSONObject; AGMonoPadrao: TgMonoPadrao);
    procedure Ler_IBSCBS_gIBSCBSMono_gMonoReten(const AJSONObject: TACBrJSONObject; AGMonoReten: TgMonoReten);
    procedure Ler_IBSCBS_gIBSCBSMono_gMonoRet(const AJSONObject: TACBrJSONObject; AGMonoRet: TgMonoRet);
    procedure Ler_IBSCBS_gIBSCBSMono_gMonoDif(const AJSONObject: TACBrJSONObject; AGMonoDif: TgMonoDif);
    procedure Ler_IBSCBS_gTransfCred(const AJSONObject: TACBrJSONObject; AGTransfCred: TgTransfCred);
    procedure Ler_IBSCBS_gCredPresIBSZFM(const AJSONObject: TACBrJSONObject; AGCredPresIBSZFM: TCredPresIBSZFM);
    procedure Ler_IBSCBS_gIBSCBS_gIBSUF(const AJSONObject: TACBrJSONObject; AIBSUF: TgIBSUF);
    procedure Ler_IBSCBS_gIBSCBS_gIBSCBSUFMun_gDevTrib(const AJSONObject: TACBrJSONObject; AGDevTrib: TgDevTrib);
    procedure Ler_IBSCBS_gIBSCBS_gIBSCBSUFMun_gRed(const AJSONObject: TACBrJSONObject; AGRed: TgRed);
    procedure Ler_IBSCBS_gIBSCBS_gIBSMun(const AJSONObject: TACBrJSONObject; AIBSMun: TgIBSMun);
    procedure Ler_IBSCBS_gIBSCBS_gCBS(const AJSONObject: TACBrJSONObject; AGCBS: TgCBS);
    procedure Ler_IBSCBS_gIBSCBS__gDif(const AJSONObject: TACBrJSONObject; AGDif: TgDif);
    procedure Ler_IBSCBS_gIBSCBS_gTribRegular(const AJSONObject: TACBrJSONObject; AGTribRegular: TgTribRegular);
    procedure Ler_IBSCBS_gIBSCBS_gIBSCBSCredPres(const AJSONObject: TACBrJSONObject; AGIBSCredPres: TgIBSCBSCredPres);
    procedure Ler_IBSCBS_gIBSCBS_gTribCompraGov(const AJSONObject: TACBrJSONObject; AGTribCompraGov: TgTribCompraGov);
    procedure Ler_Det_DFeReferenciado(const AJSONObject: TACBrJSONObject; ADFeReferenciado: TDFeReferenciado);
    procedure Ler_ISTot(const AJSONObject: TACBrJSONObject; AISTot: TISTot);
    procedure Ler_IBSCBSTot(const AJSONObject: TACBrJSONObject; AIBSCBSTot: TIBSCBSTot);
    procedure Ler_IBSCBSTot_gIBS(const AJSONObject: TACBrJSONObject; AGIBS: TgIBSTot);
    procedure Ler_IBSCBSTot_gIBS_gIBSUFTot(const AJSONObject: TACBrJSONObject; AGIBSUFTot: TgIBSUFTot);
    procedure Ler_IBSCBSTot_gIBS_gIBSMunTot(const AJSONObject: TACBrJSONObject; AGIBSMunTot: TgIBSMunTot);
    procedure Ler_IBSCBSTot_gCBS(const AJSONObject: TACBrJSONObject; AGCBS: TgCBSTot);
    procedure Ler_IBSCBSTot_gMono(const AJSONObject: TACBrJSONObject; AGMono: TgMono);
  public
    constructor Create(AOwner: TNFe); reintroduce;
    destructor Destroy; override;

    function LerJSON(const AJSONString: string): Boolean;

    property NFe: TNFe read FNFe write FNFe;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.FilesIO,
  ACBrDFe.Conversao, pcnConversao, pcnConversaoNFe;

{ TNFeJSONReader }

constructor TNFeJSONReader.Create(AOwner: TNFe);
begin
  inherited Create;
  FNFe := AOwner;
end;

destructor TNFeJSONReader.Destroy;
begin
  inherited;
end;

function TNFeJSONReader.LerJSON(const AJSONString: string): Boolean;
var
  lRootJSONObj, lNFeJSONObj, lInfNFeJSONObj: TACBrJSONObject;
  lJSONLido: String;
begin
  Result := False;

  lJSONLido := LerArquivoOuString(AJSONString);
  if not StringIsJSON(lJSONLido) then
    raise Exception.Create('String JSON informada não é válida');

  lRootJSONObj := TACBrJSONObject.Parse(lJSONLido);
  try
    if not Assigned(lRootJSONObj) then
      raise Exception.Create('Objeto JSON incorreto ou inválido');

    lNFeJSONObj := lRootJSONObj.AsJSONObject['NFe'];
    if not Assigned(lNFeJSONObj) then
      raise Exception.Create('Objeto JSON incorreto. Chave "NFe" não encontrada');

    lInfNFeJSONObj := lNFeJSONObj.AsJSONObject['infNFe'];
    if not Assigned(lInfNFeJSONObj) then
      raise Exception.Create('Objeto JSON incorreto. Chave "infNFe" não encontrada');

    LerInfNFe(lInfNFeJSONObj);
    LerInfNFeSupl(lNFeJSONObj.AsJSONObject['infNFeSupl'], FNFe.infNFeSupl);

    Result := True;
  finally
    lRootJSONObj.Free;
  end;
end;

procedure TNFeJSONReader.LerInfNFe(const AJSONObject: TACBrJSONObject);
begin
  if not Assigned(AJSONObject) then
    Exit;

  FNFe.infNFe.Id := copy(AJSONObject.AsString['Id'], 4, 44);
  FNFe.infNFe.Versao := StringToFloatDef(AJSONObject.AsString['versao'], 4.00);

  LerIde(AJSONObject.AsJSONObject['ide'], FNFe.Ide);
  LerEmit(AJSONObject.AsJSONObject['emit'], FNFe.Emit);
  LerAvulsa(AJSONObject.AsJSONObject['avulsa'], FNFe.Avulsa);
  LerDest(AJSONObject.AsJSONObject['dest'], FNFe.Dest);
  LerRetirada(AJSONObject.AsJSONObject['retirada'], FNFe.Retirada);
  LerEntrega(AJSONObject.AsJSONObject['entrega'], FNFe.Entrega);
  LerAutXML(AJSONObject.AsJSONArray['autXML'], FNFe.autXML);
  LerDet(AJSONObject.AsJSONArray['det'], FNFe.Det);
  LerTotal(AJSONObject.AsJSONObject['total'], FNFe.Total);
  LerTransp(AJSONObject.AsJSONObject['transp'], FNFe.Transp);
  LerCobr(AJSONObject.AsJSONObject['cobr'], FNFe.Cobr);
  LerPag(AJSONObject.AsJSONObject['pag'], FNFe.pag);
  LerInfIntermed(AJSONObject.AsJSONObject['infIntermed'], FNFe.infIntermed);
  LerInfAdic(AJSONObject.AsJSONObject['infAdic'], FNFe.InfAdic);
  LerExporta(AJSONObject.AsJSONObject['exporta'], FNFe.exporta);
  LerCompra(AJSONObject.AsJSONObject['compra'], FNFe.compra);
  LerCana(AJSONObject.AsJSONObject['cana'], FNFe.cana);
  LerInfRespTec(AJSONObject.AsJSONObject['infRespTec'], FNFe.infRespTec);
  LerAgropecuario(AJSONObject.AsJSONObject['agropecuario'], FNFe.agropecuario);
end;

procedure TNFeJSONReader.LerIde(const AJSONObject: TACBrJSONObject; AIde: TIde);
var
  ok: Boolean;
begin
  if not Assigned(AJSONObject) then
    Exit;

  AIde.cUF := AJSONObject.AsInteger['cUF'];
  AIde.cNF := AJSONObject.AsInteger['cNF'];
  if AIde.cNF = 0 then
    AIde.cNF := -2;
  AIde.natOp := AJSONObject.AsString['natOp'];
  AIde.indPag := StrToIndpagEX(AJSONObject.AsString['indPag']);
  AIde.modelo := AJSONObject.AsInteger['mod'];
  AIde.serie := AJSONObject.AsInteger['serie'];
  AIde.nNF := AJSONObject.AsInteger['nNF'];
  AIde.dEmi := AJSONObject.AsISODateTime['dhEmi'];
  AIde.dSaiEnt := AJSONObject.AsISODateTime['dhSaiEnt'];
  AIde.tpNF := StrToTpNF(ok, AJSONObject.AsString['tpNF']);
  AIde.idDest := StrToDestinoOperacao(ok, AJSONObject.AsString['idDest']);
  AIde.cMunFG := AJSONObject.AsInteger['cMunFG'];
  AIde.cMunFGIBS := AJSONObject.AsInteger['cMunFGIBS'];
  AIde.tpImp := StrToTpImp(ok, AJSONObject.AsString['tpImp']);
  AIde.tpEmis := StrToTpEmis(ok, AJSONObject.AsString['tpEmis']);
  AIde.cDV := AJSONObject.AsInteger['cDV'];
  AIde.tpAmb := StrToTpAmb(ok, AJSONObject.AsString['tpAmb']);
  AIde.finNFe := StrToFinNFe(ok, AJSONObject.AsString['finNFe']);
  AIde.tpNFDebito := StrTotpNFDebito(AJSONObject.AsString['tpNFDebito']);
  AIde.tpNFCredito := StrTotpNFCredito(AJSONObject.AsString['tpNFCredito']);
  AIde.indFinal := StrToConsumidorFinal(ok, AJSONObject.AsString['indFinal']);
  AIde.indPres := StrToPresencaComprador(ok, AJSONObject.AsString['indPres']);
  AIde.indIntermed := StrToIndIntermed(ok, AJSONObject.AsString['indIntermed']);
  AIde.procEmi := StrToProcEmi(ok, AJSONObject.AsString['procEmi']);
  AIde.verProc := AJSONObject.AsString['verProc'];
  AIde.dhCont := AJSONObject.AsISODateTime['dhCont'];
  AIde.xJust := AJSONObject.AsString['xJust'];

  LerIdeNFref(AJSONObject.AsJSONArray['NFref'], AIde.NFref);
  Ler_gCompraGov(AJSONOBject.AsJSONObject['gCompraGov'], AIde.gCompraGov);
  Ler_gPagAntecipado(AJSONObject.AsJSONArray['gPagAntecipado'], AIde.gPagAntecipado);
end;

procedure TNFeJSONReader.Ler_gPagAntecipado(const AJSONArray: TACBrJSONArray; AgPagAntecipado: TgPagAntecipadoCollection);
var
  Item: TgPagAntecipadoCollectionItem;
  i: Integer;
begin
  if not Assigned(AJSONArray) then
    Exit;

  for i := 0 to AJSONArray.Count - 1 do
  begin
    Item := AgPagAntecipado.New;
    Item.refNFe := AJSONArray.Items[i];
  end;
end;

procedure TNFeJSONReader.LerIdeNFref(const AJSONArray: TACBrJSONArray; ANFRef: TNFrefCollection);
var
  ok: Boolean;
  i: Integer;
  lNFRefJSONObj, lAuxRefJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    Exit;

  ANFRef.Clear;
  for i:=0 to AJSONArray.Count -1 do
  begin
    lNFRefJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lNFRefJSONObj) then
      continue;

    ANFRef.New;
    ANFRef[i].refNFe := lNFRefJSONObj.AsString['refNFe'];
    if Trim(ANFRef[i].refNFe) <> '' then
      continue;

    ANFRef[i].refNFeSig := lNFRefJSONObj.AsString['refNFeSig'];
    if Trim(ANFRef[i].refNFeSig) <> '' then
      continue;

    ANFRef[i].refCTe := lNFRefJSONObj.AsString['refCTe'];
    if Trim(ANFRef[i].refCTe) <> '' then
      continue;

    lAuxRefJSONObj := lNFRefJSONObj.AsJSONObject['refNF'];
    if Assigned(lAuxRefJSONObj) then
    begin
      ANFRef[i].RefNF.AAMM := lAuxRefJSONObj.AsString['AAMM'];
      ANFRef[i].RefNF.CNPJ := lAuxRefJSONObj.AsString['CNPJ'];
      ANFRef[i].RefNF.cUF := lAuxRefJSONObj.AsInteger['cUF'];
      ANFRef[i].RefNF.modelo := lAuxRefJSONObj.AsInteger['modelo'];
      ANFRef[i].RefNF.nNF := lAuxRefJSONObj.AsInteger['nNF'];
      ANFRef[i].RefNF.serie := lAuxRefJSONObj.AsInteger['serie'];
      continue;
    end;

    lAuxRefJSONObj := lNFRefJSONObj.AsJSONObject['refNFP'];
    if Assigned(lAuxRefJSONObj) then
    begin
      ANFRef[i].RefNFP.nNF := lAuxRefJSONObj.AsInteger['nNF'];
      ANFRef[i].RefNFP.modelo := lAuxRefJSONObj.AsString['modelo'];
      ANFRef[i].RefNFP.cUF := lAuxRefJSONObj.AsInteger['cUF'];
      ANFRef[i].RefNFP.AAMM := lAuxRefJSONObj.AsString['AAMM'];
      ANFRef[i].RefNFP.CNPJCPF := lAuxRefJSONObj.AsString['CNPJCPF'];
      ANFRef[i].RefNFP.IE := lAuxRefJSONObj.AsString['IE'];
      ANFRef[I].RefNFP.serie := lAuxRefJSONObj.AsInteger['serie'];
      continue;
    end;

    lAuxRefJSONObj := lNFRefJSONObj.AsJSONObject['refECF'];
    if Assigned(lAuxRefJSONObj) then
    begin
      ANFRef[i].RefECF.modelo := StrToECFModRef(Ok, lAuxRefJSONObj.AsString['modelo']);
      ANFRef[i].RefECF.nCOO := lAuxRefJSONObj.AsString['nCOO'];
      ANFRef[i].RefECF.nECF := lAuxRefJSONObj.AsString['nECF'];
      continue;
    end;
  end;
end;

procedure TNFeJSONReader.LerEmit(const AJSONObject: TACBrJSONObject; AEmit: TEmit);
var
  ok: Boolean;
begin
  if not Assigned(AJSONObject) then
    Exit;

  if AJSONObject.ValueExists('CNPJ') then
    AEmit.CNPJCPF := AJSONObject.AsString['CNPJ']
  else if AJSONObject.ValueExists('CPF') then
    AEmit.CNPJCPF := AJSONObject.AsString['CPF'];

  AEmit.xNome := AJSONObject.AsString['xNome'];
  AEmit.xFant := AJSONObject.AsString['xFant'];
  AEmit.IE := AJSONObject.AsString['IE'];
  AEmit.IEST := AJSONObject.AsString['IEST'];
  AEmit.IM := AJSONObject.AsString['IM'];
  AEmit.CNAE := AJSONObject.AsString['CNAE'];
  AEmit.CRT := StrToCRT(ok, AJSONObject.AsString['CRT']);

  LerEmitEnderEmit(AJSONObject.AsJSONObject['enderEmit'], AEmit.enderEmit);
end;

procedure TNFeJSONReader.LerEmitEnderEmit(const AJSONObject: TACBrJSONObject; AEnderEmit: TenderEmit);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AEnderEmit.xLgr := AJSONObject.AsString['xLgr'];
  AEnderEmit.nro := AJSONObject.AsString['nro'];
  AEnderEmit.xCpl := AJSONObject.AsString['xCpl'];
  AEnderEmit.xBairro := AJSONObject.AsString['xBairro'];
  AEnderEmit.cMun := AJSONObject.AsInteger['cMun'];
  AEnderEmit.xMun := AJSONObject.AsString['xMun'];
  AEnderEmit.UF := AJSONObject.AsString['UF'];
  AEnderEmit.CEP := AJSONObject.AsInteger['CEP'];
  AEnderEmit.cPais := AJSONObject.AsInteger['cPais'];

  if AEnderEmit.cPais = 0 then
    AEnderEmit.cPais := 1058;

  AEnderEmit.xPais := AJSONObject.AsString['xPais'];

  if AEnderEmit.xPais = '' then
    AEnderEmit.xPais := 'BRASIL';

  AEnderEmit.fone := AJSONObject.AsString['fone'];
end;

procedure TNFeJSONReader.LerAvulsa(const AJSONObject: TACBrJSONObject; AAvulsa: TAvulsa);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AAvulsa.CNPJ := AJSONObject.AsString['CNPJ'];
  AAvulsa.xOrgao := AJSONObject.AsString['xOrgao'];
  AAvulsa.matr := AJSONObject.AsString['matr'];
  AAvulsa.xAgente := AJSONObject.AsString['xAgente'];
  AAvulsa.fone := AJSONObject.AsString['fone'];
  AAvulsa.UF := AJSONObject.AsString['UF'];
  AAvulsa.nDAR := AJSONObject.AsString['nDAR'];
  AAvulsa.dEmi := AJSONObject.AsISODate['dEmi'];
  AAvulsa.vDAR := AJSONObject.AsFloat['vDAR'];
  AAvulsa.repEmi := AJSONObject.AsString['repEmi'];
  AAvulsa.dPag := AJSONObject.AsISODate['dPag'];
end;

procedure TNFeJSONReader.LerDest(const AJSONObject: TACBrJSONObject; ADest: TDest);
var
  ok: Boolean;
begin
  if not Assigned(AJSONObject) then
  begin
    ADest.indIEDest := inNaoContribuinte;
    Exit;
  end;

  if AJSONObject.ValueExists('CNPJ') then
    ADest.CNPJCPF := AJSONObject.AsString['CNPJ']
  else if AJSONObject.ValueExists('CPF') then
    ADest.CNPJCPF := AJSONObject.AsString['CPF'];

  ADest.idEstrangeiro := AJSONObject.AsString['idEstrangeiro'];
  ADest.xNome := AJSONObject.AsString['xNome'];
  ADest.indIEDest := StrToindIEDest(Ok, AJSONObject.AsString['indIEDest']);
  ADest.IE := AJSONObject.AsString['IE'];
  ADest.ISUF := AJSONObject.AsString['ISUF'];
  ADest.IM := AJSONObject.AsString['IM'];
  ADest.Email := AJSONObject.AsString['email'];

  LerDestEnderDest(AJSONObject.AsJSONObject['enderDest'], ADest.EnderDest);
end;

procedure TNFeJSONReader.LerDestEnderDest(const AJSONObject: TACBrJSONObject; AEnderDest: TEnderDest);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AEnderDest.xLgr := AJSONObject.AsString['xLgr'];
  AEnderDest.nro := AJSONObject.AsString['nro'];
  AEnderDest.xCpl := AJSONObject.AsString['xCpl'];
  AEnderDest.xBairro := AJSONObject.AsString['xBairro'];
  AEnderDest.cMun := AJSONObject.AsInteger['cMun'];
  AEnderDest.xMun := AJSONObject.AsString['xMun'];
  AEnderDest.UF := AJSONObject.AsString['UF'];
  AEnderDest.CEP := AJSONObject.AsInteger['CEP'];
  AEnderDest.cPais := AJSONObject.AsInteger['cPais'];

  if AEnderDest.cPais = 0 then
    AEnderDest.cPais := 1058;

  AEnderDest.xPais := AJSONObject.AsString['xPais'];

  if AEnderDest.xPais = '' then
    AEnderDest.xPais := 'BRASIL';

  AEnderDest.fone := AJSONObject.AsString['fone'];
end;

procedure TNFeJSONReader.LerRetirada(const AJSONObject: TACBrJSONObject; ARetirada: TRetirada);
begin
  if not Assigned(AJSONObject) then
    Exit;

  if AJSONObject.ValueExists('CNPJ') then
    ARetirada.CNPJCPF := AJSONObject.AsString['CNPJ']
  else if AJSONObject.ValueExists('CPF') then
    ARetirada.CNPJCPF := AJSONObject.AsString['CPF'];

  ARetirada.xNome := AJSONObject.AsString['xNome'];
  ARetirada.xLgr := AJSONObject.AsString['xLgr'];
  ARetirada.nro := AJSONObject.AsString['nro'];
  ARetirada.xCpl := AJSONObject.AsString['xCpl'];
  ARetirada.xBairro := AJSONObject.AsString['xBairro'];
  ARetirada.cMun := AJSONObject.AsInteger['cMun'];
  ARetirada.xMun := AJSONObject.AsString['xMun'];
  ARetirada.UF := AJSONObject.AsString['UF'];
  ARetirada.CEP := AJSONObject.AsInteger['CEP'];
  ARetirada.cPais := AJSONObject.AsInteger['cPais'];
  ARetirada.xPais := AJSONObject.AsString['xPais'];
  ARetirada.fone := AJSONObject.AsString['fone'];
  ARetirada.Email := AJSONObject.AsString['email'];
  ARetirada.IE := AJSONObject.AsString['IE'];
end;

procedure TNFeJSONReader.LerEntrega(const AJSONObject: TACBrJSONObject; AEntrega: TEntrega);
begin
  if not Assigned(AJSONObject) then
    Exit;

  if AJSONObject.ValueExists('CNPJ') then
    AEntrega.CNPJCPF := AJSONObject.AsString['CNPJ']
  else if AJSONObject.ValueExists('CPF') then
    AEntrega.CNPJCPF := AJSONObject.AsString['CPF'];

  AEntrega.xNome := AJSONObject.AsString['xNome'];
  AEntrega.xLgr := AJSONObject.AsString['xLgr'];
  AEntrega.nro := AJSONObject.AsString['nro'];
  AEntrega.xCpl := AJSONObject.AsString['xCpl'];
  AEntrega.xBairro := AJSONObject.AsString['xBairro'];
  AEntrega.cMun := AJSONObject.AsInteger['cMun'];
  AEntrega.xMun := AJSONObject.AsString['xMun'];
  AEntrega.UF := AJSONObject.AsString['UF'];
  AEntrega.CEP := AJSONObject.AsInteger['CEP'];
  AEntrega.cPais := AJSONObject.AsInteger['cPais'];
  AEntrega.xPais := AJSONObject.AsString['xPais'];
  AEntrega.fone := AJSONObject.AsString['fone'];
  AEntrega.Email := AJSONObject.AsString['email'];
  AEntrega.IE := AJSONObject.AsString['IE'];
end;

procedure TNFeJSONReader.LerAutXML(const AJSONArray: TACBrJSONArray; AAutXML: TautXMLCollection);
var
  i: Integer;
  lAutXMLJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    exit;

  AAutXML.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lAutXMLJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lAutXMLJSONObj) then
      continue;

    AAutXML.New;
    if lAutXMLJSONObj.ValueExists('CNPJ') then
      AAutXML[i].CNPJCPF := lAutXMLJSONObj.AsString['CNPJ']
    else if lAutXMLJSONObj.ValueExists('CPF') then
      AAutXML[i].CNPJCPF := lAutXMLJSONObj.AsString['CPF'];
  end;
end;

procedure TNFeJSONReader.LerDet(const AJSONArray: TACBrJSONArray; ADet: TDetCollection);
var
  i: Integer;
  lDetItem: TDetCollectionItem;
  lDetJSONObj, lImpostoDevolIPIJSONObj, lIPIJSONObj, lObsItemJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    Exit;

  for i := 0 to AJSONArray.Count - 1 do
  begin
    lDetJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lDetJSONObj) then
      continue;

    lDetItem := ADet.New;
    lDetItem.prod.nItem := lDetJSONObj.AsInteger['nItem'];
    lDetItem.infAdProd := lDetJSONObj.AsString['infAdProd'];

    LerDetProd(lDetJSONObj.AsJSONObject['prod'], lDetItem.Prod);
    LerDetImposto(lDetJSONObj.AsJSONObject['imposto'], lDetItem.Imposto);

    lImpostoDevolIPIJSONObj := lDetJSONObj.AsJSONObject['impostoDevol'];
    if Assigned(lImpostoDevolIPIJSONObj) then
    begin
      lDetItem.pDevol := lImpostoDevolIPIJSONObj.AsFloat['pDevol'];

      lIPIJSONObj := lImpostoDevolIPIJSONObj.AsJSONObject['IPI'];
      if Assigned(lIPIJSONObj) then
        lDetItem.vIPIDevol := lIPIJSONObj.AsFloat['vIPIDevol'];
    end;

    lObsItemJSONObj := lDetJSONObj.AsJSONObject['obsItem'];
    LerDetObs(lObsItemJSONObj.AsJSONObject['obsCont'], lDetItem.obsCont);
    LerDetObs(lObsItemJSONObj.AsJSONObject['obsFisco'], lDetItem.obsFisco);
    lDetItem.vItem := lDetJSONObj.AsFloat['vItem'];
    Ler_Det_DFeReferenciado(lDetJSONObj.AsJSONObject['DFeReferenciado'], lDetItem.DFeReferenciado);
  end;
end;

procedure TNFeJSONReader.LerDetProd(const AJSONObject: TACBrJSONObject; AProd: TProd);
var
  ok: Boolean;
begin
  if not Assigned(AJSONObject) then
    Exit;

  AProd.cProd := AJSONObject.AsString['cProd'];
  AProd.cEAN  := AJSONObject.AsString['cEAN'];
  AProd.cBarra := AJSONObject.AsString['cBarra'];
  AProd.xProd := AJSONObject.AsString['xProd'];
  AProd.NCM   := AJSONObject.AsString['NCM'];
  AProd.CEST := AJSONObject.AsString['CEST'];
  AProd.indEscala := StrToindEscala(ok, AJSONObject.AsString['indEscala']);
  AProd.CNPJFab   := AJSONObject.AsString['CNPJFab'];
  AProd.cBenef    := AJSONObject.AsString['cBenef'];
  AProd.EXTIPI   := AJSONObject.AsString['EXTIPI'];
  AProd.CFOP     := AJSONObject.AsString['CFOP'];
  AProd.uCom     := AJSONObject.AsString['uCom'];
  AProd.qCom     := AJSONObject.AsFloat['qCom'];
  AProd.vUnCom  := AJSONObject.AsFloat['vUnCom'];
  AProd.vProd    := AJSONObject.AsFloat['vProd'];
  AProd.cEANTrib := AJSONObject.AsString['cEANTrib'];
  AProd.cBarraTrib := AJSONObject.AsString['cBarraTrib'];
  AProd.uTrib    := AJSONObject.AsString['uTrib'];
  AProd.qTrib    := AJSONObject.AsFloat['qTrib'];
  AProd.vUnTrib := AJSONObject.AsFloat['vUnTrib'];
  AProd.vFrete   := AJSONObject.AsFloat['vFrete'];
  AProd.vSeg     := AJSONObject.AsFloat['vSeg'];
  AProd.vDesc    := AJSONObject.AsFloat['vDesc'];
  AProd.vOutro  := AJSONObject.AsFloat['vOutro'];
  AProd.IndTot  := StrToindTot(ok, AJSONObject.AsString['indTot']);
  AProd.xPed     := AJSONObject.AsString['xPed'];
  AProd.nItemPed := AJSONObject.AsString['nItemPed'];
  AProd.nRECOPI  := AJSONObject.AsString['nRECOPI'];
  AProd.nFCI     := AJSONObject.AsString['nFCI'];
  // Reforma Tributria
  AProd.indBemMovelUsado := StrToTIndicadorEx(ok, AJSONObject.AsString['indBemMovelUsado']);

  LerDetProd_CredPresumido(AJSONObject.AsJSONArray['gCred'], AProd.CredPresumido);
  LerDetProd_NVE(AJSONObject.AsJSONArray['NVE'], AProd.NVE);
  LerDetProd_DI(AJSONObject.AsJSONArray['DI'], AProd.DI);
  LerDetProd_DetExport(AJSONObject.AsJSONArray['detExport'], AProd.detExport);
  LerDetProd_Rastro(AJSONObject.AsJSONArray['rastro'], AProd.rastro);
  LerDetProd_VeicProd(AJSONObject.AsJSONObject['veicProd'], AProd.veicProd);
  LerDetProd_Med(AJSONObject.AsJSONObject['med'], AProd.med);
  LerDetProd_Arma(AJSONObject.AsJSONArray['arma'], AProd.arma);
  LerDetProd_Comb(AJSONObject.AsJSONObject['comb'], AProd.comb);
end;

procedure TNFeJSONReader.LerDetProd_CredPresumido(const AJSONArray: TACBrJSONArray; ACredPresumido: TCredPresumidoCollection);
var
  i: Integer;
  lCredPresumidoJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    exit;

  ACredPresumido.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lCredPresumidoJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lCredPresumidoJSONObj) then
      continue;

    ACredPresumido.New;
    ACredPresumido[i].cCredPresumido := lCredPresumidoJSONObj.AsString['cCredPresumido'];
    ACredPresumido[i].vCredPresumido := lCredPresumidoJSONObj.AsFloat['pCredPresumido'];
    ACredPresumido[i].pCredPresumido := lCredPresumidoJSONObj.AsFloat['vCredPresumido'];
  end;
end;

procedure TNFeJSONReader.LerDetProd_NVE(const AJSONArray: TACBrJSONArray; ANVe: TNVECollection);
var
  i: Integer;
  lNVEJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    exit;

  ANVe.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lNVEJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lNVEJSONObj) then
      continue;

    ANVe.New;
    ANVE[i].NVE := lNVEJSONObj.AsString['NVE'];
  end;
end;

procedure TNFeJSONReader.LerDetProd_DI(const AJSONArray: TACBrJSONArray; ADI: TDICollection);
var
  ok: Boolean;
  i: Integer;
  lDIJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    Exit;

  ADI.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    LDIJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(LDIJSONObj) then
      continue;

    ADI.New;
    ADI[i].nDI        := lDIJSONObj.AsString['nDI'];
    ADI[i].dDI        := lDIJSONObj.AsISODate['dDI'];
    ADI[i].xLocDesemb := lDIJSONObj.AsString['xLocDesemb'];
    ADI[i].UFDesemb   := lDIJSONObj.AsString['UFDesemb'];
    ADI[i].dDesemb    := lDIJSONObj.AsISODate['dDesemb'];

    ADI[i].tpViaTransp  := StrToTipoViaTransp(Ok, lDIJSONObj.AsString['tpViaTransp']);
    ADI[i].vAFRMM       := lDIJSONObj.AsFloat['vAFRMM'];
    ADI[i].tpIntermedio := StrToTipoIntermedio(Ok, lDIJSONObj.AsString['tpIntermedio']);

    if lDIJSONObj.ValueExists('CNPJ') then
      ADI[i].CNPJ := lDIJSONObj.AsString['CNPJ']
    else if lDIJSONObj.ValueExists('CPF') then
      ADI[i].CNPJ := lDIJSONObj.AsString['CPF'];

    ADI[i].UFTerceiro   := lDIJSONObj.AsString['UFTerceiro'];
    ADI[i].cExportador  := lDIJSONObj.AsString['cExportador'];

    LerDetProd_DIAdi(lDIJSONObj.AsJSONArray['adi'], ADI[i].adi);
  end;
end;

procedure TNFeJSONReader.LerDetProd_DIAdi(const AJSONArray: TACBrJSONArray; AAdi: TAdiCollection);
var
  i: Integer;
  lAdiJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    exit;

  AADi.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lAdiJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lAdiJSONObj) then
      continue;

    AAdi.New;
    AAdi[i].nAdicao     := lAdiJSONObj.AsInteger['nAdicao'];
    AAdi[i].nSeqAdi     := lAdiJSONObj.AsInteger['nSeqAdic'];
    AAdi[i].cFabricante := lAdiJSONObj.AsString['cFabricante'];
    AAdi[i].vDescDI     := lAdiJSONObj.AsFloat['vDescDI'];
    AAdi[i].nDraw       := lAdiJSONObj.AsString['nDraw'];
  end;
end;

procedure TNFeJSONReader.LerDetProd_DetExport(const AJSONArray: TACBrJSONArray; ADetExport: TdetExportCollection);
var
  lDetExportJSONObj, lExportIndJSONObj: TACBrJSONObject;
  i: integer;
begin
  if not Assigned(AJSONArray) then
    Exit;

  ADetExport.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lDetExportJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lDetExportJSONObj) then
      continue;

    ADetExport.New;
    ADetExport[i].nDraw := lDetExportJSONObj.AsString['nDraw'];

    lExportIndJSONObj := lDetExportJSONObj.AsJSONObject['exportInd'];
    if Assigned(lExportIndJSONObj) then
    begin
      ADetExport[i].nRE     := lExportIndJSONObj.AsString['nRE'];
      ADetExport[i].chNFe   := lExportIndJSONObj.AsString['chNFe'];
      ADetExport[i].qExport := lExportIndJSONObj.AsFloat['qExport'];
    end;
  end;
end;

procedure TNFeJSONReader.LerDetProd_Rastro(const AJSONArray: TACBrJSONArray; ARastro: TRastroCollection);
var
  lRastroJSONObj: TACBrJSONObject;
  i: integer;
begin
  if not Assigned(AJSONArray) then
    Exit;

  ARastro.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lRastroJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lRastroJSONObj) then
      continue;

    ARastro.New;
    ARastro[i].nLote  := lRastroJSONObj.AsString['nLote'];
    ARastro[i].qLote  := lRastroJSONObj.AsFloat['qLote'];
    ARastro[i].dFab   := lRastroJSONObj.AsISODate['dFab'];
    ARastro[i].dVal   := lRastroJSONObj.AsISODate['dVal'];
    ARastro[i].cAgreg := lRastroJSONObj.AsString['cAgreg'];
  end;
end;

procedure TNFeJSONReader.LerDetProd_VeicProd(const AJSONObject: TACBrJSONObject; AVeicProd: TveicProd);
var
  ok: Boolean;
begin
  if not Assigned(AJSONObject) then
    Exit;

  AVeicProd.tpOP         := StrToTpOP(ok, AJSONObject.AsString['tpOp']);
  AVeicProd.chassi       := AJSONObject.AsString['chassi'];
  AVeicProd.cCor         := AJSONObject.AsString['cCor'];
  AVeicProd.xCor         := AJSONObject.AsString['xCor'];
  AVeicProd.pot          := AJSONObject.AsString['pot'];
  AVeicProd.Cilin        := AJSONObject.AsString['cilin'];
  AVeicProd.pesoL        := AJSONObject.AsString['pesoL'];
  AVeicProd.pesoB        := AJSONObject.AsString['pesoB'];
  AVeicProd.nSerie       := AJSONObject.AsString['nSerie'];
  AVeicProd.tpComb       := AJSONObject.AsString['tpComb'];
  AVeicProd.nMotor       := AJSONObject.AsString['nMotor'];
  AVeicProd.CMT          := AJSONObject.AsString['CMT'];
  AVeicProd.dist         := AJSONObject.AsString['dist'];
  AVeicProd.anoMod       := AJSONObject.AsInteger['anoMod'];
  AVeicProd.anoFab       := AJSONObject.AsInteger['anoFab'];
  AVeicProd.tpPint       := AJSONObject.AsString['tpPint'];
  AVeicProd.tpVeic       := AJSONObject.AsInteger['tpVeic'];
  AVeicProd.espVeic      := AJSONObject.AsInteger['espVeic'];
  AVeicProd.VIN          := AJSONObject.AsString['VIN'];
  AVeicProd.condVeic     := StrToCondVeic(ok, AJSONObject.AsString['condVeic']);
  AVeicProd.cMod         := AJSONObject.AsString['cMod'];
  AVeicProd.cCorDENATRAN := AJSONObject.AsString['cCorDENATRAN'];
  AVeicProd.lota         := AJSONObject.AsInteger['lota'];
  AVeicProd.tpRest       := AJSONObject.AsInteger['tpRest'];
end;

procedure TNFeJSONReader.LerDetProd_Med(const AJSONObject: TACBrJSONObject; AMed: TMedCollection);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AMed.New;
  AMed[0].cProdANVISA := AJSONObject.AsString['cProdANVISA'];
  AMed[0].xMotivoIsencao := AJSONObject.AsString['xMotivoIsencao'];
  AMed[0].nLote := AJSONObject.AsString['nLote'];
  AMed[0].qLote := AJSONObject.AsFloat['qLote'];
  AMed[0].dFab  := AJSONObject.AsISODate['dFab'];
  AMed[0].dVal  := AJSONObject.AsISODate['dVal'];
  AMed[0].vPMC  := AJSONObject.AsFloat['vPMC'];
end;

procedure TNFeJSONReader.LerDetProd_Arma(const AJSONArray: TACBrJSONArray; AArma: TArmaCollection);
var
  ok: Boolean;
  lArmaJSONObj: TACBrJSONObject;
  i: integer;
begin
  if not Assigned(AJSONArray) then
    Exit;

  AArma.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lArmaJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lArmaJSONObj) then
      exit;

    AArma.New;
    AArma[i].tpArma := StrToTpArma(ok, lArmaJSONObj.AsString['tpArma']);
    AArma[i].nSerie := lArmaJSONObj.AsString['nSerie'];
    AArma[i].nCano  := lArmaJSONObj.AsString['nCano'];
    AArma[i].descr  := lArmaJSONObj.AsString['descr'];
  end;
end;

procedure TNFeJSONReader.LerDetProd_Comb(const AJSONObject: TACBrJSONObject; AComb: TComb);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AComb.cProdANP := AJSONObject.AsInteger['cProdANP'];
  AComb.pMixGN  := AJSONObject.AsFloat['qMixGN'];
  AComb.descANP  := AJSONObject.AsString['descANP'];
  AComb.pGLP    := AJSONObject.AsFloat['pGLP'];
  AComb.pGNn    := AJSONObject.AsFloat['pGNn'];
  AComb.pGNi    := AJSONObject.AsFloat['pGNi'];
  AComb.vPart   := AJSONObject.AsFloat['vPart'];
  AComb.CODIF    := AJSONObject.AsString['CODIF'];
  AComb.qTemp    := AJSONObject.AsFloat['qTemp'];
  AComb.UFcons   := AJSONObject.AsString['UFCons'];
  AComb.ICMSCons.UFcons := AJSONObject.AsString['UFcons'];
  AComb.pBio := AJSONObject.AsFloat['pBio'];

  LerDetProd_CombCide(AJSONObject.AsJSONObject['CIDE'], AComb.CIDE);
  LerDetProd_CombEncerrante(AJSONObject.AsJSONObject['encerrante'], AComb.encerrante);
  LerDetProd_CombOrigComb(AJSONObject.AsJSONArray['origComb'], AComb.origComb);
  LerDetProd_CombICMSComb(AJSONObject.AsJSONObject['ICMSComb'], AComb.ICMS);
  LerDetProd_CombICMSInter(AJSONObject.AsJSONObject['ICMSInter'], AComb.ICMSInter);
  LerDetProd_CombICMSCons(AJSONObject.AsJSONObject['ICMSCons'], AComb.ICMSCons);
end;

procedure TNFeJSONReader.LerDetProd_CombCide(const AJSONObject: TACBrJSONObject; ACide: TCIDE);
begin
  if not Assigned(AJSONObject) then
    exit;

  ACIDE.qBCprod   := AJSONObject.AsFloat['qBCProd'];
  ACIDE.vAliqProd := AJSONObject.AsFloat['vAliqProd'];
  ACIDE.vCIDE     := AJSONObject.AsFloat['vCIDE'];
end;

procedure TNFeJSONReader.LerDetProd_CombEncerrante(const AJSONObject: TACBrJSONObject; AEncerrante: TEncerrante);
begin
  if not Assigned(AJSONObject) then
    exit;

  AEncerrante.nBico   := AJSONObject.AsInteger['nBico'];
  AEncerrante.nBomba  := AJSONObject.AsInteger['nBomba'];
  AEncerrante.nTanque := AJSONObject.AsInteger['nTanque'];
  AEncerrante.vEncIni := AJSONObject.AsFloat['vEncIni'];
  AEncerrante.vEncFin := AJSONObject.AsFloat['vEncFin'];
end;

procedure TNFeJSONReader.LerDetProd_CombOrigComb(const AJSONArray: TACBrJSONArray; AOrigComb: TorigCombCollection);
var
  i: Integer;
  lOrigCombJSONObj: TACBrJSONObject;
  Ok: Boolean;
begin
  if not Assigned(AJSONArray) then
    exit;

  AOrigComb.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lOrigCombJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lOrigCombJSONObj) then
      continue;

    AOrigComb.New;
    AOrigComb[i].indImport := StrToindImport(Ok, lOrigCombJSONObj.AsString['indImport']);
    AOrigComb[i].cUFOrig := lOrigCombJSONObj.AsInteger['cUFOrig'];
    AOrigComb[i].pOrig := lOrigCombJSONObj.AsFloat['pOrig'];
  end;
end;

procedure TNFeJSONReader.LerDetProd_CombICMSComb(const AJSONObject: TACBrJSONObject; AICMS: TICMSComb);
begin
  if not Assigned(AJSONObject) then
    exit;

  AICMS.vBCICMS   := AJSONObject.AsFloat['vBCICMS'];
  AICMS.vICMS     := AJSONObject.AsFloat['vICMS'];
  AICMS.vBCICMSST := AJSONObject.AsFloat['vBCICMSST'];
  AICMS.vICMSST   := AJSONObject.AsFloat['vICMSST'];
end;

procedure TNFeJSONReader.LerDetProd_CombICMSInter(const AJSONObject: TACBrJSONObject; AICMS: TICMSInter);
begin
  if not Assigned(AJSONObject) then
    exit;

  AICMS.vBCICMSSTDest := AJSONObject.AsFloat['vBCICMSSTDest'];
  AICMS.vICMSSTDest   := AJSONObject.AsFloat['vICMSSTDest'];
end;

procedure TNFeJSONReader.LerDetProd_CombICMSCons(const AJSONObject: TACBrJSONObject; AICMS: TICMSCons);
begin
  if not Assigned(AJSONObject) then
    exit;

  AICMS.vBCICMSSTCons := AJSONObject.AsFloat['vBCICMSSTCons'];
  AICMS.vICMSSTCons   := AJSONObject.AsFloat['vICMSSTCons'];
  AICMS.UFcons        := AJSONObject.AsString['UFCons'];
end;

procedure TNFeJSONReader.LerDetImposto(const AJSONObject: TACBrJSONObject; AImposto: TImposto);
var
  lICMSJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONObject) then
    Exit;

  AImposto.vTotTrib := AJSONObject.AsFloat['vTotTrib'];

  lICMSJSONObj := AJSONObject.AsJSONObject['ICMS'];
  if Assigned(lICMSJSONObj) then
  begin
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS00'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS02'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS10'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS15'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS20'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS30'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS40'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS51'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS53'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS60'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS61'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS70'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMS90'], AImposto.ICMS);

    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMSSN101'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMSSN102'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMSSN201'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMSSN202'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMSSN500'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMSSN900'], AImposto.ICMS);

    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMSPart'], AImposto.ICMS);
    LerDetImposto_ICMS(lICMSJSONObj.AsJSONObject['ICMSST'], AImposto.ICMS);
  end;

  LerDetImposto_ICMSICMSUFDest(AJSONObject.AsJSONObject['ICMSUFDest'], AImposto.ICMSUFDest);
  LerDetImposto_IPI(AJSONObject.AsJSONObject['IPI'], AImposto.IPI);
  LerDetImposto_II(AJSONObject.AsJSONObject['II'], AImposto.II);
  LerDetImposto_PIS(AJSONObject.AsJSONObject['PIS'], AImposto.PIS);
  LerDetImposto_PISST(AJSONObject.AsJSONObject['PISST'], AImposto.PISST);
  LerDetImposto_COFINS(AJSONObject.AsJSONObject['COFINS'], AImposto.COFINS);
  LerDetImposto_COFINSST(AJSONObject.AsJSONObject['COFINSST'], AImposto.COFINSST);
  LerDetImposto_ISSQN(AJSONObject.AsJSONObject['ISSQN'], AImposto.ISSQN);

  // Reforma Tributria
  Ler_ISel(AJSONObject.AsJSONObject['IS'], AImposto.ISel);
  Ler_IBSCBS(AJSONObject.AsJSONObject['IBSCBS'], AImposto.IBSCBS);
end;

procedure TNFeJSONReader.LerDetImposto_ICMS(const AJSONObject: TACBrJSONObject; AICMS: TICMS);
var
  Ok: Boolean;
begin
  if not Assigned(AJSONObject) then
    Exit;

  AICMS.orig := StrToOrig(ok, AJSONObject.AsString['orig']);
  AICMS.CST := StrToCSTICMS(ok, AJSONObject.AsString['CST']);
  AICMS.CSOSN := StrToCSOSNIcms(ok, AJSONObject.AsString['CSOSN']);
  AICMS.modBC := StrToModBC(ok, AJSONObject.AsString['modBC']);
  AICMS.pRedBC := AJSONObject.AsFloat['pRedBC'];
  AICMS.vBC := AJSONObject.AsFloat['vBC'];
  AICMS.pICMS := AJSONObject.AsFloat['pICMS'];
  AICMS.vICMSOp := AJSONObject.AsFloat['vICMSOp'];
  AICMS.pDif := AJSONObject.AsFloat['pDif'];
  AICMS.vICMSDif := AJSONObject.AsFloat['vICMSDif'];
  AICMS.vICMS := AJSONObject.AsFloat['vICMS'];
  AICMS.vBCFCP := AJSONObject.AsFloat['vBCFCP'];
  AICMS.pFCP := AJSONObject.AsFloat['pFCP'];
  AICMS.vFCP := AJSONObject.AsFloat['vFCP'];
  AICMS.modBCST := StrToModBCST(ok, AJSONObject.AsString['modBCST']);
  AICMS.pMVAST := AJSONObject.AsFloat['pMVAST'];
  AICMS.pRedBCST := AJSONObject.AsFloat['pRedBCST'];
  AICMS.vBCST := AJSONObject.AsFloat['vBCST'];
  AICMS.pICMSST := AJSONObject.AsFloat['pICMSST'];
  AICMS.vICMSST := AJSONObject.AsFloat['vICMSST'];
  AICMS.vBCFCPST := AJSONObject.AsFloat['vBCFCPST'];
  AICMS.pFCPST := AJSONObject.AsFloat['pFCPST'];
  AICMS.vFCPST := AJSONObject.AsFloat['vFCPST'];
  AICMS.UFST := AJSONObject.AsString['UFST'];
  AICMS.pBCOp := AJSONObject.AsFloat['pBCOp'];
  AICMS.vBCSTRET := AJSONObject.AsFloat['vBCSTRet'];
  AICMS.vICMSSTRET := AJSONObject.AsFloat['vICMSSTRet'];
  AICMS.vICMSDeson := AJSONObject.AsFloat['vICMSDeson'];
  AICMS.vBCFCPSTRet := AJSONObject.AsFloat['vBCFCPSTRet'];
  AICMS.pFCPSTRet := AJSONObject.AsFloat['pFCPSTRet'];
  AICMS.vFCPSTRet := AJSONObject.AsFloat['vFCPSTRet'];
  AICMS.pST := AJSONObject.AsFloat['pST'];
  AICMS.motDesICMS := StrTomotDesICMS(ok, AJSONObject.AsString['motDesICMS']);
  AICMS.pCredSN := AJSONObject.AsFloat['pCredSN'];
  AICMS.vCredICMSSN := AJSONObject.AsFloat['vCredICMSSN'];
  AICMS.vBCSTDest := AJSONObject.AsFloat['vBCSTDest'];
  AICMS.vICMSSTDest := AJSONObject.AsFloat['vICMSSTDest'];
  AICMS.pRedBCEfet := AJSONObject.AsFloat['pRedBCEfet'];
  AICMS.vBCEfet := AJSONObject.AsFloat['vBCEfet'];
  AICMS.pICMSEfet := AJSONObject.AsFloat['pICMSEfet'];
  AICMS.vICMSEfet := AJSONObject.AsFloat['vICMSEfet'];
  AICMS.vICMSSubstituto := AJSONObject.AsFloat['vICMSSubstituto'];
  AICMS.vICMSSTDeson := AJSONObject.AsFloat['vICMSSTDeson'];
  AICMS.motDesICMSST := StrTomotDesICMS(ok, AJSONObject.AsString['motDesICMSST']);
  AICMS.pFCPDif := AJSONObject.AsFloat['pFCPDif'];
  AICMS.vFCPDif := AJSONObject.AsFloat['vFCPDif'];
  AICMS.vFCPEfet := AJSONObject.AsFloat['vFCPEfet'];

  AICMS.adRemICMS := AJSONObject.AsFloat['adRemICMS'];
  AICMS.vICMSMono := AJSONObject.AsFloat['vICMSMono'];
  AICMS.adRemICMSReten := AJSONObject.AsFloat['adRemICMSReten'];
  AICMS.vICMSMonoReten := AJSONObject.AsFloat['vICMSMonoReten'];
  AICMS.vICMSMonoDif := AJSONObject.AsFloat['vICMSMonoDif'];
  AICMS.adRemICMSRet := AJSONObject.AsFloat['adRemICMSRet'];
  AICMS.vICMSMonoRet := AJSONObject.AsFloat['vICMSMonoRet'];

  AICMS.qBCMono := AJSONObject.AsFloat['qBCMono'];
  AICMS.qBCMonoReten := AJSONObject.AsFloat['qBCMonoReten'];
  AICMS.pRedAdRem := AJSONObject.AsFloat['pRedAdRem'];

  if AICMS.pRedAdRem <> 0 then
    AICMS.motRedAdRem := StrTomotRedAdRem(ok, AJSONObject.AsString['motRedAdRem']);

  AICMS.qBCMonoRet := AJSONObject.AsFloat['qBCMonoRet'];
  AICMS.vICMSMonoOp := AJSONObject.AsFloat['vICMSMonoOp'];
  AICMS.indDeduzDeson := StrToTIndicadorEx(Ok, AJSONObject.AsString['indDeduzDeson']);
  AICMS.cBenefRBC := AJSONObject.AsString['cBenefRBC'];
end;

procedure TNFeJSONReader.LerDetImposto_ICMSICMSUFDest(const AJSONObject: TACBrJSONObject; AICMSUfDest: TICMSUFDest);
begin
  if not Assigned(AJSONObject) then
    exit;

  AICMSUFDest.vBCUFDest := AJSONObject.AsFloat['vBCUFDest'];
  AICMSUFDest.vBCFCPUFDest := AJSONObject.AsFloat['vBCFCPUFDest'];
  AICMSUFDest.pFCPUFDest := AJSONObject.AsFloat['pFCPUFDest'];
  AICMSUFDest.pICMSUFDest := AJSONObject.AsFloat['pICMSUFDest'];
  AICMSUFDest.pICMSInter := AJSONObject.AsFloat['pICMSInter'];
  AICMSUFDest.pICMSInterPart := AJSONObject.AsFloat['pICMSInterPart'];
  AICMSUFDest.vFCPUFDest := AJSONObject.AsFloat['vFCPUFDest'];
  AICMSUFDest.vICMSUFDest := AJSONObject.AsFloat['vICMSUFDest'];
  AICMSUFDest.vICMSUFRemet := AJSONObject.AsFloat['vICMSUFRemet'];
end;

procedure TNFeJSONReader.LerDetImposto_IPI(const AJSONObject: TACBrJSONObject; AIPI: TIPI);
var
  lIPITribObj: TACBrJSONObject;
  Ok: Boolean;
begin
  if not Assigned(AJSONObject) then
    exit;

  AIPI.CNPJProd := AJSONObject.AsString['CNPJProd'];
  AIPI.cSelo := AJSONObject.AsString['cSelo'];
  AIPI.qSelo := AJSONObject.AsInteger['qSelo'];
  AIPI.cEnq := AJSONObject.AsString['cEnq'];

  if FNFe.ide.tpNF = tnEntrada then
    AIPI.CST := ipi53
  else
    AIPI.CST := ipi03;

  lIPITribObj := AJSONObject.AsJSONObject['IPITrib'];
  if Assigned(lIPITribObj) then
  begin
    AIPI.CST := StrToCSTIPI(ok, lIPITribObj.AsString['CST']);
    AIPI.vBC := lIPITribObj.AsFloat['vBC'];
    AIPI.qUnid := lIPITribObj.AsFloat['qUnid'];
    AIPI.vUnid := lIPITribObj.AsFloat['vUnid'];
    AIPI.pIPI := lIPITribObj.AsFloat['pIPI'];
    AIPI.vIPI := lIPITribObj.AsFloat['vIPI'];
  end
  else
  begin
    lIPITribObj := AJSONObject.AsJSONObject['IPINT'];
    if Assigned(lIPITribObj) then
      AIPI.CST := StrToCSTIPI(ok, lIPITribObj.AsString['CST']);
  end;
end;

procedure TNFeJSONReader.LerDetImposto_II(const AJSONObject: TACBrJSONObject; AII: TII);
begin
  if not Assigned(AJSONObject) then
    exit;

  AII.vBC := AJSONObject.AsFloat['vBC'];
  AII.vDespAdu := AJSONObject.AsFloat['vDespAdu'];
  AII.vII := AJSONObject.AsFloat['vII'];
  AII.vIOF := AJSONObject.AsFloat['vIOF'];
end;

procedure TNFeJSONReader.LerDetImposto_PIS(const AJSONObject: TACBrJSONObject; APIS: TPIS);
var
  lPISAligJSONObj, lPISQtdeJSONObj, lPISNTJSONObj, lPISOutrJSONObj: TACBrJSONObject;
  OK: Boolean;
begin
  if not Assigned(AJSONObject) then
    exit;

  lPISAligJSONObj := AJSONObject.AsJSONObject['PISAliq'];
  if Assigned(lPISAligJSONObj) then
  begin
    APIS.CST := StrToCSTPIS(ok, lPISAligJSONObj.AsString['CST']);
    APIS.vBC := lPISAligJSONObj.AsFloat['vBC'];
    APIS.pPIS := lPISAligJSONObj.AsFloat['pPIS'];
    APIS.vPIS := lPISAligJSONObj.AsFloat['vPIS'];
  end;

  lPISQtdeJSONObj := AJSONObject.AsJSONObject['PISQtde'];
  if Assigned(lPISQtdeJSONObj) then
  begin
    APIS.CST := StrToCSTPIS(ok, lPISQtdeJSONObj.AsString['CST']);
    APIS.qBCProd := lPISQtdeJSONObj.AsFloat['qBCProd'];
    APIS.vAliqProd := lPISQtdeJSONObj.AsFloat['vAliqProd'];
    APIS.vPIS := lPISQtdeJSONObj.AsFloat['vPIS'];
  end;

  lPISNTJSONObj := AJSONObject.AsJSONObject['PISNT'];
  if Assigned(lPISNTJSONObj) then
  begin
    APIS.CST := StrToCSTPIS(ok, lPISNTJSONObj.AsString['CST']);
  end;

  lPISOutrJSONObj := AJSONObject.AsJSONObject['PISOutr'];
  if Assigned(lPISOutrJSONObj) then
  begin
    APIS.CST := StrToCSTPIS(ok, lPISOutrJSONObj.AsString['CST']);
    APIS.vBC := lPISOutrJSONObj.AsFloat['vBC'];
    APIS.pPIS := lPISOutrJSONObj.AsFloat['pPIS'];
    APIS.qBCProd := lPISOutrJSONObj.AsFloat['qBCProd'];
    APIS.vAliqProd := lPISOutrJSONObj.AsFloat['vAliqProd'];
    APIS.vPIS := lPISOutrJSONObj.AsFloat['vPIS'];
  end;
end;

procedure TNFeJSONReader.LerDetImposto_PISST(const AJSONObject: TACBrJSONObject; APISST: TPISST);
var
  Ok: Boolean;
begin
  if not Assigned(AJSONObject) then
    exit;

  APISST.vBc := AJSONObject.AsFloat['vBC'];
  APISST.pPis := AJSONObject.AsFloat['pPIS'];
  APISST.qBCProd := AJSONObject.AsFloat['qBCProd'];
  APISST.vAliqProd := AJSONObject.AsFloat['vAliqProd'];
  APISST.vPIS := AJSONObject.AsFloat['vPIS'];
  APISST.indSomaPISST := StrToindSomaPISST(ok, AJSONObject.AsString['indSomaPISST']);
end;

procedure TNFeJSONReader.LerDetImposto_COFINS(const AJSONObject: TACBrJSONObject; ACOFINS: TCOFINS);
var
  lCOFINSAligJSONObj, lCOFINSQtdeJSONObj, lCOFINSNTJSONObj, lCOFINSOutrJSONObj: TACBrJSONObject;
  Ok: Boolean;
begin
  if not Assigned(AJSONObject) then
    exit;

  lCOFINSAligJSONObj := AJSONObject.AsJSONObject['COFINSAliq'];
  if Assigned(lCOFINSAligJSONObj) then
  begin
    ACOFINS.CST := StrToCSTCOFINS(ok, lCOFINSAligJSONObj.AsString['CST']);
    ACOFINS.vBC := lCOFINSAligJSONObj.AsFloat['vBC'];
    ACOFINS.pCOFINS := lCOFINSAligJSONObj.AsFloat['pCOFINS'];
    ACOFINS.vCOFINS := lCOFINSAligJSONObj.AsFloat['vCOFINS'];
  end;

  lCOFINSQtdeJSONObj := AJSONObject.AsJSONObject['COFINSQtde'];
  if Assigned(lCOFINSQtdeJSONObj) then
  begin
    ACOFINS.CST := StrToCSTCOFINS(ok, lCOFINSQtdeJSONObj.AsString['CST']);
    ACOFINS.qBCProd := lCOFINSQtdeJSONObj.AsFloat['qBCProd'];
    ACOFINS.vAliqProd := lCOFINSQtdeJSONObj.AsFloat['vAliqProd'];
    ACOFINS.vCOFINS := lCOFINSQtdeJSONObj.AsFloat['vCOFINS'];
  end;

  lCOFINSNTJSONObj := AJSONObject.AsJSONObject['COFINSNT'];
  if Assigned(lCOFINSNTJSONObj) then
  begin
    ACOFINS.CST := StrToCSTCOFINS(ok, lCOFINSNTJSONObj.AsString['CST']);
  end;

  lCOFINSOutrJSONObj := AJSONObject.AsJSONObject['COFINSOutr'];
  if Assigned(lCOFINSOutrJSONObj) then
  begin
    ACOFINS.CST := StrToCSTCOFINS(ok, lCOFINSOutrJSONObj.AsString['CST']);
    ACOFINS.vBC := lCOFINSOutrJSONObj.AsFloat['vBC'];
    ACOFINS.pCOFINS := lCOFINSOutrJSONObj.AsFloat['pCOFINS'];
    ACOFINS.qBCProd := lCOFINSOutrJSONObj.AsFloat['qBCProd'];
    ACOFINS.vAliqProd := lCOFINSOutrJSONObj.AsFloat['vAliqProd'];
    ACOFINS.vCOFINS := lCOFINSOutrJSONObj.AsFloat['vCOFINS'];
  end;
end;

procedure TNFeJSONReader.LerDetImposto_COFINSST(const AJSONObject: TACBrJSONObject; ACOFINSST: TCOFINSST);
var
  OK: Boolean;
begin
  if not Assigned(AJSONObject) then
    exit;

  ACOFINSST.vBC := AJSONObject.AsFloat['vBC'];
  ACOFINSST.pCOFINS := AJSONObject.AsFloat['pCOFINS'];
  ACOFINSST.qBCProd := AJSONObject.AsFloat['qBCProd'];
  ACOFINSST.vAliqProd := AJSONObject.AsFloat['vAliqProd'];
  ACOFINSST.vCOFINS := AJSONObject.AsFloat['vCOFINS'];
  ACOFINSST.indSomaCOFINSST := StrToindSomaCOFINSST(Ok, AJSONObject.AsString['indSomaCOFINSST']);
end;

procedure TNFeJSONReader.LerDetImposto_ISSQN(const AJSONObject: TACBrJSONObject; AISSQN: TISSQN);
var
  OK: Boolean;
begin
  if not Assigned(AJSONObject) then
    exit;

  AISSQN.vBC := AJSONObject.AsFloat['vBC'];
  AISSQN.vAliq := AJSONObject.AsFloat['vAliq'];
  AISSQN.vISSQN := AJSONObject.AsFloat['vISSQN'];
  AISSQN.cMunFG := AJSONObject.AsInteger['cMunFG'];
  AISSQN.cListServ := AJSONObject.AsString['cListServ'];
  AISSQN.cSitTrib := StrToISSQNcSitTrib(ok, AJSONObject.AsString['cSitTrib']);
  AISSQN.vDeducao := AJSONObject.AsFloat['vDeducao'];
  AISSQN.vOutro := AJSONObject.AsFloat['vOutro'];
  AISSQN.vDescIncond := AJSONObject.AsFloat['vDescIncond'];
  AISSQN.vDescCond := AJSONObject.AsFloat['vDescCond'];
  AISSQN.vISSRet := AJSONObject.AsFloat['vISSRet'];
  AISSQN.indISS := StrToindISS(Ok, AJSONObject.AsString['indISS']);
  AISSQN.cServico := AJSONObject.AsString['cServico'];
  AISSQN.cMun := AJSONObject.AsInteger['cMun'];
  AISSQN.cPais := AJSONObject.AsInteger['cPais'];
  AISSQN.nProcesso := AJSONObject.AsString['nProcesso'];
  AISSQN.indIncentivo := StrToindIncentivo(Ok, AJSONObject.AsString['indIncentivo']);
end;

procedure TNFeJSONReader.LerDetObs(const AJSONObject: TACBrJSONObject; AObs: TobsItem);
begin
  if not Assigned(AJSONObject) then
    exit;

  AObs.xCampo := AJSONObject.AsString['xCampo'];
  AObs.xTexto := AJSONObject.AsString['xTexto'];
end;

procedure TNFeJSONReader.LerTotal(const AJSONObject: TACBrJSONObject; ATotal: TTotal);
begin
  if not Assigned(AJSONObject) then
    Exit;

  LerTotal_ICMSTot(AJSONObject.AsJSONObject['ICMSTot'], ATotal.ICMSTot);
  LerTotal_ISSQNTot(AJSONObject.AsJSONObject['ISSQNtot'], ATotal.ISSQNtot);
  LerTotal_retTrib(AJSONObject.AsJSONObject['retTrib'], ATotal.retTrib);

  // Reforma Tributria
  Ler_ISTot(AJSONObject.AsJSONObject['ISTot'], ATotal.ISTot);
  Ler_IBSCBSTot(AJSONObject.AsJSONObject['IBSCBSTot'], ATotal.IBSCBSTot);

  ATotal.vNFTot := AJSONObject.AsFloat['vNFTot'];
end;

procedure TNFeJSONReader.LerTransp(const AJSONObject: TACBrJSONObject; ATransp: TTransp);
var
  ok: Boolean;
begin
  if not Assigned(AJSONObject) then
    Exit;

  ATransp.modFrete := StrToModFrete(ok, AJSONObject.AsString['modFrete']);
  ATransp.vagao   := AJSONObject.AsString['vagao'];
  ATransp.balsa   := AJSONObject.AsString['balsa'];

  LerTransp_Transporta(AJSONObject.AsJSONObject['transporta'], ATransp.Transporta);
  LerTransp_retTransp(AJSONObject.AsJSONObject['retTransp'], ATransp.retTransp);
  LerTransp_veicTransp(AJSONObject.AsJSONObject['veicTransp'], ATransp.veicTransp);
  LerTransp_reboque(AJSONObject.AsJSONArray['reboque'], ATransp.Reboque);
  LerTransp_Vol(AJSONObject.AsJSONArray['vol'], ATransp.Vol);
end;

procedure TNFeJSONReader.LerTransp_Transporta(const AJSONObject: TACBrJSONObject; ATransporta: TTransporta);
begin
  if not Assigned(AJSONObject) then
    exit;

  if AJSONObject.ValueExists('CNPJ') then
    ATransporta.CNPJCPF := AJSONObject.AsString['CNPJ']
  else if AJSONObject.ValueExists('CPF') then
    ATransporta.CNPJCPF := AJSONObject.AsString['CPF'];

  ATransporta.xNome   := AJSONObject.AsString['xNome'];
  ATransporta.IE      := AJSONObject.AsString['IE'];
  ATransporta.xEnder  := AJSONObject.AsString['xEnder'];
  ATransporta.xMun    := AJSONObject.AsString['xMun'];
  ATransporta.UF      := AJSONObject.AsString['UF'];
end;

procedure TNFeJSONReader.LerTransp_retTransp(const AJSONObject: TACBrJSONObject; ARetTransp: TretTransp);
begin
  if not Assigned(AJSONObject) then
    exit;

  ARetTransp.vServ    := AJSONObject.AsFloat['vServ'];
  ARetTransp.vBCRet   := AJSONObject.AsFloat['vBCRet'];
  ARetTransp.pICMSRet := AJSONObject.AsFloat['pICMSRet'];
  ARetTransp.vICMSRet := AJSONObject.AsFloat['vICMSRet'];
  ARetTransp.CFOP     := AJSONObject.AsString['CFOP'];
  ARetTransp.cMunFG   := AJSONObject.AsInteger['cMunFG'];
end;

procedure TNFeJSONReader.LerTransp_veicTransp(const AJSONObject: TACBrJSONObject; AVeicTransp: TveicTransp);
begin
  if not Assigned(AJSONObject) then
    exit;

  AVeicTransp.placa := AJSONObject.AsString['placa'];
  AVeicTransp.UF    := AJSONObject.AsString['UF'];
  AVeicTransp.RNTC  := AJSONObject.AsString['RNTC'];
end;

procedure TNFeJSONReader.LerTransp_reboque(const AJSONArray: TACBrJSONArray; AReboque: TReboqueCollection);
var
  i: Integer;
  lReboqueJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    exit;

  AReboque.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lReboqueJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lReboqueJSONObj) then
      continue;

    AReboque.New;
    AReboque[i].placa := lReboqueJSONObj.AsString['placa'];
    AReboque[i].UF    := lReboqueJSONObj.AsString['UF'];
    AReboque[i].RNTC  := lReboqueJSONObj.AsString['RNTC'];
  end;
end;

procedure TNFeJSONReader.LerTransp_Vol(const AJSONArray: TACBrJSONArray; AVol: TVolCollection);
var
  i: Integer;
  lVolJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    Exit;

  AVol.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lVolJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lVolJSONObj) then
      continue;

    AVol.New;
    AVol[i].qVol  := lVolJSONObj.AsInteger['qVol'];
    AVol[i].esp   := lVolJSONObj.AsString['esp'];
    AVol[i].marca := lVolJSONObj.AsString['marca'];
    AVol[i].nVol  := lVolJSONObj.AsString['nVol'];
    AVol[i].pesoL := lVolJSONObj.AsFloat['pesoL'];
    AVol[i].pesoB := lVolJSONObj.AsFloat['pesoB'];

    LerTransp_VolLacres(lVolJSONObj.AsJSONArray['lacres'], AVol[i].Lacres);
  end;
end;

procedure TNFeJSONReader.LerTransp_VolLacres(const AJSONArray: TACBrJSONArray; ALacres: TLacresCollection);
var
  lLacreJSONObj: TACBrJSONObject;
  i: Integer;
begin
  if not Assigned(AJSONArray) then
    Exit;

  ALacres.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lLacreJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lLacreJSONObj) then
      continue;

    ALacres.New;
    ALacres[i].nLacre := lLacreJSONObj.AsString['nLacre'];
  end;
end;

procedure TNFeJSONReader.LerCobr(const AJSONObject: TACBrJSONObject; ACobr: TCobr);
begin
  if not Assigned(AJSONObject) then
    Exit;

  LerCobr_fat(AJSONObject.AsJSONObject['fat'], ACobr.Fat);
  LerCobr_dup(AJSONObject.AsJSONArray['dup'], ACobr.Dup);
end;

procedure TNFeJSONReader.LerCobr_fat(const AJSONObject: TACBrJSONObject; AFat: TFat);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AFat.nFat  := AJSONObject.AsString['nFat'];
  AFat.vOrig := AJSONObject.AsFloat['vOrig'];
  AFat.vDesc := AJSONObject.AsFloat['vDesc'];
  AFat.vLiq  := AJSONObject.AsFloat['vLiq'];
end;

procedure TNFeJSONReader.LerCobr_dup(const AJSONArray: TACBrJSONArray; ADup: TDupCollection);
var
  i: Integer;
  lDupJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    exit;

  ADup.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lDupJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lDupJSONObj) then
      continue;

    ADup.New;
    ADup[i].nDup  := lDupJSONObj.AsString['nDup'];
    ADup[i].dVenc := lDupJSONObj.AsISODate['dVenc'];
    ADup[i].vDup  := lDupJSONObj.AsFloat['vDup'];
  end;
end;

procedure TNFeJSONReader.LerPag(const AJSONObject: TACBrJSONObject; APag: TpagCollection);
var
  i: Integer;
  lDetPagJSONArray: TACBrJSONArray;
  lDetPagJSONObj, lCardJSONObj: TACBrJSONObject;
  Ok: Boolean;
begin
  if not Assigned(AJSONObject) then
    Exit;

  APag.Clear;
  lDetPagJSONArray := AJSONObject.AsJSONArray['detPag'];
  if Assigned(lDetPagJSONArray) then
  begin
    for i := 0 to lDetPagJSONArray.Count - 1 do
    begin
      lDetPagJSONObj := lDetPagJSONArray.ItemAsJSONObject[i];
      if not Assigned(lDetPagJSONObj) then
        continue;

      APag.New;
      APag[i].indPag := StrToIndpagEX(lDetPagJSONObj.AsString['indPag']);
      APag[i].tPag := StrToFormaPagamento(Ok, lDetPagJSONObj.AsString['tPag']);
      APag[i].xPag := lDetPagJSONObj.AsString['xPag'];
      APag[i].vPag := lDetPagJSONObj.AsFloat['vPag'];
      APag[i].dPag := lDetPagJSONObj.AsISODateTime['dPag'];
      APag[i].CNPJPag := lDetPagJSONObj.AsString['CNPJPag'];
      APag[i].UFPag := lDetPagJSONObj.AsString['UFPag'];

      lCardJSONObj := lDetPagJSONObj.AsJSONObject['card'];
      if Assigned(lCardJSONObj) then
      begin
        APag[i].tpIntegra := StrTotpIntegra(Ok, lCardJSONObj.AsString['tpIntegra']);
        APag[i].CNPJ := lCardJSONObj.AsString['CNPJ'];
        APag[i].tBand := StrToBandeiraCartao(Ok, lCardJSONObj.AsString['tBand']);
        APag[i].cAut := lCardJSONObj.AsString['cAut'];
        APag[i].CNPJReceb := lCardJSONObj.AsString['CNPJReceb'];
        APag[i].idTermPag := lCardJSONObj.AsString['idTermPag'];
      end;
    end;
  end;
end;

procedure TNFeJSONReader.LerInfIntermed(const AJSONObject: TACBrJSONObject; AInfIntermed: TinfIntermed);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AInfIntermed.CNPJ         := AJSONObject.AsString['CNPJ'];
  AInfIntermed.idCadIntTran := AJSONObject.AsString['idCadIntTran'];
end;

procedure TNFeJSONReader.LerInfAdic(const AJSONObject: TACBrJSONObject; AInfAdic: TInfAdic);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AInfAdic.infAdFisco := AJSONObject.AsString['infAdFisco'];
  AInfAdic.infCpl     := AJSONObject.AsString['infCpl'];
  LerInfAdic_obsCont(AJSONObject.AsJSONArray['obsCont'], AInfAdic.obsCont);
  LerInfAdic_obsFisco(AJSONObject.AsJSONArray['obsFisco'], AInfAdic.obsFisco);
  LerInfAdic_procRef(AJSONObject.AsJSONArray['procRef'], AInfAdic.procRef);
end;

procedure TNFeJSONReader.LerInfAdic_obsCont(const AJSONArray: TACBrJSONArray; AObsCont: TobsContCollection);
var
  i: Integer;
  lObsContJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    exit;

  for i := 0 to AJSONArray.Count - 1 do
  begin
    lObsContJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lObsContJSONObj) then
      continue;

    AObsCont.New;
    AObsCont[i].xCampo := lObsContJSONObj.AsString['xCampo'];
    AObsCont[i].xTexto := lObsContJSONObj.AsString['xTexto'];
  end;
end;

procedure TNFeJSONReader.LerInfAdic_obsFisco(const AJSONArray: TACBrJSONArray; AObsFisco: TobsFiscoCollection);
var
  i: Integer;
  lObsFiscoJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    exit;

  for i := 0 to AJSONArray.Count - 1 do
  begin
    lObsFiscoJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lObsFiscoJSONObj) then
      continue;

    AObsFisco.New;
    AObsFisco[i].xCampo := lObsFiscoJSONObj.AsString['xCampo'];
    AObsFisco[i].xTexto := lObsFiscoJSONObj.AsString['xTexto'];
  end;
end;

procedure TNFeJSONReader.LerInfAdic_procRef(const AJSONArray: TACBrJSONArray; AProcRef: TprocRefCollection);
var
  i: Integer;
  lProcRefJSONObj: TACBrJSONObject;
  Ok: Boolean;
begin
  if not Assigned(AJSONArray) then
    exit;

  AProcRef.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lProcRefJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lProcRefJSONObj) then
      continue;

    AProcRef.New;
    AProcRef[i].nProc := lProcRefJSONObj.AsString['nProc'];
    AProcRef[i].indProc := StrToIndProc(ok, lProcRefJSONObj.AsString['indProc']);
    AProcRef[i].tpAto := StrTotpAto(ok, lProcRefJSONObj.AsString['tpAto']);
  end;
end;

procedure TNFeJSONReader.LerExporta(const AJSONObject: TACBrJSONObject; AExporta: TExporta);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AExporta.UFembarq   := AJSONObject.AsString['UFEmbarq'];
  AExporta.xLocEmbarq := AJSONObject.AsString['xLocEmbarq'];

  //// Versao 3.10
  //FNFe.exporta.UFSaidaPais  := AJSONObject.AsString['UFSaidaPais'];
  //FNFe.exporta.xLocExporta  := AJSONObject.AsString['xLocExporta'];
  //FNFe.exporta.xLocDespacho := AJSONObject.AsString['xLocDespacho'];
end;

procedure TNFeJSONReader.LerCompra(const AJSONObject: TACBrJSONObject; ACompra: TCompra);
begin
  if not Assigned(AJSONObject) then
    Exit;

  ACompra.xNEmp := AJSONObject.AsString['xNEmp'];
  ACompra.xPed  := AJSONObject.AsString['xPed'];
  ACompra.xCont := AJSONObject.AsString['xCont'];
end;

procedure TNFeJSONReader.LerCana(const AJSONObject: TACBrJSONObject; ACana: Tcana);
begin
  if not Assigned(AJSONObject) then
    Exit;

  ACana.safra   := AJSONObject.AsString['safra'];
  ACana.ref     := AJSONObject.AsString['ref'];
  ACana.qTotMes := AJSONObject.AsFloat['qTotMes'];
  ACana.qTotAnt := AJSONObject.AsFloat['qTotAnt'];
  ACana.qTotGer := AJSONObject.AsFloat['qTotGer'];
  ACana.vFor    := AJSONObject.AsFloat['vFor'];
  ACana.vTotDed := AJSONObject.AsFloat['vTotDed'];
  ACana.vLiqFor := AJSONObject.AsFloat['vLiqFor'];

  LerCana_fordia(AJSONObject.AsJSONArray['forDia'], ACana.fordia);
  LerCana_deduc(AJSONObject.AsJSONArray['deduc'], ACana.deduc);
end;

procedure TNFeJSONReader.LerCana_fordia(const AJSONArray: TACBrJSONArray; AForDia: TForDiaCollection);
var
  i: Integer;
  lForDiaJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    exit;

  AForDia.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lForDiaJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lForDiaJSONObj) then
      continue;

    AForDia.New;
    AFordia[i].dia  := lForDiaJSONObj.AsInteger['dia'];
    AFordia[i].qtde := lForDiaJSONObj.AsFloat['qtde'];
  end;
end;

procedure TNFeJSONReader.LerCana_deduc(const AJSONArray: TACBrJSONArray; ADeduc: TDeducCollection);
var
  i: Integer;
  lDeducJSONObj: TACBrJSONObject;
begin
  if not Assigned(AJSONArray) then
    exit;

  ADeduc.Clear;
  for i := 0 to AJSONArray.Count - 1 do
  begin
    lDeducJSONObj := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lDeducJSONObj) then
      continue;

    ADeduc.New;
    ADeduc[i].xDed  := lDeducJSONObj.AsString['xDed'];
    ADeduc[i].vDed := lDeducJSONObj.AsFloat['vDed'];
  end;
end;

procedure TNFeJSONReader.LerInfRespTec(const AJSONObject: TACBrJSONObject; AInfRespTec: TinfRespTec);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AInfRespTec.CNPJ     := AJSONObject.AsString['CNPJ'];
  AInfRespTec.xContato := AJSONObject.AsString['xContato'];
  AInfRespTec.email    := AJSONObject.AsString['email'];
  AInfRespTec.fone     := AJSONObject.AsString['fone'];
  AInfRespTec.idCSRT   := AJSONObject.AsInteger['idCSRT'];
  AInfRespTec.hashCSRT := AJSONObject.AsString['hashCSRT'];
end;

procedure TNFeJSONReader.LerInfNFeSupl(const AJSONObject: TACBrJSONObject; AInfNFeSupl: TinfNFeSupl);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AInfNFeSupl.qrCode := AJSONObject.AsString['qrCode'];
  AInfNFeSupl.urlChave := AJSONObject.AsString['urlChave'];
end;

procedure TNFeJSONReader.LerAgropecuario(const AJSONObject: TACBrJSONObject; AAgropecuario: Tagropecuario);
begin
  if not Assigned(AJSONObject) then
    Exit;

  Ler_defensivo(AJSONObject.AsJSONArray['defensivo'], AAgropecuario.defensivo);
  Ler_guiaTransito(AJSONObject.AsJSONObject['guiaTransito'], AAgropecuario.guiaTransito);
end;

procedure TNFeJSONReader.Ler_defensivo(const AJSONArray: TACBrJSONArray; ADefensivo: TdefensivoCollection);
var
  lDefensivoJSON: TACBrJSONObject;
  i: Integer;
begin
  if not Assigned(AJSONArray) then
    Exit;

  for i := 0 to AJSONArray.Count - 1 do
  begin
    lDefensivoJSON := AJSONArray.ItemAsJSONObject[i];
    if not Assigned(lDefensivoJSON) then
      Continue;

    ADefensivo.New;
    ADefensivo[i].nReceituario := lDefensivoJSON.AsString['nReceituario'];
    ADefensivo[i].CPFRespTec := lDefensivoJSON.AsString['CPFRespTec'];
  end;
end;

procedure TNFeJSONReader.Ler_guiaTransito(const AJSONObject: TACBrJSONObject; AGuiaTransito: TguiaTransito);
begin
  if not Assigned(AJSONObject) then
     exit;

  AGuiaTransito.UFGuia := AJSONObject.AsString['UFGuia'];
  AGuiaTransito.tpGuia := StrToTtpGuia(AJSONObject.AsString['tpGuia']);
  AGuiaTransito.serieGuia := AJSONObject.AsString['serieGuia'];
  AGuiaTransito.nGuia := AJSONObject.AsString['nGuia'];
end;

procedure TNFeJSONReader.Ler_gCompraGov(const AJSONObject: TACBrJSONObject; AgCompraGov: TgCompraGov);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AgCompraGov.tpEnteGov := StrTotpEnteGov(AJSONObject.AsString['tpEnteGov']);
  AgCompraGov.pRedutor := AJSONObject.AsFloat['pRedutor'];
  AgCompraGov.tpOperGov := StrTotpOperGov(AJSONObject.AsString['tpOperGov']);
end;

procedure TNFeJSONReader.Ler_ISel(const AJSONObject: TACBrJSONObject; AISel: TgIS);
begin
  if not Assigned(AJSONObject) then
    Exit;

  //Usar string até a publicação de uma tabela de CSTs oficial para o IS
  //AISel.CSTIS := StrToCSTIS(AJSONObject.AsString['CSTIS']);
  AISel.CSTIS := AJSONObject.AsString['CSTIS'];
  AISel.cClassTribIS := AJSONObject.AsString['cClassTribIS'];
  AISel.vBCIS := AJSONObject.AsFloat['vBCIS'];
  AISel.pIS := AJSONObject.AsFloat['pIS'];
  AISel.pISEspec := AJSONObject.AsFloat['pISEspec'];
  AISel.uTrib := AJSONObject.AsString['uTrib'];
  AISel.qTrib := AJSONObject.AsFloat['qTrib'];
  AISel.vIS := AJSONObject.AsFloat['vIS'];
end;

procedure TNFeJSONReader.Ler_IBSCBS(const AJSONObject: TACBrJSONObject; AIBSCBS: TIBSCBS);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AIBSCBS.CST := StrToCSTIBSCBS(AJSONObject.AsString['CST']);
  AIBSCBS.cClassTrib := AJSONObject.AsString['cClassTrib'];

  Ler_IBSCBS_gIBSCBS(AJSONObject.AsJSONObject['gIBSCBS'], AIBSCBS.gIBSCBS);
  Ler_IBSCBS_gIBSCBSMono(AJSONObject.AsJSONObject['gIBSCBSMono'], AIBSCBS.gIBSCBSMono);
  Ler_IBSCBS_gTransfCred(AJSONObject.AsJSONObject['gTransfCred'], AIBSCBS.gTransfCred);
  Ler_IBSCBS_gCredPresIBSZFM(AJSONObject.AsJSONObject['gCredPresIBSZFM'], AIBSCBS.gCredPresIBSZFM);
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBS(const AJSONObject: TACBrJSONObject; AGIBSCBS: TgIBSCBS);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGIBSCBS.vBC  := AJSONObject.AsFloat['vBC'];
  AGIBSCBS.vIBS := AJSONObject.AsFloat['vIBS'];

  Ler_IBSCBS_gIBSCBS_gIBSUF(AJSONObject.AsJSONObject['gIBSUF'], AGIBSCBS.gIBSUF);
  Ler_IBSCBS_gIBSCBS_gIBSMun(AJSONObject.AsJSONObject['gIBSMun'], AGIBSCBS.gIBSMun);
  Ler_IBSCBS_gIBSCBS_gCBS(AJSONObject.AsJSONObject['gCBS'], AGIBSCBS.gCBS);
  Ler_IBSCBS_gIBSCBS_gTribRegular(AJSONObject.AsJSONObject['gTribRegular'], AGIBSCBS.gTribRegular);
//  Ler_IBSCBS_gIBSCBS_gIBSCBSCredPres(AJSONObject.AsJSONObject['gIBSCredPres'], AGIBSCBS.gIBSCredPres);
//  Ler_IBSCBS_gIBSCBS_gIBSCBSCredPres(AJSONObject.AsJSONObject['gCBSCredPres'], AGIBSCBS.gCBSCredPres);
  Ler_IBSCBS_gIBSCBS_gTribCompraGov(AJSONObject.AsJSONObject['gTribCompraGov'], AGIBSCBS.gTribCompraGov);
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBSMono(const AJSONObject: TACBrJSONObject; AIBSCBSMono: TgIBSCBSMono);
begin
  if not Assigned(AJSONObject) then
    Exit;

  Ler_IBSCBS_gIBSCBSMono_gMonoPadrao(AJSONObject.AsJSONObject['gMonoPadrao'], AIBSCBSMono.gMonoPadrao);
  Ler_IBSCBS_gIBSCBSMono_gMonoReten(AJSONObject.AsJSONObject['gMonoReten'], AIBSCBSMono.gMonoReten);
  Ler_IBSCBS_gIBSCBSMono_gMonoRet(AJSONObject.AsJSONObject['gMonoRet'], AIBSCBSMono.gMonoRet);
  Ler_IBSCBS_gIBSCBSMono_gMonoDif(AJSONObject.AsJSONObject['gMonoDif'], AIBSCBSMono.gMonoDif);

  AIBSCBSMono.vTotIBSMonoItem := AJSONObject.AsFloat['vTotIBSMonoItem'];
  AIBSCBSMono.vTotCBSMonoItem := AJSONObject.AsFloat['vTotCBSMonoItem'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gTransfCred(const AJSONObject: TACBrJSONObject; AGTransfCred: TgTransfCred);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGTransfCred.vIBS := AJSONObject.AsFloat['vIBS'];
  AGTransfCred.vCBS := AJSONObject.AsFloat['vCBS'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gCredPresIBSZFM(const AJSONObject: TACBrJSONObject; AGCredPresIBSZFM: TCredPresIBSZFM);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGCredPresIBSZFM.tpCredPresIBSZFM := StrToTpCredPresIBSZFM(AJSONObject.AsString['tpCredPresIBSZFM']);
  AGCredPresIBSZFM.vCredPresIBSZFM := AJSONObject.AsFloat['vCredPresIBSZFM'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBS_gIBSUF(const AJSONObject: TACBrJSONObject; AIBSUF: TgIBSUF);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AIBSUF.pIBSUF := AJSONObject.AsFloat['pIBSUF'];

  Ler_IBSCBS_gIBSCBS__gDif(AJSONObject.AsJSONObject['gDif'], AIBSUF.gDif);
  Ler_IBSCBS_gIBSCBS_gIBSCBSUFMun_gDevTrib(AJSONObject.AsJSONObject['gDevTrib'], AIBSUF.gDevTrib);
  Ler_IBSCBS_gIBSCBS_gIBSCBSUFMun_gRed(AJSONObject.AsJSONObject['gRed'], AIBSUF.gRed);

  AIBSUF.vIBSUF := AJSONObject.AsFloat['vIBSUF'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBS__gDif(const AJSONObject: TACBrJSONObject; AGDif: TgDif);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGDif.pDif := AJSONObject.AsFloat['pDif'];
  AGDif.vDif := AJSONObject.AsFloat['vDif'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBSMono_gMonoDif(const AJSONObject: TACBrJSONObject; AGMonoDif: TgMonoDif);
begin
  if not Assigned(AJSONObject) then
    exit;

  AGMonoDif.pDifIBS := AJSONObject.AsFloat['pDifIBS'];
  AGMonoDif.vIBSMonoDif := AJSONObject.AsFloat['vIBSMonoDif'];
  AGMonoDif.pDifCBS := AJSONObject.AsFloat['pDifCBS'];
  AGMonoDif.vCBSMonoDif := AJSONObject.AsFloat['vCBSMonoDif'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBSMono_gMonoPadrao(const AJSONObject: TACBrJSONObject; AGMonoPadrao: TgMonoPadrao);
begin
  if not Assigned(AJSONObject) then
    exit;

  AGMonoPadrao.qBCMono  := AJSONObject.AsFloat['qBCMono'];
  AGMonoPadrao.adRemIBS := AJSONObject.AsFloat['adRemIBS'];
  AGMonoPadrao.adRemCBS := AJSONObject.AsFloat['adRemCBS'];
  AGMonoPadrao.vIBSMono := AJSONObject.AsFloat['vIBSMono'];
  AGMonoPadrao.vCBSMono := AJSONObject.AsFloat['vCBSMono'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBSMono_gMonoRet(const AJSONObject: TACBrJSONObject; AGMonoRet: TgMonoRet);
begin
  if not Assigned(AJSONObject) then
    exit;

  AGMonoRet.qBCMonoRet := AJSONObject.AsFloat['qBCMonoRet'];
  AGMonoRet.adRemIBSRet := AJSONObject.AsFloat['adRemIBSRet'];
  AGMonoRet.vIBSMonoRet := AJSONObject.AsFloat['vIBSMonoRet'];
  AGMonoRet.adRemCBSRet := AJSONObject.AsFloat['adRemCBSRet'];
  AGMonoRet.vCBSMonoRet := AJSONObject.AsFloat['vCBSMonoRet'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBSMono_gMonoReten(const AJSONObject: TACBrJSONObject; AGMonoReten: TgMonoReten);
begin
  if not Assigned(AJSONObject) then
    exit;

  AGMonoReten.qBCMonoReten := AJSONObject.AsFloat['qBCMonoReten'];
  AGMonoReten.adRemIBSReten := AJSONObject.AsFloat['adRemIBSReten'];
  AGMonoReten.vIBSMonoReten := AJSONObject.AsFloat['vIBSMonoReten'];
  AGMonoReten.adRemCBSReten := AJSONObject.AsFloat['adRemCBSReten'];
  AGMonoReten.vCBSMonoReten := AJSONObject.AsFloat['vCBSMonoReten'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBS_gIBSCBSUFMun_gDevTrib(const AJSONObject: TACBrJSONObject; AGDevTrib: TgDevTrib);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGDevTrib.vDevTrib := AJSONObject.AsFloat['vDevTrib'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBS_gIBSCBSUFMun_gRed(const AJSONObject: TACBrJSONObject; AGRed: TgRed);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGRed.pRedAliq := AJSONObject.AsFloat['pRedAliq'];
  AGRed.pAliqEfet := AJSONObject.AsFloat['pAliqEfet'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBS_gIBSMun(const AJSONObject: TACBrJSONObject; AIBSMun: TgIBSMun);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AIBSMun.pIBSMun := AJSONObject.AsFloat['pIBSMun'];

  Ler_IBSCBS_gIBSCBS__gDif(AJSONObject.AsJSONObject['gDif'], AIBSMun.gDif);
  Ler_IBSCBS_gIBSCBS_gIBSCBSUFMun_gDevTrib(AJSONObject.AsJSONObject['gDevTrib'], AIBSMun.gDevTrib);
  Ler_IBSCBS_gIBSCBS_gIBSCBSUFMun_gRed(AJSONObject.AsJSONObject['gRed'], AIBSMun.gRed);

  AIBSMun.vIBSMun := AJSONObject.AsFloat['vIBSMun'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBS_gCBS(const AJSONObject: TACBrJSONObject; AGCBS: TgCBS);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGCBS.pCBS := AJSONObject.AsFloat['pCBS'];

  Ler_IBSCBS_gIBSCBS__gDif(AJSONObject.AsJSONObject['gDif'], AGCBS.gDif);
  Ler_IBSCBS_gIBSCBS_gIBSCBSUFMun_gDevTrib(AJSONObject.AsJSONObject['gDevTrib'], AGCBS.gDevTrib);
  Ler_IBSCBS_gIBSCBS_gIBSCBSUFMun_gRed(AJSONObject.AsJSONObject['gRed'], AGCBS.gRed);

  AGCBS.vCBS := AJSONObject.AsFloat['vCBS'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBS_gTribRegular(const AJSONObject: TACBrJSONObject; AGTribRegular: TgTribRegular);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGTribRegular.CSTReg := StrToCSTIBSCBS(AJSONObject.AsString['CSTReg']);
  AGTribRegular.cClassTribReg := AJSONObject.AsString['cClassTribReg'];
  AGTribRegular.pAliqEfetRegIBSUF := AJSONObject.AsFloat['pAliqEfetRegIBSUF'];
  AGTribRegular.vTribRegIBSUF := AJSONObject.AsFloat['vTribRegIBSUF'];
  AGTribRegular.pAliqEfetRegIBSMun := AJSONObject.AsFloat['pAliqEfetRegIBSMun'];
  AGTribRegular.vTribRegIBSMun := AJSONObject.AsFloat['vTribRegIBSMun'];
  AGTribRegular.pAliqEfetRegCBS := AJSONObject.AsFloat['pAliqEfetRegCBS'];
  AGTribRegular.vTribRegCBS := AJSONObject.AsFloat['vTribRegCBS'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBS_gIBSCBSCredPres(const AJSONObject: TACBrJSONObject; AGIBSCredPres: TgIBSCBSCredPres);
begin
  if not Assigned(AJSONObject) then
    Exit;

//  AGIBSCredPres.cCredPres := StrTocCredPres(AJSONObject.AsString['cCredPres']);
  AGIBSCredPres.pCredPres := AJSONObject.AsFloat['pCredPres'];
  AGIBSCredPres.vCredPres := AJSONObject.AsFloat['vCredPres'];
  AGIBSCredPres.vCredPresCondSus := AJSONObject.AsFloat['vCredPresCondSus'];
end;

procedure TNFeJSONReader.Ler_IBSCBS_gIBSCBS_gTribCompraGov(const AJSONObject: TACBrJSONObject; AGTribCompraGov: TgTribCompraGov);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGTribCompraGov.pAliqIBSUF := AJSONObject.AsFloat['pAliqIBSUF'];
  AGTribCompraGov.vTribIBSUF := AJSONObject.AsFloat['vTribIBSUF'];
  AGTribCompraGov.pAliqIBSMun := AJSONObject.AsFloat['pAliqIBSMun'];
  AGTribCompraGov.vTribIBSMun := AJSONObject.AsFloat['vTribIBSMun'];
  AGTribCompraGov.pAliqCBS := AJSONObject.AsFloat['pAliqCBS'];
  AGTribCompraGov.vTribCBS := AJSONObject.AsFloat['vTribCBS'];
end;

procedure TNFeJSONReader.Ler_Det_DFeReferenciado(const AJSONObject: TACBrJSONObject; ADFeReferenciado: TDFeReferenciado);
begin
  if not Assigned(AJSONObject) then
    Exit;

  ADFeReferenciado.chaveAcesso := AJSONObject.AsString['chaveAcesso'];
  ADFeReferenciado.nItem := AJSONObject.AsInteger['nItem'];
end;

procedure TNFeJSONReader.LerTotal_ICMSTot(const AJSONObject: TACBrJSONObject; AICMSTot: TICMSTot);
begin
  if not Assigned(AJSONObject) then
    exit;

  AICMSTot.vBC           := AJSONObject.AsFloat['vBC'];
  AICMSTot.vICMS         := AJSONObject.AsFloat['vICMS'];
  AICMSTot.vICMSDeson    := AJSONObject.AsFloat['vICMSDeson'];
  AICMSTot.vFCPUFDest    := AJSONObject.AsFloat['vFCPUFDest'];
  AICMSTot.vICMSUFDest   := AJSONObject.AsFloat['vICMSUFDest'];
  AICMSTot.vICMSUFRemet  := AJSONObject.AsFloat['vICMSUFRemet'];
  AICMSTot.vFCP          := AJSONObject.AsFloat['vFCP'];
  AICMSTot.vBCST         := AJSONObject.AsFloat['vBCST'];
  AICMSTot.vST           := AJSONObject.AsFloat['vST'];
  AICMSTot.vFCPST        := AJSONObject.AsFloat['vFCPST'];
  AICMSTot.vFCPSTRet     := AJSONObject.AsFloat['vFCPSTRet'];
  AICMSTot.qBCMono       := AJSONObject.AsFloat['qBCMono'];
  AICMSTot.vICMSMono     := AJSONObject.AsFloat['vICMSMono'];
  AICMSTot.qBCMonoReten  := AJSONObject.AsFloat['qBCMonoReten'];
  AICMSTot.vICMSMonoReten:= AJSONObject.AsFloat['vICMSMonoReten'];
  AICMSTot.qBCMonoRet    := AJSONObject.AsFloat['qBCMonoRet'];
  AICMSTot.vICMSMonoRet  := AJSONObject.AsFloat['vICMSMonoRet'];
  AICMSTot.vProd         := AJSONObject.AsFloat['vProd'];
  AICMSTot.vFrete        := AJSONObject.AsFloat['vFrete'];
  AICMSTot.vSeg          := AJSONObject.AsFloat['vSeg'];
  AICMSTot.vDesc         := AJSONObject.AsFloat['vDesc'];
  AICMSTot.vII           := AJSONObject.AsFloat['vII'];
  AICMSTot.vIPI          := AJSONObject.AsFloat['vIPI'];
  AICMSTot.vIPIDevol     := AJSONObject.AsFloat['vIPIDevol'];
  AICMSTot.vPIS          := AJSONObject.AsFloat['vPIS'];
  AICMSTot.vCOFINS       := AJSONObject.AsFloat['vCOFINS'];
  AICMSTot.vOutro        := AJSONObject.AsFloat['vOutro'];
  AICMSTot.vNF           := AJSONObject.AsFloat['vNF'];
  AICMSTot.vTotTrib      := AJSONObject.AsFloat['vTotTrib'];
end;

procedure TNFeJSONReader.LerTotal_ISSQNTot(const AJSONObject: TACBrJSONObject; AISSQNTot: TISSQNtot);
var
  OK: Boolean;
begin
  if not Assigned(AJSONObject) then
    exit;

  AISSQNtot.vServ   := AJSONObject.AsFloat['vServ'];
  AISSQNtot.vBC     := AJSONObject.AsFloat['vBC'];
  AISSQNtot.vISS    := AJSONObject.AsFloat['vISS'];
  AISSQNtot.vPIS    := AJSONObject.AsFloat['vPIS'];
  AISSQNtot.vCOFINS := AJSONObject.AsFloat['vCOFINS'];
  AISSQNtot.dCompet     := AJSONObject.AsISODate['dCompet'];
  AISSQNtot.vDeducao    := AJSONObject.AsFloat['vDeducao'];
  AISSQNtot.vOutro      := AJSONObject.AsFloat['vOutro'];
  AISSQNtot.vDescIncond := AJSONObject.AsFloat['vDescIncond'];
  AISSQNtot.vDescCond   := AJSONObject.AsFloat['vDescCond'];
  AISSQNtot.vISSRet     := AJSONObject.AsFloat['vISSRet'];
  AISSQNtot.cRegTrib    := StrToRegTribISSQN(Ok, AJSONObject.AsString['cRegTrib']);
end;

procedure TNFeJSONReader.LerTotal_retTrib(const AJSONObject: TACBrJSONObject; ARetTrib: TretTrib);
begin
  if not Assigned(AJSONObject) then
    exit;

  ARetTrib.vRetPIS    := AJSONObject.AsFloat['vRetPIS'];
  ARetTrib.vRetCOFINS := AJSONObject.AsFloat['vRetCOFINS'];
  ARetTrib.vRetCSLL   := AJSONObject.AsFloat['vRetCSLL'];
  ARetTrib.vBCIRRF    := AJSONObject.AsFloat['vBCIRRF'];
  ARetTrib.vIRRF      := AJSONObject.AsFloat['vIRRF'];
  ARetTrib.vBCRetPrev := AJSONObject.AsFloat['vBCRetPrev'];
  ARetTrib.vRetPrev   := AJSONObject.AsFloat['vRetPrev'];
end;

procedure TNFeJSONReader.Ler_ISTot(const AJSONObject: TACBrJSONObject; AISTot: TISTot);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AISTot.vIS := AJSONObject.AsFloat['vIS'];
end;

procedure TNFeJSONReader.Ler_IBSCBSTot(const AJSONObject: TACBrJSONObject; AIBSCBSTot: TIBSCBSTot);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AIBSCBSTot.vBCIBSCBS := AJSONObject.AsFloat['vBCIBSCBS'];
  Ler_IBSCBSTot_gIBS(AJSONObject.AsJSONObject['gIBS'], AIBSCBSTot.gIBS);
  Ler_IBSCBSTot_gCBS(AJSONObject.AsJSONObject['gCBS'], AIBSCBSTot.gCBS);
  Ler_IBSCBSTot_gMono(AJSONObject.AsJSONObject['gMono'], AIBSCBSTot.gMono);
end;

procedure TNFeJSONReader.Ler_IBSCBSTot_gIBS(const AJSONObject: TACBrJSONObject; AGIBS: TgIBSTot);
begin
  if not Assigned(AJSONObject) then
    Exit;

  Ler_IBSCBSTot_gIBS_gIBSUFTot(AJSONObject.AsJSONObject['gIBSUFTot'], AGIBS.gIBSUFTot);
  Ler_IBSCBSTot_gIBS_gIBSMunTot(AJSONObject.AsJSONObject['gIBSMunTot'], AGIBS.gIBSMunTot);

  AGIBS.vIBS := AJSONObject.AsFloat['vIBS'];
  AGIBS.vCredPres := AJSONObject.AsFloat['vCredPres'];
  AGIBS.vCredPresCondSus := AJSONObject.AsFloat['vCredPresCondSus'];
end;

procedure TNFeJSONReader.Ler_IBSCBSTot_gIBS_gIBSUFTot(const AJSONObject: TACBrJSONObject; AGIBSUFTot: TgIBSUFTot);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGIBSUFTot.vDif := AJSONObject.AsFloat['vDif'];
  AGIBSUFTot.vDevTrib := AJSONObject.AsFloat['vDevTrib'];
  AGIBSUFTot.vIBSUF := AJSONObject.AsFloat['vIBSUF'];
  //AGIBSUFTot.vCredPres := AJSONObject.AsFloat['vCredPres'];
  //AGIBSUFTot.vCredPresCondSus := AJSONObject.AsFloat['vCredPresCondSus'];
end;

procedure TNFeJSONReader.Ler_IBSCBSTot_gIBS_gIBSMunTot(const AJSONObject: TACBrJSONObject; AGIBSMunTot: TgIBSMunTot);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGIBSMunTot.vDif := AJSONObject.AsFloat['vDif'];
  AGIBSMunTot.vDevTrib := AJSONObject.AsFloat['vDevTrib'];
  AGIBSMunTot.vIBSMun := AJSONObject.AsFloat['vIBSMun'];
  //AGIBSMunTot.vCredPres := AJSONObject.AsFloat['vCredPres'];
  //AGIBSMunTot.vCredPresCondSus := AJSONObject.AsFloat['vCredPresCondSus'];
end;

procedure TNFeJSONReader.Ler_IBSCBSTot_gCBS(const AJSONObject: TACBrJSONObject; AGCBS: TgCBSTot);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGCBS.vDif := AJSONObject.AsFloat['vDif'];
  AGCBS.vDevTrib := AJSONObject.AsFloat['vDevTrib'];
  AGCBS.vCBS := AJSONObject.AsFloat['vCBS'];
  AGCBS.vCredPres := AJSONObject.AsFloat['vCredPres'];
  AGCBS.vCredPresCondSus := AJSONObject.AsFloat['vCredPresCondSus'];
end;

procedure TNFeJSONReader.Ler_IBSCBSTot_gMono(const AJSONObject: TACBrJSONObject; AGMono: TgMono);
begin
  if not Assigned(AJSONObject) then
    Exit;

  AGMono.vIBSMono := AJSONObject.AsFloat['vIBSMono'];
  AGMono.vCBSMono := AJSONObject.AsFloat['vCBSMono'];
  AGMono.vIBSMonoReten := AJSONObject.AsFloat['vIBSMonoReten'];
  AGMono.vCBSMonoReten := AJSONObject.AsFloat['vCBSMonoReten'];
  AGMono.vIBSMonoRet := AJSONObject.AsFloat['vIBSMonoRet'];
  AGMono.vCBSMonoRet := AJSONObject.AsFloat['vCBSMonoRet'];
end;

end.
