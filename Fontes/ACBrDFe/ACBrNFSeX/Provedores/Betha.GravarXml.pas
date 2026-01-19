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

unit Betha.GravarXml;

interface

uses
  SysUtils, Classes, IniFiles,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXGravarXml_ABRASFv1,
  ACBrNFSeXGravarXml_ABRASFv2,
  ACBrNFSeXConversao,
  ACBrNFSeXConsts,
  ACBrNFSeXClass,
  PadraoNacional.GravarXml;

type
  { TNFSeW_Betha }

  TNFSeW_Betha = class(TNFSeW_ABRASFv1)
  private
    LSecao: string;
  protected
    procedure Configuracao; override;

    function GerarCondicaoPagamento: TACBrXmlNode; override;
    function GerarParcelas: TACBrXmlNodeArray; override;

    procedure GerarINISecaoCondicaoPagamento(const AINIRec: TMemIniFile); override;
    procedure GerarINISecaoParcelas(const AINIRec: TMemIniFile); override;
  public
    function GerarXml: Boolean; override;
  end;

  { TNFSeW_Betha202 }

  TNFSeW_Betha202 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

    procedure DefinirIDDeclaracao; override;
  public
    function GerarXml: Boolean; override;
  end;

  { TNFSeW_BethaAPIPropria }

  TNFSeW_BethaAPIPropria = class(TNFSeW_PadraoNacional)
  private
    function DevoGerarXMLObra: Boolean;
  protected
    procedure Configuracao; override;

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
  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrUtil.Base,
  ACBrUtil.Strings;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Betha
//==============================================================================

{ TNFSeW_Betha }

procedure TNFSeW_Betha.Configuracao;
begin
  inherited Configuracao;

  FormatoItemListaServico := filsSemFormatacao;

  NrOcorrOutrasInformacoes := 0;
  NrOcorrValorISSRetido_1 := -1;
  NrOcorrValorISSRetido_2 := 0;
  NrOcorrInscEstTomador := 0;
end;

function TNFSeW_Betha.GerarCondicaoPagamento: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := CreateElement('CondicaoPagamento');

  if (NFSe.CondicaoPagamento.QtdParcela > 0) and
     (NFSe.CondicaoPagamento.Condicao = cpAPrazo) then
  begin
    Result.AppendChild(AddNode(tcStr, '#53', 'Condicao', 1, 15, 1,
         FpAOwner.CondicaoPagToStr(NFSe.CondicaoPagamento.Condicao), DSC_TPAG));

    Result.AppendChild(AddNode(tcInt, '#54', 'QtdParcela', 1, 03, 1,
                                 NFSe.CondicaoPagamento.QtdParcela, DSC_QPARC));

    nodeArray := GerarParcelas;
    if nodeArray <> nil then
    begin
      for i := 0 to Length(nodeArray) - 1 do
      begin
        Result.AppendChild(nodeArray[i]);
      end;
    end;
  end
  else
    Result.AppendChild(AddNode(tcStr, '#53', 'Condicao', 1, 15, 1,
                                                          'A_VISTA', DSC_TPAG));
end;

procedure TNFSeW_Betha.GerarINISecaoCondicaoPagamento(
  const AINIRec: TMemIniFile);
begin
  if NFSe.CondicaoPagamento.QtdParcela > 0 then
  begin
    LSecao:= 'CondicaoPagamento';
    AINIRec.WriteInteger(LSecao, 'QtdParcela', NFSe.CondicaoPagamento.QtdParcela);
    AINIRec.WriteString(LSecao, 'Condicao', FpAOwner.CondicaoPagToStr(NFSe.CondicaoPagamento.Condicao));
  end;
end;

procedure TNFSeW_Betha.GerarINISecaoParcelas(const AINIRec: TMemIniFile);
var
  I: Integer;
