{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andr� Ferreira de Moraes,                       }
{                              Paulo H. Ribeiro,                               }
{                              Jackeline Bellon,                               }
{                              Juliomar Marchetti,                             }
{                              Victor H Gonzales,                              }
{                              Fernando Rodrigo                                }
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

unit ACBrBancoSafra;

interface

uses Classes, SysUtils, StrUtils, ACBrBoleto, DateUtils, Math, ACBrBoletoConversao;

type

  { TACBrBancoSafra }
  TACBrBancoSafra = class(TACBrBancoClass)
  private
  protected
    FNumeroRemessa: Integer;
    FSequencia : Integer;
    FQuantidadeCobrancaSimples,
    FQuantidadeCobrancaVinculada,
    FQuantidadeCobrancaCaucionada,
    FQuantidadeCobrancaDescontada : Integer;
    FValorCobrancaSimples,
    FValorCobrancaVinculada,
    FValorCobrancaCaucionada,
    FValorCobrancaDescontada : Currency;
  public
    constructor Create(AOwner: TACBrBanco);
    function CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string; override;
    procedure GerarRegistroHeader400(NumeroRemessa: integer;
      ARemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo;
      aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa: TStringList); override;
    procedure LerRetorno400(ARetorno: TStringList); override;

    function TipoOcorrenciaToDescricao(
      const TipoOcorrencia: TACBrTipoOcorrencia): string; override;
    function CodOcorrenciaToTipo(const CodOcorrencia: integer): TACBrTipoOcorrencia;
      override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): string;
      override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia;
      CodMotivo: integer): string; override;

    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;

    function GerarRegistroHeader240(NumeroRemessa: Integer): string; override;
    function GerarRegistroTrailler240(ARemessa: TStringList): string; override;
    function GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): string; override;
    procedure LerRetorno240(ARetorno: TStringList); override;

  end;

implementation

uses ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.Strings, ACBrUtil.DateTime;

var
  aTotal: Extended;
  aCount: Integer;

{ TACBrBancoSafra }

constructor TACBrBancoSafra.Create(AOwner: TACBrBanco);
begin
  inherited Create(AOwner);
  fpDigito                := 7;
  fpNome                  := 'Banco Safra';
  fpNumero                := 422;
  fpTamanhoAgencia        := 5;
  fpTamanhoConta          := 8;
  fpTamanhoCarteira       := 1;
  fpTamanhoMaximoNossoNum := 9;
  fpLayoutVersaoArquivo   := 87;
  fpLayoutVersaoLote      := 45;
end;

function TACBrBancoSafra.CalcularDigitoVerificador(
  const ACBrTitulo: TACBrTitulo): string;
begin
  Modulo.CalculoPadrao;
  Modulo.Documento := ACBrTitulo.NossoNumero;
  Modulo.Calcular;
  if Modulo.ModuloFinal = 0 then
    Result := '1'
  else
    Result := IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoSafra.CodMotivoRejeicaoToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: integer): string;
begin
  case TipoOcorrencia of
    toRetornoRegistroRecusado:
      case CodMotivo of
        001: Result := '001-MOEDA INV�LIDA';
        002: Result := '002-MOEDA INV�LIDA PARA CARTEIRA';
        003: Result := '003-CARTEIRA TR�S INV�LIDA PARA TIPO DE MOEDA';
        004: Result := '004-TIPO DE IOF. INV�LIDO PARA CPBRAN�A DE SEGUROS';
        005: Result := '005-TIPO DE IOF. INV�LIDO PARA VALOR DE IOF (SEGUROS)';
        006: Result := '006-VALOR DE IOF INV�LIDO (SEGUROS)';
        007: Result := '007-CEP N�O CORRESPONDE UF';
        008: Result := '008-VALOR JUROS AO DIA MAIOR QUE 5% DO VALOR DO T�TULO';
        009: Result := '009-USO EXCLUSIVO N�O NUM�RICO PARA COBRAN�A EXPRESS';
        010: Result := '010-SEU N�MERO - N�O NUM�RICO PARA CHEQUE';
        011: Result := '011-NOSSO N�MERO FORA DA FAIXA';
        012: Result := '012-CEP DE CIDADE INEXISTENTE';
        013: Result := '013 - CEP FORA DE FAIXA DA CIDADE';
        014: Result := '014 - UF INVALIDO PARA CEP DA CIDADE';
        015: Result := '015 - CEP ZERADO';
        016: Result := '016 - CEP N�O CONSTA NA TABELA SAFRA';
        017: Result := '017 - CEP N�O CONSTA TABELA BCO. CORRESPONDENTE';
        018: Result := '018 - DADOS DO CHEQUE N�O NUM�RICO';
        019: Result := '019 - PROTESTO IMPRATIC�VEL';
        020: Result := '020 - PRIMEIRA INSTRU��O DE COBRAN�A INVALIDA';
        021: Result := '021 - SEGUNDA INSTRU��O DE COBRAN�A INV�LIDA';
        022: Result := '022 - SEGUNDA INSTR. (10) E TERCEIRA INSTR. INVALIDA';
        023: Result := '023 - TERCEIRA INSTRU��O DE COBRAN�A INV�LIDA';
        024: Result := '024 - DIGITO VERIFICADOR C1 INV�LIDO';
        025: Result := '025 - DIGITO VERIFICADOR C2 INV�LIDO';
        026: Result := '026 - C�DIGO DE OPERA��O/OCORR�NCIA INV�LIDO';
        027: Result := '027 - OPERA��O INV�LIDA PARA O CLIENTE';
        028: Result := '028 - NOSSO N�MERO N�O NUM�RICO OU ZERADO';
        029: Result := '029 - NOSSO N�MERO COM D�GITO DE CONTROLE ERRADO';
        030: Result := '030 - VALOR DO ABATIMENTO N�O NUM�RICO OU ZERADO';
        031: Result := '031 - SEU N�MERO EM BRANCO';
        032: Result := '032 - C�DIGO DA CARTEIRA INV�LIDO';
        033: Result := '033 - DIGITO VERIFICADOR C3 INV�LIDO';
        034: Result := '034 - C�DIGO DO T�TULO INV�LIDO';
        035: Result := '035 - DATA DE MOVIMENTO INV�LIDA';
        036: Result := '036 - DATA DE EMISS�O INV�LIDA';
        037: Result := '037 - DATA DE VENCIMENTO INV�LIDA';
        038: Result := '038 - DEPOSIT�RIA INV�LIDA';
        039: Result := '039 - DEPOSIT�RIA INV�LIDA PARA O CLIENTE';
        040: Result := '040 - DEPOSIT�RIA N�O CADASTRADA NO BANCO';
        041: Result := '041 - C�DIGO DE ACEITE INV�LIDO';
        042: Result := '042 - ESP�CIE DE T�TULO INV�LIDO';
        043: Result := '043 - INSTRU��O DE COBRAN�A INV�LIDA';
        044: Result := '044 - VALOR DO T�TULO N�O NUM�RICO OU ZERADO';
        045: Result := '045 - DATA DE OPERA��O INVALIDA';
        046: Result := '046 - VALOR DE JUROS N�O NUM�RICO OU ZERADO';
        047: Result := '047 - DATA LIMITE PARA DESCONTO INV�LIDA';
        048: Result := '048 - VALOR DO DESCONTO INV�LIDO';
        049: Result := '049 - VALOR IOF. N�O NUM�RICO OU ZERADO (SEGUROS)';
        050: Result := '050 - ABATIMENTO COM VALOR PARA OPERA��O "01" (Entrada de T�tulo)';
        051: Result := '051 - C�DIGO DE INSCRI��O DO SACADO INV�LIDO';
        052: Result := '052 - C�DIGO DE INSCRI��O / N�MERO DE INSCRI��O DO SACADO INV�LIDO';
        053: Result := '053 - N�MERO DE INSCRI��O DO SACADO N�O NUM�RICO OU D�GITO ERRADO';
        054: Result := '054 - NOME DO SACADO EM BRANCO';
        055: Result := '055 - ENDERE�O DO SACADO EM BRANCO';
        056: Result := '056 - CLIENTE N�O RECADASTRADO';
        057: Result := '057 - CLIENTE BLOQUEADO (quando opera��o de desconto e cliente sem n�mero; de border� dispon�vel)';
        058: Result := '058 - PROCESSO DE CART�RIO INV�LIDO';
        059: Result := '059 - ESTADO DO SACADO INV�LIDO';
        060: Result := '060 - CEP / ENDERE�O DIVERGEM DO CORREIO';
        061: Result := '061 - INSTRU��O AGENDADA PARA AG�NCIA';
        062: Result := '062 - OPERA��O INV�LIDA PARA A CARTEIRA';
        063: Result := '063 - Carteira inv�lida para Cobran�a Direta';
        064: Result := '064 - T�TULO INEXISTENTE (TFC)';
        065: Result := '065 - OPERA��O / T�tulo J� EXISTENTE';
        066: Result := '066 - T�TULO J� EXISTE (TFC)';
        067: Result := '067 - DATA DE VENCIMENTO INV�LIDA PARA PROTESTO';
        068: Result := '068 - CEP DO SACADO N�O CONSTA NA TABELA';
        069: Result := '069 - PRA�A N�O ATENDIDA PELO SERVI�O CART�RIO';
        070: Result := '070 - AG�NCIA INV�LIDA';
        071: Result := '071 - CLIENTE N�O CADASTRADO';
        072: Result := '072 - T�TULO J� EXISTE (COB)';
        073: Result := '073 - TAXA OPERA��O N�O NUM�RICA OU ZERADA (VENDOR)';
        074: Result := '074 - T�TULO FORA DE SEQ��NCIA';
        075: Result := '075 - TAXA DE OPERA��O ZERADA (VENDOR)';
        076: Result := '076 - EQUALIZA��O N�O NUM�RICA OU INV�LIDA (VENDOR)';
        077: Result := '077 - TAXA NEGOCIADA N�O NUM�RICA OU ZERADA (VENDOR)';
        078: Result := '078 - T�TULO INEXISTENTE (COB)';
        079: Result := '079 - OPERA��O N�O CONCLU�DA';
        080: Result := '080 - T�TULO J� Baixado';
        081: Result := '081 - T�TULO N�O DESCONTADO';
        082: Result := '082 - INTERVALO ENTRE DATA DE OPERA��O E DATA VCTO MENOR QUE UM DIA';
        083: Result := '083 - PRORROGA��O / ALTERA��O DE VENCIMENTO INV�LIDA';
        084: Result := '084 - MOVIMENTO IGUAL AO CADASTRO DE EXIST�NCIA DO COB';
        085: Result := '085 - C�DIGO OPERA��O COM PCB INV�LIDO (OPERA��O INV�LIDA P/ CARTEIRA)';
        086: Result := '086 - ABATIMENTO MAIOR QUE VALOR DO T�TULO';
        087: Result := '087 - ALTERA��O DE CART�RIO INV�LIDA';
        088: Result := '088 - T�TULO RECUSADO COMO GARANTIA (Sacado / Novo / Exclusivo Al�ada comit�)';
        089: Result := '089 - ALTERA��O DE DATA DE PROTESTO INV�LIDA';
        090: Result := '090 - MODALIDADE DE VENDOR INVALIDO';
        091: Result := '091 - PCB CTO INVALIDA';
        092: Result := '092 - DATA DE OPERA��O CTO INV�LIDA';
        093: Result := '093 - BAIXA DE T�TULO DE OUTRA AG�NCIA';
        094: Result := '094 - ENTRADA T�TULO COBRAN�A DIRETA INV�LIDA';
        095: Result := '095 - BAIXA T�TULO COBRAN�A DIRETA INV�LIDA';
        096: Result := '096 - VALOR DO T�TULO INV�LIDO';
        097: Result := '097 - MOEDA INV�LIDA PARA BANCO CORRESPONDENTE';
        098: Result := '098 - PCB DO TFC DIVERGEM DA PCB DO COB';
        099: Result := '099 - INCLUS�O DE TERCEIRA MOEDA INV�LIDA';
        100: Result := '115 - ESP�CIE DOC INV�LIDO PARA MODAL/RAMO DE ATIVIDADE (RESERVADO CTO)';
        else
          Result := IntToStrZero(CodMotivo, 3) + ' - Outros Motivos';
      end;
  end;
