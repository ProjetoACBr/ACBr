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

unit Conam.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXGravarXml,
  ACBrNFSeXConversao,
  ACBrNFSeXConsts,
  ACBrNFSeXClass;

type
  { TNFSeW_Conam }

  TNFSeW_Conam = class(TNFSeWClass)
  private
    FQtdReg30: Integer;
    FValReg30: Double;
    FQtdReg40: Integer;
    FQtdReg50: Integer;
  protected
    procedure Configuracao; override;

    function GerarReg30: TACBrXmlNode;
    function GerarReg30Item(const Sigla: string; Aliquota, Valor: Double): TACBrXmlNode;
    function GerarReg40: TACBrXmlNode;
    function GerarReg40Item(const Sigla, Conteudo: string): TACBrXmlNode;
    function GerarReg50: TACBrXmlNode;
    function GerarReg50Item(const TipoEnd: string): TACBrXmlNode;

    function GerarXmlItemDestinatario(Dest: TDadosdaPessoa): TACBrXmlNode;
    function GerarXMLItemEnderecoDestinatario(Ender: TEnder): TACBrXmlNode;

    function GerarXmlItemObra(Obra: TDadosConstrucaoCivil): TACBrXmlNode;

    function GerarXmlItemImovel(Imovel: TDadosimovel): TACBrXmlNode;

    function GerarReg60(IBSCBS: TIBSCBSDPS): TACBrXmlNode;
    function GerarXMLItemgIBSCBS(gIBSCBS: TgIBSCBS): TACBrXmlNode;
    function GerarXMLItemgTribRegular(gTribRegular: TgTribRegular): TACBrXmlNode;
    function GerarXMLItemgDif(gDif: TgDif): TACBrXmlNode;
  public
    function GerarXml: Boolean; override;

    property QtdReg30: Integer read FQtdReg30 write FQtdReg30;
    property ValReg30: Double  read FValReg30 write FValReg30;
    property QtdReg40: Integer read FQtdReg40 write FQtdReg40;
    property QtdReg50: Integer read FQtdReg50 write FQtdReg50;
  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrUtil.Strings;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Conam
//==============================================================================

{ TNFSeW_Conam }

procedure TNFSeW_Conam.Configuracao;
begin
  inherited Configuracao;

//  PrefixoPadrao := 'nfe';
end;

function TNFSeW_Conam.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
  CpfCnpj, MunTomador, MunPrestador: String;
