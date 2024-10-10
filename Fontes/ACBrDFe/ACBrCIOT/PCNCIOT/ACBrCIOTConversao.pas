{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

unit ACBrCIOTConversao;

interface

uses
  SysUtils, StrUtils, Classes;

const
  NAME_SPACE_CIOT  = '';

type
  TStatusACBrCIOT = (stCIOTIdle, stCIOTEnviar, stCIOTRetEnviar, stCIOTEmail,
                     stCIOTEnvioWebService);

  TSchemaCIOT = (schErro, schEnviar);

type
  TVersaoCIOT = (ve500);

const
  TVersaoCIOTArrayStrings: array[TVersaoCIOT] of string = ('5.00');
  TVersaoCIOTArrayDouble: array[TVersaoCIOT] of Double = (5.00);

type
  TCIOTIntegradora = (iNone, ieFrete, iRepom, iPamcard);

const
  TCIOTIntegradoraArrayStrings: array[TCIOTIntegradora] of string = ('iNone',
    'ieFrete', 'iRepom', 'iPamcard');

type
  TLayOutCIOT = (LayeFreteLogon, layeFreteProprietarios, LayeFreteVeiculos,
                 LayeFreteMotoristas, LayeFreteOperacaoTransporte,
                 LayeFreteFaturamentoTransportadora);

const
  TLayOutCIOTArrayStrings: array[TLayOutCIOT] of string = ('eFreteLogon',
    'eFreteProprietarios', 'eFreteVeiculos', 'eFreteMotoristas',
    'eFreteOperacaoTransporte', 'eFreteFaturamentoTransportadora');

type
  TpOperacao = (opLogin, opLogout,
                opGravarProprietario, opGravarVeiculo, opGravarMotorista,
                opAdicionar, opAdicionarViagem, opAdicionarPagamento,
                opObterCodigoIOT , opObterPdf, opRetificar, opCancelar,
                opCancelarPagamento, opEncerrar, opConsultarTipoCarga,
                opAlterarDataLiberacaoPagamento);

const
  TpOperacaoArrayStrings: array[TpOperacao] of string = ('Login', 'Logout',
    'Gravar Proprietario', 'Gravar Ve�culo', 'Gravar Motorista', 'Adicionar',
    'Adicionar Viagem', 'Adicionar Pagamento', 'Obter Codigo CIOT', 'Obter Pdf',
    'Retificar', 'Cancelar', 'Cancelar Pagamento', 'Encerrar',
    'ConsultarTipoCarga', 'AlterarDataLiberacaoPagamento');

type
  tpTipoConta = (tcIndefinido, tcContaCorrente, tcContaPoupanca, tcContaPagamentos);

const
  tpTipoContaArrayStrings: array[tpTipoConta] of string = ('Indefinido',
    'ContaCorrente', 'ContaPoupanca', 'ContaPagamentos');

type
  tpTipoEmbalagem = (teIndefinido, teBigbag, tePallet, teGranel, teContainer,
                     teSaco, teCaixa, teUnitario, teFardo, teTanque);

const
  tpTipoEmbalagemArrayStrings: array[tpTipoEmbalagem] of string = ('Indefinido',
    'Bigbag', 'Pallet', 'Granel', 'Container', 'Saco', 'Caixa', 'Unitario',
    'Fardo', 'Tanque');

type
  TpTipoViagem = (Indefinido, Padrao, TAC_Agregado, Frota);

const
  TpTipoViagemArrayStrings: array[TpTipoViagem] of string = ('Indefinido',
    'Padrao', 'TAC_Agregado', 'Frota');

type
  TpUnidadeDeMedidaDaMercadoria = (umIndefinido, umTonelada, umKg);

const
  TpUnidadeDeMedidaDaMercadoriaArrayStrings: array[TpUnidadeDeMedidaDaMercadoria]
    of string = ('Indefinido', 'Tonelada', 'Kg');

type
  TpViagemTipoDeCalculo = (SemQuebra, QuebraSomenteUltrapassado, QuebraIntegral);

const
  TpViagemTipoDeCalculoArrayStrings: array[TpViagemTipoDeCalculo]
     of string = ('SemQuebra', 'QuebraSomenteUltrapassado', 'QuebraIntegral');

type
  TpTipoProporcao = (tpNenhum, tpPorcentagem, tpValorAbsoluto);

const
  TpTipoProporcaoArrayStrings: array[TpTipoProporcao] of string = ('Nenhum',
    'Porcentagem', 'Absoluto');

type
  TpTipoTolerancia = (ttNenhum, ttPorcentagem, ttValorAbsoluto);

const
  TpTipoToleranciaArrayStrings: array[TpTipoTolerancia] of string = ('Nenhum',
    'Porcentagem', 'ValorAbsoluto');

type
  TpTipoAbono = (taNenhum, taPorcentagem, taValorAbsoluto, taPeso);

const
  TpTipoAbonoArrayStrings: array[TpTipoAbono] of string = ('Nenhum',
    'Porcentagem', 'ValorAbsoluto', 'Peso');

type
  TpDiferencaFrete = (SemDiferenca, SomenteUltrapassado, Integral);

const
  TpDiferencaFreteArrayStrings: array[TpDiferencaFrete]
    of string = ('SemDiferenca', 'SomenteUltrapassado', 'Integral');

type
  TpDiferencaFreteBaseCalculo = (QuantidadeDesembarque, QuantidadeMenor);

const
  TpDiferencaFreteBaseCalculoArrayStrings: array[TpDiferencaFreteBaseCalculo]
    of string = ('QuantidadeDesembarque', 'QuantidadeMenor');

type
  TpTipoPagamento = (TransferenciaBancaria, eFRETE, Parceiro, Outros,
                     DepositoAgendado);

const
  TpTipoPagamentoArrayStrings: array[TpTipoPagamento]
    of string = ('TransferenciaBancaria', 'eFRETE', 'Parceiro', 'Outros',
                 'DepositoAgendado');

type
  TpTipoCategoriaPagamento = (tcpAdiantamento, tcpEstadia, tcpQuitacao,
                              tcpSemCategoria, tcpFrota);

const
  TpTipoCategoriaPagamentoArrayStrings: array[TpTipoCategoriaPagamento]
    of string = ('Adiantamento', 'Estadia', 'Quitacao', 'SemCategoria', 'Frota');

type
  TpEntregaDocumentacao = (edNenhum, edRedeCredenciada, edCliente);

const
  TpEntregaDocumentacaoArrayStrings: array[TpEntregaDocumentacao]
    of string = ('', 'RedeCredenciada', 'Cliente');

type
  TpTipoRodado = (trNaoAplicavel, trTruck, trToco, trCavalo);

const
  TpTipoRodadoArrayStrings: array[TpTipoRodado] of string = ('NaoAplicavel',
    'Truck', 'Toco', 'Cavalo');

type
  TpTipoCarroceria = (tcNaoAplicavel, tcAberta, tcFechadaOuBau, tcGranelera,
                      tcPortaContainer, tcSider);

const
  TpTipoCarroceriaArrayStrings: array[TpTipoCarroceria]
    of string = ('NaoAplicavel', 'Aberta', 'FechadaOuBau', 'Granelera',
      'PortaContainer', 'Sider');

type
  tpTipoPessoa = (tpIndefinido, tpFisica, tpJuridica);

const
  tpTipoPessoaArrayStrings: array[tpTipoPessoa] of string = ('Indefinido',
    'Fisica', 'Juridica');

type
  TpTipoProprietario = (tpTAC, tpETC, tpCTC);

  //  TAC � Transportador Aut�nomo de Cargas;
  //  ETC � Empresa de Transporte Rodovi�rio de Cargas;
  //  CTC � Cooperativa de Transporte Rodovi�rio de Cargas;

const
  TpTipoProprietarioArrayStrings: array[TpTipoProprietario] of string = ('TAC',
    'ETC', 'CTC');

type
  tpEstadoCIOT = (ecEmViagem, ecEncerrado, ecCancelado);

const
  tpEstadoCIOTArrayStrings: array[tpEstadoCIOT] of string = ('EmViagem',
    'Encerrado', 'Cancelado');

type
  tpTipoCarga = (tpNaoAplicavel, tpGranelsolido, tpGranelLiquido, tpFrigorificada,
                 tpConteinerizada, tpCargaGeral, tpNeogranel, tpPerigosaGranelSolido,
                 tpPerigosaGranelLiquido, tpPerigosaCargaFrigorificada,
                 tpPerigosaConteinerizada, tpPerigosaCargaGeral);

const
  tpTipoCargaArrayStrings: array[tpTipoCarga] of string = ('0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '10', '11');
  tpTipoCargaDescArrayStrings: array[tpTipoCarga] of string = ('',
    'Granel s�lido - HML', 'Granel l�quido - HML', 'Frigorificada - HML',
    'Conteinerizada - HML', 'Carga Geral - HML', 'Neogranel - HML',
    'Perigosa (granel s�lido) - HML', 'Perigosa (granel l�quido) - HML',
    'Perigosa (carga frigorificada) - HML', 'Perigosa (conteinerizada) - HML',
    'Perigosa (carga geral) - HML');

{
  Declara��o das fun��es de convers�o
}
function LayOutToSchema(const t: TLayOutCIOT): TSchemaCIOT;

function LayOutToServico(const t: TLayOutCIOT): string;
function ServicoToLayOut(const s: string): TLayOutCIOT;

function SchemaCIOTToStr(const t: TSchemaCIOT): string;
function StrToSchemaCIOT(const s: string): TSchemaCIOT;

function VersaoCIOTToStr(const t: TVersaoCIOT): string;
function StrToVersaoCIOT(const s: string): TVersaoCIOT;

function VersaoCIOTToInt(const t: TVersaoCIOT): Integer;
function VersaoCIOTToDbl(const t: TVersaoCIOT): Double;
function DblToVersaoCIOT(const d: Double): TVersaoCIOT;

function TipoContaToStr(const t: tpTipoConta): string;
function StrToTipoConta(const s: string): tpTipoConta;

function TipoEmbalagemToStr(const t: tpTipoEmbalagem): string;
function StrToTipoEmbalagem(const s: string): tpTipoEmbalagem;

function TipoViagemCIOTToStr(const t: TpTipoViagem): string;
function StrToTipoViagemCIOT(const s: string): TpTipoViagem;

function TpPagamentoToStr(const t: TpTipoPagamento): string;
function StrToTpPagamento(const s: string): TpTipoPagamento;

function TpUnMedMercToStr(const t: TpUnidadeDeMedidaDaMercadoria): string;
function StrToTpUnMedMerc(const s: string): TpUnidadeDeMedidaDaMercadoria;

function TpVgTipoCalculoToStr(const t: TpViagemTipoDeCalculo): string;
function StrToTpVgTipoCalculo(const s: string): TpViagemTipoDeCalculo;

function TpProporcaoToStr(const t: TpTipoProporcao): string;
function StrToTpProporcao(const s: string): TpTipoProporcao;

function TpToleraciaToStr(const t: TpTipoTolerancia): string;
function StrToTpTolerancia(const s: string): TpTipoTolerancia;

function TpAbonoToStr(const t: TpTipoAbono): string;
function StrToTpAbono(const s: string): TpTipoAbono;

function TpDifFreteToStr(const t: TpDiferencaFrete): string;
function StrToTpDifFrete(const s: string): TpDiferencaFrete;

function TpDiferencaFreteBCToStr(const t: TpDiferencaFreteBaseCalculo): string;
function StrToTpDiferencaFreteBC(const s: string): TpDiferencaFreteBaseCalculo;

function TpCatPagToStr(const t: TpTipoCategoriaPagamento): string;
function StrToTpCatPag(const s: string): TpTipoCategoriaPagamento;

function TpOperacaoToStr(const t: TpOperacao): string;
function StrToTpOperacao(const s: string): TpOperacao;

function EntregaDocumentacaoToStr(const t: TpEntregaDocumentacao): string;
function StrToEntregaDocumentacao(const s: string): TpEntregaDocumentacao;

function TipoRodadoToStr(const t: TpTipoRodado): string;
function StrToTipoRodado(const s: string): TpTipoRodado;

function TipoCarroceriaToStr(const t: TpTipoCarroceria): string;
function StrToTipoCarroceria(const s: string): TpTipoCarroceria;

function TipoPessoaToStr(const t: tpTipoPessoa): string;
function StrToTipoPessoa(const s: string): tpTipoPessoa;

function TipoProprietarioToStr(const t: TpTipoProprietario): string;
function StrToTipoProprietario(const s: string): TpTipoProprietario;

function EstadoCIOTToStr(const t: TpEstadoCIOT): string;
function StrToEstadoCIOT(const s: string): TpEstadoCIOT;

function TipoCargaToStr(const t: tpTipoCarga): string;
function StrToTipoCarga(const s: string): tpTipoCarga;

function IntegradoraToStr(const t: TCIOTIntegradora): string;
function StrToIntegradora(const s: string): TCIOTIntegradora;

implementation

uses
  typinfo,
  ACBrBase;

function LayOutToSchema(const t: TLayOutCIOT): TSchemaCIOT;
begin
  case t of
    LayeFreteLogon,
    layeFreteProprietarios,
    LayeFreteVeiculos,
    LayeFreteMotoristas,
    LayeFreteOperacaoTransporte,
    LayeFreteFaturamentoTransportadora: Result := schEnviar;
  else
    Result := schErro;
  end;
end;

function LayOutToServico(const t: TLayOutCIOT): string;
begin
  result := TLayOutCIOTArrayStrings[t];
end;

function ServicoToLayOut(const s: string): TLayOutCIOT;
var
  idx: TLayOutCIOT;
begin
  for idx := Low(TLayOutCIOTArrayStrings) to High(TLayOutCIOTArrayStrings) do
  begin
    if (TLayOutCIOTArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TLayOutCIOT: %s', [s]);
end;

function SchemaCIOTToStr(const t: TSchemaCIOT): string;
begin
  Result := GetEnumName(TypeInfo(TSchemaCIOT), Integer(t));
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function StrToSchemaCIOT(const s: string): TSchemaCIOT;
var
  P: Integer;
  SchemaStr: string;
begin
  P := pos('_', s);
  if P > 0 then
    SchemaStr := copy(s, 1, P-1)
  else
    SchemaStr := s;

  if LeftStr(SchemaStr, 3) <> 'sch' then
    SchemaStr := 'sch' + SchemaStr;

  Result := TSchemaCIOT(GetEnumValue(TypeInfo(TSchemaCIOT), SchemaStr));
end;

function VersaoCIOTToStr(const t: TVersaoCIOT): string;
begin
  result := TVersaoCIOTArrayStrings[t];
end;

function StrToVersaoCIOT(const s: string): TVersaoCIOT;
var
  idx: TVersaoCIOT;
begin
  for idx := Low(TVersaoCIOTArrayStrings) to High(TVersaoCIOTArrayStrings) do
  begin
    if (TVersaoCIOTArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TVersaoCIOT: %s', [s]);
end;

function VersaoCIOTToInt(const t: TVersaoCIOT): Integer;
begin
  case t of
    ve500: Result := 5;
  else
    Result := 0;
  end;
end;

function VersaoCIOTToDbl(const t: TVersaoCIOT): Double;
begin
  result := TVersaoCIOTArrayDouble[t];
end;

function DblToVersaoCIOT(const d: Double): TVersaoCIOT;
var
  idx: TVersaoCIOT;
begin
  for idx := Low(TVersaoCIOTArrayDouble) to High(TVersaoCIOTArrayDouble) do
  begin
    if (TVersaoCIOTArrayDouble[idx] = d) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TVersaoCIOT: %s',
    [FormatFloat('0.00', d)]);
end;

function TipoContaToStr(const t: tpTipoConta): string;
begin
  result := tpTipoContaArrayStrings[t];
end;

function StrToTipoConta(const s: string): tpTipoConta;
var
  idx: tpTipoConta;
begin
  for idx := Low(tpTipoContaArrayStrings) to High(tpTipoContaArrayStrings) do
  begin
    if (tpTipoContaArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para tpTipoConta: %s', [s]);
end;

function TipoEmbalagemToStr(const t: tpTipoEmbalagem): string;
begin
  result := tpTipoEmbalagemArrayStrings[t];
end;

function StrToTipoEmbalagem(const s: string): tpTipoEmbalagem;
var
  idx: tpTipoEmbalagem;
begin
  for idx := Low(tpTipoEmbalagemArrayStrings) to High(tpTipoEmbalagemArrayStrings) do
  begin
    if (tpTipoEmbalagemArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para tpTipoEmbalagem: %s', [s]);
end;

function TipoViagemCIOTToStr(const t: TpTipoViagem): string;
begin
  result := TpTipoViagemArrayStrings[t];
end;

function StrToTipoViagemCIOT(const s: string): TpTipoViagem;
var
  idx: TpTipoViagem;
begin
  for idx := Low(TpTipoViagemArrayStrings) to High(TpTipoViagemArrayStrings) do
  begin
    if (TpTipoViagemArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpTipoViagem: %s', [s]);
end;

function TpPagamentoToStr(const t: TpTipoPagamento): string;
begin
  result := TpTipoPagamentoArrayStrings[t];
end;

function StrToTpPagamento(const s: string): TpTipoPagamento;
var
  idx: TpTipoPagamento;
begin
  for idx := Low(TpTipoPagamentoArrayStrings) to High(TpTipoPagamentoArrayStrings) do
  begin
    if (TpTipoPagamentoArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpTipoPagamento: %s', [s]);
end;

function TpUnMedMercToStr(const t: TpUnidadeDeMedidaDaMercadoria): string;
begin
  result := TpUnidadeDeMedidaDaMercadoriaArrayStrings[t];
end;

function StrToTpUnMedMerc(const s: string): TpUnidadeDeMedidaDaMercadoria;
var
  idx: TpUnidadeDeMedidaDaMercadoria;
begin
  for idx := Low(TpUnidadeDeMedidaDaMercadoriaArrayStrings) to High(TpUnidadeDeMedidaDaMercadoriaArrayStrings) do
  begin
    if (TpUnidadeDeMedidaDaMercadoriaArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpUnidadeDeMedidaDaMercadoria: %s', [s]);
end;

function TpVgTipoCalculoToStr(const t: TpViagemTipoDeCalculo): string;
begin
  result := TpViagemTipoDeCalculoArrayStrings[t];
end;

function StrToTpVgTipoCalculo(const s: string): TpViagemTipoDeCalculo;
var
  idx: TpViagemTipoDeCalculo;
begin
  for idx := Low(TpViagemTipoDeCalculoArrayStrings) to High(TpViagemTipoDeCalculoArrayStrings) do
  begin
    if (TpViagemTipoDeCalculoArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpViagemTipoDeCalculo: %s', [s]);
end;

function TpProporcaoToStr(const t: TpTipoProporcao): string;
begin
  result := TpTipoProporcaoArrayStrings[t];
end;

function StrToTpProporcao(const s: string): TpTipoProporcao;
var
  idx: TpTipoProporcao;
begin
  for idx := Low(TpTipoProporcaoArrayStrings) to High(TpTipoProporcaoArrayStrings) do
  begin
    if (TpTipoProporcaoArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpTipoProporcao: %s', [s]);
end;

function TpToleraciaToStr(const t: TpTipoTolerancia): string;
begin
  result := TpTipoToleranciaArrayStrings[t];
end;

function StrToTpTolerancia(const s: string): TpTipoTolerancia;
var
  idx: TpTipoTolerancia;
begin
  for idx := Low(TpTipoToleranciaArrayStrings) to High(TpTipoToleranciaArrayStrings) do
  begin
    if (TpTipoToleranciaArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpTipoTolerancia: %s', [s]);
end;

function TpAbonoToStr(const t: TpTipoAbono): string;
begin
  result := TpTipoAbonoArrayStrings[t];
end;

function StrToTpAbono(const s: string): TpTipoAbono;
var
  idx: TpTipoAbono;
begin
  for idx := Low(TpTipoAbonoArrayStrings) to High(TpTipoAbonoArrayStrings) do
  begin
    if (TpTipoAbonoArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpTipoAbono: %s', [s]);
end;

function TpDifFreteToStr(const t: TpDiferencaFrete): string;
begin
  result := TpDiferencaFreteArrayStrings[t];
end;

function StrToTpDifFrete(const s: string): TpDiferencaFrete;
var
  idx: TpDiferencaFrete;
begin
  for idx := Low(TpDiferencaFreteArrayStrings) to High(TpDiferencaFreteArrayStrings) do
  begin
    if (TpDiferencaFreteArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpDiferencaFrete: %s', [s]);
end;

function TpDiferencaFreteBCToStr(const t: TpDiferencaFreteBaseCalculo): string;
begin
  result := TpDiferencaFreteBaseCalculoArrayStrings[t];
end;

function StrToTpDiferencaFreteBC(const s: string): TpDiferencaFreteBaseCalculo;
var
  idx: TpDiferencaFreteBaseCalculo;
begin
  for idx := Low(TpDiferencaFreteBaseCalculoArrayStrings) to High(TpDiferencaFreteBaseCalculoArrayStrings) do
  begin
    if (TpDiferencaFreteBaseCalculoArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpDiferencaFreteBaseCalculo: %s', [s]);
end;

function TpCatPagToStr(const t: TpTipoCategoriaPagamento): string;
begin
  result := TpTipoCategoriaPagamentoArrayStrings[t];
end;

function StrToTpCatPag(const s: string): TpTipoCategoriaPagamento;
var
  idx: TpTipoCategoriaPagamento;
begin
  for idx := Low(TpTipoCategoriaPagamentoArrayStrings) to High(TpTipoCategoriaPagamentoArrayStrings) do
  begin
    if (TpTipoCategoriaPagamentoArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpTipoCategoriaPagamento: %s', [s]);
end;

function TpOperacaoToStr(const t: TpOperacao): string;
begin
  result := TpOperacaoArrayStrings[t];
end;

function StrToTpOperacao(const s: string): TpOperacao;
var
  idx: TpOperacao;
begin
  for idx := Low(TpOperacaoArrayStrings) to High(TpOperacaoArrayStrings) do
  begin
    if (TpOperacaoArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpOperacao: %s', [s]);
end;

function EntregaDocumentacaoToStr(const t: TpEntregaDocumentacao): string;
begin
  result := TpEntregaDocumentacaoArrayStrings[t];
end;

function StrToEntregaDocumentacao(const s: string): TpEntregaDocumentacao;
var
  idx: TpEntregaDocumentacao;
begin
  for idx := Low(TpEntregaDocumentacaoArrayStrings) to High(TpEntregaDocumentacaoArrayStrings) do
  begin
    if (TpEntregaDocumentacaoArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpEntregaDocumentacao: %s', [s]);
end;

function TipoRodadoToStr(const t: TpTipoRodado): string;
begin
  result := TpTipoRodadoArrayStrings[t];
end;

function StrToTipoRodado(const s: string): TpTipoRodado;
var
  idx: TpTipoRodado;
begin
  for idx := Low(TpTipoRodadoArrayStrings) to High(TpTipoRodadoArrayStrings) do
  begin
    if (TpTipoRodadoArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpTipoRodado: %s', [s]);
end;

function TipoCarroceriaToStr(const t: TpTipoCarroceria): string;
begin
  result := TpTipoCarroceriaArrayStrings[t];
end;

function StrToTipoCarroceria(const s: string): TpTipoCarroceria;
var
  idx: TpTipoCarroceria;
begin
  for idx := Low(TpTipoCarroceriaArrayStrings) to High(TpTipoCarroceriaArrayStrings) do
  begin
    if (TpTipoCarroceriaArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpTipoCarroceria: %s', [s]);
end;

function TipoPessoaToStr(const t: tpTipoPessoa): string;
begin
  result := tpTipoPessoaArrayStrings[t];
end;

function StrToTipoPessoa(const s: string): tpTipoPessoa;
var
  idx: tpTipoPessoa;
begin
  for idx := Low(tpTipoPessoaArrayStrings) to High(tpTipoPessoaArrayStrings) do
  begin
    if (tpTipoPessoaArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para tpTipoPessoa: %s', [s]);
end;

function TipoProprietarioToStr(const t: TpTipoProprietario): string;
begin
  result := TpTipoProprietarioArrayStrings[t];
end;

function StrToTipoProprietario(const s: string): TpTipoProprietario;
var
  idx: TpTipoProprietario;
begin
  for idx := Low(TpTipoProprietarioArrayStrings) to High(TpTipoProprietarioArrayStrings) do
  begin
    if (TpTipoProprietarioArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpTipoProprietario: %s', [s]);
end;

function EstadoCIOTToStr(const t: TpEstadoCIOT): string;
begin
  result := TpEstadoCIOTArrayStrings[t];
end;

function StrToEstadoCIOT(const s: string): TpEstadoCIOT;
var
  idx: TpEstadoCIOT;
begin
  for idx := Low(TpEstadoCIOTArrayStrings) to High(TpEstadoCIOTArrayStrings) do
  begin
    if (TpEstadoCIOTArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TpEstadoCIOT: %s', [s]);
end;

function TipoCargaToStr(const t: tpTipoCarga): string;
begin
  result := tpTipoCargaArrayStrings[t];
end;

function StrToTipoCarga(const s: string): tpTipoCarga;
var
  idx: tpTipoCarga;
begin
  for idx := Low(tpTipoCargaArrayStrings) to High(tpTipoCargaArrayStrings) do
  begin
    if (tpTipoCargaArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para tpTipoCarga: %s', [s]);
end;

function IntegradoraToStr(const t: TCIOTIntegradora): string;
begin
  result := TCIOTIntegradoraArrayStrings[t];
end;

function StrToIntegradora(const s: string): TCIOTIntegradora;
var
  idx: TCIOTIntegradora;
begin
  for idx := Low(TCIOTIntegradoraArrayStrings) to High(TCIOTIntegradoraArrayStrings) do
  begin
    if (TCIOTIntegradoraArrayStrings[idx] = s) then
    begin
      result := idx;
      exit;
    end;
  end;

  raise EACBrException.CreateFmt('Valor string inv�lido para TCIOTIntegradora: %s', [s]);
end;

end.
