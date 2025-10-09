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
  protected
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

  if OnlyNumber(NFSe.Intermediario.Identificacao.CpfCnpj) <> '' then
  begin
    Result := CreateElement('CPFCNPJIntermediario');

    Result.AppendChild(AddNodeCNPJCPF('#1', '#2',
                         OnlyNumber(NFSe.Intermediario.Identificacao.CpfCnpj)));
  end;
end;

function TNFSeW_ISSSaoPaulo.GerarCPFCNPJTomador: TACBrXmlNode;
begin
  Result := nil;

  if OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj) <> '' then
  begin
    Result := CreateElement('CPFCNPJTomador');

    Result.AppendChild(AddNodeCNPJCPF('#1', '#2',
                        OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj)));
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

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorServicos', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorServicos, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorDeducoes', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorDeducoes, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorPIS', 1, 15, 0,
                                            NFSe.Servico.Valores.ValorPis, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorCOFINS', 1, 15, 0,
                                         NFSe.Servico.Valores.ValorCofins, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorINSS', 1, 15, 0,
                                           NFSe.Servico.Valores.ValorInss, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorIR', 1, 15, 0,
                                             NFSe.Servico.Valores.ValorIr, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'ValorCSLL', 1, 15, 0,
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

  (*
      <xs:choice>
        <xs:element name="ValorInicialCobrado" type="tipos:tpValor" minOccurs="1" maxOccurs="1">
          <xs:annotation>
            <xs:documentation>Valor inicial cobrado pela prestação do serviço, antes de tributos, multa e juros.</xs:documentation>
            <xs:documentation>"Valor dos serviços antes dos tributos". Corresponde ao valor cobrado pela prestação do serviço, antes de tributos, multa e juros.</xs:documentation>
            <xs:documentation>Informado para realizar o cálculo dos tributos do início para o fim.</xs:documentation>
          </xs:annotation>
        </xs:element>
        <xs:element name="ValorFinalCobrado" type="tipos:tpValor" minOccurs="1" maxOccurs="1">
          <xs:annotation>
            <xs:documentation>Valor final cobrado pela prestação do serviço, incluindo todos os tributos.</xs:documentation>
            <xs:documentation>"Valor total na nota". Corresponde ao valor final cobrado pela prestação do serviço, incluindo todos os tributos, multa e juros.</xs:documentation>
            <xs:documentation>Informado para realizar o cálculo dos impostos do fim para o início.</xs:documentation>
          </xs:annotation>
        </xs:element>
      </xs:choice>

      <xs:element name="ValorMulta" type="tipos:tpValor" minOccurs="0" maxOccurs="1">
        <xs:annotation>
          <xs:documentation>Valor da multa.</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="ValorJuros" type="tipos:tpValor" minOccurs="0" maxOccurs="1">
        <xs:annotation>
          <xs:documentation>Valor dos juros.</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="ValorIPI" type="tipos:tpValor" minOccurs="1" maxOccurs="1">
        <xs:annotation>
          <xs:documentation>Valor de IPI.</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="ExigibilidadeSuspensa" type="tipos:tpNaoSim" minOccurs="1" maxOccurs="1">
        <xs:annotation>
          <xs:documentation>Informe se é uma emissão com exigibilidade suspensa.</xs:documentation>
          <xs:documentation>0 - Não.</xs:documentation>
          <xs:documentation>1 - Sim.</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="PagamentoParceladoAntecipado" type="tipos:tpNaoSim" minOccurs="1" maxOccurs="1">
        <xs:annotation>
          <xs:documentation>Informe a nota fiscal de pagamento parcelado antecipado (realizado antes do fornecimento).</xs:documentation>
          <xs:documentation>0 - Não.</xs:documentation>
          <xs:documentation>1 - Sim.</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="NCM" type="tipos:tpCodigoNCM" minOccurs="0" maxOccurs="1">
        <xs:annotation>
          <xs:documentation>Informe o número NCM (Nomenclatura Comum do Mercosul).</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="NBS" type="tipos:tpCodigoNBS" minOccurs="1" maxOccurs="1">
        <xs:annotation>
          <xs:documentation>Informe o número NBS (Nomenclatura Brasileira de Serviços).</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:element name="atvEvento" type="tipos:tpAtividadeEvento" minOccurs="0" maxOccurs="1">
        <xs:annotation>
          <xs:documentation>Informações dos Tipos de evento.</xs:documentation>
        </xs:annotation>
      </xs:element>
      <xs:group ref="tipos:gpPrestacao" />

  <xs:group name="gpPrestacao">
    <xs:annotation>
      <xs:documentation>Grupo do local de prestação do serviço.</xs:documentation>
    </xs:annotation>
    <xs:choice>
      <xs:element name="cLocPrestacao" type="tipos:tpCidade" minOccurs="1" maxOccurs="1" />
      <xs:element name="cPaisPrestacao" type="tipos:tpCodigoPaisISO" minOccurs="1" maxOccurs="1" />
    </xs:choice>
  </xs:group>


      <xs:element name="IBSCBS" type="tipos:tpIBSCBS" minOccurs="1" maxOccurs="1">  *)
  Result := True;
end;

end.
