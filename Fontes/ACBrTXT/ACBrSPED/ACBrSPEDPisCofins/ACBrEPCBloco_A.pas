{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro e Claudio Roberto de Souza e    }
{                              Alessandro Yamasaki                             }
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
|* 12/12/2010: Isaque Pinheiro e Claudio Roberto de Souza
|*  - Cria��o e distribui��o da Primeira Versao
|* 10/01/2011: Alessandro Yamasaki
|*  - Adicionado TACBrOrigemProcesso no REGISTRO A111: PROCESSO REFERENCIADO
|*  - Criado Tipo Local da execu��o do servi�o para o Registro A120
|*  - Adicionado TACBrOrigemCredito no REGISTRO A170: COMPLEMENTO DO DOCUMENTO - ITENS DO DOCUMENTO
*******************************************************************************}

// Documentos Fiscais - Servi�os (ISS)

unit ACBrEPCBloco_A;

{$I ACBr.inc}

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrEPCBlocos;

type
  TRegistroA010List = class;
  TRegistroA100List = class;
  TRegistroA110List = class;
  TRegistroA111List = class;
  TRegistroA120List = class;
  TRegistroA170List = class;

  // REGISTRO A001: ABERTURA DO BLOCO A

  TRegistroA001 = class(TOpenBlocos)
  private
    FRegistroA010: TRegistroA010List;
  public
    constructor Create;  virtual;   /// Create
    destructor  Destroy; override;  /// Destroy

    property RegistroA010: TRegistroA010List read FRegistroA010 write FRegistroA010;
  end;

  // REGISTRO A010: IDENTIFICA��O DO ESTABELECIMENTO
  TRegistroA010 = class
  private
    fCNPJ         : string; //02	N�mero de inscri��o do estabelecimento no CNPJ.	N	014*	-

    FRegistroA100 : TRegistroA100List;
  public
    constructor Create;  virtual;  /// Create
    destructor  Destroy; override; /// Destroy

    property RegistroA100 : TRegistroA100List read FRegistroA100 write FRegistroA100;
    property CNPJ         : string            read FCNPJ         write FCNPJ;
  end;

  /// Registro A010 - Lista

  TRegistroA010List = class(TObjectList)
  private
    function  GetItem(Index: Integer): TRegistroA010;
    procedure SetItem(Index: Integer; const Value: TRegistroA010);
  public
    function New: TRegistroA010;
    property Items[Index: Integer]: TRegistroA010 read GetItem write SetItem;
  end;

  // REGISTRO A100: DOCUMENTO - NOTA FISCAL DE SERVI�O

  TRegistroA100 = class
  private
    fIND_OPER      : TACBrIndOper;               //02	Indicador do tipo de opera��o: 0 - Servi�o Contratado pelo Estabelecimento; 1 - Servi�o Prestado pelo Estabelecimento.	C	001*
    fIND_EMIT      : TACBrIndEmit;               //03	Indicador do emitente do documento fiscal: 0 - Emiss�o pr�pria; 1 - Emiss�o de Terceiros	C	001*
    fCOD_PART      : string;                     //04	C�digo do participante (campo 02 do Registro 0150):- do emitente do documento, no caso de emiss�o de terceiros;- do adquirente, no caso de servi�os prestados.	C	060
    fCOD_SIT       : TACBrCodSit;                //05	C�digo da situa��o do documento fiscal:00 � Documento regular 02 � Documento cancelado	N	002*
    fSER           : string;                     //06	S�rie do documento fiscal	C	020
    fSUB           : string;                     //07	Subs�rie do documento fiscal	C	020
    fNUM_DOC       : string;                     //08	N�mero do documento fiscal ou documento internacional equivalente	C	060
    fCHV_NFSE      : string;                     //09	Chave/C�digo de Verifica��o da nota fiscal de servi�o eletr�nica	C	060
    fDT_DOC        : TDateTime;                  //10	Data da emiss�o do documento fiscal	N	008*
    fDT_EXE_SERV   : TDateTime;                  //11	Data de Execu��o / Conclus�o do Servi�o	N	008*
    fVL_DOC        : Variant;                    //12	Valor total do documento	N	-	02
    fIND_PGTO      : TACBrIndPgto;               //13	Indicador do tipo de pagamento:0- � vista;1- A prazo;9- Sem pagamento.	C	001*	-
    fVL_DESC       : Variant;                    //14	Valor total do desconto	N	-	02
    fVL_BC_PIS     : Variant;                    //15	Valor da base de c�lculo do PIS/PASEP	N	-	02
    fVL_PIS        : Variant;                    //16	Valor total do PIS	N	-	02
    fVL_BC_COFINS  : Variant;                    //17	Valor da base de c�lculo da COFINS	N	-	02
    fVL_COFINS     : Variant;                    //18	Valor total da COFINS	N	-	02
    fVL_PIS_RET    : Variant;                    //19	Valor total do PIS retido na fonte	N	-	02
    fVL_COFINS_RET : Variant;                    //20	Valor total da COFINS retido na fonte.	N	-	02
    fVL_ISS        : Variant;                    //21	Valor do ISS	N	-	02

    FRegistroA110: TRegistroA110List;
    FRegistroA111: TRegistroA111List;
    FRegistroA120: TRegistroA120List;
    FRegistroA170: TRegistroA170List;
  public
    constructor Create;  virtual;  /// Create
    destructor  Destroy; override; /// Destroy

    property IND_OPER      : TACBrIndOper read FIND_OPER      write FIND_OPER;
    property IND_EMIT      : TACBrIndEmit read FIND_EMIT      write FIND_EMIT;
    property COD_PART      : string       read FCOD_PART      write FCOD_PART;
    property COD_SIT       : TACBrCodSit  read FCOD_SIT       write FCOD_SIT;
    property SER           : string       read FSER           write FSER;
    property SUB           : string       read FSUB           write FSUB;
    property NUM_DOC       : string       read FNUM_DOC       write FNUM_DOC;
    property CHV_NFSE      : string       read FCHV_NFSE      write FCHV_NFSE;
    property DT_DOC        : TDateTime    read FDT_DOC        write FDT_DOC;
    property DT_EXE_SERV   : TDateTime    read FDT_EXE_SERV   write FDT_EXE_SERV;
    property VL_DOC        : Variant      read FVL_DOC        write FVL_DOC;
    property IND_PGTO      : TACBrIndPgto read FIND_PGTO      write FIND_PGTO;
    property VL_DESC       : Variant      read FVL_DESC       write FVL_DESC;
    property VL_BC_PIS     : Variant      read FVL_BC_PIS     write FVL_BC_PIS;
    property VL_PIS        : Variant      read FVL_PIS        write FVL_PIS;
    property VL_BC_COFINS  : Variant      read FVL_BC_COFINS  write FVL_BC_COFINS;
    property VL_COFINS     : Variant      read FVL_COFINS     write FVL_COFINS;
    property VL_PIS_RET    : Variant      read FVL_PIS_RET    write FVL_PIS_RET;
    property VL_COFINS_RET : Variant      read FVL_COFINS_RET write FVL_COFINS_RET;
    property VL_ISS        : Variant      read FVL_ISS        write FVL_ISS;

    property RegistroA110  : TRegistroA110List read FRegistroA110  write FRegistroA110;
    property RegistroA111  : TRegistroA111List read FRegistroA111  write FRegistroA111;
    property RegistroA120  : TRegistroA120List read FRegistroA120  write FRegistroA120;
    property RegistroA170  : TRegistroA170List read FRegistroA170  write FRegistroA170;
  end;

  /// Registro A100 - Lista

  TRegistroA100List = class(TObjectList)
  private
    function  GetItem(Index: Integer): TRegistroA100;
    procedure SetItem(Index: Integer; const Value: TRegistroA100);
  public
    function New: TRegistroA100;
    property Items[Index: Integer]: TRegistroA100 read GetItem write SetItem;
  end;

  // REGISTRO A110: COMPLEMENTO DO DOCUMENTO - INFORMA��O COMPLEMENTAR DA NF

  TRegistroA110 = class
  private
    fCOD_INF   : String;    //02	C�digo da informa��o complementar do documento fiscal (Campo 02 do Registro 0450)	C	006
    fTXT_COMPL : String;    //03	Informa��o Complementar do Documento Fiscal	C	-
  public
    property COD_INF   : String read FCOD_INF   write FCOD_INF;
    property TXT_COMPL : String read FTXT_COMPL write FTXT_COMPL;
  end;

  /// Registro A110 - Lista

  TRegistroA110List = class(TObjectList)
  private
    function  GetItem(Index: Integer): TRegistroA110;
    procedure SetItem(Index: Integer; const Value: TRegistroA110);
  public
    function New: TRegistroA110;
    property Items[Index: Integer]: TRegistroA110 read GetItem write SetItem;
  end;

  // REGISTRO A111: PROCESSO REFERENCIADO
  TRegistroA111 = class
  private
    fNUM_PROC: String;                //02	Identifica��o do processo ou ato concess�rio	C	020
    fIND_PROC: TACBrOrigemProcesso;	  //03	Indicador da origem do processo: 1 - Justi�a Federal; 3 � Secretaria da Receita Federal do Brasil; 9 - Outros.	C	001*
  public
    property NUM_PROC : string              read FNUM_PROC write FNUM_PROC;
    property IND_PROC : TACBrOrigemProcesso read FIND_PROC write FIND_PROC;
  end;

  /// Registro A111 - Lista

  TRegistroA111List = class(TObjectList)
  private
    function  GetItem(Index: Integer): TRegistroA111;
    procedure SetItem(Index: Integer; const Value: TRegistroA111);
  public
    function New: TRegistroA111;
    property Items[Index: Integer]: TRegistroA111 read GetItem write SetItem;
  end;

  // REGISTRO A120: INFORMA��O COMPLEMENTAR - OPERA��ES DE IMPORTA��O

  TRegistroA120 = class
  private
    fVL_TOT_SERV   : Variant;               //02	Valor total do servi�o, prestado por pessoa f�sica ou jur�dica domiciliada no exterior.	N	-	02
    fVL_BC_PIS     : Variant;               //03	Valor da base de c�lculo da Opera��o � PIS/PASEP � Importa��o	N	-	02
    fVL_PIS_IMP    : Variant;               //04	Valor pago/recolhido de PIS/PASEP � Importa��o	N	-	02
    fDT_PAG_PIS    : TDateTime;             //05	Data de pagamento do PIS/PASEP � Importa��o	N	008*	-
    fVL_BC_COFINS  : Variant;               //06	Valor da base de c�lculo da Opera��o � COFINS � Importa��o	N	-	02
    fVL_COFINS_IMP : Variant;               //07	Valor pago/recolhido de COFINS � Importa��o	N	-	02
    fDT_PAG_COFINS : TDateTime;             //08	Data de pagamento do COFINS � Importa��o	N	008*
    fLOC_EXE_SERV  : TACBrLocalExecServico; //09	Local da execu��o do servi�o: 0 � Executado no Pa�s; 1 � Executado no Exterior, cujo resultado se verifique no Pa�s.	C	001*	-
  public
    property VL_TOT_SERV   : Variant               read FVL_TOT_SERV   write FVL_TOT_SERV;
    property VL_BC_PIS     : Variant               read FVL_BC_PIS     write FVL_BC_PIS;
    property VL_PIS_IMP    : Variant               read FVL_PIS_IMP    write FVL_PIS_IMP;
    property DT_PAG_PIS    : TDateTime             read FDT_PAG_PIS    write FDT_PAG_PIS;
    property VL_BC_COFINS  : Variant               read FVL_BC_COFINS  write FVL_BC_COFINS;
    property VL_COFINS_IMP : Variant               read FVL_COFINS_IMP write FVL_COFINS_IMP;
    property DT_PAG_COFINS : TDateTime             read FDT_PAG_COFINS write FDT_PAG_COFINS;
    property LOC_EXE_SERV  : TACBrLocalExecServico read FLOC_EXE_SERV  write FLOC_EXE_SERV;
  end;

  /// Registro A120 - Lista

  TRegistroA120List = class(TObjectList)
  private
    function  GetItem(Index: Integer): TRegistroA120;
    procedure SetItem(Index: Integer; const Value: TRegistroA120);
  public
    function New: TRegistroA120;
    property Items[Index: Integer]: TRegistroA120 read GetItem write SetItem;
  end;

  // REGISTRO A170: COMPLEMENTO DO DOCUMENTO - ITENS DO DOCUMENTO

  TRegistroA170 = class
  private
    fNUM_ITEM      : Integer;                 //02	N�mero seq�encial do item no documento fiscal	N	003	-
    fCOD_ITEM      : string;                  //03	C�digo do item (campo 02 do Registro 0200)	C	060	-
    fDESCR_COMPL   : string;                  //04	Descri��o complementar do item como adotado no documento fiscal	C	-	-
    fVL_ITEM       : Variant;                 //05	Valor total do item (mercadorias ou servi�os)	N	-	02
    fVL_DESC       : Variant;                 //06	Valor do desconto do item	N	-	02
    fNAT_BC_CRED   : TACBrNatBcCred;          //07	C�digo da Base de C�lculo do Cr�dito, conforme a Tabela indicada no item 4.3.7, caso seja informado c�digo representativo de cr�dito no Campo 09 (CST_PIS) ou no Campo 13 (CST_COFINS).	C	002*	-
    fIND_ORIG_CRED : TACBrIndOrigCred;        //08	Indicador da origem do cr�dito:0 � Opera��o no Mercado Interno 1 � Opera��o de Importa��o	C	001*	-
    fCST_PIS       : TACBrCstPis;             //09	C�digo da Situa��o Tribut�ria referente ao PIS/PASEP � Tabela 4.3.3.	N	002*	-
    fVL_BC_PIS     : Variant;                 //10	Valor da base de c�lculo do PIS/PASEP.	N	- 	02
    fALIQ_PIS      : Variant;                 //11	Al�quota do PIS/PASEP (em percentual)	N	-	02
    fVL_PIS        : Variant;                 //12	Valor do PIS/PASEP	N	-	02
    fCST_COFINS    : TACBrCstCofins;          //13	C�digo da Situa��o Tribut�ria referente ao COFINS � Tabela 4.3.4.	N	002*	-
    fVL_BC_COFINS  : Variant;                 //14	Valor da base de c�lculo da COFINS	N	 	02
    fALIQ_COFINS   : Variant;                 //15	Al�quota do COFINS (em percentual)	N	006	02
    fVL_COFINS     : Variant;                 //16	Valor da COFINS	N	-	02
    fCOD_CTA       : string;                  //17	C�digo da conta anal�tica cont�bil debitada/creditada	C	060	-
    fCOD_CCUS      : string;                  //18	C�digo do centro de custos	C	060	-
  public
    property NUM_ITEM      : Integer                 read FNUM_ITEM      write FNUM_ITEM;
    property COD_ITEM      : string                  read FCOD_ITEM      write FCOD_ITEM;
    property DESCR_COMPL   : string                  read FDESCR_COMPL   write FDESCR_COMPL;
    property VL_ITEM       : Variant                 read FVL_ITEM       write FVL_ITEM;
    property VL_DESC       : Variant                 read FVL_DESC       write FVL_DESC;
    property NAT_BC_CRED   : TACBrNatBcCred          read FNAT_BC_CRED   write FNAT_BC_CRED;
    property IND_ORIG_CRED : TACBrIndOrigCred        read FIND_ORIG_CRED write FIND_ORIG_CRED;
    property CST_PIS       : TACBrCstPis             read FCST_PIS       write FCST_PIS;
    property VL_BC_PIS     : Variant                 read FVL_BC_PIS     write FVL_BC_PIS;
    property ALIQ_PIS      : Variant                 read FALIQ_PIS      write FALIQ_PIS;
    property VL_PIS        : Variant                 read FVL_PIS        write FVL_PIS;
    property CST_COFINS    : TACBrCstCofins          read FCST_COFINS    write FCST_COFINS;
    property VL_BC_COFINS  : Variant                 read FVL_BC_COFINS  write FVL_BC_COFINS;
    property ALIQ_COFINS   : Variant                 read FALIQ_COFINS   write FALIQ_COFINS;
    property VL_COFINS     : Variant                 read FVL_COFINS     write FVL_COFINS;
    property COD_CTA       : string                  read FCOD_CTA       write FCOD_CTA;
    property COD_CCUS      : string                  read FCOD_CCUS      write FCOD_CCUS;
  end;

  /// Registro A170 - Lista

  TRegistroA170List = class(TObjectList)
  private
    function  GetItem(Index: Integer): TRegistroA170;
    procedure SetItem(Index: Integer; const Value: TRegistroA170);
  public
    function New: TRegistroA170;
    property Items[Index: Integer]: TRegistroA170 read GetItem write SetItem;
  end;

  // REGISTRO A990: ENCERRAMENTO DO BLOCO A

  TRegistroA990 = class
  private
    fQTD_LIN_A : integer;          //02	Quantidade total de linhas do Bloco A	N	-	-
  public
    property QTD_LIN_A: integer read FQTD_LIN_A write FQTD_LIN_A;
  end;

