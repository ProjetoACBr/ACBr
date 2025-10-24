{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{ - Elias Cesar                                                                }
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

unit ACBrCalculadoraConsumo.Schemas;

interface

uses
  Classes, SysUtils, Contnrs,
  ACBrAPIBase, ACBrJSON, ACBrBase, ACBrSocket,
  ACBrUtil.Base;

const
  cACBrCalcURL = 'https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api';
  cACBrCalcQueryParamTipo = 'tipo';
  cACBrCalcQueryParamSubtipo = 'subtipo';
  cACBrCalcEndpointUFs = 'ufs';
  cACBrCalcEndpointNCM = 'ncm';
  cACBrCalcEndpointNBS = 'nbs';
  cACBrCalcEndpointVersao = 'versao';
  cACBrCalcEndpointCbsIbs = 'cbs-ibs';
  cACBrCalcEndpointAliqUF = 'aliquota-uf';
  cACBrCalcEndpointGerarXml = 'gerar-xml';
  cACBrCalcEndpointMunicipios = 'municipios';
  cACBrCalcEndpointValidarXml = 'validar-xml';
  cACBrCalcEndpointCalculadora = 'calculadora';
  cACBrCalcEndpointRegimeGeral = 'regime-geral';
  cACBrCalcEndpointAliqUniao = 'aliquota-uniao';
  cACBrCalcEndpointBaseCalculo = 'base-calculo';
  cACBrCalcEndpointDadosAbertos = 'dados-abertos';
  cACBrCalcEndpointAliqMun = 'aliquota-municipio';
  cACBrCalcEndpointISMercadorias = 'is-mercadorias';
  cACBrCalcEndpointImpostoSeletivo = 'imposto-seletivo';
  cACBrCalcEndpointCIBSMercadorias = 'cbs-ibs-mercadorias';
  cACBrCalcEndpointSituacoesTribs = 'situacoes-tributarias';
  cACBrCalcEndpointFundamentLegais = 'fundamentacoes-legais';
  cACBrCalcEndpointClassificTribs = 'classificacoes-tributarias';

type    

  EACBrCalcAuthError = class(Exception);
  EACBrCalcDataSend = class(Exception);

  { TACBrCalcErro }
  TACBrCalcErro = class(TACBrAPISchema)
  private
    fdetail: String;
    finstance: String;
    fstatus: Integer;
    ftitle: String;
    ftype: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcErro);

    property type_: String read ftype write ftype;
    property title: String read ftitle write ftitle;
    property status: Integer read fstatus write fstatus;
    property detail: String read fdetail write fdetail;
    property instance: String read finstance write finstance;
  end;

  { TACBrCalcVersao }
  TACBrCalcVersao = class(TACBrAPISchema)
  private
    fversaoApp: String;
    fversaoDb: String;
    fdescricaoVersaoDb: String;
    fdataVersaoDb: String;
    fambiente: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcVersao);

    property versaoApp: String read fversaoApp write fversaoApp;
    property versaoDb: String read fversaoDb write fversaoDb;
    property descricaoVersaoDb: String read fdescricaoVersaoDb write fdescricaoVersaoDb;
    property dataVersaoDb: String read fdataVersaoDb write fdataVersaoDb;
    property ambiente: String read fambiente write fambiente;
  end;

  { TACBrCalcUF }
  TACBrCalcUF = class(TACBrAPISchema)
  private
    fsigla: String;
    fnome: String;
    fcodigo: Integer;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcUF);

    property sigla: String read fsigla write fsigla;
    property nome: String read fnome write fnome;
    property codigo: Integer read fcodigo write fcodigo;
  end;

  { TACBrCalcUFs }

  TACBrCalcUFs = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrCalcUF;
    procedure SetItem(Index: Integer; AValue: TACBrCalcUF);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrCalcUF): Integer;
    procedure Insert(Index: Integer; aItem: TACBrCalcUF);
    function New: TACBrCalcUF;
    property Items[Index: Integer]: TACBrCalcUF read GetItem write SetItem; default;
  end;

  { TACBrCalcMunicipio }
  TACBrCalcMunicipio = class(TACBrAPISchema)
  private
    fcodigo: Integer;
    fnome: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcMunicipio);

    property codigo: Integer read fcodigo write fcodigo;
    property nome: String read fnome write fnome;
  end;

  { TACBrCalcMunicipios }

  TACBrCalcMunicipios = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrCalcMunicipio;
    procedure SetItem(Index: Integer; AValue: TACBrCalcMunicipio);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrCalcMunicipio): Integer;
    procedure Insert(Index: Integer; aItem: TACBrCalcMunicipio);
    function New: TACBrCalcMunicipio;
    property Items[Index: Integer]: TACBrCalcMunicipio read GetItem write SetItem; default;
  end;

  { TACBrCalcSituacaoTributaria }
  TACBrCalcSituacaoTributaria = class(TACBrAPISchema)
  private
    fid: Integer;
    fcodigo: String;
    fdescricao: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcSituacaoTributaria);

    property id: Integer read fid write fid;
    property codigo: String read fcodigo write fcodigo;
    property descricao: String read fdescricao write fdescricao;
  end;

  { TACBrCalcSituacaoTributariaResponse }

  TACBrCalcSituacaoTributariaResponse = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrCalcSituacaoTributaria;
    procedure SetItem(Index: Integer; AValue: TACBrCalcSituacaoTributaria);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrCalcSituacaoTributaria): Integer;
    procedure Insert(Index: Integer; aItem: TACBrCalcSituacaoTributaria);
    function New: TACBrCalcSituacaoTributaria;
    property Items[Index: Integer]: TACBrCalcSituacaoTributaria read GetItem write SetItem; default;
  end;

  { TACBrCalcFundamentacaoLegal }

  TACBrCalcFundamentacaoLegal = class(TACBrAPISchema)
  private
    fcodigoClassificacaoTributaria: String;
    fdescricaoClassificacaoTributaria: String;
    fcodigoSituacaoTributaria: String;
    fdescricaoSituacaoTributaria: String;
    fconjuntoTributo: String;
    ftexto: String;
    ftextoCurto: String;
    freferenciaNormativa: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcFundamentacaoLegal);

    property codigoClassificacaoTributaria: String read fcodigoClassificacaoTributaria write fcodigoClassificacaoTributaria;
    property descricaoClassificacaoTributaria: String read fdescricaoClassificacaoTributaria write fdescricaoClassificacaoTributaria;
    property codigoSituacaoTributaria: String read fcodigoSituacaoTributaria write fcodigoSituacaoTributaria;
    property descricaoSituacaoTributaria: String read fdescricaoSituacaoTributaria write fdescricaoSituacaoTributaria;
    property conjuntoTributo: String read fconjuntoTributo write fconjuntoTributo;
    property texto: String read ftexto write ftexto;
    property textoCurto: String read ftextoCurto write ftextoCurto;
    property referenciaNormativa: String read freferenciaNormativa write freferenciaNormativa;
  end;

  { TACBrCalcFundamentacoesLegais }

  TACBrCalcFundamentacoesLegais = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrCalcFundamentacaoLegal;
    procedure SetItem(Index: Integer; AValue: TACBrCalcFundamentacaoLegal);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrCalcFundamentacaoLegal): Integer;
    procedure Insert(Index: Integer; aItem: TACBrCalcFundamentacaoLegal);
    function New: TACBrCalcFundamentacaoLegal;
    property Items[Index: Integer]: TACBrCalcFundamentacaoLegal read GetItem write SetItem; default;
  end;

  { TACBrCalcClassificacaoTributaria }

  TACBrCalcClassificacaoTributaria = class(TACBrAPISchema)
  private
    fcodigo: String;
    fdescricao: String;
    ftipoAliquota: String;
    fnomenclatura: String;
    fdescricaoTratamentoTributario: String;
    fincompativelComSuspensao: Boolean;
    fexigeGrupoDesoneracao: Boolean;
    fpossuiPercentualReducao: Boolean;
    findicaApropriacaoCreditoAdquirenteCbs: Boolean;
    findicaApropriacaoCreditoAdquirenteIbs: Boolean;
    findicaCreditoPresumidoFornecedor: Boolean;
    findicaCreditoPresumidoAdquirente: Boolean;
    fcreditoOperacaoAntecedente: String;
    fpercentualReducaoCbs: Double;
    fpercentualReducaoIbsUf: Double;
    fpercentualReducaoIbsMun: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcClassificacaoTributaria);

    property codigo: String read fcodigo write fcodigo;
    property descricao: String read fdescricao write fdescricao;
    property tipoAliquota: String read ftipoAliquota write ftipoAliquota;
    property nomenclatura: String read fnomenclatura write fnomenclatura;
    property descricaoTratamentoTributario: String read fdescricaoTratamentoTributario write fdescricaoTratamentoTributario;
    property incompativelComSuspensao: Boolean read fincompativelComSuspensao write fincompativelComSuspensao;
    property exigeGrupoDesoneracao: Boolean read fexigeGrupoDesoneracao write fexigeGrupoDesoneracao;
    property possuiPercentualReducao: Boolean read fpossuiPercentualReducao write fpossuiPercentualReducao;
    property indicaApropriacaoCreditoAdquirenteCbs: Boolean read findicaApropriacaoCreditoAdquirenteCbs write findicaApropriacaoCreditoAdquirenteCbs;
    property indicaApropriacaoCreditoAdquirenteIbs: Boolean read findicaApropriacaoCreditoAdquirenteIbs write findicaApropriacaoCreditoAdquirenteIbs;
    property indicaCreditoPresumidoFornecedor: Boolean read findicaCreditoPresumidoFornecedor write findicaCreditoPresumidoFornecedor;
    property indicaCreditoPresumidoAdquirente: Boolean read findicaCreditoPresumidoAdquirente write findicaCreditoPresumidoAdquirente;
    property creditoOperacaoAntecedente: String read fcreditoOperacaoAntecedente write fcreditoOperacaoAntecedente;
    property percentualReducaoCbs: Double read fpercentualReducaoCbs write fpercentualReducaoCbs;
    property percentualReducaoIbsUf: Double read fpercentualReducaoIbsUf write fpercentualReducaoIbsUf;
    property percentualReducaoIbsMun: Double read fpercentualReducaoIbsMun write fpercentualReducaoIbsMun;
  end;

  { TACBrCalcClassifTributarias }

  TACBrCalcClassifTributarias = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrCalcClassificacaoTributaria;
    procedure SetItem(Index: Integer; AValue: TACBrCalcClassificacaoTributaria);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrCalcClassificacaoTributaria): Integer;
    procedure Insert(Index: Integer; aItem: TACBrCalcClassificacaoTributaria);
    function New: TACBrCalcClassificacaoTributaria;
    property Items[Index: Integer]: TACBrCalcClassificacaoTributaria read GetItem write SetItem; default;
  end;

  { TACBrCalcNCM }
  TACBrCalcNCM = class(TACBrAPISchema)
  private
    ftributadoPeloImpostoSeletivo: Boolean;
    faliquotaAdValorem: Double;
    faliquotaAdRem: Double;
    fcapitulo: String;
    fposicao: String;
    fsubposicao: String;
    fitem: String;
    fsubitem: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcNCM);

    property tributadoPeloImpostoSeletivo: Boolean read ftributadoPeloImpostoSeletivo write ftributadoPeloImpostoSeletivo;
    property aliquotaAdValorem: Double read faliquotaAdValorem write faliquotaAdValorem;
    property aliquotaAdRem: Double read faliquotaAdRem write faliquotaAdRem;
    property capitulo: String read fcapitulo write fcapitulo;
    property posicao: String read fposicao write fposicao;
    property subposicao: String read fsubposicao write fsubposicao;
    property item: String read fitem write fitem;
    property subitem: String read fsubitem write fsubitem;
  end;

  { TACBrCalcNBS }
  TACBrCalcNBS = class(TACBrAPISchema)
  private
    ftributadoPeloImpostoSeletivo: Boolean;
    faliquotaAdValorem: Double;
    fcapitulo: String;
    fposicao: String;
    fsubposicao1: String;
    fsubposicao2: String;
    fitem: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcNBS);

    property tributadoPeloImpostoSeletivo: Boolean read ftributadoPeloImpostoSeletivo write ftributadoPeloImpostoSeletivo;
    property aliquotaAdValorem: Double read faliquotaAdValorem write faliquotaAdValorem;
    property capitulo: String read fcapitulo write fcapitulo;
    property posicao: String read fposicao write fposicao;
    property subposicao1: String read fsubposicao1 write fsubposicao1;
    property subposicao2: String read fsubposicao2 write fsubposicao2;
    property item: String read fitem write fitem;
  end;

  { TACBrCalcDevolucaoTributos }

  TACBrCalcDevolucaoTributos = class(TACBrAPISchema)
  private
    fvDevTrib: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcDevolucaoTributos);

    property vDevTrib: Double read fvDevTrib write fvDevTrib;
  end;

  { TACBrCalcDiferimento }

  TACBrCalcDiferimento = class(TACBrAPISchema)
  private
    fpDif: Double;
    fvDif: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcDiferimento);

    property pDif: Double read fpDif write fpDif;
    property vDif: Double read fvDif write fvDif;
  end;

  { TACBrCalcReducaoAliquota }

  TACBrCalcReducaoAliquota = class(TACBrAPISchema)
  private
    fpRedAliq: Double;
    fpAliqEfet: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcReducaoAliquota);

    property pRedAliq: Double read fpRedAliq write fpRedAliq;
    property pAliqEfet: Double read fpAliqEfet write fpAliqEfet;
  end;

  { TACBrCalcIBSUF }

  TACBrCalcIBSUF = class(TACBrAPISchema)
  private
    fpIBSUF: Double;
    fgDif: TACBrCalcDiferimento;
    fgDevTrib: TACBrCalcDevolucaoTributos;
    fgRed: TACBrCalcReducaoAliquota;
    fvIBSUF: Double;
    fmemoriaCalculo: String;
    function GetgDif: TACBrCalcDiferimento;
    function GetgDevTrib: TACBrCalcDevolucaoTributos;
    function GetgRed: TACBrCalcReducaoAliquota;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcIBSUF);

    property pIBSUF: Double read fpIBSUF write fpIBSUF;
    property gDif: TACBrCalcDiferimento read GetgDif;
    property gDevTrib: TACBrCalcDevolucaoTributos read GetgDevTrib;
    property gRed: TACBrCalcReducaoAliquota read GetgRed;
    property vIBSUF: Double read fvIBSUF write fvIBSUF;
    property memoriaCalculo: String read fmemoriaCalculo write fmemoriaCalculo;
  end;

  { TACBrCalcIBSMun }

  TACBrCalcIBSMun = class(TACBrAPISchema)
  private
    fpIBSMun: Double;
    fgDif: TACBrCalcDiferimento;
    fgDevTrib: TACBrCalcDevolucaoTributos;
    fgRed: TACBrCalcReducaoAliquota;
    fvIBSMun: Double;
    fmemoriaCalculo: String;
    function GetgDif: TACBrCalcDiferimento;
    function GetgDevTrib: TACBrCalcDevolucaoTributos;
    function GetgRed: TACBrCalcReducaoAliquota;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcIBSMun);

    property pIBSMun: Double read fpIBSMun write fpIBSMun;
    property gDif: TACBrCalcDiferimento read GetgDif;
    property gDevTrib: TACBrCalcDevolucaoTributos read GetgDevTrib;
    property gRed: TACBrCalcReducaoAliquota read GetgRed;
    property vIBSMun: Double read fvIBSMun write fvIBSMun;
    property memoriaCalculo: String read fmemoriaCalculo write fmemoriaCalculo;
  end;

  { TACBrCalcCBS }

  TACBrCalcCBS = class(TACBrAPISchema)
  private
    fpCBS: Double;
    fgDif: TACBrCalcDiferimento;
    fgDevTrib: TACBrCalcDevolucaoTributos;
    fgRed: TACBrCalcReducaoAliquota;
    fvCBS: Double;
    fmemoriaCalculo: String;
    function GetgDif: TACBrCalcDiferimento;
    function GetgDevTrib: TACBrCalcDevolucaoTributos;
    function GetgRed: TACBrCalcReducaoAliquota;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcCBS);

    property pCBS: Double read fpCBS write fpCBS;
    property gDif: TACBrCalcDiferimento read GetgDif;
    property gDevTrib: TACBrCalcDevolucaoTributos read GetgDevTrib;
    property gRed: TACBrCalcReducaoAliquota read GetgRed;
    property vCBS: Double read fvCBS write fvCBS;
    property memoriaCalculo: String read fmemoriaCalculo write fmemoriaCalculo;
  end;

  { TACBrCalcTributacaoRegularOut }

  TACBrCalcTributacaoRegularOut = class(TACBrAPISchema)
  private
    fCSTReg: Integer;
    fcClassTribReg: String;
    fpAliqEfetRegIBSUF: Double;
    fvTribRegIBSUF: Double;
    fpAliqEfetRegIBSMun: Double;
    fvTribRegIBSMun: Double;
    fpAliqEfetRegCBS: Double;
    fvTribRegCBS: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcTributacaoRegularOut);

    property CSTReg: Integer read fCSTReg write fCSTReg;
    property cClassTribReg: String read fcClassTribReg write fcClassTribReg;
    property pAliqEfetRegIBSUF: Double read fpAliqEfetRegIBSUF write fpAliqEfetRegIBSUF;
    property vTribRegIBSUF: Double read fvTribRegIBSUF write fvTribRegIBSUF;
    property pAliqEfetRegIBSMun: Double read fpAliqEfetRegIBSMun write fpAliqEfetRegIBSMun;
    property vTribRegIBSMun: Double read fvTribRegIBSMun write fvTribRegIBSMun;
    property pAliqEfetRegCBS: Double read fpAliqEfetRegCBS write fpAliqEfetRegCBS;
    property vTribRegCBS: Double read fvTribRegCBS write fvTribRegCBS;
  end;

  { TACBrCalcCreditoPresumido }

  TACBrCalcCreditoPresumido = class(TACBrAPISchema)
  private
    fcCredPres: Integer;
    fpCredPres: Double;
    fvCredPres: Double;
    fvCredPresCondSus: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcCreditoPresumido);

    property cCredPres: Integer read fcCredPres write fcCredPres;
    property pCredPres: Double read fpCredPres write fpCredPres;
    property vCredPres: Double read fvCredPres write fvCredPres;
    property vCredPresCondSus: Double read fvCredPresCondSus write fvCredPresCondSus;
  end;

  { TACBrCalcTransferenciaCredito }

  TACBrCalcTransferenciaCredito = class(TACBrAPISchema)
  private
    fvIBS: Double;
    fvCBS: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcTransferenciaCredito);

    property vIBS: Double read fvIBS write fvIBS;
    property vCBS: Double read fvCBS write fvCBS;
  end;

  { TACBrCalcCreditoPresumidoIBSZFM }

  TACBrCalcCreditoPresumidoIBSZFM = class(TACBrAPISchema)
  private
    ftpCredPresIBSZFM: Integer;
    fvCredPresIBSZFM: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcCreditoPresumidoIBSZFM);

    property tpCredPresIBSZFM: Integer read ftpCredPresIBSZFM write ftpCredPresIBSZFM;
    property vCredPresIBSZFM: Double read fvCredPresIBSZFM write fvCredPresIBSZFM;
  end;

  { TACBrCalcTributacaoCompraGovernamental }

  TACBrCalcTributacaoCompraGovernamental = class(TACBrAPISchema)
  private
    fpAliqIBSUF: Double;
    fvTribIBSUF: Double;
    fpAliqIBSMun: Double;
    fvTribIBSMun: Double;
    fpAliqCBS: Double;
    fvTribCBS: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcTributacaoCompraGovernamental);

    property pAliqIBSUF: Double read fpAliqIBSUF write fpAliqIBSUF;
    property vTribIBSUF: Double read fvTribIBSUF write fvTribIBSUF;
    property pAliqIBSMun: Double read fpAliqIBSMun write fpAliqIBSMun;
    property vTribIBSMun: Double read fvTribIBSMun write fvTribIBSMun;
    property pAliqCBS: Double read fpAliqCBS write fpAliqCBS;
    property vTribCBS: Double read fvTribCBS write fvTribCBS;
  end;

  { TACBrCalcGrupoIBSCBS }

  TACBrCalcGrupoIBSCBS = class(TACBrAPISchema)
  private
    fvBC: Double;
    fgIBSUF: TACBrCalcIBSUF;
    fgIBSMun: TACBrCalcIBSMun;
    fgCBS: TACBrCalcCBS;
    fgTribRegular: TACBrCalcTributacaoRegularOut;
    fgIBSCredPres: TACBrCalcCreditoPresumido;
    fgCBSCredPres: TACBrCalcCreditoPresumido;
    fgTribCompraGov: TACBrCalcTributacaoCompraGovernamental;
    function GetgIBSUF: TACBrCalcIBSUF;
    function GetgIBSMun: TACBrCalcIBSMun;
    function GetgCBS: TACBrCalcCBS;
    function GetgTribRegular: TACBrCalcTributacaoRegularOut;
    function GetgIBSCredPres: TACBrCalcCreditoPresumido;
    function GetgCBSCredPres: TACBrCalcCreditoPresumido;
    function GetgTribCompraGov: TACBrCalcTributacaoCompraGovernamental;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcGrupoIBSCBS);

    property vBC: Double read fvBC write fvBC;
    property gIBSUF: TACBrCalcIBSUF read GetgIBSUF;
    property gIBSMun: TACBrCalcIBSMun read GetgIBSMun;
    property gCBS: TACBrCalcCBS read GetgCBS;
    property gTribRegular: TACBrCalcTributacaoRegularOut read GetgTribRegular;
    property gIBSCredPres: TACBrCalcCreditoPresumido read GetgIBSCredPres;
    property gCBSCredPres: TACBrCalcCreditoPresumido read GetgCBSCredPres;
    property gTribCompraGov: TACBrCalcTributacaoCompraGovernamental read GetgTribCompraGov;
  end;

  { TACBrCalcMonofasia }

  TACBrCalcMonofasia = class(TACBrAPISchema)
  private
    fqBCMono: Double;
    fadRemIBS: Double;
    fadRemCBS: Double;
    fvIBSMono: Double;
    fvCBSMono: Double;
    fqBCMonoReten: Double;
    fadRemIBSReten: Double;
    fvIBSMonoReten: Double;
    fadRemCBSReten: Double;
    fvCBSMonoReten: Double;
    fqBCMonoRet: Double;
    fadRemIBSRet: Double;
    fvIBSMonoRet: Double;
    fadRemCBSRet: Double;
    fvCBSMonoRet: Double;
    fpDifIBS: Double;
    fvIBSMonoDif: Double;
    fpDifCBS: Double;
    fvCBSMonoDif: Double;
    fvTotIBSMonoItem: Double;
    fvTotCBSMonoItem: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcMonofasia);

    property qBCMono: Double read fqBCMono write fqBCMono;
    property adRemIBS: Double read fadRemIBS write fadRemIBS;
    property adRemCBS: Double read fadRemCBS write fadRemCBS;
    property vIBSMono: Double read fvIBSMono write fvIBSMono;
    property vCBSMono: Double read fvCBSMono write fvCBSMono;
    property qBCMonoReten: Double read fqBCMonoReten write fqBCMonoReten;
    property adRemIBSReten: Double read fadRemIBSReten write fadRemIBSReten;
    property vIBSMonoReten: Double read fvIBSMonoReten write fvIBSMonoReten;
    property adRemCBSReten: Double read fadRemCBSReten write fadRemCBSReten;
    property vCBSMonoReten: Double read fvCBSMonoReten write fvCBSMonoReten;
    property qBCMonoRet: Double read fqBCMonoRet write fqBCMonoRet;
    property adRemIBSRet: Double read fadRemIBSRet write fadRemIBSRet;
    property vIBSMonoRet: Double read fvIBSMonoRet write fvIBSMonoRet;
    property adRemCBSRet: Double read fadRemCBSRet write fadRemCBSRet;
    property vCBSMonoRet: Double read fvCBSMonoRet write fvCBSMonoRet;
    property pDifIBS: Double read fpDifIBS write fpDifIBS;
    property vIBSMonoDif: Double read fvIBSMonoDif write fvIBSMonoDif;
    property pDifCBS: Double read fpDifCBS write fpDifCBS;
    property vCBSMonoDif: Double read fvCBSMonoDif write fvCBSMonoDif;
    property vTotIBSMonoItem: Double read fvTotIBSMonoItem write fvTotIBSMonoItem;
    property vTotCBSMonoItem: Double read fvTotCBSMonoItem write fvTotCBSMonoItem;
  end;

  { TACBrCalcIBSCBS }

  TACBrCalcIBSCBS = class(TACBrAPISchema)
  private
    fCST: Integer;
    fcClassTrib: String;
    fgIBSCBS: TACBrCalcGrupoIBSCBS;
    fgIBSCBSMono: TACBrCalcMonofasia;
    fgTransfCred: TACBrCalcTransferenciaCredito;
    fgCredPresIBSZFM: TACBrCalcCreditoPresumidoIBSZFM;
    function GetgIBSCBS: TACBrCalcGrupoIBSCBS;
    function GetgIBSCBSMono: TACBrCalcMonofasia;
    function GetgTransfCred: TACBrCalcTransferenciaCredito;
    function GetgCredPresIBSZFM: TACBrCalcCreditoPresumidoIBSZFM;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcIBSCBS);

    property CST: Integer read fCST write fCST;
    property cClassTrib: String read fcClassTrib write fcClassTrib;
    property gIBSCBS: TACBrCalcGrupoIBSCBS read GetgIBSCBS;
    property gIBSCBSMono: TACBrCalcMonofasia read GetgIBSCBSMono;
    property gTransfCred: TACBrCalcTransferenciaCredito read GetgTransfCred;
    property gCredPresIBSZFM: TACBrCalcCreditoPresumidoIBSZFM read GetgCredPresIBSZFM;
  end;

  { TACBrCalcIS }

  TACBrCalcIS = class(TACBrAPISchema)
  private
    fCSTIS: Integer;
    fcClassTribIS: String;
    fvBCIS: Double;
    fpIS: Double;
    fpISEspec: Double;
    fuTrib: String;
    fqTrib: Double;
    fvIS: Double;
    fmemoriaCalculo: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcIS);

    property CSTIS: Integer read fCSTIS write fCSTIS;
    property cClassTribIS: String read fcClassTribIS write fcClassTribIS;
    property vBCIS: Double read fvBCIS write fvBCIS;
    property pIS: Double read fpIS write fpIS;
    property pISEspec: Double read fpISEspec write fpISEspec;
    property uTrib: String read fuTrib write fuTrib;
    property qTrib: Double read fqTrib write fqTrib;
    property vIS: Double read fvIS write fvIS;
    property memoriaCalculo: String read fmemoriaCalculo write fmemoriaCalculo;
  end;

  { TACBrCalcTributos }

  TACBrCalcTributos = class(TACBrAPISchema)
  private
    fIS: TACBrCalcIS;
    fIBSCBS: TACBrCalcIBSCBS;
    function GetIS: TACBrCalcIS;
    function GetIBSCBS: TACBrCalcIBSCBS;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcTributos);

    property IS_: TACBrCalcIS read GetIS;
    property IBSCBS: TACBrCalcIBSCBS read GetIBSCBS;
  end;

  { TACBrCalcIBSUFTotal }

  TACBrCalcIBSUFTotal = class(TACBrAPISchema)
  private
    fvDif: Double;
    fvDevTrib: Double;
    fvIBSUF: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcIBSUFTotal);

    property vDif: Double read fvDif write fvDif;
    property vDevTrib: Double read fvDevTrib write fvDevTrib;
    property vIBSUF: Double read fvIBSUF write fvIBSUF;
  end;

  { TACBrCalcIBSMunTotal }

  TACBrCalcIBSMunTotal = class(TACBrAPISchema)
  private
    fvDif: Double;
    fvDevTrib: Double;
    fvIBSMun: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcIBSMunTotal);

    property vDif: Double read fvDif write fvDif;
    property vDevTrib: Double read fvDevTrib write fvDevTrib;
    property vIBSMun: Double read fvIBSMun write fvIBSMun;
  end;

  { TACBrCalcCBSTotal }

  TACBrCalcCBSTotal = class(TACBrAPISchema)
  private
    fvDif: Double;
    fvDevTrib: Double;
    fvCBS: Double;
    fvCredPres: Double;
    fvCredPresCondSus: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcCBSTotal);

    property vDif: Double read fvDif write fvDif;
    property vDevTrib: Double read fvDevTrib write fvDevTrib;
    property vCBS: Double read fvCBS write fvCBS;
    property vCredPres: Double read fvCredPres write fvCredPres;
    property vCredPresCondSus: Double read fvCredPresCondSus write fvCredPresCondSus;
  end;

  { TACBrCalcIBSTotal }

  TACBrCalcIBSTotal = class(TACBrAPISchema)
  private
    fgIBSUF: TACBrCalcIBSUFTotal;
    fgIBSMun: TACBrCalcIBSMunTotal;
    fvIBS: Double;
    fvCredPres: Double;
    fvCredPresCondSus: Double;
    function GetgIBSUF: TACBrCalcIBSUFTotal;
    function GetgIBSMun: TACBrCalcIBSMunTotal;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcIBSTotal);

    property gIBSUF: TACBrCalcIBSUFTotal read GetgIBSUF;
    property gIBSMun: TACBrCalcIBSMunTotal read GetgIBSMun;
    property vIBS: Double read fvIBS write fvIBS;
    property vCredPres: Double read fvCredPres write fvCredPres;
    property vCredPresCondSus: Double read fvCredPresCondSus write fvCredPresCondSus;
  end;

  { TACBrCalcMonofasiaTotal }

  TACBrCalcMonofasiaTotal = class(TACBrAPISchema)
  private
    fvIBSMono: Double;
    fvCBSMono: Double;
    fvIBSMonoReten: Double;
    fvCBSMonoReten: Double;
    fvIBSMonoRet: Double;
    fvCBSMonoRet: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcMonofasiaTotal);

    property vIBSMono: Double read fvIBSMono write fvIBSMono;
    property vCBSMono: Double read fvCBSMono write fvCBSMono;
    property vIBSMonoReten: Double read fvIBSMonoReten write fvIBSMonoReten;
    property vCBSMonoReten: Double read fvCBSMonoReten write fvCBSMonoReten;
    property vIBSMonoRet: Double read fvIBSMonoRet write fvIBSMonoRet;
    property vCBSMonoRet: Double read fvCBSMonoRet write fvCBSMonoRet;
  end;

  { TACBrCalcIBSCBSTotal }

  TACBrCalcIBSCBSTotal = class(TACBrAPISchema)
  private
    fvBCIBSCBS: Double;
    fgIBS: TACBrCalcIBSTotal;
    fgCBS: TACBrCalcCBSTotal;
    fgMono: TACBrCalcMonofasiaTotal;
    function GetgIBS: TACBrCalcIBSTotal;
    function GetgCBS: TACBrCalcCBSTotal;
    function GetgMono: TACBrCalcMonofasiaTotal;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcIBSCBSTotal);

    property vBCIBSCBS: Double read fvBCIBSCBS write fvBCIBSCBS;
    property gIBS: TACBrCalcIBSTotal read GetgIBS;
    property gCBS: TACBrCalcCBSTotal read GetgCBS;
    property gMono: TACBrCalcMonofasiaTotal read GetgMono;
  end;

  { TACBrCalcISTotal }

  TACBrCalcISTotal = class(TACBrAPISchema)
  private
    fvIS: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcISTotal);

    property vIS: Double read fvIS write fvIS;
  end;

  { TACBrCalcTributosTotais }

  TACBrCalcTributosTotais = class(TACBrAPISchema)
  private
    fISTot: TACBrCalcISTotal;
    fIBSCBSTot: TACBrCalcIBSCBSTotal;
    function GetISTot: TACBrCalcISTotal;
    function GetIBSCBSTot: TACBrCalcIBSCBSTotal;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcTributosTotais);

    property ISTot: TACBrCalcISTotal read GetISTot;
    property IBSCBSTot: TACBrCalcIBSCBSTotal read GetIBSCBSTot;
  end;

  { TACBrCalcValoresTotais }

  TACBrCalcValoresTotais = class(TACBrAPISchema)
  private
    ftribCalc: TACBrCalcTributosTotais;
    function GetTribCalc: TACBrCalcTributosTotais;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcValoresTotais);

    property tribCalc: TACBrCalcTributosTotais read GetTribCalc;
  end;

  { TACBrCalcObjeto }

  TACBrCalcObjeto = class(TACBrAPISchema)
  private
    fnObj: Integer;
    ftribCalc: TACBrCalcTributos;
    function GettribCalc: TACBrCalcTributos;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcObjeto);

    property nObj: Integer read fnObj write fnObj;
    property tribCalc: TACBrCalcTributos read GettribCalc;
  end;

  { TACBrCalcObjetos }

  TACBrCalcObjetos = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrCalcObjeto;
    procedure SetItem(Index: Integer; AValue: TACBrCalcObjeto);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrCalcObjeto): Integer;
    procedure Insert(Index: Integer; aItem: TACBrCalcObjeto);
    function New: TACBrCalcObjeto;
    property Items[Index: Integer]: TACBrCalcObjeto read GetItem write SetItem; default;
  end;

  { TACBrCalcROC }

  TACBrCalcROC = class(TACBrAPISchema)
  private
    fobjetos: TACBrCalcObjetos;
    ftotal: TACBrCalcValoresTotais;
    function GetObjetos: TACBrCalcObjetos;
    function GetTotal: TACBrCalcValoresTotais;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcROC);

    property objetos: TACBrCalcObjetos read GetObjetos;
    property total: TACBrCalcValoresTotais read GetTotal;
  end;

  { TACBrCalcAliquota }

  TACBrCalcAliquota = class(TACBrAPISchema)
  private
    faliquotaReferencia: Double;
    faliquotaPropria: Double;
    fformaAplicacao: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcAliquota);

    property aliquotaReferencia: Double read faliquotaReferencia write faliquotaReferencia;
    property aliquotaPropria: Double read faliquotaPropria write faliquotaPropria;
    property formaAplicacao: String read fformaAplicacao write fformaAplicacao;
  end;

  { TACBrCalcBCCIBSMercadorias }

  TACBrCalcBCCIBSMercadorias = class(TACBrAPISchema)
  private
    fvalorFornecimento: Double;
    fajusteValorOperacao: Double;
    fjuros: Double;
    fmultas: Double;
    facrescimos: Double;
    fencargos: Double;
    fdescontosCondicionais: Double;
    ffretePorDentro: Double;
    foutrosTributos: Double;
    fimpostoSeletivo: Double;
    fdemaisImportancias: Double;
    ficms: Double;
    fiss: Double;
    fpis: Double;
    fcofins: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcBCCIBSMercadorias);

    property valorFornecimento: Double read fvalorFornecimento write fvalorFornecimento;
    property ajusteValorOperacao: Double read fajusteValorOperacao write fajusteValorOperacao;
    property juros: Double read fjuros write fjuros;
    property multas: Double read fmultas write fmultas;
    property acrescimos: Double read facrescimos write facrescimos;
    property encargos: Double read fencargos write fencargos;
    property descontosCondicionais: Double read fdescontosCondicionais write fdescontosCondicionais;
    property fretePorDentro: Double read ffretePorDentro write ffretePorDentro;
    property outrosTributos: Double read foutrosTributos write foutrosTributos;
    property impostoSeletivo: Double read fimpostoSeletivo write fimpostoSeletivo;
    property demaisImportancias: Double read fdemaisImportancias write fdemaisImportancias;
    property icms: Double read ficms write ficms;
    property iss: Double read fiss write fiss;
    property pis: Double read fpis write fpis;
    property cofins: Double read fcofins write fcofins;
  end;

  { TACBrCalcBCISMercadorias }

  TACBrCalcBCISMercadorias = class(TACBrAPISchema)
  private
    fvalorIntegralCobrado: Double;
    fajusteValorOperacaoIS: Double;
    fjurosIS: Double;
    fmultasIS: Double;
    facrescimosIS: Double;
    fencargosIS: Double;
    fdescontosCondicionaisIS: Double;
    ffretePorDentroIS: Double;
    foutrosTributosIS: Double;
    fdemaisImportanciasIS: Double;
    ficmsIS: Double;
    fissIS: Double;
    fpisIS: Double;
    fcofinsIS: Double;
    fbonificacao: Double;
    fdevolucaoVendas: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcBCISMercadorias);

    property valorIntegralCobrado: Double read fvalorIntegralCobrado write fvalorIntegralCobrado;
    property ajusteValorOperacao: Double read fajusteValorOperacaoIS write fajusteValorOperacaoIS;
    property juros: Double read fjurosIS write fjurosIS;
    property multas: Double read fmultasIS write fmultasIS;
    property acrescimos: Double read facrescimosIS write facrescimosIS;
    property encargos: Double read fencargosIS write fencargosIS;
    property descontosCondicionais: Double read fdescontosCondicionaisIS write fdescontosCondicionaisIS;
    property fretePorDentro: Double read ffretePorDentroIS write ffretePorDentroIS;
    property outrosTributos: Double read foutrosTributosIS write foutrosTributosIS;
    property demaisImportancias: Double read fdemaisImportanciasIS write fdemaisImportanciasIS;
    property icms: Double read ficmsIS write ficmsIS;
    property iss: Double read fissIS write fissIS;
    property pis: Double read fpisIS write fpisIS;
    property cofins: Double read fcofinsIS write fcofinsIS;
    property bonificacao: Double read fbonificacao write fbonificacao;
    property devolucaoVendas: Double read fdevolucaoVendas write fdevolucaoVendas;
  end;

  { TACBrCalcBaseCalculoModel }

  TACBrCalcBaseCalculoModel = class(TACBrAPISchema)
  private
    fbaseCalculo: Double;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcBaseCalculoModel);

    property baseCalculo: Double read fbaseCalculo write fbaseCalculo;
  end;

  { TACBrCalcImpostoSeletivo }

  TACBrCalcImpostoSeletivo = class(TACBrAPISchema)
  private
    fcst: String;
    fbaseCalculo: Double;
    fquantidade: Double;
    funidade: String;
    fimpostoInformado: Double;
    fcClassTrib: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcImpostoSeletivo);

    property cst: String read fcst write fcst;
    property baseCalculo: Double read fbaseCalculo write fbaseCalculo;
    property quantidade: Double read fquantidade write fquantidade;
    property unidade: String read funidade write funidade;
    property impostoInformado: Double read fimpostoInformado write fimpostoInformado;
    property cClassTrib: String read fcClassTrib write fcClassTrib;
  end;

  { TACBrCalcTributacaoRegular }

  TACBrCalcTributacaoRegular = class(TACBrAPISchema)
  private
    fcst: String;
    fcClassTrib: String;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcTributacaoRegular);

    property cst: String read fcst write fcst;
    property cClassTrib: String read fcClassTrib write fcClassTrib;
  end;

  { TACBrCalcItemOperacao }

  TACBrCalcOperacaoItem = class(TACBrAPISchema)
  private
    fnumero: Integer;
    fncm: String;
    fnbs: String;
    fcst: String;
    fbaseCalculo: Double;
    fquantidade: Double;
    funidade: String;
    fimpostoSeletivo: TACBrCalcImpostoSeletivo;
    ftributacaoRegular: TACBrCalcTributacaoRegular;
    fcClassTrib: String;
    function GetImpostoSeletivo: TACBrCalcImpostoSeletivo;
    function GetTributacaoRegular: TACBrCalcTributacaoRegular;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcOperacaoItem);

    property numero: Integer read fnumero write fnumero;
    property ncm: String read fncm write fncm;
    property nbs: String read fnbs write fnbs;
    property cst: String read fcst write fcst;
    property baseCalculo: Double read fbaseCalculo write fbaseCalculo;
    property quantidade: Double read fquantidade write fquantidade;
    property unidade: String read funidade write funidade;
    property impostoSeletivo: TACBrCalcImpostoSeletivo read GetImpostoSeletivo;
    property tributacaoRegular: TACBrCalcTributacaoRegular read GetTributacaoRegular;
    property cClassTrib: String read fcClassTrib write fcClassTrib;
  end;

  { TACBrCalcOperacaoItens }

  TACBrCalcOperacaoItens = class(TACBrAPISchemaArray)
  private
    function GetItem(Index: Integer): TACBrCalcOperacaoItem;
    procedure SetItem(Index: Integer; AValue: TACBrCalcOperacaoItem);
  protected
    function NewSchema: TACBrAPISchema; override;
  public
    function Add(aItem: TACBrCalcOperacaoItem): Integer;
    procedure Insert(Index: Integer; aItem: TACBrCalcOperacaoItem);
    function New: TACBrCalcOperacaoItem;
    property Items[Index: Integer]: TACBrCalcOperacaoItem read GetItem write SetItem; default;
  end;

  { TACBrCalcOperacao }

  TACBrCalcOperacao = class(TACBrAPISchema)
  private
    fid: String;
    fversao: String;
    fdataHoraEmissao: TDateTime;
    fmunicipio: Integer;
    fuf: String;
    fitens: TACBrCalcOperacaoItens;
    function GetItens: TACBrCalcOperacaoItens;
  protected
    procedure AssignSchema(aSource: TACBrAPISchema); override;
    procedure DoWriteToJSon(aJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(aJSon: TACBrJSONObject); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrCalcOperacao);

    property id: String read fid write fid;
    property versao: String read fversao write fversao;
    property dataHoraEmissao: TDateTime read fdataHoraEmissao write fdataHoraEmissao;
    property municipio: Integer read fmunicipio write fmunicipio;
    property uf: String read fuf write fuf;
    property itens: TACBrCalcOperacaoItens read GetItens;
  end;

