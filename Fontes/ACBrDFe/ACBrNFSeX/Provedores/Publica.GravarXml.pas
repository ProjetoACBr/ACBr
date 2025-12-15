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

unit Publica.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils, IniFiles,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXClass,
  ACBrNFSeXGravarXml_ABRASFv1;

type
  { TNFSeW_Publica }

  TNFSeW_Publica = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

    function GerarCondicaoPagamento: TACBrXmlNode; override;
    function GerarParcelas: TACBrXmlNodeArray; override;
    function GerarDestinatario: TACBrXmlNode; override;
    function GerarEnderecoDestinatario(ender: Tender): TACBrXmlNode;
    function GerarImovel: TACBrXmlNode; override;
    function GerarEnderecoImovel(ender: TenderImovel): TACBrXmlNode;
    function GerarValores: TACBrXmlNode; override;
    function GerarTributosFederais: TACBrXmlNode;
    function GerarPisCofins: TACBrXmlNode;
    function GerartribMun: TACBrXmlNode;
    function GerarServico: TACBrXmlNode; override;
    function GerarConstrucaoCivil: TACBrXmlNode; override;

    procedure GerarINISecaoParcelas(const AINIRec: TMemIniFile); override;
  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrNFSeXConversao,
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrNFSeXConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Publica
//==============================================================================

{ TNFSeW_Publica }

procedure TNFSeW_Publica.Configuracao;
begin
  inherited Configuracao;

  DivAliq100 := True;

  if FpAOwner.ConfigGeral.Params.TemParametro('NaoDividir100') then
    DivAliq100 := False;

  NrOcorrCodigoCnae := -1;
  NrOcorrCodTribMun := -1;

  NrOcorrInformacoesComplemetares := 0;
  NrOcorrRegimeEspecialTributacao := -1;
end;

function TNFSeW_Publica.GerarCondicaoPagamento: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := nil;

  if (NFSe.CondicaoPagamento.Parcelas.Count > 0) then
  begin
    Result := CreateElement('CondicaoPagamento');

    nodeArray := GerarParcelas;
    for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

