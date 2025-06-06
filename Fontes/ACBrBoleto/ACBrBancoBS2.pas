{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor H Gonzales - Pandaaa,                    }
{   Paulo Cesar Alves de Oliveira                                              }
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

unit ACBrBancoBS2;

interface

uses
  Classes, SysUtils, Contnrs, ACBrBoleto, ACBrBoletoConversao;

type

  { TACBrBancoBS2 }

  TACBrBancoBS2 = class(TACBrBancoClass)
  private
    fValorTotalDocs : Double;
    fQtRegLote      : Integer;
    fNumeroRemessa  : Integer;
    function EspecieDocumentoToIndex(const AValue : String) : String;
    function EspecieDocumentoToStr(const AValue : String) : String;

  protected
    function GetLocalPagamento: String; override;
  public
    constructor create(AOwner: TACBrBanco);

    function CalcularNomeArquivoRemessa: string; override;
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string; override;
    function DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string; override;

    procedure GerarRegistroHeader400(NumeroRemessa: Integer; aRemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa: TStringList); override;
    function GerarRegistroHeader240(NumeroRemessa: Integer) : String; override;

    procedure LerRetorno400(ARetorno: TStringList); override;
    Procedure LerRetorno240(ARetorno:TStringList); override;

    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): string; override;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): string; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): string; override;
    function CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;

    function CalcularDigitoVerificador(const ACBrTitulo:TACBrTitulo): String; override;
  end;

implementation

uses
  {$ifdef COMPILER6_UP} DateUtils {$else} ACBrD5 {$endif}, StrUtils, Variants,
  ACBrValidador, ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime;

constructor TACBrBancoBS2.Create(AOwner: TACBrBanco);
begin
  inherited create(AOwner);
  fpDigito                := 6;
  fpNome                  := 'Banco Bs2';
  fpNumero                := 218;
  fpTamanhoMaximoNossoNum := 11;
  fpTamanhoAgencia        := 4;
  fpTamanhoConta          := 8;
  fpTamanhoCarteira       := 2;
  fValorTotalDocs         := 0;
  fQtRegLote              := 0;
  fpCodigosMoraAceitos    := '012';
  fpLayoutVersaoArquivo   := 1;
end;

function TACBrBancoBS2.DefineCampoLivreCodigoBarras(
  const ACBrTitulo: TACBrTitulo): String;
begin
  with ACBrTitulo.ACBrBoleto do
  begin
    Result := '001'                                   // 01 A 03
            + PadLeft(Cedente.CodigoCedente, 10, '0') // 04 A 13
            + MontarCampoNossoNumero(ACBrTitulo)   // 14 A 24
            + '8';                                    // 25 A 25
  end;
end;


function TACBrBancoBS2.EspecieDocumentoToIndex(const AValue: String): String;
begin
  case AnsiIndexStr(UpperCase(AValue),['DM' ,'DS']) of
    0  : Result := '0'; //Duplicata mercantil
    1  : Result := '6'; //Duplicata servi�o
  else
    Result := '9';      { Outros}
  end;
end;

function TACBrBancoBS2.EspecieDocumentoToStr(const AValue: String): String;
begin
  case StrToIntDef(AValue,0) of
    0  : Result := 'DM'; //Duplicata mercantil
    1  : Result := 'DS'; //Duplicata servi�o
  else
    Result := 'OUT';      { Outros}
  end;
end;

function TACBrBancoBS2.MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string;
begin
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia
            + '/'
            + ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente;
end;

function TACBrBancoBS2.MontarCampoNossoNumero(
  const ACBrTitulo: TACBrTitulo): string;
begin
  Result:= Copy(ACBrTitulo.NossoNumero, 2, 10)
           + CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoBS2.GerarRegistroHeader240(NumeroRemessa: Integer): String;
begin
  raise Exception.Create( ACBrStr('N�o permitido para o layout deste banco.') );
end;

procedure TACBrBancoBS2.GerarRegistroHeader400(NumeroRemessa: Integer; ARemessa: TStringList);
var
  wLinha       : string;
  Beneficiario : TACBrCedente;
