{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit PagFor.Itau.LerTxtRetorno;

interface

uses
  SysUtils, Classes, ACBrPagForConversao,
  CNAB240.LerTxtRetorno, ACBrPagForClass;

type
 { TArquivoR_Itau }

  TArquivoR_Itau = class(TArquivoR_CNAB240)
  protected
    procedure LerRegistro1(nLinha: Integer); override;

    procedure LerRegistro5(nLinha: Integer); override;

    procedure LerSegmentoA(nLinha: Integer); override;

    procedure LerSegmentoB(mSegmentoBList: TSegmentoBList; nLinha: Integer); override;

    procedure LerSegmentoC(mSegmentoCList: TSegmentoCList; nLinha: Integer); override;

    procedure LerSegmentoJ(nLinha: Integer; var LeuRegistroJ: boolean); override;

    procedure LerSegmentoN1(nLinha: Integer); override;

    procedure LerSegmentoN2(nLinha: Integer); override;

    procedure LerSegmentoN3(nLinha: Integer); override;

    procedure LerSegmentoN4(nLinha: Integer); override;

    procedure LerSegmentoN567(nLinha: Integer); override;

    procedure LerSegmentoN8(nLinha: Integer); override;

    procedure LerSegmentoN9(nLinha: Integer); override;

    procedure LerSegmentoO(nLinha: Integer); override;

    function GetOcorrencia(aOcorrencia: TOcorrencia): String; override;
  end;

implementation

uses
  ACBrUtil.DateTime;

{ TArquivoR_Itau }

procedure TArquivoR_Itau.LerRegistro1(nLinha: Integer);
var
  mOk: Boolean;
begin
  Linha := ArquivoTXT.Strings[nLinha];

  PagFor.Lote.New;

  with PagFor.Lote.Last.Registro1.Servico do
  begin
    Operacao := StrToTpOperacao(mOk, LerCampo(Linha, 9, 1, tcStr));
    TipoServico := StrToTpServico(mOk, LerCampo(Linha, 10, 2, tcStr));
    FormaLancamento := StrToFmLancamento(mOk, LerCampo(Linha, 12, 2, tcStr));
  end;

  with PagFor.Lote.Last.Registro1.Empresa do
  begin
    Inscricao.Tipo := StrToTpInscricao(mOk, LerCampo(Linha, 18, 1, tcStr));
    Inscricao.Numero := LerCampo(Linha, 20, 14, tcStr);
    Convenio := LerCampo(Linha, 33, 20, tcStr);

    ContaCorrente.Agencia.Codigo := LerCampo(Linha, 53, 5, tcInt);
    ContaCorrente.Agencia.DV := LerCampo(Linha, 58, 1, tcStr);
    ContaCorrente.Conta.Numero := LerCampo(Linha, 59, 12, tcInt64);
    ContaCorrente.Conta.DV := LerCampo(Linha, 71, 1, tcStr);
    ContaCorrente.DV := LerCampo(Linha, 72, 1, tcStr);

    Nome := LerCampo(Linha, 73, 30, tcStr);
  end;

  PagFor.Lote.Last.Registro1.Informacao1 := LerCampo(Linha, 103, 40, tcStr);

  case PagFor.Lote.Last.Registro1.Servico.TipoServico of
    tsConciliacaoBancaria:
      begin
        with PagFor.Lote.Last.Registro1 do
        begin
          Data := LerCampo(Linha, 143, 8, tcDat);
          Valor := LerCampo(Linha, 151, 18, tcDe2);
          Situacao := LerCampo(Linha, 169, 1, tcStr);
          Status := LerCampo(Linha, 170, 1, tcStr);
          TipoMoeda := LerCampo(Linha, 171, 3, tcStr);
          Sequencia := LerCampo(Linha, 174, 5, tcInt);
        end;
      end;
  else
    begin
      with PagFor.Lote.Last.Registro1.Endereco do
      begin
        Logradouro := LerCampo(Linha, 143, 30, tcStr);
        Numero := LerCampo(Linha, 173, 5, tcInt);
        Complemento := LerCampo(Linha, 178, 15, tcStr);
        Cidade := LerCampo(Linha, 193, 20, tcStr);
        CEP := LerCampo(Linha, 213, 8, tcInt);
        Estado := LerCampo(Linha, 221, 2, tcStr);
      end;
    end;
  end;
end;

procedure TArquivoR_Itau.LerRegistro5(nLinha: Integer);
var
  xAviso: string;
begin
  Linha := ArquivoTXT.Strings[nLinha];

  case PagFor.Lote.Last.Registro1.Servico.TipoServico of
    tsConciliacaoBancaria:
      begin
        with PagFor.Lote.Last.Registro5 do
        begin
          BloqueadoAcima24h := LerCampo(Linha, 89, 18, tcDe2);
          Limite := LerCampo(Linha, 107, 18, tcDe2);
          BloqueadoAte24h := LerCampo(Linha, 125, 18, tcDe2);
          Data := LerCampo(Linha, 143, 8, tcDat);
          Valor := LerCampo(Linha, 151, 18, tcDe2);
          Situacao := LerCampo(Linha, 169, 1, tcStr);
          Status := LerCampo(Linha, 170, 1, tcStr);
          QtdeRegistros := LerCampo(Linha, 171, 6, tcInt);
          ValorDebitos := LerCampo(Linha, 177, 18, tcDe2);
          ValorCreditos := LerCampo(Linha, 195, 18, tcDe2);
        end;
      end
  else
    begin
      with PagFor.Lote.Last.Registro5 do
      begin
        xAviso := LerCampo(Linha, 60, 1, tcStr);

        if PagFor.Lote.Last.Registro1.Servico.FormaLancamento = flPagamentoConcessionarias then
        begin
          // Contas de Concession�rias e Tributos com c�digo de barras
          Valor := LerCampo(Linha, 24, 18, tcDe2);
          QtdeMoeda := LerCampo(Linha, 42, 15, tcDe5);
        end
        else
        begin
          if (PagFor.Lote.Last.Registro1.Servico.TipoServico = tsPagamentoSalarios) or
             (xAviso <> '') then
          begin
            // fgts
            Valor := LerCampo(Linha, 24, 14, tcDe2);
            TotalOutrasEntidades := LerCampo(Linha, 38, 14, tcDe2);
            TotalValorAcrescimo := LerCampo(Linha, 52, 14, tcDe2);
            TotalValorArrecadado := LerCampo(Linha, 66, 14, tcDe2);
          end
          else
          begin
            // Pagamentos atrav�s de cheque, OP, DOC, TED e cr�dito em conta corrente
            // Liquida��o de t�tulos (bloquetos) em cobran�a no Ita� e em outros Bancos
            Valor := LerCampo(Linha, 24, 18, tcDe2);
          end;
        end;
      end;
    end;
  end;

  with PagFor.Lote.Last.Registro5 do
  begin
    CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

    GerarAvisos(CodOcorrencia, '5', '', '');
  end;
end;

procedure TArquivoR_Itau.LerSegmentoA(nLinha: Integer);
var
  mOk: Boolean;
  RegSeg: string;
  x: Integer;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if RegSeg <> '3A' then
    Exit;

  PagFor.Lote.Last.SegmentoA.New;

  with PagFor.Lote.Last.SegmentoA.Last do
  begin
    TipoMovimento := StrToTpMovimento(mOk, LerCampo(Linha, 15, 1, tcStr));
    CodMovimento := StrToInMovimento(mOk, LerCampo(Linha, 16, 2, tcStr));
    Favorecido.Camara := LerCampo(Linha, 18, 3, tcInt);
    Favorecido.Banco := StrToBanco(mOk, LerCampo(Linha, 21, 3, tcStr));

    with Favorecido do
    begin
      ContaCorrente.Agencia.Codigo := LerCampo(Linha, 24, 5, tcInt);
      ContaCorrente.Agencia.DV := LerCampo(Linha, 29, 1, tcStr);
      ContaCorrente.Conta.Numero := LerCampo(Linha, 30, 12, tcInt64);
      ContaCorrente.Conta.DV := LerCampo(Linha, 42, 1, tcStr);
      ContaCorrente.DV := LerCampo(Linha, 43, 1, tcStr);
    end;

    Favorecido.Nome := LerCampo(Linha, 44, 20, tcStr);
    Credito.SeuNumero := LerCampo(Linha, 74, 20, tcStr);
    Credito.DataPagamento := LerCampo(Linha, 94, 8, tcDat);

    with Credito do
    begin
  //    Moeda.Tipo := StrToTpMoeda(mOk, LerCampo(Linha, 102, 3, tcStr));
  //    Moeda.Qtde := LerCampo(Linha, 105, 15, tcDe5);
      ValorPagamento := LerCampo(Linha, 120, 15, tcDe2);
      NossoNumero := LerCampo(Linha, 135, 15, tcStr);
      DataReal := LerCampo(Linha, 155, 8, tcDat);
      ValorReal := LerCampo(Linha, 163, 15, tcDe2);
    end;

    Informacao2 := LerCampo(Linha, 178, 20, tcStr);
    NumeroDocumento := LerCampo(Linha, 198, 6, tcInt);

    Favorecido.Inscricao.Numero := LerCampo(Linha, 204, 14, tcStr);

    CodigoDOC := LerCampo(Linha, 218, 2, tcStr);
    CodigoTED := LerCampo(Linha, 220, 5, tcStr);
    Aviso := LerCampo(Linha, 230, 1, tcInt);
    CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

    GerarAvisos(CodOcorrencia, 'A', '', Credito.SeuNumero);
  end;

  Linha := ArquivoTXT.Strings[nLinha+1];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  while Pos(RegSeg, '3B/3C/3D/3E/3F/3Z/') > 0 do
  begin
    Inc(nLinha); //pr�xima linha do txt a ser lida
    {opcionais do segmento A}
    LerSegmentoB(PagFor.Lote.Last.SegmentoA.Last.SegmentoB, nLinha);
    LerSegmentoC(PagFor.Lote.Last.SegmentoA.Last.SegmentoC, nLinha);
//    LerSegmentoE(PagFor.Lote.Last.SegmentoA.Last.SegmentoE, nLinha);
//    LerSegmentoF(PagFor.Lote.Last.SegmentoA.Last.SegmentoF, nLinha);
    LerSegmentoZ(PagFor.Lote.Last.SegmentoA.Last.SegmentoZ, nLinha);

    for x := 0 to PagFor.Lote.Last.SegmentoA.Last.SegmentoB.Count - 1 do
    begin
      with PagFor.Lote.Last.SegmentoA.Last.SegmentoB.Items[x] do
      begin
        GerarAvisos(CodOcorrencia, 'A', 'B',
          PagFor.Lote.Last.SegmentoA.Last.Credito.SeuNumero);
      end;
    end;

    for x := 0 to PagFor.Lote.Last.SegmentoA.Last.SegmentoC.Count - 1 do
    begin
      with PagFor.Lote.Last.SegmentoA.Last.SegmentoC.Items[x] do
      begin
        GerarAvisos(CodOcorrencia, 'A', 'C',
          PagFor.Lote.Last.SegmentoA.Last.Credito.SeuNumero);
      end;
    end;

    Linha := ArquivoTXT.Strings[nLinha+1];
    RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);
  end;
