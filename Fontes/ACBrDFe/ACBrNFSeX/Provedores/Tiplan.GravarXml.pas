{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit Tiplan.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrNFSeXGravarXml_ABRASFv1,
  ACBrNFSeXGravarXml_ABRASFv2,
  ACBrDFe.Conversao,
  ACBrNFSeXConversao,
  ACBrXmlDocument,
  PadraoNacional.GravarXml;

type
  { TNFSeW_Tiplan }
  TNFSeW_Tiplan = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

  end;

  { TNFSeW_Tiplan203 }
  TNFSeW_Tiplan203 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;
    function DefinirNameSpaceDeclaracao: string; override;
    function GerarTomador: TACBrXmlNode; override;
    function GerarValores: TACBrXmlNode; override;
    function GerarServico: TACBrXmlNode; override;
  end;

  TNFSeW_TiplanAPIPropria = class(TNFSeW_PadraoNacional)
  protected

  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrXmlBase,
  ACBrNFSeXConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Tiplan
//==============================================================================

{ TNFSeW_Tiplan }

procedure TNFSeW_Tiplan.Configuracao;
begin
  inherited Configuracao;

  FormatoItemListaServico := filsSemFormatacao;
end;

procedure TNFSeW_Tiplan203.Configuracao;
begin
  inherited Configuracao;
end;

function TNFSeW_Tiplan203.DefinirNameSpaceDeclaracao: string;
begin
  Result := 'http://www.abrasf.org.br/nfse.xsd';
end;

function TNFSeW_Tiplan203.GerarTomador: TACBrXmlNode;
var
  tomadorIdentificado, tipoPessoa, item, cnpjCpfDestinatario,
  xCidade, xUF: string;
begin
  Result := inherited GerarTomador;

  {tomadorIdentificado := '0';
  cnpjCpfDestinatario := NFSe.Tomador.IdentificacaoTomador.CpfCnpj;

  if NFSe.Tomador.IdentificacaoTomador.Nif <> '' then
  begin
    tomadorIdentificado := '1';
    cnpjCpfDestinatario := NFSe.Tomador.IdentificacaoTomador.Nif;
  end;

  Result.AppendChild(AddNode(tcStr, '#38', 'MotivoNifNaoInformado', 1, 1, 1,
                             tomadorIdentificado, ''));}
end;

function TNFSeW_Tiplan203.GerarValores: TACBrXmlNode;
begin
  Result := inherited GerarValores;

  if (Result <> nil) and not
     (NFSe.Servico.Valores.tribFed.CST in [cstVazio, cst00, cst08, cst09]) then
  begin
    Result.AppendChild(AddNode(tcStr, '#', 'SituacaoTributariaPISCOFINS', 2, 2, 1,
                               CSTToStr(NFSe.Servico.Valores.tribFed.CST), ''));
  end;
end;


function TNFSeW_Tiplan203.GerarServico: TACBrXmlNode;
var
  item: string;
  NodeIBSCBS, NodeValoresTrib: TACBrXmlNode;
begin
  Result := CreateElement('Servico');

  Result.AppendChild(GerarValores);

  if GerarTagServicos then
  begin
    Result.AppendChild(AddNode(tcStr, '#20', 'IssRetido', 1, 1, NrOcorrIssRetido,
      FpAOwner.SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), DSC_INDISSRET));

    Result.AppendChild(AddNode(tcStr, '#21', 'ResponsavelRetencao', 1, 1, NrOcorrRespRetencao,
     FpAOwner.ResponsavelRetencaoToStr(NFSe.Servico.ResponsavelRetencao), DSC_INDRESPRET));

    item := FormatarItemServico(NFSe.Servico.ItemListaServico, FormatoItemListaServico);

    Result.AppendChild(AddNode(tcStr, '#29', 'ItemListaServico', 1, 8, NrOcorrItemListaServico,
                                                          item, DSC_CLISTSERV));

    Result.AppendChild(AddNode(tcStr, '#30', 'CodigoCnae', 1, 9, NrOcorrCodigoCNAE,
                                OnlyNumber(NFSe.Servico.CodigoCnae), DSC_CNAE));

    Result.AppendChild(AddNode(tcStr, '#31', 'CodigoTributacaoMunicipio', 1, 20, NrOcorrCodTribMun_1,
                     NFSe.Servico.CodigoTributacaoMunicipio, DSC_CSERVTRIBMUN));

    Result.AppendChild(AddNode(tcStr, '#32', 'CodigoNbs', 1, 9, NrOcorrCodigoNBS,
                                 OnlyNumber(NFSe.Servico.CodigoNBS), DSC_CMUN));

    Result.AppendChild(AddNode(tcStr, '#32', 'Discriminacao', 1, 2000, NrOcorrDiscriminacao_1,
      StringReplace(NFSe.Servico.Discriminacao, Opcoes.QuebraLinha,
               FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), DSC_DISCR));

    Result.AppendChild(AddNode(tcStr, '#33', 'CodigoMunicipio', 1, 7, NrOcorrCodigoMunic_1,
                           OnlyNumber(NFSe.Servico.CodigoMunicipio), DSC_CMUN));

    Result.AppendChild(AddNode(tcStr, '#31', 'CodigoTributacaoMunicipio', 1, 20, NrOcorrCodTribMun_2,
                     NFSe.Servico.CodigoTributacaoMunicipio, DSC_CSERVTRIBMUN));

    Result.AppendChild(AddNode(tcStr, '#31', 'CodigoServicoNacional', 1, 20, 0,
                                       NFSe.Servico.CodigoServicoNacional, ''));

    Result.AppendChild(AddNode(tcStr, '#33', 'Discriminacao', 1, 2000, NrOcorrDiscriminacao_2,
      StringReplace(NFSe.Servico.Discriminacao, Opcoes.QuebraLinha,
               FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), DSC_DISCR));

    Result.AppendChild(AddNode(tcStr, '#34', 'CodigoMunicipio', 1, 7, NrOcorrCodigoMunic_2,
                           OnlyNumber(NFSe.Servico.CodigoMunicipio), DSC_CMUN));

    Result.AppendChild(GerarCodigoPaisServico);

    Result.AppendChild(AddNode(tcInt, '#36', 'ExigibilidadeISS',
                               NrMinExigISS, NrMaxExigISS, NrOcorrExigibilidadeISS,
    StrToInt(FpAOwner.ExigibilidadeISSToStr(NFSe.Servico.ExigibilidadeISS)), DSC_INDISS));

    Result.AppendChild(AddNode(tcStr, '#9', 'OutrasInformacoes', 0, 255, NrOcorrOutrasInformacoes_2,
      StringReplace(NFSe.OutrasInformacoes, Opcoes.QuebraLinha,
           FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), DSC_OUTRASINF));

    Result.AppendChild(AddNode(tcInt, '#37', 'MunicipioIncidencia', 7, 7, NrOcorrMunIncid,
                                NFSe.Servico.MunicipioIncidencia, DSC_MUNINCI));


    Result.AppendChild(AddNode(tcStr, '#38', 'NumeroProcesso', 1, 30, NrOcorrNumProcesso,
                                   NFSe.Servico.NumeroProcesso, DSC_NPROCESSO));

    Result.AppendChild(AddNode(tcStr, '#39', 'InfAdicional', 1, 255, NrOcorrInfAdicional,
                                  NFSe.Servico.InfAdicional, DSC_INFADICIONAL));

    // Reforma Tributária
    if (NFSe.IBSCBS.dest.xNome <> '') or
       (NFSe.IBSCBS.valores.trib.gIBSCBS.cClassTrib <> '') then
    begin
      NodeIBSCBS := CreateElement('IBSCBS');

      NodeIBSCBS.AppendChild(AddNode(tcStr, '#', 'OperacaoUsoConsumoPessoal', 1, 1, 1,
                              TIndicadorToStr(NFSe.IBSCBS.ConsumoPessoal), ''));

      NodeIBSCBS.AppendChild(AddNode(tcStr, '#', 'Operacao', 6, 6, 1,
                                                       NFSe.IBSCBS.cIndOp, ''));

      NodeValoresTrib := CreateElement('ValoresTributos');

      NodeValoresTrib.AppendChild(AddNode(tcStr, '#', 'SituacaoTributaria', 3, 3, 1,
                     CSTIBSCBSToStr(NFSe.IBSCBS.Valores.Trib.gIBSCBS.CST), ''));

      NodeValoresTrib.AppendChild(AddNode(tcStr, '#', 'ClassificacaoTributaria', 6, 6, 1,
                              NFSe.IBSCBS.Valores.Trib.gIBSCBS.cClassTrib, ''));

      NodeIBSCBS.AppendChild(NodeValoresTrib);

      Result.AppendChild(NodeIBSCBS);
    end;

    Result.AppendChild(GerarListaItensServico);
  end;
