{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro, Paulo Junqueira e              }
{                              Claudio Roberto de Souza                        }
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

unit ACBrEPCBloco_0;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrEPCBlocos;

type
  TRegistro0035List = class;
  TRegistro0100List = class;
  TRegistro0110     = class;
  TRegistro0111     = class;
  TRegistro0120List = class;
  TRegistro0140List = class;
  TRegistro0145     = class;
  TRegistro0150List = class;
  TRegistro0190List = class;
  TRegistro0200List = class;
  TRegistro0205List = class;
  TRegistro0206     = class;
  TRegistro0208     = class;
  TRegistro0400List = class;
  TRegistro0450List = class;
  TRegistro0500List = class;
  TRegistro0600List = class;


  //Registro 0900: Composi��o das Receitas do Per�odo � Receita Bruta e Demais Receitas
  TRegistro0900 = class
  private
    FREC_TOTAL_BLOCO_A: Double;        /// Receita total referente aos registros escriturados no Bloco A
    FREC_NRB_BLOCO_A  : Variant;       /// Parcela da receita total escriturada no Bloco A (Campo 02), n�o classificada como receita bruta
    FREC_TOTAL_BLOCO_C: Double;        /// Receita total referente aos registros escriturados no Bloco C
    FREC_NRB_BLOCO_C  : Variant;       /// Parcela da receita total escriturada no Bloco C (Campo 04), n�o classificada como receita bruta
    FREC_TOTAL_BLOCO_D: Double;        /// Receita total referente aos registros escriturados no Bloco D
    FREC_NRB_BLOCO_D  : Variant;       /// Parcela da receita total escriturada no Bloco D (Campo 06), n�o classificada como receita bruta
    FREC_TOTAL_BLOCO_F: Double;        /// Receita total referente aos registros escriturados no Bloco F
    FREC_NRB_BLOCO_F  : Variant;       /// Parcela da receita total escriturada no Bloco F (Campo 08), n�o classificada como receita bruta
    FREC_TOTAL_BLOCO_I: Double;        /// Receita total referente aos registros escriturados no Bloco I
    FREC_NRB_BLOCO_I  : Variant;       /// Parcela da receita total escriturada no Bloco I (Campo 10) n�o classificada como receita bruta
    FREC_TOTAL_BLOCO_1: Double;        /// Receita total referente aos registros escriturados no Bloco 1 (RET)
    FREC_NRB_BLOCO_1  : Variant;       /// Parcela da receita total escriturada no Bloco 1 (Campo 12), n�o classificada como receita bruta
    FREC_TOTAL_PERIODO: Double;        /// Receita bruta total (Soma dos Campos 02, 04, 06, 08, 10 e 12)
    FREC_TOTAL_NRB_PERIODO: Variant;   /// Parcela da receita total escriturada (Campo 14), n�o classificada como receita bruta (Soma dos Campos 03, 05, 07, 09, 11 e 13)  public
  public
    property REC_TOTAL_BLOCO_A      : Double   read  FREC_TOTAL_BLOCO_A      write FREC_TOTAL_BLOCO_A;
    property REC_NRB_BLOCO_A        : Variant  read  FREC_NRB_BLOCO_A        write FREC_NRB_BLOCO_A;
    property REC_TOTAL_BLOCO_C      : Double   read  FREC_TOTAL_BLOCO_C      write FREC_TOTAL_BLOCO_C;
    property REC_NRB_BLOCO_C        : Variant  read  FREC_NRB_BLOCO_C        write FREC_NRB_BLOCO_C;
    property REC_TOTAL_BLOCO_D      : Double   read  FREC_TOTAL_BLOCO_D      write FREC_TOTAL_BLOCO_D;
    property REC_NRB_BLOCO_D        : Variant  read  FREC_NRB_BLOCO_D        write FREC_NRB_BLOCO_D;
    property REC_TOTAL_BLOCO_F      : Double   read  FREC_TOTAL_BLOCO_F      write FREC_TOTAL_BLOCO_F;
    property REC_NRB_BLOCO_F        : Variant  read  FREC_NRB_BLOCO_F        write FREC_NRB_BLOCO_F;
    property REC_TOTAL_BLOCO_I      : Double   read  FREC_TOTAL_BLOCO_I      write FREC_TOTAL_BLOCO_I;
    property REC_NRB_BLOCO_I        : Variant  read  FREC_NRB_BLOCO_I        write FREC_NRB_BLOCO_I;
    property REC_TOTAL_BLOCO_1      : Double   read  FREC_TOTAL_BLOCO_1      write FREC_TOTAL_BLOCO_1;
    property REC_NRB_BLOCO_1        : Variant  read  FREC_NRB_BLOCO_1        write FREC_NRB_BLOCO_1;
    property REC_TOTAL_PERIODO      : Double   read  FREC_TOTAL_PERIODO      write FREC_TOTAL_PERIODO;
    property REC_TOTAL_NRB_PERIODO  : Variant  read  FREC_TOTAL_NRB_PERIODO  write FREC_TOTAL_NRB_PERIODO;
  end;

  //REGISTRO 0000: ABERTURA DO ARQUIVO DIGITAL E IDENTIFICA��O DA PESSOA JUR�DICA
  TRegistro0000 = class
  private
    FCOD_VER          : TACBrCodVer;{TACBrVersaoLeiaute;}             //C�digo da vers�o do leiaute conforme a tabela 3.1.1
    FTIPO_ESCRIT      : TACBrTipoEscrit;{TACBrTipoEscrituracao;}          //Tipo de escritura��o: 0 - Original; 1 � Retificadora;
    FIND_SIT_ESP      : TACBrIndSitEsp;{TACBrIndicadorSituacaoEspecial;} //Indicador de situa��o especial: 0 - Abertura; 1 - Cis�o; 2 - Fus�o; 3 - Incorpora��o; 4 � Encerramento;
    FNUM_REC_ANTERIOR : string;                         //N�mero do Recibo da Escritura��o anterior a ser retificada, utilizado quando TIPO_ESCRIT for igual a 1
    FDT_INI           : TDateTime;                      //Data inicial das informa��es contidas no arquivo
    FDT_FIN           : TDateTime;                      //Data final das informa��es contidas no arquivo
    FNOME             : string;                         //Nome empresarial da pessoa jur�dica
    FCNPJ             : string;                         //N�mero de inscri��o do estabelecimento matriz da pessoa jur�dica no CNPJ
    FUF               : string;                         //Sigla da Unidade da Federa��o da pessoa jur�dica
    FCOD_MUN          : integer;                        //C�digo do munic�pio do domic�lio fiscal da pessoa jur�dica, conforme a tabela IBGE
    FSUFRAMA          : string;                         //Inscri��o da pessoa jur�dica na Suframa
    FIND_NAT_PJ       : TACBrIndNatPJ;{TACBrIndicadorNaturezaPJ;}       //Indicador da natureza da pessoa jur�dica: 00 � Sociedade empres�ria em geral 01 � Sociedade cooperativa 02 � Entidade sujeita ao PIS/Pasep exclusivamente com base na Folha de Sal�rios
    FIND_ATIV         : TACBrIndAtiv;{TACBrIndicadorAtividade;}        //Indicador de tipo de atividade preponderante: 0 � Industrial ou equiparado a industrial; 1 � Prestador de servi�os; 2 - Atividade de com�rcio; 3 � Atividade financeira; 4 � Atividade imobili�ria; 9 � Outros.
  public
    property COD_VER          : TACBrCodVer{TACBrVersaoLeiaute}             read FCOD_VER          write FCOD_VER;
    property TIPO_ESCRIT      : TACBrTipoEscrit{TACBrTipoEscrituracao}          read FTIPO_ESCRIT      write FTIPO_ESCRIT;
    property IND_SIT_ESP      : TACBrIndSitEsp{TACBrIndicadorSituacaoEspecial} read FIND_SIT_ESP      write FIND_SIT_ESP;
    property NUM_REC_ANTERIOR : string                         read FNUM_REC_ANTERIOR write FNUM_REC_ANTERIOR;
    property DT_INI           : TDateTime                      read FDT_INI           write FDT_INI;
    property DT_FIN           : TDateTime                      read FDT_FIN           write FDT_FIN;
    property NOME             : string                         read FNOME             write FNOME;
    property CNPJ             : string                         read FCNPJ             write FCNPJ;
    property UF               : string                         read FUF               write FUF;
    property COD_MUN          : integer                        read FCOD_MUN          write FCOD_MUN;
    property SUFRAMA          : string                         read FSUFRAMA          write FSUFRAMA;
    property IND_NAT_PJ       : TACBrIndNatPJ{TACBrIndicadorNaturezaPJ}       read FIND_NAT_PJ       write FIND_NAT_PJ;
    property IND_ATIV         : TACBrIndAtiv{TACBrIndicadorAtividade}        read FIND_ATIV         write FIND_ATIV;
  end;

  //REGISTRO 0001: ABERTURA DO BLOCO 0
  TRegistro0001 = class(TOpenBlocos)
  private
    FRegistro0035 : TRegistro0035List ;
    FRegistro0100 : TRegistro0100List;
    FRegistro0110 : TRegistro0110;
    FRegistro0120 : TRegistro0120List;     //Implementado por F�bio Gabriel - 29/11/2012
    FRegistro0140 : TRegistro0140List;
    FRegistro0500 : TRegistro0500List;
    FRegistro0600 : TRegistro0600List;
    FRegistro0900 : TRegistro0900;
  public
    constructor Create; virtual;   // Create
    destructor  Destroy; override; // Destroy

    property Registro0035 : TRegistro0035List read FRegistro0035 write FRegistro0035;
    property Registro0100 : TRegistro0100List read FRegistro0100 write FRegistro0100;
    property Registro0110 : TRegistro0110     read FRegistro0110 write FRegistro0110;
    property Registro0120 : TRegistro0120List read FRegistro0120 write FRegistro0120;  //Implementado por F�bio Gabriel - 29/11/2012
    property Registro0140 : TRegistro0140List read FRegistro0140 write FRegistro0140;
    property Registro0500 : TRegistro0500List read FRegistro0500 write FRegistro0500;
    property Registro0600 : TRegistro0600List read FRegistro0600 write FRegistro0600;
    property Registro0900 : TRegistro0900     read FRegistro0900 write FRegistro0900;
  end;

  //REGISTRO 0035: IDENTIFICA��O DE SOCIEDADE EM CONTA DE PARTICIPA��O � SCP

  { TRegistro0035 }

  TRegistro0035 = class
  private
    FCOD_SCP : string; //Identifica��o da SCP
    FDESC_SCP: string; //Descri��o da SCP
    FINF_COMP: string; //Informa��o Complementar
  public
    property COD_SCP : string read FCOD_SCP write FCOD_SCP;
    property DESC_SCP: string  read FDESC_SCP write FDESC_SCP;
    property INF_COMP: string read FINF_COMP write FINF_COMP;
  end;

  // Registro 0035 - Lista

  { TRegistro0035List }

  TRegistro0035List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0035;
    procedure SetItem(Index: Integer; const Value: TRegistro0035);
  public
    function New: TRegistro0035;
    property Items[Index: Integer]: TRegistro0035 read GetItem write SetItem;
  end;

  //REGISTRO 0100: DADOS DO CONTABILISTA
  TRegistro0100 = class
  private
    FNOME    : string; //Nome do contabilista
    FCPF     : string; //N�mero de inscri��o do contabilista no CPF
    FCRC     : string; //N�mero de inscri��o do contabilista no Conselho Regional de Contabilidade
    FCNPJ    : string; //N�mero de inscri��o do escrit�rio de contabilidade no CNPJ, se houver
    FCEP     : string; //C�digo de Endere�amento Postal.
    FEND     : string; //Logradouro e endere�o do im�vel
    FNUM     : string; //N�mero do im�vel
    FCOMPL   : string; //Dados complementares do endere�o
    FBAIRRO  : string; //Bairro em que o im�vel est� situado
    FFONE    : string; //N�mero do telefone
    FFAX     : string; //N�mero do fax
    FEMAIL   : string; //Endere�o do correio eletr�nico
    FCOD_MUN : integer; //C�digo do munic�pio, conforme tabela IBGE
  public
    property NOME    : string read FNOME    write FNOME;
    property CPF     : string read FCPF     write FCPF;
    property CRC     : string read FCRC     write FCRC;
    property CNPJ    : string read FCNPJ    write FCNPJ;
    property CEP     : string read FCEP     write FCEP;
    property ENDERECO: string read FEND     write FEND;
    property NUM     : string read FNUM     write FNUM;
    property COMPL   : string read FCOMPL   write FCOMPL;
    property BAIRRO  : string read FBAIRRO  write FBAIRRO;
    property FONE    : string read FFONE    write FFONE;
    property FAX     : string read FFAX     write FFAX;
    property EMAIL   : string read FEMAIL   write FEMAIL;
    property COD_MUN : integer read FCOD_MUN write FCOD_MUN;
  end;

  // Registro 0100 - Lista
  TRegistro0100List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0100;
    procedure SetItem(Index: Integer; const Value: TRegistro0100);
  public
    function New: TRegistro0100;
    property Items[Index: Integer]: TRegistro0100 read GetItem write SetItem;
  end;

  //REGISTRO 0110: REGIMES DE APURA��O DA CONTRIBUI��O SOCIAL E DE APROPRIA��O DE CR�DITO
  TRegistro0110 = class
  private
    FCOD_INC_TRIB  : TACBrCodIndIncTributaria; //C�digo indicador da incid�ncia tribut�ria no per�odo: 1 � Escritura��o de opera��es com incid�ncia exclusivamente no regime n�o-cumulativo; 2 � Escritura��o de opera��es com incid�ncia exclusivamente no regime cumulativo; 3 � Escritura��o de opera��es com incid�ncia nos regimes n�o-cumulativo e cumulativo.
    FIND_APRO_CRED : TACBrIndAproCred;         //C�digo indicador de m�todo de apropria��o de cr�ditos comuns, no caso de incid�ncia no regime n�ocumulativo (COD_INC_TRIB = 1 ou 3): 1 � M�todo de Apropria��o Direta; 2 � M�todo de Rateio Proporcional (Receita Bruta)
    FCOD_TIPO_CONT : TACBrCodIndTipoCon;       //C�digo indicador do Tipo de Contribui��o Apurada no Per�odo: 1 � Apura��o da Contribui��o Exclusivamente a Al�quota B�sica; 2 � Apura��o da Contribui��o a Al�quotas Espec�ficas (Diferenciadas e/ou por Unidade de Medida de Produto)
    FIND_REG_CUM   : TACBrCodIndCritEscrit;

    FRegistro0111: TRegistro0111;
  public
    constructor Create(); virtual; /// Create
    destructor  Destroy; override; // Destroy

    property COD_INC_TRIB  : TACBrCodIndIncTributaria read FCOD_INC_TRIB  write FCOD_INC_TRIB;
    property IND_APRO_CRED : TACBrIndAproCred         read FIND_APRO_CRED write FIND_APRO_CRED;
    property COD_TIPO_CONT : TACBrCodIndTipoCon       read FCOD_TIPO_CONT write FCOD_TIPO_CONT;
    property IND_REG_CUM   : TACBrCodIndCritEscrit    read FIND_REG_CUM   write FIND_REG_CUM;
    property Registro0111: TRegistro0111 read FRegistro0111 write FRegistro0111;
  end;

  //REGISTRO 0111: DE RECEITA BRUTA MENSAL PARA FINS DE RATEIO DE CR�DITOS COMUNS
  TRegistro0111 = class
  private
    FREC_BRU_NCUM_TRIB_MI : currency; //Receita Bruta N�o-Cumulativa - Tributada no Mercado Interno
    FREC_BRU_NCUM_NT_MI   : currency; //Receita Bruta N�o-Cumulativa � N�o Tributada no Mercado Interno (Vendas com suspens�o, al�quota zero, isen��o e sem incid�ncia das contribui��es)
    FREC_BRU_NCUM_EXP     : currency; //Receita Bruta N�o-Cumulativa � Exporta��o
    FREC_BRU_CUM          : currency; //Receita Bruta Cumulativa
    FREC_BRU_TOTAL        : currency; //Receita Bruta Total
  public
    property REC_BRU_NCUM_TRIB_MI : currency read FREC_BRU_NCUM_TRIB_MI write FREC_BRU_NCUM_TRIB_MI;
    property REC_BRU_NCUM_NT_MI   : currency read FREC_BRU_NCUM_NT_MI   write FREC_BRU_NCUM_NT_MI;
    property REC_BRU_NCUM_EXP     : currency read FREC_BRU_NCUM_EXP     write FREC_BRU_NCUM_EXP;
    property REC_BRU_CUM          : currency read FREC_BRU_CUM          write FREC_BRU_CUM;
    property REC_BRU_TOTAL        : currency read FREC_BRU_TOTAL        write FREC_BRU_TOTAL;
  end;

  //Implementado por F�bio Gabriel - 29/11/2012
  //REGISTRO 0120: IDENTIFICA��O DE PER�ODOS DISPENSADOS
  TRegistro0120 = class
  private
    FMES_DISPENSA   : string; //M�s de refer�ncia do ano-calend�rio da escritura��o, dispensada da entrega. Formato MMAAAA
    FINF_COMP       : string; //Informa��o complementar do registro.
  public
    property MES_DISPENSA : string read FMES_DISPENSA write FMES_DISPENSA;
    property INF_COMP     : string read FINF_COMP     write FINF_COMP;
  end;

  // Registro 0120 - Lista
  TRegistro0120List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0120;
    procedure SetItem(Index: Integer; const Value: TRegistro0120);
  public
    function New: TRegistro0120;
    property Items[Index: Integer]: TRegistro0120 read GetItem write SetItem;
  end;

  //REGISTRO 0140: TABELA DE CADASTRO DE ESTABELECIMENTO
  TRegistro0140 = class
  private
    FCOD_EST : string;  // C�digo de identifica��o do estabelecimento
    FNOME    : string;  // Nome empresarial do estabelecimento
    FCNPJ    : string;  // N�mero de inscri��o do estabelecimento no CNPJ
    FUF      : string;  // Sigla da unidade da federa��o do estabelecimento
    FIE      : string;  // Inscri��o Estadual do estabelecimento, se contribuinte de ICMS
    FCOD_MUN : integer; // C�digo do munic�pio do domic�lio fiscal do estabelecimento,conforme a tabela IBGE
    FIM      : string;  // Inscri��o Municipal do estabelecimento, se contribuinte do ISS
    FSUFRAMA : string;  // Inscri��o do estabelecimento na Suframa

    FRegistro0145 : TRegistro0145;
    FRegistro0150 : TRegistro0150List;
    FRegistro0190 : TRegistro0190List;
    FRegistro0200 : TRegistro0200List;
    FRegistro0400 : TRegistro0400List;
    FRegistro0450 : TRegistro0450List;
  public
    constructor Create(); virtual; /// Create
    destructor  Destroy; override; // Destroy

    property COD_EST      : string            read FCOD_EST      write FCOD_EST;
    property NOME         : string            read FNOME         write FNOME;
    property CNPJ         : string            read FCNPJ         write FCNPJ;
    property UF           : string            read FUF           write FUF;
    property IE           : string            read FIE           write FIE;
    property COD_MUN      : Integer           read FCOD_MUN      write FCOD_MUN;
    property IM           : string            read FIM           write FIM;
    property SUFRAMA      : string            read FSUFRAMA      write FSUFRAMA;

    property Registro0145 : TRegistro0145     read FRegistro0145 write FRegistro0145;
    property Registro0150 : TRegistro0150List read FRegistro0150 write FRegistro0150;
    property Registro0190 : TRegistro0190List read FRegistro0190 write FRegistro0190;
    property Registro0200 : TRegistro0200List read FRegistro0200 write FRegistro0200;
    property Registro0400 : TRegistro0400List read FRegistro0400 write FRegistro0400;
    property Registro0450 : TRegistro0450List read FRegistro0450 write FRegistro0450;
  end;

  // Registro 0140 - Lista
  TRegistro0140List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0140;
    procedure SetItem(Index: Integer; const Value: TRegistro0140);
  public
    function New(): TRegistro0140;
    property Items[Index: Integer]: TRegistro0140 read GetItem write SetItem;
  end;

  //REGISTRO 0145: REGIME DE APURA��O DA CONTRIBUI��O PREVIDENCI�RIA SOBRE A RECEITA BRUTA
  TRegistro0145 = class
  private
    FCOD_INC_TRIB       : string;   //C�digo indicador da incid�ncia tribut�ria no per�odo:
    FVL_REC_TOT         : currency; //Valor da Receita Bruta Total da Pessoa Jur�dica no Per�odo
    FVL_REC_ATIV        : currency; //Valor da Receita Bruta da(s) Atividade(s) Sujeita(s) � Contribui��o Previdenci�ria sobre a Receita Bruta
    FVL_REC_DEMAIS_ATIV : currency; //Valor da Receita Bruta da(s) Atividade(s) Sujeita(s) � Contribui��o Previdenci�ria sobre a Remunera��o
    FINFO_COMPL         : string  ; //Informa��o complementar
  public
    property COD_INC_TRIB       : string   read FCOD_INC_TRIB        write FCOD_INC_TRIB;
    property VL_REC_TOT         : currency read FVL_REC_TOT          write FVL_REC_TOT;
    property VL_REC_ATIV        : currency read FVL_REC_ATIV         write FVL_REC_ATIV;
    property VL_REC_DEMAIS_ATIV : currency read FVL_REC_DEMAIS_ATIV  write FVL_REC_DEMAIS_ATIV;
    property INFO_COMPL         : string   read FINFO_COMPL          write FINFO_COMPL;
  end;

  //REGISTRO 0150: TABELA DE CADASTRO DO PARTICIPANTE
  TRegistro0150 = class
  private
    FCOD_PART : string;  // C�digo de identifica��o do participante no arquivo
    FNOME     : string;  // Nome pessoal ou empresarial do participante
    FCOD_PAIS : string;  // C�digo do pa�s do participante, conforme a tabela indicada no item 3.2.1
    FCNPJ     : string;  // CNPJ do participante
    FCPF      : string;  // CPF do participante
    FIE       : string;  // Inscri��o Estadual do participante
    FCOD_MUN  : integer; // C�digo do munic�pio, conforme a tabela IBGE
    FSUFRAMA  : string;  // N�mero de inscri��o do participante na Suframa
    FEND      : string;  // Logradouro e endere�o do im�vel
    FNUM      : string;  // N�mero do im�vel
    FCOMPL    : string;  // Dados complementares do endere�o
    FBAIRRO   : string;  // Bairro em que o im�vel est� situado
  public
    property COD_PART : string read FCOD_PART write FCOD_PART;
    property NOME     : string read FNOME     write FNOME;
    property COD_PAIS : string read FCOD_PAIS write FCOD_PAIS;
    property CNPJ     : string read FCNPJ     write FCNPJ;
    property CPF      : string read FCPF      write FCPF;
    property IE       : string read FIE       write FIE;
    property COD_MUN  : integer read FCOD_MUN  write FCOD_MUN;
    property SUFRAMA  : string read FSUFRAMA  write FSUFRAMA;
    property ENDERECO : string read FEND      write FEND;
    property NUM      : string read FNUM      write FNUM;
    property COMPL    : string read FCOMPL    write FCOMPL;
    property BAIRRO   : string read FBAIRRO   write FBAIRRO;
  end;

  // Registro 0150 - Lista
  TRegistro0150List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0150;
    procedure SetItem(Index: Integer; const Value: TRegistro0150);
  public
    function New: TRegistro0150;
    function LocalizaRegistro(const Value: String): boolean;
    property Items[Index: Integer]: TRegistro0150 read GetItem write SetItem;
  end;

  //REGISTRO 0190: IDENTIFICA��O DAS UNIDADES DE MEDIDA
  TRegistro0190 = class
  private
    FUNID  : string; //C�digo da unidade de medida
    FDESCR : string; //Descri��o da unidade de medida
  public
    property UNID  : string read FUNID  write FUNID;
    property DESCR : string read FDESCR write FDESCR;
  end;

  // Registro 0190 - Lista
  TRegistro0190List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0190;
    procedure SetItem(Index: Integer; const Value: TRegistro0190);
  public
    function New: TRegistro0190;
    function LocalizaRegistro(const pUNID: String): boolean;
    property Items[Index: Integer]: TRegistro0190 read GetItem write SetItem;
  end;

  //REGISTRO 0200: TABELA DE IDENTIFICA��O DO ITEM (PRODUTOS E SERVI�OS)
  TRegistro0200 = class
  private
    FCOD_ITEM     : string;        //C�digo do item
    FDESCR_ITEM   : string;        // Descri��o do item
    FCOD_BARRA    : string;        //Representa��o alfanum�rico do c�digo de barra do produto, se houver
    FCOD_ANT_ITEM : string;        //C�digo anterior do item com rela��o � �ltima informa��o apresentada
    FUNID_INV     : string;        //Unidade de medida utilizada na quantifica��o de estoques
    FTIPO_ITEM    : TACBrTipoItem; //Tipo do item � Atividades Industriais, Comerciais e Servi�os: 00 � Mercadoria para Revenda; 01 � Mat�ria-Prima; 02 � Embalagem; 03 � Produto em Processo; 04 � Produto Acabado; 05 � Subproduto; 06 � Produto Intermedi�rio; 07 � Material de Uso e Consumo; 08 � Ativo Imobilizado; 09 � Servi�os; 10 � Outros insumos; 99 � Outras
    FCOD_NCM      : string;        //C�digo da Nomenclatura Comum do Mercosul
    FEX_IPI       : string;        //C�digo EX, conforme a TIPI
    FCOD_GEN      : string;        //C�digo do g�nero do item, conforme a Tabela 4.2.1.
    FCOD_LST      : string;        //C�digo do servi�o conforme lista do Anexo I da Lei Complementar Federal n� 116/03
    FALIQ_ICMS    : variant;      //Al�quota de ICMS aplic�vel ao item nas opera��es internas

    FRegistro0205 : TRegistro0205List;
    FRegistro0206 : TRegistro0206;
    FRegistro0208 : TRegistro0208;
  public
    constructor Create(); virtual;   // Create
    destructor  Destroy; override; // Destroy

    property COD_ITEM     : string            read FCOD_ITEM     write FCOD_ITEM;
    property DESCR_ITEM   : string            read FDESCR_ITEM   write FDESCR_ITEM;
    property COD_BARRA    : string            read FCOD_BARRA    write FCOD_BARRA;
    property COD_ANT_ITEM : string            read FCOD_ANT_ITEM write FCOD_ANT_ITEM;
    property UNID_INV     : string            read FUNID_INV     write FUNID_INV;
    property TIPO_ITEM    : TACBrTipoItem     read FTIPO_ITEM    write FTIPO_ITEM;
    property COD_NCM      : string            read FCOD_NCM      write FCOD_NCM;
    property EX_IPI       : string            read FEX_IPI       write FEX_IPI;
    property COD_GEN      : string            read FCOD_GEN      write FCOD_GEN;
    property COD_LST      : string            read FCOD_LST      write FCOD_LST;
    property ALIQ_ICMS    : variant           read FALIQ_ICMS    write FALIQ_ICMS;

    property Registro0205 : TRegistro0205List read FRegistro0205 write FRegistro0205;
    property Registro0206 : TRegistro0206     read FRegistro0206 write FRegistro0206;
    property Registro0208 : TRegistro0208     read FRegistro0208 write FRegistro0208;
  end;

  // Registro 0200 - Lista
  TRegistro0200List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0200;
    procedure SetItem(Index: Integer; const Value: TRegistro0200);
  public
    function New(): TRegistro0200;
    function LocalizaRegistro(const pCOD_ITEM: String): boolean;
    property Items[Index: Integer]: TRegistro0200 read GetItem write SetItem;
  end;

  //REGISTRO 0205: ALTERA��O DO ITEM
  TRegistro0205 = class
  private
    FDESCR_ANT_ITEM : string;    //Descri��o anterior do item
    FDT_INI         : TDateTime; //Data inicial de utiliza��o da descri��o do item
    FDT_FIM         : TDateTime; //Data final de utiliza��o da descri��o do item
    FCOD_ANT_ITEM   : string;    //C�digo anterior do item com rela��o � �ltima informa��o apresentada
  public
    property DESCR_ANT_ITEM : string    read FDESCR_ANT_ITEM write FDESCR_ANT_ITEM;
    property DT_INI         : TDateTime read FDT_INI         write FDT_INI;
    property DT_FIM         : TDateTime read FDT_FIM         write FDT_FIM;
    property COD_ANT_ITEM   : string    read FCOD_ANT_ITEM   write FCOD_ANT_ITEM;
  end;

  // Registro 0205 - Lista
  TRegistro0205List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0205;
    procedure SetItem(Index: Integer; const Value: TRegistro0205);
  public
    function New: TRegistro0205;
    property Items[Index: Integer]: TRegistro0205 read GetItem write SetItem;
  end;

  // REGISTRO 0206: C�DIGO DE PRODUTO CONFORME TABELA ANP (COMBUST�VEIS)
  TRegistro0206 = class
  private
    FCOD_COMB : string; //C�digo do combust�vel, conforme tabela publicada pela ANP
  public
    property COD_COMB: string read FCOD_COMB write FCOD_COMB;
  end;

  // REGISTRO 0208: C�DIGO DE GRUPOS POR MARCA COMERCIAL - REFRI (BEBIDAS FRIAS).
  TRegistro0208 = class
  private
    FCOD_TAB   : TACBrIndCodIncidencia; //C�digo indicador da Tabela de Incid�ncia, conforme Anexo III do Decreto n� 6.707/08: 01 � Tabela I; 02 � Tabela II; 03 � Tabela III; 04 � Tabela IV; 05 � Tabela V; 06 � Tabela VI; 07 � Tabela VII; 08� Tabela VIII; 09 � Tabela IX; 10 � Tabela X; 11 � Tabela XI; 12 � Tabela XII;
    FCOD_GRU   : string;                //C�digo do grupo, conforme Anexo III do Decreto n� 6.707/08
    FMARCA_COM : string;                //Marca Comercial
  public
    constructor Create(); virtual;   // Create
    destructor  Destroy; override; // Destroy

    property COD_TAB   : TACBrIndCodIncidencia read FCOD_TAB   write FCOD_TAB;
    property COD_GRU   : string                read FCOD_GRU   write FCOD_GRU;
    property MARCA_COM : string                read FMARCA_COM write FMARCA_COM;
  end;

  //REGISTRO 0400: TABELA DE NATUREZA DA OPERA��O/PRESTA��O
  TRegistro0400 = class
  private
    FCOD_NAT   : string; //C�digo da natureza da opera��o/presta��o
    FDESCR_NAT : string; //Descri��o da natureza da opera��o/presta��o
  public
    property COD_NAT   : string read FCOD_NAT   write FCOD_NAT;
    property DESCR_NAT : string read FDESCR_NAT write FDESCR_NAT;
  end;

  // Registro 0400 - Lista
  TRegistro0400List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0400;
    procedure SetItem(Index: Integer; const Value: TRegistro0400);
  public
    function New: TRegistro0400;
    function LocalizaRegistro(const pCOD_NAT: String): boolean;
    property Items[Index: Integer]: TRegistro0400 read GetItem write SetItem;
  end;

  //REGISTRO 0450: TABELA DE INFORMA��O COMPLEMENTAR DO DOCUMENTO FISCAL
  TRegistro0450 = class
  private
    FCOD_INF : string; //C�digo da informa��o complementar do documento fiscal.
    FTXT     : string; //Texto livre da informa��o complementar existente no documento fiscal, inclusive esp�cie de normas legais, poder normativo, n�mero, capitula��o, data e demais refer�ncias pertinentes com indica��o referentes ao tributo
  public
    property COD_INF : string read FCOD_INF write FCOD_INF;
    property TXT     : string read FTXT     write FTXT;
  end;

  // Registro 0450 - Lista
  TRegistro0450List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0450;
    procedure SetItem(Index: Integer; const Value: TRegistro0450);
  public
    function New: TRegistro0450;
    property Items[Index: Integer]: TRegistro0450 read GetItem write SetItem;
  end;

  //REGISTRO 0500: PLANO DE CONTAS CONT�BEIS
  TRegistro0500 = class
  private
    FDT_ALT      : TDateTime;            //Data da inclus�o/altera��o
    FCOD_NAT_CC  : TACBrNaturezaConta;   //C�digo da natureza da conta/grupo de contas: 01 - Contas de ativo; 02 - Contas de passivo; 03 - Patrim�nio l�quido; 04 - Contas de resultado; 05 - Contas de compensa��o; 09 - Outras
    FIND_CTA     : TACBrIndCTA;          //Indicador do tipo de conta: S - Sint�tica (grupo de contas); A - Anal�tica (conta)
    FNIVEL       : string;               //N�vel da conta anal�tica/grupo de contas
    FCOD_CTA     : string;               //C�digo da conta anal�tica/grupo de contas
    FNOME_CTA    : string;               //Nome da conta anal�tica/grupo de contas
    FCOD_CTA_REF : string;               //C�digo da conta correlacionada no Plano de Contas Referenciado, publicado pela RFB
    FCNPJ_EST    : string;               //CNPJ do estabelecimento, no caso da conta informada no campo COD_CTA ser espec�fica de um estabelecimento
  public
    property DT_ALT      : TDateTime          read FDT_ALT      write FDT_ALT;
    property COD_NAT_CC  : TACBrNaturezaConta read FCOD_NAT_CC  write FCOD_NAT_CC;
    property IND_CTA     : TACBrIndCTA        read FIND_CTA     write FIND_CTA ;
    property NIVEL       : string             read FNIVEL       write FNIVEL;
    property COD_CTA     : string             read FCOD_CTA     write FCOD_CTA ;
    property NOME_CTA    : string             read FNOME_CTA    write FNOME_CTA ;
    property COD_CTA_REF : string             read FCOD_CTA_REF write FCOD_CTA_REF;
    property CNPJ_EST    : string             read FCNPJ_EST    write FCNPJ_EST;
  end;

  // Registro 0500 - Lista
  TRegistro0500List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0500;
    procedure SetItem(Index: Integer; const Value: TRegistro0500);
  public
    function New: TRegistro0500;
    property Items[Index: Integer]: TRegistro0500 read GetItem write SetItem;
    function LocalizaRegistro(const ACOD_CTA : string) : Boolean;
  end;

  //REGISTRO 0600: CENTRO DE CUSTOS
  TRegistro0600 = class
  private
    FDT_ALT   : TDateTime; //Data da inclus�o/altera��o
    FCOD_CCUS : string;    //C�digo do centro de custos
    FCCUS     : string;    //Nome do centro de custos.
  public
    property DT_ALT   : TDateTime read FDT_ALT   write FDT_ALT ;
    property COD_CCUS : string    read FCOD_CCUS write FCOD_CCUS ;
    property CCUS     : string    read FCCUS     write FCCUS;
  end;

  // Registro 0600 - Lista
  TRegistro0600List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0600;
    procedure SetItem(Index: Integer; const Value: TRegistro0600);
  public
    function New: TRegistro0600;
    property Items[Index: Integer]: TRegistro0600 read GetItem write SetItem;
  end;

  //REGISTRO 0990: ENCERRAMENTO DO BLOCO 0
  TRegistro0990 = class
  private
    FQTD_LIN_0: integer; //Quantidade total de linhas do Bloco 0
  public
    property QTD_LIN_0: integer read FQTD_LIN_0 write FQTD_LIN_0;
  end;