end;

procedure TArquivoR_Itau.LerSegmentoB(mSegmentoBList: TSegmentoBList;
  nLinha: Integer);
var
  mOk: Boolean;
  RegSeg: string;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if (RegSeg <> '3B') then
    Exit;

  if LerCampo(Linha, 15, 2, tcStr) <> '' then
  begin
    // PIX
    // O banco n�o implementou nada
  end
  else
  begin
    mSegmentoBList.New;

    with mSegmentoBList.Last do
    begin
      Inscricao.Tipo := StrToTpInscricao(mOk, LerCampo(Linha, 18, 1, tcStr));
      Inscricao.Numero := LerCampo(Linha, 19, 14, tcStr);

      Endereco.Logradouro := LerCampo(Linha, 33, 30, tcStr);
      Endereco.Numero := LerCampo(Linha, 63, 5, tcStr);
      Endereco.Complemento := LerCampo(Linha, 68, 15, tcStr);
      Endereco.Bairro := LerCampo(Linha, 83, 15, tcStr);
      Endereco.Cidade := LerCampo(Linha, 98, 20, tcStr);
      Endereco.CEP := LerCampo(Linha, 118, 8, tcInt);
      Endereco.Estado := LerCampo(Linha, 126, 2, tcStr);

      Email := LerCampo(Linha, 128, 100, tcStr);
    end;
  end;
