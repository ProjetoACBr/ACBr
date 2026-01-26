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

unit GovDigital.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlDocument,
  ACBrUtil.Strings,
  ACBrDFe.Conversao,
  ACBrNFSeXConversao,
  ACBrNFSeXGravarXml_ABRASFv2;

type
  { TNFSeW_GovDigital200 }

  TNFSeW_GovDigital200 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

    function GerarServico: TACBrXmlNode; override;
    function GerarValores: TACBrXmlNode; override;

  end;

  { TNFSeW_GovDigital201 }

  TNFSeW_GovDigital201 = class(TNFSeW_GovDigital200)
  protected

  end;

implementation

uses
  ACBrNFSeXConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     GovDigital
//==============================================================================

{ TNFSeW_GovDigital200 }

procedure TNFSeW_GovDigital200.Configuracao;
begin
  inherited Configuracao;

  DivAliq100 := True;

  NrOcorrCodigoNBS := -1;

  if FpAOwner.ConfigGeral.Params.TemParametro('NaoDividir100') then
    DivAliq100 := False;
end;

function TNFSeW_GovDigital200.GerarServico: TACBrXmlNode;
var
  NrOcorrMunPrest: Integer;
begin
  Result := inherited GerarServico;

  NrOcorrMunPrest := 0;
  if NFSe.Servico.CodigoPais = 1058 then
    NrOcorrMunPrest := 1;

  Result.AppendChild(AddNode(tcInt, '#32', 'MunicipioPrestacao', 7, 7, NrOcorrMunPrest,
                               NFSe.Servico.CodigoMunicipioLocalPrestacao, ''));

  Result.AppendChild(AddNode(tcStr, '#41', 'PaisPrestacao', 4, 4, 0,
                                                  NFSe.Servico.CodigoPais, ''));

  Result.AppendChild(AddNode(tcStr, '#32', 'CodigoNBS', 1, 9, 0,
                                                   NFSe.Servico.CodigoNBS, ''));

  Result.AppendChild(AddNode(tcStr, '#32', 'CIndOp', 6, 6, 0,
                                                       NFSe.Servico.INDOP, ''));

  if NFSe.Servico.CodigoPais = 1058 then
    Result.AppendChild(AddNode(tcStr, '#32', 'CClassTribReg', 6, 6, 0,
                                                  NFSe.Servico.CClassTrib, ''));
end;

function TNFSeW_GovDigital200.GerarValores: TACBrXmlNode;
begin
  Result := inherited GerarValores;

  if (NFSe.Servico.Valores.ValorPis>0) or (NFSe.Servico.Valores.ValorCofins>0) then
  begin
    Result.AppendChild(AddNode(tcStr, '#1', 'CST', 2, 2, 0,
                                 CSTPisToStr(NFSe.Servico.Valores.CSTPis), ''));

    if not (StrToIntDef(CSTPisToStr(NFSe.Servico.Valores.CSTPis),0) in [0,8,9]) then
      Result.AppendChild(AddNode(tcStr, '#1', 'TpRetPisCofins', 1, 1, 0,
                 tpRetPisCofinsToStr(NFSe.Servico.Valores.tpRetPisCofins), ''));
  end;
end;

end.
