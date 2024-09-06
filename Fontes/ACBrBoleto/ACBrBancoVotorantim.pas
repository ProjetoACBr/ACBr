{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Victor H Gonzales - Pandaaa                    }
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

unit ACBrBancoVotorantim;

interface

uses Classes, SysUtils, StrUtils, ACBrBoleto, DateUtils, Math, ACBrBoletoConversao;

type

  { TACBrBancoVotorantim }
  TACBrBancoVotorantim = class(TACBrBancoClass)
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

    procedure GerarRegistroHeader400(NumeroRemessa: integer; ARemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa: TStringList); override;
    procedure LerRetorno400(ARetorno: TStringList); override;

    function GerarRegistroHeader240(NumeroRemessa: Integer): String; override;
    function GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String; override;
    function GerarRegistroTrailler240(ARemessa: TStringList): String; override;
    Procedure LerRetorno240(ARetorno: TStringList); override;


    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): string; override;
    function CodOcorrenciaToTipo(const CodOcorrencia: integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): string; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: integer): string; override;

    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;

  end;

implementation

uses ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.Strings, ACBrUtil.DateTime;

var
  aTotal: Extended;
  aCount: Integer;

{ TACBrBancoVotorantim }

constructor TACBrBancoVotorantim.Create(AOwner: TACBrBanco);
begin
  inherited Create(AOwner);
  fpDigito                := 6;
  fpNome                  := 'Banco Votorantim';
  fpNumero                := 655;
  fpTamanhoAgencia        := 5;
  fpTamanhoConta          := 10;
  fpTamanhoCarteira       := 3;
  fpTamanhoMaximoNossoNum := 10;
  fpLayoutVersaoArquivo   := 87;
  fpLayoutVersaoLote      := 45;
end;

