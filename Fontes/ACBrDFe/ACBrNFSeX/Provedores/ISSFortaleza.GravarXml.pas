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

unit ISSFortaleza.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlDocument,
  ACBrNFSeXClass,
  ACBrNFSeXGravarXml_ABRASFv1;

type
  { TNFSeW_ISSFortaleza }

  TNFSeW_ISSFortaleza = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

    function GerarInfRps: TACBrXmlNode; override;
    function GerarXMLIBSCBS(IBSCBS: TIBSCBSDPS): TACBrXmlNode; override;
    function GerarXMLgRefNFSe(gRefNFSe: TgRefNFSeCollection): TACBrXmlNode;
    function GerarXMLDestinatario(Dest: TDadosdaPessoa): TACBrXmlNode; override;
    function GerarXMLEnderecoDestinatario(ender: Tender): TACBrXmlNode;
    function GerarXMLContatoDestinatario(Dest: TDadosdaPessoa): TACBrXmlNode;
    function GerarXMLImovel(Imovel: TDadosimovel): TACBrXmlNode;
    function GerarXMLEnderecoNacionalImovel(ender: TenderImovel): TACBrXmlNode;
    function GerarXMLIBSCBSTribValores(valores: Tvalorestrib): TACBrXmlNode; override;
    function GerarXMLgReeRepRes(gReeRepRes: TgReeRepRes): TACBrXmlNode;
    function GerarXMLDocumentos: TACBrXmlNodeArray;
    function GerarXMLdFeNacional(dFeNacional: TdFeNacional): TACBrXmlNode;
    function GerarXMLdocFiscalOutro(docFiscalOutro: TdocFiscalOutro): TACBrXmlNode;
    function GerarXMLdocOutro(docOutro: TdocOutro): TACBrXmlNode;
    function GerarXMLfornec(fornec: Tfornec): TACBrXmlNode;

    function GerarXMLTributos(trib: Ttrib): TACBrXmlNode;
    function GerarXMLgIBSCBS(gIBSCBS: TgIBSCBS): TACBrXmlNode; override;
    function GerarXMLgTribRegular(gTribRegular: TgTribRegular): TACBrXmlNode;
    function GerarXMLgDif(gDif: TgDif): TACBrXmlNode;
  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrNFSeXConversao,
  ACBrDFeConsts,
  ACBrNFSeXConsts,
  ACBrUtil.Strings;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     ISSFortaleza
//==============================================================================

{ TNFSeW_ISSFortaleza }

procedure TNFSeW_ISSFortaleza.Configuracao;
begin
  inherited Configuracao;

  DivAliq100 := True;

  NrOcorrAliquota := 1;
  NrOcorrValorPis := 1;
  NrOcorrValorCofins := 1;
  NrOcorrValorInss := 1;
  NrOcorrValorIr := 1;
  NrOcorrValorCsll := 1;
  NrOcorrValorIss := 1;

  PrefixoPadrao := 'ns4';
end;

function TNFSeW_ISSFortaleza.GerarInfRps: TACBrXmlNode;
begin
  Result := inherited GerarInfRps;

  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
    Result.AppendChild(GerarXMLIBSCBS(NFSe.IBSCBS));
end;

function TNFSeW_ISSFortaleza.GerarXMLIBSCBS(IBSCBS: TIBSCBSDPS): TACBrXmlNode;
begin
  Result := CreateElement('IbsCbs');

  Result.AppendChild(AddNode(tcStr, '#1', 'CodigoIndicadorFinalidadeNFSe', 1, 1, 0,
                                             finNFSeToStr(IBSCBS.finNFSe), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CodigoIndicadorOperacaoUsoConsumoPessoal', 1, 1, 0,
                                           indFinalToStr(IBSCBS.indFinal), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CodigoIndicadorOperacao', 6, 6, 0,
                                                            IBSCBS.cIndOp, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'TipoOp', 1, 1, 0,
                                        tpOperGovNFSeToStr(IBSCBS.tpOper), ''));

  if IBSCBS.gRefNFSe.Count > 0 then
    Result.AppendChild(GerarXMLgRefNFSe(IBSCBS.gRefNFSe));

  Result.AppendChild(AddNode(tcStr, '#1', 'TipoEnteGovernamental', 1, 1, 0,
                                         tpEnteGovToStr(IBSCBS.tpEnteGov), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IndDest', 1, 1, NrOcorrindDest,
                                             indDestToStr(IBSCBS.indDest), ''));

  if (IBSCBS.dest.xNome <> '') and GerarDest then
    Result.AppendChild(GerarXMLDestinatario(IBSCBS.dest));

  if ((IBSCBS.imovel.cCIB <> '') or (IBSCBS.imovel.ender.xLgr <> '')) then
    Result.AppendChild(GerarXMLImovel(IBSCBS.imovel));

  Result.AppendChild(GerarXMLIBSCBSTribValores(IBSCBS.valores));
