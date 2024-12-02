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

unit ACBrEFDBloco_D;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrEFDBlocos;

type
  TRegistroD100List = class;

  TRegistroD101List = class; 

  TRegistroD110List = class;
  TRegistroD120List = class;
  TRegistroD130List = class;
  TRegistroD140List = class;
  TRegistroD150List = class;
  TRegistroD160List = class;
  TRegistroD161List = class;
  TRegistroD162List = class;
  TRegistroD170List = class;
  TRegistroD180List = class;
  TRegistroD190List = class; 
  TRegistroD195List = class; 
  TRegistroD197List = class; 
  TRegistroD300List = class;
  TRegistroD301List = class;
  TRegistroD310List = class;
  TRegistroD350List = class;
  TRegistroD355List = class;
  TRegistroD360List = class;
  TRegistroD365List = class;
  TRegistroD370List = class;
  TRegistroD390List = class;
  TRegistroD400List = class;
  TRegistroD410List = class;
  TRegistroD411List = class;
  TRegistroD420List = class;
  TRegistroD500List = class;
  TRegistroD510List = class;
  TRegistroD530List = class;
  TRegistroD590List = class; 
  TRegistroD600List = class;
  TRegistroD610List = class;
  TRegistroD690List = class;
  TRegistroD695List = class;
  TRegistroD696List = class;
  TRegistroD697List = class;
  TRegistroD700List = class;
  TRegistroD730List = class;
  TRegistroD731List = class;
  TRegistroD735List = class;
  TRegistroD737List = class;
  TRegistroD750List = class;
  TRegistroD760List = class;
  TRegistroD761List = class;

  /// Registro D001 - ABERTURA DO BLOCO D

  TRegistroD001 = class(TOpenBlocos)
  private
    FRegistroD100: TRegistroD100List;
    FRegistroD300: TRegistroD300List;
    FRegistroD350: TRegistroD350List;
    FRegistroD400: TRegistroD400List;
    FRegistroD500: TRegistroD500List;
    FRegistroD600: TRegistroD600List;
    FRegistroD695: TRegistroD695List;
    FRegistroD700: TRegistroD700List;
    FRegistroD750: TRegistroD750List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property RegistroD100: TRegistroD100List read FRegistroD100 write FRegistroD100;
    property RegistroD300: TRegistroD300List read FRegistroD300 write FRegistroD300;
    property RegistroD350: TRegistroD350List read FRegistroD350 write FRegistroD350;
    property RegistroD400: TRegistroD400List read FRegistroD400 write FRegistroD400;
    property RegistroD500: TRegistroD500List read FRegistroD500 write FRegistroD500;
    property RegistroD600: TRegistroD600List read FRegistroD600 write FRegistroD600;
    property RegistroD695: TRegistroD695List read FRegistroD695 write FRegistroD695;
    property RegistroD700: TRegistroD700List read FRegistroD700 write FRegistroD700;
    property RegistroD750: TRegistroD750List read FRegistroD750 write FRegistroD750;
  end;

  /// Registro D100 - NOTA FISCAL DE SERVI�O DE TRANSPORTE (C�DIGO 07) E CONHECIMENTOS DE TRANSPORTE RODOVI�RIO DE CARGAS (C�DIGO 08), AQUAVI�RIO DE CARGAS (C�DIGO 09), A�REO (C�DIGO 10), FERROVI�RIO DE CARGAS (C�DIGO 11) E MULTIMODAL DE CARGAS (C�DIGO 26) E NOTA FISCAL DE TRANSPORTE FERROVI�RIO DE CARGA (C�DIGO 27)

  TRegistroD100 = class
  private
    fIND_OPER: TACBrIndOper;        /// Indicador do tipo de opera��o: 0- Aquisi��o; 1- Presta��o
    fIND_EMIT: TACBrIndEmit;        /// Indicador do emitente do documento fiscal: 0- Emiss�o pr�pria; 1- Terceiros
    fCOD_PART: String;              /// C�digo do participante (campo 02 do Registro 0150):
    fCOD_MOD: String;               /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1 (SOMENTE 57, 67;
                                    ///Se o Campo �COD_MOD� for igual a 07, 08, 08B, 09, 10, 11, 26 ou 27, a data informada dever� ser menor que 01/01/2019.
    fCOD_SIT: TACBrCodSit;          /// C�digo da situa��o do documento fiscal, conforme a Tabela 4.1.2
    fSER: String;                   /// S�rie do documento fiscal
    fSUB: String;                   /// Subs�rie do documento fiscal
    fNUM_DOC: String;               /// N�mero do documento fiscal
    fCHV_CTE: String;               /// Chave da Conhecimento Eletr�nico
    fDT_DOC: TDateTime;             /// Data da emiss�o do documento fiscal
    fDT_A_P: TDateTime;             /// Data da aquisi��o ou da presta��odo servi�o
    fTP_CT_e: String;               /// Tipo de conhecimento conforme definido no manual de integra��o do CT-e
    fCHV_CTE_REF: String;           /// Chave do CT-e de referencia cujos valores foram complementados: 1 ou 2
    fVL_DOC: currency;              /// Valor total do documento fiscal
    fVL_DESC: currency;             /// Valor total do desconto
    fIND_FRT: TACBrIndFrt;          /// Indicador do tipo do frete:
    fVL_SERV: currency;             /// Valor do frete indicado no documento fiscal
    fVL_BC_ICMS: currency;          /// Valor da base de c�lculo do ICMS
    fVL_ICMS: currency;             /// Valor do ICMS
    fVL_NT: currency;               /// Valor n�o tributado
    fCOD_INF: String;               /// Valor do ICMS retido por substitui��o tribut�ria
    fCOD_CTA: String;               /// C�digo da conta analitica contabil debitada/creditada
    fCOD_MUN_ORIG: String;          /// C�digo municipio origem conf. tab IBGE
    fCOD_MUN_DEST: String;          /// C�digo municipio destino conf. tab IBGE

    FRegistroD101: TRegistroD101List;
    FRegistroD110: TRegistroD110List;
    FRegistroD130: TRegistroD130List;
    FRegistroD140: TRegistroD140List;
    FRegistroD150: TRegistroD150List;
    FRegistroD160: TRegistroD160List;
    FRegistroD170: TRegistroD170List;
    FRegistroD180: TRegistroD180List;
    FRegistroD190: TRegistroD190List; /// BLOCO D - Lista de RegistroD190 (FILHO)
    FRegistroD195: TRegistroD195List;
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy

    property IND_OPER: TACBrIndOper read FIND_OPER write FIND_OPER;
    property IND_EMIT: TACBrIndEmit read FIND_EMIT write FIND_EMIT;
    property COD_PART: String read FCOD_PART write FCOD_PART;
    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property COD_SIT: TACBrCodSit read FCOD_SIT write FCOD_SIT;
    property SER: String read FSER write FSER;
    property SUB: String read FSUB write FSUB;
    property NUM_DOC: String read FNUM_DOC write FNUM_DOC;
    property CHV_CTE: String read FCHV_CTE write FCHV_CTE;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property DT_A_P: TDateTime read FDT_A_P write FDT_A_P;
    property TP_CT_e: String read FTP_CT_e write FTP_CT_e;
    property CHV_CTE_REF: String read FCHV_CTE_REF write FCHV_CTE_REF;
    property VL_DOC: currency read FVL_DOC write FVL_DOC;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property IND_FRT: TACBrIndFrt read FIND_FRT write FIND_FRT;
    property VL_SERV: currency read FVL_SERV write FVL_SERV;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_NT: currency read FVL_NT write FVL_NT;
    property COD_INF: String read FCOD_INF write FCOD_INF;
    property COD_CTA: String read FCOD_CTA write FCOD_CTA;
    property COD_MUN_ORIG: String read FCOD_MUN_ORIG write FCOD_MUN_ORIG;
    property COD_MUN_DEST: String read FCOD_MUN_DEST write FCOD_MUN_DEST;

    property RegistroD101: TRegistroD101List read FRegistroD101 write FRegistroD101;
    property RegistroD110: TRegistroD110List read FRegistroD110 write FRegistroD110;
    property RegistroD130: TRegistroD130List read FRegistroD130 write FRegistroD130;
    property RegistroD140: TRegistroD140List read FRegistroD140 write FRegistroD140;
    property RegistroD150: TRegistroD150List read FRegistroD150 write FRegistroD150;
    property RegistroD160: TRegistroD160List read FRegistroD160 write FRegistroD160;
    property RegistroD170: TRegistroD170List read FRegistroD170 write FRegistroD170;
    property RegistroD180: TRegistroD180List read FRegistroD180 write FRegistroD180;
    property RegistroD190: TRegistroD190List read FRegistroD190 write FRegistroD190; 
    property RegistroD195: TRegistroD195List read FRegistroD195 write FRegistroD195;
  end;

  /// Registro D100 - Lista

  TRegistroD100List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD100; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD100); /// SetItem
  public
    function New(): TRegistroD100;
    property Items[Index: Integer]: TRegistroD100 read GetItem write SetItem;
  end;

  /// Registro D101 - EC 87/2015 - INFORMACAO COMPLEMENTAR DE OPERACOES INTERESTADUAIS

  TRegistroD101 = class
  private
    fVL_FCP_UF_DEST : currency;                  /// VALOR TOTAL FUNDO DE COMBATE A POBREZA
    fVL_ICMS_UF_DEST: currency;                  /// VALOR TOTAL DO ICMS DA UF DE DESTINO
    fVL_ICMS_UF_REM: currency;                   /// VALOR TOTAL DO ICMS DA UF DE ORIGEM
  public
    property VL_FCP_UF_DEST: currency read fVL_FCP_UF_DEST write fVL_FCP_UF_DEST;
    property VL_ICMS_UF_DEST: currency read fVL_ICMS_UF_DEST write fVL_ICMS_UF_DEST;
    property VL_ICMS_UF_REM: currency read fVL_ICMS_UF_REM write fVL_ICMS_UF_REM;
  end;

  /// Registro D101 - Lista

  TRegistroD101List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD101; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD101); /// SetItem
  public
    function New: TRegistroD101;
    property Items[Index: Integer]: TRegistroD101 read GetItem write SetItem;
  end;
  
  /// Registro D110 - COMPLEMENTO DOS BILHETES (C�DIGO 13, C�DIGO 14 E C�DIGO 16)

  TRegistroD110 = class
  private
    fCOD_ITEM: string;
    fMUN_ITEM: integer;
    fVL_SERV: currency;
    fVL_OUT: currency;

    FRegistroD120: TRegistroD120List;
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy

    property NUN_ITEM: integer read fMUN_ITEM write fMUN_ITEM;
    property COD_ITEM: string read fCOD_ITEM write fCOD_ITEM;
    property VL_SERV: currency read fVL_SERV write fVL_SERV;
    property VL_OUT: currency read fVL_OUT write fVL_OUT;

    property RegistroD120: TRegistroD120List read FRegistroD120 write FRegistroD120;
  end;

  /// Registro D110 - Lista

  TRegistroD110List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD110; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD110); /// SetItem
  public
    function New(): TRegistroD110;
    property Items[Index: Integer]: TRegistroD110 read GetItem write SetItem;
  end;

  /// Registro D120 - COMPLEMENTO DA NOTA FISCAL DE SERVI�OS DE TRANSPORTE (C�DIGO 07)

  TRegistroD120 = class
  private
     fCOD_MUN_ORIG:String; // C�digo do munic�pio de origem do servi�o, conforme a tabela IBGE
     fCOD_MUN_DEST:String; // C�digo do munic�pio de destino, conforme a tabela IBGE
     fVEIC_ID     :String; // Placa de identifica��o do ve�culo
     fUF_ID       :String;  // Sigla da UF da placa do ve�culo
  public
    property COD_MUN_ORIG :String read fCOD_MUN_ORIG write fCOD_MUN_ORIG;
    property COD_MUN_DEST :String read fCOD_MUN_DEST write fCOD_MUN_DEST;
    property VEIC_ID      :String read fVEIC_ID      write fVEIC_ID     ;
    property UF_ID        :String read fUF_ID        write fUF_ID       ;
  end;

  /// Registro D120 - Lista

  TRegistroD120List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD120; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD120); /// SetItem
  public
    function New: TRegistroD120;
    property Items[Index: Integer]: TRegistroD120 read GetItem write SetItem;
  end;

  /// Registro D130 - COMPLEMENTO DO CONHECIMENTO RODOVI�RIO DE CARGAS (C�DIGO 08)

  TRegistroD130 = class
  private
    fCOD_PART_CONSG: String;                /// C�digo do participante (campo 02 do Registro 0150):
    fCOD_PART_RED: String;                  /// C�digo do participante (campo 02 do Registro 0150):
    fIND_FRT_RED: TACBrTipoFreteRedespacho; /// Indicador do tipo do frete da opera��o de redespacho:
    fCOD_MUN_ORIG: String;                  /// C�digo do munic�pio de origem do servi�o, conforme a tabela IBGE
    fCOD_MUN_DEST: String;                  /// C�digo do munic�pio de destino, conforme a tabela IBGE
    fVEIC_ID: String;                       /// Placa de identifica��o do ve�culo
    fVL_LIQ_FRT: currency;                  /// Valor l�quido do frete
    fVL_SEC_CAT: currency;                  /// Soma de valores de Sec/Cat (servi�os de coleta/custo adicional de transporte)
    fVL_DESP: currency;                     /// Soma de valores de despacho
    fVL_PEDG: currency;                     /// Soma dos valores de ped�gio
    fVL_OUT: currency;                      /// Outros valores
    fVL_FRT: currency;                      /// Valor total do frete
    fUF_ID: String;                         /// Sigla da UF da placa do ve�culo
  public
    property COD_PART_CONSG: String read FCOD_PART_CONSG write FCOD_PART_CONSG;
    property COD_PART_RED: String read FCOD_PART_RED write FCOD_PART_RED;
    property IND_FRT_RED: TACBrTipoFreteRedespacho read FIND_FRT_RED write FIND_FRT_RED;
    property COD_MUN_ORIG: String read FCOD_MUN_ORIG write FCOD_MUN_ORIG;
    property COD_MUN_DEST: String read FCOD_MUN_DEST write FCOD_MUN_DEST;
    property VEIC_ID: String read FVEIC_ID write FVEIC_ID;
    property VL_LIQ_FRT: currency read FVL_LIQ_FRT write FVL_LIQ_FRT;
    property VL_SEC_CAT: currency read FVL_SEC_CAT write FVL_SEC_CAT;
    property VL_DESP: currency read FVL_DESP write FVL_DESP;
    property VL_PEDG: currency read FVL_PEDG write FVL_PEDG;
    property VL_OUT: currency read FVL_OUT write FVL_OUT;
    property VL_FRT: currency read FVL_FRT write FVL_FRT;
    property UF_ID: String read FUF_ID write FUF_ID;
  end;

  /// Registro D130 - Lista

  TRegistroD130List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD130; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD130); /// SetItem
  public
    function New: TRegistroD130;
    property Items[Index: Integer]: TRegistroD130 read GetItem write SetItem;
  end;

  /// Registro D140 - COMPLEMENTO DO CONHECIMENTO AQUAVI�RIO DE CARGAS (C�DIGO 09)

  TRegistroD140 = class
  private
    fCOD_PART_CONSG: String;        /// C�digo do participante (campo 02 do Registro 0150):
    fCOD_MUN_ORIG: String;          /// C�digo do munic�pio de origem do servi�o, conforme a tabela IBGE
    fCOD_MUN_DEST: String;          /// C�digo do munic�pio de destino, conforme a tabela IBGE
    fIND_VEIC: TACBrTipoVeiculo;    /// Indicador do tipo do ve�culo transportador:
    fVEIC_ID: String;               /// Identifica��o da embarca��o (IRIM ou Registro CPP)
    fIND_NAV: TACBrTipoNavegacao;   /// Indicador do tipo da navega��o:
    fVIAGEM: String;                /// N�mero da viagem
    fVL_FRT_LIQ: currency;          /// Valor l�quido do frete
    fVL_DESP_PORT: currency;        /// Valor das despesas portu�rias
    fVL_DESP_CAR_DESC: currency;    /// Valor das despesas com carga e descarga
    fVL_OUT: currency;              /// Outros valores
    fVL_FRT_BRT: currency;          /// Valor bruto do frete
    fVL_FRT_MM: currency;           /// Valor adicional do frete para renova��o da Marinha Mercante
  public
    property COD_PART_CONSG: String read FCOD_PART_CONSG write FCOD_PART_CONSG;
    property COD_MUN_ORIG: String read FCOD_MUN_ORIG write FCOD_MUN_ORIG;
    property COD_MUN_DEST: String read FCOD_MUN_DEST write FCOD_MUN_DEST;
    property IND_VEIC: TACBrTipoVeiculo read FIND_VEIC write FIND_VEIC;
    property VEIC_ID: String read FVEIC_ID write FVEIC_ID;
    property IND_NAV: TACBrTipoNavegacao read FIND_NAV write FIND_NAV;
    property VIAGEM: String read FVIAGEM write FVIAGEM;
    property VL_FRT_LIQ: currency read FVL_FRT_LIQ write FVL_FRT_LIQ;
    property VL_DESP_PORT: currency read FVL_DESP_PORT write FVL_DESP_PORT;
    property VL_DESP_CAR_DESC: currency read FVL_DESP_CAR_DESC write FVL_DESP_CAR_DESC;
    property VL_OUT: currency read FVL_OUT write FVL_OUT;
    property VL_FRT_BRT: currency read FVL_FRT_BRT write FVL_FRT_BRT;
    property VL_FRT_MM: currency read FVL_FRT_MM write FVL_FRT_MM;
  end;

  /// Registro D140 - Lista

  TRegistroD140List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD140; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD140); /// SetItem
  public
    function New: TRegistroD140;
    property Items[Index: Integer]: TRegistroD140 read GetItem write SetItem;
  end;

  /// Registro D150 - COMPLEMENTO DO CONHECIMENTO A�REO (C�DIGO 10)

  TRegistroD150 = class
  private
    fCOD_MUN_ORIG: String;     /// C�digo do munic�pio de origem do servi�o, conforme a tabela IBGE
    fCOD_MUN_DEST: String;     /// C�digo do munic�pio de destino, conforme a tabela IBGE
    fVEIC_ID: String;          /// Identifica��o da aeronave (DAC)
    fVIAGEM: String;           /// N�mero do v�o.
    fIND_TFA: TACBrTipoTarifa; /// Indicador do tipo de tarifa aplicada: 0- Exp., 1- Enc., 2- C.I., 9- Outra
    fVL_PESO_TX: currency;     /// Peso taxado
    fVL_TX_TERR: currency;     /// Valor da taxa terrestre
    fVL_TX_RED: currency;      /// Valor da taxa de redespacho
    fVL_OUT: currency;         /// Outros valores
    fVL_TX_ADV: currency;      /// Valor da taxa "ad valorem"
  public
    property COD_MUN_ORIG: String read FCOD_MUN_ORIG write FCOD_MUN_ORIG;
    property COD_MUN_DEST: String read FCOD_MUN_DEST write FCOD_MUN_DEST;
    property VEIC_ID: String read FVEIC_ID write FVEIC_ID;
    property VIAGEM: String read FVIAGEM write FVIAGEM;
    property IND_TFA: TACBrTipoTarifa read FIND_TFA write FIND_TFA;
    property VL_PESO_TX: currency read FVL_PESO_TX write FVL_PESO_TX;
    property VL_TX_TERR: currency read FVL_TX_TERR write FVL_TX_TERR;
    property VL_TX_RED: currency read FVL_TX_RED write FVL_TX_RED;
    property VL_OUT: currency read FVL_OUT write FVL_OUT;
    property VL_TX_ADV: currency read FVL_TX_ADV write FVL_TX_ADV;
  end;

  /// Registro D150 - Lista

  TRegistroD150List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD150; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD150); /// SetItem
  public
    function New: TRegistroD150;
    property Items[Index: Integer]: TRegistroD150 read GetItem write SetItem;
  end;

  /// Registro D160 - CARGA TRANSPORTADA (C�DIGO 07, 08, 09, 10, 11, 26 E 27)

  TRegistroD160 = class
  private
    fDESPACHO       : String; /// Identifica��o do n�mero do despacho
    fCNPJ_CPF_REM   : String; /// CNPJ ou CPF do remetente das mercadorias que constam na nota fiscal.
    fIE_REM         : String; /// Inscri��o Estadual do remetente das mercadorias que constam na nota fiscal.
    fCOD_MUN_ORI    : String; /// C�digo do Munic�pio de origem, conforme tabela IBGE
    fCNPJ_CPF_DEST  : String; /// CNPJ ou CPF do destinat�rio das mercadorias que constam na nota fiscal.
    fIE_DEST        : String; /// Inscri��o Estadual do destinat�rio das mercadorias que constam na nota fiscal.
    fCOD_MUN_DEST   : String; /// C�digo do Munic�pio de destino, conforme tabela IBGE

    FRegistroD161: TRegistroD161List;
    FRegistroD162: TRegistroD162List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property DESPACHO     : String read fDESPACHO       write fDESPACHO     ;
    property CNPJ_CPF_REM : String read fCNPJ_CPF_REM   write fCNPJ_CPF_REM ;
    property IE_REM       : String read fIE_REM         write fIE_REM       ;
    property COD_MUN_ORI  : String read fCOD_MUN_ORI    write fCOD_MUN_ORI  ;
    property CNPJ_CPF_DEST: String read fCNPJ_CPF_DEST  write fCNPJ_CPF_DEST;
    property IE_DEST      : String read fIE_DEST        write fIE_DEST      ;
    property COD_MUN_DEST : String read fCOD_MUN_DEST   write fCOD_MUN_DEST ;

    property RegistroD161: TRegistroD161List read FRegistroD161 write FRegistroD161;
    property RegistroD162: TRegistroD162List read FRegistroD162 write FRegistroD162;
  end;

  /// Registro D160 - Lista

  TRegistroD160List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD160; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD160); /// SetItem
  public
    function New: TRegistroD160;
    property Items[Index: Integer]: TRegistroD160 read GetItem write SetItem;
  end;

  /// Registro D161 - LOCAL DA COLETA E ENTREGA (C�DIGO 07, 08, 09, 10, 11, 26 E 27)

  TRegistroD161 = class
  private
    fIND_CARGA: TACBrTipoTransporte;    /// Indicador do tipo de transporte da carga coletada:
    fCNPJ_COL: String;                  /// N�mero do CNPJ do contribuinte do local de coleta
    fIE_COL: String;                    /// Inscri��o Estadual do contribuinte do local de coleta
    fCOD_MUN_COL: String;               /// C�digo do Munic�pio do local de coleta, conforme tabela IBGE
    fCNPJ_ENTG: String;                 /// N�mero do CNPJ do contribuinte do local de entrega
    fIE_ENTG: String;                   /// Inscri��o Estadual do contribuinte do local de entrega
    fCOD_MUN_ENTG: String;              /// C�digo do Munic�pio do local de entrega, conforme tabela IBGE
  public
    property IND_CARGA: TACBrTipoTransporte read FIND_CARGA write FIND_CARGA;
    property CNPJ_COL: String read FCNPJ_COL write FCNPJ_COL;
    property IE_COL: String read FIE_COL write FIE_COL;
    property COD_MUN_COL: String read FCOD_MUN_COL write FCOD_MUN_COL;
    property CNPJ_ENTG: String read FCNPJ_ENTG write FCNPJ_ENTG;
    property IE_ENTG: String read FIE_ENTG write FIE_ENTG;
    property COD_MUN_ENTG: String read FCOD_MUN_ENTG write FCOD_MUN_ENTG;
  end;

  /// Registro D161 - Lista

  TRegistroD161List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD161; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD161); /// SetItem
  public
    function New: TRegistroD161;
    property Items[Index: Integer]: TRegistroD161 read GetItem write SetItem;
  end;

  /// Registro D162 - IDENTIFICA��O DOS DOCUMENTOS FISCAIS (COD. 08, 8B, 09, 10, 11, 26, 27)

  TRegistroD162 = class
  private
    fCOD_MOD: String;       /// C�digo do documento fiscal
    FSER: String;           /// S�rie do documento
    FNUM_DOC: String;       /// Numero
    FDT_DOC: TDateTime;     /// Data de emiss�o
    FVL_DOC: currency;      /// Valor total do documento fiscal
    FVL_MERC: currency;     /// Valor das mercadorias constantes no documento fiscal
    FQTD_VOL: Integer;     /// Quantidade de volumes transportados
    FPESO_BRT: currency;    /// Peso bruto
    FPESO_LIQ: currency;    /// Peso liquido
  public
    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property SER: String read FSER write FSER;
    property NUM_DOC: String read FNUM_DOC write FNUM_DOC;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property VL_DOC: currency read FVL_DOC write FVL_DOC;
    property VL_MERC: currency read FVL_MERC write FVL_MERC;
    property QTD_VOL: Integer read FQTD_VOL write FQTD_VOL;
    property PESO_BRT: currency read FPESO_BRT write FPESO_BRT;
    property PESO_LIQ: currency read FPESO_LIQ write FPESO_LIQ;
  end;

  /// Registro D162 - Lista

  TRegistroD162List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD162; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD162); /// SetItem
  public
    function New: TRegistroD162;
    property Items[Index: Integer]: TRegistroD162 read GetItem write SetItem;
  end;

  /// Registro D170 - COMPLEMENTO DO CONHECIMENTO MULTIMODAL DE CARGAS (C�DIGO 26)

  TRegistroD170 = class
  private
    fCOD_PART_CONSG: String;          /// C�digo do participante (campo 02 do Registro 0150):
    fCOD_PART_RED: String;            /// C�digo do participante (campo 02 do Registro 0150):
    fCOD_MUN_ORIG: String;            /// C�digo do munic�pio de origem do servi�o, conforme a tabela IBGE
    fCOD_MUN_DEST: String;            /// C�digo do munic�pio de destino, conforme a tabela IBGE
    fOTM: String;                     /// Registro do operador de transporte multimodal
    fIND_NAT_FRT: TACBrNaturezaFrete; /// Indicador da natureza do frete:
    fVL_LIQ_FRT: currency;            /// Valor l�quido do frete
    fVL_GRIS: currency;               /// Valor do gris (gerenciamento de risco)
    fVL_PDG: currency;                /// Somat�rio dos valores de ped�gio
    fVL_OUT: currency;                /// Outros valores
    fVL_FRT: currency;                /// Valor total do frete
    fVEIC_ID: String;                 /// Placa de identifica��o do ve�culo
    fUF_ID: String;                   /// Sigla da UF da placa do ve�culo
  public
    property COD_PART_CONSG: String read FCOD_PART_CONSG write FCOD_PART_CONSG;
    property COD_PART_RED: String read FCOD_PART_RED write FCOD_PART_RED;
    property COD_MUN_ORIG: String read FCOD_MUN_ORIG write FCOD_MUN_ORIG;
    property COD_MUN_DEST: String read FCOD_MUN_DEST write FCOD_MUN_DEST;
    property OTM: String read FOTM write FOTM;
    property IND_NAT_FRT: TACBrNaturezaFrete read FIND_NAT_FRT write FIND_NAT_FRT;
    property VL_LIQ_FRT: currency read FVL_LIQ_FRT write FVL_LIQ_FRT;
    property VL_GRIS: currency read FVL_GRIS write FVL_GRIS;
    property VL_PDG: currency read FVL_PDG write FVL_PDG;
    property VL_OUT: currency read FVL_OUT write FVL_OUT;
    property VL_FRT: currency read FVL_FRT write FVL_FRT;
    property VEIC_ID: String read FVEIC_ID write FVEIC_ID;
    property UF_ID: String read FUF_ID write FUF_ID;
  end;

  /// Registro D170 - Lista

  TRegistroD170List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD170; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD170); /// SetItem
  public
    function New: TRegistroD170;
    property Items[Index: Integer]: TRegistroD170 read GetItem write SetItem;
  end;

  /// Registro D180 - MODAIS (C�DIGO 26)

  TRegistroD180 = class
  private
    fNUM_SEQ: String;            /// N�mero de ordem seq�encial do modal
    fIND_EMIT: TACBrIndEmit;     /// Indicador do emitente do documento fiscal: 0- Emiss�o pr�pria, 1- Terceiros
    fCNPJ_EMIT: String;          /// CNPJ do participante emitente do modal
    fUF_EMIT: String;            /// Sigla da unidade da federa��o do participante emitente do modal
    fIE_EMIT: String;            /// Inscri��o Estadual do participante emitente do modal
    fCOD_MUN_ORIG: String;       /// C�digo do munic�pio de origem do servi�o, conforme a tabela IBGE
    fCNPJ_CPF_TOM: String;       /// CNPJ/CPF do participante tomador do servi�o
    fUF_TOM: String;             /// Sigla da unidade da federa��o do participante tomador do servi�o
    fIE_TOM: String;             /// Inscri��o Estadual do participante tomador do servi�o
    fCOD_MUN_DEST: String;       /// C�digo do munic�pio de destino, conforme a tabela IBGE(Preencher com 9999999, se Exterior)
    fCOD_MOD: String;            /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fSER: String;                /// S�rie do documento fiscal
    fSUB: String;                /// Subs�rie do documento fiscal
    fNUM_DOC: String;            /// N�mero do documento fiscal
    fDT_DOC: TDateTime;          /// Data da emiss�o do documento fiscal
    fVL_DOC: currency;           /// Valor total do documento fiscal
  public
    property NUM_SEQ: String read FNUM_SEQ write FNUM_SEQ;
    property IND_EMIT: TACBrIndEmit read FIND_EMIT write FIND_EMIT;
    property CNPJ_EMIT: String read FCNPJ_EMIT write FCNPJ_EMIT;
    property UF_EMIT: String read FUF_EMIT write FUF_EMIT;
    property IE_EMIT: String read FIE_EMIT write FIE_EMIT;
    property COD_MUN_ORIG: String read FCOD_MUN_ORIG write FCOD_MUN_ORIG;
    property CNPJ_CPF_TOM: String read FCNPJ_CPF_TOM write FCNPJ_CPF_TOM;
    property UF_TOM: String read FUF_TOM write FUF_TOM;
    property IE_TOM: String read FIE_TOM write FIE_TOM;
    property COD_MUN_DEST: String read FCOD_MUN_DEST write FCOD_MUN_DEST;
    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property SER: String read FSER write FSER;
    property SUB: String read FSUB write FSUB;
    property NUM_DOC: String read FNUM_DOC write FNUM_DOC;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property VL_DOC: currency read FVL_DOC write FVL_DOC;
  end;

  /// Registro D180 - Lista

  TRegistroD180List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD180; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD180); /// SetItem
  public
    function New: TRegistroD180;
    property Items[Index: Integer]: TRegistroD180 read GetItem write SetItem;
  end;

  /// Registro D190 - REGISTRO ANAL�TICO DOS DOCUMENTOS (C�DIGO 07, 08, 09, 10, 11, 26 E 27)

  TRegistroD190 = class
  private
    fCST_ICMS: String;        /// C�digo da Situa��o Tribut�ria, conforme a tabela indicada no item 4.3.1
    fCFOP: String;            /// C�digo Fiscal de Opera��o e Presta��o, conforme a tabela indicada no item 4.2.2
    fALIQ_ICMS: currency;     /// Al�quota do ICMS
    fVL_OPR: currency;        /// Valor da opera��o correspondente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS.
    fVL_BC_ICMS: currency;    /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" referente � combina��o CST_ICMS, CFOP, e al�quota do ICMS
    fVL_ICMS: currency;       /// Parcela correspondente ao "Valor do ICMS" referente � combina��o CST_ICMS,  CFOP e al�quota do ICMS
    fVL_RED_BC: currency;     /// Valor n�o tributado em fun��o da redu��o da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fCOD_OBS: String;         /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)

    procedure SetCFOP(const Value: String);
  public
    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write SetCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_RED_BC: currency read FVL_RED_BC write FVL_RED_BC;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
  end;

  /// Registro D190 - Lista

  TRegistroD190List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD190; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD190); /// SetItem
  public
    function New: TRegistroD190;
    property Items[Index: Integer]: TRegistroD190 read GetItem write SetItem;
  end;

  /// Registro D195 - OBSERVA�OES DO LAN�AMENTO FISCAL (C�DIGO 07, 08, 09, 10, 11, 26 E 27)

  TRegistroD195 = class
  private
    fCOD_OBS: String;    /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
    fTXT_COMPL: String;  /// Descri��o complementar do c�digo de observa��o.

    fRegistroD197: TRegistroD197List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
    property TXT_COMPL: String read FTXT_COMPL write FTXT_COMPL;

    property RegistroD197: TRegistroD197List read FRegistroD197 write FRegistroD197;
  end;

  /// Registro D195 - Lista

  TRegistroD195List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD195; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD195); /// SetItem
  public
    function New: TRegistroD195;
    property Items[Index: Integer]: TRegistroD195 read GetItem write SetItem;
  end;

  /// Registro D197 - OUTRAS OBRIGA��ES TRIBUT�RIAS, AJUSTES E INFORMA��ES DE VALORES PROVENIENTES DE DOCUMENTO FISCAL.

  TRegistroD197 = class
  private
    fCOD_AJ: String;           /// C�digo do ajustes/benef�cio/incentivo, conforme tabela indicada no item 5.3.
    fDESCR_COMPL_AJ: String;   /// Descri��o complementar do ajuste da apura��o, nos casos em que o c�digo da tabela for �9999�
    fCOD_ITEM: String;         /// C�digo do item (campo 02 do Registro 0200)
    fVL_BC_ICMS: currency;     /// Base de c�lculo do ICMS ou do ICMS ST
    fALIQ_ICMS: currency;      /// Al�quota do ICMS
    fVL_ICMS: currency;        /// Valor do ICMS ou do ICMS ST
    fVL_OUTROS: currency;      /// Outros valores
  public
    property COD_AJ: String read FCOD_AJ write FCOD_AJ;
    property DESCR_COMPL_AJ: String read FDESCR_COMPL_AJ write FDESCR_COMPL_AJ;
    property COD_ITEM: String read FCOD_ITEM write FCOD_ITEM;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_OUTROS: currency read FVL_OUTROS write FVL_OUTROS;
  end;

  /// Registro C197 - Lista

  TRegistroD197List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD197; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD197); /// SetItem
  public
    function New: TRegistroD197;
    property Items[Index: Integer]: TRegistroD197 read GetItem write SetItem;
  end;

  /// Registro D300 - REGISTRO ANAL�TICO DOS BILHETES CONSOLIDADOS DE PASSAGEM RODOVI�RIO (C�DIGO 13), DE PASSAGEM AQUAVI�RIO (C�DIGO 14), DE PASSAGEM E NOTA DE BAGAGEM (C�DIGO 15) E DE PASSAGEM FERROVI�RIO (C�DIGO 16)

  TRegistroD300 = class
  private
    fCOD_MOD: String;         /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fSER: String;             /// S�rie do documento fiscal
    fSUB: String;             /// Subs�rie do documento fiscal
    fNUM_DOC_INI: String;     /// N�mero do primeiro documento fiscal emitido (mesmo modelo, s�rie e subs�rie)
    fNUM_DOC_FIN: String;     /// N�mero do �ltimo documento fiscal emitido (mesmo modelo, s�rie e subs�rie)
    fCST_ICMS: String;        /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1
    fCFOP: String;            /// C�digo Fiscal de Opera��o e Presta��o conforme tabela indicada no item 4.2.2
    fALIQ_ICMS: currency;     /// Al�quota do ICMS
    fDT_DOC: TDateTime;       /// Data da emiss�o dos documentos fiscais
    fVL_OPR: currency;        /// Valor total acumulado das opera��es correspondentes � combina��o de CST_ICMS, CFOP e al�quota do ICMS, inclu�das as despesas acess�rias e acr�scimos.
    fVL_DESC: currency;       /// Valor total dos descontos
    fVL_SERV: currency;       /// Valor total da presta��o de servi�o
    fVL_SEG: currency;        /// Valor de seguro
    fVL_OUT_DESP: currency;   /// Valor de outras despesas
    fVL_BC_ICMS: currency;    /// Valor total da base de c�lculo do ICMS
    fVL_ICMS: currency;       /// Valor total do ICMS
    fVL_RED_BC: currency;     /// Valor n�o tributado em fun��o da redu��o da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fCOD_OBS: String;         /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
    fCOD_CTA: String;         /// C�digo da conta anal�tica cont�bil debitada/creditada

    FRegistroD301: TRegistroD301List;
    FRegistroD310: TRegistroD310List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property SER: String read FSER write FSER;
    property SUB: String read FSUB write FSUB;
    property NUM_DOC_INI: String read FNUM_DOC_INI write FNUM_DOC_INI;
    property NUM_DOC_FIN: String read FNUM_DOC_FIN write FNUM_DOC_FIN;
    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property VL_SERV: currency read FVL_SERV write FVL_SERV;
    property VL_SEG: currency read FVL_SEG write FVL_SEG;
    property VL_OUT_DESP: currency read FVL_OUT_DESP write FVL_OUT_DESP;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_RED_BC: currency read FVL_RED_BC write FVL_RED_BC;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
    property COD_CTA: String read FCOD_CTA write FCOD_CTA;

    property RegistroD301: TRegistroD301List read FRegistroD301 write FRegistroD301;
    property RegistroD310: TRegistroD310List read FRegistroD310 write FRegistroD310;
  end;

  /// Registro D300 - Lista

  TRegistroD300List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD300; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD300); /// SetItem
  public
    function New: TRegistroD300;
    property Items[Index: Integer]: TRegistroD300 read GetItem write SetItem;
  end;

  /// Registro D301 - DOCUMENTOS CANCELADOS DOS BILHETES DE PASSAGEM RODOVI�RIO (C�DIGO 13), DE PASSAGEM AQUAVI�RIO (C�DIGO 14), DE PASSAGEM E NOTA DE BAGAGEM (C�DIGO 15) E DE PASSAGEM FERROVI�RIO (C�DIGO 16)

  TRegistroD301 = class
  private
    fNUM_DOC_CANC: String;    /// N�mero do documento fiscal cancelado
  public
    property NUM_DOC_CANC: String read FNUM_DOC_CANC write FNUM_DOC_CANC;
  end;

  /// Registro D301 - Lista

  TRegistroD301List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD301; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD301); /// SetItem
  public
    function New: TRegistroD301;
    property Items[Index: Integer]: TRegistroD301 read GetItem write SetItem;
  end;

  /// Registro D310 - COMPLEMENTO DOS BILHETES (C�DIGO 13, 14, 15 E 16)

  TRegistroD310 = class
  private
    fCOD_MUN_ORIG: String;    /// C�digo do munic�pio de origem do servi�o, conforme a tabela IBGE
    fVL_SERV: currency;       /// Valor total da presta��o de servi�o
    fVL_BC_ICMS: currency;    /// Valor total da base de c�lculo do ICMS
    fVL_ICMS: currency;       /// Valor total do ICMS
  public
    property COD_MUN_ORIG: String read FCOD_MUN_ORIG write FCOD_MUN_ORIG;
    property VL_SERV: currency read FVL_SERV write FVL_SERV;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
  end;

  /// Registro D310 - Lista

  TRegistroD310List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD310; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD310); /// SetItem
  public
    function New: TRegistroD310;
    property Items[Index: Integer]: TRegistroD310 read GetItem write SetItem;
  end;

  /// Registro D350 - EQUIPAMENTO ECF (C�DIGOS 2E, 13, 14, 15 e 16)

  TRegistroD350 = class
  private
    fCOD_MOD: String;      /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fECF_MOD: String;      /// Modelo do equipamento
    fECF_FAB: String;      /// N�mero de s�rie de fabrica��o do ECF
    fECF_CX: String;       /// N�mero do caixa atribu�do ao ECF

    FRegistroD355: TRegistroD355List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property ECF_MOD: String read FECF_MOD write FECF_MOD;
    property ECF_FAB: String read FECF_FAB write FECF_FAB;
    property ECF_CX: String read FECF_CX write FECF_CX;

    property RegistroD355: TRegistroD355List read FRegistroD355 write FRegistroD355;
  end;

  /// Registro D350 - Lista

  TRegistroD350List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD350; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD350); /// SetItem
  public
    function New: TRegistroD350;
    property Items[Index: Integer]: TRegistroD350 read GetItem write SetItem;
  end;

  /// Registro D355 - REDU��O Z (C�DIGOS 2E, 13, 14, 15 e 16)

  TRegistroD355 = class
  private
    fDT_DOC: TDateTime;       /// Data do movimento a que se refere a Redu��o Z
    fCRO: integer;            /// Posi��o do Contador de Rein�cio de Opera��o
    fCRZ: integer;            /// Posi��o do Contador de Redu��o Z
    fNUM_COO_FIN: integer;    /// N�mero do Contador de Ordem de Opera��o do �ltimo documento emitido no dia. (N�mero do COO na Redu��o Z)
    fGT_FIN: currency;        /// Valor do Grande Total final
    fVL_BRT: currency;        /// Valor da venda bruta

    FRegistroD360: TRegistroD360List;
    FRegistroD365: TRegistroD365List;
    FRegistroD390: TRegistroD390List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property CRO: integer read FCRO write FCRO;
    property CRZ: integer read FCRZ write FCRZ;
    property NUM_COO_FIN: integer read FNUM_COO_FIN write FNUM_COO_FIN;
    property GT_FIN: currency read FGT_FIN write FGT_FIN;
    property VL_BRT: currency read FVL_BRT write FVL_BRT;

    property RegistroD360: TRegistroD360List read FRegistroD360 write FRegistroD360;
    property RegistroD365: TRegistroD365List read FRegistroD365 write FRegistroD365;
    property RegistroD390: TRegistroD390List read FRegistroD390 write FRegistroD390;
  end;

  /// Registro D355 - Lista

  TRegistroD355List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD355; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD355); /// SetItem
  public
    function New: TRegistroD355;
    property Items[Index: Integer]: TRegistroD355 read GetItem write SetItem;
  end;

  /// Registro D360 - PIS E COFINS TOTALIZADOS NO DIA (C�DIGOS 2E, 13, 14, 15 e 16)

  TRegistroD360 = class
  private
    fVL_PIS: currency;        /// Valor total do PIS
    fVL_COFINS: currency;     /// Valor total do COFINS
  public
    property VL_PIS: currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: currency read FVL_COFINS write FVL_COFINS;
  end;

  /// Registro D360 - Lista

  TRegistroD360List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD360; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD360); /// SetItem
  public
    function New: TRegistroD360;
    property Items[Index: Integer]: TRegistroD360 read GetItem write SetItem;
  end;

  /// Registro D365 - REGISTRO DOS TOTALIZADORES PARCIAIS DE REDU��O Z (CODIGOS 2E 13 14 15 16)

  TRegistroD365 = class
  private
    fCOD_TOT_PAR: String;        /// C�digo do totalizador, conforme Tabela 4.4.6
    fVLR_ACUM_TOT: currency;     /// Valor acumulado no totalizador, relativo � respectiva Redu��o Z.
    fNR_TOT: String;             /// N�mero do totalizador quando ocorrer mais de uma situa��o com a mesma carga tribut�ria efetiva.
    fDESCR_NR_TOT: String;       /// Descri��o da situa��o tribut�ria relativa ao totalizador parcial, quando houver mais de um com a mesma carga tribut�ria efetiva.

    FRegistroD370: TRegistroD370List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_TOT_PAR: String read FCOD_TOT_PAR write FCOD_TOT_PAR;
    property VLR_ACUM_TOT: currency read FVLR_ACUM_TOT write FVLR_ACUM_TOT;
    property NR_TOT: String read FNR_TOT write FNR_TOT;
    property DESCR_NR_TOT: String read FDESCR_NR_TOT write FDESCR_NR_TOT;

    property RegistroD370: TRegistroD370List read FRegistroD370 write FRegistroD370;
  end;

  /// Registro D365 - Lista

  TRegistroD365List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD365; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD365); /// SetItem
  public
    function New: TRegistroD365;
    property Items[Index: Integer]: TRegistroD365 read GetItem write SetItem;
  end;

  /// Registro D370 - COMPLEMENTO DOS DOCUMENTOS INFORMADOS (C�DIGO 13, 14, 15, 16 E 2E)

  TRegistroD370 = class
  private
    fCOD_MUN_ORIG: String;    /// C�digo do munic�pio de origem do servi�o, conforme a tabela IBGE
    fVL_SERV: currency;       /// Valor total da presta��o de servi�o
    fQTD_BILH: integer;       /// Quantidade de bilhetes emitidos
    fVL_BC_ICMS: currency;    /// Valor total da base de c�lculo do ICMS
    fVL_ICMS: currency;       /// Valor total do ICMS
  public
    property COD_MUN_ORIG: String read FCOD_MUN_ORIG write FCOD_MUN_ORIG;
    property VL_SERV: currency read FVL_SERV write FVL_SERV;
    property QTD_BILH: integer read FQTD_BILH write FQTD_BILH;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
  end;

  /// Registro D370 - Lista

  TRegistroD370List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD370; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD370); /// SetItem
  public
    function New: TRegistroD370;
    property Items[Index: Integer]: TRegistroD370 read GetItem write SetItem;
  end;

  /// Registro D390 - REGISTRO ANAL�TICO DO MOVIMENTO DI�RIO (C�DIGOS 13, 14, 15, 16 E 2E)

  TRegistroD390 = class
  private
    fCST_ICMS: String;           /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1.
    fCFOP: String;               /// C�digo Fiscal de Opera��o e Presta��o
    fALIQ_ICMS: currency;        /// Al�quota do ICMS
    fVL_OPR: currency;           /// Valor da opera��o correspondente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS, inclu�das as despesas acess�rias e acr�scimos
    fVL_BC_ISSQN: currency;      /// Valor da base de c�lculo do ISSQN
    fALIQ_ISSQN: currency;       /// Al�quota do ISSQN
    fVL_ISSQN: currency;         /// Valor do ISSQN
    fVL_BC_ICMS: currency;       /// Base de c�lculo do ICMS acumulada relativa � al�quota informada
    fVL_ICMS: currency;          /// Valor do ICMS acumulado relativo � al�quota informada
    fCOD_OBS: String;            /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
  public
    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_BC_ISSQN: currency read FVL_BC_ISSQN write FVL_BC_ISSQN;
    property ALIQ_ISSQN: currency read FALIQ_ISSQN write FALIQ_ISSQN;
    property VL_ISSQN: currency read FVL_ISSQN write FVL_ISSQN;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
  end;

  /// Registro D390 - Lista

  TRegistroD390List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD390; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD390); /// SetItem
  public
    function New: TRegistroD390;
    property Items[Index: Integer]: TRegistroD390 read GetItem write SetItem;
  end;

  /// Registro D400 - RESUMO DE MOVIMENTO DI�RIO (C�DIGO 18)

  TRegistroD400 = class
  private
    fCOD_PART: String;            /// C�digo do participante (campo 02 do Registro 0150): - ag�ncia, filial ou posto
    fCOD_MOD: String;             /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fCOD_SIT: TACBrCodSit;        /// C�digo da situa��o do documento fiscal, conforme a Tabela 4.1.2
    fSER: String;                 /// S�rie do documento fiscal
    fSUB: String;                 /// Subs�rie do documento fiscal
    fNUM_DOC: String;             /// N�mero do documento fiscal resumo.
    fDT_DOC: TDateTime;           /// Data da emiss�o do documento fiscal
    fVL_DOC: currency;            /// Valor total do documento fiscal
    fVL_DESC: currency;           /// Valor acumulado dos descontos
    fVL_SERV: currency;           /// Valor acumulado da presta��o de servi�o
    fVL_BC_ICMS: currency;        /// Valor total da base de c�lculo do ICMS
    fVL_ICMS: currency;           /// Valor total do ICMS
    fVL_PIS: currency;            /// Valor do PIS
    fVL_COFINS: currency;         /// Valor da COFINS
    fCOD_CTA: String;             /// C�digo da conta anal�tica cont�bil debitada/creditada

    FRegistroD410: TRegistroD410List;
    FRegistroD420: TRegistroD420List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_PART: String read FCOD_PART write FCOD_PART;
    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property COD_SIT: TACBrCodSit read FCOD_SIT write FCOD_SIT;
    property SER: String read FSER write FSER;
    property SUB: String read FSUB write FSUB;
    property NUM_DOC: String read FNUM_DOC write FNUM_DOC;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property VL_DOC: currency read FVL_DOC write FVL_DOC;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property VL_SERV: currency read FVL_SERV write FVL_SERV;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_PIS: currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: currency read FVL_COFINS write FVL_COFINS;
    property COD_CTA: String read FCOD_CTA write FCOD_CTA;

    property RegistroD410: TRegistroD410List read FRegistroD410 write FRegistroD410;
    property RegistroD420: TRegistroD420List read FRegistroD420 write FRegistroD420;
  end;

  /// Registro D400 - Lista

  TRegistroD400List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD400; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD400); /// SetItem
  public
    function New: TRegistroD400;
    property Items[Index: Integer]: TRegistroD400 read GetItem write SetItem;
  end;

  /// Registro D410 - DOCUMENTOS INFORMADOS (C�DIGOS 13, 14, 15 E 16)

  TRegistroD410 = class
  private
    fCOD_MOD: String;      /// C�digo do modelo do documento fiscal , conforme a Tabela 4.1.1
    fSER: String;          /// S�rie do documento fiscal
    fSUB: String;          /// Subs�rie do documento fiscal
    fNUM_DOC_INI: String;  /// N�mero do documento fiscal inicial (mesmo modelo, s�rie e subs�rie)
    fNUM_DOC_FIN: String;  /// N�mero do documento fiscal final(mesmo modelo, s�rie e subs�rie)
    fDT_DOC: TDateTime;    /// Data da emiss�o dos documentos fiscais
    fCST_ICMS: String;     /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1
    fCFOP: String;         /// C�digo Fiscal de Opera��o e Presta��o
    fALIQ_ICMS: currency;  /// Al�quota do ICMS
    fVL_OPR: currency;     /// Valor total acumulado das opera��es correspondentes � combina��o de CST_ICMS, CFOP e al�quota do ICMS, inclu�das as despesas acess�rias e acr�scimos.
    fVL_DESC: currency;    /// Valor acumulado dos descontos
    fVL_SERV: currency;    /// Valor acumulado da presta��o de servi�o
    fVL_BC_ICMS: currency; /// Valor acumulado da base de c�lculo do ICMS
    fVL_ICMS: currency;    /// Valor acumulado do ICMS

    FRegistroD411: TRegistroD411List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property SER: String read FSER write FSER;
    property SUB: String read FSUB write FSUB;
    property NUM_DOC_INI: String read FNUM_DOC_INI write FNUM_DOC_INI;
    property NUM_DOC_FIN: String read FNUM_DOC_FIN write FNUM_DOC_FIN;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property VL_SERV: currency read FVL_SERV write FVL_SERV;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;

    property RegistroD411: TRegistroD411List read FRegistroD411 write FRegistroD411;
  end;

  /// Registro D410 - Lista

  TRegistroD410List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD410; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD410); /// SetItem
  public
    function New: TRegistroD410;
    property Items[Index: Integer]: TRegistroD410 read GetItem write SetItem;
  end;

  /// Registro D411 - DOCUMENTOS CANCELADOS DOS DOCUMENTOS INFORMADOS (C�DIGOS 13, 14, 15 E 16)

  TRegistroD411 = class
  private
    fNUM_DOC_CANC: String;    /// N�mero do documento fiscal cancelado
  public
    property NUM_DOC_CANC: String read FNUM_DOC_CANC write FNUM_DOC_CANC;
  end;

  /// Registro D411 - Lista

  TRegistroD411List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD411; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD411); /// SetItem
  public
    function New: TRegistroD411;
    property Items[Index: Integer]: TRegistroD411 read GetItem write SetItem;
  end;

  /// Registro D420 - COMPLEMENTO DOS DOCUMENTOS INFORMADOS(C�DIGOS 13, 14, 15 E 16)

  TRegistroD420 = class
  private
    fCOD_MUN_ORIG: String;    /// C�digo do munic�pio de origem do servi�o, conforme a tabela IBGE
    fVL_SERV: currency;       /// Valor total da presta��o de servi�o
    fVL_BC_ICMS: currency;    /// Valor total da base de c�lculo do ICMS
    fVL_ICMS: currency;       /// Valor total do ICMS
  public
    property COD_MUN_ORIG: String read FCOD_MUN_ORIG write FCOD_MUN_ORIG;
    property VL_SERV: currency read FVL_SERV write FVL_SERV;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
  end;

  /// Registro D420 - Lista

  TRegistroD420List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD420; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD420); /// SetItem
  public
    function New: TRegistroD420;
    property Items[Index: Integer]: TRegistroD420 read GetItem write SetItem;
  end;

  /// Registro D500 - NOTA FISCAL DE SERVI�O DE COMUNICA��O (C�DIGO 21) E NOTA FISCAL DE SERVI�O DE TELECOMUNICA��O (C�DIGO 22)

  TRegistroD500 = class
  private
    fIND_OPER: TACBrIndOper;           /// Indicador do tipo de opera��o: 0- Aquisi��o, 1- Presta��o
    fIND_EMIT: TACBrIndEmit;           /// Indicador do emitente do documento fiscal: 0- Emiss�o pr�pria, 1- Terceiros
    fCOD_PART: String;                 /// C�digo do participante (campo 02 do Registro 0150): - do prestador do servi�o, no caso de aquisi��o, - do tomador do servi�o, no caso de presta��o.
    fCOD_MOD: String;                  /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fCOD_SIT: TACBrCodSit;             /// C�digo da situa��o do documento fiscal, conforme a Tabela 4.1.2
    fSER: String;                      /// S�rie do documento fiscal
    fSUB: String;                      /// Subs�rie do documento fiscal
    fNUM_DOC: String;                  /// N�mero do documento fiscal
    fDT_DOC: TDateTime;                /// Data da emiss�o do documento fiscal
    fDT_A_P: TDateTime;                /// Data da entrada (aquisi��o) ou da sa�da (presta��o do servi�o)
    fVL_DOC: currency;                 /// Valor total do documento fiscal
    fVL_DESC: currency;                /// Valor total do desconto
    fVL_SERV: currency;                /// Valor da presta��o de servi�os
    fVL_SERV_NT: currency;             /// Valor total dos servi�os n�o-tributados pelo ICMS
    fVL_TERC: currency;                /// Valores cobrados em nome de terceiros
    fVL_DA: currency;                  /// Valor de outras despesas indicadas no documento fiscal
    fVL_BC_ICMS: currency;             /// Valor da base de c�lculo do ICMS
    fVL_ICMS: currency;                /// Valor do ICMS
    fCOD_INF: String;                  /// C�digo da informa��o complementar (campo 02 do Registro 0450)
    fVL_PIS: currency;                 /// Valor do PIS
    fVL_COFINS: currency;              /// Valor da COFINS
    fCOD_CTA: String;                  /// C�digo da conta anal�tica cont�bil debitada/creditada
    fTP_ASSINANTE: TACBrTipoAssinante; /// C�digo do Tipo de Assinante: 1 - Comercial/Industrial, 2 - Poder P�blico, 3 - Residencial/Pessoa f�sica, 4 - P�blico, 5 - Semi-P�blico, 6 - Outros

    FRegistroD510: TRegistroD510List;
    FRegistroD530: TRegistroD530List;
    FRegistroD590: TRegistroD590List; /// BLOCO D - Lista de RegistroD590 (FILHO) {Jean Barreiros 04Dez2009}
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property IND_OPER: TACBrIndOper read FIND_OPER write FIND_OPER;
    property IND_EMIT: TACBrIndEmit read FIND_EMIT write FIND_EMIT;
    property COD_PART: String read FCOD_PART write FCOD_PART;
    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property COD_SIT: TACBrCodSit read FCOD_SIT write FCOD_SIT;
    property SER: String read FSER write FSER;
    property SUB: String read FSUB write FSUB;
    property NUM_DOC: String read FNUM_DOC write FNUM_DOC;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property DT_A_P: TDateTime read FDT_A_P write FDT_A_P;
    property VL_DOC: currency read FVL_DOC write FVL_DOC;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property VL_SERV: currency read FVL_SERV write FVL_SERV;
    property VL_SERV_NT: currency read FVL_SERV_NT write FVL_SERV_NT;
    property VL_TERC: currency read FVL_TERC write FVL_TERC;
    property VL_DA: currency read FVL_DA write FVL_DA;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property COD_INF: String read FCOD_INF write FCOD_INF;
    property VL_PIS: currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: currency read FVL_COFINS write FVL_COFINS;
    property COD_CTA: String read FCOD_CTA write FCOD_CTA;
    property TP_ASSINANTE: TACBrTipoAssinante read FTP_ASSINANTE write FTP_ASSINANTE;

    property RegistroD510: TRegistroD510List read FRegistroD510 write FRegistroD510;
    property RegistroD530: TRegistroD530List read FRegistroD530 write FRegistroD530;
    property RegistroD590: TRegistroD590List read FRegistroD590 write FRegistroD590;  {Jean Barreiros 04Dez2009}
  end;

  /// Registro D500 - Lista

  TRegistroD500List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD500; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD500); /// SetItem
  public
    function New: TRegistroD500;
    property Items[Index: Integer]: TRegistroD500 read GetItem write SetItem;
  end;

  /// Registro D510

  TRegistroD510 = class
  private
    FNUM_ITEM: String;                  //N�mero sequencial do item no documento fiscal
    FCOD_ITEM: String;                  //C�digo do item (campo 02 do Registro 0200)
    FCOD_CLASS: String;                 //C�digo de classifica��o do item do servi�o de comunica��o ou de telecomunica��o, conforme a Tabela 4.4.1
    FQTD: Currency;                     //Quantidade do item
    FUNID: String;                      //Unidade do item (Campo 02 do registro 0190)
    FVL_ITEM: Currency;                 //Valor do item
    FVL_DESC: Currency;                 //Valor total do desconto
    FCST_ICMS: String;                  //C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1
    FCFOP: String;                      //C�digo Fiscal de Opera��o e Presta��o
    FVL_BC_ICMS: Currency;              //Valor da base de c�lculo do ICMS
    FALIQ_ICMS: Currency;               //Al�quota do ICMS
    FVL_ICMS: Currency;                 //Valor do ICMS creditado/debitado
    FVL_BC_ICMS_UF : Currency;          //Valor da base de c�lculo do ICMS de outras UFs
    FVL_ICMS_UF: Currency;              //Valor do ICMS de outras UFs
    FIND_REC: TACBrIndTipoReceita;      //Indicador do tipo de receita
    FCOD_PART: String;                  //C�digo do participante
    FVL_PIS: Currency;                  //Valor do PIS
    FVL_COFINS: Currency;               //Valor da COFINS
    FCOD_CTA: String;                   //C�digo da conta anal�tica cont�bil debitada/creditada
  public
    property NUM_ITEM: String read FNUM_ITEM write FNUM_ITEM;
    property COD_ITEM: String read FCOD_ITEM write FCOD_ITEM;
    property COD_CLASS: String read FCOD_CLASS write FCOD_CLASS;
    property QTD: Currency read FQTD write FQTD;
    property UNID: String read FUNID write FUNID;
    property VL_ITEM: Currency read FVL_ITEM write FVL_ITEM;
    property VL_DESC: Currency read FVL_DESC write FVL_DESC;
    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property VL_BC_ICMS: Currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property ALIQ_ICMS: Currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_ICMS: Currency read FVL_ICMS write FVL_ICMS;
    property VL_BC_ICMS_UF: Currency read FVL_BC_ICMS_UF write FVL_BC_ICMS_UF;
    property VL_ICMS_UF: Currency read FVL_ICMS_UF write FVL_ICMS_UF;
    property IND_REC: TACBrIndTipoReceita read FIND_REC write FIND_REC;
    property COD_PART: String read FCOD_PART write FCOD_PART;
    property VL_PIS: Currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: Currency read FVL_COFINS write FVL_COFINS;
    property COD_CTA: String read FCOD_CTA write FCOD_CTA;
  end;

  TRegistroD510List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD510; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD510); /// SetItem
  public
    function New: TRegistroD510;
    property Items[Index: Integer]: TRegistroD510 read GetItem write SetItem;
  end;

  /// Registro D530

  TRegistroD530 = class
  private
    FIND_SERV: TACBrServicoPrestado;      //Indicador do tipo de servi�o prestado
    FDT_INI_SERV: TDateTime;              //Data em que se iniciou a presta��o do servi�o
    FDT_FIN_SERV: TDateTime;              //Data em que se encerrou a presta��o do servi�o
    FPER_FISCAL: String;                  //Per�odo fiscal da presta��o do servi�o (MMAAAA)
    FCOD_AREA: String;                    //C�digo de �rea do terminal faturado
    FTERMINAL: String;                    //Identifica��o do terminal faturado
  public
    property IND_SERV: TACBrServicoPrestado read FIND_SERV write FIND_SERV;
    property DT_INI_SERV: TDateTime read FDT_INI_SERV write FDT_INI_SERV;
    property DT_FIN_SERV: TDateTime read FDT_FIN_SERV write FDT_FIN_SERV;
    property PER_FISCAL: String read FPER_FISCAL write FPER_FISCAL;
    property COD_AREA: String read FCOD_AREA write FCOD_AREA;
    property TERMINAL: String read FTERMINAL write FTERMINAL;

  end;

  TRegistroD530List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD530; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD530); /// SetItem
  public
    function New: TRegistroD530;
    property Items[Index: Integer]: TRegistroD530 read GetItem write SetItem;
  end;

  /// Registro D590

  TRegistroD590 = class
  private
    fCST_ICMS: String;        /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1.
    fCFOP: String;            /// C�digo Fiscal de Opera��o e Presta��o do agrupamento de itens
    fALIQ_ICMS: Currency;     /// Al�quota do ICMS
    fVL_OPR: currency;        /// Valor da opera��o correspondente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS.
    fVL_BC_ICMS: currency;    /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_ICMS: currency;       /// Parcela correspondente ao "Valor do ICMS" referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_BC_ICMS_ST: currency; /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" da substitui��o tribut�ria referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_ICMS_ST: currency;    /// Parcela correspondente ao valor creditado/debitado do ICMS da substitui��o tribut�ria, referente � combina��o de CST_ICMS,  CFOP, e al�quota do ICMS.
    fVL_RED_BC: currency;     /// Valor n�o tributado em fun��o da redu��o da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fCOD_OBS: String;         /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
  public
    property CST_ICMS: String read fCST_ICMS write fCST_ICMS;
    property CFOP: String read fCFOP write fCFOP;
    property ALIQ_ICMS: Currency read fALIQ_ICMS write fALIQ_ICMS;
    property VL_OPR: currency read fVL_OPR write fVL_OPR;
    property VL_BC_ICMS: currency read fVL_BC_ICMS write fVL_BC_ICMS;
    property VL_ICMS: currency read fVL_ICMS write fVL_ICMS;
    property VL_BC_ICMS_UF: currency read fVL_BC_ICMS_ST write fVL_BC_ICMS_ST;
    property VL_ICMS_UF: currency read fVL_ICMS_ST write fVL_ICMS_ST;
    property VL_RED_BC: currency read fVL_RED_BC write fVL_RED_BC;
    property COD_OBS: String read fCOD_OBS write fCOD_OBS;
  end;

  TRegistroD590List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD590; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD590); /// SetItem
  public
    function New: TRegistroD590;
    property Items[Index: Integer]: TRegistroD590 read GetItem write SetItem;
  end;

  /// Registro D600

  TRegistroD600 = class
  private
    FRegistroD610: TRegistroD610List;
    FRegistroD690: TRegistroD690List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property RegistroD610: TRegistroD610List read FRegistroD610 write FRegistroD610;
    property RegistroD690: TRegistroD690List read FRegistroD690 write FRegistroD690;
  end;

  TRegistroD600List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD600; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD600); /// SetItem
  public
    function New: TRegistroD600;
    property Items[Index: Integer]: TRegistroD600 read GetItem write SetItem;
  end;

  /// Registro D610

  TRegistroD610 = class
  private
  public
  end;

  TRegistroD610List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD610; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD610); /// SetItem
  public
    function New: TRegistroD610;
    property Items[Index: Integer]: TRegistroD610 read GetItem write SetItem;
  end;

  /// Registro D690

  TRegistroD690 = class
  private
  public
  end;

  TRegistroD690List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD690; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD690); /// SetItem
  public
    function New: TRegistroD690;
    property Items[Index: Integer]: TRegistroD690 read GetItem write SetItem;
  end;

  /// Registro D695

  TRegistroD695 = class
  private
    fCOD_MOD: String; // C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fSER: String;    // S�rie do documento fiscal
    fNRO_ORD_INI: integer;  // N�mero de ordem inicial
    fNRO_ORD_FIN: integer;  // N�mero de ordem final
    fDT_DOC_INI: Tdatetime; // Data de emiss�o inicial dos documentos
    fDT_DOC_FIN: Tdatetime; // Data de emiss�o final dos documentos
    fNOM_MEST:string;      // Nome do arquivo Mestre de Documento Fiscal
    fCHV_COD_DIG:string;   // Chave de codifica��o digital do arquivo Mestre de Documento Fiscal
    FRegistroD696: TRegistroD696List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read fCOD_MOD write fCOD_MOD;
    property SER: String read fSER write fSER;
    property NRO_ORD_INI: integer read fNRO_ORD_INI write fNRO_ORD_INI;
    property NRO_ORD_FIN: integer read fNRO_ORD_FIN write fNRO_ORD_FIN;
    property DT_DOC_INI: Tdatetime read fDT_DOC_INI write fDT_DOC_INI;
    property DT_DOC_FIN: Tdatetime read fDT_DOC_FIN write fDT_DOC_FIN;
    property NOM_MEST: String read fNOM_MEST write fNOM_MEST;
    property CHV_COD_DIG: String read fCHV_COD_DIG write fCHV_COD_DIG;

    property RegistroD696: TRegistroD696List read FRegistroD696 write FRegistroD696;
  end;

  TRegistroD695List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD695; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD695); /// SetItem
  public
    function New: TRegistroD695;
    property Items[Index: Integer]: TRegistroD695 read GetItem write SetItem;
  end;

  /// Registro D696

  TRegistroD696 = class
  private
    fCST_ICMS: String;        /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1.
    fCFOP: String;            /// C�digo Fiscal de Opera��o e Presta��o do agrupamento de itens
    fALIQ_ICMS: Currency;     /// Al�quota do ICMS
    fVL_OPR: currency;        /// Valor da opera��o correspondente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS.
    fVL_BC_ICMS: currency;    /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_ICMS: currency;       /// Parcela correspondente ao "Valor do ICMS" referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_BC_ICMS_UF: currency; /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" da substitui��o tribut�ria referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_ICMS_UF: currency;    /// Parcela correspondente ao valor creditado/debitado do ICMS da substitui��o tribut�ria, referente � combina��o de CST_ICMS,  CFOP, e al�quota do ICMS.
    fVL_RED_BC: currency;     /// Valor n�o tributado em fun��o da redu��o da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fCOD_OBS: String;         /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
    FRegistroD697: TRegistroD697List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property CST_ICMS: String read fCST_ICMS write fCST_ICMS;
    property CFOP: String read fCFOP write fCFOP;
    property ALIQ_ICMS: Currency read fALIQ_ICMS write fALIQ_ICMS;
    property VL_OPR: currency read fVL_OPR write fVL_OPR;
    property VL_BC_ICMS: currency read fVL_BC_ICMS write fVL_BC_ICMS;
    property VL_ICMS: currency read fVL_ICMS write fVL_ICMS;
    property VL_BC_ICMS_UF: currency read fVL_BC_ICMS_UF write fVL_BC_ICMS_UF;
    property VL_ICMS_UF: currency read fVL_ICMS_UF write fVL_ICMS_UF;
    property VL_RED_BC: currency read fVL_RED_BC write fVL_RED_BC;
    property COD_OBS: String read fCOD_OBS write fCOD_OBS;

    property RegistroD697: TRegistroD697List read FRegistroD697 write FRegistroD697;
  end;

  TRegistroD696List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD696; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD696); /// SetItem
  public
    function New: TRegistroD696;
    property Items[Index: Integer]: TRegistroD696 read GetItem write SetItem;
  end;

  /// Registro D697

  TRegistroD697 = class
  private
    fUF: String;              /// Sigla da unidade da federa��o
    fVL_BC_ICMS: currency;    /// Valor da base de c�lculo do ICMS
    fVL_ICMS: currency;       /// Valor do ICMS
  public
    property UF: String read fUF write fUF;
    property VL_BC_ICMS: currency read fVL_BC_ICMS write fVL_BC_ICMS;
    property VL_ICMS: currency read fVL_ICMS write fVL_ICMS;
  end;

  TRegistroD697List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD697; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroD697); /// SetItem
  public
    function New: TRegistroD697;
    property Items[Index: Integer]: TRegistroD697 read GetItem write SetItem;
  end;

  { TRegistroD700 - Nota Fiscal Fatura Eletr�nica de Servi�os de Comunica��o. NFCom (C�digo 62)  }

  TRegistroD700 = class
  private
    FCHV_DOCe: String;         // Chave da Nota Fiscal Fatura de Servi�o de Comunica��o Eletr�nica
    FCHV_DOCe_REF: string;     // Chave da nota referenciada
    fCOD_INF: String;          // C�digo da informa��o complementar do documento fiscal
    FCOD_MOD: String;          // C�digo do modelo do documento fiscal
    FCOD_MOD_DOC_REF: string;  // C�digo do modelo do documento fiscal referenciado
    FCOD_MUN_DEST: String;     // C�digo do munic�pio do destinat�rio conforme a tabela do IBGE
    FCOD_PART: String;         // C�digo do participante
    FCOD_SIT: TACBrCodSit;     // C�digo da situa��o do documento fiscal
    FDED: Currency;            // Dedu��es
    FDT_DOC: TDateTime;        // Data da emiss�o do documento fiscal
    FDT_E_S: TDateTime;        // Data da entrada
    FFIN_DOCe: TACBrFinEmissaoFaturaEletronica;  // Finalidade da emiss�o do documento eletr�nico
    FHASH_DOC_REF: string;     // C�digo de autentica��o digital do registro
    FIND_EMIT: TACBrIndEmit;   // Indicador do emitente do documento fiscal
    FIND_OPER: TACBrIndOper;   // Indicador do tipo de presta��o
    FMES_DOC_REF: string;      // M�s e ano da emiss�o do documento fiscal referenciado
    FNUM_DOC: String;          // N�mero do documento fiscal
    FNUM_DOC_REF: string;      // N�mero do documento fiscal referenciado
    FSER: String;              //
    FSER_DOC_REF: string;      // S�rie do documento fiscal referenciado
    FTIP_FAT: TACBrTipoFaturamentoDocumentoEletronico;  // Tipo de faturamento do documento eletr�nico
    FVL_BC_ICMS: Currency;     // Valor da Base de C�lculo (BC) do ICMS
    FVL_COFINS: Currency;      // Valor do Cofins
    FVL_DA: Currency;          // Valor de despesas acess�rias indicadas no documento fiscal
    FVL_DESC: Currency;        // Valor do Desconto
    FVL_DOC: Currency;         // Valor do Documento Fiscal
    FVL_ICMS: Currency;        // Valor do ICMS
    FVL_PIS: Currency;         // Valor do Pis/Pasep
    FVL_SERV: Currency;        // Valor dos servi�os tributados pelo ICMS
    FVL_SERV_NT: Currency;     // Valores cobrados em nome do prestador sem destaque de ICMS
    FVL_TERC: Currency;        // Valores cobrados em nome de terceiros

    FRegistroD730: TRegistroD730List;
    FRegistroD735: TRegistroD735List;
  public
    constructor Create;
    destructor Destroy; override;

    property IND_OPER: TACBrIndOper read FIND_OPER write FIND_OPER;
    property IND_EMIT: TACBrIndEmit read FIND_EMIT write FIND_EMIT;
    property COD_PART: String read FCOD_PART write FCOD_PART;
    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property COD_SIT: TACBrCodSit read FCOD_SIT write FCOD_SIT;
    property DED: Currency read FDED write FDED;
    property SER: String read FSER write FSER;
    property NUM_DOC: String read FNUM_DOC write FNUM_DOC;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property DT_E_S: TDateTime read FDT_E_S write FDT_E_S;
    property VL_DOC: Currency read FVL_DOC write FVL_DOC;
    property VL_DESC: Currency read FVL_DESC write FVL_DESC;
    property VL_SERV: Currency read FVL_SERV write FVL_SERV;
    property VL_SERV_NT: Currency read FVL_SERV_NT write FVL_SERV_NT;
    property VL_TERC: Currency read FVL_TERC write FVL_TERC;
    property VL_DA: Currency read FVL_DA write FVL_DA;
    property VL_BC_ICMS: Currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: Currency read FVL_ICMS write FVL_ICMS;
    property COD_INF: String read fCOD_INF write fCOD_INF;
    property VL_PIS: Currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: Currency read FVL_COFINS write FVL_COFINS;
    property CHV_DOCe: String read FCHV_DOCe write FCHV_DOCe;
    property FIN_DOCe: TACBrFinEmissaoFaturaEletronica read FFIN_DOCe write FFIN_DOCe;
    property TIP_FAT: TACBrTipoFaturamentoDocumentoEletronico read FTIP_FAT write FTIP_FAT;
    property COD_MOD_DOC_REF: string read FCOD_MOD_DOC_REF write FCOD_MOD_DOC_REF;
    property CHV_DOCe_REF: string read FCHV_DOCe_REF write FCHV_DOCe_REF;
    property HASH_DOC_REF: string read FHASH_DOC_REF write FHASH_DOC_REF;
    property SER_DOC_REF: string read FSER_DOC_REF write FSER_DOC_REF;
    property NUM_DOC_REF: string read FNUM_DOC_REF write FNUM_DOC_REF;
    property MES_DOC_REF: string read FMES_DOC_REF write FMES_DOC_REF;
    property COD_MUN_DEST: String read FCOD_MUN_DEST write FCOD_MUN_DEST;

    property RegistroD730: TRegistroD730List read FRegistroD730 write FRegistroD730;
    property RegistroD735: TRegistroD735List read FRegistroD735 write FRegistroD735;
  end;

  { TRegistroD700List }

  TRegistroD700List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD700;
    procedure SetItem(Index: Integer; const Value: TRegistroD700);
  public
    function New: TRegistroD700;
    property Items[Index: Integer]: TRegistroD700 read GetItem write SetItem;
  end;

  { TRegistroD730 - Registro anal�tico Nota Fiscal Fatura Eletr�nica de Servi�os de Comunica��o. NFCom (C�digo 62) }

  TRegistroD730 = class
  private
    FALIQ_ICMS: Currency;   // Al�quota do ICMS
    FCFOP: String;          // C�digo Fiscal de Opera��o e Presta��o
    FCOD_OBS: String;       // C�digo da observa��o
    FCST_ICMS: String;      // C�digo da Situa��o Tribut�ria
    FVL_BC_ICMS: Currency;  // Parcela correspondente ao "Valor da base de c�lculo do ICMS" referente � combina��o CST_ICMS, CFOP, e al�quota do ICMS
    FVL_ICMS: Currency;     // Parcela correspondente ao "Valor do ICMS" referente � combina��o CST_ICMS, CFOP, e al�quota do ICMS, incluindo o FCP, quando aplic�vel, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS
    FVL_OPR: Currency;      // Valor da presta��o correspondente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS, inclu�das as despesas acess�rias e acr�scimos
    FVL_RED_BC: Currency;   // Valor n�o tributado em fun��o da redu��o da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS

    FRegistroD731: TRegistroD731List;
  public
    constructor Create;
    destructor Destroy; override;

    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: Currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: Currency read FVL_OPR write FVL_OPR;
    property VL_BC_ICMS: Currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: Currency read FVL_ICMS write FVL_ICMS;
    property VL_RED_BC: Currency read FVL_RED_BC write FVL_RED_BC;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;

    property RegistroD731: TRegistroD731List read FRegistroD731 write FRegistroD731;
  end;

  { TRegistroD730List }

  TRegistroD730List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD730;
    procedure SetItem(Index: Integer; const Value: TRegistroD730);
  public
    function New: TRegistroD730;
    property Items[Index: Integer]: TRegistroD730 read GetItem write SetItem;
  end;

  { TRegistroD731 - INFORMA��ES DO FUNDO DE COMBATE � POBREZA. NFCom (C�DIGO 62) }

  TRegistroD731 = class
  private
    FVL_FCP_OP: Currency;  // Valor do Fundo de Combate � Pobreza (FCP) vinculado � opera��o pr�pria, na combina��o de CST_ICMS, CFOP e al�quota do ICMS
  public
    property VL_FCP_OP: Currency read FVL_FCP_OP write FVL_FCP_OP;
  end;

  { TRegistroD731List }

  TRegistroD731List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD731;
    procedure SetItem(Index: Integer; const Value: TRegistroD731);
  public
    function New: TRegistroD731;
    property Items[Index: Integer]: TRegistroD731 read GetItem write SetItem;
  end;

  { TRegistroD735 - OBSERVA��ES DO LAN�AMENTO FISCAL (C�DIGO 62) }

  TRegistroD735 = class
  private
    fCOD_OBS: String;    // C�digo da observa��o do lan�amento fiscal
    fTXT_COMPL: String;  // Descri��o complementar do c�digo de observa��o.

    FRegistroD737: TRegistroD737List;
  public
    constructor Create;
    destructor Destroy; override;

    property COD_OBS: String read fCOD_OBS write fCOD_OBS;
    property TXT_COMPL: String read fTXT_COMPL write fTXT_COMPL;

    property RegistroD737: TRegistroD737List read FRegistroD737 write FRegistroD737;
  end;

  { TRegistroD735List }

  TRegistroD735List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD735;
    procedure SetItem(Index: Integer; const Value: TRegistroD735);
  public
    function New: TRegistroD735;
    property Items[Index: Integer]: TRegistroD735 read GetItem write SetItem;
  end;

  { TRegistroD737 - OUTRAS OBRIGA��ES TRIBUT�RIAS, AJUSTES E INFORMA��ES DE VALORES PROVENIENTES DE DOCUMENTO FISCAL }

  TRegistroD737 = class
  private
    fALIQ_ICMS: Currency;     // Al�quota do ICMS
    fCOD_AJ: String;          // C�digo do ajustes/benef�cio/incentivo
    fCOD_ITEM: String;        // C�digo do item
    fDESCR_COMPL_AJ: String;  // Descri��o complementar do ajuste do documento fiscal
    fVL_BC_ICMS: Currency;    // Base de c�lculo do ICMS
    fVL_ICMS: Currency;       // Valor do ICMS
    fVL_OUTROS: Currency;     // Outros valores
  public
    property COD_AJ: String read fCOD_AJ write fCOD_AJ;
    property DESCR_COMPL_AJ: String read fDESCR_COMPL_AJ write fDESCR_COMPL_AJ;
    property COD_ITEM: String read fCOD_ITEM write fCOD_ITEM;
    property VL_BC_ICMS: Currency read fVL_BC_ICMS write fVL_BC_ICMS;
    property ALIQ_ICMS: Currency read fALIQ_ICMS write fALIQ_ICMS;
    property VL_ICMS: Currency read fVL_ICMS write fVL_ICMS;
    property VL_OUTROS: Currency read fVL_OUTROS write fVL_OUTROS;
  end;

  { TRegistroD737List }

  TRegistroD737List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD737;
    procedure SetItem(Index: Integer; const Value: TRegistroD737);
  public
    function New: TRegistroD737;
    property Items[Index: Integer]: TRegistroD737 read GetItem write SetItem;
  end;

  { TRegistroD750 - ESCRITURA��O CONSOLIDADA DA NOTA FISCAL FATURA ELETR�NICA DE SERVI�OS DE COMUNICA��O. NFCom (C�DIGO 62) }

  TRegistroD750 = class
  private
    FCOD_MOD: String;                        // C�digo do modelo do documento fiscal
    FDED: Currency;                          // Dedu��es
    FDT_DOC: TDateTime;                      // Data da emiss�o dos documentos
    FIND_PREPAGO: TACBrIndicadorFormaPagto;  // Forma de pagamento
    fQTD_CONS: Currency;                     // Quantidade de documentos consolidados neste registro
    FSER: String;                            // S�rie do documento fiscal
    FVL_BC_ICMS: Currency;                   // Valor total da base de c�lculo do ICMS
    FVL_COFINS: Currency;                    // Valor total do COFINS
    FVL_DA: Currency;                        // Valor total das despesas acess�rias
    FVL_DESC: Currency;                      // Valor total dos descontos
    FVL_DOC: Currency;                       // Valor total dos documentos
    FVL_ICMS: Currency;                      // Valor total do ICMS
    FVL_PIS: Currency;                       // Valor total do PIS
    FVL_SERV: Currency;                      // Valor total dos descontos
    FVL_SERV_NT: Currency;                   // Valores cobrados em nome do prestador sem destaque de ICMS
    FVL_TERC: Currency;                      // Valor total cobrado em nome de terceiros

    FRegistroD760: TRegistroD760List;
  public
    constructor Create;
    destructor Destroy; override;

    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property DED: Currency read FDED write FDED;
    property SER: String read FSER write FSER;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property QTD_CONS: Currency read fQTD_CONS write fQTD_CONS;
    property IND_PREPAGO: TACBrIndicadorFormaPagto read FIND_PREPAGO write FIND_PREPAGO;
    property VL_DOC: Currency read FVL_DOC write FVL_DOC;
    property VL_SERV: Currency read FVL_SERV write FVL_SERV;
    property VL_SERV_NT: Currency read FVL_SERV_NT write FVL_SERV_NT;
    property VL_TERC: Currency read FVL_TERC write FVL_TERC;
    property VL_DESC: Currency read FVL_DESC write FVL_DESC;
    property VL_DA: Currency read FVL_DA write FVL_DA;
    property VL_BC_ICMS: Currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: Currency read FVL_ICMS write FVL_ICMS;
    property VL_PIS: Currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: Currency read FVL_COFINS write FVL_COFINS;

    property RegistroD760: TRegistroD760List read FRegistroD760 write FRegistroD760;
  end;

  { TRegistroD750List }

  TRegistroD750List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD750;
    procedure SetItem(Index: Integer; const Value: TRegistroD750);
  public
    function New: TRegistroD750;
    property Items[Index: Integer]: TRegistroD750 read GetItem write SetItem;
  end;

  { TRegistroD760 - REGISTRO ANAL�TICO DA ESCRITURA��O CONSOLIDADA DA NOTA FISCAL FATURA ELETR�NICA DE SERVI�OS DE COMUNICA��O. NFCom (C�DIGO 62) }

  TRegistroD760 = class
  private
    FALIQ_ICMS: Currency;
    FCFOP: String;
    FCOD_OBS: String;
    FCST_ICMS: String;
    FVL_BC_ICMS: Currency;
    FVL_ICMS: Currency;
    FVL_OPR: Currency;
    FVL_RED_BC: Currency;

    FRegistroD761: TRegistroD761List;
  public
    constructor Create;
    destructor Destroy; override;

    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: Currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: Currency read FVL_OPR write FVL_OPR;
    property VL_BC_ICMS: Currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: Currency read FVL_ICMS write FVL_ICMS;
    property VL_RED_BC: Currency read FVL_RED_BC write FVL_RED_BC;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;

    property RegistroD761: TRegistroD761List read FRegistroD761 write FRegistroD761;
  end;

  { TRegistroD760List }

  TRegistroD760List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD760;
    procedure SetItem(Index: Integer; const Value: TRegistroD760);
  public
    function New: TRegistroD760;
    property Items[Index: Integer]: TRegistroD760 read GetItem write SetItem;
  end;

  { TRegistroD761 }

  TRegistroD761 = class
  private
    FVL_FCP_OP: Currency;  // Valor do Fundo de Combate � Pobreza (FCP) vinculado � opera��o pr�pria, na combina��o de CST_ICMS, CFOP e al�quota do ICMS
  public
    property VL_FCP_OP: Currency read FVL_FCP_OP write FVL_FCP_OP;
  end;

  { TRegistroD761List }

  TRegistroD761List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroD761;
    procedure SetItem(Index: Integer; const Value: TRegistroD761);
  public
    function New: TRegistroD761;
    property Items[Index: Integer]: TRegistroD761 read GetItem write SetItem;
  end;

  /// Registro D990 - ENCERRAMENTO DO BLOCO D

  TRegistroD990 = class
  private
    fQTD_LIN_D: Integer; /// Quantidade total de linhas do Bloco D
  public
    property QTD_LIN_D: Integer read fQTD_LIN_D write fQTD_LIN_D;
  end;