function TACBrBancoVotorantim.CalcularDigitoVerificador(
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

function TACBrBancoVotorantim.CodMotivoRejeicaoToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: integer): string;
begin
  case TipoOcorrencia of
    toRetornoRegistroRecusado:
      case CodMotivo of
        001: Result := '001-VALOR DO ABATIMENTO INV�LIDO';
        002: Result := '002-AGENCIA ENCARREGADA DA COBRANCA EM BRANCO OU INV�LIDO';
        003: Result := '003-BAIRRO DO SACADO EM BRANCO OU INV�LIDO';
        004: Result := '004-CARTEIRA INV�LIDA';
        005: Result := '005-CEP N�O NUM�RICO OU INVALIDO';
        006: Result := '006-CIDADE DO SACADO EM BRANCO OU INV�LIDO';
        007: Result := '007-INAPTO CNPJ DO CEDENTE INAPTO';
        008: Result := '008-CNPJ/CPF DO SACADO N�O NUM�RICO OU IGUAL A ZEROS';
        009: Result := '009-MENSAGEM DE COBRAN�A EM BRANCO OU INV�LIDA PARA REGISTRO DO TIPO 7';
        010: Result := '010-DATA DE EMISS�O DE TITULO EM BRANCO OU INV�LIDO';
        011: Result := '011-DATA DE MORA EM BRANCO OU INV�LIDO';
        012: Result := '012-DATA DE MULTA INVALIDA/INFERIOR AO VENCIMENTO DO T�TULO';
        013: Result := '013-INVALIDA/FORA DE PRAZO DE OPERA��O (M�NIMO OU M�XIMO)';
        014: Result := '014-DATA LIMITE PARA CONCESS�O DE DESCONTO INV�LIDO';
        015: Result := '015-SIGLA DO ESTADO INV�LIDA';
        016: Result := '016-CEP INCOMPAT�VEL COM A SIGLA DO ESTADO';
        017: Result := '017-IDENTIFICA A ESPECIE DO TITULO EM BRANCO OU INV�LIDO';
        018: Result := '018-IDENTIFICA��O DO TIPO INSCRI��O DO SACADO EM BRANCO OU INV�LIDO';
        019: Result := '019-INSTRU��O DE COBRANCA INV�LIDA';
        020: Result := '020-JUROS DE MORA MAIOR QUE O PERMITIDO';
        021: Result := '021-LOGRADOURO N�O INFORMADO OU DESLOCADO';
        022: Result := '022-NOME DO SACADO N�O INFORMADO OU DESLOCADO';
        023: Result := '023-NOSSO N�MERO J� REGISTRADO OU INV�LIDO';
        024: Result := '024-NUMERO DA INSCRI��O DO SACADO EM BRANCO OU INV�LIDO';
        025: Result := '025-NUMERO DE INSCRI��O DA EMPRESA EM BRANCO OU INV�LIDO';
        026: Result := '026-OCORR�NCIA INV�LIDA';
        027: Result := '027-PRAZO PARA PROTESTO EM BRANCO OU INV�LIDO';
        028: Result := '028-NOME N�O INFORMADO OU DESLOCADO (BANCOS CORRESPONDENTES)';
        029: Result := '029-SEU NUMERO EM BRANCO';
        030: Result := '030-VALOR DE MULTA INV�LIDO OU MAIOR QUE O PERMITIDO';
        031: Result := '031-VALOR DE MORA POR DIA DE ATRASO EM BRANCO OU INV�LIDO';
        032: Result := '032-VALOR DO ABATIMENTO A SER CONCEDIDO INV�LIDO';
        033: Result := '033-VALOR DE DESCONTO A SER CONCEDIDO INV�LIDO';
        034: Result := '034-VALOR DO ABATIMENTO A SER CONCEDIDO INV�LIDO';
        035: Result := '035-VALOR NOMINAL DO TITULO EM BRANCO OU INV�LIDO';
        036: Result := '036-VALOR DE ABATIMENTO INV�LIDO';
        037: Result := '037-VALOR NOMINAL INV�LIDO';
        038: Result := '038-DATA DE PRORROGA��O INV�LIDA';
        039: Result := '039-DATA DE VENCIMENTO MENOR QUE A DATA ATUAL OU INV�LIDA';
        040: Result := '040-VALOR MINIMO INV�LIDO';
        041: Result := '041-VALOR MAXIMO INV�LIDO';
        042: Result := '042-VALOR MINIMO E/O MAXIMO INV�LIDO(S)';
        043: Result := '043-TITULO J� BAIXADO, LIQUIDADO, COM INSTRU��O DE PROTESTO OU RECUSADA PELO BANCO';
        044: Result := '044-NUMERO DE DIAS PARA BAIXA AUTOM�TICA INV�LIDO';
        045: Result := '045-TITULO SEM INSTRU��O DE PROTESTO OU BAIXADO/LIQUIDADO';
        046: Result := '046-SUSTA��O DE PROTESTO N�O PERMITIDA PARA O TITULO';
        047: Result := '047-TITULO SEM INSTRU��O E BAIXA AUTOM�TICA OU J� BAIXADO/LIQUIDADO';
        048: Result := '048-RECUSADO CART�RIO SEM CUSTAS';
        049: Result := '049-RECUSADO CART�RIO COM CUSTAS';
        050: Result := '050-CONV�NIO SEM C�DIGO DO BOLETO PERSONALIZADO CADASTRADO OU C�DIGO INFORMADO DIFERENTE DO CADASTRADO';
        051: Result := '051-PROTESTO RECUSADO PELO CART�RIO';
        052: Result := '052-QUANTIDADE DE PARCELAS INV�LIDA';
        053: Result := '053-ARQUIVO EXCEDEU A QUANTIDADE DE LINHAS PERMITIDAS';
        054: Result := '054-CONVENIO N�O PERMITE MENSAGEM PERSONALIZADA';
        else
          Result := IntToStrZero(CodMotivo, 3) + ' - Outros Motivos';
      end;
    toRetornoInstrucaoRejeitada:
      case CodMotivo of
        036: Result := '036-ABATIMENTO: VALOR DE ABATIMENTO INV�LIDO';
        037: Result := '037-ALTERA��O DE VALOR: VALOR NOMINAL INV�LIDO';
        038: Result := '038-PRORROGA��O: DATA DE PRORROGA��O INV�LIDA';
        039: Result := '039-ALTERA��O DE VENCIMENTO: DATA DE VENCIMENTO MENOR QUE A DATA ATUAL OU INV�LIDA';
        040: Result := '040-ALTERA��O DE VALOR MINIMO: VALOR MINIMO INV�LIDO';
        041: Result := '041-ALTERA��O DE VALOR MAXIMO: VALOR MAXIMO INV�LIDO';
        042: Result := '042-ALTERA��O DE VALOR MINIMO E MAXIMO: VALOR MINIMO E/O MAXIMO INV�LIDO(S)';
        043: Result := '043-BAIXA: TITULO J� BAIXADO, LIQUIDADO, COM INSTRU�A� DE PROTESTO OU RECUSADA PELO BANCO';
        044: Result := '044-ALTERA��O DE BAIXA AUTOMATICA: NUMERO DE DIAS PARA BAIXA AUTOM�TICA INV�LIDO';
        045: Result := '045-N�O PROTESTAR: TITULO SEM INSTRU��O DE PROTESTO OU BAIXADO/LIQUIDADO';
        046: Result := '046-SUSTAR PROTESTO: SUSTA��O DE PROTESTO N�O PERMITIDA PARA O TITULO';
        047: Result := '047-N�O BAIXAR AUTOMATICAMENTE: TITULO SEM INSTRU��O E BAIXA AUTOM�TICA OU J� BAIXADO/LIQUIDADO';
        048: Result := '048-RECUSADO CART�RIO: RECUSADO CART�RIO SEM CUSTAS';
        049: Result := '049-RECUSADO CART�RIO: RECUSADO CART�RIO COM CUSTAS';
        051: Result := '051-PROTESTO RECUSADO: PROTESTO RECUSADO PELO CART�RIO';
        052: Result := '052-QUANTIDADE DE PARCELAS INV�LIDA: QUANTIDADE DE PARCELAS INV�LIDA';
        else
          Result := IntToStrZero(CodMotivo, 3) + ' - Outros Motivos';
      end;

  end;
