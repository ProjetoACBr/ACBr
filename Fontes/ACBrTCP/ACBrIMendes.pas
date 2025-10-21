{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{ - Elias César Vieira                                                         }
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

unit ACBrIMendes;

interface

uses
  Classes, SysUtils, Contnrs,
  ACBrAPIBase, ACBrJSON, ACBrBase, ACBrSocket,
  ACBrUtil.Base;

const
  cIMendesURLProducao = '';
  cIMendesURLHomologacao = 'http://consultatributos.com.br:8080';
  cIMendesAPI = 'api';
  cIMendesV1 = 'v1';
  cIMendesV3 = 'v3';
  cIMendesPublic = 'public';
  cIMendesAPIRegimeEspecial = 'regime_especial';
  cIMendesEndPointLogin = 'api/auth';
  cIMendesEndpointCadCliente = 'CadCliente';
  cIMendesEndpointEnviaRecebeDados = 'EnviaRecebeDados';
  cIMendesEndpointSaneamentoGrades = 'SaneamentoGrades';
  cIMendesEndpointEnviaRegimeEspecial = 'SearchSpecialRegime';
  cIMendesDadosUF = 'uf';
  cIMendesDadosServico = 'dados';
  cIMendesNomeServico = 'nomeServico';
  cIMendesServicoAlterados = 'ALTERADOS';
  cIMendesServicoDescricaoProdutos = 'DESCRPRODUTOS';
  cIMendesServicoHistoricoAcesso = 'HISTORICOACESSO';

type    

  EACBrIMendesAuthError = class(Exception);
  EACBrIMendesDataSend = class(Exception);

  TACBrIMendesAmbiente = (
    imaNenhum,
    imaHomologacao,
    imaProducao);

  { TACBrIMendesCabecalho }
  TACBrIMendesCabecalho = class(TACBrAPISchema)
  private
    fUF: String;
    fCNPJ: String;
    fProdutosRetornados: Integer;
    fMensagem: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    procedure Assign(Source: TACBrIMendesCabecalho);
    function IsEmpty: Boolean; override;
    
    property UF: String read fUF write fUF;
    property CNPJ: String read fCNPJ write fCNPJ;
    property ProdutosRetornados: Integer read fProdutosRetornados write fProdutosRetornados;
    property Mensagem: String read fMensagem write fMensagem;
  end;

  { TACBrIMendesProduto }
  TACBrIMendesProduto = class(TACBrAPISchema)
  private
    fId: String;
    fDescricao: String;
    fEan: String;
    fNcm: String;
    fCest: String;
    fDescricaoGrupo: String;
    fCodigo: String;
    fCodInterno: String;
    fCodImendes: String;
    fImportado: String;
    fEncontrado: Boolean;
    fTipo: Integer;
    fChaveRetorno: String;
    fDtUltCons: TDateTime;
    fDtRev: TDateTime;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    procedure Assign(Source: TACBrIMendesProduto);
    function IsEmpty: Boolean; override;

    property Id: String read fId write fId;
    property Descricao: String read fDescricao write fDescricao;
    property Ean: String read fEan write fEan;
    property Ncm: String read fNcm write fNcm;
    property Cest: String read fCest write fCest;
    property DescricaoGrupo: String read fDescricaoGrupo write fDescricaoGrupo;
    property Codigo: String read fCodigo write fCodigo;
    property CodInterno: String read fCodInterno write fCodInterno;
    property CodImendes: String read fCodImendes write fCodImendes;
    property Importado: String read fImportado write fImportado;
    property Encontrado: Boolean read fEncontrado write fEncontrado;
    property Tipo: Integer read fTipo write fTipo;
    property ChaveRetorno: String read fChaveRetorno write fChaveRetorno;
    property DtUltCons: TDateTime read fDtUltCons write fDtUltCons;
    property DtRev: TDateTime read fDtRev write fDtRev;
  end;

  { TACBrIMendesProdutos }
  TACBrIMendesProdutos = class(TACBrAPISchemaArray)
  private
    function GetItem(AIndex: Integer): TACBrIMendesProduto;
    procedure SetItem(AIndex: Integer; AValue: TACBrIMendesProduto);
  public
    function New: TACBrIMendesProduto;
    function NewSchema: TACBrAPISchema; override;
    function Add(AProduto: TACBrIMendesProduto): Integer;
    procedure Insert(AIndex: Integer; AProduto: TACBrIMendesProduto);
    property Items[AIndex: Integer]: TACBrIMendesProduto read GetItem write SetItem; default;
  end;

  { TACBrIMendesConsultarResponse }
  TACBrIMendesConsultarResponse = class(TACBrAPISchema)
  private
    fCabecalho: TACBrIMendesCabecalho;
    fProdutos: TACBrIMendesProdutos;
    function GetCabecalho: TACBrIMendesCabecalho;
    function GetProdutos: TACBrIMendesProdutos;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(Source: TACBrIMendesConsultarResponse);
    function IsEmpty: Boolean; override;

    property Cabecalho: TACBrIMendesCabecalho read GetCabecalho;
    property Produtos: TACBrIMendesProdutos read GetProdutos;
  end;

  { TACBrIMendesPortal }
  TACBrIMendesPortal = class(TACBrAPISchema)
  private
    fUserID: Integer;
    fMethod: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    procedure Assign(Source: TACBrIMendesPortal);
    function IsEmpty: Boolean; override;

    property UserID: Integer read fUserID write fUserID;
    property Method: String read fMethod write fMethod;
  end;

  { TACBrIMendesEmitente }
  TACBrIMendesEmitente = class(TACBrAPISchema)
  private
    famb: Integer;
    fcnpj: String;
    fcrt: Integer;
    fregimeTrib: String;
    fuf: String;
    fmunicipio: Integer;
    fcnae: String;
    fsubstICMS: Boolean;
    finterdependente: Boolean;
    fcnaeSecundario: String;
    fdia: Integer;
    fmes: Integer;
    fano: Integer;
    fdataLimite: TDateTime;
    fportal: TACBrIMendesPortal;
    fregimeEspecial: String;
    function GetPortal: TACBrIMendesPortal;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesEmitente);

    property amb: Integer read famb write famb;
    property cnpj: String read fcnpj write fcnpj;
    property crt: Integer read fcrt write fcrt;
    property regimeTrib: String read fregimeTrib write fregimeTrib;
    property uf: String read fuf write fuf;
    property municipio: Integer read fmunicipio write fmunicipio;
    property cnae: String read fcnae write fcnae;
    property substICMS: Boolean read fsubstICMS write fsubstICMS;
    property interdependente: Boolean read finterdependente write finterdependente;
    property cnaeSecundario: String read fcnaeSecundario write fcnaeSecundario;
    property dia: Integer read fdia write fdia;
    property mes: Integer read fmes write fmes;
    property ano: Integer read fano write fano;
    property dataLimite: TDateTime read fdataLimite write fdataLimite;
    property portal: TACBrIMendesPortal read GetPortal;
    property regimeEspecial: String read fregimeEspecial write fregimeEspecial;
  end;

  { TACBrIMendesCaracTrib }
  TACBrIMendesCaracTrib = class
  private
    flist: TStringList;
    function list: TStringList;

    function GetItem(Index: Integer): Integer;
    procedure SetItem(Index: Integer; AValue: Integer);
  public
    destructor Destroy; override;
    function Add(aItem: Integer): Integer;
    function Count: Integer;
    procedure Clear;

    property Items[Index: Integer]: Integer read GetItem write SetItem; default;
  end;

  { TACBrIMendesPerfil }
  TACBrIMendesPerfil = class(TACBrAPISchema)
  private
    fuf: TStringList;
    fmunicipio: Integer;
    fcfop: String;
    fcaracTrib: TACBrIMendesCaracTrib;
    ffinalidade: Integer;
    fsimplesN: String;
    forigem: Integer;
    fsubstICMS: String;
    fregimeTrib: String;
    fprodZFM: String;
    fregimeEspecial: String;
    ffabricacaoPropria: Boolean;

    function GetCaracTrib: TACBrIMendesCaracTrib;
    function GetUF: TStringList;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesPerfil);

    property uf: TStringList read GetUF;
    property municipio: Integer read fmunicipio write fmunicipio;
    property cfop: String read fcfop write fcfop;
    property caracTrib: TACBrIMendesCaracTrib read GetCaracTrib;
    property finalidade: Integer read ffinalidade write ffinalidade;
    property simplesN: String read fsimplesN write fsimplesN;
    property origem: Integer read forigem write forigem;
    property substICMS: String read fsubstICMS write fsubstICMS;
    property regimeTrib: String read fregimeTrib write fregimeTrib;
    property prodZFM: String read fprodZFM write fprodZFM;
    property regimeEspecial: String read fregimeEspecial write fregimeEspecial;
    property fabricacaoPropria: Boolean read ffabricacaoPropria write ffabricacaoPropria;
  end;

  { TACBrIMendesGradesRequest }
  TACBrIMendesGradesRequest = class(TACBrAPISchema)
  private
    femit: TACBrIMendesEmitente;
    fperfil: TACBrIMendesPerfil;
    fprodutos: TACBrIMendesProdutos;
    function GetEmit: TACBrIMendesEmitente;
    function GetPerfil: TACBrIMendesPerfil;
    function GetProdutos: TACBrIMendesProdutos;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(Source: TACBrIMendesGradesRequest);
    function IsEmpty: Boolean; override;

    property emit: TACBrIMendesEmitente read GetEmit;
    property perfil: TACBrIMendesPerfil read GetPerfil;
    property produtos: TACBrIMendesProdutos read GetProdutos;
  end;

  { TACBrIMendesResumo }
  TACBrIMendesResumo = class(TACBrAPISchema)
  private
    fDataPrimeiroConsumo: TDateTime;
    fDataUltimoConsumo: TDateTime;
    fProdutosPendentes_Interno: Integer;
    fProdutosPendentes_EAN: Integer;
    fProdutosPendentes_Devolvidos: Integer;
    fProdutosPendentes_DataInicio: TDateTime;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesResumo);

    property DataPrimeiroConsumo: TDateTime read fDataPrimeiroConsumo write fDataPrimeiroConsumo;
    property DataUltimoConsumo: TDateTime read fDataUltimoConsumo write fDataUltimoConsumo;
    property ProdutosPendentes_Interno: Integer read fProdutosPendentes_Interno write fProdutosPendentes_Interno;
    property ProdutosPendentes_EAN: Integer read fProdutosPendentes_EAN write fProdutosPendentes_EAN;
    property ProdutosPendentes_Devolvidos: Integer read fProdutosPendentes_Devolvidos write fProdutosPendentes_Devolvidos;
    property ProdutosPendentes_DataInicio: TDateTime read fProdutosPendentes_DataInicio write fProdutosPendentes_DataInicio;
  end;

  { TACBrIMendesHistoricoResponse }
  TACBrIMendesHistoricoResponse = class(TACBrAPISchema)
  private
    fResumo: TACBrIMendesResumo;
    fProdDevolvidos: TACBrIMendesProdutos;
    function GetResumo: TACBrIMendesResumo;
    function GetProdDevolvidos: TACBrIMendesProdutos;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(Source: TACBrIMendesHistoricoResponse);
    function IsEmpty: Boolean; override;

    property Resumo: TACBrIMendesResumo read GetResumo;
    property ProdDevolvidos: TACBrIMendesProdutos read GetProdDevolvidos;
  end;

  { TACBrIMendesRevenda }
  TACBrIMendesRevenda = class(TACBrAPISchema)
  private
    fCNPJCPF: String;
    fNome: String;
    fFone: String;
    fEmail: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesRevenda);

    property CNPJCPF: String read fCNPJCPF write fCNPJCPF;
    property Nome: String read fNome write fNome;
    property Fone: String read fFone write fFone;
    property Email: String read fEmail write fEmail;
  end;

  { TACBrIMendesCliente }
  TACBrIMendesCliente = class(TACBrAPISchema)
  private
    fCNPJCPF: String;
    fRazaoSocial: String;
    fEndereco: String;
    fNro: String;
    fBairro: String;
    fCidade: String;
    fUF: String;
    fCEP: String;
    fFone: String;
    fResponsavel: String;
    fEmail: String;
    fNroCNPJ: Integer;
    fValorImplantacao: Double;
    fValorMensalidade: Double;
    fStatus: String;
    fRegimeTrib: String;
    fTipoAtiv: String;
    fObservacao: String;
    fRevenda: TACBrIMendesRevenda;
    function GetRevenda: TACBrIMendesRevenda;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesCliente);

    property CNPJCPF: String read fCNPJCPF write fCNPJCPF;
    property RazaoSocial: String read fRazaoSocial write fRazaoSocial;
    property Endereco: String read fEndereco write fEndereco;
    property Nro: String read fNro write fNro;
    property Bairro: String read fBairro write fBairro;
    property Cidade: String read fCidade write fCidade;
    property UF: String read fUF write fUF;
    property CEP: String read fCEP write fCEP;
    property Fone: String read fFone write fFone;
    property Responsavel: String read fResponsavel write fResponsavel;
    property Email: String read fEmail write fEmail;
    property NroCNPJ: Integer read fNroCNPJ write fNroCNPJ;
    property ValorImplantacao: Double read fValorImplantacao write fValorImplantacao;
    property ValorMensalidade: Double read fValorMensalidade write fValorMensalidade;
    property Status: String read fStatus write fStatus;
    property RegimeTrib: String read fRegimeTrib write fRegimeTrib;
    property TipoAtiv: String read fTipoAtiv write fTipoAtiv;
    property Observacao: String read fObservacao write fObservacao;
    property Revenda: TACBrIMendesRevenda read GetRevenda;
  end; 

  { TACBrIMendesSaneamentoCabecalho }
  TACBrIMendesSaneamentoCabecalho = class(TACBrAPISchema)
  private
    fsugestao: String;
    famb: Integer;
    fcnpj: String;
    fdthr: TDateTime;
    ftransacao: String;
    fmensagem: String;
    fprodEnv: Integer;
    fprodRet: Integer;
    fprodNaoRet: Integer;
    fcomportamentosParceiro: String;
    fcomportamentosCliente: String;
    fversao: String;
    fduracao: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesSaneamentoCabecalho);

    property sugestao: String read fsugestao write fsugestao;
    property amb: Integer read famb write famb;
    property cnpj: String read fcnpj write fcnpj;
    property dthr: TDateTime read fdthr write fdthr;
    property transacao: String read ftransacao write ftransacao;
    property mensagem: String read fmensagem write fmensagem;
    property prodEnv: Integer read fprodEnv write fprodEnv;
    property prodRet: Integer read fprodRet write fprodRet;
    property prodNaoRet: Integer read fprodNaoRet write fprodNaoRet;
    property comportamentosParceiro: String read fcomportamentosParceiro write fcomportamentosParceiro;
    property comportamentosCliente: String read fcomportamentosCliente write fcomportamentosCliente;
    property versao: String read fversao write fversao;
    property duracao: String read fduracao write fduracao;
  end;

  { TACBrIMendesGrupoCBS }
  TACBrIMendesGrupoCBS = class(TACBrAPISchema)
  private
    fcClassTrib: String;
    fdescrcClassTrib: String;
    fcst: String;
    fdescrCST: String;
    faliquota: Double;
    freducao: Double;
    freducaoBaseCalculo: Double;
    fampLegal: String;
    fdtVigIni: TDateTime;
    fdtVigFin: TDateTime;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesGrupoCBS);

    property cClassTrib: String read fcClassTrib write fcClassTrib;
    property descrcClassTrib: String read fdescrcClassTrib write fdescrcClassTrib;
    property cst: String read fcst write fcst;
    property descrCST: String read fdescrCST write fdescrCST;
    property aliquota: Double read faliquota write faliquota;
    property reducao: Double read freducao write freducao;
    property reducaoBaseCalculo: Double read freducaoBaseCalculo write freducaoBaseCalculo;
    property ampLegal: String read fampLegal write fampLegal;
    property dtVigIni: TDateTime read fdtVigIni write fdtVigIni;
    property dtVigFin: TDateTime read fdtVigFin write fdtVigFin;
  end;

  TACBrIMendesGrupoPisCofins = class(TACBrAPISchema)
  private
    fcstEnt: String;
    fcstSai: String;
    faliqPis: Double;
    faliqCofins: Double;
    fnri: String;
    fampLegal: String;
    fredPis: Double;
    fredCofins: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesGrupoPisCofins);

    property cstEnt: String read fcstEnt write fcstEnt;
    property cstSai: String read fcstSai write fcstSai;
    property aliqPis: Double read faliqPis write faliqPis;
    property aliqCofins: Double read faliqCofins write faliqCofins;
    property nri: String read fnri write fnri;
    property ampLegal: String read fampLegal write fampLegal;
    property redPis: Double read fredPis write fredPis;
    property redCofins: Double read fredCofins write fredCofins;
  end;

  TACBrIMendesGrupoIPI = class(TACBrAPISchema)
  private
    fcstEnt: String;
    fcstSai: String;
    faliqipi: Double;
    fcodenq: String;
    fex: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesGrupoIPI);

    property cstEnt: String read fcstEnt write fcstEnt;
    property cstSai: String read fcstSai write fcstSai;
    property aliqipi: Double read faliqipi write faliqipi;
    property codenq: String read fcodenq write fcodenq;
    property ex: String read fex write fex;
  end;

  TACBrIMendesGrupoIBS = class(TACBrAPISchema)
  private
    fcClassTrib: String;
    fdescrcClassTrib: String;
    fcst: String;
    fdescrCST: String;
    fibsUF: Double;
    fibsMun: Double;
    freducaoaliqIBS: Double;
    freducaoBcIBS: Double;
    fampLegal: String;
    fdtVigIni: TDateTime;
    fdtVigFin: TDateTime;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesGrupoIBS);

    property cClassTrib: String read fcClassTrib write fcClassTrib;
    property descrcClassTrib: String read fdescrcClassTrib write fdescrcClassTrib;
    property cst: String read fcst write fcst;
    property descrCST: String read fdescrCST write fdescrCST;
    property ibsUF: Double read fibsUF write fibsUF;
    property ibsMun: Double read fibsMun write fibsMun;
    property reducaoaliqIBS: Double read freducaoaliqIBS write freducaoaliqIBS;
    property reducaoBcIBS: Double read freducaoBcIBS write freducaoBcIBS;
    property ampLegal: String read fampLegal write fampLegal;
    property dtVigIni: TDateTime read fdtVigIni write fdtVigIni;
    property dtVigFin: TDateTime read fdtVigFin write fdtVigFin;
  end;

  TACBrIMendesGrupoProtocolo = class(TACBrAPISchema)
  private
    fprotId: Integer;
    fprotNome: String;
    fdescricao: String;
    fdtVigIni: TDateTime;
    fdtVigFin: TDateTime;
    fisento: String;
    fantecipado: String;
    fsubsTrib: String;
    frespTrib: String;
    faliqIcmsInterestadual: Double;
    fredBcInterestadual: Double;
    faliqEfetiva: Double;
    fiva: Double;
    fdebitoPresumidoInter: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesGrupoProtocolo);

    property protId: Integer read fprotId write fprotId;
    property protNome: String read fprotNome write fprotNome;
    property descricao: String read fdescricao write fdescricao;
    property dtVigIni: TDateTime read fdtVigIni write fdtVigIni;
    property dtVigFin: TDateTime read fdtVigFin write fdtVigFin;
    property isento: String read fisento write fisento;
    property antecipado: String read fantecipado write fantecipado;
    property subsTrib: String read fsubsTrib write fsubsTrib;
    property respTrib: String read frespTrib write frespTrib;
    property aliqIcmsInterestadual: Double read faliqIcmsInterestadual write faliqIcmsInterestadual;
    property redBcInterestadual: Double read fredBcInterestadual write fredBcInterestadual;
    property aliqEfetiva: Double read faliqEfetiva write faliqEfetiva;
    property iva: Double read fiva write fiva;
    property debitoPresumidoInter: Double read fdebitoPresumidoInter write fdebitoPresumidoInter;
  end;

  TACBrIMendesGrupoCaracTrib = class(TACBrAPISchema)
  private
    fcodigo: String;
    fmunicipio: Integer;
    ffinalidade: String;
    fcodRegra: String;
    fcodExcecao: Integer;
    fdtVigIni: TDateTime;
    fdtVigFin: TDateTime;
    fcFOP: String;
    fcST: String;
    fcSOSN: String;
    faliqIcmsInterna: Double;
    faliqIcmsInterestadual: Double;
    freducaoBcIcms: Double;
    freducaoBcIcmsSt: Double;
    fredBcICMsInterestadual: Double;
    faliqIcmsSt: Double;
    fiVA: Double;
    fiVAAjust: Double;
    ffCP: Double;
    fcodBenef: String;
    fpDifer: Double;
    fpIsencao: Double;
    fantecipado: String;
    fdesonerado: String;
    fpICMSDeson: Double;
    fisento: String;
    findDeduzDeson: String;
    ftpCalcDifal: Integer;
    fdebitoPresumido: Double;
    fdebitoPresumidoNaoCredenciado: Double;
    fampLegal: String;
    fProtocolo: TACBrIMendesGrupoProtocolo;
    fregraGeral: String;
    fpSuspensaoImporatcao: Double;
    fregimeEspecial: String;
    fibs: TACBrIMendesGrupoIBS;
    function GetProtocolo: TACBrIMendesGrupoProtocolo;
    function GetIBS: TACBrIMendesGrupoIBS;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesGrupoCaracTrib);

    property codigo: String read fcodigo write fcodigo;
    property municipio: Integer read fmunicipio write fmunicipio;
    property finalidade: String read ffinalidade write ffinalidade;
    property codRegra: String read fcodRegra write fcodRegra;
    property codExcecao: Integer read fcodExcecao write fcodExcecao;
    property dtVigIni: TDateTime read fdtVigIni write fdtVigIni;
    property dtVigFin: TDateTime read fdtVigFin write fdtVigFin;
    property cFOP: String read fcFOP write fcFOP;
    property cST: String read fcST write fcST;
    property cSOSN: String read fcSOSN write fcSOSN;
    property aliqIcmsInterna: Double read faliqIcmsInterna write faliqIcmsInterna;
    property aliqIcmsInterestadual: Double read faliqIcmsInterestadual write faliqIcmsInterestadual;
    property reducaoBcIcms: Double read freducaoBcIcms write freducaoBcIcms;
    property reducaoBcIcmsSt: Double read freducaoBcIcmsSt write freducaoBcIcmsSt;
    property redBcICMsInterestadual: Double read fredBcICMsInterestadual write fredBcICMsInterestadual;
    property aliqIcmsSt: Double read faliqIcmsSt write faliqIcmsSt;
    property iVA: Double read fiVA write fiVA;
    property iVAAjust: Double read fiVAAjust write fiVAAjust;
    property fCP: Double read ffCP write ffCP;
    property codBenef: String read fcodBenef write fcodBenef;
    property pDifer: Double read fpDifer write fpDifer;
    property pIsencao: Double read fpIsencao write fpIsencao;
    property antecipado: String read fantecipado write fantecipado;
    property desonerado: String read fdesonerado write fdesonerado;
    property pICMSDeson: Double read fpICMSDeson write fpICMSDeson;
    property isento: String read fisento write fisento;
    property indDeduzDeson: String read findDeduzDeson write findDeduzDeson;
    property tpCalcDifal: Integer read ftpCalcDifal write ftpCalcDifal;
    property debitoPresumido: Double read fdebitoPresumido write fdebitoPresumido;
    property debitoPresumidoNaoCredenciado: Double read fdebitoPresumidoNaoCredenciado write fdebitoPresumidoNaoCredenciado;
    property ampLegal: String read fampLegal write fampLegal;
    property Protocolo: TACBrIMendesGrupoProtocolo read GetProtocolo;
    property regraGeral: String read fregraGeral write fregraGeral;
    property pSuspensaoImporatcao: Double read fpSuspensaoImporatcao write fpSuspensaoImporatcao;
    property regimeEspecial: String read fregimeEspecial write fregimeEspecial;
    property ibs: TACBrIMendesGrupoIBS read GetIBS;
  end;

  TACBrIMendesGrupoCaracTribs = class(TACBrAPISchemaArray)
  private
    function GetItem(AIndex: Integer): TACBrIMendesGrupoCaracTrib;
    procedure SetItem(AIndex: Integer; AValue: TACBrIMendesGrupoCaracTrib);
  public
    function New: TACBrIMendesGrupoCaracTrib;
    function NewSchema: TACBrAPISchema; override;
    function Add(AItem: TACBrIMendesGrupoCaracTrib): Integer;
    procedure Insert(AIndex: Integer; AItem: TACBrIMendesGrupoCaracTrib);
    property Items[AIndex: Integer]: TACBrIMendesGrupoCaracTrib read GetItem write SetItem; default;
  end;

  TACBrIMendesGrupoCFOP = class(TACBrAPISchema)
  private
    fcFOP: String;
    fCaracTrib: TACBrIMendesGrupoCaracTribs;
    function GetCaracTrib: TACBrIMendesGrupoCaracTribs;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesGrupoCFOP);

    property cFOP: String read fcFOP write fcFOP;
    property CaracTrib: TACBrIMendesGrupoCaracTribs read GetCaracTrib;
  end;

  TACBrIMendesGrupoUF = class(TACBrAPISchema)
  private
    fuF: String;
    fCFOP: TACBrIMendesGrupoCFOP;
    fmensagem: String;
    function GetCFOP: TACBrIMendesGrupoCFOP;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesGrupoUF);

    property uF: String read fuF write fuF;
    property CFOP: TACBrIMendesGrupoCFOP read GetCFOP;
    property mensagem: String read fmensagem write fmensagem;
  end;

  TACBrIMendesGrupoUFs = class(TACBrAPISchemaArray)
  private
    function GetItem(AIndex: Integer): TACBrIMendesGrupoUF;
    procedure SetItem(AIndex: Integer; AValue: TACBrIMendesGrupoUF);
  public
    function New: TACBrIMendesGrupoUF;
    function NewSchema: TACBrAPISchema; override;
    function Add(AItem: TACBrIMendesGrupoUF): Integer;
    procedure Insert(AIndex: Integer; AItem: TACBrIMendesGrupoUF);
    property Items[AIndex: Integer]: TACBrIMendesGrupoUF read GetItem write SetItem; default;
  end;

  TACBrIMendesGrupoRegra = class(TACBrAPISchema)
  private
    fuFs: TACBrIMendesGrupoUFs;
    function GetUFs: TACBrIMendesGrupoUFs;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesGrupoRegra);

    property uFs: TACBrIMendesGrupoUFs read GetUFs;
  end;

  TACBrIMendesGrupoRegras = class(TACBrAPISchemaArray)
  private
    function GetItem(AIndex: Integer): TACBrIMendesGrupoRegra;
    procedure SetItem(AIndex: Integer; AValue: TACBrIMendesGrupoRegra);
  public
    function New: TACBrIMendesGrupoRegra;
    function NewSchema: TACBrAPISchema; override;
    function Add(AItem: TACBrIMendesGrupoRegra): Integer;
    procedure Insert(AIndex: Integer; AItem: TACBrIMendesGrupoRegra);
    property Items[AIndex: Integer]: TACBrIMendesGrupoRegra read GetItem write SetItem; default;
  end;

  TACBrIMendesGrupo = class(TACBrAPISchema)
  private
    fcodigo: String;
    fdescricao: String;
    fnCM: String;
    fcEST: String;
    fdtVigIni: TDateTime;
    fdtVigFin: TDateTime;
    flista: String;
    ftipo: String;
    fcodAnp: String;
    fpassivelPMC: String;
    fimpostoImportacao: Double;
    fcbs: TACBrIMendesGrupoCBS;
    fpisCofins: TACBrIMendesGrupoPisCofins;
    fipi: TACBrIMendesGrupoIPI;
    fRegras: TACBrIMendesGrupoRegras;
    fprodEan: TStringList;
    fMensagem: String;
    function GetCBS: TACBrIMendesGrupoCBS;
    function GetPisCofins: TACBrIMendesGrupoPisCofins;
    function GetIPI: TACBrIMendesGrupoIPI;
    function GetRegras: TACBrIMendesGrupoRegras;
    function GetProdEan: TStringList;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesGrupo);

    property codigo: String read fcodigo write fcodigo;
    property descricao: String read fdescricao write fdescricao;
    property nCM: String read fnCM write fnCM;
    property cEST: String read fcEST write fcEST;
    property dtVigIni: TDateTime read fdtVigIni write fdtVigIni;
    property dtVigFin: TDateTime read fdtVigFin write fdtVigFin;
    property lista: String read flista write flista;
    property tipo: String read ftipo write ftipo;
    property codAnp: String read fcodAnp write fcodAnp;
    property passivelPMC: String read fpassivelPMC write fpassivelPMC;
    property impostoImportacao: Double read fimpostoImportacao write fimpostoImportacao;
    property cbs: TACBrIMendesGrupoCBS read GetCBS;
    property pisCofins: TACBrIMendesGrupoPisCofins read GetPisCofins;
    property iPI: TACBrIMendesGrupoIPI read GetIPI;
    property Regras: TACBrIMendesGrupoRegras read GetRegras;
    property prodEan: TStringList read GetProdEan;
    property Mensagem: String read fMensagem write fMensagem;
  end;

  TACBrIMendesGrupos = class(TACBrAPISchemaArray)
  private
    function GetItem(AIndex: Integer): TACBrIMendesGrupo;
    procedure SetItem(AIndex: Integer; AValue: TACBrIMendesGrupo);
  public
    function New: TACBrIMendesGrupo;
    function NewSchema: TACBrAPISchema; override;
    function Add(AItem: TACBrIMendesGrupo): Integer;
    procedure Insert(AIndex: Integer; AItem: TACBrIMendesGrupo);
    property Items[AIndex: Integer]: TACBrIMendesGrupo read GetItem write SetItem; default;
  end;

  { TACBrIMendesSaneamentoResponse }
  TACBrIMendesSaneamentoResponse = class(TACBrAPISchema)
  private
    fCabecalho: TACBrIMendesSaneamentoCabecalho;
    fGrupos: TACBrIMendesGrupos;
    function GetCabecalho: TACBrIMendesSaneamentoCabecalho;
    function GetGrupos: TACBrIMendesGrupos;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesSaneamentoResponse);

    property Cabecalho: TACBrIMendesSaneamentoCabecalho read GetCabecalho;
    property Grupos: TACBrIMendesGrupos read GetGrupos;
  end;

  { TACBrIMendesErro }
  TACBrIMendesErro = class(TACBrAPISchema)
  private
    fSucesso: Boolean;
    fMensagem: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesErro);

    property Sucesso: Boolean read fSucesso write fSucesso;
    property Mensagem: String read fMensagem write fMensagem;
  end;

  { TACBrIMendesRegimeEspecial }
  TACBrIMendesRegimeEspecial = class(TACBrAPISchema)
  private
    fCode: String;
    fDescription: String;
    fLegalBasis: String;
    fInitialValidity: TDateTime;
    fFinalValidity: TDateTime;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrIMendesRegimeEspecial);

    property Code: String read fCode write fCode;
    property Description: String read fDescription write fDescription;
    property LegalBasis: String read fLegalBasis write fLegalBasis;
    property InitialValidity: TDateTime read fInitialValidity write fInitialValidity;
    property FinalValidity: TDateTime read fFinalValidity write fFinalValidity;
  end;

  { TACBrIMendesRegimeEspecialList }
  TACBrIMendesRegimeEspecialList = class(TACBrAPISchemaArray)
  private
    function GetItem(AIndex: Integer): TACBrIMendesRegimeEspecial;
    procedure SetItem(AIndex: Integer; AValue: TACBrIMendesRegimeEspecial);
  public
    function New: TACBrIMendesRegimeEspecial;
    function NewSchema: TACBrAPISchema; override;
    function Add(ARegimeEspecial: TACBrIMendesRegimeEspecial): Integer;
    procedure Insert(AIndex: Integer; ARegimeEspecial: TACBrIMendesRegimeEspecial);
    property Items[AIndex: Integer]: TACBrIMendesRegimeEspecial read GetItem write SetItem; default;
  end;

  { TACBrIMendes }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrIMendes = class(TACBrHTTP)
  private
    fKey: String;
    fCNPJ: String;
    fToken: String;
    fSenha: AnsiString;
    fAmbiente: TACBrIMendesAmbiente;
    fRespostaErro: TACBrIMendesErro;
    fSaneamentoGradesRequest: TACBrIMendesGradesRequest;
    fSaneamentoGradesResponse: TACBrIMendesSaneamentoResponse;
    fHistoricoAcessoResponse: TACBrIMendesHistoricoResponse;
    fConsultarAlteradosResponse: TACBrIMendesConsultarResponse;
    fConsultarDescricaoResponse: TACBrIMendesConsultarResponse;
    fConsultarRegimeEspecialResponse: TACBrIMendesRegimeEspecialList;
    function GetConsultarAlteradosResponse: TACBrIMendesConsultarResponse;
    function GetConsultarRegimeEspecialResponse: TACBrIMendesRegimeEspecialList;
    function GetHistoricoAcessoResponse: TACBrIMendesHistoricoResponse;
    function GetSaneamentoGradesRequest: TACBrIMendesGradesRequest;
    function GetConsultarDescricaoResponse: TACBrIMendesConsultarResponse;
    function GetSaneamentoGradesResponse: TACBrIMendesSaneamentoResponse;
    function GetRespostaErro: TACBrIMendesErro;
    function GetSenha: AnsiString;
    function CalcularURL: String;
    procedure SetSenha(AValue: AnsiString);
    procedure ValidarConfiguracao;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear;
    procedure Autenticar;

    function SaneamentoGrades: Boolean;
    function ConsultarDescricao(const aDescricao: String; const aCNPJ: String = ''): Boolean;
    function ConsultarAlterados(const aUF: String; const aCNPJ: String = ''): Boolean;
    function ConsultarRegimesEspeciais(const aUF: String): Boolean;
    function HistoricoAcesso(const aCNPJ: String = ''): Boolean;

    property SaneamentoGradesRequest: TACBrIMendesGradesRequest read GetSaneamentoGradesRequest;
    property SaneamentoGradesResponse: TACBrIMendesSaneamentoResponse read GetSaneamentoGradesResponse;

    property ConsultarAlteradosResponse: TACBrIMendesConsultarResponse read GetConsultarAlteradosResponse;
    property ConsultarDescricaoResponse: TACBrIMendesConsultarResponse read GetConsultarDescricaoResponse;
    property ConsultarRegimeEspecialResponse: TACBrIMendesRegimeEspecialList read GetConsultarRegimeEspecialResponse;
    property HistoricoAcessoResponse: TACBrIMendesHistoricoResponse read GetHistoricoAcessoResponse;

    property RespostaErro: TACBrIMendesErro read GetRespostaErro;
  published
    property Ambiente: TACBrIMendesAmbiente read fAmbiente write fAmbiente;

    property CNPJ: String read fCNPJ write fCNPJ;
    property Senha: AnsiString read GetSenha write SetSenha;
  end;

