{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliana Tamizou                                 }
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

unit ACBrBancoABCBrasil;

interface

uses
  Classes, SysUtils, Contnrs,
  ACBrBoleto, ACBrBoletoConversao;

type

  { TACBrBancoABCBrasil }

  TACBrBancoABCBrasil = class(TACBrBancoClass)
  private
    ISequencia: integer;
  protected
    vTotalTitulos: Double;

    fpQtdCobrancaSimples: Integer;
    fpQtdCobrancaVinculada: Integer;
    fpQtdCobrancaCaucionada: Integer;
    fpQtdCobrancaDescontada: Integer;

    fpTotalCobrancaSimples: Double;
    fpTotalCobrancaVinculada: Double;
    fpTotalCobrancaCaucionada: Double;
    fpTotalCobrancaDescontada: Double;
    function GetLocalPagamento: string; override;
  public
    constructor create(AOwner: TACBrBanco);
    function CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): string; override;
    function DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string; override;
    function GerarRegistroHeader240(NumeroRemessa: Integer): string; override;
    function GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): string; override;
    function GerarRegistroTrailler240(ARemessa: TStringList): string; override;
    procedure GerarRegistroHeader400(NumeroRemessa: Integer; aRemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa: TStringList); override;
    procedure GerarRegistrosNFe(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
    procedure LerRetorno240(ARetorno: TStringList); override;
    procedure LerRetorno400(ARetorno: TStringList); override;
    procedure MontarRegistroMensagem400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
    procedure MontarRegistroBeneficiarioFinal400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): string; override;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): string; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; const CodMotivo: String): string; override;
  end;

const
  NUMERO_BANCO_REMESSA = '246';
  NOME_BANCO_REMESSA = 'Banco ABC Brasil';

implementation

uses
{$IFDEF COMPILER6_UP}dateutils{$ELSE}ACBrD5{$ENDIF},
  StrUtils, math, ACBrUtil.Base, ACBrValidador, ACBrUtil.Strings, ACBrUtil.DateTime;

{ TACBrBancoABCBrasil }

constructor TACBrBancoABCBrasil.create(AOwner: TACBrBanco);
begin
  inherited create(AOwner);
  fpDigito                := 2;
  fpNome                  := 'ABC Brasil';
  fpNumero                := 246;
  fpTamanhoMaximoNossoNum := 10;
  fpTamanhoAgencia        := 4;
  fpTamanhoConta          := 8;
  fpTamanhoCarteira       := 3;
  ISequencia              := 0;
end;

function TACBrBancoABCBrasil.CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): string;
begin
  Modulo.FormulaDigito        := frModulo10;
  Modulo.MultiplicadorFinal   := 1;
  Modulo.MultiplicadorInicial := 2;
  Modulo.Documento :=
    ACBrTitulo.ACBrBoleto.Cedente.Agencia
    + ACBrTitulo.Carteira
    + PadLeft(ACBrTitulo.NossoNumero, fpTamanhoMaximoNossoNum, '0');
  Modulo.Calcular;
  Result := IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoABCBrasil.DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String;
begin

  Result :=
   PadLeft(ACBrTitulo.ACBrBoleto.Cedente.Agencia, 4, '0')
   + PadLeft(ACBrTitulo.Carteira, 3, '0')
   + PadLeft(ACBrTitulo.ACBrBoleto.Cedente.Operacao, 7, '0')
   + PadLeft(ACBrTitulo.NossoNumero, 10, '0')
   + CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoABCBrasil.MontarCampoNossoNumero(
  const ACBrTitulo: TACBrTitulo): string;
var
  NossoNr, DV: string;
begin

  NossoNr := PadLeft(ACBrTitulo.NossoNumero, fpTamanhoMaximoNossoNum, '0');
  DV := CalcularDigitoVerificador(ACBrTitulo);
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia
    + ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito
    + '/' + ACBrTitulo.Carteira
    + '/' + NossoNr
    + '-' + DV;
end;

function TACBrBancoABCBrasil.MontarCampoCodigoCedente(
  const ACBrTitulo: TACBrTitulo): string;
begin
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia
    + ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito
    + '/'
    + ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente;
end;

function TACBrBancoABCBrasil.GerarRegistroHeader240(NumeroRemessa: Integer): string;
var
  ATipoInscricao,
    aModalidade: string;
begin
  ISequencia := 0;
  fpQtdCobrancaSimples := 0;
  fpQtdCobrancaVinculada := 0;
  fpQtdCobrancaCaucionada := 0;
  fpQtdCobrancaDescontada := 0;

  fpTotalCobrancaSimples := 0.0;
  fpTotalCobrancaVinculada := 0.0;
  fpTotalCobrancaCaucionada := 0.0;
  fpTotalCobrancaDescontada := 0.0;

  with ACBrBanco.ACBrBoleto.Cedente do
  begin
    case TipoInscricao of
      pFisica: ATipoInscricao := '1';
      pJuridica: ATipoInscricao := '2';
    else
      ATipoInscricao := '1';
    end;

    aModalidade := PadLeft(trim(Modalidade), 3, '0');

    { GERAR REGISTRO-HEADER DO ARQUIVO }

    Result := '246' + // 1 a 3 - C�digo do banco
    '0000' + // 4 a 7 - Lote de servi�o
    '0' + // 8 - Tipo de registro - Registro header de arquivo
    StringOfChar(' ', 9) + // 9 a 17 Uso exclusivo FEBRABAN/CNAB
    ATipoInscricao + // 18 - Tipo de inscri��o do cedente
    PadLeft(OnlyNumber(CNPJCPF), 14, '0') + // 19 a 32 -N�mero de inscri��o do cedente
    PadRight(Convenio, 20, ' ') + // 33 a 52 - C�digo do conv�nio no banco
    PadRight(Convenio, 20, ' ') + // 53 a 72 - Conta da Empresa
    TiraAcentos(UpperCase(PadRight(Nome, 30, ' '))) + // 73 a 102 - Nome do cedente
    PadRight('BANCO ABC BRASIL', 30, ' ') + // 103 a 132 - Nome do banco
    StringOfChar(' ', 10) + // 133 a 142 - Uso exclusivo FEBRABAN/CNAB
    '1' + // 143 - C�digo de Remessa (1) / Retorno (2)
    FormatDateTime('ddmmyyyy', Now) + // 144 a 151 - Data do de gera��o do arquivo
    FormatDateTime('hhmmss', Now) + // 152 a 157 - Hora de gera��o do arquivo
    PadLeft(IntToStr(NumeroRemessa), 6, '0') + // 158 a 163 - N�mero seq�encial do arquivo
    '040' + // 164 a 166 - N�mero da vers�o do layout do arquivo
    StringOfChar('0', 5) + // 167 a 171 - Densidade de grava��o do arquivo (BPI)
    StringOfChar(' ', 20) + // 172 a 191 - Uso reservado do banco
    StringOfChar(' ', 20) + // 192 a 211 - Uso reservado da empresa
    StringOfChar(' ', 29); // 212 a 240 - Brancos


    { GERAR REGISTRO HEADER DO LOTE }

    Result := Result + #13#10 +
      '246' + // 1 a 3 - C�digo do banco
    '0001' + // 4 a 7 - Lote de servi�o
    '1' + // 8 - Tipo de registro - Registro header de arquivo
    'R' + // 9 - Tipo de opera��o: R (Remessa) ou T (Retorno)
    '01' + // 10 a 11 - Tipo de servi�o: 01 (Cobran�a)
    StringOfChar(' ', 2) + // 12 a 13 - Uso exclusivo FEBRABAN/CNAB
    '030' + // 14 a 16 - N�mero da vers�o do layout do lote
    ' ' + // 17 - Uso exclusivo FEBRABAN/CNAB
    ATipoInscricao + // 18 - Tipo de inscri��o do cedente
    PadLeft(OnlyNumber(CNPJCPF), 15, '0') + // 19 a 32 -N�mero de inscri��o do cedente
    PadRight(Convenio, 20, ' ') + // 33 a 53 - C�digo do conv�nio no banco
    PadRight(Convenio, 20, ' ') + // 54 a 73 - Agencia
    TiraAcentos(UpperCase(PadRight(Nome, 30, ' '))) + // 74 a 103 - Nome do cedente
    StringOfChar(' ', 40) + // 104 a 143 - Mensagem 1 para todos os boletos do lote
    StringOfChar(' ', 40) + // 144 a 183 - Mensagem 2 para todos os boletos do lote
    PadLeft(IntToStr(NumeroRemessa), 8, '0') + // 184 a 191 - N�mero do arquivo
    FormatDateTime('ddmmyyyy', Now) + // 192 a 199 - Data de gera��o do arquivo
    StringOfChar('0', 8) + // 200 a 207 - Data do cr�dito - S� para arquivo retorno
    StringOfChar(' ', 33); // 208 a 240 - Uso exclusivo FEBRABAN/CNAB
  end;
end;

procedure TACBrBancoABCBrasil.GerarRegistroHeader400(NumeroRemessa: Integer; aRemessa: TStringList);
var
  LLinha: string;
  Beneficiario: TACBrCedente;
begin
  Beneficiario := ACBrBanco.ACBrBoleto.Cedente;
  vTotalTitulos := 0;

  LLinha := '0'                                             + // 001-001 Identifica��o do registro
  '1'                                                       + // 002-002 Identifica��o do arquivo remessa
  'REMESSA'                                                 + // 003-009 Literal remessa
  '01'                                                      + // 010-011 C�digo de servi�o
  PadRight('COBRANCA', 15, ' ')                             + // 012-026 Literal servi�o
  PadRight(Beneficiario.CodigoTransmissao, 20, ' ')         + // 027-046 C�digo da empresa
  PadRight(Beneficiario.Nome, 30, ' ')                      + // 047-076 Nome da empresa M�e
  IntToStrZero(ACBrBanco.Numero, 3)                         + // 077-079 N�mero do ABC na c�mara de compensa��o CIP
  PadRight(ACBrBanco.Nome, 15, ' ')                         + // 080-094 Nome do banco por extenso
  FormatDateTime('ddmmyy', Now)                             + // 095-100 Data da grava��o do arquivo
  Space(294)                                                + // 101-394 Brancos
  '000001';                                                   // 395-400 N� sequencial do registro

  ARemessa.Add(UpperCase(LLinha));
end;

