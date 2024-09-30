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

unit iiBrasil.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXGravarXml_ABRASFv2;

type
  { TNFSeW_iiBrasil204 }

  TNFSeW_iiBrasil204 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

    procedure DefinirIDRps; override;

    function GerarQuartos: TACBrXmlNode; override;
    function GerarQuarto: TACBrXmlNodeArray; override;
  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrNFSeXConsts,
  ACBrNFSeXConversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     iiBrasil
//==============================================================================

{ TNFSeW_iiBrasil204 }

procedure TNFSeW_iiBrasil204.Configuracao;
begin
  inherited Configuracao;

  FormatoAliq := tcDe2;
  TagTomador  := 'TomadorServico';

  NrOcorrAtualizaTomador := 1;
  NrOcorrTomadorExterior := 1;
  NrOcorrCodigoPaisServico := -1;
  NrOcorrCodigoPaisTomador := -1;
  NrOcorrExigibilidadeISS := -1;
  NrOcorrMunIncid := -1;
  NrOcorrRegimeEspecialTributacao := -1;
  NrOcorrOptanteSimplesNacional := -1;
  NrOcorrIncentCultural := -1;
end;

procedure TNFSeW_iiBrasil204.DefinirIDRps;
begin
  NFSe.InfID.ID := 'Rps' + OnlyNumber(NFSe.IdentificacaoRps.Numero) +
                    NFSe.IdentificacaoRps.Serie;
end;

function TNFSeW_iiBrasil204.GerarQuarto: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.Quartos.Count);

  for i := 0 to NFSe.Quartos.Count - 1 do
  begin
    Result[i] := CreateElement('Quarto');

    Result[i].AppendChild(AddNode(tcInt, '#1', 'CodigoInternoQuarto', 1, 9, 1,
                        NFSe.Quartos.Items[i].CodigoInternoQuarto, DSC_CODQRT));

    Result[i].AppendChild(AddNode(tcInt, '#2', 'QtdHospedes', 1, 9, 1,
                             NFSe.Quartos.Items[i].QtdHospedes, DSC_QTDHOSPDS));

    Result[i].AppendChild(AddNode(tcDat, '#3', 'CheckIn', 10, 10, 1,
                                   NFSe.Quartos.Items[i].CheckIn, DSC_CHECKIN));

    Result[i].AppendChild(AddNode(tcInt, '#3', 'QtdDiaria', 1, 9, 1,
                                NFSe.Quartos.Items[i].QtdDiarias, DSC_QTDDIAR));

    Result[i].AppendChild(AddNode(tcDe2, '#3', 'ValorDiaria', 1, 15, 1,
                                 NFSe.Quartos.Items[i].ValorDiaria, DSC_VDIAR));
  end;

  if NFSe.Quartos.Count > 999 then
    wAlerta('#54', 'Quarto', '', ERR_MSG_MAIOR_MAXIMO + '999');
end;

function TNFSeW_iiBrasil204.GerarQuartos: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := nil;

  if NFSe.Quartos.Count > 0 then
  begin
    Result := CreateElement('Quartos');

    nodeArray := GerarQuarto;

    if nodeArray <> nil then
    begin
      for i := 0 to Length(nodeArray) - 1 do
      begin
        Result.AppendChild(nodeArray[i]);
      end;
    end;
  end;
end;

end.
