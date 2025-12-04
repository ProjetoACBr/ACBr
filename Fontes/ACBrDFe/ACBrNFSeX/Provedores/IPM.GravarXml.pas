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

unit IPM.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrDFe.Conversao,
  ACBrXmlDocument,
  ACBrNFSeXGravarXml,
  ACBrNFSeXGravarXml_ABRASFv2,
  ACBrNFSeXConversao,
  ACBrNFSeXConsts,
  ACBrNFSeXClass;

type
  { TNFSeW_IPM }

  TNFSeW_IPM = class(TNFSeWClass)
  private
    FpGerarID: Boolean;
    FpNrOcorrTagsTomador: Integer;
    FpNrOcorrCodigoAtividade: Integer;
    FpNaoGerarGrupoRps: Boolean;

  protected
    procedure Configuracao; override;

    function GerarIdentificacaoRPS: TACBrXmlNode;
    function GerarValoresServico: TACBrXmlNode;
    function GerarPrestador: TACBrXmlNode;
    function GerarTomador: TACBrXmlNode;
    function GerarItens: TACBrXmlNode;
    function GerarLista: TACBrXmlNodeArray;
    function GerarFormaPagamento: TACBrXmlNode;
    function GerarParcelas: TACBrXmlNode;
    function GerarParcela: TACBrXmlNodeArray;
    function GerarGenericos: TACBrXmlNode;
    function GerarLinha: TACBrXmlNodeArray;

    //reforma tributária - especifíco provedor IPM
    function GerarXMLIBSCBSNFSe: TACBrXmlNode;
    function GerarValoresBrutosIbsCbs: TACBrXmlNode;
    function GerarValoresIbsEstadual: TACBrXmlNode;
    function GerarValoresIbsMunicipal: TACBrXmlNode;
    function GerarValoresCbsFederal: TACBrXmlNode;
    function GerarTotalizadores: TACBrXmlNode;
    function GerarGrupoValoresIbs: TACBrXmlNode;
    function GerarGrupoValoresIbsCreditoPresumido: TACBrXmlNode;
    function GerarGrupoValoresIbsEstadual: TACBrXmlNode;
    function GerarGrupoValoresIbsMunicipal: TACBrXmlNode;
    function GerarGrupoValoresCbs: TACBrXmlNode;
    function GerarGrupoValoresCbsCreditoPresumido: TACBrXmlNode;
  public
    function GerarXml: Boolean; override;

  end;

  { TNFSeW_IPM101 }

  TNFSeW_IPM101 = class(TNFSeW_IPM)
  protected
    procedure Configuracao; override;

  end;

  { TNFSeW_IPM204 }

  TNFSeW_IPM204 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

    function GerarServico: TACBrXmlNode; override;
    function GerarXMLIBSCBSServico: TACBrXmlNode;
    function GerarValoresBrutosIbsCbs: TACBrXmlNode;
    function GerarValoresIbsEstadual: TACBrXmlNode;
    function GerarValoresIbsMunicipal: TACBrXmlNode;
    function GerarValoresCbsFederal: TACBrXmlNode;
    function GerarTotalizadores: TACBrXmlNode;
    function GerarGrupoValoresIbs: TACBrXmlNode;
    function GerarGrupoValoresIbsCreditoPresumido: TACBrXmlNode;
    function GerarGrupoValoresIbsEstadual: TACBrXmlNode;
    function GerarGrupoValoresIbsMunicipal: TACBrXmlNode;
    function GerarGrupoValoresCbs: TACBrXmlNode;
    function GerarGrupoValoresCbsCreditoPresumido: TACBrXmlNode;
  public
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrUtil.DateTime;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     IPM
//==============================================================================

{ TNFSeW_IPM }

