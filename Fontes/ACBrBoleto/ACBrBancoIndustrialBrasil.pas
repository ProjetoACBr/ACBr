{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor H Gonzales - Pandaaa                     }
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
//Incluido em: 30/06/2023

{$I ACBr.inc}
unit ACBrBancoIndustrialBrasil;

interface

uses
  Classes,
  SysUtils,
  Contnrs,
  ACBrBoleto,
  ACBrBoletoConversao;

type
  { TACBrBancoIndustrialBrasil }
  TACBrBancoIndustrialBrasil = class(TACBrBancoClass)
  protected
    function GetLocalPagamento: String; override;
  private
    procedure MontarRegistroMensagem400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
    procedure MontarRegistroBeneficiarioFinal400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
    procedure GerarRegistrosNFe(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
    function DefineCarteira(const ACBrTitulo: TACBrTitulo): String;
  protected
    function DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;
  public
    constructor Create(AOwner: TACBrBanco);
    function CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string; override;
    procedure GerarRegistroHeader400(NumeroRemessa: Integer; aRemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa: TStringList); override;
    procedure LerRetorno400(ARetorno: TStringList); override;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): string; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; const CodMotivo: String): String; override;
  end;

implementation

uses
  ACBrValidador,
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  StrUtils,
  Variants,
  DateUtils,
  ACBrUtil.Strings;

constructor TACBrBancoIndustrialBrasil.Create(AOwner: TACBrBanco);
begin
  inherited Create(AOwner);
  fpNome                  := 'BCO INDUSTRIAL';
  fpNumero                := 604;
  fpDigito                := 1;
  fpTamanhoMaximoNossoNum := 10;
  fpTamanhoAgencia        := 4;
  fpTamanhoConta          := 7;
  fpTamanhoCarteira       := 3;
end;

function TACBrBancoIndustrialBrasil.CalcularDigitoVerificador(
  const ACBrTitulo: TACBrTitulo): string;
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

function TACBrBancoIndustrialBrasil.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string;
var
  NossoNr, DV: string;
begin
  if not((ACBrTitulo.Carteira = '121') or (ACBrTitulo.Carteira = '110')) then
    raise Exception.Create( ACBrStr('Carteira Inv�lida.'+sLineBreak+'Utilize "121 ou 110"') ) ;

  NossoNr := PadLeft(ACBrTitulo.NossoNumero, 10, '0');
  DV := CalcularDigitoVerificador(ACBrTitulo);
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia
    + ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito
    + '/' + ACBrTitulo.Carteira
    + '/' + NossoNr
    + '-' + DV;
end;

function TACBrBancoIndustrialBrasil.MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string;
begin
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia
    + ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito
    + '/'
    + ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente;
end;

procedure TACBrBancoIndustrialBrasil.GerarRegistroHeader400(NumeroRemessa: Integer;
  aRemessa: TStringList);
var
  LLinha: string;
  Beneficiario: TACBrCedente;
begin
  Beneficiario := ACBrBanco.ACBrBoleto.Cedente;

  LLinha := '0'                                             + // 001-001 Identifica��o do registro
  '1'                                                       + // 002-002 Identifica��o do arquivo remessa
  'REMESSA'                                                 + // 003-009 Literal remessa
  '01'                                                      + // 010-011 C�digo de servi�o
  PadRight('COBRANCA', 15, ' ')                             + // 012-026 Literal servi�o
  PadRight(Beneficiario.CodigoCedente, 20, ' ')             + // 027-046 C�digo da empresa
  PadRight(Beneficiario.Nome, 30, ' ')                      + // 047-076 Nome da empresa M�e
  IntToStrZero(ACBrBanco.Numero, 3)                         + // 077-079 N�mero do BIB na c�mara de compensa��o CIP
  PadRight(ACBrBanco.Nome, 15, ' ')                         + // 080-094 Nome do banco por extenso
  FormatDateTime('ddmmyy', Now)                             + // 095-100 Data da grava��o do arquivo
  Space(294)                                                + // 101-394 Brancos
  '000001';                                                   // 395-400 N� sequencial do registro

  ARemessa.Add(UpperCase(LLinha));
end;