begin
  Configuracao;

  Opcoes.DecimalChar := ',';

  ListaDeAlertas.Clear;

  FDocument.Clear();

  NFSeNode := CreateElement('Reg20Item');

  FDocument.Root := NFSeNode;

  if NFSe.IdentificacaoRps.Tipo = trRPS then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'TipoNFS', 1, 3, 1, 'RPS', ''))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'TipoNFS', 1, 3, 1, 'RPC', ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'NumRps', 1, 9, 1,
                                    NFSe.IdentificacaoRps.Numero , DSC_NUMRPS));

  if NFSe.IdentificacaoRps.Serie = '' then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'SerRps', 1, 3, 1, '001', DSC_SERIERPS))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'SerRps', 1, 3, 1,
                                    NFSe.IdentificacaoRps.Serie, DSC_SERIERPS));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'DtEmi', 1, 10, 1,
                        FormatDateTime('dd/mm/yyyy', NFse.DataEmissaoRps), ''));

  if NFSe.Servico.Valores.IssRetido in [stNormal, stDevidoForaMunicipioNaoRetido] then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'RetFonte', 1, 3, 1, 'NAO', ''))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'RetFonte', 1, 3, 1, 'SIM', ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'CodSrv', 1, 5, 1,
                                            NFSe.Servico.ItemListaServico, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'DiscrSrv', 1, 4000, 1,
   StringReplace(NFSe.Servico.Discriminacao, Opcoes.QuebraLinha,
                      FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'VlNFS', 1, 16, 1,
                                       NFSe.Servico.Valores.ValorServicos, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'VlDed', 1, 16, 1,
                                       NFSe.Servico.Valores.ValorDeducoes, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'DiscrDed', 1, 4000, 1,
   StringReplace(NFSe.Servico.Valores.JustificativaDeducao, Opcoes.QuebraLinha,
                      FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'VlBasCalc', 1, 16, 1,
                                         NFSe.Servico.Valores.BaseCalculo, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'AlqIss', 1, 5, 1,
                                            NFSe.Servico.Valores.Aliquota, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'VlIss', 1, 16, 1,
                                            NFSe.Servico.Valores.ValorIss, ''));

  NFSeNode.AppendChild(AddNode(tcDe2, '#1', 'VlIssRet', 1, 16, 1,
                                      NFSe.Servico.Valores.ValorIssRetido, ''));

  CpfCnpj := Trim(NFSe.Tomador.IdentificacaoTomador.CpfCnpj);

  if (CpfCnpj <> 'CONSUMIDOR') and (CpfCnpj <> 'EXTERIOR') then
    CpfCnpj := OnlyNumber(CpfCnpj);

  {
    Se hover municipios com apostofro deve ser substituido por espaço,
    por exemplo SANTA BARBARA D'OESTE deve informar SANTA BARBARA D OESTE.
  }
  MunPrestador:= UpperCase(StringReplace(NFSe.Prestador.Endereco.xMunicipio, '''', ' ', [rfReplaceAll]));
  MunTomador:= UpperCase(StringReplace(NFSe.Tomador.Endereco.xMunicipio, '''', ' ', [rfReplaceAll]));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'CpfCnpTom', 1, 14, 1,
                                                                  CpfCnpj, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'RazSocTom', 1, 60, 1,
                                                 NFSe.Tomador.RazaoSocial, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'TipoLogtom', 1, 10, 1,
                                     NFSe.Tomador.Endereco.TipoLogradouro, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'LogTom', 1, 60, 1,
                                           NFSe.Tomador.Endereco.Endereco, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'NumEndTom', 1, 10, 1,
                                             NFSe.Tomador.Endereco.Numero, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'ComplEndTom', 1, 60, 1,
                                        NFSe.Tomador.Endereco.Complemento, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'BairroTom', 1, 60, 1,
                                             NFSe.Tomador.Endereco.Bairro, ''));

  if CpfCnpj = 'CONSUMIDOR'  then
  begin
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'MunTom', 1, 60, 1,
                                                             MunPrestador, ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'SiglaUFTom', 2, 2, 1,
                                               NFSe.Prestador.Endereco.UF, ''));
  end
  else
  begin
    if CpfCnpj = 'EXTERIOR' then
    begin
      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'MunTom', 1, 60, 1,
                                                               'EXTERIOR', ''));

      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'SiglaUFTom', 2, 2, 1,
                                                                     'EX', ''));
    end
    else
    begin
      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'MunTom', 1, 60, 1,
                                                                 MunTomador, ''));

      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'SiglaUFTom', 2, 2, 1,
                                                   NFSe.Tomador.Endereco.UF, ''));
    end;
  end;

  if (CpfCnpj <> 'CONSUMIDOR') and (CpfCnpj <> 'EXTERIOR') then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'CepTom', 1, 8, 1,
                                    OnlyNumber(NFSe.Tomador.Endereco.CEP), ''));
  {Conforme manual nao enviar a CepTom qdo Tomador for Consumidor ou Exterior}

  if (CpfCnpj = 'CONSUMIDOR') then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Telefone', 1, 10, 1, '', ''))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Telefone', 1, 10, 1,
                   RightStr(OnlyNumber(NFSe.Tomador.Contato.Telefone), 8), ''));

  if (CpfCnpj <> 'CONSUMIDOR') and (CpfCnpj <> 'EXTERIOR') then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'InscricaoMunicipal', 1, 20, 1,
                     NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, ''))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'InscricaoMunicipal', 1, 20, 1,
                                                                       '', ''));

  {
    Segundo o manual: Informar somente se Local de Prestação de Serviços for
    diferente do Endereço do Tomador.
  }
  if NFSe.LogradouLocalPrestacaoServico <> llpTomador then
  begin
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'TipoLogLocPre', 1, 10, 1,
                                     NFSe.Servico.Endereco.TipoLogradouro, ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'LogLocPre', 1, 60, 1,
                                         NFSe.Servico.Endereco.Endereco, ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'NumEndLocPre', 1, 10, 1,
                                           NFSe.Servico.Endereco.Numero, ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'ComplEndLocPre', 1, 60, 1,
                                      NFSe.Servico.Endereco.Complemento, ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'BairroLocPre', 1, 60, 1,
                                             NFSe.Servico.Endereco.Bairro, ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'MunLocPre', 1, 60, 1,
                                         NFSe.Servico.Endereco.xMunicipio, ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'SiglaUFLocpre', 2, 2, 1,
                                                 NFSe.Servico.Endereco.UF, ''));

    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'CepLocPre', 1, 8, 1,
                                                NFSe.Servico.Endereco.CEP, ''));
  end;

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Email1', 1, 120, 1,
                                               NFSe.Tomador.Contato.Email, ''));

  if NFSe.email.Count > 0 then
  begin
    if NFSe.email.Count > 1 then
    begin
      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Email2', 1, 120, 1,
                                              NFSe.email.Items[0].emailCC, ''));

      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Email3', 1, 120, 1,
                                              NFSe.email.Items[1].emailCC, ''));
    end
    else
      NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Email2', 1, 120, 1,
                                              NFSe.email.Items[0].emailCC, ''));
  end;

  QtdReg30 := 0;
  ValReg30 := 0;
  QtdReg40 := 0;
  QtdReg50 := 0;

  // So gera se houver tributos declarados
  if (NFSe.Servico.Valores.AliquotaPis > 0) or
     (NFSe.Servico.Valores.AliquotaCofins > 0) or
     (NFSe.Servico.Valores.AliquotaCsll > 0) or
     (NFSe.Servico.Valores.AliquotaInss > 0) or
     (NFSe.Servico.Valores.AliquotaIr > 0) then
  begin
    xmlNode := GerarReg30;
    NFSeNode.AppendChild(xmlNode);
  end;

  if (NFSe.Servico.Valores.DescontoIncondicionado > 0) or
     (NFSe.Servico.InfAdicional <> '') or
     (NFSe.Servico.CodigoCnae <> '') or
     (NFSe.Servico.CodigoAnexoCnae <> '') or
     (NFSe.Servico.CodigoServicoNacional <> '') or
     (NFSe.Servico.CodigoNBS <> '') or
     (NFSe.IBSCBS.tpEnteGov <> tcgNenhum) or
     (NFSe.Tomador.Endereco.CodigoPais <> 1058) then
  begin
    xmlNode := GerarReg40;
    NFSeNode.AppendChild(xmlNode);
  end;

  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.ConstrucaoCivil.nCei <> '') or
     (NFSe.IBSCBS.imovel.cCIB <> '') then
  begin
    xmlNode := GerarReg50;
    NFSeNode.AppendChild(xmlNode);
  end;

  xmlNode := GerarReg60(NFSe.IBSCBS);
  NFSeNode.AppendChild(xmlNode);

  NFSe.QtdReg30 := QtdReg30;
  NFSe.ValReg30 := ValReg30;
  NFSe.QtdReg40 := QtdReg40;
  NFSe.QtdReg50 := QtdReg50;

  Result := True;