implementation

  uses
    ACBrUtil.Strings;

{ TRegistroD100List }

function TRegistroD100List.GetItem(Index: Integer): TRegistroD100;
begin
  Result := TRegistroD100(Inherited Items[Index]);
end;

function TRegistroD100List.New(): TRegistroD100;
begin
  Result := TRegistroD100.Create();
  Add(Result);
end;

procedure TRegistroD100List.SetItem(Index: Integer; const Value: TRegistroD100);
begin
  Put(Index, Value);
end;

{ TRegistroD101List }

function TRegistroD101List.GetItem(Index: Integer): TRegistroD101;
begin
  Result := TRegistroD101(Inherited Items[Index]);
end;

function TRegistroD101List.New: TRegistroD101;
begin
  Result := TRegistroD101.Create;
  Add(Result);
end;

procedure TRegistroD101List.SetItem(Index: Integer; const Value: TRegistroD101);
begin
  Put(Index, Value);
end;

{ TRegistroD110List }

function TRegistroD590List.GetItem(Index: Integer): TRegistroD590;
begin
  Result := TRegistroD590(Inherited Items[Index]);
end;

function TRegistroD590List.New: TRegistroD590;
begin
  Result := TRegistroD590.Create;
  Add(Result);
end;

procedure TRegistroD590List.SetItem(Index: Integer; const Value: TRegistroD590);
begin
  Put(Index, Value);
