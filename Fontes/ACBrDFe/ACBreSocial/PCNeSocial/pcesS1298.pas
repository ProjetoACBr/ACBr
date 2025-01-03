{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit pcesS1298;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$ELSE}
   Contnrs,
  {$IFEND}
  ACBrBase,
  pcnConversao,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS1298CollectionItem = class;
  TEvtReabreEvPer = class;

  TS1298Collection = class(TeSocialCollection)
  private
    function GetItem(Index: Integer): TS1298CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1298CollectionItem);
  public
    function Add: TS1298CollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TS1298CollectionItem;
    property Items[Index: Integer]: TS1298CollectionItem read GetItem write SetItem; default;
  end;

  TS1298CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FEvtReabreEvPer: TEvtReabreEvPer;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtReabreEvPer: TEvtReabreEvPer read FEvtReabreEvPer write FEvtReabreEvPer;
  end;

  TEvtReabreEvPer = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento4;
    FIdeEmpregador: TIdeEmpregador;

    {Geradores espec�ficos da classe}
  public
    constructor Create(AACBreSocial: TObject); override;
    destructor  Destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property IdeEvento: TIdeEvento4 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
  end;

implementation

uses
  IniFiles,
  ACBrUtil.FilesIO,
  ACBreSocial;

{ TS1298Collection }

function TS1298Collection.Add: TS1298CollectionItem;
begin
  Result := Self.New;
end;

function TS1298Collection.GetItem(Index: Integer): TS1298CollectionItem;
begin
  Result := TS1298CollectionItem(inherited Items[Index]);
end;

procedure TS1298Collection.SetItem(Index: Integer; Value: TS1298CollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TS1298Collection.New: TS1298CollectionItem;
begin
  Result := TS1298CollectionItem.Create(FACBreSocial);
  Self.Add(Result);
end;

{TS1298CollectionItem}
constructor TS1298CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;
  FTipoEvento     := teS1298;
  FEvtReabreEvPer := TEvtReabreEvPer.Create(AOwner);
end;

destructor TS1298CollectionItem.Destroy;
begin
  FEvtReabreEvPer.Free;

  inherited;
end;

{ TEvtSolicTotal }
constructor TEvtReabreEvPer.Create(AACBreSocial: TObject);
begin
  inherited Create(AACBreSocial);

  FIdeEvento     := TIdeEvento4.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
end;

destructor TEvtReabreEvPer.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;

  inherited;
end;

function TEvtReabreEvPer.GerarXML: boolean;
begin
  try
    inherited GerarXML;
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtReabreEvPer');
    Gerador.wGrupo('evtReabreEvPer Id="' + Self.Id + '"');

    GerarIdeEvento4(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);

    Gerador.wGrupo('/evtReabreEvPer');

    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;
//    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtReabreEvPer');

//    Validar(schevtReabreEvPer);
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtReabreEvPer.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  Ok: Boolean;
  sSecao: String;
begin
  Result := True;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with Self do
    begin
      sSecao := 'evtReabreEvPer';
      Id         := INIRec.ReadString(sSecao, 'Id', '');
      Sequencial := INIRec.ReadInteger(sSecao, 'Sequencial', 0);

      sSecao := 'ideEvento';
      ideEvento.IndApuracao := eSStrToIndApuracao(Ok, INIRec.ReadString(sSecao, 'indApuracao', '1'));
      ideEvento.perApur     := INIRec.ReadString(sSecao, 'perApur', EmptyStr);
      ideEvento.indGuia     := INIRec.ReadString(sSecao, 'indGuia', EmptyStr);
      ideEvento.ProcEmi     := eSStrToProcEmi(Ok, INIRec.ReadString(sSecao, 'procEmi', '1'));
      ideEvento.VerProc     := INIRec.ReadString(sSecao, 'verProc', EmptyStr);

      sSecao := 'ideEmpregador';
      ideEmpregador.OrgaoPublico := (TACBreSocial(FACBreSocial).Configuracoes.Geral.TipoEmpregador = teOrgaoPublico);
      ideEmpregador.TpInsc       := eSStrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', '1'));
      ideEmpregador.NrInsc       := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);
    end;

    GerarXML;
    XML := FXML;
  finally
    INIRec.Free;
  end;
end;

end.
