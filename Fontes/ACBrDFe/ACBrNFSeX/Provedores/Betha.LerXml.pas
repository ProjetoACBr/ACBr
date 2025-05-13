{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit Betha.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  INIFiles,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXLerXml_ABRASFv1, ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_Betha }

  TNFSeR_Betha = class(TNFSeR_ABRASFv1)
  private
    LSecao: string;
  protected
    procedure LerCondicaoPagamento(const ANode: TACBrXmlNode);

    procedure LerINISecaoCondicaoPagamento(const AINIRec: TMemIniFile); override;
    procedure LerINISecaoParcelas(const AINIRec: TMemIniFile); override;
  public
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean; override;

  end;

  { TNFSeR_Betha202 }

  TNFSeR_Betha202 = class(TNFSeR_ABRASFv2)
  protected

  public

  end;

implementation

uses
  ACBrUtil.Base,
  ACBrNFSeXClass;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Betha
//==============================================================================

{ TNFSeR_Betha }

procedure TNFSeR_Betha.LerCondicaoPagamento(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('CondicaoPagamento');

  if AuxNode <> nil then
  begin
    with NFSe.CondicaoPagamento do
    begin
      Condicao := FpAOwner.StrToCondicaoPag(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('Condicao'), tcStr));
      QtdParcela := ObterConteudo(AuxNode.Childrens.FindAnyNs('QtdParcela'), tcInt);

      ANodes := AuxNode.Childrens.FindAllAnyNs('Parcelas');

      for i := 0 to Length(ANodes) - 1 do
      begin
        Parcelas.New;

        Parcelas[i].Parcela := ObterConteudo(ANodes[i].Childrens.FindAnyNs('Parcela'), tcStr);
        Parcelas[i].DataVencimento := ObterConteudo(ANodes[i].Childrens.FindAnyNs('DataVencimento'), tcDatVcto);
        Parcelas[i].Valor := ObterConteudo(ANodes[i].Childrens.FindAnyNs('Valor'), tcDe2);
      end;
    end;
  end;
end;

procedure TNFSeR_Betha.LerINISecaoCondicaoPagamento(const AINIRec: TMemIniFile);
var
  Ok: Boolean;
begin
  LSecao := 'CondicaoPagamento';

  if AINIRec.SectionExists(LSecao) then
  begin
    NFSe.CondicaoPagamento.QtdParcela := AINIRec.ReadInteger(LSecao, 'QtdParcela', 0);
    NFSe.CondicaoPagamento.Condicao := FpAOwner.StrToCondicaoPag(Ok, AINIRec.ReadString(LSecao, 'Condicao', 'A_VISTA'));
  end;
end;

procedure TNFSeR_Betha.LerINISecaoParcelas(const AINIRec: TMemIniFile);
var
  i: Integer;
  sFim: string;
  Item: TParcelasCollectionItem;
begin
  i := 1;
  while true do
  begin
    LSecao := 'Parcelas' + IntToStrZero(i, 2);
    sFim := AINIRec.ReadString(LSecao, 'Parcela', 'FIM');

    if (sFim = 'FIM') then
      break;

    Item := NFSe.CondicaoPagamento.Parcelas.New;
    Item.Parcela := sFim;
    Item.DataVencimento := AINIRec.ReadDate(LSecao, 'DataVencimento', Now);
    Item.Valor := StringToFloatDef(AINIRec.ReadString(LSecao, 'Valor', ''), 0);

    Inc(i);
  end;
end;

function TNFSeR_Betha.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := inherited LerXmlRps(Anode);

  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfRps');

  if AuxNode <> nil then
    LerCondicaoPagamento(AuxNode);
end;

end.
