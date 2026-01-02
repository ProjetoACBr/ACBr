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

unit SpeedGov.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrNFSeXClass,
  ACBrXmlDocument,
  ACBrDFe.Conversao,
  ACBrNFSeXGravarXml_ABRASFv1;

type
  { TNFSeW_SpeedGov }

  TNFSeW_SpeedGov = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;
    function GerarXml: Boolean; override;
    function GerarTomador: TACBrXmlNode; override;
    function GerarDadosDPS: TACBrXmlNode;
    function GerarDestinatario: TACBrXmlNode;
    function GerarControleIBSCBS: TACBRXmlNode;
    function GerarIBSCBS: TACBrXmlNode;
  end;

implementation

uses
  ACBrNFSeXConversao,
  ACBrNFSeXConsts,
  ACBrUtil.Strings,
  ACBrUtil.DateTime;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     SpeedGov
//==============================================================================

{ TNFSeW_SpeedGov }

procedure TNFSeW_SpeedGov.Configuracao;
begin
  inherited Configuracao;

  PrefixoPadrao := 'p1';
end;

function TNFSeW_SpeedGov.GerarControleIBSCBS: TACBRXmlNode;
begin
  Result := CreateElement('ControleIBSCBS');

  Result.AppendChild(AddNode(tcStr, '#1', 'FinNFSe', 1, 1, 1,
                                        finNFSeToStr(NFSe.IBSCBS.finNFSe), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IndFinal', 1, 1, 1,
                                      indFinalToStr(NFSe.IBSCBS.indFinal), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'TpOper', 1, 1, NrOcorrtpOper,
                                   tpOperGovNFSeToStr(NFSe.IBSCBS.tpOper), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'TpEnteGov', 1, 1, 0,
                                    tpEnteGovToStr(NFSe.IBSCBS.tpEnteGov), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IndDest', 1, 1, NrOcorrindDest,
                                        indDestToStr(NFSe.IBSCBS.indDest), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CIndOp', 6, 6, 1,
                                                       NFSe.IBSCBS.cIndOp, ''));
end;

function TNFSeW_SpeedGov.GerarDadosDPS: TACBrXmlNode;
begin
  Result := CreateElement('DadosDPS');

  Result.AppendChild(AddNode(tcStr, '#38', 'TpEmit', 1, 1, 1,
                                                 tpEmitToStr(NFSe.tpEmit), ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'TpAmb', 1, 1, 1,
                                              TipoAmbienteToStr(Ambiente), ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'DhEmi', 25, 25, 1,
               DateTimeTodh(NFSe.DataEmissao) +
               GetUTC(NFSe.Prestador.Endereco.UF, NFSe.DataEmissao), DSC_DEMI));

  Result.AppendChild(AddNode(tcStr, '#38', 'VerAplic', 1, 20, 1,
                                                            NFSe.verAplic, ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'CLocEmi', 1, 1, 1, NFSe.cLocEmi, ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'CLocPrestacao', 1, 1, 1,
                                             NFSe.Servico.CodigoMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'CTribNac', 6, 6, 1,
                                            NFSe.Servico.ItemListaServico, ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'TribIssqn', 1, 1, 1,
                   tribISSQNToStr(NFSe.Servico.Valores.tribMun.tribISSQN), ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'TpRetIssqn', 2, 2, 1,
                 tpRetISSQNToStr(NFSe.Servico.Valores.tribMun.tpRetISSQN), ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'OpSimpNac', 1, 1, 1,
                                  OptanteSNToStr(NFSe.OptanteSN), DSC_INDOPSN));

  if NFSe.OptanteSN = osnOptanteMEEPP then
    Result.AppendChild(AddNode(tcStr, '#38', 'RegApTribSN', 1, 1, 1,
                             RegimeApuracaoSNToStr(NFSe.RegimeApuracaoSN), ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'RegEspTrib', 1, 1, 1,
      FpAOwner.RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao), DSC_REGISSQN));
end;

function TNFSeW_SpeedGov.GerarDestinatario: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.IBSCBS.dest.xNome <> '' then
  begin
    Result := CreateElement('Destinatario');

    if NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '' then
      Result.AppendChild(AddNodeCNPJCPF('#38', '#38',
                                                     NFSe.IBSCBS.dest.CNPJCPF));

    Result.AppendChild(AddNode(tcStr, '#38', 'Nome', 1, 300, 1,
                                                   NFSe.IBSCBS.dest.xNome, ''));

    if (NFSe.IBSCBS.dest.ender.DescricaoMunicipio <> '') or
       (NFSe.IBSCBS.dest.xPais <> '') then
    begin
      Result.AppendChild(AddNode(tcStr, '#38', 'Logradouro', 1, 255, 1,
                                              NFSe.IBSCBS.dest.ender.xLgr, ''));

      Result.AppendChild(AddNode(tcStr, '#38', 'Numero', 1, 60, 1,
                                               NFSe.IBSCBS.dest.ender.nro, ''));

      Result.AppendChild(AddNode(tcStr, '#38', 'Complemento', 1, 156, 0,
                                              NFSe.IBSCBS.dest.ender.xCpl, ''));

      Result.AppendChild(AddNode(tcStr, '#38', 'Bairro', 1, 60, 1,
                                           NFSe.IBSCBS.dest.ender.xBairro, ''));

      Result.AppendChild(AddNode(tcStr, '#38', 'Cidade', 1, 60, 1,
                                NFSe.IBSCBS.dest.ender.DescricaoMunicipio, ''));

      Result.AppendChild(AddNode(tcStr, '#38', 'UF', 1, 60, 1,
                                                NFSe.IBSCBS.dest.ender.UF, ''));

      Result.AppendChild(AddNode(tcStr, '#38', 'CEP', 1, 60, 1,
                                        NFSe.IBSCBS.dest.ender.endNac.CEP, ''));

      Result.AppendChild(AddNode(tcStr, '#38', 'CodMunicipio', 1, 60, 1,
                                       NFSe.IBSCBS.dest.ender.endNac.cMun, ''));

      Result.AppendChild(AddNode(tcStr, '#38', 'CodPais', 1, 60, 1,
                                      NFSe.IBSCBS.dest.ender.endExt.cPais, ''));
    end;

    Result.AppendChild(AddNode(tcStr, '#38', 'Email', 1, 80, 0,
                                                   NFSe.IBSCBS.dest.Email, ''));

    Result.AppendChild(AddNode(tcStr, '#38', 'Telefone', 6, 20, 0,
                                                    NFSe.IBSCBS.dest.fone, ''));
  end;
