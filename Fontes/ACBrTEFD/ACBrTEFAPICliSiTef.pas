{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
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

const
  CSUBDIRETORIO_PAYGOWEB = 'PGWeb';
  CSITEF_OP_Venda = 0;
  CSITEF_OP_Administrativo = 110;
  CSITEF_OP_Cancelamento = 200;
  CSITEF_ESPERA_MINIMA_MSG_FINALIZACAO = 5000;
  CSITEF_OP_DadosPinPadAberto = 789;

  CSITEF_RestricoesCueque = '10';
  CSITEF_RestricoesCredito = '24;26;27;28;29;30;34;35;44;73';
  CSITEF_RestricoesDebito = '16;17;18;19;42;43';
  CSITEF_RestricoesAVista = '16;24;26;34';
  CSITEF_RestricoesParcelado = '18;35;44';
  CSITEF_RestricoesParcelaEstabelecimento = '27;3988';
  CSITEF_RestricoesParcelaAministradora = '28;3988';

// https://dev.softwareexpress.com.br/en/docs/clisitef/clisitef_documento_principal/

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
    fPinPadChaveAcesso: AnsiString;
    fPinPadIdentificador: AnsiString;
    fTEFCliSiTefAPI: TACBrTEFCliSiTefAPI;
    fOperacaoVenda: Integer;
    fOperacaoAdministrativa: Integer;
    fOperacaoCancelamento: Integer;
    fAutorizador: String;
  private
    function ExecutarTransacaoSiTef(Funcao: Integer; Valor: Double): Boolean;
    procedure FazerRequisicaoSiTef(Funcao: Integer; Valor: Double);
    procedure ContinuarRequisicaoSiTef;
    procedure FinalizarTransacaoSiTef(Confirma: Boolean; const DocumentoVinculado: String = '');
    procedure InterpretarRetornoCliSiTef(const Ret: Integer);
    function DadoPinPadToOperacao(ADadoPinPad: TACBrTEFAPIDadoPinPad): String;

  protected
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
      DataPreDatado: TDateTime = 0): Boolean; override;

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

    property TEFCliSiTefAPI: TACBrTEFCliSiTefAPI read fTEFCliSiTefAPI;

    property OperacaoVenda: Integer read fOperacaoVenda
      write fOperacaoVenda default CSITEF_OP_Venda;
    property OperacaoAdministrativa: Integer read fOperacaoAdministrativa
      write fOperacaoAdministrativa default CSITEF_OP_Administrativo;
    property OperacaoCancelamento: Integer read fOperacaoCancelamento
      write fOperacaoCancelamento default CSITEF_OP_Cancelamento;

    property PinPadChaveAcesso: AnsiString read fPinPadChaveAcesso
      write fPinPadChaveAcesso;
    property PinPadIdentificador: AnsiString read fPinPadIdentificador
      write fPinPadIdentificador;

    property ParamAdicConfig: TACBrTEFParametros read fParamAdicConfig;
    property ParamAdicFuncao: TACBrTEFParametros read fParamAdicFuncao;
    property ParamAdicFinalizacao: TACBrTEFParametros read fParamAdicFinalizacao;
    property RespostasPorTipo: TACBrTEFParametros read fRespostasPorTipo;

    property Autorizador: String read fAutorizador write fAutorizador;
    property IniciouRequisicao: Boolean read fIniciouRequisicao;
  end;

implementation

uses
  Math,
  StrUtils,
  TypInfo,
  ACBrUtil.Strings,
  ACBrUtil.Base;

{ TACBrTEFAPIClassCliSiTef }

constructor TACBrTEFAPIClassCliSiTef.Create(AACBrTEFAPI: TACBrTEFAPIComum);
begin
  inherited;

  fpTEFRespClass := TACBrTEFRespCliSiTef;

  fOperacaoVenda := CSITEF_OP_Venda;
  fOperacaoAdministrativa := CSITEF_OP_Administrativo;
  fOperacaoCancelamento := CSITEF_OP_Cancelamento;

  fPinPadChaveAcesso := '';
  fPinPadIdentificador := '';
  fIniciouRequisicao := False;
  fDocumentosFinalizados := '';
  fUltimoRetornoAPI := 0;
  fAutorizador := '';

  fParamAdicConfig := TACBrTEFParametros.Create;
  fParamAdicFuncao := TACBrTEFParametros.Create;
  fParamAdicFinalizacao := TACBrTEFParametros.Create;
  fRespostasPorTipo := TACBrTEFParametros.Create;
  fTEFCliSiTefAPI := TACBrTEFCliSiTefAPI.Create;
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
  ParamAdic, EnderecoIP, CodLoja, NumeroTerminal: AnsiString;
  Erro: String;

  procedure ApagarChaveSeExistir(Chave: String);
  var
    p: Integer;
  begin
    p := ParamAdicConfig.IndexOf(Chave);
    if (p >= 0) then
      ParamAdicConfig.Delete(p);
  end;

