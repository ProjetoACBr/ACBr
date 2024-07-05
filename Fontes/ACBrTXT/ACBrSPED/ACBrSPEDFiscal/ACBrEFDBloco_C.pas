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
|* 31/8/2011: Adolfo Jeffeson Fernandes Lopes
|*  - RegistroC400List.LocalizaRegistro - N�mero de s�rie de fabrica��o do ECF
*******************************************************************************}

unit ACBrEFDBloco_C;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrEFDBlocos;

type
  TRegistroC100List = class;
  TRegistroC101List = class;
  TRegistroC105List = class;
  TRegistroC110List = class;
  TRegistroC111List = class;
  TRegistroC112List = class;
  TRegistroC113List = class;
  TRegistroC114List = class;
  TRegistroC115List = class;
  TRegistroC116List = class;
  TRegistroC120List = class;
  TRegistroC130List = class;
  TRegistroC140List = class;
  TRegistroC141List = class;
  TRegistroC160List = class;
  TRegistroC165List = class;
  TRegistroC170List = class;
  TRegistroC171List = class;
  TRegistroC172List = class;
  TRegistroC173List = class;
  TRegistroC174List = class;
  TRegistroC175List = class;
  TRegistroC176List = class;
  TRegistroC177List = class;
  TRegistroC178List = class;
  TRegistroC179List = class;
  TRegistroC180List = class;
  TRegistroC181List = class;
  TRegistroC185List = class;
  TRegistroC186List = class;
  TRegistroC190List = class;
  TRegistroC191List = class;
  TRegistroC195List = class;
  TRegistroC197List = class;
  TRegistroC300List = class;
  TRegistroC310List = class;
  TRegistroC320List = class;
  TRegistroC321List = class;
  TRegistroC330List = class;
  TRegistroC350List = class;
  TRegistroC370List = class;
  TRegistroC380List = class;
  TRegistroC390List = class;
  TRegistroC400List = class;
  TRegistroC405List = class;
  TRegistroC410List = class;
  TRegistroC420List = class;
  TRegistroC425List = class;
  TRegistroC430List = class;
  TRegistroC460List = class;
  TRegistroC465List = class;
  TRegistroC470List = class;
  TRegistroC480List = class;
  TRegistroC490List = class;
  TRegistroC495List = class;
  TRegistroC500List = class;
  TRegistroC510List = class;
  TRegistroC590List = class;
  TRegistroC591List = class;
  TRegistroC595List = class;
  TRegistroC597List = class;
  TRegistroC600List = class;
  TRegistroC601List = class;
  TRegistroC610List = class;
  TRegistroC690List = class;
  TRegistroC700List = class;
  TRegistroC790List = class;
  TRegistroC791List = class;
  TRegistroC800List = class;
  TRegistroC810List = class;
  TRegistroC850List = class;
  TRegistroC855List = class;
  TRegistroC857List = class;
  TRegistroC860List = class;
  TRegistroC870List = class;
  TRegistroC890List = class;
  TRegistroC895List = class;
  TRegistroC897List = class;

  /// Registro C001 - ABERTURA DO BLOCO C

  TRegistroC001 = class(TOpenBlocos)
  private
    FRegistroC100: TRegistroC100List;
    FRegistroC300: TRegistroC300List;
    FRegistroC350: TRegistroC350List;
    FRegistroC400: TRegistroC400List;
    FRegistroC495: TRegistroC495List;
    FRegistroC500: TRegistroC500List;
    FRegistroC600: TRegistroC600List;
    FRegistroC700: TRegistroC700List;
    FRegistroC800: TRegistroC800List; {Altera��o Vers�o 2.0.4 03Mar2011}
    FRegistroC860: TRegistroC860List; {Altera��o Vers�o 2.0.4 03Mar2011}    
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property RegistroC100: TRegistroC100List read FRegistroC100 write FRegistroC100;
    property RegistroC300: TRegistroC300List read FRegistroC300 write FRegistroC300;
    property RegistroC350: TRegistroC350List read FRegistroC350 write FRegistroC350;
    property RegistroC400: TRegistroC400List read FRegistroC400 write FRegistroC400;
    property RegistroC495: TRegistroC495List read FRegistroC495 write FRegistroC495;
    property RegistroC500: TRegistroC500List read FRegistroC500 write FRegistroC500;
    property RegistroC600: TRegistroC600List read FRegistroC600 write FRegistroC600;
    property RegistroC700: TRegistroC700List read FRegistroC700 write FRegistroC700;
    property RegistroC800: TRegistroC800List read FRegistroC800 write FRegistroC800; {Altera��o Vers�o 2.0.4 03Mar2011}
    property RegistroC860: TRegistroC860List read FRegistroC860 write FRegistroC860; {Altera��o Vers�o 2.0.4 03Mar2011}    
  end;

  /// Registro C100 - NOTA FISCAL (C�DIGO 01), NOTA FISCAL AVULSA (C�DIGO 1B), NOTA FISCAL DE PRODUTOR (C�DIGO 04) E NFE (C�DIGO 55)

  TRegistroC100 = class
  private
    fIND_OPER: TACBrIndOper;            /// Indicador do tipo de opera��o: 0- Entrada; 1- Sa�da
    fIND_EMIT: TACBrIndEmit;            /// Indicador do emitente do documento fiscal: 0- Emiss�o pr�pria; 1- Terceiros
    fCOD_PART: String;                  /// C�digo do participante (campo 02 do Registro 0150):
    fCOD_MOD: String;                   /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fCOD_SIT: TACBrCodSit;              /// C�digo da situa��o do documento fiscal, conforme a Tabela 4.1.2
    fSER: String;                       /// S�rie do documento fiscal
    fNUM_DOC: String;                   /// N�mero do documento fiscal
    fCHV_NFE: String;                   /// Chave da Nota Fiscal Eletr�nica
    fDT_DOC: TDateTime;                 /// Data da emiss�o do documento fiscal
    fDT_E_S: TDateTime;                 /// Data da entrada ou da sa�da
    fVL_DOC: currency;                  /// Valor total do documento fiscal
    fIND_PGTO: TACBrIndPgto;            /// Indicador do tipo de pagamento:
    fVL_DESC: currency;                 /// Valor total do desconto // Prates
    fVL_ABAT_NT: currency;              /// Abatimento n�o tributado e n�o comercial Ex. desconto ICMS nas remessas para ZFM: // Prates
    fVL_MERC: currency;                 /// Valor das mercadorias constantes no documento fiscal
    fIND_FRT: TACBrIndFrt;              /// Indicador do tipo do frete:
    fVL_FRT: currency;                  /// Valor do frete indicado no documento fiscal
    fVL_SEG: currency;                  /// Valor do seguro indicado no documento fiscal
    fVL_OUT_DA: currency;               /// Valor de outras despesas acess�rias
    fVL_BC_ICMS: currency;              /// Valor da base de c�lculo do ICMS
    fVL_ICMS: currency;                 /// Valor do ICMS
    fVL_BC_ICMS_ST: currency;           /// Valor da base de c�lculo do ICMS substitui��o tribut�ria
    fVL_ICMS_ST: currency;              /// Valor do ICMS retido por substitui��o tribut�ria
    fVL_IPI: currency;                  /// Valor total do IPI
    fVL_PIS: currency;                  /// Valor total do PIS
    fVL_COFINS: currency;               /// Valor total da COFINS
    fVL_PIS_ST: currency;               /// Valor total do PIS retido por substitui��o tribut�ria
    fVL_COFINS_ST: currency;            /// Valor total da COFINS retido por substitui��o tribut�ria

    FRegistroC101: TRegistroC101List;  /// BLOCO C - Lista de RegistroC105 (FILHO) 
    FRegistroC105: TRegistroC105List;  /// BLOCO C - Lista de RegistroC105 (FILHO)
    FRegistroC110: TRegistroC110List;  /// BLOCO C - Lista de RegistroC110 (FILHO)
    FRegistroC120: TRegistroC120List;  /// BLOCO C - Lista de RegistroC120 (FILHO)
    FRegistroC130: TRegistroC130List;  /// BLOCO C - Lista de RegistroC130 (FILHO)
    FRegistroC140: TRegistroC140List;  /// BLOCO C - Lista de RegistroC140 (FILHO) 
    FRegistroC160: TRegistroC160List;  /// BLOCO C - Lista de RegistroC160 (FILHO)
    FRegistroC165: TRegistroC165List;  /// BLOCO C - Lista de RegistroC165 (FILHO)
    FRegistroC170: TRegistroC170List;  /// BLOCO C - Lista de RegistroC170 (FILHO)
    FRegistroC185: TRegistroC185List;  /// BLOCO C - Lista de RegistroC185 (FILHO)
    FRegistroC186: TRegistroC186List;  /// BLOCO C - Lista de RegistroC186 (FILHO)
    FRegistroC190: TRegistroC190List;  /// BLOCO C - Lista de RegistroC190 (FILHO) 
    FRegistroC195: TRegistroC195List;  /// BLOCO C - Lista de RegistroC195 (FILHO)
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy

    property IND_OPER: TACBrIndOper read FIND_OPER write FIND_OPER;
    property IND_EMIT: TACBrIndEmit read FIND_EMIT write FIND_EMIT;
    property COD_PART: String read FCOD_PART write FCOD_PART;
    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property COD_SIT: TACBrCodSit read FCOD_SIT write FCOD_SIT;
    property SER: String read FSER write FSER;
    property NUM_DOC: String read FNUM_DOC write FNUM_DOC;
    property CHV_NFE: String read FCHV_NFE write FCHV_NFE;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property DT_E_S: TDateTime read FDT_E_S write FDT_E_S;
    property VL_DOC: currency read FVL_DOC write FVL_DOC;
    property IND_PGTO: TACBrIndPgto read FIND_PGTO write FIND_PGTO;
    property VL_DESC: currency read FVL_DESC write FVL_DESC; // prates
    property VL_ABAT_NT: currency read FVL_ABAT_NT write FVL_ABAT_NT; // Prates
    property VL_MERC: currency read FVL_MERC write FVL_MERC;
    property IND_FRT: TACBrIndFrt read FIND_FRT write FIND_FRT;
    property VL_FRT: currency read FVL_FRT write FVL_FRT;
    property VL_SEG: currency read FVL_SEG write FVL_SEG;
    property VL_OUT_DA: currency read FVL_OUT_DA write FVL_OUT_DA;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_BC_ICMS_ST: currency read FVL_BC_ICMS_ST write FVL_BC_ICMS_ST;
    property VL_ICMS_ST: currency read FVL_ICMS_ST write FVL_ICMS_ST;
    property VL_IPI: currency read FVL_IPI write FVL_IPI;
    property VL_PIS: currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: currency read FVL_COFINS write FVL_COFINS;
    property VL_PIS_ST: currency read FVL_PIS_ST write FVL_PIS_ST;
    property VL_COFINS_ST: currency read FVL_COFINS_ST write FVL_COFINS_ST;
    /// Registros FILHOS
	
    property RegistroC101: TRegistroC101List read FRegistroC101 write FRegistroC101;
    property RegistroC105: TRegistroC105List read FRegistroC105 write FRegistroC105;
    property RegistroC110: TRegistroC110List read FRegistroC110 write FRegistroC110;
    property RegistroC120: TRegistroC120List read FRegistroC120 write FRegistroC120;
    property RegistroC130: TRegistroC130List read FRegistroC130 write FRegistroC130;
    property RegistroC140: TRegistroC140List read FRegistroC140 write FRegistroC140;
    property RegistroC160: TRegistroC160List read FRegistroC160 write FRegistroC160;
    property RegistroC165: TRegistroC165List read FRegistroC165 write FRegistroC165;
    property RegistroC170: TRegistroC170List read FRegistroC170 write FRegistroC170;
    property RegistroC185: TRegistroC185List read FRegistroC185 write FRegistroC185;
    property RegistroC186: TRegistroC186List read FRegistroC186 write FRegistroC186;
    property RegistroC190: TRegistroC190List read FRegistroC190 write FRegistroC190;
    property RegistroC195: TRegistroC195List read FRegistroC195 write FRegistroC195;
  end;

  /// Registro C100 - Lista

  TRegistroC100List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC100; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC100); /// SetItem
  public
    function New(): TRegistroC100;
    property Items[Index: Integer]: TRegistroC100 read GetItem write SetItem;
  end;
  
  // REGISTRO C101 - EC 87/2015 -

  TRegistroC101 = class
  private
    fVL_FCP_UF_DEST : currency; // VLR FUNDO DE COMBATE A POBREZA UF DE DESTINO
    fVL_ICMS_UF_DEST : currency; // VLR TOTAL ICMS INTERESTADUAL PARA A UF DE DESTINO
    fVL_ICMS_UF_REM : currency; // VLR TOTAL ICMS INTERESTADUAL PARA A UF DO REMETENTE

  public
    property VL_FCP_UF_DEST: currency read fVL_FCP_UF_DEST write fVL_FCP_UF_DEST;
	property VL_ICMS_UF_DEST: currency read fVL_ICMS_UF_DEST write fVL_ICMS_UF_DEST;	
	property VL_ICMS_UF_REM: currency read fVL_ICMS_UF_REM write fVL_ICMS_UF_REM;		
	
  end;

  /// Registro C101 - EC 87/2015
  
  TRegistroC101List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC101; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC101); /// SetItem
  public
    function New: TRegistroC101;
    property Items[Index: Integer]: TRegistroC101 read GetItem write SetItem;
  end;


  /// Registro C105 - OPERA��ES COM ICMS ST RECOLHIDO PARA UF DIVERSA DO DESTINAT�RIO DO DOCUMENTO FISCAL (C�DIGO 55).

  TRegistroC105 = class
  private
    fOPER: TACBrIndOperST; /// Indicador do tipo de opera��o. 0- Combust�veis e Lubrificantes; 1- leasing de ve�culos ou faturamento direto.
    fUF: String;                /// Sigla da UF de destino do ICMS_ST
  public
    constructor Create(AOwner: TRegistroC100); virtual; /// Create

    property OPER: TACBrIndOperST read fOPER write fOPER;
    property UF: String read fUF write fUF;
  end;

  /// Registro C105 - Lista

  TRegistroC105List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC105; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC105); /// SetItem
  public
    function New(AOwner: TRegistroC100): TRegistroC105;
    property Items[Index: Integer]: TRegistroC105 read GetItem write SetItem;
  end;

  /// Registro C110 - INFORMA��O COMPLEMENTAR DA NOTA FISCAL (C�DIGO 01; 1B, 04 e 55)

  TRegistroC110 = class
  private
    fCOD_INF: String;       /// C�digo da informa��o complementar do documento fiscal (campo 02 do Registro 0450)
    fTXT_COMPL: String;    /// Descri��o complementar do c�digo de refer�ncia.

    FRegistroC111: TRegistroC111List;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO)
    FRegistroC112: TRegistroC112List;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO)
    FRegistroC113: TRegistroC113List;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO)
    FRegistroC114: TRegistroC114List;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO)
    FRegistroC115: TRegistroC115List;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO)
    FRegistroC116: TRegistroC116List;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO) {Altera��o Vers�o 2.0.4 03Mar2011}
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_INF: String read FCOD_INF write FCOD_INF;
    property TXT_COMPL: String read FTXT_COMPL write FTXT_COMPL;
    /// Resgistro FILHO do FILHO
    property RegistroC111: TRegistroC111List read FRegistroC111 write FRegistroC111;
    property RegistroC112: TRegistroC112List read FRegistroC112 write FRegistroC112;
    property RegistroC113: TRegistroC113List read FRegistroC113 write FRegistroC113;
    property RegistroC114: TRegistroC114List read FRegistroC114 write FRegistroC114;
    property RegistroC115: TRegistroC115List read FRegistroC115 write FRegistroC115;
    property RegistroC116: TRegistroC116List read FRegistroC116 write FRegistroC116; {Altera��o Vers�o 2.0.4 03Mar2011}
  end;

  /// Registro C110 - Lista

  TRegistroC110List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC110; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC110); /// SetItem
  public
    function New(): TRegistroC110;
    property Items[Index: Integer]: TRegistroC110 read GetItem write SetItem;
  end;

  /// Registro C111 - PROCESSO REFERENCIADO

  TRegistroC111 = class
  private
    fNUM_PROC: String;              /// Identifica��o do processo ou ato concess�rio
    fIND_PROC: TACBrOrigemProcesso; /// Indicador da origem do processo:
  public
    property NUM_PROC: String read FNUM_PROC write FNUM_PROC;
    property IND_PROC: TACBrOrigemProcesso read FIND_PROC write FIND_PROC;
  end;

  /// Registro C111 - Lista

  TRegistroC111List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC111; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC111); /// SetItem
  public
    function New: TRegistroC111;
    property Items[Index: Integer]: TRegistroC111 read GetItem write SetItem;
  end;

  /// Registro C112 - DOCUMENTO DE ARRECADA��O REFERENCIADO

  TRegistroC112 = class
  private
    fCOD_DA: TACBrDoctoArrecada;   /// C�digo do modelo do documento de arrecada��o :
    fUF: String;                   /// Unidade federada benefici�ria do recolhimento
    fNUM_DA: String;               /// N�mero do documento de arrecada��o
    fCOD_AUT: String;              /// C�digo completo da autentica��o banc�ria
    fVL_DA: Currency;              /// Valor do total do documento de arrecada��o (principal, atualiza��o monet�ria, juros e multa) // Prates
    fDT_VCTO: TDateTime;           /// Data de vencimento do documento de arrecada��o
    fDT_PGTO: TDateTime;           /// Data de pagamento do documento de arrecada��o, ou data do vencimento, no caso de ICMS antecipado a recolher.
  public
    property COD_DA: TACBrDoctoArrecada read FCOD_DA write FCOD_DA;
    property UF: String read FUF write FUF;
    property NUM_DA: String read FNUM_DA write FNUM_DA;
    property COD_AUT: String read FCOD_AUT write FCOD_AUT;
    property VL_DA: currency read FVL_DA write FVL_DA; // Prats
    property DT_VCTO: TDateTime read FDT_VCTO write FDT_VCTO;
    property DT_PGTO: TDateTime read FDT_PGTO write FDT_PGTO;
  end;

  /// Registro C112 - Lista

  TRegistroC112List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC112; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC112); /// SetItem
  public
    function New: TRegistroC112;
    property Items[Index: Integer]: TRegistroC112 read GetItem write SetItem;
  end;

  /// Registro C113 - DOCUMENTO FISCAL REFERENCIADO

  TRegistroC113 = class
  private
    fIND_OPER: TACBrIndOper;   /// Indicador do tipo de opera��o: 0 - Entrada/aquisi��o; 1- Sa�da/presta��o
    fIND_EMIT: TACBrIndEmit;       /// Indicador do emitente do t�tulo: 0 - Emiss�o pr�pria; 1- Terceiros
    fCOD_PART: String;              /// C�digo do participante emitente (campo 02 do Registro 0150)  do documento referenciado.
    fCOD_MOD: String;               /// C�digo do documento fiscal, conforme a Tabela 4.1.1
    fSER: String;                   /// S�rie do documento fiscal
    fSUB: String;                   /// Subs�rie do documento fiscal
    fNUM_DOC: String;               /// N�mero do documento fiscal
    fDT_DOC: TDateTime;             /// Data da emiss�o do documento fiscal.
    fCHV_DOCe: string;              /// Chave do Documento Eletr�nico
  public
    property IND_OPER: TACBrIndOper read fIND_OPER write fIND_OPER;
    property IND_EMIT: TACBrIndEmit read fIND_EMIT write fIND_EMIT;
    property COD_PART: String read fCOD_PART write fCOD_PART;
    property COD_MOD: String read fCOD_MOD write fCOD_MOD;
    property SER: String read fSER write fSER;
    property SUB: String read fSUB write fSUB;
    property NUM_DOC: String read fNUM_DOC write fNUM_DOC;
    property DT_DOC: TDateTime read fDT_DOC write fDT_DOC;
    property CHV_DOCe: String read fCHV_DOCe write fCHV_DOCe;
  end;

  /// Registro C113 - Lista

  TRegistroC113List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC113; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC113); /// SetItem
  public
    function New: TRegistroC113;
    property Items[Index: Integer]: TRegistroC113 read GetItem write SetItem;
  end;

  /// Registro C114 - CUPOM FISCAL REFERENCIADO

  TRegistroC114 = class
  private
    fCOD_MOD: String;        /// C�digo do modelo do documento fiscal, conforme a tabela indicada no item 4.1.1
    fECF_FAB: String;        /// N�mero de s�rie de fabrica��o do ECF
    fECF_CX: String;         /// N�mero do caixa atribu�do ao ECF
    fNUM_DOC: String;        /// N�mero do documento fiscal
    fDT_DOC: TDateTime;      /// Data da emiss�o do documento fiscal
  public
    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property ECF_FAB: String read FECF_FAB write FECF_FAB;
    property ECF_CX: String read FECF_CX write FECF_CX;
    property NUM_DOC: String read FNUM_DOC write FNUM_DOC;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
  end;

  /// Registro C114 - Lista

  TRegistroC114List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC114; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC114); /// SetItem
  public
    function New: TRegistroC114;
    property Items[Index: Integer]: TRegistroC114 read GetItem write SetItem;
  end;

  /// Registro C115 - LOCAL DA COLETA E ENTREGA (C�DIGO 01, 1B E 04)

  TRegistroC115 = class
  private
    fIND_CARGA: TACBrTipoTransporte;     /// Indicador do tipo de transporte da carga coletada: 0 - Rodovi�rio; 1 - Ferrovi�rio; 2 - Rodo-Ferrovi�rio; 3 - Aquavi�rio; 4 - Dutovi�rio; 5 - A�reo; 9 - Outros.
    fCNPJ_COL: String;                   /// N�mero do CNPJ do contribuinte do local de coleta
    fIE_COL: String;                     /// Inscri��o Estadual do contribuinte do local de coleta
    fCPF_COL: String;                    /// CPF do contribuinte do local de coleta das mercadorias.
    fCOD_MUN_COL: String;                /// C�digo do Munic�pio do local de coleta
    fCNPJ_ENTG: String;                  /// N�mero do CNPJ do contribuinte do local de entrega
    fIE_ENTG: String;                    /// Inscri��o Estadual do contribuinte do local de entrega
    fCPF_ENTG: String;                   /// Cpf do contribuinte do local de entrega
    fCOD_MUN_ENTG: String;               /// C�digo do Munic�pio do local de entrega
  public
    property IND_CARGA: TACBrTipoTransporte read FIND_CARGA write FIND_CARGA;
    property CNPJ_COL: String read FCNPJ_COL write FCNPJ_COL;
    property IE_COL: String read FIE_COL write FIE_COL;
    property CPF_COL: String read FCPF_COL write FCPF_COL;
    property COD_MUN_COL: String read FCOD_MUN_COL write FCOD_MUN_COL;
    property CNPJ_ENTG: String read FCNPJ_ENTG write FCNPJ_ENTG;
    property IE_ENTG: String read FIE_ENTG write FIE_ENTG;
    property CPF_ENTG: String read FCPF_ENTG write FCPF_ENTG;
    property COD_MUN_ENTG: String read FCOD_MUN_ENTG write FCOD_MUN_ENTG;
  end;

  /// Registro C115 - Lista

  TRegistroC115List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC115; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC115); /// SetItem
  public
    function New: TRegistroC115;
    property Items[Index: Integer]: TRegistroC115 read GetItem write SetItem;
  end;

  /// Registro C116 - CUPOM FISCAL ELETR�NICO REFERENCIADO {Altera��o Vers�o 2.0.4 03Mar2011}

  TRegistroC116 = class
  private
    fCOD_MOD: String;                   /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fNR_SAT: String;                    /// N�mero de S�rie do equipamento SAT
    fCHV_CFE: String;                   /// Chave do Cupom Fiscal Eletr�nico
    fNUM_CFE: String;                   /// N�mero do cupom fiscal eletr�nico
    fDT_DOC: TDateTime;                 /// Data da emiss�o do documento fiscal
  public
    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property NR_SAT: String read FNR_SAT write FNR_SAT;
    property CHV_CFE: String read FCHV_CFE write FCHV_CFE;
    property NUM_CFE: String read FNUM_CFE write FNUM_CFE;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
  end;

  /// Registro C116 - Lista

  TRegistroC116List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC116; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC116); /// SetItem
  public
    function New: TRegistroC116;
    property Items[Index: Integer]: TRegistroC116 read GetItem write SetItem;
  end;

  /// Registro C120 - OPERA��ES DE IMPORTA��O (C�DIGO 01)

  TRegistroC120 = class
  private
    fCOD_DOC_IMP: TACBrDoctoImporta;  /// Documento de importa��o:
    fNUM_DOC__IMP: String;            /// N�mero do documento de Importa��o.
    fPIS_IMP: currency;               /// Valor pago de PIS na importa��o
    fCOFINS_IMP: currency;            /// Valor pago de COFINS na importa��o
    fNUM_ACDRAW: String;              /// Numero do Ato Concess�rio ro regime Drawback public
  public
    property COD_DOC_IMP: TACBrDoctoImporta read FCOD_DOC_IMP write FCOD_DOC_IMP;
    property NUM_DOC__IMP: String read FNUM_DOC__IMP write FNUM_DOC__IMP;
    property PIS_IMP: currency read FPIS_IMP write FPIS_IMP;
    property COFINS_IMP: currency read FCOFINS_IMP write FCOFINS_IMP;
    property NUM_ACDRAW: String read fNUM_ACDRAW write fNUM_ACDRAW;
  end;

  /// Registro C120 - Lista

  TRegistroC120List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC120; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC120); /// SetItem
  public
    function New: TRegistroC120;
    property Items[Index: Integer]: TRegistroC120 read GetItem write SetItem;
  end;

  /// Registro C130 - ISSQN, IRRF E PREVID�NCIA SOCIAL

  TRegistroC130 = class
  private
    fVL_SERV_NT: currency;     /// Valor dos servi�os sob n�o-incid�ncia ou n�o-tributados pelo ICMS
    fVL_BC_ISSQN: currency;    /// Valor da base de c�lculo do ISSQN
    fVL_ISSQN: currency;       /// Valor do ISSQN
    fVL_BC_IRRF: currency;     /// Valor da base de c�lculo do Imposto de Renda Retido na Fonte
    fVL_IRRF: currency;        /// Valor do Imposto de Renda - Retido na Fonte
    fVL_BC_PREV: currency;     /// Valor da base de c�lculo de reten��o da Previd�ncia Social
    fVL_PREV: currency;        /// Valor destacado para reten��o da Previd�ncia Social
  public
    property VL_SERV_NT: currency read FVL_SERV_NT write FVL_SERV_NT;
    property VL_BC_ISSQN: currency read FVL_BC_ISSQN write FVL_BC_ISSQN;
    property VL_ISSQN: currency read FVL_ISSQN write FVL_ISSQN;
    property VL_BC_IRRF: currency read FVL_BC_IRRF write FVL_BC_IRRF;
    property VL_IRRF: currency read FVL_IRRF write FVL_IRRF;
    property VL_BC_PREV: currency read FVL_BC_PREV write FVL_BC_PREV;
    property VL_PREV: currency read FVL_PREV write FVL_PREV;
  end;

  /// Registro C130 - Lista

  TRegistroC130List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC130; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC130); /// SetItem
  public
    function New: TRegistroC130;
    property Items[Index: Integer]: TRegistroC130 read GetItem write SetItem;
  end;

  /// Registro C140 - FATURA (C�DIGO 01)

  TRegistroC140 = class
  private
    fIND_EMIT: TACBrIndEmit;  /// Indicador do emitente do t�tulo: 0- Emiss�o pr�pria; 1- Terceiros
    fIND_TIT: TACBrTipoTitulo; /// Indicador do tipo de t�tulo de cr�dito: 00- Duplicata; 01- Cheque; 02- Promiss�ria; 03- Recibo; 99- Outros (descrever)
    fDESC_TIT: String;         /// Descri��o complementar do t�tulo de cr�dito
    fNUM_TIT: String;          /// N�mero ou c�digo identificador do t�tulo de cr�dito
    fQTD_PARC: Integer;        /// Quantidade de parcelas a receber/pagar
    fVL_TIT: currency;         /// Valor original do t�tulo de cr�dito

    FRegistroC141: TRegistroC141List;  /// BLOCO C - Lista de RegistroC141 (FILHO fo FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property IND_EMIT: TACBrIndEmit read FIND_EMIT write FIND_EMIT;
    property IND_TIT: TACBrTipoTitulo read FIND_TIT write FIND_TIT;
    property DESC_TIT: String read FDESC_TIT write FDESC_TIT;
    property NUM_TIT: String read FNUM_TIT write FNUM_TIT;
    property QTD_PARC: Integer read FQTD_PARC write FQTD_PARC;
    property VL_TIT: currency read FVL_TIT write FVL_TIT;
    /// Registros FILHOS
    property RegistroC141: TRegistroC141List read FRegistroC141 write FRegistroC141; 
  end;

  /// Registro C140 - Lista

  TRegistroC140List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC140; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC140); /// SetItem
  public
    function New: TRegistroC140;
    property Items[Index: Integer]: TRegistroC140 read GetItem write SetItem;
  end;

  /// Registro C141 - VENCIMENTO DA FATURA (C�DIGO 01)

  TRegistroC141 = class
  private
    fNUM_PARC: String;       /// N�mero da parcela a receber/pagar
    fDT_VCTO: TDateTime;     /// Data de vencimento da parcela
    fVL_PARC: currency;      /// Valor da parcela a receber/pagar
  public
    property NUM_PARC: String read FNUM_PARC write FNUM_PARC;
    property DT_VCTO: TDateTime read FDT_VCTO write FDT_VCTO;
    property VL_PARC: currency read FVL_PARC write FVL_PARC;
  end;

  /// Registro C141 - Lista

  TRegistroC141List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC141; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC141); /// SetItem
  public
    function New: TRegistroC141;
    property Items[Index: Integer]: TRegistroC141 read GetItem write SetItem;
  end;

  /// Registro C160 - VOLUMES TRANSPORTADOS (C�DIGO 01 E 04) - EXCETO COMBUST�VEIS.

  TRegistroC160 = class
  private
    fCOD_PART: String;      /// C�digo do participante (campo 02 do Registro 0150):
    fVEIC_ID: String;       /// Placa de identifica��o do ve�culo
    fQTD_VOL: Integer;      /// Quantidade de volumes transportados
    fPESO_BRT: currency;    /// Peso bruto dos volumes transportados (em Kg)
    fPESO_LIQ: currency;    /// Peso l�quido dos volumes transportados (em Kg)
    fUF_ID: String;         /// Sigla da UF da placa do ve�culo
  public
    property COD_PART: String read FCOD_PART write FCOD_PART;
    property VEIC_ID: String read FVEIC_ID write FVEIC_ID;
    property QTD_VOL: Integer read FQTD_VOL write FQTD_VOL;
    property PESO_BRT: currency read FPESO_BRT write FPESO_BRT;
    property PESO_LIQ: currency read FPESO_LIQ write FPESO_LIQ;
    property UF_ID: String read FUF_ID write FUF_ID;
  end;

  /// Registro C160 - Lista

  TRegistroC160List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC160; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC160); /// SetItem
  public
    function New: TRegistroC160;
    property Items[Index: Integer]: TRegistroC160 read GetItem write SetItem;
  end;

  /// Registro C165 - OPERA��ES COM COMBUST�VEIS(C�DIGO 01; 55)

  TRegistroC165 = class
  private
    fCOD_PART: String;      /// C�digo do participante (campo 02 do Registro 0150):
    fVEIC_ID: String;       /// Placa de identifica��o do ve�culo
    fCOD_AUT: String;       /// C�digo da autoriza��o fornecido pela SEFAZ (combust�veis)
    fNR_PASSE: String;      /// N�mero do Passe Fiscal
    fHORA: String;          /// Hora da sa�da das mercadorias
    fTEMPER: String;        /// Temperatura em graus Celsius utilizada para quantifica��o do volume de combust�vel
    fQTD_VOL: Integer;      /// Quantidade de volumes transportados
    fPESO_BRT: currency;    /// Peso bruto dos volumes transportados (em Kg)
    fPESO_LIQ: currency;    /// Peso l�quido dos volumes transportados (em Kg)
    fNOM_MOT: String;       /// Nome do motorista
    fCPF: String;           /// CPF do motorista
    fUF_ID: String;         /// Sigla da UF da placa do ve�culo
  public
    property COD_PART: String read FCOD_PART write FCOD_PART;
    property VEIC_ID: String read FVEIC_ID write FVEIC_ID;
    property COD_AUT: String read FCOD_AUT write FCOD_AUT;
    property NR_PASSE: String read FNR_PASSE write FNR_PASSE;
    property HORA: String read FHORA write FHORA;
    property TEMPER: String read FTEMPER write FTEMPER;
    property QTD_VOL: Integer read FQTD_VOL write FQTD_VOL;
    property PESO_BRT: currency read FPESO_BRT write FPESO_BRT;
    property PESO_LIQ: currency read FPESO_LIQ write FPESO_LIQ;
    property NOM_MOT: String read FNOM_MOT write FNOM_MOT;
    property CPF: String read FCPF write FCPF;
    property UF_ID: String read FUF_ID write FUF_ID;
  end;

  /// Registro C165 - Lista

  TRegistroC165List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC165; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC165); /// SetItem
  public
    function New: TRegistroC165;
    property Items[Index: Integer]: TRegistroC165 read GetItem write SetItem;
  end;

  /// Registro C170 - ITENS DO DOCUMENTO (C�DIGO 01, 1B, 04 e 55)

  TRegistroC170 = class
  private
    fNUM_ITEM: String;                    /// N�mero seq�encial do item no documento fiscal
    fCOD_ITEM: String;                    /// C�digo do item (campo 02 do Registro 0200)
    fDESCR_COMPL: String;                 /// Descri��o complementar do item como adotado no documento fiscal
    fQTD: Double;                         /// Quantidade do item
    fUNID: String;                        /// Unidade do item(Campo 02 do registro 0190)
    fVL_ITEM: currency;                   /// Valor total do item
    fVL_DESC: currency;                   /// Valor do desconto comercial
    fIND_MOV: TACBrMovimentacaoFisica;    /// Movimenta��o f�sica do ITEM/PRODUTO: 0 - SIM; 1- N�O
    fCST_ICMS: String;                    /// C�digo da Situa��o Tribut�ria referente ao ICMS, conforme a Tabela indicada no item 4.3.1
    fCFOP: String;                        /// C�digo Fiscal de Opera��o e Presta��o
    fCOD_NAT: String;                     /// C�digo da natureza da opera��o (campo 02 do Registro 0400)
    fVL_BC_ICMS: currency;                /// Valor da base de c�lculo do ICMS
    fALIQ_ICMS: currency;                 /// Al�quota do ICMS
    fVL_ICMS: currency;                   /// Valor do ICMS creditado/debitado
    fVL_BC_ICMS_ST: currency;             /// Valor da base de c�lculo referente � substitui��o tribut�ria
    fALIQ_ST: currency;                   /// Al�quota do ICMS da substitui��o tribut�ria na unidade da federa��o de destino
    fVL_ICMS_ST: currency;                /// Valor do ICMS referente � substitui��o tribut�ria
    fIND_APUR: TACBrApuracaoIPI;          /// Indicador de per�odo de apura��o do IPI: 0 - Mensal; 1 - Decendial