implementation

uses
  StrUtils, synautil,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime;

{ TACBrCalcErro }

procedure TACBrCalcErro.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcErro) then
    Assign(TACBrCalcErro(aSource));
end;

procedure TACBrCalcErro.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('type', ftype, False)
    .AddPair('title', ftitle, False)
    .AddPair('status', fstatus)
    .AddPair('detail', fdetail, False)
    .AddPair('instance', finstance, False);
end;

procedure TACBrCalcErro.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('type', ftype)
    .Value('title', ftitle)
    .Value('status', fstatus)
    .Value('detail', fdetail)
    .Value('instance', finstance);
end;

procedure TACBrCalcErro.Clear;
begin
  ftype := EmptyStr;
  ftitle := EmptyStr;
  fstatus := 0;
  fdetail := EmptyStr;
  finstance := EmptyStr;
end;

function TACBrCalcErro.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(ftype) and
    EstaVazio(ftitle) and
    EstaZerado(fstatus) and
    EstaVazio(fdetail) and
    EstaVazio(finstance);
end;

procedure TACBrCalcErro.Assign(Source: TACBrCalcErro);
begin
  if not Assigned(Source) then
    Exit;

  ftype := Source.type_;
  ftitle := Source.title;
  fstatus := Source.status;
  fdetail := Source.detail;
  finstance := Source.instance;
