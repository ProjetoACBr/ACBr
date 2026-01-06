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

unit ISSNatal.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlDocument,
  ACBrDFe.Conversao,
  ACBrNFSeXClass,
  ACBrNFSeXGravarXml_ABRASFv1;

type
  { TNFSeW_ISSNatal }

  TNFSeW_ISSNatal = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

    function GerarServico: TACBrXmlNode; override;
    function GerarXMLIBSCBS(IBSCBS: TIBSCBSDPS): TACBrXmlNode; override;
    function GerarXMLResumo: TACBrXmlNode;
    function GerarXMLIBSCBSValores(Valores: TvaloresIBSCBS): TACBrXmlNode;
    function GerarXMLIBSCBSValoresUF(ValoresUF: TUF): TACBrXmlNode;
    function GerarXMLIBSCBSValoresMun(ValoresMun: TMun): TACBrXmlNode;
    function GerarXMLIBSCBSValoresFed(ValoresFed: TFed): TACBrXmlNode;
    function GerarXMLIBSCBSTotCIBS(totCIBS: TtotCIBS): TACBrXmlNode;
    function GerarXMLIBSCBSTotCIBSgIBS(gIBS: TgIBS): TACBrXmlNode;
    function GerarXMLIBSCBSTotCIBSgIBSUFTot(gIBSUFTot: TgIBSUFTot): TACBrXmlNode;
    function GerarXMLIBSCBSTotCIBSgIBSMunTot(gIBSMunTot: TgIBSMunTot): TACBrXmlNode;
    function GerarXMLIBSCBSTotCIBSgCBS(gCBS: TgCBS): TACBrXmlNode;


  end;

implementation

uses
  ACBrUtil.Strings;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     ISSNatal
//==============================================================================

{ TNFSeW_ISSNatal }

procedure TNFSeW_ISSNatal.Configuracao;
begin
  inherited Configuracao;

  NrOcorrBaseCalc := 1;
  DivAliq100 := True;
end;

function TNFSeW_ISSNatal.GerarServico: TACBrXmlNode;
begin
  Result := inherited GerarServico;

  Result.AppendChild(AddNode(tcStr, '#32', 'CodigoNbs', 1, 9, 1,
                                       OnlyNumber(NFSe.Servico.CodigoNBS), ''));

  // Reforma Tributária
  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
    Result.AppendChild(GerarXMLIBSCBS(NFSe.IBSCBS));
end;

function TNFSeW_ISSNatal.GerarXMLIBSCBS(IBSCBS: TIBSCBSDPS): TACBrXmlNode;
begin
  Result := inherited GerarXMLIBSCBS(IBSCBS);

  Result.AppendChild(GerarXMLResumo);
end;

function TNFSeW_ISSNatal.GerarXMLResumo: TACBrXmlNode;
begin
  Result := CreateElement('resumo');

  Result.AppendChild(AddNode(tcInt, '#1', 'cLocalidadeIncid', 7, 7, 1,
                                     NFSe.infNFSe.IBSCBS.cLocalidadeIncid, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'xLocalidadeIncid', 1, 150, 1,
                                     NFSe.infNFSe.IBSCBS.xLocalidadeIncid, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedutor', 1, 7, 1,
                                             NFSe.infNFSe.IBSCBS.pRedutor, ''));

  Result.AppendChild(GerarXMLIBSCBSValores(NFSe.infNFSe.IBSCBS.Valores));
  Result.AppendChild(GerarXMLIBSCBSTotCIBS(NFSe.infNFSe.IBSCBS.totCIBS));
end;

function TNFSeW_ISSNatal.GerarXMLIBSCBSValores(
  Valores: TvaloresIBSCBS): TACBrXmlNode;
begin
  Result := CreateElement('valores');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vBC', 1, 15, 1, Valores.vBC, ''));

  Result.AppendChild(GerarXMLIBSCBSValoresUF(Valores.uf));
  Result.AppendChild(GerarXMLIBSCBSValoresMun(Valores.mun));
  Result.AppendChild(GerarXMLIBSCBSValoresFed(Valores.fed));