end;

function TACBrBancoVotorantim.CodOcorrenciaToTipo(const CodOcorrencia: integer):
TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    07: Result := toRetornoLiquidadoParcialmente;
    08: Result := toRetornoLiquidadoEmCartorio;
    09: Result := toRetornoBaixaAutomatica;
    12: Result := toRetornoAbatimentoConcedido;
    14: Result := toRetornoVencimentoAlterado;
    16: Result := toRetornoInstrucaoRejeitada;
    18: Result := toRetornoConfAlteracaoDiasBaixaAutomatica;
    19: Result := toRetornoConfInstrucaoProtesto;
    20: Result := toRetornoConfInstrucaoSustacaoProtesto;
    21: Result := toRetornoConfInstrucaoNaoProtestar;
    22: Result := toRetornoConfInstrucaoNaoBaixarAutomaticamente;
    23: Result := toRetornoEncaminhadoACartorio;
    24: Result := toRetornoConfAlteracaoDiasBaixaAutomatica;
    25: Result := toRetornoConfirmacaoCancelamentoBaixaAutomatica;
    26: Result := toRetornoConfirmacaoAlteracaoValorNominal;
    27: Result := toRetornoConfirmacaoAlteracaoValorMinimoOuPercentual;
    28: Result := toRetornoConfirmacaoAlteracaoValorMaximoOuPercentual;
    29: Result := toRetornoConfirmacaoAlteracaoValorpercentualMinimoMaximo;
    32: Result := toRetornoBaixaPorProtesto;
    33: Result := toRetornoConfirmacaoProtesto;
    34: Result := toRetornoConfirmacaoSustacao;
    35: Result := toRetornoProtestoSustadoJudicialmente;
    47: Result := toRetornoTransferenciaCarteira;
    48: Result := toRetornoAlteracaoPercentualMinimoMaximo;
    49: Result := toRetornoAlteracaoPercentualMinimo;
    50: Result := toRetornoAlteracaoPercentualMaximo;
    51: Result := toRetornoAlteracaoQuantidadeParcela;
    else
      Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoVotorantim.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    06 : Result:= toRemessaAlterarVencimento;               {Prorroga��o de vencimento}
    07 : Result:= toRemessaAlterarExclusivoCliente;         {Altera��o do valor nominal}
    08 : Result:= toRemessaAlterarVencimento;               {Altera��o do vencimento}
    09 : Result:= toRemessaCancelarInstrucaoProtestoBaixa;  {N�o baixar automaticamente}
    10 : Result:= toRemessaNaoProtestar;                    {N�o Protestar}
    11 : Result:= toRemessaAlterarNumeroDiasBaixa;          {Altera��o de dias para baixa autom�tica}
    12 : Result:= toRemessaAlterarValorMinimo;              {Altera��o do percentual para m�nimo}
    13 : Result:= toRemessaAlterarValorMaximo;              {Altera��o do percentual para m�ximo}
    14 : Result:= toRemessaAlterarValorMinimoMaximo;        {Altera��o do percentual para m�nimo e m�ximo}
    15 : Result:= toRemessaAlteracaoQuantidadeParcela;      {Altera��o da quantidade de parcelas}
    18 : Result:= toRemessaCancelarInstrucaoProtestoBaixa;  {Sustar protesto}
    36 : Result:= toRemessaProtestarUrgente;                {Protesto urgente}
    48 : Result:= toRemessaRegistrarDireta                  {Remessa cobran�a direta (pr�-impressa)}
  else
    Result:= toRemessaRegistrar;                            {Remessa Cobran�a Escritural}
  end;
