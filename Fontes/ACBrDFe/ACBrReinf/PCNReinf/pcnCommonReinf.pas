{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Leivio Ramos de Fontenele                       }
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

{$I ACBr.inc}

unit pcnCommonReinf;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  pcnConversaoReinf;

const
  dDataBrancoNula = '30/12/1899';

type
  {Classes existentes nesta unit}
  TReinf = class;
  TStatus = class;
  TOcorrenciasCollection = class;
  TOcorrenciasCollectionItem = class;
  TIdeEvento = class;
  TIdeEvento1 = class;
  TIdeEvento2 = class;
  TIdeEvento3 = class;
  TInscricao = class;
  TideContri = class;
  TideContrib = class;
  TinfoComplContri = class;
  TIdeTransmissor = class;
  TidePeriodo = class;
  TideStatus = class;
  TregOcorrsCollection = class;
  TregOcorrsCollectionItem = class;

  IEventoReinf = Interface;

  TReinfCollection = class(TACBrObjectList)
  public
    FACBrReinf: TComponent;

    constructor Create(AACBrReinf: TComponent); reintroduce; virtual;
  end;

  TReinf = class(TObject)
  private
    FId: string;
    FSequencial: Integer;
  public
    property Id: string read FId write FId;
    property Sequencial: Integer read FSequencial write FSequencial;
  end;

  { TStatus }
  TStatus = class(TObject)
  private
    FcdStatus: Integer;
    FdescRetorno: string;
    FOcorrencias: TOcorrenciasCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property cdStatus: Integer read FcdStatus write FcdStatus;
    property descRetorno: string read FdescRetorno write FdescRetorno;
    property Ocorrencias: TOcorrenciasCollection read FOcorrencias write FOcorrencias;
  end;

  TOcorrenciasCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TOcorrenciasCollectionItem;
    procedure SetItem(Index: Integer; Value: TOcorrenciasCollectionItem);
  public
    function Add: TOcorrenciasCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TOcorrenciasCollectionItem;

    property Items[Index: Integer]: TOcorrenciasCollectionItem read GetItem write SetItem;
  end;

  TOcorrenciasCollectionItem = class(TObject)
  private
    FCodigo: Integer;
    FDescricao: String;
    FTipo: Byte;
    FLocalizacao: String;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: String read FDescricao write FDescricao;
    property Tipo: Byte read FTipo write FTipo;
    property Localizacao: String read FLocalizacao write FLocalizacao;
  end;

  TIdeEvento = class(TObject)
  private
    FProcEmi: TProcEmi;
    FVerProc: string;
    FretifS1250 : string;
  public
    property ProcEmi: TProcEmi read FProcEmi write FProcEmi;
    property VerProc: string read FVerProc write FVerProc;
    property retifS1250: string read FretifS1250 write FretifS1250;
  end;

  { TIdeEvento1 }
  TIdeEvento1 = class(TObject)
  private
    FperApur: string;
  public
    property perApur: string read FperApur write FperApur;
  end;

  TIdeEvento2 = class(TideEvento)
  private
    FIndRetif: TIndRetificacao;
    FNrRecibo: string;
    FPerApur: string;
  public
    property indRetif: TIndRetificacao read FIndRetif write FIndRetif;
    property NrRecibo: string read FNrRecibo write FNrRecibo;
    property perApur: string read FPerApur write FPerApur;
  end;

  TIdeEvento3 = class(TideEvento)
  private
    FIndRetif: TIndRetificacao;
    FNrRecibo: string;
    FdtApuracao: TDateTime;
  public
    property indRetif: TIndRetificacao read FIndRetif write FIndRetif;
    property NrRecibo: string read FNrRecibo write FNrRecibo;
    property dtApuracao: TDateTime read FdtApuracao write FdtApuracao;
  end;

  TInscricao = class(TObject)
  protected
    FTpInsc: TtpInsc;
    FNrInsc: string;
  public
    property TpInsc: TtpInsc read FTpInsc write FTpInsc;
    property NrInsc: string read FNrInsc write FNrInsc;
  end;

  TideContri = class(TInscricao)
  private
    FOrgaoPublico: Boolean;
    FinfoComplContri: TinfoComplContri;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AfterConstruction; override;
    property OrgaoPublico: Boolean read FOrgaoPublico write FOrgaoPublico;
    property infoComplContri: TinfoComplContri read FinfoComplContri write FinfoComplContri;
  end;

  { TinfoComplContri }
  TinfoComplContri = class(TObject)
  private
    FnatJur: string;
  public
    property natJur: string read FnatJur write FnatJur;
  end;

  { TideContrib }
  TideContrib = class(TInscricao);

  { TIdeTransmissor }
  TIdeTransmissor = class
  private
    FIdTransmissor: string;
  public
    property IdTransmissor: string read FIdTransmissor write FIdTransmissor;
  end;

  TIdePeriodo = class(TObject)
  private
    FIniValid: string;
    FFimValid: string;
  public
    property IniValid: string read FIniValid write FIniValid;
    property FimValid: string read FFimValid write FFimValid;
  end;

  { TideStatus }
  TideStatus = class(TObject)
  private
    FcdRetorno: String;
    FdescRetorno: string;
    FregOcorrs: TregOcorrsCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property cdRetorno: String read FcdRetorno write FcdRetorno;
    property descRetorno: string read FdescRetorno write FdescRetorno;
    property regOcorrs: TregOcorrsCollection read FregOcorrs write FregOcorrs;
  end;

  TregOcorrsCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TregOcorrsCollectionItem;
    procedure SetItem(Index: Integer; Value: TregOcorrsCollectionItem);
  public
    function Add: TregOcorrsCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TregOcorrsCollectionItem;

    property Items[Index: Integer]: TregOcorrsCollectionItem read GetItem write SetItem;
  end;

  TregOcorrsCollectionItem = class(TObject)
  private
    FtpOcorr: Integer;
    FlocalErroAviso: String;
    FcodResp: String;
    FdscResp: String;
  public
    property tpOcorr: Integer read FtpOcorr write FtpOcorr;
    property localErroAviso: String read FlocalErroAviso write FlocalErroAviso;
    property codResp: String read FcodResp write FcodResp;
    property dscResp: String read FdscResp write FdscResp;
  end;

  IEventoReinf = Interface(IInterface)
  ['{35B759CA-56D7-420A-B110-58736AD39308}']
    function GetXml: string;
    procedure SetXml(const Value: string);
    function GetTipoEvento: TTipoEvento;
    function GetEvento: TObject;

    property Xml: String read GetXml write SetXml;
    property TipoEvento: TTipoEvento read GetTipoEvento;
  end;