end;

function TNFSeW_ISSFortaleza.GerarXMLgRefNFSe(
  gRefNFSe: TgRefNFSeCollection): TACBrXmlNode;
var
  i: Integer;
begin
  Result := nil;

  if gRefNFSe.Count > 0 then
  begin
    if gRefNFSe.Count > 99 then
      wAlerta('BB02', 'GrupoNFSeReferenciada', DSC_REFNFSE, ERR_MSG_MAIOR_MAXIMO + '99');

    Result := FDocument.CreateElement('GrupoNFSeReferenciada');

    for i := 0 to gRefNFSe.Count - 1 do
    begin
      Result.AppendChild(AddNode(tcStr, '#1','ChaveNFSeReferenciada', 50, 50, 1,
                                             gRefNFSe[i].refNFSe, DSC_REFNFSE));
    end;
  end;
end;

function TNFSeW_ISSFortaleza.GerarXMLDestinatario(
  Dest: TDadosdaPessoa): TACBrXmlNode;
begin
  Result := CreateElement('Destinatario');

  if Dest.CNPJCPF <> '' then
    Result.AppendChild(GerarCPFCNPJ(Dest.CNPJCPF))
  else
  if Dest.Nif <> '' then
    Result.AppendChild(AddNode(tcStr, '#1', 'Nif', 1, 40, 1, Dest.Nif, ''))
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'NaoNif', 1, 1, 1,
                                                NaoNIFToStr(Dest.cNaoNIF), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Nome', 1, 300, 1, Dest.xNome, ''));

  Result.AppendChild(GerarXMLEnderecoDestinatario(Dest.ender));
  Result.AppendChild(GerarXMLContatoDestinatario(Dest));
end;

function TNFSeW_ISSFortaleza.GerarXMLEnderecoDestinatario(
  ender: Tender): TACBrXmlNode;
begin
  Result := nil;

  if (ender.endNac.cMun <> 0) or (ender.endExt.cPais <> 0) then
  begin
    Result := CreateElement('Endereco');

    Result.AppendChild(AddNode(tcStr, '#1', 'Endereco', 1, 255, 1,
                                                               ender.xLgr, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Numero', 1, 60, 1, ender.nro, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Complemento', 1, 156, 0,
                                                               ender.xCpl, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Bairro', 1, 60, 1,
                                                            ender.xBairro, ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'CodigoMunicipio', 7, 7, 1,
                                                        ender.endNac.cMun, ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'Uf', 2, 2, 0,
                                                          ender.endNac.UF, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Cep', 8, 8, 1,
                                                         ender.endNac.CEP, ''));
  end;
end;

function TNFSeW_ISSFortaleza.GerarXMLContatoDestinatario(
  Dest: TDadosdaPessoa): TACBrXmlNode;
begin
  Result := nil;

  if (Dest.fone <> '') or (Dest.Email <> '') then
  begin
    Result := CreateElement('Contato');

    Result.AppendChild(AddNode(tcStr, '#46', 'Telefone', 1, 11, 0,
                                              OnlyNumber(Dest.fone), DSC_FONE));

    Result.AppendChild(AddNode(tcStr, '#47', 'Email', 1, 80, 0,
                                                        Dest.Email, DSC_EMAIL));
  end;
end;

function TNFSeW_ISSFortaleza.GerarXMLImovel(Imovel: TDadosimovel): TACBrXmlNode;
begin
  Result := nil;

  if (Imovel.cCIB <> '') or (Imovel.ender.CEP <> '') or
     (Imovel.ender.endExt.cEndPost <> '') then
  begin
    Result := CreateElement('Imovel');

    Result.AppendChild(AddNode(tcStr, '#1', 'InscImobFisc', 1, 30, 0,
                                                      Imovel.inscImobFisc, ''));

    if (Imovel.cCIB <> '') then
      Result.AppendChild(AddNode(tcStr, '#1', 'CodigoCIB', 1, 8, 1,
                                                               Imovel.cCIB, ''))
    else
      Result.AppendChild(GerarXMLEnderecoNacionalImovel(Imovel.ender));
  end;
end;

function TNFSeW_ISSFortaleza.GerarXMLEnderecoNacionalImovel(
  ender: TenderImovel): TACBrXmlNode;
