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
  ACBrBase,
  ACBrTEFComum,
  ACBrTEFAPI,
  ACBrTEFAPIComum,
  ACBrUtil.Strings,
  ACBrTEFDestaxaComum;

type 

  { TACBrTEFRespDestaxa }

  TACBrTEFRespDestaxa = class(TACBrTEFResp)
  public
    procedure ConteudoToProperty; override;
  end;

  { TACBrTEFAPIClassDestaxa }

  TACBrTEFAPIClassDestaxa = class(TACBrTEFAPIClass)
  private
    fDestaxaClient: TACBrTEFDestaxaClient;

    function DestaxaClient: TACBrTEFDestaxaClient;

    procedure QuandoExibirQRCodeAPI(const aDados: String);
    procedure QuandoGravarLogAPI(const aLogLine: String; var Tratado: Boolean);
    procedure QuandoExibirMensagemAPI(aMensagem: String; MilissegundosExibicao: Integer; var Cancelar: Boolean);
    procedure QuandoPerguntarMenuAPI(aMensagem: String; aOpcoes: TSplitResult; var aOpcao: Integer; var Cancelado: Boolean);
    procedure QuandoPerguntarCampoAPI(aMensagem, aMascara: String; aTipo: TACBrTEFDestaxaColetaTipo; var Resposta: String; var Cancelar: Boolean);

    function ExibirMenuAdministrativo: Boolean;
  protected
    procedure InterpretarRespostaAPI; override;
    procedure InicializarChamadaAPI(aMetodoOperacao: TACBrTEFAPIMetodo); override;
    procedure FinalizarChamadaAPI; override;

    //procedure CarregarRespostasPendentes(const AListaRespostasTEF: TACBrTEFAPIRespostas); override;
  public
    constructor Create(aACBrTEFAPI: TACBrTEFAPIComum);
    destructor Destroy; override;

    procedure Inicializar; override;
    procedure DesInicializar; override;

    procedure FinalizarTransacao(const Rede, NSU, CodigoFinalizacao: String; AStatus: TACBrTEFStatusTransacao = tefstsSucessoAutomatico); override;

    procedure ResolverTransacaoPendente(aStatus: TACBrTEFStatusTransacao = tefstsSucessoManual); override;
    procedure AbortarTransacaoEmAndamento; override;

    procedure ExibirMensagemPinPad(const MsgPinPad: String); override;
              
    function VerificarPresencaPinPad: Byte; override;
    function EfetuarPagamento(ValorPagto: Currency; Modalidade: TACBrTEFModalidadePagamento = tefmpNaoDefinido;
      CartoesAceitos: TACBrTEFTiposCartao = []; Financiamento: TACBrTEFModalidadeFinanciamento = tefmfNaoDefinido;
      Parcelas: Byte = 0; DataPreDatado: TDateTime = 0; DadosAdicionais: String = ''): Boolean; override;

    function TesteComunicacao: Boolean;
    function EfetuarAdministrativa(OperacaoAdm: TACBrTEFOperacao = tefopAdministrativo): Boolean; overload; override;
    function EfetuarAdministrativa(const CodOperacaoAdm: String = ''): Boolean; overload; override;

    function CancelarTransacao(const NSU, CodigoAutorizacaoTransacao: String;DataHoraTransacao: TDateTime;Valor: Double;
      const CodigoFinalizacao: String = ''; const Rede: String = ''): Boolean; override;

    function ObterDadoPinPad(TipoDado: TACBrTEFAPIDadoPinPad; TimeOut: Integer = 30000; MinLen: SmallInt = 0; MaxLen: SmallInt = 0): String; override;
  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Math, math, DateUtils;

{ TACBrTEFRespDestaxa }

