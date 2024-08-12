﻿{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibBALMT;

interface

uses
  Classes, SysUtils, typinfo,
  ACBrLibComum, ACBrLibBALBase;

{%region Declaração da funções}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function BAL_Inicializar(var libHandle: PLibHandle; const eArqConfig, eChaveCrypt: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_Finalizar(libHandle: PLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_Nome(const libHandle: PLibHandle; const sNome: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_Versao(const libHandle: PLibHandle; const sVersao: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_OpenSSLInfo(const libHandle: PLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_UltimoRetorno(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_ConfigImportar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_ConfigExportar(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_ConfigLer(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_ConfigGravar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_ConfigLerValor(const libHandle: PLibHandle; const eSessao, eChave: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_ConfigGravarValor(const libHandle: PLibHandle; const eSessao, eChave, eValor: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Balança}
function BAL_Ativar(const libHandle: PLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_Desativar(const libHandle: PLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_LePeso(const libHandle: PLibHandle; MillisecTimeOut: Integer; var Peso: Double): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_LePesoStr(const libHandle: PLibHandle; MillisecTimeOut: Integer; sValor: PAnsiChar;
  var esTamanho: Integer): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_SolicitarPeso(const libHandle: PLibHandle): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_UltimoPesoLido(const libHandle: PLibHandle; var Peso: Double): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_UltimoPesoLidoStr(const libHandle: PLibHandle; sValor: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_InterpretarRespostaPeso(const libHandle: PLibHandle; eResposta: PAnsiChar; var Peso: Double): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function BAL_InterpretarRespostaPesoStr(const libHandle: PLibHandle; eResposta: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: Integer): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

{%endregion}

{%endregion}

implementation

uses
  ACBrLibConsts, ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.Strings, ACBrUtil.DateTime, ACBrUtil.Math;


{%region BAL}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}

function BAL_Inicializar(var libHandle: PLibHandle; const eArqConfig, eChaveCrypt: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(libHandle, TACBrLibBAL, eArqConfig, eChaveCrypt);
end;

function BAL_Finalizar(libHandle: PLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar(libHandle);
end;

function BAL_Nome(const libHandle: PLibHandle; const sNome: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(libHandle, sNome, esTamanho);
end;

function BAL_Versao(const libHandle: PLibHandle; const sVersao: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(libHandle, sVersao, esTamanho);
end;

function BAL_OpenSSLInfo(const libHandle: PLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_OpenSSLInfo(libHandle, sOpenSSLInfo, esTamanho);
end;

function BAL_UltimoRetorno(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(libHandle, sMensagem, esTamanho);
end;

function BAL_ConfigImportar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigImportar(libHandle, eArqConfig);
end;

function BAL_ConfigExportar(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigExportar(libHandle, sMensagem, esTamanho);
end;

function BAL_ConfigLer(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(libHandle, eArqConfig);
end;

function BAL_ConfigGravar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(libHandle, eArqConfig);
end;

function BAL_ConfigLerValor(const libHandle: PLibHandle; const eSessao, eChave: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(libHandle, eSessao, eChave, sValor, esTamanho);
end;

function BAL_ConfigGravarValor(const libHandle: PLibHandle; const eSessao, eChave, eValor: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(libHandle, eSessao, eChave, eValor);
end;

{%endregion}

{%region Balanço}

function BAL_Ativar(const libHandle: PLibHandle): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibBAL(libHandle^.Lib).Ativar;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function BAL_Desativar(const libHandle: PLibHandle): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibBAL(libHandle^.Lib).Desativar;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function BAL_LePeso(const libHandle: PLibHandle; MillisecTimeOut: Integer; var Peso: Double): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibBAL(libHandle^.Lib).LePeso(MillisecTimeOut, Peso);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function BAL_LePesoStr(const libHandle: PLibHandle; MillisecTimeOut: Integer; sValor: PAnsiChar;
  var esTamanho: Integer): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Peso: Double;
  Resposta: string;
begin
  try
    VerificarLibInicializada(libHandle);
    Peso := 0;
    Result := TACBrLibBAL(libHandle^.Lib).LePeso(MillisecTimeOut, Peso);
    if Result = 0 then
    begin
      Resposta := FloatToString(Peso);
      TACBrLibBAL(libHandle^.Lib).MoverStringParaPChar(Resposta, sValor, esTamanho);
      TACBrLibBAL(libHandle^.Lib).SetRetorno(Result, Resposta);
    end;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function BAL_SolicitarPeso(const libHandle: PLibHandle): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibBAL(libHandle^.Lib).SolicitarPeso;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function BAL_UltimoPesoLido(const libHandle: PLibHandle; var Peso: Double): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibBAL(libHandle^.Lib).UltimoPesoLido(Peso);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function BAL_UltimoPesoLidoStr(const libHandle: PLibHandle; sValor: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Peso: Double;
  Resposta: string;
begin
  try
    VerificarLibInicializada(libHandle);
    Peso := 0;
    Result := TACBrLibBAL(libHandle^.Lib).UltimoPesoLido(Peso);
    if Result = 0 then
    begin
      Resposta := FloatToString(Peso);
      TACBrLibBAL(libHandle^.Lib).MoverStringParaPChar(Resposta, sValor, esTamanho);
      TACBrLibBAL(libHandle^.Lib).SetRetorno(Result, Resposta);
    end;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function BAL_InterpretarRespostaPeso(const libHandle: PLibHandle; eResposta: PAnsiChar; var Peso: Double): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibBAL(libHandle^.Lib).InterpretarRespostaPeso(eResposta, Peso);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function BAL_InterpretarRespostaPesoStr(const libHandle: PLibHandle; eResposta: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: Integer): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Peso: Double;
  Resposta: string;
begin
  try
    VerificarLibInicializada(libHandle);
    Peso := 0;
    Result := TACBrLibBAL(libHandle^.Lib).InterpretarRespostaPeso(eResposta, Peso);
    if Result = 0 then
    begin
      Resposta := FloatToString(Peso);
      TACBrLibBAL(libHandle^.Lib).MoverStringParaPChar(Resposta, sValor, esTamanho);
      TACBrLibBAL(libHandle^.Lib).SetRetorno(Result, Resposta);
    end;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

{%endregion}

{%endregion}

end.

