{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor Hugo Gonzales - Panda                    }
{                                                                              }
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

{$i ACBr.inc}
unit ACBrBancoSofisaSantander;

interface

uses
  Classes,
  SysUtils,
  Contnrs,
  ACBrBoleto;

type

  { TACBrBancoSofisaSantander }

  TACBrBancoSofisaSantander = class(TACBrBancoClass)
  private
  protected
    vTotalTitulos : Double;
  public
    Constructor create(AOwner: TACBrBanco);
    function CalcularDigitoVerificador(const ACBrTitulo:TACBrTitulo): String; override;
    function MontarCodigoBarras(const ACBrTitulo : TACBrTitulo): String; override;
    function MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String; override;
    function GerarRegistroHeader240(NumeroRemessa: Integer) : String; override;
    procedure GerarRegistroHeader400(NumeroRemessa : Integer; aRemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa:TStringList);  override;

    Procedure LerRetorno400(ARetorno:TStringList); override;
    Procedure LerRetorno240(ARetorno:TStringList); override;
    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia) : String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia):String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia:TACBrTipoOcorrencia; CodMotivo:string): String; overload;

    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
  end;

implementation

uses
  {$ifdef COMPILER6_UP} DateUtils {$else} ACBrD5 {$endif},
  StrUtils, ACBrBoletoConversao, ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime;

{ TACBrBancoSofisaSantander }

constructor TACBrBancoSofisaSantander.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                 := 7;
   fpNome                   := 'Banco Sofisa';
   fpNumero                 := 033;
   fpTamanhoMaximoNossoNum  := 12;
   fpTamanhoCarteira        := 4;
   fpTamanhoConta           := 10;
   fpNumeroCorrespondente   := 637;
end;

function TACBrBancoSofisaSantander.CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo ): String;
begin
   Modulo.CalculoPadrao;
   Modulo.MultiplicadorFinal := 9;
   Modulo.Documento := ACBrTitulo.NossoNumero;
   Modulo.Calcular;

   Result:= IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoSofisaSantander.MontarCodigoBarras ( const ACBrTitulo: TACBrTitulo) : String;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras, DigitoNossoNumero:String;
begin

   with ACBrTitulo.ACBrBoleto do
   begin
      DigitoNossoNumero := CalcularDigitoVerificador(ACBrTitulo);
      FatorVencimento   := CalcularFatorVencimento(ACBrTitulo.Vencimento);

      CodigoBarras := '033'+'9'+ FatorVencimento +
                       IntToStrZero(Round(ACBrTitulo.ValorDocumento*100),10)       +
                       '9'+ PadLeft(trim(Cedente.CodigoCedente),7,'0')             +
                       PadLeft(ACBrTitulo.NossoNumero + DigitoNossoNumero, 13,'0') +
                       '0'+ PadLeft(trim(Cedente.Modalidade),3,'0');



      DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);
   end;

   Result:= '033' + '9'+ DigitoCodBarras + Copy(CodigoBarras,5,39);
end;