end;



function TRegistroD110List.GetItem(Index: Integer): TRegistroD110;
begin
  Result := TRegistroD110(Inherited Items[Index]);
end;

function TRegistroD110List.New(): TRegistroD110;
begin
  Result := TRegistroD110.Create();
  Add(Result);
end;

procedure TRegistroD110List.SetItem(Index: Integer; const Value: TRegistroD110);
begin
  Put(Index, Value);
end;

{ TRegistroD120List }

function TRegistroD120List.GetItem(Index: Integer): TRegistroD120;
begin
  Result := TRegistroD120(Inherited Items[Index]);
end;

function TRegistroD120List.New: TRegistroD120;
begin
  Result := TRegistroD120.Create;
  Add(Result);
end;

procedure TRegistroD120List.SetItem(Index: Integer; const Value: TRegistroD120);
begin
  Put(Index, Value);
end;

{ TRegistroD130List }

function TRegistroD130List.GetItem(Index: Integer): TRegistroD130;
begin
  Result := TRegistroD130(Inherited Items[Index]);
end;

function TRegistroD130List.New: TRegistroD130;
begin
  Result := TRegistroD130.Create;
  Add(Result);
end;

procedure TRegistroD130List.SetItem(Index: Integer; const Value: TRegistroD130);
begin
  Put(Index, Value);
