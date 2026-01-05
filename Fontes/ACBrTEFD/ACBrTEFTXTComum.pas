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

unit ACBrTEFTXTComum;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils,Contnrs,
  ACBrBase, ACBrTEFComum;

const
  CACBRTEFTXT_NomeGerenciadorNenhum = 'Nenhum';
  CACBrTEFTXT_TimeOutStatus = 7000;
  CACBrTEFTXT_Sleep = 250;

  CACBRTEFTXT_DIRREQ = 'C:\Client\Req\';
  CACBRTEFTXT_DIRRESP = 'C:\Client\Resp\';
  CACBRTEFTXT_ARQREQ = 'IntPos.001';
  CACBRTEFTXT_ARQTEMP = 'IntPos.tmp';
  CACBRTEFTXT_ARQSTS = 'IntPos.sts';
  CACBRTEFTXT_ARQRESP = 'IntPos.001';

resourcestring
  CErroLinhaArquivoTEFInvalida = 'Linha inválida para Arquivo TEF';
  CErroNomeArquivoNaoDefinido = 'Nome de Arquivo não definido';
  CErroNomeArquivoNaoExiste = 'Arquivo %s não existe';
  CErroNomeArquivoJaExiste = 'Arquivo %s já existe';
  CErroDiretorioEstaVazio = 'Diretório de %s não pode ser vazio';
  CErroOperacaoInvalida = 'Operação %s inválida para o TEF %s';
  CErroValorInvalidoParaOCampo = 'Valor %s inválido para o campo %s';
  CErroApagarArquivo = 'Erro ao apagar o arquivo: %s';
  CErroRenomearArquivo = 'Erro ao Renomear:' + sLineBreak + '%s para:' + sLineBreak + '%s';

  CErroGerenciadorNaoResponde = '%s não está respondendo';
  CErroRespostaInvalida = 'Resposta do %s, inválida';
  CErroAguardandoRequisicaoAnterior = 'Requisição anterior não concluida';
  CErroEsperaDeArquivoInterrompida = 'Espera de Resposta interrompida pelo usuário';

  CInfoAguardandoResposta = 'Aguardando Resposta do %s (%s)';

