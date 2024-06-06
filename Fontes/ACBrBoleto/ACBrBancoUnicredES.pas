{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliana Tamizou, Jos� M S Junior                }
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

unit ACBrBancoUnicredES;

interface

uses
  Classes, SysUtils, Contnrs, ACBrBoleto, ACBrBancoUnicredRS, ACBrBoletoConversao;

type

  { TACBrBancoUnicredES }

  TACBrBancoUnicredES = class(TACBrBancoUnicredRS)
  private
    function CodMultaToStr(const pCodigoMulta : TACBrCodigoMulta): String;
    function CodJurosToStr(const pCodigoJuros : TACBrCodigoJuros; ValorMoraJuros : Currency): String;
    function CodDescontoToStr(const pCodigoDesconto : TACBrCodigoDesconto): String;
  protected
    function DefineNumeroDocumentoModulo(const ACBrTitulo: TACBrTitulo): String; override;
    function DefinePosicaoNossoNumeroRetorno: Integer; override;
    function DefineSeuNumeroRetorno(const ALinha: String): String; override;
    function DefineNumeroDocumentoRetorno(const ALinha: String): String; override;
    function DefineCodigoProtesto(const ACBrTitulo: TACBrTitulo): String; override;   //Utilizado para definir C�digo Protesto do t�tulo na remessa

  public
    Constructor create(AOwner: TACBrBanco);

    function MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String; override;
    function GerarRegistroHeader240 ( NumeroRemessa: Integer ) : String;override;
    function GerarRegistroTransacao240(ACBrTitulo : TACBrTitulo): String; override;
    procedure GerarRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroHeader400(NumeroRemessa: Integer; ARemessa: TStringList);override;
    Procedure LerRetorno400(ARetorno:TStringList); override;
    Procedure LerRetorno240(ARetorno:TStringList); override;
    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer ) : TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String; Override;
    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia : TACBrTipoOcorrencia ; CodMotivo : Integer) : String ; override;
    function CodComplementoMovimento(const ACodMotivo: String): String;
    function TipoOcorrenciaToCodRemessa(const ATipoOcorrencia: TACBrTipoOcorrencia): String; override;
    procedure DefineRejeicaoComplementoRetorno(const ALinha: String; out ATitulo : TACBrTitulo); override;
    function DefinerCnpjCPFRetorno240(const ALinha: String): String; override;         //Define retorno rCnpjCPF
    procedure DefineCanalLiquidacaoRetorno240(const ALinha: String; out ATitulo : TACBrTitulo); override;
    function CodigoLiquidacaoDescricao( CodLiquidacao : Integer) : String;
    function DefineCaucionada(const ACBrTitulo: TACBrTitulo): String;
  end;

implementation

uses {$IFDEF COMPILER6_UP} dateutils {$ELSE} ACBrD5 {$ENDIF},
  StrUtils, ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.Math, ACBrUtil.DateTime;

{ TACBrBancoUnicredES }

constructor TACBrBancoUnicredES.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                   := 8;
   fpNome                     := 'UNICRED DO BRASIL';
   fpNumero                   := 136;
   fpTamanhoMaximoNossoNum    := 10;
   fpTamanhoAgencia           := 4;
   fpTamanhoConta             := 10;
   fpTamanhoCarteira          := 2;
   fpCodParametroMovimento    := '000';
   fpCodigosMoraAceitos       := '125';
   fpModuloMultiplicadorFinal := 9;
   fpLayoutVersaoLote         := 044;
   fpLayoutVersaoArquivo      := 085;
end;

function TACBrBancoUnicredES.MontarCampoNossoNumero (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result := ACBrTitulo.NossoNumero + '-'+ CalcularDigitoVerificador(ACBrTitulo);
end;

procedure TACBrBancoUnicredES.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  sDigitoNossoNumero, sAgencia : String;
  sTipoSacado, sConta, sProtesto    : String;
  sCarteira, sLinha, sNossoNumero, sTipoMulta,sValorMulta, LCaucionada : String;
begin

  with ACBrTitulo do
  begin
    ValidaNossoNumeroResponsavel(sNossoNumero, sDigitoNossoNumero, ACBrTitulo);

    sAgencia      := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Agencia), 0), 5);
    sConta        := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Conta)  , 0), 7);
    sCarteira     := IntToStrZero(StrToIntDef(trim(Carteira), 0), 3);

    sTipoSacado := DefineTipoSacado(ACBrTitulo);

    {Pegando campo Intru��es}
    sProtesto:= DefineCodigoProtesto(ACBrTitulo);

    {Verifica o Tipo da Multa}
    if MultaValorFixo then
      CodigoMulta := cmValorFixo;

    sTipoMulta := IfThen( PercentualMulta > 0, CodMultaToStr(CodigoMulta), '3');

    {Calculo de Multa}
    if PercentualMulta > 0 then
    begin
      case StrToIntDef(sTipoMulta,3) of
        1: sValorMulta := FloatToStr(TruncTo((ValorDocumento*( 1 + PercentualMulta/100)-ValorDocumento),2)*100);
        2: sValorMulta := IntToStrZero(Round(PercentualMulta * 100), 10);
        else
          sValorMulta  := PadRight('', 10, '0');
      end;
    end;

    {Define caucionada}
    LCaucionada := DefineCaucionada(ACBrTitulo);

    with ACBrBoleto do
    begin
       sLinha:= '1'                                                           +{ 001 a 001  	Identifica��o do Registro }
                sAgencia                                                      +{ 002 a 006  	Ag�ncia do BENEFICI�RIO na UNICRED }
                Cedente.AgenciaDigito                                         +{ 007 a 007  	D�gito da Ag�ncia  	001 }
                PadLeft(sConta, 12, '0')                                      +{ 008 a 019  	Conta Corrente  	012 }
                Cedente.ContaDigito                                           +{ 020 a 020  	D�gito da Conta Corrente  	001 }
                '0'                                                           +{ 021 a 021  	Zero  	001  	Zero }
                sCarteira                                                     +{ 022 a 024  	C�digo da Carteira  	003 }
                StringOfChar('0', 13)                                         +{ 025 a 037  	Zeros	013  	Zeros }
                PadRight(ACBrTitulo.SeuNumero, 25, ' ')                       +{ 038 a 062	  N� Controle do Participante (Uso da empresa) 	025 }
                '136'                                                         +{ 063 a 065	  C�digo do Banco na C�mara de Compensa��o	003	136 }
                StringOfChar('0', 2)                                          +{ 066 a 067	  Zeros	002	Zeros }
                Space(25)                                                     +{ 068 a 092	  Branco	025	Branco}
                '0'                                                           +{ 093 a 093	  Filler	001	Zeros}
                sTipoMulta                                                    +{ 094 a 094	  C�digo da Multa	001}
                PadLeft(sValorMulta, 10, '0')                                 +{ 095 a 104	  Valor/Percentual da Multa	010 }
                CodJurosToStr(CodigoMoraJuros,ValorMoraJuros)                 +{ 105 a 105	  Tipo de Valor Mora	001}
                'N'                                                           +{ 106 a 106	  Filler	001 }
                LCaucionada                                                   +{ 107 a 107	  Caucionada }
                Space(1)                                                      +{ 108 a 108	  108 - Brancos}
                TipoOcorrenciaToCodRemessa(OcorrenciaOriginal.Tipo)           +{ 109 a 110	  Identifica��o da Ocorr�ncia	002 }
                PadRight(ACBrTitulo.SeuNumero, 10)                            +{ 111 a 120	  N� do Documento (Seu n�mero)	010 }
                FormatDateTime( 'ddmmyy', Vencimento)                         +{ 121 a 126	  Data de vencimento do T�tulo	006 }
                IntToStrZero(Round(ValorDocumento * 100 ), 13)                +{ 127 a 139	  Valor do T�tulo	013 }
                StringOfChar('0', 3)                                          +{ 140 a 142	  Filler	003}
                StringOfChar('0', 5)                                          +{ 143 a 147	  Filler	005	Zeros}
                StringOfChar('0', 2)                                          +{ 148 a 149	  Filler	002	Zeros}
                CodDescontoToStr(CodigoDesconto)                              +{ 150 a 150	  C�digo do desconto	001}
                FormatDateTime('ddmmyy', DataDocumento)                       +{ 151 a 156	  Data de emiss�o do T�tulo	006 }
                '0'                                                           +{ 157 a 157	  Filler	004 }
                IfThen((DataProtesto <> 0) and (DiasDeProtesto > 0),
                        sProtesto, '3')                                       +{ 158 a 158	  TipoDiasProtesto }
                IfThen((DataProtesto <> 0) and (DiasDeProtesto > 0),
                        PadLeft(IntToStr(DiasDeProtesto), 2, '0'), '00')      +{ 159 a 160      N�mero de Dias para Protesto }
                IntToStrZero(Round(ValorMoraJuros * 100), 13)                 +{ 161 a 173  	Valor de Mora  	013 }
                IfThen(DataDesconto < EncodeDate(2000,01,01), '000000',
                       FormatDateTime('ddmmyy', DataDesconto))                +{ 174 a 179  	Data Limite P/Concess�o de Desconto  	006 }
                IntToStrZero(Round(ValorDescontoAntDia * 100), 13)            +{ 180 a 192  	Valor do Desconto  	013 }
                PadLeft(sNossoNumero + sDigitoNossoNumero, 11, '0')           +{ 193 a 203  	Nosso N�mero na UNICRED  	011 }
                StringOfChar('0', 2)                                          +{ 204 a 205  	Zeros  	002 }
                ifthen(TipoOcorrenciaToCodRemessa(OcorrenciaOriginal.Tipo) <> '04',
                       StringOfChar('0', 13),
                       IntToStrZero(Round(ValorAbatimento * 100), 13))        +{ 206 a 218  	Valor do Abatimento a ser concedido   	013 }
                sTipoSacado                                                   +{ 219 a 220	  Tipo de inscri��o do Pagador 01 � CPF 02 - CNPJ }
                PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0')                  +{ 221 a 234  	N� Inscri��o do Pagador  	014 }
                PadRight(Sacado.NomeSacado, 40, ' ')                          +{ 235 a 274  	Nome/Raz�o Social do Pagador  	040   }
                PadRight(Sacado.Logradouro + ' ' + Sacado.Numero, 40)         +{ 275 a 314  	Endere�o do Pagador  	040 }
                PadRight(Sacado.Bairro, 12, ' ')                              +{ 315 a 326  	Bairro do Pagador  	012 }
                PadRight(Sacado.CEP, 8, ' ')                                  +{ 327 a 334  	CEP do Pagador  	008 }
                PadRight(Sacado.Cidade, 20, ' ')                              +{ 335 a 354  	Cidade do Pagador  	020 }
                PadRight(Sacado.UF, 2, ' ')                                   +{ 355 a 356  	UF do Pagador  	002 }
                Space(38)                                                     +{ 357 a 394  	Pagador/Avalista   	038 }
                IntToStrZero(aRemessa.Count + 1, 6)                           ;{ 395 a 400  	N� Sequencial do Registro  	006  	N� Sequencial do Registro }

       aRemessa.Add(UpperCase(sLinha));
    end;
  end;