end;

function TNFSeW_Conam.GerarReg30: TACBrXmlNode;
var
  xmlNode: TACBrXmlNode;
begin
  {
    Caso tenham tributos, estes podem ser declarados no registro 30 do XML
    assim eles serao destacados de forma separada na impressao da NFse
  }
  Result := CreateElement('Reg30');

  {
    Contém os tributos municipais, Estaduais e Federais que devem ser
    destacados na nota fiscal eletrônica impressa.
    Siglas de tributos permitidas:
    COFINS
    CSLL
    INSS
    IR
    PIS
  }

  if NFSe.Servico.Valores.AliquotaPis > 0 then
  begin
    xmlNode := GerarReg30Item('PIS',
      NFSe.Servico.Valores.AliquotaPis, NFSe.Servico.Valores.ValorPis);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg30);
    ValReg30 := ValReg30 + NFSe.Servico.Valores.ValorPis;
  end;

  if NFSe.Servico.Valores.AliquotaCofins > 0 then
  begin
    xmlNode := GerarReg30Item('COFINS',
      NFSe.Servico.Valores.AliquotaCofins, NFSe.Servico.Valores.ValorCofins);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg30);
    ValReg30 := ValReg30 + NFSe.Servico.Valores.ValorCofins;
  end;

  if NFSe.Servico.Valores.AliquotaCsll > 0 then
  begin
    xmlNode := GerarReg30Item('CSLL',
      NFSe.Servico.Valores.AliquotaCsll, NFSe.Servico.Valores.ValorCsll);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg30);
    ValReg30 := ValReg30 + NFSe.Servico.Valores.ValorCsll;
  end;

  if NFSe.Servico.Valores.AliquotaInss > 0 then
  begin
    xmlNode := GerarReg30Item('INSS',
      NFSe.Servico.Valores.AliquotaInss, NFSe.Servico.Valores.ValorInss);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg30);
    ValReg30 := ValReg30 + NFSe.Servico.Valores.ValorInss;
  end;

  if NFSe.Servico.Valores.AliquotaIr > 0 then
  begin
    xmlNode := GerarReg30Item('IR',
      NFSe.Servico.Valores.AliquotaIr, NFSe.Servico.Valores.ValorIr);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg30);
    ValReg30 := ValReg30 + NFSe.Servico.Valores.ValorIr;
  end;
