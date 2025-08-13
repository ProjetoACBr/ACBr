{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  José M S Junior                                }
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

  {Com essa propriedade é possivel ter apenas um cedente para gerar remessa de bloquetos de impressao normal e/ou carne na mesma remessa - Para Sicredi}
  {TipoImpressao}
  TACBrTipoImpressao = (tipCarne, tipNormal);
  TACBrTipoDocumento = (Tradicional=1, Escritural=2);

  {Define se a carteira é Cobrança Simples / Registrada}
  TACBrTipoCarteira = (tctSimples, tctRegistrada, tctEletronica);

  {Definir como o boleto vai ser gerado/enviado pelo Cedente ou pelo Banco via correio ou Banco via email }
  TACBrCarteiraEnvio = (tceCedente, tceBanco, tceBancoEmail);

  {Definir codigo Desconto }
  TACBrCodigoDesconto    = (cdSemDesconto, cdValorFixo, cdPercentual);

  {Definir codigo Juros }
  TACBrCodigoJuros       = (cjValorDia, cjTaxaMensal, cjIsento, cjValorMensal, cjTaxaDiaria);

  {Definir codigo Multa }
  TACBrCodigoMulta       = (cmValorFixo, cmPercentual, cmIsento);

  {Definir se o titulo será protestado, não protestado ou negativado }
  TACBrCodigoNegativacao = (cnNenhum, cnProtestarCorrido, cnProtestarUteis, cnNaoProtestar, cnNegativar, cnNaoNegativar, cnCancelamento, cnNegativarUteis);

  {Definir Tipo de Operação para Registro de Cobrança via WebService}
  TOperacao = (tpInclui, tpAltera, tpBaixa, tpConsulta, tpConsultaDetalhe, tpPIXCriar, tpPIXCancelar, tpPIXConsultar, tpCancelar, tpTicket);

  {Definir Tipo de Pagamento Aceito para Registro de Cobrança via WebService }
  TTipo_Pagamento = (tpAceita_Qualquer_Valor, tpAceita_Valores_entre_Minimo_Maximo,
                     tpNao_Aceita_Valor_Divergente, tpSomente_Valor_Minimo);

    { Situação do boleto. Campo obrigatoriamente MAIÚSCULO. Domínios: A - Em ser B - Baixados/Protestados/Liquidados }
  TACBrIndicadorSituacaoBoleto    = (isbNenhum,isbAberto,isbBaixado,isbCancelado);

  { Indica se o Boleto está vencido ou não. Campo obrigatoriamente MAIÚSCULO. Domínio: S para boletos vencidos N para boletos não vencidos }
  TACBrIndicadorBoletoVencido     = (ibvNenhum,ibvNao,ibvSim);

  {Definir Metodo HTTP}
  TMetodoHTTP = (htPOST, htGET, htPATCH, htPUT, htDELETE);

  {Tipo Ambiente WS Boleto}
  TTipoAmbienteWS = (tawsProducao, tawsHomologacao, tawsSandBox);


  {Type Generico para passar parametros para Body e Header das requisicoes}
  TParams = record
    prName,PrValue:String;
  end;
  type
    TACBrEBCDIC = record
      Codigo: string[5];
      Valor: string[2];
  end;
  const
  EBCDIC_TABELA: array[0..99] of TACBrEBCDIC = (
    (Codigo: 'nnWWn'; Valor: '00'), (Codigo: 'NnwwN'; Valor: '01'),
    (Codigo: 'nNwwN'; Valor: '02'), (Codigo: 'NNwwn'; Valor: '03'),
    (Codigo: 'nnWwN'; Valor: '04'), (Codigo: 'NnWwn'; Valor: '05'),
    (Codigo: 'nNWwn'; Valor: '06'), (Codigo: 'nnwWN'; Valor: '07'),
    (Codigo: 'NnwWn'; Valor: '08'), (Codigo: 'nNwWn'; Valor: '09'),

    (Codigo: 'wnNNw'; Valor: '10'), (Codigo: 'WnnnW'; Valor: '11'),
    (Codigo: 'wNnnW'; Valor: '12'), (Codigo: 'WNnnw'; Valor: '13'),
    (Codigo: 'wnNnW'; Valor: '14'), (Codigo: 'WnNnw'; Valor: '15'),
    (Codigo: 'wNNnw'; Valor: '16'), (Codigo: 'wnnNW'; Valor: '17'),
    (Codigo: 'WnnNw'; Valor: '18'), (Codigo: 'wNnNw'; Valor: '19'),

    (Codigo: 'nwNNw'; Valor: '20'), (Codigo: 'NwnnW'; Valor: '21'),
    (Codigo: 'nWnnW'; Valor: '22'), (Codigo: 'NWnnw'; Valor: '23'),
    (Codigo: 'nwNnW'; Valor: '24'), (Codigo: 'NwNnw'; Valor: '25'),
    (Codigo: 'nWNnw'; Valor: '26'), (Codigo: 'nwnNW'; Valor: '27'),
    (Codigo: 'NwnNw'; Valor: '28'), (Codigo: 'nWnNw'; Valor: '29'),

    (Codigo: 'wwNNn'; Valor: '30'), (Codigo: 'WwnnN'; Valor: '31'),
    (Codigo: 'wWnnN'; Valor: '32'), (Codigo: 'WWnnn'; Valor: '33'),
    (Codigo: 'wwNnN'; Valor: '34'), (Codigo: 'WwNnn'; Valor: '35'),
    (Codigo: 'wWNnn'; Valor: '36'), (Codigo: 'wwnNN'; Valor: '37'),
    (Codigo: 'WwnNn'; Valor: '38'), (Codigo: 'wWnNn'; Valor: '39'),

    (Codigo: 'nnWNw'; Valor: '40'), (Codigo: 'NnwnW'; Valor: '41'),
    (Codigo: 'nNwnW'; Valor: '42'), (Codigo: 'NNwnw'; Valor: '43'),
    (Codigo: 'nnWnW'; Valor: '44'), (Codigo: 'NnWnw'; Valor: '45'),
    (Codigo: 'nNWnw'; Valor: '46'), (Codigo: 'nnwNW'; Valor: '47'),
    (Codigo: 'NnwNw'; Valor: '48'), (Codigo: 'nNwNw'; Valor: '49'),

    (Codigo: 'wnWNn'; Valor: '50'), (Codigo: 'WnwnN'; Valor: '51'),
    (Codigo: 'wNwnN'; Valor: '52'), (Codigo: 'WNwnn'; Valor: '53'),
    (Codigo: 'wnWnN'; Valor: '54'), (Codigo: 'WnWnn'; Valor: '55'),
    (Codigo: 'wNWnn'; Valor: '56'), (Codigo: 'wnwNN'; Valor: '57'),
    (Codigo: 'WnwNn'; Valor: '58'), (Codigo: 'wNwNn'; Valor: '59'),

    (Codigo: 'nwWNn'; Valor: '60'), (Codigo: 'NwwnN'; Valor: '61'),
    (Codigo: 'nWwnN'; Valor: '62'), (Codigo: 'NWwnn'; Valor: '63'),
    (Codigo: 'nwWnN'; Valor: '64'), (Codigo: 'NwWnn'; Valor: '65'),
    (Codigo: 'nWWnn'; Valor: '66'), (Codigo: 'nwwNN'; Valor: '67'),
    (Codigo: 'NwwNn'; Valor: '68'), (Codigo: 'nWwNn'; Valor: '69'),

    (Codigo: 'nnNWw'; Valor: '70'), (Codigo: 'NnnwW'; Valor: '71'),
    (Codigo: 'nNnwW'; Valor: '72'), (Codigo: 'NNnww'; Valor: '73'),
    (Codigo: 'nnNwW'; Valor: '74'), (Codigo: 'NnNww'; Valor: '75'),
    (Codigo: 'nNNww'; Valor: '76'), (Codigo: 'nnnWW'; Valor: '77'),
    (Codigo: 'NnnWw'; Valor: '78'), (Codigo: 'nNnWw'; Valor: '79'),

    (Codigo: 'wnNWn'; Valor: '80'), (Codigo: 'WnnwN'; Valor: '81'),
    (Codigo: 'wNnwN'; Valor: '82'), (Codigo: 'WNnwn'; Valor: '83'),
    (Codigo: 'wnNwN'; Valor: '84'), (Codigo: 'WnNwn'; Valor: '85'),
    (Codigo: 'wNNwn'; Valor: '86'), (Codigo: 'wnnWN'; Valor: '87'),
    (Codigo: 'WnnWn'; Valor: '88'), (Codigo: 'wNnWn'; Valor: '89'),

    (Codigo: 'nwNWn'; Valor: '90'), (Codigo: 'NwnwN'; Valor: '91'),
    (Codigo: 'nWnwN'; Valor: '92'), (Codigo: 'NWnwn'; Valor: '93'),
    (Codigo: 'nwNwN'; Valor: '94'), (Codigo: 'NwNwn'; Valor: '95'),
    (Codigo: 'nWNwn'; Valor: '96'), (Codigo: 'nwnWN'; Valor: '97'),
    (Codigo: 'NwnWn'; Valor: '98'), (Codigo: 'nWnWn'; Valor: '99')
  );
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
  function AmbienteBoletoWSToStr(const AAmbiente : TTipoAmbienteWS) : String;
  function ConverterEBCDICToCodigoBarras(const ALinhaCodificada: string): string;
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

