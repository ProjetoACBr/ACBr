{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ISSLencois.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { Provedor com layout pr�prio }
  { TNFSeR_ISSLencois }

  TNFSeR_ISSLencois = class(TNFSeRClass)
  protected

    procedure LerPASNF(const ANode: TACBrXmlNode);
    procedure LerTomador(const ANode: TACBrXmlNode);
    procedure LerEnderecoTomador(const ANode: TACBrXmlNode);
    procedure LerRecolhimentoFora(const ANode: TACBrXmlNode);
    procedure LerOutrasInformacoes(ANode: TACBrXmlNode; const AListTag, AMessageTag: string);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

implementation

uses
  ACBrUtil.Base;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     ISSLencois
//==============================================================================

{ TNFSeR_ISSLencois }

procedure TNFSeR_ISSLencois.LerEnderecoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  xUF: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('Endereco');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('Logradouro'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('Complemento'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('Municipio'), tcStr);
      xMunicipio := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);

      if UF = '' then
        UF := xUF;
    end;
  end;
end;

procedure TNFSeR_ISSLencois.LerPASNF(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('PASNF');

  if AuxNode <> nil then
  begin
    with NFSe do
    begin
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      DataEmissao := ObterConteudo(AuxNode.Childrens.FindAnyNs('Data'), tcDat);
    end;
  end;
end;

procedure TNFSeR_ISSLencois.LerRecolhimentoFora(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  aValor: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('RecolhimentoFora');

  if AuxNode <> nil then
  begin
    with NFSe.Servico do
    begin
      aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('Obrigacao'), tcStr);

      if aValor = '1' then
        ResponsavelRetencao := rtTomador
      else
        ResponsavelRetencao := rtPrestador;

      Valores.Aliquota := ObterConteudo(AuxNode.Childrens.FindAnyNs('Aliquota'), tcDe6);
    end;
  end;
end;

procedure TNFSeR_ISSLencois.LerTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('Tomador');

  if AuxNode <> nil then
  begin
    with NFSe do
    begin
      Tomador.IdentificacaoTomador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('CPF_CNPJ'), tcStr);
      Tomador.RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('Nome'), tcStr);

      LerEnderecoTomador(AuxNode);

      Tomador.Contato.Email := ObterConteudo(ANode.Childrens.FindAnyNs('Email'), tcStr);
    end;
  end;
end;

function TNFSeR_ISSLencois.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
begin
  FpQuebradeLinha := FpAOwner.ConfigGeral.QuebradeLinha;

  if EstaVazio(Arquivo) then
    raise Exception.Create('Arquivo xml n�o carregado.');

  LerParamsTabIni(True);

  Arquivo := NormatizarXml(Arquivo);

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(Arquivo);

  if (Pos('PASNF', Arquivo) > 0) then
    tpXML := txmlRPS
  else
    tpXML := txmlNFSe;

  XmlNode := Document.Root;

  if XmlNode = nil then
    raise Exception.Create('Arquivo xml vazio.');

  if tpXML = txmlNFSe then
    Result := LerXmlNfse(XmlNode)
  else
    Result := LerXmlRps(XmlNode);

  if NFSe.Tomador.RazaoSocial = '' then
    NFSe.Tomador.RazaoSocial := 'Tomador N�o Identificado';

  FreeAndNil(FDocument);
end;

procedure TNFSeR_ISSLencois.LerOutrasInformacoes(ANode: TACBrXmlNode; const AListTag, AMessageTag: string);
var I: Integer;
    AuxNode: TACBrXmlNode;
    ANodeArray: TACBrXmlNodeArray;
    AMensagemInformacao: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs(AListTag);

  if (AuxNode = nil) then
    Exit;

  ANodeArray := AuxNode.Childrens.FindAllAnyNs(AMessageTag);

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
    AMensagemInformacao := AMensagemInformacao + sLineBreak + ANodeArray[I].Content;

  NFSe.InformacoesComplementares := Trim(AMensagemInformacao);
  NFSe.InformacoesComplementares := StringReplace(NFSe.InformacoesComplementares, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);
