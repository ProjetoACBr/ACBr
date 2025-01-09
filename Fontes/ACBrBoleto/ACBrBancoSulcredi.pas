{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   Juliana Rodrigues Prado                       }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrBancoSulcredi;

interface

uses
  Classes,
  SysUtils,
  ACBrBoleto,
  ACBrBoletoConversao,
  ACBrValidador,
  Contnrs;

type

  { TACBrBancoSulcredi }

  TACBrBancoSulcredi = class(TACBrBancoClass)
  private
  protected
  public
    constructor Create(AOwner: TACBrBanco);
    function CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): String; override;
    function MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;
    function MontarCampoNossoNumero(const ACBrTitulo:TACBrTitulo): String; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String; override;
    function GerarRegistroHeader240(NumeroRemessa: Integer): String; override;
    function GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String; override;
    function GerarRegistroTrailler240(ARemessa: TStringList): String; override;
    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
    function TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    function TipoOCorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): String; override;
    function DefineTipoCarteira(const ACBrTitulo: TACBrTitulo): String;
    function CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    procedure LerRetorno240(ARetorno: TStringList); override;
  end;

implementation

uses
  {$IFDEF COMPILER6_UP} DateUtils {$ELSE} ACBrD5 {$ENDIF},
  StrUtils,
  ACBrUtil;

{ TACBrBancoSulcredi }

constructor TACBrBancoSulcredi.Create(AOwner: TACBrBanco);
begin
   inherited Create(AOwner);
   fpDigito := 0;
   fpNome := 'SULCREDI';
   fpNumero := 322;
   fpTamanhoMaximoNossoNum := 11;
   fpTamanhoAgencia := 4; 
   fpTamanhoConta := 5; 
   fpTamanhoCarteira := 2;
   fpDensidadeGravacao := '';
   fpLayoutVersaoArquivo := 103;
   fpLayoutVersaoLote := 060;
   fpQtdRegsLote := 0;
   fpQtdRegsCobranca := 0;
   fpVlrRegsCobranca := 0;
end;

function TACBrBancoSulcredi.DefineTipoCarteira(const ACBrTitulo: TACBrTitulo): String;
begin
  with ACBrTitulo do
  begin
    case ACBrBoleto.Cedente.TipoCarteira of
      tctSimples: Result := '2';
      tctRegistrada: Result := '1';
    else
      Result := '1';
    end;
  end;
end;

function TACBrBancoSulcredi.CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): String;
var
  LDocumento: String;

begin
  LDocumento := PadLeft(Trim(ACBrTitulo.ACBrBoleto.Cedente.Convenio), 7, '0') {Conv�nio: n�mero do conv�nio de cobran�a com sete d�gitos}
    + '9'                                                                     {Origem: deve ser sempre 9, representa que o boleto foi gerado via arquivo CNAB}
    + PadLeft(ACBrTitulo.NossoNumero, fpTamanhoMaximoNossoNum, '0');          {NumeroSequencial: numero sequ�ncia do t�tulo dentro do conv�nio}

  //Digito: C�lculo em Mod10 das posi��es: {convenio}{origem}{numeroSequencial}
  Modulo.FormulaDigito := frModulo10;
  Modulo.MultiplicadorFinal := 1;
  Modulo.MultiplicadorInicial := 2;
  Modulo.Documento := LDocumento;
  Modulo.Calcular;

  Result := IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoSulcredi.MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): String;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras, CampoLivre: String;

begin
  with ACBrTitulo.ACBrBoleto do
  begin
    FatorVencimento := CalcularFatorVencimento(ACBrTitulo.Vencimento);

    CampoLivre := '01' + PadLeft(RemoveString('-', MontarCampoNossoNumero(ACBrTitulo)), 23, '0');

    CodigoBarras := IntToStr(Numero) + '9' + FatorVencimento +
                    IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10) +
                    CampoLivre;

    DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);
  end;

  Result:= IntToStr(Numero) + '9' + DigitoCodBarras + Copy(CodigoBarras, 5, 39);
end;

function TACBrBancoSulcredi.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): String;
begin
  Result := PadLeft(Trim(ACBrTitulo.ACBrBoleto.Cedente.Convenio), 7, '0') +
            '9' +
            PadLeft(ACBrTitulo.NossoNumero, fpTamanhoMaximoNossoNum, '0') +
            '-' +
            CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoSulcredi.MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String;
begin
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia + '/' + ACBrTitulo.ACBrBoleto.Cedente.Conta;
end;

function TACBrBancoSulcredi.GerarRegistroHeader240(NumeroRemessa: Integer): String;
var
  ListHeader: TStringList;

begin
  Result := '';

  ListHeader:= TStringList.Create;
  try
    with ACBrBanco.ACBrBoleto.Cedente do
    begin
      { REGISTRO-HEADER DO ARQUIVO }

      ListHeader.Add(
        IntToStrZero(fpNumero, 3)                                         + // C�digo do Banco na Compensa��o
        '0000'                                                            + // Lote de Servi�o
        '0'                                                               + // Tipo de Registro
        Space(9)                                                          + // Uso Exclusivo FEBRABAN / CNAB
        DefineTipoInscricao                                               + // Tipo de inscri��o da empresa
        PadLeft(Trim(OnlyNumber(CNPJCPF)), 14, '0')                       + // N�mero de inscri��o da empresa
        PadLeft(Convenio, 20, ' ')                                        + // C�digo do Conv�nio no Banco
        PadLeft(OnlyNumber(Agencia), 5, '0')                              + // Ag�ncia Mantenedora da Conta
        Space(1)                                                          + // D�gito Verificador da Ag�ncia: PadRight(AgenciaDigito, 1, ' ')
        PadLeft(OnlyNumber(Conta), 12, '0')                               + // N�mero da Conta Corrente
        PadRight(ContaDigito, 1, '0')                                     + // D�gito Verificador da Conta
        PadRight(DigitoVerificadorAgenciaConta, 1, ' ')                   + // D�gito Verificador da Ag/Conta
        PadRight(Nome, 30, ' ')                                           + // Nome da empresa
        PadRight(fpNome, 30, ' ')                                         + // Nome do banco
        Space(10)                                                         + // Uso Exclusivo FEBRABAN / CNAB
        '1'                                                               + // C�digo de Remessa (1) / Retorno (2)
        FormatDateTime('ddmmyyyy', Now)                                   + // Data de gera��o do arquivo
        FormatDateTime('hhmmss', Now)                                     + // Hora de gera��o do arquivo
        PadLeft(IntToStr(NumeroRemessa), 6, '0')                          + // N�mero seq�encial do arquivo
        PadLeft(IntToStr(fpLayoutVersaoArquivo), 3, '0')                  + // No da Vers�o do Layout do Arquivo
        PadLeft(fpDensidadeGravacao, 5, '0')                              + // Densidade de Grava��o do Arquivo
        Space(20)                                                         + // Para Uso Reservado do Banco
        Space(20)                                                         + // Para Uso Reservado da Empresa
        Space(29)                                                           // Uso Exclusivo FEBRABAN / CNAB
      );

      { REGISTRO HEADER DO LOTE }

      ListHeader.Add(
        IntToStrZero(fpNumero, 3)                                         + // C�digo do Banco na Compensa��o
        '0001'                                                            + // Lote de Servi�o
        '1'                                                               + // Tipo de Registro
        'R'                                                               + // Tipo de Opera��o
        '01'                                                              + // Tipo de Servi�o
        Space(2)                                                          + // Uso Exclusivo FEBRABAN / CNAB
        PadLeft(IntToStr(fpLayoutVersaoLote), 3, '0')                     + // N� da vers�o do layout do lote
        Space(1)                                                          + // Uso Exclusivo FEBRABAN / CNAB
        DefineTipoInscricao                                               + // Tipo de inscri��o da empresa
        PadLeft(Trim(OnlyNumber(CNPJCPF)), 15, '0')                       + // N�mero de inscri��o da empresa
        PadLeft(Convenio, 20, ' ')                                        + // C�digo do Conv�nio no Banco
        PadLeft(OnlyNumber(Agencia), 5, '0')                              + // Ag�ncia Mantenedora da Conta
        Space(1)                                                          + // D�gito Verificador da Ag�ncia: PadRight(AgenciaDigito, 1, ' ')
        PadLeft(OnlyNumber(Conta), 12, '0')                               + // N�mero da Conta Corrente
        PadRight(ContaDigito, 1, '0')                                     + // D�gito Verificador da Conta
        PadRight(DigitoVerificadorAgenciaConta, 1, ' ')                   + // D�gito Verificador da Ag/Conta
        PadRight(Nome, 30, ' ')                                           + // Nome da empresa
        Space(40)                                                         + // Mensagem 1
        Space(40)                                                         + // Mensagem 2
        PadLeft(IntToStr(NumeroRemessa), 8, '0')                          + // N�mero seq�encial do arquivo
        FormatDateTime('ddmmyyyy', Now)                                   + // Data de gera��o do arquivo
        IntToStrZero(0, 8)                                                + // Data do cr�dito
        Space(33)                                                           // Uso Exclusivo FEBRABAN / CNAB
      );
    end;

    Result := RemoverQuebraLinhaFinal(ListHeader.Text);

   finally
     ListHeader.Free;
   end;