end;

{ TRegistroD140List }

function TRegistroD140List.GetItem(Index: Integer): TRegistroD140;
begin
  Result := TRegistroD140(Inherited Items[Index]);
end;

function TRegistroD140List.New: TRegistroD140;
begin
  Result := TRegistroD140.Create;
  Add(Result);
end;

procedure TRegistroD140List.SetItem(Index: Integer; const Value: TRegistroD140);
begin
  Put(Index, Value);
end;

{ TRegistroD150List }

function TRegistroD150List.GetItem(Index: Integer): TRegistroD150;
begin
  Result := TRegistroD150(Inherited Items[Index]);
end;

function TRegistroD150List.New: TRegistroD150;
begin
  Result := TRegistroD150.Create;
  Add(Result);
end;

procedure TRegistroD150List.SetItem(Index: Integer; const Value: TRegistroD150);
begin
  Put(Index, Value);
end;

{ TRegistroD160List }

function TRegistroD160List.GetItem(Index: Integer): TRegistroD160;
begin
  Result := TRegistroD160(Inherited Items[Index]);
end;

function TRegistroD160List.New: TRegistroD160;
begin
  Result := TRegistroD160.Create;
  Add(Result);
end;

procedure TRegistroD160List.SetItem(Index: Integer; const Value: TRegistroD160);
begin
  Put(Index, Value);
