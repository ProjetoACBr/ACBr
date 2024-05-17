{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Jos� M S Junior                                }
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

unit ACBrBoletoConversao;

interface

uses
  Classes, SysUtils, StrUtils;

type

  TACBrResponEmissao = (tbCliEmite,tbBancoEmite,tbBancoReemite,tbBancoNaoReemite, tbBancoPreEmite);
  TACBrCaracTitulo = (tcSimples, tcVinculada, tcCaucionada, tcDescontada, tcVendor, tcDireta,
                      tcSimplesRapComReg, tcCaucionadaRapComReg, tcDiretaEspecial);
  TACBrPessoa = (pFisica,pJuridica,pOutras, pNenhum);
  TACBrPessoaCedente = pFisica..pJuridica;
  TACBrBolLayOut = (lPadrao, lCarne, lFatura, lPadraoEntrega, lReciboTopo, lPadraoEntrega2, lFaturaDetal, lTermica80mm, lPadraoPIX, lPrestaServicos, lCarneA5);

  {Aceite do titulo}
  TACBrAceiteTitulo = (atSim, atNao);

  {TipoDiasIntrucao}
  TACBrTipoDiasIntrucao = (diCorridos, diUteis);

  {Com essa propriedade � possivel ter apenas um cedente para gerar remessa de bloquetos de impressao normal e/ou carne na mesma remessa - Para Sicredi}
  {TipoImpressao}
  TACBrTipoImpressao = (tipCarne, tipNormal);
  TACBrTipoDocumento = (Tradicional=1, Escritural=2);

  {Define se a carteira � Cobran�a Simples / Registrada}
  TACBrTipoCarteira = (tctSimples, tctRegistrada, tctEletronica);

  {Definir como o boleto vai ser gerado/enviado pelo Cedente ou pelo Banco via correio ou Banco via email }
  TACBrCarteiraEnvio = (tceCedente, tceBanco, tceBancoEmail);

  {Definir codigo Desconto }
  TACBrCodigoDesconto    = (cdSemDesconto, cdValorFixo, cdPercentual);

  {Definir codigo Juros }
  TACBrCodigoJuros       = (cjValorDia, cjTaxaMensal, cjIsento, cjValorMensal, cjTaxaDiaria);

  {Definir codigo Multa }
  TACBrCodigoMulta       = (cmValorFixo, cmPercentual, cmIsento);

  {Definir se o titulo ser� protestado, n�o protestado ou negativado }
  TACBrCodigoNegativacao = (cnNenhum, cnProtestarCorrido, cnProtestarUteis, cnNaoProtestar, cnNegativar, cnNaoNegativar, cnCancelamento, cnNegativarUteis);

  {Definir Tipo de Opera��o para Registro de Cobran�a via WebService}
  TOperacao = (tpInclui, tpAltera, tpBaixa, tpConsulta, tpConsultaDetalhe, tpPIXCriar, tpPIXCancelar, tpPIXConsultar, tpCancelar, tpTicket);

  {Definir Tipo de Pagamento Aceito para Registro de Cobran�a via WebService }
  TTipo_Pagamento = (tpAceita_Qualquer_Valor, tpAceita_Valores_entre_Minimo_Maximo,
                     tpNao_Aceita_Valor_Divergente, tpSomente_Valor_Minimo);

    { Situa��o do boleto. Campo obrigatoriamente MAI�SCULO. Dom�nios: A - Em ser B - Baixados/Protestados/Liquidados }
  TACBrIndicadorSituacaoBoleto    = (isbNenhum,isbAberto,isbBaixado,isbCancelado);

  { Indica se o Boleto est� vencido ou n�o. Campo obrigatoriamente MAI�SCULO. Dom�nio: S para boletos vencidos N para boletos n�o vencidos }
  TACBrIndicadorBoletoVencido     = (ibvNenhum,ibvNao,ibvSim);

  {Definir Metodo HTTP}
  TMetodoHTTP = (htPOST, htGET, htPATCH, htPUT, htDELETE);

  {Type Generico para passar parametros para Body e Header das requisicoes}
  TParams = record
    prName,PrValue:String;
  end;
  function StrToTipoOperacao(out ok: Boolean; const s: String): TOperacao;
  function TipoOperacaoToStr(const t: TOperacao): String;

  function StrToTipoJuros(out ok: Boolean; const s: String): TACBrCodigoJuros;
  function TipoJurosToStr(const t: TACBrCodigoJuros): String;

  function StrToTipoNegativacao(out ok: Boolean; const s: String): TACBrCodigoNegativacao;
  function TipoNegativacaoToStr(const t: TACBrCodigoNegativacao): String;

  function StrToTipoPagamento(out ok: Boolean; const s: String): TTipo_Pagamento;
  function TipoPagamentoToStr(const t: TTipo_Pagamento): String;

  function StrToAceite(out ok: Boolean; const s: String): TACBrAceiteTitulo;
  function AceiteToStr(const t: TACBrAceiteTitulo): String;

  function StrToMetodoHTTP(out ok: Boolean; const s: String): TMetodoHTTP;
  function MetodoHTTPToStr(const t: TMetodoHTTP): String;

const
  CFormatoDataPadrao = 'ddmmyyyy';
  S_MIME_TYPE = 'text/xml';
  S_CONTENT_TYPE= 'text/xml; charset=utf-8';
  S_SOAP_VERSION = 'soapenv';

implementation

uses
  pcnConversao;

