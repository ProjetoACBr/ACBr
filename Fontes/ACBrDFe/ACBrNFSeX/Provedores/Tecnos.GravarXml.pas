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

unit Tecnos.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils, IniFiles,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXClass,
  ACBrNFSeXGravarXml_ABRASFv2;

type
  { TNFSeW_Tecnos201 }

  TNFSeW_Tecnos201 = class(TNFSeW_ABRASFv2)
  protected
    function GerarEnderecoTomador: TACBrXmlNode; override;

    function DefinirNameSpaceDeclaracao: string; override;

    function GerarInfDeclaracaoPrestacaoServico: TACBrXmlNode; override;
    function GerarInfDeclaracaoPrestacaoServ: TACBrXmlNode;
    function GerarValores: TACBrXmlNode; override;
    function GerarConstrucaoCivil: TACBrXmlNode; override;

    procedure Configuracao; override;
    procedure DefinirIDDeclaracao; override;

    //======Arquivo INI===========================================
    procedure GerarINISecaoConstrucaoCivil(const AINIRec: TMemIniFile); override;
    procedure GerarINISecaoServico(const AINIRec: TMemIniFile); override;
    procedure GerarINIIBSCBS(AINIRec: TMemIniFile; IBSCBS: TIBSCBSDPS); override;
    procedure GerarINIIBSCBSValores(AINIRec: TMemIniFile; Valores: Tvalorestrib); override;
  public
    function GerarIni: String; override;
  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrUtil.Strings,
  ACBrNFSeXConversao,
  ACBrNFSeXConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Tecnos
//==============================================================================

{ TNFSeW_Tecnos201 }

procedure TNFSeW_Tecnos201.Configuracao;
begin
  inherited Configuracao;

  FormatoEmissao := tcDatHor;
  FormatoCompetencia := tcDatHor;
  FormatoItemListaServico := filsComFormatacaoSemZeroEsquerda;

  FormatoAliq := tcDe2;

  NrOcorrValorPis := 1;
  NrOcorrValorCofins := 1;
  NrOcorrValorInss := 1;
  NrOcorrValorIr := 1;
  NrOcorrValorCsll := 1;
  NrOcorrValorIss := 1;
  NrOcorrAliquota := 1;
  NrOcorrTipoNota := 1;
  NrOcorrSiglaUF := 1;
  NrOcorrIdCidade := 1;
  NrOcorrEspDoc := 1;
  NrOcorrSerieTal := 1;
  NrOcorrFormaPag := 1;

  NrOcorrCodigoPaisServico := 1;
  NrOcorrCodigoPaisTomador := 1;
  NrOcorrDescIncond := 1;
  NrOcorrDescCond := 1;
  NrOcorrComplTomador := 1;

  NrOcorrNaturezaOperacao := 1;
  NrOcorrBaseCalcCRS := 1;
  NrOcorrIrrfInd := 1;
  NrOcorrValorDeducoes := 1;
  NrOcorrOutrasRet := 1;
  NrOcorrRespRetencao := 1;
  NrOcorrNumParcelas := 1;
  NrOcorrRazaoSocialPrest := 1;
  NrOcorrPercCargaTrib := 1;
  NrOcorrValorCargaTrib := 1;
  NrOcorrPercCargaTribMun := 1;
  NrOcorrValorCargaTribMun := 1;
  NrOcorrPercCargaTribEst := 1;
  NrOcorrValorCargaTribEst := 1;
  NrOcorrOutrasInformacoes := 1;

  NrOcorrRegimeEspecialTributacao := 1;
  NrOcorrRazaoSocialInterm := 1;
  NrOcorrInscEstInter := 1;

  NrOcorrInscMunTomador := 1;
  NrOcorrInscEstTomador_1 := 0;

  NrOcorrRespRetencao := 1;
  
  GerarTagServicos := False;
end;