//    fCST_IPI: TACBrSituacaoTribIPI;       /// C�digo da Situa��o Tribut�ria referente ao IPI, conforme a Tabela indicada no item 4.3.2.
    fCST_IPI: string;                     /// C�digo da Situa��o Tribut�ria referente ao IPI, conforme a Tabela indicada no item 4.3.2.
    fCOD_ENQ: String;                     /// C�digo de enquadramento legal do IPI, conforme tabela indicada no item 4.5.3.
    fVL_BC_IPI: currency;                 /// Valor da base de c�lculo do IPI
    fALIQ_IPI: currency;                  /// Al�quota do IPI
    fVL_IPI: currency;                    /// Valor do IPI creditado/debitado
//    fCST_PIS: TACBrSituacaoTribPIS;       /// C�digo da Situa��o Tribut�ria referente ao PIS.
    fCST_PIS: string;                     /// C�digo da Situa��o Tribut�ria referente ao PIS.
    fVL_BC_PIS: currency;                 /// Valor da base de c�lculo do PIS
    fALIQ_PIS_PERC: currency;             /// Al�quota do PIS (em percentual)
    fQUANT_BC_PIS: Double;                /// Quantidade - Base de c�lculo PIS
    fALIQ_PIS_R: Double;                  /// Al�quota do PIS (em reais)
    fVL_PIS: currency;                    /// Valor do PIS
//    fCST_COFINS: TACBrSituacaoTribCOFINS; /// C�digo da Situa��o Tribut�ria referente ao COFINS.
    fCST_COFINS: string;                  /// C�digo da Situa��o Tribut�ria referente ao COFINS.
    fVL_BC_COFINS: currency;              /// Valor da base de c�lculo da COFINS
    fALIQ_COFINS_PERC: currency;          /// Al�quota do COFINS (em percentual)
    fQUANT_BC_COFINS: Double;             /// Quantidade - Base de c�lculo COFINS
    fALIQ_COFINS_R: Double;               /// Al�quota da COFINS (em reais)
    fVL_COFINS: currency;                 /// Valor da COFINS
    fCOD_CTA: String;                     /// C�digo da conta anal�tica cont�bil debitada/creditada
    fVL_ABAT_NT: currency;                /// Valor do abatimento n�o tributado e n�o comercial

    FRegistroC171: TRegistroC171List;  /// BLOCO C - Lista de RegistroC171 (FILHO fo FILHO)
    FRegistroC172: TRegistroC172List;  /// BLOCO C - Lista de RegistroC172 (FILHO fo FILHO)
    FRegistroC173: TRegistroC173List;  /// BLOCO C - Lista de RegistroC173 (FILHO fo FILHO)
    FRegistroC174: TRegistroC174List;  /// BLOCO C - Lista de RegistroC174 (FILHO fo FILHO)
    FRegistroC175: TRegistroC175List;  /// BLOCO C - Lista de RegistroC175 (FILHO fo FILHO)
    FRegistroC176: TRegistroC176List;  /// BLOCO C - Lista de RegistroC176 (FILHO fo FILHO)
    FRegistroC177: TRegistroC177List;  /// BLOCO C - Lista de RegistroC177 (FILHO fo FILHO)
    FRegistroC178: TRegistroC178List;  /// BLOCO C - Lista de RegistroC178 (FILHO fo FILHO)
    FRegistroC179: TRegistroC179List;  /// BLOCO C - Lista de RegistroC179 (FILHO fo FILHO)
    FRegistroC180: TRegistroC180List;  /// BLOCO C - Lista de RegistroC180 (FILHO fo FILHO)
    FRegistroC181: TRegistroC181List;  /// BLOCO C - Lista de RegistroC181 (FILHO fo FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property NUM_ITEM: String                    read FNUM_ITEM         write FNUM_ITEM;
    property COD_ITEM: String                    read FCOD_ITEM         write FCOD_ITEM;
    property DESCR_COMPL: String                 read FDESCR_COMPL      write FDESCR_COMPL;
    property QTD: Double                         read FQTD              write FQTD;
    property UNID: String                        read FUNID             write FUNID;
    property VL_ITEM: currency                   read FVL_ITEM          write FVL_ITEM;
    property VL_DESC: currency                   read FVL_DESC          write FVL_DESC;
    property IND_MOV: TACBrMovimentacaoFisica    read FIND_MOV          write FIND_MOV;
    property CST_ICMS: String                    read FCST_ICMS         write FCST_ICMS;
    property CFOP: String                        read FCFOP             write FCFOP;
    property COD_NAT: String                     read FCOD_NAT          write FCOD_NAT;
    property VL_BC_ICMS: currency                read FVL_BC_ICMS       write FVL_BC_ICMS;
    property ALIQ_ICMS: currency                 read FALIQ_ICMS        write FALIQ_ICMS;
    property VL_ICMS: currency                   read FVL_ICMS          write FVL_ICMS;
    property VL_BC_ICMS_ST: currency             read FVL_BC_ICMS_ST    write FVL_BC_ICMS_ST;
    property ALIQ_ST: currency                   read FALIQ_ST          write FALIQ_ST;
    property VL_ICMS_ST: currency                read FVL_ICMS_ST       write FVL_ICMS_ST;
    property IND_APUR: TACBrApuracaoIPI          read FIND_APUR         write FIND_APUR;
//    property CST_IPI: TACBrSituacaoTribIPI       read FCST_IPI          write FCST_IPI;
    property CST_IPI: string                     read FCST_IPI          write FCST_IPI;
    property COD_ENQ: String                     read FCOD_ENQ          write FCOD_ENQ;
    property VL_BC_IPI: currency                 read FVL_BC_IPI        write FVL_BC_IPI;
    property ALIQ_IPI: currency                  read FALIQ_IPI         write FALIQ_IPI;
    property VL_IPI: currency                    read FVL_IPI           write FVL_IPI;
//    property CST_PIS: TACBrSituacaoTribPIS       read FCST_PIS          write FCST_PIS;
    property CST_PIS: string                     read FCST_PIS          write FCST_PIS;
    property VL_BC_PIS: currency                 read FVL_BC_PIS        write FVL_BC_PIS;
    property ALIQ_PIS_PERC: currency             read FALIQ_PIS_PERC    write FALIQ_PIS_PERC;
    property QUANT_BC_PIS: Double                read FQUANT_BC_PIS     write FQUANT_BC_PIS;
    property ALIQ_PIS_R: Double                  read FALIQ_PIS_R       write FALIQ_PIS_R;
    property VL_PIS: currency                    read FVL_PIS           write FVL_PIS;