type

  { TACBrTEFCampos }

  TACBrTEFCampos = class(TObjectList{$IfDef HAS_SYSTEM_GENERICS}<TACBrTEFInformacao>{$EndIf})
  private
    function GetCampoIdSeq(AIdentificacao, ASequencia: Integer): TACBrInformacao;
    function GetItem(Index: Integer): TACBrInformacao;
    procedure SetItem(Index: Integer; const Value: TACBrInformacao);

    function ComporIdSeqTEF(AIdentificacao, ASequencia: Integer): String;
  public
    function Add(Obj: TACBrInformacao): Integer;
    procedure Insert(Index: Integer; Obj: TACBrInformacao);
    function New: TACBrInformacao;

    function AdicionarCampo(const AIdentificacao: Integer): TACBrInformacao; overload;
    function AdicionarCampo(const AIdentificacao, ASequencia: Integer; const AValor: String = 'Nil'): TACBrInformacao; overload;

    procedure RemoverCampo(const AIdentificacao: Integer); overload;
    procedure RemoverCampo(const AIdentificacao, ASequencia: Integer); overload;

    property Informacao[Index: Integer]: TACBrInformacao read GetItem write SetItem;
    property Campo[AIdentificacao, ASequencia: Integer]: TACBrInformacao read GetCampoIdSeq;
  end;

  { TACBrTEFTXTArquivo }

  TACBrTEFTXTArquivo = class
  private
    fCampos: TACBrTEFCampos;
    fIgnorarVazios: Boolean;
    function GetCampoIdSeq(AIdentificacao, ASequencia: Integer): TACBrInformacao;
  protected
    property Campos: TACBrTEFCampos read fCampos;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; virtual;

    function LerArquivo(const ANomeArquivo: String): Boolean;
    procedure SalvarArquivo(const ANomeArquivo: String); overload;
    procedure SalvarArquivo(TheStrings: TStrings); overload;

    property IgnorarVazios: Boolean read fIgnorarVazios write fIgnorarVazios default True;

    property Campo[AIdentificacao, ASequencia: Integer]: TACBrInformacao read GetCampoIdSeq;
  end;

  { TACBrTEFTXTConfig }

  TACBrTEFTXTConfig = class
  private
    fArqLog: String;
    fArqReq: String;
    fArqResp: String;
    fArqSts: String;
    fArqTemp: String;
    fDirReq: String;
    fDirResp: String;
    fTempoEsperaLacoVerificacaoArquivo: Integer;
    fTempoLimiteEsperaStatus: Integer;
    procedure SetArqLog(AValue: String);
    procedure SetArqReq(AValue: String);
    procedure SetArqResp(AValue: String);
    procedure SetArqSts(AValue: String);
    procedure SetArqTemp(AValue: String);
    procedure SetDirReq(AValue: String);
    procedure SetDirResp(AValue: String);
    procedure SetEsperaStsMilissegundos(AValue: Integer);
  public
    constructor Create;
    procedure Clear;
    procedure Assign(Source: TACBrTEFTXTConfig);

    property TempoLimiteEsperaStatus: Integer read fTempoLimiteEsperaStatus
      write SetEsperaStsMilissegundos default CACBrTEFTXT_TimeOutStatus;
    property TempoEsperaLacoVerificacaoArquivo: Integer read fTempoEsperaLacoVerificacaoArquivo
      write fTempoEsperaLacoVerificacaoArquivo default CACBrTEFTXT_Sleep;

    property DirReq: String read fDirReq write SetDirReq;
    property DirResp: String read fDirResp write SetDirResp;

    property ArqTemp: String read fArqTemp write SetArqTemp;
    property ArqReq: String read fArqReq write SetArqReq;
    property ArqSts: String read fArqSts write SetArqSts;
    property ArqResp: String read fArqResp write SetArqResp;

    property ArqLog: String read fArqLog write SetArqLog;
    //TODO criar LogLevel e gravar conteúdo dos arquivos
  end;


  TACBrTEFTXTAguardaArquivo = procedure( ArquivoAguardado: String;
    SegundosParaTimeOut: Double; var Interromper: Boolean) of object ;

  { TACBrTEFTXTClass }

  TACBrTEFTXTClass = class
  private
    fConfig: TACBrTEFTXTConfig;
    fQuandoGravarLog: TACBrGravarLog;
    fQuandoAguardarArquivo: TACBrTEFTXTAguardaArquivo;
    fReq: TACBrTEFTXTArquivo;
    fResp: TACBrTEFTXTArquivo;

    function GetArqReq: String;
    function GetArqResp: String;
    function GetArqSts: String;
    function GetArqTemp: String;
    procedure SetConfig(AValue: TACBrTEFTXTConfig);
  protected
    procedure ApagarArquivo(const AArquivo: String);
    procedure GravarLog(const AString: AnsiString; Traduz: Boolean = False);
    procedure DoException(const AErrorMsg: String); virtual;
    function GetModeloTEF: String; virtual;
  public
    constructor Create;
    destructor Destroy; override;

    property ArqTemp: String read GetArqTemp;
    property ArqReq: String read GetArqReq;
    property ArqSts: String read GetArqSts;
    property ArqResp: String read GetArqResp;

    property Req: TACBrTEFTXTArquivo read fReq;
    property Resp: TACBrTEFTXTArquivo read fResp;

    property ModeloTEF: String read GetModeloTEF;
    property Config: TACBrTEFTXTConfig read fConfig write SetConfig;

    property QuandoGravarLog : TACBrGravarLog read fQuandoGravarLog write fQuandoGravarLog;
    property QuandoAguardarArquivo: TACBrTEFTXTAguardaArquivo read fQuandoAguardarArquivo
      write fQuandoAguardarArquivo;
  end;

  TACBrTEFTXTStatus = (tefstLivre, tefstEnviandoRequisicao, tefstAguardandoSts, tefstAguardandoResp);

  TACBrTEFTXTObterID = procedure(AHeader: String; out ID: Integer) of object ;
  TACBrTEFTXTAntesGravarRequisicao = procedure(AReq: TACBrTEFTXTArquivo) of object ;

  { TACBrTEFTXTBaseClass }

  TACBrTEFTXTBaseClass = class( TACBrTEFTXTClass )
  private
    fAntesGravarRequisicao: TACBrTEFTXTAntesGravarRequisicao;
    fQuandoMudarStatus: TNotifyEvent;
    fQuandoObterID: TACBrTEFTXTObterID;
    fStatus: TACBrTEFTXTStatus;
    fIdSeq: Integer;
    procedure SetStatus(AValue: TACBrTEFTXTStatus);
  protected
    procedure ApagarArquivosDeComunicacao; virtual;
    procedure ApagarArquivoStatus; virtual;
    procedure ApagarArquivoResposta; virtual;
    procedure LimparRequisicao; virtual;
    procedure LimparResposta; virtual;
    function ObterID(const AHeader: String): Integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure PrepararRequisicao(const AHeader: String); virtual;
    procedure EnviarRequisicao(AguardaResposta: Boolean = True); virtual;

    procedure GravarRequisicao; virtual;
    function AguardarStatus: Boolean; virtual;
    function AguardarResposta: Boolean; virtual;
    procedure LerArquivoResposta(const AArq: String); virtual;
    function VerificarRespostaValida: Boolean; virtual;

    property Status: TACBrTEFTXTStatus read fStatus write SetStatus;
    property QuandoMudarStatus: TNotifyEvent read fQuandoMudarStatus write fQuandoMudarStatus;
    property QuandoObterID: TACBrTEFTXTObterID read fQuandoObterID write fQuandoObterID;
    property AntesGravarRequisicao: TACBrTEFTXTAntesGravarRequisicao read fAntesGravarRequisicao
      write fAntesGravarRequisicao;
  end;

