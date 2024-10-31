{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
{                              Jean Carlo Cantu                                }
{                              Tiago Ravache                                   }
{                              Guilherme Costa                                 }
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
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 28/08/2017: Leivio Fontenele - leivio@yahoo.com.br
|*  - Implementa��o comunica��o, envelope, status e retorno do componente com webservice.
******************************************************************************}

{$I ACBr.inc}

unit pcesS5001;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrBase,
  pcnConversao, pcnLeitor,
  pcesCommon, pcesConversaoeSocial;

type
  TInfoCpCalcCollection = class;
  TInfoCpCalcCollectionItem = class;
  TIdeEstabLotCollection = class;
  TIdeEstabLotCollectionItem = class;
  TInfoCategIncidCollection = class;
  TInfoCategIncidCollectionItem = class;
  TInfoBaseCSCollection = class;
  TInfoBaseCSCollectionItem = class;
  TCalcTercCollection = class;
  TCalcTercCollectionItem = class;
  TInfoPerRefCollection = class;
  TInfoPerRefCollectionItem = class;
  TDetInfoPerRefCollection = class;
  TDetInfoPerRefCollectionItem = class;
  TEvtBasesTrab = class;
  TInfoCompl = class;
  TSucessaoVinc = class;
  TInfoComplContCollection = class;
  TInfoComplContCollectionItem = class;
  TIdeTrabalhador4 = class;
  TIdeADCCollection = class;
  TIdeADCCollectionItem = class;
  TinfoPisPasep = class;
  TideEstabCollection = class;
  TideEstabCollectionItem = class;
  TinfoCategPisPasepCollection = class;
  TinfoCategPisPasepCollectionItem = class;
  TinfoBasePisPasepCollection = class;
  TinfoBasePisPasepCollectionItem = class;
  
  TS5001 = class(TInterfacedObject, IEventoeSocial)
  private
    FTipoEvento: TTipoEvento;
    FEvtBasesTrab: TEvtBasesTrab;

    function GetXml : string;
    procedure SetXml(const Value: string);
    function GetTipoEvento : TTipoEvento;
  public
    constructor Create;
    destructor Destroy; override;

    function GetEvento() : TObject;
    
    property Xml: String read GetXml write SetXml;
    property TipoEvento: TTipoEvento read GetTipoEvento;
    property EvtBasesTrab: TEvtBasesTrab read FEvtBasesTrab write FEvtBasesTrab;
  end;

  TIdeTrabalhador4 = class(TIdeTrabalhador3)
  private
    FInfoCompl: TInfoCompl;
  public
    constructor Create;
    destructor Destroy; override;
    
    property InfoCompl: TInfoCompl read FInfoCompl write FInfoCompl;
  end;
  
  TInfoCpCalcCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoCpCalcCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoCpCalcCollectionItem);
  public
    function Add: TInfoCpCalcCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfoCpCalcCollectionItem;
    property Items[Index: Integer]: TInfoCpCalcCollectionItem read GetItem write SetItem;
  end;

  TInfoCpCalcCollectionItem = class(TObject)
  private
    FtpCR: string;
    FvrCpSeg: Double;
    FvrDescSeg: Double;
  public
    property tpCR: string read FtpCR;
    property vrCpSeg: Double read FvrCpSeg;
    property vrDescSeg: Double read FvrDescSeg;
  end;

  TInfoCp = class(TObject)
  private
    FClassTrib: tpClassTrib;
    FIdeEstabLot: TIdeEstabLotCollection;

    procedure SetIdeEstabLot(const Value: TIdeEstabLotCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property classTrib: tpClassTrib read FClassTrib write FClassTrib;
    property IdeEstabLot: TIdeEstabLotCollection read FIdeEstabLot write SetIdeEstabLot;
  end;

  TIdeEstabLotCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TIdeEstabLotCollectionItem;
    procedure SetItem(Index: Integer; Value: TIdeEstabLotCollectionItem);
  public
    function Add: TIdeEstabLotCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TIdeEstabLotCollectionItem;
    property Items[Index: Integer]: TIdeEstabLotCollectionItem read GetItem write SetItem;
  end;

  TIdeEstabLotCollectionItem = class(TObject)
  private
    FTpInsc: TpTpInsc;
    FNrInsc: string;
    FCodLotacao: string;
    FInfoCategIncid: TInfoCategIncidCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property tpInsc: TpTpInsc read FTpInsc;
    property nrInsc: string read FNrInsc;
    property codLotacao: string read FCodLotacao;
    property InfoCategIncid: TInfoCategIncidCollection read FInfoCategIncid;
  end;

  TInfoCategIncidCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoCategIncidCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoCategIncidCollectionItem);
  public
    function Add: TInfoCategIncidCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfoCategIncidCollectionItem;
    property Items[Index: Integer]: TInfoCategIncidCollectionItem read GetItem write SetItem;
  end;

  TInfoCategIncidCollectionItem = class(TObject)
  private
    FMatricula: string;
    FcodCateg: Integer;
    FindSimples: tpIndSimples;
    FInfoBaseCS: TInfoBaseCSCollection;
    FCalcTerc: TCalcTercCollection;
    FInfoPerRef: TInfoPerRefCollection;

    procedure SetInfoBaseCS(const Value: TInfoBaseCSCollection);
    procedure SetCalcTerc(const Value: TCalcTercCollection);
    procedure SetInfoPerRef(const Value: TInfoPerRefCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property matricula: string read FMatricula;
    property codCateg: Integer read FcodCateg;
    property indSimples: tpIndSimples read FindSimples;
    property InfoBaseCS: TInfoBaseCSCollection read FInfoBaseCS write SetInfoBaseCS;
    property CalcTerc: TCalcTercCollection read FCalcTerc write SetCalcTerc;
    property InfoPerRef: TInfoPerRefCollection read FInfoPerRef write SetInfoPerRef;
  end;

  TInfoBaseCSCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoBaseCSCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoBaseCSCollectionItem);
  public
    function Add: TInfoBaseCSCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfoBaseCSCollectionItem;
    property Items[Index: Integer]: TInfoBaseCSCollectionItem read GetItem write SetItem;
  end;

  TInfoBaseCSCollectionItem = class(TObject)
  private
    Find13: Integer;
    FtpValor: Integer;
    Fvalor: Double;
  public
    property ind13: Integer read Find13;
    property tpValor: Integer read FtpValor;
    property valor: Double read Fvalor;
  end;

  TCalcTercCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TCalcTercCollectionItem;
    procedure SetItem(Index: Integer; Value: TCalcTercCollectionItem);
  public
    function Add: TCalcTercCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TCalcTercCollectionItem;
    property Items[Index: Integer]: TCalcTercCollectionItem read GetItem write SetItem;
  end;

  TCalcTercCollectionItem = class(TObject)
  private
    FtpCR: Integer;
    FvrCsSegTerc: Double;
    FvrDescTerc: Double;
  public
    property tpCR: Integer read FtpCR;
    property vrCsSegTerc: Double read FvrCsSegTerc;
    property vrDescTerc: Double read FvrDescTerc;
  end;

  TInfoPerRefCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoPerRefCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoPerRefCollectionItem);
  public
    function Add: TInfoPerRefCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfoPerRefCollectionItem;
    property Items[Index: Integer]: TInfoPerRefCollectionItem read GetItem write SetItem;
  end;

  TInfoPerRefCollectionItem = class(TObject)
  private
    FperRef: string;
    FDetInfoPerRef: TDetInfoPerRefCollection;
    FIdeADC: TIdeADCCollection;
    
    function getDetInfoPerRef(): TDetInfoPerRefCollection;
    function getIdeADC(): TIdeADCCollection;
  public
    constructor Create;
    destructor Destroy; override;

    function DetInfoPerRefInst(): Boolean;
    function IdeADCInst(): Boolean;
             
    property perRef: string read FperRef;
    property detInfoPerRef: TDetInfoPerRefCollection read getDetInfoPerRef write FDetInfoPerRef;
    property ideADC: TIdeADCCollection read getIdeADC write FIdeADC;
  end;

  TDetInfoPerRefCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TDetInfoPerRefCollectionItem;
    procedure SetItem(Index: Integer; Value: TDetInfoPerRefCollectionItem);
  public
    function Add: TDetInfoPerRefCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TDetInfoPerRefCollectionItem;
    property Items[Index: Integer]: TDetInfoPerRefCollectionItem read GetItem write SetItem;
  end;

  TDetInfoPerRefCollectionItem = class(TObject)
  private
    Find13: Integer;
    FvrPerRef: Double;
    FtpVrPerRef: Integer;
  public
    property ind13: Integer read Find13;
    property tpValor: Integer read FtpVrPerRef;
    property tpVrPerRef: Integer read FtpVrPerRef;
    property vrPerRef: Double read FvrPerRef;
  end;

  TEvtBasesTrab = class(TObject)
  private
    FLeitor         : TLeitor;
    FId             : String;
    FXML            : String;
    FIdeEvento      : TIdeEvento5;
    FIdeEmpregador  : TIdeEmpregador;
    FIdeTrabalhador : TIdeTrabalhador4;
    FInfoCpCalc     : TInfoCpCalcCollection;
    FInfoCp         : TInfoCp;
    FVersaoDF       : TVersaoeSocial;
    FinfoPisPasep   : TinfoPisPasep;

    function getInfoPisPasep: TinfoPisPasep;
  public
    constructor Create;
    destructor  Destroy; override;

    function infoPisPasepInst: boolean;
    function LerXML          : boolean;
    function SalvarINI       : boolean;

    property IdeEvento       : TIdeEvento5 read FIdeEvento write FIdeEvento;
    property IdeEmpregador   : TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeTrabalhador  : TIdeTrabalhador4 read FIdeTrabalhador write FIdeTrabalhador;
    property InfoCpCalc      : TInfoCpCalcCollection read FInfoCpCalc write FInfoCpCalc;
    property InfoCp          : TInfoCp read FInfoCp write FInfoCp;
    property Leitor          : TLeitor read FLeitor write FLeitor;
    property Id              : String read FId;
    property XML             : String read FXML;
    property VersaoDF        : TVersaoeSocial read FVersaoDF write FVersaoDF;
    property infoPisPasep    : TinfoPisPasep read getInfoPisPasep write FinfoPisPasep;
  end;

  TSucessaoVinc = class
  private
    FtpInsc   : tpTpInsc;
    FnrInsc   : string;
    FmatricAnt: string;
    FdtAdm    : TDateTime;
  public
    property tpInsc   : tpTpInsc read FtpInsc write FtpInsc;
    property nrInsc   : string read FnrInsc write FnrInsc;
    property matricAnt: string read FmatricAnt write FmatricAnt;
    property dtAdm    : TDateTime read FdtAdm write FdtAdm;
  end;

  TInfoCompl = class(TObject)
  private
    FSucessaoVinc : TSucessaoVinc;
    FInfoInterm   : TInfoIntermCollection;
    FInfoComplCont: TInfoComplContCollection;
    
    function getInfoInterm(): TInfoIntermCollection;
    function getInfoComplCont(): TInfoComplContCollection;
    function getSucessaoVinc(): TSucessaoVinc;
  public
    constructor Create;
    destructor Destroy; override;
             
    function InfoIntermInst(): Boolean;
    function InfoComplContInst(): Boolean;
    function SucessaoVincInst(): Boolean;
    
    property sucessaoVinc : TSucessaoVinc read getSucessaoVinc write FSucessaoVinc;
    property infoInterm   : TInfoIntermCollection read getInfoInterm write FInfoInterm;
    property infoComplCont: TInfoComplContCollection read getInfoComplCont write FInfoComplCont;
  end;

  TInfoComplContCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoComplContCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoComplContCollectionItem);
  public
    function Add: TInfoComplContCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfoComplContCollectionItem;
    property Items[Index: Integer]: TInfoComplContCollectionItem read GetItem write SetItem; default;
  end;
  
  TInfoComplContCollectionItem = class(TObject)
  private
    FCodCBO      : String;
    FNatAtividade: tpNatAtividade;
    FQtdDiasTrab : Integer;
  public
    property codCBO      : String read FCodCBO write FCodCBO;
    property natAtividade: tpNatAtividade read FNatAtividade write FNatAtividade;
    property qtdDiasTrab : Integer read FQtdDiasTrab write FQtdDiasTrab;
  end;
    
  TIdeADCCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TIdeADCCollectionItem;
    procedure SetItem(Index: Integer; Value: TIdeADCCollectionItem);
  public
    function Add: TIdeADCCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TIdeADCCollectionItem;
    property Items[Index: Integer]: TIdeADCCollectionItem read GetItem write SetItem;
  end;  
    
  TIdeADCCollectionItem = class(TObject)
  private
   FDtAcConv: TDateTime;
   FTpAcConv: tpTpAcConv;
   FDsc     : String;
   FremunSuc: tpSimNaoFacultativo;
  public
    property dtAcConv: TDateTime read FDtAcConv write FDtAcConv;
    property tpAcConv: tpTpAcConv read FTpAcConv write FTpAcConv;
    property dsc     : String read FDsc write FDsc;
    property remunSuc: tpSimNaoFacultativo read FremunSuc write FremunSuc;
  end;

  TinfoPisPasep = class(TObject)
  private
    FideEstab: TideEstabCollection;
  public
    constructor Create;
    destructor Destroy; override;
    property ideEstab: TideEstabCollection read FideEstab;
  end;

  TideEstabCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TideEstabCollectionItem;
    procedure SetItem(Index: Integer; Value: TideEstabCollectionItem);
  public
    function New: TideEstabCollectionItem;
    property Items[Index: Integer]: TideEstabCollectionItem read GetItem write SetItem; default;
  end;

  TideEstabCollectionItem = class(TObject)
  private
    FtpInsc: tpTpInsc;
    FnrInsc: string;
    FinfoCategPisPasep: TinfoCategPisPasepCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property tpInsc: tpTpInsc read FtpInsc write FtpInsc;
    property nrInsc: string read FnrInsc write FnrInsc;
    property infoCategPisPasep: TinfoCategPisPasepCollection read FinfoCategPisPasep;
  end;

  TinfoCategPisPasepCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfoCategPisPasepCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfoCategPisPasepCollectionItem);
  public
    function New: TinfoCategPisPasepCollectionItem;
    property Items[Index: Integer]: TinfoCategPisPasepCollectionItem read GetItem write SetItem; default;
  end;

  TinfoCategPisPasepCollectionItem = class(TObject)
  private
    Fmatricula: string;
    FcodCateg: integer;
    FinfoBasePisPasep: TinfoBasePisPasepCollection;

    function getinfoBasePisPasep(): TinfoBasePisPasepCollection;
  public
    constructor Create;
    destructor Destroy; override;

    function infoBasePisPasepInst(): Boolean;

    property matricula: string read Fmatricula write Fmatricula;
    property codCateg: integer read FcodCateg write FcodCateg;
    property infoBasePisPasep: TinfoBasePisPasepCollection read getInfoBasePisPasep write FinfoBasePisPasep;
  end;

  TinfoBasePisPasepCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfoBasePisPasepCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfoBasePisPasepCollectionItem);
  public
    function New: TinfoBasePisPasepCollectionItem;
    property Items[Index: Integer]: TinfoBasePisPasepCollectionItem read GetItem write SetItem; default;
  end;

  TinfoBasePisPasepCollectionItem = class(TObject)
  private
    Find13: integer;
    FtpValorPisPasep: TtpValorPisPasep;
    FvalorPisPasep: Double;
  public
    property ind13: integer read Find13;
    property tpValorPisPasep: TtpValorPisPasep read FtpValorPisPasep;
    property valorPisPasep: Double read FvalorPisPasep;
  end;
  