function TNFSeW_IPM.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
begin
  Configuracao;

  ListaDeAlertas.Clear;

  Opcoes.DecimalChar := ',';
  {
    Se no arquivo ACBrNFSeXServicos.ini existe o campo: NaoGerarGrupoRps na
    definição da cidade o valor de NaoGerar é True
  }
  FpNaoGerarGrupoRps := FpAOwner.ConfigGeral.Params.TemParametro('NaoGerarGrupoRps');

  FDocument.Clear();

  NFSe.InfID.ID := NFSe.IdentificacaoRps.Numero;

  NFSeNode := CreateElement('nfse');

  if FpGerarID then
    NFSeNode.SetAttribute(FpAOwner.ConfigGeral.Identificador, NFSe.InfID.ID);

  FDocument.Root := NFSeNode;

  if (VersaoNFSe in [ve100, ve101]) and (Ambiente = taHomologacao) then
  begin
    if not FpNaoGerarGrupoRps then
      NFSeNode.AppendChild(AddNode(tcStr, '#2', 'identificador', 1, 80, 0,
        'nfseh_' + NFSe.IdentificacaoRps.Numero + '.' + NFSe.IdentificacaoRps.Serie, ''));

    {
     Na versão 1.01 (que é a que estou testando), a tag <nfse_teste> deve ser
     preenchida quando o usuário quer validar o seu XML.
     Quando a tag está no XML e o XML está válido, no lugar de simplesmente
     aceitar a NFS-e (vai entender), o provedor retorna o seguinte "erro":
     NFS-e válida para emissão.
     }
    NFSeNode.AppendChild(AddNode(tcStr, '#3', 'nfse_teste', 1, 1, 1, '1', ''));
  end
  else
  begin
    if not FpNaoGerarGrupoRps then
      NFSeNode.AppendChild(AddNode(tcStr, '#2', 'identificador', 1, 80, 0,
        'nfse_' + NFSe.IdentificacaoRps.Numero + '.' + NFSe.IdentificacaoRps.Serie, ''));
  end;

  xmlNode := GerarIdentificacaoRPS;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarValoresServico;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarPrestador;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarTomador;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarItens;
  NFSeNode.AppendChild(xmlNode);

  // Reforma Tributária
  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
  begin
    xmlNode := GerarXMLIBSCBS(NFSe.IBSCBS);
    NFSeNode.AppendChild(xmlNode);
  end;

  xmlNode := GerarGenericos;
  NFSeNode.AppendChild(xmlNode);

  if (NFSe.SituacaoNfse = snNormal) and (VersaoNFSe = ve101 ) then
  begin
    xmlNode := GerarFormaPagamento;
    NFSeNode.AppendChild(xmlNode);
  end;

  Result := True;
end;

procedure TNFSeW_IPM.Configuracao;
begin
  inherited Configuracao;

  FpGerarID := False;
  FpNrOcorrTagsTomador := 1;
  FpNrOcorrCodigoAtividade := -1;

  // Reforma Tributária
  NrOcorrindDest := -1;
  GerarDest := False;
  GerargReeRepRes := False;
end;

function TNFSeW_IPM.GerarFormaPagamento: TACBrXmlNode;
var
  xmlNode: TACBrXmlNode;
begin
  Result := CreateElement('forma_pagamento');

  Result.AppendChild(AddNode(tcStr, '#1', 'tipo_pagamento', 1, 1, 1,
               FpAOwner.CondicaoPagToStr(NFSe.CondicaoPagamento.Condicao), ''));

  if (NFSe.CondicaoPagamento.QtdParcela > 0) then
  begin
    xmlNode := GerarParcelas;
    Result.AppendChild(xmlNode);
  end;
end;

function TNFSeW_IPM.GerarGenericos: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := nil;

  if NFSe.Genericos.Count > 0 then
  begin
    Result := CreateElement('genericos');

    nodeArray := GerarLinha;

    if nodeArray <> nil then
    begin
      for i := 0 to Length(nodeArray) - 1 do
      begin
        Result.AppendChild(nodeArray[i]);
      end;
    end;
  end;
end;

function TNFSeW_IPM.GerarIdentificacaoRPS: TACBrXmlNode;
begin
  Result :=  nil;

  if (StrToIntDef(NFSe.IdentificacaoRps.Numero, 0) > 0) and
     (not FpNaoGerarGrupoRps) then
  begin
    Result := CreateElement('rps');

    Result.AppendChild(AddNode(tcStr, '#1', 'nro_recibo_provisorio', 1, 12, 1,
                                     NFSe.IdentificacaoRps.Numero, DSC_NUMRPS));

    Result.AppendChild(AddNode(tcStr, '#1', 'serie_recibo_provisorio', 1, 2, 1,
                                    NFSe.IdentificacaoRps.Serie, DSC_SERIERPS));

    Result.AppendChild(AddNode(tcDatVcto, '#1', 'data_emissao_recibo_provisorio', 1, 10, 1,
                                                NFSe.DataEmissaoRps, DSC_DEMI));

    Result.AppendChild(AddNode(tcStr, '#1', 'hora_emissao_recibo_provisorio', 1, 8, 1,
                  FormatDateTimeBr(NFSe.DataEmissaoRps, 'hh:mm:ss'), DSC_HEMI));
  end;
end;

function TNFSeW_IPM.GerarItens: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := CreateElement('itens');

  nodeArray := GerarLista;

  if nodeArray <> nil then
  begin
    for i := 0 to Length(nodeArray) - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

