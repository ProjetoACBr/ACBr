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

unit PagFor.Bradesco.GravarTxtRemessa;

interface

uses
  SysUtils, Classes,
  ACBrPagForClass, CNAB240.GravarTxtRemessa;

type
 { TArquivoW_Bradesco }

  TArquivoW_Bradesco = class(TArquivoW_CNAB240)
  protected
    procedure GeraRegistro0; override;

    procedure GeraRegistro1(I: Integer); override;

    procedure GeraSegmentoB(mSegmentoBList: TSegmentoBList); override;

    procedure GeraSegmentoJ52(mSegmentoJ52List: TSegmentoJ52List); override;
  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrPagForConversao;

{ TArquivoW_Bradesco }

procedure TArquivoW_Bradesco.GeraRegistro0;
var
  LIdentificacaoRemessa: string;
begin
  FpLinha := '';
  FQtdeRegistros := 1;
  FQtdeLotes := 0;
  FQtdeContasConc := 0;

  GravarCampo(BancoToStr(PagFor.Geral.Banco), 3, tcStr);
  GravarCampo(0, 4, tcInt);
  GravarCampo(0, 1, tcInt);
  GravarCampo(' ', 9, tcStr);
  GravarCampo(TpInscricaoToStr(PagFor.Registro0.Empresa.Inscricao.Tipo), 1, tcStr);
  GravarCampo(PagFor.Registro0.Empresa.Inscricao.Numero, 14, tcStrZero);
  GravarCampo(PagFor.Registro0.Empresa.Convenio, 20, tcStr);
  GravarCampo(PagFor.Registro0.Empresa.ContaCorrente.Agencia.Codigo, 5, tcInt);
  GravarCampo(PagFor.Registro0.Empresa.ContaCorrente.Agencia.DV, 1, tcStr);
  GravarCampo(PagFor.Registro0.Empresa.ContaCorrente.Conta.Numero, 12, tcInt64);
  GravarCampo(PagFor.Registro0.Empresa.ContaCorrente.Conta.DV, 1, tcStr);
  GravarCampo(PagFor.Registro0.Empresa.ContaCorrente.DV, 1, tcStr);
  GravarCampo(PagFor.Registro0.Empresa.Nome, 30, tcStr, True);
  GravarCampo(PagFor.Registro0.NomeBanco, 30, tcStr, True);
  GravarCampo(' ', 10, tcStr);
  GravarCampo(TpArquivoToStr(PagFor.Registro0.Arquivo.Codigo), 1, tcStr);
  GravarCampo(PagFor.Registro0.Arquivo.DataGeracao, 8, tcDat);
  GravarCampo(PagFor.Registro0.Arquivo.HoraGeracao, 6, tcHor);
  GravarCampo(PagFor.Registro0.Arquivo.Sequencia, 6, tcInt);
  GravarCampo('089', 3, tcStr);
  GravarCampo(PagFor.Registro0.Arquivo.Densidade, 5, tcInt);

  LIdentificacaoRemessa := '';

  if (PagFor.Lote.Count > 0) and
     (PagFor.Lote[0].Registro1.Servico.FormaLancamento in [flPIXTransferencia, flPIXQRCode]) then
    LIdentificacaoRemessa := 'PIX';

  GravarCampo(LIdentificacaoRemessa, 3, tcStr);
  GravarCampo(PagFor.Registro0.ReservadoBanco, 17, tcStr);
  GravarCampo(PagFor.Registro0.ReservadoEmpresa, 20, tcStr, True);
  GravarCampo(' ', 29, tcStr);

  ValidarLinha('0');
  IncluirLinha;
end;