implementation

uses
  StrUtils, synautil,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime;

{ TACBrIMendesCabecalho }

constructor TACBrIMendesCabecalho.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesCabecalho.Clear;
begin
  fUF := EmptyStr;
  fCNPJ := EmptyStr;
  fProdutosRetornados := 0;
  fMensagem := EmptyStr;
end;

procedure TACBrIMendesCabecalho.Assign(Source: TACBrIMendesCabecalho);
begin
  fUF := Source.UF;
  fCNPJ := Source.CNPJ;
  fProdutosRetornados := Source.ProdutosRetornados;
  fMensagem := Source.Mensagem;
end;

function TACBrIMendesCabecalho.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fUF) and
    EstaVazio(fCNPJ) and
    EstaZerado(fProdutosRetornados) and
    EstaVazio(fMensagem);
end;

procedure TACBrIMendesCabecalho.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('UF', fUF)
    .Value('CNPJ', fCNPJ)
    .Value('produtosRetornados', fProdutosRetornados)
    .Value('mensagem', fMensagem);
end;

procedure TACBrIMendesCabecalho.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesCabecalho) then
    Assign(TACBrIMendesCabecalho(aSource));
end;

procedure TACBrIMendesCabecalho.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('UF', fUF, False)
    .AddPair('CNPJ', fCNPJ)
    .AddPair('produtosRetornados', fProdutosRetornados)
    .AddPair('mensagem', fMensagem);