implementation

uses
  IniFiles,
  ACBrUtil.Base,
  ACBrUtil.DateTime;

{ TS5001 }

constructor TS5001.Create;
begin
  inherited;
  
  FTipoEvento := teS5001;
  FEvtBasesTrab := TEvtBasesTrab.Create;
end;

destructor TS5001.Destroy;
begin
  FEvtBasesTrab.Free;

  inherited;
end;

function TS5001.GetEvento : TObject;
begin
  Result := self;
end;

function TS5001.GetXml : string;
begin
  Result := FEvtBasesTrab.XML;
end;

procedure TS5001.SetXml(const Value: string);
begin
  if Value = FEvtBasesTrab.XML then Exit;

  FEvtBasesTrab.FXML := Value;
  FEvtBasesTrab.Leitor.Arquivo := Value;
  FEvtBasesTrab.LerXML;

end;

function TS5001.GetTipoEvento : TTipoEvento;
begin
  Result := FTipoEvento;
end;

{ TIdeTrabalhador4 }

constructor TIdeTrabalhador4.Create;
begin
  inherited Create;
  
  FInfoCompl := TInfoCompl.Create;
end;

destructor TIdeTrabalhador4.Destroy;
begin
  FInfoCompl.Free;
  
  inherited;
end;

{ TEvtBasesTrab }