end;

function TACBrBancoSafra.CodOcorrenciaToTipo(const CodOcorrencia: integer):
TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    04: Result := toRetornoTransferenciaCarteiraEntrada;
    05: Result := toRetornoTransferenciaCarteiraBaixa;
    06: Result := toRetornoLiquidado;
    07: Result := toRetornoLiquidadoParcialmente;
    09: Result := toRetornoBaixaAutomatica;
    10: Result := toRetornoBaixadoInstAgencia;
    11: Result := toRetornoTituloEmSer;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoLiquidadoEmCartorio;
    16: Result := toRetornoBaixadoFrancoPagamento;
    17: Result := toRetornoEntradaBorderoManual;
    18: Result := toRetornoAlteracaoUsoCedente;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    21: Result := toRetornoTransferenciaCedente;
    23: Result := toRetornoEncaminhadoACartorio;
    40: Result := toRetornoBaixaPorProtesto;
    41: Result := toRetornoLiquidadoAposBaixaOuNaoRegistro;
    42: Result := toRetornoRetiradoDeCartorio;
    43: Result := toRetornoDespesaCartorio;
    44: Result := toRetornoDebitoDiretoAutorizado;
    45: Result := toRetornoDebitoDiretoNaoAutorizado;
    51: Result := toRetornoRecebimentoInstrucaoAlterarValorTitulo;
    52: Result := toRetornoAlteracaoDataEmissao;
    53: Result := toRetornoAlteracaoEspecie;
    54: Result := toRetornoAlteracaoSeuNumero;
    60: Result := toRetornoEqualizacaoVendor;
    77: Result := toRetornoRecebimentoInstrucaoAlterarJuros;
    else
      Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoSafra.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Altera��o de vencimento}
    07 : Result:= toRemessaAlterarExclusivoCliente;         {Altera��o "Uso Exclusivo do Cliente"}
    08 : Result:= toRemessaAlterarNumeroControle;           {Altera��o de seu n�mero}
    09 : Result:= toRemessaProtestar;                       {Pedido de protesto}
    10 : Result:= toRemessaNaoProtestar;                    {N�o Protestar}
    11 : Result:= toRemessaNaoCobrarJurosMora;              {N�o Cobrar Juros de Mora}
    16 : Result:= toRemessaCobrarJurosMora;                 {Cobrar Juros de Mora}
    31 : Result:= toRemessaAlterarValorTitulo;              {Altera��o do Valor do T�tulo}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;
end;

function TACBrBancoSafra.GerarRegistroHeader240(NumeroRemessa: Integer): string;
var
  wLinha,
  wLinha2: String;
  dataCredito : String;
begin
  FSequencia := 0;
  FQuantidadeCobrancaSimples := 0;
  FQuantidadeCobrancaVinculada := 0;
  FQuantidadeCobrancaCaucionada := 0;
  FQuantidadeCobrancaDescontada := 0;
  FValorCobrancaSimples := 0;
  FValorCobrancaVinculada := 0;
  FValorCobrancaCaucionada := 0;
  FValorCobrancaDescontada := 0;
  FNumeroRemessa := NumeroRemessa;

  if ACBrBanco.ACBrBoleto.DataCreditoLanc = 0 then
    dataCredito := '00000000'
  else
    dataCredito := FormatDateTime('ddmmyyyy', ACBrBanco.ACBrBoleto.DataCreditoLanc);
  with ACBrBanco.ACBrBoleto.Cedente do
  begin
    { Lote 0000 }
    wLinha := IntToStrZero(ACBrBanco.Numero, 3)                 + // 001-003 / C�digo do Banco na Compensa��o
              '0000'                                            + // 004-007 / Lote de Servi�o
              '0'                                               + // 008-008 / Tipo de Registro
              Space(9)                                          + // 009-017 / Campo sem Preenchimento
              IfThen(TipoInscricao = pFisica, '1', '2')         + // 018-018 / Tipo de Inscri��o da Empresa
              PadLeft(Trim(OnlyNumber(CNPJCPF)), 14, '0')       + // 019-032 / N�mero de Inscri��o da Empresa
              PadLeft(CodigoCedente, 20, ' ')                   + // 033-052 / C�digo do Conv�nio no Banco
              PadRight(Agencia, 5, '0')                         + // 053-057 / Ag�ncia Mantenedora da Conta
              PadLeft(AgenciaDigito, 1)                         + // 058-058 / D�gito Verificador da Ag�ncia
              PadLeft(Conta, 12, '0')                           + // 059-070 / N�mero da Conta Corrente
              PadLeft(ContaDigito, 1)                           + // 071-071 / D�gito Verificador da Conta
              ' '                                               + // 072-072 / D�gito Verificador da Ag/Conta
              PadRight(Nome, 30)                                + // 073-102 / Nome da Empresa
              PadRight('BANCO SAFRA S/A', 30)                   + // 103-132 / Nome do Banco
              Space(10)                                         + // 133-142 / Campo sem Preenchimento
              '1'                                               + // 143-143 / C�digo Remessa/Retorno
              FormatDateTime('ddmmyyyy', Now)                   + // 144-151 / Data de Gera��o do Arquivo
              FormatDateTime('hhnnss', Now)                     + // 152-157 / Hora e Gera��o do Arquivo
              IntToStrZero(NumeroRemessa, 6)                    + // 158-163 / N�mero Sequencial do Arquivo
              PadLeft(IntToStr(fpLayoutVersaoArquivo), 3, '0')  + // 164-166 / N� da Vers�o do Layout do Arquivo
              '01600'                                           + // 167-171 / Densidade de Grava��o do Arquivo
              Space(20)                                         + // 172-191 / Para uso Reservado do Banco
              Space(20)                                         + // 192-211 / Para uso Reservado da Empresa
              Space(29)                                         ; // 212-240 / Campo sem preenchimento

    { Lote 0001 }
    wLinha2 := IntToStrZero(ACBrBanco.Numero, 3)                                + // 001-003 / C�digo do Banco na Compensa��o
               '0001'                                                           + // 004-007 / Lote de Servi�o
               '1'                                                              + // 008-008 / Tipo de Registro
               'R'                                                              + // 009-009 / Tipo de Opera��o
               '01'                                                             + // 010-011 / Tipo de Servi�o
               Space(2)                                                         + // 012-013 / Campo sem Preenchimento
               PadLeft(IntToStr(fpLayoutVersaoLote), 3, '0')                    + // 014-016 / N� da vers�o do layout do Lote
               ' '                                                              + // 017-017 / Campo sem preenchimento
               IfThen(TipoInscricao = pFisica, '1', '2')                        + // 018-018 / Tipo de Inscri��o da Empresa
               PadLeft(Trim(OnlyNumber(CNPJCPF)), 15, '0')                      + // 019-033 / N�mero de Inscri��o da Empresa
               PadLeft(CodigoCedente, 20, ' ')                                  + // 034-053 / C�digo do Conv�nio no Banco
               PadRight(Agencia, 5, '0')                                        + // 054-058 / Ag�ncia Mantenedora da Conta
               PadLeft(AgenciaDigito, 1)                                        + // 059-059 / D�gito Verificador da Ag�ncia
               PadLeft(Conta, 12, '0')                                          + // 060-071 / N�mero da Conta Corrente
               PadLeft(ContaDigito, 1)                                          + // 072-072 / D�gito Verificador da Conta
               ' '                                                              + // 073-073 / D�gito Verificador da Ag/Conta
               PadRight(Nome, 30)                                               + // 074-103 / Nome da Empresa
               Space(40)                                                        + // 104-143 / Mensagem 1
               Space(40)                                                        + // 144-183 / Mensagem 2
               PadLeft(IntToStr(NumeroRemessa), 8, '0')                         + // 184-191 / N� temessa
               FormatDateTime('ddmmyyyy', Now)                                  + // 192-199 / Data de gera��o do arquivo
               dataCredito                                                      + // 200-207 / Data do Cr�dito
               Space(33)                                                        ; // 208-240 / Reservado (uso Banco)

    Result := UpperCase(
                wLinha +
                #13#10 +
                wLinha2
              );
  end;
