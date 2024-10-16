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
|* 06/05/2014: Francinaldo A. da Costa
|*  - Modifica��es para o layout 2
|* 04/03/2015: Flavio Rubens Massaro Jr.
|* - Modifica��o para contemplar layout 3 referente ao ano calendario 2014
*******************************************************************************}

unit ACBrECDBloco_I;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrECDBlocos;

type
  /// Registro I001 - ABERTURA DO BLOCO I

  TRegistroI001 = class(TOpenBlocos)
  private
  public
  end;

  TRegistroI015List = class;
  TRegistroI051List = class;
  TRegistroI052List = class;
  TRegistroI053List = class;
  TRegistroI151List = class;
  TRegistroI155List = class;
  TRegistroI157List = class;
  TRegistroI250List = class;
  TRegistroI310List = class;
  TRegistroI355List = class;
  TRegistroI555List = class;

  /// Registro I010 - IDENTIFICA��O DA ESCRITURA��O CONT�BIL

  TRegistroI010 = class
  private
    fIND_ESC: String;    /// Indicador da forma de escritura��o cont�bil:G - Livro Di�rio (Completo sem escritura��o auxiliar);R - Livro Di�rio com Escritura��o Resumida (com escritura��o auxiliar);A - Livro Di�rio Auxiliar ao Di�rio com Escritura��o Resumida;B - Livro Balancetes Di�rios e Balan�os;Z - Raz�o Auxiliar (Livro Cont�bil Auxiliar conforme leiaute definido nos registros I500 a I555).
    fCOD_VER_LC: String; /// C�digo da Vers�o do Leiaute Cont�bil (Ver manual).
  public
    property IND_ESC: String read fIND_ESC write fIND_ESC;
    property COD_VER_LC: String read fCOD_VER_LC write fCOD_VER_LC;
  end;

  /// Registro I012 - LIVROS AUXILIARES AO DI�RIO

  TRegistroI012 = class
  private
    fNUM_ORD: String;        /// N�mero de ordem do instrumento associado.
    fNAT_LIVR: String;       /// Natureza do livro associado; finalidade a que se destina o instrumento.
    fTIPO: String;           /// Tipo de escritura��o do livro associado: 0 � digital (inclu�dos no Sped) 1 � outros.
    fCOD_HASH_AUX: String;   /// C�digo Hash do arquivo correspondente ao livro auxiliar utilizado na assinatura digital.
    FRegistroI015: TRegistroI015List;  /// BLOCO I - Lista de RegistroI051 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property NUM_ORD: String read fNUM_ORD write fNUM_ORD;
    property NAT_LIVR: String read fNAT_LIVR write fNAT_LIVR;
    property TIPO: String read fTIPO write fTIPO;
    property COD_HASH_AUX: String read fCOD_HASH_AUX write fCOD_HASH_AUX;

    /// Registros FILHOS
    property RegistroI015: TRegistroI015List read FRegistroI015 write FRegistroI015;
  end;

  /// Registro I012 - Lista

  TRegistroI012List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI012;
    procedure SetItem(Index: Integer; const Value: TRegistroI012);
  public
    function New: TRegistroI012;
    property Items[Index: Integer]: TRegistroI012 read GetItem write SetItem;
  end;

  /// Registro I015 - IDENTIFICA��O  DAS  CONTAS  DA  ESCRITURA��O  RESUMIDA  A
  ///                 QUE SE REFERE A ESCRITURA��O AUXILIAR

  TRegistroI015 = class
  private
    fCOD_CTA_RES: String;    /// C�digo da(s) conta(s) anal�tica(s) do Livro Di�rio com Escritura��o Resumida (R) que recebe os lan�amentos globais.
  public
    property COD_CTA_RES: String read fCOD_CTA_RES write fCOD_CTA_RES;
  end;

  /// Registro I015 - Lista

  TRegistroI015List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI015;
    procedure SetItem(Index: Integer; const Value: TRegistroI015);
  public
    function New: TRegistroI015;
    property Items[Index: Integer]: TRegistroI015 read GetItem write SetItem;
  end;

  /// Registro I020 - CAMPOS ADICIONAIS

  TRegistroI020 = class
  private
    fREG_COD: String;     /// C�digo do registro que recepciona o campo adicional.
    fNUM_AD: String;      /// N�mero seq�encial do campo adicional.
    fCAMPO: String;       /// Nome do campo adicional.
    fDESCRICAO: String;   /// Descri��o do campo adicional.
    fTIPO_DADO: String;   /// Indica��o do tipo de dado (N: num�rico; C: caractere).
  public
    property REG_COD: String read fREG_COD write fREG_COD;
    property NUM_AD: String read fNUM_AD write fNUM_AD;
    property CAMPO: String read fCAMPO write fCAMPO;
    property DESCRICAO: String read fDESCRICAO write fDESCRICAO;
    property TIPO_DADO: String read fTIPO_DADO write fTIPO_DADO;
  end;

  /// Registro I020 - Lista

  TRegistroI020List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI020;
    procedure SetItem(Index: Integer; const Value: TRegistroI020);
  public
    function New: TRegistroI020;
    property Items[Index: Integer]: TRegistroI020 read GetItem write SetItem;
  end;

  /// Registro I030 - TERMO DE ABERTURA DO LIVRO

  TRegistroI030 = class
  private
    fNUM_ORD: String;     /// N�mero de ordem do instrumento de escritura��o.
    fNAT_LIVR: String;    /// Natureza do livro; finalidade a que se destina o instrumento.
    fQTD_LIN: Integer;        /// Quantidade total de linhas do arquivo digital.
    fNOME: String;        /// Nome empresarial.
    fNIRE: String;        /// N�mero de Identifica��o do Registro de Empresas da Junta Comercial.
    fCNPJ: String;        /// N�mero de inscri��o no CNPJ .
    fDT_ARQ: TDateTime;       /// Data do arquivamento dos atos constitutivos.
    fDT_ARQ_CONV: TDateTime;  /// Data de arquivamento do ato de convers�o de sociedade simples em sociedade empres�ria.
    fDESC_MUN: String;    /// Munic�pio.
    fDT_EX_SOCIAL: TDateTime;  /// Data de encerramento do exerc�cio social
    fNOME_AUDITOR: String;     /// Nome do auditor independente
    fCOD_CVM_AUDITOR: string;  /// Registro do auditor independente na CVM
  public
    property NUM_ORD: String read fNUM_ORD write fNUM_ORD;
    property NAT_LIVR: String read fNAT_LIVR write fNAT_LIVR;
    property QTD_LIN: Integer read fQTD_LIN write fQTD_LIN;
    property NOME: String read fNOME write fNOME;
    property NIRE: String read fNIRE write fNIRE;
    property CNPJ: String read fCNPJ write fCNPJ;
    property DT_ARQ: TDateTime read fDT_ARQ write fDT_ARQ;
    property DT_ARQ_CONV: TDateTime read fDT_ARQ_CONV write fDT_ARQ_CONV;
    property DESC_MUN: String read fDESC_MUN write fDESC_MUN;
    property DT_EX_SOCIAL: TDateTime read fDT_EX_SOCIAL write fDT_EX_SOCIAL;
    property NOME_AUDITOR: String read fNOME_AUDITOR write fNOME_AUDITOR;
    property COD_CVM_AUDITOR: string read fCOD_CVM_AUDITOR write fCOD_CVM_AUDITOR;
  end;

  /// Registro I050 - PLANO DE CONTAS

  TRegistroI050 = class
  private
    fDT_ALT: TDateTime;       /// Data da inclus�o/altera��o.
    fCOD_NAT: String;     /// C�digo da natureza da conta/grupo de contas, conforme tabela publicada pelo Sped.
    fIND_CTA: String;     /// Indicador do tipo de conta: S - Sint�tica (grupo de contas);A - Anal�tica (conta).
    fNIVEL: String;       /// N�vel da conta anal�tica/grupo de contas.
    fCOD_CTA: String;     /// C�digo da conta anal�tica/grupo de contas.
    fCOD_CTA_SUP: String; /// C�digo da conta sint�tica /grupo de contas de n�vel imediatamente superior.
    fCTA: String;         /// Nome da conta anal�tica/grupo de contas.

    FRegistroI051: TRegistroI051List;  /// BLOCO I - Lista de RegistroI051 (FILHO)
    FRegistroI052: TRegistroI052List;  /// BLOCO I - Lista de RegistroI052 (FILHO)
    FRegistroI053: TRegistroI053List;  /// BLOCO I - Lista de RegistroI053 (FILHO)    ///
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property DT_ALT: TDateTime read fDT_ALT write fDT_ALT;
    property COD_NAT: String read fCOD_NAT write fCOD_NAT;
    property IND_CTA: String read fIND_CTA write fIND_CTA;
    property NIVEL: String read fNIVEL write fNIVEL;
    property COD_CTA: String read fCOD_CTA write fCOD_CTA;
    property COD_CTA_SUP: String read fCOD_CTA_SUP write fCOD_CTA_SUP;
    property CTA: String read fCTA write fCTA;

    /// Registros FILHOS
    property RegistroI051: TRegistroI051List read FRegistroI051 write FRegistroI051;
    property RegistroI052: TRegistroI052List read FRegistroI052 write FRegistroI052;
    property RegistroI053: TRegistroI053List read FRegistroI053 write FRegistroI053;
  end;

  /// Registro I050 - Lista

  TRegistroI050List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI050;
    procedure SetItem(Index: Integer; const Value: TRegistroI050);
  public
    function New: TRegistroI050;
    property Items[Index: Integer]: TRegistroI050 read GetItem write SetItem;
  end;

  /// Registro I051 - PLANO DE CONTAS REFERENCIAL

  TRegistroI051 = class
  private
    fCOD_PLAN_REF: String;    /// C�digo da institui��o respons�vel pela manuten��o do plano de contas referencial.
    fCOD_CCUS: String;       /// C�digo do centro de custo.
    fCOD_CTA_REF: String;    /// C�digo da conta de acordo com o plano de contas referencial, conforme tabela publicada pelos �rg�os indicados no campo 02- COD_ENT_REF.
  public
    //property COD_ENT_REF: String read fCOD_ENT_REF write fCOD_ENT_REF;
    property COD_PLAN_REF: String read fCOD_PLAN_REF write fCOD_PLAN_REF;
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property COD_CTA_REF: String read fCOD_CTA_REF write fCOD_CTA_REF;
  end;

  /// Registro I051 - Lista

  TRegistroI051List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI051;
    procedure SetItem(Index: Integer; const Value: TRegistroI051);
  public
    function New: TRegistroI051;
    property Items[Index: Integer]: TRegistroI051 read GetItem write SetItem;
  end;

  /// Registro I052 - INDICA��O DOS C�DIGOS DE AGLUTINA��O

  TRegistroI052 = class
  private
    fCOD_CCUS: String; /// C�digo do centro de custo.
    fCOD_AGL: String;  /// C�digo de aglutina��o utilizado no Balan�o Patrimonial e na Demonstra��o de Resultado do Exerc�cio no Bloco J (somente para as contas anal�ticas).
  public
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property COD_AGL: String read fCOD_AGL write fCOD_AGL;
  end;

  /// Registro I052 - Lista

  TRegistroI052List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI052;
    procedure SetItem(Index: Integer; const Value: TRegistroI052);
  public
    function New: TRegistroI052;
    property Items[Index: Integer]: TRegistroI052 read GetItem write SetItem;
  end;

  /// Registro I053 - SUBCONTAS CORRELATAS

  TRegistroI053 = class
  private
    fCOD_CNT_CORR: String; /// C�digo de identifica��o do grupo de conta-subconta(a)
    fNAT_SUB_CNT: String;  /// C�digo da subconta correlata (deve estar no plano de contas e s� pode estar relacionada a um �nico grupo)
    fCOD_IDT: String;      /// Natureza da subconta correlata (conforme tabela de natureza da subconta publicada no Sped )
  public
    property COD_IDT: String read fCOD_IDT write fCOD_CNT_CORR;
    property COD_CNT_CORR: String read fCOD_CNT_CORR write fCOD_CNT_CORR;
    property NAT_SUB_CNT : String read fNAT_SUB_CNT write fNAT_SUB_CNT;
  end;

  /// Registro I053 - Lista

  TRegistroI053List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI053;
    procedure SetItem(Index: Integer; const Value: TRegistroI053);
  public
    function New: TRegistroI053;
    property Items[Index: Integer]: TRegistroI053 read GetItem write SetItem;
  end;

  /// Registro I075 - TABELA DE HIST�RICO PADRONIZADO

  TRegistroI075 = class
  private
    fCOD_HIST: String;    /// C�digo do hist�rico padronizado.
    fDESCR_HIST: String;  /// Descri��o do hist�rico padronizado.
  public
    property COD_HIST: String read fCOD_HIST write fCOD_HIST;
    property DESCR_HIST: String read fDESCR_HIST write fDESCR_HIST;
  end;

  /// Registro I075 - Lista

  TRegistroI075List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI075;
    procedure SetItem(Index: Integer; const Value: TRegistroI075);
  public
    function New: TRegistroI075;
    property Items[Index: Integer]: TRegistroI075 read GetItem write SetItem;
  end;

  /// Registro I100 - CENTRO DE CUSTOS

  TRegistroI100 = class
  private
    fDT_ALT: TdateTime;       /// Data da inclus�o/altera��o.
    fCOD_CCUS: String;    /// C�digo do centro de custos.
    fCCUS: String;        /// Nome do centro de custos.
  public
    property DT_ALT: TdateTime read fDT_ALT write fDT_ALT;
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property CCUS: String read fCCUS write fCCUS;
  end;

  /// Registro I100 - Lista

  TRegistroI100List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI100;
    procedure SetItem(Index: Integer; const Value: TRegistroI100);
  public
    function New: TRegistroI100;
    property Items[Index: Integer]: TRegistroI100 read GetItem write SetItem;
  end;

  /// Registro I150 - SALDOS PERI�DICOS � IDENTIFICA��O DO PER�ODO

  TRegistroI150 = class
  private
    fDT_INI: TDateTime; /// Data de in�cio do per�odo.
    fDT_FIN: TDateTime; /// Data de fim do per�odo.

    FRegistroI151: TRegistroI151List;  /// BLOCO I - Lista de RegistroI151 (FILHO)
    FRegistroI155: TRegistroI155List;  /// BLOCO I - Lista de RegistroI155 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property DT_INI: TDateTime read fDT_INI write fDT_INI;
    property DT_FIN: TDateTime read fDT_FIN write fDT_FIN;
    /// Registros FILHOS
    property RegistroI151: TRegistroI151List read FRegistroI151 write FRegistroI151;
    property RegistroI155: TRegistroI155List read FRegistroI155 write FRegistroI155;
  end;

  /// Registro I150 - Lista

  TRegistroI150List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI150;
    procedure SetItem(Index: Integer; const Value: TRegistroI150);
  public
    function New: TRegistroI150;
    property Items[Index: Integer]: TRegistroI150 read GetItem write SetItem;
  end;

  /// Registro I151 - ASSINATURA  DIGITAL  DOS  ARQUIVOS  QUE  CONT�M  AS
  ///                 FICHAS DE LAN�AMENTO UTILIZADOS NO PER�ODO (IN RFB 926/09)

  TRegistroI151 = class
  private
    fASSIM_DIG: String; /// Transcri��o da assinatura digital utilizada no arquivo contendo o conjunto de fichas de lan�amento
  public
    property ASSIM_DIG: String read fASSIM_DIG write fASSIM_DIG;
  end;

  /// Registro I151 - Lista

  TRegistroI151List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI151;
    procedure SetItem(Index: Integer; const Value: TRegistroI151);
  public
    function New: TRegistroI151;
    property Items[Index: Integer]: TRegistroI151 read GetItem write SetItem;
  end;

  /// Registro I155 - DETALHE DOS SALDOS PERI�DICOS

  TRegistroI155 = class
  private
    fCOD_CTA: String;     /// C�digo da conta anal�tica.
    fCOD_CCUS: String;    /// C�digo do centro de custos.
    fVL_SLD_INI: Currency;    /// Valor do saldo inicial do per�odo.
    fIND_DC_INI: String;  /// Indicador da situa��o do saldo inicial:D - Devedor;C - Credor.
    fVL_DEB: Currency;        /// Valor total dos d�bitos no per�odo.
    fVL_CRED: Currency;       /// Valor total dos cr�ditos no per�odo.
    fVL_SLD_FIN: Currency;    /// Valor do saldo final do per�odo.
    fIND_DC_FIN: String;  /// Indicador da situa��o do saldo final: D - Devedor; C - Credor.

    fVL_SLD_INI_MF: Currency;    /// Valor do saldo inicial do per�odo.
    fIND_DC_INI_MF: String;  /// Indicador da situa��o do saldo inicial:D - Devedor;C - Credor.
    fVL_DEB_MF: Currency;        /// Valor total dos d�bitos no per�odo.
    fVL_CRED_MF: Currency;       /// Valor total dos cr�ditos no per�odo.
    fVL_SLD_FIN_MF: Currency;    /// Valor do saldo final do per�odo.
    fIND_DC_FIN_MF: String;  /// Indicador da situa��o do saldo final: D - Devedor; C - Credor.

    FRegistroI157: TRegistroI157List;  /// BLOCO I - Lista de RegistroI157 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override;

    property COD_CTA: String read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property VL_SLD_INI: Currency read fVL_SLD_INI write fVL_SLD_INI;
    property IND_DC_INI: String read fIND_DC_INI write fIND_DC_INI;
    property VL_DEB: Currency read fVL_DEB write fVL_DEB;
    property VL_CRED: Currency read fVL_CRED write fVL_CRED;
    property VL_SLD_FIN: Currency read fVL_SLD_FIN write fVL_SLD_FIN;
    property IND_DC_FIN: String read fIND_DC_FIN write fIND_DC_FIN;

    property VL_SLD_INI_MF: Currency read fVL_SLD_INI_MF write fVL_SLD_INI_MF;
    property IND_DC_INI_MF: String read fIND_DC_INI_MF write fIND_DC_INI_MF;
    property VL_DEB_MF: Currency read fVL_DEB_MF write fVL_DEB_MF;
    property VL_CRED_MF: Currency read fVL_CRED_MF write fVL_CRED_MF;
    property VL_SLD_FIN_MF: Currency read fVL_SLD_FIN_MF write fVL_SLD_FIN_MF;
    property IND_DC_FIN_MF: String read fIND_DC_FIN_MF write fIND_DC_FIN_MF;

    property RegistroI157: TRegistroI157List read FRegistroI157 write FRegistroI157;
  end;

  /// Registro I155 - Lista

  TRegistroI155List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI155;
    procedure SetItem(Index: Integer; const Value: TRegistroI155);
  public
    function New: TRegistroI155;
    property Items[Index: Integer]: TRegistroI155 read GetItem write SetItem;
  end;

  /// Registro I157 - TRANSFER�NCIA DE SALDOS DE PLANO DE CONTAS ANTERIOR

  TRegistroI157 = class
  private
    fCOD_CTA: String;     /// C�digo da conta anal�tica do plano de contas anterior.
    fCOD_CCUS: String;    /// C�digo do centro de custos.
    fVL_SLD_INI: Currency;    /// Valor do saldo inicial do per�odo.
    fIND_DC_INI: String;  /// Indicador da situa��o do saldo inicial:D - Devedor;C - Credor.
    fVL_SLD_INI_MF: Currency;
    fIND_DC_INI_MF: String;
  public
    property COD_CTA: String read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property VL_SLD_INI: Currency read fVL_SLD_INI write fVL_SLD_INI;
    property IND_DC_INI: String read fIND_DC_INI write fIND_DC_INI;
    property VL_SLD_INI_MF: Currency read fVL_SLD_INI_MF write fVL_SLD_INI_MF;
    property IND_DC_INI_MF: String read fIND_DC_INI_MF write fIND_DC_INI_MF;
  end;

  /// Registro I157 - Lista

  TRegistroI157List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI157;
    procedure SetItem(Index: Integer; const Value: TRegistroI157);
  public
    function New: TRegistroI157;
    property Items[Index: Integer]: TRegistroI157 read GetItem write SetItem;
  end;

  // Registro I200 - Lan�amentos Cont�beis

  TRegistroI200 = class
  private
    fNUM_LCTO: String;        // N�mero de identifica��o do lan�amento
    fDT_LCTO: TDateTime;         // Data do lan�amento
    fVL_LCTO: Currency;           // Valor do Lan�amento
    fIND_LCTO: String;        // Indicador do tipo do lan�amento
    fDT_LCTO_EXT: TDateTime;         // Data do lan�amento extemporaneo
    fVL_LCTO_MF: Currency;

    fRegistroI250: TRegistroI250List; /// BLOCO I - Lista de RegistroI250 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property NUM_LCTO: String read fNUM_LCTO write fNUM_LCTO;
    property DT_LCTO: TDateTime read fDT_LCTO write fDT_LCTO;
    property VL_LCTO: Currency read fVL_LCTO write fVL_LCTO;
    property IND_LCTO: String read fIND_LCTO write fIND_LCTO;
    property DT_LCTO_EXT: TDateTime read fDT_LCTO_EXT write fDT_LCTO_EXT;
    property VL_LCTO_MF: Currency read fVL_LCTO_MF write fVL_LCTO_MF;
    property RegistroI250: TRegistroI250List read fRegistroI250 write fRegistroI250;
  end;

  TRegistroI200List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI200;
    procedure SetItem(Index: Integer; Value: TRegistroI200);
  public
    function New: TRegistroI200;
    property Items[Index: Integer]: TRegistroI200 read GetItem write SetItem;
  end;

  // Registro I250 - Partidas do Lan�amentos

  TRegistroI250 = class
  private
    fCOD_CTA: String;
    fCOD_CCUS: String;
    fVL_DC: Currency;
    fIND_DC: String;
    fVL_DC_MF: Currency;
    fIND_DC_MF: String;
    fNUM_ARQ: String;
    fCOD_HIST_PAD: String;
    fHIST: String;
    fCOD_PART: String;
  public
    property COD_CTA: String read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property VL_DC: Currency read fVL_DC write fVL_DC;
    property IND_DC: String read fIND_DC write fIND_DC;
    property NUM_ARQ: String  read fNUM_ARQ write fNUM_ARQ;
    property COD_HIST_PAD: String  read fCOD_HIST_PAD write fCOD_HIST_PAD;
    property HIST: String read fHIST write fHIST;
    property COD_PART: String read fCOD_PART write fCOD_PART;
    property VL_DC_MF: Currency read fVL_DC_MF write fVL_DC_MF;
    property IND_DC_MF: String read fIND_DC_MF write fIND_DC_MF;

  end;

  // Registro I250 - lista

  TRegistroI250List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI250;
    procedure SetItem(Index: Integer; Value: TRegistroI250);
  public
    function New: TRegistroI250;
    property Items[Index: Integer]: TRegistroI250 read GetItem write SetItem;
  end;

  /// Registro I300 - BALANCETES DI�RIOS � IDENTIFICA��O DA DATA

  TRegistroI300 = class
  private
    fDT_BCTE: TDateTime; /// Data do Balancete.

    FRegistroI310: TRegistroI310List;  /// BLOCO I - Lista de RegistroI310 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property DT_BCTE: TDateTime read fDT_BCTE write fDT_BCTE;
    /// Registros FILHOS
    property RegistroI310: TRegistroI310List read FRegistroI310 write FRegistroI310;
  end;

  /// Registro I300 - Lista

  TRegistroI300List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI300;
    procedure SetItem(Index: Integer; const Value: TRegistroI300);
  public
    function New: TRegistroI300;
    property Items[Index: Integer]: TRegistroI300 read GetItem write SetItem;
  end;

  /// Registro I310 - DETALHE DO BALANCETE DI�RIO

  TRegistroI310 = class
  private
    fCOD_CTA: String;       /// C�digo da conta anal�tica debitada/creditada.
    fCOD_CCUS: String;      /// C�digo do centro de custos.
    fVAL_DEBD: Currency;    /// Total dos d�bitos do dia.
    fVAL_CRED: Currency;    /// Total dos cr�ditos do dia.
    fVAL_DEBD_MF: Currency;
    fVAL_CRED_MF: Currency;
  public
    property COD_CTA: String read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property VAL_DEBD: Currency read fVAL_DEBD write fVAL_DEBD;
    property VAL_CRED: Currency read fVAL_CRED write fVAL_CRED;
    property VAL_DEBD_MF: Currency read fVAL_DEBD_MF write fVAL_DEBD_MF;
    property VAL_CRED_MF: Currency read fVAL_CRED_MF write fVAL_CRED_MF;
  end;

  /// Registro I310 - Lista

  TRegistroI310List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI310;
    procedure SetItem(Index: Integer; const Value: TRegistroI310);
  public
    function New: TRegistroI310;
    property Items[Index: Integer]: TRegistroI310 read GetItem write SetItem;
  end;

  /// Registro I350 - SALDO DAS CONTAS DE RESULTADO ANTES DO ENCERRAMENTO � IDENTIFICA��O DA DATA

  TRegistroI350 = class
  private
    fDT_RES: TDateTime; /// Data da apura��o do resultado.

    FRegistroI355: TRegistroI355List;  /// BLOCO I - Lista de RegistroI355 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property DT_RES: TDateTime read fDT_RES write fDT_RES;
    /// Registros FILHOS
    property RegistroI355: TRegistroI355List read FRegistroI355 write FRegistroI355;
  end;

  /// Registro I350 - Lista

  TRegistroI350List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI350;
    procedure SetItem(Index: Integer; const Value: TRegistroI350);
  public
    function New: TRegistroI350;
    property Items[Index: Integer]: TRegistroI350 read GetItem write SetItem;
  end;

  /// Registro I355 - DETALHE DOS SALDOS DAS CONTAS DE RESULTADO ANTES DO ENCERRAMENTO

  TRegistroI355 = class
  private
    fCOD_CTA: String;     /// C�digo da conta anal�tica de resultado.
    fCOD_CCUS: String;    /// C�digo do centro de custos.
    fVL_CTA: Currency;    /// Valor do saldo final antes do lan�amento de encerramento.
    fIND_DC: String;      /// Indicador da situa��o do saldo final: D - Devedor; C - Credor.
    fIND_DC_MF: String;
    fVL_CTA_MF: Currency;

  public
    property COD_CTA: String read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property VL_CTA: Currency read fVL_CTA write fVL_CTA;
    property IND_DC: String read fIND_DC write fIND_DC;
    property VL_CTA_MF: Currency read fVL_CTA_MF write fVL_CTA_MF;
    property IND_DC_MF: String read fIND_DC_MF write fIND_DC_MF;
  end;

  /// Registro I355 - Lista

  TRegistroI355List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI355;
    procedure SetItem(Index: Integer; const Value: TRegistroI355);
  public
    function New: TRegistroI355;
    property Items[Index: Integer]: TRegistroI355 read GetItem write SetItem;
  end;

  /// Registro I500 - PAR�METROS DE IMPRESS�O E VISUALIZA��O DO LIVRO RAZ�O AUXILIAR COM LEIAUTE PARAMETRIZ�VEL

  TRegistroI500 = class
  private
    fTAM_FONTE: Integer;        /// Tamanho da fonte.
  public
    property TAM_FONTE: Integer read fTAM_FONTE write fTAM_FONTE;
  end;

  /// Registro I500 - Lista

  TRegistroI500List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI500;
    procedure SetItem(Index: Integer; const Value: TRegistroI500);
  public
    function New: TRegistroI500;
    property Items[Index: Integer]: TRegistroI500 read GetItem write SetItem;
  end;

  /// Registro I510 - DEFINI��O DE CAMPOS DO LIVRO RAZ�O AUXILIAR COM LEIAUTE PARAMETRIZ�VEL

  TRegistroI510 = class
  private
    fNM_CAMPO: String;      ///Nome do campo, sem espa�os em branco ou caractere especial.
    fDESC_CAMPO: String;    ///Descri��o do campo que ser� utilizado na visualiza��o do Livro Auxiliar.
    fTIPO_CAMPO: String;    ///Tipo do campo: "N" - num�rico; "C" - caractere.
    fTAM_CAMPO: Integer;        ///Tamanho do campo.
    fDEC_CAMPO: Integer;         ///Quantidade de casas decimais para campos tipo "N".
    fCOL_CAMPO: Integer;        ///Largura da coluna no relat�rio (em quantidade de caracteres).
  public
    property NM_CAMPO: String read fNM_CAMPO write fNM_CAMPO;
    property DESC_CAMPO: String read fDESC_CAMPO write fDESC_CAMPO;
    property TIPO_CAMPO: String read fTIPO_CAMPO write fTIPO_CAMPO;
    property TAM_CAMPO: Integer read fTAM_CAMPO write fTAM_CAMPO;
    property DEC_CAMPO: Integer read fDEC_CAMPO write fDEC_CAMPO;
    property COL_CAMPO: Integer read fCOL_CAMPO write fCOL_CAMPO;
  end;

  /// Registro I510 - Lista

  TRegistroI510List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI510;
    procedure SetItem(Index: Integer; const Value: TRegistroI510);
  public
    function New: TRegistroI510;
    property Items[Index: Integer]: TRegistroI510 read GetItem write SetItem;
  end;

  // Registro I550 - DETALHES DO LIVRO RAZ�O AUXILIAR COM LEIAUTE PARAMETRIZ�VEL

  TRegistroI550 = class
  private
    fRZ_CONT: String;        // Conte�do dos campos mencionados no Registro I510.

    fRegistroI555: TRegistroI555List; /// BLOCO I - Lista de RegistroI555 (FILHO)
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property RZ_CONT: String read fRZ_CONT write fRZ_CONT;

    property RegistroI555: TRegistroI555List read fRegistroI555 write fRegistroI555;
  end;

  TRegistroI550List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI550;
    procedure SetItem(Index: Integer; Value: TRegistroI550);
  public
    function New: TRegistroI550;
    property Items[Index: Integer]: TRegistroI550 read GetItem write SetItem;
  end;


   // Registro I555 - TOTAIS NO LIVRO RAZ�O AUXILIAR COM LEIAUTE PARAMETRIZ�VEL

  TRegistroI555 = class
  private
    fRZ_CONT_TOT: String;
  public
    property RZ_CONT_TOT: String read fRZ_CONT_TOT write fRZ_CONT_TOT;
  end;

  // Registro I555 - lista

  TRegistroI555List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroI555;
    procedure SetItem(Index: Integer; Value: TRegistroI555);
  public
    function New: TRegistroI555;
    property Items[Index: Integer]: TRegistroI555 read GetItem write SetItem;
  end;

  /// Registro I990 - ENCERRAMENTO DO BLOCO I

  TRegistroI990 = class
  private
    fQTD_LIN_I: Integer;    /// Quantidade total de linhas do Bloco I
  public
    property QTD_LIN_I: Integer read FQTD_LIN_I write FQTD_LIN_I;
  end;