begin

  fNumeroRemessa := NumeroRemessa;

  Beneficiario := ACBrBanco.ACBrBoleto.Cedente;

  wLinha := '0'                                                 + // 001 a 001 Identifica��o do registro
            '1'                                                 + // 002 a 002 Identifica��o do arquivo remessa
            'REMESSA'                                           + // 003 a 009 Literal remessa
            '01'                                                + // 010 a 011 C�digo de servi�o
            PadRight('COBRANCA', 15, ' ')                       + // 012 a 026 Literal servi�o
            PadRight(OnlyNumber(Beneficiario.CNPJCPF), 14, ' ') + // 027 a 040 CNPJ da empresa
            Space(6)                                            + // 041 a 046 C�digo da empresa
            PadRight(Beneficiario.Nome, 30, ' ')                + // 047 a 076 Nome da empresa
            IntToStrZero(ACBrBanco.Numero, 3)                   + // 077 a 079 N�mero do Bs2 na c�mara de compensa��o
            PadRight('BS2', 15, ' ')                            + // 080 a 094 Nome do banco por extenso
            FormatDateTime('ddmmyyyy', Now)                     + // 095 a 102 Data da grava��o do arquivo
            IntToStrZero(0, 9)                                  + // 103 a 111 Zeros
            IntToStrZero(0, 8)                                  + // 112 a 119 Zeros
            PadLeft(DensidadeGravacao,3,'0')                    + // 120 a 122 Par�metro de Movimento
            Space(164)                                          + // 123 a 286 Branco
            PadLeft(IntToStr(LayoutVersaoArquivo), 3, '0')      + // 287 a 289 Vers�o Layout
            Space(100)                                          + // 290 a 389 Branco
            IntToStrZero(fNumeroRemessa, 5) +                     // 390 a 394 N�mero sequencial do arquivo  //'00001'
            '000001';                                             // 395 a 400 N�mero sequencial do registro

  ARemessa.Text := ARemessa.Text
                   + UpperCase(wLinha);

end;

procedure TACBrBancoBS2.GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; ARemessa: TStringList);
var
  ATipoSacado, ATipoSacadoAvalista, ADataMoraJuros, ADataDesconto, wLinha,
  wCarteira, codigoServico,LTipoMulta, LValorMultaFixo,LValorMultaPercentual,LChaveNFe, LTipoEmissaoPostagem : string;