Procedure DecomporLinhaArquivoTEF(const ALinha: String; out AIdentificacao: Integer; out ASequencia: Integer; out AValor: String);

implementation

uses
  StrUtils, Math, TypInfo, DateUtils,
  ACBrUtil.Strings,
  ACBrUtil.FilesIO;

procedure DecomporLinhaArquivoTEF(const ALinha: String; out
  AIdentificacao: Integer; out ASequencia: Integer; out AValor: String);
var
  lin, s: String;
  pi, pf: Integer;
begin
  lin := Trim(ALinha);
  pi := 1;
  pf := pos('-', lin);
  if (pf = 0) then
    raise EACBrTEFArquivo.Create(ACBrStr(CErroLinhaArquivoTEFInvalida));

  s := Trim(copy(lin, pi, pf-pi));
  AIdentificacao := StrToIntDef(s, -1);
  if (AIdentificacao < 0) then
    raise EACBrTEFArquivo.Create(ACBrStr(CErroLinhaArquivoTEFInvalida));

  pi := pf+1;
  pf := PosEx('=', lin, pi);
  s := Trim(copy(lin, pi, pf-pi));
  ASequencia := StrToIntDef(s, -1);
  if (ASequencia < 0) then
    raise EACBrTEFArquivo.Create(ACBrStr(CErroLinhaArquivoTEFInvalida));

  AValor := Trim(copy(lin, pf+1, Length(lin)));
end;

{ TACBrTEFCampos }

function TACBrTEFCampos.GetItem(Index: Integer): TACBrInformacao;
begin
  Result := TACBrInformacao(inherited Items[Index]);
end;

procedure TACBrTEFCampos.SetItem(Index: Integer; const Value: TACBrInformacao);
begin
  inherited Items[Index] := Value;
end;