implementation

{ TRegistro0035List }

function TRegistro0035List.GetItem(Index: Integer): TRegistro0035;
begin
  Result := TRegistro0035(Inherited Items[Index]);
end;

procedure TRegistro0035List.SetItem(Index: Integer; const Value: TRegistro0035);
begin
  Put(Index, Value);
end;

function TRegistro0035List.New: TRegistro0035;
begin
  Result := TRegistro0035.Create;
  Add(Result);
end;

{ TRegistro0001 }

constructor TRegistro0001.Create;
begin
  inherited Create;
  FRegistro0035 := TRegistro0035List.Create;
  FRegistro0110 := TRegistro0110.Create();
  FRegistro0100 := TRegistro0100List.Create;
  FRegistro0120 := TRegistro0120List.Create;    //Implementado por F�bio Gabriel - 29/11/2012
  FRegistro0140 := TRegistro0140List.Create;
  FRegistro0500 := TRegistro0500List.Create;
  FRegistro0600 := TRegistro0600List.Create;
end;

destructor TRegistro0001.Destroy;
begin
  FRegistro0035.Free;
  FRegistro0100.Free;
  FRegistro0110.Free;
  FRegistro0120.Free;  //Implementado por F�bio Gabriel - 29/11/2012
  FRegistro0140.Free;
  FRegistro0500.Free;
  FRegistro0600.Free;
  FRegistro0900.Free;	
  inherited;
