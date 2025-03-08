{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrBPeXmlReader;

interface

uses
  Classes, SysUtils,
  ACBrXmlDocument, ACBrXmlReader,
  ACBrBPeClass;

type
  { TBPeXmlReader }
  TBPeXmlReader = class(TACBrXmlReader)
  private
    FBPe: TBPe;

    function NodeNaoEncontrado(const ANode: TACBrXmlNode): Boolean;

    procedure Ler_ProtBPe(const ANode: TACBrXmlNode);
    procedure Ler_InfBPe(const ANode: TACBrXmlNode);
    procedure Ler_Ide(const ANode: TACBrXmlNode);

    procedure Ler_Emit(const ANode: TACBrXmlNode);
    procedure Ler_EnderEmit(const ANode: TACBrXmlNode);

    procedure Ler_Comp(const ANode: TACBrXmlNode);
    procedure Ler_EnderComp(const ANode: TACBrXmlNode);

    procedure Ler_Agencia(const ANode: TACBrXmlNode);
    procedure Ler_EnderAgencia(const ANode: TACBrXmlNode);

    procedure Ler_infBPeSub(const ANode: TACBrXmlNode);
    procedure Ler_infPassagem(const ANode: TACBrXmlNode);
    procedure Ler_InfPassageiro(const ANode: TACBrXmlNode);

    procedure Ler_infViagem(const ANode: TACBrXmlNode);
    procedure Ler_infValorBPe(const ANode: TACBrXmlNode);
    procedure Ler_CompValor(const ANode: TACBrXmlNode);

    procedure Ler_imp(const ANode: TACBrXmlNode);
    procedure Ler_pag(const ANode: TACBrXmlNode);

    // BPe TM
    procedure Ler_detBPeTM(const ANode: TACBrXmlNode);

    procedure Ler_Total(const ANode: TACBrXmlNode);

    procedure Ler_autXML(const ANode: TACBrXmlNode);
    procedure Ler_InfAdic(const ANode: TACBrXmlNode);
    procedure Ler_infRespTec(const ANode: TACBrXmlNode);

    procedure Ler_InfBPeSupl(const ANode: TACBrXmlNode);

    // Reforma Tribut�ria
    procedure Ler_IBSCBS(const ANode: TACBrXmlNode; IBSCBS: TIBSCBS);
    procedure Ler_IBSCBS_gIBSCBS(const ANode: TACBrXmlNode; gIBSCBS: TgIBSCBS);

    procedure Ler_gIBSUF(const ANode: TACBrXmlNode; gIBSUF: TgIBSValores);
    procedure Ler_gIBSUF_gDif(const ANode: TACBrXmlNode; gDif: TgDif);
    procedure Ler_gIBSUF_gDevTrib(const ANode: TACBrXmlNode; gDevTrib: TgDevTrib);
    procedure Ler_gIBSUF_gRed(const ANode: TACBrXmlNode; gRed: TgRed);
    procedure Ler_gIBSUF_gDeson(const ANode: TACBrXmlNode; gDeson: TgDeson);

    procedure Ler_gIBSMun(const ANode: TACBrXmlNode; gIBSMun: TgIBSValores);
    procedure Ler_gIBSMun_gDif(const ANode: TACBrXmlNode; gDif: TgDif);
    procedure Ler_gIBSMun_gDevTrib(const ANode: TACBrXmlNode; gDevTrib: TgDevTrib);
    procedure Ler_gIBSMun_gRed(const ANode: TACBrXmlNode; gRed: TgRed);
    procedure Ler_gIBSMun_gDeson(const ANode: TACBrXmlNode; gDeson: TgDeson);

    procedure Ler_gCBS(const ANode: TACBrXmlNode; gCBS: TgCBSValores);
    procedure Ler_gCBS_gDif(const ANode: TACBrXmlNode; gDif: TgDif);
    procedure Ler_gCBS_gDevTrib(const ANode: TACBrXmlNode; gDevTrib: TgDevTrib);
    procedure Ler_gCBS_gRed(const ANode: TACBrXmlNode; gRed: TgRed);
    procedure Ler_gCBS_gDeson(const ANode: TACBrXmlNode; gDeson: TgDeson);

    procedure Ler_gIBSCredPres(const ANode: TACBrXmlNode; gIBSCredPres: TgIBSCBSCredPres);
    procedure Ler_gCBSCredPres(const ANode: TACBrXmlNode; gCBSCredPres: TgIBSCBSCredPres);

    procedure Ler_IBSCBSTot(const ANode: TACBrXmlNode; IBSCBSTot: TIBSCBSTot);
    procedure Ler_IBSCBSTot_gIBS(const ANode: TACBrXmlNode; gIBS: TgIBS);
    procedure Ler_IBSCBSTot_gIBS_gIBSUFTot(const ANode: TACBrXmlNode; gIBSUFTot: TgIBSUFTot);
    procedure Ler_IBSCBSTot_gIBS_gIBSMunTot(const ANode: TACBrXmlNode; gIBSMunTot: TgIBSMunTot);
    procedure Ler_IBSCBSTot_gCBS(const ANode: TACBrXmlNode; gCBS: TgCBS);
  public
    constructor Create(AOwner: TBPe); reintroduce;

    function LerXml: Boolean; override;

    property BPe: TBPe read FBPe write FBPe;
  end;

implementation

uses
  ACBrXmlBase, ACBrUtil.Base,
  ACBrBPeConversao;

{ TBPeXmlReader }

constructor TBPeXmlReader.Create(AOwner: TBPe);
begin
  inherited Create;

  FBPe := AOwner;
end;

function TBPeXmlReader.NodeNaoEncontrado(const ANode: TACBrXmlNode): Boolean;
begin
  Result := not Assigned(ANode);
end;

function TBPeXmlReader.LerXml: Boolean;
Var
  BPeNode, infBPeNode: TACBrXmlNode;
  att: TACBrXmlAttribute;
begin
  if not Assigned(FBPe) then
    raise Exception.Create('Destino n�o informado, informe a classe [TBPe] de destino.');

  if EstaVazio(Arquivo) then
    raise Exception.Create('Arquivo xml da BPe n�o carregado.');

  Document.Clear();
  Document.LoadFromXml(Arquivo);

  if (Document.Root.Name = 'BPeProc') or (Document.Root.Name = 'bpeProc') then
  begin
    Ler_ProtBPe(Document.Root.Childrens.Find('protBPe').Childrens.Find('infProt'));
    BPeNode := Document.Root.Childrens.Find('BPe');
  end
  else
  begin
    BPeNode := Document.Root;
  end;

  if BPeNode <> nil then
  begin
    infBPeNode := BPeNode.Childrens.Find('infBPe');

    if infBPeNode = nil then
      raise Exception.Create('Arquivo xml incorreto.');

    att := infBPeNode.Attributes.Items['Id'];

    if att = nil then
      raise Exception.Create('N�o encontrei o atributo: Id');

    BPe.infBPe.Id := att.Content;

    att := infBPeNode.Attributes.Items['versao'];

    if att = nil then
      raise Exception.Create('N�o encontrei o atributo: versao');

    BPe.infBPe.Versao := StringToFloat(att.Content);

    Ler_InfBPe(infBPeNode);
    Ler_InfBPeSupl(BPeNode.Childrens.Find('infBPeSupl'));

    LerSignature(BPeNode.Childrens.Find('Signature'), BPe.signature);
  end;

  Result := True;
end;

procedure TBPeXmlReader.Ler_ProtBPe(const ANode: TACBrXmlNode);
var
  ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  BPe.procBPe.tpAmb := StrToTipoAmbiente(ok, ObterConteudo(ANode.Childrens.Find('tpAmb'), tcStr));
  BPe.procBPe.verAplic := ObterConteudo(ANode.Childrens.Find('verAplic'), tcStr);
  BPe.procBPe.chDFe := ObterConteudo(ANode.Childrens.Find('chBPe'), tcStr);
  BPe.procBPe.dhRecbto := ObterConteudo(ANode.Childrens.Find('dhRecbto'), tcDatHor);
  BPe.procBPe.nProt := ObterConteudo(ANode.Childrens.Find('nProt'), tcStr);
  BPe.procBPe.digVal := ObterConteudo(ANode.Childrens.Find('digVal'), tcStr);
  BPe.procBPe.cStat := ObterConteudo(ANode.Childrens.Find('cStat'), tcInt);
  BPe.procBPe.xMotivo := ObterConteudo(ANode.Childrens.Find('xMotivo'), tcStr);
  BPe.procBPe.cMsg := ObterConteudo(ANode.Childrens.Find('cMsg'), tcInt);
  BPe.procBPe.xMsg := ObterConteudo(ANode.Childrens.Find('xMsg'), tcStr);
end;

procedure TBPeXmlReader.Ler_InfBPe(const ANode: TACBrXmlNode);
var
  i: Integer;
  ANodes: TACBrXmlNodeArray;
begin
  if not Assigned(ANode) then Exit;

  Ler_Ide(ANode.Childrens.Find('ide'));
  Ler_Emit(ANode.Childrens.Find('emit'));

  if BPe.ide.tpBPe = tbBPeTM then
  begin
    ANodes := ANode.Childrens.FindAll('detBPeTM');
    for i := 0 to Length(ANodes) - 1 do
    begin
      Ler_detBPeTM(ANodes[i]);
    end;

    Ler_Total(ANode.Childrens.Find('total'));
  end
  else
  begin
    Ler_Comp(ANode.Childrens.Find('comp'));
    Ler_Agencia(ANode.Childrens.Find('agencia'));
    Ler_infBPeSub(ANode.Childrens.Find('infBPeSub'));
    Ler_infPassagem(ANode.Childrens.Find('infPassagem'));

    ANodes := ANode.Childrens.FindAll('infViagem');
    for i := 0 to Length(ANodes) - 1 do
    begin
      Ler_infViagem(ANodes[i]);
    end;

    Ler_infValorBPe(ANode.Childrens.Find('infValorBPe'));
    Ler_imp(ANode.Childrens.Find('imp'));

    ANodes := ANode.Childrens.FindAll('pag');
    for i := 0 to Length(ANodes) - 1 do
    begin
      Ler_pag(ANodes[i]);
    end;
  end;

  ANodes := ANode.Childrens.FindAll('autXML');
  for i := 0 to Length(ANodes) - 1 do
  begin
    Ler_autXML(ANodes[i]);
  end;

  Ler_InfAdic(ANode.Childrens.Find('infAdic'));

  Ler_infRespTec(ANode.Childrens.Find('infRespTec'));
end;

procedure TBPeXmlReader.Ler_Ide(const ANode: TACBrXmlNode);
var
  ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  BPe.ide.cUF := ObterConteudo(ANode.Childrens.Find('cUF'), tcInt);
  BPe.Ide.tpAmb := StrToTipoAmbiente(ok, ObterConteudo(ANode.Childrens.Find('tpAmb'), tcStr));

  BPe.ide.modelo := ObterConteudo(ANode.Childrens.Find('mod'), tcInt);
  BPe.ide.serie := ObterConteudo(ANode.Childrens.Find('serie'), tcInt);
  BPe.ide.nBP := ObterConteudo(ANode.Childrens.Find('nBP'), tcInt);
  BPe.ide.cBP := ObterConteudo(ANode.Childrens.Find('cBP'), tcInt);
  BPe.Ide.cDV := ObterConteudo(ANode.Childrens.Find('cDV'), tcInt);
  BPe.Ide.modal := StrToModalBPe(Ok, ObterConteudo(ANode.Childrens.Find('modal'), tcStr));

  BPe.ide.dhEmi := ObterConteudo(ANode.Childrens.Find('dhEmi'), tcDatHor);
  BPe.ide.dCompet := ObterConteudo(ANode.Childrens.Find('dCompet'), tcDat);
  BPe.Ide.tpEmis := StrToTipoEmissao(ok, ObterConteudo(ANode.Childrens.Find('tpEmis'), tcStr));

  BPe.Ide.verProc := ObterConteudo(ANode.Childrens.Find('verProc'), tcStr);
  BPe.Ide.tpBPe := StrToTpBPe(Ok, ObterConteudo(ANode.Childrens.Find('tpBPe'), tcStr));

  BPe.Ide.indPres := StrToPresencaComprador(Ok, ObterConteudo(ANode.Childrens.Find('indPres'), tcStr));

  BPe.Ide.UFIni := ObterConteudo(ANode.Childrens.Find('UFIni'), tcStr);
  BPe.Ide.cMunIni := ObterConteudo(ANode.Childrens.Find('cMunIni'), tcInt);
  BPe.Ide.UFFim := ObterConteudo(ANode.Childrens.Find('UFFim'), tcStr);
  BPe.Ide.cMunFim := ObterConteudo(ANode.Childrens.Find('cMunFim'), tcInt);
  BPe.Ide.dhCont := ObterConteudo(ANode.Childrens.Find('dhCont'), tcDatHor);
  BPe.Ide.xJust := ObterConteudo(ANode.Childrens.Find('xJust'), tcStr);
  BPe.Ide.CFOP := ObterConteudo(ANode.Childrens.Find('CFOP'), tcInt);
end;

procedure TBPeXmlReader.Ler_Emit(const ANode: TACBrXmlNode);
var
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  BPe.Emit.CNPJ := ObterCNPJCPF(ANode);
  BPe.Emit.IE := ObterConteudo(ANode.Childrens.Find('IE'), tcStr);
  BPe.Emit.IEST := ObterConteudo(ANode.Childrens.Find('IEST'), tcStr);
  BPe.Emit.xNome := ObterConteudo(ANode.Childrens.Find('xNome'), tcStr);
  BPe.Emit.xFant := ObterConteudo(ANode.Childrens.Find('xFant'), tcStr);
  BPe.Emit.IM := ObterConteudo(ANode.Childrens.Find('IM'), tcStr);
  BPe.Emit.CNAE := ObterConteudo(ANode.Childrens.Find('CNAE'), tcStr);
  BPe.Emit.CRT := StrToCRT(Ok, ObterConteudo(ANode.Childrens.Find('CRT'), tcStr));

  Ler_EnderEmit(ANode.Childrens.Find('enderEmit'));

  BPe.Emit.TAR := ObterConteudo(ANode.Childrens.Find('TAR'), tcStr);
end;

procedure TBPeXmlReader.Ler_EnderEmit(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  BPe.Emit.enderEmit.xLgr := ObterConteudo(ANode.Childrens.Find('xLgr'), tcStr);
  BPe.Emit.enderEmit.nro := ObterConteudo(ANode.Childrens.Find('nro'), tcStr);
  BPe.Emit.enderEmit.xCpl := ObterConteudo(ANode.Childrens.Find('xCpl'), tcStr);
  BPe.Emit.enderEmit.xBairro := ObterConteudo(ANode.Childrens.Find('xBairro'), tcStr);
  BPe.Emit.EnderEmit.cMun := ObterConteudo(ANode.Childrens.Find('cMun'), tcInt);
  BPe.Emit.enderEmit.xMun := ObterConteudo(ANode.Childrens.Find('xMun'), tcStr);
  BPe.Emit.enderEmit.CEP := ObterConteudo(ANode.Childrens.Find('CEP'), tcInt);
  BPe.Emit.enderEmit.UF := ObterConteudo(ANode.Childrens.Find('UF'), tcStr);
  BPe.Emit.enderEmit.fone := ObterConteudo(ANode.Childrens.Find('fone'), tcStr);
  BPe.Emit.enderEmit.email := ObterConteudo(ANode.Childrens.Find('email'), tcStr);
end;

procedure TBPeXmlReader.Ler_Comp(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  BPe.Comp.xNome := ObterConteudo(ANode.Childrens.Find('xNome'), tcStr);

  BPe.Comp.CNPJCPF := ObterCNPJCPF(ANode);

  if BPe.Comp.CNPJCPF = '' then
    BPe.Comp.idEstrangeiro := ObterConteudo(ANode.Childrens.Find('idEstrangeiro'), tcStr);

  BPe.Comp.IE := ObterConteudo(ANode.Childrens.Find('IE'), tcStr);

  Ler_EnderComp(ANode.Childrens.Find('enderComp'));
end;

procedure TBPeXmlReader.Ler_EnderComp(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  BPe.Comp.EnderComp.xLgr := ObterConteudo(ANode.Childrens.Find('xLgr'), tcStr);
  BPe.Comp.EnderComp.nro := ObterConteudo(ANode.Childrens.Find('nro'), tcStr);
  BPe.Comp.EnderComp.xCpl := ObterConteudo(ANode.Childrens.Find('xCpl'), tcStr);
  BPe.Comp.EnderComp.xBairro := ObterConteudo(ANode.Childrens.Find('xBairro'), tcStr);
  BPe.Comp.EnderComp.cMun := ObterConteudo(ANode.Childrens.Find('cMun'), tcInt);
  BPe.Comp.EnderComp.xMun := ObterConteudo(ANode.Childrens.Find('xMun'), tcStr);
  BPe.Comp.EnderComp.CEP := ObterConteudo(ANode.Childrens.Find('CEP'), tcInt);
  BPe.Comp.EnderComp.UF := ObterConteudo(ANode.Childrens.Find('UF'), tcStr);
  BPe.Comp.EnderComp.cPais := ObterConteudo(ANode.Childrens.Find('cPais'), tcInt);
  BPe.Comp.EnderComp.xPais := ObterConteudo(ANode.Childrens.Find('xPais'), tcStr);
  BPe.Comp.EnderComp.fone := ObterConteudo(ANode.Childrens.Find('fone'), tcStr);
  BPe.Comp.EnderComp.email := ObterConteudo(ANode.Childrens.Find('email'), tcStr);
end;

procedure TBPeXmlReader.Ler_Agencia(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  BPe.Agencia.xNome := ObterConteudo(ANode.Childrens.Find('xNome'), tcStr);

  BPe.Agencia.CNPJ := ObterCNPJCPF(ANode);

  Ler_EnderAgencia(ANode.Childrens.Find('enderAgencia'));
end;

procedure TBPeXmlReader.Ler_EnderAgencia(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  BPe.Agencia.EnderAgencia.xLgr := ObterConteudo(ANode.Childrens.Find('xLgr'), tcStr);
  BPe.Agencia.EnderAgencia.nro := ObterConteudo(ANode.Childrens.Find('nro'), tcStr);
  BPe.Agencia.EnderAgencia.xCpl := ObterConteudo(ANode.Childrens.Find('xCpl'), tcStr);
  BPe.Agencia.EnderAgencia.xBairro := ObterConteudo(ANode.Childrens.Find('xBairro'), tcStr);
  BPe.Agencia.EnderAgencia.cMun := ObterConteudo(ANode.Childrens.Find('cMun'), tcInt);
  BPe.Agencia.EnderAgencia.xMun := ObterConteudo(ANode.Childrens.Find('xMun'), tcStr);
  BPe.Agencia.EnderAgencia.CEP := ObterConteudo(ANode.Childrens.Find('CEP'), tcInt);
  BPe.Agencia.EnderAgencia.UF := ObterConteudo(ANode.Childrens.Find('UF'), tcStr);
  BPe.Agencia.EnderAgencia.cPais := ObterConteudo(ANode.Childrens.Find('cPais'), tcInt);
  BPe.Agencia.EnderAgencia.xPais := ObterConteudo(ANode.Childrens.Find('xPais'), tcStr);
  BPe.Agencia.EnderAgencia.fone := ObterConteudo(ANode.Childrens.Find('fone'), tcStr);
  BPe.Agencia.EnderAgencia.email := ObterConteudo(ANode.Childrens.Find('email'), tcStr);
end;

procedure TBPeXmlReader.Ler_infBPeSub(const ANode: TACBrXmlNode);
var
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  BPe.infBPeSub.chBPe := ObterConteudo(ANode.Childrens.Find('chBPe'), tcStr);
  BPe.infBPeSub.tpSub := StrTotpSubstituicao(Ok, ObterConteudo(ANode.Childrens.Find('tpSub'), tcStr));
end;

procedure TBPeXmlReader.Ler_infPassagem(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  BPe.infPassagem.cLocOrig := ObterConteudo(ANode.Childrens.Find('cLocOrig'), tcStr);
  BPe.infPassagem.xLocOrig := ObterConteudo(ANode.Childrens.Find('xLocOrig'), tcStr);
  BPe.infPassagem.cLocDest := ObterConteudo(ANode.Childrens.Find('cLocDest'), tcStr);
  BPe.infPassagem.xLocDest := ObterConteudo(ANode.Childrens.Find('xLocDest'), tcStr);
  BPe.infPassagem.dhEmb := ObterConteudo(ANode.Childrens.Find('dhEmb'), tcDatHor);
  BPe.infPassagem.dhValidade := ObterConteudo(ANode.Childrens.Find('dhValidade'), tcDatHor);

  Ler_InfPassageiro(ANode.Childrens.Find('infPassageiro'));
end;

procedure TBPeXmlReader.Ler_InfPassageiro(const ANode: TACBrXmlNode);
var
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  BPe.infPassagem.infPassageiro.xNome := ObterConteudo(ANode.Childrens.Find('xNome'), tcStr);
  BPe.infPassagem.infPassageiro.CPF := ObterConteudo(ANode.Childrens.Find('CPF'), tcStr);
  BPe.infPassagem.infPassageiro.tpDoc := StrTotpDocumento(Ok, ObterConteudo(ANode.Childrens.Find('tpDoc'), tcStr));

  BPe.infPassagem.infPassageiro.nDoc := ObterConteudo(ANode.Childrens.Find('nDoc'), tcStr);
  BPe.infPassagem.infPassageiro.xDoc := ObterConteudo(ANode.Childrens.Find('xDoc'), tcStr);
  BPe.infPassagem.infPassageiro.dNasc := ObterConteudo(ANode.Childrens.Find('dNasc'), tcDat);
  BPe.infPassagem.infPassageiro.Fone := ObterConteudo(ANode.Childrens.Find('fone'), tcStr);
  BPe.infPassagem.infPassageiro.Email := ObterConteudo(ANode.Childrens.Find('email'), tcStr);
end;

procedure TBPeXmlReader.Ler_infViagem(const ANode: TACBrXmlNode);
var
  Item: TInfViagemCollectionItem;
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  Item := BPe.infViagem.New;

  Item.cPercurso := ObterConteudo(ANode.Childrens.Find('cPercurso'), tcStr);
  Item.xPercurso := ObterConteudo(ANode.Childrens.Find('xPercurso'), tcStr);
  Item.tpViagem := StrTotpViagem(Ok, ObterConteudo(ANode.Childrens.Find('tpViagem'), tcStr));

  Item.tpServ := StrTotpServico(Ok, ObterConteudo(ANode.Childrens.Find('tpServ'), tcStr));

  Item.tpAcomodacao := StrTotpAcomodacao(Ok, ObterConteudo(ANode.Childrens.Find('tpAcomodacao'), tcStr));

  Item.tpTrecho := StrTotpTrecho(Ok, ObterConteudo(ANode.Childrens.Find('tpTrecho'), tcStr));

  Item.dhViagem := ObterConteudo(ANode.Childrens.Find('dhViagem'), tcDatHor);
  Item.dhConexao := ObterConteudo(ANode.Childrens.Find('dhConexao'), tcDatHor);
  Item.prefixo := ObterConteudo(ANode.Childrens.Find('prefixo'), tcStr);
  Item.poltrona := ObterConteudo(ANode.Childrens.Find('poltrona'), tcInt);
  Item.plataforma := ObterConteudo(ANode.Childrens.Find('plataforma'), tcStr);

  AuxNode := ANode.Childrens.Find('infTravessia');

  if not (NodeNaoEncontrado(AuxNode)) then
  begin
    Item.infTravessia.tpVeiculo := StrTotpVeiculo(Ok, ObterConteudo(AuxNode.Childrens.Find('tpVeiculo'), tcStr));

    Item.infTravessia.sitVeiculo := StrToSitVeiculo(Ok, ObterConteudo(AuxNode.Childrens.Find('sitVeiculo'), tcStr));
  end;
end;

procedure TBPeXmlReader.Ler_infValorBPe(const ANode: TACBrXmlNode);
var
  ANodes: TACBrXmlNodeArray;
  i: Integer;
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  BPe.infValorBPe.vBP := ObterConteudo(ANode.Childrens.Find('vBP'), tcDe2);
  BPe.infValorBPe.vDesconto := ObterConteudo(ANode.Childrens.Find('vDesconto'), tcDe2);
  BPe.infValorBPe.vPgto := ObterConteudo(ANode.Childrens.Find('vPgto'), tcDe2);
  BPe.infValorBPe.vTroco := ObterConteudo(ANode.Childrens.Find('vTroco'), tcDe2);
  BPe.infValorBPe.tpDesconto := StrTotpDesconto(Ok, ObterConteudo(ANode.Childrens.Find('tpDesconto'), tcStr));

  BPe.infValorBPe.xDesconto := ObterConteudo(ANode.Childrens.Find('xDesconto'), tcStr);
  BPe.infValorBPe.cDesconto := ObterConteudo(ANode.Childrens.Find('cDesconto'), tcStr);

  ANodes := ANode.Childrens.FindAll('Comp');
  for i := 0 to Length(ANodes) - 1 do
  begin
    Ler_CompValor(ANodes[i]);
  end;
end;

procedure TBPeXmlReader.Ler_CompValor(const ANode: TACBrXmlNode);
var
  Item: TCompCollectionItem;
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  Item := BPe.infValorBPe.Comp.New;

  Item.tpComp := StrTotpComponente(Ok, ObterConteudo(ANode.Childrens.Find('tpComp'), tcStr));

  Item.vComp := ObterConteudo(ANode.Childrens.Find('vComp'), tcDe2);
end;

procedure TBPeXmlReader.Ler_imp(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNode2: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  BPe.Imp.vTotTrib := ObterConteudo(ANode.Childrens.Find('vTotTrib'), tcDe2);
  BPe.Imp.infAdFisco := ObterConteudo(ANode.Childrens.Find('infAdFisco'), tcStr);

  AuxNode := ANode.Childrens.Find('ICMS');

  if (AuxNode <> nil) then
    AuxNode := AuxNode.Childrens.Items[0];

  if AuxNode <> nil then
  begin
    BPe.Imp.ICMS.CST := StrToCSTICMS(Ok, ObterConteudo(AuxNode.Childrens.Find('CST'), tcStr));
    BPe.Imp.ICMS.vBC := ObterConteudo(AuxNode.Childrens.Find('vBC'), tcDe2);
    BPe.Imp.ICMS.pICMS := ObterConteudo(AuxNode.Childrens.Find('pICMS'), tcDe2);
    BPe.Imp.ICMS.vICMS := ObterConteudo(AuxNode.Childrens.Find('vICMS'), tcDe2);
    BPe.Imp.ICMS.pRedBC := ObterConteudo(AuxNode.Childrens.Find('pRedBC'), tcDe2);
    BPe.Imp.ICMS.vCred := ObterConteudo(AuxNode.Childrens.Find('vCred'), tcDe2);
    BPe.Imp.ICMS.pRedBCOutraUF := ObterConteudo(AuxNode.Childrens.Find('pRedBCOutraUF'), tcDe2);
    BPe.Imp.ICMS.vBCOutraUF := ObterConteudo(AuxNode.Childrens.Find('vBCOutraUF'), tcDe2);
    BPe.Imp.ICMS.pICMSOutraUF := ObterConteudo(AuxNode.Childrens.Find('pICMSOutraUF'), tcDe2);
    BPe.Imp.ICMS.vICMSOutraUF := ObterConteudo(AuxNode.Childrens.Find('vICMSOutraUF'), tcDe2);
    BPe.Imp.ICMS.vICMSDeson := ObterConteudo(AuxNode.Childrens.Find('vICMSDeson'), tcDe2);
    BPe.Imp.ICMS.cBenef := ObterConteudo(AuxNode.Childrens.Find('cBenef'), tcStr);

    AuxNode2 := AuxNode.Childrens.Find('ICMSSN');

    if AuxNode2 <> nil then
      BPe.Imp.ICMS.CST := cstSN;
  end;

  AuxNode := ANode.Childrens.Find('ICMSUFFim');

  if AuxNode <> nil then
  begin
    BPe.Imp.ICMSUFFim.vBCUFFim := ObterConteudo(AuxNode.Childrens.Find('vBCUFFim'), tcDe2);
    BPe.Imp.ICMSUFFim.pFCPUFFim := ObterConteudo(AuxNode.Childrens.Find('pFCPUFFim'), tcDe2);
    BPe.Imp.ICMSUFFim.pICMSUFFim := ObterConteudo(AuxNode.Childrens.Find('pICMSUFFim'), tcDe2);
    BPe.Imp.ICMSUFFim.pICMSInter := ObterConteudo(AuxNode.Childrens.Find('pICMSInter'), tcDe2);
    BPe.Imp.ICMSUFFim.pICMSInterPart := ObterConteudo(AuxNode.Childrens.Find('pICMSInterPart'), tcDe2);
    BPe.Imp.ICMSUFFim.vFCPUFFim := ObterConteudo(AuxNode.Childrens.Find('vFCPUFFim'), tcDe2);
    BPe.Imp.ICMSUFFim.vICMSUFFim := ObterConteudo(AuxNode.Childrens.Find('vICMSUFFim'), tcDe2);
    BPe.Imp.ICMSUFFim.vICMSUFIni := ObterConteudo(AuxNode.Childrens.Find('vICMSUFIni'), tcDe2);
  end;

  // Reforma Tribut�ria
  { Descomentar somente quando for liberador o ambiente de homologa��o
  Ler_IBSCBS(ANode.Childrens.Find('IBSCBS'), BPe.Imp.IBSCBS);

  if BPe.ide.tpBPe <> tbBPeTM then
    BPe.Imp.vTotDFe := ObterConteudo(ANode.Childrens.Find('vTotDFe'), tcDe2);
  }
end;

procedure TBPeXmlReader.Ler_pag(const ANode: TACBrXmlNode);
var
  Item: TpagCollectionItem;
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  Item := BPe.Pag.New;

  Item.tPag := StrToFormaPagamentoBPe(Ok, ObterConteudo(ANode.Childrens.Find('tPag'), tcStr));

  Item.xPag := ObterConteudo(ANode.Childrens.Find('xPag'), tcStr);
  Item.nDocPag := ObterConteudo(ANode.Childrens.Find('nDocPag'), tcStr);
  Item.vPag := ObterConteudo(ANode.Childrens.Find('vPag'), tcDe2);

  AuxNode := ANode.Childrens.Find('card');
  if (AuxNode <> nil) then
  begin
    Item.tpIntegra := StrTotpIntegra(Ok, ObterConteudo(AuxNode.Childrens.Find('tpIntegra'), tcStr));
    Item.CNPJ := ObterConteudo(AuxNode.Childrens.Find('CNPJ'), tcStr);
    Item.tBand := StrToBandeiraCard(Ok, ObterConteudo(AuxNode.Childrens.Find('tBand'), tcStr));

    Item.xBand := ObterConteudo(AuxNode.Childrens.Find('xBand'), tcStr);
    Item.cAut := ObterConteudo(AuxNode.Childrens.Find('cAut'), tcStr);
    Item.nsuTrans := ObterConteudo(AuxNode.Childrens.Find('nsuTrans'), tcStr);
    Item.nsuHost := ObterConteudo(AuxNode.Childrens.Find('nsuHost'), tcStr);
    Item.nParcelas := ObterConteudo(AuxNode.Childrens.Find('nParcelas'), tcInt);
    Item.infAdCard := ObterConteudo(AuxNode.Childrens.Find('infAdCard'), tcStr);
  end;
end;

procedure TBPeXmlReader.Ler_detBPeTM(const ANode: TACBrXmlNode);
var
  Item: TdetBPeTMCollectionItem;
  ItemComp: TdetCompCollectionItem;
  i: Integer;
  j: Integer;
  ANodeNivel3: TACBrXmlNode;
  ANodeNivel4: TACBrXmlNode;
  ANodeNivel5: TACBrXmlNode;
  ANodeNivel6: TACBrXmlNode;
  ADetNodes: TACBrXmlNodeArray;
  CompNodes: TACBrXmlNodeArray;
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  Item := BPe.detBPeTM.New;
  Item.idEqpCont   := StrToIntDef(ObterConteudoTag(ANode.Attributes.Items['idEqpCont']), 0);

  Item.UFIniViagem := ObterConteudo(ANode.Childrens.Find('UFIniViagem'), tcStr);
  Item.UFFimViagem := ObterConteudo(ANode.Childrens.Find('UFFimViagem'), tcStr);
  Item.placa := ObterConteudo(ANode.Childrens.Find('placa'), tcStr);
  Item.prefixo := ObterConteudo(ANode.Childrens.Find('prefixo'), tcStr);

  Item.Det.Clear;
  ADetNodes := ANode.Childrens.FindAll('det');

  for i := 0 to Length(ADetNodes) - 1 do
  begin
    with Item.Det.New do
    begin
      nViagem := StrToInt(ObterConteudoTag(ADetNodes[i].Attributes.Items['nViagem']));
      cMunIni := ObterConteudo(ADetNodes[i].Childrens.Find('cMunIni'), tcInt);
      cMunFim := ObterConteudo(ADetNodes[i].Childrens.Find('cMunFim'), tcInt);
      nContInicio := ObterConteudo(ADetNodes[i].Childrens.Find('nContInicio'), tcStr);
      nContFim := ObterConteudo(ADetNodes[i].Childrens.Find('nContFim'), tcStr);
      qPass := ObterConteudo(ADetNodes[i].Childrens.Find('qPass'), tcStr);
      vBP := ObterConteudo(ADetNodes[i].Childrens.Find('vBP'), tcDe2);

      ANodeNivel3 := ADetNodes[i].Childrens.Find('imp');

      if NodeNaoEncontrado(ANodeNivel3) then
      begin
        Imp.infAdFisco := ObterConteudo(ANodeNivel3.Childrens.Find('infAdFisco'), tcStr);

        ANodeNivel4 := ADetNodes[i].Childrens.Find('imp');

        if NodeNaoEncontrado(ANodeNivel4) then
        begin
          Imp.infAdFisco := ObterConteudo(ANodeNivel4.Childrens.Find('infAdFisco'), tcStr);

          ANodeNivel5 := ANodeNivel4.Childrens.Find('ICMS');

          if ANodeNivel5 <> nil then
          begin
            Imp.ICMS.CST := StrToCSTICMS(Ok, ObterConteudo(ANodeNivel5.Childrens.Find('CST'), tcStr));

            Imp.ICMS.vBC := ObterConteudo(ANodeNivel5.Childrens.Find('vBC'), tcDe2);

            Imp.ICMS.pICMS := ObterConteudo(ANodeNivel5.Childrens.Find('pICMS'), tcDe2);
            Imp.ICMS.vICMS := ObterConteudo(ANodeNivel5.Childrens.Find('vICMS'), tcDe2);
            Imp.ICMS.pRedBC := ObterConteudo(ANodeNivel5.Childrens.Find('pRedBC'), tcDe2);
            Imp.ICMS.vCred := ObterConteudo(ANodeNivel5.Childrens.Find('vCred'), tcDe2);
            Imp.ICMS.pRedBCOutraUF := ObterConteudo(ANodeNivel5.Childrens.Find('pRedBCOutraUF'), tcDe2);
            Imp.ICMS.vBCOutraUF := ObterConteudo(ANodeNivel5.Childrens.Find('vBCOutraUF'), tcDe2);
            Imp.ICMS.pICMSOutraUF := ObterConteudo(ANodeNivel5.Childrens.Find('pICMSOutraUF'), tcDe2);
            Imp.ICMS.vICMSOutraUF := ObterConteudo(ANodeNivel5.Childrens.Find('vICMSOutraUF'), tcDe2);

            ANodeNivel6 := ANodeNivel5.Childrens.Find('ICMSSN');

            if ANodeNivel6 <> nil then
              BPe.Imp.ICMS.CST := cstSN;
          end;
        end;
      end;

      Comp.Clear;
      CompNodes := ADetNodes[i].Childrens.FindAll('Comp');

      for j := 0 to Length(CompNodes) - 1 do
      begin
        ItemComp := Comp.New;
        ItemComp.xNome := ObterConteudo(CompNodes[j].Childrens.Find('xNome'), tcStr);
        ItemComp.qComp := ObterConteudo(CompNodes[j].Childrens.Find('qComp'), tcInt);
      end;
    end;
  end;
end;

procedure TBPeXmlReader.Ler_Total(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  BPe.Total.qPass := ObterConteudo(ANode.Childrens.Find('qPass'), tcInt);
  BPe.Total.vBP := ObterConteudo(ANode.Childrens.Find('vBP'), tcDe2);

  AuxNode := ANode.Childrens.Find('ICMSTot');

  if AuxNode <> nil then
  begin
    BPe.Total.vBC := ObterConteudo(AuxNode.Childrens.Find('vBC'), tcDe2);
    BPe.Total.vICMS := ObterConteudo(AuxNode.Childrens.Find('vICMS'), tcDe2);
  end;

  // Reforma Tribut�ria
  { Descomentar somente quando for liberador o ambiente de homologa��o
  if BPe.ide.tpBPe = tbBPeTM then
  begin
    Ler_IBSCBSTot(ANode.Childrens.Find('IBSCBSTot'), BPe.total.IBSCBSTot);
    BPe.Total.vTotDFe := ObterConteudo(AuxNode.Childrens.Find('vTotDFe'), tcDe2);
  end;
  }
end;

procedure TBPeXmlReader.Ler_autXML(const ANode: TACBrXmlNode);
var
  Item: TautXMLCollectionItem;
begin
  if not Assigned(ANode) then Exit;

  Item := BPe.autXML.New;

  Item.CNPJCPF := ObterCNPJCPF(ANode);
end;

procedure TBPeXmlReader.Ler_InfAdic(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  BPe.InfAdic.infAdFisco := ObterConteudo(ANode.Childrens.Find('infAdFisco'), tcStr);
  BPe.InfAdic.infCpl := ObterConteudo(ANode.Childrens.Find('infCpl'), tcStr);
end;

procedure TBPeXmlReader.Ler_infRespTec(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  BPe.infRespTec.CNPJ     := ObterConteudo(ANode.Childrens.Find('CNPJ'), tcStr);
  BPe.infRespTec.xContato := ObterConteudo(ANode.Childrens.Find('xContato'), tcStr);
  BPe.infRespTec.email    := ObterConteudo(ANode.Childrens.Find('email'), tcStr);
  BPe.infRespTec.fone     := ObterConteudo(ANode.Childrens.Find('fone'), tcStr);
  BPe.infRespTec.idCSRT   := ObterConteudo(ANode.Childrens.Find('idCSRT'), tcInt);
  BPe.infRespTec.hashCSRT := ObterConteudo(ANode.Childrens.Find('hashCSRT'), tcStr);
end;

procedure TBPeXmlReader.Ler_InfBPeSupl(const ANode: TACBrXmlNode);
var
 sQrCode: string;
begin
  if not Assigned(ANode) then Exit;

  sQrCode := ObterConteudo(ANode.Childrens.Find('qrCodBPe'), tcStr);
  sQrCode := StringReplace(sQrCode, '<![CDATA[', '', []);
  sQrCode := StringReplace(sQrCode, ']]>', '', []);

  BPe.infBPeSupl.qrCodBPe := sQrCode;
end;

// Reforma Tribut�ria
procedure TBPeXmlReader.Ler_IBSCBS(const ANode: TACBrXmlNode; IBSCBS: TIBSCBS);
begin
  if not Assigned(ANode) then Exit;

  IBSCBS.CST := ObterConteudo(ANode.Childrens.Find('CST'), tcInt);
  IBSCBS.cClassTrib := ObterConteudo(ANode.Childrens.Find('cClassTrib'), tcInt);

  Ler_IBSCBS_gIBSCBS(ANode.Childrens.Find('gIBSCBS'), IBSCBS.gIBSCBS);
end;

procedure TBPeXmlReader.Ler_IBSCBS_gIBSCBS(const ANode: TACBrXmlNode; gIBSCBS: TgIBSCBS);
begin
  if not Assigned(ANode) then Exit;

  gIBSCBS.vBC := ObterConteudo(ANode.Childrens.Find('vBC'), tcDe2);

  Ler_gIBSUF(ANode.Childrens.Find('gIBSUF'), gIBSCBS.gIBSUF);
  Ler_gIBSMun(ANode.Childrens.Find('gIBSMun'), gIBSCBS.gIBSMun);
  Ler_gCBS(ANode.Childrens.Find('gCBS'), gIBSCBS.gCBS);
  Ler_gIBSCredPres(ANode.Childrens.Find('gIBSCredPres'), gIBSCBS.gIBSCredPres);
  Ler_gCBSCredPres(ANode.Childrens.Find('gCBSCredPres'), gIBSCBS.gCBSCredPres);
end;

procedure TBPeXmlReader.Ler_gIBSUF(const ANode: TACBrXmlNode; gIBSUF: TgIBSValores);
begin
  if not Assigned(ANode) then Exit;

  gIBSUF.pIBS := ObterConteudo(ANode.Childrens.Find('pIBSUF'), tcDe4);
  gIBSUF.vTribOp := ObterConteudo(ANode.Childrens.Find('vTribOp'), tcDe2);

  Ler_gIBSUF_gDif(ANode.Childrens.Find('gDif'), gIBSUF.gDif);
  Ler_gIBSUF_gDevTrib(ANode.Childrens.Find('gDevTrib'), gIBSUF.gDevTrib);
  Ler_gIBSUF_gRed(ANode.Childrens.Find('gRed'), gIBSUF.gRed);
  Ler_gIBSUF_gDeson(ANode.Childrens.Find('gDeson'), gIBSUF.gDeson);

  gIBSUF.vIBS := ObterConteudo(ANode.Childrens.Find('vIBSUF'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gIBSUF_gDif(const ANode: TACBrXmlNode; gDif: TgDif);
begin
  if not Assigned(ANode) then Exit;

  gDif.pDif := ObterConteudo(ANode.Childrens.Find('pDif'), tcDe4);
  gDif.vDif := ObterConteudo(ANode.Childrens.Find('vDif'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gIBSUF_gDevTrib(const ANode: TACBrXmlNode; gDevTrib: TgDevTrib);
begin
  if not Assigned(ANode) then Exit;

  gDevTrib.vDevTrib := ObterConteudo(ANode.Childrens.Find('vDevTrib'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gIBSUF_gRed(const ANode: TACBrXmlNode; gRed: TgRed);
begin
  if not Assigned(ANode) then Exit;

  gRed.pRedAliq := ObterConteudo(ANode.Childrens.Find('pRedAliq'), tcDe4);
  gRed.pAliqEfet := ObterConteudo(ANode.Childrens.Find('pAliqEfet'), tcDe4);
end;

procedure TBPeXmlReader.Ler_gIBSUF_gDeson(const ANode: TACBrXmlNode; gDeson: TgDeson);
begin
  if not Assigned(ANode) then Exit;

  gDeson.CST := ObterConteudo(ANode.Childrens.Find('CST'), tcInt);
  gDeson.cClassTrib := ObterConteudo(ANode.Childrens.Find('cClassTrib'), tcInt);
  gDeson.vBC := ObterConteudo(ANode.Childrens.Find('vBC'), tcDe2);
  gDeson.pAliq := ObterConteudo(ANode.Childrens.Find('pAliq'), tcDe4);
  gDeson.vDeson := ObterConteudo(ANode.Childrens.Find('vDeson'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gIBSMun(const ANode: TACBrXmlNode; gIBSMun: TgIBSValores);
begin
  if not Assigned(ANode) then Exit;

  gIBSMun.pIBS := ObterConteudo(ANode.Childrens.Find('pIBSMun'), tcDe4);
  gIBSMun.vTribOp := ObterConteudo(ANode.Childrens.Find('vTribOp'), tcDe2);

  Ler_gIBSMun_gDif(ANode.Childrens.Find('gDif'), gIBSMun.gDif);
  Ler_gIBSMun_gDevTrib(ANode.Childrens.Find('gDevTrib'), gIBSMun.gDevTrib);
  Ler_gIBSMun_gRed(ANode.Childrens.Find('gRed'), gIBSMun.gRed);
  Ler_gIBSMun_gDeson(ANode.Childrens.Find('gDeson'), gIBSMun.gDeson);

  gIBSMun.vIBS := ObterConteudo(ANode.Childrens.Find('vIBSMun'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gIBSMun_gDif(const ANode: TACBrXmlNode; gDif: TgDif);
begin
  if not Assigned(ANode) then Exit;

  gDif.pDif := ObterConteudo(ANode.Childrens.Find('pDif'), tcDe4);
  gDif.vDif := ObterConteudo(ANode.Childrens.Find('vDif'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gIBSMun_gDevTrib(const ANode: TACBrXmlNode; gDevTrib: TgDevTrib);
begin
  if not Assigned(ANode) then Exit;

  gDevTrib.vDevTrib := ObterConteudo(ANode.Childrens.Find('vDevTrib'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gIBSMun_gRed(const ANode: TACBrXmlNode; gRed: TgRed);
begin
  if not Assigned(ANode) then Exit;

  gRed.pRedAliq := ObterConteudo(ANode.Childrens.Find('pRedAliq'), tcDe4);
  gRed.pAliqEfet := ObterConteudo(ANode.Childrens.Find('pAliqEfet'), tcDe4);
end;

procedure TBPeXmlReader.Ler_gIBSMun_gDeson(const ANode: TACBrXmlNode; gDeson: TgDeson);
begin
  if not Assigned(ANode) then Exit;

  gDeson.CST := ObterConteudo(ANode.Childrens.Find('CST'), tcInt);
  gDeson.cClassTrib := ObterConteudo(ANode.Childrens.Find('cClassTrib'), tcInt);
  gDeson.vBC := ObterConteudo(ANode.Childrens.Find('vBC'), tcDe2);
  gDeson.pAliq := ObterConteudo(ANode.Childrens.Find('pAliq'), tcDe4);
  gDeson.vDeson := ObterConteudo(ANode.Childrens.Find('vDeson'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gCBS(const ANode: TACBrXmlNode; gCBS: TgCBSValores);
begin
  if not Assigned(ANode) then Exit;

  gCBS.pCBS := ObterConteudo(ANode.Childrens.Find('pCBS'), tcDe4);
  gCBS.vTribOp := ObterConteudo(ANode.Childrens.Find('vTribOp'), tcDe2);

  Ler_gCBS_gDif(ANode.Childrens.Find('gDif'), gCBS.gDif);
  Ler_gCBS_gDevTrib(ANode.Childrens.Find('gDevTrib'), gCBS.gDevTrib);
  Ler_gCBS_gRed(ANode.Childrens.Find('gRed'), gCBS.gRed);
  Ler_gCBS_gDeson(ANode.Childrens.Find('gDeson'), gCBS.gDeson);

  gCBS.vCBS := ObterConteudo(ANode.Childrens.Find('vCBS'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gCBS_gDif(const ANode: TACBrXmlNode; gDif: TgDif);
begin
  if not Assigned(ANode) then Exit;

  gDif.pDif := ObterConteudo(ANode.Childrens.Find('pDif'), tcDe4);
  gDif.vDif := ObterConteudo(ANode.Childrens.Find('vDif'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gCBS_gDevTrib(const ANode: TACBrXmlNode; gDevTrib: TgDevTrib);
begin
  if not Assigned(ANode) then Exit;

  gDevTrib.vDevTrib := ObterConteudo(ANode.Childrens.Find('vDevTrib'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gCBS_gRed(const ANode: TACBrXmlNode; gRed: TgRed);
begin
  if not Assigned(ANode) then Exit;

  gRed.pRedAliq := ObterConteudo(ANode.Childrens.Find('pRedAliq'), tcDe4);
  gRed.pAliqEfet := ObterConteudo(ANode.Childrens.Find('pAliqEfet'), tcDe4);
end;

procedure TBPeXmlReader.Ler_gCBS_gDeson(const ANode: TACBrXmlNode; gDeson: TgDeson);
begin
  if not Assigned(ANode) then Exit;

  gDeson.CST := ObterConteudo(ANode.Childrens.Find('CST'), tcInt);
  gDeson.cClassTrib := ObterConteudo(ANode.Childrens.Find('cClassTrib'), tcInt);
  gDeson.vBC := ObterConteudo(ANode.Childrens.Find('vBC'), tcDe2);
  gDeson.pAliq := ObterConteudo(ANode.Childrens.Find('pAliq'), tcDe4);
  gDeson.vDeson := ObterConteudo(ANode.Childrens.Find('vDeson'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gIBSCredPres(const ANode: TACBrXmlNode; gIBSCredPres: TgIBSCBSCredPres);
begin
  if not Assigned(ANode) then Exit;

  gIBSCredPres.cCredPres := ObterConteudo(ANode.Childrens.Find('cCredPres'), tcInt);
  gIBSCredPres.pCredPres := ObterConteudo(ANode.Childrens.Find('pCredPres'), tcDe4);
  gIBSCredPres.vCredPres := ObterConteudo(ANode.Childrens.Find('vCredPres'), tcDe2);
  gIBSCredPres.vCredPresCondSus := ObterConteudo(ANode.Childrens.Find('vCredPresCondSus'), tcDe2);
end;

procedure TBPeXmlReader.Ler_gCBSCredPres(const ANode: TACBrXmlNode; gCBSCredPres: TgIBSCBSCredPres);
begin
  if not Assigned(ANode) then Exit;

  gCBSCredPres.cCredPres := ObterConteudo(ANode.Childrens.Find('cCredPres'), tcInt);
  gCBSCredPres.pCredPres := ObterConteudo(ANode.Childrens.Find('pCredPres'), tcDe4);
  gCBSCredPres.vCredPres := ObterConteudo(ANode.Childrens.Find('vCredPres'), tcDe2);
  gCBSCredPres.vCredPresCondSus := ObterConteudo(ANode.Childrens.Find('vCredPresCondSus'), tcDe2);
end;

procedure TBPeXmlReader.Ler_IBSCBSTot(const ANode: TACBrXmlNode;
  IBSCBSTot: TIBSCBSTot);
begin
  if not Assigned(ANode) then Exit;

  Ler_IBSCBSTot_gIBS(ANode.Childrens.Find('gIBS'), IBSCBSTot.gIBS);
  Ler_IBSCBSTot_gCBS(ANode.Childrens.Find('gCBS'), IBSCBSTot.gCBS);
end;

procedure TBPeXmlReader.Ler_IBSCBSTot_gIBS(const ANode: TACBrXmlNode;
  gIBS: TgIBS);
begin
  if not Assigned(ANode) then Exit;

  Ler_IBSCBSTot_gIBS_gIBSUFTot(ANode.Childrens.Find('gIBSUFTot'), gIBS.gIBSUFTot);
  Ler_IBSCBSTot_gIBS_gIBSMunTot(ANode.Childrens.Find('gIBSMunTot'), gIBS.gIBSMunTot);

  gIBS.vCredPres := ObterConteudo(ANode.Childrens.Find('vCredPres'), tcDe2);
  gIBS.vCredPresCondSus := ObterConteudo(ANode.Childrens.Find('vCredPresCondSus'), tcDe2);
  gIBS.vIBSTot := ObterConteudo(ANode.Childrens.Find('vIBSTot'), tcDe2);
end;

procedure TBPeXmlReader.Ler_IBSCBSTot_gIBS_gIBSUFTot(const ANode: TACBrXmlNode;
  gIBSUFTot: TgIBSUFTot);
begin
  if not Assigned(ANode) then Exit;

  gIBSUFTot.vDif := ObterConteudo(ANode.Childrens.Find('vDif'), tcDe2);
  gIBSUFTot.vDevTrib := ObterConteudo(ANode.Childrens.Find('vDevTrib'), tcDe2);
  gIBSUFTot.vDeson := ObterConteudo(ANode.Childrens.Find('vDeson'), tcDe2);
  gIBSUFTot.vIBSUF := ObterConteudo(ANode.Childrens.Find('vIBSUF'), tcDe2);
end;

procedure TBPeXmlReader.Ler_IBSCBSTot_gIBS_gIBSMunTot(const ANode: TACBrXmlNode;
  gIBSMunTot: TgIBSMunTot);
begin
  if not Assigned(ANode) then Exit;

  gIBSMunTot.vDif := ObterConteudo(ANode.Childrens.Find('vDif'), tcDe2);
  gIBSMunTot.vDevTrib := ObterConteudo(ANode.Childrens.Find('vDevTrib'), tcDe2);
  gIBSMunTot.vDeson := ObterConteudo(ANode.Childrens.Find('vDeson'), tcDe2);
  gIBSMunTot.vIBSMun := ObterConteudo(ANode.Childrens.Find('vIBSMun'), tcDe2);
end;

procedure TBPeXmlReader.Ler_IBSCBSTot_gCBS(const ANode: TACBrXmlNode;
  gCBS: TgCBS);
begin
  if not Assigned(ANode) then Exit;

  gCBS.vDif := ObterConteudo(ANode.Childrens.Find('vDif'), tcDe2);
  gCBS.vDevTrib := ObterConteudo(ANode.Childrens.Find('vDevTrib'), tcDe2);
  gCBS.vDeson := ObterConteudo(ANode.Childrens.Find('vDeson'), tcDe2);
  gCBS.vCredPresCondSus := ObterConteudo(ANode.Childrens.Find('vCredPresCondSus'), tcDe2);
  gCBS.vCBS := ObterConteudo(ANode.Childrens.Find('vCBS'), tcDe2);
end;

end.