procedure TArquivoW_Bradesco.GeraRegistro1(I: Integer);
begin
  FpLinha := '';
  Inc(FQtdeRegistros);
  Inc(FQtdeLotes);

  if PagFor.Lote[I].Registro1.Servico.Operacao = toExtrato then
    Inc(FQtdeContasConc);

  FQtdeRegistrosLote := 1;
  FSequencialDoRegistroNoLote := 0;

  FpFormaLancamento := PagFor.Lote[I].Registro1.Servico.FormaLancamento;

  GravarCampo(BancoToStr(PagFor.Geral.Banco), 3, tcStr);
  GravarCampo(FQtdeLotes, 4, tcInt);
  GravarCampo(1, 1, tcInt);
  GravarCampo(TpOperacaoToStr(PagFor.Lote[I].Registro1.Servico.Operacao), 1, tcStr);
  GravarCampo(TpServicoToStr(PagFor.Lote[I].Registro1.Servico.TipoServico), 2, tcStr);
  GravarCampo(FmLancamentoToStr(FpFormaLancamento), 2, tcStr);

  if PagFor.Lote[I].SegmentoA.Count > 0 then
    // Se for parte do Header (Pagamentos atrav�s de cheque, OP, DOC, TED e cr�dito em conta corrente)
    // Segmento A - Pagamentos atrav�s de cheque, OP, DOC, TED e cr�dito em conta corrente
    GravarCampo('045', 3, tcStr)
  else
    if PagFor.Lote[I].SegmentoO.Count > 0 then
      GravarCampo('012', 3, tcStr)
    else
      GravarCampo('040', 3, tcStr);

  GravarCampo(' ', 1, tcStr);
  GravarCampo(TpInscricaoToStr(PagFor.Lote[I].Registro1.Empresa.Inscricao.Tipo), 1, tcStr);
  GravarCampo(PagFor.Lote[I].Registro1.Empresa.Inscricao.Numero, 14, tcStrZero);
  GravarCampo(PagFor.Lote[I].Registro1.Empresa.Convenio, 20, tcStr);
  GravarCampo(PagFor.Lote[I].Registro1.Empresa.ContaCorrente.Agencia.Codigo, 5, tcInt);
  GravarCampo(PagFor.Lote[I].Registro1.Empresa.ContaCorrente.Agencia.DV, 1, tcStr);
  GravarCampo(PagFor.Lote[I].Registro1.Empresa.ContaCorrente.Conta.Numero, 12, tcInt64);
  GravarCampo(PagFor.Lote[I].Registro1.Empresa.ContaCorrente.Conta.DV, 1, tcStr);
  GravarCampo(PagFor.Lote[I].Registro1.Empresa.ContaCorrente.DV, 1, tcStr);
  GravarCampo(PagFor.Lote[I].Registro1.Empresa.Nome, 30, tcStr, True);
  GravarCampo(PagFor.Lote[I].Registro1.Informacao1, 40, tcStr, True);
  GravarCampo(PagFor.Lote[I].Registro1.Endereco.Logradouro, 30, tcStr, True);
  GravarCampo(PagFor.Lote[I].Registro1.Endereco.Numero, 5, tcStrZero);
  GravarCampo(PagFor.Lote[I].Registro1.Endereco.Complemento, 15, tcStr, True);
  GravarCampo(PagFor.Lote[I].Registro1.Endereco.Cidade, 20, tcStr, True);
  GravarCampo(PagFor.Lote[I].Registro1.Endereco.CEP, 8, tcInt);
  GravarCampo(PagFor.Lote[I].Registro1.Endereco.Estado, 2, tcStr);

  if (PagFor.Lote[I].SegmentoA.Count > 0) or (PagFor.Lote[I].SegmentoO.Count > 0) or
     (PagFor.Lote[0].Registro1.Servico.FormaLancamento in [flPIXTransferencia, flPIXQRCode])  then
  begin
    // Se for parte do Header (Pagamentos atrav�s de cheque, OP, DOC, TED e cr�dito em conta corrente)
    // Segmento A - Pagamentos atrav�s de cheque, OP, DOC, TED e cr�dito em conta corrente
    GravarCampo('01', 2, tcStr);
    GravarCampo(' ', 16, tcStr);
  end
  else
    GravarCampo(' ', 18, tcStr);

  ValidarLinha('1');
  IncluirLinha;
end;

procedure TArquivoW_Bradesco.GeraSegmentoB(mSegmentoBList: TSegmentoBList);
var
  J: Integer;