function TACBrBancoABCBrasil.GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): string;
var

  sCodMovimento: string;
  sDigitoNossoNumero, sTipoCobranca, sTipoDocto, sTipoCarteira: string;
  sEspecie, sDataMoraJuros, sDataDesconto: string;
  STipoJuros, sTipoDesconto, sDiasProtesto, sDiasBaixaDevol: string;
  sTipoInscricao, sEndereco: string;
  aTipoInscricao: Char;
  sEmissaoBloqueto, sIdentDistribuicao, sServicoClassificacao: string;
  function MontarInstrucoes1: string;
  begin
    with ACBrTitulo do
    begin
      if Mensagem.Count = 0 then
      begin
        Result := PadRight('', 140, ' '); // 2 registros
        Exit;
      end;

      Result := '';
      if Mensagem.Count >= 1 then
      begin
        Result := Result +
          Copy(PadRight(Mensagem[0], 70, ' '), 1, 70);
      end;

      if Mensagem.Count >= 2 then
      begin
        Result := Result +
          Copy(PadRight(Mensagem[1], 70, ' '), 1, 70)
      end
      else
      begin
        if (Result <> EmptyStr) then
          Result := Result + PadRight('', 70, ' ') // 1 registro
        else
          Result := Result + PadRight('', 140, ' '); // 2 registros
        Exit;
      end;
    end;
  end;

  function MontarInstrucoes2: string;
  begin
    with ACBrTitulo do
    begin
      if Mensagem.Count <= 2 then
      begin
        // Somente duas linhas, foi montado o MonarInstrucoes1
        Result := PadRight('', 200, ' '); // 5 registros
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
  aTipoInscricao := ' ';
  // by J�ter Rabelo Ferreira - 06/2014
  with ACBrTitulo do
  begin
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar: sCodMovimento := '02'; {Pedido de Baixa}
      toRemessaConcederAbatimento: sCodMovimento := '04'; {Concess�o de Abatimento}
      toRemessaCancelarAbatimento: sCodMovimento := '05'; {Cancelamento de Abatimento concedido}
      toRemessaAlterarVencimento: sCodMovimento := '06'; {Altera��o de vencimento}
      toRemessaConcederDesconto: sCodMovimento := '07'; {Concess�o de Desconto}
      toRemessaCancelarDesconto: sCodMovimento := '08'; {Cancelamento de Desconto}
      toRemessaProtestar: sCodMovimento := '09'; {Pedido de protesto}
      toRemessaSustarProtestoBaixarTitulo: sCodMovimento := '10'; {Sustar Protesto e Baixar T�tulo}
      toRemessaSustarProtestoManterCarteira: sCodMovimento := '11'; {Sustar Protesto e Manter em Carteira}
      toRemessaRecusaAlegacaoSacado: sCodMovimento := '30'; {Recusa da Alega��o do Sacado}
    else
      sCodMovimento := '01'; {Remessa}
    end;

    sDigitoNossoNumero := CalcularDigitoVerificador(ACBrTitulo);

    case CaracTitulo of
      tcSimples:
        begin
          sTipoCobranca := '1'; {Cobran�a Simples (Sem Registro e Eletr�nica com Registro)}

          Inc(fpQtdCobrancaSimples);
          fpTotalCobrancaSimples := fpTotalCobrancaSimples + ACBrTitulo.ValorDocumento;
        end;
      tcCaucionada:
        begin
          sTipoCobranca := '3'; {Cobran�a Caucionada (Eletr�nica com Registro e Convencional com Registro)}

          Inc(fpQtdCobrancaCaucionada);
          fpTotalCobrancaCaucionada := fpTotalCobrancaCaucionada + ACBrTitulo.ValorDocumento;
        end;
      tcDescontada:
        begin
          sTipoCobranca := '4'; {Cobran�a Descontada (Eletr�nica com Registro)}

          Inc(fpQtdCobrancaDescontada);
          fpTotalCobrancaDescontada := fpTotalCobrancaDescontada + ACBrTitulo.ValorDocumento;

        end;
      tcVinculada:
        begin
          sTipoCobranca := '5'; {Cobran�a Simples (R�pida com Registro)}
          Inc(fpQtdCobrancaVinculada);
          fpTotalCobrancaVinculada := fpTotalCobrancaVinculada + ACBrTitulo.ValorDocumento;
        end;
      { TODO :
          6 = Cobran�a Caucionada (R�pida com Registro)
          8 = Cobranca Cessao (Eletronica com Registro)
      }
    end;

    ACBrBoleto.Cedente.TipoCarteira := tctRegistrada;
    case ACBrBoleto.Cedente.TipoCarteira of
      tctSimples: sTipoCarteira := '2';
      tctRegistrada: sTipoCarteira := '1';
    else
      sTipoCarteira := '2';
    end;

    ACBrBoleto.Cedente.TipoDocumento := Escritural;
    case ACBrBoleto.Cedente.TipoDocumento of
      Tradicional: sTipoDocto := '1';
      Escritural: sTipoDocto := '2';
    end;

    if sTipoDocto = '' then
      sTipoDocto := '1' // Tradicional
    else if sTipoDocto = '1' then
    begin
      sTipoDocto := '1';
      sEspecie := '02'
    end
    else if sTipoDocto = '2' then
    begin
      sTipoDocto := '2';
      sEspecie := '02'
    end
    else
    begin
      if Trim(EspecieDoc) = 'DM' then {DM - DUPLICATA MERCANTIL}
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
        if not MatchText(EspecieDoc, ['1', '02', '04', '12', '13', '17', '20', '97', '98']) then
          raise Exception.Create('Esp�cie de documento informada incorretamente!');

        sEspecie := EspecieDoc;
      end;
    end;

    if (ValorMoraJuros > 0) then
    begin
      STipoJuros := '1'; // Valor por dia
      //      STipoJuros := '2';  // Taxa Mensal
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

    if ValorDesconto > 0 then
    begin
      if DataDesconto <> 0 then
      begin
        sDataDesconto := FormatDateTime('ddmmyyyy', DataDesconto);
        sTipoDesconto := '1'; // Valor fixo ate a data informada � Informar o valor no campo �valor de desconto a ser concedido�.
      end
      else
      begin
        sTipoDesconto := '0'; // ISENTO
        sDataDesconto := PadLeft('', 8, '0');
      end;
    end
    else
    begin
      sTipoDesconto := '0'; // ISENTO
      sDataDesconto := PadLeft('', 8, '0');
    end;

    {Instru��es}

    Instrucao1 := Trim(Instrucao1);
    Instrucao2 := Trim(Instrucao2);

    if (DataProtesto <> 0) and
      (DataProtesto > Vencimento) then
    begin
      if (Instrucao1 = '') then
        Instrucao1 := '1' // Protestar Dias Corridos
      else
      begin
        if not MatchText(Instrucao1, ['0', '1', '2', '3', '9']) then
          raise Exception.Create('C�digo de protesto informado incorretamente!');
      end;
      // Calcular os dias para protesto
      sDiasProtesto := PadLeft(IntToStr(Trunc(DataProtesto) - Trunc(Vencimento)), 2, '0');
    end
    else
    begin
      Instrucao1 := '3'; // N�o protestar
      SDiasProtesto := '00';
    end;

    // Baixa/Devolu��o
    if (Instrucao2 = '') then
      Instrucao2 := '2' // NAO BAIXAR / NAO DEVOLVER
    else
    begin
      if not MatchText(Instrucao2, ['1', '2', '3']) then
        raise Exception.Create('C�digo de Baixa/Devolu��o informado incorretamente!');
    end;

    sDiasBaixaDevol := ifthen(DataBaixa > 0,
      IntToStrZero(DaysBetween(Vencimento, DataBaixa), 3),
      '000');

    case Sacado.Pessoa of
      pFisica: sTipoInscricao := '1';
      pJuridica: sTipoInscricao := '2';
      pOutras: sTipoInscricao := '9';
    end;

    if Sacado.SacadoAvalista.CNPJCPF <> '' then
    begin
      case Sacado.SacadoAvalista.Pessoa of
        pFisica: aTipoInscricao := '1';
        pJuridica: aTipoInscricao := '2';
        pOutras: aTipoInscricao := '9';
      end;
    end
    else
      aTipoInscricao := '0';

    sEndereco := Trim(Sacado.Logradouro) + ' ' + Trim(Sacado.Numero) + Trim(Sacado.Complemento);
    sEndereco := PadRight(Trim(sEndereco), 40, ' ');

    sEmissaoBloqueto := '';
    ACBrBoleto.Cedente.ResponEmissao := tbCliEmite;
    case ACBrBoleto.Cedente.ResponEmissao of
      tbBancoEmite: sEmissaoBloqueto := '1';
      tbCliEmite: sEmissaoBloqueto := '2';
      tbBancoPreEmite: sEmissaoBloqueto := '3';
      tbBancoReemite: sEmissaoBloqueto := '4';
      tbBancoNaoReemite: sEmissaoBloqueto := '5';
    end;

    sIdentDistribuicao := '';
    case ACBrBoleto.Cedente.IdentDistribuicao of
      tbBancoDistribui: sIdentDistribuicao := '1';
      tbClienteDistribui: sIdentDistribuicao := '2';
    end;

    if sIdentDistribuicao = '' then
      raise Exception.Create('Campo IdentDistribuicao do cedente n�o informado');

    if sEmissaoBloqueto = '' then
      raise Exception.Create('Campo respons�vel emiss�o do cedente n�o informado');

    sServicoClassificacao := '5';

    //    case ACBrBoleto.Cedente.ServicoClassificao of
    //      tsClassifcarCEP: sServicoClassificacao := '0';
    //      tsCorrespondenteEspecificoCEP: sServicoClassificacao := '3';
    //      tsCorrespondenteEspecificoNaoCEP: sServicoClassificacao := '4';
    //      tsBancoCedenteNaoCEP: sServicoClassificacao := '5';
    //      tsCorrespondenteEspecificoNaoCEPNN: sServicoClassificacao := '7';
    //    end;


    Inc(ISequencia);
    {SEGMENTO P}
    Result := '246' + // 001 - 003 / C�digo do Banco na compensa��o
    '0001' + // 004 - 007 / Numero do lote remessa
    '3' + // 008 - 008 / Tipo de registro
    IntToStrZero(ISequencia, 5) + // 009 - 013 / N�mero seq�encial do registro no lote
    'P' + // 014 - 014 / C�d. Segmento do registro detalhe
    Space(1) + // 015 - 015 / Reservado (uso Banco)
    sCodMovimento + // 016 - 017 / C�digo de movimento remessa
    PadRight(ACBrBoleto.Cedente.Convenio, 20, ' ') + // 018 - 037 / C�digo Empresa
    PadLeft(sServicoClassificacao, 1, '0') + // 038 - 038 / Direcionamento da Cobran
    PadLeft('000', 3, '0') + // 039 - 041 / Modalidade de Cobran�a em bancos Correspondentes
    PadLeft('', 2, '0') + // 042 - 043 / Uso exclusivo AUTBANK
    PadLeft(ACBrBoleto.Cedente.Modalidade, 3, '0') + // 044 - 046 / Modalidade de Cobran�a com Banco Cedente (NOSSA CARTEIRA)
    PadLeft(NossoNumero, 10, '0') + PadLeft(sDigitoNossoNumero, 1, '0') + // 047 � 057 / Identifica��o do t�tulo no Banco (Nosso N�mero
    sTipoCobranca + // 058 - 058 / Codigo Carteira
    sTipoCarteira + // 059 - 059 / Forma de Cadastramento = 1 Registrada / 2 Sem Registro
    sTipoDocto + // 060 - 060 / Tipo de documento
    sEmissaoBloqueto + // 061 - 061 / Identifica��o da emiss�o do bloqueto
    sIdentDistribuicao + // 062 - 062 / Identifica��o da Distribui��o
    PadRight(Copy(SeuNumero, 1, 15), 15) + // 063 - 077 / N� do documento
    FormatDateTime('ddmmyyyy', Vencimento) + // 078 - 085 / Data de vencimento do t�tulo
    IntToStrZero(round(ValorDocumento * 100), 15) + // 086 - 100 / Valor nominal do t�tulo
    PadLeft('0', 5, '0') + // 101 - 105 / Ag�ncia encarregada da cobran�a
    '0' + // 106 - 106 / D�gito da Ag�ncia encarregada da cobran�a
    sEspecie + // 107 � 108 / Esp�cie do t�tulo
    ifThen(Aceite = atSim, 'S', 'N') + // 109 - 109 / Identif. de t�tulo Aceito/N�o Aceito
    FormatDateTime('ddmmyyyy', DataDocumento) + // 110 - 117 / Data da emiss�o do t�tulo
    STipoJuros + // 118 - 118 / C�digo do juros de mora
    sDataMoraJuros + // 119 - 126 / Data do juros de mora
    IntToStrZero(round(ValorMoraJuros * 100), 15) + // 127 - 141 / Valor da mora/dia ou Taxa mensal
    sTipoDesconto + // 142 - 142 / C�digo do desconto 1
    sDataDesconto + // 143 - 150 / Data de desconto 1
    IntToStrZero(round(ValorDesconto * 100), 15) + // 151 - 165 / Valor ou Percentual do desconto concedido
    IntToStrZero(round(ValorIOF * 100), 15) + // 166 - 180 / Valor do IOF a ser recolhido
    IntToStrZero(round(ValorAbatimento * 100), 15) + // 181 - 195 / Valor do abatimento
    PadRight(NossoNumero + sDigitoNossoNumero, 25) + // 196 - 220 / Identifica��o do t�tulo na empresa
    Instrucao1 + // 221 - 221 / C�digo para protesto
    sDiasProtesto + // 222 - 223 / N�mero de dias para protesto
    Instrucao2 + // 224 - 224 / C�digo para Baixa/Devolu��o
    PadLeft(sDiasBaixaDevol, 3, '0') + // 225 - 227 / N�mero de dias para Baixa/Devolu��o
    '09' + // 228 - 229 / C�digo da moeda
    PadLeft('', 10, '0') + // 230 - 239 / N� do Contrato da Opera��o de Cr�d
    Space(1); // 240 � 240 / Reservado (uso Banco)
    {SEGMENTO P - FIM}

    Inc(ISequencia);
    {SEGMENTO Q}
    Result := Result + #13#10 +
      '246' + // 001 - 003 / C�digo do Banco na compensa��o
    '0001' + // 004 - 007 / Numero do lote remessa
    '3' + // 008 - 008 / Tipo de registro
    IntToStrZero(ISequencia, 5) + // 009 - 013 / N�mero seq�encial do registro no lote
    'Q' + // 014 - 014 / C�d. Segmento do registro detalhe
    Space(1) + // 015 - 015 / Reservado (uso Banco)
    sCodMovimento + // 016 - 017 / C�digo de movimento remessa
    sTipoInscricao + // 018 - 018 / Tipo de inscri��o do sacado
    PadLeft(trim(OnlyNumber(Sacado.CNPJCPF)), 15, '0') + // 019 - 033 / N�mero de inscri��o do sacado
    PadRight(Trim(Sacado.NomeSacado), 40) + // 034 - 073 / Nome sacado
    PadRight(Trim(sEndereco), 40, ' ') + // 074 - 113 / Endere�o sacado
    PadRight(Trim(Sacado.Bairro), 15, ' ') + // 114 - 128 / Bairro sacado
    PadLeft(Copy(OnlyNumber(Sacado.CEP), 1, 5), 5, '0') + // 129 - 133 / Cep sacado
    PadLeft(Copy(OnlyNumber(Sacado.CEP), 6, 3), 3, '0') + // 134 - 136 / Sufixo do Cep do sacado
    PadRight(Trim(Sacado.Cidade), 15, ' ') + // 137 - 151 / Cidade do sacado
    PadRight(Sacado.UF, 2, ' ') + // 152 - 153 / Unidade da federa��o do sacado
    aTipoInscricao + // 154 - 154 / Tipo de inscri��o sacador/avalista
    PadLeft(trim(OnlyNumber(Sacado.SacadoAvalista.CNPJCPF)), 15, '0') + // 155 - 169 / N� de inscri��o sacador/avalista
    PadRight(Sacado.SacadoAvalista.NomeAvalista, 40, ' ') + // 170 - 209 / Nome do sacador/avalista
    '000' + // 210 � 212 / Banco Correspondente
    Space(20) + // 213 � 232 / Nosso N� no banco Correspondente
    // PadRight(PadLeft(NossoNumero,12,' ') + sDigitoNossoNumero,20,' ')
    Space(8); // 233 � 240 / Reservado (uso Banco)
    {SEGMENTO Q - FIM}

    Inc(ISequencia);
    {SEGMENTO R}
    Result := Result + #13#10 +
      '246' + // 001 - 003 / C�digo do Banco na compensa��o
    '0001' + // 004 - 007 / Numero do lote remessa
    '3' + // 008 - 008 / Tipo de registro
    IntToStrZero(ISequencia, 5) + // 009 - 013 / N�mero seq�encial do registro no lote
    'R' + // 014 - 014 / C�d. Segmento do registro detalhe
    Space(1) + // 015 - 015 / Reservado (uso Banco)
    sCodMovimento + // 016 - 017 / C�digo de movimento remessa
    '0' + // 018 - 018 / C�digo do desconto 2
    PadLeft('', 8, '0') + // 019 - 026 / Data do desconto 2
    IntToStrZero(0, 15) + // 027 - 041 / Valor/Percentual a ser concedido
    '0' + // 042 - 042 / C�digo do desconto 3
    PadLeft('', 8, '0') + // 043 - 050 / Data do desconto 3
    IntToStrZero(0, 15) + // 051 - 065 / '1'  =  Valor Fixo      '2'  =  Percentual
    IfThen((PercentualMulta > 0), '2', '0') + // 066 - 066 / C�digo da multa
    IfThen((PercentualMulta > 0), FormatDateTime('ddmmyyyy', DataMulta), '00000000') + // 67 - 74 Se cobrar informe a data para iniciar a cobran�a ou informe zeros se n�o cobrar
    IfThen(PercentualMulta > 0, IntToStrZero(round(PercentualMulta * 10000), 15), IntToStrZero(0, 15)) + // 075 - 089 / Valor/Percentual a ser aplicado
    // IntToStrZero(round(MultaValorFixo * 100), 15))
    Space(10) + // 090 - 099 / Reservado (uso Banco)
    Space(40) + // 100 - 139 / Branco
    Space(40) + // 140 - 179 / branco
    Space(61); // 180 - 240 / Reservado (uso Banco)

    if MontarInstrucoes1 <> '' then begin
      Inc(ISequencia);
      {SEGMENTO S}
      Result := Result + #13#10 +
        '246' + 						          //001 - 003 C�digo do Banco na compensa��o
        '0001' + 						          //004 - 007 Numero do lote remessa
        '3' + 							          //008 - 008 Tipo de registro
        IntToStrZero(ISequencia, 5) + //009 - 013 N�mero seq�encial do registro no lote
        'S' + 							          //014 - 014 C�d. Segmento do registro detalhe
        ' ' + 							          //015 - 015 Reservado (uso Banco)
        sCodMovimento + 				      //016 - 017 C�digo de movimento remessa
        '1'  +  						          //018 - 018 Tipo de Impress�o Identifica��o da Impress�o  //
        '01' + 							          //019 - 020 N�mero da Linha a ser Impressa
        MontarInstrucoes1 + 			    //021 - 160 Mensagem a ser Impressa
        '01' +							          //161 - 162 Tipo do Caracter a ser Impresso
        Space (78); 					        //163 -  240 Uso Exclusivo FEBRABAN/CNAB
    end;

    if ACBrTitulo.ListaDadosNFe.Count > 0 then // Se tem informacoes de NFe associadas ao titulo
    begin
      Inc(ISequencia);
      {SEGMENTO Y-52}
      Result := Result + #13#10 +
        '246' + // 001 - 003 / C�digo do Banco na compensa��o
        '0001' + // 004 - 007 / Numero do lote remessa
        '3' + // 008 - 008 / Tipo de registro
        IntToStrZero(ISequencia, 5) + // 009 - 013 / N�mero seq�encial do registro no lote
        'Y' + // 014 - 014 / C�d. Segmento do registro detalhe
        ' ' + // 015 - 015 / Reservado (uso Banco)
        sCodMovimento + // 016 - 017 / C�digo de movimento remessa
        '52' + // Identifica��o Registro Opcional 18 19 2
        PadRight(ListaDadosNFe[0].NumNFe, 15, ' ') +  // Nota Fiscal 1 N�mero da Nota Fiscal 1 20 34 15
        IntToStrZero(round(ListaDadosNFe[0].ValorNFe * 100), 15) + // Valor N. Fiscal Valor da Nota Fiscal 1 35 49 13 2
        FormatDateTime('ddmmyyyy', ListaDadosNFe[0].EmissaoNFe) + // Data Emiss�o Data Emiss�o da Nota Fiscal 1 50 57 8
        PadRight(ListaDadosNFe[0].ChaveNFe, 44, ' '); //Chave Acesso Chave de Acesso DANFE NF 1 58 101 44

      if ACBrTitulo.ListaDadosNFe.Count <  2 then
        Result := Result + Space(15) + StringOfChar('0',67) +
          Space (57) // Uso Exclusivo FEBRABAN/CNAB 184 240 57
      else
      begin
        Result := Result +
          PadRight(ListaDadosNFe[1].NumNFe, 15, ' ') +  // Nota Fiscal 1 N�mero da Nota Fiscal 1 20 34 15
          IntToStrZero(round(ListaDadosNFe[1].ValorNFe * 100), 15) + // Valor N. Fiscal Valor da Nota Fiscal 1 35 49 13 2
          FormatDateTime('ddmmyyyy', ListaDadosNFe[1].EmissaoNFe) + // Data Emiss�o Data Emiss�o da Nota Fiscal 1 50 57 8
          PadRight(ListaDadosNFe[1].ChaveNFe, 44, ' ') + //Chave Acesso Chave de Acesso DANFE NF 1 58 101 44
          Space (57); // Uso Exclusivo FEBRABAN/CNAB 184 240 57
      end;
    end;
  end;
