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

unit ACBrDCe.XmlReader;

interface

uses
  Classes, SysUtils,
  ACBrXmlDocument, ACBrXmlReader,
  ACBrDCe.Classes;

type

  { TDCeXmlReader }
  TDCeXmlReader = class(TACBrXmlReader)
  private
    FDCe: TDCe;

    procedure Ler_InfDCe(const ANode: TACBrXmlNode);
    procedure Ler_Ide(const ANode: TACBrXmlNode);
    procedure Ler_Emit(const ANode: TACBrXmlNode);
    procedure Ler_EmitEnderEmit(const ANode: TACBrXmlNode);
    procedure Ler_Fisco(const ANode: TACBrXmlNode);
    procedure Ler_Marketplace(const ANode: TACBrXmlNode);
    procedure Ler_Transportadora(const ANode: TACBrXmlNode);
    procedure Ler_EmpEmisProp(const ANode: TACBrXmlNode);
    procedure Ler_Dest(const ANode: TACBrXmlNode);
    procedure Ler_DestEnderDest(const ANode: TACBrXmlNode);
    procedure Ler_Det(const ANode: TACBrXmlNode);
    procedure Ler_DetProd(const Item: TDetCollectionItem; const ANode: TACBrXmlNode);
    procedure Ler_Total(const ANode: TACBrXmlNode);
    procedure Ler_Transp(const ANode: TACBrXmlNode);
    procedure Ler_InfAdic(const ANode: TACBrXmlNode);
    procedure Ler_InfDec(const ANode: TACBrXmlNode);
    procedure Ler_InfSolicDCe(const ANode: TACBrXmlNode);

    procedure Ler_ProtDCe(const ANode: TACBrXmlNode);
    procedure Ler_InfDCeSupl(const ANode: TACBrXmlNode);
  public
    constructor Create(AOwner: TDCe); reintroduce;

    function LerXml: Boolean; override;

    property DCe: TDCe read FDCe write FDCe;

  end;

implementation

uses
  ACBrUtil.Base,
  ACBrXmlBase, ACBrDCe.Conversao;

{ TDCeXmlReader }

constructor TDCeXmlReader.Create(AOwner: TDCe);
begin
  inherited Create;

  FDCe := AOwner;
end;