function TACBrTEFCampos.ComporIdSeqTEF(AIdentificacao, ASequencia: Integer): String;
begin
  Result := Format('%3.3d', [AIdentificacao])+'-'+Format('%3.3d', [ASequencia]);
end;

function TACBrTEFCampos.Add(Obj: TACBrInformacao): Integer;
begin
  Result := inherited Add(Obj);
end;

procedure TACBrTEFCampos.Insert(Index: Integer; Obj: TACBrInformacao);
begin
  inherited Insert(Index, Obj);
end;

function TACBrTEFCampos.New: TACBrInformacao;
begin
  Result := TACBrInformacao.Create;
  inherited Add(Result);
end;

function TACBrTEFCampos.AdicionarCampo(const AIdentificacao: Integer): TACBrInformacao;
begin
  Result := AdicionarCampo(AIdentificacao, 0);
end;

function TACBrTEFCampos.AdicionarCampo(const AIdentificacao, ASequencia: Integer; const AValor: String
  ): TACBrInformacao;
begin
  Result := Campo[AIdentificacao, ASequencia];
  if (Result = Nil) then
  begin
    Result := Self.New;
    Result.Nome := ComporIdSeqTEF(AIdentificacao, ASequencia);
  end;

  if (AValor <> 'Nil') then
    Result.AsString := AValor;
end;

function TACBrTEFCampos.GetCampoIdSeq(AIdentificacao, ASequencia: Integer): TACBrInformacao;
var
  i: Integer;
  s: String;
begin
  s := ComporIdSeqTEF(AIdentificacao, ASequencia);
  Result := Nil;
  for i := 0 to Self.Count - 1 do
  begin
    if (Self.Informacao[I].Nome = s) then
    begin
      Result := GetItem(i);
      Exit;
    end;
  end;
end;

procedure TACBrTEFCampos.RemoverCampo(const AIdentificacao: Integer);
begin
  RemoverCampo(AIdentificacao, 0);
end;

procedure TACBrTEFCampos.RemoverCampo(const AIdentificacao, ASequencia: Integer);
var
  c: TACBrInformacao;
begin
  c := Campo[AIdentificacao, ASequencia];
  if Assigned(c) then
    remove(c);
end;

{ TACBrTEFTXTArquivo }

constructor TACBrTEFTXTArquivo.Create;
begin
  fCampos := TACBrTEFCampos.Create;
  fIgnorarVazios := True;
end;

procedure TACBrTEFTXTArquivo.Clear;
begin
  Campos.Clear;
end;

destructor TACBrTEFTXTArquivo.Destroy;
begin
  fCampos.Free;
  inherited Destroy;
end;

function TACBrTEFTXTArquivo.LerArquivo(const ANomeArquivo: String): Boolean;
var
  sl: TStringList;
  arq, lin, lVal: String;
  i, lID, lSeq: Integer;
begin
  Result := False;
  arq := Trim(ANomeArquivo);
  if (arq = '') then
    Exit;
  if not FileExists(arq) then
    raise EACBrTEFArquivo.CreateFmt(ACBrStr(CErroNomeArquivoNaoExiste), [arq]) ;

  sl := TStringList.Create;
  try
    sl.LoadFromFile(arq);
    sl.Sort;
    for i := 0 to sl.Count-1 do
    begin
      lin := sl[i];
      DecomporLinhaArquivoTEF(lin, lID, lSeq, lVal);
      if (not IgnorarVazios) or (lVal <> '') then
        fCampos.AdicionarCampo(lID, lSeq, lVal);
    end;
  finally
    sl.Free;
  end;
end;

procedure TACBrTEFTXTArquivo.SalvarArquivo(const ANomeArquivo: String);
var
  sl: TStringList;
  arq: String;
begin
  arq := Trim(ANomeArquivo);
  if (arq = '') then
    Exit;

  if FileExists(arq) then
    SysUtils.DeleteFile(arq);

  sl := TStringList.Create;
  try
    SalvarArquivo(sl);
    sl.Sort;
    sl.SaveToFile(arq);
    FlushToDisk(arq);
  finally
    sl.Free;
  end;
