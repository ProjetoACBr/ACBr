{*******************************************************************************}
{ Projeto: Componentes ACBr                                                     }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa-  }
{ mentos de Automação Comercial utilizados no Brasil                            }
{                                                                               }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida                }
{                                                                               }
{ Colaboradores nesse arquivo: Antonio Carlos Junior                            }
{                                                                               }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr     }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr       }
{                                                                               }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la  }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela   }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério)  }
{ qualquer versão posterior.                                                    }
{                                                                               }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM    }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU       }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor }
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)               }
{                                                                               }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto }
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,   }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.           }
{ Você também pode obter uma copia da licença em:                               }
{ http://www.opensource.org/licenses/gpl-license.php                            }
{                                                                               }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br }
{        Rua Cel.Aureliano de Camargo, 963 - Tatuí - SP - 18270-170             }
{                                                                               }
{*******************************************************************************}

{$I ACBr.inc}

unit ACBrLibNFSeRespostas;

interface

uses
  SysUtils, Classes, contnrs, ACBrLibResposta, ACBrNFSeXNotasFiscais,
  ACBrNFSeX, ACBrNFSeXWebservicesResponse, ACBrNFSeXWebserviceBase,
  ACBrNFSeXConversao, ACBrNFSeXConfiguracoes, ACBrBase, ACBrLibConfig;