begin
  //Lista de parcelas, xx pode variar de 01-99 (provedor Betha versão 1 do Layout da ABRASF)
  for I := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
  begin
    LSecao:= 'Parcelas' + IntToStrZero(I + 1, 2);

    AINIRec.WriteString(LSecao, 'Parcela', NFSe.CondicaoPagamento.Parcelas.Items[I].Parcela);
    AINIRec.WriteDate(LSecao, 'DataVencimento', NFSe.CondicaoPagamento.Parcelas.Items[I].DataVencimento);
    AINIRec.WriteFloat(LSecao, 'Valor', NFSe.CondicaoPagamento.Parcelas.Items[I].Valor);
  end;
end;

function TNFSeW_Betha.GerarParcelas: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.CondicaoPagamento.Parcelas.Count);

  for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
  begin
    Result[i] := CreateElement('Parcelas');

    Result[i].AppendChild(AddNode(tcStr, '#55', 'Parcela', 1, 03, 1,
                  NFSe.CondicaoPagamento.Parcelas.Items[i].Parcela, DSC_NPARC));

    Result[i].AppendChild(AddNode(tcDatVcto, '#56', 'DataVencimento', 10, 10, 1,
           NFSe.CondicaoPagamento.Parcelas.Items[i].DataVencimento, DSC_DVENC));

    Result[i].AppendChild(AddNode(tcDe2, '#57', 'Valor', 1, 18, 1,
                    NFSe.CondicaoPagamento.Parcelas.Items[i].Valor, DSC_VPARC));
  end;

  if NFSe.CondicaoPagamento.Parcelas.Count > 10 then
    wAlerta('#54', 'Parcelas', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

function TNFSeW_Betha.GerarXml: Boolean;
begin
  if NFSe.OptanteSimplesNacional = snSim then
    NrOcorrAliquota := 1;

  Result := inherited GerarXml;
end;

{ TNFSeW_Betha202 }

procedure TNFSeW_Betha202.Configuracao;
begin
  inherited Configuracao;

  FormatoItemListaServico := filsSemFormatacao;

  NrOcorrCodigoPaisServico := -1;
end;

procedure TNFSeW_Betha202.DefinirIDDeclaracao;
begin
  NFSe.InfID.ID := 'rps' + OnlyNumber(NFSe.IdentificacaoRps.Numero)
end;

function TNFSeW_Betha202.GerarXml: Boolean;
begin
  if NFSe.Servico.Valores.IssRetido <> stNormal then
    NrOcorrRespRetencao := 0   // se tem a retenção a tag deve ser gerada
  else
    NrOcorrRespRetencao := -1; // se não tem a retenção a tag não deve ser gerada

  if NFSe.Tomador.Endereco.CodigoMunicipio = '9999999' then
    NrOcorrCodigoPaisTomador := 1
  else
    NrOcorrCodigoPaisTomador := -1;

  Result := inherited GerarXml;
end;

{ TNFSeW_BethaAPIPropria }

procedure TNFSeW_BethaAPIPropria.Configuracao;
begin
  inherited Configuracao;

  PrefixoPadrao := 'dps';
  GerargReeRepRes := false;
end;

function TNFSeW_BethaAPIPropria.GerarXMLIBSCBSAdquirente: TACBrXmlNode;
begin
  Result := CreateElement('adq');

  if NFSe.IBSCBS.Dest.CNPJCPF <> '' then
    Result.AppendChild(AddNodeCNPJCPF('#1', '#1', NFSe.IBSCBS.Dest.CNPJCPF))
  else
  begin
    if NFSe.IBSCBS.Dest.Nif <> '' then
      Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                                      NFSe.IBSCBS.Dest.Nif, ''))
    else
      Result.AppendChild(AddNode(tcStr, '#1', 'cNaoNIF', 1, 1, 1,
                                    NaoNIFToStr(NFSe.IBSCBS.Dest.cNaoNIF), ''));
  end;

  Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 300, 1,
                                                   NFSe.IBSCBS.Dest.xNome, ''));

  Result.AppendChild(GerarXMLEnderecoDestinatario(NFSe.IBSCBS.Dest.ender));

  Result.AppendChild(AddNode(tcStr, '#1', 'fone', 6, 20, 0,
                                                    NFSe.IBSCBS.Dest.fone, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'email', 1, 80, 0,
                                                   NFSe.IBSCBS.Dest.email, ''));