function StrToTipoOperacao(out ok: Boolean; const s: String): TOperacao;
begin
  Result := StrToEnumerado(ok, s, ['INCLUI_BOLETO', 'ALTERA_BOLETO','BAIXA_BOLETO','CONSULTA_BOLETO','GERA_TICKET',
                                   'CONSULTA_BOLETO_DETALHE','PIX_CRIAR', 'PIX_CANCELAR', 'PIX_CONSULTAR', 'CANCELAR_BOLETO'],
         [tpInclui, tpAltera, tpBaixa, tpConsulta, tpTicket, tpConsultaDetalhe, tpPIXCriar, tpPIXCancelar, tpPIXConsultar, tpCancelar]);
end;

function TipoOperacaoToStr(const t: TOperacao): String;
begin
  Result := EnumeradoToStr(t, ['INCLUI_BOLETO', 'ALTERA_BOLETO', 'BAIXA_BOLETO', 'CONSULTA_BOLETO','GERA_TICKET',
                               'CONSULTA_BOLETO_DETALHE','PIX_CRIAR', 'PIX_CANCELAR', 'PIX_CONSULTAR', 'CANCELAR_BOLETO'],
         [tpInclui, tpAltera, tpBaixa, tpConsulta, tpTicket, tpConsultaDetalhe, tpPIXCriar, tpPIXCancelar, tpPIXConsultar, tpCancelar]);
end;

function StrToTipoJuros(out ok: Boolean; const s: String): TACBrCodigoJuros;
begin
  Result := StrToEnumerado(ok, s, ['VALOR_POR_DIA', 'TAXA_MENSAL', 'ISENTO','VALOR_MENSAL','TAXA_DIARIA'],
                                  [cjValorDia, cjTaxaMensal, cjIsento, cjValorMensal, cjTaxaDiaria]);
end;

function TipoJurosToStr(const t: TACBrCodigoJuros): String;
begin
  Result := EnumeradoToStr(t, ['VALOR_POR_DIA', 'TAXA_MENSAL', 'ISENTO','VALOR_MENSAL','TAXA_DIARIA'],
                              [cjValorDia, cjTaxaMensal, cjIsento, cjValorMensal, cjTaxaDiaria]);

end;

function StrToTipoNegativacao(out ok: Boolean; const s: String
  ): TACBrCodigoNegativacao;
begin
  Result := StrToEnumerado(ok, s, ['NENHUM','PROTESTAR'       ,'PROTESTAR_UTEIS','DEVOLVER'    ,'NEGATIVAR','NAO_NEGATIVAR','CANCELAMENTO','NEGATIVAR_UTEIS'],
                                  [cnNenhum,cnProtestarCorrido,cnProtestarUteis ,cnNaoProtestar,cnNegativar,cnNaoNegativar ,cnCancelamento,cnNegativarUteis]);


end;

function TipoNegativacaoToStr(const t: TACBrCodigoNegativacao): String;
begin
  Result := EnumeradoToStr(t, ['NENHUM', 'PROTESTAR'       ,'PROTESTAR_UTEIS','DEVOLVER'     ,'NEGATIVAR' ,'NAO_NEGATIVAR','CANCELAMENTO', 'NEGATIVAR_UTEIS'],
                              [cnNenhum, cnProtestarCorrido, cnProtestarUteis, cnNaoProtestar, cnNegativar, cnNaoNegativar ,cnCancelamento, cnNegativarUteis]);

end;

function StrToTipoPagamento(out ok: Boolean; const s: String): TTipo_Pagamento;
begin
  Result := StrToEnumerado(ok, s, ['ACEITA_QUALQUER_VALOR',
                                   'ACEITA_VALORES_ENTRE_MINIMO_MAXIMO',
                                   'NAO_ACEITA_VALOR_DIVERGENTE',
                                   'SOMENTE_VALOR_MINIMO'],
                 [tpAceita_Qualquer_Valor, tpAceita_Valores_entre_Minimo_Maximo,
                  tpNao_Aceita_Valor_Divergente, tpSomente_Valor_Minimo]);
end;

function TipoPagamentoToStr(const t: TTipo_Pagamento): String;
begin
  Result := EnumeradoToStr(t, ['ACEITA_QUALQUER_VALOR',
                               'ACEITA_VALORES_ENTRE_MINIMO_MAXIMO',
                               'NAO_ACEITA_VALOR_DIVERGENTE',
                               'SOMENTE_VALOR_MINIMO'],
                 [tpAceita_Qualquer_Valor, tpAceita_Valores_entre_Minimo_Maximo,
                  tpNao_Aceita_Valor_Divergente, tpSomente_Valor_Minimo]);
end;

function StrToAceite(out ok: Boolean; const s: String): TACBrAceiteTitulo;
begin
  Result := StrToEnumerado(ok, s, ['S', 'N'],
                                  [atSim, atNao]);
end;

function AceiteToStr(const t: TACBrAceiteTitulo): String;
begin
  Result := EnumeradoToStr(t, ['S', 'N'],
                              [atSim, atNao]);
end;

function StrToMetodoHTTP(out ok: Boolean; const s: String): TMetodoHTTP;
begin
  Result := StrToEnumerado(ok, s, ['POST', 'GET', 'PATCH', 'PUT', 'DELETE'],
                                  [htPOST, htGET, htPATCH, htPUT, htDELETE]);
end;

function MetodoHTTPToStr(const t: TMetodoHTTP): String;
begin
  Result := EnumeradoToStr(t, ['POST', 'GET', 'PATCH', 'PUT', 'DELETE'],
                              [htPOST, htGET, htPATCH, htPUT, htDELETE]);
end;


end.