end;

function TNFSeW_ISSNatal.GerarXMLIBSCBSValoresUF(
  ValoresUF: TUF): TACBrXmlNode;
begin
  Result := CreateElement('uf');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pIBSUF', 1, 7, 1,
                                                         ValoresUF.pIBSUF, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedAliqUF', 1, 7, 1,
                                                     ValoresUF.pRedAliqUF, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqEfetUF', 1, 7, 1,
                                                    ValoresUF.pAliqEfetUF, ''));
end;

function TNFSeW_ISSNatal.GerarXMLIBSCBSValoresMun(
  ValoresMun: TMun): TACBrXmlNode;
begin
  Result := CreateElement('mun');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pIBSMun', 1, 7, 1,
                                                       ValoresMun.pIBSMun, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedAliqMun', 1, 7, 1,
                                                   ValoresMun.pRedAliqMun, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqEfetMun', 1, 7, 1,
                                                  ValoresMun.pAliqEfetMun, ''));
end;

function TNFSeW_ISSNatal.GerarXMLIBSCBSValoresFed(
  ValoresFed: TFed): TACBrXmlNode;
begin
  Result := CreateElement('fed');

  Result.AppendChild(AddNode(tcDe2, '#1', 'pCBS', 1, 7, 1,
                                                          ValoresFed.pCBS, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pRedAliqCBS', 1, 7, 1,
                                                   ValoresFed.pRedAliqCBS, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pAliqEfetCBS', 1, 7, 1,
                                                  ValoresFed.pAliqEfetCBS, ''));
end;

function TNFSeW_ISSNatal.GerarXMLIBSCBSTotCIBS(
  totCIBS: TtotCIBS): TACBrXmlNode;
begin
  Result := CreateElement('totCIBS');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vTotNF', 1, 15, 1,
                                                           totCIBS.vTotNF, ''));

  Result.AppendChild(GerarXMLIBSCBSTotCIBSgIBS(totCIBS.gIBS));
  Result.AppendChild(GerarXMLIBSCBSTotCIBSgCBS(totCIBS.gCBS));
end;

function TNFSeW_ISSNatal.GerarXMLIBSCBSTotCIBSgIBS(
  gIBS: TgIBS): TACBrXmlNode;
begin
  Result := CreateElement('gIBS');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vIBSTot', 1, 15, 1,
                                                             gIBS.vIBSTot, ''));

  Result.AppendChild(GerarXMLIBSCBSTotCIBSgIBSUFTot(gIBS.gIBSUFTot));
  Result.AppendChild(GerarXMLIBSCBSTotCIBSgIBSMunTot(gIBS.gIBSMunTot));
end;

function TNFSeW_ISSNatal.GerarXMLIBSCBSTotCIBSgIBSUFTot(
  gIBSUFTot: TgIBSUFTot): TACBrXmlNode;
begin
  Result := CreateElement('gIBSUFTot');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vDifUF', 1, 15, 1,
                                                         gIBSUFTot.vDifUF, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vIBSUF', 1, 15, 1,
                                                         gIBSUFTot.vIBSUF, ''));
end;

function TNFSeW_ISSNatal.GerarXMLIBSCBSTotCIBSgIBSMunTot(
  gIBSMunTot: TgIBSMunTot): TACBrXmlNode;
begin
  Result := CreateElement('gIBSMunTot');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vDifMun', 1, 15, 1,
                                                       gIBSMunTot.vDifMun, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vIBSMun', 1, 15, 1,
                                                       gIBSMunTot.vIBSMun, ''));
end;

function TNFSeW_ISSNatal.GerarXMLIBSCBSTotCIBSgCBS(
  gCBS: TgCBS): TACBrXmlNode;
begin
  Result := CreateElement('gCBS');

  Result.AppendChild(AddNode(tcDe2, '#1', 'vDifCBS', 1, 15, 1,
                                                             gCBS.vDifCBS, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'vCBS', 1, 15, 1, gCBS.vCBS, ''));
end;

end.