function TACBrBancoSofisaSantander.MontarCampoNossoNumero (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   with ACBrTitulo do
   begin
      case StrToIntDef(Carteira,0) of
         4: Carteira := '101';
         6: Carteira := '201';
         5: Carteira := '102';
      end;
   end;

   Result:= PadLeft(ACBrTitulo.NossoNumero,12,'0')+ ' '+ CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoSofisaSantander.MontarCampoCodigoCedente (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   if (ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito = '') then
   begin
     Result := ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente
   end
   else
   begin
     Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia+'-'+
             ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito+'/'+
             ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente
   end;
end;

procedure TACBrBancoSofisaSantander.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  DigitoNossoNumero, Ocorrencia,aEspecie, sChaveNFe :String;
  Protesto, Multa, valorMulta, aAgencia, TipoSacado, wLinha :String;
  aCarteira, I, mensagemBranco, multiplicadorMulta: Integer;
begin

  aCarteira := StrToIntDef(ACBrTitulo.Carteira, 0 );

  if aCarteira = 102  then
    aCarteira:= 5
  else if aCarteira = 201 then
    aCarteira:= 6
  else if aCarteira = 101 then
    aCarteira:= 4;

  if aCarteira = 5 then
    aAgencia := PadLeft(OnlyNumber(ACBrTitulo.ACBrBoleto.Cedente.Agencia) +
                       ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito,5,'0')
  else
    aAgencia:= '00000';

  vTotalTitulos:= vTotalTitulos+ ACBrTitulo.ValorDocumento;
  with ACBrTitulo do
  begin
    DigitoNossoNumero := CalcularDigitoVerificador(ACBrTitulo);

    {Pegando C�digo da Ocorrencia}
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar                        : Ocorrencia := '02'; {Pedido de Baixa}
      toRemessaConcederAbatimento            : Ocorrencia := '04'; {Concess�o de Abatimento}
      toRemessaCancelarAbatimento            : Ocorrencia := '05'; {Cancelamento de Abatimento concedido}
      toRemessaAlterarVencimento             : Ocorrencia := '06'; {Altera��o de vencimento}
      toRemessaProtestar                     : Ocorrencia := '09'; {Pedido de protesto}
      toRemessaNaoProtestar                  : Ocorrencia := '10'; {Sustar protesto antes do in�cio do ciclo de protesto}
      toRemessaCancelarInstrucaoProtesto     : Ocorrencia := '18'; {Sustar protesto e manter na carteira}
    else
      Ocorrencia := '01';                                          {Remessa}
    end;

    {Pegando Especie}
    if trim(EspecieDoc) = 'DM' then
      aEspecie:= '01'
    else if trim(EspecieDoc) = 'NP' then
      aEspecie:= '02'
    else if trim(EspecieDoc) = 'NS' then
      aEspecie:= '03'
    else if trim(EspecieDoc) = 'RC' then
      aEspecie:= '05'
    else if trim(EspecieDoc) = 'DS' then
      aEspecie:= '06'
    else if trim(EspecieDoc) = 'LC' then
      aEspecie:= '07'
    else if trim(EspecieDoc) = 'BDP' then
      aEspecie:= '08'
    else if trim(EspecieDoc) = 'BCC' then
      aEspecie:= '19'
    else
      aEspecie := EspecieDoc;

    {Pegando campo Intru��es}
    if (DataProtesto > 0) and (DataProtesto > Vencimento) then //and (Instrucao1 = '06') then
    begin
      Protesto := IntToStrZero(DaysBetween(DataProtesto,Vencimento),2);
      if (trim(Instrucao1) <> '06' )  and (trim(Instrucao2) <> '06' ) then
        If Trim(Instrucao1) = '' then
          Instrucao1 := '06'
        else
          Instrucao2 := '06';
    end
    else
      Protesto:= '00';

    Instrucao2 := '00';

    {Pegando Dias Multa}
    if (DataMulta > 0) and (DataMulta > Vencimento) then
    begin
      Multa := IntToStrZero(DaysBetween(DataMulta, Vencimento), 2);
    end
    else
      Multa := '00';

    {Define Valor Multa}
    if MultaValorFixo then
      multiplicadorMulta:= 100
    else
      multiplicadorMulta:= 10000;
    valorMulta:= IntToStrZero( round( PercentualMulta * multiplicadorMulta ), 13);

    {Pegando Tipo de Sacado}
    case Sacado.Pessoa of
      pFisica   : TipoSacado := '01';
      pJuridica : TipoSacado := '02';
    else
      TipoSacado := '99'; //TODO: CHECAR OQ FAZER PARA CEDENTE SEM TIPO
    end;

    with ACBrBoleto do
    begin
      sChaveNFe := '';

      if (ACBrTitulo.ListaDadosNFe.Count > 0) then
        sChaveNFe := ACBrTitulo.ListaDadosNFe[0].ChaveNFe;
      //sChaveNFe := PadLeft(sChaveNFe,44,'0');

      wLinha:= '1'                                                  +  // 1- ID Registro
        IfThen(Cedente.TipoInscricao = pJuridica,'02','01')         +  // 2 a 3
        PadLeft(trim(OnlyNumber(Cedente.CNPJCPF)),14,'0')           +  // 4 a 17
        PadRight(trim(Cedente.CodigoTransmissao),20)                +  // 18 a 37
        PadRight( SeuNumero ,25,' ')                                +  // 38 a 62
        '00000000000'                                               +  // 63 a 73
        PadLeft(RightStr(NossoNumero,12),12,'0') + DigitoNossoNumero+  // 74 a 86 Cobran�a direta T�tulo Correspondente
        Space(3)                                                    +  // 87 a 89 Modalidade de Cobran�a com bancos correspondentes.
        IfThen(PercentualMulta > 0,'2','0')                         +  // 90 a 90
        valorMulta                                                  +  // 91 a 103
        Multa                                                       +  // 104 a 105 N�mero de dias ap�s o vencimento para aplicar a multa
        Space(2)                                                    +  // 106 a 107 Identifica��o da Opera��o no Banco
        IntToStr(aCarteira)                                         +  // 108 a 108 C�digo da Carteira
        Ocorrencia                                                  +  // 109 a 110 Identifica��o da Ocorr�ncia
        PadRight( NumeroDocumento,10,' ')                           +  // 111 a 120
        FormatDateTime( 'ddmmyy', Vencimento)                       +  // 121 a 126
        IntToStrZero( round( ValorDocumento * 100), 13)             +  // 127 a 139
        '033' + aAgencia                                            +  // 140 a 147
        PadLeft(aEspecie, 2) + 'N'                                  +  // 148 a 150
        FormatDateTime( 'ddmmyy', DataDocumento )                   +  // 151 a 156
        PadLeft(trim(Instrucao1),2,'0')                             +  // 157 a 158
        PadLeft(trim(Instrucao2),2,'0')                             +  // 159 a 160
        IntToStrZero( round(ValorMoraJuros * 100 ), 13)             +  // 161 a 173
        IfThen(DataDesconto < EncodeDate(2000,01,01),
               '000000',
               FormatDateTime( 'ddmmyy', DataDesconto))             +  // 174 a 179
        IntToStrZero( round( ValorDesconto * 100), 13)              +  // 180 a 192
        IntToStrZero( round( ValorIOF * 100 ), 13)                  +  // 193 a 205
        IntToStrZero( round( ValorAbatimento * 100 ), 13)           +  // 206 a 218
        TipoSacado + PadLeft(OnlyNumber(Sacado.CNPJCPF),14,'0')     +  // 219 a 234
        PadRight( Sacado.NomeSacado, 40, ' ')                       +  // 235 a 274
        PadRight( Sacado.Logradouro + ' '+ Sacado.Numero, 40, ' ')  +  // 275 a 314
        PadRight( Sacado.Bairro,12,' ')                             +  // 315 a 326
        PadRight( OnlyNumber(Sacado.CEP) , 8, ' ' )                 +  // 327 a 334
        PadRight( Sacado.Cidade, 15, ' ')                           +
        PadRight( Sacado.UF, 2 )                                    +  // 335 a 351
        PadRight( IfThen(Sacado.SacadoAvalista.NomeAvalista <>'',
                         Sacado.SacadoAvalista.NomeAvalista,
                         Cedente.Nome), 30, ' ')                    +  // 352 a 381
        Space(4)                                                    +  // 382 a 385
        Space(6)                                                    +  // 386 a 391
        Protesto + '0'                                              +  // 392 a 394
        IntToStrZero( aRemessa.Count + 1, 6 )                       +  // 395 a 400
        sChaveNFe;                                                     // 401 a 444


      wLinha:= UpperCase(wLinha);
      if Mensagem.Count > 0 then
      begin
        wLinha:= wLinha + #13#10                         +
                 '2' + '0';
        for I := 0 to Mensagem.Count - 1 do
        begin
          if i = 5  then
            Break;

          wLinha := wLinha +
            PadRight(Mensagem[I],69);

        end;

        mensagemBranco := (5 - i) * 69;

        wLinha := wLinha + Space(mensagemBranco) + Space(47);
        wLinha := wLinha +  IntToStrZero(aRemessa.Count  + 2, 6 );
      end;

      aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
    end;
  end;
end;

function TACBrBancoSofisaSantander.GerarRegistroHeader240(NumeroRemessa: Integer): String;
begin
  raise Exception.Create( ACBrStr('N�o permitido para o layout deste banco.') );
end;

procedure TACBrBancoSofisaSantander.GerarRegistroHeader400(
  NumeroRemessa: Integer; aRemessa: TStringList);
var
  wLinha: String;
begin
   vTotalTitulos:= 0;
   with ACBrBanco.ACBrBoleto.Cedente do
   begin
      wLinha:= '0'                                        + // 001-001 ID do Registro
               '1'                                        + // 002-002 ID do Arquivo( 1 - Remessa)
               'REMESSA'                                  + // 003-009 Literal de Remessa
               '01'                                       + // 010-011 C�digo do Tipo de Servi�o
               PadRight( 'COBRANCA', 15 )                 + // 012-026 Descri��o do tipo de servi�o
               PadRight( CodigoTransmissao, 20)           + // 027-046 Codigo da Empresa no Banco
               PadRight( Nome, 30)                        + // 047-076 Nome da Empresa
               '637'                                      + // 077-079 C�digo
               PadRight('BANCO SOFISA SA', 15)            + // 080-094 Nome do Banco
               FormatDateTime('ddmmyy',Now)               + // 095-100 Data de gera��o do arquivo
               Space(294)                                 + // 101-394 Brancos
               IntToStrZero(1,6);                           // 395-400 Nr. Sequencial de Remessa

      aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
   end;
end;

procedure TACBrBancoSofisaSantander.GerarRegistroTrailler400( ARemessa:TStringList );
var
  wLinha: String;
begin
   wLinha:= '9'                                            + // ID Registro
            Space(393)                                     + // Complmenta��o do Registro (Brancos)
            IntToStrZero(ARemessa.Count + 1, 6);

   ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
end;

procedure TACBrBancoSofisaSantander.LerRetorno240(ARetorno: TStringList);
begin
  inherited;
  raise exception.Create('Leitura de retorno padr�o CNAB 240 n�o implementada para Sofisa AutBank!');
end;

Procedure TACBrBancoSofisaSantander.LerRetorno400 ( ARetorno: TStringList );
var
  Titulo : TACBrTitulo;
  ContLinha, CodOcorrencia: Integer;
  CodMotivo: string;
  Linha, rCedente, rAgencia, rConta, rDigitoConta, rCNPJCPF : String;
  wCodBanco: Integer;
  LPosicao : Integer;
  I : Integer;
begin
   wCodBanco := StrToIntDef(copy(ARetorno.Strings[0],77,3),-1);
   if (wCodBanco <> Numero) and (wCodBanco <> fpNumeroCorrespondente) then
      raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                             'n�o � um arquivo de retorno do '+ Nome));

   rCedente := trim(Copy(ARetorno[0],47,30));
   rAgencia := trim(Copy(ARetorno[1],169,4));
   rConta   := ''; //trim(Copy(ARetorno[1],22,8))+ Copy(ARetorno[1],384,1);
   //rConta   := PadLeft( OnlyNumber(rConta),fpTamanhoConta,'0');
   rDigitoConta := ''; //Copy(ARetorno[1],385,1);

   case StrToIntDef(Copy(ARetorno[1],2,2),0) of
      01: rCNPJCPF := Copy(ARetorno[1],7,11);
      02: rCNPJCPF := Copy(ARetorno[1],4,14);
   else
     rCNPJCPF := Copy(ARetorno[1],4,14);
   end;

   ACBrBanco.ACBrBoleto.DataCreditoLanc :=
     StringToDateTimeDef(Copy(ARetorno[0], 95, 2) + '/' +
                         Copy(ARetorno[0], 97, 2) + '/' +
                         Copy(ARetorno[0], 99, 2), 0, 'dd/mm/yy');

   ValidarDadosRetorno(rAgencia, rConta, rCNPJCPF);
   with ACBrBanco.ACBrBoleto do
   begin
      Cedente.Nome    := rCedente;
      Cedente.CNPJCPF := rCNPJCPF;
      Cedente.Agencia := rAgencia;
      Cedente.AgenciaDigito:= Copy(ARetorno[1],173,1);
      Cedente.Conta   := rConta;
      Cedente.ContaDigito:= rDigitoConta;

      DataArquivo   := StringToDateTimeDef(Copy(ARetorno[0],95,2)+'/'+
                                           Copy(ARetorno[0],97,2)+'/'+
                                           Copy(ARetorno[0],99,2),0, 'DD/MM/YY' );

      case StrToIntDef(Copy(ARetorno[1],2,2),0) of
         01: Cedente.TipoInscricao:= pFisica;
         else
            Cedente.TipoInscricao:= pJuridica;
      end;

      ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
   end;

   for ContLinha := 1 to ARetorno.Count - 2 do
   begin
      Linha := ARetorno[ContLinha] ;

      if Copy(Linha,1,1)<> '1' then
         Continue;

      Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

      with Titulo do
      begin
         SeuNumero   := copy(Linha,38,25);
         NossoNumero := Copy(Linha,63,11);
         NossoNumeroCorrespondente := Copy(Linha,95,12);
         Carteira    := Copy(Linha,108,1);

         OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(copy(Linha,109,2),0));

         DataOcorrencia:= StringToDateTimeDef(Copy(Linha,111,2)+'/'+
                                              Copy(Linha,113,2)+'/'+
                                              Copy(Linha,115,2),0, 'DD/MM/YY' );

         NumeroDocumento:= Copy(Linha,117,10);

         CodOcorrencia := StrToIntDef(copy(Linha,109,2),0);

         //-|Se a ocorrencia for igual a > 0 - Houve Erros
         if(CodOcorrencia > 0) then
         begin
           LPosicao := 378;
           for I := 1 to 4 do
           begin
             CodMotivo:= copy(Linha,LPosicao,2);
             if CodMotivo <> '00' then
             begin
               MotivoRejeicaoComando.Add(copy(Linha,LPosicao,2));
               DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo,CodMotivo));
               Inc(LPosicao, 2);
              end;
           end;
         end;

         Vencimento := StringToDateTimeDef( Copy(Linha,147,2)+'/'+
                                            Copy(Linha,149,2)+'/'+
                                            Copy(Linha,151,2),0, 'DD/MM/YY' );

         ValorDocumento       := StrToFloatDef(Copy(Linha,153,13),0)/100;

         case StrToIntDef(Copy(Linha,174,2),0) of
            01 : EspecieDoc:= 'DM';
            02 : EspecieDoc:= 'NP';
            03 : EspecieDoc:= 'CH';
            04 : EspecieDoc:= 'LC';
            05 : EspecieDoc:= 'RC';
            //06 : EspecieDoc:= 'DS';
            //07 : EspecieDoc:= 'LS';
            08 : EspecieDoc:= 'AS';
            12 : EspecieDoc:= 'DS';
            31 : EspecieDoc:= 'CC';
            99 : EspecieDoc:= 'OU';
         end;

         ValorDespesaCobranca := StrToFloatDef(Copy(Linha,176,13),0)/100;
         //ValorOutrasDespesas  := StrToFloatDef(Copy(Linha,189,13),0)/100;
         ValorMoraJuros       := StrToFloatDef(Copy(Linha,267,13),0)/100;
         ValorIOF             := StrToFloatDef(Copy(Linha,215,13),0)/100;
         ValorAbatimento      := StrToFloatDef(Copy(Linha,228,13),0)/100;
         ValorDesconto        := StrToFloatDef(Copy(Linha,241,13),0)/100;
         ValorRecebido        := StrToFloatDef(Copy(Linha,254,13),0)/100;
         //ValorOutrosCreditos  := StrToFloatDef(Copy(Linha,280,13),0)/100;

         {if Copy(Linha,294,1) = 'N' then
            Aceite:=  atNao
         else
            Aceite:=  atSim;}

         if StrToIntDef(Copy(Linha,386,6),0) <> 0 then
            DataCredito:= StringToDateTimeDef( Copy(Linha,386,2)+'/'+
                                               Copy(Linha,388,2)+'/'+
                                               Copy(Linha,390,2),0, 'DD/MM/YY' );

         //Sacado.NomeSacado:= Copy(Linha,302,36);
      end;
   end;