begin

  { Data Mora }
  ADataMoraJuros := DefineDataMoraJuros(ACBrTitulo, 'ddmmyy');

  // descontos
  if (ACBrTitulo.ValorDesconto > 0) and (ACBrTitulo.DataDesconto <> Null) then
    ADataDesconto := FormatDateTime('ddmmyy', ACBrTitulo.DataDesconto)
  else
    ADataDesconto := PadLeft('', 6, '0');

  // tipo S
  case ACBrTitulo.Sacado.SacadoAvalista.Pessoa of
    pFisica   : ATipoSacadoAvalista := '1';
    pJuridica : ATipoSacadoAvalista := '2';
  end;
  if ACBrTitulo.Sacado.SacadoAvalista.CNPJCPF = '' then
    ATipoSacadoAvalista := '0';

  // tipo de sacado
  case ACBrTitulo.Sacado.Pessoa of
    pFisica   : ATipoSacado := '01';
    pJuridica : ATipoSacado := '02';
  else
    ATipoSacado := '99';
  end;

  if (ACBrTitulo.ValorDesconto > 0) then
    ADataDesconto := FormatDateTime('ddmmyyyy', ACBrTitulo.DataDesconto)
  else
    ADataDesconto := PadRight('', 8, '0');

  wCarteira := Trim(ACBrTitulo.Carteira);
  case ACBrTitulo.OcorrenciaOriginal.Tipo of
    toRemessaRegistrar : codigoServico := '01';
    toRemessaBaixar    : codigoServico := '09';
    else codigoServico := '01';
  end;

  if ACBrTitulo.MultaValorFixo then
  begin
    LTipoMulta            := '1';
    LValorMultaFixo       := IntToStrZero(round(ACBrTitulo.PercentualMulta * 100), 12);
    LValorMultaPercentual := IntToStrZero(0, 4);
  end else
  begin
    LTipoMulta            := '2';
    LValorMultaFixo       := IntToStrZero(0, 12);
    LValorMultaPercentual := IntToStrZero(round(ACBrTitulo.PercentualMulta * 100), 4);
  end;

  if ACBrTitulo.ACBrBoleto.Cedente.ResponEmissao = tbCliEmite then
    LTipoEmissaoPostagem := 'N'
  else
    LTipoEmissaoPostagem := 'M';

 wLinha := '1'                                                                                     + // 001 a 001 Identifica��o do registro de transa��o
            PadLeft('', 10, '0')                                                                   + // 002 a 011 Zeros
            Space(5)                                                                               + // 012 a 016 Branco
            ATipoSacadoAvalista                                                                    + // 017 a 017 Tipo de inscri��o Sacador/Avalista
            PadLeft(OnlyNumber(ACBrTitulo.Sacado.SacadoAvalista.CNPJCPF), 14, '0')                 + // 018 a 031 documento do sacado avalista
            Space(3)                                                                               + // 032 a 034 Branco
            PadRight(ACBrTitulo.SeuNumero, 25, ' ')                                                + // 035 a 059 N�mero de controle para uso da empresa.
            MontarCampoNossoNumero(ACBrTitulo)                                                     + // 060 a 070 Nosso numero
            PadLeft(ACBrBanco.ACBrBoleto.Cedente.CodigoCedente, 10, '0')                           + // 071 a 080 N�mero de Contrato
            Space(10)                                                                              + // 081 a 090 Branco
            LTipoMulta                                                                             + // 091 a 091 Tipo da Multa
            LValorMultaFixo                                                                        + // 092 a 103 Valor de Multa Fixo
            LValorMultaPercentual                                                                  + // 104 a 107 Valor de Multa Percentual
            PadLeft(wCarteira,2,'0')                                                               + // 108 a 109 C�digo da carteira - �21� cobran�a Simples
            codigoServico                                                                          + // 110 a 111 C�digo do servi�o 01 - Entrada / 09 - Baixa
            PadRight(ACBrTitulo.NumeroDocumento, 10, ' ')                                          + // 112 a 121 Seu numero
            FormatDateTime('ddmmyyyy', ACBrTitulo.Vencimento)                                      + // 122 a 129 Data do vencimento do t�tulo
            IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 13)                               + // 130 a 142 Valor do t�tulo
            Space(5)                                                                               + // 143 a 147 Branco
            IfThen(LayoutVersaoArquivo > 1, LTipoEmissaoPostagem,'0')                                               + // 148 a 148 Zero
            EspecieDocumentoToIndex(ACBrTitulo.EspecieDoc)                                         + // 149 a 149 Especie do documento
            IfThen(ACBrTitulo.Aceite = atSim,'A','N')                                              + // 150 a 150 Aceite (Envia "N" Padrao)
            FormatDateTime('ddmmyyyy', ACBrTitulo.DataDocumento)                                   + // 151 a 158 Data de emissao do t�tulo
            Space(2)                                                                               + // 159 a 160 Brancos
            '0'                                                                                    + // 161 a 161 Zero
            IntToStrZero(round(ACBrTitulo.ValorMoraJuros * 100), 12)                               + // 162 a 173 Percentual a ser cobrado juros/mora
            ADataDesconto                                                                          + // 174 a 181 Data limite descont
            IntToStrZero(Round(ACBrTitulo.ValorDesconto * 100), 13)                                + // 182 a 194 Valor do desconto
            IfThen(LayoutVersaoArquivo > 1, PadLeft(' ',11),
                   IntToStrZero(round(ACBrTitulo.PercentualMulta * 100),
              11))                                                                                 + // 195 a 205 Valor da multa
            IfThen(LayoutVersaoArquivo > 1, IntToStrZero(round(ACBrTitulo.ValorAbatimento * 100), 13),
              FormatDateTime('ddmmyyyy', ACBrTitulo.DataLimitePagto) + PadLeft('', 5, '0') )       + // 206 a 213 Data limite pagamento + // 214 a 218 Zeros
            ATipoSacado                                                                            + // 219 a 220 Identifica��o do tipo de inscri��o do pagador
            PadLeft(OnlyNumber(ACBrTitulo.Sacado.CNPJCPF), 14, '0')                                + // 221 a 234 N� Inscri��o do pagador
            PadRight(TiraAcentos(ACBrTitulo.Sacado.NomeSacado), 40, ' ')                           + // 235 a 274 Nome do pagador
            PadRight(TiraAcentos(ACBrTitulo.Sacado.Logradouro), 40, ' ')                           + // 275 a 314 Endereco
            PadRight(TiraAcentos(ACBrTitulo.Sacado.Bairro), 12, ' ')                               + // 315 a 326 Bairro
            PadRight(TiraAcentos(OnlyNumber(ACBrTitulo.Sacado.CEP)), 8, ' ')                       + // 327 a 334 CEP
            PadRight(TiraAcentos(ACBrTitulo.Sacado.Cidade), 15, ' ')                               + // 335 a 349 Cidade
            PadRight(TiraAcentos(ACBrTitulo.Sacado.UF), 2, ' ')                                    + // 350 a 351 UF
            PadRight(TiraAcentos(ACBrTitulo.Sacado.NomeSacado), 40, ' ')                           + // 352 a 391 Nome do avalista
            PadLeft('', 2, '0')                                                                    + // 392 a 393 Zeros
            '0'                                                                                    + // 394 a 394 Codigo moeda 0 Real
            IntToStrZero(ARemessa.Count + 1, 6);                                                     // 395 a 400 N� sequencial do registro

  ARemessa.Text := ARemessa.Text + UpperCase(wLinha);

  if wCarteira = '41' then
  begin       //(OBRIGAT�RIO, CASO A CARTEIRA SEJA VINCULADA 41)
    {Chave da NFe}
    if ACBrTitulo.ListaDadosNFe.Count > 0 then
      LChaveNFe := ACBrTitulo.ListaDadosNFe[0].ChaveNFe
    else
      LChaveNFe := '';
    wLinha := '2'                                                                                  + // 001 a 001 C�digo do Registro
              PadRight(ACBrTitulo.Sacado.Email,120,' ')                                            + // 002 a 121 Email do Sacado
              Space(229)                                                                           + // 112 a 350 Brancos
              PadLeft(LChaveNFe, 44, '0')                                                          + // 351 a 394 Chave da NF-e - Em caso de NF de Servico (normalmente 9 posicoes) completar com zeros a esquerda
              IntToStrZero(ARemessa.Count + 1, 6);
    ARemessa.Text := ARemessa.Text + UpperCase(wLinha);
  end;