begin
  if Inicializado then
    Exit;

  fTEFCliSiTefAPI.PathDLL := PathDLL;
  fTEFCliSiTefAPI.Inicializada := True;

  PortaPinPad := StrToIntDef( OnlyNumber(fpACBrTEFAPI.DadosTerminal.PortaPinPad), 0);
  // configura��o da porta do pin-pad
  if (PortaPinPad > 0) then
    ParamAdicConfig.Values['PortaPinPad'] := IntToStr(PortaPinPad)
  else
    ApagarChaveSeExistir('PortaPinPad');

  if fpACBrTEFAPI.DadosAutomacao.SuportaViasDiferenciadas then
    ParamAdicConfig.Values['MultiplosCupons'] := '1'
  else
    ApagarChaveSeExistir('MultiplosCupons');

  // cielo premia
  if fpACBrTEFAPI.DadosAutomacao.SuportaDesconto then
    ParamAdicConfig.Values['VersaoAutomacaoCielo'] := PadRight( fpACBrTEFAPI.DadosAutomacao.NomeSoftwareHouse, 8 ) + '10'
  else
    ApagarChaveSeExistir('VersaoAutomacaoCielo');

  // acertar quebras de linhas e abertura e fechamento da lista de parametros
  ParamAdic := StringReplace(Trim(ParamAdicConfig.Text), sLineBreak, ';', [rfReplaceAll]);
  if NaoEstaVazio(ParamAdic) then
    ParamAdic := '['+ ParamAdic + ']';

  if NaoEstaVazio(fpACBrTEFAPI.DadosEstabelecimento.CNPJ) and
    NaoEstaVazio(fpACBrTEFAPI.DadosAutomacao.CNPJSoftwareHouse) then
  begin
    if NaoEstaVazio(ParamAdic) then
      ParamAdic := ParamAdic + ';';

    ParamAdic := ParamAdic + '[ParmsClient=1='+fpACBrTEFAPI.DadosEstabelecimento.CNPJ+';'+
                                          '2='+fpACBrTEFAPI.DadosAutomacao.CNPJSoftwareHouse+']';
  end;

  EnderecoIP := IfEmptyThen(fpACBrTEFAPI.DadosTerminal.EnderecoServidor, 'localhost');
  CodLoja := IfEmptyThen(fpACBrTEFAPI.DadosTerminal.CodFilial, IfEmptyThen(fpACBrTEFAPI.DadosTerminal.CodEmpresa, '00000000' ));
  NumeroTerminal := IfEmptyThen(fpACBrTEFAPI.DadosTerminal.CodTerminal, 'SE000001');

  fpACBrTEFAPI.GravarLog( '*** ConfiguraIntSiTefInterativoEx. '+
                          ' EnderecoIP: ' + EnderecoIP +
                          ' CodigoLoja: ' + CodLoja +
                          ' NumeroTerminal: ' + NumeroTerminal +
                          ' Resultado: 0' +
                          ' ParametrosAdicionais: '+ParamAdic ) ;

  Sts := fTEFCliSiTefAPI.ConfiguraIntSiTefInterativo(
           PAnsiChar(EnderecoIP),
           PAnsiChar(CodLoja),
           PAnsiChar(NumeroTerminal),
           0,
           PAnsiChar(ParamAdic) );

  Erro := fTEFCliSiTefAPI.TraduzirErroInicializacao(Sts);
  if (Erro <> '') then
    fpACBrTEFAPI.DoException(ACBrStr(Erro));

  fpACBrTEFAPI.GravarLog( '   Inicializado CliSiTEF' );
  inherited;
  ExecutarTransacaoSiTef(130,0);

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
  if (fUltimoRetornoAPI = 10000) then
    ContinuarRequisicaoSiTef;

  Result := (fUltimoRetornoAPI = 0);

  if Result then
    fpACBrTEFAPI.UltimaRespostaTEF.Conteudo.GravaInformacao(899,103, IntToStr(Trunc(SimpleRoundTo( Valor * 100 ,0))) );

  fpACBrTEFAPI.UltimaRespostaTEF.Conteudo.GravaInformacao(899, 102, fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao);
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

   //TODO: Verificar se precisa disso (n�o consta no manual atual)
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
   DoctoStr := fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao;
   OperadorStr := fpACBrTEFAPI.DadosTerminal.Operador;
   ParamAdicStr := StringReplace(Trim(fParamAdicFuncao.Text), sLineBreak, ';', [rfReplaceAll]);
   fDocumentosFinalizados := '' ;

   fpACBrTEFAPI.UltimaRespostaTEF.Clear;
   fpACBrTEFAPI.GravarLog( '*** IniciaFuncaoSiTefInterativo. Modalidade: '+IntToStr(Funcao)+
                           ' Valor: '+ValorStr+
                           ' Documento: '+DoctoStr+
                           ' Data: '+DataStr+
                           ' Hora: '+HoraStr+
                           ' Operador: '+OperadorStr+
                           ' ParamAdic: '+ParamAdicStr ) ;

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
var
  Continua, ItemSelecionado, EsperaMensagem: Integer;
  ProximoComando,TamanhoMinimo, TamanhoMaximo : SmallInt;
  TipoCampo: LongInt;
  Buffer: array [0..20000] of AnsiChar;
  Mensagem, TituloMenu: String ;
  Resposta: String;
  SL: TStringList ;
  Interromper, Digitado, Voltar, Validado, EhCarteiraDigital: Boolean ;

  DefinicaoCampo: TACBrTEFAPIDefinicaoCampo;
  TefAPI: TACBrTEFAPI;
  RespCliSiTef: TACBrTEFRespCliSiTef;