end;

{ TRegistroD161List }

function TRegistroD161List.GetItem(Index: Integer): TRegistroD161;
begin
  Result := TRegistroD161(Inherited Items[Index]);
end;

function TRegistroD161List.New: TRegistroD161;
begin
  Result := TRegistroD161.Create;
  Add(Result);
end;

procedure TRegistroD161List.SetItem(Index: Integer; const Value: TRegistroD161);
begin
  Put(Index, Value);
end;

{ TRegistroD162List }

function TRegistroD162List.GetItem(Index: Integer): TRegistroD162;
begin
  Result := TRegistroD162(Inherited Items[Index]);
end;

function TRegistroD162List.New: TRegistroD162;
begin
  Result := TRegistroD162.Create;
  Add(Result);
end;

procedure TRegistroD162List.SetItem(Index: Integer; const Value: TRegistroD162);
begin
  Put(Index, Value);
end;

{ TRegistroD170List }

function TRegistroD170List.GetItem(Index: Integer): TRegistroD170;
begin
  Result := TRegistroD170(Inherited Items[Index]);
end;

function TRegistroD170List.New: TRegistroD170;
begin
  Result := TRegistroD170.Create;
  Add(Result);
end;

procedure TRegistroD170List.SetItem(Index: Integer; const Value: TRegistroD170);
begin
  Put(Index, Value);