end;

function TACBrBancoVotorantim.GerarRegistroHeader240(
  NumeroRemessa: Integer): String;
begin
  raise Exception.create(ACBrStr('CNAB 240 n�o implementado.'));
end;

procedure TACBrBancoVotorantim.GerarRegistroHeader400(NumeroRemessa: integer;
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
    wLinha := '0'                                   + // 001-001 ID do Registro Header
              '1'                                   + // 002-002 ID do Arquivo de Remessa
              'REMESSA'                             + // 003-009 Literal de Remessa
              '01'                                  + // 010-011 C�digo do Tipo de Servi�o
              PadRight('COBRANCA', 15)              + // 012-026 Descri��o do tipo de servi�o + "brancos"
              Space(20)                             + // 027-046 "brancos"
              PadRight(Nome, 30)                    + // 047-076 Nome da Empresa
              IntToStr(Numero)                      + // 077-079 C�digo do Banco - 655
              PadRight('BANCO VOTORANTIM S/A', 20)  + // 080-099 Nome do Banco - BANCO VOTORANTIM + "brancos"
              FormatDateTime('ddmmyy', Now)         + // 100-105 Data de gera��o do arquivo
              Space(284)                            + // 106-389 "brancos"
              'CL' + IntToStrZero(NumeroRemessa, 3) + // 390-394 Nr. Sequencial de Gera��o do Arquivo
              IntToStrZero(1, 6);                     // 395-400 Nr. Sequencial do Registro no Arquivo

    ARemessa.Text := ARemessa.Text + UpperCase(wLinha);
  end;

end;

function TACBrBancoVotorantim.GerarRegistroTrailler240(
  ARemessa: TStringList): String;
begin
  raise Exception.create(ACBrStr('CNAB 240 n�o implementado.'));

end;

procedure TACBrBancoVotorantim.GerarRegistroTrailler400(ARemessa: TStringList);
var
  wLinha: String;
begin
  wLinha := '9'                               + // Identifica��o do Registro do Trailler
  Space(393)                                  + // "Branco"
  IntToStrZero(ARemessa.Count + 1, 6);          // N�mero Sequencial do Registro do Arquivo

  ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
end;

function TACBrBancoVotorantim.GerarRegistroTransacao240(
  ACBrTitulo: TACBrTitulo): String;
begin
  raise Exception.create(ACBrStr('CNAB 240 n�o implementado.'));
end;

procedure TACBrBancoVotorantim.GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo;
  aRemessa: TStringList);
var
  wLinha, tipoInscricao,  aConta: String;
  Ocorrencia, aEspecie, aAceite, aInstrucao2: String;
  aTipoSacado, sDataDesconto:String;
