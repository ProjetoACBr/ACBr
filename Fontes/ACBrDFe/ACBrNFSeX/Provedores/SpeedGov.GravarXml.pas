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
  SysUtils, Classes, StrUtils, IniFiles,
  ACBrNFSeXClass,
  ACBrXmlDocument,
  ACBrDFe.Conversao,
  ACBrNFSeXGravarXml_ABRASFv1;

type
  { TNFSeW_SpeedGov }

  TNFSeW_SpeedGov = class(TNFSeW_ABRASFv1)
  private
    function DeveGerarDadosDPS: Boolean;
    function DeveGerarDestinatario: Boolean;
    function DeveGerarControleIBSCBS: Boolean;
    function DeveGerarIBSCBS: Boolean;
  protected
    procedure Configuracao; override;
    function GerarXml: Boolean; override;
    function GerarInfRps: TACBrXmlNode; override;
    function GerarTomador: TACBrXmlNode; override;
    function GerarValores: TACBrXmlNode; override;
    function GerarServico: TACBrXmlNode; override;
    function GerarDadosDPS: TACBrXmlNode;
    function GerarDestinatario: TACBrXmlNode;
    function GerarControleIBSCBS: TACBRXmlNode;
    function GerarIBSCBS: TACBrXmlNode;

    //======Arquivo INI===========================================
    procedure GerarINISecaoIdentificacaoNFSe(const AINIRec: TMemIniFile); override;
    procedure GerarINIIBSCBSValores(AINIRec: TMemIniFile; Valores: Tvalorestrib); override;
  public
    function GerarIni: string; override;
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

//  PrefixoPadrao := 'p1';
end;

function TNFSeW_SpeedGov.DeveGerarControleIBSCBS: Boolean;
begin
  Result := Trim(NFSe.IBSCBS.cIndOp) <> EmptyStr;
end;

function TNFSeW_SpeedGov.DeveGerarDadosDPS: Boolean;
begin
  Result := Trim(NFSe.cLocEmi) <> EmptyStr;
end;

function TNFSeW_SpeedGov.DeveGerarDestinatario: Boolean;
begin
  Result := (Trim(NFSe.IBSCBS.dest.CNPJCPF) <> EmptyStr) or
            (Trim(NFSe.IBSCBS.dest.xNome) <> EmptyStr) or
            (Trim(NFSe.IBSCBS.dest.ender.DescricaoMunicipio) <> EmptyStr) or
            (Trim(NFSe.IBSCBS.dest.xPais) <> EmptyStr);
end;

function TNFSeW_SpeedGov.DeveGerarIBSCBS: Boolean;
begin
  Result := (Trim(NFSe.infNFSe.IBSCBS.xLocalidadeIncid) <> EmptyStr) or
            (NFSe.infNFSe.IBSCBS.cLocalidadeIncid > 0);
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

  Result.AppendChild(AddNode(tcStr, '#1', 'CST', 6, 6, 0,
                                                       CSTIBSCBSToStr(NFSe.IBSCBS.valores.trib.gIBSCBS.CST), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cClassTrib', 6, 6, 0,
                                                       NFSe.IBSCBS.valores.trib.gIBSCBS.cClassTrib, ''));
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

  Result.AppendChild(AddNode(tcStr, '#38', 'RegEspTrib', 1, 1, 1,
      FpAOwner.RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao), DSC_REGISSQN));

  if NFSe.OptanteSN = osnOptanteMEEPP then
    Result.AppendChild(AddNode(tcStr, '#38', 'RegApTribSN', 1, 1, 1,
                             RegimeApuracaoSNToStr(NFSe.RegimeApuracaoSN), ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'serie', 1, 5, 0,
                                            NFSe.IdentificacaoRps.Serie, ''));

  Result.AppendChild(AddNode(tcStr, '#38', 'nDPS', 1, 15, 0,
                                            NFSe.IdentificacaoRps.Numero, ''));

  Result.AppendChild(AddNode(tcDat, '#1', 'dCompet', 10, 10, 1,
                                            NFSe.Competencia, ''));
end;