type

  { TLibNFSeResposta }
  TLibNFSeResposta = class (TACBrLibRespostaBase)
    private
      FMsg: String;

    public
      constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo;
      const AFormato: TACBrLibCodificacao); reintroduce;

    published
      property Msg: String read FMsg write FMsg;
  end;

  { TNFSeEventoItem }
  TNFSeEventoItem = class(TACBrLibRespostaBase)
  private
    FCodigo: String;
    FDescricao: String;
    FCorrecao: String;

  public
    procedure Processar(const Evento: TNFSeEventoCollectionItem);

  published
    property Codigo: String read FCodigo write FCodigo;
    property Descricao: String read FDescricao write FDescricao;
    property Correcao: String read FCorrecao write FCorrecao;

  end;

  { TNFSeArquivoItem }

  TNFSeArquivoItem = class(TACBrLibArquivosResposta)
  private
    FNumeroNota: String;
    FCodigoVerificacao: String;
    FNumeroRPS: String;
    FSerieRPS: String;
  public
    procedure Processar(const Resumo: TNFSeResumoCollectionItem);
  published
    property NumeroNota: String read FNumeroNota write FNumeroNota;
    property CodigoVerificacao: String read FCodigoVerificacao write FCodigoVerificacao;
    property NumeroRPS: String read FNumeroRPS write FNumeroRPS;
    property SerieRPS: String read FSerieRPS write FSerieRPS;
  end;

  { TLibNFSeServiceResposta }
  TLibNFSeServiceResposta = class abstract(TACBrLibRespostaEnvio)
  private
    FXmlEnvio: string;
    FXmlRetorno: string;
    FErros: TACBrObjectList;
    FAlertas: TACBrObjectList;
    FResumos: TACBrObjectList;

  public
    constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeWebserviceResponse); virtual;

  published
    property XmlEnvio: String read FXmlEnvio write FXmlEnvio;
    property XmlRetorno: String read FXmlRetorno write FXmlRetorno;
    property Erros: TACBrObjectList read FErros write FErros;
    property Alertas: TACBrObjectList read FAlertas write FAlertas;
    property Resumos: TACBrObjectList read FResumos write FResumos;

  end;

  { TEmiteResposta }
  TEmiteResposta = class(TLibNFSeServiceResposta)
  private
    FLote: string;
    FData: TDateTime;
    FProtocolo: string;
    FModoEnvio: string;
    FMaxRps: Integer;
    FSucesso : boolean;
    FNumeroNota : string;
    FCodigoVerificacao : string;
    FLink : string;
    FSituacao: string;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeEmiteResponse); reintroduce;

  published
    property Lote: string read FLote write FLote;
    property Data: TDateTime read FData write FData;
    property Protocolo: String read FProtocolo write FProtocolo;
    property MaxRps: Integer read FMaxRps write FMaxRps;
    property ModoEnvio: string read FModoEnvio write FModoEnvio;
    property Sucesso: boolean read FSucesso write FSucesso;
    property NumeroNota: string read FNumeroNota write FNumeroNota;
    property CodigoVerificacao: string read FCodigoVerificacao write FCodigoVerificacao;
    property Link: string read FLink write FLink;
    property Situacao: string read FSituacao write FSituacao;
  end;

  { TConsultaSituacaoResposta }
  TConsultaSituacaoResposta = class(TLibNFSeServiceResposta)
  private
    FLote: string;
    FSituacao: string;
    FProtocolo: string;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeConsultaSituacaoResponse); reintroduce;

  published
    property Lote: string read FLote write FLote;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Situacao: string read FSituacao write FSituacao;

  end;

  { TConsultaLoteRpsResposta }
  TConsultaLoteRpsResposta = class(TLibNFSeServiceResposta)
  private
      FLote: string;
      FProtocolo: string;
      FSituacao: string;
      FCodVerificacao: string;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeConsultaLoteRpsResponse); reintroduce;

  published
    property Lote: string read FLote write FLote;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Situacao: string read FSituacao write FSituacao;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
  end;

  { TConsultaNFSePorRpsResposta }
  TConsultaNFSePorRpsResposta = class (TLibNFSeServiceResposta)
  private
    FNumRPS: string;
    FSerie: string;
    FTipo: string;
    FCodVerificacao: string;
    FCancelamento: TNFSeCancelamento;
    FNumNotaSubstituidora: string;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeConsultaNFSeporRpsResponse); reintroduce;

  published
    property NumRPS: string read FNumRPS write FNumRPS;
    property Serie: string read FSerie write FSerie;
    property Tipo: string read FTipo write FTipo;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property Cancelamento: TNFSeCancelamento read FCancelamento write FCancelamento;
    property NumNotaSubstituidora: string read FNumNotaSubstituidora write FNumNotaSubstituidora;
  end;

  { TSubstituirNFSeResposta }
  TSubstituirNFSeResposta = class(TLibNFSeServiceResposta)
  private
    FNumRPS: string;
    FSerie: string;
    FTipo: string;
    FCodVerificacao: string;
    FPedCanc: string;
    FNumNotaSubstituida: string;
    FNumNotaSubstituidora: string;
  
  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeSubstituiNFSeResponse); reintroduce;

  published
    property NumRPS: string read FNumRPS write FNumRPS;
    property Serie: string read FSerie write FSerie;
    property Tipo: string read FTipo write FTipo;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property PedCanc: string read FPedCanc write FPedCanc;
    property NumNotaSubstituida: string read FNumNotaSubstituida write FNumNotaSubstituida;
    property NumNotaSubstituidora: string read FNumNotaSubstituidora write FNumNotaSubstituidora;    
  end;

  { TGerarTokenResposta }
  TGerarTokenResposta = class(TLibNFSeServiceResposta)
  private
    FToken: string;
    FDataExpiracao: TDateTime;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeGerarTokenResponse); reintroduce;

  published
    property Token: string read FToken write FToken;
    property DataExpiracao: TDateTime read FDataExpiracao write FDataExpiracao;
  end;

  { TConsultaNFSeResposta }
  TConsultaNFSeResposta = class(TLibNFSeServiceResposta)
  private
    FMetodo: TMetodo;
    FInfConsultaNFSe: TInfConsultaNFSe;

  public 
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeConsultaNFSeResponse); reintroduce;

  published
    property Metodo: TMetodo read FMetodo write FMetodo;
    property InfConsultaNFSe: TInfConsultaNFSe read FInfConsultaNFSe write FInfConsultaNFSe;
  end;

  { TConsultarLinkNFSeResposta }
  TConsultarLinkNFSeResposta = class(TLibNFSeServiceResposta)
  private
    FNumeroNota: string;
    FNumeroRps: string;
    FSerieRps: string;
    FLink: string;
  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeConsultaLinkNFSeResponse); reintroduce;

  published
    property NumeroNota: string read FNumeroNota write FNumeroNota;
    property NumeroRps: string read FNumeroRps write FNumeroRps;
    property SerieRps: string read FSerieRps write FSerieRps;
    property Link: string read FLink write FLink;
  end;

  TInfCancelamentoNFSeResposta = class(TACBrLibRespostaBase)
  private
    FNumeroNFSe: string;
    FSerieNFSe: string;
    FChaveNFSe: string;
    FDataEmissaoNFSe: TDateTime;
    FCodCancelamento: string;
    FMotCancelamento: string;
    FNumeroLote: string;
    FNumeroRps: Integer;
    FSerieRps: string;
    FValorNFSe: Double;
    FCodVerificacao: string;
    Femail: string;
    FNumeroNFSeSubst: string;
    FSerieNFSeSubst: string;
    FCodServ: string;
  public
    procedure Processar(const InfCancelamento: TInfCancelamento); reintroduce;
  published
    property NumeroNFSe: string read FNumeroNFSe;
    property SerieNFSe: string read FSerieNFSe;
    property ChaveNFSe: string read FChaveNFSe;
    property DataEmissaoNFSe: TDateTime read FDataEmissaoNFSe;
    property CodCancelamento: string read FCodCancelamento;
    property MotCancelamento: string read FMotCancelamento;
    property NumeroLote: string read FNumeroLote;
    property NumeroRps: Integer read FNumeroRps;
    property SerieRps: string read FSerieRps;
    property ValorNFSe: Double read FValorNFSe;
    property CodVerificacao: string read FCodVerificacao;
    property Email: string read FEmail;
    property NumeroNFSeSubst: string read FNumeroNFSeSubst;
    property SerieNFSeSubst: string read FSerieNFSeSubst;
    property CodServ: string read FCodServ;
  end;

  TRetCancelamentoNFSeResposta = class(TACBrLibRespostaBase)
  private
    FNumeroLote: string;
    FSituacao: string;
    FDataHora: TDateTime;
    FMsgCanc: string;
    FSucesso: string;
    FLink: string;
    FNumeroNota: string;
  public
    procedure Processar(const RetCancelamento: TRetCancelamento); reintroduce;
  published
    property NumeroLote: string read FNumeroLote;
    property Situacao: string read FSituacao;
    property DataHora: TDateTime read FDataHora;
    property MSgCanc: string read FMsgCanc;
    property Sucesso: string read FSucesso;
    property Link: string read FLink;
    property NumeroNota: string read FNumeroNota;
  end;

  { TCancelarNFSeResposta }
  TCancelarNFSeResposta = class(TLibNFSeServiceResposta)
  private
    FCodVerificacao: string;
    FInfCancelamento: TInfCancelamentoNFSeResposta;
    FRetCancelamento: TRetCancelamentoNFSeResposta;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeCancelaNFSeResponse); reintroduce;

  published
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property InfCancelamento: TInfCancelamentoNFSeResposta read FInfCancelamento write FInfCancelamento;
    property RetCancelamento: TRetCancelamentoNFSeResposta read FRetCancelamento write FRetCancelamento;
  end;

  { TLinkNFSeResposta }
  TLinkNFSeResposta = class(TLibNFSeServiceResposta)
  private
    FLinkNFSe: string;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const LinkNFSe: string); reintroduce;

  published
    property LinkNFSe: string read FLinkNFSe write FLinkNFSe;
  end;

  { TGerarLoteResposta }
  TGerarLoteResposta = class(TLibNFSeServiceResposta)
  private
    FLote: string;
    FQtdMaxRps: integer;
    FModoEnvio: TmodoEnvio;
    FNomeArq: string;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TNFSeEmiteResponse); reintroduce;

  published
    property Lote: string read FLote write FLote;
    property MaxRps: integer read FQtdMaxRps write FQtdMaxRps;
    property ModoEnvio: TmodoEnvio read FModoEnvio write FModoEnvio;
    property NomeArq: string read FNomeArq write FNomeArq;
  end;

  { TEnviarEventoResposta }
  TEnviarEventoResposta = class(TLibNFSeServiceResposta)
    private
      FToken: string;
      FDataExpiracao: TDateTime;
      FInfEvento: TInfEvento;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Processar(const Response: TNFSeEnviarEventoResponse); reintroduce;

    published
      property Token: string read FToken write FToken;
      property DataExpiracao: TDateTime read FDataExpiracao write FDataExpiracao;
      property InfEvento: TInfEvento read FInfEvento write FInfEvento;
  end;

  { TConsultaEventoResposta }
  TConsultaEventoResposta = class(TLibNFSeServiceResposta)
    private
      FChaveNFSe: string;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Processar(const Response: TNFSeConsultarEventoResponse); reintroduce;

    published
      property ChaveNFSe: string read FChaveNFSe write FChaveNFSe;
  end;

  { TConsultaDFeResposta }
  TConsultaDFeResposta = class(TLibNFSeServiceResposta)
    private
      FNSU: Integer;
      FChaveNFSe: string;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Processar(const Response: TNFSeConsultarDFeResponse); reintroduce;

    published
      property NSU: Integer read FNSU write FNSU;
      property ChaveNFSe: string read FChaveNFSe write FChaveNFSe;
  end;

  { TConsultaParametrosResposta }
  TConsultaParametrosResposta = class(TLibNFSeServiceResposta)
    private
      FtpParamMunic: TParamMunic;
      FCodigoMunicipio: Integer;
      FCodigoServico: string;
      FCompetencia: TDateTime;
      FNumeroBeneficio: string;
      FParametros: TStrings;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Processar(const Response: TNFSeConsultarParamResponse); reintroduce;

    published
      property tpParamMunic: TParamMunic read FtpParamMunic write FtpParamMunic;
      property CodigoMunicipio: Integer read FCodigoMunicipio write FCodigoMunicipio;
      property CodigoServico: string read FCodigoServico write FCodigoServico;
      property Competencia: TDateTime read FCompetencia write FCompetencia;
      property NumeroBeneficio: string read FNumeroBeneficio write FNumeroBeneficio;
      property Parametros: TStrings read FParametros write FParametros;
  end;

  { TObterInformacoesProvedorResposta }

  TObterInformacoesProvedorResposta = class(TACBrLibRespostaBase)
  private
    FIdentificacaoProvedor: string;
    FAutenticacoesRequeridas: string;
    FServicosDisponibilizados: string;
    FParticularidades: string;
  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy; override;

    procedure Processar(const Response: TGeralConfNFSe); reintroduce;

  published
    property IdentificacaoProvedor: String read FIdentificacaoProvedor;
    property AutenticacoesRequeridas: String read FAutenticacoesRequeridas;
    property ServicosDisponibilizados: String read FServicosDisponibilizados;
    property Particularidades: String read FParticularidades;
  end;