end;

{ TACBrIMendesProduto }

constructor TACBrIMendesProduto.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesProduto.Clear;
begin
  fId := EmptyStr;
  fDescricao := EmptyStr;
  fEan := EmptyStr;
  fNcm := EmptyStr;
  fCest := EmptyStr;
  fDescricaoGrupo := EmptyStr;
  fCodigo := EmptyStr;
  fCodInterno := EmptyStr;
  fCodImendes := EmptyStr;
  fImportado := EmptyStr;
  fEncontrado := False;
  fTipo := 0;
  fChaveRetorno := EmptyStr;
  fDtUltCons := 0;
  fDtRev := 0;
end;

procedure TACBrIMendesProduto.Assign(Source: TACBrIMendesProduto);
begin
  fId := Source.Id;
  fDescricao := Source.Descricao;
  fEan := Source.Ean;
  fNcm := Source.Ncm;
  fCest := Source.Cest;
  fDescricaoGrupo := Source.DescricaoGrupo;
  fCodigo := Source.Codigo;
  fCodInterno := Source.CodInterno;
  fCodImendes := Source.CodImendes;
  fImportado := Source.Importado;
  fEncontrado := Source.Encontrado;
  fTipo := Source.Tipo;
  fChaveRetorno := Source.ChaveRetorno;
  fDtUltCons := Source.DtUltCons;
  fDtRev := Source.DtRev;
end;

function TACBrIMendesProduto.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fId) and
    EstaVazio(fDescricao) and
    EstaVazio(fEan) and
    EstaVazio(fNcm) and
    EstaVazio(fCest) and
    EstaVazio(fDescricaoGrupo) and
    EstaVazio(fCodigo) and
    EstaVazio(fCodInterno) and
    EstaVazio(fCodImendes) and
    EstaVazio(fImportado) and
    (not fEncontrado) and
    EstaZerado(fTipo) and
    EstaVazio(fChaveRetorno) and
    EstaZerado(fDtUltCons) and
    EstaZerado(fDtRev);
end;

procedure TACBrIMendesProduto.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s1, s2: String;
begin
  {$IfDef FPC}
  s1 := EmptyStr;
  s2 := EmptyStr;
  {$EndIf}

  aJSon
    .Value('id', fId)
    .Value('descricao', fDescricao)
    .Value('ean', fEan)
    .Value('ncm', fNcm)
    .Value('cest', fCest)
    .Value('descricaoGrupo', fDescricaoGrupo)
    .Value('codigo', fCodigo)
    .Value('codInterno', fCodInterno)
    .Value('codImendes', fCodImendes)
    .Value('importado', fImportado)
    .Value('encontrado', fEncontrado)
    .Value('tipo', fTipo)
    .Value('chave_retorno', fChaveRetorno)
    .Value('dtultcons', s1)
    .Value('dtrev', s2);
  if NaoEstaVazio(s1) then
    fDtUltCons := StringToDateTimeDef(s1, 0, 'YYYY-MM-DD');
  if NaoEstaVazio(s2) then
    fDtRev := StringToDateTimeDef(s2, 0, 'YYYY-MM-DD');
end;

procedure TACBrIMendesProduto.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('id', fId, False)
    .AddPair('descricao', fDescricao)
    .AddPair('ean', fEan, False)
    .AddPair('ncm', fNcm)
    .AddPair('cest', fCest, False)
    .AddPair('descricaoGrupo', fDescricaoGrupo, False)
    .AddPair('codigo', fCodigo)
    .AddPair('codInterno', fCodInterno)
    .AddPair('codImendes', fCodImendes, False)
    .AddPair('importado', fImportado, False)
    .AddPair('encontrado', fEncontrado)
    .AddPair('tipo', fTipo, False)
    .AddPair('chave_retorno', fChaveRetorno, False)
    .AddPair('dtultcons', FormatDateBr(fDtUltCons, 'YYYY-MM-DD'))
    .AddPair('dtrev', FormatDateBr(fDtRev, 'YYYY-MM-DD'));
end;

procedure TACBrIMendesProduto.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesProduto) then
    Assign(TACBrIMendesProduto(aSource));
end;

{ TACBrIMendesProdutos }

function TACBrIMendesProdutos.New: TACBrIMendesProduto;
begin
  Result := TACBrIMendesProduto.Create;
  Add(Result);
end;

function TACBrIMendesProdutos.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrIMendesProdutos.Add(AProduto: TACBrIMendesProduto): Integer;
begin
  Result := inherited Add(AProduto);
end;

procedure TACBrIMendesProdutos.Insert(AIndex: Integer; AProduto: TACBrIMendesProduto);
begin
  inherited Insert(AIndex, AProduto);
end;

function TACBrIMendesProdutos.GetItem(AIndex: Integer): TACBrIMendesProduto;
begin
  Result := TACBrIMendesProduto(inherited Items[AIndex]);
end;

procedure TACBrIMendesProdutos.SetItem(AIndex: Integer; AValue: TACBrIMendesProduto);
begin
  inherited Items[AIndex] := AValue;
end;

{ TACBrIMendesConsultarResponse }

constructor TACBrIMendesConsultarResponse.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesConsultarResponse.Destroy;
begin
  if Assigned(fCabecalho) then
    fCabecalho.Free;
  if Assigned(fProdutos) then
    fProdutos.Free;
  inherited Destroy;
end;

procedure TACBrIMendesConsultarResponse.Clear;
begin
  if Assigned(fCabecalho) then
    fCabecalho.Clear;
  if Assigned(fProdutos) then
    fProdutos.Clear;
end;

function TACBrIMendesConsultarResponse.IsEmpty: Boolean;
begin
  Result :=
    (not Assigned(fCabecalho) or fCabecalho.IsEmpty) and
    (not Assigned(fProdutos) or fProdutos.IsEmpty);
end;

function TACBrIMendesConsultarResponse.GetCabecalho: TACBrIMendesCabecalho;
begin
  if not Assigned(fCabecalho) then
    fCabecalho := TACBrIMendesCabecalho.Create('cabecalho');
  Result := fCabecalho;
end;

function TACBrIMendesSaneamentoResponse.GetGrupos: TACBrIMendesGrupos;
begin
  if (not Assigned(fGrupos)) then
    fGrupos := TACBrIMendesGrupos.Create('Grupos');
  Result := fGrupos;
end;

function TACBrIMendesConsultarResponse.GetProdutos: TACBrIMendesProdutos;
begin
  if not Assigned(fProdutos) then
    fProdutos := TACBrIMendesProdutos.Create('produto');
  Result := fProdutos;
end;

procedure TACBrIMendesConsultarResponse.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  Cabecalho.ReadFromJSon(aJSon);
  Produtos.ReadFromJSon(aJSon);
end;

procedure TACBrIMendesConsultarResponse.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if Assigned(fCabecalho) then
    Cabecalho.WriteToJSon(aJSon);
  if Assigned(fProdutos) then
    Produtos.WriteToJSon(aJSon);
end;

procedure TACBrIMendesConsultarResponse.Assign(Source: TACBrIMendesConsultarResponse);
begin
  if Assigned(Source.Cabecalho) then
    Cabecalho.Assign(Source.Cabecalho);
  if Assigned(Source.Produtos) then
    Produtos.Assign(Source.Produtos);
end;

procedure TACBrIMendesConsultarResponse.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesConsultarResponse) then
    Assign(TACBrIMendesConsultarResponse(aSource));
end;

{ TACBrIMendesPortal }

constructor TACBrIMendesPortal.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesPortal.Clear;
begin
  fUserID := 0;
  fMethod := EmptyStr;
end;

function TACBrIMendesPortal.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fUserID) and
    EstaVazio(fMethod);
end;

procedure TACBrIMendesPortal.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('userID', fUserID)
    .Value('method', fMethod);
end;

procedure TACBrIMendesPortal.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('userID', fUserID)
    .AddPair('method', fMethod);
end;

procedure TACBrIMendesPortal.Assign(Source: TACBrIMendesPortal);
begin
  fUserID := Source.UserID;
  fMethod := Source.Method;
end;

procedure TACBrIMendesPortal.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesPortal) then
    Assign(TACBrIMendesPortal(aSource));
end;

{ TACBrIMendesEmitente }

constructor TACBrIMendesEmitente.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesEmitente.Destroy;
begin
  if Assigned(fportal) then
    fportal.Free;
  inherited Destroy;
end;

procedure TACBrIMendesEmitente.Clear;
begin
  famb := 0;
  fcnpj := EmptyStr;
  fcrt := 0;
  fregimeTrib := EmptyStr;
  fuf := EmptyStr;
  fmunicipio := 0;
  fcnae := EmptyStr;
  fsubstICMS := False;
  finterdependente := False;
  fcnaeSecundario := EmptyStr;
  fdia := 0;
  fmes := 0;
  fano := 0;
  fdataLimite := 0;
  fregimeEspecial := EmptyStr;
  if Assigned(fportal) then
    fportal.Clear;
end;

function TACBrIMendesEmitente.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(famb) and
    EstaVazio(fcnpj) and
    EstaZerado(fcrt) and
    EstaVazio(fregimeTrib) and
    EstaVazio(fuf) and
    EstaZerado(fmunicipio) and
    EstaVazio(fcnae) and
    (not fsubstICMS) and
    (not finterdependente) and
    EstaVazio(fcnaeSecundario) and
    EstaZerado(fdia) and
    EstaZerado(fmes) and
    EstaZerado(fano) and
    EstaZerado(fdataLimite) and
    EstaVazio(fregimeEspecial) and
    (not Assigned(fportal) or fportal.IsEmpty);
end;

function TACBrIMendesEmitente.GetPortal: TACBrIMendesPortal;
begin
  if not Assigned(fportal) then
    fportal := TACBrIMendesPortal.Create('portal');
  Result := fportal;
end;

procedure TACBrIMendesEmitente.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s1, s2, s3: String;
begin
  {$IfDef FPC}
  s1 := EmptyStr;
  s2 := EmptyStr;
  s3 := EmptyStr;
  {$EndIf}
  aJSon
    .Value('amb', famb)
    .Value('cnpj', fcnpj)
    .Value('crt', fcrt)
    .Value('regimeTrib', fregimeTrib)
    .Value('uf', fuf)
    .Value('municipio', fmunicipio)
    .Value('cnae', fcnae)
    .Value('substICMS', s1)
    .Value('interdependente', s2)
    .Value('cnaeSecundario', fcnaeSecundario)
    .Value('dia', fdia)
    .Value('mes', fmes)
    .Value('ano', fano)
    .Value('dataLimite', s3)
    .Value('regimeEspecial', fregimeEspecial);
  fsubstICMS := (s1 = 'S');
  finterdependente := (s2 = 'S');
  if NaoEstaVazio(s3) then
    fdataLimite := StringToDateTimeDef(s3, 0, 'YYYY-MM-DD');

  Portal.ReadFromJSon(aJSon);
end;

procedure TACBrIMendesEmitente.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('amb', famb)
    .AddPair('cnpj', fcnpj)
    .AddPair('crt', fcrt)
    .AddPair('regimeTrib', fregimeTrib)
    .AddPair('uf', fuf)
    .AddPair('municipio', fmunicipio)
    .AddPair('cnae', fcnae)
    .AddPair('substICMS', IfThen(fsubstICMS, 'S', 'N'))
    .AddPair('interdependente', IfThen(finterdependente, 'S', 'N'))
    .AddPair('cnaeSecundario', fcnaeSecundario)
    .AddPair('dia', fdia)
    .AddPair('mes', fmes)
    .AddPair('ano', fano)
    .AddPair('dataLimite', FormatDateBr(fdataLimite, 'YYYY-MM-DD'))
    .AddPair('regimeEspecial', fregimeEspecial);

  if Assigned(fportal) and (not fportal.IsEmpty) then
    fportal.WriteToJSon(aJSon);
end;

procedure TACBrIMendesEmitente.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesEmitente) then
    Assign(TACBrIMendesEmitente(aSource));
end;

procedure TACBrIMendesEmitente.Assign(Source: TACBrIMendesEmitente);
begin
  famb := Source.amb;
  fcnpj := Source.cnpj;
  fcrt := Source.crt;
  fregimeTrib := Source.regimeTrib;
  fuf := Source.uf;
  fmunicipio := Source.municipio;
  fcnae := Source.cnae;
  fsubstICMS := Source.substICMS;
  finterdependente := Source.interdependente;
  fcnaeSecundario := Source.cnaeSecundario;
  fdia := Source.dia;
  fmes := Source.mes;
  fano := Source.ano;
  fdataLimite := Source.dataLimite;
  fregimeEspecial := Source.regimeEspecial;
  if Assigned(Source.portal) then
    Portal.Assign(Source.portal);
end;

{ TACBrIMendesCaracTrib }

function TACBrIMendesCaracTrib.list: TStringList;
begin
  if (not Assigned(flist)) then
    flist := TStringList.Create;
  Result := flist;
end;

function TACBrIMendesCaracTrib.GetItem(Index: Integer): Integer;
begin
  Result := StrToInt(list[Index]);
end;

procedure TACBrIMendesCaracTrib.SetItem(Index: Integer; AValue: Integer);
begin
  list[Index] := IntToStr(AValue);
end;

destructor TACBrIMendesCaracTrib.Destroy;
begin
  if Assigned(flist) then
    flist.Free;
  inherited Destroy;
end;

function TACBrIMendesCaracTrib.Add(aItem: Integer): Integer;
begin
  Result := list.Add(IntToStr(aItem));
end;

function TACBrIMendesCaracTrib.Count: Integer;
begin
  Result := list.Count;
end;

procedure TACBrIMendesCaracTrib.Clear;
begin
  if Assigned(flist) then
    flist.Clear;
end;

{ TACBrIMendesPerfil }

constructor TACBrIMendesPerfil.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesPerfil.Destroy;
begin
  if Assigned(fuf) then
    fuf.Free;

  if Assigned(fcaracTrib) then
    fcaracTrib.Free;

  inherited Destroy;
end;

procedure TACBrIMendesPerfil.Clear;
begin
  if Assigned(fuf) then
    fuf.Clear;

  if Assigned(fcaracTrib)  then
    fcaracTrib.Clear;

  fcfop := EmptyStr;
  ffinalidade := 0;
  fsimplesN := EmptyStr;
  forigem := 0;
  substICMS := EmptyStr;
  fregimeTrib := EmptyStr;
  fprodZFM := EmptyStr;
  fregimeEspecial := EmptyStr;
  ffabricacaoPropria := False;
end;

