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

unit ACBrBancoItau;

interface

uses
  Classes, SysUtils, Contnrs,
  ACBrBoleto, ACBrBoletoConversao;

type
  { TACBrBancoItau}

  TACBrBancoItau = class(TACBrBancoClass)
  private
    fTipoOcorrenciaRemessa : String;
    fDataProtestoNegativacao : TDateTime;
    fDiasProtestoNegativacao : String;
  protected
    function DefineNumeroDocumentoModulo(const ACBrTitulo: TACBrTitulo): String; override;
    function DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;
    function DefineCampoConvenio(const ATam: Integer = 20): String; override;
    function DefineCampoDigitoAgencia: String; override;
    function DefineCampoDigitoConta: String; override;
    function DefineCampoDigitoAgenciaConta: String; override;
    function DefinePosicaoUsoExclusivo: String; override;
    function DefineEspecieDoc(const ACBrTitulo: TACBrTitulo): String; override;
    function DefineTipoBeneficiario(const ACBrTitulo: TACBrTitulo): String;
    function DefinePosicaoNossoNumeroRetorno: Integer; override;
    function DefineTipoSacado(const ACBrTitulo: TACBrTitulo): String; override;
    function DefinePosicaoCarteiraRetorno:Integer; override;
    function InstrucoesProtesto(const ACBrTitulo: TACBrTitulo): String;override;
    function MontaInstrucoesCNAB400(const ACBrTitulo :TACBrTitulo; const nRegistro: Integer ): String; override;

    function ConverteEspecieDoc(const ACodigoEspecie: Integer = 0): String;
    procedure DefineDataProtestoNegativacao(const ACBrTitulo: TACBrTitulo);
    procedure EhObrigatorioAgenciaDV; override;
  public
    Constructor create(AOwner: TACBrBanco);
    function MontarCampoNossoNumero ( const ACBrTitulo: TACBrTitulo) : String; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String; override;

    function GerarRegistroTransacao240(ACBrTitulo : TACBrTitulo): String; override;
    function GerarRegistroTrailler240(ARemessa : TStringList): String;  override;
    procedure GerarRegistroHeader400(NumeroRemessa : Integer; aRemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList); override;

    Procedure LerRetorno400(ARetorno:TStringList); override;

    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia) : String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia):String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia:TACBrTipoOcorrencia; CodMotivo:Integer): String; override;

    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function CodigoLiquidacao_Descricao( CodLiquidacao : String) : String;

    function TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;

    property TipoOcorrenciaRemessa: String read fTipoOcorrenciaRemessa write fTipoOcorrenciaRemessa;
    property DataProtestoNegativacao : TDateTime read  fDataProtestoNegativacao ;
    property DiasProtestoNegativacao : String read fDiasProtestoNegativacao ;

  end;

implementation

uses
  {$IFDEF COMPILER6_UP} dateutils {$ELSE} ACBrD5 {$ENDIF},
  StrUtils, Variants, ACBrValidador, ACBrUtil.Base, ACBrUtil.FilesIO,
  ACBrUtil.Strings, ACBrUtil.DateTime;

constructor TACBrBancoItau.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                := 7;
   fpNome                  := 'BANCO ITAU SA';
   fpNumero                := 341;
   fpTamanhoMaximoNossoNum := 8;
   fpTamanhoAgencia        := 4;
   fpTamanhoConta          := 5;
   fpTamanhoCarteira       := 3;
   fpTamanhoNumeroDocumento:= 10;
   fTipoOcorrenciaRemessa  := '01';
   fpQtdRegsLote           := 0;
   fpQtdRegsCobranca       := 0;
   fpVlrRegsCobranca       := 0;
   fpLayoutVersaoArquivo   := 40;
   fpLayoutVersaoLote      := 30;
   fpDensidadeGravacao     := '0';
   fpModuloMultiplicadorInicial:= 1;
   fpModuloMultiplicadorFinal:= 2;
   fpModuloMultiplicadorAtual:= 2;

   fpCodigosMoraAceitos    := '123590919305';
end;

function TACBrBancoItau.DefineNumeroDocumentoModulo(
  const ACBrTitulo: TACBrTitulo): String;
var
  Docto: String;
begin
  Result := '0';
  Docto := '';

  with ACBrTitulo do
  begin
     if MatchText( Carteira , ['116','117','119','134','135','136','104',
     '147','105','112','212','166','113','126','131','145','150','168']) then
           Docto := Carteira + PadLeft(NossoNumero,TamanhoMaximoNossoNum,'0')
        else
           Docto := ACBrBoleto.Cedente.Agencia + ACBrBoleto.Cedente.Conta +
                    Carteira + PadLeft(ACBrTitulo.NossoNumero,TamanhoMaximoNossoNum,'0')
  end;
  Modulo.FormulaDigito := frModulo10;  //Particularidade do Itau
  Result := Docto;

end;

function TACBrBancoItau.DefineCampoLivreCodigoBarras(
  const ACBrTitulo: TACBrTitulo): String;
var
  ANossoNumero, aAgenciaCC: String;
begin
  Result := '';
  with ACBrTitulo do
  begin
    ANossoNumero := ACBrTitulo.Carteira +
                    PadLeft(NossoNumero,8,'0') +
                    CalcularDigitoVerificador(ACBrTitulo);

    AAgenciaCC   := OnlyNumber(ACBrTitulo.ACBrBoleto.Cedente.Agencia +
                  ACBrTitulo.ACBrBoleto.Cedente.Conta   +
                  ACBrTitulo.ACBrBoleto.Cedente.ContaDigito);


    Result := ANossoNumero +
              AAgenciaCC +
              '000';
  end;

end;

function TACBrBancoItau.DefineCampoConvenio(const ATam: Integer): String;
begin
  Result := Space(ATam);
end;

function TACBrBancoItau.DefineCampoDigitoAgencia: String;
begin
  Result := Space(1);
end;

function TACBrBancoItau.DefineCampoDigitoConta: String;
begin
  Result := Space(1);
end;

function TACBrBancoItau.DefineCampoDigitoAgenciaConta: String;
begin
  Result := PadLeft(ACBrBanco.ACBrBoleto.Cedente.ContaDigito, 1, '0');
end;

function TACBrBancoItau.DefinePosicaoUsoExclusivo: String;
begin
  Result := space(54)                          + // 172 a 225 - 54 Brancos
            '000'                              + // 226 a 228 - zeros
            space(12);                           // 229 a 240 - Brancos
end;

function TACBrBancoItau.DefineEspecieDoc(const ACBrTitulo: TACBrTitulo): String;
begin
  with ACBrTitulo do
  begin
    if ACBrBanco.ACBrBoleto.LayoutRemessa = c240 then
    begin
       if AnsiSameText(EspecieDoc, 'DM') then
        Result := '01'
       else if AnsiSameText(EspecieDoc,'NP') then
        Result := '02'
       else if AnsiSameText(EspecieDoc,'NS') then
        Result := '03'
       else if AnsiSameText(EspecieDoc,'ME') then
        Result := '04'
       else if AnsiSameText(EspecieDoc,'RC') then
        Result := '05'
       else if AnsiSameText(EspecieDoc,'CTR') then
        Result := '06'
       else if AnsiSameText(EspecieDoc,'CSG') then
        Result := '07'
       else if AnsiSameText(EspecieDoc,'DS') then
        Result := '08'
       else if AnsiSameText(EspecieDoc,'LC') then
        Result := '09'
       else if AnsiSameText(EspecieDoc,'ND') then
        Result := '13'
       else if AnsiSameText(EspecieDoc,'DD') then
        Result := '15'
       else if AnsiSameText(EspecieDoc,'EC') then
        Result := '16'
       else if AnsiSameText(EspecieDoc,'CPS') then
        Result := '17'
       else if AnsiSameText(EspecieDoc,'BDP') then
        Result := '18'
       else
        Result := '99';
    end
    else
    begin
      if trim(EspecieDoc) = 'DM' then
        Result:= '01'
      else if trim(EspecieDoc) = 'NP' then
        Result:= '02'
      else if trim(EspecieDoc) = 'NS' then
        Result:= '03'
      else if trim(EspecieDoc) = 'ME' then
        Result:= '04'
      else if trim(EspecieDoc) = 'RC' then
        Result:= '05'
      else if trim(EspecieDoc) = 'CT' then
        Result:= '06'
      else if trim(EspecieDoc) = 'CS' then
        Result:= '07'
      else if trim(EspecieDoc) = 'DS' then
        Result:= '08'
      else if trim(EspecieDoc) = 'LC' then
        Result:= '09'
      else if trim(EspecieDoc) = 'ND' then
        Result:= '13'
      else if trim(EspecieDoc) = 'DD' then
        Result:= '15'
      else if trim(EspecieDoc) = 'EC' then
        Result:= '16'
      else if trim(EspecieDoc) = 'PS' then
        Result:= '17'
      else
        Result:= '99';
    end;

  end;
end;

function TACBrBancoItau.DefineTipoBeneficiario(const ACBrTitulo: TACBrTitulo): String;
var LTamanhoPagadorFinal : Byte;
begin
  LTamanhoPagadorFinal := Length(OnlyNumber(ACBrTitulo.Sacado.SacadoAvalista.CNPJCPF));
  if (ACBrTitulo.ACBrBoleto.LayoutRemessa = c400) AND (LTamanhoPagadorFinal > 0) then
  begin
    case LTamanhoPagadorFinal of
      11 : Result := '3'; //CPF DO PAGADOR FINAL
      14 : Result := '4'; //CNPJ DO PAGADOR FINAL
    else
      Result := '9';
    end;
  end else
  begin
    case ACBrTitulo.ACBrBoleto.Cedente.TipoInscricao of
      pFisica   : Result := '1'; //N DO CPF DO BENEFICI�RIO
      pJuridica : Result := '2'; //N DO CNPJ DO BENEFICI�RIO
    else
      Result := '9';
    end;
  end;
end;

function TACBrBancoItau.DefineTipoSacado(const ACBrTitulo: TACBrTitulo): String;
begin
  with ACBrTitulo do
  begin
    case Sacado.Pessoa of
        pFisica   : Result := '1';
        pJuridica : Result := '2';
     else
        Result := '9';
     end;

  end;
end;

procedure TACBrBancoItau.EhObrigatorioAgenciaDV;
begin
  //sem valida��o
end;

function TACBrBancoItau.DefinePosicaoNossoNumeroRetorno: Integer;
begin
  if ACBrBanco.ACBrBoleto.LayoutRemessa = c240 then
    Result := 41
  else
    Result := 63;
end;

function TACBrBancoItau.DefinePosicaoCarteiraRetorno: Integer;
begin
  if ACBrBanco.ACBrBoleto.LayoutRemessa = c240 then
    Result := 38
  else
    Result := 83;
end;

function TACBrBancoItau.InstrucoesProtesto(const ACBrTitulo: TACBrTitulo): String;
begin
  with ACBrTitulo do
  begin
    if ((DataProtesto > 0) and (DataProtesto > Vencimento)) then
    begin
      case TipoDiasProtesto of
        diCorridos : Result := '81';
        diUteis    : Result := '82';
      else
        Result := '';
      end;
    end else
    begin
      if ((DataNegativacao > 0) and (DataNegativacao > Vencimento)) then
        Result := '66'
      else
        Result := '';
    end;
      if (PadLeft(trim(Instrucao1),2,'0') = '00') and (Result <> '') then
        Instrucao1:= Result;
  end;
end;

function TACBrBancoItau.MontaInstrucoesCNAB400(const ACBrTitulo: TACBrTitulo;
  const nRegistro: Integer): String;
begin
  Result := '';
  with ACBrTitulo, ACBrBoleto do
  begin
    {Nenhum mensagem especificada. Registro n�o ser� necess�rio gerar o registro}
    if Mensagem.Count = 0 then
       Exit;

    Result := sLineBreak + '6'                        +                       // IDENTIFICA��O DO REGISTRO
              '2'                                     +                       // IDENTIFICA��O DO LAYOUT PARA O REGISTRO
              Copy(PadRight(Mensagem[0], 69, ' '), 1, 69);                    // CONTE�DO DA 1� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO

    if Mensagem.Count >= 2 then
       Result := Result + Copy(PadRight(Mensagem[1], 69, ' '), 1, 69)         // CONTE�DO DA 2� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
    else
       Result := Result + PadRight('', 69, ' ');                              // CONTE�DO DO RESTANTE DAS LINHAS

    if Mensagem.Count >= 3 then
       Result := Result + Copy(PadRight(Mensagem[2], 69, ' '), 1, 69)         // CONTE�DO DA 3� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
    else
      Result := Result + PadRight('', 69, ' ');                               // CONTE�DO DO RESTANTE DAS LINHAS

    if Mensagem.Count >= 4 then
       Result := Result + Copy(PadRight(Mensagem[3], 69, ' '), 1, 69)         // CONTE�DO DA 4� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
    else
       Result := Result + PadRight('', 69, ' ');                              // CONTE�DO DO RESTANTE DAS LINHAS

    if Mensagem.Count >= 5 then
       Result := Result + Copy(PadRight(Mensagem[4], 69, ' '), 1, 69)         // CONTE�DO DA 5� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
    else
       Result := Result + PadRight('', 69, ' ');                              // CONTE�DO DO RESTANTE DAS LINHAS

    Result := Result    +
              space(47) +                                                     // COMPLEMENTO DO REGISTRO
              IntToStrZero(nRegistro + 2, 6);                                 // N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO
  end;
end;

function TACBrBancoItau.ConverteEspecieDoc(const ACodigoEspecie: Integer): String;
begin
  if (ACodigoEspecie = 0) then
    Result := '99'
  else
    case ACodigoEspecie of
      01 : Result := 'DM';
      02 : Result := 'NP';
      03 : Result := 'NS';
      04 : Result := 'ME';
      05 : Result := 'RC';
      06 : Result := 'CT';
      07 : Result := 'CS';
      08 : Result := 'DS';
      09 : Result := 'LC';
      13 : Result := 'ND';
      15 : Result := 'DD';
      16 : Result := 'EC';
      17 : Result := 'PS';
      99 : Result := 'DV';
    else
      Result := 'DV';
    end;

end;

procedure TACBrBancoItau.DefineDataProtestoNegativacao(
  const ACBrTitulo: TACBrTitulo);
var
  ACodProtesto: String;
begin

  with ACBrTitulo do
  begin
    ACodProtesto :=  DefineCodigoProtesto(ACBrTitulo);
    if ( ACodProtesto = '7') then
      begin
        fDataProtestoNegativacao := DataNegativacao;
        fDiasProtestoNegativacao := IntToStr(DiasDeNegativacao);
      end
      else
      begin
        if ((ACodProtesto <> '3') and (ACodProtesto <> '8')) then
        begin
          fDataProtestoNegativacao := DataProtesto;
          fDiasProtestoNegativacao := IntToStr(DiasDeProtesto);
        end
        else
        begin
          fDataProtestoNegativacao := 0;
          fDiasProtestoNegativacao := '0';
        end;
      end;

  end;
end;

function TACBrBancoItau.MontarCampoNossoNumero ( const ACBrTitulo: TACBrTitulo
   ) : String;
var
  NossoNr: String;