implementation

uses
  pcnAuxiliar, pcnConversao, ACBrUtil, ACBrLibNFSeConsts, ACBrLibConsts;

{ TObterInformacoesProvedorResposta }

constructor TObterInformacoesProvedorResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  FIdentificacaoProvedor := '';
  FAutenticacoesRequeridas := '';
  FServicosDisponibilizados := '';

  inherited Create(CSessaoObterInformacoesProvedor, ATipo, AFormato);
end;

destructor TObterInformacoesProvedorResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TObterInformacoesProvedorResposta.Processar(const Response: TGeralConfNFSe);
begin
  FIdentificacaoProvedor := 'Nome:'+ Response.xProvedor +
                            '|Versão:' + VersaoNFSeToStr(Response.Versao);
  if Response.Layout = loABRASF then
    FIdentificacaoProvedor := FIdentificacaoProvedor + '|Layout: ABRASF'
  else
    FIdentificacaoProvedor := FIdentificacaoProvedor + '|Layout: Próprio';

  if Response.Autenticacao.RequerCertificado then
    FAutenticacoesRequeridas := FAutenticacoesRequeridas + 'RequerCertificado|';

  if Response.Autenticacao.RequerLogin then
    FAutenticacoesRequeridas := FAutenticacoesRequeridas + 'RequerLogin|';

  if Response.Autenticacao.RequerChaveAcesso then
    FAutenticacoesRequeridas := FAutenticacoesRequeridas + 'RequerChaveAcesso|';

  if Response.Autenticacao.RequerChaveAutorizacao then
    FAutenticacoesRequeridas := FAutenticacoesRequeridas + 'RequerChaveAutorizacao|';

  if Response.Autenticacao.RequerFraseSecreta then
    FAutenticacoesRequeridas := FAutenticacoesRequeridas + 'RequerFraseSecreta|';

  if Response.ServicosDisponibilizados.EnviarLoteAssincrono then
    FServicosDisponibilizados := FServicosDisponibilizados + 'EnviarLoteAssincrono|';

  if Response.ServicosDisponibilizados.EnviarLoteSincrono then
    FServicosDisponibilizados := FServicosDisponibilizados + 'EnviarLoteSincrono|';

  if Response.ServicosDisponibilizados.EnviarUnitario then
    FServicosDisponibilizados := FServicosDisponibilizados + 'EnviarUnitario|';

  if Response.ServicosDisponibilizados.ConsultarSituacao then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarSituacao|';

  if Response.ServicosDisponibilizados.ConsultarLote then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarLote|';

  if Response.ServicosDisponibilizados.ConsultarRps then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarRps|';

  if Response.ServicosDisponibilizados.ConsultarNfse then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarNfse|';

  if Response.ServicosDisponibilizados.ConsultarFaixaNfse then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarFaixaNfse|';

  if Response.ServicosDisponibilizados.ConsultarServicoPrestado then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarServicoPrestado|';

  if Response.ServicosDisponibilizados.ConsultarServicoTomado then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarServicoTomado|';

  if Response.ServicosDisponibilizados.CancelarNfse then
    FServicosDisponibilizados := FServicosDisponibilizados + 'CancelarNfse|';

  if Response.ServicosDisponibilizados.SubstituirNfse then
    FServicosDisponibilizados := FServicosDisponibilizados + 'SubstituirNfse|';

  if Response.ServicosDisponibilizados.GerarToken then
    FServicosDisponibilizados := FServicosDisponibilizados + 'GerarToken|';

  if Response.ServicosDisponibilizados.EnviarEvento then
    FServicosDisponibilizados := FServicosDisponibilizados + 'EnviarEvento|';

  if Response.ServicosDisponibilizados.ConsultarEvento then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarEvento|';

  if Response.ServicosDisponibilizados.ConsultarDFe then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarDFe|';

  if Response.ServicosDisponibilizados.ConsultarParam then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarParam|';

  if Response.ServicosDisponibilizados.ConsultarSeqRps then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarSeqRps|';

  if Response.ServicosDisponibilizados.ConsultarLinkNfse then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarLinkNfse|';

  if Response.ServicosDisponibilizados.ConsultarNfseChave then
    FServicosDisponibilizados := FServicosDisponibilizados + 'ConsultarNfseChave|';

  if Response.ServicosDisponibilizados.TestarEnvio then
    FServicosDisponibilizados := FServicosDisponibilizados + 'TestarEnvio|';

  if Response.Particularidades.PermiteMaisDeUmServico then
    FParticularidades := FParticularidades + 'PermiteMaisDeUmServico|';

  if Response.Particularidades.PermiteTagOutrasInformacoes then
    FParticularidades := FParticularidades + 'PermiteTagOutrasInformacoes|';