end;

{ TRegistroD180List }

function TRegistroD180List.GetItem(Index: Integer): TRegistroD180;
begin
  Result := TRegistroD180(Inherited Items[Index]);
end;

function TRegistroD180List.New: TRegistroD180;
begin
  Result := TRegistroD180.Create;
  Add(Result);
end;

procedure TRegistroD180List.SetItem(Index: Integer; const Value: TRegistroD180);
begin
  Put(Index, Value);
end;

{ TRegistroD190List }

function TRegistroD190List.GetItem(Index: Integer): TRegistroD190;
begin
  Result := TRegistroD190(Inherited Items[Index]);
end;

function TRegistroD190List.New: TRegistroD190;
begin
  Result := TRegistroD190.Create;
  Add(Result);
end;

procedure TRegistroD190List.SetItem(Index: Integer; const Value: TRegistroD190);
begin
  Put(Index, Value);
end;



{ TRegistroD195List }

function TRegistroD195List.GetItem(Index: Integer): TRegistroD195;
begin
  Result := TRegistroD195(Inherited Items[Index]);
end;

function TRegistroD195List.New: TRegistroD195;
begin
  Result := TRegistroD195.Create;
  Add(Result);
end;

procedure TRegistroD195List.SetItem(Index: Integer; const Value: TRegistroD195);
begin
  Put(Index, Value);