end;

function TACBrBancoSulcredi.GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String;
var
  ListTransacao: TStringList;
  sCodMovimento: String;
  sNossoNumero: String;
  sTipoCobranca: String;
  sTipoCarteira: String;
  sTipoDocto: String;
  sEspecie: String;
  sTipoJuros: String;
  sDataMoraJuros: String;
  sValorMoraDia: String;
  sTipoDesconto: String;
  sDataDesconto: String;
  sCodigoProtesto: String;
  sDiasProtesto: String;
  sCodigoBaixa: String;
  sDiasBaixa: String;
  sTipoInscricao: String;
  sEndereco: String;
  aTipoInscricao: String;
  sCodMulta: String;
  sDataMulta: String;

begin
  with ACBrTitulo do
  begin
    {Tipo de Ocorrencia}
    sCodMovimento := TipoOcorrenciaToCodRemessa(ACBrTitulo.OcorrenciaOriginal.Tipo);

    {C�digo da Carteira}
    sTipoCobranca := DefineCaracTitulo(ACBrTitulo);

    {Tipo Carteira}
    sTipoCarteira:= DefineTipoCarteira(ACBrTitulo);

    {Tipo Documento}
    sTipoDocto:= DefineTipoDocumento;

    {Especie Documento}
    sEspecie := DefineEspecieDoc(ACBrTitulo);

    {C�digo Mora}
    sTipoJuros := DefineCodigoMoraJuros(ACBrTitulo);

    {Data Mora}
    if (TruncTo(ValorMoraJuros, fpCasasDecimaisMoraJuros) > 0) then
      sDataMoraJuros := DefineDataMoraJuros(ACBrTitulo)
    else
    begin
      sDataMoraJuros := PadLeft('', 8, '0');
      sTipoJuros := '3'; // Isento
    end;

    {Valor Mora Dia}
    if (sTipoJuros = '2') then
      sValorMoraDia := FormatarMoraJurosRemessa(15, ACBrTitulo)
    else
      sValorMoraDia := IntToStrZero(Round(ValorMoraJuros * 100), 15);

    {C�digo Desconto}
    sTipoDesconto := DefineCodigoDesconto(ACBrTitulo);

    {Data Desconto}
    sDataDesconto := DefineDataDesconto(ACBrTitulo);

    {C�digo e Dias Protesto}
    if (DataProtesto <> 0) and (DiasDeProtesto > 0) then
    begin
      sCodigoProtesto := DefineTipoDiasProtesto(ACBrTitulo);
      sDiasProtesto := PadLeft(IntToStr(DiasDeProtesto), 2, '0');
    end
    else
    begin
      sCodigoProtesto := '3';
      sDiasProtesto := '00';
    end;

    {C�digo e Dias Baixa}
    if (DataBaixa <> 0) and (DataBaixa > Vencimento) then
    begin
      sCodigoBaixa := '1';
      sDiasBaixa := PadLeft(IntToStr(DaysBetween(DataBaixa, Vencimento)), 3, '0');
    end
    else
    begin
      sCodigoBaixa := Space(1);
      sDiasBaixa := Space(3);
    end;

    {Tipo de Inscri��o}
    sTipoInscricao := Copy(DefineTipoSacado(ACBrTitulo), 2, 1);

    {Endereco do Sacado}
    sEndereco := PadRight(Sacado.Logradouro + ' ' + Sacado.Numero + ' ' + Sacado.Complemento , 40, ' ');

    {Tipo Inscri��o do Avalista}
    aTipoInscricao := DefineTipoSacadoAvalista(ACBrTitulo);

    {Nosso N�mero Completo: (convenio)(origem)(numeroSequencial)(dv) }
    sNossoNumero := RemoveString('-', MontarCampoNossoNumero(ACBrTitulo));

    {C�digo Multa}
    sCodMulta := DefineCodigoMulta(ACBrTitulo);

    {Data Multa}
    sDataMulta := DefineDataMulta(ACBrTitulo);

    Inc(fpQtdRegsLote);
    Inc(fpQtdRegsCobranca);
    VlrRegsCobranca := VlrRegsCobranca + ValorDocumento;

    ListTransacao := TStringList.Create;
    try
      {SEGMENTO P}

      ListTransacao.Add(
        IntToStrZero(fpNumero, 3)                                                 + // C�digo do Banco na Compensa��o
        '0001'                                                                    + // Lote de Servi�o
        '3'                                                                       + // Tipo de Registro
        IntToStrZero(fpQtdRegsLote, 5)                                            + // N� Sequencial do Registro no Lote
        'P'                                                                       + // C�d. Segmento do Registro Detalhe
        Space(1)                                                                  + // Uso Exclusivo FEBRABAN/CNAB
        sCodMovimento                                                             + // C�digo de Movimento Remessa
        PadLeft(OnlyNumber(ACBrBoleto.Cedente.Agencia), 5, '0')                   + // Ag�ncia mantenedora da conta
        Space(1)                                                                  + // Digito agencia: PadLeft(ACBrBoleto.Cedente.AgenciaDigito, 1, ' ')
        PadLeft(OnlyNumber(ACBrBoleto.Cedente.Conta), 12, '0')                    + // N�mero da Conta Corrente
        PadLeft(ACBrBoleto.Cedente.ContaDigito, 1, '0')                           + // D�gito da Conta Corrente
        PadLeft(ACBrBoleto.Cedente.DigitoVerificadorAgenciaConta, 1, ' ')         + // D�gito Verificador da Ag/Conta
        PadLeft(sNossoNumero, 20, '0')                                            + // Identifica��o do t�tulo no Banco (Nosso N�mero)
        sTipoCobranca                                                             + // C�digo da carteira
        sTipoCarteira                                                             + // Forma de Cadastramento = 1 Registrada / 2 Sem Registro
        sTipoDocto                                                                + // Tipo de documento
        '2'                                                                       + // Identifica��o da Emiss�o do Boleto de Pagamento / 2 Cliente Emite
        '2'                                                                       + // Identifica��o da Distribui��o / 2 Cliente distribui
        PadRight(Copy(NumeroDocumento, 1, 15), 15, ' ')                           + // N�mero do documento
        FormatDateTime('ddmmyyyy', Vencimento)                                    + // Data de vencimento do t�tulo
        IntToStrZero(Round(ValorDocumento * 100), 15)                             + // Valor nominal do t�tulo
        PadLeft('0', 5, '0')                                                      + // Ag�ncia encarregada da cobran�a
        '0'                                                                       + // D�gito da Ag�ncia encarregada da cobran�a
        sEspecie                                                                  + // Esp�cie do t�tulo
        IfThen(Aceite = atSim, 'A', 'N')                                          + // Identific. de T�tulo Aceito/N�o Aceito
        FormatDateTime('ddmmyyyy', DataDocumento)                                 + // Data da emiss�o do t�tulo
        sTipoJuros                                                                + // C�digo do juros de mora
        sDataMoraJuros                                                            + // Data do juros de mora
        sValorMoraDia                                                             + // Valor da mora/dia ou Taxa mensal
        sTipoDesconto                                                             + // C�digo do desconto 1
        sDataDesconto                                                             + // Data de desconto 1
        IntToStrZero(Round(ValorDesconto * 100), 15)                              + // Valor ou Percentual do desconto concedido
        IntToStrZero(Round(ValorIOF * 100), 15)                                   + // Valor do IOF a ser recolhido
        IntToStrZero(Round(ValorAbatimento * 100), 15)                            + // Valor do abatimento
        PadRight(SeuNumero, 25)                                                   + // Identifica��o do t�tulo na empresa
        sCodigoProtesto                                                           + // C�digo para protesto
        sDiasProtesto                                                             + // N�mero de dias para protesto
        sCodigoBaixa                                                              + // C�digo para Baixa/Devolu��o
        sDiasBaixa                                                                + // N�mero de dias para Baixa/Devolu��o
        '09'                                                                      + // C�digo da moeda
        IntToStrZero(0, 10)                                                       + // N� do Contrato da Opera��o de Cr�d.
        '1'                                                                         // Uso livre banco/empresa / 1 � N�o autoriza pagamento parcial 2 � Autoriza pagamentos parciais
      );

      Inc(fpQtdRegsLote);

      {SEGMENTO Q}

      ListTransacao.Add(
        IntToStrZero(fpNumero, 3)                                                 + // C�digo do Banco na Compensa��o
        '0001'                                                                    + // Lote de Servi�o
        '3'                                                                       + // Tipo de Registro
        IntToStrZero(fpQtdRegsLote, 5)                                            + // N� Sequencial do Registro no Lote
        'Q'                                                                       + // C�d. Segmento do Registro Detalhe
        Space(1)                                                                  + // Uso Exclusivo FEBRABAN/CNAB
        sCodMovimento                                                             + // C�digo de Movimento Remessa
        sTipoInscricao                                                            + // Tipo de inscri��o
        PadLeft(trim(OnlyNumber(Sacado.CNPJCPF)), 15, '0')                        + // N�mero de inscri��o do sacado
        PadRight(Trim(Sacado.NomeSacado), 40)                                     + // Nome sacado
        sEndereco                                                                 + // Endere�o sacado
        PadRight(Trim(Sacado.Bairro), 15)                                         + // Bairro sacado
        PadLeft(Copy(OnlyNumber(Sacado.CEP), 1, 5), 5, '0')                       + // Cep sacado
        PadLeft(Copy(OnlyNumber(Sacado.CEP), 6, 3), 3, '0')                       + // Sufixo do Cep do sacado
        PadRight(Trim(Sacado.Cidade), 15)                                         + // Cidade do sacado
        PadRight(Sacado.UF, 2)                                                    + // Unidade da federa��o do
        aTipoInscricao                                                            + // Tipo de inscri��o sacador/avalista
        PadLeft(Sacado.SacadoAvalista.CNPJCPF, 15, '0')                           + // N� de inscri��o sacador/avalista
        PadRight(Sacado.SacadoAvalista.NomeAvalista, 40, ' ')                     + // Nome do sacador/avalista
        PadRight('0', 3, '0')                                                     + // C�d. Bco. Corresp. na Compensa��o
        PadRight('', 20, ' ')                                                     + // Nosso N� no Banco Correspondente
        PadRight('', 8, ' '));                                                      // FEBRABAN/CNAB 233 240 8 - Alfa Brancos G004

      Inc(fpQtdRegsLote);

      {SEGMENTO R}

      ListTransacao.Add(
        IntToStrZero(fpNumero, 3)                                                 + // C�digo do Banco na Compensa��o
        '0001'                                                                    + // Lote de Servi�o
        '3'                                                                       + // Tipo de Registro
        IntToStrZero(fpQtdRegsLote, 5)                                            + // N� Sequencial do Registro no Lote
        'R'                                                                       + // C�d. Segmento do Registro Detalhe
        Space(1)                                                                  + // Uso Exclusivo FEBRABAN/CNAB
        sCodMovimento                                                             + // C�digo de Movimento Remessa
        '0'                                                                       + // C�digo do Desconto 2
        IntToStrZero(0, 8)                                                        + // Data do Desconto 2
        IntToStrZero(0, 15)                                                       + // Valor/Percentual a ser concedido no Desconto 2
        '0'                                                                       + // C�digo do Desconto 3
        IntToStrZero(0, 8)                                                        + // Data do Desconto 3
        IntToStrZero(0, 15)                                                       + // Valor/Percentual a ser concedido no Desconto 3
        sCodMulta                                                                 + // C�digo da Multa
        sDataMulta                                                                + // Data da Multa
        IntToStrZero(Round(PercentualMulta * 100), 15)                            + // Valor/Percentual a ser aplicado na Multa
        Space(10)                                                                 + // Informa��o ao pagador
        Space(40)                                                                 + // Mensagem 3
        Space(40)                                                                 + // Mensagem 4
        Space(20)                                                                 + // Uso Exclusivo FEBRABAN/CNAB
        IntToStrZero(0, 8)                                                        + // C�d. Ocor. do Pagador
        IntToStrZero(0, 3)                                                        + // C�d. do Banco na Conta do D�bito
        IntToStrZero(0, 5)                                                        + // C�digo da Ag�ncia do D�bito
        Space(1)                                                                  + // Digito Verificador da Ag�ncia
        IntToStrZero(0, 12)                                                       + // Conta Corrente para D�bito
        Space(1)                                                                  + // Digito Verificador da Conta
        Space(1)                                                                  + // Digito Verificador da Ag�ncia/Conta
        IntToStrZero(0, 1)                                                        + // Aviso para D�bito Autom�tico
        Space(9));                                                                  // Uso Exclusivo FEBRABAN/CNAB

      Result := RemoverQuebraLinhaFinal(ListTransacao.Text);

    finally
      ListTransacao.Free;
    end;
  end;
