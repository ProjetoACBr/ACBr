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

unit Fiorilli.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXConversao,
  ACBrNFSeXGravarXml_ABRASFv2,
  PadraoNacional.GravarXml;

type
  { TNFSeW_Fiorilli200 }

  TNFSeW_Fiorilli200 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;
  end;

  { TNFSeW_FiorilliAPIPropria }

  TNFSeW_FiorilliAPIPropria = class(TNFSeW_PadraoNacional)
  private
    FpVersao: string;
  protected
    procedure Configuracao; override;
    function GerarXMLInfDps: TACBrXmlNode; override;

  public
    function GerarXml: Boolean; override;

    {

    // Reescrito a geração do grupo IBSCBS do DPS pelo fato do provedor ainda
    // estar usando o layout definido na NT 003 versão 1.2
    function GerarXMLIBSCBS(IBSCBS: TIBSCBSDPS): TACBrXmlNode; override;
    function GerarXMLTributacaoMunicipal: TACBrXmlNode; override;
    function GerarXMLPrestador: TACBrXmlNode; override;
    function GerarXMLgIBSCBS(gIBSCBS: TgIBSCBS): TACBrXmlNode; override;
    function GerarXMLObra: TACBrXmlNode; override;
    function GerarXMLEnderecoExteriorObra: TACBrXmlNode; override;
    function GerarXMLFornecedor(Item: Integer): TACBrXmlNode; override;
    function GerarXMLIBSCBSAdquirente: TACBrXmlNode;
    function GerarXMLIBSCBSEnderecoAdquirente(ender: Tender): TACBrXmlNode;
    function GerarXMLIBSCBSEnderecoNacionalAdquirente(endNac: TendNac): TACBrXmlNode;
    function GerarXMLIBSCBSEnderecoExteriorAdquirente(endExt: TendExt): TACBrXmlNode;
    function GerarXMLServico: TACBrXmlNode;  override;
    }
  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrNFSeXConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Fiorilli
//==============================================================================

{ TNFSeW_Fiorilli200 }

procedure TNFSeW_Fiorilli200.Configuracao;
begin
  inherited Configuracao;

  FormatoCompetencia := tcDat;

  NrOcorrCodigoPaisTomador := 0;
  NrOcorrDiscriminacao_1 := -1;
  NrOcorrCodigoMunic_1 := -1;

  NrOcorrDiscriminacao_2 := 1;
  NrOcorrCodigoMunic_2 := 1;
end;

{ TNFSeW_FiorilliAPIPropria }

procedure TNFSeW_FiorilliAPIPropria.Configuracao;
begin
  inherited Configuracao;

  PrefixoPadrao := 'nfse1';
end;

function TNFSeW_FiorilliAPIPropria.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
  chave, CodigoMun, CNPJ: string;
begin
  Configuracao;

  ListaDeAlertas.Clear;

  FDocument.Clear();

  FpVersao := VersaoNFSeToStr(VersaoNFSe);

  CodigoMun := IntToStr(CodMunEmit);
  CNPJ := CNPJEmitente;

  if CNPJ = '' then
    CNPJ := NFSe.Prestador.IdentificacaoPrestador.CpfCnpj;

  chave := GerarChaveDPS(CodigoMun,
                         CNPJ,
                         NFSe.IdentificacaoRps.Serie,
                         NFSe.IdentificacaoRps.Numero);

  NFSe.InfID.ID := 'DPS' + chave;
  PrefixoPadrao := 'nfse';

  NFSeNode := CreateElement('DPS');
  NFSeNode.SetAttribute('versao', FpVersao);
  NFSeNode.SetNamespace(FpAOwner.ConfigMsgDados.LoteRps.xmlns, Self.PrefixoPadrao);

  FDocument.Root := NFSeNode;

  xmlNode := GerarXMLInfDps;
  NFSeNode.AppendChild(xmlNode);

  Result := True;
end;

function TNFSeW_FiorilliAPIPropria.GerarXMLInfDps: TACBrXmlNode;
begin
  PrefixoPadrao := 'nfse1';
  Result := CreateElement('infDPS');

  if (FpAOwner.ConfigGeral.Identificador <> '') then
    Result.SetAttribute(FpAOwner.ConfigGeral.Identificador, NFSe.infID.ID);

  if (FpAOwner.ConfigMsgDados.xmlRps.xmlns <> '') then
    Result.SetNamespace(FpAOwner.ConfigMsgDados.xmlRps.xmlns, Self.PrefixoPadrao);

  Result.AppendChild(AddNode(tcStr, '#1', 'tpAmb', 1, 1, 1,
                                              TipoAmbienteToStr(Ambiente), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'dhEmi', 25, 25, 1,
               DateTimeTodh(NFSe.DataEmissao) +
               GetUTC(NFSe.Prestador.Endereco.UF, NFSe.DataEmissao), DSC_DEMI));

  Result.AppendChild(AddNode(tcStr, '#1', 'verAplic', 1, 20, 1,
                                                            NFSe.verAplic, ''));

  Result.AppendChild(AddNode(tcInt, '#1', 'serie', 1, 5, 1,
                              StrToIntDef(NFSe.IdentificacaoRps.Serie, 0), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'nDPS', 1, 14, 1,
                                             NFSe.IdentificacaoRps.Numero, ''));

  Result.AppendChild(AddNode(tcDat, '#1', 'dCompet', 10, 10, 1,
                                                         NFSe.Competencia, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tpEmit', 1, 1, 1,
                                                 tpEmitToStr(NFSe.tpEmit), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cMotivoEmisTI', 1, 1, 0,
                                   cMotivoEmisTIToStr(NFSe.cMotivoEmisTI), ''));

  if NFSe.cLocEmi <> '' then
    Result.AppendChild(AddNode(tcStr, '#1', 'cLocEmi', 7, 7, 1,
                                                              NFSe.cLocEmi, ''))
  else
  begin
    case NFSe.tpEmit of
      teTomador:
        Result.AppendChild(AddNode(tcStr, '#1', 'cLocEmi', 7, 7, 1,
                                    NFSe.Tomador.Endereco.CodigoMunicipio, ''));
      teIntermediario:
        Result.AppendChild(AddNode(tcStr, '#1', 'cLocEmi', 7, 7, 1,
                              NFSe.Intermediario.Endereco.CodigoMunicipio, ''));
    else
      Result.AppendChild(AddNode(tcStr, '#1', 'cLocEmi', 7, 7, 1,
                                  NFSe.Prestador.Endereco.CodigoMunicipio, ''));
    end;
  end;

  Result.AppendChild(GerarXMLSubstituicao);
  Result.AppendChild(GerarXMLPrestador);
  Result.AppendChild(GerarXMLTomador);
  Result.AppendChild(GerarXMLIntermediario);
  Result.AppendChild(GerarXMLServico);
  Result.AppendChild(GerarXMLValores);

  // Reforma Tributária
  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
    Result.AppendChild(GerarXMLIBSCBS(NFSe.IBSCBS));
end;

end.