end;

{ TACBrCalcVersao }

procedure TACBrCalcVersao.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcVersao) then
    Assign(TACBrCalcVersao(aSource));
end;

procedure TACBrCalcVersao.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('versaoApp', fversaoApp, False)
    .AddPair('versaoDb', fversaoDb, False)
    .AddPair('descricaoVersaoDb', fdescricaoVersaoDb, False)
    .AddPair('dataVersaoDb', fdataVersaoDb, False)
    .AddPair('ambiente', fambiente, False);
end;

procedure TACBrCalcVersao.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('versaoApp', fversaoApp)
    .Value('versaoDb', fversaoDb)
    .Value('descricaoVersaoDb', fdescricaoVersaoDb)
    .Value('dataVersaoDb', fdataVersaoDb)
    .Value('ambiente', fambiente);
end;

procedure TACBrCalcVersao.Clear;
begin
  fversaoApp := EmptyStr;
  fversaoDb := EmptyStr;
  fdescricaoVersaoDb := EmptyStr;
  fdataVersaoDb := EmptyStr;
  fambiente := EmptyStr;
end;

function TACBrCalcVersao.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fversaoApp) and
    EstaVazio(fversaoDb) and
    EstaVazio(fdescricaoVersaoDb) and
    EstaVazio(fdataVersaoDb) and
    EstaVazio(fambiente);
end;

procedure TACBrCalcVersao.Assign(Source: TACBrCalcVersao);
begin
  if not Assigned(Source) then
    Exit;

  fversaoApp := Source.versaoApp;
  fversaoDb := Source.versaoDb;
  fdescricaoVersaoDb := Source.descricaoVersaoDb;
  fdataVersaoDb := Source.dataVersaoDb;
  fambiente := Source.ambiente;
end;

{ TACBrCalcUF }

procedure TACBrCalcUF.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcUF) then
    Assign(TACBrCalcUF(aSource));
end;

procedure TACBrCalcUF.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('sigla', fsigla, False)
    .AddPair('nome', fnome, False)
    .AddPair('codigo', fcodigo);
end;

procedure TACBrCalcUF.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('sigla', fsigla)
    .Value('nome', fnome)
    .Value('codigo', fcodigo);
end;

procedure TACBrCalcUF.Clear;
begin
  fsigla := EmptyStr;
  fnome := EmptyStr;
  fcodigo := 0;
end;

function TACBrCalcUF.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fsigla) and
    EstaVazio(fnome) and
    EstaZerado(fcodigo);
end;

procedure TACBrCalcUF.Assign(Source: TACBrCalcUF);
begin
  if not Assigned(Source) then
    Exit;

  fsigla := Source.sigla;
  fnome := Source.nome;
  fcodigo := Source.codigo;
end;

{ TACBrCalcUFs }

function TACBrCalcUFs.GetItem(Index: Integer): TACBrCalcUF;
begin
  Result := TACBrCalcUF(inherited Items[Index]);
end;

procedure TACBrCalcUFs.SetItem(Index: Integer; AValue: TACBrCalcUF);
begin
  inherited Items[Index] := aValue;
end;

function TACBrCalcUFs.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrCalcUFs.Add(aItem: TACBrCalcUF): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrCalcUFs.Insert(Index: Integer; aItem: TACBrCalcUF);
begin
  inherited Insert(Index, aItem);
end;

function TACBrCalcUFs.New: TACBrCalcUF;
begin
  Result := TACBrCalcUF.Create;
  Self.Add(Result);
end;

{ TACBrCalcMunicipio }

procedure TACBrCalcMunicipio.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcMunicipio) then
    Assign(TACBrCalcMunicipio(aSource));
end;

procedure TACBrCalcMunicipio.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('codigo', fcodigo)
    .AddPair('nome', fnome, False);
end;

procedure TACBrCalcMunicipio.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('codigo', fcodigo)
    .Value('nome', fnome);
end;

procedure TACBrCalcMunicipio.Clear;
begin
  fcodigo := 0;
  fnome := EmptyStr;
end;

function TACBrCalcMunicipio.IsEmpty: Boolean;
begin
  Result := EstaZerado(fcodigo) and EstaVazio(fnome);
end;

procedure TACBrCalcMunicipio.Assign(Source: TACBrCalcMunicipio);
begin
  if not Assigned(Source) then
    Exit;

  fcodigo := Source.codigo;
  fnome := Source.nome;
end;

{ TACBrCalcMunicipios }

function TACBrCalcMunicipios.GetItem(Index: Integer): TACBrCalcMunicipio;
begin
  Result := TACBrCalcMunicipio(inherited Items[Index]);
end;

procedure TACBrCalcMunicipios.SetItem(Index: Integer; AValue: TACBrCalcMunicipio);
begin
  inherited Items[Index] := aValue;
end;

function TACBrCalcMunicipios.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrCalcMunicipios.Add(aItem: TACBrCalcMunicipio): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrCalcMunicipios.Insert(Index: Integer; aItem: TACBrCalcMunicipio);
begin
  inherited Insert(Index, aItem);
end;

function TACBrCalcMunicipios.New: TACBrCalcMunicipio;
begin
  Result := TACBrCalcMunicipio.Create;
  Self.Add(Result);
end;

{ TACBrCalcSituacaoTributaria }

procedure TACBrCalcSituacaoTributaria.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcSituacaoTributaria) then
    Assign(TACBrCalcSituacaoTributaria(aSource));
end;

procedure TACBrCalcSituacaoTributaria.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('id', fid)
    .AddPair('codigo', fcodigo, False)
    .AddPair('descricao', fdescricao, False);
end;

procedure TACBrCalcSituacaoTributaria.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('id', fid)
    .Value('codigo', fcodigo)
    .Value('descricao', fdescricao);
end;

procedure TACBrCalcSituacaoTributaria.Clear;
begin
  fid := 0;
  fcodigo := EmptyStr;
  fdescricao := EmptyStr;
end;

function TACBrCalcSituacaoTributaria.IsEmpty: Boolean;
begin
  Result := EstaZerado(fid) and EstaVazio(fcodigo) and EstaVazio(fdescricao);
end;

procedure TACBrCalcSituacaoTributaria.Assign(Source: TACBrCalcSituacaoTributaria);
begin
  if not Assigned(Source) then
    Exit;

  fid := Source.id;
  fcodigo := Source.codigo;
  fdescricao := Source.descricao;
end;

{ TACBrCalcSituacaoTributariaResponse }

function TACBrCalcSituacaoTributariaResponse.GetItem(Index: Integer): TACBrCalcSituacaoTributaria;
begin
  Result := TACBrCalcSituacaoTributaria(inherited Items[Index]);
end;

{ TACBrCalcClassificacaoTributaria }

procedure TACBrCalcClassificacaoTributaria.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcClassificacaoTributaria) then
    Assign(TACBrCalcClassificacaoTributaria(aSource));
end;

procedure TACBrCalcClassificacaoTributaria.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('codigo', fcodigo, False)
    .AddPair('descricao', fdescricao, False)
    .AddPair('tipoAliquota', ftipoAliquota, False)
    .AddPair('nomenclatura', fnomenclatura, False)
    .AddPair('descricaoTratamentoTributario', fdescricaoTratamentoTributario, False)
    .AddPair('incompativelComSuspensao', fincompativelComSuspensao)
    .AddPair('exigeGrupoDesoneracao', fexigeGrupoDesoneracao)
    .AddPair('possuiPercentualReducao', fpossuiPercentualReducao)
    .AddPair('indicaApropriacaoCreditoAdquirenteCbs', findicaApropriacaoCreditoAdquirenteCbs)
    .AddPair('indicaApropriacaoCreditoAdquirenteIbs', findicaApropriacaoCreditoAdquirenteIbs)
    .AddPair('indicaCreditoPresumidoFornecedor', findicaCreditoPresumidoFornecedor)
    .AddPair('indicaCreditoPresumidoAdquirente', findicaCreditoPresumidoAdquirente)
    .AddPair('creditoOperacaoAntecedente', fcreditoOperacaoAntecedente, False)
    .AddPair('percentualReducaoCbs', fpercentualReducaoCbs)
    .AddPair('percentualReducaoIbsUf', fpercentualReducaoIbsUf)
    .AddPair('percentualReducaoIbsMun', fpercentualReducaoIbsMun);
end;

procedure TACBrCalcClassificacaoTributaria.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('codigo', fcodigo)
    .Value('descricao', fdescricao)
    .Value('tipoAliquota', ftipoAliquota)
    .Value('nomenclatura', fnomenclatura)
    .Value('descricaoTratamentoTributario', fdescricaoTratamentoTributario)
    .Value('incompativelComSuspensao', fincompativelComSuspensao)
    .Value('exigeGrupoDesoneracao', fexigeGrupoDesoneracao)
    .Value('possuiPercentualReducao', fpossuiPercentualReducao)
    .Value('indicaApropriacaoCreditoAdquirenteCbs', findicaApropriacaoCreditoAdquirenteCbs)
    .Value('indicaApropriacaoCreditoAdquirenteIbs', findicaApropriacaoCreditoAdquirenteIbs)
    .Value('indicaCreditoPresumidoFornecedor', findicaCreditoPresumidoFornecedor)
    .Value('indicaCreditoPresumidoAdquirente', findicaCreditoPresumidoAdquirente)
    .Value('creditoOperacaoAntecedente', fcreditoOperacaoAntecedente)
    .Value('percentualReducaoCbs', fpercentualReducaoCbs)
    .Value('percentualReducaoIbsUf', fpercentualReducaoIbsUf)
    .Value('percentualReducaoIbsMun', fpercentualReducaoIbsMun);
end;

procedure TACBrCalcClassificacaoTributaria.Clear;
begin
  fcodigo := EmptyStr;
  fdescricao := EmptyStr;
  ftipoAliquota := EmptyStr;
  fnomenclatura := EmptyStr;
  fdescricaoTratamentoTributario := EmptyStr;
  fincompativelComSuspensao := False;
  fexigeGrupoDesoneracao := False;
  fpossuiPercentualReducao := False;
  findicaApropriacaoCreditoAdquirenteCbs := False;
  findicaApropriacaoCreditoAdquirenteIbs := False;
  findicaCreditoPresumidoFornecedor := False;
  findicaCreditoPresumidoAdquirente := False;
  fcreditoOperacaoAntecedente := EmptyStr;
  fpercentualReducaoCbs := 0;
  fpercentualReducaoIbsUf := 0;
  fpercentualReducaoIbsMun := 0;
end;

function TACBrCalcClassificacaoTributaria.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcodigo) and
    EstaVazio(fdescricao) and
    EstaVazio(ftipoAliquota) and
    EstaVazio(fnomenclatura) and
    EstaVazio(fdescricaoTratamentoTributario) and
    not fincompativelComSuspensao and
    not fexigeGrupoDesoneracao and
    not fpossuiPercentualReducao and
    not findicaApropriacaoCreditoAdquirenteCbs and
    not findicaApropriacaoCreditoAdquirenteIbs and
    not findicaCreditoPresumidoFornecedor and
    not findicaCreditoPresumidoAdquirente and
    EstaVazio(fcreditoOperacaoAntecedente) and
    EstaZerado(fpercentualReducaoCbs) and
    EstaZerado(fpercentualReducaoIbsUf) and
    EstaZerado(fpercentualReducaoIbsMun);
end;

procedure TACBrCalcClassificacaoTributaria.Assign(Source: TACBrCalcClassificacaoTributaria);
begin
  if not Assigned(Source) then
    Exit;

  fcodigo := Source.codigo;
  fdescricao := Source.descricao;
  ftipoAliquota := Source.tipoAliquota;
  fnomenclatura := Source.nomenclatura;
  fdescricaoTratamentoTributario := Source.descricaoTratamentoTributario;
  fincompativelComSuspensao := Source.incompativelComSuspensao;
  fexigeGrupoDesoneracao := Source.exigeGrupoDesoneracao;
  fpossuiPercentualReducao := Source.possuiPercentualReducao;
  findicaApropriacaoCreditoAdquirenteCbs := Source.indicaApropriacaoCreditoAdquirenteCbs;
  findicaApropriacaoCreditoAdquirenteIbs := Source.indicaApropriacaoCreditoAdquirenteIbs;
  findicaCreditoPresumidoFornecedor := Source.indicaCreditoPresumidoFornecedor;
  findicaCreditoPresumidoAdquirente := Source.indicaCreditoPresumidoAdquirente;
  fcreditoOperacaoAntecedente := Source.creditoOperacaoAntecedente;
  fpercentualReducaoCbs := Source.percentualReducaoCbs;
  fpercentualReducaoIbsUf := Source.percentualReducaoIbsUf;
  fpercentualReducaoIbsMun := Source.percentualReducaoIbsMun;
end;

{ TACBrCalcClassifTributarias }

function TACBrCalcClassifTributarias.GetItem(Index: Integer): TACBrCalcClassificacaoTributaria;
begin
  Result := TACBrCalcClassificacaoTributaria(inherited Items[Index]);
end;

procedure TACBrCalcClassifTributarias.SetItem(Index: Integer; AValue: TACBrCalcClassificacaoTributaria);
begin
  inherited Items[Index] := aValue;
end;

function TACBrCalcClassifTributarias.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrCalcClassifTributarias.Add(aItem: TACBrCalcClassificacaoTributaria): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrCalcClassifTributarias.Insert(Index: Integer; aItem: TACBrCalcClassificacaoTributaria);
begin
  inherited Insert(Index, aItem);
