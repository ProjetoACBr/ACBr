{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andre Adami                                     }
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

unit ACBrBALWeightechWT3000IR_ABS_Fm1Fm2Fm9;

interface

uses
  Classes;

type

  TStatusPesagem = (spNaoDetectado, spEstavel, spInstavel, spSobrecarga, spSobrecargaNegativa);
  TInformacaoPeso = (ipNaoDetectado, ipPesoBruto, ipPesoLiquido, ipTara);
  TInformacaoSinalPeso = (sipNaoDetectado, sipPositivo, sipNegativo);

  (*
    Classe com l�gica para interpretar formatos de mensagens Fm1, Fm2 e Fm9
    da balan�a Weightech WT3000IR_ABS.
  *)
  TFormatoFm1Fm2Fm9Util = class
  private
    class function TratarResposta(const aResposta: AnsiString): AnsiString;

    class function ExtrairSinalPeso(const aResposta: AnsiString): TInformacaoSinalPeso;
    class function ExtrairInformacaoPeso(const aResposta: AnsiString): TInformacaoPeso;
    class function ExtrairStatusPesagem(const aResposta: AnsiString): TStatusPesagem;

    class function DetectarFormatoTransmissao(const aResposta: AnsiString): Boolean;
  public
    class function InterpretarResposta(const aResposta: AnsiString; out aPesoLido: Double): Boolean;
  end;

implementation

Uses
  SysUtils, Math,
  ACBrConsts, ACBrUtil.Strings,
  {$IFDEF COMPILER6_UP}
   DateUtils, StrUtils
  {$ELSE}
   ACBrD5, Windows
  {$ENDIF};

const
  (*
    Ref.: https://www.weightech.com.br/indicador-de-pesagem-wt3000-ir-abs
    Constantes para os dados (manual de integra��o p�g.: 21)

    Formato de mensagem:
    S T , G S , + SP SP 3 0 0 . 0 0 SP SP k g CR LF
  *)

  INFORMACAO_PESO_BRUTO = 'GS';
  INFORMACAO_PESO_LIQUIDO = 'NT';
  INFORMACAO_TARA = 'TR';

  STATUS_PESAGEM_ESTAVEL = 'ST';
  STATUS_PESAGEM_INSTAVEL = 'US';
  STATUS_PESAGEM_EM_OVER_LOAD = 'OL';

  INDEX_INICIO_INFORMACAO_PESO = 4;
  TAMANHO_INFORMACAO_PESO = 2;

  INDEX_INICIO_STATUS_PESAGEM = 1;
  TAMANHO_STATUS_PESAGEM = 2;

  INDEX_INICIO_SINAL_PESO = 7;
  TAMANHO_SINAL_PESO = 1;

  INDEX_INICIO_PESO = 8;
  TAMANHO_PESO = 8;

  INDEX_INICIO_PACOTE_DADOS_PESAGEM = 1;
  TAMANHO_PACOTE_DADOS_PESAGEM = 19;

{ ACBrBALWeightechWT3000IR_ABS_Fm1Fm2Fm9 }

class function TFormatoFm1Fm2Fm9Util.DetectarFormatoTransmissao(const aResposta: AnsiString): Boolean;
begin
  Result := (Length(aResposta) = TAMANHO_PACOTE_DADOS_PESAGEM) and
  (ExtrairStatusPesagem(aResposta) <> spNaoDetectado) and
  (ExtrairInformacaoPeso(aResposta) <> ipNaoDetectado) and
  (ExtrairSinalPeso(aResposta) <> sipNaoDetectado);
end;

class function TFormatoFm1Fm2Fm9Util.ExtrairInformacaoPeso(
  const aResposta: AnsiString): TInformacaoPeso;
var
  vInformacaoPeso: AnsiString;
begin
  Result := ipNaoDetectado;

  vInformacaoPeso := Copy(aResposta, INDEX_INICIO_INFORMACAO_PESO, TAMANHO_INFORMACAO_PESO);
  case AnsiIndexText(vInformacaoPeso, [INFORMACAO_PESO_BRUTO, INFORMACAO_PESO_LIQUIDO, INFORMACAO_TARA]) of
    0: Result := ipPesoBruto;
    1: Result := ipPesoLiquido;
    2: Result := ipTara;
  end;
