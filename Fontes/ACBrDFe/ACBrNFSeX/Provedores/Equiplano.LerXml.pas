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

unit Equiplano.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { TNFSeR_Equiplano }

  TNFSeR_Equiplano = class(TNFSeRClass)
  protected
    procedure LerNFS(const ANode: TACBrXmlNode);
    procedure LerTomador(const ANode: TACBrXmlNode);
    procedure LerIdentificacaoTomador(const ANode: TACBrXmlNode);
    procedure LerListaServico(const ANode: TACBrXmlNode);
    procedure LerRetencoes(const ANode: TACBrXmlNode);
    procedure LerCancelamento(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings;

//==============================================================================
// Essa unit tem por finalidade exclusiva de ler o XML do provedor:
//     Equiplano
//==============================================================================

procedure TNFSeR_Equiplano.LerNFS(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  aValor: string;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('nfs');

  if AuxNode <> nil then
  begin
    NFSe.Numero                  := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrNfs'), tcStr);
    NFSe.CodigoVerificacao       := ObterConteudo(AuxNode.Childrens.FindAnyNs('cdAutenticacao'), tcStr);
    NFSe.DataEmissao             := ObterConteudo(AuxNode.Childrens.FindAnyNs('dtEmissaoNfs'), tcDatHor);
    NFSe.IdentificacaoRps.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrRps'), tcStr);

    with NFSe.Prestador.IdentificacaoPrestador do
    begin
      CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrDocumento'), tcStr);
      InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrInscricaoMunicipal'), tcStr);
    end;

    with NFSe.Prestador do
    begin
      RazaoSocial  := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmPrestador'), tcStr);
      NomeFantasia := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmPrestador'), tcStr);
    end;

    with NFSe.Prestador.Endereco do
    begin
      Endereco   := ObterConteudo(AuxNode.Childrens.FindAnyNs('dsEndereco'), tcStr);
      Numero     := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrEndereco'), tcStr);
      Bairro     := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmBairro'), tcStr);
      xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmCidade'), tcStr);
      UF         := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmUf'), tcStr);
      CEP        := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrCEP'), tcStr);
      xPais      := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmPais'), tcStr);
    end;

    with NFSe.Servico do
    begin
      Discriminacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('dsDiscriminacaoServico'), tcStr);
      Discriminacao := StringReplace(Discriminacao, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

      VerificarSeConteudoEhLista(Discriminacao);

      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrCidadeIbgeServico'), tcStr);
    end;

    with NFSe.Servico.Valores do
    begin
      ValorServicos := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlServico'), tcDe2);
      Aliquota      := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlAliquota'), tcDe2);
      ValorIss      := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlImposto'), tcDe2);
      BaseCalculo   := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlBaseCalculo'), tcDe2);

      aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('isIssRetido'), tcStr);

      if aValor = 'Sim' then
        ValorISSRetido := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlImposto'), tcDe2);

      ValorPis      := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlPis'), tcDe2);
      ValorCofins   := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlCofins'), tcDe2);
      ValorIr       := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlAliquotaIrpj'), tcDe2);
      ValorCsll     := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlCsll'), tcDe2);
      ValorInss     := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlInss'), tcDe2);

      RetencoesFederais := ValorPis + ValorCofins + ValorInss + ValorIr + ValorCsll;
    end;

    AuxNode := AuxNode.Childrens.FindAnyNs('cancelamento');

    if AuxNode <> nil then
    begin
      NFSe.NfseCancelamento.DataHora := ObterConteudo(AuxNode.Childrens.FindAnyNs('dtCancelamento'), tcDatHor);
      NFSe.MotivoCancelamento := ObterConteudo(AuxNode.Childrens.FindAnyNs('dsCancelamento'), tcStr);
      NFSe.SituacaoNfse := snCancelado;
    end;
  end;
end;

procedure TNFSeR_Equiplano.LerTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  xUF: string;
begin
  xUF := '';

  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('tomadorServico');

  if AuxNode = nil then
    AuxNode := ANode.Childrens.FindAnyNs('tomador');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador do
    begin
      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmTomador'), tcStr);
    end;

    LerIdentificacaoTomador(AuxNode);

    with NFSe.Tomador.Endereco do
    begin
      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('dsEndereco'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrEndereco'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('dsComplemento'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmBairro'), tcStr);
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrCidadeIbge'), tcStr);
      xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmCidade'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmUf'), tcStr);
      xPais := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmPais'), tcStr);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrCep'), tcStr);

      if xMunicipio = '' then
        xMunicipio := ObterNomeMunicipioUF(StrToIntDef(CodigoMunicipio, 0), xUF);

      if UF = '' then
        UF := xUF;
    end;

    with NFSe.Tomador.Contato do
    begin
      Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrTelefone'), tcStr);
    end;
  end;
end;

procedure TNFSeR_Equiplano.LerIdentificacaoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('documento');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.IdentificacaoTomador do
    begin
      CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrDocumento'), tcStr);
    end;
  end;
