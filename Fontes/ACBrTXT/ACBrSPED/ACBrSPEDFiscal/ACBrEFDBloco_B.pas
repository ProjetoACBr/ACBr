{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro e Renan Eustaquio               }
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

unit ACBrEFDBloco_B;

{$I ACBr.inc}

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrEFDBlocos;

type
  TRegistroB020List = class;
  TRegistroB025List = class;
  TRegistroB030List = class;
  TRegistroB035List = class;
  TRegistroB350List = class;
  TRegistroB420List = class;
  TRegistroB440List = class;
  TRegistroB460List = class;
  TRegistroB470List = class;
  TRegistroB500List = class;
  TRegistroB510List = class;

  /// Registro B001 - ABERTURA DO BLOCO B
  TRegistroB001 = class(TOpenBlocos)
  private
    FRegistroB020: TRegistroB020List;
    FRegistroB030: TRegistroB030List;
    FRegistroB350: TRegistroB350List;
    FRegistroB420: TRegistroB420List;
    FRegistroB440: TRegistroB440List;
    FRegistroB460: TRegistroB460List;
    FRegistroB470: TRegistroB470List;
    FRegistroB500: TRegistroB500List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy
    property RegistroB020: TRegistroB020List read FRegistroB020 write FRegistroB020;
    property RegistroB030: TRegistroB030List read FRegistroB030 write FRegistroB030;
    property RegistroB350: TRegistroB350List read FRegistroB350 write FRegistroB350;
    property RegistroB420: TRegistroB420List read FRegistroB420 write FRegistroB420;
    property RegistroB440: TRegistroB440List read FRegistroB440 write FRegistroB440;
    property RegistroB460: TRegistroB460List read FRegistroB460 write FRegistroB460;
    property RegistroB470: TRegistroB470List read FRegistroB470 write FRegistroB470;
    property RegistroB500: TRegistroB500List read FRegistroB500 write FRegistroB500;

  end;

  /// REGISTRO B020: NOTA FISCAL (C�DIGO 01), NOTA FISCAL DE SERVI�OS (C�DIGO03), NOTA FISCAL DE SERVI�OS AVULSA (C�DIGO 3B),
  /// NOTA FISCAL DE PRODUTOR(C�DIGO 04), CONHECIMENTO DE TRANSPORTE RODOVI�RIO DE CARGAS
  /// (C�DIGO 08), NF-e (C�DIGO 55) e NFC-e (C�DIGO 65).
 TRegistroB020 = class
  private
    fIND_OPER: TACBrIndOper;          /// Indicador do tipo de opera��o: 0- Aquisi��o; 1- Presta��o
    fIND_EMIT: TACBrIndEmit;          /// Indicador do emitente do documento fiscal: 0- Emiss�o pr�pria; 1- Terceiros
    fCOD_PART: String;                /// C�digo do participante (campo 02 do Registro 0150):
                                      ///   - do prestador, no caso de declarante na condi��o de tomador;
                                      ///   - do tomador, no caso de declarante na condi��o de prestador
    fCOD_MOD: String;                 /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.3
    fCOD_SIT: TACBrCodSit;            /// C�digo da situa��o do documento fiscal, conforme a Tabela 4.1.2
    fSER: String;                     /// S�rie do documento fiscal
    fNUM_DOC: String;                 /// N�mero do documento fiscal
    fCHV_NFE: String;                 /// Chave da Nota Fiscal Eletr�nica
    fDT_DOC: TDateTime;               /// Data da emiss�o do documento fiscal
    fCOD_MUN_SERV: String;            /// C�digo do munic�pio onde o servi�o foi prestado,conforme a tabela IBGE.
    fVL_CONT: currency;               /// Valor cont�bil (valor total do documento)
    fVL_MAT_TERC: currency;           /// Valor do material fornecido por terceiros na presta��o do servi�o
    fVL_SUB: currency;                /// Valor da subempreitada
    fVL_ISNT_ISS: currency;           /// Valor das opera��es isentas ou n�o-tributadas pelo ISS
    fVL_DED_BC: currency;             /// Valor da dedu��o da base de c�lculo
    fVL_BC_ISS: currency;             /// Valor da base de c�lculo do ISS
    fVL_BC_ISS_RT: currency;          /// Valor da base de c�lculo de reten��o do ISS
    fVL_ISS_RT: currency;             /// Valor do ISS retido pelo tomador
    fVL_ISS: currency;                /// Valor do ISS destacado
    fCOD_INF_OBS: String;             /// C�digo da observa��o do lan�amento fiscal(campo 02 do Registro 0460)
    fRegistroB025: TRegistroB025List; /// Bloco b - Lista de RegistroB025 (FILHO)
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override;                       /// Destroy
    property IND_OPER: TACBrIndOper           read fIND_OPER      write fIND_OPER;
    property IND_EMIT: TACBrIndEmit           read fIND_EMIT      write fIND_EMIT;
    property COD_PART: String                 read fCOD_PART      write fCOD_PART;
    property COD_MOD: String                  read fCOD_MOD       write fCOD_MOD;
    property COD_SIT: TACBrCodSit             read fCOD_SIT       write fCOD_SIT;
    property SER: String                      read fSER           write fSER;
    property NUM_DOC: String                  read fNUM_DOC       write fNUM_DOC;
    property CHV_NFE: String                  read fCHV_NFE       write fCHV_NFE;
    property DT_DOC: TDateTime                read fDT_DOC        write fDT_DOC;
    property COD_MUN_SERV: String             read fCOD_MUN_SERV  write fCOD_MUN_SERV;
    property VL_CONT: currency                read fVL_CONT       write fVL_CONT;
    property VL_MAT_TERC: currency            read fVL_MAT_TERC   write fVL_MAT_TERC;
    property VL_SUB: currency                 read fVL_SUB        write fVL_SUB;
    property VL_ISNT_ISS: currency            read fVL_ISNT_ISS   write fVL_ISNT_ISS;
    property VL_DED_BC: currency              read fVL_DED_BC     write fVL_DED_BC;
    property VL_BC_ISS: currency              read fVL_BC_ISS     write fVL_BC_ISS;
    property VL_BC_ISS_RT: currency           read fVL_BC_ISS_RT  write fVL_BC_ISS_RT;
    property VL_ISS_RT: currency              read fVL_ISS_RT     write fVL_ISS_RT;
    property VL_ISS: currency                 read fVL_ISS        write fVL_ISS;
    property COD_INF_OBS: String              read fCOD_INF_OBS   write fCOD_INF_OBS;
    property RegistroB025: TRegistroB025List  read fRegistroB025  write fRegistroB025; // BLOCO B - Lista de RegistroB025
  end;

  /// Registro B020 - Lista
  TRegistroB020List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB020; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB020); /// SetItem
  public
    function New(): TRegistroB020;
    property Items[Index: Integer]: TRegistroB020 read GetItem write SetItem;
  end;

  /// REGISTRO B025: DETALHAMENTO POR COMBINA��O DE AL�QUOTA E ITEM DA LISTA DE SERVI�OS DA LC 116/2003)
  TRegistroB025 = class
  private
    fVL_CONT_P: currency;    /// Parcela correspondente ao "Valor Cont�bil" referente � combina��o da al�quota e item da lista
    fVL_BC_ISS_P: currency;  /// Parcela correspondente ao "Valor da base de c�lculo do ISS" referente � combina��o da al�quota e item da lista
    fALIQ_ISS: currency;     /// Al�quota do ISS
    fVL_ISS_P: currency;     /// Parcela correspondente ao "Valor do ISS" referente � combina��o da al�quota e item da lista
    fVL_ISNT_ISS_P: currency; /// Parcela correspondente ao "Valor das opera��es isentas ou n�otributadas pelo ISS" referente � combina��o da al�quota e item da lista
    fCOD_SERV: String;         /// Item da lista de servi�os, conforme Tabela 4.6.3
  public
    property VL_CONT_P: currency     read fVL_CONT_P     write fVL_CONT_P;
    property VL_BC_ISS_P: currency   read fVL_BC_ISS_P   write fVL_BC_ISS_P;
    property ALIQ_ISS: currency      read fALIQ_ISS      write fALIQ_ISS;
    property VL_ISS_P: currency      read fVL_ISS_P      write fVL_ISS_P;
    property VL_ISNT_ISS_P: currency read fVL_ISNT_ISS_P write fVL_ISNT_ISS_P;
    property COD_SERV: String        read fCOD_SERV      write fCOD_SERV;
  end;

  /// Registro B025 - Lista
  TRegistroB025List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB025; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB025); /// SetItem
  public
    function New: TRegistroB025;
    property Items[Index: Integer]: TRegistroB025 read GetItem write SetItem;
  end;

  /// REGISTRO B030: NOTA FISCAL DE SERVI�OS SIMPLIFICADA (C�DIGO 3A)
 TRegistroB030 = class
  private
    fCOD_MOD: String;                 /// C�digo do modelo do documento fiscal, conforme a Tabela 4.1.3
    fSER: String;                     /// S�rie do documento fiscal
    fNUM_DOC_INI: String;             /// N�mero do primeiro documento fiscal emitido no dia
    fNUM_DOC_FIN: String;             /// N�mero do �ltimo documento fiscal emitido no dia
    fDT_DOC: TDateTime;               /// Data da emiss�o do documento fiscal
    fQTD_CANC: currency;              /// Quantidade de documentos cancelados
    fVL_CONT: currency;               /// Valor cont�bil (valor total do documento)
    fVL_ISNT_ISS: currency;           /// Valor das opera��es isentas ou n�o-tributadas pelo ISS
    fVL_BC_ISS: currency;             /// Valor da base de c�lculo do ISS
    fVL_ISS: currency;                /// Valor do ISS destacado
    fCOD_INF_OBS: String;             /// C�digo da observa��o do lan�amento fiscal(campo 02 do Registro 0460)
    fRegistroB035: TRegistroB035List; /// Bloco b - Lista de RegistroB035 (FILHO)
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override;                       /// Destroy
    property COD_MOD: String                  read fCOD_MOD       write fCOD_MOD;
    property SER: String                      read fSER           write fSER;
    property NUM_DOC_INI: String              read fNUM_DOC_INI   write fNUM_DOC_INI;
    property NUM_DOC_FIN: String              read fNUM_DOC_FIN   write fNUM_DOC_FIN;
    property DT_DOC: TDateTime                read fDT_DOC        write fDT_DOC;
    property QTD_CANC: currency               read fQTD_CANC      write fQTD_CANC;
    property VL_CONT: currency                read fVL_CONT       write fVL_CONT;
    property VL_ISNT_ISS: currency            read fVL_ISNT_ISS   write fVL_ISNT_ISS;
    property VL_BC_ISS: currency              read fVL_BC_ISS     write fVL_BC_ISS;
    property VL_ISS: currency                 read fVL_ISS        write fVL_ISS;
    property COD_INF_OBS: String              read fCOD_INF_OBS   write fCOD_INF_OBS;
    property RegistroB035: TRegistroB035List  read fRegistroB035  write fRegistroB035; // BLOCO B - Lista de RegistroB035
  end;

  /// Registro B030 - Lista
  TRegistroB030List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB030; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB030); /// SetItem
  public
    function New(): TRegistroB030;
    property Items[Index: Integer]: TRegistroB030 read GetItem write SetItem;
  end;

  /// REGISTRO B035: DETALHAMENTO POR COMBINA��O DE AL�QUOTA E ITEM DA LISTA DE SERVI�OS DA LC 116/2003)
  TRegistroB035 = class
  private
    fVL_CONT_P: currency;    /// Parcela correspondente ao "Valor Cont�bil" referente � combina��o da al�quota e item da lista
    fVL_BC_ISS_P: currency;  /// Parcela correspondente ao "Valor da base de c�lculo do ISS" referente � combina��o da al�quota e item da lista
    fALIQ_ISS: currency;     /// Al�quota do ISS
    fVL_ISS_P: currency;     /// Parcela correspondente ao "Valor do ISS" referente � combina��o da al�quota e item da lista
    fVL_ISNT_ISS_P: currency; /// Parcela correspondente ao "Valor das opera��es isentas ou n�otributadas pelo ISS" referente � combina��o da al�quota e item da lista
    fCOD_SERV: String;         /// Item da lista de servi�os, conforme Tabela 4.6.3
  public
    property VL_CONT_P: currency     read fVL_CONT_P     write fVL_CONT_P ;
    property VL_BC_ISS_P: currency   read fVL_BC_ISS_P   write fVL_BC_ISS_P;
    property ALIQ_ISS: currency      read fALIQ_ISS      write fALIQ_ISS;
    property VL_ISS_P: currency      read fVL_ISS_P      write fVL_ISS_P;
    property VL_ISNT_ISS_P: currency read fVL_ISNT_ISS_P write fVL_ISNT_ISS_P;
    property COD_SERV: String        read fCOD_SERV      write fCOD_SERV;
  end;

  /// Registro B035 - Lista
  TRegistroB035List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB035; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB035); /// SetItem
  public
    function New: TRegistroB035;
    property Items[Index: Integer]: TRegistroB035 read GetItem write SetItem;
  end;

  //REGISTRO B350: SERVI�OS PRESTADOS POR INSTITUI��ES FINANCEIRAS
  TRegistroB350 = class
  private
    fCOD_CTD: String;     /// C�digo da conta do plano de contas
    fCTA_ISS: String;     /// Descri��o da conta no plano de contas
    fCTA_COSIF: String;   /// C�digo COSIF a que est� subordinada a conta do ISS das institui��es financeiras
    fQTD_OCOR: currency;  /// Quantidade de ocorr�ncias na conta
    fCOD_SERV: String;    /// Item da lista de servi�os, conforme Tabela 4.6.3.
    fVL_CONT: currency;   /// Valor cont�bil
    fVL_BC_ISS: currency; /// Valor da base de c�lculo do ISS
    fALIQ_ISS: currency;  /// Al�quota do ISS
    fVL_ISS: currency;    /// Valor do ISS
    fCOD_INF_OBS: String; /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
  public
    constructor Create(AOwner: TRegistroB001); virtual; /// Create
    destructor Destroy; override;                       /// Destroy
    property COD_CTD: String     read fCOD_CTD     write fCOD_CTD;
    property CTA_ISS: String     read fCTA_ISS     write fCTA_ISS;
    property CTA_COSIF: String   read fCTA_COSIF   write fCTA_COSIF;
    property QTD_OCOR: currency  read fQTD_OCOR    write fQTD_OCOR;
    property COD_SERV: String    read fCOD_SERV    write fCOD_SERV;
    property VL_CONT: currency   read fVL_CONT     write fVL_CONT;
    property VL_BC_ISS: currency read fVL_BC_ISS   write fVL_BC_ISS;
    property ALIQ_ISS: currency  read fALIQ_ISS    write fALIQ_ISS;
    property VL_ISS: currency    read fVL_ISS      write fVL_ISS;
    property COD_INF_OBS: String read fCOD_INF_OBS write fCOD_INF_OBS;
  end;

  /// Registro B350 - Lista
  TRegistroB350List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB350; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB350); /// SetItem
  public
    function New(AOwner: TRegistroB001): TRegistroB350;
    property Items[Index: Integer]: TRegistroB350 read GetItem write SetItem;
  end;

  //REGISTRO B420: TOTALIZA��O DOS VALORES DE SERVI�OS PRESTADOS POR COMBINA��O DE AL�QUOTA E ITEM DA LISTA DE SERVI�OS DA LC 116/2003
  TRegistroB420 = class
  private
    fVL_CONT: currency;     /// Totaliza��o do Valor Cont�bil das presta��es do declarante referente � combina��o da al�quota e item da lista
    fVL_BC_ISS: currency;   /// Totaliza��o do Valor da base de c�lculo do ISS das presta��es do declarante referente � combina��o da al�quota e item da lista
    fALIQ_ISS: currency;    /// Al�quota do ISS
    fVL_ISNT_ISS: currency; /// Totaliza��o do valor das opera��es isentas ou n�o-tributadas pelo ISS referente � combina��o da al�quota e item da lista
    fVL_ISS: currency;      /// Totaliza��o, por combina��o da al�quota e item da lista, do Valor do ISS
    fCOD_SERV: String;      /// Item da lista de servi�os, conforme Tabela 4.6.3.
  public
    constructor Create(AOwner: TRegistroB001); virtual; /// Create
    destructor Destroy; override;                       /// Destroy
    property VL_CONT: currency      read fVL_CONT     write fVL_CONT;
    property VL_BC_ISS: currency    read fVL_BC_ISS   write fVL_BC_ISS;
    property ALIQ_ISS: currency     read fALIQ_ISS    write fALIQ_ISS;
    property VL_ISNT_ISS: currency  read fVL_ISNT_ISS write fVL_ISNT_ISS;
    property VL_ISS: currency       read fVL_ISS      write fVL_ISS;
    property COD_SERV: String       read fCOD_SERV    write fCOD_SERV;
  end;

  /// Registro B420 - Lista
  TRegistroB420List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB420; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB420); /// SetItem
  public
    function New(AOwner: TRegistroB001): TRegistroB420;
    property Items[Index: Integer]: TRegistroB420 read GetItem write SetItem;
  end;

  //REGISTRO B440: TOTALIZA��O DOS VALORES RETIDOS
  TRegistroB440 = class
  private
    fIND_OPER:TACBrIndOper;  /// Indicador do tipo de opera��o: 0- Aquisi��o; 1- Presta��o
    fCOD_PART: String;       /// C�digo do participante (campo 02 do Registro 0150):- do prestador, no caso de aquisi��o de servi�o pelo declarante; - do tomador, no caso de presta��o de servi�o pelo declarante
    fVL_CONT_RT: currency;   /// Totaliza��o do Valor Cont�bil das presta��es e/ou aquisi��es do declarante pela combina��o de tipo de opera��o e participante.
    fVL_BC_ISS_RT: currency; /// Totaliza��o do Valor da base de c�lculo de reten��o do ISS das presta��es e/ou aquisi��es do declarante pela combina��o de tipo de opera��o e participante.
    fVL_ISS_RT: currency;    /// Totaliza��o do Valor do ISS retido pelo tomador das presta��es e/ou aquisi��es do declarante pela combina��o de tipo de opera��o e participante.
  public
    constructor Create(AOwner: TRegistroB001); virtual; /// Create
    destructor Destroy; override;                       /// Destroy
    property IND_OPER:TACBrIndOper  read fIND_OPER     write fIND_OPER;
    property COD_PART: String       read fCOD_PART     write fCOD_PART;
    property VL_CONT_RT: currency   read fVL_CONT_RT   write fVL_CONT_RT;
    property VL_BC_ISS_RT: currency read fVL_BC_ISS_RT write fVL_BC_ISS_RT;
    property VL_ISS_RT: currency    read fVL_ISS_RT    write fVL_ISS_RT;
  end;

  /// Registro B440 - Lista
  TRegistroB440List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB440; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB440); /// SetItem
  public
    function New(AOwner: TRegistroB001): TRegistroB440;
    property Items[Index: Integer]: TRegistroB440 read GetItem write SetItem;
  end;

  //REGISTRO B460: DEDU��ES DO ISS
  TRegistroB460 = class
  private
   fIND_DED:TACBrIndicadorDeducao;   /// Indicador do tipo de dedu��o: 0- Compensa��o do ISS calculado a maior; 1- Benef�cio fiscal por incentivo � cultura; 2- Decis�o administrativa ou judicial; 9- Outros
   fVL_DED: currency;                /// Valor da dedu��o
   fNUM_PROC: String;                /// N�mero do processo ao qual o ajuste est� vinculado, se houver
   fIND_PROC:TACBrIndicadorProcesso; /// Indicador da origem do processo: 0- Sefin; 1- Justi�a Federal; 2- Justi�a Estadual; 9- Outros
   fPROC: String;                    /// Descri��o do processo que embasou o lan�amento
   fCOD_INF_OBS: String;             /// C�digo da observa��o do lan�amento fiscal (campo 02 do Registro 0460)
   fIND_OBR:TACBrIndicadorObrigacao; /// Indicador da obriga��o onde ser� aplicada a dedu��o: 0 - ISS Pr�prio; 1 - ISS Substituto (devido pelas aquisi��es de servi�os do declarante).2 - ISS Uniprofissionais.
  public
   constructor Create(AOwner: TRegistroB001); virtual; /// Create
   destructor Destroy; override;                       /// Destroy
   property IND_DED:TACBrIndicadorDeducao   read fIND_DED     write fIND_DED;
   property VL_DED: currency                read fVL_DED      write fVL_DED;
   property NUM_PROC: String                read fNUM_PROC    write fNUM_PROC;
   property IND_PROC:TACBrIndicadorProcesso read fIND_PROC    write fIND_PROC;
   property PROC: String                    read fPROC        write fPROC;
   property COD_INF_OBS: String             read fCOD_INF_OBS write fCOD_INF_OBS;
   property IND_OBR:TACBrIndicadorObrigacao read fIND_OBR     write fIND_OBR;
  end;

  /// Registro B460 - Lista
  TRegistroB460List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB460; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB460); /// SetItem
  public
    function New(AOwner: TRegistroB001): TRegistroB460;
    property Items[Index: Integer]: TRegistroB460 read GetItem write SetItem;
  end;

  //REGISTRO B470: APURA��O DO ISS
  TRegistroB470 = class
  private
    fVL_CONT: currency;        /// A - Valor total referente �s presta��es de servi�o do per�odo
    fVL_MAT_TERC: currency;    /// B - Valor total do material fornecido por terceiros na presta��o do servi�o
    fVL_MAT_PROP: currency;    /// C - Valor do material pr�prio utilizado na presta��o do servi�o
    fVL_SUB: currency;         /// D - Valor total das subempreitadas N - 02 O
    fVL_ISNT: currency;        /// E - Valor total das opera��es isentas ou n�o-tributadas pelo ISS
    fVL_DED_BC: currency;      /// F - Valor total das dedu��es da base de c�lculo (B + C + D + E)
    fVL_BC_ISS: currency;      /// G - Valor total da base de c�lculo do ISS N - 02 O
    fVL_BC_ISS_RT: currency;   /// H - Valor total da base de c�lculo de reten��o do ISS referente �s presta��es do declarante.
    fVL_ISS: currency;         /// I - Valor total do ISS destacado N - 02 O
    fVL_ISS_RT: currency;      /// J - Valor total do ISS retido pelo tomador nas presta��es do declarante
    fVL_DED: currency;         /// K - Valor total das dedu��es do ISS pr�prio
    fVL_ISS_REC: currency;     /// L - Valor total apurado do ISS pr�prio a recolher (I - J - K)
    fVL_ISS_ST: currency;      /// M - Valor total do ISS substituto a recolher pelas aquisi��es do declarante(tomador)
    fVL_ISS_REC_UNI: currency; /// U Valor do ISS pr�prio a recolher pela Sociedade Uniprofissional
  public
    constructor Create(AOwner: TRegistroB001); virtual; /// Create
    destructor Destroy; override;                       /// Destroy
    property VL_CONT: currency        read fVL_CONT        write fVL_CONT;
    property VL_MAT_TERC: currency    read fVL_MAT_TERC    write fVL_MAT_TERC;
    property VL_MAT_PROP: currency    read fVL_MAT_PROP    write fVL_MAT_PROP;
    property VL_SUB: currency         read fVL_SUB         write fVL_SUB;
    property VL_ISNT: currency        read fVL_ISNT        write fVL_ISNT;
    property VL_DED_BC: currency      read fVL_DED_BC      write fVL_DED_BC;
    property VL_BC_ISS: currency      read fVL_BC_ISS      write fVL_BC_ISS;
    property VL_BC_ISS_RT: currency   read fVL_BC_ISS_RT   write fVL_BC_ISS_RT;
    property VL_ISS: currency         read fVL_ISS         write fVL_ISS;
    property VL_ISS_RT: currency      read fVL_ISS_RT      write fVL_ISS_RT;
    property VL_DED: currency         read fVL_DED         write fVL_DED;
    property VL_ISS_REC: currency     read fVL_ISS_REC     write fVL_ISS_REC;
    property VL_ISS_ST: currency      read fVL_ISS_ST      write fVL_ISS_ST;
    property VL_ISS_REC_UNI: currency read fVL_ISS_REC_UNI write fVL_ISS_REC_UNI;
  end;

  /// Registro B470 - Lista
  TRegistroB470List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB470; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB470); /// SetItem
  public
    function New(AOwner: TRegistroB001): TRegistroB470;
    property Items[Index: Integer]: TRegistroB470 read GetItem write SetItem;
  end;

 //REGISTRO B500: APURA��O DO ISS SOCIEDADE UNIPROFISSIONAL
  TRegistroB500 = class
  private
    fVL_REC: currency;   ///Valor mensal das receitas auferidas pela sociedade uniprofissional
    fQTD_PROF: currency; ///Quantidade de profissionais habilitados
    fVL_OR: currency;    //Valor do ISS devido
    FRegistroB510 :TRegistroB510List;
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy
    property VL_REC: currency   read fVL_REC   write fVL_REC;
    property QTD_PROF: currency read fQTD_PROF write fQTD_PROF;
    property VL_OR: currency    read fVL_OR    write fVL_OR;
    property RegistroB510: TRegistroB510List read FRegistroB510 write FRegistroB510;
  end;

  /// Registro B500 - Lista
  TRegistroB500List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB500; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB500); /// SetItem
  public
    function New(): TRegistroB500;
    property Items[Index: Integer]: TRegistroB500 read GetItem write SetItem;
  end;

 //REGISTRO B510: APURA��O DO ISS SOCIEDADE UNIPROFISSIONAL
  TRegistroB510 = class
  private
    fIND_PROF: String; /// Indicador de habilita��o: 0- Profissional habilitado 1- Profissional n�o habilitado
    fIND_ESC: String;  /// Indicador de escolaridade: 0- N�vel superior 1- N�vel m�dio
    fIND_SOC: String;  /// Indicador de participa��o societ�ria: 0- S�cio 1- N�o s�cio
    fCPF: String;      /// N�mero de inscri��o do profissional no CPF.
    fNOME: String;     /// Nome do profissional
  public
    property IND_PROF: String read fIND_PROF write fIND_PROF;
    property IND_ESC: String  read fIND_ESC  write fIND_ESC;
    property IND_SOC: String  read fIND_SOC  write fIND_SOC;
    property CPF: String      read fCPF      write fCPF;
    property NOME: String     read fNOME     write fNOME;
  end;

  /// Registro B510 - Lista
  TRegistroB510List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroB510; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroB510); /// SetItem
  public
    function New: TRegistroB510;
    property Items[Index: Integer]: TRegistroB510 read GetItem write SetItem;
  end;


  /// Registro B990 - ENCERRAMENTO DO BLOCO B

  TRegistroB990 = class
  private
    fQTD_LIN_B: Integer; /// Quantidade total de linhas do Bloco B
  public
    property QTD_LIN_B: Integer read fQTD_LIN_B write fQTD_LIN_B;
  end;