end;

function TACBrCalcClassifTributarias.New: TACBrCalcClassificacaoTributaria;
begin
  Result := TACBrCalcClassificacaoTributaria.Create;
  Self.Add(Result);
end;

procedure TACBrCalcSituacaoTributariaResponse.SetItem(Index: Integer; AValue: TACBrCalcSituacaoTributaria);
begin
  inherited Items[Index] := aValue;
end;

function TACBrCalcSituacaoTributariaResponse.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrCalcSituacaoTributariaResponse.Add(aItem: TACBrCalcSituacaoTributaria): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrCalcSituacaoTributariaResponse.Insert(Index: Integer; aItem: TACBrCalcSituacaoTributaria);
begin
  inherited Insert(Index, aItem);
end;

function TACBrCalcSituacaoTributariaResponse.New: TACBrCalcSituacaoTributaria;
begin
  Result := TACBrCalcSituacaoTributaria.Create;
  Self.Add(Result);
end;

{ TACBrCalcFundamentacaoLegal }

procedure TACBrCalcFundamentacaoLegal.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcFundamentacaoLegal) then
    Assign(TACBrCalcFundamentacaoLegal(aSource));
end;

procedure TACBrCalcFundamentacaoLegal.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('codigoClassificacaoTributaria', fcodigoClassificacaoTributaria, False)
    .AddPair('descricaoClassificacaoTributaria', fdescricaoClassificacaoTributaria, False)
    .AddPair('codigoSituacaoTributaria', fcodigoSituacaoTributaria, False)
    .AddPair('descricaoSituacaoTributaria', fdescricaoSituacaoTributaria, False)
    .AddPair('conjuntoTributo', fconjuntoTributo, False)
    .AddPair('texto', ftexto, False)
    .AddPair('textoCurto', ftextoCurto, False)
    .AddPair('referenciaNormativa', freferenciaNormativa, False);
end;

procedure TACBrCalcFundamentacaoLegal.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('codigoClassificacaoTributaria', fcodigoClassificacaoTributaria)
    .Value('descricaoClassificacaoTributaria', fdescricaoClassificacaoTributaria)
    .Value('codigoSituacaoTributaria', fcodigoSituacaoTributaria)
    .Value('descricaoSituacaoTributaria', fdescricaoSituacaoTributaria)
    .Value('conjuntoTributo', fconjuntoTributo)
    .Value('texto', ftexto)
    .Value('textoCurto', ftextoCurto)
    .Value('referenciaNormativa', freferenciaNormativa);
end;

procedure TACBrCalcFundamentacaoLegal.Clear;
begin
  fcodigoClassificacaoTributaria := EmptyStr;
  fdescricaoClassificacaoTributaria := EmptyStr;
  fcodigoSituacaoTributaria := EmptyStr;
  fdescricaoSituacaoTributaria := EmptyStr;
  fconjuntoTributo := EmptyStr;
  ftexto := EmptyStr;
  ftextoCurto := EmptyStr;
  freferenciaNormativa := EmptyStr;
end;

function TACBrCalcFundamentacaoLegal.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcodigoClassificacaoTributaria) and
    EstaVazio(fdescricaoClassificacaoTributaria) and
    EstaVazio(fcodigoSituacaoTributaria) and
    EstaVazio(fdescricaoSituacaoTributaria) and
    EstaVazio(fconjuntoTributo) and
    EstaVazio(ftexto) and
    EstaVazio(ftextoCurto) and
    EstaVazio(freferenciaNormativa);
end;

procedure TACBrCalcFundamentacaoLegal.Assign(Source: TACBrCalcFundamentacaoLegal);
begin
  if not Assigned(Source) then
    Exit;

  fcodigoClassificacaoTributaria := Source.codigoClassificacaoTributaria;
  fdescricaoClassificacaoTributaria := Source.descricaoClassificacaoTributaria;
  fcodigoSituacaoTributaria := Source.codigoSituacaoTributaria;
  fdescricaoSituacaoTributaria := Source.descricaoSituacaoTributaria;
  fconjuntoTributo := Source.conjuntoTributo;
  ftexto := Source.texto;
  ftextoCurto := Source.textoCurto;
  freferenciaNormativa := Source.referenciaNormativa;
end;

{ TACBrCalcFundamentacoesLegais }

function TACBrCalcFundamentacoesLegais.GetItem(Index: Integer): TACBrCalcFundamentacaoLegal;
begin
  Result := TACBrCalcFundamentacaoLegal(inherited Items[Index]);
end;

procedure TACBrCalcFundamentacoesLegais.SetItem(Index: Integer; AValue: TACBrCalcFundamentacaoLegal);
begin
  inherited Items[Index] := aValue;
end;

function TACBrCalcFundamentacoesLegais.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrCalcFundamentacoesLegais.Add(aItem: TACBrCalcFundamentacaoLegal): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrCalcFundamentacoesLegais.Insert(Index: Integer; aItem: TACBrCalcFundamentacaoLegal);
begin
  inherited Insert(Index, aItem);
end;

function TACBrCalcFundamentacoesLegais.New: TACBrCalcFundamentacaoLegal;
begin
  Result := TACBrCalcFundamentacaoLegal.Create;
  Self.Add(Result);
end;

{ TACBrCalcNCM }

procedure TACBrCalcNCM.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcNCM) then
    Assign(TACBrCalcNCM(aSource));
end;

procedure TACBrCalcNCM.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('tributadoPeloImpostoSeletivo', ftributadoPeloImpostoSeletivo)
    .AddPair('aliquotaAdValorem', faliquotaAdValorem, False)
    .AddPair('aliquotaAdRem', faliquotaAdRem, False)
    .AddPair('capitulo', fcapitulo, False)
    .AddPair('posicao', fposicao, False)
    .AddPair('subposicao', fsubposicao, False)
    .AddPair('item', fitem, False)
    .AddPair('subitem', fsubitem, False);
end;

procedure TACBrCalcNCM.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('tributadoPeloImpostoSeletivo', ftributadoPeloImpostoSeletivo)
    .Value('aliquotaAdValorem', faliquotaAdValorem)
    .Value('aliquotaAdRem', faliquotaAdRem)
    .Value('capitulo', fcapitulo)
    .Value('posicao', fposicao)
    .Value('subposicao', fsubposicao)
    .Value('item', fitem)
    .Value('subitem', fsubitem);
end;

procedure TACBrCalcNCM.Clear;
begin
  ftributadoPeloImpostoSeletivo := False;
  faliquotaAdValorem := 0;
  faliquotaAdRem := 0;
  fcapitulo := EmptyStr;
  fposicao := EmptyStr;
  fsubposicao := EmptyStr;
  fitem := EmptyStr;
  fsubitem := EmptyStr;
end;

function TACBrCalcNCM.IsEmpty: Boolean;
begin
  Result :=
    not ftributadoPeloImpostoSeletivo and
    EstaZerado(faliquotaAdValorem) and
    EstaZerado(faliquotaAdRem) and
    EstaVazio(fcapitulo) and
    EstaVazio(fposicao) and
    EstaVazio(fsubposicao) and
    EstaVazio(fitem) and
    EstaVazio(fsubitem);
end;

procedure TACBrCalcNCM.Assign(Source: TACBrCalcNCM);
begin
  if not Assigned(Source) then
    Exit;

  ftributadoPeloImpostoSeletivo := Source.tributadoPeloImpostoSeletivo;
  faliquotaAdValorem := Source.aliquotaAdValorem;
  faliquotaAdRem := Source.aliquotaAdRem;
  fcapitulo := Source.capitulo;
  fposicao := Source.posicao;
  fsubposicao := Source.subposicao;
  fitem := Source.item;
  fsubitem := Source.subitem;
end;

{ TACBrCalcNBS }

procedure TACBrCalcNBS.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcNBS) then
    Assign(TACBrCalcNBS(aSource));
end;

{ TACBrCalcBaseCalculoModel }

procedure TACBrCalcBaseCalculoModel.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcBaseCalculoModel) then
    Assign(TACBrCalcBaseCalculoModel(aSource));
end;

procedure TACBrCalcBaseCalculoModel.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('baseCalculo', fbaseCalculo);
end;

procedure TACBrCalcBaseCalculoModel.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('baseCalculo', fbaseCalculo);
end;

procedure TACBrCalcBaseCalculoModel.Clear;
begin
  fbaseCalculo := 0;
end;

function TACBrCalcBaseCalculoModel.IsEmpty: Boolean;
begin
  Result := EstaZerado(fbaseCalculo);
end;

procedure TACBrCalcBaseCalculoModel.Assign(Source: TACBrCalcBaseCalculoModel);
begin
  if not Assigned(Source) then
    Exit;

  fbaseCalculo := Source.baseCalculo;
end;

{ TACBrCalcBCCIBSMercadorias }

procedure TACBrCalcBCCIBSMercadorias.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcBCCIBSMercadorias) then
    Assign(TACBrCalcBCCIBSMercadorias(aSource));
end;

{ TACBrCalcBCISMercadorias }

procedure TACBrCalcBCISMercadorias.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcBCISMercadorias) then
    Assign(TACBrCalcBCISMercadorias(aSource));
end;

procedure TACBrCalcBCISMercadorias.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('valorIntegralCobrado', fvalorIntegralCobrado)
    .AddPair('ajusteValorOperacao', fajusteValorOperacaoIS)
    .AddPair('juros', fjurosIS)
    .AddPair('multas', fmultasIS)
    .AddPair('acrescimos', facrescimosIS)
    .AddPair('encargos', fencargosIS)
    .AddPair('descontosCondicionais', fdescontosCondicionaisIS)
    .AddPair('fretePorDentro', ffretePorDentroIS)
    .AddPair('outrosTributos', foutrosTributosIS)
    .AddPair('demaisImportancias', fdemaisImportanciasIS)
    .AddPair('icms', ficmsIS)
    .AddPair('iss', fissIS)
    .AddPair('pis', fpisIS)
    .AddPair('cofins', fcofinsIS)
    .AddPair('bonificacao', fbonificacao)
    .AddPair('devolucaoVendas', fdevolucaoVendas);
end;

procedure TACBrCalcBCISMercadorias.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('valorIntegralCobrado', fvalorIntegralCobrado)
    .Value('ajusteValorOperacao', fajusteValorOperacaoIS)
    .Value('juros', fjurosIS)
    .Value('multas', fmultasIS)
    .Value('acrescimos', facrescimosIS)
    .Value('encargos', fencargosIS)
    .Value('descontosCondicionais', fdescontosCondicionaisIS)
    .Value('fretePorDentro', ffretePorDentroIS)
    .Value('outrosTributos', foutrosTributosIS)
    .Value('demaisImportancias', fdemaisImportanciasIS)
    .Value('icms', ficmsIS)
    .Value('iss', fissIS)
    .Value('pis', fpisIS)
    .Value('cofins', fcofinsIS)
    .Value('bonificacao', fbonificacao)
    .Value('devolucaoVendas', fdevolucaoVendas);
end;

procedure TACBrCalcBCISMercadorias.Clear;
begin
  fvalorIntegralCobrado := 0;
  fajusteValorOperacaoIS := 0;
  fjurosIS := 0;
  fmultasIS := 0;
  facrescimosIS := 0;
  fencargosIS := 0;
  fdescontosCondicionaisIS := 0;
  ffretePorDentroIS := 0;
  foutrosTributosIS := 0;
  fdemaisImportanciasIS := 0;
  ficmsIS := 0;
  fissIS := 0;
  fpisIS := 0;
  fcofinsIS := 0;
  fbonificacao := 0;
  fdevolucaoVendas := 0;
end;

function TACBrCalcBCISMercadorias.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fvalorIntegralCobrado) and
    EstaZerado(fajusteValorOperacaoIS) and
    EstaZerado(fjurosIS) and
    EstaZerado(fmultasIS) and
    EstaZerado(facrescimosIS) and
    EstaZerado(fencargosIS) and
    EstaZerado(fdescontosCondicionaisIS) and
    EstaZerado(ffretePorDentroIS) and
    EstaZerado(foutrosTributosIS) and
    EstaZerado(fdemaisImportanciasIS) and
    EstaZerado(ficmsIS) and
    EstaZerado(fissIS) and
    EstaZerado(fpisIS) and
    EstaZerado(fcofinsIS) and
    EstaZerado(fbonificacao) and
    EstaZerado(fdevolucaoVendas);
end;

procedure TACBrCalcBCISMercadorias.Assign(Source: TACBrCalcBCISMercadorias);
begin
  if not Assigned(Source) then
    Exit;

  fvalorIntegralCobrado := Source.valorIntegralCobrado;
  fajusteValorOperacaoIS := Source.ajusteValorOperacao;
  fjurosIS := Source.juros;
  fmultasIS := Source.multas;
  facrescimosIS := Source.acrescimos;
  fencargosIS := Source.encargos;
  fdescontosCondicionaisIS := Source.descontosCondicionais;
  ffretePorDentroIS := Source.fretePorDentro;
  foutrosTributosIS := Source.outrosTributos;
  fdemaisImportanciasIS := Source.demaisImportancias;
  ficmsIS := Source.icms;
  fissIS := Source.iss;
  fpisIS := Source.pis;
  fcofinsIS := Source.cofins;
  fbonificacao := Source.bonificacao;
  fdevolucaoVendas := Source.devolucaoVendas;
end;

procedure TACBrCalcBCCIBSMercadorias.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('valorFornecimento', fvalorFornecimento)
    .AddPair('ajusteValorOperacao', fajusteValorOperacao)
    .AddPair('juros', fjuros)
    .AddPair('multas', fmultas)
    .AddPair('acrescimos', facrescimos)
    .AddPair('encargos', fencargos)
    .AddPair('descontosCondicionais', fdescontosCondicionais)
    .AddPair('fretePorDentro', ffretePorDentro)
    .AddPair('outrosTributos', foutrosTributos)
    .AddPair('impostoSeletivo', fimpostoSeletivo)
    .AddPair('demaisImportancias', fdemaisImportancias)
    .AddPair('icms', ficms)
    .AddPair('iss', fiss)
    .AddPair('pis', fpis)
    .AddPair('cofins', fcofins);
end;

procedure TACBrCalcBCCIBSMercadorias.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('valorFornecimento', fvalorFornecimento)
    .Value('ajusteValorOperacao', fajusteValorOperacao)
    .Value('juros', fjuros)
    .Value('multas', fmultas)
    .Value('acrescimos', facrescimos)
    .Value('encargos', fencargos)
    .Value('descontosCondicionais', fdescontosCondicionais)
    .Value('fretePorDentro', ffretePorDentro)
    .Value('outrosTributos', foutrosTributos)
    .Value('impostoSeletivo', fimpostoSeletivo)
    .Value('demaisImportancias', fdemaisImportancias)
    .Value('icms', ficms)
    .Value('iss', fiss)
    .Value('pis', fpis)
    .Value('cofins', fcofins);
end;

procedure TACBrCalcBCCIBSMercadorias.Clear;
begin
  fvalorFornecimento := 0;
  fajusteValorOperacao := 0;
  fjuros := 0;
  fmultas := 0;
  facrescimos := 0;
  fencargos := 0;
  fdescontosCondicionais := 0;
  ffretePorDentro := 0;
  foutrosTributos := 0;
  fimpostoSeletivo := 0;
  fdemaisImportancias := 0;
  ficms := 0;
  fiss := 0;
  fpis := 0;
  fcofins := 0;
end;

function TACBrCalcBCCIBSMercadorias.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fvalorFornecimento) and
    EstaZerado(fajusteValorOperacao) and
    EstaZerado(fjuros) and
    EstaZerado(fmultas) and
    EstaZerado(facrescimos) and
    EstaZerado(fencargos) and
    EstaZerado(fdescontosCondicionais) and
    EstaZerado(ffretePorDentro) and
    EstaZerado(foutrosTributos) and
    EstaZerado(fimpostoSeletivo) and
    EstaZerado(fdemaisImportancias) and
    EstaZerado(ficms) and
    EstaZerado(fiss) and
    EstaZerado(fpis) and
    EstaZerado(fcofins);
end;

procedure TACBrCalcBCCIBSMercadorias.Assign(Source: TACBrCalcBCCIBSMercadorias);
begin
  if not Assigned(Source) then
    Exit;

  fvalorFornecimento := Source.valorFornecimento;
  fajusteValorOperacao := Source.ajusteValorOperacao;
  fjuros := Source.juros;
  fmultas := Source.multas;
  facrescimos := Source.acrescimos;
  fencargos := Source.encargos;
  fdescontosCondicionais := Source.descontosCondicionais;
  ffretePorDentro := Source.fretePorDentro;
  foutrosTributos := Source.outrosTributos;
  fimpostoSeletivo := Source.impostoSeletivo;
  fdemaisImportancias := Source.demaisImportancias;
  ficms := Source.icms;
  fiss := Source.iss;
  fpis := Source.pis;
  fcofins := Source.cofins;
end;

{ TACBrCalcAliquota }

procedure TACBrCalcAliquota.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcAliquota) then
    Assign(TACBrCalcAliquota(aSource));
end;

procedure TACBrCalcAliquota.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('aliquotaReferencia', faliquotaReferencia)
    .AddPair('aliquotaPropria', faliquotaPropria, False)
    .AddPair('formaAplicacao', fformaAplicacao, False);
end;

procedure TACBrCalcAliquota.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('aliquotaReferencia', faliquotaReferencia)
    .Value('aliquotaPropria', faliquotaPropria)
    .Value('formaAplicacao', fformaAplicacao);
end;

procedure TACBrCalcAliquota.Clear;
begin
  faliquotaReferencia := 0;
  faliquotaPropria := 0;
  fformaAplicacao := EmptyStr;
end;

function TACBrCalcAliquota.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(faliquotaReferencia) and
    EstaZerado(faliquotaPropria) and
    EstaVazio(fformaAplicacao);
end;

procedure TACBrCalcAliquota.Assign(Source: TACBrCalcAliquota);
begin
  if not Assigned(Source) then
    Exit;

  faliquotaReferencia := Source.aliquotaReferencia;
  faliquotaPropria := Source.aliquotaPropria;
  fformaAplicacao := Source.formaAplicacao;
end;

procedure TACBrCalcNBS.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('tributadoPeloImpostoSeletivo', ftributadoPeloImpostoSeletivo)
    .AddPair('aliquotaAdValorem', faliquotaAdValorem, False)
    .AddPair('capitulo', fcapitulo, False)
    .AddPair('posicao', fposicao, False)
    .AddPair('subposicao1', fsubposicao1, False)
    .AddPair('subposicao2', fsubposicao2, False)
    .AddPair('item', fitem, False);
end;