end;

function TNFSeW_BethaAPIPropria.GerarXMLIBSCBSEnderecoAdquirente(
  ender: Tender): TACBrXmlNode;
begin
  Result := nil;

  if (ender.endNac.cMun <> 0) or (ender.endExt.cPais <> 0) then
  begin
    Result := CreateElement('end');

    if (ender.endNac.cMun <> 0) then
      Result.AppendChild(GerarXMLIBSCBSEnderecoNacionalAdquirente(ender.endNac))
    else
      Result.AppendChild(GerarXMLIBSCBSEnderecoExteriorAdquirente(ender.endExt));

    Result.AppendChild(AddNode(tcStr, '#1', 'xLgr', 1, 255, 1, ender.xLgr, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'nro', 1, 60, 1, ender.nro, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xCpl', 1, 156, 0, ender.xCpl, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xBairro', 1, 60, 1,
                                                            ender.xBairro, ''));
  end;
end;

function TNFSeW_BethaAPIPropria.GerarXMLIBSCBSEnderecoExteriorAdquirente(
  endExt: TendExt): TACBrXmlNode;
begin
  Result := CreateElement('endExt');

  Result.AppendChild(AddNode(tcStr, '#1', 'cPais', 2, 2, 1,
                                     CodIBGEPaisToSiglaISO2(endExt.cPais), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                                          endExt.cEndPost, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                                           endExt.xCidade, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                                       endExt.xEstProvReg, ''));
end;

function TNFSeW_BethaAPIPropria.GerarXMLIBSCBSEnderecoNacionalAdquirente(
  endNac: TendNac): TACBrXmlNode;
begin
  Result := nil;

  if endNac.CEP <> '' then
  begin
    Result := CreateElement('endNac');

    Result.AppendChild(AddNode(tcInt, '#1', 'cMun', 7, 7, 1, endNac.cMun, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'CEP', 8, 8, 1, endNac.CEP, ''));
  end;
end;

function TNFSeW_BethaAPIPropria.GerarXMLEnderecoExteriorObra: TACBrXmlNode;
begin
  Result := CreateElement('endExt');
  //verificar tamanho cPais e se é referente xPais ou CodigoPais    // nao é explicito no schema
  Result.AppendChild(AddNode(tcStr, '#1', 'cPais', 1, 200, 1,
                                      NFSe.ConstrucaoCivil.Endereco.xPais, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cEndPost', 1, 11, 1,
                                        NFSe.ConstrucaoCivil.Endereco.CEP, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xCidade', 1, 60, 1,
                                 NFSe.ConstrucaoCivil.Endereco.xMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xEstProvReg', 1, 60, 1,
                                         NFSe.ConstrucaoCivil.Endereco.UF, ''));
end;

function TNFSeW_BethaAPIPropria.GerarXMLFornecedor(Item: Integer): TACBrXmlNode;
begin
  Result := nil;

  with NFSe.Servico.Valores.DocDeducao.Items[Item].fornec do
  begin
    if RazaoSocial <> '' then
    begin
      Result := CreateElement('fornec');

      if Identificacao.CpfCnpj <> '' then
        Result.AppendChild(AddNodeCNPJCPF('#1', '#1', Identificacao.CpfCnpj))
      else
      if Identificacao.Nif <> '' then
        Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                                         Identificacao.Nif, ''))
      else
        Result.AppendChild(AddNode(tcStr, '#1', 'cNaoNIF', 1, 1, 1,
                                       NaoNIFToStr(Identificacao.cNaoNIF), ''));

      Result.AppendChild(AddNode(tcStr, '#1', 'CAEPF', 1, 14, 0,
                                                      Identificacao.CAEPF, ''));

      Result.AppendChild(AddNode(tcStr, '#1', 'IM', 1, 15, 0,
                                         Identificacao.InscricaoMunicipal, ''));

      Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 300, 1,
                                                              RazaoSocial, ''));

      Result.AppendChild(GerarXMLEnderecoFornecedor(Item));
    end;
  end;
