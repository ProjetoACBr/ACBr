{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit ACBrDevice;

interface

uses
  Classes, SysUtils,
  synaser, blcksock,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
  System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
  System.Contnrs,
  {$Else}
  Contnrs,
  {$IfEnd}
  {$IfDef COMPILER6_UP}
  Types,
  {$Else}
  Windows, ACBrD5,
  {$EndIf}
  ACBrDeviceClass, ACBrDeviceSerial, ACBrDeviceTCP, ACBrDeviceLPT,
  ACBrDeviceHook, ACBrDeviceRaw,
  {$IfDef MSWINDOWS}
  ACBrDeviceWinUSB, ACBrWinUSBDevice,
  {$EndIf}
  {$IfDef HAS_BLUETOOTH}
  ACBrDeviceBlueTooth, System.Bluetooth.Components,
  {$EndIf}
  ACBrBase;

type

  TACBrECFEstado = (estNaoInicializada, { Porta Serial ainda nao foi aberta }
    estDesconhecido, {Porta aberta, mas estado ainda nao definido}
    estLivre, { Impressora Livre, sem nenhum cupom aberto,
                              pronta para nova venda, Reducao Z e Leitura X ok,
                              pode ou nao j� ter ocorrido 1� venda no dia...}
    estVenda, { Cupom de Venda Aberto com ou sem venda do 1� Item}
    estPagamento, { Iniciado Fechamento de Cupom com Formas Pagto
                                  pode ou nao ter efetuado o 1� pagto. Nao pode
                                  mais vender itens, ou alterar Subtotal}
    estRelatorio, { Imprimindo Cupom Fiscal Vinculado ou
                                  Relatorio Gerencial }
    estBloqueada, { Redu�ao Z j� emitida, bloqueada at� as 00:00 }
    estRequerZ, {Reducao Z dia anterior nao emitida. Emita agora }
    estRequerX,  {Esta impressora requer Leitura X todo inicio de
                               dia. Imprima uma Leitura X para poder vender}
    estNaoFiscal  { Comprovante Nao Fiscal Aberto }
    );

  TACBrECFTipoBilhete = (tbRodIntermun,   //0x30 - Rodovi�rio Intermunicipal
    tbFerIntermun,   //0x31 - Ferrovi�rio Intermunicipal
    tbAquIntermun,   //0x32 - Aquavi�rio Intermunicipal
    tbRodInterest,   //0x33 - Rodovi�rio Interestadual
    tbFerInterest,   //0x34 - Ferrovi�rio Interestadual
    tbAquInterest,   //0x35 - Aquavi�rio Interestadual
    tbRodInternac,   //0x36 - Rodovi�rio Internacional
    tbFerInternac,   //0x37 - Ferrovi�rio Internacional
    tbAquInternac    //0x38 - Aquavi�rio Internacional
    );

  TACBrECFEstadoSet = set of TACBrECFEstado;

  TACBrGAVAberturaAntecipada = (aaIgnorar, aaException, aaAguardar);

  {Criando o tipo enumerado para tipos de c�digo de barras }
  TACBrTipoCodBarra = (barEAN13, barEAN8, barSTANDARD, barINTERLEAVED,
    barCODE128, barCODE39, barCODE93, barUPCA,
    barCODABAR, barMSI, barCODE11);

  {Criando tipo enumerado para a finalidade do arquivo MFD}
  TACBrECFFinalizaArqMFD = (finMF, finMFD, finTDM, finRZ, finRFD, finNFP,
    finNFPTDM, finSintegra, finSPED);

  { Criando tipo enumerado para o tipo do contador }
  TACBrECFTipoContador = (tpcCOO, tpcCRZ);

  TACBrECFTipoDownloadMFD = (tdmfdTotal, tdmfdData, tdmfdCOO);

  {Criando o tipo enumerado para tipo de documentos em Leitura da MFD }
  TACBrECFTipoDocumento = (docRZ, docLX, docCF, docCFBP, docCupomAdicional,
    docCFCancelamento, docCCD, docAdicionalCCD,
    docSegViaCCD, docReimpressaoCCD, docEstornoCCD,
    docCNF, docCNFCancelamento, docSangria, docSuprimento,
    docEstornoPagto, docRG, docLMF, docTodos, docNenhum);
  TACBrECFTipoDocumentoSet = set of TACBrECFTipoDocumento;

  TACBrAlinhamento = (alDireita, alEsquerda, alCentro);

  TACBrECFCHQEstado = (chqIdle, chqPosicione, chqImprimindo, chqFimImpressao, chqRetire, chqAutenticacao);

{ ACBrDevice � um componente apenas para usarmos o recurso de AutoExpand do
  ObjectInspector para SubComponentes, poderia ser uma Classe }

  TACBrECFConfigBarras = class(TPersistent)
  private
    FMostrarCodigo: Boolean;
    FAltura: Integer;
    FLarguraLinha: Integer;
    FMargem: Integer;
  published
    property MostrarCodigo: Boolean read FMostrarCodigo write FMostrarCodigo;
    property LarguraLinha: Integer read FLarguraLinha write FLarguraLinha;
    property Altura: Integer read FAltura write FAltura;
    property Margem: Integer read FMargem write FMargem;
  end;

  { TACBrTag }

  TACBrTag = class
  private
    FAjuda: String;
    FEhBloco: Boolean;
    FNome: String;
    FSequencia: Integer;
    function GetTamanho: Integer;
    procedure SetAjuda(const AValue: String);
    procedure SetNome(const AValue: String);
  public
    constructor Create;

    property Sequencia: Integer read FSequencia write FSequencia;
    property EhBloco: Boolean read FEhBloco write FEhBloco;
    property Nome: String read FNome write SetNome;
    property Ajuda: String read FAjuda write SetAjuda;
    property Tamanho: Integer read GetTamanho;
  end;

  { Lista de Objetos do tipo TACBrTag }

  { TACBrTags }

  TACBrTags = class(TObjectList{$IfDef HAS_SYSTEM_GENERICS}<TACBrTag>{$EndIf})
  protected
    procedure SetObject(Index: Integer; Item: TACBrTag);
    function GetObject(Index: Integer): TACBrTag;
    procedure Insert(Index: Integer; Obj: TACBrTag);
  public
    function New: TACBrTag;
    function Add(Obj: TACBrTag): Integer;
    property Objects[Index: Integer]: TACBrTag read GetObject write SetObject; default;

    function AcharTag(NomeTag: String): TACBrTag;
  end;

  TACBrTagOnTraduzirTag = procedure(const ATag: AnsiString; var TagTraduzida: AnsiString) of object;
  TACBrTagOnTraduzirTagBloco = procedure(const ATag, ConteudoBloco: AnsiString; var BlocoTraduzido: AnsiString) of object;
  TACBrTagOnAdicionarBlocoResposta = procedure(const ConteudoBloco: AnsiString) of object;

  { TACBrTagProcessor }

  TACBrTagProcessor = class
  private
    FIgnorarTags: Boolean;
    FOnAdicionarBlocoResposta: TACBrTagOnAdicionarBlocoResposta;
    FOnTraduzirTag: TACBrTagOnTraduzirTag;
    FOnTraduzirTagBloco: TACBrTagOnTraduzirTagBloco;
    FTags: TACBrTags;
    FTraduzirTags: Boolean;
    FChamada: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    function DecodificarTagsFormatacao(ABinaryString: AnsiString): AnsiString;
    function TraduzirTag(const ATag: AnsiString): AnsiString;
    function TraduzirTagBloco(const ATag, ConteudoBloco: AnsiString): AnsiString;

    procedure RetornarTags(AStringList: TStrings; IncluiAjuda: Boolean = True);

    procedure AddTags(ArrayTags: array of String; ArrayHelpTags: array of String; TagEhBloco: Boolean);

    property Tags: TACBrTags read FTags;
    property IgnorarTags: Boolean read FIgnorarTags write FIgnorarTags;
    property TraduzirTags: Boolean read FTraduzirTags write FTraduzirTags;

    property OnTraduzirTag: TACBrTagOnTraduzirTag
      read FOnTraduzirTag write FOnTraduzirTag;
    property OnTraduzirTagBloco: TACBrTagOnTraduzirTagBloco
      read FOnTraduzirTagBloco write FOnTraduzirTagBloco;
    property OnAdicionarBlocoResposta: TACBrTagOnAdicionarBlocoResposta
      read FOnAdicionarBlocoResposta write FOnAdicionarBlocoResposta;

  end;

  TACBrDeviceType = (dtNenhum, dtFile, dtSerial, dtParallel, dtTCP, dtRawPrinter, dtHook, dtUSB, dtBlueTooth);

  { TACBrDevice }

  TACBrDevice = class(TComponent)
  private
    fsDeviceAtivo: TACBrDeviceClass;
    fsDeviceNenhum: TACBrDeviceClass;
    fsDeviceSerial: TACBrDeviceSerial;
    fsDeviceTCP: TACBrDeviceTCP;
    fsDeviceLPT: TACBrDeviceLPT;
    fsDeviceHook: TACBrDeviceHook;
    fsDeviceRaw: TACBrDeviceRaw;
    {$IfDef MSWINDOWS}
    fsDeviceWinUSB: TACBrDeviceWinUSB;
    {$EndIf}
    {$IfDef HAS_BLUETOOTH}
    fsDeviceBlueTooth: TACBrDeviceBlueTooth;
    {$EndIf}

    fsPosImp: TPoint;
    fsPorta: String;
    fsNomeDocumento: String;
    fsDeviceType: TACBrDeviceType;
    fsTimeOutMilissegundos: Integer;
    fsAtivo: Boolean;

    fsSendBytesCount: Integer;
    fsSendBytesInterval: Integer;
    fProcessMessages: Boolean;
    fsArqLOG: String;

    function GetBaud: Integer;
    function GetData: Integer;
    function GetDeviceTCP: TBlockSocket;

    {$IfDef MSWINDOWS}
    function GetDeviceWinUSB: TACBrUSBWinDeviceAPI;
    {$EndIf}
    {$IfDef HAS_BLUETOOTH}
    function GetDeviceBlueTooth: TBluetooth;
    {$EndIf}
    function GetHandShake: TACBrHandShake;
    function GetHardFlow: Boolean;
    function GetHookAtivar: TACBrDeviceHookAtivar;
    function GetHookDesativar: TACBrDeviceHookDesativar;
    function GetHookEnviaString: TACBrDeviceHookEnviaString;
    function GetHookLeString: TACBrDeviceHookLeString;
    function GetNomeDocumento: String;
    function GetParamsString: String;
    function GetDeviceSerial: TBlockSerial;
    function GetSoftFlow: Boolean;
    function GetTimeOut: Integer;
    function GetTimeOutMilissegundos: Integer;
    procedure SetArqLOG(AValue: String);

    procedure SetBaud(const AValue: Integer);
    procedure SetData(const AValue: Integer);
    procedure SetDeviceType(AValue: TACBrDeviceType);
    procedure SetHookAtivar(AValue: TACBrDeviceHookAtivar);
    procedure SetHookDesativar(AValue: TACBrDeviceHookDesativar);
    procedure SetHookEnviaString(AValue: TACBrDeviceHookEnviaString);
    procedure SetHookLeString(AValue: TACBrDeviceHookLeString);
    procedure SetNomeDocumento(const AValue: String);
    procedure SetHardFlow(const AValue: Boolean);
    function GetParity: TACBrSerialParity;
    procedure SetParity(const AValue: TACBrSerialParity);
    procedure SetSoftFlow(const AValue: Boolean);
    function GetStop: TACBrSerialStop;
    procedure SetStop(const AValue: TACBrSerialStop);
    procedure SetPorta(const AValue: String);
    procedure SetTimeOut(const AValue: Integer);
    procedure SetOnStatus(const AValue: THookSerialStatus);
    function GetOnStatus: THookSerialStatus;
    procedure SetAtivo(const Value: Boolean);
    procedure SetHandShake(const AValue: TACBrHandShake);
    procedure SetParamsString(const AValue: String);
    function GetMaxBandwidth: Integer;
    procedure SetMaxBandwidth(const AValue: Integer);
    procedure SetTimeOutMilissegundos(AValue: Integer);
  public
    property Serial: TBlockSerial read GetDeviceSerial;
    property Socket: TBlockSocket read GetDeviceTCP;
    {$IfDef MSWINDOWS}
    property WinUSB: TACBrUSBWinDeviceAPI read GetDeviceWinUSB;
    {$EndIf}
    {$IfDef HAS_BLUETOOTH}
    property BlueTooth: TBluetooth read GetDeviceBlueTooth;
    {$EndIf}

    property PosImp: TPoint read fsPosImp;

    procedure Assign(Source: TPersistent); override;

    property Ativo: Boolean read fsAtivo write SetAtivo;

    property Porta: String read fsPorta write SetPorta;
    property DeviceType: TACBrDeviceType read fsDeviceType write SetDeviceType;
    property TimeOut: Integer read GetTimeOut write SetTimeOut;
    property TimeOutMilissegundos: Integer read GetTimeOutMilissegundos write SetTimeOutMilissegundos;

    function EmLinha(const ATimeOutSegundos: Integer = 1): Boolean;
    function DeduzirTipoPorta(const APorta: String): TACBrDeviceType;

    property ParamsString: String read GetParamsString write SetParamsString;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Ativar;
    procedure Desativar;
    procedure EnviaString(const AString: AnsiString);
    procedure EnviaByte(const AByte: byte);
    function LeString(const ATimeOutMilissegundos: Integer = 0; NumBytes: Integer = 0; const Terminador: AnsiString = ''): AnsiString;
    function LeByte(const ATimeOutMilissegundos: Integer = 0): byte;
    procedure Limpar;
    function BytesParaLer: Integer;

    procedure ImprimePos(const Linha, Coluna: Integer; const AString: AnsiString);
    procedure Eject;

    procedure SetDefaultValues;

    function IsSerialPort: Boolean;
    function IsParallelPort: Boolean;
    function IsTXTFilePort: Boolean;
    function IsDLLPort: Boolean;
    function IsUSBPort: Boolean;
    function IsTCPPort: Boolean;
    function IsRawPort: Boolean;

    procedure AcharPortas(const AStringList: TStrings);
    procedure AcharPortasSeriais(const AStringList: TStrings; UltimaPorta: Integer = 64);
    procedure AcharPortasRAW(const AStringList: TStrings);
    {$IfDef MSWINDOWS}
    procedure AcharPortasUSB(const AStringList: TStrings);
    {$EndIf}
    {$IfDef HAS_BLUETOOTH}
    procedure AcharPortasBlueTooth(const AStringList: TStrings; TodasPortas: Boolean = True);
    {$EndIf}

    function PedirPermissoes: Boolean;
    {$IfDef HAS_BLUETOOTH}
    function PedirPermissoesBlueTooth: Boolean;
    {$EndIf}

    {$IfDef MSWINDOWS}
    procedure DetectarTipoEProtocoloDispositivoUSB(var TipoHardware: TACBrUSBHardwareType; var ProtocoloACBr: Integer);
    {$EndIf}
    function DeviceToString(OnlyException: Boolean): String;

    procedure GravaLog(AString: AnsiString; Traduz: Boolean = False);
    function TemArqLog: Boolean;

    procedure DoException(E: Exception);
  published
    property Baud: Integer read GetBaud write SetBaud default 9600;
    property Data: Integer read GetData write SetData default 8;
    property Parity: TACBrSerialParity read GetParity write SetParity default pNone;
    property Stop: TACBrSerialStop read GetStop write SetStop default s1;
    property HandShake: TACBrHandShake read GetHandShake write SetHandShake default hsNenhum;
    property SoftFlow: Boolean read GetSoftFlow write SetSoftFlow default False;
    property HardFlow: Boolean read GetHardFlow write SetHardFlow default False;

    property MaxBandwidth: Integer read GetMaxBandwidth write SetMaxBandwidth default 0;
    property SendBytesCount: Integer read fsSendBytesCount write fsSendBytesCount default 0;
    property SendBytesInterval: Integer read fsSendBytesInterval write fsSendBytesInterval default 0;

    property NomeDocumento: String read GetNomeDocumento write SetNomeDocumento;

    { propriedade que ativa/desativa o processamento de mensagens do windows }
    property ProcessMessages: Boolean read fProcessMessages write fProcessMessages default True;

    property OnStatus: THookSerialStatus read GetOnStatus write SetOnStatus;
    property HookAtivar: TACBrDeviceHookAtivar read GetHookAtivar write SetHookAtivar;
    property HookDesativar: TACBrDeviceHookDesativar read GetHookDesativar write SetHookDesativar;
    property HookEnviaString: TACBrDeviceHookEnviaString read GetHookEnviaString write SetHookEnviaString;
    property HookLeString: TACBrDeviceHookLeString read GetHookLeString write SetHookLeString;

    property ArqLOG: String read fsArqLOG write SetArqLOG;
  end;

const
  estCupomAberto = [estVenda, estPagamento];

implementation

uses
  typinfo, Math, StrUtils,
  ACBrUtil.Strings, ACBrUtil.XMLHTML, ACBrUtil.FilesIO, ACBrConsts;

{ TACBrTag }

function TACBrTag.GetTamanho: Integer;
begin
  Result := Length(FNome);
end;

procedure TACBrTag.SetAjuda(const AValue: String);
begin
  FAjuda := ACBrStr(AValue);
end;

procedure TACBrTag.SetNome(const AValue: String);
begin
  FNome := LowerCase(Trim(AValue));

  if LeftStr(FNome, 1) <> '<' then
    FNome := '<' + FNome;

  if RightStr(AValue, 1) <> '>' then
    FNome := FNome + '>';
end;

constructor TACBrTag.Create;
begin
  FEhBloco := False;
  FSequencia := 0;
end;

{ TACBrTags }

procedure TACBrTags.SetObject(Index: Integer; Item: TACBrTag);
begin
  inherited Items[Index] := Item;
end;

function TACBrTags.GetObject(Index: Integer): TACBrTag;
begin
  Result := TACBrTag(inherited Items[Index]);
end;

procedure TACBrTags.Insert(Index: Integer; Obj: TACBrTag);
begin
  inherited Insert(Index, Obj);
end;

function TACBrTags.New: TACBrTag;
begin
  Result := TACBrTag.Create;
  Add(Result);
end;

function TACBrTags.Add(Obj: TACBrTag): Integer;
begin
  Result := inherited Add(Obj);
  Obj.Sequencia := Count;
end;

function TACBrTags.AcharTag(NomeTag: String): TACBrTag;
var
  I: Integer;
  ATag: TACBrTag;
begin
  NomeTag := LowerCase(NomeTag);
  Result := nil;

  for I := 0 to Count - 1 do
  begin
    ATag := Objects[I];
    if (ATag.Nome = NomeTag) then
    begin
      Result := ATag;
      Break;
    end;
  end;
end;

{ TACBrTagProcessor }

constructor TACBrTagProcessor.Create;
begin
  inherited Create;

  FTags := TACBrTags.Create(True);
  FIgnorarTags := False;
  FTraduzirTags := True;
  FChamada := 0;
  FOnTraduzirTag := Nil;
  FOnTraduzirTagBloco := Nil;
  FOnAdicionarBlocoResposta := Nil;
end;

destructor TACBrTagProcessor.Destroy;
begin
  FTags.Free;

  inherited Destroy;
end;

function TACBrTagProcessor.DecodificarTagsFormatacao(ABinaryString: AnsiString): AnsiString;
var
  Cmd, Tag1, Tag2, TagT, Resp: AnsiString;
  PosTag1, LenTag1, PosTag2, FimTag: Integer;
  ATag: TACBrTag;

  procedure AdicionarBlocoResposta(const ConteudoBloco: AnsiString);
  begin
    if (ConteudoBloco = '') then
      Exit;

    Resp := Resp + ConteudoBloco;

    if (FChamada <= 1) then // Evitar chamar o evento, em cada chamada recursiva...
      if Assigned(FOnAdicionarBlocoResposta) then
        FOnAdicionarBlocoResposta(ConteudoBloco);
  end;

begin
  if not TraduzirTags then
  begin
    Result := ABinaryString;
    Exit;
  end;

  Inc( FChamada );
  try
    Resp := '';
    Tag1 := '';
    PosTag1 := 0;
    FimTag := 0;

    AcharProximaTag(ABinaryString, FimTag + 1, Tag1, PosTag1);
    while Tag1 <> '' do
    begin
      AdicionarBlocoResposta( copy(ABinaryString, FimTag + 1, PosTag1 - (FimTag + 1)) );
      LenTag1 := Length(Tag1);
      ATag := FTags.AcharTag(Tag1);
      Tag2 := '';

      if ATag <> nil then
      begin
        if (ATag.EhBloco) then  // Tag de Bloco, Procure pelo Fechamento
        begin
          Tag2 := '</' + copy(Tag1, 2, LenTag1); // Calcula Tag de Fechamento
          TagT := Tag1;
          PosTag2 := PosTag1;
          while (TagT <> Tag2) and (PosTag2 > 0) do
            AcharProximaTag(ABinaryString, PosTag2 + Length(TagT), TagT, PosTag2);

          if (PosTag2 = 0) then             // N�o achou Tag de Fechamento
          begin
            Tag2 := '';
            Cmd := '';
          end
          else
          begin
            Cmd := TraduzirTagBloco(Tag1, copy(ABinaryString, PosTag1 + LenTag1, PosTag2 - PosTag1 - LenTag1));

            // Faz da Tag1, todo o Bloco para fazer a substitui��o abaixo //
            LenTag1 := PosTag2 - PosTag1 + LenTag1 + 1;
            Tag1 := copy(ABinaryString, PosTag1, LenTag1);
          end;
        end
        else
          Cmd := TraduzirTag(Tag1);
      end
      else
        Cmd := Tag1;   // Tag n�o existe nesse TagProcessor

      AdicionarBlocoResposta( Cmd );
      FimTag := PosTag1 + LenTag1 - 1;

      Tag1 := '';
      PosTag1 := 0;
      AcharProximaTag(ABinaryString, FimTag + 1, Tag1, PosTag1);
    end;

    AdicionarBlocoResposta( copy(ABinaryString, FimTag + 1, Length(ABinaryString)) );

    Result := Resp;
  finally
    Dec( FChamada );
  end;
end;

function TACBrTagProcessor.TraduzirTag(const ATag: AnsiString): AnsiString;
begin
  Result := '';
  if (ATag = '') or IgnorarTags then
    exit;

  if Assigned(FOnTraduzirTag) then
    FOnTraduzirTag(ATag, Result);
end;

function TACBrTagProcessor.TraduzirTagBloco(const ATag, ConteudoBloco: AnsiString): AnsiString;
var
  AStr: AnsiString;
begin
  Result := ConteudoBloco;
  if (ATag = '') or IgnorarTags or (ATag = cTagIgnorarTags) then
    exit;

  { Chamada Recursiva, para no caso de "ConteudoBloco" ter TAGs n�o resolvidas
    dentro do Bloco }
  AStr := DecodificarTagsFormatacao(ConteudoBloco);

  if Assigned(FOnTraduzirTagBloco) then
    FOnTraduzirTagBloco(ATag, AStr, Result);
end;

procedure TACBrTagProcessor.RetornarTags(AStringList: TStrings; IncluiAjuda: Boolean);
var
  ALine: String;
  i: Integer;
begin
  AStringList.Clear;
  for i := 0 to FTags.Count - 1 do
  begin
    ALine := FTags[i].Nome;
    if IncluiAjuda then
    begin
      if FTags[i].EhBloco then
        ALine := ALine + ' - Bloco';

      ALine := ALine + ' - ' + FTags[i].Ajuda;
    end;

    AStringList.Add(ALine);
  end;
end;

procedure TACBrTagProcessor.AddTags(ArrayTags: array of String; ArrayHelpTags: array of String; TagEhBloco: Boolean);
var
  i: Integer;
begin
  for i := Low(ArrayTags) to High(ArrayTags) do
  begin
    with FTags.New do
    begin
      Nome := ArrayTags[i];
      if High(ArrayHelpTags) >= i then
        Ajuda := ArrayHelpTags[i];

      EhBloco := TagEhBloco;
    end;
  end;
end;


{ TACBrDevice }

constructor TACBrDevice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fsDeviceNenhum := TACBrDeviceClass.Create(Self);
  fsDeviceSerial := TACBrDeviceSerial.Create(Self);
  fsDeviceTCP := TACBrDeviceTCP.Create(Self);
  fsDeviceLPT := TACBrDeviceLPT.Create(Self);
  fsDeviceHook := TACBrDeviceHook.Create(Self);
  fsDeviceRaw := TACBrDeviceRaw.Create(Self);
  {$IfDef MSWINDOWS}
  fsDeviceWinUSB := TACBrDeviceWinUSB.Create(Self);
  {$EndIf}
  {$IfDef HAS_BLUETOOTH}
  fsDeviceBlueTooth := TACBrDeviceBlueTooth.Create(Self);
  {$EndIf}

  { Variaveis Internas }
  fsPorta := '';
  fsTimeOutMilissegundos := cTimeout * 1000;

  fsSendBytesCount := 0;
  fsSendBytesInterval := 0;
  fProcessMessages := True;
  fsDeviceType := dtNenhum;
  fsDeviceAtivo := fsDeviceNenhum;
  fsNomeDocumento := '';
  fsArqLOG := '';

  SetDefaultValues;
end;

destructor TACBrDevice.Destroy;
begin
  GravaLog('Destroy');
  fsDeviceNenhum.Free;
  fsDeviceSerial.Free;
  fsDeviceTCP.Free;
  fsDeviceLPT.Free;
  fsDeviceHook.Free;
  fsDeviceRaw.Free;
  {$IfDef MSWINDOWS}
  fsDeviceWinUSB.Free;
  {$EndIf}
  {$IfDef HAS_BLUETOOTH}
  fsDeviceBlueTooth.Free;
  {$EndIf}

  inherited Destroy;
end;

procedure TACBrDevice.SetDefaultValues;
begin
  GravaLog('SetDefaultValues');
  fsDeviceSerial.ValoresPadroes;
  fsPosImp.X := 0;
  fsPosImp.Y := 0;
end;


procedure TACBrDevice.SetAtivo(const Value: Boolean);
begin
  if Value then
    Ativar
  else
    Desativar;
end;

procedure TACBrDevice.Ativar;
begin
  if fsAtivo then
    Exit;

  GravaLog('Ativar - Porta ' + copy(GetEnumName(TypeInfo(TACBrDeviceType), Integer(fsDeviceType)), 3, 20) + ': ' + fsPorta);

  if (fsPorta = '') or ((fsDeviceType = dtNenhum) and (copy(UpperCase(fsPorta), 1, 4) <> 'NULL')) then
    DoException(Exception.Create(ACBrStr(cACBrDeviceAtivarPortaException)));

  fsDeviceAtivo.Conectar(fsPorta, fsTimeOutMilissegundos);
  fsAtivo := True;
end;

procedure TACBrDevice.Desativar;
begin
  if not fsAtivo then
    Exit;

  GravaLog('Desativar');
  fsDeviceAtivo.Desconectar();

  fsAtivo := False;
end;

function TACBrDevice.GetOnStatus: THookSerialStatus;
begin
  Result := fsDeviceSerial.OnStatus;
end;

procedure TACBrDevice.SetOnStatus(const AValue: THookSerialStatus);
begin
  fsDeviceSerial.OnStatus := AValue;
end;

procedure TACBrDevice.SetBaud(const AValue: Integer);
begin
  fsDeviceSerial.Baud := AValue;
end;

procedure TACBrDevice.SetData(const AValue: Integer);
begin
  fsDeviceSerial.Data := AValue;
end;

procedure TACBrDevice.SetDeviceType(AValue: TACBrDeviceType);
begin
  if fsDeviceType = AValue then
    Exit;

  if TemArqLog then
    GravaLog('SetDeviceType(' + GetEnumName(TypeInfo(TACBrDeviceType), Integer(AValue)) + ')');

  if (AValue in [dtTCP, dtRawPrinter, dtHook, dtUSB, dtBlueTooth]) then
  begin
    if (DeduzirTipoPorta(fsPorta) <> AValue) then
      DoException(Exception.Create(ACBrStr(cACBrDeviceSetTypeException)));
  end

  else if (AValue in [dtFile, dtSerial]) then
  begin
    if not (DeduzirTipoPorta(fsPorta) in [dtFile, dtSerial]) then
      DoException(Exception.Create(ACBrStr(cACBrDeviceSetTypeException)));
  end;

  fsDeviceType := AValue;
  case fsDeviceType of
    dtTCP:
      fsDeviceAtivo := fsDeviceTCP;
    dtSerial:
      fsDeviceAtivo := fsDeviceSerial;
    dtHook:
      fsDeviceAtivo := fsDeviceHook;
    dtRawPrinter:
      fsDeviceAtivo := fsDeviceRaw;
    dtFile, dtParallel:
      fsDeviceAtivo := fsDeviceLPT;
    {$IfDef MSWINDOWS}
    dtUSB:
      fsDeviceAtivo := fsDeviceWinUSB;
    {$EndIf}
    {$IfDef HAS_BLUETOOTH}
    dtBlueTooth:
      fsDeviceAtivo := fsDeviceBlueTooth;
    {$EndIf}
    else
      fsDeviceAtivo := fsDeviceNenhum;
  end;

end;

procedure TACBrDevice.SetHookAtivar(AValue: TACBrDeviceHookAtivar);
begin
  fsDeviceHook.HookAtivar := AValue;
end;

procedure TACBrDevice.SetHookDesativar(AValue: TACBrDeviceHookDesativar);
begin
  fsDeviceHook.HookDesativar := AValue;
end;

procedure TACBrDevice.SetHookEnviaString(AValue: TACBrDeviceHookEnviaString);
begin
  fsDeviceHook.HookEnviaString := AValue;
end;

procedure TACBrDevice.SetHookLeString(AValue: TACBrDeviceHookLeString);
begin
  fsDeviceHook.HookLeString := AValue;
end;

procedure TACBrDevice.SetNomeDocumento(const AValue: String);
begin
  GravaLog('SetNomeDocumento(' + AValue + ')');
  fsNomeDocumento := Trim(AValue);
end;

function TACBrDevice.GetParity: TACBrSerialParity;
begin
  Result := fsDeviceSerial.Parity;
end;

procedure TACBrDevice.SetParity(const AValue: TACBrSerialParity);
begin
  fsDeviceSerial.Parity := AValue;
end;

function TACBrDevice.GetStop: TACBrSerialStop;
begin
  Result := fsDeviceSerial.Stop;
end;

procedure TACBrDevice.SetStop(const AValue: TACBrSerialStop);
begin
  fsDeviceSerial.Stop := AValue;
end;

function TACBrDevice.GetMaxBandwidth: Integer;
begin
  Result := fsDeviceAtivo.MaxSendBandwidth;
end;

procedure TACBrDevice.SetMaxBandwidth(const AValue: Integer);
begin
  GravaLog('SetMaxBandwidth(' + IntToStr(AValue) + ')');
  fsDeviceAtivo.MaxSendBandwidth := AValue;
end;

procedure TACBrDevice.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if Source is TACBrDevice then
  begin
    Baud := TACBrDevice(Source).Baud;
    Data := TACBrDevice(Source).Data;
    Parity := TACBrDevice(Source).Parity;
    Stop := TACBrDevice(Source).Stop;
    MaxBandwidth := TACBrDevice(Source).MaxBandwidth;
    SendBytesCount := TACBrDevice(Source).SendBytesCount;
    SendBytesInterval := TACBrDevice(Source).SendBytesInterval;
    HandShake := TACBrDevice(Source).HandShake;
    SoftFlow := TACBrDevice(Source).SoftFlow;
    HardFlow := TACBrDevice(Source).HardFlow;
    ProcessMessages := TACBrDevice(Source).ProcessMessages;
    OnStatus := TACBrDevice(Source).OnStatus;
    HookEnviaString := TACBrDevice(Source).HookEnviaString;
    HookLeString := TACBrDevice(Source).HookLeString;
    HookAtivar := TACBrDevice(Source).HookAtivar;
    HookDesativar := TACBrDevice(Source).HookDesativar;
  end;
end;

procedure TACBrDevice.SetHardFlow(const AValue: Boolean);
begin
  fsDeviceSerial.HardFlow := AValue;
end;

procedure TACBrDevice.SetSoftFlow(const AValue: Boolean);
begin
  fsDeviceSerial.SoftFlow := AValue;
end;

procedure TACBrDevice.SetHandShake(const AValue: TACBrHandShake);
begin
  fsDeviceSerial.HandShake := AValue;
end;

procedure TACBrDevice.SetPorta(const AValue: String);
var
  PortaUp: String;
begin
  if fsPorta = AValue then
    Exit;

  GravaLog('SetPorta(' + AValue + ')');
  if Ativo then
    DoException(Exception.Create(ACBrStr(cACBrDeviceSetPortaException)));

  fsPorta := Trim(AValue);
  PortaUp := UpperCase(fsPorta);
  if (pos('LPT', PortaUp) = 1) or (pos('COM', PortaUp) = 1) then
    fsPorta := PortaUp;

  DeviceType := DeduzirTipoPorta(fsPorta);
end;

function TACBrDevice.DeduzirTipoPorta(const APorta: String): TACBrDeviceType;
var
  UPorta: String;
begin
  GravaLog('DeduzirTipoPorta(' + APorta + ')');

  UPorta := UpperCase(APorta);

  if APorta = '*' then
    Result := dtRawPrinter   // usar� a impressora default
  else if (copy(UPorta, 1, 4) = 'NULL') then
    Result := dtNenhum
  else if (copy(UPorta, 1, 4) = 'TCP:') then
    Result := dtTCP
  else if (copy(UPorta, 1, 4) = 'RAW:') then
    Result := dtRawPrinter
  else if (copy(UPorta, 1, 4) = 'BTH:') then
    Result := dtBlueTooth
  else if (RightStr(UPorta, 4) = '.TXT') or (copy(UPorta, 1, 5) = 'FILE:') then
    Result := dtFile
  else if {$IFDEF LINUX}
           ((pos('/dev/', APorta) = 1) and (Pos('/lp', APorta) > 4))
          {$ELSE}
           (Pos('LPT', UPorta) = 1)
          {$ENDIF}
  then
    Result := dtParallel
  else if (copy(UPorta, 1, 3) = 'COM') or
          {$IFDEF MSWINDOWS}
           (copy(APorta, 1, 4) = '\\.\')
          {$ELSE}
           (pos('/dev/', APorta) = 1)
          {$ENDIF}
  then
    Result := dtSerial
  else if (copy(UPorta, 1, 3) = 'DLL') then
    Result := dtHook
  else if (copy(UPorta, 1, 3) = 'USB') or
    (LowerCase(copy(APorta, 1, 7)) = '\\?\usb') then
    Result := dtUSB
  else if (fsDeviceRaw.GetLabelPrinterIndex(APorta) >= 0) then
    Result := dtRawPrinter
  else
  begin
    if pos(PathDelim, APorta) > 0 then
      Result := dtFile
    else
      Result := dtNenhum;
  end;

  if TemArqLog then
    GravaLog('  ' + GetEnumName(TypeInfo(TACBrDeviceType), Integer(Result)));
end;

{$IfDef MSWINDOWS}
procedure TACBrDevice.AcharPortasUSB(const AStringList: TStrings);
begin
  fsDeviceWinUSB.AcharPortasUSB(AStringList);
end;

procedure TACBrDevice.DetectarTipoEProtocoloDispositivoUSB(var TipoHardware: TACBrUSBHardwareType; var ProtocoloACBr: Integer);
begin
  ProtocoloACBr := 0;
  if not (DeviceType in [dtSerial, dtUSB]) then
    Exit;

  fsDeviceWinUSB.DetectarTipoEProtocoloDispositivoUSB(fsPorta, TipoHardware, ProtocoloACBr);
end;

{$EndIf}

procedure TACBrDevice.SetTimeOut(const AValue: Integer);
var
  NovoTimeOut: Integer;
begin
  NovoTimeOut := (max(AValue, 1) * 1000);
  if NovoTimeOut = fsTimeOutMilissegundos then
    Exit;

  GravaLog('SetTimeOut(' + IntToStr(AValue) + ')');

  fsTimeOutMilissegundos := NovoTimeOut;
  fsDeviceAtivo.TimeOutMilissegundos := NovoTimeOut;
end;

function TACBrDevice.GetTimeOutMilissegundos: Integer;
begin
  Result := fsTimeOutMilissegundos;
end;

procedure TACBrDevice.SetArqLOG(AValue: String);
begin
  if fsArqLOG = AValue then
    Exit;
  fsArqLOG := AValue;
  {$IfDef MSWINDOWS}
  fsDeviceWinUSB.WinUSB.LogFile := AValue;
  {$EndIf}
end;

procedure TACBrDevice.SetTimeOutMilissegundos(AValue: Integer);
begin
  if AValue = fsTimeOutMilissegundos then
    Exit;

  GravaLog('SetTimeOutMilissegundos(' + IntToStr(AValue) + ')');
  fsTimeOutMilissegundos := AValue;
  fsDeviceAtivo.TimeOutMilissegundos := AValue;
end;

function TACBrDevice.EmLinha(const ATimeOutSegundos: Integer): Boolean;
var
  NovoTimeOut: Integer;
begin
  GravaLog('EmLinha(' + IntToStr(ATimeOutSegundos) + ')');
  NovoTimeOut := max(ATimeOutSegundos, 1) * 1000;
  Result := fsDeviceAtivo.EmLinha(NovoTimeOut);
  GravaLog('  ' + BoolToStr(Result, True));
end;

function TACBrDevice.IsSerialPort: Boolean;
begin
  Result := (fsDeviceType = dtSerial);
end;

function TACBrDevice.IsParallelPort: Boolean;
begin
  Result := (fsDeviceType = dtParallel);
end;

function TACBrDevice.IsTCPPort: Boolean;
begin
  Result := (fsDeviceType = dtTCP);
end;

function TACBrDevice.IsRawPort: Boolean;
begin
  Result := (fsDeviceType = dtRawPrinter);
end;

function TACBrDevice.IsTXTFilePort: Boolean;
begin
  Result := (fsDeviceType = dtFile);
end;

function TACBrDevice.IsDLLPort: Boolean;
begin
  Result := (fsDeviceType = dtHook);
end;

function TACBrDevice.IsUSBPort: Boolean;
begin
  Result := (fsDeviceType = dtUSB);
end;

procedure TACBrDevice.AcharPortas(const AStringList: TStrings);
begin
  {$IfDef MSWINDOWS}
   AcharPortasUSB(AStringList);
  {$EndIf}

  AcharPortasSeriais(AStringList);
  AcharPortasRAW(AStringList);

  {$IfDef HAS_BLUETOOTH}
   AcharPortasBlueTooth(AStringList);
  {$EndIf}
end;

procedure TACBrDevice.AcharPortasRAW(const AStringList: TStrings);
begin
  fsDeviceRaw.AcharPortasRAW(AStringList);
end;

procedure TACBrDevice.AcharPortasSeriais(const AStringList: TStrings; UltimaPorta: Integer);
begin
  fsDeviceSerial.AcharPortasSeriais(AStringList, UltimaPorta);
end;

function TACBrDevice.PedirPermissoes: Boolean;
begin
  GravaLog('PedirPermissoes');
  Result := fsDeviceAtivo.PedirPermissoes;
  GravaLog('  ' + BoolToStr(Result, True));
end;

{$IfDef HAS_BLUETOOTH}
function TACBrDevice.PedirPermissoesBlueTooth: Boolean;
begin
  GravaLog('PedirPermissoesBlueTooth');
  Result := fsDeviceBlueTooth.PedirPermissoes;
  GravaLog('  ' + BoolToStr(Result, True));
end;
{$EndIf}

function TACBrDevice.DeviceToString(OnlyException: Boolean): String;
begin
  Result := fsDeviceSerial.ParametrosSerial(OnlyException);
  GravaLog('  DeviceToString: ' + Result);
end;

procedure TACBrDevice.GravaLog(AString: AnsiString; Traduz: Boolean);
begin
  if not TemArqLog then
    Exit;

  if Traduz then
    AString := TranslateUnprintable(AString);

  WriteLog(fsArqLOG, '-- ' + FormatDateTime('dd/mm hh:nn:ss:zzz', now) + ' ' + AString);
end;

function TACBrDevice.TemArqLog: Boolean;
begin
  Result := (fsArqLOG <> '');
end;

procedure TACBrDevice.DoException(E: Exception);
begin
  if Assigned(E) then
    GravaLog(E.ClassName + ': ' + E.Message);

  raise E;
end;

function TACBrDevice.GetParamsString: String;
begin
  Result := fsDeviceSerial.ParamsString;
end;

{$IfDef HAS_BLUETOOTH}
function TACBrDevice.GetDeviceBlueTooth: TBluetooth;
begin
  Result := fsDeviceBlueTooth.BlueTooth;
end;

procedure TACBrDevice.AcharPortasBlueTooth(const AStringList: TStrings; TodasPortas: Boolean = True);
begin
  fsDeviceBlueTooth.AcharPortasBlueTooth(AStringList, TodasPortas);
end;

{$EndIf}

function TACBrDevice.GetDeviceSerial: TBlockSerial;
begin
  Result := fsDeviceSerial.Serial;
end;

function TACBrDevice.GetSoftFlow: Boolean;
begin
  Result := fsDeviceSerial.SoftFlow;
end;

function TACBrDevice.GetTimeOut: Integer;
begin
  Result := Max(Trunc(fsTimeOutMilissegundos / 1000), 1);
end;

procedure TACBrDevice.SetParamsString(const AValue: String);
begin
  fsDeviceSerial.ParamsString := AValue;
end;

procedure TACBrDevice.EnviaString(const AString: AnsiString);
begin
  GravaLog('EnviaString' + AString + ')', True);

  fsDeviceAtivo.EnviaString(AString);
end;

procedure TACBrDevice.EnviaByte(const AByte: byte);
begin
  GravaLog('EnviaByte(' + IntToStr(AByte) + ')');
  fsDeviceAtivo.EnviaByte(AByte);
end;

function TACBrDevice.LeString(const ATimeOutMilissegundos: Integer; NumBytes: Integer; const Terminador: AnsiString): AnsiString;
var
  NovoTimeOut: Integer;
begin
  if ATimeOutMilissegundos <= 0 then
    NovoTimeOut := fsTimeOutMilissegundos
  else
    NovoTimeOut := ATimeOutMilissegundos;

  GravaLog('LeString(' + IntToStr(NovoTimeOut) + ', ' + IntToStr(NumBytes) + ', ' + Terminador + ')', True);
  Result := fsDeviceAtivo.LeString(NovoTimeOut, NumBytes, Terminador);
  GravaLog('  ' + Result, True);
end;

function TACBrDevice.LeByte(const ATimeOutMilissegundos: Integer): byte;
var
  NovoTimeOut: Integer;
begin
  if ATimeOutMilissegundos <= 0 then
    NovoTimeOut := fsTimeOutMilissegundos
  else
    NovoTimeOut := ATimeOutMilissegundos;

  GravaLog('LeByte(' + IntToStr(NovoTimeOut) + ')');
  Result := fsDeviceAtivo.LeByte(NovoTimeOut);
  GravaLog('  ' + IntToStr(Result));
end;

procedure TACBrDevice.Limpar;
begin
  GravaLog('Limpar');
  fsDeviceAtivo.Limpar;
end;

function TACBrDevice.BytesParaLer: Integer;
begin
  Result := fsDeviceAtivo.BytesParaLer;
  GravaLog('BytesParaLer: ' + IntToStr(Result));
end;

function TACBrDevice.GetBaud: Integer;
begin
  Result := fsDeviceSerial.Baud;
end;

function TACBrDevice.GetData: Integer;
begin
  Result := fsDeviceSerial.Data;
end;

function TACBrDevice.GetDeviceTCP: TBlockSocket;
begin
  Result := fsDeviceTCP.Socket;
end;

{$IfDef MSWINDOWS}
function TACBrDevice.GetDeviceWinUSB: TACBrUSBWinDeviceAPI;
begin
  Result := fsDeviceWinUSB.WinUSB;
end;

{$EndIf}

function TACBrDevice.GetHandShake: TACBrHandShake;
begin
  Result := fsDeviceSerial.HandShake;
end;

function TACBrDevice.GetHardFlow: Boolean;
begin
  Result := fsDeviceSerial.HardFlow;
end;

function TACBrDevice.GetHookAtivar: TACBrDeviceHookAtivar;
begin
  Result := fsDeviceHook.HookAtivar;
end;

function TACBrDevice.GetHookDesativar: TACBrDeviceHookDesativar;
begin
  Result := fsDeviceHook.HookDesativar;
end;

function TACBrDevice.GetHookEnviaString: TACBrDeviceHookEnviaString;
begin
  Result := fsDeviceHook.HookEnviaString;
end;

function TACBrDevice.GetHookLeString: TACBrDeviceHookLeString;
begin
  Result := fsDeviceHook.HookLeString;
end;

function TACBrDevice.GetNomeDocumento: String;
begin
  if (fsNomeDocumento = '') then
    if not (csDesigning in ComponentState) then
      fsNomeDocumento := ClassName;

  Result := fsNomeDocumento;
end;

procedure TACBrDevice.ImprimePos(const Linha, Coluna: Integer; const AString: AnsiString);
var
  Cmd: String;
begin
  if (AString = '') or
    (Linha < 0) or
    (Coluna < 0) then
    exit;

  Cmd := '';

  if Linha < fsPosImp.X then
    Eject;

  if Linha > fsPosImp.X then
  begin
    Cmd := StringOfChar(LF, (Linha - fsPosImp.X));
    fsPosImp.X := Linha;
  end;

  if Coluna < fsPosImp.Y then
  begin
    Cmd := Cmd + CR;
    fsPosImp.Y := 0;
  end;

  if Coluna > fsPosImp.Y then
  begin
    Cmd := Cmd + StringOfChar(' ', (Coluna - fsPosImp.Y));
    fsPosImp.Y := Coluna;
  end;

  EnviaString(Cmd + AString);
  fsPosImp.Y := fsPosImp.Y + Length(AString);
end;

procedure TACBrDevice.Eject;
begin
  EnviaString(FF);
  fsPosImp.X := 0;
end;

end.