function TACBrIMendesPerfil.IsEmpty: Boolean;
begin
  Result :=
    ((not Assigned(fcaracTrib)) or EstaZerado(fcaracTrib.Count)) and
    ((not Assigned(fuf)) or EstaZerado(fuf.Count)) and
    EstaVazio(fcfop) and
    EstaZerado(ffinalidade) and
    EstaVazio(fsimplesN) and
    EstaZerado(forigem) and
    EstaVazio(substICMS) and
    EstaVazio(fregimeTrib) and
    EstaVazio(fprodZFM) and
    EstaVazio(fregimeEspecial) and
    (not ffabricacaoPropria);
end;

function TACBrIMendesPerfil.GetUF: TStringList;
begin
  if (not Assigned(fuf)) then
    fuf := TStringList.Create;
  Result := fuf;
end;

function TACBrIMendesPerfil.GetCaracTrib: TACBrIMendesCaracTrib;
begin
  if (not Assigned(fcaracTrib)) then
    fcaracTrib := TACBrIMendesCaracTrib.Create;
  Result := fcaracTrib;
end;

procedure TACBrIMendesPerfil.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  i: Integer;
  ja: TACBrJSONArray;
begin
  Clear;
  aJSon
    .Value('cfop', fcfop)
    .Value('finalidade', ffinalidade)
    .Value('simplesN', fsimplesN)
    .Value('origem', forigem)
    .Value('substICMS', fsubstICMS)
    .Value('regimeTrib', fregimeTrib)
    .Value('prodZFM', fprodZFM)
    .Value('regimeEspecial', fregimeEspecial)
    .Value('fabricacaoPropria', ffabricacaoPropria);

  if aJSon.IsJSONArray('uf') then
  begin
    ja := aJSon.AsJSONArray['uf'];
    for i := 0 to ja.Count - 1 do
      uf.Add(ja.Items[i]);
  end;

  if aJSon.IsJSONArray('caracTrib') then
  begin
    ja := aJSon.AsJSONArray['caracTrib'];
    for i := 0 to ja.Count - 1 do
      caracTrib.Add(StrToIntDef(ja.Items[i], 0));
  end;
end;

procedure TACBrIMendesPerfil.DoWriteToJSon(aJSon: TACBrJSONObject);
var
  ja, ja2: TACBrJSONArray;
  i: Integer;
begin
  aJSon
    .AddPair('cfop', fcfop)
    .AddPair('finalidade', ffinalidade)
    .AddPair('simplesN', fsimplesN)
    .AddPair('origem', forigem)
    .AddPair('substICMS', substICMS)
    .AddPair('regimeTrib', fregimeTrib)
    .AddPair('prodZFM', fprodZFM)
    .AddPair('regimeEspecial', fregimeEspecial)
    .AddPair('fabricacaoPropria', ffabricacaoPropria);

  if Assigned(fcaracTrib) and NaoEstaZerado(fcaracTrib.Count) then
  begin
    ja2 := TACBrJSONArray.Create;
    for i := 0 to fcaracTrib.Count - 1 do
      ja2.AddElement(fcaracTrib[i]);

    aJSon.AddPair('caracTrib', ja2);
  end;

  if Assigned(fuf) and NaoEstaZerado(fuf.Count) then
  begin
    ja := TACBrJSONArray.Create;
    for i := 0 to fuf.Count - 1 do
      ja.AddElement(fuf[i]);

    aJSon.AddPair('uf', ja);
  end;
end;

procedure TACBrIMendesPerfil.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesPerfil) then
    Assign(TACBrIMendesPerfil(aSource));
end;

procedure TACBrIMendesPerfil.Assign(Source: TACBrIMendesPerfil);
begin
  fuf.Assign(Source.uf);
  fcfop := Source.cfop;
  ffinalidade := Source.finalidade;
  fsimplesN := Source.simplesN;
  forigem := Source.origem;
  substICMS := Source.substICMS;
  fregimeTrib := Source.regimeTrib;
  fprodZFM := Source.prodZFM;
  fregimeEspecial := Source.regimeEspecial;
  ffabricacaoPropria := Source.fabricacaoPropria;
  fcaracTrib := Source.caracTrib;
end;

{ TACBrIMendesGradesRequest }

constructor TACBrIMendesGradesRequest.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesGradesRequest.Destroy;
begin
  if Assigned(femit) then
    femit.Free;
  if Assigned(fperfil) then
    fperfil.Free;
  if Assigned(fprodutos) then
    fprodutos.Free;
  inherited Destroy;
end;

procedure TACBrIMendesGradesRequest.Clear;
begin
  if Assigned(femit) then
    femit.Clear;
  if Assigned(fperfil) then
    fperfil.Clear;
  if Assigned(fprodutos) then
    fprodutos.Clear;
end;

function TACBrIMendesGradesRequest.IsEmpty: Boolean;
begin
  Result :=
    (not Assigned(femit) or femit.IsEmpty) and
    (not Assigned(fperfil) or fperfil.IsEmpty) and
    (not Assigned(fprodutos) or fprodutos.IsEmpty);
end;

function TACBrIMendesGradesRequest.GetEmit: TACBrIMendesEmitente;
begin
  if not Assigned(femit) then
    femit := TACBrIMendesEmitente.Create('emit');
  Result := femit;
end;

function TACBrIMendesGradesRequest.GetPerfil: TACBrIMendesPerfil;
begin
  if not Assigned(fperfil) then
    fperfil := TACBrIMendesPerfil.Create('perfil');
  Result := fperfil;
end;

function TACBrIMendesGradesRequest.GetProdutos: TACBrIMendesProdutos;
begin
  if not Assigned(fprodutos) then
    fprodutos := TACBrIMendesProdutos.Create('produtos');
  Result := fprodutos;
end;

procedure TACBrIMendesGradesRequest.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  emit.ReadFromJSon(aJSon);
  perfil.ReadFromJSon(aJSon);
  produtos.ReadFromJSon(aJSon);
end;

procedure TACBrIMendesGradesRequest.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if Assigned(femit) and (not femit.IsEmpty) then
    femit.WriteToJSon(aJSon);
  if Assigned(fperfil) and (not fperfil.IsEmpty) then
    fperfil.WriteToJSon(aJSon);
  if Assigned(fprodutos) and (not fprodutos.IsEmpty) then
    fprodutos.WriteToJSon(aJSon);
end;

procedure TACBrIMendesGradesRequest.Assign(Source: TACBrIMendesGradesRequest);
begin
  if Assigned(Source.emit) then
    emit.Assign(Source.emit);
  if Assigned(Source.perfil) then
    perfil.Assign(Source.perfil);
  if Assigned(Source.produtos) then
    produtos.Assign(Source.produtos);
end;

procedure TACBrIMendesGradesRequest.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGradesRequest) then
    Assign(TACBrIMendesGradesRequest(aSource));
end;

{ TACBrIMendesResumo }

constructor TACBrIMendesResumo.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesResumo.Clear;
begin
  fDataPrimeiroConsumo := 0;
  fDataUltimoConsumo := 0;
  fProdutosPendentes_Interno := 0;
  fProdutosPendentes_EAN := 0;
  fProdutosPendentes_Devolvidos := 0;
  fProdutosPendentes_DataInicio := 0;
end;

function TACBrIMendesResumo.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fDataPrimeiroConsumo) and
    EstaZerado(fDataUltimoConsumo) and
    EstaZerado(fProdutosPendentes_Interno) and
    EstaZerado(fProdutosPendentes_EAN) and
    EstaZerado(fProdutosPendentes_Devolvidos) and
    EstaZerado(fProdutosPendentes_DataInicio);
end;

procedure TACBrIMendesResumo.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s1, s2, s3: String;
begin
  {$IfDef FPC}
  s1 := EmptyStr;
  s2 := EmptyStr;
  s3 := EmptyStr;
  {$EndIf}

  aJSon
    .Value('dataPrimeiroConsumo', s1)
    .Value('dataUltimoConsumo', s2)
    .Value('produtosPendentes_Interno', fProdutosPendentes_Interno)
    .Value('produtosPendentes_EAN', fProdutosPendentes_EAN)
    .Value('produtosPendentes_Devolvidos', fProdutosPendentes_Devolvidos)
    .Value('produtosPendentes_DataInicio', s3);
  if NaoEstaVazio(s1) then
    fDataPrimeiroConsumo := StringToDateTimeDef(s1, 0, 'YYYY-MM-DD');
  if NaoEstaVazio(s2) then
    fDataUltimoConsumo := StringToDateTimeDef(s2, 0, 'YYYY-MM-DD');
  if NaoEstaVazio(s3) then
    fProdutosPendentes_DataInicio := StringToDateTimeDef(s3, 0, 'YYYY-MM-DD');
end;

procedure TACBrIMendesResumo.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('dataPrimeiroConsumo', FormatDateBr(fDataPrimeiroConsumo, 'YYYY-MM-DD'), False)
    .AddPair('dataUltimoConsumo', FormatDateBr(fDataUltimoConsumo, 'YYYY-MM-DD'), False)
    .AddPair('produtosPendentes_Interno', fProdutosPendentes_Interno)
    .AddPair('produtosPendentes_EAN', fProdutosPendentes_EAN)
    .AddPair('produtosPendentes_Devolvidos', fProdutosPendentes_Devolvidos)
    .AddPair('produtosPendentes_DataInicio', FormatDateBr(fProdutosPendentes_DataInicio, 'YYYY-MM-DD'), False);
end;

procedure TACBrIMendesResumo.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesResumo) then
    Assign(TACBrIMendesResumo(aSource));
end;

procedure TACBrIMendesResumo.Assign(Source: TACBrIMendesResumo);
begin
  fDataPrimeiroConsumo := Source.DataPrimeiroConsumo;
  fDataUltimoConsumo := Source.DataUltimoConsumo;
  fProdutosPendentes_Interno := Source.ProdutosPendentes_Interno;
  fProdutosPendentes_EAN := Source.ProdutosPendentes_EAN;
  fProdutosPendentes_Devolvidos := Source.ProdutosPendentes_Devolvidos;
  fProdutosPendentes_DataInicio := Source.ProdutosPendentes_DataInicio;
end;

{ TACBrIMendesHistoricoResponse }

constructor TACBrIMendesHistoricoResponse.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesHistoricoResponse.Destroy;
begin
  if Assigned(fResumo) then
    fResumo.Free;
  if Assigned(fProdDevolvidos) then
    fProdDevolvidos.Free;
  inherited Destroy;
end;

procedure TACBrIMendesHistoricoResponse.Clear;
begin
  if Assigned(fResumo) then
    fResumo.Clear;
  if Assigned(fProdDevolvidos) then
    fProdDevolvidos.Clear;
end;

function TACBrIMendesHistoricoResponse.IsEmpty: Boolean;
begin
  Result :=
    (not Assigned(fResumo) or fResumo.IsEmpty) and
    (not Assigned(fProdDevolvidos) or fProdDevolvidos.IsEmpty);
end;

function TACBrIMendesHistoricoResponse.GetResumo: TACBrIMendesResumo;
begin
  if not Assigned(fResumo) then
    fResumo := TACBrIMendesResumo.Create('resumo');
  Result := fResumo;
end;

function TACBrIMendesHistoricoResponse.GetProdDevolvidos: TACBrIMendesProdutos;
begin
  if not Assigned(fProdDevolvidos) then
    fProdDevolvidos := TACBrIMendesProdutos.Create('prodDevolvidos');
  Result := fProdDevolvidos;
end;

procedure TACBrIMendesHistoricoResponse.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  Resumo.ReadFromJSon(aJSon);
  ProdDevolvidos.ReadFromJSon(aJSon);
end;

procedure TACBrIMendesHistoricoResponse.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if Assigned(fResumo) and (not fResumo.IsEmpty) then
    fResumo.WriteToJSon(aJSon);
  if Assigned(fProdDevolvidos) and (not fProdDevolvidos.IsEmpty) then
    fProdDevolvidos.WriteToJSon(aJSon);
end;

procedure TACBrIMendesHistoricoResponse.Assign(Source: TACBrIMendesHistoricoResponse);
begin
  if Assigned(Source.Resumo) then
    Resumo.Assign(Source.Resumo);
  if Assigned(Source.ProdDevolvidos) then
    ProdDevolvidos.Assign(Source.ProdDevolvidos);
end;

procedure TACBrIMendesHistoricoResponse.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesHistoricoResponse) then
    Assign(TACBrIMendesHistoricoResponse(aSource));
end;

{ TACBrIMendesRevenda }

constructor TACBrIMendesRevenda.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesRevenda.Clear;
begin
  fCNPJCPF := EmptyStr;
  fNome := EmptyStr;
  fFone := EmptyStr;
  fEmail := EmptyStr;
end;

function TACBrIMendesRevenda.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fCNPJCPF) and
    EstaVazio(fNome) and
    EstaVazio(fFone) and
    EstaVazio(fEmail);
end;

procedure TACBrIMendesRevenda.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('cnpjcpf', fCNPJCPF)
    .Value('nome', fNome)
    .Value('fone', fFone)
    .Value('email', fEmail);
end;

procedure TACBrIMendesRevenda.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('cnpjcpf', fCNPJCPF)
    .AddPair('nome', fNome)
    .AddPair('fone', fFone)
    .AddPair('email', fEmail);
end;

procedure TACBrIMendesRevenda.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesRevenda) then
    Assign(TACBrIMendesRevenda(aSource));
end;

procedure TACBrIMendesRevenda.Assign(Source: TACBrIMendesRevenda);
begin
  fCNPJCPF := Source.CNPJCPF;
  fNome := Source.Nome;
  fFone := Source.Fone;
  fEmail := Source.Email;
end;

{ TACBrIMendesCliente }

constructor TACBrIMendesCliente.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesCliente.Destroy;
begin
  if Assigned(fRevenda) then
    fRevenda.Free;
  inherited Destroy;
end;

procedure TACBrIMendesCliente.Clear;
begin
  fCNPJCPF := EmptyStr;
  fRazaoSocial := EmptyStr;
  fEndereco := EmptyStr;
  fNro := EmptyStr;
  fBairro := EmptyStr;
  fCidade := EmptyStr;
  fUF := EmptyStr;
  fCEP := EmptyStr;
  fFone := EmptyStr;
  fResponsavel := EmptyStr;
  fEmail := EmptyStr;
  fNroCNPJ := 0;
  fValorImplantacao := 0;
  fValorMensalidade := 0;
  fStatus := EmptyStr;
  fRegimeTrib := EmptyStr;
  fTipoAtiv := EmptyStr;
  fObservacao := EmptyStr;
  if Assigned(fRevenda) then
    fRevenda.Clear;
end;

function TACBrIMendesCliente.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fCNPJCPF) and
    EstaVazio(fRazaoSocial) and
    EstaVazio(fEndereco) and
    EstaVazio(fNro) and
    EstaVazio(fBairro) and
    EstaVazio(fCidade) and
    EstaVazio(fUF) and
    EstaVazio(fCEP) and
    EstaVazio(fFone) and
    EstaVazio(fResponsavel) and
    EstaVazio(fEmail) and
    EstaZerado(fNroCNPJ) and
    EstaZerado(fValorImplantacao) and
    EstaZerado(fValorMensalidade) and
    EstaVazio(fStatus) and
    EstaVazio(fRegimeTrib) and
    EstaVazio(fTipoAtiv) and
    EstaVazio(fObservacao) and
    (not Assigned(fRevenda) or fRevenda.IsEmpty);
end;

function TACBrIMendesCliente.GetRevenda: TACBrIMendesRevenda;
begin
  if not Assigned(fRevenda) then
    fRevenda := TACBrIMendesRevenda.Create('revenda');
  Result := fRevenda;
end;

procedure TACBrIMendesCliente.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('cnpjcpf', fCNPJCPF)
    .Value('razaosocial', fRazaoSocial)
    .Value('endereco', fEndereco)
    .Value('nro', fNro)
    .Value('bairro', fBairro)
    .Value('cidade', fCidade)
    .Value('uf', fUF)
    .Value('cep', fCEP)
    .Value('fone', fFone)
    .Value('responsavel', fResponsavel)
    .Value('email', fEmail)
    .Value('nro_cnpj', fNroCNPJ)
    .Value('valorimplantacao', fValorImplantacao)
    .Value('valormensalidade', fValorMensalidade)
    .Value('status', fStatus)
    .Value('regimeTrib', fRegimeTrib)
    .Value('tipoAtiv', fTipoAtiv)
    .Value('observacao', fObservacao);
  Revenda.ReadFromJSon(aJSon);
end;

procedure TACBrIMendesCliente.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('cnpjcpf', fCNPJCPF)
    .AddPair('razaosocial', fRazaoSocial)
    .AddPair('endereco', fEndereco)
    .AddPair('nro', fNro)
    .AddPair('bairro', fBairro)
    .AddPair('cidade', fCidade)
    .AddPair('uf', fUF)
    .AddPair('cep', fCEP)
    .AddPair('fone', fFone)
    .AddPair('responsavel', fResponsavel)
    .AddPair('email', fEmail)
    .AddPair('nro_cnpj', fNroCNPJ)
    .AddPair('valorimplantacao', fValorImplantacao)
    .AddPair('valormensalidade', fValorMensalidade)
    .AddPair('status', fStatus)
    .AddPair('regimeTrib', fRegimeTrib)
    .AddPair('tipoAtiv', fTipoAtiv)
    .AddPair('observacao', fObservacao);
  if Assigned(fRevenda) and (not fRevenda.IsEmpty) then
    fRevenda.WriteToJSon(aJSon);