function TNFSeW_Tecnos201.GerarConstrucaoCivil: TACBrXmlNode;
begin
  if (Trim(NFSe.ConstrucaoCivil.LocalConstrucao) <> EmptyStr) or
     (Trim(NFSe.ConstrucaoCivil.CodigoObra) <> EmptyStr) or
     (Trim(NFSe.ConstrucaoCivil.Art) <> EmptyStr) then
  begin
    Result := CreateElement('ConstrucaoCivil');

    Result.AppendChild(AddNode(tcStr, '#54', 'LocalConstrucao', 1,  50, 1,
                                            NFSe.ConstrucaoCivil.LocalConstrucao, DSC_LOCAL_CONSTRUCAO));

    Result.AppendChild(AddNode(tcStr, '#51', 'CodigoObra', 1, 15, 1,
                                   NFSe.ConstrucaoCivil.CodigoObra, DSC_COBRA));

    Result.AppendChild(AddNode(tcStr, '#52', 'Art', 1, 15, 1,
                                            NFSe.ConstrucaoCivil.Art, DSC_ART));

    Result.AppendChild(AddNode(tcInt, '#53', 'ReformaCivil', 1, 15, 1,
                                            FpAOwner.SimNaoToStr(NFSe.ConstrucaoCivil.ReformaCivil), DSC_ART));

    Result.AppendChild(AddNode(tcInt, '#55', 'Cib', 1, 50, 1,
                                            NFSe.ConstrucaoCivil.Cib, DSC_CIB));

    Result.AppendChild(AddNode(tcStr, '#56', 'EstadoObra', 1, 2, 1,
                                            NFSe.ConstrucaoCivil.Endereco.UF, DSC_UFOBRA));

    Result.AppendChild(AddNode(tcStr, '#56', 'CidadeObra', 1, 2, 1,
                                            NFSe.ConstrucaoCivil.Endereco.CodigoMunicipio, DSC_CODMUNOBRA));

    Result.AppendChild(AddNode(tcStr, '#56', 'EnderecoObra', 1, 2, 1,
                                            NFSe.ConstrucaoCivil.Endereco.Endereco, DSC_EOBRA));

    Result.AppendChild(AddNode(tcInt, '#56', 'NumeroObra', 1, 2, 1,
                                            NFSe.ConstrucaoCivil.Endereco.Numero, DSC_NEOBRA));

    Result.AppendChild(AddNode(tcStr, '#56', 'BairroObra', 1, 2, 1,
                                            NFSe.ConstrucaoCivil.Endereco.Bairro, DSC_BEOBRA));

    Result.AppendChild(AddNode(tcInt, '#56', 'CepObra', 1, 2, 1,
                                            NFSe.ConstrucaoCivil.Endereco.CEP, DSC_CEPOBRA));

    Result.AppendChild(AddNode(tcStr, '#56', 'ComplementoObra', 1, 2, 1,
                                            NFSe.ConstrucaoCivil.Endereco.Complemento, DSC_CEOBRA));
  end;
end;