end;

procedure TArquivoR_Itau.LerSegmentoC(mSegmentoCList: TSegmentoCList;
  nLinha: Integer);
var
  RegSeg: string;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if (RegSeg <> '3C') then
    Exit;

  mSegmentoCList.New;

  with mSegmentoCList.Last do
  begin
    ValorCSLL := LerCampo(Linha, 15, 15, tcDe2);
    Vencimento := LerCampo(Linha, 38, 8, tcDat);
    ValorDocumento := LerCampo(Linha, 46, 15, tcDe2);
    ValorPIS := LerCampo(Linha, 61, 15, tcDe2);
    ValorIR := LerCampo(Linha, 76, 15, tcDe2);
    ValorISS := LerCampo(Linha, 91, 15, tcDe2);
    ValorCOFINS := LerCampo(Linha, 106, 15, tcDe2);
    Descontos := LerCampo(Linha, 121, 15, tcDe2);
    Abatimentos := LerCampo(Linha, 136, 15, tcDe2);
    Deducoes := LerCampo(Linha, 151, 15, tcDe2);
    Mora := LerCampo(Linha, 166, 15, tcDe2);
    Multa := LerCampo(Linha, 181, 15, tcDe2);
    Acrescimos := LerCampo(Linha, 196, 15, tcDe2);

    NumeroFaturaDocumento := LerCampo(Linha, 211, 20, tcStr);
  end;
end;

procedure TArquivoR_Itau.LerSegmentoJ(nLinha: Integer; var LeuRegistroJ: boolean);
var
  mOk: Boolean;
  RegSeg, RegOpc: string;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);
  RegOpc := LerCampo(Linha, 18, 2, tcStr);

  if (RegSeg <> '3J') and (RegSeg <> '3B') and (RegSeg <> '3C') and (RegSeg <> '3Z') then
    Exit;

  if (RegSeg = '3J') then
    LeuRegistroJ := True;

  if (RegOpc <> '52') and (RegOpc <> '99') and
     (RegSeg <> '3B') and (RegSeg <> '3C') and (RegSeg <> '3Z') then
  begin
    PagFor.Lote.Last.SegmentoJ.New;

    with PagFor.Lote.Last.SegmentoJ.Last do
    begin
      CodMovimento := StrToInMovimento(mOk, LerCampo(Linha, 16, 2, tcStr));
      CodigoBarras := LerCampo(Linha, 18, 44, tcStr);
      NomeCedente := LerCampo(Linha, 62, 30, tcStr);
      DataVencimento := LerCampo(Linha, 92, 8, tcDat);

      ValorTitulo := LerCampo(Linha, 100, 15, tcDe2);
      Desconto := LerCampo(Linha, 115, 15, tcDe2);
      Acrescimo := LerCampo(Linha, 130, 15, tcDe2);
      DataPagamento := LerCampo(Linha, 145, 8, tcDat);
      ValorPagamento := LerCampo(Linha, 153, 15, tcDe2);
      QtdeMoeda := LerCampo(Linha, 168, 15, tcDe5);
      ReferenciaSacado := LerCampo(Linha, 183, 20, tcStr);
      NossoNumero := LerCampo(Linha, 216, 15, tcStr);
      CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

      GerarAvisos(CodOcorrencia, 'J', '', ReferenciaSacado);
    end;
  end;

  // Segmentos B, C, Z, etc. tamb�m existem para outros tipos de segmento que
  // n�o sejam o J, portanto, s� deve processar nessa rotina se o lote que est�
  // sendo processado � realmente de tipos J.
  // O Itau, por exemplo, retorna arquivo com segmentos A contendo segmentos B
  // quando � pagamento de PIX e nesse caso, n�o pode processar o segmento B
  // nessa rotina pois n�o se refere a segmentos J.

  if not LeuRegistroJ then
    exit;

  Linha := ArquivoTXT.Strings[nLinha+1];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);
  RegOpc := LerCampo(Linha, 18, 2, tcStr);

  while (Pos(RegSeg, '3B/3C/3D/3E/3F/3Z/') > 0) or
        (RegSeg = '3J') and (Pos(RegOpc, '52/99/') > 0) do
  begin
    Inc(nLinha); //pr�xima linha do txt a ser lida

    {opcionais segmento J}
    LerSegmentoJ52(PagFor.Lote.Last.SegmentoJ.Last.SegmentoJ52, nLinha);
    LerSegmentoJ99(PagFor.Lote.Last.SegmentoJ.Last.SegmentoJ99, nLinha);
//    LerSegmentoB(PagFor.Lote.Last.SegmentoJ.Last.SegmentoB, nLinha);
//    LerSegmentoC(PagFor.Lote.Last.SegmentoJ.Last.SegmentoC, nLinha);
    LerSegmentoZ(PagFor.Lote.Last.SegmentoJ.Last.SegmentoZ, nLinha);

    Linha := ArquivoTXT.Strings[nLinha+1];
    RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);
    RegOpc := LerCampo(Linha, 18, 2, tcStr);
  end;
end;