implementation


{ TRegistroA001 }

constructor TRegistroA001.Create;
begin
  inherited Create;
  FRegistroA010 := TRegistroA010List.Create;
end;

destructor TRegistroA001.Destroy;
begin
  FRegistroA010.Free;
  inherited;
end;

{ TRegistroA010 }

constructor TRegistroA010.Create;
begin
  FRegistroA100 := TRegistroA100List.Create;
end;

destructor TRegistroA010.Destroy;
begin
  FRegistroA100.Free;
  inherited;
end;

function TRegistroA010List.GetItem(Index: Integer): TRegistroA010;
begin
  Result := TRegistroA010(Inherited Items[Index]);
end;

function TRegistroA010List.New: TRegistroA010;
begin
  Result := TRegistroA010.Create;
  Add(Result);
end;

procedure TRegistroA010List.SetItem(Index: Integer; const Value: TRegistroA010);
begin
  Put(Index, Value);
end;


{ TRegistroA100 }

function TRegistroA100List.GetItem(Index: Integer): TRegistroA100;
begin
  Result := TRegistroA100(Inherited Items[Index]);
end;

function TRegistroA100List.New: TRegistroA100;
begin
  Result := TRegistroA100.Create;
  Add(Result);
end;

procedure TRegistroA100List.SetItem(Index: Integer; const Value: TRegistroA100);
begin
  Put(Index, Value);
