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

unit EloTech.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrUtil.Strings,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml_ABRASFv2;

type
  { TNFSeW_Elotech203 }

  TNFSeW_Elotech203 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

    function GerarListaItensServico: TACBrXmlNode; override;
    function GerarItemServico: TACBrXmlNodeArray; override;
    function GerarDadosDeducao(Item: Integer): TACBrXmlNode;
  end;

implementation

uses
  ACBrNFSeXConsts,
  ACBrNFSeXConversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     EloTech
//     Chave de Acesso tem que ter 32 caracteres.
//==============================================================================

{ TNFSeW_Elotech203 }

procedure TNFSeW_Elotech203.Configuracao;
begin
  inherited Configuracao;

  NrOcorrCodigoMunic_2 := 1;
  NrOcorrOptanteSimplesNacional := -1;
  NrOcorrItemListaServico := -1;
  NrOcorrCodigoCNAE := -1;
  NrOcorrCodTribMun_1 := -1;
  NrOcorrCodigoMunic_1 := -1;

  FormatoItemListaServico := filsSemFormatacao;
  NrOcorrRespRetencao := -1;
  NrOcorrValorDeducoes := 1;
  NrOcorrDescIncond := 1;
  NrOcorrDescCond := 1;
  NrOcorrOutrasRet := 1;

  NrOcorrAliquotaPis := 1;
  NrOcorrRetidoPis := 1;
  NrOcorrAliquotaCofins := 1;
  NrOcorrRetidoCofins := 1;
  NrOcorrAliquotaInss := 1;
  NrOcorrRetidoInss := 1;
  NrOcorrAliquotaIr := 1;
  NrOcorrRetidoIr := 1;
  NrOcorrAliquotaCsll := 1;
  NrOcorrRetidoCsll := 1;
  NrOcorrInscEstTomador_2 := 0;
  NrOcorrValorCpp := 0;
  NrOcorrAliquotaCpp := 0;
  NrOcorrRetidoCpp := 0;

  GerarIDDeclaracao := False;
end;

function TNFSeW_Elotech203.GerarDadosDeducao(Item: Integer): TACBrXmlNode;
var
  aDoc: string;
begin
  Result := nil;

  if NFSe.Servico.ItemServico[Item].DadosDeducao.TipoDeducao = tdNenhum then
    Exit;

  Result := CreateElement('DadosDeducao');

  Result.AppendChild(AddNode(tcStr, '#', 'TipoDeducao', 1, 1, 1,
    FpAOwner.TipoDeducaoToStr(NFSe.Servico.ItemServico[Item].DadosDeducao.TipoDeducao)));

  aDoc := OnlyNumber(NFSe.Servico.ItemServico[Item].DadosDeducao.CpfCnpj);

  if length(aDoc) <= 11 then
    Result.AppendChild(AddNode(tcStr, '#', 'Cpf ', 11, 11, 1, aDoc, DSC_CPF))
  else
    Result.AppendChild(AddNode(tcStr, '#', 'Cnpj', 14, 14, 1, aDoc, DSC_CNPJ));

  Result.AppendChild(AddNode(tcStr, '#', 'NumeroNotaFiscalReferencia', 1, 15, 0,
       NFSe.Servico.ItemServico[Item].DadosDeducao.NumeroNotaFiscalReferencia));

  Result.AppendChild(AddNode(tcDe2, '#', 'ValorTotalNotaFiscal', 1, 15, 1,
             NFSe.Servico.ItemServico[Item].DadosDeducao.ValorTotalNotaFiscal));

  Result.AppendChild(AddNode(tcDe2, '#', 'PercentualADeduzir', 1, 15, 0,
               NFSe.Servico.ItemServico[Item].DadosDeducao.PercentualADeduzir));

  Result.AppendChild(AddNode(tcDe2, '#', 'ValorADeduzir', 1, 15, 0,
                    NFSe.Servico.ItemServico[Item].DadosDeducao.ValorADeduzir));
end;

function TNFSeW_Elotech203.GerarItemServico: TACBrXmlNodeArray;
var
  i: integer;
  item: string;
begin
  Result := nil;
  SetLength(Result, NFSe.Servico.ItemServico.Count);

  for i := 0 to NFSe.Servico.ItemServico.Count - 1 do
  begin
    Result[i] := CreateElement('ItemServico');

    item := FormatarItemServico(NFSe.Servico.ItemServico[i].ItemListaServico, FormatoItemListaServico);

    Result[i].AppendChild(AddNode(tcStr, '#', 'ItemListaServico', 1, 6, 1,
                                                          item, DSC_CLISTSERV));

    Result[i].AppendChild(AddNode(tcStr, '#', 'CodigoCnae', 1, 7, 0,
                                       NFSe.Servico.ItemServico[i].CodigoCnae));

    Result[i].AppendChild(AddNode(tcStr, '#', 'Descricao', 1, 4000, 0,
                                        NFSe.Servico.ItemServico[i].Descricao));

    Result[i].AppendChild(AddNode(tcStr, '#', 'Tributavel', 1, 1, 0,
                 FpAOwner.SimNaoToStr(NFSe.Servico.ItemServico[i].Tributavel)));

    Result[i].AppendChild(AddNode(tcDe2, '#', 'Quantidade', 1, 17, 1,
                                       NFSe.Servico.ItemServico[i].Quantidade));

    Result[i].AppendChild(AddNode(tcDe2, '#', 'ValorUnitario', 1, 17, 1,
                                    NFSe.Servico.ItemServico[i].ValorUnitario));

    Result[i].AppendChild(AddNode(tcDe2, '#', 'ValorDesconto', 1, 17, 1,
                             NFSe.Servico.ItemServico[i].DescontoIncondicionado));

    Result[i].AppendChild(AddNode(tcDe2, '#', 'ValorLiquido', 1, 17, 1,
                                       NFSe.Servico.ItemServico[i].ValorTotal));

    Result[i].AppendChild(GerarDadosDeducao(i));
  end;

  if NFSe.Servico.ItemServico.Count > 10 then
    wAlerta('#54', 'ItemServico', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

function TNFSeW_Elotech203.GerarListaItensServico: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := CreateElement('ListaItensServico');

  nodeArray := GerarItemServico;
  if nodeArray <> nil then
  begin
    for i := 0 to Length(nodeArray) - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

end.