end;

function TNFSeW_BethaAPIPropria.GerarXMLgIBSCBS(
  gIBSCBS: TgIBSCBS): TACBrXmlNode;
begin
  Result := CreateElement('gIBSCBS');

  Result.AppendChild(AddNode(tcStr, '#1', TagCST, 3, 3, NrOcorrCST,
                                              CSTIBSCBSToStr(gIBSCBS.CST), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cClassTrib', 6, 6, 1,
                                                       gIBSCBS.cClassTrib, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cCredPres', 2, 2, NrOcorrcCredPres,
                                        cCredPresToStr(gIBSCBS.cCredPres), ''));
end;

function TNFSeW_BethaAPIPropria.GerarXMLIBSCBS(
  IBSCBS: TIBSCBSDPS): TACBrXmlNode;
begin
  Result := CreateElement(TagIBSCBS);

  Result.AppendChild(AddNode(tcStr, '#1', 'finNFSe', 1, 1, NrOcorrfinNFSe,
                                             finNFSeToStr(IBSCBS.finNFSe), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'indFinal', 1, 1, NrOcorrindFinal,
                                           indFinalToStr(IBSCBS.indFinal), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cIndOp', 6, 6, NrOcorrcIndOp,
                                                            IBSCBS.cIndOp, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tpEnteGov', 1, 1, 0,
                                         tpEnteGovToStr(IBSCBS.tpEnteGov), ''));

  {Como sera definido este campo se nao temos descricao no schemas}
  Result.AppendChild(AddNode(tcStr, '#1', 'xTpEnteGov', 1, 1, 0,
                                         '', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'indPessoas', 1, 1, NrOcorrindDest,
                                             indDestToStr(IBSCBS.indDest), ''));

  if (IBSCBS.dest.xNome <> '') and GerarDest then
    Result.AppendChild(GerarXMLDestinatario(IBSCBS.dest));

  Result.AppendChild(GerarXMLIBSCBSTribValores(IBSCBS.valores));
end;

function TNFSeW_BethaAPIPropria.GerarXMLObra: TACBrXmlNode;
begin
  Result := CreateElement('obra');

  Result.AppendChild(AddNode(tcStr, '#1', 'inscImobFisc', 1, 30, 0,
                                        NFSe.ConstrucaoCivil.inscImobFisc, ''));

  if NFSe.ConstrucaoCivil.CodigoObra <> '' then
    Result.AppendChild(AddNode(tcStr, '#1', 'cObra', 1, 30, 1,
                                           NFSe.ConstrucaoCivil.CodigoObra, ''))

  else if NFSe.ConstrucaoCivil.Cib > 0 then
    Result.AppendChild(AddNode(tcStr, '#1', 'cCIB', 1, 8, 1,
                                      Poem_Zeros(NFSe.ConstrucaoCivil.Cib, 8)));

  Result.AppendChild(GerarXMLEnderecoObra);
end;

