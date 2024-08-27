{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Daniel de Moraes, Victor H Gonzales - Panda,    }
{   Luiz Carlos Rodrigues                                                      }
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

unit ACBrBancoBTGPactual;

interface

uses
  Classes, SysUtils, Contnrs, ACBrBoleto, ACBrBoletoConversao;

type

  { TACBrBancoBTGPactual }
  TACBrBancoBTGPactual = class(TACBrBancoClass)
  private
    fValorTotalDocs: Double;
  protected
    procedure EhObrigatorioContaDV; override;
    procedure EhObrigatorioAgenciaDV; override;
    function DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;
    function DefinePosicaoNossoNumeroRetorno: Integer; override;                     //Define posi��o para leitura de Retorno campo: NossoNumero
    function MontaInstrucoesCNAB240(ATitulo : TACBrTitulo; AIndex : Integer) : string;
    function ConverterDigitoModuloFinal(): String; override;
    function DefineDataOcorrencia(const ALinha: String): String; override;
  public
    constructor Create(AOwner: TACBrBanco);
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String; override;
    function MontarCampoNossoNumero( const ACBrTitulo: TACBrTitulo): String; override;
    function GerarRegistroHeader240(NumeroRemessa: Integer): String; override;
    function GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String; override;
    function GerarRegistroTrailler240(ARemessa: TStringList): String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia):String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): String; override;
    procedure GerarRegistroHeader400(NumeroRemessa: Integer; aRemessa: TStringList); override;
    procedure LerRetorno400(ARetorno: TStringList); override;
    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia) : String; override;
  end;

implementation

uses
  StrUtils,
  Variants,
  {$IFDEF COMPILER6_UP}
    DateUtils
  {$ELSE}
    ACBrD5,
    FileCtrl
  {$ENDIF},
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  Math;


