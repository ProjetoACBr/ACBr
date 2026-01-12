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

unit WebISS.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlDocument,
  ACBrNFSeXLerXml_ABRASFv1,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_WebISS }

  TNFSeR_WebISS = class(TNFSeR_ABRASFv1)
  protected

  public

  end;

  { TNFSeR_WebISS202 }

  TNFSeR_WebISS202 = class(TNFSeR_ABRASFv2)
  protected
    procedure LerInfDeclaracaoPrestacaoServico(const ANode: TACBrXmlNode); override;
    procedure LerInfNfse(const ANode: TACBrXmlNode); override;
  public

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     WebISS
//==============================================================================

{ TNFSeR_WebISS202 }

procedure TNFSeR_WebISS202.LerInfDeclaracaoPrestacaoServico(
  const ANode: TACBrXmlNode);
var
  node: TACBrXmlNode;
begin
  inherited LerInfDeclaracaoPrestacaoServico(ANode);

  node := ANode.Childrens.FindAnyNs('InfDeclaracaoPrestacaoServico');
  if node <> nil then
    LerXMLIBSCBSDPS(node.Childrens.FindAnyNs('IBSCBS'), NFSe.IBSCBS);
end;
procedure TNFSeR_WebISS202.LerInfNfse(const ANode: TACBrXmlNode);
var
  NodeIBS: TACBrXmlNode;
  NodeInfNfse: TACBrXmlNode;
  i: Integer;
begin
  NodeInfNfse := ANode.Childrens.FindAnyNs('InfNfse');
  inherited LerInfNfse(ANode);

  if NodeInfNfse <> nil then
  begin
    NodeIBS := NodeInfNfse.Childrens.FindAnyNs('IBSCBS');

    if NodeIBS <> nil then
      LerXMLIBSCBSNFSe(NodeIBS, NFSe.infNFSe.IBSCBS);
  end;
end;

end.
