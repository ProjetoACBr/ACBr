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

unit ACBrNF3eWebServices;

interface

uses
  Classes, SysUtils, dateutils,
  blcksock, synacode,
  ACBrXmlBase,
  pcnConversao,
  ACBrDFe, ACBrDFeWebService,
  ACBrDFeComum.RetConsReciDFe,
  ACBrDFeComum.Proc,
  ACBrDFeComum.RetEnvio,
  ACBrDFeComum.DistDFeInt, ACBrDFeComum.RetDistDFeInt,
  ACBrNF3eNotasFiscais, ACBrNF3eConfiguracoes,
  ACBrNF3eClass, ACBrNF3eConversao,
  ACBrNF3eEnvEvento, ACBrNF3eRetEnvEvento,
  ACBrNF3eRetConsSit;

type

  { TNF3eWebService }

  TNF3eWebService = class(TDFeWebService)
  private
    FOldSSLType: TSSLType;
    FOldHeaderElement: String;
  protected
    FPStatus: TStatusNF3e;
    FPLayout: TLayOut;
    FPConfiguracoesNF3e: TConfiguracoesNF3e;

  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    function GerarVersaoDadosSoap: String; override;
    procedure EnviarDados; override;
    procedure FinalizarServico; override;
    procedure RemoverNameSpace;

  public
    constructor Create(AOwner: TACBrDFe); override;
    procedure Clear; override;

    property Status: TStatusNF3e read FPStatus;
    property Layout: TLayOut read FPLayout;
  end;

  { TNF3eStatusServico }

  TNF3eStatusServico = class(TNF3eWebService)
  private
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: integer;
    FxMotivo: String;
    FcUF: integer;
    FdhRecbto: TDateTime;
    FTMed: integer;
    FdhRetorno: TDateTime;
    FxObs: String;
  protected
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarMsgErro(E: Exception): String; override;
  public
    procedure Clear; override;

    property versao: String read Fversao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb;
    property verAplic: String read FverAplic;
    property cStat: integer read FcStat;
    property xMotivo: String read FxMotivo;
    property cUF: integer read FcUF;
    property dhRecbto: TDateTime read FdhRecbto;
    property TMed: integer read FTMed;
    property dhRetorno: TDateTime read FdhRetorno;
    property xObs: String read FxObs;
  end;

  { TNF3eRecepcao }

  TNF3eRecepcao = class(TNF3eWebService)
  private
    FLote: String;
    FRecibo: String;
    FNotasFiscais: TNotasFiscais;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: integer;
    FcUF: integer;
    FxMotivo: String;
    FdhRecbto: TDateTime;
    FTMed: integer;
    FSincrono: Boolean;
    FVersaoDF: TVersaoNF3e;

    FNF3eRetornoSincrono: TRetConsSitNF3e;
    FNF3eRetorno: TretEnvDFe;
    FMsgUnZip: String;

    function GetLote: String;
    function GetRecibo: String;
  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; ANotasFiscais: TNotasFiscais);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property Recibo: String read GetRecibo;
    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: integer read FcStat;
    property cUF: integer read FcUF;
    property xMotivo: String read FxMotivo;
    property dhRecbto: TDateTime read FdhRecbto;
    property TMed: integer read FTMed;
    property Lote: String read GetLote write FLote;
    property Sincrono: Boolean read FSincrono write FSincrono;
    property MsgUnZip: String read FMsgUnZip write FMsgUnZip;

    property NF3eRetornoSincrono: TRetConsSitNF3e read FNF3eRetornoSincrono;
  end;

  { TNF3eRetRecepcao }

  TNF3eRetRecepcao = class(TNF3eWebService)
  private
    FRecibo: String;
    FProtocolo: String;
    FChaveNF3e: String;
    FNotasFiscais: TNotasFiscais;
    Fversao: String;
    FTpAmb: TACBrTipoAmbiente;
    FverAplic: String;
    FcStat: integer;
    FcUF: integer;
    FxMotivo: String;
    FcMsg: integer;
    FxMsg: String;
    FVersaoDF: TVersaoNF3e;

    FNF3eRetorno: TRetConsReciDFe;

    function GetRecibo: String;
    function TratarRespostaFinal: Boolean;
  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
    procedure FinalizarServico; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; ANotasFiscais: TNotasFiscais);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    function Executar: Boolean; override;

    property versao: String read Fversao;
    property TpAmb: TACBrTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: integer read FcStat;
    property cUF: integer read FcUF;
    property xMotivo: String read FxMotivo;
    property cMsg: integer read FcMsg;
    property xMsg: String read FxMsg;
    property Recibo: String read GetRecibo write FRecibo;
    property Protocolo: String read FProtocolo write FProtocolo;
    property ChaveNF3e: String read FChaveNF3e write FChaveNF3e;

    property NF3eRetorno: TRetConsReciDFe read FNF3eRetorno;
  end;

  { TNF3eRecibo }

  TNF3eRecibo = class(TNF3eWebService)
  private
    FNotasFiscais: TNotasFiscais;
    FRecibo: String;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: integer;
    FxMotivo: String;
    FcUF: integer;
    FxMsg: String;
    FcMsg: integer;
    FVersaoDF: TVersaoNF3e;

    FNF3eRetorno: TRetConsReciDFe;
  protected
    procedure InicializarServico; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirURL; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
  public
    constructor Create(AOwner: TACBrDFe; ANotasFiscais: TNotasFiscais);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: integer read FcStat;
    property xMotivo: String read FxMotivo;
    property cUF: integer read FcUF;
    property xMsg: String read FxMsg;
    property cMsg: integer read FcMsg;
    property Recibo: String read FRecibo write FRecibo;

    property NF3eRetorno: TRetConsReciDFe read FNF3eRetorno;
  end;

  { TNF3eConsulta }

  TNF3eConsulta = class(TNF3eWebService)
  private
    FOwner: TACBrDFe;
    FNF3eChave: String;
    FExtrairEventos: Boolean;
    FNotasFiscais: TNotasFiscais;
    FProtocolo: String;
    FDhRecbto: TDateTime;
    FXMotivo: String;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: integer;
    FcUF: integer;
    FRetNF3eDFe: String;

    FprotNF3e: TProcDFe;
    FprocEventoNF3e: TRetEventoNF3eCollection;

    procedure SetNF3eChave(const AValue: String);
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function GerarUFSoap: String; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; ANotasFiscais: TNotasFiscais);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property NF3eChave: String read FNF3eChave write SetNF3eChave;
    property ExtrairEventos: Boolean read FExtrairEventos write FExtrairEventos;
    property Protocolo: String read FProtocolo;
    property DhRecbto: TDateTime read FDhRecbto;
    property XMotivo: String read FXMotivo;
    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: integer read FcStat;
    property cUF: integer read FcUF;
    property RetNF3eDFe: String read FRetNF3eDFe;

    property protNF3e: TProcDFe read FprotNF3e;
    property procEventoNF3e: TRetEventoNF3eCollection read FprocEventoNF3e;
  end;

  { TNF3eEnvEvento }

  TNF3eEnvEvento = class(TNF3eWebService)
  private
    FidLote: Int64;
    FEvento: TEventoNF3e;
    FcStat: integer;
    FxMotivo: String;
    FTpAmb: TACBrTipoAmbiente;
    FCNPJ: String;

    FEventoRetorno: TRetEventoNF3e;

    function GerarPathEvento(const ACNPJ: String = ''; const AIE: String = ''): String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; AEvento: TEventoNF3e); reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property idLote: Int64 read FidLote write FidLote;
    property cStat: integer read FcStat;
    property xMotivo: String read FxMotivo;
    property TpAmb: TACBrTipoAmbiente read FTpAmb;

    property EventoRetorno: TRetEventoNF3e read FEventoRetorno;
  end;

  { TDistribuicaoDFe }

  TDistribuicaoDFe = class(TNF3eWebService)
  private
    FOwner: TACBrDFe;
    FcUFAutor: integer;
    FCNPJCPF: String;
    FultNSU: String;
    FNSU: String;
    FchNF3e: String;
    FNomeArq: String;
    FlistaArqs: TStringList;

    FretDistDFeInt: TretDistDFeInt;

    function GerarPathDistribuicao(AItem :TdocZipCollectionItem): String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarMsgErro(E: Exception): String; override;
  public
//    constructor Create(AOwner: TACBrDFe); override;
    constructor Create(AOwner: TACBrDFe); reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property cUFAutor: integer read FcUFAutor write FcUFAutor;
    property CNPJCPF: String read FCNPJCPF write FCNPJCPF;
    property ultNSU: String read FultNSU write FultNSU;
    property NSU: String read FNSU write FNSU;
    property chNF3e: String read FchNF3e write FchNF3e;
    property NomeArq: String read FNomeArq;
    property ListaArqs: TStringList read FlistaArqs;

    property retDistDFeInt: TretDistDFeInt read FretDistDFeInt;
  end;

  { TNF3eEnvioWebService }

  TNF3eEnvioWebService = class(TNF3eWebService)
  private
    FXMLEnvio: String;
    FPURLEnvio: String;
    FVersao: String;
    FSoapActionEnvio: String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgErro(E: Exception): String; override;
    function GerarVersaoDadosSoap: String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;
    procedure Clear; override;

    function Executar: Boolean; override;

    property Versao: String read FVersao;
    property XMLEnvio: String read FXMLEnvio write FXMLEnvio;
    property URLEnvio: String read FPURLEnvio write FPURLEnvio;
    property SoapActionEnvio: String read FSoapActionEnvio write FSoapActionEnvio;
  end;

  { TWebServices }

  TWebServices = class
  private
    FACBrNF3e: TACBrDFe;
    FStatusServico: TNF3eStatusServico;
    FEnviar: TNF3eRecepcao;
    FRetorno: TNF3eRetRecepcao;
    FRecibo: TNF3eRecibo;
    FConsulta: TNF3eConsulta;
    FEnvEvento: TNF3eEnvEvento;
    FDistribuicaoDFe: TDistribuicaoDFe;
    FEnvioWebService: TNF3eEnvioWebService;
  public
    constructor Create(AOwner: TACBrDFe); overload;
    destructor Destroy; override;

    function Envia(ALote: Int64; const ASincrono: Boolean = False): Boolean;
      overload;
    function Envia(const ALote: String; const ASincrono: Boolean = False): Boolean;
      overload;

    property ACBrNF3e: TACBrDFe read FACBrNF3e write FACBrNF3e;
    property StatusServico: TNF3eStatusServico read FStatusServico write FStatusServico;
    property Enviar: TNF3eRecepcao read FEnviar write FEnviar;
    property Retorno: TNF3eRetRecepcao read FRetorno write FRetorno;
    property Recibo: TNF3eRecibo read FRecibo write FRecibo;
    property Consulta: TNF3eConsulta read FConsulta write FConsulta;
    property EnvEvento: TNF3eEnvEvento read FEnvEvento write FEnvEvento;
    property DistribuicaoDFe: TDistribuicaoDFe
      read FDistribuicaoDFe write FDistribuicaoDFe;
    property EnvioWebService: TNF3eEnvioWebService
      read FEnvioWebService write FEnvioWebService;
  end;

implementation

uses
  StrUtils, Math,
  ACBrUtil.Base, ACBrUtil.XMLHTML, ACBrUtil.Strings, ACBrUtil.DateTime,
  ACBrUtil.FilesIO,
  ACBrCompress, ACBrIntegrador,
  ACBrDFeConsts,
  ACBrDFeUtil,
  ACBrDFeComum.ConsStatServ, ACBrDFeComum.RetConsStatServ,
  ACBrDFeComum.ConsReciDFe,
  ACBrNF3e,
  ACBrNF3eConsts,
  ACBrNF3eConsSit;

{ TNF3eWebService }

constructor TNF3eWebService.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPConfiguracoesNF3e := TConfiguracoesNF3e(FPConfiguracoes);
  FPLayout := LayNF3eStatusServico;

  FPHeaderElement := ''; //'NF3eCabecMsg';
  FPBodyElement := 'nf3eDadosMsg';
end;