end;


{function TNFSeW_Tiplan203.GerarServico: TACBrXmlNode;
var
  NodeIBSCBS, NodeValoresTrib: TACBrXmlNode;
begin
  // Gera o nó padrão de Serviço (ABRASF 2.03)
  Result := inherited GerarServico;

  if Result <> nil then
  begin
    // Reforma Tributária
    if (NFSe.IBSCBS.dest.xNome <> '') or
       (NFSe.IBSCBS.valores.trib.gIBSCBS.cClassTrib <> '') then
    begin
      NodeIBSCBS := CreateElement('IBSCBS');

      NodeIBSCBS.AppendChild(AddNode(tcStr, '#', 'OperacaoUsoConsumoPessoal', 1, 1, 1,
                                     TIndicadorToStr(NFSe.IBSCBS.ConsumoPessoal), ''));

      NodeIBSCBS.AppendChild(AddNode(tcStr, '#', 'Operacao', 6, 6, 1,
                                     NFSe.IBSCBS.cIndOp, ''));

      NodeValoresTrib := CreateElement('ValoresTributos');

      NodeValoresTrib.AppendChild(AddNode(tcStr, '#', 'SituacaoTributaria', 3, 3, 1,
                                          NFSe.IBSCBS.Valores.Trib.gIBSCBS.CST, ''));

      NodeValoresTrib.AppendChild(AddNode(tcStr, '#', 'ClassificacaoTributaria', 6, 6, 1,
                                          NFSe.IBSCBS.Valores.Trib.gIBSCBS.cClassTrib, ''));

      NodeIBSCBS.AppendChild(NodeValoresTrib);

      Result.AppendChild(NodeIBSCBS);
    end;
  end;
end;}

end.


