{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrLibNFeStaticImportMT;

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
  CACBrNFeLIBName = 'ACBrNFe64.dll';
  {$Else}
  CACBrNFeLIBName = 'ACBrNFe32.dll';
  {$EndIf}
 {$Else}
  {$IfDef CPU64}
  CACBrNFeLIBName = 'ACBrNFe64.so';
  {$Else}
  CACBrNFeLIBName = 'ACBrNFe32.so';

  {$EndIf}
 {$EndIf}

{$I ACBrLibErros.inc}

{%region Constructor/Destructor}
function NFE_Inicializar(var libHandle: TLibHandle; const eArqConfig, eChaveCrypt: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_Finalizar(const libHandle: TLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;
{%endregion}

{%region Versao/Retorno}
function NFE_Nome(const libHandle: TLibHandle; const sNome: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_Versao(const libHandle: TLibHandle; const sVersao: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_OpenSSLInfo(const libHandle: TLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_UltimoRetorno(const libHandle: TLibHandle; const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;
{%endregion}

{%region Ler/Gravar Config }
function NFE_ConfigLer(const libHandle: TLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_ConfigGravar(const libHandle: TLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_ConfigLerValor(const libHandle: TLibHandle; const eSessao, eChave: PAnsiChar; sValor: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_ConfigGravarValor(const libHandle: TLibHandle; const eSessao, eChave, eValor: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;
{%endregion}

{%region NFe}
function NFE_CarregarXML(const libHandle: TLibHandle; const eArquivoOuXML: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_CarregarINI(const libHandle: TLibHandle; const eArquivoOuINI: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_CarregarEventoXML(const libHandle: TLibHandle; const eArquivoOuXML: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_CarregarEventoINI(const libHandle: TLibHandle; const eArquivoOuINI: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_LimparLista(const libHandle: TLibHandle) : Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_LimparListaEventos(const libHandle: TLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_Assinar(const libHandle: TLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_Validar(const libHandle:Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_ValidarRegrasdeNegocios(const libHandle: TLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_VerificarAssinatura(const libHandle: TLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;
{%endregion}

{%region Servicos}
function NFE_StatusServico(const libHandle: TLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_Consultar(const libHandle: TLibHandle; const eChaveOuNFe: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_ConsultarRecibo(const libHandle: TLibHandle; const ARecibo: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_Inutilizar(const libHandle: TLibHandle; const ACNPJ, AJustificativa: PAnsiChar;
  Ano, Modelo, Serie, NumeroInicial, NumeroFinal: integer;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_Enviar(const libHandle: TLibHandle; ALote: Integer; Imprimir, Sincrono, Zipado: Boolean;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_Cancelar(const libHandle: TLibHandle; const eChave, eJustificativa, eCNPJ: PAnsiChar; ALote: Integer;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_EnviarEvento(const libHandle: TLibHandle; idLote: Integer;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_DistribuicaoDFePorUltNSU(const libHandle: TLibHandle; const AcUFAutor: integer; eCNPJCPF, eultNSU: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_DistribuicaoDFePorNSU(const libHandle: TLibHandle; const AcUFAutor: integer; eCNPJCPF, eNSU: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_DistribuicaoDFePorChave(const libHandle: TLibHandle; const AcUFAutor: integer; eCNPJCPF, echNFe: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_EnviarEmail(const libHandle: TLibHandle; const ePara, eChaveNFe: PAnsiChar; const AEnviaPDF: Boolean;
  const eAssunto, eCC, eAnexos, eMensagem: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_EnviarEmailEvento(const libHandle: TLibHandle; const ePara, eChaveEvento, eChaveNFe: PAnsiChar;
  const AEnviaPDF: Boolean; const eAssunto, eCC, eAnexos, eMensagem: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_Imprimir(libHandle: TLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_Imprimir(const libHandle: TLibHandle; const cImpressora: PAnsiChar; nNumCopias: Integer; const cProtocolo,
    bMostrarPreview, cMarcaDagua, bViaConsumidor, bSimplificado: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_ImprimirEvento(const libHandle: TLibHandle; const eChaveNFe, eChaveEvento: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_ImprimirEventoPDF(const libHandle: TLibHandle; const eChaveNFe, eChaveEvento: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_ImprimirInutilizacao(const libHandle: TLibHandle; const eChave: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;

function NFE_ImprimirInutilizacaoPDF(const libHandle: TLibHandle; const eChave: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf}; external CACBrNFeLIBName;
{%endregion}


implementation

end.