end;


{TRegistroA110}

function TRegistroA110List.GetItem(Index: Integer): TRegistroA110;
begin
  Result := TRegistroA110(Inherited Items[Index]);
end;

function TRegistroA110List.New: TRegistroA110;
begin
  Result := TRegistroA110.Create;
  Add(Result);
end;

procedure TRegistroA110List.SetItem(Index: Integer; const Value: TRegistroA110);
begin
  Put(Index, Value);
end;


{TRegistroA111}

function TRegistroA111List.GetItem(Index: Integer): TRegistroA111;
begin
  Result := TRegistroA111(Inherited Items[Index]);
end;

function TRegistroA111List.New: TRegistroA111;
begin
  Result := TRegistroA111.Create;
  Add(Result);
end;

procedure TRegistroA111List.SetItem(Index: Integer; const Value: TRegistroA111);
begin
  Put(Index, Value);
end;


{TRegistroA120}

function TRegistroA120List.GetItem(Index: Integer): TRegistroA120;
begin
  Result := TRegistroA120(Inherited Items[Index]);
end;

function TRegistroA120List.New: TRegistroA120;
begin
  Result := TRegistroA120.Create;
  Add(Result);
end;

procedure TRegistroA120List.SetItem(Index: Integer; const Value: TRegistroA120);
begin
  Put(Index, Value);
end;


{TRegistroA170}

function TRegistroA170List.GetItem(Index: Integer): TRegistroA170;
begin
  Result := TRegistroA170(Inherited Items[Index]);
end;

function TRegistroA170List.New: TRegistroA170;
begin
  Result := TRegistroA170.Create;
  Add(Result);
end;

procedure TRegistroA170List.SetItem(Index: Integer; const Value: TRegistroA170);
begin
  Put(Index, Value);
end;

constructor TRegistroA100.Create;
begin
  FRegistroA110 := TRegistroA110List.Create;
  FRegistroA111 := TRegistroA111List.Create;
  FRegistroA120 := TRegistroA120List.Create;
  FRegistroA170 := TRegistroA170List.Create;
end;

destructor TRegistroA100.Destroy;
begin
  FRegistroA110.Free;
  FRegistroA111.Free;
  FRegistroA120.Free;
  FRegistroA170.Free;
  inherited;
end;

end.