function TACBrBancoBTGPactual.CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): String;
begin
  case TipoOcorrencia of
    toRetornoRegistroConfirmado,  //02
    toRetornoRegistroRecusado,    //03
    toRetornoInstrucaoRejeitada,  //26
    toRetornoAlteracaoDadosRejeitados: //30
      case CodMotivo of
        01: Result := '01-C�digo do Banco Inv�lido';
        02: Result := '02-C�digo do Registro Detalhe Inv�lido';
        03: Result := '03-C�digo do Segmento Inv�lido';
        04: Result := '04-C�digo de Movimento N�o Permitido para Carteira';
        05: Result := '05-C�digo de Movimento Inv�lido';
        06: Result := '06-Tipo/N�mero de Inscri��o do Benefici�rio Inv�lidos';
        07: Result := '07-Ag�ncia/Conta/DV Inv�lido';
        08: Result := '08-Nosso N�mero Inv�lido';
        09: Result := '09-Nosso N�mero Duplicado';
        10: Result := '10-Carteira Inv�lida';
        11: Result := '11-Forma de Cadastramento do T�tulo Inv�lido';
        12: Result := '12-Tipo de Documento Inv�lido';
        13: Result := '13-Identifica��o da Emiss�o do Boleto de Pagamento Inv�lida';
        14: Result := '14-Identifica��o da Distribui��o do Boleto de Pagamento Inv�lida';
        15: Result := '15-Caracter�sticas da Cobran�a Incompat�veis';
        16: Result := '16-Data de Vencimento Inv�lida';
        17: Result := '17-Data de Vencimento Anterior a Data de Emiss�o';
        18: Result := '18-Vencimento Fora do Prazo de Opera��o';
        19: Result := '19-T�tulo a Cargo de Bancos Correspondentes com Vencimento Inferior a XX Dias';
        20: Result := '20-Valor do T�tulo Inv�lido';
        21: Result := '21-Esp�cie do T�tulo Inv�lida';
        22: Result := '22-Esp�cie do T�tulo N�o Permitida para a Carteira';
        23: Result := '23-Aceite Inv�lido';
        24: Result := '24-Data da Emiss�o Inv�lida';
        25: Result := '25-Data da Emiss�o Posterior a Data de Entrada';
        26: Result := '26-C�digo de Juros de Mora Inv�lido';
        27: Result := '27-Valor/Taxa de Juros de Mora Inv�lido';
        28: Result := '28-C�digo do Desconto Inv�lido';
        29: Result := '29-Valor do Desconto Maior ou Igual ao Valor do T�tulo';
        30: Result := '30-Desconto a Conceder N�o Confere';
        31: Result := '31-Concess�o de Desconto - J� Existe Desconto Anterior';
        32: Result := '32-Valor do IOF Inv�lido';
        33: Result := '33-Valor do Abatimento Inv�lido';
        34: Result := '34-Valor do Abatimento Maior ou Igual ao Valor do T�tulo';
        35: Result := '35-Valor a Conceder N�o Confere';
        36: Result := '36-Concess�o de Abatimento - J� Existe Abatimento Anterior';
        37: Result := '37-C�digo para Protesto Inv�lido';
        38: Result := '38-Prazo para Protesto Inv�lido';
        39: Result := '39-Pedido de Protesto N�o Permitido para o T�tulo';
        40: Result := '40-T�tulo com Ordem de Protesto Emitida';
        41: Result := '41-Pedido de Cancelamento/Susta��o para T�tulos sem Instru��o de Protesto';
        42: Result := '42-C�digo para Baixa/Devolu��o Inv�lido';
        43: Result := '43-Prazo para Baixa/Devolu��o Inv�lido';
        44: Result := '44-C�digo da Moeda Inv�lido';
        45: Result := '45-Nome do Pagador N�o Informado';
        46: Result := '46-Tipo/N�mero de Inscri��o do Pagador Inv�lidos';
        47: Result := '47-Endere�o do Pagador N�o Informado';
        48: Result := '48-CEP Inv�lido';
        49: Result := '49-CEP Sem Pra�a de Cobran�a (N�o Localizado)';
        50: Result := '50-CEP Referente a um Banco Correspondente';
        51: Result := '51-CEP incompat�vel com a Unidade da Federa��o';
        52: Result := '52-Unidade da Federa��o Inv�lida';
        53: Result := '53-Tipo/N�mero de Inscri��o do Sacador/Avalista Inv�lidos';
        54: Result := '54-Sacador/Avalista N�o Informado';
        55: Result := '55-Nosso n�mero no Banco Correspondente N�o Informado';
        56: Result := '56-C�digo do Banco Correspondente N�o Informado';
        57: Result := '57-C�digo da Multa Inv�lido';
        58: Result := '58-Data da Multa Inv�lida';
        59: Result := '59-Valor/Percentual da Multa Inv�lido';
        60: Result := '60-Movimento para T�tulo N�o Cadastrado';
        61: Result := '61-Altera��o da Ag�ncia Cobradora/DV Inv�lida';
        62: Result := '62-Tipo de Impress�o Inv�lido';
        63: Result := '63-Entrada para T�tulo j� Cadastrado';
        64: Result := '64-N�mero da Linha Inv�lido';
        65: Result := '65-C�digo do Banco para D�bito Inv�lido';
        66: Result := '66-Ag�ncia/Conta/DV para D�bito Inv�lido';
        67: Result := '67-Dados para D�bito incompat�vel com a Identifica��o da Emiss�o do Boleto de Pagamento';
        68: Result := '68-D�bito Autom�tico Agendado';
        69: Result := '69-D�bito N�o Agendado - Erro nos Dados da Remessa';
        70: Result := '70-D�bito N�o Agendado - Pagador N�o Consta do Cadastro de Autorizante';
        71: Result := '71-D�bito N�o Agendado - Benefici�rio N�o Autorizado pelo Pagador';
        72: Result := '72-D�bito N�o Agendado - Benefici�rio N�o Participa da Modalidade D�bito';
        73: Result := '73-D�bito N�o Agendado - C�digo de Moeda Diferente de Real (R$)';
        74: Result := '74-D�bito N�o Agendado - Data Vencimento Inv�lida';
        75: Result := '75-D�bito N�o Agendado, Conforme seu Pedido, T�tulo N�o Registrado';
        76: Result := '76-D�bito N�o Agendado, Tipo/Num. Inscri��o do Debitado, Inv�lido';
        77: Result := '77-Transfer�ncia para Desconto N�o Permitida para a Carteira do T�tulo';
        78: Result := '78-Data Inferior ou Igual ao Vencimento para D�bito Autom�tico';
        79: Result := '79-Data Juros de Mora Inv�lido';
        80: Result := '80-Data do Desconto Inv�lida';
        81: Result := '81-Tentativas de D�bito Esgotadas - Baixado';
        82: Result := '82-Tentativas de D�bito Esgotadas - Pendente';
        83: Result := '83-Limite Excedido';
        84: Result := '84-N�mero Autoriza��o Inexistente';
        85: Result := '85-T�tulo com Pagamento Vinculado';
        86: Result := '86-Seu N�mero Inv�lido';
        87: Result := '87--mail/SMS enviado';
        88: Result := '88--mail Lido';
        89: Result := '89--mail/SMS devolvido - endere�o de e-mail ou n�mero do celular incorreto �90�= e-mail devolvido - caixa postal cheia';
        91: Result := '91--mail/n�mero do celular do Pagador n�o informado';
        92: Result := '92-agador optante por Boleto de Pagamento Eletr�nico - e-mail n�o enviado';
        93: Result := '93-�digo para emiss�o de Boleto de Pagamento n�o permite envio de e-mail';
        94: Result := '94-�digo da Carteira inv�lido para envio e-mail.';
        95: Result := '95-ntrato n�o permite o envio de e-mail';
        96: Result := '96-�mero de contrato inv�lido';
        97: Result := '97-Rejei��o da altera��o do prazo limite de recebimento (a data deve ser informada no campo 28.3.p)';
        98: Result := '98-Rejei��o de dispensa de prazo limite de recebimento';
        99: Result := '99-Rejei��o da altera��o do n�mero do t�tulo dado pelo Benefici�rio';
      else  Result := 'XX-Outros motivos';
      end;
    toRetornoDebitoTarifas: // 28 - D�bito de Tarifas/Custas (Febraban 240 posi��es, v08.9 de 15/04/2014)
      case CodMotivo of
        01: Result := '01-Tarifa de Extrato de Posi��o';
        02: Result := '02-Tarifa de Manuten��o de T�tulo Vencido';
        03: Result := '03-Tarifa de Susta��o';
        04: Result := '04-Tarifa de Protesto';
        05: Result := '05-Tarifa de Outras Instru��es';
        06: Result := '06-Tarifa de Outras Ocorr�ncias';
        07: Result := '07-Tarifa de Envio de Duplicata ao Sacado';
        08: Result := '08-Custas de Protesto';
        09: Result := '09-Custas de Susta��o de Protesto';
        10: Result := '10-Custas de Cart�rio Distribuidor';
        11: Result := '11-Custas de Edital';
        12: Result := '12-Tarifa Sobre Devolu��o de T�tulo Vencido';
        13: Result := '13-Tarifa Sobre Registro Cobrada na Baixa/Liquida��o';
        14: Result := '14-Tarifa Sobre Reapresenta��o Autom�tica';
        15: Result := '15-Tarifa Sobre Rateio de Cr�dito';
        16: Result := '16-Tarifa Sobre Informa��es Via Fax';
        17: Result := '17-Tarifa Sobre Prorroga��o de Vencimento';
        18: Result := '18-Tarifa Sobre Altera��o de Abatimento/Desconto';
        19: Result := '19-Tarifa Sobre Arquivo mensal (Em Ser)';
        20: Result := '20-Tarifa Sobre Emiss�o de Bloqueto Pr�-Emitido pelo Banco';
      end;
    toRetornoLiquidado, // 06-Liquida��o Normal
    toRetornoBaixaAutomatica, // 09-Baixa Automatica
    toRetornoLiquidadoSemRegistro: // 17-Liquida��o Ap�s Baixa ou Liquida��o de T�tulo N�o Registrado
      case CodMotivo of
        01: Result := '01-Por Saldo';
        02: Result := '02-Por Conta';
        03: Result := '03-Liquida��o no Guich� de Caixa em Dinheiro';
        04: Result := '04-Compensa��o Eletr�nica';
        05: Result := '05-Compensa��o Convencional';
        06: Result := '06-Por Meio Eletr�nico';
        07: Result := '07-Ap�s Feriado Local';
        08: Result := '08-Em Cart�rio';
        09: Result := '09-Comandada Banco';
        10: Result := '10-Comandada Cliente Arquivo';
        11: Result := '11-Comandada Cliente On-line';
        12: Result := '12-Decurso Prazo - Cliente';
        13: Result := '13-Decurso Prazo - Banco';
        14: Result := '14-Protestado';
        15: Result := '15-T�tulo Exclu�do';
        30: Result := '30-Liquida��o no Guich� de Caixa em Cheque';
        31: Result := '31-Liquida��o em banco correspondente';
        32: Result := '32-Liquida��o Terminal de Auto-Atendimento';
        33: Result := '33-Liquida��o na Internet (Home banking)';
        34: Result := '34-Liquidado Office Banking';
        35: Result := '35-Liquidado Correspondente em Dinheiro';
        36: Result := '36-Liquidado Correspondente em Cheque';
        37: Result := '37-Liquidado por meio de Central de Atendimento (Telefone)';
      end;
  end;
  Result := ACBrSTr(Result);
end;