end;

function TNFSeR_ISSLencois.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode, AuxNode2: TACBrXmlNode;
begin
  if ObterConteudo(ANode.Childrens.FindAnyNs('Situacao'), tcStr) = '0' then
  begin
    NFSe.SituacaoNfse := snCancelado;
    NFSe.StatusRps    := srCancelado;
  end
  else
  begin
    NFSe.SituacaoNfse := snNormal;
    NFSe.StatusRps    := srNormal;
  end;

  NFSe.Numero            := ObterConteudo(ANode.Childrens.FindAnyNs('Numero'), tcStr);
  NFSe.DataEmissao       := ObterConteudo(ANode.Childrens.FindAnyNs('EmissaoData'), tcDat);
  NFSe.Competencia       := NFSe.DataEmissao;
  NFSe.CodigoVerificacao := ObterConteudo(ANode.Childrens.FindAnyNs('CodigoValidacao'), tcStr);
  NFSe.NfseSubstituida   := '';
  NFSe.RegimeEspecialTributacao := retNenhum;

  NFSe.RpsSubstituido.Numero := '';
  NFSe.RpsSubstituido.Serie  := '';
  NFSe.RpsSubstituido.Tipo   := trRPS;

  AuxNode := ANode.Childrens.FindAnyNs('Prestador');
  With NFSe do
  begin
    Prestador.IdentificacaoPrestador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('Inscricao'), tcStr);
    Prestador.IdentificacaoPrestador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);

    Prestador.RazaoSocial  := ObterConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocial'), tcStr);
    Prestador.NomeFantasia := ObterConteudo(AuxNode.Childrens.FindAnyNs('NomeFantasia'), tcStr);

    if ObterConteudo(AuxNode.Childrens.FindAnyNs('SuperSimples'), tcStr) = '0' then
      OptanteSimplesNacional := snNao
    else
      OptanteSimplesNacional := snSim;


    AuxNode2 := AuxNode.Childrens.FindAnyNs('Endereco');
    if AuxNode2 <> nil then
    begin
      Prestador.Endereco.Endereco    := ObterConteudo(AuxNode2.Childrens.FindAnyNs('Logradouro'), tcStr);
      Prestador.Endereco.Numero      := ObterConteudo(AuxNode2.Childrens.FindAnyNs('Numero'), tcStr);
      Prestador.Endereco.Complemento := ObterConteudo(AuxNode2.Childrens.FindAnyNs('Complemento'), tcStr);
      Prestador.Endereco.Bairro      := ObterConteudo(AuxNode2.Childrens.FindAnyNs('Bairro'), tcStr);
      Prestador.Endereco.CodigoMunicipio := ObterConteudo(AuxNode2.Childrens.FindAnyNs('CidadeIBGE'), tcStr);
      Prestador.Endereco.xMunicipio  := ObterConteudo(AuxNode2.Childrens.FindAnyNs('Cidade'), tcStr);
      Prestador.Endereco.UF          := ObterConteudo(AuxNode2.Childrens.FindAnyNs('Estado'), tcStr);
      Prestador.Endereco.CodigoPais  := 1058;
      Prestador.Endereco.xPais       := 'BRASIL';
      Prestador.Endereco.CEP         := ObterConteudo(AuxNode2.Childrens.FindAnyNs('Cep'), tcStr);

      OrgaoGerador.CodigoMunicipio := ObterConteudo(AuxNode2.Childrens.FindAnyNs('CidadeIBGE'), tcStr);
      OrgaoGerador.UF              := ObterConteudo(AuxNode2.Childrens.FindAnyNs('Estado'), tcStr);
    end;

    Servico.MunicipioIncidencia := StrToIntDef(Prestador.Endereco.CodigoMunicipio,0);

    AuxNode2 := AuxNode.Childrens.FindAnyNs('Atividade');
    if AuxNode2 <> nil then
    begin
      Servico.ItemListaServico := ObterConteudo(AuxNode2.Childrens.FindAnyNs('Codigo'), tcStr);
      Servico.xItemListaServico:= ObterConteudo(AuxNode2.Childrens.FindAnyNs('Descricao'), tcStr);
      Servico.CodigoMunicipio  := ObterConteudo(AuxNode2.Childrens.FindAnyNs('CidadeExecucao'), tcStr);
    end;
  end;

  AuxNode := ANode.Childrens.FindAnyNs('PAS');
  if AuxNode <> nil then
  begin
    With NFSe do
    begin
      IdentificacaoRps.Tipo := trRPS;
      IdentificacaoRps.Serie := '';
      IdentificacaoRps.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      DataEmissaoRps := ObterConteudo(AuxNode.Childrens.FindAnyNs('DataGeracao'), tcDat);
      dhRecebimento := ObterConteudo(AuxNode.Childrens.FindAnyNs('DataProcessamento'), tcDatHor);
    end;
  end;

  NFSe.Servico.Discriminacao := ObterConteudo(ANode.Childrens.FindAnyNs('Descricao'), tcStr);
  NFSe.Servico.Discriminacao := StringReplace(NFSe.Servico.Discriminacao, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

  VerificarSeConteudoEhLista(NFSe.Servico.Discriminacao);

  AuxNode := ANode.Childrens.FindAnyNs('Tomador');
  if AuxNode <> nil then
  begin
    With NFSe.Tomador do
    begin
      IdentificacaoTomador.CpfCnpj            := ObterConteudo(AuxNode.Childrens.FindAnyNs('Inscricao'), tcStr);
      IdentificacaoTomador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);

      RazaoSocial      := ObterConteudo(AuxNode.Childrens.FindAnyNs('Nome'), tcStr);
      Contato.Email    := ObterConteudo(AuxNode.Childrens.FindAnyNs('Email'), tcStr);
      Contato.Telefone := '';


      AuxNode := AuxNode.Childrens.FindAnyNs('Endereco');
      Endereco.TipoLogradouro  := '';
      Endereco.CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('CidadeIBGE'), tcStr);
      Endereco.Endereco        := ObterConteudo(AuxNode.Childrens.FindAnyNs('Logradouro'), tcStr);
      Endereco.Numero          := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Endereco.Complemento     := ObterConteudo(AuxNode.Childrens.FindAnyNs('Complemento'), tcStr);
      Endereco.Bairro          := ObterConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      Endereco.xMunicipio      := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cidade'), tcStr);
      Endereco.UF              := ObterConteudo(AuxNode.Childrens.FindAnyNs('Estado'), tcStr);
      Endereco.CEP             := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cep'), tcStr);

      if ObterConteudo(AuxNode.Childrens.FindAnyNs('TipoPessoa'), tcStr) = '1' then
      begin
        if Trim(Endereco.CodigoMunicipio) <> '' then
        begin
          if (NFSe.Prestador.Endereco.CodigoMunicipio <> Endereco.CodigoMunicipio) then
            IdentificacaoTomador.Tipo := tpPJforaMunicipio
          else
            IdentificacaoTomador.Tipo := tpPJdoMunicipio;
        end
        else
          IdentificacaoTomador.Tipo := tpPJdoMunicipio;
      end
      else
        IdentificacaoTomador.Tipo := tpPF;
    end;
  end;

  with NFSe.Servico.Valores do
  begin
    BaseCalculo      := ObterConteudo(ANode.Childrens.FindAnyNs('BaseDeCalculo'), tcDe2);
    ValorIss         := ObterConteudo(ANode.Childrens.FindAnyNs('ValorISS'), tcDe2);
    ValorServicos    := ObterConteudo(ANode.Childrens.FindAnyNs('ValorTotal'), tcDe2);
    ValorDeducoes    := ObterConteudo(ANode.Childrens.FindAnyNs('ValorDeducao'), tcDe2);
    Aliquota         := ObterConteudo(ANode.Childrens.FindAnyNs('Aliquota'), tcDe6);
    ValorPis         := ObterConteudo(ANode.Childrens.FindAnyNs('ValorPIS'), tcDe2);
    ValorCofins      := ObterConteudo(ANode.Childrens.FindAnyNs('ValorCOFINS'), tcDe2);
    RetidoIr         := ObterConteudo(ANode.Childrens.FindAnyNs('RetencaoIRRF'), tcDe2);
    RetidoInss       := ObterConteudo(ANode.Childrens.FindAnyNs('RetencaoINSS'), tcDe2);
    RetidoPis        := ObterConteudo(ANode.Childrens.FindAnyNs('RetencaoPIS'), tcDe2);
    RetidoCofins     := ObterConteudo(ANode.Childrens.FindAnyNs('RetencaoCOFINS'), tcDe2);
    RetidoCsll       := ObterConteudo(ANode.Childrens.FindAnyNs('RetencaoCSLL'), tcDe2);

    RetencoesFederais := ValorPis + ValorCofins + ValorInss + ValorIr + ValorCsll;

    ValorLiquidoNfse := ValorServicos - RetencoesFederais - OutrasRetencoes -
                        ValorIssRetido - DescontoIncondicionado -
                        DescontoCondicionado;

    ValorTotalNotaFiscal := ValorServicos - DescontoCondicionado -
                            DescontoIncondicionado;
  end;

  AuxNode := ANode.Childrens.FindAnyNs('Cancelamento');
  NFSe.NfseCancelamento.DataHora := ObterConteudo( AuxNode.Childrens.FindAnyNs('DataCancelamento'), tcDat );
  NFSe.NfseCancelamento.Sucesso  := (NFSe.NfseCancelamento.DataHora > 0);
  NFSe.NfseCancelamento.Pedido.CodigoCancelamento := ObterConteudo( AuxNode.Childrens.FindAnyNs('MotivoCodigo'), tcStr );;

  LerOutrasInformacoes( ANode , 'Informacoes', 'Informacao' );

  NFSe.NomeArq := NFSe.Numero + '-nfse.xml';
  Result := True;

  LerCampoLink;