end;

procedure TACBrBancoSafra.GerarRegistroHeader400(NumeroRemessa: integer;
  ARemessa: TStringList);
var wLinha: String;
  aAgencia,
  aConta: String;
begin
  aTotal := 0;
  aCount := 0;
  aAgencia := PadLeft(RightStr( ACBrBanco.ACBrBoleto.Cedente.Agencia, 5), 5, '0');

  aConta := PadLeft(ACBrBanco.ACBrBoleto.Cedente.Conta, 8, '0') +
              PadLeft(ACBrBanco.ACBrBoleto.Cedente.ContaDigito, 1, '0');
  FNumeroRemessa := NumeroRemessa;
  with ACBrBanco.ACBrBoleto.Cedente do
  begin
    wLinha := '0'                             + // ID do Registro Header
              '1'                             + // ID do Arquivo de Remessa
              'REMESSA'                       + // Literal de Remessa
              '01'                            + // C�digo do Tipo de Servi�o
              PadRight('COBRANCA', 15)        + // Descri��o do tipo de servi�o + "brancos"
              aAgencia + aConta               + // Codigo da Empresa no Banco
              Space(6)                        + // "brancos"
              PadRight(Nome, 30)              + // Nome da Empresa
              IntToStr(Numero)                + // C�digo do Banco - 237
              PadRight('BANCO SAFRA', 15)     + // Nome do Banco - BANCO SAFRA + "brancos"
              FormatDateTime('ddmmyy', Now)   + // Data de gera��o do arquivo
              Space(291)                      + // "brancos"
              IntToStrZero(NumeroRemessa, 3)  + // Nr. Sequencial de Gera��o do Arquivo
              IntToStrZero(1, 6);               // Nr. Sequencial do Registro no Arquivo

    ARemessa.Text := ARemessa.Text + UpperCase(wLinha);
  end;

end;

function TACBrBancoSafra.GerarRegistroTrailler240(
  ARemessa: TStringList): string;
var
  wLinha,
  wLinha2: String;
begin
  wLinha := IntToStrZero(ACBrBanco.Numero, 3)                       + // 001-003 / C�digo do Banco na compensa��o
            '0001'                                                  + // 004-007 / Numero do lote remessa
            '5'                                                     + // 008-008 / Tipo de registro
            Space(9)                                                + // 009-017 / Reservado (uso Banco)
            IntToStrZero(FSequencia + 2, 6)                         + // 018-023 / Quantidade de registros do lote
            IntToStrZero(FQuantidadeCobrancaSimples, 6)             + // 024-029 / Quantidade de T�tulos em Cobran�a Simples
            IntToStrZero(round(FValorCobrancaSimples * 100), 17)    + // 030-046 / Valor Total dos T�tulos em Cobran�a Simples
            IntToStrZero(FQuantidadeCobrancaVinculada, 6)           + // 047-052 / Quantidade de T�tulos em Cobran�a Vinculada
            IntToStrZero(round(FValorCobrancaVinculada * 100), 17)  + // 053-069 / Valor Total dos T�tulos em Cobran�a Vinculada
            IntToStrZero(FQuantidadeCobrancaCaucionada, 6)          + // 070-075 / Quantidade de T�tulos em Cobran�a Caucionada
            IntToStrZero(round(FValorCobrancaCaucionada * 100), 17) + // 076-092 / Valor Total dos T�tulos em Cobran�a Caucionada
            IntToStrZero(FQuantidadeCobrancaDescontada, 6)          + // 093-098 / Quantidade de T�tulos em Cobran�a Descontada
            IntToStrZero(round(FValorCobrancaDescontada * 100), 17) + // 099-115 / Valor Total dos T�tulos em Cobran�a Descontada
            Space(8)                                                + // 116-123 / N�mero de Aviso do Lan�amento
            Space(117)                                              ; // 124-240 / Campo sem Preenchimento

  wLinha2 := IntToStrZero(ACBrBanco.Numero, 3)   + // 001-003 / C�digo do Banco na compensa��o
             '9999'                              + // 004-007 / Numero do lote remessa
             '9'                                 + // 008-008 / Tipo de registro
             space(9)                            + // 009-017 / Reservado (uso Banco)
             '000001'                            + // 018-023 / Quantidade de lotes do arquivo
             IntToStrZero(FSequencia + 4, 6) + // 024-029 / Quantidade de registros do arquivo
             '000000'                            + // 030-035 / Quantidade de Contas p/ Conc. (Lotes)
             Space(205)                          ; // 036-240 / Reservado (uso Banco)

  Result:= wLinha +
           #13#10 +
           wLinha2;
end;

procedure TACBrBancoSafra.GerarRegistroTrailler400(ARemessa: TStringList);
var
  wLinha: String;
begin
  wLinha := '9'                               + // Identifica��o do Registro do Trailler
  Space(367)                                  + // "Branc"
  PadLeft(IntToStr(aCount), 8, '0')           + // Quantidade de t�tulos no arquivo
  FormatCurr('000000000000000', aTotal * 100) + // Valor total dos t�tulos
  IntToStrZero(FNumeroRemessa, 3)             + // Nr. Sequencial de Gera��o do Arquivo
  IntToStrZero(ARemessa.Count + 1, 6);          // N�mero Sequencial do Registro do Arquivo

  ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
end;

function TACBrBancoSafra.GerarRegistroTransacao240(
  ACBrTitulo: TACBrTitulo): string;
var
  segmentoP,
  segmentoQ,
  segmentoR : string;
  sCodMovimento,
  sTipoInscricao,
  aTipoInscricao,
  sEndereco,
  sEspecie,
  sTipoCobranca,
  sTipoCarteira,
  sTipoDocto,
  STipoJuros,
  sDataMoraJuros,
  sTipoDesconto,
  sDataDesconto,
  sDiasProtesto,
  sDiasBaixaDevol : String;
  ACodProtesto: Char;
  function MontarInstrucoes1: string;
  begin
    with ACBrTitulo do
    begin
      if Mensagem.Count = 0 then
      begin
        Result := PadRight('', 80, ' '); // 2 registros
        Exit;
      end;

      Result := '';
      if Mensagem.Count >= 1 then
      begin
        Result := Result +
                  Copy(PadRight(Mensagem[0], 40, ' '), 1, 40);
      end;

      if Mensagem.Count >= 2 then
      begin
        Result := Result +
                  Copy(PadRight(Mensagem[1], 40, ' '), 1, 40)
      end
      else
      begin
        if (Result <> EmptyStr) then
          Result := Result + PadRight('', 40, ' ')  // 1 registro
        else
          Result := Result + PadRight('', 80, ' '); // 2 registros
        Exit;
      end;
    end;
  end;

  function MontarInstrucoes2: string;
  begin
    with ACBrTitulo do
    begin
      if (Mensagem.Count <= 2) then
      begin
        // Somente duas linhas, foi montado o MonarInstrucoes1
        Result := PadRight('', 200, ' ');
        Exit;
      end;

      Result := '';
      if Mensagem.Count >= 3 then
      begin
        Result := Copy(PadRight(Mensagem[2], 40, ' '), 1, 40);
      end;

      if Mensagem.Count >= 4 then
      begin
        Result := Result +
                  Copy(PadRight(Mensagem[3], 40, ' '), 1, 40)
      end;

      if Mensagem.Count >= 5 then
      begin
        Result := Result +
                  Copy(PadRight(Mensagem[4], 40, ' '), 1, 40)
      end;

      if Mensagem.Count >= 6 then
      begin
        Result := Result +
                  Copy(PadRight(Mensagem[5], 40, ' '), 1, 40)
      end;

      if Mensagem.Count >= 7 then
      begin
        Result := Result +
                  Copy(PadRight(Mensagem[6], 40, ' '), 1, 40)
      end;

      // Acertar a quantidade de caracteres
      Result := PadRight(Result, 200);
    end;
  end;