function TACBrBancoBTGPactual.CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  Result := toTipoOcorrenciaNenhum;
  if CodOcorrencia>0 then
  begin
    case CodOcorrencia of
      02: Result := toRetornoRegistroConfirmado;
      03: Result := toRetornoRegistroRecusado;
      04: Result := toRetornoTransferenciaCarteiraEntrada;
      05: Result := toRetornoTransferenciaCarteiraBaixa;
      06: Result := toRetornoLiquidado;
      07: Result := toRetornoRecebimentoInstrucaoConcederDesconto;
      08: Result := toRetornoRecebimentoInstrucaoCancelarDesconto;
      09: Result := toRetornoBaixaAutomatica;
      11: Result := toRetornoTituloEmSer;
      12: Result := toRetornoAbatimentoConcedido;
      13: Result := toRetornoAbatimentoCancelado;
      14: Result := toRetornoVencimentoAlterado;
      15: Result := toRetornoBaixadoFrancoPagamento;
      17: Result := toRetornoLiquidadoSemRegistro;
      19: Result := toRetornoRecebimentoInstrucaoProtestar;
      20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
      23: Result := toRetornoEntradaEmCartorio;
      24: Result := toRetornoRetiradoDeCartorio;
      25: Result := toRetornoBaixaPorProtesto;
      26: Result := toRetornoInstrucaoRejeitada;
      27: Result := toRetornoAlteracaoUsoCedente;
      28: Result := toRetornoDebitoTarifas;
      29: Result := toRetornoOcorrenciasDoSacado;
      30: Result := toRetornoAlteracaoDadosRejeitados;
      33: Result := toRetornoAcertoDadosRateioCredito;
      34: Result := toRetornoCancelamentoDadosRateio;
      35: Result := toRetornoDesagendamentoDebitoAutomatico;
      36: Result := toRetornoConfirmacaoEmailSMS;
      37: Result := toRetornoEmailSMSRejeitado;
      38: Result := toRetornoAlterarPrazoLimiteRecebimento;
      39: Result := toRetornoDispensarPrazoLimiteRecebimento;
      40: Result := toRetornoAlteracaoSeuNumero;
      41: Result := toRetornoAcertoControleParticipante;
      42: Result := toRetornoDadosAlterados;
      43: Result := toRetornoAlterarSacadorAvalista;
      44: Result := toRetornoChequeDevolvido;
      45: Result := toRetornoChequeCompensado;
      46: Result := toRetornoProtestoSustado;
      47: Result := toRetornoProtestoImediatoFalencia;
      48: Result := toRetornoConfInstrucaoTransferenciaCarteiraModalidadeCobranca;
      49: Result := toRetornoTipoCobrancaAlterado;
      50: Result := toRetornoChequePendenteCompensacao;
      51: Result := toRetornoTituloDDAReconhecidoPagador;
      52: Result := toRetornoTituloDDANaoReconhecidoPagador;
      53: Result := toRetornoTituloDDARecusadoCIP;
      54: Result := toRetornoBaixaTituloNegativadoSemProtesto;
      55: Result := toRetornoConfirmacaoPedidoDispensaMulta;
      56: Result := toRetornoConfirmacaoPedidoCobrancaMulta;
      57: Result := toRetornoRecebimentoInstrucaoAlterarJuros;
      58: Result := toRetornoAlterarDataDesconto;
      59: Result := toRetornoConfirmacaoPedidoAlteracaoBeneficiarioTitulo;
      60: Result := toRetornoRecebimentoInstrucaoDispensarJuros;
      61: Result := toRetornoConfirmacaoAlteracaoValorNominal;
      62: Result := toRetornoTituloSustadoJudicialmente;
      63: Result := toRetornoTituloSustadoJudicialmente;
      64: Result := toRetornoConfirmacaoAlteracaoValorMinimoOuPercentual;
      65: Result := toRetornoConfirmacaoAlteracaoValorMaximoOuPercentual;
    else
      Result := toRetornoOutrasOcorrencias;
    end;
  end;
end;

function TACBrBancoBTGPactual.ConverterDigitoModuloFinal: String;
begin
  if Modulo.ModuloFinal = 1 then
      Result:= 'P'
   else
      Result:= IntToStr(Modulo.DigitoFinal);
end;

constructor TACBrBancoBTGPactual.Create(AOwner: TACBrBanco);
begin
  inherited Create(AOwner);
  fpDigito                   := 1;
  fpNome                     := 'BTG Pactual';
  fpNumero                   := 208;
  fpTamanhoMaximoNossoNum    := 11;
  fpTamanhoNumeroDocumento   := 20;
  fpTamanhoAgencia           := 4;
  fpTamanhoConta             := 7;
  fpTamanhoCarteira          := 2;
  fValorTotalDocs            := 0;
  fpDensidadeGravacao        := '01600';
  fpModuloMultiplicadorFinal := 7;
  fpLayoutVersaoLote         := 060;
  fpLayoutVersaoArquivo      := 103;
end;

function TACBrBancoBTGPactual.DefineCampoLivreCodigoBarras(
  const ACBrTitulo: TACBrTitulo): String;
begin
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia                        // agencia sem digito
            + PadLeft(IntToStr(StrToInt(ACBrTitulo.Carteira)), 2,'0')    // codigo da carteira
            + ACBrTitulo.NossoNumero                                     // nosso n�mero sem o digito
            + RightStr(ACBrTitulo.ACBrBoleto.Cedente.Conta,7)            // conta benefici�rio sem digito
            + '0';                                                       // zero fixo
end;

function TACBrBancoBTGPactual.DefineDataOcorrencia(const ALinha: String): String;
begin
  if (trim(copy(ALinha, 158, 2)) <> '') and (trim(copy(ALinha, 158, 2)) <> '00') then
    Result := copy(ALinha, 158, 2)+'/'+copy(ALinha, 160, 2)+'/'+copy(ALinha, 162, 4)
  else
    Result := copy(ALinha, 138, 2)+'/'+copy(ALinha, 140, 2)+'/'+copy(ALinha, 142, 4);
end;

function TACBrBancoBTGPactual.DefinePosicaoNossoNumeroRetorno: Integer;
begin
  Result := 47
end;

procedure TACBrBancoBTGPactual.EhObrigatorioAgenciaDV;
begin
  //sem valida��o
end;

procedure TACBrBancoBTGPactual.EhObrigatorioContaDV;
begin
  //sem valida��o
end;

function TACBrBancoBTGPactual.TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  Result:='';
  case TipoOcorrencia of   {C044 - CODIGO MOVTO RETORNO}
    toRetornoRegistroConfirmado:                                    Result := '02';
    toRetornoRegistroRecusado:                                      Result := '03';
    toRetornoTransferenciaCarteiraEntrada:                          Result := '04';
    toRetornoTransferenciaCarteiraBaixa:                            Result := '05';
    toRetornoLiquidado:                                             Result := '06';
    toRetornoRecebimentoInstrucaoConcederDesconto:                  Result := '07';
    toRetornoRecebimentoInstrucaoCancelarDesconto:                  Result := '08';
    toRetornoBaixaAutomatica:                                       Result := '09';
    toRetornoTituloEmSer:                                           Result := '11';
    toRetornoAbatimentoConcedido:                                   Result := '12';
    toRetornoAbatimentoCancelado:                                   Result := '13';
    toRetornoVencimentoAlterado:                                    Result := '14';
    toRetornoBaixadoFrancoPagamento:                                Result := '15';
    toRetornoLiquidadoSemRegistro:                                  Result := '17';
    toRetornoRecebimentoInstrucaoProtestar:                         Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto:                    Result := '20';
    toRetornoEntradaEmCartorio:                                     Result := '23';
    toRetornoRetiradoDeCartorio:                                    Result := '24';
    toRetornoBaixaPorProtesto:                                      Result := '25';
    toRetornoInstrucaoRejeitada:                                    Result := '26';
    toRetornoAlteracaoUsoCedente:                                   Result := '27';
    toRetornoDebitoTarifas:                                         Result := '28';
    toRetornoOcorrenciasDoSacado:                                   Result := '29';
    toRetornoAlteracaoDadosRejeitados:                              Result := '30';
    toRetornoAcertoDadosRateioCredito:                              Result := '33';
    toRetornoCancelamentoDadosRateio:                               Result := '34';
    toRetornoDesagendamentoDebitoAutomatico:                        Result := '35';
    toRetornoConfirmacaoEmailSMS:                                   Result := '36';
    toRetornoEmailSMSRejeitado:                                     Result := '37';
    toRetornoAlterarPrazoLimiteRecebimento:                         Result := '38';
    toRetornoDispensarPrazoLimiteRecebimento:                       Result := '39';
    toRetornoAlteracaoSeuNumero:                                    Result := '40';
    toRetornoAcertoControleParticipante:                            Result := '41';
    toRetornoDadosAlterados:                                        Result := '42';
    toRetornoAlterarSacadorAvalista:                                Result := '43';
    toRetornoChequeDevolvido:                                       Result := '44';
    toRetornoChequeCompensado:                                      Result := '45';
    toRetornoProtestoSustado:                                       Result := '46';
    toRetornoProtestoImediatoFalencia:                              Result := '47';
    toRetornoConfInstrucaoTransferenciaCarteiraModalidadeCobranca:  Result := '48';
    toRetornoTipoCobrancaAlterado:                                  Result := '49';
    toRetornoChequePendenteCompensacao:                             Result := '50';
    toRetornoTituloDDAReconhecidoPagador:                           Result := '51';
    toRetornoTituloDDANaoReconhecidoPagador:                        Result := '52';
    toRetornoTituloDDARecusadoCIP:                                  Result := '53';
    toRetornoBaixaTituloNegativadoSemProtesto:                      Result := '54';
    toRetornoConfirmacaoPedidoDispensaMulta:                        Result := '55';
    toRetornoConfirmacaoPedidoCobrancaMulta:                        Result := '56';
    toRetornoRecebimentoInstrucaoAlterarJuros:                      Result := '57';
    toRetornoAlterarDataDesconto:                                   Result := '58';
    toRetornoConfirmacaoPedidoAlteracaoBeneficiarioTitulo:          Result := '59';
    toRetornoRecebimentoInstrucaoDispensarJuros:                    Result := '60';
    toRetornoConfirmacaoAlteracaoValorNominal:                      Result := '61';
    toRetornoTituloSustadoJudicialmente:                            Result := '63';
    toRetornoConfirmacaoAlteracaoValorMinimoOuPercentual:           Result := '64';
    toRetornoConfirmacaoAlteracaoValorMaximoOuPercentual:           Result := '65';
  end;