end;

function TACBrBancoSofisaSantander.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
 CodOcorrencia: Integer;
begin
  Result := '';
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia),0);

  { Atribuindo Ocorr�ncias diverg�ntes entre CNAB240 e CNAB400 }
  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    raise Exception.Create('c240 n�o implementado!');
  end
  else
  begin
    case CodOcorrencia of
      02: Result := 'Entrada Confirmada';
      03: Result := 'Entrada Rejeitada - ver motivo';
      05: Result := 'Campo Livre Alterado';
      06: Result := 'Liquida��o Normal';
      08: Result := 'Liquida��o em Cart�rio';
      09: Result := 'Baixa Autom�tica';
      10: Result := 'Baixa por ter sido liquidado';
      12: Result := 'Confirma Abatimento';
      13: Result := 'Abatimento Cancelado';
      14: Result := 'Vencimento Alterado';
      15: Result := 'Baixa Rejeitada - ver motivo';
      16: Result := 'Instru��o Rejeitada - ver motivo';
      19: Result := 'Confirma Recebimento de Ordem de Protesto';
      20: Result := 'Confirma Recebimento de Ordem de Susta��o';
      22: Result := 'Seu n�mero alterado';
      23: Result := 'T�tulo enviado para cart�rio';
      24: Result := 'Confirma recebimento de ordem de n�o protestar';
      28: Result := 'D�bito de Tarifas/Custas � Correspondentes';
      40: Result := 'Tarifa de Entrada (debitada na Liquida��o)';
      43: Result := 'Baixado por ter sido protestado';
      96: Result := 'Tarifa Sobre Instru��es � M�s anterior';
      97: Result := 'Tarifa Sobre Baixas � M�s Anterior';
      98: Result := 'Tarifa Sobre Entradas � M�s Anterior';
      99: Result := 'Tarifa Sobre Instru��es de Protesto/Susta��o � M�s Anterior';
    end
  end;