begin
  with ACBrTitulo do
  begin
    NossoNr := Carteira + PadLeft(NossoNumero,TamanhoMaximoNossoNum,'0');
  end;

  Insert('/',NossoNr,4);  Insert('-',NossoNr,13);
  Result := NossoNr + CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoItau.MontarCampoCodigoCedente (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia  +'/'+
             ACBrTitulo.ACBrBoleto.Cedente.Conta    +'-'+
             ACBrTitulo.ACBrBoleto.Cedente.ContaDigito;
end;

function TACBrBancoItau.GerarRegistroTransacao240(ACBrTitulo : TACBrTitulo): String;
var
   ATipoInscricao,
   AEspecieDoc,
   ADataMoraJuros,
   ADataDesconto,
   ATipoAceite,
   ACodigoNegativacao,
   ATipoInscricaoAvalista: String;
   ListTransacao: TStringList;
begin
  ListTransacao:= TStringList.Create;
  try
    with ACBrTitulo do
    begin
       {SEGMENTO P}
       inc(fpQtdRegsCobranca);
       inc(fpQtdRegsLote);
       {Tipo de Ocorrencia}
       TipoOcorrenciaRemessa := TipoOcorrenciaToCodRemessa(ACBrTitulo.OcorrenciaOriginal.Tipo);

       {Especie Documento}
       AEspecieDoc := DefineEspecieDoc(ACBrTitulo);

       {Aceite do Titulo }
       ATipoAceite := DefineAceite(ACBrTitulo);

       {C�digo de Protesto/Negativa��o }
       ACodigoNegativacao := DefineCodigoProtesto(ACBrTitulo);
       DefineDataProtestoNegativacao(ACBrTitulo);

       {Data Mora}
       ADataMoraJuros := DefineDataMoraJuros(ACBrTitulo);

       {Data Desconto}
       ADataDesconto := DefineDataDesconto(ACBrTitulo);

       {Pegando tipo de pessoa do Sacado}
       ATipoInscricao := DefineTipoSacado(ACBrTitulo);

       {Pegando tipo de pessoa do Avalista}
       ATipoInscricaoAvalista:= DefineTipoSacadoAvalista(ACBrTitulo);

       VlrRegsCobranca:= VlrRegsCobranca  + ValorDocumento;

       ListTransacao.Add( IntToStrZero(ACBrBanco.Numero, 3)                + //1 a 3 - C�digo do banco
                '0001'                                                     + //4 a 7 - Lote de servi�o
                '3'                                                        + //8 - Tipo do registro: Registro detalhe
                IntToStrZero(fpQtdRegsLote ,5)                             + //9 a 13 - N�mero seq�encial do registro no lote - Cada registro possui dois segmentos
                'P'                                                        + //14 - C�digo do segmento do registro detalhe
                ' '                                                        + //15 - Uso exclusivo FEBRABAN/CNAB: Branco
                TipoOcorrenciaRemessa                                      + //16 a 17 - C�digo de movimento
                '0'                                                        + // 18
                PadLeft(OnlyNumber(ACBrBoleto.Cedente.Agencia),4,'0')      + //19 a 22 - Ag�ncia mantenedora da conta
                ' '                                                        + // 23
                '0000000'                                                  + //24 a 30 - Complemento de Registro
                PadLeft(OnlyNumber(ACBrBoleto.Cedente.Conta),5,'0')        + //31 a 35 - N�mero da Conta Corrente
                ' '                                                        + // 36
                ACBrBoleto.Cedente.ContaDigito                             + //37 - D�gito verificador da ag�ncia / conta
                PadLeft(Carteira, 3, ' ')                                  + // 38 a 40 - Carteira
                PadLeft(NossoNumero, 8, '0')                               + // 41 a 48 - Nosso n�mero - identifica��o do t�tulo no banco
                CalcularDigitoVerificador(ACBrTitulo)                      + // 49 - D�gito verificador da ag�ncia / conta preencher somente em cobran�a sem registro
                space(8)                                                   + // 50 a 57 - Brancos
                PadRight('', 5, '0')                                       + // 58 a 62 - Complemento
                PadRight(NumeroDocumento, 10, ' ')                         + // 63 a 72 - N�mero que identifica o t�tulo na empresa [ Alterado conforme instru��es da CSO Bras�lia ] {27-07-09}

                space(5)                                                   + // 73 a 77 - Brancos
                FormatDateTime('ddmmyyyy', Vencimento)                     + // 78 a 85 - Data de vencimento do t�tulo
                IntToStrZero( round( ValorDocumento * 100), 15)            + // 86 a 100 - Valor nominal do t�tulo
                '00000'                                                    + // 101 a 105 - Ag�ncia cobradora. // Ficando com Zeros o Ita� definir� a ag�ncia cobradora pelo CEP do sacado
                '0'                                                        + // 106 - D�gito da ag�ncia cobradora
                PadRight(AEspecieDoc,2)                                    + // 107 a 108 - Esp�cie do documento
                ATipoAceite                                                + // 109 - Identifica��o de t�tulo Aceito / N�o aceito
                FormatDateTime('ddmmyyyy', DataDocumento)                  + // 110 a 117 - Data da emiss�o do documento
                '0'                                                        + // 118 - Zeros
                ADataMoraJuros                                             + //119 a 126 - Data a partir da qual ser�o cobrados juros
                IfThen(ValorMoraJuros > 0, IntToStrZero( round(ValorMoraJuros * 100), 15),
                 PadLeft('', 15, '0'))                                     + //127 a 141 - Valor de juros de mora por dia
                '0'                                                        + // 142 - Zeros
                ADataDesconto                                              + // 143 a 150 - Data limite para desconto
                IfThen(ValorDesconto > 0, IntToStrZero( round(ValorDesconto * 100), 15),
                PadLeft('', 15, '0'))                                      + //151 a 165 - Valor do desconto por dia
                IntToStrZero( round(ValorIOF * 100), 15)                   + //166 a 180 - Valor do IOF a ser recolhido
                IntToStrZero( round(ValorAbatimento * 100), 15)            + //181 a 195 - Valor do abatimento
                PadRight(SeuNumero, 25, ' ')                               + //196 a 220 - Identifica��o do t�tulo na empresa
                ACodigoNegativacao                                         + //221 - C�digo de protesto: Protestar em XX dias corridos
                IfThen((DataProtestoNegativacao <> 0) and
                       (DataProtestoNegativacao > Vencimento),
                        PadLeft(DiasProtestoNegativacao , 2, '0'), '00')   + //222 a 223 - Prazo para protesto
                IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento), '1', '0')  + // 224 - C�digo de Baixa
                IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento),
                        PadLeft(IntToStr(DaysBetween(DataBaixa, Vencimento)), 2, '0'), '00')  + // 225 A 226 - Dias para baixa
                '0000000000000 ');


       {SEGMENTO Q}
       inc(fpQtdRegsLote);
       ListTransacao.Add( IntToStrZero(ACBrBanco.Numero, 3)                + //C�digo do banco
                '0001'                                                     + //N�mero do lote
                '3'                                                        + //Tipo do registro: Registro detalhe
                IntToStrZero(fpQtdRegsLote ,5)                             + //N�mero seq�encial do registro no lote - Cada registro possui dois segmentos
                'Q'                                                        + //C�digo do segmento do registro detalhe
                ' '                                                        + //Uso exclusivo FEBRABAN/CNAB: Branco
                TipoOcorrenciaRemessa                                      + // 16 a 17
                         {Dados do sacado}
                ATipoInscricao                                             + // 18 a 18 Tipo inscricao
                PadLeft(OnlyNumber(Sacado.CNPJCPF), 15, '0')               + // 19 a 33
                PadRight(Sacado.NomeSacado, 30, ' ')                       + // 34 a 63
                space(10)                                                  + // 64 a 73
                PadRight(Sacado.Logradouro +' '+ Sacado.Numero +' '+ Sacado.Complemento , 40, ' ') + // 74 a 113
                PadRight(Sacado.Bairro, 15, ' ')                           +  // 114 a 128
                PadLeft(Sacado.CEP, 8, '0')                                +  // 129 a 136
                PadRight(Sacado.Cidade, 15, ' ')                           +  // 137 a 151
                PadRight(Sacado.UF, 2, ' ')                                +  // 152 a 153
                         {Dados do sacador/avalista}
                ATipoInscricaoAvalista                                     + //Tipo de inscri��o: N�o informado
                PadLeft(Sacado.SacadoAvalista.CNPJCPF, 15, '0')            + //N�mero de inscri��o
                PadRight(Sacado.SacadoAvalista.NomeAvalista, 30, ' ')      + //Nome do sacador/avalista
                space(10)                                                  + //Uso exclusivo FEBRABAN/CNAB
                PadRight('0',3, '0')                                       + //Uso exclusivo FEBRABAN/CNAB
                space(28));                                                   //Uso exclusivo FEBRABAN/CNAB



       {Segmento R}
       if(MatchText(TipoOcorrenciaRemessa,['01','49','31']))then
       begin
         if (ValorDesconto2  > 0) or
            (ValorDesconto3  > 0) or
            (PercentualMulta > 0) then
         begin
           inc(fpQtdRegsLote);
           ListTransacao.Add(IntToStrZero(ACBrBanco.Numero,3)                         + // 001 a 003 - Codigo do Banco
                  '0001'                                                              + // 004 a 007 - Lote de Servi�o
                  '3'                                                                 + // 008 a 008 - Registro Detalhe
                  IntToStrZero(fpQtdRegsLote ,5)                                      + // 009 a 013 - Seq. Registro do Lote
                  'R'                                                                 + // 014 a 014 - Codigo do Segmento registro detalhe
                  ' '                                                                 + // 015 a 015 - Complemento de Registro
                  TipoOcorrenciaRemessa                                               + // 016 a 017 - Identifica��o da Ocorrencia
                  '0'                                                                 + // 018 a 018 - Complemento de Registro

                  IfThen(ValorDesconto2>0,FormatDateTime( 'ddmmyyyy', DataDesconto2),
                  StringOfChar('0',8))                                                + // 019 a 026 - Data Segundo Desconto

                  IntToStrZero(round(ValorDesconto2 * 100),15)                        + // 027 a 041 - Valor Segundo Desconto
                  '0'                                                                 + // 042 a 042 - Complemento de Registro

                  IfThen(ValorDesconto3>0,FormatDateTime( 'ddmmyyyy', DataDesconto3),
                  StringOfChar('0',8))                                                + // 043 a 050 - Data Terceiro Desconto

                  IntToStrZero(round(ValorDesconto3 * 100),15)                        + // 051 a 065 - Valor Terceiro Desconto

                  IfThen((PercentualMulta > 0),
                        IfThen(MultaValorFixo,'1','2'), '0')                          + // 066 a 066 1- Cobrar Multa Valor Fixo / 2- Percentual / 0-N�o cobrar multa
                  IfThen((PercentualMulta > 0),
                         FormatDateTime('ddmmyyyy', DataMulta), '00000000')           + // 067 a 074 Se cobrar informe a data para iniciar a cobran�a ou informe zeros se n�o cobrar
                  IfThen( (PercentualMulta > 0), IntToStrZero(round(PercentualMulta * 100), 15),
                           PadRight('', 15, '0'))                                     + // 075 a 089 Valor / Percentual de multa.

                  StringOfChar(' ',10)                                                + // 090 a 099 Complemento de Registro
                  StringOfChar(' ',40)                                                + // 100 a 139 Informa��o ao Pagador
                  StringOfChar(' ',60)                                                + // 140 a 199 Complemento de Registro
                  '00000000'                                                          + // 200 a 207 Codigo de Ocorrencia do Pagador
                  '00000000'                                                          + // 208 a 215 Complemento de Registro
                  ' '                                                                 + // 216 a 216 Complemento de Registro
                  StringOfChar('0',12)                                                + // 217 a 228 Complemento de Registro
                  '  '                                                                + // 229 a 230 Complemento de Registro
                  '0'                                                                 + // 231 a 231 Complemento de Registro
                  StringOfChar(' ',9));                                                 // 232 a 240 Complemento de Registro
         end;
       end;

    end;
    Result := RemoverQuebraLinhaFinal(ListTransacao.Text);
  finally
    ListTransacao.Free;
  end;
end;

function TACBrBancoItau.GerarRegistroTrailler240(ARemessa: TStringList): String;
begin

  Result:= inherited GerarRegistroTrailler240(ARemessa);
  fpQtdRegsLote     := 0;
  fpQtdRegsCobranca := 0;
end;

procedure TACBrBancoItau.GerarRegistroHeader400(
  NumeroRemessa: Integer; aRemessa: TStringList);
var
   wLinha: String;
begin
   with ACBrBanco.ACBrBoleto.Cedente do
   begin

      { GERAR REGISTRO-HEADER DO ARQUIVO }
      wLinha:=    '0'                                  + // 1 a 1     - IDENTIFICA��O DO REGISTRO HEADER
                  '1'                                  + // 2 a 2     - TIPO DE OPERA��O - REMESSA
                  'REMESSA'                            + // 3 a 9     - IDENTIFICA��O POR EXTENSO DO MOVIMENTO
                  '01'                                 + // 10 a 11   - IDENTIFICA��O DO TIPO DE SERVI�O
                  PadRight('COBRANCA',15, ' ')         + // 12 a 26   - IDENTIFICA��O POR EXTENSO DO TIPO DE SERVI�O
                  PadLeft(OnlyNumber(Agencia), 4, '0') + // 27 a 30   - AG�NCIA MANTENEDORA DA CONTA
                  '00'                                 + // 31 a 32   - COMPLEMENTO DE REGISTRO
                  PadLeft(Conta, 5, '0')               + // 33 a 37   - N�MERO DA CONTA CORRENTE DA EMPRESA
                  PadLeft(ContaDigito, 1, '0')         + // 38 a 38   - D�GITO DE AUTO CONFER�NCIA AG/CONTA EMPRESA
                  space(8)                             + // 39 a 46   - COMPLEMENTO DO REGISTRO
                  PadRight(Nome, 30, ' ')              + // 47 a 76   - NOME POR EXTENSO DA "EMPRESA M�E"
                  IntToStrZero(ACBrBanco.Numero, 3)    + // 77 a 79   - N� DO BANCO NA C�MARA DE COMPENSA��O
                  PadRight(fpNome, 15, ' ')            + // 80 a 94   - NOME POR EXTENSO DO BANCO COBRADOR
                  FormatDateTime('ddmmyy', Now)        + // 95 a 100  - DATA DE GERA��O DO ARQUIVO
                  space(294)                           + // 101 a 394 - COMPLEMENTO DO REGISTRO
                  IntToStrZero(1,6);                     // 395 a 400 - N�MERO SEQ�ENCIAL DO REGISTRO NO ARQUIVO
      aRemessa.Add(UpperCase(wLinha));
   end;
end;

