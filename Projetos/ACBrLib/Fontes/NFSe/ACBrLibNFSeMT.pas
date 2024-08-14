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

unit ACBrLibNFSeMT;

interface

uses
  Classes, SysUtils, Forms,
  ACBrLibComum;

{%region Declaração da funções}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function NFSE_Inicializar(var libHandle: PLibHandle; const eArqConfig, eChaveCrypt: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_Finalizar(libHandle: PLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_Nome(const libHandle: PLibHandle; const sNome: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_Versao(const libHandle: PLibHandle; const sVersao: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_OpenSSLInfo(const libHandle: PLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_UltimoRetorno(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConfigImportar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConfigExportar(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConfigLer(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConfigGravar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConfigLerValor(const libHandle: PLibHandle; const eSessao, eChave: PAnsiChar; sValor: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConfigGravarValor(const libHandle: PLibHandle; const eSessao, eChave, eValor: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region NFSe}
function NFSE_CarregarXML(const libHandle: PLibHandle; const eArquivoOuXML: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_CarregarLoteXML(const libHandle: PLibHandle; const eArquivoOuXML: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_CarregarINI(const libHandle: PLibHandle; const eArquivoOuINI: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ObterXml(const libHandle: PLibHandle; AIndex: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_GravarXml(const libHandle: PLibHandle; AIndex: Integer; const eNomeArquivo, ePathArquivo: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ObterIni(const libHandle: PLibHandle; AIndex: Integer; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_GravarIni(const libHandle: PLibHandle; AIndex: Integer; const eNomeArquivo, ePathArquivo: PAnsiChar):Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_LimparLista(const libHandle: PLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ObterCertificados(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_Emitir(const libHandle: PLibHandle; const aLote: PAnsiChar; aModoEnvio: Integer;  aImprimir: Boolean; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_Cancelar(const libHandle: PLibHandle; aInfCancelamentoNFSe: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_SubstituirNFSe(const libHandle: PLibHandle; const aNumeroNFSe, aSerieNFSe, aCodigoCancelamento, aMotivoCancelamento, aNumeroLote, aCodigoVerificacao, sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_LinkNFSe(const libHandle: PLibHandle; aNumeroNFSe: PAnsiChar; const aCodigoVerificacao, aChaveAcesso, aValorServico, sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_GerarLote(const libHandle: PLibHandle; const aLote: PAnsiChar; aQtdMaximaRps, aModoEnvio: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_GerarToken(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarSituacao(const libHandle: PLibHandle; const AProtocolo, ANumLote, sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarLoteRps(const libHandle: PLibHandle; const AProtocolo, ANumLote, sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSePorRps(const libHandle: PLibHandle; const ANumeroRps, ASerie, ATipo, ACodigoVerificacao, sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSePorNumero(const libHandle: PLibHandle; const ANumero:PAnsiChar; APagina: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSePorPeriodo(const libHandle: PLibHandle; aDataInicial, aDataFinal: TDateTime; aPagina: Integer; aNumeroLote: PAnsiChar; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSePorFaixa(const libHandle: PLibHandle; const aNumeroInicial, aNumeroFinal: PAnsiChar; aPagina: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSeGenerico(const libHandle: PLibHandle; aInfConsultaNFSe: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarLinkNFSe(const libHandle: PLibHandle; aInfConsultaLinkNFSe: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_EnviarEmail(const libHandle: PLibHandle; const ePara, eXmlNFSe: PAnsiChar; const AEnviaPDF: boolean; const eAssunto, eCC, eAnexos, eMensagem: PAnsiChar):Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_Imprimir(const libHandle: PLibHandle; const cImpressora: PAnsiChar; nNumCopias: integer; const bGerarPDF, bMostrarPreview, cCancelada: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ImprimirPDF(const libHandle: PLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_SalvarPDF(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSeServicoPrestadoPorNumero(const libHandle: PLibHandle; const aNumero: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSeServicoPrestadoPorPeriodo(const libHandle: PLibHandle; aDataInicial, aDataFinal: TDateTime; aPagina: Integer; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSeServicoPrestadoPorTomador(const libHandle: PLibHandle; const aCNPJ, aInscMun: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSeServicoPrestadoPorIntermediario(const libHandle: PLibHandle; const aCNPJ, aInscMun: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSeServicoTomadoPorNumero(const libHandle: PLibHandle; const aNumero: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer):Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSeServicoTomadoPorPrestador(const libHandle: PLibHandle; const aCNPJ, aInscMun: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSeServicoTomadoPorTomador(const libHandle: PLibHandle; const aCNPJ, aInscMun: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSeServicoTomadoPorPeriodo(const libHandle: PLibHandle; aDataInicial, aDataFinal: TDateTime; aPagina: Integer; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSeServicoTomadoPorIntermediario(const libHandle: PLibHandle; const aCNPJ, aInscMun: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_EnviarEvento(const libHandle: PLibHandle; aInfEvento: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarDPSPorChave(const libHandle: PLibHandle; const aChaveDPS: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarNFSePorChave(const libHandle: PLibHandle; const aChaveNFSe: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarEvento(const libHandle: PLibHandle; const aChave: PAnsiChar; aTipoEvento: Integer; aNumSeq: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarDFe(const libHandle: PLibHandle; aNSU: Integer; sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ObterDANFSE(const libHandle: PLibHandle; const aChaveNFSe: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ConsultarParametros(const libHandle: PLibHandle; aTipoParametroMunicipio: Integer; const aCodigoServico: PAnsiChar; aCompetencia: TDateTime; aNumeroBeneficio: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function NFSE_ObterInformacoesProvedor(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

{%endregion}

{%endregion}

implementation

uses
  ACBrLibNFSeBase, ACBrLibConsts;

{%region NFSe}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}

function NFSE_Inicializar(var libHandle: PLibHandle; const eArqConfig, eChaveCrypt: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(libHandle, TACBrLibNFSe, eArqConfig, eChaveCrypt);
end;

function NFSE_Finalizar(libHandle: PLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar(libHandle);
  libHandle := nil;
end;

function NFSE_Nome(const libHandle: PLibHandle; const sNome: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(libHandle, sNome, esTamanho);
end;

function NFSE_Versao(const libHandle: PLibHandle; const sVersao: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(libHandle,sVersao, esTamanho);
end;

function NFSE_OpenSSLInfo(const libHandle: PLibHandle; const sOpenSSLInfo: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_OpenSSLInfo(libHandle, sOpenSSLInfo, esTamanho);
end;

function NFSE_UltimoRetorno(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(libHandle, sMensagem, esTamanho);
end;

function NFSE_ConfigImportar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigImportar(libHandle, eArqConfig);
end;

function NFSE_ConfigExportar(const libHandle: PLibHandle; const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
      {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigExportar(libHandle, sMensagem, esTamanho);
end;

function NFSE_ConfigLer(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(libHandle, eArqConfig);
end;

function NFSE_ConfigGravar(const libHandle: PLibHandle; const eArqConfig: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(libHandle, eArqConfig);
end;

function NFSE_ConfigLerValor(const libHandle: PLibHandle; const eSessao, eChave: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(libHandle, eSessao, eChave, sValor, esTamanho);
end;

function NFSE_ConfigGravarValor(const libHandle: PLibHandle; const eSessao, eChave, eValor: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(libHandle, eSessao, eChave, eValor);
end;

{%endregion}

function NFSE_CarregarXML(const libHandle: PLibHandle; const eArquivoOuXML: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).CarregarXML(eArquivoOuXML);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_CarregarLoteXML(const libHandle: PLibHandle; const eArquivoOuXML: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).CarregarLoteXML(eArquivoOuXML);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_CarregarINI(const libHandle: PLibHandle; const eArquivoOuINI: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).CarregarINI(eArquivoOuINI);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ObterXml(const libHandle: PLibHandle; AIndex: Integer; const sResposta: PAnsiChar;
  var esTamanho: Integer): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ObterXml(AIndex, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_GravarXml(const libHandle: PLibHandle; AIndex: Integer; const eNomeArquivo, ePathArquivo: PAnsiChar): Integer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).GravarXml(AIndex, eNomeArquivo, ePathArquivo);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ObterIni(const libHandle: PLibHandle; AIndex: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ObterIni(AIndex, sResposta, esTamanho);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_GravarIni(const libHandle: PLibHandle; AIndex: Integer; const eNomeArquivo, ePathArquivo: PAnsiChar): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).GravarIni(AIndex, eNomeArquivo, ePathArquivo);
  except
    on E: EACBrLibException do
      Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_LimparLista(const libHandle: PLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).LimparLista;
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ObterCertificados(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ObterCertificados(sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_Emitir(const libHandle: PLibHandle; const aLote: PAnsiChar; aModoEnvio: Integer;  aImprimir: Boolean;
  const sResposta: PAnsiChar; var esTamanho: Integer): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).Emitir(aLote, aModoEnvio, aImprimir, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_Cancelar(const libHandle: PLibHandle; aInfCancelamentoNFSe: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).Cancelar(aInfCancelamentoNFSe, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_SubstituirNFSe(const libHandle: PLibHandle; const aNumeroNFSe, aSerieNFSe, aCodigoCancelamento, aMotivoCancelamento, aNumeroLote, aCodigoVerificacao, sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).SubstituirNFSe(aNumeroNFSe, aSerieNFSe, aCodigoCancelamento, aMotivoCancelamento, aNumeroLote, aCodigoVerificacao, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_LinkNFSe(const libHandle: PLibHandle; aNumeroNFSe: PAnsiChar; const aCodigoVerificacao, aChaveAcesso, aValorServico, sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).LinkNFSe(aNumeroNFSe, aCodigoVerificacao, aChaveAcesso, aValorServico, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_GerarLote(const libHandle: PLibHandle; const aLote: PAnsiChar; aQtdMaximaRps, aModoEnvio: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).GerarLote(aLote, aQtdMaximaRps, aModoEnvio, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_GerarToken(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result:= TACBrLibNFSe(libHandle^.Lib).GerarToken(sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarSituacao(const libHandle: PLibHandle; const AProtocolo, ANumLote, sResposta: PAnsiChar;
  var esTamanho: Integer): Integer; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarSituacao(AProtocolo, ANumLote, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSe_ConsultarLoteRps(const libHandle: PLibHandle; const AProtocolo, ANumLote, sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarLoteRps(AProtocolo, ANumLote, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSePorRps(const libHandle: PLibHandle; const ANumeroRps, ASerie, ATipo, ACodigoVerificacao, sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSePorRps(ANumeroRps, ASerie, ATipo, ACodigoVerificacao, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeporNumero(const libHandle: PLibHandle; const ANumero: PAnsiChar; APagina: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeporNumero(ANumero, APagina, sResposta, esTamanho);
  except
    on E: EACBrLibException do
     Result := E.Erro;

    on E: Exception do
      Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeporPeriodo(const libHandle: PLibHandle; aDataInicial, aDataFinal: TDateTime; aPagina: integer; aNumeroLote: PAnsiChar; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSePorPeriodo(aDataInicial, aDataFinal, aPagina, aNumeroLote, aTipoPeriodo, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
    end;
end;

function NFSE_ConsultarNFSePorFaixa(const libHandle: PLibHandle; const aNumeroInicial, aNumeroFinal: PAnsiChar; aPagina: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSePorFaixa(aNumeroInicial, aNumeroFinal, aPagina, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeGenerico(const libHandle: PLibHandle; aInfConsultaNFSe: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeGenerico(aInfConsultaNFSe, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarLinkNFSe(const libHandle: PLibHandle; aInfConsultaLinkNFSe: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarLinkNFSe(aInfConsultaLinkNFSe, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_EnviarEmail(const libHandle: PLibHandle; const ePara, eXmlNFSe: PAnsiChar; const AEnviaPDF: boolean; const eAssunto, eCC, eAnexos, eMensagem: PAnsiChar):Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).EnviarEmail(ePara, eXmlNFSe, AEnviaPDF, eAssunto, eCC, eAnexos, eMensagem);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_Imprimir(const libHandle: PLibHandle; const cImpressora: PAnsiChar; nNumCopias: integer; const bGerarPDF, bMostrarPreview, cCancelada: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).Imprimir(cImpressora, nNumCopias, bGerarPDF, bMostrarPreview, cCancelada);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ImprimirPDF(const libHandle: PLibHandle): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ImprimirPDF;
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_SalvarPDF(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).SalvarPDF(sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeServicoPrestadoPorNumero(const libHandle: PLibHandle; const aNumero: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer ): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeServicoPrestadoPorNumero(aNumero, aPagina, aDataInicial, aDataFinal, aTipoPeriodo, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeServicoPrestadoPorPeriodo(const libHandle: PLibHandle; aDataInicial, aDataFinal: TDateTime; aPagina: Integer; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeServicoPrestadoPorPeriodo(aDataInicial, aDataFinal, aPagina, aTipoPeriodo, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeServicoPrestadoPorTomador(const libHandle: PLibHandle; const aCNPJ, aInscMun: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeServicoPrestadoPorTomador(aCNPJ, aInscMun, aPagina, aDataInicial, aDataFinal, aTipoPeriodo, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeServicoPrestadoPorIntermediario(const libHandle: PLibHandle; const aCNPJ, aInscMun: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
    try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeServicoPrestadoPorIntermediario(aCNPJ, aInscMun, aPagina, aDataInicial, aDataFinal, aTipoPeriodo, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeServicoTomadoPorNumero(const libHandle: PLibHandle; const aNumero: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeServicoTomadoPorNumero(aNumero, aPagina, aDataInicial, aDataFinal, aTipoPeriodo, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeServicoTomadoPorPrestador(const libHandle: PLibHandle; const aCNPJ, aInscMun: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeServicoTomadoPorPrestador(aCNPJ, aInscMun, aPagina, aDataInicial, aDataFinal, aTipoPeriodo, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeServicoTomadoPorTomador(const libHandle: PLibHandle; const aCNPJ, aInscMun: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeServicoTomadoPorTomador(aCNPJ, aInscMun, aPagina, aDataInicial, aDataFinal, aTipoPeriodo, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeServicoTomadoPorPeriodo(const libHandle: PLibHandle; aDataInicial, aDataFinal: TDateTime; aPagina: Integer; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeServicoTomadoPorPeriodo(aDataInicial, aDataFinal, aPagina, aTipoPeriodo, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSeServicoTomadoPorIntermediario(const libHandle: PLibHandle; const aCNPJ, aInscMun: PAnsiChar; aPagina: Integer; aDataInicial, aDataFinal: TDateTime; aTipoPeriodo: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSeServicoTomadoPorIntermediario(aCNPJ, aInscMun, aPagina, aDataInicial, aDataFinal, aTipoPeriodo, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_EnviarEvento(const libHandle: PLibHandle; aInfEvento: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).EnviarEvento(aInfEvento, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarDPSPorChave(const libHandle: PLibHandle; const aChaveDPS: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarDPSPorChave(aChaveDPS, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarNFSePorChave(const libHandle: PLibHandle; const aChaveNFSe: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarNFSePorChave(aChaveNFSe, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarEvento(const libHandle: PLibHandle; const aChave: PAnsiChar; aTipoEvento: Integer; aNumSeq: Integer; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarEvento(aChave, aTipoEvento, aNumSeq, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarDFe(const libHandle: PLibHandle; aNSU: Integer; sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarDFe(aNSU, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ObterDANFSE(const libHandle: PLibHandle; const aChaveNFSe: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ObterDANFSE(aChaveNFSe, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ConsultarParametros(const libHandle: PLibHandle; aTipoParametroMunicipio: Integer; const aCodigoServico: PAnsiChar; aCompetencia: TDateTime; aNumeroBeneficio: PAnsiChar; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ConsultarParametros(aTipoParametroMunicipio, aCodigoServico, aCompetencia, aNumeroBeneficio, sResposta, esTamanho);
  except
      on E: EACBrLibException do
       Result := E.Erro;

      on E: Exception do
        Result := ErrExecutandoMetodo;
  end;
end;

function NFSE_ObterInformacoesProvedor(const libHandle: PLibHandle; const sResposta: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada(libHandle);
    Result := TACBrLibNFSe(libHandle^.Lib).ObterInformacoesProvedor(sResposta, esTamanho);
  except
      on E: EACBrLibException do
         Result := E.Erro;

      on E: Exception do
         Result := ErrExecutandoMetodo;
  end;
end;

{%endregion}

end.