function AmbienteBoletoWSToStr(const AAmbiente : TTipoAmbienteWS) : String;
begin
  case AAmbiente of
    tawsProducao    : Result := 'Produção';
    tawsHomologacao : Result := 'Homologação';
    tawsSandbox     : Result := 'SandBox';
  end;
end;

function ConverterEBCDICToCodigoBarras(const ALinhaCodificada: string): string;
var
  I, IDX, LTotalBlocos: Integer;
  LBloco: string[5];
  LLinhaEBCDIC : String;
  LEncontrado: Boolean;
begin
  Result := '';
  LLinhaEBCDIC := ALinhaCodificada;
  LLinhaEBCDIC := StringReplace(LLinhaEBCDIC, '<', '', [rfReplaceAll]);
  LLinhaEBCDIC := StringReplace(LLinhaEBCDIC, '>', '', [rfReplaceAll]);

  LTotalBlocos := Length(LLinhaEBCDIC) div 5;

  for I := 0 to Pred(LTotalBlocos) do
  begin
  
    LBloco      := Copy(LLinhaEBCDIC, I * 5 + 1, 5);
    LEncontrado := False;

    for IDX := Low(EBCDIC_TABELA) to High(EBCDIC_TABELA) do
    begin
      if EBCDIC_TABELA[IDX].Codigo = LBloco then
      begin
        Result := Result + EBCDIC_TABELA[IDX].Valor;
        LEncontrado := True;
        Break;
      end;
    end;

    if not LEncontrado then
      raise Exception.CreateFmt('Bloco inválido encontrado: "%s" na posição %d', [LBloco, I + 1]);
  end;
end;

end.