implementation

{ TRegistroI012List }

function TRegistroI012List.GetItem(Index: Integer): TRegistroI012;
begin
  Result := TRegistroI012(Inherited Items[Index]);
end;

function TRegistroI012List.New: TRegistroI012;
begin
  Result := TRegistroI012.Create;
  Add(Result);
end;

procedure TRegistroI012List.SetItem(Index: Integer; const Value: TRegistroI012);
begin
  Put(Index, Value);
end;

{ TRegistroI015List }

function TRegistroI015List.GetItem(Index: Integer): TRegistroI015;
begin
  Result := TRegistroI015(Inherited Items[Index]);
end;

function TRegistroI015List.New: TRegistroI015;
begin
  Result := TRegistroI015.Create;
  Add(Result);
end;

procedure TRegistroI015List.SetItem(Index: Integer; const Value: TRegistroI015);
begin
  Put(Index, Value);
end;

{ TRegistroI020List }

function TRegistroI020List.GetItem(Index: Integer): TRegistroI020;
begin
  Result := TRegistroI020(Inherited Items[Index]);
end;

function TRegistroI020List.New: TRegistroI020;
begin
  Result := TRegistroI020.Create;
  Add(Result);
end;

procedure TRegistroI020List.SetItem(Index: Integer; const Value: TRegistroI020);
begin
  Put(Index, Value);