begin
  for J := 0 to mSegmentoBList.Count - 1 do
  begin
    FpLinha := '';

    with mSegmentoBList[J] do
    begin
      Inc(FQtdeRegistros);
      Inc(FQtdeRegistrosLote);
      Inc(FSequencialDoRegistroNoLote);

      GravarCampo(BancoToStr(PagFor.Geral.Banco), 3, tcStr);
      GravarCampo(FQtdeLotes, 4, tcInt);
      GravarCampo('3', 1, tcStr);
      GravarCampo(FSequencialDoRegistroNoLote, 5, tcInt);
      GravarCampo('B', 1, tcStr);

      if PixTipoChave <> tcpNenhum then
      begin
        GravarCampo(TipoChavePixToStr(PixTipoChave), 2, tcStr);
        GravarCampo(' ', 1, tcStr);
        GravarCampo(TpInscricaoToStr(Inscricao.Tipo), 1, tcStr);
        GravarCampo(Inscricao.Numero, 14, tcStrZero);
        GravarCampo(PixTXID, 35, tcStr);
        GravarCampo(PixMensagem, 60, tcStr);
        GravarCampo(PixChave, 99, tcStr);
        GravarCampo(CodigoUG, 6, tcInt);
        GravarCampo(CodigoISPB, 8, tcInt);
      end
      else
      begin
        GravarCampo(' ', 3, tcStr);
        GravarCampo(TpInscricaoToStr(Inscricao.Tipo), 1, tcStr);
        GravarCampo(Inscricao.Numero, 14, tcStrZero);
        GravarCampo(Endereco.Logradouro, 30, tcStr, True);
        GravarCampo(Endereco.Numero, 5, tcStrZero);
        GravarCampo(Endereco.Complemento, 15, tcStr, True);
        GravarCampo(Endereco.Bairro, 15, tcStr, True);
        GravarCampo(Endereco.Cidade, 20, tcStr, True);
        GravarCampo(Endereco.CEP, 8, tcInt);
        GravarCampo(Endereco.Estado, 2, tcStr);
        GravarCampo(DataVencimento, 8, tcDat);
        GravarCampo(Valor, 15, tcDe2);
        GravarCampo(Abatimento, 15, tcDe2);
        GravarCampo(Desconto, 15, tcDe2);
        GravarCampo(Mora, 15, tcDe2);
        GravarCampo(Multa, 15, tcDe2);
        GravarCampo(CodigoDOC, 15, tcStr);
        GravarCampo(Aviso, 1, tcInt);
        GravarCampo(CodigoUG, 6, tcInt);
        GravarCampo(' ', 8, tcStr);
      end;

      ValidarLinha('B');
      IncluirLinha;
    end;
  end;
end;

procedure TArquivoW_Bradesco.GeraSegmentoJ52(
  mSegmentoJ52List: TSegmentoJ52List);
var
  J: Integer;
begin
  for J := 0 to mSegmentoJ52List.Count - 1 do
  begin
    FpLinha := '';

    with mSegmentoJ52List[J] do
    begin
      Inc(FQtdeRegistros);
      Inc(FQtdeRegistrosLote);
      Inc(FSequencialDoRegistroNoLote);

      GravarCampo(BancoToStr(PagFor.Geral.Banco), 3, tcStr);
      GravarCampo(FQtdeLotes, 4, tcInt);
      GravarCampo('3', 1, tcStr);
      GravarCampo(FSequencialDoRegistroNoLote, 5, tcInt);
      GravarCampo('J', 1, tcStr);
      GravarCampo(' ', 1, tcStr);
      GravarCampo('00', 2, tcStr);
      GravarCampo('52', 2, tcStr);
      GravarCampo(TpInscricaoToStr(Pagador.Inscricao.Tipo), 1, tcStr);
      GravarCampo(Pagador.Inscricao.Numero, 15, tcStrZero);
      GravarCampo(Pagador.Nome, 40, tcStr, True);
      GravarCampo(TpInscricaoToStr(Beneficiario.Inscricao.Tipo), 1, tcStr);
      GravarCampo(Beneficiario.Inscricao.Numero, 15, tcStrZero);
      GravarCampo(Beneficiario.Nome, 40, tcStr, True);

      if Chave = '' then
      begin
        GravarCampo(TpInscricaoToStr(SacadorAvalista.Inscricao.Tipo), 1, tcStr);
        GravarCampo(SacadorAvalista.Inscricao.Numero, 15, tcStrZero);
        GravarCampo(SacadorAvalista.Nome, 40, tcStr, True);
        GravarCampo(' ', 53, tcStr);
      end
      else
      begin
        GravarCampo(Chave, 79, tcStr);
        GravarCampo(TXID, 30, tcStr);
      end;

      ValidarLinha('J52');
      IncluirLinha;
    end;
  end;
end;

end.