function TNFSeW_IPM.GerarLinha: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.Genericos.Count);

  for i := 0 to NFSe.Genericos.Count - 1 do
  begin
    Result[i] := CreateElement('linha');

    Result[i].AppendChild(AddNode(tcStr, '#', 'titulo', 1, 50, 0,
                                NFSe.Genericos[I].Titulo, DSC_GENERICOSTITULO));

    Result[i].AppendChild(AddNode(tcStr, '#', 'descricao', 1, 200, 0,
                         NFSe.Genericos[I].Descricao, DESC_GENERICOSDESCRICAO));

  end;

  if NFSe.Genericos.Count > 10 then
    wAlerta('#', 'linha', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

function TNFSeW_IPM.GerarLista: TACBrXmlNodeArray;
var
  i: integer;
  xDescr: string;
begin
  Result := nil;
  SetLength(Result, NFSe.Servico.ItemServico.Count);

  for i := 0 to NFSe.Servico.ItemServico.Count - 1 do
  begin
    Result[i] := CreateElement('lista');

    Result[i].AppendChild(AddNode(tcStr, '#', 'tributa_municipio_prestador', 1, 1, 1,
      FpAOwner.SimNaoToStr(NFSe.Servico.ItemServico[I].TribMunPrestador), ''));

    Result[i].AppendChild(AddNode(tcStr, '#', 'codigo_local_prestacao_servico', 1, 9, 1,
      CodIBGEToCodTOM(StrToIntDef(NFSe.Servico.ItemServico[I].CodMunPrestacao, 0)), ''));

    Result[i].AppendChild(AddNode(tcStr, '#', 'unidade_codigo', 1, 9, 0,
                   UnidadeToStr(NFSe.Servico.ItemServico[I].TipoUnidade), ''));

    Result[i].AppendChild(AddNode(tcDe10, '#', 'unidade_quantidade', 1, 15, 0,
                                   NFSe.Servico.ItemServico[I].Quantidade, ''));

    Result[i].AppendChild(AddNode(tcDe10, '#', 'unidade_valor_unitario', 1, 15, 0,
                                NFSe.Servico.ItemServico[I].ValorUnitario, ''));

    Result[i].AppendChild(AddNode(tcStr, '#', 'codigo_item_lista_servico', 1, 9, 1,
                 OnlyNumber(NFSe.Servico.ItemServico[I].ItemListaServico), ''));

    Result[i].AppendChild(AddNode(tcStr, '#', 'codigo_nbs', 1, 9, 0,
                                       OnlyNumber(NFSe.Servico.CodigoNBS), ''));

    Result[i].AppendChild(AddNode(tcStr, '#', 'codigo_atividade', 1, 9, FpNrOcorrCodigoAtividade,
                       OnlyNumber(NFSe.Servico.ItemServico[I].CodigoCnae), ''));

    if NFSe.Servico.ItemServico[I].Descricao = '' then
      xDescr := NFSe.Servico.Discriminacao
    else
      xDescr := NFSe.Servico.ItemServico[I].Descricao;

    xDescr := StringReplace(xDescr, Opcoes.QuebraLinha,
                            FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]);

    Result[i].AppendChild(AddNode(tcStr, '#', 'descritivo', 1, 1000, 1,
                                                                   xDescr, ''));

    if NFSe.Servico.ItemServico[I].Aliquota = 0 then
      Result[i].AppendChild(AddNode(tcDe4, '#', 'aliquota_item_lista_servico', 1, 15, 1,
                                             NFSe.Servico.Valores.Aliquota, ''))
    else
      Result[i].AppendChild(AddNode(tcDe4, '#', 'aliquota_item_lista_servico', 1, 15, 1,
                                     NFSe.Servico.ItemServico[I].Aliquota, ''));

    Result[i].AppendChild(AddNode(tcInt, '#', 'situacao_tributaria', 1, 4, 1,
                           NFSe.Servico.ItemServico[I].SituacaoTributaria, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#', 'valor_tributavel', 1, 15, 0,
                              NFSe.Servico.ItemServico[I].ValorTributavel, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#', 'valor_deducao', 1, 15, 0,
                                NFSe.Servico.ItemServico[I].ValorDeducoes, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#', 'valor_desconto_incondicional', 1, 15, 0,
                       NFSe.Servico.ItemServico[I].DescontoIncondicionado, ''));

    if NFSe.Servico.ItemServico[I].SituacaoTributaria in [3, 4] then
      Result[i].AppendChild(AddNode(tcDe2, '#', 'valor_issrf', 1, 15, 1,
                          NFSe.Servico.ItemServico[I].ValorISSRetido, DSC_VISS))
    else
      Result[i].AppendChild(AddNode(tcDe2, '#', 'valor_issrf', 1, 15, 0,
                         NFSe.Servico.ItemServico[I].ValorISSRetido, DSC_VISS));

    Result[i].AppendChild(AddNode(tcStr, '#', 'cno', 1, 15, 0,
                                       NFSe.Servico.ItemServico[I].CodCNO, ''));
  end;

  if NFSe.Servico.ItemServico.Count > 10 then
    wAlerta('#', 'lista', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

function TNFSeW_IPM.GerarParcela: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.CondicaoPagamento.Parcelas.Count);

  for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
  begin
    Result[i] := CreateElement('parcela');

    Result[i].AppendChild(AddNode(tcStr, '#', 'numero', 1, 2, 1,
                         NFSe.CondicaoPagamento.Parcelas.Items[i].Parcela, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#', 'valor', 1, 15, 1,
                           NFSe.CondicaoPagamento.Parcelas.Items[i].Valor, ''));

    Result[i].AppendChild(AddNode(tcDatVcto, '#', 'data_vencimento', 10, 10, 1,
                  NFSe.CondicaoPagamento.Parcelas.Items[i].DataVencimento, ''));
  end;

  if NFSe.CondicaoPagamento.Parcelas.Count > 10 then
    wAlerta('#', 'parcela', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

function TNFSeW_IPM.GerarParcelas: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := CreateElement('parcelas');

  nodeArray := GerarParcela;

  if nodeArray <> nil then
  begin
    for i := 0 to Length(nodeArray) - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

function TNFSeW_IPM.GerarPrestador: TACBrXmlNode;
begin
  Result := CreateElement('prestador');

  Result.AppendChild(AddNode(tcStr, '#1', 'cpfcnpj', 11, 14, 1,
          OnlyNumber(NFSe.Prestador.IdentificacaoPrestador.CpfCnpj), DSC_CNPJ));

  Result.AppendChild(AddNode(tcStr, '#1', 'cidade', 1, 9, 0,
  CodIBGEToCodTOM(StrToIntDef(NFSe.Prestador.Endereco.CodigoMunicipio, 0)), ''));
end;

function TNFSeW_IPM.GerarTomador: TACBrXmlNode;
begin
  Result := CreateElement('tomador');

  Result.AppendChild(AddNode(tcStr, '#1', 'endereco_informado', 1, 1, 0,
            FpAOwner.SimNaoOpcToStr(NFSe.Tomador.Endereco.EnderecoInformado), ''));

  if Trim(NFSe.Tomador.IdentificacaoTomador.DocEstrangeiro) <> '' then
  begin
    Result.AppendChild(AddNode(tcStr, '#1', 'tipo', 1, 1, 1, 'E', ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'identificador', 1, 20, 1,
                   Trim(NFSe.Tomador.IdentificacaoTomador.DocEstrangeiro), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'estado', 1, 100, 1,
                                                 NFSe.Tomador.Endereco.UF, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'pais', 1, 100, 1,
                                              NFSe.Tomador.Endereco.xPais, ''));
  end
  else
  begin
    if (NFSe.Tomador.IdentificacaoTomador.Tipo in [tpPFNaoIdentificada, tpPF]) and
       (Length(OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj)) < 14) then
      Result.AppendChild(AddNode(tcStr, '#1', 'tipo', 1, 1, 1, 'F', ''))
    else
      Result.AppendChild(AddNode(tcStr, '#1', 'tipo', 1, 1, 1, 'J', ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'cpfcnpj', 1, 14, FpNrOcorrTagsTomador,
                OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), DSC_CNPJ));

    Result.AppendChild(AddNode(tcStr, '#1', 'ie', 0, 16, FpNrOcorrTagsTomador,
        OnlyNumber(NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual), DSC_IE));
  end;

  Result.AppendChild(AddNode(tcStr, '#1', 'nome_razao_social', 1, 100, FpNrOcorrTagsTomador,
                                          NFSe.Tomador.RazaoSocial, DSC_XNOME));

  Result.AppendChild(AddNode(tcStr, '#1', 'sobrenome_nome_fantasia', 1, 100, FpNrOcorrTagsTomador,
                                                NFSe.Tomador.NomeFantasia, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'logradouro', 1, 70, FpNrOcorrTagsTomador,
                                     NFSe.Tomador.Endereco.Endereco, DSC_XLGR));

  Result.AppendChild(AddNode(tcStr, '#1', 'email', 1, 100, FpNrOcorrTagsTomador,
                                               NFSe.Tomador.Contato.Email, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'numero_residencia', 1, 8, 0,
                                        NFSe.Tomador.Endereco.Numero, DSC_NRO));

  Result.AppendChild(AddNode(tcStr, '#1', 'complemento', 1, 50, FpNrOcorrTagsTomador,
                                  NFSe.Tomador.Endereco.Complemento, DSC_XCPL));

  Result.AppendChild(AddNode(tcStr, '#1', 'ponto_referencia', 1, 100, FpNrOcorrTagsTomador,
                                    NFSe.Tomador.Endereco.PontoReferencia, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'bairro', 1, 30, FpNrOcorrTagsTomador,
                                    NFSe.Tomador.Endereco.Bairro, DSC_XBAIRRO));

  if Trim(NFSe.Tomador.IdentificacaoTomador.DocEstrangeiro) <> '' then
    Result.AppendChild(AddNode(tcStr, '#1', 'cidade', 1, 100, FpNrOcorrTagsTomador,
                                          NFSe.Tomador.Endereco.xMunicipio, ''))
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'cidade', 1, 9, FpNrOcorrTagsTomador,
   CodIBGEToCodTOM(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0)), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cep', 1, 8, FpNrOcorrTagsTomador,
                                    OnlyNumber(NFSe.Tomador.Endereco.CEP), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'ddd_fone_comercial', 1, 3, FpNrOcorrTagsTomador,
                                            NFSe.Tomador.Contato.DDD, DSC_DDD));

  Result.AppendChild(AddNode(tcStr, '#1', 'fone_comercial', 1, 9, FpNrOcorrTagsTomador,
                                            NFSe.Tomador.Contato.Telefone, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'ddd_fone_residencial', 1, 3, FpNrOcorrTagsTomador,
                                                                       '', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'fone_residencial', 1, 9, FpNrOcorrTagsTomador,
                                                                       '', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'ddd_fax', 1, 3, FpNrOcorrTagsTomador,
                                                                       '', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'fone_fax', 1, 9, FpNrOcorrTagsTomador,
                                                                       '', ''));
