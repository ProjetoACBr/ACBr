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
{                              Leivio Fontenele                                }
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

unit pcesIniciais;

interface

uses
  SysUtils, Classes, synautil,
  pcesConversaoeSocial,
  pcesS1000, pcesS1005;

type

  TIniciais = class(TObject)
  private
    FS1000: TS1000Collection;
    FS1005: TS1005Collection;
    FACBreSocial: TComponent;
    function GetCount: integer;
    procedure setS1000(const Value: TS1000Collection);
    procedure setS1005(const Value: TS1005Collection);

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure Gerar;
    procedure Assinar;
    procedure Validar;
    procedure SaveToFiles;
    procedure Clear;
    function LoadFromString(const AXMLString: String): Boolean;
    function LoadFromIni(const AIniString: String): Boolean;
    property Count: Integer read GetCount;
    property S1000: TS1000Collection read FS1000 write setS1000;
    property S1005: TS1005Collection read FS1005 write setS1005;

  end;

implementation

uses
  ACBrUtil.FilesIO,
  ACBrUtil.Strings,
  ACBreSocial;

{ TIniciais }

procedure TIniciais.Clear;
begin
  FS1000.Clear;
  FS1005.Clear;
end;

constructor TIniciais.Create(AOwner: TComponent);
begin
  inherited Create;

  FACBreSocial := AOwner;
  FS1000       := TS1000Collection.Create(AOwner);
  FS1005       := TS1005Collection.Create(AOwner);
end;

destructor TIniciais.Destroy;
begin
  FS1000.Free;
  FS1005.Free;

  inherited;
end;

function TIniciais.GetCount: Integer;
begin
  Result := self.S1000.Count +
            self.S1005.Count;
end;

procedure TIniciais.Gerar;
var
  i: Integer;
begin
  for I := 0 to Self.S1000.Count - 1 do
    Self.S1000.Items[i].evtInfoEmpregador.GerarXML;

  for I := 0 to Self.S1005.Count - 1 do
    Self.S1005.Items[i].evtTabEstab.GerarXML;
end;

procedure TIniciais.Assinar;
var
  i: Integer;
begin
  for I := 0 to Self.S1000.Count - 1 do
    Self.S1000.Items[i].evtInfoEmpregador.XML :=
      Self.S1000.Items[i].evtInfoEmpregador.Assinar(Self.S1000.Items[i].evtInfoEmpregador.XML, 'evtInfoEmpregador');

  for I := 0 to Self.S1005.Count - 1 do
    Self.S1005.Items[i].evtTabEstab.XML :=
      Self.S1005.Items[i].evtTabEstab.Assinar(Self.S1005.Items[i].evtTabEstab.XML, 'evtTabEstab');
end;

procedure TIniciais.Validar;
var
  i: Integer;
begin
  for I := 0 to Self.S1000.Count - 1 do
    Self.S1000.Items[i].evtInfoEmpregador.Validar(schevtInfoEmpregador);

  for I := 0 to Self.S1005.Count - 1 do
    Self.S1005.Items[i].evtTabEstab.Validar(schevtTabEstab);
end;

procedure TIniciais.SaveToFiles;
var
  i: integer;
  Path, PathName: String;
begin
  with TACBreSocial(FACBreSocial) do
    Path := PathWithDelim(Configuracoes.Arquivos.GetPatheSocial(Now, Configuracoes.Geral.IdEmpregador));

  for I := 0 to Self.S1000.Count - 1 do
  begin
    PathName := Path + OnlyNumber(Self.S1000.Items[i].evtInfoEmpregador.Id) + '-' +
     TipoEventoToStr(Self.S1000.Items[i].TipoEvento)+'-'+IntToStr(i);

    Self.S1000.Items[i].evtInfoEmpregador.SaveToFile(PathName);

    with TACBreSocial(Self.FACBreSocial).Eventos.Gerados.New do
    begin
      TipoEvento := teS1000;
      PathNome := PathName;
      idEvento := OnlyNumber(Self.S1000.Items[i].evtInfoEmpregador.Id);
      XML := Self.S1000.Items[i].evtInfoEmpregador.XML;
    end;
  end;

  for I := 0 to Self.S1005.Count - 1 do
  begin
    PathName := Path + OnlyNumber(Self.S1005.Items[i].evtTabEstab.Id) + '-' +
     TipoEventoToStr(Self.S1005.Items[i].TipoEvento)+'-'+IntToStr(i);

    Self.S1005.Items[i].evtTabEstab.SaveToFile(PathName);

    with TACBreSocial(Self.FACBreSocial).Eventos.Gerados.New do
    begin
      TipoEvento := teS1005;
      PathNome := PathName;
      idEvento := OnlyNumber(Self.S1005.Items[i].evtTabEstab.Id);
      XML := Self.S1005.Items[i].evtTabEstab.XML;
    end;
  end;
end;

procedure TIniciais.setS1000(const Value: TS1000Collection);
begin
  FS1000.Assign(Value);
end;

procedure TIniciais.setS1005(const Value: TS1005Collection);
begin
  FS1005.Assign(Value);
end;

function TIniciais.LoadFromString(const AXMLString: String): Boolean;
var
  Ok : Boolean;
  typVersaoDF : TVersaoeSocial;
begin
  typVersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;

  case StringXMLToTipoEvento(Ok, AXMLString, typVersaoDF) of
    teS1000: Self.S1000.New.evtInfoEmpregador.XML := AXMLString;
    teS1005: Self.S1005.New.evtTabEstab.XML := AXMLString;
  end;

  Result := (GetCount > 0);
end;

function TIniciais.LoadFromIni(const AIniString: String): Boolean;
var
  Ok: Boolean;
  typVersaoDF : TVersaoeSocial;
begin
  typVersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;

  case StringINIToTipoEvento(Ok, AIniString, typVersaoDF) of
    teS1000: Self.S1000.New.evtInfoEmpregador.LerArqIni(AIniString);
    teS1005: Self.S1005.New.evtTabEstab.LerArqIni(AIniString);
  end;

  Result := (GetCount > 0);
end;

end.
