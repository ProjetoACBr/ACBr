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

unit pcesS2260;

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
  ACBrBase, pcnConversao,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  Tjornada = class(TObject)
  private
    FcodHorContrat: string;
    FdscJornada: string;
  public
    property codHorContrat: string read FcodHorContrat write FcodHorContrat;
    property dscJornada: string read FdscJornada write FdscJornada;
  end;

  TlocalTrab = class(TObject)
  private
    FindLocal: string;
    FlocalTrabInterm: TBrasil;
  public
    constructor Create;
    destructor Destroy; override;

    property indLocal: string read FindLocal write FindLocal;
    property localTrabInterm: TBrasil read FlocalTrabInterm write FlocalTrabInterm;
  end;

  TInfoConvInterm = class(TObject)
  private
    FcodConv: string;
    FdtInicio: TDateTime;
    FdtFim: TDateTime;
    FdtPrevPgto: TDateTime;
    Fjornada : Tjornada;
    FlocalTrab: TlocalTrab;
  public
    constructor Create;
    destructor Destroy; override;

    property codConv: string read FcodConv write FcodConv;
    property dtInicio: TDateTime read FdtInicio write FdtInicio;
    property dtFim: TDateTime read FdtFim write FdtFim;
    property dtPrevPgto: TDateTime read FdtPrevPgto write FdtPrevPgto;
    property jornada: Tjornada read Fjornada write Fjornada;
    property localTrab: TlocalTrab read FlocalTrab write FlocalTrab;
  end;

  TEvtConvInterm = class(TeSocialEvento)
  private
    FIdeEvento: TIdeEvento2;
    FIdeEmpregador: TIdeEmpregador;
    FIdeVinculo: TIdeVinculo;
    FInfoConvInterm: TInfoConvInterm;

    procedure GerarInfoConvInterm;
    procedure Gerarjornada;
    procedure GerarlocalTrab;
  public
    constructor Create(AACBreSocial: TObject); override;
    destructor  Destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property IdeEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeVinculo: TIdeVinculo read FIdeVinculo write FIdeVinculo;

    property InfoConvInterm: TInfoConvInterm read FInfoConvInterm write FInfoConvInterm;
  end;

  TS2260CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FEvtConvInterm: TEvtConvInterm;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtConvInterm: TEvtConvInterm read FEvtConvInterm write FEvtConvInterm;
  end;

  TS2260Collection = class(TeSocialCollection)
  private
    function GetItem(Index: Integer): TS2260CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2260CollectionItem);
  public
    function Add: TS2260CollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TS2260CollectionItem;
    property Items[Index: Integer]: TS2260CollectionItem read GetItem write SetItem; default;
  end;

implementation

uses
  IniFiles,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime,
  ACBreSocial;

{ TS2260Collection }

function TS2260Collection.Add: TS2260CollectionItem;
begin
  Result := Self.New;
end;

function TS2260Collection.GetItem(Index: Integer): TS2260CollectionItem;
begin
  Result := TS2260CollectionItem(inherited Items[Index]);
end;