end;

function TNFSeW_Conam.GerarReg30Item(const Sigla: string; Aliquota,
  Valor: Double): TACBrXmlNode;
begin
  Result := CreateElement('Reg30Item');

  Result.AppendChild(AddNode(tcStr, '#1', 'TributoSigla', 1, 6, 1, Sigla, ''));

  if (Sigla = 'PIS') or (Sigla = 'COFINS') then
    Result.AppendChild(AddNode(tcStr, '#1', 'TributoCST', 1, 2, 1, CSTToStr(NFSe.Servico.Valores.tribFed.CST), ''));

  if NFSe.Servico.Valores.tribFed.tpRetPisCofins = trpcNaoRetido then
    Result.AppendChild(AddNode(tcStr, '#1', 'TributoIdRet', 1, 3, 1, 'NAO', ''))
  else
   Result.AppendChild(AddNode(tcStr, '#1', 'TributoIdRet', 1, 3, 1, 'SIM', ''));

  if (Sigla = 'PIS') or (Sigla = 'COFINS') then
    Result.AppendChild(AddNode(tcDe2, '#1', 'TributoBaseCalc', 1, 16, 1, NFSe.Servico.Valores.tribFed.vBCPisCofins, ''));

  if (Sigla = 'INSS') and (NFSe.Servico.Valores.tribFed.vBCPCP > 0) then
    Result.AppendChild(AddNode(tcDe2, '#1', 'TributoBaseCalc', 1, 16, 1, NFSe.Servico.Valores.tribFed.vBCPCP, ''));

  if ((Sigla = 'IRRF') or (Sigla = 'IR')) and (NFSe.Servico.Valores.tribFed.vBCPIRRF > 0) then
    Result.AppendChild(AddNode(tcDe2, '#1', 'TributoBaseCalc', 1, 16, 1, NFSe.Servico.Valores.tribFed.vBCPIRRF, ''));

  if (Sigla = 'CSLL') and (NFSe.Servico.Valores.tribFed.vBCCSLL > 0) then
    Result.AppendChild(AddNode(tcDe2, '#1', 'TributoBaseCalc', 1, 16, 1, NFSe.Servico.Valores.tribFed.vBCCSLL, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'TributoAliquota', 1, 5, 1,
                                                                 Aliquota, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'TributoValor', 1, 16, 1, Valor, ''));
end;

function TNFSeW_Conam.GerarReg40: TACBrXmlNode;
var
  xmlNode: TACBrXmlNode;
  aValor: string;