end;

{ TNFSeArquivoItem }

procedure TNFSeArquivoItem.Processar(const Resumo: TNFSeResumoCollectionItem);
begin
  Self.NomeArquivo := ExtractFileName(Resumo.NomeArq);
  Self.CaminhoCompleto := Resumo.NomeArq;
  Self.NumeroNota := Resumo.NumeroNota;
  Self.CodigoVerificacao := Resumo.CodigoVerificacao;
  Self.NumeroRPS := Resumo.NumeroRps;
  Self.SerieRPS := Resumo.SerieRps;
end;

{ TNFSeEventoItem }
procedure TNFSeEventoItem.Processar(const Evento: TNFSeEventoCollectionItem);
begin
  Codigo := Evento.Codigo;
  Descricao := Evento.Descricao;
  Correcao := Evento.Correcao;
end;

{ TLibNFSeResposta }
constructor TLibNFSeResposta.Create(const ASessao: String;
  const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(ASessao, ATipo, AFormato);
end;

{ TLibNFSeServiceResposta }
constructor TLibNFSeServiceResposta.Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(ASessao, ATipo, AFormato);

  FErros := TACBrObjectList.Create(True);
  FAlertas := TACBrObjectList.Create(True);
  FResumos := TACBrObjectList.Create(True);
end;

destructor TLibNFSeServiceResposta.Destroy;
begin
  FErros.Destroy;
  FAlertas.Destroy;
  FResumos.Destroy;
  inherited Destroy;
end;

procedure TLibNFSeServiceResposta.Processar(const Response: TNFSeWebserviceResponse);
var
  i: Integer;
  Item: TNFSeEventoItem;
  Arq: TNFSeArquivoItem;
begin
  XmlEnvio := Response.XmlEnvio;
  XmlRetorno := Response.XmlRetorno;

  if Response.Erros.Count > 0 then
  begin
    for i := 0 to Response.Erros.Count -1 do
    begin
      Item := TNFSeEventoItem.Create(CSessaoRespErro + IntToStr(i + 1), Tipo, Codificacao);
      Item.Processar(Response.Erros.Items[i]);
      FErros.Add(Item);
    end;
  end;

  if Response.Alertas.Count > 0 then
  begin
    for i := 0 to Response.Alertas.Count -1 do
    begin
      Item := TNFSeEventoItem.Create(CSessaoRespAlerta + IntToStr(i + 1), Tipo, Codificacao);
      Item.Processar(Response.Alertas.Items[i]);
      FAlertas.Add(Item);
    end;
  end;

  if Response.Resumos.Count > 0 then
  begin
    for i := 0 to Response.Resumos.Count - 1 do
    begin
      Arq := TNFSeArquivoItem.Create(CSessaoRespArquivo + IntToStr(i + 1), Tipo, Codificacao);
      Arq.Processar(Response.Resumos.Items[i]);
      InformacoesArquivo.Add(Arq);
    end;
  end;
end;

{ TEmiteResposta }
constructor TEmiteResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespEnvio, ATipo, AFormato);
end;

