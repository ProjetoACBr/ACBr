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

unit MegaSoft.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml_ABRASFv2, ACBrNFSeXConversao;

type
  { TNFSeW_MegaSoft200 }

  TNFSeW_MegaSoft200 = class(TNFSeW_ABRASFv2)
  protected
    function GerarContatoTomador: TACBrXmlNode; override;
    function GerarStatus: TACBrXmlNode; override;

    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     MegaSoft
//==============================================================================

{ TNFSeW_MegaSoft200 }

procedure TNFSeW_MegaSoft200.Configuracao;
begin
  inherited Configuracao;

  FormatoEmissao := tcDatHor;
  FormatoCompetencia := tcDatHor;

  NrOcorrCodTribMun_2 := 0;
  NrOcorrInfAdicional := 0;
  NrOcorrCepTomador_2 := 0;

  NrOcorrDiscriminacao_2 := 1;

  NrOcorrSerieRPS := -1;
  NrOcorrTipoRPS := -1;
  NrOcorrUFTomador := -1;
  NrOcorrCodigoPaisServico := -1;
  NrOcorrCodigoPaisTomador := -1;
  NrOcorrCepTomador := -1;
  NrOcorrValorISS := -1;
  NrOcorrCompetencia := -1;
  NrOcorrRegimeEspecialTributacao := -1;
  NrOcorrOptanteSimplesNacional := -1;
  NrOcorrIncentCultural := -1;
  NrOcorrItemListaServico := -1;
  NrOcorrCodigoCNAE := -1;
  NrOcorrCodTribMun_1 := -1;
  NrOcorrDiscriminacao_1 := -1;
  NrOcorrExigibilidadeISS := -1;
  NrOcorrMunIncid := -1;
  NrOcorrRespRetencao := -1;
end;

function TNFSeW_MegaSoft200.GerarContatoTomador: TACBrXmlNode;
begin
  Result := nil;
end;

function TNFSeW_MegaSoft200.GerarStatus: TACBrXmlNode;
begin
  Result := nil;
end;

end.