procedure TACBrTEFRespDestaxa.ConteudoToProperty;

  procedure ConteudoToParcelas(resp: TACBrTEFDestaxaTransacaoResposta);
  var
    i: Integer;
    venc: TDateTime;
    parc_val, saldo: Double;
    parc: TACBrTEFRespParcela;
    vencs, valores: TSplitResult;
  begin
    Parcelas.Clear;
    if (resp.transacao_parcela > 0) then
      QtdParcelas := resp.transacao_parcela;

    if NaoEstaVazio(resp.transacao_administradora) then
      valores := Split(';', resp.transacao_parcela_valor);

    if NaoEstaVazio(resp.transacao_parcela_vencimento) then
      vencs := Split(';', resp.transacao_parcela_vencimento);
    
    for i := 0 to Length(valores) - 1 do
    begin
      parc := TACBrTEFRespParcela.Create;
      parc.Valor := StrToFloatDef(valores[i], 0);

      if (Length(vencs) >= (i+1)) then
        parc.Vencimento := StrToDateDef(vencs[i], 0);
      Parcelas.Add(parc);
    end;

    if EstaZerado(Parcelas.Count) and (QtdParcelas > 0) then
    begin
      saldo := resp.transacao_valor;
      parc_val := RoundABNT((saldo / QtdParcelas), -2);
      venc := IncDay(DateOf(resp.transacao_data), 30);
      for i := 1 to QtdParcelas do
      begin
        parc := TACBrTEFRespParcela.Create;
        parc.Vencimento := venc;

        if (i = QtdParcelas) then
          parc.Valor := saldo
        else
          parc.Valor := parc_val;

        Parcelas.Add(parc);
        venc := IncDay(venc, 30);
        saldo := saldo - parc_val;
      end;
    end;
  end;

var
  wResp: String;
  wDestaxaResposta: TACBrTEFDestaxaTransacaoResposta;
begin
  wResp := Conteudo.LeInformacao(899, 201).AsString;
  if EstaVazio(wResp) then
    Exit;

  wDestaxaResposta := TACBrTEFDestaxaTransacaoResposta.Create;
  try
    wDestaxaResposta.AsString := StringToBinaryString(wResp);

    if (wDestaxaResposta.servico = dxsIniciar) then
    begin
      Confirmar := False;
      Sucesso := wDestaxaResposta.estado.Conectado;
      Exit;
    end;

    fpCNFEnviado := (UpperCase(Conteudo.LeInformacao(899,1).AsString) = 'S');
    Sucesso := (wDestaxaResposta.transacao_resposta = 0);
    Confirmar := (wDestaxaResposta.retorno = drsSucessoComConfirmacao) or
                 ((wDestaxaResposta.transacao = CDESTAXA_ADM_PENDENTE) and NaoEstaVazio(wDestaxaResposta.transacao_nsu));
    Rede := wDestaxaResposta.transacao_rede;
    NSU := wDestaxaResposta.transacao_nsu;
    TextoEspecialOperador := wDestaxaResposta.mensagem;
    BIN := wDestaxaResposta.transacao_cartao_numero;
    ValorTotal := wDestaxaResposta.transacao_valor;
    NSU_TEF := wDestaxaResposta.transacao_nsu_rede;
    DataHoraTransacaoLocal := wDestaxaResposta.transacao_data;
    DataHoraTransacaoHost := wDestaxaResposta.transacao_data;
    DataVencimento := wDestaxaResposta.transacao_vencimento;
    TaxaServico := StrToFloatDef(wDestaxaResposta.transacao_valor_taxa_servico, 0);

    NFCeSAT.Bandeira := wDestaxaResposta.transacao_administradora;
    NFCeSAT.Autorizacao := wDestaxaResposta.transacao_autorizacao;
    NFCeSAT.CNPJCredenciadora := wDestaxaResposta.transacao_rede_cnpj;
    if NaoEstaVazio(wDestaxaResposta.transacao_cartao_numero) and (Length(wDestaxaResposta.transacao_cartao_numero) >= 4) then
      NFCeSAT.UltimosQuatroDigitos := RightStr(wDestaxaResposta.transacao_cartao_numero, 4);

    CodigoBandeiraPadrao := wDestaxaResposta.codigo_bandeira;
    NomeAdministradora := wDestaxaResposta.transacao_administradora;
    CodigoAutorizacaoTransacao := wDestaxaResposta.transacao_autorizacao;

    Credito := (wDestaxaResposta.transacao_tipo_cartao = dtcCredito);
    Debito := wDestaxaResposta.transacao_tipo_cartao = dtcDebito;

    ImagemComprovante1aVia.Text := wDestaxaResposta.transacao_comprovante_1via.Text;
    ImagemComprovante2aVia.Text := wDestaxaResposta.transacao_comprovante_2via.Text;

    ConteudoToParcelas(wDestaxaResposta);
    case wDestaxaResposta.transacao_financiado of
      dxfAdministradora: ParceladoPor := parcADM;
      dxfEstabelecimento: ParceladoPor := parcLoja;
    end;

    case wDestaxaResposta.transacao_pagamento of
      dpgAVista: TipoOperacao := opAvista;
      dpgParcelado: TipoOperacao := opParcelado;
      dpgPreDatado: TipoOperacao := opPreDatado;
    end;
  finally
    wDestaxaResposta.Free;
  end;