begin
  with ACBrTitulo do
  begin
    if ACBrBoleto.Cedente.TipoInscricao = pFisica then
      tipoInscricao := '01'
    else
      tipoInscricao := '02';

    aConta := PadLeft(ACBrBoleto.Cedente.Conta, 8, '0') +
              PadLeft(ACBrBoleto.Cedente.ContaDigito, 1, '0');

    {Pegando C�digo da Ocorrencia}
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar                         : Ocorrencia := '02'; {Pedido de Baixa}
      toRemessaConcederAbatimento             : Ocorrencia := '04'; {Concess�o de Abatimento}
      toRemessaProrrogarVencimento            : Ocorrencia := '06'; {Prorroga��o de vencimento}
      toRemessaAlteracaoValorNominal          : Ocorrencia := '07'; {Altera��o do Valor Nominal}
      toRemessaAlterarVencimento              : Ocorrencia := '08'; {Altera��o de seu n�mero}
      toRemessaNaoBaixarAutomaticamente       : Ocorrencia := '09'; {Pedido de protesto}
      toRemessaNaoProtestar                   : Ocorrencia := '10'; {N�o Protestar}
      toRemessaAlterarNumeroDiasProtesto      : Ocorrencia := '11'; {Altera��o de dias para baixa autom�tica}
      toRemessaAlteracaoPercentualParaMinimo  : Ocorrencia := '12'; {Altera��o do percentual para m�nimo}
      toRemessaAlteracaoPercentualParaMaximo  : Ocorrencia := '13'; {Altera��o do percentual para m�ximo}
      toRemessaAlteracaoPercentualParaMinimoMaximo : Ocorrencia := '14'; {Altera��o do percentual para m�nimo e m�ximo}
      toRemessaAlteracaoQuantidadeParcela     : Ocorrencia := '15'; {Altera��o da quantidade de parcelas}
      toRemessaSustarProtesto                 : Ocorrencia := '18'; {Sustar protesto}
      toRemessaProtestarUrgente               : Ocorrencia := '36'; {Protestar urgente}
      toRemessaRegistrarDireta                : Ocorrencia := '48'; {Remessa cobran�a direta (pr�-impressa)}
      else
        Ocorrencia := '01'; {Remessa cobran�a escritural}
    end;

    {Pegando Especie}
    if trim(EspecieDoc) = 'DM' then
      aEspecie := '01'
    else if trim(EspecieDoc) = 'DS' then
      aEspecie := '08'
    else if trim(EspecieDoc) = 'CC' then
      aEspecie := '31'
    else
      aEspecie := '01';


    if Aceite = atSim then
      aAceite := 'A'
    else
      aAceite := 'N';

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

    wLinha := '1'                                                                            + // 001 a  001 - Identifica��o do Registro de Transa��o
              tipoInscricao                                                                  + // 002 a  003 - Tipo de Inscri��o da Empresa
              PadLeft(OnlyNumber(ACBrBoleto.Cedente.CNPJCPF), 14, '0')                       + // 004 a  017 - N�mero da Inscri��o da Empresa
              '00'                                                                           + // 018 a  019 - "C�digo Instru��o/ Alega��o a ser cancelada/ocorrencia 35"
              PadLeft(ACBrBoleto.Cedente.Convenio, 10, '0')                                  + // 020 a  029 - "C�digo do Conv�nio"
              Space(8)                                                                       + // 030 a  037 - "Brancos"
              PadLeft(NumeroDocumento,25)                                                    + // 038 a  062 - Uso exclusivo da Empresa
              PadLeft(NossoNumero,10,'0')                                                    + // 063 a 072 - N�mero do t�tulo no banco
              PadLeft(Carteira, 3, '0')                                                      + // 073 a 075 - Identifica��o do N�mero da Carteira
              Ocorrencia                                                                     + // 076 a 077 - Identifica��o do Tipo de Ocorr�ncia
              PadLeft(NumeroDocumento, 10, '0')                                              + // 078 a 087 - Identifica��o do T�tulo da Empresa
              FormatDateTime('ddmmyy', Vencimento)                                           + // 088 a 093 - Data de Vencimento do T�tulo
              IntToStrZero(Round(ValorDocumento * 100), 13)                                  + // 094 a 106 - Valor Nominal do T�tulo
              IntToStrZero(ACBrBoleto.Banco.Numero,3)                                        + // 107 a 109 - C�digo do Banco encarregado da cobra�a
              PadLeft(RightStr( ACBrBoleto.Cedente.Agencia, 5), 5, '0')                      + // 110 a 114 - Ag�ncia Encarregada da Cobran�a
              aEspecie                                                                       + // 115 a 116 - Esp�cie do T�tulo
              aAceite                                                                        + // 117 a 117 - Identifica��o do Aceite do T�tulo
              FormatDateTime('ddmmyy', DataDocumento)                                        + // 118 a 123 - Data de Emiss�o do T�tulo
              PadLeft(trim(Instrucao1), 2, '0')                                              + // 124 a 125 - Primeira Instru��o de Cobran�a
              PadLeft(trim(Instrucao2), 2, '0')                                              + // 126 a 127 - Segunda Instru��o de Cobran�a
              Space(10)                                                                      + // 128 a 137 - "Brancos"
              IntToStrZero(round(ValorMoraJuros * 100), 13)                                  + // 138 a 150 - Juros de Mora Por Dia de Atraso
              sDataDesconto                                                                  + // 151 a 156 - Data Limite para Desconto
              IntToStrZero(round(ValorDesconto * 100), 13)                                   + // 157 a 169 - Valor Do Desconto Concedido
              IntToStrZero(round(ValorIOF * 100), 13)                                        + // 170 a 182 - Valor De Iof Opera��es Deseguro
              IntToStrZero(round(ValorAbatimento * 100), 13)                                 + // 183 a 195 -Valor Do Abatimento Concedido Ou Cancelado / Multa
              aTipoSacado                                                                    + // 196 a 197 - C�digo De Inscri��o Do Sacado
              PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0')                                   + // 198 a 211 - N�mero de Inscri��o do Sacado
              PadRight(Sacado.NomeSacado, 40, ' ')                                           + // 212 a 251 - Nome Do Sacado
              PadRight(trim(Sacado.Logradouro) + ' ' + trim(Sacado.Numero), 37, ' ')         + // 252 a 288 - Endere�o Do Sacado
              Space(3)                                                                       + // 289 a 291 - Brancos
              PadRight(Sacado.Bairro, 12, ' ')                                               + // 292 a 303 - Bairro Do Sacado
              PadRight(Sacado.CEP, 8)                                                        + // 304 a 311 - CEP do Sacado
              PadRight(Sacado.Cidade, 15)                                                    + // 312 a 326 - Cidade do Sacado
              PadRight(Sacado.UF, 2)                                                         + // 327 a 328 - UF do Sacado
              PadRight(Sacado.SacadoAvalista.NomeAvalista, 40)                               + // 329 a 368 - Nome do Sacador Avalista / Mensagem espec�fica vide nota 6.1.9 conforme manual do banco
              FormatDateTime('ddmmyy', Vencimento)                                           + // 369 a 374 - Data de Vencimento do T�tulo
              IntToStrZero(DiasDeProtesto,2)                                                 + // 375 a 376 - Data a partir da qual a multa deve ser cobrada
              '0'                                                                            + // 377 a 377 - Identifica��o do Tipo de Moeda, 0=Real
              Space(17)                                                                      + // 378 a 394 - "Branco"
              IntToStrZero(ARemessa.Count + 1, 6);                                             // 395 a 400 - N�mero Sequencial De Registro De Arquivo

    aTotal := aTotal + ValorDocumento;
    Inc(aCount);
    aRemessa.Text := aRemessa.Text + wLinha;
  end;