end;

function TACBrBancoSofisaSantander.CodOcorrenciaToTipo(const CodOcorrencia:
   Integer ) : TACBrTipoOcorrencia;
begin
  // DONE -oJacinto Junior: Ajustar para utilizar as ocorr�ncias corretas.
  Result := toTipoOcorrenciaNenhum;

  { Atribuindo Ocorr�ncias diverg�ntes entre CNAB240 e CNAB400 }
  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    raise Exception.Create('C�digo de ocorr�ncia n�o implementado para c240!');
  end
  else
  begin
    case CodOcorrencia of
      02: Result := toRetornoEntradaConfirmadaNaCip; //Entrada Confirmada
      03: Result := toRetornoRemessaRejeitada; // (*) Entrada Rejeitada
      //05: Campo Livre Alterado
      06: Result :=  toRetornoLiquidado; //Liquida��o Normal
      08: Result := toRetornoLiquidadoEmCartorio; // Liquida��o em Cart�rio
      09: Result := toRetornoBaixaAutomatica; // Baixa Autom�tica
      10: Result := toRetornoLiquidado; // Baixa por ter sido liquidado  ?????????????????????????
      12: Result := toRetornoAbatimentoConcedido; // Confirma Abatimento
      13: Result := toRetornoAbatimentoCancelado; // Abatimento Cancelado
      14: Result := toRetornoVencimentoAlterado; // Vencimento Alterado
      15: Result := toRetornoBaixaRejeitada; // (*) Baixa Rejeitada
      16: Result := toRetornoInstrucaoRejeitada; // (*) Instru��o Rejeitada
      19: Result := toRetornoConfInstrucaoProtesto; // Confirma Recebimento de Ordem de Protesto
      20: Result := toRetornoConfInstrucaoSustacaoProtesto; // Confirma Recebimento de Ordem de Susta��o
      22: Result := toRetornoAlteracaoSeuNumero; // Seu n�mero alterado
      23: Result := toRetornoEncaminhadoACartorio; // T�tulo enviado para cart�rio
      24: Result := toRetornoRecebimentoInstrucaoNaoProtestar; // Confirma recebimento de ordem de n�o protestar
      28: Result := toRetornoDebitoTarifas; // D�bito de Tarifas/Custas � Correspondentes
      40: Result := toRetornoDebitoTarifas; // Tarifa de Entrada (debitada na Liquida��o) ??????????????????????????
      43: Result := toRetornoBaixaPorProtesto; // Baixado por ter sido protestado
      //96 Tarifa Sobre Instru��es � M�s anterior
      //97 Tarifa Sobre Baixas � M�s Anterior
      //98 Tarifa Sobre Entradas � M�s Anterior
      //99 Tarifa Sobre Instru��es de Protesto/Susta��o � M�s Anterior
    else
      Result := toRetornoOutrasOcorrencias;
    end
  end;
