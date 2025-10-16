{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Renato Rubinho                                  }
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

{$I ACBr.inc}

unit ACBrLibExtratoAPIRespostas;

interface

uses
  Classes, SysUtils, Contnrs,
  ACBrBase, ACBrLibResposta, ACBrLibConfig,
  ACBrExtratoAPI, ACBrLibExtratoAPIConsts;

type
  { TLancamentoResposta }
  TLancamentoResposta = class(TACBrLibRespostaBase)
  private
    FDataLancamento: TDateTime;
    FDataMovimento: TDateTime;
    FDescricao: string;
    FInfoComplementar: string;
    FNumeroDocumento: string;
    FTipoOperacao: integer;
    FValor: Double;
    FIdentificador: string;
    FCPFCNPJ: string;
  public
    constructor Create(const Id: integer; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Clear;
    procedure Processar(const ALancamento: TACBrExtratoLancamento);
  published
    property Identificador: string read FIdentificador write FIdentificador;
    property NumeroDocumento: string read FNumeroDocumento write FNumeroDocumento;
    property DataLancamento: TDateTime read FDataLancamento write FDataLancamento;
    property DataMovimento: TDateTime read FDataMovimento write FDataMovimento;
    property TipoOperacao: integer read FTipoOperacao write FTipoOperacao;
    property Descricao: string read FDescricao write FDescricao;
    property InfoComplementar: string read FInfoComplementar write FInfoComplementar;
    property Valor: Double read FValor write FValor;
    property CPFCNPJ: string read FCPFCNPJ write FCPFCNPJ;
  end;

  { TExtratoResposta }
  TExtratoResposta = class(TACBrLibRespostaBase)
  private
    FQtd: integer;
    FItems: TACBrObjectList;
  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Clear;
    procedure Processar(const ACBrExtratoAPI: TACBrExtratoAPI);
  published
    property Quantidade: integer read FQtd write FQtd;
    property Items: TACBrObjectList read FItems;
  end;

implementation

{ TLancamentoResposta }
constructor TLancamentoResposta.Create(const Id: integer; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsulta + IntToStr(Id), ATipo, AFormato);

  Clear;
end;

destructor TLancamentoResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TLancamentoResposta.Clear;
begin
  FDataLancamento := 0;
  FDataMovimento := 0;
  FDescricao := EmptyStr;
  FInfoComplementar := EmptyStr;
  FNumeroDocumento := EmptyStr;
  FTipoOperacao := 0;
  FValor := 0;
  FIdentificador := EmptyStr;
  FCPFCNPJ := EmptyStr;
end;

procedure TLancamentoResposta.Processar(const ALancamento: TACBrExtratoLancamento);
begin
  Self.DataLancamento := ALancamento.DataLancamento;
  Self.DataMovimento := ALancamento.DataMovimento;
  Self.Descricao := ALancamento.Descricao;
  Self.InfoComplementar := ALancamento.InfoComplementar;
  Self.NumeroDocumento := ALancamento.NumeroDocumento;
  Self.TipoOperacao := Integer(ALancamento.TipoOperacao);
  Self.Valor := ALancamento.Valor;
  Self.Identificador := ALancamento.Identificador;
  Self.CPFCNPJ := ALancamento.CPFCNPJ;
end;

{ TExtratoResposta }
constructor TExtratoResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoExtratoLancamento, ATipo, AFormato);

  FItems := TACBrObjectList.Create;
  Clear;
end;

destructor TExtratoResposta.Destroy;
begin
  FItems.Free;

  inherited Destroy;
end;

procedure TExtratoResposta.Clear;
begin
  FQtd := 0;
  FItems.Clear;
end;

procedure TExtratoResposta.Processar(const ACBrExtratoAPI: TACBrExtratoAPI);
var
  I: integer;
  Item: TLancamentoResposta;
begin
  FQtd := ACBrExtratoAPI.ExtratoConsultado.Lancamentos.Count;
  for I := 0 to FQtd - 1 do
  begin
    Item := TLancamentoResposta.Create(I + 1, Tipo, Codificacao);
    Item.Processar(ACBrExtratoAPI.ExtratoConsultado.Lancamentos[I]);
    FItems.Add(Item);
  end;
end;

end.