end;

procedure TACBrBancoVotorantim.LerRetorno240(ARetorno: TStringList);
begin
  raise Exception.create(ACBrStr('CNAB 240 n�o implementado.'));
end;

procedure TACBrBancoVotorantim.LerRetorno400(ARetorno: TStringList);
var
  rCodEmpresa, rCedente, rAgencia, rDigitoAgencia: String;
  rConta, rDigitoConta, rCNPJCPF, Linha: String;
  ContLinha, CodOcorrencia, nColunaMotivoRejeicao, nQtdeMotivosRejeicao: Integer;
  Titulo: TACBrTitulo;
begin
  if StrToIntDef(copy(ARetorno.Strings[0], 77, 3), -1) <> Numero then
    raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                           'n�o � um arquivo de retorno do ' + Nome));

  rCodEmpresa    := trim(Copy(ARetorno[1], 04, 14));
  rCedente       := trim(Copy(ARetorno[0], 27, 10));

  ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0], 100, 2) + '/' +
                                                          Copy(ARetorno[0], 102, 2) + '/' +
                                                          Copy(ARetorno[0], 104, 2), 0,
                                                          'DD/MM/YY');

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0], 395, 6), 0);

  with ACBrBanco.ACBrBoleto do
  begin
    if (not LeCedenteRetorno) and (rCedente <>
        PadLeft(Cedente.CodigoCedente, 10, '0')) then
      raise Exception.Create(ACBrStr('C�digo do Cedente do arquivo inv�lido '+rCedente));

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
      NossoNumero    := Copy(Linha, 63, 10);
      CodOcorrencia  := StrToIntDef(copy(Linha, 101, 2),0);
      OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(CodOcorrencia);

      Carteira := copy(Linha, 099, 2);

      DataOcorrencia := StringToDateTimeDef(copy(Linha, 111, 2) + '/' +
                                            copy(Linha, 113, 2) + '/' +
                                            copy(Linha, 115, 2), 0, 'DD/MM/YY');

      if (CodOcorrencia = 03) or (CodOcorrencia = 16) then // entrada rejeitada
      begin

        nColunaMotivoRejeicao := 367; // posi��o da primeira rejeicao de 4 (367-374)

        for nQtdeMotivosRejeicao := 1 to 4 do
        begin
          if Copy(Linha, nColunaMotivoRejeicao, 2)<>'00' then
          begin
            Titulo.MotivoRejeicaoComando.Add(Copy(Linha, nColunaMotivoRejeicao, 2));
            Titulo.DescricaoMotivoRejeicaoComando.add(CodMotivoRejeicaoToDescricao(Titulo.OcorrenciaOriginal.Tipo,copy(Linha, nColunaMotivoRejeicao, 2)));
          end;
          nColunaMotivoRejeicao := nColunaMotivoRejeicao + 2; // incrementa 2 posicoes para pr�xima rejeicao
        end;

      end;
      NumeroDocumento := copy(Linha, 117, 10);

      if Copy(Linha, 147, 2) <> '00' then
        Vencimento := StringToDateTimeDef(copy(Linha, 147, 2) + '/' +
                                          copy(Linha, 149, 2) + '/' +
                                          copy(Linha, 151, 2), 0, 'DD/MM/YY');

      ValorDocumento       := StrToFloatDef(copy(Linha, 153, 13), 0) / 100;
      case StrToIntDef(copy(Linha, 174, 2),00) of
        01: EspecieDoc := 'DM';
        08: EspecieDoc := 'DS';
        31: EspecieDoc := 'CC';
      else
        EspecieDoc := copy(Linha, 174, 2);
      end;
      ValorDespesaCobranca := StrToFloatDef(Copy(Linha, 176, 13), 0) / 100;
      ValorOutrasDespesas  := StrToFloatDef(Copy(Linha, 189, 13), 0) / 100;
      ValorIOF             := StrToFloatDef(Copy(Linha, 215, 13), 0) / 100;
      ValorAbatimento      := StrToFloatDef(Copy(Linha, 228, 13), 0) / 100;
      ValorDesconto        := StrToFloatDef(Copy(Linha, 241, 13), 0) / 100;
      ValorPago            := StrToFloatDef(Copy(Linha, 254, 13), 0) / 100;
      ValorMoraJuros       := StrToFloatDef(Copy(Linha, 267, 13), 0) / 100;
      ValorOutrosCreditos  := StrToFloatDef(Copy(Linha, 280, 13), 0) / 100;

      if Copy(Linha, 296, 2) <> '00' then
        DataCredito := StringToDateTimeDef(copy(Linha, 296, 2) + '/' +
                                           copy(Linha, 298, 2) + '/' +
                                           copy(Linha, 300, 2), 0, 'DD/MM/YY');
    end;
  end;
