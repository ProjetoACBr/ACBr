{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

{$I ACBr.inc}

unit ACBrTEFAPICliSiTef;

interface

uses
  Classes,
  SysUtils,
  ACBrBase,
  ACBrTEFComum,
  ACBrTEFAPI,
  ACBrTEFAPIComum,
  ACBrTEFCliSiTefComum;

resourcestring
  sErroCliSiTef_SemLoja = 'Código de Loja não informado';
  sErroCliSiTef_SemTerminal = 'Código de Terminal não informado';

const
  CSUBDIRETORIO_PAYGOWEB = 'PGWeb';
  CURL_LOCALHOST = 'localhost';
  CURL_TLS_PROD_FISERV = 'tls-prod.fiservapp.com';
  CVER_ACBR_SITEF = 'ACBR 10101';

  CPARAM_PortaPinPad = 'PortaPinPad';
  CPINPAD_AUTOUSB = 'AUTO_USB';
  CPARAM_HabilitaTrace = 'HabilitaTrace';
  CPARAM_MultiplosCupons = 'MultiplosCupons';
  CPARAM_VersaoAutomacao = 'VersaoAutomacaoCielo';
  CPARAM_ParmsClient = 'ParmsClient';
  CPARAM_TipoComunicacaoExterna = 'TipoComunicacaoExterna';
  CPARAM_TokenRegistro = 'TokenRegistro';
  CPARAM_ExibeMsgOperadorPinpad = 'ExibeMsgOperadorPinpad';

  CPARAM_CONT_ENCERRA = -1;
  CPARAM_CONT_CONTINUA = 0;
  CPARAM_CONT_RETORNA = 1;
  CPARAM_CONT_CANCELA = 2;
  CPARAM_CONT_CONTINUA_SEM_COLETA = 10000;

  CRET_ITERATIVO_CONTINUA = 10000;

// https://dev.softwareexpress.com.br/docs/clisitef/clisitef_documento_principal/

type

  { TACBrTEFAPIClassCliSiTef }

  TACBrTEFAPIClassCliSiTef = class(TACBrTEFAPIClass)
  private
    fIniciouRequisicao: Boolean;
    fUltimoRetornoAPI: Integer;
    fReimpressao: Boolean;
    fCancelamento: Boolean;
    fDocumentosFinalizados: String;
    fParamAdicConfig: TACBrTEFParametros;
    fParamAdicFinalizacao: TACBrTEFParametros;
    fParamAdicFuncao: TACBrTEFParametros;
    fRespostasPorTipo: TACBrTEFParametros;
    fTEFCliSiTefAPI: TACBrTEFCliSiTefAPI;
    fOperacaoVenda: Integer;
    fOperacaoAdministrativa: Integer;
    fOperacaoCancelamento: Integer;
    fAutorizador: String;
    fFinalizarTransacaoIndividual: Boolean;
  private
    function ExecutarTransacaoSiTef(Funcao: Integer; Valor: Double): Boolean;
    procedure FazerRequisicaoSiTef(Funcao: Integer; Valor: Double);
    procedure ContinuarRequisicaoSiTef;
    procedure FinalizarTransacaoSiTef(Confirma: Boolean; const DocumentoVinculado: String = '';
      DataHora: TDateTime = 0);
    procedure InterpretarRetornoCliSiTef(const Ret: Integer);
    function DadoPinPadToOperacao(ADadoPinPad: TACBrTEFAPIDadoPinPad): String;

    function TokenFiservValido(const AString: String): Boolean;
    function ParamTemChave(AParam: TACBrTEFParametros; const Chave: String): Boolean;

    procedure QuandoGravarLogAPI(const ALogLine: String; var Tratado: Boolean);

    function AjustarMensagemTela(const AMsg: String): String;
    function AjustarMensagemPinPad(const MensagemDisplay: String): String;

    procedure DoExibirMensagem(const AMsg: String; Terminal: TACBrTEFAPITela; MilissegundosExibicao: Integer);
    function DoContinuarOperacao(OperacaoAPI: TACBrTEFAPIOperacaoAPI): Boolean;
    function DoPerguntarSimNao(const Titulo: String): String;
    function DoPerguntarMenu(const Titulo: String; Opcoes: TStringList): String; overload;
    function DoPerguntarMenu(const Titulo: String; const Opcoes: String): String; overload;
    function DoPerguntarCampo(DefinicaoCampo: TACBrTEFAPIDefinicaoCampo): String;
    procedure DoExibirQRCode(const DadosQRCode: String);

  protected
    procedure InterpretarRespostaAPI; override;
    procedure CarregarRespostasPendentes(const AListaRespostasTEF: TACBrTEFAPIRespostas); override;

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

    function EfetuarAdministrativa(OperacaoAdm: TACBrTEFOperacao = tefopAdministrativo): Boolean; overload; override;
    function EfetuarAdministrativa(const CodOperacaoAdm: string = ''): Boolean; overload; override;

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
    function VersaoAPI: String; override;

    property TEFCliSiTefAPI: TACBrTEFCliSiTefAPI read fTEFCliSiTefAPI;

    property OperacaoVenda: Integer read fOperacaoVenda
      write fOperacaoVenda default CSITEF_OP_Venda;
    property OperacaoAdministrativa: Integer read fOperacaoAdministrativa
      write fOperacaoAdministrativa default CSITEF_OP_Administrativo;
    property OperacaoCancelamento: Integer read fOperacaoCancelamento
      write fOperacaoCancelamento default CSITEF_OP_Cancelamento;

    property ParamAdicConfig: TACBrTEFParametros read fParamAdicConfig;
    property ParamAdicFuncao: TACBrTEFParametros read fParamAdicFuncao;
    property ParamAdicFinalizacao: TACBrTEFParametros read fParamAdicFinalizacao;
    property RespostasPorTipo: TACBrTEFParametros read fRespostasPorTipo;

    property FinalizarTransacaoIndividual: Boolean read fFinalizarTransacaoIndividual
      write fFinalizarTransacaoIndividual default False;

    property Autorizador: String read fAutorizador write fAutorizador;
    property IniciouRequisicao: Boolean read fIniciouRequisicao;
  end;

implementation

uses
  Math,
  StrUtils,
  TypInfo,
  ACBrUtil.Strings,
  ACBrUtil.Base,
  ACBrUtil.Compatibilidade;

{ TACBrTEFAPIClassCliSiTef }

constructor TACBrTEFAPIClassCliSiTef.Create(AACBrTEFAPI: TACBrTEFAPIComum);
begin
  inherited;

  fpTEFRespClass := TACBrTEFRespCliSiTef;

  fOperacaoVenda := CSITEF_OP_Venda;
  fOperacaoAdministrativa := CSITEF_OP_Administrativo;
  fOperacaoCancelamento := CSITEF_OP_Cancelamento;

  fIniciouRequisicao := False;
  fDocumentosFinalizados := '';
  fUltimoRetornoAPI := 0;
  fAutorizador := '';
  fFinalizarTransacaoIndividual := False;

  fParamAdicConfig := TACBrTEFParametros.Create;
  fParamAdicFuncao := TACBrTEFParametros.Create;
  fParamAdicFinalizacao := TACBrTEFParametros.Create;
  fRespostasPorTipo := TACBrTEFParametros.Create;

  fTEFCliSiTefAPI := TACBrTEFCliSiTefAPI.Create;
  fTEFCliSiTefAPI.OnGravarLog := QuandoGravarLogAPI;
end;

destructor TACBrTEFAPIClassCliSiTef.Destroy;
begin
  fParamAdicConfig.Free;
  fParamAdicFuncao.Free;
  fParamAdicFinalizacao.Free;
  fRespostasPorTipo.Free;
  fTEFCliSiTefAPI.Free;
  inherited;
end;

procedure TACBrTEFAPIClassCliSiTef.Inicializar;
Var
  PortaPinPad, Sts: Integer ;
  ParamAdic, EnderecoIP, CodLoja, NumeroTerminal, MsgPinPad: AnsiString;
  Erro, Aplicacao, ParmsClient, ParamComunicacao, s: String;
  TEFParam: TACBrTEFParametros;
  Ambiente: TACBrTEFAPIAmbiente;
begin
  if Inicializado then
    Exit;

  fTEFCliSiTefAPI.PathDLL := PathDLL;
  fTEFCliSiTefAPI.Inicializada := True;

  CodLoja := Trim(IfEmptyThen(fpACBrTEFAPI.DadosTerminal.CodEmpresa, fpACBrTEFAPI.DadosTerminal.CodFilial));
  NumeroTerminal := Trim(fpACBrTEFAPI.DadosTerminal.CodTerminal);
  EnderecoIP := Trim(fpACBrTEFAPI.DadosTerminal.EnderecoServidor);
  Ambiente := fpACBrTEFAPI.DadosTerminal.Ambiente;

  if (EnderecoIP = CURL_TLS_PROD_FISERV) then
  begin
    if (Ambiente <> ambProducao) then
    begin
      fpACBrTEFAPI.GravarLog( '"EnderecoIP" informado é de Producao, mudando ambiente') ;
      Ambiente := ambProducao;
    end;
  end;

  ParamComunicacao := Trim(fpACBrTEFAPI.DadosTerminal.ParamComunicacao);
  if NaoEstaVazio(ParamComunicacao) then
  begin
    if (Ambiente <> ambProducao) then
    begin
      fpACBrTEFAPI.GravarLog( '"ParamComunicacao" Informado, mudando para ambiente de producao') ;
      Ambiente := ambProducao;
    end;
  end;

  if (Ambiente = ambProducao) then
  begin
    fpACBrTEFAPI.GravarLog( 'Validando Loja e Terminal para ambiente de producao') ;
    EnderecoIP := IfEmptyThen(EnderecoIP, CURL_TLS_PROD_FISERV);
    if (CodLoja = '') then
      fpACBrTEFAPI.DoException(ACBrStr(sErroCliSiTef_SemLoja));
    if (NumeroTerminal = '') then
      fpACBrTEFAPI.DoException(ACBrStr(sErroCliSiTef_SemTerminal));
  end
  else  // homologação
  begin
    fpACBrTEFAPI.GravarLog( 'Ajustando Loja e Terminal para ambiente de homologacao') ;
    EnderecoIP := IfEmptyThen(EnderecoIP, CURL_LOCALHOST);
    CodLoja := IfEmptyThen(CodLoja, '00000000' );
    NumeroTerminal := IfEmptyThen(NumeroTerminal, 'SE000001');
  end;

  // Poderiamos ajustar o Diretorio de trabalho na Clisitef.ini,
  //   mas não na ConfiguraIntSiTefInterativo.. vale a pena fazer isso ?
  // fpACBrTEFAPI.DiretorioTrabalho;

  if not ParamTemChave(ParamAdicConfig, CPARAM_PortaPinPad) then
  begin
    s := Trim(fpACBrTEFAPI.DadosTerminal.PortaPinPad);
    {$IfDef MSWINDOWS}
     PortaPinPad := StrToIntDef( OnlyNumber(s), 0);
     if (PortaPinPad > 0) then
       s := IntToStr(PortaPinPad);
    {$EndIf}
    if EstaVazio(s) then
      s := CPINPAD_AUTOUSB;

    ParamAdicConfig.Values[CPARAM_PortaPinPad] := s;
  end;

  if not ParamTemChave(ParamAdicConfig, CPARAM_HabilitaTrace) then
    if fpACBrTEFAPI.DadosTerminal.GravarLogTEF then
      ParamAdicConfig.Values[CPARAM_HabilitaTrace] := '1';

  if not ParamTemChave(ParamAdicConfig, CPARAM_MultiplosCupons) then
    if fpACBrTEFAPI.DadosAutomacao.SuportaViasDiferenciadas then
      ParamAdicConfig.Values[CPARAM_MultiplosCupons] := '1';

  if not ParamTemChave(ParamAdicConfig, CPARAM_VersaoAutomacao) then
  begin
    Aplicacao := PadRight(fpACBrTEFAPI.DadosAutomacao.NomeAplicacao, 5) +
                 PadRight(fpACBrTEFAPI.DadosAutomacao.VersaoAplicacao, 5);
    if EstaVazio(Trim(Aplicacao)) then
      Aplicacao := CVER_ACBR_SITEF;
    ParamAdicConfig.Values[CPARAM_VersaoAutomacao] := Aplicacao;
  end;

  ParmsClient := '';
  if not ParamTemChave(ParamAdicConfig, CPARAM_ParmsClient) then
  begin
    if NaoEstaVazio(fpACBrTEFAPI.DadosEstabelecimento.CNPJ) then
      ParmsClient := ParmsClient + '1='+fpACBrTEFAPI.DadosEstabelecimento.CNPJ;

    if NaoEstaVazio(fpACBrTEFAPI.DadosAutomacao.CNPJSoftwareHouse) then
      ParmsClient := ParmsClient + ';2='+fpACBrTEFAPI.DadosAutomacao.CNPJSoftwareHouse;

    if NaoEstaVazio(ParmsClient) then
      if (ParmsClient[1] = ';') then
        System.Delete(ParmsClient, 1, 1);   // remove ; inicial
  end;

  // https://dev.softwareexpress.com.br/en/docs/clisitef-interface-android/habilitando_comunicacao_tls_clisitef
  if (fpACBrTEFAPI.DadosTerminal.Ambiente = ambProducao) then
  begin
    TEFParam := TACBrTEFParametros.Create;
    try
      if TokenFiservValido(ParamComunicacao) then
        TEFParam.Values[CPARAM_TokenRegistro] := ParamComunicacao
      else
        TEFParam.Text := StringReplace(ParamComunicacao, ';', sLineBreak, [rfReplaceAll]);

      if not ParamTemChave(TEFParam, CPARAM_TipoComunicacaoExterna) then
        TEFParam.Values[CPARAM_TipoComunicacaoExterna] := 'TLSGWP';

      // acertar quebras de linhas e abertura e fechamento da lista de parametros
      ParamComunicacao := StringReplace(Trim(TEFParam.Text), sLineBreak, ';', [rfReplaceAll]);
    finally
      TEFParam.Free;
    end;
  end;

  // acertar quebras de linhas e abertura e fechamento da lista de parametros
  ParamAdic := StringReplace(Trim(ParamAdicConfig.Text), sLineBreak, ';', [rfReplaceAll]);

  if NaoEstaVazio(ParamComunicacao) then
    ParamAdic := ParamAdic + ';' + ParamComunicacao;

  if NaoEstaVazio(ParamAdic) then
  begin
    if (ParamAdic[1] = ';') then
      System.Delete(ParamAdic, 1, 1);   // remove ; inicial

    ParamAdic := '['+ ParamAdic + ']';
  end;

  if NaoEstaVazio(ParmsClient) then
  begin
    ParamAdic := ParamAdic + ';[' +CPARAM_ParmsClient + '=' + ParmsClient + ']';
    if (ParamAdic[1] = ';') then
      System.Delete(ParamAdic, 1, 1);   // remove ; inicial
  end;

  Sts := fTEFCliSiTefAPI.ConfiguraIntSiTefInterativo(
           PAnsiChar(EnderecoIP),
           PAnsiChar(CodLoja),
           PAnsiChar(NumeroTerminal),
           0,
           PAnsiChar(ParamAdic) );

  Erro := fTEFCliSiTefAPI.TraduzirErroInicializacao(Sts);
  if (Erro <> '') then
    fpACBrTEFAPI.DoException(ACBrStr(Erro));

  MsgPinPad := TrimRight(AjustarMensagemPinPad(fpACBrTEFAPI.DadosAutomacao.MensagemPinPad));
  if (MsgPinPad <> '') then
    fTEFCliSiTefAPI.DefineMensagemPermanentePinPad(MsgPinPad);

  inherited;
end;

procedure TACBrTEFAPIClassCliSiTef.DesInicializar;
begin
  fTEFCliSiTefAPI.Inicializada := False;
  inherited;
end;

function TACBrTEFAPIClassCliSiTef.ExecutarTransacaoSiTef(Funcao: Integer;
  Valor: Double): Boolean;
begin
  FazerRequisicaoSiTef(Funcao, Valor);
  if (fUltimoRetornoAPI = CRET_ITERATIVO_CONTINUA) then
    ContinuarRequisicaoSiTef;

  Result := (fUltimoRetornoAPI = 0);

  if Result then
    fpACBrTEFAPI.UltimaRespostaTEF.Conteudo.GravaInformacao(899,103, IntToStr(Trunc(SimpleRoundTo( Valor * 100 ,0))) );

  fpACBrTEFAPI.UltimaRespostaTEF.Conteudo.GravaInformacao(899, 102, fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao);
  fpACBrTEFAPI.UltimaRespostaTEF.Conteudo.GravaInformacao(899, 110, IntToStr(Funcao));
end;

procedure TACBrTEFAPIClassCliSiTef.FazerRequisicaoSiTef(Funcao: Integer;
  Valor: Double);
Var
  ValorStr, DataStr, HoraStr, DoctoStr, OperadorStr, ParamAdicStr: AnsiString;
  DataHora: TDateTime;
begin
  if not fTEFCliSiTefAPI.Inicializada then
    fpACBrTEFAPI.DoException(ACBrStr(CACBrTEFCliSiTef_NaoInicializado));

  if fIniciouRequisicao then
    fpACBrTEFAPI.DoException(ACBrStr(CACBrTEFCliSiTef_NaoConcluido));

  //TODO: Verificar se precisa disso (não consta no manual atual)
  //if (pos('{TipoTratamento=4}',ListaRestricoes) = 0) and
  //   (pos(AHeader,'CRT,CHQ') > 0 ) and
  //   SuportaDesconto then
  //begin
  //   ListaRestricoes := ListaRestricoes + '{TipoTratamento=4}';
  //end;

   DataHora := Now;
   DataStr := FormatDateTime('YYYYMMDD', DataHora );
   HoraStr := FormatDateTime('HHNNSS', DataHora );
   ValorStr := FormatFloatBr( Valor );
   if (fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao = '') then
     fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao := DataStr + HoraStr;

   DoctoStr := fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao;
   OperadorStr := fpACBrTEFAPI.DadosTerminal.Operador;
   if not ParamTemChave(ParamAdicFuncao, CPARAM_ExibeMsgOperadorPinpad) then
     if fpACBrTEFAPI.DadosAutomacao.AutoAtendimento then
       ParamAdicFuncao.Values[CPARAM_ExibeMsgOperadorPinpad] := '1';

   ParamAdicStr := StringReplace(Trim(ParamAdicFuncao.Text), sLineBreak, ';', [rfReplaceAll]);
   fDocumentosFinalizados := '' ;

   fpACBrTEFAPI.UltimaRespostaTEF.Clear;
   fUltimoRetornoAPI := fTEFCliSiTefAPI.IniciaFuncaoSiTefInterativo(
                          Funcao,
                          PAnsiChar(ValorStr),
                          PAnsiChar(DoctoStr),
                          PAnsiChar(DataStr),
                          PAnsiChar(HoraStr),
                          PAnsiChar(OperadorStr),
                          PAnsiChar(ParamAdicStr) ) ;

   fIniciouRequisicao := True;
   fCancelamento := False ;
   fReimpressao := False;
   fParamAdicFuncao.Clear;
end;

procedure TACBrTEFAPIClassCliSiTef.ContinuarRequisicaoSiTef;
const
  CBufferSize = 20480;
var
  ContinuaNavegacao, EsperaMensagem: Integer;
  ProximoComando,TamanhoMinimo, TamanhoMaximo : SmallInt;
  TipoCampo: LongInt;
  pBuffer:PAnsiChar;
  RespBuffer: AnsiString;
  Mensagem, TituloMenu: String;
  EhCarteiraDigital: Boolean ;
  DefinicaoCampo: TACBrTEFAPIDefinicaoCampo;
  RespCliSiTef: TACBrTEFRespCliSiTef;

  function RespostaValidaParaContinuar(const AResp: String): Boolean;
  var
    s: String;
  begin
    s := Trim(AResp);
    Result := (s <> '-1') and (s <> ':-1') and
              (s <> '-2') and (s <> ':-2');
  end;

begin
  fIniciouRequisicao := True ;
  fCancelamento := False ;
  fReimpressao := False;
  EhCarteiraDigital := False;
  ContinuaNavegacao := CPARAM_CONT_CONTINUA;
  RespBuffer := '';
  TituloMenu := '' ;

  pBuffer :=  AllocMem(CBufferSize);
  RespCliSiTef := TACBrTEFRespCliSiTef(fpACBrTEFAPI.UltimaRespostaTEF);
  try
    repeat
      ProximoComando := 0;
      TipoCampo := 0;
      TamanhoMinimo := 0;
      TamanhoMaximo := 0;
      fUltimoRetornoAPI := fTEFCliSiTefAPI.ContinuaFuncaoSiTefInterativo(
                             ProximoComando,
                             TipoCampo,
                             TamanhoMinimo,
                             TamanhoMaximo,
                             pBuffer, CBufferSize,
                             ContinuaNavegacao );

      ContinuaNavegacao := CPARAM_CONT_CONTINUA;
      RespBuffer := '';
      Mensagem := TrimRight(pBuffer);

      if (fUltimoRetornoAPI = CRET_ITERATIVO_CONTINUA) then
      begin
        if (TipoCampo > 0) then
          RespBuffer := fRespostasPorTipo.ValueInfo[TipoCampo];

        if (TipoCampo = 5005) then   // 5005 - Indica que a transação foi finalizada
          EsperaMensagem := CSITEF_ESPERA_MINIMA_MSG_FINALIZACAO
        else
          EsperaMensagem := -1;

        case ProximoComando of
          0:  // Está devolvendo um valor para ser armazenado pela automação
          begin
            RespCliSiTef.GravaInformacao(TipoCampo, Mensagem);

            case TipoCampo of
              15:
                RespCliSiTef.GravaInformacao(TipoCampo, 'True'); //Selecionou Debito;
              25:
                RespCliSiTef.GravaInformacao(TipoCampo, 'True'); //Selecionou Credito;
              29:
                RespCliSiTef.GravaInformacao(TipoCampo, 'True'); //Cartão Digitado;
              56, 57, 58:
                fReimpressao := True;
              107:
                EhCarteiraDigital := True;
              110:
                fCancelamento:= True;
            end;
          end;

          1:  // Mensagem para o visor do operador
            DoExibirMensagem(Mensagem, telaOperador, EsperaMensagem);

          2:  // Mensagem para o visor do cliente
            DoExibirMensagem(Mensagem, telaCliente, EsperaMensagem);

          3:  // Mensagem para os dois visores
          begin
            DoExibirMensagem(Mensagem, telaTodas, EsperaMensagem);

            if EhCarteiraDigital then
              if not DoContinuarOperacao(opapiLeituraQRCode) then
                ContinuaNavegacao := CPARAM_CONT_ENCERRA;
          end;

          4:  // Texto que deverá ser utilizado como título na apresentação do menu ( vide comando 21)
            TituloMenu := AjustarMensagemTela(Mensagem);

          11: // Deve remover a mensagem apresentada no visor do operador (comando 1)
            DoExibirMensagem('', telaOperador, -1);

          12: // Deve remover a mensagem apresentada no visor do cliente (comando 2)
            DoExibirMensagem('', telaCliente, -1);

          13: // Deve remover mensagem apresentada no visor do operador e do cliente (comando 3)
            DoExibirMensagem('', telaTodas, -1);

          14: // Deve limpar o texto utilizado como título na apresentação do menu (comando 4)
            TituloMenu := '';

          15:  // Cabeçalho a ser apresentado pela aplicação. Refere-se a exibição de informações adicionais que algumas transações necessitam mostrar na tela.
            DoExibirMensagem(Mensagem, telaCliente, -1);

          16:  // Deve remover o cabeçalho apresentado pelo comando 15
            DoExibirMensagem('', telaCliente, -1);

          20:  // Deve apresentar o texto em pBuffer, e obter uma resposta do tipo SIM/NÃO.
            RespBuffer := DoPerguntarSimNao(Mensagem);

          21:  // Deve apresentar um menu de opções e permitir que o usuário selecione uma delas
            RespBuffer := DoPerguntarMenu(TituloMenu, Mensagem);

          22:  // Deve apresentar a mensagem em pBuffer, e aguardar uma tecla do operador.
          begin
            if (Mensagem = '') then
              Mensagem := CACBrTEFCliSiTef_PressioneEnter;

             DoExibirMensagem(Mensagem, telaOperador, 0);
          end;

          23:  // Este comando indica que a rotina está perguntando para a aplicação se ele deseja interromper o processo de coleta de dados ou não
          begin
            if not DoContinuarOperacao(opapiPinPad) then
              ContinuaNavegacao := CPARAM_CONT_ENCERRA;
          end;

          29:  // deve ser coletado um campo que não requer intervenção do operador de caixa, ou seja, não precisa que seja digitado/mostrado na tela, e sim passado diretamente para a biblioteca pela automação
            { Nada a Fazer, Resposta já foi atribuida por
              Resposta := fRespostasPorTipo.ValueInfo[TipoCampo] };

          30,  // Deve ser lido um campo cujo tamanho está entre TamMinimo e TamMaximo
          31,  // Deve ser lido o número de um cheque. A coleta pode ser feita via leitura de CMC-7, digitação do CMC-7 ou pela digitação da primeira linha do cheque
          34,  // Deve ser lido um campo monetário ou seja, aceita o delimitador de centavos e devolvido no parâmetro pBuffer
          35,  // Deve ser lido um código em barras ou o mesmo deve ser coletado manualmente.
          41:  // Análogo ao Comando 30, porém o campo deve ser coletado de forma mascarada
          begin
            if (RespBuffer = '') then
            begin
              DefinicaoCampo.OcultarDadosDigitados := False;
              DefinicaoCampo.TipoCampo := TipoCampo;
              DefinicaoCampo.TituloPergunta := ACBrStr(Mensagem);
              DefinicaoCampo.TamanhoMaximo := TamanhoMaximo;
              DefinicaoCampo.TamanhoMinimo := TamanhoMinimo;
              DefinicaoCampo.MascaraDeCaptura := '';
              DefinicaoCampo.TipoDeEntrada := tedTodos;
              DefinicaoCampo.TipoEntradaCodigoBarras := tbQualquer;

              if (ProximoComando <> 30) and (ProximoComando <> 41) then
                DefinicaoCampo.TipoDeEntrada := tedNumerico;

              if (ProximoComando = 34) then
                DefinicaoCampo.MascaraDeCaptura := '@@@@@@@@@,@@';

              if (ProximoComando = 35) then
                DefinicaoCampo.TipoEntradaCodigoBarras := tbLeitor;

              if (ProximoComando = 41) then
                DefinicaoCampo.OcultarDadosDigitados := True;

              RespBuffer := DoPerguntarCampo(DefinicaoCampo);
            end;

            if RespostaValidaParaContinuar(RespBuffer) then
            begin
              if (ProximoComando = 34) then
                RespBuffer := FormatFloatBr(StringToFloatDef(RespBuffer, 0));  // Garantindo que a Resposta é Float //

              RespCliSiTef.GravaInformacao(TipoCampo, RespBuffer);
            end;
          end;

          50:  // Exibir QRCode
            DoExibirQRCode(AjustarMensagemTela(Mensagem));

          51:  // Remover QRCode
            DoExibirQRCode('');

          52:  // Mensagem de rodapé QRCode
          begin
            DoExibirMensagem(Mensagem, telaCliente, -1);
            if not DoContinuarOperacao(opapiLeituraQRCode) then
              ContinuaNavegacao := CPARAM_CONT_ENCERRA;
          end;
        end;

        if (RespBuffer = '-1') or (RespBuffer = ':-1') then
        begin
          ContinuaNavegacao := CPARAM_CONT_ENCERRA;
          RespBuffer := '';
        end
        else if (RespBuffer = '-2') or (RespBuffer = ':-2') then
        begin
          ContinuaNavegacao := CPARAM_CONT_RETORNA;
          RespBuffer := '';
        end
        else if (RespBuffer <> '') then
          ContinuaNavegacao := CPARAM_CONT_CONTINUA;
      end
      else
        fpACBrTEFAPI.GravarLog( '*** Finalizando ContinuaFuncaoSiTefInterativo: STS = '+IntToStr(fUltimoRetornoAPI) ) ;

      //StrPCopy(pBuffer, RespBuffer);
      RespBuffer := RespBuffer + #00;
      Move( RespBuffer[1], pBuffer^, Length(RespBuffer)+1);

    until (fUltimoRetornoAPI <> CRET_ITERATIVO_CONTINUA);

  finally
    fIniciouRequisicao := False;
    Freemem(pBuffer);
    DoExibirMensagem('', telaTodas, -1);
  end;
end;

procedure TACBrTEFAPIClassCliSiTef.FinalizarTransacaoSiTef(Confirma: Boolean;
  const DocumentoVinculado: String; DataHora: TDateTime);
Var
  DataStr, HoraStr, DoctoStr, ParamAdic: AnsiString;
  Finalizacao: SmallInt;
begin
   fRespostasPorTipo.Clear;
   fIniciouRequisicao := False;

   // Re-Impressão não precisa de Finalização
   if fReimpressao then
     Exit;

   // Já Finalizou este Documento por outra Transação ?
   if (DocumentoVinculado <> '') then
     DoctoStr := DocumentoVinculado
   else
     DoctoStr := fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao;

   if (not fFinalizarTransacaoIndividual) and (pos(DoctoStr, fDocumentosFinalizados) > 0) then
     Exit;

  fDocumentosFinalizados := fDocumentosFinalizados + DocumentoVinculado + '|' ;
  if (DataHora = 0) then
  begin
    // Leu com sucesso o arquivo pendente. Transações com mais de três dias são finalizadas automaticamente pela SiTef
    if (fpACBrTEFAPI.UltimaRespostaTEF.DataHoraTransacaoComprovante > (date - 3)) then
      DataHora := fpACBrTEFAPI.UltimaRespostaTEF.DataHoraTransacaoComprovante
    else
      DataHora := Now;
  end;

  // acertar quebras de linhas e abertura e fechamento da lista de parametros
  ParamAdic := StringReplace(Trim(ParamAdicFinalizacao.Text), sLineBreak, '', [rfReplaceAll]);
  DataStr := FormatDateTime('YYYYMMDD', DataHora);
  HoraStr := FormatDateTime('HHNNSS', DataHora);
  Finalizacao := ifthen(Confirma or fCancelamento, 1, 0);

  fTEFCliSiTefAPI.FinalizaFuncaoSiTefInterativo( Finalizacao,
                                                 PAnsiChar(DoctoStr),
                                                 PAnsiChar(DataStr),
                                                 PAnsiChar(HoraStr),
                                                 PAnsiChar(ParamAdic) ) ;
end;

procedure TACBrTEFAPIClassCliSiTef.InterpretarRetornoCliSiTef(const Ret: Integer);
var
  Erro: String;
begin
  Erro := fTEFCliSiTefAPI.TraduzirErroTransacao(Ret);
  if (Erro <> '') then
    fpACBrTEFAPI.DoException(ACBrStr(Erro));
end;

function TACBrTEFAPIClassCliSiTef.DadoPinPadToOperacao(
  ADadoPinPad: TACBrTEFAPIDadoPinPad): String;
begin
  case ADadoPinPad of
    dpDDD: Result := '1';
    dpRedDDD: Result := '2';
    dpFone: Result := '3';
    dpRedFone: Result := '4';
    dpDDDeFone: Result := '5';
    dpRedDDDeFone: Result := '6';
    dpCPF: Result := '7';
    dpRedCPF: Result := '8';
    dpRG: Result := '9';
    dpRedRG: Result := 'A';
    dp4UltDigitos: Result := 'B';
    dpCodSeguranca: Result := 'C';
    dpCNPJ: Result := 'D';
    dpRedCNPJ: Result := 'E';
    dpDataDDMMAAAA: Result := 'F';
    dpDataDDMMAA: Result := '10';
    dpDataDDMM: Result := '11';
    dpDiaDD: Result := '12';
    dpMesMM: Result := '13';
    dpAnoAA: Result := '14';
    dpAnoAAAA: Result := '15';
    dpDataNascimentoDDMMAAAA: Result := '16';
    dpDataNascimentoDDMMAA: Result := '17';
    dpDataNascimentoDDMM: Result := '18';
    dpDiaNascimentoDD: Result := '19';
    dpMesNascimentoMM: Result := '1A';
    dpAnoNascimentoAA: Result := '1B';
    dpAnoNascimentoAAAA: Result := '1C';
    dpIdentificacao: Result := '1D';
    dpCodFidelidade: Result := '1E';
    dpNumeroMesa: Result := '1F';
    dpQtdPessoas: Result := '20';
    dpQuantidade: Result := '21';
    dpNumeroBomba: Result := '22';
    dpNumeroVaga: Result := '23';
    dpNumeroGuiche: Result := '24';
    dpCodVendedor: Result := '25';
    dpCodGarcom: Result := '26';
    dpNotaAtendimento: Result := '27';
    dpNumeroNotaFiscal: Result := '28';
    dpNumeroComanda: Result := '29';
    dpPlacaVeiculo: Result := '2A';
    dpQuilometragem: Result := '2B';
    dpQuilometragemInicial: Result := '2C';
    dpQuilometragemFinal: Result := '2D';
    dpPorcentagem: Result := '2E';
    dpPesquisaSatisfacao0_10: Result := '2F';
    dpAvalieAtendimento0_10: Result := '30';
    dpToken: Result := '31';
    dpNumeroParcelas: Result := '33';
    dpCodigoPlano: Result := '34';
    dpCodigoProduto: Result := '35';
  else
    Result := '';
  end;
end;

function TACBrTEFAPIClassCliSiTef.TokenFiservValido(const AString: String): Boolean;
var
  s: String;
begin
  // Ex: TokenRegistro=1234-4567-8901-2345
  s := Trim(AString);
  Result := (Length(s) = 19) and
            StrIsNumber(copy(s, 1,4)) and
            (s[05] = '-') and
            StrIsNumber(copy(s, 6,4)) and
            (s[10] = '-') and
            StrIsNumber(copy(s,11,4)) and
            (s[15] = '-') and
            StrIsNumber(copy(s,16,4));
end;

function TACBrTEFAPIClassCliSiTef.ParamTemChave(AParam: TACBrTEFParametros;
  const Chave: String): Boolean;
begin
  Result := (AParam.IndexOf(Chave) >= 0);
end;

procedure TACBrTEFAPIClassCliSiTef.QuandoGravarLogAPI(const ALogLine: String; var Tratado: Boolean);
begin
  fpACBrTEFAPI.GravarLog(ALogLine);
  Tratado := True;
end;

function TACBrTEFAPIClassCliSiTef.AjustarMensagemTela(const AMsg: String): String;
begin
  Result := ACBrStr(AMsg);
  Result := StringReplace(Result, '@', sLineBreak, [rfReplaceAll] );
  Result := StringReplace(Result, '/n', sLineBreak, [rfReplaceAll] );
end;

function TACBrTEFAPIClassCliSiTef.AjustarMensagemPinPad(const MensagemDisplay: String): String;
const
  CPINPAD_COL = 16;
  CPINPAD_LIN = 2;
begin
  Result := StringReplace(MensagemDisplay, '|', #10, [rfReplaceAll]);
  Result := AjustaLinhas(Result, CPINPAD_COL, CPINPAD_LIN, True);
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);
end;


procedure TACBrTEFAPIClassCliSiTef.DoExibirMensagem(const AMsg: String;
  Terminal: TACBrTEFAPITela; MilissegundosExibicao: Integer);
var
  s: String;
begin
  with TACBrTEFAPI(fpACBrTEFAPI) do
  begin
    if Assigned(QuandoExibirMensagem) then
    begin
      s := AjustarMensagemTela(AMsg);
      QuandoExibirMensagem(s, Terminal, MilissegundosExibicao);
    end;
  end;
end;

function TACBrTEFAPIClassCliSiTef.DoContinuarOperacao(
  OperacaoAPI: TACBrTEFAPIOperacaoAPI): Boolean;
var
  Cancelar: Boolean;
begin
  Result := True;
  with TACBrTEFAPI(fpACBrTEFAPI) do
  begin
    Cancelar := False;
    if Assigned(QuandoEsperarOperacao) then
      QuandoEsperarOperacao(OperacaoAPI, Cancelar);
  end;

  Result := not Cancelar;
end;

function TACBrTEFAPIClassCliSiTef.DoPerguntarSimNao(const Titulo: String): String;
var
  s: String;
  SL: TStringList;
begin
  Result := '1';   // 1-Cancela
  with TACBrTEFAPI(fpACBrTEFAPI) do
  begin
    if not Assigned(QuandoPerguntarMenu) then
      Exit;

    s := Trim(Titulo);
    if (s = '') then
      s := 'CONFIRMA ?';

    SL := TStringList.Create;
    try
      SL.Add('0:SIM');
      SL.Add(ACBrStr('1:NÃO'));
      Result := DoPerguntarMenu(s, SL);
    finally
      SL.Free;
    end;
  end;
end;

function TACBrTEFAPIClassCliSiTef.DoPerguntarMenu(const Titulo: String; Opcoes: TStringList): String;
var
  ItemSelecionado: Integer;
begin
  Result := '';
  with TACBrTEFAPI(fpACBrTEFAPI) do
  begin
    if Assigned(QuandoPerguntarMenu) then
    begin
      ItemSelecionado := -1;
      QuandoPerguntarMenu(ACBrStr(Titulo), Opcoes, ItemSelecionado);
      if (ItemSelecionado >= 0) and (ItemSelecionado < Opcoes.Count) then
        Result := copy( Opcoes[ItemSelecionado], 1, pos(':',Opcoes[ItemSelecionado]+':')-1 )
      else if (ItemSelecionado = -1) then  // Cancelar
        Result := ':-1'
      else if (ItemSelecionado = -2) then  // Voltar
        Result := ':-2';
    end;
  end;
end;

function TACBrTEFAPIClassCliSiTef.DoPerguntarMenu(const Titulo: String; const Opcoes: String): String;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := StringReplace(Opcoes, ';', sLineBreak, [rfReplaceAll]);
    Result := DoPerguntarMenu(Titulo, SL);
  finally
    SL.Free ;
  end ;
end;

function TACBrTEFAPIClassCliSiTef.DoPerguntarCampo(DefinicaoCampo: TACBrTEFAPIDefinicaoCampo): String;
var
  Resposta: String;
  Validado, Cancelado: Boolean;
begin
  Resposta := '';
  with TACBrTEFAPI(fpACBrTEFAPI) do
  begin
    if Assigned(QuandoPerguntarCampo) then
    begin
      Validado := True;
      Cancelado := False;
      QuandoPerguntarCampo(DefinicaoCampo, Resposta, Validado, Cancelado);

      if Cancelado then
        Resposta := ':-1';
    end;
  end;

  Result := Resposta;
end;

procedure TACBrTEFAPIClassCliSiTef.DoExibirQRCode(const DadosQRCode: String);
begin
  with TACBrTEFAPI(fpACBrTEFAPI) do
  begin
    if Assigned(QuandoExibirQRCode) then
      QuandoExibirQRCode(DadosQRCode);
  end;
end;

procedure TACBrTEFAPIClassCliSiTef.InterpretarRespostaAPI;
begin
  fpACBrTEFAPI.GravarLog( 'TACBrTEFAPIClassCliSiTef.InterpretarRespostaAPI');
  //D Verificar segurança de log abaixo
  fpACBrTEFAPI.GravarLog( fpACBrTEFAPI.UltimaRespostaTEF.Conteudo.Conteudo.Text );
  fpACBrTEFAPI.UltimaRespostaTEF.ViaClienteReduzida := fpACBrTEFAPI.DadosAutomacao.ImprimeViaClienteReduzida;
  fpACBrTEFAPI.UltimaRespostaTEF.Sucesso := (fUltimoRetornoAPI = 0);


  fpACBrTEFAPI.UltimaRespostaTEF.ConteudoToProperty;
  if (fUltimoRetornoAPI <> 0) then
    fpACBrTEFAPI.UltimaRespostaTEF.TextoEspecialOperador := ACBrStr(fTEFCliSiTefAPI.TraduzirErroTransacao(fUltimoRetornoAPI));
end;

procedure TACBrTEFAPIClassCliSiTef.CarregarRespostasPendentes(
  const AListaRespostasTEF: TACBrTEFAPIRespostas);
var
  i, j: Integer;
  CupomFiscal, NumIdent, DataFiscal, HoraFiscal: String;
  ValorTransacao: Double;
  RespTEFPendente: TACBrTEFResp;
  InfValor: TACBrInformacao;
begin
  AListaRespostasTEF.CarregarRespostasDoDiretorioTrabalho;
  i := 0;
  while i < AListaRespostasTEF.Count do
  begin
    RespTEFPendente := AListaRespostasTEF[i];
    if not RespTEFPendente.CNFEnviado then   // Transações não confirmadas, serão carregadas abaixo, pelo comando 130
      AListaRespostasTEF.ApagarRespostaTEF(i)
    else
      Inc(i);
  end;

  // Solicita do TEF respostas pendentes
  ExecutarTransacaoSiTef(CSITEF_OP_ConsultarTrasPendente, 0);
  i := fpACBrTEFAPI.UltimaRespostaTEF.LeInformacao(210, 0).AsInteger; // Total number of pending issues
  if (i = 0) then
    Exit;

  // Varre o Log, e carrega em AListaRespostasTEF
  with fpACBrTEFAPI.UltimaRespostaTEF do
  begin
    i := 1;
    CupomFiscal := Trim(LeInformacao(160, i).AsString);
    while NaoEstaVazio(CupomFiscal) do
    begin
      NumIdent := Trim(LeInformacao(161, i).AsString);
      DataFiscal := Trim(LeInformacao(163, i).AsString);
      HoraFiscal := Trim(LeInformacao(164, i).AsString);
      ValorTransacao := LeInformacao(1319, i).AsFloat;

      RespTEFPendente :=  TACBrTEFRespCliSiTef.Create;
      InfValor := TACBrInformacao.Create;
      try
        RespTEFPendente.Conteudo.GravaInformacao(899,100,'CRT');
        RespTEFPendente.Conteudo.GravaInformacao(899,102, CupomFiscal);
        RespTEFPendente.Conteudo.GravaInformacao(899,500, NumIdent);
        RespTEFPendente.Conteudo.GravaInformacao(105,000, DataFiscal + HoraFiscal);
        InfValor.AsFloat := ValorTransacao;
        RespTEFPendente.Conteudo.GravaInformacao(899,103, InfValor);
        RespTEFPendente.Conteudo.GravaInformacao(899,110, IntToStr(CSITEF_OP_ConsultarTrasPendente));

        RespTEFPendente.Finalizacao := CupomFiscal;
        RespTEFPendente.DocumentoVinculado := CupomFiscal;

        j := AListaRespostasTEF.AdicionarRespostaTEF(RespTEFPendente); // Cria Clone interno
        AListaRespostasTEF.Items[j].NSU := '';
        AListaRespostasTEF.Items[j].CNFEnviado := False;
        AListaRespostasTEF.Items[j].Confirmar := True;
      finally
        InfValor.Free;
        RespTEFPendente.Free;
      end;

      inc(i);
      CupomFiscal := Trim(LeInformacao(160, i).AsString);
    end;
  end;
end;

function TACBrTEFAPIClassCliSiTef.EfetuarAdministrativa(
  OperacaoAdm: TACBrTEFOperacao): Boolean;
var
  Op: Integer;
begin
  case OperacaoAdm of
    tefopPagamento:
      Op := CSITEF_OP_Venda;
    tefopAdministrativo:
      Op := CSITEF_OP_Administrativo;
    tefopTesteComunicacao, tefopVersao:
      Op := 111;
    tefopFechamento:
      Op := 999;
    tefopCancelamento:
      Op := 200;
    tefopReimpressao:
      Op := 112;
    tefopPrePago:
      Op := 314;
    tefopPreAutorizacao:
      Op := 115;
    tefopConsultaSaldo:
      Op := 600;
    tefopConsultaCheque:
      Op := 1;
    tefopPagamentoConta:
      Op := 310;
  else
    fpACBrTEFAPI.DoException(Format(ACBrStr(sACBrTEFAPIAdministrativaNaoSuportada),
      [GetEnumName(TypeInfo(TACBrTEFOperacao), integer(OperacaoAdm) ), ClassName] ));
  end;

  Result := EfetuarAdministrativa(IntToStr(Op));
end;

function TACBrTEFAPIClassCliSiTef.EfetuarAdministrativa(const CodOperacaoAdm: string): Boolean;
var
  OP: Integer;
begin

  Op := StrToIntDef(CodOperacaoAdm, CSITEF_OP_Administrativo);
  Result := ExecutarTransacaoSiTef(Op, 0);
end;

function TACBrTEFAPIClassCliSiTef.EfetuarPagamento(ValorPagto: Currency;
  Modalidade: TACBrTEFModalidadePagamento; CartoesAceitos: TACBrTEFTiposCartao;
  Financiamento: TACBrTEFModalidadeFinanciamento; Parcelas: Byte;
  DataPreDatado: TDateTime; DadosAdicionais: String): Boolean;
var
  Op, i, L: Integer;
  SL: TStringList;
  Restr, Restricoes: String;
begin
  VerificarIdentificadorVendaInformado;
  if (ValorPagto <= 0) then
    fpACBrTEFAPI.DoException(sACBrTEFAPIValorPagamentoInvalidoException);

  Op := fOperacaoVenda;
  case Modalidade of
    tefmpDinheiro:
      Op := 0;    // Pagamento genérico
    tefmpCheque:
      Op := 1;    // Cheque
    tefmpCarteiraVirtual:
      Op := 122;  // Venda via Carteira Digital
  else
    if (CartoesAceitos = []) then
      Op := 0   // Pagamento genérico.
    else if (teftcCredito in CartoesAceitos) and (teftcDebito in CartoesAceitos) then
      Op := 0   // Pagamento genérico.
    else if (teftcDebito in CartoesAceitos) then
      Op := 2   // Débito
    else if (teftcCredito in CartoesAceitos) then
      Op := 3   // Crédito
    else if (teftcVoucher in CartoesAceitos) then
      Op := 5   // Cartão Benefício
    else if (teftcFrota in CartoesAceitos) then
      Op := 7   // Cartão Combustível
    else if (teftcPrivateLabel in CartoesAceitos) then
      Op := 15  // Venda com cartão Gift
    else
      Op := 0;  // Pagamento genérico.
  end;

  if (TACBrTEFAPI(fpACBrTEFAPI).ExibicaoQRCode = qrapiExibirAplicacao) then
  begin
    if (pos('DevolveStringQRCode', fParamAdicConfig.Text) = 0) then
      fParamAdicConfig.Add('{DevolveStringQRCode=1}');
  end;

  Restricoes := '';
  if Trim(DadosAdicionais) <> '' then
    Restricoes := Restricoes + ';' + Trim(DadosAdicionais);

  if Trim(fParamAdicFuncao.Text) <> '' then
    Restricoes := Restricoes + ';' + Trim(fParamAdicFuncao.Text);

  // removendo '[', ']', ';' do inicial e final e
  while (Length(Restricoes) > 0) and CharInSet(Restricoes[1], ['[',';']) do
    Delete(Restricoes, 1, 1);

  L := Length(Restricoes);
  while (L > 0) and CharInSet(Restricoes[L], [']',';']) do
  begin
    Delete(Restricoes, L, 1);
    L := Length(Restricoes);
  end;

  if (Restricoes = '') then
  begin
    // Aplicando Restriçoes conhecidas internamente
    if (Op <> 0) and (Op <> 1) then       // 0-Generico, 1-Cheque
      Restricoes := Restricoes + CSITEF_RestricoesCheque + ';';

    if (Op = 2) then       // 2-Débito
      Restricoes := Restricoes + CSITEF_RestricoesConsultaDebito + ';'
    else if (Op = 3) then  // 3-Crédito
      Restricoes := Restricoes + CSITEF_RestricoesConsultaCredito + ';';

    if (Financiamento = tefmfAVista) then
    begin
      Restricoes := Restricoes + CSITEF_RestricoesParcelado + ';';
      Restricoes := Restricoes + CSITEF_RestricoesPreDatado + ';';
      Restricoes := Restricoes + CSITEF_RestricoesParcelaAministradora + ';';
      Restricoes := Restricoes + CSITEF_RestricoesParcelaEstabelecimento + ';';
    end
    else if (Financiamento = tefmfParceladoEmissor) then
    begin
      Restricoes := Restricoes + CSITEF_RestricoesAVista + ';';
      Restricoes := Restricoes + CSITEF_RestricoesPreDatado + ';';
      Restricoes := Restricoes + CSITEF_RestricoesParcelaEstabelecimento + ';';
    end
    else if (Financiamento = tefmfParceladoEstabelecimento) then
    begin
      Restricoes := Restricoes + CSITEF_RestricoesAVista + ';';
      Restricoes := Restricoes + CSITEF_RestricoesPreDatado + ';';
      Restricoes := Restricoes + CSITEF_RestricoesParcelaAministradora + ';';
    end
    else if (Financiamento = tefmfPredatado) then
    begin
      Restricoes := Restricoes + CSITEF_RestricoesAVista + ';';
      Restricoes := Restricoes + CSITEF_RestricoesParcelaAministradora + ';';
      Restricoes := Restricoes + CSITEF_RestricoesParcelaEstabelecimento + ';';
    end;
  end;

  if (Restricoes <> '') then
  begin
    // Removendo Itens repetidos e ordenando as restrições
    SL := TStringList.Create;
    try
      SL.Text := StringReplace(Restricoes, ';', sLineBreak, [rfReplaceAll]);
      for i := 0 to SL.Count-1 do
        SL[i] := FormatFloat('00000', StrToIntDef(SL[i], 0));

      i := 0;
      Restr := '';
      SL.Sort;

      // Apagando restrições inválidas
      while (SL.Count > 0) and (SL[0] = '00000') do
        SL.Delete(0);

      // Removendo Itens repetidos
      while (i < SL.Count) do
      begin
        Restr := SL[i];
        inc(i);
        while (i < SL.Count) and (Restr = SL[i]) do
          SL.Delete(i);
      end;

      // Convertendo para formato de parâmetro, em String separada por ;
      if (SL.Count > 0) then
      begin
        for i := 0 to SL.Count-1 do
          SL[i] := IntToStr(StrToIntDef(SL[i], 0));

        Restricoes := Trim(StringReplace(Trim(SL.Text), sLineBreak, ';', [rfReplaceAll]));
        if (Restricoes <> '') then
        begin
          Restricoes := '['+Restricoes+']';
          fParamAdicFuncao.Text := Restricoes;
        end;
      end;
    finally
      SL.Free;
    end;
  end;

  // Injetando resposta de Parcelas
  if (Parcelas <> 0) then
    fRespostasPorTipo.ValueInfo[505] := IntToStr(Parcelas);

  // Injetando resposta de Pré datado
  if (DataPreDatado <> 0) then
    fRespostasPorTipo.ValueInfo[506] := FormatDateTime('DDMMYYYY', DataPreDatado);

  Result := ExecutarTransacaoSiTef(Op, ValorPagto);
end;

procedure TACBrTEFAPIClassCliSiTef.FinalizarTransacao(const Rede, NSU,
  CodigoFinalizacao: String; AStatus: TACBrTEFStatusTransacao);
var
  Confirma: Boolean;
  i, p: Integer;
  DocumentoVinculado: String;
  DataHora: TDateTime;
begin
  // CliSiTEF não usa Rede, NSU e Finalizacao
  DocumentoVinculado := '';
  DataHora := 0;
  p := -1;
  Confirma := (AStatus in [tefstsSucessoAutomatico, tefstsSucessoManual]);
  if (NSU = '') and (CodigoFinalizacao <> '') then  // capturado por 130 em CarregarRespostasPendentes ?
  begin
    DocumentoVinculado := CodigoFinalizacao;
    for i := 0 to fpACBrTEFAPI.RespostasTEF.Count-1 do
    begin
      if fpACBrTEFAPI.RespostasTEF[i].DocumentoVinculado = DocumentoVinculado then
      begin
        DataHora := fpACBrTEFAPI.RespostasTEF[i].DataHoraTransacaoComprovante;
        Break;
      end;
    end;
  end
  else
  begin
    i := fpACBrTEFAPI.RespostasTEF.AcharTransacao(Rede, NSU, CodigoFinalizacao);
    if (i >= 0) then
    begin
      DocumentoVinculado := fpACBrTEFAPI.RespostasTEF[i].DocumentoVinculado;
      DataHora := fpACBrTEFAPI.RespostasTEF[i].DataHoraTransacaoComprovante;

      if fFinalizarTransacaoIndividual then
        p := ParamAdicFinalizacao.Add('{NumeroPagamentoCupom='+IntToStr(fpACBrTEFAPI.RespostasTEF[i].IdPagamento)+'}');
    end;
  end;

  FinalizarTransacaoSiTef(Confirma, DocumentoVinculado, DataHora);
  
  if (p >= 0) then
    ParamAdicFinalizacao.Delete(p);
end;

procedure TACBrTEFAPIClassCliSiTef.ResolverTransacaoPendente(
  AStatus: TACBrTEFStatusTransacao);
var
  AMsg: String;
begin
  FinalizarTransacao( fpACBrTEFAPI.UltimaRespostaTEF.Rede,
                      fpACBrTEFAPI.UltimaRespostaTEF.NSU,
                      fpACBrTEFAPI.UltimaRespostaTEF.Finalizacao,
                      AStatus );

  if (AStatus in [tefstsSucessoAutomatico, tefstsSucessoManual]) then
    AMsg := Format( CACBrTEFCliSiTef_TransacaoEfetuadaReImprimir,
                    [fpACBrTEFAPI.UltimaRespostaTEF.Finalizacao] )
  else
    AMsg := CACBrTEFCliSiTef_TransacaoNaoEfetuada;

  DoExibirMensagem(AMsg, telaOperador, 0);
end;

function TACBrTEFAPIClassCliSiTef.VerificarPresencaPinPad: Byte;
begin
  Result := Ord(fTEFCliSiTefAPI.VerificaPresencaPinPad);
end;

function TACBrTEFAPIClassCliSiTef.VersaoAPI: String;
var
  lVersaoCliSiTef: String;
  lVersaoCliSiTefI: String;
begin
  InterpretarRetornoCliSiTef( fTEFCliSiTefAPI.ObtemVersao(lVersaoCliSiTef, lVersaoCliSiTefI) );
  Result := lVersaoCliSiTef;
end;

procedure TACBrTEFAPIClassCliSiTef.AbortarTransacaoEmAndamento;
begin
  fUltimoRetornoAPI := CRET_ITERATIVO_CONTINUA * -1;
end;

function TACBrTEFAPIClassCliSiTef.CancelarTransacao(const NSU,
  CodigoAutorizacaoTransacao: string; DataHoraTransacao: TDateTime;
  Valor: Double; const CodigoFinalizacao: string; const Rede: string): Boolean;
var
   ValorStr: String;
begin
  ValorStr := FormatFloat('0.00',Valor);
  fRespostasPorTipo.ValueInfo[146] := ValorStr;
  fRespostasPorTipo.ValueInfo[147] := ValorStr;
  fRespostasPorTipo.ValueInfo[515] := FormatDateTime('DDMMYYYY',DataHoraTransacao) ;
  fRespostasPorTipo.ValueInfo[516] := NSU ;

  Result := ExecutarTransacaoSiTef(fOperacaoCancelamento, Valor);
end;

procedure TACBrTEFAPIClassCliSiTef.ExibirMensagemPinPad(const MsgPinPad: String);
var
  s: AnsiString;
begin
  s := AjustarMensagemPinPad(MsgPinPad);
  fTEFCliSiTefAPI.EscreveMensagemPinPad(s);
end;

function TACBrTEFAPIClassCliSiTef.ObterDadoPinPad(
  TipoDado: TACBrTEFAPIDadoPinPad; TimeOut: integer; MinLen: SmallInt;
  MaxLen: SmallInt): String;
Var
  DadoPortador: String;
  Ok: Boolean;
begin
  Result := '';
  DadoPortador := DadoPinPadToOperacao(TipoDado);
  if (DadoPortador = '') then
  begin
    fpACBrTEFAPI.DoException(Format(ACBrStr(sACBrTEFAPICapturaNaoSuportada),
      [GetEnumName(TypeInfo(TACBrTEFAPIDadoPinPad), integer(TipoDado) ), ClassName] ));
  end;

  if (MinLen = 0) and (MaxLen = 0) then
    CalcularTamanhosCampoDadoPinPad(TipoDado, MinLen, MaxLen);

  // SiTef espera o tempo em Segundos.. convertendo de milisegundos
  if (TimeOut > 1000) then
    TimeOut := trunc(TimeOut/1000)
  else if (TimeOut > 100)then
    TimeOut := trunc(TimeOut/100);

  fRespostasPorTipo.ValueInfo[2967] := DadoPortador;
  fRespostasPorTipo.ValueInfo[2968] := IntToStr(MinLen);
  fRespostasPorTipo.ValueInfo[2969] := IntToStr(MaxLen);
  fRespostasPorTipo.ValueInfo[2970] := IntToStr(TimeOut);

  //https://dev.softwareexpress.com.br/docs/clisitef-leitura-de-campo-aberto-no-pinpad/api_prototipo_das_funcoes
  Ok := ExecutarTransacaoSiTef(CSITEF_OP_DadosPinPadAberto, 0);
  if Ok then
    Result := fpACBrTEFAPI.UltimaRespostaTEF.LeInformacao(2971,0).AsString;
end;

end.


