{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrNFe.EventoClass;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrDFe.Conversao,
  pcnConversao,
  pcnConversaoNFe,
//  ACBrNFe.Conversao,
  ACBrNFe.Classes,
  ACBrBase,
  ACBrUtil.Strings;

type
  EventoException = class(EACBrException);

  TDestinatario = class(TObject)
  private
    FUF: string;
    FCNPJCPF: string;
    FidEstrangeiro: string;
    FIE: string;
  public
    property UF: string            read FUF            write FUF;
    property CNPJCPF: string       read FCNPJCPF       write FCNPJCPF;
    property idEstrangeiro: string read FidEstrangeiro write FidEstrangeiro;
    property IE: string            read FIE            write FIE;
  end;

  TitemPedidoCollectionItem = class
  private
    FqtdeItem: Currency;
    FnumItem: Integer;
  public
    property numItem: Integer   read FnumItem  write FnumItem;
    property qtdeItem: Currency read FqtdeItem write FqtdeItem;
  end;

  TitemPedidoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TitemPedidoCollectionItem;
    procedure SetItem(Index: Integer; Value: TitemPedidoCollectionItem);
  public
    function Add: TitemPedidoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TitemPedidoCollectionItem;
    property Items[Index: Integer]: TitemPedidoCollectionItem read GetItem write SetItem; default;
  end;

  TautXMLCollectionItem = class(TObject)
  private
    FCNPJCPF: string;
  public
    procedure Assign(Source: TautXMLCollectionItem);

    property CNPJCPF: string read FCNPJCPF write FCNPJCPF;
  end;

  TautXMLCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TautXMLCollectionItem;
    procedure SetItem(Index: Integer; Value: TautXMLCollectionItem);
  public
    function Add: TautXMLCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New.'{$EndIf};
    function New: TautXMLCollectionItem;
    property Items[Index: Integer]: TautXMLCollectionItem read GetItem write SetItem; default;
  end;

  TdetPagCollectionItem = class
  private
    FindPag: TpcnIndicadorPagamento;
    FtPag: TpcnFormaPagamento;
    FxPag: string;
    FvPag: Currency;
    FdPag: TDateTime;
    FCNPJPag: string;
    FUFPag: string;
    FCNPJIF: string;
    FtBand: TpcnBandeiraCartao;
    FcAut: string;
    FCNPJReceb: string;
    FUFReceb: string;
  public
    property indPag: TpcnIndicadorPagamento read FindPag write FindPag default ipNenhum;
    property tPag: TpcnFormaPagamento read FtPag write FtPag;
    property xPag: string read FxPag write FxPag;
    property vPag: Currency read FvPag write FvPag;
    property dPag: TDateTime read FdPag write FdPag;
    property CNPJPag: string read FCNPJPag write FCNPJPag;
    property UFPag: string read FUFPag write FUFPag;
    property CNPJIF: string read FCNPJIF write FCNPJIF;
    property tBand: TpcnBandeiraCartao read FtBand write FtBand;
    property cAut: string read FcAut write FcAut;
    property CNPJReceb: string read FCNPJReceb write FCNPJReceb;
    property UFReceb: string read FUFReceb write FUFReceb;
  end;

  TdetPagCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TdetPagCollectionItem;
    procedure SetItem(Index: Integer; Value: TdetPagCollectionItem);
  public
    function Add: TdetPagCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TdetPagCollectionItem;
    property Items[Index: Integer]: TdetPagCollectionItem read GetItem write SetItem; default;
  end;

  TgIBSgCBS = class
  private
    FcCredPres: TcCredPres;
    FpCredPres: Double;
    FvCredPres: Double;
  public
    property cCredPres: TcCredPres read FcCredPres write FcCredPres;
    property pCredPres: Double read FpCredPres write FpCredPres;
    property vCredPres: Double read FvCredPres write FvCredPres;
  end;

  TgCredPresCollectionItem = class
  private
    FnItem: Integer;
    FvBC: Double;
    FgIBS: TgIBSgCBS;
    FgCBS: TgIBSgCBS;
  public
    constructor Create;
    destructor Destroy; override;

    property nItem: Integer read FnItem write FnItem;
    property vBC: Double read FvBC write FvBC;
    property gIBS: TgIBSgCBS read FgIBS write FgIBS;
    property gCBS: TgIBSgCBS read FgCBS write FgCBS;
  end;

  TgCredPresCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TgCredPresCollectionItem;
    procedure SetItem(Index: Integer; Value: TgCredPresCollectionItem);
  public
    function Add: TgCredPresCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TgCredPresCollectionItem;
    property Items[Index: Integer]: TgCredPresCollectionItem read GetItem write SetItem; default;
  end;

  TgControleEstoque = class
  private
    FqConsumo: Double;
    FuConsumo: string;
  public
    property qConsumo: Double read FqConsumo write FqConsumo;
    property uConsumo: string read FuConsumo write FuConsumo;
  end;

  TgConsumoCollectionItem = class
  private
    FnItem: Integer;
    FvIBS: Double;
    FvCBS: Double;
    FgControleEstoque: TgControleEstoque;
    FDFeReferenciado: TDFeReferenciado;
  public
    constructor Create;
    destructor Destroy; override;

    property nItem: Integer read FnItem write FnItem;
    property vIBS: Double read FvIBS write FvIBS;
    property vCBS: Double read FvCBS write FvCBS;
    property gControleEstoque: TgControleEstoque read FgControleEstoque write FgControleEstoque;
    property DFeReferenciado: TDFeReferenciado read FDFeReferenciado write FDFeReferenciado;
  end;

  TgConsumoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TgConsumoCollectionItem;
    procedure SetItem(Index: Integer; Value: TgConsumoCollectionItem);
  public
    function Add: TgConsumoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TgConsumoCollectionItem;
    property Items[Index: Integer]: TgConsumoCollectionItem read GetItem write SetItem; default;
  end;

  TgControleEstoqueZFM = class
  private
    Fqtde: Double;
    Funidade: string;
  public
    property qtde: Double read Fqtde write Fqtde;
    property unidade: string read Funidade write Funidade;
  end;

  TgConsumoZFMCollectionItem = class
  private
    FnItem: Integer;
    FvIBS: Double;
    FvCBS: Double;
    FgControleEstoqueZFM: TgControleEstoqueZFM;
  public
    constructor Create;
    destructor Destroy; override;

    property nItem: Integer read FnItem write FnItem;
    property vIBS: Double read FvIBS write FvIBS;
    property vCBS: Double read FvCBS write FvCBS;
    property gControleEstoque: TgControleEstoqueZFM read FgControleEstoqueZFM;
  end;

  TgConsumoZFMCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TgConsumoZFMCollectionItem;
    procedure SetItem(Index: Integer; Value: TgConsumoZFMCollectionItem);
  public
    function Add: TgConsumoZFMCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TgConsumoZFMCollectionItem;
    property Items[Index: Integer]: TgConsumoZFMCollectionItem read GetItem write SetItem; default;
  end;

  //perecimento
  TgControleEstoquePerecimento = class
  private
    FqPerecimento: Double;
    FuPerecimento: string;
  public
    property qPerecimento: Double read FqPerecimento write FqPerecimento;
    property uPerecimento: string read FuPerecimento write FuPerecimento;
  end;

  TgPerecimentoCollectionItem = class
  private
    FnItem: Integer;
    FvIBS: Double;
    FvCBS: Double;
    FgControleEstoque: TgControleEstoquePerecimento;
  public
    constructor Create;
    destructor Destroy; override;

    property nItem: Integer read FnItem write FnItem;
    property vIBS: Double read FvIBS write FvIBS;
    property vCBS: Double read FvCBS write FvCBS;
    property gControleEstoque: TgControleEstoquePerecimento read FgControleEstoque write FgControleEstoque;
  end;

  TgPerecimentoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TgPerecimentoCollectionItem;
    procedure SetItem(Index: Integer; Value: TgPerecimentoCollectionItem);
  public
    function Add: TgPerecimentoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TgPerecimentoCollectionItem;
    property Items[Index: Integer]: TgPerecimentoCollectionItem read GetItem write SetItem; default;
  end;

  //Imobilização de Item
    TgControleEstoqueImobilizacao = class
  private
    FqImobilizado: Double;
    FuImobilizado: string;
  public
    property qImobilizado: Double read FqImobilizado write FqImobilizado;
    property uImobilizado: string read FuImobilizado write FuImobilizado;
  end;

  TgImobilizacaoCollectionItem = class
  private
    FnItem: Integer;
    FvIBS: Double;
    FvCBS: Double;
    FgControleEstoque: TgControleEstoqueImobilizacao;
  public
    constructor Create;
    destructor Destroy; override;

    property nItem: Integer read FnItem write FnItem;
    property vIBS: Double read FvIBS write FvIBS;
    property vCBS: Double read FvCBS write FvCBS;
    property gControleEstoque: TgControleEstoqueImobilizacao read FgControleEstoque write FgControleEstoque;
  end;

  TgImobilizacaoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TgImobilizacaoCollectionItem;
    procedure SetItem(Index: Integer; Value: TgImobilizacaoCollectionItem);
  public
    function Add: TgImobilizacaoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TgImobilizacaoCollectionItem;
    property Items[Index: Integer]: TgImobilizacaoCollectionItem read GetItem write SetItem; default;
  end;

  //Solicitacao de Apropriação de Crédito de Combustível
  TgControleEstoqueComb = class
  private
    FqComb: Double;
    FuComb: string;
  public
    property qComb: Double read FqComb write FqComb;
    property uComb: string read FuComb write FuComb;
  end;

  TgConsumoCombCollectionItem = class
  private
    FnItem: Integer;
    FvIBS: Double;
    FvCBS: Double;
    FgControleEstoque: TgControleEstoqueComb;
  public
    constructor Create;
    destructor Destroy; override;

    property nItem: Integer read FnItem write FnItem;
    property vIBS: Double read FvIBS write FvIBS;
    property vCBS: Double read FvCBS write FvCBS;
    property gControleEstoque: TgControleEstoqueComb read FgControleEstoque write FgControleEstoque;
  end;

  TgConsumoCombCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TgConsumoCombCollectionItem;
    procedure SetItem(Index: Integer; Value: TgConsumoCombCollectionItem);
  public
    function Add: TgConsumoCombCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TgConsumoCombCollectionItem;
    property Items[Index: Integer]: TgConsumoCombCollectionItem read GetItem write SetItem; default;
  end;

   //Solicitacao de Apropriação de Crédito para bens e serviços que dependem de atividade do adquirente
  TgCreditoCollectionItem = class
  private
    FnItem: Integer;
    FvCredIBS: Double;
    FvCredCBS: Double;
  public
    property nItem: Integer read FnItem write FnItem;
    property vCredIBS: Double read FvCredIBS write FvCredIBS;
    property vCredCBS: Double read FvCredCBS write FvCredCBS;
  end;

  TgCreditoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TgCreditoCollectionItem;
    procedure SetItem(Index: Integer; Value: TgCreditoCollectionItem);
  public
    function Add: TgCreditoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TgCreditoCollectionItem;
    property Items[Index: Integer]: TgCreditoCollectionItem read GetItem write SetItem; default;
  end;

  TgControleEstoquePerecimentoForn = class
  private
    FqPerecimento: Double;
    FuPerecimento: string;
    FvCBS: Double;
    FvIBS: Double;
  public
    property qPerecimento: Double read FqPerecimento write FqPerecimento;
    property uPerecimento: string read FuPerecimento write FuPerecimento;
    property vIBS: Double read FvIBS write FvIBS;
    property vCBS: Double read FvCBS write FvCBS;
  end;

  TgPerecimentoFornCollectionItem = class
  private
    FnItem: Integer;
    FvIBS: Double;
    FvCBS: Double;
    FgControleEstoque: TgControleEstoquePerecimentoForn;
  public
    constructor Create;
    destructor Destroy; override;

    property nItem: Integer read FnItem write FnItem;
    property vIBS: Double read FvIBS write FvIBS;
    property vCBS: Double read FvCBS write FvCBS;
    property gControleEstoque: TgControleEstoquePerecimentoForn read FgControleEstoque;
  end;

  TgPerecimentoFornCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TgPerecimentoFornCollectionItem;
    procedure SetItem(Index: Integer; Value: TgPerecimentoFornCollectionItem);
  public
    function Add: TgPerecimentoFornCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TgPerecimentoFornCollectionItem;
    property Items[Index: Integer]: TgPerecimentoFornCollectionItem read GetItem write SetItem; default;
  end;

  TgControleEstoqueItemNaoFornecido = class
  private
    FqNaoFornecida: Double;
    FuNaoFornecida: String;
  public
    property qNaoFornecida: Double read FqNaoFornecida write FqNaoFornecida;
    property uNaoFornecida: String read FuNaoFornecida write FuNaoFornecida;
  end;

  // Fornecimento nao realizado com pagamento antecipado
  TgItemNaoFornecidoCollectionItem = class
  private
    FnItem: Integer;
    FvIBS: Double;
    FvCBS: Double;
    FgControleEstoque: TgControleEstoqueItemNaoFornecido;
  public
    constructor Create;
    destructor Destroy; override;

    property nItem: Integer read FnItem write FnItem;
    property vIBS: Double read FvIBS write FvIBS;
    property vCBS: Double read FvCBS write FvCBS;
    property gControleEstoque: TgControleEstoqueItemNaoFornecido read FgControleEstoque;
  end;

  TgItemNaoFornecidoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TgItemNaoFornecidoCollectionItem;
    procedure SetItem(Index: Integer; Value: TgItemNaoFornecidoCollectionItem);
  public
    function Add: TgItemNaoFornecidoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun~ao New'{$EndIf};
    function New: TgItemNaoFornecidoCollectionItem;
    property Items[Index: Integer]: TgItemNaoFornecidoCollectionItem read GetItem write SetItem; default;
  end;

  TDetEvento = class
  private
    FVersao: string;
    FDescEvento: string;
    FCorrecao: string;     // Carta de Correção
    FCondUso: string;      // Carta de Correção
    FnProt: string;        // Cancelamento
    FxJust: string;        // Cancelamento e Manif. Destinatario
    FcOrgaoAutor: Integer; // EPEC
    FtpAutor: TpcnTipoAutor;
    FverAplic: string;
    FdhEmi: TDateTime;
    FtpNF: TpcnTipoNFe;
    FIE: string;
    Fdest: TDestinatario;
    FvNF: Currency;
    FvICMS: Currency;
    FvST: Currency;
    FitemPedido: TitemPedidoCollection;
    FidPedidoCancelado: string;
    FchNFeRef: string;
    FdhEntrega: TDateTime;
    FnDoc: string;
    FxNome: string;
    FlatGPS: Double;
    FlongGPS: Double;
    FhashComprovante: string;
    FdhHashComprovante: TDateTime;
    FnProtEvento: string;
    FautXML: TautXMLCollection;
    FtpAutorizacao: TAutorizacao;
    // Insucesso na Entrega
    FdhTentativaEntrega: TDateTime;
    FnTentativa: Integer;
    FtpMotivo: TtpMotivo;
    FxJustMotivo: string;
    FhashTentativaEntrega: string;
    FdhHashTentativaEntrega: TDateTime;
    FUF: string;
    FdetPag: TdetPagCollection;
    // Reforma Tributária
    FtpEventoAut: string;
    FgCredPres: TgCredPresCollection;
    FgConsumo: TgConsumoCollection;
    FgPerecimento: TgPerecimentoCollection;
    FgImobilizacao: TgImobilizacaoCollection;
    FgConsumoComb: TgConsumoCombCollection;
    FgCredito: TgCreditoCollection;
    FIndAceitacao: TIndAceitacao;
    FgConsumoZFM: TgConsumoZFMCollection;
    FgPerecimentoForn: TgPerecimentoFornCollection;
    FgItemNaoFornecido: TgItemNaoFornecidoCollection;
    FdPrevEntrega: TDateTime;

    procedure setxCondUso(const Value: string);
    procedure SetitemPedido(const Value: TitemPedidoCollection);
    procedure SetautXML(const Value: TautXMLCollection);
    procedure SetdetPag(const Value: TdetPagCollection);
    procedure SetgCredPres(const Value: TgCredPresCollection);
    procedure SetgConsumo(const Value: TgConsumoCollection);
    procedure SetgPerecimento(const Value: TgPerecimentoCollection);
    procedure SetgImobilizacao(const Value: TgImobilizacaoCollection);
    procedure SetgConsumoComb(const Value: TgConsumoCombCollection);
    procedure SetgCredito(const Value: TgCreditoCollection);
    procedure SetIndAceitacao(const Value: TIndAceitacao);
  public
    constructor Create;
    destructor Destroy; override;

    property versao: string         read FVersao      write FVersao;
    property descEvento: string     read FDescEvento  write FDescEvento;
    property xCorrecao: string      read FCorrecao    write FCorrecao;
    property xCondUso: string       read FCondUso     write setxCondUso;
    property nProt: string          read FnProt       write FnProt;
    property xJust: string          read FxJust       write FxJust;
    property cOrgaoAutor: Integer   read FcOrgaoAutor write FcOrgaoAutor;
    property tpAutor: TpcnTipoAutor read FtpAutor     write FtpAutor;
    property verAplic: string       read FverAplic    write FverAplic;
    property chNFeRef: string       read FchNFeRef    write FchNFeRef;
    property dhEmi: TDateTime       read FdhEmi       write FdhEmi;
    property tpNF: TpcnTipoNFe      read FtpNF        write FtpNF;
    property IE: string             read FIE          write FIE;
    property dest: TDestinatario    read Fdest        write Fdest;
    property vNF: Currency          read FvNF         write FvNF;
    property vICMS: Currency        read FvICMS       write FvICMS;
    property vST: Currency          read FvST         write FvST;


    property itemPedido: TitemPedidoCollection read FitemPedido        write SetitemPedido;
    property idPedidoCancelado: string         read FidPedidoCancelado write FidPedidoCancelado;

    property dhEntrega: TDateTime         read FdhEntrega         write FdhEntrega;
    property nDoc: string                 read FnDoc              write FnDoc;
    property xNome: string                read FxNome             write FxNome;
    property latGPS: Double               read FlatGPS            write FlatGPS;
    property longGPS: Double              read FlongGPS           write FlongGPS;
    property hashComprovante: string      read FhashComprovante   write FhashComprovante;
    property dhHashComprovante: TDateTime read FdhHashComprovante write FdhHashComprovante;
    property nProtEvento: string          read FnProtEvento       write FnProtEvento;

    property autXML: TautXMLCollection    read FautXML            write SetautXML;
    property tpAutorizacao: TAutorizacao  read FtpAutorizacao     write FtpAutorizacao;

    property dhTentativaEntrega: TDateTime read FdhTentativaEntrega write FdhTentativaEntrega;
    property nTentativa: Integer read FnTentativa write FnTentativa;
    property tpMotivo: TtpMotivo read FtpMotivo write FtpMotivo;
    property xJustMotivo: string read FxJustMotivo write FxJustMotivo;
    property hashTentativaEntrega: string read FhashTentativaEntrega write FhashTentativaEntrega;
    property dhHashTentativaEntrega: TDateTime read FdhHashTentativaEntrega write FdhHashTentativaEntrega;
    property UF: string read FUF write FUF;
    property detPag: TdetPagCollection read FdetPag write SetdetPag;

    // Reforma Tributária
    property tpEventoAut: string read FtpEventoAut write FtpEventoAut;
    property gCredPres: TgCredPresCollection read FgCredPres write SetgCredPres;
    property gConsumo: TgConsumoCollection read FgConsumo write SetgConsumo;
    property gConsumoZFM: TgConsumoZFMCollection read FgConsumoZFM;
    property gPerecimento: TgPerecimentoCollection read FgPerecimento write SetgPerecimento;
    property gPerecimentoForn: TgPerecimentoFornCollection read FgPerecimentoForn;
    property gItemNaoFornecido: TgItemNaoFornecidoCollection read FgItemNaoFornecido;
    property gImobilizacao: TgImobilizacaoCollection read FgImobilizacao write SetgImobilizacao;
    property gConsumoComb: TgConsumoCombCollection read FgConsumoComb write SetgConsumoComb;
    property gCredito: TgCreditoCollection read FgCredito write SetgCredito;
    property indAceitacao: TIndAceitacao read  FIndAceitacao write SetIndAceitacao;
    property dPrevEntrega: TDateTime read FdPrevEntrega write FdPrevEntrega;
  end;

  TInfEvento = class
  private
    FID: string;
    FtpAmbiente: TpcnTipoAmbiente;
    FCNPJ: string;
    FcOrgao: Integer;
    FChave: string;
    FDataEvento: TDateTime;
    FTpEvento: TpcnTpEvento;
    FnSeqEvento: Integer;
    FVersaoEvento: string;
    FDetEvento: TDetEvento;

    function getcOrgao: Integer;
    function getDescEvento: string;
    function getTipoEvento: string;
  public
    constructor Create;
    destructor Destroy; override;

    function DescricaoTipoEvento(TipoEvento:TpcnTpEvento): string;

    property id: string              read FID            write FID;
    property cOrgao: Integer         read getcOrgao      write FcOrgao;
    property tpAmb: TpcnTipoAmbiente read FtpAmbiente    write FtpAmbiente;
    property CNPJ: string            read FCNPJ          write FCNPJ;
    property chNFe: string           read FChave         write FChave;
    property dhEvento: TDateTime     read FDataEvento    write FDataEvento;
    property tpEvento: TpcnTpEvento  read FTpEvento      write FTpEvento;
    property nSeqEvento: Integer     read FnSeqEvento    write FnSeqEvento;
    property versaoEvento: string    read FVersaoEvento  write FversaoEvento;
    property detEvento: TDetEvento   read FDetEvento     write FDetEvento;
    property DescEvento: string      read getDescEvento;
    property TipoEvento: string      read getTipoEvento;
  end;

  TRetchNFePendCollectionItem = class
  private
    FChavePend: string;
  public
    property ChavePend: string read FChavePend write FChavePend;
  end;

  TRetchNFePendCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetchNFePendCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetchNFePendCollectionItem);
  public
    function Add: TRetchNFePendCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TRetchNFePendCollectionItem;
    property Items[Index: Integer]: TRetchNFePendCollectionItem read GetItem write SetItem; default;
  end;

  { TRetInfEvento }

  TRetInfEvento = class(TObject)
  private
    FId: string;
    FNomeArquivo: string;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: string;
    FcOrgao: Integer;
    FcStat: Integer;
    FxMotivo: string;
    FchNFe: string;
    FtpEvento: TpcnTpEvento;
    FxEvento: string;
    FnSeqEvento: Integer;
    FCNPJDest: string;
    FemailDest: string;
    FcOrgaoAutor: Integer;
    FdhRegEvento: TDateTime;
    FnProt: string;
    FchNFePend: TRetchNFePendCollection;
    FXML: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: string                         read FId          write FId;
    property tpAmb: TpcnTipoAmbiente            read FtpAmb       write FtpAmb;
    property verAplic: string                   read FverAplic    write FverAplic;
    property cOrgao: Integer                    read FcOrgao      write FcOrgao;
    property cStat: Integer                     read FcStat       write FcStat;
    property xMotivo: string                    read FxMotivo     write FxMotivo;
    property chNFe: string                      read FchNFe       write FchNFe;
    property tpEvento: TpcnTpEvento             read FtpEvento    write FtpEvento;
    property xEvento: string                    read FxEvento     write FxEvento;
    property nSeqEvento: Integer                read FnSeqEvento  write FnSeqEvento;
    property CNPJDest: string                   read FCNPJDest    write FCNPJDest;
    property emailDest: string                  read FemailDest   write FemailDest;
    property cOrgaoAutor: Integer               read FcOrgaoAutor write FcOrgaoAutor;
    property dhRegEvento: TDateTime             read FdhRegEvento write FdhRegEvento;
    property nProt: string                      read FnProt       write FnProt;
    property chNFePend: TRetchNFePendCollection read FchNFePend   write FchNFePend;
    property XML: AnsiString                    read FXML         write FXML;
    property NomeArquivo: string                read FNomeArquivo write FNomeArquivo;
  end;