function TNFSeW_Tecnos201.GerarEnderecoTomador: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.Tomador.Endereco.Endereco <> '') or (NFSe.Tomador.Endereco.Numero <> '') or
     (NFSe.Tomador.Endereco.Bairro <> '') or (NFSe.Tomador.Endereco.CodigoMunicipio <> '') or
     (NFSe.Tomador.Endereco.UF <> '') or (NFSe.Tomador.Endereco.CEP <> '') then
  begin
    Result := CreateElement('Endereco');

    Result.AppendChild(AddNode(tcStr, '#39', 'Endereco', 1, 125, NrOcorrEndereco,
                                     NFSe.Tomador.Endereco.Endereco, DSC_XLGR));

    Result.AppendChild(AddNode(tcStr, '#39', 'TipoLogradouro', 1, 50, NrOcorrTipoLogradouro,
                               NFSe.Tomador.Endereco.TipoLogradouro, DSC_XLGR));

    Result.AppendChild(AddNode(tcStr, '#39', 'Logradouro', 1, 125, NrOcorrLogradouro,
                                     NFSe.Tomador.Endereco.Endereco, DSC_XLGR));

    Result.AppendChild(AddNode(tcStr, '#40', 'Numero', 1, 10, 0,
                                        NFSe.Tomador.Endereco.Numero, DSC_NRO));

    Result.AppendChild(AddNode(tcStr, '#41', 'Complemento', 1, 60, NrOcorrComplTomador,
                                  NFSe.Tomador.Endereco.Complemento, DSC_XCPL));

    Result.AppendChild(AddNode(tcStr, '#42', 'Bairro', 1, 60, 0,
                                    NFSe.Tomador.Endereco.Bairro, DSC_XBAIRRO));

    Result.AppendChild(AddNode(tcStr, '#43', 'CodigoMunicipio', 7, 7, 0,
                  OnlyNumber(NFSe.Tomador.Endereco.CodigoMunicipio), DSC_CMUN));

    Result.AppendChild(AddNode(tcStr, '#44', 'Uf', 2, 2, NrOcorrUFTomador,
                                             NFSe.Tomador.Endereco.UF, DSC_UF));

    Result.AppendChild(AddNode(tcInt, '#44', 'CodigoPais', 4, 4, NrOcorrCodigoPaisTomador,
                                  NFSe.Tomador.Endereco.CodigoPais, DSC_CPAIS));

    Result.AppendChild(AddNode(tcStr, '#45', 'Cep', 8, 8, NrOcorrCepTomador,
                               OnlyNumber(NFSe.Tomador.Endereco.CEP), DSC_CEP));
  end;
end;

procedure TNFSeW_Tecnos201.DefinirIDDeclaracao;
begin
  NFSe.InfID.ID := '1' + // Tipo de operação, no caso envio
                   OnlyNumber(NFSe.Prestador.IdentificacaoPrestador.CpfCnpj) +
                   Poem_Zeros(OnlyNumber(NFSe.IdentificacaoRps.Numero), 16);
end;

function TNFSeW_Tecnos201.DefinirNameSpaceDeclaracao: string;
begin
  Result := 'http://www.abrasf.org.br/nfse.xsd';
end;

