{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Antonio Carlos Junior                           }
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

unit ACBrLibPIXCDST;

interface

uses
  Classes, SysUtils, Forms,
  ACBrLibComum;

function PIXCD_Inicializar(const eArqConfig, eChaveCrypt: PAnsiChar): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Finalizar: integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Nome(const sNome: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Versao(const sVersao: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_OpenSSLInfo(const sOpenSSLInfo: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_UltimoRetorno(const sMensagem: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConfigImportar(const eArqConfig: PAnsiChar): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConfigExportar(const sMensagem: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConfigLer(const eArqConfig: PAnsiChar): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConfigGravar(const eArqConfig: PAnsiChar): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConfigLerValor(const eSessao, eChave: PAnsiChar; sValor: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConfigGravarValor(const eSessao, eChave, eValor: PAnsiChar): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_GerarQRCodeEstatico(AValor: Double; const AinfoAdicional: PAnsiChar; const ATxID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConsultarPix(const Ae2eid: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConsultarPixRecebidos(ADataInicio: TDateTime; ADataFim: TDateTime; const ATxId: PAnsiChar; const ACpfCnpj: PAnsiChar; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_SolicitarDevolucaoPix(AInfDevolucao: PAnsiChar; const Ae2eid: PAnsiChar; AidDevolucao: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConsultarDevolucaoPix(const Ae2eid, AidDevolucao: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer):integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_CriarCobrancaImediata(AInfCobSolicitada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConsultarCobrancaImediata(const ATxId: PAnsiChar; ARevisao: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConsultarCobrancasCob(ADataInicio: TDateTime; ADataFim: TDateTime; ACpfCnpj: PAnsiChar; ALocationPresente: Boolean; AStatus: integer; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_RevisarCobrancaImediata(AInfCobRevisada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_CancelarCobrancaImediata(ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_CriarCobranca(AInfCobVSolicitada: PAnsiChar; ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConsultarCobranca(const ATxId: PAnsiChar; ARevisao: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_ConsultarCobrancasCobV(ADataInicio: TDateTime; ADataFim: TDateTime; ACpfCnpj: PAnsiChar; ALocationPresente: Boolean; AStatus: integer; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_RevisarCobranca(AInfCobVRevisada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_CancelarCobranca(ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

 //Matera
function PIXCD_Matera_IncluirConta(aInfIncluirConta: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_ConsultarConta(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_InativarConta(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_IncluirChavePix(aAccountId, aExternalID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_ConsultarChavePix(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_ExcluirChavePix(aAccountId, aChavePIX: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_GerarQRCode(aInfQRCode: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_ConsultarTransacao(aAccountId, aTransactionID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_ConsultarSaldoEC(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_ConsultarExtratoEC(aAccountId: PAnsiChar; aInicio: TDateTime; aFim: TDateTime; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_ConsultarMotivosDevolucao(const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_SolicitarDevolucao(aInfSolicitarDevolucao: PAnsiChar; aAccountId, aTransactionID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_ConsultarAliasRetirada(aAccountId, aAlias: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function PIXCD_Matera_SolicitarRetirada(aInfSolicitarRetirada: PAnsiChar; aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

implementation

Uses
  ACBrLibConsts, ACBrLibPIXCDBase;

function PIXCD_Inicializar(const eArqConfig, eChaveCrypt: PAnsiChar): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(pLib, TACBrLibPIXCD, eArqConfig, eChaveCrypt);
end;

function PIXCD_Finalizar: integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar(pLib);
  pLib := Nil;
end;

function PIXCD_Nome(const sNome: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(pLib, sNome, esTamanho);
end;

function PIXCD_Versao(const sVersao: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(pLib, sVersao, esTamanho);
end;

function PIXCD_OpenSSLInfo(const sOpenSSLInfo: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_OpenSSLInfo(pLib, sOpenSSLInfo, esTamanho);
end;

function PIXCD_UltimoRetorno(const sMensagem: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(pLib, sMensagem, esTamanho);
end;

function PIXCD_ConfigImportar(const eArqConfig: PAnsiChar): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigImportar(pLib, eArqConfig);
end;

function PIXCD_ConfigExportar(const sMensagem: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigExportar(pLib, sMensagem, esTamanho);
end;

function PIXCD_ConfigLer(const eArqConfig: PAnsiChar): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(pLib, eArqConfig);
end;

function PIXCD_ConfigGravar(const eArqConfig: PAnsiChar): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(pLib, eArqConfig);
end;

function PIXCD_ConfigLerValor(const eSessao, eChave: PAnsiChar; sValor: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(pLib, eSessao, eChave, sValor, esTamanho);
end;

function PIXCD_ConfigGravarValor(const eSessao, eChave, eValor: PAnsiChar): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(pLib, eSessao, eChave, eValor);
end;

function PIXCD_GerarQRCodeEstatico(AValor: Double; const AinfoAdicional: PAnsiChar; const ATxID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).GerarQRCodeEstatico(AValor, AinfoAdicional, ATxId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_ConsultarPix(const Ae2eid: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).ConsultarPix(Ae2eid, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_ConsultarPixRecebidos(ADataInicio: TDateTime; ADataFim: TDateTime; const ATxId: PAnsiChar; const ACpfCnpj: PAnsiChar; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).ConsultarPixRecebidos(ADataInicio, ADataFim, ATxId, ACpfCnpj, PagAtual, ItensPorPagina, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_SolicitarDevolucaoPix(AInfDevolucao: PAnsiChar; const Ae2eid: PAnsiChar; AidDevolucao: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).SolicitarDevolucaoPix(AInfDevolucao, Ae2eid, AidDevolucao, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_ConsultarDevolucaoPix(const Ae2eid, AidDevolucao: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result:= TACBrLibPIXCD(pLib^.Lib).ConsultarDevolucaoPix(Ae2eid, AidDevolucao, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_CriarCobrancaImediata(AInfCobSolicitada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer):integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result:= TACBrLibPIXCD(pLib^.Lib).CriarCobrancaImediata(AInfCobSolicitada, ATxId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_ConsultarCobrancaImediata(const ATxId: PAnsiChar; ARevisao: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result:= TACBrLibPIXCD(pLib^.Lib).ConsultarCobrancaImediata(ATxId, ARevisao, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_ConsultarCobrancasCob(ADataInicio: TDateTime; ADataFim: TDateTime; ACpfCnpj: PAnsiChar; ALocationPresente: Boolean; AStatus: integer; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result:= TACBrLibPIXCD(pLib^.Lib).ConsultarCobrancasCob(ADataInicio, ADataFim, ACpfCnpj, ALocationPresente, AStatus, PagAtual, ItensPorPagina, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_RevisarCobrancaImediata(AInfCobRevisada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result:= TACBrLibPIXCD(pLib^.Lib).RevisarCobrancaImediata(AInfCobRevisada, ATxId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_CancelarCobrancaImediata(ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).CancelarCobrancaImediata(ATxId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_CriarCobranca(AInfCobVSolicitada: PAnsiChar; ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result:= TACBrLibPIXCD(pLib^.Lib).CriarCobranca(AInfCobVSolicitada, ATxId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_ConsultarCobranca(const ATxId: PAnsiChar; ARevisao: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result:= TACBrLibPIXCD(pLib^.Lib).ConsultarCobranca(ATxId, ARevisao, sResposta, esTamanho);
  except
        on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_ConsultarCobrancasCobV(ADataInicio: TDateTime; ADataFim: TDateTime; ACpfCnpj: PAnsiChar; ALocationPresente: Boolean; AStatus: integer; PagAtual: integer; ItensPorPagina: integer; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result:= TACBrLibPIXCD(pLib^.Lib).ConsultarCobrancasCobV(ADataInicio, ADataFim, ACpfCnpj, ALocationPresente, AStatus, PagAtual, ItensPorPagina, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_RevisarCobranca(AInfCobVRevisada: PAnsiChar; const ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result:= TACBrLibPIXCD(pLib^.Lib).RevisarCobranca(AInfCobVRevisada, ATxId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_CancelarCobranca(ATxId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).CancelarCobranca(ATxId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_IncluirConta(aInfIncluirConta: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraIncluirConta(aInfIncluirConta, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_ConsultarConta(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraConsultarConta(aAccountId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_InativarConta(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraInativarConta(aAccountId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_IncluirChavePix(aAccountId, aExternalID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraIncluirChavePix(aAccountId, aExternalID, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_ConsultarChavePix(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
   try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraConsultarChavePix(aAccountId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_ExcluirChavePix(aAccountId, aChavePIX: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraExcluirChavePix(aAccountId, aChavePIX, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_GerarQRCode(aInfQRCode: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraGerarQRCode(aInfQRCode, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_ConsultarTransacao(aAccountId, aTransactionID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraConsultarTransacao(aAccountId, aTransactionID, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_ConsultarSaldoEC(aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraConsultarSaldoEC(aAccountId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_ConsultarExtratoEC(aAccountId: PAnsiChar; aInicio: TDateTime; aFim: TDateTime; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraConsultarExtratoEC(aAccountId, aInicio, aFim, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_ConsultarMotivosDevolucao(const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraConsultarMotivosDevolucao(sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_SolicitarDevolucao(aInfSolicitarDevolucao: PAnsiChar; aAccountId, aTransactionID: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraSolicitarDevolucao(aInfSolicitarDevolucao, aAccountId, aTransactionID, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_ConsultarAliasRetirada(aAccountId, aAlias: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraConsultarAliasRetirada(aAccountId, aAlias, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function PIXCD_Matera_SolicitarRetirada(aInfSolicitarRetirada: PAnsiChar; aAccountId: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: integer): integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibPIXCD(pLib^.Lib).MateraSolicitarRetirada(aInfSolicitarRetirada, aAccountId, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

end.