end;

{ TACBrTEFAPIClassDestaxa }

function TACBrTEFAPIClassDestaxa.DestaxaClient: TACBrTEFDestaxaClient;
var
  p: Integer;
begin
  if (not Assigned(fDestaxaClient)) then
  begin
    fDestaxaClient := TACBrTEFDestaxaClient.Create;
    fDestaxaClient.Loja := fpACBrTEFAPI.DadosTerminal.CodEmpresa;
    fDestaxaClient.Terminal := fpACBrTEFAPI.DadosTerminal.CodTerminal;
    fDestaxaClient.Aplicacao := fpACBrTEFAPI.DadosAutomacao.NomeAplicacao;
    //fDestaxaClient.AplicacaoTela := fpACBrTEFAPI.DadosTerminal.CodEmpresa;
    fDestaxaClient.AplicacaoVersao := fpACBrTEFAPI.DadosAutomacao.VersaoAplicacao;
    fDestaxaClient.Estabelecimento := fpACBrTEFAPI.DadosEstabelecimento.CNPJ;
    fDestaxaClient.OnGravarLog := QuandoGravarLogAPI;
    fDestaxaClient.OnColetarOpcao := QuandoPerguntarMenuAPI;
    fDestaxaClient.OnColetarInformacao := QuandoPerguntarCampoAPI;
    fDestaxaClient.OnExibirMensagem := QuandoExibirMensagemAPI;
    fDestaxaClient.OnExibirQRCode := QuandoExibirQRCodeAPI;
    fDestaxaClient.OnAguardarResposta := TACBrTEFAPI(fpACBrTEFAPI).QuandoEsperarOperacao;

    if NaoEstaVazio(fpACBrTEFAPI.DadosTerminal.EnderecoServidor) then
    begin
      p := Pos(':', fpACBrTEFAPI.DadosTerminal.EnderecoServidor);
      fDestaxaClient.EnderecoIP := Copy(fpACBrTEFAPI.DadosTerminal.EnderecoServidor, 1, p-1);
      fDestaxaClient.Porta := Copy(fpACBrTEFAPI.DadosTerminal.EnderecoServidor, p+1, Length(fpACBrTEFAPI.DadosTerminal.EnderecoServidor));
    end;
  end;
  Result := fDestaxaClient;
end;

procedure TACBrTEFAPIClassDestaxa.QuandoExibirQRCodeAPI(const aDados: String);
begin
  if (not Assigned(TACBrTEFAPI(fpACBrTEFAPI).QuandoExibirQRCode)) then
    fpACBrTEFAPI.DoException(Format(ACBrStr(sACBrTEFAPIEventoInvalidoException), ['QuandoExibirQRCode']));
  TACBrTEFAPI(fpACBrTEFAPI).QuandoExibirQRCode(aDados);
end;