end;

procedure TACBrTEFTXTArquivo.SalvarArquivo(TheStrings: TStrings);
var
  lVal: String;
  i: Integer;
begin
  TheStrings.Clear;
  for i := 0 to fCampos.Count-1 do
  begin
    lVal := fCampos.Informacao[i].AsString;
    if (not IgnorarVazios) or (lVal <> '') then
      TheStrings.Add(fCampos.Informacao[i].Nome + ' = ' + lVal);
  end;
end;

function TACBrTEFTXTArquivo.GetCampoIdSeq(AIdentificacao, ASequencia: Integer): TACBrInformacao;
begin
  Result := fCampos.Campo[AIdentificacao, ASequencia];
  if (Result = Nil) then
    Result := fCampos.AdicionarCampo(AIdentificacao, ASequencia);
end;

{ TACBrTEFTXTConfig }

constructor TACBrTEFTXTConfig.Create;
begin
  inherited;
  Clear;
end;

procedure TACBrTEFTXTConfig.Clear;
begin
  fTempoLimiteEsperaStatus := CACBrTEFTXT_TimeOutStatus;
  fTempoEsperaLacoVerificacaoArquivo := CACBrTEFTXT_Sleep;
  fDirReq := CACBRTEFTXT_DIRREQ;
  fDirResp := CACBRTEFTXT_DIRRESP;
  fArqReq := CACBRTEFTXT_ARQREQ;
  fArqResp := CACBRTEFTXT_ARQRESP;
  fArqSts := CACBRTEFTXT_ARQSTS;
  fArqTemp := CACBRTEFTXT_ARQTEMP;
  fArqLog := '';
end;

procedure TACBrTEFTXTConfig.Assign(Source: TACBrTEFTXTConfig);
begin
  fTempoLimiteEsperaStatus := Source.TempoLimiteEsperaStatus;
  fTempoEsperaLacoVerificacaoArquivo := Source.TempoEsperaLacoVerificacaoArquivo;
  fDirReq := Source.DirReq;
  fDirResp := Source.DirResp;
  fArqTemp := Source.ArqTemp;
  fArqReq := Source.ArqReq;
  fArqSts := Source.ArqSts;
  fArqResp := Source.ArqResp;
  fArqLog := Source.ArqLog;
end;

procedure TACBrTEFTXTConfig.SetDirReq(AValue: String);
var
  p, f, e: String;
begin
  if fDirReq = AValue then
    Exit;

  p := ExtractFilePath(AValue);
  if (p = '')  then
    raise EACBrTEFArquivo.CreateFmt(ACBrStr(CErroDiretorioEstaVazio), ['DirReq']);

  f := ExtractFileName(AValue);
  if (f <> '') then
  begin
    e := ExtractFileExt(f);
    if (e = '') then
      p := p + f + PathDelim;
  end;

  fDirReq := p;
end;

procedure TACBrTEFTXTConfig.SetDirResp(AValue: String);
var
  p, f, e: String;
begin
  if fDirResp = AValue then
    Exit;

  p := ExtractFilePath(AValue);
  if (p = '')  then
    raise EACBrTEFArquivo.CreateFmt(ACBrStr(CErroDiretorioEstaVazio), ['DirResp']);

  f := ExtractFileName(AValue);
  if (f <> '') then
  begin
    e := ExtractFileExt(f);
    if (e = '') then
      p := p + f + PathDelim;
  end;

  fDirResp := p;
end;

procedure TACBrTEFTXTConfig.SetArqReq(AValue: String);
begin
  if fArqReq = AValue then Exit;
  fArqReq := ExtractFileName(AValue);
end;

procedure TACBrTEFTXTConfig.SetArqLog(AValue: String);
begin
  if fArqLog = AValue then Exit;
  fArqLog := AValue;
end;

