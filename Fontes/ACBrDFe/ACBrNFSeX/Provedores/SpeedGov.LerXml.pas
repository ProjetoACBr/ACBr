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

unit SpeedGov.LerXml;

interface

uses
  SysUtils, Classes, StrUtils, IniFiles, ACBrNFSeXClass, ACBrNFSeXConversao, ACBrUtil.Base,
  ACBrNFSeXLerXml_ABRASFv1, ACBrXmlDocument, ACBrDFe.Conversao, ACBrUtil.DateTime;

type
  { TNFSeR_SpeedGov }

  TNFSeR_SpeedGov = class(TNFSeR_ABRASFv1)
  protected
    procedure LerInfNfse(const ANode: TACBrXmlNode); override;
    procedure LerDadosDPS(const ANode: TACBrXmlNode);
    procedure LerDestinatario(const ANode: TACBrXmlNode);
    procedure LerControleIBSCBS(const ANode: TACBRXmlNode);
    procedure LerIBSCBS(const ANode: TACBrXmlNode);
    //======Arquivo INI===========================================
    procedure LerINISecaoIdentificacaoNFSe(const AINIRec: TMemIniFile); override;
    procedure LerINISecaoValores(const AINIRec: TMemIniFile); override;
    procedure LerINIIBSCBSValores(AINIRec: TMemIniFile; Valores: Tvalorestrib); override;
  public

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     SpeedGov
//==============================================================================

{ TNFSeR_SpeedGov }

procedure TNFSeR_SpeedGov.LerControleIBSCBS(const ANode: TACBRXmlNode);
var
  Ok: Boolean;
begin
  if not Assigned(ANode) then
    exit;

  NFSe.IBSCBS.finNFSe := StrTofinNFSe(ObterConteudo(ANode.Childrens.FindAnyNs('FinNFSe'), tcStr));
  NFSe.IBSCBS.indFinal := StrToindFinal(ObterConteudo(ANode.Childrens.FindAnyNs('IndFinal'), tcStr));
  NFSe.IBSCBS.tpOper := StrTotpOperGovNFSe(ObterConteudo(ANode.Childrens.FindAnyNs('TpOper'), tcStr));
  NFSe.IBSCBS.tpEnteGov := StrTotpEnteGov(ObterConteudo(ANode.Childrens.FindAnyNs('TpEnteGov'), tcStr));
  NFSe.IBSCBS.indDest := StrToindDest(ObterConteudo(ANode.Childrens.FindAnyNs('IndDest'), tcStr));
  NFSe.IBSCBS.cIndOp := ObterConteudo(ANode.Childrens.FindAnyNs('CIndOp'), tcStr);
  NFSe.IBSCBS.valores.trib.gIBSCBS.CST := StrToCSTIBSCBS(ObterConteudo(ANode.Childrens.FindAnyNs('CST'), tcStr));
  NFSe.IBSCBS.valores.trib.gIBSCBS.cClassTrib := ObterConteudo(ANode.Childrens.FindAnyNs('cClassTrib'), tcStr);
end;

procedure TNFSeR_SpeedGov.LerDadosDPS(const ANode: TACBrXmlNode);
var
  Ok: Boolean;
begin
  if not Assigned(ANode) then
    exit;

  NFSe.tpEmit := StrTotpEmit(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('TpEmit'), tcStr));
  NFSe.DataEmissao := StringToDateTimeDef(ObterConteudo(ANode.Childrens.FindAnyNs('DhEmi'), tcStr), 0);
  NFSe.verAplic := ObterConteudo(ANode.Childrens.FindAnyNs('VerAplic'), tcStr);
  NFSe.cLocEmi := ObterConteudo(ANode.Childrens.FindAnyNs('CLocEmi'), tcStr);
  NFSe.Servico.CodigoMunicipio := ObterConteudo(ANode.Childrens.FindAnyNs('CLocPrestacao'), tcStr);
  NFSe.Servico.ItemListaServico := ObterConteudo(ANode.Childrens.FindAnyNs('CTribNac'), tcStr);
  NFSe.Servico.Valores.tribMun.tribISSQN := StrTotribISSQN(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('TribIssqn'), tcStr));
  NFSe.Servico.Valores.tribMun.tpRetISSQN := StrTotpRetISSQN(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('TpRetIssqn'), tcStr));
  NFSe.OptanteSN := StrToOptanteSN(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('OpSimpNac'), tcStr));
  NFSe.RegimeEspecialTributacao := FpAOwner.StrToRegimeEspecialTributacao(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('RegEspTrib'), tcStr));

  if NFSe.OptanteSN = osnOptanteMEEPP then
    NFSe.RegimeApuracaoSN := StrToRegimeApuracaoSN(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('RegApTribSN'), tcStr));

  NFSe.IdentificacaoRps.Serie := ObterConteudo(ANode.Childrens.FindAnyNs('serie'), tcStr);
  NFSe.IdentificacaoRps.Numero := ObterConteudo(ANode.Childrens.FindAnyNs('nDPS'), tcStr);
  NFSe.Competencia := ObterConteudo(ANode.Childrens.FindAnyNs('dCompet'), tcDat);