procedure TACBrTEFAPIClassDestaxa.QuandoGravarLogAPI(const aLogLine: String; var Tratado: Boolean);
begin
  fpACBrTEFAPI.GravarLog(ALogLine);
  Tratado := True;
end;

procedure TACBrTEFAPIClassDestaxa.QuandoExibirMensagemAPI(aMensagem: String; MilissegundosExibicao: Integer; var Cancelar: Boolean);
begin
  TACBrTEFAPI(fpACBrTEFAPI).QuandoExibirMensagem(aMensagem, telaTodas, MilissegundosExibicao);
end;

procedure TACBrTEFAPIClassDestaxa.QuandoPerguntarMenuAPI(aMensagem: String;aOpcoes: TSplitResult; var aOpcao: Integer; var Cancelado: Boolean);
var
  i: Integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := 0 to Length(aOpcoes) - 1 do
      sl.Add(aOpcoes[i]);

    TACBrTEFAPI(fpACBrTEFAPI).QuandoPerguntarMenu(aMensagem, sl, aOpcao);
    Cancelado := (aOpcao < 0);
  finally
    sl.Free;
  end;
end;

procedure TACBrTEFAPIClassDestaxa.QuandoPerguntarCampoAPI(aMensagem,
  aMascara: String; aTipo: TACBrTEFDestaxaColetaTipo; var Resposta: String; var Cancelar: Boolean);
var
  Validado: Boolean;
  Def: TACBrTEFAPIDefinicaoCampo;
begin
  Validado := False;
  Def.TamanhoMinimo := 0;
  Def.TamanhoMaximo := 0;
  Def.TipoDeEntrada := tedTodos;
  Def.TituloPergunta := aMensagem;
  Def.ValidacaoDado := valdNenhuma;
  Def.OcultarDadosDigitados := False;
  Def.NaoRemoverMascaraResposta := True;

  if (aMascara = CDESTAXA_MASCARA_DATA1) then
    Def.MascaraDeCaptura := '**/**/**'
  else if (aMascara = CDESTAXA_MASCARA_DATA2) then
    Def.MascaraDeCaptura := '**/**/****'
  else if (aMascara = CDESTAXA_MASCARA_VALIDADE) then
    Def.MascaraDeCaptura := '**/**'
  else if (aMascara = CDESTAXA_MASCARA_DECIMAL) then
    Def.MascaraDeCaptura := '@,@@'
  else
    Def.MascaraDeCaptura := aMascara;

  case aTipo of
    dctNaoExibivel: Def.TipoDeEntrada := tedApenasLeitura;
    dctAlfabetico: Def.TipoDeEntrada := tedAlfabetico;
    dctDataHora: Def.TipoDeEntrada := tedAlfaNum;
    dctNumerico: Def.TipoDeEntrada := tedNumerico;
  end;

  TACBrTEFAPI(fpACBrTEFAPI).QuandoPerguntarCampo(Def, Resposta, Validado, Cancelar);
end;

function TACBrTEFAPIClassDestaxa.ExibirMenuAdministrativo: Boolean;
var
  wOpcao: Integer;
  sr: TSplitResult;
  Cancelar: Boolean;
begin
  wOpcao := -1;
  Result := False;
  Cancelar := False;
  DestaxaClient.Requisicao.sequencial := DestaxaClient.UltimoSequencial+1;
  DestaxaClient.Socket.Consultar;

  if (DestaxaClient.Resposta.servico <> dxsConsultar) or
     (DestaxaClient.Resposta.retorno = drsErroDesconhecido) or
     EstaVazio(DestaxaClient.Resposta.transacao) then
    Exit;

  sr := Split(';', DestaxaClient.Resposta.transacao);

  QuandoPerguntarMenuAPI(CDESTAXA_MENU_ADMIN, sr, wOpcao, Cancelar);

  if (wOpcao >= 0) then
  begin
    DestaxaClient.Requisicao.sequencial := DestaxaClient.UltimoSequencial+1;
    Result := DestaxaClient.ExecutarTransacao(sr[wOpcao]);
  end;
