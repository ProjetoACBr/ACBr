﻿{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
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

unit ACBrLibCEPStaticImportMT;

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
  CACBrCEPLIBName = 'ACBrCEP64.dll';
  {$Else}
  CACBrCEPLIBName = 'ACBrCEP32.dll';
  //CACBrCEPLIBName = 'ACBrLibCEP.dll';  // Delphi
  {$EndIf}
 {$Else}
  {$IfDef CPU64}
  CACBrCEPLIBName = 'libacbrcep64.so';
  {$Else}
  CACBrCEPLIBName = 'libacbrcep32.so';
  {$EndIf}
 {$EndIf}

{$IfNDef FPC}
type
   TLibHandle = THandle;
{$EndIf}

{$I ACBrLibErros.inc}

{%region Constructor/Destructor}
function CEP_Inicializar(var libHandle: TLibHandle; const eArqConfig, eChaveCrypt: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;

function CEP_Finalizar(const libHandle: TLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;
{%endregion}

{%region Versao/Retorno}
function CEP_Nome(const libHandle: TLibHandle; const sNome: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;

function CEP_Versao(const libHandle: TLibHandle; const sVersao: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;

function CEP_OpenSSLInfo(const libHandle: TLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;

function CEP_UltimoRetorno(const libHandle: TLibHandle; const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;
{%endregion}

{%region Ler/Gravar Config }
function CEP_ConfigLer(const libHandle: TLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;

function CEP_ConfigGravar(const libHandle: TLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;

function CEP_ConfigLerValor(const libHandle: TLibHandle; const eSessao, eChave: PAnsiChar; sValor: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;

function CEP_ConfigGravarValor(const libHandle: TLibHandle; const eSessao, eChave, eValor: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;
{%endregion}

{%region CEPança}
function CEP_BuscarPorCEP(const libHandle: TLibHandle; eCEP: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;
function CEP_BuscarPorLogradouro(const libHandle: TLibHandle; eCidade, eTipo_Logradouro, eLogradouro, eUF,
  eBairro: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrCEPLIBName;
{%endregion}

implementation

end.