implementation

{ TideContri }

procedure TideContri.AfterConstruction;
begin
  inherited;
  FOrgaoPublico := False;
end;

constructor TideContri.Create;
begin
  FinfoComplContri := TinfoComplContri.Create;
end;

destructor TideContri.Destroy;
begin
  FinfoComplContri.Free;

  inherited;
end;

{ TideStatus }

constructor TideStatus.Create;
begin
  FregOcorrs := TregOcorrsCollection.Create;
end;

destructor TideStatus.Destroy;
begin
  FregOcorrs.Free;

  inherited;
end;

{ TregOcorrsCollection }

function TregOcorrsCollection.Add: TregOcorrsCollectionItem;
begin
  Result := Self.New;
end;

function TregOcorrsCollection.GetItem(
  Index: Integer): TregOcorrsCollectionItem;
begin
  Result := TregOcorrsCollectionItem(inherited Items[Index]);
end;

function TregOcorrsCollection.New: TregOcorrsCollectionItem;
begin
  Result := TregOcorrsCollectionItem.Create;
  Self.Add(Result);
end;

procedure TregOcorrsCollection.SetItem(Index: Integer;
  Value: TregOcorrsCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TStatus }

constructor TStatus.Create;
begin
  FOcorrencias := TOcorrenciasCollection.Create;
end;

destructor TStatus.Destroy;
begin
  FOcorrencias.Free;

  inherited;
end;

{ TOcorrenciasCollection }

function TOcorrenciasCollection.Add: TOcorrenciasCollectionItem;
begin
  Result := Self.New;
end;

function TOcorrenciasCollection.GetItem(
  Index: Integer): TOcorrenciasCollectionItem;
begin
  Result := TOcorrenciasCollectionItem(inherited Items[Index]);
end;

function TOcorrenciasCollection.New: TOcorrenciasCollectionItem;
begin
  Result := TOcorrenciasCollectionItem.Create;
  Self.Add(Result);
end;

procedure TOcorrenciasCollection.SetItem(Index: Integer;
  Value: TOcorrenciasCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TReinfCollection }

constructor TReinfCollection.Create(AACBrReinf: TComponent);
begin
  inherited Create;

  FACBrReinf := AACBrReinf;
end;

end.