end;

procedure TACBrTEFAPIClassDestaxa.InterpretarRespostaAPI;
var
  resp: String;
begin
  resp := BinaryStringToString(DestaxaClient.Resposta.AsString);

  AtualizarHeader;
  fpACBrTEFAPI.UltimaRespostaTEF.Clear;
  fpACBrTEFAPI.UltimaRespostaTEF.Conteudo.GravaInformacao(899, 201, resp);
  fpACBrTEFAPI.UltimaRespostaTEF.DocumentoVinculado := fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao;
  fpACBrTEFAPI.UltimaRespostaTEF.ViaClienteReduzida := fpACBrTEFAPI.DadosAutomacao.ImprimeViaClienteReduzida;
  fpACBrTEFAPI.UltimaRespostaTEF.ConteudoToProperty;
end;

procedure TACBrTEFAPIClassDestaxa.InicializarChamadaAPI(aMetodoOperacao: TACBrTEFAPIMetodo);
begin
  inherited InicializarChamadaAPI(aMetodoOperacao);
  DestaxaClient.IniciarRequisicao;
end;

procedure TACBrTEFAPIClassDestaxa.FinalizarChamadaAPI;
begin
  inherited FinalizarChamadaAPI;
  if DestaxaClient.Socket.EmTransacao then
  begin
    DestaxaClient.Requisicao.sequencial := DestaxaClient.UltimoSequencial+1;
    DestaxaClient.FinalizarRequisicao;
  end;
end;

constructor TACBrTEFAPIClassDestaxa.Create(aACBrTEFAPI: TACBrTEFAPIComum);
begin
  inherited Create(aACBrTEFAPI);
  fpTEFRespClass := TACBrTEFRespDestaxa;
end;

destructor TACBrTEFAPIClassDestaxa.Destroy;
begin
  if Assigned(fDestaxaClient) then
    fDestaxaClient.Free;
  inherited Destroy;
end;

procedure TACBrTEFAPIClassDestaxa.Inicializar;
var
  wErro: Integer;
begin
  inherited;
  wErro := DestaxaClient.Socket.Conectar;
  if NaoEstaZerado(wErro) then
    raise EACBrTEFDestaxaErro.Create(
      ACBrStr(
        'Erro ao conectar Destaxa Client' + sLineBreak +
        'Endere�o: ' + DestaxaClient.EnderecoIP + sLineBreak +
        'Porta: ' + DestaxaClient.Porta + sLineBreak +
        'Erro: ' + IntToStr(wErro) + '-' + DestaxaClient.Socket.LastErrorDesc));
  fpInicializado := True;
end;

procedure TACBrTEFAPIClassDestaxa.DesInicializar;
begin
  DestaxaClient.Socket.Conectar;
  inherited DesInicializar;
end;

function TACBrTEFAPIClassDestaxa.EfetuarPagamento(ValorPagto: Currency; Modalidade: TACBrTEFModalidadePagamento; CartoesAceitos: TACBrTEFTiposCartao;
  Financiamento: TACBrTEFModalidadeFinanciamento; Parcelas: Byte; DataPreDatado: TDateTime; DadosAdicionais: String): Boolean;
