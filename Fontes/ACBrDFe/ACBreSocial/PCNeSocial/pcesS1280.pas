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

unit pcesS1280;

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
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS1280Collection = class;
  TS1280CollectionItem = class;
  TEvtInfoComplPer = class;
  TInfoSubstPatrOpPortItem = class;
  TInfoSubstPatrOpPortColecao = class;
  TInfoSubstPatr = class;
  TInfoAtivConcom = class;
  TinfoPercTransf11096 = class;

  TS1280Collection = class(TeSocialCollection)
  private
    function GetItem(Index: Integer): TS1280CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1280CollectionItem);
  public
    function Add: TS1280CollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TS1280CollectionItem;
    property Items[Index: Integer]: TS1280CollectionItem read GetItem write SetItem; default;
  end;

  TS1280CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FEvtInfoComplPer: TEvtInfoComplPer;
  public
    constructor Create(AOwner: TComponent);
    destructor  Destroy; override;
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtInfoComplPer: TEvtInfoComplPer read FEvtInfoComplPer write FEvtInfoComplPer;
  end;

  TEvtInfoComplPer = class(TESocialEvento)
  private
    FClassTrib: TpClassTrib;
    FIdeEvento: TIdeEvento3;
    FIdeEmpregador: TIdeEmpregador;
    FInfoSubstPatr: TInfoSubstPatr;
    FInfoAtivConcom: TInfoAtivConcom;
    FInfoSubstPatrOpPort: TInfoSubstPatrOpPortColecao;
    FinfoPercTransf11096 : TinfoPercTransf11096;

    {Geradores espec�ficos da classe}
    procedure GerarInfoSubstPatr;
    procedure GerarInfoSubstPatrOpPort;
    procedure GerarInfoAtivConcom;
    procedure GerarinfoPercTransf11096;
    function getInfoAtivConcom: TInfoAtivConcom;
    function getInfoSubstPatr: TInfoSubstPatr;
    function getInfoSubstPatrOpPort: TInfoSubstPatrOpPortColecao;
    function getinfoPercTransf11096: TinfoPercTransf11096;

  public
    constructor Create(AACBreSocial: TObject); override;
    destructor  Destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    function infoAtivConcomInst(): Boolean;
    function infoSubstPatrInst(): Boolean;
    function infoSubstPatrOpPortInst(): Boolean;
    function infoPercTransf11096Inst(): Boolean;

    property ClassTrib: TpClassTrib read FClassTrib write FClassTrib;
    property IdeEvento: TIdeEvento3 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property InfoSubstPatr: TInfoSubstPatr read getInfoSubstPatr write FInfoSubstPatr;
    property InfoAtivConcom: TInfoAtivConcom read getInfoAtivConcom write FInfoAtivConcom;
    property InfoSubstPatrOpPort: TInfoSubstPatrOpPortColecao read getInfoSubstPatrOpPort write FInfoSubstPatrOpPort;
    property infoPercTransf11096 : TinfoPercTransf11096 read getinfoPercTransf11096 write FinfoPercTransf11096;
  end;

  TInfoSubstPatr = class(TObject)
  private
    FindSubstPatr: tpIndSubstPatr;
    FpercRedContrib: double;
  public
    property indSubstPatr: tpIndSubstPatr read FindSubstPatr write FindSubstPatr;
    property percRedContrib: double read FpercRedContrib write FpercRedContrib;
  end;

  TInfoSubstPatrOpPortItem = class(TObject)
  private
    FcnpjOpPortuario : string;
    FcodLotacao      : string;
  public
    property cnpjOpPortuario: string read FcnpjOpPortuario write FcnpjOpPortuario;
    property codLotacao: string read FcodLotacao write FcodLotacao;
  end;

  TInfoSubstPatrOpPortColecao = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoSubstPatrOpPortItem;
    procedure SetItem(Index: Integer; const Value: TInfoSubstPatrOpPortItem);
  public
    function Add: TInfoSubstPatrOpPortItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfoSubstPatrOpPortItem;
    property Items[Index: Integer]: TInfoSubstPatrOpPortItem read GetItem write SetItem;
  end;

  TinfoPercTransf11096 = class(TObject)
  private
    FpercTransf: Integer;
  public
    property percTransf : Integer read FpercTransf write FpercTransf;
  end;


  TInfoAtivConcom = class(TObject)
  private
    FfatorMes: Double;
    Ffator13: Double;
  public
    property fatorMes: Double read FfatorMes write FfatorMes;
    property fator13: Double read Ffator13 write Ffator13;
  end;

