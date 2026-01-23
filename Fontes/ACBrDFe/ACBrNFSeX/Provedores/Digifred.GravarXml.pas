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

unit Digifred.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrNFSeXGravarXml_ABRASFv2,
  PadraoNacional.GravarXml;

type
  { TNFSeW_Digifred200 }

  TNFSeW_Digifred200 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

  end;

  { TNFSeW_DigifredAPIPropria }

  TNFSeW_DigifredAPIPropria = class(TNFSeW_PadraoNacional)
  protected

  public
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrXmlDocument,
  ACBrDFe.Conversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Digifred
//==============================================================================

{ TNFSeW_Digifred200 }

procedure TNFSeW_Digifred200.Configuracao;
begin
  inherited Configuracao;

  FormatoEmissao := tcDatHor;
  FormatoCompetencia := tcDatHor;
  FormatoAliq := tcDe2;
  NrOcorrCodigoPaisServico := -1;
end;

{ TNFSeW_DigifredAPIPropria }

function TNFSeW_DigifredAPIPropria.GerarXml: Boolean;
var
  NFSeNode: TACBrXmlNode;
begin
  Configuracao;
  LerParamsTabIni(True);

  {
    Alguns dados merecem atenção para não serem confundidos:
    Os tags "nNFSe" e "nDFSe" devem aparecer no xml, porém, não devem ser preenchidos.
    Os tags "infNFSe" e "infDPS" devem conter o "Id", este também deve estar vazio.
    Como no exemplo 'infDPS Id=""' .Os tags "infNFSe" e "infDPS" devem conter o "Id",
    este também deve estar vazio. Como no exemplo 'infDPS Id=""'.
    Item de Serviço: A tag "cTribNac" - Item da Lista de Serviços deve ser informado
    com o código da lista de serviços da Lei Complementar 116/2003 -
    http://www.planalto.gov.br/ccivil_03/Leis/LCP/Lcp116.htm porém com 6 dígitos,
    conforme o desdobro que consta na planilha do layout Nacional
    ANEXO_B-NBS2-LISTA_SERVICO_NACIONAL-SNNFSe-v1.00-20251210 A atualização nos
    Cadastros de Estabelecimentos, foram realizados por padrão, com desdobro
    final 00. Após, o Fiscal deverá conferir e ajustar conforme melhor se adequar
    para cada prestador.
  }
  ListaDeAlertas.Clear;

  FDocument.Clear();

  NrOcorrtpAmb := -1;
  IDNFSeVazio := True;
  IDDPSVazio := True;
  GerarIBSCBSNFSe := False;

//  NFSe.infNFSe.nNFSe := '';
//  NFSe.infNFSe.nDFSe := '';

  NFSeNode := GerarXMLNFSe;
  FDocument.Root := NFSeNode;

  Result := True;
end;

end.