procedure TNF3eWebService.Clear;
begin
  inherited Clear;

  FPStatus := stIdle;
  if Assigned(FPDFeOwner) and Assigned(FPDFeOwner.SSL) then
    FPDFeOwner.SSL.UseCertificateHTTP := True;
end;

procedure TNF3eWebService.InicializarServico;
begin
  { Sobrescrever apenas se necess�rio }
  inherited InicializarServico;

  FOldSSLType := FPDFeOwner.SSL.SSLType;
  FOldHeaderElement := FPHeaderElement;

  FPHeaderElement := '';

  TACBrNF3e(FPDFeOwner).SetStatus(FPStatus);
end;

procedure TNF3eWebService.RemoverNameSpace;
begin
  FPRetWS := StringReplace(FPRetWS, ' xmlns="http://www.portalfiscal.inf.br/nf3e"',
                                    '', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TNF3eWebService.DefinirURL;
var
  Versao: Double;
begin
  { sobrescrever apenas se necess�rio.
    Voc� tamb�m pode mudar apenas o valor de "FLayoutServico" na classe
    filha e chamar: Inherited;     }

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';
  FPServico := '';
  FPSoapAction := '';

  TACBrNF3e(FPDFeOwner).LerServicoDeParams(FPLayout, Versao, FPURL, FPServico, FPSoapAction);
  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

function TNF3eWebService.GerarVersaoDadosSoap: String;
begin
  { Sobrescrever apenas se necess�rio }

  if EstaVazio(FPVersaoServico) then
    FPVersaoServico := TACBrNF3e(FPDFeOwner).LerVersaoDeParams(FPLayout);

  Result := '<versaoDados>' + FPVersaoServico + '</versaoDados>';
end;

procedure TNF3eWebService.EnviarDados;
var
  UsaIntegrador: Boolean;
  Integrador: TACBrIntegrador;
begin
  UsaIntegrador := Assigned(FPDFeOwner.Integrador);

  Integrador := Nil;

  try
    inherited EnviarDados;
  finally
    if Assigned(Integrador) then
      FPDFeOwner.Integrador := Integrador;
  end;
end;

procedure TNF3eWebService.FinalizarServico;
begin
  { Sobrescrever apenas se necess�rio }

  // Retornar configura��es anteriores
  FPDFeOwner.SSL.SSLType := FOldSSLType;
  FPHeaderElement := FOldHeaderElement;

  TACBrNF3e(FPDFeOwner).SetStatus(stIdle);
end;

{ TNF3eStatusServico }

procedure TNF3eStatusServico.Clear;
begin
  inherited Clear;

  FPStatus := stNF3eStatusServico;
  FPLayout := LayNF3eStatusServico;
  FPArqEnv := 'ped-sta';
  FPArqResp := 'sta';

  Fversao := '';
  FverAplic := '';
  FcStat := 0;
  FxMotivo := '';
  FdhRecbto := 0;
  FTMed := 0;
  FdhRetorno := 0;
  FxObs := '';

  if Assigned(FPConfiguracoesNF3e) then
  begin
    FtpAmb := FPConfiguracoesNF3e.WebServices.Ambiente;
    FcUF := FPConfiguracoesNF3e.WebServices.UFCodigo;
  end
end;

procedure TNF3eStatusServico.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'NF3eStatusServico';
  FPSoapAction := FPServico + '/NF3eStatusServicoNF';
end;

procedure TNF3eStatusServico.DefinirDadosMsg;
var
  ConsStatServ: TConsStatServ;
begin
  ConsStatServ := TConsStatServ.Create(FPVersaoServico, NAME_SPACE_NF3e, 'NF3e', False);
  try
    ConsStatServ.TpAmb := FPConfiguracoesNF3e.WebServices.Ambiente;
    ConsStatServ.CUF := FPConfiguracoesNF3e.WebServices.UFCodigo;

    FPDadosMsg := ConsStatServ.GerarXML;
  finally
    ConsStatServ.Free;
  end;
end;

function TNF3eStatusServico.TratarResposta: Boolean;
var
  NF3eRetorno: TRetConsStatServ;
begin
  FPRetWS := SeparaDadosArray(['nf3eResultMsg'],FPRetornoWS );

  VerificarSemResposta;

  RemoverNameSpace;

  NF3eRetorno := TRetConsStatServ.Create('NF3e');
  try
    NF3eRetorno.XmlRetorno := ParseText(FPRetWS);
    NF3eRetorno.LerXml;

    Fversao := NF3eRetorno.versao;
    FtpAmb := TpcnTipoAmbiente(NF3eRetorno.tpAmb);
    FverAplic := NF3eRetorno.verAplic;
    FcStat := NF3eRetorno.cStat;
    FxMotivo := NF3eRetorno.xMotivo;
    FcUF := NF3eRetorno.cUF;

    { WebService do RS retorna hor�rio de ver�o mesmo pros estados que n�o
      adotam esse hor�rio, ao utilizar esta hora para basear a emiss�o da nota
      acontece o erro. }
    if (pos('svrs.rs.gov.br', FPURL) > 0) and
       (MinutesBetween(NF3eRetorno.dhRecbto, Now) > 50) and
       (not IsHorarioDeVerao(CodigoUFparaUF(FcUF), NF3eRetorno.dhRecbto)) then
      FdhRecbto:= IncHour(NF3eRetorno.dhRecbto,-1)
    else
      FdhRecbto := NF3eRetorno.dhRecbto;

    FTMed := NF3eRetorno.TMed;
    FdhRetorno := NF3eRetorno.dhRetorno;
    FxObs := NF3eRetorno.xObs;
    FPMsg := FxMotivo + LineBreak + FxObs;

    if Assigned(FPConfiguracoesNF3e) and
       Assigned(FPConfiguracoesNF3e.WebServices) and
       FPConfiguracoesNF3e.WebServices.AjustaAguardaConsultaRet then
      FPConfiguracoesNF3e.WebServices.AguardarConsultaRet := FTMed * 1000;

    Result := (FcStat = 107);

  finally
    NF3eRetorno.Free;
  end;
end;

function TNF3eStatusServico.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s' + LineBreak +
                           'Status Descri��o: %s' + LineBreak +
                           'UF: %s' + LineBreak +
                           'Recebimento: %s' + LineBreak +
                           'Tempo M�dio: %s' + LineBreak +
                           'Retorno: %s' + LineBreak +
                           'Observa��o: %s' + LineBreak),
                   [Fversao, TpAmbToStr(FtpAmb), FverAplic, IntToStr(FcStat),
                    FxMotivo, CodigoUFparaUF(FcUF),
                    IfThen(FdhRecbto = 0, '', FormatDateTimeBr(FdhRecbto)),
                    IntToStr(FTMed),
                    IfThen(FdhRetorno = 0, '', FormatDateTimeBr(FdhRetorno)),
                    FxObs]);
  {*)}
end;

function TNF3eStatusServico.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Consulta Status servi�o:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

{ TNF3eRecepcao }

constructor TNF3eRecepcao.Create(AOwner: TACBrDFe; ANotasFiscais: TNotasFiscais);
begin
  inherited Create(AOwner);

  FNotasFiscais := ANotasFiscais;
end;

destructor TNF3eRecepcao.Destroy;
begin
  FNF3eRetornoSincrono.Free;
  FNF3eRetorno.Free;

  inherited Destroy;
end;

procedure TNF3eRecepcao.Clear;
begin
  inherited Clear;

  FPStatus := stNF3eRecepcao;
  FPLayout := LayNF3eRecepcao;
  FPArqEnv := 'env-lot';
  FPArqResp := 'rec';

  Fversao := '';
  FTMed := 0;
  FverAplic := '';
  FcStat    := 0;
  FxMotivo  := '';
  FRecibo   := '';
  FdhRecbto := 0;
  FMsgUnZip := '';

  if Assigned(FPConfiguracoesNF3e) then
  begin
    FtpAmb := FPConfiguracoesNF3e.WebServices.Ambiente;
    FcUF := FPConfiguracoesNF3e.WebServices.UFCodigo;
  end;

  if Assigned(FNF3eRetornoSincrono) then
    FNF3eRetornoSincrono.Free;

  if Assigned(FNF3eRetorno) then
    FNF3eRetorno.Free;

  FNF3eRetornoSincrono := TRetConsSitNF3e.Create;
  FNF3eRetorno := TretEnvDFe.Create;
end;

function TNF3eRecepcao.GetLote: String;
begin
  Result := Trim(FLote);
end;

function TNF3eRecepcao.GetRecibo: String;
begin
  Result := Trim(FRecibo);
end;

procedure TNF3eRecepcao.InicializarServico;
begin
  Sincrono := True;

  if FNotasFiscais.Count > 0 then    // Tem NF3e ? Se SIM, use as informa��es do XML
    FVersaoDF := DblToVersaoNF3e(FNotasFiscais.Items[0].NF3e.infNF3e.Versao)
  else
    FVersaoDF := FPConfiguracoesNF3e.Geral.VersaoDF;

  inherited InicializarServico;

  FPHeaderElement := '';
end;

procedure TNF3eRecepcao.DefinirURL;
var
  xUF: String;
  VerServ: Double;
//  ok: Boolean;
begin
  if FNotasFiscais.Count > 0 then    // Tem NF3e ? Se SIM, use as informa��es do XML
  begin
    FcUF := FNotasFiscais.Items[0].NF3e.Ide.cUF;

    if Integer(FPConfiguracoesNF3e.WebServices.Ambiente) <> Integer(FNotasFiscais.Items[0].NF3e.Ide.tpAmb) then
      raise EACBrNF3eException.Create( ACBrNF3e_CErroAmbienteDiferente );
  end
  else
  begin // Se n�o tem NF3e, use as configura��es do componente
    FcUF := FPConfiguracoesNF3e.WebServices.UFCodigo;
  end;

  VerServ := VersaoNF3eToDbl(FVersaoDF);
  FTpAmb  := FPConfiguracoesNF3e.WebServices.Ambiente;
  FPVersaoServico := '';
  FPURL := '';

  if FSincrono then
    FPLayout := LayNF3eRecepcaoSinc
  else
    FPLayout := LayNF3eRecepcao;

  // Configura��o correta ao enviar para o SVC
  case FPConfiguracoesNF3e.Geral.FormaEmissao of
    teSVCAN: xUF := 'SVC-AN';
    teSVCRS: xUF := 'SVC-RS';
  else
    xUF := CodigoUFparaUF(FcUF);
  end;

  TACBrNF3e(FPDFeOwner).LerServicoDeParams(
    'NF3e',
    xUF,
    FTpAmb,
    LayOutToServico(FPLayout),
    VerServ,
    FPURL,
    FPServico,
    FPSoapAction);

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TNF3eRecepcao.DefinirServicoEAction;
begin
  if FSincrono then
  begin
    if EstaVazio(FPServico) then
      FPServico := GetUrlWsd + 'NF3eRecepcaoSinc';
    if EstaVazio(FPSoapAction) then
      FPSoapAction := FPServico + '/nf3eRecepcao';
  end
  else
  begin
    FPServico := GetUrlWsd + 'NF3eRecepcao';
    FPSoapAction := FPServico + '/nf3eRecepcaoLote';
  end;
end;

procedure TNF3eRecepcao.DefinirDadosMsg;
var
  I: integer;
  vNotas: String;
