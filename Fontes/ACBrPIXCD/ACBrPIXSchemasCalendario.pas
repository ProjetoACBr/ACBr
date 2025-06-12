{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

(*

  Documenta��o:
  https://github.com/bacen/pix-api

*)

{$I ACBr.inc}

unit ACBrPIXSchemasCalendario;

interface

uses
  Classes, SysUtils, ACBrJSON, ACBrPIXBase;

type

  { TACBrPIXCalendarioCobBase }

  TACBrPIXCalendarioCobBase = class(TACBrPIXSchema)
  private
    fapresentacao: TDateTime;
    fapresentacao_Bias: Integer;
    fcriacao: TDateTime;
    fcriacao_Bias: Integer;
    fexpiracao: Integer;
  protected
    property criacao: TDateTime read fcriacao write fcriacao;
    property criacao_Bias: Integer read fcriacao_Bias write fcriacao_Bias;
    property apresentacao: TDateTime read fapresentacao write fapresentacao;
    property apresentacao_Bias: Integer read fapresentacao_Bias write fapresentacao_Bias;
    property expiracao: Integer read fexpiracao write fexpiracao;

    procedure DoWriteToJSon(AJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(AJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCalendarioCobBase);
  end;

  { TACBrPIXCalendarioCobSolicitada }

  TACBrPIXCalendarioCobSolicitada = class(TACBrPIXCalendarioCobBase)
  public
    property expiracao;
  end;

  { TACBrPIXCalendarioCobGerada }

  TACBrPIXCalendarioCobGerada = class(TACBrPIXCalendarioCobBase)
  public
    property criacao;
    property criacao_Bias;
    property expiracao;
  end;

  { TACBrPIXCalendarioRecBase }

  TACBrPIXCalendarioRecBase = class(TACBrPIXSchema)
  private
    fdataFinal: TDateTime;
    fdataInicial: TDateTime;
    fperiodicidade: TACBrPIXPeriodicidade;
    fdataExpiracaoSolicitacao: TDateTime;
  protected
    procedure DoWriteToJSon(AJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(AJSon: TACBrJSONObject); override;

    property dataInicial: TDateTime read fdataInicial write fdataInicial;
    property dataFinal: TDateTime read fdataFinal write fdataFinal;
    property periodicidade: TACBrPIXPeriodicidade read fperiodicidade write fperiodicidade;
    property dataExpiracaoSolicitacao: TDateTime read fdataExpiracaoSolicitacao write fdataExpiracaoSolicitacao;
  public
    constructor Create(const ObjectName: String); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCalendarioRecBase);
  end;

  { TACBrPIXCalendarioRec }

  TACBrPIXCalendarioRec = class(TACBrPIXCalendarioRecBase)
  public
    property dataInicial;
    property dataFinal;
    property periodicidade;
  end;

  { TACBrPIXCalendarioRecSolic }

  TACBrPIXCalendarioRecSolic = class(TACBrPIXCalendarioRecBase)
  public
    property dataExpiracaoSolicitacao;
  end;

implementation

uses
  ACBrUtil.DateTime, ACBrUtil.Base;

{ TACBrPIXCalendarioCobBase }

constructor TACBrPIXCalendarioCobBase.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrPIXCalendarioCobBase.Clear;
begin
  fapresentacao := 0;
  fapresentacao_Bias := 0;
  fcriacao := 0;
  fcriacao_Bias := 0;
  fexpiracao := 0;
end;

function TACBrPIXCalendarioCobBase.IsEmpty: Boolean;
begin
  Result := (fcriacao = 0) and (fcriacao_Bias = 0) and (fapresentacao = 0) and
            (fapresentacao_Bias = 0) and (fexpiracao = 0);
end;

procedure TACBrPIXCalendarioCobBase.Assign(Source: TACBrPIXCalendarioCobBase);
begin
  fcriacao := Source.criacao;
  fcriacao_Bias := Source.criacao_Bias;
  fapresentacao := Source.apresentacao;
  fapresentacao_Bias := Source.apresentacao_Bias;
  fexpiracao := Source.expiracao;
end;

procedure TACBrPIXCalendarioCobBase.DoWriteToJSon(AJSon: TACBrJSONObject);
begin
  if (fcriacao <> 0) then
    AJSon.AddPair('criacao', DateTimeToIso8601(fcriacao, BiasToTimeZone(fcriacao_Bias)));
  if (fapresentacao <> 0) then
    AJSon.AddPair('apresentacao', DateTimeToIso8601(fapresentacao, BiasToTimeZone(fapresentacao_Bias)));
  AJSon.AddPair('expiracao', fexpiracao, False);
end;

procedure TACBrPIXCalendarioCobBase.DoReadFromJSon(AJSon: TACBrJSONObject);
var
  s1, s2: String;
begin
  {$IfDef FPC}
  s1 := EmptyStr;
  s2 := EmptyStr;
  {$EndIf}

  AJSon
    .Value('criacao', s1)
    .Value('apresentacao', s2)
    .Value('expiracao', fexpiracao);

  if NaoEstaVazio(s1) then
  begin
    fcriacao := Iso8601ToDateTime(s1);
    fcriacao_Bias := TimeZoneToBias(s1);
  end;

  if NaoEstaVazio(s2) then
  begin
    fapresentacao := Iso8601ToDateTime(s2);
    fapresentacao_Bias := TimeZoneToBias(s2);
  end;
end;

{ TACBrPIXCalendarioRecBase }

constructor TACBrPIXCalendarioRecBase.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrPIXCalendarioRecBase.Clear;
begin
  fdataInicial := 0;
  fdataFinal := 0;
  fperiodicidade := perNENHUM;
  fdataExpiracaoSolicitacao := 0;
end;

function TACBrPIXCalendarioRecBase.IsEmpty: Boolean;
begin
  Result := EstaZerado(fdataInicial) and
            EstaZerado(fdataFinal) and
            (fperiodicidade = perNENHUM) and
            EstaZerado(fdataExpiracaoSolicitacao);
end;

procedure TACBrPIXCalendarioRecBase.Assign(Source: TACBrPIXCalendarioRecBase);
begin
  Clear;
  if not Assigned(Source) then
    Exit;
  fdataInicial := Source.dataInicial;
  fdataFinal := Source.dataFinal;
  fperiodicidade := Source.periodicidade;
  fdataExpiracaoSolicitacao := Source.dataExpiracaoSolicitacao;
end;

procedure TACBrPIXCalendarioRecBase.DoWriteToJSon(AJSon: TACBrJSONObject);
begin
  AJSon.AddPair('periodicidade', PIXPeriodicidadeToString(fperiodicidade), False);
  if NaoEstaZerado(fdataInicial) then
    AJSon.AddPair('dataInicial', DateTimeToISO8601(fdataInicial));
  if NaoEstaZerado(fdataFinal) then
    AJSon.AddPair('dataFinal', DateTimeToISO8601(fdataFinal));
  if NaoEstaZerado(fdataExpiracaoSolicitacao) then
    AJSon.AddPair('dataExpiracaoSolicitacao', DateTimeToISO8601(fdataExpiracaoSolicitacao));
end;

procedure TACBrPIXCalendarioRecBase.DoReadFromJSon(AJSon: TACBrJSONObject);
var
  wDataInicial, wDataFinal, wPeriodicidade, wDataExpiracaoSolicitacao: String;
begin
  {$IFDEF FPC}
  wDataFinal := EmptyStr;
  wDataInicial := EmptyStr;
  wPeriodicidade := EmptyStr;
  wDataExpiracaoSolicitacao := EmptyStr;
  {$ENDIF}
  AJSon
    .Value('dataInicial', wDataInicial)
    .Value('dataFinal', wDataFinal)
    .Value('periodicidade', wPeriodicidade)
    .Value('dataExpiracaoSolicitacao', wDataExpiracaoSolicitacao);

  if NaoEstaVazio(wDataInicial) then
    fdataInicial := ISO8601ToDateTime(wDataInicial);

  if NaoEstaVazio(wDataFinal) then
    fdataFinal := ISO8601ToDateTime(wDataFinal);

  if NaoEstaVazio(wPeriodicidade) then
    fperiodicidade := StringToPIXPeriodicidade(wPeriodicidade);

  if NaoEstaVazio(wDataExpiracaoSolicitacao) then
    fdataExpiracaoSolicitacao := ISO8601ToDateTime(wDataExpiracaoSolicitacao);
end;

end.