end;

procedure TNFSeR_Equiplano.LerListaServico(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNodeDed: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('listaServicos');

  if AuxNode <> nil then
  begin
    ANodes := AuxNode.Childrens.FindAllAnyNs('servico');

    for i := 0 to Length(ANodes) - 1 do
    begin
      NFSe.Servico.ItemServico.New;
      with NFSe.Servico.ItemServico[i] do
      begin
        Quantidade := 1;

        ItemListaServico := PadLeft(ObterConteudo(ANodes[i].Childrens.FindAnyNs('nrServicoItem'), tcStr), 2, '0') +
                            '.' +
                            PadLeft(ObterConteudo(ANodes[i].Childrens.FindAnyNs('nrServicoSubItem'), tcStr), 2, '0');

        ValorUnitario := ObterConteudo(ANodes[i].Childrens.FindAnyNs('vlServico'), tcDe2);
        Aliquota := ObterConteudo(ANodes[i].Childrens.FindAnyNs('vlAliquota'), tcDe2);

        AuxNodeDed := ANodes[i].Childrens.FindAnyNs('deducao');

        if AuxNodeDed <> nil then
        begin
          ValorDeducoes := ObterConteudo(AuxNodeDed.Childrens.FindAnyNs('vlDeducao'), tcDe2);

          xJustDeducao := ObterConteudo(AuxNodeDed.Childrens.FindAnyNs('dsJustificativaDeducao'), tcStr);
        end;

        BaseCalculo := ObterConteudo(ANodes[i].Childrens.FindAnyNs('vlBaseCalculo'), tcDe2);
        ValorISS := ObterConteudo(ANodes[i].Childrens.FindAnyNs('vlIssServico'), tcDe2);
        Descricao := ObterConteudo(ANodes[i].Childrens.FindAnyNs('dsDiscriminacaoServico'), tcStr);
        Descricao := StringReplace(Descricao, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

        ValorTotal := Quantidade * ValorUnitario;
      end;
    end;

    NFSe.Servico.Valores.ValorServicos := 0;
    NFSe.Servico.Valores.Aliquota := 0;
    NFSe.Servico.Valores.BaseCalculo := 0;
    NFSe.Servico.Valores.ValorIss := 0;
    NFSe.Servico.Discriminacao := '';

    for i := 0 to NFSe.Servico.ItemServico.Count -1 do
    begin
      if i = 0 then
      begin
        NFSe.Servico.ItemListaServico := NFSe.Servico.ItemServico[i].ItemListaServico;
        NFSe.Servico.Valores.Aliquota := NFSe.Servico.ItemServico[i].Aliquota;
      end;

      NFSe.Servico.Valores.ValorServicos := NFSe.Servico.Valores.ValorServicos +
        (NFSe.Servico.ItemServico[i].Quantidade * NFSe.Servico.ItemServico[i].ValorUnitario);
      NFSe.Servico.Valores.BaseCalculo := NFSe.Servico.Valores.BaseCalculo +
        NFSe.Servico.ItemServico[i].BaseCalculo;
      NFSe.Servico.Valores.ValorIss := NFSe.Servico.Valores.ValorIss +
        NFSe.Servico.ItemServico[i].ValorIss;

      NFSe.Servico.Discriminacao := NFSe.Servico.Discriminacao +
        NFSe.Servico.ItemServico[i].Descricao;
    end;

    NFSe.Servico.Discriminacao := StringReplace(NFSe.Servico.Discriminacao, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);
  end;
end;

procedure TNFSeR_Equiplano.LerRetencoes(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('retencoes');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores do
    begin
      ValorCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlCofins'), tcDe2);
      ValorCsll := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlCsll'), tcDe2);
      ValorInss := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlInss'), tcDe2);
      ValorIr := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlIrrf'), tcDe2);
      ValorPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlPis'), tcDe2);
      ValorIssRetido := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlIss'), tcDe2);

      AliquotaCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlAliquotaCofins'), tcDe2);
      AliquotaCsll := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlAliquotaCsll'), tcDe2);
      AliquotaInss := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlAliquotaInss'), tcDe2);
      AliquotaIr  := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlAliquotaIrrf'), tcDe2);
      AliquotaPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('vlAliquotaPis'), tcDe2);

      RetencoesFederais := ValorPis + ValorCofins + ValorInss + ValorIr + ValorCsll;
    end;
  end;
end;

procedure TNFSeR_Equiplano.LerCancelamento(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('cancelamento');

  if AuxNode <> nil then
  begin
    NFSe.NfseCancelamento.DataHora := ObterConteudo(AuxNode.Childrens.FindAnyNs('dtCancelamento'), tcDatHor);
    NFSe.MotivoCancelamento := ObterConteudo(AuxNode.Childrens.FindAnyNs('dsCancelamento'), tcStr);
    NFSe.SituacaoNfse := snCancelado;
  end;
end;

function TNFSeR_Equiplano.LerXml: Boolean;
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

  if (Pos('nfse', Arquivo) > 0) then
    tpXML := txmlNFSe
  else
    tpXML := txmlRPS;

  XmlNode := Document.Root;

  if XmlNode = nil then
    raise Exception.Create('Arquivo xml vazio.');

  if tpXML = txmlNFSe then
    Result := LerXmlNfse(XmlNode)
  else
    Result := LerXmlRps(XmlNode);

  FreeAndNil(FDocument);
end;

function TNFSeR_Equiplano.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;
  NFSe.SituacaoNfse := snNormal;

  if not Assigned(ANode) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('nfse');

  if AuxNode <> nil then
  begin
    NFSe.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrNfse'), tcStr);
    NFSe.CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('cdAutenticacao'), tcStr);
    NFSe.DataEmissao := ObterConteudo(AuxNode.Childrens.FindAnyNs('dtEmissaoNfs'), tcDatHor);

    LerXmlRps(AuxNode);
//    LerTomador(ANode);
//    LerListaServico(ANode);
//    LerRetencoes(ANode);
    LerCancelamento(AuxNode);
  end;

  LerCampoLink;
end;

function TNFSeR_Equiplano.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode, AuxNodeDoc: TACBrXmlNode;
  Ok: Boolean;
  xUF: string;
begin
  Result := True;

  with NFSe do
  begin
    IdentificacaoRps.Numero := ObterConteudo(ANode.Childrens.FindAnyNs('nrRps'), tcStr);
    IdentificacaoRps.Serie := ObterConteudo(ANode.Childrens.FindAnyNs('nrEmissorRps'), tcStr);

    DataEmissaoRps := ObterConteudo(ANode.Childrens.FindAnyNs('dtEmissaoRps'), tcDatHor);
    NaturezaOperacao := StrToNaturezaOperacao(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('tpTributacao'), tcStr));

    Servico.Valores.IssRetido := FpAOwner.StrToSituacaoTributaria(Ok, ObterConteudo(ANode.Childrens.FindAnyNs('isIssRetido'), tcStr));
    Servico.Valores.ValorServicos := ObterConteudo(ANode.Childrens.FindAnyNs('vlTotalRps'), tcDe2);
    Servico.Valores.ValorLiquidoNfse := ObterConteudo(ANode.Childrens.FindAnyNs('vlLiquidoRps'), tcDe2);

    AuxNode := ANode.Childrens.FindAnyNs('tomador');

    if AuxNode <> nil then
    begin
      Tomador.RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmTomador'), tcStr);

      Tomador.Contato.Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('dsEmail'), tcStr);
      Tomador.Contato.Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrTelefone'), tcStr);

      Tomador.IdentificacaoTomador.InscricaoEstadual := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrInscricaoEstadual'), tcStr);
      Tomador.IdentificacaoTomador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrInscricaoMunicipal'), tcStr);

      Tomador.Endereco.Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('dsEndereco'), tcStr);
      Tomador.Endereco.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrEndereco'), tcStr);
      Tomador.Endereco.Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('dsComplemento'), tcStr);
      Tomador.Endereco.Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmBairro'), tcStr);
      Tomador.Endereco.CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrCidadeIbge'), tcStr);
      Tomador.Endereco.UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmUf'), tcStr);
      Tomador.Endereco.xPais := ObterConteudo(AuxNode.Childrens.FindAnyNs('nmPais'), tcStr);
      Tomador.Endereco.CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('nrCep'), tcStr);
      Tomador.Endereco.xMunicipio := ObterNomeMunicipioUF(StrToIntDef(Tomador.Endereco.CodigoMunicipio, 0), xUF);

      if Tomador.Endereco.UF = '' then
        Tomador.Endereco.UF := xUF;

      AuxNodeDoc := AuxNode.Childrens.FindAnyNs('documento');

      if AuxNodeDoc <> nil then
      begin
        Tomador.IdentificacaoTomador.CpfCnpj := ObterConteudo(AuxNodeDoc.Childrens.FindAnyNs('nrDocumento'), tcStr);
        Tomador.IdentificacaoTomador.DocEstrangeiro := ObterConteudo(AuxNodeDoc.Childrens.FindAnyNs('dsDocumentoEstrangeiro'), tcStr);
      end;
    end;

    LerListaServico(ANode);
    LerRetencoes(ANode);

    Servico.Valores.DescontoIncondicionado := ObterConteudo(ANode.Childrens.FindAnyNs('vlDesconto'), tcDe2);

    if Servico.Valores.ValorLiquidoNfse = 0 then
      Servico.Valores.ValorLiquidoNfse := Servico.Valores.ValorServicos -
      Servico.Valores.RetencoesFederais - Servico.Valores.OutrasRetencoes -
      Servico.Valores.ValorIssRetido - Servico.Valores.DescontoIncondicionado -
      Servico.Valores.DescontoCondicionado;

    Servico.Valores.ValorTotalNotaFiscal := Servico.Valores.ValorServicos -
      Servico.Valores.DescontoCondicionado - Servico.Valores.DescontoIncondicionado;
  end;
end;

end.
