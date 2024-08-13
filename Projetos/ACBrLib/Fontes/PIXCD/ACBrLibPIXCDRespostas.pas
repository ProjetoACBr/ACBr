{ criar uma interface de comunicação com equipamentos de automacao comercial.   }
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

unit ACBrLibPIXCDRespostas;

interface

uses
  Classes, SysUtils,
  ACBrBase, ACBrPIXCD, ACBrPIXBase,
  ACBrPIXSchemasCob, ACBrPIXSchemasCalendario, ACBrPIXSchemasDevedor, ACBrPIXSchemasLocation,
  ACBrPIXSchemasPix, ACBrPIXSchemasDevolucao, ACBrPIXSchemasPixConsultados,
  ACBrPIXSchemasParametrosConsultaCob, ACBrPIXSchemasCobsConsultadas, ACBrPIXSchemasCobsVConsultadas,
  ACBrPIXSchemasPaginacao, ACBrPIXSchemasCobV, ACBrPIXSchemasProblema,
  ACBrUtil.Base,
  ACBrLibPIXCDConsts, ACBrLibResposta, ACBrLibConfig;

type

  { TLibPIXCDProblemaRespostaViolacao }
  TLibPIXCDProblemaRespostaViolacao = class(TACBrLibRespostaBase)
    private
      fPropriedade: String;
      fRazao: String;
      fValor: String;

    public
      procedure Processar(const Violacao: TACBrPIXViolacao);

    published
      property Propriedade: String read fPropriedade;
      property Razao: String read fRazao;
      property Valor: String read fValor;
  end;

  { TLibPIXCDProblemaResposta }
  TLibPIXCDProblemaResposta = class (TACBrLibRespostaBase)
    private
      fcorrelationId: String;
      fDetail: String;
      fStatus: integer;
      fTitle: String;
      ftype_uri: String;
      fViolacoes: TACBrObjectList;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure Processar(const Problema: TACBrPIXProblema);

    published
      property correlationId: String read fcorrelationId write fcorrelationId;
      property Status: integer read fStatus write fStatus;
      property Title: String read fTitle write fTitle;
      property Detail: String read fDetail write fDetail;
      property type_uri: String read ftype_uri write ftype_uri;
      property Violacoes: TACBrObjectList read fViolacoes;
  end;

  { TLibPixCDValorVInfo }
  TLibPixCDValorVInfo = class(TACBrLibRespostaBase)
    private
      fModalidadeAbatimento: TACBrPIXValoresModalidade;
      fvalorPercAbatimento: Currency;
      fModalidadeDesconto: TACBrPIXDescontoModalidade;
      fValorPercDesconto: Currency;
      fModalidadeJuros: TACBrPIXJurosModalidade;
      fValorPercJuros: Currency;
      fModalidadeMulta: TACBrPixValoresModalidade;
      fValorPercMulta: Currency;
      foriginal: Currency;

    public
      procedure Clear;
      procedure Processar(const ValorV: TACBrPIXCobVValor);

    published
      property ModalidadeAbatimento: TACBrPIXValoresModalidade read fModalidadeAbatimento write fModalidadeAbatimento;
      property valorPercAbatimento: Currency read fValorPercAbatimento write fValorPercAbatimento;
      property ModalidadeDesconto: TACBrPIXDescontoModalidade read fModalidadeDesconto write fModalidadeDesconto;
      property ValorPercDesconto: Currency read fValorPercDesconto write fValorPercDesconto;
      property ModalidadeJuros: TACBrPIXJurosModalidade read fModalidadeJuros write fModalidadeJuros;
      property ValorPercJuros: Currency read fValorPercJuros write fValorPercJuros;
      property ModalidadeMulta: TACBrPixValoresModalidade read fModalidadeMulta write fModalidadeMulta;
      property ValorPercMulta: Currency read fValorPercMulta write fValorPercMulta;
      property original: Currency read fOriginal write fOriginal;
  end;

  { TLibPIXCDCalendarioVInfo }
  TLibPIXCDCalendarioVInfo = class(TACBrLibRespostaBase)
    private
      Fcriacao: TDateTime;
      Fcriacao_Bias: Integer;
      FdataDeVencimento: TDateTime;
      FvalidadeAposVencimento: Integer;

    public
      procedure Clear;
      procedure Processar(const CalendarioV: TACBrPIXCalendarioCobVGerada);

    published
      property criacao: TDateTime read fcriacao write fcriacao;
      property criacao_Bias: Integer read fcriacao_Bias write fCriacao_Bias;
      property dataDeVencimento: TDateTime read fDataDeVencimento write FDataDeVencimento;
      property validadeAposVencimento: Integer read FValidadeAposVencimento write FValidadeAposVencimento;
  end;

  { TLibPIXCDValorInfo }
  TLibPIXCDValorInfo = class(TACBrLibRespostaBase)
    private
      fOriginal: Currency;
      fModalidadeAlteracao: Boolean;

    public
      procedure Clear;
      procedure Processar(const Valor: TACBrPIXCobValor);

    published
      property original: Currency read fOriginal write fOriginal;
      property modalidadeAlteracao: Boolean read fmodalidadeAlteracao write fmodalidadeAlteracao;
  end;

  { TLibPIXCDLocInfo }
  TLibPIXCDLocInfo = class(TACBrLibRespostaBase)
    private
      fId: Int64;
      fTxId: String;
      fLocation: String;
      fCriacao: TDateTime;
      fCriacao_Bias: Integer;

    public
      procedure Clear;
      procedure Processar(const Loc: TACBrPIXLocationCompleta);

    published
      property id: Int64 read fId write fId;
      property txId: String read fTxId write fTxId;
      property location: String read fLocation write fLocation;
      property criacao: TDateTime read fCriacao write fCriacao;
      property criacao_Bias: Integer read fCriacao_Bias write fCriacao_Bias;
  end;

  { TLibPIXCDDevedorInfo }
  TLibPIXCDDevedorInfo = class(TACBrLibRespostaBase)
    private
      fCpf: String;
      fCnpj: String;
      fNome: String;
      fEmail: String;
      fLogradouro: String;
      fCidade: String;
      fUf: String;
      fCep: String;

    public
      procedure Clear;
      procedure Processar(const Devedor: TACBrPIXDevedor);
      procedure ProcessarDadosDevedor(const Devedor: TACBrPIXDadosDevedor);
      procedure ProcessarDadosRecebedor(const Recebedor: TACBrPIXDadosRecebedor);

    published
      property cpf: String read fCpf write fCpf;
      property cnpj: String read fCnpj write fCnpj;
      property nome: String read fNome write fNome;
      property Email: String read FEmail write FEmail;
      property Logradouro: String read FLogradouro write FLogradouro;
      property Cidade: String read FCidade write FCidade;
      property Uf: String read FUf write FUf;
      property Cep: String read FCep write FCep;
  end;

  { TLibPIXCDCalendarioInfo }
  TLibPIXCDCalendarioInfo = class(TACBrLibRespostaBase)
    private
      fCriacao: TDateTime;
      fCriacao_Bias: Integer;
      fExpiracao: Integer;

    public
      procedure Clear;
      procedure Processar(const Calendario: TACBrPIXCalendarioCobGerada);

    published
      property criacao: TDateTime read fCriacao write fCriacao;
      property criacao_Bias: Integer read fCriacao_Bias write fCriacao_Bias;
      property expiracao: Integer read fExpiracao write fExpiracao;
  end;

  { TLibPIXCDCobVResposta }
  TLibPIXCDCobVResposta = class (TACBrLibRespostaBase)
    private
      fcalendario: TLibPIXCDCalendarioVInfo;
      fdevedor: TLibPIXCDDevedorInfo;
      floc: TLibPIXCDLocInfo;
      frecebedor: TLibPIXCDDevedorInfo;
      frevisao: Integer;
      fstatus: TACBrPIXStatusCobranca;
      ftxId: String;
      fvalor: TLibPixCDValorVInfo;
      fPix: TACBrObjectList;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure ProcessarCobVGerada(const CobVGerada: TACBrPIXCobVGerada);
      procedure ProcessarCobVCompleta(const CobVCompleta: TACBrPIXCobVCompleta);

    published
      property calendario: TLibPIXCDCalendarioVInfo read fcalendario;
      property devedor: TLibPIXCDDevedorInfo read fdevedor;
      property loc: TLibPIXCDLocInfo read floc;
      property recebedor: TLibPIXCDDevedorInfo read frecebedor;
      property revisao: Integer read frevisao;
      property status: TACBrPIXStatusCobranca read fstatus;
      property txId: String read fTxId;
      property valor: TLibPixCDValorVInfo read fvalor;
  end;

  { TLibPIXCDCobResposta }
  TLibPIXCDCobResposta = class(TACBrLibRespostaBase)
    private
      fCalendario: TLibPIXCDCalendarioInfo;
      fTxId: String;
      fRevisao: Integer;
      fDevedor: TLibPIXCDDevedorInfo;
      fLoc: TLibPIXCDLocInfo;
      fStatus: TACBrPIXStatusCobranca;
      fValor: TLibPIXCDValorInfo;
      fPixCopiaeCola: String;
      fPix: TACBrObjectList;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure ProcessarCobGerada(const CobGerada: TACBrPIXCobGerada);
      procedure ProcessarCobCompleta(const CobCompleta: TACBrPIXCobCompleta);

    published
      property txId: String read fTxId write fTxId;
      property revisao: Integer read fRevisao write fRevisao;
      property status: TACBrPIXStatusCobranca read fStatus write fStatus;
      property calendario: TLibPIXCDCalendarioInfo read fCalendario write fCalendario;
      property devedor: TLibPIXCDDevedorInfo read fDevedor write fDevedor;
      property loc: TLibPIXCDLocInfo read fLoc write fLoc;
      property valor: TLibPIXCDValorInfo read fValor write fValor;
      property pixCopiaeCola: String read FPixCopiaeCola write fPixCopiaeCola;
      property Pix: TACBrObjectList read FPix write fPix;
  end;

  { TLibPIXCDPaginacao }
  TLibPIXCDPaginacao = class(TACBrLibRespostaBase)
    private
      fitensPorPagina: Integer;
      fpaginaAtual: Integer;
      fquantidadeDePaginas: Integer;
      fquantidadeTotalDeItens: Integer;

    public
      constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure Processar(const Paginacao: TACBrPIXPaginacao);

    published
      property itensPorPagina: Integer read fitensPorPagina write fitensPorPagina;
      property paginaAtual: Integer read fpaginaAtual write fpaginaAtual;
      property quantidadeDePaginas: Integer read fquantidadeDePaginas write fquantidadeDePaginas;
      property quantidadeTotalDeItens: Integer read fquantidadeTotalDeItens write fquantidadeTotalDeItens;
  end;

  { TLibPIXCDParametrosConsultaCob }
  TLibPIXCDParametrosConsultaCob = class(TACBrLibRespostaBase)
    private
      fcnpj: String;
      fcpf: String;
      flocationPresente: Boolean;
      ffim: TDateTime;
      finicio: TDateTime;
      fpaginacao: TLibPIXCDPaginacao;
      fstatus: String;

    public
      constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure Processar(const ParametrosConsultaCob: TACBrPIXParametrosConsultaCob);
    published
      property cnpj: String read fcnpj write fcnpj;
      property cpf: String read fcpf write fcpf;
      property locationPresente: Boolean read flocationPresente write flocationPresente;
      property fim: TDateTime read ffim write ffim;
      property inicio: TDateTime read finicio write finicio;
      property paginacao: TLibPIXCDPaginacao read fpaginacao write fpaginacao;
      property status: String read fstatus write fstatus;
  end;

  { TLibPIXCDCobVCompletaArray }
  TLibPIXCDCobVCompletaArray = class(TACBrLibRespostaBase)
    private
      fcobsV: TACBrObjectList;

    public
      constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure Processar(const CobVCompleta: TACBrPIXArray);

    published
      property cobsV: TACBrObjectList read fcobsV write fcobsV;
  end;

  { TLibPIXCDCobsVConsultadas }
  TLibPIXCDCobsVConsultadas = class(TACBrLibRespostaBase)
    private
      fcobsV: TLibPIXCDCobVCompletaArray;
      fparametros: TLibPIXCDParametrosConsultaCob;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure Processar(const CobsVConsultadas: TACBrPIXCobsVConsultadas);

    published
      property cobsV: TLibPIXCDCobVCompletaArray read fcobsV write fcobsV;
      property parametros: TLibPIXCDParametrosConsultaCob read fparametros write fparametros;
  end;

  { TLibPIXCDCobCompletaArray }
  TLibPIXCDCobCompletaArray = class(TACBrLibRespostaBase)
    private
      fcobs: TACBrObjectList;

    public
      constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure Processar(const CobCompleta: TACBrPIXArray);

    published
      property cobs: TACBrObjectList read fcobs write fcobs;
  end;

  { TLibPIXCDCobsConsultadas }
  TLibPIXCDCobsConsultadas = class(TACBrLibRespostaBase)
    private
      fcobs: TLibPIXCDCobCompletaArray;
      fparametros: TLibPIXCDParametrosConsultaCob;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure Processar(const CobsConsultadas: TACBrPIXCobsConsultadas);

    published
      property cobs: TLibPIXCDCobCompletaArray read fcobs write fcobs;
      property parametros: TLibPIXCDParametrosConsultaCob read fparametros write fparametros;
  end;

  { TLibPIXCDDevolucaoPixResposta }
  TLibPIXCDDevolucaoPixResposta = class(TACBrLibRespostaBase)
    private
      fliquidacao: TDateTime;
      fliquidacao_Bias: Integer;
      fsolicitacao: TDateTime;
      fsolicitacao_Bias: Integer;
      fid: String;
      fmotivo: String;
      frtrId: String;
      fstatus: TACBrPIXStatusDevolucao;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce; overload;
      constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); overload;

      procedure Clear;
      procedure Processar(const Devolucao: TACBrPIXDevolucao);

    published
      property liquidacao: TDateTime read fliquidacao write fliquidacao;
      property liquidacao_Bias: Integer read fliquidacao_Bias write fliquidacao_Bias;
      property solicitacao: TDateTime read fsolicitacao write fsolicitacao;
      property solicitacao_Bias: Integer read fsolicitacao_Bias write fsolicitacao_Bias;
      property id: String read fId write fId;
      property motivo: String read fmotivo write fmotivo;
      property rtrId: String read frtrId write frtrId;
      property status: TACBrPIXStatusDevolucao read fStatus write fStatus;
  end;

  { TLibPIXCDConsultarPixRecebidosResposta }
  TLibPIXCDConsultarPixRecebidosResposta = class(TACBrLibRespostaBase)
    private
      fcnpj: String;
      fcpf: String;
      fdevolucaoPresente: Boolean;
      ffim: TDateTime;
      finicio: TDateTime;
      fPaginaAtual: Integer;
      fItensPorPagina: Integer;
      fQuantidadeDePaginas: Integer;
      fQuantidadeTotaldeItens: Integer;
      ftxid: String;
      ftxIdPresente: Boolean;
      FPix: TACBrObjectList;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure Processar(const PixConsultados: TACBrPIXConsultados);

    published
      property cnpj: String read FCnpj write FCnpj;
      property cpf: String read FCpf write FCpf;
      property devolucaoPresente: Boolean  read FdevolucaoPresente write FdevolucaoPresente;
      property fim: TDateTime read Ffim write Ffim;
      property inicio: TDateTime read Finicio write finicio;
      property paginaAtual: Integer read fpaginaAtual write fpaginaAtual;
      property itensPorPagina: Integer read fitensPorPagina write fitensPorPagina;
      property quantidadeDePaginas: Integer read fquantidadeDePaginas write fquantidadeDePaginas;
      property quantidadeTotalDeItens: Integer read fquantidadeTotalDeItens write fquantidadeTotalDeItens;
      property TxId: String read FTxId write FTxId;
      property TxIdPresente: Boolean read FTxIdPresente write FTxIdPresente;
      property Pix: TACBrObjectList read FPix write FPix;
  end;

  { TLibPIXCDSaqueTrocoInfo }
  TLibPIXCDSaqueTrocoInfo = class(TACBrLibRespostaBase)
    private
      fmodalidadeAgente: TACBrPIXModalidadeAgente;
      fmodalidadeAlteracao: Boolean;
      fprestadorDoServicoDeSaque: Integer;
      fvalor: Currency;

    public
      procedure Clear;
      procedure Processar(const SaqueTroco: TACBrPIXSaqueTroco);

    published
      property modalidadeAgente: TACBrPIXModalidadeAgente read fmodalidadeAgente write fmodalidadeAgente;
      property modalidadeAlteracao: Boolean read fmodalidadeAlteracao write fmodalidadeAlteracao;
      property prestadorDoServicoDeSaque: Integer read fprestadorDoServicoDeSaque write fprestadorDoServicoDeSaque;
      property valor: Currency read fValor write fValor;
  end;

  { TLibPIXCDComponentesValorInfo }
  TLibPIXCDComponentesValorInfo = class(TACBrLibRespostaBase)
    private
      fabatimento: Currency;
      fdesconto: Currency;
      fjuros: Currency;
      fmulta: Currency;
      foriginal: Currency;
      fsaque: TLibPIXCDSaqueTrocoInfo;
      ftroco: TLibPIXCDSaqueTrocoInfo;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;
      procedure Clear;
      procedure Processar(const ComponentesValor: TACBrPIXComponentesValor);

    published
      property abatimento: Currency read fabatimento write fabatimento;
      property desconto: Currency read fdesconto write fdesconto;
      property juros: Currency read fjuros write fjuros;
      property multa: Currency read fmulta write fmulta;
      property original: Currency read foriginal write foriginal;
      property saque: TLibPIXCDSaqueTrocoInfo read fsaque;
      property troco: TLibPIXCDSaqueTrocoInfo read ftroco;
  end;

  { TLibPIXCDConsultarPixResposta }
  TLibPIXCDConsultarPixResposta = class(TACBrLibRespostaBase)
    private
      fchave: String;
      fcomponentesValor: TLibPIXCDComponentesValorInfo;
      fdevolucoes: TACBrObjectList;
      fendToEndId: String;
      fhorario: TDateTime;
      fhorario_Bias: Integer;
      finfoPagador: String;
      ftxid: String;
      fvalor: Currency;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce; overload;
      constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); overload;
      destructor Destroy; override;

      procedure Clear;
      procedure Processar(const Pix: TACBrPIX);

    published
      property chave: String read fchave write fchave;
      property componentesValor: TLibPIXCDComponentesValorInfo read fcomponentesValor;
      property devolucoes: TACBrObjectList read fDevolucoes;
      property endToEndId: String read FendToEndId write fendToEndId;
      property horario: TDateTime read Fhorario write Fhorario;
      property horario_Bias: Integer read fhorario_Bias write fhorario_Bias;
      property infoPagador: String read fInfoPagador write fInfoPagador;
      property TxId: String read fTxId write fTxId;
      property valor: Currency read fValor write fValor;
  end;

  { TLibPIXCDResposta }
  TLibPIXCDResposta = class (TACBrLibRespostaBase)
    private
      fStatus: Integer;
      fTitle: String;
      fDetail: String;

    public
      constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
      destructor Destroy; override;

      procedure Clear;
      procedure Processar(const PIXCD: TACBrPIXProblema);

    published
      property Status: Integer read fStatus write fStatus;
      property Title: String read fTitle write fTitle;
      property Detail: String read fDetail write fDetail;
  end;