procedure TACBrCalcNBS.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('tributadoPeloImpostoSeletivo', ftributadoPeloImpostoSeletivo)
    .Value('aliquotaAdValorem', faliquotaAdValorem)
    .Value('capitulo', fcapitulo)
    .Value('posicao', fposicao)
    .Value('subposicao1', fsubposicao1)
    .Value('subposicao2', fsubposicao2)
    .Value('item', fitem);
end;

procedure TACBrCalcNBS.Clear;
begin
  ftributadoPeloImpostoSeletivo := False;
  faliquotaAdValorem := 0;
  fcapitulo := EmptyStr;
  fposicao := EmptyStr;
  fsubposicao1 := EmptyStr;
  fsubposicao2 := EmptyStr;
  fitem := EmptyStr;
end;

function TACBrCalcNBS.IsEmpty: Boolean;
begin
  Result :=
    not ftributadoPeloImpostoSeletivo and
    EstaZerado(faliquotaAdValorem) and
    EstaVazio(fcapitulo) and
    EstaVazio(fposicao) and
    EstaVazio(fsubposicao1) and
    EstaVazio(fsubposicao2) and
    EstaVazio(fitem);
end;

procedure TACBrCalcNBS.Assign(Source: TACBrCalcNBS);
begin
  if not Assigned(Source) then
    Exit;

  ftributadoPeloImpostoSeletivo := Source.tributadoPeloImpostoSeletivo;
  faliquotaAdValorem := Source.aliquotaAdValorem;
  fcapitulo := Source.capitulo;
  fposicao := Source.posicao;
  fsubposicao1 := Source.subposicao1;
  fsubposicao2 := Source.subposicao2;
  fitem := Source.item;
end;

{ TACBrCalcDevolucaoTributos }

procedure TACBrCalcDevolucaoTributos.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcDevolucaoTributos) then
    Assign(TACBrCalcDevolucaoTributos(aSource));
end;

procedure TACBrCalcDevolucaoTributos.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.AddPair('vDevTrib', fvDevTrib);
end;

procedure TACBrCalcDevolucaoTributos.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.Value('vDevTrib', fvDevTrib);
end;

procedure TACBrCalcDevolucaoTributos.Clear;
begin
  fvDevTrib := 0;
end;

function TACBrCalcDevolucaoTributos.IsEmpty: Boolean;
begin
  Result := EstaZerado(fvDevTrib);
end;

procedure TACBrCalcDevolucaoTributos.Assign(Source: TACBrCalcDevolucaoTributos);
begin
  if not Assigned(Source) then
    Exit;
  fvDevTrib := Source.vDevTrib;
end;

{ TACBrCalcDiferimento }

procedure TACBrCalcDiferimento.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcDiferimento) then
    Assign(TACBrCalcDiferimento(aSource));
end;

procedure TACBrCalcDiferimento.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('pDif', fpDif)
    .AddPair('vDif', fvDif);
end;

procedure TACBrCalcDiferimento.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('pDif', fpDif)
    .Value('vDif', fvDif);
end;

procedure TACBrCalcDiferimento.Clear;
begin
  fpDif := 0;
  fvDif := 0;
end;

function TACBrCalcDiferimento.IsEmpty: Boolean;
begin
  Result := EstaZerado(fpDif) and EstaZerado(fvDif);
end;

procedure TACBrCalcDiferimento.Assign(Source: TACBrCalcDiferimento);
begin
  if not Assigned(Source) then
    Exit;
  fpDif := Source.pDif;
  fvDif := Source.vDif;
end;

{ TACBrCalcReducaoAliquota }

procedure TACBrCalcReducaoAliquota.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcReducaoAliquota) then
    Assign(TACBrCalcReducaoAliquota(aSource));
end;

procedure TACBrCalcReducaoAliquota.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('pRedAliq', fpRedAliq)
    .AddPair('pAliqEfet', fpAliqEfet);
end;

procedure TACBrCalcReducaoAliquota.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('pRedAliq', fpRedAliq)
    .Value('pAliqEfet', fpAliqEfet);
end;

procedure TACBrCalcReducaoAliquota.Clear;
begin
  fpRedAliq := 0;
  fpAliqEfet := 0;
end;

function TACBrCalcReducaoAliquota.IsEmpty: Boolean;
begin
  Result := EstaZerado(fpRedAliq) and EstaZerado(fpAliqEfet);
end;

procedure TACBrCalcReducaoAliquota.Assign(Source: TACBrCalcReducaoAliquota);
begin
  if not Assigned(Source) then
    Exit;
  fpRedAliq := Source.pRedAliq;
  fpAliqEfet := Source.pAliqEfet;
end;

{ TACBrCalcIBSUF }

procedure TACBrCalcIBSUF.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcIBSUF) then
    Assign(TACBrCalcIBSUF(aSource));
end;

procedure TACBrCalcIBSUF.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.AddPair('pIBSUF', fpIBSUF);

  if Assigned(fgDif) then
    fgDif.WriteToJSon(aJSon);
  if Assigned(fgDevTrib) then
    fgDevTrib.WriteToJSon(aJSon);
  if Assigned(fgRed) then
    fgRed.WriteToJSon(aJSon);

  aJSon
    .AddPair('vIBSUF', fvIBSUF)
    .AddPair('memoriaCalculo', fmemoriaCalculo, False);
end;

procedure TACBrCalcIBSUF.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.Value('pIBSUF', fpIBSUF);

  gDif.ReadFromJSon(aJSon);
  gDevTrib.ReadFromJSon(aJSon);
  gRed.ReadFromJSon(aJSon);

  aJSon
    .Value('vIBSUF', fvIBSUF)
    .Value('memoriaCalculo', fmemoriaCalculo);
end;

destructor TACBrCalcIBSUF.Destroy;
begin
  if Assigned(fgDif) then fgDif.Free;
  if Assigned(fgDevTrib) then fgDevTrib.Free;
  if Assigned(fgRed) then fgRed.Free;
  inherited Destroy;
end;

procedure TACBrCalcIBSUF.Clear;
begin
  fpIBSUF := 0;
  fvIBSUF := 0;
  fmemoriaCalculo := EmptyStr;
  if Assigned(fgDif) then fgDif.Clear;
  if Assigned(fgDevTrib) then fgDevTrib.Clear;
  if Assigned(fgRed) then fgRed.Clear;
end;

function TACBrCalcIBSUF.IsEmpty: Boolean;
begin
  Result := EstaZerado(fpIBSUF) and EstaZerado(fvIBSUF) and EstaVazio(fmemoriaCalculo)
    and ((not Assigned(fgDif)) or fgDif.IsEmpty)
    and ((not Assigned(fgDevTrib)) or fgDevTrib.IsEmpty)
    and ((not Assigned(fgRed)) or fgRed.IsEmpty);
end;

procedure TACBrCalcIBSUF.Assign(Source: TACBrCalcIBSUF);
begin
  if not Assigned(Source) then
    Exit;
  fpIBSUF := Source.pIBSUF;
  fvIBSUF := Source.vIBSUF;
  fmemoriaCalculo := Source.memoriaCalculo;
  gDif.Assign(Source.gDif);
  gDevTrib.Assign(Source.gDevTrib);
  gRed.Assign(Source.gRed);
end;

function TACBrCalcIBSUF.GetgDif: TACBrCalcDiferimento;
begin
  if not Assigned(fgDif) then
    fgDif := TACBrCalcDiferimento.Create('gDif');
  Result := fgDif;
end;

function TACBrCalcIBSUF.GetgDevTrib: TACBrCalcDevolucaoTributos;
begin
  if not Assigned(fgDevTrib) then
    fgDevTrib := TACBrCalcDevolucaoTributos.Create('gDevTrib');
  Result := fgDevTrib;
end;

function TACBrCalcIBSUF.GetgRed: TACBrCalcReducaoAliquota;
begin
  if not Assigned(fgRed) then
    fgRed := TACBrCalcReducaoAliquota.Create('gRed');
  Result := fgRed;
end;

{ TACBrCalcIBSMun }

procedure TACBrCalcIBSMun.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcIBSMun) then
    Assign(TACBrCalcIBSMun(aSource));
end;

procedure TACBrCalcIBSMun.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.AddPair('pIBSMun', fpIBSMun);

  if Assigned(fgDif) then fgDif.WriteToJSon(aJSon);
  if Assigned(fgDevTrib) then fgDevTrib.WriteToJSon(aJSon);
  if Assigned(fgRed) then fgRed.WriteToJSon(aJSon);

  aJSon
    .AddPair('vIBSMun', fvIBSMun)
    .AddPair('memoriaCalculo', fmemoriaCalculo, False);
end;

procedure TACBrCalcIBSMun.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.Value('pIBSMun', fpIBSMun);

  gDif.ReadFromJSon(aJSon);
  gDevTrib.ReadFromJSon(aJSon);
  gRed.ReadFromJSon(aJSon);

  aJSon
    .Value('vIBSMun', fvIBSMun)
    .Value('memoriaCalculo', fmemoriaCalculo);
end;

destructor TACBrCalcIBSMun.Destroy;
begin
  if Assigned(fgDif) then fgDif.Free;
  if Assigned(fgDevTrib) then fgDevTrib.Free;
  if Assigned(fgRed) then fgRed.Free;
  inherited Destroy;
end;

procedure TACBrCalcIBSMun.Clear;
begin
  fpIBSMun := 0;
  fvIBSMun := 0;
  fmemoriaCalculo := EmptyStr;
  if Assigned(fgDif) then fgDif.Clear;
  if Assigned(fgDevTrib) then fgDevTrib.Clear;
  if Assigned(fgRed) then fgRed.Clear;
end;

function TACBrCalcIBSMun.IsEmpty: Boolean;
begin
  Result := EstaZerado(fpIBSMun) and EstaZerado(fvIBSMun) and EstaVazio(fmemoriaCalculo)
    and ((not Assigned(fgDif)) or fgDif.IsEmpty)
    and ((not Assigned(fgDevTrib)) or fgDevTrib.IsEmpty)
    and ((not Assigned(fgRed)) or fgRed.IsEmpty);
end;

procedure TACBrCalcIBSMun.Assign(Source: TACBrCalcIBSMun);
begin
  if not Assigned(Source) then
    Exit;
  fpIBSMun := Source.pIBSMun;
  fvIBSMun := Source.vIBSMun;
  fmemoriaCalculo := Source.memoriaCalculo;
  gDif.Assign(Source.gDif);
  gDevTrib.Assign(Source.gDevTrib);
  gRed.Assign(Source.gRed);
end;

function TACBrCalcIBSMun.GetgDif: TACBrCalcDiferimento;
begin
  if not Assigned(fgDif) then
    fgDif := TACBrCalcDiferimento.Create('gDif');
  Result := fgDif;
end;

function TACBrCalcIBSMun.GetgDevTrib: TACBrCalcDevolucaoTributos;
begin
  if not Assigned(fgDevTrib) then
    fgDevTrib := TACBrCalcDevolucaoTributos.Create('gDevTrib');
  Result := fgDevTrib;
end;

function TACBrCalcIBSMun.GetgRed: TACBrCalcReducaoAliquota;
begin
  if not Assigned(fgRed) then
    fgRed := TACBrCalcReducaoAliquota.Create('gRed');
  Result := fgRed;
end;

{ TACBrCalcCBS }

procedure TACBrCalcCBS.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcCBS) then
    Assign(TACBrCalcCBS(aSource));
end;

procedure TACBrCalcCBS.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.AddPair('pCBS', fpCBS);

  if Assigned(fgDif) then fgDif.WriteToJSon(aJSon);
  if Assigned(fgDevTrib) then fgDevTrib.WriteToJSon(aJSon);
  if Assigned(fgRed) then fgRed.WriteToJSon(aJSon);

  aJSon
    .AddPair('vCBS', fvCBS)
    .AddPair('memoriaCalculo', fmemoriaCalculo, False);
end;

procedure TACBrCalcCBS.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.Value('pCBS', fpCBS);

  gDif.ReadFromJSon(aJSon);
  gDevTrib.ReadFromJSon(aJSon);
  gRed.ReadFromJSon(aJSon);

  aJSon
    .Value('vCBS', fvCBS)
    .Value('memoriaCalculo', fmemoriaCalculo);
end;

destructor TACBrCalcCBS.Destroy;
begin
  if Assigned(fgDif) then fgDif.Free;
  if Assigned(fgDevTrib) then fgDevTrib.Free;
  if Assigned(fgRed) then fgRed.Free;
  inherited Destroy;
end;

procedure TACBrCalcCBS.Clear;
begin
  fpCBS := 0;
  fvCBS := 0;
  fmemoriaCalculo := EmptyStr;
  if Assigned(fgDif) then fgDif.Clear;
  if Assigned(fgDevTrib) then fgDevTrib.Clear;
  if Assigned(fgRed) then fgRed.Clear;
end;

function TACBrCalcCBS.IsEmpty: Boolean;
begin
  Result := EstaZerado(fpCBS) and EstaZerado(fvCBS) and EstaVazio(fmemoriaCalculo)
    and ((not Assigned(fgDif)) or fgDif.IsEmpty)
    and ((not Assigned(fgDevTrib)) or fgDevTrib.IsEmpty)
    and ((not Assigned(fgRed)) or fgRed.IsEmpty);
end;

procedure TACBrCalcCBS.Assign(Source: TACBrCalcCBS);
begin
  if not Assigned(Source) then
    Exit;
  fpCBS := Source.pCBS;
  fvCBS := Source.vCBS;
  fmemoriaCalculo := Source.memoriaCalculo;
  gDif.Assign(Source.gDif);
  gDevTrib.Assign(Source.gDevTrib);
  gRed.Assign(Source.gRed);
end;

function TACBrCalcCBS.GetgDif: TACBrCalcDiferimento;
begin
  if not Assigned(fgDif) then
    fgDif := TACBrCalcDiferimento.Create('gDif');
  Result := fgDif;
end;

function TACBrCalcCBS.GetgDevTrib: TACBrCalcDevolucaoTributos;
begin
  if not Assigned(fgDevTrib) then
    fgDevTrib := TACBrCalcDevolucaoTributos.Create('gDevTrib');
  Result := fgDevTrib;
end;

function TACBrCalcCBS.GetgRed: TACBrCalcReducaoAliquota;
begin
  if not Assigned(fgRed) then
    fgRed := TACBrCalcReducaoAliquota.Create('gRed');
  Result := fgRed;
end;

{ TACBrCalcTributacaoRegularOut }

procedure TACBrCalcTributacaoRegularOut.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcTributacaoRegularOut) then
    Assign(TACBrCalcTributacaoRegularOut(aSource));
end;

procedure TACBrCalcTributacaoRegularOut.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('CSTReg', fCSTReg)
    .AddPair('cClassTribReg', fcClassTribReg, False)
    .AddPair('pAliqEfetRegIBSUF', fpAliqEfetRegIBSUF)
    .AddPair('vTribRegIBSUF', fvTribRegIBSUF)
    .AddPair('pAliqEfetRegIBSMun', fpAliqEfetRegIBSMun)
    .AddPair('vTribRegIBSMun', fvTribRegIBSMun)
    .AddPair('pAliqEfetRegCBS', fpAliqEfetRegCBS)
    .AddPair('vTribRegCBS', fvTribRegCBS);
end;

procedure TACBrCalcTributacaoRegularOut.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('CSTReg', fCSTReg)
    .Value('cClassTribReg', fcClassTribReg)
    .Value('pAliqEfetRegIBSUF', fpAliqEfetRegIBSUF)
    .Value('vTribRegIBSUF', fvTribRegIBSUF)
    .Value('pAliqEfetRegIBSMun', fpAliqEfetRegIBSMun)
    .Value('vTribRegIBSMun', fvTribRegIBSMun)
    .Value('pAliqEfetRegCBS', fpAliqEfetRegCBS)
    .Value('vTribRegCBS', fvTribRegCBS);
end;

procedure TACBrCalcTributacaoRegularOut.Clear;
begin
  fCSTReg := 0;
  fcClassTribReg := EmptyStr;
  fpAliqEfetRegIBSUF := 0;
  fvTribRegIBSUF := 0;
  fpAliqEfetRegIBSMun := 0;
  fvTribRegIBSMun := 0;
  fpAliqEfetRegCBS := 0;
  fvTribRegCBS := 0;
end;

function TACBrCalcTributacaoRegularOut.IsEmpty: Boolean;
begin
  Result := EstaZerado(fCSTReg) and EstaVazio(fcClassTribReg)
    and EstaZerado(fpAliqEfetRegIBSUF) and EstaZerado(fvTribRegIBSUF)
    and EstaZerado(fpAliqEfetRegIBSMun) and EstaZerado(fvTribRegIBSMun)
    and EstaZerado(fpAliqEfetRegCBS) and EstaZerado(fvTribRegCBS);
end;

procedure TACBrCalcTributacaoRegularOut.Assign(Source: TACBrCalcTributacaoRegularOut);
begin
  if not Assigned(Source) then
    Exit;
  fCSTReg := Source.CSTReg;
  fcClassTribReg := Source.cClassTribReg;
  fpAliqEfetRegIBSUF := Source.pAliqEfetRegIBSUF;
  fvTribRegIBSUF := Source.vTribRegIBSUF;
  fpAliqEfetRegIBSMun := Source.pAliqEfetRegIBSMun;
  fvTribRegIBSMun := Source.vTribRegIBSMun;
  fpAliqEfetRegCBS := Source.pAliqEfetRegCBS;
  fvTribRegCBS := Source.vTribRegCBS;
end;

{ TACBrCalcCreditoPresumido }

procedure TACBrCalcCreditoPresumido.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcCreditoPresumido) then
    Assign(TACBrCalcCreditoPresumido(aSource));
end;

procedure TACBrCalcCreditoPresumido.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('cCredPres', fcCredPres)
    .AddPair('pCredPres', fpCredPres)
    .AddPair('vCredPres', fvCredPres)
    .AddPair('vCredPresCondSus', fvCredPresCondSus, False);
end;

procedure TACBrCalcCreditoPresumido.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('cCredPres', fcCredPres)
    .Value('pCredPres', fpCredPres)
    .Value('vCredPres', fvCredPres)
    .Value('vCredPresCondSus', fvCredPresCondSus);
end;

procedure TACBrCalcCreditoPresumido.Clear;
begin
  fcCredPres := 0;
  fpCredPres := 0;
  fvCredPres := 0;
  fvCredPresCondSus := 0;
end;

function TACBrCalcCreditoPresumido.IsEmpty: Boolean;
begin
  Result := EstaZerado(fcCredPres) and EstaZerado(fpCredPres)
    and EstaZerado(fvCredPres) and EstaZerado(fvCredPresCondSus);
end;

procedure TACBrCalcCreditoPresumido.Assign(Source: TACBrCalcCreditoPresumido);
begin
  if not Assigned(Source) then
    Exit;
  fcCredPres := Source.cCredPres;
  fpCredPres := Source.pCredPres;
  fvCredPres := Source.vCredPres;
  fvCredPresCondSus := Source.vCredPresCondSus;
end;

{ TACBrCalcTransferenciaCredito }