end;

function TNFSeW_IPM.GerarValoresServico: TACBrXmlNode;
begin
  Result := CreateElement('nf');

  if NFSe.SituacaoNfse = snCancelado then
  begin
    Result.AppendChild(AddNode(tcStr, '#1', 'numero', 0, 9, 1,
                                                              NFSe.Numero, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'situacao', 1, 1, 1, 'C', ''));
  end;

  Result.AppendChild(AddNode(tcDatVcto, '#1', 'data_fato_gerador', 1, 10, 0,
                                                   NFSe.Competencia, DSC_DEMI));

  Result.AppendChild(AddNode(tcDe2, '#1', 'valor_total', 1, 15, 1,
                             NFSe.Servico.Valores.ValorServicos, DSC_VSERVICO));

  Result.AppendChild(AddNode(tcDe2, '#1', 'valor_desconto', 1, 15, 0,
                       NFSe.Servico.Valores.DescontoIncondicionado, DSC_VDESC));

  Result.AppendChild(AddNode(tcDe2, '#1', 'valor_ir', 1, 15, 1,
                                             NFSe.Servico.Valores.ValorIr, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'valor_inss', 1, 15, 0,
                                           NFSe.Servico.Valores.ValorInss, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'valor_contribuicao_social', 1, 15, 0,
                                           NFSe.Servico.Valores.ValorCsll, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'valor_rps', 1, 15, 0,
                                                                        0, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'valor_pis', 1, 15, 0,
                                      NFSe.Servico.Valores.ValorPis, DSC_VPIS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'valor_cofins', 1, 15, 0,
                                NFSe.Servico.Valores.ValorCofins, DSC_VCOFINS));

  Result.AppendChild(AddNode(tcStr, '#1', 'observacao', 1, 1000, 0,
                                        NFSe.OutrasInformacoes, DSC_OUTRASINF));

  //reforma tributária - especifíco provedor IPM
  Result.AppendChild(GerarXMLIBSCBSNFSe);