implementation

{ TLibPIXCDProblemaRespostaViolacao }

procedure TLibPIXCDProblemaRespostaViolacao.Processar(const Violacao: TACBrPIXViolacao);
begin
  fPropriedade := Violacao.propriedade;
  fRazao := Violacao.razao;
  fValor := Violacao.valor;
end;

{ TLibPIXCDProblemaResposta }
constructor TLibPIXCDProblemaResposta.Create(const ATipo: TACBrLibRespostaTipo;
  const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespProblema, ATipo, AFormato);
  fViolacoes := TACBrObjectList.Create;
  Clear;
end;

destructor TLibPIXCDProblemaResposta.Destroy;
begin
  fViolacoes.Free;
  inherited Destroy;
end;

procedure TLibPIXCDProblemaResposta.Clear;
begin
  fcorrelationId := EmptyStr;
  fStatus := 0;
  fTitle := EmptyStr;
  fDetail := EmptyStr;
  ftype_uri := EmptyStr;
  fViolacoes.Clear;
end;

procedure TLibPIXCDProblemaResposta.Processar(const Problema: TACBrPIXProblema);
var
  LViolacao: TLibPIXCDProblemaRespostaViolacao;
  i: Integer;
begin
  fStatus := Problema.status;
  fTitle := Problema.title;
  fDetail := Problema.detail;
  fcorrelationId := Problema.correlationId;
  ftype_uri := Problema.type_uri;

  for i:=0 to Pred(Problema.violacoes.Count) do
  begin
    LViolacao := TLibPIXCDProblemaRespostaViolacao.Create('Violacoes'+IntToStrZero(i+1, 3), Tipo, Codificacao);
    LViolacao.Processar(Problema.violacoes.Items[i]);
    fViolacoes.Add(LViolacao);
  end;