implementation


{ TRegistroB001 }

constructor TRegistroB001.Create;
begin
  inherited Create;
  FRegistroB020 := TRegistroB020List.Create;
  FRegistroB030 := TRegistroB030List.Create;
  FRegistroB350 := TRegistroB350List.Create;
  FRegistroB420 := TRegistroB420List.Create;
  FRegistroB440 := TRegistroB440List.Create;
  FRegistroB460 := TRegistroB460List.Create;
  FRegistroB470 := TRegistroB470List.Create;
  FRegistroB500 := TRegistroB500List.Create;
  IND_MOV := imSemDados;
end;

destructor TRegistroB001.Destroy;
begin
  FRegistroB020.free;
  FRegistroB030.free;
  FRegistroB350.free;
  FRegistroB420.free;
  FRegistroB440.free;
  FRegistroB460.free;
  FRegistroB470.free;
  FRegistroB500.free;
  inherited;
end;

{ TRegistroB020 }

constructor TRegistroB020.Create();
begin
  inherited Create;
  FRegistroB025 := TRegistroB025List.Create;
end;

destructor TRegistroB020.Destroy;
begin
  FRegistroB025.free;
  inherited;
end;

{ TRegistroB020List }

function TRegistroB020List.GetItem(Index: Integer): TRegistroB020;
begin
  Result := TRegistroB020(Inherited Items[Index]);