begin
  if Sincrono then
  begin
    // No envio s� podemos ter apena UM NF3-e, pois o seu processamento � s�ncrono
    if FNotasFiscais.Count > 1 then
      GerarException(ACBrStr('ERRO: Conjunto de NF3-e transmitidos (m�ximo de 1 NF3-e)' +
             ' excedido. Quantidade atual: ' + IntToStr(FNotasFiscais.Count)));

    if FNotasFiscais.Count > 0 then
      FPDadosMsg := '<NF3e' +
        RetornarConteudoEntre(FNotasFiscais.Items[0].XMLAssinado, '<NF3e', '</NF3e>') +
        '</NF3e>';
  end
  else
  begin
    vNotas := '';

    for I := 0 to FNotasFiscais.Count - 1 do
      vNotas := vNotas + '<NF3e' + RetornarConteudoEntre(
        FNotasFiscais.Items[I].XMLAssinado, '<NF3e', '</NF3e>') + '</NF3e>';

    FPDadosMsg := '<enviNF3e xmlns="'+ACBRNF3e_NAMESPACE+'" versao="' +
      FPVersaoServico + '">' + '<idLote>' + FLote + '</idLote>' +
      vNotas + '</enviNF3e>';
  end;

  FMsgUnZip := FPDadosMsg;

  FPDadosMsg := EncodeBase64(GZipCompress(FPDadosMsg));

  // Lote tem mais de 1 Mb ? //
  if Length(FPDadosMsg) > (1024 * 1024) then
    GerarException(ACBrStr('Tamanho do XML de Dados superior a 1 Mbytes. Tamanho atual: ' +
      IntToStr(trunc(Length(FPDadosMsg) / 1024)) + ' Kbytes'));

  FRecibo := '';
end;

function TNF3eRecepcao.TratarResposta: Boolean;
var
  I: integer;
  chNF3e, AXML, NomeXMLSalvo: String;
  AProcNF3e: TProcDFe;
  SalvarXML: Boolean;
begin
  FPRetWS := SeparaDadosArray(['nf3eResultMsg'], FPRetornoWS );

  VerificarSemResposta;

  RemoverNameSpace;

  if FSincrono then
  begin
    if pos('retNF3e', FPRetWS) > 0 then
      AXML := StringReplace(FPRetWS, 'retNF3e', 'retConsSitNF3e',
                                     [rfReplaceAll, rfIgnoreCase])
    else if pos('retConsReciNF3e', FPRetWS) > 0 then
      AXML := StringReplace(FPRetWS, 'retConsReciNF3e', 'retConsSitNF3e',
                                     [rfReplaceAll, rfIgnoreCase])
    else
      AXML := FPRetWS;

    FNF3eRetornoSincrono.XmlRetorno := ParseText(AXML);
    FNF3eRetornoSincrono.LerXml;

    Fversao := FNF3eRetornoSincrono.versao;
    FTpAmb := TpcnTipoAmbiente(FNF3eRetornoSincrono.TpAmb);
    FverAplic := FNF3eRetornoSincrono.verAplic;

    // Consta no Retorno da NFC-e
    FRecibo := FNF3eRetornoSincrono.nRec;
    FcUF := FNF3eRetornoSincrono.cUF;
    chNF3e := FNF3eRetornoSincrono.ProtNF3e.chDFe;

    if (FNF3eRetornoSincrono.protNF3e.cStat > 0) then
      FcStat := FNF3eRetornoSincrono.protNF3e.cStat
    else
      FcStat := FNF3eRetornoSincrono.cStat;

    if (FNF3eRetornoSincrono.protNF3e.xMotivo <> '') then
    begin
      FPMsg := FNF3eRetornoSincrono.protNF3e.xMotivo;
      FxMotivo := FNF3eRetornoSincrono.protNF3e.xMotivo;
    end
    else
    begin
      FPMsg := FNF3eRetornoSincrono.xMotivo;
      FxMotivo := FNF3eRetornoSincrono.xMotivo;
    end;

    // Verificar se a NF3-e foi autorizada com sucesso
    Result := (FNF3eRetornoSincrono.cStat = 104) and
      (TACBrNF3e(FPDFeOwner).CstatProcessado(FNF3eRetornoSincrono.protNF3e.cStat));

    if Result then
    begin
      for I := 0 to TACBrNF3e(FPDFeOwner).NotasFiscais.Count - 1 do
      begin
        with TACBrNF3e(FPDFeOwner).NotasFiscais.Items[I] do
        begin
          if OnlyNumber(chNF3e) = NumID then
          begin
            if (FPConfiguracoesNF3e.Geral.ValidarDigest) and
               (FNF3eRetornoSincrono.protNF3e.digVal <> '') and
               (NF3e.signature.DigestValue <> FNF3eRetornoSincrono.protNF3e.digVal) then
            begin
              raise EACBrNF3eException.Create('DigestValue do documento ' + NumID + ' n�o coNF3ere.');
            end;

            NF3e.procNF3e.cStat := FNF3eRetornoSincrono.protNF3e.cStat;
            NF3e.procNF3e.tpAmb := FNF3eRetornoSincrono.tpAmb;
            NF3e.procNF3e.verAplic := FNF3eRetornoSincrono.verAplic;
            NF3e.procNF3e.chDFe := FNF3eRetornoSincrono.ProtNF3e.chDFe;
            NF3e.procNF3e.dhRecbto := FNF3eRetornoSincrono.protNF3e.dhRecbto;
            NF3e.procNF3e.nProt := FNF3eRetornoSincrono.ProtNF3e.nProt;
            NF3e.procNF3e.digVal := FNF3eRetornoSincrono.protNF3e.digVal;
            NF3e.procNF3e.xMotivo := FNF3eRetornoSincrono.protNF3e.xMotivo;

            AProcNF3e := TProcDFe.Create(FPVersaoServico, NAME_SPACE_NF3e, 'nf3eProc', 'NF3e');
            try
              // Processando em UTF8, para poder gravar arquivo corretamente //
              AProcNF3e.XML_DFe := RemoverDeclaracaoXML(XMLAssinado);
              AProcNF3e.XML_Prot := FNF3eRetornoSincrono.XMLprotNF3e;
              XMLOriginal := AProcNF3e.GerarXML;

              if FPConfiguracoesNF3e.Arquivos.Salvar then
              begin
                SalvarXML := Processada;

                // Salva o XML da NF3-e assinado e protocolado
                if SalvarXML then
                begin
                  NomeXMLSalvo := '';
                  if NaoEstaVazio(NomeArq) and FileExists(NomeArq) then
                  begin
                    FPDFeOwner.Gravar( NomeArq, XMLOriginal ); // Atualiza o XML carregado
                    NomeXMLSalvo := NomeArq;
                  end;

                  if (NomeXMLSalvo <> CalcularNomeArquivoCompleto()) then
                    GravarXML; // Salva na pasta baseado nas configura��es do PathNF3e
                end;
              end ;
            finally
              AProcNF3e.Free;
            end;
            Break;
          end;
        end;
      end;
    end;
  end
  else
  begin
    FNF3eRetorno.XmlRetorno := ParseText(FPRetWS);
    FNF3eRetorno.LerXml;

    Fversao := FNF3eRetorno.versao;
    FTpAmb := TpcnTipoAmbiente(FNF3eRetorno.TpAmb);
    FverAplic := FNF3eRetorno.verAplic;
    FcStat := FNF3eRetorno.cStat;
    FxMotivo := FNF3eRetorno.xMotivo;
    FdhRecbto := FNF3eRetorno.infRec.dhRecbto;
    FTMed := FNF3eRetorno.infRec.tMed;
    FcUF := FNF3eRetorno.cUF;
    FPMsg := FNF3eRetorno.xMotivo;
    FRecibo := FNF3eRetorno.infRec.nRec;

    Result := (FNF3eRetorno.CStat = 103);
  end;
end;

function TNF3eRecepcao.GerarMsgLog: String;
begin
  {(*}
  if FSincrono then
    Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + sLineBreak +
                           'dhRecbto: %s ' + sLineBreak +
                           'chNF3e: %s ' + LineBreak),
                     [FNF3eRetornoSincrono.versao,
                      TipoAmbienteToStr(FNF3eRetornoSincrono.TpAmb),
                      FNF3eRetornoSincrono.verAplic,
                      IntToStr(FNF3eRetornoSincrono.protNF3e.cStat),
                      FNF3eRetornoSincrono.protNF3e.xMotivo,
                      CodigoUFparaUF(FNF3eRetornoSincrono.cUF),
                      FormatDateTimeBr(FNF3eRetornoSincrono.dhRecbto),
                      FNF3eRetornoSincrono.chNF3e])
  else
    Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                             'Ambiente: %s ' + LineBreak +
                             'Vers�o Aplicativo: %s ' + LineBreak +
                             'Status C�digo: %s ' + LineBreak +
                             'Status Descri��o: %s ' + LineBreak +
                             'UF: %s ' + sLineBreak +
                             'Recibo: %s ' + LineBreak +
                             'Recebimento: %s ' + LineBreak +
                             'Tempo M�dio: %s ' + LineBreak),
                     [FNF3eRetorno.versao,
                      TipoAmbienteToStr(FNF3eRetorno.TpAmb),
                      FNF3eRetorno.verAplic,
                      IntToStr(FNF3eRetorno.cStat),
                      FNF3eRetorno.xMotivo,
                      CodigoUFparaUF(FNF3eRetorno.cUF),
                      FNF3eRetorno.infRec.nRec,
                      IfThen(FNF3eRetorno.InfRec.dhRecbto = 0, '',
                             FormatDateTimeBr(FNF3eRetorno.InfRec.dhRecbto)),
                      IntToStr(FNF3eRetorno.InfRec.TMed)]);
  {*)}
end;

function TNF3eRecepcao.GerarPrefixoArquivo: String;
begin
  if FSincrono then  // Esta procesando nome do Retorno Sincrono ?
  begin
    if FRecibo <> '' then
    begin
      Result := Recibo;
      FPArqResp := 'pro-rec';
    end
    else
    begin
      Result := Lote;
      FPArqResp := 'pro-lot';
    end;
  end
  else
    Result := Lote;
end;

{ TNF3eRetRecepcao }

constructor TNF3eRetRecepcao.Create(AOwner: TACBrDFe; ANotasFiscais: TNotasFiscais);
begin
  inherited Create(AOwner);

  FNotasFiscais := ANotasFiscais;
end;

destructor TNF3eRetRecepcao.Destroy;
begin
  FNF3eRetorno.Free;

  inherited Destroy;
end;

function TNF3eRetRecepcao.GetRecibo: String;
begin
  Result := Trim(FRecibo);
end;

procedure TNF3eRetRecepcao.InicializarServico;
begin
  if FNotasFiscais.Count > 0 then    // Tem NF3e ? Se SIM, use as informa��es do XML
    FVersaoDF := DblToVersaoNF3e(FNotasFiscais.Items[0].NF3e.infNF3e.Versao)
  else
    FVersaoDF := FPConfiguracoesNF3e.Geral.VersaoDF;

  inherited InicializarServico;

  FPHeaderElement := '';
end;

procedure TNF3eRetRecepcao.Clear;
var
  i, j: Integer;
begin
  inherited Clear;

  FPStatus := stNF3eRetRecepcao;
  FPLayout := LayNF3eRetRecepcao;
  FPArqEnv := 'ped-rec';
  FPArqResp := 'pro-rec';

  FverAplic := '';
  FcStat := 0;
  FxMotivo := '';
  Fversao := '';
  FxMsg := '';
  FcMsg := 0;

  if Assigned(FPConfiguracoesNF3e) then
  begin
    FtpAmb := TACBrTipoAmbiente(FPConfiguracoesNF3e.WebServices.Ambiente);
    FcUF := FPConfiguracoesNF3e.WebServices.UFCodigo;
  end;

  if Assigned(FNF3eRetorno) and Assigned(FNotasFiscais)
		and Assigned(FNF3eRetorno.ProtDFe) then
  begin
    // Limpa Dados dos retornos das notas Fiscais;
    for i := 0 to FNF3eRetorno.ProtDFe.Count - 1 do
    begin
      for j := 0 to FNotasFiscais.Count - 1 do
      begin
        if OnlyNumber(FNF3eRetorno.ProtDFe.Items[i].chDFe) = FNotasFiscais.Items[J].NumID then
        begin
          FNotasFiscais.Items[j].NF3e.procNF3e.verAplic := '';
          FNotasFiscais.Items[j].NF3e.procNF3e.chDFe    := '';
          FNotasFiscais.Items[j].NF3e.procNF3e.dhRecbto := 0;
          FNotasFiscais.Items[j].NF3e.procNF3e.nProt    := '';
          FNotasFiscais.Items[j].NF3e.procNF3e.digVal   := '';
          FNotasFiscais.Items[j].NF3e.procNF3e.cStat    := 0;
          FNotasFiscais.Items[j].NF3e.procNF3e.xMotivo  := '';
        end;
      end;
    end;
  end;

  if Assigned( FNF3eRetorno ) then
    FreeAndNil(FNF3eRetorno);

  FNF3eRetorno := TRetConsReciDFe.Create('NF3e');