end;

{ TLibPixCDValorVInfo }
procedure TLibPixCDValorVInfo.Clear;
begin
  fModalidadeAbatimento := pvmNenhum;
  fvalorPercAbatimento := 0;
  fModalidadeDesconto := pdmNenhum;
  fValorPercDesconto := 0;
  fModalidadeJuros := pjmNenhum;
  fValorPercJuros := 0;
  fModalidadeMulta := pvmNenhum;
  fValorPercMulta := 0;
  foriginal := 0;
end;

procedure TLibPixCDValorVInfo.Processar(const ValorV: TACBrPIXCobVValor);
begin
  ModalidadeAbatimento := ValorV.abatimento.modalidade;
  valorPercAbatimento := ValorV.abatimento.valorPerc;
  ModalidadeDesconto := ValorV.desconto.modalidade;
  ValorPercDesconto := ValorV.desconto.valorPerc;
  ModalidadeJuros := ValorV.juros.modalidade;
  ValorPercJuros := ValorV.juros.valorPerc;
  ModalidadeMulta := ValorV.multa.modalidade;
  ValorPercMulta := ValorV.multa.valorPerc;
  original := ValorV.original;
end;

{ TLibPIXCDCalendarioVInfo }
procedure TLibPIXCDCalendarioVInfo.Clear;
begin
  Fcriacao := 0;
  Fcriacao_Bias := 0;
  FdataDeVencimento := 0;
  FvalidadeAposVencimento := 0;