//    property CST_COFINS: TACBrSituacaoTribCOFINS read FCST_COFINS       write FCST_COFINS;
    property CST_COFINS: string                  read FCST_COFINS       write FCST_COFINS;
    property VL_BC_COFINS: currency              read FVL_BC_COFINS     write FVL_BC_COFINS;
    property ALIQ_COFINS_PERC: currency          read FALIQ_COFINS_PERC write FALIQ_COFINS_PERC;
    property QUANT_BC_COFINS: Double             read FQUANT_BC_COFINS  write FQUANT_BC_COFINS;
    property ALIQ_COFINS_R: Double               read FALIQ_COFINS_R    write FALIQ_COFINS_R;
    property VL_COFINS: currency                 read FVL_COFINS        write FVL_COFINS;
    property COD_CTA: String                     read FCOD_CTA          write FCOD_CTA;
    property VL_ABAT_NT: currency                read FVL_ABAT_NT       write FVL_ABAT_NT;
    /// Registros FILHOS
    property RegistroC171: TRegistroC171List read FRegistroC171 write FRegistroC171;
    property RegistroC172: TRegistroC172List read FRegistroC172 write FRegistroC172;
    property RegistroC173: TRegistroC173List read FRegistroC173 write FRegistroC173;
    property RegistroC174: TRegistroC174List read FRegistroC174 write FRegistroC174;
    property RegistroC175: TRegistroC175List read FRegistroC175 write FRegistroC175;
    property RegistroC176: TRegistroC176List read FRegistroC176 write FRegistroC176;
    property RegistroC177: TRegistroC177List read FRegistroC177 write FRegistroC177;
    property RegistroC178: TRegistroC178List read FRegistroC178 write FRegistroC178;
    property RegistroC179: TRegistroC179List read FRegistroC179 write FRegistroC179;
    property RegistroC180: TRegistroC180List read FRegistroC180 write FRegistroC180;
    property RegistroC181: TRegistroC181List read FRegistroC181 write FRegistroC181;
  end;

  /// Registro C170 - Lista

  TRegistroC170List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC170; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC170); /// SetItem
  public
    function New: TRegistroC170;
    property Items[Index: Integer]: TRegistroC170 read GetItem write SetItem;
  end;

  /// Registro C171 - ARMAZENAMENTO DE COMBUSTIVEIS (c�digo 01, 55)

  TRegistroC171 = class
  private
    fNUM_TANQUE: String;    /// Tanque onde foi armazenado o combust�vel
    fQTDE: Double;        /// Quantidade ou volume armazenado
  public
    property NUM_TANQUE: String read FNUM_TANQUE write FNUM_TANQUE;
    property QTDE: Double read FQTDE write FQTDE;
  end;

  /// Registro C171 - Lista

  TRegistroC171List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC171; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC171); /// SetItem
  public
    function New: TRegistroC171;
    property Items[Index: Integer]: TRegistroC171 read GetItem write SetItem;
  end;

  /// Registro C172 - OPERA��ES COM ISSQN (C�DIGO 01)

  TRegistroC172 = class
  private
    fVL_BC_ISSQN: currency;    /// Valor da base de c�lculo do ISSQN
    fALIQ_ISSQN: currency;     /// Al�quota do ISSQN
    fVL_ISSQN: currency;       /// Valor do ISSQN
  public
    property VL_BC_ISSQN: currency read FVL_BC_ISSQN write FVL_BC_ISSQN;
    property ALIQ_ISSQN: currency read FALIQ_ISSQN write FALIQ_ISSQN;
    property VL_ISSQN: currency read FVL_ISSQN write FVL_ISSQN;
  end;

  /// Registro C172 - Lista

  TRegistroC172List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC172; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC172); /// SetItem
  public
    function New: TRegistroC172;
    property Items[Index: Integer]: TRegistroC172 read GetItem write SetItem;
  end;

  /// Registro C173 - OPERA��ES COM MEDICAMENTOS (C�DIGO 01, 55)

  TRegistroC173 = class
  private
    fLOTE_MED: String;                  /// N�mero do lote de fabrica��o do medicamento
    fQTD_ITEM: Double;                  /// Quantidade de item por lote
    fDT_FAB: TDateTime;                 /// Data de fabrica��o do medicamento
    fDT_VAL: TDateTime;                 /// Data de expira��o da validade do medicamento
    fIND_MED: TACBrTipoBaseMedicamento; /// Indicador de tipo de refer�ncia da base de c�lculo do ICMS (ST) do produto farmac�utico:
    fTP_PROD: TACBrTipoProduto;         /// Tipo de produto:
    fVL_TAB_MAX: currency;              /// Valor do pre�o tabelado ou valor do pre�o m�ximo
  public
    property LOTE_MED: String read FLOTE_MED write FLOTE_MED;
    property QTD_ITEM: Double read FQTD_ITEM write FQTD_ITEM;
    property DT_FAB: TDateTime read FDT_FAB write FDT_FAB;
    property DT_VAL: TDateTime read FDT_VAL write FDT_VAL;
    property IND_MED: TACBrTipoBaseMedicamento read FIND_MED write FIND_MED;
    property TP_PROD: TACBrTipoProduto read FTP_PROD write FTP_PROD;
    property VL_TAB_MAX: currency read FVL_TAB_MAX write FVL_TAB_MAX;
  end;

  /// Registro C173 - Lista

  TRegistroC173List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC173; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC173); /// SetItem
  public
    function New: TRegistroC173;
    property Items[Index: Integer]: TRegistroC173 read GetItem write SetItem;
  end;

  /// Registro C174 - OPERA��ES COM ARMAS DE FOGO (C�DIGO 01)

  TRegistroC174 = class
  private
    fIND_ARM: TACBrTipoArmaFogo;   /// Indicador do tipo da arma de fogo: 0- Uso permitido; 1- Uso restrito
    fNUM_ARM: String;              /// Numera��o de s�rie de fabrica��o da arma
    fDESCR_COMPL: String;          /// Descri��o da arma, compreendendo: n�mero do cano, calibre, marca, capacidade de cartuchos, tipo de funcionamento, quantidade de canos, comprimento, tipo de alma, quantidade e sentido das raias e demais elementos que permitam sua perfeita identifica��o
  public
    property IND_ARM: TACBrTipoArmaFogo read FIND_ARM write FIND_ARM;
    property NUM_ARM: String read FNUM_ARM write FNUM_ARM;
    property DESCR_COMPL: String read FDESCR_COMPL write FDESCR_COMPL;
  end;

  /// Registro C174 - Lista

  TRegistroC174List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC174; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC174); /// SetItem
  public
    function New: TRegistroC174;
    property Items[Index: Integer]: TRegistroC174 read GetItem write SetItem;
  end;

  /// Registro C175 - OPERA��ES COM VE�CULOS NOVOS (C�DIGO 01, 55)

  TRegistroC175 = class
  private
    fIND_VEIC_OPER: TACBrIndVeicOper; /// Indicador do tipo de opera��o com ve�culo: 0- Venda para concession�ria; 1- Faturamento direto; 2- Venda direta; 3- Venda da concession�ria; 9- Outros
    fCNPJ: String;                    /// CNPJ da Concession�ria
    fUF: String;                      /// Sigla da unidade da federa��o da Concession�ria
    fCHASSI_VEIC: String;             /// Chassi do ve�culo
  public
    property IND_VEIC_OPER: TACBrIndVeicOper read FIND_VEIC_OPER write FIND_VEIC_OPER;
    property CNPJ: String read FCNPJ write FCNPJ;
    property UF: String read FUF write FUF;
    property CHASSI_VEIC: String read FCHASSI_VEIC write FCHASSI_VEIC;
  end;

  /// Registro C175 - Lista

  TRegistroC175List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC175; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC175); /// SetItem
  public
    function New: TRegistroC175;
    property Items[Index: Integer]: TRegistroC175 read GetItem write SetItem;
  end;

  /// Registro C176 - RESSARCIMENTO DE ICMS EM OPERA��ES COM SUBSTITUI��O TRIBUT�RIA (C�DIGO 01,55)

  TRegistroC176 = class
  private
    fCOD_MOD_ULT_E: String;                  /// C�digo do modelo do documento fiscal relativa a �ltima entrada
    fNUM_DOC_ULT_E: String;                  /// N�mero do documento fiscal relativa a �ltima entrada
    fSER_ULT_E: String;                      /// S�rie do documento fiscal relativa a �ltima entrada
    fDT_ULT_E: TDateTime;                    /// Data relativa a �ltima entrada da mercadoria
    fCOD_PART_ULT_E: String;                 /// C�digo do participante (do emitente do documento relativa a �ltima entrada)
    fQUANT_ULT_E: Double;                    /// Quantidade do item relativa a �ltima entrada
    fVL_UNIT_ULT_E: Double;                  /// Valor unit�rio da mercadoria constante na NF relativa a �ltima entrada inclusive despesas acess�rias.
    fVL_UNIT_BC_ST: Double;                  /// Valor unit�rio da base de c�lculo do imposto pago por substitui��o.
    fCHAVE_NFE_ULT_E: String;                /// N�mero completo da chave da NFe relativo � �ltima entrada
    fNUM_ITEM_ULT_E: String;                 /// N�mero sequencial do item na NF entrada que corresponde � mercadoria objeto de pedido de ressarcimento
    fVL_UNIT_BC_ICMS_ULT_E: Currency;        /// Valor unit�rio da base de c�lculo da opera��o pr�pria do remetente sob o regime comum de tributa��o
    fALIQ_ICMS_ULT_E: Currency;              /// Al�quota do ICMS aplic�vel � �ltima entrada da mercadoria
    fVL_UNIT_LIMITE_BC_ICMS_ULT_E: Currency; /// Valor unit�rio da base de c�lculo do ICMS relativo � �ltima entrada da mercadoria, limitado ao valor da BC da reten��o (corresponde ao menor valor entre os campos VL_UNIT_BC_ST e VL_UNIT_BC_ICMS_ULT_E )
    fVL_UNIT_ICMS_ULT_E: Currency;           /// Valor unit�rio do cr�dito de ICMS sobre opera��es pr�prias do remetente, relativo � �ltima entrada da mercadoria, decorrente da quebra da ST � equivalente a multiplica��o entre os campos 13 e 14
    fALIQ_ST_ULT_E: Currency;                /// Al�quota do ICMS ST relativa � �ltima entrada da mercadoria
    fVL_UNIT_RES: Currency;                  /// Valor unit�rio do ressarcimento (parcial ou completo) de ICMS decorrente da quebra da ST
    fCOD_RESP_RET: String;                   /// C�digo que indica o respons�vel pela reten��o do ICMS-ST: 1-Remetente Direto 2-Remetente Indireto 3-Pr�prio declarante
    fCOD_MOT_RES: TACBrMotivoRessarcimento;  /// C�digo do motivo do ressarcimento 1 � Venda para outra UF; 2 � Sa�da amparada por isen��o ou n�o incid�ncia; 3 � Perda ou deteriora��o; 4 � Furto ou roubo 5 � Exporta��o 6 � Venda interna para Simples Nacional 9 - Outros
    fCHAVE_NFE_RET: String;                  /// N�mero completo da chave da NF-e emitida pelo substituto, na qual consta o valor do ICMS-ST retido
    fCOD_PART_NFE_RET: String;               /// C�digo do participante do emitente da NF-e em que houve a reten��o do ICMS-ST � campo 02 do registro 0150
    fSER_NFE_RET: String;                    /// S�rie da NF-e em que houve a reten��o do ICMSST
    fNUM_NFE_RET: String;                    /// N�mero da NF-e em que houve a reten��o do ICMS-ST
    fITEM_NFE_RET: String;                   /// N�mero sequencial do item na NF-e em que houve a reten��o do ICMS-ST, que corresponde � mercadoria objeto de pedido de ressarcimento
    fCOD_DA: String;                         /// C�digo do modelo do documento de arrecada��o : 0 - documento estadual de arrecada��o 1 � GNRE
    fNUM_DA: String;                         /// N�mero do documento de arrecada��o estadual, se houver
    fVL_UNIT_RES_FCP_ST: Currency;           /// Valor unit�rio do ressarcimento (parcial ou completo) de FCP decorrente da quebra da ST
  public
    property COD_MOD_ULT_E: String read FCOD_MOD_ULT_E write FCOD_MOD_ULT_E;
    property NUM_DOC_ULT_E: String read FNUM_DOC_ULT_E write FNUM_DOC_ULT_E;
    property SER_ULT_E: String read FSER_ULT_E write FSER_ULT_E;
    property DT_ULT_E: TDateTime read FDT_ULT_E write FDT_ULT_E;
    property COD_PART_ULT_E: String read FCOD_PART_ULT_E write FCOD_PART_ULT_E;
    property QUANT_ULT_E: Double read FQUANT_ULT_E write FQUANT_ULT_E;
    property VL_UNIT_ULT_E: Double read FVL_UNIT_ULT_E write FVL_UNIT_ULT_E;
    property VL_UNIT_BC_ST: Double read FVL_UNIT_BC_ST write FVL_UNIT_BC_ST;
    property CHAVE_NFE_ULT_E: String read fCHAVE_NFE_ULT_E write fCHAVE_NFE_ULT_E;
    property NUM_ITEM_ULT_E: String read fNUM_ITEM_ULT_E write fNUM_ITEM_ULT_E;
    property VL_UNIT_BC_ICMS_ULT_E: Currency read fVL_UNIT_BC_ICMS_ULT_E write fVL_UNIT_BC_ICMS_ULT_E;
    property ALIQ_ICMS_ULT_E: Currency read fALIQ_ICMS_ULT_E write fALIQ_ICMS_ULT_E;
    property VL_UNIT_LIMITE_BC_ICMS_ULT_E: Currency read fVL_UNIT_LIMITE_BC_ICMS_ULT_E write fVL_UNIT_LIMITE_BC_ICMS_ULT_E;
    property VL_UNIT_ICMS_ULT_E: Currency read fVL_UNIT_ICMS_ULT_E write fVL_UNIT_ICMS_ULT_E;
    property ALIQ_ST_ULT_E: Currency read fALIQ_ST_ULT_E write fALIQ_ST_ULT_E;
    property VL_UNIT_RES: Currency read fVL_UNIT_RES write fVL_UNIT_RES;
    property COD_RESP_RET: String read fCOD_RESP_RET write fCOD_RESP_RET;
    property COD_MOT_RES: TACBrMotivoRessarcimento read fCOD_MOT_RES write fCOD_MOT_RES;
    property CHAVE_NFE_RET: String read fCHAVE_NFE_RET write fCHAVE_NFE_RET;
    property COD_PART_NFE_RET: String read fCOD_PART_NFE_RET write fCOD_PART_NFE_RET;
    property SER_NFE_RET: String read fSER_NFE_RET write fSER_NFE_RET;
    property NUM_NFE_RET: String read fNUM_NFE_RET write fNUM_NFE_RET;
    property ITEM_NFE_RET: String read fITEM_NFE_RET write fITEM_NFE_RET;
    property COD_DA: String read fCOD_DA write fCOD_DA;
    property NUM_DA: String read fNUM_DA write fNUM_DA;
    property VL_UNIT_RES_FCP_ST: Currency read fVL_UNIT_RES_FCP_ST write fVL_UNIT_RES_FCP_ST;
  end;

  /// Registro C176 - Lista

  TRegistroC176List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC176; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC176); /// SetItem
  public
    function New: TRegistroC176;
    property Items[Index: Integer]: TRegistroC176 read GetItem write SetItem;
  end;

  /// Registro C177 - OPERA��ES COM PRODUTOS SUJEITOS A SELO DE CONTROLE IPI.

  TRegistroC177 = class
  private
    fCOD_SELO_IPI: String;  /// C�digo do selo de controle do IPI, conforme Tabela 4.5.2
    fQT_SELO_IPI: currency; /// Quantidade de selo de controle do IPI aplicada

    fCOD_INF_ITEM: String;  //C�digo da informa��o adicional de acordo com tabela a ser publicada pelas SEFAZ, conforme tabela definida no item 5.6.

  public
    //vers�o abaixo da 3.0
    property COD_SELO_IPI: String read FCOD_SELO_IPI write FCOD_SELO_IPI;
    property QT_SELO_IPI: currency read FQT_SELO_IPI write FQT_SELO_IPI;
    //vers�o 3.0
    property COD_INF_ITEM: String read fCOD_INF_ITEM write fCOD_INF_ITEM;
  end;

  /// Registro C177 - Lista

  TRegistroC177List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC177; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC177); /// SetItem
  public
    function New: TRegistroC177;
    property Items[Index: Integer]: TRegistroC177 read GetItem write SetItem;
  end;

  /// Registro C178 - OPERA��ES COM PRODUTOS SUJEITOS A TRIBUTA��O DE IPI POR UNIDADE OU QUANTIDADE DE PRODUTO.

  TRegistroC178 = class
  private
    fCL_ENQ: String;        /// C�digo da classe de enquadramento do IPI, conforme Tabela 4.5.1.
    fVL_UNID: currency;     /// Valor por unidade padr�o de tributa��o
    fQUANT_PAD: Double;   /// Quantidade total de produtos na unidade padr�o de tributa��o
  public
    property CL_ENQ: String read FCL_ENQ write FCL_ENQ;
    property VL_UNID: currency read FVL_UNID write FVL_UNID;
    property QUANT_PAD: Double read FQUANT_PAD write FQUANT_PAD;
  end;

  /// Registro C178 - Lista

  TRegistroC178List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC178; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC178); /// SetItem
  public
    function New: TRegistroC178;
    property Items[Index: Integer]: TRegistroC178 read GetItem write SetItem;
  end;

  /// Registro C179 - INFORMA��ES COMPLEMENTARES ST (C�DIGO 01)

  TRegistroC179 = class
  private
    fBC_ST_ORIG_DEST: currency;   /// Valor da base de c�lculo ST na origem/destino em opera��es interestaduais.
    fICMS_ST_REP: currency;       /// Valor do ICMS-ST a repassar/deduzir em opera��es interestaduais
    fICMS_ST_COMPL: currency;     /// Valor do ICMS-ST a complementar � UF de destino
    fBC_RET: currency;            /// Valor da BC de reten��o em remessa promovida por Substitu�do intermedi�rio
    fICMS_RET: currency;          /// Valor da parcela do imposto retido em remessa promovida por substitu�do intermedi�rio
  public
    property BC_ST_ORIG_DEST: currency read FBC_ST_ORIG_DEST write FBC_ST_ORIG_DEST;
    property ICMS_ST_REP: currency read FICMS_ST_REP write FICMS_ST_REP;
    property ICMS_ST_COMPL: currency read FICMS_ST_COMPL write FICMS_ST_COMPL;
    property BC_RET: currency read FBC_RET write FBC_RET;
    property ICMS_RET: currency read FICMS_RET write FICMS_RET;
  end;

  /// Registro C179 - Lista

  TRegistroC179List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC179; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC179); /// SetItem
  public
    function New: TRegistroC179;
    property Items[Index: Integer]: TRegistroC179 read GetItem write SetItem;
  end;

  /// REGISTRO C180: INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE ENTRADA DE MERCADORIAS SUJEITAS � SUBSTITUI��O TRIBUT�RIA (C�DIGO 01, 1B, 04 e 55)

  TRegistroC180 = class
  private
   fCOD_RESP_RET: String;               /// C�digo que indica o respons�vel pela reten��o do ICMS-ST: 1-Remetente Direto / 2-Remetente Indireto / 3-Pr�prio declarante.
   fQUANT_CONV: Double;              /// Quantidade do item convertida na unidade de controle de estoque informada no registro 0200 ou a unidade de comercializa��o, a crit�rio de cada UF.
   fUNID: String;                    /// Unidade adotada para informar o campo QUANT_CONV.
   fVL_UNIT_CONV: Double;            /// Valor unit�rio da mercadoria, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_OP_CONV: Double;    /// Valor unit�rio do ICMS opera��o pr�pria que o informante teria direito ao cr�dito caso a mercadoria estivesse sob o regime comum de tributa��o, considerando unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_BC_ICMS_ST_CONV: Double; /// Valor unit�rio da base de c�lculo do imposto pago ou retido anteriormente por substitui��o, considerando a unidade utilizada para informar o campo �QUANT_CONV�, aplicando-se redu��o, se houver.
   fVL_UNIT_ICMS_ST_CONV: Double;    /// Valor unit�rio do imposto pago ou retido anteriormente por substitui��o, inclusive FCP se devido, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ST_CONV: Double;     /// Valor unit�rio do FCP_ST agregado ao valor informado no campo �VL_UNIT_ICMS_ST_CONV�.
   fCOD_DA: String;                    /// C�digo do modelo do documento de arrecada��o: 0 � Documento estadual de arrecada��o / 1 � GNRE.
   fNUM_DA: String;                    /// N�mero do documento de arrecada��o estadual, se houver.
  public
    property COD_RESP_RET: String read fCOD_RESP_RET write fCOD_RESP_RET;
    property QUANT_CONV: Double read fQUANT_CONV write fQUANT_CONV;
    property UNID: String read fUNID write fUNID;
    property VL_UNIT_CONV: Double read fVL_UNIT_CONV write fVL_UNIT_CONV;
    property VL_UNIT_ICMS_OP_CONV: Double read fVL_UNIT_ICMS_OP_CONV write fVL_UNIT_ICMS_OP_CONV;
    property VL_UNIT_BC_ICMS_ST_CONV: Double read fVL_UNIT_BC_ICMS_ST_CONV write fVL_UNIT_BC_ICMS_ST_CONV;
    property VL_UNIT_ICMS_ST_CONV: Double read fVL_UNIT_ICMS_ST_CONV write fVL_UNIT_ICMS_ST_CONV;
    property VL_UNIT_FCP_ST_CONV: Double read fVL_UNIT_FCP_ST_CONV write fVL_UNIT_FCP_ST_CONV;
    property COD_DA: String read fCOD_DA write fCOD_DA;
    property NUM_DA: String read fNUM_DA write fNUM_DA;
  end;
    /// Registro C180 - Lista

  TRegistroC180List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC180; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC180); /// SetItem
  public
    function New: TRegistroC180;
    property Items[Index: Integer]: TRegistroC180 read GetItem write SetItem;
  end;

  /// REGISTRO C181:  INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE ENTRADA DE MERCADORIAS SUJEITAS � SUBSTITUI��O TRIBUT�RIA (C�DIGO 01, 1B, 04 e 55).

  TRegistroC181 = class
  private
   fCOD_MOT_REST_COMPL : String;   /// C�digo do motivo da restitui��o ou complementa��o conforme Tabela 5.7
   fQUANT_CONV : Double ;  /// Quantidade do item
   fUNID : String;   /// Unidade adotada para informar o campoQUANT_CONV.
   fCOD_MOD_SAIDA : String;   /// C�digo do modelo do documento fiscal de sa�da, conforme a tabela indicada no item 4.1.1
   fSERIE_SAIDA : String;   /// N�mero de s�rie do documento de sa�da em papel
   fECF_FAB_SAIDA : String;   /// N�mero de s�rie de fabrica��o do equipamento ECF
   fNUM_DOC_SAIDA : String;   /// N�mero do documento fiscal de sa�da
   fCHV_DFE_SAIDA : String;   /// Chave do documento fiscal eletr�nico de sa�da
   fDT_DOC_SAIDA : TDateTime;   /// Data da emiss�o do documento fiscal de sa�da
   fNUM_ITEM_SAIDA : String;   /// N�mero do item em que foi escriturada a sa�da em um registro C185, C380, C480 ou C815 quando o contribuinte informar a sa�da em um arquivo de perfil A.
   fVL_UNIT_CONV_SAIDA : Double;   /// Valor unit�rio da mercadoria, considerando a unidade utilizada para informar o campo �QUANT_CONV�, correspondente ao valor do campo VL_UNIT_CONV, preenchido na ocasi�o da sa�da
   fVL_UNIT_ICMS_OP_ESTOQUE_CONV_SAIDA : Variant;   /// Valor m�dio unit�rio do ICMS OP, das mercadorias em estoque, correspondente ao valor do campo VL_UNIT_ICMS_OP_ESTOQUE_CONV, preenchido na ocasi�o da sa�da
   fVL_UNIT_ICMS_ST_ESTOQUE_CONV_SAIDA : Variant;   /// Valor m�dio unit�rio do ICMS ST, incluindo FCP ST, das mercadorias em estoque, correspondente ao valor do campo VL_UNIT_ICMS_ST_ESTOQUE_CONV, preenchido na ocasi�o da sa�da
   fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV_SAIDA : Variant;   /// Valor m�dio unit�rio do FCP ST agregado ao ICMS das mercadorias em estoque, correspondente ao valor do campo VL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV, preenchido na ocasi�o da sa�da
   fVL_UNIT_ICMS_NA_OPERACAO_CONV_SAIDA : Variant;   /// Valor unit�rio para o ICMS na opera��o, correspondente ao valor do campo VL_UNIT_ICMS_NA_OPERACAO_CONV, preenchido na ocasi�o da sa�da
   fVL_UNIT_ICMS_OP_CONV_SAIDA : Variant;   /// Valor unit�rio do ICMS correspondente ao valor do campo VL_UNIT_ICMS_OP_CONV, preenchido na ocasi�o da sa�da
   fVL_UNIT_ICMS_ST_CONV_REST : Variant;   /// Valor unit�rio do total do ICMS ST, incluindo FCP ST, a ser restitu�do/ressarcido, correspondente ao estorno do complemento apurado na opera��o de sa�da.
   fVL_UNIT_FCP_ST_CONV_REST : Variant;   /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_REST�, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_CONV_COMPL : Variant;   /// Valor unit�rio do estorno do ressarcimento/restitui��o, incluindo FCP ST, apurado na opera��o de sa�da.
   fVL_UNIT_FCP_ST_CONV_COMPL : Variant;   /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_COMPL�, considerando unidade utilizada para informar o campo �QUANT_CONV�.
  public
   property COD_MOT_REST_COMPL: String read fCOD_MOT_REST_COMPL  write fCOD_MOT_REST_COMPL ;
   property QUANT_CONV: Double read fQUANT_CONV  write fQUANT_CONV ;
   property UNID: String read fUNID  write fUNID ;
   property COD_MOD_SAIDA: String read fCOD_MOD_SAIDA  write fCOD_MOD_SAIDA ;
   property SERIE_SAIDA: String read fSERIE_SAIDA  write fSERIE_SAIDA ;
   property ECF_FAB_SAIDA: String read fECF_FAB_SAIDA  write fECF_FAB_SAIDA ;
   property NUM_DOC_SAIDA: String read fNUM_DOC_SAIDA  write fNUM_DOC_SAIDA ;
   property CHV_DFE_SAIDA: String read fCHV_DFE_SAIDA  write fCHV_DFE_SAIDA ;
   property DT_DOC_SAIDA: TDateTime read fDT_DOC_SAIDA  write fDT_DOC_SAIDA ;
   property NUM_ITEM_SAIDA: String read fNUM_ITEM_SAIDA  write fNUM_ITEM_SAIDA ;
   property VL_UNIT_CONV_SAIDA: Double read fVL_UNIT_CONV_SAIDA  write fVL_UNIT_CONV_SAIDA ;
   property VL_UNIT_ICMS_OP_ESTOQUE_CONV_SAIDA: Variant read fVL_UNIT_ICMS_OP_ESTOQUE_CONV_SAIDA  write fVL_UNIT_ICMS_OP_ESTOQUE_CONV_SAIDA ;
   property VL_UNIT_ICMS_ST_ESTOQUE_CONV_SAIDA: Variant read fVL_UNIT_ICMS_ST_ESTOQUE_CONV_SAIDA  write fVL_UNIT_ICMS_ST_ESTOQUE_CONV_SAIDA ;
   property VL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV_SAIDA: Variant read fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV_SAIDA  write fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV_SAIDA ;
   property VL_UNIT_ICMS_NA_OPERACAO_CONV_SAIDA: Variant read fVL_UNIT_ICMS_NA_OPERACAO_CONV_SAIDA  write fVL_UNIT_ICMS_NA_OPERACAO_CONV_SAIDA ;
   property VL_UNIT_ICMS_OP_CONV_SAIDA: Variant read fVL_UNIT_ICMS_OP_CONV_SAIDA  write fVL_UNIT_ICMS_OP_CONV_SAIDA ;
   property VL_UNIT_ICMS_ST_CONV_REST: Variant read fVL_UNIT_ICMS_ST_CONV_REST  write fVL_UNIT_ICMS_ST_CONV_REST ;
   property VL_UNIT_FCP_ST_CONV_REST: Variant read fVL_UNIT_FCP_ST_CONV_REST  write fVL_UNIT_FCP_ST_CONV_REST ;
   property VL_UNIT_ICMS_ST_CONV_COMPL: Variant read fVL_UNIT_ICMS_ST_CONV_COMPL  write fVL_UNIT_ICMS_ST_CONV_COMPL ;
   property VL_UNIT_FCP_ST_CONV_COMPL: Variant read fVL_UNIT_FCP_ST_CONV_COMPL  write fVL_UNIT_FCP_ST_CONV_COMPL ;
  end;


  /// Registro C181 - Lista

  TRegistroC181List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC181; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC181); /// SetItem
  public
    function New: TRegistroC181;
    property Items[Index: Integer]: TRegistroC181 read GetItem write SetItem;
  end;

  /// REGISTRO C185: INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE SA�DA DE MERCADORIAS SUJEITAS � SUBSTITUI��O TRIBUT�RIA (C�DIGO 01, 1B, 04, 55 e 65).

  TRegistroC185 = class
  private
   fNUM_ITEM: String; /// N�mero sequencial do item no documento fiscal.
   fCOD_ITEM: String; /// C�digo do item (campo 02 do Registro 0200).
   fCST_ICMS: String; /// C�digo da Situa��o Tribut�ria referente ao ICMS.
   fCFOP:String ; /// C�digo Fiscal de Opera��o e Presta��o.
   fCOD_MOT_REST_COMPL:String ; /// C�digo do motivo da restitui��o ou complementa��o conforme Tabela 5.7.
   fQUANT_CONV: Double ; /// Quantidade do item.
   fUNID: String; /// Unidade adotada para informar o campo QUANT_CONV.
   fVL_UNIT_CONV: Double; /// Valor unit�rio da mercadoria, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_NA_OPERACAO_CONV: Variant; /// Valor unit�rio para o ICMS na opera��o, caso n�o houvesse a ST, considerando unidade utilizada para informar o campo �QUANT_CONV�, considerando redu��o da base de c�lculo do ICMS ST na tributa��o, se houver.
   fVL_UNIT_ICMS_OP_CONV: Variant; /// Valor unit�rio do ICMS que o contribuinte teria se creditado, ou pode se creditar, referente � opera��o de entrada da mercadoria, caso estivesse submetida ao regime comum de tributa��o, no desfazimento da substitui��o tribut�ria, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_OP_ESTOQUE_CONV: Variant; /// Valor m�dio unit�rio do ICMS que o contribuinte teria se creditado referente � opera��o de entrada das mercadorias em estoque caso estivesse submetida ao regime comum de tributa��o, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_ESTOQUE_CONV: Variant; /// Valor m�dio unit�rio do ICMS/ST, incluindo FCP ST, das mercadorias em estoque, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: Variant; /// Valor m�dio unit�rio do FCP ST agregado ao ICMS das mercadorias em estoque, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_CONV_REST: Variant; /// Valor unit�rio do total do ICMS/ST, incluindo FCP ST, a ser restitu�do/ressarcido, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ST_CONV_REST: Variant; /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_REST�, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_CONV_COMPL: Variant; ///  Valor unit�rio do complemento do ICMS, incluindo FCP ST, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ST_CONV_COMPL: Variant; /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_COMPL�, considerando unidade utilizada para informar o campo �QUANT_CONV�.
 public
   property NUM_ITEM: String read fNUM_ITEM write fNUM_ITEM;
   property COD_ITEM: String read fCOD_ITEM write fCOD_ITEM;
   property CST_ICMS: String read fCST_ICMS write fCST_ICMS;
   property CFOP:String  read fCFOP write fCFOP;
   property COD_MOT_REST_COMPL:String  read fCOD_MOT_REST_COMPL write fCOD_MOT_REST_COMPL;
   property QUANT_CONV: Double  read fQUANT_CONV write fQUANT_CONV;
   property UNID: String read fUNID write fUNID;
   property VL_UNIT_CONV: Double read fVL_UNIT_CONV write fVL_UNIT_CONV;
   property VL_UNIT_ICMS_NA_OPERACAO_CONV: Variant read fVL_UNIT_ICMS_NA_OPERACAO_CONV write fVL_UNIT_ICMS_NA_OPERACAO_CONV;
   property VL_UNIT_ICMS_OP_CONV: Variant read fVL_UNIT_ICMS_OP_CONV write fVL_UNIT_ICMS_OP_CONV;
   property VL_UNIT_ICMS_OP_ESTOQUE_CONV: Variant read fVL_UNIT_ICMS_OP_ESTOQUE_CONV write fVL_UNIT_ICMS_OP_ESTOQUE_CONV;
   property VL_UNIT_ICMS_ST_ESTOQUE_CONV: Variant read fVL_UNIT_ICMS_ST_ESTOQUE_CONV write fVL_UNIT_ICMS_ST_ESTOQUE_CONV;
   property VL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: Variant read fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV write fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV;
   property VL_UNIT_ICMS_ST_CONV_REST: Variant read fVL_UNIT_ICMS_ST_CONV_REST write fVL_UNIT_ICMS_ST_CONV_REST;
   property VL_UNIT_FCP_ST_CONV_REST: Variant read fVL_UNIT_FCP_ST_CONV_REST write fVL_UNIT_FCP_ST_CONV_REST;
   property VL_UNIT_ICMS_ST_CONV_COMPL: Variant read fVL_UNIT_ICMS_ST_CONV_COMPL write fVL_UNIT_ICMS_ST_CONV_COMPL;
   property VL_UNIT_FCP_ST_CONV_COMPL: Variant read fVL_UNIT_FCP_ST_CONV_COMPL write fVL_UNIT_FCP_ST_CONV_COMPL;
  end;

    /// Registro C185 - Lista

  TRegistroC185List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC185; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC185); /// SetItem
  public
    function New: TRegistroC185;
    property Items[Index: Integer]: TRegistroC185 read GetItem write SetItem;
  end;

  /// REGISTRO C186: INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE DEVOLU��O DE ENTRADAS DE MERCADORIAS SUJEITAS � SUBSTITUI��O
  /// TRIBUT�RIA (C�DIGO 01, 1B, 04 e 55).INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE SA�DA DE MERCADORIAS SUJEITAS � SUBSTITUI��O TRIBUT�RIA (C�DIGO 01, 1B, 04, 55 e 65).

  TRegistroC186 = class
  private
   fNUM_ITEM: String; /// N�mero sequencial do item no documento fiscal.
   fCOD_ITEM: String; /// C�digo do item (campo 02 do Registro 0200).
   fCST_ICMS: String; /// C�digo da Situa��o Tribut�ria referente ao ICMS.
   fCFOP:String ; /// C�digo Fiscal de Opera��o e Presta��o.
   fCOD_MOT_REST_COMPL:String ; /// C�digo do motivo da restitui��o ou complementa��o conforme Tabela 5.7.
   fQUANT_CONV: Double ; /// Quantidade do item.
   fUNID: String; /// Unidade adotada para informar o campo QUANT_CONV.
   fCOD_MOD_ENTRADA: String; /// C�digo do modelo do documento fiscal de entrada, conforme a tabela indicada no item 4.1.1
   fSERIE_ENTRADA: String;  ///  N�mero de s�rie do documento de entrada em papel
   fNUM_DOC_ENTRADA: String; /// N�mero do documento fiscal de entrada
   fCHV_DFE_ENTRADA: String; /// Chave do documento fiscal eletr�nico de entrada
   fDT_DOC_ENTRADA: TDateTime; /// Data da emiss�o do documento fiscal de entrada
   fNUM_ITEM_ENTRADA: String; /// Item do documento fiscal de entrada
   fVL_UNIT_CONV_ENTRADA: Double; /// Valor unit�rio da mercadoria, considerando a unidade utilizada para informar o campo �QUANT_CONV�, correspondente ao valor do campo VL_UNIT_CONV, preenchido na ocasi�o da entrada
   fVL_UNIT_ICMS_OP_CONV_ENTRADA: Double; /// Valor unit�rio do ICMS correspondente ao valor do campo VL_UNIT_ICMS_OP_CONV, preenchido na ocasi�o da entrada
   fVL_UNIT_BC_ICMS_ST_CONV_ENTRADA: Double; /// Valor unit�rio da base de c�lculo do imposto pago ou retido anteriormente por substitui��o, correspondente ao valor do campo VL_UNIT_BC_ICMS_ST_CONV, preenchido na ocasi�o da entrada
   fVL_UNIT_ICMS_ST_CONV_ENTRADA: Double; ///  Valor unit�rio do imposto pago ou retido anteriormente por substitui��o, inclusive FCP se devido, correspondente ao valor do campo VL_UNIT_ICMS_ST_CONV, preenchido na ocasi�o da entrada
   fVL_UNIT_FCP_ST_CONV_ENTRADA: Double; /// Valor unit�rio do FCP_ST, correspondente ao valor do campo VL_UNIT_FCP_ST_CONV, preenchido na ocasi�o da entrada

 public
   property NUM_ITEM: String read fNUM_ITEM write fNUM_ITEM;
   property COD_ITEM: String read fCOD_ITEM write fCOD_ITEM;
   property CST_ICMS: String read fCST_ICMS write fCST_ICMS;
   property CFOP:String  read fCFOP write fCFOP;
   property COD_MOT_REST_COMPL:String  read fCOD_MOT_REST_COMPL write fCOD_MOT_REST_COMPL;
   property QUANT_CONV: Double  read fQUANT_CONV write fQUANT_CONV;
   property UNID: String read fUNID write fUNID;
   property COD_MOD_ENTRADA: String read fCOD_MOD_ENTRADA write fCOD_MOD_ENTRADA;
   property SERIE_ENTRADA: String read fSERIE_ENTRADA write fSERIE_ENTRADA;
   property NUM_DOC_ENTRADA: String read fNUM_DOC_ENTRADA write fNUM_DOC_ENTRADA;
   property CHV_DFE_ENTRADA: String read fCHV_DFE_ENTRADA write fCHV_DFE_ENTRADA;
   property DT_DOC_ENTRADA: TDateTime read fDT_DOC_ENTRADA write fDT_DOC_ENTRADA;
   property NUM_ITEM_ENTRADA: String read fNUM_ITEM_ENTRADA write fNUM_ITEM_ENTRADA;
   property VL_UNIT_CONV_ENTRADA: Double read fVL_UNIT_CONV_ENTRADA write fVL_UNIT_CONV_ENTRADA;
   property VL_UNIT_ICMS_OP_CONV_ENTRADA: Double read fVL_UNIT_ICMS_OP_CONV_ENTRADA write fVL_UNIT_ICMS_OP_CONV_ENTRADA;
   property VL_UNIT_BC_ICMS_ST_CONV_ENTRADA: Double read fVL_UNIT_BC_ICMS_ST_CONV_ENTRADA write fVL_UNIT_BC_ICMS_ST_CONV_ENTRADA;
   property VL_UNIT_ICMS_ST_CONV_ENTRADA: Double read fVL_UNIT_ICMS_ST_CONV_ENTRADA write fVL_UNIT_ICMS_ST_CONV_ENTRADA;
   property VL_UNIT_FCP_ST_CONV_ENTRADA: Double read fVL_UNIT_FCP_ST_CONV_ENTRADA write fVL_UNIT_FCP_ST_CONV_ENTRADA;
  end;

    /// Registro C186 - Lista

  TRegistroC186List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC186; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC186); /// SetItem
  public
    function New: TRegistroC186;
    property Items[Index: Integer]: TRegistroC186 read GetItem write SetItem;
  end;

   /// Registro C190 - REGISTRO ANAL�TICO DO DOCUMENTO (C�DIGO 01, 1B, 04 E 55)

  TRegistroC190 = class
  private
    fCST_ICMS: String;         /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1
    fCFOP: String;             /// C�digo Fiscal de Opera��o e Presta��o do agrupamento de itens
    fALIQ_ICMS: currency;      /// Al�quota do ICMS
    fVL_OPR: currency;         /// Valor da opera��o na combina��o de CST_ICMS,CFOP e al�quota do ICMS, correspondente ao somat�rio do valor das mercadorias, despesas acess�rias (frete, seguros e outras despesas acess�rias), ICMS_ST, FCP_ST e IPI.
    fVL_BC_ICMS: currency;     /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_ICMS: currency;        /// Parcela correspondente ao "Valor do ICMS", incluindo o FCP, quando aplic�vel, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS
    fVL_BC_ICMS_ST: currency;  /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" da substitui��o tribut�ria referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_ICMS_ST: currency;     /// Parcela correspondente ao valor creditado/debitado do ICMS da substitui��o tribut�ria, incluindo o FCP_ ST, quando aplic�vel, referente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS
    fVL_RED_BC: currency;      /// Valor n�o tributado em fun��o da redu��o da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_IPI: currency;         /// Parcela correspondente ao "Valor do IPI" referente � combina��o CST_ICMS, CFOP e al�quota do ICMS.
    fCOD_OBS: String;          /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460
    FRegistroC191: TRegistroC191List;  /// BLOCO C - Lista de RegistroC191 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy
    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_BC_ICMS_ST: currency read FVL_BC_ICMS_ST write FVL_BC_ICMS_ST;
    property VL_ICMS_ST: currency read FVL_ICMS_ST write FVL_ICMS_ST;
    property VL_RED_BC: currency read FVL_RED_BC write FVL_RED_BC;
    property VL_IPI: currency read FVL_IPI write FVL_IPI;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
    property RegistroC191: TRegistroC191List read FRegistroC191 write FRegistroC191;
  end;

  /// Registro C190 - Lista

  TRegistroC190List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC190; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC190); /// SetItem
  public
    function New: TRegistroC190;
    property Items[Index: Integer]: TRegistroC190 read GetItem write SetItem;
  end;

   /// Registro C191: INFORMA��ES DO FUNDO DE COMBATE � POBREZA � FCP � NA NFe (C�DIGO 55)

  TRegistroC191 = class
  private
    FVL_FCP_OP: currency; //Valor do Fundo de Combate � Pobreza (FCP) vinculado � opera��o pr�pria, na combina��o de CST_ICMS, CFOP e al�quota do ICMS
    FVL_FCP_ST: currency; //Valor do Fundo de Combate � Pobreza (FCP) vinculado � opera��o de substitui��o tribut�ria, na combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    FVL_FCP_RET: currency;//Valor relativo ao Fundo de Combate � Pobreza (FCP) retido anteriormente nas opera��es com Substitui��o Tribut�rias, na combina��o de CST_ICMS, CFOP e al�quota do ICMS
  public
    property VL_FCP_OP: currency  read FVL_FCP_OP write  FVL_FCP_OP;
    property VL_FCP_ST: currency  read FVL_FCP_ST write  FVL_FCP_ST;
    property VL_FCP_RET: currency read FVL_FCP_RET write FVL_FCP_RET;
  end;

  /// Registro C191 - Lista

  TRegistroC191List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC191; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC191); /// SetItem
  public
    function New: TRegistroC191;
    property Items[Index: Integer]: TRegistroC191 read GetItem write SetItem;
  end;

  /// Registro C195 - OBSERVA�OES DO LAN�AMENTO FISCAL (C�DIGO 01, 1B E 55)

  TRegistroC195 = class
  private
    fCOD_OBS: String;    /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
    fTXT_COMPL: String;  /// Descri��o complementar do c�digo de observa��o.

    fRegistroC197: TRegistroC197List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
    property TXT_COMPL: String read FTXT_COMPL write FTXT_COMPL;

    property RegistroC197: TRegistroC197List read FRegistroC197 write FRegistroC197;
  end;

  /// Registro C195 - Lista

  TRegistroC195List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC195; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC195); /// SetItem
  public
    function New: TRegistroC195;
    property Items[Index: Integer]: TRegistroC195 read GetItem write SetItem;
  end;

  /// Registro C197 - OUTRAS OBRIGA��ES TRIBUT�RIAS, AJUSTES E INFORMA��ES DE VALORES PROVENIENTES DE DOCUMENTO FISCAL.

  TRegistroC197 = class
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

  TRegistroC197List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC197; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC197); /// SetItem
  public
    function New: TRegistroC197;
    property Items[Index: Integer]: TRegistroC197 read GetItem write SetItem;
  end;

  /// Registro C300 - RESUMO DI�RIO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR (C�DIGO 02)

  TRegistroC300 = class
  private
    fCOD_MOD: String;     /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fSER: String;         /// S�rie do documento fiscal
    fSUB: String;         /// Subs�rie do documento fiscal
    fNUM_DOC_INI: String; /// N�mero do documento fiscal inicial
    fNUM_DOC_FIN: String; /// N�mero do documento fiscal final
    fDT_DOC: TDateTime;   /// Data da emiss�o dos documentos fiscais
    fVL_DOC: currency;    /// Valor total dos documentos
    fVL_PIS: currency;    /// Valor total do PIS
    fVL_COFINS: currency; /// Valor total da COFINS
    fCOD_CTA: String;     /// C�digo da conta anal�tica cont�bil debitada/creditada

    fRegistroC310: TRegistroC310List;
    fRegistroC320: TRegistroC320List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read fCOD_MOD write fCOD_MOD;
    property SER: String read fSER write fSER;
    property SUB: String read fSUB write fSUB;
    property NUM_DOC_INI: String read fNUM_DOC_INI write fNUM_DOC_INI;
    property NUM_DOC_FIN: String read fNUM_DOC_FIN write fNUM_DOC_FIN;
    property DT_DOC: TDateTime read fDT_DOC write fDT_DOC;
    property VL_DOC: currency read fVL_DOC write fVL_DOC;
    property VL_PIS: currency read fVL_PIS write fVL_PIS;
    property VL_COFINS: currency read fVL_COFINS write fVL_COFINS;
    property COD_CTA: String read fCOD_CTA write fCOD_CTA;

    property RegistroC310: TRegistroC310List read FRegistroC310 write FRegistroC310;
    property RegistroC320: TRegistroC320List read FRegistroC320 write FRegistroC320;
  end;

  /// Registro C300 - Lista

  TRegistroC300List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC300; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC300); /// SetItem
  public
    function New: TRegistroC300;
    property Items[Index: Integer]: TRegistroC300 read GetItem write SetItem;
  end;

  /// Registro C310 - DOCUMENTOS CANCELADOS DE NOTAS FISCAIS DE VENDA A CONSUMIDOR (C�DIGO 02)

  TRegistroC310 = class
  private
    fNUM_DOC_CANC: String; /// N�mero do documento fiscal cancelado
  public
    property NUM_DOC_CANC: String read fNUM_DOC_CANC write fNUM_DOC_CANC;
  end;

  /// Registro C310 - Lista

  TRegistroC310List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC310; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC310); /// SetItem
  public
    function New: TRegistroC310;
    property Items[Index: Integer]: TRegistroC310 read GetItem write SetItem;
  end;

  /// Registro C320 - REGISTRO ANAL�TICO DO RESUMO DI�RIO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR (C�DIGO 02)

  TRegistroC320 = class
  private
    fCST_ICMS: String;     /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1
    fCFOP: String;         /// C�digo Fiscal de Opera��o e Presta��o
    fALIQ_ICMS: Currency;  /// Al�quota do ICMS
    fVL_OPR: currency;     /// Valor total acumulado das opera��es correspondentes � combina��o de CST_ICMS, CFOP e al�quota do ICMS, inclu�das as despesas acess�rias e acr�scimos.
    fVL_BC_ICMS: currency; /// Valor acumulado da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS.
    fVL_ICMS: currency;    /// Valor acumulado do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_RED_BC: currency;  /// Valor n�o tributado em fun��o da redu��o da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS.
    fCOD_OBS: String;      /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)

    FRegistroC321: TRegistroC321List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property CST_ICMS: String read fCST_ICMS write fCST_ICMS;
    property CFOP: String read fCFOP write fCFOP;
    property ALIQ_ICMS: Currency read fALIQ_ICMS write fALIQ_ICMS;
    property VL_OPR: currency read fVL_OPR write fVL_OPR;
    property VL_BC_ICMS: currency read fVL_BC_ICMS write fVL_BC_ICMS;
    property VL_ICMS: currency read fVL_ICMS write fVL_ICMS;
    property VL_RED_BC: currency read fVL_RED_BC write fVL_RED_BC;
    property COD_OBS: String read fCOD_OBS write fCOD_OBS;

    property RegistroC321: TRegistroC321List read FRegistroC321 write FRegistroC321;
  end;

  /// Registro C320 - Lista

  TRegistroC320List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC320; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC320); /// SetItem
  public
    function New: TRegistroC320;
    property Items[Index: Integer]: TRegistroC320 read GetItem write SetItem;
  end;

  /// Registro C321 - ITENS DO RESUMO DI�RIO DOS DOCUMENTOS (C�DIGO 02)

  TRegistroC321 = class
  private
    fCOD_ITEM: String;     /// C�digo do item (campo 02 do Registro 0200)
    fQTD: Double;          /// Quantidade acumulada do item
    fUNID: String;         /// Unidade do item (Campo 02 do registro 0190)
    fVL_ITEM: currency;    /// Valor acumulado do item
    fVL_DESC: currency;    /// Valor do desconto acumulado
    fVL_BC_ICMS: currency; /// Valor acumulado da base de c�lculo do ICMS
    fVL_ICMS: currency;    /// Valor acumulado do ICMS debitado
    fVL_PIS: currency;     /// Valor acumulado do PIS
    fVL_COFINS: currency;  /// Valor acumulado da COFINS
    FRegistroC330: TRegistroC330List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy
    ///
    property COD_ITEM: String read FCOD_ITEM write FCOD_ITEM;
    property QTD: Double read FQTD write FQTD;
    property UNID: String read FUNID write FUNID;
    property VL_ITEM: currency read FVL_ITEM write FVL_ITEM;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_PIS: currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: currency read FVL_COFINS write FVL_COFINS;
    property RegistroC330: TRegistroC330List read FRegistroC330 write FRegistroC330;
  end;

  /// Registro C321 - Lista

  TRegistroC321List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC321; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC321); /// SetItem
  public
    function New: TRegistroC321;
    property Items[Index: Integer]: TRegistroC321 read GetItem write SetItem;
  end;

  /// REGISTRO C330: INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE SA�DA DE MERCADORIAS SUJEITAS � SUBSTITUI��O TRIBUT�RIA (C�DIGO 02)

  TRegistroC330 = class
  private
   fCOD_MOT_REST_COMPL: string; /// C�digo do motivo da restitui��o ou complementa��o conforme Tabela 5.7.
   fQUANT_CONV: currency; /// Quantidade do item.
   fUNID: string ; /// Unidade adotada para informar o campo QUANT_CONV.
   fVL_UNIT_CONV: currency; /// Valor unit�rio da mercadoria, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_NA_OPERACAO_CONV: currency; /// Valor unit�rio para o ICMS na opera��o, caso n�o houvesse a ST, considerando unidade utilizada para informar o campo �QUANT_CONV�, aplicando-se a mesma redu��o da base de c�lculo do ICMS ST na tributa��o, se houver.
   fVL_UNIT_ICMS_OP_CONV: currency; /// Valor unit�rio correspondente ao ICMS OP utilizado no c�lculo do ressarcimento / restitui��o, no desfazimento da substitui��o tribut�ria, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_OP_ESTOQUE_CONV: currency; /// Valor m�dio unit�rio do ICMS que o contribuinte teria se creditado referente � opera��o de entrada das mercadorias em estoque caso estivesse submetida ao regime comum de tributa��o, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_ESTOQUE_CONV: currency; /// Valor m�dio unit�rio do ICMS/ST, incluindo FCP ST, das mercadorias em estoque, considerando unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: currency; /// Valor m�dio unit�rio do ICMS/ST, incluindo FCP ST, das mercadorias em estoque, considerando unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_CONV_REST: Variant; /// Valor unit�rio do total do ICMS/ST, incluindo FCP ST, a ser restitu�do/ressarcido, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ST_CONV_REST: Variant; /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_REST�, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_CONV_COMPL: Variant; /// Valor unit�rio do complemento do ICMS, incluindo FCP ST, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ST_CONV_COMPL: Variant; /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_COMPL�, considerando unidade utilizada para informar o campo �QUANT_CONV�.
  public
   property COD_MOT_REST_COMPL: string read fCOD_MOT_REST_COMPL  write fCOD_MOT_REST_COMPL;
   property QUANT_CONV: currency read fQUANT_CONV  write fQUANT_CONV;
   property UNID: string  read fUNID  write fUNID;
   property VL_UNIT_CONV: currency read fVL_UNIT_CONV  write fVL_UNIT_CONV;
   property VL_UNIT_ICMS_NA_OPERACAO_CONV: currency read fVL_UNIT_ICMS_NA_OPERACAO_CONV  write fVL_UNIT_ICMS_NA_OPERACAO_CONV;
   property VL_UNIT_ICMS_OP_CONV: currency read fVL_UNIT_ICMS_OP_CONV  write fVL_UNIT_ICMS_OP_CONV;
   property VL_UNIT_ICMS_OP_ESTOQUE_CONV: currency read fVL_UNIT_ICMS_OP_ESTOQUE_CONV  write fVL_UNIT_ICMS_OP_ESTOQUE_CONV;
   property VL_UNIT_ICMS_ST_ESTOQUE_CONV: currency read fVL_UNIT_ICMS_ST_ESTOQUE_CONV  write fVL_UNIT_ICMS_ST_ESTOQUE_CONV;
   property VL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: currency read fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV  write fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV;
   property VL_UNIT_ICMS_ST_CONV_REST: Variant read fVL_UNIT_ICMS_ST_CONV_REST  write fVL_UNIT_ICMS_ST_CONV_REST;
   property VL_UNIT_FCP_ST_CONV_REST: Variant read fVL_UNIT_FCP_ST_CONV_REST  write fVL_UNIT_FCP_ST_CONV_REST;
   property VL_UNIT_ICMS_ST_CONV_COMPL: Variant read fVL_UNIT_ICMS_ST_CONV_COMPL  write fVL_UNIT_ICMS_ST_CONV_COMPL;
   property VL_UNIT_FCP_ST_CONV_COMPL: Variant read fVL_UNIT_FCP_ST_CONV_COMPL  write fVL_UNIT_FCP_ST_CONV_COMPL;
  end;

   /// Registro C330 - Lista

  TRegistroC330List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC330; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC330); /// SetItem
  public
    function New: TRegistroC330;
    property Items[Index: Integer]: TRegistroC330 read GetItem write SetItem;
  end;


  /// Registro C350 - NOTA FISCAL DE VENDA A CONSUMIDOR (C�DIGO 02)

  TRegistroC350 = class
  private
    fSER: String;           /// S�rie do documento fiscal
    fSUB_SER: String;       /// Subs�rie do documento fiscal
    fNUM_DOC: String;       /// N�mero do documento fiscal
    fDT_DOC: TDateTime;     /// Data da emiss�o do documento fiscal
    fCNPJ_CPF: String;      /// CNPJ ou CPF do destinat�rio
    fVL_MERC: currency;     /// Valor das mercadorias constantes no documento fiscal
    fVL_DOC: currency;      /// Valor total do documento fiscal
    fVL_DESC: currency;     /// Valor total do desconto
    fVL_PIS: currency;      /// Valor total do PIS
    fVL_COFINS: currency;   /// Valor total da COFINS
    fCOD_CTA: String;       /// C�digo da conta anal�tica cont�bil debitada/creditada

    FRegistroC370: TRegistroC370List;  /// BLOCO C - Lista de RegistroC370 (FILHO)
    FRegistroC390: TRegistroC390List;  /// BLOCO C - Lista de RegistroC390 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property SER: String read FSER write FSER;
    property SUB_SER: String read FSUB_SER write FSUB_SER;
    property NUM_DOC: String read FNUM_DOC write FNUM_DOC;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property CNPJ_CPF: String read FCNPJ_CPF write FCNPJ_CPF;
    property VL_MERC: currency read FVL_MERC write FVL_MERC;
    property VL_DOC: currency read FVL_DOC write FVL_DOC;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property VL_PIS: currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: currency read FVL_COFINS write FVL_COFINS;
    property COD_CTA: String read FCOD_CTA write FCOD_CTA;

    property RegistroC370: TRegistroC370List read FRegistroC370 write FRegistroC370;
    property RegistroC390: TRegistroC390List read FRegistroC390 write FRegistroC390;
  end;

  /// Registro C350 - Lista

  TRegistroC350List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC350; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC350); /// SetItem
  public
    function New: TRegistroC350;
    property Items[Index: Integer]: TRegistroC350 read GetItem write SetItem;
  end;

  /// Registro C370 - ITENS DO DOCUMENTO (C�DIGO 02)

  TRegistroC370 = class
  private
    fNUM_ITEM: String;   /// N�mero seq�encial do item no documento fiscal
    fCOD_ITEM: String;   /// C�digo do Item (campo 02 do registro 0200)
    fQTD: Double;        /// Quantidade do item
    fUNID: String;       /// Unidade do item (campo 02 do registro 0190)
    fVL_ITEM: currency;  /// Valor total do item
    fVL_DESC: currency;  /// Valor total do desconto no item
    FRegistroC380: TRegistroC380List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy
    property NUM_ITEM: String read FNUM_ITEM write FNUM_ITEM;
    property COD_ITEM: String read FCOD_ITEM write FCOD_ITEM;
    property QTD: Double read FQTD write FQTD;
    property UNID: String read FUNID write FUNID;
    property VL_ITEM: currency read FVL_ITEM write FVL_ITEM;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property RegistroC380: TRegistroC380List read FRegistroC380 write FRegistroC380;
  end;

  /// Registro C370 - Lista

  TRegistroC370List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC370; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC370); /// SetItem
  public
    function New: TRegistroC370;
    property Items[Index: Integer]: TRegistroC370 read GetItem write SetItem;
  end;

  /// REGISTRO C380: INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE SA�DA DE MERCADORIAS SUJEITAS � SUBSTITUI��O TRIBUT�RIA (C�DIGO 02)

  TRegistroC380 = class
  private
   fCOD_MOT_REST_COMPL: string; /// C�digo do motivo da restitui��o ou complementa��o conforme Tabela 5.7.
   fQUANT_CONV: currency; ///Quantidade do item.
   fUNID: string; /// Unidade adotada para informar o campo QUANT_CONV.
   fVL_UNIT_CONV: currency; /// Valor unit�rio da mercadoria, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_NA_OPERACAO_CONV: currency; /// Valor unit�rio para o ICMS na opera��o, caso n�o houvesse a ST, considerando unidade utilizada para informar o campo �QUANT_CONV�, aplicando-se a mesma redu��o da base de c�lculo do ICMS ST na tributa��o, se houver.
   fVL_UNIT_ICMS_OP_CONV: currency; /// Valor unit�rio correspondente ao ICMS OP utilizado no c�lculo do ressarcimento / restitui��o, no desfazimento da substitui��o tribut�ria, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_OP_ESTOQUE_CONV: currency; /// Valor m�dio unit�rio do ICMS que o contribuinte teria se creditado referente � opera��o de entrada das mercadorias em estoque caso estivesse submetida ao regime comum de tributa��o, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_ESTOQUE_CONV: currency; /// Valor m�dio unit�rio do ICMS/ST, incluindo FCP ST, das mercadorias em estoque, considerando unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: currency; /// Valor m�dio unit�rio do FCP ST agregado ao ICMS das mercadorias em estoque, considerando unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_CONV_REST: Variant; /// Valor unit�rio do total do ICMS/ST, incluindo FCP ST, a ser restitu�do/ressarcido, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ST_CONV_REST: Variant; /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_REST�, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_CONV_COMPL: Variant; /// Valor unit�rio do complemento do ICMS, incluindo FCP ST, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ST_CONV_COMPL: Variant; /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_COMPL�, considerando unidade utilizada para informar o campo �QUANT_CONV�.
   fCST_ICMS: string; ///C�digo da Situa��o Tribut�ria referente ao ICMS.
   fCFOP: string; /// C�digo Fiscal de Opera��o e Presta��o.
  public
   property COD_MOT_REST_COMPL: string read fCOD_MOT_REST_COMPL  write fCOD_MOT_REST_COMPL;
   property QUANT_CONV: currency read fQUANT_CONV  write fQUANT_CONV;
   property UNID: string read fUNID  write fUNID;
   property VL_UNIT_CONV: currency read fVL_UNIT_CONV  write fVL_UNIT_CONV;
   property VL_UNIT_ICMS_NA_OPERACAO_CONV: currency read fVL_UNIT_ICMS_NA_OPERACAO_CONV  write fVL_UNIT_ICMS_NA_OPERACAO_CONV;
   property VL_UNIT_ICMS_OP_CONV: currency read fVL_UNIT_ICMS_OP_CONV  write fVL_UNIT_ICMS_OP_CONV;
   property VL_UNIT_ICMS_OP_ESTOQUE_CONV: currency read fVL_UNIT_ICMS_OP_ESTOQUE_CONV  write fVL_UNIT_ICMS_OP_ESTOQUE_CONV;
   property VL_UNIT_ICMS_ST_ESTOQUE_CONV: currency read fVL_UNIT_ICMS_ST_ESTOQUE_CONV  write fVL_UNIT_ICMS_ST_ESTOQUE_CONV;
   property VL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: currency read fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV  write fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV;
   property VL_UNIT_ICMS_ST_CONV_REST: Variant read fVL_UNIT_ICMS_ST_CONV_REST  write fVL_UNIT_ICMS_ST_CONV_REST;
   property VL_UNIT_FCP_ST_CONV_REST: Variant read fVL_UNIT_FCP_ST_CONV_REST  write fVL_UNIT_FCP_ST_CONV_REST;
   property VL_UNIT_ICMS_ST_CONV_COMPL: Variant read fVL_UNIT_ICMS_ST_CONV_COMPL  write fVL_UNIT_ICMS_ST_CONV_COMPL;
   property VL_UNIT_FCP_ST_CONV_COMPL: Variant read fVL_UNIT_FCP_ST_CONV_COMPL  write fVL_UNIT_FCP_ST_CONV_COMPL;
   property CST_ICMS: string read fCST_ICMS  write fCST_ICMS;
   property CFOP: string read fCFOP  write fCFOP;
  end;

  /// Registro C380 - Lista

  TRegistroC380List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC380; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC380); /// SetItem
  public
    function New: TRegistroC380;
    property Items[Index: Integer]: TRegistroC380 read GetItem write SetItem;
  end;

  /// Registro C390 - REGISTRO ANAL�TICO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR (C�DIGO 02)

  TRegistroC390 = class
  private
    fCST_ICMS: String;         /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1
    fCFOP: String;             /// C�digo Fiscal de Opera��o e Presta��o
    fALIQ_ICMS: currency;      /// Al�quota do ICMS
    fVL_OPR: currency;         /// Valor total acumulado das opera��es correspondentes � combina��o de CST_ICMS, CFOP e al�quota do ICMS, inclu�das as despesas acess�rias e acr�scimos.
    fVL_BC_ICMS: currency;     /// Valor acumulado da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS.
    fVL_ICMS: currency;        /// Valor acumulado do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_RED_BC: currency;      /// Valor n�o tributado em fun��o da redu��o da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS.
    fCOD_OBS: String;          /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
  public
    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_RED_BC: currency read FVL_RED_BC write FVL_RED_BC;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
  end;

  /// Registro C390 - Lista

  TRegistroC390List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC390; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC390); /// SetItem
  public
    function New: TRegistroC390;
    property Items[Index: Integer]: TRegistroC390 read GetItem write SetItem;
  end;

  /// Registro C400 - EQUIPAMENTO ECF (C�DIGO 02 E 2D)

  TRegistroC400 = class
  private
    fCOD_MOD: String; /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fECF_MOD: String; /// Modelo do equipamento
    fECF_FAB: String; /// N�mero de s�rie de fabrica��o do ECF
    fECF_CX: String;  /// N�mero do caixa atribu�do ao ECF

    FRegistroC405: TRegistroC405List;  /// BLOCO C - Lista de RegistroC405 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read fCOD_MOD write fCOD_MOD;
    property ECF_MOD: String read fECF_MOD write fECF_MOD;
    property ECF_FAB: String read fECF_FAB write fECF_FAB;
    property ECF_CX: String read fECF_CX write fECF_CX;
    /// Registros FILHOS
    property RegistroC405: TRegistroC405List read FRegistroC405 write FRegistroC405;
  end;

  /// Registro C400 - Lista

  TRegistroC400List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC400; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC400); /// SetItem
  public
    function New: TRegistroC400;
    function LocalizaRegistro(const pECF_FAB: string): boolean; {:N�mero de s�rie de fabrica��o do ECF :AJ-31/8/2011 13:57:12:}
    property Items[Index: Integer]: TRegistroC400 read GetItem write SetItem;
  end;

  /// Registro C405 - REDU��O Z (C�DIGO 02 E 2D)

  TRegistroC405 = class
  private
    fDT_DOC: TDateTime;       /// Data do movimento a que se refere a Redu��o Z
    fCRO: integer;            /// Posi��o do Contador de Rein�cio de Opera��o
    fCRZ: integer;            /// Posi��o do Contador de Redu��o Z
    fNUM_COO_FIN: integer;    /// N�mero do Contador de Ordem de Opera��o do �ltimo documento emitido no dia. (N�mero do COO na Redu��o Z)
    fGT_FIN: currency;        /// Valor do Grande Total final
    fVL_BRT: currency;        /// Valor da venda bruta

    FRegistroC410: TRegistroC410List;  /// BLOCO C - Lista de RegistroC410 (FILHO)
    FRegistroC420: TRegistroC420List;  /// BLOCO C - Lista de RegistroC420 (FILHO)
    FRegistroC460: TRegistroC460List;  /// BLOCO C - Lista de RegistroC460 (FILHO)
    FRegistroC490: TRegistroC490List;  /// BLOCO C - Lista de RegistroC490 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property DT_DOC: TDateTime read fDT_DOC write fDT_DOC;
    property CRO: integer read fCRO write fCRO;
    property CRZ: integer read fCRZ write fCRZ;
    property NUM_COO_FIN: integer read fNUM_COO_FIN write fNUM_COO_FIN;
    property GT_FIN: currency read fGT_FIN write fGT_FIN;
    property VL_BRT: currency read fVL_BRT write fVL_BRT;

    property RegistroC410: TRegistroC410List read FRegistroC410 write FRegistroC410;
    property RegistroC420: TRegistroC420List read FRegistroC420 write FRegistroC420;
    property RegistroC460: TRegistroC460List read FRegistroC460 write FRegistroC460;
    property RegistroC490: TRegistroC490List read FRegistroC490 write FRegistroC490;
  end;

  /// Registro C405 - Lista

  TRegistroC405List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC405; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC405); /// SetItem
  public
    function New: TRegistroC405;
    property Items[Index: Integer]: TRegistroC405 read GetItem write SetItem;
  end;

  /// Registro C410 - PIS E COFINS TOTALIZADOS NO DIA (C�DIGO 02 E 2D)

  TRegistroC410 = class
  private
    fVL_PIS: currency;      /// 'Valor total do PIS
    fVL_COFINS: currency;   /// 'Valor total da COFINS
  public
    property VL_PIS: currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: currency read FVL_COFINS write FVL_COFINS;
  end;

  /// Registro C410 - Lista

  TRegistroC410List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC410; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC410); /// SetItem
  public
    function New: TRegistroC410;
    property Items[Index: Integer]: TRegistroC410 read GetItem write SetItem;
  end;

  /// Registro C420 - REGISTRO DOS TOTALIZADORES PARCIAIS DA REDU��O Z (COD 02 E 2D)

  TRegistroC420 = class
  private
    fCOD_TOT_PAR: String;     /// C�digo do totalizador, conforme Tabela 4.4.6
    fVLR_ACUM_TOT: currency;  /// Valor acumulado no totalizador, relativo � respectiva Redu��o Z.
    fNR_TOT: integer;         /// N�mero do totalizador quando ocorrer mais de uma situa��o com a mesma carga tribut�ria efetiva.
    fDESCR_NR_TOT: String;    /// Descri��o da situa��o tribut�ria relativa ao totalizador parcial, quando houver mais de um com a mesma carga tribut�ria efetiva.

    FRegistroC425: TRegistroC425List;  /// BLOCO C - Lista de RegistroC425 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_TOT_PAR: String read fCOD_TOT_PAR write fCOD_TOT_PAR;
    property VLR_ACUM_TOT: currency read fVLR_ACUM_TOT write fVLR_ACUM_TOT;
    property NR_TOT: integer read fNR_TOT write fNR_TOT;
    property DESCR_NR_TOT: String read fDESCR_NR_TOT write fDESCR_NR_TOT;
    /// Registros FILHOS
    property RegistroC425: TRegistroC425List read FRegistroC425 write FRegistroC425;
  end;

  /// Registro C420 - Lista

  TRegistroC420List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC420; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC420); /// SetItem
  public
    function New: TRegistroC420;
    property Items[Index: Integer]: TRegistroC420 read GetItem write SetItem;
  end;

  /// Registro C425 - RESUMO DE ITENS DO MOVIMENTO DI�RIO (C�DIGO 02 E 2D)

  TRegistroC425 = class
  private
    fCOD_ITEM: String;           /// C�digo do item (campo 02 do Registro 0200):
    fQTD: Double;              /// Quantidade acumulada do item:
    fUNID: String;               /// Unidade do item (Campo 02 do registro 0190)
    fVL_ITEM: currency;          /// Valor acumulado do item:
    fVL_PIS: currency;           /// Valor do PIS
    fVL_COFINS: currency;        /// Valor da COFINS
    FRegistroC430: TRegistroC430List;  /// BLOCO C - Lista de RegistroC430 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy
    property COD_ITEM: String read FCOD_ITEM write FCOD_ITEM;
    property QTD: Double read FQTD write FQTD;
    property UNID: String read FUNID write FUNID;
    property VL_ITEM: currency read FVL_ITEM write FVL_ITEM;
    property VL_PIS: currency read fVL_PIS write fVL_PIS;
    property VL_COFINS: currency read fVL_COFINS write fVL_COFINS;
    property RegistroC430: TRegistroC430List read FRegistroC430 write FRegistroC430;
  end;

  /// Registro C425 - Lista

  TRegistroC425List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC425; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC425); /// SetItem
  public
    function New: TRegistroC425;
    property Items[Index: Integer]: TRegistroC425 read GetItem write SetItem;
  end;

  /// REGISTRO C430: INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE SA�DA DE MERCADORIAS SUJEITAS � SUBSTITUI��O TRIBUT�RIA (C�DIGO 02, 2D e 60)

  TRegistroC430 = class
  private
   fCOD_MOT_REST_COMPL: string; /// C�digo do motivo da restitui��o ou complementa��o conforme Tabela 5.7.
   fQUANT_CONV: currency; /// Quantidade do item.
   fUNID: string; /// Unidade adotada para informar o campo QUANT_CONV.
   fVL_UNIT_CONV: currency; /// Valor unit�rio da mercadoria, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_NA_OPERACAO_CONV: currency; /// Valor unit�rio para o ICMS na opera��o, caso n�o houvesse a ST, considerando unidade utilizada para informar o campo �QUANT_CONV�, considerando redu��o da base de c�lculo do ICMS ST na tributa��o, se houver.
   fVL_UNIT_ICMS_OP_CONV: currency; /// Valor unit�rio do ICMS que o contribuinte teria se creditado, ou pode se creditar, referente � opera��o de entrada da mercadoria, caso estivesse submetida ao regime comum de tributa��o, no desfazimento da substitui��o tribut�ria, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_OP_ESTOQUE_CONV: currency; /// Valor m�dio unit�rio do ICMS que o contribuinte teria se creditado referente � opera��o de entrada das mercadorias em estoque caso estivesse submetida ao regime comum de tributa��o, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_ESTOQUE_CONV: currency; /// Valor m�dio unit�rio do ICMS/ST, incluindo FCP ST, das mercadorias em estoque, considerando unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: currency; /// Valor m�dio unit�rio do FCP ST agregado ao ICMS das mercadorias em estoque, considerando unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_CONV_REST: Variant; /// Valor unit�rio do total do ICMS/ST, incluindo FCP ST, a ser restitu�do/ressarcido, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ST_CONV_REST: Variant; /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_REST�, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_ICMS_ST_CONV_COMPL: Variant; /// Valor unit�rio do complemento do ICMS, incluindo FCP ST, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
   fVL_UNIT_FCP_ST_CONV_COMPL: Variant; /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_COMPL�, considerando unidade utilizada para informar o campo �QUANT_CONV�.
   fCST_ICMS: string; /// C�digo da Situa��o Tribut�ria referente ao ICMS.
   fCFOP: string;/// C�digo Fiscal de Opera��o e Presta��o
  public
   property COD_MOT_REST_COMPL: string read fCOD_MOT_REST_COMPL  write fCOD_MOT_REST_COMPL;
   property QUANT_CONV: currency read fQUANT_CONV  write fQUANT_CONV;
   property UNID: string read fUNID  write fUNID;
   property VL_UNIT_CONV: currency read fVL_UNIT_CONV  write fVL_UNIT_CONV;
   property VL_UNIT_ICMS_NA_OPERACAO_CONV: currency read fVL_UNIT_ICMS_NA_OPERACAO_CONV  write fVL_UNIT_ICMS_NA_OPERACAO_CONV;
   property VL_UNIT_ICMS_OP_CONV: currency read fVL_UNIT_ICMS_OP_CONV  write fVL_UNIT_ICMS_OP_CONV;
   property VL_UNIT_ICMS_OP_ESTOQUE_CONV: currency read fVL_UNIT_ICMS_OP_ESTOQUE_CONV  write fVL_UNIT_ICMS_OP_ESTOQUE_CONV;
   property VL_UNIT_ICMS_ST_ESTOQUE_CONV: currency read fVL_UNIT_ICMS_ST_ESTOQUE_CONV  write fVL_UNIT_ICMS_ST_ESTOQUE_CONV;
   property VL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: currency read fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV  write fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV;
   property VL_UNIT_ICMS_ST_CONV_REST: Variant read fVL_UNIT_ICMS_ST_CONV_REST  write fVL_UNIT_ICMS_ST_CONV_REST;
   property VL_UNIT_FCP_ST_CONV_REST: Variant read fVL_UNIT_FCP_ST_CONV_REST  write fVL_UNIT_FCP_ST_CONV_REST;
   property VL_UNIT_ICMS_ST_CONV_COMPL: Variant read fVL_UNIT_ICMS_ST_CONV_COMPL  write fVL_UNIT_ICMS_ST_CONV_COMPL;
   property VL_UNIT_FCP_ST_CONV_COMPL: Variant read fVL_UNIT_FCP_ST_CONV_COMPL  write fVL_UNIT_FCP_ST_CONV_COMPL;
   property CST_ICMS: string read fCST_ICMS  write fCST_ICMS;
   property CFOP: string read fCFOP  write fCFOP;
  end;

  /// Registro C430 - Lista

  TRegistroC430List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC430; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC430); /// SetItem
  public
    function New: TRegistroC430;
    property Items[Index: Integer]: TRegistroC430 read GetItem write SetItem;
  end;

  /// Registro C460 - DOCUMENTO FISCAL EMITIDO POR ECF (C�DIGO 02 E 2D)

  TRegistroC460 = class
  private
    fCOD_MOD: String;             /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fCOD_SIT: TACBrCodSit;        /// C�digo da situa��o do documento fiscal, conforme a Tabela 4.1.2
    fNUM_DOC: String;             /// N�mero do documento fiscal (COO)
    fDT_DOC: TDateTime;           /// Data da emiss�o do documento fiscal
    fVL_DOC: currency;            /// Valor total do documento fiscal
    fVL_PIS: currency;            /// Valor do PIS
    fVL_COFINS: currency;         /// Valor da COFINS
    fCPF_CNPJ: String;            /// CPF ou CNPJ do adquirente
    fNOM_ADQ: String;             /// Nome do adquirente

    FRegistroC465: TRegistroC465List;
    FRegistroC470: TRegistroC470List;  /// BLOCO C - Lista de RegistroC460 (FILHO)
 public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read fCOD_MOD write fCOD_MOD;
    property COD_SIT: TACBrCodSit read fCOD_SIT write fCOD_SIT;
    property NUM_DOC: String read fNUM_DOC write fNUM_DOC;
    property DT_DOC: TDateTime read fDT_DOC write fDT_DOC;
    property VL_DOC: currency read fVL_DOC write fVL_DOC;
    property VL_PIS: currency read fVL_PIS write fVL_PIS;
    property VL_COFINS: currency read fVL_COFINS write fVL_COFINS;
    property CPF_CNPJ: String read fCPF_CNPJ write fCPF_CNPJ;
    property NOM_ADQ: String read fNOM_ADQ write fNOM_ADQ;
    /// Registros FILHOS
    property RegistroC465: TRegistroC465List read FRegistroC465 write FRegistroC465;
    property RegistroC470: TRegistroC470List read FRegistroC470 write FRegistroC470;
  end;

  /// Registro C460 - Lista

  TRegistroC460List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC460; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC460); /// SetItem
  public
    function New: TRegistroC460;
    property Items[Index: Integer]: TRegistroC460 read GetItem write SetItem;
  end;

  /// Registro C465 - CUPOM FISCAL ELETR�NICO REFERENCIADO {Altera��o Vers�o 2.0.4 03Mar2011}

  TRegistroC465 = class
  private
    fCHV_CFE: String;                   /// Chave do Cupom Fiscal Eletr�nico
    fNUM_CCF: String;                   /// N�mero do cupom fiscal eletr�nico
  public
    property CHV_CFE: String read FCHV_CFE write FCHV_CFE;
    property NUM_CCF: String read FNUM_CCF write FNUM_CCF;
  end;

  /// Registro C465 - Lista

  TRegistroC465List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC465; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC465); /// SetItem
  public
    function New: TRegistroC465;
    property Items[Index: Integer]: TRegistroC465 read GetItem write SetItem;
  end;

  /// Registro C470 - ITENS DO DOCUMENTO FISCAL EMITIDO POR ECF (C�DIGO 02 E 2D)

  TRegistroC470 = class
  private
    fCOD_ITEM: String;       /// C�digo do item (campo 02 do Registro 0200):
    fQTD: Double;            /// Quantidade do item
    fQTD_CANC: Double;       /// Quantidade cancelada, no caso de cancelamento parcial de item
    fUNID: String;           /// Unidade do item (Campo 02 do registro 0190)
    fVL_ITEM: currency;      /// Valor do item:
    fCST_ICMS: String;       /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1.
    fCFOP: String;           /// C�digo Fiscal de Opera��o e Presta��o
    fALIQ_ICMS: Currency;    /// Al�quota do ICMS - Carga tribut�ria efetiva em percentual
    fVL_PIS: currency;       /// Valor do PIS
    fVL_COFINS: currency;    /// Valor da COFINS
    FRegistroC480: TRegistroC480List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy
    property COD_ITEM: String read FCOD_ITEM write FCOD_ITEM;
    property QTD: Double read FQTD write FQTD;
    property QTD_CANC: Double read FQTD_CANC write FQTD_CANC;
    property UNID: String read FUNID write FUNID;
    property VL_ITEM: currency read FVL_ITEM write FVL_ITEM;
    property CST_ICMS: String read fCST_ICMS write fCST_ICMS;
    property CFOP: String read fCFOP write fCFOP;
    property ALIQ_ICMS: Currency read fALIQ_ICMS write fALIQ_ICMS;
    property VL_PIS: currency read fVL_PIS write fVL_PIS;
    property VL_COFINS: currency read fVL_COFINS write fVL_COFINS;
    property RegistroC480: TRegistroC480List read FRegistroC480 write FRegistroC480;
  end;

  /// Registro C470 - Lista

  TRegistroC470List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC470; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC470); /// SetItem
  public
    function New: TRegistroC470;
    property Items[Index: Integer]: TRegistroC470 read GetItem write SetItem;
  end;

  /// REGISTRO C480: INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE SA�DA DE MERCADORIAS SUJEITAS � SUBSTITUI��O TRIBUT�RIA (C�DIGO 02, 2D e 60)

  TRegistroC480 = class
  private
  fCOD_MOT_REST_COMPL: string; /// C�digo do motivo da restitui��o ou complementa��o conforme Tabela 5.7.
  fQUANT_CONV: Currency; /// Quantidade do item.
  fUNID: string; /// Unidade adotada para informar o campo QUANT_CONV.
  fVL_UNIT_CONV: Currency; /// Valor unit�rio da mercadoria, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
  fVL_UNIT_ICMS_NA_OPERACAO_CONV: Currency; /// Valor unit�rio para o ICMS na opera��o, caso n�o houvesse a ST, considerando unidade utilizada para informar o campo �QUANT_CONV�, aplicando-se a mesma redu��o da base de c�lculo do ICMS ST na tributa��o, se houver.
  fVL_UNIT_ICMS_OP_CONV: Currency; /// Valor unit�rio correspondente ao ICMS OP utilizado no c�lculo do ressarcimento / restitui��o, no desfazimento da substitui��o tribut�ria, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
  fVL_UNIT_ICMS_OP_ESTOQUE_CONV: Currency; /// Valor m�dio unit�rio do ICMS que o contribuinte teria se creditado referente � opera��o de entrada das mercadorias em estoque caso estivesse submetida ao regime comum de tributa��o, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
  fVL_UNIT_ICMS_ST_ESTOQUE_CONV: Currency; /// Valor m�dio unit�rio do ICMS/ST, incluindo FCP ST, das mercadorias em estoque, considerando unidade utilizada para informar o campo �QUANT_CONV�.
  fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: Currency; /// Valor m�dio unit�rio do FCP ST agregado ao ICMS das mercadorias em estoque, considerando unidade utilizada para informar o campo �QUANT_CONV�.
  fVL_UNIT_ICMS_ST_CONV_REST: Variant; /// Valor unit�rio do total do ICMS/ST, incluindo FCP ST, a ser restitu�do/ressarcido, calculado conforme a legisla��o de cada UF, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
  fVL_UNIT_FCP_ST_CONV_REST: Variant; /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_REST�, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
  fVL_UNIT_ICMS_ST_CONV_COMPL: Variant; /// Valor unit�rio do complemento do ICMS, incluindo FCP ST, considerando a unidade utilizada para informar o campo �QUANT_CONV�.
  fVL_UNIT_FCP_ST_CONV_COMPL: Variant; /// Valor unit�rio correspondente � parcela de ICMS FCP ST que comp�e o campo �VL_UNIT_ICMS_ST_CONV_COMPL�, considerando unidade utilizada para informar o campo �QUANT_CONV�.
  fCST_ICMS: string; /// C�digo da Situa��o Tribut�ria referente ao ICMS.
  fCFOP: string; /// C�digo Fiscal de Opera��o e Presta��o.
 public
   property COD_MOT_REST_COMPL: string read fCOD_MOT_REST_COMPL  write fCOD_MOT_REST_COMPL;
   property QUANT_CONV: Currency read fQUANT_CONV  write fQUANT_CONV;
   property UNID: string read fUNID  write fUNID;
   property VL_UNIT_CONV: Currency read fVL_UNIT_CONV  write fVL_UNIT_CONV;
   property VL_UNIT_ICMS_NA_OPERACAO_CONV: Currency read fVL_UNIT_ICMS_NA_OPERACAO_CONV  write fVL_UNIT_ICMS_NA_OPERACAO_CONV;
   property VL_UNIT_ICMS_OP_CONV: Currency read fVL_UNIT_ICMS_OP_CONV  write fVL_UNIT_ICMS_OP_CONV;
   property VL_UNIT_ICMS_OP_ESTOQUE_CONV: Currency read fVL_UNIT_ICMS_OP_ESTOQUE_CONV  write fVL_UNIT_ICMS_OP_ESTOQUE_CONV;
   property VL_UNIT_ICMS_ST_ESTOQUE_CONV: Currency read fVL_UNIT_ICMS_ST_ESTOQUE_CONV  write fVL_UNIT_ICMS_ST_ESTOQUE_CONV;
   property VL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: Currency read fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV  write fVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV;
   property VL_UNIT_ICMS_ST_CONV_REST: Variant read fVL_UNIT_ICMS_ST_CONV_REST  write fVL_UNIT_ICMS_ST_CONV_REST;
   property VL_UNIT_FCP_ST_CONV_REST: Variant read fVL_UNIT_FCP_ST_CONV_REST  write fVL_UNIT_FCP_ST_CONV_REST;
   property VL_UNIT_ICMS_ST_CONV_COMPL: Variant read fVL_UNIT_ICMS_ST_CONV_COMPL  write fVL_UNIT_ICMS_ST_CONV_COMPL;
   property VL_UNIT_FCP_ST_CONV_COMPL: Variant read fVL_UNIT_FCP_ST_CONV_COMPL  write fVL_UNIT_FCP_ST_CONV_COMPL;
   property CST_ICMS: string read fCST_ICMS  write fCST_ICMS;
   property CFOP: string read fCFOP  write fCFOP;
  end;

   /// Registro C480 - Lista

  TRegistroC480List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC480; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC480); /// SetItem
  public
    function New: TRegistroC480;
    property Items[Index: Integer]: TRegistroC480 read GetItem write SetItem;
  end;

  /// Registro C490 - REGISTRO ANAL�TICO DO MOVIMENTO DI�RIO (C�DIGO 02 E 2D)

  TRegistroC490 = class
  private
    fCST_ICMS: String;     /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1
    fCFOP: String;         /// C�digo Fiscal de Opera��o e Presta��o
    fALIQ_ICMS: currency;      /// Al�quota do ICMS
    fVL_OPR: currency;         /// Valor da opera��o correspondente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS, inclu�das as despesas acess�rias e acr�scimos
    fVL_BC_ICMS: currency;     /// Valor acumulado da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS.
    fVL_ICMS: currency;        /// Valor acumulado do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fCOD_OBS: String;      /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
  public
    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
  end;

  /// Registro C490 - Lista

  TRegistroC490List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC490; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC490); /// SetItem
  public
    function New: TRegistroC490;
    property Items[Index: Integer]: TRegistroC490 read GetItem write SetItem;
  end;

  /// Registro C495 - RESUMO MENSAL DE ITENS DO ECF POR ESTABELECIMENTO (C�DIGO 02, 2D)

  TRegistroC495 = class
  private
    fALIQ_ICMS: currency;      /// Al�quota do ICMS
    fCOD_ITEM: String;     /// C�digo do item (campo 02 do Registro 0200)
    fQTD: Double;              /// Quantidade acumulada do item
    fQTD_CANC: Double;         /// Quantidade cancelada acumulada, no caso de cancelamento parcial de item
    fUNID: String;         /// Unidade do item (Campo 02 do registro 0190)
    fVL_ITEM: currency;        /// Valor acumulado do item
    fVL_DESC: currency;        /// Valor acumulado dos descontos
    fVL_CANC: currency;        /// Valor acumulado dos cancelamentos
    fVL_ACMO: currency;        /// Valor acumulado dos acr�scimos
    fVL_BC_ICMS: currency;     /// Valor acumulado da base de c�lculo do ICMS
    fVL_ICMS: currency;        /// Valor acumulado do ICMS
    fVL_ISEN: currency;        /// Valor das sa�das isentas do ICMS
    fVL_NT: currency;          /// Valor das sa�das sob n�o-incid�ncia ou n�o-tributadas pelo ICMS
    fVL_ICMS_ST: currency;     /// Valor das sa�das de mercadorias adquiridas com substitui��o tribut�ria do ICMS
  public
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property COD_ITEM: String read FCOD_ITEM write FCOD_ITEM;
    property QTD: Double read FQTD write FQTD;
    property QTD_CANC: Double read FQTD_CANC write FQTD_CANC;
    property UNID: String read FUNID write FUNID;
    property VL_ITEM: currency read FVL_ITEM write FVL_ITEM;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property VL_CANC: currency read FVL_CANC write FVL_CANC;
    property VL_ACMO: currency read FVL_ACMO write FVL_ACMO;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_ISEN: currency read FVL_ISEN write FVL_ISEN;
    property VL_NT: currency read FVL_NT write FVL_NT;
    property VL_ICMS_ST: currency read FVL_ICMS_ST write FVL_ICMS_ST;
  end;

  /// Registro C495 - Lista

  TRegistroC495List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC495; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC495); /// SetItem
  public
    function New: TRegistroC495;
    property Items[Index: Integer]: TRegistroC495 read GetItem write SetItem;
  end;

  /// Registro C500 - NOTA FISCAL/CONTA DE ENERGIA EL�TRICA (C�DIGO 06) E NOTA FISCAL CONSUMO FORNECIMENTO DE G�S (C�DIGO 28)

  TRegistroC500 = class
  private
    fIND_OPER: TACBrIndOper;             /// Indicador do tipo de opera��o: 0 - Entrada; 1- Sa�da
    fIND_EMIT: TACBrIndEmit;             /// Indicador do emitente do documento fiscal: 0- Emiss�o pr�pria; 1- Terceiros
    fCOD_PART: String;                   /// C�digo do participante (campo 02 do Registro 0150): - do adquirente, no caso das sa�das; - do fornecedor no caso de entradas
    fCOD_MOD: String;                    /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fCOD_SIT: TACBrCodSit;               /// C�digo da situa��o do documento fiscal, conforme a Tabela 4.1.2
    fSER: String;                        /// S�rie do documento fiscal
    fSUB: String;                        /// Subs�rie do documento fiscal