procedure TArquivoR_Itau.LerSegmentoN1(nLinha: Integer);
var
  RegSeg: string;
  x: Integer;
  mOk: Boolean;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if RegSeg <> '3N' then
    Exit;

  // S� processa se for GPS
  if (LerCampo(Linha, 18, 2, tcStr) <> '01') then
    Exit;

  PagFor.Lote.Last.SegmentoN1.New;

  with PagFor.Lote.Last.SegmentoN1.Last do
  begin
    CodigoPagamento := StrToCodigoPagamentoGps(mOk, LerCampo(Linha, 20, 4, tcStr));
    MesAnoCompetencia := LerCampo(Linha, 24, 6, tcInt);
    idContribuinte := LerCampo(Linha, 30, 14, tcStr);
    ValorTributo := LerCampo(Linha, 44, 14, tcDe2);
    ValorOutrasEntidades := LerCampo(Linha, 58, 14, tcDe2);
    AtualizacaoMonetaria := LerCampo(Linha, 72, 14, tcDe2);

    with SegmentoN do
    begin
      CodMovimento := StrToInMovimento(mOk, LerCampo(Linha, 16, 2, tcStr));
      ValorPagamento := LerCampo(Linha, 86, 14, tcDe2);
      DataPagamento := LerCampo(Linha, 100, 8, tcDat);
      SeuNumero := LerCampo(Linha, 196, 20, tcStr);
      NossoNumero := LerCampo(Linha, 216, 20, tcStr);
      CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

      GerarAvisos(CodOcorrencia, 'N', '', SeuNumero);
    end;
  end;

  {Adicionais segmento N}
  with PagFor.Lote.Last.SegmentoN1.Last.SegmentoN do
  begin
    LerSegmentoB(SegmentoB, nLinha);
    LerSegmentoW(SegmentoW, nLinha);
    LerSegmentoZ(SegmentoZ, nLinha);

    for x := 0 to SegmentoB.Count - 1 do
    begin
      with SegmentoB.Items[x] do
      begin
        GerarAvisos(CodOcorrencia, 'N', 'B', SeuNumero);
      end;
    end;
  end;
end;

procedure TArquivoR_Itau.LerSegmentoN2(nLinha: Integer);
var
  RegSeg: string;
  x: Integer;
  mOk: Boolean;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if RegSeg <> '3N' then
    Exit;

  // S� processa se for DARF
  if (LerCampo(Linha, 18, 2, tcStr) <> '02') then
    Exit;

  PagFor.Lote.Last.SegmentoN2.New;

  with PagFor.Lote.Last.SegmentoN2.Last do
  begin
    Receita := LerCampo(Linha, 20, 4, tcInt);
    TipoContribuinte := StrToTpInscricao(mOk, LerCampo(Linha, 24, 1, tcStr));
    idContribuinte := LerCampo(Linha, 25, 14, tcStr);
    Periodo := LerCampo(Linha, 39, 8, tcDat);
    Referencia := LerCampo(Linha, 47, 17, tcStr);
    ValorPrincipal := LerCampo(Linha, 64, 14, tcDe2);
    Multa := LerCampo(Linha, 78, 14, tcDe2);
    Juros := LerCampo(Linha, 92, 14, tcDe2);
    DataVencimento := LerCampo(Linha, 120, 8, tcDat);

    with SegmentoN do
    begin
      CodMovimento := StrToInMovimento(mOk, LerCampo(Linha, 16, 2, tcStr));
      ValorPagamento := LerCampo(Linha, 106, 14, tcDe2);
      DataPagamento := LerCampo(Linha, 128, 8, tcDat);
      NomeContribuinte := LerCampo(Linha, 166, 30, tcStr);
      SeuNumero := LerCampo(Linha, 196, 20, tcStr);
      CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

      GerarAvisos(CodOcorrencia, 'N', '', SeuNumero);
    end;
  end;

  {Adicionais segmento N}
  with PagFor.Lote.Last.SegmentoN2.Last.SegmentoN do
  begin
    LerSegmentoB(SegmentoB, nLinha);
    LerSegmentoW(SegmentoW, nLinha);
    LerSegmentoZ(SegmentoZ, nLinha);

    for x := 0 to SegmentoB.Count - 1 do
    begin
      with SegmentoB.Items[x] do
      begin
        GerarAvisos(CodOcorrencia, 'N', 'B', SeuNumero);
      end;
    end;
  end;
end;

procedure TArquivoR_Itau.LerSegmentoN3(nLinha: Integer);
var
  RegSeg: string;
  x: Integer;
  mOk: Boolean;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if RegSeg <> '3N' then
    Exit;

  // S� processa se for DARF Simples
  if (LerCampo(Linha, 18, 2, tcStr) <> '03') then
    Exit;

  PagFor.Lote.Last.SegmentoN3.New;

  with PagFor.Lote.Last.SegmentoN3.Last do
  begin
    // Verificar as posi��es e os campos.
    Receita := LerCampo(Linha, 20, 4, tcInt);
    TipoContribuinte := StrToTpInscricao(mOk, LerCampo(Linha, 24, 1, tcStr));
    idContribuinte := LerCampo(Linha, 25, 14, tcStr);
    Periodo := LerCampo(Linha, 39, 8, tcDat);
    ReceitaBruta := LerCampo(Linha, 64, 14, tcDe2);
    Percentual := LerCampo(Linha, 64, 14, tcDe2);
    ValorPrincipal := LerCampo(Linha, 64, 14, tcDe2);
    Multa := LerCampo(Linha, 78, 14, tcDe2);
    Juros := LerCampo(Linha, 92, 14, tcDe2);
    DataVencimento := LerCampo(Linha, 120, 8, tcDat);

    with SegmentoN do
    begin
      // Verificar as posi��es e os campos.
      CodMovimento := StrToInMovimento(mOk, LerCampo(Linha, 16, 2, tcStr));
      ValorPagamento := LerCampo(Linha, 106, 14, tcDe2);
      DataPagamento := LerCampo(Linha, 128, 8, tcDat);
      NomeContribuinte := LerCampo(Linha, 166, 30, tcStr);
      SeuNumero := LerCampo(Linha, 196, 20, tcStr);
      CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

      GerarAvisos(CodOcorrencia, 'N', '', SeuNumero);
    end;
  end;

  {Adicionais segmento N}

  with PagFor.Lote.Last.SegmentoN3.Last.SegmentoN do
  begin
    LerSegmentoB(SegmentoB, nLinha);
    LerSegmentoW(SegmentoW, nLinha);
    LerSegmentoZ(SegmentoZ, nLinha);

    for x := 0 to SegmentoB.Count - 1 do
    begin
      with SegmentoB.Items[x] do
      begin
        GerarAvisos(CodOcorrencia, 'N', 'B', SeuNumero);
      end;
    end;
  end;
