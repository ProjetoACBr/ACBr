{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliana Tamizou, Andr� Ferreira de Moraes,      }
{ Jos� M S Junior                                                              }
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

unit ACBrBancoBradesco;

interface

uses
  Classes, Contnrs, SysUtils, ACBrBoleto, ACBrBoletoConversao;

type

  { TACBrBancoBradesco }

  TACBrBancoBradesco = class(TACBrBancoClass)
  private
    function ConverterMultaPercentual(const ACBrTitulo: TACBrTitulo): Double;
  protected
    function ConverterDigitoModuloFinal(): String; override;
    function DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;
    procedure ValidaNossoNumeroResponsavel(out ANossoNumero: String; out ADigVerificador: String;
              const ACBrTitulo: TACBrTitulo); override;
    function MontaInstrucoesCNAB400(const ACBrTitulo :TACBrTitulo; const nRegistro: Integer ): String; override;
    function GerarLinhaRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList): String;
    procedure LerRetorno400(ARetorno:TStringList); override;
  public
    Constructor create(AOwner: TACBrBanco);
    function MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String; override;

    procedure GerarRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList); override;
    function  GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String; override;

    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia) : String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia):String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; const CodMotivo: String): String; override;

    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;

    Procedure LerRetorno400Transacao4(ACBrTitulo :TACBrTitulo; ALinha:String); override;


  end;

implementation

uses {$IFDEF COMPILER6_UP} dateutils {$ELSE} ACBrD5 {$ENDIF},
  StrUtils, ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.Strings, ACBrUtil.DateTime ;

{ TACBrBancoBradesco }

function TACBrBancoBradesco.ConverterDigitoModuloFinal(): String;
begin
  if Modulo.ModuloFinal = 1 then
      Result:= 'P'
   else
      Result:= IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoBradesco.DefineCampoLivreCodigoBarras(
  const ACBrTitulo: TACBrTitulo): String;
begin
  with ACBrTitulo.ACBrBoleto do
  begin
    Result := PadLeft(OnlyNumber(Cedente.Agencia), fpTamanhoAgencia, '0') +
                      ACBrTitulo.Carteira +
                      ACBrTitulo.NossoNumero +
                      PadLeft(RightStr(Cedente.Conta,7),7,'0') + '0';
  end;
end;

procedure TACBrBancoBradesco.ValidaNossoNumeroResponsavel(out
  ANossoNumero: String; out ADigVerificador: String;
  const ACBrTitulo: TACBrTitulo);
begin
  ANossoNumero:= '0';
  ADigVerificador:= '0';

  if (ACBrTitulo.ACBrBoleto.Cedente.ResponEmissao = tbBancoEmite) then
  begin
    if (ACBrTitulo.NossoNumero = '') or (ACBrTitulo.NossoNumero = PadLeft('0',ACBrBanco.TamanhoMaximoNossoNum,'0')) then
    begin
      ANossoNumero := StringOfChar('0', CalcularTamMaximoNossoNumero(ACBrTitulo.Carteira, ACBrTitulo.NossoNumero) );
      ADigVerificador := '0';
    end
    else
    begin
      ANossoNumero := ACBrTitulo.NossoNumero;
      ADigVerificador := CalcularDigitoVerificador(ACBrTitulo);
    end;
  end
  else
  begin
    ANossoNumero := ACBrTitulo.NossoNumero;
    ADigVerificador := CalcularDigitoVerificador(ACBrTitulo);
    if (ANossoNumero = EmptyStr) then
      ADigVerificador := '0';
  end;

end;

function TACBrBancoBradesco.ConverterMultaPercentual(
  const ACBrTitulo: TACBrTitulo): Double;
begin
  with ACBrTitulo do
  begin
    if MultaValorFixo then
        if (ValorDocumento > 0) then
          Result := (PercentualMulta / ValorDocumento) * 100
        else
          Result := 0
      else
        Result := PercentualMulta;
  end;

end;

constructor TACBrBancoBradesco.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                 := 2;
   fpNome                   := 'BRADESCO';
   fpNumero                 := 237;
   fpTamanhoMaximoNossoNum  := 11;
   fpTamanhoAgencia         := 4;
   fpTamanhoConta           := 7;
   fpTamanhoCarteira        := 2;
   fpLayoutVersaoArquivo    := 84;
   fpLayoutVersaoLote       := 42;
   fpDensidadeGravacao      := '06250';
   fpModuloMultiplicadorInicial:= 0;
   fpModuloMultiplicadorFinal:= 7;
   fpCodParametroMovimento:= 'MX';
   fpCodigosMoraAceitos    := '123';
end;

function TACBrBancoBradesco.MontaInstrucoesCNAB400(
  const ACBrTitulo: TACBrTitulo; const nRegistro: Integer): String;
var sNossoNumero,sDigitoNossoNumero : String;
begin
  Result := '';

  ValidaNossoNumeroResponsavel(sNossoNumero, sDigitoNossoNumero, ACBrTitulo);

  With ACBrTitulo, ACBrBoleto do begin

    {Primeira instru��o vai no registro 1}
    if Mensagem.Count <= 1 then begin
       Result := '';
       Exit;
    end;

    Result := '2'               +                                                                          // 001-001 IDENTIFICA��O DO LAYOUT PARA O REGISTRO
              Copy(PadRight(Mensagem[1], 80, ' '), 1, 80);                                                 // 002-081 CONTE�DO DA 1� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO

    if Mensagem.Count >= 3 then
      Result := Result +
                Copy(PadRight(Mensagem[2], 80, ' '), 1, 80)                                                // 082-161 CONTE�DO DA 2� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
    else
      Result := Result + PadRight('', 80, ' ');                                                            // 082-161 CONTE�DO DO RESTANTE DAS LINHAS

    if Mensagem.Count >= 4 then
      Result := Result +
                Copy(PadRight(Mensagem[3], 80, ' '), 1, 80)                                                // 162-241 CONTE�DO DA 3� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
    else
      Result := Result + PadRight('', 80, ' ');                                                            // 162-241 CONTE�DO DO RESTANTE DAS LINHAS

    if Mensagem.Count >= 5 then
      Result := Result +
                Copy(PadRight(Mensagem[4], 80, ' '), 1, 80)                                                // 242-321 CONTE�DO DA 4� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
    else
      Result := Result + PadRight('', 80, ' ');                                                            // 242-321 CONTE�DO DO RESTANTE DAS LINHAS


    Result := Result
              + IfThen(DataDesconto2 > 0,FormatDateTime( 'ddmmyy', DataDesconto2),PadLeft('', 6, '0'))     // 322-327 Data limite para concess�o de Desconto 2
              + IntToStrZero( round( ValorDesconto2 * 100 ), 13)                                           // 328-340 Valor do Desconto 2
              + IfThen(DataDesconto3 > 0, FormatDateTime( 'ddmmyy', DataDesconto3) ,PadLeft('', 6, '0'))   // 341-346 Data limite para concess�o de Desconto 3
              + IntToStrZero( round( ValorDesconto3 * 100 ), 13)                                           // 347-359 Valor do Desconto 3
              + space(7)                                                                                   // 360-366 Filler
              + IntToStrZero(StrToIntDef(trim(Carteira), 0), 3)                                            // 367-369 Num. da Carteira
              + IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Agencia), 0), 5)                    // 370-374 C�digo da Ag�ncia Benefici�rio
              + IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Conta)  , 0), 7)                    // 375-381 Num. da Conta-Corrente
              + Cedente.ContaDigito                                                                        // 382-382 DAC C/C
              + sNossoNumero                                                                               // 383-393 Nosso N�mero
              + sDigitoNossoNumero                                                                         // 394-394 DAC Nosso N�mero
              + IntToStrZero( nRegistro + 1, 6);                                                           // 395-400 Num. Sequencial do Registro
  end;
end;