end;

constructor TRegistroI050.Create;
begin
   FRegistroI051 := TRegistroI051List.Create;
   FRegistroI052 := TRegistroI052List.Create;
   FRegistroI053 := TRegistroI053List.Create;
end;

destructor TRegistroI050.Destroy;
begin
  FRegistroI051.Free;
  FRegistroI052.Free;
  FRegistroI053.Free;
  inherited;
end;

{ TRegistroI050List }

function TRegistroI050List.GetItem(Index: Integer): TRegistroI050;
begin
  Result := TRegistroI050(Inherited Items[Index]);
end;

function TRegistroI050List.New: TRegistroI050;
begin
  Result := TRegistroI050.Create;
  Add(Result);
end;

procedure TRegistroI050List.SetItem(Index: Integer; const Value: TRegistroI050);
begin
  Put(Index, Value);
end;

{ TRegistroI051List }

function TRegistroI051List.GetItem(Index: Integer): TRegistroI051;
begin
  Result := TRegistroI051(Inherited Items[Index]);
end;

function TRegistroI051List.New: TRegistroI051;
begin
  Result := TRegistroI051.Create;
  Add(Result);
end;

procedure TRegistroI051List.SetItem(Index: Integer; const Value: TRegistroI051);
begin
  Put(Index, Value);