implementation

{ TInfEvento }

constructor TInfEvento.Create;
begin
  inherited Create;

  FDetEvento := TDetEvento.Create();
end;

destructor TInfEvento.Destroy;
begin
  FDetEvento.Free;

  inherited;
end;

function TInfEvento.getcOrgao: Integer;
//  (AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,RJ,RN,RS,RO,RR,SC,SP,SE,TO);
//  (12,27,16,13,29,23,53,32,52,21,51,50,31,15,25,41,26,22,33,24,43,11,14,42,35,28,17);
begin
  if FcOrgao <> 0 then
    Result := FcOrgao
  else
    Result := StrToIntDef(copy(FChave, 1, 2), 0);
end;

function TInfEvento.getDescEvento: string;
begin
  case fTpEvento of
    teCCe                      : Result := 'Carta de Correcao';
    teCancelamento             : Result := 'Cancelamento';
    teCancSubst                : Result := 'Cancelamento por substituicao';
    teManifDestConfirmacao     : Result := 'Confirmacao da Operacao';
    teManifDestCiencia         : Result := 'Ciencia da Operacao';
    teManifDestDesconhecimento : Result := 'Desconhecimento da Operacao';
    teManifDestOperNaoRealizada: Result := 'Operacao nao Realizada';
    teEPECNFe                  : Result := 'EPEC';
    teEPEC                     : Result := 'EPEC';
    teMultiModal               : Result := 'Registro Multimodal';
    teRegistroPassagem         : Result := 'Registro de Passagem';
    teRegistroPassagemNFe      : Result := 'Registro de Passagem NF-e';
    teRegistroPassagemBRId     : Result := 'Registro de Passagem BRId';
    teEncerramento             : Result := 'Encerramento';
    teInclusaoCondutor         : Result := 'Inclusao Condutor';
    teRegistroCTe              : Result := 'CT-e Autorizado para NF-e';
    teRegistroPassagemNFeCancelado: Result := 'Registro de Passagem para NF-e Cancelado';
    teRegistroPassagemNFeRFID  : Result := 'Registro de Passagem para NF-e RFID';
    teCTeAutorizado            : Result := 'CT-e Autorizado';
    teCTeCancelado             : Result := 'CT-e Cancelado';
    teMDFeAutorizado,
    teMDFeAutorizado2          : Result := 'MDF-e Autorizado';
    teMDFeCancelado,
    teMDFeCancelado2           : Result := 'MDF-e Cancelado';
    teVistoriaSuframa          : Result := 'Vistoria SUFRAMA';
    tePedProrrog1,
    tePedProrrog2              : Result := 'Pedido de Prorrogacao';
    teCanPedProrrog1,
    teCanPedProrrog2           : Result := 'Cancelamento de Pedido de Prorrogacao';
    teEventoFiscoPP1,
    teEventoFiscoPP2,
    teEventoFiscoCPP1,
    teEventoFiscoCPP2          : Result := 'Evento Fisco';
    teConfInternalizacao       : Result := 'Confirmacao de Internalizacao da Mercadoria na SUFRAMA';
    teComprEntrega             : Result := 'Comprovante de Entrega do CT-e';
    teComprEntregaNFe          : Result := 'Comprovante de Entrega da NF-e';
    teCancComprEntregaNFe      : Result := 'Cancelamento Comprovante de Entrega da NF-e';
    teAtorInteressadoNFe       : Result := 'Ator interessado na NF-e';
    teInsucessoEntregaNFe      : Result := 'Insucesso na Entrega da NF-e';
    teCancInsucessoEntregaNFe  : Result := 'Cancelamento Insucesso na Entrega da NF-e';
    teConcFinanceira           : Result := 'ECONF';
    teCancConcFinanceira       : Result := ACBrStr('Cancelamento Conciliação Financeira');
    // Reforma Tributária
    teCancGenerico             : Result := 'Cancelamento de Evento';
    tePagIntegLibCredPresAdq   : Result := ACBrStr('Informação de efetivo pagamento integral para liberar crédito presumido do adquirente');
    teImporALCZFM              : Result := ACBrStr('Importação em ALC/ZFM não convertida em isenção');
    tePerecPerdaRouboFurtoTranspContratFornec : Result := ACBrStr('Perecimento, perda, roubo ou furto durante o transporte contratado pelo fornecedor');
    teFornecNaoRealizPagAntec  : Result := ACBrStr('Fornecimento não realizado com pagamento antecipado');
    teSolicApropCredPres       : Result := ACBrStr('Solicitação de Apropriação de crédito presumido');
    teDestItemConsPessoal      : Result := ACBrStr('Destinação de item para consumo pessoal');
    tePerecPerdaRouboFurtoTranspContratAqu : Result := ACBrStr('Perecimento, perda, roubo ou furto durante o transporte contratado pelo adquirente');
    teAceiteDebitoApuracaoNotaCredito : Result := ACBrStr('Aceite de débito na apuração por emissão de nota de crédito');
    teImobilizacaoItem       : Result := ACBrStr('Imobilização de Item');
    teSolicApropCredCombustivel : Result := ACBrStr('Solicitação de Apropriação de Crédito de Combustível');
    teSolicApropCredBensServicos : Result := ACBrStr('Solicitação de Apropriação de Crédito para bens e serviços que dependem de atividade do adquirente');
    teManifPedTransfCredIBSSucessao : Result := '';
    teManifPedTransfCredCBSSucessao : Result := '';
    teAtualizacaoDataPrevisaoEntrega : Result := ACBrStr('Atualização da Data de Previsão de Entrega');
  else
    Result := '';
  end;