end;

procedure TACBrBancoUnicredES.LerRetorno240(ARetorno: TStringList);
begin
  fpTamanhoMaximoNossoNum := 19;
  try
    inherited;
  finally
    fpTamanhoMaximoNossoNum := 10;
  end;

end;

procedure TACBrBancoUnicredES.LerRetorno400(ARetorno: TStringList);
var
  Titulo : TACBrTitulo;
  ContLinha, MotivoLinha, i : Integer;
  rAgencia    :String;
  rConta, rDigitoConta      :String;
  Linha, rCedente, rCNPJCPF :String;
  rCodEmpresa               :String;
  codInstrucao              :String;
  LCodigoOrigem             : Integer;
  LTipoOcorrencia           : TACBrTipoOcorrencia;
begin

  if StrToIntDef(copy(ARetorno.Strings[0],77,3),-1) <> Numero then
    raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                             'n�o � um arquivo de retorno do '+ Nome));

  rCodEmpresa:= trim(Copy(ARetorno[0],108,14));
  rCedente   := trim(Copy(ARetorno[0],47,30));

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0],101,7),0);

  if (StrToIntDef( Copy(ARetorno[0], 95, 6 ), 0) > 0) then
    ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0],95,2)+'/'+
                                                            Copy(ARetorno[0],97,2)+'/'+
                                                            Copy(ARetorno[0],99,2),0, 'DD/MM/YY' );

  rAgencia := trim(Copy(ARetorno[1], 18, ACBrBanco.TamanhoAgencia));
  rConta   := trim(Copy(ARetorno[1], 23, 8));
  rDigitoConta := Copy(ARetorno[1], 31 ,1);

  case StrToIntDef(Copy(ARetorno[1],2,2),0) of
     1: rCNPJCPF := Copy(ARetorno[1],7,11);
     2: rCNPJCPF := Copy(ARetorno[1],4,14);
  else
    rCNPJCPF := Copy(ARetorno[1],4,14);
  end;

  ValidarDadosRetorno(rAgencia, rConta);
  with ACBrBanco.ACBrBoleto do
  begin
    if (not LeCedenteRetorno) and (rCodEmpresa <> PadLeft(Cedente.CodigoCedente, 14, '0')) then
       raise Exception.Create(ACBrStr('C�digo da Empresa do arquivo inv�lido'));

    case StrToIntDef(Copy(ARetorno[1],2,2),0) of
       1: Cedente.TipoInscricao:= pFisica;
       2: Cedente.TipoInscricao:= pJuridica;
    else
       Cedente.TipoInscricao := pJuridica;
    end;

    if LeCedenteRetorno then
    begin
       try
         Cedente.CNPJCPF := rCNPJCPF;
       except
         // Retorno quando � CPF est� vindo errado por isso ignora erro na atribui��o
       end;

       Cedente.CodigoCedente:= rCodEmpresa;
       Cedente.Nome         := rCedente;
       Cedente.Agencia      := rAgencia;
       Cedente.AgenciaDigito:= '0';
       Cedente.Conta        := rConta;
       Cedente.ContaDigito  := rDigitoConta;
    end;

    ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
  end;

  try
    fpTamanhoMaximoNossoNum  := 17;
    for ContLinha := 1 to ARetorno.Count - 2 do
    begin
       Linha := ARetorno[ContLinha] ;

       if Copy(Linha,1,1)<> '1' then
          Continue;

       Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

       with Titulo do
       begin
          SeuNumero                   := copy(Linha,280,26);
          NumeroDocumento             := copy(Linha,117,10);
          LCodigoOrigem               := StrToIntDef(copy(Linha,327,2),0);
          if LCodigoOrigem in [0,1,6,7,9,13,14] then
          begin
            LCodigoOrigem := StrToIntDef(copy(Linha,109,2),0);
            LTipoOcorrencia := CodOcorrenciaToTipo(LCodigoOrigem);
          end else
            LTipoOcorrencia := CodOcorrenciaToTipoRemessa(LCodigoOrigem);
          
          OcorrenciaOriginal.Tipo     := LTipoOcorrencia;
          
          MotivoLinha := 319;
          for i := 1 to 4 do
          begin
            codInstrucao := IfThen(copy(Linha,MotivoLinha,2) = '  ','00',copy(Linha,MotivoLinha,2));
            MotivoRejeicaoComando.Add(codInstrucao);
            if codInstrucao <> '00' then
               DescricaoMotivoRejeicaoComando.Add(CodComplementoMovimento(codInstrucao));
            MotivoLinha := MotivoLinha + 2;
          end;

          if (StrToIntDef(Copy(Linha,111,6),0) > 0) then
            DataOcorrencia := StringToDateTimeDef( Copy(Linha,111,2)+'/'+
                                                 Copy(Linha,113,2)+'/'+
                                                 Copy(Linha,115,2),0, 'DD/MM/YY' );
          if (StrToIntDef(Copy(Linha,147,6),0) > 0) then
             Vencimento := StringToDateTimeDef( Copy(Linha,147,2)+'/'+
                                                Copy(Linha,149,2)+'/'+
                                                Copy(Linha,151,2),0, 'DD/MM/YY' );

          ValorDocumento       := StrToFloatDef(Copy(Linha,153,13),0)/100;
          ValorAbatimento      := StrToFloatDef(Copy(Linha,228,13),0)/100;
          ValorDesconto        := StrToFloatDef(Copy(Linha,241,13),0)/100;
          ValorMoraJuros       := StrToFloatDef(Copy(Linha,267,13),0)/100;
          ValorRecebido        := StrToFloatDef(Copy(Linha,306,13),0)/100;
          ValorPago            := StrToFloatDef(Copy(Linha,254,13),0)/100;
          NossoNumero          := Copy(Linha,46, fpTamanhoMaximoNossoNum);
          ValorDespesaCobranca := StrToFloatDef(Copy(Linha,182,7),0)/100;

          // informa��es do local de pagamento
          Liquidacao.Banco      := StrToIntDef(Copy(Linha,166,3), -1);
          Liquidacao.Agencia    := Copy(Linha,169,4);
          Liquidacao.Origem     := '';

          if (StrToIntDef(Copy(Linha,176,6),0) > 0) then
             DataCredito:= StringToDateTimeDef( Copy(Linha,176,2)+'/'+
                                                Copy(Linha,178,2)+'/'+
                                                Copy(Linha,180,2),0, 'DD/MM/YY' );
       end;
    end;

  finally
    fpTamanhoMaximoNossoNum:= 10;
  end;