begin

  segmentoP := '';
  segmentoQ := '';
  segmentoR := '';

  with ACBrTitulo do
  begin
    case OcorrenciaOriginal.Tipo of
       toRemessaBaixar                        : sCodMovimento := '02'; {Pedido de Baixa}
       toRemessaConcederAbatimento            : sCodMovimento := '04'; {Concess�o de Abatimento}
       toRemessaCancelarAbatimento            : sCodMovimento := '05'; {Cancelamento de Abatimento concedido}
       toRemessaAlterarVencimento             : sCodMovimento := '06'; {Altera��o de vencimento}
       toRemessaAlterarControleParticipante   : sCodMovimento := '07'; {Altera��o N�mero Controle Cedente}
       toRemessaAlterarNumeroControle         : sCodMovimento := '08'; {Altera��o de seu n�mero}
       toRemessaProtestar                     : sCodMovimento := '09'; {Pedido de protesto}
       toRemessaCancelarInstrucaoProtesto     : sCodMovimento := '18'; {Sustar protesto e manter na carteira}
       toRemessaConcederDesconto              : sCodMovimento := '10'; {Concess�o de Desconto}
       toRemessaCancelarDesconto              : sCodMovimento := '11'; {Cancelamento de Desconto}
       toRemessaAlterarOutrosDados            : sCodMovimento := '31'; {Altera��o de outros dados}
       toRemessaNaoProtestar                  : sCodMovimento := '98'; {N�o Protestar (Antes de iniciar o ciclo de protesto )}
    else
       sCodMovimento := '01';                                          {Remessa}
    end;

    case Sacado.Pessoa of
       pFisica  : sTipoInscricao := '1';
       pJuridica: sTipoInscricao := '2';
       pOutras  : sTipoInscricao := '9';
    end;

    if Sacado.SacadoAvalista.CNPJCPF <> '' then
     begin
      case Sacado.SacadoAvalista.Pessoa of
        pFisica  : aTipoInscricao := '1';
        pJuridica: aTipoInscricao := '2';
        pOutras  : aTipoInscricao := '9';
      end;
     end
    else
      aTipoInscricao:= '0';

    sEndereco := PadRight(Sacado.Logradouro + ' ' +
                      Sacado.Numero + ' ' +
                      Sacado.Complemento , 40, ' ');

    if Trim(EspecieDoc) = 'DM' then      {DM - DUPLICATA MERCANTIL}
      sEspecie := '02'
    else if Trim(EspecieDoc) = 'DS' then {DS - DUPLICATA DE SERVICO}
      sEspecie := '04'
    else if Trim(EspecieDoc) = 'NP' then {NP - NOTA PROMISSORIA}
      sEspecie := '12'
    else if Trim(EspecieDoc) = 'NR' then {NR - NOTA PROMISSORIA RURAL}
      sEspecie := '13'
    else if Trim(EspecieDoc) = 'RC' then {RC - RECIBO}
      sEspecie := '17'
    else if Trim(EspecieDoc) = 'AP' then {AP � APOLICE DE SEGURO}
      sEspecie := '20'
    else if Trim(EspecieDoc) = 'CH' then {CH - CHEQUE}
      sEspecie := '97'
    else if Trim(EspecieDoc) = 'ND' then {ND - NOTA PROMISSORIA DIRETA}
      sEspecie := '98'
    else
    begin
      if not MatchText(EspecieDoc, ['02', '04', '12', '13', '17', '20', '97', '98']) then
        raise Exception.Create('Esp�cie de documento informada incorretamente!');

      sEspecie := EspecieDoc;
    end;

    case ACBrBoleto.Cedente.CaracTitulo of
      tcSimples     :
      begin
        sTipoCobranca  := '1'; {Cobran�a Simples (Sem Registro e Eletr�nica com Registro)}
        Inc(FQuantidadeCobrancaSimples);
        FValorCobrancaSimples := FValorCobrancaSimples + ValorDocumento;
      end;
      tcCaucionada  :
      begin
        sTipoCobranca  := '3'; {Cobran�a Caucionada (Eletr�nica com Registro e Convencional com Registro)}
        Inc(FQuantidadeCobrancaCaucionada);
        FValorCobrancaCaucionada := FValorCobrancaCaucionada + ValorDocumento;
      end;
      tcDescontada  :
      begin
        sTipoCobranca  := '4'; {Cobran�a Descontada (Eletr�nica com Registro)}
        Inc(FQuantidadeCobrancaDescontada);
        FValorCobrancaDescontada := FValorCobrancaDescontada + ValorDocumento;
      end;
      tcVinculada   :
      begin
        sTipoCobranca  := '5'; {Cobran�a Simples (R�pida com Registro)}
        Inc(FQuantidadeCobrancaVinculada);
        FValorCobrancaVinculada := FValorCobrancaVinculada + ValorDocumento;
      end;
      { TODO :
          6 = Cobran�a Caucionada (R�pida com Registro)
          8 = Cobranca Cessao (Eletronica com Registro)
      }
    end;

    case ACBrBoleto.Cedente.TipoCarteira of
      tctSimples: sTipoCarteira := '2';
      tctRegistrada: sTipoCarteira := '1';
      else
       sTipoCarteira := '2';
    end;

    case ACBrBoleto.Cedente.TipoDocumento of
      Tradicional: sTipoDocto := '1';
      Escritural: sTipoDocto := '2';
    end;

    if sTipoDocto = '' then
      sTipoDocto := '1'; // Tradicional

    if (ValorMoraJuros > 0) then
    begin
      STipoJuros := IfThen( (CodigoMora <> ''), CodigoMora, '1');    //1- Valor por dia  2- Taxa Mensal
      if DataMoraJuros <> 0 then
        sDataMoraJuros := FormatDateTime('ddmmyyyy', DataMoraJuros)
      else
        sDataMoraJuros := PadLeft('', 8, '0');
    end
    else
    begin
      sDataMoraJuros := PadLeft('', 8, '0');
      STipoJuros := '3'; // Isento
    end;

    // 0 = ISENTO
    // 1 = Valor fixo ate a data informada � Informar o valor no campo �valor de desconto a ser concedido.
    // 2 = Percentual ate a data informada � Informar o percentual no campo �percentual de desconto a ser concedido
    // 3 = Valor por antecipa��o por dia corrido - Informar o valor no campo �valor de desconto a ser concedido
    // 4 = Valor por antecipa��o dia �til - Informar o valor no campo �valor de desconto a ser concedido
    case ACBrTitulo.TipoDesconto of
         tdNaoConcederDesconto: sTipoDesconto := '0';
         tdValorFixoAteDataInformada: sTipoDesconto := '1';
         tdPercentualAteDataInformada: sTipoDesconto := '2';
    end;

    if ValorDesconto > 0 then
    begin
      if DataDesconto <> 0 then
        sDataDesconto := FormatDateTime('ddmmyyyy', DataDesconto)
      else
        sDataDesconto := PadLeft('', 8, '0');
    end
    else
       sDataDesconto := PadLeft('', 8, '0');

    {C�digo para Protesto}
    case TipoDiasProtesto of
       diCorridos       : ACodProtesto := '1';
       diUteis          : ACodProtesto := '2';
    else
       ACodProtesto := '0';
    end;

    if ((DataProtesto <> 0) and (DiasDeProtesto > 0)) then
    begin
      if not MatchText(Instrucao1, ['1', '2', '4', '5', '8', '9']) then
        Instrucao1 := ACodProtesto;
      // Dias para protesto
      sDiasProtesto := PadLeft(IntToStr(DiasDeProtesto), 2, '0');
    end
    else
    begin
      Instrucao1 := '3';  // N�o protestar Regra C026
      SDiasProtesto := '00';
    end;

    sDiasBaixaDevol := ifthen(DataBaixa > 0,
                             IntToStrZero(DaysBetween(Vencimento,DataBaixa),3),
                             '000');
  end;

  with ACBrBanco.ACBrBoleto.Cedente do
  begin

    Inc(FSequencia);
    segmentoP := IntToStrZero(ACBrBanco.Numero, 3)                                     + // 001-003 / C�digo do Banco na Compensa��o
                 '0001'                                                                + // 004-007 / Lote de Servi�o
                 '3'                                                                   + // 008-008 / Tipo de Registro
                 IntToStrZero(FSequencia, 5)                                           + // 009-013 / N� Sequencial do Registro de Lote
                 'P'                                                                   + // 014-014 / C�d. Segmento do Regsitro Detalhe
                 ' '                                                                   + // 015-015 / Campo sem Preenchimento
                 sCodMovimento                                                         + // 016-017 / C�digo de Movimento remessa
                 PadRight(Agencia, 5, '0')                                             + // 018-022 / Ag�ncia Mantenedora da Conta
                 PadLeft(AgenciaDigito, 1)                                             + // 023-023 / D�gito Verificador da Ag�ncia
                 PadLeft(Conta, 12, '0')                                               + // 024-035 / N�mero da Conta Corrente
                 PadLeft(ContaDigito, 1)                                               + // 036-036 / D�gito Verificador da Conta
                 ' '                                                                   + // 037-037 / D�gito Verificador da Ag�ncia/Conta
                 PadRight(ACBrTitulo.NossoNumero, 20)                                  + // 038-057 / Identifica��o do T�tulo no Banco NN com DV
                 PadLeft(ACBrTitulo.Carteira, 1)                                       + // 058-058 / C�digo da Carteira
                 sTipoCarteira                                                         + // 059-059 / Forma de Cadastro do t�tulo no banco
                 sTipoDocto                                                            + // 060-060 / Tipo de Documento
                 sTipoCobranca                                                         + // 061-061 / Identifica��o da Emiss�o do Bloqueto
                 '2'                                                                   + // 062-062 / Identifica��o da Distribui��o
                 ifThen(NaoEstaVazio(ACBrTitulo.NumeroDocumento),
                        PadRight(ACBrTitulo.NumeroDocumento, 15),
                        PadRight(ACBrTitulo.NossoNumero, 15))                          + // 063-077 / N�mero do Documento de Cobran�a
                 FormatDateTime('ddmmyyyy', ACBrTitulo.Vencimento)                     + // 078-085 / Data de Vencimento do T�tulo
                 IntToStrZero(round(ACBrTitulo.ValorDocumento * 100), 15)              + // 086-100 / Valor Nominal do T�tulo
                 PadRight(Agencia, 5, '0')                                             + // 101-105 / Ag�ncia Encarregada da Cobran�a
                 ' '                                                                   + // 106-106 / D�gito Verificador da Ag�ncia
                 sEspecie                                                              + // 107-108 / Esp�cie do T�tulo
                 IfThen(ACBrTitulo.Aceite = atSim, 'A', 'N')                           + // 109-109 / Identifica��o de T�tulo Aceito / N�o Aceito
                 FormatDateTime('ddmmyyyy', ACBrTitulo.DataDocumento)                  + // 110-117 / Data de Emiss�o do T�tulo
                 STipoJuros                                                            + // 118-118 / C�digo do Juros de Mora
                 sDataMoraJuros                                                        + // 119-126 / Data do Juros de Mora
                 ifthen((STipoJuros = '2'), FormatarMoraJurosRemessa(15, ACBrTitulo),
                        IntToStrZero(round(ACBrTitulo.ValorMoraJuros * 100), 15))      + // 127-141 / Valor da mora/dia ou Taxa mensal
                 sTipoDesconto                                                         + // 142-142 / C�digo do Desconto 1
                 sDataDesconto                                                         + // 143-150 / Data do Desconto 1
                 IntToStrZero(round(ACBrTitulo.ValorDesconto * 100), 15)               + // 151-165 / Valor ou Percentual do desconto concedido
                 IntToStrZero(round(ACBrTitulo.ValorIOF * 100), 15)                    + // 166-180 / Valor do IOF a ser recolhido
                 IntToStrZero(round(ACBrTitulo.ValorAbatimento * 100), 15)             + // 181-195 / Valor do abatimento
                 PadRight(ACBrTitulo.SeuNumero, 25)                                    + // 196-220 / Identifica��o do t�tulo na empresa
                 PadLeft(ACBrTitulo.Instrucao1, 1)                                     + // 221-221 / C�digo para protesto
                 sDiasProtesto                                                         + // 222-223 / N�mero de dias para protesto
                 PadLeft(Trim(ACBrTitulo.Instrucao2), 1)                               + // 224-224 / C�digo para Baixa/Devolu��o
                 sDiasBaixaDevol                                                       + // 225-227 / N�mero de Dias para Baixa/Devolu��o
                 '09'                                                                  + // 228-229 / C�digo da moeda
                 PadLeft('0', 10, '0')                                                 + // 230-239 / N� do Contrato da Opera��o de Cr�d.
                 ' '                                                                   ; // 240�240 / Uso livre banco/empresa

    if sCodMovimento = '01' then
    begin
      Inc(FSequencia);
      segmentoQ := IntToStrZero(ACBrBanco.Numero, 3)                              + // 001-003 / C�digo do Banco na compensa��o
                   '0001'                                                         + // 004-007 / Numero do lote remessa
                   '3'                                                            + // 008-008 / Tipo de registro
                   IntToStrZero(FSequencia ,5)                                    + // 009-013 / N�mero seq�encial do registro no lote
                   'Q'                                                            + // 014-014 / C�d. Segmento do registro detalhe
                   ' '                                                            + // 015-015 / Reservado (uso Banco)
                   sCodMovimento                                                  + // 016-017 / C�digo de movimento remessa
                   sTipoInscricao                                                 + // 018-018 / Tipo de inscri��o do sacado
                   PadLeft(trim(OnlyNumber(ACBrTitulo.Sacado.CNPJCPF)),15,'0')    + // 019-033 / N�mero de inscri��o do sacado
                   PadRight(Trim(ACBrTitulo.Sacado.NomeSacado), 40)               + // 034-073 / Nome sacado
                   sEndereco                                                      + // 074-113 / Endere�o sacado
                   PadRight(Trim(ACBrTitulo.Sacado.Bairro), 15)                   + // 114-128 / Bairro sacado
                   PadLeft(Copy(OnlyNumber(ACBrTitulo.Sacado.CEP), 1, 5), 5, '0') + // 129-133 / Cep sacado
                   PadLeft(Copy(OnlyNumber(ACBrTitulo.Sacado.CEP), 6, 3), 3, '0') + // 134-136 / Sufixo do Cep do sacado
                   PadRight(Trim(ACBrTitulo.Sacado.Cidade), 15)                   + // 137-151 / Cidade do sacado
                   PadRight(ACBrTitulo.Sacado.UF, 2)                              + // 152-153 / Unidade da federa��o do sacado
                   aTipoInscricao                                                 + // 154-154 / Tipo de inscri��o sacador/avalista
                   PadLeft(ACBrTitulo.Sacado.SacadoAvalista.CNPJCPF, 15,'0')      + // 155-169 / N� de inscri��o sacador/avalista
                   PadRight(ACBrTitulo.Sacado.SacadoAvalista.NomeAvalista,40,' ') + // 170-209 / Nome do sacador/avalista
                   IntToStrZero(ACBrBanco.Numero, 3)                              + // 210�212 / C�d Bco.Corresp. Na Compensa��o
                   PadRight(ACBrTitulo.NossoNumero, 20)                           + // 213�232 / Nosso N� no Banco Correspondente
                   Space(8)                                                       ; // 233�240 / Reservado (uso Banco)

      Inc(FSequencia);
      {SEGMENTO R}
      segmentoR := IntToStrZero(ACBrBanco.Numero, 3)                                                    + // 001 - 003 / C�digo do Banco na compensa��o
                  '0001'                                                                                + // 004 - 007 / Numero do lote remessa
                  '3'                                                                                   + // 008 - 008 / Tipo de registro
                  IntToStrZero(FSequencia ,5)                                                           + // 009 - 013 / N�mero seq�encial do registro no lote
                  'R'                                                                                   + // 014 - 014 / C�d. Segmento do registro detalhe
                  Space(1)                                                                              + // 015 - 015 / Reservado (uso Banco)
                  sCodMovimento                                                                         + // 016 - 017 / C�digo de movimento remessa
                  '0'                                                                                   + // 018 - 018 / C�digo do desconto 2
                  PadLeft('', 8, '0')                                                                   + // 019 - 026 / Data do desconto 2
                  IntToStrZero(0, 15)                                                                   + // 027 - 041 / Valor/Percentual a ser concedido
                  '0'                                                                                   + // 042 - 042 / C�digo do desconto 3
                  PadLeft('', 8, '0')                                                                   + // 043 - 050 / Data do desconto 3
                  IntToStrZero(0, 15)                                                                   + // 051 - 065 / Valor/Percentual a ser concedido
                  {sTipoDesconto                                                                        + // 042 - 042 1 = Valor Fixo ate a Data Informada / 2 = Percentual ate a Data Informada / 3 = Valor por Antecipa��o dia Corrido
                                                                                                          //           5 = Percentual por Antecipa��o dia corrido
                  IfThen((ACBrTitulo.ValorDesconto > 0),
                          FormatDateTime('ddmmyyyy', ACBrTitulo.DataDesconto), '00000000')              + // 043 - 050 Campo numerico e deve ser preenchido, caso n�o tenha desconto manter o campo zerado. DDMMAAAA
                  IntToStrZero(round(ACBrTitulo.ValorDesconto), 15)                                     + // 051 - 065 / Valor/Percentual a ser aplicado}
                  IfThen((ACBrTitulo.PercentualMulta > 0),
                         IfThen(ACBrTitulo.MultaValorFixo,'1','2'), '0')                + // 66 - 66 1-Cobrar Multa Valor Fixo / 2-Percentual / 0-N�o cobrar multa
                  IfThen((ACBrTitulo.PercentualMulta > 0),
                          FormatDateTime('ddmmyyyy', ACBrTitulo.DataMulta), '00000000') + // 67 - 74 Se cobrar informe a data para iniciar a cobran�a ou informe zeros se n�o cobrar
                  IfThen((ACBrTitulo.PercentualMulta > 0), IntToStrZero(round(ACBrTitulo.PercentualMulta * 100), 15),
                         PadRight('', 15, '0'))                                         + // 075 - 089 / Valor/Percentual a ser aplicado
                  Space(10)                                                             + // 090 - 099 / Reservado (uso Banco)
                  MontarInstrucoes1                                                     + // 100 - 139 / Mensagem 3
                                                                                          // 140 - 179 / Mensagem 4
                  Space(61)                                                             ; // 180 - 240 / Reservado (uso Banco)
    end;
  end;

  Result := segmentoP;

  if segmentoQ <> '' then
    Result := Result + #13#10 + segmentoQ;

  if segmentoR <> '' then
    Result := Result + #13#10 + segmentoR;
end;

procedure TACBrBancoSafra.GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo;
  aRemessa: TStringList);