end;

function TACBrBancoVotorantim.MontarCampoCodigoCedente(
  const ACBrTitulo: TACBrTitulo): string;
begin
  with ACBrTitulo.ACBrBoleto.Cedente do
  begin
    Result := PadLeft(RightStr(Agencia,5), 5, '0') + ' / ' + PadLeft(ACBrBoleto.Cedente.Conta, 8, '0') + PadLeft(ACBrBoleto.Cedente.ContaDigito, 1, '0');
  end;
end;

function TACBrBancoVotorantim.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string;
begin
  with ACBrTitulo do
  begin
    Result := PadLeft(RightStr(NossoNumero,9),9,'0');
  end;
end;

function TACBrBancoVotorantim.MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): string;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras ,
  valorDocumento, agencia, convenio,
   NossoNumero: string;
begin
  with ACBrTitulo.ACBrBoleto do
  begin
    FatorVencimento  := CalcularFatorVencimento(ACBrTitulo.Vencimento);
    valorDocumento   := IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10);
    convenio            := PadLeft(Cedente.Convenio, 10, '0');
    NossoNumero      := PadLeft(RightStr(ACBrTitulo.NossoNumero,9),10,'0');

    CodigoBarras := IntToStr(Banco.Numero) + '9' + FatorVencimento +
                    valorDocumento +
                    trim(convenio) + '500' +
                    NossoNumero +  '00';


    DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);
  end;
    Result := IntToStr(Numero) + '9' + DigitoCodBarras + FatorVencimento + valorDocumento + PadLeft(convenio,10,'0') + '500' + NossoNumero + '00';

end;

function TACBrBancoVotorantim.TipoOcorrenciaToCod(
  const TipoOcorrencia: TACBrTipoOcorrencia): string;
