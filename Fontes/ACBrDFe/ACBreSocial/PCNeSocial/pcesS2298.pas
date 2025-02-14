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

unit pcesS2298;

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
  TInfoReintegr = class
  private
     FtpReint: tpTpReint;
     FnrProcJud: string;
     FnrLeiAnistia: string;
     FdtEfetRetorno: TDateTime;
     FdtEfeito: TDateTime;
     FindPagtoJuizo: tpSimNao;
  public
    property tpReint: tpTpReint read FtpReint write FtpReint;
    property nrProcJud: string read FnrProcJud write FnrProcJud;
    property nrLeiAnistia: string read FnrLeiAnistia write FnrLeiAnistia;
    property dtEfetRetorno: TDateTime read FdtEfetRetorno write FdtEfetRetorno;
    property dtEfeito: TDateTime read FdtEfeito write FdtEfeito;
    property indPagtoJuizo: tpSimNao read FindPagtoJuizo write FindPagtoJuizo;
  end;

  TEvtReintegr = class(TeSocialEvento)
  private
    FIdeEvento: TIdeEvento2;
    FIdeEmpregador: TIdeEmpregador;
    FIdeVinculo: TIdeVinculo;
    FInfoReintegr: TInfoReintegr;

    procedure GerarInfoReintegr;
  public
    constructor Create(AACBreSocial: TObject); override;
    destructor  Destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property IdeEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeVinculo: TIdeVinculo read FIdeVinculo write FIdeVinculo;
    property InfoReintegr: TInfoReintegr read FInfoReintegr write FInfoReintegr;
  end;

  TS2298CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FEvtReintegr: TEvtReintegr;
  public
    constructor Create(AOwner: TComponent);
    destructor  Destroy; override;
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtReintegr: TEvtReintegr read FEvtReintegr write FEvtReintegr;
  end;

  TS2298Collection = class(TeSocialCollection)
  private
    function GetItem(Index: Integer): TS2298CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2298CollectionItem);
  public
    function Add: TS2298CollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TS2298CollectionItem;
    property Items[Index: Integer]: TS2298CollectionItem read GetItem write SetItem; default;
  end;

implementation

uses
  IniFiles,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime,
  ACBreSocial;

{ TS2298Collection }

function TS2298Collection.Add: TS2298CollectionItem;
begin
  Result := Self.New;
end;

function TS2298Collection.GetItem(Index: Integer): TS2298CollectionItem;
begin
  Result := TS2298CollectionItem(inherited Items[Index]);
end;

procedure TS2298Collection.SetItem(Index: Integer;
  Value: TS2298CollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TS2298Collection.New: TS2298CollectionItem;
begin
  Result := TS2298CollectionItem.Create(FACBreSocial);
  Self.Add(Result);
end;

{ TS2298CollectionItem }
constructor TS2298CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;
  FTipoEvento  := teS2298;
  FEvtReintegr := TEvtReintegr.Create(AOwner);
end;

destructor TS2298CollectionItem.Destroy;
begin
  FEvtReintegr.Free;

  inherited;
end;

{ TEvtReintegracao }
constructor TEvtReintegr.Create(AACBreSocial: TObject);
begin
  inherited Create(AACBreSocial);

  FIdeEvento     := TIdeEvento2.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeVinculo    := TIdeVinculo.Create;
  FInfoReintegr  := TInfoReintegr.Create;
end;

destructor TEvtReintegr.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeVinculo.Free;
  FInfoReintegr.Free;

  inherited;
end;

procedure TEvtReintegr.GerarInfoReintegr;
begin
  Gerador.wGrupo('infoReintegr');

  Gerador.wCampo(tcStr, '', 'tpReint', 1, 1, 1, eSTpReintToStr(self.InfoReintegr.tpReint));

  if eSTpReintToStr(self.InfoReintegr.tpReint) = '1' then
    Gerador.wCampo(tcStr, '', 'nrProcJud', 1, 20, 0, self.InfoReintegr.nrProcJud);

  if eSTpReintToStr(self.InfoReintegr.tpReint) = '2' then
    Gerador.wCampo(tcStr, '', 'nrLeiAnistia', 5, 13, 0, self.InfoReintegr.nrLeiAnistia);

  Gerador.wCampo(tcDat, '', 'dtEfetRetorno', 10, 10, 1, self.InfoReintegr.dtEfetRetorno);
  Gerador.wCampo(tcDat, '', 'dtEfeito',      10, 10, 1, self.InfoReintegr.dtEfeito);

  Gerador.wGrupo('/infoReintegr');
end;

function TEvtReintegr.GerarXML: boolean;
begin
  try
    inherited GerarXML;
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtReintegr');
    Gerador.wGrupo('evtReintegr Id="' + Self.Id + '"');

    GerarIdeEvento2(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);
    GerarIdeVinculo(self.IdeVinculo);
    GerarInfoReintegr;

    Gerador.wGrupo('/evtReintegr');

    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtReintegr.LerArqIni(const AIniString: String): Boolean;
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
      sSecao := 'evtReintegr';
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

      sSecao := 'infoReintegr';
      infoReintegr.tpReint       := eSStrToTpReint(Ok, INIRec.ReadString(sSecao, 'tpReint', '1'));
      infoReintegr.nrProcJud     := INIRec.ReadString(sSecao, 'nrProcJud', EmptyStr);
      infoReintegr.nrLeiAnistia  := INIRec.ReadString(sSecao, 'nrLeiAnistia', 'LEI6683_1979');
      infoReintegr.dtEfetRetorno := StringToDateTime(INIRec.ReadString(sSecao, 'dtEfetRetorno', '0'));
      infoReintegr.dtEfeito      := StringToDateTime(INIRec.ReadString(sSecao, 'dtEfeito', '0'));
      infoReintegr.indPagtoJuizo := eSStrToSimNao(Ok, INIRec.ReadString(sSecao, 'indPagtoJuizo', 'S'));
    end;

    GerarXML;
    XML := FXML;
  finally
    INIRec.Free;
  end;
end;

end.