end;

{ TRegistro0100List }

function TRegistro0100List.GetItem(Index: Integer): TRegistro0100;
begin
  Result := TRegistro0100(Inherited Items[Index]);
end;

function TRegistro0100List.New: TRegistro0100;
begin
  Result := TRegistro0100.Create;
  Add(Result);
end;

procedure TRegistro0100List.SetItem(Index: Integer; const Value: TRegistro0100);
begin
  Put(Index, Value);
end;

{ TRegistro0120List }

function TRegistro0120List.GetItem(Index: Integer): TRegistro0120;
begin
  Result := TRegistro0120(Inherited Items[Index]);
end;

function TRegistro0120List.New: TRegistro0120;
begin
  Result := TRegistro0120.Create;
  Add(Result);
end;

procedure TRegistro0120List.SetItem(Index: Integer; const Value: TRegistro0120);
begin
  Put(Index, Value);
end;

{TRegistro0140}

function TRegistro0140List.GetItem(Index: Integer): TRegistro0140;
begin
  Result := TRegistro0140(Inherited Items[Index]);
end;

function TRegistro0140List.New(): TRegistro0140;
begin
  Result := TRegistro0140.Create();
  Add(Result);
end;

procedure TRegistro0140List.SetItem(Index: Integer; const Value: TRegistro0140);
begin
  Put(Index, Value);
