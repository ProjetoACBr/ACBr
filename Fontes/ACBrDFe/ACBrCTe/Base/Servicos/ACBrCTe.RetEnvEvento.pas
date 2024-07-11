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

unit ACBrCTe.RetEnvEvento;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  pcnConversao,
  pcnSignature,
  ACBrCTe.EventoClass,
  ACBrBase,
  ACBrXmlBase,
  ACBrXmlDocument;

type
  TRetInfeventoCollectionItem = class(TObject)
  private
    FRetInfEvento: TRetInfEvento;
  public
    constructor Create;
    destructor Destroy; override;
    property RetInfEvento: TRetInfEvento read FRetInfEvento write FRetInfEvento;
  end;

  TRetInfEventoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetInfEventoCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetInfEventoCollectionItem);
  public
    function Add: TRetInfEventoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRetInfEventoCollectionItem;
    property Items[Index: Integer]: TRetInfEventoCollectionItem read GetItem write SetItem; default;
  end;

  TRetEventoCTe = class(TObject)
  private
    FidLote: Int64;
    Fversao: string;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: string;
    FcStat: Integer;
    FcOrgao: Integer;
    FxMotivo: string;
    FretEvento: TRetInfEventoCollection;
    FInfEvento: TInfEvento;
    Fsignature: Tsignature;
    FXML: AnsiString;
    FXmlRetorno: string;

  protected
    procedure Ler_InfEventos(const ANode: TACBrXmlNode);
//    procedure Ler_RetEvento(const ANode: TACBrXmlNode);
    procedure Ler_InfEvento(const ANode: TACBrXmlNode);
    procedure Ler_DetEvento(const ANode: TACBrXmlNode);
    procedure Ler_InfCorrecao(const ANode: TACBrXmlNode);
    procedure Ler_InfGTV(const ANode: TACBrXmlNode);
    procedure Ler_InfEspecie(const ANode: TACBrXmlNode; Idx: Integer);
    procedure Ler_Remetente(const ANode: TACBrXmlNode; Idx: Integer);
    procedure Ler_Destinatario(const ANode: TACBrXmlNode; Idx: Integer);
    procedure Ler_InfEntrega(const ANode: TACBrXmlNode);
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;

    property idLote: Int64                      read FidLote    write FidLote;
    property versao: string                     read Fversao    write Fversao;
    property tpAmb: TpcnTipoAmbiente            read FtpAmb     write FtpAmb;
    property verAplic: string                   read FverAplic  write FverAplic;
    property cOrgao: Integer                    read FcOrgao    write FcOrgao;
    property cStat: Integer                     read FcStat     write FcStat;
    property xMotivo: string                    read FxMotivo   write FxMotivo;
    property InfEvento: TInfEvento              read FInfEvento write FInfEvento;
    property signature: Tsignature              read Fsignature write Fsignature;
    property retEvento: TRetInfEventoCollection read FretEvento write FretEvento;
    property XML: AnsiString                    read FXML       write FXML;

    property XmlRetorno: string read FXmlRetorno write FXmlRetorno;
  end;


implementation

uses
  pcteConversaoCTe,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML;

{ TRetInfEventoCollection }

function TRetInfEventoCollection.Add: TRetInfEventoCollectionItem;
begin
  Result := Self.New;
end;

function TRetInfEventoCollection.GetItem(Index: Integer): TRetInfEventoCollectionItem;
begin
  Result := TRetInfEventoCollectionItem(inherited Items[Index]);
end;