end;

function TACBrBancoBS2.GetLocalPagamento: String;
begin
  Result := ACBrStr('Pag�vel em qualquer banco, mesmo ap�s vencimento');
end;

procedure TACBrBancoBS2.GerarRegistroTrailler400(ARemessa: TStringList);
var
  wLinha: string;
begin

  wLinha := '9'                                 +  // 001 a 001 Identifica��o registro
            Space(393)                          +  // 002 a 394 Branco
            IntToStrZero(ARemessa.Count + 1, 6);   // 395 a 400 N�mero sequencial de registro

  ARemessa.Text := ARemessa.Text + UpperCase(wLinha);

end;

procedure TACBrBancoBS2.LerRetorno240(ARetorno: TStringList);
begin
  raise Exception.Create( ACBrStr('N�o permitido para o layout deste banco.') );
end;

procedure TACBrBancoBS2.LerRetorno400(ARetorno: TStringList);
var
  ContLinha: Integer;
  Linha, rCedente: string;
  Titulo: TACBrTitulo;
  Boleto : TACBrBoleto;
begin
  Boleto := ACBrBanco.ACBrBoleto;

  if (StrToIntDef(copy(ARetorno.Strings[0], 77, 3), -1) <> Numero) then
    raise Exception.create(ACBrStr(Boleto.NomeArqRetorno + 'n�o � um arquivo de retorno do ' + Nome));

  rCedente := trim(Copy(ARetorno[0], 47, 30));

  Boleto.DataArquivo := StringToDateTimeDef(
                          Copy(ARetorno[0], 95, 2)
                        + '/'
                        + Copy(ARetorno[0], 97, 2)
                        + '/'
                        + Copy(ARetorno[0], 99, 4), 0, 'DD/MM/YYYY');

  Boleto.ListadeBoletos.Clear;

  for ContLinha := 1 to ARetorno.Count - 2 do
  begin
    Linha := ARetorno[ContLinha];

    if (Copy(Linha, 1, 1) <> '1') then
      Continue;

    Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

    Titulo.SeuNumero               := trim(copy(Linha, 120, 10));
    Titulo.NumeroDocumento         := trim(copy(Linha, 120, 10));
    Titulo.NossoNumero             := Copy(Linha, 60, 11);

    Titulo.Carteira                := copy(Linha, 108, 2);
    Titulo.OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(copy(Linha, 110, 2), 0));
    Titulo.EspecieDoc              := EspecieDocumentoToStr(copy(Linha, 175, 1));

    Titulo.ValorDocumento          := StrToFloatDef(Copy(Linha, 154, 13), 0) / 100;
    Titulo.ValorRecebido           := StrToFloatDef(Copy(Linha, 253, 13), 0) / 100;

    Titulo.DataOcorrencia          := StringToDateTimeDef(Copy(Linha, 112, 2)
                                    + '/'
                                    + Copy(Linha, 114, 2)
                                    + '/'
                                    + Copy(Linha, 116, 4), 0, 'DD/MM/YYYY');

    if (StrToIntDef(Copy(Linha, 146, 8), 0) <> 0) then
      Titulo.Vencimento := StringToDateTimeDef(Copy(Linha, 146, 2)
                                               + '/'
                                               + Copy(Linha, 148, 2)
                                               + '/'
                                               + Copy(Linha, 150, 4), 0, 'DD/MM/YYYY');

    if (StrToIntDef(Copy(Linha, 81, 8), 0) <> 0) then
      Titulo.DataCredito := StringToDateTimeDef(Copy(Linha, 81, 2)
                                                + '/'
                                                + Copy(Linha, 83, 2)
                                                + '/'
                                                + Copy(Linha, 85, 4), 0, 'DD/MM/YYYY');
  end;
end;

function TACBrBancoBS2.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): string;
var
  CodOcorrencia: Integer;
begin
  Result := '';
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia), 0);

  if (Result <> '') then
    Exit;

  case CodOcorrencia of
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    06: Result := '06-Liquida��o Normal';
    07: Result := '07-Baixa Simples';
  end;
end;

function TACBrBancoBS2.CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    09: Result := toRetornoBaixaManualConfirmada;
    10: Result := toRetornoBaixaAutomatica;
    99: Result := toRetornoInstrucaoRejeitada; //REJETADA
    else
      Result := toTipoOcorrenciaNenhum;
  end;
end;