end;

function TInfEvento.getTipoEvento: string;
begin
  try
    Result := TpEventoToStr( FTpEvento );
  except
    Result := '';
  end;
end;

function TInfEvento.DescricaoTipoEvento(TipoEvento: TpcnTpEvento): string;
begin
  case TipoEvento of
    teCCe                      : Result := 'CARTA DE CORREÇÃO ELETRÔNICA';
    teCancelamento             : Result := 'CANCELAMENTO DE NF-e';
    teCancSubst                : Result := 'Cancelamento por substituicao';
    teManifDestConfirmacao     : Result := 'CONFIRMAÇÃO DA OPERAÇÃO';
    teManifDestCiencia         : Result := 'CIÊNCIA DA OPERAÇÃO';
    teManifDestDesconhecimento : Result := 'DESCONHECIMENTO DA OPERAÇÃO';
    teManifDestOperNaoRealizada: Result := 'OPERAÇÃO NÃO REALIZADA';
    teEPECNFe                  : Result := 'EPEC';
    teEPEC                     : Result := 'EPEC';
    teMultiModal               : Result := 'REGISTRO MULTIMODAL';
    teRegistroPassagem         : Result := 'REGISTRO DE PASSAGEM';
    teRegistroPassagemNFe      : Result := 'REGISTRO DE PASSAGEM NF-e';
    teRegistroPassagemBRId     : Result := 'REGISTRO DE PASSAGEM BRId';
    teEncerramento             : Result := 'ENCERRAMENTO';
    teInclusaoCondutor         : Result := 'INCLUSAO CONDUTOR';
    teRegistroCTe              : Result := 'CT-e Autorizado para NF-e';
    teRegistroPassagemNFeCancelado: Result := 'Registro de Passagem para NF-e Cancelado';
    teRegistroPassagemNFeRFID  : Result := 'Registro de Passagem para NF-e RFID';
    teCTeAutorizado            : Result := 'CT-e Autorizado';
    teCTeCancelado             : Result := 'CT-e Cancelado';
    teMDFeAutorizado,
    teMDFeAutorizado2          : Result := 'MDF-e Autorizado';
    teMDFeCancelado,
    teMDFeCancelado2           : Result := 'MDF-e Cancelado';
    teVistoriaSuframa          : Result := 'Vistoria SUFRAMA';
    tePedProrrog1,
    tePedProrrog2              : Result := 'Pedido de Prorrogacao';
    teCanPedProrrog1,
    teCanPedProrrog2           : Result := 'Cancelamento de Pedido de Prorrogacao';
    teEventoFiscoPP1,
    teEventoFiscoPP2,
    teEventoFiscoCPP1,
    teEventoFiscoCPP2          : Result := 'Evento Fisco';
    teConfInternalizacao       : Result := 'Confirmacao de Internalizacao da Mercadoria na SUFRAMA';
    teComprEntrega             : Result := 'Comprovante de Entrega do CT-e';
    teComprEntregaNFe          : Result := 'Comprovante de Entrega da NF-e';
    teCancComprEntregaNFe      : Result := 'Cancelamento Comprovante de Entrega da NF-e';
    teAtorInteressadoNFe       : Result := 'Ator interessado na NF-e';
    teInsucessoEntregaNFe      : Result := 'Insucesso na Entrega da NF-e';
    teCancInsucessoEntregaNFe  : Result := 'Cancelamento Insucesso na Entrega da NF-e';
    teConcFinanceira           : Result := 'ECONF';
    teCancConcFinanceira       : Result := 'Cancelamento Conciliação Financeira';

    // Reforma Tributária
    teCancGenerico             : Result := 'Evento de Cancelamento';
    tePagIntegLibCredPresAdq   : Result := 'Informação de efetivo pagamento integral para liberar crédito presumido do adquirente';
    teImporALCZFM              : Result := 'Importação em ALC/ZFM não convertida em isenção';
    tePerecPerdaRouboFurtoTranspContratFornec : Result := 'Perecimento, perda, roubo ou furto durante o transporte contratado pelo fornecedor';
    teFornecNaoRealizPagAntec  : Result := 'Fornecimento não realizado com pagamento antecipado';
    teSolicApropCredPres       : Result := 'Solicitação de Apropriação de crédito presumido';
    teDestItemConsPessoal      : Result := 'Destinação de item para consumo pessoal';
    tePerecPerdaRouboFurtoTranspContratAqu : Result := 'Perecimento, perda, roubo ou furto durante o transporte contratado pelo adquirente';
    teAceiteDebitoApuracaoNotaCredito : Result := 'Aceite de débito na apuração por emissão de nota de crédito';
    teImobilizacaoItem       : Result := 'Imobilização de Item';
    teSolicApropCredCombustivel : Result := 'Solicitação de Apropriação de Crédito de Combustível';
    teSolicApropCredBensServicos : Result := 'Solicitação de Apropriação de Crédito para bens e serviços que dependem de atividade do adquirente';
    teManifPedTransfCredIBSSucessao : Result := '';
    teManifPedTransfCredCBSSucessao : Result := '';
  else
    Result := 'Não Definido';
  end;