end;

function TACBrBancoUnicredES.CodComplementoMovimento(
  const ACodMotivo: String): String;
begin
  try
    if ACodMotivo = '00' then
      Result := '00 - Sem Complemento a informar'
    else
    if StrToInt(ACodMotivo) > 0 then
    begin
      case StrToIntDef(ACodMotivo,0) of
        // C�digos de Complemento do Movimento
        01 : Result := '01 - C�digo do Banco Inv�lido';
        04 : Result := '04 - C�digo de Movimento n�o permitido para a carteira';
        05 : Result := '05 - C�digo de Movimento Inv�lido';
        06 : Result := '06 - N�mero de Inscri��o do Benefici�rio Inv�lido';
        07 : Result := '07 - Ag�ncia - Conta Inv�lida';
        08 : Result := '08 - Nosso N�mero Inv�lido';
        09 : Result := '09 - Nosso N�mero Duplicado';
        10 : Result := '10 - Carteira inv�lida';
        12 : Result := '12 - Tipo de Documento Inv�lido';
        15 : Result := '15 - Data de Vencimento inferior a 5 dias uteis para remessa gr�fica';
        16 : Result := '16 - Data de Vencimento Inv�lida';
        17 : Result := '17 - Data de Vencimento Anterior � Data de Emiss�o';
        18 : Result := '18 - Vencimento fora do Prazo de Opera��o';
        20 : Result := '20 - Valor do T�tulo Inv�lido';
        24 : Result := '24 - Data de Emiss�o Inv�lida';
        25 : Result := '25 - Data de Emiss�o Posterior � data de Entrega';
        26 : Result := '26 - C�digo de juros inv�lido';
        27 : Result := '27 � Valor de juros inv�lido';
        28 : Result := '28 � C�digo de Desconto inv�lido';
        29 : Result := '29 � Valor de Desconto inv�lido';
        30 : Result := '30 - Altera��o de Dados Rejeitada';
        33 : Result := '33 - Valor de Abatimento Inv�lido';
        34 : Result := '34 - Valor do Abatimento Maior ou Igual ao Valor do t�tulo';
        37 : Result := '37 - C�digo para Protesto Inv�lido; (Protesto via SGR, n�o � CRA)';
        38 : Result := '38 - Prazo para Protesto Inv�lido; (Protesto via SGR, n�o � CRA)';
        39 : Result := '39 - Pedido de Protesto N�o Permitido para o T�tulo';
        40 : Result := '40 - T�tulo com Ordem de Protesto Emitida';
        41 : Result := '41 - Pedido de Cancelamento/Susta��o para T�tulos sem Instru��o de Protesto ou Instru��o de Protesto n�o confirmada pelo cart�rio';
        45 : Result := '45 - Nome do Pagador n�o informado';
        46 : Result := '46 - N�mero de Inscri��o do Pagador Inv�lido';
        47 : Result := '47 - Endere�o do Pagador N�o Informado';
        48 : Result := '48 - CEP Inv�lido';
        52 : Result := '52 - Unidade Federativa Inv�lida';
        57 : Result := '57 � C�digo de Multa inv�lido';
        58 : Result := '58 � Data de Multa inv�lido';
        59 : Result := '59 � Valor / percentual de Multa inv�lido';
        60 : Result := '60 - Movimento para T�tulo n�o Cadastrado';
        63 : Result := '63 - Entrada para T�tulo j� cadastrado';
        79 : Result := '79 � Data de Juros inv�lida';
        80 : Result := '80 � Data de Desconto inv�lida';
        86 : Result := '86 - Seu N�mero Inv�lido';
        //C�digos de Complemento do Movimento, relacionados a Protesto de t�tulo:
        101 : Result := '101 - Data da apresenta��o inferior � data de vencimento';
        102 : Result := '102 - Falta de comprovante da presta��o de servi�o';
        103 : Result := '103 - Nome do sacado incompleto/incorreto';
        104 : Result := '104 - Nome do cedente incompleto/incorreto';
        105 : Result := '105 - Nome do sacador incompleto/incorreto';
        106 : Result := '106 - Endere�o do sacado insuficiente';
        107 : Result := '107 - CNPJ/CPF do sacado inv�lido/incorreto';
        108 : Result := '108 - CNPJ/CPF incompat�vel c/ o nome do sacado/sacador/avalista';
        109 : Result := '109 - CNPJ/CPF do sacado incompat�vel com o tipo de documento';
        110 : Result := '110 - CNPJ/CPF do sacador incompat�vel com a esp�cie';
        111 : Result := '111 - T�tulo aceito sem a assinatura do sacado';
        112 : Result := '112 - T�tulo aceito rasurado ou rasgado';
        113 : Result := '113 - T�tulo aceito � falta t�tulo (ag ced: enviar)';
        114 : Result := '114 - CEP incorreto';
        115 : Result := '115 - Pra�a de pagamento incompat�vel com endere�o';
        116 : Result := '116 - Falta n�mero do t�tulo';
        117 : Result := '117 - T�tulo sem endosso do cedente ou irregular';
        118 : Result := '118 - Falta data de emiss�o do t�tulo';
        119 : Result := '119 - T�tulo aceito: valor por extenso diferente do valor por num�rico';
        120 : Result := '120 - Data de emiss�o posterior ao vencimento';
        121 : Result := '121 - Esp�cie inv�lida para protesto';
        122 : Result := '122 - CEP do sacado incompat�vel com a pra�a de protesto';
        123 : Result := '123 - Falta esp�cie do t�tulo';
        124 : Result := '124 - Saldo maior que o valor do t�tulo';
        125 : Result := '125 - Tipo de endosso inv�lido';
        126 : Result := '126 - Devolvido por ordem judicial';
        127 : Result := '127 - Dados do t�tulo n�o conferem com disquete';
        128 : Result := '128 - Sacado e Sacador/Avalista s�o a mesma pessoa';
        129 : Result := '129 - Corrigir a esp�cie do t�tulo';
        130 : Result := '130 - Aguardar um dia �til ap�s o vencimento para protestar';
        131 : Result := '131 - Data do vencimento rasurada';
        132 : Result := '132 - Vencimento � extenso n�o confere com n�mero';
        133 : Result := '133 - Falta data de vencimento no t�tulo';
        134 : Result := '134 - DM/DMI sem comprovante autenticado ou declara��o';
        135 : Result := '135 - Comprovante ileg�vel para confer�ncia e microfilmagem';
        136 : Result := '136 - Nome solicitado n�o confere com emitente ou sacado';
        137 : Result := '137 - Confirmar se s�o 2 emitentes. Se sim, indicar os dados dos 2';
        138 : Result := '138 - Endere�o do sacado igual ao do sacador ou do portador';
        139 : Result := '139 - Endere�o do apresentante incompleto ou n�o informado';
        140 : Result := '140 - Rua / N�mero inexistente no endere�o';
        141 : Result := '141 - Informar a qualidade do endosso (M ou T)';
        142 : Result := '142 - Falta endosso do favorecido para o apresentante';
        143 : Result := '143 - Data da emiss�o rasurada';
        144 : Result := '144 - Protesto de cheque proibido � motivo 20/25/28/30 ou 35';
        145 : Result := '145 - Falta assinatura do emitente no cheque';
        146 : Result := '146 - Endere�o do emitente no cheque igual ao do banco sacado';
        147 : Result := '147 - Falta o motivo da devolu��o no cheque ou motivo ileg�vel';
        148 : Result := '148 - Falta assinatura do sacador no t�tulo';
        149 : Result := '149 - Nome do apresentante n�o informado/incompleto/incorreto';
        150 : Result := '150 - Erro de preenchimento do t�tulo';
        151 : Result := '151 - T�tulo com direito de regresso vencido';
        152 : Result := '152 - T�tulo apresentado em duplicidade';
        153 : Result := '153 - T�tulo j� protestado';
        154 : Result := '154 - Letra de C�mbio vencida � falta aceite do sacado';
        155 : Result := '155 - T�tulo � falta tradu��o por tradutor p�blico';
        156 : Result := '156 - Falta declara��o de saldo assinada no t�tulo';
        157 : Result := '157 - Contrato de C�mbio � falta conta gr�fica';
        158 : Result := '158 - Aus�ncia do Documento F�sico';
        159 : Result := '159 - Sacado Falecido';
        160 : Result := '160 - Sacado Apresentou Quita��o do T�tulo';
        161 : Result := '161 - T�tulo de outra jurisdi��o territorial';
        162 : Result := '162 - T�tulo com emiss�o anterior � concordata do sacado';
        163 : Result := '163 - Sacado consta na lista de fal�ncia';
        164 : Result := '164 - Apresentante n�o aceita publica��o de edital';
        165 : Result := '165 - Dados do sacador em branco ou inv�lido';
        166 : Result := '166 - T�tulo sem autoriza��o para protesto por edital';
        167 : Result := '167 - Valor divergente entre t�tulo e comprovante';
        168 : Result := '168 - Condom�nio n�o pode ser protestado para fins falimentares';
        169 : Result := '169 - Vedada a intima��o por edital para protesto falimentar';
        170 : Result := '170 - Dados do Cedente em branco ou inv�lido';
      end;
    end;
  except
    if ACodMotivo = 'A5' then
      Result := 'A5 - T�tulo Liquidado'
    else if ACodMotivo = 'A8' then
      Result := 'A8 - Valor do Abatimento Inv�lido para Cancelamento'
    else if ACodMotivo = 'C0' then
      Result := 'C0 � Sistema Intermitente � Entre em contato com sua Cooperativa'
    else if ACodMotivo = 'C1' then
      Result := 'C1 - Situa��o do t�tulo Aberto'
    else if ACodMotivo = 'C3' then
      Result := 'C3 - Status do Border� Inv�lido'
    else if ACodMotivo = 'C4' then
      Result := 'C4 - Nome do Benefici�rio Inv�lido'
    else if ACodMotivo = 'C5' then
      Result := 'C5 - Documento Inv�lido'
    else if ACodMotivo = 'C6' then
      Result := 'C6 - Instru��o n�o Atualiza Cadastro do T�tulo'
    else if ACodMotivo = 'C7' then
      Result := 'C7 � T�tulo n�o registrado na CIP'
    else if ACodMotivo = 'C8' then
      Result := 'C8 � Situa��o do Border� inv�lida'
    else if ACodMotivo = 'C9' then
      Result := 'C9 � T�tulo inv�lido conforme situa��o CIP'
    else if ACodMotivo = 'C10' then
      Result := 'C10 - Protesto: T�tulo precisa estar em Aberto'
    else if ACodMotivo = 'D0' then
      Result := 'D0 � Benefici�rio n�o autorizado a operar com produto Desconto'
    else if ACodMotivo = 'D1' then
      Result := 'D1 � Altera��o de status de desconto n�o permitido para t�tulo'
    else if ACodMotivo = 'D2' then
      Result := 'D2 � Opera��o de desconto n�o permitida para t�tulo vencido'
    else if ACodMotivo = 'D3' then
      Result := 'D3 - Altera��o de status de desconto n�o permitido para situa��o do t�tulo'
    else if ACodMotivo = 'E0' then
      Result := 'E0 - CEP indicado para o endere�o do Pagador n�o compat�vel com os Correios'
    else if ACodMotivo = 'E1' then
      Result := 'E1 - Logradouro para o endere�o do Pagador n�o compat�vel com o CEP indicado'
    else if ACodMotivo = 'E2' then
      Result := 'E2 � Tipo de logradouro para o endere�o do Pagador n�o compat�vel o CEP indicado'
    else if ACodMotivo = 'E3' then
      Result := 'E3 � Bairro para o endere�o do Pagador n�o compat�vel com o CEP indicado'
    else if ACodMotivo = 'E4' then
      Result := 'E4 � Cidade para o endere�o do Pagador n�o compat�vel com o CEP indicado'
    else if ACodMotivo = 'E5' then
      Result := 'E5 � UF para o endere�o do Pagador n�o compat�vel com o CEP indicado'
    else if ACodMotivo = 'E6' then
      Result := 'E6 � Dados do segmento/registro opcional de endere�o do pagador, incompletos no arquivo remessa'
    else if ACodMotivo = 'E7' then
      Result := 'E7 � Benefici�rio n�o autorizado a enviar boleto por e-mail'
    else if ACodMotivo = 'E8' then
      Result := 'E8 � Indicativo para pagador receber boleto por e-mail sinalizado, por�m sem o endere�o do e-mail'
    else if ACodMotivo = 'E9' then
      Result := 'E9 � Benefici�rio n�o autorizado a enviar t�tulos para protesto'
    else if ACodMotivo = 'E10' then
      Result := 'E10 � Instru��o "09 � Protestar", usada erroneamente para t�tulo a vencer ou ainda dentro do per�odo de Car�ncia de "1 dia" do vencimento, referente a liquida��o por Compensa��o'
    else if ACodMotivo = 'E11' then
      Result := 'E11 - Instru��o "26 � Protesto Autom�tico", usada erroneamente para t�tulo vencido'
    else if ACodMotivo = 'E12' then
      Result := 'E12 - Cancelamento de protesto autom�tico n�o permitido, t�tulo n�o possui configura��o de protesto autom�tico'
    else if ACodMotivo = 'E13' then
      Result := 'E13 - Configura��o de N�mero de Dias para Protesto, foi informado para cancelamento de protesto autom�tico'
    else if ACodMotivo = 'E14' then
      Result := 'E14 - Configura��o de N�mero de Dias para Protesto, n�o foi informado para protesto autom�tico'
    else if ACodMotivo = 'E15' then
      Result := 'E15 - Cancelamento de protesto autom�tico n�o permitido, para protesto j� enviado a cart�rio'
    else if ACodMotivo = 'E16' then
      Result := 'E16 - C�digo para Protesto inv�lido'
    else if ACodMotivo = 'E17' then
      Result := 'E17 � Instru��o n�o permitida para t�tulo descontado'
    else if ACodMotivo = 'E18' then
      Result := 'E18 - Configura��o de N�mero de Dias para Protesto, foi informado para op��o de n�o protestar'
    else if ACodMotivo = 'E19' then
      Result := 'E19 � Baixa por decurso de prazo foi encaminhada em duplicidade pela CIP'
    else if ACodMotivo = 'E20' then
      Result := 'E20 � T�tulos com m�ltiplos pagamentos devem ter permiss�o para receber qualquer valor de pagamento'
    else if ACodMotivo = 'E21' then
      Result := 'E21 � Instru��o n�o permitida para t�tulos com m�ltiplos pagamentos'
    else if ACodMotivo = 'E22' then
      Result := 'E22 � Funcionalidade para t�tulos com m�ltiplos pagamentos n�o est� habilitada'
    else if ACodMotivo = 'E23' then
      Result := 'E23 � Quantidade de pagamentos parciais, deve ser 99'
    else if ACodMotivo = 'E24' then
      Result := 'E24 � Quantidade de pagamentos parciais n�o deve ser informado'
    else if ACodMotivo = 'E25' then
      Result := 'E25 - Modelo de calculo invalido para titulo com pagamentos parciais';
  end;
