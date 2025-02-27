{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrTEFMSitefComum;

interface

uses
  Classes,
  SysUtils,
  ACBrTEFComum;

const
  PWRET_OK = 0;      // Opera��o bem sucedida

  //==========================================================================================
  //  Tabela de C�digos de retorno das transa��es
  //==========================================================================================
  PWOPER_SALE             = 0; // (Venda) Realiza o pagamento de mercadorias e/ou servi�os vendidos pelo Estabelecimento ao Cliente (tipicamente, com cart�o de cr�dito/d�bito), transferindo fundos entre as respectivas contas.
  PWOPER_COMEXTERNA       = 1; // Campo para definir qual servi�o TLS ser� usado: 0 � Sem (apenas para SiTef dedicado); 1 � TLS Software Express; 2 � TLS WNB Comnect; 3 � TLS Gsurf
  PWOPER_DOUBLEVALIDATION = 2; // Campo para definir qual tipo de valida��o ser� usado: 0 � Para valida��o simples; 1 � Para valida��o dupla
  PWOPER_RESTRICOES       = 3; // Restrincoes de transa��o no sitef
  PWOPER_TRANSHABILITADA  = 4; // Transacoes Habilitadas no sitef
  PWOPER_OTP              = 5; // C�digo OTP
  PWOPER_ACESSIBILIDADEVISUAL = 6; // Campo para definir se a acessibilidade visual deve ser habilitada: 0 � Para desabilitar (valor padr�o) 1 � Para habilitar
  PWOPER_TIPOPINPAD       = 7; //Tipo de pinpad ANDROID_USB ou ANDROID_BT
  PWOPER_TIMEOUT_COLETA   = 8;
  PWOPER_TOKEN_TLS        = 9;
  PWOPER_ADMIN            = 110;  // Acessa qualquer transa��o que n�o seja disponibilizada pelo comando PWOPER_SALE. Um menu � apresentado para o operador selecionar a transa��o desejada.
  PWOPER_SALEVOID         = 200;  // (Cancelamento de venda) Cancela uma transa��o PWOPER_SALE, realizando a transfer�ncia de fundos inversa
  PWOPER_REPRINT          = 114;  // Obt�m o �ltimo comprovante gerado por uma transa��o


  //==========================================================================================
  //   Tipos de dados que podem ser informados pela Automa��o
  //==========================================================================================
  PWINFO_RET            = 0;      // C�digo do �ltimo Retorno (PWRET)  (uso interno do ACBr)
  PWINFO_POSID          = 17;     // Identificador do Ponto de Captura.
  PWINFO_TOTAMNT        = 37;     // Valor total da opera��o, considerando PWINFO_CURREXP (em centavos se igual a 2), incluindo desconto, saque, gorjeta, taxa de embarque, etc.
  PWINFO_CURRENCY       = 38;     // Moeda (padr�o ISO4217, 986 para o Real)
  PWINFO_CURREXP        = 39;     // Expoente da moeda (2 para centavos)
  PWINFO_FISCALREF      = 40;     // Identificador do documento fiscal
  PWINFO_CARDTYPE       = 41;     // Tipo de cart�o utilizado (PW_iGetResult), ou tipos de cart�o aceitos (soma dos valores abaixo, PW_iAddParam): 1: cr�dito 2: d�bito 4: voucher/PAT 8: private label 16: frota 128: outros
  PWINFO_DATETIME       = 49;     // Data e hora local da transa��o, no formato �AAAAMMDDhhmmss�
  PWINFO_REQNUM         = 50;     // Refer�ncia local da transa��o
  PWINFO_AUTHSYST       = 53;     // Nome do Provedor: �ELAVON�; �FILLIP�; �LIBERCARD�; �RV�; etc
  PWINFO_VIRTMERCH      = 54;     // Identificador do Estabelecimento
  PWINFO_AUTMERCHID     = 56;     // Identificador do estabelecimento para o Provedor (c�digo de afilia��o).
  PWINFO_FINTYPE        = 59;     // Modalidade de financiamento da transa��o: 1: � vista 2: parcelado pelo emissor 4: parcelado pelo estabelecimento 8: pr�-datado 16: cr�dito emissor
  PWINFO_INSTALLMENTS   = 60;     // Quantidade de parcelas
  PWINFO_INSTALLMDATE   = 61;     // Data de vencimento do pr�-datado, ou da primeira parcela. Formato �DDMMAA
  PWINFO_RESULTMSG      = 66;     // Mensagem descrevendo o resultado final da transa��o, seja esta bem ou mal sucedida
  PWINFO_CNFREQ         = 67;     // Necessidade de confirma��o: 0: n�o requer confirma��o; 1: requer confirma��o.
  PWINFO_AUTLOCREF      = 68;     // Refer�ncia da transa��o para a infraestrutura
  PWINFO_AUTEXTREF      = 69;     // Refer�ncia da transa��o para o Provedor (NSU host).
  PWINFO_AUTHCODE       = 70;     // C�digo de autoriza��o
  PWINFO_AUTRESPCODE    = 71;     // C�digo de resposta da transa��o (campo ISO8583:39)
  PWINFO_AUTDATETIME    = 72;     // Data/hora da transa��o para o Provedor, formato �AAAAMMDDhhmmss�.
  PWINFO_DISCOUNTAMT    = 73;     // Valor do desconto concedido pelo Provedor, considerando PWINFO_CURREXP, j� deduzido em PWINFO_TOTAMNT
  PWINFO_CASHBACKAMT    = 74;     // Valor do saque/troco, considerando PWINFO_CURREXP, j� inclu�do em PWINFO_TOTAMNT
  PWINFO_CARDNAME       = 75;     // Nome do cart�o ou do emissor do cart�o
  PWINFO_BANDCODE       = 76;     // C�digo da bandeira do emissor do cart�o
  PWINFO_BOARDINGTAX    = 77;     // Valor da taxa de embarque, considerando PWINFO_CURREXP, j� inclu�do em PWINFO_TOTAMNT
  PWINFO_TIPAMOUNT      = 78;     // Valor da taxa de servi�o (gorjeta), considerando PWINFO_CURREXP, j� inclu�do em PWINFO_TOTAMNT
  PWINFO_INSTALLM1AMT   = 79;     // Valor da entrada para um pagamento parcelado, considerando PWINFO_CURREXP, j� inclu�do em PWINFO_TOTAMNT
  PWINFO_INSTALLMAMNT   = 80;     // Valor da parcela, considerando PWINFO_CURREXP, j� inclu�do em PWINFO_TOTAMNT
  PWINFO_RCPTFULL       = 82;     // Comprovante para impress�o � Via completa. At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh
  PWINFO_RCPTMERCH      = 83;     // Comprovante para impress�o � Via diferenciada para o Estabelecimento. At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh.
  PWINFO_RCPTCHOLDER    = 84;     // Comprovante para impress�o � Via diferenciada para o Cliente. At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh.
  PWINFO_RCPTCHSHORT    = 85;     // Comprovante para impress�o � Cupom reduzido (para o Cliente). At� 40 colunas, quebras de linha identificadas pelo caractere 0Dh
  PWINFO_TRNORIGDATE    = 87;     // Data da transa��o original, no caso de um cancelamento ou uma confirma��o de pr�-autoriza��o (formato �DDMMAA�).
  PWINFO_TRNORIGNSU     = 88;     // NSU da transa��o original, no caso de um cancelamento ou uma confirma��o de pr�-autoriza��o
  PWINFO_TRNORIGAMNT    = 96;     // Valor da transa��o original, no caso de um cancelamento ou uma confirma��o de pr�-autoriza��o.
  PWINFO_PROCESSMSG     = 111;    // Mensagem a ser exibida para o cliente durante o processamento da transa��o
  PWINFO_TRNORIGTIME    = 115;    // Hora da transa��o original, no caso de um cancelamento ou uma confirma��o de pr�-autoriza��o (formato �HHMMSS�).
  PWINFO_CNCDSPMSG      = 116;    // Mensagem a ser exibida para o operador no terminal no caso da transa��o ser abortada (cancelamento ou timeout).
  PWINFO_CARDENTMODE    = 192;    // Modo(s) de entrada do cart�o:
  PWINFO_CARDFULLPAN    = 193;    // N�mero do cart�o completo, para transa��o digitada. Este dado n�o pode ser recuperado pela fun��o
  PWINFO_CARDPARCPAN    = 200;    // N�mero do cart�o, truncado ou mascarado
  PWINFO_MERCHADDDATA1  = 240;    // Dados adicionais relevantes para a Automa��o (#1)
  PWCNF_CNF_AUTO        = 289;     // A transa��o foi confirmada pelo Ponto de Captura, sem interven��o do usu�rio.
                                  // 00 � Magn�tico; 01 - Moedeiro VISA Cash v1; 02 - Moedeiro VISA v3; 03 - EMV com contato; 04 - Easy-Entry; 05 - Chip sem contato simulando tarja
                                  // 06 - EMV sem contato (Cart�es tradicionais, adesivos e pulseiras sem contato, al�m das solu��es mobile tais como Apple Pay, Google Pay, Samsung Pay no modo �NFC � Near Field Communication�, entre outros)
                                  // 99 � Digitado
  PWINFO_CARDEXPDATE    = 194;    // Data de vencimento do cart�o (formato �MMAA�).
  PWINFO_CARDNAMESTD    = 196;    // Descri��o do produto bandeira padr�o relacionado ao BIN.
  PWINFO_RCPTPRN        = 244;    // Indica quais vias de comprovante devem ser impressas: 0: n�o h� comprovante 1: imprimir somente a via do Cliente 2: imprimir somente a via do Estabelecimento 3: imprimir ambas as vias do Cliente e do Estabelecimento
  PWINFO_PAYMNTTYPE     = 245;   // Modalidade de pagamento:   1: cart�o   2: dinheiro   4: cheque   8: carteira virtual
  PWINFO_CHOLDERNAME    = 246;   // Nome do portador do cart�o utilizado, o tamanho segue o mesmo padr�o da tag 5F20 EMV.
  PWINFO_DEFAULTCARDPARCPAN = 247; // N�mero do cart�o mascarado no formato BIN + *** + 4 �ltimos d�gitos. Ex: 543211******987
  PWINFO_AUTHPOSQRCODE  = 248;   // Conte�do do QR Code identificando o checkout para o autorizador.
  PWINFO_DATETIMERCPT   = 249;   // Data/hora da transa��o para exibi��o no comprovante, no formato �AAAAMMDDhhmmss�.

type
  EACBrTEFMSitefWeb = class(EACBrTEFErro);

  { TACBrTEFRespMSitefWeb }

  TACBrTEFRespMSitefWeb = class( TACBrTEFResp )
  public
    procedure ConteudoToProperty; override;
  end;

procedure ConteudoToPropertyMSitefWeb(AACBrTEFResp: TACBrTEFResp);
procedure DadosDaTransacaoToTEFResp(ADadosDaTransacao: TACBrTEFParametros; ATefResp: TACBrTEFResp);
function MoedaToISO4217(AMoeda: Byte): Word;
function ISO4217ToMoeda(AIso4217: Word): Byte;

function traduzRetorno( codRetorno: integer): string;

implementation

uses
  Math, DateUtils, StrUtils,
  ACBrConsts,
  ACBrUtil.Math,
  ACBrUtil.Strings,
  ACBrUtil.Base;

procedure ConteudoToPropertyMSitefWeb(AACBrTEFResp: TACBrTEFResp);

  procedure ConteudoToComprovantes;
  var
    ImprimirViaCliente, ImprimirViaEstabelecimento: Boolean;
    ViaCompleta, ViaDiferenciada, ViasDeComprovante: String;

    function ViaDoCliente( ViaReduzida: Boolean ): String;
    begin
      if ViaReduzida then
        Result := AACBrTEFResp.LeInformacao(PWINFO_RCPTCHSHORT, 0).AsBinary
      else
        Result := AACBrTEFResp.LeInformacao(PWINFO_RCPTCHOLDER, 0).AsBinary;
    end;

  begin
    with AACBrTEFResp do
    begin
      ViasDeComprovante := Trim(LeInformacao(PWINFO_RCPTPRN, 0).AsString);
      if (ViasDeComprovante = '') then
        ViasDeComprovante := '3';

      ImprimirViaCliente := (ViasDeComprovante = '1') or (ViasDeComprovante = '3');
      ImprimirViaEstabelecimento := (ViasDeComprovante = '2') or (ViasDeComprovante = '3');

      ViaCompleta := LeInformacao(PWINFO_RCPTFULL, 0).AsBinary;

      // Verificando Via do Estabelecimento
      if ImprimirViaEstabelecimento then
      begin
        ViaDiferenciada := trim(LeInformacao(PWINFO_RCPTMERCH, 0).AsBinary);
        if (Trim(ViaDiferenciada) <> '') then
          ImagemComprovante2aVia.Text := ViaDiferenciada
        else
          ImagemComprovante2aVia.Text := ViaCompleta;
      end
      else
        ImagemComprovante2aVia.Clear;

      // Verificando Via do Cliente
      if ImprimirViaCliente then
      begin
        ViaDiferenciada := ViaDoCliente( ViaClienteReduzida );
        if (Trim(ViaDiferenciada) = '') then
          ViaDiferenciada := ViaDoCliente( not ViaClienteReduzida );

        if (Trim(ViaDiferenciada) <> '') then
          ImagemComprovante1aVia.Text := ViaDiferenciada
        else
          ImagemComprovante1aVia.Text := ViaCompleta;
      end
      else
        ImagemComprovante1aVia.Clear;

      QtdLinhasComprovante := max(ImagemComprovante1aVia.Count, ImagemComprovante2aVia.Count);
    end;
  end;

  procedure ConteudoToParcelas;
  var
    DataParcela: TDateTime;
    ValorPrimeiraParcela, ValorParcelas, SaldoParcelas: Currency;
    I: Integer;
    Parc: TACBrTEFRespParcela;
  begin
    with AACBrTEFResp do
    begin
      Parcelas.Clear;

      QtdParcelas := LeInformacao(PWINFO_INSTALLMENTS, 0).AsInteger;
      if (QtdParcelas > 0) then
      begin
        DataParcela := LeInformacao(PWINFO_INSTALLMDATE, 0).AsDate;
        if (DataParcela = 0) then
          DataParcela := IncDay(DateOf(DataHoraTransacaoLocal), 30);

        ValorParcelas := LeInformacao(PWINFO_INSTALLMAMNT, 0).AsFloat;
        if (ValorParcelas = 0) then
          ValorParcelas := RoundABNT((ValorTotal / QtdParcelas), -2);

        ValorPrimeiraParcela := LeInformacao(PWINFO_INSTALLM1AMT, 0).AsFloat;
        if (ValorPrimeiraParcela = 0) then
          ValorPrimeiraParcela := ValorParcelas;

        SaldoParcelas := ValorTotal;

        for I := 1 to QtdParcelas do
        begin
          Parc := TACBrTEFRespParcela.create;
          Parc.Vencimento := DataParcela;
          if (I = QtdParcelas) then
            Parc.Valor := SaldoParcelas
          else if (I = 1) then
            Parc.Valor := ValorPrimeiraParcela
          else
            Parc.Valor := ValorParcelas;

          Parc.NSUParcela := NSU;
          Parcelas.Add(Parc);

          DataParcela := IncDay(DataParcela,30);
          SaldoParcelas := SaldoParcelas - Parc.Valor;
        end;
      end;
    end;
  end;

var
  I, AInt: Integer;
  LinStr: String;
  Linha: TACBrTEFLinha;
begin
  with AACBrTEFResp do
  begin
    ImagemComprovante1aVia.Clear;
    ImagemComprovante2aVia.Clear;
    Debito := False;
    Credito := False;
    Digitado := False;
    TaxaServico := 0;
    DataHoraTransacaoCancelada := 0;

    for I := 0 to Conteudo.Count - 1 do
    begin
      Linha := Conteudo.Linha[I];
      LinStr := Linha.Informacao.AsBinary;

      case Linha.Identificacao of
        PWINFO_TOTAMNT:
          ValorTotal := Linha.Informacao.AsFloat;

        PWINFO_DISCOUNTAMT:
          Desconto := Linha.Informacao.AsFloat;

        PWINFO_CASHBACKAMT:
          Saque := Linha.Informacao.AsFloat;

        PWINFO_CURRENCY:
        begin
          AInt := Linha.Informacao.AsInteger;
          Moeda := ISO4217ToMoeda(AInt);
        end;

        PWINFO_CNFREQ:
          Confirmar := (Trim(Linstr)='1');

        PWINFO_FISCALREF:
          DocumentoVinculado := LinStr;

        PWINFO_CARDTYPE:
        begin
          // Indica c�digo da transa��o realizada. Poss�veis valores: 00 cheque; 01 Debito; 02 cartao; 03 voucher
          AInt := Linha.Informacao.AsInteger;
          Debito  := (AInt = 1);
          Credito := (AInt = 2);
          Voucher := (Aint = 3);
        end;

        PWINFO_CARDENTMODE:
        begin
          // 1: digitado, 2: tarja magn�tica, 4: chip com contato, 16: fallback de chip para tarja,
          // 32: chip sem contato simulando tarja (cliente informa tipo efetivamente utilizado),
          // 64: chip sem contato EMV (cliente informa tipo efetivamente, utilizado),
          // 256: fallback de tarja para digitado
          AInt := Linha.Informacao.AsInteger;
          Digitado := (AInt = 1) or (AInt = 256);
        end;

        PWINFO_CARDFULLPAN:
        begin
          BIN := LinStr;
          NFCeSAT.UltimosQuatroDigitos := RightStr(LinStr,4);
        end;

        PWINFO_CARDPARCPAN:
        begin
          if (NFCeSAT.UltimosQuatroDigitos = '') then
            NFCeSAT.UltimosQuatroDigitos := RightStr(LinStr,4);
        end;

        PWINFO_DEFAULTCARDPARCPAN:
        begin
          BIN := LinStr;
          NFCeSAT.UltimosQuatroDigitos := RightStr(LinStr,4);
        end;

        PWINFO_CARDEXPDATE:
          NFCeSAT.DataExpiracao := LinStr;

        PWINFO_DATETIME:
          DataHoraTransacaoLocal := Linha.Informacao.AsTimeStampSQL;

        PWINFO_AUTDATETIME:
          DataHoraTransacaoHost :=  Linha.Informacao.AsTimeStampSQL;

        PWINFO_DATETIMERCPT:
          DataHoraTransacaoComprovante := Linha.Informacao.AsTimeStampSQL;

        PWINFO_AUTHSYST:
        begin
          Rede := LinStr;
          if (Trim(Rede) <> '') then
          begin
            //Verificar se o sitef retorna isso ou vamos tratar igual ao paygo
            {ARede := TabelaRedes.FindPGWeb(Rede);
            if Assigned(ARede) then
            begin
              if (NFCeSAT.Bandeira = '') then
                NFCeSAT.Bandeira := ARede.NomePGWeb;

              NFCeSAT.CNPJCredenciadora := ARede.CNPJ;
              NFCeSAT.CodCredenciadora := IntToStrZero(ARede.CodSATCFe, 3);
            end;}
          end;
        end;

        PWINFO_CARDNAME:
        begin
          if (NFCeSAT.Bandeira = '') then
            NFCeSAT.Bandeira := LinStr;
        end;

        PWINFO_BANDCODE:
          CodigoBandeiraPadrao := LinStr;

        PWINFO_CARDNAMESTD:
        begin
          NomeAdministradora := LinStr;
          NFCeSAT.Bandeira := LinStr;
        end;

        PWINFO_CHOLDERNAME:
          NFCeSAT.DonoCartao := LinStr;

        PWINFO_AUTLOCREF:
          Finalizacao := LinStr;

        PWINFO_AUTEXTREF:
        begin
          NSU := LinStr;
          CodigoPSP := LinStr;
          NFCeSAT.Autorizacao := NSU;
        end;

        PWINFO_REQNUM:
        begin
          NumeroLoteTransacao := Linha.Informacao.AsInt64;
          NSU_TEF := LinStr;
        end;

        PWINFO_VIRTMERCH:
          Estabelecimento := LinStr;

        PWINFO_AUTHCODE:
          CodigoAutorizacaoTransacao := LinStr;

        //PWINFO_AUTRESPCODE:
        //  Autenticacao := LinStr;

        PWINFO_FINTYPE:
        begin
          //Sitef �00�: � vista; �01�: Pr�-Datado; �02�: Parcelado Estabelecimento; �03�: Parcelado Administradora
          AInt := Linha.Informacao.AsInteger;
          if (AInt = 0) then
          begin
            ParceladoPor := parcNenhum;
            TipoOperacao := opAvista;
          end
          else if (AInt = 1) then
          begin
            ParceladoPor := parcNenhum;
            TipoOperacao := opPreDatado;
          end
          else if (AInt = 2) then
          begin
            ParceladoPor := parcLoja;
            TipoOperacao := opParcelado;
          end
          else if (AInt = 3) then
          begin
            ParceladoPor := parcADM;
            TipoOperacao := opPreDatado;
          end
          else
          begin
            ParceladoPor := parcNenhum;
            TipoOperacao := opAvista;
          end
        end;

        PWINFO_INSTALLMDATE:
          DataPreDatado := Linha.Informacao.AsDate;

        PWINFO_BOARDINGTAX, PWINFO_TIPAMOUNT:
          TaxaServico := TaxaServico + Linha.Informacao.AsFloat;

        PWINFO_TRNORIGDATE:
          DataHoraTransacaoCancelada := DataHoraTransacaoCancelada + Linha.Informacao.AsDate;

        PWINFO_TRNORIGTIME:
          DataHoraTransacaoCancelada := DataHoraTransacaoCancelada + Linha.Informacao.AsTime;

        PWINFO_TRNORIGNSU:
          NSUTransacaoCancelada := LinStr;

        PWINFO_TRNORIGAMNT:
          ValorOriginal := Linha.Informacao.AsFloat;

        PWINFO_AUTHPOSQRCODE:
          QRCode := LinStr;

        PWINFO_POSID:
          SerialPOS := LinStr;
      else
        ProcessarTipoInterno(Linha);
      end;
    end;

    ConteudoToComprovantes;
    ConteudoToParcelas;

    if (TipoOperacao <> opPreDatado) then
      DataPreDatado := 0;

    Sucesso := (LeInformacao(PWINFO_RET, 0).AsInteger = PWRET_OK);

    if Sucesso then
      TextoEspecialOperador := LeInformacao(PWINFO_RESULTMSG, 0).AsBinary
    else
      TextoEspecialOperador := IfEmptyThen( LeInformacao(PWINFO_CNCDSPMSG, 0).AsBinary,
                                            LeInformacao(PWINFO_RESULTMSG, 0).AsBinary );

    if (Trim(TextoEspecialOperador) = '') then
      TextoEspecialOperador := 'TRANSACAO FINALIZADA'
    else if (copy(TextoEspecialOperador,1,1) = CR) then
      TextoEspecialOperador := copy(TextoEspecialOperador, 2, Length(TextoEspecialOperador));
  end;
end;

procedure DadosDaTransacaoToTEFResp(ADadosDaTransacao: TACBrTEFParametros; ATefResp: TACBrTEFResp);
var
  i, p, AInfo: Integer;
  Lin, AValue: String;
begin
  for i := 0 to ADadosDaTransacao.Count-1 do
  begin
    Lin := ADadosDaTransacao[i];
    p := pos('=', Lin);
    if (p > 0) then
    begin
      AInfo := StrToIntDef(copy(Lin, 1, p-1), -1);
      if (AInfo >= 0) then
      begin
        AValue := copy(Lin, P+1, Length(Lin));
        ATefResp.Conteudo.GravaInformacao(Ainfo, 0, AValue);
      end;
    end;
  end;

  ConteudoToPropertyMSitefWeb( ATefResp );
end;


function MoedaToISO4217(AMoeda: Byte): Word;
begin
  case AMoeda of
    0: Result := 986;    // BRL
    1: Result := 840;    // USD
    2: Result := 978;    // EUR
  else
    Result := AMoeda;
  end;
end;

function ISO4217ToMoeda(AIso4217: Word): Byte;
begin
  case AIso4217 of
    986: Result := 0;    // BRL
    840: Result := 1;    // USD
    978: Result := 2;    // EUR
  else
    Result := AIso4217;
  end;
end;

function traduzRetorno( codRetorno: integer): string;
begin
  case codRetorno of
    0: Result := 'Sucesso na execucao da funcao.';
    1: Result := 'Endereco IP invalido ou nao resolvido';
    2: Result := 'Codigo da loja invalido';
    3: Result := 'Codigo de terminal invalido';
    6: Result := 'Erro na inicializacao do Tcp/Ip';
    7: Result := 'Falta de memoria';
    8: Result := 'Nao encontrou o Sitef ou ela esta com problemas';
    9: Result := 'Configuracao de servidores Sitef foi excedida.';
    10: Result := 'Erro de acesso na pasta Sitef (possivel falta de permissao para escrita)';
    11: Result := 'Dados invalidos passados pela automacao.';
    12: Result := 'Modo seguro nao ativo';
    13: Result := 'Caminho DLL invalido (o caminho completo das bibliotecas esta muito grande).';
    -1: Result := 'Modulo nao inicializado. O PDV tentou chamar alguma rotina sem antes executar a funcao configura.';
    -2: Result := 'Operacao cancelada pelo operador.';
    -3: Result := 'O parametro funcao / modalidade e inexistente/invalido.';
    -4: Result := 'Falta de memoria no PDV.';
    -5: Result := 'Sem comunicacao com o Sitef.';
    -6: Result := 'Operacao cancelada pelo usuario (no pinpad).';
    -9: Result := 'A automacao chamou a rotina ContinuaFuncaoInterativo sem antes iniciar uma funcao iterativa.';
    -10: Result := 'Algum parametro obrigatorio nao foi passado pela automacao comercial.';
    -12: Result := 'Erro na execucao da rotina iterativa. Provavelmente o processo iterativo anterior nao foi executado ate o final (enquanto o retorno for igual a 10000).';
    -13: Result := 'Documento fiscal nao encontrado nos registros do Sitef. Retornado em funcoes de consulta tais como ObtemQuantidadeTransacoesPendentes.';
    -15: Result := 'Operacao cancelada pela automacao comercial.';
    -20: Result := 'Parametro invalido passado para a funcao.';
    -25: Result := 'Erro no Correspondente Bancario: Deve realizar sangria.';
    -30: Result := 'Erro de acesso ao arquivo. Certifique-se que o usuario que roda a aplicacao tem direitos de leitura/escrita.';
    -40: Result := 'Transacao negada pelo servidor Sitef.';
    -41: Result := 'Dados invalidos.';
    -43: Result := 'Problema na execucao de alguma das rotinas no pinpad.';
    -50: Result := 'Transacao nao segura.';
    -100: Result := 'Erro interno do modulo.';
  else
    Result := 'Erro nao catalogado.';
  end;
end;

{ TACBrTEFRespMSitefWeb }

procedure TACBrTEFRespMSitefWeb.ConteudoToProperty;
begin
  ConteudoToPropertyMSitefWeb( Self );
end;

end.

