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

unit ACBrBPeRetConsSit;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase, ACBrXmlBase,
  ACBrDFeComum.Proc,
  ACBrBPeRetEnvEvento;

type

  TRetEventoBPeCollectionItem = class(TObject)
  private
    FRetEventoBPe: TRetEventoBPe;
  public
    constructor Create;
    destructor Destroy; override;
    property RetEventoBPe: TRetEventoBPe read FRetEventoBPe write FRetEventoBPe;
  end;

  TRetEventoBPeCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetEventoBPeCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetEventoBPeCollectionItem);
  public
    function New: TRetEventoBPeCollectionItem;
    property Items[Index: Integer]: TRetEventoBPeCollectionItem read GetItem write SetItem; default;
  end;

  TRetConsSitBPe = class(TObject)
  private
    Fversao: string;
    FtpAmb: TACBrTipoAmbiente;
    FverAplic: string;
    FcStat: Integer;
    FxMotivo: string;
    FcUF: Integer;
    FdhRecbto: TDateTime;
    FchBPe: string;
    FprotBPe: TProcDFe;
    FprocEventoBPe: TRetEventoBPeCollection;
    FnRec: string;
    FXMLprotBPe: string;

    FXmlRetorno: string;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;

    property versao: string                         read Fversao        write Fversao;
    property tpAmb: TACBrTipoAmbiente               read FtpAmb         write FtpAmb;
    property verAplic: string                       read FverAplic      write FverAplic;
    property cStat: Integer                         read FcStat         write FcStat;
    property xMotivo: string                        read FxMotivo       write FxMotivo;
    property cUF: Integer                           read FcUF           write FcUF;
    property dhRecbto: TDateTime                    read FdhRecbto      write FdhRecbto;
    property chBPe: string                          read FchBPe         write FchBPe;
    property protBPe: TProcDFe                      read FprotBPe       write FprotBPe;
    property procEventoBPe: TRetEventoBPeCollection read FprocEventoBPe write FprocEventoBPe;
    property nRec: string                           read FnRec          write FnRec;
    property XMLprotBPe: string                     read FXMLprotBPe    write FXMLprotBPe;

    property XmlRetorno: string read FXmlRetorno write FXmlRetorno;
  end;

implementation

uses
  ACBrBPeConsts,
  ACBrXmlDocument;

{ TRetEventoCollection }

function TRetEventoBPeCollection.GetItem(Index: Integer): TRetEventoBPeCollectionItem;
begin
  Result := TRetEventoBPeCollectionItem(inherited Items[Index]);
end;

procedure TRetEventoBPeCollection.SetItem(Index: Integer;
  Value: TRetEventoBPeCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRetEventoCollectionItem }

constructor TRetEventoBPeCollectionItem.Create;
begin
  inherited Create;

  FRetEventoBPe := TRetEventoBPe.Create;
end;

destructor TRetEventoBPeCollectionItem.Destroy;
begin
  FRetEventoBPe.Free;

  inherited;
end;

function TRetEventoBPeCollection.New: TRetEventoBPeCollectionItem;
begin
  Result := TRetEventoBPeCollectionItem.Create;
  Self.Add(Result);
end;

{ TRetConsSitBPe }

constructor TRetConsSitBPe.Create;
begin
  inherited Create;

  FprotBPe := TProcDFe.Create(Versao, NAME_SPACE_BPe, 'bpeProc', 'BPe');
end;

destructor TRetConsSitBPe.Destroy;
begin
  FprotBPe.Free;

  if Assigned(procEventoBPe) then
    procEventoBPe.Free;

  inherited;
end;

function TRetConsSitBPe.LerXml: Boolean;
var
  Document: TACBrXmlDocument;
  ANode, ANodeAux: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  ok: Boolean;
  i: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      Result := True;

      Document.LoadFromXml(XmlRetorno);

      ANode := Document.Root;

      if ANode <> nil then
      begin
        versao := ObterConteudoTag(ANode.Attributes.Items['versao']);
        verAplic := ObterConteudoTag(ANode.Childrens.FindAnyNs('verAplic'), tcStr);
        tpAmb := StrToTipoAmbiente(ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpAmb'), tcStr));
        cUF := ObterConteudoTag(ANode.Childrens.FindAnyNs('cUF'), tcInt);
        nRec := ObterConteudoTag(ANode.Childrens.FindAnyNs('nRec'), tcStr);
        cStat := ObterConteudoTag(ANode.Childrens.FindAnyNs('cStat'), tcInt);
        xMotivo := ObterConteudoTag(ANode.Childrens.FindAnyNs('xMotivo'), tcStr);
        dhRecbto := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhRecbto'), tcDatHor);
        chBPe := ObterConteudoTag(ANode.Childrens.FindAnyNs('chBPe'), tcStr);

        case cStat of
          100,101,104,110,150,151,155,301,302,303:
            begin
              ANodeAux := ANode.Childrens.FindAnyNs('protBPe');

              if ANodeAux <> nil then
              begin
                // A propriedade XMLprotBPe contem o XML que traz o resultado do
                // processamento da BP-e.
                XMLprotBPe := ANodeAux.OuterXml;

                ANodeAux := ANodeAux.Childrens.FindAnyNs('infProt');

                if ANodeAux <> nil then
                begin
                  protBPe.tpAmb := StrToTipoAmbiente(ok, ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('tpAmb'), tcStr));
                  protBPe.verAplic := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('verAplic'), tcStr);
                  protBPe.chDFe := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('chBPe'), tcStr);
                  protBPe.dhRecbto := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('dhRecbto'), tcDatHor);
                  protBPe.nProt := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('nProt'), tcStr);
                  protBPe.digVal := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('digVal'), tcStr);
                  protBPe.cStat := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('cStat'), tcInt);
                  protBPe.xMotivo := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('xMotivo'), tcStr);
                  protBPe.cMsg := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('cMsg'), tcInt);
                  protBPe.xMsg := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('xMsg'), tcStr);
                end;
              end;
            end;
        end;

        if Assigned(procEventoBPe) then
          procEventoBPe.Free;

        procEventoBPe := TRetEventoBPeCollection.Create;

        try
          ANodeArray := ANode.Childrens.FindAllAnyNs('procEventoBPe');

          if Assigned(ANodeArray) then
          begin
            for i := Low(ANodeArray) to High(ANodeArray) do
            begin
              AnodeAux := ANodeArray[i];

              procEventoBPe.New;
              procEventoBPe.Items[i].RetEventoBPe.XmlRetorno := AnodeAux.OuterXml;
              procEventoBPe.Items[i].RetEventoBPe.XML := AnodeAux.OuterXml;
              procEventoBPe.Items[i].RetEventoBPe.LerXml;
            end;
          end;
        except
          Result := False;
        end;
      end;
    except
      Result := False;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

end.

