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

unit ACBrLibExtratoAPITestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, Dialogs;

const
  CExtratoAPIAgencia = '1505';
  CExtratoAPIConta = '1348';
  CExtratoAPIPagina = 1;
  CExtratoAPIRegistrosPorPag = 50;

type
  { TTestACBrExtratoAPILib }

  TTestACBrExtratoAPILib= class(TTestCase)
  published
    procedure Test_ExtratoAPI_Inicializar_Com_DiretorioInvalido;
    procedure Test_ExtratoAPI_Inicializar;
    procedure Test_ExtratoAPI_Inicializar_Ja_Inicializado;
    procedure Test_ExtratoAPI_Finalizar;
    procedure Test_ExtratoAPI_Finalizar_Ja_Finalizado;
    procedure Test_ExtratoAPI_Nome_Obtendo_LenBuffer;
    procedure Test_ExtratoAPI_Nome_Lendo_Buffer_Tamanho_Identico;
    procedure Test_ExtratoAPI_Nome_Lendo_Buffer_Tamanho_Maior;
    procedure Test_ExtratoAPI_Nome_Lendo_Buffer_Tamanho_Menor;
    procedure Test_ExtratoAPI_Versao;
    procedure Test_ExtratoAPI_ConfigLerValor;
    procedure Test_ExtratoAPI_ConfigGravarValor;
    procedure Test_ExtratoAPI_OpenSSLInfo;

    procedure Test_ExtratoAPI_ConsultarExtrato;
  end;

implementation

uses
  ACBrLibExtratoAPIStaticImportMT, ACBrLibExtratoAPIConsts, ACBrLibConsts;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_Inicializar_Com_DiretorioInvalido;
var
  Handle: THandle;
begin
  try
    AssertEquals(ErrDiretorioNaoExiste, ExtratoAPI_Inicializar(Handle, 'C:\NAOEXISTE\ACBrLib.ini',''));
  except
    on E: exception do
      ShowMessage('Error: '+ E.ClassName + #13#10 + E.Message);
  end;
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_Inicializar;
var
  Handle: THandle;
begin
  AssertEquals(ErrOk, ExtratoAPI_Inicializar(Handle,'',''));
  AssertEquals(ErrOk, ExtratoAPI_Finalizar(Handle));
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_Inicializar_Ja_Inicializado;
var
  Handle: THandle;
  HandleOriginal: THandle;
begin
  AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '', ''));
  // Armazenado HandleOriginal para finalizar e não ficar com a Lib presa
  HandleOriginal := Handle;
  AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '',''));
  AssertEquals(ErrOK, ExtratoAPI_Finalizar(Handle));
  AssertEquals(ErrOK, ExtratoAPI_Finalizar(HandleOriginal));
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_Finalizar;
var
  Handle: THandle;
begin
  AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '', ''));
  AssertEquals(ErrOK, ExtratoAPI_Finalizar(Handle));
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_Finalizar_Ja_Finalizado;
var
  Handle: THandle;
  mensagem: String;
begin
  mensagem := 'Ocorreu um erro antes da segunda chamada Finalizar()';
  try
    AssertEquals(ErrOk, ExtratoAPI_Inicializar(Handle, '', ''));
    AssertEquals(ErrOk, ExtratoAPI_Finalizar(Handle));
    mensagem := 'OK - Erro na segunda chamada Finalizar()';
    AssertEquals(ErrOk, ExtratoAPI_Finalizar(Handle));
  except
    on E: Exception do
      ShowMessage( 'Error: '+ E.ClassName + #13#10 + mensagem + #13#10 + E.Message );
  end;
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_Nome_Obtendo_LenBuffer;
var
  Bufflen: Integer;
  Handle: THandle;
begin
  // Obtendo o Tamanho //
  AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '', ''));
  Bufflen := 0;
  AssertEquals(ErrOk, ExtratoAPI_Nome(Handle, Nil, Bufflen));
  AssertEquals(Length(CLibExtratoAPINome), Bufflen);
  AssertEquals(ErrOK, ExtratoAPI_Finalizar(Handle));
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_Nome_Lendo_Buffer_Tamanho_Identico;
var
  AStr: String;
  Bufflen: Integer;
  Handle: THandle;
begin
  AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '',''));
  Bufflen := Length(CLibExtratoAPINome);
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, ExtratoAPI_Nome(Handle, PChar(AStr), Bufflen));
  AssertEquals(Length(CLibExtratoAPINome), Bufflen);
  AssertEquals(CLibExtratoAPINome, AStr);
  AssertEquals(ErrOK, ExtratoAPI_Finalizar(Handle));
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_Nome_Lendo_Buffer_Tamanho_Maior;
var
  AStr: String;
  Bufflen: Integer;
  Handle: THandle;
begin
  AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '', ''));
  Bufflen := Length(CLibExtratoAPINome)*2;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, ExtratoAPI_Nome(Handle, PChar(AStr), Bufflen));
  AStr := Copy(AStr, 1, Bufflen);
  AssertEquals(Length(CLibExtratoAPINome), Bufflen);
  AssertEquals(CLibExtratoAPINome, AStr);
  AssertEquals(ErrOK, ExtratoAPI_Finalizar(Handle));
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_Nome_Lendo_Buffer_Tamanho_Menor;
var
  AStr: String;
  Bufflen: Integer;
  Handle: THandle;