destructor TEmiteResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TEmiteResposta.Processar(const Response: TNFSeEmiteResponse);
begin
  inherited Processar(Response);

  Lote := Response.NumeroLote;
  Data := Response.Data;
  Protocolo := Response.Protocolo;
  MaxRps := Response.MaxRps;
  ModoEnvio := ModoEnvioToStr(Response.ModoEnvio);
  Sucesso := Response.Sucesso;
  NumeroNota := Response.NumeroNota;
  CodigoVerificacao := Response.CodigoVerificacao;
  Link := Response.Link;
  Situacao := Response.Situacao;
end;

{ TConsultaSituacaoResposta }
constructor TConsultaSituacaoResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespSituacao, ATipo, AFormato);
end;

destructor TConsultaSituacaoResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TConsultaSituacaoResposta.Processar(const Response: TNFSeConsultaSituacaoResponse);
begin
  inherited Processar(Response);

  Lote := Response.NumeroLote;
  Protocolo := Response.Protocolo;
  Situacao := Response.Situacao;
end;

{ TConsultaLoteRpsResposta }
constructor TConsultaLoteRpsResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsultaLoteRps, ATipo, AFormato);
end;

destructor TConsultaLoteRpsResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TConsultaLoteRpsResposta.Processar(const Response: TNFSeConsultaLoteRpsResponse);
begin
  inherited Processar(Response);

  Lote:= Response.NumeroLote;
  Protocolo:= Response.Protocolo;
  Situacao:= Response.Situacao;
  CodVerificacao:= Response.CodigoVerificacao;
