{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Renato Tanchela Rubinho                         }
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

unit Prescon.GravarJson;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrJSON,
  ACBrNFSeXGravarXml;

type
  { TNFSeW_Prescon }

  TNFSeW_Prescon = class(TNFSeWClass)
  protected
    procedure Configuracao; override;

    function GerarDadosNota: String;
  public
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrConsts,
  ACBrNFSeXConversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o Json do RPS do provedor:
//     Prescon
//==============================================================================

{ TNFSeW_Prescon }

procedure TNFSeW_Prescon.Configuracao;
begin
  inherited Configuracao;

  FormatoItemListaServico := filsSemFormatacaoSemZeroEsquerda;
end;

function TNFSeW_Prescon.GerarXml: Boolean;
begin
  Configuracao;

  Opcoes.QuebraLinha := FpAOwner.ConfigGeral.QuebradeLinha;

  ListaDeAlertas.Clear;

  FDocument.Clear;

  FConteudoTxt.Clear;

  {$IFDEF FPC}
  FConteudoTxt.LineBreak := CRLF;
  {$ELSE}
    {$IFDEF DELPHI2006_UP}
    FConteudoTxt.LineBreak := CRLF;
    {$ENDIF}
  {$ENDIF}

  FConteudoTxt.Text := GerarDadosNota;
  Result := True;
end;

function TNFSeW_Prescon.GerarDadosNota: String;
var
  LJSonArray: TACBrJSONArray;
  AJSon: TACBrJSONObject;
  tipoPessoa: String;
  issRetido: String;
  devidoNoLocal: String;
  tipoEnquadramento: String;
  deducaoMaterial: double;
  i: Integer;
begin
  case NFSe.Tomador.IdentificacaoTomador.Tipo of
    tpPF: tipoPessoa := 'F';
    tpPJforaPais: tipoPessoa := 'E';
  else
    tipoPessoa := 'J';
  end;

  if NFSe.Servico.Valores.IssRetido = stNormal then
  begin
    issRetido := '0';
    devidoNoLocal := '0';
  end
  else
  begin
    issRetido := '1';

    if (NFSe.Servico.ResponsavelRetencao = rtTomador) and
       (NFSe.Tomador.Endereco.CodigoMunicipio <> NFSe.Prestador.Endereco.CodigoMunicipio) then
      devidoNoLocal := '0'
    else
      devidoNoLocal := '1';
  end;

  if NFSe.OptanteSimplesNacional = snSim then
    tipoEnquadramento := 'N'
  else if NFSe.OptanteMEISimei = snSim then
    tipoEnquadramento := 'E'
  else
    tipoEnquadramento := '';

  deducaoMaterial := 0;
  if NFSe.DeducaoMateriais = snSim then
  begin
    for i:=0 to NFSe.Servico.Deducao.Count - 1 do
    begin
      if NFSe.Servico.Deducao.Items[i].TipoDeducao = tdMateriais then
      begin
        deducaoMaterial := NFSe.Servico.Deducao.Items[i].ValorDeduzir;
        break;
      end;
    end;
  end;  

  AJSon := TACBrJsonObject.Create;
  LJSonArray := TACBrJSONArray.Create;
  try
    AJSon
      .AddPair('im', NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal)
      .AddPair('NumeroNota', NFSe.Numero)
      .AddPairISODate('DataEmissao', NFSe.DataEmissao)
      .AddPair('NomeTomador', NFSe.Tomador.RazaoSocial)
      .AddPair('tipoDocTomador', tipoPessoa)
      .AddPair('documentoTomador', NFSe.Tomador.IdentificacaoTomador.CpfCnpj)
      .AddPair('InscricaoEstadualTomador', NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual)
      .AddPair('logradouroTomador', Trim(NFSe.Tomador.Endereco.TipoLogradouro + ' ' +
                                         NFSe.Tomador.Endereco.Endereco))
      .AddPair('numeroTomador', NFSe.Tomador.Endereco.Numero)
      .AddPair('complementoTomador', NFSe.Tomador.Endereco.Complemento)
      .AddPair('bairroTomador', NFSe.Tomador.Endereco.Bairro)
      .AddPair('cidadeTomador', NFSe.Tomador.Endereco.xMunicipio)
      .AddPair('ufTomador', NFSe.Tomador.Endereco.UF)
      .AddPair('PAISTomador', NFSe.Tomador.Endereco.xPais)
      .AddPair('emailTomador', NFSe.Tomador.Contato.Email)
      .AddPair('logradouroServico', Trim(NFSe.ConstrucaoCivil.Endereco.TipoLogradouro + ' ' +
                                         NFSe.ConstrucaoCivil.Endereco.Endereco))
      .AddPair('CEPTomador', NFSe.Tomador.Endereco.CEP)
      .AddPair('numeroServico', NFSe.ConstrucaoCivil.Endereco.Numero)
      .AddPair('complementoServico', NFSe.ConstrucaoCivil.Endereco.Complemento)
      .AddPair('bairroServico', NFSe.ConstrucaoCivil.Endereco.Bairro)
      .AddPair('cidadeServico', NFSe.ConstrucaoCivil.Endereco.xMunicipio)
      .AddPair('ufServico', NFSe.ConstrucaoCivil.Endereco.UF)
      .AddPair('issRetido', issRetido)
      .AddPair('devidoNoLocal', devidoNoLocal)
      .AddPair('observacao', NFSe.OutrasInformacoes)
      .AddPair('INSS', NFSe.Servico.Valores.ValorInss)
      .AddPair('IRPJ', NFSe.Servico.Valores.ValorIr)
      .AddPair('CSLL', NFSe.Servico.Valores.ValorCsll)
      .AddPair('COFINS', NFSe.Servico.Valores.ValorCofins)
      .AddPair('PISPASEP', NFSe.Servico.Valores.ValorPis)
      .AddPair('CEPServico', NFSe.ConstrucaoCivil.Endereco.CEP)
      .AddPair('PAISServico', NFSe.ConstrucaoCivil.Endereco.CodigoPais)
      .AddPair('descricao', NFSe.Servico.Discriminacao)
      .AddPair('atividade', FormatarItemServico(NFSe.Servico.ItemListaServico, FormatoItemListaServico))
      .AddPair('valor', NFSe.Servico.Valores.ValorServicos)
      .AddPair('aliquota', NFSe.Servico.Valores.Aliquota)
      .AddPair('deducaoMaterial', deducaoMaterial)
      .AddPair('descontoCondicional', NFSe.Servico.Valores.DescontoCondicionado)
      .AddPair('descontoIncondicional', NFSe.Servico.Valores.DescontoIncondicionado)
      .AddPair('valorDeducao', NFSe.Servico.Valores.ValorDeducoes)
      .AddPair('baseCalculo', NFSe.Servico.Valores.BaseCalculo)
      .AddPair('valorIss', NFSe.Servico.Valores.ValorIss)
      .AddPair('valorTotalNota', NFSe.Servico.Valores.ValorLiquidoNfse)
      .AddPair('tipoEnquadramento', tipoEnquadramento)
      .AddPair('tipoIss', 'F')
      .AddPair('hashMd5', '');

    LJSonArray
      .AddElementJSON( AJSon );

    Result := LJSonArray.ToJSON;
  finally
    LJSonArray.Free;
  end;
end;

end.