end;

function TNF3eRetRecepcao.Executar: Boolean;
var
  IntervaloTentativas, Tentativas: integer;
begin
  Result := False;

  TACBrNF3e(FPDFeOwner).SetStatus(stNF3eRetRecepcao);
  try
    Sleep(FPConfiguracoesNF3e.WebServices.AguardarConsultaRet);

    Tentativas := 0;
    IntervaloTentativas := max(FPConfiguracoesNF3e.WebServices.IntervaloTentativas, 1000);

    while (inherited Executar) and
      (Tentativas < FPConfiguracoesNF3e.WebServices.Tentativas) do
    begin
      Inc(Tentativas);
      sleep(IntervaloTentativas);
    end;
  finally
    TACBrNF3e(FPDFeOwner).SetStatus(stIdle);
  end;

  if FNF3eRetorno.CStat = 104 then  // Lote processado ?
    Result := TratarRespostaFinal;
end;

procedure TNF3eRetRecepcao.DefinirURL;
var
  xUF: String;
  VerServ: Double;
//  ok: Boolean;
begin
  if FNotasFiscais.Count > 0 then    // Tem NF3e ? Se SIM, use as informa��es do XML
  begin
    FcUF := FNotasFiscais.Items[0].NF3e.Ide.cUF;

    if Integer(FPConfiguracoesNF3e.WebServices.Ambiente) <> Integer(FNotasFiscais.Items[0].NF3e.Ide.tpAmb) then
      raise EACBrNF3eException.Create( ACBrNF3e_CErroAmbienteDiferente );
  end
  else
  begin                              // Se n�o tem NF3e, use as configura��es do componente
    FcUF := FPConfiguracoesNF3e.WebServices.UFCodigo;
  end;

  VerServ := VersaoNF3eToDbl(FVersaoDF);
  FTpAmb := TACBrTipoAmbiente(FPConfiguracoesNF3e.WebServices.Ambiente);
  FPVersaoServico := '';
  FPURL := '';

  FPLayout := LayNF3eRetRecepcao;

  // Configura��o correta ao enviar para o SVC
  case FPConfiguracoesNF3e.Geral.FormaEmissao of
    teSVCAN: xUF := 'SVC-AN';
    teSVCRS: xUF := 'SVC-RS';
  else
    xUF := CodigoUFparaUF(FcUF);
  end;

  TACBrNF3e(FPDFeOwner).LerServicoDeParams(
    'NF3e',
    xUF,
    TpcnTipoAmbiente(FTpAmb),
    LayOutToServico(FPLayout),
    VerServ,
    FPURL,
    FPServico,
    FPSoapAction);

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TNF3eRetRecepcao.DefinirServicoEAction;
begin
//  if FPLayout = LayNF3eRetAutorizacao then
//  begin
//    if EstaVazio(FPServico) then
//      FPServico := GetUrlWsd + 'NF3eRetAutorizacao4';
//    if EstaVazio(FPSoapAction) then
//      FPSoapAction := FPServico +'/NF3eRetAutorizacaoLote';
//  end
//  else
//  begin
    FPServico := GetUrlWsd + 'NF3eRetRecepcao';
    FPSoapAction := FPServico + '/NF3eRetRecepcao';
//  end;
end;

procedure TNF3eRetRecepcao.DefinirDadosMsg;
var
  ConsReciNF3e: TConsReciDFe;
begin
  ConsReciNF3e := TConsReciDFe.Create(FPVersaoServico, NAME_SPACE_NF3e, 'NF3e');
  try
    ConsReciNF3e.tpAmb := TpcnTipoAmbiente(FTpAmb);
    ConsReciNF3e.nRec := FRecibo;

//    AjustarOpcoes( ConsReciNF3e.Gerador.Opcoes );
    FPDadosMsg := ConsReciNF3e.GerarXML;
  finally
    ConsReciNF3e.Free;
  end;
end;

function TNF3eRetRecepcao.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDadosArray(['nf3eResultMsg'],FPRetornoWS );

  VerificarSemResposta;

  RemoverNameSpace;

  FNF3eRetorno.XmlRetorno := ParseText(FPRetWS);
  FNF3eRetorno.LerXML;

  Fversao := FNF3eRetorno.versao;
  FTpAmb := FNF3eRetorno.TpAmb;
  FverAplic := FNF3eRetorno.verAplic;
  FcStat := FNF3eRetorno.cStat;
  FcUF := FNF3eRetorno.cUF;
  FPMsg := FNF3eRetorno.xMotivo;
  FxMotivo := FNF3eRetorno.xMotivo;
  FcMsg := FNF3eRetorno.cMsg;
  FxMsg := FNF3eRetorno.xMsg;

  Result := (FNF3eRetorno.CStat = 105); // Lote em Processamento
end;

function TNF3eRetRecepcao.TratarRespostaFinal: Boolean;
var
  I, J: integer;
  AProcNF3e: TProcDFe;
  AInfProt: TProtDFeCollection;
  SalvarXML: Boolean;
  NomeXMLSalvo: String;
begin
  Result := False;

  AInfProt := FNF3eRetorno.ProtDFe;

  if (AInfProt.Count > 0) then
  begin
    FPMsg := FNF3eRetorno.ProtDFe.Items[0].xMotivo;
    FxMotivo := FNF3eRetorno.ProtDFe.Items[0].xMotivo;
  end;

  //Setando os retornos das notas fiscais;
  for I := 0 to AInfProt.Count - 1 do
  begin
    for J := 0 to FNotasFiscais.Count - 1 do
    begin
      if OnlyNumber(AInfProt.Items[I].chDFe) = FNotasFiscais.Items[J].NumID then
      begin
        if (FPConfiguracoesNF3e.Geral.ValidarDigest) and
           (AInfProt.Items[I].digVal <> '') and
           (FNotasFiscais.Items[J].NF3e.signature.DigestValue <> AInfProt.Items[I].digVal) then
        begin
          raise EACBrNF3eException.Create('DigestValue do documento ' +
            FNotasFiscais.Items[J].NumID + ' n�o coNF3ere.');
        end;

        with FNotasFiscais.Items[J] do
        begin
          NF3e.procNF3e.tpAmb := TACBrTipoAmbiente(AInfProt.Items[I].tpAmb);
          NF3e.procNF3e.verAplic := AInfProt.Items[I].verAplic;
          NF3e.procNF3e.chDFe := AInfProt.Items[I].chDFe;
          NF3e.procNF3e.dhRecbto := AInfProt.Items[I].dhRecbto;
          NF3e.procNF3e.nProt := AInfProt.Items[I].nProt;
          NF3e.procNF3e.digVal := AInfProt.Items[I].digVal;
          NF3e.procNF3e.cStat := AInfProt.Items[I].cStat;
          NF3e.procNF3e.xMotivo := AInfProt.Items[I].xMotivo;
        end;

        // Monta o XML da NF3-e assinado e com o protocolo de Autoriza��o
        if (AInfProt.Items[I].cStat = 100) or (AInfProt.Items[I].cStat = 150) then
        begin
          AProcNF3e := TProcDFe.Create(FPVersaoServico, NAME_SPACE_NF3e, 'nf3eProc', 'NF3e');
          try
            AProcNF3e.XML_DFe := RemoverDeclaracaoXML(FNotasFiscais.Items[J].XMLAssinado);
            AProcNF3e.XML_Prot := AInfProt.Items[I].XMLprotDFe;

            with FNotasFiscais.Items[J] do
            begin
              XMLOriginal := AProcNF3e.GerarXML;

              if FPConfiguracoesNF3e.Arquivos.Salvar then
              begin
                SalvarXML := Processada;

                // Salva o XML da NF3-e assinado e protocolado
                if SalvarXML then
                begin
                  NomeXMLSalvo := '';
                  if NaoEstaVazio(NomeArq) and FileExists(NomeArq) then
                  begin
                    FPDFeOwner.Gravar( NomeArq, XMLOriginal );  // Atualiza o XML carregado
                    NomeXMLSalvo := NomeArq;
                  end;

                  if (NomeXMLSalvo <> CalcularNomeArquivoCompleto()) then
                    GravarXML; // Salva na pasta baseado nas configura��es do PathNF3e
                end;
              end;
            end;
          finally
            AProcNF3e.Free;
          end;
        end;

        break;
      end;
    end;
  end;

  //Verificando se existe alguma nota confirmada
  for I := 0 to FNotasFiscais.Count - 1 do
  begin
    if FNotasFiscais.Items[I].Confirmada then
    begin
      Result := True;
      break;
    end;
  end;

  //Verificando se existe alguma nota nao confirmada
  for I := 0 to FNotasFiscais.Count - 1 do
  begin
    if not FNotasFiscais.Items[I].Confirmada then
    begin
      FPMsg := ACBrStr('Nota(s) n�o confirmadas:') + LineBreak;
      break;
    end;
  end;

  //Montando a mensagem de retorno para as notas nao confirmadas
  for I := 0 to FNotasFiscais.Count - 1 do
  begin
    if not FNotasFiscais.Items[I].Confirmada then
      FPMsg := FPMsg + IntToStr(FNotasFiscais.Items[I].NF3e.Ide.nNF) +
        '->' + IntToStr(FNotasFiscais.Items[I].cStat)+'-'+ FNotasFiscais.Items[I].Msg + LineBreak;
  end;

  if AInfProt.Count > 0 then
  begin
    FChaveNF3e := AInfProt.Items[0].chDFe;
    FProtocolo := AInfProt.Items[0].nProt;
    FcStat := AInfProt.Items[0].cStat;
  end;
end;

procedure TNF3eRetRecepcao.FinalizarServico;
begin
  // Sobrescrito, para n�o liberar para stIdle... n�o ainda...;

  // Retornar configura��es anteriores
  FPDFeOwner.SSL.SSLType := FOldSSLType;
  FPHeaderElement := FOldHeaderElement;
end;

function TNF3eRetRecepcao.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Recibo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'cMsg: %s ' + LineBreak +
                           'xMsg: %s ' + LineBreak),
                   [FNF3eRetorno.versao, TipoAmbienteToStr(FNF3eRetorno.tpAmb),
                    FNF3eRetorno.verAplic, FNF3eRetorno.nRec,
                    IntToStr(FNF3eRetorno.cStat), FNF3eRetorno.xMotivo,
                    CodigoUFparaUF(FNF3eRetorno.cUF), IntToStr(FNF3eRetorno.cMsg),
                    FNF3eRetorno.xMsg]);
  {*)}
end;

function TNF3eRetRecepcao.GerarPrefixoArquivo: String;
begin
  Result := Recibo;
end;

{ TNF3eRecibo }

constructor TNF3eRecibo.Create(AOwner: TACBrDFe; ANotasFiscais: TNotasFiscais);
begin
  inherited Create(AOwner);

  FNotasFiscais := ANotasFiscais;
end;

destructor TNF3eRecibo.Destroy;
begin
  FNF3eRetorno.Free;

  inherited Destroy;
end;

procedure TNF3eRecibo.Clear;
begin
  inherited Clear;

  FPStatus := stNF3eRecibo;
  FPLayout := LayNF3eRetRecepcao;
  FPArqEnv := 'ped-rec';
  FPArqResp := 'pro-rec';

  Fversao := '';
  FxMsg := '';
  FcMsg := 0;
  FverAplic := '';
  FcStat    := 0;
  FxMotivo  := '';

  if Assigned(FPConfiguracoesNF3e) then
  begin
    FtpAmb := FPConfiguracoesNF3e.WebServices.Ambiente;
    FcUF := FPConfiguracoesNF3e.WebServices.UFCodigo;
  end;

  if Assigned(FNF3eRetorno) then
    FNF3eRetorno.Free;

  FNF3eRetorno := TRetConsReciDFe.Create('NF3e');
end;