end;

{ TNFSeW_IPM101 }

procedure TNFSeW_IPM101.Configuracao;
begin
  inherited Configuracao;

  FpGerarID := True;
  FpNrOcorrTagsTomador := 1;

  if FpAOwner.ConfigGeral.Params.ParamTemValor('GerarTag', 'codigo_atividade') then
    FpNrOcorrCodigoAtividade := 1;
end;

{ TNFSeW_IPM204 }

procedure TNFSeW_IPM204.Configuracao;
begin
  inherited Configuracao;

  FormatoAliq := tcDe2;

  NrOcorrInformacoesComplemetares := 0;
  NrOcorrCodigoPaisTomador := -1;

  TagTomador := 'TomadorServico';

  // Reforma Tributária
  NrOcorrtpOper := -1;
  NrOcorrindDest := -1;
  GerarDest := False;
  GerargReeRepRes := False;
end;

function TNFSeW_IPM204.GerarXMLIBSCBSServico: TACBrXmlNode;
begin
  Result := CreateElement('IBSCBS');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedutor', 1, 2, 1,
                                                 NFSe.infNFSe.IBSCBS.pRedutor));

  Result.AppendChild(GerarValoresBrutosIbsCbs);
  Result.AppendChild(GerarTotalizadores);
end;

function TNFSeW_IPM204.GerarValoresBrutosIbsCbs: TACBrXmlNode;
begin
  Result := CreateElement('valores');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vBC', 1, 15, 1,
                                              NFSe.infNFSe.IBSCBS.valores.vBC));

  Result.AppendChild(GerarValoresIbsEstadual);
  Result.AppendChild(GerarValoresIbsMunicipal);
  Result.AppendChild(GerarValoresCbsFederal);