procedure TACBrBancoItau.GerarRegistroTransacao400( ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
var
   ATipoCedente, ATipoSacado, ATipoSacadoAvalista, ATipoOcorrencia    :String;
   ADataMoraJuros, ADataDesconto, ATipoAceite    :String;
   ATipoEspecieDoc, ANossoNumero,wLinha,wCarteira :String;
   wLinhaMulta,LCPFCNPJBeneciciario :String;
   iSequencia : integer;

begin
   with ACBrTitulo do
   begin
     {Tipo de Ocorrencia}
     ATipoOcorrencia := TipoOcorrenciaToCodRemessa(ACBrTitulo.OcorrenciaOriginal.Tipo);

     {Aceite do Titulo }
     ATipoAceite := DefineAceite(ACBrTitulo);

     {Especie Documento}
     ATipoEspecieDoc := DefineEspecieDoc(ACBrTitulo);

     {Data Mora}
     ADataMoraJuros := DefineDataMoraJuros(ACBrTitulo, 'ddmmyy');

     {Descontos}
     ADataDesconto := DefineDataDesconto(ACBrTitulo, 'ddmmyy');

     {Pegando Tipo de Cedente}
     ATipoCedente := DefineTipoBeneficiario(ACBrTitulo);

     if (StrToIntDef(ATipoCedente,0) in [3..4]) then
       LCPFCNPJBeneciciario := OnlyNumber(ACBrTitulo.Sacado.SacadoAvalista.CNPJCPF)
     else
       LCPFCNPJBeneciciario := ACBrBoleto.Cedente.CNPJCPF;

     {Pegando Tipo de Sacado}
     ATipoSacado:= DefineTipoSacado(ACBrTitulo);

     {Pegando Tipo de Sacado Avalista}
     ATipoSacadoAvalista := DefineTipoSacadoAvalista(ACBrTitulo);

     {Pegando campo Intru��es conforme c�digo protesto}
     InstrucoesProtesto(ACBrTitulo);
     DefineDataProtestoNegativacao(ACBrTitulo);

    with ACBrBoleto do
    begin
       wCarteira:= Trim(Carteira);
       {Cobran�a sem registro com op��o de envio de arquivo remessa}
       if (wCarteira = '102') or (wCarteira = '103') or
          (wCarteira = '107') or (wCarteira = '172') or
          (wCarteira = '173') or (wCarteira = '196') then
        begin
          ANossoNumero := MontarCampoNossoNumero(ACBrTitulo);
          wLinha:= '6'                                                                            + // 6 - FIXO
                   '1'                                                                            + // 1 - FIXO
                   PadLeft(OnlyNumber(Cedente.Agencia), 4, '0')                                   + // AG�NCIA MANTENEDORA DA CONTA
                   '00'                                                                           + // COMPLEMENTO DE REGISTRO
                   PadLeft(OnlyNumber(Cedente.Conta), 5, '0')                                     + // N�MERO DA CONTA CORRENTE DA EMPRESA
                   PadRight(Cedente.ContaDigito, 1)                                               + // D�GITO DE AUTO CONFER�NCIA AG/CONTA EMPRESA
                   PadLeft(Carteira,3,' ')                                                        + // N�MERO DA CARTEIRA NO BANCO
                   PadLeft(NossoNumero, 8, '0')                                                   + // IDENTIFICA��O DO T�TULO NO BANCO
                   Copy(ANossoNumero, Length(ANossoNumero), 1)                                    + // DAC DO NOSSO N�MERO
                   '0'                                                                            + // 0 - R$
                   PadRight('R$', 4, ' ')                                                         + // LITERAL DE MOEDA
                   IntToStrZero( round( ValorDocumento * 100), 13)                                + // VALOR NOMINAL DO T�TULO
                   PadRight(SeuNumero, 10, ' ')                                                   + // IDENTIFICA��O DO T�TULO NA EMPRESA
                   FormatDateTime('ddmmyy', Vencimento)                                           + // DATA DE VENCIMENTO DO T�TULO
                   PadLeft(ATipoEspecieDoc, 2, '0')                                               + // ESP�CIE DO T�TULO
                   ATipoAceite                                                                    + // IDENTIFICA��O DE TITILO ACEITO OU N�O ACEITO
                   FormatDateTime('ddmmyy', DataDocumento)                                        + // DATA DE EMISS�O
                   {Dados do sacado}
                   PadLeft(ATipoSacado, 2, '0')                                                   + // IDENTIFICA��O DO TIPO DE INSCRI��O/SACADO
                   PadLeft(OnlyNumber(Sacado.CNPJCPF), 15, '0')                                   + // N� DE INSCRI��O DO SACADO  (CPF/CGC)
                   PadRight(Sacado.NomeSacado, 30, ' ')                                           + // NOME DO SACADO
                   space(9)                                                                       + // BRANCOS(COMPLEMENTO DE REGISTRO)
                   PadRight(Sacado.Logradouro + ' ' + Sacado.Numero + ' ' +
                            Sacado.Complemento , 40, ' ')                                         + // RUA, N�MERO E COMPLEMENTO DO SACADO
                   PadRight(Sacado.Bairro, 12, ' ')                                               + // BAIRRO DO SACADO
                   PadLeft(OnlyNumber(Sacado.CEP), 8, '0')                                        + // CEP DO SACADO
                   PadRight(Sacado.Cidade, 15, ' ')                                               + // CIDADE DO SACADO
                   PadRight(Sacado.UF, 2, ' ')                                                    + // UF DO SACADO
                   {Dados do sacador/avalista}
                   PadRight(Sacado.SacadoAvalista.NomeAvalista, 30, ' ')                          + // NOME DO SACADOR/AVALISTA
                   space(4)                                                                       + // COMPLEMENTO DO REGISTRO
                   PadRight(TiraAcentos(LocalPagamento), 55, ' ')                                 + // LOCAL PAGAMENTO
                   PadRight(' ', 55, ' ')                                                         + // LOCAL PAGAMENTO 2
                   '01'                                                                           + // IDENTIF. TIPO DE INSCRI��O DO SACADOR/AVALISTA
                   PadRight(Sacado.SacadoAvalista.CNPJCPF, 15, '0')                               + // N�MERO DE INSCRI��O DO SACADOR/AVALISTA
                   space(31)                                                                      + // COMPLEMENTO DO REGISTRO
                   IntToStrZero(aRemessa.Count + 1 , 6);                                            // N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO

          aRemessa.Add(UpperCase(wLinha));
          wLinha := MontaInstrucoesCNAB400(ACBrTitulo, aRemessa.Count );

         if not(wLinha = EmptyStr) then
           aRemessa.Add(UpperCase(wLinha));

          //Result := DoMontaInstrucoes2(Result);               // opcional
        end
       else
        {Carteira com registro}
        begin
          wLinha:= '1'                                                                            + // 1 a 1 - IDENTIFICA��O DO REGISTRO TRANSA��O
                   PadLeft(ATipoCedente,2,'0')                                                    + // TIPO DE INSCRI��O DA EMPRESA
                   PadLeft(OnlyNumber(LCPFCNPJBeneciciario),14,'0')                               + // N� DE INSCRI��O DA EMPRESA (CPF/CGC)
                   PadLeft(OnlyNumber(Cedente.Agencia), 4, '0')                                   + // AG�NCIA MANTENEDORA DA CONTA
                   '00'                                                                           + // COMPLEMENTO DE REGISTRO
                   PadLeft(OnlyNumber(Cedente.Conta), 5, '0')                                     + // N�MERO DA CONTA CORRENTE DA EMPRESA
                   PadRight(Cedente.ContaDigito, 1)                                               + // D�GITO DE AUTO CONFER�NCIA AG/CONTA EMPRESA
                   space(4)                                                                       + // COMPLEMENTO DE REGISTRO
                   '0000'                                                                         + // C�D.INSTRU��O/ALEGA��O A SER CANCELADA
                   PadRight(SeuNumero, 25, ' ')                                                   + // IDENTIFICA��O DO T�TULO NA EMPRESA
                   PadLeft(NossoNumero, 8, '0')                                                   + // IDENTIFICA��O DO T�TULO NO BANCO
                   '0000000000000'                                                                + // QUANTIDADE DE MOEDA VARI�VEL
                   PadLeft(Carteira,3,' ')                                                        + // N�MERO DA CARTEIRA NO BANCO
                   space(21)                                                                      + // IDENTIFICA��O DA OPERA��O NO BANCO
                   'I'                                                                            + // C�DIGO DA CARTEIRA
                   ATipoOcorrencia                                                                + // IDENTIFICA��O DA OCORR�NCIA
                   PadRight(NumeroDocumento, 10, ' ')                                             + // N� DO DOCUMENTO DE COBRAN�A (DUPL.,NP ETC.)
                   FormatDateTime('ddmmyy', Vencimento)                                           + // DATA DE VENCIMENTO DO T�TULO
                   IntToStrZero( round( ValorDocumento * 100), 13)                                + // VALOR NOMINAL DO T�TULO
                   IntToStrZero(ACBrBanco.Numero, 3)                                              + // N� DO BANCO NA C�MARA DE COMPENSA��O
                   '00000'                                                                        + // AG�NCIA ONDE O T�TULO SER� COBRADO
                   PadLeft(ATipoEspecieDoc, 2, '0')                                               + // ESP�CIE DO T�TULO
                   ATipoAceite                                                                    + // IDENTIFICA��O DE TITILO ACEITO OU N�O ACEITO
                   FormatDateTime('ddmmyy', DataDocumento)                                        + // DATA DA EMISS�O DO T�TULO
                   PadLeft(trim(ACBrStr(Instrucao1)), 2, '0')                                     + // 1� INSTRU��O
                   PadLeft(trim(ACBrStr(Instrucao2)), 2, '0')                                     + // 2� INSTRU��O
                   IntToStrZero( round(ValorMoraJuros * 100 ), 13)                                + // VALOR DE MORA POR DIA DE ATRASO
                   ADataDesconto                                                                  + // DATA LIMITE PARA CONCESS�O DE DESCONTO
                   IfThen(ValorDesconto > 0, IntToStrZero( round(ValorDesconto * 100), 13),
                   PadLeft('', 13, '0'))                                                          + // VALOR DO DESCONTO A SER CONCEDIDO
                   IntToStrZero( round(ValorIOF * 100), 13)                                       + // VALOR DO I.O.F. RECOLHIDO P/ NOTAS SEGURO
                   IntToStrZero( round(ValorAbatimento * 100), 13)                                + // VALOR DO ABATIMENTO A SER CONCEDIDO

                   {Dados do sacado}
                   PadLeft(ATipoSacado, 2, '0')                                                   + // IDENTIFICA��O DO TIPO DE INSCRI��O/SACADO
                   PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0')                                   + // N� DE INSCRI��O DO SACADO  (CPF/CGC)
                   PadRight(Sacado.NomeSacado, 30, ' ')                                           + // NOME DO SACADO
                   space(10)                                                                      + // BRANCOS(COMPLEMENTO DE REGISTRO)
                   PadRight(Sacado.Logradouro + ' '+ Sacado.Numero + ' ' +
                            Sacado.Complemento , 40, ' ')                                         + // RUA, N�MERO E COMPLEMENTO DO SACADO
                   PadRight(Sacado.Bairro, 12, ' ')                                               + // BAIRRO DO SACADO
                   PadLeft(OnlyNumber(Sacado.CEP), 8, '0')                                        + // CEP DO SACADO
                   PadRight(Sacado.Cidade, 15, ' ')                                               + // CIDADE DO SACADO
                   PadRight(Sacado.UF, 2, ' ')                                                    + // UF DO SACADO

                   {Dados do sacador/avalista}
                   PadRight(Sacado.SacadoAvalista.NomeAvalista, 30, ' ')                          + // NOME DO SACADOR/AVALISTA
                   space(4)                                                                       + // COMPLEMENTO DO REGISTRO
                   ADataMoraJuros                                                                 + // DATA DE MORA
                   IfThen((DataProtestoNegativacao <> 0) and (DataProtestoNegativacao > Vencimento),
                        PadLeft(DiasProtestoNegativacao , 2, '0'), '00')+ // PRAZO
                   space(1)                                                                       + // BRANCOS
                   IntToStrZero(aRemessa.Count + 1, 6);                                             // N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO

                   iSequencia := aRemessa.Count + 1;
                   aRemessa.Add(UpperCase(wLinha));
                   //Registro Complemento Detalhe - Multa
                   if PercentualMulta > 0 then
                   begin
                     inc( iSequencia );
                     wLinhaMulta:= '2'                                              + // Tipo de registro - 2 OPCIONAL � COMPLEMENTO DETALHE - MULTA
                                   IfThen(MultaValorFixo,'1','2')                   + // Cocidgo da Multa 1- Cobrar Multa Valor Fixo / 2- Percentual / 0-N�o cobrar multa
                                   ifThen((DataMulta > 0),
                                           FormatDateTime('ddmmyyyy',  DataMulta),
                                           Poem_Zeros('',8))                        + // Data da Multa 9(008)
                                   IntToStrZero( round(PercentualMulta * 100 ), 13) + // Valor/Percentual 9(013)
                                   space(371)                                       + // Complemento
                                   IntToStrZero(iSequencia , 6);                      // Sequencial

                     aRemessa.Add(UpperCase(wLinhaMulta));
                   end;

                  {Registro H�brido - Bolecode}
                  if (NaoEstaVazio(ACBrBoleto.Cedente.PIX.Chave)) then
                  begin
                    wLinha := '3'                                              + // 001 a 001 - Identifica��o do registro bolecode (3)
                              PadRight(IfThen(QrCode.txId = '', ACBrBoleto.Cedente.PIX.Chave, ''), 77, ' ') + // 002 a 078 - Chave Pix (opicional)
                              PadRight(QrCode.txId,  64, ' ')                  + // 079 a 142 - ID DA URL DO QR CODE PIX (opcional)
                              PadRight('', 252, ' ')                                                          + // 143 a 394 - Brancos
                              IntToStrZero(ARemessa.Count + 1, 6);
                    iSequencia := aRemessa.Count + 1;                                                                        // 395 a 400 - N�mero sequencial do registro
                    ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
                  end;

                   //OPCIONAL � COBRAN�A E-MAIL E/OU DADOS DO SACADOR AVALISTA
                   if (Sacado.Email <> '') or (Sacado.SacadoAvalista.CNPJCPF <> '') then
                   begin
                     inc( iSequencia );
                     wLinhaMulta:= '5'                                                          + // 001 - 001 Tipo de registro - 5 IDENTIFICA��O DO REGISTRO TRANSA��O
                                   PadRight(Sacado.Email, 120, ' ')                             + // 002 - 121 ENDERE�O DE E-MAIL ENDERE�O DE E-MAIL DO PAGADOR
                                   PadLeft(ATipoSacadoAvalista, 2, '0')                         + // 122 - 123 C�DIGO DE INSCRI��O IDENT. DO TIPO DE INSCRI��O DO SACADOR/AVALISTA
                                   PadLeft(OnlyNumber(Sacado.SacadoAvalista.CNPJCPF), 14, '0')  + // 124 - 137 N�MERO DE INSCRI��O N�MERO DE INSCRI��O DO SACADOR AVALISTA
                                   PadRight(Sacado.SacadoAvalista.Logradouro + ' '              +
                                   Sacado.SacadoAvalista.Numero + ' '                           +
                                   Sacado.SacadoAvalista.Complemento , 40, ' ')                 + // 138 - 177 RUA, N� E COMPLEMENTO DO SACADOR AVALISTA
                                   PadRight(Sacado.SacadoAvalista.Bairro, 12, ' ')              + // 178 - 189 BAIRRO DO SACADOR AVALISTA
                                   PadLeft(OnlyNumber(Sacado.SacadoAvalista.CEP), 8, '0')       + // 190 - 197 CEP DO SACADOR AVALISTA
                                   PadRight(Sacado.SacadoAvalista.Cidade, 15, ' ')              + // 198 - 212 CIDADE DO SACADOR AVALISTA
                                   PadRight(Sacado.SacadoAvalista.UF, 2, ' ')                   + // 213 - 214 UF (ESTADO) DO SACADOR AVALISTA
                                   space(139)                                                   + // 215 - 353 Brancos
                                   //para se operar com mais de um desconto (depende de cadastramento pr�vio do indicador 19.0 pelo Ita�, conforme Item 5)
                                   IfThen(ValorDesconto2>0,                                       // Alternativamente este campo poder� ter dois outros usos  (SACADOR/AVALISTA ou 2 e 3 descontos)

                                          FormatDateTime('ddmmyy', DataDesconto2),                // 354 - 359 Data do 2� desconto (DDMMAA)
                                          space(6))                                             +
                                   IfThen(ValorDesconto2>0,
                                          IntToStrZero(round(ValorDesconto2 * 100), 13),          // 360 - 372 Valor do 2� desconto
                                          space(13))                                            +
                                   IfThen(ValorDesconto3>0,
                                          FormatDateTime('ddmmyy', DataDesconto3),                // 373 - 378 Data do 3� desconto (DDMMAA)
                                          space(6))                                             +
                                   IfThen(ValorDesconto3>0,
                                          IntToStrZero(round(ValorDesconto3 * 100), 13),          // 379 - 391 Valor do 3� desconto
                                          space(13))                                            +

                                   space(3)                                                     + // 392 - 394 COMPLEMENTO DE REGISTRO
                                   IntToStrZero(iSequencia , 6);                                  // 395 - 400 Sequencial

                     aRemessa.Add(UpperCase(wLinhaMulta));
                   end;
        end;
    end;
  end;
end;

procedure TACBrBancoItau.LerRetorno400(ARetorno: TStringList);
var
  ContLinha, CodOCorrencia, I    : Integer;
  MotivoLinha, wMotivoRejeicaoCMD: Integer;
  Linha, rCedente, rDigitoConta  : String ;
  rCNPJCPF,rAgencia,rConta       : String;
  Titulo: TACBrTitulo;
begin

  if StrToIntDef(copy(ARetorno.Strings[0],77,3),-1) <> Numero then
    raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                                   'n�o � um arquivo de retorno do '+ Nome));

  rCedente     := trim(Copy(ARetorno[0],47,30));
  rAgencia     := trim(Copy(ARetorno[0],27,4));
  rConta       := trim(Copy(ARetorno[0],33,5));
  rDigitoConta := Copy(ARetorno[0],38,1);

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0],109,5),0);

  ACBrBanco.ACBrBoleto.DataArquivo   := StringToDateTimeDef(Copy(ARetorno[0],95,2)+'/'+
                                                            Copy(ARetorno[0],97,2)+'/'+
                                                            Copy(ARetorno[0],99,2),0, 'DD/MM/YY' );

  ACBrBanco.ACBrBoleto.DataCreditoLanc := StringToDateTimeDef(Copy(ARetorno[0],114,2)+'/'+
                                                              Copy(ARetorno[0],116,2)+'/'+
                                                              Copy(ARetorno[0],118,2),0, 'DD/MM/YY' );

  case StrToIntDef(Copy(ARetorno[1],2,2),0) of
    1 : rCNPJCPF:= Copy(ARetorno[1],07,11);
    2 : rCNPJCPF:= Copy(ARetorno[1],04,14);
  else
    rCNPJCPF:= Copy(ARetorno[1],4,14);
  end;

  ValidarDadosRetorno(rAgencia, rConta, rCNPJCPF);
  with ACBrBanco.ACBrBoleto do
  begin
    case StrToIntDef(Copy(ARetorno[1],2,2),0) of
      01: Cedente.TipoInscricao:= pFisica;
    else
      Cedente.TipoInscricao:= pJuridica;
    end;

    Cedente.Nome         := rCedente;
    Cedente.CNPJCPF      := rCNPJCPF;
    Cedente.Agencia      := rAgencia;
    Cedente.AgenciaDigito:= '0';
    Cedente.Conta        := rConta;
    Cedente.ContaDigito  := rDigitoConta;

    ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
  end;

  for ContLinha := 1 to ARetorno.Count - 2 do
  begin
    Linha := ARetorno[ContLinha] ;

    if Linha[1] = '1' then
      Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

    with Titulo do
    begin
      if Linha[1] = '1' then
      begin
        SeuNumero                   := copy(Linha,38,25);
        NumeroDocumento             := copy(Linha,117,10);
        Carteira                    := copy(Linha,83,3);

        OcorrenciaOriginal.Tipo     := CodOcorrenciaToTipo(StrToIntDef(copy(Linha,109,2),0));
        Sacado.NomeSacado           := copy(Linha,325,30);

        if OcorrenciaOriginal.Tipo in [toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente,
                                       toRetornoAlegacaoDoSacado, toRetornoInstrucaoCancelada] then
        begin
          MotivoLinha := 302;
          wMotivoRejeicaoCMD:= StrToIntDef(Copy(Linha, MotivoLinha, 4), 0);

          if wMotivoRejeicaoCMD <> 0 then
          begin
            MotivoRejeicaoComando.Add(Copy(Linha, MotivoLinha, 4));
            CodOcorrencia := StrToIntDef(MotivoRejeicaoComando[0], 0);
            DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, CodOcorrencia));
          end;
        end
        else
        begin
          MotivoLinha := 378;
        for I := 0 to 3 do
        begin
          wMotivoRejeicaoCMD:= StrToIntDef(Copy(Linha, MotivoLinha, 2),0);

        if wMotivoRejeicaoCMD <> 0 then
        begin
          MotivoRejeicaoComando.Add(Copy(Linha, MotivoLinha, 2));
          CodOcorrencia := StrToIntDef(MotivoRejeicaoComando[I], 0) ;
         DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, CodOcorrencia));
        end;

          MotivoLinha := MotivoLinha + 2;
        end;
      end;

        DataOcorrencia := StringToDateTimeDef( Copy(Linha,111,2)+'/'+
                                            Copy(Linha,113,2)+'/'+
                                            Copy(Linha,115,2),0, 'DD/MM/YY' );

        {Esp�cie do documento}
        EspecieDoc := ConverteEspecieDoc(StrToIntDef(Copy(Linha,174,2),0));

        Vencimento := StringToDateTimeDef( Copy(Linha,147,2)+'/'+
                                          Copy(Linha,149,2)+'/'+
                                          Copy(Linha,151,2),0, 'DD/MM/YY' );

        ValorDocumento       := StrToFloatDef(Copy(Linha,153,13),0)/100;
        ValorIOF             := StrToFloatDef(Copy(Linha,215,13),0)/100;
        ValorAbatimento      := StrToFloatDef(Copy(Linha,228,13),0)/100;
        ValorDesconto        := StrToFloatDef(Copy(Linha,241,13),0)/100;
        ValorMoraJuros       := StrToFloatDef(Copy(Linha,267,13),0)/100;
        ValorOutrosCreditos  := StrToFloatDef(Copy(Linha,280,13),0)/100;
        ValorRecebido        := StrToFloatDef(Copy(Linha,254,13),0)/100;
        NossoNumero          := Copy(Linha,63,8);
        Carteira             := Copy(Linha,83,3);
        ValorDespesaCobranca := StrToFloatDef(Copy(Linha,176,13),0)/100;
        CodigoLiquidacao     := Copy(Linha,393,2);
        CodigoLiquidacaoDescricao := CodigoLiquidacao_Descricao( CodigoLiquidacao );
        // informa��es do local de pagamento
        Liquidacao.Banco      := StrToIntDef(Copy(Linha,166,3), -1);
        Liquidacao.Agencia    := Copy(Linha,169,4);
        Liquidacao.Origem     := '';

        if StrToIntDef(Copy(Linha,296,6),0) <> 0 then
         DataCredito:= StringToDateTimeDef( Copy(Linha,296,2)+'/'+
                                            Copy(Linha,298,2)+'/'+
                                            Copy(Linha,300,2),0, 'DD/MM/YY' );

        if StrToIntDef(Copy(Linha,111,6),0) <> 0 then
         DataBaixa := StringToDateTimeDef(Copy(Linha,111,2)+'/'+
                                          Copy(Linha,113,2)+'/'+
                                          Copy(Linha,115,2),0,'DD/MM/YY');

      end;
      if Linha[1] = '3' then
        QrCode.emv := trim(copy(Linha,2,390));
    end;
   end;
