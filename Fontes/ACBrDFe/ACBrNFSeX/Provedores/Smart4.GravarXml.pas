{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
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

unit Smart4.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml;

type
  { Provedor com layout pr�prio }
  { TNFSeW_Smart4 }

  TNFSeW_Smart4 = class(TNFSeWClass)
  protected
    function GerarTomador: TACBrXmlNode;
    function GerarImpostos: TACBrXmlNode;

    function GerarServicos: TACBrXmlNode;
    function GerarServico: TACBrXmlNodeArray;
  public
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrNFSeXConsts,
  ACBrNFSeXConversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Smart4
//==============================================================================

{ TNFSeW_Smart4 }

function TNFSeW_Smart4.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
begin
  Configuracao;

  ListaDeAlertas.Clear;

  FDocument.Clear();

  NFSeNode := CreateElement('NOTA');

  FDocument.Root := NFSeNode;

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'RPS', 1, 15, 1,
                                             NFSe.IdentificacaoRps.Numero, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'LOTE', 1, 15, 1,
                                                          NFSe.NumeroLote, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'DATAEMISSAO', 1, 10, 1,
                           FormatDateTime('dd/MM/yyyy', NFSe.DataEmissao), ''));

  NFSeNode.AppendChild(AddNode(tcHor, '#1', 'HORAEMISSAO', 1, 10, 1,
                                                         NFSe.DataEmissao, ''));

  if NFSe.Servico.CodigoMunicipio = IntToStr(NFSe.Servico.MunicipioIncidencia) then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'LOCAL', 1, 1, 1, 'D', ''))
  else
  begin
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'LOCAL', 1, 1, 1, 'F', ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'UFFORA', 1, 1, 1,
                                                 NFSe.Servico.UFPrestacao, ''));
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'MUNICIPIOFORA', 1, 1, 1,
                               IntToStr(NFSe.Servico.MunicipioIncidencia), ''));

//    Gerador.wCampo(tcStr, '', 'PAISFORA', 1, 1, 1, '1', '');
  end;

  NFSeNode.AppendChild(AddNode(tcInt, '#1', 'SITUACAO', 1, 4, 1,
                                                            NFSe.Situacao, ''));

  if NFSe.Servico.Valores.IssRetido = stRetencao then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'RETIDO', 1, 1, 1, 'S', ''))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'RETIDO', 1, 1, 1, 'N', ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'ATIVIDADE', 1, 10, 1,
                                            NFSe.Servico.CodigoCnae, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ALIQUOTAAPLICADA', 1, 5, 1,
                                            NFSe.Servico.Valores.Aliquota, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'DEDUCAO', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorDeducoes, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'IMPOSTO', 1, 15, 1,
                                NFSe.Servico.Valores.valorOutrasRetencoes, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'RETENCAO', 1, 15, 1,
                                      NFSe.Servico.Valores.ValorIssRetido, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'OBSERVACAO', 1, 1000, 0,
                                               NFSe.Servico.Discriminacao, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'DEDMATERIAIS', 1, 1, 1, 'S', ''));

  NFSeNode.AppendChild(GerarTomador);
  NFSeNode.AppendChild(GerarImpostos);

  xmlNode := GerarServicos;
  NFSeNode.AppendChild(xmlNode);




//  NFSeNode.AppendChild(AddNode(tcDatVcto, '#1', 'DATAVENCIMENTO', 1, 10, 0,
//                                                          NFSe.Vencimento, ''));

  Result := True;
end;

function TNFSeW_Smart4.GerarTomador: TACBrXmlNode;
begin
  Result := CreateElement('TOMADOR');

  if Length(Trim(NFSe.Tomador.IdentificacaoTomador.CpfCnpj)) = 11 then
    Result.AppendChild(AddNode(tcStr, '#1', 'NATUREZA', 1, 1, 1, 'F', ''))
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'NATUREZA', 1, 1, 1, 'J', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CPFCNPJ', 1, 14, 1,
                                NFSe.Tomador.IdentificacaoTomador.CpfCnpj, ''));