var
  wLinha, tipoInscricao, aAgencia, aConta: String;
  Ocorrencia, aEspecie, aAceite, aInstrucao2: String;
  aTipoSacado, sDataDesconto:String;
begin
  with ACBrTitulo do
  begin
    if ACBrBoleto.Cedente.TipoInscricao = pFisica then
      tipoInscricao := '01'
    else
      tipoInscricao := '02';

    aAgencia := PadLeft(RightStr( ACBrBoleto.Cedente.Agencia, 5), 5, '0');

    aConta := PadLeft(ACBrBoleto.Cedente.Conta, 8, '0') +
              PadLeft(ACBrBoleto.Cedente.ContaDigito, 1, '0');

    {Pegando C�digo da Ocorrencia}
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar                 : Ocorrencia := '02'; {Pedido de Baixa}
      toRemessaConcederAbatimento     : Ocorrencia := '04'; {Concess�o de Abatimento}
      toRemessaCancelarAbatimento     : Ocorrencia := '05'; {Cancelamento de Abatimento concedido}
      toRemessaAlterarVencimento      : Ocorrencia := '06'; {Altera��o de vencimento}
      toRemessaAlterarExclusivoCliente: Ocorrencia := '07'; {Altera��o "Uso Exclusivo do Cliente"}
      toRemessaAlterarNumeroControle  : Ocorrencia := '08'; {Altera��o de seu n�mero}
      toRemessaProtestar              : Ocorrencia := '09'; {Pedido de protesto}
      toRemessaNaoProtestar           : Ocorrencia := '10'; {N�o Protestar}
      toRemessaNaoCobrarJurosMora     : Ocorrencia := '11'; {N�o Cobrar Juros de Mora}
      toRemessaCobrarJurosMora        : Ocorrencia := '16'; {Cobrar Juros de Mora}
      toRemessaAlterarValorTitulo     : Ocorrencia := '31'; {Altera��o do Valor do T�tulo}
      else
        Ocorrencia := '01'; {Remessa}
    end;

    {Pegando Especie}
    if trim(EspecieDoc) = 'DM' then
      aEspecie := '01'
    else if trim(EspecieDoc) = 'NP' then
      aEspecie := '02'
    else if trim(EspecieDoc) = 'NS' then
      aEspecie := '03'
    else if trim(EspecieDoc) = 'RC' then
      aEspecie := '05'
    else if Trim(EspecieDoc) = 'DS' then
      aEspecie := '09'
    else
      aEspecie := PadLeft(EspecieDoc, 2, ' ') ;

    if Aceite = atSim then
      aAceite := 'A'
    else
      aAceite := 'N';

    if StrToIntDef(Instrucao3,0) > 0 then
      aInstrucao2 := '10'
    else
      aInstrucao2 := PadLeft(trim(Instrucao2), 2, '0');

    if Sacado.Pessoa = pFisica then
      aTipoSacado := '01'
    else if Sacado.Pessoa = pJuridica then
      aTipoSacado := '02'
    else
      aTipoSacado := '03';

    if DataDesconto = 0 then
      sDataDesconto := '000000'
    else
      sDataDesconto := FormatDateTime('ddmmyy', DataDesconto);

    wLinha := '1'                                                                            + //   1 a   1 - Identifica��o do Registro de Transa��o
              tipoInscricao                                                                  + //   2 a   3 - Tipo de Inscri��o da Empresa
              PadLeft(OnlyNumber(ACBrBoleto.Cedente.CNPJCPF), 14, '0')                       + //   4 a  17 - N�mero da Inscri��o da Empresa
              aAgencia + aConta                                                              + //  18 a  31 - Identifica��o da Empresa no Banco
              Space(6)                                                                       + //  32 a  37 - "Brancos"
              PadRight(SeuNumero,25)                                                         + //  38 a  62 - Uso exclusivo da Empresa
              IfThen(NossoNumero = '000000000', '000000000',
                                 PadLeft(RightStr(NossoNumero,9),9,'0'))                     + //  63 a  71 - N�mero do t�tulo no banco
              Space(14)                                                                      + //  72 a  85 - "Brancos"
              IfThen(DataMoraJuros > 0,
                FormatDateTime('ddmmyy', DataMoraJuros),
                Space(6))                                                                    + //  86 a  91 -  Data in�cio de cobran�a de Juros de Mora
              Space(10)                                                                      + //  92 a 101 - "Brancos"
              '0'                                                                            + // 102 a 102 - C�digo de IOF sobre Opera��es de Seguro
              '00'                                                                           + // 103 a 104 - Identifica��o do Tipo de Moeda, 00=Real
              Space(1)                                                                       + // 105 a 105 - "Branco"
              IntToStrZero(StrToIntDef(Instrucao3,0), 2)                                     + // 106 a 107 - Terceira Instru��o de Cobran�a. Utilizar somente quando Instru��o2 � igual a 10
              Carteira                                                                       + // 108 a 108 - Identifica��o do Tipo de Carteira
              Ocorrencia                                                                     + // 109 a 110 - Identifica��o do Tipo de Ocorr�ncia
              PadRight(NumeroDocumento, 10)                                                        + // 111 a 120 - Identifica��o do T�tulo da Empresa
              FormatDateTime('ddmmyy', Vencimento)                                           + // 121 a 126 - Data de Vencimento do T�tulo
              IntToStrZero(Round(ValorDocumento * 100), 13)                                  + // 127 a 139 - Valor Nominal do T�tulo
              IntToStr(ACBrBoleto.Banco.Numero)                                              + // 140 a 142 - C�digo do Banco encarregado da cobra�a
              '00000'                                                                        + // 143 a 147 - Ag�ncia Encarregada da Cobran�a
              aEspecie                                                                       + // 148 a 149 - Esp�cie do T�tulo
              aAceite                                                                        + // 150 a 150 - Identifica��o do Aceite do T�tulo
              FormatDateTime('ddmmyy', DataDocumento)                                        + // 151 a 156 - Data de Emiss�o do T�tulo
              PadLeft(trim(Instrucao1), 2, '0')                                              + // 157 a 158 - Primeira Instru��o de Cobran�a
              aInstrucao2                                                                    + // 159 a 160 - Segunda Instru��o de Cobran�a
              IntToStrZero(round(ValorMoraJuros * 100), 13)                                  + // 161 a 173 - Juros de Mora Por Dia de Atraso
              sDataDesconto                                                                  + // 174 a 179 - Data Limite para Desconto
              IntToStrZero(round(ValorDesconto * 100), 13)                                   + // 180 a 192 - Valor Do Desconto Concedido
              IntToStrZero(round(ValorIOF * 100), 13)                                        + // 193 a 205 - Valor De Iof Opera��es Deseguro

              IfThen( ((Ocorrencia = '01') and
                      (PercentualMulta > 0) and
                      ((Copy(Instrucao1, 1, 2) = '16') or (Copy(Instrucao2, 1, 2) = '16'))  ),
                (FormatDateTime('ddmmyy', DataMulta) +                                         // 206 a 211 a data a partir da qual a multa deve ser cobrada
                IntToStrZero(round(PercentualMulta * 100), 4) +                                // 212 a 215 o percentual referente � multa no formato 99v99
                '000'),                                                                        // 216 a 218 zeros
                IntToStrZero(round(ValorAbatimento * 100), 13)  )                            + // Valor Do Abatimento Concedido Ou Cancelado / Multa
              aTipoSacado                                                                    + // 219 a 220 - C�digo De Inscri��o Do Sacado
              PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0')                                   + // 221 a 234 - N�mero de Inscri��o do Sacado
              PadRight(Sacado.NomeSacado, 40, ' ')                                           + // 235 a 274 - Nome Do Sacado
              PadRight(Sacado.Logradouro + ' ' + Sacado.Numero, 40, ' ')                     + // 275 a 314 - Endere�o Do Sacado
              PadRight(Sacado.Bairro, 10, ' ')                                               + // 315 a 324 - Bairro Do Sacado
              Space(2)                                                                       + // 325 a 326 - Brancos
              PadRight(Sacado.CEP, 8)                                                        + // 327 a 334 - CEP do Sacado
              PadRight(Sacado.Cidade, 15)                                                    + // 335 a 349 - Cidade do Sacado
              PadRight(Sacado.UF, 2)                                                         + // 350 a 351 - UF do Sacado
              PadRight(Sacado.SacadoAvalista.NomeAvalista, 30)                               + // 352 a 381 - Nome do Sacador Avalista / Mensagem espec�fica vide nota 6.1.9 conforme manual do banco
              Space(7)                                                                       + // 382 a 388 - "Brancos"
              '422'                                                                          + // 389 a 391 - Banco Emitente do Boleto
              IntToStrZero(FNumeroRemessa, 3)                                                + // 392 a 394 - Numero Seq�encial Gera��o Arquivo Remessa
              IntToStrZero(ARemessa.Count + 1, 6);                                             // 395 a 400 - N�mero Sequencial De Registro De Arquivo

    aTotal := aTotal + ValorDocumento;
    Inc(aCount);
    aRemessa.Text := aRemessa.Text + wLinha;
  end;