end;

function TACBrBancoUnicredES.CodDescontoToStr(
  const pCodigoDesconto: TACBrCodigoDesconto): String;
begin
  case pCodigoDesconto of
    cdValorFixo : Result := '1';
  else
    Result := '0';
  end;
end;

function TACBrBancoUnicredES.CodigoLiquidacaoDescricao(
  CodLiquidacao: Integer): String;
begin
  case CodLiquidacao of
    000 : result := '000 Sem informa��o relevante';
    161 : result := '161 Internet Banking';
    162 : result := '162 ATM';
    163 : result := '163 Caixa';
    164 : result := '164 Retaguarda';
    165 : result := '165 Monitor de TED';
    166 : result := '166 Compe';
    167 : result := '167 DDA';
    168 : result := '168 Banco Correspondente';
    190 : result := '190 Lot�rica';
    234 : result := '234 Agendamento';
    268 : result := '268 Mobile';
    308 : result := '308 Cart�rio';
    333 : result := '333 Pix';
  end;

end;

function TACBrBancoUnicredES.CodJurosToStr(const pCodigoJuros: TACBrCodigoJuros;
  ValorMoraJuros: Currency): String;
begin
  if ValorMoraJuros = 0 then
    result := '5'
  else
  begin
    case pCodigoJuros of
      cjValorDia: result := '1';
      cjTaxaMensal: result := '2';
      cjValorMensal: result := '3';
      cjTaxaDiaria: result := '4';
    else
      result := '5';
    end;
  end;