end;

procedure TLibPIXCDCalendarioVInfo.Processar(const CalendarioV: TACBrPIXCalendarioCobVGerada);
begin
  criacao := CalendarioV.criacao;
  criacao_Bias := CalendarioV.criacao_Bias;
  dataDeVencimento := CalendarioV.dataDeVencimento;
  validadeAposVencimento := CalendarioV.validadeAposVencimento;
end;

{ TLibPIXCDValorInfo }
procedure TLibPIXCDValorInfo.Clear;
begin
  Original := 0;
  modalidadeAlteracao := False;
end;

procedure TLibPIXCDValorInfo.Processar(const Valor: TACBrPIXCobValor);
begin
  Original := Valor.original;
  modalidadeAlteracao := Valor.modalidadeAlteracao;
end;

{ TLibPIXCDLocInfo }
procedure TLibPIXCDLocInfo.Clear;
begin
  fId := 0;
  fTxId := EmptyStr;
  fLocation := EmptyStr;
  fCriacao := 0;
  fCriacao_Bias := 0;
end;

procedure TLibPIXCDLocInfo.Processar(const Loc: TACBrPIXLocationCompleta);
begin
  Id := Loc.id;
  TxId := Loc.txId;
  location := Loc.location;
  criacao := Loc.criacao;
  Criacao_Bias := Loc.criacao_Bias;
