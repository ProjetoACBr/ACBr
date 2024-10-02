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

unit ModernizacaoPublica.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrNFSeXGravarXml_ABRASFv2;

type
  { TNFSeW_ModernizacaoPublica202 }

  TNFSeW_ModernizacaoPublica202 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

    procedure DefinirIDRps; override;

  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrXmlBase;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     ModernizacaoPublica
//==============================================================================

{ TNFSeW_ModernizacaoPublica202 }

procedure TNFSeW_ModernizacaoPublica202.Configuracao;
begin
  inherited Configuracao;

  // a linha abaixo foi comentada para atender a cidade de Belford Roxo/RJ
  // se outra cidade atendida pelo mesmo provedor exigir a presen�a da tag
  // vai ser necess�rio mudar a forma de configurar.

//  NrOcorrAliquota := 1;

  FormatoAliq := tcInt;
  GerarIDRps := True;
end;

procedure TNFSeW_ModernizacaoPublica202.DefinirIDRps;
begin
  NFSe.InfID.ID := 'rps' + OnlyNumber(NFSe.IdentificacaoRps.Numero) +
                    NFSe.IdentificacaoRps.Serie +
                    FpAOwner.TipoRPSToStr(NFSe.IdentificacaoRps.Tipo);
end;

end.