end;

 { TConsultaNFSePorRpsResposta }
constructor TConsultaNFSePorRpsResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsultaNFSePorRps, ATipo, AFormato);
end;

destructor TConsultaNFSePorRpsResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TConsultaNFSePorRpsResposta.Processar(const Response: TNFSeConsultaNFSeporRpsResponse);
begin
  inherited Processar(Response);

  NumRPS:= Response.NumeroRps;
  Serie:= Response.SerieRps;
  Tipo:= Response.TipoRps;
  CodVerificacao:= Response.CodigoVerificacao;
  Cancelamento:= Response.Cancelamento;
  NumNotaSubstituidora:= Response.NumNotaSubstituidora;
end;

 { TSubstituirNFSeResposta }
constructor TSubstituirNFSeResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespSubstituirNFSe, ATipo, AFormato);
end;

destructor TSubstituirNFSeResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TSubstituirNFSeResposta.Processar(const Response: TNFSeSubstituiNFSeResponse);
begin
  inherited Processar(Response);

  NumRPS:= Response.NumeroRps;
  Serie:= Response.SerieRps;
  Tipo:= Response.TipoRps;
  CodVerificacao:= Response.CodigoVerificacao;
  PedCanc:= Response.PedCanc;
  NumNotaSubstituida:= Response.NumNotaSubstituida;
  NumNotaSubstituidora:= Response.NumNotaSubstituidora;