function TACBrBancoBS2.TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): string;
begin
  Result := '';
  case TipoOcorrencia of
    toRetornoLiquidadoParcialmente                       : Result := '07';
    toRetornoBaixaCreditoCCAtravesSispag                 : Result := '59';
    toRetornoEntradaConfirmadaRateioCredito              : Result := '64';
    toRetornoChequePendenteCompensacao                   : Result := '65';
    toRetornoChequeDevolvido                             : Result := '69';
    toRetornoEntradaRegistradaAguardandoAvaliacao        : Result := '71';
    toRetornoBaixaCreditoCCAtravesSispagSemTituloCorresp : Result := '72';
    toRetornoConfirmacaoEntradaCobrancaSimples           : Result := '73';
    toRetornoChequeCompensado                            : Result := '76';
  end;

  if (Result <> '') then
    begin
      Exit;
    end;

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

function TACBrBancoBS2.CalcularDigitoVerificador(
  const ACBrTitulo: TACBrTitulo): String;
begin
   Modulo.CalculoPadrao;
   Modulo.Documento := ACBrTitulo.NossoNumero;
   Modulo.Calcular;

   if (Modulo.ModuloFinal = 0) or (Modulo.ModuloFinal = 1) then
     if fpLayoutVersaoArquivo >= 6 then
       Result:= '0'
     else
       Result:= '1'
   else
      Result:= IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoBS2.CalcularNomeArquivoRemessa: string;
var Boleto : TACBrBoleto;
  Sequencia :Integer;
  LNomeRemessa : String;
begin
  Sequencia := 0;
  Boleto := ACBrBanco.ACBrBoleto;

  if Boleto.NomeArqRemessa = '' then
  begin
     repeat
       LNomeRemessa :=   'BS2_REM_'
                         + FormatDateTime('ddmmyyyy', Now)
                         + '_'
                         + IntToStrZero( Sequencia, 2 )
                         + '.rem';

        Inc( Sequencia );
     until not FileExists( Boleto.DirArqRemessa + PathDelim + LNomeRemessa ) ;
     Result := Boleto.DirArqRemessa + PathDelim + LNomeRemessa;
  end
  else
     Result := Boleto.DirArqRemessa + PathDelim + Boleto.NomeArqRemessa;

end;

function TACBrBancoBS2.CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia;
  CodMotivo: Integer): string;