end;

function TACBrBancoSofisaSantander.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Altera��o de vencimento}
    07 : Result:= toRemessaAlterarControleParticipante;     {Altera��o do controle do participante}
    08 : Result:= toRemessaAlterarNumeroControle;           {Altera��o de seu n�mero}
    09 : Result:= toRemessaProtestar;                       {Pedido de protesto}
    18 : Result:= toRemessaCancelarInstrucaoProtesto;       {Sustar protesto e manter na carteira}
    98 : Result:= toRemessaNaoProtestar;                    {Sustar protesto antes do in�cio do ciclo de protesto}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;
end;

function TACBrBancoSofisaSantander.TipoOcorrenciaToCod (
   const TipoOcorrencia: TACBrTipoOcorrencia ) : String;
begin
  Result := '';

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    raise Exception.Create('c240 n�o implementado!');
  end
  else
  begin
    case TipoOcorrencia of
      toRetornoEntradaConfirmadaNaCip: Result := '02';
      toRetornoRemessaRejeitada: Result := '03';
      toRetornoLiquidado: Result := '06';
      toRetornoLiquidadoEmCartorio: Result := '08';
      toRetornoBaixaAutomatica: Result := '09';
//      toRetornoLiquidado: Result := 'Baixa por ter sido liquidado';
      toRetornoAbatimentoConcedido: Result := '12';
      toRetornoAbatimentoCancelado: Result := '13';
      toRetornoVencimentoAlterado: Result := '14';
      toRetornoBaixaRejeitada: Result := '15';
      toRetornoInstrucaoRejeitada: Result := '16';
      toRetornoConfInstrucaoProtesto: Result := '19';
      toRetornoConfInstrucaoSustacaoProtesto: Result := '20';
      toRetornoAlteracaoSeuNumero: Result := '22';
      toRetornoEncaminhadoACartorio: Result := '23';
      toRetornoRecebimentoInstrucaoNaoProtestar: Result := '24';
      toRetornoDebitoTarifas: Result := '28';
