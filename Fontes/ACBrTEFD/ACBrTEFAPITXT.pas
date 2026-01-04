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

unit ACBrTEFAPITXT;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils,
  ACBrBase,
  ACBrTEFComum, ACBrTEFAPI, ACBrTEFAPIComum, ACBrTEFTXTComum, ACBrTEFTXTGerenciadorPadrao;

resourcestring
  CINFOTEFTXT_EnviandoRequisicao = 'Enviando Requisição';
  CINFOTEFTXT_AguardandoSts = 'Aguardando Status';
  CINFOTEFTXT_AguardandoResp ='Aguardando Resposta';

type

  TACBrTEFTXTModelo = (teftxtNenhum, teftxtGerenciadorPadrao, teftxtPayGo, teftxtSiTEF);

  { TACBrTEFAPIClassTXT }

  TACBrTEFAPIClassTXT = class(TACBrTEFAPIClass)
  private
    fAguardandoResposta: Boolean;
    fModelo: TACBrTEFTXTModelo;
    fTEFTXT: TACBrTEFTXTBaseClass;

    procedure QuandoGravarLogAPI(const ALogLine: String; var Tratado: Boolean);
    procedure QuandoAguardarArquivoAPI( ArquivoAguardado: String;
      SegundosParaTimeOut: Double; var Interromper: Boolean);
    procedure QuandoMudarStatusAPI(Sender: TObject);
    procedure SetModelo(AValue: TACBrTEFTXTModelo);

  protected
    procedure InterpretarRespostaAPI; override;
    procedure CarregarRespostasPendentes(const AListaRespostasTEF: TACBrTEFAPIRespostas); override;

  public
    constructor Create(AACBrTEFAPI: TACBrTEFAPIComum);
    destructor Destroy; override;

    procedure Inicializar; override;

    function EfetuarPagamento(
      ValorPagto: Currency;
      Modalidade: TACBrTEFModalidadePagamento = tefmpNaoDefinido;
      CartoesAceitos: TACBrTEFTiposCartao = [];
      Financiamento: TACBrTEFModalidadeFinanciamento = tefmfNaoDefinido;
      Parcelas: Byte = 0;
      DataPreDatado: TDateTime = 0;
      DadosAdicionais: String = ''): Boolean; override;

    function EfetuarAdministrativa(
      CodOperacaoAdm: TACBrTEFOperacao = tefopAdministrativo): Boolean; overload; override;
    function EfetuarAdministrativa(
      const CodOperacaoAdm: string = ''): Boolean; overload; override;

    function CancelarTransacao(
      const NSU, CodigoAutorizacaoTransacao: string;
      DataHoraTransacao: TDateTime;
      Valor: Double;
      const CodigoFinalizacao: string = '';
      const Rede: string = ''): Boolean; override;

    procedure FinalizarTransacao(
      const Rede, NSU, CodigoFinalizacao: String;
      AStatus: TACBrTEFStatusTransacao = tefstsSucessoAutomatico); override;

    procedure ResolverTransacaoPendente(AStatus: TACBrTEFStatusTransacao = tefstsSucessoManual); override;
    procedure AbortarTransacaoEmAndamento; override;
    procedure FinalizarVenda; override;

    procedure ExibirMensagemPinPad(const MsgPinPad: String); override;
    function ObterDadoPinPad(TipoDado: TACBrTEFAPIDadoPinPad;
      TimeOut: Integer = 30000; MinLen: SmallInt = 0; MaxLen: SmallInt = 0): String; override;
    function VerificarPresencaPinPad: Byte; override;
    function VersaoAPI: String; override;

    procedure ObterListaImagensPinPad(ALista: TStrings); override;

    procedure ExibirImagemPinPad(const NomeImagem: String); override;
    procedure ApagarImagemPinPad(const NomeImagem: String); override;
    procedure CarregarImagemPinPad(const NomeImagem: String; AStream: TStream;
      TipoImagem: TACBrTEFAPIImagemPinPad ); override;

    property TEFTXT: TACBrTEFTXTBaseClass read fTEFTXT;
    property Modelo: TACBrTEFTXTModelo read fModelo write SetModelo;
    property AguardandoResposta: Boolean read fAguardandoResposta;
  end;


implementation

uses
  ACBrUtil.Strings;

{ TACBrTEFAPIClassTXT }