end;

{ TLibPIXCDDevedorInfo }
procedure TLibPIXCDDevedorInfo.Clear;
begin
  cnpj := EmptyStr;
  cpf := EmptyStr;
  nome := EmptyStr;
end;

procedure TLibPIXCDDevedorInfo.Processar(const Devedor: TACBrPIXDevedor);
begin
  cnpj := Devedor.cnpj;
  cpf := Devedor.cpf;
  nome := Devedor.nome;
end;

procedure TLibPIXCDDevedorInfo.ProcessarDadosDevedor(const Devedor: TACBrPIXDadosDevedor);
begin
  Processar(Devedor);
  email := Devedor.email;
  Logradouro := Devedor.Logradouro;
  Cidade := Devedor.Cidade;
  Uf := Devedor.Uf;
  Cep := Devedor.Cep;
end;

procedure TLibPIXCDDevedorInfo.ProcessarDadosRecebedor(const Recebedor: TACBrPIXDadosRecebedor);
begin
  Processar(Recebedor);
  nome := Recebedor.nomeFantasia;
  logradouro := Recebedor.logradouro;
  cidade := Recebedor.cidade;
  uf := Recebedor.uf;
  cep := Recebedor.cep;
end;

{ TLibPIXCDCalendarioInfo }
procedure TLibPIXCDCalendarioInfo.Clear;
begin
  fCriacao := 0;
  fCriacao_Bias := 0;
  fExpiracao := 0
end;

procedure TLibPIXCDCalendarioInfo.Processar(const Calendario: TACBrPIXCalendarioCobGerada);
begin
  Criacao :=  Calendario.criacao;
  Criacao_Bias := Calendario.criacao_Bias;
  Expiracao := Calendario.expiracao;
end;

{ TLibPIXCDCobVResposta }
constructor TLibPIXCDCobVResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespCobVGerada, ATipo, AFormato);
  fcalendario := TLibPIXCDCalendarioVInfo.Create(CSessaoRespCalendario, ATipo, AFormato);
  fdevedor := TLibPIXCDDevedorInfo.Create(CSessaoRespDevedor, ATipo, AFormato);
  floc := TLibPIXCDLocInfo.Create(CSessaoRespLocation, ATipo, AFormato);
  frecebedor := TLibPIXCDDevedorInfo.Create(CSessaoRespRecebedor, ATipo, AFormato);
  fvalor := TLibPixCDValorVInfo.Create(CSessaoRespValor, ATipo, AFormato);
  fPix := TACBrObjectList.Create;
  Clear;
end;

destructor TLibPIXCDCobVResposta.Destroy;
begin
  inherited Destroy;
  fcalendario.Free;
  fDevedor.Free;
  fLoc.Free;
  fRecebedor.Free;
  fValor.Free;
  fPix.Free;
end;

procedure TLibPIXCDCobVResposta.Clear;
begin
  fcalendario.Clear;
  fdevedor.Clear;
  floc.Clear;
  frecebedor.Clear;
  frevisao := 0;
  fstatus := stcNENHUM;
  ftxId := EmptyStr;
  fvalor.Clear;
end;

procedure TLibPIXCDCobVResposta.ProcessarCobVGerada(const CobVGerada: TACBrPIXCobVGerada);
begin
  fcalendario.Processar(CobVGerada.calendario);
  fdevedor.ProcessarDadosDevedor(CobVGerada.devedor);
  floc.Processar(CobVGerada.loc);
  frecebedor.ProcessarDadosRecebedor(CobVGerada.recebedor);
  frevisao := CobVGerada.revisao;
  fstatus := CobVGerada.status;
  ftxId := CobVGerada.txId;
  fvalor.Processar(CobVGerada.valor);
end;

procedure TLibPIXCDCobVResposta.ProcessarCobVCompleta(const CobVCompleta: TACBrPIXCobVCompleta);
var
  i: Integer;
  PixInfo: TLibPIXCDConsultarPixResposta;
begin
  ProcessarCobVGerada(CobVCompleta);
  for i:=0 to CobVCompleta.pix.Count-1 do
  begin
    PixInfo := TLibPIXCDConsultarPixResposta.Create(CSessaoRespPixInfo+IntToStr(i), Tipo, Codificacao);
    PixInfo.Processar(CobVCompleta.pix[i]);
    fPix.Add(PixInfo);
  end;
end;