end;

function TACBrBancoItau.TipoOcorrenciaToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
 CodOcorrencia: Integer;
begin
  Result := '';
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia),0);

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case CodOcorrencia of
      94: Result := '94-Confirma Recebimento de Instru��o de n�o Negativar';
    end;
  end
  else
  begin
    case CodOcorrencia of
      07: Result := '07-Liquida��o Parcial � Cobran�a Inteligente';
      59: Result := '59-Baixa Por Cr�dito em C/C Atrav�s do Sispag';
      64: Result := '64-Entrada Confirmada com Rateio de Cr�dito';
      65: Result := '65-Pagamento com Cheque � Aguardando Compensa��o';
      69: Result := '69-Cheque Devolvido';
      71: Result := '71-Entrada Registrada Aguardando Avalia��o';
      72: Result := '72-Baixa Por Cr�dito em C/C Atrav�s do Sispag Sem T�tulo Correspondente';
      73: Result := '73-Confirma��o de Entrada na Cobran�a Simples � Entrada n�o Aceita na Cobran�a Contratual';
      76: Result := '76-Cheque Compensado';
    end;
  end;

  if (Result <> '') then
  begin
    Result := ACBrSTr(Result);
    Exit;
  end;

  case CodOcorrencia of
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    04: Result := '04-Altera��o de Dados - Nova Entrada ou Altera��o/Exclus�o de Dados Acatada';
    05: Result := '05-Altera��o de Dados - Baixa';
    06: Result := '06-Liquida��o Normal';
    07: Result := '07-Liquida��o Parcial - Cobran�a Inteligente' ;
    08: Result := '08-Liquida��o em Cart�rio';
    09: Result := '09-Baixa Simples' ;
    10: Result := '10-Baixa por ter sido Liquidado' ;
    11: Result := '11-Em Ser';
    12: Result := '12-Abatimento Concedido';
    13: Result := '13-Abatimento Cancelado';
    14: Result := '14-Vencimento Alterado';
    15: Result := '15-Baixas Rejeitadas';
    16: Result := '16-Instru��es Rejeitadas';
    17: Result := '17-Altera��o/Exclus�o de Dados Rejeitados';
    18: Result := '18-Cobran�a Contratual - Instru��es/Altera��es Rejeitadas/Pendentes';
    19: Result := '19-Confirma Recebimento de Instru��o de Protesto';
    20: Result := '20-Confirma Recebimento de Instru��o de Susta��o de Protesto/Tarifa';
    21: Result := '21-Confirma Recebimento de Instru��o de n�o Protestar';
    23: Result := '23-T�tulo Enviado A Cart�rio/Tarifa';
    24: Result := '24-Instru��o de Protesto Rejeitada / Sustada / Pendente';
    25: Result := '25-Alega��es do Pagador';
    26: Result := '26-Tarifa de Aviso de Cobran�a';
    27: Result := '27-Tarifa de Extrato Posi��o' ;
    28: Result := '28-Tarifa de Rela��o das Liquida��es';
    29: Result := '29-Tarifa de Manuten��o de T�tulos Vencidos';
    30: Result := '30-D�bito Mensal de Tarifas';
    32: Result := '32-Baixa por ter sido Protestado';
    33: Result := '33-Custas de Protesto';
    34: Result := '34-Custas de Susta��o';
    35: Result := '35-Custas de Cart�rio Distribuidor';
    36: Result := '36-Custas de Edital';
    37: Result := '37-Tarifa de Emiss�o de Boleto/Tarifa de Envio de Duplicata';
    38: Result := '38-Tarifa de Instru��o';
    39: Result := '39-Tarifa de Ocorr�ncias';
    40: Result := '40-Tarifa Mensal de Emiss�o de Boleto/Tarifa Mensal de Envio De Duplicata';
    41: Result := '41-D�bito Mensal de Tarifas - Extrato de Posi��o';
    42: Result := '42-D�bito Mensal de Tarifas - Outras Instru��es';
    43: Result := '43-D�bito Mensal de Tarifas - Manuten��o de T�tulos Vencidos';
    44: Result := '44-D�bito Mensal de Tarifas - Outras Ocorr�ncias';
    45: Result := '45-D�bito Mensal de Tarifas - Protesto';
    46: Result := '46-D�bito Mensal de Tarifas - Susta��o de Protesto';
    47: Result := '47-Baixa com Transfer�ncia para Desconto';
    48: Result := '48-Custas de Susta��o Judicial';
    49: Result := '49-Altera��o de dados extras';
    51: Result := '51-Tarifa Mensal Referente a Entradas Bancos Correspondentes na Carteira';
    52: Result := '52-Tarifa Mensal Baixas na Carteira';
    53: Result := '53-Tarifa Mensal Baixas em Bancos Correspondentes na Carteira';
    54: Result := '54-Tarifa Mensal de Liquida��es na Carteira';
    55: Result := '55-Tarifa Mensal de Liquida��es em Bancos Correspondentes na Carteira';
    56: Result := '56-Custas de Irregularidade';
    57: Result := '57-Instru��o Cancelada';
    60: Result := '60-Entrada Rejeitada Carn�';
    61: Result := '61-Tarifa Emiss�o Aviso de Movimenta��o de T�tulos';
    62: Result := '62-D�bito Mensal de Tarifa - Aviso de Movimenta��o de T�tulos';
    63: Result := '63-T�tulo Sustado Judicialmente';
    74: Result := '74-Instru��o de Negativa��o Expressa Rejeitada';
    75: Result := '75-Confirma��o de Recebimento de Instru��o de Entrada em Negativa��o Expressa';
    77: Result := '77-Confirma��o de Recebimento de Instru��o de Exclus�o de Entrada em Negativa��o Expressa';
    78: Result := '78-Confirma��o de Recebimento de Instru��o de Cancelamento de Negativa��o Expressa';
    79: Result := '79-Negativa��o Expressa Informacional';
    80: Result := '80-Confirma��o de Entrada em Negativa��o Expressa � Tarifa';
    82: Result := '82-Confirma��o do Cancelamento de Negativa��o Expressa � Tarifa';
    83: Result := '83-Confirma��o de Exclus�o de Entrada em Negativa��o Expressa Por Liquida��o � Tarifa';
    85: Result := '85-Tarifa Por Boleto (At� 03 Envios) Cobran�a Ativa Eletr�nica';
    86: Result := '86-Tarifa Email Cobran�a Ativa Eletr�nica';
    87: Result := '87-Tarifa SMS Cobran�a Ativa Eletr�nica';
    88: Result := '88-Tarifa Mensal Por Boleto (At� 03 Envios) Cobran�a Ativa Eletr�nica';
    89: Result := '89-Tarifa Mensal Email Cobran�a Ativa Eletr�nica';
    90: Result := '90-Tarifa Mensal SMS Cobran�a Ativa Eletr�nica';
    91: Result := '91-Tarifa Mensal de Exclus�o de Entrada de Negativa��o Expressa';
    92: Result := '92-Tarifa Mensal de Cancelamento de Negativa��o Expressa';
    93: Result := '93-Tarifa Mensal de Exclus�o de Negativa��o Expressa Por Liquida��o';
  end;

  Result := ACBrSTr(Result);
end;