end;

procedure TACBrBancoUnicredES.DefineCanalLiquidacaoRetorno240(
  const ALinha: String; out ATitulo: TACBrTitulo);
begin
  ATitulo.CodigoLiquidacao := copy(ALinha, 108,3);
  Atitulo.CodigoLiquidacaoDescricao := CodigoLiquidacaoDescricao(StrToIntDef(ATitulo.CodigoLiquidacao,0));
  ATitulo.ValorOutrasDespesas := 0;
end;

function TACBrBancoUnicredES.DefineCaucionada(
  const ACBrTitulo: TACBrTitulo): String;
begin
   if (fpNumero = 136) and (fpLayoutVersaoArquivo = 085) then
   begin
     if (ACBrTitulo.EspecieDoc = Trim('31')) or (ACBrTitulo.EspecieDoc = trim('CC')) then
       Result := 'N'
     else
       case ACBrTitulo.CaracTitulo of
         tcCaucionada: result := 'S';
       else
         result := 'N';
       end;
   end
   else
     result := Space(1);
end;

function TACBrBancoUnicredES.DefineCodigoProtesto(
  const ACBrTitulo: TACBrTitulo): String;
begin
  with ACBrTitulo do
  begin
    case CodigoNegativacao of
        cnNenhum           :  Result := '0';
        cnProtestarCorrido :  Result := '1';
        cnProtestarUteis   :  Result := '2';
        cnNaoProtestar     :  Result := '3';
        cnNegativar        :  Result := '4'; // negativar dias corridos
        cnNegativarUteis   :  Result := '5';
        cnNaoNegativar     :  Result := '6';
       else
        Result := '0';
      end;
  end;
end;

function TACBrBancoUnicredES.DefineNumeroDocumentoModulo(
  const ACBrTitulo: TACBrTitulo): String;
begin
  Result:= ACBrTitulo.NossoNumero;
end;

function TACBrBancoUnicredES.DefineNumeroDocumentoRetorno(
  const ALinha: String): String;
begin
  if ACBrBanco.ACBrBoleto.LayoutRemessa = c240 then
    Result:= copy(ALinha, 59, 15)
  else
    Result:= inherited DefineNumeroDocumentoRetorno(ALinha);
end;

function TACBrBancoUnicredES.DefinePosicaoNossoNumeroRetorno: Integer;
begin
  if ACBrBanco.ACBrBoleto.LayoutRemessa = c240 then
    Result := 39
  else
    Result := 71;
end;

function TACBrBancoUnicredES.DefinerCnpjCPFRetorno240(
  const ALinha: String): String;
begin
  case StrToIntDef(Copy(ALinha,18,1),0) of
     1: result := Copy(ALinha,22,11);
     2: result := Copy(ALinha,19,14);
  else
    result := Copy(ALinha,19,14);
  end;

end;

procedure TACBrBancoUnicredES.DefineRejeicaoComplementoRetorno(const ALinha: String; out ATitulo: TACBrTitulo);
var LCodInstrucao : String;
begin
  LCodInstrucao := trim(copy(ALinha,214,8));
  ATitulo.MotivoRejeicaoComando.Add(LCodInstrucao);
  ATitulo.DescricaoMotivoRejeicaoComando.Add(CodComplementoMovimento(LCodInstrucao));
end;

function TACBrBancoUnicredES.DefineSeuNumeroRetorno(
  const ALinha: String): String;
begin
  if ACBrBanco.ACBrBoleto.LayoutRemessa = c240 then
    Result:= copy(ALinha, 59, 15)
  else
    Result:= inherited DefineSeuNumeroRetorno(ALinha);
end;

function TACBrBancoUnicredES.CodMotivoRejeicaoToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): String;
begin
  case CodMotivo of
    00 : Result := '00 � Sem Tipo de Instru��o Origem a informar';
    01 : Result := '01 - Remessa';
    02 : Result := '02 - Pedido de Baixa';
    04 : Result := '04 - Concess�o de Abatimento';
    05 : Result := '05 - Cancelamento de Abatimento';
    06 : Result := '06 - Altera��o de vencimento';
    08 : Result := '08 - Altera��o de Seu N�mero';
    09 : Result := '09 � Protestar';
    10 : Result := '10 - Baixa por Decurso de Prazo � Solicita��o CIP';
    11 : Result := '11 - Sustar Protesto e Manter em Carteira';
    31 : Result := '31 - Altera��o de outros dados (Altera��o de dados do pagador)';
    25 : Result := '25 - Sustar Protesto e Baixar T�tulo';
    26 : Result := '26 � Protesto autom�tico';
    40 : Result := '40 - Altera��o de Carteira';
    else
      Result := 'XX � Evento N�o Mapeado';
  end;
end;

function TACBrBancoUnicredES.CodMultaToStr(const pCodigoMulta: TACBrCodigoMulta): String;
begin
  case pCodigoMulta of
    cmValorFixo : result := '1';
    cmPercentual : result := '2';
  else
    result := '3';
  end;
end;

function TACBrBancoUnicredES.GerarRegistroTransacao240(
  ACBrTitulo: TACBrTitulo): String;
var
  ATipoOcorrencia : String;
  ADataDesconto: String;
  sNossoNumero, sDigitoNossoNumero, ATipoAceite : String;
  ACodJuros, ACodDesc, ACodProtesto : String;
  ACodMulta, AValorMulta : String;
  ADias, LCaucionada : String;
  ListTransacao: TStringList;

