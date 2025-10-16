{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Renato Rubinho                                  }
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

unit ACBrLibExtratoAPIMT;

interface

uses
  Classes, SysUtils, Forms,
  ACBrLibComum;

function ExtratoAPI_Inicializar(var libHandle: PLibHandle; const eArqConfig, eChaveCrypt: Pchar): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_Finalizar(libHandle: PLibHandle): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_Nome(const libHandle : PLibHandle; const sNome: PChar; var esTamanho: longint): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_Versao(const libHandle : PLibHandle; const sVersao: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_OpenSSLInfo(const libHandle : PLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: longint): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_UltimoRetorno(const libHandle : PLibHandle; const sMensagem: PChar; var esTamanho: longint): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_ConfigImportar(const libHandle : PLibHandle; const eArqConfig: PChar): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_ConfigExportar(const libHandle : PLibHandle; const sMensagem: PChar; var esTamanho: longint): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_ConfigLer(const libHandle : PLibHandle; const eArqConfig: PChar): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_ConfigGravar(const libHandle : PLibHandle; const eArqConfig: PChar): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_ConfigLerValor(const libHandle : PLibHandle; const eSessao, eChave: PChar; sValor: PChar;
  var esTamanho: longint): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_ConfigGravarValor(const libHandle : PLibHandle; const eSessao, eChave, eValor: PChar): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function ExtratoAPI_ConsultarExtrato(const libHandle : PLibHandle; const AAgencia, AConta: PAnsiChar;
  const ADataInicio, ADataFim: TDateTime; const APagina, ARegistrosPorPag: integer;
  const sResposta: PAnsiChar; var esTamanho: integer): longint;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

implementation

uses
  ACBrLibConsts, ACBrLibExtratoAPIBase;

function ExtratoAPI_Inicializar(var libHandle: PLibHandle; const eArqConfig, eChaveCrypt: Pchar): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(libHandle, TACBrLibExtratoAPI, eArqConfig, eChaveCrypt);
end;

function ExtratoAPI_Finalizar (libHandle: PLibHandle): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar(libHandle);
  libHandle := nil;
end;

function ExtratoAPI_Nome(const libHandle: PLibHandle; const sNome: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(libHandle, sNome, esTamanho);
end;

function ExtratoAPI_Versao(const libHandle: PLibHandle; const sVersao: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(libHandle, sVersao, esTamanho);
end;

function ExtratoAPI_OpenSSLInfo(const libHandle: PLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_OpenSSLInfo(libHandle, sOpenSSLInfo, esTamanho);
end;

function ExtratoAPI_UltimoRetorno(const libHandle: PLibHandle; const sMensagem: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(libHandle, sMensagem, esTamanho);
end;

function ExtratoAPI_ConfigImportar(const libHandle: PLibHandle; const eArqConfig: PChar): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigImportar(libHandle, eArqConfig);
end;

function ExtratoAPI_ConfigExportar(const libHandle: PLibHandle; const sMensagem: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigExportar(libHandle, sMensagem, esTamanho);
end;

function ExtratoAPI_ConfigLer(const libHandle: PLibHandle; const eArqConfig: PChar): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(libHandle, eArqConfig);
end;

function ExtratoAPI_ConfigGravar(const libHandle: PLibHandle; const eArqConfig: PChar): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(libHandle, eArqConfig);
end;

function ExtratoAPI_ConfigLerValor(const libHandle: PLibHandle; const eSessao, eChave: PChar; sValor: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(libHandle, eSessao, eChave, sValor, esTamanho);
end;

function ExtratoAPI_ConfigGravarValor(const libHandle: PLibHandle; const eSessao, eChave, eValor: PChar): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(libHandle, eSessao, eChave, eValor);
end;

function ExtratoAPI_ConsultarExtrato(const libHandle: PLibHandle; const AAgencia, AConta: PAnsiChar;
  const ADataInicio, ADataFim: TDateTime; const APagina, ARegistrosPorPag: integer;
  const sResposta: PAnsiChar; var esTamanho: integer): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibExtratoAPI(libHandle^.Lib).ConsultarExtrato(AAgencia, AConta, ADataInicio, ADataFim, APagina, ARegistrosPorPag, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

end.
