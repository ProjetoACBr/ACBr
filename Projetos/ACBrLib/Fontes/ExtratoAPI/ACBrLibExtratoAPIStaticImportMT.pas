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

unit ACBrLibExtratoAPIStaticImportMT;

{$IfDef FPC}
{$mode objfpc}{$H+}
{$EndIf}

{.$Define STDCALL}

interface

uses
  Classes, SysUtils;

const
 {$IfDef MSWINDOWS}
  {$IfDef CPU64}
  CACBrExtratoAPILIBName = 'ACBrExtratoAPI64.dll';
  {$Else}
  CACBrExtratoAPILIBName = 'ACBrExtratoAPI32.dll';
  {$EndIf}
 {$Else}
  {$IfDef CPU64}
  CACBrExtratoAPILIBName = 'ACBrExtratoAPI64.so';
  {$Else}
  CACBrExtratoAPILIBName = 'ACBrExtratoAPI32.so';

  {$EndIf}
 {$EndIf}

 {$I ACBrLibErros.inc}

 {%region Constructor/Destructor}
 function ExtratoAPI_Inicializar(var libHandle: TLibHandle; const eArqConfig, eChaveCrypt: PChar): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;

 function ExtratoAPI_Finalizar (const libHandle: TLibHandle): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;
 {%endregion}

 {%region Versao/Retorno}
 function ExtratoAPI_Nome(const libHandle: TLibHandle; const sNome: PChar; var esTamanho: longint): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;

 function ExtratoAPI_Versao(const libHandle: TLibHandle; const sVersao: PChar; var esTamanho: longint): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;

 function ExtratoAPI_OpenSSLInfo(const libHandle: TLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: longint): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;

 function ExtratoAPI_UltimoRetorno(const libHandle: TLibHandle; const sMensagem: PChar; var esTamanho: longint): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;
 {%endregion}

 {%region Ler/Gravar Config }
 function ExtratoAPI_ConfigLer(const libHandle: TLibHandle; const eArqConfig: PChar): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;

 function ExtratoAPI_ConfigGravar(const libHandle: TLibHandle; const eArqConfig: PChar): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;

 function ExtratoAPI_ConfigLerValor(const libHandle: TLibHandle; const eSessao, eChave: PChar; sValor: PChar; var esTamanho: longint): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;

 function ExtratoAPI_ConfigGravarValor(const libHandle: TLibHandle; const eSessao, eChave, eValor: PChar): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;
 {%endregion}

 {%region ExtratoAPI}
 function ExtratoAPI_ConsultarExtrato(const libHandle: TLibHandle; const AAgencia, AConta: PAnsiChar;
   const ADataInicio, ADataFim: TDateTime; const APagina, ARegistrosPorPag: integer;
   const sResposta: PAnsiChar; var esTamanho: integer): longint;
   {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrExtratoAPILIBName;
 {%endregion}

implementation

end.