{ TLibPIXCDCobResposta }
constructor TLibPIXCDCobResposta.Create(const ATipo: TACBrLibRespostaTipo;
  const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespCobGerada, ATipo, AFormato);

  fCalendario := TLibPIXCDCalendarioInfo.Create(CSessaoRespCalendario, ATipo, AFormato);
  fDevedor := TLibPIXCDDevedorInfo.Create(CSessaoRespDevedor, ATipo, AFormato);
  fLoc := TLibPIXCDLocInfo.Create(CSessaoRespLocation, ATipo, AFormato);
  fValor := TLibPIXCDValorInfo.Create(CSessaoRespValor, ATipo, AFormato);
  fPix := TACBrObjectList.Create;
  Clear;
end;

destructor TLibPIXCDCobResposta.Destroy;
begin
  fCalendario.Free;
  fDevedor.Free;
  fLoc.Free;
  fValor.Free;;
  fPix.Free;
  inherited Destroy;
end;

procedure TLibPIXCDCobResposta.Clear;
begin
  fCalendario.Clear;
  fTxId := '';
  fRevisao := 0;
  fDevedor.Clear;
  fLoc.Clear;
  fStatus := TACBrPIXStatusCobranca.stcNENHUM;
  fValor.Clear;
  fPix.Clear;
end;

procedure TLibPIXCDCobResposta.ProcessarCobGerada(const CobGerada: TACBrPIXCobGerada);
begin
  TxId := CobGerada.txId;
  Revisao := CobGerada.revisao;
  Status := CobGerada.status;
  pixCopiaeCola := CobGerada.pixCopiaECola;

  Calendario.Processar(CobGerada.calendario);
  devedor.Processar(CobGerada.devedor);
  Loc.Processar(CobGerada.Loc);
  Valor.Processar(CobGerada.Valor);
end;

procedure TLibPIXCDCobResposta.ProcessarCobCompleta(const CobCompleta: TACBrPIXCobCompleta);
var
  i: Integer;
  PixInfo: TLibPIXCDConsultarPixResposta;
begin
  ProcessarCobGerada(CobCompleta);
  for i:=0 to CobCompleta.pix.Count-1 do
  begin
    PixInfo := TLibPIXCDConsultarPixResposta.Create(CSessaoRespPixInfo+IntToStr(i), Tipo, Codificacao);
    PixInfo.Processar(CobCompleta.pix[i]);
    fPix.Add(PixInfo);
  end;
end;

{ TLibPIXCDDevolucaoPixResposta }
constructor TLibPIXCDDevolucaoPixResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespDevolucao, ATipo, AFormato);
end;

constructor TLibPIXCDDevolucaoPixResposta.Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(ASessao, ATipo, AFormato);
end;

procedure TLibPIXCDDevolucaoPixResposta.Clear;
begin
  fliquidacao := 0;
  fliquidacao_Bias := 0;
  fsolicitacao := 0;
  fsolicitacao_Bias := 0;
  fid := EmptyStr;
  fmotivo := EmptyStr;
  frtrId := EmptyStr;
  fstatus := stdNENHUM;
end;

procedure TLibPIXCDDevolucaoPixResposta.Processar(const Devolucao: TACBrPIXDevolucao);
begin
  liquidacao := Devolucao.horario.liquidacao;
  liquidacao_Bias := Devolucao.horario.liquidacao_Bias;
  solicitacao := Devolucao.horario.solicitacao;
  solicitacao_Bias := Devolucao.horario.solicitacao_Bias;
  id := Devolucao.id;
  motivo := Devolucao.motivo;
  rtrId := Devolucao.rtrId;
  status := Devolucao.status;
end;

{ TLibPIXCDConsultarPixRecebidosResposta }
constructor TLibPIXCDConsultarPixRecebidosResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsultarPixRecebidos, ATipo, AFormato);
  FPix := TACBrObjectList.Create;
  Clear;
end;

destructor TLibPIXCDConsultarPixRecebidosResposta.Destroy;
begin
  FPix.Free;
  inherited Destroy;
end;

procedure TLibPIXCDConsultarPixRecebidosResposta.Clear;
begin
  fcnpj := EmptyStr;
  fcpf := EmptyStr;
  fdevolucaoPresente := False;
  ffim := 0;
  finicio := 0;
  fPaginaAtual := 0;
  fItensPorPagina := 0;
  fQuantidadeDePaginas := 0;
  fQuantidadeTotaldeItens := 0;
  ftxid := EmptyStr;
  ftxIdPresente := false;
  FPix.Clear;
end;

procedure TLibPIXCDConsultarPixRecebidosResposta.Processar(const PixConsultados: TACBrPIXConsultados);
var
  i: Integer;
  PixInfo: TLibPIXCDConsultarPixResposta;
begin
  cnpj := PixConsultados.parametros.cnpj;
  cpf := PixConsultados.parametros.cpf;
  devolucaoPresente :=  PixConsultados.parametros.devolucaoPresente;
  inicio := PixConsultados.parametros.inicio;
  fim := PixConsultados.parametros.fim;
  paginaAtual := PixConsultados.parametros.paginacao.paginaAtual;
  itensPorPagina := PixConsultados.parametros.paginacao.itensPorPagina;
  quantidadeDePaginas := PixConsultados.parametros.paginacao.quantidadeDePaginas;
  quantidadeTotalDeItens := PixConsultados.parametros.paginacao.quantidadeTotalDeItens;
  TxId := PixConsultados.parametros.txid;
  TxIdPresente := PixConsultados.parametros.txIdPresente;
  for i:=0 to PixConsultados.pix.Count-1 do
  begin
    PixInfo := TLibPIXCDConsultarPixResposta.Create('PIX'+IntToStr(i+1), Tipo, Codificacao);
    PixInfo.Processar(PixConsultados.pix[i]);
    FPix.Add(PixInfo);
  end;
end;