constructor TACBrTEFAPIClassTXT.Create(AACBrTEFAPI: TACBrTEFAPIComum);
begin
  inherited;
  fAguardandoResposta := False;
  fTEFTXT := Nil;
  fModelo := teftxtNenhum;
  SetModelo(teftxtGerenciadorPadrao);
end;

destructor TACBrTEFAPIClassTXT.Destroy;
begin
  fTEFTXT.Free;
  inherited Destroy;
end;

procedure TACBrTEFAPIClassTXT.Inicializar;
begin
  AbortarTransacaoEmAndamento;
  inherited Inicializar;
end;

procedure TACBrTEFAPIClassTXT.SetModelo(AValue: TACBrTEFTXTModelo);
var
  lEventoObterId: TACBrTEFTXTObterID;
  lEventoGravarRequisicao: TACBrTEFTXTAntesGravarRequisicao;
begin
  if fModelo = AValue then Exit;

  lEventoObterId := Nil;
  lEventoGravarRequisicao := Nil;
  if Assigned(fTEFTXT) then
  begin
    lEventoObterId := fTEFTXT.QuandoObterID;
    lEventoGravarRequisicao := fTEFTXT.AntesGravarRequisicao;
    fTEFTXT.Free
  end;

  case AValue of
    teftxtPayGo:
      begin
        //TODO
        fTEFTXT := TACBrTEFTXTGerenciadorPadrao.Create;
        fpTEFRespClass := TACBrTEFRespTXTGerenciadorPadrao;
      end;
    teftxtSiTEF:
      begin
        //TODO
        fTEFTXT := TACBrTEFTXTGerenciadorPadrao.Create;
        fpTEFRespClass := TACBrTEFRespTXTGerenciadorPadrao;
      end;
  else
    fTEFTXT := TACBrTEFTXTGerenciadorPadrao.Create;
    fpTEFRespClass := TACBrTEFRespTXTGerenciadorPadrao;
  end;

  fTEFTXT.QuandoGravarLog := QuandoGravarLogAPI;
  fTEFTXT.QuandoAguardarArquivo := QuandoAguardarArquivoAPI;
  fTEFTXT.QuandoMudarStatus := QuandoMudarStatusAPI;
  fTEFTXT.QuandoObterID := lEventoObterId;
  fTEFTXT.AntesGravarRequisicao := lEventoGravarRequisicao;

  fModelo := AValue;
end;

procedure TACBrTEFAPIClassTXT.QuandoGravarLogAPI(const ALogLine: String;  var Tratado: Boolean);
begin
  fpACBrTEFAPI.GravarLog(ALogLine);
  Tratado := True;
end;

procedure TACBrTEFAPIClassTXT.QuandoAguardarArquivoAPI(ArquivoAguardado: String;
  SegundosParaTimeOut: Double; var Interromper: Boolean);
var
  msg: String;
begin
  msg := Format( ACBrStr(CInfoAguardandoResposta),
                 [fTEFTXT.ModeloTEF, FormatFloat('##0',abs(SegundosParaTimeOut))] );
  TACBrTEFAPI(fpACBrTEFAPI).QuandoExibirMensagem( msg, telaTodas, -1);

  TACBrTEFAPI(fpACBrTEFAPI).QuandoEsperarOperacao(opapiAguardaUsuario, Interromper);
  if not Interromper then
    Interromper := (fAguardandoResposta = False);
end;

procedure TACBrTEFAPIClassTXT.QuandoMudarStatusAPI(Sender: TObject);
var
  msg: String;
begin
  msg := '';
  case fTEFTXT.Status of
    tefstEnviandoRequisicao: msg := CINFOTEFTXT_EnviandoRequisicao;
    tefstAguardandoSts: msg := CINFOTEFTXT_AguardandoSts;
    tefstAguardandoResp: msg := CINFOTEFTXT_AguardandoResp;
  end;

  fAguardandoResposta := (fTEFTXT.Status in [tefstAguardandoSts, tefstAguardandoResp]);
  TACBrTEFAPI(fpACBrTEFAPI).QuandoExibirMensagem( msg, telaTodas, -1);
end;

procedure TACBrTEFAPIClassTXT.InterpretarRespostaAPI;
begin
  fpACBrTEFAPI.UltimaRespostaTEF.Clear;
  fTEFTXT.Resp.SalvarArquivo(fpACBrTEFAPI.UltimaRespostaTEF.Conteudo.Conteudo);
  //D Arrumar espacos

  fpACBrTEFAPI.UltimaRespostaTEF.ConteudoToProperty;