begin
  case TipoOcorrencia of
    toRetornoRegistroConfirmado                    : Result := '02';
    toRetornoRegistroRecusado                      : Result := '03';
    toRetornoLiquidado                             : Result := '06';
    toRetornoLiquidadoParcialmente                 : Result := '07';
    toRetornoLiquidadoEmCartorio                   : Result := '08';
    toRetornoBaixaAutomatica                       : Result := '09';
    toRetornoAbatimentoConcedido                   : Result := '12';
    toRetornoVencimentoAlterado                    : Result := '14';
    toRetornoInstrucaoRejeitada                    : Result := '16';
    toRetornoConfInstrucaoAlteracaoDiasBaixaAutomatica : Result := '18';
    toRetornoConfInstrucaoProtesto                 : Result := '19';
    toRetornoConfInstrucaoSustacaoProtesto         : Result := '20';
    toRetornoConfInstrucaoNaoProtestar             : Result := '21';
    toRetornoConfInstrucaoNaoBaixarAutomaticamente : Result := '22';
    toRetornoEncaminhadoACartorio                  : Result := '23';
    toRetornoConfAlteracaoDiasBaixaAutomatica      : Result := '24';
    toRetornoConfirmacaoCancelamentoBaixaAutomatica: Result := '25';
    toRetornoConfirmacaoAlteracaoValorNominal      : Result := '26';
    toRetornoConfirmacaoAlteracaoValorMinimoOuPercentual : Result := '27';
    toRetornoConfirmacaoAlteracaoValorMaximoOuPercentual : Result := '28';
    toRetornoConfirmacaoAlteracaoValorpercentualMinimoMaximo : Result := '29';
    toRetornoBaixaPorProtesto                      : Result := '32';
    toRetornoConfirmacaoProtesto                   : Result := '33';
    toRetornoConfirmacaoSustacao                   : Result := '34';
    toRetornoProtestoSustadoJudicialmente          : Result := '35';
    toRetornoTransferenciaCarteira                 : Result := '47';
    toRetornoAlteracaoPercentualMinimoMaximo       : Result := '48';
    toRetornoAlteracaoPercentualMinimo             : Result := '49';
    toRetornoAlteracaoPercentualMaximo             : Result := '50';
    toRetornoAlteracaoQuantidadeParcela            : Result := '51';
    else
      Result := '02';
  end;
end;

function TACBrBancoVotorantim.TipoOcorrenciaToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia): string;
var
  CodOcorrencia: integer;
begin
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia), 0);

  case CodOcorrencia of
    02: Result := '02-ENTRADA CONFIRMADA';
    03: Result := '03-ENTRADA REJEITADA';
    06: Result := '06-LIQUIDA��O NORMAL';
    07: Result := '07-LIQUIDA��O PARCIAL';
    08: Result := '08-LIQUIDA��O EM CART�RIO';
    09: Result := '09-BAIXA SIMPLES';
    12: Result := '12-ABATIMENTO CONCEDIDO';
    14: Result := '14-VENCIMENTO ALTERADO';
    16: Result := '16-INSTRU��ES REJEITADAS';
    18: Result := '18-CONFIRMA��O DA INSTRU��O DE ALTERA��O DE DIAS PARA BAIXA AUTOMATICA';
    19: Result := '19-CONFIRMA��O DA INSTRU��O DE PROTESTO';
    20: Result := '20-CONFIRMA��O DA INSTRU��O DE SUSTA��O DE PROTESTO';
    21: Result := '21-CONFIRMA��O DA INSTRU��O DE N�O PROTESTAR';
    22: Result := '22-CONFIRMA��O DA INSTRU��O DE N�O BAIXAR AUTOMATICAMENTE';
    23: Result := '23-PROTESTO ENVIADO A CART�RIO';
    24: Result := '24-CONFIRMA��O DE ALTERA��O DE DIAS PARA BAIXA AUTOMATICA';
    25: Result := '25-CONFIRMA��O DE CANCELAMENTO DE BAIXA AUTOMATICA';
    26: Result := '26-CONFIRMA��O DE ALTERA��O DO VALOR NOMINAL';
    27: Result := '27-CONFIRMA��O DE ALTERA��O DE VALOR/PERCENTUAL MINIMO';
    28: Result := '28-CONFIRMA��O DE ALTERA��O DE VALOR/PERCENTUAL MAXIMO';
    29: Result := '29-CONFIRMA��O DE ALTERA��O DE VALOR/PERCENTUAL M�NIMO E MAXIMO';
    32: Result := '32-BAIXA POR TER SIDO PROTESTADO';
    33: Result := '33-CONFIRMA��O DE PROTESTO';
    34: Result := '34-CONFIRMA��O DE SUSTA��O';
    35: Result := '35-PROTESTO SUSTADO JUDICIALMENTE';
    47: Result := '47-TRANSFER�NCIA DE CARTEIRA';
    48: Result := '48-ALTERA��O DE PERCENTUAL M�NIMO/ M�XIMO';
    49: Result := '49-ALTERA��O DE PERCENTUAL M�NIMO';
    50: Result := '50-ALTERA��O DE PERCENTUAL M�XIMO';
    51: Result := '51-ALTERA��O DA QUANTIDADE DE PARCELAS';
  end;

  Result := ACBrSTr(Result);
end;

end.