begin
  case TipoOcorrencia of
    // tabela 1
    toRetornoRegistroRecusado,
    toRetornoEntradaRejeitadaCarne:
      case CodMotivo of
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
        21: Result := 'AG. COBRADORA - CARTEIRA N�O ACEITA DEPOSIT�RIA CORRESPONDENTE/'
                      + 'ESTADO DA AG�NCIA DIFERENTE DO ESTADO DO SACADO/' + 'AG. COBRADORA N�O CONSTA NO CADASTRO OU ENCERRANDO';
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
          Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      end;

    // tabela 2
    toRetornoAlteracaoDadosRejeitados:
      case CodMotivo of
        02: Result := 'AG�NCIA COBRADORA INV�LIDA OU COM O MESMO CONTE�DO';
        04: Result := 'SIGLA DO ESTADO INV�LIDA';
        05: Result := 'DATA DE VENCIMENTO INV�LIDA OU COM O MESMO CONTE�DO';
        06: Result := 'VALOR DO T�TULO COM OUTRA ALTERA��O SIMULT�NEA';
        08: Result := 'NOME DO SACADO COM O MESMO CONTE�DO';
        09: Result := 'AG�NCIA/CONTA INCORRETA';
        11: Result := 'CEP INV�LIDO';
        13: Result := 'SEU N�MERO COM O MESMO CONTE�DO';
        16: Result := 'ABATIMENTO/ALTERA��O DO VALOR DO T�TULO OU SOLICITA��O DE BAIXA BLOQUEADA';
        21: Result := 'AG�NCIA COBRADORA N�O CONSTA NO CADASTRO DE DEPOSIT�RIA OU EM ENCERRAMENTO';
        53: Result := 'INSTRU��O COM O MESMO CONTE�DO';
        54: Result := 'DATA VENCIMENTO PARA BANCOS CORRESPONDENTES INFERIOR AO ACEITO PELO BANCO';
        55: Result := 'ALTERA��ES IGUAIS PARA O MESMO CONTROLE (AG�NCIA/CONTA/CARTEIRA/NOSSO N�MERO)';
        56: Result := 'CGC/CPF INV�LIDO N�O NUM�RICO OU ZERADO';
        57: Result := 'PRAZO DE VENCIMENTO INFERIOR A 15 DIAS';
        60: Result := 'VALOR DE IOF - ALTERA��O N�O PERMITIDA PARA CARTEIRAS DE N.S. - MOEDA VARI�VEL';
        61: Result := 'T�TULO J� BAIXADO OU LIQUIDADO OU N�O EXISTE T�TULO CORRESPONDENTE NO SISTEMA';
        66: Result := 'ALTERA��O N�O PERMITIDA PARA CARTEIRAS DE NOTAS DE SEGUROS - MOEDA VARI�VEL';
        81: Result := 'ALTERA��O BLOQUEADA - T�TULO COM PROTESTO';
        else
          Result := IntToStrZero(CodMotivo, 2)
                    + ' - Outros Motivos';
      end;

    // tabela 3
    toRetornoInstrucaoRejeitada:
      case CodMotivo of
        01: Result := 'INSTRU��O/OCORR�NCIA N�O EXISTENTE';
        06: Result := 'NOSSO N�MERO IGUAL A ZEROS';
        09: Result := 'CGC/CPF DO SACADOR/AVALISTA INV�LIDO';
        10: Result := 'VALOR DO ABATIMENTO IGUAL OU MAIOR QUE O VALOR DO T�TULO';
        14: Result := 'REGISTRO EM DUPLICIDADE';
        15: Result := 'CGC/CPF INFORMADO SEM NOME DO SACADOR/AVALISTA';
        21: Result := 'T�TULO N�O REGISTRADO NO SISTEMA';
        22: Result := 'T�TULO BAIXADO OU LIQUIDADO';
        23: Result := 'INSTRU��O N�O ACEITA POR TER SIDO EMITIDO �LTIMO AVISO AO SACADO';
        24: Result := 'INSTRU��O INCOMPAT�VEL - EXISTE INSTRU��O DE PROTESTO PARA O T�TULO';
        25: Result := 'INSTRU��O INCOMPAT�VEL - N�O EXISTE INSTRU��O DE PROTESTO PARA O T�TULO';
        26: Result := 'INSTRU��O N�O ACEITA POR TER SIDO EMITIDO �LTIMO AVISO AO SACADO';
        27: Result := 'INSTRU��O N�O ACEITA POR N�O TER SIDO EMITIDA A ORDEM DE PROTESTO AO CART�RIO';
        28: Result := 'J� EXISTE UMA MESMA INSTRU��O CADASTRADA ANTERIORMENTE PARA O T�TULO';
        29: Result := 'VALOR L�QUIDO + VALOR DO ABATIMENTO DIFERENTE DO VALOR DO T�TULO REGISTRADO, OU VALOR'
                    + 'DO ABATIMENTO MAIOR QUE 90% DO VALOR DO T�TULO';
        30: Result := 'EXISTE UMA INSTRU��O DE N�O PROTESTAR ATIVA PARA O T�TULO';
        31: Result := 'EXISTE UMA OCORR�NCIA DO SACADO QUE BLOQUEIA A INSTRU��O';
        32: Result := 'DEPOSIT�RIA DO T�TULO = 9999 OU CARTEIRA N�O ACEITA PROTESTO';
        33: Result := 'ALTERA��O DE VENCIMENTO IGUAL � REGISTRADA NO SISTEMA OU QUE TORNA O T�TULO VENCIDO';
        34: Result := 'INSTRU��O DE EMISS�O DE AVISO DE COBRAN�A PARA T�TULO VENCIDO ANTES DO VENCIMENTO';
        35: Result := 'SOLICITA��O DE CANCELAMENTO DE INSTRU��O INEXISTENTE';
        36: Result := 'T�TULO SOFRENDO ALTERA��O DE CONTROLE (AG�NCIA/CONTA/CARTEIRA/NOSSO N�MERO)';
        37: Result := 'INSTRU��O N�O PERMITIDA PARA A CARTEIRA';
        else
          Result := IntToStrZero(CodMotivo, 2)
                    + ' - Outros Motivos';
      end;

    // tabela 4
    toRetornoBaixaRejeitada:
      case CodMotivo of
        01: Result := 'CARTEIRA/N� N�MERO N�O NUM�RICO';
        04: Result := 'NOSSO N�MERO EM DUPLICIDADE NUM MESMO MOVIMENTO';
        05: Result := 'SOLICITA��O DE BAIXA PARA T�TULO J� BAIXADO OU LIQUIDADO';
        06: Result := 'SOLICITA��O DE BAIXA PARA T�TULO N�O REGISTRADO NO SISTEMA';
        07: Result := 'COBRAN�A PRAZO CURTO - SOLICITA��O DE BAIXA P/ T�TULO N�O REGISTRADO NO SISTEMA';
        08: Result := 'SOLICITA��O DE BAIXA PARA T�TULO EM FLOATING';
        else
          Result := IntToStrZero(CodMotivo, 2)
                    + ' - Outros Motivos';
      end;

    // tabela 5
    toRetornoCobrancaContratual:
      case CodMotivo of
        16: Result := 'ABATIMENTO/ALTERA��O DO VALOR DO T�TULO OU SOLICITA��O DE BAIXA BLOQUEADOS';
        40: Result := 'N�O APROVADA DEVIDO AO IMPACTO NA ELEGIBILIDADE DE GARANTIAS';
        41: Result := 'AUTOMATICAMENTE REJEITADA';
        42: Result := 'CONFIRMA RECEBIMENTO DE INSTRU��O � PENDENTE DE AN�LISE';
        else
          Result := IntToStrZero(CodMotivo, 2)
                    + ' - Outros Motivos';
      end;

    // tabela 6
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
        else
          Result := IntToStrZero(CodMotivo, 2)
                    + ' - Outros Motivos';
      end;

    // tabela 7
    toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente:
      case CodMotivo of
        1610: Result := 'DOCUMENTA��O SOLICITADA AO CEDENTE';
        3111: Result := 'SUSTA��O SOLICITADA AG. CEDENTE';
        3228: Result := 'ATOS DA CORREGEDORIA ESTADUAL';
        3244: Result := 'PROTESTO SUSTADO / CEDENTE N�O ENTREGOU A DOCUMENTA��O';
        3269: Result := 'DATA DE EMISS�O DO T�TULO INV�LIDA/IRREGULAR';
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
        else
          Result := IntToStrZero(CodMotivo, 2)
                    + ' - Outros Motivos';
      end;

    // tabela 8
    toRetornoInstrucaoCancelada:
      case CodMotivo of
        1156: Result := 'N�O PROTESTAR';
        2261: Result := 'DISPENSAR JUROS/COMISS�O DE PERMAN�NCIA';
        else
          Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      end;

    // tabela 9
    toRetornoChequeDevolvido:
      case CodMotivo of
        11: Result := 'CHEQUE SEM FUNDOS - PRIMEIRA APRESENTA��O - PASS�VEL DE REAPRESENTA��O: SIM';
        12: Result := 'CHEQUE SEM FUNDOS - SEGUNDA APRESENTA��O - PASS�VEL DE REAPRESENTA��O: N�O ';
        13: Result := 'CONTA ENCERRADA - PASS�VEL DE REAPRESENTA��O: N�O';
        14: Result := 'PR�TICA ESP�RIA - PASS�VEL DE REAPRESENTA��O: N�O';
        20: Result := 'FOLHA DE CHEQUE CANCELADA POR SOLICITA��O DO CORRENTISTA - PASS�VEL DE REAPRESENTA��O: N�O';
        21: Result := 'CONTRA-ORDEM (OU REVOGA��O) OU OPOSI��O (OU SUSTA��O) AO PAGAMENTO PELO EMITENTE OU PELO '
                      + 'PORTADOR - PASS�VEL DE REAPRESENTA��O: SIM';
        22: Result := 'DIVERG�NCIA OU INSUFICI�NCIA DE ASSINATURAb - PASS�VEL DE REAPRESENTA��O: SIM';
        23: Result := 'CHEQUES EMITIDOS POR ENTIDADES E �RG�OS DA ADMINISTRA��O P�BLICA FEDERAL DIRETA E INDIRETA, '
                      + 'EM DESACORDO COM OS REQUISITOS CONSTANTES DO ARTIGO 74, � 2�, DO DECRETO-LEI N� 200, DE 25.02.1967. - '
                      + 'PASS�VEL DE REAPRESENTA��O: SIM';
        24: Result := 'BLOQUEIO JUDICIAL OU DETERMINA��O DO BANCO CENTRAL DO BRASIL - PASS�VEL DE REAPRESENTA��O: SIM';
        25: Result := 'CANCELAMENTO DE TALON�RIO PELO BANCO SACADO - PASS�VEL DE REAPRESENTA��O: N�O';
        28: Result := 'CONTRA-ORDEM (OU REVOGA��O) OU OPOSI��O (OU SUSTA��O) AO PAGAMENTO OCASIONADA POR FURTO OU ROUBO - '
                      + 'PASS�VEL DE REAPRESENTA��O: N�O';
        29: Result := 'CHEQUE BLOQUEADO POR FALTA DE CONFIRMA��O DO RECEBIMENTO DO TALON�RIO PELO CORRENTISTA - '
                      + 'PASS�VEL DE REAPRESENTA��O: SIM';
        30: Result := 'FURTO OU ROUBO DE MALOTES - PASS�VEL DE REAPRESENTA��O: N�O';
        31: Result := 'ERRO FORMAL (SEM DATA DE EMISS�O, COM O M�S GRAFADO NUMERICAMENTE, AUS�NCIA DE ASSINATURA, '
                      + 'N�O-REGISTRO DO VALOR POR EXTENSO) - PASS�VEL DE REAPRESENTA��O: SIM';
        32: Result := 'AUS�NCIA OU IRREGULARIDADE NA APLICA��O DO CARIMBO DE COMPENSA��O - PASS�VEL DE REAPRESENTA��O: SIM';
        33: Result := 'DIVERG�NCIA DE ENDOSSO - PASS�VEL DE REAPRESENTA��O: SIM';
        34: Result := 'CHEQUE APRESENTADO POR ESTABELECIMENTO BANC�RIO QUE N�O O INDICADO NO CRUZAMENTO EM PRETO, SEM O '
                      + 'ENDOSSO-MANDATO - PASS�VEL DE REAPRESENTA��O: SIM';
        35: Result := 'CHEQUE FRAUDADO, EMITIDO SEM PR�VIO CONTROLE OU RESPONSABILIDADE DO ESTABELECIMENTO BANC�RIO '
                      + '("CHEQUE UNIVERSAL"), OU AINDA COM ADULTERA��O DA PRA�A SACADA - PASS�VEL DE REAPRESENTA��O: N�O';
        36: Result := 'CHEQUE EMITIDO COM MAIS DE UM ENDOSSO - PASS�VEL DE REAPRESENTA��O: SIM';
        40: Result := 'MOEDA INV�LIDA - PASS�VEL DE REAPRESENTA��O: N�O';
        41: Result := 'CHEQUE APRESENTADO A BANCO QUE N�O O SACADO - PASS�VEL DE REAPRESENTA��O: SIM';
        42: Result := 'CHEQUE N�O-COMPENS�VEL NA SESS�O OU SISTEMA DE COMPENSA��O EM QUE FOI APRESENTADO - '
                      + 'PASS�VEL DE REAPRESENTA��O: SIM';
        43: Result := 'CHEQUE, DEVOLVIDO ANTERIORMENTE PELOS MOTIVOS 21, 22, 23, 24, 31 OU 34, N�O-PASS�VEL '
                      + 'DE REAPRESENTA��O EM VIRTUDE DE PERSISTIR O MOTIVO DA DEVOLU��O - PASS�VEL DE REAPRESENTA��O: N�O';
        44: Result := 'CHEQUE PRESCRITO - PASS�VEL DE REAPRESENTA��O: N�O';
        45: Result := 'CHEQUE EMITIDO POR ENTIDADE OBRIGADA A REALIZAR MOVIMENTA��O E UTILIZA��O DE RECURSOS FINANCEIROS '
                      + 'DO TESOURO NACIONAL MEDIANTE ORDEM BANC�RIA - PASS�VEL DE REAPRESENTA��O: N�O';
        48: Result := 'CHEQUE DE VALOR SUPERIOR AO ESTABELECIDO, EMITIDO SEM A IDENTIFICA��O DO BENEFICI�RIO, DEVENDO SER '
                      + 'DEVOLVIDO A QUALQUER TEMPO - PASS�VEL DE REAPRESENTA��O: SIM';
        49: Result := 'REMESSA NULA, CARACTERIZADA PELA REAPRESENTA��O DE CHEQUE DEVOLVIDO PELOS MOTIVOS 12, 13, 14, 20, '
                      + '25, 28, 30, 35, 43, 44 E 45, PODENDO A SUA DEVOLU��O OCORRER A QUALQUER TEMPO - PASS�VEL DE REAPRESENTA��O: N�O';
        else
          Result := IntToStrZero(CodMotivo, 2)
                    + ' - Outros Motivos';
      end;

    // tabela 10
    toRetornoRegistroConfirmado:
      case CodMotivo of
        01: Result := 'CEP SEM ATENDIMENTO DE PROTESTO NO MOMENTO';
        else
          Result := IntToStrZero(CodMotivo, 2)
                    + ' - Outros Motivos';
      end;
    else
      Result := IntToStrZero(CodMotivo, 2)
                + ' - Outros Motivos';
  end;