end;

{ TGerarTokenResposta }
constructor TGerarTokenResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespGerarToken, ATipo, AFormato);
end;

destructor TGerarTokenResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TGerarTokenResposta.Processar(const Response: TNFSeGerarTokenResponse);
begin
  inherited Processar(Response);

  Token:= Response.Token;
  DataExpiracao:= Response.DataExpiracao;
end;

{ TConsultaNFSeResposta }
constructor TConsultaNFSeResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsultaNFSe, ATipo, AFormato);
end;

destructor TConsultaNFSeResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TConsultaNFSeResposta.Processar(const Response: TNFSeConsultaNFSeResponse);
begin
  inherited Processar(Response);

  Metodo:= Response.Metodo;
  InfConsultaNFSe:= Response.InfConsultaNFSe;
end;

{ TConsultarLinkNFSeResposta }

constructor TConsultarLinkNFSeResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsultaLinkNFSe, ATipo, AFormato);
end;

destructor TConsultarLinkNFSeResposta.Destroy;
begin
 inherited Destroy;
end;

procedure TConsultarLinkNFSeResposta.Processar(const Response: TNFSeConsultaLinkNFSeResponse);
begin
  inherited Processar(Response);

  NumeroNota := Response.NumeroNota;
  NumeroRps := Response.NumeroRps;
  SerieRps := Response.SerieRps;
  Link := Response.Link;
end;

{ TInfCancelamentoNFSeResposta }

procedure TInfCancelamentoNFSeResposta.Processar(const InfCancelamento: TInfCancelamento);
begin
  FNumeroNFSe := InfCancelamento.NumeroNFSe;
  FSerieNFSe := InfCancelamento.SerieNFSe;
  FChaveNFSe := InfCancelamento.ChaveNFSe;
  FDataEmissaoNFSe := InfCancelamento.DataEmissaoNFSe;
  FCodCancelamento := InfCancelamento.CodCancelamento;
  FMotCancelamento := InfCancelamento.MotCancelamento;
  FNumeroLote := InfCancelamento.NumeroLote;
  FNumeroRps := InfCancelamento.NumeroRps;
  FSerieRps := InfCancelamento.SerieRps;
  FValorNFSe := InfCancelamento.ValorNFSe;
  FCodVerificacao := InfCancelamento.CodVerificacao;
  Femail := InfCancelamento.email;
  FNumeroNFSeSubst := InfCancelamento.NumeroNFSeSubst;
  FSerieNFSeSubst := InfCancelamento.SerieNFSeSubst;
  FCodServ := InfCancelamento.CodServ;
end;

