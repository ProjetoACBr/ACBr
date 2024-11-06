{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{ - Elias C�sar Vieira                                                         }
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

unit ACBrTEFAPIDestaxa;

interface

uses
  Classes, SysUtils,
  ACBrBase, ACBrTEFComum, ACBrTEFAPI, ACBrTEFAPIComum, ACBrTEFDestaxaComum;

type

  { TACBrTEFAPIDestaxa }

  TACBrTEFAPIDestaxa = class(TACBrTEFAPIComumClass)
  private
    fDestaxaClient: TACBrTEFDestaxaClient;

  public
    constructor Create(AACBrTEFAPI: TACBrTEFAPIComum);
    destructor Destroy; override;

    procedure Inicializar; override;
    procedure DesInicializar; override;

    function EfetuarPagamento(ValorPagto: Currency;Modalidade: TACBrTEFModalidadePagamento = tefmpNaoDefinido;
      CartoesAceitos: TACBrTEFTiposCartao = []; Financiamento: TACBrTEFModalidadeFinanciamento = tefmfNaoDefinido;
      Parcelas: Byte = 0; DataPreDatado: TDateTime = 0; DadosAdicionais: String = ''): Boolean; override;

    function EfetuarAdministrativa(OperacaoAdm: TACBrTEFOperacao = tefopAdministrativo): Boolean; overload; override;
    function EfetuarAdministrativa(const CodOperacaoAdm: String = ''): Boolean; overload; override;

    function CancelarTransacao(const NSU, CodigoAutorizacaoTransacao: String;DataHoraTransacao: TDateTime;Valor: Double;
      const CodigoFinalizacao: String = ''; const Rede: String = ''): Boolean; override;

    procedure FinalizarTransacao(
      const Rede, NSU, CodigoFinalizacao: String; AStatus: TACBrTEFStatusTransacao = tefstsSucessoAutomatico); override;

    procedure ResolverTransacaoPendente(AStatus: TACBrTEFStatusTransacao = tefstsSucessoManual); override;
    procedure AbortarTransacaoEmAndamento; override;
  end;

implementation

{ TACBrTEFAPIDestaxa }

constructor TACBrTEFAPIDestaxa.Create(AACBrTEFAPI: TACBrTEFAPIComum);
begin

end;

destructor TACBrTEFAPIDestaxa.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrTEFAPIDestaxa.Inicializar;
begin
  inherited Inicializar;
end;

procedure TACBrTEFAPIDestaxa.DesInicializar;
begin
  inherited DesInicializar;
end;

function TACBrTEFAPIDestaxa.EfetuarPagamento(ValorPagto: Currency; Modalidade: TACBrTEFModalidadePagamento; CartoesAceitos: TACBrTEFTiposCartao;
  Financiamento: TACBrTEFModalidadeFinanciamento; Parcelas: Byte; DataPreDatado: TDateTime; DadosAdicionais: String): Boolean;
begin
  Result := inherited EfetuarPagamento(ValorPagto, Modalidade, CartoesAceitos,
    Financiamento, Parcelas, DataPreDatado, DadosAdicionais);
end;

function TACBrTEFAPIDestaxa.EfetuarAdministrativa(OperacaoAdm: TACBrTEFOperacao): Boolean;
begin
  Result := inherited EfetuarAdministrativa(OperacaoAdm);
end;

function TACBrTEFAPIDestaxa.EfetuarAdministrativa(const CodOperacaoAdm: String): Boolean;
begin
  Result := inherited EfetuarAdministrativa(CodOperacaoAdm);
end;

function TACBrTEFAPIDestaxa.CancelarTransacao(const NSU, CodigoAutorizacaoTransacao: String; DataHoraTransacao: TDateTime;
  Valor: Double; const CodigoFinalizacao: String; const Rede: String): Boolean;
begin
  Result := inherited CancelarTransacao(NSU, CodigoAutorizacaoTransacao,
    DataHoraTransacao, Valor, CodigoFinalizacao, Rede);
end;

procedure TACBrTEFAPIDestaxa.FinalizarTransacao(const Rede, NSU, CodigoFinalizacao: String; AStatus: TACBrTEFStatusTransacao);
begin
  inherited FinalizarTransacao(Rede, NSU, CodigoFinalizacao, AStatus);
end;

procedure TACBrTEFAPIDestaxa.ResolverTransacaoPendente(AStatus: TACBrTEFStatusTransacao);
begin
  inherited ResolverTransacaoPendente(AStatus);
end;

procedure TACBrTEFAPIDestaxa.AbortarTransacaoEmAndamento;
begin
  inherited AbortarTransacaoEmAndamento;
end;

end.