end;

function TACBrBancoSulcredi.GerarRegistroTrailler240(ARemessa: TStringList): String;
var
  ListTrailler: TStringList;

begin
  Result:= '';

  ListTrailler := TStringList.Create;
  try
    {REGISTRO TRAILER DO LOTE}

    ListTrailler.Add(
      IntToStrZero(fpNumero, 3)                                   + // C�digo do Banco na compensa��o
      '0001'                                                      + // Lote de servi�o
      '5'                                                         + // Tipo de registro
      Space(9)                                                    + // Uso Exclusivo FEBRABAN / CNAB
      IntToStrZero(fpQtdRegsLote, 6)                              + // Quantidade de registros do lote
      IntToStrZero(fpQtdRegsCobranca, 6)                          + // Quantidade de T�tulos em Cobran�a
      IntToStrZero(Round(fpVlrRegsCobranca * 100), 17)            + // Valor Total dos T�tulos em Carteiras
      IntToStrZero(0, 6)                                          + // Quantidade de T�tulos em Cobran�a
      IntToStrZero(0, 17)                                         + // Valor Total dos T�tulos em Carteiras
      IntToStrZero(0, 6)                                          + // Quantidade de T�tulos em Cobran�a
      IntToStrZero(0, 17)                                         + // Valor Total dos T�tulos em Carteiras
      IntToStrZero(0, 6)                                          + // Quantidade de T�tulos em Cobran�a
      IntToStrZero(0, 17)                                         + // Valor Total dos T�tulos em Carteiras
      Space(8)                                                    + // N�mero do Aviso de Lan�amento
      Space(117)                                                    // Uso Exclusivo FEBRABAN / CNAB
    );

    {REGISTRO TRAILER DO ARQUIVO}

    ListTrailler.Add(
      IntToStrZero(fpNumero, 3)                                   + // C�digo do Banco na compensa��o
      '9999'                                                      + // Lote de servi�o
      '9'                                                         + // Tipo de registro
      Space(9)                                                    + // Uso Exclusivo FEBRABAN / CNAB
      '000001'                                                    + // Quantidade de lotes do arquivo
      IntToStrZero(fpQtdRegsLote + 4, 6)                          + // Quantidade de registros do arquivo
      '000000'                                                    + // Quantidade de contas
      Space(205)                                                    // Uso Exclusivo FEBRABAN / CNAB
    );

    Result := RemoverQuebraLinhaFinal(ListTrailler.Text);

  finally
    fpQtdRegsLote := 0;
    fpQtdRegsCobranca := 0;
    fpVlrRegsCobranca := 0;
    ListTrailler.Free;
  end;
