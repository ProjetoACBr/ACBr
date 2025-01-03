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

{$I ACBr.inc}

unit pcnCIOTW;

interface

uses
  SysUtils, Classes,
  ACBrUtil.Strings,
  pcnGerador, ACBrCIOTConversao, pcnCIOT;

type

  TCIOTW = class;
  TGeradorOpcoes = class;

  { TCIOTWClass }

  TCIOTWClass = class
  private
  protected
    FpCIOTW: TCIOTW;

    FGerador: TGerador;
    FOpcoes: TGeradorOpcoes;

    FCIOT: TCIOT;
  public
    constructor Create(ACIOTW: TCIOTW); virtual;
    destructor  Destroy; Override;

    function ObterNomeArquivo: String; virtual;
    function GerarXml: Boolean; virtual;

    property Gerador: TGerador      read FGerador   write FGerador;
    property Opcoes: TGeradorOpcoes read FOpcoes    write FOpcoes;
    property CIOT: TCIOT  read FCIOT write FCIOT;
  end;


  { TCIOTW }

  TCIOTW = class
  private
    FIntegradora: TCIOTIntegradora;
    FCIOTWClass: TCIOTWClass;
    FCIOT: TCIOT;

    procedure SetIntegradora(AIntegradora: TCIOTIntegradora);
  public
    constructor Create(AOwner: TCIOT);
    procedure Clear;
    destructor Destroy; override;

    function GerarXml: Boolean;

    property Integradora: TCIOTIntegradora read FIntegradora write SetIntegradora;
    property CIOTWClass: TCIOTWClass read FCIOTWClass;
    property CIOT: TCIOT read FCIOT write FCIOT;
  end;

  TGeradorOpcoes = class(TPersistent)
  private
    FAjustarTagNro: Boolean;
    FNormatizarMunicipios: Boolean;
    FPathArquivoMunicipios: String;
    FValidarInscricoes: Boolean;
  published
    property AjustarTagNro: Boolean        read FAjustarTagNro         write FAjustarTagNro;
    property NormatizarMunicipios: Boolean read FNormatizarMunicipios  write FNormatizarMunicipios;
    property PathArquivoMunicipios: String read FPathArquivoMunicipios write FPathArquivoMunicipios;
    property ValidarInscricoes: Boolean    read FValidarInscricoes     write FValidarInscricoes;
  end;

implementation

uses
  ACBrDFeException,
  pcnCIOTW_eFrete, pcnCIOTW_REPOM, pcnCIOTW_Pamcard;


{ TCIOTWClass }

constructor TCIOTWClass.Create(ACIOTW: TCIOTW);
begin
  FpCIOTW := ACIOTW;

  FGerador := TGerador.Create;

  FOpcoes := TGeradorOpcoes.Create;
  FOpcoes.FAjustarTagNro        := True;
  FOpcoes.FNormatizarMunicipios := False;
  FOpcoes.FValidarInscricoes    := False;
end;

destructor TCIOTWClass.Destroy;
begin
  FOpcoes.Free;
  FGerador.Free;

  inherited Destroy;
end;

function TCIOTWClass.GerarXml: Boolean;
begin
  Result := False;
  raise EACBrDFeException.Create(ClassName + '.GerarXml, n�o implementado');
end;

function TCIOTWClass.ObterNomeArquivo: String;
begin
  Result := '';
  raise EACBrDFeException.Create(ClassName + '.ObterNomeArquivo, n�o implementado');
end;

{ TCIOTW }

procedure TCIOTW.Clear;
begin
  FIntegradora := iNone;

  if Assigned(FCIOTWClass) then
    FCIOTWClass.Free;

  FCIOTWClass := TCIOTWClass.Create(Self);
end;

constructor TCIOTW.Create(AOwner: TCIOT);
begin
  inherited Create;

  FCIOT := AOwner;

  Clear;
end;

destructor TCIOTW.Destroy;
begin
  if Assigned(FCIOTWClass) then
    FreeAndNil(FCIOTWClass);

  inherited Destroy;
end;

function TCIOTW.GerarXml: Boolean;
begin
  Result := FCIOTWClass.GerarXml;
end;

procedure TCIOTW.SetIntegradora(AIntegradora: TCIOTIntegradora);
begin
  if AIntegradora = FIntegradora then
    exit;

  if Assigned(FCIOTWClass) then
    FreeAndNil(FCIOTWClass);

  case AIntegradora of
    ieFrete:  FCIOTWClass := TCIOTW_eFrete.Create(Self);
    iREPOM:   FCIOTWClass := TCIOTW_REPOM.Create(Self);
    iPamcard: FCIOTWClass := TCIOTW_Pamcard.Create(Self);
  else
    FCIOTWClass := TCIOTWClass.Create(Self);
  end;

  FCIOTWClass.FCIOT := FCIOT;

  FIntegradora := AIntegradora;
end;

end.