end;

{ TRegistro0140 }

constructor TRegistro0140.Create();
begin
  inherited Create;
  FRegistro0145 := TRegistro0145.Create;
  FRegistro0150 := TRegistro0150List.Create;
  FRegistro0190 := TRegistro0190List.Create;
  FRegistro0200 := TRegistro0200List.Create;
  FRegistro0400 := TRegistro0400List.Create;
  FRegistro0450 := TRegistro0450List.Create;
end;

destructor TRegistro0140.Destroy;
begin
  FRegistro0145.Free;
  FRegistro0150.Free;
  FRegistro0190.Free;
  FRegistro0200.Free;
  FRegistro0400.Free;
  FRegistro0450.Free;
  inherited;
end;

{TRegistro0150}

function TRegistro0150List.GetItem(Index: Integer): TRegistro0150;
begin
  Result := TRegistro0150(Inherited Items[Index]);
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

function TRegistro0150List.New: TRegistro0150;
begin
  Result := TRegistro0150.Create;
  Add(Result);
end;

procedure TRegistro0150List.SetItem(Index: Integer; const Value: TRegistro0150);
begin
  Put(Index, Value);
end;

{TRegistro0190}

function TRegistro0190List.GetItem(Index: Integer): TRegistro0190;
begin
  Result := TRegistro0190(Inherited Items[Index]);
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