end;

procedure TACBrBancoSulcredi.LerRetorno240(ARetorno: TStringList);
var
  Titulo: TACBrTitulo;
  TempData, Linha, rCedente, rCNPJCPF: String;
  ContLinha: Integer;
  idxMotivo: Integer;
  rConvenioCedente: String;

begin
  // Verifica se o arquivo pertence ao banco
  if StrToIntDef(copy(ARetorno.Strings[0], 1, 3), -1) <> Numero then
    raise Exception.create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno + 'n�o � um arquivo de retorno do ' + Nome));

  ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0], 144, 2) + '/' +
                                                          Copy(ARetorno[0], 146, 2) + '/' +
                                                          Copy(ARetorno[0], 148, 4), 0, 'DD/MM/YYYY');

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0], 158, 6), 0);

  rCedente := Trim(Copy(ARetorno[0], 73, 30));
  rCNPJCPF := OnlyNumber(Copy(ARetorno[0], 19, 14));
  rConvenioCedente := Trim(Copy(ARetorno[0], 33, 20));

  with ACBrBanco.ACBrBoleto do
  begin
    if (not LeCedenteRetorno) and (rCNPJCPF <> OnlyNumber(Cedente.CNPJCPF)) then
       raise Exception.create(ACBrStr('CNPJ\CPF do arquivo inv�lido'));

    if LeCedenteRetorno then
    begin
      Cedente.Nome := rCedente;
      Cedente.CNPJCPF := rCNPJCPF;
      Cedente.Convenio := rConvenioCedente;
    end;

    case StrToIntDef(copy(ARetorno[0], 18, 1), 0) of
      01:
        Cedente.TipoInscricao := pFisica;
      else
        Cedente.TipoInscricao := pJuridica;
    end;

    ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
  end;

  for ContLinha := 1 to ARetorno.Count - 2 do
  begin
    Linha := ARetorno[ContLinha];

    if Copy(Linha, 8, 1) <> '3' then // Verifica se o registro (linha) � um registro detalhe (segmento J)
      Continue;

    if Copy(Linha, 14, 1) = 'T' then // Verifica se for segmento T cria um novo titulo
      Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

    with Titulo do
    begin
      if Copy(Linha, 14, 1) = 'T' then
      begin
        SeuNumero := Copy(Linha, 106, 25);
        NumeroDocumento := Copy(Linha, 59, 15);
        Carteira := Copy(Linha, 58, 1);

        TempData := Copy(Linha, 74, 2) + '/' + Copy(Linha, 76, 2) + '/' + Copy(Linha, 78, 4);
        if TempData <> '00/00/0000' then
          Vencimento := StringToDateTimeDef(TempData, 0, 'DDMMYYYY');

        ValorDocumento := StrToFloatDef(Copy(Linha, 82, 15), 0) / 100;

        NossoNumero := Copy(Linha, 42, 11);
        ValorDespesaCobranca := StrToFloatDef(Copy(Linha, 199, 15), 0) / 100;

        OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(Copy(Linha, 16, 2), 0));

        IdxMotivo := 214;

        while (IdxMotivo < 223) do
        begin
          if (Trim(Copy(Linha, IdxMotivo, 2)) <> '') then
          begin
            MotivoRejeicaoComando.Add(Copy(Linha, IdxMotivo, 2));
            DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, StrToIntDef(Copy(Linha, IdxMotivo, 2), 0)));
          end;
          Inc(IdxMotivo, 2);
        end;

        // Quando o numero documento vier em branco
        if Trim(NumeroDocumento) = '' then
          NumeroDocumento := NossoNumero;
      end
      else // Segmento U
      begin
        ValorIOF            := StrToFloatDef(Copy(Linha, 63, 15), 0) / 100;
        ValorAbatimento     := StrToFloatDef(Copy(Linha, 48, 15), 0) / 100;
        ValorDesconto       := StrToFloatDef(Copy(Linha, 33, 15), 0) / 100;
        ValorMoraJuros      := StrToFloatDef(Copy(Linha, 18, 15), 0) / 100;
        ValorOutrosCreditos := StrToFloatDef(Copy(Linha, 123, 15), 0) / 100;
        ValorOutrasDespesas := StrToFloatDef(Copy(Linha, 108, 15), 0) / 100;
        ValorRecebido       := StrToFloatDef(Copy(Linha, 78, 15), 0) / 100;

        TempData := Copy(Linha, 138, 2) + '/' + Copy(Linha, 140, 2) + '/' + Copy(Linha, 142, 4);
        if TempData <> '00/00/0000' then
          DataOcorrencia := StringToDateTimeDef(TempData, 0, 'DDMMYYYY');

        TempData := Copy(Linha, 146, 2) + '/' + Copy(Linha, 148, 2) + '/' + Copy(Linha, 150, 4);
        if TempData <> '00/00/0000' then
          DataCredito := StringToDateTimeDef(TempData, 0, 'DDMMYYYY');
      end;
    end;
  end;
end;