//    fCOD_CONS: TACBrClasseConsumo;       /// C�digo de classe de consumo de energia el�trica, conforme a Tabela 4.4.5 ou C�digo da classe de consumo de g�s canalizado conforme Tabela 4.4.3.
    fCOD_CONS: String;                   /// C�digo de classe de consumo de energia el�trica, conforme a Tabela 4.4.5 ou C�digo da classe de consumo de g�s canalizado conforme Tabela 4.4.3.
    fNUM_DOC: String;                    /// N�mero do documento fiscal
    fDT_DOC: TDateTime;                  /// Data da emiss�o do documento fiscal
    fDT_E_S: TDateTime;                  /// Data da entrada ou da sa�da
    fVL_DOC: currency;                   /// Valor total do documento fiscal
    fVL_DESC: currency;                  /// Valor total do desconto
    fVL_FORN: currency;                  /// Valor total fornecido/consumido
    fVL_SERV_NT: currency;               /// Valor total dos servi�os n�o-tributados pelo ICMS
    fVL_TERC: currency;                  /// Valor total cobrado em nome de terceiros
    fVL_DA: currency;                    /// Valor total de despesas acess�rias indicadas no documento fiscal
    fVL_BC_ICMS: currency;               /// Valor acumulado da base de c�lculo do ICMS
    fVL_ICMS: currency;                  /// Valor acumulado do ICMS
    fVL_BC_ICMS_ST: currency;            /// Valor acumulado da base de c�lculo do ICMS substitui��o tribut�ria
    fVL_ICMS_ST: currency;               /// Valor acumulado do ICMS retido por substitui��o tribut�ria
    fCOD_INF: string;                    /// C�digo da informa��o complementar do documento fiscal (campo 02 do Registro 0450)
    fVL_PIS: currency;                   /// Valor do PIS
    fVL_COFINS: currency;                /// Valor da COFINS
    fTP_LIGACAO: TACBrTipoLigacao;       /// C�digo de tipo de Liga��o [ 1 - Monof�sico 2 - Bif�sico 3 - Trif�sico ]
    fCOD_GRUPO_TENSAO: TACBrGrupoTensao; /// C�digo de grupo de tens�o: Vide Manual Registro C500 Campo 27
    fCHV_DOCe: string;                   /// Chave da Nota Fiscal de Energia El�trica Eletr�nica
    fFIN_DOCe: TACBrFinalidadeEmissaoDocumentoEletronico; /// Finalidade da emiss�o do documento eletr�nico
    FCHV_DOCe_REF: string;               /// Chave da nota referenciada.
    FIND_DEST: TACBrIndicadorDestinatarioAcessante; /// Indicador do Destinat�rio/Acessante:
    FCOD_MUN_DEST: string;               /// C�digo do munic�pio do destinat�rio conforme a tabela do IBGE.
    fCOD_CTA: string;                    /// C�digo da conta anal�tica cont�bil debitada/creditada
    FCOD_MOD_DOC_REF: string;            /// C�digo do modelo do documento fiscal referenciado, conforme a Tabela 4.1.1
    FHASH_DOC_REF: string;               /// C�digo de autentica��o digital do registro (Conv�nio 115/2003).
    FSER_DOC_REF: string;                /// S�rie do documento fiscal referenciado.
    FNUM_DOC_REF: string;                /// N�mero do documento fiscal referenciado.
    FMES_DOC_REF: string;                /// M�s e ano da emiss�o do documento fiscal referenciado.
    FOUTRAS_DED: Variant;                 /// Energia injetada
    FENER_INJET: Variant;                 /// Outras dedu��es

    FRegistroC510: TRegistroC510List;  /// BLOCO C - Lista de RegistroC510 (FILHO)
    FRegistroC590: TRegistroC590List;  /// BLOCO C - Lista de RegistroC590 (FILHO)
    FRegistroC595: TRegistroC595List;  /// BLOCO C - Lista de RegistroC595 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property IND_OPER: TACBrIndOper read fIND_OPER write fIND_OPER;
    property IND_EMIT: TACBrIndEmit read fIND_EMIT write fIND_EMIT;
    property COD_PART: String read fCOD_PART write fCOD_PART;
    property COD_MOD: String read fCOD_MOD write fCOD_MOD;
    property COD_SIT: TACBrCodSit read fCOD_SIT write fCOD_SIT;
    property SER: String read fSER write fSER;
    property SUB: String read fSUB write fSUB;