end;

procedure TArquivoR_Itau.LerSegmentoN4(nLinha: Integer);
var
  RegSeg: string;
  x: Integer;
  mOk: Boolean;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if RegSeg <> '3N' then
    Exit;

  // S� processa se for GARE SP ICMS
  if (LerCampo(Linha, 18, 2, tcStr) <> '05') then
    Exit;

  PagFor.Lote.Last.SegmentoN4.New;

  with PagFor.Lote.Last.SegmentoN4.Last do
  begin
    // Verificar as posi��es e os campos.
    Receita := LerCampo(Linha, 20, 4, tcInt);
    TipoContribuinte := StrToTpInscricao(mOk, LerCampo(Linha, 24, 1, tcStr));
    idContribuinte := LerCampo(Linha, 25, 14, tcStr);
    InscEst := LerCampo(Linha, 39, 12, tcStr);
    NumEtiqueta := LerCampo(Linha, 51, 13, tcStr);
    Referencia := LerCampo(Linha, 64, 6, tcInt);
    NumParcela := LerCampo(Linha, 70, 13, tcStr);
    ValorReceita := LerCampo(Linha, 83, 14, tcDe2);
    Juros := LerCampo(Linha, 97, 14, tcDe2);
    Multa := LerCampo(Linha, 111, 14, tcDe2);
    DataVencimento := LerCampo(Linha, 139, 8, tcDat);

    with SegmentoN do
    begin
      // Verificar as posi��es e os campos.
      CodMovimento := StrToInMovimento(mOk, LerCampo(Linha, 16, 2, tcStr));
      ValorPagamento := LerCampo(Linha, 125, 14, tcDe2);
      DataPagamento := LerCampo(Linha, 147, 8, tcDat);
      NomeContribuinte := LerCampo(Linha, 166, 30, tcStr);
      SeuNumero := LerCampo(Linha, 196, 20, tcStr);
      NossoNumero := LerCampo(Linha, 216, 20, tcStr);
      CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

      GerarAvisos(CodOcorrencia, 'N', '', SeuNumero);
    end;
  end;

  {Adicionais segmento N}

  with PagFor.Lote.Last.SegmentoN4.Last.SegmentoN do
  begin
    LerSegmentoB(SegmentoB, nLinha);
    LerSegmentoW(SegmentoW, nLinha);
    LerSegmentoZ(SegmentoZ, nLinha);

    for x := 0 to SegmentoB.Count - 1 do
    begin
      with SegmentoB.Items[x] do
      begin
        GerarAvisos(CodOcorrencia, 'N', 'B', SeuNumero);
      end;
    end;
  end;
end;

procedure TArquivoR_Itau.LerSegmentoN567(nLinha: Integer);
var
  RegSeg: string;
  x: Integer;
  mOk: Boolean;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if RegSeg <> '3N' then
    Exit;

  // S� processa se for IPVA/DPVAT
  if (Pos(LerCampo(Linha, 18, 2, tcStr), '07 08') = 0) then
    Exit;

  PagFor.Lote.Last.SegmentoN567.New;

  with PagFor.Lote.Last.SegmentoN567.Last do
  begin
    // Verificar as posi��es e os campos.
    Receita := LerCampo(Linha, 111, 6, tcInt);
    TipoContribuinte := StrToTpInscricao(mOk, LerCampo(Linha, 117, 2, tcStr));
    idContribuinte := LerCampo(Linha, 119, 14, tcStr);
    Tributo := StrToIndTributo(mOk, LerCampo(Linha, 133, 2, tcStr));
    Exercicio := LerCampo(Linha, 135, 4, tcInt);
    Renavam := LerCampo(Linha, 139, 9, tcStr);
    Estado := LerCampo(Linha, 148, 2, tcStr);
    Municipio := LerCampo(Linha, 150, 5, tcInt);
    Placa := LerCampo(Linha, 155, 7, tcStr);
    OpcaoPagamento := LerCampo(Linha, 162, 1, tcStr);
    NovoRenavam := LerCampo(Linha, 163, 12, tcStr);

    with SegmentoN do
    begin
      // Verificar as posi��es e os campos.
      CodMovimento := StrToInMovimento(mOk, LerCampo(Linha, 16, 2, tcStr));
      ValorPagamento := LerCampo(Linha, 125, 14, tcDe2);
      DataPagamento := LerCampo(Linha, 147, 8, tcDat);
      NomeContribuinte := LerCampo(Linha, 166, 30, tcStr);
      SeuNumero := LerCampo(Linha, 196, 20, tcStr);
      NossoNumero := LerCampo(Linha, 216, 20, tcStr);
      CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

      GerarAvisos(CodOcorrencia, 'N', '', SeuNumero);
    end;
  end;

  {Adicionais segmento N}

  with PagFor.Lote.Last.SegmentoN567.Last.SegmentoN do
  begin
    LerSegmentoB(SegmentoB, nLinha);
    LerSegmentoW(SegmentoW, nLinha);
    LerSegmentoZ(SegmentoZ, nLinha);

    for x := 0 to SegmentoB.Count - 1 do
    begin
      with SegmentoB.Items[x] do
      begin
        GerarAvisos(CodOcorrencia, 'N', 'B', SeuNumero);
      end;
    end;
  end;
end;