end;

procedure TACBrIMendesCliente.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesCliente) then
    Assign(TACBrIMendesCliente(aSource));
end;

procedure TACBrIMendesCliente.Assign(Source: TACBrIMendesCliente);
begin
  fCNPJCPF := Source.CNPJCPF;
  fRazaoSocial := Source.RazaoSocial;
  fEndereco := Source.Endereco;
  fNro := Source.Nro;
  fBairro := Source.Bairro;
  fCidade := Source.Cidade;
  fUF := Source.UF;
  fCEP := Source.CEP;
  fFone := Source.Fone;
  fResponsavel := Source.Responsavel;
  fEmail := Source.Email;
  fNroCNPJ := Source.NroCNPJ;
  fValorImplantacao := Source.ValorImplantacao;
  fValorMensalidade := Source.ValorMensalidade;
  fStatus := Source.Status;
  fRegimeTrib := Source.RegimeTrib;
  fTipoAtiv := Source.TipoAtiv;
  fObservacao := Source.Observacao;
  if Assigned(Source.Revenda) then
    Revenda.Assign(Source.Revenda);
end;

{ TACBrIMendesSaneamentoCabecalho }

procedure TACBrIMendesSaneamentoCabecalho.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesSaneamentoCabecalho) then
    Assign(TACBrIMendesSaneamentoCabecalho(aSource));
end;

procedure TACBrIMendesSaneamentoCabecalho.DoWriteToJSon(aJSon: TACBrJSONObject);
var
  jCab: TACBrJSONObject;
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('sugestao', fsugestao, False)
    .AddPair('amb', famb)
    .AddPair('cnpj', fcnpj, False)
    .AddPairISODateTime('dthr', fdthr, False)
    .AddPair('transacao', ftransacao, False)
    .AddPair('mensagem', fmensagem, False)
    .AddPair('prodEnv', fprodEnv)
    .AddPair('prodRet', fprodRet)
    .AddPair('prodNaoRet', fprodNaoRet)
    .AddPair('comportamentosParceiro', fcomportamentosParceiro, False)
    .AddPair('comportamentosCliente', fcomportamentosCliente, False)
    .AddPair('versao', fversao, False)
    .AddPair('duracao', fduracao, False);
end;

procedure TACBrIMendesSaneamentoCabecalho.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s: String;
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('sugestao', fsugestao)
    .Value('amb', famb)
    .Value('cnpj', fcnpj)
    .Value('dthr', s)
    .Value('transacao', ftransacao)
    .Value('mensagem', fmensagem)
    .Value('prodEnv', fprodEnv)
    .Value('prodRet', fprodRet)
    .Value('prodNaoRet', fprodNaoRet)
    .Value('comportamentosParceiro', fcomportamentosParceiro)
    .Value('comportamentosCliente', fcomportamentosCliente)
    .Value('versao', fversao)
    .Value('duracao', fduracao);

  if NaoEstaVazio(s) then
    fdthr := Iso8601ToDateTime(s);
end;

procedure TACBrIMendesSaneamentoCabecalho.Clear;
begin
  fsugestao := EmptyStr;
  famb := 0;
  fcnpj := EmptyStr;
  fdthr := 0;
  ftransacao := EmptyStr;
  fmensagem := EmptyStr;
  fprodEnv := 0;
  fprodRet := 0;
  fprodNaoRet := 0;
  fcomportamentosParceiro := EmptyStr;
  fcomportamentosCliente := EmptyStr;
  fversao := EmptyStr;
  fduracao := EmptyStr;
end;

function TACBrIMendesSaneamentoCabecalho.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fsugestao) and
    EstaZerado(famb) and
    EstaVazio(fcnpj) and
    EstaZerado(fdthr) and
    EstaVazio(ftransacao) and
    EstaVazio(fmensagem) and
    EstaZerado(fprodEnv) and
    EstaZerado(fprodRet) and
    EstaZerado(fprodNaoRet) and
    EstaVazio(fcomportamentosParceiro) and
    EstaVazio(fcomportamentosCliente) and
    EstaVazio(fversao) and
    EstaVazio(fduracao);
end;

procedure TACBrIMendesSaneamentoCabecalho.Assign(Source: TACBrIMendesSaneamentoCabecalho);
begin
  if not Assigned(Source) then
    Exit;

  fsugestao := Source.sugestao;
  famb := Source.amb;
  fcnpj := Source.cnpj;
  fdthr := Source.dthr;
  ftransacao := Source.transacao;
  fmensagem := Source.mensagem;
  fprodEnv := Source.prodEnv;
  fprodRet := Source.prodRet;
  fprodNaoRet := Source.prodNaoRet;
  fcomportamentosParceiro := Source.comportamentosParceiro;
  fcomportamentosCliente := Source.comportamentosCliente;
  fversao := Source.versao;
  fduracao := Source.duracao;
end;

{ TACBrIMendesSaneamentoResponse }

function TACBrIMendesSaneamentoResponse.GetCabecalho: TACBrIMendesSaneamentoCabecalho;
begin
  if (not Assigned(fCabecalho)) then
    fCabecalho := TACBrIMendesSaneamentoCabecalho.Create('Cabecalho');
  Result := fCabecalho;
end;

procedure TACBrIMendesSaneamentoResponse.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesSaneamentoResponse) then
    Assign(TACBrIMendesSaneamentoResponse(aSource));
end;

procedure TACBrIMendesSaneamentoResponse.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if (not Assigned(aJSon)) then
    Exit;

  if Assigned(fCabecalho) then
    fCabecalho.WriteToJSon(aJSon);
  if Assigned(fGrupos) then
    fGrupos.WriteToJSon(aJSon);
end;

procedure TACBrIMendesSaneamentoResponse.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if (not Assigned(aJSon)) then
    Exit;

  Cabecalho.ReadFromJSon(aJSon);
  Grupos.ReadFromJSon(aJSon);
end;

constructor TACBrIMendesSaneamentoResponse.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesSaneamentoResponse.Clear;
begin
  if Assigned(fCabecalho) then
    fCabecalho.Clear;
  if Assigned(fGrupos) then
    fGrupos.Clear;
end;

function TACBrIMendesSaneamentoResponse.IsEmpty: Boolean;
begin
  Result := ((not Assigned(fCabecalho)) or fCabecalho.IsEmpty) and 
            ((not Assigned(fGrupos)) or fGrupos.IsEmpty);
end;

procedure TACBrIMendesSaneamentoResponse.Assign(Source: TACBrIMendesSaneamentoResponse);
begin
  Cabecalho.Assign(Source.Cabecalho);
  Grupos.Assign(Source.Grupos);
end;

{ TACBrIMendesErro }

constructor TACBrIMendesErro.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesErro.Clear;
begin
  fSucesso := False;
  fMensagem := EmptyStr;
end;

function TACBrIMendesErro.IsEmpty: Boolean;
begin
  Result :=
    (not fSucesso) and
    EstaVazio(fMensagem);
end;

procedure TACBrIMendesErro.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('sucesso', fSucesso)
    .Value('mensagem', fMensagem);
end;

procedure TACBrIMendesErro.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('sucesso', fSucesso)
    .AddPair('mensagem', fMensagem);
end;

procedure TACBrIMendesErro.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesErro) then
    Assign(TACBrIMendesErro(aSource));
end;

procedure TACBrIMendesErro.Assign(Source: TACBrIMendesErro);
begin
  fSucesso := Source.Sucesso;
  fMensagem := Source.Mensagem;
end;

{ TACBrIMendesRegimeEspecial }

constructor TACBrIMendesRegimeEspecial.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesRegimeEspecial.Clear;
begin
  fCode := EmptyStr;
  fDescription := EmptyStr;
  fLegalBasis := EmptyStr;
  fInitialValidity := 0;
  fFinalValidity := 0;
end;

function TACBrIMendesRegimeEspecial.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fCode) and
    EstaVazio(fDescription) and
    EstaVazio(fLegalBasis) and
    EstaZerado(fInitialValidity) and
    EstaZerado(fFinalValidity);
end;

procedure TACBrIMendesRegimeEspecial.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s1, s2: String;
begin
  {$IfDef FPC}
  s1 := EmptyStr;
  s2 := EmptyStr;
  {$EndIf}
  aJSon
    .Value('code', fCode)
    .Value('description', fDescription)
    .Value('legalBasis', fLegalBasis)
    .Value('initialValidity', s1)
    .Value('finalValidity', s2);
  if NaoEstaVazio(s1) then
    fInitialValidity := StringToDateTimeDef(s1, 0, 'DD-MM-YYYY');
  if NaoEstaVazio(s2) then
    fFinalValidity := StringToDateTimeDef(s2, 0, 'DD-MM-YYYY');
end;

procedure TACBrIMendesRegimeEspecial.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('code', fCode)
    .AddPair('description', fDescription)
    .AddPair('legalBasis', fLegalBasis)
    .AddPair('initialValidity', FormatDateBr(fInitialValidity, 'DD-MM-YYYY'), False)
    .AddPair('finalValidity', FormatDateBr(fFinalValidity, 'DD-MM-YYYY'), False);
end;

procedure TACBrIMendesRegimeEspecial.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesRegimeEspecial) then
    Assign(TACBrIMendesRegimeEspecial(aSource));
end;

procedure TACBrIMendesRegimeEspecial.Assign(Source: TACBrIMendesRegimeEspecial);
begin
  fCode := Source.Code;
  fDescription := Source.Description;
  fLegalBasis := Source.LegalBasis;
  fInitialValidity := Source.InitialValidity;
  fFinalValidity := Source.FinalValidity;
end;

{ TACBrIMendesRegimeEspecialList }

function TACBrIMendesRegimeEspecialList.New: TACBrIMendesRegimeEspecial;
begin
  Result := TACBrIMendesRegimeEspecial.Create;
  Add(Result);
end;

{ TACBrIMendesGrupoCBS }

constructor TACBrIMendesGrupoCBS.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesGrupoCBS.Clear;
begin
  fcClassTrib := EmptyStr;
  fdescrcClassTrib := EmptyStr;
  fcst := EmptyStr;
  fdescrCST := EmptyStr;
  faliquota := 0;
  freducao := 0;
  freducaoBaseCalculo := 0;
  fampLegal := EmptyStr;
  fdtVigIni := 0;
  fdtVigFin := 0;
end;

function TACBrIMendesGrupoCBS.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcClassTrib) and
    EstaVazio(fdescrcClassTrib) and
    EstaVazio(fcst) and
    EstaVazio(fdescrCST) and
    EstaZerado(faliquota) and
    EstaZerado(freducao) and
    EstaZerado(freducaoBaseCalculo) and
    EstaVazio(fampLegal) and
    EstaZerado(fdtVigIni) and
    EstaZerado(fdtVigFin);
end;

procedure TACBrIMendesGrupoCBS.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s1, s2: String;
begin
  {$IfDef FPC}
  s1 := EmptyStr;
  s2 := EmptyStr;
  {$EndIf}
  aJSon
    .Value('cClassTrib', fcClassTrib)
    .Value('descrcClassTrib', fdescrcClassTrib)
    .Value('cst', fcst)
    .Value('descrCST', fdescrCST)
    .Value('aliquota', faliquota)
    .Value('reducao', freducao)
    .Value('reducaoBaseCalculo', freducaoBaseCalculo)
    .Value('ampLegal', fampLegal)
    .Value('dtVigIni', s1)
    .Value('dtVigFin', s2);
  if NaoEstaVazio(s1) then
    fdtVigIni := StringToDateTimeDef(s1, 0, 'DD/MM/YYYY');
  if NaoEstaVazio(s2) then
    fdtVigFin := StringToDateTimeDef(s2, 0, 'DD/MM/YYYY');
end;

procedure TACBrIMendesGrupoCBS.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('cClassTrib', fcClassTrib, False)
    .AddPair('descrcClassTrib', fdescrcClassTrib, False)
    .AddPair('cst', fcst, False)
    .AddPair('descrCST', fdescrCST, False)
    .AddPair('aliquota', faliquota)
    .AddPair('reducao', freducao)
    .AddPair('reducaoBaseCalculo', freducaoBaseCalculo)
    .AddPair('ampLegal', fampLegal, False)
    .AddPair('dtVigIni', FormatDateBr(fdtVigIni, 'DD/MM/YYYY'), False)
    .AddPair('dtVigFin', FormatDateBr(fdtVigFin, 'DD/MM/YYYY'), False);
end;

procedure TACBrIMendesGrupoCBS.Assign(Source: TACBrIMendesGrupoCBS);
begin
  fcClassTrib := Source.cClassTrib;
  fdescrcClassTrib := Source.descrcClassTrib;
  fcst := Source.cst;
  fdescrCST := Source.descrCST;
  faliquota := Source.aliquota;
  freducao := Source.reducao;
  freducaoBaseCalculo := Source.reducaoBaseCalculo;
  fampLegal := Source.ampLegal;
  fdtVigIni := Source.dtVigIni;
  fdtVigFin := Source.dtVigFin;
end;

procedure TACBrIMendesGrupoCBS.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGrupoCBS) then
    Assign(TACBrIMendesGrupoCBS(aSource));
end;

{ TACBrIMendesGrupoPisCofins }

constructor TACBrIMendesGrupoPisCofins.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesGrupoPisCofins.Clear;
begin
  fcstEnt := EmptyStr;
  fcstSai := EmptyStr;
  faliqPis := 0;
  faliqCofins := 0;
  fnri := EmptyStr;
  fampLegal := EmptyStr;
  fredPis := 0;
  fredCofins := 0;
end;

function TACBrIMendesGrupoPisCofins.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcstEnt) and
    EstaVazio(fcstSai) and
    EstaZerado(faliqPis) and
    EstaZerado(faliqCofins) and
    EstaVazio(fnri) and
    EstaVazio(fampLegal) and
    EstaZerado(fredPis) and
    EstaZerado(fredCofins);
end;

procedure TACBrIMendesGrupoPisCofins.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('cstEnt', fcstEnt)
    .Value('cstSai', fcstSai)
    .Value('aliqPis', faliqPis)
    .Value('aliqCofins', faliqCofins)
    .Value('nri', fnri)
    .Value('ampLegal', fampLegal)
    .Value('redPis', fredPis)
    .Value('redCofins', fredCofins);
end;

procedure TACBrIMendesGrupoPisCofins.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('cstEnt', fcstEnt, False)
    .AddPair('cstSai', fcstSai, False)
    .AddPair('aliqPis', faliqPis)
    .AddPair('aliqCofins', faliqCofins)
    .AddPair('nri', fnri, False)
    .AddPair('ampLegal', fampLegal, False)
    .AddPair('redPis', fredPis)
    .AddPair('redCofins', fredCofins);
end;

procedure TACBrIMendesGrupoPisCofins.Assign(Source: TACBrIMendesGrupoPisCofins);
begin
  fcstEnt := Source.cstEnt;
  fcstSai := Source.cstSai;
  faliqPis := Source.aliqPis;
  faliqCofins := Source.aliqCofins;
  fnri := Source.nri;
  fampLegal := Source.ampLegal;
  fredPis := Source.redPis;
  fredCofins := Source.redCofins;
end;

procedure TACBrIMendesGrupoPisCofins.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGrupoPisCofins) then
    Assign(TACBrIMendesGrupoPisCofins(aSource));
end;

{ TACBrIMendesGrupoIPI }

constructor TACBrIMendesGrupoIPI.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesGrupoIPI.Clear;
begin
  fcstEnt := EmptyStr;
  fcstSai := EmptyStr;
  faliqipi := 0;
  fcodenq := EmptyStr;
  fex := EmptyStr;
end;

function TACBrIMendesGrupoIPI.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcstEnt) and
    EstaVazio(fcstSai) and
    EstaZerado(faliqipi) and
    EstaVazio(fcodenq) and
    EstaVazio(fex);
end;

procedure TACBrIMendesGrupoIPI.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('cstEnt', fcstEnt)
    .Value('cstSai', fcstSai)
    .Value('aliqipi', faliqipi)
    .Value('codenq', fcodenq)
    .Value('ex', fex);
end;

procedure TACBrIMendesGrupoIPI.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('cstEnt', fcstEnt, False)
    .AddPair('cstSai', fcstSai, False)
    .AddPair('aliqipi', faliqipi)
    .AddPair('codenq', fcodenq, False)
    .AddPair('ex', fex, False);
end;

procedure TACBrIMendesGrupoIPI.Assign(Source: TACBrIMendesGrupoIPI);
begin
  fcstEnt := Source.cstEnt;
  fcstSai := Source.cstSai;
  faliqipi := Source.aliqipi;
  fcodenq := Source.codenq;
  fex := Source.ex;