end;

function TACBrBancoBS2.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02: Result := toRemessaBaixar; { Pedido de Baixa }
    04: Result := toRemessaConcederAbatimento; { Concess�o de Abatimento }
    05: Result := toRemessaCancelarAbatimento; { Cancelamento de Abatimento concedido }
    06: Result := toRemessaAlterarVencimento; { Altera��o de vencimento }
    07: Result := toRemessaAlterarUsoEmpresa; { Altera��o do uso Da Empresa }
    08: Result := toRemessaAlterarSeuNumero; { Altera��o do seu N�mero }
    09: Result := toRemessaProtestar; { Protestar (emite aviso ao sacado ap�s xx dias do vencimento, e envia ao cart�rio ap�s 5 dias �teis) }
    10: Result := toRemessaCancelarInstrucaoProtesto; { Sustar Protesto }
    11: Result := toRemessaProtestoFinsFalimentares; { Protesto para fins Falimentares }
    18: Result := toRemessaCancelarInstrucaoProtestoBaixa; { Sustar protesto e baixar }
    30: Result := toRemessaExcluirSacadorAvalista; { Exclus�o de Sacador Avalista }
    31: Result := toRemessaOutrasAlteracoes; { Altera��o de Outros Dados }
    34: Result := toRemessaBaixaporPagtoDiretoCedente; { Baixa por ter sido pago Diretamente ao Cedente }
    35: Result := toRemessaCancelarInstrucao; { Cancelamento de Instru��o }
    37: Result := toRemessaAlterarVencimentoSustarProtesto; { Altera��o do Vencimento e Sustar Protesto }
    38: Result := toRemessaCedenteDiscordaSacado; { Cedente n�o Concorda com Alega��o do Sacado }
    47: Result := toRemessaCedenteSolicitaDispensaJuros; { Cedente Solicita Dispensa de Juros }
    else
      Result := toRemessaRegistrar; { Remessa }
  end;
end;

end.
