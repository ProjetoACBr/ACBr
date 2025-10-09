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

unit Fisco.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_Fisco203 }

  TNFSeR_Fisco203 = class(TNFSeR_ABRASFv2)
  protected
    function LerDataHoraCancelamento(const ANode: TACBrXmlNode): TDateTime; override;
    function LerDataHora(const ANode: TACBrXmlNode): TDateTime; override;
    function LerDataEmissao(const ANode: TACBrXmlNode): TDateTime; override;
    function LerDataEmissaoRps(const ANode: TACBrXmlNode): TDateTime; override;
    function LerCompetencia(const ANode: TACBrXmlNode): TDateTime; override;

  public

  end;

implementation

uses
  ACBrDFe.Conversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Fisco
//==============================================================================

{ TNFSeR_Fisco203 }

function TNFSeR_Fisco203.LerCompetencia(const ANode: TACBrXmlNode): TDateTime;
begin
  Result := ObterConteudo(ANode.Childrens.FindAnyNs('Competencia'), tcDatVcto);
end;

function TNFSeR_Fisco203.LerDataEmissao(const ANode: TACBrXmlNode): TDateTime;
begin
  Result := ObterConteudo(ANode.Childrens.FindAnyNs('DataEmissao'), tcDatVcto);
end;

function TNFSeR_Fisco203.LerDataEmissaoRps(
  const ANode: TACBrXmlNode): TDateTime;
begin
  Result := ObterConteudo(ANode.Childrens.FindAnyNs('DataEmissao'), tcDatVcto);
end;

function TNFSeR_Fisco203.LerDataHora(const ANode: TACBrXmlNode): TDateTime;
begin
  Result := ObterConteudo(ANode.Childrens.FindAnyNs('DataHora'), tcDatVcto);
end;

function TNFSeR_Fisco203.LerDataHoraCancelamento(
  const ANode: TACBrXmlNode): TDateTime;
begin
  Result := ObterConteudo(ANode.Childrens.FindAnyNs('DataHora'), tcDatVcto);
end;

end.