end;

function TNFSeR_ISSLencois.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
begin
  Result := True;

  with NFSe do
  begin
    Prestador.IdentificacaoPrestador.InscricaoMunicipal := ObterConteudo(ANode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);

    LerPASNF(ANode);
    LerTomador(ANode);

    Servico.CodigoMunicipio := ObterConteudo(ANode.Childrens.FindAnyNs('CidadeExecucao'), tcStr);
    Servico.Descricao := ObterConteudo(ANode.Childrens.FindAnyNs('Descricao'), tcStr);

    Servico.Valores.ValorServicos := ObterConteudo(ANode.Childrens.FindAnyNs('ValorTotal'), tcDe2);
    Servico.Valores.ValorDeducoes := ObterConteudo(ANode.Childrens.FindAnyNs('ValorDeducao'), tcDe2);
    Servico.Valores.Aliquota := ObterConteudo(ANode.Childrens.FindAnyNs('Aliquota'), tcDe6);
    Servico.Valores.ValorPis := ObterConteudo(ANode.Childrens.FindAnyNs('ValorPIS'), tcDe2);
    Servico.Valores.ValorCofins := ObterConteudo(ANode.Childrens.FindAnyNs('ValorCOFINS'), tcDe2);
    Servico.Valores.ValorIr := ObterConteudo(ANode.Childrens.FindAnyNs('RetencaoIRRF'), tcDe2);
    Servico.Valores.ValorInss := ObterConteudo(ANode.Childrens.FindAnyNs('RetencaoINSS'), tcDe2);
    Servico.Valores.ValorPis := ObterConteudo(ANode.Childrens.FindAnyNs('RetencaoPIS'), tcDe2);
    Servico.Valores.ValorCofins := ObterConteudo(ANode.Childrens.FindAnyNs('RetencaoCOFINS'), tcDe2);
    Servico.Valores.ValorCsll := ObterConteudo(ANode.Childrens.FindAnyNs('RetencaoCSLL'), tcDe2);

    LerRecolhimentoFora(ANode);
  end;
end;

end.