//      toRetornoDebitoTarifas: Result := '40 Tarifa de Entrada (debitada na Liquida��o)';
      toRetornoBaixaPorProtesto: Result := '43';
    else
      raise Exception.Create('C�digo de tipo de ocorr�ncia identerminado!');
    end;
  end;

end;

function TACBrBancoSofisaSantander.CodMotivoRejeicaoToDescricao( const TipoOcorrencia:TACBrTipoOcorrencia; CodMotivo: string) : String;
const
  Motivos03: array [0..101] of string = (
    '03 CEP inv�lido � N�o temos cobrador � Cobrador n�o Localizado',
    '04 Sigla do Estado inv�lida',
    '05 Data de Vencimento inv�lida ou fora do prazo m�nimo',
    '06 C�digo do Banco inv�lido',
    '08 Nome do sacado n�o informado',
    '10 Logradouro n�o informado',
    '14 Registro em duplicidade',
    '19 Data de desconto inv�lida ou maior que a data de vencimento',
    '20 Valor de IOF n�o num�rico',
    '21 Movimento para t�tulo n�o cadastrado no sistema',
    '22 Valor de desconto + abatimento maior que o valor do t�tulo',
    '25 CNPJ ou CPF do sacado inv�lido (aceito com restri��es)',
    '26 Esp�cie de documento inv�lida',
    '27 Data de emiss�o do t�tulo inv�lida',
    '28 Seu n�mero n�o informado',
    '29 CEP � igual a espa�o ou zeros; ou n�o num�rico',
    '30 Valor do t�tulo n�o num�rico ou inv�lido',
    '36 Valor de perman�ncia (mora) n�o num�rico',
    '37 Valor de perman�ncia inconsistente, pois, dentro de um m�s, ser� maior que o valor do t�tulo',
    '38 Valor de desconto/abatimento n�o num�rico ou inv�lido',
    '39 Valor de abatimento n�o num�rico',
    '42 T�tulo j� existente em nossos registros. Nosso n�mero n�o aceito',
    '43 T�tulo enviado em duplicidade nesse movimento',
    '44 T�tulo zerado ou em branco; ou n�o num�rico na remessa',
    '46 T�tulo enviado fora da faixa de Nosso N�mero, estipulada para o cliente',
    '51 Tipo/N�mero de Inscri��o Sacador/Avalista Inv�lido',
    '52 Sacador/Avalista n�o informado',
    '53 Prazo de vencimento do t�tulo excede ao da contrata��o',
    '54 Banco informado n�o � nosso correspondente 140-142',
    '55 Banco correspondente informado n�o cobra este CEP ou n�o possui faixas de CEP cadastradas',
    '56 Nosso n�mero no correspondente n�o foi informado',
    '57 Remessa contendo duas instru��es incompat�veis � n�o protestar e dias de protesto ou prazo para protesto inv�lido',
    '58 Entradas Rejeitadas � Reprovado no Represamento para An�lise',
    '60 CNPJ/CPF do sacado inv�lido � t�tulo recusado',
    '87 Excede Prazo m�ximo entre emiss�o e vencimento',
    'AA Servi�o de cobran�a inv�lido',
    'AB Servi�o de "0" ou "5" e banco cobrador <> zeros',
    'AE T�tulo n�o possui abatimento',
    'AG Movto n�o permitido para t�tulo � Vista/Contra Apresenta��o',
    'AH Cancelamento de Valores Inv�lidos',
    'AI Nossa carteira inv�lida',
    'AJ Modalidade com bancos correspondentes inv�lida',
    'AK T�tulo pertence a outro cliente',
    'AL Sacado impedido de entrar nesta cobran�a',
    'AT Valor Pago Inv�lido',
    'AU Data da ocorr�ncia inv�lida',
    'AV Valor da tarifa de cobran�a inv�lida',
    'AX T�tulo em pagamento parcial',
    'AY T�tulo em Aberto e Vencido para acatar protestol',
    'BA Banco Correspondente Recebedor n�o � o Cobrador Atual',
    'BB T�tulo deve estar em cart�rio para baixar',
    'BC An�lise gerencial-sacado inv�lido p/opera��o cr�dito',
    'BD An�lise gerencial-sacado inadimplente',
    'BE An�lise gerencial-sacado difere do exigido',
    'BF An�lise gerencial-vencto excede vencto da opera��o de cr�dito',
    'BG An�lise gerencial-sacado com baixa liquidez',
    'BH An�lise gerencial-sacado excede concentra��o',
    'CC Valor de iof incompat�vel com a esp�cie documento',
    'CD Efetiva��o de protesto sem agenda v�lida',
    'CE T�tulo n�o aceito - pessoa f�sica',
    'CF Excede prazo m�ximo da entrada ao vencimento',
    'CG T�tulo n�o aceito � por an�lise gerencial',
    'CH T�tulo em espera � em an�lise pelo banco',
    'CJ An�lise gerencial-vencto do titulo abaixo przcurto',
    'CK An�lise gerencial-vencto do titulo abaixo przlongo',
    'CS T�tulo rejeitado pela checagem de duplicatas',
    'DA An�lise gerencial � Entrada de T�tulo Descontado com limite cancelado',
    'DB An�lise gerencial � Entrada de T�tulo Descontado com limite vencido',
    'DC An�lise gerencial - cedente com limite cancelado',
    'DD An�lise gerencial � cedente � sacado e teve seu limite cancelado',
    'DE An�lise gerencial - apontamento no Serasa',
    'DG Endere�o sacador/avalista n�o informado',
    'DH Cep do sacador/avalista n�o informado',
    'DI Cidade do sacador/avalista n�o informado',
    'DJ Estado do sacador/avalista inv�lido ou n informado',
    'DM Cliente sem C�digo de Flash cadastrado no cobrador',
    'DN T�tulo Descontado com Prazo ZERO � Recusado',
    'DP Data de Refer�ncia menor que a Data de Emiss�o do T�tulo',
    'DT Nosso N�mero do Correspondente n�o deve ser informado',
    'EB HSBC n�o aceita endere�o de sacado com mais de 38 caracteres',
    'G1 Endere�o do sacador incompleto (lei 12.039)',
    'G2 Sacador impedido de movimentar',
    'G3 Concentra��o de cep n�o permitida',
    'G4 Valor do t�tulo n�o permitido',
    'HA Servi�o e Modalidade Incompat�veis',
    'HB Inconsist�ncias entre Registros T�tulo e Sacador',
    'HC Ocorr�ncia n�o dispon�vel',
    'HD T�tulo com Aceite',
    'HF Baixa Liquidez do Sacado',
    'HG Sacado Informou que n�o paga Boletos',
    'HH Sacado n�o confirmou a Nota Fiscal',
    'HI Checagem Pr�via n�o Efetuada',
    'HJ Sacado desconhece compra e Nota Fiscal',
    'HK Compra e Nota Fiscal canceladas pelo sacado',
    'HL Concentra��o al�m do permitido pela �rea de Cr�dito',
    'HM Vencimento acima do permitido pelo �rea de Cr�dito',
    'HN Excede o prazo limite da opera��o',
    'IX T�tulo de Cart�o de Cr�dito n�o aceita instru��es',
    'JB T�tulo de Cart�o de Cr�dito inv�lido para o Produto',
    'JC Produto somente para Cart�o de Cr�dito',
    'JH CB Direta com opera��o de Desconto Autom�tico',
    'JI Esp�cie de Documento incompat�vel para produto de Cart�o de Cr�dito');