end;

function TNFSeW_IPM204.GerarValoresIbsEstadual: TACBrXmlNode;
begin
  Result := CreateElement('uf');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pIBSUF', 1, 2, 1,
                                        NFSe.infNFSe.IBSCBS.valores.uf.pIBSUF));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedAliqUF', 1, 3, 1,
                                    NFSe.infNFSe.IBSCBS.valores.uf.pRedAliqUF));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqEfetUF', 1, 2, 1,
                                   NFSe.infNFSe.IBSCBS.valores.uf.pAliqEfetUF));
end;

function TNFSeW_IPM204.GerarValoresIbsMunicipal: TACBrXmlNode;
begin
  Result := CreateElement('mun');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pIBSMun', 1, 2, 1,
                                      NFSe.infNFSe.IBSCBS.valores.mun.pIBSMun));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedAliqMun', 1, 3, 1,
                                  NFSe.infNFSe.IBSCBS.valores.mun.pRedAliqMun));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqEfetMun', 1, 2, 1,
                                 NFSe.infNFSe.IBSCBS.valores.mun.pAliqEfetMun));
end;

function TNFSeW_IPM204.GerarValoresCbsFederal: TACBrXmlNode;
begin
  Result := CreateElement('fed');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pCBS', 1, 2, 1,
                                         NFSe.infNFSe.IBSCBS.valores.fed.pCBS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedAliqCBS', 1, 3, 1,
                                  NFSe.infNFSe.IBSCBS.valores.fed.pRedAliqCBS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqEfetCBS', 1, 2, 1,
                                 NFSe.infNFSe.IBSCBS.valores.fed.pAliqEfetCBS));
end;

function TNFSeW_IPM204.GerarTotalizadores: TACBrXmlNode;
begin
  Result := CreateElement('totCIBS');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vTotNF', 1, 15, 1,
                                           NFSe.infNFSe.IBSCBS.totCIBS.vTotNF));

  Result.AppendChild(GerarGrupoValoresIbs);
  Result.AppendChild(GerarGrupoValoresCbs);
end;

function TNFSeW_IPM204.GerarGrupoValoresIbs: TACBrXmlNode;
begin
  Result := CreateElement('gIBS');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vIBSTot', 1, 15, 1,
                                     NFSe.infNFSe.IBSCBS.totCIBS.gIBS.vIBSTot));

  Result.AppendChild(GerarGrupoValoresIbsCreditoPresumido);
  Result.AppendChild(GerarGrupoValoresIbsEstadual);
  Result.AppendChild(GerarGrupoValoresIbsMunicipal);
end;

function TNFSeW_IPM204.GerarGrupoValoresIbsEstadual: TACBrXmlNode;
begin
  Result := CreateElement('gIBSUFTot');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vDifUF', 1, 15, 1,
                            NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSUFTot.vDifUF));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vIBSUF', 1, 15, 1,
                            NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSUFTot.vIBSUF));
end;

function TNFSeW_IPM204.GerarGrupoValoresIbsMunicipal: TACBrXmlNode;
begin
  Result := CreateElement('gIBSMunTot');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vDifMun', 1, 15, 1,
                          NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSMunTot.vDifMun));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vIBSMun', 1, 15, 1,
                          NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSMunTot.vIBSMun));
end;

function TNFSeW_IPM204.GerarGrupoValoresIbsCreditoPresumido: TACBrXmlNode;
begin
  Result := CreateElement('gIBSCredPres');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pCredPresIBS', 1, 2, 1,
                   NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSCredPres.pCredPresIBS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vCredPresIBS', 1, 15, 1,
                   NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSCredPres.vCredPresIBS));