begin
  if NaoEstaZerado(ValorPagto) then
    DestaxaClient.Requisicao.transacao_valor := ValorPagto;

  if (Modalidade = tefmpCarteiraVirtual) then
  begin
    DestaxaClient.DigitalPagar;
    Exit;
  end;

  case Financiamento of
    tefmfAVista: DestaxaClient.Requisicao.transacao_pagamento := dpgAVista;
    tefmfPredatado: DestaxaClient.Requisicao.transacao_pagamento := dpgPreDatado;
    tefmfParceladoEmissor:
    begin
      DestaxaClient.Requisicao.transacao_pagamento := dpgParcelado;
      DestaxaClient.Requisicao.transacao_financiado := dxfAdministradora;
    end;
    tefmfParceladoEstabelecimento:
    begin
      DestaxaClient.Requisicao.transacao_pagamento := dpgParcelado;
      DestaxaClient.Requisicao.transacao_financiado := dxfEstabelecimento;
    end;
  end;

  if (teftcCredito in CartoesAceitos) and (not (teftcDebito in CartoesAceitos)) then
    DestaxaClient.Requisicao.transacao_tipo_cartao := dtcCredito;
  if (teftcDebito in CartoesAceitos) and (not (teftcCredito in CartoesAceitos)) then
    DestaxaClient.Requisicao.transacao_tipo_cartao := dtcDebito;

  if (DestaxaClient.Requisicao.transacao_pagamento <> dpgAVista) and NaoEstaZerado(Parcelas) then
    DestaxaClient.Requisicao.transacao_parcela := Parcelas;

  if NaoEstaZerado(DataPreDatado) then
    DestaxaClient.Requisicao.transacao_vencimento := DataPreDatado;

  Result := DestaxaClient.CartaoVender;
end;

function TACBrTEFAPIClassDestaxa.TesteComunicacao: Boolean;
var
  wIniciarTransacao: Boolean;
begin
  wIniciarTransacao := (not DestaxaClient.Socket.EmTransacao);
  if wIniciarTransacao then
    DestaxaClient.IniciarRequisicao;
  try
    Result := DestaxaClient.Resposta.estado.Conectado;
  finally
    if wIniciarTransacao then
      DestaxaClient.FinalizarRequisicao;
  end;
end;

function TACBrTEFAPIClassDestaxa.EfetuarAdministrativa(OperacaoAdm: TACBrTEFOperacao): Boolean;
var
  transacao: String;
begin
  transacao := EmptyStr;

  case OperacaoAdm of
    tefopCancelamento: transacao := CDESTAXA_ADM_CANCELAR;
    tefopReimpressao: transacao := CDESTAXA_ADM_REIMPRIMIR;
    tefopTesteComunicacao:
    begin
      Result := TesteComunicacao;
      Exit;
    end;
  end;

  Result := EfetuarAdministrativa(transacao);
end;

function TACBrTEFAPIClassDestaxa.EfetuarAdministrativa(const CodOperacaoAdm: String): Boolean;
begin
  if EstaVazio(CodOperacaoAdm) then
  begin
    Result := ExibirMenuAdministrativo;
    Exit;
  end;
      
  DestaxaClient.Requisicao.sequencial := DestaxaClient.UltimoSequencial+1;
  DestaxaClient.Requisicao.retorno := drqExecutarServico;
  DestaxaClient.Socket.Executar(CodOperacaoAdm);
end;

function TACBrTEFAPIClassDestaxa.CancelarTransacao(const NSU, CodigoAutorizacaoTransacao: String; DataHoraTransacao: TDateTime;
  Valor: Double; const CodigoFinalizacao: String; const Rede: String): Boolean;
begin
  DestaxaClient.IniciarRequisicao;
  try
    if NaoEstaVazio(NSU) then
      DestaxaClient.Requisicao.transacao_nsu := NSU;
    if NaoEstaZerado(DataHoraTransacao) then
      DestaxaClient.Requisicao.transacao_data := DataHoraTransacao;
    if NaoEstaZerado(Valor) then
      DestaxaClient.Requisicao.transacao_valor := Valor;

    Result := DestaxaClient.AdministracaoCancelar;
  finally
    DestaxaClient.FinalizarRequisicao;
  end;
end;

procedure TACBrTEFAPIClassDestaxa.ExibirMensagemPinPad(const MsgPinPad: String);
var
  Msg: TACBrTEFDestaxaMensagem;
begin
  Msg := StringToDestaxaMensagem(MsgPinPad);
  DestaxaClient.IniciarRequisicao;
  try
    DestaxaClient.Requisicao.sequencial := DestaxaClient.UltimoSequencial+1;
    DestaxaClient.Requisicao.retorno := drqExecutarServico;
    DestaxaClient.Socket.Mostrar(Msg);
  finally
    DestaxaClient.FinalizarRequisicao;
  end;