end;

{ TRegistroD197List }

function TRegistroD197List.GetItem(Index: Integer): TRegistroD197;
begin
  Result := TRegistroD197(Inherited Items[Index]);
end;

function TRegistroD197List.New: TRegistroD197;
begin
  Result := TRegistroD197.Create;
  Add(Result);
end;

procedure TRegistroD197List.SetItem(Index: Integer; const Value: TRegistroD197);
begin
  Put(Index, Value);
end;


{ TRegistroD300List }

function TRegistroD300List.GetItem(Index: Integer): TRegistroD300;
begin
  Result := TRegistroD300(Inherited Items[Index]);
end;

function TRegistroD300List.New: TRegistroD300;
begin
  Result := TRegistroD300.Create;
  Add(Result);
end;

procedure TRegistroD300List.SetItem(Index: Integer; const Value: TRegistroD300);
begin
  Put(Index, Value);
end;

{ TRegistroD301List }

function TRegistroD301List.GetItem(Index: Integer): TRegistroD301;
begin
  Result := TRegistroD301(Inherited Items[Index]);
end;

function TRegistroD301List.New: TRegistroD301;
begin
  Result := TRegistroD301.Create;
  Add(Result);
end;

procedure TRegistroD301List.SetItem(Index: Integer; const Value: TRegistroD301);
begin
  Put(Index, Value);
end;

{ TRegistroD310List }

function TRegistroD310List.GetItem(Index: Integer): TRegistroD310;
begin
  Result := TRegistroD310(Inherited Items[Index]);
end;

function TRegistroD310List.New: TRegistroD310;
begin
  Result := TRegistroD310.Create;
  Add(Result);
end;

procedure TRegistroD310List.SetItem(Index: Integer; const Value: TRegistroD310);
begin
  Put(Index, Value);
end;

{ TRegistroD350List }

function TRegistroD350List.GetItem(Index: Integer): TRegistroD350;
begin
  Result := TRegistroD350(Inherited Items[Index]);
end;

function TRegistroD350List.New: TRegistroD350;
begin
  Result := TRegistroD350.Create;
  Add(Result);
end;

procedure TRegistroD350List.SetItem(Index: Integer; const Value: TRegistroD350);
begin
  Put(Index, Value);
end;

{ TRegistroD355List }

function TRegistroD355List.GetItem(Index: Integer): TRegistroD355;
begin
  Result := TRegistroD355(Inherited Items[Index]);
end;

function TRegistroD355List.New: TRegistroD355;
begin
  Result := TRegistroD355.Create;
  Add(Result);
end;

procedure TRegistroD355List.SetItem(Index: Integer; const Value: TRegistroD355);
begin
  Put(Index, Value);
end;

{ TRegistroD360List }

function TRegistroD360List.GetItem(Index: Integer): TRegistroD360;
begin
  Result := TRegistroD360(Inherited Items[Index]);
end;

function TRegistroD360List.New: TRegistroD360;
begin
  Result := TRegistroD360.Create;
  Add(Result);
end;

procedure TRegistroD360List.SetItem(Index: Integer; const Value: TRegistroD360);
begin
  Put(Index, Value);
end;

{ TRegistroD365List }

function TRegistroD365List.GetItem(Index: Integer): TRegistroD365;
begin
  Result := TRegistroD365(Inherited Items[Index]);
end;

function TRegistroD365List.New: TRegistroD365;
begin
  Result := TRegistroD365.Create;
  Add(Result);
end;

procedure TRegistroD365List.SetItem(Index: Integer; const Value: TRegistroD365);
begin
  Put(Index, Value);
end;

{ TRegistroD370List }

function TRegistroD370List.GetItem(Index: Integer): TRegistroD370;
begin
  Result := TRegistroD370(Inherited Items[Index]);
end;

function TRegistroD370List.New: TRegistroD370;
begin
  Result := TRegistroD370.Create;
  Add(Result);
end;

procedure TRegistroD370List.SetItem(Index: Integer; const Value: TRegistroD370);
begin
  Put(Index, Value);
end;

{ TRegistroD390List }

function TRegistroD390List.GetItem(Index: Integer): TRegistroD390;
begin
  Result := TRegistroD390(Inherited Items[Index]);
end;

function TRegistroD390List.New: TRegistroD390;
begin
  Result := TRegistroD390.Create;
  Add(Result);
end;

procedure TRegistroD390List.SetItem(Index: Integer; const Value: TRegistroD390);
begin
  Put(Index, Value);
end;

{ TRegistroD400List }

function TRegistroD400List.GetItem(Index: Integer): TRegistroD400;
begin
  Result := TRegistroD400(Inherited Items[Index]);
end;

function TRegistroD400List.New: TRegistroD400;
begin
  Result := TRegistroD400.Create;
  Add(Result);
end;

procedure TRegistroD400List.SetItem(Index: Integer; const Value: TRegistroD400);
begin
  Put(Index, Value);
end;

{ TRegistroD410List }

function TRegistroD410List.GetItem(Index: Integer): TRegistroD410;
begin
  Result := TRegistroD410(Inherited Items[Index]);
end;

function TRegistroD410List.New: TRegistroD410;
begin
  Result := TRegistroD410.Create;
  Add(Result);
end;

procedure TRegistroD410List.SetItem(Index: Integer; const Value: TRegistroD410);
begin
  Put(Index, Value);
end;

{ TRegistroD411List }

function TRegistroD411List.GetItem(Index: Integer): TRegistroD411;
begin
  Result := TRegistroD411(Inherited Items[Index]);
end;

function TRegistroD411List.New: TRegistroD411;
begin
  Result := TRegistroD411.Create;
  Add(Result);
end;

procedure TRegistroD411List.SetItem(Index: Integer; const Value: TRegistroD411);
begin
  Put(Index, Value);
end;

{ TRegistroD420List }

function TRegistroD420List.GetItem(Index: Integer): TRegistroD420;
begin
  Result := TRegistroD420(Inherited Items[Index]);
end;

function TRegistroD420List.New: TRegistroD420;
begin
  Result := TRegistroD420.Create;
  Add(Result);
end;

procedure TRegistroD420List.SetItem(Index: Integer; const Value: TRegistroD420);
begin
  Put(Index, Value);
end;

{ TRegistroD500List }

function TRegistroD500List.GetItem(Index: Integer): TRegistroD500;
begin
  Result := TRegistroD500(Inherited Items[Index]);
end;

function TRegistroD500List.New: TRegistroD500;
begin
  Result := TRegistroD500.Create;
  Add(Result);
end;

procedure TRegistroD500List.SetItem(Index: Integer; const Value: TRegistroD500);
begin
  Put(Index, Value);
end;

{ TRegistroD510List }

function TRegistroD510List.GetItem(Index: Integer): TRegistroD510;
begin
  Result := TRegistroD510(Inherited Items[Index]);
end;

function TRegistroD510List.New: TRegistroD510;
begin
  Result := TRegistroD510.Create;
  Add(Result);
end;

procedure TRegistroD510List.SetItem(Index: Integer; const Value: TRegistroD510);
begin
  Put(Index, Value);