end;

procedure TACBrBancoSafra.LerRetorno240(ARetorno: TStringList);
var
  Titulo: TACBrTitulo;
  TempData, Linha, rCedente, rCNPJCPF: String;
  ContLinha : Integer;
  idxMotivo: Integer;
  rConvenioCedente: String;
begin
   // informa��o do Header
   // Verifica se o arquivo pertence ao banco
   if StrToIntDef(copy(ARetorno.Strings[0], 1, 3),-1) <> Numero then
      raise Exception.create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                             'n�o' + '� um arquivo de retorno do ' + Nome));

   ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0],144,2)+'/'+
                                                           Copy(ARetorno[0],146,2)+'/'+
                                                           Copy(ARetorno[0],148,4),0, 'DD/MM/YYYY' );

   ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0],158,6),0);

   rCedente        := trim(copy(ARetorno[0], 73, 30));
   rCNPJCPF        := OnlyNumber( copy(ARetorno[0], 19, 14) );
   rConvenioCedente:= Trim(RemoveZerosEsquerda(Copy(ARetorno[0], 33, 9)));

   ValidarDadosRetorno('', '', rCNPJCPF);
   with ACBrBanco.ACBrBoleto do
   begin
     if LeCedenteRetorno then
     begin
       case StrToIntDef(copy(ARetorno[0], 18, 1), 0) of
         01:
           Cedente.TipoInscricao := pFisica;
         else
           Cedente.TipoInscricao := pJuridica;
       end;

       Cedente.Nome          := rCedente;
       Cedente.CNPJCPF       := rCNPJCPF;
       Cedente.Convenio      := rConvenioCedente;
       Cedente.Agencia       := trim(copy(ARetorno[0], 53, 5));
       Cedente.AgenciaDigito := trim(copy(ARetorno[0], 58, 1));
       Cedente.Conta         := trim(copy(ARetorno[0], 59, 12));
       Cedente.ContaDigito   := trim(copy(ARetorno[0], 71, 1));
     end;

     ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
   end;

   Linha := '';
   Titulo := nil;

   for ContLinha := 1 to ARetorno.Count - 2 do
   begin
      Linha := ARetorno[ContLinha];

      if copy(Linha, 8, 1) <> '3' then // verifica se o registro (linha) � um registro detalhe (segmento J)
         Continue;

      if copy(Linha, 14, 1) = 'T' then // se for segmento T cria um novo titulo
         Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

      if Assigned(Titulo) then
      with Titulo do
      begin
         if copy(Linha, 14, 1) = 'T' then
          begin
            SeuNumero := copy(Linha, 106, 25);
            NumeroDocumento := copy(Linha, 59, 15);
            Carteira := copy(Linha, 58, 1);

            TempData := copy(Linha, 74, 2) + '/'+copy(Linha, 76, 2)+'/'+copy(Linha, 78, 4);
            if TempData<>'00/00/0000' then
              Vencimento := StringToDateTimeDef(TempData, 0, 'DD/MM/YYYY');

            ValorDocumento := StrToFloatDef(copy(Linha, 82, 15), 0) / 100;

            NossoNumero := Copy(Linha, 38, TamanhoMaximoNossoNum);

            ValorDespesaCobranca := StrToFloatDef(copy(Linha, 199, 15), 0) / 100;

            OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(copy(Linha, 16, 2), 0));

            IdxMotivo := 214;

            while (IdxMotivo < 223) do
            begin
               if (trim(Copy(Linha, IdxMotivo, 2)) <> '') then
               begin
                  MotivoRejeicaoComando.Add(Copy(Linha, IdxMotivo, 2));
                  DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, StrToIntDef(Copy(Linha, IdxMotivo, 2), 0)));
               end;
               Inc(IdxMotivo, 2);
            end;

          end
         else if copy(Linha, 14, 1) = 'U' then // segmento U
          begin
            ValorIOF            := StrToFloatDef(copy(Linha, 63, 15), 0) / 100;
            ValorAbatimento     := StrToFloatDef(copy(Linha, 48, 15), 0) / 100;
            ValorDesconto       := StrToFloatDef(copy(Linha, 33, 15), 0) / 100;
            ValorMoraJuros      := StrToFloatDef(copy(Linha, 18, 15), 0) / 100;
            ValorOutrosCreditos := StrToFloatDef(copy(Linha, 123, 15), 0) / 100;
            ValorOutrasDespesas := StrToFloatDef(copy(Linha, 108, 15), 0) / 100;
            ValorPago           := StrToFloatDef(copy(Linha, 78, 15), 0) / 100;
            ValorRecebido       := StrToFloatDef(copy(Linha, 93, 15), 0) / 100;
            TempData := copy(Linha, 138, 2)+'/'+copy(Linha, 140, 2)+'/'+copy(Linha, 142, 4);
            if TempData<>'00/00/0000' then
              DataOcorrencia := StringToDateTimeDef(TempData, 0, 'DD/MM/YYYY');
            TempData := copy(Linha, 146, 2)+'/'+copy(Linha, 148, 2)+'/'+copy(Linha, 150, 4);
            if TempData<>'00/00/0000' then
              DataCredito := StringToDateTimeDef(TempData, 0, 'DD/MM/YYYY');
          end;
      end;
   end;