end;

procedure TACBrIMendesGrupoIPI.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGrupoIPI) then
    Assign(TACBrIMendesGrupoIPI(aSource));
end;

{ TACBrIMendesGrupoIBS }

constructor TACBrIMendesGrupoIBS.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesGrupoIBS.Clear;
begin
  fcClassTrib := EmptyStr;
  fdescrcClassTrib := EmptyStr;
  fcst := EmptyStr;
  fdescrCST := EmptyStr;
  fibsUF := 0;
  fibsMun := 0;
  freducaoaliqIBS := 0;
  freducaoBcIBS := 0;
  fampLegal := EmptyStr;
  fdtVigIni := 0;
  fdtVigFin := 0;
end;

function TACBrIMendesGrupoIBS.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcClassTrib) and
    EstaVazio(fdescrcClassTrib) and
    EstaVazio(fcst) and
    EstaVazio(fdescrCST) and
    EstaZerado(fibsUF) and
    EstaZerado(fibsMun) and
    EstaZerado(freducaoaliqIBS) and
    EstaZerado(freducaoBcIBS) and
    EstaVazio(fampLegal) and
    EstaZerado(fdtVigIni) and
    EstaZerado(fdtVigFin);
end;

procedure TACBrIMendesGrupoIBS.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s1, s2: String;
begin
  {$IfDef FPC}
  s1 := EmptyStr;
  s2 := EmptyStr;
  {$EndIf}
  aJSon
    .Value('cClassTrib', fcClassTrib)
    .Value('descrcClassTrib', fdescrcClassTrib)
    .Value('cst', fcst)
    .Value('descrCST', fdescrCST)
    .Value('ibsUF', fibsUF)
    .Value('ibsMun', fibsMun)
    .Value('reducaoaliqIBS', freducaoaliqIBS)
    .Value('reducaoBcIBS', freducaoBcIBS)
    .Value('ampLegal', fampLegal)
    .Value('dtVigIni', s1)
    .Value('dtVigFin', s2);
  if NaoEstaVazio(s1) then
    fdtVigIni := StringToDateTimeDef(s1, 0, 'DD/MM/YYYY');
  if NaoEstaVazio(s2) then
    fdtVigFin := StringToDateTimeDef(s2, 0, 'DD/MM/YYYY');
end;

procedure TACBrIMendesGrupoIBS.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('cClassTrib', fcClassTrib, False)
    .AddPair('descrcClassTrib', fdescrcClassTrib, False)
    .AddPair('cst', fcst, False)
    .AddPair('descrCST', fdescrCST, False)
    .AddPair('ibsUF', fibsUF)
    .AddPair('ibsMun', fibsMun)
    .AddPair('reducaoaliqIBS', freducaoaliqIBS)
    .AddPair('reducaoBcIBS', freducaoBcIBS)
    .AddPair('ampLegal', fampLegal, False)
    .AddPair('dtVigIni', FormatDateBr(fdtVigIni, 'DD/MM/YYYY'), False)
    .AddPair('dtVigFin', FormatDateBr(fdtVigFin, 'DD/MM/YYYY'), False);
end;

procedure TACBrIMendesGrupoIBS.Assign(Source: TACBrIMendesGrupoIBS);
begin
  fcClassTrib := Source.cClassTrib;
  fdescrcClassTrib := Source.descrcClassTrib;
  fcst := Source.cst;
  fdescrCST := Source.descrCST;
  fibsUF := Source.ibsUF;
  fibsMun := Source.ibsMun;
  freducaoaliqIBS := Source.reducaoaliqIBS;
  freducaoBcIBS := Source.reducaoBcIBS;
  fampLegal := Source.ampLegal;
  fdtVigIni := Source.dtVigIni;
  fdtVigFin := Source.dtVigFin;
end;

procedure TACBrIMendesGrupoIBS.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGrupoIBS) then
    Assign(TACBrIMendesGrupoIBS(aSource));
end;

{ TACBrIMendesGrupoProtocolo }

constructor TACBrIMendesGrupoProtocolo.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrIMendesGrupoProtocolo.Clear;
begin
  fprotId := 0;
  fprotNome := EmptyStr;
  fdescricao := EmptyStr;
  fdtVigIni := 0;
  fdtVigFin := 0;
  fisento := EmptyStr;
  fantecipado := EmptyStr;
  fsubsTrib := EmptyStr;
  frespTrib := EmptyStr;
  faliqIcmsInterestadual := 0;
  fredBcInterestadual := 0;
  faliqEfetiva := 0;
  fiva := 0;
  fdebitoPresumidoInter := 0;
end;

function TACBrIMendesGrupoProtocolo.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fprotId) and
    EstaVazio(fprotNome) and
    EstaVazio(fdescricao) and
    EstaZerado(fdtVigIni) and
    EstaZerado(fdtVigFin) and
    EstaVazio(fisento) and
    EstaVazio(fantecipado) and
    EstaVazio(fsubsTrib) and
    EstaVazio(frespTrib) and
    EstaZerado(faliqIcmsInterestadual) and
    EstaZerado(fredBcInterestadual) and
    EstaZerado(faliqEfetiva) and
    EstaZerado(fiva) and
    EstaZerado(fdebitoPresumidoInter);
end;

procedure TACBrIMendesGrupoProtocolo.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s1, s2: String;
begin
  {$IfDef FPC}
  s1 := EmptyStr;
  s2 := EmptyStr;
  {$EndIf}
  aJSon
    .Value('protId', fprotId)
    .Value('protNome', fprotNome)
    .Value('descricao', fdescricao)
    .Value('dtVigIni', s1)
    .Value('dtVigFin', s2)
    .Value('isento', fisento)
    .Value('antecipado', fantecipado)
    .Value('subsTrib', fsubsTrib)
    .Value('respTrib', frespTrib)
    .Value('aliqIcmsInterestadual', faliqIcmsInterestadual)
    .Value('redBcInterestadual', fredBcInterestadual)
    .Value('aliqEfetiva', faliqEfetiva)
    .Value('iva', fiva)
    .Value('debitoPresumidoInter', fdebitoPresumidoInter);
  if NaoEstaVazio(s1) then
    fdtVigIni := StringToDateTimeDef(s1, 0, 'DD/MM/YYYY');
  if NaoEstaVazio(s2) then
    fdtVigFin := StringToDateTimeDef(s2, 0, 'DD/MM/YYYY');
end;

procedure TACBrIMendesGrupoProtocolo.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('protId', fprotId)
    .AddPair('protNome', fprotNome, False)
    .AddPair('descricao', fdescricao, False)
    .AddPair('dtVigIni', FormatDateBr(fdtVigIni, 'DD/MM/YYYY'), False)
    .AddPair('dtVigFin', FormatDateBr(fdtVigFin, 'DD/MM/YYYY'), False)
    .AddPair('isento', fisento, False)
    .AddPair('antecipado', fantecipado, False)
    .AddPair('subsTrib', fsubsTrib, False)
    .AddPair('respTrib', frespTrib, False)
    .AddPair('aliqIcmsInterestadual', faliqIcmsInterestadual)
    .AddPair('redBcInterestadual', fredBcInterestadual)
    .AddPair('aliqEfetiva', faliqEfetiva)
    .AddPair('iva', fiva)
    .AddPair('debitoPresumidoInter', fdebitoPresumidoInter);
end;

procedure TACBrIMendesGrupoProtocolo.Assign(Source: TACBrIMendesGrupoProtocolo);
begin
  fprotId := Source.protId;
  fprotNome := Source.protNome;
  fdescricao := Source.descricao;
  fdtVigIni := Source.dtVigIni;
  fdtVigFin := Source.dtVigFin;
  fisento := Source.isento;
  fantecipado := Source.antecipado;
  fsubsTrib := Source.subsTrib;
  frespTrib := Source.respTrib;
  faliqIcmsInterestadual := Source.aliqIcmsInterestadual;
  fredBcInterestadual := Source.redBcInterestadual;
  faliqEfetiva := Source.aliqEfetiva;
  fiva := Source.iva;
  fdebitoPresumidoInter := Source.debitoPresumidoInter;
end;

procedure TACBrIMendesGrupoProtocolo.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGrupoProtocolo) then
    Assign(TACBrIMendesGrupoProtocolo(aSource));
end;

{ TACBrIMendesGrupoCaracTrib }

constructor TACBrIMendesGrupoCaracTrib.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesGrupoCaracTrib.Destroy;
begin
  if Assigned(fProtocolo) then
    fProtocolo.Free;
  if Assigned(fibs) then
    fibs.Free;
  inherited Destroy;
end;

procedure TACBrIMendesGrupoCaracTrib.Clear;
begin
  fcodigo := EmptyStr;
  fmunicipio := 0;
  ffinalidade := EmptyStr;
  fcodRegra := EmptyStr;
  fcodExcecao := 0;
  fdtVigIni := 0;
  fdtVigFin := 0;
  fcFOP := EmptyStr;
  fcST := EmptyStr;
  fcSOSN := EmptyStr;
  faliqIcmsInterna := 0;
  faliqIcmsInterestadual := 0;
  freducaoBcIcms := 0;
  freducaoBcIcmsSt := 0;
  fredBcICMsInterestadual := 0;
  faliqIcmsSt := 0;
  fiVA := 0;
  fiVAAjust := 0;
  ffCP := 0;
  fcodBenef := EmptyStr;
  fpDifer := 0;
  fpIsencao := 0;
  fantecipado := EmptyStr;
  fdesonerado := EmptyStr;
  fpICMSDeson := 0;
  fisento := EmptyStr;
  findDeduzDeson := EmptyStr;
  ftpCalcDifal := 0;
  fdebitoPresumido := 0;
  fdebitoPresumidoNaoCredenciado := 0;
  fampLegal := EmptyStr;
  fregraGeral := EmptyStr;
  fpSuspensaoImporatcao := 0;
  fregimeEspecial := EmptyStr;
  if Assigned(fProtocolo) then
    fProtocolo.Clear;
  if Assigned(fibs) then
    fibs.Clear;
end;

function TACBrIMendesGrupoCaracTrib.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcodigo) and
    EstaZerado(fmunicipio) and
    EstaVazio(ffinalidade) and
    EstaVazio(fcodRegra) and
    EstaZerado(fcodExcecao) and
    EstaZerado(fdtVigIni) and
    EstaZerado(fdtVigFin) and
    EstaVazio(fcFOP) and
    EstaVazio(fcST) and
    EstaVazio(fcSOSN) and
    EstaZerado(faliqIcmsInterna) and
    EstaZerado(faliqIcmsInterestadual) and
    EstaZerado(freducaoBcIcms) and
    EstaZerado(freducaoBcIcmsSt) and
    EstaZerado(fredBcICMsInterestadual) and
    EstaZerado(faliqIcmsSt) and
    EstaZerado(fiVA) and
    EstaZerado(fiVAAjust) and
    EstaZerado(ffCP) and
    EstaVazio(fcodBenef) and
    EstaZerado(fpDifer) and
    EstaZerado(fpIsencao) and
    EstaVazio(fantecipado) and
    EstaVazio(fdesonerado) and
    EstaZerado(fpICMSDeson) and
    EstaVazio(fisento) and
    EstaVazio(findDeduzDeson) and
    EstaZerado(ftpCalcDifal) and
    EstaZerado(fdebitoPresumido) and
    EstaZerado(fdebitoPresumidoNaoCredenciado) and
    EstaVazio(fampLegal) and
    (not Assigned(fProtocolo) or fProtocolo.IsEmpty) and
    EstaVazio(fregraGeral) and
    EstaZerado(fpSuspensaoImporatcao) and
    EstaVazio(fregimeEspecial) and
    (not Assigned(fibs) or fibs.IsEmpty);
end;

function TACBrIMendesGrupoCaracTrib.GetProtocolo: TACBrIMendesGrupoProtocolo;
begin
  if not Assigned(fProtocolo) then
    fProtocolo := TACBrIMendesGrupoProtocolo.Create('Protocolo');
  Result := fProtocolo;
end;

function TACBrIMendesGrupoCaracTrib.GetIBS: TACBrIMendesGrupoIBS;
begin
  if not Assigned(fibs) then
    fibs := TACBrIMendesGrupoIBS.Create('ibs');
  Result := fibs;
end;

procedure TACBrIMendesGrupoCaracTrib.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s1, s2: String;
begin
  {$IfDef FPC}
  s1 := EmptyStr;
  s2 := EmptyStr;
  {$EndIf}
  aJSon
    .Value('codigo', fcodigo)
    .Value('municipio', fmunicipio)
    .Value('finalidade', ffinalidade)
    .Value('codRegra', fcodRegra)
    .Value('codExcecao', fcodExcecao)
    .Value('dtVigIni', s1)
    .Value('dtVigFin', s2)
    .Value('cFOP', fcFOP)
    .Value('cST', fcST)
    .Value('cSOSN', fcSOSN)
    .Value('aliqIcmsInterna', faliqIcmsInterna)
    .Value('aliqIcmsInterestadual', faliqIcmsInterestadual)
    .Value('reducaoBcIcms', freducaoBcIcms)
    .Value('reducaoBcIcmsSt', freducaoBcIcmsSt)
    .Value('redBcICMsInterestadual', fredBcICMsInterestadual)
    .Value('aliqIcmsSt', faliqIcmsSt)
    .Value('iVA', fiVA)
    .Value('iVAAjust', fiVAAjust)
    .Value('fCP', ffCP)
    .Value('codBenef', fcodBenef)
    .Value('pDifer', fpDifer)
    .Value('pIsencao', fpIsencao)
    .Value('antecipado', fantecipado)
    .Value('desonerado', fdesonerado)
    .Value('pICMSDeson', fpICMSDeson)
    .Value('isento', fisento)
    .Value('indDeduzDeson', findDeduzDeson)
    .Value('tpCalcDifal', ftpCalcDifal)
    .Value('debitoPresumido', fdebitoPresumido)
    .Value('debitoPresumidoNaoCredenciado', fdebitoPresumidoNaoCredenciado)
    .Value('ampLegal', fampLegal)
    .Value('regraGeral', fregraGeral)
    .Value('pSuspensaoImporatcao', fpSuspensaoImporatcao)
    .Value('regimeEspecial', fregimeEspecial);
  if NaoEstaVazio(s1) then
    fdtVigIni := StringToDateTimeDef(s1, 0, 'DD/MM/YYYY');
  if NaoEstaVazio(s2) then
    fdtVigFin := StringToDateTimeDef(s2, 0, 'DD/MM/YYYY');

  Protocolo.ReadFromJSon(aJSon);
  ibs.ReadFromJSon(aJSon);
end;

procedure TACBrIMendesGrupoCaracTrib.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('codigo', fcodigo, False)
    .AddPair('municipio', fmunicipio)
    .AddPair('finalidade', ffinalidade, False)
    .AddPair('codRegra', fcodRegra, False)
    .AddPair('codExcecao', fcodExcecao)
    .AddPair('dtVigIni', FormatDateBr(fdtVigIni, 'DD/MM/YYYY'), False)
    .AddPair('dtVigFin', FormatDateBr(fdtVigFin, 'DD/MM/YYYY'), False)
    .AddPair('cFOP', fcFOP, False)
    .AddPair('cST', fcST, False)
    .AddPair('cSOSN', fcSOSN, False)
    .AddPair('aliqIcmsInterna', faliqIcmsInterna)
    .AddPair('aliqIcmsInterestadual', faliqIcmsInterestadual)
    .AddPair('reducaoBcIcms', freducaoBcIcms)
    .AddPair('reducaoBcIcmsSt', freducaoBcIcmsSt)
    .AddPair('redBcICMsInterestadual', fredBcICMsInterestadual)
    .AddPair('aliqIcmsSt', faliqIcmsSt)
    .AddPair('iVA', fiVA)
    .AddPair('iVAAjust', fiVAAjust)
    .AddPair('fCP', ffCP)
    .AddPair('codBenef', fcodBenef, False)
    .AddPair('pDifer', fpDifer)
    .AddPair('pIsencao', fpIsencao)
    .AddPair('antecipado', fantecipado, False)
    .AddPair('desonerado', fdesonerado, False)
    .AddPair('pICMSDeson', fpICMSDeson)
    .AddPair('isento', fisento, False)
    .AddPair('indDeduzDeson', findDeduzDeson, False)
    .AddPair('tpCalcDifal', ftpCalcDifal)
    .AddPair('debitoPresumido', fdebitoPresumido)
    .AddPair('debitoPresumidoNaoCredenciado', fdebitoPresumidoNaoCredenciado)
    .AddPair('ampLegal', fampLegal, False)
    .AddPair('regraGeral', fregraGeral, False)
    .AddPair('pSuspensaoImporatcao', fpSuspensaoImporatcao)
    .AddPair('regimeEspecial', fregimeEspecial, False);

  if Assigned(fProtocolo) then
    fProtocolo.WriteToJSon(aJSon);
  if Assigned(fibs) then
    fibs.WriteToJSon(aJSon);
end;