end;

{ TDetEvento }

constructor TDetEvento.Create();
begin
  inherited Create;

  Fdest := TDestinatario.Create;
  FitemPedido := TitemPedidoCollection.Create;
  FautXML := TautXMLCollection.Create;
  FdetPag := TdetPagCollection.Create;
  FgCredPres := TgCredPresCollection.Create;
  FgConsumo := TgConsumoCollection.Create;
  FgPerecimento := TgPerecimentoCollection.Create;
  FgImobilizacao := TgImobilizacaoCollection.Create;
  FgConsumoComb := TgConsumoCombCollection.Create;
  FgCredito := TgCreditoCollection.Create;
  FgConsumoZFM := TgConsumoZFMCollection.Create;
  FgPerecimentoForn := TgPerecimentoFornCollection.Create;
  FgItemNaoFornecido := TgItemNaoFornecidoCollection.Create;
end;

destructor TDetEvento.Destroy;
begin
  Fdest.Free;
  FitemPedido.Free;
  FautXML.Free;
  FdetPag.Free;
  FgCredPres.Free;
  FgConsumo.Free;
  FgPerecimento.Free;
  FgImobilizacao.Free;
  FgConsumoComb.Free;
  FgCredito.Free;
  FgConsumoZFM.Free;
  FgPerecimentoForn.Free;
  FgItemNaoFornecido.Free;

  inherited;