end;

function TACBrBancoBTGPactual.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
 CodOcorrencia: Integer;
begin
  Result := '';
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia),0);
  case CodOcorrencia of
    02: Result:= '02 � Entrada confirmada';
    03: Result:= '03 � Entrada Rejeitada';
    04: Result:= '04 � Transfer�ncia de Carteira/Entrada';
    05: Result:= '05 � Transfer�ncia de Carteira/Baixa';
    06: Result:= '06 � Liquida��o';
    09: Result:= '09 � Baixa';
    11: Result:= '11 � T�tulos em Carteira (em ser)';
    12: Result:= '12 � Confirma��o Recebimento Instru��o de Abatimento';
    13: Result:= '13 � Confirma��o Recebimento Instru��o de Cancelamento Abatimento';
    14: Result:= '14 � Confirma��o Recebimento Instru��o Altera��o de Vencimento';
    15: Result:= '15 � Franco de Pagamento';
    17: Result:= '17 � Liquida��o Ap�s Baixa ou Liquida��o T�tulo N�o Registrado';
    19: Result:= '19 � Confirma��o Recebimento Instru��o de Protesto';
    20: Result:= '20 � Confirma��o Recebimento Instru��o de Susta��o/Cancelamento de Protesto';
    23: Result:= '23 � Remessa a Cart�rio';
    24: Result:= '24 � Retirada de Cart�rio e Manuten��o em Carteira';
    25: Result:= '25 � Protestado e Baixado';
    26: Result:= '26 � Instru��o Rejeitada';
    27: Result:= '27 � Confirma��o do Pedido de Altera��o de Outros Dados';
    28: Result:= '28 � D�bito de Tarifas/Custas';
    29: Result:= '29 � Ocorr�ncias do Sacado';
    30: Result:= '30 � Altera��o de Dados Rejeitada';
    44: Result:= '44 � T�tulo pago com cheque devolvido';
    50: Result:= '50 � T�tulo pago com cheque pendente de compensa��o';
  end;
  Result := ACBrSTr(Result);
end;

function TACBrBancoBTGPactual.MontaInstrucoesCNAB240(ATitulo: TACBrTitulo;
  AIndex: Integer): string;
begin

  if ATitulo.Mensagem.Count = 0 then
    Result := PadRight('', 80, ' ')
  else
  if (AIndex = 1) then
  begin
    if ATitulo.Mensagem.Count >= 1 then
         Result := Result + Copy(PadRight(ATitulo.Mensagem[0], 40, ' '), 1, 40) //Registro R mensagem 3
      else
         Result := Result + PadRight('', 40, ' ');

    if ATitulo.Mensagem.Count >= 2 then
         Result := Result + Copy(PadRight(ATitulo.Mensagem[1], 40, ' '), 1, 40) //Registro R mensagem 4
      else
         Result := Result + PadRight('', 40, ' ');
  end else
  begin
    if ATitulo.Mensagem.Count >= 3 then
         Result := Result + Copy(PadRight(ATitulo.Mensagem[2], 40, ' '), 1, 40) //Registro S mensagem 5
      else
         Result := Result + PadRight('', 40, ' ');

    if ATitulo.Mensagem.Count >= 4 then
         Result := Result + Copy(PadRight(ATitulo.Mensagem[3], 40, ' '), 1, 40) //Registro S mensagem 6
      else
         Result := Result + PadRight('', 40, ' ');

    if ATitulo.Mensagem.Count >= 5 then
         Result := Result + Copy(PadRight(ATitulo.Mensagem[4], 40, ' '), 1, 40) //Registro S mensagem 7
      else
         Result := Result + PadRight('', 40, ' ');

    if ATitulo.Mensagem.Count >= 6 then
         Result := Result + Copy(PadRight(ATitulo.Mensagem[5], 40, ' '), 1, 40) //Registro S mensagem 8
      else
         Result := Result + PadRight('', 40, ' ');

    if ATitulo.Mensagem.Count >= 7 then
         Result := Result + Copy(PadRight(ATitulo.Mensagem[6], 40, ' '), 1, 40) //Registro S mensagem 9
      else
         Result := Result + PadRight('', 40, ' ');
  end;

end;

function TACBrBancoBTGPactual.MontarCampoCodigoCedente (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
  Result := RightStr(ACBrTitulo.ACBrBoleto.Cedente.Agencia,4)+'/'+
            ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente;
end;

function TACBrBancoBTGPactual.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): String;
begin
  Result := PadLeft(IntToStr(StrToInt(ACBrTitulo.Carteira)), 3,'0')+'/' +
            ACBrTitulo.NossoNumero + '-' +
            CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoBTGPactual.GerarRegistroHeader240(NumeroRemessa: Integer): String;
var
  ATipoInscricao: string;