implementation

uses
  IniFiles,
  ACBrUtil.Base,
  ACBrUtil.FilesIO,
  ACBreSocial;

{ TS1280Collection }

function TS1280Collection.Add: TS1280CollectionItem;
begin
  Result := Self.New;
end;

function TS1280Collection.GetItem(Index: Integer): TS1280CollectionItem;
begin
  Result := TS1280CollectionItem(inherited Items[Index]);
end;

procedure TS1280Collection.SetItem(Index: Integer;
  Value: TS1280CollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TS1280Collection.New: TS1280CollectionItem;
begin
  Result := TS1280CollectionItem.Create(FACBreSocial);
  Self.Add(Result);
end;

{TS1280CollectionItem}
constructor TS1280CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;
  FTipoEvento      := teS1280;
  FEvtInfoComplPer := TEvtInfoComplPer.Create(AOwner);
end;

destructor TS1280CollectionItem.Destroy;
begin
  FEvtInfoComplPer.Free;
  inherited;
end;

{ TEvtSolicTotal }
constructor TEvtInfoComplPer.Create(AACBreSocial: TObject);
begin
  inherited Create(AACBreSocial);

  FIdeEvento           := TIdeEvento3.Create;
  FIdeEmpregador       := TIdeEmpregador.Create;
  FInfoSubstPatrOpPort := nil;
  FInfoSubstPatr       := nil;
  FInfoAtivConcom      := nil;
  FinfoPercTransf11096 := nil;
end;

destructor TEvtInfoComplPer.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FInfoSubstPatr.Free;
  FInfoSubstPatrOpPort.Free;
  FInfoAtivConcom.Free;
  FinfoPercTransf11096.Free;

  inherited;
end;

procedure TEvtInfoComplPer.GerarInfoAtivConcom;
begin
  if (FClassTrib = ct03) or (InfoAtivConcom.fatorMes <> 0) then
  begin
    Gerador.wGrupo('infoAtivConcom');

    Gerador.wCampo(tcDe2, '', 'fatorMes', 1, 5, 1, InfoAtivConcom.fatorMes);
    Gerador.wCampo(tcDe2, '', 'fator13',  1, 5, 1, InfoAtivConcom.fator13);

    Gerador.wGrupo('/infoAtivConcom');
  end;
end;

procedure TEvtInfoComplPer.GerarinfoPercTransf11096;
begin
  if VersaoDF > ve02_05_00 then
    if infoPercTransf11096.percTransf > 0 then
    begin
      Gerador.wGrupo('infoPercTransf11096');

      Gerador.wCampo(tcStr, '', 'percTransf', 1, 1, 1, infoPercTransf11096.percTransf);

      Gerador.wGrupo('/infoPercTransf11096');
    end;

end;

procedure TEvtInfoComplPer.GerarInfoSubstPatr;
begin
  if infoSubstPatr.indSubstPatr <> spVazio then
  begin
    Gerador.wGrupo('infoSubstPatr');
  
    Gerador.wCampo(tcStr, '', 'indSubstPatr',   1, 1, 1, eSIndSubstPatrStr(InfoSubstPatr.indSubstPatr));
    Gerador.wCampo(tcDe2, '', 'percRedContrib', 1, 5, 1, InfoSubstPatr.percRedContrib);
  
    Gerador.wGrupo('/infoSubstPatr');
  end;
end;

procedure TEvtInfoComplPer.GerarInfoSubstPatrOpPort;
var
  i: Integer;
  objInfoSubstPatrOpPortItem: TInfoSubstPatrOpPortItem;
begin
  for i := 0 to InfoSubstPatrOpPort.Count - 1 do
  begin
    objInfoSubstPatrOpPortItem := InfoSubstPatrOpPort.Items[i];

    Gerador.wGrupo('infoSubstPatrOpPort');

    if VersaoDF <= ve02_05_00 then
      Gerador.wCampo(tcStr, '', 'cnpjOpPortuario', 14, 14, 1, objInfoSubstPatrOpPortItem.cnpjOpPortuario)
    else
      Gerador.wCampo(tcStr, '', 'codLotacao ', 30, 30, 1, objInfoSubstPatrOpPortItem.codLotacao);

    Gerador.wGrupo('/infoSubstPatrOpPort');
  end;

  if InfoSubstPatrOpPort.Count > 9999 then
    Gerador.wAlerta('', 'infoSubstPatrOpPort', 'Lista de Operadores Portuarios', ERR_MSG_MAIOR_MAXIMO + '9999');
end;

function TEvtInfoComplPer.GerarXML: boolean;
begin
  try
    inherited GerarXML;
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtInfoComplPer');
    Gerador.wGrupo('evtInfoComplPer Id="' + Self.Id + '"');

    GerarIdeEvento3(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);

    if (infoSubstPatrInst) then
      GerarInfoSubstPatr;
    if (infoSubstPatrOpPortInst) then
      GerarInfoSubstPatrOpPort;
    if (infoAtivConcomInst) then
      GerarInfoAtivConcom;
    if (infoPercTransf11096Inst) then
      GerarinfoPercTransf11096;

    Gerador.wGrupo('/evtInfoComplPer');

    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;
//    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtInfoComplPer');

//    Validar(schevtInfoComplPer);
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtInfoComplPer.getInfoAtivConcom: TInfoAtivConcom;
begin
  if not (Assigned(FInfoAtivConcom)) then
    FInfoAtivConcom := TInfoAtivConcom.Create;
  Result := FInfoAtivConcom;
end;

function TEvtInfoComplPer.getinfoPercTransf11096: TinfoPercTransf11096;
begin
  if not (Assigned(FinfoPercTransf11096)) then
    FinfoPercTransf11096 := TinfoPercTransf11096.Create;
  Result := FinfoPercTransf11096;
end;

function TEvtInfoComplPer.getInfoSubstPatr: TInfoSubstPatr;
begin
  if not (Assigned(FInfoSubstPatr)) then
    FInfoSubstPatr := TInfoSubstPatr.Create;
  Result := FInfoSubstPatr;
end;

function TEvtInfoComplPer.getInfoSubstPatrOpPort: TInfoSubstPatrOpPortColecao;
begin
  if not (Assigned(FInfoSubstPatrOpPort)) then
    FInfoSubstPatrOpPort := TInfoSubstPatrOpPortColecao.Create;
  Result := FInfoSubstPatrOpPort;
end;

function TEvtInfoComplPer.infoAtivConcomInst: Boolean;
begin
  Result := Assigned(FInfoAtivConcom);
end;

function TEvtInfoComplPer.infoPercTransf11096Inst: Boolean;
begin
   Result := Assigned(FinfoPercTransf11096);
end;

function TEvtInfoComplPer.infoSubstPatrInst: Boolean;
begin
  Result := Assigned(FInfoSubstPatr);
end;

function TEvtInfoComplPer.infoSubstPatrOpPortInst: Boolean;
begin
  Result := Assigned(FInfoSubstPatrOpPort);
end;

{ TInfoSubstPatrOpPortColecao }
function TInfoSubstPatrOpPortColecao.Add: TInfoSubstPatrOpPortItem;
begin
  Result := Self.New;
end;

function TInfoSubstPatrOpPortColecao.GetItem(Index: Integer): TInfoSubstPatrOpPortItem;
begin
  Result := TInfoSubstPatrOpPortItem(inherited Items[Index]);
end;

procedure TInfoSubstPatrOpPortColecao.SetItem(Index: Integer; const Value: TInfoSubstPatrOpPortItem);
begin
  inherited Items[Index] := Value;
end;

function TEvtInfoComplPer.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  Ok: Boolean;
  sSecao, sFim: String;
  I: Integer;
begin
  Result := True;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with Self do
    begin
      sSecao := 'evtInfoComplPer';
      Id         := INIRec.ReadString(sSecao, 'Id', '');
      Sequencial := INIRec.ReadInteger(sSecao, 'Sequencial', 0);

      sSecao := 'ideEvento';
      ideEvento.indRetif    := eSStrToIndRetificacao(Ok, INIRec.ReadString(sSecao, 'indRetif', '1'));
      ideEvento.NrRecibo    := INIRec.ReadString(sSecao, 'nrRecibo', EmptyStr);
      ideEvento.IndApuracao := eSStrToIndApuracao(Ok, INIRec.ReadString(sSecao, 'indApuracao', '1'));
      ideEvento.perApur     := INIRec.ReadString(sSecao, 'perApur', EmptyStr);
      ideEvento.indGuia     := INIRec.ReadString(sSecao, 'indGuia', EmptyStr);
      ideEvento.ProcEmi     := eSStrToProcEmi(Ok, INIRec.ReadString(sSecao, 'procEmi', '1'));
      ideEvento.VerProc     := INIRec.ReadString(sSecao, 'verProc', EmptyStr);

      sSecao := 'ideEmpregador';
      ideEmpregador.OrgaoPublico := (TACBreSocial(FACBreSocial).Configuracoes.Geral.TipoEmpregador = teOrgaoPublico);
      ideEmpregador.TpInsc       := eSStrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', '1'));
      ideEmpregador.NrInsc       := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);

      sSecao := 'infoSubstPatr';
      if INIRec.ReadString(sSecao, 'indSubstPatr', '') <> ''then
      begin
        infoSubstPatr.indSubstPatr   := eSStrToIndSubstPatr(Ok, INIRec.ReadString(sSecao, 'indSubstPatr', '1'));
        infoSubstPatr.percRedContrib := StringToFloatDef(INIRec.ReadString(sSecao, 'percRedContrib', ''), 0);
      end;

      I := 1;
      while true do
      begin
        // de 0000 at� 9999
        sSecao := 'infoSubstPatrOpPort' + IntToStrZero(I, 4);
        sFim   := INIRec.ReadString(sSecao, 'codLotacao', 'FIM');

        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with infoSubstPatrOpPort.New do
        begin
          codLotacao := sFim;
          cnpjOpPortuario := INIRec.ReadString(sSecao, 'cnpjOpPortuario', EmptyStr);
        end;

        Inc(I);
      end;

      sSecao := 'infoAtivConcom';
      InfoAtivConcom.fatorMes := StringToFloatDef(INIRec.ReadString(sSecao, 'fatorMes', ''), 0);
      InfoAtivConcom.fator13  := StringToFloatDef(INIRec.ReadString(sSecao, 'fator13', ''), 0);

      sSecao := 'infoPercTransf11096';
      sFim := INIRec.ReadString(sSecao, 'percTrans', INIRec.ReadString(sSecao, 'percTransf', ''));
      if Trim(sFim) <> '' then
        infoPercTransf11096.percTransf  := StrToIntDef(sFim, 0);
    end;

    GerarXML;
    XML := FXML;
  finally
    INIRec.Free;
  end;
end;

function TInfoSubstPatrOpPortColecao.New: TInfoSubstPatrOpPortItem;
begin
  Result := TInfoSubstPatrOpPortItem.Create;
  Self.Add(Result);
end;

end.
