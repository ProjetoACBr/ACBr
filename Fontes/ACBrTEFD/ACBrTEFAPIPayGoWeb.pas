{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrTEFAPIPayGoWeb;

interface

uses
  Classes, SysUtils,
  ACBrBase,
  ACBrTEFComum, ACBrTEFAPI, ACBrTEFAPIComum, ACBrTEFPayGoComum, ACBrTEFPayGoWebComum;

const
  CSUBDIRETORIO_PAYGOWEB = 'PGWeb';

type

  { TACBrTEFAPIClassPayGoWeb }

  TACBrTEFAPIClassPayGoWeb = class(TACBrTEFAPIClass)
  private
    fDiretorioTrabalho: String;
    fTEFPayGoAPI: TACBrTEFPGWebAPI;
    fpndReqNum: String;
    fPndLocRef: String;
    fPndExtRef: String;
    fPndVirtMerch: String;
    fPndAuthSyst: String;
    fOperacaoVenda: Byte;
    fOperacaoAdministrativa: Byte;
    fOperacaoCancelamento: Byte;
    fAutorizador: String;

    procedure QuandoGravarLogAPI(const ALogLine: String; var Tratado: Boolean);
    procedure QuandoExibirQRCodeAPI(const Dados: String);
    procedure QuandoExibirMensagemAPI( Mensagem: String;
      Terminal: TACBrTEFPGWebAPITerminalMensagem;
      MilissegundosExibicao: Integer);
    procedure QuandoAguardaPinPadAPI( OperacaoPinPad: TACBrTEFPGWebAPIOperacaoPinPad;
      var Cancelar: Boolean);
    procedure QuandoPerguntarMenuAPI( Titulo: String; Opcoes: TStringList;
      var ItemSelecionado: Integer; var Cancelado: Boolean);
    procedure QuandoPerguntarCampoAPI(
      DefinicaoCampo: TACBrTEFPGWebAPIDefinicaoCampo;
      var Resposta: String; var Validado: Boolean; var Cancelado: Boolean);

    procedure QuandoAvaliarTransacaoPendenteAPI(var Status: LongWord;
      pszReqNum: String; pszLocRef: String; pszExtRef: String; pszVirtMerch: String;
      pszAuthSyst: String);

    procedure LimparUltimaTransacaoPendente;
    procedure SetDiretorioTrabalho(const AValue: String);

    function DadoPinPadToMsg(ADadoPinPad: TACBrTEFAPIDadoPinPad): Word;

  protected
    procedure InicializarChamadaAPI(AMetodoOperacao: TACBrTEFAPIMetodo); override;
    procedure InterpretarRespostaAPI; override;

  public
    constructor Create(AACBrTEFAPI: TACBrTEFAPIComum);
    destructor Destroy; override;

    procedure Inicializar; override;
    procedure DesInicializar; override;

    function EfetuarPagamento(
      ValorPagto: Currency;
      Modalidade: TACBrTEFModalidadePagamento = tefmpNaoDefinido;
      CartoesAceitos: TACBrTEFTiposCartao = [];
      Financiamento: TACBrTEFModalidadeFinanciamento = tefmfNaoDefinido;
      Parcelas: Byte = 0;
      DataPreDatado: TDateTime = 0;
      DadosAdicionais: String = ''): Boolean; override;

    function EfetuarAdministrativa(
      OperacaoAdm: TACBrTEFOperacao = tefopAdministrativo): Boolean; overload; override;
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

    procedure ResolverTransacaoPendente(
      AStatus: TACBrTEFStatusTransacao = tefstsSucessoManual); override;
    procedure AbortarTransacaoEmAndamento; override;

    procedure ExibirMensagemPinPad(const MsgPinPad: String); override;
    function ObterDadoPinPad(TipoDado: TACBrTEFAPIDadoPinPad; TimeOut: integer = 30000;
      MinLen: SmallInt = 0; MaxLen: SmallInt = 0): String; override;
    function VerificarPresencaPinPad: Byte; override;

    property TEFPayGoAPI: TACBrTEFPGWebAPI read fTEFPayGoAPI;
    property DiretorioTrabalho: String read fDiretorioTrabalho write SetDiretorioTrabalho;

    property OperacaoVenda: Byte read fOperacaoVenda
      write fOperacaoVenda default PWOPER_SALE;
    property OperacaoAdministrativa: Byte read fOperacaoAdministrativa
      write fOperacaoAdministrativa default PWOPER_ADMIN;
    property OperacaoCancelamento: Byte read fOperacaoCancelamento
      write fOperacaoCancelamento default PWOPER_SALEVOID;
    property Autorizador: String read fAutorizador write fAutorizador;
  end;

implementation

uses
  math, TypInfo,
  ACBrUtil.Strings,
  ACBrUtil.Base,
  ACBrUtil.FilesIO;

{ TACBrTEFAPIClassPayGoWeb }

constructor TACBrTEFAPIClassPayGoWeb.Create(AACBrTEFAPI: TACBrTEFAPIComum);
begin
  inherited;

  fpTEFRespClass := TACBrTEFRespPayGoWeb;

  fOperacaoVenda := PWOPER_SALE;
  fOperacaoAdministrativa := PWOPER_ADMIN;
  fOperacaoCancelamento := PWOPER_SALEVOID;
  fAutorizador := '';

  fTEFPayGoAPI := TACBrTEFPGWebAPI.Create;
  fTEFPayGoAPI.OnGravarLog := QuandoGravarLogAPI;
  fTEFPayGoAPI.OnExibeQRCode := QuandoExibirQRCodeAPI;
  fTEFPayGoAPI.OnExibeMensagem := QuandoExibirMensagemAPI;
  fTEFPayGoAPI.OnAguardaPinPad := QuandoAguardaPinPadAPI;
  fTEFPayGoAPI.OnExibeMenu := QuandoPerguntarMenuAPI;
  fTEFPayGoAPI.OnObtemCampo := QuandoPerguntarCampoAPI;
end;

destructor TACBrTEFAPIClassPayGoWeb.Destroy;
begin
  fTEFPayGoAPI.Free;
  inherited;
end;

procedure TACBrTEFAPIClassPayGoWeb.Inicializar;
var
  i, P: Integer;
  ADir, IpStr, PortaStr: String;
begin
  if Inicializado then
    Exit;

  if (fDiretorioTrabalho = '') then
    ADir := PathWithDelim(fpACBrTEFAPI.DiretorioTrabalho) + CSUBDIRETORIO_PAYGOWEB
  else
    ADir := fDiretorioTrabalho;

  IpStr := fpACBrTEFAPI.DadosTerminal.EnderecoServidor;
  PortaStr := '';
  p := pos(':', IpStr);
  if (p > 0) then
  begin
    PortaStr := copy(IpStr, p+1, Length(IpStr));
    IpStr := copy(IpStr, 1, p-1);
  end;

  fTEFPayGoAPI.DiretorioTrabalho := ADir;
  fTEFPayGoAPI.EnderecoIP := IpStr;
  fTEFPayGoAPI.PortaTCP := PortaStr;
  fTEFPayGoAPI.NomeAplicacao := fpACBrTEFAPI.DadosAutomacao.NomeAplicacao;
  fTEFPayGoAPI.VersaoAplicacao := fpACBrTEFAPI.DadosAutomacao.VersaoAplicacao;
  fTEFPayGoAPI.SoftwareHouse := fpACBrTEFAPI.DadosAutomacao.NomeSoftwareHouse;
  fTEFPayGoAPI.NomeEstabelecimento := fpACBrTEFAPI.DadosEstabelecimento.RazaoSocial;
  fTEFPayGoAPI.SuportaSaque := fpACBrTEFAPI.DadosAutomacao.SuportaSaque;
  fTEFPayGoAPI.SuportaDesconto := fpACBrTEFAPI.DadosAutomacao.SuportaDesconto;
  fTEFPayGoAPI.SuportaViasDiferenciadas := fpACBrTEFAPI.DadosAutomacao.SuportaViasDiferenciadas;
  fTEFPayGoAPI.ImprimeViaClienteReduzida := fpACBrTEFAPI.DadosAutomacao.ImprimeViaClienteReduzida;
  fTEFPayGoAPI.UtilizaSaldoTotalVoucher := fpACBrTEFAPI.DadosAutomacao.UtilizaSaldoTotalVoucher;
  i := Integer(TACBrTEFAPI(fpACBrTEFAPI).ExibicaoQRCode);
  fTEFPayGoAPI.ExibicaoQRCode := TACBrTEFPGWebAPIExibicaoQRCode(i);

  fTEFPayGoAPI.ConfirmarTransacoesPendentesNoHost := (fpACBrTEFAPI.TratamentoTransacaoPendente = tefpenConfirmar);
  if (fpACBrTEFAPI.TratamentoTransacaoPendente = tefpenPerguntar) then
    fTEFPayGoAPI.OnAvaliarTransacaoPendente := QuandoAvaliarTransacaoPendenteAPI
  else
    fTEFPayGoAPI.OnAvaliarTransacaoPendente := Nil;

  fTEFPayGoAPI.Inicializar;

  LimparUltimaTransacaoPendente;

  inherited;
end;

procedure TACBrTEFAPIClassPayGoWeb.DesInicializar;
begin
  fTEFPayGoAPI.DesInicializar;
  inherited;
end;

procedure TACBrTEFAPIClassPayGoWeb.InicializarChamadaAPI(
  AMetodoOperacao: TACBrTEFAPIMetodo);
begin
  inherited;
  LimparUltimaTransacaoPendente;
  // PayGoWeb n�o consegue efetuar nova Opera��o, se a anterior ficou pendente
  fpACBrTEFAPI.ConfirmarTransacoesPendentes;
end;

procedure TACBrTEFAPIClassPayGoWeb.InterpretarRespostaAPI;
begin
  inherited;
  fpACBrTEFAPI.UltimaRespostaTEF.ViaClienteReduzida := fpACBrTEFAPI.DadosAutomacao.ImprimeViaClienteReduzida;
  DadosDaTransacaoToTEFResp( fTEFPayGoAPI.DadosDaTransacao,
                             fpACBrTEFAPI.UltimaRespostaTEF );
end;

procedure TACBrTEFAPIClassPayGoWeb.QuandoGravarLogAPI(const ALogLine: String;
  var Tratado: Boolean);
begin
  fpACBrTEFAPI.GravarLog(ALogLine);
  Tratado := True;
end;

procedure TACBrTEFAPIClassPayGoWeb.QuandoPerguntarCampoAPI(
  DefinicaoCampo: TACBrTEFPGWebAPIDefinicaoCampo; var Resposta: String;
  var Validado: Boolean; var Cancelado: Boolean);
Var
  DefCampo: TACBrTEFAPIDefinicaoCampo;
  p: Integer;
begin
  DefCampo.TituloPergunta := DefinicaoCampo.Titulo;
  DefCampo.MascaraDeCaptura := DefinicaoCampo.MascaraDeCaptura;
  DefCampo.TamanhoMinimo := DefinicaoCampo.TamanhoMinimo;
  DefCampo.TamanhoMaximo := DefinicaoCampo.TamanhoMaximo;
  DefCampo.ValorMinimo := DefinicaoCampo.ValorMinimo;
  DefCampo.ValorMaximo := DefinicaoCampo.ValorMaximo;
  DefCampo.OcultarDadosDigitados := DefinicaoCampo.OcultarDadosDigitados;

  case DefinicaoCampo.TiposEntradaPermitidos of
    pgApenasLeitura: DefCampo.TipoDeEntrada := tedApenasLeitura;
    pgtNumerico: DefCampo.TipoDeEntrada := tedNumerico;
    pgtAlfabetico: DefCampo.TipoDeEntrada := tedAlfabetico;
    pgtAlfaNum: DefCampo.TipoDeEntrada := tedAlfaNum;
  else
    DefCampo.TipoDeEntrada := tedTodos;
  end;

  case DefinicaoCampo.ValidacaoDado of
    pgvNaoVazio: DefCampo.ValidacaoDado := valdNaoVazio;
    pgvDigMod10: DefCampo.ValidacaoDado := valdDigMod10;
    pgvCPF_CNPJ: DefCampo.ValidacaoDado := valdCPFouCNPJ;
    pgvMMAA: DefCampo.ValidacaoDado := valdMesAno;
    pgvDDMMAA: DefCampo.ValidacaoDado := valdDiaMesAno;
    pgvDuplaDigitacao: DefCampo.ValidacaoDado := valdDuplaDigitacao;
    pgvSenhaLojista: DefCampo.ValidacaoDado := valdSenhaLojista;
    pgvSenhaTecnica: DefCampo.ValidacaoDado := valdSenhaTecnica;
    pgvQuantidadeParcelas: DefCampo.ValidacaoDado := valdQuantidadeParcelas;
  else
    DefCampo.ValidacaoDado := valdNenhuma;
  end;

  TACBrTEFAPI(fpACBrTEFAPI).QuandoPerguntarCampo(
    DefCampo, Resposta, Validado, Cancelado );

  // Remove Ponto Decimal, se houver
  p := pos('.', Resposta);
  if (p > 0) and (p = (Length(Resposta)-2)) then
    Delete(Resposta, p, 1);
end;

procedure TACBrTEFAPIClassPayGoWeb.QuandoPerguntarMenuAPI(Titulo: String;
  Opcoes: TStringList; var ItemSelecionado: Integer; var Cancelado: Boolean);
begin
  TACBrTEFAPI(fpACBrTEFAPI).QuandoPerguntarMenu(
    Titulo, Opcoes, ItemSelecionado);

  Cancelado := (ItemSelecionado < 0);
end;

procedure TACBrTEFAPIClassPayGoWeb.QuandoExibirMensagemAPI(Mensagem: String;
  Terminal: TACBrTEFPGWebAPITerminalMensagem; MilissegundosExibicao: Integer);
var
  TelaMsg: TACBrTEFAPITela;
begin
  case Terminal of
    tmOperador: TelaMsg := telaOperador;
    tmCliente: TelaMsg := telaCliente;
  else
    TelaMsg := telaTodas;
  end;

  TACBrTEFAPI(fpACBrTEFAPI).QuandoExibirMensagem(
    Mensagem,
    TelaMsg,
    MilissegundosExibicao );
end;

procedure TACBrTEFAPIClassPayGoWeb.QuandoAguardaPinPadAPI(
  OperacaoPinPad: TACBrTEFPGWebAPIOperacaoPinPad; var Cancelar: Boolean);
var
  Op: TACBrTEFAPIOperacaoAPI;
begin
  if not Assigned(TACBrTEFAPI(fpACBrTEFAPI).QuandoEsperarOperacao) then
    Exit;

  case OperacaoPinPad of
    ppGetCard, ppGetPIN, ppGoOnChip, ppFinishChip:
      Op := opapiPinPadLerCartao;
    ppGetData, ppConfirmData, ppGenericCMD, ppDataConfirmation, ppGetUserData:
      Op := opapiPinPadDigitacao;
    ppDisplay:
      Op := opapiPinPad;
    ppRemoveCard:
      Op := opapiRemoveCartao;
    ppLerQRCode:
      Op := opapiLeituraQRCode;
  else
    Op := opapiPinPad;
  end;

  Cancelar := False;
  TACBrTEFAPI(fpACBrTEFAPI).QuandoEsperarOperacao( Op, Cancelar );
end;

procedure TACBrTEFAPIClassPayGoWeb.QuandoExibirQRCodeAPI(const Dados: String);
begin
  if not Assigned(TACBrTEFAPI(fpACBrTEFAPI).QuandoExibirQRCode) then
    fpACBrTEFAPI.DoException( Format(ACBrStr(sACBrTEFAPIEventoInvalidoException),
                                     ['QuandoExibirQRCode']));

  TACBrTEFAPI(fpACBrTEFAPI).QuandoExibirQRCode(Dados);
end;

procedure TACBrTEFAPIClassPayGoWeb.QuandoAvaliarTransacaoPendenteAPI(
  var Status: LongWord; pszReqNum: String; pszLocRef: String;
  pszExtRef: String; pszVirtMerch: String; pszAuthSyst: String);
var
  MsgErro: String;
begin
  fpndReqNum := pszReqNum;
  fPndLocRef := pszLocRef;
  fPndExtRef := pszExtRef;
  fPndVirtMerch := pszVirtMerch;
  fPndAuthSyst := pszAuthSyst;

  MsgErro := Format(ACBrStr(sACBrTEFAPITransacaoPendente), [pszAuthSyst, pszExtRef]);
  fpACBrTEFAPI.ProcessarTransacaoPendente(MsgErro);
  Status := 0;
end;

function TACBrTEFAPIClassPayGoWeb.EfetuarAdministrativa(
  OperacaoAdm: TACBrTEFOperacao): Boolean;
begin
  Result := Self.EfetuarAdministrativa( IntToStr(OperacaoAdminToPWOPER_(OperacaoAdm)) );
end;

function TACBrTEFAPIClassPayGoWeb.EfetuarAdministrativa(const CodOperacaoAdm: string): Boolean;
var
  PA: TACBrTEFParametros;
  OpInt: Integer;
  OpByte: Byte;
begin
  PA := TACBrTEFParametros.Create;
  try
    OpByte := fOperacaoAdministrativa;
    if (CodOperacaoAdm <> '') then
    begin
      OpInt := StrToIntDef(CodOperacaoAdm, -1);
      if (OpInt >= 0) then
      begin
       if (OpInt <= High(Byte)) then
         OpByte := OpInt;
      end;
    end;

    if (fAutorizador <> '') then
      PA.ValueInfo[PWINFO_AUTHSYST] := fAutorizador;

    if (fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao <> '') then
      PA.ValueInfo[PWINFO_FISCALREF] := fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao;

    fTEFPayGoAPI.IniciarTransacao(OpByte, PA);
    Result := fTEFPayGoAPI.ExecutarTransacao;
  finally
    PA.Free;
  end;
end;

function TACBrTEFAPIClassPayGoWeb.EfetuarPagamento(ValorPagto: Currency;
  Modalidade: TACBrTEFModalidadePagamento; CartoesAceitos: TACBrTEFTiposCartao;
  Financiamento: TACBrTEFModalidadeFinanciamento; Parcelas: Byte;
  DataPreDatado: TDateTime; DadosAdicionais: String): Boolean;
var
  PA: TACBrTEFParametros;
  SomaCartoes, ModalidadeInt, FinanciamentoInt: Integer;
  ValDbl: Double;
begin
  VerificarIdentificadorVendaInformado;
  if (ValorPagto <= 0) then
    fpACBrTEFAPI.DoException(sACBrTEFAPIValorPagamentoInvalidoException);

  PA := TACBrTEFParametros.Create;
  try
    PA.Text := DadosAdicionais;

    ValDbl := ValorPagto * 100;
    PA.ValueInfo[PWINFO_FISCALREF] := fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao;
    PA.ValueInfo[PWINFO_CURREXP] := '2'; // centavos
    PA.ValueInfo[PWINFO_TOTAMNT] := IntToStr(Trunc(RoundTo(ValDbl,-2)));
    PA.ValueInfo[PWINFO_CURRENCY] := IntToStr(fpACBrTEFAPI.DadosAutomacao.MoedaISO4217); // '986' ISO4217 - BRL

    case Modalidade of
      tefmpCartao: ModalidadeInt := 1;
      tefmpDinheiro: ModalidadeInt := 2;
      tefmpCheque: ModalidadeInt := 4;
      tefmpCarteiraVirtual: ModalidadeInt := 8;
    else
      ModalidadeInt := 0;
    end;
    if (ModalidadeInt > 0) then
      PA.ValueInfo[PWINFO_PAYMNTTYPE] := IntToStr(ModalidadeInt);

    SomaCartoes := 0;
    if teftcCredito in CartoesAceitos then
      Inc(SomaCartoes, 1);
    if teftcDebito in CartoesAceitos then
      Inc(SomaCartoes, 2);
    if teftcVoucher in CartoesAceitos then
      Inc(SomaCartoes, 4);
    if teftcPrivateLabel in CartoesAceitos then
      Inc(SomaCartoes, 8);
    if teftcFrota in CartoesAceitos then
      Inc(SomaCartoes, 16);
    if teftcOutros in CartoesAceitos then
      Inc(SomaCartoes, 128);
    if (SomaCartoes > 0) then
      PA.ValueInfo[PWINFO_CARDTYPE] := IntToStr(SomaCartoes);

    case Financiamento of
      tefmfAVista: FinanciamentoInt := 1;
      tefmfParceladoEmissor: FinanciamentoInt := 2;
      tefmfParceladoEstabelecimento: FinanciamentoInt := 4;
      tefmfPredatado: FinanciamentoInt := 8;
      tefmfCreditoEmissor: FinanciamentoInt := 16;
    else
      FinanciamentoInt := 0;
    end;
    if (FinanciamentoInt > 0) then
      PA.ValueInfo[PWINFO_FINTYPE] := IntToStr(FinanciamentoInt);

    if (Parcelas > 0) then
      PA.ValueInfo[PWINFO_INSTALLMENTS] := IntToStr(Parcelas);

    if (DataPreDatado <> 0) then
      PA.ValueInfo[PWINFO_INSTALLMDATE] := FormatDateTime('ddmmyy', DataPreDatado);

    if (fAutorizador <> '') then
      PA.ValueInfo[PWINFO_AUTHSYST] := fAutorizador;

    fTEFPayGoAPI.IniciarTransacao(fOperacaoVenda, PA);
    Result := fTEFPayGoAPI.ExecutarTransacao;
  finally
    PA.Free;
  end;
end;

procedure TACBrTEFAPIClassPayGoWeb.FinalizarTransacao(const Rede, NSU,
  CodigoFinalizacao: String; AStatus: TACBrTEFStatusTransacao);
var
  i: Integer;
  Resp: TACBrTEFResp;
  PGWebStatus: LongWord;
begin
  i := fpACBrTEFAPI.RespostasTEF.AcharTransacao(Rede, NSU, CodigoFinalizacao);
  if (i >= 0) then
    Resp := fpACBrTEFAPI.RespostasTEF[i]
  else
    fpACBrTEFAPI.DoException( Format(ACBrStr(sACBrTEFAPITransacaoNaoEncontradaException),
      [Rede+' '+ NSU+' '+CodigoFinalizacao]) );

  PGWebStatus := StatusTransacaoToPWCNF_(AStatus);
  fTEFPayGoAPI.FinalizarTransacao( PGWebStatus,
                                   IntToStr(Resp.NumeroLoteTransacao),
                                   Resp.Finalizacao,
                                   Resp.NSU,
                                   Resp.Estabelecimento,
                                   Resp.Rede );
end;

function TACBrTEFAPIClassPayGoWeb.CancelarTransacao(const NSU,
  CodigoAutorizacaoTransacao: string; DataHoraTransacao: TDateTime;
  Valor: Double; const CodigoFinalizacao: string; const Rede: string): Boolean;
var
  PA: TACBrTEFParametros;
  i: Integer;
  Resp: TACBrTEFResp;

  procedure CopiarValorDaUltimaResposta(AInfo: Integer);
  var
    AStr: String;
  begin
    AStr := Resp.LeInformacao(AInfo).AsString;
    if (Trim(AStr) <> '') then
      PA.ValueInfo[AInfo] := AStr;
  end;

begin
  PA := TACBrTEFParametros.Create;
  try
    PA.ValueInfo[PWINFO_TRNORIGNSU] := NSU;
    PA.ValueInfo[PWINFO_TRNORIGDATE] := FormatDateTime('DDMMYY', DataHoraTransacao);
    PA.ValueInfo[PWINFO_TRNORIGTIME] := FormatDateTime('hhnnss', DataHoraTransacao);
    //PA.ValueInfo[PWINFO_TRNORIGDATETIME] := FormatDateTime('YYYYMMDDhhnnss', DataHoraTransacao);
    PA.ValueInfo[PWINFO_TRNORIGAMNT] :=  IntToStr(Trunc(RoundTo(Valor * 100,-2)));
    PA.ValueInfo[PWINFO_TRNORIGAUTH] := CodigoAutorizacaoTransacao;
    PA.ValueInfo[PWINFO_TRNORIGAUTHCODE] := CodigoAutorizacaoTransacao;

    if (Rede <> '') and (CodigoFinalizacao <> '') then
    begin
      i := fpACBrTEFAPI.RespostasTEF.AcharTransacao(Rede, NSU, CodigoFinalizacao);
      if (i >= 0) then
      begin
        Resp := fpACBrTEFAPI.RespostasTEF[i];
        PA.ValueInfo[PWINFO_TRNORIGLOCREF] := Resp.Finalizacao;
        PA.ValueInfo[PWINFO_TRNORIGREQNUM] := IntToStr(Resp.NumeroLoteTransacao);
        //CopiarValorDaUltimaResposta(PWINFO_MERCHCNPJCPF);
        CopiarValorDaUltimaResposta(PWINFO_CARDTYPE);
        CopiarValorDaUltimaResposta(PWINFO_VIRTMERCH);
        CopiarValorDaUltimaResposta(PWINFO_AUTMERCHID);
        CopiarValorDaUltimaResposta(PWINFO_FINTYPE);
      end;
    end;

    if (Rede <> '') then
      PA.ValueInfo[PWINFO_AUTHSYST] := Rede
    else if (fAutorizador <> '') then
      PA.ValueInfo[PWINFO_AUTHSYST] := fAutorizador;

    fTEFPayGoAPI.IniciarTransacao(fOperacaoCancelamento, PA);
    Result := fTEFPayGoAPI.ExecutarTransacao;
  finally
    PA.Free;
  end;
end;

procedure TACBrTEFAPIClassPayGoWeb.ResolverTransacaoPendente(
  AStatus: TACBrTEFStatusTransacao);
var
  PGWebStatus: LongWord;
begin
  // Se n�o foi disparado por QuandoAvaliarTransacaoPendenteAPI, pegue as
  //   informa��es da Transa��o atual, na mem�ria
  if (fpndReqNum = '') then
  begin
    with fpACBrTEFAPI.UltimaRespostaTEF do
    begin
      fpndReqNum := LeInformacao(PWINFO_REQNUM,0).AsString;
      fPndLocRef := LeInformacao(PWINFO_AUTLOCREF,0).AsString;
      fPndExtRef := LeInformacao(PWINFO_AUTEXTREF,0).AsString;
      fPndVirtMerch := LeInformacao(PWINFO_VIRTMERCH,0).AsString;
      fPndAuthSyst := LeInformacao(PWINFO_AUTHSYST,0).AsString;
    end;
  end;

  if (fpndReqNum = '') then
    fpACBrTEFAPI.DoException(sACBrTEFAPISemTransacaoPendenteException);

  PGWebStatus := StatusTransacaoToPWCNF_(AStatus);
  fTEFPayGoAPI.FinalizarTransacao(PGWebStatus,
          fpndReqNum, fPndLocRef, fPndExtRef, fPndVirtMerch, fPndAuthSyst);
  LimparUltimaTransacaoPendente;
end;

procedure TACBrTEFAPIClassPayGoWeb.AbortarTransacaoEmAndamento;
begin
  fTEFPayGoAPI.AbortarTransacao;
end;

procedure TACBrTEFAPIClassPayGoWeb.ExibirMensagemPinPad(const MsgPinPad: String);
begin
  fTEFPayGoAPI.ExibirMensagemPinPad(MsgPinPad);
end;

function TACBrTEFAPIClassPayGoWeb.ObterDadoPinPad(
  TipoDado: TACBrTEFAPIDadoPinPad; TimeOut: integer; MinLen: SmallInt;
  MaxLen: SmallInt): String;
var
  TipoMsg: Word;
begin
  TipoMsg := DadoPinPadToMsg(TipoDado);
  if (TipoMsg < 1) then
  begin
    fpACBrTEFAPI.DoException(Format(ACBrStr(sACBrTEFAPICapturaNaoSuportada),
      [GetEnumName(TypeInfo(TACBrTEFAPIDadoPinPad), integer(TipoDado) ), ClassName] ));
  end;

  if (MinLen = 0) and (MaxLen = 0) then
    CalcularTamanhosCampoDadoPinPad(TipoDado, MinLen, MaxLen);

  Result := fTEFPayGoAPI.ObterDadoPinPad( TipoMsg,
                                          MinLen, MaxLen,
                                          Trunc(TimeOut/1000) );
end;

function TACBrTEFAPIClassPayGoWeb.VerificarPresencaPinPad: Byte;
begin
  Result := fTEFPayGoAPI.VerificarPresencaPinPad;
end;

procedure TACBrTEFAPIClassPayGoWeb.LimparUltimaTransacaoPendente;
begin
  fpndReqNum := '';
  fPndLocRef := '';
  fPndExtRef := '';
  fPndVirtMerch := '';
  fPndAuthSyst := '';
end;

procedure TACBrTEFAPIClassPayGoWeb.SetDiretorioTrabalho(const AValue: String);
begin
  if fDiretorioTrabalho = AValue then Exit;

  if Inicializado then
    fpACBrTEFAPI.DoException(Format(ACBrStr(sACBrTEFAPIComponenteInicializadoException),
                                     ['TACBrTEFAPIClassPayGoWeb.DiretorioTrabalho']));

  fDiretorioTrabalho := AValue;
end;

function TACBrTEFAPIClassPayGoWeb.DadoPinPadToMsg(
  ADadoPinPad: TACBrTEFAPIDadoPinPad): Word;
begin
  case ADadoPinPad of
    dpDDD: Result := PWDPIN_DIGITE_O_DDD;
    dpRedDDD: Result := PWDPIN_REDIGITE_O_DDD;
    dpFone: Result := PWDPIN_DIGITE_O_TELEFONE;
    dpRedFone: Result := PWDPIN_REDIGITE_O_TELEFONE;
    dpDDDeFone: Result := PWDPIN_DIGITE_DDD_TELEFONE;
    dpRedDDDeFone: Result := PWDPIN_REDIGITE_DDD_TELEFONE;
    dpCPF: Result := PWDPIN_DIGITE_O_CPF;
    dpRedCPF: Result := PWDPIN_REDIGITE_O_CPF;
    dpRG: Result := PWDPIN_DIGITE_O_RG;
    dpRedRG: Result := PWDPIN_REDIGITE_O_RG;
    dp4UltDigitos: Result := PWDPIN_DIGITE_OS_4_ULTIMOS_DIGITOS;
    dpCodSeguranca: Result := PWDPIN_DIGITE_CODIGO_DE_SEGURANCA;
    dpCNPJ: Result := PWDPIN_DIGITE_O_CNPJ;
    dpRedCNPJ: Result := PWDPIN_REDIGITE_O_CNPJ;
  else
    Result := 0;
  end;
end;

end.
