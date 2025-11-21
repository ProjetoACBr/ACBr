{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit PadraoNacional.LerXml;

interface

uses
  SysUtils, Classes, StrUtils, IniFiles,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXClass,
  ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { TNFSeR_PadraoNacional }

  TNFSeR_PadraoNacional = class(TNFSeRClass)
  protected
    FpTipoXML: string;

    procedure LerXMLinfNFSe(const ANode: TACBrXmlNode);
    procedure LerXMLEmitente(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoEmitente(const ANode: TACBrXmlNode);

    procedure LerXMLValoresNFSe(const ANode: TACBrXmlNode);
    procedure LerXMLDPS(const ANode: TACBrXmlNode);

    procedure LerXMLinfDPS(const ANode: TACBrXmlNode);
    procedure LerXMLSubstituicao(const ANode: TACBrXmlNode);

    procedure LerXMLPrestador(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoPrestador(const ANode: TACBrXmlNode);
    procedure LerXMLRegimeTributacaoPrestador(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoNacionalPrestador(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoExteriorPrestador(const ANode: TACBrXmlNode);

    procedure LerXMLTomador(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoTomador(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoNacionalTomador(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoExteriorTomador(const ANode: TACBrXmlNode);

    procedure LerXMLIntermediario(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoItermediario(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoNacionalIntermediario(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoExteriorIntermediario(const ANode: TACBrXmlNode);

    procedure LerXMLServico(const ANode: TACBrXmlNode);
    procedure LerXMLLocalPrestacao(const ANode: TACBrXmlNode);
    procedure LerXMLCodigoServico(const ANode: TACBrXmlNode);
    procedure LerXMLComercioExterior(const ANode: TACBrXmlNode);
    procedure LerXMLLocacaoSubLocacao(const ANode: TACBrXmlNode);
    procedure LerXMLObra(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoObra(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoExteriorObra(const ANode: TACBrXmlNode);
    procedure LerXMLAtividadeEvento(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoEvento(const ANode: TACBrXmlNode);
    procedure LerXMLEnderecoExteriorEvento(const ANode: TACBrXmlNode);
    procedure LerXMLExploracaoRodoviaria(const ANode: TACBrXmlNode);
    procedure LerXMLInformacoesComplementares(const ANode: TACBrXmlNode);

    procedure LerXMLValores(const ANode: TACBrXmlNode);
    procedure LerXMLServicoPrestado(const ANode: TACBrXmlNode);
    procedure LerXMLDescontos(const ANode: TACBrXmlNode);
    procedure LerXMLDeducoes(const ANode: TACBrXmlNode);
    procedure LerXMLDocDeducoes(const ANode: TACBrXmlNode);
    procedure LerXMLNFSeMunicipio(const ANode: TACBrXmlNode; Item: Integer);
    procedure LerXMLNFNFS(const ANode: TACBrXmlNode; Item: Integer);
    procedure LerXMLFornecedor(const ANode: TACBrXmlNode; Item: Integer);
    procedure LerXMLEnderecoFornecedor(const ANode: TACBrXmlNode; Item: Integer);
    procedure LerXMLEnderecoNacionalFornecedor(const ANode: TACBrXmlNode; Item: Integer);
    procedure LerXMLEnderecoExteriorFornecedr(const ANode: TACBrXmlNode; Item: Integer);

    procedure LerXMLTributacao(const ANode: TACBrXmlNode);
    procedure LerXMLTributacaoMunicipal(const ANode: TACBrXmlNode);
    procedure LerXMLBeneficioMunicipal(const ANode: TACBrXmlNode);
    procedure LerXMLExigibilidadeSuspensa(const ANode: TACBrXmlNode);
    procedure LerXMLTributacaoFederal(const ANode: TACBrXmlNode);
    procedure LerXMLTributacaoOutrosPisCofins(const ANode: TACBrXmlNode);
    procedure LerXMLTotalTributos(const ANode: TACBrXmlNode);
    procedure LerXMLValorTotalTributos(const ANode: TACBrXmlNode);
    procedure LerXMLPercentualTotalTributos(const ANode: TACBrXmlNode);

    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;

    //====== Ler o Arquivo INI===========================================
    procedure LerINIIdentificacaoNFSe(AINIRec: TMemIniFile);
    procedure LerINIIdentificacaoRps(AINIRec: TMemIniFile);
    procedure LerININFSeSubstituicao(AINIRec: TMemIniFile);
    procedure LerINIDadosEmitente(AINIRec: TMemIniFile);
    procedure LerINIValoresNFSe(AINIRec: TMemIniFile);

    procedure LerINIDadosPrestador(AINIRec: TMemIniFile);
    procedure LerINIDadosTomador(AINIRec: TMemIniFile);
    procedure LerINIDadosIntermediario(AINIRec: TMemIniFile);
    procedure LerINIConstrucaoCivil(AINIRec: TMemIniFile);
    procedure LerINIDadosServico(AINIRec: TMemIniFile);
    procedure LerINIComercioExterior(AINIRec: TMemIniFile);
    procedure LerINILocacaoSubLocacao(AINIRec: TMemIniFile);
    procedure LerINIEvento(AINIRec: TMemIniFile);
    procedure LerINIRodoviaria(AINIRec: TMemIniFile);
    procedure LerINIInformacoesComplementares(AINIRec: TMemIniFile);
    procedure LerINIValores(AINIRec: TMemIniFile);
    procedure LerINIDocumentosDeducoes(AINIRec: TMemIniFile);
    procedure LerINIDocumentosDeducoesFornecedor(AINIRec: TMemIniFile;
      fornec: TInfoPessoa; Indice: Integer);
    procedure LerINIValoresTribMun(AINIRec: TMemIniFile);
    procedure LerINIValoresTribFederal(AINIRec: TMemIniFile);
    procedure LerINIValoresTotalTrib(AINIRec: TMemIniFile);

    procedure LerIniRps(AINIRec: TMemIniFile);
    procedure LerIniNfse(AINIRec: TMemIniFile);
  public
    function LerXml: Boolean; override;
    function LerIni: Boolean; override;
  end;

implementation

uses
  ACBrDFeUtil,
  ACBrDFe.Conversao,
  ACBrUtil.Base,
  ACBrUtil.XMLHTML,
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrUtil.FilesIO;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     PadraoNacional
//==============================================================================

{ TNFSeR_PadraoNacional }

procedure TNFSeR_PadraoNacional.LerXMLAtividadeEvento(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('atvEvento');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Evento do
    begin
      xNome := ObterConteudo(AuxNode.Childrens.FindAnyNs('xNome'), tcStr);
      dtIni := ObterConteudo(AuxNode.Childrens.FindAnyNs('dtIni'), tcDat);
      dtFim := ObterConteudo(AuxNode.Childrens.FindAnyNs('dtFim'), tcDat);
      idAtvEvt := ObterConteudo(AuxNode.Childrens.FindAnyNs('idAtvEvt'), tcStr);

      LerXMLEnderecoEvento(AuxNode);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLBeneficioMunicipal(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('BM');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.tribMun do
    begin
//      tpBM := StrTotpBM(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('tpBM'), tcStr));
      nBM := ObterConteudo(AuxNode.Childrens.FindAnyNs('nBM'), tcStr);
      vRedBCBM := ObterConteudo(AuxNode.Childrens.FindAnyNs('vRedBCBM'), tcDe2);
      pRedBCBM := ObterConteudo(AuxNode.Childrens.FindAnyNs('pRedBCBM'), tcDe2);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLCodigoServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('cServ');

  if AuxNode <> nil then
  begin
    with NFSe.Servico do
    begin
      ItemListaServico := ObterConteudo(AuxNode.Childrens.FindAnyNs('cTribNac'), tcStr);

      if NFSe.infNFSe.xTribNac = '' then
        xItemListaServico := ItemListaServicoDescricao(ItemListaServico)
      else
        xItemListaServico := NFSe.infNFSe.xTribNac;

      CodigoTributacaoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cTribMun'), tcStr);
      Discriminacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('xDescServ'), tcStr);
      Discriminacao := StringReplace(Discriminacao, FpQuebradeLinha,
                                                    sLineBreak, [rfReplaceAll]);

      VerificarSeConteudoEhLista(Discriminacao);

      CodigoNBS := ObterConteudo(AuxNode.Childrens.FindAnyNs('cNBS'), tcStr);
      CodigoInterContr := ObterConteudo(AuxNode.Childrens.FindAnyNs('cIntContrib'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLComercioExterior(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('comExt');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.comExt do
    begin
      mdPrestacao := StrTomdPrestacao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('mdPrestacao'), tcStr));
      vincPrest := StrTovincPrest(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('vincPrest'), tcStr));
      tpMoeda := ObterConteudo(AuxNode.Childrens.FindAnyNs('tpMoeda'), tcInt);
      vServMoeda := ObterConteudo(AuxNode.Childrens.FindAnyNs('vServMoeda'), tcDe2);
      mecAFComexP := StrTomecAFComexP(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('mecAFComexP'), tcStr));
      mecAFComexT := StrTomecAFComexT(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('mecAFComexT'), tcStr));
      movTempBens := StrTomovTempBens(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('movTempBens'), tcStr));
      nDI := ObterConteudo(AuxNode.Childrens.FindAnyNs('nDI'), tcStr);
      nRE := ObterConteudo(AuxNode.Childrens.FindAnyNs('nRE'), tcStr);
      mdic := ObterConteudo(AuxNode.Childrens.FindAnyNs('mdic'), tcInt);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLDeducoes(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('vDedRed');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores do
    begin
      AliquotaDeducoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('pDR'), tcDe2);
      ValorDeducoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('vDR'), tcDe2);

      LerXMLDocDeducoes(AuxNode);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLDescontos(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('vDescCondIncond');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores do
    begin
      DescontoIncondicionado := ObterConteudo(AuxNode.Childrens.FindAnyNs('vDescIncond'), tcDe2);
      DescontoCondicionado := ObterConteudo(AuxNode.Childrens.FindAnyNs('vDescCond'), tcDe2);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLDocDeducoes(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('documentos');

  if AuxNode <> nil then
  begin
    ANodes := AuxNode.Childrens.FindAllAnyNs('docDedRed');

    for i := 0 to Length(ANodes) - 1 do
    begin
      NFSe.Servico.Valores.DocDeducao.New;
      with NFSe.Servico.Valores.DocDeducao[i] do
      begin
        chNFSe := ObterConteudo(ANodes[i].Childrens.FindAnyNs('chNFSe'), tcStr);
        chNFe := ObterConteudo(ANodes[i].Childrens.FindAnyNs('chNFe'), tcStr);

        LerXMLNFSeMunicipio(ANodes[i].Childrens.FindAnyNs('NFSeMun'), I);
        LerXMLNFNFS(ANodes[i].Childrens.FindAnyNs('NFNFS'), I);

        nDocFisc := ObterConteudo(ANodes[i].Childrens.FindAnyNs('nDocFisc'), tcStr);
        nDoc := ObterConteudo(ANodes[i].Childrens.FindAnyNs('nDoc'), tcStr);
        tpDedRed := StrTotpDedRed(Ok, ObterConteudo(ANodes[i].Childrens.FindAnyNs('tpDedRed'), tcStr));
        xDescOutDed := ObterConteudo(ANodes[i].Childrens.FindAnyNs('xDescOutDed'), tcStr);
        dtEmiDoc := ObterConteudo(ANodes[i].Childrens.FindAnyNs('dtEmiDoc'), tcDat);
        vDedutivelRedutivel := ObterConteudo(ANodes[i].Childrens.FindAnyNs('vDedutivelRedutivel'), tcDe2);
        vDeducaoReducao := ObterConteudo(ANodes[i].Childrens.FindAnyNs('vDeducaoReducao'), tcDe2);

        LerXMLFornecedor(ANodes[i].Childrens.FindAnyNs('fornec'), I);
      end;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLDPS(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('DPS');

  if AuxNode <> nil then
    LerXMLinfDPS(AuxNode);
end;

procedure TNFSeR_PadraoNacional.LerXMLEmitente(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('emit');

  if AuxNode <> nil then
  begin
    with NFSe.infNFSe.emit do
    begin
      Identificacao.CpfCnpj := ObterCNPJCPF(AuxNode);
      Identificacao.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('IM'), tcStr);

      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('xNome'), tcStr);
      NomeFantasia := ObterConteudo(AuxNode.Childrens.FindAnyNs('xFant'), tcStr);

      LerXMLEnderecoEmitente(AuxNode);

      Contato.Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('fone'), tcStr);
      Contato.Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('email'), tcStr);
    end;

    with NFSe.Prestador do
    begin
      IdentificacaoPrestador.CpfCnpj := NFSe.infNFSe.emit.Identificacao.CpfCnpj;
      IdentificacaoPrestador.InscricaoMunicipal := NFSe.infNFSe.emit.Identificacao.InscricaoMunicipal;

      RazaoSocial := NFSe.infNFSe.emit.RazaoSocial;
      NomeFantasia := NFSe.infNFSe.emit.NomeFantasia;

      Endereco.Endereco := NFSe.infNFSe.emit.Endereco.Endereco;
      Endereco.Numero := NFSe.infNFSe.emit.Endereco.Numero;
      Endereco.Complemento := NFSe.infNFSe.emit.Endereco.Complemento;
      Endereco.Bairro := NFSe.infNFSe.emit.Endereco.Bairro;
      Endereco.UF := NFSe.infNFSe.emit.Endereco.UF;
      Endereco.CEP := NFSe.infNFSe.emit.Endereco.CEP;
      Endereco.CodigoMunicipio := NFSe.infNFSe.emit.Endereco.CodigoMunicipio;
      Endereco.xMunicipio := NFSe.infNFSe.emit.Endereco.xMunicipio;

      Contato.Telefone := NFSe.infNFSe.emit.Contato.Telefone;
      Contato.Email := NFSe.infNFSe.emit.Contato.Email;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoEmitente(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  xUF: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('enderNac');

  if AuxNode <> nil then
  begin
    with NFSe.infNFSe.emit.Endereco do
    begin
      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('xLgr'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nro'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCpl'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('xBairro'), tcStr);
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cMun'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('UF'), tcStr);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);
      xMunicipio := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);

      if UF = '' then
        UF := xUF;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoEvento(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('end');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Evento.Endereco do
    begin
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);

      LerXMLEnderecoExteriorEvento(AuxNode);

      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('xLgr'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nro'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCpl'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('xBairro'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoExteriorEvento(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('endExt');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Evento.Endereco do
    begin
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cEndPost'), tcStr);
      xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCidade'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('xEstProvReg'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoExteriorFornecedr(
  const ANode: TACBrXmlNode; Item: Integer);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('endExt');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.DocDeducao.Items[Item].fornec.Endereco do
    begin
      CodigoPais := SiglaISO2ToCodIBGEPais(ObterConteudo(AuxNode.Childrens.FindAnyNs('cPais'), tcStr));
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cEndPost'), tcStr);
      xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCidade'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('xEstProvReg'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoExteriorIntermediario(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('endExt');

  if AuxNode <> nil then
  begin
    with NFSe.Intermediario.Endereco do
    begin
      CodigoPais := SiglaISO2ToCodIBGEPais(ObterConteudo(AuxNode.Childrens.FindAnyNs('cPais'), tcStr));
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cEndPost'), tcStr);
      xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCidade'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('xEstProvReg'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoExteriorObra(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('endExt');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Endereco do
    begin
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cEndPost'), tcStr);
      xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCidade'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('xEstProvReg'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoExteriorPrestador(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('endExt');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Endereco do
    begin
      if CodigoPais = 0 then
        CodigoPais := SiglaISO2ToCodIBGEPais(ObterConteudo(AuxNode.Childrens.FindAnyNs('cPais'), tcStr));

      if CEP = '' then
        CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cEndPost'), tcStr);

      if xMunicipio = '' then
        xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCidade'), tcStr);

      if UF = '' then
        UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('xEstProvReg'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoExteriorTomador(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('endExt');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      CodigoPais := SiglaISO2ToCodIBGEPais(ObterConteudo(AuxNode.Childrens.FindAnyNs('cPais'), tcStr));
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('cEndPost'), tcStr);
      xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCidade'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('xEstProvReg'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoFornecedor(const ANode: TACBrXmlNode;
  Item: Integer);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('end');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.DocDeducao.Items[item].fornec.Endereco do
    begin
      LerXMLEnderecoNacionalFornecedor(AuxNode, Item);
      LerXMLEnderecoExteriorFornecedr(AuxNode, Item);

      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('xLgr'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nro'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCpl'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('xBairro'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoItermediario(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('end');

  if AuxNode <> nil then
  begin
    with NFSe.Intermediario.Endereco do
    begin
      LerXMLEnderecoNacionalIntermediario(AuxNode);
      LerXMLEnderecoExteriorIntermediario(AuxNode);

      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('xLgr'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nro'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCpl'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('xBairro'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoNacionalFornecedor(
  const ANode: TACBrXmlNode; Item: Integer);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('endNac');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.DocDeducao.Items[item].fornec.Endereco do
    begin
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cMun'), tcStr);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoNacionalIntermediario(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  xUF: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('endNac');

  if AuxNode <> nil then
  begin
    with NFSe.Intermediario.Endereco do
    begin
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cMun'), tcStr);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);
      xMunicipio := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);

      if UF = '' then
        UF := xUF;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoNacionalPrestador(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  xUF: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('endNac');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Endereco do
    begin
      if CodigoMunicipio = '' then
        CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cMun'), tcStr);

      if CEP = '' then
        CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);

      xMunicipio := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);

      if UF = '' then
        UF := xUF;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoNacionalTomador(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  xUF: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('endNac');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cMun'), tcStr);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);
      xMunicipio := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);

      if UF = '' then
        UF := xUF;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoObra(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('end');

  if AuxNode <> nil then
  begin
    with NFSe.ConstrucaoCivil.Endereco do
    begin
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);

      LerXMLEnderecoExteriorObra(AuxNode);

      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('xLgr'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nro'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCpl'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('xBairro'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('end');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Endereco do
    begin
      LerXMLEnderecoNacionalPrestador(AuxNode);
      LerXMLEnderecoExteriorPrestador(AuxNode);

      if Endereco = '' then
        Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('xLgr'), tcStr);

      if Numero = '' then
        Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nro'), tcStr);

      if Complemento = '' then
        Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCpl'), tcStr);

      if Bairro = '' then
        Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('xBairro'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLEnderecoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('end');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      LerXMLEnderecoNacionalTomador(AuxNode);
      LerXMLEnderecoExteriorTomador(AuxNode);

      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('xLgr'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nro'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('xCpl'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('xBairro'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLExigibilidadeSuspensa(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('exigSusp');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.tribMun do
    begin
      tpSusp := StrTotpSusp(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('tpSusp'), tcStr));
      nProcesso := ObterConteudo(AuxNode.Childrens.FindAnyNs('nProcesso'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLExploracaoRodoviaria(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('explRod');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.explRod do
    begin
      categVeic := StrTocategVeic(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('categVeic'), tcStr));
      nEixos := ObterConteudo(AuxNode.Childrens.FindAnyNs('nEixos'), tcInt);
      rodagem := ObterConteudo(AuxNode.Childrens.FindAnyNs('rodagem'), tcStr);
      sentido := ObterConteudo(AuxNode.Childrens.FindAnyNs('sentido'), tcStr);
      placa := ObterConteudo(AuxNode.Childrens.FindAnyNs('placa'), tcStr);
      codAcessoPed := ObterConteudo(AuxNode.Childrens.FindAnyNs('codAcessoPed'), tcStr);
      codContrato := ObterConteudo(AuxNode.Childrens.FindAnyNs('codContrato'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLFornecedor(const ANode: TACBrXmlNode;
  Item: Integer);
var
  Ok: Boolean;
begin
  if ANode <> nil then
  begin
    with NFSe.Servico.Valores.DocDeducao.Items[item].fornec do
    begin
      Identificacao.CpfCnpj := ObterCNPJCPF(ANode);

      if Identificacao.CpfCnpj = '' then
        Identificacao.Nif := ObterConteudo(ANode.Childrens.FindAnyNs('NIF'), tcStr);

      if Identificacao.Nif = '' then
        Identificacao.cNaoNIF := StrToNaoNIF(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('cNaoNIF'), tcStr));

      Identificacao.CAEPF := ObterConteudo(ANode.Childrens.FindAnyNs('CAEPF'), tcStr);
      Identificacao.InscricaoMunicipal := ObterConteudo(ANode.Childrens.FindAnyNs('IM'), tcStr);

      RazaoSocial := ObterConteudo(ANode.Childrens.FindAnyNs('xNome'), tcStr);

      LerXMLEnderecoFornecedor(ANode, Item);

      Contato.Telefone := ObterConteudo(ANode.Childrens.FindAnyNs('fone'), tcStr);
      Contato.Email := ObterConteudo(ANode.Childrens.FindAnyNs('email'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLinfDPS(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('infDPS');

  if AuxNode <> nil then
  begin
    NFSe.infID.ID := OnlyNumber(ObterConteudoTag(AuxNode.Attributes.Items['Id']));
    NFSe.DataEmissao := ObterConteudo(AuxNode.Childrens.FindAnyNs('dhEmi'), tcDatHor);
    NFSe.verAplic := ObterConteudo(AuxNode.Childrens.FindAnyNs('verAplic'), tcStr);
    NFSe.IdentificacaoRps.Serie := ObterConteudo(AuxNode.Childrens.FindAnyNs('serie'), tcStr);
    NFSe.IdentificacaoRps.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nDPS'), tcStr);
    NFSe.Competencia := ObterConteudo(AuxNode.Childrens.FindAnyNs('dCompet'), tcDat);
    NFSe.tpEmit := StrTotpEmit(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('tpEmit'), tcStr));
    NFSe.cMotivoEmisTI := StrTocMotivoEmisTI(ObterConteudo(AuxNode.Childrens.FindAnyNs('cMotivoEmisTI'), tcStr));
    NFSe.cLocEmi := ObterConteudo(AuxNode.Childrens.FindAnyNs('cLocEmi'), tcStr);

    LerXMLSubstituicao(AuxNode);
    LerXMLPrestador(AuxNode);
    LerXMLTomador(AuxNode);
    LerXMLIntermediario(AuxNode);
    LerXMLServico(AuxNode);
    LerXMLValores(AuxNode);

    // Reforma Tributária
    LerXMLIBSCBSDPS(AuxNode.Childrens.FindAnyNs('IBSCBS'), NFSe.IBSCBS);
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLinfNFSe(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('infNFSe');

  if AuxNode <> nil then
  begin
    {
    A formação do identificador de 53 posições da NFS é:

    "NFS" +
    Cód.Mun. (7) +
    Amb.Ger. (1) +
    Tipo de Inscrição Federal (1) +
    Inscrição Federal (14 - CPF completar com 000 à esquerda) +
    nNFSe (13) +
    AnoMes Emis. da DPS (4) +
    Cód.Num. (9) +
    DV (1)

    Código numérico de 9 Posições numérico, aleatório,
    gerado automaticamente pelo sistema gerador da NFS-e.
    }

    NFSe.infNFSe.ID := OnlyNumber(ObterConteudoTag(AuxNode.Attributes.Items['Id']));
    NFSe.infNFSe.xLocEmi := ObterConteudo(AuxNode.Childrens.FindAnyNs('xLocEmi'), tcStr);
    NFSe.infNFSe.xLocPrestacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('xLocPrestacao'), tcStr);
    NFSe.infNFSe.nNFSe := ObterConteudo(AuxNode.Childrens.FindAnyNs('nNFSe'), tcStr);
    NFSe.infNFSe.cLocIncid := ObterConteudo(AuxNode.Childrens.FindAnyNs('cLocIncid'), tcInt);
    NFSe.infNFSe.xLocIncid := ObterConteudo(AuxNode.Childrens.FindAnyNs('xLocIncid'), tcStr);
    NFSe.infNFSe.xTribNac := ObterConteudo(AuxNode.Childrens.FindAnyNs('xTribNac'), tcStr);
    NFSe.infNFSe.xTribMun := ObterConteudo(AuxNode.Childrens.FindAnyNs('xTribMun'), tcStr);
    NFSe.infNFSe.xNBS := ObterConteudo(AuxNode.Childrens.FindAnyNs('xNBS'), tcStr);
    NFSe.infNFSe.verAplic := ObterConteudo(AuxNode.Childrens.FindAnyNs('verAplic'), tcStr);
    NFSe.infNFSe.ambGer := StrToambGer(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('ambGer'), tcStr));
    NFSe.infNFSe.tpEmis := StrTotpEmis(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('tpEmis'), tcStr));
    NFSe.infNFSe.procEmi := StrToprocEmis(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('procEmi'), tcStr));
    NFSe.infNFSe.cStat := ObterConteudo(AuxNode.Childrens.FindAnyNs('cStat'), tcInt);
    NFSe.infNFSe.dhProc := ObterConteudo(AuxNode.Childrens.FindAnyNs('dhProc'), tcDatHor);
    NFSe.infNFSe.nDFSe := ObterConteudo(AuxNode.Childrens.FindAnyNs('nDFSe'), tcStr);

    NFSe.Servico.MunicipioIncidencia := NFSe.infNFSe.cLocIncid;
    NFSe.Servico.xMunicipioIncidencia := NFSe.infNFSe.xLocIncid;

    LerXMLEmitente(AuxNode);
    LerXMLValoresNFSe(AuxNode);
    LerXMLDPS(AuxNode);

    NFSe.Numero := NFSe.infNFSe.nNFSe;
    NFSe.CodigoVerificacao := NFSe.infNFSe.ID;

    with NFSe.Servico.Valores do
    begin
      BaseCalculo := ValorServicos - ValorDeducoes - DescontoIncondicionado;

      if tribFed.tpRetPisCofins = trpcNaoRetido then
         RetencoesFederais := ValorInss + ValorIr + ValorCsll
      else
         RetencoesFederais := ValorPis + ValorCofins + ValorInss + ValorIr + ValorCsll;

      ValorLiquidoNfse := ValorServicos - RetencoesFederais - OutrasRetencoes -
                 ValorIssRetido - DescontoIncondicionado - DescontoCondicionado;

      ValorTotalNotaFiscal := ValorServicos - DescontoCondicionado -
                              DescontoIncondicionado;
    end;

    // Reforma Tributária
    LerXMLIBSCBSNFSe(AuxNode.Childrens.FindAnyNs('IBSCBS'), NFSe.infNFSe.IBSCBS);
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLInformacoesComplementares(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('infoCompl');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.infoCompl do
    begin
      idDocTec := ObterConteudo(AuxNode.Childrens.FindAnyNs('idDocTec'), tcStr);
      docRef := ObterConteudo(AuxNode.Childrens.FindAnyNs('docRef'), tcStr);
      xInfComp := ObterConteudo(AuxNode.Childrens.FindAnyNs('xInfComp'), tcStr);
      xInfComp := StringReplace(xInfComp, FpQuebradeLinha,
                                                    sLineBreak, [rfReplaceAll]);

      NFSe.OutrasInformacoes := NFSe.OutrasInformacoes + sLineBreak + xInfComp;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLIntermediario(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('interm');

  if AuxNode <> nil then
  begin
    with NFSe.Intermediario do
    begin
      Identificacao.CpfCnpj := ObterCNPJCPF(AuxNode);

      if Identificacao.CpfCnpj = '' then
        Identificacao.Nif := ObterConteudo(AuxNode.Childrens.FindAnyNs('NIF'), tcStr);

      if Identificacao.Nif = '' then
        Identificacao.cNaoNIF := StrToNaoNIF(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('cNaoNIF'), tcStr));

      Identificacao.CAEPF := ObterConteudo(AuxNode.Childrens.FindAnyNs('CAEPF'), tcStr);
      Identificacao.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('IM'), tcStr);

      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('xNome'), tcStr);

      LerXMLEnderecoItermediario(AuxNode);

      Contato.Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('fone'), tcStr);
      Contato.Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('email'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLLocacaoSubLocacao(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('lsadppu');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Locacao do
    begin
      categ := StrTocateg(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('categ'), tcStr));
      objeto := StrToobjeto(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('objeto'), tcStr));
      extensao := ObterConteudo(AuxNode.Childrens.FindAnyNs('extensao'), tcStr);
      nPostes := ObterConteudo(AuxNode.Childrens.FindAnyNs('nPostes'), tcInt);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLLocalPrestacao(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  xUF: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('locPrest');

  if AuxNode <> nil then
  begin
    with NFSe.Servico do
    begin
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('cLocPrestacao'), tcStr);
      CodigoPais := SiglaISO2ToCodIBGEPais(ObterConteudo(AuxNode.Childrens.FindAnyNs('cPaisPrestacao'), tcStr));

      MunicipioPrestacaoServico := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);
      MunicipioPrestacaoServico := MunicipioPrestacaoServico + '/' + xUF;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLNFNFS(const ANode: TACBrXmlNode;
  Item: Integer);
begin
  if ANode <> nil then
  begin
    with NFSe.Servico.Valores.DocDeducao.Items[item].NFNFS do
    begin
      nNFS := ObterConteudo(ANode.Childrens.FindAnyNs('nNFS'), tcStr);
      modNFS := ObterConteudo(ANode.Childrens.FindAnyNs('modNFS'), tcStr);
      serieNFS := ObterConteudo(ANode.Childrens.FindAnyNs('serieNFS'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLNFSeMunicipio(
  const ANode: TACBrXmlNode; Item: Integer);
begin
  if ANode <> nil then
  begin
    with NFSe.Servico.Valores.DocDeducao.Items[item].NFSeMun do
    begin
      cMunNFSeMun := ObterConteudo(ANode.Childrens.FindAnyNs('cMunNFSeMun'), tcStr);
      nNFSeMun := ObterConteudo(ANode.Childrens.FindAnyNs('nNFSeMun'), tcStr);
      cVerifNFSeMun := ObterConteudo(ANode.Childrens.FindAnyNs('cVerifNFSeMun'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLObra(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('obra');

  if AuxNode <> nil then
  begin
    with NFSe.ConstrucaoCivil do
    begin
      CodigoObra := ObterConteudo(AuxNode.Childrens.FindAnyNs('cObra'), tcStr);
      inscImobFisc := ObterConteudo(AuxNode.Childrens.FindAnyNs('inscImobFisc'), tcStr);

      LerXMLEnderecoObra(AuxNode);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLPercentualTotalTributos(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('pTotTrib');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.totTrib do
    begin
      pTotTribFed := ObterConteudo(AuxNode.Childrens.FindAnyNs('pTotTribFed'), tcDe2);
      pTotTribEst := ObterConteudo(AuxNode.Childrens.FindAnyNs('pTotTribEst'), tcDe2);
      pTotTribMun := ObterConteudo(AuxNode.Childrens.FindAnyNs('pTotTribMun'), tcDe2);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('prest');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador do
    begin
      if IdentificacaoPrestador.CpfCnpj = '' then
        IdentificacaoPrestador.CpfCnpj := ObterCNPJCPF(AuxNode);

      if IdentificacaoPrestador.CpfCnpj = '' then
        IdentificacaoPrestador.Nif := ObterConteudo(AuxNode.Childrens.FindAnyNs('NIF'), tcStr);

      if IdentificacaoPrestador.Nif = '' then
        IdentificacaoPrestador.cNaoNIF := StrToNaoNIF(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('cNaoNIF'), tcStr));

      IdentificacaoPrestador.CAEPF := ObterConteudo(AuxNode.Childrens.FindAnyNs('CAEPF'), tcStr);

      if IdentificacaoPrestador.InscricaoMunicipal = '' then
        IdentificacaoPrestador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('IM'), tcStr);

      if RazaoSocial = '' then
        RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('xNome'), tcStr);

      LerXMLEnderecoPrestador(AuxNode);

      if Contato.Telefone = '' then
        Contato.Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('fone'), tcStr);

      if Contato.Email = '' then
      Contato.Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('email'), tcStr);

      LerXMLRegimeTributacaoPrestador(AuxNode);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLRegimeTributacaoPrestador(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('regTrib');

  if AuxNode <> nil then
  begin
    NFSe.OptanteSN := StrToOptanteSN(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('opSimpNac'), tcStr));
    NFSe.RegimeApuracaoSN := StrToRegimeApuracaoSN(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('regApTribSN'), tcStr));
    NFSe.RegimeEspecialTributacao := FpAOwner.StrToRegimeEspecialTributacao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('regEspTrib'), tcStr));
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('serv');

  if AuxNode <> nil then
  begin
    LerXMLLocalPrestacao(AuxNode);
    LerXMLCodigoServico(AuxNode);
    LerXMLComercioExterior(AuxNode);
    LerXMLLocacaoSubLocacao(AuxNode);
    LerXMLObra(AuxNode);
    LerXMLAtividadeEvento(AuxNode);
    LerXMLExploracaoRodoviaria(AuxNode);
    LerXMLInformacoesComplementares(AuxNode);
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLServicoPrestado(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('vServPrest');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores do
    begin
      ValorRecebido := ObterConteudo(AuxNode.Childrens.FindAnyNs('vReceb'), tcDe2);
      ValorServicos := ObterConteudo(AuxNode.Childrens.FindAnyNs('vServ'), tcDe2);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLSubstituicao(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('subst');

  if AuxNode <> nil then
  begin
      {
      A formação da chSubstda de 50 posições da NFS é:

      Cód.Mun. (7) +
      Amb.Ger. (1) +
      Tipo de Inscrição Federal (1) +
      Inscrição Federal (14 - CPF completar com 000 à esquerda) +
      nNFSe (13) +
      AnoMes Emis. da DPS (4) +
      Cód.Num. (9) +
      DV (1)

      Código numérico de 9 Posições numérico, aleatório,
      gerado automaticamente pelo sistema gerador da NFS-e.
      }
    NFSe.subst.chSubstda := ObterConteudo(AuxNode.Childrens.FindAnyNs('chSubstda'), tcStr);
    NFSe.subst.cMotivo := StrTocMotivo(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('cMotivo'), tcStr));
    NFSe.subst.xMotivo := ObterConteudo(AuxNode.Childrens.FindAnyNs('xMotivo'), tcStr);

    NFSe.NfseSubstituida := Copy(NFSe.subst.chSubstda, 24, 13);
    NFSe.OutrasInformacoes := NFSe.OutrasInformacoes + sLineBreak +
      'Chave da NFSe Substituida: ' + NFSe.subst.chSubstda;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('toma');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador do
    begin
      IdentificacaoTomador.CpfCnpj := ObterCNPJCPF(AuxNode);

      if IdentificacaoTomador.CpfCnpj = '' then
        IdentificacaoTomador.Nif := ObterConteudo(AuxNode.Childrens.FindAnyNs('NIF'), tcStr);

      if IdentificacaoTomador.Nif = '' then
        IdentificacaoTomador.cNaoNIF := StrToNaoNIF(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('cNaoNIF'), tcStr));

      IdentificacaoTomador.CAEPF := ObterConteudo(AuxNode.Childrens.FindAnyNs('CAEPF'), tcStr);
      IdentificacaoTomador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('IM'), tcStr);

      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('xNome'), tcStr);

      LerXMLEnderecoTomador(AuxNode);

      Contato.Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('fone'), tcStr);
      Contato.Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('email'), tcStr);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLTotalTributos(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('totTrib');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.totTrib do
    begin
      LerXMLValorTotalTributos(AuxNode);
      LerXMLPercentualTotalTributos(AuxNode);

      indTotTrib := StrToindTotTrib(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('indTotTrib'), tcStr));
      pTotTribSN := ObterConteudo(AuxNode.Childrens.FindAnyNs('pTotTribSN'), tcDe2);
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLTributacao(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('trib');

  if AuxNode <> nil then
  begin
    LerXMLTributacaoMunicipal(AuxNode);
    LerXMLTributacaoFederal(AuxNode);
    LerXMLTotalTributos(AuxNode);
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLTributacaoMunicipal(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('tribMun');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.tribMun do
    begin
      tribISSQN := StrTotribISSQN(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('tribISSQN'), tcStr));
      cPaisResult := SiglaISO2ToCodIBGEPais(ObterConteudo(AuxNode.Childrens.FindAnyNs('cPaisResult'), tcStr));

      LerXMLBeneficioMunicipal(AuxNode);
      LerXMLExigibilidadeSuspensa(AuxNode);

      tpImunidade := StrTotpImunidade(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('tpImunidade'), tcStr));
      tpRetISSQN := StrTotpRetISSQN(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('tpRetISSQN'), tcStr));
      pAliq := ObterConteudo(AuxNode.Childrens.FindAnyNs('pAliq'), tcDe2);

      if tpRetISSQN = trNaoRetido then
      begin
        NFSe.Servico.Valores.IssRetido := stNormal;
        NFSe.Servico.Valores.ValorIssRetido := 0;
      end
      else
      begin
        NFSe.Servico.Valores.IssRetido := stRetencao;
        NFSe.Servico.Valores.ValorIssRetido := NFSe.infNFSe.valores.ValorIss;
      end;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLTributacaoFederal(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('tribFed');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.tribFed do
    begin
      LerXMLTributacaoOutrosPisCofins(AuxNode);

      vRetCP := ObterConteudo(AuxNode.Childrens.FindAnyNs('vRetCP'), tcDe2);
      vRetIRRF := ObterConteudo(AuxNode.Childrens.FindAnyNs('vRetIRRF'), tcDe2);
      vRetCSLL := ObterConteudo(AuxNode.Childrens.FindAnyNs('vRetCSLL'), tcDe2);

      NFSe.Servico.Valores.ValorIr := vRetIRRF;
      NFSe.Servico.Valores.ValorCsll := vRetCSLL;
      NFSe.Servico.Valores.ValorInss := vRetCP;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLTributacaoOutrosPisCofins(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('piscofins');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.tribFed do
    begin
      CST := StrToCST(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('CST'), tcStr));
      vBCPisCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('vBCPisCofins'), tcDe2);
      pAliqPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('pAliqPis'), tcDe2);
      pAliqCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('pAliqCofins'), tcDe2);
      vPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('vPis'), tcDe2);
      vCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('vCofins'), tcDe2);
      tpRetPisCofins := StrTotpRetPisCofins(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('tpRetPisCofins'), tcStr));

      NFSe.Servico.Valores.ValorPis := vPis;
      NFSe.Servico.Valores.ValorCofins := vCofins;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLValores(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('valores');

  if AuxNode <> nil then
  begin
    LerXMLServicoPrestado(AuxNode);
    LerXMLDescontos(AuxNode);
    LerXMLDeducoes(AuxNode);
    LerXMLTributacao(AuxNode);
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLValoresNFSe(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('valores');

  if AuxNode <> nil then
  begin
    with NFSe.infNFSe.valores do
    begin
      vCalcDR := ObterConteudo(AuxNode.Childrens.FindAnyNs('vCalcDR'), tcDe2);
      tpBM := ObterConteudo(AuxNode.Childrens.FindAnyNs('tpBM'), tcStr);
      vCalcBM := ObterConteudo(AuxNode.Childrens.FindAnyNs('vCalcBM'), tcDe2);
      BaseCalculo := ObterConteudo(AuxNode.Childrens.FindAnyNs('vBC'), tcDe2);
      Aliquota := ObterConteudo(AuxNode.Childrens.FindAnyNs('pAliqAplic'), tcDe2);
      ValorIss := ObterConteudo(AuxNode.Childrens.FindAnyNs('vISSQN'), tcDe2);
      vTotalRet := ObterConteudo(AuxNode.Childrens.FindAnyNs('vTotalRet'), tcDe2);
      ValorLiquidoNfse := ObterConteudo(AuxNode.Childrens.FindAnyNs('vLiq'), tcDe2);
    end;

    NFSe.OutrasInformacoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('xOutInf'), tcStr);
    NFSe.OutrasInformacoes := StringReplace(NFSe.OutrasInformacoes, FpQuebradeLinha,
                                                    sLineBreak, [rfReplaceAll]);
    NFSe.Servico.Valores.Aliquota := NFSe.infNFSe.valores.Aliquota;
    NFSe.Servico.Valores.ValorIss := NFSe.infNFSe.valores.ValorIss;
  end;
end;

procedure TNFSeR_PadraoNacional.LerXMLValorTotalTributos(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('vTotTrib');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores.totTrib do
    begin
      vTotTribFed := ObterConteudo(AuxNode.Childrens.FindAnyNs('vTotTribFed'), tcDe2);
      vTotTribEst := ObterConteudo(AuxNode.Childrens.FindAnyNs('vTotTribEst'), tcDe2);
      vTotTribMun := ObterConteudo(AuxNode.Childrens.FindAnyNs('vTotTribMun'), tcDe2);
    end;
  end;
end;

function TNFSeR_PadraoNacional.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
begin
  FpQuebradeLinha := FpAOwner.ConfigGeral.QuebradeLinha;

  if EstaVazio(Arquivo) then
    raise Exception.Create('Arquivo xml não carregado.');

  LerParamsTabIni(True);

  Arquivo := NormatizarXml(Arquivo);

  Arquivo := RemoverCaracteresDesnecessarios(Arquivo);

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(Arquivo);

  // Não remover o espaço em branco, caso contrario vai encontrar tags que tem
  // NFSe em sua grafia.
  if (Pos('NFSe ', Arquivo) > 0) then
    tpXML := txmlNFSe
  else
    tpXML := txmlRPS;

  XmlNode := Document.Root;

  if XmlNode = nil then
    raise Exception.Create('Arquivo xml vazio.');

  NFSe.tpXML := tpXml;

  if tpXML = txmlNFSe then
    Result := LerXmlNfse(XmlNode)
  else
    Result := LerXmlRps(XmlNode);

  FreeAndNil(FDocument);
end;

function TNFSeR_PadraoNacional.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
begin
  Result := True;

  if not Assigned(ANode) then Exit;

  LerXMLinfNFSe(ANode);

  LerCampoLink;
end;

function TNFSeR_PadraoNacional.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
begin
  Result := True;

  if not Assigned(ANode) then Exit;

  LerXMLinfDPS(ANode);
end;

function TNFSeR_PadraoNacional.LerIni: Boolean;
var
  INIRec: TMemIniFile;
begin
  INIRec := TMemIniFile.Create('');

  // Usar o FpAOwner em vez de  FProvider

  try
    LerIniArquivoOuString(Arquivo, INIRec);

    FpTipoXML := INIRec.ReadString('IdentificacaoNFSe', 'TipoXML', '');

    if FpTipoXML = 'NFSE' then
      LerIniNfse(INIRec)
    else
      LerIniRps(INIRec);

  finally
    INIRec.Free;
  end;

  Result := True;
end;

procedure TNFSeR_PadraoNacional.LerIniRps(AINIRec: TMemIniFile);
begin
  NFSe.tpXML := txmlRPS;

  LerINIIdentificacaoNFSe(AINIRec);
  LerINIIdentificacaoRps(AINIRec);
  LerININFSeSubstituicao(AINIRec);
  LerINIDadosPrestador(AINIRec);
  LerINIDadosTomador(AINIRec);
  LerINIDadosIntermediario(AINIRec);
  LerINIDadosServico(AINIRec);
  LerINIComercioExterior(AINIRec);
  LerINILocacaoSubLocacao(AINIRec);
  LerINIConstrucaoCivil(AINIRec);
  LerINIEvento(AINIRec);
  LerINIRodoviaria(AINIRec);
  LerINIInformacoesComplementares(AINIRec);
  LerINIValores(AINIRec);
  LerINIDocumentosDeducoes(AINIRec);
  LerINIValoresTribMun(AINIRec);
  LerINIValoresTribFederal(AINIRec);
  LerINIValoresTotalTrib(AINIRec);

  // Reforma Tributária
  LerINIIBSCBS(AINIRec, NFSe.IBSCBS);
end;

procedure TNFSeR_PadraoNacional.LerIniNfse(AINIRec: TMemIniFile);
begin
  NFSe.tpXML := txmlNFSe;

  LerINIIdentificacaoNFSe(AINIRec);
  LerINIDadosEmitente(AINIRec);
  LerINIValoresNFSe(AINIRec);
  // Informações sobre o DPS
  LerINIIdentificacaoRps(AINIRec);
  LerININFSeSubstituicao(AINIRec);
  LerINIDadosPrestador(AINIRec);
  LerINIDadosTomador(AINIRec);
  LerINIDadosIntermediario(AINIRec);
  LerINIDadosServico(AINIRec);
  LerINIComercioExterior(AINIRec);
  LerINILocacaoSubLocacao(AINIRec);
  LerINIConstrucaoCivil(AINIRec);
  LerINIEvento(AINIRec);
  LerINIRodoviaria(AINIRec);
  LerINIInformacoesComplementares(AINIRec);
  LerINIValores(AINIRec);
  LerINIDocumentosDeducoes(AINIRec);
  LerINIValoresTribMun(AINIRec);
  LerINIValoresTribFederal(AINIRec);
  LerINIValoresTotalTrib(AINIRec);
  LerINIValoresTotalTrib(AINIRec);

  // Reforma Tributária
  LerINIIBSCBS(AINIRec, NFSe.IBSCBS);

  LerINIIBSCBSNFSe(AINIRec, NFSe.infNFSe.IBSCBS);

  with NFSe.Servico.Valores do
  begin
    BaseCalculo := ValorServicos - ValorDeducoes - DescontoIncondicionado;

    if tribFed.tpRetPisCofins = trpcNaoRetido then
       RetencoesFederais := ValorInss + ValorIr + ValorCsll
    else
       RetencoesFederais := ValorPis + ValorCofins + ValorInss + ValorIr + ValorCsll;

    ValorLiquidoNfse := ValorServicos - RetencoesFederais - OutrasRetencoes -
               ValorIssRetido - DescontoIncondicionado - DescontoCondicionado;

    ValorTotalNotaFiscal := ValorServicos - DescontoCondicionado -
                            DescontoIncondicionado;
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIIdentificacaoNFSe(AINIRec: TMemIniFile);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'IdentificacaoNFSe';
  if AINIRec.SectionExists(sSecao) then
  begin
    if NFSe.tpXML = txmlNFSe then
    begin
      NFSe.infNFSe.ID := AINIRec.ReadString(sSecao, 'Id', '');
      NFSe.infNFSe.xLocEmi := AINIRec.ReadString(sSecao, 'xLocEmi', '');
      NFSe.infNFSe.xLocPrestacao := AINIRec.ReadString(sSecao, 'xLocPrestacao', '');
      NFSe.infNFSe.nNFSe := AINIRec.ReadString(sSecao, 'nNFSe', '');
      NFSe.infNFSe.cLocIncid := AINIRec.ReadInteger(sSecao, 'cLocIncid', 0);
      NFSe.infNFSe.xLocIncid := AINIRec.ReadString(sSecao, 'xLocIncid', '');
      NFSe.infNFSe.xTribNac := AINIRec.ReadString(sSecao, 'xTribNac', '');
      NFSe.infNFSe.xTribMun := AINIRec.ReadString(sSecao, 'xTribMun', '');
      NFSe.infNFSe.xNBS := AINIRec.ReadString(sSecao, 'xNBS', '');
      NFSe.infNFSe.verAplic := AINIRec.ReadString(sSecao, 'verAplic', '');
      NFSe.infNFSe.ambGer := StrToambGer(Ok, AINIRec.ReadString(sSecao, 'ambGer', ''));
      NFSe.infNFSe.tpEmis := StrTotpEmis(Ok, AINIRec.ReadString(sSecao, 'tpEmis', ''));
      NFSe.infNFSe.procEmi := StrToprocEmis(Ok, AINIRec.ReadString(sSecao, 'procEmi', ''));
      NFSe.infNFSe.cStat := AINIRec.ReadInteger(sSecao, 'cStat', 0);
      NFSe.infNFSe.dhProc := StringToDateTimeDef(AINIRec.ReadString(sSecao, 'dhProc', ''), 0);
      NFSe.infNFSe.nDFSe := AINIRec.ReadString(sSecao, 'nDFSe', '');
      NFSe.Servico.MunicipioIncidencia := NFSe.infNFSe.cLocIncid;
      NFSe.Servico.xMunicipioIncidencia := NFSe.infNFSe.xLocIncid;
      NFSe.Numero := NFSe.infNFSe.nNFSe;
      NFSe.CodigoVerificacao := NFSe.infNFSe.ID;
    end;
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIIdentificacaoRps(AINIRec: TMemIniFile);
var
  sSecao, sData: string;
  Ok: Boolean;
begin
  sSecao := 'IdentificacaoRps';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.IdentificacaoRps.Numero := AINIRec.ReadString(sSecao, 'Numero', '0');
    NFSe.IdentificacaoRps.Serie := AINIRec.ReadString(sSecao, 'Serie', '0');

    sData := AINIRec.ReadString(sSecao, 'DataEmissao', '');
    if sData <> '' then
      NFSe.DataEmissao := StringToDateTimeDef(sData, 0);

    sData := AINIRec.ReadString(sSecao, 'Competencia', '');
    if sData <> '' then
      NFSe.Competencia := StringToDateTimeDef(sData, 0);

    NFSe.verAplic := AINIRec.ReadString(sSecao, 'verAplic', 'ACBrNFSeX-1.00');
    NFSe.tpEmit := StrTotpEmit(Ok, AINIRec.ReadString(sSecao, 'tpEmit', '1'));
    NFSe.cMotivoEmisTI := StrTocMotivoEmisTI(AINIRec.ReadString(sSecao, 'cMotivoEmisTI', ''));
  end;
end;

procedure TNFSeR_PadraoNacional.LerININFSeSubstituicao(AINIRec: TMemIniFile);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'NFSeSubstituicao';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.subst.chSubstda := AINIRec.ReadString(sSecao, 'chSubstda', '');
    NFSe.subst.cMotivo := StrTocMotivo(Ok, AINIRec.ReadString(sSecao, 'cMotivo', ''));
    NFSe.subst.xMotivo := AINIRec.ReadString(sSecao, 'xMotivo', '');
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIDadosEmitente(AINIRec: TMemIniFile);
var
  sSecao: string;
  xUF: string;
begin
  sSecao := 'Emitente';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.infNFSe.emit.Identificacao.CpfCnpj := AINIRec.ReadString(sSecao, 'CNPJ', '');
    NFSe.infNFSe.emit.Identificacao.InscricaoMunicipal := AINIRec.ReadString(sSecao, 'InscricaoMunicipal', '');

    NFSe.infNFSe.emit.RazaoSocial := AINIRec.ReadString(sSecao, 'RazaoSocial', '');
    NFSe.infNFSe.emit.NomeFantasia := AINIRec.ReadString(sSecao, 'NomeFantasia', '');

    NFSe.infNFSe.emit.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
    NFSe.infNFSe.emit.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
    NFSe.infNFSe.emit.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
    NFSe.infNFSe.emit.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');
    NFSe.infNFSe.emit.Endereco.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
    NFSe.infNFSe.emit.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
    NFSe.infNFSe.emit.Endereco.xMunicipio := ObterNomeMunicipioUF(StrToIntDef(NFSe.infNFSe.emit.Endereco.CodigoMunicipio, 0), xUF);
    NFSe.infNFSe.emit.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');

    NFSe.infNFSe.emit.Contato.Telefone := AINIRec.ReadString(sSecao, 'Telefone', '');
    NFSe.infNFSe.emit.Contato.Email := AINIRec.ReadString(sSecao, 'Email', '');

    NFSe.Prestador.IdentificacaoPrestador.CpfCnpj := NFSe.infNFSe.emit.Identificacao.CpfCnpj;
    NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal := NFSe.infNFSe.emit.Identificacao.InscricaoMunicipal;

    NFSe.Prestador.RazaoSocial := NFSe.infNFSe.emit.RazaoSocial;
    NFSe.Prestador.NomeFantasia := NFSe.infNFSe.emit.NomeFantasia;

    NFSe.Prestador.Endereco.Endereco := NFSe.infNFSe.emit.Endereco.Endereco;
    NFSe.Prestador.Endereco.Numero := NFSe.infNFSe.emit.Endereco.Numero;
    NFSe.Prestador.Endereco.Complemento := NFSe.infNFSe.emit.Endereco.Complemento;
    NFSe.Prestador.Endereco.Bairro := NFSe.infNFSe.emit.Endereco.Bairro;
    NFSe.Prestador.Endereco.UF := NFSe.infNFSe.emit.Endereco.UF;
    NFSe.Prestador.Endereco.CEP := NFSe.infNFSe.emit.Endereco.CEP;
    NFSe.Prestador.Endereco.CodigoMunicipio := NFSe.infNFSe.emit.Endereco.CodigoMunicipio;
    NFSe.Prestador.Endereco.xMunicipio := NFSe.infNFSe.emit.Endereco.xMunicipio;

    NFSe.Prestador.Contato.Telefone := NFSe.infNFSe.emit.Contato.Telefone;
    NFSe.Prestador.Contato.Email := NFSe.infNFSe.emit.Contato.Email;
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIValoresNFSe(AINIRec: TMemIniFile);
var
  sSecao: string;
begin
  sSecao := 'ValoresNFSe';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.infNFSe.valores.vCalcDR := StringToFloatDef(AINIRec.ReadString(sSecao, 'vCalcDR', ''), 0);
    NFSe.infNFSe.valores.tpBM := AINIRec.ReadString(sSecao, 'tpBM', '');
    NFSe.infNFSe.valores.vCalcBM := StringToFloatDef(AINIRec.ReadString(sSecao, 'vCalcBM', ''), 0);
    NFSe.infNFSe.valores.BaseCalculo := StringToFloatDef(AINIRec.ReadString(sSecao, 'vBC', ''), 0);
    NFSe.infNFSe.valores.Aliquota := StringToFloatDef(AINIRec.ReadString(sSecao, 'pAliqAplic', ''), 0);
    NFSe.infNFSe.valores.ValorIss := StringToFloatDef(AINIRec.ReadString(sSecao, 'vISSQN', ''), 0);
    NFSe.infNFSe.valores.vTotalRet := StringToFloatDef(AINIRec.ReadString(sSecao, 'vTotalRet', ''), 0);
    NFSe.infNFSe.valores.ValorLiquidoNfse := StringToFloatDef(AINIRec.ReadString(sSecao, 'vLiq', ''), 0);
    NFSe.OutrasInformacoes := AINIRec.ReadString(sSecao, 'xOutInf', '');

    NFSe.Servico.Valores.Aliquota := NFSe.infNFSe.valores.Aliquota;
    NFSe.Servico.Valores.ValorIss := NFSe.infNFSe.valores.ValorIss;
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIDadosPrestador(AINIRec: TMemIniFile);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'Prestador';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Prestador.IdentificacaoPrestador.CpfCnpj := AINIRec.ReadString(sSecao, 'CNPJ', '');
    NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal := AINIRec.ReadString(sSecao, 'InscricaoMunicipal', '');

    NFSe.Prestador.IdentificacaoPrestador.Nif := AINIRec.ReadString(sSecao, 'NIF', '');
    NFSe.Prestador.IdentificacaoPrestador.cNaoNIF := StrToNaoNIF(Ok, AINIRec.ReadString(sSecao, 'cNaoNIF', '0'));
    NFSe.Prestador.IdentificacaoPrestador.CAEPF := AINIRec.ReadString(sSecao, 'CAEPF', '');

    NFSe.Prestador.RazaoSocial := AINIRec.ReadString(sSecao, 'RazaoSocial', '');

    NFSe.Prestador.Endereco.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
    NFSe.Prestador.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
    NFSe.Prestador.Endereco.CodigoPais := AINIRec.ReadInteger(sSecao, 'CodigoPais', 0);
    NFSe.Prestador.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
    NFSe.Prestador.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');
    NFSe.Prestador.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
    NFSe.Prestador.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
    NFSe.Prestador.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
    NFSe.Prestador.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');

    NFSe.Prestador.Contato.Telefone := AINIRec.ReadString(sSecao, 'Telefone', '');
    NFSe.Prestador.Contato.Email := AINIRec.ReadString(sSecao, 'Email', '');

    NFSe.OptanteSN := StrToOptanteSN(Ok, AINIRec.ReadString(sSecao, 'opSimpNac', '2'));

    if AINIRec.ReadString(sSecao, 'RegimeApuracaoSN', '') <> '' then
      NFSe.RegimeApuracaoSN := StrToRegimeApuracaoSN(Ok, AINIRec.ReadString(sSecao, 'RegimeApuracaoSN', '1'));

    NFSe.RegimeEspecialTributacao := FpAOwner.StrToRegimeEspecialTributacao(Ok, AINIRec.ReadString(sSecao, 'Regime', '0'));
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIDadosTomador(AINIRec: TMemIniFile);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'Tomador';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Tomador.IdentificacaoTomador.CpfCnpj := AINIRec.ReadString(sSecao, 'CNPJCPF', '');
    NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := AINIRec.ReadString(sSecao, 'InscricaoMunicipal', '');

    NFSe.Tomador.IdentificacaoTomador.Nif := AINIRec.ReadString(sSecao, 'NIF', '');
    NFSe.Tomador.IdentificacaoTomador.cNaoNIF := StrToNaoNIF(Ok, AINIRec.ReadString(sSecao, 'cNaoNIF', '0'));
    NFSe.Tomador.IdentificacaoTomador.CAEPF := AINIRec.ReadString(sSecao, 'CAEPF', '');

    NFSe.Tomador.RazaoSocial := AINIRec.ReadString(sSecao, 'RazaoSocial', '');

    NFSe.Tomador.Endereco.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
    NFSe.Tomador.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
    NFSe.Tomador.Endereco.CodigoPais := AINIRec.ReadInteger(sSecao, 'CodigoPais', 0);
    NFSe.Tomador.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
    NFSe.Tomador.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');
    NFSe.Tomador.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
    NFSe.Tomador.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
    NFSe.Tomador.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
    NFSe.Tomador.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');

    NFSe.Tomador.Contato.Telefone := AINIRec.ReadString(sSecao, 'Telefone', '');
    NFSe.Tomador.Contato.Email := AINIRec.ReadString(sSecao, 'Email', '');
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIDadosIntermediario(AINIRec: TMemIniFile);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'Intermediario';
  if AINIRec.SectionExists(sSecao)then
  begin
    NFSe.Intermediario.Identificacao.CpfCnpj := AINIRec.ReadString(sSecao, 'CNPJCPF', '');
    NFSe.Intermediario.Identificacao.InscricaoMunicipal := AINIRec.ReadString(sSecao, 'InscricaoMunicipal', '');
    NFSe.Intermediario.Identificacao.Nif := AINIRec.ReadString(sSecao, 'NIF', '');
    NFSe.Intermediario.Identificacao.cNaoNIF := StrToNaoNIF(Ok, AINIRec.ReadString(sSecao, 'cNaoNIF', '0'));
    NFSe.Intermediario.Identificacao.CAEPF := AINIRec.ReadString(sSecao, 'CAEPF', '');

    NFSe.Intermediario.RazaoSocial := AINIRec.ReadString(sSecao, 'RazaoSocial', '');

    NFSe.Intermediario.Endereco.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
    NFSe.Intermediario.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
    NFSe.Intermediario.Endereco.CodigoPais := AINIRec.ReadInteger(sSecao, 'CodigoPais', 0);
    NFSe.Intermediario.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
    NFSe.Intermediario.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');
    NFSe.Intermediario.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
    NFSe.Intermediario.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
    NFSe.Intermediario.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
    NFSe.Intermediario.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');

    NFSe.Intermediario.Contato.Telefone := AINIRec.ReadString(sSecao, 'Telefone', '');
    NFSe.Intermediario.Contato.Email := AINIRec.ReadString(sSecao, 'Email', '');
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIDadosServico(AINIRec: TMemIniFile);
var
  sSecao: string;
begin
  sSecao := 'Servico';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Servico.CodigoMunicipio := AINIRec.ReadString(sSecao, 'CodigoMunicipio', '');
    NFSe.Servico.CodigoPais := AINIRec.ReadInteger(sSecao, 'CodigoPais', 0);
    NFSe.Servico.ItemListaServico := AINIRec.ReadString(sSecao, 'ItemListaServico', '');
    NFSe.Servico.CodigoTributacaoMunicipio := AINIRec.ReadString(sSecao, 'CodigoTributacaoMunicipio', '');
    NFSe.Servico.Discriminacao := AINIRec.ReadString(sSecao, 'Discriminacao', '');
    NFSe.Servico.CodigoNBS := AINIRec.ReadString(sSecao, 'CodigoNBS', '');
    NFSe.Servico.CodigoInterContr := AINIRec.ReadString(sSecao, 'CodigoInterContr', '');
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIComercioExterior(AINIRec: TMemIniFile);
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

procedure TNFSeR_PadraoNacional.LerINILocacaoSubLocacao(AINIRec: TMemIniFile);
var
  SSecao: string;
  Ok: Boolean;
begin
  sSecao := 'LocacaoSubLocacao';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Servico.Locacao.categ := StrTocateg(Ok, AINIRec.ReadString(sSecao, 'categ', '1'));
    NFSe.Servico.Locacao.objeto := StrToobjeto(Ok, AINIRec.ReadString(sSecao, 'objeto', '1'));
    NFSe.Servico.Locacao.extensao := AINIRec.ReadString(sSecao, 'extensao', '');
    NFSe.Servico.Locacao.nPostes := AINIRec.ReadInteger(sSecao, 'nPostes', 0);
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIConstrucaoCivil(AINIRec: TMemIniFile);
var
  sSecao: string;
begin
  sSecao := 'ConstrucaoCivil';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.ConstrucaoCivil.CodigoObra := AINIRec.ReadString(sSecao, 'CodigoObra', '');
    NFSe.ConstrucaoCivil.inscImobFisc := AINIRec.ReadString(sSecao, 'inscImobFisc', '');

    NFSe.ConstrucaoCivil.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
    NFSe.ConstrucaoCivil.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
    NFSe.ConstrucaoCivil.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');
    NFSe.ConstrucaoCivil.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
    NFSe.ConstrucaoCivil.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
    NFSe.ConstrucaoCivil.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
    NFSe.ConstrucaoCivil.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIEvento(AINIRec: TMemIniFile);
var
  SSecao: string;
begin
  sSecao := 'Evento';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Servico.Evento.xNome := AINIRec.ReadString(sSecao, 'xNome', '');
    NFSe.Servico.Evento.dtIni := AINIRec.ReadDate(sSecao, 'dtIni', Now);
    NFSe.Servico.Evento.dtFim := AINIRec.ReadDate(sSecao, 'dtFim', Now);
    NFSe.Servico.Evento.idAtvEvt := AINIRec.ReadString(sSecao, 'idAtvEvt', '');

    NFSe.Servico.Evento.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
    NFSe.Servico.Evento.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
    NFSe.Servico.Evento.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');
    NFSe.Servico.Evento.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
    NFSe.Servico.Evento.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
    NFSe.Servico.Evento.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
    NFSe.Servico.Evento.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIRodoviaria(AINIRec: TMemIniFile);
var
  SSecao: string;
  Ok: Boolean;
begin
  sSecao := 'Rodoviaria';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Servico.explRod.categVeic := StrTocategVeic(Ok, AINIRec.ReadString(sSecao, 'categVeic', '00'));
    NFSe.Servico.explRod.nEixos := AINIRec.ReadInteger(sSecao, 'nEixos', 0);
    NFSe.Servico.explRod.rodagem := StrTorodagem(Ok, AINIRec.ReadString(sSecao, 'rodagem', '1'));
    NFSe.Servico.explRod.sentido := AINIRec.ReadString(sSecao, 'sentido', '');
    NFSe.Servico.explRod.placa := AINIRec.ReadString(sSecao, 'placa', '');
    NFSe.Servico.explRod.codAcessoPed := AINIRec.ReadString(sSecao, 'codAcessoPed', '');
    NFSe.Servico.explRod.codContrato := AINIRec.ReadString(sSecao, 'codContrato', '');
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIInformacoesComplementares(
  AINIRec: TMemIniFile);
var
  SSecao: string;
begin
  sSecao := 'InformacoesComplementares';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Servico.infoCompl.idDocTec := AINIRec.ReadString(sSecao, 'idDocTec', '');
    NFSe.Servico.infoCompl.docRef := AINIRec.ReadString(sSecao, 'docRef', '');
    NFSe.Servico.infoCompl.xInfComp := AINIRec.ReadString(sSecao, 'xInfComp', '');
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIValores(AINIRec: TMemIniFile);
var
  SSecao: string;
begin
  sSecao := 'Valores';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Servico.Valores.ValorRecebido := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorRecebido', ''), 0);
    NFSe.Servico.Valores.ValorServicos := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorServicos', ''), 0);
    NFSe.Servico.Valores.DescontoIncondicionado := StringToFloatDef(AINIRec.ReadString(sSecao, 'DescontoIncondicionado', ''), 0);
    NFSe.Servico.Valores.DescontoCondicionado := StringToFloatDef(AINIRec.ReadString(sSecao, 'DescontoCondicionado', ''), 0);
    NFSe.Servico.Valores.AliquotaDeducoes := StringToFloatDef(AINIRec.ReadString(sSecao, 'AliquotaDeducoes', ''), 0);
    NFSe.Servico.Valores.ValorDeducoes := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorDeducoes', ''), 0);
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIDocumentosDeducoes(AINIRec: TMemIniFile);
var
  i: Integer;
  sSecao: string;
  Ok: Boolean;
  Item: TDocDeducaoCollectionItem;
begin
  i := 1;
  while true do
  begin
    sSecao := 'DocumentosDeducoes' + IntToStrZero(i, 3);

    if not AINIRec.SectionExists(sSecao) then
      break;

    Item := NFSe.Servico.Valores.DocDeducao.New;

    Item.chNFSe := AINIRec.ReadString(sSecao,'chNFSe', '');
    Item.chNFe := AINIRec.ReadString(sSecao, 'chNFe', '');
    Item.nDocFisc := AINIRec.ReadString(sSecao, 'nDocFisc', '');
    Item.nDoc := AINIRec.ReadString(sSecao, 'nDoc', '');
    Item.tpDedRed := StrTotpDedRed(Ok, AINIRec.ReadString(sSecao, 'tpDedRed', '1'));
    Item.xDescOutDed := AINIRec.ReadString(sSecao, 'xDescOutDed', '');
    Item.dtEmiDoc := AINIRec.ReadDate(sSecao, 'dtEmiDoc', Now);
    Item.vDedutivelRedutivel := StringToFloatDef(AINIRec.ReadString(sSecao, 'vDedutivelRedutivel', ''), 0);
    Item.vDeducaoReducao := StringToFloatDef(AINIRec.ReadString(sSecao, 'vDeducaoReducao', ''), 0);

    Item.NFSeMun.cMunNFSeMun := AINIRec.ReadString(sSecao, 'cMunNFSeMun', '');
    Item.NFSeMun.nNFSeMun := AINIRec.ReadString(sSecao, 'nNFSeMun', '');
    Item.NFSeMun.cVerifNFSeMun := AINIRec.ReadString(sSecao, 'cVerifNFSeMun', '');

    Item.NFNFS.nNFS := AINIRec.ReadString(sSecao, 'nNFS', '');
    Item.NFNFS.modNFS := AINIRec.ReadString(sSecao, 'modNFS', '');
    Item.NFNFS.serieNFS := AINIRec.ReadString(sSecao, 'serieNFS', '');

    LerINIDocumentosDeducoesFornecedor(AINIRec, Item.fornec, i);

    Inc(i);
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIDocumentosDeducoesFornecedor(
  AINIRec: TMemIniFile; fornec: TInfoPessoa; Indice: Integer);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'DocumentosDeducoesFornecedor' + IntToStrZero(Indice, 3);
  if AINIRec.SectionExists(sSecao) then
  begin
    fornec.Identificacao.CpfCnpj := AINIRec.ReadString(sSecao, 'CNPJCPF', '');
    fornec.Identificacao.InscricaoMunicipal := AINIRec.ReadString(sSecao, 'InscricaoMunicipal', '');
    fornec.Identificacao.Nif := AINIRec.ReadString(sSecao, 'NIF', '');
    fornec.Identificacao.cNaoNIF := StrToNaoNIF(Ok, AINIRec.ReadString(sSecao, 'cNaoNIF', '0'));
    fornec.Identificacao.CAEPF := AINIRec.ReadString(sSecao, 'CAEPF', '');

    fornec.Endereco.CEP := AINIRec.ReadString(sSecao, 'CEP', '');
    fornec.Endereco.xMunicipio := AINIRec.ReadString(sSecao, 'xMunicipio', '');
    fornec.Endereco.UF := AINIRec.ReadString(sSecao, 'UF', '');
    fornec.Endereco.Endereco := AINIRec.ReadString(sSecao, 'Logradouro', '');
    fornec.Endereco.Numero := AINIRec.ReadString(sSecao, 'Numero', '');
    fornec.Endereco.Complemento := AINIRec.ReadString(sSecao, 'Complemento', '');
    fornec.Endereco.Bairro := AINIRec.ReadString(sSecao, 'Bairro', '');

    fornec.Contato.Telefone := AINIRec.ReadString(sSecao, 'Telefone', '');
    fornec.Contato.Email := AINIRec.ReadString(sSecao, 'Email', '');
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIValoresTribMun(AINIRec: TMemIniFile);
var
  sSecao: string;
  Ok: Boolean;
begin
  sSecao := 'tribMun';
  if AINIRec.SectionExists(sSecao) then
  begin
    NFSe.Servico.Valores.tribMun.tribISSQN := StrTotribISSQN(Ok, AINIRec.ReadString(sSecao, 'tribISSQN', '1'));
    NFSe.Servico.Valores.tribMun.cPaisResult := AINIRec.ReadInteger(sSecao, 'cPaisResult', 0);
//    NFSe.Servico.Valores.tribMun.tpBM := StrTotpBM(Ok, AINIRec.ReadString(sSecao, 'tpBM', '1'));
    NFSe.Servico.Valores.tribMun.nBM := AINIRec.ReadString(sSecao, 'nBM', '');
    NFSe.Servico.Valores.tribMun.vRedBCBM := StringToFloatDef(AINIRec.ReadString(sSecao, 'vRedBCBM', ''), 0);
    NFSe.Servico.Valores.tribMun.pRedBCBM := StringToFloatDef(AINIRec.ReadString(sSecao, 'pRedBCBM', ''), 0);
    NFSe.Servico.Valores.tribMun.tpSusp := StrTotpSusp(Ok, AINIRec.ReadString(sSecao, 'tpSusp', ''));
    NFSe.Servico.Valores.tribMun.nProcesso := AINIRec.ReadString(sSecao, 'nProcesso', '');
    NFSe.Servico.Valores.tribMun.tpImunidade := StrTotpImunidade(Ok, AINIRec.ReadString(sSecao, 'tpImunidade', ''));
    NFSe.Servico.Valores.tribMun.pAliq := StringToFloatDef(AINIRec.ReadString(sSecao, 'pAliq', ''), 0);
    NFSe.Servico.Valores.tribMun.tpRetISSQN := StrTotpRetISSQN(Ok, AINIRec.ReadString(sSecao, 'tpRetISSQN', ''));
  end;
end;

procedure TNFSeR_PadraoNacional.LerINIValoresTribFederal(AINIRec: TMemIniFile);
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

procedure TNFSeR_PadraoNacional.LerINIValoresTotalTrib(AINIRec: TMemIniFile);
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

end.
