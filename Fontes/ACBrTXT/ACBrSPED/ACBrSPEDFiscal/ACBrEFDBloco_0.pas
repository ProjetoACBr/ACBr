{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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

{******************************************************************************
|* Historico
|*
|* 10/04/2009: Isaque Pinheiro
|*  - Cria��o e distribui��o da Primeira Versao
|* 15/03/2010: Alessandro Yamasaki
|*  - Adicionado o REGISTRO 0500: PLANO DE CONTAS CONT�BEIS
|* 13/9/2011: Adolfo Jefferson Fernandes Lopes
|*  - Registro0206.LocalizaRegistro - ANP 
*******************************************************************************}

unit ACBrEFDBloco_0;

{$I ACBr.inc}

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrEFDBlocos;

type
  TRegistro0002 = class;
  TRegistro0005 = class;
  TRegistro0015List = class;
  TRegistro0100 = class;
  TRegistro0150List = class;
  TRegistro0175List = class;
  TRegistro0190List = class;
  TRegistro0200List = class;
  TRegistro0205List = class;
  TRegistro0206List = class;
  TRegistro0210List = class;
  TRegistro0220List = class;
  TRegistro0221List = class;
  TRegistro0300List = class;
  TRegistro0305 = class;
  TRegistro0400List = class;
  TRegistro0450List = class;
  TRegistro0460List = class;
  TRegistro0500List = class;
  TRegistro0600List = class;

  /// Registro 0000 - ABERTURA DO ARQUIVO DIGITAL E IDENTIFICA��O DA ENTIDADE

  TRegistro0000 = class
  private
    fCOD_VER: TACBrVersaoLeiauteSPEDFiscal;        /// C�digo da vers�o do leiaute: 100, 101, 102
    fCOD_FIN: TACBrCodFin;        /// C�digo da finalidade do arquivo: 0 - Remessa do arquivo original / 1 - Remessa do arquivo substituto.
    fDT_INI: TDateTime;           /// Data inicial das informa��es contidas no arquivo
    fDT_FIN: TDateTime;           /// Data final das informa��es contidas no arquivo
    fNOME: String;                /// Nome empresarial do contribuinte:
    fCNPJ: String;                /// N�mero de inscri��o do contribuinte:
    fCPF: String;                 /// N�mero de inscri��o do contribuinte:
    fUF: String;                  /// Sigla da unidade da federa��o:
    fIE: String;                  /// Inscri��o Estadual do contribuinte:
    fCOD_MUN: integer;            /// C�digo do munic�pio do domic�lio fiscal:
    fIM: String;                  /// Inscri��o Municipal do contribuinte:
    fSUFRAMA: String;             /// N�mero de inscri��o do contribuinte:
    fIND_PERFIL: TACBrPerfil;     /// Perfil de apresenta��o do arquivo fiscal: A - Perfil A / B - Perfil B / C - Perfil C
    fIND_ATIV: TACBrIndAtiv;      /// Indicador de tipo de atividade: 0 - Industrial ou equiparado a industrial; 1 - Outros.
  public
    property COD_VER: TACBrVersaoLeiauteSPEDFiscal read FCOD_VER write FCOD_VER;
    property COD_FIN: TACBrCodFin read FCOD_FIN write FCOD_FIN;
    property DT_INI: TDateTime read FDT_INI write FDT_INI;
    property DT_FIN: TDateTime read FDT_FIN write FDT_FIN;
    property NOME: String read FNOME write FNOME;
    property CNPJ: String read FCNPJ write FCNPJ;
    property CPF: String read FCPF write FCPF;
    property UF: String read FUF write FUF;
    property IE: String read FIE write FIE;
    property COD_MUN: integer read FCOD_MUN write FCOD_MUN;
    property IM: String read FIM write FIM;
    property SUFRAMA: String read FSUFRAMA write FSUFRAMA;
    property IND_PERFIL: TACBrPerfil read FIND_PERFIL write FIND_PERFIL;
    property IND_ATIV: TACBrIndAtiv read FIND_ATIV write FIND_ATIV;
  end;

  /// Registro 0001 - ABERTURA DO BLOCO 0

  TRegistro0001 = class(TOpenBlocos)
  private
    FRegistro0190: TRegistro0190List;
    FRegistro0200: TRegistro0200List;
    FRegistro0100: TRegistro0100;
    FRegistro0005: TRegistro0005;
    FRegistro0150: TRegistro0150List;
    FRegistro0015: TRegistro0015List;
    FRegistro0300: TRegistro0300List;
    FRegistro0600: TRegistro0600List;
    FRegistro0400: TRegistro0400List;
    FRegistro0500: TRegistro0500List;
    FRegistro0460: TRegistro0460List;
    FRegistro0450: TRegistro0450List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property Registro0005: TRegistro0005     read FRegistro0005 write FRegistro0005;
    property Registro0015: TRegistro0015List read FRegistro0015 write FRegistro0015;
    property Registro0100: TRegistro0100     read FRegistro0100 write FRegistro0100;
    property Registro0150: TRegistro0150List read FRegistro0150 write FRegistro0150;
    property Registro0190: TRegistro0190List read FRegistro0190 write FRegistro0190;
    property Registro0200: TRegistro0200List read FRegistro0200 write FRegistro0200;
    property Registro0300: TRegistro0300List read FRegistro0300 write FRegistro0300;
    property Registro0400: TRegistro0400List read FRegistro0400 write FRegistro0400;
    property Registro0450: TRegistro0450List read FRegistro0450 write FRegistro0450;
    property Registro0460: TRegistro0460List read FRegistro0460 write FRegistro0460;
    property Registro0500: TRegistro0500List read FRegistro0500 write FRegistro0500;
    property Registro0600: TRegistro0600List read FRegistro0600 write FRegistro0600;
  end;

  /// REGISTRO 0002: CLASSIFICA��O DO ESTABELECIMENTO INDUSTRIAL OU EQUIPARADO A INDUSTRIAL

   TRegistro0002 = class

  private
    fCLAS_ESTAB_IND: string;  ///Informar a classifica��o do estabelecimento conforme tabela 4.5.5
  public
    property CLAS_ESTAB_IND: string read fCLAS_ESTAB_IND write fCLAS_ESTAB_IND;
  end;

  /// Registro 0005 - DADOS COMPLEMENTARES DA ENTIDADE

  TRegistro0005 = class
  private
    fFANTASIA: String;     /// Nome de fantasia associado:
    fCEP: String;          /// C�digo de Endere�amento Postal:
    fENDERECO: String;     /// Logradouro e endere�o do im�vel:
    fNUM: String;          /// N�mero do im�vel:
    fCOMPL: String;        /// Dados complementares do endere�o:
    fBAIRRO: String;       /// Bairro em que o im�vel est� situado:
    fFONE: String;         /// N�mero do telefone:
    fFAX: String;          /// N�mero do fax:
    fEMAIL: String;        /// Endere�o do correio eletr�nico:
  public
    property FANTASIA: String read fFANTASIA write fFANTASIA;
    property CEP: String read FCEP write FCEP;
    property ENDERECO: String read FENDERECO write FENDERECO;
    property NUM: String read FNUM write FNUM;
    property COMPL: String read FCOMPL write FCOMPL;
    property BAIRRO: String read FBAIRRO write FBAIRRO;
    property FONE: String read FFONE write FFONE;
    property FAX: String read FFAX write FFAX;
    property EMAIL: String read FEMAIL write FEMAIL;
  end;

  /// Registro 0015 - DADOS DO CONTRIBUINTE SUBSTITUTO

  TRegistro0015 = class
  private
    fUF_ST: String;   /// Sigla da unidade da federa��o:
    fIE_ST: String;   /// Inscri��o Estadual:
  public
    property UF_ST: String read FUF_ST write FUF_ST;
    property IE_ST: String read FIE_ST write FIE_ST;
  end;

  /// Registro 0015 - Lista

  TRegistro0015List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0015;
    procedure SetItem(Index: Integer; const Value: TRegistro0015);
  public
    function New: TRegistro0015;
    property Items[Index: Integer]: TRegistro0015 read GetItem write SetItem;
  end;

  /// Registro 0100 - DADOS DO CONTABILISTA

  TRegistro0100 = class
  private
    fNOME: String;        /// Nome do contabilista/escrit�rio:
    fCPF: String;         /// N�mero de inscri��o no CPF:
    fCRC: String;         /// N�mero de inscri��o no Conselho Regional:
    fCNPJ: String;        /// CNPJ do escrit�rio de contabilidade, se houver:
    fCEP: String;         /// C�digo de Endere�amento Postal:
    fENDERECO: String;    /// Logradouro e endere�o do im�vel:
    fNUM: String;         /// N�mero do im�vel:
    fCOMPL: String;       /// Dados complementares do endere�o:
    fBAIRRO: String;      /// Bairro em que o im�vel est� situado:
    fFONE: String;        /// N�mero do telefone:
    fFAX: String;         /// N�mero do fax:
    fEMAIL: String;       /// Endere�o do correio eletr�nico:
    fCOD_MUN: integer;        /// C�digo do munic�pio, conforme tabela IBGE:
  public
    property NOME: String read FNOME write FNOME;
    property CPF: String read FCPF write FCPF;
    property CRC: String read FCRC write FCRC;
    property CNPJ: String read FCNPJ write FCNPJ;
    property CEP: String read FCEP write FCEP;
    property ENDERECO: String read FENDERECO write FENDERECO;
    property NUM: String read FNUM write FNUM;
    property COMPL: String read FCOMPL write FCOMPL;
    property BAIRRO: String read FBAIRRO write FBAIRRO;
    property FONE: String read FFONE write FFONE;
    property FAX: String read FFAX write FFAX;
    property EMAIL: String read FEMAIL write FEMAIL;
    property COD_MUN: integer read FCOD_MUN write FCOD_MUN;
  end;

  /// Registro 0150 - TABELA DE CADASTRO DO PARTICIPANTE

  TRegistro0150 = class
  private
    fCOD_PART: String;    /// C�digo de identifica��o do participante:
    fNOME: String;        /// Nome pessoal ou empresarial:
    fCOD_PAIS: String;    /// C�digo do pa�s do participante:
    fCNPJ: String;        /// CNPJ do participante:
    fCPF: String;         /// CPF do participante na unidade da federa��o do destinat�rio:
    fIE: String;          /// Inscri��o Estadual do participante:
    fCOD_MUN: integer;        /// C�digo do munic�pio:
    fSUFRAMA: String;     /// N�mero de inscri��o na Suframa:
    fENDERECO: String;    /// Logradouro e endere�o do im�vel:
    fNUM: String;         /// N�mero do im�vel:
    fCOMPL: String;       /// Dados complementares do endere�o:
    fBAIRRO: String;      /// Bairro em que o im�vel est� situado:

    FRegistro0175: TRegistro0175List;  /// BLOCO C - Lista de Registro0175 (FILHO)
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_PART: String read FCOD_PART write FCOD_PART;
    property NOME: String read FNOME write FNOME;
    property COD_PAIS: String read FCOD_PAIS write FCOD_PAIS;
    property CNPJ: String read FCNPJ write FCNPJ;
    property CPF: String read FCPF write FCPF;
    property IE: String read FIE write FIE;
    property COD_MUN: integer read FCOD_MUN write FCOD_MUN;
    property SUFRAMA: String read FSUFRAMA write FSUFRAMA;
    property ENDERECO: String read FENDERECO write FENDERECO;
    property NUM: String read FNUM write FNUM;
    property COMPL: String read FCOMPL write FCOMPL;
    property BAIRRO: String read FBAIRRO write FBAIRRO;
    /// Registros FILHOS
    property Registro0175: TRegistro0175List read FRegistro0175 write FRegistro0175;
  end;

  /// Registro 0150 - Lista

  TRegistro0150List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0150;
    procedure SetItem(Index: Integer; const Value: TRegistro0150);
  public
    function New(): TRegistro0150;
    function LocalizaRegistro(const Value: String): boolean;
    property Items[Index: Integer]: TRegistro0150 read GetItem write SetItem;
  end;

  /// Registro 0175 - ALTERA��O DA TABELA DE CADASTRO DE PARTICIPANTE

  TRegistro0175 = class
  private
    fDT_ALT: TDateTime;      /// Data de altera��o do cadastro:
    fNR_CAMPO: String;       /// N�mero do campo alterado (Somente campos 03 a 13):
    fCONT_ANT: String;       /// Conte�do anterior do campo:
  public
    property DT_ALT: TDateTime read FDT_ALT write FDT_ALT;
    property NR_CAMPO: String read FNR_CAMPO write FNR_CAMPO;
    property CONT_ANT: String read FCONT_ANT write FCONT_ANT;
  end;

  /// Registro 0175 - Lista

  TRegistro0175List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0175;
    procedure SetItem(Index: Integer; const Value: TRegistro0175);
  public
    function New: TRegistro0175;
    property Items[Index: Integer]: TRegistro0175 read GetItem write SetItem;
  end;

  /// Registro 0190 - IDENTIFICA��O DAS UNIDADES DE MEDIDA

  TRegistro0190 = class
  private
    fUNID: String;        /// C�digo da unidade de medida:
    fDESCR: String;       /// Descri��o da unidade de medida:
  public
    property UNID: String read FUNID write FUNID;
    property DESCR: String read FDESCR write FDESCR;
  end;

  /// Registro 0190 - Lista

  TRegistro0190List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0190;
    procedure SetItem(Index: Integer; const Value: TRegistro0190);
  public
    function New: TRegistro0190;
    function LocalizaRegistro(const pUNID: String): boolean;
    property Items[Index: Integer]: TRegistro0190 read GetItem write SetItem;
  end;

  /// Registro 0200 - TABELA DE IDENTIFICA��O DO ITEM (PRODUTO E SERVI�OS)

  { TRegistro0200 }

  TRegistro0200 = class
  private
    fCOD_ITEM: String;         /// C�digo do item:
    fDESCR_ITEM: String;       /// Descri��o do item:
    fCOD_BARRA: String;        /// C�digo de barra do produto, se houver:
    fCOD_ANT_ITEM: String;     /// C�digo anterior do item (ultima apresentado):
    fUNID_INV: String;         /// Unidade de medida do estoque:
    fTIPO_ITEM: TACBrTipoItem; /// Tipo do item - Atividades Industriais, Comerciais e Servi�os: 00 - Mercadoria para Revenda, 01 - Mat�ria-Prima,  02 - Embalagem, 03 - Produto em Processo, 04 - Produto Acabado, 05 - Subproduto, 06 - Produto Intermedi�rio, 07 - Material de Uso e Consumo, 08 - Ativo Imobilizado, 09 - Servi�os, 10 - Outros insumos, 99 - Outras
    fCOD_NCM: String;          /// C�digo da Nomenclatura Comum do Mercosul:
    fEX_IPI: String;           /// C�digo EX, conforme a TIPI:
    fCOD_GEN: String;          /// C�digo g�nero item, tabela indicada item 4.2.1:
    fCOD_LST: String;          /// C�digo servi�o Anexo I - Lei n�116/03:
    fALIQ_ICMS: Variant;      /// Al�quota ICMS aplic�vel (opera��es internas):
		FCEST : string;

    FRegistro0205: TRegistro0205List;  /// BLOCO 0 - Lista de Registro0205 (FILHO)
    FRegistro0206: TRegistro0206List;  /// BLOCO 0 - Lista de Registro0206 (FILHO)
    FRegistro0210: TRegistro0210List;
    FRegistro0220: TRegistro0220List;  /// BLOCO 0 - Lista de Registro0220 (FILHO)
    FRegistro0221: TRegistro0221List;  /// BLOCO 0 - Lista de Registro0221 (FILHO)
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_ITEM: String read FCOD_ITEM write FCOD_ITEM;
    property DESCR_ITEM: String read FDESCR_ITEM write FDESCR_ITEM;
    property COD_BARRA: String read FCOD_BARRA write FCOD_BARRA;
    property COD_ANT_ITEM: String read FCOD_ANT_ITEM write FCOD_ANT_ITEM;
    property UNID_INV: String read FUNID_INV write FUNID_INV;
    property TIPO_ITEM: TACBrTipoItem read FTIPO_ITEM write FTIPO_ITEM;
    property COD_NCM: String read FCOD_NCM write FCOD_NCM;
    property EX_IPI: String read FEX_IPI write FEX_IPI;
    property COD_GEN: String read FCOD_GEN write FCOD_GEN;
    property COD_LST: String read FCOD_LST write FCOD_LST;
    property ALIQ_ICMS: Variant read FALIQ_ICMS write FALIQ_ICMS;
		property CEST : String read FCEST write FCEST;
    /// Registros FILHOS
    property Registro0205: TRegistro0205List read FRegistro0205 write FRegistro0205;
    property Registro0206: TRegistro0206List read FRegistro0206 write FRegistro0206;
    property Registro0210: TRegistro0210List read FRegistro0210 write FRegistro0210;
    property Registro0220: TRegistro0220List read FRegistro0220 write FRegistro0220;
    property Registro0221: TRegistro0221List read FRegistro0221 write FRegistro0221;
  end;

  /// Registro 0200 - Lista

  TRegistro0200List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0200;
    procedure SetItem(Index: Integer; const Value: TRegistro0200);
  public
    function New(): TRegistro0200;
    function LocalizaRegistro(const pCOD_ITEM: String): boolean;
    property Items[Index: Integer]: TRegistro0200 read GetItem write SetItem;
  end;

  /// Registro 0205 - C�DIGO ANTERIOR DO ITEM

  TRegistro0205 = class
  private
    fDESCR_ANT_ITEM: String;    /// Descri��o anterior do item:
    fDT_INI: TDateTime;         /// Data inicial de utiliza��o do c�digo:
    fDT_FIN: TDateTime;         /// Data final de utiliza��o do c�digo:
    fCOD_ANT_ITEM: string;      /// C�digo anterior do item com rela��o � �ltima informa��o apresentada.
  public
    property DESCR_ANT_ITEM: String read FDESCR_ANT_ITEM write FDESCR_ANT_ITEM;
    property DT_INI: TDateTime read FDT_INI write FDT_INI;
    property DT_FIN: TDateTime read FDT_FIN write FDT_FIN;
    property COD_ANT_ITEM: String read FCOD_ANT_ITEM write FCOD_ANT_ITEM;
  end;

  /// Registro 0205 - Lista

  TRegistro0205List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0205;
    procedure SetItem(Index: Integer; const Value: TRegistro0205);
  public
    function New: TRegistro0205;
    property Items[Index: Integer]: TRegistro0205 read GetItem write SetItem;
  end;

  /// Registro 0206 - C�DIGO DE PRODUTO CONFORME TABELA ANP (COMBUST�VEIS)

  TRegistro0206 = class
  private
    fCOD_COMB: String;       /// C�digo do combust�vel, conforme tabela publicada pela ANP:
  public
    property COD_COMB: String read FCOD_COMB write FCOD_COMB;
  end;

  /// Registro 0206 - Lista

  TRegistro0206List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0206;
    procedure SetItem(Index: Integer; const Value: TRegistro0206);
  public
    function New: TRegistro0206;
    function LocalizaRegistro(const pCOD_COMB: string): boolean;{:ANP - Localiza :AJ-13/9/2011 05:34:36:}
    property Items[Index: Integer]: TRegistro0206 read GetItem write SetItem;
  end;

  /// Registro 0210 - CONSUMO ESPECIFICO PADRONIZADO

  { TRegistro0210 }

  TRegistro0210 = class
  private
    fCOD_ITEM_COMP: string;
    fPERDA: Double;
    fQTD_COMP: Double;
  public
    property COD_ITEM_COMP: string read fCOD_ITEM_COMP write fCOD_ITEM_COMP;
    property QTD_COMP : Double read fQTD_COMP write fQTD_COMP;
    property PERDA: Double read fPERDA write fPERDA;
  end;

  /// Registro 0210 - Lista

  { TRegistro0210List }

  TRegistro0210List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0210;
    procedure SetItem(Index: Integer; const Value: TRegistro0210);
  public
    function New: TRegistro0210;
    property Items[Index: Integer]: TRegistro0210 read GetItem write SetItem;
  end;

  /// Registro 0220 - FATORES DE CONVERS�O DE UNIDADES

  TRegistro0220 = class
  private
    fUNID_CONV: String;  /// Unidade comercial a ser convertida na unidade de estoque, referida em 0200:
    fFAT_CONV: Double;   /// Fator de convers�o:
    FCOD_BARRA: string;  ///   Representa��o alfanum�rica do c�digo de barra da unidade comercial do produto, se houver
  public
    property UNID_CONV: String read FUNID_CONV write FUNID_CONV;
    property FAT_CONV: Double read FFAT_CONV write FFAT_CONV;
    property COD_BARRA: string read FCOD_BARRA write FCOD_BARRA;
  end;

  /// Registro 0220 - Lista

  TRegistro0220List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0220;
    procedure SetItem(Index: Integer; const Value: TRegistro0220);
  public
    function New: TRegistro0220;
    property Items[Index: Integer]: TRegistro0220 read GetItem write SetItem;
  end;

  { TRegistro0221 - CORRELA��O ENTRE C�DIGOS DE ITENS COMERCIALIZADOS }

  TRegistro0221 = class
  private
    fCOD_ITEM_ATOMICO: String;  /// Informar o c�digo do item at�mico contido no item informado no 0200 Pai.
    fQTDE_CONTIDA: Double;      /// Informar quantos itens at�micos est�o contidos no item informado no 0200 Pai.
  public
    property COD_ITEM_ATOMICO: String read fCOD_ITEM_ATOMICO write fCOD_ITEM_ATOMICO;
    property QTDE_CONTIDA: Double read fQTDE_CONTIDA write fQTDE_CONTIDA;
  end;

  { TRegistro0221List }

  TRegistro0221List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0221;
    procedure SetItem(Index: Integer; const Value: TRegistro0221);
  public
    function New: TRegistro0221; overload;
    property Items[Index: Integer]: TRegistro0221 read GetItem write SetItem;
  end;

  /// Registro 0300 - CADASTRO DE BENS OU COMPONENTES DO ATIVO IMOBILIZADO

  TRegistro0300 = class
  private
    FCOD_IND_BEM: String;    /// C�digo individualizado do bem ou componente adotado no controle patrimonial do estabelecimento informante
    FIDENT_MERC: Integer;    /// Identifica��o do tipo de mercadoria: 1 = bem; 2 = componente.
    FDESCR_ITEM: String;     /// Descri��o do bem ou componente (modelo, marca e outras caracter�sticas necess�rias a sua individualiza��o)
    FCOD_PRNC: String;       /// C�digo de cadastro do bem principal nos casos em que o bem ou componente ( campo 02) esteja vinculado a um bem principal.
    FCOD_CTA: String;        /// C�digo da conta anal�tica de contabiliza��o do bem ou componente (campo 06 do Registro 0500)
    FNR_PARC: Double;        /// N�mero total de parcelas a serem apropriadas, segundo a legisla��o de cada unidade federada

    FRegistro0305: TRegistro0305; /// BLOCO 0 - Registro0305 (FILHO)
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_IND_BEM: String read FCOD_IND_BEM write FCOD_IND_BEM;
    property IDENT_MERC: Integer read FIDENT_MERC  write FIDENT_MERC;
    property DESCR_ITEM: String  read FDESCR_ITEM  write FDESCR_ITEM;
    property COD_PRNC: String    read FCOD_PRNC    write FCOD_PRNC;
    property COD_CTA: String     read FCOD_CTA     write FCOD_CTA;
    property NR_PARC: Double     read FNR_PARC     write FNR_PARC;
    /// Registros FILHOS
    property Registro0305: TRegistro0305 read FRegistro0305 write FRegistro0305;
  end;

  /// Registro 0300 - Lista

  TRegistro0300List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0300;
    procedure SetItem(Index: Integer; const Value: TRegistro0300);
  public
    function New(): TRegistro0300;
    function LocalizaRegistro(const pCOD_IND_BEM: String): boolean;
    property Items[Index: Integer]: TRegistro0300 read GetItem write SetItem;
  end;

  /// Registro 0305 - INFORMA��O SOBRE A UTILIZA��O DO BEM

  TRegistro0305 = class
  private
    FCOD_CCUS: string; /// C�digo do centro de custo onde o bem est� sendo ou ser� utilizado (campo 03 do Registro 0600)
    FFUNC: string;      /// Descri��o sucinta da fun��o do bem na atividade do estabelecimento
    FVIDA_UTIL: Integer; /// Vida �til estimada do bem, em n�mero de meses
  public
    property COD_CCUS: String   read FCOD_CCUS  write FCOD_CCUS;
    property FUNC: String       read FFUNC      write FFUNC;
    property VIDA_UTIL: Integer read FVIDA_UTIL write FVIDA_UTIL;
  end;

  /// Registro 0400 - TABELA DE NATUREZA DA OPERA��O/PRESTA��O

  TRegistro0400 = class
  private
    fCOD_NAT: String;        /// C�digo da natureza:
    fDESCR_NAT: String;      /// Descri��o da natureza:
  public
    property COD_NAT: String read FCOD_NAT write FCOD_NAT;
    property DESCR_NAT: String read FDESCR_NAT write FDESCR_NAT;
  end;
  /// Registro 0400 - Lista

  TRegistro0400List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0400;
    procedure SetItem(Index: Integer; const Value: TRegistro0400);
  public
    function New: TRegistro0400;
    function LocalizaRegistro(const pCOD_NAT: String): boolean;
    property Items[Index: Integer]: TRegistro0400 read GetItem write SetItem;
  end;

  /// Registro 0450 - TABELA DE INFORMA��O COMPLEMENTAR/OBSERVA��O

  TRegistro0450 = class
  private
    fCOD_INF: String;     /// C�digo da informa��o complementar do documento fiscal:
    fTXT: String;         /// Texto livre:
  public
    property COD_INF: String read FCOD_INF write FCOD_INF;
    property TXT: String read FTXT write FTXT;
  end;

  /// Registro 0450 - Lista

  TRegistro0450List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0450;
    procedure SetItem(Index: Integer; const Value: TRegistro0450);
  public
    function New: TRegistro0450;
    function LocalizaRegistro(const pCOD_INF :string): Boolean; overload;
    function LocalizaRegistro(const AValue : string; ABuscaTxt : Boolean): String; overload;
    property Items[Index: Integer]: TRegistro0450 read GetItem write SetItem;
  end;

  /// Registro 0460 - TABELA DE OBSERVA��ES DO LAN�AMENTO FISCAL

  TRegistro0460 = class
  private
    fCOD_OBS: String;     /// C�digo da Observa��o do lan�amento fiscal:
    fTXT: String;         /// Descri��o da observa��o vinculada ao lan�amento fiscal:
  public
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
    property TXT: String read FTXT write FTXT;
  end;

  /// Registro 0460 - Lista

  TRegistro0460List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0460;
    procedure SetItem(Index: Integer; const Value: TRegistro0460);
  public
    function New: TRegistro0460;
    function LocalizaRegistro(const pCOD_OBS: String): boolean; overload;
    function LocalizaRegistro(const AValue : String; ABuscaTxt : Boolean): String; overload;
    property Items[Index: Integer]: TRegistro0460 read GetItem write SetItem;
  end;

  /// Registro 0500 - TABELA DE PLANO DE CONTAS CONT�BEIS
  TRegistro0500 = class
  private
    fDT_ALT     : TDateTime;        // Data da inclus�o/altera��o
    fCOD_NAT_CC : String;       // C�digo da natureza da conta/grupo de contas
    fIND_CTA    : String;       // Indicador do tipo de conta:  S - Sint�tica ou A - Anal�tica
    fNIVEL      : String;       // N�vel da conta anal�tica/grupo de contas
    fCOD_CTA    : String;       // C�digo da conta anal�tica/grupo de conta
    fNOME_CTA   : String;       // Nome da conta anal�tica/grupo de contas
  public
    property DT_ALT: TDateTime read FDT_ALT write FDT_ALT;
    property COD_NAT_CC: String read FCOD_NAT_CC write FCOD_NAT_CC;
    property IND_CTA: String read FIND_CTA write FIND_CTA;
    property NIVEL: String read FNIVEL write FNIVEL;
    property COD_CTA: String read FCOD_CTA write FCOD_CTA;
    property NOME_CTA: String read FNOME_CTA write FNOME_CTA;
  end;

  /// Registro 0500 - Lista
  TRegistro0500List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0500;
    procedure SetItem(Index: Integer; const Value: TRegistro0500);
  public
    function New: TRegistro0500;
    property Items[Index: Integer]: TRegistro0500 read GetItem write SetItem;
  end;

  /// Registro 0600 - CENTRO DE CUSTOS
  TRegistro0600 = class
  private
    fDT_ALT     : TDateTime;        // Data da inclus�o/altera��o
    fCOD_CCUS   : String;       // C�digo do centro de custos.
    fCCUS       : String;       // Nome do centro de custos.
  public
    property DT_ALT: TDateTime read FDT_ALT write FDT_ALT;
    property COD_CCUS: String read FCOD_CCUS write FCOD_CCUS;
    property CCUS: String read FCCUS write FCCUS;
  end;

  /// Registro 0600 - Lista
  TRegistro0600List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0600;
    procedure SetItem(Index: Integer; const Value: TRegistro0600);
  public
    function New: TRegistro0600;
    property Items[Index: Integer]: TRegistro0600 read GetItem write SetItem;
  end;

  /// Registro 0990 - ENCERRAMENTO DO BLOCO 0

  TRegistro0990 = class
  private
    fQTD_LIN_0: Integer; /// Quantidade total de linhas do Bloco 0
  public
    property QTD_LIN_0: Integer read fQTD_LIN_0 write fQTD_LIN_0;
  end;

implementation


{ TRegistro0001 }

constructor TRegistro0001.Create;
begin
  inherited Create;
  FRegistro0190 := TRegistro0190List.Create;
  FRegistro0200 := TRegistro0200List.Create;
  FRegistro0100 := TRegistro0100.Create;
  FRegistro0005 := TRegistro0005.Create;
  FRegistro0150 := TRegistro0150List.Create;
  FRegistro0015 := TRegistro0015List.Create;
  FRegistro0300 := TRegistro0300List.Create;
  FRegistro0600 := TRegistro0600List.Create;
  FRegistro0400 := TRegistro0400List.Create;
  FRegistro0500 := TRegistro0500List.Create;
  FRegistro0460 := TRegistro0460List.Create;
  FRegistro0450 := TRegistro0450List.Create;
  //
  IND_MOV := imSemDados;
end;

destructor TRegistro0001.Destroy;
begin
  FRegistro0190.Free;
  FRegistro0200.Free;
  FRegistro0100.Free;
  FRegistro0005.Free;
  FRegistro0150.Free;
  FRegistro0015.Free;
  FRegistro0300.Free;
  FRegistro0600.Free;
  FRegistro0400.Free;
  FRegistro0500.Free;
  FRegistro0460.Free;
  FRegistro0450.Free;
  inherited;
end;

{* TRegistro0015List *}

function TRegistro0015List.GetItem(Index: Integer): TRegistro0015;
begin
  Result := TRegistro0015(Inherited GetItem(Index));
end;

function TRegistro0015List.New: TRegistro0015;
begin
  Result := TRegistro0015.Create;
  Add(Result);
end;

procedure TRegistro0015List.SetItem(Index: Integer; const Value: TRegistro0015);
begin
  Put(Index, Value);
end;

{ TRegistro0150List }

function TRegistro0150List.GetItem(Index: Integer): TRegistro0150;
begin
  Result := TRegistro0150(Inherited GetItem(Index));
end;

function TRegistro0150List.LocalizaRegistro(const Value: String): boolean;
var
intFor: integer;
begin
   Result := false;
   for intFor := 0 to Self.Count - 1 do
   begin
      if Length(Value) = 14 then
      begin
         if Self.Items[intFor].CNPJ = Value then
         begin
            Result := true;
            Break;
         end;
      end
      else
      if Length(Value) = 11 then
      begin
         if Self.Items[intFor].CPF = Value then
         begin
            Result := true;
            Break;
         end;
      end
      else
      begin
         if Self.Items[intFor].COD_PART = Value then
         begin
            Result := true;
            Break;
         end;
      end
   end;
end;

function TRegistro0150List.New(): TRegistro0150;
begin
  Result := TRegistro0150.Create();
  Add(Result);
end;

procedure TRegistro0150List.SetItem(Index: Integer; const Value: TRegistro0150);
begin
  Put(Index, Value);
end;

{ TRegistro0175List }

function TRegistro0175List.GetItem(Index: Integer): TRegistro0175;
begin
  Result := TRegistro0175(Inherited GetItem(Index));
end;

function TRegistro0175List.New: TRegistro0175;
begin
  Result := TRegistro0175.Create;
  Add(Result);
end;

procedure TRegistro0175List.SetItem(Index: Integer; const Value: TRegistro0175);
begin
  Put(Index, Value);
end;

{ TRegistro0190List }

function TRegistro0190List.GetItem(Index: Integer): TRegistro0190;
begin
  Result := TRegistro0190(Inherited GetItem(Index));
end;

function TRegistro0190List.LocalizaRegistro(const pUNID: String): boolean;
var
intFor: integer;
begin
   Result := false;
   for intFor := 0 to Self.Count - 1 do
   begin
      if Self.Items[intFor].UNID = pUNID then
      begin
         Result := true;
         Break;
      end;
   end;
end;

function TRegistro0190List.New: TRegistro0190;
begin
  Result := TRegistro0190.Create;
  Add(Result);
end;

procedure TRegistro0190List.SetItem(Index: Integer; const Value: TRegistro0190);
begin
  Put(Index, Value);
end;

{ TRegistro0200List }

function TRegistro0200List.GetItem(Index: Integer): TRegistro0200;
begin
  Result := TRegistro0200(Inherited GetItem(Index));
end;

function TRegistro0200List.LocalizaRegistro(const pCOD_ITEM: String): boolean;
var
intFor: integer;
begin
   Result := false;
   for intFor := 0 to Self.Count - 1 do
   begin
      if Self.Items[intFor].COD_ITEM = pCOD_ITEM then
      begin
         Result := true;
         Break;
      end;
   end;
end;

function TRegistro0200List.New(): TRegistro0200;
begin
  Result := TRegistro0200.Create();
  Add(Result);
end;

procedure TRegistro0200List.SetItem(Index: Integer; const Value: TRegistro0200);
begin
  Put(Index, Value);
end;

{ TRegistro0205List }

function TRegistro0205List.GetItem(Index: Integer): TRegistro0205;
begin
  Result := TRegistro0205(Inherited GetItem(Index));
end;

function TRegistro0205List.New: TRegistro0205;
begin
  Result := TRegistro0205.Create;
  Add(Result);
end;

procedure TRegistro0205List.SetItem(Index: Integer; const Value: TRegistro0205);
begin
  Put(Index, Value);
end;

{ TRegistro0206List }

function TRegistro0206List.GetItem(Index: Integer): TRegistro0206;
begin
  Result := TRegistro0206(Inherited GetItem(Index));
end;

function TRegistro0206List.LocalizaRegistro(const pCOD_COMB: string): boolean;
{:ANP - Localiza :AJ-13/9/2011 05:33:04:}
var
  intFor: integer;
begin
  Result := false;
  for intFor := 0 to Self.Count - 1 do
  begin
    if Self.Items[intFor].COD_COMB = pCOD_COMB then
    begin
      Result := true;
      Break;
    end;
  end;
end;

function TRegistro0206List.New: TRegistro0206;
begin
  Result := TRegistro0206.Create;
  Add(Result);
end;

procedure TRegistro0206List.SetItem(Index: Integer; const Value: TRegistro0206);
begin
  Put(Index, Value);
end;

{ TRegistro0210List }

function TRegistro0210List.GetItem(Index: Integer): TRegistro0210;
begin
  Result := TRegistro0210(Inherited GetItem(Index));
end;

procedure TRegistro0210List.SetItem(Index: Integer; const Value: TRegistro0210);
begin
  Put(Index, Value);
end;

function TRegistro0210List.New: TRegistro0210;
begin
  Result := TRegistro0210.Create;
  Add(Result);
end;

{ TRegistro0220List }

function TRegistro0220List.GetItem(Index: Integer): TRegistro0220;
begin
  Result := TRegistro0220(Inherited GetItem(Index));
end;

function TRegistro0220List.New: TRegistro0220;
begin
  Result := TRegistro0220.Create;
  Add(Result);
end;

procedure TRegistro0220List.SetItem(Index: Integer; const Value: TRegistro0220);
begin
  Put(Index, Value);
end;

{ TRegistro0221List }

function TRegistro0221List.GetItem(Index: Integer): TRegistro0221;
begin
  Result := TRegistro0221(Inherited GetItem(Index));
end;

function TRegistro0221List.New: TRegistro0221;
begin
  Result := TRegistro0221.Create;
  Add(Result);
end;

procedure TRegistro0221List.SetItem(Index: Integer; const Value: TRegistro0221);
begin
  Put(Index, Value);
end;

{ TRegistro0400List }

function TRegistro0400List.GetItem(Index: Integer): TRegistro0400;
begin
  Result := TRegistro0400(Inherited GetItem(Index));
end;

function TRegistro0400List.LocalizaRegistro(const pCOD_NAT: String): boolean;
var
intFor: integer;
begin
   Result := false;
   for intFor := 0 to Self.Count - 1 do
   begin
      if Self.Items[intFor].COD_NAT = pCOD_NAT then
      begin
         Result := true;
         Break;
      end;
   end;
end;

function TRegistro0400List.New: TRegistro0400;
begin
  Result := TRegistro0400.Create;
  Add(Result);
end;

procedure TRegistro0400List.SetItem(Index: Integer; const Value: TRegistro0400);
begin
  Put(Index, Value);
end;

{ TRegistro0450List }

function TRegistro0450List.GetItem(Index: Integer): TRegistro0450;
begin
  Result := TRegistro0450(Inherited GetItem(Index));
end;

function TRegistro0450List.LocalizaRegistro(const pCOD_INF: string): Boolean;
  var
    iI: Integer;
begin
  Result := False;
  for iI := 0 to Pred(Self.Count) do
  begin
    if Self.Items[iI].COD_INF = pCOD_INF then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TRegistro0450List.LocalizaRegistro(const AValue: string;
  ABuscaTxt: Boolean): String;
  var
    iI: Integer;
    VAchou : Boolean;
begin
  Result := '';
  for iI := 0 to Pred(Self.Count) do
  begin
   if ABuscaTxt then
   begin
   VAchou := Self.Items[iI].TXT = AValue;
   end
   else
   VAchou := Self.Items[iI].COD_INF = AValue;

   if VAchou then
   begin
    result := IntToStr( iI+1 );
    Break;
   end;

    end;
end;

function TRegistro0450List.New: TRegistro0450;
begin
  Result := TRegistro0450.Create;
  Add(Result);
end;

procedure TRegistro0450List.SetItem(Index: Integer; const Value: TRegistro0450);
begin
  Put(Index, Value);
end;

{ TRegistro0460List }

function TRegistro0460List.GetItem(Index: Integer): TRegistro0460;
begin
  Result := TRegistro0460(inherited GetItem(Index));
end;

function TRegistro0460List.LocalizaRegistro(const pCOD_OBS: String): boolean;
var
intFor: integer;
begin
   Result := false;
   for intFor := 0 to Self.Count - 1 do
   begin
      if Self.Items[intFor].COD_OBS = pCOD_OBS then
      begin
         Result := true;
         Break;
      end;
   end;
end;

function TRegistro0460List.LocalizaRegistro(const AValue : String; ABuscaTxt : Boolean): String;
var
intFor: integer;
VAchou : Boolean;
begin
   Result := '';
   for intFor := 0 to Self.Count - 1 do
   begin
     if ABuscaTxt then
     begin
      VAchou := Self.Items[intFor].TXT = AValue;
      end
      else
      VAchou := Self.Items[intFor].COD_OBS = AValue;
      if VAchou then
      begin
       result := IntToStr(intFor+1);
       Break;
      end;
     end;
end;

function TRegistro0460List.New: TRegistro0460;
begin
  Result := TRegistro0460.Create;
  Add(Result);
end;

procedure TRegistro0460List.SetItem(Index: Integer; const Value: TRegistro0460);
begin
  Put(Index, Value);
end;

{ TRegistro0150 }

constructor TRegistro0150.Create();
begin
  FRegistro0175 := TRegistro0175List.Create;
end;

destructor TRegistro0150.Destroy;
begin
  FRegistro0175.Free;
  inherited;
end;

{ TRegistro0200 }

constructor TRegistro0200.Create();
begin
   inherited Create();
   FRegistro0205 := TRegistro0205List.Create;
   FRegistro0206 := TRegistro0206List.Create;
   FRegistro0210 := TRegistro0210List.Create;
   FRegistro0220 := TRegistro0220List.Create;
   FRegistro0221 := TRegistro0221List.Create;
end;

destructor TRegistro0200.Destroy;
begin
  FRegistro0205.Free;
  FRegistro0206.Free;
  FRegistro0210.Free;
  FRegistro0220.Free;
  FRegistro0221.Free;
  inherited;
end;

{ TRegistro0300 }

constructor TRegistro0300.Create();
begin
   inherited Create;
   FRegistro0305 := TRegistro0305.Create;
end;

destructor TRegistro0300.Destroy;
begin
  FRegistro0305.Free;
  inherited;
end;

{ TRegistro0300List }

function TRegistro0300List.GetItem(Index: Integer): TRegistro0300;
begin
  Result := TRegistro0300(inherited GetItem(Index));
end;

function TRegistro0300List.LocalizaRegistro(const pCOD_IND_BEM: String): boolean;
var
intFor: integer;
begin
   Result := false;
   for intFor := 0 to Self.Count - 1 do
   begin
      if Self.Items[intFor].FCOD_IND_BEM = pCOD_IND_BEM then
      begin
         Result := true;
         Break;
      end;
   end;
end;

function TRegistro0300List.New(): TRegistro0300;
begin
  Result := TRegistro0300.Create();
  Add(Result);
end;

procedure TRegistro0300List.SetItem(Index: Integer; const Value: TRegistro0300);
begin
  Put(Index, Value);
end;

{ TRegistro0500List }

function TRegistro0500List.GetItem(Index: Integer): TRegistro0500;
begin
  Result := TRegistro0500(inherited GetItem(Index));
end;

function TRegistro0500List.New: TRegistro0500;
begin
  Result := TRegistro0500.Create;
  Add(Result);
end;

procedure TRegistro0500List.SetItem(Index: Integer; const Value: TRegistro0500);
begin
  Put(Index, Value);
end;

{ TRegistro0600List }

function TRegistro0600List.GetItem(Index: Integer): TRegistro0600;
begin
  Result := TRegistro0600(inherited GetItem(Index));
end;

function TRegistro0600List.New: TRegistro0600;
begin
  Result := TRegistro0600.Create();
  Add(Result);
end;

procedure TRegistro0600List.SetItem(Index: Integer; const Value: TRegistro0600);
begin
  inherited SetItem(Index, Value);
end;

end.