begin
  Result := nil;

  if (ender.CEP <> '') or (ender.endExt.cEndPost <> '') then
  begin
    Result := CreateElement('Endereco');

    Result.AppendChild(AddNode(tcStr, '#1', 'Endereco', 1, 255, 1,
                                                               ender.xLgr, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Numero', 1, 60, 1, ender.nro, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Complemento', 1, 156, 0,
                                                               ender.xCpl, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Bairro', 1, 60, 1,
                                                            ender.xBairro, ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'CodigoMunicipio', 7, 7, 1,
                                                    ender.CodigoMunicipio, ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'Uf', 2, 2, 0, ender.UF, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Cep', 8, 8, 1, ender.CEP, ''));
  end;
end;

function TNFSeW_ISSFortaleza.GerarXMLIBSCBSTribValores(
  valores: Tvalorestrib): TACBrXmlNode;
begin
  Result := CreateElement('Valores');

  if (valores.gReeRepRes.documentos.Count > 0) then
    Result.AppendChild(GerarXMLgReeRepRes(valores.gReeRepRes));

  Result.AppendChild(GerarXMLTributos(valores.trib));
end;

function TNFSeW_ISSFortaleza.GerarXMLgReeRepRes(
  gReeRepRes: TgReeRepRes): TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := CreateElement('GrupoReeRepRes');

  nodeArray := GerarXMLDocumentos;

  if nodeArray <> nil then
  begin
    for i := 0 to Length(nodeArray) - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

function TNFSeW_ISSFortaleza.GerarXMLDocumentos: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.IBSCBS.valores.gReeRepRes.documentos.Count);

  for i := 0 to NFSe.IBSCBS.valores.gReeRepRes.documentos.Count - 1 do
  begin
    Result[i] := CreateElement('Documentos');

    if NFSe.IBSCBS.valores.gReeRepRes.documentos[i].dFeNacional.chaveDFe <> '' then
      Result[i].AppendChild(GerarXMLdFeNacional(NFSe.IBSCBS.valores.gReeRepRes.documentos[i].dFeNacional))
    else
    if NFSe.IBSCBS.valores.gReeRepRes.documentos[i].docFiscalOutro.cMunDocFiscal > 0 then
      Result[i].AppendChild(GerarXMLdocFiscalOutro(NFSe.IBSCBS.valores.gReeRepRes.documentos[i].docFiscalOutro))
    else
    if NFSe.IBSCBS.valores.gReeRepRes.documentos[i].docOutro.nDoc <> '' then
      Result[i].AppendChild(GerarXMLdocOutro(NFSe.IBSCBS.valores.gReeRepRes.documentos[i].docOutro));

    if NFSe.IBSCBS.valores.gReeRepRes.documentos[i].fornec.xNome <> '' then
      Result[i].AppendChild(GerarXMLfornec(NFSe.IBSCBS.valores.gReeRepRes.documentos[i].fornec));

    Result[i].AppendChild(AddNode(tcDat, '#1', 'DataEmissaoDocumento', 10, 10, 1,
                    NFSe.IBSCBS.valores.gReeRepRes.documentos[i].dtEmiDoc, ''));

    Result[i].AppendChild(AddNode(tcDat, '#1', 'DataCompetenciaDocumento', 10, 10, 1,
                   NFSe.IBSCBS.valores.gReeRepRes.documentos[i].dtCompDoc, ''));

    Result[i].AppendChild(AddNode(tcStr, '#1', 'TipoReeRepRes', 2, 2, 1,
      tpReeRepResToStr(NFSe.IBSCBS.valores.gReeRepRes.documentos[i].tpReeRepRes), ''));

    Result[i].AppendChild(AddNode(tcStr, '#1', 'DescTipoReeRepRes', 0, 150, 0,
                NFSe.IBSCBS.valores.gReeRepRes.documentos[i].xTpReeRepRes, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#1', 'ValorReeRepRes', 1, 15, 1,
                NFSe.IBSCBS.valores.gReeRepRes.documentos[i].vlrReeRepRes, ''));
  end;

  if NFSe.Servico.Valores.DocDeducao.Count > 1000 then
    wAlerta('#1', 'Documentos', '', ERR_MSG_MAIOR_MAXIMO + '1000');
end;

function TNFSeW_ISSFortaleza.GerarXMLdFeNacional(
  dFeNacional: TdFeNacional): TACBrXmlNode;
begin
  Result := CreateElement('DocumentosFiscaisEletronicos');

  Result.AppendChild(AddNode(tcStr, '#1', 'TipoChaveDFe', 1, 1, 1,
                              tipoChaveDFeToStr(dFeNacional.tipoChaveDFe), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'DescTipoChaveDFe', 1, 255, 0,
                                                dFeNacional.xTipoChaveDFe, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'ChaveDFe', 1, 50, 1,
                                                     dFeNacional.chaveDFe, ''));
end;

function TNFSeW_ISSFortaleza.GerarXMLdocFiscalOutro(
  docFiscalOutro: TdocFiscalOutro): TACBrXmlNode;
begin
  Result := CreateElement('DocumentosFiscaisOutro');

  Result.AppendChild(AddNode(tcInt, '#1', 'CodigoMunicipioDocFiscal', 7, 7, 1,
                                             docFiscalOutro.cMunDocFiscal, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'NumeroDocumentoFiscal', 1, 255, 1,
                                                docFiscalOutro.nDocFiscal, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'DescTipoChaveDFe', 1, 255, 1,
                                                docFiscalOutro.xDocFiscal, ''));
end;

function TNFSeW_ISSFortaleza.GerarXMLdocOutro(docOutro: TdocOutro): TACBrXmlNode;
begin
  Result := CreateElement('DocumentosOutro');

  Result.AppendChild(AddNode(tcStr, '#1', 'NumeroDocumentoOutro', 1, 255, 1,
                                                            docOutro.nDoc, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'DescDocumentoOutro', 1, 255, 1,
                                                            docOutro.xDoc, ''));
end;

function TNFSeW_ISSFortaleza.GerarXMLfornec(fornec: Tfornec): TACBrXmlNode;
begin
  Result := CreateElement('Fornecedor');

  if fornec.CNPJCPF <> '' then
    Result.AppendChild(GerarCPFCNPJ(fornec.CNPJCPF))
  else
  if fornec.Nif <> '' then
    Result.AppendChild(AddNode(tcStr, '#1', 'Nif', 1, 40, 1,
                                                     fornec.Nif, ''))
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'NaoNif', 1, 1, 1,
                                   NaoNIFToStr(fornec.cNaoNIF), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Nome', 1, 150, 1,
                                                             fornec.xNome, ''));