end;

class function TFormatoFm1Fm2Fm9Util.ExtrairSinalPeso(const aResposta: AnsiString): TInformacaoSinalPeso;
begin
  Result := sipNaoDetectado;

  case AnsiIndexText(Copy(aResposta, INDEX_INICIO_SINAL_PESO, TAMANHO_SINAL_PESO), ['+', '-']) of
    0: Result := sipPositivo;
    1: Result := sipNegativo;
  end;
end;

class function TFormatoFm1Fm2Fm9Util.ExtrairStatusPesagem(const aResposta: AnsiString): TStatusPesagem;
var
  vStatusPesagem: AnsiString;
begin
  Result := spNaoDetectado;

  vStatusPesagem := Copy(aResposta, INDEX_INICIO_STATUS_PESAGEM, TAMANHO_STATUS_PESAGEM);
  case AnsiIndexText(vStatusPesagem, [STATUS_PESAGEM_ESTAVEL, STATUS_PESAGEM_INSTAVEL, STATUS_PESAGEM_EM_OVER_LOAD]) of
    0: Result := spEstavel;
    1: Result := spInstavel;
    2:
    begin
      Result := spSobrecarga;

      if ExtrairSinalPeso(aResposta) = sipNegativo then
        Result := spSobrecargaNegativa;
    end;
  end;
end;

class function TFormatoFm1Fm2Fm9Util.InterpretarResposta(const aResposta: AnsiString; out aPesoLido: Double): Boolean;
var
  vTempResposta: AnsiString;
begin
  Result := False;
  aPesoLido := -9; // Por padr�o, timeout

  vTempResposta := TratarResposta(aResposta);

  if not DetectarFormatoTransmissao(vTempResposta) then
    Exit;

  case ExtrairStatusPesagem(vTempResposta) of
    spEstavel:
    begin
      { Ajustando o separador de Decimal corretamente }
      vTempResposta := trim(StringReplace(vTempResposta, '.', DecimalSeparator, [rfReplaceAll]));
      vTempResposta := trim(StringReplace(vTempResposta, ',', DecimalSeparator, [rfReplaceAll]));

      aPesoLido := StrToFloatDef(copy(vTempResposta, INDEX_INICIO_PESO, TAMANHO_PESO), 0); // { ST - Est�vel }
    end;
    spInstavel: aPesoLido := -1; { US - Inst�vel }
    spSobrecarga: aPesoLido := -10; { OL - Sobrecarga }
    spSobrecargaNegativa: aPesoLido := -2; { OL - Sobrecarga negativa/Peso negativo }
  end;

  Result := True;
end;

class function TFormatoFm1Fm2Fm9Util.TratarResposta(const aResposta: AnsiString): AnsiString;
var
  vPacotesDadosPesagens: TSplitResult; // ACBrUtil.Strings
  vLengthPacotesDadosPesagens: Integer;
begin
  Result := Trim(aResposta);
  vLengthPacotesDadosPesagens := 0;

  if Length(aResposta) < TAMANHO_PACOTE_DADOS_PESAGEM then
    Exit;

  {
    Se resposta em modo de transmiss�o cont�nuo:
    - Separar mensagens conforme o delimitador LF (Line Feed).
    - Pegar a quantidade de mensagens e ler a �ltima do grupo.

    Exemplo:
    ST,GS,+    3000  kgCRLF
    ST,GS,+    3000  kgCRLF
    ST,GS,+    3000  kgCRLF
    ST,GS,+    3000  kgCRLF
  }
  if Pos(LF, Result) > 0 then // ACBrConsts
  begin
    vPacotesDadosPesagens := Split(LF, Result); // ACBrUtil.Strings
    vLengthPacotesDadosPesagens := Length(vPacotesDadosPesagens);

    // Pegar �ltima resposta do grupo
    Result := vPacotesDadosPesagens[vLengthPacotesDadosPesagens - 1];
  end;

  Result := Copy(Result, INDEX_INICIO_PACOTE_DADOS_PESAGEM, TAMANHO_PACOTE_DADOS_PESAGEM);
end;

end.
