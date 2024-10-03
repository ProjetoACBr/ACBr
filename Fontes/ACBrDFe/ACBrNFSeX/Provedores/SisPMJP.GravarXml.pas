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

unit SisPMJP.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrNFSeXGravarXml_ABRASFv2,
  ACBrNFSeXConversao;

type
  { TNFSeW_SisPMJP202 }

  TNFSeW_SisPMJP202 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

  public
    function GerarXml: Boolean; Override;
  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     SisPMJP
//==============================================================================

{ TNFSeW_SisPMJP202 }

procedure TNFSeW_SisPMJP202.Configuracao;
begin
  inherited Configuracao;

  FormatoItemListaServico := filsSemFormatacaoSemZeroEsquerda;
  FormatoAliq := tcDe2;
end;

function TNFSeW_SisPMJP202.GerarXml: Boolean;
begin
  if (NFSe.OptanteSimplesNacional = snNao) then
  begin
    if (NFSe.RegimeEspecialTributacao in [retMicroempresaMunicipal, retMicroempresarioEmpresaPP]) then
      NrOcorrValorIss := 1
    else
      NrOcorrValorIss := -1;
  end
  else
  begin
    if (NFSe.RegimeEspecialTributacao in [retMicroempresaMunicipal]) then
      NrOcorrValorIss := 1
    else
      NrOcorrValorIss := -1;
  end;

  Result := inherited GerarXml;
end;

end.
