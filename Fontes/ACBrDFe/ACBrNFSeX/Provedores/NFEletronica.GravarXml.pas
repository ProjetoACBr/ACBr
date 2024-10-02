{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit NFEletronica.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrNFSeXGravarXml_ABRASFv1;

type
  { TNFSeW_NFEletronica }

  TNFSeW_NFEletronica = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     NFEletronica
//==============================================================================

{ TNFSeW_NFEletronica }

procedure TNFSeW_NFEletronica.Configuracao;
begin
  inherited Configuracao;

  {
     Todos os par�metros de configura��o est�o com os seus valores padr�es.

     Se a configura��o padr�o atende o provedor ela pode ser excluida dessa
     procedure.

     Portanto deixe somente os par�metros de configura��o que foram alterados
     para atender o provedor.
  }

  // Propriedades de Formata��o de informa��es
  // elas requerem que seja declarado em uses a unit: ACBrXmlBase
  {
  FormatoEmissao     := tcDatHor;
  FormatoCompetencia := tcDatHor;

  FormatoAliq := tcDe4;
  }

  // elas requerem que seja declarado em uses a unit: ACBrNFSeXConversao
  {
  // filsComFormatacao, filsSemFormatacao, filsComFormatacaoSemZeroEsquerda
  FormatoItemListaServico := filsComFormatacao;
  }

  DivAliq100  := False;

  NrMinExigISS := 1;
  NrMaxExigISS := 1;

  // Numero de Ocorrencias Minimas de uma tag
  // se for  0 s� gera a tag se o conteudo for diferente de vazio ou zero
  // se for  1 sempre vai gerar a tag
  // se for -1 nunca gera a tag

  // Por padr�o as tags abaixo s�o opcionais
  NrOcorrComplTomador := 0;
  NrOcorrFoneTomador := 0;
  NrOcorrEmailTomador := 0;
  NrOcorrOutrasRet := 0;
  NrOcorrAliquota := 0;
  NrOcorrValorPis := 0;
  NrOcorrValorCofins := 0;
  NrOcorrValorInss := 0;
  NrOcorrValorIr := 0;
  NrOcorrValorCsll := 0;
  NrOcorrValorIss := 0;
  NrOcorrBaseCalc := 0;
  NrOcorrDescIncond := 0;
  NrOcorrDescCond := 0;
  NrOcorrValLiq := 0;
  NrOcorrCodigoCnae := 0;
  NrOcorrCodTribMun := 0;
  NrOcorrMunIncid := 0;
  NrOcorrCodigoPaisTomador := 0;
  NrOcorrRazaoSocialInterm := 0;
  NrOcorrValorDeducoes := 0;
  NrOcorrValorISSRetido_1 := 0;
  NrOcorrInscMunTomador := 0;

  // Por padr�o as tags abaixo s�o obrigat�rias
  NrOcorrOptanteSN := 1;
  NrOcorrIncentCult := 1;
  NrOcorrStatus := 1;
  NrOcorrItemListaServico := 1;
  NrOcorrNaturezaOperacao := 1;

  // Por padr�o as tags abaixo n�o devem ser geradas
  NrOcorrRespRetencao := -1;
  NrOcorrIdCidade := -1;
  NrOcorrValorISSRetido_2 := -1;
  NrOcorrValorTotalRecebido := -1;
  NrOcorrInscEstTomador := -1;
  NrOcorrOutrasInformacoes := -1;
  NrOcorrInformacoesComplemetares := -1;
  NrOcorrRegimeEspecialTributacao := -1;
end;

end.