procedure TACBrCalcTransferenciaCredito.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcTransferenciaCredito) then
    Assign(TACBrCalcTransferenciaCredito(aSource));
end;

procedure TACBrCalcTransferenciaCredito.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;
  aJSon
    .AddPair('vIBS', fvIBS)
    .AddPair('vCBS', fvCBS);
end;

procedure TACBrCalcTransferenciaCredito.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;
  aJSon
    .Value('vIBS', fvIBS)
    .Value('vCBS', fvCBS);
end;

procedure TACBrCalcTransferenciaCredito.Clear;
begin
  fvIBS := 0;
  fvCBS := 0;
end;

function TACBrCalcTransferenciaCredito.IsEmpty: Boolean;
begin
  Result := EstaZerado(fvIBS) and EstaZerado(fvCBS);
end;

procedure TACBrCalcTransferenciaCredito.Assign(Source: TACBrCalcTransferenciaCredito);
begin
  if not Assigned(Source) then
    Exit;
  fvIBS := Source.vIBS;
  fvCBS := Source.vCBS;
end;

{ TACBrCalcCreditoPresumidoIBSZFM }

procedure TACBrCalcCreditoPresumidoIBSZFM.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcCreditoPresumidoIBSZFM) then
    Assign(TACBrCalcCreditoPresumidoIBSZFM(aSource));
end;

procedure TACBrCalcCreditoPresumidoIBSZFM.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;
  aJSon
    .AddPair('tpCredPresIBSZFM', ftpCredPresIBSZFM)
    .AddPair('vCredPresIBSZFM', fvCredPresIBSZFM);
end;

procedure TACBrCalcCreditoPresumidoIBSZFM.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;
  aJSon
    .Value('tpCredPresIBSZFM', ftpCredPresIBSZFM)
    .Value('vCredPresIBSZFM', fvCredPresIBSZFM);
end;

procedure TACBrCalcCreditoPresumidoIBSZFM.Clear;
begin
  ftpCredPresIBSZFM := 0;
  fvCredPresIBSZFM := 0;
end;

function TACBrCalcCreditoPresumidoIBSZFM.IsEmpty: Boolean;
begin
  Result := EstaZerado(ftpCredPresIBSZFM) and EstaZerado(fvCredPresIBSZFM);
end;

procedure TACBrCalcCreditoPresumidoIBSZFM.Assign(Source: TACBrCalcCreditoPresumidoIBSZFM);
begin
  if not Assigned(Source) then
    Exit;
  ftpCredPresIBSZFM := Source.tpCredPresIBSZFM;
  fvCredPresIBSZFM := Source.vCredPresIBSZFM;
end;

{ TACBrCalcTributacaoCompraGovernamental }

procedure TACBrCalcTributacaoCompraGovernamental.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcTributacaoCompraGovernamental) then
    Assign(TACBrCalcTributacaoCompraGovernamental(aSource));
end;

procedure TACBrCalcTributacaoCompraGovernamental.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;
  aJSon
    .AddPair('pAliqIBSUF', fpAliqIBSUF)
    .AddPair('vTribIBSUF', fvTribIBSUF)
    .AddPair('pAliqIBSMun', fpAliqIBSMun)
    .AddPair('vTribIBSMun', fvTribIBSMun)
    .AddPair('pAliqCBS', fpAliqCBS)
    .AddPair('vTribCBS', fvTribCBS);
end;

procedure TACBrCalcTributacaoCompraGovernamental.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;
  aJSon
    .Value('pAliqIBSUF', fpAliqIBSUF)
    .Value('vTribIBSUF', fvTribIBSUF)
    .Value('pAliqIBSMun', fpAliqIBSMun)
    .Value('vTribIBSMun', fvTribIBSMun)
    .Value('pAliqCBS', fpAliqCBS)
    .Value('vTribCBS', fvTribCBS);
end;

procedure TACBrCalcTributacaoCompraGovernamental.Clear;
begin
  fpAliqIBSUF := 0;
  fvTribIBSUF := 0;
  fpAliqIBSMun := 0;
  fvTribIBSMun := 0;
  fpAliqCBS := 0;
  fvTribCBS := 0;
end;

function TACBrCalcTributacaoCompraGovernamental.IsEmpty: Boolean;
begin
  Result := EstaZerado(fpAliqIBSUF) and EstaZerado(fvTribIBSUF)
    and EstaZerado(fpAliqIBSMun) and EstaZerado(fvTribIBSMun)
    and EstaZerado(fpAliqCBS) and EstaZerado(fvTribCBS);
end;

procedure TACBrCalcTributacaoCompraGovernamental.Assign(Source: TACBrCalcTributacaoCompraGovernamental);
begin
  if not Assigned(Source) then
    Exit;
  fpAliqIBSUF := Source.pAliqIBSUF;
  fvTribIBSUF := Source.vTribIBSUF;
  fpAliqIBSMun := Source.pAliqIBSMun;
  fvTribIBSMun := Source.vTribIBSMun;
  fpAliqCBS := Source.pAliqCBS;
  fvTribCBS := Source.vTribCBS;
end;

{ TACBrCalcGrupoIBSCBS }

procedure TACBrCalcGrupoIBSCBS.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcGrupoIBSCBS) then
    Assign(TACBrCalcGrupoIBSCBS(aSource));
end;

procedure TACBrCalcGrupoIBSCBS.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;
  aJSon.AddPair('vBC', fvBC);
  if Assigned(fgIBSUF) then fgIBSUF.WriteToJSon(aJSon);
  if Assigned(fgIBSMun) then fgIBSMun.WriteToJSon(aJSon);
  if Assigned(fgCBS) then fgCBS.WriteToJSon(aJSon);
  if Assigned(fgTribRegular) then fgTribRegular.WriteToJSon(aJSon);
  if Assigned(fgIBSCredPres) then fgIBSCredPres.WriteToJSon(aJSon);
  if Assigned(fgCBSCredPres) then fgCBSCredPres.WriteToJSon(aJSon);
  if Assigned(fgTribCompraGov) then fgTribCompraGov.WriteToJSon(aJSon);
end;

procedure TACBrCalcGrupoIBSCBS.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;
  aJSon.Value('vBC', fvBC);

  gIBSUF.ReadFromJSon(aJSon);
  gIBSMun.ReadFromJSon(aJSon);
  gCBS.ReadFromJSon(aJSon);
  gTribRegular.ReadFromJSon(aJSon);
  gIBSCredPres.ReadFromJSon(aJSon);
  gCBSCredPres.ReadFromJSon(aJSon);
  gTribCompraGov.ReadFromJSon(aJSon);
end;

destructor TACBrCalcGrupoIBSCBS.Destroy;
begin
  if Assigned(fgIBSUF) then fgIBSUF.Free;
  if Assigned(fgIBSMun) then fgIBSMun.Free;
  if Assigned(fgCBS) then fgCBS.Free;
  if Assigned(fgTribRegular) then fgTribRegular.Free;
  if Assigned(fgIBSCredPres) then fgIBSCredPres.Free;
  if Assigned(fgCBSCredPres) then fgCBSCredPres.Free;
  if Assigned(fgTribCompraGov) then fgTribCompraGov.Free;
  inherited Destroy;
end;

procedure TACBrCalcGrupoIBSCBS.Clear;
begin
  fvBC := 0;
  if Assigned(fgIBSUF) then fgIBSUF.Clear;
  if Assigned(fgIBSMun) then fgIBSMun.Clear;
  if Assigned(fgCBS) then fgCBS.Clear;
  if Assigned(fgTribRegular) then fgTribRegular.Clear;
  if Assigned(fgIBSCredPres) then fgIBSCredPres.Clear;
  if Assigned(fgCBSCredPres) then fgCBSCredPres.Clear;
  if Assigned(fgTribCompraGov) then fgTribCompraGov.Clear;
end;

function TACBrCalcGrupoIBSCBS.IsEmpty: Boolean;
begin
  Result := EstaZerado(fvBC)
    and ((not Assigned(fgIBSUF)) or fgIBSUF.IsEmpty)
    and ((not Assigned(fgIBSMun)) or fgIBSMun.IsEmpty)
    and ((not Assigned(fgCBS)) or fgCBS.IsEmpty)
    and ((not Assigned(fgTribRegular)) or fgTribRegular.IsEmpty)
    and ((not Assigned(fgIBSCredPres)) or fgIBSCredPres.IsEmpty)
    and ((not Assigned(fgCBSCredPres)) or fgCBSCredPres.IsEmpty)
    and ((not Assigned(fgTribCompraGov)) or fgTribCompraGov.IsEmpty);
end;

procedure TACBrCalcGrupoIBSCBS.Assign(Source: TACBrCalcGrupoIBSCBS);
begin
  if not Assigned(Source) then
    Exit;
  fvBC := Source.vBC;
  gIBSUF.Assign(Source.gIBSUF);
  gIBSMun.Assign(Source.gIBSMun);
  gCBS.Assign(Source.gCBS);
  gTribRegular.Assign(Source.gTribRegular);
  gIBSCredPres.Assign(Source.gIBSCredPres);
  gCBSCredPres.Assign(Source.gCBSCredPres);
  gTribCompraGov.Assign(Source.gTribCompraGov);
end;

function TACBrCalcGrupoIBSCBS.GetgIBSUF: TACBrCalcIBSUF;
begin
  if not Assigned(fgIBSUF) then
    fgIBSUF := TACBrCalcIBSUF.Create('gIBSUF');
  Result := fgIBSUF;
end;

function TACBrCalcGrupoIBSCBS.GetgIBSMun: TACBrCalcIBSMun;
begin
  if not Assigned(fgIBSMun) then
    fgIBSMun := TACBrCalcIBSMun.Create('gIBSMun');
  Result := fgIBSMun;
end;

function TACBrCalcGrupoIBSCBS.GetgCBS: TACBrCalcCBS;
begin
  if not Assigned(fgCBS) then
    fgCBS := TACBrCalcCBS.Create('gCBS');
  Result := fgCBS;
end;

function TACBrCalcGrupoIBSCBS.GetgTribRegular: TACBrCalcTributacaoRegularOut;
begin
  if not Assigned(fgTribRegular) then
    fgTribRegular := TACBrCalcTributacaoRegularOut.Create('gTribRegular');
  Result := fgTribRegular;
end;

function TACBrCalcGrupoIBSCBS.GetgIBSCredPres: TACBrCalcCreditoPresumido;
begin
  if not Assigned(fgIBSCredPres) then
    fgIBSCredPres := TACBrCalcCreditoPresumido.Create('gIBSCredPres');
  Result := fgIBSCredPres;
end;

function TACBrCalcGrupoIBSCBS.GetgCBSCredPres: TACBrCalcCreditoPresumido;
begin
  if not Assigned(fgCBSCredPres) then
    fgCBSCredPres := TACBrCalcCreditoPresumido.Create('gCBSCredPres');
  Result := fgCBSCredPres;
end;

function TACBrCalcGrupoIBSCBS.GetgTribCompraGov: TACBrCalcTributacaoCompraGovernamental;
begin
  if not Assigned(fgTribCompraGov) then
    fgTribCompraGov := TACBrCalcTributacaoCompraGovernamental.Create('gTribCompraGov');
  Result := fgTribCompraGov;
end;

{ TACBrCalcMonofasia }

procedure TACBrCalcMonofasia.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcMonofasia) then
    Assign(TACBrCalcMonofasia(aSource));
end;

procedure TACBrCalcMonofasia.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .AddPair('qBCMono', fqBCMono)
    .AddPair('adRemIBS', fadRemIBS)
    .AddPair('adRemCBS', fadRemCBS)
    .AddPair('vIBSMono', fvIBSMono)
    .AddPair('vCBSMono', fvCBSMono)
    .AddPair('qBCMonoReten', fqBCMonoReten)
    .AddPair('adRemIBSReten', fadRemIBSReten)
    .AddPair('vIBSMonoReten', fvIBSMonoReten)
    .AddPair('adRemCBSReten', fadRemCBSReten)
    .AddPair('vCBSMonoReten', fvCBSMonoReten)
    .AddPair('qBCMonoRet', fqBCMonoRet)
    .AddPair('adRemIBSRet', fadRemIBSRet)
    .AddPair('vIBSMonoRet', fvIBSMonoRet)
    .AddPair('adRemCBSRet', fadRemCBSRet)
    .AddPair('vCBSMonoRet', fvCBSMonoRet)
    .AddPair('pDifIBS', fpDifIBS)
    .AddPair('vIBSMonoDif', fvIBSMonoDif)
    .AddPair('pDifCBS', fpDifCBS)
    .AddPair('vCBSMonoDif', fvCBSMonoDif)
    .AddPair('vTotIBSMonoItem', fvTotIBSMonoItem)
    .AddPair('vTotCBSMonoItem', fvTotCBSMonoItem);
end;

procedure TACBrCalcMonofasia.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .Value('qBCMono', fqBCMono)
    .Value('adRemIBS', fadRemIBS)
    .Value('adRemCBS', fadRemCBS)
    .Value('vIBSMono', fvIBSMono)
    .Value('vCBSMono', fvCBSMono)
    .Value('qBCMonoReten', fqBCMonoReten)
    .Value('adRemIBSReten', fadRemIBSReten)
    .Value('vIBSMonoReten', fvIBSMonoReten)
    .Value('adRemCBSReten', fadRemCBSReten)
    .Value('vCBSMonoReten', fvCBSMonoReten)
    .Value('qBCMonoRet', fqBCMonoRet)
    .Value('adRemIBSRet', fadRemIBSRet)
    .Value('vIBSMonoRet', fvIBSMonoRet)
    .Value('adRemCBSRet', fadRemCBSRet)
    .Value('vCBSMonoRet', fvCBSMonoRet)
    .Value('pDifIBS', fpDifIBS)
    .Value('vIBSMonoDif', fvIBSMonoDif)
    .Value('pDifCBS', fpDifCBS)
    .Value('vCBSMonoDif', fvCBSMonoDif)
    .Value('vTotIBSMonoItem', fvTotIBSMonoItem)
    .Value('vTotCBSMonoItem', fvTotCBSMonoItem);
end;

procedure TACBrCalcMonofasia.Clear;
begin
  fqBCMono := 0;
  fadRemIBS := 0;
  fadRemCBS := 0;
  fvIBSMono := 0;
  fvCBSMono := 0;
  fqBCMonoReten := 0;
  fadRemIBSReten := 0;
  fvIBSMonoReten := 0;
  fadRemCBSReten := 0;
  fvCBSMonoReten := 0;
  fqBCMonoRet := 0;
  fadRemIBSRet := 0;
  fvIBSMonoRet := 0;
  fadRemCBSRet := 0;
  fvCBSMonoRet := 0;
  fpDifIBS := 0;
  fvIBSMonoDif := 0;
  fpDifCBS := 0;
  fvCBSMonoDif := 0;
  fvTotIBSMonoItem := 0;
  fvTotCBSMonoItem := 0;
end;

function TACBrCalcMonofasia.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fqBCMono) and EstaZerado(fadRemIBS) and EstaZerado(fadRemCBS) and
    EstaZerado(fvIBSMono) and EstaZerado(fvCBSMono) and EstaZerado(fqBCMonoReten) and
    EstaZerado(fadRemIBSReten) and EstaZerado(fvIBSMonoReten) and EstaZerado(fadRemCBSReten) and
    EstaZerado(fvCBSMonoReten) and EstaZerado(fqBCMonoRet) and EstaZerado(fadRemIBSRet) and
    EstaZerado(fvIBSMonoRet) and EstaZerado(fadRemCBSRet) and EstaZerado(fvCBSMonoRet) and
    EstaZerado(fpDifIBS) and EstaZerado(fvIBSMonoDif) and EstaZerado(fpDifCBS) and
    EstaZerado(fvCBSMonoDif) and EstaZerado(fvTotIBSMonoItem) and EstaZerado(fvTotCBSMonoItem);
end;

procedure TACBrCalcMonofasia.Assign(Source: TACBrCalcMonofasia);
begin
  if not Assigned(Source) then Exit;
  fqBCMono := Source.qBCMono;
  fadRemIBS := Source.adRemIBS;
  fadRemCBS := Source.adRemCBS;
  fvIBSMono := Source.vIBSMono;
  fvCBSMono := Source.vCBSMono;
  fqBCMonoReten := Source.qBCMonoReten;
  fadRemIBSReten := Source.adRemIBSReten;
  fvIBSMonoReten := Source.vIBSMonoReten;
  fadRemCBSReten := Source.adRemCBSReten;
  fvCBSMonoReten := Source.vCBSMonoReten;
  fqBCMonoRet := Source.qBCMonoRet;
  fadRemIBSRet := Source.adRemIBSRet;
  fvIBSMonoRet := Source.vIBSMonoRet;
  fadRemCBSRet := Source.adRemCBSRet;
  fvCBSMonoRet := Source.vCBSMonoRet;
  fpDifIBS := Source.pDifIBS;
  fvIBSMonoDif := Source.vIBSMonoDif;
  fpDifCBS := Source.pDifCBS;
  fvCBSMonoDif := Source.vCBSMonoDif;
  fvTotIBSMonoItem := Source.vTotIBSMonoItem;
  fvTotCBSMonoItem := Source.vTotCBSMonoItem;
end;

{ TACBrCalcIBSCBS }

procedure TACBrCalcIBSCBS.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcIBSCBS) then
    Assign(TACBrCalcIBSCBS(aSource));
end;

procedure TACBrCalcIBSCBS.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .AddPair('CST', fCST)
    .AddPair('cClassTrib', fcClassTrib, False);
  if Assigned(fgIBSCBS) then fgIBSCBS.WriteToJSon(aJSon);
  if Assigned(fgIBSCBSMono) then fgIBSCBSMono.WriteToJSon(aJSon);
  if Assigned(fgTransfCred) then fgTransfCred.WriteToJSon(aJSon);
  if Assigned(fgCredPresIBSZFM) then fgCredPresIBSZFM.WriteToJSon(aJSon);
end;

procedure TACBrCalcIBSCBS.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .Value('CST', fCST)
    .Value('cClassTrib', fcClassTrib);

  gIBSCBS.ReadFromJSon(aJSon);
  gIBSCBSMono.ReadFromJSon(aJSon);
  gTransfCred.ReadFromJSon(aJSon);
  gCredPresIBSZFM.ReadFromJSon(aJSon);
end;

destructor TACBrCalcIBSCBS.Destroy;
begin
  if Assigned(fgIBSCBS) then fgIBSCBS.Free;
  if Assigned(fgIBSCBSMono) then fgIBSCBSMono.Free;
  if Assigned(fgTransfCred) then fgTransfCred.Free;
  if Assigned(fgCredPresIBSZFM) then fgCredPresIBSZFM.Free;
  inherited Destroy;
end;