end;

procedure TDetEvento.setxCondUso(const Value: string);
begin
  FCondUso := Value;

  if FCondUso = '' then
    FCondUso := 'A Carta de Correcao e disciplinada pelo paragrafo 1o-A do' +
                ' art. 7o do Convenio S/N, de 15 de dezembro de 1970 e' +
                ' pode ser utilizada para regularizacao de erro ocorrido na' +
                ' emissao de documento fiscal, desde que o erro nao esteja' +
                ' relacionado com: I - as variaveis que determinam o valor' +
                ' do imposto tais como: base de calculo, aliquota, diferenca' +
                ' de preco, quantidade, valor da operacao ou da prestacao;' +
                ' II - a correcao de dados cadastrais que implique mudanca' +
                ' do remetente ou do destinatario; III - a data de emissao ou' +
                ' de saida.'
end;

procedure TDetEvento.SetautXML(const Value: TautXMLCollection);
begin
  FautXML := Value;
end;

procedure TDetEvento.SetdetPag(const Value: TdetPagCollection);
begin
  FdetPag := Value;
end;

procedure TDetEvento.SetgConsumo(const Value: TgConsumoCollection);
begin
  FgConsumo := Value;
end;

procedure TDetEvento.SetgConsumoComb(const Value: TgConsumoCombCollection);
begin
 FgConsumoComb := Value;
