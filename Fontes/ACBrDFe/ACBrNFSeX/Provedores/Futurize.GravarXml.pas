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

unit Futurize.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlDocument,
  ACBrNFSeXGravarXml_ABRASFv2;

type
  { TNFSeW_Futurize202 }

  TNFSeW_Futurize202 = class(TNFSeW_ABRASFv2)
  protected
    function GerarServico: TACBrXmlNode; override;

  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrNFSeXConsts,
  ACBrUtil.Strings;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Futurize
//==============================================================================

{ TNFSeW_Futurize202 }

function TNFSeW_Futurize202.GerarServico: TACBrXmlNode;
begin
  Result := CreateElement('Servico');

  Result.AppendChild(GerarValores);

  Result.AppendChild(AddNode(tcStr, '#20', 'IssRetido', 1, 1, 1,
      FpAOwner.SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), DSC_INDISSRET));

  Result.AppendChild(AddNode(tcStr, '#21', 'ResponsavelRetencao', 1, 1, 0,
     FpAOwner.ResponsavelRetencaoToStr(NFSe.Servico.ResponsavelRetencao), DSC_INDRESPRET));

  Result.AppendChild(AddNode(tcStr, '#30', 'CodigoCnae', 1, 9, 0,
                                OnlyNumber(NFSe.Servico.CodigoCnae), DSC_CNAE));

  Result.AppendChild(AddNode(tcStr, '#31', 'CodigoTributacaoMunicipio', 1, 20, 0,
                     NFSe.Servico.CodigoTributacaoMunicipio, DSC_CSERVTRIBMUN));

  Result.AppendChild(AddNode(tcStr, '#32', 'Discriminacao', 1, 2000, 1,
      StringReplace(NFSe.Servico.Discriminacao, Opcoes.QuebraLinha,
               FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), DSC_DISCR));

  Result.AppendChild(AddNode(tcStr, '#33', 'CodigoMunicipio', 1, 7, 1,
                           OnlyNumber(NFSe.Servico.CodigoMunicipio), DSC_CMUN));

  Result.AppendChild(AddNode(tcInt, '#35', 'CodigoPais', 4, 4, 0,
                                           NFSe.Servico.CodigoPais, DSC_CPAIS));

  Result.AppendChild(AddNode(tcInt, '#36', 'ExigibilidadeISS', 1, 1, 1,
    StrToInt(FpAOwner.ExigibilidadeISSToStr(NFSe.Servico.ExigibilidadeISS)), DSC_INDISS));

  Result.AppendChild(AddNode(tcInt, '#37', 'MunicipioIncidencia', 7, 7, 0,
                                NFSe.Servico.MunicipioIncidencia, DSC_MUNINCI));

  Result.AppendChild(AddNode(tcStr, '#38', 'NumeroProcesso', 1, 30, 0,
                                   NFSe.Servico.NumeroProcesso, DSC_NPROCESSO));

  Result.AppendChild(AddNode(tcStr, '#38', 'CTribNac', 6, 6, 1,
                                            NFSe.Servico.ItemListaServico, ''));

  Result.AppendChild(AddNode(tcStr, '#32', 'cNBS', 1, 9, 1,
                                             NFSe.Servico.CodigoNBS, DSC_CMUN));
end;

end.