end;

function TNFSeW_ISSFortaleza.GerarXMLTributos(
  trib: Ttrib): TACBrXmlNode;
begin
  Result := CreateElement('TributosIbsCbs');

  Result.AppendChild(GerarXMLgIBSCBS(trib.gIBSCBS));
end;

function TNFSeW_ISSFortaleza.GerarXMLgIBSCBS(
  gIBSCBS: TgIBSCBS): TACBrXmlNode;
begin
  Result := CreateElement('GrupoIbsCbs');

  Result.AppendChild(AddNode(tcStr, '#1', 'CST', 3, 3, 0,
                                              CSTIBSCBSToStr(gIBSCBS.CST), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CodigoClassTrib', 6, 6, 1,
                                                       gIBSCBS.cClassTrib, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CodigoCreditoPresumido', 2, 2, NrOcorrcCredPres,
                                        cCredPresToStr(gIBSCBS.cCredPres), ''));

  if (gIBSCBS.gTribRegular.CSTReg <> cstNenhum) and GerarTribRegular then
    Result.AppendChild(GerarXMLgTribRegular(gIBSCBS.gTribRegular));

  if ((gIBSCBS.gDif.pDifUF > 0) or (gIBSCBS.gDif.pDifMun > 0) or
     (gIBSCBS.gDif.pDifCBS > 0)) and GerargDif then
    Result.AppendChild(GerarXMLgDif(gIBSCBS.gDif));
end;

function TNFSeW_ISSFortaleza.GerarXMLgTribRegular(
  gTribRegular: TgTribRegular): TACBrXmlNode;
begin
  Result := CreateElement('GrupoInfoTributacaoRegular');

  Result.AppendChild(AddNode(tcStr, '#1', 'CodigoSitTribReg', 3, 3, 0,
                                      CSTIBSCBSToStr(gTribRegular.CSTReg), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CodigoClassTribReg', 6, 6, 1,
                                               gTribRegular.cClassTribReg, ''));
end;

function TNFSeW_ISSFortaleza.GerarXMLgDif(gDif: TgDif): TACBrXmlNode;
begin
  Result := CreateElement('GrupoDiferimento');

  Result.AppendChild(AddNode(tcDe2, '#1', 'PercentualDiferimentoIbsUf', 1, 15, 1,
                                                              gDif.pDifUF, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'PercentualDiferimentoIbsMun', 1, 15, 1,
                                                             gDif.pDifMun, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'PercentualDiferimentoCbs', 1, 15, 1,
                                                             gDif.pDifCBS, ''));
end;

end.
