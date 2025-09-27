{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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

unit ACBrONE.RetConsPlaca;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrBase,
  ACBrXmlBase,
  ACBrDFe.Conversao,
  ACBrXmlDocument;

type
  TinfMDFeCollectionItem = class(TObject)
  private
    FchMDFe: string;

  public
    property chMDFe: string read FchMDFe write FchMDFe;
  end;

  TinfMDFeCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfMDFeCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfMDFeCollectionItem);
  public
    function New: TinfMDFeCollectionItem;
    property Items[Index: Integer]: TinfMDFeCollectionItem read GetItem write SetItem; default;
  end;

  TRetConsPlaca = class(TObject)
  private
    Fversao: string;
    FtpAmb: TACBrTipoAmbiente;
    FverAplic: string;
    FcStat: Integer;
    FxMotivo: string;
    FdhResp: TDateTime;
    FNSU: string;
    FleituraComp: string;
    FinfMDFe: TinfMDFeCollection;
    FXmlRetorno: string;

    procedure SetinfMDFe(const Value: TinfMDFeCollection);
    procedure Ler_retOneConsPorPlaca(ANode: TACBrXmlNode);
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: boolean;

    property versao: string           read Fversao      write Fversao;
    property tpAmb: TACBrTipoAmbiente read FtpAmb       write FtpAmb;
    property verAplic: string         read FverAplic    write FverAplic;
    property cStat: Integer           read FcStat       write FcStat;
    property xMotivo: string          read FxMotivo     write FxMotivo;
    property dhResp: TDateTime        read FdhResp      write FdhResp;
    property NSU: string              read FNSU         write FNSU;
    property leituraComp: string      read FleituraComp write FleituraComp;
    property infMDFe: TinfMDFeCollection read FinfMDFe  write SetinfMDFe;

    property XmlRetorno: string read FXmlRetorno write FXmlRetorno;
  end;

implementation

uses
  synacode,
  ACBrUtil.FilesIO;

{ TRetConsPlaca }

constructor TRetConsPlaca.Create;
begin
  inherited Create;

  FinfMDFe := TinfMDFeCollection.Create();
end;

destructor TRetConsPlaca.Destroy;
begin
  FinfMDFe.Free;

  inherited;
end;

function TRetConsPlaca.LerXml: boolean;
var
  Document: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  ok: Boolean;
begin
  Document := TACBrXmlDocument.Create;

  try
    Document.LoadFromXml(XmlRetorno);

    ANode := Document.Root;

    if ANode <> nil then
    begin
      versao := ObterConteudoTag(ANode.Attributes.Items['versao']);
      tpAmb := StrToTipoAmbiente(ok, ObterConteudoTag(ANode.Childrens.FindAnyNs('tpAmb'), tcStr));
      verAplic := ObterConteudoTag(ANode.Childrens.FindAnyNs('verAplic'), tcStr);
      cStat := ObterConteudoTag(ANode.Childrens.FindAnyNs('cStat'), tcInt);
      xMotivo := ObterConteudoTag(ANode.Childrens.FindAnyNs('xMotivo'), tcStr);
      dhResp := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhResp'), tcDatHor);

      Ler_retOneConsPorPlaca(ANode.Childrens.FindAnyNs('retOneConsPorPlaca'));
    end;
  finally
    Result := True;
    FreeAndNil(Document);
  end;
end;

procedure TRetConsPlaca.Ler_retOneConsPorPlaca(ANode: TACBrXmlNode);
var
  ANodeAux: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  auxStr: AnsiString;
  i: Integer;
begin
  if not Assigned(ANode) then Exit;

  ANodeAux := ANode.Childrens.FindAnyNs('loteDistLeitura');

  if ANodeAux <> nil then
  begin
    ANodeAux := ANodeAux.Childrens.FindAnyNs('leituraCompactada');

    if ANodeAux <> nil then
    begin
      NSU := ObterConteudoTag(ANodeAux.Attributes.Items['NSU']);
      auxStr := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('leituraComp'), tcStr);

      if auxStr <> '' then
        leituraComp := UnZip(DecodeBase64(auxStr));

      ANodes := ANodeAux.Childrens.FindAllAnyNs('infMDFe');

      for i := 0 to Length(ANodes) - 1 do
      begin
        FinfMDFe.New;
        FinfMDFe[i].chMDFe := ObterConteudoTag(ANodes[i].Childrens.FindAnyNs('chMDFe'), tcStr);
      end;
    end;
  end;
end;

procedure TRetConsPlaca.SetinfMDFe(const Value: TinfMDFeCollection);
begin
  FinfMDFe := Value;
end;

{ TinfMDFeCollection }

function TinfMDFeCollection.GetItem(Index: Integer): TinfMDFeCollectionItem;
begin
  Result := TinfMDFeCollectionItem(inherited Items[Index]);
end;

function TinfMDFeCollection.New: TinfMDFeCollectionItem;
begin
  Result := TinfMDFeCollectionItem.Create;
  Add(Result);
end;

procedure TinfMDFeCollection.SetItem(Index: Integer;
  Value: TinfMDFeCollectionItem);
begin
  inherited Items[Index] := Value;
end;

end.

