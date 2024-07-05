{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Renato Tanchela Rubinho                         }
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

unit Prescon.LerJson;

interface

uses
  SysUtils, Classes, StrUtils,
  StrUtilsEx,
  ACBrUtil.DateTime,
  ACBrUtil.Base, ACBrUtil.Strings,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass,
  ACBrNFSeXConversao, ACBrNFSeXLerXml, ACBrJSON;

type
  { Provedor com layout pr�prio }
  { TNFSeR_Prescon }

  TNFSeR_Prescon = class(TNFSeRClass)
  protected
    procedure LerDadosPrestador(const ANode: TACBrXmlNode);
    procedure LerDadosTomador(const ANode: TACBrXmlNode);
    procedure LerDadosLocalServico(const ANode: TACBrXmlNode);
    procedure LerDetalhesServico(const ANode: TACBrXmlNode);
    procedure LerTotais(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

implementation

uses
  ACBrDFeUtil;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o Json do provedor:
//     Prescon
//==============================================================================

{ TNFSeR_Prescon }

function TNFSeR_Prescon.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
begin
  FpQuebradeLinha := FpAOwner.ConfigGeral.QuebradeLinha;

  // O provedor recebe as informa��es em json e devolve xml
  if EstaVazio(Arquivo) then
    raise Exception.Create('Arquivo xml n�o carregado.');

  LerParamsTabIni(True);

  Arquivo := NormatizarXml(Arquivo);

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(Arquivo);

  tpXML := txmlNFSe;

  XmlNode := Document.Root;

  if XmlNode = nil then
    raise Exception.Create('Arquivo xml vazio.');

  Result := LerXmlNfse(XmlNode);

  if NFSe.Tomador.RazaoSocial = '' then
    NFSe.Tomador.RazaoSocial := 'Tomador N�o Identificado';

  FreeAndNil(FDocument);
end;

function TNFSeR_Prescon.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;

  if not Assigned(ANode) then Exit;

  // A tag vem com erro de grafia, prevista situa��o de corre��o por parte do provedor
  AuxNode := ANode.Childrens.FindAnyNs('NfeCabecario');
  if not Assigned(AuxNode) then
  begin
    AuxNode := ANode.Childrens.FindAnyNs('NfeCabecalho');

    if not Assigned(AuxNode) then Exit;
  end;

  NFSe.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numeroNota'), tcStr);
  NFSe.DataEmissao := EncodeDataHora(ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dataEmissao'), tcStr),'DD/MM/YYYY');
  NFSe.Competencia := NFSe.DataEmissao;
  NFSe.CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('codigoAutenticacao'), tcStr);

  if ObterConteudo(AuxNode.Childrens.FindAnyNs('notacancelada'), tcStr) = '1' then
    NFSe.SituacaoNfse := ACBrNFSeXConversao.snCancelado;

  LerDadosPrestador(ANode);
  LerDadosTomador(ANode);
  LerDadosLocalServico(ANode);
  LerDetalhesServico(ANode);
  LerTotais(ANode);

  LerCampoLink;
end;

procedure TNFSeR_Prescon.LerDadosPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Prestador: TDadosPrestador;
  Endereco: TEndereco;
begin
  AuxNode := ANode.Childrens.FindAnyNs('DadosPrestador');

  if Assigned(AuxNode) then
  begin
    Prestador := NFSe.Prestador;
    Prestador.RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('razaoSocial'), tcStr);
    Prestador.NomeFantasia := Prestador.RazaoSocial;
    Prestador.IdentificacaoPrestador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('documento'), tcStr);
    Prestador.IdentificacaoPrestador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('im'), tcStr);

    Endereco := Prestador.Endereco;
    Endereco.Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('endereco'), tcStr);
    Endereco.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero'), tcStr);
    Endereco.Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('complemento'), tcStr);
    Endereco.Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('bairro'), tcStr);
    Endereco.xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('municipio'), tcStr);
    Endereco.UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('uf'), tcStr);
    Endereco.CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cep'), tcStr);

    Prestador.Contato.Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('tel'), tcStr);
  end;
end;

procedure TNFSeR_Prescon.LerDadosTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Tomador: TDadosTomador;
  Endereco: TEndereco;
begin
  AuxNode := ANode.Childrens.FindAnyNs('DadosTomador');

  if Assigned(AuxNode) then
  begin
    Tomador := NFSe.Tomador;
    Tomador.RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('razaoSocial'), tcStr);
    Tomador.NomeFantasia := Tomador.RazaoSocial;
    Tomador.IdentificacaoTomador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('documento'), tcStr);
    Tomador.IdentificacaoTomador.InscricaoEstadual := ObterConteudo(AuxNode.Childrens.FindAnyNs('ie'), tcStr);

    Endereco := Tomador.Endereco;
    Endereco.Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('logradouro'), tcStr);
    Endereco.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero'), tcStr);
    Endereco.Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('complemento'), tcStr);
    Endereco.Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('bairro'), tcStr);
    Endereco.xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cidade'), tcStr);
    Endereco.UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('uf'), tcStr);
    Endereco.CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cep'), tcStr);

    Tomador.Contato.Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('email'), tcStr);
  end;