procedure TACBrTEFTXTConfig.SetArqResp(AValue: String);
begin
  if fArqResp = AValue then Exit;
  fArqResp := ExtractFileName(AValue);
end;

procedure TACBrTEFTXTConfig.SetArqSts(AValue: String);
begin
  if fArqSts = AValue then Exit;
  fArqSts := ExtractFileName(AValue);
end;

procedure TACBrTEFTXTConfig.SetArqTemp(AValue: String);
begin
  if fArqTemp = AValue then Exit;
  fArqTemp := ExtractFileName(AValue);
end;

procedure TACBrTEFTXTConfig.SetEsperaStsMilissegundos(AValue: Integer);
const
  CACBrTEFTXT_EsperaStsMin = 1000;
  CACBrTEFTXT_EsperaStsMax = 1000;
begin
  if fTempoLimiteEsperaStatus = AValue then Exit;
  fTempoLimiteEsperaStatus := Min(Max(CACBrTEFTXT_EsperaStsMin, AValue), CACBrTEFTXT_EsperaStsMax);
end;

{ TACBrTEFTXTClass }

constructor TACBrTEFTXTClass.Create;
begin
  inherited;
  fQuandoGravarLog := Nil;
  fQuandoAguardarArquivo := Nil;
  fConfig := TACBrTEFTXTConfig.Create;
  fReq := TACBrTEFTXTArquivo.Create;
  fResp := TACBrTEFTXTArquivo.Create;
end;

destructor TACBrTEFTXTClass.Destroy;
begin
  fResp.Free;
  fReq.Free;
  fConfig.Free;
  inherited Destroy;
end;

procedure TACBrTEFTXTClass.SetConfig(AValue: TACBrTEFTXTConfig);
begin
  if fConfig = AValue then Exit;
  fConfig.Assign(AValue);
end;

function TACBrTEFTXTClass.GetArqReq: String;
begin
  Result := Config.DirReq + Config.ArqReq;
end;

function TACBrTEFTXTClass.GetArqResp: String;
begin
  Result := Config.DirResp + Config.ArqResp;
end;

function TACBrTEFTXTClass.GetArqSts: String;
begin
  Result := Config.DirResp + Config.ArqSts;
end;

function TACBrTEFTXTClass.GetArqTemp: String;
begin
  Result := Config.DirReq + Config.ArqTemp;
end;

function TACBrTEFTXTClass.GetModeloTEF: String;
begin
  Result := CACBRTEFTXT_NomeGerenciadorNenhum;
end;

procedure TACBrTEFTXTClass.ApagarArquivo(const AArquivo: String);
begin
  if AArquivo = '' then
    Exit;
  if not FileExists(AArquivo) then
    Exit;

  GravarLog('    Apagando: '+AArquivo);
  SysUtils.DeleteFile(AArquivo);
  if FileExists(AArquivo) then
    DoException(Format(ACBrStr(CErroApagarArquivo), [AArquivo]));
end;

procedure TACBrTEFTXTClass.GravarLog(const AString: AnsiString;
  Traduz: Boolean);
Var
  Tratado: Boolean;
  s: AnsiString;
  ArqLog: String;
begin
  if Traduz then
    s := TranslateUnprintable(AString)
  else
    s := AString;

  Tratado := False;
  if Assigned(fQuandoGravarLog) then
    fQuandoGravarLog(AString, Tratado);

  ArqLog := fConfig.ArqLog;
  if Tratado or (ArqLog = '') then
    Exit;

  s := '-- '+FormatDateTime('dd/mm hh:nn:ss:zzz',now) + ' - ' + s;
  try
    WriteToTXT(ArqLOG, s);
  except
  end ;
end;

procedure TACBrTEFTXTClass.DoException(const AErrorMsg: String);
var
  s: String;
begin
  s := Trim(AErrorMsg);
  if (s = '') then
    Exit;

  GravarLog('EACBrTEFErro: '+AErrorMsg);
  raise EACBrTEFErro.Create(AErrorMsg);
end;

{ TACBrTEFTXTBaseClass }