Motivos15: array [0..2] of string =
('05 Solicita��o de baixa para t�tulo j� baixado ou liquidado',
'06 Solicita��o de baixa para t�tulo n�o registrado no sistema',
'08 Solicita��o de baixa para t�tulo em float');

Motivos16: array [0..37] of string =
('04 Data de vencimento n�o num�rica ou inv�lida',
'05 Data de Vencimento inv�lida ou fora do prazo m�nimo',
'14 Registro em duplicidade',
'19 Data de desconto inv�lida ou maior que a data de vencimento',
'20 Campo livre n�o informado',
'21 T�tulo n�o registrado no sistema',
'22 T�tulo baixado ou liquidado',
'26 Esp�cie de documento inv�lida',
'27 Instru��o n�o aceita, por n�o ter sido emitida ordem de protesto ao cart�rio',
'28 T�tulo tem instru��o de cart�rio ativa',
'29 T�tulo n�o tem instru��o de carteira ativa',
'30 Existe instru��o de n�o protestar, ativa para o t�tulo',
'36 Valor de perman�ncia (mora) n�o num�rico',
'37 T�tulo Descontado � Instru��o n�o permitida para a carteira',
'38 Valor do abatimento n�o num�rico ou maior que a soma do valor do t�tulo + perman�ncia + multa',
'39 T�tulo em cart�rio',
'40 Instru��o recusada � Reprovado no Represamento para An�lise',
'44 T�tulo zerado ou em branco; ou n�o num�rico na remessa',
'51 Tipo/N�mero de Inscri��o Sacador/Avalista Inv�lido',
'53 Prazo de vencimento do t�tulo excede ao da contrata��o',
'57 Remessa contendo duas instru��es incompat�veis � n�o protestar e dias de protesto ou prazo para protesto inv�lido.',
'AA Servi�o de cobran�a inv�lido',
'AE T�tulo n�o possui abatimento',
'AG Movimento n�o permitido � T�tulo � vista ou contra apresenta��o',
'AH Cancelamento de valores inv�lidos',
'AI Nossa carteira inv�lida',
'AK T�tulo pertence a outro cliente',
'AU Data da ocorr�ncia inv�lida',
'AY T�tulo deve estar em aberto e vencido para acatar protesto',
'CB T�tulo possui protesto efetivado/a efetivar hoje',
'CT T�tulo j� baixado',
'CW T�tulo j� transferido',
'DO T�tulo em Preju�zo',
'JK Produto n�o permite altera��o de valor de t�tulo',
'JQ T�tulo em Correspondente � N�o alterar Valor',
'JS T�tulo possui Descontos/Abto/Mora/Multa',
'JT T�tulo possui Agenda de Protesto/Devolu��o',
'99 Ocorr�ncia desconhecida na remessa');

var i: integer;

begin
  Result := '';
  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c400) then
  begin
    case TipoOcorrencia of
      toRetornoRemessaRejeitada:
      begin
        for i := Low(Motivos03) to High(Motivos03) do
        begin
          if Pos(CodMotivo, Motivos03[i]) = 1 then
          begin
            Result := Motivos03[i];
            Exit;
          end;
          Result := '?? C�digo de motivo n�o reconhecido!';
        end;
      end;
      toRetornoBaixaRejeitada:
      begin
        for i := Low(Motivos15) to High(Motivos15) do
        begin
          if Pos(CodMotivo, Motivos15[i]) = 1 then
          begin
            Result := Motivos15[i];
            Exit;
          end;
          Result := '?? C�digo de motivo n�o reconhecido!';
        end;
      end;
      toRetornoInstrucaoRejeitada:
      begin
        for i := Low(Motivos16) to High(Motivos16) do
        begin
          if Pos(CodMotivo, Motivos15[i]) = 1 then
          begin
            Result := Motivos16[i];
            Exit;
          end;
          Result := '?? C�digo de motivo n�o reconhecido!';
        end;
      end;
    end;
  end
  else // 240
  begin
    raise exception.Create('cnab 240 n�o implementado!');
  end;
end;

end.
