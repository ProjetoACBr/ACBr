{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit ACBrNF3eRetConsSit;

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
  ACBrNF3eRetEnvEvento;

type

  TRetEventoNF3eCollectionItem = class(TObject)
  private
    FRetEventoNF3e: TRetEventoNF3e;
  public
    constructor Create;
    destructor Destroy; override;
    property RetEventoNF3e: TRetEventoNF3e read FRetEventoNF3e write FRetEventoNF3e;
  end;

  TRetEventoNF3eCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetEventoNF3eCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetEventoNF3eCollectionItem);
  public
    function New: TRetEventoNF3eCollectionItem;
    property Items[Index: Integer]: TRetEventoNF3eCollectionItem read GetItem write SetItem; default;
  end;

  TRetConsSitNF3e = class(TObject)
  private
    Fversao: String;
    FtpAmb: TACBrTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FcUF: Integer;
    FdhRecbto: TDateTime;
    FchNF3e: String;
    FprotNF3e: TProcDFe;
    FprocEventoNF3e: TRetEventoNF3eCollection;
    FnRec: String;
    FXMLprotNF3e: String;

    FXmlRetorno: String;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;

    property versao: String                           read Fversao         write Fversao;
    property tpAmb: TACBrTipoAmbiente                 read FtpAmb          write FtpAmb;
    property verAplic: String                         read FverAplic       write FverAplic;
    property cStat: Integer                           read FcStat          write FcStat;
    property xMotivo: String                          read FxMotivo        write FxMotivo;
    property cUF: Integer                             read FcUF            write FcUF;
    property dhRecbto: TDateTime                      read FdhRecbto       write FdhRecbto;
    property chNF3e: String                           read FchNF3e         write FchNF3e;
    property protNF3e: TProcDFe                       read FprotNF3e       write FprotNF3e;
    property procEventoNF3e: TRetEventoNF3eCollection read FprocEventoNF3e write FprocEventoNF3e;
    property nRec: String                             read FnRec           write FnRec;
    property XMLprotNF3e: String                      read FXMLprotNF3e    write FXMLprotNF3e;

    property XmlRetorno: String read FXmlRetorno write FXmlRetorno;
  end;

implementation

uses
  ACBrNF3eConsts,
  ACBrXmlDocument;

{ TRetEventoCollection }

function TRetEventoNF3eCollection.GetItem(Index: Integer): TRetEventoNF3eCollectionItem;
begin
  Result := TRetEventoNF3eCollectionItem(inherited Items[Index]);
end;

procedure TRetEventoNF3eCollection.SetItem(Index: Integer;
  Value: TRetEventoNF3eCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRetEventoCollectionItem }

constructor TRetEventoNF3eCollectionItem.Create;
begin
  inherited Create;

  FRetEventoNF3e := TRetEventoNF3e.Create;
end;

destructor TRetEventoNF3eCollectionItem.Destroy;
begin
  FRetEventoNF3e.Free;

  inherited;
end;

function TRetEventoNF3eCollection.New: TRetEventoNF3eCollectionItem;
begin
  Result := TRetEventoNF3eCollectionItem.Create;
  Self.Add(Result);
end;

{ TRetConsSitNF3e }

constructor TRetConsSitNF3e.Create;
begin
  inherited Create;

  FprotNF3e := TProcDFe.Create(Versao, NAME_SPACE_NF3e, 'nf3eProc', 'NF3e');
end;

destructor TRetConsSitNF3e.Destroy;
begin
  FprotNF3e.Free;

  if Assigned(procEventoNF3e) then
    procEventoNF3e.Free;

  inherited;
end;

function TRetConsSitNF3e.LerXml: Boolean;
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
        chNF3e := ObterConteudoTag(ANode.Childrens.FindAnyNs('chNF3e'), tcStr);

        case cStat of
          100, 101, 104, 150, 151, 155:
            begin
              ANodeAux := ANode.Childrens.FindAnyNs('protNF3e');

              if ANodeAux <> nil then
              begin
                // A propriedade XMLprotNF3e contem o XML que traz o resultado do
                // processamento da NF3-e.
                XMLprotNF3e := ANodeAux.OuterXml;

                ANodeAux := ANodeAux.Childrens.FindAnyNs('infProt');

                if ANodeAux <> nil then
                begin
                  protNF3e.tpAmb := StrToTipoAmbiente(ok, ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('tpAmb'), tcStr));
                  protNF3e.verAplic := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('verAplic'), tcStr);
                  protNF3e.chDFe := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('chNF3e'), tcStr);
                  protNF3e.dhRecbto := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('dhRecbto'), tcDatHor);
                  protNF3e.nProt := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('nProt'), tcStr);
                  protNF3e.digVal := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('digVal'), tcStr);
                  protNF3e.cStat := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('cStat'), tcInt);
                  protNF3e.xMotivo := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('xMotivo'), tcStr);
                  protNF3e.cMsg := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('cMsg'), tcInt);
                  protNF3e.xMsg := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('xMsg'), tcStr);
                end;
              end;
            end;
        end;

        if Assigned(procEventoNF3e) then
          procEventoNF3e.Free;

        procEventoNF3e := TRetEventoNF3eCollection.Create;

        try
          ANodeArray := ANode.Childrens.FindAllAnyNs('procEventoNF3e');

          if Assigned(ANodeArray) then
          begin
            for i := Low(ANodeArray) to High(ANodeArray) do
            begin
              AnodeAux := ANodeArray[i];

              procEventoNF3e.New;
              procEventoNF3e.Items[i].RetEventoNF3e.XmlRetorno := AnodeAux.OuterXml;
              procEventoNF3e.Items[i].RetEventoNF3e.XML := AnodeAux.OuterXml;
              procEventoNF3e.Items[i].RetEventoNF3e.LerXml;
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