end;

function TACBrTEFAPIClassDestaxa.ObterDadoPinPad(TipoDado: TACBrTEFAPIDadoPinPad; TimeOut: Integer; MinLen: SmallInt; MaxLen: SmallInt): String;
begin
  DestaxaClient.IniciarRequisicao;
  try
    DestaxaClient.Requisicao.sequencial := DestaxaClient.UltimoSequencial+1;
    DestaxaClient.Requisicao.retorno := drqExecutarServico;

    Result := DestaxaClient.Socket.Coletar(TipoDado, MinLen, MaxLen, TimeOut);
  finally
    DestaxaClient.FinalizarRequisicao;
  end;
end;

procedure TACBrTEFAPIClassDestaxa.FinalizarTransacao(const Rede, NSU,
  CodigoFinalizacao: String; AStatus: TACBrTEFStatusTransacao);
begin
  DestaxaClient.Requisicao.Clear;
  if DestaxaClient.Socket.EmTransacao then
  begin
    if aStatus in [tefstsSucessoManual, tefstsSucessoAutomatico] then
      DestaxaClient.Requisicao.retorno := drqConfirmarTransacao
    else
      DestaxaClient.Requisicao.retorno := drqCancelarTransacao;

    DestaxaClient.Requisicao.sequencial := DestaxaClient.UltimoSequencial;
    DestaxaClient.ExecutarTransacao(DestaxaClient.Resposta.transacao);
  end
  else if (fpACBrTEFAPI.UltimaRespostaTEF.NSU = NSU) then
    ResolverTransacaoPendente(AStatus);
end;

{procedure TACBrTEFAPIClassDestaxa.CarregarRespostasPendentes(const AListaRespostasTEF: TACBrTEFAPIRespostas);
var
  ultNSU: String;
  wResp: TACBrTEFResp;
begin
  ultNSU := EmptyStr;
  DestaxaClient.Socket.ColetaAutomatica := False;
  DestaxaClient.IniciarRequisicao;
  try
    DestaxaClient.Requisicao.sequencial := DestaxaClient.UltimoSequencial+1;
    DestaxaClient.Requisicao.retorno := drqExecutarServico;
    DestaxaClient.ExecutarTransacaoSilenciosa(CDESTAXA_ADM_PENDENTE);
    if NaoEstaZerado(DestaxaClient.Resposta.automacao_coleta_sequencial) and
       NaoEstaVazio(DestaxaClient.Resposta.transacao_nsu) then
    begin
      while (DestaxaClient.ColetaResposta.automacao_coleta_retorno = dcrExecutarProcedimento) and
            (DestaxaClient.ColetaResposta.transacao_nsu <> ultNSU) do
      begin
        ultNSU := DestaxaClient.ColetaResposta.transacao_nsu;
        wResp := TACBrTEFRespDestaxa.Create;
        try
          wResp.Conteudo.GravaInformacao(899, 201, DestaxaClient.ColetaResposta.AsString);
          wResp.ConteudoToProperty;

          AListaRespostasTEF.AdicionarRespostaTEF(wResp);
        finally
          wResp.Free;
        end;

        DestaxaClient.ColetaRequisicao.automacao_coleta_retorno := dcrExecutarProcedimento;
        DestaxaClient.ColetaRequisicao.automacao_coleta_sequencial := DestaxaClient.ColetaResposta.automacao_coleta_sequencial;
        DestaxaClient.ColetaRequisicao.automacao_coleta_informacao := CDESTAXA_ADM_ANTERIOR;
        DestaxaClient.Socket.ExecutarColeta;
      end;

      DestaxaClient.ColetaRequisicao.automacao_coleta_retorno := dcrExecutarProcedimento;
      DestaxaClient.ColetaRequisicao.automacao_coleta_sequencial := DestaxaClient.ColetaResposta.automacao_coleta_sequencial;
      DestaxaClient.ColetaRequisicao.automacao_coleta_informacao := CDESTAXA_ADM_FECHAR;
      DestaxaClient.Socket.ExecutarColeta;
    end;
  finally
    DestaxaClient.Socket.ColetaAutomatica := True;
    DestaxaClient.FinalizarRequisicao;
  end;
end;}

