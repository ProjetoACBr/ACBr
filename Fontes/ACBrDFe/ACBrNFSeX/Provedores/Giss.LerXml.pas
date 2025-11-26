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

unit Giss.LerXml;

interface

uses
  SysUtils, Classes, StrUtils, IniFiles,
  ACBrXmlDocument,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_Giss204 }

  TNFSeR_Giss204 = class(TNFSeR_ABRASFv2)
  protected
    function LerCodigoPaisServico(const ANode: TACBrXmlNode): Integer; override;
    function LerCodigoPaisTomador(const ANode: TACBrXmlNode): Integer; override;

    procedure LerINISecaoValores(const AINIRec: TMemIniFile); override;
    procedure LerINIValoresTribFederal(AINIRec: TMemIniFile);
    procedure LerINIValoresTotalTrib(AINIRec: TMemIniFile);
    procedure LerINIComercioExterior(AINIRec: TMemIniFile);
  public

  end;

implementation

uses
  ACBrUtil.Base,
  ACBrDFe.Conversao,
  ACBrNFSeXConversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Giss
//==============================================================================

{ TNFSeR_Giss204 }

function TNFSeR_Giss204.LerCodigoPaisServico(
  const ANode: TACBrXmlNode): Integer;
begin
  Result := CodISOPaisToCodIBGE(ObterConteudo(ANode.Childrens.FindAnyNs('CodigoPais'), tcInt));
end;

function TNFSeR_Giss204.LerCodigoPaisTomador(
  const ANode: TACBrXmlNode): Integer;
begin
  Result := CodISOPaisToCodIBGE(ObterConteudo(ANode.Childrens.FindAnyNs('CodigoPais'), tcInt));
end;

procedure TNFSeR_Giss204.LerINISecaoValores(const AINIRec: TMemIniFile);
begin
  LerINIComercioExterior(AINIRec);

  inherited LerINISecaoValores(AINIRec);

  LerINIValoresTribFederal(AINIRec);
  LerINIValoresTotalTrib(AINIRec);

  // Reforma Tributária
  if (NFSe.IBSCBS.dest.xNome <> '') or (NFSe.IBSCBS.imovel.cCIB <> '') or
     (NFSe.IBSCBS.imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.imovel.ender.endExt.cEndPost <> '') or
     (NFSe.IBSCBS.valores.trib.gIBSCBS.CST <> cstNenhum) then
  begin
    LerINIIBSCBS(AINIRec, NFSe.IBSCBS);
//    GerarINIIBSCBSNFSe(AINIRec, NFSe.infNFSe.IBSCBS);
  end;
end;

procedure TNFSeR_Giss204.LerINIValoresTotalTrib(AINIRec: TMemIniFile);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'totTrib';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Servico.Valores.totTrib.indTotTrib := StrToindTotTrib(Ok, AINIRec.ReadString(sSecao, 'indTotTrib', '0'));
    NFSe.Servico.Valores.totTrib.pTotTribSN := StringToFloatDef(AINIRec.ReadString(sSecao, 'pTotTribSN', ''), 0);

    NFSe.Servico.Valores.totTrib.vTotTribFed := StringToFloatDef(AINIRec.ReadString(sSecao, 'vTotTribFed', ''), 0);
    NFSe.Servico.Valores.totTrib.vTotTribEst := StringToFloatDef(AINIRec.ReadString(sSecao, 'vTotTribEst', ''), 0);
    NFSe.Servico.Valores.totTrib.vTotTribMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'vTotTribMun', ''), 0);

    NFSe.Servico.Valores.totTrib.pTotTribFed := StringToFloatDef(AINIRec.ReadString(sSecao, 'pTotTribFed', ''), 0);
    NFSe.Servico.Valores.totTrib.pTotTribEst := StringToFloatDef(AINIRec.ReadString(sSecao, 'pTotTribEst', ''), 0);
    NFSe.Servico.Valores.totTrib.pTotTribMun := StringToFloatDef(AINIRec.ReadString(sSecao, 'pTotTribMun', ''), 0);
  end;
end;

procedure TNFSeR_Giss204.LerINIValoresTribFederal(AINIRec: TMemIniFile);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'tribFederal';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Servico.Valores.tribFed.CST := StrToCST(Ok, AINIRec.ReadString(sSecao, 'CST', ''));
    NFSe.Servico.Valores.tribFed.vBCPisCofins := StringToFloatDef(AINIRec.ReadString(sSecao, 'vBCPisCofins', ''), 0);
    NFSe.Servico.Valores.tribFed.pAliqPis := StringToFloatDef(AINIRec.ReadString(sSecao, 'pAliqPis', ''), 0);
    NFSe.Servico.Valores.tribFed.pAliqCofins := StringToFloatDef(AINIRec.ReadString(sSecao, 'pAliqCofins' ,''), 0);
    NFSe.Servico.Valores.tribFed.vPis := StringToFloatDef(AINIRec.ReadString(sSecao, 'vPis', ''), 0);
    NFSe.Servico.Valores.tribFed.vCofins := StringToFloatDef(AINIRec.ReadString(sSecao, 'vCofins', ''), 0);
    NFSe.Servico.Valores.tribFed.tpRetPisCofins := StrTotpRetPisCofins(Ok, AINIRec.ReadString(sSecao, 'tpRetPisCofins', ''));
    NFSe.Servico.Valores.tribFed.vRetCP := StringToFloatDef(AINIRec.ReadString(sSecao, 'vRetCP', ''), 0);
    NFSe.Servico.Valores.tribFed.vRetIRRF := StringToFloatDef(AINIRec.ReadString(sSecao, 'vRetIRRF', ''), 0);
    NFSe.Servico.Valores.tribFed.vRetCSLL := StringToFloatDef(AINIRec.ReadString(sSecao, 'vRetCSLL', ''), 0);
  end;
end;

procedure TNFSeR_Giss204.LerINIComercioExterior(AINIRec: TMemIniFile);
var
  SSecao: string;
  Ok: Boolean;
begin
  sSecao := 'ComercioExterior';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Servico.comExt.mdPrestacao := StrTomdPrestacao(Ok, AINIRec.ReadString(sSecao, 'mdPrestacao', '0'));
    NFSe.Servico.comExt.vincPrest := StrTovincPrest(Ok, AINIRec.ReadString(sSecao, 'vincPrest', '0'));
    NFSe.Servico.comExt.tpMoeda := AINIRec.ReadInteger(sSecao, 'tpMoeda', 0);
    NFSe.Servico.comExt.vServMoeda := StringToFloatDef(AINIRec.ReadString(sSecao, 'vServMoeda', '0'), 0);
    NFSe.Servico.comExt.mecAFComexP := StrTomecAFComexP(Ok, AINIRec.ReadString(sSecao, 'mecAFComexP', '00'));
    NFSe.Servico.comExt.mecAFComexT := StrTomecAFComexT(Ok, AINIRec.ReadString(sSecao, 'mecAFComexT', '00'));
    NFSe.Servico.comExt.movTempBens := StrToMovTempBens(Ok, AINIRec.ReadString(sSecao, 'movTempBens', '00'));
    NFSe.Servico.comExt.nDI := AINIRec.ReadString(sSecao, 'nDI', '');
    NFSe.Servico.comExt.nRE := AINIRec.ReadString(sSecao, 'nRE', '');
    NFSe.Servico.comExt.mdic := AINIRec.ReadInteger(sSecao, 'mdic', 0);
  end;
end;

end.