//    property COD_CONS: TACBrClasseConsumo read fCOD_CONS write fCOD_CONS;
    property COD_CONS: String read fCOD_CONS write fCOD_CONS;
    property NUM_DOC: String read fNUM_DOC write fNUM_DOC;
    property DT_DOC: TDateTime read fDT_DOC write fDT_DOC;
    property DT_E_S: TDateTime read fDT_E_S write fDT_E_S;
    property VL_DOC: currency read fVL_DOC write fVL_DOC;
    property VL_DESC: currency read fVL_DESC write fVL_DESC;
    property VL_FORN: currency read fVL_FORN write fVL_FORN;
    property VL_SERV_NT: currency read fVL_SERV_NT write fVL_SERV_NT;
    property VL_TERC: currency read fVL_TERC write fVL_TERC;
    property VL_DA: currency read fVL_DA write fVL_DA;
    property VL_BC_ICMS: currency read fVL_BC_ICMS write fVL_BC_ICMS;
    property VL_ICMS: currency read fVL_ICMS write fVL_ICMS;
    property VL_BC_ICMS_ST: currency read fVL_BC_ICMS_ST write fVL_BC_ICMS_ST;
    property VL_ICMS_ST: currency read fVL_ICMS_ST write fVL_ICMS_ST;
    property COD_INF: String read fCOD_INF write fCOD_INF;
    property VL_PIS: currency read fVL_PIS write fVL_PIS;
    property VL_COFINS: currency read fVL_COFINS write fVL_COFINS;
    property TP_LIGACAO:        TACBrTipoLigacao read fTP_LIGACAO       write fTP_LIGACAO;
    property COD_GRUPO_TENSAO:  TACBrGrupoTensao read fCOD_GRUPO_TENSAO write fCOD_GRUPO_TENSAO;
    property CHV_DOCe: String read fCHV_DOCe write fCHV_DOCe;
    property FIN_DOCe: TACBrFinalidadeEmissaoDocumentoEletronico read fFIN_DOCe write fFIN_DOCe;
    property CHV_DOCe_REF: string read FCHV_DOCe_REF write FCHV_DOCe_REF;
    property IND_DEST: TACBrIndicadorDestinatarioAcessante read FIND_DEST write FIND_DEST;
    property COD_MUN_DEST: string read FCOD_MUN_DEST write FCOD_MUN_DEST;
    property COD_CTA: String read fCOD_CTA write fCOD_CTA;
    property COD_MOD_DOC_REF: string read FCOD_MOD_DOC_REF write FCOD_MOD_DOC_REF;
    property HASH_DOC_REF: string read FHASH_DOC_REF write FHASH_DOC_REF;
    property SER_DOC_REF: string read FSER_DOC_REF write FSER_DOC_REF;
    property NUM_DOC_REF: string read FNUM_DOC_REF write FNUM_DOC_REF;
    property MES_DOC_REF: string read FMES_DOC_REF write FMES_DOC_REF;
    property ENER_INJET: Variant read FENER_INJET write FENER_INJET;
    property OUTRAS_DED: Variant read FOUTRAS_DED write FOUTRAS_DED;

    /// Registros FILHOS
    property RegistroC510: TRegistroC510List read FRegistroC510 write FRegistroC510;
    property RegistroC590: TRegistroC590List read FRegistroC590 write FRegistroC590;
    property RegistroC595: TRegistroC595List read FRegistroC595 write FRegistroC595;

  end;

  /// Registro C500 - Lista

  TRegistroC500List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC500; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC500); /// SetItem
  public
    function New: TRegistroC500;
    property Items[Index: Integer]: TRegistroC500 read GetItem write SetItem;
  end;

  /// Registro C510 - ITENS DO DOCUMENTO NOTA FISCAL/CONTA ENERGIA EL�TRICA (C�DIGO 06) E NOTA FISCAL/CONTA DE FORNECIMENTO DE G�S (C�DIGO 28)

  TRegistroC510 = class
  private
    fNUM_ITEM: String;          /// N�mero seq�encial do item no documento fiscal
    fCOD_ITEM: String;          /// C�digo do item (campo 02 do Registro 0200)
    fCOD_CLASS: String;         /// C�digo de classifica��o do item de energia el�trica, conforme a Tabela 4.4.1
    fQTD: Double;               /// Quantidade do item
    fUNID: String;              /// Unidade do item (Campo 02 do registro 0190)
    fVL_ITEM: currency;         /// Valor do item
    fVL_DESC: currency;         /// Valor total do desconto
    fCST_ICMS: String;          /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1
    fCFOP: String;              /// C�digo Fiscal de Opera��o e Presta��o
    fVL_BC_ICMS: currency;      /// Valor da base de c�lculo do ICMS
    fALIQ_ICMS: Currency;       /// Al�quota do ICMS
    fVL_ICMS: currency;         /// Valor do ICMS creditado/debitado
    fVL_BC_ICMS_ST: currency;   /// Valor da base de c�lculo referente � substitui��o tribut�ria
    fALIQ_ST: Currency;         /// Al�quota do ICMS da substitui��o tribut�ria na unidade da federa��o de destino
    fVL_ICMS_ST: currency;      /// Valor do ICMS referente � substitui��o tribut�ria
    fIND_REC: TACBrTipoReceita; /// Indicador do tipo de receita: 0- Receita pr�pria; 1- Receita de terceiros
    fCOD_PART: String;          /// C�digo do participante receptor da receita, terceiro da opera��o (campo 02 do Registro 0150)
    fVL_PIS: currency;          /// Valor do PIS
    fVL_COFINS: currency;       /// Valor da COFINS
    fCOD_CTA: String;           /// C�digo da conta anal�tica cont�bil debitada/creditada
  public
    property NUM_ITEM: String read fNUM_ITEM write fNUM_ITEM;
    property COD_ITEM: String read fCOD_ITEM write fCOD_ITEM;
    property COD_CLASS: String read fCOD_CLASS write fCOD_CLASS;
    property QTD: Double read fQTD write fQTD;
    property UNID: String read fUNID write fUNID;
    property VL_ITEM: currency read fVL_ITEM write fVL_ITEM;
    property VL_DESC: currency read fVL_DESC write fVL_DESC;
    property CST_ICMS: String read fCST_ICMS write fCST_ICMS;
    property CFOP: String read fCFOP write fCFOP;
    property VL_BC_ICMS: currency read fVL_BC_ICMS write fVL_BC_ICMS;
    property ALIQ_ICMS: Currency read fALIQ_ICMS write fALIQ_ICMS;
    property VL_ICMS: currency read fVL_ICMS write fVL_ICMS;
    property VL_BC_ICMS_ST: currency read fVL_BC_ICMS_ST write fVL_BC_ICMS_ST;
    property ALIQ_ST: Currency read fALIQ_ST write fALIQ_ST;
    property VL_ICMS_ST: currency read fVL_ICMS_ST write fVL_ICMS_ST;
    property IND_REC: TACBrTipoReceita read fIND_REC write fIND_REC;
    property COD_PART: String read fCOD_PART write fCOD_PART;
    property VL_PIS: currency read fVL_PIS write fVL_PIS;
    property VL_COFINS: currency read fVL_COFINS write fVL_COFINS;
    property COD_CTA: String read fCOD_CTA write fCOD_CTA;
  end;

  /// Registro C510 - Lista

  TRegistroC510List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC510; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC510); /// SetItem
  public
    function New: TRegistroC510;
    property Items[Index: Integer]: TRegistroC510 read GetItem write SetItem;
  end;

  /// Registro C590 - REGISTRO ANAL�TICO DO DOCUMENTO - NOTA FISCAL/CONTA DE ENERGIA EL�TRICA (C�DIGO 06) E NOTA FISCAL CONSUMO FORNECIMENTO DE G�S (C�DIGO 28)

  TRegistroC590 = class
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
    FRegistroC591: TRegistroC591List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy
    property CST_ICMS: String read fCST_ICMS write fCST_ICMS;
    property CFOP: String read fCFOP write fCFOP;
    property ALIQ_ICMS: Currency read fALIQ_ICMS write fALIQ_ICMS;
    property VL_OPR: currency read fVL_OPR write fVL_OPR;
    property VL_BC_ICMS: currency read fVL_BC_ICMS write fVL_BC_ICMS;
    property VL_ICMS: currency read fVL_ICMS write fVL_ICMS;
    property VL_BC_ICMS_ST: currency read fVL_BC_ICMS_ST write fVL_BC_ICMS_ST;
    property VL_ICMS_ST: currency read fVL_ICMS_ST write fVL_ICMS_ST;
    property VL_RED_BC: currency read fVL_RED_BC write fVL_RED_BC;
    property COD_OBS: String read fCOD_OBS write fCOD_OBS;
    property RegistroC591: TRegistroC591List read FRegistroC591 write FRegistroC591;
  end;

  /// Registro C590 - Lista

  TRegistroC590List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC590; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC590); /// SetItem
  public
    function New: TRegistroC590;
    property Items[Index: Integer]: TRegistroC590 read GetItem write SetItem;
  end;

  /// REGISTRO C591: INFORMA��ES DO FUNDO DE COMBATE � POBREZA � FCP NA NF3e (C�DIGO 66)

  TRegistroC591 = class
  private
   fVL_FCP_OP: currency; /// Valor do Fundo de Combate � Pobreza (FCP) vinculado � opera��o pr�pria, na combina��o de CST_ICMS, CFOP e al�quota do ICMS
   fVL_FCP_ST: currency; /// Valor do Fundo de Combate � Pobreza (FCP) vinculado � opera��o de substitui��o tribut�ria, na combina��o de CST_ICMS, CFOP e al�quota do ICMS.
  public
   property VL_FCP_OP: currency read fVL_FCP_OP write fVL_FCP_OP;
   property VL_FCP_ST: currency read fVL_FCP_ST write fVL_FCP_ST;

  end;

  /// Registro C591 - Lista

  TRegistroC591List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC591; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC591); /// SetItem
  public
    function New: TRegistroC591;
    property Items[Index: Integer]: TRegistroC591 read GetItem write SetItem;
  end;

  /// Registro C595: OBSERVA��ES DO LAN�AMENTO FISCAL (C�DIGOS 06, 28, 29 e 66)
  TRegistroC595 = class
  private
   fCOD_OBS: string; /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460).
   fTXT_COMPL: string; /// Descri��o complementar do c�digo de observa��o.
   FRegistroC597: TRegistroC597List;
  public
   constructor Create; virtual; /// Create
   destructor Destroy; override; /// Destroy
   property COD_OBS: string read fCOD_OBS write fCOD_OBS;
   property TXT_COMPL: string read fTXT_COMPL write fTXT_COMPL;
   property RegistroC597: TRegistroC597List read FRegistroC597 write FRegistroC597;
  end;

  /// Registro C595 - Lista

  TRegistroC595List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC595; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC595); /// SetItem
  public
    function New: TRegistroC595;
    property Items[Index: Integer]: TRegistroC595 read GetItem write SetItem;
  end;

  /// REGISTRO C597: OUTRAS OBRIGA��ES TRIBUT�RIAS, AJUSTES E INFORMA��ES DE VALORES PROVENIENTES DE DOCUMENTO FISCAL.

  TRegistroC597 = class
  private
   fCOD_AJ: string; /// C�digo do ajustes/benef�cio/incentivo, conforme tabela indicada no item 5.3.
   fDESCR_COMPL_AJ: string ; /// Descri��o complementar do ajuste do documento fiscal
   fCOD_ITEM: string; /// C�digo do item (campo 02 do Registro 0200).
   fVL_BC_ICMS: Currency; /// Base de c�lculo do ICMS ou do ICMS ST.
   fALIQ_ICMS: Currency; /// Al�quota do ICMS.
   fVL_ICMS: Currency; /// Valor do ICMS ou do ICMS.
   fVL_OUTROS: Currency; /// Outros valores.
  public
   property COD_AJ: string read fCOD_AJ write fCOD_AJ;
   property DESCR_COMPL_AJ: string read fDESCR_COMPL_AJ write fDESCR_COMPL_AJ;
   property COD_ITEM: string read fCOD_ITEM write fCOD_ITEM;
   property VL_BC_ICMS: Currency read fVL_BC_ICMS write fVL_BC_ICMS;
   property ALIQ_ICMS: Currency read fALIQ_ICMS write fALIQ_ICMS;
   property VL_ICMS: Currency read fVL_ICMS write fVL_ICMS;
   property VL_OUTROS: Currency read fVL_OUTROS write fVL_OUTROS;
  end;

   /// Registro C597 - Lista

  TRegistroC597List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC597; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC597); /// SetItem
  public
    function New: TRegistroC597;
    property Items[Index: Integer]: TRegistroC597 read GetItem write SetItem;
  end;

  /// Registro C600 - CONSOLIDA��O DI�RIA DE NOTAS FISCAIS/CONTAS DE ENERGIA EL�TRICA (C�DIGO 06), NOTA FISCAL/CONTA DE FORNECIMENTO D'�GUA CANALIZADA (C�DIGO 29) E NOTA FISCAL/CONTA DE FORNECIMENTO DE G�S (C�DIGO 28) (EMPRESAS N�O OBRIGADAS AO CONVENIO ICMS 115/03)

  TRegistroC600 = class
  private
    fCOD_MOD: String;      /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fCOD_MUN: String;      /// C�digo do munic�pio dos pontos de consumo, conforme a tabela IBGE
    fSER: String;          /// S�rie do documento fiscal
    fSUB: String;          /// Subs�rie do documento fiscal
    fCOD_CONS: String;     /// C�digo de classe de consumo de energia el�trica, conforme a Tabela 4.4.5, ou C�digo de Consumo de Fornecimento D��gua - Tabela 4.4.2 ou C�digo da classe de consumo de g�s canalizado   conforme Tabela 4.4.3.
    fQTD_CONS: Integer;    /// Quantidade de documentos consolidados neste registro
    fQTD_CANC: Integer;    /// Quantidade de documentos cancelados
    fDT_DOC: TDateTime;    /// Data dos documentos consolidados
    fVL_DOC: currency;     /// Valor total dos documentos
    fVL_DESC: currency;    /// Valor acumulado dos descontos
    fCONS: Integer ;       /// Consumo total acumulado, em kWh (C�digo 06)
    fVL_FORN: currency;    /// Valor acumulado do fornecimento
    fVL_SERV_NT: currency; /// Valor acumulado dos servi�os n�o-tributados pelo ICMS
    fVL_TERC: currency;    /// Valores cobrados em nome de terceiros
    fVL_DA: currency;      /// Valor acumulado das despesas acess�rias
    fVL_BC_ICMS: currency; /// Valor acumulado da base de c�lculo do ICMS
    fVL_ICMS: currency;    /// Valor acumulado do ICMS
    fVL_BC_ICMS_ST: currency;    /// Valor acumulado da base de c�lculo do ICMS substitui��o tribut�ria
    fVL_ICMS_ST: currency;       /// Valor acumulado do ICMS retido por substitui��o tribut�ria
    fVL_PIS: currency;           /// Valor acumulado do PIS
    fVL_COFINS: currency;        /// Valor acumulado COFINS

    FRegistroC601: TRegistroC601List;
    FRegistroC610: TRegistroC610List;
    FRegistroC690: TRegistroC690List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read fCOD_MOD write fCOD_MOD;
    property COD_MUN: String read fCOD_MUN write fCOD_MUN;
    property SER: String read fSER write fSER;
    property SUB: String read fSUB write fSUB;
    property COD_CONS: String read fCOD_CONS write fCOD_CONS;
    property QTD_CONS: Integer read fQTD_CONS write fQTD_CONS;
    property QTD_CANC: Integer read fQTD_CANC write fQTD_CANC;
    property DT_DOC: TDateTime read fDT_DOC write fDT_DOC;
    property VL_DOC: currency read fVL_DOC write fVL_DOC;
    property VL_DESC: currency read fVL_DESC write fVL_DESC;
    property CONS: Integer read fCONS write fCONS;
    property VL_FORN: currency read fVL_FORN write fVL_FORN;
    property VL_SERV_NT: currency read fVL_SERV_NT write fVL_SERV_NT;
    property VL_TERC: currency read fVL_TERC write fVL_TERC;
    property VL_DA: currency read fVL_DA write fVL_DA;
    property VL_BC_ICMS: currency read fVL_BC_ICMS write fVL_BC_ICMS;
    property VL_ICMS: currency read fVL_ICMS write fVL_ICMS;
    property VL_BC_ICMS_ST: currency read fVL_BC_ICMS_ST write fVL_BC_ICMS_ST;
    property VL_ICMS_ST: currency read fVL_ICMS_ST write fVL_ICMS_ST;
    property VL_PIS: currency read fVL_PIS write fVL_PIS;
    property VL_COFINS: currency read fVL_COFINS write fVL_COFINS;

    property RegistroC601: TRegistroC601List read FRegistroC601 write FRegistroC601;
    property RegistroC610: TRegistroC610List read FRegistroC610 write FRegistroC610;
    property RegistroC690: TRegistroC690List read FRegistroC690 write FRegistroC690;
  end;

  /// Registro C600 - Lista

  TRegistroC600List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC600; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC600); /// SetItem
  public
    function New: TRegistroC600;
    property Items[Index: Integer]: TRegistroC600 read GetItem write SetItem;
  end;

  /// Registro C601 - DOCUMENTOS CANCELADOS - CONSOLIDA��O DI�RIA DE NOTAS FISCAIS/CONTAS DE ENERGIA EL�TRICA (C�DIGO 06), NOTA FISCAL/CONTA DE FORNECIMENTO D'�GUA CANALIZADA (C�DIGO 29) E NOTA FISCAL/CONTA DE FORNECIMENTO DE G�S (C�DIGO 28)

  TRegistroC601 = class
  private
    fNUM_DOC_CANC: String;        /// N�mero do documento fiscal cancelado
  public
    property NUM_DOC_CANC: String read FNUM_DOC_CANC write FNUM_DOC_CANC;
  end;

  /// Registro C601 - Lista

  TRegistroC601List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC601; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC601); /// SetItem
  public
    function New: TRegistroC601;
    property Items[Index: Integer]: TRegistroC601 read GetItem write SetItem;
  end;

  /// Registro C610 - ITENS DO DOCUMENTO CONSOLIDADO NOTAS FISCAIS/CONTAS DE ENERGIA EL�TRICA (C�DIGO 06), NOTA FISCAL/CONTA DE FORNECIMENTO D'�GUA CANALIZADA (C�DIGO 29) E NOTA FISCAL/CONTA DE FORNECIMENTO DE G�S (C�DIGO 28) (EMPRESAS N�O OBRIGADAS AO CONVENIO ICMS 115/03)

  TRegistroC610 = class
  private
    fCOD_CLASS: String;       /// C�digo de classifica��o do item de energia el�trica, conforme Tabela 4.4.1
    fCOD_ITEM: String;        /// C�digo do item (campo 02 do Registro 0200)
    fQTD: Double;                 /// Quantidade acumulada do item
    fUNID: String;            /// Unidade do item (Campo 02 do registro 0190)
    fVL_ITEM: currency;           /// Valor acumulado do item
    fVL_DESC: currency;           /// Valor acumulado dos descontos
    fCST_ICMS: String;        /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1
    fCFOP: String;            /// C�digo Fiscal de Opera��o e Presta��o conforme tabela indicada no item 4.2.2
    fALIQ_ICMS: currency;         /// Al�quota do ICMS
    fVL_BC_ICMS: currency;        /// Valor acumulado da base de c�lculo do ICMS
    fVL_ICMS: currency;           /// Valor acumulado do ICMS debitado
    fVL_BC_ICMS_ST: currency;     /// Valor da base de c�lculo do ICMS substitui��o tribut�ria
    fVL_ICMS_ST: currency;        /// Valor do ICMS retido por substitui��o tribut�ria
    fVL_PIS: currency;            /// Valor do PIS
    fVL_COFINS: currency;         /// Valor da COFINS
    fCOD_CTA: String;         /// C�digo da conta anal�tica cont�bil debitada/creditada
  public
    property COD_CLASS: String read FCOD_CLASS write FCOD_CLASS;
    property COD_ITEM: String read FCOD_ITEM write FCOD_ITEM;
    property QTD: Double read FQTD write FQTD;
    property UNID: String read FUNID write FUNID;
    property VL_ITEM: currency read FVL_ITEM write FVL_ITEM;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_BC_ICMS_ST: currency read FVL_BC_ICMS_ST write FVL_BC_ICMS_ST;
    property VL_ICMS_ST: currency read FVL_ICMS_ST write FVL_ICMS_ST;
    property VL_PIS: currency read FVL_PIS write FVL_PIS;
    property VL_COFINS: currency read FVL_COFINS write FVL_COFINS;
    property COD_CTA: String read FCOD_CTA write FCOD_CTA;
  end;

  /// Registro C610 - Lista

  TRegistroC610List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC610; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC610); /// SetItem
  public
    function New: TRegistroC610;
    property Items[Index: Integer]: TRegistroC610 read GetItem write SetItem;
  end;

  /// Registro C690 - REGISTRO ANAL�TICO DOS DOCUMENTOS (Notas Fiscais/Contas de Energia El�trica (C�digo 06), Nota Fiscal/Conta de Fornecimento d��gua CANALIZADA (c�digo 29) e Nota Fiscal/Conta de Fornecimento de G�s (C�digo 28)

  TRegistroC690 = class
  private
    fCST_ICMS: String;            /// C�digo da Situa��o Tribut�ria, conforme a tabela indicada no item 4.3.1
    fCFOP: String;                /// C�digo Fiscal de Opera��o e Presta��o, conforme a tabela indicada no item 4.2.2
    fALIQ_ICMS: currency;         /// Al�quota do ICMS
    fVL_OPR: currency;            /// Valor da opera��o correspondente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS.
    fVL_BC_ICMS: currency;        /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" referente � combina��o CST_ICMS, CFOP e al�quota do ICMS
    fVL_ICMS: currency;           /// Parcela correspondente ao "Valor do ICMS" referente � combina��o CST_ICMS, CFOP e al�quota do ICMS
    fVL_RED_BC: currency;         /// Valor n�o tributado em fun��o da redu��o da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fVL_BC_ICMS_ST: currency;     /// Valor da base de c�lculo do ICMS substitui��o tribut�ria
    fVL_ICMS_ST: currency;        /// Valor do ICMS retido por substitui��o tribut�ria
    fCOD_OBS: String;             /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
  public
    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_RED_BC: currency read FVL_RED_BC write FVL_RED_BC;
    property VL_BC_ICMS_ST: currency read FVL_BC_ICMS_ST write FVL_BC_ICMS_ST;
    property VL_ICMS_ST: currency read FVL_ICMS_ST write FVL_ICMS_ST;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
  end;

  /// Registro C690 - Lista

  TRegistroC690List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC690; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC690); /// SetItem
  public
    function New: TRegistroC690;
    property Items[Index: Integer]: TRegistroC690 read GetItem write SetItem;
  end;

  /// Registro C700 - CONSOLIDA��O DOS DOCUMENTOS NF/CONTA ENERGIA EL�TRICA (C�DIGO 06), EMITIDAS EM VIA �NICA (EMPRESAS OBRIGADAS AO CONVENIO ICMS 115/03)

  TRegistroC700 = class
  private
    fCOD_MOD: String;      /// C�digo do modelo d documento fiscal, conforme a Tabela 4.1.1
    fSER: String;          /// S�rie do documento fiscal
    fNRO_ORD_INI: integer;     /// N�mero de ordem inicial
    fNRO_ORD_FIN: integer;     /// N�mero de ordem final
    fDT_DOC_INI: TDateTime;    /// Data de emiss�o inicial dos documentos
    fDT_DOC_FIN: TDateTime;    /// Data de emiss�o final dos documentos
    fNOM_MEST: String;     /// Nome do arquivo Mestre de Documento Fiscal
    fCHV_COD_DIG: String;  /// Chave de codifica��o digital do arquivo Mestre de Documento Fiscal
    FRegistroC790: TRegistroC790List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read fCOD_MOD write fCOD_MOD;
    property SER: String read fSER write fSER;
    property NRO_ORD_INI: integer read fNRO_ORD_INI write fNRO_ORD_INI;
    property NRO_ORD_FIN: integer read fNRO_ORD_FIN write fNRO_ORD_FIN;
    property DT_DOC_INI: TDateTime read fDT_DOC_INI write fDT_DOC_INI;
    property DT_DOC_FIN: TDateTime read fDT_DOC_FIN write fDT_DOC_FIN;
    property NOM_MEST: String read fNOM_MEST write fNOM_MEST;
    property CHV_COD_DIG: String read fCHV_COD_DIG write fCHV_COD_DIG;

    property RegistroC790: TRegistroC790List read FRegistroC790 write FRegistroC790;
  end;

  /// Registro C700 - Lista

  TRegistroC700List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC700; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC700); /// SetItem
  public
    function New: TRegistroC700;
    property Items[Index: Integer]: TRegistroC700 read GetItem write SetItem;
  end;

  /// Registro C790 - REGISTRO ANAL�TICO DOS DOCUMENTOS (COD 06)

  TRegistroC790 = class
  private
    fCST_ICMS: String;            /// C�digo da Situa��o Tribut�ria, conforme a tabela indicada no item 4.3.1
    fCFOP: String;                /// C�digo Fiscal de Opera��o e Presta��o, conforme a tabela indicada no item 4.2.2
    fALIQ_ICMS: currency;         /// Al�quota do ICMS
    fVL_OPR: currency;            /// Valor da opera��o correspondente � combina��o de CST_ICMS, CFOP, e al�quota do ICMS.
    fVL_BC_ICMS: currency;        /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" referente � combina��o CST_ICMS, CFOP, e al�quota do ICMS
    fVL_ICMS: currency;           /// Parcela correspondente ao "Valor do ICMS" referente � combina��o CST_ICMS, CFOP e al�quota do ICMS
    fVL_BC_ICMS_ST: currency;     /// Valor da base de c�lculo do ICMS substitui��o tribut�ria
    fVL_ICMS_ST: currency;        /// Valor do ICMS retido por substitui��o tribut�ria
    fVL_RED_BC: currency;         /// Valor n�o tributado em fun��o da redu��o da base de c�lculo do ICMS, referente � combina��o de CST_ICMS, CFOP e al�quota do ICMS.
    fCOD_OBS: String;
    FRegistroC791: TRegistroC791List;             /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_BC_ICMS_ST: currency read FVL_BC_ICMS_ST write FVL_BC_ICMS_ST;
    property VL_ICMS_ST: currency read FVL_ICMS_ST write FVL_ICMS_ST;
    property VL_RED_BC: currency read FVL_RED_BC write FVL_RED_BC;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;

    property RegistroC791: TRegistroC791List read FRegistroC791 write FRegistroC791;
  end;

  /// Registro C790 - Lista

  TRegistroC790List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC790; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC790); /// SetItem
  public
    function New: TRegistroC790;
    property Items[Index: Integer]: TRegistroC790 read GetItem write SetItem;
  end;

  /// Registro C791 - REGISTRO DE INFORMA��ES DE ICMS ST POR UF (COD 06)

  TRegistroC791 = class
  private
    fUF: String;                  /// Sigla da unidade da federa��o a que se refere a reten��o ST
    fVL_BC_ICMS_ST: currency;     /// Valor da base de c�lculo do ICMS substitui��o tribut�ria
    fVL_ICMS_ST: currency;        /// Valor do ICMS retido por substitui��o tribut�ria
  public
    property UF: String read FUF write FUF;
    property VL_BC_ICMS_ST: currency read FVL_BC_ICMS_ST write FVL_BC_ICMS_ST;
    property VL_ICMS_ST: currency read FVL_ICMS_ST write FVL_ICMS_ST;
  end;

  /// Registro C791 - Lista

  TRegistroC791List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC791; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC791); /// SetItem
  public
    function New: TRegistroC791;
    property Items[Index: Integer]: TRegistroC791 read GetItem write SetItem;
  end;

  { TRegistroC800 - CUPOM FISCAL ELETR�NICO (C�DIGO 59) (somente notas de sa�da) }

  TRegistroC800 = class
  private
    fCOD_MOD: String;                   /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fCOD_SIT: TACBrCodSit;              /// C�digo da situa��o do documento fiscal, conforme a Tabela 4.1.2
    fNUM_CFE: String;                   /// N�mero do Cupom Fiscal Eletr�nico
    fDT_DOC: TDateTime;                 /// Data da emiss�o do documento fiscal Eletr�nico
    fVL_CFE: currency;                  /// Valor total do Cupom Fiscal Eletr�nico
    fVL_PIS: Variant;                   /// Valor total do PIS
    fVL_COFINS: Variant;                /// Valor total da COFINS
    fCNPJ_CPF: String;                  /// CNPJ ou CPF do destinat�rio
    fNR_SAT: String;                    /// N�mero de S�rie do equipamento SAT
    fCHV_CFE: String;                   /// Chave do Cupom Fiscal Eletr�nico
    fVL_DESC: currency;                 /// Valor total do desconto sobre item
    fVL_MERC: currency;                 /// Valor das mercadorias e servi�o
    fVL_OUT_DA: currency;               /// Valor de outras desp. acess�rias (acr�scimo)
    fVL_ICMS: currency;                 /// Valor do ICMS
    fVL_PIS_ST: Variant;                /// Valor total do PIS retido por substitui��o tribut�ria
    fVL_COFINS_ST: Variant;             /// Valor total da COFINS retido por substitui��o tribut�ria

    FRegistroC810: TRegistroC810List;
    FRegistroC850: TRegistroC850List;   /// BLOCO C - Lista de RegistroC850 (FILHO)
    FRegistroC855: TRegistroC855List;
  public
    constructor Create; virtual;  /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property COD_SIT: TACBrCodSit read FCOD_SIT write FCOD_SIT;
    property NUM_CFE: String read FNUM_CFE write FNUM_CFE;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property VL_CFE: currency read FVL_CFE write FVL_CFE;
    property VL_PIS: Variant read FVL_PIS write FVL_PIS;
    property VL_COFINS: Variant read FVL_COFINS write FVL_COFINS;
    property CNPJ_CPF: String read FCNPJ_CPF write FCNPJ_CPF;
    property NR_SAT: String read FNR_SAT write FNR_SAT;
    property CHV_CFE: String read FCHV_CFE write FCHV_CFE;
    property VL_DESC: currency read FVL_DESC write FVL_DESC;
    property VL_MERC: currency read FVL_MERC write FVL_MERC;
    property VL_OUT_DA: currency read FVL_OUT_DA write FVL_OUT_DA;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property VL_PIS_ST: Variant read FVL_PIS_ST write FVL_PIS_ST;
    property VL_COFINS_ST: Variant read FVL_COFINS_ST write FVL_COFINS_ST;
    /// Registros FILHOS
    property RegistroC810: TRegistroC810List read FRegistroC810 write FRegistroC810;
    property RegistroC850: TRegistroC850List read FRegistroC850 write FRegistroC850;
    property RegistroC855: TRegistroC855List read FRegistroC855 write FRegistroC855;
  end;

  /// Registro C800 - Lista

  TRegistroC800List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC800; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC800); /// SetItem
  public
    function New: TRegistroC800;
    property Items[Index: Integer]: TRegistroC800 read GetItem write SetItem;
  end;

  /// REGISTRO C815: INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE SA�DA DE MERCADORIAS SUJEITAS � 
  /// SUBSTITUI��O TRIBUT�RIA (CF-E-SAT) (C�DIGO 59)
  
  TRegistroC815 = class
  private
    FCOD_MOT_REST_COMPL: string;
    FQUANT_CONV: Extended;
    FUNID: string;
    FVL_UNIT_CONV: Extended;
    FVL_UNIT_ICMS_NA_OPERACAO_CONV: Variant;
    FVL_UNIT_ICMS_OP_CONV: Variant;
    FVL_UNIT_ICMS_OP_ESTOQUE_CONV: Variant;
    FVL_UNIT_ICMS_ST_ESTOQUE_CONV: Variant;
    FVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: Variant;
    FVL_UNIT_ICMS_ST_CONV_REST: Variant;
    FVL_UNIT_FCP_ST_CONV_REST: Variant;
    FVL_UNIT_ICMS_ST_CONV_COMPL: Variant;
    FVL_UNIT_FCP_ST_CONV_COMPL: Variant;
  public
    property COD_MOT_REST_COMPL: string read FCOD_MOT_REST_COMPL write FCOD_MOT_REST_COMPL;
    property QUANT_CONV: Extended read FQUANT_CONV write FQUANT_CONV;
    property UNID: string read FUNID write FUNID;
    property VL_UNIT_CONV: Extended read FVL_UNIT_CONV write FVL_UNIT_CONV;
    property VL_UNIT_ICMS_NA_OPERACAO_CONV: Variant read FVL_UNIT_ICMS_NA_OPERACAO_CONV write FVL_UNIT_ICMS_NA_OPERACAO_CONV;
    property VL_UNIT_ICMS_OP_CONV: Variant read FVL_UNIT_ICMS_OP_CONV write FVL_UNIT_ICMS_OP_CONV;
    property VL_UNIT_ICMS_OP_ESTOQUE_CONV: Variant read FVL_UNIT_ICMS_OP_ESTOQUE_CONV write FVL_UNIT_ICMS_OP_ESTOQUE_CONV;
    property VL_UNIT_ICMS_ST_ESTOQUE_CONV: Variant read FVL_UNIT_ICMS_ST_ESTOQUE_CONV write FVL_UNIT_ICMS_ST_ESTOQUE_CONV;
    property VL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: Variant read FVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV write FVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV;
    property VL_UNIT_ICMS_ST_CONV_REST: Variant read FVL_UNIT_ICMS_ST_CONV_REST write FVL_UNIT_ICMS_ST_CONV_REST;
    property VL_UNIT_FCP_ST_CONV_REST: Variant read FVL_UNIT_FCP_ST_CONV_REST write FVL_UNIT_FCP_ST_CONV_REST;
    property VL_UNIT_ICMS_ST_CONV_COMPL: Variant read FVL_UNIT_ICMS_ST_CONV_COMPL write FVL_UNIT_ICMS_ST_CONV_COMPL;
    property VL_UNIT_FCP_ST_CONV_COMPL: Variant read FVL_UNIT_FCP_ST_CONV_COMPL write FVL_UNIT_FCP_ST_CONV_COMPL;
  end;

  /// REGISTRO C810: ITENS DO DOCUMENTO DO CUPOM FISCAL ELETR�NICO � SAT (CFE-SAT) (C�DIGO 59):

  TRegistroC810 = class
  private
    FNUM_ITEM: string;
    FCOD_ITEM: string;
    FQTD: Extended;
    FUNID: string;
    FVL_ITEM: Currency;
    FCST_ICMS: string;
    FCFOP: string;
    FRegistroC815: TRegistroC815;
  public
    constructor Create;
    destructor Destroy; override;

    property NUM_ITEM: string read FNUM_ITEM write FNUM_ITEM;
    property COD_ITEM: string read FCOD_ITEM write FCOD_ITEM;
    property QTD: Extended read FQTD write FQTD;
    property UNID: string read FUNID write FUNID;
    property VL_ITEM: Currency read FVL_ITEM write FVL_ITEM;
    property CST_ICMS: string read FCST_ICMS write FCST_ICMS;
    property CFOP: string read FCFOP write FCFOP;
    property RegistroC815: TRegistroC815 read FRegistroC815 write FRegistroC815;
  end;

  TRegistroC810List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC810;
    procedure SetItem(Index: Integer; const Value: TRegistroC810);
  public
    function New: TRegistroC810;
    property Items[Index: Integer]: TRegistroC810 read GetItem write SetItem;
  end;

  /// Registro C850 - REGISTRO ANAL�TICO DO CF-E (CODIGO 59)
  TRegistroC850 = class
  private
    fCST_ICMS: String;            /// C�digo da Situa��o Tribut�ria, conforme a tabela indicada no item 4.3.1
    fCFOP: String;                /// C�digo Fiscal de Opera��o e Presta��o do agrupamento de itens
    fALIQ_ICMS: currency;         /// Al�quota do ICMS
    fVL_OPR: currency;            /// �Valor total do CF-e� na combina��o de CST_ICMS, CFOP e al�quota do ICMS, correspondente ao somat�rio do valor l�quido dos itens.
    fVL_BC_ICMS: currency;        /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" referente � combina��o CST_ICMS, CFOP, e al�quota do ICMS
    fVL_ICMS: currency;           /// Parcela correspondente ao "Valor do ICMS" referente � combina��o CST_ICMS, CFOP e al�quota do ICMS
    fCOD_OBS: String;
  public

    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
  end;

  /// Registro C850 - Lista

  TRegistroC850List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC850; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC850); /// SetItem
  public
    function New: TRegistroC850;
    property Items[Index: Integer]: TRegistroC850 read GetItem write SetItem;
  end;

  { TRegistroC855 - OBSERVA��ES DO LAN�AMENTO FISCAL (C�DIGO 59) }

  TRegistroC855 = class
  private
    fCOD_OBS: String;    // C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
    fTXT_COMPL: String;  // Descri��o complementar do c�digo de observa��o.

    FRegistroC857: TRegistroC857List;
  public
    constructor Create;
    destructor Destroy; override;

    property COD_OBS: String read fCOD_OBS write fCOD_OBS;
    property TXT_COMPL: String read fTXT_COMPL write fTXT_COMPL;

    property RegistroC857: TRegistroC857List read FRegistroC857 write FRegistroC857;
  end;

  { TRegistroC855List }

  TRegistroC855List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC855;
    procedure SetItem(Index: Integer; const Value: TRegistroC855);
  public
    function New: TRegistroC855;
    property Items[Index: Integer]: TRegistroC855 read GetItem write SetItem;
  end;

  { TRegistroC857 - OUTRAS OBRIGA��ES TRIBUT�RIAS, AJUSTES E INFORMA��ES DE VALORES PROVENIENTES DE DOCUMENTO FISCAL }

  TRegistroC857 = class
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

  { TRegistroC857List }

  TRegistroC857List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC857;
    procedure SetItem(Index: Integer; const Value: TRegistroC857);
  public
    function New: TRegistroC857;
    property Items[Index: Integer]: TRegistroC857 read GetItem write SetItem;
  end;

  /// Registro C860 - IDENTIFICA��O DO EQUIPAMENTO SAT-CF-E

  TRegistroC860 = class
  private
    fCOD_MOD: String;                   /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.1
    fNR_SAT: String;                    /// N�mero de S�rie do equipamento SAT
    fDT_DOC: TDateTime;                 /// Data de emiss�o dos documentos fiscais
    fDOC_INI: String;                   /// N�mero do documento inicial
    fDOC_FIN: String;                   /// N�mero do documento final
    FRegistroC870: TRegistroC870List;
    FRegistroC890: TRegistroC890List;   /// BLOCO C - Lista de RegistroC890 (FILHO)
    FRegistroC895: TRegistroC895List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_MOD: String read FCOD_MOD write FCOD_MOD;
    property NR_SAT: String read FNR_SAT write FNR_SAT;
    property DT_DOC: TDateTime read FDT_DOC write FDT_DOC;
    property DOC_INI: String read fDOC_INI write fDOC_INI;
    property DOC_FIN: String read fDOC_FIN write fDOC_FIN;
    /// Registros FILHOS
    property RegistroC870: TRegistroC870List read FRegistroC870 write FRegistroC870;
    property RegistroC890: TRegistroC890List read FRegistroC890 write FRegistroC890;
    property RegistroC895: TRegistroC895List read FRegistroC895 write FRegistroC895;
  end;

  /// Registro C860 - Lista

  TRegistroC860List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC860;
    procedure SetItem(Index: Integer; const Value: TRegistroC860);
  public
    function New: TRegistroC860;
    property Items[Index: Integer]: TRegistroC860 read GetItem write SetItem;
  end;

  /// REGISTRO C880: INFORMA��ES COMPLEMENTARES DAS OPERA��ES DE SA�DA DE MERCADORIAS SUJEITAS � 
  ///SUBSTITUI��O TRIBUT�RIA (CF-E-SAT) (C�DIGO 59)

  TRegistroC880 = class
  private
    FCOD_MOT_REST_COMPL: string;
    FQUANT_CONV: Extended;
    FUNID: string;
    FVL_UNIT_CONV: Extended;
    FVL_UNIT_ICMS_NA_OPERACAO_CONV: Variant;
    FVL_UNIT_ICMS_OP_CONV: Variant;
    FVL_UNIT_ICMS_OP_ESTOQUE_CONV: Variant;
    FVL_UNIT_ICMS_ST_ESTOQUE_CONV: Variant;
    FVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: Variant;
    FVL_UNIT_ICMS_ST_CONV_REST: Variant;
    FVL_UNIT_FCP_ST_CONV_REST: Variant;
    FVL_UNIT_ICMS_ST_CONV_COMPL: Variant;
    FVL_UNIT_FCP_ST_CONV_COMPL: Variant;
  public
    property COD_MOT_REST_COMPL: string read FCOD_MOT_REST_COMPL write FCOD_MOT_REST_COMPL;
    property QUANT_CONV: Extended read FQUANT_CONV write FQUANT_CONV;
    property UNID: string read FUNID write FUNID;
    property VL_UNIT_CONV: Extended read FVL_UNIT_CONV write FVL_UNIT_CONV;
    property VL_UNIT_ICMS_NA_OPERACAO_CONV: Variant read FVL_UNIT_ICMS_NA_OPERACAO_CONV write FVL_UNIT_ICMS_NA_OPERACAO_CONV;
    property VL_UNIT_ICMS_OP_CONV: Variant read FVL_UNIT_ICMS_OP_CONV write FVL_UNIT_ICMS_OP_CONV;
    property VL_UNIT_ICMS_OP_ESTOQUE_CONV: Variant read FVL_UNIT_ICMS_OP_ESTOQUE_CONV write FVL_UNIT_ICMS_OP_ESTOQUE_CONV;
    property VL_UNIT_ICMS_ST_ESTOQUE_CONV: Variant read FVL_UNIT_ICMS_ST_ESTOQUE_CONV write FVL_UNIT_ICMS_ST_ESTOQUE_CONV;
    property VL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV: Variant read FVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV write FVL_UNIT_FCP_ICMS_ST_ESTOQUE_CONV;
    property VL_UNIT_ICMS_ST_CONV_REST: Variant read FVL_UNIT_ICMS_ST_CONV_REST write FVL_UNIT_ICMS_ST_CONV_REST;
    property VL_UNIT_FCP_ST_CONV_REST: Variant read FVL_UNIT_FCP_ST_CONV_REST write FVL_UNIT_FCP_ST_CONV_REST;
    property VL_UNIT_ICMS_ST_CONV_COMPL: Variant read FVL_UNIT_ICMS_ST_CONV_COMPL write FVL_UNIT_ICMS_ST_CONV_COMPL;
    property VL_UNIT_FCP_ST_CONV_COMPL: Variant read FVL_UNIT_FCP_ST_CONV_COMPL write FVL_UNIT_FCP_ST_CONV_COMPL;
  end;

  /// REGISTRO C870: ITENS DO RESUMO DI�RIO DOS DOCUMENTOS (CF-E-SAT) (C�DIGO 59)
  
  TRegistroC870 = class
  private
    FCOD_ITEM: string;
    FQTD: Extended;
    FUNID: string;
    FCST_ICMS: string;
    FCFOP: string;
    FRegistroC880: TRegistroC880;
  public
    constructor Create;
    destructor Destroy; override;

    property COD_ITEM: string read FCOD_ITEM write FCOD_ITEM;
    property QTD: Extended read FQTD write FQTD;
    property UNID: string read FUNID write FUNID;
    property CST_ICMS: string read FCST_ICMS write FCST_ICMS;
    property CFOP: string read FCFOP write FCFOP;
    property RegistroC880: TRegistroC880 read FRegistroC880 write FRegistroC880;
  end;

  TRegistroC870List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC870;
    procedure SetItem(Index: Integer; const Value: TRegistroC870);
  public
    function New: TRegistroC870;
    property Items[Index: Integer]: TRegistroC870 read GetItem write SetItem;
  end;

  /// Registro C890 - RESUMO DI�RIO DO CF-E (C�DIGO 59) POR EQUIPAMENTO SAT-CF-E

  TRegistroC890 = class
  private
    fCST_ICMS: String;            /// C�digo da Situa��o Tribut�ria, conforme a tabela indicada no item 4.3.1
    fCFOP: String;                /// C�digo Fiscal de Opera��o e Presta��o do agrupamento de itens
    fALIQ_ICMS: currency;         /// Al�quota do ICMS
    fVL_OPR: currency;            /// �Valor total do CF-e� na combina��o de CST_ICMS, CFOP e al�quota do ICMS, correspondente ao somat�rio do valor l�quido dos itens.
    fVL_BC_ICMS: currency;        /// Parcela correspondente ao "Valor da base de c�lculo do ICMS" referente � combina��o CST_ICMS, CFOP, e al�quota do ICMS
    fVL_ICMS: currency;           /// Parcela correspondente ao "Valor do ICMS" referente � combina��o CST_ICMS, CFOP e al�quota do ICMS
    fCOD_OBS: String;             /// C�digo da observa��o do lan�amento fiscal (campo 02 do registro 0460)
  public

    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property CFOP: String read FCFOP write FCFOP;
    property ALIQ_ICMS: currency read FALIQ_ICMS write FALIQ_ICMS;
    property VL_OPR: currency read FVL_OPR write FVL_OPR;
    property VL_BC_ICMS: currency read FVL_BC_ICMS write FVL_BC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
    property COD_OBS: String read FCOD_OBS write FCOD_OBS;
  end;

  /// Registro C890 - Lista

  TRegistroC890List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC890; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroC890); /// SetItem
  public
    function New: TRegistroC890;
    property Items[Index: Integer]: TRegistroC890 read GetItem write SetItem;
  end;

  { TRegistroC895 - OBSERVA��ES DO LAN�AMENTO FISCAL (C�DIGO 59) }

  TRegistroC895 = class
  private
    fCOD_OBS: String;    // C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
    fTXT_COMPL: String;  // Descri��o complementar do c�digo de observa��o.

    FRegistroC897: TRegistroC897List;
  public
    constructor Create;
    destructor Destroy; override;

    property COD_OBS: String read fCOD_OBS write fCOD_OBS;
    property TXT_COMPL: String read fTXT_COMPL write fTXT_COMPL;

    property RegistroC897: TRegistroC897List read FRegistroC897 write FRegistroC897;
  end;

  { TRegistroC895List }

  TRegistroC895List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC895;
    procedure SetItem(Index: Integer; const Value: TRegistroC895);
  public
    function New: TRegistroC895;
    property Items[Index: Integer]: TRegistroC895 read GetItem write SetItem;
  end;

  { TRegistroC897 - OUTRAS OBRIGA��ES TRIBUT�RIAS, AJUSTES E INFORMA��ES DE VALORES PROVENIENTES DE DOCUMENTO FISCAL }

  TRegistroC897 = class
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

  { TRegistroC897List }

  TRegistroC897List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroC897;
    procedure SetItem(Index: Integer; const Value: TRegistroC897);
  public
    function New: TRegistroC897;
    property Items[Index: Integer]: TRegistroC897 read GetItem write SetItem;
  end;

  /// Registro C990 - ENCERRAMENTO DO BLOCO C

  TRegistroC990 = class
  private
    fQTD_LIN_C: Integer; /// Quantidade total de linhas do Bloco C
  public
    property QTD_LIN_C: Integer read fQTD_LIN_C write fQTD_LIN_C;
  end;