end;

procedure TACBrBancoABCBrasil.GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
var
  Boleto             : TACBrBoleto;
  Beneficiario       : TACBrCedente;
  Pagador            : TACBrSacado;
  BeneficiarioFinal  : TACBrSacadoAvalista;
  LTipoPessoa        : String;
  LCPFCNPJ           : String;
  LLinha             : String;
  LCodigoMulta       : String;
  LValorMulta        : Integer;
  LCarteira          : String;
  LOcorrencia        : String;
  LEspecieDoc        : String;
  LDiasProtesto      : Integer;
begin
  Boleto            := ACBrTitulo.ACBrBoleto;
  Beneficiario      := Boleto.Cedente;
  Pagador           := ACBrTitulo.Sacado;
  BeneficiarioFinal := ACBrTitulo.Sacado.SacadoAvalista;

  {C�digo de Inscri��o 002 - 003}
  {N�mero de Inscri��o da Empresa 004-017}
  if (BeneficiarioFinal.CNPJCPF <> '') then
  begin
    LTipoPessoa :=  ifThen(BeneficiarioFinal.Pessoa = pFisica, '03', '04');
    LCPFCNPJ    :=  OnlyNumber(BeneficiarioFinal.CNPJCPF);
  end else
  begin
    LTipoPessoa :=  IfThen(Beneficiario.TipoInscricao = pFisica, '01', '02');
    LCPFCNPJ    :=  OnlyNumber(Beneficiario.CNPJCPF);
  end;
  {C�digo da Multa 090-090}
  LCodigoMulta := '0'; //Sem Multa
  if (ACBrTitulo.MultaValorFixo) then
    LCodigoMulta := '1' //Valor Fixo
  else
  if (ACBrTitulo.PercentualMulta > 0) then
    LCodigoMulta := '2'; //Percentual

  {Valor ou Taxa de Multa 091-103}
  case StrToInt(LCodigoMulta) of
    1 : LValorMulta := Round(ACBrTitulo.ValorDocumento * ACBrTitulo.PercentualMulta);
    2 : LValorMulta := Round(ACBrTitulo.PercentualMulta * 10000);
  end;

  case StrToIntDef(ACBrTitulo.Carteira,0) of
    4,110 : LCarteira := '4';
    6,121 : LCarteira := '6';
    else
       LCarteira := '0';
  end;

  {C�digo de Ocorr�ncia 109-110}
  case ACBrTitulo.OcorrenciaOriginal.Tipo of
    toRemessaRegistrar          : LOcorrencia := '01';
    toRemessaBaixar             : LOcorrencia := '02';
    toRemessaConcederAbatimento : LOcorrencia := '04';
    toRemessaCancelarAbatimento : LOcorrencia := '05';
    toRemessaAlterarVencimento  : LOcorrencia := '06';
    toRemessaProtestar          : LOcorrencia := '09';
    toRemessaNaoProtestar       : LOcorrencia := '10';
    toRemessaSustarProtesto     : LOcorrencia := '18';
    toRemessaAlterarValorTitulo : LOcorrencia := '47';
    else
      LOcorrencia := '01';
  end;

  {Esp�cie do t�tulo 148-149}
  case AnsiIndexStr(ACBrTitulo.EspecieDoc, ['DM', 'NP', 'CHQ', 'LC', 'RC', 'AS', 'DS', 'CC', 'OUT']) of
    0 : LEspecieDoc := '01'; //DM duplicata mercantil por indica��o
    1 : LEspecieDoc := '02'; //NP nota promiss�ria
    2 : LEspecieDoc := '03'; //CHQ Cheque
    3 : LEspecieDoc := '04'; //LC letra de c�mbio
    4 : LEspecieDoc := '05'; //RC Recibo
    5 : LEspecieDoc := '08'; //AS Ap�lice de Seguro
    6 : LEspecieDoc := '12'; //DS Duplicata de Servi�o
    7 : LEspecieDoc := '31'; //CC Cart�o de Cr�dito
    8 : LEspecieDoc := '99'; //OUT Outros
  else
    LEspecieDoc := ACBrTitulo.EspecieDoc; //Outros
  end;

  {Instru��o01 157-158}
  {Prazo 392-393}
  LDiasProtesto := ACBrTitulo.DiasDeProtesto;
  if LDiasProtesto = 0 then
    if ACBrTitulo.DataProtesto > 0 then
      LDiasProtesto := DaysBetween(ACBrTitulo.DataProtesto, ACBrTitulo.Vencimento);

  try
    LLinha := '1'                                                    + // 001-001 Identifica��o do registro de transa��o
              LTipoPessoa                                            + // 002-003 Identifica��o do Tipo de Inscri��o da empresa
     PadLeft(LCPFCNPJ, 14, '0')                                      + // 004-017 N�mero de Inscri��o da Empresa (CNPJ/CPF)
     PadRight(Beneficiario.CodigoTransmissao, 20, ' ')               + // 018-037 Identifica��o da empresa no ABC
     PadRight(ACBrTitulo.SeuNumero, 25, ' ')                         + // 038-062 Identifica��o do T�tulo na empresa
     PadLeft(ACBrTitulo.NossoNumero, 10, '0')                        + // 063-072 Identifica��o do T�tulo no Banco
     PadLeft(CalcularDigitoVerificador(ACBrTitulo), 1, '0')          + // 073-073 DV Nosso N�mero
     Space(13)                                                       + // 074-086 Cobran�a Direta T�tulo Correspondente
     Space(03)                                                       + // 087-089 Modalidade de Cobran�a com bancos correspondentes
     LCodigoMulta                                                    + // 090-090 C�digo da Multa 0 - Sem multa 1 - Valor fixo 2 - percentual
     Poem_Zeros(LValorMulta, 13)                                     + // 091-103 Valor ou Taxa de Multa
     IfThen(LValorMulta > 0,'01','00')                               + // 104-105 N�mero de Dias Ap�s o Vencimento para aplicar a Multa
     Space(02)                                                       + // 106-107 Brancos
     LCarteira                                                       + // 108-108 C�digo da Carteira :: Carteira 6 alterada segundo email 112 para 6
     LOcorrencia                                                     + // 109-110 Identifica��o da ocorr�ncia
     PadRight(ACBrTitulo.NumeroDocumento, 10, ' ')                   + // 111-120 N. documento de Cobran�a (Duplicata, Promiss�ria etc.)
     FormatDateTime('ddmmyy', ACBrTitulo.Vencimento)                 + // 121-126 Data de vencimento do t�tulo
     Poem_Zeros(Round(ACBrTitulo.ValorDocumento * 100), 13)          + // 127-139 Valor do t�tulo
     Poem_Zeros(ACBrBanco.Numero, 3)                                 + // 140-142 C�digo do Banco
     Poem_Zeros(0, 4)                                                + // 143-146  Ag�ncia encarregada da cobran�a ZEROS
     Poem_Zeros(0, 1)                                                + // 147-147  DV Ag�ncia encarregada da cobran�a ZEROS
     LEspecieDoc                                                     + // 148-149 Esp�cie do t�tulo
     IfThen(ACBrTitulo.Aceite = atSim, 'A', 'N')                     + // 150-150 Aceite (A ou N)
     FormatDateTime('ddmmyy', ACBrTitulo.DataDocumento)              + // 151-156 Data da emiss�o do t�tulo
     IfThen(LDiasProtesto > 0, '00', '10')                           + // 157-158 Primeira Instru��o
     '00'                                                            + // 159-160 Segunda Instru��o
     Poem_Zeros(Round(ACBrTitulo.ValorMoraJuros * 100), 13)          + // 161-173 Valor de mora por dia de atraso
     IfThen(ACBrTitulo.DataDesconto > 0,
      FormatDateTime('ddmmyy', ACBrTitulo.DataDesconto), '000000')   + // 174-179 Data Limite para concess�o de desconto
     Poem_Zeros(Round(ACBrTitulo.ValorDesconto * 100), 13)           + // 180-192 Valor do desconto a ser concedido
     Poem_Zeros(Round(ACBrTitulo.ValorIOF * 100), 13)                + // 193-205 Valor do I.O.F. a ser recolhido pelo Banco no caso de seguro
     Poem_Zeros(Round(ACBrTitulo.ValorAbatimento * 100), 13)         + // 206-218 Valor do abatimento a ser concedido
     IfThen(Pagador.Pessoa = pFisica, '01', '02')                    + // 219-220 Identifica��o do tipo de inscri��o do sacado
     PadLeft(OnlyNumber(Pagador.CNPJCPF), 14, '0')                   + // 221-234 N�mero de Inscri��o do Sacado
     PadRight(TiraAcentos(Pagador.NomeSacado), 30, ' ')              + // 234-264 Nome do Sacado
     Space(10)                                                       + // 265-274 Complementa��o do Registro - Brancos
     PadRight(TiraAcentos(Pagador.Logradouro) + ' ' +
                          Pagador.Numero + ' ' +
                          Pagador.Complemento, 40, ' ')              + // 275-314 Rua, N�mero e Complemento do Sacado
     PadRight(TiraAcentos(Pagador.Bairro), 12, ' ')                  + // 315-326 Bairro do Sacado
     PadLeft(OnlyNumber(Pagador.CEP), 8, '0')                        + // 327-334 CEP do Sacado
     PadRight(TiraAcentos(Pagador.Cidade), 15, ' ')                  + // 335-349 Cidade do Sacado
     PadRight(TiraAcentos(Pagador.UF), 2, ' ')                       + // 350-351 Bairro do Sacado
     PadLeft(BeneficiarioFinal.NomeAvalista, 30, ' ')                + // 352-381 Nome do Sacador ou Avalista
     Space(4)                                                        + // 382-391 Complementa��o do Registro - Brancos
     Space(6)                                                        + // 382-391 Complementa��o do Registro - Brancos
     IfThen(LDiasProtesto > 0, Poem_Zeros(LDiasProtesto, 2), '00')   + // 392-393 Quantidade de dias para in�cio da A��o de Protesto
     '0'                                                             + // 394-394 Moeda 0 ou 1 Moeda Corrente Nacional
     Poem_Zeros(ARemessa.Count + 1, 6);                                // 395-400 N�mero Sequencial do Registro no Arquivo

  finally
    ARemessa.Add(UpperCase(LLinha));
    MontarRegistroBeneficiarioFinal400(ACBrTitulo, aRemessa);
    MontarRegistroMensagem400(ACBrTitulo, aRemessa);

    if ACBrTitulo.ListaDadosNFe.Count > 0 then
      GerarRegistrosNFe(ACBrTitulo, aRemessa);
  end;