procedure TACBrCalcIBSCBS.Clear;
begin
  fCST := 0;
  fcClassTrib := EmptyStr;
  if Assigned(fgIBSCBS) then fgIBSCBS.Clear;
  if Assigned(fgIBSCBSMono) then fgIBSCBSMono.Clear;
  if Assigned(fgTransfCred) then fgTransfCred.Clear;
  if Assigned(fgCredPresIBSZFM) then fgCredPresIBSZFM.Clear;
end;

function TACBrCalcIBSCBS.IsEmpty: Boolean;
begin
  Result := EstaZerado(fCST) and EstaVazio(fcClassTrib)
    and ((not Assigned(fgIBSCBS)) or fgIBSCBS.IsEmpty)
    and ((not Assigned(fgIBSCBSMono)) or fgIBSCBSMono.IsEmpty)
    and ((not Assigned(fgTransfCred)) or fgTransfCred.IsEmpty)
    and ((not Assigned(fgCredPresIBSZFM)) or fgCredPresIBSZFM.IsEmpty);
end;

procedure TACBrCalcIBSCBS.Assign(Source: TACBrCalcIBSCBS);
begin
  if not Assigned(Source) then Exit;
  fCST := Source.CST;
  fcClassTrib := Source.cClassTrib;
  gIBSCBS.Assign(Source.gIBSCBS);
  gIBSCBSMono.Assign(Source.gIBSCBSMono);
  gTransfCred.Assign(Source.gTransfCred);
  gCredPresIBSZFM.Assign(Source.gCredPresIBSZFM);
end;

function TACBrCalcIBSCBS.GetgIBSCBS: TACBrCalcGrupoIBSCBS;
begin
  if not Assigned(fgIBSCBS) then
    fgIBSCBS := TACBrCalcGrupoIBSCBS.Create('gIBSCBS');
  Result := fgIBSCBS;
end;

function TACBrCalcIBSCBS.GetgIBSCBSMono: TACBrCalcMonofasia;
begin
  if not Assigned(fgIBSCBSMono) then
    fgIBSCBSMono := TACBrCalcMonofasia.Create('gIBSCBSMono');
  Result := fgIBSCBSMono;
end;

function TACBrCalcIBSCBS.GetgTransfCred: TACBrCalcTransferenciaCredito;
begin
  if not Assigned(fgTransfCred) then
    fgTransfCred := TACBrCalcTransferenciaCredito.Create('gTransfCred');
  Result := fgTransfCred;
end;

function TACBrCalcIBSCBS.GetgCredPresIBSZFM: TACBrCalcCreditoPresumidoIBSZFM;
begin
  if not Assigned(fgCredPresIBSZFM) then
    fgCredPresIBSZFM := TACBrCalcCreditoPresumidoIBSZFM.Create('gCredPresIBSZFM');
  Result := fgCredPresIBSZFM;
end;

{ TACBrCalcIS }

procedure TACBrCalcIS.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcIS) then
    Assign(TACBrCalcIS(aSource));
end;

procedure TACBrCalcIS.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .AddPair('CSTIS', fCSTIS)
    .AddPair('cClassTribIS', fcClassTribIS, False)
    .AddPair('vBCIS', fvBCIS)
    .AddPair('pIS', fpIS, False)
    .AddPair('pISEspec', fpISEspec, False)
    .AddPair('uTrib', fuTrib, False)
    .AddPair('qTrib', fqTrib, False)
    .AddPair('vIS', fvIS)
    .AddPair('memoriaCalculo', fmemoriaCalculo, False);
end;

procedure TACBrCalcIS.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .Value('CSTIS', fCSTIS)
    .Value('cClassTribIS', fcClassTribIS)
    .Value('vBCIS', fvBCIS)
    .Value('pIS', fpIS)
    .Value('pISEspec', fpISEspec)
    .Value('uTrib', fuTrib)
    .Value('qTrib', fqTrib)
    .Value('vIS', fvIS)
    .Value('memoriaCalculo', fmemoriaCalculo);
end;

procedure TACBrCalcIS.Clear;
begin
  fCSTIS := 0;
  fcClassTribIS := EmptyStr;
  fvBCIS := 0;
  fpIS := 0;
  fpISEspec := 0;
  fuTrib := EmptyStr;
  fqTrib := 0;
  fvIS := 0;
  fmemoriaCalculo := EmptyStr;
end;

function TACBrCalcIS.IsEmpty: Boolean;
begin
  Result := EstaZerado(fCSTIS) and EstaVazio(fcClassTribIS) and EstaZerado(fvBCIS) and
    EstaZerado(fpIS) and EstaZerado(fpISEspec) and EstaVazio(fuTrib) and EstaZerado(fqTrib) and
    EstaZerado(fvIS) and EstaVazio(fmemoriaCalculo);
end;

procedure TACBrCalcIS.Assign(Source: TACBrCalcIS);
begin
  if not Assigned(Source) then Exit;
  fCSTIS := Source.CSTIS;
  fcClassTribIS := Source.cClassTribIS;
  fvBCIS := Source.vBCIS;
  fpIS := Source.pIS;
  fpISEspec := Source.pISEspec;
  fuTrib := Source.uTrib;
  fqTrib := Source.qTrib;
  fvIS := Source.vIS;
  fmemoriaCalculo := Source.memoriaCalculo;
end;

{ TACBrCalcTributos }

procedure TACBrCalcTributos.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcTributos) then
    Assign(TACBrCalcTributos(aSource));
end;

procedure TACBrCalcTributos.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  if Assigned(fIS) then fIS.WriteToJSon(aJSon);
  if Assigned(fIBSCBS) then fIBSCBS.WriteToJSon(aJSon);
end;

procedure TACBrCalcTributos.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  IS_.ReadFromJSon(aJSon);
  IBSCBS.ReadFromJSon(aJSon);
end;

destructor TACBrCalcTributos.Destroy;
begin
  if Assigned(fIS) then fIS.Free;
  if Assigned(fIBSCBS) then fIBSCBS.Free;
  inherited Destroy;
end;

procedure TACBrCalcTributos.Clear;
begin
  if Assigned(fIS) then fIS.Clear;
  if Assigned(fIBSCBS) then fIBSCBS.Clear;
end;

function TACBrCalcTributos.IsEmpty: Boolean;
begin
  Result := ((not Assigned(fIS)) or fIS.IsEmpty) and ((not Assigned(fIBSCBS)) or fIBSCBS.IsEmpty);
end;

procedure TACBrCalcTributos.Assign(Source: TACBrCalcTributos);
begin
  if not Assigned(Source) then Exit;
  IS_.Assign(Source.IS_);
  IBSCBS.Assign(Source.IBSCBS);
end;

function TACBrCalcTributos.GetIS: TACBrCalcIS;
begin
  if not Assigned(fIS) then
    fIS := TACBrCalcIS.Create('IS');
  Result := fIS;
end;

function TACBrCalcTributos.GetIBSCBS: TACBrCalcIBSCBS;
begin
  if not Assigned(fIBSCBS) then
    fIBSCBS := TACBrCalcIBSCBS.Create('IBSCBS');
  Result := fIBSCBS;
end;

{ TACBrCalcIBSUFTotal }

procedure TACBrCalcIBSUFTotal.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcIBSUFTotal) then
    Assign(TACBrCalcIBSUFTotal(aSource));
end;

procedure TACBrCalcIBSUFTotal.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .AddPair('vDif', fvDif)
    .AddPair('vDevTrib', fvDevTrib)
    .AddPair('vIBSUF', fvIBSUF);
end;

procedure TACBrCalcIBSUFTotal.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .Value('vDif', fvDif)
    .Value('vDevTrib', fvDevTrib)
    .Value('vIBSUF', fvIBSUF);
end;

procedure TACBrCalcIBSUFTotal.Clear;
begin
  fvDif := 0;
  fvDevTrib := 0;
  fvIBSUF := 0;
end;

function TACBrCalcIBSUFTotal.IsEmpty: Boolean;
begin
  Result := EstaZerado(fvDif) and EstaZerado(fvDevTrib) and EstaZerado(fvIBSUF);
end;

procedure TACBrCalcIBSUFTotal.Assign(Source: TACBrCalcIBSUFTotal);
begin
  if not Assigned(Source) then Exit;
  fvDif := Source.vDif;
  fvDevTrib := Source.vDevTrib;
  fvIBSUF := Source.vIBSUF;
end;

{ TACBrCalcIBSMunTotal }

procedure TACBrCalcIBSMunTotal.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcIBSMunTotal) then
    Assign(TACBrCalcIBSMunTotal(aSource));
end;

procedure TACBrCalcIBSMunTotal.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .AddPair('vDif', fvDif)
    .AddPair('vDevTrib', fvDevTrib)
    .AddPair('vIBSMun', fvIBSMun);
end;

procedure TACBrCalcIBSMunTotal.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .Value('vDif', fvDif)
    .Value('vDevTrib', fvDevTrib)
    .Value('vIBSMun', fvIBSMun);
end;

procedure TACBrCalcIBSMunTotal.Clear;
begin
  fvDif := 0;
  fvDevTrib := 0;
  fvIBSMun := 0;
end;

function TACBrCalcIBSMunTotal.IsEmpty: Boolean;
begin
  Result := EstaZerado(fvDif) and EstaZerado(fvDevTrib) and EstaZerado(fvIBSMun);
end;

procedure TACBrCalcIBSMunTotal.Assign(Source: TACBrCalcIBSMunTotal);
begin
  if not Assigned(Source) then Exit;
  fvDif := Source.vDif;
  fvDevTrib := Source.vDevTrib;
  fvIBSMun := Source.vIBSMun;
end;

{ TACBrCalcCBSTotal }

procedure TACBrCalcCBSTotal.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcCBSTotal) then
    Assign(TACBrCalcCBSTotal(aSource));
end;

procedure TACBrCalcCBSTotal.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .AddPair('vDif', fvDif)
    .AddPair('vDevTrib', fvDevTrib)
    .AddPair('vCBS', fvCBS)
    .AddPair('vCredPres', fvCredPres, False)
    .AddPair('vCredPresCondSus', fvCredPresCondSus, False);
end;

procedure TACBrCalcCBSTotal.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .Value('vDif', fvDif)
    .Value('vDevTrib', fvDevTrib)
    .Value('vCBS', fvCBS)
    .Value('vCredPres', fvCredPres)
    .Value('vCredPresCondSus', fvCredPresCondSus);
end;

procedure TACBrCalcCBSTotal.Clear;
begin
  fvDif := 0;
  fvDevTrib := 0;
  fvCBS := 0;
  fvCredPres := 0;
  fvCredPresCondSus := 0;
end;

function TACBrCalcCBSTotal.IsEmpty: Boolean;
begin
  Result := EstaZerado(fvDif) and EstaZerado(fvDevTrib) and EstaZerado(fvCBS)
    and EstaZerado(fvCredPres) and EstaZerado(fvCredPresCondSus);
end;

procedure TACBrCalcCBSTotal.Assign(Source: TACBrCalcCBSTotal);
begin
  if not Assigned(Source) then Exit;
  fvDif := Source.vDif;
  fvDevTrib := Source.vDevTrib;
  fvCBS := Source.vCBS;
  fvCredPres := Source.vCredPres;
  fvCredPresCondSus := Source.vCredPresCondSus;
end;

{ TACBrCalcIBSTotal }

procedure TACBrCalcIBSTotal.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcIBSTotal) then
    Assign(TACBrCalcIBSTotal(aSource));
end;

procedure TACBrCalcIBSTotal.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  if Assigned(fgIBSUF) then fgIBSUF.WriteToJSon(aJSon);
  if Assigned(fgIBSMun) then fgIBSMun.WriteToJSon(aJSon);
  aJSon
    .AddPair('vIBS', fvIBS)
    .AddPair('vCredPres', fvCredPres, False)
    .AddPair('vCredPresCondSus', fvCredPresCondSus, False);
end;

procedure TACBrCalcIBSTotal.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .Value('vIBS', fvIBS)
    .Value('vCredPres', fvCredPres)
    .Value('vCredPresCondSus', fvCredPresCondSus);

  gIBSUF.ReadFromJSon(aJSon);
  gIBSMun.ReadFromJSon(aJSon);
end;

destructor TACBrCalcIBSTotal.Destroy;
begin
  if Assigned(fgIBSUF) then fgIBSUF.Free;
  if Assigned(fgIBSMun) then fgIBSMun.Free;
  inherited Destroy;
end;

procedure TACBrCalcIBSTotal.Clear;
begin
  fvIBS := 0;
  fvCredPres := 0;
  fvCredPresCondSus := 0;
  if Assigned(fgIBSUF) then fgIBSUF.Clear;
  if Assigned(fgIBSMun) then fgIBSMun.Clear;
end;

function TACBrCalcIBSTotal.IsEmpty: Boolean;
begin
  Result := EstaZerado(fvIBS) and EstaZerado(fvCredPres) and EstaZerado(fvCredPresCondSus)
    and ((not Assigned(fgIBSUF)) or fgIBSUF.IsEmpty)
    and ((not Assigned(fgIBSMun)) or fgIBSMun.IsEmpty);
end;

procedure TACBrCalcIBSTotal.Assign(Source: TACBrCalcIBSTotal);
begin
  if not Assigned(Source) then Exit;
  fvIBS := Source.vIBS;
  fvCredPres := Source.vCredPres;
  fvCredPresCondSus := Source.vCredPresCondSus;
  gIBSUF.Assign(Source.gIBSUF);
  gIBSMun.Assign(Source.gIBSMun);
end;

function TACBrCalcIBSTotal.GetgIBSUF: TACBrCalcIBSUFTotal;
begin
  if not Assigned(fgIBSUF) then
    fgIBSUF := TACBrCalcIBSUFTotal.Create('gIBSUF');
  Result := fgIBSUF;
end;

function TACBrCalcIBSTotal.GetgIBSMun: TACBrCalcIBSMunTotal;
begin
  if not Assigned(fgIBSMun) then
    fgIBSMun := TACBrCalcIBSMunTotal.Create('gIBSMun');
  Result := fgIBSMun;
end;

{ TACBrCalcMonofasiaTotal }

procedure TACBrCalcMonofasiaTotal.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcMonofasiaTotal) then
    Assign(TACBrCalcMonofasiaTotal(aSource));
end;

procedure TACBrCalcMonofasiaTotal.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .AddPair('vIBSMono', fvIBSMono)
    .AddPair('vCBSMono', fvCBSMono)
    .AddPair('vIBSMonoReten', fvIBSMonoReten)
    .AddPair('vCBSMonoReten', fvCBSMonoReten)
    .AddPair('vIBSMonoRet', fvIBSMonoRet)
    .AddPair('vCBSMonoRet', fvCBSMonoRet);
end;

procedure TACBrCalcMonofasiaTotal.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon
    .Value('vIBSMono', fvIBSMono)
    .Value('vCBSMono', fvCBSMono)
    .Value('vIBSMonoReten', fvIBSMonoReten)
    .Value('vCBSMonoReten', fvCBSMonoReten)
    .Value('vIBSMonoRet', fvIBSMonoRet)
    .Value('vCBSMonoRet', fvCBSMonoRet);
end;

procedure TACBrCalcMonofasiaTotal.Clear;
begin
  fvIBSMono := 0;
  fvCBSMono := 0;
  fvIBSMonoReten := 0;
  fvCBSMonoReten := 0;
  fvIBSMonoRet := 0;
  fvCBSMonoRet := 0;
end;

function TACBrCalcMonofasiaTotal.IsEmpty: Boolean;
begin
  Result := EstaZerado(fvIBSMono) and EstaZerado(fvCBSMono)
    and EstaZerado(fvIBSMonoReten) and EstaZerado(fvCBSMonoReten)
    and EstaZerado(fvIBSMonoRet) and EstaZerado(fvCBSMonoRet);
end;

procedure TACBrCalcMonofasiaTotal.Assign(Source: TACBrCalcMonofasiaTotal);
begin
  if not Assigned(Source) then Exit;
  fvIBSMono := Source.vIBSMono;
  fvCBSMono := Source.vCBSMono;
  fvIBSMonoReten := Source.vIBSMonoReten;
  fvCBSMonoReten := Source.vCBSMonoReten;
  fvIBSMonoRet := Source.vIBSMonoRet;
  fvCBSMonoRet := Source.vCBSMonoRet;
end;

{ TACBrCalcIBSCBSTotal }

procedure TACBrCalcIBSCBSTotal.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcIBSCBSTotal) then
    Assign(TACBrCalcIBSCBSTotal(aSource));
end;

procedure TACBrCalcIBSCBSTotal.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.AddPair('vBCIBSCBS', fvBCIBSCBS);
  if Assigned(fgIBS) then fgIBS.WriteToJSon(aJSon);
  if Assigned(fgCBS) then fgCBS.WriteToJSon(aJSon);
  if Assigned(fgMono) then fgMono.WriteToJSon(aJSon);
end;

procedure TACBrCalcIBSCBSTotal.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.Value('vBCIBSCBS', fvBCIBSCBS);
  gIBS.ReadFromJSon(aJSon);
  gCBS.ReadFromJSon(aJSon);
  gMono.ReadFromJSon(aJSon);
end;

destructor TACBrCalcIBSCBSTotal.Destroy;
begin
  if Assigned(fgIBS) then fgIBS.Free;
  if Assigned(fgCBS) then fgCBS.Free;
  if Assigned(fgMono) then fgMono.Free;
  inherited Destroy;
end;

procedure TACBrCalcIBSCBSTotal.Clear;
begin
  fvBCIBSCBS := 0;
  if Assigned(fgIBS) then fgIBS.Clear;
  if Assigned(fgCBS) then fgCBS.Clear;
  if Assigned(fgMono) then fgMono.Clear;
end;

function TACBrCalcIBSCBSTotal.IsEmpty: Boolean;
begin
  Result := EstaZerado(fvBCIBSCBS)
    and ((not Assigned(fgIBS)) or fgIBS.IsEmpty)
    and ((not Assigned(fgCBS)) or fgCBS.IsEmpty)
    and ((not Assigned(fgMono)) or fgMono.IsEmpty);
end;

procedure TACBrCalcIBSCBSTotal.Assign(Source: TACBrCalcIBSCBSTotal);
begin
  if not Assigned(Source) then Exit;
  fvBCIBSCBS := Source.vBCIBSCBS;
  gIBS.Assign(Source.gIBS);
  gCBS.Assign(Source.gCBS);
  gMono.Assign(Source.gMono);
end;

function TACBrCalcIBSCBSTotal.GetgIBS: TACBrCalcIBSTotal;
begin
  if not Assigned(fgIBS) then
    fgIBS := TACBrCalcIBSTotal.Create('gIBS');
  Result := fgIBS;
end;

function TACBrCalcIBSCBSTotal.GetgCBS: TACBrCalcCBSTotal;
begin
  if not Assigned(fgCBS) then
    fgCBS := TACBrCalcCBSTotal.Create('gCBS');
  Result := fgCBS;
end;