{ TLibPIXCDSaqueTrocoInfo }
procedure TLibPIXCDSaqueTrocoInfo.Clear;
begin
  fmodalidadeAgente := maNENHUM;
  fmodalidadeAlteracao := False;
  fprestadorDoServicoDeSaque := 0;
  fvalor := 0;
end;

procedure TLibPIXCDSaqueTrocoInfo.Processar(const SaqueTroco: TACBrPIXSaqueTroco);
begin
  prestadorDoServicoDeSaque := SaqueTroco.prestadorDoServicoDeSaque;
  modalidadeAlteracao := SaqueTroco.modalidadeAlteracao;
  modalidadeAgente := SaqueTroco.modalidadeAgente;
  valor := SaqueTroco.valor;
end;

{ TLibPIXCDComponentesValorInfo }
constructor TLibPIXCDComponentesValorInfo.Create(
  const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create('ComponentesValor', ATipo, AFormato);
  fSaque := TLibPIXCDSaqueTrocoInfo.Create('Saque', ATipo, AFormato);
  ftroco := TLibPIXCDSaqueTrocoInfo.Create('Troco', ATipo, AFormato);
end;

destructor TLibPIXCDComponentesValorInfo.Destroy;
begin
  inherited Destroy;
  fSaque.Free;
  fTroco.Free;
end;

procedure TLibPIXCDComponentesValorInfo.Clear;
begin
  fabatimento := 0;
  fdesconto := 0;
  fjuros := 0;
  fmulta := 0;
  foriginal := 0;
  fsaque.Clear;
  ftroco.Clear;
end;

procedure TLibPIXCDComponentesValorInfo.Processar(const ComponentesValor: TACBrPIXComponentesValor);
begin
  abatimento := ComponentesValor.abatimento.valor;
  desconto := ComponentesValor.desconto.valor;
  juros := ComponentesValor.juros.valor;
  multa := ComponentesValor.multa.valor;
  original := ComponentesValor.original.valor;
  fSaque.Processar(ComponentesValor.saque);
  fTroco.Processar(ComponentesValor.troco);
end;

{ TLibPIXCDConsultarPixResposta }
constructor TLibPIXCDConsultarPixResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
 inherited Create(CSessaoRespPixInfo, ATipo, AFormato);
 fcomponentesValor := TLibPIXCDComponentesValorInfo.Create(ATipo, AFormato);
 fdevolucoes := TACBrObjectList.Create;
end;

constructor TLibPIXCDConsultarPixResposta.Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(ASessao, ATipo, AFormato);
  fcomponentesValor := TLibPIXCDComponentesValorInfo.Create(ATipo, AFormato);
  fdevolucoes := TACBrObjectList.Create;
end;

destructor TLibPIXCDConsultarPixResposta.Destroy;
begin
  fcomponentesValor.Free;
  fdevolucoes.Free;
  inherited Destroy;
end;

procedure TLibPIXCDConsultarPixResposta.Clear;
begin
  fchave := EmptyStr;
  fcomponentesValor.Clear;;
  fdevolucoes.Clear;
  fendToEndId := EmptyStr;
  fhorario := 0;
  fhorario_Bias := 0;
  finfoPagador := EmptyStr;
  ftxid := EmptyStr;
  fvalor := 0;
end;

procedure TLibPIXCDConsultarPixResposta.Processar(const Pix: TACBrPIX);
var
  i: Integer;
  DevolucaoInfo: TLibPIXCDDevolucaoPixResposta;
begin
  chave := Pix.chave;
  componentesValor.Processar(Pix.componentesValor);
  for i:=0 to Pix.devolucoes.Count-1 do
  begin
    DevolucaoInfo := TLibPIXCDDevolucaoPixResposta.Create(CSessaoRespDevolucao+IntToStr(i+1), Tipo, Codificacao);
    DevolucaoInfo.Processar(Pix.devolucoes[i]);
    fdevolucoes.Add(DevolucaoInfo);
  end;
  endToEndId := Pix.endToEndId;
  horario := Pix.horario;
  horario_Bias := Pix.horario_Bias;
  infoPagador := Pix.infoPagador;
  TxId := Pix.txid;
  valor := Pix.valor;
end;

{ TLibPIXCDResposta }
constructor TLibPIXCDResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespPIXCD, ATipo, AFormato);
  Clear;
end;

destructor TLibPIXCDResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TLibPIXCDResposta.Clear;
begin
  fStatus := 0;
  fTitle := EmptyStr;
  fDetail := EmptyStr;
end;

procedure TLibPIXCDResposta.Processar(const PIXCD: TACBrPIXProblema);
begin
  fStatus := PIXCD.status;
  fTitle := PIXCD.title;
  fDetail := PIXCD.detail;
end;

{ TLibPIXCDCobsConsultadas }
constructor TLibPIXCDCobsConsultadas.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespCobsConsultadas, ATipo, AFormato);
  fcobs := TLibPIXCDCobCompletaArray.Create(CSessaoRespCobCompleta, ATipo, AFormato);
  fparametros := TLibPIXCDParametrosConsultaCob.Create(CSessaoRespParametrosConsultaCob, ATipo, AFormato);
end;

destructor TLibPIXCDCobsConsultadas.Destroy;
begin
  fcobs.Free;
  fparametros.Free;
  inherited Destroy;
end;

procedure TLibPIXCDCobsConsultadas.Clear;
begin
  fcobs.Clear;
  fparametros.Clear;
end;

procedure TLibPIXCDCobsConsultadas.Processar(const CobsConsultadas: TACBrPIXCobsConsultadas);
var
  i: Integer;
  InfoCobs: TLibPIXCDCobCompletaArray;
begin

  for i := 0 to CobsConsultadas.cobs.Count - 1 do
  begin
    InfoCobs := TLibPIXCDCobCompletaArray.Create(CSessaoRespCobsInfo + IntToStr(i), Tipo, Codificacao);
    InfoCobs.Processar(CobsConsultadas.cobs.Items[i].pix);
    cobs.cobs.Add(InfoCobs);
  end;
  parametros.Processar(CobsConsultadas.parametros);
