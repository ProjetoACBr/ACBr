{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrLibeSocialST;

interface

uses
  Classes, SysUtils, Forms,
  ACBrLibComum;

function eSocial_Inicializar (const eArqConfig, eChaveCrypt: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_Finalizar: Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_Nome (const sNome: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_Versao (const sVersao: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_OpenSSLInfo(const sOpenSSLInfo: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_UltimoRetorno (const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ConfigImportar (const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ConfigExportar (const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ConfigLer (const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ConfigGravar (const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ConfigLerValor (const eSessao, eChave: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ConfigGravarValor (const eSessao, eChave, eValor: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_CriarEventoeSocial (const eArqIni: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_EnviareSocial (aGrupo: integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ConsultareSocial (eProtocolo: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_CriarEnviareSocial (const eArqIni: PAnsiChar; aGrupo:integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_LimpareSocial: Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_CarregarXMLEventoeSocial (const eArquivoOuXML: PAnsiChar):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_SetIDEmpregador (const aIdEmpregador: PAnsiChar):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_SetIDTransmissor (const aIdTransmissor: PAnsiChar):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_SetTipoEmpregador (aTipoEmpregador: integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_SetVersaoDF (const sVersao: PAnsiChar):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ConsultaIdentificadoresEventosEmpregador (const aIdEmpregador: PAnsiChar; aTipoEvento: integer; aPeriodoApuracao: TDateTime; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ConsultaIdentificadoresEventosTabela (const aIdEmpregador: PAnsiChar; aTipoEvento: integer; aChave: PAnsiChar; aDataInicial: TDateTime; aDataFinal: TDateTime; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ConsultaIdentificadoresEventosTrabalhador (const aIdEmpregador: PAnsiChar; aCPFTrabalhador: PAnsiChar; aDataInicial:TDateTime; aDataFinal: TDateTime; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_DownloadEventos (const aIdEmpregador: PAnsiChar; aCPFTrabalhador: PAnsiChar; aDataInicial: TDateTime; aDataFinal: TDateTime; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_ObterCertificados(const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function eSocial_Validar: Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};


implementation

Uses
  ACBrLibConsts, ACBrLibeSocialBase;

function eSocial_Inicializar(const eArqConfig, eChaveCrypt: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(pLib, TACBrLibeSocial, eArqConfig, eChaveCrypt);
end;

function eSocial_Finalizar: Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar(pLib);
  pLib := Nil;
end;

function eSocial_Nome(const sNome: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(pLib, sNome, esTamanho);
end;

function eSocial_Versao(const sVersao: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(pLib, sVersao, esTamanho);
end;

function eSocial_OpenSSLInfo(const sOpenSSLInfo: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_OpenSSLInfo(pLib, sOpenSSLInfo, esTamanho);
end;

function eSocial_UltimoRetorno(const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(pLib, sMensagem, esTamanho);
end;

function eSocial_ConfigImportar(const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigImportar(pLib, eArqConfig);
end;

function eSocial_ConfigExportar(const sMensagem: PAnsiChar; var esTamanho: Integer
  ): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigExportar(pLib, sMensagem, esTamanho);
end;

function eSocial_ConfigLer(const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(pLib, eArqConfig);
end;

function eSocial_ConfigGravar(const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(pLib, eArqConfig);
end;

function eSocial_ConfigLerValor(const eSessao, eChave: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(pLib, eSessao, eChave, sValor, esTamanho);
end;

function eSocial_ConfigGravarValor(const eSessao, eChave, eValor: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(pLib, eSessao, eChave, eValor);
end;

function eSocial_CriarEventoeSocial(const eArqIni: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
  VerificarLibInicializada(pLib);
  Result := TACBrLibeSocial(pLib^.Lib).CriarEventoeSocial(eArqIni);
  except
  on E: EACBrLibException do
     Result := E.Erro;

  on E: Exception do
     Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_EnviareSocial(aGrupo: integer; const sResposta: PAnsiChar; var esTamanho: Integer
  ): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).EnviareSocial(aGrupo, sResposta, esTamanho);
  except
   on E: EACBrLibException do
    Result := E.Erro;

   on E: Exception do
    Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_ConsultareSocial(eProtocolo: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).ConsultareSocial(eProtocolo, sResposta, esTamanho);
  except
   on E: EACBrLibException do
    Result := E.Erro;

   on E: Exception do
    Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_CriarEnviareSocial (const eArqIni: PAnsiChar; aGrupo:integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).CriarEnviareSocial(eArqIni, aGrupo);
  except
   on E: EACBrLibException do
    Result := E.Erro;

   on E: Exception do
    Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_LimpareSocial: Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).LimpareSocial;
  except
   on E: EACBrLibException do
    Result := E.Erro;

   on E: Exception do
    Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_CarregarXMLEventoeSocial (const eArquivoOuXML: PAnsiChar):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).CarregarXMLEventoeSocial(eArquivoOuXML);
  except
   on E: EACBrLibException do
    Result := E.Erro;

   on E: Exception do
    Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_SetIDEmpregador (const aIdEmpregador: PAnsiChar):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).SetIDEmpregador(aIdEmpregador);
  except
   on E: EACBrLibException do
    Result := E.Erro;

   on E: Exception do
    Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_SetIDTransmissor (const aIdTransmissor: PAnsiChar):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).SetIDTransmissor(aIdTransmissor);
  except
   on E: EACBrLibException do
   Result := E.Erro;

   on E: Exception do
   Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_SetTipoEmpregador (aTipoEmpregador: integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).SetTipoEmpregador(aTipoEmpregador);
  except
   on E: EACBrLibException do
   Result := E.Erro;

   on E: Exception do
   Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_SetVersaoDF (const sVersao: PAnsiChar):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).SetVersaoDF(sVersao);
  except
   on E: EACBrLibException do
   Result := E.Erro;

   on E: Exception do
   Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_ConsultaIdentificadoresEventosEmpregador (const aIdEmpregador: PAnsiChar; aTipoEvento: integer; aPeriodoApuracao: TDateTime; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).ConsultaIdentificadoresEventosEmpregador(aIdEmpregador, aTipoEvento, aPeriodoApuracao, sResposta, esTamanho);
  except
   on E: EACBrLibException do
   Result := E.Erro;

   on E: Exception do
   Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_ConsultaIdentificadoresEventosTabela (const aIdEmpregador: PAnsiChar; aTipoEvento: integer; aChave: PAnsiChar; aDataInicial: TDateTime; aDataFinal: TDateTime; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).ConsultaIdentificadoresEventosTabela(aIdEmpregador, aTipoEvento, aChave, aDataInicial, aDataFinal, sResposta, esTamanho);
  except
   on E: EACBrLibException do
   Result := E.Erro;

   on E: Exception do
   Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_ConsultaIdentificadoresEventosTrabalhador (const aIdEmpregador: PAnsiChar; aCPFTrabalhador: PAnsiChar; aDataInicial:TDateTime; aDataFinal: TDateTime; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).ConsultaIdentificadoresEventosTrabalhador(aIdEmpregador, aCPFTrabalhador, aDataInicial, aDataFinal, sResposta, esTamanho);
  except
   on E: EACBrLibException do
   Result := E.Erro;

   on E: Exception do
   Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_DownloadEventos (const aIdEmpregador: PAnsiChar; aCPFTrabalhador: PAnsiChar; aDataInicial: TDateTime; aDataFinal: TDateTime; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
   VerificarLibInicializada(pLib);
   Result := TACBrLibeSocial(pLib^.Lib).DownloadEventos(aIdEmpregador, aCPFTrabalhador, aDataInicial, aDataFinal, sResposta, esTamanho);
  except
   on E: EACBrLibException do
   Result := E.Erro;

   on E: Exception do
   Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_ObterCertificados (const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibeSocial(pLib^.Lib).ObterCertificados(sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function eSocial_Validar: Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(pLib);
    Result := TACBrLibeSocial(pLib^.Lib).Validar;
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

end.