function TACBrBancoBradesco.MontarCampoNossoNumero (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result:= ACBrTitulo.Carteira+'/'+ACBrTitulo.NossoNumero+'-'+CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoBradesco.GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String;
var
  ATipoOcorrencia,
  ATipoBoleto,
  ADataMoraJuros,
  ACodigoMoraJuros,
  ACodigoDesconto: String;
  ADataDesconto,
  ACodigoMulta,
  ADataMulta,
  ATipoAceite,
  AEspecieDoc: String;

  Fsequencia:Integer;
  FdigitoNossoNumero: String;
  FcodCarteira: String;
  ACodProtesto: String;
  ListTransacao: TStringList;

begin
  if (ACBrTitulo.TipoDesconto2<>tdNaoConcederDesconto) or
     (ACBrTitulo.TipoDesconto3<>tdNaoConcederDesconto) or
     (ACBrTitulo.PercentualMulta > 0) then
    Fsequencia     := 3 * ACBrTitulo.ACBrBoleto.ListadeBoletos.IndexOf(ACBrTitulo)
  else
    Fsequencia     := 2 * ACBrTitulo.ACBrBoleto.ListadeBoletos.IndexOf(ACBrTitulo);

  //Caracteristica T�tulo
  FcodCarteira := DefineCaracTitulo(ACBrTitulo);

  //Digito Nosso N�mero
  FdigitoNossoNumero := CalcularDigitoVerificador(ACBrTitulo);

  {C�digo para Protesto}
  ACodProtesto := DefineTipoDiasProtesto(ACBrTitulo);

  {Tipo de Ocorrencia}
  ATipoOcorrencia := TipoOcorrenciaToCodRemessa(ACBrTitulo.OcorrenciaOriginal.Tipo);

  {Aceite do Titulo }
  ATipoAceite := DefineAceite(ACBrTitulo);

  {Especie Documento}
  AEspecieDoc := DefineEspecieDoc(ACBrTitulo);

  {Responsavel Emiss�o}
  ATipoBoleto := DefineResponsEmissao;

  {C�digo Mora}
  ACodigoMoraJuros := DefineCodigoMoraJuros(ACBrTitulo);

  {Data Mora}
  ADataMoraJuros := DefineDataMoraJuros(ACBrTitulo);

  {C�digo Desconto}
  ACodigoDesconto := DefineCodigoDesconto(ACBrTitulo);

  {Data Desconto}
  ADataDesconto := DefineDataDesconto(ACBrTitulo);

  {C�digo Multa}
  ACodigoMulta := DefineCodigoMulta(ACBrTitulo);

  {Data Multa}
  ADataMulta := DefineDataMulta(ACBrTitulo);

  ListTransacao:= TStringList.Create;
  try

    with ACBrTitulo do
    begin
      {REGISTRO P}
      inc(fpQtdRegsLote);
      ListTransacao.Add(IntToStrZero(ACBrBanco.Numero, 3)    + //1 a 3 - C�digo do banco
        '0001'                                               + //4 a 7 - Lote de servi�o
        '3'                                                  + //8 - Tipo do registro: Registro detalhe
        IntToStrZero(Fsequencia+1,5)                         + //N� Sequencial do Registro no Lote 9 13 5 - Num *G038
        'P'                                                  + //14 - C�digo do segmento do registro detalhe
        ' '                                                  + //15 - Uso exclusivo FEBRABAN/CNAB: Branco
        ATipoOcorrencia                                      + //C�digo de Movimento Remessa 16 17 2 - Num *C004
        PadLeft(OnlyNumber(ACBrTitulo.ACBrBoleto.Cedente.Agencia), 5, '0') + //18 a 22 - Ag�ncia mantenedora da conta
        PadRight(ACBrBoleto.Cedente.AgenciaDigito, 1 , '0')  + //23 -D�gito verificador da ag�ncia
        PadLeft(ACBrBoleto.Cedente.conta, 12, '0')           + //24 a 35 - N�mero da Conta Corrente
        Padleft(ACBrBoleto.Cedente.ContaDigito, 1 , '0')     + //36 a 36 D�gito Verificador da Conta Alfa *G011
        ' '                                                  + //Retornaram que deve gravar vazio .. contrario ao layout
        //PadLeft(Copy(Fconta,Length(Fconta) ,1 ),1, ' ')    + //37-37D�gito Verificador da Ag/Conta 37 37 1 - Alfa *G012
        PadLeft(ACBrTitulo.Carteira, 3, '0')                 + //38-40 Identifica��o do Produto 38 40 3 Num *G069
        PadLeft('0', 5, '0')                                 + //Zeros 41 45 5 Num *G069
        PadLeft(NossoNumero, 11, '0')                        + //Nosso N�mero 46 56 11 Num *G069
        PadLeft(FdigitoNossoNumero,1,'0')                    + //Digito do nosso N�mero 57 57 1 Num *G069
        PadLeft(FcodCarteira,1,'0' )                         + //C�digo da Carteira 58 58 1 - Num *C006
        '1'                                                  + //Forma de Cadastr. do T�tulo no Banco 59 59 1 - Num *C007   1-cobran�a Registrada
        '1'                                                  + //Tipo de Documento 60 60 1 - Alfa C008    -1-Tradicional
        ATipoBoleto                                          + //Identifica��o da Emiss�o do Bloqueto 61 61 1 - Num *C009
        ATipoBoleto                                          +//Identifica��o da Distribui��o 62 62 1 - Alfa C010  -Quem emite que distribua...
        PadRight(NumeroDocumento, 15, ' ')                   + //N�mero do Documento de Cobran�a 63 77 15 - Alfa *C011
        FormatDateTime('ddmmyyyy', Vencimento)               + //Data de Vencimento do T�tulo 78 85 8 - Num *C012
        IntToStrZero( round( ValorDocumento * 100), 15)      + //Valor Nominal do T�tulo 86 100 13 2 Num *G070
        Padleft('0', 5, '0')                                 + //Ag�ncia Encarregada da Cobran�a 101 105 5 - Num *C014
        '0'                                                  + //D�gito Verificador da Ag�ncia 106 106 1 - Alfa *G009
        PadRight(AEspecieDoc, 2)                             + //Esp�cie do T�tulo 107 108 2 - Num *C015
        ATipoAceite                                          + //Identific. de T�tulo Aceito/N�o Aceito 109 109 1 - Alfa C016
        FormatDateTime('ddmmyyyy', DataDocumento)            + //Data da Emiss�o do T�tulo 110 117 8 - Num G071
        ACodigoMoraJuros                                     + //C�digo do Juros de Mora 118 118 1 - Num *C018  '1' = Valor por Dia'2' = Taxa Mensal '3' = Isento
        ADataMoraJuros                                       + //Data do Juros de Mora 119 126 8 - Num *C019
        IfThen(ValorMoraJuros > 0, IntToStrZero(round(ValorMoraJuros * 100), 15),PadRight('', 15, '0')) + //juros de Mora por Dia/Taxa 127 141 13 2 Num C020
        ACodigoDesconto                                      + //C�digo do Desconto 1 142 142 1 - Num *C021
        ADataDesconto                                        + //Data do Desconto 1 143 150 8 - Num C022
        IfThen(ValorDesconto > 0, IntToStrZero(
        round(ValorDesconto * 100), 15),PadRight('', 15, '0'))
                                                             + //Valor/Percentual a ser Concedido 151 165 13 2 Num C023
        IntToStrZero( round(ValorIOF * 100), 15)             + //Valor do IOF a ser Recolhido 166 180 13 2 Num C024
        IntToStrZero( round(ValorAbatimento * 100), 15)      + //Valor do Abatimento 181 195 13 2 Num G045

        PadRight(IfThen(SeuNumero <> '',SeuNumero,NumeroDocumento), 25, ' ')                + //Identifica��o do T�tulo na Empresa 196 220 25 - Alfa G072

        IfThen((DataProtesto <> 0) and (DiasDeProtesto > 0), ACodProtesto, '3')            + //C�digo para Protesto 221 221 1 - Num C026

        IfThen((DataProtesto <> 0) and (DiasDeProtesto > 0),
                        PadLeft(IntToStr(DiasDeProtesto), 2, '0'), '00')                   + //N�mero de Dias para Protesto 222 223 2 - Num C027

        IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento), '1', '2')                    + //C�digo para Baixa/Devolu��o 224 224 1 - Num C028

        IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento),PadLeft(IntToStr(DaysBetween(DataBaixa, Vencimento)), 3, '0'), '000') + //N�mero de Dias para Baixa/Devolu��o 225 227 3 - Alfa C029
        '09'                                                + //C�digo da Moeda 228 229 2 - Num *G065   '09' = Real
        PadRight('', 10 , '0')                              + //N� do Contrato da Opera��o de Cr�d. 230 239 10 - Num C030
        ' ');                                                 //240 - Uso exclusivo FEBRABAN/CNAB

      {SEGMENTO Q}
      inc(fpQtdRegsLote);
      ListTransacao.Add(IntToStrZero(ACBrBanco.Numero, 3) + //C�digo do Banco na Compensa��o 1 3 3 - Num G001
        '0001'                                              + //Lote Lote de Servi�o 4 7 4 - Num *G002
        '3'                                                 + //Tipo de Registro 8 8 1 - Num �3� *G003
        IntToStrZero(Fsequencia+ 2 ,5)                      + //N� Sequencial do Registro no Lote 9 13 5 - Num *G038
        'Q'                                                 + //C�d. Segmento do Registro Detalhe 14 14 1 - Alfa �Q� *G039
        ' '                                                 + //Uso Exclusivo FEBRABAN/CNAB 15 15 1 - Alfa Brancos G004
        ATipoOcorrencia                                     + //C�digo de Movimento Remessa 16 17 2 - Num *C004

        {Dados do sacado}
        IfThen(Sacado.Pessoa = pJuridica,'2','1')           + //Tipo Tipo de Inscri��o 18 18 1 - Num *G005
        PadLeft(OnlyNumber(Sacado.CNPJCPF), 15, '0')        + //N�mero N�mero de Inscri��o 19 33 15 - Num *G006
        PadRight(Sacado.NomeSacado, 40, ' ')                + //Nome 34 73 40 - Alfa G013
        PadRight(Sacado.Logradouro + ' ' + Sacado.Numero + ' ' + Sacado.Complemento + ' ' + Sacado.Bairro, 40, ' ') + //Endere�o 74 113 40 - Alfa G032
        PadRight(Sacado.Bairro, 15, ' ')                    + //Bairro 114 128 15 - Alfa G032
        PadLeft(OnlyNumber(ACBrTitulo.Sacado.CEP), 8, '0')  + //CEP 129 133 5 - Num G034 + //Sufixo do CEP 134 136 3 - Num G035
        PadRight(Sacado.Cidade, 15, ' ')                    + // Cidade 137 151 15 - Alfa G033
        PadRight(Sacado.UF, 2, ' ')                         + //Unidade da Federa��o 152 153 2 - Alfa G036
        {Dados do sacador/avalista}
        '0'                                                 + // 154 a 154 - Tipo de Inscri��o 154 154 1 - Num *G005
        PadRight(Sacado.SacadoAvalista.CNPJCPF, 15, '0')    + // N�mero de Inscri��o 155 169 15 - Num *G006
        PadRight(Sacado.SacadoAvalista.NomeAvalista, 40,' ')+ // Nome do Pagadorr/Avalista 170 209 40 - Alfa G013
        PadRight('0', 3, '0')                               + // C�d. Bco. Corresp. na Compensa��o 210 212 3 - Num *C031
        PadRight('',20, ' ')                                + // Nosso N� no Banco Correspondente 213 232 20 - Alfa *C032
        PadRight('', 8, ' '));                                 // FEBRABAN/CNAB 233 240 8 - Alfa Brancos G004

    {SEGMENTO R OPCIONAL }
      if (TipoDesconto2<>tdNaoConcederDesconto) or
         (TipoDesconto3<>tdNaoConcederDesconto) or
         (PercentualMulta > 0) then
      begin
        inc(fpQtdRegsLote);
        ListTransacao.Add(IntToStrZero(ACBrBanco.Numero, 3)    + //C�digo do Banco na Compensa��o 1 3 3 - Num G001
          '0001'                                               + //Lote de Servi�o 4 7 4 - Num *G002
          '3'                                                  + //Tipo de Registro 8 8 1 - Num �3� *G003
          IntToStrZero(Fsequencia+ 3 ,5)                       + //N� Sequencial do Registro no Lote 9 13 5 - Num *G038
          'R'                                                  + //C�d. Segmento do Registro Detalhe 14 14 1 - Alfa �R� *G039
          ' '                                                  + //CNAB Uso Exclusivo FEBRABAN/CNAB 15 15 1 - Alfa Brancos G004
          ATipoOcorrencia                                      + //C�digo de Movimento Remessa 16 17 2 - Num *C004
          TipoDescontoToString(TipoDesconto2)                  + //C�digo do Desconto 2 18 18 1 - Num *C021
          PadLeft(IfThen(TipoDesconto2<>tdNaoConcederDesconto,IfThen(DataDesconto2  > 0, FormatDateTime( 'ddmmyyyy', DataDesconto2),''),''),8,'0') + //Data do Desconto 2 19 26 8 - Num C022
          PadLeft(IfThen(TipoDesconto2<>tdNaoConcederDesconto,IfThen(ValorDesconto2 > 0,IntToStrZero(round(ValorDesconto2 * 100), 15),''),''), 15, '0') + //Valor/Percentual a ser Concedido 27 41 13 2 Num C023
          TipoDescontoToString(TipoDesconto3)                  + //C�digo do Desconto 3 42 42 1 - Num *C021
          PadLeft(IfThen(TipoDesconto3<>tdNaoConcederDesconto,IfThen(DataDesconto3  > 0, FormatDateTime( 'ddmmyyyy', DataDesconto3),'0'),'0'),8,'0') + //Data do Desconto 3 43 50 8 - Num C022
          PadLeft(IfThen(TipoDesconto3<>tdNaoConcederDesconto,IfThen(ValorDesconto3 > 0,IntToStrZero(round(ValorDesconto3 * 100), 15),''),''), 15, '0') + //Valor/Percentual a Ser Concedido 51 65 13 2 Num C023
          ACodigoMulta                                         + //C�digo da Multa 66 66 1 - Alfa G073
          ADataMulta                                           + //Data da Multa 67 74 8 - Num G074
          IfThen(PercentualMulta > 0,
            IntToStrZero(round(PercentualMulta * 100), 15),
          PadRight('', 15, '0'))                               + //Multa Valor/Percentual a Ser Aplicado 75 89 13 2 Num G075
          PadRight('', 10, ' ')                                + //Informa��o ao Pagador Informa��o ao Pagador 90 99 10 - Alfa *C036
          PadRight('', 28, ' ')                                + //Informa��o 3 Mensagem 3 (Tipo de Opera��o, Utiliza��o do Cheque Especial, Consulta Saldo ap�s o Vencimento, N�mero C�d. Identifica��o/Contrato 100 127 28) - Alfa *C037
          PadRight('', 8, '0')                                 + //Informa��o 3 Mensagem 3 Prazo de Validade do Contrato/Autoriza��o 128 135 8 - Num *C037
          PadRight('', 4, ' ')                                 + //Informa��o 3 Mensagem 3 Branco 136 139 4 - Alfa *C037
          PadRight('', 40, ' ')                                + //Mensagem 4 140 179 40 - Alfa *C037
          PadRight('', 20, ' ')                                + //CNAB Uso Exclusivo FEBRABAN/CNAB 180 199 20 - Alfa Brancos G004
          PadLeft('', 8, '0')                                  +//C�d. Ocor. do Pagador 200 207 8 - Num *C038
          PadLeft('', 3, '0')                                  +//C�d. do Banco na Conta do D�bito 208 210 3 - Num G001
          PadLeft('', 5, '0')                                  +//C�digo da Ag�ncia do D�bito 211 215 5 - Num *G008
          PadLeft('', 1, ' ')                                  +//D�gito Verificador da Ag�ncia 216 216 1 - Alfa *G009
          PadLeft('', 12, '0')                                 +//Corrente para D�bito 217 228 12 - Num *G010
          PadLeft('', 1, ' ')                                  +//D�gito Verificador da Conta 229 229 1 - Alfa *G011
          PadLeft('', 1, ' ')                                  +//DV D�gito Verificador Ag/Conta 230 230 1 - Alfa *G012
          PadLeft('', 1, '3')                                  +//Ident. da Emiss�o do Aviso D�b. Aviso para D�bito Autom�tico 231 231 1 - Num *C039
          PadLeft('',9, ' ')                                    //CNAB Uso Exclusivo FEBRABAN/CNAB 232 240 9 - Alfa Brancos G004
        );
      end;
    end;
    Result := RemoverQuebraLinhaFinal(ListTransacao.Text);
  finally
    ListTransacao.Free;
  end;
