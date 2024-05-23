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

unit SiapNet.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_SiapNet200 }

  TNFSeR_SiapNet200 = class(TNFSeR_ABRASFv2)
  protected
    procedure LerEnderecoPrestadorServico(const ANode: TACBrXmlNode; const aTag: string); override;
    procedure LerEnderecoTomador(const ANode: TACBrXmlNode); override;
    procedure LerServico(const ANode: TACBrXmlNode); override;
  public

  end;

implementation

uses
  ACBrDFeUtil,
  ACBrNFSeXConversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     SiapNet
//==============================================================================

{ TNFSeR_SiapNet200 }

procedure TNFSeR_SiapNet200.LerEnderecoPrestadorServico(
  const ANode: TACBrXmlNode; const aTag: string);
var
  AuxNode: TACBrXmlNode;
  xUF: string;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs(aTag);

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Endereco do
    begin
      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('Endereco'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('Complemento'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      CodigoMunicipio := GerarDigitoMunicipio(ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr));
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('Uf'), tcStr);
      CodigoPais := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoPais'), tcInt);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cep'), tcStr);
      xMunicipio := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);

      if UF = '' then
        UF := xUF;
    end;
  end;
end;

procedure TNFSeR_SiapNet200.LerEnderecoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  xUF, xEndereco: string;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Endereco');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('Endereco'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('Complemento'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      CodigoMunicipio := GerarDigitoMunicipio(ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr));
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('Uf'), tcStr);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cep'), tcStr);
      xMunicipio := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);

      if UF = '' then
        UF := xUF;
    end;
  end;

  AuxNode := ANode.Childrens.FindAnyNs('EnderecoExterior');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      xEndereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('EnderecoCompletoExterior'), tcStr);

      if xEndereco <> '' then
        Endereco := xEndereco;

      CodigoPais := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoPais'), tcInt);

      if (CodigoPais <> 1058) and (CodigoPais > 0) then
        UF := 'EX';
    end;
  end;
end;

procedure TNFSeR_SiapNet200.LerServico(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNode2: TACBrXmlNode;
  Ok: Boolean;
  CodigoItemServico, Responsavel, xUF: string;
  ValorLiq: Double;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Servico');

  if AuxNode <> nil then
  begin
    LerValores(AuxNode);

    CodigoItemServico := ObterConteudo(AuxNode.Childrens.FindAnyNs('ItemListaServico'), tcStr);

    with NFSe.Servico do
    begin
      Responsavel := ObterConteudo(AuxNode.Childrens.FindAnyNs('ResponsavelRetencao'), tcStr);

      if Responsavel = '' then
        ResponsavelRetencao := rtNenhum
      else
        ResponsavelRetencao := FpAOwner.StrToResponsavelRetencao(Ok, Responsavel);

      ItemListaServico          := NormatizarItemListaServico(CodigoItemServico);
      xItemListaServico         := ItemListaServicoDescricao(ItemListaServico);
      CodigoCnae                := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoCnae'), tcStr);
      CodigoTributacaoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoTributacaoMunicipio'), tcStr);
      CodigoNBS                 := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoNbs'), tcStr);
      Discriminacao             := ObterConteudo(AuxNode.Childrens.FindAnyNs('Discriminacao'), tcStr);
      Discriminacao := StringReplace(Discriminacao, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

      VerificarSeConteudoEhLista(Discriminacao);

      CodigoMunicipio := GerarDigitoMunicipio(ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr));

      MunicipioPrestacaoServico := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);
      MunicipioPrestacaoServico := MunicipioPrestacaoServico + '/' + xUF;

      CodigoPais          := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoPais'), tcInt);
      ExigibilidadeISS    := FpAOwner.StrToExigibilidadeISS(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('ExigibilidadeISS'), tcStr));
      IdentifNaoExigibilidade := ObterConteudo(AuxNode.Childrens.FindAnyNs('IdentifNaoExigibilidade'), tcStr);

      MunicipioIncidencia := StrToIntDef(GerarDigitoMunicipio(ObterConteudo(AuxNode.Childrens.FindAnyNs('MunicipioIncidencia'), tcStr)), 0);

      xMunicipioIncidencia := ObterNomeMunicipioUF(MunicipioIncidencia, xUF);
      xMunicipioIncidencia := xMunicipioIncidencia + '/' + xUF;

      NumeroProcesso := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumeroProcesso'), tcStr);

      if Valores.IssRetido = stNenhum then
        Valores.IssRetido := FpAOwner.StrToSituacaoTributaria(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('IssRetido'), tcStr));

      if Valores.IssRetido = stRetencao then
        Valores.ValorIssRetido := Valores.ValorIss
      else
        Valores.ValorIssRetido := 0;

      Valores.RetencoesFederais := Valores.ValorPis + Valores.ValorCofins +
                                   Valores.ValorInss + Valores.ValorIr +
                                   Valores.ValorCsll + Valores.ValorCpp;

      ValorLiq := Valores.ValorServicos - Valores.RetencoesFederais -
                  Valores.OutrasRetencoes - Valores.ValorIssRetido -
                  Valores.DescontoIncondicionado - Valores.DescontoCondicionado;

      if (Valores.ValorLiquidoNfse = 0) or (Valores.ValorLiquidoNfse > ValorLiq) then
        Valores.ValorLiquidoNfse := ValorLiq;

      Valores.ValorTotalNotaFiscal := Valores.ValorServicos -
                                      Valores.DescontoCondicionado -
                                      Valores.DescontoIncondicionado;
    end;
  end;
end;

end.