end;

procedure TACBrBancoABCBrasil.MontarRegistroBeneficiarioFinal400(
  ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
var
  BeneficiarioFinal  : TACBrSacadoAvalista;
  LLinha             : String;
begin
  BeneficiarioFinal := ACBrTitulo.Sacado.SacadoAvalista;

  if NaoEstaVazio(BeneficiarioFinal.CNPJCPF) then
  begin
    LLinha := '5'                                                           + // 001-001 Identifica��o registro
     Space(120)                                                             + // 002-121 Complementa��o do Registro - Brancos
     PadLeft(ifThen(BeneficiarioFinal.Pessoa = pFisica, '03', '04'),2,'0')  + // 122-123 Identifica��o de Inscri��o do Sacador/Avalista
     PadLeft(OnlyNumber(BeneficiarioFinal.CNPJCPF),14,'0')                  + // 124-137 N�mero de Inscri��o do Sacador/Avalista
     PadRight(TiraAcentos(BeneficiarioFinal.Logradouro) + ' ' +
                          BeneficiarioFinal.Numero + ' ' +
                          BeneficiarioFinal.Complemento, 40, ' ')           + // 138-177 Rua, N�mero de complemento do Sacador/Avalista
     PadRight(TiraAcentos(BeneficiarioFinal.Bairro), 12, ' ')               + // 315-326 Bairro do Sacador/Avalista
     PadLeft(OnlyNumber(BeneficiarioFinal.CEP), 8, '0')                     + // 327-334 CEP do Sacador/Avalista
     PadRight(TiraAcentos(BeneficiarioFinal.Cidade), 15, ' ')               + // 335-349 Cidade do Sacador/Avalista
     PadRight(TiraAcentos(BeneficiarioFinal.UF), 2, ' ')                    + // 350-351 Bairro do Sacador/Avalista
     Space(180)                                                             + // 348-394 Complementa��o do Registro - Brancos
     Poem_Zeros(ARemessa.Count + 1, 6);                                       // 395-400 N�mero sequencial de registro

    ARemessa.Add(UpperCase(LLinha));
  end;
end;

procedure TACBrBancoABCBrasil.GerarRegistrosNFe(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
var
  LQtdRegNFes, X, I, LQtdNFeNaLinha: Integer;
  LLinha, LNFeSemDados: String;
  LContinua: Boolean;
begin
   LNFeSemDados:= StringOfChar(' ',15) + StringOfChar('0', 65);
   LQtdRegNFes:= trunc(ACBrTitulo.ListaDadosNFe.Count / 3);

   if (ACBrTitulo.ListaDadosNFe.Count mod 3) <> 0 then
      Inc(LQtdRegNFes);

   X:= 0;
   I:= 0;
   repeat
   begin
      LContinua:=  true;

      LLinha:= '4';
      LQtdNFeNaLinha:= 0;
      while (LContinua) and (X < ACBrTitulo.ListaDadosNFe.Count) do
      begin
         LLinha:= LLinha +
                  PadRight(ACBrTitulo.ListaDadosNFe[X].NumNFe,15) +
                  IntToStrZero(round(ACBrTitulo.ListaDadosNFe[X].ValorNFe  * 100 ), 13) +
                  FormatDateTime('ddmmyyyy',ACBrTitulo.ListaDadosNFe[X].EmissaoNFe) +
                  PadLeft(ACBrTitulo.ListaDadosNFe[X].ChaveNFe, 44, '0');

         Inc(X);
         Inc(LQtdNFeNaLinha);
         LContinua := (X mod 3) <> 0 ;
      end;

      if LQtdNFeNaLinha < 3 then
      begin
         LLinha:= LLinha + LNFeSemDados;
         if LQtdNFeNaLinha < 2 then
            LLinha:= LLinha + LNFeSemDados;
      end;

      LLinha:= PadRight(LLinha,241) + StringOfChar(' ', 153) +
               IntToStrZero(aRemessa.Count + 1, 6);

      aRemessa.Add(LLinha);
      Inc(I);
   end;
   until (I = LQtdRegNFes);
end;

function TACBrBancoABCBrasil.GetLocalPagamento: string;
begin
  Result := ACBrStr(CInstrucaoPagamentoTodaRede);
end;

function TACBrBancoABCBrasil.GerarRegistroTrailler240(
  ARemessa: TStringList): string;

begin


  // by J�ter Rabelo Ferreira - 06/2014
     {REGISTRO TRAILER DO LOTE}
  Result := '246' + // 001 - 003 / C�digo do Banco na compensa��o
  '0001' + // 004 - 007 / Numero do lote remessa
  '5' + // 008 - 008 / Tipo de registro
  Space(9) + // 009 - 017 / Reservado (uso Banco
  IntToStrZero(ISequencia + 2, 6) + // 018 - 023 / Quantidade de registros do lote
  IntToStrZero(fpQtdCobrancaSimples, 6) + // 024 - 029 / Quantidade de t�tulos em cobran�a simples
  IntToStrZero(round(fpTotalCobrancaSimples * 100), 17) + // 030 - 046 / Valor dos t�tulos em cobran�a simples
  IntToStrZero(fpQtdCobrancaVinculada, 6) + // 047 - 052 / Quantidade t�tulos em cobran�a vinculada
  IntToStrZero(round(fpTotalCobrancaVinculada * 100), 17) + // 053 - 069 / Valor dos t�tulos em cobran�a vinculada
  IntToStrZero(fpQtdCobrancaCaucionada, 6) + // 070 - 075 / Quantidade t�tulos em cobran�a Caucionada
  IntToStrZero(round(fpTotalCobrancaCaucionada * 100), 17) + // 076 - 092 / Valor dos t�tulos em cobran�a Caucionada
  IntToStrZero(fpQtdCobrancaDescontada, 6) + // 093 - 098 / Quantidade t�tulos em cobran�a Descontada
  IntToStrZero(round(fpTotalCobrancaDescontada * 100), 17) + // 099 - 115 / Valor dos t�tulos em cobran�a Descontada
  space(8) + // 116 - 123 / Uso exclusivo AUTBANK
  space(117); // 124 - 240 / Reservado (uso Banco)

  {GERAR REGISTRO TRAILER DO ARQUIVO}
  Result := Result + #13#10 +
    '246' + // 001 - 003 / C�digo do Banco na compensa��o
  '9999' + // 004 - 007 / Numero do lote remessa
  '9' + // 008 - 008 / Tipo de registro
  space(9) + // 009 - 017 / Reservado (uso Banco)
  '000001' + // 018 - 023 / Quantidade de lotes do arquivo
  IntToStrZero(ISequencia + 4, 6) + // 024 - 029 / Quantidade de registros do arquivo
  PadLeft('', 6, '0') + // 030 - 035 / Qtde. de Contas Concilia��o
  space(205); // 036 - 240 / Reservado (uso Banco)
end;

procedure TACBrBancoABCBrasil.GerarRegistroTrailler400(ARemessa: TStringList);
var
  LLinha: string;
begin
  LLinha := '9' + // ID Registro
  StringOfChar(' ', 393) +
    IntToStrZero(ARemessa.Count + 1, 6);

  ARemessa.Text := ARemessa.Text + UpperCase(LLinha);
end;

procedure TACBrBancoABCBrasil.LerRetorno240(ARetorno: TStringList);
var
  Titulo: TACBrTitulo;
  Linha, rConvenio, rCodigoCedente, rCedente, rCNPJCPF: string;
  CodMotivoRejeicao: string;
  iLinha: Integer;

  procedure DoVerOcorrencia(AOcorrencia: string);
  var
    pMotivoRejeicao, I: Integer;
  begin
    with Titulo.OcorrenciaOriginal do
    begin
      Tipo := CodOcorrenciaToTipo(StrToIntDef(AOcorrencia, 0));

      Titulo.MotivoRejeicaoComando.Clear;
      Titulo.DescricaoMotivoRejeicaoComando.Clear;
      pMotivoRejeicao := 214;
      if Tipo = toRetornoTituloDDARecusadoCIP then
      begin
        CodMotivoRejeicao := copy(Linha, pMotivoRejeicao, 8);
        Titulo.MotivoRejeicaoComando.Add(CodMotivoRejeicao);
        Titulo.DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicao);
        Exit;
      end;
      //Adiciona as Rejei�oes caso existam
      for I := 0 to 4 do
      begin
        CodMotivoRejeicao := copy(Linha, pMotivoRejeicao, 2);
        if not ((Trim(CodMotivoRejeicao) = '00') or
          (Trim(CodMotivoRejeicao) = '')) then
        begin
          Titulo.MotivoRejeicaoComando.Add(CodMotivoRejeicao);
          Titulo.DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(
            Tipo, CodMotivoRejeicao));
        end;
        Inc(pMotivoRejeicao, 2);
      end;
    end;
  end;