end;

function TACBrBancoBradesco.GerarLinhaRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList): String;
var
  sOcorrencia, sEspecie, aAgencia: String;
  sProtesto, sTipoSacado, MensagemCedente, aConta, aDigitoConta: String;
  aCarteira, wLinha, sNossoNumero, sDigitoNossoNumero, sTipoBoleto: String;
  aPercMulta: Double;
  LChaveNFE : String;
begin
   Result := '';
   with ACBrTitulo do
   begin
     ValidaNossoNumeroResponsavel(sNossoNumero, sDigitoNossoNumero, ACBrTitulo);

     aAgencia := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Agencia),0),5);
     aConta   := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Conta),0),7);
     aCarteira:= IntToStrZero(StrToIntDef(trim(Carteira),0), 3);
     aDigitoConta := PadLeft(trim(ACBrBoleto.Cedente.ContaDigito),1,'0');

     {C�digo da Ocorrencia}
     sOcorrencia:= TipoOcorrenciaToCodRemessa(OcorrenciaOriginal.Tipo);

     {Tipo de Boleto}
     sTipoBoleto:= DefineTipoBoleto(ACBrTitulo);

     {Especie}
     sEspecie:= DefineEspecieDoc(ACBrTitulo);

     {Intru��es}
     sProtesto:= InstrucoesProtesto(ACBrTitulo);

     {Tipo de Sacado}
     sTipoSacado := DefineTipoSacado(ACBrTitulo);

     { Converte valor em moeda para percentual, pois o arquivo s� permite % }
     aPercMulta := ConverterMultaPercentual(ACBrTitulo);

     {Chave da NFe}
     if ACBrTitulo.ListaDadosNFe.Count>0 then
       LChaveNFe := ACBrTitulo.ListaDadosNFe[0].ChaveNFe
     else
       LChaveNFe := '';

     MensagemCedente := '';

     with ACBrBoleto do
     begin
       if Sacado.SacadoAvalista.CNPJCPF <> '' then
       begin
         MensagemCedente := PadLeft(OnlyNumber(Sacado.SacadoAvalista.CNPJCPF), 15, '0') +  // 335 a 349 - CNPJ do benefici�rio final
         '  ' +                                                                            // 350 a 351 - Brancos
         PadRight(Sacado.SacadoAvalista.NomeAvalista, 43);                                 // 352 a 394 - Nome do benefici�rio final
       end
       else if Mensagem.Text <> '' then
          MensagemCedente := Mensagem[0];

       wLinha:= '1'                                             +  // 001 a 001 - ID Registro
       StringOfChar( '0', 19)                                   +  // 002 a 020 - Dados p/ D�bito Autom�tico
       '0'+ aCarteira                                           +
       aAgencia                                                 +
       aConta                                                   +
       aDigitoConta                                             +
       PadRight( SeuNumero,25,' ')+'000'                        +  // 038 a 062 - Numero de Controle do Participante                                                   +  // 063 a 065 - C�digo do Banco
       IfThen( PercentualMulta > 0, '2', '0')                   +  // 066 a 066 - Indica se exite Multa ou n�o
       IntToStrZero( round( aPercMulta * 100 ) , 4)             +  // 067 a 070 - Percentual de Multa formatado com 2 casas decimais
       sNossoNumero + sDigitoNossoNumero                        +  // 071 a 082 - Identifica��o do Titulo + Digito de auto conferencia de n�mero banc�rio
       IntToStrZero( round( ValorDescontoAntDia * 100), 10)     +  // 083 a 092 - Desconto Bonifica��o por dia
       sTipoBoleto + ' ' + Space(10)                            +  // 093 a 104 - Tipo Boleto(Quem emite) + Identifica��o se emite boleto para d�bito autom�tico +  Identifica��o Opera��o do Banco
       ' ' + '2' + '  ' + sOcorrencia                           +  // 105 a 110 - Ind. Rateio de Credito + Aviso de Debito Aut.: 2=N�o emite aviso + BRANCO + Ocorr�ncia
       PadRight( NumeroDocumento,  10)                          +  // 111 a 120 - Numero Documento
       FormatDateTime( 'ddmmyy', Vencimento)                    +  // 121 a 126 - Data Vencimento
       IntToStrZero( Round( ValorDocumento * 100 ), 13)         +  // 127 a 139 - Valo Titulo
       StringOfChar('0',8) + PadRight(sEspecie,2) + 'N'         +  // 140 a 150 - Zeros + Especie do documento + Idntifica��o(valor fixo N)
       FormatDateTime( 'ddmmyy', DataDocumento )                +  // 151 a 156 - Data de Emiss�o
       sProtesto                                                +  // 157 a 160 - Intru��es de Protesto
       IntToStrZero( round(ValorMoraJuros * 100 ), 13)          +  // 161 a 173 - Valor a ser cobrado por dia de atraso
       IfThen(DataDesconto < EncodeDate(2000,01,01),'000000',
              FormatDateTime( 'ddmmyy', DataDesconto))          +  // 174 a 179 - Data limite para concess�o desconto
       IntToStrZero( round( ValorDesconto * 100 ), 13)          +  // 180 a 192 - Valor Desconto
       IntToStrZero( round( ValorIOF * 100 ), 13)               +  // 193 a 205 - Valor IOF
       IntToStrZero( round( ValorAbatimento * 100 ), 13)        +  // 206 a 218 - Valor Abatimento
       sTipoSacado + PadLeft(OnlyNumber(Sacado.CNPJCPF),14,'0') +  // 219 a 234 - Tipo de Inscri��o + N�mero de Inscri��o do Pagador
       PadRight( Sacado.NomeSacado, 40, ' ')                    +  // 235 a 274 - Nome do Pagador
       PadRight(Sacado.Logradouro + ' ' + Sacado.Numero + ' '   +
         Sacado.Complemento + ' ' + Sacado.Bairro, 40)          +  // 275 a 314 - Endere�o completo do pagador
       PadRight( Sacado.Mensagem, 12, ' ')                      +  // 315 a 326 - 1� Mensagem
       PadRight( Sacado.CEP, 8 )                                +  // 327 a 334 - CEP
       PadRight( MensagemCedente, 60 )                          +  // 335 a 394 - Benefici�rio final ou 2� Mensagem
       IntToStrZero(aRemessa.Count + 1, 6)                      +  // N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO
       LChaveNFe;                                                 // 401 a 444 Chave NFe

       Result := UpperCase(wLinha);

      end;
   end;

