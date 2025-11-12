{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit pcnCIOT;

interface

uses
  SysUtils, Classes,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  ACBrCIOTConversao;

type

  TIntegradora = class(TObject)
  private
    FToken: string;
    FIntegrador: string;
    FSenha: string;
    FUsuario: string;

    FIntegradora: TCIOTIntegradora;
    FOperacao: TpOperacao;
  public
    property Token: string read FToken write FToken;
    property Integrador: string read FIntegrador write FIntegrador;
    property Senha: string read FSenha write FSenha;
    property Usuario: string read FUsuario write FUsuario;

    property Integradora: TCIOTIntegradora read FIntegradora write FIntegradora;
    property Operacao: TpOperacao read FOperacao write FOperacao;
  end;

  TTelefone = class(TObject)
  private
    FOperadoraId: integer;
    FDDD: integer;
    FNumero: integer;
  public
    property OperadoraId: integer read FOperadoraId write FOperadoraId;
    property DDD: integer read FDDD write FDDD;
    property Numero: integer read FNumero write FNumero;
  end;

  TTelefones = class(TObject)
  private
    FCelular: TTelefone;
    FFixo: TTelefone;
    FFax: TTelefone;
  public
    constructor Create;
    destructor Destroy; override;

    property Celular: TTelefone read FCelular write FCelular;
    property Fixo: TTelefone read FFixo write FFixo;
    property Fax: TTelefone read FFax write FFax;
  end;

  TEndereco = class(TObject)
  private
    FRua: String;
    FNumero: String;
    FComplemento: String;
    FBairro: String;
    FCodigoMunicipio: Integer;
    FxMunicipio: String;
    FCEP: string;
    FxPais: string;
    FUf: string;
    FPropriedadeTipoId: Integer;
    FResideDesde: string;

    procedure SetCEP(const Value: string);
  public
    property Rua: String read FRua    write FRua;
    property Numero: String read FNumero     write FNumero;
    property Complemento: String read FComplemento    write FComplemento;
    property Bairro: String read FBairro write FBairro;
    property CodigoMunicipio: Integer read FCodigoMunicipio    write FCodigoMunicipio;
    property xMunicipio: String read FxMunicipio    write FxMunicipio;
    property CEP: string read FCEP     write SetCEP;
    property xPais: string read FxPais write FxPais;
    property Uf: string read FUf write FUf;
    property PropriedadeTipoId: Integer read FPropriedadeTipoId write FPropriedadeTipoId;
    property ResideDesde: string read FResideDesde write FResideDesde;
  end;

  TCartao = class(TObject)
  private
    FNumero: string;
    FNumeroControle: string;
    FEmpresaNome: string;
    FEmpresaCNPJ: string;
    FEmpresaRNTRC: string;
  public
    property Numero: string read FNumero write FNumero;
    property NumeroControle: string read FNumeroControle write FNumeroControle;
    property EmpresaNome: string read FEmpresaNome write FEmpresaNome;
    property EmpresaCNPJ: string read FEmpresaCNPJ write FEmpresaCNPJ;
    property EmpresaRNTRC: string read FEmpresaRNTRC write FEmpresaRNTRC;
  end;

  TInformacoesBancarias = class(TObject)
  private
    FInstituicaoBancaria: string;
    FAgencia: string;
    FDigitoAgencia: string;
    FConta: string;
    FTipoConta: tpTipoConta;
    FCartao: TCartao;
  public
    constructor Create;
    destructor Destroy; override;

    property InstituicaoBancaria: string read FInstituicaoBancaria write FInstituicaoBancaria;
    property Agencia: string read FAgencia write FAgencia;
    property DigitoAgencia: string read FDigitoAgencia write FDigitoAgencia;
    property Conta: string read FConta write FConta;
    property TipoConta: tpTipoConta read FTipoConta write FTipoConta;
    property Cartao: TCartao read FCartao write FCartao;
  end;

  TPessoa = class(TObject)
  private
    FCodigoNaIntegradora: Integer;
    FNomeOuRazaoSocial: string;
    FCpfOuCnpj: string;
    FRg: string;
    FRgUf: string;
    FRgEmissorId: Integer;
    FRgDataEmissao: TDateTime;
    FDataNascimento: TDateTime;
    FEndereco: TEndereco;
    FEMail: string;
    FSexo: string;
    FTelefones: TTelefones;
    FRNTRC: string;
    FMeioPagamentoId: Integer;
    FConsumoResponsavelCpf: string;
    FConsumoResponsavelNome: string;
    FInformacoesBancarias: TInformacoesBancarias;
    FResponsavelPeloPagamento: Boolean;
    FNacionalidadeId: Integer;
    FNaturalidadeIbge: Integer;
    FEscolaridade: Integer;
    FQualificacao: Integer;
    FEstadoCivil: Integer;
    FNomeMae: string;
    FNumDependentes: Integer;
    FPISPASEP: string;

    procedure SetCpfOuCnpj(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    property CodigoNaIntegradora: Integer read FCodigoNaIntegradora write FCodigoNaIntegradora;
    property NomeOuRazaoSocial: string read FNomeOuRazaoSocial write FNomeOuRazaoSocial;
    property CpfOuCnpj: string read FCpfOuCnpj write SetCpfOuCnpj;
    property Rg: string read FRg write FRg;
    property RgUf: string read FRgUf write FRgUf;
    property RgEmissorId: Integer read FRgEmissorId write FRgEmissorId;
    property RgDataEmissao: TDateTime read FRgDataEmissao write FRgDataEmissao;
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property Endereco: TEndereco read FEndereco write FEndereco;
    property EMail: string read FEMail write FEMail;
    property Sexo: string read FSexo write FSexo;
    property Telefones: TTelefones read FTelefones write FTelefones;
    property RNTRC: string read FRNTRC write FRNTRC;
    property MeioPagamentoId: Integer read FMeioPagamentoId write FMeioPagamentoId;
    property ConsumoResponsavelCpf: string read FConsumoResponsavelCpf write FConsumoResponsavelCpf;
    property ConsumoResponsavelNome: string read FConsumoResponsavelNome write FConsumoResponsavelNome;
    property InformacoesBancarias: TInformacoesBancarias read FInformacoesBancarias write FInformacoesBancarias;
    property ResponsavelPeloPagamento: Boolean read FResponsavelPeloPagamento write FResponsavelPeloPagamento;
    property NacionalidadeId: Integer read FNacionalidadeId write FNacionalidadeId;
    property NaturalidadeIbge: Integer read FNaturalidadeIbge write FNaturalidadeIbge;
    property Escolaridade: Integer read FEscolaridade write FEscolaridade;
    property Qualificacao: Integer read FQualificacao write FQualificacao;
    property EstadoCivil: Integer read FEstadoCivil write FEstadoCivil;
    property NomeMae: string read FNomeMae write FNomeMae;
    property NumDependentes: Integer read FNumDependentes write FNumDependentes;
    property PISPASEP: string read FPISPASEP write FPISPASEP;
  end;

  TMotorista = class(TPessoa)
  private
    FCNH: string;
    FCelular: TTelefone;
  public
    constructor Create;
    destructor Destroy; override;

    property CNH: string read FCNH write FCNH;
    property Celular: TTelefone read FCelular write FCelular; //Ja existe em Telefones, mantido para compatibilidade com o código atual do E-Frete.
  end;

  TPagamentoCollectionItem = class(TObject)
  private
    FIdIntegradora: string;
    FIdPagamentoCliente: string;
    FDataDeLiberacao: TDateTime;
    FValor: Double;
    FTipoPagamento: TpTipoPagamento;
    FCategoria: TpTipoCategoriaPagamento;
    FDocumento: string;
    FInformacoesBancarias: TInformacoesBancarias;
    FInformacaoAdicional: string;
    FCnpjFilialAbastecimento: string;
  public
    constructor Create;
    destructor Destroy; override;

    property IdIntegradora: string read FIdIntegradora write FIdIntegradora;
    property IdPagamentoCliente: string read FIdPagamentoCliente write FIdPagamentoCliente;
    property DataDeLiberacao: TDateTime read FDataDeLiberacao write FDataDeLiberacao;
    property Valor: Double read FValor write FValor;
    property TipoPagamento: TpTipoPagamento read FTipoPagamento write FTipoPagamento;
    property Categoria: TpTipoCategoriaPagamento read FCategoria write FCategoria;
    property Documento: string read FDocumento write FDocumento;
    property InformacoesBancarias: TInformacoesBancarias read FInformacoesBancarias write FInformacoesBancarias;
    property InformacaoAdicional: string read FInformacaoAdicional write FInformacaoAdicional;
    property CnpjFilialAbastecimento: string read FCnpjFilialAbastecimento write FCnpjFilialAbastecimento;
  end;

  TPagamentoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TPagamentoCollectionItem;
    procedure SetItem(Index: Integer; Value: TPagamentoCollectionItem);
  public
    function Add: TPagamentoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TPagamentoCollectionItem;
    property Items[Index: Integer]: TPagamentoCollectionItem read GetItem write SetItem; default;
  end;

  TVeiculoCollectionItem = class(TObject)
  private
    FPlaca: String;
    FRNTRC: String;

    procedure SetPlaca(const Value: String);
  public
    property Placa: String read FPlaca write SetPlaca;
    property RNTRC: String read FRNTRC write FRNTRC;
  end;

  TVeiculoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TVeiculoCollectionItem;
    procedure SetItem(Index: Integer; Value: TVeiculoCollectionItem);
  public
    function Add: TVeiculoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TVeiculoCollectionItem;
    property Items[Index: Integer]: TVeiculoCollectionItem read GetItem write SetItem; default;
  end;

  TImpostos = class(TObject)
  private
    FIRRF: Double;
    FSestSenat: Double;
    FINSS: Double;
    FISSQN: Double;
    FOutrosImpostos: Double;
    FDescricaoOutrosImpostos: string;
  public
    property IRRF: Double read FIRRF write FIRRF;
    property SestSenat: Double read FSestSenat write FSestSenat;
    property INSS: Double read FINSS write FINSS;
    property ISSQN: Double read FISSQN write FISSQN;
    property OutrosImpostos: Double read FOutrosImpostos write FOutrosImpostos;
    property DescricaoOutrosImpostos: string read FDescricaoOutrosImpostos write FDescricaoOutrosImpostos;
  end;

  TValoresOT = class(TObject)
  private
    FTotalOperacao: Double;
    FTotalViagem: Double;
    FTotalDeAdiantamento: Double;
    FTotalDeQuitacao: Double;
    FCombustivel: Double;
    FPedagio: Double;
    FOutrosCreditos: Double;
    FJustificativaOutrosCreditos: string;
    FSeguro: Double;
    FOutrosDebitos: Double;
    FJustificativaOutrosDebitos: string;
  public
    property TotalOperacao: Double read FTotalOperacao write FTotalOperacao;
    property TotalViagem: Double read FTotalViagem write FTotalViagem;
    property TotalDeAdiantamento: Double read FTotalDeAdiantamento write FTotalDeAdiantamento;
    property TotalDeQuitacao: Double read FTotalDeQuitacao write FTotalDeQuitacao;
    property Combustivel: Double read FCombustivel write FCombustivel;
    property Pedagio: Double read FPedagio write FPedagio;
    property OutrosCreditos: Double read FOutrosCreditos write FOutrosCreditos;
    property JustificativaOutrosCreditos: string read FJustificativaOutrosCreditos write FJustificativaOutrosCreditos;
    property Seguro: Double read FSeguro write FSeguro;
    property OutrosDebitos: Double read FOutrosDebitos write FOutrosDebitos;
    property JustificativaOutrosDebitos: string read FJustificativaOutrosDebitos write FJustificativaOutrosDebitos;
  end;

  TToleranciaDePerdaDeMercadoria = class(TObject)
  private
    FTipo: TpTipoProporcao;
    FValor: Double;
  public
    property Tipo: TpTipoProporcao read FTipo write FTipo;
    property Valor: Double read FValor write FValor;
  end;

  TDiferencaFreteMargem = class(TObject)
  private
    FTipo: TpTipoProporcao;
    FValor: Double;
  public
    property Tipo: TpTipoProporcao read FTipo write FTipo;
    property Valor: Double read FValor write FValor;
  end;

   TDiferencaDeFrete = class(TObject)
  private
    FTipo: TpDiferencaFrete;
    FBase: TpDiferencaFreteBaseCalculo;
    FTolerancia: TDiferencaFreteMargem;
    FMargemGanho: TDiferencaFreteMargem;
    FMargemPerda: TDiferencaFreteMargem;
  public
    constructor Create;
    destructor Destroy; override;

    property Tipo: TpDiferencaFrete read FTipo write FTipo;
    property Base: TpDiferencaFreteBaseCalculo read FBase write FBase;
    property Tolerancia: TDiferencaFreteMargem read FTolerancia write FTolerancia;
    property MargemGanho: TDiferencaFreteMargem read FMargemGanho write FMargemGanho;
    property MargemPerda: TDiferencaFreteMargem read FMargemPerda write FMargemPerda;
  end;

 TNotaFiscalCollectionItem = class(TObject)
  private
    FTipoDocumentoPamcard: tpTipoDocumentoPamcard;
    FChaveAcesso: string;
    FNumero: string;
    FSerie: string;
    FData: TDateTime;
    FValorTotal: Double;
    FValorDaMercadoriaPorUnidade: Double;
    FCodigoNCMNaturezaCarga: integer;
    FDescricaoDaMercadoria: string;
    FUnidadeDeMedidaDaMercadoria: TpUnidadeDeMedidaDaMercadoria;
    FTipoDeCalculo: TpViagemTipoDeCalculo;
    FValorDoFretePorUnidadeDeMercadoria: Double;
    FQuantidadeDaMercadoriaNoEmbarque: double;
    FQuantidadeDaMercadoriaNoDesembarque: double;
    FToleranciaDePerdaDeMercadoria: TToleranciaDePerdaDeMercadoria;
    FDiferencaDeFrete: TDiferencaDeFrete;
    FEspecie: string;
    FCubagem: Double;
    FPeso: Double;
    FRemetente: TPessoa;
    FDestinatario: TPessoa;
    FConsignatario: TPessoa;
  public
    constructor Create;
    destructor Destroy; override;

    property TipoDocumentoPamcard: tpTipoDocumentoPamcard read FTipoDocumentoPamcard write FTipoDocumentoPamcard;
    property ChaveAcesso: string read FChaveAcesso write FChaveAcesso;
    property Numero: string read FNumero write FNumero;
    property Serie: string read FSerie write FSerie;
    property Data: TDateTime read FData write FData;
    property ValorTotal: Double read FValorTotal write FValorTotal;
    property ValorDaMercadoriaPorUnidade: Double read FValorDaMercadoriaPorUnidade write FValorDaMercadoriaPorUnidade;
    property CodigoNCMNaturezaCarga: integer read FCodigoNCMNaturezaCarga write FCodigoNCMNaturezaCarga;
    property DescricaoDaMercadoria: string read FDescricaoDaMercadoria write FDescricaoDaMercadoria;
    property UnidadeDeMedidaDaMercadoria: TpUnidadeDeMedidaDaMercadoria read FUnidadeDeMedidaDaMercadoria write FUnidadeDeMedidaDaMercadoria;
    property TipoDeCalculo: TpViagemTipoDeCalculo read FTipoDeCalculo write FTipoDeCalculo;
    property ValorDoFretePorUnidadeDeMercadoria: Double read FValorDoFretePorUnidadeDeMercadoria write FValorDoFretePorUnidadeDeMercadoria;
    property QuantidadeDaMercadoriaNoEmbarque: double read FQuantidadeDaMercadoriaNoEmbarque write FQuantidadeDaMercadoriaNoEmbarque;
    property QuantidadeDaMercadoriaNoDesembarque: double read FQuantidadeDaMercadoriaNoDesembarque write FQuantidadeDaMercadoriaNoDesembarque;
    property ToleranciaDePerdaDeMercadoria: TToleranciaDePerdaDeMercadoria read FToleranciaDePerdaDeMercadoria write FToleranciaDePerdaDeMercadoria;
    property DiferencaDeFrete: TDiferencaDeFrete read FDiferencaDeFrete write FDiferencaDeFrete;
    property Especie: string read FEspecie write FEspecie;
    property Cubagem: Double read FCubagem write FCubagem;
    property Peso: Double read FPeso write FPeso;
    property Remetente: TPessoa read FRemetente write FRemetente;
    property Destinatario: TPessoa read FDestinatario write FDestinatario;
    property Consignatario: TPessoa read FConsignatario write FConsignatario;
  end;

  TNotaFiscalCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TNotaFiscalCollectionItem;
    procedure SetItem(Index: Integer; Value: TNotaFiscalCollectionItem);
  public
    function Add: TNotaFiscalCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TNotaFiscalCollectionItem;
    property Items[Index: Integer]: TNotaFiscalCollectionItem read GetItem write SetItem; default;
  end;

  TViagemCollectionItem = class(TObject)
  private
    FDocumentoViagem: string;
    FCodigoMunicipioOrigem: integer;
    FCodigoMunicipioDestino: integer;
    FCepOrigem: string;
    FCepDestino: string;
    FDistanciaPercorrida: Integer;
    FValores: TValoresOT;
    FTipoPagamento: TpTipoPagamento;
    FInformacoesBancarias: TInformacoesBancarias;
    FNotasFiscais: TNotaFiscalCollection;

    procedure SetNotasFiscais(const Value: TNotaFiscalCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property DocumentoViagem: string read FDocumentoViagem write FDocumentoViagem;
    property CodigoMunicipioOrigem: integer read FCodigoMunicipioOrigem write FCodigoMunicipioOrigem;
    property CodigoMunicipioDestino: integer read FCodigoMunicipioDestino write FCodigoMunicipioDestino;
    property CepOrigem: string read FCepOrigem write FCepOrigem;
    property CepDestino: string read FCepDestino write FCepDestino;
    property DistanciaPercorrida: Integer read FDistanciaPercorrida write FDistanciaPercorrida;
    property Valores: TValoresOT read FValores write FValores;
    property TipoPagamento: TpTipoPagamento read FTipoPagamento write FTipoPagamento;
    property InformacoesBancarias: TInformacoesBancarias read FInformacoesBancarias write FInformacoesBancarias;
    property NotasFiscais: TNotaFiscalCollection read FNotasFiscais write SetNotasFiscais;
  end;

  TViagemCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TViagemCollectionItem;
    procedure SetItem(Index: Integer; Value: TViagemCollectionItem);
  public
    function Add: TViagemCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TViagemCollectionItem;
    property Items[Index: Integer]: TViagemCollectionItem read GetItem write SetItem; default;
  end;

  TRotaPontoCollectionItem = class(TObject)
  private
    FPaisNome: string;
    FEstadoNome: string;
    FCidadeNome: string;
    FCidadeIbge: Integer;
    FCidadeCep: string;
    FCidadeLatitude: string;
    FCidadeLongitude: string;
    FEixoSuspenso: Boolean;
    FKm: Double;
  public
    property PaisNome: string read FPaisNome write FPaisNome;
    property EstadoNome: string read FEstadoNome write FEstadoNome;
    property CidadeNome: string read FCidadeNome write FCidadeNome;
    property CidadeIbge: Integer read FCidadeIbge write FCidadeIbge;
    property CidadeCep: string read FCidadeCep write FCidadeCep;
    property CidadeLatitude: string read FCidadeLatitude write FCidadeLatitude;
    property CidadeLongitude: string read FCidadeLongitude write FCidadeLongitude;
    property EixoSuspenso: Boolean read FEixoSuspenso write FEixoSuspenso;
    property Km: Double read FKm write FKm;
  end;

  TRotaPontosCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRotaPontoCollectionItem;
    procedure SetItem(Index: Integer; Value: TRotaPontoCollectionItem);
  public
    function Add: TRotaPontoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TRotaPontoCollectionItem;
    property Items[Index: Integer]: TRotaPontoCollectionItem read GetItem write SetItem; default;
  end;

  TRota = class(TObject)
  private
    FId: Integer;
    FIdCliente: Integer;
    FNome: string;

    FOrigemCidadeNome: string;
    FOrigemCidadeIbge: Integer;
    FOrigemCidadeLatitude: string;
    FOrigemCidadeLongitude: string;
    FOrigemCidadeCep: string;
    FOrigemEstadoNome: string;
    FOrigemPaisNome: string;
    FOrigemEixoSuspenso: Boolean;

    FDestinoCidadeNome: string;
    FDestinoCidadeIbge: Integer;
    FDestinoCidadeLatitude: string;
    FDestinoCidadeLongitude: string;
    FDestinoCidadeCep: string;
    FDestinoEstadoNome: string;
    FDestinoPaisNome: string;
    FDestinoEixoSuspenso: Boolean;

    FPontos: TRotaPontosCollection;
    FObterPostos: Boolean;
    FObterUf: Boolean;
    procedure SetPontos(const Value: TRotaPontosCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write FId;
    property IdCliente: Integer read FIdCliente write FIdCliente;
    property Nome: string read FNome write FNome;

    property OrigemCidadeNome: string read FOrigemCidadeNome write FOrigemCidadeNome;
    property OrigemCidadeIbge: Integer read FOrigemCidadeIbge write FOrigemCidadeIbge;
    property OrigemCidadeLatitude: string read FOrigemCidadeLatitude write FOrigemCidadeLatitude;
    property OrigemCidadeLongitude: string read FOrigemCidadeLongitude write FOrigemCidadeLongitude;
    property OrigemCidadeCep: string read FOrigemCidadeCep write FOrigemCidadeCep;
    property OrigemEstadoNome: string read FOrigemEstadoNome write FOrigemEstadoNome;
    property OrigemPaisNome: string read FOrigemPaisNome write FOrigemPaisNome;
    property OrigemEixoSuspenso: Boolean read FOrigemEixoSuspenso write FOrigemEixoSuspenso;

    property DestinoCidadeNome: string read FDestinoCidadeNome write FDestinoCidadeNome;
    property DestinoCidadeIbge: Integer read FDestinoCidadeIbge write FDestinoCidadeIbge;
    property DestinoCidadeLatitude: string read FDestinoCidadeLatitude write FDestinoCidadeLatitude;
    property DestinoCidadeLongitude: string read FDestinoCidadeLongitude write FDestinoCidadeLongitude;
    property DestinoCidadeCep: string read FDestinoCidadeCep write FDestinoCidadeCep;
    property DestinoEstadoNome: string read FDestinoEstadoNome write FDestinoEstadoNome;
    property DestinoPaisNome: string read FDestinoPaisNome write FDestinoPaisNome;
    property DestinoEixoSuspenso: Boolean read FDestinoEixoSuspenso write FDestinoEixoSuspenso;

    property Pontos: TRotaPontosCollection read FPontos write SetPontos;
    property ObterPostos: Boolean read FObterPostos write FObterPostos;
    property ObterUf: Boolean read FObterUf write FObterUf;
  end;

  TPedagioPracaCollectionItem = class(TObject)
  private
    FId: Integer;
    FSeq: Integer;
    FNome: string;
    FKm: Double;
    FValor: Double;
  public
    property Id: Integer read FId write FId;
    property Seq: Integer read FSeq write FSeq;
    property Nome: string read FNome write FNome;
    property Km: Double read FKm write FKm;
    property Valor: Double read FValor write FValor;
  end;

  TPedagioPracaCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TPedagioPracaCollectionItem;
    procedure SetItem(Index: Integer; Value: TPedagioPracaCollectionItem);
  public
    function Add: TPedagioPracaCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TPedagioPracaCollectionItem;
    property Items[Index: Integer]: TPedagioPracaCollectionItem read GetItem write SetItem; default;
  end;

  TPedagio = class(TObject)
  private
    FCartaoNumero: string;
    FTag: string;
    FIdaVolta: Boolean;
    FObterPraca: Boolean;
    FObterRota: Boolean;
    FRoteirizar: Boolean;
    FSolucaoId: Integer;
    FStatusId: Integer;
    FValor: Double;
    FValorCarregado: Double;
    FTagEmissorId: Integer;
    FCaminho: Integer;
    FProtocolo: string;
    FKm: Double;
    FQtde: Double;
    FTempoPercurso: string;
    FPracas: TPedagioPracaCollection;
    procedure SetPracas(const Value: TPedagioPracaCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property CartaoNumero: string read FCartaoNumero write FCartaoNumero;
    property Tag: string read FTag write FTag;
    property IdaVolta: Boolean read FIdaVolta write FIdaVolta;
    property ObterPraca: Boolean read FObterPraca write FObterPraca;
    property ObterRota: Boolean read FObterRota write FObterRota;
    property Roteirizar: Boolean read FRoteirizar write FRoteirizar;
    property SolucaoId: Integer read FSolucaoId write FSolucaoId;
    property StatusId: Integer read FStatusId write FStatusId;
    property Valor: Double read FValor write FValor;
    property ValorCarregado: Double read FValorCarregado write FValorCarregado;
    property TagEmissorId: Integer read FTagEmissorId write FTagEmissorId;
    property Caminho: Integer read FCaminho write FCaminho;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Km: Double read FKm write FKm;
    property Qtde: Double read FQtde write FQtde;
    property TempoPercurso: string read FTempoPercurso write FTempoPercurso;
    property Pracas: TPedagioPracaCollection read FPracas write SetPracas;
  end;

  TPostoCollectionItem = class(TObject)
  private
    FBandeira: string;
    FDocumentoNumero: string;
    FNomeFantasia: string;
    FEndereco: TEndereco;
  public
    constructor Create;
    destructor Destroy; override;

    property Bandeira: string read FBandeira write FBandeira;
    property DocumentoNumero: string read FDocumentoNumero write FDocumentoNumero;
    property NomeFantasia: string read FNomeFantasia write FNomeFantasia;
    property Endereco: TEndereco read FEndereco write FEndereco;
  end;

  TPostoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TPostoCollectionItem;
    procedure SetItem(Index: Integer; Value: TPostoCollectionItem);
  public
    function Add: TPostoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TPostoCollectionItem;
    property Items[Index: Integer]: TPostoCollectionItem read GetItem write SetItem; default;
  end;

  TFreteItemCollectionItem = class(TObject)
  private
    FTipo: Integer;
    FTarifaQuantidade: Integer;
    FValor: Double;
  public
    constructor Create;

    property Tipo: Integer read FTipo write FTipo;
    property TarifaQuantidade: Integer read FTarifaQuantidade write FTarifaQuantidade;
    property Valor: Double read FValor write FValor;
  end;

  TFreteItemCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TFreteItemCollectionItem;
    procedure SetItem(Index: Integer; Value: TFreteItemCollectionItem);
  public
    function Add: TFreteItemCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TFreteItemCollectionItem;
    property Items[Index: Integer]: TFreteItemCollectionItem read GetItem write SetItem; default;
  end;

  TFrete = class(TObject)
  private
    FValorBruto: Double;
    FValorBaseApuracao: Double;
    FItens: TFreteItemCollection;
    procedure SetItens(const Value: TFreteItemCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property ValorBruto: Double read FValorBruto write FValorBruto;
    property ValorBaseApuracao: Double read FValorBaseApuracao write FValorBaseApuracao;
    property Itens: TFreteItemCollection read FItens write SetItens;
  end;

  TParcelaCollectionItem = class(TObject)
  private
    FData: TDateTime;
    FEfetivacaoTipo: Integer;
    FFavorecidoTipoId: Integer;
    FNumeroCliente: string;
    FStatusId: Integer;
    FSubtipo: Integer;
    FValor: Double;
  public
    property Data: TDateTime read FData write FData;
    property EfetivacaoTipo: Integer read FEfetivacaoTipo write FEfetivacaoTipo;
    property FavorecidoTipoId: Integer read FFavorecidoTipoId write FFavorecidoTipoId;
    property NumeroCliente: string read FNumeroCliente write FNumeroCliente;
    property StatusId: Integer read FStatusId write FStatusId;
    property Subtipo: Integer read FSubtipo write FSubtipo;
    property Valor: Double read FValor write FValor;
  end;

  TParcelaCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TParcelaCollectionItem;
    procedure SetItem(Index: Integer; Value: TParcelaCollectionItem);
  public
    function Add: TParcelaCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TParcelaCollectionItem;
    property Items[Index: Integer]: TParcelaCollectionItem read GetItem write SetItem; default;
  end;

  TDescontoFaixaCollectionItem = class(TObject)
  private
    FAte: Double;
    FPercentual: Double;
  public
    property Ate: Double read FAte write FAte;
    property Percentual: Double read FPercentual write FPercentual;
  end;

  TDescontoFaixaCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TDescontoFaixaCollectionItem;
    procedure SetItem(Index: Integer; Value: TDescontoFaixaCollectionItem);
  public
    function Add: TDescontoFaixaCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TDescontoFaixaCollectionItem;
    property Items[Index: Integer]: TDescontoFaixaCollectionItem read GetItem write SetItem; default;
  end;

  TUfsCollectionItem = class(TObject)
  private
    FSigla: string;
  public
    property Sigla: string read FSigla write FSigla;
  end;

  TUfsCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TUfsCollectionItem;
    procedure SetItem(Index: Integer; Value: TUfsCollectionItem);
  public
    function Add: TUfsCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TUfsCollectionItem;
    property Items[Index: Integer]: TUfsCollectionItem read GetItem write SetItem; default;
  end;

  TCancelamento = class(TObject)
  private
    FMotivo: string;
    FProtocolo: string;
    FData: TDateTime;
    FIdPagamentoCliente: string;
  public
    property Motivo: string read FMotivo write FMotivo;
    property Data: TDateTime read FData write FData;
    property Protocolo: string read FProtocolo write FProtocolo;
    property IdPagamentoCliente: string read FIdPagamentoCliente write FIdPagamentoCliente;
  end;

  TMensagemCollectionItem = class(TObject)
  private
    FMensagem: string;
  public
    property Mensagem: string read FMensagem write FMensagem;
  end;

  TMensagemCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TMensagemCollectionItem;
    procedure SetItem(Index: Integer; Value: TMensagemCollectionItem);
  public
    function Add: TMensagemCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TMensagemCollectionItem;
    property Items[Index: Integer]: TMensagemCollectionItem read GetItem write SetItem; default;
  end;

  TQuitacao = class(TObject)
  private
    FIndicador: Boolean;
    FOrigemPagamento: Integer;
    FPrazo: Integer;
    FEntregaRessalva: Boolean;
    FDescontoTipo: Integer;
    FDescontoTolerancia: Double;
    FDescontoFaixas: TDescontoFaixaCollection;
    procedure SetDescontoFaixas(const Value: TDescontoFaixaCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property Indicador: Boolean read FIndicador write FIndicador;
    property OrigemPagamento: Integer read FOrigemPagamento write FOrigemPagamento;
    property Prazo: Integer read FPrazo write FPrazo;
    property EntregaRessalva: Boolean read FEntregaRessalva write FEntregaRessalva;
    property DescontoTipo: Integer read FDescontoTipo write FDescontoTipo;
    property DescontoTolerancia: Double read FDescontoTolerancia write FDescontoTolerancia;
    property DescontoFaixas: TDescontoFaixaCollection read FDescontoFaixas write SetDescontoFaixas;
  end;

  TObjectBase = class(TObject)
  private
    FMatrizCNPJ: string;
    FFilialCNPJ: string;
  public
    property MatrizCNPJ: string read FMatrizCNPJ write FMatrizCNPJ;
    property FilialCNPJ: string read FFilialCNPJ write FFilialCNPJ;
  end;

  TIncluirCartaoPortador = class(TObjectBase)
  private
    FPortador: TPessoa;
  public
    constructor Create;
    destructor Destroy; override;

    property Portador: TPessoa read FPortador write FPortador;
  end;

  TIncluirRota = class(TObjectBase)
  private
    FRota: TRota;
    FPedagio: TPedagio;
  public
    constructor Create;
    destructor Destroy; override;

    property Rota: TRota read FRota write FRota;
    property Pedagio: TPedagio read FPedagio write FPedagio;
  end;

  TRoterizar = class(TObjectBase)
  private
    FVeiculoCategoria: string;
    FVeiculoCategoriaEixoSuspenso: string;
    FRota: TRota;
    FPedagio: TPedagio;
  public
    constructor Create;
    destructor Destroy; override;

    property VeiculoCategoria: string read FVeiculoCategoria write FVeiculoCategoria;
    property VeiculoCategoriaEixoSuspenso: string read FVeiculoCategoriaEixoSuspenso write FVeiculoCategoriaEixoSuspenso;
    property Rota: TRota read FRota write FRota;
    property Pedagio: TPedagio read FPedagio write FPedagio;
  end;

  TPagamentoPedagio = class(TObjectBase)
  private
    FCodigoIdentificacaoOperacao: string;
    FIdOperacaoIntegradora: string;
    FIdOperacaoCliente: string;
  public
    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property IdOperacaoIntegradora: string read FIdOperacaoIntegradora write FIdOperacaoIntegradora;
    property IdOperacaoCliente: string read FIdOperacaoCliente write FIdOperacaoCliente;
  end;

  TAdicionarOperacao = class(TObjectBase)
  private
    FTipoViagem: TpTipoViagem;
    FTipoPagamento: TpTipoPagamento;
    FBloquearNaoEquiparado: Boolean;
    FIdOperacaoCliente: string;
    FDataInicioViagem: TDateTime;
    FDataFimViagem: TDateTime;
    FCodigoNCMNaturezaCarga: integer;
    FPesoCarga: double;
    FTipoEmbalagem: tpTipoEmbalagem;
    FViagens: TViagemCollection;
    FImpostos: TImpostos;
    FPagamentos: TPagamentoCollection;
    FContratado: TPessoa;
    FMotorista: TMotorista;
    FDestinatario: TPessoa;
    FContratante: TPessoa;
    FSubcontratante: TPessoa;
    FConsignatario: TPessoa;
    FTomadorServico: TPessoa;
    FRemetente: TPessoa;
    FProprietarioCarga: TPessoa;
    FVeiculos: TVeiculoCollection;
    FCodigoIdentificacaoOperacaoPrincipal: string;
    FObservacoesAoTransportador: TMensagemCollection;
    FObservacoesAoCredenciado: TMensagemCollection;
    FEntregaDocumentacao: TpEntregaDocumentacao;
    FQuantidadeSaques: Integer;
    FQuantidadeTransferencias: Integer;
    FValorSaques: Double;
    FValorTransferencias: Double;
    FCiotNumero: Integer;

    FAltoDesempenho: Boolean;
    FDestinacaoComercial: Boolean;
    FFreteRetorno: Boolean;
    FCepRetorno: String;
    FDistanciaRetorno: Integer;

    FIntegrador: string;
    FEmissaoGratuita: Boolean;
    FCodigoTipoCarga: tpTipoCarga;

    FRota: TRota;
    FVeiculoCategoria: string;
    FVeiculoCategoriaEixoSuspenso: string;
    FPedagio: TPedagio;
    FPostos: TPostoCollection;
    FFrete: TFrete;
    FParcelas: TParcelaCollection;
    FQuitacao: TQuitacao;
    FCargaPerfilId: Integer;
    FCargaValorUnitario: Double;
    FDiferencaFreteCredito: Boolean;
    FDiferencaFreteDebito: Boolean;
    FDiferencaFreteTarifaMotorista: Double;
    FComprovacaoObservacao: string;
    FCiotEmissor: TPessoa;
    FContratacaoTipo: Integer;

    procedure SetViagens(const Value: TViagemCollection);
    procedure SetPagamentos(const Value: TPagamentoCollection);
    procedure SetVeiculos(const Value: TVeiculoCollection);
    procedure SetObservacoesAoCredenciado(const Value: TMensagemCollection);
    procedure SetObservacoesAoTransportador(const Value: TMensagemCollection);
    procedure SetPostos(const Value: TPostoCollection);
    procedure SetParcelas(const Value: TParcelaCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property TipoViagem: TpTipoViagem read FTipoViagem write FTipoViagem;
    property TipoPagamento: TpTipoPagamento read FTipoPagamento write FTipoPagamento;
    property EmissaoGratuita: Boolean read FEmissaoGratuita write FEmissaoGratuita;
    property BloquearNaoEquiparado: Boolean read FBloquearNaoEquiparado write FBloquearNaoEquiparado;
    property IdOperacaoCliente: string read FIdOperacaoCliente write FIdOperacaoCliente;
    property DataInicioViagem: TDateTime read FDataInicioViagem write FDataInicioViagem;
    property DataFimViagem: TDateTime read FDataFimViagem write FDataFimViagem;
    property CodigoNCMNaturezaCarga: integer read FCodigoNCMNaturezaCarga write FCodigoNCMNaturezaCarga;
    property PesoCarga: double read FPesoCarga write FPesoCarga;
    property TipoEmbalagem: tpTipoEmbalagem read FTipoEmbalagem write FTipoEmbalagem;
    property Viagens: TViagemCollection read FViagens write SetViagens;
    property Impostos: TImpostos read FImpostos write FImpostos;
    property Pagamentos: TPagamentoCollection read FPagamentos write SetPagamentos;
    property Contratado: TPessoa read FContratado write FContratado;
    property Motorista: TMotorista read FMotorista write FMotorista;
    property Destinatario: TPessoa read FDestinatario write FDestinatario;
    property Contratante: TPessoa read FContratante write FContratante;
    property Subcontratante: TPessoa read FSubcontratante write FSubcontratante;
    property Consignatario: TPessoa read FConsignatario write FConsignatario;
    property TomadorServico: TPessoa read FTomadorServico write FTomadorServico;
    property Remetente: TPessoa read FRemetente write FRemetente;
    property ProprietarioCarga: TPessoa read FProprietarioCarga write FProprietarioCarga;
    property Veiculos: TVeiculoCollection read FVeiculos write SetVeiculos;
    property CodigoIdentificacaoOperacaoPrincipal: string read FCodigoIdentificacaoOperacaoPrincipal write FCodigoIdentificacaoOperacaoPrincipal;
    property ObservacoesAoTransportador: TMensagemCollection read FObservacoesAoTransportador write SetObservacoesAoTransportador;
    property ObservacoesAoCredenciado: TMensagemCollection read FObservacoesAoCredenciado write SetObservacoesAoCredenciado;
    property EntregaDocumentacao: TpEntregaDocumentacao read FEntregaDocumentacao write FEntregaDocumentacao;
    property QuantidadeSaques: Integer read FQuantidadeSaques write FQuantidadeSaques;
    property QuantidadeTransferencias: Integer read FQuantidadeTransferencias write FQuantidadeTransferencias;
    property ValorSaques: Double read FValorSaques write FValorSaques;
    property ValorTransferencias: Double read FValorTransferencias write FValorTransferencias;
    property CiotNumero: Integer read FCiotNumero write FCiotNumero;
    property CodigoTipoCarga: tpTipoCarga read FCodigoTipoCarga write FCodigoTipoCarga;
    property AltoDesempenho: Boolean read FAltoDesempenho write FAltoDesempenho;
    property DestinacaoComercial: Boolean read FDestinacaoComercial write FDestinacaoComercial;
    property FreteRetorno: Boolean read FFreteRetorno write FFreteRetorno;
    property CepRetorno: String read FCepRetorno write FCepRetorno;
    property DistanciaRetorno: Integer read FDistanciaRetorno write FDistanciaRetorno;
    property Rota: TRota read FRota write FRota;
    property VeiculoCategoria: string read FVeiculoCategoria write FVeiculoCategoria;
    property VeiculoCategoriaEixoSuspenso: string read FVeiculoCategoriaEixoSuspenso write FVeiculoCategoriaEixoSuspenso;
    property Pedagio: TPedagio read FPedagio write FPedagio;
    property Postos: TPostoCollection read FPostos write SetPostos;
    property Frete: TFrete read FFrete write FFrete;
    property Parcelas: TParcelaCollection read FParcelas write SetParcelas;
    property Quitacao: TQuitacao read FQuitacao write FQuitacao;
    property CargaPerfilId: Integer read FCargaPerfilId write FCargaPerfilId;
    property CargaValorUnitario: Double read FCargaValorUnitario write FCargaValorUnitario;
    property DiferencaFreteCredito: Boolean read FDiferencaFreteCredito write FDiferencaFreteCredito;
    property DiferencaFreteDebito: Boolean read FDiferencaFreteDebito write FDiferencaFreteDebito;
    property DiferencaFreteTarifaMotorista: Double read FDiferencaFreteTarifaMotorista write FDiferencaFreteTarifaMotorista;
    property ComprovacaoObservacao: string read FComprovacaoObservacao write FComprovacaoObservacao;
    property CiotEmissor: TPessoa read FCiotEmissor write FCiotEmissor;
    property ContratacaoTipo: Integer read FContratacaoTipo write FContratacaoTipo;

    property Integrador: string read FIntegrador write FIntegrador;
  end;

  TObterOperacaoTransportePDF = class(TObject)
  private
    FCodigoIdentificacaoOperacao: string;
    FDocumentoViagem: string;
  public
    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property DocumentoViagem: string read FDocumentoViagem write FDocumentoViagem;
  end;

  TRetificarOperacao = class(TObject)
  private
    FCodigoIdentificacaoOperacao: string;
    FDataInicioViagem: TDateTime;
    FDataFimViagem: TDateTime;
    FCodigoNCMNaturezaCarga: integer;
    FPesoCarga: double;
    FCodigoMunicipioOrigem: integer;
    FCodigoMunicipioDestino: integer;
    FVeiculos: TVeiculoCollection;
    FQuantidadeSaques: Integer;
    FQuantidadeTransferencias: Integer;
    FValorSaques: Double;
    FValorTransferencias: Double;
    FCodigoTipoCarga: tpTipoCarga;
    FCepOrigem: string;
    FCepDestino: string;
    FDistanciaPercorrida: Integer;

    procedure SetVeiculos(const Value: TVeiculoCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property DataInicioViagem: TDateTime read FDataInicioViagem write FDataInicioViagem;
    property DataFimViagem: TDateTime read FDataFimViagem write FDataFimViagem;
    property CodigoNCMNaturezaCarga: integer read FCodigoNCMNaturezaCarga write FCodigoNCMNaturezaCarga;
    property PesoCarga: double read FPesoCarga write FPesoCarga;
    property CodigoMunicipioOrigem: integer read FCodigoMunicipioOrigem write FCodigoMunicipioOrigem;
    property CodigoMunicipioDestino: integer read FCodigoMunicipioDestino write FCodigoMunicipioDestino;
    property Veiculos: TVeiculoCollection read FVeiculos write SetVeiculos;
    property QuantidadeSaques: Integer read FQuantidadeSaques write FQuantidadeSaques;
    property QuantidadeTransferencias: Integer read FQuantidadeTransferencias write FQuantidadeTransferencias;
    property ValorSaques: Double read FValorSaques write FValorSaques;
    property ValorTransferencias: Double read FValorTransferencias write FValorTransferencias;
    property CodigoTipoCarga: tpTipoCarga read FCodigoTipoCarga write FCodigoTipoCarga;
    property CepOrigem: string read FCepOrigem write FCepOrigem;
    property CepDestino: string read FCepDestino write FCepDestino;
    property DistanciaPercorrida: Integer read FDistanciaPercorrida write FDistanciaPercorrida;
  end;

  TCancelarOperacao = class(TObjectBase)
  private
    FCodigoIdentificacaoOperacao: string;
    FIdOperacaoIntegradora: string;
    FIdOperacaoCliente: string;
    FMotivo: string;
  public
    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property IdOperacaoIntegradora: string read FIdOperacaoIntegradora write FIdOperacaoIntegradora;
    property IdOperacaoCliente: string read FIdOperacaoCliente write FIdOperacaoCliente;
    property Motivo: string read FMotivo write FMotivo;
  end;

  TAdicionarViagem = class(TObject)
  private
    FCodigoIdentificacaoOperacao: string;
    FViagens: TViagemCollection;
    FPagamentos: TPagamentoCollection;
    FNaoAdicionarParcialmente: Boolean;

    procedure SetViagens(const Value: TViagemCollection);
    procedure SetPagamentos(const Value: TPagamentoCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property Viagens: TViagemCollection read FViagens write SetViagens;
    property Pagamentos: TPagamentoCollection read FPagamentos write SetPagamentos;
    property NaoAdicionarParcialmente: Boolean read FNaoAdicionarParcialmente write FNaoAdicionarParcialmente;
  end;

  TAdicionarPagamento = class(TObjectBase)
  private
    FCodigoIdentificacaoOperacao: string;
    FIdOperacaoIntegradora: string;
    FIdOperacaoCliente: string;
    FPagamentos: TPagamentoCollection;

    procedure SetPagamentos(const Value: TPagamentoCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property IdOperacaoIntegradora: string read FIdOperacaoIntegradora write FIdOperacaoIntegradora;
    property IdOperacaoCliente: string read FIdOperacaoCliente write FIdOperacaoCliente;
    property Pagamentos: TPagamentoCollection read FPagamentos write SetPagamentos;
  end;

  TAlterarDataLiberacaoPagamento = class(TObject)
  private
    FIdPagamentoCliente: string;
    FMotivo: string;
    FCodigoIdentificacaoOperacao: string;
    FDataDeLiberacao: TDateTime;
  public
    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property IdPagamentoCliente: string read FIdPagamentoCliente write FIdPagamentoCliente;
    property DataDeLiberacao: TDateTime read FDataDeLiberacao write FDataDeLiberacao;
    property Motivo: string read FMotivo write FMotivo;
  end;

  TCancelarPagamento = class(TObject)
  private
    FCodigoIdentificacaoOperacao: string;
    FIdPagamentoCliente: string;
    FMotivo: string;
  public
    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property IdPagamentoCliente: string read FIdPagamentoCliente write FIdPagamentoCliente;
    property Motivo: string read FMotivo write FMotivo;
  end;

  TEncerrarOperacao = class(TObjectBase)
  private
    FCodigoIdentificacaoOperacao: string;
    FIdOperacaoIntegradora: string;
    FIdOperacaoCliente: string;
    FPesoCarga: double;
    FViagens: TViagemCollection;
    FPagamentos: TPagamentoCollection;
    FImpostos: TImpostos;
    FQuantidadeSaques: Integer;
    FQuantidadeTransferencias: Integer;
    FValorSaques: Double;
    FValorTransferencias: Double;
    FFrete: TFrete;

    procedure SetViagens(const Value: TViagemCollection);
    procedure SetPagamentos(const Value: TPagamentoCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property IdOperacaoIntegradora: string read FIdOperacaoIntegradora write FIdOperacaoIntegradora;
    property IdOperacaoCliente: string read FIdOperacaoCliente write FIdOperacaoCliente;
    property PesoCarga: double read FPesoCarga write FPesoCarga;
    property Viagens: TViagemCollection read FViagens write SetViagens;
    property Pagamentos: TPagamentoCollection read FPagamentos write SetPagamentos;
    property Impostos: TImpostos read FImpostos write FImpostos;
    property QuantidadeSaques: Integer read FQuantidadeSaques write FQuantidadeSaques;
    property QuantidadeTransferencias: Integer read FQuantidadeTransferencias write FQuantidadeTransferencias;
    property ValorSaques: Double read FValorSaques write FValorSaques;
    property ValorTransferencias: Double read FValorTransferencias write FValorTransferencias;
    property Frete: TFrete read FFrete write FFrete;
  end;

  TGravarVeiculo = class(TObject)
  private
    FPlaca: string;
    FRenavam: string;
    FChassi: string;
    FRNTRC: string;
    FNumeroDeEixos: Integer;
    FCodigoMunicipio: Integer;
    FMarca: string;
    FModelo: string;
    FAnoFabricacao: Integer;
    FAnoModelo: Integer;
    FCor: string;
    FTara: Integer;
    FCapacidadeKg: Integer;
    FCapacidadeM3: Integer;
    FTipoRodado: TpTipoRodado;
    FTipoCarroceria: TpTipoCarroceria;
  public
    property Placa: string read FPlaca write FPlaca;
    property Renavam: string read FRenavam write FRenavam;
    property Chassi: string read FChassi write FChassi;
    property RNTRC: string read FRNTRC write FRNTRC;
    property NumeroDeEixos: Integer read FNumeroDeEixos write FNumeroDeEixos;
    property CodigoMunicipio: Integer read FCodigoMunicipio write FCodigoMunicipio;
    property Marca: string read FMarca write FMarca;
    property Modelo: string read FModelo write FModelo;
    property AnoFabricacao: Integer read FAnoFabricacao write FAnoFabricacao;
    property AnoModelo: Integer read FAnoModelo write FAnoModelo;
    property Cor: string read FCor write FCor;
    property Tara: Integer read FTara write FTara;
    property CapacidadeKg: Integer read FCapacidadeKg write FCapacidadeKg;
    property CapacidadeM3: Integer read FCapacidadeM3 write FCapacidadeM3;
    property TipoRodado: TpTipoRodado read FTipoRodado write FTipoRodado;
    property TipoCarroceria: TpTipoCarroceria read FTipoCarroceria write FTipoCarroceria;
  end;

  TGravarMotorista = class(TObject)
  private
    FCPF: string;
    FNome: string;
    FCNH: string;
    FDataNascimento: TDateTime;
    FNomeDeSolteiraDaMae: string;
    FEndereco: TEndereco;
    FTelefones: TTelefones;

    procedure setCPF(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    property CPF: string read FCPF write setCPF;
    property Nome: string read FNome write FNome;
    property CNH: string read FCNH write FCNH;
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property NomeDeSolteiraDaMae: string read FNomeDeSolteiraDaMae write FNomeDeSolteiraDaMae;
    property Endereco: TEndereco read FEndereco write FEndereco;
    property Telefones: TTelefones read FTelefones write FTelefones;
  end;

  TGravarProprietario = class(TObject)
  private
    FCNPJ: string;
    FTipoPessoa: tpTipoPessoa;
    FRazaoSocial: string;
    FRNTRC: string;
    FEndereco: TEndereco;
    FTelefones: TTelefones;
    // Os campos abaixos são obtidos pelo retorno do envio.
    FTipo: TpTipoProprietario;
    FTACouEquiparado: Boolean;
    FDataValidadeRNTRC: TDateTime;
    FRNTRCAtivo: Boolean;

    procedure setCNPJ(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    property CNPJ: string read FCNPJ write setCNPJ;
    property TipoPessoa: tpTipoPessoa read FTipoPessoa write FTipoPessoa;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property RNTRC: string read FRNTRC write FRNTRC;
    property Endereco: TEndereco read FEndereco write FEndereco;
    property Telefones: TTelefones read FTelefones write FTelefones;
    // Os campos abaixos são obtidos pelo retorno do envio.
    property Tipo: TpTipoProprietario read FTipo write FTipo;
    property TACouEquiparado: Boolean read FTACouEquiparado write FTACouEquiparado;
    property DataValidadeRNTRC: TDateTime read FDataValidadeRNTRC write FDataValidadeRNTRC;
    property RNTRCAtivo: Boolean read FRNTRCAtivo write FRNTRCAtivo;
  end;

  TObterCodigoOperacaoTransporte = class(TObjectBase)
  private
    FIdOperacaoIntegradora: string;
    FIdOperacaoCliente: string;
    FCodigoIdentificacaoOperacao: string;
    FPedagioObterPraca: Boolean;
    FPedagioObterRota: Boolean;
    FObterFavorecido: Boolean;
    FObterDocumento: Boolean;
    FObterValores: Boolean;
    FObterVeiculo: Boolean;
    FObterQuitacao: Boolean;
    FObterUf: Boolean;
    FObterPostos: Boolean;
  public
    property IdOperacaoIntegradora: string read FIdOperacaoIntegradora write FIdOperacaoIntegradora;
    property IdOperacaoCliente: string read FIdOperacaoCliente write FIdOperacaoCliente;
    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property PedagioObterPraca: Boolean read FPedagioObterPraca write FPedagioObterPraca;
    property PedagioObterRota: Boolean read FPedagioObterRota write FPedagioObterRota;
    property ObterFavorecido: Boolean read FObterFavorecido write FObterFavorecido;
    property ObterDocumento: Boolean read FObterDocumento write FObterDocumento;
    property ObterValores: Boolean read FObterValores write FObterValores;
    property ObterVeiculo: Boolean read FObterVeiculo write FObterVeiculo;
    property ObterQuitacao: Boolean read FObterQuitacao write FObterQuitacao;
    property ObterUf: Boolean read FObterUf write FObterUf;
    property ObterPostos: Boolean read FObterPostos write FObterPostos;
  end;

  TRegistrarQuantidadeDaMercadoriaNoDesembarque = class(TObject)
  private
    FCodigoIdentificacaoOperacao: string;
    FNotasFiscais: TNotaFiscalCollection;

    procedure SetNotasFiscais(const Value: TNotaFiscalCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property NotasFiscais: TNotaFiscalCollection read FNotasFiscais write SetNotasFiscais;
  end;

  TRegistrarPagamentoQuitacao = class(TObject)
  private
    FTokenCompra: string;
    FNotasFiscais: TNotaFiscalCollection;
    FCodigoIdentificacaoOperacao: string;

    procedure SetNotasFiscais(const Value: TNotaFiscalCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;
    property TokenCompra: string read FTokenCompra write FTokenCompra;
    property NotasFiscais: TNotaFiscalCollection read FNotasFiscais write SetNotasFiscais;
  end;

  TCIOT = class(TObject)
  private
    FIntegradora: TIntegradora;

    FGravarProprietario: TGravarProprietario;
    FGravarVeiculo: TGravarVeiculo;
    FGravarMotorista: TGravarMotorista;

    FAdicionarOperacao: TAdicionarOperacao;
    FObterOperacaoTransportePDF: TObterOperacaoTransportePDF;
    FRetificarOperacao: TRetificarOperacao;
    FCancelarOperacao: TCancelarOperacao;
    FAdicionarViagem: TAdicionarViagem;
    FAdicionarPagamento: TAdicionarPagamento;
    FCancelarPagamento: TCancelarPagamento;
    FEncerrarOperacao: TEncerrarOperacao;
    FObterCodigoOperacaoTransporte: TObterCodigoOperacaoTransporte;
    FAlterarDataLiberacaoPagamento: TAlterarDataLiberacaoPagamento;
    FRegistrarQuantidadeDaMercadoriaNoDesembarque: TRegistrarQuantidadeDaMercadoriaNoDesembarque;
    FRegistrarPagamentoQuitacao: TRegistrarPagamentoQuitacao;

    //Pamcard
    FIncluirCartaoPortador: TIncluirCartaoPortador;
    FIncluirRota: TIncluirRota;
    FRoterizar: TRoterizar;
    FPagamentoPedagio: TPagamentoPedagio;
  public
    constructor Create;
    destructor Destroy; override;

    property Integradora: TIntegradora read FIntegradora write FIntegradora;

    property GravarProprietario: TGravarProprietario read FGravarProprietario write FGravarProprietario;
    property GravarVeiculo: TGravarVeiculo read FGravarVeiculo write FGravarVeiculo;
    property GravarMotorista: TGravarMotorista read FGravarMotorista write FGravarMotorista;

    property AdicionarOperacao: TAdicionarOperacao read FAdicionarOperacao write FAdicionarOperacao;
    property ObterOperacaoTransportePDF: TObterOperacaoTransportePDF read FObterOperacaoTransportePDF write FObterOperacaoTransportePDF;
    property RetificarOperacao: TRetificarOperacao read FRetificarOperacao write FRetificarOperacao;
    property CancelarOperacao: TCancelarOperacao read FCancelarOperacao write FCancelarOperacao;
    property AdicionarViagem: TAdicionarViagem read FAdicionarViagem write FAdicionarViagem;
    property AdicionarPagamento: TAdicionarPagamento read FAdicionarPagamento write FAdicionarPagamento;
    property CancelarPagamento: TCancelarPagamento read FCancelarPagamento write FCancelarPagamento;
    property EncerrarOperacao: TEncerrarOperacao read FEncerrarOperacao write FEncerrarOperacao;
    property ObterCodigoOperacaoTransporte: TObterCodigoOperacaoTransporte read FObterCodigoOperacaoTransporte write FObterCodigoOperacaoTransporte;
    property AlterarDataLiberacaoPagamento: TAlterarDataLiberacaoPagamento read FAlterarDataLiberacaoPagamento write FAlterarDataLiberacaoPagamento;
    property RegistrarQuantidadeDaMercadoriaNoDesembarque: TRegistrarQuantidadeDaMercadoriaNoDesembarque read FRegistrarQuantidadeDaMercadoriaNoDesembarque write FRegistrarQuantidadeDaMercadoriaNoDesembarque;
    property RegistrarPagamentoQuitacao: TRegistrarPagamentoQuitacao read FRegistrarPagamentoQuitacao write FRegistrarPagamentoQuitacao;

    //Pamcard
    property IncluirCartaoPortador: TIncluirCartaoPortador read FIncluirCartaoPortador write FIncluirCartaoPortador;
    property IncluirRota: TIncluirRota read FIncluirRota write FIncluirRota;
    property Roterizar: TRoterizar read FRoterizar write FRoterizar;
    property PagamentoPedagio: TPagamentoPedagio read FPagamentoPedagio write FPagamentoPedagio;
  end;

  TConsultaTipoCargaCollectionItem = class(TObject)
  private
    FCodigo: Integer;
    FDescricao: tpTipoCarga;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: tpTipoCarga read FDescricao write FDescricao;
  end;

  TConsultaTipoCargaCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TConsultaTipoCargaCollectionItem;
    procedure SetItem(Index: Integer; Value: TConsultaTipoCargaCollectionItem);
  public
    function Add: TConsultaTipoCargaCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TConsultaTipoCargaCollectionItem;
    property Items[Index: Integer]: TConsultaTipoCargaCollectionItem read GetItem write SetItem; default;
  end;

// ************* Retorno

  TRetEnvio = class(TObject)
  private
    FMensagem: String;
    FCodigo: String;

    FVersao: Integer;
    FSucesso: String;
    FProtocoloServico: String;

    FToken: String;

    FProprietario: TGravarProprietario;
    FVeiculo: TGravarVeiculo;
    FMotorista: TGravarMotorista;

    FPDF: AnsiString;
    FPDFNomeArquivo :string;
    FCodigoIdentificacaoOperacao: string;
    FDataRetificacao: TDateTime;
    FData: TDateTime;
    FProtocolo: String;
    FQuantidadeViagens: Integer;
    FQuantidadePagamentos: Integer;
    FDocumentoViagem: TMensagemCollection;
    FDocumentoPagamento: TMensagemCollection;
    FIdPagamentoCliente: string;
    FEstadoCiot: tpEstadoCIOT;
    FTipoCarga: TConsultaTipoCargaCollection;
    FAlterarDataLiberacaoPagamento: TAlterarDataLiberacaoPagamento;
    FValorLiquido: Double;
    FValorQuebra: Double;
    FValorDiferencaDeFrete: Double;

    //Pamcard
    FCartaoNumero: String;
    FDigito: String;
    FId: String;
    FRota: TRota;
    FPedagio: TPedagio;
    FPostos: TPostoCollection;
    FUfs: TUfsCollection;
    FDataEncerramento: TDateTime;
    FProtocoloEncerramento: String;
    FDataCancelamento: TDateTime;
    FProtocoloCancelamento: String;
    FAvisoTransportador: String;
    FCodigoIdentificacaoOperacaoPrincipal: string;
    FIdOperacaoCliente: string;
    FDataInicioViagem: TDateTime;
    FDataFimViagem: TDateTime;
    FDistanciaPercorrida: Integer;
    FCodigoTipoCarga: tpTipoCarga;
    FCodigoNCMNaturezaCarga: integer;
    FPesoCarga: Double;
    FCargaPerfilId: Integer;
    FCargaValorUnitario: Double;
    FVeiculoCategoria: string;
    FVeiculos: TVeiculoCollection;
    FFrete: TFrete;
    FParcelas: TParcelaCollection;
    FQuitacao: TQuitacao;
    FDiferencaFreteCredito: Boolean;
    FDiferencaFreteDebito: Boolean;
    FDiferencaFreteTarifaMotorista: Double;

    procedure SetDocumentoViagem(const Value: TMensagemCollection);
    procedure SetDocumentoPagamento(const Value: TMensagemCollection);
    procedure SetTipoCarga(const Value: TConsultaTipoCargaCollection);
    procedure SetPostos(const Value: TPostoCollection);
    procedure SetUfs(const Value: TUfsCollection);
    procedure SetVeiculos(const Value: TVeiculoCollection);
    procedure SetParcelas(const Value: TParcelaCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property Mensagem: String read FMensagem write FMensagem;
    property Codigo: String read FCodigo write FCodigo;

    property Versao: Integer read FVersao write FVersao;
    property Sucesso: String read FSucesso write FSucesso;
    property ProtocoloServico: String read FProtocoloServico write FProtocoloServico;

    property Token: String read FToken write FToken;

    property Proprietario: TGravarProprietario read FProprietario write FProprietario;
    property Veiculo: TGravarVeiculo read FVeiculo write FVeiculo;
    property Motorista: TGravarMotorista read FMotorista write FMotorista;

    property PDF: AnsiString read FPDF write FPDF;
    property PDFNomeArquivo : String read FPDFNomeArquivo write FPDFNomeArquivo;
    property CodigoIdentificacaoOperacao: string read FCodigoIdentificacaoOperacao write FCodigoIdentificacaoOperacao;

    property DataRetificacao: TDateTime read FDataRetificacao write FDataRetificacao;
    property Data: TDateTime read FData write FData;
    property Protocolo: String read FProtocolo write FProtocolo;
    property QuantidadeViagens: Integer read FQuantidadeViagens write FQuantidadeViagens;
    property QuantidadePagamentos: Integer read FQuantidadePagamentos write FQuantidadePagamentos;
    property DocumentoViagem: TMensagemCollection read FDocumentoViagem write SetDocumentoViagem;
    property DocumentoPagamento: TMensagemCollection read FDocumentoPagamento write SetDocumentoPagamento;
    property IdPagamentoCliente: string read FIdPagamentoCliente write FIdPagamentoCliente;
    property EstadoCiot: tpEstadoCIOT read FEstadoCiot write FEstadoCiot;
    property TipoCarga: TConsultaTipoCargaCollection read FTipoCarga write SetTipoCarga;
    property AlterarDataLiberacaoPagamento: TAlterarDataLiberacaoPagamento read FAlterarDataLiberacaoPagamento write FAlterarDataLiberacaoPagamento;

    property ValorLiquido: Double read FValorLiquido write FValorLiquido;
    property ValorQuebra: Double read FValorQuebra write FValorQuebra;
    property ValorDiferencaDeFrete: Double read FValorDiferencaDeFrete write FValorDiferencaDeFrete;

    //Pamcard
    property CartaoNumero: String read FCartaoNumero write FCartaoNumero;
    property Digito: String read FDigito write FDigito;
    property Id: String read FId write FId;
    property Rota: TRota read FRota write FRota;
    property Pedagio: TPedagio read FPedagio write FPedagio;
    property Postos: TPostoCollection read FPostos write SetPostos;
    property Ufs: TUfsCollection read FUfs write SetUfs;
    property DataEncerramento: TDateTime read FDataEncerramento write FDataEncerramento;
    property ProtocoloEncerramento: String read FProtocoloEncerramento write FProtocoloEncerramento;
    property DataCancelamento: TDateTime read FDataCancelamento write FDataCancelamento;
    property ProtocoloCancelamento: String read FProtocoloCancelamento write FProtocoloCancelamento;
    property AvisoTransportador: String read FAvisoTransportador write FAvisoTransportador;
    property CodigoIdentificacaoOperacaoPrincipal: string read FCodigoIdentificacaoOperacaoPrincipal write FCodigoIdentificacaoOperacaoPrincipal;
    property IdOperacaoCliente: string read FIdOperacaoCliente write FIdOperacaoCliente;
    property DataInicioViagem: TDateTime read FDataInicioViagem write FDataInicioViagem;
    property DataFimViagem: TDateTime read FDataFimViagem write FDataFimViagem;
    property DistanciaPercorrida: Integer read FDistanciaPercorrida write FDistanciaPercorrida;
    property CodigoTipoCarga: tpTipoCarga read FCodigoTipoCarga write FCodigoTipoCarga;
    property CodigoNCMNaturezaCarga: Integer read FCodigoNCMNaturezaCarga write FCodigoNCMNaturezaCarga;
    property PesoCarga: Double read FPesoCarga write FPesoCarga;
    property CargaPerfilId: Integer read FCargaPerfilId write FCargaPerfilId;
    property CargaValorUnitario: Double read FCargaValorUnitario write FCargaValorUnitario;
    property VeiculoCategoria: string read FVeiculoCategoria write FVeiculoCategoria;
    property Veiculos: TVeiculoCollection read FVeiculos write SetVeiculos;
    property Frete: TFrete read FFrete write FFrete;
    property Parcelas: TParcelaCollection read FParcelas write SetParcelas;
    property Quitacao: TQuitacao read FQuitacao write FQuitacao;
    property DiferencaFreteCredito: Boolean read FDiferencaFreteCredito write FDiferencaFreteCredito;
    property DiferencaFreteDebito: Boolean read FDiferencaFreteDebito write FDiferencaFreteDebito;
    property DiferencaFreteTarifaMotorista: Double read FDiferencaFreteTarifaMotorista write FDiferencaFreteTarifaMotorista;
  end;

implementation

uses
  ACBrUtil.Strings;

{ TCIOT }

constructor TCIOT.Create;
begin
  inherited Create;

  FIntegradora := TIntegradora.Create;

  FGravarProprietario := TGravarProprietario.Create;
  FGravarVeiculo      := TGravarVeiculo.Create;
  FGravarMotorista    := TGravarMotorista.Create;

  FAdicionarOperacao             := TAdicionarOperacao.Create;
  FObterCodigoOperacaoTransporte := TObterCodigoOperacaoTransporte.Create;
  FObterOperacaoTransportePDF    := TObterOperacaoTransportePDF.Create;
  FRetificarOperacao             := TRetificarOperacao.Create;
  FCancelarOperacao              := TCancelarOperacao.Create;
  FAdicionarViagem               := TAdicionarViagem.Create;
  FAdicionarPagamento            := TAdicionarPagamento.Create;
  FCancelarPagamento             := TCancelarPagamento.Create;
  FEncerrarOperacao              := TEncerrarOperacao.Create;
  FAlterarDataLiberacaoPagamento := TAlterarDataLiberacaoPagamento.Create;
  FRegistrarQuantidadeDaMercadoriaNoDesembarque := TRegistrarQuantidadeDaMercadoriaNoDesembarque.Create;
  FRegistrarPagamentoQuitacao := TRegistrarPagamentoQuitacao.Create;

  //Pamcard
  FIncluirCartaoPortador := TIncluirCartaoPortador.Create;
  FIncluirRota := TIncluirRota.Create;
  FRoterizar := TRoterizar.Create;
  FPagamentoPedagio := TPagamentoPedagio.Create;
end;

destructor TCIOT.Destroy;
begin
  FIntegradora.Free;

  FGravarProprietario.Free;
  FGravarVeiculo.Free;
  FGravarMotorista.Free;

  FAdicionarOperacao.Free;
  FObterCodigoOperacaoTransporte.Free;
  FObterOperacaoTransportePDF.Free;
  FRetificarOperacao.Free;
  FCancelarOperacao.Free;
  FAdicionarViagem.Free;
  FAdicionarPagamento.Free;
  FCancelarPagamento.Free;
  FEncerrarOperacao.Free;
  FAlterarDataLiberacaoPagamento.Free;
  FRegistrarQuantidadeDaMercadoriaNoDesembarque.Free;
  FRegistrarPagamentoQuitacao.Free;

  //Pamcard
  FIncluirCartaoPortador.Free;
  FIncluirRota.Free;
  FRoterizar.Free;
  FPagamentoPedagio.Free;

  inherited Destroy;
end;

{ TAdicionarOperacao }

constructor TAdicionarOperacao.Create;
begin
  inherited Create;

  FViagens := TViagemCollection.Create;
  FImpostos := TImpostos.Create;
  FPagamentos := TPagamentoCollection.Create;
  FContratado := TPessoa.Create;
  FMotorista := TMotorista.Create;
  FDestinatario := TPessoa.Create;
  FContratante := TPessoa.Create;
  FSubcontratante := TPessoa.Create;
  FConsignatario := TPessoa.Create;
  FTomadorServico := TPessoa.Create;
  FRemetente := TPessoa.Create;
  FProprietarioCarga := TPessoa.Create;
  FVeiculos := TVeiculoCollection.Create;
  FObservacoesAoCredenciado := TMensagemCollection.Create;
  FObservacoesAoTransportador := TMensagemCollection.Create;
  FRota := TRota.Create;
  FPedagio := TPedagio.Create;
  FPostos := TPostoCollection.Create;
  FFrete := TFrete.Create;
  FParcelas := TParcelaCollection.Create;
  FQuitacao := TQuitacao.Create;
  FCiotEmissor := TPessoa.Create;
end;

destructor TAdicionarOperacao.Destroy;
begin
  FViagens.Free;
  FImpostos.Free;
  FPagamentos.Free;
  FContratado.Free;
  FMotorista.Free;
  FDestinatario.Free;
  FContratante.Free;
  FSubcontratante.Free;
  FConsignatario.Free;
  FTomadorServico.Free;
  FRemetente.Free;
  FProprietarioCarga.Free;
  FVeiculos.Free;
  FObservacoesAoCredenciado.Free;
  FObservacoesAoTransportador.Free;
  FRota.Free;
  FPedagio.Free;
  FPostos.Free;
  FFrete.Free;
  FParcelas.Free;
  FQuitacao.Free;
  FCiotEmissor.Free;

  inherited Destroy;
end;

procedure TAdicionarOperacao.SetObservacoesAoCredenciado(
  const Value: TMensagemCollection);
begin
  FObservacoesAoCredenciado := Value;
end;

procedure TAdicionarOperacao.SetObservacoesAoTransportador(
  const Value: TMensagemCollection);
begin
  FObservacoesAoTransportador := Value;
end;

procedure TAdicionarOperacao.SetPagamentos(const Value: TPagamentoCollection);
begin
  FPagamentos := Value;
end;

procedure TAdicionarOperacao.SetParcelas(const Value: TParcelaCollection);
begin
  FParcelas := Value;
end;

procedure TAdicionarOperacao.SetPostos(const Value: TPostoCollection);
begin
  FPostos := Value;
end;

procedure TAdicionarOperacao.SetVeiculos(const Value: TVeiculoCollection);
begin
  FVeiculos := Value;
end;

procedure TAdicionarOperacao.SetViagens(const Value: TViagemCollection);
begin
  FViagens := Value;
end;

{ TTelefones }

constructor TTelefones.Create;
begin
  inherited Create;

  FCelular := TTelefone.Create;
  FFixo := TTelefone.Create;
  FFax := TTelefone.Create;
end;

destructor TTelefones.Destroy;
begin
  FCelular.Free;
  FFixo.Free;
  FFax.Free;

  inherited Destroy;
end;

{ TEndereco }

procedure TEndereco.SetCEP(const Value: string);
begin
  FCEP := {SomenteNumeros(}Value{)};
end;

{ TPagamentoCollectionItem }

constructor TPagamentoCollectionItem.Create;
begin
  inherited Create;

  FInformacoesBancarias := TInformacoesBancarias.Create;
end;

destructor TPagamentoCollectionItem.Destroy;
begin
  FInformacoesBancarias.Free;

  inherited Destroy;
end;

{ TPagamentoCollection }

function TPagamentoCollection.Add: TPagamentoCollectionItem;
begin
  Result := Self.New;
end;

function TPagamentoCollection.GetItem(Index: Integer): TPagamentoCollectionItem;
begin
  Result := TPagamentoCollectionItem(inherited Items[Index]);
end;

function TPagamentoCollection.New: TPagamentoCollectionItem;
begin
  Result := TPagamentoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TPagamentoCollection.SetItem(Index: Integer;
  Value: TPagamentoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TVeiculoCollectionItem }

procedure TVeiculoCollectionItem.SetPlaca(const Value: String);
begin
  FPlaca := RemoveStrings(Value, [' ', '-', '/', '\', '*', '_']);
end;

{ TVeiculoCollection }

function TVeiculoCollection.Add: TVeiculoCollectionItem;
begin
  Result := Self.New;
end;

function TVeiculoCollection.GetItem(Index: Integer): TVeiculoCollectionItem;
begin
  Result := TVeiculoCollectionItem(inherited Items[Index]);
end;

function TVeiculoCollection.New: TVeiculoCollectionItem;
begin
  Result := TVeiculoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TVeiculoCollection.SetItem(Index: Integer;
  Value: TVeiculoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TViagemCollectionItem }

constructor TViagemCollectionItem.Create;
begin
  inherited Create;

  FTipoPagamento := TransferenciaBancaria;

  FValores              := TValoresOT.Create;
  FInformacoesBancarias := TInformacoesBancarias.Create;
  FNotasFiscais         := TNotaFiscalCollection.Create;
end;

destructor TViagemCollectionItem.Destroy;
begin
  FValores.Free;
  FInformacoesBancarias.Free;
  FNotasFiscais.Free;

  inherited Destroy;
end;

procedure TViagemCollectionItem.SetNotasFiscais(
  const Value: TNotaFiscalCollection);
begin
  FNotasFiscais := Value;
end;

{ TViagemCollection }

function TViagemCollection.Add: TViagemCollectionItem;
begin
  Result := Self.New;
end;

function TViagemCollection.GetItem(Index: Integer): TViagemCollectionItem;
begin
  Result := TViagemCollectionItem(inherited Items[Index]);
end;

function TViagemCollection.New: TViagemCollectionItem;
begin
  Result := TViagemCollectionItem.Create;
  Self.Add(Result);
end;

procedure TViagemCollection.SetItem(Index: Integer;
  Value: TViagemCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TNotaFiscalCollectionItem }

constructor TNotaFiscalCollectionItem.Create;
begin
  inherited Create;

  FToleranciaDePerdaDeMercadoria := TToleranciaDePerdaDeMercadoria.Create;
  FDiferencaDeFrete := TDiferencaDeFrete.Create;
  FRemetente := TPessoa.Create;
  FDestinatario := TPessoa.Create;
  FConsignatario := TPessoa.Create;
end;

destructor TNotaFiscalCollectionItem.Destroy;
begin
  FToleranciaDePerdaDeMercadoria.Free;
  FDiferencaDeFrete.Free;
  FRemetente.Free;
  FDestinatario.Free;
  FConsignatario.Free;

  inherited Destroy;
end;

{ TNotaFiscalCollection }

function TNotaFiscalCollection.Add: TNotaFiscalCollectionItem;
begin
  Result := Self.New;
end;

function TNotaFiscalCollection.GetItem(
  Index: Integer): TNotaFiscalCollectionItem;
begin
  Result := TNotaFiscalCollectionItem(inherited Items[Index]);
end;

function TNotaFiscalCollection.New: TNotaFiscalCollectionItem;
begin
  Result := TNotaFiscalCollectionItem.Create;
  Self.Add(Result);
end;

procedure TNotaFiscalCollection.SetItem(Index: Integer;
  Value: TNotaFiscalCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TDiferencaDeFrete }

constructor TDiferencaDeFrete.Create;
begin
  inherited Create;

  Tolerancia := TDiferencaFreteMargem.Create;
  MargemGanho := TDiferencaFreteMargem.Create;
  MargemPerda := TDiferencaFreteMargem.Create;
end;

destructor TDiferencaDeFrete.Destroy;
begin
  Tolerancia.Free;
  MargemGanho.Free;
  MargemPerda.Free;

  inherited Destroy;
end;

{ TRetificarOperacao }

constructor TRetificarOperacao.Create;
begin
  inherited Create;

  FVeiculos := TVeiculoCollection.Create;
end;

destructor TRetificarOperacao.Destroy;
begin
  FVeiculos.Free;

  inherited Destroy;
end;

procedure TRetificarOperacao.setVeiculos(
  const Value: TVeiculoCollection);
begin
  FVeiculos := Value;
end;

// ************* Retorno

{ TEncerrarOperacao }

constructor TEncerrarOperacao.Create;
begin
  inherited Create;

  FViagens := TViagemCollection.Create;
  FPagamentos := TPagamentoCollection.Create;
  FImpostos := TImpostos.Create;
  Frete := TFrete.Create;
end;

destructor TEncerrarOperacao.Destroy;
begin
  FViagens.Free;
  FPagamentos.Free;
  FImpostos.Free;
  Frete.Free;

  inherited Destroy;
end;

procedure TEncerrarOperacao.SetPagamentos(const Value: TPagamentoCollection);
begin
  FPagamentos := Value;
end;

procedure TEncerrarOperacao.SetViagens(const Value: TViagemCollection);
begin
  FViagens := Value;
end;

{ TAdicionarViagem }

constructor TAdicionarViagem.Create;
begin
  inherited Create;

  FViagens := TViagemCollection.Create;
  FPagamentos := TPagamentoCollection.Create;
end;

destructor TAdicionarViagem.Destroy;
begin
  FViagens.Free;
  FPagamentos.Free;

  inherited Destroy;
end;

procedure TAdicionarViagem.SetPagamentos(const Value: TPagamentoCollection);
begin
  FPagamentos := Value;
end;

procedure TAdicionarViagem.SetViagens(const Value: TViagemCollection);
begin
  FViagens := Value;
end;

{ TMensagemCollection }

function TMensagemCollection.Add: TMensagemCollectionItem;
begin
  Result := Self.New;
end;

function TMensagemCollection.GetItem(Index: Integer): TMensagemCollectionItem;
begin
  Result := TMensagemCollectionItem(inherited Items[Index]);
end;

function TMensagemCollection.New: TMensagemCollectionItem;
begin
  Result := TMensagemCollectionItem.Create;
  Self.Add(Result);
end;

procedure TMensagemCollection.SetItem(Index: Integer;
  Value: TMensagemCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRetEnvio }

constructor TRetEnvio.Create;
begin
  inherited Create;

  FProprietario       := TGravarProprietario.Create;
  FVeiculo            := TGravarVeiculo.Create;
  FMotorista          := TGravarMotorista.Create;
  FDocumentoViagem    := TMensagemCollection.Create;
  FDocumentoPagamento := TMensagemCollection.Create;
  FTipoCarga          := TConsultaTipoCargaCollection.Create;
  FAlterarDataLiberacaoPagamento := TAlterarDataLiberacaoPagamento.Create;

  FRota := TRota.Create;
  FPedagio := TPedagio.Create;
  FPostos := TPostoCollection.Create;
  FUfs := TUfsCollection.Create;
  FVeiculos := TVeiculoCollection.Create;
  FFrete := TFrete.Create;
  FParcelas := TParcelaCollection.Create;
  FQuitacao := TQuitacao.Create;
end;

destructor TRetEnvio.Destroy;
begin
  FProprietario.Free;
  FVeiculo.Free;
  FMotorista.Free;
  FDocumentoViagem.Free;
  FDocumentoPagamento.Free;
  FTipoCarga.Free;
  FAlterarDataLiberacaoPagamento.Free;

  FRota.Free;
  FPedagio.Free;
  FPostos.Free;
  FUfs.Free;
  FVeiculos.Free;
  FFrete.Free;
  FParcelas.Free;
  FQuitacao.Free;

  inherited Destroy;
end;

procedure TRetEnvio.SetDocumentoPagamento(const Value: TMensagemCollection);
begin
  FDocumentoPagamento := Value;
end;

procedure TRetEnvio.SetDocumentoViagem(const Value: TMensagemCollection);
begin
  FDocumentoViagem := Value;
end;

procedure TRetEnvio.SetParcelas(const Value: TParcelaCollection);
begin
  FParcelas := Value;
end;

procedure TRetEnvio.SetPostos(const Value: TPostoCollection);
begin
  FPostos := Value;
end;

procedure TRetEnvio.SetTipoCarga(const Value: TConsultaTipoCargaCollection);
begin
  FTipoCarga := Value;
end;

procedure TRetEnvio.SetUfs(const Value: TUfsCollection);
begin
  FUfs := Value;
end;

procedure TRetEnvio.SetVeiculos(const Value: TVeiculoCollection);
begin
  FVeiculos := Value;
end;

{ TAdicionarPagamento }

constructor TAdicionarPagamento.Create;
begin
  inherited Create;

  FPagamentos := TPagamentoCollection.Create;
end;

destructor TAdicionarPagamento.Destroy;
begin
  FPagamentos.Free;

  inherited Destroy;
end;

procedure TAdicionarPagamento.SetPagamentos(const Value: TPagamentoCollection);
begin
  FPagamentos := Value;
end;

{ TGravarMotorista }

constructor TGravarMotorista.Create;
begin
  inherited Create;

  FTelefones := TTelefones.Create;
  FEndereco  := TEndereco.Create;
end;

destructor TGravarMotorista.Destroy;
begin
  FTelefones.Free;
  FEndereco.Free;

  inherited Destroy;
end;

procedure TGravarMotorista.setCPF(const Value: string);
begin
  FCPF := {SomenteNumeros(}Value{)};
end;

{ TGravarProprietario }

constructor TGravarProprietario.Create;
begin
  inherited Create;

  FTelefones := TTelefones.Create;
  FEndereco  := TEndereco.Create;
end;

destructor TGravarProprietario.Destroy;
begin
  FTelefones.Free;
  FEndereco.Free;

  inherited Destroy;
end;

procedure TGravarProprietario.setCNPJ(const Value: string);
begin
  FCNPJ := {SomenteNumeros(}Value{)};
end;

{ TConsultaTipoCarga }

function TConsultaTipoCargaCollection.Add: TConsultaTipoCargaCollectionItem;
begin
  Result := Self.New;
end;

function TConsultaTipoCargaCollection.GetItem(Index: Integer): TConsultaTipoCargaCollectionItem;
begin
  Result := TConsultaTipoCargaCollectionItem(inherited Items[Index]);
end;

function TConsultaTipoCargaCollection.New: TConsultaTipoCargaCollectionItem;
begin
  Result := TConsultaTipoCargaCollectionItem.Create;
  Self.Add(Result);
end;

procedure TConsultaTipoCargaCollection.SetItem(Index: Integer;
  Value: TConsultaTipoCargaCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRegistrarQuantidadeDaMercadoriaNoDesembarque }

constructor TRegistrarQuantidadeDaMercadoriaNoDesembarque.Create;
begin
  inherited Create;

  FNotasFiscais := TNotaFiscalCollection.Create;
end;

destructor TRegistrarQuantidadeDaMercadoriaNoDesembarque.Destroy;
begin
  FNotasFiscais.Free;

  inherited Destroy;
end;

procedure TRegistrarQuantidadeDaMercadoriaNoDesembarque.SetNotasFiscais(
  const Value: TNotaFiscalCollection);
begin
  FNotasFiscais := Value;
end;

{ TRegistrarPagamentoQuitacao }

constructor TRegistrarPagamentoQuitacao.Create;
begin
  inherited Create;

  FNotasFiscais := TNotaFiscalCollection.Create;
end;

destructor TRegistrarPagamentoQuitacao.Destroy;
begin
  FNotasFiscais.Free;

  inherited Destroy;
end;

procedure TRegistrarPagamentoQuitacao.SetNotasFiscais(
  const Value: TNotaFiscalCollection);
begin
  FNotasFiscais := Value;
end;

{ TPessoa }

constructor TPessoa.Create;
begin
  inherited Create;

  FTelefones := TTelefones.Create;
  FEndereco  := TEndereco.Create;
  FInformacoesBancarias := TInformacoesBancarias.Create;
end;

destructor TPessoa.Destroy;
begin
  FTelefones.Free;
  FEndereco.Free;
  FInformacoesBancarias.Free;

  inherited Destroy;
end;

procedure TPessoa.SetCpfOuCnpj(const Value: string);
begin
  FCpfOuCnpj := {omenteNumeros(}Value{)};
end;

{ TMotorista }

constructor TMotorista.Create;
begin
  inherited Create;

  FCelular := TTelefone.Create;
end;

destructor TMotorista.Destroy;
begin
  FCelular.Free;

  inherited Destroy;
end;

{ TRotaPontosCollection }

function TRotaPontosCollection.Add: TRotaPontoCollectionItem;
begin
  Result := Self.New;
end;

function TRotaPontosCollection.GetItem(Index: Integer): TRotaPontoCollectionItem;
begin
  Result := TRotaPontoCollectionItem(inherited Items[Index]);
end;

function TRotaPontosCollection.New: TRotaPontoCollectionItem;
begin
  Result := TRotaPontoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TRotaPontosCollection.SetItem(Index: Integer; Value: TRotaPontoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRota }

constructor TRota.Create;
begin
  FPontos := TRotaPontosCollection.Create;
end;

destructor TRota.Destroy;
begin
  FPontos.Free;

  inherited Destroy;
end;

procedure TRota.SetPontos(const Value: TRotaPontosCollection);
begin
  FPontos := Value;
end;

{ TPedagioPracaCollection }

function TPedagioPracaCollection.Add: TPedagioPracaCollectionItem;
begin
  Result := Self.New;
end;

function TPedagioPracaCollection.GetItem(Index: Integer): TPedagioPracaCollectionItem;
begin
  Result := TPedagioPracaCollectionItem(inherited Items[Index]);
end;

function TPedagioPracaCollection.New: TPedagioPracaCollectionItem;
begin
  Result := TPedagioPracaCollectionItem.Create;
  Self.Add(Result);
end;

procedure TPedagioPracaCollection.SetItem(Index: Integer; Value: TPedagioPracaCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TPedagio }

constructor TPedagio.Create;
begin
  FPracas := TPedagioPracaCollection.Create;
end;

destructor TPedagio.Destroy;
begin
  FPracas.Free;

  inherited Destroy;
end;

procedure TPedagio.SetPracas(const Value: TPedagioPracaCollection);
begin
  FPracas := Value;
end;

{ TFreteItemCollectionItem }

constructor TFreteItemCollectionItem.Create;
begin
  inherited Create;

  FTarifaQuantidade := 4;
end;

{ TFreteItemCollection }

function TFreteItemCollection.Add: TFreteItemCollectionItem;
begin
  Result := Self.New;
end;

function TFreteItemCollection.GetItem(Index: Integer): TFreteItemCollectionItem;
begin
  Result := TFreteItemCollectionItem(inherited Items[Index]);
end;

function TFreteItemCollection.New: TFreteItemCollectionItem;
begin
  Result := TFreteItemCollectionItem.Create;
  Self.Add(Result);
end;

procedure TFreteItemCollection.SetItem(Index: Integer; Value: TFreteItemCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TFrete }

constructor TFrete.Create;
begin
  inherited Create;

  FItens := TFreteItemCollection.Create;
end;

destructor TFrete.Destroy;
begin
  FItens.Free;

  inherited Destroy;
end;

procedure TFrete.SetItens(const Value: TFreteItemCollection);
begin
  FItens := Value;
end;

{ TParcelaCollection }

function TParcelaCollection.Add: TParcelaCollectionItem;
begin
  Result := Self.New;
end;

function TParcelaCollection.GetItem(Index: Integer): TParcelaCollectionItem;
begin
  Result := TParcelaCollectionItem(inherited Items[Index]);
end;

function TParcelaCollection.New: TParcelaCollectionItem;
begin
  Result := TParcelaCollectionItem.Create;
  Self.Add(Result);
end;

procedure TParcelaCollection.SetItem(Index: Integer; Value: TParcelaCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TQuitacao }

constructor TQuitacao.Create;
begin
  inherited Create;

  FDescontoFaixas := TDescontoFaixaCollection.Create;
end;

destructor TQuitacao.Destroy;
begin
  FDescontoFaixas.Free;

  inherited Destroy;
end;

procedure TQuitacao.SetDescontoFaixas(const Value: TDescontoFaixaCollection);
begin
  FDescontoFaixas := Value;
end;

{ TDescontoFaixaCollection }

function TDescontoFaixaCollection.Add: TDescontoFaixaCollectionItem;
begin
  Result := Self.New;
end;

function TDescontoFaixaCollection.GetItem(Index: Integer): TDescontoFaixaCollectionItem;
begin
  Result := TDescontoFaixaCollectionItem(inherited Items[Index]);
end;

function TDescontoFaixaCollection.New: TDescontoFaixaCollectionItem;
begin
  Result := TDescontoFaixaCollectionItem.Create;
  Self.Add(Result);
end;

procedure TDescontoFaixaCollection.SetItem(Index: Integer; Value: TDescontoFaixaCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TPostoCollection }

function TPostoCollection.Add: TPostoCollectionItem;
begin
  Result := Self.New;
end;

function TPostoCollection.GetItem(Index: Integer): TPostoCollectionItem;
begin
  Result := TPostoCollectionItem(inherited Items[Index]);
end;

function TPostoCollection.New: TPostoCollectionItem;
begin
  Result := TPostoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TPostoCollection.SetItem(Index: Integer; Value: TPostoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TPostoCollectionItem }

constructor TPostoCollectionItem.Create;
begin
  inherited Create;

  FEndereco := TEndereco.Create;
end;

destructor TPostoCollectionItem.Destroy;
begin
  FEndereco.Free;

  inherited Destroy;
end;

{ TUfsCollection }

function TUfsCollection.Add: TUfsCollectionItem;
begin
  Result := Self.New;
end;

function TUfsCollection.GetItem(Index: Integer): TUfsCollectionItem;
begin
  Result := TUfsCollectionItem(inherited Items[Index]);
end;

function TUfsCollection.New: TUfsCollectionItem;
begin
  Result := TUfsCollectionItem.Create;
  Self.Add(Result);
end;

procedure TUfsCollection.SetItem(Index: Integer; Value: TUfsCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TIncluirCartaoPortador }

constructor TIncluirCartaoPortador.Create;
begin
  inherited Create;

  FPortador := TPessoa.Create;
end;

destructor TIncluirCartaoPortador.Destroy;
begin
  FPortador.Free;

  inherited Destroy;
end;

{ TInformacoesBancarias }

constructor TInformacoesBancarias.Create;
begin
  inherited Create;

  FCartao := TCartao.Create;
end;

destructor TInformacoesBancarias.Destroy;
begin
  FCartao.Free;

  inherited Destroy;
end;

{ TRoterizar }

constructor TRoterizar.Create;
begin
  inherited Create;

  FRota := TRota.Create;
  FPedagio := TPedagio.Create;
end;

destructor TRoterizar.Destroy;
begin
  FRota.Free;
  FPedagio.Free;

  inherited Destroy;
end;

{ TIncluirRota }

constructor TIncluirRota.Create;
begin
  inherited Create;

  FRota := TRota.Create;
  FPedagio := TPedagio.Create;
end;

destructor TIncluirRota.Destroy;
begin
  FRota.Free;
  FPedagio.Free;

  inherited Destroy;
end;

end.