//  LRespostaTEFPendente: TACBrTEFResp;
//  LDataHoraStr:string;

  function AjustarMensagemTela(AMensagem : String): String;
  begin
    Result := StringReplace( ACBrStr(AMensagem), '@', sLineBreak, [rfReplaceAll] );
    Result := StringReplace( Result, '/n', sLineBreak, [rfReplaceAll] );
  end;

begin
  fIniciouRequisicao := True ;
  Interromper := False;
  fCancelamento := False ;
  fReimpressao := False;
  EhCarteiraDigital := False;
  Continua := 0;
  Resposta := '';
  Buffer := '';
  TituloMenu := '' ;

  TefAPI := TACBrTEFAPI(fpACBrTEFAPI);
  RespCliSiTef := TACBrTEFRespCliSiTef(fpACBrTEFAPI.UltimaRespostaTEF);
  try
    repeat
      fpACBrTEFAPI.GravarLog( 'ContinuaFuncaoSiTefInterativo, Chamando: Continua = '+
                              IntToStr(Continua)+' Buffer = '+Resposta ) ;

      ProximoComando := 0;
      TipoCampo := 0;
      TamanhoMinimo := 0;
      TamanhoMaximo := 0;
      fUltimoRetornoAPI := fTEFCliSiTefAPI.ContinuaFuncaoSiTefInterativo(
                             ProximoComando,
                             TipoCampo,
                             TamanhoMinimo,
                             TamanhoMaximo,
                             Buffer, sizeof(Buffer),
                             Continua );

      Continua := 0;
      Resposta := '';
      Mensagem := TrimRight(Buffer);
      fpACBrTEFAPI.GravarLog( 'ContinuaFuncaoSiTefInterativo, '+
                              ' Retornos: STS = '+IntToStr(fUltimoRetornoAPI)+
                              ' ProximoComando = '+IntToStr(ProximoComando)+
                              ' TipoCampo = '+IntToStr(TipoCampo)+
                              ' Buffer = '+Mensagem +
                              ' Tam.Min = '+IntToStr(TamanhoMinimo) +
                              ' Tam.Max = '+IntToStr(TamanhoMaximo)) ;

      Resposta := '';
      Voltar := False;
      Digitado := True;

      if (fUltimoRetornoAPI = 10000) then
      begin
        if (TipoCampo > 0) then
          Resposta := fRespostasPorTipo.ValueInfo[TipoCampo];

        if (TipoCampo = 5005) then   // 5005 - Indica que a transa��o foi finalizada
          EsperaMensagem := CSITEF_ESPERA_MINIMA_MSG_FINALIZACAO
        else
          EsperaMensagem := -1;

        case ProximoComando of
          0:  // Est� devolvendo um valor para ser armazenado pela automa��o
          begin
            RespCliSiTef.GravaInformacao(TipoCampo, Mensagem);

            case TipoCampo of
              15:
                RespCliSiTef.GravaInformacao(TipoCampo, 'True'); //Selecionou Debito;
              25:
                RespCliSiTef.GravaInformacao(TipoCampo, 'True'); //Selecionou Credito;
              29:
                RespCliSiTef.GravaInformacao(TipoCampo, 'True'); //Cart�o Digitado;
              56, 57, 58:
                fReimpressao := True;
              107:
                EhCarteiraDigital := True;
              110:
                fCancelamento:= True;