end;

{ TRegistroI052List }

function TRegistroI052List.GetItem(Index: Integer): TRegistroI052;
begin
  Result := TRegistroI052(Inherited Items[Index]);
end;

function TRegistroI052List.New: TRegistroI052;
begin
  Result := TRegistroI052.Create;
  Add(Result);
end;

procedure TRegistroI052List.SetItem(Index: Integer; const Value: TRegistroI052);
begin
  Put(Index, Value);
end;

{ TRegistroI075List }

function TRegistroI075List.GetItem(Index: Integer): TRegistroI075;
begin
  Result := TRegistroI075(Inherited Items[Index]);
end;

function TRegistroI075List.New: TRegistroI075;
begin
  Result := TRegistroI075.Create;
  Add(Result);
end;

procedure TRegistroI075List.SetItem(Index: Integer; const Value: TRegistroI075);
begin
  Put(Index, Value);
end;

{ TRegistroI100List }

function TRegistroI100List.GetItem(Index: Integer): TRegistroI100;
begin
  Result := TRegistroI100(Inherited Items[Index]);
end;

function TRegistroI100List.New: TRegistroI100;
begin
  Result := TRegistroI100.Create;
  Add(Result);
end;

procedure TRegistroI100List.SetItem(Index: Integer; const Value: TRegistroI100);
begin
  Put(Index, Value);