procedure TRetInfEventoCollection.SetItem(Index: Integer;
  Value: TRetInfEventoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TRetInfEventoCollection.New: TRetInfEventoCollectionItem;
begin
  Result := TRetInfEventoCollectionItem.Create;
  Self.Add(Result);
end;

{ TRetInfEventoCollectionItem }

constructor TRetInfEventoCollectionItem.Create;
begin
  inherited Create;
  FRetInfEvento := TRetInfEvento.Create;
end;

destructor TRetInfEventoCollectionItem.Destroy;
begin
  FRetInfEvento.Free;
  inherited;
end;

{ TRetEventoCTe }

constructor TRetEventoCTe.Create;
begin
  inherited Create;

  FretEvento := TRetInfEventoCollection.Create;
  FInfEvento := TInfEvento.Create;
  Fsignature := Tsignature.Create;
end;

destructor TRetEventoCTe.Destroy;
begin
  FretEvento.Free;
  FInfEvento.Free;
  Fsignature.Free;

  inherited;
end;

procedure TRetEventoCTe.Ler_InfCorrecao(const ANode: TACBrXmlNode);
var
  Item: TinfCorrecaoCollectionItem;
begin
  if not Assigned(ANode) then Exit;

  Item := InfEvento.detEvento.infCorrecao.New;

  Item.grupoAlterado := ObterConteudoTag(ANode.Childrens.FindAnyNs('grupoAlterado'), tcStr);
  Item.campoAlterado := ObterConteudoTag(ANode.Childrens.FindAnyNs('campoAlterado'), tcStr);
  Item.valorAlterado := ObterConteudoTag(ANode.Childrens.FindAnyNs('valorAlterado'), tcStr);
  Item.nroItemAlterado := ObterConteudoTag(ANode.Childrens.FindAnyNs('nroItemAlterado'), tcInt);
end;

procedure TRetEventoCTe.Ler_InfGTV(const ANode: TACBrXmlNode);
var
  Item: TInfGTVCollectionItem;
  ANodes: TACBrXmlNodeArray;
  i, j: Integer;
begin
  if not Assigned(ANode) then Exit;

  Item := InfEvento.detEvento.infGTV.New;

  j := InfEvento.detEvento.infGTV.Count -1;

  Item.nDoc := ObterConteudoTag(ANode.Childrens.FindAnyNs('nDoc'), tcStr);
  Item.id := ObterConteudoTag(ANode.Childrens.FindAnyNs('id'), tcStr);
  Item.serie := ObterConteudoTag(ANode.Childrens.FindAnyNs('serie'), tcStr);
  Item.subserie := ObterConteudoTag(ANode.Childrens.FindAnyNs('subserie'), tcStr);
  Item.dEmi := ObterConteudoTag(ANode.Childrens.FindAnyNs('dEmi'), tcDat);
  Item.nDV := ObterConteudoTag(ANode.Childrens.FindAnyNs('nDV'), tcInt);
  Item.qCarga := ObterConteudoTag(ANode.Childrens.FindAnyNs('qCarga'), tcDe4);
  Item.placa := ObterConteudoTag(ANode.Childrens.FindAnyNs('placa'), tcStr);
  Item.UF := ObterConteudoTag(ANode.Childrens.FindAnyNs('UF'), tcStr);
  Item.RNTRC := ObterConteudoTag(ANode.Childrens.FindAnyNs('RNTRC'), tcStr);

  ANodes := ANode.Childrens.FindAll('infEspecie');
  for i := 0 to Length(ANodes) - 1 do
  begin
    Ler_InfEspecie(ANodes[i], j);
  end;

  Ler_Remetente(ANode.Childrens.FindAnyNs('rem'), j);

  Ler_Destinatario(ANode.Childrens.FindAnyNs('dest'), j);
end;

procedure TRetEventoCTe.Ler_InfEspecie(const ANode: TACBrXmlNode; Idx: Integer);
var
  Item: TInfEspecieCollectionItem;
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  Item := InfEvento.detEvento.infGTV[Idx].infEspecie.New;

  Item.tpEspecie := StrToTEspecie(Ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpEspecie'), tcStr));
  Item.vEspecie := ObterConteudoTag(ANode.Childrens.FindAnyNs('vEspecie'), tcDe2);
end;

procedure TRetEventoCTe.Ler_Remetente(const ANode: TACBrXmlNode; Idx: Integer);
var
  Item: TInfRemDest;
begin
  if not Assigned(ANode) then Exit;

  Item := InfEvento.detEvento.infGTV[Idx].rem;

  Item.CNPJCPF := ObterConteudoTagCNPJCPF(ANode);
  Item.IE := ObterConteudoTag(ANode.Childrens.FindAnyNs('IE'), tcStr);
  Item.UF := ObterConteudoTag(ANode.Childrens.FindAnyNs('UF'), tcStr);
  Item.xNome := ObterConteudoTag(ANode.Childrens.FindAnyNs('xNome'), tcStr);
end;

procedure TRetEventoCTe.Ler_Destinatario(const ANode: TACBrXmlNode;
  Idx: Integer);
var
  Item: TInfRemDest;
begin
  if not Assigned(ANode) then Exit;

  Item := InfEvento.detEvento.infGTV[Idx].dest;

  Item.CNPJCPF := ObterConteudoTagCNPJCPF(ANode);
  Item.IE := ObterConteudoTag(ANode.Childrens.FindAnyNs('IE'), tcStr);
  Item.UF := ObterConteudoTag(ANode.Childrens.FindAnyNs('UF'), tcStr);
  Item.xNome := ObterConteudoTag(ANode.Childrens.FindAnyNs('xNome'), tcStr);
end;

procedure TRetEventoCTe.Ler_InfEntrega(const ANode: TACBrXmlNode);
var
  Item: TInfEntregaCollectionItem;
begin
  if not Assigned(ANode) then Exit;

  Item := InfEvento.detEvento.infEntrega.New;

  Item.chNFe := ObterConteudoTag(ANode.Childrens.FindAnyNs('chNFe'), tcStr);
end;

procedure TRetEventoCTe.Ler_DetEvento(const ANode: TACBrXmlNode);
var
  ok: Boolean;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  infEvento.VersaoEvento := ObterConteudoTag(ANode.Attributes.Items['versaoEvento']);

  case InfEvento.tpEvento of
    teCCe: AuxNode := ANode.Childrens.FindAnyNs('evCCeCTe');

    teCancelamento: AuxNode := ANode.Childrens.FindAnyNs('evCancCTe');

    teEPEC: AuxNode := ANode.Childrens.FindAnyNs('evEPECCTe');

    teMultiModal: AuxNode := ANode.Childrens.FindAnyNs('evRegMultimodal');

    tePrestDesacordo: AuxNode := ANode.Childrens.FindAnyNs('evPrestDesacordo');

    teCancPrestDesacordo: AuxNode := ANode.Childrens.FindAnyNs('evCancPrestDesacordo');

    teGTV: AuxNode := ANode.Childrens.FindAnyNs('evGTV');

    teComprEntrega: AuxNode := ANode.Childrens.FindAnyNs('evCECTe');

    teCancComprEntrega: AuxNode := ANode.Childrens.FindAnyNs('evCancCECTe');

    teInsucessoEntregaCTe: AuxNode := ANode.Childrens.FindAnyNs('evIECTe');

    teCancInsucessoEntregaCTe: AuxNode := ANode.Childrens.FindAnyNs('evCancIECTe');
  else
    AuxNode := nil;
  end;

  if AuxNode <> nil then
  begin
    infEvento.DetEvento.descEvento := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('descEvento'), tcStr);
    infEvento.DetEvento.nProt := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nProt'), tcStr);
    infEvento.DetEvento.xJust := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('xJust'), tcStr);
    infEvento.DetEvento.vICMS := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('vICMS'), tcDe2);
    infEvento.DetEvento.vICMSST := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('vICMSST'), tcDe2);
    infEvento.DetEvento.vTPrest := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('vTPrest'), tcDe2);
    infEvento.DetEvento.vCarga := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('vCarga'), tcDe2);
    infEvento.detEvento.toma := StrToTpTomador(ok, ObterConteudoTag(AuxNode.Childrens.FindAnyNs('toma'), tcStr));
    infEvento.detEvento.UF := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('UF'), tcStr);
    infEvento.detEvento.CNPJCPF := ObterConteudoTagCNPJCPF(AuxNode);
    infEvento.detEvento.IE := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('IE'), tcStr);
    infEvento.detEvento.modal := StrToTpModal(ok, ObterConteudoTag(AuxNode.Childrens.FindAnyNs('modal'), tcStr));
    infEvento.DetEvento.UFIni := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('UFIni'), tcStr);
    infEvento.DetEvento.UFFim := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('UFFim'), tcStr);
    infEvento.DetEvento.xOBS := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('xOBS'), tcStr);
    // Comprovante de Entrega da CT-e e o Cancelamento do Comprovante
    infEvento.detEvento.dhEntrega := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhEntrega'), tcDatHor);
    infEvento.detEvento.nDoc := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nDoc'), tcStr);
    infEvento.detEvento.xNome := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('xNome'), tcStr);
    infEvento.detEvento.latitude := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('latitude'), tcDe6);
    infEvento.detEvento.longitude := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('longitude'), tcDe6);
    infEvento.detEvento.hashEntrega := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('hashEntrega'), tcStr);
    infEvento.detEvento.dhHashEntrega := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhHashEntrega'), tcDatHor);
    infEvento.detEvento.nProtCE := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nProtCE'), tcStr);

    infEvento.detEvento.dhTentativaEntrega := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhTentativaEntrega'), tcDatHor);
    infEvento.detEvento.nTentativa := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nTentativa'), tcInt);
    infEvento.detEvento.tpMotivo := StrTotpMotivo(ok, ObterConteudoTag(AuxNode.Childrens.FindAnyNs('tpMotivo'), tcStr));
    infEvento.detEvento.xJustMotivo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('xJustMotivo'), tcStr);
    infEvento.detEvento.hashTentativaEntrega := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('hashTentativaEntrega'), tcStr);
    infEvento.detEvento.dhHashTentativaEntrega := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhHashTentativaEntrega'), tcDatHor);

    infEvento.detEvento.nProtIE := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nProtIE'), tcStr);

    ANodes := AuxNode.Childrens.FindAll('infCorrecao');
    for i := 0 to Length(ANodes) - 1 do
    begin
      Ler_InfCorrecao(ANodes[i]);
    end;

    ANodes := AuxNode.Childrens.FindAll('infGTV');
    for i := 0 to Length(ANodes) - 1 do
    begin
      Ler_InfGTV(ANodes[i]);
    end;

    ANodes := AuxNode.Childrens.FindAll('infEntrega');
    for i := 0 to Length(ANodes) - 1 do
    begin
      Ler_InfEntrega(ANodes[i]);
    end;
  end;