end;

function TNFSeW_SpeedGov.GerarIBSCBS: TACBrXmlNode;
var
  item: string;
  Valores: TACBrXmlNode;
begin
  Result := CreateElement('IBSCBS');

  Result.AppendChild(AddNode(tcDe2, '#24', 'IBSCBSBaseCalculo', 1, 15, NrOcorrBaseCalc,
                                 NFSe.Servico.Valores.BaseCalculo, DSC_VBCISS));

  Result.AppendChild(AddNode(tcDe2, '#29', 'IBSUFAliquota', 1, 5, 0,
                                          NFSe.IBSCBS.valores.IbsEstadual, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'IBSMunAliquota', 1, 5, 0,
                                         NFSe.IBSCBS.valores.IbsMunicipal, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'CBSAliquota', 1, 5, 0,
                                                  NFSe.IBSCBS.valores.Cbs, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'IBSUFValor', 1, 15, 0,
                                     NFSe.IBSCBS.valores.ValorIbsEstadual, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'IBSMunValor', 1, 15, 0,
                                    NFSe.IBSCBS.valores.ValorIbsMunicipal, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'CBSValor', 1, 15, 0,
                                             NFSe.IBSCBS.valores.ValorCbs, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'IBSUFPercReducao', 1, 15, 0,
                                NFSe.infNFSe.IBSCBS.valores.uf.pRedAliqUF, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'IBSMunPercReducao', 1, 15, 0,
                              NFSe.infNFSe.IBSCBS.valores.mun.pRedAliqMun, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'CBSPercReducao', 1, 15, 0,
                              NFSe.infNFSe.IBSCBS.valores.fed.pRedAliqCBS, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'CBSPercReducao', 1, 15, 0,
                              NFSe.infNFSe.IBSCBS.valores.fed.pRedAliqCBS, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'IBSUFAliquotaEfetiva', 1, 15, 0,
                               NFSe.infNFSe.IBSCBS.valores.uf.pAliqEfetUF, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'IBSMunAliquotaEfetiva', 1, 15, 0,
                             NFSe.infNFSe.IBSCBS.valores.mun.pAliqEfetMun, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'CBSAliquotaEfetiva', 1, 15, 0,
                             NFSe.infNFSe.IBSCBS.valores.fed.pAliqEfetCBS, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'IBSValorTotal', 1, 15, 0,
    NFSe.IBSCBS.valores.ValorIbsEstadual + NFSe.IBSCBS.valores.IbsMunicipal, ''));

  Result.AppendChild(AddNode(tcDe2, '#29', 'ValorTotalComTributos', 1, 15, 0,
                                NFSe.Servico.Valores.ValorTotalNotaFiscal, ''));

  Result.AppendChild(AddNode(tcStr, '#29', 'LocalidadeIncidenciaCod', 1, 7, 1,
                                     NFSe.infNFSe.IBSCBS.cLocalidadeIncid, ''));

  Result.AppendChild(AddNode(tcStr, '#29', 'LocalidadeIncidenciaNome', 1, 100, 1,
                                     NFSe.infNFSe.IBSCBS.xLocalidadeIncid, ''));
end;

function TNFSeW_SpeedGov.GerarTomador: TACBrXmlNode;
var
  tomadorIdentificado, tipoPessoa, item, cnpjCpfDestinatario,
  xCidade, xUF: string;
begin
  Result := inherited GerarTomador;
end;

function TNFSeW_SpeedGov.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
begin
  ListaDeAlertas.Clear;

  FDocument.Clear();

  NFSeNode := CreateElement('Rps');

  if FpAOwner.ConfigMsgDados.XmlRps.xmlns <> '' then
    NFSeNode.SetNamespace(FpAOwner.ConfigMsgDados.XmlRps.xmlns, Self.PrefixoPadrao);

  FDocument.Root := NFSeNode;

  if FormatoDiscriminacao <> fdNenhum then
    ConsolidarVariosItensServicosEmUmSo;

  xmlNode := GerarInfRps;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarDadosDPS;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarDestinatario;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarControleIBSCBS;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarIBSCBS;
  NFSeNode.AppendChild(xmlNode);

  Result := True;
end;

end.
