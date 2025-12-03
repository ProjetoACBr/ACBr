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

unit ISSSaoPaulo.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXGravarXml;

type
  { TNFSeW_ISSSaoPaulo }

  TNFSeW_ISSSaoPaulo = class(TNFSeWClass)
  private
    FNrOcorr: Integer;
  protected
    procedure Configuracao; override;

    function GerarChaveRPS: TACBrXmlNode;
    function GerarCPFCNPJTomador: TACBrXmlNode;
    function GerarEnderecoTomador: TACBrXmlNode;
    function GerarCPFCNPJIntermediario: TACBrXmlNode;
  public
    function GerarXml: Boolean; override;

  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrUtil.Strings,
  ACBrNFSeXConversao,
  ACBrNFSeXConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     ISSSaoPaulo
//==============================================================================

{ TNFSeW_ISSSaoPaulo }

procedure TNFSeW_ISSSaoPaulo.Configuracao;
begin
  inherited Configuracao;

  FNrOcorr := 0;
  NrOcorrCST := -1;
  NrOcorrcCredPres := -1;
  NrOcorrCSTReg := -1;

  GerargDif := False;

  if VersaoNFSe = ve200 then
    FNrOcorr := 1;
end;

function TNFSeW_ISSSaoPaulo.GerarChaveRPS: TACBrXmlNode;
begin
  Result := CreateElement('ChaveRPS');

  Result.AppendChild(AddNode(tcStr, '#1', 'InscricaoPrestador', 1, 11, 1,
        NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal, DSC_INSCMUN));

  Result.AppendChild(AddNode(tcStr, '#2', 'SerieRPS', 1, 05, 1,
                                    NFSe.IdentificacaoRps.Serie, DSC_SERIERPS));

  Result.AppendChild(AddNode(tcStr, '#2', 'NumeroRPS', 1, 12, 1,
                                     NFSe.IdentificacaoRps.Numero, DSC_NUMRPS));
end;

function TNFSeW_ISSSaoPaulo.GerarCPFCNPJIntermediario: TACBrXmlNode;
begin
  Result := nil;

  if (OnlyNumber(NFSe.Intermediario.Identificacao.CpfCnpj) <> '') or
     (NFSe.Intermediario.Identificacao.Nif <> '') then
  begin
    Result := CreateElement('CPFCNPJIntermediario');

    if NFSe.Intermediario.Identificacao.CpfCnpj <> '' then
      Result.AppendChild(AddNodeCNPJCPF('#1', '#1',
                                     NFSe.Intermediario.Identificacao.CpfCnpj))
    else
    begin
      if NFSe.Intermediario.Identificacao.Nif <> '' then
        Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                     NFSe.Intermediario.Identificacao.Nif, ''))
      else
        Result.AppendChild(AddNode(tcStr, '#1', 'NaoNIF', 1, 1, 1,
                   NaoNIFToStr(NFSe.Intermediario.Identificacao.cNaoNIF), ''));
    end;
  end;
end;

function TNFSeW_ISSSaoPaulo.GerarCPFCNPJTomador: TACBrXmlNode;
begin
  Result := nil;

  if (OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj) <> '') or
     (NFSe.Tomador.IdentificacaoTomador.Nif <> '') then
  begin
    Result := CreateElement('CPFCNPJTomador');

    if NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '' then
      Result.AppendChild(AddNodeCNPJCPF('#1', '#1',
                                     NFSe.Tomador.IdentificacaoTomador.CpfCnpj))
    else
    begin
      if NFSe.Tomador.IdentificacaoTomador.Nif <> '' then
        Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                     NFSe.Tomador.IdentificacaoTomador.Nif, ''))
      else
        Result.AppendChild(AddNode(tcStr, '#1', 'NaoNIF', 1, 1, 1,
                   NaoNIFToStr(NFSe.Tomador.IdentificacaoTomador.cNaoNIF), ''));
    end;
  end;
end;