function TNFSeW_BethaAPIPropria.GerarXMLPrestador: TACBrXmlNode;
begin
  Result := CreateElement('prest');

  if NFSe.Prestador.IdentificacaoPrestador.CpfCnpj <> '' then
    Result.AppendChild(AddNodeCNPJCPF('#1', '#1',
                                 NFSe.Prestador.IdentificacaoPrestador.CpfCnpj))
  else
  begin
    if NFSe.Prestador.IdentificacaoPrestador.Nif <> '' then
      Result.AppendChild(AddNode(tcStr, '#1', 'NIF', 1, 40, 1,
                                 NFSe.Prestador.IdentificacaoPrestador.Nif, ''))
    else
      Result.AppendChild(AddNode(tcStr, '#1', 'cNaoNIF', 1, 1, 1,
               NaoNIFToStr(NFSe.Prestador.IdentificacaoPrestador.cNaoNIF), ''));
  end;

  Result.AppendChild(AddNode(tcStr, '#1', 'CAEPF', 1, 14, 0,
                              NFSe.Prestador.IdentificacaoPrestador.CAEPF, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IM', 1, 15, 0,
                 NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal, ''));

  if NFSe.tpEmit <> tePrestador then
  begin
    Result.AppendChild(AddNode(tcStr, '#1', 'xNome', 1, 300, 0,
                                               NFSe.Prestador.RazaoSocial, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'xFant', 1, 300, 0,
                                              NFSe.Prestador.NomeFantasia, ''));

    Result.AppendChild(GerarXMLEnderecoPrestador);
  end;

  Result.AppendChild(AddNode(tcStr, '#1', 'fone', 6, 20, 0,
                                          NFSe.Prestador.Contato.Telefone, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'email', 1, 80, 0,
                                             NFSe.Prestador.Contato.Email, ''));

  Result.AppendChild(GerarXMLRegimeTributacaoPrestador);
end;

function TNFSeW_BethaAPIPropria.GerarXMLTributacaoMunicipal: TACBrXmlNode;
begin
  // No Betha: dentro de TTributacaoMunicipal, aparece antes de tpRetISSQN.
  Result := CreateElement('tribMun');

  Result.AppendChild(AddNode(tcStr, '#1', 'tribISSQN', 1, 1, 1,
                   tribISSQNToStr(NFSe.Servico.Valores.tribMun.tribISSQN), ''));

  if NFSe.Servico.Valores.tribMun.cPaisResult > 0 then
    Result.AppendChild(AddNode(tcStr, '#1', 'cPaisResult', 2, 2, 0,
         CodIBGEPaisToSiglaISO2(NFSe.Servico.Valores.tribMun.cPaisResult), ''));

  {antes de ExigibilidadeSuspensa}
  Result.AppendChild(GerarXMLBeneficioMunicipal);

  Result.AppendChild(GerarXMLExigibilidadeSuspensa);

  {Apos ExigibilidadeSuspensa}
  if NFSe.Servico.Valores.tribMun.tribISSQN = tiImunidade then
    Result.AppendChild(AddNode(tcStr, '#1', 'tpImunidade', 1, 1, 0,
               tpImunidadeToStr(NFSe.Servico.Valores.tribMun.tpImunidade), ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliq', 1, 3, 0,
                                       NFSe.Servico.Valores.tribMun.pAliq, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tpRetISSQN', 2, 2, 1,
                 tpRetISSQNToStr(NFSe.Servico.Valores.tribMun.tpRetISSQN), ''));
end;

function TNFSeW_BethaAPIPropria.GerarXMLServico: TACBrXmlNode;
begin
  Result := CreateElement('serv');

  Result.AppendChild(GerarXMLLocalPrestacao);
  Result.AppendChild(GerarXMLCodigoServico);
  Result.AppendChild(GerarXMLComercioExterior);

  if VersaoNFSe = ve100 then
    Result.AppendChild(GerarXMLLocacaoSubLocacao);

  if DevoGerarXMLObra then
    Result.AppendChild(GerarXMLObra);

  Result.AppendChild(GerarXMLAtividadeEvento);
  Result.AppendChild(GerarXMLInformacoesComplementares);
end;

function TNFSeW_BethaAPIPropria.DevoGerarXMLObra: Boolean;
begin
  Result := (NFSe.ConstrucaoCivil.CodigoObra <> '') or
            (NFSE.ConstrucaoCivil.Cib > 0) or
            (NFSe.ConstrucaoCivil.Endereco.CEP <> '');
end;

end.