begin

  // Verificar se o retorno � do banco selecionado
  if copy(ARetorno.Strings[0], 1, 3) <> NUMERO_BANCO_REMESSA then
    raise Exception.create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
      ' n�o � um arquivo de retorno do banco' + sLineBreak + NOME_BANCO_REMESSA));

  rConvenio := Copy(ARetorno[0], 33, 20);
  rCedente := Copy(ARetorno[0], 73, 30);
  rCNPJCPF := RightStr(OnlyNumber(Copy(ARetorno[0], 19, 14)), 14);

  with ACBrBanco.ACBrBoleto do
  begin
    if (not LeCedenteRetorno) and (rCNPJCPF <> OnlyNumber(Cedente.CNPJCPF)) then
      raise Exception.create(ACBrStr('CNPJ\CPF do arquivo inv�lido'));

    Cedente.Nome := rCedente;
    Cedente.CodigoCedente := rCodigoCedente;
    Cedente.CNPJCPF := rCnpjCpf;

    if StrToIntDef(copy(ARetorno[0], 18, 1), 0) = 1 then
      Cedente.TipoInscricao := pFisica
    else
      Cedente.TipoInscricao := pJuridica;

    ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
  end;

  ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0], 144, 2) + '/' +
    Copy(ARetorno[0], 146, 2) + '/' +
    Copy(ARetorno[0], 148, 4), 0, 'DD/MM/YYYY');

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0], 158, 6), 0);

  for iLinha := 1 to ARetorno.Count - 2 do
  begin
    Linha := ARetorno[iLinha];

    if copy(Linha, 14, 1) = 'T' then // se for segmento T cria um novo Titulo
      Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

    with Titulo do
    begin
      if copy(Linha, 14, 1) = 'T' then
      begin
        NossoNumero := Copy(Linha, 47, ACBrBanco.TamanhoMaximoNossoNum);
        SeuNumero := Copy(Linha, 59, 15);
        NumeroDocumento := Copy(Linha, 59, 15);
        Carteira := Copy(Linha, 58, 1);
        ValorDocumento := StrToFloatDef(copy(Linha, 82, 15), 0) / 100;
        ValorDespesaCobranca := StrToFloatDef(copy(Linha, 199, 15), 0) / 100;
        Vencimento := StringToDateTimeDef(Copy(Linha, 74, 2) + '/' +
          Copy(Linha, 76, 2) + '/' +
          Copy(Linha, 78, 4), 0, 'DD/MM/YYYY');

        // Sacado
        if Copy(Linha, 133, 1) = '1' then
          Sacado.Pessoa := pFisica
        else
          Sacado.Pessoa := pJuridica;
        Sacado.CNPJCPF := Trim(Copy(Linha, 134, 15));
        Sacado.NomeSacado := Trim(Copy(Linha, 149, 40));

        // Algumas ocorr�ncias est�o diferentes do cnab400, farei uma separada aqui
        DoVerOcorrencia(Copy(Linha, 16, 2));
      end
      else if copy(Linha, 14, 1) = 'U' then
      begin
        ValorPago := StrToFloatDef(copy(Linha, 78, 15), 0) / 100;
        ValorMoraJuros := StrToFloatDef(copy(Linha, 18, 15), 0) / 100;
        ValorDesconto := StrToFloatDef(copy(Linha, 33, 15), 0) / 100;
        ValorAbatimento := StrToFloatDef(copy(Linha, 48, 15), 0) / 100;
        ValorIOF := StrToFloatDef(copy(Linha, 63, 15), 0) / 100;
        ValorRecebido := StrToFloatDef(copy(Linha, 78, 15), 0) / 100;
        ValorOutrasDespesas := StrToFloatDef(copy(Linha, 108, 15), 0) / 100;
        ValorOutrosCreditos := StrToFloatDef(copy(Linha, 123, 15), 0) / 100;
        DataOcorrencia := StringToDateTimeDef(Copy(Linha, 138, 2) + '/' +
          Copy(Linha, 140, 2) + '/' +
          Copy(Linha, 142, 4), 0, 'DD/MM/YYYY');
        DataCredito := StringToDateTimeDef(Copy(Linha, 146, 2) + '/' +
          Copy(Linha, 148, 2) + '/' +
          Copy(Linha, 150, 4), 0, 'DD/MM/YYYY');

        //A posi��o do nosso numero come�a na 214
        //NossoNumeroCorresp  := Copy(Linha, 214, 20);
      end;
    end;
  end;
end;

procedure TACBrBancoABCBrasil.LerRetorno400(ARetorno: TStringList);
var
  Index: Integer;
  LLinha: string;
  LTitulo: TACBrTitulo;
  LBoleto: TACBrBoleto;
  LColunaMotivoRejeicao : integer;
  LQtdeMotivosRejeicao : integer;
begin
  LBoleto := ACBrBanco.ACBrBoleto;

  if (StrToIntDef(copy(ARetorno.Strings[0], 77, 3), -1) <> Numero) then
    raise Exception.create(ACBrStr(LBoleto.NomeArqRetorno + 'n�o � um arquivo de retorno do ' + Nome));

  LBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0], 95, 2)
    + '/'
    + Copy(ARetorno[0], 97, 2)
    + '/'
    + Copy(ARetorno[0], 99, 2), 0, 'DD/MM/YY');

  if LBoleto.LeCedenteRetorno then
  begin
    LBoleto.Cedente.Nome          := Trim(Copy(ARetorno[0], 47, 30));
    LBoleto.Cedente.CNPJCPF       := Trim(Copy(ARetorno[1], 4, 14));
    LBoleto.Cedente.CodigoCedente := Trim(Copy(ARetorno[1], 18, 20));
  end;

  if Trim(LBoleto.Cedente.CodigoCedente) <> Trim(Copy(ARetorno[1], 18, 20)) then
    raise Exception.create(ACBrStr(format('O C�digo de cedente do arquivo %s n�o � o mesmo do componente %s.',[Copy(ARetorno[1], 18, 20),LBoleto.Cedente.CodigoCedente])));

  case StrToIntDef(Copy(ARetorno[1], 2, 2), 0) of
    01: LBoleto.Cedente.TipoInscricao := pFisica;
  else
    LBoleto.Cedente.TipoInscricao := pJuridica;
  end;

  LBoleto.ListadeBoletos.Clear;

  for Index := 1 to ARetorno.Count - 2 do
  begin
    LLinha := ARetorno[Index];

    if (Copy(LLinha, 1, 1) <> '1') then
      Continue;

    LTitulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;
    LTitulo.SeuNumero       := copy(LLinha, 38, 25);
    LTitulo.NossoNumero     := Copy(LLinha, 63, TamanhoMaximoNossoNum);
    LTitulo.Carteira        := copy(LLinha, 83, 3);
    LTitulo.NumeroDocumento := copy(LLinha, 117, 10);

    LTitulo.OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(copy(LLinha, 109, 2), 0));
    if LTitulo.OcorrenciaOriginal.Tipo in [toRetornoRegistroRecusado,
      toRetornoBaixaRejeitada, toRetornoInstrucaoRejeitada] then
    begin
      LColunaMotivoRejeicao := 378; // posi��o da primeira rejeicao
      for LQtdeMotivosRejeicao := 1 to 3 do
      begin
        if Copy(LLinha, LColunaMotivoRejeicao, 2)<>'00' then
        begin
          LTitulo.MotivoRejeicaoComando.Add(Copy(LLinha, LColunaMotivoRejeicao, 2));
          LTitulo.DescricaoMotivoRejeicaoComando.add(CodMotivoRejeicaoToDescricao(LTitulo.OcorrenciaOriginal.Tipo,copy(LLinha, LColunaMotivoRejeicao, 2)));
        end;
        LColunaMotivoRejeicao := LColunaMotivoRejeicao + 2; // incrementa 2 posicoes para pr�xima rejeicao
      end;
    end;

    LTitulo.DataOcorrencia := StringToDateTimeDef(Copy(LLinha, 111, 2)
       + '/'
       + Copy(LLinha, 113, 2)
       + '/'
       + Copy(LLinha, 115, 2), 0, 'DD/MM/YY');

    case StrToIntDef(Copy(LLinha, 174, 2), 0) of
      01: LTitulo.EspecieDoc := 'DM';
      02: LTitulo.EspecieDoc := 'NP';
      03: LTitulo.EspecieDoc := 'CH';
      04: LTitulo.EspecieDoc := 'LC';
      05: LTitulo.EspecieDoc := 'RC';
      08: LTitulo.EspecieDoc := 'AS';
      12: LTitulo.EspecieDoc := 'DS';
      31: LTitulo.EspecieDoc := 'CC';
      99: LTitulo.EspecieDoc := 'OUT';
    end;

    case StrToInt(copy(LLinha, 108, 1)) of
      1: LTitulo.CaracTitulo := tcSimples;
      2: LTitulo.CaracTitulo := tcVinculada;
      3: LTitulo.CaracTitulo := tcCaucionada;
      4: LTitulo.CaracTitulo := tcDescontada;
    end;

    if (StrToIntDef(Copy(LLinha, 147, 6), 0) <> 0) then
      LTitulo.Vencimento := StringToDateTimeDef(Copy(LLinha, 147, 2)
        + '/'
        + Copy(LLinha, 149, 2)
        + '/'
        + Copy(LLinha, 151, 2), 0, 'DD/MM/YY');

    LTitulo.ValorDocumento       := StrToFloatDef(Copy(LLinha, 153, 13), 0) / 100;
    LTitulo.ValorDespesaCobranca := StrToFloatDef(Copy(LLinha, 176, 13), 0) / 100;
    LTitulo.ValorIOF             := StrToFloatDef(Copy(LLinha, 215, 13), 0) / 100;
    LTitulo.ValorAbatimento      := StrToFloatDef(Copy(LLinha, 228, 13), 0) / 100;
    LTitulo.ValorDesconto        := StrToFloatDef(Copy(LLinha, 241, 13), 0) / 100;
    LTitulo.ValorRecebido        := StrToFloatDef(Copy(LLinha, 254, 13), 0) / 100;
    LTitulo.ValorMoraJuros       := StrToFloatDef(Copy(LLinha, 267, 13), 0) / 100;

    if (StrToIntDef(Copy(LLinha, 386, 6), 0) <> 0) then
      LTitulo.DataCredito := StringToDateTimeDef(Copy(LLinha, 386, 2)
        + '/'
        + Copy(LLinha, 388, 2)
        + '/'
        + Copy(LLinha, 390, 2), 0, 'DD/MM/YY');
  end;