//              160://cupom fiscal
//              begin
//                LRespostaTEFPendente := TACBrTEFResp.Create;
//                LRespostaTEFPendente.Conteudo.GravaInformacao(899,100,'CRT');
//                LRespostaTEFPendente.Conteudo.GravaInformacao(025,000,'True');
//                LRespostaTEFPendente.Confirmar := true;
//                LRespostaTEFPendente.Conteudo.GravaInformacao(899,101, Mensagem);
//              end;
//              161://identificar pagamento
//              begin
////                LRespostaTEFPendente.Conteudo.GravaInformacao(899,101, Mensagem);
//              end;
//              163://data documento //yyyymmdd
//              begin
//                LDataHoraStr := Mensagem;
//              end;
//              164://hora   //hhmmss
//              begin
//                LDataHoraStr := LDataHoraStr + Mensagem;
//                LRespostaTEFPendente.Conteudo.GravaInformacao(105,000,LDataHoraStr);
//              end;
//              210://numero total pendencias
//              begin
//                fpACBrTEFAPI.GravarLog( '*** Numero de transa��es Pendentes '+ Mensagem) ;
//              end;
//              211://tipo de pagamento credito debito etc
//              begin
//                LRespostaTEFPendente.Conteudo.GravaInformacao(899,102, Mensagem);
//              end;
//              1319: /// valor da transacao
//              begin
//                LRespostaTEFPendente.Conteudo.GravaInformacao(899,103,Mensagem);
//                fpACBrTEFAPI.RespostasTEF.AdicionarRespostaTEF(LRespostaTEFPendente);
//
//                LRespostaTEFPendente.free;
//              end;

            end;
          end;

          1:  // Mensagem para o visor do operador
          begin
            Mensagem := AjustarMensagemTela(Mensagem);
            TefAPI.QuandoExibirMensagem(Mensagem, telaOperador, EsperaMensagem);
          end;

          2:  // Mensagem para o visor do cliente
          begin
            Mensagem := AjustarMensagemTela(Mensagem);
            TefAPI.QuandoExibirMensagem(Mensagem, telaCliente, EsperaMensagem);
          end;

          3:  // Mensagem para os dois visores
          begin
            Mensagem := AjustarMensagemTela(Mensagem);
            TefAPI.QuandoExibirMensagem(Mensagem, telaTodas, EsperaMensagem);
            if EhCarteiraDigital then
            begin
              Interromper := False;
              TefAPI.QuandoEsperarOperacao(opapiLeituraQRCode, Interromper);
            end;
          end;

          4:  // Texto que dever� ser utilizado como t�tulo na apresenta��o do menu ( vide comando 21)
            TituloMenu := AjustarMensagemTela(Mensagem);

          11: // Deve remover a mensagem apresentada no visor do operador (comando 1)
            TefAPI.QuandoExibirMensagem('', telaOperador, -1);

          12: // Deve remover a mensagem apresentada no visor do cliente (comando 2)
            TefAPI.QuandoExibirMensagem('', telaCliente, -1);

           13: // Deve remover mensagem apresentada no visor do operador e do cliente (comando 3)
             TefAPI.QuandoExibirMensagem('', telaTodas, -1);

           14:  // Deve limpar o texto utilizado como t�tulo na apresenta��o do menu (comando 4)
             TituloMenu := '';

           15,  // Cabe�alho a ser apresentado pela aplica��o. Refere-se a exibi��o de informa��es adicionais que algumas transa��es necessitam mostrar na tela.
           16:  // Deve remover o cabe�alho apresentado pelo comando 15
              ; // TODO: ainda n�o implementado

           20:  // Deve apresentar o texto em Buffer, e obter uma resposta do tipo SIM/N�O.
           begin
             if Mensagem = '' then
               Mensagem := 'CONFIRMA ?';

             SL := TStringList.Create;
             try
               SL.Add('SIM');
               SL.Add(ACBrStr('N�O'));

               ItemSelecionado := -1;
               TefAPI.QuandoPerguntarMenu( Mensagem, SL, ItemSelecionado);
               Resposta := IfThen(ItemSelecionado = 0, '0', '1');
               // 5013 - Confirma Cancelamento. Se a resposta a mensagem for n�o, n�o deixar interromper voltar ao loop
               if (TipoCampo = 5013) and (Resposta = '1') then
                 Interromper := False;
             finally
               SL.Free;
             end;
           end ;

           21:  // Deve apresentar um menu de op��es e permitir que o usu�rio selecione uma delas
           begin
             SL := TStringList.Create;
             try
               SL.Text := StringReplace(Mensagem, ';', sLineBreak, [rfReplaceAll]);
               ItemSelecionado := -1 ;
               TefAPI.QuandoPerguntarMenu(TituloMenu, SL, ItemSelecionado);

               if (ItemSelecionado = -1) then
                 Interromper := True
               else if (ItemSelecionado = -2) then
                 Voltar := True
               else
               begin
                 if (ItemSelecionado >= 0) and (ItemSelecionado < SL.Count) then
                   Resposta := copy( SL[ItemSelecionado], 1, pos(':',SL[ItemSelecionado])-1 )
                 else
                   Digitado := False ;
               end;
             finally
               SL.Free ;
             end ;
           end;

           22:  // Deve apresentar a mensagem em Buffer, e aguardar uma tecla do operador.
           begin
             if (Mensagem = '') then
               Mensagem := CACBrTEFCliSiTef_PressioneEnter
             else
               Mensagem := AjustarMensagemTela(Mensagem);

             TefAPI.QuandoExibirMensagem(Mensagem, telaOperador, 0);
           end;

           23:  // Este comando indica que a rotina est� perguntando para a aplica��o se ele deseja interromper o processo de coleta de dados ou n�o
           begin
             Interromper := False;
             TefAPI.QuandoEsperarOperacao(opapiPinPad, Interromper);
           end;

           29:  // deve ser coletado um campo que n�o requer interven��o do operador de caixa, ou seja, n�o precisa que seja digitado/mostrado na tela, e sim passado diretamente para a biblioteca pela automa��o
             { Nada a Fazer, Resposta j� foi atribuida por
               Resposta := fRespostasPorTipo.ValueInfo[TipoCampo] };

           30:  // Deve ser lido um campo cujo tamanho est� entre TamMinimo e TamMaximo
           begin
             DefinicaoCampo.TipoCampo := TipoCampo;
             DefinicaoCampo.TituloPergunta := ACBrStr(Mensagem);
             DefinicaoCampo.TipoDeEntrada := tedTodos;
             DefinicaoCampo.TamanhoMaximo := TamanhoMaximo;
             DefinicaoCampo.TamanhoMinimo := TamanhoMinimo;
             DefinicaoCampo.MascaraDeCaptura := EmptyStr;

             Validado := True;
             if Resposta = '' then
               TefAPI.QuandoPerguntarCampo(DefinicaoCampo, Resposta, Validado, Interromper);

             if Resposta = '-1' then
               Interromper := True
             else if Resposta = '-2' then
               Voltar := True
             else
               RespCliSiTef.GravaInformacao(TipoCampo, Resposta);
           end;

           31:  // Deve ser lido o n�mero de um cheque. A coleta pode ser feita via leitura de CMC-7, digita��o do CMC-7 ou pela digita��o da primeira linha do cheque
           begin
             DefinicaoCampo.TipoCampo := TipoCampo;
             DefinicaoCampo.TituloPergunta := ACBrStr(Mensagem);
             DefinicaoCampo.TipoDeEntrada := tedNumerico;
             DefinicaoCampo.TipoEntradaCodigoBarras := tbQualquer;
             DefinicaoCampo.TamanhoMaximo := TamanhoMaximo;
             DefinicaoCampo.TamanhoMinimo := TamanhoMinimo;

             Validado := True;
             if Resposta = '' then
               TefAPI.QuandoPerguntarCampo(DefinicaoCampo, Resposta, Validado, Interromper);

             if Resposta = '-1' then
               Interromper := True
             else if Resposta = '-2' then
               Voltar := True
             else
               RespCliSiTef.GravaInformacao(TipoCampo, Resposta);
           end;

           34:  // Deve ser lido um campo monet�rio ou seja, aceita o delimitador de centavos e devolvido no par�metro Buffer
           begin
             DefinicaoCampo.TipoCampo := TipoCampo;
             DefinicaoCampo.TituloPergunta := ACBrStr(Mensagem);
             DefinicaoCampo.TipoDeEntrada := tedNumerico;
             DefinicaoCampo.MascaraDeCaptura := '@@@@@@@@@,@@';
             DefinicaoCampo.TipoEntradaCodigoBarras := tbQualquer;
             DefinicaoCampo.TamanhoMaximo := TamanhoMaximo;
             DefinicaoCampo.TamanhoMinimo := TamanhoMinimo;

             Validado := True;
             if Resposta = '' then
               TefAPI.QuandoPerguntarCampo(DefinicaoCampo, Resposta, Validado, Interromper);

             if Resposta = '-1' then
               Interromper := True
             else if Resposta = '-2' then
               Voltar := True
             else
             begin
               Resposta := FormatFloatBr(StringToFloatDef(Resposta, 0));  // Garantindo que a Resposta � Float //
               RespCliSiTef.GravaInformacao(TipoCampo, Resposta);
             end;
           end;

           35:  // Deve ser lido um c�digo em barras ou o mesmo deve ser coletado manualmente.
           begin
             DefinicaoCampo.TipoCampo := TipoCampo;
             DefinicaoCampo.TituloPergunta := ACBrStr(Mensagem);
             DefinicaoCampo.TipoDeEntrada := tedNumerico;
             DefinicaoCampo.TipoEntradaCodigoBarras := tbLeitor;
             DefinicaoCampo.TamanhoMaximo := TamanhoMaximo;
             DefinicaoCampo.TamanhoMinimo := TamanhoMinimo;

             Validado := True;
             if Resposta = '' then
               TefAPI.QuandoPerguntarCampo(DefinicaoCampo, Resposta, Validado, Interromper);

             if Resposta = '-1' then
               Interromper := True
             else if Resposta = '-2' then
               Voltar := True
             else
               RespCliSiTef.GravaInformacao(TipoCampo, Resposta);
           end;

           41:  // An�logo ao Comando 30, por�m o campo deve ser coletado de forma mascarada
           begin
             DefinicaoCampo.TipoCampo := TipoCampo;
             DefinicaoCampo.TituloPergunta := ACBrStr(Mensagem);
             DefinicaoCampo.TipoDeEntrada := tedTodos;
             DefinicaoCampo.TamanhoMaximo := TamanhoMaximo;
             DefinicaoCampo.TamanhoMinimo := TamanhoMinimo;
             DefinicaoCampo.OcultarDadosDigitados := True;

             Validado := True;
             if Resposta = '' then
               TefAPI.QuandoPerguntarCampo(DefinicaoCampo, Resposta, Validado, Interromper);

             if Resposta = '-1' then
               Interromper := True
             else if Resposta = '-2' then
               Voltar := True
             else
               RespCliSiTef.GravaInformacao(TipoCampo, Resposta);
           end;

           50:  // Exibir QRCode
             TefAPI.QuandoExibirQRCode(AjustarMensagemTela(Mensagem));

           51:  // Remover QRCode
             TefAPI.QuandoExibirQRCode('');

           52:  // Mensagem de rodap� QRCode
           begin
             Interromper := False;
             TefAPI.QuandoExibirMensagem(ACBrStr(Mensagem), telaCliente, -1);
             TefAPI.QuandoEsperarOperacao(opapiLeituraQRCode, Interromper);
           end;
        end;
      end;

      if (fUltimoRetornoAPI <> 10000) then
      begin
        fpACBrTEFAPI.GravarLog( '*** ContinuaFuncaoSiTefInterativo, Finalizando: STS = '+
                                IntToStr(fUltimoRetornoAPI) ) ;
        Interromper := True;
      end;

      if Voltar then
        Continua := 1     // Volta para o menu anterior
      else if (not Digitado) or Interromper then
        Continua := -1 ;  // Cancela operacao

      if Interromper or (not Digitado) or (Voltar and (fUltimoRetornoAPI = 10000)) then
        TefAPI.QuandoExibirMensagem('', telaTodas, -1);

      StrPCopy(Buffer, Resposta);
    until (fUltimoRetornoAPI <> 10000);
  finally
    fIniciouRequisicao := False;
  end;