end;

procedure TDetEvento.SetgCredito(const Value: TgCreditoCollection);
begin
  FgCredito := Value;
end;

procedure TDetEvento.SetgCredPres(const Value: TgCredPresCollection);
begin
  FgCredPres := Value;
end;

procedure TDetEvento.SetgImobilizacao(const Value: TgImobilizacaoCollection);
begin
  FgImobilizacao := Value;
end;

procedure TDetEvento.SetgPerecimento(const Value: TgPerecimentoCollection);
begin
  FgPerecimento := Value;
end;

procedure TDetEvento.SetitemPedido(const Value: TitemPedidoCollection);
begin
  FitemPedido := Value;
end;

procedure TDetEvento.SetIndAceitacao(const Value: TIndAceitacao);
begin
  FIndAceitacao := Value;
end;

{ TRetchNFePendCollection }

function TRetchNFePendCollection.Add: TRetchNFePendCollectionItem;
begin
  Result := Self.New;
end;

function TRetchNFePendCollection.GetItem(
  Index: Integer): TRetchNFePendCollectionItem;
begin
  Result := TRetchNFePendCollectionItem(inherited Items[Index]);
end;

procedure TRetchNFePendCollection.SetItem(Index: Integer;
  Value: TRetchNFePendCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TRetchNFePendCollection.New: TRetchNFePendCollectionItem;
begin
  Result := TRetchNFePendCollectionItem.Create;
  Self.Add(Result);
end;

{ TRetInfEvento }

constructor TRetInfEvento.Create;
begin
  inherited Create;

  FchNFePend := TRetchNFePendCollection.Create();
end;

destructor TRetInfEvento.Destroy;
begin
  FchNFePend.Free;

  inherited;
end;

{ TitemPedidoCollection }

function TitemPedidoCollection.Add: TitemPedidoCollectionItem;
begin
  Result := Self.New;
end;

function TitemPedidoCollection.GetItem(
  Index: Integer): TitemPedidoCollectionItem;
begin
  Result := TitemPedidoCollectionItem(inherited Items[Index]);
end;

procedure TitemPedidoCollection.SetItem(Index: Integer;
  Value: TitemPedidoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TitemPedidoCollection.New: TitemPedidoCollectionItem;
begin
  Result := TitemPedidoCollectionItem.Create;
  Self.Add(Result);
end;

{ TautXMLCollectionItem }

procedure TautXMLCollectionItem.Assign(Source: TautXMLCollectionItem);
begin
  CNPJCPF := Source.CNPJCPF;
end;

{ TautXMLCollection }

function TautXMLCollection.Add: TautXMLCollectionItem;
begin
  Result := Self.New;
end;

function TautXMLCollection.GetItem(Index: Integer): TautXMLCollectionItem;
begin
  Result := TautXMLCollectionItem(inherited Items[Index]);
end;

function TautXMLCollection.New: TautXMLCollectionItem;
begin
  Result := TautXMLCollectionItem.Create;
  Self.Add(Result);
end;

procedure TautXMLCollection.SetItem(Index: Integer;
  Value: TautXMLCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TdetPagCollection }

function TdetPagCollection.Add: TdetPagCollectionItem;
begin
  Result := Self.New;
end;

function TdetPagCollection.GetItem(Index: Integer): TdetPagCollectionItem;
begin
  Result := TdetPagCollectionItem(inherited Items[Index]);
end;

function TdetPagCollection.New: TdetPagCollectionItem;
begin
  Result := TdetPagCollectionItem.Create;
  Self.Add(Result);
end;

procedure TdetPagCollection.SetItem(Index: Integer;
  Value: TdetPagCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TgCredPresCollection }

function TgCredPresCollection.Add: TgCredPresCollectionItem;
begin
  Result := Self.New;
end;

function TgCredPresCollection.GetItem(Index: Integer): TgCredPresCollectionItem;
begin
  Result := TgCredPresCollectionItem(inherited Items[Index]);
end;

function TgCredPresCollection.New: TgCredPresCollectionItem;
begin
  Result := TgCredPresCollectionItem.Create;
  Self.Add(Result);
end;

procedure TgCredPresCollection.SetItem(Index: Integer;
  Value: TgCredPresCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TgCredPresCollectionItem }

constructor TgCredPresCollectionItem.Create;
begin
  inherited Create;

  FgIBS := TgIBSgCBS.Create;
  FgCBS := TgIBSgCBS.Create;
end;

destructor TgCredPresCollectionItem.Destroy;
begin
  FgIBS.Free;
  FgCBS.Free;

  inherited;
end;

{ TgConsumoCollection }

function TgConsumoCollection.Add: TgConsumoCollectionItem;
begin
  Result := Self.New;
end;

function TgConsumoCollection.GetItem(Index: Integer): TgConsumoCollectionItem;
begin
  Result := TgConsumoCollectionItem(inherited Items[Index]);
end;

function TgConsumoCollection.New: TgConsumoCollectionItem;
begin
  Result := TgConsumoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TgConsumoCollection.SetItem(Index: Integer;
  Value: TgConsumoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TgConsumoCollectionItem }

constructor TgConsumoCollectionItem.Create;
begin
  inherited Create;

  FgControleEstoque := TgControleEstoque.Create;
  FDFeReferenciado := TDFeReferenciado.Create;
end;

destructor TgConsumoCollectionItem.Destroy;
begin
  FgControleEstoque.Free;
  FDFeReferenciado.Free;

  inherited;
end;

{ TgPerecimentoCollectionItem }

constructor TgPerecimentoCollectionItem.Create;
begin
 FgControleEstoque := TgControleEstoquePerecimento.Create;
end;

destructor TgPerecimentoCollectionItem.Destroy;
begin
  FgControleEstoque.Free;
  inherited;
end;

{ TgPerecimentoCollection }

function TgPerecimentoCollection.Add: TgPerecimentoCollectionItem;
begin
  Result := Self.New;
end;

function TgPerecimentoCollection.GetItem(
  Index: Integer): TgPerecimentoCollectionItem;
begin
  Result := TgPerecimentoCollectionItem(inherited Items[Index]);
end;

function TgPerecimentoCollection.New: TgPerecimentoCollectionItem;
begin
  Result := TgPerecimentoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TgPerecimentoCollection.SetItem(Index: Integer;
  Value: TgPerecimentoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TgImobilizacaoCollection }

function TgImobilizacaoCollection.Add: TgImobilizacaoCollectionItem;
begin
  Result := Self.New;
end;

function TgImobilizacaoCollection.GetItem(
  Index: Integer): TgImobilizacaoCollectionItem;
begin
  Result := TgImobilizacaoCollectionItem(inherited Items[Index]);
end;

function TgImobilizacaoCollection.New: TgImobilizacaoCollectionItem;
begin
  Result := TgImobilizacaoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TgImobilizacaoCollection.SetItem(Index: Integer;
  Value: TgImobilizacaoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TgImobilizacaoCollectionItem }

constructor TgImobilizacaoCollectionItem.Create;
begin
  FgControleEstoque := TgControleEstoqueImobilizacao.Create;
end;

destructor TgImobilizacaoCollectionItem.Destroy;
begin
  FgControleEstoque.Free;
  inherited;
end;

{ TgConsumoCombCollectionItem }

constructor TgConsumoCombCollectionItem.Create;
begin
  FgControleEstoque := TgControleEstoqueComb.Create;
end;

destructor TgConsumoCombCollectionItem.Destroy;
begin
  FgControleEstoque.Free;
  inherited;
end;

{ TgConsumoCombCollection }

function TgConsumoCombCollection.Add: TgConsumoCombCollectionItem;
begin
  Result := Self.New;
end;

function TgConsumoCombCollection.GetItem(
  Index: Integer): TgConsumoCombCollectionItem;
begin
 Result := TgConsumoCombCollectionItem(inherited Items[Index]);
end;

function TgConsumoCombCollection.New: TgConsumoCombCollectionItem;
begin
  Result := TgConsumoCombCollectionItem.Create;
  Self.Add(Result);
end;

procedure TgConsumoCombCollection.SetItem(Index: Integer;
  Value: TgConsumoCombCollectionItem);
begin
   inherited Items[Index] := Value;
end;

{ TgCreditoCollection }

function TgCreditoCollection.Add: TgCreditoCollectionItem;
begin
  Result := Self.New;
end;

function TgCreditoCollection.GetItem(Index: Integer): TgCreditoCollectionItem;
begin
  Result := TgCreditoCollectionItem(inherited Items[Index]);
end;

function TgCreditoCollection.New: TgCreditoCollectionItem;
begin
  Result := TgCreditoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TgCreditoCollection.SetItem(Index: Integer;
  Value: TgCreditoCollectionItem);
begin
 inherited Items[Index] := Value;
end;

{ TgConsumoZFMCollectionItem }

constructor TgConsumoZFMCollectionItem.Create;
begin
  FgControleEstoqueZFM := TgControleEstoqueZFM.Create;
end;

destructor TgConsumoZFMCollectionItem.Destroy;
begin
  FgControleEstoqueZFM.Free;
  inherited;
end;

{ TgConsumoZFMCollection }

function TgConsumoZFMCollection.Add: TgConsumoZFMCollectionItem;
begin
  Result := Self.New;
end;

function TgConsumoZFMCollection.GetItem(
  Index: Integer): TgConsumoZFMCollectionItem;
begin
  Result := TgConsumoZFMCollectionItem(inherited Items[Index]);
end;

function TgConsumoZFMCollection.New: TgConsumoZFMCollectionItem;
begin
  Result := TgConsumoZFMCollectionItem.Create;
  Self.Add(Result);
end;

procedure TgConsumoZFMCollection.SetItem(Index: Integer;
  Value: TgConsumoZFMCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TgPerecimentoFornCollectionItem }

constructor TgPerecimentoFornCollectionItem.Create;
begin
  FgControleEstoque := TgControleEstoquePerecimentoForn.Create;
end;

destructor TgPerecimentoFornCollectionItem.Destroy;
begin
  FgControleEstoque.Free;
  inherited;
end;

{ TgPerecimentoFornCollection }

function TgPerecimentoFornCollection.Add: TgPerecimentoFornCollectionItem;
begin
  Result := Self.New;
end;

function TgPerecimentoFornCollection.GetItem(
  Index: Integer): TgPerecimentoFornCollectionItem;
begin
  Result := TgPerecimentoFornCollectionItem(inherited Items[Index]);
end;

function TgPerecimentoFornCollection.New: TgPerecimentoFornCollectionItem;
begin
  Result := TgPerecimentoFornCollectionItem.Create;
  Self.Add(Result);
end;

procedure TgPerecimentoFornCollection.SetItem(Index: Integer;
  Value: TgPerecimentoFornCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TgItemNaoFornecidoCollectionItem }

constructor TgItemNaoFornecidoCollectionItem.Create;
begin
  FgControleEstoque := TgControleEstoqueItemNaoFornecido.Create;
end;

destructor TgItemNaoFornecidoCollectionItem.Destroy;
begin
  FgControleEstoque.Free;
  inherited;
end;

{ TgItemNaoFornecidoCollection }

function TgItemNaoFornecidoCollection.Add: TgItemNaoFornecidoCollectionItem;
begin
  Result := Self.New;
end;

function TgItemNaoFornecidoCollection.GetItem(
  Index: Integer): TgItemNaoFornecidoCollectionItem;
begin
  Result := TgItemNaoFornecidoCollectionItem(inherited Items[Index]);
end;

function TgItemNaoFornecidoCollection.New: TgItemNaoFornecidoCollectionItem;
begin
  Result := TgItemNaoFornecidoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TgItemNaoFornecidoCollection.SetItem(Index: Integer;
  Value: TgItemNaoFornecidoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

end.