function TACBrBancoItau.CodOcorrenciaToTipo(
  const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  Result := toTipoOcorrenciaNenhum;

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case CodOcorrencia of
      94: Result := toRetornoConfirmaRecebimentoInstrucaoNaoNegativar;
    end;
  end
  else
  begin
    case CodOcorrencia of
      07: Result := toRetornoLiquidadoParcialmente;
      59: Result := toRetornoBaixaCreditoCCAtravesSispag;
      64: Result := toRetornoEntradaConfirmadaRateioCredito;
      65: Result := toRetornoChequePendenteCompensacao;
      69: Result := toRetornoChequeDevolvido;
      71: Result := toRetornoEntradaRegistradaAguardandoAvaliacao;
      72: Result := toRetornoBaixaCreditoCCAtravesSispagSemTituloCorresp;
      73: Result := toRetornoConfirmacaoEntradaCobrancaSimples;
      76: Result := toRetornoChequeCompensado;
    end;
  end;

  if (Result <> toTipoOcorrenciaNenhum) then
    Exit;

  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    04: Result := toRetornoAlteracaoDadosNovaEntrada;
    05: Result := toRetornoAlteracaoDadosBaixa;
    06: Result := toRetornoLiquidado;
    08: Result := toRetornoLiquidadoEmCartorio;
    09: Result := toRetornoBaixaSimples;
    10: Result := toRetornoBaixaPorTerSidoLiquidado;
    11: Result := toRetornoTituloEmSer;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoBaixaRejeitada;
    16: Result := toRetornoInstrucaoRejeitada;
    17: Result := toRetornoAlteracaoDadosRejeitados;
    18: Result := toRetornoCobrancaContratual;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    21: Result := toRetornoRecebimentoInstrucaoNaoProtestar;
    23: Result := toRetornoEncaminhadoACartorio;
    24: Result := toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente;
    25: Result := toRetornoAlegacaoDoSacado;
    26: Result := toRetornoTarifaAvisoCobranca;
    27: Result := toRetornoTarifaExtratoPosicao;
    28: Result := toRetornoTarifaDeRelacaoDasLiquidacoes;
    29: Result := toRetornoTarifaDeManutencaoDeTitulosVencidos;
    30: Result := toRetornoDebitoTarifas;
    32: Result := toRetornoBaixaPorProtesto;
    33: Result := toRetornoCustasProtesto;
    34: Result := toRetornoCustasSustacao;
    35: Result := toRetornoCustasCartorioDistribuidor;
    36: Result := toRetornoCustasEdital;
    37: Result := toRetornoTarifaEmissaoBoletoEnvioDuplicata;
    38: Result := toRetornoTarifaInstrucao;
    39: Result := toRetornoTarifaOcorrencias;
    40: Result := toRetornoTarifaMensalEmissaoBoletoEnvioDuplicata;
    41: Result := toRetornoDebitoMensalTarifasExtradoPosicao;
    42: Result := toRetornoDebitoMensalTarifasOutrasInstrucoes;
    43: Result := toRetornoDebitoMensalTarifasManutencaoTitulosVencidos;
    44: Result := toRetornoDebitoMensalTarifasOutrasOcorrencias;
    45: Result := toRetornoDebitoMensalTarifasProtestos;
    46: Result := toRetornoDebitoMensalTarifasSustacaoProtestos;
    47: Result := toRetornoBaixaTransferenciaParaDesconto;
    48: Result := toRetornoCustasSustacaoJudicial;
    51: Result := toRetornoTarifaMensalRefEntradasBancosCorrespCarteira;
    52: Result := toRetornoTarifaMensalBaixasCarteira;
    53: Result := toRetornoTarifaMensalBaixasBancosCorrespCarteira;
    54: Result := toRetornoTarifaMensalLiquidacoesCarteira;
    55: Result := toRetornoTarifaMensalLiquidacoesBancosCorrespCarteira;
    56: Result := toRetornoCustasIrregularidade;
    57: Result := toRetornoInstrucaoCancelada;
    60: Result := toRetornoEntradaRejeitadaCarne;
    61: Result := toRetornoTarifaEmissaoAvisoMovimentacaoTitulos;
    62: Result := toRetornoDebitoMensalTarifaAvisoMovimentacaoTitulos;
    63: Result := toRetornoTituloSustadoJudicialmente;
    74: Result := toRetornoInstrucaoNegativacaoExpressaRejeitada;
    75: Result := toRetornoConfRecebimentoInstEntradaNegativacaoExpressa;
    77: Result := toRetornoConfRecebimentoInstExclusaoEntradaNegativacaoExpressa;
    78: Result := toRetornoConfRecebimentoInstCancelamentoNegativacaoExpressa;
    79: Result := toRetornoNegativacaoExpressaInformacional;
    80: Result := toRetornoConfEntradaNegativacaoExpressaTarifa;
    82: Result := toRetornoConfCancelamentoNegativacaoExpressaTarifa;
    83: Result := toRetornoConfExclusaoEntradaNegativacaoExpressaPorLiquidacaoTarifa;
    85: Result := toRetornoTarifaPorBoletoAte03EnvioCobrancaAtivaEletronica;
    86: Result := toRetornoTarifaEmailCobrancaAtivaEletronica;
    87: Result := toRetornoTarifaSMSCobrancaAtivaEletronica;
    88: Result := toRetornoTarifaMensalPorBoletoAte03EnvioCobrancaAtivaEletronica;
    89: Result := toRetornoTarifaMensalEmailCobrancaAtivaEletronica;
    90: Result := toRetornoTarifaMensalSMSCobrancaAtivaEletronica;
    91: Result := toRetornoTarifaMensalExclusaoEntradaNegativacaoExpressa;
    92: Result := toRetornoTarifaMensalCancelamentoNegativacaoExpressa;
    93: Result := toRetornoTarifaMensalExclusaoNegativacaoExpressaPorLiquidacao;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoItau.TipoOcorrenciaToCod(
  const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  Result := '';

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case TipoOcorrencia of
      toRetornoConfirmaRecebimentoInstrucaoNaoNegativar                : Result := '94';
    end;
  end
  else
  begin
    case TipoOcorrencia of
      toRetornoLiquidadoParcialmente                                   : Result := '07';
      toRetornoBaixaCreditoCCAtravesSispag                             : Result := '59';
      toRetornoEntradaConfirmadaRateioCredito                          : Result := '64';
      toRetornoChequePendenteCompensacao                               : Result := '65';
      toRetornoChequeDevolvido                                         : Result := '69';
      toRetornoEntradaRegistradaAguardandoAvaliacao                    : Result := '71';
      toRetornoBaixaCreditoCCAtravesSispagSemTituloCorresp             : Result := '72';
      toRetornoConfirmacaoEntradaCobrancaSimples                       : Result := '73';
      toRetornoChequeCompensado                                        : Result := '76';
    end;
  end;

  if (Result <> '') then
    Exit;

  case TipoOcorrencia of
    toRetornoRegistroConfirmado                                        : Result := '02';
    toRetornoRegistroRecusado                                          : Result := '03';
    toRetornoAlteracaoDadosNovaEntrada                                 : Result := '04';
    toRetornoAlteracaoDadosBaixa                                       : Result := '05';
    toRetornoLiquidado                                                 : Result := '06';
    toRetornoLiquidadoEmCartorio                                       : Result := '08';
    toRetornoBaixaSimples                                              : Result := '09';
    toRetornoBaixaPorTerSidoLiquidado                                  : Result := '10';
    toRetornoTituloEmSer                                               : Result := '11';
    toRetornoAbatimentoConcedido                                       : Result := '12';
    toRetornoAbatimentoCancelado                                       : Result := '13';
    toRetornoVencimentoAlterado                                        : Result := '14';
    toRetornoBaixaRejeitada                                            : Result := '15';
    toRetornoInstrucaoRejeitada                                        : Result := '16';
    toRetornoAlteracaoDadosRejeitados                                  : Result := '17';
    toRetornoCobrancaContratual                                        : Result := '18';
    toRetornoRecebimentoInstrucaoProtestar                             : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto                        : Result := '20';
    toRetornoRecebimentoInstrucaoNaoProtestar                          : Result := '21';
    toRetornoEncaminhadoACartorio                                      : Result := '23';
    toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente               : Result := '24';
    toRetornoAlegacaoDoSacado                                          : Result := '25';
    toRetornoTarifaAvisoCobranca                                       : Result := '26';
    toRetornoTarifaExtratoPosicao                                      : Result := '27';
    toRetornoTarifaDeRelacaoDasLiquidacoes                             : Result := '28';
    toRetornoTarifaDeManutencaoDeTitulosVencidos                       : Result := '29';
    toRetornoDebitoTarifas                                             : Result := '30';
    toRetornoBaixaPorProtesto                                          : Result := '32';
    toRetornoCustasProtesto                                            : Result := '33';
    toRetornoCustasSustacao                                            : Result := '34';
    toRetornoCustasCartorioDistribuidor                                : Result := '35';
    toRetornoCustasEdital                                              : Result := '36';
    toRetornoTarifaEmissaoBoletoEnvioDuplicata                         : Result := '37';
    toRetornoTarifaInstrucao                                           : Result := '38';
    toRetornoTarifaOcorrencias                                         : Result := '39';
    toRetornoTarifaMensalEmissaoBoletoEnvioDuplicata                   : Result := '40';
    toRetornoDebitoMensalTarifasExtradoPosicao                         : Result := '41';
    toRetornoDebitoMensalTarifasOutrasInstrucoes                       : Result := '42';
    toRetornoDebitoMensalTarifasManutencaoTitulosVencidos              : Result := '43';
    toRetornoDebitoMensalTarifasOutrasOcorrencias                      : Result := '44';
    toRetornoDebitoMensalTarifasProtestos                              : Result := '45';
    toRetornoDebitoMensalTarifasSustacaoProtestos                      : Result := '46';
    toRetornoBaixaTransferenciaParaDesconto                            : Result := '47';
    toRetornoCustasSustacaoJudicial                                    : Result := '48';
    toRetornoTarifaMensalRefEntradasBancosCorrespCarteira              : Result := '51';
    toRetornoTarifaMensalBaixasCarteira                                : Result := '52';
    toRetornoTarifaMensalBaixasBancosCorrespCarteira                   : Result := '53';
    toRetornoTarifaMensalLiquidacoesCarteira                           : Result := '54';
    toRetornoTarifaMensalLiquidacoesBancosCorrespCarteira              : Result := '55';
    toRetornoCustasIrregularidade                                      : Result := '56';
    toRetornoInstrucaoCancelada                                        : Result := '57';
    toRetornoEntradaRejeitadaCarne                                     : Result := '60';
    toRetornoTarifaEmissaoAvisoMovimentacaoTitulos                     : Result := '61';
    toRetornoDebitoMensalTarifaAvisoMovimentacaoTitulos                : Result := '62';
    toRetornoTituloSustadoJudicialmente                                : Result := '63';
    toRetornoInstrucaoNegativacaoExpressaRejeitada                     : Result := '74';
    toRetornoConfRecebimentoInstEntradaNegativacaoExpressa             : Result := '75';
    toRetornoConfRecebimentoInstExclusaoEntradaNegativacaoExpressa     : Result := '77';
    toRetornoConfRecebimentoInstCancelamentoNegativacaoExpressa        : Result := '78';
    toRetornoNegativacaoExpressaInformacional                          : Result := '79';
    toRetornoConfEntradaNegativacaoExpressaTarifa                      : Result := '80';
    toRetornoConfCancelamentoNegativacaoExpressaTarifa                 : Result := '82';
    toRetornoConfExclusaoEntradaNegativacaoExpressaPorLiquidacaoTarifa : Result := '83';
    toRetornoTarifaPorBoletoAte03EnvioCobrancaAtivaEletronica          : Result := '85';
    toRetornoTarifaEmailCobrancaAtivaEletronica                        : Result := '86';
    toRetornoTarifaSMSCobrancaAtivaEletronica                          : Result := '87';
    toRetornoTarifaMensalPorBoletoAte03EnvioCobrancaAtivaEletronica    : Result := '88';
    toRetornoTarifaMensalEmailCobrancaAtivaEletronica                  : Result := '89';
    toRetornoTarifaMensalSMSCobrancaAtivaEletronica                    : Result := '90';
    toRetornoTarifaMensalExclusaoEntradaNegativacaoExpressa            : Result := '91';
    toRetornoTarifaMensalCancelamentoNegativacaoExpressa               : Result := '92';
    toRetornoTarifaMensalExclusaoNegativacaoExpressaPorLiquidacao      : Result := '93';
  else
    Result := '02';
  end;
end;

function TACBrBancoItau.CodMotivoRejeicaoToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): String;
begin
  case TipoOcorrencia of
  
      //Tabela 1
      toRetornoRegistroRecusado, toRetornoEntradaRejeitadaCarne:
      case CodMotivo  of
         03: Result := 'AG. COBRADORA -N�O FOI POSS�VEL ATRIBUIR A AG�NCIA PELO CEP OU CEP INV�LIDO';
         04: Result := 'ESTADO -SIGLA DO ESTADO INV�LIDA';
         05: Result := 'DATA VENCIMENTO -PRAZO DA OPERA��O MENOR QUE PRAZO M�NIMO OU MAIOR QUE O M�XIMO';
         07: Result := 'VALOR DO T�TULO -VALOR DO T�TULO MAIOR QUE 10.000.000,00';
         08: Result := 'NOME DO SACADO -N�O INFORMADO OU DESLOCADO';
         09: Result := 'AGENCIA/CONTA -AG�NCIA ENCERRADA';
         10: Result := 'LOGRADOURO -N�O INFORMADO OU DESLOCADO';
         11: Result := 'CEP -CEP N�O NUM�RICO';
         12: Result := 'SACADOR / AVALISTA -NOME N�O INFORMADO OU DESLOCADO (BANCOS CORRESPONDENTES)';
         13: Result := 'ESTADO/CEP -CEP INCOMPAT�VEL COM A SIGLA DO ESTADO';
         14: Result := 'NOSSO N�MERO -NOSSO N�MERO J� REGISTRADO NO CADASTRO DO BANCO OU FORA DA FAIXA';
         15: Result := 'NOSSO N�MERO -NOSSO N�MERO EM DUPLICIDADE NO MESMO MOVIMENTO';
         18: Result := 'DATA DE ENTRADA -DATA DE ENTRADA INV�LIDA PARA OPERAR COM ESTA CARTEIRA';
         19: Result := 'OCORR�NCIA -OCORR�NCIA INV�LIDA';
         21: Result := 'AG. COBRADORA - CARTEIRA N�O ACEITA DEPOSIT�RIA CORRESPONDENTE/'+
                       'ESTADO DA AG�NCIA DIFERENTE DO ESTADO DO SACADO/'+
                       'AG. COBRADORA N�O CONSTA NO CADASTRO OU ENCERRANDO';
         22: Result := 'CARTEIRA -CARTEIRA N�O PERMITIDA (NECESS�RIO CADASTRAR FAIXA LIVRE)';
         26: Result := 'AG�NCIA/CONTA -AG�NCIA/CONTA N�O LIBERADA PARA OPERAR COM COBRAN�A';
         27: Result := 'CNPJ INAPTO -CNPJ DO CEDENTE INAPTO';
         29: Result := 'C�DIGO EMPRESA -CATEGORIA DA CONTA INV�LIDA';
         30: Result := 'ENTRADA BLOQUEADA -ENTRADAS BLOQUEADAS, CONTA SUSPENSA EM COBRAN�A';
         31: Result := 'AG�NCIA/CONTA -CONTA N�O TEM PERMISS�O PARA PROTESTAR (CONTATE SEU GERENTE)';
         35: Result := 'VALOR DO IOF -IOF MAIOR QUE 5%';
         36: Result := 'QTDADE DE MOEDA -QUANTIDADE DE MOEDA INCOMPAT�VEL COM VALOR DO T�TULO';
         37: Result := 'CNPJ/CPF DO SACADO -N�O NUM�RICO OU IGUAL A ZEROS';
         42: Result := 'NOSSO N�MERO -NOSSO N�MERO FORA DE FAIXA';
         52: Result := 'AG. COBRADORA -EMPRESA N�O ACEITA BANCO CORRESPONDENTE';
         53: Result := 'AG. COBRADORA -EMPRESA N�O ACEITA BANCO CORRESPONDENTE - COBRAN�A MENSAGEM';
         54: Result := 'DATA DE VENCTO -BANCO CORRESPONDENTE - T�TULO COM VENCIMENTO INFERIOR A 15 DIAS';
         55: Result := 'DEP/BCO CORRESP -CEP N�O PERTENCE � DEPOSIT�RIA INFORMADA';
         56: Result := 'DT VENCTO/BCO CORRESP -VENCTO SUPERIOR A 180 DIAS DA DATA DE ENTRADA';
         57: Result := 'DATA DE VENCTO -CEP S� DEPOSIT�RIA BCO DO BRASIL COM VENCTO INFERIOR A 8 DIAS';
         60: Result := 'ABATIMENTO -VALOR DO ABATIMENTO INV�LIDO';
         61: Result := 'JUROS DE MORA -JUROS DE MORA MAIOR QUE O PERMITIDO';
         62: Result := 'DESCONTO -VALOR DO DESCONTO MAIOR QUE VALOR DO T�TULO';
         63: Result := 'DESCONTO DE ANTECIPA��O -VALOR DA IMPORT�NCIA POR DIA DE DESCONTO (IDD) N�O PERMITIDO';
         64: Result := 'DATA DE EMISS�O -DATA DE EMISS�O DO T�TULO INV�LIDA';
         65: Result := 'TAXA FINANCTO -TAXA INV�LIDA (VENDOR)';
         66: Result := 'DATA DE VENCTO -INVALIDA/FORA DE PRAZO DE OPERA��O (M�NIMO OU M�XIMO)';
         67: Result := 'VALOR/QTIDADE -VALOR DO T�TULO/QUANTIDADE DE MOEDA INV�LIDO';
         68: Result := 'CARTEIRA -CARTEIRA INV�LIDA';
         69: Result := 'CARTEIRA -CARTEIRA INV�LIDA PARA T�TULOS COM RATEIO DE CR�DITO';
         70: Result := 'AG�NCIA/CONTA -CEDENTE N�O CADASTRADO PARA FAZER RATEIO DE CR�DITO';
         78: Result := 'AG�NCIA/CONTA -DUPLICIDADE DE AG�NCIA/CONTA BENEFICI�RIA DO RATEIO DE CR�DITO';
         80: Result := 'AG�NCIA/CONTA -QUANTIDADE DE CONTAS BENEFICI�RIAS DO RATEIO MAIOR DO QUE O PERMITIDO (M�XIMO DE 30 CONTAS POR T�TULO)';
         81: Result := 'AG�NCIA/CONTA -CONTA PARA RATEIO DE CR�DITO INV�LIDA / N�O PERTENCE AO ITA�';
         82: Result := 'DESCONTO/ABATI-MENTO -DESCONTO/ABATIMENTO N�O PERMITIDO PARA T�TULOS COM RATEIO DE CR�DITO';
         83: Result := 'VALOR DO T�TULO -VALOR DO T�TULO MENOR QUE A SOMA DOS VALORES ESTIPULADOS PARA RATEIO';
         84: Result := 'AG�NCIA/CONTA -AG�NCIA/CONTA BENEFICI�RIA DO RATEIO � A CENTRALIZADORA DE CR�DITO DO CEDENTE';
         85: Result := 'AG�NCIA/CONTA -AG�NCIA/CONTA DO CEDENTE � CONTRATUAL / RATEIO DE CR�DITO N�O PERMITIDO';
         86: Result := 'TIPO DE VALOR -C�DIGO DO TIPO DE VALOR INV�LIDO / N�O PREVISTO PARA T�TULOS COM RATEIO DE CR�DITO';
         87: Result := 'AG�NCIA/CONTA -REGISTRO TIPO 4 SEM INFORMA��O DE AG�NCIAS/CONTAS BENEFICI�RIAS DO RATEIO';
         90: Result := 'NRO DA LINHA -COBRAN�A MENSAGEM - N�MERO DA LINHA DA MENSAGEM INV�LIDO';
         97: Result := 'SEM MENSAGEM -COBRAN�A MENSAGEM SEM MENSAGEM (S� DE CAMPOS FIXOS), POR�M COM REGISTRO DO TIPO 7 OU 8';
         98: Result := 'FLASH INV�LIDO -REGISTRO MENSAGEM SEM FLASH CADASTRADO OU FLASH INFORMADO DIFERENTE DO CADASTRADO';
         99: Result := 'FLASH INV�LIDO -CONTA DE COBRAN�A COM FLASH CADASTRADO E SEM REGISTRO DE MENSAGEM CORRESPONDENTE';
         91: Result := 'DAC -DAC AG�NCIA / CONTA CORRENTE INV�LIDO';
         92: Result := 'DAC -DAC AG�NCIA/CONTA/CARTEIRA/NOSSO N�MERO INV�LIDO';
         93: Result := 'ESTADO -SIGLA ESTADO INV�LIDA';
         94: Result := 'ESTADO -SIGLA ESTADA INCOMPAT�VEL COM CEP DO SACADO';
         95: Result := 'CEP -CEP DO SACADO N�O NUM�RICO OU INV�LIDO';
         96: Result := 'ENDERE�O -ENDERE�O / NOME / CIDADE SACADO INV�LIDO';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      //Tabela 2
      toRetornoAlteracaoDadosRejeitados:
      case CodMotivo of
         02: Result := 'AG�NCIA COBRADORA INV�LIDA OU COM O MESMO CONTE�DO';
         04: Result := 'SIGLA DO ESTADO INV�LIDA';
         05: Result := 'DATA DE VENCIMENTO INV�LIDA OU COM O MESMO CONTE�DO';
         06: Result := 'VALOR DO T�TULO COM OUTRA ALTERA��O SIMULT�NEA';
         08: Result := 'NOME DO SACADO COM O MESMO CONTE�DO';
         09: Result := 'AG�NCIA/CONTA INCORRETA';
         11: Result := 'CEP INV�LIDO';
         12: Result := 'N�MERO INSCRI��O INV�LIDO DO SACADOR AVALISTA';
         13: Result := 'SEU N�MERO COM O MESMO CONTE�DO';
         16: Result := 'ABATIMENTO/ALTERA��O DO VALOR DO T�TULO OU SOLICITA��O DE BAIXA BLOQUEADA';
         20: Result := 'ESP�CIE INV�LIDA';
         21: Result := 'AG�NCIA COBRADORA N�O CONSTA NO CADASTRO DE DEPOSIT�RIA OU EM ENCERRAMENTO';
         23: Result := 'DATA DE EMISS�O DO T�TULO INV�LIDA OU COM MESMO CONTE�DO';
         41: Result := 'CAMPO ACEITE INV�LIDO OU COM MESMO CONTE�DO';
         42: Result := 'ALTERA��O INV�LIDA PARA T�TULO VENCIDO';
         43: Result := 'ALTERA��O BLOQUEADA � VENCIMENTO J� ALTERADO';
         53: Result := 'INSTRU��O COM O MESMO CONTE�DO';
         54: Result := 'DATA VENCIMENTO PARA BANCOS CORRESPONDENTES INFERIOR AO ACEITO PELO BANCO';
         55: Result := 'ALTERA��ES IGUAIS PARA O MESMO CONTROLE (AG�NCIA/CONTA/CARTEIRA/NOSSO N�MERO)';
         56: Result := 'CGC/CPF INV�LIDO N�O NUM�RICO OU ZERADO';
         57: Result := 'PRAZO DE VENCIMENTO INFERIOR A 15 DIAS';
         60: Result := 'VALOR DE IOF - ALTERA��O N�O PERMITIDA PARA CARTEIRAS DE N.S. - MOEDA VARI�VEL';
         61: Result := 'T�TULO J� BAIXADO OU LIQUIDADO OU N�O EXISTE T�TULO CORRESPONDENTE NO SISTEMA';
         66: Result := 'ALTERA��O N�O PERMITIDA PARA CARTEIRAS DE NOTAS DE SEGUROS - MOEDA VARI�VEL';
         67: Result := 'NOME INV�LIDO DO SACADOR AVALISTA';
         72: Result := 'ENDERE�O INV�LIDO � SACADOR AVALISTA';
         73: Result := 'BAIRRO INV�LIDO � SACADOR AVALISTA';
         74: Result := 'CIDADE INV�LIDA � SACADOR AVALISTA';
         75: Result := 'SIGLA ESTADO INV�LIDO � SACADOR AVALISTA';
         76: Result := 'CEP INV�LIDO � SACADOR AVALISTA';
         81: Result := 'ALTERA��O BLOQUEADA - T�TULO COM PROTESTO';
         87: Result := 'ALTERA��O BLOQUEADA � T�TULO COM RATEIO DE CR�DITO';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      //Tabela 3
      toRetornoInstrucaoRejeitada:
      case CodMotivo of
         01: Result := 'INSTRU��O/OCORR�NCIA N�O EXISTENTE';
         03: Result := 'CONTA N�O TEM PERMISS�O PARA PROTESTAR (CONTATE SEU GERENTE)';
         06: Result := 'NOSSO N�MERO IGUAL A ZEROS';
         09: Result := 'CGC/CPF DO SACADOR/AVALISTA INV�LIDO';
         10: Result := 'VALOR DO ABATIMENTO IGUAL OU MAIOR QUE O VALOR DO T�TULO';
         11: Result := 'SEGUNDA INSTRU��O/OCORR�NCIA N�O EXISTENTE';
         14: Result := 'REGISTRO EM DUPLICIDADE';
         15: Result := 'CNPJ/CPF INFORMADO SEM NOME DO SACADOR/AVALISTA';
         19: Result := 'VALOR DO ABATIMENTO MAIOR QUE 90% DO VALOR DO T�TULO';
         20: Result := 'EXISTE SUSTACAO DE PROTESTO PENDENTE PARA O TITULO';
         21: Result := 'T�TULO N�O REGISTRADO NO SISTEMA';
         22: Result := 'T�TULO BAIXADO OU LIQUIDADO';
         23: Result := 'INSTRU��O N�O ACEITA POR TER SIDO EMITIDO �LTIMO AVISO AO SACADO';
         24: Result := 'INSTRU��O INCOMPAT�VEL - EXISTE INSTRU��O DE PROTESTO PARA O T�TULO';
         25: Result := 'INSTRU��O INCOMPAT�VEL - N�O EXISTE INSTRU��O DE PROTESTO PARA O T�TULO';
         26: Result := 'INSTRU��O N�O ACEITA POR TER SIDO EMITIDO �LTIMO AVISO AO SACADO';
         27: Result := 'INSTRU��O N�O ACEITA POR N�O TER SIDO EMITIDA A ORDEM DE PROTESTO AO CART�RIO';
         28: Result := 'J� EXISTE UMA MESMA INSTRU��O CADASTRADA ANTERIORMENTE PARA O T�TULO';
         29: Result := 'VALOR L�QUIDO + VALOR DO ABATIMENTO DIFERENTE DO VALOR DO T�TULO REGISTRADO, OU VALOR'+
                       'DO ABATIMENTO MAIOR QUE 90% DO VALOR DO T�TULO';
         30: Result := 'EXISTE UMA INSTRU��O DE N�O PROTESTAR ATIVA PARA O T�TULO';
         31: Result := 'EXISTE UMA OCORR�NCIA DO SACADO QUE BLOQUEIA A INSTRU��O';
         32: Result := 'DEPOSIT�RIA DO T�TULO = 9999 OU CARTEIRA N�O ACEITA PROTESTO';
         33: Result := 'ALTERA��O DE VENCIMENTO IGUAL � REGISTRADA NO SISTEMA OU QUE TORNA O T�TULO VENCIDO';
         34: Result := 'INSTRU��O DE EMISS�O DE AVISO DE COBRAN�A PARA T�TULO VENCIDO ANTES DO VENCIMENTO';
         35: Result := 'SOLICITA��O DE CANCELAMENTO DE INSTRU��O INEXISTENTE';
         36: Result := 'T�TULO SOFRENDO ALTERA��O DE CONTROLE (AG�NCIA/CONTA/CARTEIRA/NOSSO N�MERO)';
         37: Result := 'INSTRU��O N�O PERMITIDA PARA A CARTEIRA';
         38: Result := 'INSTRU��O N�O PERMITIDA PARA T�TULO COM RATEIO DE CR�DITO';
         40: Result := 'INSTRU��O INCOMPAT�VEL � N�O EXISTE INSTRU��O DE NEGATIVA��O EXPRESSA PARA O T�TULO';
         41: Result := 'INSTRU��O N�O PERMITIDA � T�TULO COM ENTRADA EM NEGATIVA��O EXPRESSA';
         42: Result := 'INSTRU��O N�O PERMITIDA � T�TULO COM NEGATIVA��O EXPRESSA CONCLU�DA';
         43: Result := 'PRAZO INV�LIDO PARA NEGATIVA��O EXPRESSA � M�NIMO: 02 DIAS CORRIDOS AP�S O VENCIMENTO';
         45: Result := 'INSTRU��O INCOMPAT�VEL PARA O MESMO T�TULO NESTA DATA';
         47: Result := 'INSTRU��O N�O PERMITIDA � ESP�CIE INV�LIDA';
         48: Result := 'DADOS DO PAGADOR INV�LIDOS ( CPF / CNPJ / NOME )';
         49: Result := 'DADOS DO ENDERE�O DO PAGADOR INV�LIDOS';
         50: Result := 'DATA DE EMISS�O DO T�TULO INV�LIDA';
         51: Result := 'INSTRU��O N�O PERMITIDA � T�TULO COM NEGATIVA��O EXPRESSA AGENDADA';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      //Tabela 4
      toRetornoBaixaRejeitada:
      case CodMotivo of
         01: Result := 'CARTEIRA/N� N�MERO N�O NUM�RICO';
         04: Result := 'NOSSO N�MERO EM DUPLICIDADE NUM MESMO MOVIMENTO';
         05: Result := 'SOLICITA��O DE BAIXA PARA T�TULO J� BAIXADO OU LIQUIDADO';
         06: Result := 'SOLICITA��O DE BAIXA PARA T�TULO N�O REGISTRADO NO SISTEMA';
         07: Result := 'COBRAN�A PRAZO CURTO - SOLICITA��O DE BAIXA P/ T�TULO N�O REGISTRADO NO SISTEMA';
         08: Result := 'SOLICITA��O DE BAIXA PARA T�TULO EM FLOATING';
         10: Result := 'VALOR DO TITULO FAZ PARTE DE GARANTIA DE EMPRESTIMO';
         11: Result := 'PAGO ATRAV�S DO SISPAG POR CR�DITO EM C/C E N�O BAIXADO';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      //Tabela 5
      toRetornoCobrancaContratual:
         case CodMotivo of
            16: Result:= 'ABATIMENTO/ALTERA��O DO VALOR DO T�TULO OU SOLICITA��O DE BAIXA BLOQUEADOS';
            40: Result:= 'N�O APROVADA DEVIDO AO IMPACTO NA ELEGIBILIDADE DE GARANTIAS';
            41: Result:= 'AUTOMATICAMENTE REJEITADA';
            42: Result:= 'CONFIRMA RECEBIMENTO DE INSTRU��O � PENDENTE DE AN�LISE';
         else
            Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
         end;

      //Tabela 6
      toRetornoAlegacaoDoSacado:
      case CodMotivo of
         1313: Result := 'SOLICITA A PRORROGA��O DO VENCIMENTO PARA';
         1321: Result := 'SOLICITA A DISPENSA DOS JUROS DE MORA';
         1339: Result := 'N�O RECEBEU A MERCADORIA';
         1347: Result := 'A MERCADORIA CHEGOU ATRASADA';
         1354: Result := 'A MERCADORIA CHEGOU AVARIADA';
         1362: Result := 'A MERCADORIA CHEGOU INCOMPLETA';
         1370: Result := 'A MERCADORIA N�O CONFERE COM O PEDIDO';
         1388: Result := 'A MERCADORIA EST� � DISPOSI��O';
         1396: Result := 'DEVOLVEU A MERCADORIA';
         1404: Result := 'N�O RECEBEU A FATURA';
         1412: Result := 'A FATURA EST� EM DESACORDO COM A NOTA FISCAL';
         1420: Result := 'O PEDIDO DE COMPRA FOI CANCELADO';
         1438: Result := 'A DUPLICATA FOI CANCELADA';
         1446: Result := 'QUE NADA DEVE OU COMPROU';
         1453: Result := 'QUE MANT�M ENTENDIMENTOS COM O SACADOR';
         1461: Result := 'QUE PAGAR� O T�TULO EM:';
         1479: Result := 'QUE PAGOU O T�TULO DIRETAMENTE AO CEDENTE EM:';
         1487: Result := 'QUE PAGAR� O T�TULO DIRETAMENTE AO CEDENTE EM:';
         1495: Result := 'QUE O VENCIMENTO CORRETO �:';
         1503: Result := 'QUE TEM DESCONTO OU ABATIMENTO DE:';
         1719: Result := 'SACADO N�O FOI LOCALIZADO; CONFIRMAR ENDERE�O';
         1727: Result := 'SACADO EST� EM REGIME DE CONCORDATA';
         1735: Result := 'SACADO EST� EM REGIME DE FAL�NCIA';
         1750: Result := 'SACADO SE RECUSA A PAGAR JUROS BANC�RIOS';
         1768: Result := 'SACADO SE RECUSA A PAGAR COMISS�O DE PERMAN�NCIA';
         1776: Result := 'N�O FOI POSS�VEL A ENTREGA DO BLOQUETO AO SACADO';
         1784: Result := 'BLOQUETO N�O ENTREGUE, MUDOU-SE/DESCONHECIDO';
         1792: Result := 'BLOQUETO N�O ENTREGUE, CEP ERRADO/INCOMPLETO';
         1800: Result := 'BLOQUETO N�O ENTREGUE, N�MERO N�O EXISTE/ENDERE�O INCOMPLETO';
         1818: Result := 'BLOQUETO N�O RETIRADO PELO SACADO. REENVIADO PELO CORREIO';
         1826: Result := 'ENDERE�O DE E-MAIL INV�LIDO. BLOQUETO ENVIADO PELO CORREIO';
         1834: Result := 'BOLETO DDA, DIVIDA RECONHECIDA PELO PAGADOR';
         1842: Result := 'BOLETO DDA, DIVIDA N�O RECONHECIDA PELO PAGADOR';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      //Tabela 7
      toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente:
      case CodMotivo of
         1610: Result := 'DOCUMENTA��O SOLICITADA AO CEDENTE';
         3103: Result := 'INSUFICIENCIA DE DADOS NO MODELO 4006';
         3111: Result := 'SUSTA��O SOLICITADA AG. CEDENTE';
         3129: Result := 'TITULO NAO ENVIADO A CARTORIO';
         3137: Result := 'AGUARDAR UM DIA UTIL APOS O VENCTO PARA PROTESTAR';
         3145: Result := 'DM/DMI SEM COMPROVANTE AUTENTICADO OU DECLARACAO';
         3152: Result := 'FALTA CONTRATO DE SERV(AG.CED:ENVIAR)';
         3160: Result := 'NOME DO PAGADOR INCOMPLETO/INCORRETO';
         3178: Result := 'NOME DO BENEFICI�RIO INCOMPLETO/INCORRETO';
         3186: Result := 'NOME DO SACADOR INCOMPLETO/INCORRETO';
         3194: Result := 'TIT ACEITO: IDENTIF ASSINANTE DO CHEQ';
         3202: Result := 'TIT ACEITO: RASURADO OU RASGADO';
         3210: Result := 'TIT ACEITO: FALTA TIT.(AG.CED:ENVIAR)';
         3228: Result := 'ATOS DA CORREGEDORIA ESTADUAL';
         3236: Result := 'NAO FOI POSSIVEL EFETUAR O PROTESTO';
         3244: Result := 'PROTESTO SUSTADO / CEDENTE N�O ENTREGOU A DOCUMENTA��O';
         3251: Result := 'DOCUMENTACAO IRREGULAR';
         3269: Result := 'DATA DE EMISS�O DO T�TULO INV�LIDA/IRREGULAR';
         3277: Result := 'ESPECIE INVALIDA PARA PROTESTO';
         3285: Result := 'PRA�A N�O ATENDIDA PELA REDE BANC�RIA';
         3293: Result := 'CENTRALIZADORA DE PROTESTO NAO RECEBEU A DOCUMENTACAO';
         3301: Result := 'CGC/CPF DO SACADO INV�LIDO/INCORRETO';
         3319: Result := 'SACADOR/AVALISTA E PESSOA F�SICA';
         3327: Result := 'CEP DO SACADO INCORRETO';
         3335: Result := 'DEPOSIT�RIA INCOMPAT�VEL COM CEP DO SACADO';
         3343: Result := 'CGC/CPF SACADOR INVALIDO/INCORRETO';
         3350: Result := 'ENDERE�O DO SACADO INSUFICIENTE';
         3368: Result := 'PRA�A PAGTO INCOMPAT�VEL COM ENDERE�O';
         3376: Result := 'FALTA N�MERO/ESP�CIE DO T�TULO';
         3384: Result := 'T�TULO ACEITO S/ ASSINATURA DO SACADOR';
         3392: Result := 'T�TULO ACEITO S/ ENDOSSO CEDENTE OU IRREGULAR';
         3400: Result := 'T�TULO SEM LOCAL OU DATA DE EMISS�O';
         3418: Result := 'T�TULO ACEITO COM VALOR EXTENSO DIFERENTE DO NUM�RICO';
         3426: Result := 'T�TULO ACEITO DEFINIR ESP�CIE DA DUPLICATA';
         3434: Result := 'DATA EMISS�O POSTERIOR AO VENCIMENTO';
         3442: Result := 'T�TULO ACEITO DOCUMENTO N�O PROSTEST�VEL';
         3459: Result := 'T�TULO ACEITO EXTENSO VENCIMENTO IRREGULAR';
         3467: Result := 'T�TULO ACEITO FALTA NOME FAVORECIDO';
         3475: Result := 'T�TULO ACEITO FALTA PRA�A DE PAGAMENTO';
         3483: Result := 'T�TULO ACEITO FALTA CPF ASSINANTE CHEQUE';
         3491: Result := 'FALTA N�MERO DO T�TULO (SEU N�MERO)';
         3509: Result := 'CART�RIO DA PRA�A COM ATIVIDADE SUSPENSA';
         3517: Result := 'DATA APRESENTACAO MENOR QUE A DATA VENCIMENTO';
         3525: Result := 'FALTA COMPROVANTE DA PRESTACAO DE SERVICO';
         3533: Result := 'CNPJ/CPF PAGADOR INCOMPATIVEL C/ TIPO DE DOCUMENTO';
         3541: Result := 'CNPJ/CPF SACADOR INCOMPATIVEL C/ ESPECIE';
         3558: Result := 'TIT ACEITO: S/ ASSINATURA DO PAGADOR';
         3566: Result := 'FALTA DATA DE EMISSAO DO TITULO';
         3574: Result := 'SALDO MAIOR QUE O VALOR DO TITULO';
         3582: Result := 'TIPO DE ENDOSSO INVALIDO';
         3590: Result := 'DEVOLVIDO POR ORDEM JUDICIAL';
         3608: Result := 'DADOS DO TITULO NAO CONFEREM COM DISQUETE';
         3616: Result := 'PAGADOR E SACADOR AVALISTA S�O A MESMA PESSOA';
         3624: Result := 'COMPROVANTE ILEGIVEL PARA CONFERENCIA E MICROFILMAGEM';
         3632: Result := 'CONFIRMAR SE SAO DOIS EMITENTES';
         3640: Result := 'ENDERECO DO PAGADOR IGUAL AO DO SACADOR OU DO PORTADOR';
         3657: Result := 'ENDERECO DO BENEFICI�RIO INCOMPLETO OU NAO INFORMADO';
         3665: Result := 'ENDERECO DO EMITENTE NO CHEQUE IGUAL AO DO BANCO PAGADOR';
         3673: Result := 'FALTA MOTIVO DA DEVOLUCAO NO CHEQUE OU ILEGIVEL';
         3681: Result := 'TITULO COM DIREITO DE REGRESSO VENCIDO';
         3699: Result := 'TITULO APRESENTADO EM DUPLICIDADE';
         3707: Result := 'LC EMITIDA MANUALMENTE (TITULO DO BANCO/CA)';
         3715: Result := 'NAO PROTESTAR LC (TITULO DO BANCO/CA)';
         3723: Result := 'ELIMINAR O PROTESTO DA LC (TITULO DO BANCO/CA)';
         3731: Result := 'TITULO JA PROTESTADO';
         3749: Result := 'TITULO - FALTA TRADUCAO POR TRADUTOR PUBLICO';
         3756: Result := 'FALTA DECLARACAO DE SALDO ASSINADA NO TITULO';
         3764: Result := 'CONTRATO DE CAMBIO - FALTA CONTA GRAFICA';
         3772: Result := 'PAGADOR FALECIDO';
         3780: Result := 'ESPECIE DE TITULO QUE O BANCO NAO PROTESTA';
         3798: Result := 'AUSENCIA DO DOCUMENTO FISICO';
         3806: Result := 'ORDEM DE PROTESTO SUSTADA, MOTIVO';
         3814: Result := 'PAGADOR APRESENTOU QUITA��O DO T�TULO';
         3822: Result := 'PAGADOR IR� NEGOCIAR COM BENEFICI�RIO';
         3830: Result := 'CPF INCOMPAT�VEL COM A ESP�CIE DO T�TULO';
         3848: Result := 'T�TULO DE OUTRA JURISDI��O TERRITORIAL';
         3855: Result := 'T�TULO COM EMISS�O ANTERIOR A CONCORDATA DO PAGADOR';
         3863: Result := 'PAGADOR CONSTA NA LISTA DE FAL�NCIA';
         3871: Result := 'APRESENTANTE N�O ACEITA PUBLICA��O DE EDITAL';
         3889: Result := 'CART�RIO COM PROBLEMAS OPERACIONAIS';
         3897: Result := 'ENVIO DE TITULOS PARA PROTESTO TEMPORARIAMENTE PARALISADO';
         3905: Result := 'BENEFICI�RIO COM CONTA EM COBRANCA SUSPENSA';
         3913: Result := 'CEP DO PAGADOR � UMA CAIXA POSTAL';
         3921: Result := 'ESP�CIE N�O PROTEST�VEL NO ESTADO';
         3939: Result := 'FALTA ENDERE�O OU DOCUMENTO DO SACADOR AVALISTA';
         3947: Result := 'CORRIGIR A ESPECIE DO TITULO';
         3954: Result := 'ERRO DE PREENCHIMENTO DO TITULO';
         3962: Result := 'VALOR DIVERGENTE ENTRE TITULO E COMPROVANTE';
         3970: Result := 'CONDOMINIO NAO PODE SER PROTESTADO P/ FINS FALIMENTARES';
         3988: Result := 'VEDADA INTIMACAO POR EDITAL PARA PROTESTO FALIMENTAR';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      //Tabela 8
      toRetornoInstrucaoCancelada:
      case CodMotivo of
         1156: Result := 'N�O PROTESTAR';
         2261: Result := 'DISPENSAR JUROS/COMISS�O DE PERMAN�NCIA';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      //Tabela 9
      toRetornoChequeDevolvido:
      case CodMotivo of
         11: Result:= 'CHEQUE SEM FUNDOS - PRIMEIRA APRESENTA��O - PASS�VEL DE REAPRESENTA��O: SIM';
         12: Result:= 'CHEQUE SEM FUNDOS - SEGUNDA APRESENTA��O - PASS�VEL DE REAPRESENTA��O: N�O ';
         13: Result:= 'CONTA ENCERRADA - PASS�VEL DE REAPRESENTA��O: N�O';
         14: Result:= 'PR�TICA ESP�RIA - PASS�VEL DE REAPRESENTA��O: N�O';
         20: Result:= 'FOLHA DE CHEQUE CANCELADA POR SOLICITA��O DO CORRENTISTA - PASS�VEL DE REAPRESENTA��O: N�O';
         21: Result:= 'CONTRA-ORDEM (OU REVOGA��O) OU OPOSI��O (OU SUSTA��O) AO PAGAMENTO PELO EMITENTE OU PELO ' +
                      'PORTADOR - PASS�VEL DE REAPRESENTA��O: SIM';
         22: Result:= 'DIVERG�NCIA OU INSUFICI�NCIA DE ASSINATURAb - PASS�VEL DE REAPRESENTA��O: SIM';
         23: Result:= 'CHEQUES EMITIDOS POR ENTIDADES E �RG�OS DA ADMINISTRA��O P�BLICA FEDERAL DIRETA E INDIRETA, ' +
                      'EM DESACORDO COM OS REQUISITOS CONSTANTES DO ARTIGO 74, � 2�, DO DECRETO-LEI N� 200, DE 25.02.1967. - ' +
                      'PASS�VEL DE REAPRESENTA��O: SIM';
         24: Result:= 'BLOQUEIO JUDICIAL OU DETERMINA��O DO BANCO CENTRAL DO BRASIL - PASS�VEL DE REAPRESENTA��O: SIM';
         25: Result:= 'CANCELAMENTO DE TALON�RIO PELO BANCO SACADO - PASS�VEL DE REAPRESENTA��O: N�O';
         28: Result:= 'CONTRA-ORDEM (OU REVOGA��O) OU OPOSI��O (OU SUSTA��O) AO PAGAMENTO OCASIONADA POR FURTO OU ROUBO - ' +
                      'PASS�VEL DE REAPRESENTA��O: N�O';
         29: Result:= 'CHEQUE BLOQUEADO POR FALTA DE CONFIRMA��O DO RECEBIMENTO DO TALON�RIO PELO CORRENTISTA - ' +
                      'PASS�VEL DE REAPRESENTA��O: SIM';
         30: Result:= 'FURTO OU ROUBO DE MALOTES - PASS�VEL DE REAPRESENTA��O: N�O';
         31: Result:= 'ERRO FORMAL (SEM DATA DE EMISS�O, COM O M�S GRAFADO NUMERICAMENTE, AUS�NCIA DE ASSINATURA, ' +
                      'N�O-REGISTRO DO VALOR POR EXTENSO) - PASS�VEL DE REAPRESENTA��O: SIM';
         32: Result:= 'AUS�NCIA OU IRREGULARIDADE NA APLICA��O DO CARIMBO DE COMPENSA��O - PASS�VEL DE REAPRESENTA��O: SIM';
         33: Result:= 'DIVERG�NCIA DE ENDOSSO - PASS�VEL DE REAPRESENTA��O: SIM';
         34: Result:= 'CHEQUE APRESENTADO POR ESTABELECIMENTO BANC�RIO QUE N�O O INDICADO NO CRUZAMENTO EM PRETO, SEM O ' +
                      'ENDOSSO-MANDATO - PASS�VEL DE REAPRESENTA��O: SIM';
         35: Result:= 'CHEQUE FRAUDADO, EMITIDO SEM PR�VIO CONTROLE OU RESPONSABILIDADE DO ESTABELECIMENTO BANC�RIO ' +
                      '("CHEQUE UNIVERSAL"), OU AINDA COM ADULTERA��O DA PRA�A SACADA - PASS�VEL DE REAPRESENTA��O: N�O';
         36: Result:= 'CHEQUE EMITIDO COM MAIS DE UM ENDOSSO - PASS�VEL DE REAPRESENTA��O: SIM';
         40: Result:= 'MOEDA INV�LIDA - PASS�VEL DE REAPRESENTA��O: N�O';
         41: Result:= 'CHEQUE APRESENTADO A BANCO QUE N�O O SACADO - PASS�VEL DE REAPRESENTA��O: SIM';
         42: Result:= 'CHEQUE N�O-COMPENS�VEL NA SESS�O OU SISTEMA DE COMPENSA��O EM QUE FOI APRESENTADO - ' +
                      'PASS�VEL DE REAPRESENTA��O: SIM';
         43: Result:= 'CHEQUE, DEVOLVIDO ANTERIORMENTE PELOS MOTIVOS 21, 22, 23, 24, 31 OU 34, N�O-PASS�VEL ' +
                      'DE REAPRESENTA��O EM VIRTUDE DE PERSISTIR O MOTIVO DA DEVOLU��O - PASS�VEL DE REAPRESENTA��O: N�O';
         44: Result:= 'CHEQUE PRESCRITO - PASS�VEL DE REAPRESENTA��O: N�O';
         45: Result:= 'CHEQUE EMITIDO POR ENTIDADE OBRIGADA A REALIZAR MOVIMENTA��O E UTILIZA��O DE RECURSOS FINANCEIROS ' +
                      'DO TESOURO NACIONAL MEDIANTE ORDEM BANC�RIA - PASS�VEL DE REAPRESENTA��O: N�O';
         48: Result:= 'CHEQUE DE VALOR SUPERIOR AO ESTABELECIDO, EMITIDO SEM A IDENTIFICA��O DO BENEFICI�RIO, DEVENDO SER ' +
                      'DEVOLVIDO A QUALQUER TEMPO - PASS�VEL DE REAPRESENTA��O: SIM';
         49: Result:= 'REMESSA NULA, CARACTERIZADA PELA REAPRESENTA��O DE CHEQUE DEVOLVIDO PELOS MOTIVOS 12, 13, 14, 20, ' +
                      '25, 28, 30, 35, 43, 44 E 45, PODENDO A SUA DEVOLU��O OCORRER A QUALQUER TEMPO - PASS�VEL DE REAPRESENTA��O: N�O';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      // Tabela 10
      toRetornoRegistroConfirmado:
      case CodMotivo of
        01: Result := 'CEP SEM ATENDIMENTO DE PROTESTO NO MOMENTO';
        02: Result := 'ESTADO COM DETERMINA��O LEGAL QU EIMPEDE A INSCRI��O DE INADIMPLENTES NOS CADASTROS DE PROTE��O AO ' +
                      'CR�DITO NO PRAZO SOLICITADO � PRAZO SUPERIOR AO SOLICITADO';
        03: Result := 'BOLETO N�O LIQUIDADO NO DESCONTO DE DUPLICATAS E TRANSFERIDO PARA COBRAN�A SIMPLES';
      else
        Result:= IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      end;

      // Tabela 11
      toRetornoInstrucaoNegativacaoExpressaRejeitada:
      case CodMotivo of
        6007: Result := 'INCLUS�O BLOQUEADA FACE A DETERMINA��O JUDICIAL';
        6015: Result := 'INCONSIST�NCIAS NAS INFORMA��ES DE ENDERE�O';
        6023: Result := 'T�TULO J� DECURSADO';
        6031: Result := 'INCLUS�O CONDICIONADA A APRESENTA��O DE DOCUMENTO DE D�VIDA';
        6163: Result := 'EXCLUS�O N�O PERMITIDA, REGISTRO SUSPENSO';
        6171: Result := 'EXCLUS�O PARA REGISTRO INEXISTENTE';
        6379: Result := 'REJEI��O POR DADO(S) INCONSISTENTE(S)';
      else
        Result:= IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      end;

      // Tabela 12
      toRetornoNegativacaoExpressaInformacional:
      case CodMotivo of
        6049: Result := 'INFORMA��O DOS CORREIOS � MUDOU-SE';
        6056: Result := 'INFORMA��O DOS CORREIOS � DEVOLVIDO POR INFORMA��O PRESTADA PELO SINDICO OU PORTEIRO';
        6064: Result := 'INFORMA��O DOS CORREIOS � DEVOLVIDO POR INCONSIST�NCIA NO ENDERE�O';
        6072: Result := 'INFORMA��O DOS CORREIOS � DESCONHECIDO';
        6080: Result := 'INFORMA��O DOS CORREIOS � RECUSADO';
        6098: Result := 'INFORMA��O DOS CORREIOS � AUSENTE';
        6106: Result := 'INFORMA��O DOS CORREIOS � N�O PROCURADO';
        6114: Result := 'INFORMA��O DOS CORREIOS � FALECIDO';
        6122: Result := 'INFORMA��O DOS CORREIOS � N�O ESPECIFICADO';
        6130: Result := 'INFORMA��O DOS CORREIOS � CAIXA POSTAL INEXISTENTE';
        6148: Result := 'INFORMA��O DOS CORREIOS � DEVOLU��O DO COMUNICADO DO CORREIO';
        6155: Result := 'INFORMA��O DOS CORREIOS � OUTROS MOTIVOS';
        6478: Result := 'AR - ENTREGUE COM SUCESSO';
        6486: Result := 'INCLUSAO PARA REGISTRO JA EXISTENTE/RECUSADO';
        6494: Result := 'AR - CARTA EXTRAVIADA E N�O ENTREGUE';
        6502: Result := 'AR - CARTA ROUBADA E N�O ENTREGUE';
        6510: Result := 'AR - AUSENTE - ENCAMINHADO PARA ENTREGA INTERNA';
        6528: Result := 'AR INUTILIZADO - N�O RETIRADO NOS CORREIOS AP�S 3 TENTATIVAS';
        6536: Result := 'AR - ENDERECO INCORRETO';
        6544: Result := 'AR - NAO PROCURADO � DEVOLVIDO AO REMETENTE';
        6551: Result := 'AR - N�O ENTREGUE POR FALTA DE APRESENTAR DOCUMENTO COM FOTO';
        6569: Result := 'AR - MUDOU-SE';
        6577: Result := 'AR - DESCONHECIDO';
        6585: Result := 'AR - RECUSADO';
        6593: Result := 'AR - ENDERECO INSUFICIENTE';
        6601: Result := 'AR - NAO EXISTE O NUMERO INDICADO';
        6618: Result := 'AR � AUSENTE';
        6627: Result := 'AR - CARTA NAO PROCURADA NA UNIDADE DOS CORREIOS';
        6635: Result := 'AR � FALECIDO';
        6643: Result := 'AR - DEVIDO A DEVOLUCAO DO COMUNICADO DO CORREIO';
      else
        Result:= IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      end;
   else
      Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
   end;

  Result := ACBrSTr(Result);
end;

function TACBrBancoItau.CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Altera��o de vencimento}
    07 : Result:= toRemessaAlterarUsoEmpresa;               {Altera��o do uso Da Empresa}
    08 : Result:= toRemessaAlterarSeuNumero;                {Altera��o do seu N�mero}
    09 : Result:= toRemessaProtestar;                       {Protestar (emite aviso ao sacado ap�s xx dias do vencimento, e envia ao cart�rio ap�s 5 dias �teis)}
    10 : Result:= toRemessaCancelarInstrucaoProtesto;       {Sustar Protesto}
    11 : Result:= toRemessaProtestoFinsFalimentares;        {Protesto para fins Falimentares}
    18 : Result:= toRemessaCancelarInstrucaoProtestoBaixa;  {Sustar protesto e baixar}
    30 : Result:= toRemessaExcluirSacadorAvalista;          {Exclus�o de Sacador Avalista}
    31 : Result:= toRemessaOutrasAlteracoes;                {Altera��o de Outros Dados}
    34 : Result:= toRemessaBaixaporPagtoDiretoCedente;      {Baixa por ter sido pago Diretamente ao Cedente}
    35 : Result:= toRemessaCancelarInstrucao;               {Cancelamento de Instru��o}
    37 : Result:= toRemessaAlterarVencimentoSustarProtesto; {Altera��o do Vencimento e Sustar Protesto}
    38 : Result:= toRemessaCedenteDiscordaSacado;           {Cedente n�o Concorda com Alega��o do Sacado }
    47 : Result:= toRemessaCedenteSolicitaDispensaJuros;    {Cedente Solicita Dispensa de Juros}
    49 : Result:= toRemessaAlterarOutrosDados;              {49-Altera��o de dados extras}
    71 : Result:= toRemessaHibrido                          {71-REMESSA � BOLECODE (emiss�o do boleto e QR Code pix)}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;

