{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit pcesS1270;

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
  TS1270CollectionItem = class;
  TEvtContratAvNP = class;
  TRemunAvNPItem = class;
  TRemunAvNPColecao = class;

  TS1270Collection = class(TeSocialCollection)
  private
    function GetItem(Index: Integer): TS1270CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1270CollectionItem);
  public
    function Add: TS1270CollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TS1270CollectionItem;
    property Items[Index: Integer]: TS1270CollectionItem read GetItem write SetItem; default;
  end;

  TS1270CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FEvtContratAvNP: TEvtContratAvNP;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtContratAvNP: TEvtContratAvNP read FEvtContratAvNP write FEvtContratAvNP;
  end;

  TEvtContratAvNP = class(TESocialEvento)
  private
    FIdeEvento: TIdeEvento3;
    FIdeEmpregador: TIdeEmpregador;
    FRemunAvNp: TRemunAvNPColecao;

    {Geradores espec�ficos da classe}
    procedure GerarRemunAvNP(pRemunAvNPColecao: TRemunAvNPColecao);
  public
    constructor Create(AACBreSocial: TObject); override;
    destructor Destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property IdeEvento: TIdeEvento3 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property remunAvNp: TRemunAvNPColecao read FRemunAvNp write FRemunAvNp;
  end;

  TRemunAvNPColecao = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRemunAvNPItem;
    procedure SetItem(Index: Integer; const Value: TRemunAvNPItem);
  public
    function Add: TRemunAvNPItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRemunAvNPItem;
    property Items[Index: Integer]: TRemunAvNPItem read GetItem write SetItem;
  end;

  TRemunAvNPItem = class(TObject)
  private
    FtpInsc: tpTpInsc;
    FnrInsc: string;
    FCodLotacao: string;
    FVrBcCp00: Double;
    FVrBcCp15: Double;
    FVrBcCp20: Double;
    FVrBcCp25: Double;
    FVrBcCp13: Double;
    FVrBcFgts: Double;
    FVrDescCP: Double;
  public
    property tpInsc: tpTpInsc read FtpInsc write FtpInsc;
    property nrInsc: string read FnrInsc write FnrInsc;
    property codLotacao: string read FCodLotacao write FCodLotacao;
    property vrBcCp00: Double read FVrBcCp00 write FVrBcCp00;
    property vrBcCp15: Double read FVrBcCp15 write FVrBcCp15;
    property vrBcCp20: Double read FVrBcCp20 write FVrBcCp20;
    property vrBcCp25: Double read FVrBcCp25 write FVrBcCp25;
    property vrBcCp13: Double read FVrBcCp13 write FVrBcCp13;
    property vrBcFgts: Double read FVrBcFgts write FVrBcFgts;
    property vrDescCP: Double read FVrDescCP write FVrDescCP;
  end;

implementation

uses
  IniFiles,
  ACBrUtil.Base,
  ACBrUtil.FilesIO,
  ACBreSocial;

{ TS1270Collection }

function TS1270Collection.Add: TS1270CollectionItem;
begin
  Result := Self.New;
end;

function TS1270Collection.GetItem(Index: Integer): TS1270CollectionItem;
begin
  Result := TS1270CollectionItem(inherited Items[Index]);
end;