end;

constructor TRegistroI150.Create;
begin
   FRegistroI151 := TRegistroI151List.Create;
   FRegistroI155 := TRegistroI155List.Create;
end;

constructor TRegistroI155.Create;
begin
   FRegistroI157 := TRegistroI157List.Create;
end;

destructor TRegistroI155.Destroy;
begin
   FRegistroI157.Free;
   inherited Destroy;
end;

destructor TRegistroI150.Destroy;
begin
  FRegistroI151.Free;
  FRegistroI155.Free;
//  FRegistroI157.Free;
  inherited;
end;

{ TRegistroI150List }

function TRegistroI150List.GetItem(Index: Integer): TRegistroI150;
begin
  Result := TRegistroI150(Inherited Items[Index]);
end;

function TRegistroI150List.New: TRegistroI150;
begin
  Result := TRegistroI150.Create;
  Add(Result);
end;

procedure TRegistroI150List.SetItem(Index: Integer; const Value: TRegistroI150);
begin
  Put(Index, Value);
end;

{ TRegistroI151List }

function TRegistroI151List.GetItem(Index: Integer): TRegistroI151;
begin
  Result := TRegistroI151(Inherited Items[Index]);
end;

function TRegistroI151List.New: TRegistroI151;
begin
  Result := TRegistroI151.Create;
  Add(Result);
