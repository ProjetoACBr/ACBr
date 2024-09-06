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

unit ACBrMDFe.RetConsSit;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  pcnConversao,
  pmdfeConsts,
  ACBrBase, ACBrXmlBase,
  ACBrDFeComum.Proc,
  ACBrMDFe.RetEnvEvento,
  pmdfeProcInfraSA;

type

  TRetEventoMDFeCollectionItem = class(TObject)
  private
    FRetEventoMDFe: TRetEventoMDFe;
  public
    constructor Create;
    destructor Destroy; override;
    property RetEventoMDFe: TRetEventoMDFe read FRetEventoMDFe write FRetEventoMDFe;
  end;

  TRetEventoMDFeCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetEventoMDFeCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetEventoMDFeCollectionItem);
  public
    function Add: TRetEventoMDFeCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRetEventoMDFeCollectionItem;
    property Items[Index: Integer]: TRetEventoMDFeCollectionItem read GetItem write SetItem; default;
  end;

  TRetConsSitMDFe = class(TObject)
  private
    Fversao: string;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: string;
    FcStat: Integer;
    FxMotivo: string;
    FcUF: Integer;
    FchMDFe: string;
    FprotMDFe: TProcDFe;
    FprocEventoMDFe: TRetEventoMDFeCollection;
    FXMLprotMDFe: string;
    FprocInfraSA: TProcInfraSA;

    FXmlRetorno: string;
  public
    constructor Create(const Versao: string);
    destructor Destroy; override;

    function LerXml: Boolean;

    property versao: string                           read Fversao         write Fversao;
    property tpAmb: TpcnTipoAmbiente                  read FtpAmb          write FtpAmb;
    property verAplic: string                         read FverAplic       write FverAplic;
    property cStat: Integer                           read FcStat          write FcStat;
    property xMotivo: string                          read FxMotivo        write FxMotivo;
    property cUF: Integer                             read FcUF            write FcUF;
    property chMDFe: string                           read FchMDFe         write FchMDFe;
    property protMDFe: TProcDFe                       read FprotMDFe       write FprotMDFe;
    property procEventoMDFe: TRetEventoMDFeCollection read FprocEventoMDFe write FprocEventoMDFe;
    property XMLprotMDFe: string                      read FXMLprotMDFe    write FXMLprotMDFe;
    property procInfraSA: TProcInfraSA                read FprocInfraSA    write FprocInfraSA;

    property XmlRetorno: string read FXmlRetorno write FXmlRetorno;
  end;

implementation

uses
  ACBrXmlDocument;

{ TRetConsSitMDFe }

constructor TRetConsSitMDFe.Create(const Versao: string);
begin
  inherited Create;

  FprotMDFe := TProcDFe.Create(Versao, NAME_SPACE_MDFE, 'MDFe');
end;

destructor TRetConsSitMDFe.Destroy;
begin
  FprotMDFe.Free;

  if Assigned(procEventoMDFe) then
    procEventoMDFe.Free;

  inherited;
end;

function TRetConsSitMDFe.LerXml: Boolean;
var
  Document: TACBrXmlDocument;
  ANode, ANodeAux, ANodeAux2: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  ok: Boolean;
  i: Integer;
  Item : TRetEventoMDFeCollectionItem;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if XmlRetorno = '' then Exit;

      Document.LoadFromXml(XmlRetorno);

      ANode := Document.Root;

      if ANode <> nil then
      begin
        versao := ObterConteudoTag(ANode.Attributes.Items['versao']);
        verAplic := ObterConteudoTag(ANode.Childrens.FindAnyNs('verAplic'), tcStr);
        tpAmb := StrToTpAmb(ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpAmb'), tcStr));
        cUF := ObterConteudoTag(ANode.Childrens.FindAnyNs('cUF'), tcInt);
        cStat := ObterConteudoTag(ANode.Childrens.FindAnyNs('cStat'), tcInt);
        xMotivo := ObterConteudoTag(ANode.Childrens.FindAnyNs('xMotivo'), tcStr);
        chMDFe := ObterConteudoTag(ANode.Childrens.FindAnyNs('chMDFe'), tcStr);

        case cStat of
          100, 101, 132:
            begin
              ANodeAux := ANode.Childrens.FindAnyNs('protMDFe');

              if ANodeAux <> nil then
              begin
                // A propriedade XMLprotMDFe contem o XML que traz o resultado do
                // processamento da NF-e.
                XMLprotMDFe := ANodeAux.OuterXml;

                ANodeAux2 := ANodeAux.Childrens.FindAnyNs('infProt');

                if ANodeAux2 <> nil then
                begin
                  protMDFe.tpAmb := StrToTipoAmbiente(ok, ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('tpAmb'), tcStr));
                  protMDFe.verAplic := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('verAplic'), tcStr);
                  protMDFe.chDFe := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('chMDFe'), tcStr);
                  protMDFe.dhRecbto := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('dhRecbto'), tcDatHor);
                  protMDFe.nProt := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('nProt'), tcStr);
                  protMDFe.digVal := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('digVal'), tcStr);
                  protMDFe.cStat := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('cStat'), tcInt);
                  protMDFe.xMotivo := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('xMotivo'), tcStr);
                  protMDFe.cMsg := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('cMsg'), tcInt);
                  protMDFe.xMsg := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('xMsg'), tcStr);
                end;

                ANodeAux2 := ANodeAux.Childrens.FindAnyNs('procInfraSA');

                if ANodeAux2 <> nil then
                begin
                  FprocInfraSA.nProtDTe := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('nProtDTe'), tcStr);
                  FprocInfraSA.dhProt := ObterConteudoTag(ANodeAux2.Childrens.FindAnyNs('dhProt'), tcDatHor);
                end;
              end;
            end;
        end;

        if Assigned(procEventoMDFe) then
          procEventoMDFe.Free;

        procEventoMDFe := TRetEventoMDFeCollection.Create;

        try
          ANodeArray := ANode.Childrens.FindAllAnyNs('procEventoMDFe');

          if Assigned(ANodeArray) then
          begin
            for i := Low(ANodeArray) to High(ANodeArray) do
            begin
              AnodeAux := ANodeArray[i];

              Item := procEventoMDFe.New;

              Item.RetEventoMDFe.XmlRetorno := AnodeAux.OuterXml;
              Item.RetEventoMDFe.XML := AnodeAux.OuterXml;
              Item.RetEventoMDFe.LerXml;
            end;
          end;
        finally
          Result := True;
        end;
      end;

      Result := True;
    except
      Result := False;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

{ TRetEventoCollection }

function TRetEventoMDFeCollection.Add: TRetEventoMDFeCollectionItem;
begin
  Result := Self.New;
end;

function TRetEventoMDFeCollection.GetItem(Index: Integer): TRetEventoMDFeCollectionItem;
begin
  Result := TRetEventoMDFeCollectionItem(inherited Items[Index]);
end;

procedure TRetEventoMDFeCollection.SetItem(Index: Integer;
  Value: TRetEventoMDFeCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRetEventoCollectionItem }

constructor TRetEventoMDFeCollectionItem.Create;
begin
  inherited Create;
  FRetEventoMDFe := TRetEventoMDFe.Create;
end;

destructor TRetEventoMDFeCollectionItem.Destroy;
begin
  FRetEventoMDFe.Free;
  inherited;
end;

function TRetEventoMDFeCollection.New: TRetEventoMDFeCollectionItem;
begin
  Result := TRetEventoMDFeCollectionItem.Create;
  Self.Add(Result);
end;

end.