implementation

{ TRegistroC100List }

function TRegistroC100List.GetItem(Index: Integer): TRegistroC100;
begin
  Result := TRegistroC100(Inherited Items[Index]);
end;

function TRegistroC100List.New(): TRegistroC100;
begin
  Result := TRegistroC100.Create();
  Add(Result);
end;

procedure TRegistroC100List.SetItem(Index: Integer; const Value: TRegistroC100);
begin
  Put(Index, Value);
end;

{ TRegistroC101List -- EC 87/2015}

function TRegistroC101List.GetItem(Index: Integer): TRegistroC101;
begin
  Result := TRegistroC101(Inherited Items[Index]);
end;

function TRegistroC101List.New: TRegistroC101;
begin
  Result := TRegistroC101.Create;
  Add(Result);
end;

procedure TRegistroC101List.SetItem(Index: Integer; const Value: TRegistroC101);
begin
  Put(Index, Value);
end;
{ FIM --- TRegistroC101List -- EC 87/2015}

{ TRegistroC105List }

function TRegistroC105List.GetItem(Index: Integer): TRegistroC105;
begin
  Result := TRegistroC105(Inherited Items[Index]);
end;

function TRegistroC105List.New(AOwner: TRegistroC100): TRegistroC105;
begin
  Result := TRegistroC105.Create(AOwner);
  Add(Result);