end;

procedure TACBrBancoBradesco.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  LLinha, LNossoNumero, LDigitoNossoNumero : String;
begin
  aRemessa.Add(UpperCase(GerarLinhaRegistroTransacao400(ACBrTitulo, aRemessa)));
  LLinha := MontaInstrucoesCNAB400(ACBrTitulo, aRemessa.Count );

  if not(LLinha = EmptyStr) then
    aRemessa.Add(UpperCase(LLinha));

  if (ACBrTitulo.Sacado.SacadoAvalista.NomeAvalista <> '') then
  begin
    ValidaNossoNumeroResponsavel(LNossoNumero, LDigitoNossoNumero, ACBrTitulo);
    LLinha := '7'                                                                + // 001 a 001 - Identifica��o do registro detalhe (7)
    PadRight(Trim(ACBrTitulo.Sacado.SacadoAvalista.Logradouro + ' ' +
                  ACBrTitulo.Sacado.SacadoAvalista.Numero     + ' ' +
                  ACBrTitulo.Sacado.SacadoAvalista.Bairro)  , 45, ' ')           + // 002 a 046 - Endere�o Beneficiario Final
    PadRight(OnlyNumber(ACBrTitulo.Sacado.SacadoAvalista.CEP), 8, '0' )          + // 047 a 054 - CEP + Sufixo do CEP
    PadRight(ACBrTitulo.Sacado.SacadoAvalista.Cidade, 20, ' ')                   + // 055 a 074 - Cidade
    PadRight(ACBrTitulo.Sacado.SacadoAvalista.UF, 2, ' ')                        + // 075 a 076 - UF
    PadRight('', 290, ' ')                                                       + // 077 a 366 - Reserva Filer
    PadLeft(ACBrTitulo.Carteira, 3, '0')                                         + // 367 a 369 - Carteira
    PadLeft(OnlyNumber(ACBrTitulo.ACBrBoleto.Cedente.Agencia), 5, '0')           + // 370 a 374 - Ag�ncia mantenedora da conta
    PadLeft(ACBrTitulo.ACBrBoleto.Cedente.Conta, 7, '0')                         + // 375 a 381 - N�mero da Conta Corrente
    Padleft(ACBrTitulo.ACBrBoleto.Cedente.ContaDigito, 1 , ' ')                  + // 382 a 382 - D�gito Verificador da Conta DAC
    PadLeft(LNossoNumero, 11, '0')                                               + // 383 a 393 - Nosso N�mero
    PadLeft(LDigitoNossoNumero ,1,' ')                                           + // 394 a 394 - Digito Nosso N�mero
    IntToStrZero( ARemessa.Count + 1, 6);                                          // 395 a 400 - N�mero sequencial do registro

    ARemessa.Add(UpperCase(LLinha));
  end;