end;

{ TLibPIXCDCobsVConsultadas }
constructor TLibPIXCDCobsVConsultadas.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespCobsVConsultadas, ATipo, AFormato);
  fcobsV := TLibPIXCDCobVCompletaArray.Create(CSessaoRespCobCompleta, ATipo, AFormato);
  fparametros := TLibPIXCDParametrosConsultaCob.Create(CSessaoRespParametrosConsultaCobV, ATipo, AFormato);
end;

destructor TLibPIXCDCobsVConsultadas.Destroy;
begin
  fcobsV.Free;
  fparametros.Free;
  inherited Destroy;
end;

procedure TLibPIXCDCobsVConsultadas.Clear;
begin
  fcobsV.Clear;
  fparametros.Clear;
end;

procedure TLibPIXCDCobsVConsultadas.Processar(const CobsVConsultadas: TACBrPIXCobsVConsultadas);
var
  i: Integer;
  InfoCobsV: TLibPIXCDCobVCompletaArray;
begin
  for i := 0 to CobsVConsultadas.cobs.Count - 1 do
  begin
    InfoCobsV := TLibPIXCDCobVCompletaArray.Create(CSessaoRespCobsVInfo + IntToStr(i), Tipo, Codificacao);;
    InfoCobsV.Processar(CobsVConsultadas.cobs.Items[i].pix);
    cobsV.cobsV.Add(InfoCobsV);
  end;
  parametros.Processar(CobsVConsultadas.parametros);
end;

{ TLibPIXCDCobCompletaArray }
constructor TLibPIXCDCobCompletaArray.Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(ASessao, ATipo, AFormato);
  fcobs := TACBrObjectList.Create;
end;

destructor TLibPIXCDCobCompletaArray.Destroy;
begin
  fcobs.Free;
  inherited Destroy;
end;

procedure TLibPIXCDCobCompletaArray.Clear;
begin
  fcobs.Clear;
end;

procedure TLibPIXCDCobCompletaArray.Processar(const CobCompleta: TACBrPIXArray);
var
  i: Integer;
  cobsInfo: TLibPIXCDConsultarPixResposta;
begin
  for i := 0 to CobCompleta.Count -1 do
  begin
    cobsInfo := TLibPIXCDConsultarPixResposta.Create(CSessaoRespCobs + IntToStr(i), Tipo, Codificacao);
    cobsInfo.Processar(CobCompleta[i]);
    cobs.Add(cobsInfo);
  end;
end;

{ TLibPIXCDParametrosConsultaCob }
constructor TLibPIXCDParametrosConsultaCob.Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespParametrosConsultaCob, ATipo, AFormato);
  fpaginacao := TLibPIXCDPaginacao.Create(CSessaoRespPaginacaoCobV, ATipo, AFormato);
end;

destructor TLibPIXCDParametrosConsultaCob.Destroy;
begin
  fpaginacao.Free;
  inherited Destroy;
end;

procedure TLibPIXCDParametrosConsultaCob.Clear;
begin
  fcnpj := EmptyStr;
  fcpf := EmptyStr;
  flocationPresente := False;
  ffim := 0;
  finicio := 0;
  fpaginacao.Clear;
  fstatus := EmptyStr;
end;

procedure TLibPIXCDParametrosConsultaCob.Processar(const ParametrosConsultaCob: TACBrPIXParametrosConsultaCob);
begin
  cnpj := ParametrosConsultaCob.cnpj;
  cpf := ParametrosConsultaCob.cpf;
  locationPresente := ParametrosConsultaCob.locationPresente;
  fim := ParametrosConsultaCob.fim;
  inicio := ParametrosConsultaCob.inicio;
  paginacao.Processar(ParametrosConsultaCob.paginacao);
  status := ParametrosConsultaCob.status;
end;

{ TLibPIXCDCobVCompletaArray }
constructor TLibPIXCDCobVCompletaArray.Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(ASessao, ATipo, AFormato);
  fcobsV := TACBrObjectList.Create;
end;

destructor TLibPIXCDCobVCompletaArray.Destroy;
begin
  fcobsV.Free;
  inherited Destroy;
end;

procedure TLibPIXCDCobVCompletaArray.Clear;
begin
  fcobsV.Clear;
end;

procedure TLibPIXCDCobVCompletaArray.Processar(const CobVCompleta: TACBrPIXArray);
var
  i: Integer;
  cobsVInfo: TLibPIXCDConsultarPixResposta;
begin
  for i := 0 to CobVCompleta.Count -1 do
  begin
   cobsVInfo := TLibPIXCDConsultarPixResposta.Create(CSessaoRespCobsV + IntToStr(i), Tipo, Codificacao);
   cobsVInfo.Processar(CobVCompleta[i]);
   cobsV.Add(cobsVInfo);
  end;
end;

{ TLibPIXCDPaginacao }
constructor TLibPIXCDPaginacao.Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespPaginacaoCob, ATipo, AFormato);
end;

destructor TLibPIXCDPaginacao.Destroy;
begin
  inherited Destroy;
end;

procedure TLibPIXCDPaginacao.Clear;
begin
  fitensPorPagina := 0;
  fpaginaAtual := 0;
  fquantidadeDePaginas := 0;
  fquantidadeTotalDeItens := 0;
end;

procedure TLibPIXCDPaginacao.Processar(const Paginacao: TACBrPIXPaginacao);
begin
  itensPorPagina := Paginacao.itensPorPagina;
  paginaAtual := Paginacao.paginaAtual;
  quantidadeDePaginas := Paginacao.quantidadeDePaginas;
  quantidadeTotalDeItens := Paginacao.quantidadeTotalDeItens;
end;

end.