function TNFSeW_Tecnos201.GerarInfDeclaracaoPrestacaoServ: TACBrXmlNode;
var
  aNameSpace: string;
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  aNameSpace := DefinirNameSpaceDeclaracao;

  Result := CreateElement('InfDeclaracaoPrestacaoServico');

  if aNameSpace <> '' then
    Result.SetNamespace(aNameSpace);

  DefinirIDDeclaracao;

  if (FpAOwner.ConfigGeral.Identificador <> '') and GerarIDDeclaracao then
    Result.SetAttribute(FpAOwner.ConfigGeral.Identificador, NFSe.infID.ID);

  Result.AppendChild(AddNode(tcStr, '#4', 'Id', 1, 15, NrOcorrID,
                                                            NFSe.infID.ID, ''));

  if (NFSe.IdentificacaoRps.Numero <> '') and GerarTagRps then
    Result.AppendChild(GerarRps);

  Result.AppendChild(GerarListaServicos);

  Result.AppendChild(AddNode(FormatoCompetencia, '#4', 'Competencia', 10, 10, NrOcorrCompetencia,
                                                  NFSe.Competencia, DSC_DHEMI));

  Result.AppendChild(GerarServico);

  nodeArray := GerarServicos;
  if nodeArray <> nil then
  begin
    for i := 0 to Length(nodeArray) - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;

  Result.AppendChild(GerarPrestador);
  Result.AppendChild(GerarTomador);

  Result.AppendChild(AddNode(tcDatHor, '#9', 'DataFatoGerador', 10, 10, 0,
                                                     NFSe.DataFatoGerador, ''));

  Result.AppendChild(GerarIntermediarioServico);
  Result.AppendChild(GerarConstrucaoCivil);

  Result.AppendChild(AddNode(tcStr, '#6', 'RegimeEspecialTributacao', 1, 2, NrOcorrRegimeEspecialTributacao,
   FpAOwner.RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao), DSC_REGISSQN));

  Result.AppendChild(AddNode(tcStr, '#7', 'NaturezaOperacao', 1, 3, NrOcorrNaturezaOperacao,
                   NaturezaOperacaoToStr(NFSe.NaturezaOperacao), DSC_INDNATOP));

  Result.AppendChild(AddNode(tcStr, '#7', 'OptanteSimplesNacional', 1, 1, NrOcorrOptanteSimplesNacional,
               FpAOwner.SimNaoToStr(NFSe.OptanteSimplesNacional), DSC_INDOPSN));

  Result.AppendChild(AddNode(tcStr, '#8', 'IncentivoFiscal', 1, 1, NrOcorrIncentCultural,
              FpAOwner.SimNaoToStr(NFSe.IncentivadorCultural), DSC_INDINCCULT));

  Result.AppendChild(AddNode(tcStr, '#9', 'PercentualCargaTributaria', 1, 5, NrOcorrPercCargaTrib,
                                           NFSe.PercentualCargaTributaria, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'ValorCargaTributaria', 1, 15, NrOcorrValorCargaTrib,
                                                NFSe.ValorCargaTributaria, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'PercentualCargaTributariaMunicipal', 1, 5, NrOcorrPercCargaTribMun,
                                  NFSe.PercentualCargaTributariaMunicipal, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'ValorCargaTributariaMunicipal', 1, 15, NrOcorrValorCargaTribMun,
                                       NFSe.ValorCargaTributariaMunicipal, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'PercentualCargaTributariaEstadual', 1, 5, NrOcorrPercCargaTribEst,
                                   NFSe.PercentualCargaTributariaEstadual, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'ValorCargaTributariaEstadual', 1, 15, NrOcorrValorCargaTribEst,
                                        NFSe.ValorCargaTributariaEstadual, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'OutrasInformacoes', 0, 255, NrOcorrOutrasInformacoes,
    StringReplace(NFSe.OutrasInformacoes, Opcoes.QuebraLinha,
           FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), DSC_OUTRASINF));

  Result.AppendChild(AddNode(tcInt, '#9', 'TipoNota', 1, 3, NrOcorrTipoNota,
                                                            NFSe.TipoNota, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'SiglaUF', 2, 2, NrOcorrSiglaUF,
                                                             NFSe.SiglaUF, ''));

  if NFSe.Prestador.Endereco.CodigoMunicipio <> '' then
    Result.AppendChild(AddNode(tcStr, '#9', 'IdCidade', 7, 7, NrOcorrIdCidade,
                             NFSe.Prestador.Endereco.CodigoMunicipio, DSC_CMUN))
  else
    Result.AppendChild(AddNode(tcStr, '#9', 'IdCidade', 7, 7, NrOcorrIdCidade,
                                       NFSe.Servico.CodigoMunicipio, DSC_CMUN));

  Result.AppendChild(AddNode(tcInt, '#9', 'EspecieDocumento', 1, 3, NrOcorrEspDoc,
                                                    NFSe.EspecieDocumento, ''));

  Result.AppendChild(AddNode(tcInt, '#9', 'SerieTalonario', 1, 3, NrOcorrSerieTal,
                                                      NFSe.SerieTalonario, ''));

  Result.AppendChild(AddNode(tcInt, '#9', 'FormaPagamento', 1, 3, NrOcorrFormaPag,
                                                      NFSe.FormaPagamento, ''));

  Result.AppendChild(AddNode(tcInt, '#9', 'NumeroParcelas', 1, 3, NrOcorrNumParcelas,
                                                      NFSe.NumeroParcelas, ''));
end;

function TNFSeW_Tecnos201.GerarInfDeclaracaoPrestacaoServico: TACBrXmlNode;
begin
  Result := CreateElement('tcDeclaracaoPrestacaoServico');

  Result.AppendChild(GerarInfDeclaracaoPrestacaoServ);
end;

function TNFSeW_Tecnos201.GerarIni: String;
var
  LINIRec: TMemIniFile;
  LIniNFSe: TStringList;