end;

procedure TACBrTEFAPIClassCliSiTef.FinalizarTransacaoSiTef(Confirma: Boolean;
  const DocumentoVinculado: String);
Var
   DataStr, HoraStr, DoctoStr, ParamAdic: AnsiString;
   Finalizacao : SmallInt;
   AMsg: String;
   DataHora: TDateTime;
begin
   fRespostasPorTipo.Clear;
   fIniciouRequisicao := False;

   // Re-Impress�o n�o precisa de Finaliza��o
   if fReimpressao then
     Exit;

   // J� Finalizou este Documento por outra Transa��o ?
   if (DocumentoVinculado <> '') then
     DoctoStr := DocumentoVinculado
   else
     DoctoStr := fpACBrTEFAPI.RespostasTEF.IdentificadorTransacao;

   if (pos(DoctoStr, fDocumentosFinalizados) > 0) then
     Exit;

  fDocumentosFinalizados := fDocumentosFinalizados + DocumentoVinculado + '|' ;
  // Leu com sucesso o arquivo pendente. Transa��es com mais de tr�s dias s�o finalizadas automaticamente pela SiTef
  if (fpACBrTEFAPI.UltimaRespostaTEF.DataHoraTransacaoComprovante > (date - 3)) then
    DataHora := fpACBrTEFAPI.UltimaRespostaTEF.DataHoraTransacaoComprovante
  else
    DataHora := Now;

  // acertar quebras de linhas e abertura e fechamento da lista de parametros
  ParamAdic := StringReplace(Trim(ParamAdicFinalizacao.Text), sLineBreak, '', [rfReplaceAll]);
  DataStr := FormatDateTime('YYYYMMDD', DataHora);
  HoraStr := FormatDateTime('HHNNSS', DataHora);
  Finalizacao := ifthen(Confirma or fCancelamento, 1, 0);

  fpACBrTEFAPI.GravarLog( '*** FinalizaTransacaoSiTefInterativo. Confirma: '+
                          IfThen(Finalizacao = 1,'SIM','NAO')+
                          ' Documento: ' +DoctoStr+
                          ' Data: '      +DataStr+
                          ' Hora: '      +HoraStr+
                          ' ParametrosAdicionais: '+ParamAdic ) ;

  fTEFCliSiTefAPI.FinalizaFuncaoSiTefInterativo( Finalizacao,
                                                 PAnsiChar(DoctoStr),
                                                 PAnsiChar(DataStr),
                                                 PAnsiChar(HoraStr),
                                                 PAnsiChar(ParamAdic) ) ;

  if not Confirma then
  begin
    if fCancelamento then
      AMsg := Format( CACBrTEFCliSiTef_TransacaoEfetuadaReImprimir,
                      [fpACBrTEFAPI.UltimaRespostaTEF.NSU] )
    else
      AMsg := CACBrTEFCliSiTef_TransacaoNaoEfetuada;

    TACBrTEFAPI(fpACBrTEFAPI).QuandoExibirMensagem(AMsg, telaOperador, 0);
  end;