begin
  AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '', ''));
  try
    Bufflen := Length(CLibExtratoAPINome);
    AStr := Space(Bufflen);
    AssertEquals(ErrOk, ExtratoAPI_Nome(Handle, PChar(AStr), Bufflen));
    AssertEquals(Length(CLibExtratoAPINome), Bufflen);
    AssertEquals(CLibExtratoAPINome, AStr);
  finally
    AssertEquals(ErrOK, ExtratoAPI_Finalizar(Handle));
  end;
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_Versao;
var
  Bufflen: Integer;
  AStr: String;
  Handle: THandle;
begin
  // Obtendo o Tamanho //
  AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '', ''));
  try
    Bufflen := 0;
    AssertEquals(ErrOk, ExtratoAPI_Versao(Handle, Nil, Bufflen));
    AssertEquals(Length(CLibExtratoAPIVersao), Bufflen);

    // Lendo a resposta //
    AStr := Space(Bufflen);
    AssertEquals(ErrOk, ExtratoAPI_Versao(Handle, PChar(AStr), Bufflen));
    AssertEquals(Length(CLibExtratoAPIVersao), Bufflen);
    AssertEquals(CLibExtratoAPIVersao, AStr);
  finally
    AssertEquals(ErrOK, ExtratoAPI_Finalizar(Handle));
  end;
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_ConfigLerValor;
var
  Bufflen: Integer;
  AStr: String;
  Handle: THandle;
begin
  // Obtendo o Tamanho //
  AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '', ''));
  Bufflen := 255;
  AStr := Space(Bufflen);
  AssertEquals(ErrOK, ExtratoAPI_ConfigLerValor(Handle, CSessaoVersao, CACBrLib, PChar(AStr), Bufflen));
  AStr := Copy(AStr,1,Bufflen);
  AssertEquals(CACBrLibVersaoConfig, AStr);
  ExtratoAPI_ConfigGravarValor(Handle, 'DFe','DadosPFX', '');
  AssertEquals(ErrOK, ExtratoAPI_Finalizar(Handle));
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_ConfigGravarValor;
var
  Bufflen: Integer;
  AStr: String;
  Handle: THandle;
begin
  // Gravando o valor
  AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '', ''));
  AssertEquals('Erro ao Mudar configuração', ErrOk, ExtratoAPI_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveLogNivel, '4'));

  // Checando se o valor foi atualizado //
  Bufflen := 255;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, ExtratoAPI_ConfigLerValor(Handle, CSessaoPrincipal, CChaveLogNivel, PChar(AStr), Bufflen));
  AStr := Copy(AStr,1,Bufflen);
  AssertEquals('Erro ao Mudar configuração', '4', AStr);
  AssertEquals(ErrOK, ExtratoAPI_Finalizar(Handle));
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_OpenSSLInfo;
var
  Handle: THandle;
  Resposta: PChar;
  Tamanho: Longint;
begin
  try
    AssertEquals(ErrOK, ExtratoAPI_Inicializar(Handle, '', ''));
    Resposta := '';
    Tamanho := 0;

    AssertEquals('Erro ao Obter Certificados', ErrOK,
      ExtratoAPI_OpenSSLInfo(Handle, Resposta, Tamanho));
    AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
    AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');

    AssertEquals(ErrOK, ExtratoAPI_Finalizar(Handle));
  except
    on E: Exception do
      ShowMessage( 'Error: '+ E.ClassName + #13#10 + E.Message );
  end;
end;

procedure TTestACBrExtratoAPILib.Test_ExtratoAPI_ConsultarExtrato;
var
  Handle: TLibHandle;
  Resposta: PChar;
  Tamanho: Longint;
begin
  Resposta := '';
  Tamanho := 0;

  try
    AssertEquals(ErrOk, ExtratoAPI_Inicializar(Handle, '',''));
    AssertEquals('Erro ao Mudar configuração: ' + CChaveTipoResposta, ErrOk,
      ExtratoAPI_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveTipoResposta, '0'));
    AssertEquals('Erro ao Mudar configuração: ' + CChaveCodificacaoResposta, ErrOk,
      ExtratoAPI_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveCodificacaoResposta, '0'));
    AssertEquals('Erro ao Mudar configuração: ' + CSessaoExtratoAPIConfig, ErrOk,
      ExtratoAPI_ConfigGravarValor(Handle, CSessaoExtratoAPIConfig, CBancoConsulta, '0'));
    AssertEquals('Erro ao Consultar Extrato', ErrOk,
      ExtratoAPI_ConsultarExtrato(Handle, CExtratoAPIAgencia, CExtratoAPIConta, Date, Date,
        CExtratoAPIPagina, CExtratoAPIRegistrosPorPag, Resposta, Tamanho));
    AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
    AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');
    AssertEquals(ErrOk, ExtratoAPI_Finalizar(Handle));
  except
    on E: Exception do
      ShowMessage( 'Error: '+ E.ClassName + #13#10 + E.Message );
  end;
end;

initialization

  RegisterTest(TTestACBrExtratoAPILib);
end.

