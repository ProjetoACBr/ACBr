{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
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

unit ACBrLibDCeTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  { TTestACBrDCeLib }

  TTestACBrDCeLib = class(TTestCase)
  private
    fCaminhoExec: string;
  public
    procedure SetUp; override;
  published
    procedure Test_DCe_Inicializar_Com_DiretorioInvalido;
    procedure Test_DCe_Inicializar;
    procedure Test_DCe_Inicializar_Ja_Inicializado;
    procedure Test_DCe_Finalizar;
    procedure Test_DCe_Finalizar_Ja_Finalizado;
    procedure Test_DCe_Nome_Obtendo_LenBuffer;
    procedure Test_DCe_Nome_Lendo_Buffer_Tamanho_Identico;
    procedure Test_DCe_Nome_Lendo_Buffer_Tamanho_Maior;
    procedure Test_DCe_Nome_Lendo_Buffer_Tamanho_Menor;
    procedure Test_DCe_Versao;
    procedure Test_DCe_ConfigLerValor;
    procedure Test_DCe_ConfigGravarValor;
end;

implementation

uses
  ACBrLibDCeStaticImportMT, ACBrLibDCeConsts, ACBrLibConsts, Dialogs;

{ TTestACBrDCeLib }

procedure TTestACBrDCeLib.SetUp;
begin
  inherited SetUp;
end;

procedure TTestACBrDCeLib.Test_DCe_Inicializar_Com_DiretorioInvalido;
var
  Handle: THandle;
begin
  try
    //DCE_Inicializar(Handle);
    AssertEquals(ErrDiretorioNaoExiste, DCE_Inicializar(Handle, 'C:\NAOEXISTE\ACBrLib.ini',''));
  except
    on E: Exception do
     ShowMessage( 'Error: '+ E.ClassName + #13#10 + E.Message );
  end;
end;

procedure TTestACBrDCeLib.Test_DCe_Inicializar;
var
  Handle: THandle;
begin
  AssertEquals(ErrOK, DCE_Inicializar(Handle, '', ''));
  AssertEquals(ErrOK, DCE_Finalizar(Handle));
end;

procedure TTestACBrDCeLib.Test_DCe_Inicializar_Ja_Inicializado;
var
  Handle: THandle;
begin
  AssertEquals(ErrOk, DCE_Inicializar(Handle,'',''));
  AssertEquals(ErrOk, DCE_Inicializar(Handle,'',''));
  AssertEquals(ErrOk, DCE_Finalizar(Handle));
end;

procedure TTestACBrDCeLib.Test_DCe_Finalizar;
var
  Handle: THandle;
begin
  AssertEquals(ErrOk, DCE_Inicializar(Handle,'',''));
  AssertEquals(ErrOk, DCE_Finalizar(Handle));
end;

procedure TTestACBrDCeLib.Test_DCe_Finalizar_Ja_Finalizado;
var
  Handle: THandle;
begin
  AssertEquals(ErrOk, DCE_Inicializar(Handle,'',''));
  AssertEquals(ErrOk, DCE_Finalizar(Handle));
  //AssertEquals(ErrOk, DCE_Finalizar(Handle));
end;

procedure TTestACBrDCeLib.Test_DCe_Nome_Obtendo_LenBuffer;
var
  Handle: THandle;
  Bufflen: Integer;
  AStr: String;
begin
  // Obtendo o Tamanho //
  AssertEquals(ErrOk, DCE_Inicializar(Handle,'',''));

  Bufflen := 0;
  AssertEquals(ErrOk, DCE_Nome(Handle,Nil, Bufflen));
  AssertEquals(Length(CLibDCeNome), Bufflen);

  AssertEquals(ErrOk, DCE_Finalizar(Handle));
end;

procedure TTestACBrDCeLib.Test_DCe_Nome_Lendo_Buffer_Tamanho_Identico;
var
  AStr: String;
  Bufflen: Integer;
  Handle: THandle;
begin
  AssertEquals(ErrOK, DCE_Inicializar(Handle, '',''));

  Bufflen := Length(CLibDCeNome);
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, DCE_Nome(Handle, PChar(AStr), Bufflen));
  AssertEquals(Length(CLibDCeNome), Bufflen);
  AssertEquals(CLibDCeNome, AStr);

  AssertEquals(ErrOK, DCE_Finalizar(Handle));
end;

procedure TTestACBrDCeLib.Test_DCe_Nome_Lendo_Buffer_Tamanho_Maior;
var
  AStr: String;
  Bufflen: Integer;
  Handle: THandle;
begin
  AssertEquals(ErrOK, DCE_Inicializar(Handle, '', ''));

  Bufflen := Length(CLibDCeNome)*2;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, DCE_Nome(Handle, PChar(AStr), Bufflen));
  AStr := copy(AStr, 1, Bufflen);
  AssertEquals(Length(CLibDCeNome), Bufflen);
  AssertEquals(CLibDCeNome, AStr);

  AssertEquals(ErrOK, DCE_Finalizar(Handle));