begin
  with ACBrTitulo do
  begin
    ValidaNossoNumeroResponsavel(sNossoNumero, sDigitoNossoNumero, ACBrTitulo);

    {Pegando C�digo da Ocorrencia}
    ATipoOcorrencia:= TipoOcorrenciaToCodRemessa(OcorrenciaOriginal.Tipo);

    {Aceite do Titulo }
    ATipoAceite := DefineAceite(ACBrTitulo);

    {C�digo Mora}
    ACodJuros := DefineCodigoMoraJuros(ACBrTitulo);

    {C�digo Desconto}
    ACodDesc := DefineCodigoDesconto(ACBrTitulo);

    {Data Desconto}
    ADataDesconto := DefineDataDesconto(ACBrTitulo);

    {C�digo para Protesto}
    ACodProtesto := DefineCodigoProtesto(ACBrTitulo);

    {Define Codigo Multa}
    ACodMulta := DefineCodigoMulta(ACBrTitulo);

    {Define caucionada}
    LCaucionada := DefineCaucionada(ACBrTitulo);

    {Calculo de Multa}
    if PercentualMulta > 0 then
    begin
      case StrToIntDef(ACodMulta,3) of
        1: AValorMulta := PadLeft(FloatToStr(TruncTo((ValorDocumento*( 1 + PercentualMulta/100)-ValorDocumento),2)*100), 15, '0');
        2: AValorMulta := IntToStrZero(Round(PercentualMulta * 100), 15);
        else
          AValorMulta  := PadRight('', 15, '0');
      end;
    end;

    if (ACBrBoleto.Cedente.UF = 'SC') then
      NumeroDocumento := PadLeft(Copy(NumeroDocumento,0,10), 15, ' ');

    { Dias para protesto / Negativa��o }
    ADias := '00';
    if Length(ACodProtesto) > 0 then
    begin
      case StrToInt(ACodProtesto) of
        1,2 : begin
          ADias := PadLeft(IntToStr(DiasDeProtesto), 2, '0');
          if DiasDeProtesto <= 0 then
             Raise Exception.Create(ACBrStr('Informar a propriedade DiasDeProtesto !'));
        end;
        4,5 : begin
          ADias := PadLeft(IntToStr(DiasDeNegativacao), 2, '0');
          if DiasDeNegativacao <= 0 then
             Raise Exception.Create(ACBrStr('Informar a propriedade DiasDeNegativacao !'));
        end;

      end;

    end;

    ListTransacao:= TStringList.Create;

    try

      //SEGMENTO P
      ListTransacao.Add( IntToStrZero(ACBrBanco.Numero, 3)                             + // 1 a 3 - C�digo do banco
               '0001'                                                                  + // 4 a 7 - Lote de servi�o
               '3'                                                                     + // 8 - Tipo do registro: Registro detalhe
               IntToStrZero((3 * ACBrBoleto.ListadeBoletos.IndexOf(ACBrTitulo)) + 1 , 5) + // 9 a 13 - N�mero seq�encial do registro no lote - Cada t�tulo tem 2 registros (P e Q)
               'P'                                                                     + // 14 - C�digo do segmento do registro detalhe
               Space(1)                                                                + // 15 - Uso exclusivo FEBRABAN/CNAB: Branco
               aTipoOcorrencia                                                         + // 16 a 17 - C�digo de movimento
               PadLeft(ACBrBoleto.Cedente.Agencia, 5, '0')                             + // 18 a 22 - Ag�ncia mantenedora da conta
               PadRight(ACBrBoleto.Cedente.AgenciaDigito, 1 , ' ')                     + // 23 -D�gito verificador da ag�ncia
               PadLeft(ACBrBoleto.Cedente.Conta, 12, '0')                              + // 24 a 35 - N�mero da conta corrente
               PadLeft(ACBrBoleto.Cedente.ContaDigito, 1, '0')                         + // 36 - D�gito verificador da conta
               '0'                                                                     + // 37 - Zeros
               PadRight(sNossoNumero + sDigitoNossoNumero, 11, '0')                    + // 38 a 48 - Identifica��o do T�tulo no Banco (Nosso Numero)
               Space(8)                                                                + // 49 a 56 - Zeros
               PadLeft(Carteira, 2, '0')                                               + // 57 a 58 - Codigo carteira  21=Cobran�a Com Registro;
               Space(4)                                                                + // 59 a 62 - Brancos

               PadRight(NumeroDocumento, 15, ' ')                                      + // 63 a 77 - N� do Documento
               FormatDateTime('ddmmyyyy', Vencimento)                                  + // 78 a 85 - Data de vencimento do t�tulo
               IntToStrZero( round( ValorDocumento * 100), 15)                         + // 86 a 100 - Valor nominal do t�tulo
               Space(6)                                                                + // 101 a 106 - Ag�ncia cobradora + dv
               'N'                                                                     + // 107 - T�tulo Participa de opera��o de desconto
               LCaucionada                                                             + // 108 - Brancos
               ATipoAceite                                                             + // 109 - Identifica��o de t�tulo Aceito / N�o aceito
               FormatDateTime('ddmmyyyy', DataDocumento)                               + // 110 a 117 - Data da emiss�o do documento
               aCodJuros                                                               + // 118 - C�digo de juros de mora: Valor por dia   ('1' = Valor por Dia  '2' = Taxa Mensal  '4' = Taxa Diaria '5' = Isento)
               Space(8)                                                                + // 119 a 126 - Brancos
               IfThen(ACodJuros = '5', IntToStrZero(0, 15),
                 IfThen (ValorMoraJuros > 0,
                      IntToStrZero(round(ValorMoraJuros * 100), 15),
                      PadRight('', 15, '0')))                                           + // 127 a 141 - Juros de Mora por Dia/Taxa
               aCodDesc                                                                + // 142 - C�digo de desconto 1:  0 - Isento   1 - Valor fixo at� a data informada
               IfThen(ValorDesconto > 0,
                      IfThen(DataDesconto > 0, ADataDesconto,'00000000'), '00000000')  + // 143 a 150 - Data do desconto 1
               IfThen(ValorDesconto > 0, IntToStrZero( round(ValorDesconto * 100), 15),
                      PadRight('', 15, '0'))                                           + // 151 a 165 - Valor do desconto 1 a ser concedido
               Space(15)                                                               + // 166 a 180 - Brancos
               IntToStrZero( round(ValorAbatimento * 100), 15)                         + // 181 a 195 - Valor do abatimento
               PadRight(SeuNumero, 25, ' ')                                            + // 196 a 220 - Identifica��o do t�tulo na empresa
               aCodProtesto                                                            + // 221 - C�digo para protesto.  '1� = ProtestarDias Corridos '2� = ProtestarDias �teis '3� = N�oProtestar
               ADias                                                                   + // 222 a 223 - Prazo para negativar (em dias corridos)
               Space(4)                                                                + // 224 a 227 - Brancos
               '09'                                                                    + // 228 a 229 - C�digo da moeda: 09-Real
               StringOfChar('0', 10)                                                   + // 230 a 239 - Numero do contrato da op. de credito
               Space(1)                                                              );  // 240 - Uso exclusivo FEBRABAN/CNAB

      //SEGMENTO Q
      ListTransacao.Add(IntToStrZero(ACBrBanco.Numero, 3)                               + // 1 a 3 - C�digo do banco
               '0001'                                                                   + // 4 a 7 - N�mero do lote
               '3'                                                                      + // 8 - Tipo do registro: Registro detalhe
               IntToStrZero((3 * ACBrBoleto.ListadeBoletos.IndexOf(ACBrTitulo)) + 2 ,5) + // 9 a 13 - N�mero seq�encial do registro no lote - Cada t�tulo tem 2 registros (P e Q)
               'Q'                                                                      + // 14 - C�digo do segmento do registro detalhe
               Space(1)                                                                 + // 15 - Uso exclusivo FEBRABAN/CNAB: Branco
               ATipoOcorrencia                                                          + // 16 a 17 - Codigo de movimento remessa
               IfThen(Sacado.Pessoa = pJuridica,'2','1')                                + // 18 - Tipo inscricao
               PadLeft(OnlyNumber(Sacado.CNPJCPF), 15, '0')                             + // 19 a 33 - N�mero de Inscri��o
               PadRight(Sacado.NomeSacado, 40, ' ')                                     + // 34 a 73 - Nome sacado
               PadRight(Sacado.Logradouro + ' ' + Sacado.Numero + ' '+
                        Sacado.Complemento , 40, ' ')                                   + // 74 a 113 - Endereco sacado
               PadRight(Sacado.Bairro, 15, ' ')                                         + // 114 a 128 - Bairro sacado
               PadLeft(OnlyNumber(Sacado.CEP), 8, '0')                                  + // 129 a 136 - Cep sacado
               PadRight(Sacado.Cidade, 15, ' ')                                         + // 137 a 151 - Cidade sacado
               PadRight(Sacado.UF, 2, ' ')                                              + // 152 a 153 - Unidade da Federa��o
               IfThen(Sacado.SacadoAvalista.Pessoa = pJuridica, '2',
                      IfThen(Sacado.SacadoAvalista.CNPJCPF <> '','1', '0'))             + // 154 - Tipo de inscri��o: Sac./ Aval.
               PadLeft(OnlyNumber(Sacado.SacadoAvalista.CNPJCPF), 15, '0')              + // 155 a 169 - N�mero de inscri��o Sac./ Aval.
               PadRight(Sacado.SacadoAvalista.NomeAvalista, 40, ' ')                    + // 170 a 209 - Nome do sacador/avalista
               Space(23)                                                                + // 210 a 232 - Brancos
               Space(8)                                                              );   // 233 a 240 - Uso exclusivo FEBRABAN/CNAB

      //SEGMENTO R
      if (PercentualMulta > 0) then
      begin
        ListTransacao.Add(IntToStrZero(ACBrBanco.Numero, 3)                              + // 1 a 3 - C�digo do banco
                 '0001'                                                                  + // 4 a 7 - N�mero do lote
                 '3'                                                                     + // 8 a 8 - Tipo do registro: Registro detalhe
                 IntToStrZero((3 * ACBrBoleto.ListadeBoletos.IndexOf(ACBrTitulo))+ 3 ,5) + // 9 a 13 - N�mero seq�encial do registro no lote - Cada t�tulo tem 3 registros (P, Q e R)
                 'R'                                                                     + // 14 a 14 - C�digo do segmento do registro detalhe
                 Space(1)                                                                + // 15 a 15 - Uso exclusivo FEBRABAN/CNAB: Branco
                 aTipoOcorrencia                                                         + // 16 a 17 - Tipo Ocorrencia
                 Space(48)                                                               + // 18 a 65 - Brancos
                 aCodMulta                                                               + // 66 a 66 - Codigo Multa (1-Valor fixo / 2-Taxa  / 3-Isento)
                 Space(8)                                                                + // 67 a 74 - Brancos
                 aValorMulta                                                             + // 75 a 89 - valor/Percentual de multa dependando do cod da multa. Informar zeros se n�o cobrar
                 Space(10)                                                               + // 90 a 99 - Informacao ao sacado
                 Space(40)                                                               + // 100 a 139 - Mensagem 1
                 Space(40)                                                               + // 140 a 179 - Mensagem 2
                 Space(20)                                                               + // 180 a 199 - Uso exclusivo FEBRABAN/CNAB: Branco
                 Space(32)                                                               + // 200 - 231 - Brancos
                 Space(9)                                                             );   // 232 a 240 - Uso exclusivo FEBRABAN/CNAB: Branco
      end;
      Result := RemoverQuebraLinhaFinal(ListTransacao.Text);
    finally
       ListTransacao.Free;
    end;
  end;
