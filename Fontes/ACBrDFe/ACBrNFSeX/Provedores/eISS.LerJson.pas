{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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

unit eISS.LerJson;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrUtil.Base, ACBrUtil.Strings,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass,
  ACBrNFSeXConversao, ACBrNFSeXLerXml, ACBrJSON;

type
  { Provedor com layout pr�prio }
  { TNFSeR_eISS }

  TNFSeR_eISS = class(TNFSeRClass)
  protected
    procedure LerNota(aJson: TACBrJSONObject; FRps: Boolean);
    procedure LerSituacaoNfse(aJson: TACBrJSONObject);
    procedure LerIdentificacaoPrestador(aJson: TACBrJSONObject);
    procedure LerPrestador(aJson: TACBrJSONObject);
    procedure LerTomador(aJson: TACBrJSONObject);
    procedure LerEndereco(aJson: TACBrJSONObject; aEndereco: TEndereco);
    procedure LerContato(aJson: TACBrJSONObject; aContato: TContato);
    procedure LerRps(aJson: TACBrJSONObject);
    procedure LerServicos(aJson: TACBrJSONObject);

  public
    function LerXml: Boolean; override;
    function LerJsonNfse(const ArquivoRetorno: String): Boolean;
    function LerJsonRps(const ArquivoRetorno: String): Boolean;
  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o Json do provedor:
//     eISS
//==============================================================================

{ TNFSeR_eISS }

function TNFSeR_eISS.LerXml: Boolean;
begin
  if EstaVazio(Arquivo) then
    raise Exception.Create('Arquivo Json n�o carregado.');

  if (Pos('DadosNfse', Arquivo) > 0) then
    Result := LerJsonNfse(TiraAcentos(Arquivo))
  else
    Result := LerJsonRps(TiraAcentos(Arquivo));

  NFSe.tpXML := tpXml;
end;

function TNFSeR_eISS.LerJsonNfse(const ArquivoRetorno: String): Boolean;
var
  jsRet: TACBrJSONObject;
begin
  Result := False;
  tpXML := txmlNFSe;

  try
    jsRet := TACBrJSONObject.Parse(String(ArquivoRetorno));

    if Assigned(jsRet.AsJSONObject['DadosNfse']) then
    begin
      LerNota(jsRet.AsJSONObject['DadosNfse'], False);
      LerPrestador(jsRet.AsJSONObject['DadosNfse']);
      LerTomador(jsRet.AsJSONObject['DadosNfse']);
      LerRps(jsRet.AsJSONObject['DadosNfse']);
      LerServicos(jsRet.AsJSONObject['DadosNfse']);

      Result := True;
    end;
  finally
    jsRet.Free;
  end;
end;

function TNFSeR_eISS.LerJsonRps(const ArquivoRetorno: String): Boolean;
var
  jsRet: TACBrJSONObject;
begin
  Result := False;
  tpXML := txmlRPS;

  try
    jsRet := TACBrJSONObject.Parse(String(ArquivoRetorno));

    if Assigned(jsRet.AsJSONObject['DadosNota']) then
    begin
      LerNota(jsRet.AsJSONObject['DadosNota'], True);
      LerIdentificacaoPrestador(jsRet.AsJSONObject['DadosNota']);
      LerTomador(jsRet.AsJSONObject['DadosNota']);
      LerRps(jsRet.AsJSONObject['DadosNota']);
      LerServicos(jsRet.AsJSONObject['DadosNota']);

      Result := True;
    end;
  finally
    jsRet.Free;
  end;
end;

procedure TNFSeR_eISS.LerRps(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
begin
  jsAux := aJson.AsJSONObject['Rps'];

  if Assigned(jsAux) then
  begin
    NFSe.DataEmissaoRps := jsAux.AsISODate['DataEmissao'];

    with NFSe.IdentificacaoRps do
    begin
      Numero := jsAux.AsString['Numero'];
      Serie := jsAux.AsString['Serie'];
    end;
  end;
end;

procedure TNFSeR_eISS.LerNota(aJson: TACBrJSONObject; FRps: Boolean);
var
  jsAux: TACBrJSONObject;
  OK: Boolean;
begin
  if Assigned(aJson) then
  begin
    with NFSe do
    begin
      Servico.CodigoMunicipio := aJson.AsString['MunicipioPrestacao'];

      if (FRps) then
      begin
        NaturezaOperacao := StrToNaturezaOperacao(OK, aJson.AsString['NaturezaOperacao']);
        jsAux := aJson.AsJSONObject['Atividade'];

        if Assigned(jsAux) then
        begin
          Servico.CodigoTributacaoMunicipio := jsAux.AsString['Codigo'];
          Servico.CodigoCnae := jsAux.AsString['CodigoCnae'];
          Servico.ItemListaServico := jsAux.AsString['CodigoLc116'];
        end;
      end
      else
      begin
        Numero := aJson.AsString['NumeroNfse'];
        CodigoVerificacao := aJson.AsString['CodigoValidacao'];
        Link := aJson.AsString['LinkNfse'];
        Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);

        jsAux := aJson.AsJSONObject['Rps'];

        if Assigned(jsAux) then
          SeriePrestacao := jsAux.AsString['Serie'];

        DataEmissao := aJson.AsISODateTime['DataEmissao'];
        Competencia := aJson.AsISODate['Competencia'];

        LerSituacaoNfse(aJson);
      end;

      OutrasInformacoes := aJson.AsString['Observacoes'];
      OutrasInformacoes := StringReplace(OutrasInformacoes, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

      jsAux := aJson.AsJSONObject['Valores'];

      if Assigned(jsAux) then
      begin
        if (aJson.AsString['IssRetido'] = 'N') then
          Servico.Valores.IssRetido := stNormal
        else
          Servico.Valores.IssRetido := stRetencao;

        Servico.Valores.ValorServicos := jsAux.AsFloat['ValorServicos'];
        Servico.Valores.ValorDeducoes := jsAux.AsFloat['ValorDeducoes'];
        Servico.Valores.ValorPis := jsAux.AsFloat['ValorPis'];
        Servico.Valores.ValorCofins := jsAux.AsFloat['ValorCofins'];
        Servico.Valores.ValorInss := jsAux.AsFloat['ValorInss'];
        Servico.Valores.ValorIr := jsAux.AsFloat['ValorIr'];
        Servico.Valores.ValorCsll := jsAux.AsFloat['ValorCsll'];
        Servico.Valores.OutrasRetencoes := jsAux.AsFloat['OutrasRetencoes'];
        Servico.Valores.DescontoIncondicionado := jsAux.AsFloat['DescontoIncondicionado'];
        Servico.Valores.DescontoCondicionado := jsAux.AsFloat['DescontoCondicionado'];
        Servico.Valores.BaseCalculo := jsAux.AsFloat['BaseCalculo'];
        Servico.Valores.Aliquota := jsAux.AsFloat['Aliquota'];
        Servico.Valores.ValorIss := jsAux.AsFloat['ValorIss'];
        Servico.Valores.ValorTotalTributos := jsAux.AsFloat['ValorTotalTributos'];
        ValorCredito := jsAux.AsFloat['ValorCredito'];

        Servico.Valores.RetencoesFederais := Servico.Valores.ValorPis +
          Servico.Valores.ValorCofins + Servico.Valores.ValorInss +
          Servico.Valores.ValorIr + Servico.Valores.ValorCsll;

        Servico.Valores.ValorLiquidoNfse := Servico.Valores.ValorServicos -
          (Servico.Valores.RetencoesFederais + Servico.Valores.ValorDeducoes +
           Servico.Valores.DescontoCondicionado + Servico.Valores.DescontoIncondicionado +
           Servico.Valores.ValorIssRetido);

        Servico.Valores.ValorTotalNotaFiscal := Servico.Valores.ValorServicos -
          Servico.Valores.DescontoCondicionado - Servico.Valores.DescontoIncondicionado;
      end;
    end;
  end;
end;

procedure TNFSeR_eISS.LerSituacaoNfse(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
begin
  jsAux := aJson.AsJSONObject['Cancelamento'];

  if Assigned(jsAux) then
  begin
    NFSe.Situacao := StrToIntDef(aJson.AsString['SituacaoNfse'], 0);

    case NFSe.Situacao of
      -2:
        begin
          NFSe.SituacaoNfse := snCancelado;
          NFSe.MotivoCancelamento := aJson.AsString['Motivo'];
        end;
      -8: NFSe.SituacaoNfse := snNormal;
    end;
  end;
end;

procedure TNFSeR_eISS.LerIdentificacaoPrestador(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
begin
  jsAux := aJson.AsJSONObject['Prestador'];

  if Assigned(jsAux) then
  begin
    NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal := jsAux.AsString['InscricaoMunicipal'];
  end;
end;

procedure TNFSeR_eISS.LerPrestador(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
begin
  jsAux := aJson.AsJSONObject['Prestador'];

  if Assigned(jsAux) then
  begin
    with NFSe.Prestador do
    begin
      RazaoSocial := jsAux.AsString['RazaoSocial'];
      NomeFantasia := jsAux.AsString['NomeFantasia'];

      IdentificacaoPrestador.CpfCnpj := OnlyNumber(jsAux.AsString['Cnpj']);
      IdentificacaoPrestador.CpfCnpj := PadLeft(IdentificacaoPrestador.CpfCnpj, 14, '0');
      IdentificacaoPrestador.InscricaoMunicipal := jsAux.AsString['InscricaoMunicipal'];

      LerEndereco(jsAux, Endereco);
      LerContato(jsAux, Contato);
    end;
  end;
end;

procedure TNFSeR_eISS.LerTomador(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
  aValor: string;
begin
  jsAux := aJson.AsJSONObject['Tomador'];

  if Assigned(jsAux) then
  begin
    with NFSe.Tomador do
    begin
      RazaoSocial := jsAux.AsString['RazaoSocial'];
      NomeFantasia := jsAux.AsString['NomeFantasia'];

      IdentificacaoTomador.CpfCnpj := OnlyNumber(jsAux.AsString['NrDocumento']);
      aValor  := jsAux.AsString['TipoPessoa'];

      if ((aValor = 'J') or (aValor = '2')) then
      begin
        IdentificacaoTomador.CpfCnpj := PadLeft(IdentificacaoTomador.CpfCnpj, 14, '0');
      end
      else
      begin
        IdentificacaoTomador.CpfCnpj := PadLeft(IdentificacaoTomador.CpfCnpj, 11, '0');
        IdentificacaoTomador.Tipo := tpPF;
      end;

      LerEndereco(jsAux, Endereco);
      LerContato(jsAux, Contato);

      if Endereco.CodigoMunicipio = NFSe.Prestador.Endereco.CodigoMunicipio then
        IdentificacaoTomador.Tipo := tpPJdoMunicipio
      else
        IdentificacaoTomador.Tipo := tpPJforaMunicipio;
    end;
  end;
end;

procedure TNFSeR_eISS.LerEndereco(aJson: TACBrJSONObject; aEndereco: TEndereco);
var
  jsAux: TACBrJSONObject;
  xUF: string;
begin
  jsAux := aJson.AsJSONObject['Endereco'];

  if Assigned(jsAux) then
  begin
    aEndereco.Endereco := jsAux.AsString['Logradouro'];
    aEndereco.Numero := jsAux.AsString['Numero'];
    aEndereco.Complemento := jsAux.AsString['Complemento'];
    aEndereco.Bairro := jsAux.AsString['Bairro'];

    aEndereco.CodigoMunicipio := jsAux.AsString['Municipio'];
    aEndereco.CodigoMunicipio := NormatizarCodigoMunicipio(aEndereco.CodigoMunicipio);

    aEndereco.xMunicipio := ObterNomeMunicipioUF(StrToIntDef(aEndereco.CodigoMunicipio, 0), xUF);

    if aEndereco.UF = '' then
      aEndereco.UF := xUF;

    aEndereco.CEP := jsAux.AsString['Cep'];
  end;
end;

procedure TNFSeR_eISS.LerContato(aJson: TACBrJSONObject; aContato: TContato);
var
  jsAux: TACBrJSONObject;
begin
  jsAux := aJson.AsJSONObject['Contato'];

  if Assigned(jsAux) then
  begin
    aContato.Telefone := jsAux.AsString['Telefone'];
    aContato.Email := jsAux.AsString['Email'];
  end;
end;

procedure TNFSeR_eISS.LerServicos(aJson: TACBrJSONObject);
var
  jsAux: TACBrJSONObject;
  jsArr: TACBrJSONArray;
  i: Integer;
begin
  jsArr := aJson.AsJSONArray['Servicos'];

  if Assigned(jsArr) then
  begin
    for i := 0 to jsArr.Count - 1 do
    begin
      jsAux := jsArr.ItemAsJSONObject[i];

      NFSe.Servico.ItemServico.New;
      with NFSe.Servico.ItemServico[i] do
      begin
        Unidade := jsAux.AsString['Unidade'];
        Descricao := jsAux.AsString['Descricao'];
        Descricao := StringReplace(Descricao, FpQuebradeLinha,
                                      sLineBreak, [rfReplaceAll, rfIgnoreCase]);
        Quantidade := jsAux.AsFloat['Quantidade'];
        ValorUnitario := jsAux.AsCurrency['ValorUnitario'];
        ValorTotal := ValorUnitario * Quantidade;
      end;
    end;
  end;
end;

end.