function TNFSeW_SpeedGov.GerarDestinatario: TACBrXmlNode;
begin
  Result := nil;

  if NFSe.IBSCBS.dest.xNome <> '' then
  begin
    Result := CreateElement('Destinatario');

    if NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '' then
      Result.AppendChild(AddNode(tcStr, '#38', 'CnpjCpf', 11, 14, 0,
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

function TNFSeW_SpeedGov.GerarInfRps: TACBrXmlNode;
begin
  Result := inherited GerarInfRps;
  if DeveGerarDadosDPS then
    Result.AppendChild(GerarDadosDPS);
  if DeveGerarDestinatario then
    Result.AppendChild(GerarDestinatario);
  if DeveGerarControleIBSCBS then
    Result.AppendChild(GerarControleIBSCBS);
  if DeveGerarIBSCBS then
    Result.AppendChild(GerarIBSCBS);

  if NFSe.Competencia > 0 then
    Result.AppendChild(AddNode(tcDat, '#30', 'DataCompetencia', 1, 10, 0,
                                   NFSe.Competencia, ''));
end;

function TNFSeW_SpeedGov.GerarIni: string;
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
    GerarINISecaoValores(LINIRec);
    if (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
    begin
      GerarINIIBSCBSNFSe(LINIRec, NFSe.infNFSe.IBSCBS);
      GerarINIIBSCBS(LINIRec, NFSe.IBSCBS);
    end;
    GerarINISecaoOrgaoGerador(LINIRec);
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

procedure TNFSeW_SpeedGov.GerarINIIBSCBSValores(AINIRec: TMemIniFile;
  Valores: Tvalorestrib);
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
  inherited GerarINIIBSCBSValores(AINIRec, Valores);
end;

procedure TNFSeW_SpeedGov.GerarINISecaoIdentificacaoNFSe(
  const AINIRec: TMemIniFile);
var
  lSecao: string;
begin
  inherited GerarINISecaoIdentificacaoNFSe(AINIRec);
  lSecao := 'IdentificacaoNFSe';
  AINIRec.WriteString(lSecao, 'cLocEmi', NFSe.cLocEmi);
  AINIRec.WriteString(lSecao, 'verAplic', NFSe.verAplic);
end;

function TNFSeW_SpeedGov.GerarServico: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
  item: string;
begin
  Result := CreateElement('Servico');

  Result.AppendChild(GerarValores);

  item := FormatarItemServico(NFSe.Servico.ItemListaServico, FormatoItemListaServico);

  Result.AppendChild(AddNode(tcStr, '#29', 'ItemListaServico', 1, 5, NrOcorrItemListaServico,
                                                          item, DSC_CLISTSERV));

  Result.AppendChild(AddNode(tcStr, '#30', 'CodigoCnae', 1, 7, NrOcorrCodigoCnae,
                                OnlyNumber(NFSe.Servico.CodigoCnae), DSC_CNAE));

  Result.AppendChild(AddNode(tcStr, '#31', 'CodigoTributacaoMunicipio', 1, 20, NrOcorrCodTribMun,
                     NFSe.Servico.CodigoTributacaoMunicipio, DSC_CSERVTRIBMUN));

  Result.AppendChild(AddNode(tcStr, '#32', 'Discriminacao', 1, 2000, 1,
    StringReplace(NFSe.Servico.Discriminacao, Opcoes.QuebraLinha,
               FpAOwner.ConfigGeral.QuebradeLinha, [rfReplaceAll]), DSC_DISCR));

  Result.AppendChild(GerarServicoCodigoMunicipio);

  Result.AppendChild(AddNode(tcStr, '#31', 'cNBS', 1, 9, 0,
                     NFSe.Servico.CodigoNBS, ''));

  Result.AppendChild(AddNode(tcStr, '#31', 'xDescServ', 1, 2000, 0,
                     NFSe.Servico.Descricao, ''));

  Result.AppendChild(AddNode(tcStr, '#31', 'cIntContrib', 1, 2000, 0,
                     NFSe.Servico.CodigoInterContr, ''));
end;

function TNFSeW_SpeedGov.GerarTomador: TACBrXmlNode;
var
  tomadorIdentificado, tipoPessoa, item, cnpjCpfDestinatario,
  xCidade, xUF: string;
begin
  Result := inherited GerarTomador;
end;

function TNFSeW_SpeedGov.GerarValores: TACBrXmlNode;
var
  Aliquota: Double;
begin
  Result := CreateElement('Valores');

  Result.AppendChild(AddNode(tcDe2, '#13', 'ValorServicos', 1, 15, 1,
                             NFSe.Servico.Valores.ValorServicos, DSC_VSERVICO));

  Result.AppendChild(AddNode(tcDe2, '#14', 'ValorDeducoes', 1, 15, NrOcorrValorDeducoes,
                            NFSe.Servico.Valores.ValorDeducoes, DSC_VDEDUCISS));

  Result.AppendChild(AddNode(tcDe2, '#14', 'ValorTotalRecebido', 1, 15, NrOcorrValorTotalRecebido,
                         NFSe.Servico.Valores.ValorTotalRecebido, DSC_VTOTREC));

  Result.AppendChild(AddNode(tcDe2, '#15', 'ValorPis', 1, 15, NrOcorrValorPis,
                                      NFSe.Servico.Valores.ValorPis, DSC_VPIS));

  Result.AppendChild(AddNode(tcDe2, '#16', 'ValorCofins', 1, 15, NrOcorrValorCofins,
                                NFSe.Servico.Valores.ValorCofins, DSC_VCOFINS));

  Result.AppendChild(AddNode(tcDe2, '#17', 'ValorInss', 1, 15, NrOcorrValorInss,
                                    NFSe.Servico.Valores.ValorInss, DSC_VINSS));

  Result.AppendChild(AddNode(tcDe2, '#18', 'ValorIr', 1, 15, NrOcorrValorIr,
                                        NFSe.Servico.Valores.ValorIr, DSC_VIR));

  Result.AppendChild(AddNode(tcDe2, '#19', 'ValorCsll', 1, 15, NrOcorrValorCsll,
                                    NFSe.Servico.Valores.ValorCsll, DSC_VCSLL));

  Result.AppendChild(AddNode(tcStr, '#20', 'IssRetido', 1, 1, 1,
    FpAOwner.SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), DSC_INDISSRET));

  Result.AppendChild(AddNode(tcDe2, '#21', 'ValorIss', 1, 15, NrOcorrValorIss,
                                      NFSe.Servico.Valores.ValorIss, DSC_VISS));

  Result.AppendChild(AddNode(tcDe2, '#22', 'ValorIssRetido', 1, 15, NrOcorrValorISSRetido_1,
                               NFSe.Servico.Valores.ValorIssRetido, DSC_VNFSE));

  Result.AppendChild(AddNode(tcDe2, '#23', 'OutrasRetencoes', 1, 15, NrOcorrOutrasRet,
                    NFSe.Servico.Valores.OutrasRetencoes, DSC_OUTRASRETENCOES));

  Result.AppendChild(AddNode(tcDe2, '#24', 'BaseCalculo', 1, 15, NrOcorrBaseCalc,
                                 NFSe.Servico.Valores.BaseCalculo, DSC_VBCISS));

  Aliquota := NormatizarAliquota(NFSe.Servico.Valores.Aliquota, DivAliq100);

  Result.AppendChild(AddNode(FormatoAliq, '#25', 'Aliquota', 1, 5, NrOcorrAliquota,
                                                          Aliquota, DSC_VALIQ));

  Result.AppendChild(AddNode(tcDe2, '#26', 'ValorLiquidoNfse', 1, 15, NrOcorrValLiq,
                             NFSe.Servico.Valores.ValorLiquidoNfse, DSC_VNFSE));

  Result.AppendChild(AddNode(tcDe2, '#22', 'ValorIssRetido', 1, 15, NrOcorrValorISSRetido_2,
                               NFSe.Servico.Valores.ValorIssRetido, DSC_VNFSE));

  Result.AppendChild(AddNode(tcDe2, '#27', 'DescontoIncondicionado', 1, 15, NrOcorrDescIncond,
                 NFSe.Servico.Valores.DescontoIncondicionado, DSC_VDESCINCOND));

  Result.AppendChild(AddNode(tcDe2, '#28', 'DescontoCondicionado', 1, 15, NrOcorrDescCond,
                     NFSe.Servico.Valores.DescontoCondicionado, DSC_VDESCCOND));

  if (NFSe.Servico.Valores.CSTPis <> cstPisVazio) or
     (NFSe.Servico.Valores.AliquotaPis > 0) or
     (NFSe.Servico.Valores.AliquotaCofins > 0) then
  begin
    Result.AppendChild(AddNode(tcStr, '#28', 'CSTPisCofins', 1, 10, 0,
                       NFSe.Servico.Valores.CSTPis, ''));

    if (NFSe.Servico.Valores.BaseCalculoPisCofins > 0) and
       (NFSe.Servico.Valores.BaseCalculo <> NFSe.Servico.Valores.BaseCalculoPisCofins) then
    begin
      Result.AppendChild(AddNode(tcDe2, '#28', 'BaseCalculoPisCofins', 1, 15, 0,
                         NFSe.Servico.Valores.BaseCalculoPisCofins, ''));
    end else
    begin
      Result.AppendChild(AddNode(tcDe2, '#28', 'BaseCalculoPisCofins', 1, 15, 0,
                         NFSe.Servico.Valores.BaseCalculo, ''));
    end;

    Result.AppendChild(AddNode(tcInt, '#28', 'TipoRetencaoPisCofins', 1, 1, 0,
                       NFSe.Servico.Valores.tpRetPisCofins, ''));

    Result.AppendChild(AddNode(tcDe4, '#28', 'AliqPis', 1, 5, 0,
                       NFSe.Servico.Valores.AliquotaPis, ''));

    Result.AppendChild(AddNode(tcDe4, '#28', 'AliqCofins', 1, 5, 0,
                       NFSe.Servico.Valores.AliquotaCofins, ''));
  end;

  Result.AppendChild(AddNode(tcDe2, '#28', 'pTotTribFed', 1, 15, 0,
                     NFSe.IBSCBS.valores.ValorCbs, ''));

  Result.AppendChild(AddNode(tcDe2, '#28', 'pTotTribEst', 1, 15, 0,
                     NFSe.IBSCBS.valores.ValorIbsEstadual, ''));

  Result.AppendChild(AddNode(tcDe2, '#28', 'pTotTribMun', 1, 15, 0,
                     NFSe.IBSCBS.valores.ValorIbsMunicipal, ''));
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

  Result := True;
end;

end.