end;

function TRegistroB020List.New(): TRegistroB020;
begin
  Result := TRegistroB020.Create();
  Add(Result);
end;

procedure TRegistroB020List.SetItem(Index: Integer; const Value: TRegistroB020);
begin
  Put(Index, Value);
end;

{ TRegistroB025List }

function TRegistroB025List.GetItem(Index: Integer): TRegistroB025;
begin
  Result := TRegistroB025(Inherited Items[Index]);
end;

function TRegistroB025List.New: TRegistroB025;
begin
  Result := TRegistroB025.Create;
  Add(Result);
end;

procedure TRegistroB025List.SetItem(Index: Integer; const Value: TRegistroB025);
begin
  Put(Index, Value);
end;

{ TRegistroB030 }

constructor TRegistroB030.Create();
begin
  inherited Create;
  FRegistroB035 := TRegistroB035List.Create;
end;

destructor TRegistroB030.Destroy;
begin
  FRegistroB035.Free;
  inherited;
end;

{ TRegistroB030List }

function TRegistroB030List.GetItem(Index: Integer): TRegistroB030;
begin
  Result := TRegistroB030(Inherited Items[Index]);
end;

function TRegistroB030List.New(): TRegistroB030;
begin
  Result := TRegistroB030.Create();
  Add(Result);