end;

procedure TACBrBancoABCBrasil.MontarRegistroMensagem400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
var
  LMensagem: array[0..4] of string;
  LTextos : TStrings;
  Index: integer;
  LLinha: string;
begin
  LLinha := EmptyStr;

  if NaoEstaVazio(ACBrTitulo.Informativo.Text) then
    LTextos := ACBrTitulo.Informativo
  else
    LTextos := ACBrTitulo.Mensagem;

  for Index := 0 to Pred(LTextos.Count) do
  begin
    if Index > 4 then Break;
    LMensagem[Index] := LTextos[Index];
  end;

  if NaoEstaVazio(LTextos.Text) then
  begin
    LLinha := '2'                                   + // 001-001 Identifica��o registro
     '0'                                            + // 002-002 Zero
     PadRight(TiraAcentos(LMensagem[0]), 69)        + // 003-071 Mensagem Livre 1 69 posi��es
     PadRight(TiraAcentos(LMensagem[1]), 69)        + // 072-140 Mensagem Livre 2 69 posi��es
     PadRight(TiraAcentos(LMensagem[2]), 69)        + // 141-209 Mensagem Livre 3 69 posi��es
     PadRight(TiraAcentos(LMensagem[3]), 69)        + // 210-278 Mensagem Livre 4 69 posi��es
     PadRight(TiraAcentos(LMensagem[4]), 69)        + // 279-347 Mensagem Livre 5 69 posi��es
     Space(47)                                      + // 348-394 Brancos
     Poem_Zeros(ARemessa.Count + 1, 6);               // 395-400 N�mero sequencial de registro

    ARemessa.Add(UpperCase(LLinha));
  end;
end;

function TACBrBancoABCBrasil.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): string;
var
  CodOcorrencia: Integer;
begin
  Result := '';
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia), 0);

  case CodOcorrencia of
    01: Result := '01-T�tulo N�o Existe';
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    04: Result := '04-Transfer�ncia de Carteira/Entrada';
    05: Result := '05-Transfer�ncia de Carteira/Baixa';
    06: Result := '06-Liquida��o';
    07: Result := '07-Confirma��o do Recebimento da Instru��o de Desconto';
    08: Result := '08-Confirma��o do Recebimento do Cancelamento do Desconto';
    09: Result := '09-Baixa';
    11: Result := '11-T�tulos em Carteira (Em Ser)';
    12: Result := '12-Confirma��o Recebimento Instru��o de Abatimento';
    13: Result := '13-Confirma��o Recebimento Instru��o de Cancelamento Abatimento';
    14: Result := '14-Confirma��o Recebimento Instru��o Altera��o de Vencimento';
    17: Result := '17-Liquida��o Ap�s Baixa ou Liquida��o T�tulo N�o Registrado';
    19: Result := '19-Confirma��o Recebimento Instru��o de Protesto';
    20: Result := '20-Confirma��o Recebimento Instru��o de Susta��o/Cancelamento de Protesto';
    23: Result := '23-Remessa a Cart�rio (Aponte em Cart�rio)';
    24: Result := '24-Retirada de Cart�rio e Manuten��o em Carteira';
    25: Result := '25-Protestado e Baixado (Baixa por Ter Sido Protestado)';
    26: Result := '26-Instru��o Rejeitada';
    27: Result := '27-Confirma��o do Pedido de Altera��o de Outros Dados';
    28: Result := '28-D�bito de Tarifas/Custas';
    29: Result := '29-Ocorr�ncias do Sacado';
    30: Result := '30-Altera��o de Dados Rejeitada';
    53: Result := '53-T�tulo DDA recusado pela CIP';
    94: Result := '94-Confirma Recebimento de Instru��o de Sustar e Alterar Vencimento';
    95: Result := '95-Confirma Recebimento de Instru��o de Altera��o do �Campo Livre�';
    96: Result := '96-Confirma Recebimento de Instru��o de Altera��o do �Seu N�mero�';
    97: Result := '97-Confirma Recebimento de Instru��o de Agendamento de Devolu��o';
    98: Result := '98-Confirma Recebimento de Instru��o de Altera��o de Mora';
    99: Result := '99-Confirma Recebimento de Instru��o de Altera��o de Multa';
  end;

  Result := ACBrSTr(Result);
end;

function TACBrBancoABCBrasil.CodOcorrenciaToTipo(const CodOcorrencia:
  Integer): TACBrTipoOcorrencia;
begin
  // DONE -oJacinto Junior: Ajustar para utilizar as ocorr�ncias corretas.
  Result := toTipoOcorrenciaNenhum;

  { Atribuindo Ocorr�ncias diverg�ntes entre CNAB240 e CNAB400 }
  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case CodOcorrencia of
      17: Result := toRetornoLiquidadoAposBaixaOuNaoRegistro;
      24: Result := toRetornoRetiradoDeCartorio;
      25: Result := toRetornoBaixaPorProtesto;
      26: Result := toRetornoInstrucaoRejeitada;
      35: Result := toRetornoTituloDDAReconhecidoPagador;
      36: Result := toRetornoTituloDDANaoReconhecidoPagador;
      37: Result := toRetornoTituloDDARecusadoCIP;
    end;
  end
  else
  begin
    case CodOcorrencia of
      17: Result := toRetornoLiquidadoEmCartorio;
      24: Result := toRetornoCustasCartorio;
      25: Result := toRetornoRecebimentoInstrucaoProtestar;
      26: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
      51: Result := toRetornoTituloDDAReconhecidoPagador;
      52: Result := toRetornoTituloDDANaoReconhecidoPagador;
      53: Result := toRetornoTituloDDARecusadoCIP;
    end;
  end;

  if (Result <> toTipoOcorrenciaNenhum) then
    Exit;

  case CodOcorrencia of
    01: Result := toRetornoTituloNaoExiste;
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    04: Result := toRetornoTransferenciaCarteiraEntrada;
    05: Result := toRetornoTransferenciaCarteiraBaixa;
    06: Result := toRetornoLiquidado;
    07: Result := toRetornoRecebimentoInstrucaoConcederDesconto;
    08: Result := toRetornoRecebimentoInstrucaoCancelarDesconto;
    09: Result := toRetornoBaixaAutomatica;
    10: Result := toRetornoBaixadoInstAgencia;
    11: Result := toRetornoTituloEmSer;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoProtestado;
    16: Result := toRetornoTituloJaBaixado;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    21: Result := toRetornoEncaminhadoACartorio;
    22: Result := toRetornoRetiradoDeCartorio;
    23: Result := toRetornoEntradaEmCartorio;
    27: Result := toRetornoAlteracaoUsoCedente;
    28: Result := toRetornoDebitoTarifas;
    29: Result := toRetornoOcorrenciasDoSacado;
    30: Result := toRetornoAlteracaoDadosRejeitados;
    53: Result := toRetornoTituloDDARecusadoCIP;
    94: Result := toRemessaAlterarVencSustarProtesto;
    //95: Result := toRetornoAlterarCampoLivre;
    96: Result := toRemessaAlterarSeuNumero;
    //97: Result := toRetornoAgendamentoDevolucao;
    98: Result := toRetornoConfirmacaoAlteracaoJurosMora;
    //99: Result := toRetornoConfirmacaoAlteracaoMulta;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoABCBrasil.TipoOcorrenciaToCod(
  const TipoOcorrencia: TACBrTipoOcorrencia): string;
begin
  Result := '';

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case TipoOcorrencia of
      toRetornoLiquidadoAposBaixaOuNaoRegistro: Result := '17';
      toRetornoRetiradoDeCartorio: Result              := '24';
      toRetornoBaixaPorProtesto: Result                := '25';
      toRetornoInstrucaoRejeitada: Result              := '26';
    end;
  end
  else
  begin
    case TipoOcorrencia of
      toRetornoLiquidadoEmCartorio: Result                := '17';
      toRetornoCustasCartorio: Result                     := '24';
      toRetornoRecebimentoInstrucaoProtestar: Result      := '25';
      toRetornoRecebimentoInstrucaoSustarProtesto: Result := '26';
    end;
  end;

  if (Result <> '') then
    Exit;

  case TipoOcorrencia of
    toRetornoTituloNaoExiste: Result := '01';
    toRetornoRegistroConfirmado: Result := '02';
    toRetornoRegistroRecusado: Result := '03';
    toRetornoTransferenciaCarteiraEntrada: Result := '04';
    toRetornoTransferenciaCarteiraBaixa: Result := '05';
    toRetornoLiquidado: Result := '06';
    toRetornoRecebimentoInstrucaoConcederDesconto: Result := '07';
    toRetornoRecebimentoInstrucaoCancelarDesconto: Result := '08';
    toRetornoBaixaAutomatica: Result := '09';
    toRetornoTituloEmSer: Result := '11';
    toRetornoAbatimentoConcedido: Result := '12';
    toRetornoAbatimentoCancelado: Result := '13';
    toRetornoVencimentoAlterado: Result := '14';
    toRetornoRecebimentoInstrucaoProtestar: Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto: Result := '20';
    toRetornoEntradaEmCartorio: Result := '23';
    toRetornoAlteracaoUsoCedente: Result := '27';
    toRetornoDebitoTarifas: Result := '28';
    toRetornoOcorrenciasDoSacado: Result := '29';
    toRetornoAlteracaoDadosRejeitados: Result := '30';
    toRetornoTituloDDARecusadoCIP: Result := '53';
    toRemessaAlterarVencSustarProtesto: Result := '94';
    //toRetornoAlterarCampoLivre                               : Result := '95';
    toRemessaAlterarSeuNumero: Result := '96';
    //toRetornoAgendamentoDevolucao                            : Result := '97';
    toRetornoConfirmacaoAlteracaoJurosMora: Result := '98';
    //toRetornoConfirmacaoAlteracaoMulta                       : Result := '99';

  else
    raise Exception.Create('Tipo de Ocorr�ncia de Retorno n�o suportada!');
  end;