end;

procedure TACBrBancoBradesco.LerRetorno400(ARetorno: TStringList);
var LTamanhoMaximoNossoNum : Integer;
begin
  LTamanhoMaximoNossoNum := TamanhoMaximoNossoNum;
  try
    if ACBrBanco.ACBrBoleto.LerNossoNumeroCompleto then
      fpTamanhoMaximoNossoNum := LTamanhoMaximoNossoNum+1;
    inherited;
  finally
    fpTamanhoMaximoNossoNum := LTamanhoMaximoNossoNum;
  end;
end;

procedure TACBrBancoBradesco.LerRetorno400Transacao4(ACBrTitulo :TACBrTitulo; ALinha: String);
var
  LURL, LtxId: string;
begin
  inherited;
  LURL := Trim(Copy(ALinha, 29,77));
  LtxId := Trim(Copy(ALinha,106,35));
  if NaoEstaVazio(lURL) and NaoEstaVazio(LtxId) then
     ACBrTitulo.QrCode.PIXQRCodeDinamico(Lurl, LtxId, ACBrTitulo);
end;

function TACBrBancoBradesco.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
  CodOcorrencia: Integer;
begin
  Result := '';
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia),0);

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case CodOcorrencia of
      04: Result := '04-Transfer�ncia de Carteira/Entrada';
      05: Result := '05-Transfer�ncia de Carteira/Baixa';
      07: Result := '07-Confirma��o do Recebimento da Instru��o de Desconto';
      08: Result := '08-Confirma��o do Recebimento do Cancelamento do Desconto';
      15: Result := '15-Franco de Pagamento';
      24: Result := '24-Retirada de Cart�rio e Manuten��o em Carteira';
      25: Result := '25-Protestado e Baixado';
      26: Result := '26-Instru��o Rejeitada';
      27: Result := '27-Confirma��o do Pedido de Altera��o de Outros Dados';
      33: Result := '33-Confirma��o da Altera��o dos Dados do Rateio de Cr�dito';
      34: Result := '34-Confirma��o do Cancelamento dos Dados do Rateio de Cr�dito';
      36: Result := '36-Confirma��o de Envio de E-mail/SMS';
      37: Result := '37-Envio de E-mail/SMS Rejeitado';
      38: Result := '38-Confirma��o de Altera��o do Prazo Limite de Recebimento';
      39: Result := '39-Confirma��o de Dispensa de Prazo Limite de Recebimento';
      40: Result := '40-Confirma��o da Altera��o do N�mero do T�tulo Dado pelo Beneficiario';
      41: Result := '41-Confirma��o da Altera��o do N�mero Controle do Participante';
      42: Result := '42-Confirma��o da Altera��o dos Dados do Pagador';
      43: Result := '43-Confirma��o da Altera��o dos Dados do Benefici�rio Final';
      44: Result := '44-T�tulo Pago com Cheque Devolvido';
      45: Result := '45-T�tulo Pago com Cheque Compensado';
      46: Result := '46-Instru��o para Cancelar Protesto Confirmada';
      47: Result := '47-Instru��o para Protesto para Fins Falimentares Confirmada';
      48: Result := '48-Confirma��o de Instru��o de Transfer�ncia de Carteira/Modalidade de Cobran�a';
      49: Result := '49-Altera��o de Contrato de Cobran�a';
      50: Result := '50-T�tulo Pago com Cheque Pendente de Liquida��o';
      51: Result := '51-T�tulo DDA Reconhecido pelo Pagador';
      52: Result := '52-T�tulo DDA n�o Reconhecido pelo Pagador';
      53: Result := '53-T�tulo DDA recusado pela CIP';
      54: Result := '54-Confirma��o da Instru��o de Baixa de T�tulo Negativado sem Protesto';
    end;
  end
  else
  begin
    case CodOcorrencia of
      10: Result := '10-Baixado Conforme Instru��es da Ag�ncia';
      15: Result := '15-Liquida��o em Cart�rio';
      16: Result := '16-Titulo Pago em Cheque - Vinculado';
      18: Result := '18-Acerto de Deposit�ria';
      21: Result := '21-Acerto do Controle do Participante';
      22: Result := '22-Titulo com Pagamento Cancelado';
      24: Result := '24-Entrada Rejeitada por CEP Irregular';
      25: Result := '25-Confirma��o Recebimento Instru��o de Protesto Falimentar';
      27: Result := '27-Baixa Rejeitada';
      32: Result := '32-Instru��o Rejeitada';
      33: Result := '33-Confirma��o Pedido Altera��o Outros Dados';
      34: Result := '34-Retirado de Cart�rio e Manuten��o Carteira';
      40: Result := '40-Estorno de Pagamento';
      55: Result := '55-Sustado Judicial';
      68: Result := '68-Acerto dos Dados do Rateio de Cr�dito';
      69: Result := '69-Cancelamento dos Dados do Rateio';
      74: Result := '74-Confirma��o Pedido de Exclus�o de Negatativa��o';
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
    06: Result := '06-Liquida��o Normal';
    09: Result := '09-Baixado Automaticamente via Arquivo';
    11: Result := '11-Em Ser - Arquivo de T�tulos Pendentes';
    12: Result := '12-Abatimento Concedido';
    13: Result := '13-Abatimento Cancelado';
    14: Result := '14-Vencimento Alterado';
    17: Result := '17-Liquida��o ap�s baixa ou T�tulo n�o registrado';
    19: Result := '19-Confirma��o Recebimento Instru��o de Protesto';
    20: Result := '20-Confirma��o Recebimento Instru��o Susta��o de Protesto';
    23: Result := '23-Entrada do T�tulo em Cart�rio';
    28: Result := '28-D�bito de tarifas/custas';
    29: Result := '29-Ocorr�ncias do Pagador';
    30: Result := '30-Altera��o de Outros Dados Rejeitados';
    35: Result := '35-Desagendamento do d�bito autom�tico';
    73: Result := '73-Confirma��o Recebimento Pedido de Negativa��o';
  end;

  Result := ACBrSTr(Result);