end;

procedure TRegistroB030List.SetItem(Index: Integer; const Value: TRegistroB030);
begin
  Put(Index, Value);
end;

{ TRegistroB035List }

function TRegistroB035List.GetItem(Index: Integer): TRegistroB035;
begin
  Result := TRegistroB035(Inherited Items[Index]);
end;

function TRegistroB035List.New: TRegistroB035;
begin
  Result := TRegistroB035.Create;
  Add(Result);
end;

procedure TRegistroB035List.SetItem(Index: Integer; const Value: TRegistroB035);
begin
  Put(Index, Value);
end;

{ TRegistroB350List }

function TRegistroB350List.GetItem(Index: Integer): TRegistroB350;
begin
  Result := TRegistroB350(Inherited Items[Index]);
end;

function TRegistroB350List.New(AOwner: TRegistroB001): TRegistroB350;
begin
  Result := TRegistroB350.Create(AOwner);
  Add(Result);

end;

procedure TRegistroB350List.SetItem(Index: Integer; const Value: TRegistroB350);
begin
  Put(Index, Value);
end;

{ TRegistroB420List }

function TRegistroB420List.GetItem(Index: Integer): TRegistroB420;
begin
  Result := TRegistroB420(Inherited Items[Index]);
end;

function TRegistroB420List.New(AOwner: TRegistroB001): TRegistroB420;
begin
  Result := TRegistroB420.Create(AOwner);
  Add(Result);