procedure TACBrBancoIndustrialBrasil.GerarRegistroTransacao400(
  ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
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
    else
      LValorMulta := 0;
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
     PadRight(Beneficiario.CodigoCedente, 20, ' ')                   + // 018-037 Identifica��o da empresa no BIB
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
    //MontarRegistroMensagem400(ACBrTitulo, aRemessa); // existe no manual mas a valida��o banc�ria
                                                       // pediu para remover pois h� erro,
                                                       // que eles n�o usam esse bloco no sistema deles
    if ACBrTitulo.ListaDadosNFe.Count > 0 then
      GerarRegistrosNFe(ACBrTitulo, aRemessa);
  end;
end;

procedure TACBrBancoIndustrialBrasil.GerarRegistroTrailler400(
  ARemessa: TStringList);
var
  LLinha: string;
begin
  LLinha := '9'                                   + // 001-001 Identifica��o registro
  Space(393)                                      + // 002-394 Branco
  IntToStrZero(ARemessa.Count + 1, 6);              // 395-400 N�mero sequencial de registro

  ARemessa.Add(UpperCase(LLinha));
end;

procedure TACBrBancoIndustrialBrasil.MontarRegistroBeneficiarioFinal400(
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

procedure TACBrBancoIndustrialBrasil.MontarRegistroMensagem400(
  ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
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

procedure TACBrBancoIndustrialBrasil.LerRetorno400(ARetorno: TStringList);
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


function TACBrBancoIndustrialBrasil.CodMotivoRejeicaoToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia; const CodMotivo: String): String;
begin

  case TipoOcorrencia of
      toRetornoRegistroRecusado: // Ocorrencia 03
        begin
          case StrtoIntDef(CodMotivo, -1) of
            -1:
              begin
                  if CodMotivo = 'AA' Then result := 'AA - Servi�o de cobran�a inv�lido'
                  else if CodMotivo = 'AB' Then result := 'AB - Servi�o de "0" ou "5" e banco cobrador <> zeros'
                  else if CodMotivo = 'AE' Then result := 'AE - T�tulo n�o possui abatimento'
                  else if CodMotivo = 'AG' Then result := 'AG - Movto n�o permitido para t�tulo � Vista/Contra Apresenta��o'
                  else if CodMotivo = 'AH' Then result := 'AH - Cancelamento de Valores Inv�lidos'
                  else if CodMotivo = 'AI' Then result := 'AI - Nossa carteira inv�lida'
                  else if CodMotivo = 'AJ' Then result := 'AJ - Modalidade com bancos correspondentes inv�lida'
                  else if CodMotivo = 'AK' Then result := 'AK - T�tulo pertence a outro cliente'
                  else if CodMotivo = 'AL' Then result := 'AL - Sacado impedido de entrar nesta cobran�a'
                  else if CodMotivo = 'AT' Then result := 'AT - Valor Pago Inv�lido'
                  else if CodMotivo = 'AU' Then result := 'AU - Data da ocorr�ncia inv�lida'
                  else if CodMotivo = 'AV' Then result := 'AV - Valor da tarifa de cobran�a inv�lida'
                  else if CodMotivo = 'AX' Then result := 'AX - T�tulo em pagamento parcial'
                  else if CodMotivo = 'AY' Then result := 'AY - T�tulo em Aberto e Vencido para acatar protestol'
                  else if CodMotivo = 'BA' Then result := 'BA - Banco Correspondente Recebedor n�o � o Cobrador Atual'
                  else if CodMotivo = 'BB' Then result := 'BB - T�tulo deve estar em cart�rio para baixar'
                  else if CodMotivo = 'BC' Then result := 'BC - An�lise gerencial-sacado inv�lido p/opera��o cr�dito'
                  else if CodMotivo = 'BD' Then result := 'BD - An�lise gerencial-sacado inadimplente'
                  else if CodMotivo = 'BE' Then result := 'BE - An�lise gerencial-sacado difere do exigido'
                  else if CodMotivo = 'BF' Then result := 'BF - An�lise gerencial-vencto excede vencto da opera��o de cr�dito'
                  else if CodMotivo = 'BG' Then result := 'BG - An�lise gerencial-sacado com baixa liquidez'
                  else if CodMotivo = 'BH' Then result := 'BH - An�lise gerencial-sacado excede concentra��o'
                  else if CodMotivo = 'CC' Then result := 'CC - Valor de iof incompat�vel com a esp�cie documento'
                  else if CodMotivo = 'CD' Then result := 'CD - Efetiva��o de protesto sem agenda v�lida'
                  else if CodMotivo = 'CE' Then result := 'CE - T�tulo n�o aceito - pessoa f�sica'
                  else if CodMotivo = 'CF' Then result := 'CF - Excede prazo m�ximo da entrada ao vencimento'
                  else if CodMotivo = 'CG' Then result := 'CG - T�tulo n�o aceito � por an�lise gerencial'
                  else if CodMotivo = 'CH' Then result := 'CH - T�tulo em espera � em an�lise pelo banco'
                  else if CodMotivo = 'CJ' Then result := 'CJ - An�lise gerencial-vencto do titulo abaixo przcurto'
                  else if CodMotivo = 'CK' Then result := 'CK - An�lise gerencial-vencto do titulo abaixo przlongo'
                  else if CodMotivo = 'CS' Then result := 'CS - T�tulo rejeitado pela checagem de duplicatas'
                  else if CodMotivo = 'DA' Then result := 'DA - An�lise gerencial � Entrada de T�tulo Descontado com limite cancelado'
                  else if CodMotivo = 'DB' Then result := 'DB - An�lise gerencial � Entrada de T�tulo Descontado com limite vencido'
                  else if CodMotivo = 'DC' Then result := 'DC - An�lise gerencial - cedente com limite cancelado'
                  else if CodMotivo = 'DD' Then result := 'DD - An�lise gerencial � cedente � sacado e teve seu limite cancelado'
                  else if CodMotivo = 'DE' Then result := 'DE - An�lise gerencial - apontamento no Serasa'
                  else if CodMotivo = 'DG' Then result := 'DG - Endere�o sacador/avalista n�o informado'
                  else if CodMotivo = 'DH' Then result := 'DH - Cep do sacador/avalista n�o informado'
                  else if CodMotivo = 'DI' Then result := 'DI - Cidade do sacador/avalista n�o informado'
                  else if CodMotivo = 'DJ' Then result := 'DJ - Estado do sacador/avalista inv�lido ou n informado'
                  else if CodMotivo = 'DM' Then result := 'DM - Cliente sem C�digo de Flash cadastrado no cobrador'
                  else if CodMotivo = 'DN' Then result := 'DN - T�tulo Descontado com Prazo ZERO � Recusado'
                  else if CodMotivo = 'DP' Then result := 'DP - Data de Refer�ncia menor que a Data de Emiss�o do T�tulo'
                  else if CodMotivo = 'DT' Then result := 'DT - Nosso N�mero do Correspondente n�o deve ser informado'
                  else if CodMotivo = 'EB' Then result := 'EB - HSBC n�o aceita endere�o de sacado com mais de 38 caracteres'
                  else if CodMotivo = 'G1' Then result := 'G1 - Endere�o do sacador incompleto ( lei 12.039)'
                  else if CodMotivo = 'G2' Then result := 'G2 - Sacador impedido de movimentar'
                  else if CodMotivo = 'G3' Then result := 'G3 - Concentra��o de cep n�o permitida'
                  else if CodMotivo = 'G4' Then result := 'G4 - Valor do t�tulo n�o permitido'
                  else if CodMotivo = 'HA' Then result := 'HA - Servi�o e Modalidade Incompat�veis'
                  else if CodMotivo = 'HB' Then result := 'HB - Inconsist�ncias entre Registros T�tulo e Sacador'
                  else if CodMotivo = 'HC' Then result := 'HC - Ocorr�ncia n�o dispon�vel'
                  else if CodMotivo = 'HD' Then result := 'HD - T�tulo com Aceite'
                  else if CodMotivo = 'HF' Then result := 'HF - Baixa Liquidez do Sacado'
                  else if CodMotivo = 'HG' Then result := 'HG - Sacado Informou que n�o paga Boletos'
                  else if CodMotivo = 'HH' Then result := 'HH - Sacado n�o confirmou a Nota Fiscal'
                  else if CodMotivo = 'HI' Then result := 'HI - Checagem Pr�via n�o Efetuada'
                  else if CodMotivo = 'HJ' Then result := 'HJ - Sacado desconhece compra e Nota Fiscal'
                  else if CodMotivo = 'HK' Then result := 'HK - Compra e Nota Fiscal canceladas pelo sacado'
                  else if CodMotivo = 'HL' Then result := 'HL - Concentra��o al�m do permitido pela �rea de Cr�dito'
                  else if CodMotivo = 'HM' Then result := 'HM - Vencimento acima do permitido pelo �rea de Cr�dito'
                  else if CodMotivo = 'HN' Then result := 'HN - Excede o prazo limite da opera��o'
                  else if CodMotivo = 'IX' Then result := 'IX - T�tulo de Cart�o de Cr�dito n�o aceita instru��es'
                  else if CodMotivo = 'JB' Then result := 'JB - T�tulo de Cart�o de Cr�dito inv�lido para o Produto'
                  else if CodMotivo = 'JC' Then result := 'JC - Produto somente para Cart�o de Cr�dito'
                  else if CodMotivo = 'JH' Then result := 'JH - CB Direta com opera��o de Desconto Autom�tico'
                  else if CodMotivo = 'JI' Then result := 'JI - Esp�cie de Documento incompat�vel para produto de Cart�o de Cr�dito'
                  else Result := PadLeft(CodMotivo,2,'0') + ' - Outros motivos';
                end;
            03: result := '03 - CEP inv�lido � N�o temos cobrador � Cobrador n�o Localizado';
            04: result := '04 - Sigla do Estado inv�lida';
            05: result := '05 - Data de Vencimento inv�lida ou fora do prazo m�nimo';
            06: result := '06 - C�digo do Banco inv�lido';
            08: result := '08 - Nome do sacado n�o informado';
            10: result := '10 - Logradouro n�o informado';
            14: result := '14 - Registro em duplicidade';
            19: result := '19 - Data de desconto inv�lida ou maior que a data de vencimento';
            20: result := '20 - Valor de IOF n�o num�rico';
            21: result := '21 - Movimento para t�tulo n�o cadastrado no sistema';
            22: result := '22 - Valor de desconto + abatimento maior que o valor do t�tulo';
            23: result := '25 - CNPJ ou CPF do sacado inv�lido (aceito com restri��es)';
            26: result := '26 - Esp�cie de documento inv�lida';
            27: result := '27 - Data de emiss�o do t�tulo inv�lida';
            28: result := '28 - Seu n�mero n�o informado';
            29: result := '29 - CEP � igual a espa�o ou zeros; ou n�o num�rico';
            30: result := '30 - Valor do t�tulo n�o num�rico ou inv�lido';
            36: result := '36 - Valor de perman�ncia (mora) n�o num�rico ';
            37: result := '37 - Valor de perman�ncia inconsistente, pois, dentro de um m�s, ser� maior que o valor do t�tulo';
            38: result := '38 - Valor de desconto/abatimento n�o num�rico ou inv�lido';
            39: result := '39 - Valor de abatimento n�o num�rico';
            42: result := '42 - T�tulo j� existente em nossos registros. Nosso n�mero n�o aceito ';
            43: result := '43 - T�tulo enviado em duplicidade nesse movimento';
            44: result := '44 - T�tulo zerado ou em branco; ou n�o num�rico na remessa';
            46: result := '46 - T�tulo enviado fora da faixa de Nosso N�mero, es1ipulada para o cliente.';
            51: result := '51 - Tipo/N�mero de Inscri��o Sacador/Avalista Inv�lido';
            52: result := '52 - Sacador/Avalista n�o informado';
            53: result := '53 - Prazo de vencimento do t�tulo excede ao da contrata��o';
            54: result := '54 - Banco informado n�o � nosso correspondente 140-142';
            55: result := '55 - Banco correspondente informado n�o cobra este CEP ou n�o possui faixas de CEP cadastradas';
            56: result := '56 - Nosso n�mero no correspondente n�o foi informado';
            57: result := '57 - Remessa contendo duas instru��es incompat�veis � n�o protestar e dias de protesto ou prazo para protesto inv�lido.';
            58: result := '58 - Entradas Rejeitadas � Reprovado no Represamento para An�lise';
            60: result := '60 - CNPJ/CPF do sacado inv�lido � t�tulo recusado';
            87: result := '87 - Excede Prazo m�ximo entre emiss�o e vencimento';
          else
              Result := PadLeft(CodMotivo,2,'0') + ' - Outros motivos';
          end;
        end;
      toRetornoBaixaRejeitada: // ocorrencia 15
        begin
           case StrtoIntDef(CodMotivo, 0) of
             05: result := '05 - Solicita��o de baixa para t�tulo j� baixado ou liquidado';
             06: result := '06 - Solicita��o de baixa para t�tulo n�o registrado no sistema';
             08: result := '08 - Solicita��o de baixa para t�tulo em float';
             else
             Result := PadLeft(CodMotivo,2,'0') + ' - Outros motivos';
           end;
        end;
      toRetornoInstrucaoRejeitada: // ocorr�ncia16
        begin
          case StrtoIntDef(CodMotivo, -1) of
             -1: begin
               if CodMotivo = 'AA' Then result := 'AA - Servi�o de cobran�a inv�lido'
               else if CodMotivo = 'AE' Then result := 'AE - T�tulo n�o possui abatimento'
               else if CodMotivo = 'AG' Then result := 'AG - Movimento n�o permitido � T�tulo � vista ou contra apresenta��o'
               else if CodMotivo = 'AH' Then result := 'AH - Cancelamento de valores inv�lidos'
               else if CodMotivo = 'AI' Then result := 'AI - Nossa carteira inv�lida'
               else if CodMotivo = 'AK' Then result := 'AK - T�tulo pertence a outro cliente'
               else if CodMotivo = 'AU' Then result := 'AU - Data da ocorr�ncia inv�lida'
               else if CodMotivo = 'AY' Then result := 'AY - T�tulo deve estar em aberto e vencido para acatar protesto'
               else if CodMotivo = 'CB' Then result := 'CB - T�tulo possui protesto efetivado/a efetivar hoje'
               else if CodMotivo = 'CT' Then result := 'CT - T�tulo j� baixado'
               else if CodMotivo = 'CW' Then result := 'CW - T�tulo j� transferido'
               else if CodMotivo = 'DO' Then result := 'DO - T�tulo em Preju�zo'
               else if CodMotivo = 'JK' Then result := 'JK - Produto n�o permite altera��o de valor de t�tulo'
               else if CodMotivo = 'JQ' Then result := 'JQ - T�tulo em Correspondente � N�o alterar Valor'
               else if CodMotivo = 'JS' Then result := 'JS - T�tulo possui Descontos/Abto/Mora/Multa'
               else if CodMotivo = 'JT' Then result := 'JT - T�tulo possui Agenda de Protesto/Devolu��o'
               else Result := PadLeft(CodMotivo,2,'0') + ' - Outros motivos';

             end;
             04: result := '04 - Data de vencimento n�o num�rica ou inv�lida';
             05: result := '05 - Data de Vencimento inv�lida ou fora do prazo m�nimo';
             14: result := '14 - Registro em duplicidade';
             19: result := '19 - Data de desconto inv�lida ou maior que a data de vencimento';
             20: result := '20 - Campo livre n�o informado';
             21: result := '21 - T�tulo n�o registrado no sistema';
             22: result := '22 - T�tulo baixado ou liquidado';
             26: result := '26 - Esp�cie de documento inv�lida';
             27: result := '27 - Instru��o n�o aceita, por n�o ter sido emitida ordem de protesto ao cart�rio';
             28: result := '28 - T�tulo tem instru��o de cart�rio ativa';
             29: result := '29 - T�tulo n�o tem instru��o de carteira ativa';
             30: result := '30 - Existe instru��o de n�o protestar, ativa para o t�tulo';
             36: result := '36 - Valor de perman�ncia (mora) n�o num�rico';
             37: result := '37 - T�tulo Descontado � Instru��o n�o permitida para a carteira';
             38: result := '38 - Valor do abatimento n�o num�rico ou maior que a soma do valor do t�tulo perman�ncia + multa';
             39: result := '39 - T�tulo em cart�rio';
             40: result := '40 - Instru��o recusada � Reprovado no Represamento para An�lise';
             44: result := '44 - T�tulo zerado ou em branco; ou n�o num�rico na remessa';
             51: result := '51 - Tipo/N�mero de Inscri��o Sacador/Avalista Inv�lido';
             53: result := '53 - Prazo de vencimento do t�tulo excede ao da contrata��o';
             57: result := '57 - Remessa contendo duas instru��es incompat�veis � n�o protestar e dias de protesto ou prazo para protesto inv�lido';
             else
             Result := PadLeft(CodMotivo,2,'0') + ' - Outros motivos';

          end;
        end;
  end;
end;


function TACBrBancoIndustrialBrasil.CodOcorrenciaToTipo(
  const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    01: Result := toRetornoEntradaConfirmadaNaCip;
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    05: Result := toRetornoDadosAlterados;
    06: Result := toRetornoLiquidado;
    08: Result := toRetornoLiquidadoEmCartorio;
    09: Result := toRetornoBaixaAutomatica;
    10: Result := toRetornoBaixaPorTerSidoLiquidado;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoBaixaRejeitada;
    16: Result := toRetornoInstrucaoRejeitada;
    19: Result := toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente;
    20: Result := toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente;
    22: Result := toRetornoAlteracaoSeuNumero;
    23: Result := toRetornoEncaminhadoACartorio;
    24: Result := toRetornoRecebimentoInstrucaoNaoProtestar;
    40: Result := toRetornoDebitoTarifas;
    43: Result := toRetornoBaixaPorProtesto;
    96: Result := toRetornoDebitoMensalTarifasOutrasInstrucoes;
    97: Result := toRetornoDebitoMensalTarifasOutrasInstrucoes;
    98: Result := toRetornoDebitoMensalTarifasOutrasInstrucoes;
    99: Result := toRetornoDebitoMensalTarifasSustacaoProtestos;
  else
    Result := toTipoOcorrenciaNenhum;
  end;
end;

function TACBrBancoIndustrialBrasil.TipoOcorrenciaToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia): string;
begin
  case TipoOcorrencia of
    toRetornoEntradaConfirmadaNaCip                      : Result := '01-Confirma Entrada T�tulo na CIP';
    toRetornoRegistroConfirmado                          : Result := '02�Entrada Confirmada';
    toRetornoRegistroRecusado                            : Result := '03�Entrada Rejeitada';
    toRetornoDadosAlterados                              : Result := '05-Campo Livre Alterado';
    toRetornoLiquidado                                   : Result := '06-Liquida��o Normal';
    toRetornoLiquidadoEmCartorio                         : Result := '08-Liquida��o em Cart�rio';
    toRetornoBaixaAutomatica                             : Result := '09-Baixa Autom�tica';
    toRetornoBaixaPorTerSidoLiquidado                    : Result := '10-Baixa por ter sido liquidado';
    toRetornoAbatimentoConcedido                         : Result := '12-Confirma Abatimento';
    toRetornoAbatimentoCancelado                         : Result := '13-Abatimento Cancelado';
    toRetornoVencimentoAlterado                          : Result := '14-Vencimento Alterado';
    toRetornoBaixaRejeitada                              : Result := '15-Baixa Rejeitada';
    toRetornoInstrucaoRejeitada                          : Result := '16-Instru��o Rejeitadas';
    toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente : Result := '19-Confirma Recebimento de Ordem de Protesto';
    toRetornoAlteracaoSeuNumero                          : Result := '22-Seu n�mero alterado';
    toRetornoEncaminhadoACartorio                        : Result := '23-T�tulo enviado para cart�rio';
    toRetornoRecebimentoInstrucaoNaoProtestar            : Result := '24-Confirma recebimento de ordem de n�o protestar';
    toRetornoDebitoTarifas                               : Result := '40-Tarifa de Entrada (debitada na Liquida��o)';
    toRetornoBaixaPorProtesto                            : Result := '43-Baixado por ter sido protestado';
    toRetornoDebitoMensalTarifasOutrasInstrucoes         : Result := '96, 97 e 98-Tarifas - M�s Anterior';
    toRetornoDebitoMensalTarifasSustacaoProtestos        : Result := '99-Tarifa Sobre Instru��es de Protesto/Susta��o � M�s Anterior';
  else
    Result := 'Outras ocorr�ncias';
  end;
end;

function TACBrBancoIndustrialBrasil.GetLocalPagamento: String;
begin
  Result := ACBrStr(CInstrucaoPagamentoRegistro);
end;

procedure TACBrBancoIndustrialBrasil.GerarRegistrosNFe(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
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

function TACBrBancoIndustrialBrasil.DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String;
begin

  Result :=
   PadLeft(ACBrTitulo.ACBrBoleto.Cedente.Agencia, 4, '0')
   + PadLeft(DefineCarteira(ACBrTitulo), 3, '0')
   + PadLeft(ACBrTitulo.ACBrBoleto.Cedente.Operacao, 7, '0')
   + PadLeft(ACBrTitulo.NossoNumero, 10, '0')
   + CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoIndustrialBrasil.DefineCarteira(const ACBrTitulo: TACBrTitulo): String;
var LCarteira : String;
begin
  LCarteira := ACBrTitulo.Carteira;
  if (LCarteira = 'D') or (LCarteira = '4') then
    Result := '110'
  else if LCarteira = '6' then
    Result := '121'
  else
    Result := ACBrTitulo.Carteira;
end;

end.