end;

procedure TRetEventoCTe.Ler_InfEvento(const ANode: TACBrXmlNode);
var
  ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  infEvento.Id := ObterConteudoTag(ANode.Attributes.Items['Id']);
  infEvento.tpAmb := StrToTpAmb(ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpAmb'), tcStr));
  infEvento.cOrgao := ObterConteudoTag(ANode.Childrens.FindAnyNs('cOrgao'), tcInt);
  infEvento.CNPJ := ObterConteudoTagCNPJCPF(ANode);
  infEvento.chCTe := ObterConteudoTag(ANode.Childrens.FindAnyNs('chCTe'), tcStr);
  infEvento.dhEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhEvento'), tcDatHor);
  infEvento.tpEvento := StrToTpEventoCTe(ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpEvento'), tcStr));
  infEvento.nSeqEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('nSeqEvento'), tcInt);

  Ler_DetEvento(ANode.Childrens.FindAnyNs('detEvento'));
end;

procedure TRetEventoCTe.Ler_InfEventos(const ANode: TACBrXmlNode);
var
  Item: TRetInfEventoCollectionItem;
  ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  Item := retEvento.New;

  Item.RetInfEvento.XML := ANode.OuterXml;

  Item.RetInfEvento.Id := ObterConteudoTag(ANode.Attributes.Items['Id']);
  Item.RetInfEvento.tpAmb := StrToTpAmb(ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpAmb'), tcStr));
  Item.RetInfEvento.verAplic := ObterConteudoTag(ANode.Childrens.FindAnyNs('verAplic'), tcStr);
  Item.RetInfEvento.cOrgao := ObterConteudoTag(ANode.Childrens.FindAnyNs('cOrgao'), tcInt);
  Item.RetInfEvento.cStat := ObterConteudoTag(ANode.Childrens.FindAnyNs('cStat'), tcInt);
  Item.RetInfEvento.xMotivo := ObterConteudoTag(ANode.Childrens.FindAnyNs('xMotivo'), tcStr);

  // Os campos abaixos seram retornados caso o cStat = 134 ou 135 ou 136
  Item.RetInfEvento.chCTe := ObterConteudoTag(ANode.Childrens.FindAnyNs('chCTe'), tcStr);
  Item.RetInfEvento.tpEvento := StrToTpEventoCTe(ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpEvento'), tcStr));
  Item.RetInfEvento.xEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('xEvento'), tcStr);
  Item.RetInfEvento.nSeqEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('nSeqEvento'), tcInt);
  Item.RetInfEvento.CNPJDest := ObterConteudoTag(ANode.Childrens.FindAnyNs('CNPJDest'), tcStr);
  Item.RetInfEvento.dhRegEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhRegEvento'), tcDatHor);
  Item.RetInfEvento.nProt := ObterConteudoTag(ANode.Childrens.FindAnyNs('nProt'), tcStr);

  tpAmb := Item.RetInfEvento.tpAmb;
  cStat := Item.RetInfEvento.cStat;
  xMotivo := Item.RetInfEvento.xMotivo;
end;
{
procedure TRetEventoCTe.Ler_RetEvento(const ANode: TACBrXmlNode);
var
  ok: Boolean;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  if not Assigned(ANode) then Exit;

  versao := ObterConteudoTag(ANode.Attributes.Items['versao']);
  idLote := ObterConteudoTag(ANode.Childrens.FindAnyNs('idLote'), tcInt64);
  tpAmb := StrToTpAmb(ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpAmb'), tcStr));
  verAplic := ObterConteudoTag(ANode.Childrens.FindAnyNs('verAplic'), tcStr);
  cOrgao := ObterConteudoTag(ANode.Childrens.FindAnyNs('cOrgao'), tcInt);
  cStat := ObterConteudoTag(ANode.Childrens.FindAnyNs('cStat'), tcInt);
  xMotivo := ObterConteudoTag(ANode.Childrens.FindAnyNs('xMotivo'), tcStr);

  ANodes := ANode.Childrens.FindAll('retEvento');
  for i := 0 to Length(ANodes) - 1 do
  begin
    Ler_InfEventos(ANodes[i].Childrens.FindAnyNs('infEvento'));
  end;
end;
}
function TRetEventoCTe.LerXml: Boolean;
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if XmlRetorno = '' then Exit;

      Document.LoadFromXml(XmlRetorno);

      ANode := Document.Root;

      if ANode <> nil then
      begin
        if (ANode.LocalName = 'procEventoCTe') then
        begin
          versao := ObterConteudoTag(ANode.Attributes.Items['versao']);

          AuxNode := ANode.Childrens.FindAnyNs('retEnvEvento');

          if AuxNode = nil then
            AuxNode := ANode.Childrens.FindAnyNs('retEventoCTe');

          if AuxNode = nil then
            AuxNode := ANode.Childrens.FindAnyNs('retEvento');

          ANodes := AuxNode.Childrens.FindAllAnyNs('infEvento');
          for i := 0 to Length(ANodes) - 1 do
          begin
            Ler_InfEventos(ANodes[i]);
          end;
        end;

        if (ANode.LocalName = 'eventoCTe') or (ANode.LocalName = 'evento') then
          Ler_InfEvento(ANode.Childrens.FindAnyNs('infEvento'));

        LerSignature(ANode.Childrens.FindAnyNs('Signature'), signature);
      end;

      Result := True;
    except
      Result := False;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

end.