end;

procedure TRegistroB420List.SetItem(Index: Integer; const Value: TRegistroB420);
begin
  Put(Index, Value);
end;

{ TRegistroBB440List }

function TRegistroB440List.GetItem(Index: Integer): TRegistroB440;
begin
  Result := TRegistroB440(Inherited Items[Index]);
end;

function TRegistroB440List.New(AOwner: TRegistroB001): TRegistroB440;
begin
  Result := TRegistroB440.Create(AOwner);
  Add(Result);
end;

procedure TRegistroB440List.SetItem(Index: Integer; const Value: TRegistroB440);
begin
  Put(Index, Value);
end;

{ TRegistroB460List }
function TRegistroB460List.GetItem(Index: Integer): TRegistroB460;
begin
  Result := TRegistroB460(Inherited Items[Index]);
end;

function TRegistroB460List.New(AOwner: TRegistroB001): TRegistroB460;
begin
  Result := TRegistroB460.Create(AOwner);
  Add(Result);
end;

procedure TRegistroB460List.SetItem(Index: Integer; const Value: TRegistroB460);
begin
  Put(Index, Value);
end;

function TRegistroB470List.GetItem(Index: Integer): TRegistroB470;
begin
  Result := TRegistroB470(Inherited Items[Index]);
end;

function TRegistroB470List.New(AOwner: TRegistroB001): TRegistroB470;
begin
  Result := TRegistroB470.Create(AOwner);
  Add(Result);
