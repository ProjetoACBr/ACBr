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

unit ACBrEFDBloco_H;

{$I ACBr.inc}

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrEFDBlocos;

type
  TRegistroH005List = class;
  TRegistroH010List = class;
  TRegistroH011List = class;
  TRegistroH020List = class;
  TRegistroH030List = class;

  /// Registro H001 - ABERTURA DO BLOCO H

  TRegistroH001 = class(TOpenBlocos)
  private
    FRegistroH005: TRegistroH005List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property RegistroH005: TRegistroH005List read FRegistroH005 write FRegistroH005;
  end;

  /// Registro H005 - TOTAIS DO INVENT�RIO

  TRegistroH005 = class
  private
    fDT_INV: TDateTime;    /// Data do invent�rio:
    fVL_INV: currency;     /// Valor total do estoque:
    fMOT_INV: TACBrMotInv; /// 01 � No final no per�odo;
                           /// 02 � Na mudan�a de forma de tributa��o da mercadoria (ICMS);
                           /// 03 � Na solicita��o da baixa cadastral, paralisa��o tempor�ria e outras situa��es;
                           /// 04 � Na altera��o de regime de pagamento � condi��o do contribuinte;
                           /// 05 � Por determina��o dos fiscos.
                           /// 06 - Para controle das mercadorias sujeitas ao regime de substitui��o tribut�ria

    FRegistroH010: TRegistroH010List;  /// BLOCO H - Lista de RegistroH010 (FILHO)
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy

    property DT_INV: TDateTime read FDT_INV write FDT_INV;
    property VL_INV: currency read FVL_INV write FVL_INV;
    property MOT_INV: TACBrMotInv read fMOT_INV write fMOT_INV;

    /// Registros FILHOS
    property RegistroH010: TRegistroH010List read FRegistroH010 write FRegistroH010;
  end;

  /// Registro H005 - Lista

  TRegistroH005List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroH005; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroH005); /// SetItem
  public
    function New(): TRegistroH005;
    property Items[Index: Integer]: TRegistroH005 read GetItem write SetItem;
  end;

  /// Registro H010 - INVENT�RIO

  { TRegistroH010 }

  TRegistroH010 = class
  private
    fCOD_ITEM: String;       /// C�digo do item (campo 02 do Registro 0200)
    fUNID: String;           /// Unidade do item
    fQTD: Double;            /// Quantidade do item
    fVL_UNIT: Double;        /// Valor unit�rio do item
    fVL_ITEM: currency;      /// Valor do item
    fIND_PROP: TACBrIndProp; /// Indicador de propriedade/posse do item: 0- Item de propriedade do informante e em seu poder, 1- Item de propriedade do informante em posse de terceiros, 2- Item de propriedade de terceiros em posse do informante
    fCOD_PART: String;       /// C�digo do participante (campo 02 do Registro 0150): propriet�rio/possuidor que n�o seja o informante do arquivo
    fTXT_COMPL: String;      /// Descri��o complementar
    fCOD_CTA: String;        /// C�digo da conta anal�tica cont�bil debitada/creditada
    fVL_ITEM_IR: Double;       /// Valor do item para efeitos do Imposto de Renda.

    FRegistroH011: TRegistroH011List;  /// BLOCO H - Lista de RegistroH011 (FILHO)
    FRegistroH020: TRegistroH020List;  /// BLOCO H - Lista de RegistroH020 (FILHO)
    FRegistroH030: TRegistroH030List;  /// BLOCO H - Lista de RegistroH030 (FILHO)

  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy

    property COD_ITEM: String read FCOD_ITEM write FCOD_ITEM;
    property UNID: String read FUNID write FUNID;
    property QTD: Double read FQTD write FQTD;
    property VL_UNIT: Double read FVL_UNIT write FVL_UNIT;
    property VL_ITEM: currency read FVL_ITEM write FVL_ITEM;
    property IND_PROP: TACBrIndProp read FIND_PROP write FIND_PROP;
    property COD_PART: String read FCOD_PART write FCOD_PART;
    property TXT_COMPL: String read FTXT_COMPL write FTXT_COMPL;
    property COD_CTA: String read FCOD_CTA write FCOD_CTA;
    property VL_ITEM_IR : Double read fVL_ITEM_IR write fVL_ITEM_IR;
    /// Registros FILHOS
    property RegistroH011: TRegistroH011List read FRegistroH011 write FRegistroH011;
    property RegistroH020: TRegistroH020List read FRegistroH020 write FRegistroH020;
    property RegistroH030: TRegistroH030List read FRegistroH030 write FRegistroH030;
  end;

  /// Registro H010 - Lista

  TRegistroH010List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroH010; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroH010); /// SetItem
  public
    function LocalizaRegistro(const pCOD_ITEM: String): boolean;
    function New(): TRegistroH010;
    property Items[Index: Integer]: TRegistroH010 read GetItem write SetItem;
  end;

  /// Registro H020 - INFORMA��O COMPLEMENTAR DO INVENT�RIO

  TRegistroH011 = class
  private
    fCNPJ: String;          /// CNPJ DA EMPRESA RESPONS�VEL PELO INVENTARIO
  public
    constructor Create(AOwner: TRegistroH010); virtual; /// Create

    property CNPJ: String read fCNPJ write fCNPJ;
  end;

  /// Registro H011 - Lista
  TRegistroH011List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroH011; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroH011); /// SetItem
  public
    function New(AOwner: TRegistroH010): TRegistroH011;
    property Items[Index: Integer]: TRegistroH011 read GetItem write SetItem;
  end;

  /// Registro H020 - INFORMA��O COMPLEMENTAR DO INVENT�RIO

  TRegistroH020 = class
  private
    fCST_ICMS: String;          /// C�digo da Situa��o Tribut�ria, conforme a Tabela indicada no item 4.3.1
    fBC_ICMS: currency;         /// Informe a base de c�lculo do ICMS
    fVL_ICMS: currency;         /// Informe o valor do ICMS a ser debitado ou creditado
  public
    constructor Create(AOwner: TRegistroH010); virtual; /// Create

    property CST_ICMS: String read FCST_ICMS write FCST_ICMS;
    property BC_ICMS: currency read FBC_ICMS write FBC_ICMS;
    property VL_ICMS: currency read FVL_ICMS write FVL_ICMS;
  end;

  /// Registro H020 - Lista

  TRegistroH020List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroH020; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroH020); /// SetItem
  public
    function New(AOwner: TRegistroH010): TRegistroH020;
    property Items[Index: Integer]: TRegistroH020 read GetItem write SetItem;
  end;

  ///REGISTRO H030: INFORMA��ES COMPLEMENTARES DO INVENT�RIO DAS MERCADORIAS SUJEITAS AO REGIME DE SUBSTITUI��O TRIBUT�RIA.

  TRegistroH030 = class
  private
    fVL_ICMS_OP: Double; /// Valor m�dio unit�rio do ICMS OP.
    fVL_BC_ICMS_ST: Double; /// Valor m�dio unit�rio da base de c�lculo do ICMS ST.
    fVL_ICMS_ST: Double; /// Valor m�dio unit�rio do ICMS ST.
    fVL_FCP: Double; /// Valor m�dio unit�rio do FCP.
  public
    constructor Create(AOwner: TRegistroH010); virtual; /// Create

    property VL_ICMS_OP: Double read fVL_ICMS_OP write fVL_ICMS_OP;
    property VL_BC_ICMS_ST: Double read fVL_BC_ICMS_ST write fVL_BC_ICMS_ST;
    property VL_ICMS_ST: Double read fVL_ICMS_ST write fVL_ICMS_ST;
    property VL_FCP: Double read fVL_FCP write fVL_FCP;
  end;

  /// Registro H030 - Lista

  TRegistroH030List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroH030; /// GetItem
    procedure SetItem(Index: Integer; const Value: TRegistroH030); /// SetItem
  public
    function New(AOwner: TRegistroH010): TRegistroH030;
    property Items[Index: Integer]: TRegistroH030 read GetItem write SetItem;
  end;

  /// Registro H990 - ENCERRAMENTO DO BLOCO H

  TRegistroH990 = class
  private
    fQTD_LIN_H: Integer;    /// Quantidade total de linhas do Bloco H
  public
    property QTD_LIN_H: Integer read FQTD_LIN_H write FQTD_LIN_H;
  end;

