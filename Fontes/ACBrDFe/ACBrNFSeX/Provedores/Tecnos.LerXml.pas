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

unit Tecnos.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlDocument, IniFiles,
  ACBrDFe.Conversao,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_Tecnos201 }

  TNFSeR_Tecnos201 = class(TNFSeR_ABRASFv2)
  protected
    procedure LerConstrucaoCivil(const ANode: TACBrXmlNode); override;
    //======Arquivo INI===========================================
    procedure LerINISecaoConstrucaoCivil(const AINIRec: TMemIniFile); override;
    procedure LerINISecaoServico(const AINIRec: TMemIniFile); override;

  public
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean; override;

  end;

implementation

uses
  ACBrNFSeXConversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Tecnos
//==============================================================================

{ TNFSeR_Tecnos201 }

procedure TNFSeR_Tecnos201.LerConstrucaoCivil(const ANode: TACBrXmlNode);
var
  lAuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) then Exit;

  lAuxNode := ANode.Childrens.FindAnyNs('ConstrucaoCivil');

  if Assigned(lAuxNode) then
  begin
    NFSe.ConstrucaoCivil.LocalConstrucao := ObterConteudo(lAuxNode.Childrens.FindAnyNs('LocalConstrucao'), tcStr);
    NFSe.ConstrucaoCivil.CodigoObra := ObterConteudo(lAuxNode.Childrens.FindAnyNs('CodigoObra'), tcStr);
    NFSe.ConstrucaoCivil.Art := ObterConteudo(lAuxNode.Childrens.FindAnyNs('Art'), tcStr);
    NFSe.ConstrucaoCivil.ReformaCivil := FpAOwner.StrToSimNao(Ok, ObterConteudo(lAuxNode.Childrens.FindAnyNs('ReformaCivil'), tcStr));
    NFSe.ConstrucaoCivil.Cib := ObterConteudo(lAuxNode.Childrens.FindAnyNs('Cib'), tcInt);
    NFSe.ConstrucaoCivil.Endereco.UF := ObterConteudo(lAuxNode.Childrens.FindAnyNs('EstadoObra'), tcStr);
    NFSe.ConstrucaoCivil.Endereco.CodigoMunicipio := ObterConteudo(lAuxNode.Childrens.FindAnyNs('CidadeObra'), tcStr);
    NFSe.ConstrucaoCivil.Endereco.Endereco := ObterConteudo(lAuxNode.Childrens.FindAnyNs('EnderecoObra'), tcStr);
    NFSe.ConstrucaoCivil.Endereco.Numero := ObterConteudo(lAuxNode.Childrens.FindAnyNs('NumeroObra'), tcStr);
    NFSe.ConstrucaoCivil.Endereco.Bairro := ObterConteudo(lAuxNode.Childrens.FindAnyNs('BairroObra'), tcStr);
    NFSe.ConstrucaoCivil.Endereco.CEP := ObterConteudo(lAuxNode.Childrens.FindAnyNs('CepObra'), tcStr);
    NFSe.ConstrucaoCivil.Endereco.Complemento := ObterConteudo(lAuxNode.Childrens.FindAnyNs('ComplementoObra'), tcStr);
  end;
end;

procedure TNFSeR_Tecnos201.LerINISecaoConstrucaoCivil(const AINIRec: TMemIniFile);
var
  lSecao: String;
  Ok: Boolean;
begin
  lSecao := 'ConstrucaoCivil';

  if AINIRec.SectionExists(LSecao) then
  begin
    NFSe.ConstrucaoCivil.LocalConstrucao := AINIRec.ReadString(lSecao, 'LocalConstrucao', EmptyStr);
    NFSe.ConstrucaoCivil.CodigoObra := AINIRec.ReadString(LSecao, 'CodigoObra', EmptyStr);
    NFSe.ConstrucaoCivil.Art := AINIRec.ReadString(LSecao, 'Art', EmptyStr);
    NFSE.ConstrucaoCivil.ReformaCivil := FpAOwner.StrToSimNao(Ok, AINIRec.ReadString(lSecao, 'ReformaCivil', EmptyStr));
    NFSE.ConstrucaoCivil.Cib := AINIRec.ReadInteger(lSecao, 'Cib', 0);
    NFSe.ConstrucaoCivil.Endereco.UF := AINIRec.ReadString(lSecao, 'UF', EmptyStr);
    NFSe.ConstrucaoCivil.Endereco.CodigoMunicipio := AINIRec.ReadString(lSecao, 'CodigoMunicipio', EmptyStr);
    NFSe.ConstrucaoCivil.Endereco.Endereco := AINIRec.ReadString(lSecao, 'Logradouro', EmptyStr);
    NFSE.ConstrucaoCivil.Endereco.Numero := AINIRec.ReadString(lSecao, 'Numero', '0');
    NFSe.ConstrucaoCivil.Endereco.Bairro := AINIRec.ReadString(lSecao, 'Bairro', EmptyStr);
    NFSe.ConstrucaoCivil.Endereco.CEP := AINIRec.ReadString(lSecao, 'CEP', EmptyStr);
    NFSe.ConstrucaoCivil.Endereco.Complemento := AINIRec.ReadString(lSecao, 'Complemento', EmptyStr);
  end;