begin
  Result := '';
  LINIRec := TMemIniFile.Create('');
  try
    GerarINISecaoIdentificacaoNFSe(LINIRec);
    GerarINISecaoIdentificacaoRps(LINIRec);
    GerarINISecaoRpsSubstituido(LINIRec);
    GerarINISecaoNFSeCancelamento(LINIRec);
    GerarINISecaoPrestador(LINIRec);
    GerarINISecaoTomador(LINIRec);
    GerarINISecaoIntermediario(LINIRec);
    GerarINISecaoConstrucaoCivil(LINIRec);
    GerarINISecaoServico(LINIRec);
    GerarINISecaoItens(LINIRec);
    GerarINISecaoEvento(LINIRec);
    GerarINISecaoInformacoesComplementares(LINIRec);
    GerarINISecaoValores(LINIRec);
    GerarINISecaoDocumentosDeducoes(LINIRec);
    GerarINISecaoCondicaoPagamento(LINIRec);
    GerarINISecaoOrgaoGerador(LINIRec);
    GerarINISecaoParcelas(LINIRec);
    GerarINIIBSCBS(LINIRec, NFSE.IBSCBS);
  finally
    LIniNFSe := TStringList.Create;
    try
      LINIRec.GetStrings(LIniNFSe);
      LINIRec.Free;

      Result := StringReplace(LIniNFSe.Text, sLineBreak + sLineBreak, sLineBreak, [rfReplaceAll]);
    finally
      LIniNFSe.Free;
    end;
  end;
end;

procedure TNFSeW_Tecnos201.GerarINIIBSCBS(AINIRec: TMemIniFile; IBSCBS: TIBSCBSDPS);
begin
  GerarINIIBSCBSValores(AINIRec, IBSCBS.valores);
end;

procedure TNFSeW_Tecnos201.GerarINIIBSCBSValores(AINIRec: TMemIniFile; Valores: Tvalorestrib);
var
  lSecao: String;
begin
  if (NFSe.IBSCBS.valores.IbsMunicipal > 0) or (NFSe.IBSCBS.valores.ValorIbsMunicipal > 0) or
     (NFSe.IBSCBS.valores.IbsEstadual > 0) or (NFSe.IBSCBS.valores.ValorIbsEstadual > 0) or
     (NFSe.IBSCBS.valores.Cbs > 0) or (NFSe.IBSCBS.valores.ValorCbs > 0) then
  begin
    lSecao := 'IBSCBSValores';
    AINIRec.WriteFloat(lSecao, 'IbsMunicipal', NFSe.IBSCBS.valores.IbsMunicipal);
    AINIRec.WriteFloat(lSecao, 'ValorIbsMunicipal', NFSe.IBSCBS.valores.ValorIbsMunicipal);
    AINIRec.WriteFloat(lSecao, 'IbsEstadual', NFSe.IBSCBS.valores.IbsEstadual);
    AINIRec.WriteFloat(lSecao, 'ValorIbsEstadual', NFSe.IBSCBS.valores.ValorIbsEstadual);
    AINIRec.WriteFloat(lSecao, 'Cbs', NFSe.IBSCBS.valores.Cbs);
    AINIRec.WriteFloat(lSecao, 'ValorCbs', NFSe.IBSCBS.valores.ValorCbs);
  end;
end;

procedure TNFSeW_Tecnos201.GerarINISecaoConstrucaoCivil(const AINIRec: TMemIniFile);
var
  lSecao: String;