procedure TArquivoR_Itau.LerSegmentoN8(nLinha: Integer);
var
  RegSeg: string;
  x: Integer;
  mOk: Boolean;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if RegSeg <> '3N' then
    Exit;

  PagFor.Lote.Last.SegmentoN8.New;

  with PagFor.Lote.Last.SegmentoN8.Last do
  begin
    // Verificar as posi��es e os campos.
    Receita := LerCampo(Linha, 20, 4, tcInt);
    TipoContribuinte := StrToTpInscricao(mOk, LerCampo(Linha, 24, 1, tcStr));
    idContribuinte := LerCampo(Linha, 25, 14, tcStr);
    InscEst := LerCampo(Linha, 39, 12, tcStr);
    Origem := LerCampo(Linha, 51, 13, tcStr);
    ValorPrincipal := LerCampo(Linha, 83, 14, tcDe2);
    AtualizacaoMonetaria := LerCampo(Linha, 97, 14, tcDe2);
    Mora := LerCampo(Linha, 97, 14, tcDe2);
    Multa := LerCampo(Linha, 111, 14, tcDe2);
    DataVencimento := LerCampo(Linha, 139, 8, tcDat);
    PeriodoParcela := LerCampo(Linha, 20, 6, tcInt);

    with SegmentoN do
    begin
      // Verificar as posi��es e os campos.
      CodMovimento := StrToInMovimento(mOk, LerCampo(Linha, 16, 2, tcStr));
      ValorPagamento := LerCampo(Linha, 125, 14, tcDe2);
      DataPagamento := LerCampo(Linha, 147, 8, tcDat);
      NomeContribuinte := LerCampo(Linha, 166, 30, tcStr);
      SeuNumero := LerCampo(Linha, 196, 20, tcStr);
      NossoNumero := LerCampo(Linha, 216, 20, tcStr);
      CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

      GerarAvisos(CodOcorrencia, 'N', '', SeuNumero);
    end;
  end;

  {Adicionais segmento N}

  with PagFor.Lote.Last.SegmentoN8.Last.SegmentoN do
  begin
    LerSegmentoB(SegmentoB, nLinha);
    LerSegmentoW(SegmentoW, nLinha);
    LerSegmentoZ(SegmentoZ, nLinha);

    for x := 0 to SegmentoB.Count - 1 do
    begin
      with SegmentoB.Items[x] do
      begin
        GerarAvisos(CodOcorrencia, 'N', 'B', SeuNumero);
      end;
    end;
  end;
end;

procedure TArquivoR_Itau.LerSegmentoN9(nLinha: Integer);
var
  RegSeg: string;
  x: Integer;
  mOk: Boolean;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if RegSeg <> '3N' then
    Exit;

  // S� processa se for FGTS
  if (LerCampo(Linha, 18, 2, tcStr) <> '11') then
    Exit;

  PagFor.Lote.Last.SegmentoN9.New;

  with PagFor.Lote.Last.SegmentoN9.Last do
  begin
    // Verificar as posi��es e os campos.
    Receita := LerCampo(Linha, 20, 4, tcInt);

    if LerCampo(Linha, 24, 1, tcStr) = '1' then // Nesse segmento, 1 = CNPJ e 2 = CEI
      TipoContribuinte := tiCNPJ
    else
      TipoContribuinte := tiCPF;

    idContribuinte := LerCampo(Linha, 25, 14, tcStr);
    CodigoBarras := LerCampo(Linha, 39, 12, tcStr);
    Identificador := LerCampo(Linha, 51, 13, tcInt);
    Lacre := LerCampo(Linha, 83, 14, tcInt);
    LacreDigito := LerCampo(Linha, 97, 14, tcInt);

    with SegmentoN do
    begin
      // Verificar as posi��es e os campos.
      CodMovimento := StrToInMovimento(mOk, LerCampo(Linha, 16, 2, tcStr));
      ValorPagamento := LerCampo(Linha, 125, 14, tcDe2);
      DataPagamento := LerCampo(Linha, 147, 8, tcDat);
      NomeContribuinte := LerCampo(Linha, 166, 30, tcStr);
      SeuNumero := LerCampo(Linha, 196, 20, tcStr);
      NossoNumero := LerCampo(Linha, 216, 20, tcStr);
      CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

      GerarAvisos(CodOcorrencia, 'N', '', SeuNumero);
    end;
  end;

  {Adicionais segmento N}
  with PagFor.Lote.Last.SegmentoN9.Last.SegmentoN do
  begin
    LerSegmentoB(SegmentoB, nLinha);
    LerSegmentoW(SegmentoW, nLinha);
    LerSegmentoZ(SegmentoZ, nLinha);

    for x := 0 to SegmentoB.Count - 1 do
    begin
      with SegmentoB.Items[x] do
      begin
        GerarAvisos(CodOcorrencia, 'N', 'B', SeuNumero);
      end;
    end;
  end;
end;

procedure TArquivoR_Itau.LerSegmentoO(nLinha: Integer);
var
  mOk: Boolean;
  RegSeg: string;
begin
  Linha := ArquivoTXT.Strings[nLinha];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  if RegSeg <> '3O' then
    Exit;

  PagFor.Lote.Last.SegmentoO.New;

  with PagFor.Lote.Last.SegmentoO.Last do
  begin
    CodMovimento := StrToInMovimento(mOk, LerCampo(Linha, 16, 2, tcStr));
    CodigoBarras := LerCampo(Linha, 18, 48, tcStr);
    NomeConcessionaria := LerCampo(Linha, 66, 30, tcStr);
    DataVencimento := LerCampo(Linha, 96, 8, tcDat);
    QuantidadeMoeda := LerCampo(Linha, 107, 15, tcDe5);
    ValorPagamento := LerCampo(Linha, 122, 15, tcDe2);
    DataPagamento := LerCampo(Linha, 137, 8, tcDat);
    ValorPago := LerCampo(Linha, 145, 15, tcDe2);
    NotaFiscal := LerCampo(Linha, 163, 9, tcInt);
    SeuNumero := LerCampo(Linha, 175, 20, tcStr);
    NossoNumero := LerCampo(Linha, 216, 15, tcStr);
    CodOcorrencia := LerCampo(Linha, 231, 10, tcStr);

    GerarAvisos(CodOcorrencia, 'O', '', SeuNumero);
  end;

  Linha := ArquivoTXT.Strings[nLinha+1];
  RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);

  while Pos(RegSeg, '3Z') > 0 do
  begin
    Inc(nLinha); //pr�xima linha do txt a ser lida

    {opcionais segmento O}
    LerSegmentoW(PagFor.Lote.Last.SegmentoO.Last.SegmentoW, nLinha);
    LerSegmentoB(PagFor.Lote.Last.SegmentoO.Last.SegmentoB, nLinha);
    LerSegmentoZ(PagFor.Lote.Last.SegmentoO.Last.SegmentoZ, nLinha);

    Linha := ArquivoTXT.Strings[nLinha+1];
    RegSeg := LerCampo(Linha, 8, 1, tcStr) + LerCampo(Linha, 14, 1, tcStr);
  end;