procedure TACBrIMendesGrupoCaracTrib.Assign(Source: TACBrIMendesGrupoCaracTrib);
begin
  fcodigo := Source.codigo;
  fmunicipio := Source.municipio;
  ffinalidade := Source.finalidade;
  fcodRegra := Source.codRegra;
  fcodExcecao := Source.codExcecao;
  fdtVigIni := Source.dtVigIni;
  fdtVigFin := Source.dtVigFin;
  fcFOP := Source.cFOP;
  fcST := Source.cST;
  fcSOSN := Source.cSOSN;
  faliqIcmsInterna := Source.aliqIcmsInterna;
  faliqIcmsInterestadual := Source.aliqIcmsInterestadual;
  freducaoBcIcms := Source.reducaoBcIcms;
  freducaoBcIcmsSt := Source.reducaoBcIcmsSt;
  fredBcICMsInterestadual := Source.redBcICMsInterestadual;
  faliqIcmsSt := Source.aliqIcmsSt;
  fiVA := Source.iVA;
  fiVAAjust := Source.iVAAjust;
  ffCP := Source.fCP;
  fcodBenef := Source.codBenef;
  fpDifer := Source.pDifer;
  fpIsencao := Source.pIsencao;
  fantecipado := Source.antecipado;
  fdesonerado := Source.desonerado;
  fpICMSDeson := Source.pICMSDeson;
  fisento := Source.isento;
  findDeduzDeson := Source.indDeduzDeson;
  ftpCalcDifal := Source.tpCalcDifal;
  fdebitoPresumido := Source.debitoPresumido;
  fdebitoPresumidoNaoCredenciado := Source.debitoPresumidoNaoCredenciado;
  fampLegal := Source.ampLegal;
  fregraGeral := Source.regraGeral;
  fpSuspensaoImporatcao := Source.pSuspensaoImporatcao;
  fregimeEspecial := Source.regimeEspecial;
  Protocolo.Assign(Source.Protocolo);
  ibs.Assign(Source.ibs);
end;

procedure TACBrIMendesGrupoCaracTrib.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGrupoCaracTrib) then
    Assign(TACBrIMendesGrupoCaracTrib(aSource));
end;

{ TACBrIMendesGrupoCaracTribs }

function TACBrIMendesGrupoCaracTribs.New: TACBrIMendesGrupoCaracTrib;
begin
  Result := TACBrIMendesGrupoCaracTrib.Create;
  Add(Result);
end;

function TACBrIMendesGrupoCaracTribs.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrIMendesGrupoCaracTribs.Add(AItem: TACBrIMendesGrupoCaracTrib): Integer;
begin
  Result := inherited Add(AItem);
end;

procedure TACBrIMendesGrupoCaracTribs.Insert(AIndex: Integer; AItem: TACBrIMendesGrupoCaracTrib);
begin
  inherited Insert(AIndex, AItem);
end;

function TACBrIMendesGrupoCaracTribs.GetItem(AIndex: Integer): TACBrIMendesGrupoCaracTrib;
begin
  Result := TACBrIMendesGrupoCaracTrib(inherited Items[AIndex]);
end;

procedure TACBrIMendesGrupoCaracTribs.SetItem(AIndex: Integer; AValue: TACBrIMendesGrupoCaracTrib);
begin
  inherited Items[AIndex] := AValue;
end;

{ TACBrIMendesGrupoCFOP }

constructor TACBrIMendesGrupoCFOP.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesGrupoCFOP.Destroy;
begin
  if Assigned(fCaracTrib) then
    fCaracTrib.Free;
  inherited Destroy;
end;

procedure TACBrIMendesGrupoCFOP.Clear;
begin
  fcFOP := EmptyStr;
  if Assigned(fCaracTrib) then
    fCaracTrib.Clear;
end;

function TACBrIMendesGrupoCFOP.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcFOP) and
    (not Assigned(fCaracTrib) or fCaracTrib.IsEmpty);
end;

function TACBrIMendesGrupoCFOP.GetCaracTrib: TACBrIMendesGrupoCaracTribs;
begin
  if not Assigned(fCaracTrib) then
    fCaracTrib := TACBrIMendesGrupoCaracTribs.Create('CaracTrib');
  Result := fCaracTrib;
end;

procedure TACBrIMendesGrupoCFOP.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('cFOP', fcFOP);
  CaracTrib.ReadFromJSon(aJSon);
end;

procedure TACBrIMendesGrupoCFOP.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('cFOP', fcFOP, False);
  if Assigned(fCaracTrib) then
    fCaracTrib.WriteToJSon(aJSon);
end;

procedure TACBrIMendesGrupoCFOP.Assign(Source: TACBrIMendesGrupoCFOP);
begin
  fcFOP := Source.cFOP;
  CaracTrib.Assign(Source.CaracTrib);
end;

procedure TACBrIMendesGrupoCFOP.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGrupoCFOP) then
    Assign(TACBrIMendesGrupoCFOP(aSource));
end;

{ TACBrIMendesGrupoUF }

constructor TACBrIMendesGrupoUF.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesGrupoUF.Destroy;
begin
  if Assigned(fCFOP) then
    fCFOP.Free;
  inherited Destroy;
end;

procedure TACBrIMendesGrupoUF.Clear;
begin
  fuF := EmptyStr;
  fmensagem := EmptyStr;
  if Assigned(fCFOP) then
    fCFOP.Clear;
end;

function TACBrIMendesGrupoUF.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fuF) and
    (not Assigned(fCFOP) or fCFOP.IsEmpty) and
    EstaVazio(fmensagem);
end;

function TACBrIMendesGrupoUF.GetCFOP: TACBrIMendesGrupoCFOP;
begin
  if not Assigned(fCFOP) then
    fCFOP := TACBrIMendesGrupoCFOP.Create('CFOP');
  Result := fCFOP;
end;

procedure TACBrIMendesGrupoUF.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .Value('uF', fuF)
    .Value('mensagem', fmensagem);
  CFOP.ReadFromJSon(aJSon);
end;

procedure TACBrIMendesGrupoUF.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  aJSon
    .AddPair('uF', fuF, False)
    .AddPair('mensagem', fmensagem, False);
  if Assigned(fCFOP) then
    fCFOP.WriteToJSon(aJSon);
end;

procedure TACBrIMendesGrupoUF.Assign(Source: TACBrIMendesGrupoUF);
begin
  fuF := Source.uF;
  fmensagem := Source.mensagem;
  CFOP.Assign(Source.CFOP);
end;

procedure TACBrIMendesGrupoUF.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGrupoUF) then
    Assign(TACBrIMendesGrupoUF(aSource));
end;

{ TACBrIMendesGrupoUFs }

function TACBrIMendesGrupoUFs.New: TACBrIMendesGrupoUF;
begin
  Result := TACBrIMendesGrupoUF.Create;
  Add(Result);
end;

function TACBrIMendesGrupoUFs.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrIMendesGrupoUFs.Add(AItem: TACBrIMendesGrupoUF): Integer;
begin
  Result := inherited Add(AItem);
end;

procedure TACBrIMendesGrupoUFs.Insert(AIndex: Integer; AItem: TACBrIMendesGrupoUF);
begin
  inherited Insert(AIndex, AItem);
end;

function TACBrIMendesGrupoUFs.GetItem(AIndex: Integer): TACBrIMendesGrupoUF;
begin
  Result := TACBrIMendesGrupoUF(inherited Items[AIndex]);
end;

procedure TACBrIMendesGrupoUFs.SetItem(AIndex: Integer; AValue: TACBrIMendesGrupoUF);
begin
  inherited Items[AIndex] := AValue;
end;

{ TACBrIMendesGrupoRegra }

constructor TACBrIMendesGrupoRegra.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesGrupoRegra.Destroy;
begin
  if Assigned(fuFs) then
    fuFs.Free;
  inherited Destroy;
end;

procedure TACBrIMendesGrupoRegra.Clear;
begin
  if Assigned(fuFs) then
    fuFs.Clear;
end;

function TACBrIMendesGrupoRegra.IsEmpty: Boolean;
begin
  Result := (not Assigned(fuFs)) or fuFs.IsEmpty;
end;

function TACBrIMendesGrupoRegra.GetUFs: TACBrIMendesGrupoUFs;
begin
  if not Assigned(fuFs) then
    fuFs := TACBrIMendesGrupoUFs.Create('uFs');
  Result := fuFs;
end;

procedure TACBrIMendesGrupoRegra.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  uFs.ReadFromJSon(aJSon);
end;

procedure TACBrIMendesGrupoRegra.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if Assigned(fuFs) then
    fuFs.WriteToJSon(aJSon);
end;

procedure TACBrIMendesGrupoRegra.Assign(Source: TACBrIMendesGrupoRegra);
begin
  uFs.Assign(Source.uFs);
end;

procedure TACBrIMendesGrupoRegra.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGrupoRegra) then
    Assign(TACBrIMendesGrupoRegra(aSource));
end;

{ TACBrIMendesGrupoRegras }

function TACBrIMendesGrupoRegras.New: TACBrIMendesGrupoRegra;
begin
  Result := TACBrIMendesGrupoRegra.Create;
  Add(Result);
end;

function TACBrIMendesGrupoRegras.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrIMendesGrupoRegras.Add(AItem: TACBrIMendesGrupoRegra): Integer;
begin
  Result := inherited Add(AItem);
end;

procedure TACBrIMendesGrupoRegras.Insert(AIndex: Integer; AItem: TACBrIMendesGrupoRegra);
begin
  inherited Insert(AIndex, AItem);
end;

function TACBrIMendesGrupoRegras.GetItem(AIndex: Integer): TACBrIMendesGrupoRegra;
begin
  Result := TACBrIMendesGrupoRegra(inherited Items[AIndex]);
end;

procedure TACBrIMendesGrupoRegras.SetItem(AIndex: Integer; AValue: TACBrIMendesGrupoRegra);
begin
  inherited Items[AIndex] := AValue;
end;

{ TACBrIMendesGrupo }

constructor TACBrIMendesGrupo.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

destructor TACBrIMendesGrupo.Destroy;
begin
  if Assigned(fcbs) then
    fcbs.Free;
  if Assigned(fpisCofins) then
    fpisCofins.Free;
  if Assigned(fipi) then
    fipi.Free;
  if Assigned(fRegras) then
    fRegras.Free;
  if Assigned(fprodEan) then
    fprodEan.Free;
  inherited Destroy;
end;

procedure TACBrIMendesGrupo.Clear;
begin
  fcodigo := EmptyStr;
  fdescricao := EmptyStr;
  fnCM := EmptyStr;
  fcEST := EmptyStr;
  fdtVigIni := 0;
  fdtVigFin := 0;
  flista := EmptyStr;
  ftipo := EmptyStr;
  fcodAnp := EmptyStr;
  fpassivelPMC := EmptyStr;
  fimpostoImportacao := 0;
  fMensagem := EmptyStr;
  if Assigned(fcbs) then fcbs.Clear;
  if Assigned(fpisCofins) then fpisCofins.Clear;
  if Assigned(fipi) then fipi.Clear;
  if Assigned(fRegras) then fRegras.Clear;
  if Assigned(fprodEan) then fprodEan.Clear;
end;

function TACBrIMendesGrupo.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcodigo) and
    EstaVazio(fdescricao) and
    EstaVazio(fnCM) and
    EstaVazio(fcEST) and
    EstaZerado(fdtVigIni) and
    EstaZerado(fdtVigFin) and
    EstaVazio(flista) and
    EstaVazio(ftipo) and
    EstaVazio(fcodAnp) and
    EstaVazio(fpassivelPMC) and
    EstaZerado(fimpostoImportacao) and
    (not Assigned(fcbs) or fcbs.IsEmpty) and
    (not Assigned(fpisCofins) or fpisCofins.IsEmpty) and
    (not Assigned(fipi) or fipi.IsEmpty) and
    (not Assigned(fRegras) or fRegras.IsEmpty) and
    ((not Assigned(fprodEan)) or (fprodEan.Count = 0)) and
    EstaVazio(fMensagem);
end;

function TACBrIMendesGrupo.GetCBS: TACBrIMendesGrupoCBS;
begin
  if not Assigned(fcbs) then
    fcbs := TACBrIMendesGrupoCBS.Create('cbs');
  Result := fcbs;
end;

function TACBrIMendesGrupo.GetPisCofins: TACBrIMendesGrupoPisCofins;
begin
  if not Assigned(fpisCofins) then
    fpisCofins := TACBrIMendesGrupoPisCofins.Create('pisCofins');
  Result := fpisCofins;
end;

function TACBrIMendesGrupo.GetIPI: TACBrIMendesGrupoIPI;
begin
  if not Assigned(fipi) then
    fipi := TACBrIMendesGrupoIPI.Create('iPI');
  Result := fipi;
end;

function TACBrIMendesGrupo.GetRegras: TACBrIMendesGrupoRegras;
begin
  if not Assigned(fRegras) then
    fRegras := TACBrIMendesGrupoRegras.Create('Regras');
  Result := fRegras;
end;

function TACBrIMendesGrupo.GetProdEan: TStringList;
begin
  if not Assigned(fprodEan) then
    fprodEan := TStringList.Create;
  Result := fprodEan;
end;

procedure TACBrIMendesGrupo.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s1, s2: String;
  ja: TACBrJSONArray;
  i: Integer;
begin
  {$IfDef FPC}
  s1 := EmptyStr;
  s2 := EmptyStr;
  {$EndIf}
  aJSon
    .Value('codigo', fcodigo)
    .Value('descricao', fdescricao)
    .Value('nCM', fnCM)
    .Value('cEST', fcEST)
    .Value('dtVigIni', s1)
    .Value('dtVigFin', s2)
    .Value('lista', flista)
    .Value('tipo', ftipo)
    .Value('codAnp', fcodAnp)
    .Value('passivelPMC', fpassivelPMC)
    .Value('impostoImportacao', fimpostoImportacao)
    .Value('Mensagem', fMensagem);
  if NaoEstaVazio(s1) then
    fdtVigIni := StringToDateTimeDef(s1, 0, 'DD/MM/YYYY');
  if NaoEstaVazio(s2) then
    fdtVigFin := StringToDateTimeDef(s2, 0, 'DD/MM/YYYY');

  cbs.ReadFromJSon(aJSon);
  pisCofins.ReadFromJSon(aJSon);
  iPI.ReadFromJSon(aJSon);
  if aJSon.IsJSONArray('prodEan') then
  begin
    prodEan.Clear;
    ja := aJSon.AsJSONArray['prodEan'];
    for i := 0 to ja.Count - 1 do
      prodEan.Add(ja.Items[i]);
  end;

  Regras.ReadFromJSon(aJSon);
end;

procedure TACBrIMendesGrupo.DoWriteToJSon(aJSon: TACBrJSONObject);
var
  ja: TACBrJSONArray;
  i: Integer;
begin
  aJSon
    .AddPair('codigo', fcodigo, False)
    .AddPair('descricao', fdescricao, False)
    .AddPair('nCM', fnCM, False)
    .AddPair('cEST', fcEST, False)
    .AddPair('dtVigIni', FormatDateBr(fdtVigIni, 'DD/MM/YYYY'), False)
    .AddPair('dtVigFin', FormatDateBr(fdtVigFin, 'DD/MM/YYYY'), False)
    .AddPair('lista', flista, False)
    .AddPair('tipo', ftipo, False)
    .AddPair('codAnp', fcodAnp, False)
    .AddPair('passivelPMC', fpassivelPMC, False)
    .AddPair('impostoImportacao', fimpostoImportacao)
    .AddPair('Mensagem', fMensagem, False);

  if Assigned(fcbs) then
    fcbs.WriteToJSon(aJSon);
  if Assigned(fpisCofins) then
    fpisCofins.WriteToJSon(aJSon);
  if Assigned(fipi) then
    fipi.WriteToJSon(aJSon);
  if Assigned(fprodEan) and (fprodEan.Count > 0) then
  begin
    ja := TACBrJSONArray.Create;
    for i := 0 to fprodEan.Count - 1 do
      ja.AddElement(fprodEan[i]);
    aJSon.AddPair('prodEan', ja);
  end;
  if Assigned(fRegras) then
    fRegras.WriteToJSon(aJSon);
end;

procedure TACBrIMendesGrupo.Assign(Source: TACBrIMendesGrupo);
begin
  fcodigo := Source.codigo;
  fdescricao := Source.descricao;
  fnCM := Source.nCM;
  fcEST := Source.cEST;
  fdtVigIni := Source.dtVigIni;
  fdtVigFin := Source.dtVigFin;
  flista := Source.lista;
  ftipo := Source.tipo;
  fcodAnp := Source.codAnp;
  fpassivelPMC := Source.passivelPMC;
  fimpostoImportacao := Source.impostoImportacao;
  fMensagem := Source.Mensagem;
  cbs.Assign(Source.cbs);
  pisCofins.Assign(Source.pisCofins);
  iPI.Assign(Source.iPI);
  Regras.Assign(Source.Regras);
  prodEan.Assign(Source.prodEan);
end;

procedure TACBrIMendesGrupo.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrIMendesGrupo) then
    Assign(TACBrIMendesGrupo(aSource));
end;

