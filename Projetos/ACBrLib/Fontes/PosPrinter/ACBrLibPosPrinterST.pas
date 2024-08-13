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

{$I ACBr.inc}

unit ACBrLibPosPrinterST;

interface

uses
  Classes, SysUtils,
  ACBrLibPosPrinterBase, ACBrLibComum;

{%region Declaração da funções}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function POS_Inicializar(const eArqConfig, eChaveCrypt: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Finalizar: integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Inicializada: Boolean;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Nome(const sNome: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Versao(const sVersao: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_OpenSSLInfo(const sOpenSSLInfo: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_UltimoRetorno(const sMensagem: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ConfigImportar(const eArqConfig: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ConfigExportar(const sMensagem: PAnsiChar; var esTamanho: integer): integer;
      {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ConfigLer(const eArqConfig: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ConfigGravar(const eArqConfig: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ConfigLerValor(const eSessao, eChave: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ConfigGravarValor(const eSessao, eChave, eValor: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Ativar}
function POS_Ativar: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Desativar: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Impressão}
function POS_Imprimir(eString: PAnsiChar; PulaLinha, DecodificarTags,
  CodificarPagina: Boolean; Copias: Integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirLinha(eString: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirCmd(eComando: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirTags: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirImagemArquivo(aPath: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirLogo(nAKC1, nAKC2, nFatorX, nFatorY: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirCheque(CodBanco: Integer; const AValor, ADataEmissao, AFavorecido,
  ACidade, AComplemento: PAnsiChar; LerCMC7: Boolean; SegundosEspera: Integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirTextoCheque(const X, Y: Integer; const AString: PAnsiChar;
  AguardaCheque: Boolean; SegundosEspera: Integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Diversos}
function POS_TxRx(eCmd: PAnsiChar; BytesToRead: Byte; ATimeOut: Integer; WaitForTerminator: Boolean;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Zerar: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_InicializarPos: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Reset: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_PularLinhas(NumLinhas: Integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_CortarPapel(Parcial: Boolean): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_AbrirGaveta: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_LerInfoImpressora(const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_LerStatusImpressora(Tentativas: Integer; var status: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_LerStatusImpressoraFormatado(Tentativas: Integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_RetornarTags(IncluiAjuda: Boolean; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_AcharPortas(const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_GravarLogoArquivo(aPath: PAnsiChar; nAKC1, nAKC2: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ApagarLogo(nAKC1, nAKC2: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_LeituraCheque(const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_LerCMC7(AguardaCheque: Boolean; SegundosEspera: Integer;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_EjetarCheque: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_PodeLerDaPorta: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_LerCaracteristicas(const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%endregion}

implementation

uses
  ACBrLibConsts;

{%region PosPrinter}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function POS_Inicializar(const eArqConfig, eChaveCrypt: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(pLib, TACBrLibPosPrinter,eArqConfig, eChaveCrypt);
end;

function POS_Finalizar: integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar(pLib);
end;

function POS_Inicializada: Boolean;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicalizada(pLib);
end;

function POS_Nome(const sNome: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(pLib, sNome, esTamanho);
end;

function POS_Versao(const sVersao: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(pLib, sVersao, esTamanho);
end;

function POS_OpenSSLInfo(const sOpenSSLInfo: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_OpenSSLInfo(pLib, sOpenSSLInfo, esTamanho);
end;

function POS_UltimoRetorno(const sMensagem: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(pLib, sMensagem, esTamanho);
end;

function POS_ConfigImportar(const eArqConfig: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigImportar(pLib, eArqConfig);
end;

function POS_ConfigExportar(const sMensagem: PAnsiChar; var esTamanho: integer): integer;
      {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigExportar(pLib, sMensagem, esTamanho);
end;

function POS_ConfigLer(const eArqConfig: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(pLib, eArqConfig);
end;

function POS_ConfigGravar(const eArqConfig: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(pLib, eArqConfig);
end;

function POS_ConfigLerValor(const eSessao, eChave: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(pLib, eSessao, eChave, sValor, esTamanho);
end;

function POS_ConfigGravarValor(const eSessao, eChave, eValor: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(pLib, eSessao, eChave, eValor);
end;
{%endregion}

{%region Ativar}
function POS_Ativar: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).Ativar;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_Desativar: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).Desativar;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;
{%endregion}

{%region Impressão}
function POS_Imprimir(eString: PAnsiChar; PulaLinha, DecodificarTags,
  CodificarPagina: Boolean; Copias: Integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).Imprimir(eString, PulaLinha, DecodificarTags, CodificarPagina, Copias);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_ImprimirLinha(eString: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).ImprimirLinha(eString);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_ImprimirCmd(eComando: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).ImprimirCmd(eComando);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_ImprimirTags: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).ImprimirTags;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_ImprimirImagemArquivo(aPath: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).ImprimirImagemArquivo(aPath);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_ImprimirLogo(nAKC1, nAKC2, nFatorX, nFatorY: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).ImprimirLogo(nAKC1, nAKC2, nFatorX, nFatorY);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_ImprimirCheque(CodBanco: Integer; const AValor, ADataEmissao, AFavorecido, ACidade,
                            AComplemento: PAnsiChar; LerCMC7: Boolean; SegundosEspera: Integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).ImprimirCheque(CodBanco, AValor, ADataEmissao, AFavorecido, ACidade,
                                                           AComplemento, LerCMC7, SegundosEspera);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_ImprimirTextoCheque(const X, Y: Integer; const AString: PAnsiChar; AguardaCheque: Boolean;
                                  SegundosEspera: Integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).ImprimirTextoCheque(X, Y, AString, AguardaCheque, SegundosEspera);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;
{%endregion}

{%region Diversos}
function POS_TxRx(eCmd: PAnsiChar; BytesToRead: Byte; ATimeOut: Integer; WaitForTerminator: Boolean;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).TxRx(eCmd, BytesToRead, ATimeOut, WaitForTerminator, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_Zerar: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).Zerar;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_InicializarPos: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).InicializarPos;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_Reset: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).Reset;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_PularLinhas(NumLinhas: Integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).PularLinhas(NumLinhas);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_CortarPapel(Parcial: Boolean): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).CortarPapel(Parcial);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_AbrirGaveta: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).AbrirGaveta;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_LerInfoImpressora(const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).LerInfoImpressora(sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_LerStatusImpressora(Tentativas: Integer; var status: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).LerStatusImpressora(Tentativas, status);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_LerStatusImpressoraFormatado(Tentativas: Integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).LerStatusImpressoraFormatado(Tentativas, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_RetornarTags(IncluiAjuda: Boolean; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).RetornarTags(IncluiAjuda, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_AcharPortas(const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).AcharPortas(sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_GravarLogoArquivo(aPath: PAnsiChar; nAKC1, nAKC2: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).GravarLogoArquivo(aPath, nAKC1, nAKC2);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_ApagarLogo(nAKC1, nAKC2: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).ApagarLogo(nAKC1, nAKC2);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_LeituraCheque(const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).LeituraCheque(sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_LerCMC7(AguardaCheque: Boolean; SegundosEspera: Integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).LerCMC7(AguardaCheque, SegundosEspera, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_EjetarCheque: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).EjetarCheque;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_PodeLerDaPorta: integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).PodeLerDaPorta;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function POS_LerCaracteristicas(const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPosPrinter(pLib^.Lib).LerCaracteristicas(sResposta, esTamanho);
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