end;


procedure TACBrBancoSafra.LerRetorno400(ARetorno: TStringList);
var
  rCodEmpresa, rCedente, rAgencia, rDigitoAgencia: String;
  rConta, rDigitoConta, rCNPJCPF, Linha: String;
  ContLinha, CodOcorrencia: Integer;
  Titulo: TACBrTitulo;
begin
  if StrToIntDef(copy(ARetorno.Strings[0], 77, 3), -1) <> Numero then
    raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                           'n�o � um arquivo de retorno do ' + Nome));

  rCodEmpresa    := trim(Copy(ARetorno[0], 27, 14));
  rCedente       := trim(Copy(ARetorno[0], 47, 30));
  rAgencia       := trim(Copy(ARetorno[1], 18, 5));
  rDigitoAgencia := trim(Copy(ARetorno[1], 22, 1));
  rConta         := trim(Copy(ARetorno[1], 23, ACBrBanco.TamanhoConta));
  rDigitoConta   := Copy(ARetorno[1], 31, 1);

  ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0], 95, 2) + '/' +
                                                          Copy(ARetorno[0], 97, 2) + '/' +
                                                          Copy(ARetorno[0], 99, 2), 0,
                                                          'DD/MM/YY');

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0], 392, 3), 0);

  ValidarDadosRetorno(rAgencia, rConta);
  with ACBrBanco.ACBrBoleto do
  begin
    if (not LeCedenteRetorno) and (rCodEmpresa <>
        PadLeft(Cedente.CodigoCedente, 14, '0')) then
      raise Exception.Create(ACBrStr('C�digo da Empresa do arquivo inv�lido'));

    case StrToIntDef(Copy(ARetorno[1], 2, 2), 0) of
      01: Cedente.TipoInscricao := pFisica;
      02: Cedente.TipoInscricao := pJuridica;
      else
        Cedente.TipoInscricao := pJuridica;
    end;

    rCNPJCPF := Copy(ARetorno[1], 4, 14);

    if LeCedenteRetorno then
    begin
      try
        Cedente.CNPJCPF := rCNPJCPF;
      except
      end;

      Cedente.CodigoCedente := rCodEmpresa;
      Cedente.Nome          := rCedente;
      Cedente.Agencia       := rAgencia;
      Cedente.AgenciaDigito := rDigitoAgencia;
      Cedente.Conta         := rConta;
      Cedente.ContaDigito   := rDigitoConta;
    end;

    ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
  end;

  for ContLinha := 1 to ARetorno.Count - 2 do
  begin
    Linha := ARetorno[ContLinha];

    if Copy(Linha, 1, 1) <> '1' then
      Continue;

    Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

    with Titulo do
    begin
      SeuNumero      := Copy(Linha,38,25); 
      NossoNumero    := Copy(Linha, 63, 9);
      CodOcorrencia  := StrToIntDef(copy(Linha, 109, 2),0);
      OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(CodOcorrencia);

      Carteira := copy(Linha, 108, 1);

      DataOcorrencia := StringToDateTimeDef(copy(Linha, 111, 2) + '/' +
                                            copy(Linha, 113, 2) + '/' +
                                            copy(Linha, 115, 2), 0, 'DD/MM/YY');

      if CodOcorrencia = 03 then // entrada rejeitada
      begin
        MotivoRejeicaoComando.Add(copy(Linha, 105, 3));
        DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(
          toRetornoRegistroRecusado, StrToIntDef(copy(Linha, 105, 3),0)));
      end;
      NumeroDocumento := copy(Linha, 117, 10);

      if Copy(Linha, 147, 2) <> '00' then
        Vencimento := StringToDateTimeDef(copy(Linha, 147, 2) + '/' +
                                          copy(Linha, 149, 2) + '/' +
                                          copy(Linha, 151, 2), 0, 'DD/MM/YY');

      ValorDocumento       := StrToFloatDef(copy(Linha, 153, 13), 0) / 100;
      EspecieDoc           := copy(Linha, 174, 2);
      ValorDespesaCobranca := StrToFloatDef(Copy(Linha, 176, 13), 0) / 100;
      ValorOutrasDespesas  := StrToFloatDef(Copy(Linha, 189, 13), 0) / 100;
      ValorIOF             := StrToFloatDef(Copy(Linha, 215, 13), 0) / 100;
      ValorAbatimento      := StrToFloatDef(Copy(Linha, 228, 13), 0) / 100;
      ValorDesconto        := StrToFloatDef(Copy(Linha, 241, 13), 0) / 100;
      ValorRecebido        := StrToFloatDef(Copy(Linha, 254, 13), 0) / 100;
      ValorMoraJuros       := StrToFloatDef(Copy(Linha, 267, 13), 0) / 100;
      ValorOutrosCreditos  := StrToFloatDef(Copy(Linha, 280, 13), 0) / 100;

      if Copy(Linha, 296, 2) <> '00' then
        DataCredito := StringToDateTimeDef(copy(Linha, 296, 2) + '/' +
                                           copy(Linha, 298, 2) + '/' +
                                           copy(Linha, 300, 2), 0, 'DD/MM/YY');
    end;
  end;