end;

function TArquivoR_Itau.GetOcorrencia(aOcorrencia: TOcorrencia): String;
begin
  case aOcorrencia of
    to00: Result := 'PAGAMENTO EFETUADO';
    toAE: Result := 'DATA DE PAGAMENTO ALTERADA';
    toAG: Result := 'N�MERO DO LOTE INV�LIDO';
    toAH: Result := 'N�MERO SEQUENCIAL DO REGISTRO NO LOTE INV�LIDO';
    toAI: Result := 'PRODUTO DEMONSTRATIVO DE PAGAMENTO N�O CONTRATADO';
    toAJ: Result := 'TIPO DE MOVIMENTO INV�LIDO';
    toAL: Result := 'C�DIGO DO BANCO FAVORECIDO INV�LIDO';
    toAM: Result := 'AG�NCIA DO FAVORECIDO INV�LIDA';
    toAN: Result := 'CONTA CORRENTE DO FAVORECIDO INV�LIDA';
    toAO: Result := 'NOME DO FAVORECIDO INV�LIDO';
    toAP: Result := 'DATA DE PAGAMENTO / DATA DE VALIDADE / HORA DE LAN�AMENTO / ARRECADA��O / APURA��O INV�LIDA';
    toAQ: Result := 'QUANTIDADE DE REGISTROS MAIOR QUE 999999';
    toAR: Result := 'VALOR ARRECADADO / LAN�AMENTO INV�LIDO';
    toBC: Result := 'NOSSO N�MERO INV�LIDO';
    toBD: Result := 'PAGAMENTO AGENDADO';
    toBE: Result := 'PAGAMENTO AGENDADO COM FORMA ALTERADA PARA OP';
    toBI: Result := 'CNPJ / CPF DO FAVORECIDO NO SEGMENTO J-52 ou B INV�LIDO / DOCUMENTO FAVORECIDO INV�LIDO PIX';
    toBL: Result := 'VALOR DA PARCELA INV�LIDO';
    toCD: Result := 'CNPJ / CPF INFORMADO DIVERGENTE DO CADASTRADO';
    toCE: Result := 'PAGAMENTO CANCELADO';
    toCF: Result := 'VALOR DO DOCUMENTO INV�LIDO / VALOR DIVERGENTE DO QR CODE';
    toCG: Result := 'VALOR DO ABATIMENTO INV�LIDO';
    toCH: Result := 'VALOR DO DESCONTO INV�LIDO';
    toCI: Result := 'CNPJ / CPF / IDENTIFICADOR / INSCRI��O ESTADUAL / INSCRI��O NO CAD / ICMS INV�LIDO';
    toCJ: Result := 'VALOR DA MULTA INV�LIDO';
    toCK: Result := 'TIPO DE INSCRI��O INV�LIDA';
    toCL: Result := 'VALOR DO INSS INV�LIDO';
    toCM: Result := 'VALOR DO COFINS INV�LIDO';
    toCN: Result := 'CONTA N�O CADASTRADA';
    toCO: Result := 'VALOR DE OUTRAS ENTIDADES INV�LIDO';
    toCP: Result := 'CONFIRMA��O DE OP CUMPRIDA';
    toCQ: Result := 'SOMA DAS FATURAS DIFERE DO PAGAMENTO';
    toCR: Result := 'VALOR DO CSLL INV�LIDO';
    toCS: Result := 'DATA DE VENCIMENTO DA FATURA INV�LIDA';
    toDA: Result := 'N�MERO DE DEPEND. SAL�RIO FAMILIA INVALIDO';
    toDB: Result := 'N�MERO DE HORAS SEMANAIS INV�LIDO';
    toDC: Result := 'SAL�RIO DE CONTRIBUI��O INSS INV�LIDO';
    toDD: Result := 'SAL�RIO DE CONTRIBUI��O FGTS INV�LIDO';
    toDE: Result := 'VALOR TOTAL DOS PROVENTOS INV�LIDO';
    toDF: Result := 'VALOR TOTAL DOS DESCONTOS INV�LIDO';
    toDG: Result := 'VALOR L�QUIDO N�O NUM�RICO';
    toDH: Result := 'VALOR LIQ. INFORMADO DIFERE DO CALCULADO';
    toDI: Result := 'VALOR DO SAL�RIO-BASE INV�LIDO';
    toDJ: Result := 'BASE DE C�LCULO IRRF INV�LIDA';
    toDK: Result := 'BASE DE C�LCULO FGTS INV�LIDA';
    toDL: Result := 'FORMA DE PAGAMENTO INCOMPAT�VEL COM HOLERITE';
    toDM: Result := 'E-MAIL DO FAVORECIDO INV�LIDO';
    toDV: Result := 'DOC / TED DEVOLVIDO PELO BANCO FAVORECIDO';
    toD0: Result := 'FINALIDADE DO HOLERITE INV�LIDA';
    toD1: Result := 'M�S DE COMPETENCIA DO HOLERITE INV�LIDA';
    toD2: Result := 'DIA DA COMPETENCIA DO HOLETITE INV�LIDA';
    toD3: Result := 'CENTRO DE CUSTO INV�LIDO';
    toD4: Result := 'CAMPO NUM�RICO DA FUNCIONAL INV�LIDO';
    toD5: Result := 'DATA IN�CIO DE F�RIAS N�O NUM�RICA';
    toD6: Result := 'DATA IN�CIO DE F�RIAS INCONSISTENTE';
    toD7: Result := 'DATA FIM DE F�RIAS N�O NUM�RICO';
    toD8: Result := 'DATA FIM DE F�RIAS INCONSISTENTE';
    toD9: Result := 'N�MERO DE DEPENDENTES IR INV�LIDO';
    toEM: Result := 'CONFIRMA��O DE OP EMITIDA';
    toEX: Result := 'DEVOLU��O DE OP N�O SACADA PELO FAVORECIDO';
    toE0: Result := 'TIPO DE MOVIMENTO HOLERITE INV�LIDO';
    toE1: Result := 'VALOR 01 DO HOLERITE / INFORME INV�LIDO';
    toE2: Result := 'VALOR 02 DO HOLERITE / INFORME INV�LIDO';
    toE3: Result := 'VALOR 03 DO HOLERITE / INFORME INV�LIDO';
    toE4: Result := 'VALOR 04 DO HOLERITE / INFORME INV�LIDO';
    toFC: Result := 'PAGAMENTO EFETUADO ATRAV�S DE FINANCIAMENTO COMPROR';
    toFD: Result := 'PAGAMENTO EFETUADO ATRAV�S DE FINANCIAMENTO DESCOMPROR';
    toHA: Result := 'ERRO NO LOTE';
    toHM: Result := 'ERRO NO REGISTRO HEADER DE ARQUIVO';
    toIB: Result := 'VALOR DO DOCUMENTO INV�LIDO';
    toIC: Result := 'VALOR DO ABATIMENTO INV�LIDO';
    toID: Result := 'VALOR DO DESCONTO INV�LIDO';
    toIE: Result := 'VALOR DA MORA INV�LIDO';
    toIF: Result := 'VALOR DA MULTA INV�LIDO';
    toIG: Result := 'VALOR DA DEDU��O INV�LIDO';
    toIH: Result := 'VALOR DO ACR�SCIMO INV�LIDO';
    toII: Result := 'DATA DE VENCIMENTO INV�LIDA / QR CODE EXPIRADO';
    toIJ: Result := 'COMPET�NCIA / PER�ODO REFER�NCIA / PARCELA INV�LIDA';
    toIK: Result := 'TRIBUTO N�O LIQUID�VEL VIA SISPAG OU N�O CONVENIADO COM ITA�';
    toIL: Result := 'C�DIGO DE PAGAMENTO / EMPRESA /RECEITA INV�LIDO';
    toIM: Result := 'TIPO X FORMA N�O COMPAT�VEL';
    toIN: Result := 'BANCO/AG�NCIA N�O CADASTRADOS';
    toIO: Result := 'DAC / VALOR / COMPET�NCIA / IDENTIFICADOR DO LACRE INV�LIDO / IDENTIFICA��O DO QR CODE INV�LIDO';
    toIP: Result := 'DAC DO C�DIGO DE BARRAS INV�LIDO / ERRO NA VALIDA��O DO QR CODE';
    toIQ: Result := 'D�VIDA ATIVA OU N�MERO DE ETIQUETA INV�LIDO';
    toIR: Result := 'PAGAMENTO ALTERADO';
    toIS: Result := 'CONCESSION�RIA N�O CONVENIADA COM ITA�';
    toIT: Result := 'VALOR DO TRIBUTO INV�LIDO';
    toIU: Result := 'VALOR DA RECEITA BRUTA ACUMULADA INV�LIDO';
    toIV: Result := 'N�MERO DO DOCUMENTO ORIGEM / REFER�NCIA INV�LIDO';
    toIX: Result := 'C�DIGO DO PRODUTO INV�LIDO';
    toLA: Result := 'DATA DE PAGAMENTO DE UM LOTE ALTERADA';
    toLC: Result := 'LOTE DE PAGAMENTOS CANCELADO';
    toNA: Result := 'PAGAMENTO CANCELADO POR FALTA DE AUTORIZA��O';
    toNB: Result := 'IDENTIFICA��O DO TRIBUTO INV�LIDA';
    toNC: Result := 'EXERC�CIO (ANO BASE) INV�LIDO';
    toND: Result := 'C�DIGO RENAVAM N�O ENCONTRADO/INV�LIDO';
    toNE: Result := 'UF INV�LIDA';
    toNF: Result := 'C�DIGO DO MUNIC�PIO INV�LIDO';
    toNG: Result := 'PLACA INV�LIDA';
    toNH: Result := 'OP��O/PARCELA DE PAGAMENTO INV�LIDA';
    toNI: Result := 'TRIBUTO J� FOI PAGO OU EST� VENCIDO';
    toNR: Result := 'OPERA��O N�O REALIZADA';
    toPD: Result := 'AQUISI��O CONFIRMADA (EQUIVALE A OCORR�NCIA 02 NO LAYOUT DE RISCO SACADO)';
    toRJ: Result := 'REGISTRO REJEITADO � CONTA EM PROCESSO DE ABERTURA OU BLOQUEADA';
    toRS: Result := 'PAGAMENTO DISPON�VEL PARA ANTECIPA��O NO RISCO SACADO � MODALIDADE RISCO SACADO P�S AUTORIZADO';
    toSS: Result := 'PAGAMENTO CANCELADO POR INSUFICI�NCIA DE SALDO / LIMITE DI�RIO DE PAGTO EXCEDIDO';
    toTA: Result := 'LOTE N�O ACEITO - TOTAIS DO LOTE COM DIFEREN�A';
    toTI: Result := 'TITULARIDADE INV�LIDA';
    toX1: Result := 'FORMA INCOMPAT�VEL COM LAYOUT 010';
    toX2: Result := 'N�MERO DA NOTA FISCAL INV�LIDO';
    toX3: Result := 'IDENTIFICADOR DE NF/CNPJ INV�LIDO';
    toX4: Result := 'FORMA 32 INV�LIDA';
  else
    Result := '';
  end;
end;

end.