end;

procedure TACBrTEFAPIClassCliSiTef.InterpretarRetornoCliSiTef(const Ret: Integer);
var
  Erro: String;
begin
  Erro := fTEFCliSiTefAPI.TraduzirErroTransacao(Ret);
  if (Erro <> '') then
    fpACBrTEFAPI.DoException( ACBrStr(Erro) ) ;
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

procedure TACBrTEFAPIClassCliSiTef.InterpretarRespostaAPI;
begin
  fpACBrTEFAPI.GravarLog( fpACBrTEFAPI.UltimaRespostaTEF.Conteudo.Conteudo.Text );
  fpACBrTEFAPI.UltimaRespostaTEF.ViaClienteReduzida := fpACBrTEFAPI.DadosAutomacao.ImprimeViaClienteReduzida;
  fpACBrTEFAPI.UltimaRespostaTEF.Sucesso := (fUltimoRetornoAPI = 0);


  fpACBrTEFAPI.UltimaRespostaTEF.ConteudoToProperty;
  if (fUltimoRetornoAPI <> 0) then
    fpACBrTEFAPI.UltimaRespostaTEF.TextoEspecialOperador := ACBrStr(fTEFCliSiTefAPI.TraduzirErroTransacao(fUltimoRetornoAPI));
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

function TACBrTEFAPIClassCliSiTef.EfetuarPagamento(
  ValorPagto: Currency;
  Modalidade: TACBrTEFModalidadePagamento; CartoesAceitos: TACBrTEFTiposCartao;
  Financiamento: TACBrTEFModalidadeFinanciamento; Parcelas: Byte;
  DataPreDatado: TDateTime): Boolean;