end;

function TACBrBancoBradesco.CodOcorrenciaToTipo(const CodOcorrencia:
   Integer ) : TACBrTipoOcorrencia;
begin
  Result := toTipoOcorrenciaNenhum;

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case CodOcorrencia of
      04: Result := toRetornoTransferenciaCarteiraEntrada;
      05: Result := toRetornoTransferenciaCarteiraBaixa;
      07: Result := toRetornoRecebimentoInstrucaoConcederDesconto;
      08: Result := toRetornoRecebimentoInstrucaoCancelarDesconto;
      15: Result := toRetornoBaixadoFrancoPagamento;
      24: Result := toRetornoRetiradoDeCartorio;
      25: Result := toRetornoBaixaPorProtesto;
      26: Result := toRetornoComandoRecusado;
      27: Result := toRetornoRecebimentoInstrucaoAlterarDados;
      33: Result := toRetornoAcertoDadosRateioCredito;
      34: Result := toRetornoCancelamentoDadosRateio;
      36: Result := toRetornoConfirmacaoEmailSMS;
      37: Result := toRetornoEmailSMSRejeitado;
      38: Result := toRetornoAlterarPrazoLimiteRecebimento;
      39: Result := toRetornoDispensarPrazoLimiteRecebimento;
      40: Result := toRetornoAlteracaoSeuNumero;
      41: Result := toRetornoAcertoControleParticipante;
      42: Result := toRetornoRecebimentoInstrucaoAlterarNomeSacado;
      43: Result := toRetornoAlterarSacadorAvalista;
      44: Result := toRetornoChequeDevolvido;
      45: Result := toRetornoChequeCompensado;
      46: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
      47: Result := toRetornoProtestoImediatoFalencia;
      48: Result := toRemessaTransferenciaCarteira;
      49: Result := toRetornoTipoCobrancaAlterado;
      50: Result := toRetornoChequePendenteCompensacao;
      51: Result := toRetornoTituloDDAReconhecidoPagador;
      52: Result := toRetornoTituloDDANaoReconhecidoPagador;
      53: Result := toRetornoTituloDDARecusadoCIP;
      54: Result := toRetornoBaixaTituloNegativadoSemProtesto;
    end;
  end
  else
  begin
    case CodOcorrencia of
      10: Result := toRetornoBaixadoInstAgencia;
      15: Result := toRetornoLiquidadoEmCartorio;
      16: Result := toRetornoTituloPagoEmCheque;
      18: Result := toRetornoAcertoDepositaria;
      21: Result := toRetornoAcertoControleParticipante;
      22: Result := toRetornoTituloPagamentoCancelado;
      24: Result := toRetornoEntradaRejeitaCEPIrregular;
      25: Result := toRetornoProtestoImediatoFalencia;
      27: Result := toRetornoBaixaRejeitada;
      32: Result := toRetornoComandoRecusado;
      33: Result := toRetornoRecebimentoInstrucaoAlterarDados;
      34: Result := toRetornoRetiradoDeCartorio;
      40: Result := toRetornoEstornoPagamento;
      55: Result := toRetornoTituloSustadoJudicialmente;
      68: Result := toRetornoAcertoDadosRateioCredito;
      69: Result := toRetornoCancelamentoDadosRateio;
      74: Result := toRetornoConfirmacaoPedidoExclNegativacao;
    end;
  end;

  if (Result <> toTipoOcorrenciaNenhum) then
    Exit;

  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    09: Result := toRetornoBaixadoViaArquivo;
    11: Result := toRetornoTituloEmSer;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    17: Result := toRetornoLiquidadoAposBaixaouNaoRegistro;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    23: Result := toRetornoEncaminhadoACartorio;
    28: Result := toRetornoDebitoTarifas;
    29: Result := toRetornoOcorrenciasdoSacado;
    30: Result := toRetornoAlteracaoOutrosDadosRejeitada;
    35: Result := toRetornoDesagendamentoDebitoAutomatico;
    73: Result := toRetornoConfirmacaoRecebPedidoNegativacao;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoBradesco.TipoOcorrenciaToCod(
  const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  Result := '';

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case TipoOcorrencia of
      toRetornoTransferenciaCarteiraEntrada                 : Result := '04';
      toRetornoTransferenciaCarteiraBaixa                   : Result := '05';
      toRetornoRecebimentoInstrucaoConcederDesconto         : Result := '07';
      toRetornoRecebimentoInstrucaoCancelarDesconto         : Result := '08';
      toRetornoBaixadoFrancoPagamento                       : Result := '15';
      toRetornoRetiradoDeCartorio                           : Result := '24';
      toRetornoBaixaPorProtesto                             : Result := '25';
      toRetornoComandoRecusado                              : Result := '26';
      toRetornoRecebimentoInstrucaoAlterarDados             : Result := '27';
      toRetornoAcertoDadosRateioCredito                     : Result := '33';
      toRetornoCancelamentoDadosRateio                      : Result := '34';
      toRetornoConfirmacaoEmailSMS                          : Result := '36';
      toRetornoEmailSMSRejeitado                            : Result := '37';
      toRetornoAlterarPrazoLimiteRecebimento                : Result := '38';
      toRetornoDispensarPrazoLimiteRecebimento              : Result := '39';
      toRetornoAlteracaoSeuNumero                           : Result := '40';
      toRetornoAcertoControleParticipante                   : Result := '41';
      toRetornoRecebimentoInstrucaoAlterarNomeSacado        : Result := '42';
      toRetornoAlterarSacadorAvalista                       : Result := '43';
      toRetornoChequeDevolvido                              : Result := '44';
      toRetornoChequeCompensado                             : Result := '45';
      toRetornoRecebimentoInstrucaoSustarProtesto           : Result := '46';
      toRetornoProtestoImediatoFalencia                     : Result := '47';
      toRemessaTransferenciaCarteira                        : Result := '48';
      toRetornoTipoCobrancaAlterado                         : Result := '49';
      toRetornoChequePendenteCompensacao                    : Result := '50';
      toRetornoTituloDDAReconhecidoPagador                  : Result := '51';
      toRetornoTituloDDANaoReconhecidoPagador               : Result := '52';
      toRetornoTituloDDARecusadoCIP                         : Result := '53';
      toRetornoBaixaTituloNegativadoSemProtesto             : Result := '54';
    end;
  end
  else
  begin
    case TipoOcorrencia of
      toRetornoBaixadoInstAgencia                           : Result := '10';
      toRetornoLiquidadoEmCartorio                          : Result := '15';
      toRetornoTituloPagoEmCheque                           : Result := '16';
      toRetornoAcertoDepositaria                            : Result := '18';
      toRetornoAcertoControleParticipante                   : Result := '21';
      toRetornoTituloPagamentoCancelado                     : Result := '22';
      toRetornoEntradaRejeitaCEPIrregular                   : Result := '24';
      toRetornoProtestoImediatoFalencia                     : Result := '25';
      toRetornoBaixaRejeitada                               : Result := '27';
      toRetornoComandoRecusado                              : Result := '32';
      toRetornoRecebimentoInstrucaoAlterarDados             : Result := '33';
      toRetornoRetiradoDeCartorio                           : Result := '34';
      toRetornoEstornoPagamento                             : Result := '40';
      toRetornoTituloSustadoJudicialmente                   : Result := '55';
      toRetornoAcertoDadosRateioCredito                     : Result := '68';
      toRetornoCancelamentoDadosRateio                      : Result := '69';
      toRetornoConfirmacaoPedidoExclNegativacao             : Result := '74';
    end;
  end;

  if (Result <> '') then
    Exit;

  case TipoOcorrencia of
    toRetornoRegistroConfirmado                             : Result := '02';
    toRetornoRegistroRecusado                               : Result := '03';
    toRetornoLiquidado                                      : Result := '06';
    toRetornoBaixadoViaArquivo                              : Result := '09';
    toRetornoTituloEmSer                                    : Result := '11';
    toRetornoAbatimentoConcedido                            : Result := '12';
    toRetornoAbatimentoCancelado                            : Result := '13';
    toRetornoVencimentoAlterado                             : Result := '14';
    toRetornoLiquidadoAposBaixaouNaoRegistro                : Result := '17';
    toRetornoRecebimentoInstrucaoProtestar                  : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto             : Result := '20';
    toRetornoEncaminhadoACartorio                           : Result := '23';
    toRetornoDebitoTarifas                                  : Result := '28';
    toRetornoOcorrenciasdoSacado                            : Result := '29';
    toRetornoAlteracaoOutrosDadosRejeitada                  : Result := '30';
    toRetornoDesagendamentoDebitoAutomatico                 : Result := '35';
    toRetornoConfirmacaoRecebPedidoNegativacao              : Result := '73';
  else
    Result := '02';
  end;
end;

function TACBrBancoBradesco.CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; const CodMotivo: String): String;
begin
   case TipoOcorrencia of
      toRetornoRegistroConfirmado:
      case StrToIntDef(CodMotivo,999) of
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
         45: Result := '45-Nome do Pagador inv�lido';
         46: Result := '46-Tipo/num. de inscri��o do Pagador inv�lidos';
         47: Result := '47-Endere�o do Pagador n�o informado';
         48: Result := '48-CEP invalido';
         50: Result := '50-CEP referente a Banco correspondente';
         53: Result := '53-N� de inscri��o do Benefici�rio Final inv�lidos (CPF/CNPJ)';
         54: Result := '54-Benefici�rio Final n�o informado';
         67: Result := '67-D�bito autom�tico agendado';
         68: Result := '68-D�bito n�o agendado - erro nos dados de remessa';
         69: Result := '69-D�bito n�o agendado - Pagador n�o consta no cadastro de autorizante';
         70: Result := '70-D�bito n�o agendado - Cedente n�o autorizado pelo Pagador';
         71: Result := '71-D�bito n�o agendado - Cedente n�o participa da modalidade de d�bito autom�tico';
         72: Result := '72-D�bito n�o agendado - C�digo de moeda diferente de R$';
         73: Result := '73-D�bito n�o agendado - Data de vencimento inv�lida';
         75: Result := '75-D�bito n�o agendado - Tipo do n�mero de inscri��o do pagador debitado inv�lido';
         76: Result := '76-Pagador Eletr�nico DDA (NOVO)- Esse motivo somente ser� disponibilizado no arquivo retorno para as empresas cadastradas nessa condi��o';
         86: Result := '86-Seu n�mero do documento inv�lido';
         89: Result := '89-Email pagador nao enviado - Titulo com debito automatico';
         90: Result := '90-Email pagador nao enviado - Titulo com cobranca sem registro';
      else
         if CodMotivo = 'P1' then
            Result := 'P1-Registrado com QR CODE PIX'
         else if CodMotivo = 'P2' then
            Result := 'P2-Registrado sem QR CODE PIX'
         else if CodMotivo = 'P3' then
            Result := 'P3-Chave Pix Inv�lida'
         else if CodMotivo = 'P4' then
            Result := 'P4-Chave Pix sem Cadastro no DICT'
         else if CodMotivo = 'P5' then
            Result := 'P5-Chave Pix n�o Compat�vel CNPJ/CPF ou Ag�ncia/Conta Informada'
         else if CodMotivo = 'P6' then
            Result := 'P6-Identificador (TXID) em Duplicidade'
         else if CodMotivo = 'P7' then
            Result := 'P7-Identificador (TXID) Inv�lido ou N�o Encontrado'
         else if CodMotivo = 'P8' then
            Result := 'P8-Altera��o N�o Permitida - QR CODE conclu�do, removido pelo PSP ou removido pelo usu�rio recebedor'
         else
            Result:= CodMotivo +' - Outros Motivos';
      end;
      toRetornoRegistroRecusado:
      case StrToIntDef(CodMotivo,999) of
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
         46: Result:= 'Tipo/numero inscricao pagador invalido';
         47: Result:= 'Endereco pagador nao informado';
         48: Result:= 'CEP invalido';
         50: Result:= 'CEP irregular - Banco correspondente';
         63: Result:= 'Entrada para titulo ja cadastrado';
         65: Result:= 'Limite excedido';
         66: Result:= 'Numero autorizacao inexistente';
         68: Result:= 'Debito nao agendado - Erro nos dados da remessa';
         69: Result:= 'Debito nao agendado - Pagador nao consta no cadastro de autorizante';
         70: Result:= 'Debito nao agendado - Cedente nao autorizado pelo pagador';
         71: Result:= 'Debito nao agendado - Cedente nao participa de debito automatico';
         72: Result:= 'Debito nao agendado - Codigo de moeda diferente de R$';
         73: Result:= 'Debito nao agendado - Data de vencimento invalida';
         74: Result:= 'Debito nao agendado - Conforme seu pedido titulo nao registrado';
         75: Result:= 'Debito nao agendado - Tipo de numero de inscricao de debitado invalido';
      else
         Result:= CodMotivo +' - Outros Motivos';
      end;
      toRetornoLiquidado:
      case StrToIntDef(CodMotivo,999) of
         00: Result:= '00-Titulo pago com dinheiro';
         15: Result:= '15-Titulo pago com cheque';
         42: Result:= '42-Rateio nao efetuado';
      else
         Result:= CodMotivo +' - Outros Motivos';
      end;
      toRetornoBaixadoViaArquivo:
      case StrToIntDef(CodMotivo,999) of
         00: Result:= '00-Ocorrencia aceita';
         10: Result:= '10=Baixa comandada pelo cliente';
      else
         Result:= CodMotivo +' - Outros Motivos';
      end;
      toRetornoBaixadoInstAgencia:
         case StrToIntDef(CodMotivo,999) of
            00: Result:= '00-Baixado conforme instrucoes na agencia';
            14: Result:= '14-Titulo protestado';
            15: Result:= '15-Titulo excluido';
            16: Result:= '16-Titulo baixado pelo banco por decurso de prazo';
            20: Result:= '20-Titulo baixado e transferido para desconto';
         else
            Result:= CodMotivo +' - Outros Motivos';
         end;
      toRetornoLiquidadoAposBaixaouNaoRegistro:
      case StrToIntDef(CodMotivo,999) of
         00: Result:= '00-Pago com dinheiro';
         15: Result:= '15-Pago com cheque';
      else
         Result:= CodMotivo +' - Outros Motivos';
      end;

      toRetornoLiquidadoEmCartorio:
      case StrToIntDef(CodMotivo,999) of
         00: Result:= '00-Pago com dinheiro';
         15: Result:= '15-Pago com cheque';
      else
         Result:= CodMotivo +' - Outros Motivos';
      end;

      toRetornoEntradaRejeitaCEPIrregular:
      case StrToIntDef(CodMotivo,999) of
         48: Result:= '48-CEP invalido';
      else
         Result:= CodMotivo +' - Outros Motivos';
      end;

      toRetornoBaixaRejeitada:
      case StrToIntDef(CodMotivo,999) of
         04: Result:= '04-Codigo de ocorrencia nao permitido para a carteira';
         07: Result:= '07-Agencia\Conta\Digito invalidos';
         08: Result:= '08-Nosso numero invalido';
         10: Result:= '10-Carteira invalida';
         15: Result:= '15-Carteira\Agencia\Conta\Nosso Numero invalidos';
         40: Result:= '40-Titulo com ordem de protesto emitido';
         42: Result:= '42-Codigo para baixa/devolucao via Telebradesco invalido';
         60: Result:= '60-Movimento para titulo nao cadastrado';
         77: Result:= '70-Transferencia para desconto nao permitido para a carteira';
         85: Result:= '85-Titulo com pagamento vinculado';
      else
         Result:= CodMotivo +' - Outros Motivos';
      end;

      toRetornoDebitoTarifas:
      case StrToIntDef(CodMotivo,999) of
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
         Result:= CodMotivo +' - Outros Motivos';
      end;

      toRetornoOcorrenciasdoSacado:
      case StrToIntDef(CodMotivo,999) of
         78 : Result:= '78-Pagador alega que faturamento e indevido';
         116: Result:= '116-Pagador aceita/reconhece o faturamento';
      else
         Result:= CodMotivo +' - Outros Motivos';
      end;

      toRetornoALteracaoOutrosDadosRejeitada:
      case StrToIntDef(CodMotivo,999) of
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
         46: Result:= '46-Tipo/n�mero de inscri��o do pagador inv�lidos';
         48: Result:= '48-Cep Inv�lido';
         53: Result:= '53-Tipo/N�mero de inscri��o do benefici�rio final inv�lidos';
         54: Result:= '54-Benefici�rio Final n�o informado';
         57: Result:= '57-C�digo da multa inv�lido';
         58: Result:= '58-Data da multa inv�lida';
         60: Result:= '60-Movimento para T�tulo n�o cadastrado';
         79: Result:= '79-Data de Juros de mora Inv�lida';
         80: Result:= '80-Data do desconto inv�lida';
         85: Result:= '85-T�tulo com Pagamento Vinculado.';
         88: Result:= '88-E-mail Pagador n�o lido no prazo 5 dias';
         91: Result:= '91-E-mail Pagador n�o recebido';
      else
         Result:= CodMotivo +' - Outros Motivos';
      end;

      toRetornoComandoRecusado:
      case StrToIntDef(CodMotivo,999) of
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
         45 : Result:= '45-Nome do Pagador n�o informado';
         46 : Result:= '46-Tipo/n�mero de inscri��o do Pagador inv�lidos';
         47 : Result:= '47-Endere�o do Pagador n�o informado';
         48 : Result:= '48-CEP Inv�lido';
         50 : Result:= '50-CEP referente a um Banco correspondente';
         53 : Result:= '53-Tipo de inscri��o do Benefici�rio Final inv�lidos';
         60 : Result:= '60-Movimento para T�tulo n�o cadastrado';
         85 : Result:= '85-T�tulo com pagamento vinculado';
         86 : Result:= '86-Seu n�mero inv�lido';
         94 : Result:= '94-T�tulo Penhorado � Instru��o N�o Liberada pela Ag�ncia';

      else
         Result:= CodMotivo +' - Outros Motivos';
      end;

      toRetornoDesagendamentoDebitoAutomatico:
      case StrToIntDef(CodMotivo,999) of
         81 : Result:= '81-Tentativas esgotadas, baixado';
         82 : Result:= '82-Tentativas esgotadas, pendente';
         83 : Result:= '83-Cancelado pelo Pagador e Mantido Pendente, conforme negocia��o';
         84 : Result:= '84-Cancelado pelo Pagador e baixado, conforme negocia��o';
      else
         Result:= CodMotivo +' - Outros Motivos';
      end;

      toRetornoVencimentoAlterado, toRetornoAbatimentoConcedido, toRetornoAbatimentoCancelado:
      if CodMotivo = 'P8' then
           Result := 'P8-Altera��o n�o Permitida - QR CODE Pago ou Cancelado'
        else
           Result:= CodMotivo +' - Outros Motivos'


   else
      Result:= CodMotivo +' - Outros Motivos';
   end;

   Result := ACBrSTr(Result);