end;

function TNFSeW_IPM204.GerarGrupoValoresCbs: TACBrXmlNode;
begin
  Result := CreateElement('gCBS');

  Result.AppendChild(GerarGrupoValoresCbsCreditoPresumido);

  Result.AppendChild(AddNode(tcDe2, '#1', 'vDifCBS', 1, 15, 1,
                                     NFSe.infNFSe.IBSCBS.totCIBS.gCBS.vDifCBS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vCBS', 1, 15, 1,
                                        NFSe.infNFSe.IBSCBS.totCIBS.gCBS.vCBS));
end;

function TNFSeW_IPM204.GerarGrupoValoresCbsCreditoPresumido: TACBrXmlNode;
begin
  Result := CreateElement('gCBSCredPres');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pCredPresCBS', 1, 2, 1,
                   NFSe.infNFSe.IBSCBS.totCIBS.gCBS.gCBSCredPres.pCredPresCBS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vCredPresCBS', 1, 15, 1,
                   NFSe.infNFSe.IBSCBS.totCIBS.gCBS.gCBSCredPres.vCredPresCBS));
end;

function TNFSeW_IPM204.GerarServico: TACBrXmlNode;
begin
  Result := inherited GerarServico;

  // Reforma Tributária
  if (NFSe.infNFSe.IBSCBS.pRedutor > 0) or
     (NFSe.infNFSe.IBSCBS.valores.vBC > 0) then
    Result.AppendChild(GerarXMLIBSCBSServico);
end;

function TNFSeW_IPM204.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
begin
  // Em conformidade com a versão 2 do layout da ABRASF não deve ser alterado

  ListaDeAlertas.Clear;

  case VersaoNFSe of
    ve203:
      begin
        GerarTagNifTomador := True;
        NrOcorrCodigoMunicInterm := 1;
      end;

    ve204:
      begin
        GerarTagNifTomador := True;
        GerarEnderecoExterior := True;

        NrOcorrCodigoNBS := 0;
        NrOcorrCodigoMunicInterm := 1;

        NrOcorrCodTribMun_1 := -1;
        NrOcorrDiscriminacao_1 := -1;
        NrOcorrCodigoMunic_1 := -1;

        NrOcorrCodTribMun_2 := 0;
        NrOcorrDiscriminacao_2 := 0;
        NrOcorrCodigoMunic_2 := 0;
      end;
  else
    begin
      GerarTagNifTomador := False;
      GerarEnderecoExterior := False;
      NrOcorrCodigoMunicInterm := -1;
    end;
  end;

  FDocument.Clear();

  NFSeNode := CreateElement('Rps');

  if GerarNSRps then
    NFSeNode.SetNamespace(FpAOwner.ConfigMsgDados.XmlRps.xmlns, Self.PrefixoPadrao);

  FDocument.Root := NFSeNode;

  if FormatoDiscriminacao <> fdNenhum then
    ConsolidarVariosItensServicosEmUmSo;

  xmlNode := GerarInfDeclaracaoPrestacaoServico;
  NFSeNode.AppendChild(xmlNode);

  // Reforma Tributária
  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
    NFSeNode.AppendChild(GerarXMLIBSCBS(NFSe.IBSCBS));

  Result := True;
end;

function TNFSeW_IPM.GerarXMLIBSCBSNFSe: TACBrXmlNode;
begin
  Result := nil;

  if (NFSE.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) and
     (NFSE.IBSCBS.valores.trib.gIBSCBS.cClassTrib <> '') then
  begin
    Result := CreateElement('IBSCBS');

    Result.AppendChild(AddNode(tcDe2, '#1', 'pRedutor', 1, 2, 1,
                                                 NFSe.infNFSe.IBSCBS.pRedutor));

    Result.AppendChild(GerarValoresBrutosIbsCbs);
    Result.AppendChild(GerarTotalizadores);
  end;
end;

function TNFSeW_IPM.GerarValoresBrutosIbsCbs: TACBrXmlNode;
begin
  Result := CreateElement('valores');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vBC', 1, 15, 1,
                                              NFSe.infNFSe.IBSCBS.valores.vBC));

  Result.AppendChild(GerarValoresIbsEstadual);
  Result.AppendChild(GerarValoresIbsMunicipal);
  Result.AppendChild(GerarValoresCbsFederal);
end;