{ TACBrIMendesGrupos }

function TACBrIMendesGrupos.New: TACBrIMendesGrupo;
begin
  Result := TACBrIMendesGrupo.Create;
  Add(Result);
end;

function TACBrIMendesGrupos.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrIMendesGrupos.Add(AItem: TACBrIMendesGrupo): Integer;
begin
  Result := inherited Add(AItem);
end;

procedure TACBrIMendesGrupos.Insert(AIndex: Integer; AItem: TACBrIMendesGrupo);
begin
  inherited Insert(AIndex, AItem);
end;

function TACBrIMendesGrupos.GetItem(AIndex: Integer): TACBrIMendesGrupo;
begin
  Result := TACBrIMendesGrupo(inherited Items[AIndex]);
end;

procedure TACBrIMendesGrupos.SetItem(AIndex: Integer; AValue: TACBrIMendesGrupo);
begin
  inherited Items[AIndex] := AValue;
end;

{ ==== FIM: Implementacao Saneamento Grupos ==== }

function TACBrIMendesRegimeEspecialList.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrIMendesRegimeEspecialList.Add(ARegimeEspecial: TACBrIMendesRegimeEspecial): Integer;
begin
  Result := inherited Add(ARegimeEspecial);
end;

procedure TACBrIMendesRegimeEspecialList.Insert(AIndex: Integer; ARegimeEspecial: TACBrIMendesRegimeEspecial);
begin
  inherited Insert(AIndex, ARegimeEspecial);
end;

function TACBrIMendesRegimeEspecialList.GetItem(AIndex: Integer): TACBrIMendesRegimeEspecial;
begin
  Result := TACBrIMendesRegimeEspecial(inherited Items[AIndex]);
end;

procedure TACBrIMendesRegimeEspecialList.SetItem(AIndex: Integer; AValue: TACBrIMendesRegimeEspecial);
begin
  inherited Items[AIndex] := AValue;
end;

function TACBrIMendes.GetSaneamentoGradesRequest: TACBrIMendesGradesRequest;
begin
  if (not Assigned(fSaneamentoGradesRequest)) then
    fSaneamentoGradesRequest := TACBrIMendesGradesRequest.Create;
  Result := fSaneamentoGradesRequest;
end;

function TACBrIMendes.GetHistoricoAcessoResponse: TACBrIMendesHistoricoResponse;
begin
  if (not Assigned(fHistoricoAcessoResponse)) then
    fHistoricoAcessoResponse := TACBrIMendesHistoricoResponse.Create;
  Result := fHistoricoAcessoResponse;
end;

function TACBrIMendes.GetConsultarRegimeEspecialResponse: TACBrIMendesRegimeEspecialList;
begin
  if (not Assigned(fConsultarRegimeEspecialResponse)) then
    fConsultarRegimeEspecialResponse := TACBrIMendesRegimeEspecialList.Create;
  Result := fConsultarRegimeEspecialResponse;
end;

function TACBrIMendes.GetConsultarAlteradosResponse: TACBrIMendesConsultarResponse;
begin
  if (not Assigned(fConsultarAlteradosResponse)) then
    fConsultarAlteradosResponse := TACBrIMendesConsultarResponse.Create;
  Result := fConsultarAlteradosResponse;
end;

function TACBrIMendes.GetConsultarDescricaoResponse: TACBrIMendesConsultarResponse;
begin
  if (not Assigned(fConsultarDescricaoResponse)) then
    fConsultarDescricaoResponse := TACBrIMendesConsultarResponse.Create;
  Result := fConsultarDescricaoResponse;
end;

function TACBrIMendes.GetRespostaErro: TACBrIMendesErro;
begin
  if (not Assigned(fRespostaErro)) then
    fRespostaErro := TACBrIMendesErro.Create;
  Result := fRespostaErro;
end;

function TACBrIMendes.GetSaneamentoGradesResponse: TACBrIMendesSaneamentoResponse;
begin
  if (not Assigned(fSaneamentoGradesResponse)) then
    fSaneamentoGradesResponse := TACBrIMendesSaneamentoResponse.Create;
  Result := fSaneamentoGradesResponse;
end;

function TACBrIMendes.GetSenha: AnsiString;
begin
  Result := StrCrypt(fSenha, fKey)  // Descritografa a Senha
end;

function TACBrIMendes.CalcularURL: String;
begin
  if (fAmbiente = imaProducao) then
    Result := cIMendesURLProducao
  else
    Result := cIMendesURLHomologacao;
end;

procedure TACBrIMendes.SetSenha(AValue: AnsiString);
begin
  if NaoEstaVazio(fKey) and (fSenha = StrCrypt(AValue, fKey)) then
    Exit;

  fKey := FormatDateTime('hhnnsszzz', Now);
  fSenha := StrCrypt(AValue, fKey);  // Salva Senha de forma Criptografada, para evitar "Inspect"
end;

procedure TACBrIMendes.ValidarConfiguracao;
var
  wErro: TStringList;
begin
  wErro := TStringList.Create;
  try
    if (fAmbiente = imaNenhum) then
      wErro.Add('- Ambiente');
    if EstaVazio(fCNPJ) then
      wErro.Add('- Email');
    if EstaVazio(fSenha) then
      wErro.Add('- Senha');
    if NaoEstaZerado(wErro.Count) then
      raise EACBrIMendesAuthError.Create('Configure as propriedades:' + sLineBreak + wErro.Text);
  finally
    wErro.Free;
  end;
end;

constructor TACBrIMendes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fKey := EmptyStr;
  fCNPJ := EmptyStr;
  fToken := EmptyStr;
  fSenha := EmptyStr;
  fAmbiente := imaNenhum;
  fRespostaErro := Nil;
  fSaneamentoGradesRequest := Nil;
  fSaneamentoGradesResponse := Nil;
  fConsultarAlteradosResponse := Nil;
  fConsultarDescricaoResponse := Nil;
  fConsultarRegimeEspecialResponse := Nil;
  fHistoricoAcessoResponse := Nil;
end;

destructor TACBrIMendes.Destroy;
begin
  if Assigned(fRespostaErro) then
    fRespostaErro.Free;
  if Assigned(fSaneamentoGradesRequest) then
    fSaneamentoGradesRequest.Free;
  if Assigned(fSaneamentoGradesResponse) then
    fSaneamentoGradesResponse.Free;
  if Assigned(fConsultarAlteradosResponse) then
    fConsultarAlteradosResponse.Free;
  if Assigned(fConsultarDescricaoResponse) then
    fConsultarDescricaoResponse.Free;
  if Assigned(fConsultarRegimeEspecialResponse) then
    fConsultarRegimeEspecialResponse.Free;
  if Assigned(fHistoricoAcessoResponse) then
    fHistoricoAcessoResponse.Free;
  inherited Destroy;
end;

procedure TACBrIMendes.Clear;
begin
  RespostaErro.Clear;
  if Assigned(fSaneamentoGradesRequest) then
    fSaneamentoGradesRequest.Clear;
  if Assigned(fSaneamentoGradesResponse) then
    fSaneamentoGradesResponse.Clear;
  if Assigned(fConsultarAlteradosResponse) then
    fConsultarAlteradosResponse.Clear;
  if Assigned(fConsultarDescricaoResponse) then
    fConsultarDescricaoResponse.Clear;
  if Assigned(fConsultarRegimeEspecialResponse) then
    fConsultarRegimeEspecialResponse.Clear;
  if Assigned(fHistoricoAcessoResponse) then
    fHistoricoAcessoResponse.Clear;
end;

procedure TACBrIMendes.Autenticar;
var
  wBody, wResp: TACBrJSONObject;
  wURL, wBodyStr: String;
begin
  if NaoEstaVazio(fToken) then
    Exit;

  RegistrarLog('  TACBrIMendes.Autenticar');
  LimparHTTP;
  ValidarConfiguracao;

  HttpSend.Protocol := '1.1';
  HttpSend.MimeType := cContentTypeApplicationJSon;
  wBody := TACBrJSONObject.Create;
  try
    wBody
      .AddPair('cnpj', fCNPJ)
      .AddPair('senha', Senha);

    wBodyStr := wBody.ToJSON;
    RegistrarLog('Req.Body: ' + wBodyStr);
    WriteStrToStream(HTTPSend.Document, wBodyStr);
  finally
    wBody.Free;
  end;

  try
    wURL := CalcularURL + cIMendesEndPointLogin;
    HTTPMethod(cHTTPMethodPOST, wURL);

    if (HTTPResultCode <> HTTP_OK) then
      raise EACBrIMendesAuthError.Create('Erro ao Autenticar:' + sLineBreak + HTTPResponse);

    wResp := TACBrJSONObject.Parse(HTTPResponse);
    try
      fToken := wResp.AsString['token'];
    finally
      wResp.Free;
    end;
  except
    on E: Exception do
      raise EACBrIMendesAuthError.Create('Erro ao Autenticar:' + sLineBreak + E.Message);
  end;
end;

function TACBrIMendes.SaneamentoGrades: Boolean;
var
  jBody: TACBrJSONObject;
  sBody: String;
begin
  Result := False;
  ValidarConfiguracao;

  if SaneamentoGradesRequest.IsEmpty then
    raise EACBrAPIException.CreateFmt('sErroObjetoNaoPrenchido', ['SaneamentoGradesRequest']);

  LimparHTTP;
  HttpSend.Protocol := '1.1';
  HTTPSend.Headers.Add('login: ' + fCNPJ);
  HTTPSend.Headers.Add('senha: ' + Senha);
  HttpSend.MimeType := cContentTypeApplicationJSon;

  jBody := TACBrJSONObject.Create;
  try
    sBody := SaneamentoGradesRequest.AsJSON;
    RegistrarLog('Req.Body: ' + sBody);
    WriteStrToStream(HTTPSend.Document, sBody);
  finally
    jBody.Free;
  end;

  try
    URLPathParams.Add(cIMendesAPI);
    URLPathParams.Add(cIMendesV3);
    URLPathParams.Add(cIMendesPublic);
    URLPathParams.Add(cIMendesEndpointSaneamentoGrades);
    HTTPMethod(cHTTPMethodPOST, CalcularURL);
    Result := (HTTPResultCode = HTTP_OK);
    if Result or (HTTPResultCode = HTTP_BAD_REQUEST) then
      SaneamentoGradesResponse.AsJSON := HTTPResponse
    else
      RespostaErro.AsJSON := HTTPResponse;
  except
    on E: Exception do
      raise EACBrIMendesDataSend.Create('Erro:' + sLineBreak + E.Message);
  end;
end;

function TACBrIMendes.ConsultarDescricao(const aDescricao: String; const aCNPJ: String): Boolean;
var
  jBody: TACBrJSONObject;
  wCNPJ, sBody: String;
begin
  Result := False;
  ValidarConfiguracao;

  LimparHTTP;
  HttpSend.Protocol := '1.1';
  HttpSend.MimeType := cContentTypeApplicationJSon;
  HTTPSend.Headers.Add('login: ' + fCNPJ);
  HTTPSend.Headers.Add('senha: ' + Senha);
     
  wCNPJ := fCNPJ;
  if NaoEstaVazio(aCNPJ) then
    wCNPJ := aCNPJ;

  jBody := TACBrJSONObject.Create;
  try
    jBody.AddPair(cIMendesNomeServico, cIMendesServicoDescricaoProdutos);
    jBody.AddPair(cIMendesDadosServico, wCNPJ + '|' + aDescricao);
    sBody := jBody.ToJSON;
    RegistrarLog('Req.Body: ' + sBody);
    WriteStrToStream(HTTPSend.Document, sBody);
  finally
    jBody.Free;
  end; 

  try
    URLPathParams.Add(cIMendesAPI);
    URLPathParams.Add(cIMendesV1);
    URLPathParams.Add(cIMendesPublic);
    URLPathParams.Add(cIMendesEndpointEnviaRecebeDados);
    HTTPMethod(cHTTPMethodPOST, CalcularURL);
    Result := (HTTPResultCode = HTTP_OK);
    if Result then
      ConsultarDescricaoResponse.AsJSON := HTTPResponse
    else
      RespostaErro.AsJSON := HTTPResponse;
  except
    on E: Exception do
      raise EACBrIMendesDataSend.Create('Erro ao Consultar:' + sLineBreak + E.Message);
  end;
end;

function TACBrIMendes.ConsultarAlterados(const aUF: String; const aCNPJ: String): Boolean;
var
  jBody: TACBrJSONObject;
  wCNPJ, sBody: String;
begin
  Result := False;
  ValidarConfiguracao;

  LimparHTTP;
  HttpSend.Protocol := '1.1';
  HttpSend.MimeType := cContentTypeApplicationJSon;
  HTTPSend.Headers.Add('login: ' + fCNPJ);
  HTTPSend.Headers.Add('senha: ' + Senha);

  wCNPJ := fCNPJ;
  if NaoEstaVazio(aCNPJ) then
    wCNPJ := aCNPJ;

  jBody := TACBrJSONObject.Create;
  try
    jBody.AddPair(cIMendesNomeServico, cIMendesServicoAlterados);
    jBody.AddPair(cIMendesDadosServico, wCNPJ + '|' + aUF);
    sBody := jBody.ToJSON;
    RegistrarLog('Req.Body: ' + sBody);
    WriteStrToStream(HTTPSend.Document, sBody);
  finally
    jBody.Free;
  end;

  try
    URLPathParams.Add(cIMendesAPI);
    URLPathParams.Add(cIMendesV1);
    URLPathParams.Add(cIMendesPublic);
    URLPathParams.Add(cIMendesEndpointEnviaRecebeDados);
    HTTPMethod(cHTTPMethodPOST, CalcularURL);
    Result := (HTTPResultCode = HTTP_OK);
    if Result then
      ConsultarAlteradosResponse.AsJSON := HTTPResponse
    else
      RespostaErro.AsJSON := HTTPResponse;
  except
    on E: Exception do
      raise EACBrIMendesDataSend.Create('Erro ao Consultar:' + sLineBreak + E.Message);
  end;
end;

function TACBrIMendes.ConsultarRegimesEspeciais(const aUF: String): Boolean;
var
  jBody: TACBrJSONObject;
  sBody: String;
begin
  Result := False;
  ValidarConfiguracao;

  LimparHTTP;
  HttpSend.Protocol := '1.1';
  HTTPSend.Headers.Add('login: ' + fCNPJ);
  HTTPSend.Headers.Add('senha: ' + Senha);
  HttpSend.MimeType := cContentTypeApplicationJSon;

  jBody := TACBrJSONObject.Create;
  try
    jBody.AddPair(cIMendesDadosUF, aUF);
    sBody := jBody.ToJSON;
    RegistrarLog('Req.Body: ' + sBody);
    WriteStrToStream(HTTPSend.Document, sBody);
  finally
    jBody.Free;
  end;

  try
    URLPathParams.Add(cIMendesAPIRegimeEspecial);
    URLPathParams.Add(cIMendesEndpointEnviaRegimeEspecial);
    HTTPMethod(cHTTPMethodPOST, CalcularURL);
    Result := (HTTPResultCode = HTTP_OK);
    if Result then
      ConsultarRegimeEspecialResponse.AsJSON := HTTPResponse
    else
      RespostaErro.AsJSON := HTTPResponse;
  except
    on E: Exception do
      raise EACBrIMendesDataSend.Create('Erro ao Consultar:' + sLineBreak + E.Message);
  end;
end;

function TACBrIMendes.HistoricoAcesso(const aCNPJ: String): Boolean;
var
  wCNPJ, sBody: String;
  jBody: TACBrJSONObject;
begin
  Result := False;
  ValidarConfiguracao;

  LimparHTTP;
  HttpSend.Protocol := '1.1';
  HTTPSend.Headers.Add('login: ' + fCNPJ);
  HTTPSend.Headers.Add('senha: ' + Senha);
  HttpSend.MimeType := cContentTypeApplicationJSon;

  wCNPJ := fCNPJ;
  if NaoEstaVazio(aCNPJ) then
    wCNPJ := aCNPJ;

  jBody := TACBrJSONObject.Create;
  try
    jBody.AddPair(cIMendesNomeServico, cIMendesServicoHistoricoAcesso);
    jBody.AddPair(cIMendesDadosServico, wCNPJ);
    sBody := jBody.ToJSON;
    RegistrarLog('Req.Body: ' + sBody);
    WriteStrToStream(HTTPSend.Document, sBody);
  finally
    jBody.Free;
  end;

  try
    URLPathParams.Add(cIMendesAPI);
    URLPathParams.Add(cIMendesV1);
    URLPathParams.Add(cIMendesPublic);
    URLPathParams.Add(cIMendesEndpointEnviaRecebeDados);
    HTTPMethod(cHTTPMethodPOST, CalcularURL);
    Result := (HTTPResultCode = HTTP_OK);
    if Result then
      HistoricoAcessoResponse.AsJSON := HTTPResponse
    else
      RespostaErro.AsJSON := HTTPResponse;
  except
    on E: Exception do
      raise EACBrIMendesDataSend.Create('Erro ao Consultar:' + sLineBreak + E.Message);
  end;
end;

end. 
