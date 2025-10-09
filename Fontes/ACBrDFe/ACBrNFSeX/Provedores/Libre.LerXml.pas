{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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

unit Libre.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrDFe.Conversao,
  ACBrXmlDocument,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_Libre204 }

  TNFSeR_Libre204 = class(TNFSeR_ABRASFv2)
  protected
    procedure LerPrestadorServico(const ANode: TACBrXmlNode); override;
  public

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Libre
//==============================================================================

{ TNFSeR_Libre204 }

procedure TNFSeR_Libre204.LerPrestadorServico(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNodePrestador, AuxNodeCpfCnpj: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('PrestadorServico');
  if AuxNode <> nil then
  begin
    with NFSe.Prestador do
    begin
      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocial'), tcStr);
      RazaoSocial := StringReplace(RazaoSocial, '&amp;', '&', [rfReplaceAll]);
      NomeFantasia := ObterConteudo(AuxNode.Childrens.FindAnyNs('NomeFantasia'), tcStr);
    end;

    LerEnderecoPrestadorServico(AuxNode, 'Endereco');
    LerContatoPrestador(AuxNode);
  end;

  AuxNodePrestador := ANode.Childrens.FindAnyNs('Prestador');
  if AuxNodePrestador <> nil then
  begin
    with NFSe.Prestador.IdentificacaoPrestador do
    begin
      AuxNodeCpfCnpj := AuxNodePrestador.Childrens.FindAnyNs('CpfCnpj');
      if AuxNodeCpfCnpj <> nil then
      begin
        CpfCnpj := ObterConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cnpj'), tcStr);
        if CpfCnpj = '' then
          CpfCnpj := ObterConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cpf'), tcStr);
      end;

      InscricaoMunicipal := ObterConteudo(AuxNodePrestador.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
    end;
  end;
end;

end.