procedure TACBrTEFAPIClassDestaxa.ResolverTransacaoPendente(aStatus: TACBrTEFStatusTransacao);
var
  achou: Boolean;
  status, nsu, ultNSU: String;
begin
  status := EmptyStr;
  ultNSU := EmptyStr;
  achou := False;
  nsu := fpACBrTEFAPI.UltimaRespostaTEF.NSU;

  case aStatus of
    tefstsSucessoAutomatico, tefstsSucessoManual: status := CDESTAXA_ADM_CONFIRMAR;
    tefstsErroImpressao, tefstsErroDispesador, tefstsErroEnergia, tefstsErroDiverso: status := CDESTAXA_ADM_DESFAZER;
  end;

  DestaxaClient.IniciarRequisicao;
  DestaxaClient.Socket.ColetaAutomatica := False;
  try
    DestaxaClient.Requisicao.sequencial := DestaxaClient.UltimoSequencial+1;
    DestaxaClient.Requisicao.retorno := drqExecutarServico;
    DestaxaClient.ExecutarTransacaoSilenciosa(CDESTAXA_ADM_PENDENTE);
    if NaoEstaZerado(DestaxaClient.Resposta.automacao_coleta_sequencial) and
       NaoEstaVazio(DestaxaClient.Resposta.transacao_nsu) then
    begin
      while (DestaxaClient.ColetaResposta.automacao_coleta_retorno = dcrExecutarProcedimento) and
            (DestaxaClient.ColetaResposta.transacao_nsu <> ultNSU) do
      begin
        ultNSU := DestaxaClient.ColetaResposta.transacao_nsu;

        achou := (DestaxaClient.ColetaResposta.transacao_nsu = nsu);
        if achou then
          DestaxaClient.ColetaRequisicao.automacao_coleta_informacao := status
        else
          DestaxaClient.ColetaRequisicao.automacao_coleta_informacao := CDESTAXA_ADM_ANTERIOR;

        DestaxaClient.ColetaRequisicao.automacao_coleta_retorno := dcrExecutarProcedimento;
        DestaxaClient.ColetaRequisicao.automacao_coleta_sequencial := DestaxaClient.ColetaResposta.automacao_coleta_sequencial;
        DestaxaClient.Socket.ExecutarColeta;
      end;

      if (not achou) then
      begin
        DestaxaClient.ColetaRequisicao.automacao_coleta_retorno := dcrExecutarProcedimento;
        DestaxaClient.ColetaRequisicao.automacao_coleta_sequencial := DestaxaClient.ColetaResposta.automacao_coleta_sequencial;
        DestaxaClient.ColetaRequisicao.automacao_coleta_informacao := CDESTAXA_ADM_FECHAR;
        DestaxaClient.Socket.ExecutarColeta;
      end;
    end;
  finally
    DestaxaClient.Socket.ColetaAutomatica := True;
    DestaxaClient.FinalizarRequisicao;
  end;
end;

procedure TACBrTEFAPIClassDestaxa.AbortarTransacaoEmAndamento;
begin
  DestaxaClient.Requisicao.sequencial := DestaxaClient.UltimoSequencial+1;
  DestaxaClient.Requisicao.retorno := drqCancelarTransacao;
  DestaxaClient.Socket.Executar(DestaxaClient.Resposta.transacao);
end;

function TACBrTEFAPIClassDestaxa.VerificarPresencaPinPad: Byte;
begin
  Result := 0;
  DestaxaClient.IniciarRequisicao;
  try
    if DestaxaClient.Resposta.estado.ConfiguradoComPinpad then
      Result := 99;
  finally
    DestaxaClient.FinalizarRequisicao;
  end;
end;

end.