end;

function TACBrBancoBradesco.CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    03 : Result:= toRemessaProtestoFinsFalimentares;        {Pedido de Protesto Falimentar}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Altera��o de vencimento}
    07 : Result:= toRemessaAlterarControleParticipante;     {Altera��o do controle do participante}
    08 : Result:= toRemessaAlterarNumeroControle;           {Altera��o de seu n�mero}
    09 : Result:= toRemessaProtestar;                       {Pedido de protesto}
    18 : Result:= toRemessaCancelarInstrucaoProtestoBaixa;  {Sustar protesto e baixar}
    19 : Result:= toRemessaCancelarInstrucaoProtesto;       {Sustar protesto e manter na carteira}
    22 : Result:= toRemessaTransfCessaoCreditoIDProd10;     {Transfer�ncia Cess�o cr�dito ID. Prod.10}
    23 : Result:= toRemessaTransferenciaCarteira;           {Transfer�ncia entre Carteiras}
    24 : Result:= toRemessaDevTransferenciaCarteira;        {Dev. Transfer�ncia entre Carteiras}
    31 : Result:= toRemessaOutrasOcorrencias;               {Altera��o de Outros Dados}
    68 : Result:= toRemessaAcertarRateioCredito;            {Acerto nos dados do rateio de Cr�dito}
    69 : Result:= toRemessaCancelarRateioCredito;           {Cancelamento do rateio de cr�dito.}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;