end;

function TACBrBancoABCBrasil.CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; const CodMotivo: String): string;
var
  vlCodOcorrencia: string;
begin
  vlCodOcorrencia := TipoOcorrenciaToCod(TipoOcorrencia);

  if (vlCodOcorrencia = '02') or    //Entrada Confirmada
    (vlCodOcorrencia = '03') or     //Entrada Rejeitada
    (vlCodOcorrencia = '26') or     //Instru��o Rejeitada
    (vlCodOcorrencia = '30') then   //Altera��o de Dados Rejeitada
  begin
    if CodMotivo = '01' then
      Result := 'BANCO INV�LIDO'
    else if CodMotivo = '02' then
      Result := 'C�DIGO DO REGISTRO DETALHE INV�LIDO'
    else if CodMotivo = '03' then
      Result := 'C�DIGO DO SEGMENTO INV�LIDO'
    else if codMotivo = '04' then
      result := 'C�DIGO DO MOVIMENTO NAO PERMITIDO PARA CARTEIRA'
    else if codMotivo = '05' then
      result := 'C�DIGO DE MOVIMENTO INV�LIDO'
    else if codMotivo = '06' then
      result := 'TIPO/N�MERO DE INSCRI��O DO CEDENTE INV�LIDO'
    else if codMotivo = '07' then
      result := 'AG�NCIA/CONTA/DV INV�LIDO'
    else if codMotivo = '08' then
      result := 'NOSSO N�MERO INV�LIDO/DV INV�LIDO'
    else if codMotivo = '09' then
      result := 'NOSSO N�MERO DUPLICADO'
    else if codMotivo = '10' then
      result := 'CARTEIRA INV�LIDA'
    else if codMotivo = '11' then
      result := 'FORMA DE CADASTRAMENTO DO T�TULO INV�LIDA'
    else if codMotivo = '12' then
      result := 'TIPO DE DOCUMENTO INV�LIDO'
    else if codMotivo = '13' then
      result := 'IDENTIFICA��O DA EMISS�O DO BLOQUETO INV�LIDA'
    else if codMotivo = '14' then
      result := 'IDENTIFICA��O DA DISTRIBUI��O DO BLOQUETO INV�LIDA'
    else if codMotivo = '15' then
      result := 'CARACTER�STICAS DA COBRAN�A INCOMPAT�VEIS'
    else if codMotivo = '16' then
      result := 'DATA DE VENCIMENTO INV�LIDA OU IGUAL A ATUAL'
    else if codMotivo = '17' then
      result := 'DATA DE VENCIMENTO INV�LIDA'
    else if codMotivo = '18' then
      result := 'VENCIMENTO FORA DO PRAZO DE OPERA��O'
    else if codMotivo = '19' then
      result := 'T�TULO A CARGO DE BANCOS E VENCTO < XX DIAS'
    else if codMotivo = '20' then
      result := 'VALOR DO T�TULO INV�LIDO'
    else if codMotivo = '21' then
      result := 'ESP�CIE DO T�TULO INV�LIDA'
    else if codMotivo = '22' then
      result := 'ESP�CIE NAO PERMITIDA PARA A CARTEIRA'
    else if codMotivo = '23' then
      result := 'ACEITE INV�LIDO'
    else if codMotivo = '24' then
      result := 'DATA DE EMISS�O INV�LIDA'
    else if codMotivo = '25' then
      result := 'DATA DE EMISS�O POSTERIOR A DATA DE ENTRADA'
    else if codMotivo = '26' then
      result := 'C�DIGO DE JUROS DE MORA INV�LIDO'
    else if codMotivo = '27' then
      result := 'VALOR/TAXA DE JUROS DE MORA INV�LIDO'
    else if codMotivo = '28' then
      result := 'C�DIGO DO DESCONTO INV�LIDO'
    else if codMotivo = '29' then
      result := 'VALOR DESCONTO MAIOR OU IGUAL AO VALOR DO T�TULO'
    else if codMotivo = '30' then
      result := 'DESCONTO A CONCEDER N�O CONFERE'
    else if codMotivo = '31' then
      result := 'CONCESS�O DE DESCONTO - J� EXISTE DESCTO ANTERIOR'
    else if codMotivo = '32' then
      result := 'VALOR DE IOF INV�LIDO'
    else if codMotivo = '33' then
      result := 'VALOR DE ABATIMENTO INV�LIDO'
    else if codMotivo = '34' then
      result := 'VALOR DE ABTO MAIOR OU IGUAL AO VALOR DO T�TULO'
    else if codMotivo = '35' then
      result := 'ABATIMENTO A CONCEDER N�O CONFERE'
    else if codMotivo = '36' then
      result := 'CONCESS�O DE ABTO - J� EXISTE ABTO ANTERIOR'
    else if codMotivo = '37' then
      result := 'C�DIGO PARA PROTESTO INV�LIDO'
    else if codMotivo = '38' then
      result := 'PRAZO PARA PROTESTO INV�LIDO'
    else if codMotivo = '39' then
      result := 'PEDIDO DE PROTESTO N�O PERMITIDO PARA O T�TULO'
    else if codMotivo = '40' then
      result := 'T�TULO COM ORDEM DE PROTESTO EMITIDA'
    else if codMotivo = '41' then
      result := 'PEDIDO DE CANCEL/SUSTA��O  P/ T�TULO SEM INSTRU��O'
    else if codMotivo = '42' then
      result := 'C�DIGO PARA BAIXA/DEVOLU��O INV�LIDO'
    else if codMotivo = '43' then
      result := 'PRAZO PARA BAIXA/DEVOLU��O INV�LIDO'
    else if codMotivo = '44' then
      result := 'C�DIGO DA MOEDA INV�LIDO'
    else if codMotivo = '45' then
      result := 'NOME DO SACADO N�O INFORMADO'
    else if codMotivo = '46' then
      result := 'TIPO/N�MERO DE INSCRI��O DO SACADO INV�LIDOS'
    else if codMotivo = '47' then
      result := 'ENDERE�O DO SACADO N�O INFORMADO (TODO BRANCO)'
    else if codMotivo = '48' then
      result := 'CEP INV�LIDO'
    else if codMotivo = '49' then
      result := 'CEP SEM PRA�A DE COBRAN�A (N�O LOCALIZADO)'
    else if codMotivo = '50' then
      result := 'CEP REFERENTE A UM BANCO CORRESPONDENTE'
    else if codMotivo = '51' then
      result := 'CEP INCOMPAT�VEL COM A UNIDADE DA FEDERA��O'
    else if codMotivo = '52' then
      result := 'UNIDADE DA FEDERA��O INV�LIDA'
    else if codMotivo = '53' then
      result := 'TIPO/N�MERO DE INSCRI��O SACADOR/AVALISTA INV�LIDO'
    else if codMotivo = '54' then
      result := 'SACADOR/AVALISTA N�O INFORMADO'
    else if codMotivo = '55' then
      result := 'NOSSO N�MERO NO BANCO CORRESPONDENTE N�O INFORMADO'
    else if codMotivo = '56' then
      result := 'C�DIGO DO BANCO CORRESPONDENTE INV�LIDO'
    else if codMotivo = '57' then
      result := 'C�DIGO DA MULTA INV�LIDO'
    else if codMotivo = '58' then
      result := 'DATA DA MULTA INV�LIDA'
    else if codMotivo = '59' then
      result := 'VALOR/PERCENTUAL DA MULTA INV�LIDO'
    else if codMotivo = '60' then
      result := 'MOVIMENTO PARA T�TULO N�O CADASTRADO'
    else if codMotivo = '61' then
      result := 'ALTERA��O DA AG�NCIA COBRADORA/DV INV�LIDA'
    else if codMotivo = '62' then
      result := 'TIPO DE IMPRESS�O INV�LIDO'
    else if codMotivo = '63' then
      result := 'ENTRADA PARA T�TULO J� CADASTRADO'
    else if codMotivo = '64' then
      result := 'N�MERO DA LINHA INV�LIDO'
    else if codMotivo = '65' then
      result := 'C�DIGO DO BANCO PARA D�BITO INV�LIDO'
    else if codMotivo = '66' then
      result := 'AG�NCIA/CONTA/DV PARA D�BITO INV�LIDO'
    else if codMotivo = '67' then
      result := 'DADOS D�B. INCOMPAT�VEL COM A IDENT. EMIS. BLOQ.'
    else if codMotivo = '68' then
      result := 'D�BITO AUTOM�TICO AGENDADO'
    else if codMotivo = '69' then
      result := 'D�BITO N�O AGENDADO - ERRO NOS DADOS DA REMESSA'
    else if codMotivo = '70' then
      result := 'D�BITO N�O AGEND.- SAC N�O CONSTA CAD. AUTORIZANTE'
    else if codMotivo = '71' then
      result := 'D�BITO N�O AGEND.- CEDENTE N�O AUTORIZ PELO SACADO'
    else if codMotivo = '72' then
      result := 'D�BITO N�O AGEND.-CED. N�O PARTIC. MODAL. DEB. AUT'
    else if codMotivo = '73' then
      result := 'D�BITO N�O AGEND.- C�D. MOEDA DIFERENTE DE REAL'
    else if codMotivo = '74' then
      result := 'D�BITO N�O AGENDADO - DATA VENCIMENTO INV�LIDA'
    else if codMotivo = '75' then
      result := 'D�BITO N�O AGEND., CONF. SEU PED., TIT. N�O REGIST'
    else if codMotivo = '76' then
      result := 'D�BITO N�O AGEND., TIPO/NUM. INSCR. DEBITADO INV�L'
    else if codMotivo = '78' then
      result := 'DATA INF. OU IGUAL AO VENC. PARA D�BITO AUTOMATICO'
    else if codMotivo = '79' then
      result := 'DATA JUROS DE MORA INV�LIDO'
    else if codMotivo = '80' then
      result := 'DATA DESCONTO INV�LIDA'
    else if codMotivo = '81' then
      result := 'TENTATIVAS DE D�BITO ESGOTADAS - BAIXADO'
    else if codMotivo = '82' then
      result := 'TENTATIVAS DE D�BITO ESGOTADAS - PENDENTE'
    else if codMotivo = '83' then
      result := 'LIMITE EXCEDIDO'
    else if codMotivo = '84' then
      result := 'N�MERO AUTORIZA��O INEXISTENTE'
    else if codMotivo = '85' then
      result := 'T�TULO COM PAGAMENTO VINCULADO'
    else if codMotivo = '86' then
      result := 'SEU N�MERO INV�LIDO (TODO BRANCO)'
    else if codMotivo = '87' then
      result := 'EXCEDE PRAZO M�XIMO ENTRE EMISS�O E VENCTO'
    else if codMotivo = 'AA' then
      result := 'SERVI�O DE COBRAN�A INV�LIDO'
    else if codMotivo = 'AB' then
      result := 'SERVI�O DE "0" OU "5" E BANCO COBRADOR <> ZEROS'
    else if codMotivo = 'AC' then
      result := 'VALOR. DESC + VALOR. ABTO. > VALOR. TITULO'
    else if codMotivo = 'AD' then
      result := 'T�TULO PAGO OU BAIXADO OU PROTESTADO'
    else if codMotivo = 'AE' then
      result := 'T�TULO N�O POSSUI ABATIMENTO'
    else if codMotivo = 'AF' then
      result := 'MOVIMENTO N�O PERMITIDO P/ A CARTEIRA DE DESCONTO'
    else if codMotivo = 'AG' then
      result := 'MOV. N�O PERMITIDO P/ TIT. A VISTA/CONTRA APRES.'
    else if codMotivo = 'AH' then
      result := 'CANCELAMENTO DE VALORES INV�LIDOS'
    else if codMotivo = 'AI' then
      result := 'NOSSA CARTEIRA INV�LIDA'
    else if codMotivo = 'AJ' then
      result := 'MODALIDADE COM BANCOS CORRESPONDENTES INV�LIDA'
    else if codMotivo = 'AK' then
      result := 'T�TULO PERTENCE A OUTRO CLIENTE'
    else if codMotivo = 'AL' then
      result := 'SACADO IMPEDIDO DE ENTRAR'
    else if codMotivo = 'AM' then
      result := 'SACADO ISENTO DE PROTESTO E TENTATIVA DE PROTESTO'
    else if codMotivo = 'AN' then
      result := 'SACADO INV�LIDO, ACEITO COM RESTRI��ES'
    else if codMotivo = 'AO' then
      result := 'NOSSO N�MERO BANCOS FORA DA FAIXA OU N�O INFORMADO'
    else if codMotivo = 'AP' then
      result := 'T�TULO DEVE ESTAR EM ABERTO SEM PROTESTO EFETIVADO'
    else if codMotivo = 'AQ' then
      result := 'ENTRADA REJEITADA. REPRESAMENTO REPROVADO'
    else if codMotivo = 'AR' then
      result := 'INSTRU��O REJEITADA. REPRESAMENTO REPROVADO'
    else if codMotivo = 'AS' then
      result := 'NOSSO N�MERO FORA DA FAIXA CEDIDA AO CLIENTE'
    else if codMotivo = 'AU' then
      result := 'DATA DA OCORR�NCIA INV�LIDA'
    else if codMotivo = 'AV' then
      result := 'VALOR DA TARIFA DE COBRAN�A INV�LIDA'
    else if codMotivo = 'AX' then
      result := 'T�TULO EM PAGAMENTO PARCIAL'
    else if codMotivo = 'AY' then
      result := 'T�TULO EM ABERTO E VENCIDO PARA ACATAR PROTESTO'
    else if codMotivo = 'AZ' then
      result := 'SEU N�MERO DUPLICADO'
    else if codMotivo = 'BC' then
      result := 'AN�LISE GERENCIAL-SACADO INV�LIDO P/OPERA��O CRED.'
    else if codMotivo = 'BD' then
      result := 'AN�LISE GERENCIAL-SACADO INADIMPLENTE.'
    else if codMotivo = 'BE' then
      result := 'AN�LISE GERENCIAL-SACADO DIFERE DO EXIGIDO'
    else if codMotivo = 'BF' then
      result := 'AN�LISE GERENCIAL-VENCTO EXCEDE VENCTO DA OPCRED'
    else if codMotivo = 'BG' then
      result := 'AN�LISE GERENCIAL-SACADO COM BAIXA LIQUIDEZ'
    else if codMotivo = 'BH' then
      result := 'AN�LISE GERENCIAL-SACADO EXCEDE CONCENTRA��O'
    else if codMotivo = 'BI' then
      result := 'N�O FOI POSS�VEL O REPASSE DE TARIFAS'
    else if codMotivo = 'CB' then
      result := 'T�TULO POSSUI PROTESTO EFETIVADO/A EFETIVAR HOJE'
    else if codMotivo = 'CC' then
      result := 'VALOR DE IOF INCOMPAT�VEL COM A ESP�CIE DOCUMENTO'
    else if codMotivo = 'CD' then
      result := 'EFETIVA��O DE PROTESTO SEM AGENDA V�LIDA'
    else if codMotivo = 'CE' then
      result := 'T�TULO N�O ACEITO - PESSOA F�SICA'
    else if codMotivo = 'CF' then
      result := 'EXCEDE PRAZO MAX DA ENTRADA AO VENCIMENTO'
    else if codMotivo = 'CG' then
      result := 'T�TULO N�O ACEITO - POR AN�LISE GERENCIAL'
    else if codMotivo = 'CH' then
      result := 'T�TULO EM ESPERA - EM AN�LISE PELO BANCO'
    else if codMotivo = 'CJ' then
      result := 'AN�LISE GERENCIAL-VENCTO DO TITULO ABAIXO PRZCURTO'
    else if codMotivo = 'CK' then
      result := 'AN�LISE GERENCIAL-VENCTO DO TITULO ACIMA PRZLONGO'
    else if codMotivo = 'CL' then
      result := 'C�DIGO DA TARIFA INV�LIDO PARA O PRODUTO'
    else if codMotivo = 'CM' then
      result := 'C�DIGO DA TARIFA N�O CONCORDA COM O VALOR INFORMADO'
    else if codMotivo = 'CN' then
      result := 'VALOR DA TARIFA INV�LIDO'
    else if codMotivo = 'CO' then
      result := 'VALOR DA TARIFA � MAIOR OU IGUAL AO VALOR NOMINAL.'
    else if codMotivo = 'CS' then
      result := 'TITULO REJEITADO PELA CHECAGEM DE DUPLICATAS'
    else if codMotivo = 'CT' then
      result := 'T�TULO J� BAIXADO'
    else if codMotivo = 'CW' then
      result := 'T�TULO J� TRANSFERIDO'
    else if codMotivo = 'DA' then
      result := 'AN�LISE GERENCIAL - TD COM LIMITE CANCELADO'
    else if codMotivo = 'DB' then
      result := 'AN�LISE GERENCIAL - TD COM LIMITE VENCIDO'
    else if codMotivo = 'DC' then
      result := 'AN�LISE GERENCIAL - CEDENTE COM LIMITE CANCELADO'
    else if codMotivo = 'DD' then
      result := 'AN�LISE GERENCIAL - CED-SAC COM LIMITE CANCELADO'
    else if codMotivo = 'DE' then
      result := 'AN�LISE GERENCIAL - APONTAMENTO NO SERASA'
    else if codMotivo = 'DF' then
      result := 'SACADO N�O PODE SER PROCESSADO PARCIALMENTE'
    else if codMotivo = 'DG' then
      result := 'ENDERE�O SACADOR/AVALISTA N�O INFORMADO'
    else if codMotivo = 'DH' then
      result := 'CEP DO SACADOR/AVALISTA N�O INFORMADO'
    else if codMotivo = 'DI' then
      result := 'CIDADE DO SACADOR/AVALISTA N�O INFORMADO'
    else if codMotivo = 'DJ' then
      result := 'ESTADO DO SACADOR/AVALISTA INV�LIDO OU N INFORMADO'
    else if codMotivo = 'DM' then
      result := 'CLIENTE SEM C�DIGO DE FLASH CADASTRADO NO COBRADOR'
    else if codMotivo = 'DN' then
      result := 'T�TULO DESCONTADO COM PRAZO ZERO- RECUSADO'
    else if codMotivo = 'DO' then
      result := 'T�TULO EM PREJU�ZO'
    else if codMotivo = 'DP' then
      result := 'DATA DEREFER�NCIA MENOR QUE DATA DE EMISS�O DO T�TULO'
    else if codMotivo = 'DT' then
      result := 'NOSSO NUMERO DO CORRESP N�O DEVE SER INFORMADO'
    else if codMotivo = 'EB' then
      result := 'HSBC N�O ACEITA ENDERE�O SACADO COM MAIS DE 38 CARACTERES'
    else if codMotivo = 'G1' then
      result := 'ENDERE�O DO SACADOR INCOMPLETO ( LEI 12.039)'
    else if codMotivo = 'G2' then
      result := 'SACADOR IMPEDIDO DE MOVIMENTAR'
    else if codMotivo = 'G3' then
      result := 'CONCENTRA��O DE CEP N�O PERMITIDA'
    else if codMotivo = 'G4' then
      result := 'VALOR DO T�TULO N�O PERMITIDO'
    else if codMotivo = 'HA' then
      result := 'SERVI�O E MODALIDADE INCOMPAT�VEIS'
    else if codMotivo = 'HB' then
      result := 'INCONSIST�NCIAS ENTRE REGISTROS T�TULO E SACADOR'
    else if codMotivo = 'HC' then
      result := 'OCORR�NCIA N�O DISPON�VEL'
    else if codMotivo = 'HD' then
      result := 'T�TULO COM ACEITE';
  end
  else if vlCodOcorrencia = '28' then
  begin
    if codMotivo = '01' then
      result := 'Tarifa de Extrato de Posi��o'
    else if codMotivo = '02' then
      result := 'Tarifa de Manuten��o de T�tulo Vencido'
    else if codMotivo = '03' then
      result := 'Tarifa de Susta��o'
    else if codMotivo = '04' then
      result := 'Tarifa de Protesto'
    else if codMotivo = '05' then
      result := 'Tarifa de Outras Instru��es'
    else if codMotivo = '06' then
      result := 'Tarifa de Outras Ocorr�ncias'
    else if codMotivo = '07' then
      result := 'Tarifa de Envio de Duplicata ao Sacado'
    else if codMotivo = '08' then
      result := 'Custas de Protesto'
    else if codMotivo = '09' then
      result := 'Custas de Susta��o de Protesto'
    else if codMotivo = '10' then
      result := 'Custas de Cart�rio Distribuidor'
    else if codMotivo = '11' then
      result := 'Custas de Edital'
    else if codMotivo = '12' then
      result := 'Tarifa Sobre Devolu��o de T�tulo Vencido'
    else if codMotivo = '13' then
      result := 'Tarifa Sobre Registro Cobrada na Baixa/Liquida��o'
    else if codMotivo = '16' then
      result := 'Tarifa Sobre Informa��es Via Fax'
    else if codMotivo = '17' then
      result := 'Tarifa Sobre Prorroga��o de Vencimento'
    else if codMotivo = '18' then
      result := 'Tarifa Sobre Altera��o de Abatimento/Desconto'
    else if codMotivo = '19' then
      result := 'Tarifa Sobre Arquivo mensal (Em Ser)'
    else if codMotivo = '20' then
      result := 'Tarifa Sobre Emiss�o de Bloqueto Pr�-Emitido pelo Banco'
    else if codMotivo = '96' then
      result := 'Tarifa Sobre Instru��es � M�s anterior'
    else if codMotivo = '97' then
      result := 'Tarifa Sobre Baixas � M�s anterior'
    else if codMotivo = '98' then
      result := 'Tarifa Sobre Entradas � M�s anterior'
    else if codMotivo = '99' then
      result := 'Tarifa Sobre Instru��es de Protesto/Susta��o � M�s anterior';
  end
  else if (vlCodOcorrencia = '06') or
    (vlCodOcorrencia = '09') or
    (vlCodOcorrencia = '17') then
  begin
    if codMotivo = '01' then
      result := 'Por Saldo'
    else if codMotivo = '02' then
      result := 'Por Conta'
    else if codMotivo = '03' then
      result := 'No Pr�prio Banco'
    else if codMotivo = '04' then
      result := 'Compensa��o Eletr�nica'
    else if codMotivo = '05' then
      result := 'Compensa��o Convencional'
    else if codMotivo = '06' then
      result := 'Por Meio Eletr�nico'
    else if codMotivo = '07' then
      result := 'Ap�s Feriado Local'
    else if codMotivo = '08' then
      result := 'Em Cart�rio'
    else if codMotivo = '09' then
      result := 'Comandada Banco'
    else if codMotivo = '10' then
      result := 'Comandada Cliente Arquivo'
    else if codMotivo = '11' then
      result := 'Comandada Cliente On-line'
    else if codMotivo = '12' then
      result := 'Decurso Prazo - Cliente'
    else if codMotivo = '13' then
      result := 'Decurso Prazo - Banco'
    else if codMotivo = '14' then
      result := 'Protestado'
    else if codMotivo = '15' then
      result := 'T�tulo Exclu�do';
  end
  else
    Result := CodMotivo + ' - Outros Motivos';

  Result := ACBrSTr(Result);
end;

end.