//  Result.AppendChild(AddNode(tcStr, '#1', 'RGIE', 1, 14, 1,
//                      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'NOMERAZAO', 1, 60, 1,
                                                 NFSe.Tomador.RazaoSocial, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'NOMEFANTASIA', 1, 60, 0,
                                                 NFSe.Tomador.NomeFantasia, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'MUNICIPIO', 1, 7, 1,
                                    NFSe.Tomador.Endereco.CodigoMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'BAIRRO', 1, 60, 1,
                                             NFSe.Tomador.Endereco.Bairro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 1, 10, 1,
                                                NFSe.Tomador.Endereco.CEP, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'PREFIXO', 1, 10, 1,
                                     NFSe.Tomador.Endereco.TipoLogradouro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'LOGRADOURO', 1, 60, 1,
                                           NFSe.Tomador.Endereco.Endereco, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'COMPLEMENTO', 1, 60, 1,
                                        NFSe.Tomador.Endereco.Complemento, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'NUMERO', 1, 10, 1,
                                             NFSe.Tomador.Endereco.Numero, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'DENTROPAIS', 1, 1, 1, 'S', ''));

//  Result.AppendChild(AddNode(tcStr, '#1', 'EMAIL', 1, 100, 1,
//                                             NFSe.Tomador.Contato.Email, ''));
end;

function TNFSeW_Smart4.GerarImpostos: TACBrXmlNode;
begin
  Result := CreateElement('IMPOSTOS');

  Result.AppendChild(AddNode(tcStr, '#1', 'RESPONSAVELIMPOSTO', 1, 1, 1,
                                            'P', ''));  // P ou T

  Result.AppendChild(AddNode(tcDe2, '#1', 'PIS', 1, 15, 1,
                                            NFSe.Servico.Valores.ValorPis, ''));

//  if NFSe.Servico.Valores.ValorPis > 0 then
//    Result.AppendChild(AddNode(tcStr, '#1', 'RETPIS', 1, 1, 1, 'S', ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'COFINS', 1, 15, 1,
                                         NFSe.Servico.Valores.ValorCofins, ''));

//  if NFSe.Servico.Valores.ValorCofins > 0 then
//    Result.AppendChild(AddNode(tcStr, '#1', 'RETCOFINS', 1, 1, 1, 'S', ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'INSS', 1, 15, 1,
                                           NFSe.Servico.Valores.ValorInss, ''));

//  if NFSe.Servico.Valores.ValorInss > 0 then
//    Result.AppendChild(AddNode(tcStr, '#1', 'RETINSS', 1, 1, 1, 'S', ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'IR', 1, 15, 1,
                                             NFSe.Servico.Valores.ValorIr, ''));

//  if NFSe.Servico.Valores.ValorIr > 0 then
//    Result.AppendChild(AddNode(tcStr, '#1', 'RETIR', 1, 1, 1, 'S', ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'CSLL', 1, 15, 1,
                                           NFSe.Servico.Valores.ValorCsll, ''));

//  if NFSe.Servico.Valores.ValorCsll > 0 then
//    Result.AppendChild(AddNode(tcStr, '#1', 'RETCSLL', 1, 1, 1, 'S', ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'OUTRASRETENCOES', 1, 15, 1,
                                NFSe.Servico.Valores.ValorOutrasRetencoes, ''));
end;

function TNFSeW_Smart4.GerarServicos: TACBrXmlNode;
var
  i : integer;
  nodeArray: TACBrXmlNodeArray;
begin
  Result := CreateElement('SERVICOS');

  nodeArray := GerarServico;
  if nodeArray <> nil then
  begin
    for i := 0 to Length(nodeArray) - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

function TNFSeW_Smart4.GerarServico: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.Servico.ItemServico.Count);

  for i := 0 to NFSe.Servico.ItemServico.Count - 1 do
  begin
    Result[i] := CreateElement('SERVICO');

    Result[i].AppendChild(AddNode(tcStr, '#1', 'SERVDESCRICAO', 1, 60, 1,
                              NFSe.Servico.ItemServico.Items[i].Descricao, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#1', 'SERVVALORUNIT', 1, 15, 1,
                          NFSe.Servico.ItemServico.Items[i].ValorUnitario, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#1', 'SERVQUANTIDADE', 1, 10, 1,
                             NFSe.Servico.ItemServico.Items[i].Quantidade, ''));

//    Result[i].AppendChild(AddNode(tcDe2, '#1', 'DESCONTO', 1, 10, 1,
//                 NFSe.Servico.ItemServico.Items[i].DescontoIncondicionado, ''));
  end;

  if NFSe.Servico.ItemServico.Count > 10 then
    wAlerta('#54', 'SERVICO', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

end.