constructor TEvtBasesTrab.Create();
begin
  inherited Create;

  FLeitor         := TLeitor.Create;
  FIdeEvento      := TIdeEvento5.Create;
  FIdeEmpregador  := TIdeEmpregador.Create;
  FIdeTrabalhador := TIdeTrabalhador4.Create;
  FInfoCpCalc     := TInfoCpCalcCollection.Create;
  FInfoCp         := TInfoCp.Create;
  FinfoPisPasep   := nil;
end;

destructor TEvtBasesTrab.Destroy;
begin
  FLeitor.Free;

  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeTrabalhador.Free;
  FInfoCpCalc.Free;
  FInfoCp.Free;

  if infoPisPasepInst() then
    FreeAndNil(FinfoPisPasep);

  inherited;
end;

function TEvtBasesTrab.getInfoPisPasep(): TinfoPisPasep;
begin
  if not(infoPisPasepInst()) then
    FinfoPisPasep := TinfoPisPasep.Create;
  Result := FinfoPisPasep;
end;

function TEvtBasesTrab.infoPisPasepInst(): boolean;
begin
  Result := Assigned(FinfoPisPaseP);
end;

{ TideEstabCollection }

function TideEstabCollection.GetItem(
  Index: Integer): TideEstabCollectionItem;
begin
  Result := TideEstabCollectionItem(inherited Items[Index]);