procedure TNF3eRecibo.InicializarServico;
begin
  if FNotasFiscais.Count > 0 then    // Tem NF3e ? Se SIM, use as informa��es do XML
    FVersaoDF := DblToVersaoNF3e(FNotasFiscais.Items[0].NF3e.infNF3e.Versao)
  else
    FVersaoDF := FPConfiguracoesNF3e.Geral.VersaoDF;

  inherited InicializarServico;

  FPHeaderElement := '';
end;

procedure TNF3eRecibo.DefinirServicoEAction;
begin
//  if FPLayout = LayNF3eRetAutorizacao then
//  begin
//    if EstaVazio(FPServico) then
//      FPServico := GetUrlWsd + 'NF3eRetAutorizacao4';
//    if EstaVazio(FPSoapAction) then
//      FPSoapAction := FPServico +'/NF3eRetAutorizacaoLote';
//  end
//  else
//  begin
    FPServico := GetUrlWsd + 'NF3eRetRecepcao';
    FPSoapAction := FPServico + '/NF3eRetRecepcao';
//  end;
end;

procedure TNF3eRecibo.DefinirURL;
var
  xUF: String;
  VerServ: Double;
//  ok: Boolean;
begin
  if FNotasFiscais.Count > 0 then    // Tem NF3e ? Se SIM, use as informa��es do XML
  begin
    FcUF := FNotasFiscais.Items[0].NF3e.Ide.cUF;

    if Integer(FPConfiguracoesNF3e.WebServices.Ambiente) <> Integer(FNotasFiscais.Items[0].NF3e.Ide.tpAmb) then
      raise EACBrNF3eException.Create( ACBrNF3e_CErroAmbienteDiferente );
  end
  else
  begin // Se n�o tem NF3e, use as configura��es do componente
    FcUF := FPConfiguracoesNF3e.WebServices.UFCodigo;
  end;

  VerServ := VersaoNF3eToDbl(FVersaoDF);
  FTpAmb := FPConfiguracoesNF3e.WebServices.Ambiente;
  FPVersaoServico := '';
  FPURL := '';

  FPLayout := LayNF3eRetRecepcao;

  // Configura��o correta ao enviar para o SVC
  case FPConfiguracoesNF3e.Geral.FormaEmissao of
    teSVCAN: xUF := 'SVC-AN';
    teSVCRS: xUF := 'SVC-RS';
  else
    xUF := CodigoUFparaUF(FcUF);
  end;

  TACBrNF3e(FPDFeOwner).LerServicoDeParams(
    'NF3e',
    xUF,
    FTpAmb,
    LayOutToServico(FPLayout),
    VerServ,
    FPURL,
    FPServico,
    FPSoapAction);

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TNF3eRecibo.DefinirDadosMsg;
var
  ConsReciNF3e: TConsReciDFe;
begin
  ConsReciNF3e := TConsReciDFe.Create(FPVersaoServico, NAME_SPACE_NF3e, 'NF3e');
  try
    ConsReciNF3e.tpAmb := FTpAmb;
    ConsReciNF3e.nRec  := FRecibo;

//    AjustarOpcoes( ConsReciNF3e.Gerador.Opcoes );
    FPDadosMsg := ConsReciNF3e.GerarXML;
  finally
    ConsReciNF3e.Free;
  end;
end;

function TNF3eRecibo.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDadosArray(['nf3eResultMsg'],FPRetornoWS );

  VerificarSemResposta;

  RemoverNameSpace;

  FNF3eRetorno.XmlRetorno := ParseText(FPRetWS);
  FNF3eRetorno.LerXML;

  Fversao := FNF3eRetorno.versao;
  FTpAmb := TpcnTipoAmbiente(FNF3eRetorno.TpAmb);
  FverAplic := FNF3eRetorno.verAplic;
  FcStat := FNF3eRetorno.cStat;
  FxMotivo := FNF3eRetorno.xMotivo;
  FcUF := FNF3eRetorno.cUF;
  FxMsg := FNF3eRetorno.xMsg;
  FcMsg := FNF3eRetorno.cMsg;
  FPMsg := FxMotivo;

  Result := (FNF3eRetorno.CStat = 104);
end;

function TNF3eRecibo.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Recibo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak),
                   [FNF3eRetorno.versao, TipoAmbienteToStr(FNF3eRetorno.TpAmb),
                   FNF3eRetorno.verAplic, FNF3eRetorno.nRec,
                   IntToStr(FNF3eRetorno.cStat),
                   FNF3eRetorno.xMotivo,
                   CodigoUFparaUF(FNF3eRetorno.cUF)]);
  {*)}
end;

{ TNF3eConsulta }

constructor TNF3eConsulta.Create(AOwner: TACBrDFe; ANotasFiscais: TNotasFiscais);
begin
  inherited Create(AOwner);

  FOwner := AOwner;
  FNotasFiscais := ANotasFiscais;
end;

destructor TNF3eConsulta.Destroy;
begin
  FprotNF3e.Free;
  FprocEventoNF3e.Free;

  inherited Destroy;
end;

procedure TNF3eConsulta.Clear;
begin
  inherited Clear;

  FPStatus := stNF3eConsulta;
  FPLayout := LayNF3eConsulta;
  FPArqEnv := 'ped-sit';
  FPArqResp := 'sit';

  FverAplic := '';
  FcStat := 0;
  FxMotivo := '';
  FProtocolo := '';
  FDhRecbto := 0;
  Fversao := '';
  FRetNF3eDFe := '';

  if Assigned(FPConfiguracoesNF3e) then
  begin
    FtpAmb := FPConfiguracoesNF3e.WebServices.Ambiente;
    FcUF := FPConfiguracoesNF3e.WebServices.UFCodigo;
  end;

  if Assigned(FprotNF3e) then
    FprotNF3e.Free;

  if Assigned(FprocEventoNF3e) then
    FprocEventoNF3e.Free;

  FprotNF3e := TProcDFe.Create(FPVersaoServico, NAME_SPACE_NF3e, 'nf3eProc', 'NF3e');
  FprocEventoNF3e := TRetEventoNF3eCollection.Create;
end;

procedure TNF3eConsulta.SetNF3eChave(const AValue: String);
var
  NumChave: String;
begin
  if FNF3eChave = AValue then Exit;
  NumChave := OnlyNumber(AValue);

  if not ValidarChave(NumChave) then
     raise EACBrNF3eException.Create('Chave "'+AValue+'" inv�lida.');

  FNF3eChave := NumChave;
end;

procedure TNF3eConsulta.DefinirURL;
var
  VerServ: Double;
  xUF: String;
//  ok: Boolean;
begin
  FPVersaoServico := '';

  FPURL   := '';
  FcUF    := ExtrairUFChaveAcesso(FNF3eChave);
  VerServ := VersaoNF3eToDbl(FPConfiguracoesNF3e.Geral.VersaoDF);

  if FNotasFiscais.Count > 0 then
    FTpAmb := TpcnTipoAmbiente(FNotasFiscais.Items[0].NF3e.Ide.tpAmb)
  else
    FTpAmb := FPConfiguracoesNF3e.WebServices.Ambiente;

  // Se a nota foi enviada para o SVC a consulta tem que ser realizada no SVC e
  // n�o na SEFAZ-Autorizadora
  case FPConfiguracoesNF3e.Geral.FormaEmissao of
    teSVCAN: xUF := 'SVC-AN';
    teSVCRS: xUF := 'SVC-RS';
  else
    xUF := CodigoUFparaUF(FcUF);
  end;

  TACBrNF3e(FPDFeOwner).LerServicoDeParams(
    'NF3e',
    xUF,
    FTpAmb,
    LayOutToServico(FPLayout),
    VerServ,
    FPURL,
    FPServico,
    FPSoapAction);

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TNF3eConsulta.DefinirServicoEAction;
begin
  if EstaVazio(FPServico) then
    FPServico := GetUrlWsd + 'NF3eConsulta';

  if EstaVazio(FPSoapAction) then
    FPSoapAction := FPServico + '/NF3eConsultaNF';
end;

procedure TNF3eConsulta.DefinirDadosMsg;
var
  ConsSitNF3e: TConsSitNF3e;
begin
  ConsSitNF3e := TConsSitNF3e.Create;
  try
    ConsSitNF3e.TpAmb := TACBrTipoAmbiente(FTpAmb);
    ConsSitNF3e.chNF3e := FNF3eChave;
    ConsSitNF3e.Versao := FPVersaoServico;
    FPDadosMsg := ConsSitNF3e.GerarXML;
  finally
    ConsSitNF3e.Free;
  end;
end;

function TNF3eConsulta.GerarUFSoap: String;
begin
  Result := '<cUF>' + IntToStr(FcUF) + '</cUF>';
end;

function TNF3eConsulta.TratarResposta: Boolean;

procedure SalvarEventos(Retorno: string);
var
  aEvento, aProcEvento, aIDEvento, sPathEvento, sCNPJ: string;
  Inicio, Fim: Integer;
  TipoEvento: TpcnTpEvento;
  Ok: Boolean;
begin
  while Retorno <> '' do
  begin
    Inicio := Pos('<procEventoNF3e', Retorno);
    Fim    := Pos('</procEventoNF3e>', Retorno) + 15;

    aEvento := Copy(Retorno, Inicio, Fim - Inicio + 1);

    Retorno := Copy(Retorno, Fim + 1, Length(Retorno));

    aProcEvento := '<procEventoNF3e versao="' + FVersao + '" xmlns="' + ACBRNF3e_NAMESPACE + '">' +
                      SeparaDados(aEvento, 'procEventoNF3e') +
                   '</procEventoNF3e>';

    Inicio := Pos('Id=', aProcEvento) + 6;
    Fim    := 52;

    if Inicio = 6 then
      aIDEvento := FormatDateTime('yyyymmddhhnnss', Now)
    else
      aIDEvento := Copy(aProcEvento, Inicio, Fim);

    TipoEvento  := StrToTpEventoNF3e(Ok, SeparaDados(aEvento, 'tpEvento'));
    sCNPJ       := SeparaDados(aEvento, 'CNPJ');
    sPathEvento := PathWithDelim(FPConfiguracoesNF3e.Arquivos.GetPathEvento(TipoEvento, sCNPJ));

    if (aProcEvento <> '') then
      FPDFeOwner.Gravar( aIDEvento + '-procEventoNF3e.xml', aProcEvento, sPathEvento);
  end;
end;

var
  NF3eRetorno: TRetConsSitNF3e;
  SalvarXML, NFCancelada, Atualiza: Boolean;
  aEventos, sPathNF3e, NomeXMLSalvo: String;
  AProcNF3e: TProcDFe;
  I, Inicio, Fim: integer;
  dhEmissao: TDateTime;
begin
  NF3eRetorno := TRetConsSitNF3e.Create;

  try
    FPRetWS := SeparaDadosArray(['nf3eResultMsg'],FPRetornoWS );

    VerificarSemResposta;

    RemoverNameSpace;

    NF3eRetorno.XmlRetorno := ParseText(FPRetWS);
    NF3eRetorno.LerXML;

    NFCancelada := False;
    aEventos := '';

    // <retConsSitNF3e> - Retorno da consulta da situa��o da NF3-e
    // Este � o status oficial da NF3-e
    Fversao := NF3eRetorno.versao;
    FTpAmb := TpcnTipoAmbiente(NF3eRetorno.tpAmb);
    FverAplic := NF3eRetorno.verAplic;
    FcStat := NF3eRetorno.cStat;
    FXMotivo := NF3eRetorno.xMotivo;
    FcUF := NF3eRetorno.cUF;