end;

function TACBrBancoItau.CodigoLiquidacao_Descricao(CodLiquidacao: String): String;
begin
  CodLiquidacao := Trim(CodLiquidacao);
  if AnsiSameText(CodLiquidacao, 'AA') then
    Result := 'CAIXA ELETR�NICO BANCO ITA�'
  else if AnsiSameText(CodLiquidacao, 'AC') then
    Result := 'PAGAMENTO EM CART�RIO AUTOMATIZADO'
  else if AnsiSameText(CodLiquidacao, 'AO') then
    Result := 'ACERTO ONLINE'
  else if AnsiSameText(CodLiquidacao, 'BC') then
    Result := 'BANCOS CORRESPONDENTES'
  else if AnsiSameText(CodLiquidacao, 'BF') then
    Result := 'ITA� BANKFONE'
  else if AnsiSameText(CodLiquidacao, 'BL') then
    Result := 'ITA� BANKLINE'
  else if AnsiSameText(CodLiquidacao, 'B0') then
    Result := 'OUTROS BANCOS � RECEBIMENTO OFF-LINE'
  else if AnsiSameText(CodLiquidacao, 'B1') then
    Result := 'OUTROS BANCOS � PELO C�DIGO DE BARRAS'
  else if AnsiSameText(CodLiquidacao, 'B2') then
    Result := 'OUTROS BANCOS � PELA LINHA DIGIT�VEL'
  else if AnsiSameText(CodLiquidacao, 'B3') then
    Result := 'OUTROS BANCOS � PELO AUTO ATENDIMENTO'
  else if AnsiSameText(CodLiquidacao, 'B4') then
    Result := 'OUTROS BANCOS � RECEBIMENTO EM CASA LOT�RICA'
  else if AnsiSameText(CodLiquidacao, 'B5') then
    Result := 'OUTROS BANCOS � CORRESPONDENTE'
  else if AnsiSameText(CodLiquidacao, 'B6') then
    Result := 'OUTROS BANCOS � TELEFONE'
  else if AnsiSameText(CodLiquidacao, 'B7') then
    Result := 'OUTROS BANCOS � ARQUIVO ELETR�NICO'
  else if AnsiSameText(CodLiquidacao, 'CC') then
    Result := 'AG�NCIA ITA� � COM CHEQUE DE OUTRO BANCO ou (CHEQUE ITA�)'
  else if AnsiSameText(CodLiquidacao, 'CI') then
    Result := 'CORRESPONDENTE ITA�'
  else if AnsiSameText(CodLiquidacao, 'CK') then
    Result := 'SISPAG � SISTEMA DE CONTAS A PAGAR ITA�'
  else if AnsiSameText(CodLiquidacao, 'CP') then
    Result := 'AG�NCIA ITA� � POR D�BITO EM CONTA CORRENTE, CHEQUE ITA� OU DINHEIRO'
  else if AnsiSameText(CodLiquidacao, 'DG') then
    Result := 'AG�NCIA ITA� � CAPTURADO EM OFF-LINE'
  else if AnsiSameText(CodLiquidacao, 'LC') then
    Result := 'PAGAMENTO EM CART�RIO DE PROTESTO COM CHEQUE'
  else if AnsiSameText(CodLiquidacao, 'EA') then
    Result := 'TERMINAL DE CAIXA'
  else if AnsiSameText(CodLiquidacao, 'Q0') then
    Result := 'AGENDAMENTO � PAGAMENTO AGENDADO VIA BANKLINE OU OUTRO CANAL ELETR�NICO E LIQUIDADO NA DATA INDICADA'
  else if AnsiSameText(CodLiquidacao, 'RA') then
    Result := 'DIGITA��O � REALIMENTA��O AUTOM�TICA'
  else if AnsiSameText(CodLiquidacao, 'ST') then
    Result := 'PAGAMENTO VIA SELTEC'
  else
    Result := '';