end;

procedure TideEstabCollection.SetItem(Index: Integer;
  Value: TideEstabCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TideEstabCollection.New: TideEstabCollectionItem;
begin
  Result := TideEstabCollectionItem.Create;
  Self.Add(Result);
end;

{ TideEstabCollectionItem }

constructor TideEstabCollectionItem.Create;
begin
  inherited Create;
  FinfoCategPisPasep := TinfoCategPisPasepCollection.Create;
end;

destructor TideEstabCollectionItem.Destroy;
begin
  FinfoCategPisPasep.Free;
  inherited;
end;

{ TinfoCategPisPasepCollection }

function TinfoCategPisPasepCollection.GetItem(Index: Integer): TinfoCategPisPasepCollectionItem;
begin
  Result := TinfoCategPisPasepCollectionItem(inherited Items[Index]);
end;

procedure TinfoCategPisPasepCollection.SetItem(Index: Integer;
  Value: TinfoCategPisPasepCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TinfoCategPisPasepCollection.New: TinfoCategPisPasepCollectionItem;
begin
  Result := TinfoCategPisPasepCollectionItem.Create;
  Self.Add(Result);
end;

{ TinfoCategPisPasepCollectionItem }

constructor TinfoCategPisPasepCollectionItem.Create;
begin
  inherited Create;

  FinfoBasePisPasep := nil;
end;

destructor TinfoCategPisPasepCollectionItem.Destroy;
begin
  if infoBasePisPasepInst() then
    FreeAndNil(FinfoBasePisPasep);

  inherited;
end;

function TinfoCategPisPasepCollectionItem.GetinfoBasePisPasep: TinfoBasePisPasepCollection;
begin
  if not Assigned(FinfoBasePisPasep) then
    FinfoBasePisPasep := TinfoBasePisPasepCollection.Create;
   Result := FinfoBasePisPasep;
end;

function TinfoCategPisPasepCollectionItem.infoBasePisPasepInst(): Boolean;
begin
  Result := Assigned(FinfoBasePisPasep);
end;

{ TinfoBasePisPasepCollection }

function TinfoBasePisPasepCollection.GetItem(Index: Integer): TinfoBasePisPasepCollectionItem;
begin
  Result := TinfoBasePisPasepCollectionItem(inherited Items[Index]);
end;

procedure TinfoBasePisPasepCollection.SetItem(Index: Integer; Value: TinfoBasePisPasepCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TinfoBasePisPasepCollection.New: TinfoBasePisPasepCollectionItem;
begin
  Result := TinfoBasePisPasepCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfoCpCalcCollection }

function TInfoCpCalcCollection.Add: TInfoCpCalcCollectionItem;
begin
  Result := Self.New;
end;

function TInfoCpCalcCollection.GetItem(
  Index: Integer): TInfoCpCalcCollectionItem;
begin
  Result := TInfoCpCalcCollectionItem(inherited Items[Index]);
end;

procedure TInfoCpCalcCollection.SetItem(Index: Integer;
  Value: TInfoCpCalcCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfoCpCalcCollection.New: TInfoCpCalcCollectionItem;
begin
  Result := TInfoCpCalcCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfoCp }

constructor TInfoCp.Create;
begin
  inherited Create;
  FIdeEstabLot := TIdeEstabLotCollection.Create;
end;

destructor TInfoCp.Destroy;
begin
  FIdeEstabLot.Free;

  inherited;
end;

procedure TInfoCp.SetIdeEstabLot(const Value: TIdeEstabLotCollection);
begin
  FIdeEstabLot := Value;
end;

{ TIdeEstabLotCollection }

function TIdeEstabLotCollection.Add: TIdeEstabLotCollectionItem;
begin
  Result := Self.New;
end;

function TIdeEstabLotCollection.GetItem(
  Index: Integer): TIdeEstabLotCollectionItem;
begin
  Result := TIdeEstabLotCollectionItem(inherited Items[Index]);
end;

procedure TIdeEstabLotCollection.SetItem(Index: Integer;
  Value: TIdeEstabLotCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TIdeEstabLotCollection.New: TIdeEstabLotCollectionItem;
begin
  Result := TIdeEstabLotCollectionItem.Create;
  Self.Add(Result);
end;

{ TIdeEstabLotCollectionItem }

constructor TIdeEstabLotCollectionItem.Create;
begin
  inherited Create;
  FInfoCategIncid := TInfoCategIncidCollection.Create;
end;

destructor TIdeEstabLotCollectionItem.Destroy;
begin
  FInfoCategIncid.Free;

  inherited;
end;

{ TInfoCategIncidCollection }

function TInfoCategIncidCollection.Add: TInfoCategIncidCollectionItem;
begin
  Result := Self.New;
end;

function TInfoCategIncidCollection.GetItem(
  Index: Integer): TInfoCategIncidCollectionItem;
begin
  Result := TInfoCategIncidCollectionItem(inherited Items[Index]);
end;

procedure TInfoCategIncidCollection.SetItem(Index: Integer;
  Value: TInfoCategIncidCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfoCategIncidCollection.New: TInfoCategIncidCollectionItem;
begin
  Result := TInfoCategIncidCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfoCategIncidCollectionItem }

constructor TInfoCategIncidCollectionItem.Create;
begin
  inherited Create;
  FInfoBaseCS := TInfoBaseCSCollection.Create;
  FCalcTerc   := TCalcTercCollection.Create;
  FInfoPerRef := TInfoPerRefCollection.Create;
end;

destructor TInfoCategIncidCollectionItem.Destroy;
begin
  FInfoBaseCS.Free;
  FCalcTerc.Free;
  FInfoPerRef.Free;

  inherited;
end;

procedure TInfoCategIncidCollectionItem.SetCalcTerc(
  const Value: TCalcTercCollection);
begin
  FCalcTerc := Value;
end;

procedure TInfoCategIncidCollectionItem.SetInfoBaseCS(
  const Value: TInfoBaseCSCollection);
begin
  FInfoBaseCS := Value;
end;

procedure TInfoCategIncidCollectionItem.SetInfoPerRef(
  const Value: TInfoPerRefCollection);
begin
  FInfoPerRef := Value;
end;

{ TInfoBaseCSCollection }

function TInfoBaseCSCollection.Add: TInfoBaseCSCollectionItem;
begin
  Result := Self.New;
end;

function TInfoBaseCSCollection.GetItem(
  Index: Integer): TInfoBaseCSCollectionItem;
begin
  Result := TInfoBaseCSCollectionItem(inherited Items[Index]);
end;

procedure TInfoBaseCSCollection.SetItem(Index: Integer;
  Value: TInfoBaseCSCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfoBaseCSCollection.New: TInfoBaseCSCollectionItem;
begin
  Result := TInfoBaseCSCollectionItem.Create;
  Self.Add(Result);
end;

{ TCalcTercCollection }

function TCalcTercCollection.Add: TCalcTercCollectionItem;
begin
  Result := Self.New;
end;

function TCalcTercCollection.GetItem(
  Index: Integer): TCalcTercCollectionItem;
begin
  Result := TCalcTercCollectionItem(inherited Items[Index]);
end;

procedure TCalcTercCollection.SetItem(Index: Integer;
  Value: TCalcTercCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TCalcTercCollection.New: TCalcTercCollectionItem;
begin
  Result := TCalcTercCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfoPerRefCollection }

function TInfoPerRefCollection.Add: TInfoPerRefCollectionItem;
begin
  Result := Self.New;
end;

function TInfoPerRefCollection.GetItem(
  Index: Integer): TInfoPerRefCollectionItem;
begin
  Result := TInfoPerRefCollectionItem(inherited Items[Index]);
end;

procedure TInfoPerRefCollection.SetItem(Index: Integer;
  Value: TInfoPerRefCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfoPerRefCollection.New: TInfoPerRefCollectionItem;
begin
  Result := TInfoPerRefCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfoPerRefCollectionItem }

constructor TInfoPerRefCollectionItem.Create;
begin
  inherited Create;
  
  FDetInfoPerRef := nil;
  FIdeADC := nil;
end;

destructor TInfoPerRefCollectionItem.Destroy;
begin
  if DetInfoPerRefInst() then
    FDetInfoPerRef.Free;
  if IdeADCInst() then
    FIdeADC.Free;

  inherited;
end;

function TInfoPerRefCollectionItem.getDetInfoPerRef: TDetInfoPerRefCollection;
begin
  if not(DetInfoPerRefInst()) then
    FDetInfoPerRef := TDetInfoPerRefCollection.Create;
  Result := FDetInfoPerRef;
end;

function TInfoPerRefCollectionItem.getIdeADC: TIdeAdcCollection;
begin
  if not(IdeADCInst()) then
    FIdeADC := TIdeADCCollection.Create;
  Result := FIdeADC;
end;

function TInfoPerRefCollectionItem.DetInfoPerRefInst(): Boolean;
begin
  Result := Assigned(FDetInfoPerRef);
end;

function TInfoPerRefCollectionItem.IdeADCInst(): Boolean;
begin
  Result := Assigned(FIdeADC);
end;
{ TDetInfoPerRefCollection }

function TDetInfoPerRefCollection.Add: TDetInfoPerRefCollectionItem;
begin
  Result := Self.New;
end;

function TDetInfoPerRefCollection.GetItem(
  Index: Integer): TDetInfoPerRefCollectionItem;
begin
  Result := TDetInfoPerRefCollectionItem(inherited Items[Index]);
end;

procedure TDetInfoPerRefCollection.SetItem(Index: Integer;
  Value: TDetInfoPerRefCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TDetInfoPerRefCollection.New: TDetInfoPerRefCollectionItem;
begin
  Result := TDetInfoPerRefCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfoCompl }
constructor TInfoCompl.Create;
begin
  inherited Create;
  
  FSucessaoVinc  := nil;
  FInfoInterm    := nil;
  FInfoComplCont := nil;
end;

destructor TInfoCompl.Destroy;
begin
  if SucessaoVincInst() then
    FSucessaoVinc.Free;
  if InfoIntermInst() then
    FInfoInterm.Free;
  if InfoComplContInst() then
    FInfoComplCont.Free;
  
  inherited;
end;

function TInfoCompl.getSucessaoVinc(): TSucessaoVinc;
begin
  if not(SucessaoVincInst()) then
    FSucessaoVinc := TSucessaoVinc.Create;
  Result := FSucessaoVinc;
end;

function TInfoCompl.getInfoInterm(): TInfoIntermCollection;
begin
  if not(InfoIntermInst()) then
    FInfoInterm := TInfoIntermCollection.Create;
  Result := FInfoInterm;
end;

function TInfoCompl.getInfoComplCont(): TInfoComplContCollection;
begin
  if not(InfoComplContInst()) then
    FInfoComplCont := TInfoComplContCollection.Create;
  Result := FInfoComplCont;
end;

function TInfoCompl.SucessaoVincInst(): Boolean;
begin
  Result := Assigned(FSucessaoVinc);
end;

function TInfoCompl.InfoIntermInst(): Boolean;
begin
  Result := Assigned(FInfoInterm);
end;

function TInfoCompl.InfoComplContInst(): Boolean;
begin
  Result := Assigned(FInfoComplCont);
end;

{ TIdeADCCollection }

function TIdeADCCollection.Add: TIdeADCCollectionItem;
begin
  Result := Self.New;
end;

function TIdeADCCollection.GetItem(Index: Integer): TIdeADCCollectionItem;
begin
  Result := TIdeADCCollectionItem(inherited Items[Index]);
end;

procedure TIdeADCCollection.SetItem(Index: Integer; Value: TIdeADCCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TIdeADCCollection.New: TIdeADCCollectionItem;
begin
  Result := TIdeADCCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfoComplContCollection }

function TInfoComplContCollection.Add: TInfoComplContCollectionItem;
begin
  Result := Self.New;
end;

function TInfoComplContCollection.GetItem(Index: Integer): TInfoComplContCollectionItem;
begin
  Result := TInfoComplContCollectionItem(inherited Items[Index]);
end;

procedure TInfoComplContCollection.SetItem(Index: Integer; Value: TInfoComplContCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfoComplContCollection.New: TInfoComplContCollectionItem;
begin
  Result := TInfoComplContCollectionItem.Create;
  Self.Add(Result);
end;

{ TinfoPisPasep }

constructor TinfoPisPasep.Create;
begin
  inherited Create;

  FideEstab := TIdeEstabCollection.Create;
end;

destructor TinfoPisPasep.Destroy;
begin
  FideEstab.Free;
  inherited;
end;

{ TEvtBasesTrab }

function TEvtBasesTrab.LerXML: boolean;
var
  ok: Boolean;
  i, j, k, l: Integer;
  s: String;
begin
  Result := False;
  try
    FXML := Leitor.Arquivo;

    // Capturar a vers�o do evento
    s := Copy(FXML, Pos('/evt/evtBasesTrab/', FXML)+18, 16);
    s := Copy(s, 1, Pos('"', s)-1);
    Self.VersaoDF := StrToVersaoeSocialSchemas(s);

    if leitor.rExtrai(1, 'evtBasesTrab') <> '' then
    begin
      FId := Leitor.rAtributo('Id=');

      if leitor.rExtrai(2, 'ideEvento') <> '' then
      begin
        IdeEvento.nrRecArqBase := leitor.rCampo(tcStr, 'nrRecArqBase');
        IdeEvento.IndApuracao  := eSStrToIndApuracao(ok, leitor.rCampo(tcStr, 'IndApuracao'));
        IdeEvento.perApur      := leitor.rCampo(tcStr, 'perApur');
      end; { ideEvento }

      if leitor.rExtrai(2, 'ideEmpregador') <> '' then
      begin
        IdeEmpregador.TpInsc := eSStrToTpInscricao(ok, leitor.rCampo(tcStr, 'tpInsc'));
        IdeEmpregador.NrInsc := leitor.rCampo(tcStr, 'nrInsc');
      end; { ideEmpregador }

      if leitor.rExtrai(2, 'ideTrabalhador') <> '' then
      begin
        IdeTrabalhador.cpfTrab := leitor.rCampo(tcStr, 'cpfTrab');

        if VersaoDF > ve02_05_00 then
        begin
          if leitor.rExtrai(3, 'infoCompl') <> '' then
          begin

            if leitor.rExtrai(4, 'sucessaoVinc') <> '' then
            begin
              IdeTrabalhador.infoCompl.sucessaoVinc.tpInsc    := eSStrToTpInscricao(ok, leitor.rCampo(tcStr, 'tpInsc'));
              IdeTrabalhador.infoCompl.sucessaoVinc.nrInsc    := leitor.rCampo(tcStr, 'nrInsc');
              IdeTrabalhador.infoCompl.sucessaoVinc.matricAnt := leitor.rCampo(tcStr, 'matricAnt');
              IdeTrabalhador.infoCompl.sucessaoVinc.dtAdm     := StringToDateTime(Leitor.rCampo(tcDat, 'dtAdm'));
            end; { sucessaoVinc }

            i := 0;
            while Leitor.rExtrai(4, 'infoInterm', '', i + 1) <> '' do
            begin
              IdeTrabalhador.infoCompl.infoInterm.New;
              IdeTrabalhador.infoCompl.infoInterm.Items[i].dia := leitor.rCampo(tcInt, 'dia');

              if VersaoDF > veS01_02_00 then
                IdeTrabalhador.infoCompl.infoInterm.Items[i].hrsTrab := leitor.rCampo(tcStr, 'hrsTrab');
              inc(i);
            end; { infoInterm }

            if VersaoDF >= veS01_00_00 then
            begin
              i := 0;
              while Leitor.rExtrai(4, 'infoComplCont', '', i + 1) <> '' do
              begin
                IdeTrabalhador.infoCompl.infoComplCont.New;
                IdeTrabalhador.infoCompl.infoComplCont.Items[i].codCBO       := leitor.rCampo(tcStr, 'codCBO');
                IdeTrabalhador.infoCompl.infoComplCont.Items[i].natAtividade := eSStrToNatAtividade(ok, leitor.rCampo(tcStr, 'natAtividade'));
                IdeTrabalhador.infoCompl.infoComplCont.Items[i].qtdDiasTrab  := leitor.rCampo(tcInt, 'qtdDiasTrab');
                inc(i);
              end; { infoComplCont }
            end;
          end; { infoCompl }
        end;

        i := 0;
        while Leitor.rExtrai(3, 'procJudTrab', '', i + 1) <> '' do
        begin
          IdeTrabalhador.procJudTrab.New;
          IdeTrabalhador.procJudTrab.Items[i].nrProcJud := leitor.rCampo(tcStr, 'nrProcJud');
          IdeTrabalhador.procJudTrab.Items[i].codSusp   := leitor.rCampo(tcStr, 'codSusp');
          inc(i);
        end; { procJudTrab }
      end; { ideTrabalhador }

      i := 0;
      while Leitor.rExtrai(2, 'infoCpCalc', '', i + 1) <> '' do
      begin
        infoCpCalc.New;
        infoCpCalc.Items[i].FtpCR      := leitor.rCampo(tcStr, 'tpCR');
        infoCpCalc.Items[i].FvrCpSeg   := leitor.rCampo(tcDe2, 'vrCpSeg');
        infoCpCalc.Items[i].FvrDescSeg := leitor.rCampo(tcDe2, 'vrDescSeg');
        inc(i);
      end; { infoCpCalc }

      if leitor.rExtrai(2, 'infoCp') <> '' then
      begin
        i := 0;
        infoCp.classTrib := StrTotpClassTrib(ok, leitor.rCampo(tcStr,'classTrib'));

        while Leitor.rExtrai(3, 'ideEstabLot', '', i + 1) <> '' do
        begin
          infoCp.IdeEstabLot.New;
          infoCp.IdeEstabLot.Items[i].FtpInsc     := eSStrToTpInscricao(ok, leitor.rCampo(tcStr, 'tpInsc'));
          infoCp.IdeEstabLot.Items[i].FnrInsc     := leitor.rCampo(tcStr, 'nrInsc');
          infoCp.IdeEstabLot.Items[i].FcodLotacao := leitor.rCampo(tcStr, 'codLotacao');

          j := 0;
          while Leitor.rExtrai(4, 'infoCategIncid', '', j + 1) <> '' do
          begin
            infoCp.IdeEstabLot.Items[i].InfoCategIncid.New;
            infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].Fmatricula  := leitor.rCampo(tcStr, 'matricula');
            infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].FcodCateg   := leitor.rCampo(tcInt, 'codCateg');
            infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].FindSimples := eSStrToIndSimples(ok, leitor.rCampo(tcStr, 'indSimples'));

            k := 0;
            while Leitor.rExtrai(5, 'infoBaseCS', '', k + 1) <> '' do
            begin
              infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoBaseCS.New;
              infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoBaseCS.Items[k].Find13   := leitor.rCampo(tcInt, 'ind13');
              infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoBaseCS.Items[k].FtpValor := leitor.rCampo(tcInt, 'tpValor');
              infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoBaseCS.Items[k].Fvalor   := leitor.rCampo(tcDe2, 'valor');
              inc(k);
            end; { infoBaseCS }

            k := 0;
            while Leitor.rExtrai(5, 'calcTerc', '', k + 1) <> '' do
            begin
              infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].CalcTerc.New;
              infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].CalcTerc.Items[k].FtpCR        := leitor.rCampo(tcInt, 'tpCR');
              infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].CalcTerc.Items[k].FvrCsSegTerc := leitor.rCampo(tcDe2, 'vrCsSegTerc');
              infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].CalcTerc.Items[k].FvrDescTerc  := leitor.rCampo(tcDe2, 'vrDescTerc');
              inc(k);
            end; { calcTerc }

            k := 0;
            while Leitor.rExtrai(5, 'infoPerRef', '', k + 1) <> '' do
            begin
              infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.New;
              infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.Items[k].FperRef := leitor.rCampo(tcStr, 'perRef');

              l := 0;
              while Leitor.rExtrai(6, 'ideADC', '', l + 1) <> '' do
              begin
                infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.Items[k].ideADC.New;
                infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.Items[k].ideADC.Items[l].FdtAcConv := leitor.rCampo(tcDat, 'dtAcConv');
                infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.Items[k].ideADC.Items[l].FtpAcConv := eSStrToTpAcConv(ok, leitor.rCampo(tcStr, 'tpAcConv'));
                infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.Items[k].ideADC.Items[l].Fdsc      := leitor.rCampo(tcStr, 'dsc');
                infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.Items[k].ideADC.Items[l].FremunSuc := eSStrToSimNaoFacultativo(ok, leitor.rCampo(tcStr, 'remunSuc'));
                inc(l);
              end; { ideADC }

              l := 0;
              while Leitor.rExtrai(6, 'detInfoPerRef', '', l + 1) <> '' do
              begin
                infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.Items[k].DetInfoPerRef.New;
                infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.Items[k].DetInfoPerRef.Items[l].Find13      := leitor.rCampo(tcInt, 'ind13');
                infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.Items[k].DetInfoPerRef.Items[l].FtpVrPerRef := leitor.rCampo(tcInt, 'tpVrPerRef');
                infoCp.IdeEstabLot.Items[i].InfoCategIncid.Items[j].InfoPerRef.Items[k].DetInfoPerRef.Items[l].FvrPerRef   := leitor.rCampo(tcDe2, 'vrPerRef');
                inc(l);
              end; { detInfoPerRef }

              inc(k);
            end; { infoPerRef }

            inc(j);
          end; { infoCategIncid }

          inc(i);
        end; { ideEstabLot }

      end; { infoCp }

      if VersaoDF > veS01_02_00 then
      begin
        if leitor.rExtrai(2, 'infoPisPasep') <> '' then
        begin
          i := 0;

          while Leitor.rExtrai(3, 'ideEstab', '', i + 1) <> '' do
          begin
            infoPisPasep.ideEstab.New;
            infoPisPasep.ideEstab.Items[i].tpInsc := eSStrToTpInscricao(ok, leitor.rCampo(tcStr, 'tpInsc'));
            infoPisPasep.ideEstab.Items[i].nrInsc := leitor.rCampo(tcStr, 'nrInsc');

            j := 0;
            while Leitor.rExtrai(4, 'infoCategPisPasep', '', j + 1) <> '' do
            begin
              infoPisPasep.ideEstab.Items[i].infoCategPisPasep.New;
              infoPisPasep.ideEstab.Items[i].infoCategPisPasep.Items[j].matricula := leitor.rCampo(tcStr, 'matricula');
              infoPisPasep.ideEstab.Items[i].infoCategPisPasep.Items[j].codCateg  := leitor.rCampo(tcInt, 'codCateg');

              k := 0;
              while Leitor.rExtrai(5, 'infoBasePisPasep', '', k + 1) <> '' do
              begin
                infoPisPasep.ideEstab.Items[i].infoCategPisPasep.Items[j].infoBasePisPasep.New;
                infoPisPasep.ideEstab.Items[i].infoCategPisPasep.Items[j].infoBasePisPasep.Items[k].Find13           := leitor.rCampo(tcInt, 'ind13');
                infoPisPasep.ideEstab.Items[i].infoCategPisPasep.Items[j].infoBasePisPasep.Items[k].FtpValorPisPasep := eSStrToTtpValorPisPasep(leitor.rCampo(tcStr, 'tpValorPisPasep'));
                infoPisPasep.ideEstab.Items[i].infoCategPisPasep.Items[j].infoBasePisPasep.Items[k].FvalorPisPasep   := leitor.rCampo(tcDe2, 'valorPisPasep');

                inc(k);
              end; { infoBasePisPasep }

              inc(j);
            end; { infoCategPisPasep }

            inc(i);
          end; { ideEstab }
        end; { infoPisPasep }
      end;

      Result := True;
    end; { evtBasesTrab }
  except
    Result := False;
  end;