end;

procedure TNFSeR_Prescon.LerDadosLocalServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Endereco: TEndereco;
begin
  AuxNode := ANode.Childrens.FindAnyNs('DadosPrestador');

  if Assigned(AuxNode) then
  begin
    Endereco := NFSe.ConstrucaoCivil.Endereco;
    Endereco.Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('logradouro'), tcStr);
    Endereco.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero'), tcStr);
    Endereco.Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('complemento'), tcStr);
    Endereco.Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('bairro'), tcStr);
    Endereco.xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cidade'), tcStr);
    Endereco.UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('uf'), tcStr);
    Endereco.CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cep'), tcStr);
    Endereco.xPais := ObterConteudo(AuxNode.Childrens.FindAnyNs('pais'), tcStr);
  end;
end;

procedure TNFSeR_Prescon.LerDetalhesServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Servico: TDadosServico;
  str: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('DetalhesServico');

  if Assigned(AuxNode) then
  begin
    Servico := NFSe.Servico;
    Servico.ItemListaServico := ObterConteudo(AuxNode.Childrens.FindAnyNs('codigo'), tcStr);
    Servico.Discriminacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('descricao'), tcStr);
    Servico.Discriminacao := StringReplace(Servico.Discriminacao, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

    VerificarSeConteudoEhLista(Servico.Discriminacao);

    Servico.Valores.ValorServicos := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorServico'), tcDe2);

    Servico.Valores.Aliquota := ObterConteudo(AuxNode.Childrens.FindAnyNs('aliquota'), tcDe2);

    str := ObterConteudo(AuxNode.Childrens.FindAnyNs('aliquota'), tcStr);
    str := FastStringReplace(str,'%','',[rfReplaceAll]);
    str := FastStringReplace(str,'.',',',[rfReplaceAll]);
    Servico.Valores.Aliquota := StrToFloatDef(str, 0);

    Servico.Valores.ValorInss := ObterConteudo(AuxNode.Childrens.FindAnyNs('inss'), tcDe2);
    Servico.Valores.ValorIr := ObterConteudo(AuxNode.Childrens.FindAnyNs('ir'), tcDe2);
    Servico.Valores.ValorCsll := ObterConteudo(AuxNode.Childrens.FindAnyNs('csll'), tcDe2);
    Servico.Valores.ValorCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('cofins'), tcDe2);
    Servico.Valores.ValorPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('pispasep'), tcDe2);

    Servico.Valores.RetencoesFederais := Servico.Valores.ValorPis +
                                         Servico.Valores.ValorCofins +
                                         Servico.Valores.ValorInss +
                                         Servico.Valores.ValorIr +
                                         Servico.Valores.ValorCsll;

          if ObterConteudo(AuxNode.Childrens.FindAnyNs('issretido'), tcStr) = '0' then
      NFSe.Servico.Valores.IssRetido := stNormal
    else
      NFSe.Servico.Valores.IssRetido := stRetencao;

    NFSe.OutrasInformacoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('obs'), tcStr);
    NFSe.OutrasInformacoes := StringReplace(NFSe.OutrasInformacoes, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);
  end;
end;

procedure TNFSeR_Prescon.LerTotais(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Servico: TDadosServico;
  DeducaoMaterial: TDeducaoCollectionItem;
  valor: double;
begin
  AuxNode := ANode.Childrens.FindAnyNs('Totais');

  if Assigned(AuxNode) then
  begin
    Servico := NFSe.Servico;
    Servico.Valores.DescontoCondicionado := ObterConteudo(AuxNode.Childrens.FindAnyNs('descontoCondicional'), tcDe2);
    Servico.Valores.DescontoIncondicionado := ObterConteudo(AuxNode.Childrens.FindAnyNs('descontoIncondicional'), tcDe2);
    Servico.Valores.ValorDeducoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorDeducao'), tcDe2);
    Servico.Valores.BaseCalculo := ObterConteudo(AuxNode.Childrens.FindAnyNs('BaseCalculo'), tcDe2);
    Servico.Valores.ValorIss := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorIss'), tcDe2);
    Servico.Valores.ValorServicos := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorLiquidoNota'), tcDe2);

    valor := ObterConteudo(AuxNode.Childrens.FindAnyNs('deducaoMaterial'), tcDe2);
    if valor > 0 then
    begin
      DeducaoMaterial := Servico.Deducao.New;
      DeducaoMaterial.TipoDeducao := tdMateriais;
      DeducaoMaterial.ValorDeduzir := valor;
    end;
  end;
end;

end.