end;

procedure TRegistroB470List.SetItem(Index: Integer; const Value: TRegistroB470);
begin
  Put(Index, Value);
end;

{ TRegistroB500List }

function TRegistroB500List.GetItem(Index: Integer): TRegistroB500;
begin
  Result := TRegistroB500(Inherited Items[Index]);
end;

function TRegistroB500List.New(): TRegistroB500;
begin
  Result := TRegistroB500.Create();
  Add(Result);
end;

procedure TRegistroB500List.SetItem(Index: Integer; const Value: TRegistroB500);
begin
  Put(Index, Value);
end;

{ TRegistroB510List }

function TRegistroB510List.GetItem(Index: Integer): TRegistroB510;
begin
  Result := TRegistroB510(Inherited Items[Index]);
end;

function TRegistroB510List.New: TRegistroB510;
begin
  Result := TRegistroB510.Create;
  Add(Result);
end;

procedure TRegistroB510List.SetItem(Index: Integer; const Value: TRegistroB510);
begin
  Put(Index, Value);
end;

{ TRegistroB500 }

constructor TRegistroB500.Create();
begin
  inherited Create;
  FRegistroB510 := TRegistroB510List.Create;  /// BLOCO B - Lista de RegistroB510 (FILHO)
end;

destructor TRegistroB500.Destroy;
begin
  FRegistroB510.Free;
  inherited;
end;

{ TRegistroB350 }

constructor TRegistroB350.Create(AOwner: TRegistroB001);
begin

end;

destructor TRegistroB350.Destroy;
begin

  inherited;
end;

{ TRegistroB440 }

constructor TRegistroB440.Create(AOwner: TRegistroB001);
begin

end;

destructor TRegistroB440.Destroy;
begin

  inherited;
end;

{ TRegistroB460 }

constructor TRegistroB460.Create(AOwner: TRegistroB001);
begin

end;

destructor TRegistroB460.Destroy;
begin

  inherited;
end;

{ TRegistroB470 }

constructor TRegistroB470.Create(AOwner: TRegistroB001);
begin

end;

destructor TRegistroB470.Destroy;
begin

  inherited;
end;

{ TRegistroB420 }

constructor TRegistroB420.Create(AOwner: TRegistroB001);
begin

end;

destructor TRegistroB420.Destroy;
begin

  inherited;
end;

end.