end;

function TACBrBancoItau.TipoOcorrenciaToCodRemessa(
  const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case TipoOcorrencia of
      toRemessaBaixar                    : Result := '02';
      toRemessaConcederAbatimento        : Result := '04';
      toRemessaCancelarAbatimento        : Result := '05';
      toRemessaAlterarVencimento         : Result := '06';
      toRemessaSustarProtesto            : Result := '18';
      toRemessaCancelarInstrucaoProtesto : Result := '10';
    else
       Result := '01';
    end;
  end
  else
  begin
    case TipoOcorrencia of
      toRemessaBaixar                       : Result := '02';
      toRemessaConcederAbatimento           : Result := '04';
      toRemessaCancelarAbatimento           : Result := '05';
      toRemessaAlterarVencimento            : Result := '06';
      toRemessaAlterarUsoEmpresa            : Result := '07';
      toRemessaAlterarSeuNumero             : Result := '08';
      toRemessaProtestar                    : Result := '09';
      toRemessaNaoProtestar                 : Result := '10';
      toRemessaProtestoFinsFalimentares     : Result := '11';
      toRemessaSustarProtesto               : Result := '18';
      toRemessaOutrasAlteracoes             : Result := '31';
      toRemessaBaixaporPagtoDiretoCedente   : Result := '34';
      toRemessaCancelarInstrucao            : Result := '35';
      toRemessaAlterarVencSustarProtesto    : Result := '37';
      toRemessaCedenteDiscordaSacado        : Result := '38';
      toRemessaCedenteSolicitaDispensaJuros : Result := '47';
      toRemessaHibrido                      : Result := '71';
    else
      Result := '01';
    end;
  end;

end;

end.