var
  Op, i: Integer;
  SL: TStringList;
  Restr, Restricoes: String;
begin
  VerificarIdentificadorVendaInformado;
  if (ValorPagto <= 0) then
    fpACBrTEFAPI.DoException(sACBrTEFAPIValorPagamentoInvalidoException);

  Op := fOperacaoVenda;
  case Modalidade of
    tefmpDinheiro:
      Op := 0;    // Pagamento gen�rico
    tefmpCheque:
      Op := 1;    // Cheque
    tefmpCarteiraVirtual:
      Op := 122;  // Venda via Carteira Digital
  else
    if (teftcCredito in CartoesAceitos) and (teftcDebito in CartoesAceitos) then
      Op := 0   // Pagamento gen�rico.
    else if (teftcDebito in CartoesAceitos) then
      Op := 2   // D�bito
    else if (teftcCredito in CartoesAceitos) then
      Op := 3   // Cr�dito
    else if (teftcVoucher in CartoesAceitos) then
      Op := 5   // Cart�o Benef�cio
    else if (teftcFrota in CartoesAceitos) then
      Op := 7   // Cart�o Combust�vel
    else if (teftcPrivateLabel in CartoesAceitos) then
      Op := 15  // Venda com cart�o Gift
    else
      Op := 0;  // Pagamento gen�rico.
  end;

  if (TACBrTEFAPI(fpACBrTEFAPI).ExibicaoQRCode = qrapiExibirAplicacao) then
  begin
    if (pos('DevolveStringQRCode', fParamAdicConfig.Text) = 0) then
      fParamAdicConfig.Add('{DevolveStringQRCode=1}');
  end;

  Restricoes := '';
  if (pos('[', fParamAdicFuncao.Text) = 0) then   // N�o especificou Restri��es de Menu ?
  begin
    if (Op <> 1) then       // D�bito
      Restricoes := Restricoes + CSITEF_RestricoesCueque + ';';

    if (Op = 2) then       // D�bito
      Restricoes := Restricoes + CSITEF_RestricoesCredito + ';'
    else if (Op = 3) then  // Cr�dito
      Restricoes := Restricoes + CSITEF_RestricoesDebito + ';';

    if (Financiamento = tefmfAVista) then
    begin
      Restricoes := Restricoes + CSITEF_RestricoesParcelado + ';';
      Restricoes := Restricoes + CSITEF_RestricoesParcelaAministradora + ';';
      Restricoes := Restricoes + CSITEF_RestricoesParcelaEstabelecimento + ';';
    end
    else if (Financiamento = tefmfParceladoEmissor) then
    begin
      Restricoes := Restricoes + CSITEF_RestricoesAVista + ';';
      Restricoes := Restricoes + CSITEF_RestricoesParcelaEstabelecimento + ';';
    end
    else if (Financiamento = tefmfParceladoEstabelecimento) then
    begin
      Restricoes := Restricoes + CSITEF_RestricoesAVista + ';';
      Restricoes := Restricoes + CSITEF_RestricoesParcelaAministradora + ';';
    end;


    SL := TStringList.Create;
    try
      SL.Text := StringReplace(Restricoes, ';', sLineBreak, [rfReplaceAll]);

      // Removendo Itens repetidos
      i := 0;
      Restr := '';
      SL.Sort;
      while (i < SL.Count) do
      begin
        Restr := SL[i];
        inc(i);
        while (i < SL.Count) and (Restr = SL[i]) do
          SL.Delete(i);
      end;

      // Convertendo para formato de par�metro, conforme esperado
      if (SL.Count > 0) then
      begin
        Restricoes := StringReplace(Trim(SL.Text), sLineBreak, ';', [rfReplaceAll]);
        if Restricoes <> '' then
          Restricoes := '['+Restricoes+']';
        if fParamAdicConfig.Count > 0 then
           Restricoes := Restricoes + ';'+ Trim(fParamAdicConfig.Text);

        if (Restricoes <> '') then
          fParamAdicFuncao.Add( Restricoes );
      end;
    finally
      SL.Free;
    end;
  end;


  if (Parcelas <> 0) then
    fRespostasPorTipo.ValueInfo[505] := IntToStr(Parcelas);

  if (DataPreDatado <> 0) then
    fRespostasPorTipo.ValueInfo[506] := FormatDateTime('DDMMYYYY', DataPreDatado);

  Result := ExecutarTransacaoSiTef(op, ValorPagto);