end;

function TACBrBancoUnicredES.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
  CodOcorrencia: Integer;
begin
  Result        := EmptyStr;
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCodRemessa(TipoOcorrencia),0);
  case CodOcorrencia of
    02 : Result:= '02-Pedido de Baixa';
    04 : Result:= '04-Concess�o de Abatimento';
    05 : Result:= '05-Cancelamento de Abatimento concedido';
    06 : Result:= '06-Altera��o de vencimento';
    09 : Result:= '09-Pedido de protesto';
    11 : Result:= '11-Sustar protesto e manter em carteira';
    22 : Result:= '22-Altera��o do seu n�mero';
    23 : Result:= '23-Altera��o de dados do pagador';
    25 : Result:= '25-Sustar protesto e baixar t�tulo';
    26 : Result:= '26-Protesto autom�tico';
    40 : Result:= '40-Altera��o de status desconto';
  else
    CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia),0);
    case CodOcorrencia of
      01: Result := '01-T�tulo Protestado Pago em Cart�rio';
      02: Result := '02-Instru��o Confirmada';
      03: Result := '03-Instru��o Rejeitada';
      04: Result := '04-T�tulo protestado sustado judicialmente';
      06: Result := '06-Liquida��o Normal';
      07: Result := '07-T�tulo Liquidado em Cart�rio Com Cheque do Pr�prio Devedor';
      08: Result := '08-T�tulo Protestado Sustado Judicialmente em Definitivo';
      09: Result := '09-Liquida��o de T�tulo Descontado';
      10: Result := '10-Protesto Solicitado';
      11: Result := '11-Protesto em Cart�rio';
      12: Result := '12-Susta��o Solicitada';
      13: Result := '13-T�tulo Utilizado Como Garantia em Opera��o de Desconto';
      14: Result := '14-T�tulo Com Desist�ncia de Garantia em Opera��o de Desconto';
    end;
  end;



  Result := ACBrSTr(Result);
end;

function TACBrBancoUnicredES.CodOcorrenciaToTipo(const CodOcorrencia: Integer ) : TACBrTipoOcorrencia;
begin

  case CodOcorrencia of
    01: Result := toRetornoLiquidadoEmCartorio;
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoInstrucaoRejeitada;
    04: Result := toRetornoSustadoJudicial;
    06: Result := toRetornoLiquidado;
    07: Result := toRetornoLiquidadoEmCartorioEmCondicionalComChequeDoDevedor;
    08: Result := toRetornoProtestoSustadoDefinitivo;
    09: Result := toRetornoLiquidadoTituloDescontado;
    10: Result := toRetornoProtestado;
    11: Result := toRetornoProtestadoEmCartorio;
    12: Result := toRetornoSustacaoSolicitada;
    13: Result := toRetornoTituloDescontado;
    14: Result := toRetornoTituloDescontavel;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoUnicredES.TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  Result := '';

  case TipoOcorrencia of
    toRetornoLiquidadoEmCartorio                                : Result := '01';
    toRetornoRegistroConfirmado                                 : Result := '02';
    toRetornoInstrucaoRejeitada                                 : Result := '03';
    toRetornoSustadoJudicial                                    : Result := '04';
    toRetornoLiquidado                                          : Result := '06';
    toRetornoLiquidadoEmCartorioEmCondicionalComChequeDoDevedor : Result := '07';
    toRetornoProtestoSustadoDefinitivo                          : Result := '08';
    toRetornoLiquidadoTituloDescontado                          : Result := '09';
    toRetornoProtestado                                         : Result := '10';
    toRetornoProtestadoEmCartorio                               : Result := '11';
    toRetornoSustacaoSolicitada                                 : Result := '12';
    toRetornoTituloDescontado                                   : Result := '13';
    toRetornoTituloDescontavel                                  : Result := '14';
  else
    Result := '02';
  end;
end;

function TACBrBancoUnicredES.CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Altera��o de vencimento}
    09 : Result:= toRemessaProtestar;                       {Pedido de protesto}
    11 : Result:= toRemessaSustarProtestoManterCarteira;    {Sustar protesto e manter em carteira}
    22 : Result:= toRemessaAlterarSeuNumero;                {Altera��o do seu n�mero}
    23 : Result:= toRemessaAlterarDadosPagador;             {Altera��o de dados do pagador}
    25 : Result:= toRemessaSustarProtestoBaixarTitulo;      {Sustar protesto e baixar t�tulo}
    26 : Result:= toRemessaProtestoAutomatico;              {Protesto autom�tico}
    40 : Result:= toRemessaAlterarStatusDesconto;           {Altera��o de status desconto}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;
end;