implementation

{ TRegistroH010List }

function TRegistroH010List.GetItem(Index: Integer): TRegistroH010;
begin
  Result := TRegistroH010(Inherited Items[Index]);
end;

function TRegistroH010List.LocalizaRegistro(const pCOD_ITEM: String): boolean;
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

function TRegistroH010List.New(): TRegistroH010;
begin
  Result := TRegistroH010.Create();
  Add(Result);
end;

procedure TRegistroH010List.SetItem(Index: Integer; const Value: TRegistroH010);
begin
  Put(Index, Value);
end;

{ TRegistroH005List }

function TRegistroH005List.GetItem(Index: Integer): TRegistroH005;
begin
  Result := TRegistroH005(Inherited Items[Index]);
end;

function TRegistroH005List.New(): TRegistroH005;
begin
  Result := TRegistroH005.Create();
  Add(Result);
end;

procedure TRegistroH005List.SetItem(Index: Integer; const Value: TRegistroH005);
begin
  Put(Index, Value);
end;

{ TRegistroH005 }

constructor TRegistroH005.Create();
begin
  inherited Create;
  FRegistroH010 := TRegistroH010List.Create;
end;

destructor TRegistroH005.Destroy;
begin
  FRegistroH010.Free;
  inherited;
end;

{ TRegistroH001 }

