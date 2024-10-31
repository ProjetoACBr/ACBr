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

unit pcesS2555;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrBase,
  ACBrDFeConsts,
  pcnConversao, pcnGerador,
  pcesCommon, pcesConversaoeSocial, pcesGerador, pcnLeitor;

type

  TIdeProc = class(TObject)
  private
    FnrProcTrab: String;
    FperApurPgto: String;
  public
    property nrProcTrab: String read FnrProcTrab write FnrProcTrab;
    property perApurPgto: String read FperApurPgto write FperApurPgto;
  end;

  TEvtConsolidContProc = class(TeSocialEvento)
  private
    FIdeEvento: TIdeEvento;
    FIdeEmpregador: TIdeEmpregador;
    FIdeProc: TIdeProc;
    procedure GerarIdeProc;
  public
    constructor Create(AACBreSocial: TObject); override;
    destructor Destroy; override;

    function GerarXML: Boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property ideEvento: TIdeEvento read FideEvento write FideEvento;
    property ideEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property ideProc: TIdeProc read FIdeProc write FIdeProc;
  end;

  TS2555CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FevtConsolidContProc: TEvtConsolidContProc;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property TipoEvento: TTipoEvento read FTipoEvento write FTipoEvento;
    property evtConsolidContProc: TEvtConsolidContProc read FevtConsolidContProc write FevtConsolidContProc;
  end;

  TS2555Collection = class(TeSocialCollection)
  private
    function GetItem(Index: Integer): TS2555CollectionItem;
    procedure SetItem(Index: Integer; const Value: TS2555CollectionItem);
  public
    function Add: TS2555CollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TS2555CollectionItem;
    property Items[Index: Integer]: TS2555CollectionItem read GetItem write SetItem; default;
  end;

implementation

uses
  ACBreSocial, IniFiles, ACBrutil.FilesIO;

{ TS2555Collection }

function TS2555Collection.Add: TS2555CollectionItem;
begin
  Result := Self.New;
end;

function TS2555Collection.GetItem(Index: Integer): TS2555CollectionItem;
begin
  Result := TS2555CollectionItem(inherited Items[Index]);
end;

function TS2555Collection.New: TS2555CollectionItem;
begin
  Result := TS2555CollectionItem.Create(FACBreSocial);
  Self.Add(Result);
end;

procedure TS2555Collection.SetItem(Index: Integer;
  const Value: TS2555CollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TS2555CollectionItem }

constructor TS2555CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;
  FTipoEvento := teS2555;
  FevtConsolidContProc := TEvtConsolidContProc.Create(AOwner);
end;

destructor TS2555CollectionItem.Destroy;
begin
  FevtConsolidContProc.Free;
  inherited;
end;

{ TEvtConsolidContProc }

constructor TEvtConsolidContProc.Create(AACBreSocial: TObject);
begin
  inherited Create(AACbreSocial);
  FIdeEvento := TIdeEvento.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeProc := TIdeProc.Create;
end;

destructor TEvtConsolidContProc.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeProc.Free;
  inherited;
end;

procedure TEvtConsolidContProc.GerarIdeProc;
begin
  Gerador.wGrupo('ideProc');
  Gerador.wCampo(tcStr, '', 'nrProcTrab', 15, 20, 1, Self.ideProc.nrProcTrab);
  Gerador.wCampo(tcStr, '', 'perApurPgto', 01, 07, 1, Self.ideProc.perApurPgto);
  Gerador.wGrupo('/ideProc');
end;

function TEvtConsolidContProc.GerarXML: Boolean;
begin
  try
    inherited GerarXML;
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
    Self.Id := GerarChaveEsocial(now, Self.ideEmpregador.NrInsc, Self.Sequencial);

    GerarCabecalho('evtConsolidContProc');
    Gerador.wGrupo('evtConsolidContProc Id="' + Self.Id + '"');

    GerarIdeEvento(Self.ideEvento, True);
    GerarIdeEmpregador(Self.ideEmpregador);
    GerarIdeProc;

    Gerador.wGrupo('/evtConsolidContProc');
    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;

  except
    on E:Exception do
      raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;
end;

function TEvtConsolidContProc.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  sSecao: String;
  OK: Boolean;
begin
  Result := True;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    sSecao := 'evtConsolidContProc';
    Id := INIRec.ReadString(sSecao, 'Id', '');
    Sequencial := INIRec.ReadInteger(sSecao, 'Sequencial', 0);

    sSecao := 'ideEvento';
    ideEvento.ProcEmi := eSStrToprocEmi(Ok, INIRec.ReadString(sSecao, 'procEmi', '1'));
    ideEvento.VerProc := INIRec.ReadString(sSecao, 'verProc', '');

    sSecao := 'ideEmpregador';
    ideEmpregador.TpInsc := eSStrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', ''));
    ideEmpregador.nrInsc := INIRec.ReadString(sSecao, 'nrInsc', '');

    sSecao := 'ideProc';
    ideProc.nrProcTrab := INIRec.ReadString(sSecao, 'nrProcTrab', '');
    ideProc.perApurPgto := INIRec.ReadString(sSecao, 'perApurPgto', '');

    GerarXML;
    XML := FXML;

  finally
    INIRec.Free;
  end;
end;

end.