function TACBrBancoSulcredi.TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  case TipoOcorrencia of
    toRemessaBaixar                         : Result := '02'; {Pedido de Baixa}
    toRemessaProtestoFinsFalimentares       : Result := '03';
    toRemessaConcederAbatimento             : Result := '04'; {Concess�o de Abatimento}
    toRemessaCancelarAbatimento             : Result := '05'; {Cancelamento de Abatimento concedido}
    toRemessaAlterarVencimento              : Result := '06'; {Altera��o de vencimento}
    toRemessaConcederDesconto               : Result := '07';
    toRemessaCancelarDesconto               : Result := '08';
    toRemessaProtestar                      : Result := '09'; {Pedido de protesto}
    toRemessaSustarProtestoBaixarTitulo     : Result := '10';
    toRemessaSustarProtestoManterCarteira   : Result := '11';
    toRemessaAlterarJurosMora               : Result := '12';
    toRemessaDispensarJuros                 : Result := '13';
    toRemessaAlterarMulta                   : Result := '14';
    toRemessaDispensarMulta                 : Result := '15';
    toRemessaAlterarDesconto                : Result := '16';
    toRemessaNaoConcederDesconto            : Result := '17';
    toRemessaAlterarValorAbatimento         : Result := '18';
    toRemessaAlterarPrazoLimiteRecebimento  : Result := '19';
    toRemessaDispensarPrazoLimiteRecebimento: Result := '20';
    toRemessaAlterarNumeroTituloBeneficiario: Result := '21';
    toRemessaAlterarNumeroControle          : Result := '22';
    toRemessaAlterarDadosPagador            : Result := '23';
    toRemessaAlterarDadosSacadorAvalista    : Result := '24';
    toRemessaRecusaAlegacaoPagador          : Result := '30';
    toRemessaAlterarOutrosDados             : Result := '31';
    toRemessaAlterarDadosRateioCredito      : Result := '33';
    toRemessaPedidoCancelamentoDadosRateioCredito : Result := '34';
    toRemessaPedidoDesagendamentoDebietoAutom     : Result := '35';
    toRemessaAlterarProtestoDevolucao       : Result := '40';
    toRemessaAlterarEspecieTitulo           : Result := '42';
    toRemessaTransferenciaCarteira          : Result := '43';
    toRemessaAlterarContratoCobran          : Result := '44';
    toRemessaNegativacaoSemProtesto         : Result := '45';
    toRemessaBaixaTituloNegativadoSemProtesto      : Result := '46';
    toRemessaAlterarValorTitulo             : Result := '47';
    toRemessaAlterarValorMinimo             : Result := '48';
    toRemessaAlterarValorMaximo             : Result := '49';
    toRemessaHibrido                        : Result := '61';
  else
    Result := '01';
  end;
end;

function TACBrBancoSulcredi.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
  CodOcorrencia: Integer;

begin
  CodOcorrencia := StrToIntDef(TipoOCorrenciaToCod(TipoOcorrencia),0);

  case CodOcorrencia of
    02: Result:='02-Entrada Confirmada' ;
    03: Result:='03-Entrada Rejeitada' ;
    06: Result:='06-Liquida��o normal' ;
    09: Result:='09-Baixado Automaticamente via Arquivo' ;
    10: Result:='10-Baixado conforme instru��es da Ag�ncia' ;
    11: Result:='11-Em Ser - Arquivo de T�tulos pendentes' ;
    12: Result:='12-Abatimento Concedido' ;
    13: Result:='13-Abatimento Cancelado' ;
    14: Result:='14-Vencimento Alterado' ;
    15: Result:='15-Liquida��o em Cart�rio' ;
    16: Result:= '16-Titulo Pago em Cheque - Vinculado';
    17: Result:='17-Liquida��o ap�s baixa ou T�tulo n�o registrado' ;
    18: Result:='18-Acerto de Deposit�ria' ;
    19: Result:='19-Confirma��o Recebimento Instru��o de Protesto' ;
    20: Result:='20-Confirma��o Recebimento Instru��o Susta��o de Protesto' ;
    21: Result:='21-Acerto do Controle do Participante' ;
    22: Result:='22-Titulo com Pagamento Cancelado';
    23: Result:='23-Entrada do T�tulo em Cart�rio' ;
    24: Result:='24-Entrada rejeitada por CEP Irregular' ;
    27: Result:='27-Baixa Rejeitada' ;
    28: Result:='28-D�bito de tarifas/custas' ;
    29: Result:= '29-Ocorr�ncias do Sacado';
    30: Result:='30-Altera��o de Outros Dados Rejeitados' ;
    32: Result:='32-Instru��o Rejeitada' ;
    33: Result:='33-Confirma��o Pedido Altera��o Outros Dados' ;
    34: Result:='34-Retirado de Cart�rio e Manuten��o Carteira' ;
    35: Result:='35-Desagendamento do d�bito autom�tico' ;
    40: Result:='40-Estorno de Pagamento';
    55: Result:='55-Sustado Judicial';
    68: Result:='68-Acerto dos dados do rateio de Cr�dito' ;
    69: Result:='69-Cancelamento dos dados do rateio' ;
  end;
end;

function TACBrBancoSulcredi.CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    09: Result := toRetornoBaixadoViaArquivo;
    10: Result := toRetornoBaixadoInstAgencia;
    11: Result := toRetornoTituloEmSer;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoLiquidadoEmCartorio;
    16: Result := toRetornoTituloPagoEmCheque;
    17: Result := toRetornoLiquidadoAposBaixaouNaoRegistro;
    18: Result := toRetornoAcertoDepositaria;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    21: Result := toRetornoAcertoControleParticipante;
    22: Result := toRetornoTituloPagamentoCancelado;
    23: Result := toRetornoEncaminhadoACartorio;
    24: Result := toRetornoEntradaRejeitaCEPIrregular;
    27: Result := toRetornoBaixaRejeitada;
    28: Result := toRetornoDebitoTarifas;
    29: Result := toRetornoOcorrenciasdoSacado;
    30: Result := toRetornoAlteracaoOutrosDadosRejeitada;
    32: Result := toRetornoComandoRecusado;
    33: Result := toRetornoRecebimentoInstrucaoAlterarDados;
    34: Result := toRetornoRetiradoDeCartorio;
    35: Result := toRetornoDesagendamentoDebitoAutomatico;
    99: Result := toRetornoRegistroRecusado;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoSulcredi.TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  case TipoOcorrencia of
    toRetornoRegistroConfirmado                : Result := '02';
    toRetornoRegistroRecusado                  : Result := '03';
    toRetornoLiquidado                         : Result := '06';
    toRetornoBaixadoViaArquivo                 : Result := '09';
    toRetornoBaixadoInstAgencia                : Result := '10';
    toRetornoTituloEmSer                       : Result := '11';
    toRetornoAbatimentoConcedido               : Result := '12';
    toRetornoAbatimentoCancelado               : Result := '13';
    toRetornoVencimentoAlterado                : Result := '14';
    toRetornoLiquidadoEmCartorio               : Result := '15';
    toRetornoTituloPagoEmCheque                : Result := '16';
    toRetornoLiquidadoAposBaixaouNaoRegistro   : Result := '17';
    toRetornoAcertoDepositaria                 : Result := '18';
    toRetornoRecebimentoInstrucaoProtestar     : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto: Result := '20';
    toRetornoAcertoControleParticipante        : Result := '21';
    toRetornoTituloPagamentoCancelado          : Result := '22';
    toRetornoEncaminhadoACartorio              : Result := '23';
    toRetornoEntradaRejeitaCEPIrregular        : Result := '24';
    toRetornoBaixaRejeitada                    : Result := '27';
    toRetornoDebitoTarifas                     : Result := '28';
    toRetornoOcorrenciasDoSacado               : Result := '29';
    toRetornoAlteracaoOutrosDadosRejeitada     : Result := '30';
    toRetornoComandoRecusado                   : Result := '32';
    { DONE -oJacinto -cAjuste : Acrescentar a ocorr�ncia correta referente ao c�digo. }
    toRetornoRecebimentoInstrucaoAlterarDados  : Result := '33';
    { DONE -oJacinto -cAjuste : Acrescentar a ocorr�ncia correta referente ao c�digo. }
    toRetornoRetiradoDeCartorio                : Result := '34';
    toRetornoDesagendamentoDebitoAutomatico    : Result := '35';
  else
    Result := '02';
  end;
end;