end;

procedure TRegistroC105List.SetItem(Index: Integer; const Value: TRegistroC105);
begin
  Put(Index, Value);
end;

{ TRegistroC110List }

function TRegistroC110List.GetItem(Index: Integer): TRegistroC110;
begin
  Result := TRegistroC110(Inherited Items[Index]);
end;

function TRegistroC110List.New(): TRegistroC110;
begin
  Result := TRegistroC110.Create();
  Add(Result);
end;

procedure TRegistroC110List.SetItem(Index: Integer; const Value: TRegistroC110);
begin
  Put(Index, Value);
end;

{ TRegistroC111List }

function TRegistroC111List.GetItem(Index: Integer): TRegistroC111;
begin
  Result := TRegistroC111(Inherited Items[Index]);
end;

function TRegistroC111List.New: TRegistroC111;
begin
  Result := TRegistroC111.Create;
  Add(Result);
end;

procedure TRegistroC111List.SetItem(Index: Integer; const Value: TRegistroC111);
begin
  Put(Index, Value);
end;

{ TRegistroC112List }

function TRegistroC112List.GetItem(Index: Integer): TRegistroC112;
begin
  Result := TRegistroC112(Inherited Items[Index]);
end;

function TRegistroC112List.New: TRegistroC112;
begin
  Result := TRegistroC112.Create;
  Add(Result);
end;

procedure TRegistroC112List.SetItem(Index: Integer; const Value: TRegistroC112);
begin
  Put(Index, Value);
end;

{ TRegistroC113List }

function TRegistroC113List.GetItem(Index: Integer): TRegistroC113;
begin
  Result := TRegistroC113(Inherited Items[Index]);
end;

function TRegistroC113List.New: TRegistroC113;
begin
  Result := TRegistroC113.Create;
  Add(Result);
end;

procedure TRegistroC113List.SetItem(Index: Integer; const Value: TRegistroC113);
begin
  Put(Index, Value);
end;

{ TRegistroC114List }

function TRegistroC114List.GetItem(Index: Integer): TRegistroC114;
begin
  Result := TRegistroC114(Inherited Items[Index]);
end;

function TRegistroC114List.New: TRegistroC114;
begin
  Result := TRegistroC114.Create;
  Add(Result);
end;

procedure TRegistroC114List.SetItem(Index: Integer; const Value: TRegistroC114);
begin
  Put(Index, Value);
end;

{ TRegistroC115List }

function TRegistroC115List.GetItem(Index: Integer): TRegistroC115;
begin
  Result := TRegistroC115(Inherited Items[Index]);
end;

function TRegistroC115List.New: TRegistroC115;
begin
  Result := TRegistroC115.Create;
  Add(Result);
end;

procedure TRegistroC115List.SetItem(Index: Integer; const Value: TRegistroC115);
begin
  Put(Index, Value);
end;

{ TRegistroC116List } {Altera��o Vers�o 2.0.4 03Mar2011}

function TRegistroC116List.GetItem(Index: Integer): TRegistroC116;
begin
  Result := TRegistroC116(Inherited Items[Index]);
end;

function TRegistroC116List.New: TRegistroC116;
begin
  Result := TRegistroC116.Create;
  Add(Result);
end;

procedure TRegistroC116List.SetItem(Index: Integer; const Value: TRegistroC116);
begin
  Put(Index, Value);
end;

{ TRegistroC120List }

function TRegistroC120List.GetItem(Index: Integer): TRegistroC120;
begin
  Result := TRegistroC120(Inherited Items[Index]);
end;

function TRegistroC120List.New: TRegistroC120;
begin
  Result := TRegistroC120.Create;
  Add(Result);
end;

procedure TRegistroC120List.SetItem(Index: Integer; const Value: TRegistroC120);
begin
  Put(Index, Value);
end;

{ TRegistroC130List }

function TRegistroC130List.GetItem(Index: Integer): TRegistroC130;
begin
  Result := TRegistroC130(Inherited Items[Index]);
end;

function TRegistroC130List.New: TRegistroC130;
begin
  Result := TRegistroC130.Create;
  Add(Result);
end;

procedure TRegistroC130List.SetItem(Index: Integer; const Value: TRegistroC130);
begin
  Put(Index, Value);
end;

{ TRegistroC140List }

function TRegistroC140List.GetItem(Index: Integer): TRegistroC140;
begin
  Result := TRegistroC140(Inherited Items[Index]);
end;

function TRegistroC140List.New: TRegistroC140;
begin
  Result := TRegistroC140.Create;
  Add(Result);
end;

procedure TRegistroC140List.SetItem(Index: Integer; const Value: TRegistroC140);
begin
  Put(Index, Value);
end;

{ TRegistroC141List }

function TRegistroC141List.GetItem(Index: Integer): TRegistroC141;
begin
  Result := TRegistroC141(Inherited Items[Index]);
end;

function TRegistroC141List.New: TRegistroC141;
begin
  Result := TRegistroC141.Create;
  Add(Result);
end;

procedure TRegistroC141List.SetItem(Index: Integer; const Value: TRegistroC141);
begin
  Put(Index, Value);
end;

{ TRegistroC160List }

function TRegistroC160List.GetItem(Index: Integer): TRegistroC160;
begin
  Result := TRegistroC160(Inherited Items[Index]);
end;

function TRegistroC160List.New: TRegistroC160;
begin
  Result := TRegistroC160.Create;
  Add(Result);
end;

procedure TRegistroC160List.SetItem(Index: Integer; const Value: TRegistroC160);
begin
  Put(Index, Value);
end;

{ TRegistroC165List }

function TRegistroC165List.GetItem(Index: Integer): TRegistroC165;
begin
  Result := TRegistroC165(Inherited Items[Index]);
end;

function TRegistroC165List.New: TRegistroC165;
begin
  Result := TRegistroC165.Create;
  Add(Result);
end;

procedure TRegistroC165List.SetItem(Index: Integer; const Value: TRegistroC165);
begin
  Put(Index, Value);
end;

{ TRegistroC170List }

function TRegistroC170List.GetItem(Index: Integer): TRegistroC170;
begin
  Result := TRegistroC170(Inherited Items[Index]);
end;

function TRegistroC170List.New: TRegistroC170;
begin
  Result := TRegistroC170.Create;
  Add(Result);
end;

procedure TRegistroC170List.SetItem(Index: Integer; const Value: TRegistroC170);
begin
  Put(Index, Value);
end;

{ TRegistroC171List }

function TRegistroC171List.GetItem(Index: Integer): TRegistroC171;
begin
  Result := TRegistroC171(Inherited Items[Index]);
end;

function TRegistroC171List.New: TRegistroC171;
begin
  Result := TRegistroC171.Create;
  Add(Result);
end;

procedure TRegistroC171List.SetItem(Index: Integer; const Value: TRegistroC171);
begin
  Put(Index, Value);
end;

{ TRegistroC172List }

function TRegistroC172List.GetItem(Index: Integer): TRegistroC172;
begin
  Result := TRegistroC172(Inherited Items[Index]);
end;

function TRegistroC172List.New: TRegistroC172;
begin
  Result := TRegistroC172.Create;
  Add(Result);
end;

procedure TRegistroC172List.SetItem(Index: Integer; const Value: TRegistroC172);
begin
  Put(Index, Value);
end;

{ TRegistroC173List }

function TRegistroC173List.GetItem(Index: Integer): TRegistroC173;
begin
  Result := TRegistroC173(Inherited Items[Index]);
end;

function TRegistroC173List.New: TRegistroC173;
begin
  Result := TRegistroC173.Create;
  Add(Result);
end;

procedure TRegistroC173List.SetItem(Index: Integer; const Value: TRegistroC173);
begin
  Put(Index, Value);
end;

{ TRegistroC174List }

function TRegistroC174List.GetItem(Index: Integer): TRegistroC174;
begin
  Result := TRegistroC174(Inherited Items[Index]);
end;

function TRegistroC174List.New: TRegistroC174;
begin
  Result := TRegistroC174.Create;
  Add(Result);
end;

procedure TRegistroC174List.SetItem(Index: Integer; const Value: TRegistroC174);
begin
  Put(Index, Value);
end;

{ TRegistroC175List }

function TRegistroC175List.GetItem(Index: Integer): TRegistroC175;
begin
  Result := TRegistroC175(Inherited Items[Index]);
end;

function TRegistroC175List.New: TRegistroC175;
begin
  Result := TRegistroC175.Create;
  Add(Result);
end;

procedure TRegistroC175List.SetItem(Index: Integer; const Value: TRegistroC175);
begin
  Put(Index, Value);
end;

{ TRegistroC176List }

function TRegistroC176List.GetItem(Index: Integer): TRegistroC176;
begin
  Result := TRegistroC176(Inherited Items[Index]);
end;

function TRegistroC176List.New: TRegistroC176;
begin
  Result := TRegistroC176.Create;
  Add(Result);
end;

procedure TRegistroC176List.SetItem(Index: Integer; const Value: TRegistroC176);
begin
  Put(Index, Value);
end;

{ TRegistroC177List }

function TRegistroC177List.GetItem(Index: Integer): TRegistroC177;
begin
  Result := TRegistroC177(Inherited Items[Index]);
end;

function TRegistroC177List.New: TRegistroC177;
begin
  Result := TRegistroC177.Create;
  Add(Result);
end;

procedure TRegistroC177List.SetItem(Index: Integer; const Value: TRegistroC177);
begin
  Put(Index, Value);
end;

{ TRegistroC178List }

function TRegistroC178List.GetItem(Index: Integer): TRegistroC178;
begin
  Result := TRegistroC178(Inherited Items[Index]);
end;

function TRegistroC178List.New: TRegistroC178;
begin
  Result := TRegistroC178.Create;
  Add(Result);
end;

procedure TRegistroC178List.SetItem(Index: Integer; const Value: TRegistroC178);
begin
  Put(Index, Value);
end;

{ TRegistroC179List }

function TRegistroC179List.GetItem(Index: Integer): TRegistroC179;
begin
  Result := TRegistroC179(Inherited Items[Index]);
end;

function TRegistroC179List.New: TRegistroC179;
begin
  Result := TRegistroC179.Create;
  Add(Result);
end;

procedure TRegistroC179List.SetItem(Index: Integer; const Value: TRegistroC179);
begin
  Put(Index, Value);
end;

{ TRegistroC190List }

function TRegistroC190List.GetItem(Index: Integer): TRegistroC190;
begin
  Result := TRegistroC190(Inherited Items[Index]);
end;

function TRegistroC190List.New: TRegistroC190;
begin
  Result := TRegistroC190.Create;
  Add(Result);
end;

procedure TRegistroC190List.SetItem(Index: Integer; const Value: TRegistroC190);
begin
  Put(Index, Value);
end;

{ TRegistroC191List }

function TRegistroC191List.GetItem(Index: Integer): TRegistroC191;
begin
  Result := TRegistroC191(Inherited Items[Index]);
end;

function TRegistroC191List.New: TRegistroC191;
begin
  Result := TRegistroC191.Create;
  Add(Result);
end;

procedure TRegistroC191List.SetItem(Index: Integer; const Value: TRegistroC191);
begin
  Put(Index, Value);
end;

{ TRegistroC195List }

function TRegistroC195List.GetItem(Index: Integer): TRegistroC195;
begin
  Result := TRegistroC195(Inherited Items[Index]);
end;

function TRegistroC195List.New: TRegistroC195;
begin
  Result := TRegistroC195.Create;
  Add(Result);
end;

procedure TRegistroC195List.SetItem(Index: Integer; const Value: TRegistroC195);
begin
  Put(Index, Value);
end;

{ TRegistroC197List }

function TRegistroC197List.GetItem(Index: Integer): TRegistroC197;
begin
  Result := TRegistroC197(Inherited Items[Index]);
end;

function TRegistroC197List.New: TRegistroC197;
begin
  Result := TRegistroC197.Create;
  Add(Result);
end;

procedure TRegistroC197List.SetItem(Index: Integer; const Value: TRegistroC197);
begin
  Put(Index, Value);
end;

{ TRegistroC300List }

function TRegistroC300List.GetItem(Index: Integer): TRegistroC300;
begin
  Result := TRegistroC300(Inherited Items[Index]);
end;

function TRegistroC300List.New: TRegistroC300;
begin
  Result := TRegistroC300.Create;
  Add(Result);
end;

procedure TRegistroC300List.SetItem(Index: Integer; const Value: TRegistroC300);
begin
  Put(Index, Value);
end;

{ TRegistroC310List }

function TRegistroC310List.GetItem(Index: Integer): TRegistroC310;
begin
  Result := TRegistroC310(Inherited Items[Index]);
end;

function TRegistroC310List.New: TRegistroC310;
begin
  Result := TRegistroC310.Create;
  Add(Result);
end;

procedure TRegistroC310List.SetItem(Index: Integer; const Value: TRegistroC310);
begin
  Put(Index, Value);
end;

{ TRegistroC320List }

function TRegistroC320List.GetItem(Index: Integer): TRegistroC320;
begin
  Result := TRegistroC320(Inherited Items[Index]);
end;

function TRegistroC320List.New: TRegistroC320;
begin
  Result := TRegistroC320.Create;
  Add(Result);
end;

procedure TRegistroC320List.SetItem(Index: Integer; const Value: TRegistroC320);
begin
  Put(Index, Value);
end;

{ TRegistroC321List }

function TRegistroC321List.GetItem(Index: Integer): TRegistroC321;
begin
  Result := TRegistroC321(Inherited Items[Index]);
end;

function TRegistroC321List.New: TRegistroC321;
begin
  Result := TRegistroC321.Create;
  Add(Result);
end;

procedure TRegistroC321List.SetItem(Index: Integer; const Value: TRegistroC321);
begin
  Put(Index, Value);
end;

{ TRegistroC350List }

function TRegistroC350List.GetItem(Index: Integer): TRegistroC350;
begin
  Result := TRegistroC350(Inherited Items[Index]);
end;

function TRegistroC350List.New: TRegistroC350;
begin
  Result := TRegistroC350.Create;
  Add(Result);
end;

procedure TRegistroC350List.SetItem(Index: Integer; const Value: TRegistroC350);
begin
  Put(Index, Value);
end;

{ TRegistroC370List }

function TRegistroC370List.GetItem(Index: Integer): TRegistroC370;
begin
  Result := TRegistroC370(Inherited Items[Index]);
end;

function TRegistroC370List.New: TRegistroC370;
begin
  Result := TRegistroC370.Create;
  Add(Result);
end;

procedure TRegistroC370List.SetItem(Index: Integer; const Value: TRegistroC370);
begin
  Put(Index, Value);
end;

{ TRegistroC390List }

function TRegistroC390List.GetItem(Index: Integer): TRegistroC390;
begin
  Result := TRegistroC390(Inherited Items[Index]);
end;

function TRegistroC390List.New: TRegistroC390;
begin
  Result := TRegistroC390.Create;
  Add(Result);
end;

procedure TRegistroC390List.SetItem(Index: Integer; const Value: TRegistroC390);
begin
  Put(Index, Value);
end;

{ TRegistroC400List }

function TRegistroC400List.GetItem(Index: Integer): TRegistroC400;
begin
  Result := TRegistroC400(Inherited Items[Index]);
end;

function TRegistroC400List.New: TRegistroC400;
begin
  Result := TRegistroC400.Create;
  Add(Result);
end;

procedure TRegistroC400List.SetItem(Index: Integer; const Value: TRegistroC400);
begin
  Put(Index, Value);
end;

function TRegistroC400List.LocalizaRegistro(const pECF_FAB: string): boolean;
{:N�mero de s�rie de fabrica��o do ECF :AJ-31/8/2011 13:57:12:}
var
  intFor: integer;
begin
  Result := false;
  for intFor := 0 to Self.Count - 1 do
  begin
    if Self.Items[intFor].ECF_FAB = pECF_FAB then
    begin
      Result := true;
      Break;
    end;
  end;
end;

{ TRegistroC405List }

function TRegistroC405List.GetItem(Index: Integer): TRegistroC405;
begin
  Result := TRegistroC405(Inherited Items[Index]);
end;

function TRegistroC405List.New: TRegistroC405;
begin
  Result := TRegistroC405.Create;
  Add(Result);
end;

procedure TRegistroC405List.SetItem(Index: Integer; const Value: TRegistroC405);
begin
  Put(Index, Value);
end;

{ TRegistroC410List }

function TRegistroC410List.GetItem(Index: Integer): TRegistroC410;
begin
  Result := TRegistroC410(Inherited Items[Index]);
end;

function TRegistroC410List.New: TRegistroC410;
begin
  Result := TRegistroC410.Create;
  Add(Result);
end;

procedure TRegistroC410List.SetItem(Index: Integer; const Value: TRegistroC410);
begin
  Put(Index, Value);
end;

{ TRegistroC420List }

function TRegistroC420List.GetItem(Index: Integer): TRegistroC420;
begin
  Result := TRegistroC420(Inherited Items[Index]);
end;

function TRegistroC420List.New: TRegistroC420;
begin
  Result := TRegistroC420.Create;
  Add(Result);
end;

procedure TRegistroC420List.SetItem(Index: Integer; const Value: TRegistroC420);
begin
  Put(Index, Value);
end;

{ TRegistroC425List }

function TRegistroC425List.GetItem(Index: Integer): TRegistroC425;
begin
  Result := TRegistroC425(Inherited Items[Index]);
end;

function TRegistroC425List.New: TRegistroC425;
begin
  Result := TRegistroC425.Create;
  Add(Result);
end;

procedure TRegistroC425List.SetItem(Index: Integer; const Value: TRegistroC425);
begin
  Put(Index, Value);
end;

{ TRegistroC460List }

function TRegistroC460List.GetItem(Index: Integer): TRegistroC460;
begin
  Result := TRegistroC460(Inherited Items[Index]);
end;

function TRegistroC460List.New: TRegistroC460;
begin
  Result := TRegistroC460.Create;
  Add(Result);
end;