end;

function TACBrBancoSafra.MontarCampoCodigoCedente(
  const ACBrTitulo: TACBrTitulo): string;
begin
  with ACBrTitulo.ACBrBoleto.Cedente do
  begin
    Result := PadLeft(RightStr(Agencia,5), 5, '0') + ' / ' + PadLeft(ACBrBoleto.Cedente.Conta, 8, '0') + PadLeft(ACBrBoleto.Cedente.ContaDigito, 1, '0');
  end;
end;

function TACBrBancoSafra.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string;
begin
  with ACBrTitulo do
  begin
    Result := PadLeft(RightStr(NossoNumero,9),9,'0');
  end;
end;

function TACBrBancoSafra.MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): string;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras ,
  valorDocumento, agencia, conta,
  ContaDigito, NossoNumero: string;
begin
  with ACBrTitulo.ACBrBoleto do
  begin
    FatorVencimento  := CalcularFatorVencimento(ACBrTitulo.Vencimento);
    valorDocumento   := IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10);
    agencia          := PadLeft(RightStr(Cedente.Agencia,5), 5, '0');
    conta            := PadLeft(Cedente.Conta, 8, '0');
    ContaDigito      := PadLeft(Cedente.ContaDigito, 1, '0');
    NossoNumero      := PadLeft(RightStr(ACBrTitulo.NossoNumero,9),9,'0');

    CodigoBarras := IntToStr(Banco.Numero) + '9' + FatorVencimento +
                    valorDocumento +
                    '7' + agencia + trim(conta) + ContaDigito +
                    NossoNumero +  '2';


    DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);
  end;

  Result := IntToStr(Numero) + '9' + DigitoCodBarras + Copy(CodigoBarras, 5, 39);

end;

function TACBrBancoSafra.TipoOcorrenciaToCod(
  const TipoOcorrencia: TACBrTipoOcorrencia): string;
begin
  case TipoOcorrencia of
    toRetornoRegistroConfirmado                    : Result := '02';
    toRetornoRegistroRecusado                      : Result := '03';
    toRetornoTransferenciaCarteiraEntrada          : Result := '04';
    toRetornoTransferenciaCarteiraBaixa            : Result := '05';
    toRetornoLiquidado                             : Result := '06';
    toRetornoLiquidadoParcialmente                 : Result := '07';
    toRetornoBaixaAutomatica                       : Result := '09';
    toRetornoBaixadoInstAgencia                    : Result := '10';
    toRetornoTituloEmSer                           : Result := '11';
    toRetornoAbatimentoConcedido                   : Result := '12';
    toRetornoAbatimentoCancelado                   : Result := '13';
    toRetornoVencimentoAlterado                    : Result := '14';
    toRetornoLiquidadoEmCartorio                   : Result := '15';
    toRetornoBaixadoFrancoPagamento                : Result := '16';
    toRetornoEntradaBorderoManual                  : Result := '17';
    toRetornoAlteracaoUsoCedente                   : Result := '18';
    toRetornoRecebimentoInstrucaoProtestar         : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto    : Result := '20';
    toRetornoTransferenciaCedente                  : Result := '21';
    toRetornoEncaminhadoACartorio                  : Result := '23';
    toRetornoBaixaPorProtesto                      : Result := '40';
    toRetornoLiquidadoAposBaixaOuNaoRegistro       : Result := '41';
    toRetornoRetiradoDeCartorio                    : Result := '42';
    toRetornoDespesaCartorio                       : Result := '43';
    toRetornoDebitoDiretoAutorizado                : Result := '44';
    toRetornoDebitoDiretoNaoAutorizado             : Result := '45';
    toRetornoRecebimentoInstrucaoAlterarValorTitulo: Result := '51';
    toRetornoAlteracaoDataEmissao                  : Result := '52';
    toRetornoAlteracaoEspecie                      : Result := '53';
    toRetornoAlteracaoSeuNumero                    : Result := '54';
    toRetornoEqualizacaoVendor                     : Result := '60';
    toRetornoRecebimentoInstrucaoAlterarJuros      : Result := '77';
    else
      Result := '02';
  end;
end;

function TACBrBancoSafra.TipoOcorrenciaToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia): string;
var
  CodOcorrencia: integer;
begin
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia), 0);

  case CodOcorrencia of
    02: Result := '02-ENTRADA CONFIRMADA';
    03: Result := '03-ENTRADA REJEITADA';
    04: Result := '04-TRANSFER�NCIA DE CARTEIRA (ENTRADA)';
    05: Result := '05-TRANSFER�NCIA DE CARTEIRA (BAIXA)';
    06: Result := '06-LIQUIDA��O NORMAL';
    07: Result := '07-LIQUIDA��O PARCIAL';
    09: Result := '09-BAIXADO AUTOMATICAMENTE';
    10: Result := '10-BAIXADO CONFORME INSTRU��ES';
    11: Result := '11-T�TULOS EM SER (PARA ARQUIVO MENSAL)';
    12: Result := '12-ABATIMENTO CONCEDIDO';
    13: Result := '13-ABATIMENTO CANCELADO';
    14: Result := '14-VENCIMENTO ALTERADO';
    15: Result := '15-LIQUIDA��O EM CART�RIO';
    16: Result := '16-BAIXADO POR ENTREGA FRANCO DE PAGAMENTO';
    17: Result := '17-ENTRADA POR BORDERO MANUAL';
    18: Result := '18-ALTERACAO DE USO DO CEDENTE';
    19: Result := '19-CONFIRMA��O DE INSTRU��O DE PROTESTO';
    20: Result := '20-CONFIRMA��O DE SUSTAR PROTESTO';
    21: Result := '21-TRANSFER�NCIA DE CEDENTE';
    23: Result := '23-T�TULO ENVIADO A CART�RIO';
    40: Result := '40-BAIXA DE T�TULO PROTESTADO';
    41: Result := '41-LIQUIDA��O DE T�TULO BAIXADO';
    42: Result := '42-T�TULO RETIRADO DO CART�RIO';
    43: Result := '43-DESPESA DE CART�RIO';
    44: Result := '44-ACEITE DO T�TULO DDA PELO SACADO';
    45: Result := '45-N�O ACEITE DO T�TULO DDA PELO SACADO';
    51: Result := '51-VALOR DO T�TULO ALTERADO';
    52: Result := '52-ACERTO DE DATA DE EMISSAO';
    53: Result := '53-ACERTO DE COD ESPECIE DOCTO';
    54: Result := '54-ALTERACAO DE SEU NUMERO';
    60: Result := '60-EQUALIZACAO VENDOR';
    77: Result := '77-ALT. INSTR. COBR. - JUROS';
  end;

  Result := ACBrSTr(Result);
end;

end.
