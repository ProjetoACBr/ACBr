{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2026 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

unit ACBrTEFTXTGerenciadorPadrao;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils,
  ACBrTEFComum, ACBrTEFTXTComum;

const
  CACBRTEFTXT_NomeGerenciadorPadrao = 'Gerenciador Padrão';
  CACBRTEFTXT_CMD_ATV = 'ATV';
  CACBRTEFTXT_CMD_ADM = 'ADM';
  CACBRTEFTXT_CMD_CHQ = 'CHQ';
  CACBRTEFTXT_CMD_CRT = 'CRT';
  CACBRTEFTXT_CMD_CNC = 'CNC';
  CACBRTEFTXT_CMD_CNF = 'CNF';
  CACBRTEFTXT_CMD_NCN = 'NCN';

type

  { TACBrTEFRespTXT }

  { TACBrTEFRespTXTGerenciadorPadrao }

  TACBrTEFRespTXTGerenciadorPadrao = class( TACBrTEFResp )
  protected
    function AjustaLinhaImagemComprovante(const ALinha: String): String;
  public
    procedure ConteudoToProperty; override;
  end;

  { TACBrTEFTXTGerenciadorPadrao }

  TACBrTEFTXTGerenciadorPadrao = class( TACBrTEFTXTBaseClass )
  private
    fEnviarATV: Boolean;
  protected
    function RespostaTransacaoComSucesso: Boolean;
    function GetModeloTEF: String; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure PrepararRequisicao(const AHeader: String); override;
    procedure ATV;
    function ADM: Boolean;
    function CRT(Valor: Double; const DocumentoVinculado: String = ''; Moeda: Integer = 0): Boolean;
    function CHQ(Valor: Double; const DocumentoVinculado: String = '';
      CMC7: String = ''; TipoPessoa: AnsiChar = 'F'; DocumentoPessoa: String = '';
      DataCheque: TDateTime = 0; Banco: String = '';
      Agencia: String = ''; AgenciaDC : String = '';
      Conta: String = ''; ContaDC: String = '';
      Cheque: String = ''; ChequeDC: String = '';
      Compensacao: String = '' ): Boolean;
    Function CNC(Valor: Double; const Rede, NSU: String; DataHoraTransacao: TDateTime; DocumentoVinculado: String = ''): Boolean;
    Procedure CNF(const Rede, NSU, Finalizacao: String; DocumentoVinculado: String = '');
    Procedure NCN(const Rede, NSU, Finalizacao: String; Valor: Double = 0; const DocumentoVinculado: String = '') ;

    property Enviar_ATV_Antes: Boolean read fEnviarATV write fEnviarATV default True;
  end;


implementation

uses
  DateUtils,
  ACBrUtil.Strings;

{ TACBrTEFRespTXTGerenciadorPadrao }

function TACBrTEFRespTXTGerenciadorPadrao.AjustaLinhaImagemComprovante(const ALinha: String): String;
var
  l: Integer;
begin
  Result := ALinha;
  if copy(Result, 1, 1) = '"' then
    Delete(Result, 1, 1);
  l := Length(Result);
  if copy(Result, l, 1) = '"' then
    Delete(Result, l, 1);
end;

procedure TACBrTEFRespTXTGerenciadorPadrao.ConteudoToProperty;
var
  i: Integer;
  Linha: TACBrTEFLinha;
  lin: String;
  Parc: TACBrTEFRespParcela;
begin
  fpDataHoraTransacaoComprovante := 0 ;
  fpImagemComprovante1aVia.Clear;
  fpImagemComprovante2aVia.Clear;

  for i := 0 to Conteudo.Count-1 do
  begin
    Linha := Conteudo.Linha[i];
    case Linha.Identificacao of
      0: fpHeader := Linha.Informacao.AsString;
      1: fpID := Linha.Informacao.AsInteger;
      2: fpDocumentoVinculado := Linha.Informacao.AsString;
      3: fpValorTotal := Linha.Informacao.AsFloat;
      4: fpMoeda := Linha.Informacao.AsInteger;
      5: fpCMC7 := Linha.Informacao.AsString;
      6: fpTipoPessoa := AnsiChar(PadRight(Linha.Informacao.AsString, 1 )[ 1 ]);
      7: fpDocumentoPessoa := Linha.Informacao.AsString;
      8: fpDataCheque := Linha.Informacao.AsDate;
      9: fpStatusTransacao := Linha.Informacao.AsString;
      10: fpRede := Linha.Informacao.AsString;
      11: fpTipoTransacao := Linha.Informacao.AsInteger;
      12: fpNSU := Linha.Informacao.AsString;
      13: fpCodigoAutorizacaoTransacao := Linha.Informacao.AsString;
      14: fpNumeroLoteTransacao := Linha.Informacao.AsInteger;
      15: fpDataHoraTransacaoHost := Linha.Informacao.AsTimeStamp;
      16: fpDataHoraTransacaoLocal := Linha.Informacao.AsTimeStamp;
      17: fpTipoParcelamento := Linha.Informacao.AsInteger;
      18: fpQtdParcelas := Linha.Informacao.AsInteger;
      22: fpDataHoraTransacaoComprovante := fpDataHoraTransacaoComprovante + Linha.Informacao.AsDate;
      23: fpDataHoraTransacaoComprovante := fpDataHoraTransacaoComprovante + Linha.Informacao.AsTime;
      24: fpDataPreDatado := Linha.Informacao.AsDate;
      25: fpNSUTransacaoCancelada := Linha.Informacao.AsString;
      26: fpDataHoraTransacaoCancelada := Linha.Informacao.AsTimeStamp;
      27: fpFinalizacao := Linha.Informacao.AsString;
      28: fpQtdLinhasComprovante := Linha.Informacao.AsInteger;
      30: fpTextoEspecialOperador := ACBrStr(Linha.Informacao.AsString);
      31: fpTextoEspecialCliente := ACBrStr(Linha.Informacao.AsString);
      32: fpAutenticacao := Linha.Informacao.AsString;
      33: fpBanco := Linha.Informacao.AsString;
      34: fpAgencia := Linha.Informacao.AsString;
      35: fpAgenciaDC := Linha.Informacao.AsString;
      36: fpConta := Linha.Informacao.AsString;
      37: fpContaDC := Linha.Informacao.AsString;
      38: fpCheque := Linha.Informacao.AsString;
      39: fpChequeDC  := Linha.Informacao.AsString;
      40: fpNomeAdministradora := Linha.Informacao.AsString;
      999: fpTrailer := Linha.Informacao.AsString ;
    else
      ProcessarTipoInterno(Linha);
    end;
  end ;

  // Processando as Vias dos Comprovantes //
  if (fpQtdLinhasComprovante > 0) then
  begin
    i := 1;
    while (i <= fpQtdLinhasComprovante) do
    begin
      lin := LeInformacao(29 , i).AsString;
      fpImagemComprovante1aVia.Add( AjustaLinhaImagemComprovante(lin) );
      Inc(i);
    end;

    fpImagemComprovante2aVia.Text := fpImagemComprovante1aVia.Text;
  end;

  case fpTipoParcelamento  of
    0: fpParceladoPor := parcLoja;
    1: fpParceladoPor := parcADM;
  else
    fpParceladoPor := parcNenhum;
  end;

  fpConfirmar := (fpQtdLinhasComprovante > 0);
  fpSucesso := (fpStatusTransacao = '0');

  fpParcelas.Clear;
  for I := 1 to fpQtdParcelas do
  begin
    Parc := TACBrTEFRespParcela.create;
    Parc.Vencimento := LeInformacao(19 , i).AsDate ;
    Parc.Valor := LeInformacao(20 , i).AsFloat ;
    Parc.NSUParcela := LeInformacao(21 , i).AsString ;
    fpParcelas.Add(Parc);
  end;

  // Tipo da transação se foi Crédito ou Débito
  fpDebito := ((fpTipoTransacao >= 20) and (fpTipoTransacao <= 25)) or (fpTipoTransacao = 40);
  fpCredito := (fpTipoTransacao >= 10) and (fpTipoTransacao <= 12) ;

  case fpTipoTransacao of
    10,20,23:
      fpTipoOperacao := opAvista;
    11,12,22:
      fpTipoOperacao := opParcelado;
    21,24,25:
      begin
        fpTipoOperacao := opPreDatado;
        fpDataPreDatado := LeInformacao(24).AsDate;
      end;
    40:
      begin
        fpTipoOperacao := opParcelado;
        fpParceladoPor := parcADM;
      end;
  else
    fpTipoOperacao := opOutras;
  end;
end;

{ TACBrTEFTXTGerenciadorPadrao }

constructor TACBrTEFTXTGerenciadorPadrao.Create;
begin
  inherited;
  fEnviarATV := True;
end;

destructor TACBrTEFTXTGerenciadorPadrao.Destroy;
begin
  inherited Destroy;
end;

function TACBrTEFTXTGerenciadorPadrao.RespostaTransacaoComSucesso: Boolean;
begin
  Result := (Resp.Campo[9,0].AsString = '0');
end;

function TACBrTEFTXTGerenciadorPadrao.GetModeloTEF: String;
begin
  Result := ACBrStr(CACBRTEFTXT_NomeGerenciadorPadrao);
end;

procedure TACBrTEFTXTGerenciadorPadrao.PrepararRequisicao(const AHeader: String);
begin
  if fEnviarATV and (AHeader <> CACBRTEFTXT_CMD_ATV) then
    ATV;

  inherited PrepararRequisicao(AHeader);
end;

procedure TACBrTEFTXTGerenciadorPadrao.ATV;
begin
  PrepararRequisicao(CACBRTEFTXT_CMD_ATV);
  EnviarRequisicao(False);
end;

function TACBrTEFTXTGerenciadorPadrao.ADM: Boolean;
begin
  PrepararRequisicao(CACBRTEFTXT_CMD_ADM);
  EnviarRequisicao;
  Result := RespostaTransacaoComSucesso;
end;

function TACBrTEFTXTGerenciadorPadrao.CRT(Valor: Double;
  const DocumentoVinculado: String; Moeda: Integer): Boolean;
begin
  PrepararRequisicao(CACBRTEFTXT_CMD_CRT);
  Req.Campo[2,0].AsString := DocumentoVinculado;
  Req.Campo[3,0].AsFloat := Valor;
  Req.Campo[4,0].AsInteger := Moeda;
  EnviarRequisicao;
  Result := RespostaTransacaoComSucesso;
end;

function TACBrTEFTXTGerenciadorPadrao.CHQ(Valor: Double;
  const DocumentoVinculado: String; CMC7: String; TipoPessoa: AnsiChar;
  DocumentoPessoa: String; DataCheque: TDateTime; Banco: String;
  Agencia: String; AgenciaDC: String; Conta: String; ContaDC: String;
  Cheque: String; ChequeDC: String; Compensacao: String): Boolean;
begin
  PrepararRequisicao(CACBRTEFTXT_CMD_CHQ);
  Req.Campo[02,0].AsString := DocumentoVinculado;
  Req.Campo[03,0].AsFloat := Valor;
  Req.Campo[05,0].AsString := CMC7;
  Req.Campo[06,0].AsString := TipoPessoa;
  Req.Campo[07,0].AsString := DocumentoPessoa;
  Req.Campo[08,0].AsDate := DataCheque;
  Req.Campo[33,0].AsString := Banco;
  Req.Campo[34,0].AsString := Agencia;
  Req.Campo[35,0].AsString := AgenciaDC;
  Req.Campo[36,0].AsString := Conta;
  Req.Campo[37,0].AsString := ContaDC;
  Req.Campo[38,0].AsString := Cheque;
  Req.Campo[39,0].AsString := ChequeDC;
  EnviarRequisicao;
  Result := RespostaTransacaoComSucesso;
end;

function TACBrTEFTXTGerenciadorPadrao.CNC(Valor: Double; const Rede,
  NSU: String; DataHoraTransacao: TDateTime; DocumentoVinculado: String): Boolean;
begin
  PrepararRequisicao(CACBRTEFTXT_CMD_CNC);
  Req.Campo[02,0].AsString := DocumentoVinculado;
  Req.Campo[03,0].AsFloat := Valor;
  Req.Campo[10,0].AsString := Rede;
  Req.Campo[12,0].AsString := NSU;
  Req.Campo[22,0].AsDate := DateOf(DataHoraTransacao);
  Req.Campo[23,0].AsTime := TimeOf(DataHoraTransacao);
  EnviarRequisicao;
  Result := RespostaTransacaoComSucesso;
end;

procedure TACBrTEFTXTGerenciadorPadrao.CNF(const Rede, NSU,
  Finalizacao: String; DocumentoVinculado: String);
begin
  PrepararRequisicao(CACBRTEFTXT_CMD_CNF);
  Req.Campo[02,0].AsString := DocumentoVinculado;
  Req.Campo[10,0].AsString := Rede;
  Req.Campo[12,0].AsString := NSU;
  Req.Campo[27,0].AsString := Finalizacao;
  EnviarRequisicao;
end;

procedure TACBrTEFTXTGerenciadorPadrao.NCN(const Rede, NSU,
  Finalizacao: String; Valor: Double; const DocumentoVinculado: String);
begin
  PrepararRequisicao(CACBRTEFTXT_CMD_NCN);
  Req.Campo[02,0].AsString := DocumentoVinculado;
  Req.Campo[10,0].AsString := Rede;
  Req.Campo[12,0].AsString := NSU;
  Req.Campo[27,0].AsString := Finalizacao;
  EnviarRequisicao;
end;

end.