constructor TACBrTEFTXTBaseClass.Create;
begin
  inherited;
  fQuandoMudarStatus := Nil;
  fQuandoObterID := Nil;
  fAntesGravarRequisicao := Nil;
  fStatus := tefstLivre;
  fIdSeq := 0;
end;

destructor TACBrTEFTXTBaseClass.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrTEFTXTBaseClass.SetStatus(AValue: TACBrTEFTXTStatus);
begin
  if fStatus = AValue then
    Exit;

  GravarLog('  SetStatus: '+ GetEnumName(TypeInfo(TACBrTEFTXTStatus), Integer(AValue) ));
  fStatus := AValue;
  if Assigned(fQuandoMudarStatus) then
    fQuandoMudarStatus(Self);
end;

function TACBrTEFTXTBaseClass.ObterID(const AHeader: String): Integer;
begin
  Result := 0;
  if Assigned(fQuandoObterID) then
    fQuandoObterID(AHeader, Result);

  if (Result = 0) then
  begin
    if fIdSeq = 0 then
      fIdSeq := SecondOfTheDay(Now)
    else
      fIdSeq := fIdSeq + 1;

    Result := fIdSeq;
  end;
end;

procedure TACBrTEFTXTBaseClass.PrepararRequisicao(const AHeader: String);
begin
  GravarLog('PrepararRequisicao( '+AHeader+' )' );
  if (Status <> tefstLivre) then
    DoException(ACBrStr(CErroAguardandoRequisicaoAnterior));

  LimparRequisicao;
  LimparResposta;
  ApagarArquivosDeComunicacao;

  Req.Campo[0,0].AsString := AHeader;
  Req.Campo[1,0].AsInt64 := ObterID(AHeader);
  Req.Campo[999,999].AsString := '0' ;
end;

procedure TACBrTEFTXTBaseClass.EnviarRequisicao(AguardaResposta: Boolean);
begin
  GravarLog('EnviarRequisicao');
  if (Status <> tefstLivre) then
    DoException(ACBrStr(CErroAguardandoRequisicaoAnterior));

  Status := tefstEnviandoRequisicao;
  try
    GravarRequisicao;
    if not AguardarStatus then
      DoException(Format(ACBrStr(CErroGerenciadorNaoResponde), [ModeloTEF]));

    LerArquivoResposta(ArqSts);
    if not VerificarRespostaValida then
      DoException(Format(ACBrStr(CErroRespostaInvalida), [ModeloTEF]));
    ApagarArquivoStatus;

    if AguardaResposta then
    begin
      if not AguardarResposta then
        DoException(ACBrStr(CErroEsperaDeArquivoInterrompida));

      LerArquivoResposta(ArqResp);
      if not VerificarRespostaValida then
        DoException(Format(ACBrStr(CErroRespostaInvalida), [ModeloTEF]));
    end;
  finally
    Status := tefstLivre;
  end;
end;

procedure TACBrTEFTXTBaseClass.GravarRequisicao;
begin
  GravarLog('GravarRequisicao: '+ArqReq);
  Status := tefstEnviandoRequisicao;

  if Assigned(fAntesGravarRequisicao) then
    fAntesGravarRequisicao(Req);

  GravarLog('  Gravando Temporario: '+ArqTemp);
  Req.SalvarArquivo( ArqTemp );

  GravarLog(Format('  Renomeando: %s para %s ', [ArqTemp, ArqReq]));
  if not RenameFile( ArqTemp, ArqReq ) then
    DoException(Format( ACBrStr(CErroRenomearArquivo), [ArqTemp, ArqReq]));
end;

procedure TACBrTEFTXTBaseClass.ApagarArquivosDeComunicacao;
  procedure VerificarEApagarArquivo(const Arq: String);
  var
    s: String;
  begin
    s := Trim(Arq);
    if (s = '') then
      Exit;

    if FileExists(s) then
    begin
      GravarLog('    AVISO: '+Format(ACBrStr(CErroNomeArquivoJaExiste), [ArqTemp]));
      ApagarArquivo(s);
    end;
  end;