constructor TRegistroH001.Create;
begin
   inherited Create;
   FRegistroH005 := TRegistroH005List.Create;
   //
   IND_MOV := imSemDados;
end;

destructor TRegistroH001.Destroy;
begin
  FRegistroH005.Free;
  inherited;
end;

{ TRegistroH020List }

function TRegistroH020List.GetItem(Index: Integer): TRegistroH020;
begin
  Result := TRegistroH020(Inherited Items[Index]);
end;

function TRegistroH020List.New(AOwner: TRegistroH010): TRegistroH020;
begin
  Result := TRegistroH020.Create(AOwner);
  Add(Result);
end;

procedure TRegistroH020List.SetItem(Index: Integer;
  const Value: TRegistroH020);
begin
  Put(Index, Value);
end;

{ TRegistroH011List }

function TRegistroH011List.GetItem(Index: Integer): TRegistroH011;
begin
  Result := TRegistroH011(Inherited Items[Index]);
end;

function TRegistroH011List.New(AOwner: TRegistroH010): TRegistroH011;
begin
  Result := TRegistroH011.Create(AOwner);
  Add(Result);
end;

procedure TRegistroH011List.SetItem(Index: Integer;
  const Value: TRegistroH011);
begin
  Put(Index, Value);
end;

{ TRegistroH010 }

constructor TRegistroH010.Create();
begin
  inherited Create;
  FRegistroH011 := TRegistroH011List.Create;
  FRegistroH020 := TRegistroH020List.Create;
  FRegistroH030 := TRegistroH030List.Create;
end;

destructor TRegistroH010.Destroy;
begin
  FRegistroH011.Free;
  FRegistroH020.Free;
  FRegistroH030.Free;
  inherited;
end;

{ TRegistroH011 }

constructor TRegistroH011.Create(AOwner: TRegistroH010);
begin
end;

{ TRegistroH020 }

constructor TRegistroH020.Create(AOwner: TRegistroH010);
begin
end;

{ TRegistroH030 }

constructor TRegistroH030.Create(AOwner: TRegistroH010);
begin
end;

{ TRegistroH030List }

function TRegistroH030List.GetItem(Index: Integer): TRegistroH030;
begin
   Result := TRegistroH030(Inherited Items[Index]);
end;

function TRegistroH030List.New(AOwner: TRegistroH010): TRegistroH030;
begin
  Result := TRegistroH030.Create(AOwner);
  Add(Result);
end;

procedure TRegistroH030List.SetItem(Index: Integer; const Value: TRegistroH030);
begin
  Put(Index, Value);
end;

end.
