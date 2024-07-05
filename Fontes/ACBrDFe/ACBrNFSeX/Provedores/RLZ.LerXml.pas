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

unit RLZ.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXLerXml_ABRASFv2, ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { TNFSeR_RLZ }

  TNFSeR_RLZ = class(TNFSeRClass)
  protected
    procedure LerServicos(const ANode: TACBrXmlNode);
    procedure LerPrestador(const ANode: TACBrXmlNode);
    procedure LerTomador(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

  { TNFSeR_RLZ203 }

  TNFSeR_RLZ203 = class(TNFSeR_ABRASFv2)
  protected

  public

  end;

implementation

uses
  ACBrUtil.Base;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     RLZ
//==============================================================================

{ TNFSeR_RLZ }

procedure TNFSeR_RLZ.LerServicos(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('servicos');

  if AuxNode <> nil then
  begin
    ANodes := AuxNode.Childrens.FindAllAnyNs('servico');

    for i := 0 to Length(ANodes) - 1 do
    begin
      NFSe.Servico.ItemServico.New;
      with NFSe.Servico.ItemServico[i] do
      begin
        Quantidade := ObterConteudo(ANodes[i].Childrens.FindAnyNs('quantidade'), tcDe6);
        Descricao := ObterConteudo(ANodes[i].Childrens.FindAnyNs('atividade'), tcStr);
        Descricao := StringReplace(Descricao, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);
        ValorUnitario := ObterConteudo(ANodes[i].Childrens.FindAnyNs('valor'), tcDe2);
        DescontoIncondicionado := ObterConteudo(ANodes[i].Childrens.FindAnyNs('deducao'), tcDe2);
        ItemListaServico := ObterConteudo(ANodes[i].Childrens.FindAnyNs('codigoservico'), tcStr);
        Aliquota := ObterConteudo(ANodes[i].Childrens.FindAnyNs('aliquota'), tcDe2);
        ValorINSS := ObterConteudo(ANodes[i].Childrens.FindAnyNs('inss'), tcDe2);
        ValorTotal := ObterConteudo(ANodes[i].Childrens.FindAnyNs('total'), tcDe2);
      end;
    end;
  end;
end;

procedure TNFSeR_RLZ.LerPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  xUF: string;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('prestador');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador do
    begin
      Endereco.Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('endereco'), tcStr);
      Endereco.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero'), tcStr);
      Endereco.Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('complemento'), tcStr);
      Endereco.Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('bairro'), tcStr);
      Endereco.CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cep'), tcStr);
      Endereco.CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cidade'), tcStr);
      Endereco.UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('uf'), tcStr);
      Endereco.xMunicipio := ObterNomeMunicipioUF(StrToIntDef(Endereco.CodigoMunicipio, 0), xUF);

      if Endereco.UF = '' then
        Endereco.UF := xUF;

      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('nome'), tcStr);

      IdentificacaoPrestador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('inscricao'), tcStr);
      IdentificacaoPrestador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('cpfcnpj'), tcStr);
    end;
  end;
end;

procedure TNFSeR_RLZ.LerTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  xUF: string;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('tomador');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador do
    begin
      Endereco.Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('endereco'), tcStr);
      Endereco.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero'), tcStr);
      Endereco.Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('complemento'), tcStr);
      Endereco.Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('bairro'), tcStr);
      Endereco.CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cep'), tcStr);
      Endereco.CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cidade'), tcStr);
      Endereco.UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('uf'), tcStr);
      Endereco.xMunicipio := ObterNomeMunicipioUF(StrToIntDef(Endereco.CodigoMunicipio, 0), xUF);

      if Endereco.UF = '' then
        Endereco.UF := xUF;

      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('nome'), tcStr);

      IdentificacaoTomador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('inscricao'), tcStr);
      IdentificacaoTomador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('cpfcnpj'), tcStr);
    end;
  end;
end;

function TNFSeR_RLZ.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
begin
  FpQuebradeLinha := FpAOwner.ConfigGeral.QuebradeLinha;

  if EstaVazio(Arquivo) then
    raise Exception.Create('Arquivo xml n�o carregado.');

  LerParamsTabIni(True);

  Arquivo := NormatizarXml(Arquivo);

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(Arquivo);

  XmlNode := Document.Root;

  if XmlNode = nil then
    raise Exception.Create('Arquivo xml vazio.');

  Result := LerXmlNfse(XmlNode);

  if NFSe.Tomador.RazaoSocial = '' then
    NFSe.Tomador.RazaoSocial := 'Tomador N�o Identificado';

  FreeAndNil(FDocument);
end;

function TNFSeR_RLZ.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  Ok: Boolean;
begin
  Result := True;

  if not Assigned(ANode) then Exit;

  with NFSe do
  begin
    // <guia>?</guia>
    Numero := ObterConteudo(ANode.Childrens.FindAnyNs('numero'), tcStr);
    // <mes>?</mes>
    // <cidade>?</cidade>
    // <uf>?</uf>
    // <exercicio>?</exercicio>
    DataEmissao := ObterConteudo(ANode.Childrens.FindAnyNs('data'), tcDat);
    // <modelo>?</modelo>
    SeriePrestacao := ObterConteudo(ANode.Childrens.FindAnyNs('serie'), tcStr);
    // <apuracao>?</apuracao>
    // <valor>/valor>
    // <valorimposto>?</valorimposto>
    OptanteSimplesNacional := FpAOwner.StrToSimNao(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('optantesimples'), tcStr));
    // <situacao>?</situacao>
    // <deducao>?</deducao>
    // <basecalculo>?</basecalculo>
    // <retido>?</ retido >
    // <incidencia>?</incidencia>
    Link := ObterConteudo(ANode.Childrens.FindAnyNs('url'), tcStr);
    Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);

    LerServicos(ANode);
    LerPrestador(ANode);
    LerTomador(ANode);
  end;
end;

end.