end;

{ TRegistroD530List }

function TRegistroD530List.GetItem(Index: Integer): TRegistroD530;
begin
  Result := TRegistroD530(Inherited Items[Index]);
end;

function TRegistroD530List.New: TRegistroD530;
begin
  Result := TRegistroD530.Create;
  Add(Result);
end;

procedure TRegistroD530List.SetItem(Index: Integer; const Value: TRegistroD530);
begin
  Put(Index, Value);
end;

{ TRegistroD600List }

function TRegistroD600List.GetItem(Index: Integer): TRegistroD600;
begin
  Result := TRegistroD600(Inherited Items[Index]);
end;

function TRegistroD600List.New: TRegistroD600;
begin
  Result := TRegistroD600.Create;
  Add(Result);
end;

procedure TRegistroD600List.SetItem(Index: Integer; const Value: TRegistroD600);
begin
  Put(Index, Value);
end;

{ TRegistroD610List }

function TRegistroD610List.GetItem(Index: Integer): TRegistroD610;
begin
  Result := TRegistroD610(Inherited Items[Index]);
end;

function TRegistroD610List.New: TRegistroD610;
begin
  Result := TRegistroD610.Create;
  Add(Result);
end;

procedure TRegistroD610List.SetItem(Index: Integer; const Value: TRegistroD610);
begin
  Put(Index, Value);
end;

{ TRegistroD690List }

function TRegistroD690List.GetItem(Index: Integer): TRegistroD690;
begin
  Result := TRegistroD690(Inherited Items[Index]);
end;

function TRegistroD690List.New: TRegistroD690;
begin
  Result := TRegistroD690.Create;
  Add(Result);
end;

procedure TRegistroD690List.SetItem(Index: Integer; const Value: TRegistroD690);
begin
  Put(Index, Value);
end;

{ TRegistroD695List }

function TRegistroD695List.GetItem(Index: Integer): TRegistroD695;
begin
  Result := TRegistroD695(Inherited Items[Index]);
end;

function TRegistroD695List.New: TRegistroD695;
begin
  Result := TRegistroD695.Create;
  Add(Result);
end;

procedure TRegistroD695List.SetItem(Index: Integer; const Value: TRegistroD695);
begin
  Put(Index, Value);
end;

{ TRegistroD696List }

function TRegistroD696List.GetItem(Index: Integer): TRegistroD696;
begin
  Result := TRegistroD696(Inherited Items[Index]);
end;

function TRegistroD696List.New: TRegistroD696;
begin
  Result := TRegistroD696.Create;
  Add(Result);
end;

procedure TRegistroD696List.SetItem(Index: Integer; const Value: TRegistroD696);
begin
  Put(Index, Value);
end;

{ TRegistroD697List }

function TRegistroD697List.GetItem(Index: Integer): TRegistroD697;
begin
  Result := TRegistroD697(Inherited Items[Index]);
end;

function TRegistroD697List.New: TRegistroD697;
begin
  Result := TRegistroD697.Create;
  Add(Result);
end;

procedure TRegistroD697List.SetItem(Index: Integer; const Value: TRegistroD697);
begin
  Put(Index, Value);
end;

{ TRegistroD700 }

constructor TRegistroD700.Create;
begin
  FRegistroD730 := TRegistroD730List.Create;
  FRegistroD735 := TRegistroD735List.Create;
end;

destructor TRegistroD700.Destroy;
begin
  FRegistroD730.Free;
  FRegistroD735.Free;
  inherited Destroy;
end;

{ TRegistroD700List }

function TRegistroD700List.GetItem(Index: Integer): TRegistroD700;
begin
  Result := TRegistroD700(Inherited Items[Index]);
end;

procedure TRegistroD700List.SetItem(Index: Integer; const Value: TRegistroD700);
begin
  Put(Index, Value);
end;

function TRegistroD700List.New: TRegistroD700;
begin
  Result := TRegistroD700.Create;
  Add(Result);
end;

{ TRegistroD730 }

constructor TRegistroD730.Create;
begin
  FRegistroD731 := TRegistroD731List.Create;
end;

destructor TRegistroD730.Destroy;
begin
  FRegistroD731.Free;
  inherited Destroy;
end;

{ TRegistroD730List }

function TRegistroD730List.GetItem(Index: Integer): TRegistroD730;
begin
  Result := TRegistroD730(Inherited Items[Index]);
end;

procedure TRegistroD730List.SetItem(Index: Integer; const Value: TRegistroD730);
begin
  Put(Index, Value);
end;

function TRegistroD730List.New: TRegistroD730;
begin
  Result := TRegistroD730.Create;
  Add(Result);
end;

{ TRegistroD731List }

function TRegistroD731List.GetItem(Index: Integer): TRegistroD731;
begin
  Result := TRegistroD731(Inherited Items[Index]);
end;

procedure TRegistroD731List.SetItem(Index: Integer; const Value: TRegistroD731);
begin
  Put(Index, Value);
end;

function TRegistroD731List.New: TRegistroD731;
begin
  Result := TRegistroD731.Create;
  Add(Result);
end;

{ TRegistroD735 }

constructor TRegistroD735.Create;
begin
  FRegistroD737 := TRegistroD737List.Create;
end;

destructor TRegistroD735.Destroy;
begin
  FRegistroD737.Free;
  inherited Destroy;
end;

{ TRegistroD735List }

function TRegistroD735List.GetItem(Index: Integer): TRegistroD735;
begin
  Result := TRegistroD735(Inherited Items[Index]);
end;

procedure TRegistroD735List.SetItem(Index: Integer; const Value: TRegistroD735);
begin
  Put(Index, Value);
end;

function TRegistroD735List.New: TRegistroD735;
begin
  Result := TRegistroD735.Create;
  Add(Result);
end;

{ TRegistroD737List }

function TRegistroD737List.GetItem(Index: Integer): TRegistroD737;
begin
  Result := TRegistroD737(Inherited Items[Index]);
end;

procedure TRegistroD737List.SetItem(Index: Integer; const Value: TRegistroD737);
begin
  Put(Index, Value);
end;

function TRegistroD737List.New: TRegistroD737;
begin
  Result := TRegistroD737.Create;
  Add(Result);
end;

{ TRegistroD750 }

constructor TRegistroD750.Create;
begin
  FRegistroD760 := TRegistroD760List.Create;
end;

destructor TRegistroD750.Destroy;
begin
  FRegistroD760.Free;
  inherited Destroy;
end;

{ TRegistroD750List }

function TRegistroD750List.GetItem(Index: Integer): TRegistroD750;
begin
  Result := TRegistroD750(Inherited Items[Index]);
end;

procedure TRegistroD750List.SetItem(Index: Integer; const Value: TRegistroD750);
begin
  Put(Index, Value);
end;

function TRegistroD750List.New: TRegistroD750;
begin
  Result := TRegistroD750.Create;
  Add(Result);
end;

{ TRegistroD760 }

constructor TRegistroD760.Create;
begin
  FRegistroD761 := TRegistroD761List.Create;
end;

destructor TRegistroD760.Destroy;
begin
  FRegistroD761.Free;
  inherited Destroy;
end;

{ TRegistroD760List }

function TRegistroD760List.GetItem(Index: Integer): TRegistroD760;
begin
  Result := TRegistroD760(Inherited Items[Index]);
end;

procedure TRegistroD760List.SetItem(Index: Integer; const Value: TRegistroD760);
begin
  Put(Index, Value);
end;

function TRegistroD760List.New: TRegistroD760;
begin
  Result := TRegistroD760.Create;
  Add(Result);
end;

{ TRegistroD761List }

function TRegistroD761List.GetItem(Index: Integer): TRegistroD761;
begin
  Result := TRegistroD761(Inherited Items[Index]);
end;

procedure TRegistroD761List.SetItem(Index: Integer; const Value: TRegistroD761);
begin
  Put(Index, Value);
end;

function TRegistroD761List.New: TRegistroD761;
begin
  Result := TRegistroD761.Create;
  Add(Result);
end;

{ TRegistroD500 }

constructor TRegistroD500.Create;
begin
  FRegistroD510 := TRegistroD510List.Create;
  FRegistroD530 := TRegistroD530List.Create;
  FRegistroD590 := TRegistroD590List.Create;  /// BLOCO D - Lista de RegistroD590 (FILHO)
end;

destructor TRegistroD500.Destroy;
begin
  FRegistroD510.Free;
  FRegistroD530.Free;
  FRegistroD590.Free;
  inherited;
end;

{ TRegistroC195 }

constructor TRegistroD195.Create;
begin
   FRegistroD197 := TRegistroD197List.Create;
end;

destructor TRegistroD195.Destroy;
begin
  FRegistroD197.Free;
  inherited;
end;

{ TRegistroD100 }

constructor TRegistroD100.Create();
begin
  inherited Create;
  FRegistroD101 := TRegistroD101List.Create;
  FRegistroD110 := TRegistroD110List.Create;
  FRegistroD130 := TRegistroD130List.Create;
  FRegistroD140 := TRegistroD140List.Create;
  FRegistroD150 := TRegistroD150List.Create;
  FRegistroD160 := TRegistroD160List.Create;
  FRegistroD170 := TRegistroD170List.Create;
  FRegistroD180 := TRegistroD180List.Create;
  FRegistroD190 := TRegistroD190List.Create;  /// BLOCO D - Lista de RegistroD190 (FILHO)
  FRegistroD195 := TRegistroD195List.Create;  /// BLOCO D - Lista de RegistroD195 
end;

destructor TRegistroD100.Destroy;
begin
  FRegistroD101.Free;
  FRegistroD110.Free;
  FRegistroD130.Free;
  FRegistroD140.Free;
  FRegistroD150.Free;
  FRegistroD160.Free;
  FRegistroD170.Free;
  FRegistroD180.Free;
  FRegistroD190.Free;
  FRegistroD195.Free;
  inherited;
end;

{ TRegistroD001 }

constructor TRegistroD001.Create;
begin
  inherited Create;
  FRegistroD100 := TRegistroD100List.Create;
  FRegistroD300 := TRegistroD300List.Create;
  FRegistroD350 := TRegistroD350List.Create;
  FRegistroD400 := TRegistroD400List.Create;
  FRegistroD500 := TRegistroD500List.Create;
  FRegistroD600 := TRegistroD600List.Create;
  FRegistroD695 := TRegistroD695List.Create;
  FRegistroD700 := TRegistroD700List.Create;
  FRegistroD750 := TRegistroD750List.Create;
  IND_MOV := imSemDados;
end;

destructor TRegistroD001.Destroy;
begin
  FRegistroD100.Free;
  FRegistroD300.Free;
  FRegistroD350.Free;
  FRegistroD400.Free;
  FRegistroD500.Free;
  FRegistroD600.Free;
  FRegistroD695.Free;
  FRegistroD700.Free;
  FRegistroD750.Free;
  inherited;
end;

{ TRegistroD110 }

constructor TRegistroD110.Create();
begin
  inherited Create;
  FRegistroD120 := TRegistroD120List.Create;
end;

destructor TRegistroD110.Destroy;
begin
  FRegistroD120.Free;
  inherited;
end;

{ TRegistroD300 }

constructor TRegistroD300.Create;
begin
  FRegistroD301 := TRegistroD301List.Create;
  FRegistroD310 := TRegistroD310List.Create;
end;

destructor TRegistroD300.Destroy;
begin
  RegistroD310.Free;
  inherited;
end;

{ TRegistroD350 }

constructor TRegistroD350.Create;
begin
  FRegistroD355 := TRegistroD355List.Create;
end;

destructor TRegistroD350.Destroy;
begin
  RegistroD355.Free;
  inherited;
end;

{ TRegistroD355 }

constructor TRegistroD355.Create;
begin
  FRegistroD360 := TRegistroD360List.Create;
  FRegistroD365 := TRegistroD365List.Create;
  FRegistroD390 := TRegistroD390List.Create;
end;

destructor TRegistroD355.Destroy;
begin
  FRegistroD360.Free;
  FRegistroD365.Free;
  FRegistroD390.Free;
  inherited;
end;

{ TRegistroD365 }

constructor TRegistroD365.Create;
begin
  FRegistroD370 := TRegistroD370List.Create;
end;

destructor TRegistroD365.Destroy;
begin
  RegistroD370.Free;
  inherited;
end;

{ TRegistroD400 }

constructor TRegistroD400.Create;
begin
  FRegistroD410 := TRegistroD410List.Create;
  FRegistroD420 := TRegistroD420List.Create;
end;

destructor TRegistroD400.Destroy;
begin
  FRegistroD410.Free;
  FRegistroD420.Free;
  inherited;
end;

{ TRegistroD410 }

constructor TRegistroD410.Create;
begin
  FRegistroD411 := TRegistroD411List.Create;
end;

destructor TRegistroD410.Destroy;
begin
  FRegistroD411.Free;
  inherited;
end;

{ TRegistroD600 }

constructor TRegistroD600.Create;
begin
  FRegistroD610 := TRegistroD610List.Create;
  FRegistroD690 := TRegistroD690List.Create;
end;

destructor TRegistroD600.Destroy;
begin
  FRegistroD610.Free;
  FRegistroD690.Free;
  inherited;
end;

{ TRegistroD695 }

constructor TRegistroD695.Create;
begin
  FRegistroD696 := TRegistroD696List.Create;
end;

destructor TRegistroD695.Destroy;
begin
  FRegistroD696.Free;
  inherited;
end;

{ TRegistroD696 }

constructor TRegistroD696.Create;
begin
  FRegistroD697 := TRegistroD697List.Create;
end;

destructor TRegistroD696.Destroy;
begin
  FRegistroD697.Free;
  inherited;
end;

{ TRegistroD160 }

constructor TRegistroD160.Create;
begin
  FRegistroD161 := TRegistroD161List.Create;
  FRegistroD162 := TRegistroD162List.Create;
end;

destructor TRegistroD160.Destroy;
begin
  FRegistroD161.Free;
  FRegistroD162.Free;
  inherited;
end;

{ TRegistroD190 }

procedure TRegistroD190.SetCFOP(const Value: String);
begin
  if FCFOP <> Value then
     FCFOP := TiraPontos(Value);
end;

end.