begin
  GravarLog('  ApagarArquivosDeComunicacao');
  VerificarEApagarArquivo(ArqTemp);
  VerificarEApagarArquivo(ArqReq);
  VerificarEApagarArquivo(ArqSts);
  VerificarEApagarArquivo(ArqResp);
end;

procedure TACBrTEFTXTBaseClass.ApagarArquivoStatus;
begin
  ApagarArquivo(ArqSts);
end;

procedure TACBrTEFTXTBaseClass.ApagarArquivoResposta;
begin
  ApagarArquivo(ArqResp);
end;

procedure TACBrTEFTXTBaseClass.LimparRequisicao;
begin
  GravarLog('LimparRequisicao');
  Req.Clear;
end;

procedure TACBrTEFTXTBaseClass.LimparResposta;
begin
  GravarLog('LimparResposta');
  Resp.Clear;
end;

function TACBrTEFTXTBaseClass.AguardarStatus: Boolean;
var
  Interromper: Boolean;
  TempoFimEspera: TDateTime;
  TempoRestante: Double;
begin
  GravarLog('AguardarStatus: '+ArqSts);
  Status := tefstAguardandoSts;
  Interromper := False;
  Result := False;
  TempoFimEspera := IncMilliSecond(Now, Config.TempoLimiteEsperaStatus);
  while (not Interromper) and (not Result) and (TempoFimEspera > Now) do
  begin
    Sleep(Config.TempoEsperaLacoVerificacaoArquivo);
    Result := FileExists(ArqSts);
    if not Result then
    begin
      TempoRestante := SecondSpan(Now, TempoFimEspera);
      GravarLog('  Tempo Restante: '+FormatFloat('##0',TempoRestante)+' segundos');
      if Assigned(QuandoAguardarArquivo) then
      begin
        QuandoAguardarArquivo(ArqSts, TempoRestante, Interromper);
        if Interromper then
          GravarLog('  Interrompido');
      end;
    end;
  end;
  GravarLog('  '+ifthen(Result, 'OK', 'ERRO'));
end;

function TACBrTEFTXTBaseClass.AguardarResposta: Boolean;
var
  Interromper: Boolean;
  TempoInicio: TDateTime;
  TempoPassado: Double;
begin
  GravarLog('AguardarResposta: '+ArqResp);
  LimparResposta;
  Status := tefstAguardandoResp;
  Interromper := False;
  Result := False;
  TempoInicio := Now;
  while (not Interromper) and (not Result) do
  begin
    Sleep(Config.TempoEsperaLacoVerificacaoArquivo);
    Result := FileExists(ArqResp);
    if not Result then
    begin
      TempoPassado := SecondSpan(TempoInicio, Now);
      GravarLog('  Tempo Passado: '+FormatFloat('##0',TempoPassado)+' segundos');
      if Assigned(QuandoAguardarArquivo) then
      begin
        QuandoAguardarArquivo(ArqResp, -TempoPassado, Interromper);
        if Interromper then
          GravarLog('  Interrompido');
      end;
    end;
  end;
  GravarLog('  '+ifthen(Result, 'OK', 'ERRO'));
end;

procedure TACBrTEFTXTBaseClass.LerArquivoResposta(const AArq: String);
begin
  GravarLog('LerArquivoResposta: '+AArq);
  Resp.LerArquivo(AArq);
end;

function TACBrTEFTXTBaseClass.VerificarRespostaValida: Boolean;
begin
  GravarLog('  VerificarRespostaValida');
  Result := (Resp.Campo[999,999].AsString <> '') and
            (Resp.Campo[0,0].AsString = Req.Campo[0,0].AsString) and
            (Resp.Campo[1,0].AsInt64 = Req.Campo[1,0].AsInt64);
  GravarLog('    '+ifthen(Result, 'OK', 'ERRO'));
end;

end.