begin
  if (Trim(NFSe.ConstrucaoCivil.CodigoObra) <> EmptyStr) or
     (Trim(NFSe.ConstrucaoCivil.Art) <> EmptyStr) or
     (Trim(NFSe.ConstrucaoCivil.LocalConstrucao) <> EmptyStr) then
  begin
    lSecao:= 'ConstrucaoCivil';
    AINIRec.WriteString(lSecao, 'LocalConstrucao', NFSe.ConstrucaoCivil.LocalConstrucao);
    AINIRec.WriteString(lSecao, 'CodigoObra', NFSe.ConstrucaoCivil.CodigoObra);
    AINIRec.WriteString(lSecao, 'Art', NFSe.ConstrucaoCivil.Art);
    AINIRec.WriteString(lSecao, 'ReformaCivil', FpAOwner.SimNaoToStr(NFSe.ConstrucaoCivil.ReformaCivil));
    AINIRec.WriteInteger(lSecao, 'Cib', NFSe.ConstrucaoCivil.Cib);
    AINIRec.WriteString(lSecao, 'UF', NFSe.ConstrucaoCivil.Endereco.UF);
    AINIRec.WriteString(lSecao, 'CodigoMunicipio', NFSe.ConstrucaoCivil.Endereco.CodigoMunicipio);
    AINIRec.WriteString(lSecao, 'Logradouro', NFSe.ConstrucaoCivil.Endereco.Endereco);
    AINIRec.WriteString(lSecao, 'Numero', NFSe.ConstrucaoCivil.Endereco.Numero);
    AINIRec.WriteString(lSecao, 'Bairro', NFSe.ConstrucaoCivil.Endereco.Bairro);
    AINIRec.WriteString(lSecao, 'CEP', NFSe.ConstrucaoCivil.Endereco.CEP);
    AINIRec.WriteString(lSecao, 'Complemento', NFSe.ConstrucaoCivil.Endereco.Complemento);
  end;
end;

procedure TNFSeW_Tecnos201.GerarINISecaoServico(const AINIRec: TMemIniFile);
var
  lSecao: String;
begin
  lSecao := 'Servico';
  AINIRec.WriteString(lSecao, 'ResponsavelRetencao', FpAOwner.ResponsavelRetencaoToStr(NFSe.Servico.ResponsavelRetencao));
  AINIRec.WriteString(lSecao, 'ItemListaServico', NFSe.Servico.ItemListaServico);
  AINIRec.WriteString(lSecao, 'xItemListaServico', NFSe.Servico.xItemListaServico);
  AINIRec.WriteString(lSecao, 'CodigoCnae', NFSe.Servico.CodigoCnae);
  AINIRec.WriteString(lSecao, 'CodigoTributacaoMunicipio', NFSe.Servico.CodigoTributacaoMunicipio);
  AINIRec.WriteString(lSecao, 'xCodigoTributacaoMunicipio', NFSe.Servico.xCodigoTributacaoMunicipio);
  AINIRec.WriteString(lSecao, 'Discriminacao', NFSe.Servico.Discriminacao);
  AINIRec.WriteString(lSecao, 'CodigoMunicipio', NFSe.Servico.CodigoMunicipio);
  AINIRec.WriteInteger(lSecao, 'CodigoPais', NFSe.Servico.CodigoPais);
  AINIRec.WriteString(lSecao, 'ExigibilidadeISS', FpAOwner.ExigibilidadeISSToStr(NFSe.Servico.ExigibilidadeISS));
  AINIRec.WriteInteger(lSecao, 'MunicipioIncidencia', NFSe.Servico.MunicipioIncidencia);
  AINIRec.WriteString(lSecao, 'xMunicipioIncidencia', NFSe.Servico.xMunicipioIncidencia);
  AINIRec.WriteString(lSecao, 'NumeroProcesso', NFSe.Servico.NumeroProcesso);
  AINIRec.WriteString(lSecao, 'xPed', NFSe.Servico.xPed);
  AINIRec.WriteString(lSecao, 'nItemPed', NFSE.Servico.nItemPed);
  AINIRec.WriteString(lSecao, 'CodigoNBS', NFSe.Servico.CodigoNBS);
  AINIRec.WriteString(lSecao, 'CodigoServicoNacional', NFSe.Servico.CodigoServicoNacional);
end;

function TNFSeW_Tecnos201.GerarValores: TACBrXmlNode;
var
  item: string;
  Valores: TACBrXmlNode;
