{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit Siappa.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { TNFSeR_Siappa }

  TNFSeR_Siappa = class(TNFSeRClass)
  protected
    procedure LerTomador(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime,
  ACBrNFSeXClass;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Siappa
//==============================================================================

{ TNFSeR_Siappa }

procedure TNFSeR_Siappa.LerTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode;

  with NFSe.Tomador do
  begin
    IdentificacaoTomador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_CPF_CNPJ'), tcStr);
    RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_NOME_RSO'), tcStr);

    Endereco.TipoLogradouro := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_END_TLG'), tcStr);
    Endereco.Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_END_LOG'), tcStr);
    Endereco.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_END_NRO'), tcStr);
    Endereco.Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_END_COM'), tcStr);
    Endereco.Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_END_BAI'), tcStr);
    Endereco.CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_END_CEP'), tcStr);
    Endereco.xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_END_CID'), tcStr);
    Endereco.UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_END_UF'), tcStr);
    Endereco.xPais := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_END_UF'), tcStr);

    Contato.Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_TOM_PAIS_NOM'), tcStr);
  end;
end;

function TNFSeR_Siappa.LerXml: Boolean;
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

  if (Pos('NFS_E_XML', Arquivo) > 0) then
    tpXML := txmlNFSe
  else
    tpXML := txmlRPS;

  XmlNode := Document.Root;

  if XmlNode = nil then
    raise Exception.Create('Arquivo xml vazio.');

  if tpXML = txmlNFSe then
    Result := LerXmlNfse(XmlNode)
  else
    Result := LerXmlRps(XmlNode);

  FreeAndNil(FDocument);
end;

function TNFSeR_Siappa.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;

  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('cabecalho');

  if AuxNode <> nil then
  begin
    NFSe.Prestador.IdentificacaoPrestador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cab_CNPJ'), tcStr);

    AuxNode := ANode.Childrens.FindAnyNs('Detalhes_NFS_e');

    if AuxNode <> nil then
      AuxNode := AuxNode.Childrens.FindAnyNs('Reg_NFS_E');
  end;

  if not Assigned(AuxNode) then Exit;

  with NFSe do
  begin
    DataEmissao := EncodeDataHora( ObterConteudoTag(AuxNode.Childrens.FindAnyNs('NFS_E_DATA_HORA_CAD'), tcStr),
                                   'DD/MM/YYYY HH:NN:SS' );
    Competencia := DataEmissao;
    Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_NRO'), tcStr);
    SeriePrestacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_SERIE'), tcStr);
    CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_COD_VALIDACAO'), tcStr);

    SituacaoNfse := snNormal;
    if ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_STATUS'), tcStr) = 'C' then
      SituacaoNfse := snCancelado;
  end;

  LerTomador(AuxNode);

  with NFSe.Servico do
  begin
    Discriminacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_DES_DET'), tcStr);
    Discriminacao := StringReplace(Discriminacao, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

    VerificarSeConteudoEhLista(Discriminacao);

    Valores.ValorServicos := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_VLR_BRUTO'), tcDe2);
    Valores.ValorIss := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_VLR_ISSQN'), tcDe2);
    Valores.BaseCalculo := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_VLR_BASE_CALC'), tcDe2);
    Valores.Aliquota := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_ALQ_APL'), tcDe2);
    Valores.ValorLiquidoNfse := Valores.ValorServicos;

    Valores.ValorTotalNotaFiscal := Valores.ValorServicos - Valores.DescontoCondicionado -
                                    Valores.DescontoIncondicionado;
  end;

  NFSe.OutrasInformacoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFS_E_DES_RES'), tcStr);
  NFSe.OutrasInformacoes := StringReplace(NFSe.OutrasInformacoes, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

  LerCampoLink;
end;

function TNFSeR_Siappa.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
begin
  Result := False;

  if not Assigned(ANode) then Exit;
end;

end.