end;

function TACBrBancoBradesco.TipoOcorrenciaToCodRemessa(
  const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case TipoOcorrencia of
        toRemessaBaixar                           : Result := '02';
        toRemessaConcederAbatimento               : Result := '04';
        toRemessaCancelarAbatimento               : Result := '05';
        toRemessaAlterarVencimento                : Result := '06';
        toRemessaConcederDesconto                 : Result := '07';
        toRemessaCancelarDesconto                 : Result := '08';
        toRemessaProtestar                        : Result := '09';
        toRemessaCancelarInstrucaoProtestoBaixa   : Result := '10';
        toRemessaCancelarInstrucaoProtesto        : Result := '11';
        toRemessaDispensarJuros                   : Result := '13';
        toRemessaAlterarNomeEnderecoSacado        : Result := '31';
        toRemessaDispensarMulta                   : Result := '15';
        toRemessaNegativacaoSemProtesto           : Result := '45';
        toRemessaBaixaTituloNegativadoSemProtesto : Result := '46';
      else
        Result := '01';
    end;

  end
  else
  begin
    case TipoOcorrencia of
        toRemessaBaixar                         : Result := '02'; {Pedido de Baixa}
        toRemessaProtestoFinsFalimentares       : Result := '03'; {Pedido de Protesto Falimentar}
        toRemessaConcederAbatimento             : Result := '04'; {Concess�o de Abatimento}
        toRemessaCancelarAbatimento             : Result := '05'; {Cancelamento de Abatimento concedido}
        toRemessaAlterarVencimento              : Result := '06'; {Altera��o de vencimento}
        toRemessaAlterarControleParticipante    : Result := '07'; {Altera��o do controle do participante}
        toRemessaAlterarNumeroControle          : Result := '08'; {Altera��o de seu n�mero}
        toRemessaProtestar                      : Result := '09'; {Pedido de protesto}
        toRemessaCancelarInstrucaoProtestoBaixa : Result := '18'; {Sustar protesto e baixar}
        toRemessaCancelarInstrucaoProtesto      : Result := '19'; {Sustar protesto e manter na carteira}
        toRemessaAlterarValorTitulo             : Result := '20'; {Altera��o de valor}
        toRemessaTransferenciaCarteira          : Result := '23'; {Transfer�ncia entre carteiras}
        toRemessaDevTransferenciaCarteira       : Result := '24'; {Dev. Transfer�ncia entre carteiras}
        toRemessaOutrasOcorrencias              : Result := '31'; {Altera��o de Outros Dados}
      else
        Result := '01';                                           {Remessa}
    end;

  end;

end;


end.