procedure TS2260Collection.SetItem(Index: Integer;
  Value: TS2260CollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TS2260Collection.New: TS2260CollectionItem;
begin
  Result := TS2260CollectionItem.Create(FACBreSocial);
  Self.Add(Result);
end;

{ TS2260CollectionItem }

constructor TS2260CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;
  FTipoEvento    := teS2260;
  FEvtConvInterm := TEvtConvInterm.Create(AOwner);
end;

destructor TS2260CollectionItem.Destroy;
begin
  FEvtConvInterm.Free;

  inherited;
end;

{ TInfoConvInterm }

constructor TInfoConvInterm.Create;
begin
  inherited Create;
  Fjornada   := Tjornada.Create;
  FlocalTrab := TlocalTrab.Create;
end;

destructor TInfoConvInterm.Destroy;
begin
  Fjornada.Free;
  FlocalTrab.Free;

  inherited;
end;

{ TlocalTrab }

constructor TlocalTrab.Create;
begin
  inherited Create;
  FlocalTrabInterm := TBrasil.Create;
end;

destructor TlocalTrab.Destroy;
begin
  FlocalTrabInterm.Free;

  inherited;
end;

{ TEvtConvInterm }

constructor TEvtConvInterm.Create(AACBreSocial: TObject);
begin
  inherited Create(AACBreSocial);

  FIdeEvento      := TIdeEvento2.Create;
  FIdeEmpregador  := TIdeEmpregador.Create;
  FIdeVinculo     := TIdeVinculo.Create;
  FInfoConvInterm := TInfoConvInterm.Create;
end;

destructor TEvtConvInterm.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeVinculo.Free;
  FInfoConvInterm.Free;

  inherited;
end;

procedure TEvtConvInterm.GerarlocalTrab;
begin
  Gerador.wGrupo('localTrab');

  Gerador.wCampo(tcStr, '', 'indLocal', 1, 1, 1, self.InfoConvInterm.localTrab.indLocal);

  GerarEnderecoLocalTrabInterm(self.InfoConvInterm.localTrab.localTrabInterm);

  Gerador.wGrupo('/localTrab');
end;

procedure TEvtConvInterm.Gerarjornada;
begin
  Gerador.wGrupo('jornada');

  Gerador.wCampo(tcStr, '', 'codHorContrat', 1,  30, 0, self.InfoConvInterm.jornada.codHorContrat);
  Gerador.wCampo(tcStr, '', 'dscJornada',    1, 999, 0, self.InfoConvInterm.jornada.dscJornada);

  Gerador.wGrupo('/jornada');
end;

procedure TEvtConvInterm.GerarInfoConvInterm;
begin
  Gerador.wGrupo('infoConvInterm');

  Gerador.wCampo(tcStr, '', 'codConv',     1, 30, 1, self.InfoConvInterm.codConv);
  Gerador.wCampo(tcDat, '', 'dtInicio',   10, 10, 1, self.InfoConvInterm.dtInicio);
  Gerador.wCampo(tcDat, '', 'dtFim',      10, 10, 1, self.InfoConvInterm.dtFim);
  Gerador.wCampo(tcDat, '', 'dtPrevPgto', 10, 10, 1, self.InfoConvInterm.dtPrevPgto);

  Gerarjornada;
  GerarlocalTrab;

  Gerador.wGrupo('/infoConvInterm');
end;

function TEvtConvInterm.GerarXML: boolean;
begin
  try
    inherited GerarXML;
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtConvInterm');
    Gerador.wGrupo('evtConvInterm Id="' + Self.Id + '"');

    GerarIdeEvento2(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);
    GerarIdeVinculo(self.IdeVinculo);
    GerarInfoConvInterm;

    Gerador.wGrupo('/evtConvInterm');

    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtConvInterm.LerArqIni(const AIniString: String): Boolean;
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
      sSecao := 'evtConvInterm';
      Id         := INIRec.ReadString(sSecao, 'Id', '');
      Sequencial := INIRec.ReadInteger(sSecao, 'Sequencial', 0);

      sSecao := 'ideEvento';
      ideEvento.indRetif    := eSStrToIndRetificacao(Ok, INIRec.ReadString(sSecao, 'indRetif', '1'));
      ideEvento.NrRecibo    := INIRec.ReadString(sSecao, 'nrRecibo', EmptyStr);
      ideEvento.ProcEmi     := eSStrToProcEmi(Ok, INIRec.ReadString(sSecao, 'procEmi', '1'));
      ideEvento.VerProc     := INIRec.ReadString(sSecao, 'verProc', EmptyStr);

      sSecao := 'ideEmpregador';
      ideEmpregador.OrgaoPublico := (TACBreSocial(FACBreSocial).Configuracoes.Geral.TipoEmpregador = teOrgaoPublico);
      ideEmpregador.TpInsc       := eSStrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', '1'));
      ideEmpregador.NrInsc       := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);

      sSecao := 'ideVinculo';
      ideVinculo.CpfTrab   := INIRec.ReadString(sSecao, 'cpfTrab', EmptyStr);
      ideVinculo.NisTrab   := INIRec.ReadString(sSecao, 'nisTrab', EmptyStr);
      ideVinculo.Matricula := INIRec.ReadString(sSecao, 'matricula', EmptyStr);

      sSecao := 'infoConvInterm';
      infoConvInterm.codConv    := INIRec.ReadString(sSecao, 'codConv', EmptyStr);
      infoConvInterm.dtInicio   := StringToDateTime(INIRec.ReadString(sSecao, 'dtInicio', '0'));
      infoConvInterm.dtFim      := StringToDateTime(INIRec.ReadString(sSecao, 'dtFim', '0'));
      infoConvInterm.dtPrevPgto := StringToDateTime(INIRec.ReadString(sSecao, 'dtPrevPgto', '0'));

      sSecao := 'jornada';
      infoConvInterm.jornada.codHorContrat := INIRec.ReadString(sSecao, 'codHorContrat', EmptyStr);
      infoConvInterm.jornada.dscJornada    := INIRec.ReadString(sSecao, 'dscJornada', EmptyStr);

      sSecao := 'localTrab';
      infoConvInterm.localTrab.indLocal := INIRec.ReadString(sSecao, 'indLocal', EmptyStr);

      sSecao := 'localTrabInterm';
      if INIRec.ReadString(sSecao, 'tpLograd', '') <> '' then
      begin
        infoConvInterm.localTrab.localTrabInterm.TpLograd    := INIRec.ReadString(sSecao, 'tpLograd', EmptyStr);
        infoConvInterm.localTrab.localTrabInterm.DscLograd   := INIRec.ReadString(sSecao, 'dscLograd', EmptyStr);
        infoConvInterm.localTrab.localTrabInterm.NrLograd    := INIRec.ReadString(sSecao, 'nrLograd', EmptyStr);
        infoConvInterm.localTrab.localTrabInterm.Complemento := INIRec.ReadString(sSecao, 'complem', EmptyStr);
        infoConvInterm.localTrab.localTrabInterm.bairro      := INIRec.ReadString(sSecao, 'bairro', EmptyStr);
        infoConvInterm.localTrab.localTrabInterm.Cep         := INIRec.ReadString(sSecao, 'cep', EmptyStr);
        infoConvInterm.localTrab.localTrabInterm.CodMunic    := INIRec.ReadInteger(sSecao, 'codMunic', 0);
        infoConvInterm.localTrab.localTrabInterm.UF          := INIRec.ReadString(sSecao, 'uf', 'SP');
      end;
    end;

    GerarXML;
    XML := FXML;
  finally
    INIRec.Free;
  end;
end;

end.