function TNFSeW_ISSSaoPaulo.GerarEnderecoTomador: TACBrXmlNode;
begin
  Result := CreateElement('EnderecoTomador');

  Result.AppendChild(AddNode(tcStr, '#1', 'TipoLogradouro', 1, 10, 0,
                                     NFSe.Tomador.Endereco.TipoLogradouro, ''));

  Result.AppendChild(AddNode(tcStr, '#2', 'Logradouro ', 1, 50, 0,
                                           NFSe.Tomador.Endereco.Endereco, ''));

  Result.AppendChild(AddNode(tcStr, '#2', 'NumeroEndereco ', 1, 9, 0,
                                             NFSe.Tomador.Endereco.Numero, ''));

  Result.AppendChild(AddNode(tcStr, '#2', 'ComplementoEndereco ', 1, 30, 0,
                                        NFSe.Tomador.Endereco.Complemento, ''));

  Result.AppendChild(AddNode(tcStr, '#2', 'Bairro ', 1, 50, 0,
                                             NFSe.Tomador.Endereco.Bairro, ''));

  Result.AppendChild(AddNode(tcStr, '#2', 'Cidade ', 1, 10, 0,
                                    NFSe.Tomador.Endereco.CodigoMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#2', 'UF ', 1, 2, 0,
                                                 NFSe.Tomador.Endereco.UF, ''));

  Result.AppendChild(AddNode(tcStr, '#2', 'CEP ', 1, 8, 0,
                                    OnlyNumber(NFSe.Tomador.Endereco.CEP), ''));
end;

function TNFSeW_ISSSaoPaulo.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
  TipoRPS, Situacao, aliquota, ISSRetido, sISSRetidoInter: String;
