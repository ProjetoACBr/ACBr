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

unit ACBrLibSATMT;

interface

uses
  Classes, SysUtils, typinfo, ACBrLibComum;

{%region Declaração da funções}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function SAT_Inicializar(var libHandle: PLibHandle; const eArqConfig, eChaveCrypt: PAnsiChar): integer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_Finalizar(libHandle: PLibHandle): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_Nome(const libHandle: PLibHandle; const sNome: PAnsiChar; var esTamanho: integer): integer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_Versao(const libHandle: PLibHandle; const sVersao: PAnsiChar; var esTamanho: integer): integer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_OpenSSLInfo(const libHandle: PLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: integer): integer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_UltimoRetorno(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: integer): integer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConfigImportar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConfigExportar(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: integer): integer;
      {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConfigLer(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): integer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConfigGravar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): integer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConfigLerValor(const libHandle: PLibHandle; const eSessao, eChave: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConfigGravarValor(const libHandle: PLibHandle; const eSessao, eChave, eValor: PAnsiChar): integer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Ativar}
function SAT_InicializarSAT(const libHandle: PLibHandle): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_DesInicializar(const libHandle: PLibHandle): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Funções SAT}
function SAT_AtivarSAT(const libHandle: PLibHandle; CNPJvalue: PAnsiChar; cUF: integer;
  const sResposta: PAnsiChar; var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_AssociarAssinatura(const libHandle: PLibHandle; CNPJvalue, assinaturaCNPJs: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_BloquearSAT(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_DesbloquearSAT(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_TrocarCodigoDeAtivacao(const libHandle: PLibHandle; codigoDeAtivacaoOuEmergencia: PAnsiChar;
  opcao: integer; novoCodigo: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConsultarSAT(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
function SAT_ConsultarUltimaSessaoFiscal(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConsultarStatusOperacional(const libHandle: PLibHandle; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConsultarNumeroSessao(const libHandle: PLibHandle; cNumeroDeSessao: integer;
  const sResposta: PAnsiChar; var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_SetNumeroSessao(const libHandle:PLibHandle; cNumeroDeSessao: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_AtualizarSoftwareSAT(const libHandle: PLibHandle; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ComunicarCertificadoICPBRASIL(const libHandle: PLibHandle; certificado: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ExtrairLogs(const libHandle: PLibHandle; eArquivo: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_TesteFimAFim(const libHandle: PLibHandle; eArquivoXmlVenda: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_GerarAssinaturaSAT(const libHandle: PLibHandle; eCNPJSHW, eCNPJEmitente: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region CFe}
function SAT_CriarCFe(const libHandle: PLibHandle; eArquivoIni: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_CriarEnviarCFe(const libHandle: PLibHandle; eArquivoIni: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ValidarCFe(const libHandle: PLibHandle; eArquivoXml: PAnsiChar): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_CarregarXML(const libHandle: PLibHandle; eArquivoXml: PAnsiChar): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ObterIni(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_EnviarCFe(const libHandle: PLibHandle; eArquivoXml: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_CancelarCFe(const libHandle: PLibHandle; eArquivoXml: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Impressão}
function SAT_ImprimirExtratoVenda(const libHandle: PLibHandle; eArqXMLVenda, eNomeImpressora: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ImprimirExtratoResumido(const libHandle: PLibHandle; eArqXMLVenda, eNomeImpressora: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ImprimirExtratoCancelamento(const libHandle: PLibHandle; eArqXMLVenda, eArqXMLCancelamento,
  eNomeImpressora: PAnsiChar): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_SalvarPDF(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer)
  : integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_GerarImpressaoFiscalMFe(const libHandle: PLibHandle; eArqXMLVenda: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_GerarPDFExtratoVenda(const libHandle: PLibHandle; eArqXMLVenda, eNomeArquivo: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_GerarPDFCancelamento(const libHandle: PLibHandle; eArqXMLVenda, eArqXMLCancelamento, eNomeArquivo: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_EnviarEmail(const libHandle: PLibHandle; eArqXMLVenda, sPara, sAssunto, eNomeArquivo, sMensagem,
  sCC, eAnexos: PAnsiChar): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%endregion}

implementation

uses
  ACBrLibConsts, ACBrLibSATBase;

{ ACBrLibSAT }

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function SAT_Inicializar(var libHandle: PLibHandle; const eArqConfig, eChaveCrypt: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(libHandle, TACBrLibSAT, eArqConfig, eChaveCrypt);
end;

function SAT_Finalizar(libHandle: PLibHandle): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar(libHandle);
end;

function SAT_Nome(const libHandle: PLibHandle; const sNome: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(libHandle, sNome, esTamanho);
end;

function SAT_Versao(const libHandle: PLibHandle; const sVersao: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(libHandle, sVersao, esTamanho);
end;

function SAT_OpenSSLInfo(const libHandle: PLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_OpenSSLInfo(libHandle, sOpenSSLInfo, esTamanho);
end;

function SAT_UltimoRetorno(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(libHandle, sMensagem, esTamanho);
end;

function SAT_ConfigImportar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigImportar(libHandle, eArqConfig);
end;

function SAT_ConfigExportar(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: integer): integer;
      {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigExportar(libHandle, sMensagem, esTamanho);
end;

function SAT_ConfigLer(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(libHandle, eArqConfig);
end;

function SAT_ConfigGravar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(libHandle, eArqConfig);
end;

function SAT_ConfigLerValor(const libHandle: PLibHandle; const eSessao, eChave: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(libHandle, eSessao, eChave, sValor, esTamanho);
end;

function SAT_ConfigGravarValor(const libHandle: PLibHandle; const eSessao, eChave, eValor: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(libHandle, eSessao, eChave, eValor);
end;

{%endregion}

{%region Ativar}
function SAT_InicializarSAT(const libHandle: PLibHandle): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).InicializarSAT;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_DesInicializar(const libHandle: PLibHandle): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).DesInicializar;
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;
{%endregion}

{%region Funções SAT}
function SAT_AtivarSAT(const libHandle: PLibHandle; CNPJvalue: PAnsiChar; cUF: integer;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).AtivarSAT(CNPJvalue, cUF, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_AssociarAssinatura(const libHandle: PLibHandle; CNPJvalue, assinaturaCNPJs: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).AssociarAssinatura(CNPJvalue, assinaturaCNPJs, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_BloquearSAT(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).BloquearSAT(sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_DesbloquearSAT(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).DesbloquearSAT(sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_TrocarCodigoDeAtivacao(const libHandle: PLibHandle; codigoDeAtivacaoOuEmergencia: PAnsiChar;
  opcao: integer; novoCodigo: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).TrocarCodigoDeAtivacao(codigoDeAtivacaoOuEmergencia, opcao, novoCodigo,
                                                            sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_ConsultarSAT(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ConsultarSAT(sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_ConsultarUltimaSessaoFiscal(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ConsultarUltimaSessaoFiscal(sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_ConsultarStatusOperacional(const libHandle: PLibHandle; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ConsultarStatusOperacional(sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_ConsultarNumeroSessao(const libHandle: PLibHandle; cNumeroDeSessao: integer;
  const sResposta: PAnsiChar; var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ConsultarNumeroSessao(cNumeroDeSessao, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_SetNumeroSessao(const libHandle: PLibHandle; cNumeroDeSessao: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).SetNumeroSessao(cNumeroDeSessao);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_AtualizarSoftwareSAT(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).AtualizarSoftwareSAT(sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_ComunicarCertificadoICPBRASIL(const libHandle: PLibHandle; certificado: PAnsiChar;  const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ComunicarCertificadoICPBRASIL(certificado, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_ExtrairLogs(const libHandle: PLibHandle; eArquivo: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ExtrairLogs(eArquivo);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_TesteFimAFim(const libHandle: PLibHandle; eArquivoXmlVenda: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).TesteFimAFim(eArquivoXmlVenda, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_GerarAssinaturaSAT(const libHandle: PLibHandle; eCNPJSHW, eCNPJEmitente: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).GerarAssinaturaSAT(eCNPJSHW, eCNPJEmitente, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

{%endregion}

{%region CFe}

function SAT_CriarCFe(const libHandle: PLibHandle; eArquivoIni: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).CriarCFe(eArquivoIni, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_CriarEnviarCFe(const libHandle: PLibHandle; eArquivoIni: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).CriarEnviarCFe(eArquivoIni, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_ValidarCFe(const libHandle: PLibHandle; eArquivoXml: PAnsiChar):integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ValidarCFe(eArquivoXml);
  except
    on E: EACBrLibException do
       Result := E.Erro;

    on E: Exception do
       Result := ErrExecutandoMetodo;
  end;
end;

function SAT_CarregarXML(const libHandle: PLibHandle; eArquivoXml: PAnsiChar):integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).CarregarXML(eArquivoXml);
  except
    on E: EACBrLibException do
       Result := E.Erro;

    on E: Exception do
       Result := ErrExecutandoMetodo;
  end;
end;

function SAT_ObterIni(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ObterIni(sResposta, esTamanho);
  except
    on E: EACBrLibException do
       Result := E.Erro;

    on E: Exception do
       Result := ErrExecutandoMetodo;
  end;
end;

function SAT_EnviarCFe(const libHandle: PLibHandle; eArquivoXml: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).EnviarCFe(eArquivoXml, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_CancelarCFe(const libHandle: PLibHandle; eArquivoXml: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).CancelarCFe(eArquivoXml, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

{%endregion}

{%region Impressão}

function SAT_ImprimirExtratoVenda(const libHandle: PLibHandle; eArqXMLVenda, eNomeImpressora: PAnsiChar)
  : integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ImprimirExtratoVenda(eArqXMLVenda, eNomeImpressora);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_ImprimirExtratoResumido(const libHandle: PLibHandle; eArqXMLVenda, eNomeImpressora: PAnsiChar): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ImprimirExtratoResumido(eArqXMLVenda, eNomeImpressora);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_ImprimirExtratoCancelamento(const libHandle: PLibHandle; eArqXMLVenda, eArqXMLCancelamento,
  eNomeImpressora: PAnsiChar): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).ImprimirExtratoCancelamento(eArqXMLVenda, eArqXMLCancelamento, eNomeImpressora);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_SalvarPDF(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: integer): integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).SalvarPDF(sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_GerarImpressaoFiscalMFe(const libHandle: PLibHandle; eArqXMLVenda: PAnsiChar; const sResposta: PAnsiChar;
  var esTamanho: integer): integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).GerarImpressaoFiscalMFe(eArqXMLVenda, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_GerarPDFExtratoVenda(const libHandle: PLibHandle; eArqXMLVenda, eNomeArquivo: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).GerarPDFExtratoVenda(eArqXMLVenda, eNomeArquivo, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_GerarPDFCancelamento(const libHandle: PLibHandle; eArqXMLVenda, eArqXMLCancelamento, eNomeArquivo: PAnsiChar;
  const sResposta: PAnsiChar; var esTamanho: integer): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).GerarPDFCancelamento(eArqXMLVenda, eArqXMLCancelamento, eNomeArquivo,
                                                          sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function SAT_EnviarEmail(const libHandle: PLibHandle; eArqXMLVenda, sPara, sAssunto, eNomeArquivo, sMensagem,
  sCC, eAnexos: PAnsiChar): integer;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibSAT(libHandle^.Lib).EnviarEmail(eArqXMLVenda, sPara, sAssunto, eNomeArquivo, sMensagem,
                                                 sCC, eAnexos);
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