end;

procedure TNFSeR_Tecnos201.LerINISecaoServico(const AINIRec: TMemIniFile);
var
  lSecao: String;
  Ok: Boolean;
begin
  lSecao := 'Servico';
  if AINIRec.SectionExists(lSecao) then
  begin
    NFSe.Servico.ResponsavelRetencao := FpAOwner.StrToResponsavelRetencao(Ok, AINIRec.ReadString(lSecao, 'ResponsavelRetencao', FpAOwner.ResponsavelRetencaoToStr(NFSe.Servico.ResponsavelRetencao)));
    NFSe.Servico.ItemListaServico := AINIRec.ReadString(lSecao, 'ItemListaServico', NFSe.Servico.ItemListaServico);
    NFSe.Servico.xItemListaServico := AINIRec.ReadString(lSecao, 'xItemListaServico', NFSe.Servico.xItemListaServico);
    NFSe.Servico.CodigoCnae := AINIRec.ReadString(lSecao, 'CodigoCnae', NFSe.Servico.CodigoCnae);
    NFSe.Servico.CodigoTributacaoMunicipio := AINIRec.ReadString(lSecao, 'CodigoTributacaoMunicipio', NFSe.Servico.CodigoTributacaoMunicipio);
    NFSe.Servico.xCodigoTributacaoMunicipio := AINIRec.ReadString(lSecao, 'xCodigoTributacaoMunicipio', NFSe.Servico.xCodigoTributacaoMunicipio);
    NFSe.Servico.Discriminacao := AINIRec.ReadString(lSecao, 'Discriminacao', NFSe.Servico.Discriminacao);
    NFSe.Servico.CodigoMunicipio := AINIRec.ReadString(lSecao, 'CodigoMunicipio', NFSe.Servico.CodigoMunicipio);
    NFSe.Servico.CodigoPais := AINIRec.ReadInteger(lSecao, 'CodigoPais', NFSe.Servico.CodigoPais);
    NFSe.Servico.ExigibilidadeISS := FpAOwner.StrToExigibilidadeISS(Ok, AINIRec.ReadString(lSecao, 'ExigibilidadeISS', FpAOwner.ExigibilidadeISSToStr(NFSe.Servico.ExigibilidadeISS)));
    NFSe.Servico.MunicipioIncidencia := AINIRec.ReadInteger(lSecao, 'MunicipioIncidencia', NFSe.Servico.MunicipioIncidencia);
    NFSe.Servico.xMunicipioIncidencia := AINIRec.ReadString(lSecao, 'xMunicipioIncidencia', NFSe.Servico.xMunicipioIncidencia);
    NFSe.Servico.NumeroProcesso := AINIRec.ReadString(lSecao, 'NumeroProcesso', NFSe.Servico.NumeroProcesso);
    NFSe.Servico.xPed := AINIRec.ReadString(lSecao, 'xPed', NFSe.Servico.xPed);
    NFSE.Servico.nItemPed := AINIRec.ReadString(lSecao, 'nItemPed', NFSE.Servico.nItemPed);
    NFSe.Servico.CodigoNBS := AINIRec.ReadString(lSecao, 'CodigoNBS', NFSe.Servico.CodigoNBS);
    NFSe.Servico.CodigoServicoNacional := AINIRec.ReadString(lSecao, 'CodigoServicoNacional', NFSe.Servico.CodigoServicoNacional);
  end;
end;

function TNFSeR_Tecnos201.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;

  if not Assigned(ANode) then Exit;

  // O provedor Tecnos tem essa tag entre as tag CompNfse e Nfse.
  AuxNode := ANode.Childrens.FindAnyNs('tcCompNfse');

  if AuxNode = nil then
    AuxNode := ANode;

  AuxNode := AuxNode.Childrens.FindAnyNs('Nfse');

  if AuxNode = nil then
    AuxNode := ANode;

  LerInfNfse(AuxNode);

  LerNfseCancelamento(ANode);
  LerNfseSubstituicao(ANode);

  LerCampoLink;

  if NFSe.OptanteSimplesNacional = snSim then
    NFSe.OptanteSimplesNacional := snNao
  else
    NFSe.OptanteSimplesNacional := snSim;
end;

end.