function TNFSeW_Publica.GerarParcelas: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.CondicaoPagamento.Parcelas.Count);

  for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
  begin
    Result[i] := CreateElement('Parcelas');

    Result[i].AppendChild(AddNode(tcStr, '#53', 'Condicao', 1, 15, 1,
      FpAOwner.CondicaoPagToStr(NFSe.CondicaoPagamento.Parcelas.Items[i].Condicao), DSC_TPAG));

    Result[i].AppendChild(AddNode(tcStr, '#54', 'Parcela', 1, 03, 1,
                  NFSe.CondicaoPagamento.Parcelas.Items[i].Parcela, DSC_NPARC));

    Result[i].AppendChild(AddNode(tcDe2, '#55', 'Valor', 1, 18, 1,
                    NFSe.CondicaoPagamento.Parcelas.Items[i].Valor, DSC_VPARC));

    Result[i].AppendChild(AddNode(tcDat, '#56', 'DataVencimento', 10, 10, 1,
           NFSe.CondicaoPagamento.Parcelas.Items[i].DataVencimento, DSC_DVENC));
  end;

  if NFSe.CondicaoPagamento.Parcelas.Count > 10 then
    wAlerta('#54', 'Parcelas', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

function TNFSeW_Publica.GerarDestinatario: TACBrXmlNode;
var
  Tamanho: integer;
  Ocorrencia: integer;
  CNPJCPF, TipoDestinatario: string;
begin
  Result := nil;

  if NFSe.IBSCBS.dest.xNome <> '' then
  begin
    Result := CreateElement('Destinatario');

    CNPJCPF := OnlyAlphaNum(trim(NFSe.IBSCBS.Dest.CNPJCPF));
    Tamanho := length(CNPJCPF);

    if CNPJCPF = '' then
      TipoDestinatario := '0'
    else
    begin
      if (Tamanho <= 11) and (Tamanho > 0) then
      begin
        if Tamanho <> 11 then
        begin
          CNPJCPF := PadLeft(CNPJCPF, 11, '0');
          Tamanho := 11;
        end;

        TipoDestinatario := '1';
      end
      else
      begin
        if (Tamanho > 0) and (Tamanho <> 14) then
        begin
          CNPJCPF := PadLeft(CNPJCPF, 14, '0');
          Tamanho := 14;
        end;

        TipoDestinatario := '2';
      end;
    end;

    if NFSe.IBSCBS.Dest.Nif <> '' then
      TipoDestinatario := '3';

    Result.AppendChild(AddNode(tcStr, '#1', 'TipoDestinatario', 1, 1, 0,
                                                         TipoDestinatario, ''));

    if NFSe.IBSCBS.Dest.CNPJCPF <> '' then
      Result.AppendChild(AddNode(tcStr, '#1', 'Identificacao', 1, 14, 1,
                                                  NFSe.IBSCBS.Dest.CNPJCPF, ''))
    else
      if NFSe.IBSCBS.Dest.Nif <> '' then
        Result.AppendChild(AddNode(tcStr, '#1', 'Identificacao', 1, 20, 1,
                                                     NFSe.IBSCBS.Dest.Nif, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'TipoServico', 1, 1, 0,
                                             NFSe.IBSCBS.Dest.TipoServico, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Nome', 1, 300, 1,
                                                   NFSe.IBSCBS.Dest.xNome, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Fone', 6, 20, 0,
                                                    NFSe.IBSCBS.Dest.fone, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Email', 1, 80, 0,
                                                   NFSe.IBSCBS.Dest.email, ''));

    Result.AppendChild(GerarEnderecoDestinatario(NFSe.IBSCBS.Dest.ender));
  end;
end;

function TNFSeW_Publica.GerarEnderecoDestinatario(ender: Tender): TACBrXmlNode;
begin
  Result := nil;

  if (ender.endNac.CEP <> '') or (ender.endExt.cEndPost <> '') then
  begin
    Result := CreateElement('Endereco');

    Result.AppendChild(AddNode(tcStr, '#1', 'Cep', 8, 8, 0,
                                                         ender.endNac.CEP, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Logradouro', 1, 255, 0,
                                                               ender.xLgr, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Numero', 1, 60, 0, ender.nro, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Bairro', 1, 60, 0,
                                                            ender.xBairro, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Complemento', 1, 156, 0,
                                                               ender.xCpl, ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'CodigoPais', 4, 4, 0,
                                                       ender.endExt.cPais, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Uf', 2, 2, 0, ender.Uf, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'DescricaoMunicipio', 1, 100, 0,
                                                 ender.DescricaoMunicipio, ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'CodigoMunicipio', 7, 7, 0,
                                                        ender.endNac.cMun, ''));
  end;
end;

function TNFSeW_Publica.GerarImovel: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.IBSCBS.Imovel.cCIB <> '') or (NFSe.IBSCBS.Imovel.ender.CEP <> '') or
     (NFSe.IBSCBS.Imovel.ender.endExt.cEndPost <> '') then
  begin
    Result := CreateElement('Imovel');

    if NFSe.IBSCBS.Imovel.ender.endExt.cEndPost <> '' then
      Result.AppendChild(AddNode(tcStr, '#1', 'TipoImovel', 1, 1, 0, '2', ''))
    else
      Result.AppendChild(AddNode(tcStr, '#1', 'TipoImovel', 1, 1, 0, '1', ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'InscImob', 1, 30, 0,
                                          NFSe.IBSCBS.Imovel.inscImobFisc, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'CIB', 1, 8, 0,
                                                  NFSe.IBSCBS.Imovel.cCIB, ''));

    Result.AppendChild(GerarEnderecoImovel(NFSe.IBSCBS.Imovel.ender));
  end;
end;

function TNFSeW_Publica.GerarEnderecoImovel(ender: TenderImovel): TACBrXmlNode;
begin
  Result := nil;

  if (ender.CEP <> '') or (ender.endExt.cEndPost <> '') then
  begin
    Result := CreateElement('Endereco');

    Result.AppendChild(AddNode(tcStr, '#1', 'Cep', 8, 8, 0, ender.CEP, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Logradouro', 1, 255, 0,
                                                               ender.xLgr, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Numero', 1, 60, 0, ender.nro, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Bairro', 1, 60, 0,
                                                            ender.xBairro, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Complemento', 1, 156, 0,
                                                               ender.xCpl, ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'CodigoPais', 4, 4, 0,
                                                       ender.endExt.cPais, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'Uf', 2, 2, 0,
                                                                 ender.Uf, ''));

    Result.AppendChild(AddNode(tcStr, '#1', 'DescricaoMunicipio', 1, 100, 0,
                                                 ender.DescricaoMunicipio, ''));

    Result.AppendChild(AddNode(tcInt, '#1', 'CodigoMunicipio', 7, 7, 0,
                                                    ender.CodigoMunicipio, ''));
  end;
