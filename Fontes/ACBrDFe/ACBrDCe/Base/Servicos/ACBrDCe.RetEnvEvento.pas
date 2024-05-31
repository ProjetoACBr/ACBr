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

unit ACBrDCe.RetEnvEvento;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase, ACBrXmlBase,
//  ACBrDFeComum.SignatureClass,
  pcnSignature,
  ACBrDCe.EventoClass;

type

  TRetEventoDCe = class(TObject)
  private
    Fversao: string;
    FretInfEvento: TRetInfEvento;
    Fsignature: Tsignature;

    FXmlRetorno: string;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;

    property versao: string read Fversao write Fversao;
    property retInfEvento: TRetInfEvento read FretInfEvento write FretInfEvento;
    property signature: Tsignature read Fsignature write Fsignature;

    property XmlRetorno: string read FXmlRetorno write FXmlRetorno;
  end;

implementation

uses
  ACBrDCe.Conversao,
  ACBrUtil.Strings,
  ACBrXmlDocument;

{ TRetEventoDCe }

constructor TRetEventoDCe.Create;
begin
  inherited Create;

  FretInfEvento := TRetInfEvento.Create;
  Fsignature := Tsignature.Create;
end;

destructor TRetEventoDCe.Destroy;
begin
  FretInfEvento.Free;
  Fsignature.Free;

  inherited;
end;

function TRetEventoDCe.LerXml: Boolean;
var
  Document: TACBrXmlDocument;
  ANode, ANodeAux: TACBrXmlNode;
  ok: Boolean;
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
        versao := ObterConteudoTag(ANode.Attributes.Items['versao']);

        ANodeAux := ANode.Childrens.FindAnyNs('infEvento');

        if ANodeAux <> nil then
        begin
          RetInfEvento.Id := ObterConteudoTag(ANodeAux.Attributes.Items['Id']);
          RetInfEvento.tpAmb := StrToTipoAmbiente(ok, ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('tpAmb'), tcStr));
          RetInfEvento.verAplic := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('verAplic'), tcStr);
          retInfEvento.cOrgao := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('cOrgao'), tcInt);
          retInfEvento.cStat := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('cStat'), tcInt);
          retInfEvento.xMotivo := ACBrStr(ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('xMotivo'), tcStr));
          RetInfEvento.chDCe := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('chDCe'), tcStr);
          RetInfEvento.tpEvento := StrTotpEventoDCe(ok, ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('tpEvento'), tcStr));
          RetInfEvento.xEvento := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('xEvento'), tcStr);
          retInfEvento.nSeqEvento := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('nSeqEvento'), tcInt);
          retInfEvento.dhRegEvento := ObterConteudoTag(Anode.Childrens.FindAnyNs('dhRegEvento'), tcDatHor);
          RetInfEvento.nProt := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('nProt'), tcStr);
        end;

        ANodeAux := ANode.Childrens.FindAnyNs('Signature');

        if ANodeAux <> nil then
        begin
          signature.URI := ObterConteudoTag(ANodeAux.Attributes.Items['URI']);
          signature.DigestValue := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('DigestValue'), tcStr);
          signature.SignatureValue := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('SignatureValue'), tcStr);
          signature.X509Certificate := ObterConteudoTag(ANodeAux.Childrens.FindAnyNs('X509Certificate'), tcStr);
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

end.
