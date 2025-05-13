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

unit EloTech.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  IniFiles,
  ACBrXmlDocument, ACBrXmlBase,
  ACBrNFSeXClass,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_EloTech203 }

  TNFSeR_EloTech203 = class(TNFSeR_ABRASFv2)
  protected

    procedure LerListaServicos(const ANode: TACBrXmlNode); override;
    procedure LerServicos(const ANode: TACBrXmlNode); override;
    procedure LerDadosDeducao(const ANode: TACBrXmlNode; Item: Integer);

    procedure LerINISecaoServicos(const AINIRec: TMemIniFile); override;
    procedure LerINISecaoDadosDeducao(const AINIRec: TMemIniFile;
        Item: TItemServicoCollectionItem; const AIndice: Integer); override;
  public

  end;

implementation

uses
  ACBrUtil.Base;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     EloTech
//==============================================================================

{ TNFSeR_EloTech203 }

procedure TNFSeR_EloTech203.LerINISecaoServicos(const AINIRec: TMemIniFile);
var
  i: Integer;
  sSecao, sFim: string;
  Item: TItemServicoCollectionItem;
  Ok: Boolean;
begin
  i := 1;
  while true do
  begin
    sSecao := 'Itens' + IntToStrZero(i, 3);
    sFim := AINIRec.ReadString(sSecao, 'Descricao'  ,'FIM');

    if (sFim = 'FIM') then
      break;

    Item := NFSe.Servico.ItemServico.New;

    Item.ItemListaServico := AINIRec.ReadString(sSecao, 'ItemListaServico', '');
    Item.xItemListaServico := AINIRec.ReadString(sSecao, 'xItemListaServico', '');
    Item.CodigoCnae := AINIRec.ReadString(sSecao, 'CodigoCnae', '');
    Item.Descricao := StringReplace(sFim, FpAOwner.ConfigGeral.QuebradeLinha, sLineBreak, [rfReplaceAll]);
    Item.Tributavel := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(sSecao, 'Tributavel', '1'));
    Item.Quantidade := StringToFloatDef(AINIRec.ReadString(sSecao, 'Quantidade', ''), 0);
    Item.ValorUnitario := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorUnitario', ''), 0);
    Item.DescontoIncondicionado := StringToFloatDef(AINIRec.ReadString(sSecao, 'DescontoIncondicionado', ''), 0);
    Item.ValorTotal := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorTotal', ''), 0);

    LerINISecaoDadosDeducao(AINIRec, Item, i);
  end;
end;

procedure TNFSeR_EloTech203.LerINISecaoDadosDeducao(const AINIRec: TMemIniFile;
  Item: TItemServicoCollectionItem; const AIndice: Integer);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'DadosDeducao' + IntToStrZero(AIndice + 1, 3);

  if AINIRec.SectionExists(sSecao) then
  begin
    Item.DadosDeducao.TipoDeducao := FpAOwner.StrToTipoDeducao(Ok, AINIRec.ReadString(sSecao, 'TipoDeducao', ''));
    Item.DadosDeducao.CpfCnpj := AINIRec.ReadString(sSecao, 'CpfCnpj', '');
    Item.DadosDeducao.NumeroNotaFiscalReferencia := AINIRec.ReadString(sSecao, 'NumeroNotaFiscalReferencia', '');
    Item.DadosDeducao.ValorTotalNotaFiscal := StrToFloatDef(AINIRec.ReadString(sSecao, 'ValorTotalNotaFiscal', ''), 0);
    Item.DadosDeducao.PercentualADeduzir := StrToFloatDef(AINIRec.ReadString(sSecao, 'PercentualADeduzir', ''), 0);
    Item.DadosDeducao.ValorADeduzir := StrToFloatDef(AINIRec.ReadString(sSecao, 'ValorADeduzir', ''), 0);
  end;
end;

procedure TNFSeR_EloTech203.LerListaServicos(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  //Conforme schema, <ListaItensServico> est� dentro de <Servico>
  AuxNode := ANode.Childrens.FindAnyNs('Servico');
  if Assigned(AuxNode) then
    AuxNode := AuxNode.Childrens.FindAnyNs('ListaItensServico');

  if AuxNode <> nil then
    LerServicos(AuxNode);
end;

procedure TNFSeR_EloTech203.LerServicos(const ANode: TACBrXmlNode);
var
  ANodes: TACBrXmlNodeArray;
  i: Integer;
  CodigoItemServico: string;
  Ok: Boolean;
begin
  ANodes := ANode.Childrens.FindAllAnyNs('ItemServico');

  for i := 0 to Length(ANodes) - 1 do
  begin
    NFSe.Servico.ItemServico.New;

    with NFSe.Servico.ItemServico[i] do
    begin
      CodigoItemServico := ObterConteudo(ANodes[i].Childrens.FindAnyNs('ItemListaServico'), tcStr);
      ItemListaServico := NormatizarItemListaServico(CodigoItemServico);
      xItemListaServico := ItemListaServicoDescricao(ItemListaServico);

      CodigoCnae := ObterConteudo(ANodes[i].Childrens.FindAnyNs('CodigoCnae'), tcStr);
      Descricao := ObterConteudo(ANodes[i].Childrens.FindAnyNs('Descricao'), tcStr);
      Descricao := StringReplace(Descricao, FpQuebradeLinha,
                                                    sLineBreak, [rfReplaceAll]);
      Tributavel := FpAOwner.StrToSimNao(Ok, ObterConteudo(ANodes[i].Childrens.FindAnyNs('Tributavel'), tcStr));
      Quantidade := ObterConteudo(ANodes[i].Childrens.FindAnyNs('Quantidade'), tcDe5);
      ValorUnitario := ObterConteudo(ANodes[i].Childrens.FindAnyNs('ValorUnitario'), tcDe5);
      DescontoIncondicionado := ObterConteudo(ANodes[i].Childrens.FindAnyNs('ValorDesconto'), tcDe2);
      ValorTotal := ObterConteudo(ANodes[i].Childrens.FindAnyNs('ValorLiquido'), tcDe2);

      LerDadosDeducao(ANodes[i], i);
    end;
  end;
end;

procedure TNFSeR_EloTech203.LerDadosDeducao(const ANode: TACBrXmlNode; Item: Integer);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('DadosDeducao');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.ItemServico[Item].DadosDeducao do
    begin
      TipoDeducao := FpAOwner.StrToTipoDeducao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('TipoDeducao'), tcStr));

      CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cnpj'), tcStr);

      if CpfCnpj = '' then
        CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cpf'), tcStr);

      NumeroNotaFiscalReferencia := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumeroNotaFiscalReferencia'), tcStr);
      ValorTotalNotaFiscal := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorTotalNotaFiscal'), tcDe2);
      PercentualADeduzir := ObterConteudo(AuxNode.Childrens.FindAnyNs('PercentualADeduzir'), tcDe2);
      ValorADeduzir := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorADeduzir'), tcDe2);
    end;
  end;
end;

end.