{ TRetCancelamentoNFSeResposta }
procedure TRetCancelamentoNFSeResposta.Processar(const RetCancelamento: TRetCancelamento);
begin
  FNumeroLote := RetCancelamento.NumeroLote;
  FSituacao := RetCancelamento.Situacao;
  FDataHora := RetCancelamento.DataHora;
  FMsgCanc := RetCancelamento.MsgCanc;
  FSucesso := RetCancelamento.Sucesso;
  FLink := RetCancelamento.Link;
  FNumeroNota := RetCancelamento.NumeroNota;
end;

{ TCancelarNFSeResposta }
constructor TCancelarNFSeResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespCancelarNFSe, ATipo, AFormato);
  InfCancelamento := TInfCancelamentoNFSeResposta.Create(CSessaoRespInformacaoCancelamento, ATipo, AFormato);
  RetCancelamento := TRetCancelamentoNFSeResposta.Create(CSessaoRespRetornoCancelamento, ATipo, AFormato);
end;

destructor TCancelarNFSeResposta.Destroy;
begin
  InfCancelamento.Free;
  RetCancelamento.Free;
  inherited Destroy;
end;

procedure TCancelarNFSeResposta.Processar(const Response: TNFSeCancelaNFSeResponse);
begin
  inherited Processar(Response);

  CodVerificacao:= Response.CodigoVerificacao;
  InfCancelamento.Processar(Response.InfCancelamento);
  RetCancelamento.Processar(Response.RetCancelamento);
end;

{ TLinkNFSeResposta }
constructor TLinkNFSeResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespLinkNFSe, ATipo, AFormato);
end;

destructor TLinkNFSeResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TLinkNFSeResposta.Processar(const LinkNFSe: string);
begin
  FLinkNFSe:= LinkNFSe;
end;

{ TGerarLoteResposta }
constructor TGerarLoteResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespGerarLote, ATipo, AFormato);
end;

destructor TGerarLoteResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TGerarLoteResposta.Processar(const Response: TNFSeEmiteResponse);
begin
  FLote:= Response.NumeroLote;
  FQtdMaxRps:= Response.MaxRps;
  FModoEnvio:= Response.ModoEnvio;
  FNomeArq:= Response.NomeArq;
end;

{ TEnviarEventoResposta }
constructor TEnviarEventoResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespEnviarEvento, ATipo, AFormato);
end;

destructor TEnviarEventoResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TEnviarEventoResposta.Processar(const Response: TNFSeEnviarEventoResponse);
begin
  inherited Processar(Response);

  Token:= Response.Token;
  DataExpiracao:= Response.DataExpiracao;
  InfEvento:= Response.InfEvento;
end;

{ TConsultaEventoResposta }
constructor TConsultaEventoResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsultarEvento, ATipo, AFormato);
end;

destructor TConsultaEventoResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TConsultaEventoResposta.Processar(const Response: TNFSeConsultarEventoResponse);
begin
  inherited Processar(Response);

  ChaveNFSe:= Response.ChaveNFSe;
end;

{ TConsultaDFeResposta }
constructor TConsultaDFeResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsultarDFe, ATipo, AFormato);
end;

destructor TConsultaDFeResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TConsultaDFeResposta.Processar(const Response: TNFSeConsultarDFeResponse);
begin
  inherited Processar(Response);

  NSU:= Response.NSU;
  ChaveNFSe:= Response.ChaveNFSe;
end;

{ TConsultaParametrosResposta }
constructor TConsultaParametrosResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsultarParametros, ATipo, AFormato);
end;

destructor TConsultaParametrosResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TConsultaParametrosResposta.Processar(const Response: TNFSeConsultarParamResponse);
begin
  inherited Processar(Response);

  tpParamMunic:= Response.tpParamMunic;
  CodigoMunicipio:= Response.CodigoMunicipio;
  CodigoServico:= Response.CodigoServico;
  Competencia:= Response.Competencia;
  NumeroBeneficio:= Response.NumeroBeneficio;
  Parametros:= Response.Parametros;
end;

end.