end;

procedure TRegistroI151List.SetItem(Index: Integer; const Value: TRegistroI151);
begin
  Put(Index, Value);
end;

{ TRegistroI155List }

function TRegistroI155List.GetItem(Index: Integer): TRegistroI155;
begin
  Result := TRegistroI155(Inherited Items[Index]);
end;

function TRegistroI155List.New: TRegistroI155;
begin
  Result := TRegistroI155.Create;
  Add(Result);
end;

procedure TRegistroI155List.SetItem(Index: Integer; const Value: TRegistroI155);
begin
  Put(Index, Value);
end;

{ TRegistroI157List }

function TRegistroI157List.GetItem(Index: Integer): TRegistroI157;
begin
  Result := TRegistroI157(Inherited Items[Index]);
end;

function TRegistroI157List.New: TRegistroI157;
begin
  Result := TRegistroI157.Create;
  Add(Result);
end;

procedure TRegistroI157List.SetItem(Index: Integer; const Value: TRegistroI157);
begin
  Put(Index, Value);
end;

// TRegistroI200

constructor TRegistroI200.Create;
begin
  FRegistroI250 := TRegistroI250List.create;
end;

destructor TRegistroI200.Destroy;
begin
  FRegistroI250.Free;
  inherited;
end;

// TRegistroI200List