function TACBrBancoSulcredi.COdMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): String;
begin
  case TipoOcorrencia of
    toRetornoRegistroConfirmado:
      case CodMotivo  of
        00: Result := '00-Ocorrencia aceita';
        01: Result := '01-Codigo de banco inv�lido';
        04: Result := '04-Cod. movimentacao nao permitido p/ a carteira';
        15: Result := '15-Caracteristicas de Cobranca Imcompativeis';
        17: Result := '17-Data de vencimento anterior a data de emiss�o';
        21: Result := '21-Esp�cie do T�tulo inv�lido';
        24: Result := '24-Data da emiss�o inv�lida';
        38: Result := '38-Prazo para protesto inv�lido';
        39: Result := '39-Pedido para protesto n�o permitido para t�tulo';
        43: Result := '43-Prazo para baixa e devolu��o inv�lido';
        45: Result := '45-Nome do Sacado inv�lido';
        46: Result := '46-Tipo/num. de inscri��o do Sacado inv�lidos';
        47: Result := '47-Endere�o do Sacado n�o informado';
        48: Result := '48-CEP invalido';
        50: Result := '50-CEP referente a Banco correspondente';
        53: Result := '53-N� de inscri��o do Sacador/avalista inv�lidos (CPF/CNPJ)';
        54: Result := '54-Sacador/avalista n�o informado';
        67: Result := '67-D�bito autom�tico agendado';
        68: Result := '68-D�bito n�o agendado - erro nos dados de remessa';
        69: Result := '69-D�bito n�o agendado - Sacado n�o consta no cadastro de autorizante';
        70: Result := '70-D�bito n�o agendado - Cedente n�o autorizado pelo Sacado';
        71: Result := '71-D�bito n�o agendado - Cedente n�o participa da modalidade de d�bito autom�tico';
        72: Result := '72-D�bito n�o agendado - C�digo de moeda diferente de R$';
        73: Result := '73-D�bito n�o agendado - Data de vencimento inv�lida';
        75: Result := '75-D�bito n�o agendado - Tipo do n�mero de inscri��o do sacado debitado inv�lido';
        86: Result := '86-Seu n�mero do documento inv�lido';
        89: Result := '89-Email sacado nao enviado - Titulo com debito automatico';
        90: Result := '90-Email sacado nao enviado - Titulo com cobranca sem registro';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoRegistroRecusado:
      case CodMotivo of
        02: Result:= '02-Codigo do registro detalhe invalido';
        03: Result:= '03-Codigo da Ocorrencia Invalida';
        04: Result:= '04-Codigo da Ocorrencia nao permitida para a carteira';
        05: Result:= '05-Codigo de Ocorrencia nao numerico';
        07: Result:= 'Agencia\Conta\Digito invalido';
        08: Result:= 'Nosso numero invalido';
        09: Result:= 'Nosso numero duplicado';
        10: Result:= 'Carteira invalida';
        13: Result:= 'Idetificacao da emissao do boleto invalida';
        16: Result:= 'Data de vencimento invalida';
        18: Result:= 'Vencimento fora do prazo de operacao';
        20: Result:= 'Valor do titulo invalido';
        21: Result:= 'Especie do titulo invalida';
        22: Result:= 'Especie nao permitida para a carteira';
        24: Result:= 'Data de emissao invalida';
        28: Result:= 'Codigo de desconto invalido';
        38: Result:= 'Prazo para protesto invalido';
        44: Result:= 'Agencia cedente nao prevista';
        45: Result:= 'Nome cedente nao informado';
        46: Result:= 'Tipo/numero inscricao sacado invalido';
        47: Result:= 'Endereco sacado nao informado';
        48: Result:= 'CEP invalido';
        50: Result:= 'CEP irregular - Banco correspondente';
        63: Result:= 'Entrada para titulo ja cadastrado';
        65: Result:= 'Limite excedido';
        66: Result:= 'Numero autorizacao inexistente';
        68: Result:= 'Debito nao agendado - Erro nos dados da remessa';
        69: Result:= 'Debito nao agendado - Sacado nao consta no cadastro de autorizante';
        70: Result:= 'Debito nao agendado - Cedente nao autorizado pelo sacado';
        71: Result:= 'Debito nao agendado - Cedente nao participa de debito automatico';
        72: Result:= 'Debito nao agendado - Codigo de moeda diferente de R$';
        73: Result:= 'Debito nao agendado - Data de vencimento invalida';
        74: Result:= 'Debito nao agendado - Conforme seu pedido titulo nao registrado';
        75: Result:= 'Debito nao agendado - Tipo de numero de inscricao de debitado invalido';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoLiquidado:
      case CodMotivo of
        00: Result:= '00-Titulo pago com dinheiro';
        15: Result:= '15-Titulo pago com cheque';
        42: Result:= '42-Rateio nao efetuado';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoBaixadoViaArquivo:
      case CodMotivo of
        00: Result:= '00-Ocorrencia aceita';
        10: Result:= '10=Baixa comandada pelo cliente';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoBaixadoInstAgencia:
      case CodMotivo of
        00: Result:= '00-Baixado conforme instrucoes na agencia';
        14: Result:= '14-Titulo protestado';
        15: Result:= '15-Titulo excluido';
        16: Result:= '16-Titulo baixado pelo banco por decurso de prazo';
        20: Result:= '20-Titulo baixado e transferido para desconto';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoLiquidadoAposBaixaouNaoRegistro:
      case CodMotivo of
        00: Result:= '00-Pago com dinheiro';
        15: Result:= '15-Pago com cheque';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoLiquidadoEmCartorio:
      case CodMotivo of
        00: Result:= '00-Pago com dinheiro';
        15: Result:= '15-Pago com cheque';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoEntradaRejeitaCEPIrregular:
      case CodMotivo of
        48: Result:= '48-CEP invalido';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoBaixaRejeitada:
      case CodMotivo of
        04: Result:= '04-Codigo de ocorrencia nao permitido para a carteira';
        07: Result:= '07-Agencia\Conta\Digito invalidos';
        08: Result:= '08-Nosso numero invalido';
        10: Result:= '10-Carteira invalida';
        15: Result:= '15-Carteira\Agencia\Conta\NossoNumero invalidos';
        40: Result:= '40-Titulo com ordem de protesto emitido';
        42: Result:= '42-Codigo para baixa/devolucao via Telebradesco invalido';
        60: Result:= '60-Movimento para titulo nao cadastrado';
        77: Result:= '70-Transferencia para desconto nao permitido para a carteira';
        85: Result:= '85-Titulo com pagamento vinculado';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoDebitoTarifas:
      case CodMotivo of
        02: Result:= '02-Tarifa de perman�ncia t�tulo cadastrado';
        03: Result:= '03-Tarifa de susta��o';
        04: Result:= '04-Tarifa de protesto';
        05: Result:= '05-Tarifa de outras instrucoes';
        06: Result:= '06-Tarifa de outras ocorr�ncias';
        08: Result:= '08-Custas de protesto';
        12: Result:= '12-Tarifa de registro';
        13: Result:= '13-Tarifa titulo pago no Bradesco';
        14: Result:= '14-Tarifa titulo pago compensacao';
        15: Result:= '15-Tarifa t�tulo baixado n�o pago';
        16: Result:= '16-Tarifa alteracao de vencimento';
        17: Result:= '17-Tarifa concess�o abatimento';
        18: Result:= '18-Tarifa cancelamento de abatimento';
        19: Result:= '19-Tarifa concess�o desconto';
        20: Result:= '20-Tarifa cancelamento desconto';
        21: Result:= '21-Tarifa t�tulo pago cics';
        22: Result:= '22-Tarifa t�tulo pago Internet';
        23: Result:= '23-Tarifa t�tulo pago term. gerencial servi�os';
        24: Result:= '24-Tarifa t�tulo pago P�g-Contas';
        25: Result:= '25-Tarifa t�tulo pago Fone F�cil';
        26: Result:= '26-Tarifa t�tulo D�b. Postagem';
        27: Result:= '27-Tarifa impress�o de t�tulos pendentes';
        28: Result:= '28-Tarifa t�tulo pago BDN';
        29: Result:= '29-Tarifa t�tulo pago Term. Multi Funcao';
        30: Result:= '30-Impress�o de t�tulos baixados';
        31: Result:= '31-Impress�o de t�tulos pagos';
        32: Result:= '32-Tarifa t�tulo pago Pagfor';
        33: Result:= '33-Tarifa reg/pgto � guich� caixa';
        34: Result:= '34-Tarifa t�tulo pago retaguarda';
        35: Result:= '35-Tarifa t�tulo pago Subcentro';
        36: Result:= '36-Tarifa t�tulo pago Cartao de Credito';
        37: Result:= '37-Tarifa t�tulo pago Comp Eletr�nica';
        38: Result:= '38-Tarifa t�tulo Baix. Pg. Cartorio';
        39: Result:='39-Tarifa t�tulo baixado acerto BCO';
        40: Result:='40-Baixa registro em duplicidade';
        41: Result:='41-Tarifa t�tulo baixado decurso prazo';
        42: Result:='42-Tarifa t�tulo baixado Judicialmente';
        43: Result:='43-Tarifa t�tulo baixado via remessa';
        44: Result:='44-Tarifa t�tulo baixado rastreamento';
        45: Result:='45-Tarifa t�tulo baixado conf. Pedido';
        46: Result:='46-Tarifa t�tulo baixado protestado';
        47: Result:='47-Tarifa t�tulo baixado p/ devolucao';
        48: Result:='48-Tarifa t�tulo baixado franco pagto';
        49: Result:='49-Tarifa t�tulo baixado SUST/RET/CART�RIO';
        50: Result:='50-Tarifa t�tulo baixado SUS/SEM/REM/CART�RIO';
        51: Result:='51-Tarifa t�tulo transferido desconto';
        52: Result:='52-Cobrado baixa manual';
        53: Result:='53-Baixa por acerto cliente';
        54: Result:='54-Tarifa baixa por contabilidade';
        55: Result:='55-BIFAX';
        56: Result:='56-Consulta informa��es via internet';
        57: Result:='57-Arquivo retorno via internet';
        58: Result:='58-Tarifa emiss�o Papeleta';
        59: Result:='59-Tarifa fornec papeleta semi preenchida';
        60: Result:='60-Acondicionador de papeletas (RPB)S';
        61: Result:='61-Acond. De papelatas (RPB)s PERSONAL';
        62: Result:='62-Papeleta formul�rio branco';
        63: Result:='63-Formul�rio A4 serrilhado';
        64: Result:='64-Fornecimento de softwares transmiss';
        65: Result:='65-Fornecimento de softwares consulta';
        66: Result:='66-Fornecimento Micro Completo';
        67: Result:='67-Fornecimento MODEN';
        68: Result:='68-Fornecimento de m�quina FAX';
        69: Result:='69-Fornecimento de maquinas oticas';
        70: Result:='70-Fornecimento de Impressoras';
        71: Result:='71-Reativa��o de t�tulo';
        72: Result:='72-Altera��o de produto negociado';
        73: Result:='73-Tarifa emissao de contra recibo';
        74: Result:='74-Tarifa emissao 2� via papeleta';
        75: Result:='75-Tarifa regrava��o arquivo retorno';
        76: Result:='76-Arq. T�tulos a vencer mensal';
        77: Result:='77-Listagem auxiliar de cr�dito';
        78: Result:='78-Tarifa cadastro cartela instru��o permanente';
        79: Result:='79-Canaliza��o de Cr�dito';
        80: Result:='80-Cadastro de Mensagem Fixa';
        81: Result:='81-Tarifa reapresenta��o autom�tica t�tulo';
        82: Result:='82-Tarifa registro t�tulo d�b. Autom�tico';
        83: Result:='83-Tarifa Rateio de Cr�dito';
        84: Result:='84-Emiss�o papeleta sem valor';
        85: Result:='85-Sem uso';
        86: Result:='86-Cadastro de reembolso de diferen�a';
        87: Result:='87-Relat�rio fluxo de pagto';
        88: Result:='88-Emiss�o Extrato mov. Carteira';
        89: Result:='89-Mensagem campo local de pagto';
        90: Result:='90-Cadastro Concession�ria serv. Publ.';
        91: Result:='91-Classif. Extrato Conta Corrente';
        92: Result:='92-Contabilidade especial';
        93: Result:='93-Realimenta��o pagto';
        94: Result:='94-Repasse de Cr�ditos';
        95: Result:='95-Tarifa reg. pagto Banco Postal';
        96: Result:='96-Tarifa reg. Pagto outras m�dias';
        97: Result:='97-Tarifa Reg/Pagto � Net Empresa';
        98: Result:='98-Tarifa t�tulo pago vencido';
        99: Result:='99-TR T�t. Baixado por decurso prazo';
        100: Result:='100-Arquivo Retorno Antecipado';
        101: Result:='101-Arq retorno Hora/Hora';
        102: Result:='102-TR. Agendamento D�b Aut';
        103: Result:='103-TR. Tentativa cons D�b Aut';
        104: Result:='104-TR Cr�dito on-line';
        105: Result:='105-TR. Agendamento rat. Cr�dito';
        106: Result:='106-TR Emiss�o aviso rateio';
        107: Result:='107-Extrato de protesto';
        110: Result:='110-Tarifa reg/pagto Bradesco Expresso';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoOcorrenciasdoSacado:
      case CodMotivo of
        78 : Result:= '78-Sacado alega que faturamento e indevido';
        116: Result:= '116-Sacado aceita/reconhece o faturamento';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoALteracaoOutrosDadosRejeitada:
      case CodMotivo of
        01: Result:= '01-C�digo do Banco inv�lido';
        04: Result:= '04-C�digo de ocorr�ncia n�o permitido para a carteira';
        05: Result:= '05-C�digo da ocorr�ncia n�o num�rico';
        08: Result:= '08-Nosso n�mero inv�lido';
        15: Result:= '15-Caracter�stica da cobran�a incompat�vel';
        16: Result:= '16-Data de vencimento inv�lido';
        17: Result:= '17-Data de vencimento anterior a data de emiss�o';
        18: Result:= '18-Vencimento fora do prazo de opera��o';
        24: Result:= '24-Data de emiss�o Inv�lida';
        26: Result:= '26-C�digo de juros de mora inv�lido';
        27: Result:= '27-Valor/taxa de juros de mora inv�lido';
        28: Result:= '28-C�digo de desconto inv�lido';
        29: Result:= '29-Valor do desconto maior/igual ao valor do T�tulo';
        30: Result:= '30-Desconto a conceder n�o confere';
        31: Result:= '31-Concess�o de desconto j� existente ( Desconto anterior )';
        32: Result:= '32-Valor do IOF inv�lido';
        33: Result:= '33-Valor do abatimento inv�lido';
        34: Result:= '34-Valor do abatimento maior/igual ao valor do T�tulo';
        38: Result:= '38-Prazo para protesto inv�lido';
        39: Result:= '39-Pedido de protesto n�o permitido para o T�tulo';
        40: Result:= '40-T�tulo com ordem de protesto emitido';
        42: Result:= '42-C�digo para baixa/devolu��o inv�lido';
        46: Result:= '46-Tipo/n�mero de inscri��o do sacado inv�lidos';
        48: Result:= '48-Cep Inv�lido';
        53: Result:= '53-Tipo/N�mero de inscri��o do sacador/avalista inv�lidos';
        54: Result:= '54-Sacador/avalista n�o informado';
        57: Result:= '57-C�digo da multa inv�lido';
        58: Result:= '58-Data da multa inv�lida';
        60: Result:= '60-Movimento para T�tulo n�o cadastrado';
        79: Result:= '79-Data de Juros de mora Inv�lida';
        80: Result:= '80-Data do desconto inv�lida';
        85: Result:= '85-T�tulo com Pagamento Vinculado.';
        88: Result:= '88-E-mail Sacado n�o lido no prazo 5 dias';
        91: Result:= '91-E-mail sacado n�o recebido';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoComandoRecusado:
      case CodMotivo of
        01 : Result:= '01-C�digo do Banco inv�lido';
        02 : Result:= '02-C�digo do registro detalhe inv�lido';
        04 : Result:= '04-C�digo de ocorr�ncia n�o permitido para a carteira';
        05 : Result:= '05-C�digo de ocorr�ncia n�o num�rico';
        07 : Result:= '07-Ag�ncia/Conta/d�gito inv�lidos';
        08 : Result:= '08-Nosso n�mero inv�lido';
        10 : Result:= '10-Carteira inv�lida';
        15 : Result:= '15-Caracter�sticas da cobran�a incompat�veis';
        16 : Result:= '16-Data de vencimento inv�lida';
        17 : Result:= '17-Data de vencimento anterior a data de emiss�o';
        18 : Result:= '18-Vencimento fora do prazo de opera��o';
        20 : Result:= '20-Valor do t�tulo inv�lido';
        21 : Result:= '21-Esp�cie do T�tulo inv�lida';
        22 : Result:= '22-Esp�cie n�o permitida para a carteira';
        24 : Result:= '24-Data de emiss�o inv�lida';
        28 : Result:= '28-C�digo de desconto via Telebradesco inv�lido';
        29 : Result:= '29-Valor do desconto maior/igual ao valor do T�tulo';
        30 : Result:= '30-Desconto a conceder n�o confere';
        31 : Result:= '31-Concess�o de desconto - J� existe desconto anterior';
        33 : Result:= '33-Valor do abatimento inv�lido';
        34 : Result:= '34-Valor do abatimento maior/igual ao valor do T�tulo';
        36 : Result:= '36-Concess�o abatimento - J� existe abatimento anterior';
        38 : Result:= '38-Prazo para protesto inv�lido';
        39 : Result:= '39-Pedido de protesto n�o permitido para o T�tulo';
        40 : Result:= '40-T�tulo com ordem de protesto emitido';
        41 : Result:= '41-Pedido cancelamento/susta��o para T�tulo sem instru��o de protesto';
        42 : Result:= '42-C�digo para baixa/devolu��o inv�lido';
        45 : Result:= '45-Nome do Sacado n�o informado';
        46 : Result:= '46-Tipo/n�mero de inscri��o do Sacado inv�lidos';
        47 : Result:= '47-Endere�o do Sacado n�o informado';
        48 : Result:= '48-CEP Inv�lido';
        50 : Result:= '50-CEP referente a um Banco correspondente';
        53 : Result:= '53-Tipo de inscri��o do sacador avalista inv�lidos';
        60 : Result:= '60-Movimento para T�tulo n�o cadastrado';
        85 : Result:= '85-T�tulo com pagamento vinculado';
        86 : Result:= '86-Seu n�mero inv�lido';
        94 : Result:= '94-T�tulo Penhorado � Instru��o N�o Liberada pela Ag�ncia';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoDesagendamentoDebitoAutomatico:
      case CodMotivo of
        81 : Result:= '81-Tentativas esgotadas, baixado';
        82 : Result:= '82-Tentativas esgotadas, pendente';
        83 : Result:= '83-Cancelado pelo Sacado e Mantido Pendente, conforme negocia��o';
        84 : Result:= '84-Cancelado pelo sacado e baixado, conforme negocia��o';
      else
        Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
   else
      Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
   end;