procedure TDCeXmlReader.Ler_Dest(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.dest.CNPJCPF := ObterCNPJCPF(ANode);

  if DCe.dest.CNPJCPF = '' then
    DCe.dest.idOutros := ObterConteudo(ANode.Childrens.Find('idOutros'), tcStr);

  DCe.dest.xNome := ObterConteudo(ANode.Childrens.Find('xNome'), tcStr);

  Ler_DestEnderDest(ANode.Childrens.Find('enderDest'));
end;

procedure TDCeXmlReader.Ler_DestEnderDest(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.dest.enderDest.xLgr := ObterConteudo(ANode.Childrens.Find('xLgr'), tcStr);
  DCe.dest.enderDest.nro := ObterConteudo(ANode.Childrens.Find('nro'), tcStr);
  DCe.dest.enderDest.xCpl := ObterConteudo(ANode.Childrens.Find('xCpl'), tcStr);
  DCe.dest.enderDest.xBairro := ObterConteudo(ANode.Childrens.Find('xBairro'), tcStr);
  DCe.dest.enderDest.cMun := ObterConteudo(ANode.Childrens.Find('cMun'), tcInt);
  DCe.dest.enderDest.xMun := ObterConteudo(ANode.Childrens.Find('xMun'), tcStr);
  DCe.dest.enderDest.UF := ObterConteudo(ANode.Childrens.Find('UF'), tcStr);
  DCe.dest.enderDest.CEP := ObterConteudo(ANode.Childrens.Find('CEP'), tcInt);
  DCe.dest.enderDest.cPais := ObterConteudo(ANode.Childrens.Find('cPais'), tcInt);

  if DCe.dest.enderDest.cPais = 0 then
    DCe.dest.enderDest.cPais := 1058;

  DCe.dest.enderDest.xPais := ObterConteudo(ANode.Childrens.Find('xPais'), tcStr);

  if DCe.dest.enderDest.xPais = '' then
    DCe.dest.enderDest.xPais := 'BRASIL';

  DCe.dest.enderDest.fone := ObterConteudo(ANode.Childrens.Find('fone'), tcStr);
  DCe.dest.enderDest.email := ObterConteudo(ANode.Childrens.Find('email'), tcStr);
end;

procedure TDCeXmlReader.Ler_Det(const ANode: TACBrXmlNode);
var
  Item: TDetCollectionItem;
begin
  if not Assigned(ANode) then Exit;

  Item := DCe.Det.New;
  Item.prod.nItem := DCe.Det.Count;
  Item.infAdProd := ObterConteudo(ANode.Childrens.Find('infAdProd'), tcStr);

  Ler_DetProd(Item, ANode.Childrens.Find('prod'));
end;

procedure TDCeXmlReader.Ler_DetProd(const Item: TDetCollectionItem;
  const ANode: TACBrXmlNode);
begin
  if not Assigned(Item) then Exit;
  if not Assigned(ANode) then Exit;

  Item.Prod.xProd := ObterConteudo(ANode.Childrens.Find('xProd'), tcStr);
  Item.Prod.NCM := ObterConteudo(ANode.Childrens.Find('NCM'), tcStr);
  Item.Prod.qCom := ObterConteudo(ANode.Childrens.Find('qCom'), tcDe4);
  Item.Prod.vUnCom := ObterConteudo(ANode.Childrens.Find('vUnCom'), tcDe8);
  Item.Prod.vProd := ObterConteudo(ANode.Childrens.Find('vProd'), tcDe2);
end;

procedure TDCeXmlReader.Ler_Emit(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.emit.CNPJCPF := ObterCNPJCPF(ANode);

  if DCe.emit.CNPJCPF = '' then
    DCe.emit.idOutros := ObterConteudo(ANode.Childrens.Find('idOutros'), tcStr);

  DCe.emit.xNome := ObterConteudo(ANode.Childrens.Find('xNome'), tcStr);

  Ler_EmitEnderEmit(ANode.Childrens.Find('enderEmit'));
end;

procedure TDCeXmlReader.Ler_EmitEnderEmit(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.Emit.enderEmit.xLgr := ObterConteudo(ANode.Childrens.Find('xLgr'), tcStr);
  DCe.Emit.enderEmit.nro := ObterConteudo(ANode.Childrens.Find('nro'), tcStr);
  DCe.Emit.enderEmit.xCpl := ObterConteudo(ANode.Childrens.Find('xCpl'), tcStr);
  DCe.Emit.enderEmit.xBairro := ObterConteudo(ANode.Childrens.Find('xBairro'), tcStr);
  DCe.Emit.EnderEmit.cMun := ObterConteudo(ANode.Childrens.Find('cMun'), tcInt);
  DCe.Emit.enderEmit.xMun := ObterConteudo(ANode.Childrens.Find('xMun'), tcStr);
  DCe.Emit.enderEmit.UF := ObterConteudo(ANode.Childrens.Find('UF'), tcStr);
  DCe.Emit.enderEmit.CEP := ObterConteudo(ANode.Childrens.Find('CEP'), tcInt);
  DCe.Emit.enderEmit.cPais := ObterConteudo(ANode.Childrens.Find('cPais'), tcInt);

  if DCe.Emit.enderEmit.cPais = 0 then
    DCe.Emit.enderEmit.cPais := 1058;

  DCe.Emit.enderEmit.xPais := ObterConteudo(ANode.Childrens.Find('xPais'), tcStr);

  if DCe.Emit.enderEmit.xPais = '' then
    DCe.Emit.enderEmit.xPais := 'BRASIL';

  DCe.Emit.enderEmit.fone := ObterConteudo(ANode.Childrens.Find('fone'), tcStr);
end;

procedure TDCeXmlReader.Ler_EmpEmisProp(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.EmpEmisProp.CNPJ := ObterConteudo(ANode.Childrens.Find('CNPJ'), tcStr);
  DCe.EmpEmisProp.xNome := ObterConteudo(ANode.Childrens.Find('xNome'), tcStr);
end;

procedure TDCeXmlReader.Ler_Fisco(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.Fisco.CNPJ := ObterConteudo(ANode.Childrens.Find('CNPJ'), tcStr);
  DCe.Fisco.xOrgao := ObterConteudo(ANode.Childrens.Find('xOrgao'), tcStr);
  DCe.Fisco.UF := ObterConteudo(ANode.Childrens.Find('UF'), tcStr);
end;

procedure TDCeXmlReader.Ler_Ide(const ANode: TACBrXmlNode);
var
  ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  DCe.ide.cUF := ObterConteudo(ANode.Childrens.Find('cUF'), tcInt);
  DCe.ide.cDC := ObterConteudo(ANode.Childrens.Find('cDC'), tcInt);
  DCe.ide.modelo := ObterConteudo(ANode.Childrens.Find('mod'), tcInt);
  DCe.ide.serie := ObterConteudo(ANode.Childrens.Find('serie'), tcInt);
  DCe.ide.nDC := ObterConteudo(ANode.Childrens.Find('nDC'), tcInt);
  DCe.ide.dhEmi := ObterConteudo(ANode.Childrens.Find('dhEmi'), tcDatHor);
  DCe.Ide.tpEmis := StrToTipoEmissao(ok, ObterConteudo(ANode.Childrens.Find('tpEmis'), tcStr));
  DCe.Ide.tpEmit := StrToEmitenteDCe(ObterConteudo(ANode.Childrens.Find('tpEmit'), tcStr));
  DCe.ide.nSiteAutoriz := ObterConteudo(ANode.Childrens.Find('nSiteAutoriz'), tcInt);
  DCe.ide.cDV := ObterConteudo(ANode.Childrens.Find('cDV'), tcInt);
  DCe.Ide.tpAmb := StrToTipoAmbiente(ok, ObterConteudo(ANode.Childrens.Find('tpAmb'), tcStr));
  DCe.Ide.verProc := ObterConteudo(ANode.Childrens.Find('verProc'), tcStr);
end;

procedure TDCeXmlReader.Ler_InfAdic(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.InfAdic.infAdFisco := ObterConteudo(ANode.Childrens.Find('infAdFisco'), tcStr);
  DCe.InfAdic.infCpl := ObterConteudo(ANode.Childrens.Find('infCpl'), tcStr);
  DCe.InfAdic.infAdMarketplace := ObterConteudo(ANode.Childrens.Find('infAdMarketplace'), tcStr);
  DCe.InfAdic.infAdTransp := ObterConteudo(ANode.Childrens.Find('infAdTransp'), tcStr);
end;

procedure TDCeXmlReader.Ler_InfDCe(const ANode: TACBrXmlNode);
var
  i: Integer;
  ANodes: TACBrXmlNodeArray;
begin
  if not Assigned(ANode) then Exit;

  Ler_Ide(ANode.Childrens.Find('ide'));
  Ler_Emit(ANode.Childrens.Find('emit'));
  Ler_Fisco(ANode.Childrens.Find('Fisco'));
  Ler_Marketplace(ANode.Childrens.Find('Marketplace'));
  Ler_Transportadora(ANode.Childrens.Find('Transportadora'));
  Ler_EmpEmisProp(ANode.Childrens.Find('EmpEmisProp'));
  Ler_Dest(ANode.Childrens.Find('dest'));

  ANodes := ANode.Childrens.FindAll('autXML');
  for i := 0 to Length(ANodes) - 1 do
  begin
    DCe.autXML.New;
    DCe.autXML[i].CNPJCPF := ObterCNPJCPF(ANodes[i]);
  end;

  ANodes := ANode.Childrens.FindAll('det');
  for i := 0 to Length(ANodes) - 1 do
  begin
    Ler_Det(ANodes[i]);
  end;

  Ler_Total(ANode.Childrens.Find('total'));
  Ler_Transp(ANode.Childrens.Find('transp'));
  Ler_InfAdic(ANode.Childrens.Find('infAdic'));

  DCe.obsCont.Clear;
  ANodes := ANode.Childrens.FindAll('obsCont');
  for i := 0 to Length(ANodes) - 1 do
  begin
    DCe.obsCont.New;
    DCe.obsCont[i].xCampo := ANodes[i].Attributes.Items['xCampo'].Content;
    DCe.obsCont[i].xTexto := ObterConteudo(ANodes[i].Childrens.Find('xTexto'), tcStr);
  end;

  DCe.obsMarketplace.Clear;
  ANodes := ANode.Childrens.FindAll('obsMarketplace');
  for i := 0 to Length(ANodes) - 1 do
  begin
    DCe.obsMarketplace.New;
    DCe.obsMarketplace[i].xCampo := ANodes[i].Attributes.Items['xCampo'].Content;
    DCe.obsMarketplace[i].xTexto := ObterConteudo(ANodes[i].Childrens.Find('xTexto'), tcStr);
  end;

  Ler_InfDec(ANode.Childrens.Find('infDec'));
  Ler_InfSolicDCe(ANode.Childrens.Find('infSolicDCe'));
end;

procedure TDCeXmlReader.Ler_InfDCeSupl(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.infDCeSupl.qrCode := ObterConteudo(ANode.Childrens.Find('qrCodDCe'), tcStr);
  DCe.infDCeSupl.qrCode := StringReplace(DCe.infDCeSupl.qrCode, '<![CDATA[', '', []);
  DCe.infDCeSupl.qrCode := StringReplace(DCe.infDCeSupl.qrCode, ']]>', '', []);
  DCe.infDCeSupl.urlChave := ObterConteudo(ANode.Childrens.Find('urlChave'), tcStr);
end;

procedure TDCeXmlReader.Ler_InfDec(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.infDec.xObs1 := ObterConteudo(ANode.Childrens.Find('xObs1'), tcStr);
  DCe.infDec.xObs2 := ObterConteudo(ANode.Childrens.Find('xObs2'), tcStr);
end;

procedure TDCeXmlReader.Ler_InfSolicDCe(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.infSolicDCe.xSolic := ObterConteudo(ANode.Childrens.Find('xSolic'), tcStr);
end;

procedure TDCeXmlReader.Ler_Marketplace(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.Marketplace.CNPJ := ObterConteudo(ANode.Childrens.Find('CNPJ'), tcStr);
  DCe.Marketplace.xNome := ObterConteudo(ANode.Childrens.Find('xNome'), tcStr);
  DCe.Marketplace.Site := ObterConteudo(ANode.Childrens.Find('Site'), tcStr);
end;

procedure TDCeXmlReader.Ler_ProtDCe(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.Find('infProt');

  if not Assigned(AuxNode) then Exit;

  DCe.procDCe.tpAmb    := StrToTipoAmbiente(ok, ObterConteudo(AuxNode.Childrens.Find('tpAmb'), tcStr));
  DCe.procDCe.verAplic := ObterConteudo(AuxNode.Childrens.Find('verAplic'), tcStr);
  DCe.procDCe.chDFe    := ObterConteudo(AuxNode.Childrens.Find('chDCe'), tcStr);
  DCe.procDCe.dhRecbto := ObterConteudo(AuxNode.Childrens.Find('dhRecbto'), tcDatHor);
  DCe.procDCe.nProt    := ObterConteudo(AuxNode.Childrens.Find('nProt'), tcStr);
  DCe.procDCe.digVal   := ObterConteudo(AuxNode.Childrens.Find('digVal'), tcStr);
  DCe.procDCe.cStat    := ObterConteudo(AuxNode.Childrens.Find('cStat'), tcInt);
  DCe.procDCe.xMotivo  := ObterConteudo(AuxNode.Childrens.Find('xMotivo'), tcStr);
  DCe.procDCe.cMsg     := ObterConteudo(AuxNode.Childrens.Find('cMsg'), tcInt);
  DCe.procDCe.xMsg     := ObterConteudo(AuxNode.Childrens.Find('xMsg'), tcStr);
end;

procedure TDCeXmlReader.Ler_Total(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.Total.vDC := ObterConteudo(ANode.Childrens.Find('vDC'), tcDe2);
end;

procedure TDCeXmlReader.Ler_Transp(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then Exit;

  DCe.Transp.modTrans := StrToModTrans(ObterConteudo(ANode.Childrens.Find('modTrans'), tcStr));
  DCe.Transp.CNPJTrans := ObterConteudo(ANode.Childrens.Find('CNPJTrans'), tcStr);
end;

procedure TDCeXmlReader.Ler_Transportadora(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode)  then Exit;

  DCe.Transportadora.CNPJ := ObterConteudo(ANode.Childrens.Find('CNPJ'), tcStr);
  DCe.Transportadora.xNome := ObterConteudo(ANode.Childrens.Find('xNome'), tcStr);
end;

function TDCeXmlReader.LerXml: Boolean;
var
  DCeNode, infDCeNode: TACBrXmlNode;
  att: TACBrXmlAttribute;
begin
  Result := False;

  if not Assigned(FDCe) then
    raise Exception.Create('Destino n�o informado, informe a classe [TDCe] de destino.');

  if EstaVazio(Arquivo) then
    raise Exception.Create('Arquivo xml da DCe n�o carregado.');

  infDCeNode := nil;
  Document.Clear();
  Document.LoadFromXml(Arquivo);

  if Document.Root.Name = 'dceProc' then
  begin
    Ler_ProtDCe(Document.Root.Childrens.Find('protDCe'));
    DCeNode := Document.Root.Childrens.Find('DCe');
  end
  else
  begin
    DCeNode := Document.Root;
  end;

  if DCeNode <> nil then
      infDCeNode := DCeNode.Childrens.Find('infDCe');

  if infDCeNode = nil then
    raise Exception.Create('Arquivo xml incorreto.');

  att := infDCeNode.Attributes.Items['Id'];
  if att = nil then
    raise Exception.Create('N�o encontrei o atributo: Id');

  DCe.infDCe.Id := att.Content;

  att := infDCeNode.Attributes.Items['versao'];
  if att = nil then
    raise Exception.Create('N�o encontrei o atributo: versao');

  DCe.infDCe.Versao := StringToFloat(att.Content);

  Ler_InfDCe(infDCeNode);
  Ler_InfDCeSupl(DCeNode.Childrens.Find('infDCeSupl'));
  LerSignature(DCeNode.Childrens.Find('Signature'), DCe.signature);

  Result := True;
end;

end.