procedure TRegistroC460List.SetItem(Index: Integer; const Value: TRegistroC460);
begin
  Put(Index, Value);
end;

{ TRegistroC465List }

function TRegistroC465List.GetItem(Index: Integer): TRegistroC465;
begin
  Result := TRegistroC465(Inherited Items[Index]);
end;

function TRegistroC465List.New: TRegistroC465;
begin
  Result := TRegistroC465.Create;
  Add(Result);
end;

procedure TRegistroC465List.SetItem(Index: Integer; const Value: TRegistroC465);
begin
  Put(Index, Value);
end;

{ TRegistroC470List }

function TRegistroC470List.GetItem(Index: Integer): TRegistroC470;
begin
  Result := TRegistroC470(Inherited Items[Index]);
end;

function TRegistroC470List.New: TRegistroC470;
begin
  Result := TRegistroC470.Create;
  Add(Result);
end;

procedure TRegistroC470List.SetItem(Index: Integer; const Value: TRegistroC470);
begin
  Put(Index, Value);
end;

{ TRegistroC490List }

function TRegistroC490List.GetItem(Index: Integer): TRegistroC490;
begin
  Result := TRegistroC490(Inherited Items[Index]);
end;

function TRegistroC490List.New: TRegistroC490;
begin
  Result := TRegistroC490.Create;
  Add(Result);
end;

procedure TRegistroC490List.SetItem(Index: Integer; const Value: TRegistroC490);
begin
  Put(Index, Value);
end;

{ TRegistroC495List }

function TRegistroC495List.GetItem(Index: Integer): TRegistroC495;
begin
  Result := TRegistroC495(Inherited Items[Index]);
end;

function TRegistroC495List.New: TRegistroC495;
begin
  Result := TRegistroC495.Create;
  Add(Result);
end;

procedure TRegistroC495List.SetItem(Index: Integer; const Value: TRegistroC495);
begin
  Put(Index, Value);
end;

{ TRegistroC500List }

function TRegistroC500List.GetItem(Index: Integer): TRegistroC500;
begin
  Result := TRegistroC500(Inherited Items[Index]);
end;

function TRegistroC500List.New: TRegistroC500;
begin
  Result := TRegistroC500.Create;
  Add(Result);
end;

procedure TRegistroC500List.SetItem(Index: Integer; const Value: TRegistroC500);
begin
  Put(Index, Value);
end;

{ TRegistroC510List }

function TRegistroC510List.GetItem(Index: Integer): TRegistroC510;
begin
  Result := TRegistroC510(Inherited Items[Index]);
end;

function TRegistroC510List.New: TRegistroC510;
begin
  Result := TRegistroC510.Create;
  Add(Result);
end;

procedure TRegistroC510List.SetItem(Index: Integer; const Value: TRegistroC510);
begin
  Put(Index, Value);
end;

{ TRegistroC590List }

function TRegistroC590List.GetItem(Index: Integer): TRegistroC590;
begin
  Result := TRegistroC590(Inherited Items[Index]);
end;

function TRegistroC590List.New: TRegistroC590;
begin
  Result := TRegistroC590.Create;
  Add(Result);
end;

procedure TRegistroC590List.SetItem(Index: Integer; const Value: TRegistroC590);
begin
  Put(Index, Value);
end;

{ TRegistroC600List }

function TRegistroC600List.GetItem(Index: Integer): TRegistroC600;
begin
  Result := TRegistroC600(Inherited Items[Index]);
end;

function TRegistroC600List.New: TRegistroC600;
begin
  Result := TRegistroC600.Create;
  Add(Result);
end;

procedure TRegistroC600List.SetItem(Index: Integer; const Value: TRegistroC600);
begin
  Put(Index, Value);
end;

{ TRegistroC601List }

function TRegistroC601List.GetItem(Index: Integer): TRegistroC601;
begin
  Result := TRegistroC601(Inherited Items[Index]);
end;

function TRegistroC601List.New: TRegistroC601;
begin
  Result := TRegistroC601.Create;
  Add(Result);
end;

procedure TRegistroC601List.SetItem(Index: Integer; const Value: TRegistroC601);
begin
  Put(Index, Value);
end;

{ TRegistroC610List }

function TRegistroC610List.GetItem(Index: Integer): TRegistroC610;
begin
  Result := TRegistroC610(Inherited Items[Index]);
end;

function TRegistroC610List.New: TRegistroC610;
begin
  Result := TRegistroC610.Create;
  Add(Result);
end;

procedure TRegistroC610List.SetItem(Index: Integer; const Value: TRegistroC610);
begin
  Put(Index, Value);
end;

{ TRegistroC690List }

function TRegistroC690List.GetItem(Index: Integer): TRegistroC690;
begin
  Result := TRegistroC690(Inherited Items[Index]);
end;

function TRegistroC690List.New: TRegistroC690;
begin
  Result := TRegistroC690.Create;
  Add(Result);
end;

procedure TRegistroC690List.SetItem(Index: Integer; const Value: TRegistroC690);
begin
  Put(Index, Value);
end;

{ TRegistroC700List }

function TRegistroC700List.GetItem(Index: Integer): TRegistroC700;
begin
  Result := TRegistroC700(Inherited Items[Index]);
end;

function TRegistroC700List.New: TRegistroC700;
begin
  Result := TRegistroC700.Create;
  Add(Result);
end;

procedure TRegistroC700List.SetItem(Index: Integer; const Value: TRegistroC700);
begin
  Put(Index, Value);
end;

{ TRegistroC790List }

function TRegistroC790List.GetItem(Index: Integer): TRegistroC790;
begin
  Result := TRegistroC790(Inherited Items[Index]);
end;

function TRegistroC790List.New: TRegistroC790;
begin
  Result := TRegistroC790.Create;
  Add(Result);
end;

procedure TRegistroC790List.SetItem(Index: Integer; const Value: TRegistroC790);
begin
  Put(Index, Value);
end;

{ TRegistroC791List }

function TRegistroC791List.GetItem(Index: Integer): TRegistroC791;
begin
  Result := TRegistroC791(Inherited Items[Index]);
end;

function TRegistroC791List.New: TRegistroC791;
begin
  Result := TRegistroC791.Create;
  Add(Result);
end;

procedure TRegistroC791List.SetItem(Index: Integer; const Value: TRegistroC791);
begin
  Put(Index, Value);
end;

{ TRegistroC800List }

function TRegistroC800List.GetItem(Index: Integer): TRegistroC800;
begin
  Result := TRegistroC800(Inherited Items[Index]);
end;

function TRegistroC800List.New: TRegistroC800;
begin
  Result := TRegistroC800.Create;
  Add(Result);
end;

procedure TRegistroC800List.SetItem(Index: Integer; const Value: TRegistroC800);
begin
  Put(Index, Value);
end;

{ TRegistroC850List }

function TRegistroC850List.GetItem(Index: Integer): TRegistroC850;
begin
  Result := TRegistroC850(Inherited Items[Index]);
end;

function TRegistroC850List.New: TRegistroC850;
begin
  Result := TRegistroC850.Create;
  Add(Result);
end;

procedure TRegistroC850List.SetItem(Index: Integer; const Value: TRegistroC850);
begin
  Put(Index, Value);
end;

{ TRegistroC855 }

constructor TRegistroC855.Create;
begin
  FRegistroC857 := TRegistroC857List.Create;
end;

destructor TRegistroC855.Destroy;
begin
  FRegistroC857.Free;
  inherited Destroy;
end;

{ TRegistroC855List }

function TRegistroC855List.GetItem(Index: Integer): TRegistroC855;
begin
  Result := TRegistroC855(inherited Items[Index]);
end;

procedure TRegistroC855List.SetItem(Index: Integer; const Value: TRegistroC855);
begin
  Put(Index, Value);
end;

function TRegistroC855List.New: TRegistroC855;
begin
  Result := TRegistroC855.Create;
  Add(Result);
end;

{ TRegistroC857List }

function TRegistroC857List.GetItem(Index: Integer): TRegistroC857;
begin
  Result := TRegistroC857(inherited Items[Index]);
end;

procedure TRegistroC857List.SetItem(Index: Integer; const Value: TRegistroC857);
begin
  Put(Index, Value);
end;

function TRegistroC857List.New: TRegistroC857;
begin
  Result := TRegistroC857.Create;
  Add(Result);
end;

{ TRegistroC860List }

function TRegistroC860List.GetItem(Index: Integer): TRegistroC860;
begin
  Result := TRegistroC860(Inherited Items[Index]);
end;

function TRegistroC860List.New: TRegistroC860;
begin
  Result := TRegistroC860.Create;
  Add(Result);
end;

procedure TRegistroC860List.SetItem(Index: Integer; const Value: TRegistroC860);
begin
  Put(Index, Value);
end;

{ TRegistroC890List }

function TRegistroC890List.GetItem(Index: Integer): TRegistroC890;
begin
  Result := TRegistroC890(Inherited Items[Index]);
end;

function TRegistroC890List.New: TRegistroC890;
begin
  Result := TRegistroC890.Create;
  Add(Result);
end;

procedure TRegistroC890List.SetItem(Index: Integer; const Value: TRegistroC890);
begin
  Put(Index, Value);
end;

{ TRegistroC895 }

constructor TRegistroC895.Create;
begin
  FRegistroC897 := TRegistroC897List.Create;
end;

destructor TRegistroC895.Destroy;
begin
  FRegistroC897.Free;
  inherited Destroy;
end;

{ TRegistroC895List }

function TRegistroC895List.GetItem(Index: Integer): TRegistroC895;
begin
  Result := TRegistroC895(Inherited Items[Index]);
end;

procedure TRegistroC895List.SetItem(Index: Integer; const Value: TRegistroC895);
begin
  Put(Index, Value);
end;

function TRegistroC895List.New: TRegistroC895;
begin 
  Result := TRegistroC895.Create;
  Add(Result);
end;

{ TRegistroC897List }

function TRegistroC897List.GetItem(Index: Integer): TRegistroC897;
begin
  Result := TRegistroC897(Inherited Items[Index]);
end;

procedure TRegistroC897List.SetItem(Index: Integer; const Value: TRegistroC897);
begin 
  Put(Index, Value);
end;

function TRegistroC897List.New: TRegistroC897;
begin 
  Result := TRegistroC897.Create;
  Add(Result);
end;

{ TRegistroC100 }

constructor TRegistroC100.Create();
begin
  inherited Create;
  FRegistroC101 := TRegistroC101List.Create;  /// BLOCO C - Lista de RegistroC105 (FILHO) 
  FRegistroC105 := TRegistroC105List.Create;  /// BLOCO C - Lista de RegistroC105 (FILHO)
  FRegistroC110 := TRegistroC110List.Create;  /// BLOCO C - Lista de RegistroC110 (FILHO)
  FRegistroC120 := TRegistroC120List.Create;  /// BLOCO C - Lista de RegistroC110 (FILHO)
  FRegistroC130 := TRegistroC130List.Create;  /// BLOCO C - Lista de RegistroC110 (FILHO)
  FRegistroC140 := TRegistroC140List.Create;  /// BLOCO C - Lista de RegistroC140 (FILHO)
  FRegistroC160 := TRegistroC160List.Create;  /// BLOCO C - Lista de RegistroC110 (FILHO)
  FRegistroC165 := TRegistroC165List.Create;  /// BLOCO C - Lista de RegistroC110 (FILHO)
  FRegistroC170 := TRegistroC170List.Create;  /// BLOCO C - Lista de RegistroC170 (FILHO)
  FRegistroC185 := TRegistroC185List.Create;  /// BLOCO C - Lista de RegistroC185 (FILHO)
  FRegistroC186 := TRegistroC186List.Create;  /// BLOCO C - Lista de RegistroC186 (FILHO)
  FRegistroC190 := TRegistroC190List.Create;  /// BLOCO C - Lista de RegistroC190 (FILHO)
  FRegistroC195 := TRegistroC195List.Create;  /// BLOCO C - Lista de RegistroC110 (FILHO)
end;

destructor TRegistroC100.Destroy;
begin
  FRegistroC101.Free;
  FRegistroC105.Free;
  FRegistroC110.Free;
  FRegistroC120.Free;
  FRegistroC130.Free;
  FRegistroC140.Free;
  FRegistroC160.Free;
  FRegistroC165.Free;
  FRegistroC170.Free;
  FRegistroC185.Free;
  FRegistroC186.Free;
  FRegistroC190.Free;
  FRegistroC195.Free;
  inherited;
end;

{ TRegistroC110 }

constructor TRegistroC110.Create();
begin
  inherited Create;
  FRegistroC111 := TRegistroC111List.Create;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO)
  FRegistroC112 := TRegistroC112List.Create;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO)
  FRegistroC113 := TRegistroC113List.Create;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO)
  FRegistroC114 := TRegistroC114List.Create;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO)
  FRegistroC115 := TRegistroC115List.Create;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO)
  FRegistroC116 := TRegistroC116List.Create;  /// BLOCO C - Lista de RegistroC111 (FILHO fo FILHO) {Altera��o Vers�o 2.0.4 03Mar2011}
end;

destructor TRegistroC110.Destroy;
begin
  FRegistroC111.Free;
  FRegistroC112.Free;
  FRegistroC113.Free;
  FRegistroC114.Free;
  FRegistroC115.Free;
  FRegistroC116.Free;  {Altera��o Vers�o 2.0.4 03Mar2011}
  inherited;
end;

{ TRegistroC140 }

constructor TRegistroC140.Create;
begin
  FRegistroC141 := TRegistroC141List.Create; // BLOCO C - Lista de Registro (FILHO do FILHO)
end;

destructor TRegistroC140.Destroy;
begin
  FRegistroC141.Free;
  inherited;
end;

{ TRegistroC460 }

constructor TRegistroC460.Create;
begin
  FRegistroC470 := TRegistroC470List.Create; // BLOCO C - Lista de Registro (FILHO do FILHO)
  FRegistroC465 := TRegistroC465List.Create; // BLOCO C - Lista de Registro (FILHO do FILHO)
end;

destructor TRegistroC460.Destroy;
begin
  FRegistroC470.Free;
  FRegistroC465.Free;
  inherited;
end;

{ TRegistroC350 }

constructor TRegistroC350.Create;
begin
  FRegistroC370 := TRegistroC370List.Create;  /// BLOCO C - Lista de RegistroC370 (FILHO)
  FRegistroC390 := TRegistroC390List.Create;  /// BLOCO C - Lista de RegistroC370 (FILHO)
end;

destructor TRegistroC350.Destroy;
begin
  FRegistroC370.Free;
  FRegistroC390.Free;
  inherited;
end;

constructor TRegistroC420.Create;
begin
  FRegistroC425 := TRegistroC425List.Create;
end;

destructor TRegistroC420.Destroy;
begin
  FRegistroC425.Free;
  inherited;
end;

{ TRegistroC400 }

constructor TRegistroC400.Create;
begin
  FRegistroC405 := TRegistroC405List.Create;
end;

destructor TRegistroC400.Destroy;
begin
  FRegistroC405.Free;
  inherited;
end;

{ TRegistroC405 }

constructor TRegistroC405.Create;
begin
  FRegistroC410 := TRegistroC410List.Create;
  FRegistroC420 := TRegistroC420List.Create;
  FRegistroC460 := TRegistroC460List.Create;
  FRegistroC490 := TRegistroC490List.Create;
end;

destructor TRegistroC405.Destroy;
begin
  FRegistroC410.Free;
  FRegistroC420.Free;
  FRegistroC460.Free;
  FRegistroC490.Free;
  inherited;
end;

{ TRegistroC170 }

constructor TRegistroC170.Create;
begin
  FRegistroC171 := TRegistroC171List.Create;
  FRegistroC172 := TRegistroC172List.Create;
  FRegistroC173 := TRegistroC173List.Create;
  FRegistroC174 := TRegistroC174List.Create;
  FRegistroC175 := TRegistroC175List.Create;
  FRegistroC176 := TRegistroC176List.Create;
  FRegistroC177 := TRegistroC177List.Create;
  FRegistroC178 := TRegistroC178List.Create;
  FRegistroC179 := TRegistroC179List.Create;
  FRegistroC180 := TRegistroC180List.Create;
  FRegistroC181 := TRegistroC181List.Create;
end;

destructor TRegistroC170.Destroy;
begin
  FRegistroC171.Free;
  FRegistroC172.Free;
  FRegistroC173.Free;
  FRegistroC174.Free;
  FRegistroC175.Free;
  FRegistroC176.Free;
  FRegistroC177.Free;
  FRegistroC178.Free;
  FRegistroC179.Free;
  FRegistroC180.Free;
  FRegistroC181.Free;
  inherited;
end;

{ TRegistroC500 }

constructor TRegistroC500.Create;
begin
  FRegistroC510 := TRegistroC510List.Create;  /// BLOCO C - Lista de RegistroC510 (FILHO)
  FRegistroC590 := TRegistroC590List.Create;  /// BLOCO C - Lista de RegistroC590 (FILHO)
  FRegistroC595 := TRegistroC595List.Create;  /// BLOCO C - Lista de RegistroC590 (FILHO)
end;

destructor TRegistroC500.Destroy;
begin
  FRegistroC510.Free;
  FRegistroC590.Free;
  FRegistroC595.Free;
  inherited;
end;

{ TRegistroC001 }

constructor TRegistroC001.Create;
begin
   inherited Create;
   FRegistroC100 := TRegistroC100List.Create;
   FRegistroC300 := TRegistroC300List.Create;
   FRegistroC350 := TRegistroC350List.Create;
   FRegistroC400 := TRegistroC400List.Create;
   FRegistroC495 := TRegistroC495List.Create;
   FRegistroC500 := TRegistroC500List.Create;
   FRegistroC600 := TRegistroC600List.Create;
   FRegistroC700 := TRegistroC700List.Create;
   FRegistroC800 := TRegistroC800List.Create;
   FRegistroC860 := TRegistroC860List.Create;
   //
   IND_MOV := imSemDados;
end;

destructor TRegistroC001.Destroy;
begin
  FRegistroC100.Free;
  FRegistroC300.Free;
  FRegistroC350.Free;
  FRegistroC400.Free;
  FRegistroC495.Free;
  FRegistroC500.Free;
  FRegistroC600.Free;
  FRegistroC700.Free;
  FRegistroC800.Free;
  FRegistroC860.Free;
  inherited;
end;

{ TRegistroC195 }

constructor TRegistroC195.Create;
begin
  inherited Create;
  FRegistroC197 := TRegistroC197List.Create;
end;

destructor TRegistroC195.Destroy;
begin
  FRegistroC197.Free;
  inherited;
end;

{ TRegistroC300 }

constructor TRegistroC300.Create;
begin
  inherited Create;
  fRegistroC310 := TRegistroC310List.Create;
  fRegistroC320 := TRegistroC320List.Create;
end;

destructor TRegistroC300.Destroy;
begin
  fRegistroC310.Free;
  fRegistroC320.Free;
  inherited;
end;

{ TRegistroC320 }

constructor TRegistroC320.Create;
begin
  inherited Create;
  FRegistroC321 := TRegistroC321List.Create;
end;

destructor TRegistroC320.Destroy;
begin
  FRegistroC321.Free;
  inherited;
end;

{ TRegistroC600 }

constructor TRegistroC600.Create;
begin
  inherited Create;
  FRegistroC690 := TRegistroC690List.Create;
  FRegistroC610 := TRegistroC610List.Create;
  FRegistroC601 := TRegistroC601List.Create;
end;

destructor TRegistroC600.Destroy;
begin
  FRegistroC690.Free;
  FRegistroC610.Free;
  FRegistroC601.Free;
  inherited;
end;

{ TRegistroC700 }

constructor TRegistroC700.Create;
begin
  inherited Create;
  FRegistroC790 := TRegistroC790List.Create;
end;

destructor TRegistroC700.Destroy;
begin
  FRegistroC790.Free;
  inherited;
end;

{ TRegistroC790 }

constructor TRegistroC790.Create;
begin
  inherited Create;
  FRegistroC791 := TRegistroC791List.Create;
end;

destructor TRegistroC790.Destroy;
begin
  FRegistroC791.Free;
  inherited;
end;

{ TRegistroC800 }

constructor TRegistroC800.Create;
begin
  inherited Create;
  FRegistroC810 := TRegistroC810List.Create;
  FRegistroC850 := TRegistroC850List.Create;
  FRegistroC855 := TRegistroC855List.Create;
end;

destructor TRegistroC800.Destroy;
begin
  FRegistroC810.Free;
  FRegistroC850.Free;
  FRegistroC855.Free;
  inherited;
end;

{ TRegistroC860 }

constructor TRegistroC860.Create;
begin
  inherited Create;
  FRegistroC870 := TRegistroC870List.Create;
  FRegistroC890 := TRegistroC890List.Create;
  FRegistroC895 := TRegistroC895List.Create;
end;

destructor TRegistroC860.Destroy;
begin
  FRegistroC870.Free;
  FRegistroC890.Free;
  FRegistroC895.Free;
  inherited;
end;

{ TRegistroC105 }

constructor TRegistroC105.Create(AOwner: TRegistroC100);
begin
end;

{ TRegistroC190 }

constructor TRegistroC190.Create;
begin
  inherited Create;
  FRegistroC191 := TRegistroC191List.Create;
end;

destructor TRegistroC190.Destroy;
begin
  FRegistroC191.Free;
  inherited;
end;
{ TRegistroC180List }

function TRegistroC180List.GetItem(Index: Integer): TRegistroC180;
begin
   Result := TRegistroC180(Inherited Items[Index]);
end;

function TRegistroC180List.New: TRegistroC180;
begin
  Result := TRegistroC180.Create;
  Add(Result);
end;

procedure TRegistroC180List.SetItem(Index: Integer; const Value: TRegistroC180);
begin
   Put(Index, Value);
end;

{ TRegistroC185 }

{ TRegistroC185List }

function TRegistroC185List.GetItem(Index: Integer): TRegistroC185;
begin
   Result := TRegistroC185(Inherited Items[Index]);
end;

function TRegistroC185List.New: TRegistroC185;
begin
  Result := TRegistroC185.Create;
  Add(Result);
end;

procedure TRegistroC185List.SetItem(Index: Integer; const Value: TRegistroC185);
begin
   Put(Index, Value);
end;

{ TRegistroC330List }

function TRegistroC330List.GetItem(Index: Integer): TRegistroC330;
begin
   Result := TRegistroC330(Inherited Items[Index]);
end;

function TRegistroC330List.New: TRegistroC330;
begin
  Result := TRegistroC330.Create;
  Add(Result);
end;

procedure TRegistroC330List.SetItem(Index: Integer; const Value: TRegistroC330);
begin
   Put(Index, Value);
end;

{ TRegistroC321 }

constructor TRegistroC321.Create;
begin
  inherited Create;
  FRegistroC330 := TRegistroC330List.Create;
end;

destructor TRegistroC321.Destroy;
begin
  FRegistroC330.Free;
  inherited;
end;

{ TRegistroC380List }

function TRegistroC380List.GetItem(Index: Integer): TRegistroC380;
begin
   Result := TRegistroC380(Inherited Items[Index]);
end;

function TRegistroC380List.New: TRegistroC380;
begin
  Result := TRegistroC380.Create;
  Add(Result);
end;

procedure TRegistroC380List.SetItem(Index: Integer; const Value: TRegistroC380);
begin
   Put(Index, Value);
end;

{ TRegistroC430List }

function TRegistroC430List.GetItem(Index: Integer): TRegistroC430;
begin
   Result := TRegistroC430(Inherited Items[Index]);
end;

function TRegistroC430List.New: TRegistroC430;
begin
  Result := TRegistroC430.Create;
  Add(Result);
end;

procedure TRegistroC430List.SetItem(Index: Integer; const Value: TRegistroC430);
begin
   Put(Index, Value);
end;

{ TRegistroC425 }

constructor TRegistroC425.Create;
begin
  inherited Create;
  FRegistroC430 := TRegistroC430List.Create;
end;

destructor TRegistroC425.Destroy;
begin
  FRegistroC430.Free;
  inherited;
end;

{ TRegistroC480List }

function TRegistroC480List.GetItem(Index: Integer): TRegistroC480;
begin
   Result := TRegistroC480(Inherited Items[Index]);
end;

function TRegistroC480List.New: TRegistroC480;
begin
  Result := TRegistroC480.Create;
  Add(Result);
end;

procedure TRegistroC480List.SetItem(Index: Integer; const Value: TRegistroC480);
begin
   Put(Index, Value);
end;

{ TRegistroC470 }

constructor TRegistroC470.Create;
begin
  inherited Create;
  FRegistroC480 := TRegistroC480List.Create;
end;

destructor TRegistroC470.Destroy;
begin
  FRegistroC480.Free;
  inherited;
end;

{ TRegistroC370 }

constructor TRegistroC370.Create;
begin
  inherited Create;
  FRegistroC380 := TRegistroC380List.Create;
end;

destructor TRegistroC370.Destroy;
begin
  FRegistroC380.Free;
  inherited;
end;

{ TRegistroC591List }

function TRegistroC591List.GetItem(Index: Integer): TRegistroC591;
begin
   Result := TRegistroC591(Inherited Items[Index]);
end;

function TRegistroC591List.New: TRegistroC591;
begin
  Result := TRegistroC591.Create;
  Add(Result);
end;

procedure TRegistroC591List.SetItem(Index: Integer; const Value: TRegistroC591);
begin
   Put(Index, Value);
end;

{ TRegistroC590 }

constructor TRegistroC590.Create;
begin
  inherited Create;
  FRegistroC591 := TRegistroC591List.Create;
end;

destructor TRegistroC590.Destroy;
begin
  FRegistroC591.Free;
  inherited;
end;

{ TRegistroC595List }

function TRegistroC595List.GetItem(Index: Integer): TRegistroC595;
begin
   Result := TRegistroC595(Inherited Items[Index]);
end;

function TRegistroC595List.New: TRegistroC595;
begin
  Result := TRegistroC595.Create;
  Add(Result);
end;

procedure TRegistroC595List.SetItem(Index: Integer; const Value: TRegistroC595);
begin
   Put(Index, Value);
end;

{ TRegistroC595 }

constructor TRegistroC595.Create;
begin
  inherited Create;
  FRegistroC597 := TRegistroC597List.Create;
end;

destructor TRegistroC595.Destroy;
begin
   FRegistroC597.Free;
  inherited;
end;

{ TRegistroC597List }

function TRegistroC597List.GetItem(Index: Integer): TRegistroC597;
begin
   Result := TRegistroC597(Inherited Items[Index]);
end;

function TRegistroC597List.New: TRegistroC597;
begin
   Result := TRegistroC597.Create;
   Add(Result);
end;

procedure TRegistroC597List.SetItem(Index: Integer; const Value: TRegistroC597);
begin
   Put(Index, Value);
end;

{ TRegistroC810List }

function TRegistroC810List.GetItem(Index: Integer): TRegistroC810;
begin
  Result := TRegistroC810(Inherited GetItem(Index));
end;

function TRegistroC810List.New: TRegistroC810;
begin
  Result := TRegistroC810.Create;
  Add(Result);
end;

procedure TRegistroC810List.SetItem(Index: Integer; const Value: TRegistroC810);
begin
  inherited SetItem(Index, Value);
end;

{ TRegistroC810 }

constructor TRegistroC810.Create;
begin
  inherited;
  FRegistroC815 := TRegistroC815.Create;
end;

destructor TRegistroC810.Destroy;
begin
  FRegistroC815.Free;
  inherited;
end;

{ TRegistroC870 }

constructor TRegistroC870.Create;
begin
  inherited;
  FRegistroC880 := TRegistroC880.Create
end;

destructor TRegistroC870.Destroy;
begin
  FRegistroC880.Free;
  inherited;
end;

{ TRegistroC870List }

function TRegistroC870List.GetItem(Index: Integer): TRegistroC870;
begin
  Result := TRegistroC870(inherited GetItem(Index));
end;

function TRegistroC870List.New: TRegistroC870;
begin
  Result := TRegistroC870.Create;
  Self.Add(Result);
end;

procedure TRegistroC870List.SetItem(Index: Integer; const Value: TRegistroC870);
begin
  inherited SetItem(Index, Value);
end;

{ TRegistroC181List }

function TRegistroC181List.GetItem(Index: Integer): TRegistroC181;
begin
   Result := TRegistroC181(Inherited Items[Index]);
end;

function TRegistroC181List.New: TRegistroC181;
begin
  Result := TRegistroC181.Create;
  Add(Result);
end;

procedure TRegistroC181List.SetItem(Index: Integer; const Value: TRegistroC181);
begin
   Put(Index, Value);
end;

{ TRegistroC186List }

function TRegistroC186List.GetItem(Index: Integer): TRegistroC186;
begin
   Result := TRegistroC186(Inherited Items[Index]);
end;

function TRegistroC186List.New: TRegistroC186;
begin
  Result := TRegistroC186.Create;
  Add(Result);
end;

procedure TRegistroC186List.SetItem(Index: Integer; const Value: TRegistroC186);
begin
   Put(Index, Value);
end;

end.