end;

function TACBrBancoSulcredi.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    03 : Result:= toRemessaProtestoFinsFalimentares;        {Pedido de Protesto Falimentar}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Altera��o de vencimento}
    07 : Result:= toRemessaConcederDesconto;                {Concess�o de desconto}
    08 : Result:= toRemessaCancelarDesconto;                {Cancelamento de desconto}
    09 : Result:= toRemessaProtestar;                       {Pedido de protesto}
    10 : Result:= toRemessaSustarProtestoBaixarTitulo;      {Sustar Protesto e Baixar T�tulo}
    11 : Result:= toRemessaSustarProtestoManterCarteira;    {Sustar Protesto e Manter em Carteira}
    12 : Result:= toRemessaAlterarJurosMora;                {Altera��o de Juros de Mora}
    13 : Result:= toRemessaDispensarJuros;                  {Dispensar Cobran�a de Juros de Mora}
    14 : Result:= toRemessaAlterarMulta;                    {Altera��o de Valor/Percentual de Multa}
    15 : Result:= toRemessaDispensarMulta;                  {Dispensar Cobran�a de Multa}
    16 : Result:= toRemessaAlterarDesconto;                 {Altera��o de Valor/Data de Desconto}
    17 : Result:= toRemessaNaoConcederDesconto;             {N�o conceder Desconto}
    18 : Result:= toRemessaAlterarValorAbatimento;          {Altera��o do Valor de Abatimento}
    19 : Result:= toRemessaAlterarPrazoLimiteRecebimento;   {Prazo Limite de Recebimento - Alterar}
    20 : Result:= toRemessaDispensarPrazoLimiteRecebimento; {Prazo Limite de Recebimento - Dispensar}
    21 : Result:= toRemessaAlterarNumeroTituloBeneficiario; {Alterar n�mero do t�tulo dado pelo Benefici�rio}
    22 : Result:= toRemessaAlterarNumeroControle;           {Alterar n�mero controle do Participante}
    23 : Result:= toRemessaAlterarDadosPagador;             {Alterar dados do Pagador}
    24 : Result:= toRemessaAlterarDadosSacadorAvalista;     {Alterar dados do Sacador/Avalista}
    30 : Result:= toRemessaRecusaAlegacaoPagador;           {Recusa da Alega��o do Pagador}
    31 : Result:= toRemessaAlterarOutrosDados;              {Altera��o de Outros Dados}
    33 : Result:= toRemessaAlterarDadosRateioCredito;       {Altera��o dos Dados do Rateio de Cr�dito}
    34 : Result:= toRemessaPedidoCancelamentoDadosRateioCredito; {Pedido de Cancelamento dos Dados do Rateio de Cr�dito}
    35 : Result:= toRemessaPedidoDesagendamentoDebietoAutom;{Pedido de Desagendamento do D�bito Autom�tico}
    40 : Result:= toRemessaAlterarProtestoDevolucao;        {Altera��o de Carteira "41" = Cancelar protesto}
    42 : Result:= toRemessaAlterarEspecieTitulo;            {Altera��o de Esp�cie de T�tulo}
    43 : Result:= toRemessaTransferenciaCarteira;           {Transfer�ncia de carteira/modalidade de cobran�a}
    44 : Result:= toRemessaAlterarContratoCobran;           {Altera��o de contrato de cobran�a}
    45 : Result:= toRemessaNegativacaoSemProtesto;          {Negativa��o Sem Protesto}
    46 : Result:= toRemessaBaixaTituloNegativadoSemProtesto;{Solicita��o de Baixa de T�tulo Negativado Sem Protesto}
    47 : Result:= toRemessaAlterarValorTitulo;              {Altera��o do Valor Nominal do T�tulo}
    48 : Result:= toRemessaAlterarValorMinimo;              {Altera��o do Valor M�nimo/ Percentual}
    49 : Result:= toRemessaAlterarValorMaximo;              {Altera��o do Valor M�ximo/Percentual}
    61 : Result:= toRemessaHibrido;                         {Altera��o para inclus�o/manuten��o de QR Code Pix}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;
end;

end.