begin
  Result := CreateElement('Reg40');

  if NFSe.Servico.Valores.DescontoIncondicionado > 0 then
  begin
    aValor := FormatFloat('0.00', NFSe.Servico.Valores.DescontoIncondicionado);
    xmlNode := GerarReg40Item('DESCINCOND', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
//    ValReg30 := ValReg30 + NFSe.Servico.Valores.ValorIr;
  end;

  if NFSe.Servico.InfAdicional <> '' then
  begin
    aValor := NFSe.Servico.InfAdicional;
    xmlNode := GerarReg40Item('DADOSADICIONAIS', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Servico.CodigoCnae <> '' then
  begin
    aValor := NFSe.Servico.CodigoCnae;
    xmlNode := GerarReg40Item('SRV_CNAE', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Servico.CodigoAnexoCnae <> '' then
  begin
    aValor := NFSe.Servico.CodigoAnexoCnae;
    xmlNode := GerarReg40Item('SRV_ANEXOSN', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Servico.CodigoServicoNacional <> '' then
  begin
    aValor := NFSe.Servico.CodigoServicoNacional;
    xmlNode := GerarReg40Item('SRV_CTN', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Servico.CodigoNBS <> '' then
  begin
    aValor := NFSe.Servico.CodigoNBS;
    xmlNode := GerarReg40Item('SRV_NBS', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.IBSCBS.tpEnteGov <> tcgNenhum then
  begin
    aValor := tpEnteGovToStr(NFSe.IBSCBS.tpEnteGov);
    xmlNode := GerarReg40Item('TOM_TPENTGOV', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Tomador.Endereco.CodigoPais <> 1058 then
  begin
    aValor := CodIBGEPaisToSiglaISO2(NFSe.Tomador.Endereco.CodigoPais);
    xmlNode := GerarReg40Item('TOMEXT_PAIS', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Tomador.Endereco.CodigoPais <> 1058 then
  begin
    aValor := NFSe.Tomador.Endereco.CEP;
    xmlNode := GerarReg40Item('TOMEXT_CODPOST', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Tomador.Endereco.CodigoPais <> 1058 then
  begin
    aValor := NFSe.Tomador.Endereco.xMunicipio;
    xmlNode := GerarReg40Item('TOMEXT_CIDADE', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Tomador.Endereco.CodigoPais <> 1058 then
  begin
    aValor := NFSe.Tomador.Endereco.UF;
    xmlNode := GerarReg40Item('TOMEXT_ESTPROVREG', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Servico.Endereco.CodigoPais <> 1058 then
  begin
    aValor := NFSe.Servico.Endereco.UF;
    xmlNode := GerarReg40Item('LOCPREEXT_CODPOST', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Servico.Endereco.CodigoPais <> 1058 then
  begin
    aValor := NFSe.Servico.Endereco.xMunicipio;
    xmlNode := GerarReg40Item('LOCPREEXT_CIDADE', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;

  if NFSe.Servico.Endereco.CodigoPais <> 1058 then
  begin
    aValor := NFSe.Servico.Endereco.UF;
    xmlNode := GerarReg40Item('LOCPREEXT_ESTPROVREG', aValor);
    Result.AppendChild(xmlNode);

    Inc(FQtdReg40);
  end;
end;

function TNFSeW_Conam.GerarReg40Item(const Sigla, Conteudo: string): TACBrXmlNode;
begin
  Result := CreateElement('Reg40Item');

  Result.AppendChild(AddNode(tcStr, '#1', 'SiglaCpoAdc', 1, 6, 1, Sigla, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'ConteudoCpoAdc', 1, 5, 1,
                                                                 Conteudo, ''));
end;

function TNFSeW_Conam.GerarReg50: TACBrXmlNode;
var
  xmlNode: TACBrXmlNode;
begin
  Result := CreateElement('Reg50');

  if NFSe.IBSCBS.dest.xNome <> '' then
  begin
    xmlNode := GerarReg50Item('1');
    Result.AppendChild(xmlNode);

    Inc(FQtdReg50);
  end;

  if NFSe.ConstrucaoCivil.nCei <> '' then
  begin
    xmlNode := GerarReg50Item('2');
    Result.AppendChild(xmlNode);

    Inc(FQtdReg50);
  end;

  if NFSe.IBSCBS.imovel.cCIB <> '' then
  begin
    xmlNode := GerarReg50Item('3');
    Result.AppendChild(xmlNode);

    Inc(FQtdReg50);
  end;
end;

function TNFSeW_Conam.GerarReg50Item(const TipoEnd: string): TACBrXmlNode;
var
  Tipo: Integer;
begin
  Result := CreateElement('Reg50Item');

  Result.AppendChild(AddNode(tcStr, '#1', 'TipoEnd', 1, 1, 1, TipoEnd, ''));

  case Tipo of
    1: Result.AppendChild(GerarXmlItemDestinatario(NFSe.IBSCBS.dest));
    2: Result.AppendChild(GerarXmlItemObra(NFSe.ConstrucaoCivil));
    3: Result.AppendChild(GerarXmlItemImovel(NFSe.IBSCBS.imovel));
  end;
end;

function TNFSeW_Conam.GerarXmlItemDestinatario(
  Dest: TDadosdaPessoa): TACBrXmlNode;
var
  Tipo, CNPJCPF: string;
  Tamanho: Integer;
begin
  Result := CreateElement('Destinatario');

  if Dest.Nif <> '' then
    Tipo := 'E'
  else
  begin
    CNPJCPF := OnlyAlphaNum(trim(Dest.CNPJCPF));
    if CNPJCPF <> '' then
    begin
      Tamanho := length(CNPJCPF);
      if (Tamanho <= 11) and (Tamanho > 0) then
      begin
        if (Tamanho <> 11) then
        begin
          CNPJCPF := PadLeft(CNPJCPF, 11, '0');
        end;
        Tipo := 'F';
      end
      else
      begin
        if (Tamanho > 0) and (Tamanho <> 14) then
        begin
          CNPJCPF := PadLeft(CNPJCPF, 14, '0');
        end;
        Tipo := 'J';
      end;
    end;
  end;

  Result.AppendChild(AddNode(tcStr, '#1', 'DestTipPes', 1, 1, 1, Tipo, ''));

  if Tipo = 'E' then
    Result.AppendChild(AddNode(tcStr, '#1', 'DestNIF', 1, 40, 1, Dest.Nif, ''))
  else
  if CNPJCPF <> '' then
    Result := AddNode(tcStr, '#1', 'DestCpfCnpj', 0, 14, 1, CNPJCPF)
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'DestNaoNIF', 1, 1, 1,
                                                NaoNIFToStr(Dest.cNaoNIF), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'DestNome', 1, 300, 1, Dest.xNome, ''));

  Result.AppendChild(GerarXMLItemEnderecoDestinatario(Dest.ender));
end;

function TNFSeW_Conam.GerarXMLItemEnderecoDestinatario(
  Ender: TEnder): TACBrXmlNode;
begin
  Result := CreateElement('Endereco');

  if Ender.endNac.CEP <> ''then
    Result.AppendChild(AddNode(tcStr, '#1', 'EndCEP', 8, 8, 1,
                                                          Ender.endNac.CEP, ''))
  else
  begin
    Result.AppendChild(AddNode(tcStr, '#1', 'EndExtPais', 2, 2, 1,
                               CodIBGEPaisToSiglaISO2(Ender.endExt.cPais), ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'EndExtCodPost', 1, 11, 1,
                                                    Ender.endExt.cEndPost, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'EndExtCidade', 1, 60, 1,
                                                     Ender.endExt.xCidade, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'EndExtEstProvReg', 1, 60, 1,
                                                 Ender.endExt.xEstProvReg, ''));
  end;

  Result.AppendChild(AddNode(tcStr, '#1', 'EndLog', 1, 255, 1, ender.xLgr, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'EndNum', 1, 60, 1, ender.nro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'EndCompl', 1, 156, 0, ender.xCpl, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'EndBairro', 1, 60, 1,
                                                            ender.xBairro, ''));
end;

function TNFSeW_Conam.GerarXmlItemObra(
  Obra: TDadosConstrucaoCivil): TACBrXmlNode;
begin
  Result := CreateElement('Obra');
  {
   1 - Local da obra é no município do prestador
   2 - Local da obra é fora do município do prestador
   3 - Local da obra é no exterior
  }
  Result.AppendChild(AddNode(tcStr, '#1', 'ObraIdLocal', 1, 1, 1,
                                                     Obra.LocalConstrucao, ''));

  Result.AppendChild(AddNode(tcDatVcto, '#1', 'ObraDtInicio', 10, 10, 1,
                                                          Obra.DataInicio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'ObraIdLocal', 1, 20, 1,
                                                     Obra.LocalConstrucao, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'ObraCEICNO', 1, 30, 1,
                                                                Obra.nCei, ''));
end;

function TNFSeW_Conam.GerarXmlItemImovel(Imovel: TDadosimovel): TACBrXmlNode;
begin
  Result := CreateElement('BensImov');

  Result.AppendChild(AddNode(tcStr, '#1', 'BensImobCIB', 1, 1, 1,
                                                              Imovel.cCIB, ''));
end;

function TNFSeW_Conam.GerarReg60(IBSCBS: TIBSCBSDPS): TACBrXmlNode;
begin
  Result := CreateElement('Reg60_RTC');

  Result.AppendChild(AddNode(tcStr, '#1', 'Finalidade', 1, 1, 1,
                                             finNFSeToStr(IBSCBS.finNFSe), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IndConsFin', 1, 1, 1,
                 IfThen(indFinalToStr(IBSCBS.indFinal) = '1','SIM','NAO'), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IndDest', 1, 1, 1,
                   IfThen(indDestToStr(IBSCBS.indDest) = '1','SIM','NAO'), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IndOpeOne', 1, 1, 1,
              IfThen(TIndicadorToStr(IBSCBS.IndOpeOne) = '1','SIM','NAO'), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IndCodOpe', 6, 6, 1,
                                                            IBSCBS.cIndOp, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'VlReeRepRes', 1, 15, 0,
                                                      IBSCBS.vlrReeRepRes, ''));

  Result.AppendChild(GerarXMLItemgIBSCBS(IBSCBS.valores.trib.gIBSCBS));
  Result.AppendChild(GerarXMLItemgTribRegular(IBSCBS.valores.trib.gIBSCBS.gTribRegular));
  Result.AppendChild(GerarXMLItemgDif(IBSCBS.valores.trib.gIBSCBS.gDif));
end;

function TNFSeW_Conam.GerarXMLItemgIBSCBS(gIBSCBS: TgIBSCBS): TACBrXmlNode;
begin
  Result := CreateElement('gIBSCBS');

  Result.AppendChild(AddNode(tcStr, '#1', 'CST', 3, 3, 1,
                                              CSTIBSCBSToStr(gIBSCBS.CST), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CClassTrib', 6, 6, 1,
                                                       gIBSCBS.cClassTrib, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CCodCredPres', 2, 2, 0,
                                        cCredPresToStr(gIBSCBS.cCredPres), ''));
end;

function TNFSeW_Conam.GerarXMLItemgTribRegular(
  gTribRegular: TgTribRegular): TACBrXmlNode;
begin
  Result := CreateElement('gTribReg');

  Result.AppendChild(AddNode(tcStr, '#1', 'CST', 3, 3, 1,
                                      CSTIBSCBSToStr(gTribRegular.CSTReg), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CClassTrib', 6, 6, 1,
                                               gTribRegular.cClassTribReg, ''));
end;

function TNFSeW_Conam.GerarXMLItemgDif(gDif: TgDif): TACBrXmlNode;
begin
  Result := CreateElement('gDif');

  Result.AppendChild(AddNode(tcDe2, '#1', 'PDifUF', 1, 15, 1,
                                                              gDif.pDifUF, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'PDifMun', 1, 15, 1,
                                                             gDif.pDifMun, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'PDifCBS', 1, 15, 1,
                                                             gDif.pDifCBS, ''));
end;

end.