function TRegistroI200List.GetItem(Index: Integer): TRegistroI200;
begin
  Result := TRegistroI200(Inherited Items[Index]);
end;

function TRegistroI200List.New: TRegistroI200;
begin
  Result := TRegistroI200.Create;
  Add(Result);
end;

procedure TRegistroI200List.SetItem(Index: Integer; Value: TRegistroI200);
begin
  Put(Index, Value);
end;

// TRegistroI250List

function TRegistroI250List.GetItem(index: Integer): TRegistroI250;
begin
  Result := TRegistroI250( inherited Items[Index]);
end;

function TRegistroI250List.New: TRegistroI250;
begin
   Result := TRegistroI250.Create;
   Add(Result);
end;

procedure TRegistroI250List.SetItem(Index: Integer; Value: TRegistroI250);
begin
   Put(Index, Value);
end;


constructor TRegistroI300.Create;
begin
   FRegistroI310 := TRegistroI310List.Create;
end;

destructor TRegistroI300.Destroy;
begin
  FRegistroI310.Free;
  inherited;
end;

{ TRegistroI300List }

function TRegistroI300List.GetItem(Index: Integer): TRegistroI300;
begin
  Result := TRegistroI300(Inherited Items[Index]);
end;

function TRegistroI300List.New: TRegistroI300;
begin
  Result := TRegistroI300.Create;
  Add(Result);