end;

function TNFSeW_Publica.GerarValores: TACBrXmlNode;
begin
  Result := inherited GerarValores;

  Result.AppendChild(AddNode(tcStr, '#1', 'UnidadeServico', 1, 5, 0,
                                      NFSe.Servico.Valores.UnidadeServico, ''));

  Result.AppendChild(GerarTributosFederais);

  if NFSe.Servico.Valores.tribMun.tribISSQN = tiImunidade then
    Result.AppendChild(GerartribMun);
end;

function TNFSeW_Publica.GerarTributosFederais: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.Servico.Valores.tribFed.vRetCP > 0) or
     (NFSe.Servico.Valores.tribFed.vRetIRRF > 0) or
     (NFSe.Servico.Valores.tribFed.vRetCSLL > 0) or
     (NFSe.Servico.Valores.tribFed.CST <> cstVazio) then
  begin
    Result := CreateElement('TributosFederais');

    if NFSe.Servico.Valores.tribFed.CST <> cstVazio then
      Result.AppendChild(GerarPisCofins);
    {
    Result.AppendChild(AddNode(tcDe2, '#1', 'vRetCP', 1, 15, 0,
                                      NFSe.Servico.Valores.tribFed.vRetCP, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vRetIRRF', 1, 15, 0,
                                    NFSe.Servico.Valores.tribFed.vRetIRRF, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vRetCSLL', 1, 15, 0,
                                    NFSe.Servico.Valores.tribFed.vRetCSLL, ''));
    }
  end;
end;

function TNFSeW_Publica.GerarPisCofins: TACBrXmlNode;
var
  NOcorr: Integer;
begin
  Result := CreateElement('PisCofins');

  Result.AppendChild(AddNode(tcStr, '#1', 'CST', 2, 2, 1,
                               CSTToStr(NFSe.Servico.Valores.tribFed.CST), ''));

  if (NFSe.Servico.Valores.tribFed.vBCPisCofins > 0) or
     (NFSe.Servico.Valores.tribFed.pAliqPis > 0) or
     (NFSe.Servico.Valores.tribFed.pAliqCofins > 0) or
     (NFSe.Servico.Valores.tribFed.vPis > 0) or
     (NFSe.Servico.Valores.tribFed.vCofins > 0) or
     (NFSe.Servico.Valores.tribFed.CST in [cst04, cst06]) then
  begin
    NOcorr := 0;

    if NFSe.Servico.Valores.tribFed.CST in [cst04, cst06] then
      NOcorr := 1;

    Result.AppendChild(AddNode(tcDe2, '#1', 'ValorBaseCalculoPisCofins', 1, 15, 0,
                                NFSe.Servico.Valores.tribFed.vBCPisCofins, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'PercentualAliquotaPis', 1, 5, NOcorr,
                                    NFSe.Servico.Valores.tribFed.pAliqPis, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'PercentualAliquotaCofins', 1, 5, NOcorr,
                                 NFSe.Servico.Valores.tribFed.pAliqCofins, ''));
{
    Result.AppendChild(AddNode(tcDe2, '#1', 'vPis', 1, 15, NOcorr,
                                        NFSe.Servico.Valores.tribFed.vPis, ''));

    Result.AppendChild(AddNode(tcDe2, '#1', 'vCofins', 1, 15, NOcorr,
                                     NFSe.Servico.Valores.tribFed.vCofins, ''));
}
    Result.AppendChild(AddNode(tcStr, '#1', 'TipoRetencaoPisCofins', 1, 1, 0,
         tpRetPisCofinsToStr(NFSe.Servico.Valores.tribFed.tpRetPisCofins), ''));
  end;
end;

function TNFSeW_Publica.GerartribMun: TACBrXmlNode;
begin
  Result := CreateElement('tribMun');

  Result.AppendChild(AddNode(tcStr, '#1', 'tpImunidade', 1, 1, 0,
               tpImunidadeToStr(NFSe.Servico.Valores.tribMun.tpImunidade), ''));
end;

function TNFSeW_Publica.GerarServico: TACBrXmlNode;
begin
  Result := inherited GerarServico;

  Result.AppendChild(AddNode(tcInt, '#1', 'CodigoMunicipioLocalPestacao', 7, 7, 0,
                               NFSe.Servico.CodigoMunicipioLocalPrestacao, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cNBS', 1, 10, 0,
                                                   NFSe.Servico.CodigoNBS, ''));