procedure TS1270Collection.SetItem(Index: Integer;
  Value: TS1270CollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TS1270Collection.New: TS1270CollectionItem;
begin
  Result := TS1270CollectionItem.Create(FACBreSocial);
  Self.Add(Result);
end;

{TS1270CollectionItem}
constructor TS1270CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;
  FTipoEvento     := teS1270;
  FEvtContratAvNP := TEvtContratAvNP.Create(AOwner);
end;

destructor TS1270CollectionItem.Destroy;
begin
  FEvtContratAvNP.Free;

  inherited;
end;

{ TRemunAvNPColecao }
function TRemunAvNPColecao.Add: TRemunAvNPItem;
begin
  Result := Self.New;
end;

function TRemunAvNPColecao.GetItem(Index: Integer): TRemunAvNPItem;
begin
  Result := TRemunAvNPItem(inherited Items[Index]);
end;

procedure TRemunAvNPColecao.SetItem(Index: Integer;
  const Value: TRemunAvNPItem);
begin
  inherited Items[Index] := Value;
end;

function TRemunAvNPColecao.New: TRemunAvNPItem;
begin
  Result := TRemunAvNPItem.Create;
  Self.Add(Result);
end;

{ TEvtContratAvNP }
constructor TEvtContratAvNP.Create(AACBreSocial: TObject);
begin
  inherited Create(AACBreSocial);

  FIdeEvento     := TIdeEvento3.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FRemunAvNp     := TRemunAvNPColecao.Create;
end;

destructor TEvtContratAvNP.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FRemunAvNp.Free;

  inherited;
end;

procedure TEvtContratAvNP.GerarRemunAvNP(pRemunAvNPColecao: TRemunAvNPColecao);
var
  i: integer;
begin
  for i := 0 to pRemunAvNPColecao.Count - 1 do
  begin
    Gerador.wGrupo('remunAvNP');

    Gerador.wCampo(tcInt, '', 'tpInsc',     1,  1, 1, eSTpInscricaoToStr(pRemunAvNPColecao.Items[i].tpInsc));
    Gerador.wCampo(tcStr, '', 'nrInsc',     1, 15, 1, pRemunAvNPColecao.Items[i].nrInsc);
    Gerador.wCampo(tcStr, '', 'codLotacao', 1, 30, 1, pRemunAvNPColecao.Items[i].codLotacao);
    Gerador.wCampo(tcDe2, '', 'vrBcCp00',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcCp00);
    Gerador.wCampo(tcDe2, '', 'vrBcCp15',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcCp15);
    Gerador.wCampo(tcDe2, '', 'vrBcCp20',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcCp20);
    Gerador.wCampo(tcDe2, '', 'vrBcCp25',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcCp25);
    Gerador.wCampo(tcDe2, '', 'vrBcCp13',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcCp13);
    Gerador.wCampo(tcDe2, '', 'vrBcFgts',   1, 14, 1, pRemunAvNPColecao.Items[i].vrBcFgts);
    Gerador.wCampo(tcDe2, '', 'vrDescCP',   1, 14, 1, pRemunAvNPColecao.Items[i].vrDescCP);

    Gerador.wGrupo('/remunAvNP');
  end;

  if pRemunAvNPColecao.Count > 999 then
    Gerador.wAlerta('', 'remunAvNP', 'Lista de Remunera��o', ERR_MSG_MAIOR_MAXIMO + '999');
end;

function TEvtContratAvNP.GerarXML: boolean;
begin
  try
    inherited GerarXML;
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtContratAvNP');
    Gerador.wGrupo('evtContratAvNP Id="' + Self.Id + '"');

    if VersaoDF <= ve02_05_00 then
      gerarIdeEvento3(self.IdeEvento, True, True, False)
    else
      GerarIdeEvento3(self.IdeEvento, True, False, True);

    gerarIdeEmpregador(self.IdeEmpregador);
    GerarRemunAvNP(remunAvNp);

    Gerador.wGrupo('/evtContratAvNP');

    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;
//    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtContratAvNP');

//    Validar(schevtContratAvNP);
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtContratAvNP.LerArqIni(const AIniString: String): Boolean;
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
      sSecao := 'evtContratAvNP';
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

      I := 1;
      while true do
      begin
        // de 001 at� 999
        sSecao := 'remunAvNP' + IntToStrZero(I, 3);
        sFim   := INIRec.ReadString(sSecao, 'tpInsc', 'FIM');

        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with remunAvNP.New do
        begin
          TpInsc     := eSStrToTpInscricao(Ok, sFim);
          NrInsc     := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);
          codLotacao := INIRec.ReadString(sSecao, 'codLotacao', EmptyStr);
          vrBcCp00   := StringToFloatDef(INIRec.ReadString(sSecao, 'vrBcCp00', ''), 0);
          vrBcCp15   := StringToFloatDef(INIRec.ReadString(sSecao, 'vrBcCp15', ''), 0);
          vrBcCp20   := StringToFloatDef(INIRec.ReadString(sSecao, 'vrBcCp20', ''), 0);
          vrBcCp25   := StringToFloatDef(INIRec.ReadString(sSecao, 'vrBcCp25', ''), 0);
          vrBcCp13   := StringToFloatDef(INIRec.ReadString(sSecao, 'vrBcCp13', ''), 0);
          vrBcFgts   := StringToFloatDef(INIRec.ReadString(sSecao, 'vrBcFgts', ''), 0);
          vrDescCP   := StringToFloatDef(INIRec.ReadString(sSecao, 'vrDescCP', ''), 0);
        end;

        Inc(I);
      end;
    end;

    GerarXML;
    XML := FXML;
  finally
    INIRec.Free;
  end;
end;

end.