end;

procedure TRegistroI300List.SetItem(Index: Integer; const Value: TRegistroI300);
begin
  Put(Index, Value);
end;

{ TRegistroI310List }

function TRegistroI310List.GetItem(Index: Integer): TRegistroI310;
begin
  Result := TRegistroI310(Inherited Items[Index]);
end;

function TRegistroI310List.New: TRegistroI310;
begin
  Result := TRegistroI310.Create;
  Add(Result);
end;

procedure TRegistroI310List.SetItem(Index: Integer; const Value: TRegistroI310);
begin
  Put(Index, Value);
end;

constructor TRegistroI350.Create;
begin
   FRegistroI355 := TRegistroI355List.Create;
end;

destructor TRegistroI350.Destroy;
begin
  FRegistroI355.Free;
  inherited;
end;

{ TRegistroI350List }

function TRegistroI350List.GetItem(Index: Integer): TRegistroI350;
begin
  Result := TRegistroI350(Inherited Items[Index]);
end;

function TRegistroI350List.New: TRegistroI350;
begin
  Result := TRegistroI350.Create;
  Add(Result);
end;

procedure TRegistroI350List.SetItem(Index: Integer; const Value: TRegistroI350);
begin
  Put(Index, Value);
end;

{ TRegistroI355List }

function TRegistroI355List.GetItem(Index: Integer): TRegistroI355;
begin
  Result := TRegistroI355(Inherited Items[Index]);
end;

function TRegistroI355List.New: TRegistroI355;
begin
  Result := TRegistroI355.Create;
  Add(Result);
end;

procedure TRegistroI355List.SetItem(Index: Integer; const Value: TRegistroI355);
begin
  Put(Index, Value);
end;

{ TRegistroI500List }

function TRegistroI500List.GetItem(Index: Integer): TRegistroI500;
begin
  Result := TRegistroI500(Inherited Items[Index]);
end;

function TRegistroI500List.New: TRegistroI500;
begin
  Result := TRegistroI500.Create;
  Add(Result);
end;

procedure TRegistroI500List.SetItem(Index: Integer; const Value: TRegistroI500);
begin
  Put(Index, Value);
end;

{ TRegistroI510List }

function TRegistroI510List.GetItem(Index: Integer): TRegistroI510;
begin
  Result := TRegistroI510(Inherited Items[Index]);
end;

function TRegistroI510List.New: TRegistroI510;
begin
  Result := TRegistroI510.Create;
  Add(Result);
end;

procedure TRegistroI510List.SetItem(Index: Integer; const Value: TRegistroI510);
begin
  Put(Index, Value);
end;

// TRegistroI550

constructor TRegistroI550.Create;
begin
  FRegistroI555 := TRegistroI555List.create;
end;

destructor TRegistroI550.Destroy;
begin
  FRegistroI555.Free;
  inherited;
end;

// TRegistroI550List

function TRegistroI550List.GetItem(Index: Integer): TRegistroI550;
begin
  Result := TRegistroI550(Inherited Items[Index]);
end;

function TRegistroI550List.New: TRegistroI550;
begin
  Result := TRegistroI550.Create;
  Add(Result);
end;

procedure TRegistroI550List.SetItem(Index: Integer; Value: TRegistroI550);
begin
  Put(Index, Value);
end;

// TRegistroI555List

function TRegistroI555List.GetItem(index: Integer): TRegistroI555;
begin
  Result := TRegistroI555( inherited Items[Index]);
end;

function TRegistroI555List.New: TRegistroI555;
begin
   Result := TRegistroI555.Create;
   Add(Result);
end;

procedure TRegistroI555List.SetItem(Index: Integer; Value: TRegistroI555);
begin
   Put(Index, Value);
end;

{ TRegistroI012 }

constructor TRegistroI012.Create;
begin
  FRegistroI015 := TRegistroI015List.Create;
end;

destructor TRegistroI012.Destroy;
begin
  FRegistroI015.Free;
  inherited;
end;


{ TRegistroI053List }

function TRegistroI053List.GetItem(Index: Integer): TRegistroI053;
begin
  Result := TRegistroI053(Inherited Items[Index]);
end;

function TRegistroI053List.New: TRegistroI053;
begin
  Result := TRegistroI053.Create;
  Add(Result);      
end;

procedure TRegistroI053List.SetItem(Index: Integer; const Value: TRegistroI053);
begin
  Put(Index, Value);
end;

end.