{TRegistro0200}

function TRegistro0200List.GetItem(Index: Integer): TRegistro0200;
begin
  Result := TRegistro0200(Inherited Items[Index]);
end;

function TRegistro0200List.New(): TRegistro0200;
begin
  Result := TRegistro0200.Create();
  Add(Result);
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

procedure TRegistro0200List.SetItem(Index: Integer; const Value: TRegistro0200);
begin
  Put(Index, Value);
end;

{ TRegistro0200 }

constructor TRegistro0200.Create();
begin
  inherited Create;
  FRegistro0205 := TRegistro0205List.Create;
  FRegistro0206 := TRegistro0206.Create;
  FRegistro0208 := TRegistro0208.Create;
end;

destructor TRegistro0200.Destroy;
begin
  FRegistro0205.Free;
  FRegistro0206.Free;
  FRegistro0208.Free;
  inherited;
end;

{TRegistro0205}

function TRegistro0205List.GetItem(Index: Integer): TRegistro0205;
begin
  Result := TRegistro0205(Inherited Items[Index]);
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

{TRegistro0400}

function TRegistro0400List.GetItem(Index: Integer): TRegistro0400;
begin
  Result := TRegistro0400(Inherited Items[Index]);
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

{TRegistro0450}

function TRegistro0450List.GetItem(Index: Integer): TRegistro0450;
begin
  Result := TRegistro0450(Inherited Items[Index]);
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