end;

function TEvtBasesTrab.SalvarINI: boolean;
var
  AIni: TMemIniFile;
  sSecao: String;
  i, j, k, l: Integer;
begin
  Result := True;

  AIni := TMemIniFile.Create('');
  try
    with Self do
    begin
      sSecao := 'evtBasesTrab';
      AIni.WriteString(sSecao, 'Id', Id);

      sSecao := 'ideEvento';
      AIni.WriteString(sSecao, 'nrRecArqBase', IdeEvento.nrRecArqBase);
      AIni.WriteString(sSecao, 'IndApuracao',  eSIndApuracaoToStr(IdeEvento.IndApuracao));
      AIni.WriteString(sSecao, 'perApur',      IdeEvento.perApur);

      sSecao := 'ideEmpregador';
      AIni.WriteString(sSecao, 'tpInsc', eSTpInscricaoToStr(IdeEmpregador.TpInsc));
      AIni.WriteString(sSecao, 'nrInsc', IdeEmpregador.nrInsc);

      sSecao := 'ideTrabalhador';
      AIni.WriteString(sSecao, 'cpfTrab', ideTrabalhador.cpfTrab);

      for i := 0 to IdeTrabalhador.procJudTrab.Count -1 do
      begin
        sSecao := 'procJudTrab' + IntToStrZero(I, 2);

        AIni.WriteString(sSecao, 'nrProcJud', IdeTrabalhador.procJudTrab.Items[i].nrProcJud);
        AIni.WriteString(sSecao, 'codSusp',  IdeTrabalhador.procJudTrab.Items[i].codSusp);
      end;

      for i := 0 to infoCpCalc.Count -1 do
      begin
        sSecao := 'infoCpCalc' + IntToStrZero(I, 1);

        AIni.WriteString(sSecao, 'tpCR',     infoCpCalc.Items[i].tpCR);
        AIni.WriteFloat(sSecao, 'vrCpSeg',   infoCpCalc.Items[i].vrCpSeg);
        AIni.WriteFloat(sSecao, 'vrDescSeg', infoCpCalc.Items[i].vrDescSeg);
      end;

      for i := 0 to infoCp.IdeEstabLot.Count -1 do
      begin
        with infoCp.IdeEstabLot.Items[i] do
        begin
          sSecao := 'ideEstabLot' + IntToStrZero(I, 2);

          AIni.WriteString(sSecao, 'tpInsc',     eSTpInscricaoToStr(tpInsc));
          AIni.WriteString(sSecao, 'nrInsc',     nrInsc);
          AIni.WriteString(sSecao, 'codLotacao', codLotacao);

          for j := 0 to infoCategIncid.Count -1 do
          begin
            with InfoCategIncid.Items[j] do
            begin
              sSecao := 'infoCategIncid' + IntToStrZero(I, 2) + IntToStrZero(J, 2);

              AIni.WriteString(sSecao, 'matricula',  matricula);
              AIni.WriteInteger(sSecao, 'codCateg',  codCateg);
              AIni.WriteString(sSecao, 'indSimples', eSIndSimplesToStr(indSimples));

              for k := 0 to infoBaseCS.Count -1 do
              begin
                with infoBaseCS.Items[k] do
                begin
                  sSecao := 'infoBaseCS' + IntToStrZero(I, 2) +
                                     IntToStrZero(J, 2) + IntToStrZero(k, 2);

                  AIni.WriteInteger(sSecao, 'ind13',   ind13);
                  AIni.WriteInteger(sSecao, 'tpValor', tpValor);
                  AIni.WriteFloat(sSecao, 'valor',     valor);
                end;
              end;

              for k := 0 to CalcTerc.Count -1 do
              begin
                with CalcTerc.Items[k] do
                begin
                  sSecao := 'calcTerc' + IntToStrZero(I, 2) +
                                     IntToStrZero(J, 2) + IntToStrZero(k, 1);

                  AIni.WriteInteger(sSecao, 'tpCR',      tpCR);
                  AIni.WriteFloat(sSecao, 'vrCsSegTerc', vrCsSegTerc);
                  AIni.WriteFloat(sSecao, 'vrDescTerc',  vrDescTerc);
                end;
              end;

              for k := 0 to InfoPerRef.Count -1 do
              begin
                with InfoPerRef.Items[k] do
                begin
                  sSecao := 'InfoPerRef' + IntToStrZero(I, 2) +
                                     IntToStrZero(J, 2) + IntToStrZero(k, 1); // italo

                  AIni.WriteString(sSecao, 'perRef', perRef);

                  for l := 0 to detInfoPerRef.Count -1 do
                  begin
                    with detInfoPerRef.Items[l] do
                    begin
                      sSecao := 'detInfoPerRef' + IntToStrZero(I, 2) +
                                         IntToStrZero(J, 2) + IntToStrZero(k, 1) +
                                         IntToStrZero(l, 1); // italo

                      AIni.WriteInteger(sSecao, 'ind13',    ind13);
                      AIni.WriteInteger(sSecao, 'tpValor',  tpValor);
                      AIni.WriteFloat(  sSecao, 'vrPerRef', vrPerRef);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    AIni.Free;
  end;
end;

end.