end;

procedure TTestACBrDCeLib.Test_DCe_Nome_Lendo_Buffer_Tamanho_Menor;
var
  AStr: String;
  Bufflen: Integer;
  Handle: THandle;
begin
  AssertEquals(ErrOK, DCE_Inicializar(Handle,  '', ''));

  Bufflen := 10;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, DCE_Nome(Handle,  PChar(AStr), Bufflen));
  AssertEquals(10, Bufflen);
  AssertEquals(copy(CLibDCeNome,1,10), AStr);

  AssertEquals(ErrOK, DCE_Finalizar(Handle));
end;

procedure TTestACBrDCeLib.Test_DCe_Versao;
var
  AStr: String;
  Bufflen: Integer;
  Handle: THandle;
begin
  // Obtendo o Tamanho //
  AssertEquals(ErrOK, DCE_Inicializar(Handle,  '', ''));

  Bufflen := 0;
  AssertEquals(ErrOk, DCE_Versao(Handle,  Nil, Bufflen));
  AssertEquals(Length(CLibDCeVersao), Bufflen);

  // Lendo a resposta //
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, DCE_Versao(Handle, PChar(AStr), Bufflen));
  AssertEquals(Length(CLibDCeVersao), Bufflen);
  AssertEquals(CLibDCeVersao, AStr);

  AssertEquals(ErrOK, DCE_Finalizar(Handle));
end;

procedure TTestACBrDCeLib.Test_DCe_ConfigLerValor;
var
  AStr: String;
  Bufflen: Integer;
  Handle: THandle;
begin
  // Obtendo o Tamanho //
  AssertEquals(ErrOK, DCE_Inicializar(Handle, '', ''));

  Bufflen := 255;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, DCE_ConfigLerValor(Handle, CSessaoVersao, CLibDCeNome, PChar(AStr), Bufflen));
  AStr := copy(AStr,1,Bufflen);
  AssertEquals(CLibDCeVersao, AStr);

  AssertEquals(ErrOK, DCE_Finalizar(Handle));
end;

procedure TTestACBrDCeLib.Test_DCe_ConfigGravarValor;
var
  AStr: String;
  Bufflen: Integer;
  Handle: THandle;
begin
  // Gravando o valor
  AssertEquals(ErrOK, DCE_Inicializar(Handle, '', ''));

  AssertEquals('Erro ao Mudar configuração', ErrOk, DCE_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveLogNivel, '4'));

  // Checando se o valor foi atualizado //
  Bufflen := 255;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, DCE_ConfigLerValor(Handle, CSessaoPrincipal, CChaveLogNivel, PChar(AStr), Bufflen));
  AStr := copy(AStr,1,Bufflen);
  AssertEquals('Erro ao Mudar configuração', '4', AStr);

  AssertEquals(ErrOK, DCE_Finalizar(Handle));
end;


initialization

  RegisterTest(TTestACBrDCeLib);
end.