end;

function TNFSeW_Publica.GerarConstrucaoCivil: TACBrXmlNode;
var
  NodeEnd: TACBrXmlNode;
begin
  Result := nil;

  with NFSe.ConstrucaoCivil do
  begin
    // só gera se tiver Tipo válido
    if not (Tipo in [1, 2]) then
      Exit;

    Result := CreateElement('ConstrucaoCivil');

    // 1) TipoIdentificacaoObra (1 = Endereço, 2 = CNO/CEI)
    Result.AppendChild(AddNode(tcStr, '#51', 'TipoIdentificacaoObra', 1, 1, 1,
                                                              Tipo, DSC_TOBRA));

    // ============================
    // Tipo = 2  -> CNO / CEI
    // ============================
    if (Tipo = 2) then
    begin
      if Trim(CodigoObra) <> '' then
        Result.AppendChild(AddNode(tcStr, '#52', 'CodigoObra', 1, 15, 1,
                                                        CodigoObra, DSC_COBRA));
    end;

    // ============================
    // Tipo = 1 -> Endereço completo
    // ============================
    if (Tipo = 1) then
    begin
      if (Trim(Endereco.CEP) <> '') or (Trim(Endereco.Endereco) <> '') then
      begin
        NodeEnd := CreateElement('EnderecoCompleto');
        Result.AppendChild(NodeEnd);

        // aqui usei os mesmos padrões que o ACBr costuma usar
        NodeEnd.AppendChild(AddNode(tcStr, '#60', 'Cep', 8, 8, 1,
                                                    Endereco.CEP, DSC_CEPOBRA));

        NodeEnd.AppendChild(AddNode(tcStr, '#61', 'Logradouro', 1, 125, 1,
                                                 Endereco.Endereco, DSC_EOBRA));

        NodeEnd.AppendChild(AddNode(tcStr, '#62', 'Numero', 1, 10, 1,
                                                  Endereco.Numero, DSC_NEOBRA));

        NodeEnd.AppendChild(AddNode(tcStr, '#63', 'Bairro', 1, 60, 1,
                                                  Endereco.Bairro, DSC_BEOBRA));

        NodeEnd.AppendChild(AddNode(tcStr, '#64', 'CodigoMunicipio', 1, 7, 1,
                                     Endereco.CodigoMunicipio, DSC_CODMUNOBRA));

        NodeEnd.AppendChild(AddNode(tcStr, '#65', 'Complemento', 0, 60, 0,
                                             Endereco.Complemento, DSC_CEOBRA));

        NodeEnd.AppendChild(AddNode(tcStr, '#66', 'Uf', 2, 2, 1,
                                                      Endereco.UF, DSC_UFOBRA));

        NodeEnd.AppendChild(AddNode(tcStr, '#67', 'CodigoPais', 8, 8, 1,
                                                          '1055', DSC_CEPOBRA));
      end;
    end;

    // 3) (comum para os dois tipos, se informado)
    if Trim(Art) <> '' then
      Result.AppendChild(AddNode(tcStr, '#53', 'Art', 1, 15, 1,
                                                                 Art, DSC_ART));

    If Trim(inscImobFisc) <> '' then
      Result.AppendChild(AddNode(tcStr, '#54', 'InscImob', 1, 60, 1,
                                                    inscImobFisc, DSC_INSCMOB));
  end;
end;

procedure TNFSeW_Publica.GerarINISecaoParcelas(const AINIRec: TMemIniFile);
var
  I: Integer;
  sSecao: string;
begin
  for I := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
  begin
    sSecao:= 'Parcelas' + IntToStrZero(I + 1, 2);

    AINIRec.WriteString(sSecao, 'Parcela', NFSe.CondicaoPagamento.Parcelas.Items[I].Parcela);
    AINIRec.WriteDate(sSecao, 'DataVencimento', NFSe.CondicaoPagamento.Parcelas.Items[I].DataVencimento);
    AINIRec.WriteFloat(sSecao, 'Valor', NFSe.CondicaoPagamento.Parcelas.Items[I].Valor);
    AINIRec.WriteString(sSecao, 'Condicao', FpAOwner.CondicaoPagToStr(NFSe.CondicaoPagamento.Parcelas.Items[I].Condicao));
  end;
end;

end.