//    FNF3eChave := NF3eRetorno.chNF3e;
    FPMsg := FXMotivo;

    // <protNF3e> - Retorno dos dados do ENVIO da NF3-e
    // Consider�-los apenas se n�o existir nenhum evento de cancelamento (110111)
    FprotNF3e.PathDFe := NF3eRetorno.protNF3e.PathDFe;
    FprotNF3e.PathRetConsReciDFe := NF3eRetorno.protNF3e.PathRetConsReciDFe;
    FprotNF3e.PathRetConsSitDFe := NF3eRetorno.protNF3e.PathRetConsSitDFe;
    FprotNF3e.tpAmb := NF3eRetorno.protNF3e.tpAmb;
    FprotNF3e.verAplic := NF3eRetorno.protNF3e.verAplic;
    FprotNF3e.chDFe := NF3eRetorno.protNF3e.chDFe;
    FprotNF3e.dhRecbto := NF3eRetorno.protNF3e.dhRecbto;
    FprotNF3e.nProt := NF3eRetorno.protNF3e.nProt;
    FprotNF3e.digVal := NF3eRetorno.protNF3e.digVal;
    FprotNF3e.cStat := NF3eRetorno.protNF3e.cStat;
    FprotNF3e.xMotivo := NF3eRetorno.protNF3e.xMotivo;

    {(*}
    if Assigned(NF3eRetorno.procEventoNF3e) and (NF3eRetorno.procEventoNF3e.Count > 0) then
    begin
      aEventos := '=====================================================' +
        LineBreak + '================== Eventos da NF3-e ==================' +
        LineBreak + '=====================================================' +
        LineBreak + '' + LineBreak + 'Quantidade total de eventos: ' +
        IntToStr(NF3eRetorno.procEventoNF3e.Count);

      FprocEventoNF3e.Clear;
      for I := 0 to NF3eRetorno.procEventoNF3e.Count - 1 do
      begin
        with FprocEventoNF3e.New.RetEventoNF3e.retInfEvento do
        begin
//          idLote := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.idLote;
          tpAmb := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.tpAmb;
          verAplic := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.verAplic;
          cOrgao := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.cOrgao;
          cStat := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.cStat;
          xMotivo := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.xMotivo;
          XML := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.XML;

          ID := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.ID;
          tpAmb := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.tpAmb;
//          CNPJ := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.CNPJ;
          chNF3e := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.chNF3e;
//          dhEvento := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.dhEvento;
          TpEvento := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.TpEvento;
          nSeqEvento := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.nSeqEvento;
          nProt := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.nProt;
//          xJust := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retInfEvento.xJust;

          {
          retEvento.Clear;
          for J := 0 to NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Count-1 do
          begin
            with retEvento.New.RetInfEvento do
            begin
              Id := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.Id;
              tpAmb := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.tpAmb;
              verAplic := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.verAplic;
              cOrgao := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.cOrgao;
              cStat := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.cStat;
              xMotivo := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.xMotivo;
              chNF3e := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.chNF3e;
              tpEvento := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.tpEvento;
              xEvento := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.xEvento;
              nSeqEvento := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.nSeqEvento;
              CNPJDest := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.CNPJDest;
              emailDest := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.emailDest;
              dhRegEvento := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.dhRegEvento;
              nProt := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.nProt;
              XML := NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e.retEvento.Items[J].RetInfEvento.XML;
            end;
          end;
          }
        end;

        {
        with NF3eRetorno.procEventoNF3e.Items[I].RetEventoNF3e do
        begin
          for j := 0 to retEvento.Count -1 do
          begin
            aEventos := aEventos + LineBreak + LineBreak +
              Format(ACBrStr('N�mero de sequ�ncia: %s ' + LineBreak +
                             'C�digo do evento: %s ' + LineBreak +
                             'Descri��o do evento: %s ' + LineBreak +
                             'Status do evento: %s ' + LineBreak +
                             'Descri��o do status: %s ' + LineBreak +
                             'Protocolo: %s ' + LineBreak +
                             'Data/Hora do registro: %s '),
                     [IntToStr(InfEvento.nSeqEvento),
                      TpEventoToStr(InfEvento.TpEvento),
                      InfEvento.DescEvento,
                      IntToStr(retEvento.Items[J].RetInfEvento.cStat),
                      retEvento.Items[J].RetInfEvento.xMotivo,
                      retEvento.Items[J].RetInfEvento.nProt,
                      FormatDateTimeBr(retEvento.Items[J].RetInfEvento.dhRegEvento)]);

            if retEvento.Items[J].RetInfEvento.tpEvento in [teCancelamento, teCancSubst] then
            begin
              NFCancelada := True;
              FProtocolo := retEvento.Items[J].RetInfEvento.nProt;
              FDhRecbto := retEvento.Items[J].RetInfEvento.dhRegEvento;
              FPMsg := retEvento.Items[J].RetInfEvento.xMotivo;
            end;
          end;
        end;
        }
      end;
    end;
    {*)}

    if (not NFCancelada) and (NaoEstaVazio(NF3eRetorno.protNF3e.nProt))  then
    begin
      FProtocolo := NF3eRetorno.protNF3e.nProt;
      FDhRecbto := NF3eRetorno.protNF3e.dhRecbto;
      FPMsg := NF3eRetorno.protNF3e.xMotivo;
    end;

    if not Assigned(FPDFeOwner) then //evita AV caso n�o atribua o Owner
    begin
     Result := True;
     Exit;
    end;

    with TACBrNF3e(FPDFeOwner) do
    begin
      Result := CstatProcessado(NF3eRetorno.CStat) or
                CstatCancelada(NF3eRetorno.CStat);
    end;

    if Result then
    begin
      if TACBrNF3e(FPDFeOwner).NotasFiscais.Count > 0 then
      begin
        for i := 0 to TACBrNF3e(FPDFeOwner).NotasFiscais.Count - 1 do
        begin
          with TACBrNF3e(FPDFeOwner).NotasFiscais.Items[i] do
          begin
            if (OnlyNumber(FNF3eChave) = NumID) then
            begin
              Atualiza := (NaoEstaVazio(NF3eRetorno.XMLprotNF3e));
              if Atualiza and
                 TACBrNF3e(FPDFeOwner).CstatCancelada(NF3eRetorno.CStat) then
                Atualiza := False;

              // No retorno pode constar que a nota esta cancelada, mas traz o grupo
              // <protNF3e> com as informa��es da sua autoriza��o
              if not Atualiza and TACBrNF3e(FPDFeOwner).cstatProcessado(NF3eRetorno.protNF3e.cStat) then
                Atualiza := True;

              if (FPConfiguracoesNF3e.Geral.ValidarDigest) and
                (NF3eRetorno.protNF3e.digVal <> '') and (NF3e.signature.DigestValue <> '') and
                (UpperCase(NF3e.signature.DigestValue) <> UpperCase(NF3eRetorno.protNF3e.digVal)) then
              begin
                raise EACBrNF3eException.Create('DigestValue do documento ' +
                  NumID + ' n�o confere.');
              end;

              // Atualiza o Status da NF3e interna //
              NF3e.procNF3e.cStat := NF3eRetorno.cStat;

              if Atualiza then
              begin
                if TACBrNF3e(FPDFeOwner).CstatCancelada(NF3eRetorno.CStat) then
                begin
                  NF3e.procNF3e.tpAmb := NF3eRetorno.tpAmb;
                  NF3e.procNF3e.verAplic := NF3eRetorno.verAplic;
                  NF3e.procNF3e.chDFe := NF3eRetorno.chNF3e;
                  NF3e.procNF3e.dhRecbto := FDhRecbto;
                  NF3e.procNF3e.nProt := FProtocolo;
                  NF3e.procNF3e.digVal := NF3eRetorno.protNF3e.digVal;
                  NF3e.procNF3e.cStat := NF3eRetorno.cStat;
                  NF3e.procNF3e.xMotivo := NF3eRetorno.xMotivo;
   
                  GerarXML;
                end
                else
                begin
                  NF3e.procNF3e.tpAmb := NF3eRetorno.protNF3e.tpAmb;
                  NF3e.procNF3e.verAplic := NF3eRetorno.protNF3e.verAplic;
                  NF3e.procNF3e.chDFe := NF3eRetorno.protNF3e.chDFe;
                  NF3e.procNF3e.dhRecbto := NF3eRetorno.protNF3e.dhRecbto;
                  NF3e.procNF3e.nProt := NF3eRetorno.protNF3e.nProt;
                  NF3e.procNF3e.digVal := NF3eRetorno.protNF3e.digVal;
                  NF3e.procNF3e.cStat := NF3eRetorno.protNF3e.cStat;
                  NF3e.procNF3e.xMotivo := NF3eRetorno.protNF3e.xMotivo;

                  // O c�digo abaixo � bem mais r�pido que "GerarXML" (acima)...
                  AProcNF3e := TProcDFe.Create(FPVersaoServico, NAME_SPACE_NF3e, 'nf3eProc', 'NF3e');
                  try
                    AProcNF3e.XML_DFe := RemoverDeclaracaoXML(XMLOriginal);
                    AProcNF3e.XML_Prot := NF3eRetorno.XMLprotNF3e;

                    XMLOriginal := AProcNF3e.GerarXML;
                  finally
                    AProcNF3e.Free;
                  end;
                end;
              end;

              { Se no retorno da consulta constar que a nota possui eventos vinculados
               ser� disponibilizado na propriedade FRetNF3eDFe, e conforme configurado
               em "ConfiguracoesNF3e.Arquivos.Salvar", tamb�m ser� gerado o arquivo:
               <chave>-NF3eDFe.xml}

              FRetNF3eDFe := '';

              if (NaoEstaVazio(SeparaDados(FPRetWS, 'procEventoNF3e'))) then
              begin
                Inicio := Pos('<procEventoNF3e', FPRetWS);
                Fim    := Pos('</retConsSitNF3e', FPRetWS) -1;

                aEventos := Copy(FPRetWS, Inicio, Fim - Inicio + 1);

                FRetNF3eDFe := '<' + ENCODING_UTF8 + '>' +
                              '<NF3eDFe>' +
                               '<nf3eProc versao="' + FVersao + '">' +
                                 SeparaDados(XMLOriginal, 'nf3eProc') +
                               '</nf3eProc>' +
                               '<procEventoNF3e versao="' + FVersao + '">' +
                                 aEventos +
                               '</procEventoNF3e>' +
                              '</NF3eDFe>';
              end;

              SalvarXML := Result and FPConfiguracoesNF3e.Arquivos.Salvar and Atualiza;

              if SalvarXML then
              begin
                // Salva o XML da NF3-e assinado, protocolado e com os eventos
                if FPConfiguracoesNF3e.Arquivos.EmissaoPathNF3e then
                  dhEmissao := NF3e.Ide.dhEmi
                else
                  dhEmissao := Now;

                sPathNF3e := PathWithDelim(FPConfiguracoesNF3e.Arquivos.GetPathNF3e(dhEmissao, NF3e.Emit.CNPJ));

                if (FRetNF3eDFe <> '') then
                  FPDFeOwner.Gravar( FNF3eChave + '-NF3eDFe.xml', FRetNF3eDFe, sPathNF3e);

                if Atualiza then
                begin
                  // Salva o XML da NF3-e assinado e protocolado
                  NomeXMLSalvo := '';
                  if NaoEstaVazio(NomeArq) and FileExists(NomeArq) then
                  begin
                    FPDFeOwner.Gravar( NomeArq, XMLOriginal );  // Atualiza o XML carregado
                    NomeXMLSalvo := NomeArq;
                  end;

                  // Salva na pasta baseado nas configura��es do PathNF3e
                  if (NomeXMLSalvo <> CalcularNomeArquivoCompleto()) then
                    GravarXML;

                  // Salva o XML de eventos retornados ao consultar um NF3-e
                  if ExtrairEventos then
                    SalvarEventos(aEventos);
                end;
              end;

              break;
            end;
          end;
        end;
      end
      else
      begin
        if ExtrairEventos and FPConfiguracoesNF3e.Arquivos.Salvar and
           (NaoEstaVazio(SeparaDados(FPRetWS, 'procEventoNF3e'))) then
        begin
          Inicio := Pos('<procEventoNF3e', FPRetWS);
          Fim    := Pos('</retConsSitNF3e', FPRetWS) -1;

          aEventos := Copy(FPRetWS, Inicio, Fim - Inicio + 1);

          // Salva o XML de eventos retornados ao consultar um NF3-e
          SalvarEventos(aEventos);
        end;
      end;
    end;
  finally
    NF3eRetorno.Free;
  end;