begin
  Result := CreateElement('tcDadosServico');

  Valores := inherited GerarValores;

  Valores.AppendChild(AddNode(tcDe2, '#29', 'IbsMunicipal', 1, 5, 0,
                                         NFSe.IBSCBS.valores.IbsMunicipal, ''));

  Valores.AppendChild(AddNode(tcDe2, '#29', 'ValorIbsMunicipal', 1, 15, 0,
                                    NFSe.IBSCBS.valores.ValorIbsMunicipal, ''));

  Valores.AppendChild(AddNode(tcDe2, '#29', 'IbsEstadual', 1, 5, 0,
                                          NFSe.IBSCBS.valores.IbsEstadual, ''));

  Valores.AppendChild(AddNode(tcDe2, '#29', 'ValorIbsEstadual', 1, 15, 0,
                                     NFSe.IBSCBS.valores.ValorIbsEstadual, ''));

  Valores.AppendChild(AddNode(tcDe2, '#29', 'Cbs', 1, 5, 0,
                                                  NFSe.IBSCBS.valores.Cbs, ''));

  Valores.AppendChild(AddNode(tcDe2, '#29', 'ValorCbs', 1, 15, 0,
                                             NFSe.IBSCBS.valores.ValorCbs, ''));

  Result.AppendChild(Valores);

  Result.AppendChild(AddNode(tcStr, '#20', 'IssRetido', 1, 01, 1,
    FpAOwner.SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), DSC_INDISSRET));

  Result.AppendChild(AddNode(tcStr, '#21', 'ResponsavelRetencao', 1, 1, NrOcorrRespRetencao,
   FpAOwner.ResponsavelRetencaoToStr(NFSe.Servico.ResponsavelRetencao), DSC_INDRESPRET));

  item := FormatarItemServico(NFSe.Servico.ItemListaServico, FormatoItemListaServico);

  Result.AppendChild(AddNode(tcStr, '#29', 'ItemListaServico', 1, 5, 1,
                                                          item, DSC_CLISTSERV));

  Result.AppendChild(AddNode(tcStr, '#30', 'CodigoCnae', 1, 7, 1,
                                OnlyNumber(NFSe.Servico.CodigoCnae), DSC_CNAE));

  Result.AppendChild(AddNode(tcStr, '#31', 'CodigoTributacaoMunicipio', 1, 20, 0,
                     NFSe.Servico.CodigoTributacaoMunicipio, DSC_CSERVTRIBMUN));

  Result.AppendChild(AddNode(tcStr, '#32', 'Discriminacao', 1, 2000, 1,
    StringReplace(NFSe.Servico.Discriminacao, Opcoes.QuebraLinha,
               FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), DSC_DISCR));

  Result.AppendChild(AddNode(tcStr, '#33', 'CodigoMunicipio', 1, 7, 1,
                           OnlyNumber(NFSe.Servico.CodigoMunicipio), DSC_CMUN));

  Result.AppendChild(AddNode(tcInt, '#34', 'CodigoPais', 4, 4, NrOcorrCodigoPaisServico,
                                           NFSe.Servico.CodigoPais, DSC_CPAIS));

  Result.AppendChild(AddNode(tcStr, '#35', 'ExigibilidadeISS', 1, 01, 1,
    FpAOwner.ExigibilidadeISSToStr(NFSe.Servico.ExigibilidadeISS), DSC_INDISS));

  Result.AppendChild(AddNode(tcInt, '#36', 'MunicipioIncidencia', 7, 07, NrOcorrMunIncid,
                                NFSe.Servico.MunicipioIncidencia, DSC_MUNINCI));

  Result.AppendChild(AddNode(tcStr, '#37', 'NumeroProcesso', 1, 30, 1,
                                   NFSe.Servico.NumeroProcesso, DSC_NPROCESSO));

  Result.AppendChild(AddNode(tcStr, '#38', 'xPed', 1, 999, 0,
                                                   NFSe.Servico.xPed, ''));

  Result.AppendChild(AddNode(tcStr, '#39', 'nItemPed', 1, 999, 0,
                                                   NFSe.Servico.nItemPed, ''));

  Result.AppendChild(AddNode(tcStr, '#40', 'CodigoNBS', 1, 30, 0,
                                                   NFSe.Servico.CodigoNBS, ''));

  Result.AppendChild(AddNode(tcStr, '#41', 'CodigoServicoNacional', 1, 30, 0,
                                       NFSe.Servico.CodigoServicoNacional, ''));
end;

end.