end;

procedure TNFSeR_SpeedGov.LerDestinatario(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then
    exit;

  NFSe.IBSCBS.dest.CNPJCPF := ObterConteudo(ANode.Childrens.FindAnyNs('CnpjCpf'), tcStr);
  NFSe.IBSCBS.dest.xNome := ObterConteudo(ANode.Childrens.FindAnyNs('Nome'), tcStr);
  NFSe.IBSCBS.dest.ender.xLgr := ObterConteudo(ANode.Childrens.FindAnyNs('Logradouro'), tcStr);
  NFSe.IBSCBS.dest.ender.nro := ObterConteudo(ANode.Childrens.FindAnyNs('Numero'), tcStr);
  NFSe.IBSCBS.dest.ender.xCpl := ObterConteudo(ANode.Childrens.FindAnyNs('Complemento'), tcStr);
  NFSe.IBSCBS.dest.ender.xBairro := ObterConteudo(ANode.Childrens.FindAnyNs('Bairro'), tcStr);
  NFSe.IBSCBS.dest.ender.DescricaoMunicipio := ObterConteudo(ANode.Childrens.FindAnyNs('Cidade'), tcStr);
  NFSe.IBSCBS.dest.ender.UF := ObterConteudo(ANode.Childrens.FindAnyNs('UF'), tcStr);
  NFSe.IBSCBS.dest.ender.endNac.CEP := ObterConteudo(ANode.Childrens.FindAnyNs('CEP'), tcStr);
  NFSe.IBSCBS.dest.ender.endNac.cMun := ObterConteudo(ANode.Childrens.FindAnyNs('CodMunicipio'), tcStr);
  NFSe.IBSCBS.dest.ender.endExt.cPais := ObterConteudo(ANode.Childrens.FindAnyNs('CodPais'), tcStr);
  NFSe.IBSCBS.dest.Email := ObterConteudo(ANode.Childrens.FindAnyNs('Email'), tcStr);
  NFSe.IBSCBS.dest.fone := ObterConteudo(ANode.Childrens.FindAnyNs('Telefone'), tcStr);
end;

procedure TNFSeR_SpeedGov.LerIBSCBS(const ANode: TACBrXmlNode);
begin
  if not Assigned(ANode) then
    exit;

  NFSe.Servico.Valores.BaseCalculo := ObterConteudo(ANode.Childrens.FindAnyNs('IBSCBSBaseCalculo'), tcDe2);
  NFSe.IBSCBS.valores.IbsEstadual := ObterConteudo(ANode.Childrens.FindAnyNs('IBSUFAliquota'), tcDe2);
  NFSe.IBSCBS.valores.IbsMunicipal := ObterConteudo(ANode.Childrens.FindAnyNs('IBSMunAliquota'), tcDe2);
  NFSe.IBSCBS.valores.Cbs := ObterConteudo(ANode.Childrens.FindAnyNs('CBSAliquota'), tcDe2);
  NFSe.IBSCBS.valores.ValorIbsEstadual := ObterConteudo(ANode.Childrens.FindAnyNs('IBSUFValor'), tcDe2);
  NFSe.IBSCBS.valores.ValorIbsMunicipal := ObterConteudo(ANode.Childrens.FindAnyNs('IBSMunValor'), tcDe2);
  NFSe.IBSCBS.valores.ValorCbs := ObterConteudo(ANode.Childrens.FindAnyNs('CBSValor'), tcDe2);
  NFSe.infNFSe.IBSCBS.valores.uf.pRedAliqUF := ObterConteudo(ANode.Childrens.FindAnyNs('IBSUFPercReducao'), tcDe2);
  NFSe.infNFSe.IBSCBS.valores.mun.pRedAliqMun := ObterConteudo(ANode.Childrens.FindAnyNs('IBSMunPercReducao'), tcDe2);
  NFSe.infNFSe.IBSCBS.valores.fed.pRedAliqCBS := ObterConteudo(ANode.Childrens.FindAnyNs('CBSPercReducao'), tcDe2);
  NFSe.infNFSe.IBSCBS.valores.uf.pAliqEfetUF := ObterConteudo(ANode.Childrens.FindAnyNs('IBSUFAliquotaEfetiva'), tcDe2);
  NFSe.infNFSe.IBSCBS.valores.mun.pAliqEfetMun := ObterConteudo(ANode.Childrens.FindAnyNs('IBSMunAliquotaEfetiva'), tcDe2);
  NFSe.infNFSe.IBSCBS.valores.fed.pAliqEfetCBS := ObterConteudo(ANode.Childrens.FindAnyNs('CBSAliquotaEfetiva'), tcDe2);
  NFSe.Servico.Valores.ValorTotalNotaFiscal := ObterConteudo(ANode.Childrens.FindAnyNs('ValorTotalComTributos'), tcDe2);
  NFSe.infNFSe.IBSCBS.cLocalidadeIncid := ObterConteudo(ANode.Childrens.FindAnyNs('LocalidadeIncidenciaCod'), tcDe2);
  NFSe.infNFSe.IBSCBS.xLocalidadeIncid := ObterConteudo(ANode.Childrens.FindAnyNs('LocalidadeIncidenciaNome'), tcDe2);
end;

procedure TNFSeR_SpeedGov.LerInfNfse(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXMLNode;
begin
  inherited LerInfNfse(ANode);
  if Assigned(ANode) then
  begin
    AuxNode := ANode.Childrens.FindAnyNs('InfNfse');
    if not Assigned(AuxNode) then
      exit;

    LerDadosDPS(AuxNode.Childrens.FindAnyNs('DadosDPS'));
    LerDestinatario(AuxNode.Childrens.FindAnyNs('Destinatario'));
    LerControleIBSCBS(AuxNode.Childrens.FindAnyNs('ControleIBSCBS'));
    LerIBSCBS(AuxNode.Childrens.FindAnyNs('IBSCBS'));
  end;
end;

procedure TNFSeR_SpeedGov.LerINIIBSCBSValores(AINIRec: TMemIniFile;
  Valores: Tvalorestrib);
var
  lSecao: String;
begin
  lSecao := 'IBSCBSValores';
  if AINIRec.SectionExists(lSecao) then
  begin
    NFSe.IBSCBS.valores.IbsMunicipal := AINIRec.ReadFloat(lSecao, 'IbsMunicipal', 0);
    NFSe.IBSCBS.valores.ValorIbsMunicipal := AINIRec.ReadFloat(lSecao, 'ValorIbsMunicipal', 0);
    NFSe.IBSCBS.valores.IbsEstadual := AINIRec.ReadFloat(lSecao, 'IbsEstadual', 0);
    NFSe.IBSCBS.valores.ValorIbsEstadual := AINIRec.ReadFloat(lSecao, 'ValorIbsEstadual', 0);
    NFSe.IBSCBS.valores.Cbs := AINIRec.ReadFloat(lSecao, 'Cbs', 0);
    NFSe.IBSCBS.valores.ValorCbs := AINIRec.ReadFloat(lSecao, 'ValorCbs', 0);
  end;

  inherited LerINIIBSCBSValores(AINIRec, Valores);
end;

procedure TNFSeR_SpeedGov.LerINISecaoIdentificacaoNFSe(
  const AINIRec: TMemIniFile);
var
  lSecao: string;
begin
  inherited LerINISecaoIdentificacaoNFSe(AINIRec);
  lSecao := 'IdentificacaoNFSe';
  NFSe.cLocEmi := AINIRec.ReadString(lSecao, 'cLocEmi', '');
  NFSe.verAplic := AINIRec.ReadString(lSecao, 'verAplic', '');
end;

procedure TNFSeR_SpeedGov.LerINISecaoValores(const AINIRec: TMemIniFile);
var
  lSecao: String;
  Ok: Boolean;
begin
  inherited LerINISecaoValores(AINIRec);
  lSecao := 'Valores';
  if AINIRec.SectionExists(lSecao) then
  begin
    NFSe.Servico.Valores.BaseCalculoPisCofins := StringToFloatDef(AINIRec.ReadString(lSecao, 'BaseCalculoPisCofins', ''), 0);
    NFSe.Servico.Valores.CSTPis :=  ACBrNFSeXConversao.StrToCSTPis(Ok, AINIRec.ReadString(lSecao, 'CSTPis', ''));
    NFSe.Servico.Valores.tpRetPisCofins := StrTotpRetPisCofins(Ok, AINIRec.ReadString(lSecao, 'tpRetPisCofins', ''));
  end;
end;

end.