begin
  with ACBrBanco.ACBrBoleto.Cedente do
  begin
    case TipoInscricao of
      pFisica  : ATipoInscricao := '1';
      pJuridica: ATipoInscricao := '2';
    end;

    { GERAR REGISTRO-HEADER DO ARQUIVO }

    Result:= IntToStrZero(ACBrBanco.Numero, 3)           + // 001 a 003 C�digo do banco
             '0000'                                      + // 004 a 007 Lote de servi�o
             '0'                                         + // 008 a 008 Tipo de registro - Registro header de arquivo
             Space(9)                                    + // 009 a 017 Uso exclusivo FEBRABAN/CNAB
             ATipoInscricao                              + // 018 a 018 Tipo de inscri��o do cedente // fisica / jur
             PadLeft(OnlyNumber(CNPJCPF), 14, '0')       + // 019 a 032 N�mero de inscri��o do cedente
             PadRight(Convenio, 20, ' ')                 + // 033 a 052 C�digo do conv�nio no banco
             PadLeft(Agencia, 5, '0')                    + // 053 a 057 C�digo da ag�ncia mantenedora da conta
             PadRight(AgenciaDigito,1,' ')               + // 058 a 058 D�gito da ag�ncia (Branco)
             PadLeft(OnlyNumber(Conta), 12, '0')         + // 059 a 070 N�mero da conta cosmos
             PadRight(ContaDigito,1,' ')                 + // 071 a 071 DV Conta
             space(1)                                    + // 072 a 072 D�gito verificador da ag/conta
             PadRight(Nome, 30)                          + // 073 a 102 Nome da empresa
             PadRight('BANCO BTG PACTUAL S.A.', 30, ' ') + // 103 a 132 Nome do banco
             Space(10)                                   + // 133 a 142 Uso exclusivo FEBRABAN/CNAB
             '1'                                         + // 143 a 143 C�digo de Remessa (1) / Retorno (2)
             FormatDateTime('ddmmyyyy', Now)             + // 144 a 151 Data do de gera��o do arquivo
             FormatDateTime('hhmmss', Now)               + // 152 a 157 Hora de gera��o do arquivo
             PadLeft(IntToStr(NumeroRemessa), 6, '0')    + // 158 a 163 N�mero seq�encial do arquivo
             PadLeft(IntToStr(LayoutVersaoArquivo), 3, '0') + // 164 a 166 N�mero da vers�o do layout do arquivo
             PadLeft(DensidadeGravacao,5,'0')            + // 167 a 171 Densidade de grava��o do arquivo = "01600"
             Space(20)                                   + // 172 a 191 Para uso reservado do banco
             Space(20)                                   + // 192 a 211 Para uso reservado da empresa
             Space(29);                                    // 212 a 240 Uso exclusivo FEBRABAN/CNAB

    { GERAR REGISTRO HEADER DO LOTE }   {titulos em cobranca}

    Result:= Result                                      +
             #13#10                                      +
             IntToStrZero(ACBrBanco.Numero, 3)           + // 001 a 003 C�digo do banco
             '0001'                                      + // 004 a 007 Lote de servi�o
             '1'                                         + // 008 a 008 Tipo de registro = "1" HEADER LOTE
             'R'                                         + // 009 a 009 Tipo de opera��o: R (Remessa) ou T (Retorno)
             '01'                                        + // 010 a 011 Tipo de servi�o: 01 (Cobran�a)
             Space(2)                                    + // 012 a 013 Uso exclusivo FEBRABAN/CNAB
             PadLeft(IntToStr(LayoutVersaoLote),3,'0')   + // 014 a 016 N�mero da vers�o do layout do lote
             Space(1)                                    + // 017 a 017 Uso exclusivo FEBRABAN/CNAB
             ATipoInscricao                              + // 018 a 018 Tipo de inscri��o do cedente
             PadLeft(OnlyNumber(CNPJCPF), 15, '0')       + // 019 a 033 N�mero de inscri��o do cedente
             PadRight(Convenio, 20, ' ')                 + // 034 a 053 C�digo do conv�nio no banco
             PadLeft(Agencia, 5, '0')                    + // 054 a 058 C�digo da ag�ncia mantenedora da conta (Zeros)
             PadLeft(AgenciaDigito, 1, ' ')              + // 059 a 059 D�gito da ag�ncia
             PadLeft(OnlyNumber(Conta), 12, '0')         + // 060 a 071 N�mero da conta cosmos
             PadLeft(ContaDigito, 1, ' ')                + // 072 a 072 DV Conta
             PadLeft(DigitoVerificadorAgenciaConta, 1, ' ') + // 073 a 073 D�gito verificador da agencia conta
             PadRight(Nome, 30, ' ')                     + // 074 a 103 Nome do cedente
             Space(40)                                   + // 104 a 143 Mensagem 1
             Space(40)                                   + // 144 a 183 Mensagem 2
             '00000000'                                  + // 184 a 191 N�mero remessa/retorno {pq zero}
             FormatDateTime('ddmmyyyy', Now)             + // 192 a 199 Data de grava��o rem./ret.
             PadRight('', 8, '0')                        + // 200 a 207 Data do cr�dito - S� para arquivo retorno
             PadRight('', 33, ' ');                        // 208 a 240 Uso exclusivo FEBRABAN/CNAB
  end;
end;

procedure TACBrBancoBTGPactual.GerarRegistroHeader400(NumeroRemessa: Integer;
  aRemessa: TStringList);
begin
  raise Exception.Create( ACBrStr('N�o permitido para o layout CNAB400 deste banco.') );
end;

function TACBrBancoBTGPactual.GerarRegistroTransacao240(ACBrTitulo : TACBrTitulo): String;
var
  ATipoOcorrencia, ATipoBoleto, ATipoDistribuicao, ADataMoraJuros, CodProtesto, DiasProtesto: String;
  ACodigoDesconto, ADataDesconto, DigitoNossoNumero, ATipoAceite, AEspecieDoc, TipoSacado, EndSacado: String;
  ADiasBaixa, ACodigoCarteira, ATipoCarteira, ATipoDocumento: String;
  TipoAvalista: Char;