function TACBrBancoUnicredES.TipoOcorrenciaToCodRemessa(const ATipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case ATipoOcorrencia of
            toRemessaBaixar                         : Result := '02'; // Pedido de Baixa
            toRemessaConcederAbatimento             : Result := '04'; // Concess�o de Abatimento
            toRemessaCancelarAbatimento             : Result := '05'; // Cancelamento de Abatimento
            toRemessaAlterarVencimento              : Result := '06'; // Altera��o de Vencimento
            toRemessaProtestar                      : Result := '09'; // Protestar
            toRemessaCancelarInstrucaoProtesto      : Result := '11'; // Sustar Protesto e Manter em Carteira
            toRemessaAlterarControleParticipante    : Result := '22'; // Altera��on�mero controle do Participante -de Seu n�mero
            toRemessaAlterarDadosPagador            : Result := '23'; // Alterar dados do Pagador
            toRemessaCancelarInstrucaoProtestoBaixa : Result := '25'; // SustarProtesto e Baixar T�tulo
    else
      Result := '01';                                                 // Entrada de T�tulos
    end;
  end
  else
  begin
    case ATipoOcorrencia of
         toRemessaBaixar                         : Result := '02'; {Pedido de Baixa}
         toRemessaConcederAbatimento             : Result := '04'; {Concess�o de Abatimento}
         toRemessaCancelarAbatimento             : Result := '05'; {Cancelamento de Abatimento concedido}
         toRemessaAlterarVencimento              : Result := '06'; {Altera��o de vencimento}
         toRemessaProtestar                      : Result := '09'; {Pedido de protesto}
         toRemessaSustarProtestoManterCarteira   : Result := '11'; {Sustar protesto e manter em carteira}
         toRemessaAlterarSeuNumero               : Result := '22'; {Altera��o do seu n�mero}
         toRemessaAlterarDadosPagador            : Result := '23'; {Altera��o de dados do pagador}
         toRemessaSustarProtestoBaixarTitulo     : Result := '25'; {Sustar protesto e baixar t�tulo}
         toRemessaProtestoAutomatico             : Result := '26'; {Protesto autom�tico}
         toRemessaAlterarStatusDesconto          : Result := '40'; {Altera��o de status desconto}
       else
         Result := '01';                                           {Remessa}
    end;
  end;
end;



function TACBrBancoUnicredES.GerarRegistroHeader240 ( NumeroRemessa: Integer ) : String;
var
  ListHeader: TStringList;
  ACodBeneficiario: String;
  sNomeBanco : String;
  LayoutLote : Integer;
begin
  Result := '';
  //ErroAbstract('GerarRemessa240');

  with ACBrBanco.ACBrBoleto.Cedente do
  begin
    if (Length( ContaDigito)  > 1) and (trim(DigitoVerificadorAgenciaConta) = '')  then
      DigitoVerificadorAgenciaConta:=  copy(ContaDigito,length(ContaDigito ),1) ;
  end;
  ACodBeneficiario:= trim(DefineCodBeneficiarioHeader);
  LayoutLote := fpLayoutVersaoLote;
  if (fpLayoutVersaoLote = 944) then
  begin
    sNomeBanco := 'UNICRED';
    LayoutLote := 44;
  end else
    sNomeBanco := fpNome;

  ListHeader:= TStringList.Create;
  try
    with ACBrBanco.ACBrBoleto.Cedente do
    begin

      { GERAR REGISTRO-HEADER DO ARQUIVO }
      ListHeader.Add(IntToStrZero(fpNumero, 3)         + //1 a 3 - C�digo do banco
      '0000'                                           + //4 a 7 - Lote de servi�o
      '0'                                              + //8 - Tipo de registro - Registro header de arquivo
      PadRight('', 9, ' ')                             + //9 a 17 Uso exclusivo FEBRABAN/CNAB
      DefineTipoInscricao                              + //18 - Tipo de inscri��o do cedente
      PadLeft(OnlyNumber(CNPJCPF), 14, '0')            + //19 a 32 -N�mero de inscri��o do cedente
      PadRight('', 20, ' ')                            + //33 a 52 - C�digo do conv�nio no banco-Alfa
      PadLeft(OnlyNumber(Agencia), 5, '0')             + //53 a 57 - C�digo da ag�ncia do cedente-Numero
      DefineCampoDigitoAgencia                         + //58 - D�gito da ag�ncia do cedente -Alfa
      Padleft(ACodBeneficiario,14,'0')                 + //59 a 72 - C�digo do Benefici�rio
      PadRight(nome, 30, ' ')                          + //73 102 - Nome da Empresa-Alfa
      PadRight(sNomeBanco, 30, ' ')                        + //103 a 132 -Nome do banco-Alfa
      PadRight('', 10, ' ')                            + //133 a 142 - Uso exclusivo FEBRABAN/CNAB  -Alfa
      '1'                                              + //143 - C�digo de Remessa (1) / Retorno (2)
      FormatDateTime('ddmmyyyy', Now)                  + //144 a 151 - Data do de gera��o do arquivo
      FormatDateTime('hhmmss', Now)                    + //152 a 157 - Hora de gera��o do arquivo
      PadLeft(IntToStr(NumeroRemessa), 6, '0')         + //158 a 163 - N�mero seq�encial do arquivo
      PadLeft(IntToStr(fpLayoutVersaoArquivo), 3, '0') + //164 a 166 - N�mero da vers�o do layout do arquivo
      PadLeft(fpDensidadeGravacao, 5, '0')             + //167 a 171 - Densidade de grava��o do arquivo (BPI)  fixo 06250
      '000'                                            + // 172 a 174 - Filler - Zeros
      'REMESSA-PRODUCAO '                              + // 175 a 191 - Uso reservado do Banco
      Space(49)                                        ); // 192 a 240 - Uso exclusivo FEBRABAN/CNAB - Brancos

      { GERAR REGISTRO HEADER DO LOTE }

      ListHeader.Add(IntToStrZero(fpNumero, 3)   + //1 a 3 - C�digo do banco
      '0001'                                     + //4 a 7 - Lote de servi�o
      '1'                                        + //8 - Tipo de registro - Registro header de arquivo
      'R'                                        + //9 - Tipo de opera��o 'R'
      '01'                                       + //10 a 11 - Tipo de servi�o: 01 (Cobran�a)
      '  '                                       + //12 a 13 - Uso Exclusivo FEBRABAN/CNAB /Alfa
      PadLeft(IntToStr(LayoutLote), 3, '0')      + //14 a 16 - N�mero da vers�o do layout do lote
      ' '                                        + //17 - Uso exclusivo FEBRABAN/CNAB
      DefineTipoInscricao                        + //18 - Tipo de inscri��o do cedente
      PadLeft(OnlyNumber(CNPJCPF), 15, '0')      + //19 a 33 -N�mero de inscri��o do cedente
      PadRight('', 20, ' ')                      + //34 a 53 - C�digo do conv�nio no banco-Alfa
      Padleft(Agencia, 5, '0')                   + //54 a 58 - Ag�ncia Mantenedora da Conta
      DefineCampoDigitoAgencia                   + //59 a 59 - D�gito Verificador da Ag/Conta
//      Padleft(ACodBeneficiario,14,'0')           + //60 a 73 - C�digo do Benefici�rio
      Padleft(Conta, 13 , '0')                   + // Conta Beneficiario
      DefineCampoDigitoConta                     + //Digito Conta
      PadRight(Nome, 30, ' ')                    + //74 a 103 - Nome do cedente
      PadRight('', 40, ' ')                      + //104 a 143 - Mensagem 1
      PadRight('', 40, ' ')                      + //144 a 183 - Mensagen 2
      PadLeft(IntToStr(NumeroRemessa), 8, '0')   + //184 a 191 - N�mero seq�encial do registro no lote
      FormatDateTime('ddmmyyyy', date)           +// 192 a 199 Data de Grava��o Remessa/Retorno
      Padleft('0', 8 , '0')                      + //200 -207 Data do Cr�dito
      '00'                                       + //208 a 209 - Uso exclusivo FEBRABAN/CNAB
      Space(31)                                  );//210 a 240 - Uso exclusivo FEBRABAN/CNAB

    end;

    Result := RemoverQuebraLinhaFinal(ListHeader.Text);
  finally
    ListHeader.Free;
  end;

end;

procedure TACBrBancoUnicredES.GerarRegistroHeader400(NumeroRemessa: Integer;
  ARemessa: TStringList);
var sNome : String;
begin
  sNome := fpNome;
  try
    if (fpLayoutVersaoLote = 944) then
      fpNome := 'UNICRED';
    inherited;
  finally
    fpNome := sNome;
  end;
end;

end.