{TRegistro0500}

function TRegistro0500List.GetItem(Index: Integer): TRegistro0500;
begin
  Result := TRegistro0500(Inherited Items[Index]);
end;

function TRegistro0500List.LocalizaRegistro(const ACOD_CTA: string): Boolean;
var
  I: integer;
begin
  for I := 0 to Pred(Count) do
    if Items[I].COD_CTA = ACOD_CTA then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
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

{TRegistro0600}

function TRegistro0600List.GetItem(Index: Integer): TRegistro0600;
begin
  Result := TRegistro0600(Inherited Items[Index]);
end;

function TRegistro0600List.New: TRegistro0600;
begin
  Result := TRegistro0600.Create;
  Add(Result);
end;

procedure TRegistro0600List.SetItem(Index: Integer; const Value: TRegistro0600);
begin
  Put(Index, Value);
end;

{ TRegistro0110 }

constructor TRegistro0110.Create();
begin
  inherited Create;
  FRegistro0111 := TRegistro0111.Create;
end;

destructor TRegistro0110.Destroy;
begin
  FRegistro0111.Free;
  inherited;
end;

{ TRegistro0208 }

constructor TRegistro0208.Create();
begin
   inherited Create;
   FCOD_TAB := codIndiTabNaoTem;
end;

destructor TRegistro0208.Destroy;
begin

  inherited;
end;

end.