begin
  with ACBrTitulo do
  begin
    {Nosso N�mero}
    DigitoNossoNumero := CalcularDigitoVerificador(ACBrTitulo);

    {Aceite}
    case Aceite of
      atSim: ATipoAceite := 'A';
      atNao: ATipoAceite := 'N';
    end;

    {Esp�cieDoc}
    case AnsiIndexStr(UpperCase(EspecieDoc),['CH' ,'DM' ,'DMI','DS' ,'DSI','DR','LC','NCC','NCE',
                                             'NCI','NCR','NP' ,'NPR','TM' ,'TS','NS','RC' ,'FAT',
                                             'ND' ,'AP' ,'ME' ,'PC' ,'NF' ,'DD',
                                             'CPR','WAA','DAE','DAM','DAU','EC','CCC','DPD', {add casa}
                                             'BDA']) of
      0  : AEspecieDoc := '01';
      1  : AEspecieDoc := '02';
      2  : AEspecieDoc := '03';
      3  : AEspecieDoc := '04';
      4  : AEspecieDoc := '05';
      5  : AEspecieDoc := '06';
      6  : AEspecieDoc := '07';
      7  : AEspecieDoc := '08';
      8  : AEspecieDoc := '09';
      9  : AEspecieDoc := '10';
      10 : AEspecieDoc := '11';
      11 : AEspecieDoc := '12';
      12 : AEspecieDoc := '13';
      13 : AEspecieDoc := '14';
      14 : AEspecieDoc := '15';
      15 : AEspecieDoc := '16';
      16 : AEspecieDoc := '17';
      17 : AEspecieDoc := '18';
      18 : AEspecieDoc := '19';
      19 : AEspecieDoc := '20';
      20 : AEspecieDoc := '21';
      21 : AEspecieDoc := '22';
      22 : AEspecieDoc := '23';
      23 : AEspecieDoc := '24';
      24 : AEspecieDoc := '25'; { C�dula de Produto Rural}
      25 : AEspecieDoc := '26'; { Warrant}
      26 : AEspecieDoc := '27'; { D�vida Ativa de Estado}
      27 : AEspecieDoc := '28'; { D�vida Ativa de Munic�pio}
      28 : AEspecieDoc := '29'; { D�vida Ativa da Uni�o}
      29 : AEspecieDoc := '30'; { Encargos condominiais}
      30 : AEspecieDoc := '31'; { CC Cart�o de Cr�dito}
      31 : AEspecieDoc := '32'; { BDP � Boleto de Proposta}
      32 : AEspecieDoc := '33'; { Boleto de Dep�sito e Aporte}
    else
      AEspecieDoc := '99';      { Outros}
    end;

    {Pegando o Tipo de Ocorrencia}
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar             : ATipoOcorrencia := '02';
      toRemessaConcederAbatimento : ATipoOcorrencia := '04';
      toRemessaAlterarVencimento  : ATipoOcorrencia := '06';
      toRemessaConcederDesconto   : ATipoOcorrencia := '07';
      toRemessaProtestar          : ATipoOcorrencia := '09';
      toRemessaSustarProtesto     : ATipoOcorrencia := '11';
    else
      ATipoOcorrencia := '01';
    end;

    {Mora Juros}
    if (ValorMoraJuros > 0) and (DataMoraJuros > 0) then
      ADataMoraJuros := FormatDateTime('ddmmyyyy', DataMoraJuros)
    else
      ADataMoraJuros := PadRight('', 8, '0');

    {Descontos}
    if (ValorDesconto > 0) and (DataDesconto > 0) then
    begin
      if TipoDesconto = tdPercentualAteDataInformada then
        ACodigoDesconto := '2'
      else
        ACodigoDesconto := '1';
      ADataDesconto := FormatDateTime('ddmmyyyy', DataDesconto);
    end
    else
    begin
      if ValorDesconto > 0 then
        ACodigoDesconto := '3'
      else
        ACodigoDesconto := '0';
      ADataDesconto := PadRight('', 8, '0');
    end;

    {Protesto}
    CodProtesto  := '3';
    DiasProtesto := '00';
    if (DataProtesto > 0) and (DataProtesto > Vencimento) then
    begin
      CodProtesto := '1';
      DiasProtesto := PadLeft(IntToStr(DaysBetween(DataProtesto, Vencimento)), 2, '0');
    end;

    // N� Dias para Baixa/Devolucao
    ADiasBaixa  := '   ';
    if ((ATipoOcorrencia = '01') or
       (ATipoOcorrencia = '39')) and
       (Max(DataBaixa, DataLimitePagto) > Vencimento) then
       ADiasBaixa  := IntToStrZero(DaysBetween(Vencimento, Max(DataBaixa, DataLimitePagto)), 3);

    {Pegando Tipo de Boleto} //Quem emite e quem distribui o boleto?
    case ACBrBoleto.Cedente.ResponEmissao of
       tbBancoEmite : ATipoBoleto := '1';
       tbCliEmite   : ATipoBoleto := '2';
    else
      ATipoBoleto := '2';						 
    end;

    case ACBrBoleto.Cedente.IdentDistribuicao of
      tbBancoDistribui   : ATipoDistribuicao := '1';
      tbClienteDistribui : ATipoDistribuicao := '2';
    else
      ATipoDistribuicao := '2';							   
    end;

    {Sacado}
    case Sacado.Pessoa of
      pFisica:   TipoSacado := '1';
      pJuridica: TipoSacado := '2';
    else
      TipoSacado := '9';
    end;

    EndSacado := Sacado.Logradouro;
    if (Sacado.Numero <> '') then
      EndSacado := EndSacado + ', ' + Sacado.Numero;

    EndSacado := PadRight(trim(EndSacado), 40);

    {Avalista}
    if PadRight(Sacado.SacadoAvalista.CNPJCPF, 15, '0') = PadRight('0', 15, '0') then
      TipoAvalista := '0'
    else
      case Sacado.SacadoAvalista.Pessoa of
        pFisica:   TipoAvalista := '1';
        pJuridica: TipoAvalista := '2';
      else
        TipoAvalista := '9';
      end;

    {Codigo Carteira}
    case CaracTitulo of
      tcSimples            : ACodigoCarteira := '1'; {Cobran�a Simples (Sem Registro e Eletr�nica com Registro)}
      tcVinculada          : ACodigoCarteira := '2'; {Cobranca Vinculada}
      tcCaucionada         : ACodigoCarteira := '3'; {Cobran�a Caucionada (Eletr�nica com Registro e Convencional com Registro)}
      tcDescontada         : ACodigoCarteira := '4'; {Cobran�a Descontada (Eletr�nica com Registro)}
      tcVendor             : ACodigoCarteira := '5'; {Cobran�a Vendor}
    else
      ACodigoCarteira := '1';
    end;

    {Tipo carteira}
    case ACBrBoleto.Cedente.TipoCarteira of
      tctRegistrada: ATipoCarteira := '1';
      tctSimples   : ATipoCarteira := '2';
    else
      ATipoCarteira := '1';
    end;

    {Tipo documento}
    case ACBrBoleto.Cedente.TipoDocumento of
      Tradicional: ATipoDocumento := '1';
      Escritural : ATipoDocumento := '2';
    else
      ATipoDocumento := '1';
    end;
    {SEGMENTO P}
    fValorTotalDocs := fValorTotalDocs  + ValorDocumento;
    Inc(fpQtdRegsLote);
    Result:= IntToStrZero(ACBrBanco.Numero, 3)                                      + // 001 a 003 C�digo do banco  {Ok}
             '0001'                                                                 + // 004 a 007 Lote de servi�o {ok}
             '3'                                                                    + // 008 a 008 Tipo do registro: Registro detalhe
             IntToStrZero(fpQtdRegsLote, 5)                                         + // 009 a 013 N�mero seq�encial do registro no lote - Cada t�tulo tem 2 registros (P e Q)' {ok}
             'P'                                                                    + // 014 a 014 C�digo do segmento do registro detalhe {ok}
             Space(1)                                                               + // 015 a 015 Uso exclusivo FEBRABAN/CNAB: Branco ok
             ATipoOcorrencia                                                        + // 016 a 017 C�digo de movimento {2 digitos 01- entrada de titulos}
             PadLeft(ACBrBoleto.Cedente.Agencia, 5, '0')                            + // 018 a 022 Ag�ncia mantenedora da conta (Zeros)
             Space(1)                                                               + // 023 a 023 D�gito verificador da ag�ncia   {pq branco}
             PadLeft(OnlyNumber(ACBrBoleto.Cedente.Conta), 12, '0')                 + // 024 a 035 N�mero da conta cosmos {ok}
             PadRight(ACBrBoleto.Cedente.ContaDigito, 1, ' ')                       + // 036 a 036 D�gito verificador da conta {ok}
             Space(1)                                                               + // 037 a 037 D�gito verificador da ag/conta {?? pq branco}
             PadRight(NossoNumero, 20, ' ')                                         + // 038 a 057 Identifica��o do t�tulo no banco{OK}
             PadLeft(ACodigoCarteira, 1, ' ')                                       + // 058 a 058 C�digo da Carteira (caracter�stica dos t�tulos dentro das modalidades de cobran�a: '1' = Cobran�a Simples '3' = Cobran�a Caucionada) {ok}
             PadLeft(ATipoCarteira, 1, ' ')                                         + // 059 a 059 Forma de cadastramento do t�tulo no banco (1=Cobran�a Registrada, 2=Cobran�a sem Registro) {ok}            Space(1)                                                               + // 060 a 060 Tipo de documento: Brancos   {pq fica em branco ? tradicional/escritual}
             PadLeft(ATipoDocumento, 1, ' ')                                        + // 060 a 060 Tipo de documento: Brancos   {tradicional/escritual}
             PadLeft(ATipoBoleto, 1, ' ')                                           + // 061 a 061 Quem emite / ident da emissao boleto  pgto
             PadLeft(ATipoDistribuicao, 1, ' ')                                     + // 062 a 062 Quem distribui  {ok}
             PadRight(NumeroDocumento, 15)                                          + // 063 a 077 N� do documento de cobran�a {ok}
             FormatDateTime('ddmmyyyy', Vencimento)                                 + // 078 a 085 Data de vencimento do t�tulo  {ok}
             IntToStrZero( Round( ValorDocumento * 100), 15)                        + // 086 a 100 Valor nominal do t�tulo {ok}
             '00000'                                                                + // 101 a 105 Ag�ncia cobradora. Se ficar em branco, o BTGPACTUAL determina automaticamente pelo CEP do sacado {ok}
             Space(1)                                                               + // 106 a 106 D�gito da ag�ncia cobradora {nao existe digitos??}
             PadRight(AEspecieDoc, 2)                                               + // 107 a 108 Esp�cie do documento {ok}
             ATipoAceite                                                            + // 109 a 109 Identifica��o de t�tulo Aceito / N�o aceito {ok}
             FormatDateTime('ddmmyyyy', DataDocumento)                              + // 110 a 117 Data da emiss�o do documento {ok}
             PadLeft(trim(CodigoMora), 1)                                           + // 118 a 118 C�digo de mora (1=Valor di�rio; 2=Taxa Mensal; 3=Isento) {ok}
             ADataMoraJuros                                                         + // 119 a 126 Data a partir da qual ser�o cobrados juros {ok}
             IntToStrZero(round(ValorMoraJuros * 100), 15)                          + // 127 a 141 Valor de juros de mora por dia {ok}
             ACodigoDesconto                                                        + // 142 a 142 C�digo de desconto: 1 - Valor fixo at� a data informada, 2 - Percentual desconto 4-Desconto por dia de antecipacao 0 - Sem desconto
             ADataDesconto                                                          + // 143 a 150 Data do desconto {ok}
             IntToStrZero(round(ValorDesconto * 100), 15)                           + // 151 a 165 Valor do desconto por dia {ok}
             IntToStrZero(Round(ValorIOF * 100), 15)                                + // 166 a 180 Valor do IOF a ser recolhido {ok}
             IntToStrZero(Round(ValorAbatimento * 100), 15)                         + // 181 a 195 Valor do abatimento {ok}
             PadRight(NumeroDocumento, 25)                                          + // 196 a 220 Identifica��o do t�tulo na empresa  {ok}
             CodProtesto                                                            + // 221 a 221 C�digo para protesto   {ok}
             DiasProtesto                                                           + // 222 a 223 N�mero de dias para protesto {ok}
             IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento), '1', '2')        + // 224 a 224 C�digo para baixa/devolu��o: N�o baixar/n�o devolver
             ADiasBaixa                                                             + // 225 a 227 Brancos
             '09'                                                                   + // 228 a 229 C�digo da moeda: Real  {ok}
             PadRight('', 10 , '0')                                                 + // 230 a 239 Uso Exclusivo BTGPACTUAL  contrato {ok}
             Space(1);                                                                // 240 a 240 Uso exclusivo FEBRABAN/CNAB { ok}

    {SEGMENTO Q}
    Inc(fpQtdRegsLote);					   
    Result:= Result +  #13#10 +
             IntToStrZero(ACBrBanco.Numero, 3)                                          + // 001 a 003 C�digo do banco     {ok}
             '0001'                                                                     + // 004 a 007 N�mero do lote     {ok}
             '3'                                                                        + // 008 a 008 Tipo do registro: Registro detalhe  {ok}
             IntToStrZero(fpQtdRegsLote ,5)                                             + // 009 a 013 N�mero seq�encial do registro no lote - Cada t�tulo tem 2 registros (P e Q)  {ok}
             'Q'                                                                        + // 014 a 013 C�digo do segmento do registro detalhe  {ok}
             ' '                                                                        + // 015 a 015 Uso exclusivo FEBRABAN/CNAB: Branco  {ok}
             ATipoOcorrencia                                                            + // 016 a 017 C�digo de movimento  {ok}
             TipoSacado                                                                 + // 018 a 018 Tipo de inscri��o  {ok}
             PadLeft(OnlyNumber(Sacado.CNPJCPF), 15, '0')                               + // 019 a 033 N�mero de Inscri��o  {ok}
             PadRight(Sacado.NomeSacado, 40, ' ')                                       + // 034 a 073 Nome sacado  {ok}
             PadRight(EndSacado, 40, ' ')                                               + // 074 a 113 Endere�o  {ok}
             PadRight(Sacado.Bairro, 15, ' ')                                           + // 114 a 128 bairro sacado  {ok}
             Copy(PadLeft(OnlyNumber(Sacado.CEP),8,'0'),1,5)                            + // 129 a 133 CEP  {ok}
             Copy(PadLeft(OnlyNumber(Sacado.CEP),8,'0'),6,3)                            + // 134 a 136 Sufixo do CEP  {ok}
             PadRight(Sacado.Cidade, 15, ' ')                                           + // 137 a 151 cidade sacado  {ok}
             PadRight(Sacado.UF, 2, ' ')                                                + // 152 a 153 UF sacado  {ok}
             TipoAvalista                                                               + // 154 a 154 Tipo de inscri��o sacador/avalista  {ok}
             PadRight(Sacado.SacadoAvalista.CNPJCPF, 15, '0')                           + // 155 a 169 N�mero de inscri��o  {ok}
             PadRight(Sacado.SacadoAvalista.NomeAvalista,40,' ')                        + // 170 a 209 Nome do sacador/avalista  {ok}
             PadRight('', 3, '0')                                                       + // 210 a 212 Banco correspondente  {ok}
             PadRight('', 20, '0')                                                      + // 213 a 232 Nosso N�mero no banco correspondente  {ok}
             Space(8);                                                                    // 233 a 240 Uso exclusivo FEBRABAN/CNAB  {ok}
    if (PercentualMulta>0) or (Mensagem.Count>0) then
    begin
      {SEGMENTO R}
      Inc(fpQtdRegsLote);
      Result:= Result+ #13#10 +
               IntToStrZero(ACBrBanco.Numero, 3)                          + // 001 - 003 / C�digo do Banco na compensa��o
               '0001'                                                     + // 004 - 007 / Numero do lote remessa
               '3'                                                        + // 008 - 008 / Tipo de registro
               IntToStrZero(fpQtdRegsLote, 5)                             + // 009 - 013 / N�mero seq�encial do registro no lote
               'R'                                                        + // 014 - 014 / C�d. Segmento do registro detalhe
               Space(1)                                                   + // 015 - 015 / Reservado (uso Banco)
               ATipoOcorrencia                                            + // 016 - 017 / C�digo de movimento remessa
               '0'                                                        + // 018 - 018 / C�digo do desconto 2
               PadLeft('', 8, '0')                                        + // 019 - 026 / Data do desconto 2
               IntToStrZero(0, 15)                                        + // 027 - 041 / Valor/Percentual a ser concedido 2
               '0'                                                        + // 042 - 042 / C�digo do desconto 3
               PadLeft('', 8, '0')                                        + // 043 - 050 / Data do desconto 3
               IntToStrZero(0, 15)                                        + // 051 - 065 / Valor/Percentual a ser concedido 3
               IfThen(PercentualMulta>0,
                 IfThen(MultaValorFixo,'1','2'),
                 '0')                                                     + // 066 - 066 1-Cobrar Multa Valor Fixo / 2-Percentual / 0-N�o cobrar multa
               IfThen(PercentualMulta>0,
                 FormatDateTime('ddmmyyyy', DataMulta),
                 PadLeft('', 8, '0'))                                     + // 067 - 074 Se cobrar informe a data para iniciar a cobran�a ou informe zeros se n�o cobrar
               IntToStrZero(Round(PercentualMulta * 100), 15)             + // 075 - 089 / Valor/Percentual a ser aplicado
               Space(10)                                                  + // 090 - 099 / Reservado (uso Banco)
               MontaInstrucoesCNAB240(ACBrTitulo,1)                       + // 100 - 139 / Mensagem 3
                                                                            // 140 - 179 / Mensagem 4
               Space(20)                                                  + // 180 - 199 / CNAB Uso Exclusivo FEBRABAN/CNAB
               PadRight('', 8, '0')                                       + // 200 - 207 / C�d. Ocor. do Pagador
               PadRight('', 3, '0')                                       + // 208 - 210 / C�d. do Banco na Conta do D�bito
               PadRight('', 5, '0')                                       + // 211 - 215 / C�digo da Ag�ncia do D�bito
               Space(1)                                                   + // 216 - 216 / D�gito Verificador da Ag�ncia
               PadRight('', 12, '0')                                      + // 217 - 228 / Conta Corrente para D�bito
               Space(1)                                                   + // 229 - 229 / D�gito Verificador da Conta
               Space(1)                                                   + // 230 - 230 / DV D�gito Verificador Ag/Conta
               PadRight('', 1, '0')                                       + // 231 - 231 / Aviso D�b. Aviso para D�bito Autom�tico
               Space(9);                                                    // 232 - 240 / CNAB Uso Exclusivo FEBRABAN/CNAB
      {SEGMENTO R - FIM}
    end;

    if (Mensagem.Count > 2) then
    begin
      {SEGMENTO S}
      Inc(fpQtdRegsLote);
      Result:= Result+ #13#10 +
               IntToStrZero(ACBrBanco.Numero, 3)     + // 001 - 003 / C�digo do Banco na compensa��o
               '0001'                                           + // 004 - 007 / Numero do lote remessa
               '3'                                              + // 008 - 008 / Tipo de registro
               IntToStrZero(fpQtdRegsLote, 5)                   + // 009 - 013 / N�mero seq�encial do registro no lote
               'S'                                              + // 014 - 014 / C�d. Segmento do registro detalhe
               Space(1)                                         + // 015 - 015 / Reservado (uso Banco)
               ATipoOcorrencia                                  + // 016 - 017 / C�digo de movimento remessa
               '2'                                              + // 018 - 018 / Identifica��o da impress�o
               MontaInstrucoesCNAB240(ACBrTitulo,2)             + // 019 - 058 / Mensagem 5
                                                                  // 059 - 098 / Mensagem 6
                                                                  // 099 - 138 / Mensagem 7
                                                                  // 139 - 178 / Mensagem 8
                                                                  // 179 - 218 / Mensagem 9
               Space(22);                                         // 219 - 240 / Reservado (uso Banco)
      {SEGMENTO S - FIM}
    end;
  end;