end;

function TNF3eConsulta.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Identificador: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'Chave Acesso: %s ' + LineBreak +
                           'Recebimento: %s ' + LineBreak +
                           'Protocolo: %s ' + LineBreak +
                           'Digest Value: %s ' + LineBreak),
                   [Fversao, FNF3eChave, TpAmbToStr(FTpAmb), FverAplic,
                    IntToStr(FcStat), FXMotivo, CodigoUFparaUF(FcUF), FNF3eChave,
                    FormatDateTimeBr(FDhRecbto), FProtocolo, FprotNF3e.digVal]);
  {*)}
end;

function TNF3eConsulta.GerarPrefixoArquivo: String;
begin
  Result := Trim(FNF3eChave);
end;

{ TNF3eEnvEvento }

constructor TNF3eEnvEvento.Create(AOwner: TACBrDFe; AEvento: TEventoNF3e);
begin
  inherited Create(AOwner);

  FEvento := AEvento;
end;

destructor TNF3eEnvEvento.Destroy;
begin
  if Assigned(FEventoRetorno) then
    FEventoRetorno.Free;

  inherited Destroy;
end;

procedure TNF3eEnvEvento.Clear;
begin
  inherited Clear;

  FPStatus := stNF3eEvento;
  FPLayout := LayNF3eEvento;
  FPArqEnv := 'ped-eve';
  FPArqResp := 'eve';

  FcStat   := 0;
  FxMotivo := '';
  FCNPJ := '';

  if Assigned(FPConfiguracoesNF3e) then
    FtpAmb := TACBrTipoAmbiente(FPConfiguracoesNF3e.WebServices.Ambiente);

  if Assigned(FEventoRetorno) then
    FEventoRetorno.Free;

  FEventoRetorno := TRetEventoNF3e.Create;
end;

function TNF3eEnvEvento.GerarPathEvento(const ACNPJ: String; const AIE: String): String;
begin
  with FEvento.Evento.Items[0].InfEvento do
  begin
    Result := FPConfiguracoesNF3e.Arquivos.GetPathEvento(tpEvento, ACNPJ, AIE);
  end;
end;

procedure TNF3eEnvEvento.DefinirURL;
var
  UF: String;
  VerServ: Double;
//  ok: Boolean;
begin
  { Verifica��o necess�ria pois somente os eventos de Cancelamento e CCe ser�o tratados pela SEFAZ do estado
    os outros eventos como manifestacao de destinat�rios ser�o tratados diretamente pela RFB }

  FPLayout := LayNF3eEvento;
  VerServ  := VersaoNF3eToDbl(FPConfiguracoesNF3e.Geral.VersaoDF);
  FCNPJ    := FEvento.Evento.Items[0].InfEvento.CNPJ;
  FTpAmb   := FEvento.Evento.Items[0].InfEvento.tpAmb;

  // Configura��o correta ao enviar para o SVC
  case FPConfiguracoesNF3e.Geral.FormaEmissao of
    teSVCAN: UF := 'SVC-AN';
    teSVCRS: UF := 'SVC-RS';
  else
    UF := CodigoUFparaUF(ExtrairUFChaveAcesso(FEvento.Evento.Items[0].InfEvento.chNF3e));
  end;
  {
  if (FEvento.Evento.Items[0].InfEvento.tpEvento = teEPECNFe) then
  begin
    FPLayout := LayNFCeEPEC;
  end
  else if not (FEvento.Evento.Items[0].InfEvento.tpEvento in [teCCe,
         teCancelamento, teCancSubst, tePedProrrog1, tePedProrrog2,
         teCanPedProrrog1, teCanPedProrrog2]) then
  begin
    FPLayout := LayNF3eEventoAN;
    UF       := 'AN';
  end;
  }
  FPURL := '';

  TACBrNF3e(FPDFeOwner).LerServicoDeParams(
    'NF3e',
    UF,
    TpcnTipoAmbiente(FTpAmb),
    LayOutToServico(FPLayout),
    VerServ,
    FPURL,
    FPServico,
    FPSoapAction);

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TNF3eEnvEvento.DefinirServicoEAction;
begin
  if EstaVazio(FPServico) then
    FPServico := GetUrlWsd + 'NF3eRecepcaoEvento';

  if EstaVazio(FPSoapAction) then
    FPSoapAction := FPServico + '/NF3eRecepcaoEvento';
end;

procedure TNF3eEnvEvento.DefinirDadosMsg;
var
  EventoNF3e: TEventoNF3e;
  I: integer;
  AXMLEvento: AnsiString;
  FErroValidacao: string;
  EventoEhValido: Boolean;
  SchemaEventoNF3e: TSchemaNF3e;
begin
  EventoNF3e := TEventoNF3e.Create;
  try
    EventoNF3e.idLote := FidLote;
    SchemaEventoNF3e  := schErro;
    {(*}
    for I := 0 to FEvento.Evento.Count - 1 do
    begin
      with EventoNF3e.Evento.New do
      begin
        InfEvento.tpAmb := TACBrTipoAmbiente(FTpAmb);
        infEvento.CNPJ := FEvento.Evento[I].InfEvento.CNPJ;
        infEvento.cOrgao := FEvento.Evento[I].InfEvento.cOrgao;
        infEvento.chNF3e := FEvento.Evento[I].InfEvento.chNF3e;
        infEvento.dhEvento := FEvento.Evento[I].InfEvento.dhEvento;
        infEvento.tpEvento := FEvento.Evento[I].InfEvento.tpEvento;
        infEvento.nSeqEvento := FEvento.Evento[I].InfEvento.nSeqEvento;

        case InfEvento.tpEvento of
          teCancelamento:
            begin
              SchemaEventoNF3e := schCancNF3e;
              infEvento.detEvento.nProt := FEvento.Evento[I].InfEvento.detEvento.nProt;
              infEvento.detEvento.xJust := FEvento.Evento[I].InfEvento.detEvento.xJust;
            end;
        end;
      end;
    end;
    {*)}

    EventoNF3e.Versao := FPVersaoServico;
    EventoNF3e.GerarXML;

    AssinarXML(EventoNF3e.Xml, 'eventoNF3e', 'infEvento', 'Falha ao assinar o Envio de Evento ');

    // Separa o XML especifico do Evento para ser Validado.
    AXMLEvento := SeparaDados(FPDadosMsg, 'detEvento');

    case SchemaEventoNF3e of
      schCancNF3e:
        begin
          AXMLEvento := '<evCancNF3e xmlns="' + ACBRNF3E_NAMESPACE + '">' +
//                          AXMLEvento +
                          Trim(RetornarConteudoEntre(AXMLEvento, '<evCancNF3e>', '</evCancNF3e>')) +
                        '</evCancNF3e>';
        end;
    else
      AXMLEvento := '';
    end;

    AXMLEvento := '<' + ENCODING_UTF8 + '>' + AXMLEvento;

    with TACBrNF3e(FPDFeOwner) do
    begin
      EventoEhValido := SSL.Validar(FPDadosMsg,
                                    GerarNomeArqSchema(FPLayout,
                                      StringToFloatDef(FPVersaoServico, 0)),
                                      FPMsg) and
                        SSL.Validar(AXMLEvento,
                                    GerarNomeArqSchemaEvento(SchemaEventoNF3e,
                                      StringToFloatDef(FPVersaoServico, 0)),
                                      FPMsg);
    end;

    if not EventoEhValido then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o dos dados do Evento: ') +
        FPMsg;

      raise EACBrNF3eException.CreateDef(FErroValidacao);
    end;

    for I := 0 to FEvento.Evento.Count - 1 do
      FEvento.Evento[I].InfEvento.id := EventoNF3e.Evento[I].InfEvento.id;
  finally
    EventoNF3e.Free;
  end;
end;

function TNF3eEnvEvento.TratarResposta: Boolean;
var
  I, J: integer;
  NomeArq, PathArq, VersaoEvento, Texto: String;
begin
  FEvento.idLote := idLote;

  FPRetWS := SeparaDadosArray(['nf3eResultMsg'],FPRetornoWS );

  VerificarSemResposta;

  RemoverNameSpace;

  EventoRetorno.XmlRetorno := ParseText(FPRetWS);
  EventoRetorno.LerXml;

  FcStat := EventoRetorno.retInfEvento.cStat;
  FxMotivo := EventoRetorno.retInfEvento.xMotivo;
  FPMsg := EventoRetorno.retInfEvento.xMotivo;
  FTpAmb := EventoRetorno.retInfEvento.tpAmb;

  Result := (FcStat = 128);

  //gerar arquivo proc de evento
  if Result then
  begin
    for I := 0 to FEvento.Evento.Count - 1 do
    begin
      for J := 0 to EventoRetorno.retEvento.Count - 1 do
      begin
        if FEvento.Evento.Items[I].InfEvento.chNF3e =
          EventoRetorno.retEvento.Items[J].RetInfEvento.chNF3e then
        begin
          FEvento.Evento.Items[I].RetInfEvento.tpAmb := EventoRetorno.retEvento.Items[J].RetInfEvento.tpAmb;
          FEvento.Evento.Items[I].RetInfEvento.nProt := EventoRetorno.retEvento.Items[J].RetInfEvento.nProt;
          FEvento.Evento.Items[I].RetInfEvento.dhRegEvento := EventoRetorno.retEvento.Items[J].RetInfEvento.dhRegEvento;
          FEvento.Evento.Items[I].RetInfEvento.cStat := EventoRetorno.retEvento.Items[J].RetInfEvento.cStat;
          FEvento.Evento.Items[I].RetInfEvento.xMotivo := EventoRetorno.retEvento.Items[J].RetInfEvento.xMotivo;

          Texto := '';

          if EventoRetorno.retEvento.Items[J].RetInfEvento.cStat in [135, 136, 155] then
          begin
            VersaoEvento := TACBrNF3e(FPDFeOwner).LerVersaoDeParams(LayNF3eEvento);

            Texto := '<evento versao="' + VersaoEvento + '">' +
                         SeparaDados(FPDadosMsg, 'infEvento', True) +
                         '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">' +
                         SeparaDados(FPDadosMsg, 'Signature', False) +
                         '</Signature>'+
                     '</evento>';

            Texto := Texto +
                       '<retEvento versao="' + VersaoEvento + '">' +
                          SeparaDados(FPRetWS, 'infEvento', True) +
                       '</retEvento>';

            Texto := '<procEventoNF3e versao="' + VersaoEvento + '" xmlns="' + ACBRNF3e_NAMESPACE + '">' +
                       Texto +
                     '</procEventoNF3e>';

            if FPConfiguracoesNF3e.Arquivos.Salvar then
            begin
              NomeArq := OnlyNumber(FEvento.Evento.Items[i].InfEvento.Id) + '-procEventoNF3e.xml';
              PathArq := PathWithDelim(GerarPathEvento(FEvento.Evento.Items[I].InfEvento.CNPJ));

              FPDFeOwner.Gravar(NomeArq, Texto, PathArq);
              FEventoRetorno.retEvento.Items[J].RetInfEvento.NomeArquivo := PathArq + NomeArq;
              FEvento.Evento.Items[I].RetInfEvento.NomeArquivo := PathArq + NomeArq;
            end;

            { Converte de UTF8 para a String nativa e Decodificar caracteres HTML Entity }
            Texto := ParseText(Texto);
          end;

          // Se o evento for rejeitado a propriedade XML conter� uma string vazia
          FEventoRetorno.retEvento.Items[J].RetInfEvento.XML := Texto;
          FEvento.Evento.Items[I].RetInfEvento.XML := Texto;

          break;
        end;
      end;
    end;
  end;
end;

function TNF3eEnvEvento.GerarMsgLog: String;
var
  aMsg: String;