begin
  Configuracao;

  Opcoes.SuprimirDecimais := True;
  Opcoes.DecimalChar := '.';

  ListaDeAlertas.Clear;

  FDocument.Clear();

  NFSe.InfID.ID := NFSe.IdentificacaoRps.Numero;

  NFSeNode := CreateElement('RPS');
  NFSeNode.SetNamespace(FpAOwner.ConfigMsgDados.LoteRps.xmlns, Self.PrefixoPadrao);

  FDocument.Root := NFSeNode;

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Assinatura', 1, 2000, 1,
                                                          NFSe.Assinatura, ''));

  xmlNode := GerarChaveRPS;
  NFSeNode.AppendChild(xmlNode);

  TipoRPS := EnumeradoToStr(NFSe.IdentificacaoRps.Tipo,
                      ['RPS','RPS-M','RPS-C'], [trRPS, trNFConjugada, trCupom]);

  Situacao := EnumeradoToStr(NFSe.StatusRps, ['N', 'C'], [srNormal, srCancelado]);

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'TipoRPS', 1, 5, 1, TipoRPS, ''));

  NFSeNode.AppendChild(AddNode(tcDat, '#1', 'DataEmissao', 1, 10, 1,
                                                         NFse.DataEmissao, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'StatusRPS', 1, 1, 1, Situacao, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'TributacaoRPS', 1, 1, 1,
                  FPAOwner.TipoTributacaoRPSToStr(NFSe.TipoTributacaoRPS), ''));

  if VersaoNFSe = ve100 then
    NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorServicos', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorServicos, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorDeducoes', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorDeducoes, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorPIS', 1, 15, FNrOcorr,
                                            NFSe.Servico.Valores.ValorPis, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorCOFINS', 1, 15, FNrOcorr,
                                         NFSe.Servico.Valores.ValorCofins, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorINSS', 1, 15, FNrOcorr,
                                           NFSe.Servico.Valores.ValorInss, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorIR', 1, 15, FNrOcorr,
                                             NFSe.Servico.Valores.ValorIr, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorCSLL', 1, 15, FNrOcorr,
                                           NFSe.Servico.Valores.ValorCsll, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'CodigoServico', 1, 5, 1,
                                OnlyNumber(NFSe.Servico.ItemListaServico), ''));

  if NFSe.Servico.Valores.Aliquota > 0 then
  begin
    aliquota := FormatFloat('0.00##', NFSe.Servico.Valores.Aliquota / 100);

    aliquota := StringReplace(aliquota, ',', '.', [rfReplaceAll]);
  end
  else
    aliquota := '0';

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'AliquotaServicos', 1, 6, 1,
                                                                 aliquota, ''));

  ISSRetido := EnumeradoToStr( NFSe.Servico.Valores.IssRetido,
                                     ['false', 'true'], [stNormal, stRetencao]);

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'ISSRetido', 1, 5, 1, ISSRetido, ''));

  xmlNode := GerarCPFCNPJTomador;
  NFSeNode.AppendChild(xmlNode);

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'InscricaoMunicipalTomador', 1, 8, 0,
         OnlyNumber(NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal), ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'InscricaoEstadualTomador', 1, 19, 0,
          OnlyNumber(NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual), ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'RazaoSocialTomador', 1, 75, 0,
                                                 NFSe.Tomador.RazaoSocial, ''));

  xmlNode := GerarEnderecoTomador;
  NFSeNode.AppendChild(xmlNode);

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'EmailTomador', 1, 75, 0,
                                               NFSe.Tomador.Contato.Email, ''));

  if OnlyNumber(NFSe.Intermediario.Identificacao.CpfCnpj) <> '' then
  begin
    xmlNode := GerarCPFCNPJIntermediario;
    NFSeNode.AppendChild(xmlNode);

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'InscricaoMunicipalIntermediario', 1, 8, 0,
          OnlyNumber(NFSe.Intermediario.Identificacao.InscricaoMunicipal), ''));

    sISSRetidoInter := EnumeradoToStr( NFSe.Intermediario.IssRetido,
                                     ['false', 'true'], [stNormal, stRetencao]);

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'ISSRetidoIntermediario', 1, 5, 0,
                                                          sISSRetidoInter, ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'EmailIntermediario', 1, 75, 0,
                                         NFSe.Intermediario.Contato.EMail, ''));
  end;

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Discriminacao', 1, 2000, 1,
    StringReplace(NFSe.Servico.Discriminacao, Opcoes.QuebraLinha,
                          FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll])));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorCargaTributaria', 1, 15, 0,
                                        NFSe.Servico.ValorCargaTributaria, ''));

  NFSeNode.AppendChild(AddNode(tcDe4, '#1', 'PercentualCargaTributaria', 1, 5, 0,
                                   NFSe.Servico.PercentualCargaTributaria, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'FonteCargaTributaria', 1, 10, 0,
                                        NFSe.Servico.FonteCargaTributaria, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'CodigoCEI', 1, 12, 0,
                                                NFSe.ConstrucaoCivil.nCei, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'MatriculaObra', 1, 12, 0,
                                              NFSe.ConstrucaoCivil.nMatri, ''));

  if (NFSe.TipoTributacaoRPS <> ttTribnoMun) and
     (NFSe.TipoTributacaoRPS <> ttTribnoMunIsento) and
     (NFSe.TipoTributacaoRPS <> ttTribnoMunImune) then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'MunicipioPrestacao', 1, 7, 0,
                                             NFSe.Servico.CodigoMunicipio, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'NumeroEncapsulamento', 1, 12, 0,
                               NFSe.ConstrucaoCivil.nNumeroEncapsulamento, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorTotalRecebido', 1, 15, 0,
                                          NFSe.Servico.ValorTotalRecebido, ''));

  if VersaoNFSe = ve200 then
  begin
    if NFSe.Servico.Valores.ValorServicos > 0 then
      NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorInicialCobrado', 1, 15, 1,
                                        NFSe.Servico.Valores.ValorServicos, ''))
    else
      NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorFinalCobrado', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorServicos, ''));
  end;

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorMulta', 1, 15, 0,
                                          NFSe.Servico.Valores.ValorMulta, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorJuros', 1, 15, 0,
                                          NFSe.Servico.Valores.ValorJuros, ''));

  if VersaoNFSe = ve200 then
  begin
    NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorIPI', 1, 15, 1,
                                            NFSe.Servico.Valores.ValorIPI, ''));

    if NFSe.Servico.ExigibilidadeISS = exiSuspensaProcessoAdministrativo then
      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'ExigibilidadeSuspensa', 1, 1, 1,
                                                                       '1', ''))
    else
      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'ExigibilidadeSuspensa', 1, 1, 1,
                                                                      '0', ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'PagamentoParceladoAntecipado', 1, 1, 1,
                                                                      '0', ''));
  end;

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'NCM', 1, 15, 0,
                                                   NFSe.Servico.CodigoNCM, ''));

  if VersaoNFSe = ve200 then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'NBS', 1, 15, 1,
                                                   NFSe.Servico.CodigoNBS, ''));

(*
      <xs:element name="atvEvento" type="tipos:tpAtividadeEvento" minOccurs="0" maxOccurs="1">
        <xs:annotation>
          <xs:documentation>Informações dos Tipos de evento.</xs:documentation>
        </xs:annotation>
      </xs:element>
*)

  if VersaoNFSe = ve200 then
  begin
    if NFSe.Servico.CodigoMunicipio <> '' then
      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'cLocPrestacao', 7, 7, 1,
                                              NFSe.Servico.CodigoMunicipio, ''))
    else
      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'cPaisPrestacao', 2, 2, 1,
                          CodIBGEPaisToSiglaISO2(NFSe.Servico.CodigoPais), ''));
  end;

  // Reforma Tributária
  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
    NFSeNode.AppendChild(GerarXMLIBSCBS(NFSe.IBSCBS));

  Result := True;
end;

end.