end;

procedure TACBrTEFAPIClassTXT.CarregarRespostasPendentes(
  const AListaRespostasTEF: TACBrTEFAPIRespostas);
begin
  inherited CarregarRespostasPendentes(AListaRespostasTEF);
end;

function TACBrTEFAPIClassTXT.EfetuarPagamento(ValorPagto: Currency;
  Modalidade: TACBrTEFModalidadePagamento; CartoesAceitos: TACBrTEFTiposCartao;
  Financiamento: TACBrTEFModalidadeFinanciamento; Parcelas: Byte;
  DataPreDatado: TDateTime; DadosAdicionais: String): Boolean;
begin
  Result := inherited EfetuarPagamento(ValorPagto, Modalidade, CartoesAceitos,
    Financiamento, Parcelas, DataPreDatado, DadosAdicionais);
end;

function TACBrTEFAPIClassTXT.EfetuarAdministrativa(CodOperacaoAdm: TACBrTEFOperacao): Boolean;
begin
  EfetuarAdministrativa('');
end;

function TACBrTEFAPIClassTXT.EfetuarAdministrativa(const CodOperacaoAdm: string): Boolean;
begin
  Result := False;
  if (fTEFTXT is TACBrTEFTXTGerenciadorPadrao) then
    Result := TACBrTEFTXTGerenciadorPadrao(fTEFTXT).ADM;
end;

function TACBrTEFAPIClassTXT.CancelarTransacao(const NSU,
  CodigoAutorizacaoTransacao: string; DataHoraTransacao: TDateTime;
  Valor: Double; const CodigoFinalizacao: string; const Rede: string): Boolean;
begin
  Result := inherited CancelarTransacao(NSU, CodigoAutorizacaoTransacao,
    DataHoraTransacao, Valor, CodigoFinalizacao, Rede);
end;

procedure TACBrTEFAPIClassTXT.FinalizarTransacao(const Rede, NSU,
  CodigoFinalizacao: String; AStatus: TACBrTEFStatusTransacao);
begin
  inherited FinalizarTransacao(Rede, NSU, CodigoFinalizacao, AStatus);
end;

procedure TACBrTEFAPIClassTXT.ResolverTransacaoPendente(
  AStatus: TACBrTEFStatusTransacao);
begin
  inherited ResolverTransacaoPendente(AStatus);
end;

procedure TACBrTEFAPIClassTXT.AbortarTransacaoEmAndamento;
begin
  fAguardandoResposta := False;
end;

procedure TACBrTEFAPIClassTXT.FinalizarVenda;
begin
  inherited FinalizarVenda;
end;

procedure TACBrTEFAPIClassTXT.ExibirMensagemPinPad(const MsgPinPad: String);
begin
  inherited ExibirMensagemPinPad(MsgPinPad);
end;

function TACBrTEFAPIClassTXT.ObterDadoPinPad(TipoDado: TACBrTEFAPIDadoPinPad;
  TimeOut: Integer; MinLen: SmallInt; MaxLen: SmallInt): String;
begin
  Result := inherited ObterDadoPinPad(TipoDado, TimeOut, MinLen, MaxLen);
end;

function TACBrTEFAPIClassTXT.VerificarPresencaPinPad: Byte;
begin
  Result := inherited VerificarPresencaPinPad;
end;

function TACBrTEFAPIClassTXT.VersaoAPI: String;
begin
  Result := inherited VersaoAPI;
end;

procedure TACBrTEFAPIClassTXT.ObterListaImagensPinPad(ALista: TStrings);
begin
  inherited ObterListaImagensPinPad(ALista);
end;

procedure TACBrTEFAPIClassTXT.ExibirImagemPinPad(const NomeImagem: String);
begin
  inherited ExibirImagemPinPad(NomeImagem);
end;

procedure TACBrTEFAPIClassTXT.ApagarImagemPinPad(const NomeImagem: String);
begin
  inherited ApagarImagemPinPad(NomeImagem);
end;

procedure TACBrTEFAPIClassTXT.CarregarImagemPinPad(const NomeImagem: String;
  AStream: TStream; TipoImagem: TACBrTEFAPIImagemPinPad);
begin
  inherited CarregarImagemPinPad(NomeImagem, AStream, TipoImagem);
end;

end.