end;

procedure TACBrBancoBTGPactual.LerRetorno400(ARetorno: TStringList);
begin
  raise Exception.Create( ACBrStr('N�o permitido para o layout CNAB400 deste banco.') );
end;

function TACBrBancoBTGPactual.GerarRegistroTrailler240( ARemessa : TStringList ): String;
begin

  { REGISTRO TRAILER DO LOTE Pagina 68 - Unico Trailler com layout compativel }
  Result := IntToStrZero(ACBrBanco.Numero, 3)                         + // 001 - 003 C�digo do banco
           '0001'                                                     + // 004 - 007 Lote de Servi�o
           '5'                                                        + // 008 - 008 Tipo do registro: Registro trailer do lote
           Space(9)                                                   + // 009 - 017 Uso exclusivo FEBRABAN/CNAB
           IntToStrZero((fpQtdRegsLote + 2 ), 6)                      + // 018 - 023 Quantidade de Registro no Lote (Registros P,Q header e trailer do lote)
           IntToStrZero((0), 6)                                       + // 024 - 029 Quantidade t�tulos em cobran�a (CHEQUES)
           IntToStrZero(Round(fValorTotalDocs * 100), 17)             + // 030 - 046 Valor dos t�tulos em carteiras}
           PadRight('',06, '0')                                       + // 047 - 052 Quantidade t�tulos em cobran�a
           PadRight('',17, '0')                                       + // 053 - 069 Valor dos t�tulos em carteiras}
           PadRight('',06, '0')                                       + // 070 - 075 Quantidade t�tulos em cobran�a
           PadRight('',17, '0')                                       + // 076 - 092 Quantidade de T�tulos em Carteiras
           PadRight('',06, '0')                                       + // 093 - 098 Quantidade t�tulos em cobran�a
           PadRight('',17, '0')                                       + // 099 - 115 Quantidade de T�tulos em Carteiras
           Space(8)                                                   + // 116 - 123 N�mero do aviso de lan�amento
           Space(117);                                                  // 124 - 240 Uso exclusivo FEBRABAN/CNAB

  {GERAR REGISTRO TRAILER DO ARQUIVO - Pagina 18 }
  Result:= Result + #13#10 +
           IntToStrZero(ACBrBanco.Numero, 3)                          + // 001 - 003 C�digo do banco
           '9999'                                                     + // 004 - 007 Lote de servi�o
           '9'                                                        + // 008 - 008 Tipo do registro: Registro trailer do arquivo
           PadRight('',9,' ')                                         + // 009 - 017 Uso exclusivo FEBRABAN/CNAB}
           '000001'                                                   + // 018 - 023 Quantidade de lotes do arquivo (Registros P,Q header e trailer do lote e do arquivo)
           IntToStrZero((fpQtdRegsLote + 4), 6)                       + // 024 - 029 Quantidade de registros do arquivo, inclusive este registro que est� sendo criado agora}
           PadRight('',006,'0')                                       + // 030 - 035 Uso exclusivo FEBRABAN/CNAB}
           PadRight('',205,' ');                                        // 240 - 205 Uso exclusivo FEBRABAN/CNAB}


  fValorTotalDocs := 0;
  fpQtdRegsLote   := 0;
end;
end.