function TACBrCalcIBSCBSTotal.GetgMono: TACBrCalcMonofasiaTotal;
begin
  if not Assigned(fgMono) then
    fgMono := TACBrCalcMonofasiaTotal.Create('gMono');
  Result := fgMono;
end;

{ TACBrCalcISTotal }

procedure TACBrCalcISTotal.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcISTotal) then
    Assign(TACBrCalcISTotal(aSource));
end;

procedure TACBrCalcISTotal.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon.AddPair('vIS', fvIS);
end;

procedure TACBrCalcISTotal.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  aJSon.Value('vIS', fvIS);
end;

procedure TACBrCalcISTotal.Clear;
begin
  fvIS := 0;
end;

function TACBrCalcISTotal.IsEmpty: Boolean;
begin
  Result := EstaZerado(fvIS);
end;

procedure TACBrCalcISTotal.Assign(Source: TACBrCalcISTotal);
begin
  if not Assigned(Source) then Exit;
  fvIS := Source.vIS;
end;

{ TACBrCalcTributosTotais }

procedure TACBrCalcTributosTotais.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcTributosTotais) then
    Assign(TACBrCalcTributosTotais(aSource));
end;

procedure TACBrCalcTributosTotais.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  if Assigned(fISTot) then fISTot.WriteToJSon(aJSon);
  if Assigned(fIBSCBSTot) then fIBSCBSTot.WriteToJSon(aJSon);
end;

procedure TACBrCalcTributosTotais.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  ISTot.ReadFromJSon(aJSon);
  IBSCBSTot.ReadFromJSon(aJSon);
end;

destructor TACBrCalcTributosTotais.Destroy;
begin
  if Assigned(fISTot) then fISTot.Free;
  if Assigned(fIBSCBSTot) then fIBSCBSTot.Free;
  inherited Destroy;
end;

procedure TACBrCalcTributosTotais.Clear;
begin
  if Assigned(fISTot) then fISTot.Clear;
  if Assigned(fIBSCBSTot) then fIBSCBSTot.Clear;
end;

function TACBrCalcTributosTotais.IsEmpty: Boolean;
begin
  Result := ((not Assigned(fISTot)) or fISTot.IsEmpty) and ((not Assigned(fIBSCBSTot)) or fIBSCBSTot.IsEmpty);
end;

procedure TACBrCalcTributosTotais.Assign(Source: TACBrCalcTributosTotais);
begin
  if not Assigned(Source) then Exit;
  ISTot.Assign(Source.ISTot);
  IBSCBSTot.Assign(Source.IBSCBSTot);
end;

function TACBrCalcTributosTotais.GetISTot: TACBrCalcISTotal;
begin
  if not Assigned(fISTot) then
    fISTot := TACBrCalcISTotal.Create('ISTot');
  Result := fISTot;
end;

function TACBrCalcTributosTotais.GetIBSCBSTot: TACBrCalcIBSCBSTotal;
begin
  if not Assigned(fIBSCBSTot) then
    fIBSCBSTot := TACBrCalcIBSCBSTotal.Create('IBSCBSTot');
  Result := fIBSCBSTot;
end;

{ TACBrCalcValoresTotais }

procedure TACBrCalcValoresTotais.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcValoresTotais) then
    Assign(TACBrCalcValoresTotais(aSource));
end;

procedure TACBrCalcValoresTotais.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  if Assigned(ftribCalc) then ftribCalc.WriteToJSon(aJSon);
end;

procedure TACBrCalcValoresTotais.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  tribCalc.ReadFromJSon(aJSon);
end;

destructor TACBrCalcValoresTotais.Destroy;
begin
  if Assigned(ftribCalc) then ftribCalc.Free;
  inherited Destroy;
end;

procedure TACBrCalcValoresTotais.Clear;
begin
  if Assigned(ftribCalc) then ftribCalc.Clear;
end;

function TACBrCalcValoresTotais.IsEmpty: Boolean;
begin
  Result := (not Assigned(ftribCalc)) or ftribCalc.IsEmpty;
end;

procedure TACBrCalcValoresTotais.Assign(Source: TACBrCalcValoresTotais);
begin
  if not Assigned(Source) then Exit;
  tribCalc.Assign(Source.tribCalc);
end;

function TACBrCalcValoresTotais.GetTribCalc: TACBrCalcTributosTotais;
begin
  if not Assigned(ftribCalc) then
    ftribCalc := TACBrCalcTributosTotais.Create('tribCalc');
  Result := ftribCalc;
end;

{ TACBrCalcObjeto }

function TACBrCalcObjeto.GettribCalc: TACBrCalcTributos;
begin
  if (not Assigned(ftribCalc)) then
    ftribCalc := TACBrCalcTributos.Create('tribCalc');
  Result := ftribCalc;
end;

procedure TACBrCalcObjeto.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcObjeto) then
    Assign(TACBrCalcObjeto(aSource));
end;

procedure TACBrCalcObjeto.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.AddPair('nObj', fnObj);
  if Assigned(ftribCalc) then ftribCalc.WriteToJSon(aJSon);
end;

procedure TACBrCalcObjeto.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon.Value('nObj', fnObj);
  tribCalc.ReadFromJSon(aJSon);
end;

destructor TACBrCalcObjeto.Destroy;
begin
  if Assigned(ftribCalc) then ftribCalc.Free;
  inherited Destroy;
end;

procedure TACBrCalcObjeto.Clear;
begin
  fnObj := 0;
  if Assigned(ftribCalc) then ftribCalc.Clear;
end;

function TACBrCalcObjeto.IsEmpty: Boolean;
begin
  Result := EstaZerado(fnObj) and ((not Assigned(ftribCalc)) or ftribCalc.IsEmpty);
end;

procedure TACBrCalcObjeto.Assign(Source: TACBrCalcObjeto);
begin
  if not Assigned(Source) then Exit;
  fnObj := Source.nObj;
  tribCalc.Assign(Source.tribCalc);
end;

{ TACBrCalcObjetos }

function TACBrCalcObjetos.GetItem(Index: Integer): TACBrCalcObjeto;
begin
  Result := TACBrCalcObjeto(inherited Items[Index]);
end;

procedure TACBrCalcObjetos.SetItem(Index: Integer; AValue: TACBrCalcObjeto);
begin
  inherited Items[Index] := AValue;
end;

function TACBrCalcObjetos.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrCalcObjetos.Add(aItem: TACBrCalcObjeto): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrCalcObjetos.Insert(Index: Integer; aItem: TACBrCalcObjeto);
begin
  inherited Insert(Index, aItem);
end;

function TACBrCalcObjetos.New: TACBrCalcObjeto;
begin
  Result := TACBrCalcObjeto.Create;
  Self.Add(Result);
end;

{ TACBrCalcROC }

procedure TACBrCalcROC.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcROC) then
    Assign(TACBrCalcROC(aSource));
end;

procedure TACBrCalcROC.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  if Assigned(fobjetos) then fobjetos.WriteToJSon(aJSon);
  if Assigned(ftotal) then ftotal.WriteToJSon(aJSon);
end;

procedure TACBrCalcROC.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then Exit;
  objetos.ReadFromJSon(aJSon);
  total.ReadFromJSon(aJSon);
end;

destructor TACBrCalcROC.Destroy;
begin
  if Assigned(fobjetos) then fobjetos.Free;
  if Assigned(ftotal) then ftotal.Free;
  inherited Destroy;
end;

procedure TACBrCalcROC.Clear;
begin
  if Assigned(fobjetos) then fobjetos.Clear;
  if Assigned(ftotal) then ftotal.Clear;
end;

function TACBrCalcROC.IsEmpty: Boolean;
begin
  Result := ((not Assigned(fobjetos)) or (fobjetos.Count = 0)) and
            ((not Assigned(ftotal)) or ftotal.IsEmpty);
end;

procedure TACBrCalcROC.Assign(Source: TACBrCalcROC);
begin
  if not Assigned(Source) then Exit;
  objetos.Assign(Source.objetos);
  total.Assign(Source.total);
end;

function TACBrCalcROC.GetObjetos: TACBrCalcObjetos;
begin
  if not Assigned(fobjetos) then
    fobjetos := TACBrCalcObjetos.Create('objetos');
  Result := fobjetos;
end;

function TACBrCalcROC.GetTotal: TACBrCalcValoresTotais;
begin
  if not Assigned(ftotal) then
    ftotal := TACBrCalcValoresTotais.Create('total');
  Result := ftotal;
end;

{ TACBrCalcImpostoSeletivo }

procedure TACBrCalcImpostoSeletivo.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcImpostoSeletivo) then
    Assign(TACBrCalcImpostoSeletivo(aSource));
end;

procedure TACBrCalcImpostoSeletivo.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('cst', fcst, False)
    .AddPair('baseCalculo', fbaseCalculo)
    .AddPair('quantidade', fquantidade, False)
    .AddPair('unidade', funidade, False)
    .AddPair('impostoInformado', fimpostoInformado)
    .AddPair('cClassTrib', fcClassTrib);
end;

procedure TACBrCalcImpostoSeletivo.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('cst', fcst)
    .Value('baseCalculo', fbaseCalculo)
    .Value('quantidade', fquantidade)
    .Value('unidade', funidade)
    .Value('impostoInformado', fimpostoInformado)
    .Value('cClassTrib', fcClassTrib);
end;

procedure TACBrCalcImpostoSeletivo.Clear;
begin
  fcst := EmptyStr;
  fbaseCalculo := 0;
  fquantidade := 0;
  funidade := EmptyStr;
  fimpostoInformado := 0;
  fcClassTrib := EmptyStr;
end;

function TACBrCalcImpostoSeletivo.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fcst) and
    EstaZerado(fbaseCalculo) and
    EstaZerado(fquantidade) and
    EstaVazio(funidade) and
    EstaZerado(fimpostoInformado) and
    EstaVazio(fcClassTrib);
end;

procedure TACBrCalcImpostoSeletivo.Assign(Source: TACBrCalcImpostoSeletivo);
begin
  if not Assigned(Source) then
    Exit;

  fcst := Source.cst;
  fbaseCalculo := Source.baseCalculo;
  fquantidade := Source.quantidade;
  funidade := Source.unidade;
  fimpostoInformado := Source.impostoInformado;
  fcClassTrib := Source.cClassTrib;
end;

{ TACBrCalcTributacaoRegular }

procedure TACBrCalcTributacaoRegular.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcTributacaoRegular) then
    Assign(TACBrCalcTributacaoRegular(aSource));
end;

procedure TACBrCalcTributacaoRegular.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('cst', fcst, False)
    .AddPair('cClassTrib', fcClassTrib, False);
end;

procedure TACBrCalcTributacaoRegular.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('cst', fcst)
    .Value('cClassTrib', fcClassTrib);
end;

procedure TACBrCalcTributacaoRegular.Clear;
begin
  fcst := EmptyStr;
  fcClassTrib := EmptyStr;
end;

function TACBrCalcTributacaoRegular.IsEmpty: Boolean;
begin
  Result := EstaVazio(fcst) and EstaVazio(fcClassTrib);
end;

procedure TACBrCalcTributacaoRegular.Assign(Source: TACBrCalcTributacaoRegular);
begin
  if not Assigned(Source) then
    Exit;

  fcst := Source.cst;
  fcClassTrib := Source.cClassTrib;
end;

{ TACBrCalcOperacaoItem }

procedure TACBrCalcOperacaoItem.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcOperacaoItem) then
    Assign(TACBrCalcOperacaoItem(aSource));
end;

procedure TACBrCalcOperacaoItem.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('numero', fnumero)
    .AddPair('ncm', fncm, False)
    .AddPair('nbs', fnbs, False)
    .AddPair('cst', fcst)
    .AddPair('baseCalculo', fbaseCalculo)
    .AddPair('quantidade', fquantidade, False)
    .AddPair('unidade', funidade, False);

  if Assigned(fimpostoSeletivo) then fimpostoSeletivo.WriteToJSon(aJSon);
  if Assigned(ftributacaoRegular) then ftributacaoRegular.WriteToJSon(aJSon);

  aJSon.AddPair('cClassTrib', fcClassTrib);
end;

procedure TACBrCalcOperacaoItem.DoReadFromJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .Value('numero', fnumero)
    .Value('ncm', fncm)
    .Value('nbs', fnbs)
    .Value('cst', fcst)
    .Value('baseCalculo', fbaseCalculo)
    .Value('quantidade', fquantidade)
    .Value('unidade', funidade)
    .Value('cClassTrib', fcClassTrib);

  impostoSeletivo.ReadFromJSon(aJSon);
  tributacaoRegular.ReadFromJSon(aJSon);
end;

destructor TACBrCalcOperacaoItem.Destroy;
begin
  if Assigned(fimpostoSeletivo) then fimpostoSeletivo.Free;
  if Assigned(ftributacaoRegular) then ftributacaoRegular.Free;
  inherited Destroy;
end;

procedure TACBrCalcOperacaoItem.Clear;
begin
  fnumero := 0;
  fncm := EmptyStr;
  fnbs := EmptyStr;
  fcst := EmptyStr;
  fbaseCalculo := 0;
  fquantidade := 0;
  funidade := EmptyStr;
  fcClassTrib := EmptyStr;
  if Assigned(fimpostoSeletivo) then fimpostoSeletivo.Clear;
  if Assigned(ftributacaoRegular) then ftributacaoRegular.Clear;
end;

function TACBrCalcOperacaoItem.IsEmpty: Boolean;
begin
  Result :=
    EstaZerado(fnumero) and
    EstaVazio(fncm) and
    EstaVazio(fnbs) and
    EstaVazio(fcst) and
    EstaZerado(fbaseCalculo) and
    EstaZerado(fquantidade) and
    EstaVazio(funidade) and
    EstaVazio(fcClassTrib) and
    ((not Assigned(fimpostoSeletivo)) or fimpostoSeletivo.IsEmpty) and
    ((not Assigned(ftributacaoRegular)) or ftributacaoRegular.IsEmpty);
end;

procedure TACBrCalcOperacaoItem.Assign(Source: TACBrCalcOperacaoItem);
begin
  if not Assigned(Source) then
    Exit;

  fnumero := Source.numero;
  fncm := Source.ncm;
  fnbs := Source.nbs;
  fcst := Source.cst;
  fbaseCalculo := Source.baseCalculo;
  fquantidade := Source.quantidade;
  funidade := Source.unidade;
  fcClassTrib := Source.cClassTrib;
  impostoSeletivo.Assign(Source.impostoSeletivo);
  tributacaoRegular.Assign(Source.tributacaoRegular);
end;

function TACBrCalcOperacaoItem.GetImpostoSeletivo: TACBrCalcImpostoSeletivo;
begin
  if not Assigned(fimpostoSeletivo) then
    fimpostoSeletivo := TACBrCalcImpostoSeletivo.Create('impostoSeletivo');
  Result := fimpostoSeletivo;
end;

function TACBrCalcOperacaoItem.GetTributacaoRegular: TACBrCalcTributacaoRegular;
begin
  if not Assigned(ftributacaoRegular) then
    ftributacaoRegular := TACBrCalcTributacaoRegular.Create('tributacaoRegular');
  Result := ftributacaoRegular;
end;

{ TACBrCalcOperacaoItens }

function TACBrCalcOperacaoItens.GetItem(Index: Integer): TACBrCalcOperacaoItem;
begin
  Result := TACBrCalcOperacaoItem(inherited Items[Index]);
end;

procedure TACBrCalcOperacaoItens.SetItem(Index: Integer; AValue: TACBrCalcOperacaoItem);
begin
  inherited Items[Index] := AValue;
end;

function TACBrCalcOperacaoItens.NewSchema: TACBrAPISchema;
begin
  Result := New;
end;

function TACBrCalcOperacaoItens.Add(aItem: TACBrCalcOperacaoItem): Integer;
begin
  Result := inherited Add(aItem);
end;

procedure TACBrCalcOperacaoItens.Insert(Index: Integer; aItem: TACBrCalcOperacaoItem);
begin
  inherited Insert(Index, aItem);
end;

function TACBrCalcOperacaoItens.New: TACBrCalcOperacaoItem;
begin
  Result := TACBrCalcOperacaoItem.Create;
  Self.Add(Result);
end;

{ TACBrCalcOperacao }

procedure TACBrCalcOperacao.AssignSchema(aSource: TACBrAPISchema);
begin
  if Assigned(aSource) and (aSource is TACBrCalcOperacao) then
    Assign(TACBrCalcOperacao(aSource));
end;

procedure TACBrCalcOperacao.DoWriteToJSon(aJSon: TACBrJSONObject);
begin
  if not Assigned(aJSon) then
    Exit;

  aJSon
    .AddPair('id', fid)
    .AddPair('versao', fversao)
    .AddPair('dataHoraEmissao', DateTimeToIso8601(fdataHoraEmissao))
    .AddPair('municipio', fmunicipio)
    .AddPair('uf', fuf);

  if Assigned(fitens) then fitens.WriteToJSon(aJSon);
end;

procedure TACBrCalcOperacao.DoReadFromJSon(aJSon: TACBrJSONObject);
var
  s: String;
begin
  if not Assigned(aJSon) then
    Exit;

  {$IfDef FPC}
  s := EmptyStr;
  {$EndIf}

  aJSon
    .Value('id', fid)
    .Value('versao', fversao)
    .Value('dataHoraEmissao', s)
    .Value('municipio', fmunicipio)
    .Value('uf', fuf);
  if NaoEstaVazio(s) then
    fdataHoraEmissao := Iso8601ToDateTime(s);
  itens.ReadFromJSon(aJSon);
end;

destructor TACBrCalcOperacao.Destroy;
begin
  if Assigned(fitens) then
    fitens.Free;
  inherited Destroy;
end;

procedure TACBrCalcOperacao.Clear;
begin
  fid := EmptyStr;
  fversao := EmptyStr;
  fdataHoraEmissao := 0;
  fmunicipio := 0;
  fuf := EmptyStr;
  if Assigned(fitens) then
    fitens.Clear;
end;

function TACBrCalcOperacao.IsEmpty: Boolean;
begin
  Result :=
    EstaVazio(fid) and
    EstaVazio(fversao) and
    EstaZerado(fdataHoraEmissao) and
    EstaZerado(fmunicipio) and
    EstaVazio(fuf) and
    ((not Assigned(fitens)) or (fitens.Count = 0));
end;

procedure TACBrCalcOperacao.Assign(Source: TACBrCalcOperacao);
begin
  if not Assigned(Source) then
    Exit;

  fid := Source.id;
  fversao := Source.versao;
  fdataHoraEmissao := Source.dataHoraEmissao;
  fmunicipio := Source.municipio;
  fuf := Source.uf;
  itens.Assign(Source.itens);
end;

function TACBrCalcOperacao.GetItens: TACBrCalcOperacaoItens;
begin
  if not Assigned(fitens) then
    fitens := TACBrCalcOperacaoItens.Create('itens');
  Result := fitens;
end;

end. 