end;

procedure TACBrTEFAPIClassCliSiTef.FinalizarTransacao(const Rede, NSU,
  CodigoFinalizacao: String; AStatus: TACBrTEFStatusTransacao);
var
  Confirma: Boolean;
  i: Integer;
  DocumentoVinculado: String;
begin
  // CliSiTEF n�o usa Rede, NSU e Finalizacao
  DocumentoVinculado := '';
  Confirma := (AStatus in [tefstsSucessoAutomatico, tefstsSucessoManual]);
  i := fpACBrTEFAPI.RespostasTEF.AcharTransacao(Rede, NSU, CodigoFinalizacao);
  if (i >= 0) then
    DocumentoVinculado := fpACBrTEFAPI.RespostasTEF[i].DocumentoVinculado;

  FinalizarTransacaoSiTef(Confirma, DocumentoVinculado);
end;

procedure TACBrTEFAPIClassCliSiTef.ResolverTransacaoPendente(
  AStatus: TACBrTEFStatusTransacao);
begin
  FinalizarTransacao( fpACBrTEFAPI.UltimaRespostaTEF.Rede,
                      fpACBrTEFAPI.UltimaRespostaTEF.NSU,
                      fpACBrTEFAPI.UltimaRespostaTEF.Finalizacao,
                      AStatus );
end;

procedure TACBrTEFAPIClassCliSiTef.AbortarTransacaoEmAndamento;
begin
  fUltimoRetornoAPI := -10000;
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
begin
  InterpretarRetornoCliSiTef( fTEFCliSiTefAPI.DefineMensagemPermanentePinPad(MsgPinPad) );
end;

function TACBrTEFAPIClassCliSiTef.ObterDadoPinPad(
  TipoDado: TACBrTEFAPIDadoPinPad; TimeOut: integer; MinLen: SmallInt;
  MaxLen: SmallInt): String;
Var
  DadoPortador: String;
  Ok: Boolean;
begin
  DadoPortador := DadoPinPadToOperacao(TipoDado);
  if (DadoPortador = '') then
  begin
    fpACBrTEFAPI.DoException(Format(ACBrStr(sACBrTEFAPICapturaNaoSuportada),
      [GetEnumName(TypeInfo(TACBrTEFAPIDadoPinPad), integer(TipoDado) ), ClassName] ));
  end;

  if (MinLen = 0) and (MaxLen = 0) then
    CalcularTamanhosCampoDadoPinPad(TipoDado, MinLen, MaxLen);

  fRespostasPorTipo.ValueInfo[2967] := DadoPortador;
  fRespostasPorTipo.ValueInfo[2968] := IntToStr(MinLen);
  fRespostasPorTipo.ValueInfo[2969] := IntToStr(MaxLen);
  fRespostasPorTipo.ValueInfo[2970] := IntToStr(trunc(TimeOut/100));

  Ok := ExecutarTransacaoSiTef(CSITEF_OP_DadosPinPadAberto, 0);
  if Ok then
    Result := fpACBrTEFAPI.UltimaRespostaTEF.LeInformacao(2971,0).AsString;
end;

end.