begin
  {(*}
  aMsg := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                         'Ambiente: %s ' + LineBreak +
                         'Vers�o Aplicativo: %s ' + LineBreak +
                         'Status C�digo: %s ' + LineBreak +
                         'Status Descri��o: %s ' + LineBreak),
                 [FEventoRetorno.versao, TipoAmbienteToStr(FEventoRetorno.retInfEvento.tpAmb),
                  FEventoRetorno.retInfEvento.verAplic, IntToStr(FEventoRetorno.retInfEvento.cStat),
                  FEventoRetorno.retInfEvento.xMotivo]);
  {
  if FEventoRetorno.retEvento.Count > 0 then
    aMsg := aMsg + Format(ACBrStr('Recebimento: %s ' + LineBreak),
       [IfThen(FEventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento = 0, '',
               FormatDateTimeBr(FEventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento))]);
  }
  Result := aMsg;
  {*)}
end;

function TNF3eEnvEvento.GerarPrefixoArquivo: String;
begin
//  Result := IntToStr(FEvento.idLote);
  Result := IntToStr(FidLote);
end;

{ TDistribuicaoDFe }

constructor TDistribuicaoDFe.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FOwner := AOwner;
end;

destructor TDistribuicaoDFe.Destroy;
begin
  FretDistDFeInt.Free;
  FlistaArqs.Free;

  inherited Destroy;
end;

procedure TDistribuicaoDFe.Clear;
begin
  inherited Clear;

  FPStatus := stDistDFeInt;
  FPLayout := LayNF3eDistDFeInt;
  FPArqEnv := 'con-dist-dfe';
  FPArqResp := 'dist-dfe';
  FPBodyElement := 'NF3eDistDFeInteresse';
  FPHeaderElement := '';

  if Assigned(FretDistDFeInt) then
    FretDistDFeInt.Free;

  FretDistDFeInt := TRetDistDFeInt.Create(FOwner, 'NF3e');

  if Assigned(FlistaArqs) then
    FlistaArqs.Free;

  FlistaArqs := TStringList.Create;
end;

procedure TDistribuicaoDFe.DefinirURL;
var
  UF : String;
  Versao: Double;
begin
  { Esse m�todo � tratado diretamente pela RFB }

  UF := 'AN';

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';
  Versao := VersaoNF3eToDbl(FPConfiguracoesNF3e.Geral.VersaoDF);

  TACBrNF3e(FPDFeOwner).LerServicoDeParams(
    TACBrNF3e(FPDFeOwner).GetNomeModeloDFe,
    UF ,
    FPConfiguracoesNF3e.WebServices.Ambiente,
    LayOutToServico(FPLayout),
    Versao,
    FPURL, FPServico,
    FPSoapAction);

  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

procedure TDistribuicaoDFe.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'NF3eDistribuicaoDFe';
  FPSoapAction := FPServico + '/NF3eDistDFeInteresse';
end;

procedure TDistribuicaoDFe.DefinirDadosMsg;
var
  DistDFeInt: TDistDFeInt;
begin
  DistDFeInt := TDistDFeInt.Create(FPVersaoServico, NAME_SPACE_NF3e,
                                     'NF3eDadosMsg', 'consChNF3e', 'chNF3e', True);
  try
    DistDFeInt.TpAmb := FPConfiguracoesNF3e.WebServices.Ambiente;
    DistDFeInt.cUFAutor := FcUFAutor;
    DistDFeInt.CNPJCPF := FCNPJCPF;
    DistDFeInt.ultNSU := trim(FultNSU);
    DistDFeInt.NSU := trim(FNSU);
    DistDFeInt.Chave := trim(FchNF3e);

    FPDadosMsg := DistDFeInt.GerarXML;
  finally
    DistDFeInt.Free;
  end;
end;

function TDistribuicaoDFe.TratarResposta: Boolean;
var
  I: integer;
  AXML, aPath: String;
begin
  FPRetWS := SeparaDadosArray(['NF3eDistDFeInteresseResult',
                               'nf3eResultMsg'],FPRetornoWS );

  VerificarSemResposta;

  RemoverNameSpace;

  // Processando em UTF8, para poder gravar arquivo corretamente //
  FretDistDFeInt.XmlRetorno := ParseText(FPRetWS);
  FretDistDFeInt.LerXml;

  FPMsg := FretDistDFeInt.xMotivo;
  Result := (FretDistDFeInt.CStat = 137) or (FretDistDFeInt.CStat = 138);

  for I := 0 to FretDistDFeInt.docZip.Count - 1 do
  begin
    AXML := FretDistDFeInt.docZip.Items[I].XML;
    FNomeArq := '';
    if (AXML <> '') then
    begin
      case FretDistDFeInt.docZip.Items[I].schema of
        schresNFe:
          FNomeArq := FretDistDFeInt.docZip.Items[I].resDFe.chDFe + '-resNF3e.xml';

        schresEvento:
          FNomeArq := OnlyNumber(TpEventoToStr(FretDistDFeInt.docZip.Items[I].resEvento.tpEvento) +
                      FretDistDFeInt.docZip.Items[I].resEvento.chDFe +
                      Format('%.2d', [FretDistDFeInt.docZip.Items[I].resEvento.nSeqEvento])) +
                      '-resEventoNF3e.xml';

        schprocNFe:
          FNomeArq := FretDistDFeInt.docZip.Items[I].resDFe.chDFe + '-NF3e.xml';

        schprocEventoNFe:
          FNomeArq := OnlyNumber(FretDistDFeInt.docZip.Items[I].procEvento.Id) +
                      '-procEventoNF3e.xml';
      end;

      if NaoEstaVazio(NomeArq) then
        FlistaArqs.Add( FNomeArq );

      aPath := GerarPathDistribuicao(FretDistDFeInt.docZip.Items[I]);
      FretDistDFeInt.docZip.Items[I].NomeArq := aPath + FNomeArq;

      if (FPConfiguracoesNF3e.Arquivos.Salvar) and NaoEstaVazio(NomeArq) then
      begin
        if FPConfiguracoesNF3e.Arquivos.SalvarEvento then
          if (FretDistDFeInt.docZip.Items[I].schema in [schresEvento, schprocEventoNFe]) then
            FPDFeOwner.Gravar(NomeArq, AXML, aPath);

        if (FretDistDFeInt.docZip.Items[I].schema in [schresNFe, schprocNFe]) then
          FPDFeOwner.Gravar(NomeArq, AXML, aPath);
      end;
    end;
  end;
end;

function TDistribuicaoDFe.GerarMsgLog: String;
begin
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'Resposta: %s ' + LineBreak +
                           '�ltimo NSU: %s ' + LineBreak +
                           'M�ximo NSU: %s ' + LineBreak),
                   [FretDistDFeInt.versao, TpAmbToStr(FretDistDFeInt.tpAmb),
                    FretDistDFeInt.verAplic, IntToStr(FretDistDFeInt.cStat),
                    FretDistDFeInt.xMotivo,
                    IfThen(FretDistDFeInt.dhResp = 0, '',
                           FormatDateTimeBr(RetDistDFeInt.dhResp)),
                    FretDistDFeInt.ultNSU, FretDistDFeInt.maxNSU]);
end;

function TDistribuicaoDFe.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Distribui��o de DFe:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

function TDistribuicaoDFe.GerarPathDistribuicao(AItem: TdocZipCollectionItem): String;
var
  Data: TDateTime;
begin
  if FPConfiguracoesNF3e.Arquivos.EmissaoPathNF3e then
  begin
    Data := AItem.resDFe.dhEmi;
    if Data = 0 then
    begin
      Data := AItem.resEvento.dhEvento;
      if Data = 0 then
        Data := AItem.procEvento.dhEvento;
    end;
  end
  else
    Data := Now;

  case AItem.schema of
    schresEvento:
      Result := FPConfiguracoesNF3e.Arquivos.GetPathDownloadEvento(AItem.resEvento.tpEvento,
                                                          AItem.resDFe.xNome,
                                                          AItem.resEvento.CNPJCPF,
                                                          AItem.resDFe.IE,
                                                          Data);

    schprocEventoNFe:
      Result := FPConfiguracoesNF3e.Arquivos.GetPathDownloadEvento(AItem.procEvento.tpEvento,
                                                          AItem.resDFe.xNome,
                                                          AItem.procEvento.CNPJ,
                                                          AItem.resDFe.IE,
                                                          Data);

    schresNFe,
    schprocNFe:
      Result := FPConfiguracoesNF3e.Arquivos.GetPathDownload(AItem.resDFe.xNome,
                                                        AItem.resDFe.CNPJCPF,
                                                        AItem.resDFe.IE,
                                                        Data);
  end;
end;

{ TNF3eEnvioWebService }

constructor TNF3eEnvioWebService.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPStatus := stEnvioWebService;
end;

destructor TNF3eEnvioWebService.Destroy;
begin
  inherited Destroy;
end;

procedure TNF3eEnvioWebService.Clear;
begin
  inherited Clear;

  FVersao := '';
end;

function TNF3eEnvioWebService.Executar: Boolean;
begin
  Result := inherited Executar;
end;

procedure TNF3eEnvioWebService.DefinirURL;
begin
  FPURL := FPURLEnvio;
end;

procedure TNF3eEnvioWebService.DefinirServicoEAction;
begin
  FPServico := FPSoapAction;
end;

procedure TNF3eEnvioWebService.DefinirDadosMsg;
//var
//  LeitorXML: TLeitor;
begin
{
  LeitorXML := TLeitor.Create;
  try
    LeitorXML.Arquivo := FXMLEnvio;
    LeitorXML.Grupo := FXMLEnvio;
    FVersao := LeitorXML.rAtributo('versao')
  finally
    LeitorXML.Free;
  end;
}
  FPDadosMsg := FXMLEnvio;
end;

function TNF3eEnvioWebService.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'soap:Body');

  VerificarSemResposta;

  RemoverNameSpace;

  Result := True;
end;

function TNF3eEnvioWebService.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService: '+FPServico + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

function TNF3eEnvioWebService.GerarVersaoDadosSoap: String;
begin
  Result := '<versaoDados>' + FVersao + '</versaoDados>';
end;

{ TWebServices }

constructor TWebServices.Create(AOwner: TACBrDFe);
begin
  FACBrNF3e := TACBrNF3e(AOwner);

  FStatusServico := TNF3eStatusServico.Create(FACBrNF3e);
  FEnviar := TNF3eRecepcao.Create(FACBrNF3e, TACBrNF3e(FACBrNF3e).NotasFiscais);
  FRetorno := TNF3eRetRecepcao.Create(FACBrNF3e, TACBrNF3e(FACBrNF3e).NotasFiscais);
  FRecibo := TNF3eRecibo.Create(FACBrNF3e, TACBrNF3e(FACBrNF3e).NotasFiscais);
  FConsulta := TNF3eConsulta.Create(FACBrNF3e, TACBrNF3e(FACBrNF3e).NotasFiscais);
  FEnvEvento := TNF3eEnvEvento.Create(FACBrNF3e, TACBrNF3e(FACBrNF3e).EventoNF3e);
  FDistribuicaoDFe := TDistribuicaoDFe.Create(FACBrNF3e);
  FEnvioWebService := TNF3eEnvioWebService.Create(FACBrNF3e);
end;

destructor TWebServices.Destroy;
begin
  FStatusServico.Free;
  FEnviar.Free;
  FRetorno.Free;
  FRecibo.Free;
  FConsulta.Free;
  FEnvEvento.Free;
  FDistribuicaoDFe.Free;
  FEnvioWebService.Free;

  inherited Destroy;
end;

function TWebServices.Envia(ALote: Int64; const ASincrono: Boolean): Boolean;
begin
  Result := Envia(IntToStr(ALote), ASincrono);
end;

function TWebServices.Envia(const ALote: String; const ASincrono: Boolean): Boolean;
begin
  FEnviar.Clear;
  FRetorno.Clear;

  FEnviar.Lote := ALote;
  FEnviar.Sincrono := ASincrono;

  if not Enviar.Executar then
    Enviar.GerarException( Enviar.Msg );

  if not ASincrono or ((FEnviar.Recibo <> '') and (FEnviar.cStat = 103)) then
  begin
    FRetorno.Recibo := FEnviar.Recibo;

    if not FRetorno.Executar then
      FRetorno.GerarException( FRetorno.Msg );
  end;

  Result := True;
end;

end.