function TNFSeW_IPM.GerarValoresIbsEstadual: TACBrXmlNode;
begin
  Result := CreateElement('uf');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pIBSUF', 1, 2, 1,
                                        NFSe.infNFSe.IBSCBS.valores.uf.pIBSUF));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedAliqUF', 1, 3, 1,
                                    NFSe.infNFSe.IBSCBS.valores.uf.pRedAliqUF));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqEfetUF', 1, 2, 1,
                                   NFSe.infNFSe.IBSCBS.valores.uf.pAliqEfetUF));
end;

function TNFSeW_IPM.GerarValoresIbsMunicipal: TACBrXmlNode;
begin
  Result := CreateElement('mun');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pIBSMun', 1, 2, 1,
                                      NFSe.infNFSe.IBSCBS.valores.mun.pIBSMun));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedAliqMun', 1, 3, 1,
                                  NFSe.infNFSe.IBSCBS.valores.mun.pRedAliqMun));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqEfetMun', 1, 2, 1,
                                 NFSe.infNFSe.IBSCBS.valores.mun.pAliqEfetMun));
end;

function TNFSeW_IPM.GerarValoresCbsFederal: TACBrXmlNode;
begin
  Result := CreateElement('fed');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pCBS', 1, 2, 1,
                                         NFSe.infNFSe.IBSCBS.valores.fed.pCBS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedAliqCBS', 1, 3, 1,
                                  NFSe.infNFSe.IBSCBS.valores.fed.pRedAliqCBS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqEfetCBS', 1, 2, 1,
                                 NFSe.infNFSe.IBSCBS.valores.fed.pAliqEfetCBS));
end;

function TNFSeW_IPM.GerarTotalizadores: TACBrXmlNode;
begin
  Result := CreateElement('totCIBS');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vTotNF', 1, 15, 1,
                                           NFSe.infNFSe.IBSCBS.totCIBS.vTotNF));

  Result.AppendChild(GerarGrupoValoresIbs);
  Result.AppendChild(GerarGrupoValoresCbs);
end;

function TNFSeW_IPM.GerarGrupoValoresIbs: TACBrXmlNode;
begin
  Result := CreateElement('gIBS');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vIBSTot', 1, 15, 1,
                                     NFSe.infNFSe.IBSCBS.totCIBS.gIBS.vIBSTot));

  Result.AppendChild(GerarGrupoValoresIbsCreditoPresumido);
  Result.AppendChild(GerarGrupoValoresIbsEstadual);
  Result.AppendChild(GerarGrupoValoresIbsMunicipal);
end;

function TNFSeW_IPM.GerarGrupoValoresIbsCreditoPresumido: TACBrXmlNode;
begin
  Result := CreateElement('gIBSCredPres');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pCredPresIBS', 1, 2, 1,
                   NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSCredPres.pCredPresIBS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vCredPresIBS', 1, 15, 1,
                   NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSCredPres.vCredPresIBS));
end;

function TNFSeW_IPM.GerarGrupoValoresIbsEstadual: TACBrXmlNode;
begin
  Result := CreateElement('gIBSUFTot');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vDifUF', 1, 15, 1,
                            NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSUFTot.vDifUF));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vIBSUF', 1, 15, 1,
                            NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSUFTot.vIBSUF));
end;

function TNFSeW_IPM.GerarGrupoValoresIbsMunicipal: TACBrXmlNode;
begin
  Result := CreateElement('gIBSMunTot');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vDifMun', 1, 15, 1,
                          NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSMunTot.vDifMun));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vIBSMun', 1, 15, 1,
                          NFSe.infNFSe.IBSCBS.totCIBS.gIBS.gIBSMunTot.vIBSMun));
end;

function TNFSeW_IPM.GerarGrupoValoresCbs: TACBrXmlNode;
begin
  Result := CreateElement('gCBS');

  Result.AppendChild(GerarGrupoValoresCbsCreditoPresumido);

  Result.AppendChild(AddNode(tcDe2, '#1', 'vDifCBS', 1, 15, 1,
                                     NFSe.infNFSe.IBSCBS.totCIBS.gCBS.vDifCBS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vCBS', 1, 15, 1,
                                        NFSe.infNFSe.IBSCBS.totCIBS.gCBS.vCBS));
end;

function TNFSeW_IPM.GerarGrupoValoresCbsCreditoPresumido: TACBrXmlNode;
begin
  Result := CreateElement('gCBSCredPres');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pCredPresCBS', 1, 2, 1,
                   NFSe.infNFSe.IBSCBS.totCIBS.gCBS.gCBSCredPres.pCredPresCBS));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vCredPresCBS', 1, 15, 1,
                   NFSe.infNFSe.IBSCBS.totCIBS.gCBS.gCBSCredPres.vCredPresCBS));
end;

end.
