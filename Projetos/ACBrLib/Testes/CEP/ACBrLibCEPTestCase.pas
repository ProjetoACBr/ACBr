{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

unit ACBrLibCEPTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

const
  CLibCEPNome = 'ACBrLibCEP';
  CLibCEPWebService = '10';  // Via Cep
  CCEPACBr = '18270170';
  CSecEnd1 = 'Endereco1';

type

  { TTestACBrCEPLib }

  TTestACBrCEPLib = class(TTestCase)
  private
    procedure Verificar_Retorno_INI_18270170(const AResposta: String);
    procedure Verificar_Retorno_JSON_18270170(const AResposta: String);
    procedure Verificar_Retorno_XML_18270170(const AResposta: String);

  published
    procedure Test_CEP_Inicializar_Com_DiretorioInvalido;
    procedure Test_CEP_Inicializar;
    procedure Test_CEP_Inicializar_Ja_Inicializado;
    procedure Test_CEP_Finalizar;
    procedure Test_CEP_Finalizar_Ja_Finalizado;
    procedure Test_CEP_Nome_Obtendo_LenBuffer;
    procedure Test_CEP_Nome_Lendo_Buffer_Tamanho_Identico;
    procedure Test_CEP_Nome_Lendo_Buffer_Tamanho_Maior;
    procedure Test_CEP_Nome_Lendo_Buffer_Tamanho_Menor;
    procedure Test_CEP_Versao;
    procedure Test_CEP_OpenSSL;
    procedure Test_CEP_ConfigLerValor;
    procedure Test_CEP_ConfigGravarValor;

    procedure Test_CEP_BuscarPorCEP;
    procedure Test_CEP_BuscarPorLogradouro;

    procedure Test_CEP_BuscarPorCEPJSON;
    procedure Test_CEP_BuscarPorCEPXML;

  end;

implementation

uses
  IniFiles,
  ACBrLibCEPStaticImportMT, ACBrLibCEPConsts, ACBrLibConsts,
  ACBrUtil.Strings, ACBrJSON
  {$IfDef FPC}
   ,Laz2_XMLRead, laz2_DOM
  {$EndIf};

procedure TTestACBrCEPLib.Verificar_Retorno_INI_18270170(const AResposta: String);
var
  sl: TStringList;
  Ini: TMemIniFile;
begin
  sl := TStringList.Create;
  Ini := TMemIniFile.Create('');
  try
    sl.Text := AResposta;
    Ini.SetStrings(sl);

    AssertTrue(Ini.SectionExists(CSecEnd1));
    AssertEquals('Bairro', 'Centro', Ini.ReadString(CSecEnd1, 'Bairro', ''));
    AssertEquals('CEP', '18270-170', Ini.ReadString(CSecEnd1, 'CEP', ''));
    AssertEquals('IBGE_Municipio', '3554003', Ini.ReadString(CSecEnd1, 'IBGE_Municipio', ''));
    AssertEquals('IBGE_UF', '35', Ini.ReadString(CSecEnd1, 'IBGE_UF', ''));
    AssertEquals('Logradouro', 'Rua Coronel Aureliano de Camargo', Ini.ReadString(CSecEnd1, 'Logradouro', ''));
    AssertEquals('Municipio', ACBrStr('Tatu�'), Ini.ReadString(CSecEnd1, 'Municipio', ''));
    AssertEquals('UF', 'SP', Ini.ReadString(CSecEnd1, 'UF', ''));
  finally
    Ini.Free;
    sl.Free;
  end;
end;

procedure TTestACBrCEPLib.Verificar_Retorno_JSON_18270170(
  const AResposta: String);
const
  CSecEnd1 = 'Endereco1';
var
  json, jscep, jsend: TACBrJSONObject;
  //s: String;
begin
  json := TACBrJSONObject.Parse(AResposta);
  try
    AssertTrue(json.IsJSONObject('CEP'));
    jscep := json.AsJSONObject['CEP'];
    //s := jscep.ToJSON;
    AssertTrue(jscep.IsJSONObject(CSecEnd1));
    jsend := jscep.AsJSONObject[CSecEnd1];
    //s := jsend.ToJSON;
    AssertEquals('Bairro', 'Centro', jsend.AsString['Bairro']);
    AssertEquals('CEP', '18270-170', jsend.AsString['CEP']);
    AssertEquals('IBGE_Municipio', '3554003', jsend.AsString['IBGE_Municipio']);
    AssertEquals('IBGE_UF', '35', jsend.AsString['IBGE_UF']);
    AssertEquals('Logradouro', 'Rua Coronel Aureliano de Camargo', jsend.AsString['Logradouro']);
    AssertEquals('Municipio', ACBrStr('Tatu�'), jsend.AsString['Municipio']);
    AssertEquals('UF', 'SP', jsend.AsString['UF']);
  finally
    json.Free;
  end;
end;

procedure TTestACBrCEPLib.Verificar_Retorno_XML_18270170(const AResposta: String);
{$IfDef FPC}
var
  xml : TXMLDocument;
  ss: TStringStream;
  nitens, nend: TDOMNode;
{$EndIf}
begin
{$IfDef FPC}
  ss := TStringStream.Create(Trim(AResposta));
  try
    ReadXMLFile(xml, ss);
    nitens := xml.DocumentElement.FindNode('Itens');
    AssertNotNull('Node Itens n�o encontrado', nitens);
    nend := nitens.FindNode(CSecEnd1);
    AssertNotNull('Node '+CSecEnd1+' n�o encontrado', nend);

    AssertEquals('Bairro', 'Centro', nend.FindNode('Bairro').TextContent);
    AssertEquals('CEP', '18270-170', nend.FindNode('CEP').TextContent);
    AssertEquals('IBGE_Municipio', '3554003', nend.FindNode('IBGE_Municipio').TextContent);
    AssertEquals('IBGE_UF', '35', nend.FindNode('IBGE_UF').TextContent);
    AssertEquals('Logradouro', 'Rua Coronel Aureliano de Camargo', nend.FindNode('Logradouro').TextContent);
    AssertEquals('Municipio', ACBrStr('Tatu�'), nend.FindNode('Municipio').TextContent);
    AssertEquals('UF', 'SP', nend.FindNode('UF').TextContent);
  finally
    ss.Free;
    xml.Free;
  end;
{$EndIf}
end;

procedure TTestACBrCEPLib.Test_CEP_Inicializar_Com_DiretorioInvalido;
var
  Handle: TLibHandle;
begin
    AssertEquals(ErrDiretorioNaoExiste, CEP_Inicializar(Handle, 'C:\NAOEXISTE\ACBrLib.ini',''));
end;

procedure TTestACBrCEPLib.Test_CEP_Inicializar;
var
  Handle: TLibHandle;
begin
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  AssertEquals(ErrOK, CEP_Finalizar(Handle));
end;

procedure TTestACBrCEPLib.Test_CEP_Inicializar_Ja_Inicializado;
var
  Handle: TLibHandle;
begin
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  AssertEquals(ErrOK, CEP_Finalizar(Handle));
end;

procedure TTestACBrCEPLib.Test_CEP_Finalizar;
var
  Handle: TLibHandle;
begin
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  AssertEquals(ErrOk, CEP_Finalizar(Handle));
end;

procedure TTestACBrCEPLib.Test_CEP_Finalizar_Ja_Finalizado;
var
  Handle: TLibHandle;
begin

  Handle:=0;
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  AssertEquals(ErrOk, CEP_Finalizar(Handle));

  //try
  //  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  //  AssertEquals(ErrOk, CEP_Finalizar(Handle));
  //  //AssertEquals(ErrOk, CEP_Finalizar(Handle));
  //except
  //on E: Exception do
  //   ShowMessage('Error: '+ E.ClassName + #13#10 + E.Message);
  //end;
end;

procedure TTestACBrCEPLib.Test_CEP_Nome_Obtendo_LenBuffer;
var
  Handle: TLibHandle;
  Bufflen: Integer;
begin
  // Obtendo o Tamanho //
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  Bufflen := 0;
  AssertEquals(ErrOk, CEP_Nome(Handle, Nil, Bufflen));
  AssertEquals(Length(CLibCEPNome), Bufflen);
  AssertEquals(ErrOk, CEP_Finalizar(Handle));
end;

procedure TTestACBrCEPLib.Test_CEP_Nome_Lendo_Buffer_Tamanho_Identico;
var
  Handle: TLibHandle;
  AStr: String;
  Bufflen: Integer;
begin
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  Bufflen := Length(CLibCEPNome);
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CEP_Nome(Handle, PChar(AStr), Bufflen));
  AssertEquals(Length(CLibCEPNome), Bufflen);
  AssertEquals(CLibCEPNome, AStr);
  AssertEquals(ErrOk, CEP_Finalizar(Handle));
end;

procedure TTestACBrCEPLib.Test_CEP_Nome_Lendo_Buffer_Tamanho_Maior;
var
  Handle: TLibHandle;
  AStr: String;
  Bufflen: Integer;
begin
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  Bufflen := Length(CLibCEPNome)*2;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CEP_Nome(Handle, PChar(AStr), Bufflen));
  AStr := copy(AStr, 1, Bufflen);
  AssertEquals(Length(CLibCEPNome), Bufflen);
  AssertEquals(CLibCEPNome, AStr);
  AssertEquals(ErrOk, CEP_Finalizar(Handle));
end;

procedure TTestACBrCEPLib.Test_CEP_Nome_Lendo_Buffer_Tamanho_Menor;
var
  Handle: TLibHandle;
  AStr: String;
  Bufflen: Integer;
begin
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  Bufflen := 4;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CEP_Nome(Handle, PChar(AStr), Bufflen));
  AssertEquals(Length(CLibCEPNome), Bufflen);
  AssertEquals(copy(CLibCEPNome,1,4), AStr);
  AssertEquals(ErrOk, CEP_Finalizar(Handle));
end;

procedure TTestACBrCEPLib.Test_CEP_Versao;
var
  Handle: TLibHandle;
  Bufflen1, Bufflen2: Integer;
  AStr: String;
begin
  // Obtendo o Tamanho //
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  Bufflen1 := 0;
  AssertEquals(ErrOk, CEP_Versao(Handle, Nil, Bufflen1));
  AssertTrue(Bufflen1 > 0);

  // Lendo a resposta //
  BuffLen2 := BuffLen1;
  AStr := Space(Bufflen2);
  AssertEquals(ErrOk, CEP_Versao(Handle, PChar(AStr), Bufflen2));
  AssertTrue(Bufflen2 > 0);
  AssertTrue(AStr <> '');
  AssertEquals(ErrOk, CEP_Finalizar(Handle));
  AssertEquals('Bufflen', BuffLen1, Bufflen2);
end;

procedure TTestACBrCEPLib.Test_CEP_OpenSSL;
var
  Handle: TLibHandle;
  Bufflen1, Bufflen2: Integer;
  AStr: String;
begin
  // Obtendo o Tamanho //
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  Bufflen1 := 0;
  AssertEquals(ErrOk, CEP_OpenSSLInfo(Handle, Nil, Bufflen1));
  AssertTrue(Bufflen1 > 0);

  // Lendo a resposta //
  BuffLen2 := BuffLen1;
  AStr := Space(Bufflen2);
  AssertEquals(ErrOk, CEP_OpenSSLInfo(Handle, PChar(AStr), Bufflen2));
  AssertTrue(Bufflen2 > 0);
  AssertTrue(AStr <> '');
  AssertEquals(ErrOk, CEP_Finalizar(Handle));
  AssertEquals('Bufflen', BuffLen1, Bufflen2);
end;

procedure TTestACBrCEPLib.Test_CEP_ConfigLerValor;
var
  Handle: TLibHandle;
  Bufflen: Integer;
  AStr: String;
begin
  // Obtendo o Tamanho //
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  Bufflen := 255;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CEP_ConfigLerValor(Handle, CSessaoVersao, CLibCEPNome, PChar(AStr), Bufflen));
  AStr := copy(AStr,1,Bufflen);
  AssertEquals(CLibCEPVersao, AStr);
  AssertEquals(ErrOk, CEP_Finalizar(Handle));
end;

procedure TTestACBrCEPLib.Test_CEP_ConfigGravarValor;
var
  Handle: TLibHandle;
  Bufflen: Integer;
  AStr: String;
begin
  // Gravando o valor
  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  AssertEquals('Erro ao Mudar configura��o', ErrOk, CEP_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveLogNivel, '4'));

  // Checando se o valor foi atualizado //
  Bufflen := 255;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CEP_ConfigLerValor(Handle, CSessaoPrincipal, CChaveLogNivel, PChar(AStr), Bufflen));
  AStr := copy(AStr,1,Bufflen);

  AssertEquals('Erro ao Mudar configura��o', '4', AStr);
  AssertEquals(ErrOk, CEP_Finalizar(Handle));
end;

procedure TTestACBrCEPLib.Test_CEP_BuscarPorCEP;
var
  Handle: TLibHandle;
  Resposta: String;
  Tamanho: Longint;
begin
  // Buscando o Endere�o por CEP
  Resposta := space(10240);
  Tamanho := 10240;

  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  AssertEquals('Erro ao Mudar configura��o: '+CChaveTipoResposta, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveTipoResposta, '0')); // Ini
  AssertEquals('Erro ao Mudar configura��o: '+CChaveCodificacaoResposta, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveCodificacaoResposta, '0')); // UTF8
  AssertEquals('Erro ao Mudar configura��o: '+CLibCEPWebService, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoCEP, CChaveWebService, CLibCEPWebService));
  AssertEquals('Erro ao buscar o endere�o por CEP', ErrOk,
    CEP_BuscarPorCEP(Handle, CCEPACBr, PChar(Resposta), Tamanho));
  AssertEquals(ErrOk, CEP_Finalizar(Handle));

  Verificar_Retorno_INI_18270170(Resposta)
end;

procedure TTestACBrCEPLib.Test_CEP_BuscarPorLogradouro;
var
  Handle: TLibHandle;
  Resposta, sCidade, sTipoLogradouro, sLogradouro, sUF, sBairro: AnsiString;
  Tamanho: Longint;
begin
  // Buscando o CEP por Logradouro
  Resposta := space(10240);
  Tamanho := 10240;
  sCidade := ACBrStr('Tatu�');
  sTipoLogradouro := 'Rua';
  sLogradouro := 'Coronel Aureliano de Camargo';
  sUF := 'SP';
  sBairro := 'Centro';

  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  AssertEquals('Erro ao Mudar configura��o: '+CChaveTipoResposta, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveTipoResposta, '0'));  // Ini
  AssertEquals('Erro ao Mudar configura��o: '+CChaveCodificacaoResposta, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveCodificacaoResposta, '0')); // UTF8
  AssertEquals('Erro ao Mudar configura��o: '+CLibCEPWebService, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoCEP, CChaveWebService, CLibCEPWebService));
  AssertEquals('Erro ao buscar o CEP por Logradouro', ErrOk,
    CEP_BuscarPorLogradouro(Handle, PAnsiChar(sCidade), PAnsiChar(sTipoLogradouro),
                                    PAnsiChar(sLogradouro), PAnsiChar(sUF), PAnsiChar(sBairro),
                                    PAnsiChar(Resposta), Tamanho));
  AssertEquals(ErrOk, CEP_Finalizar(Handle));

  Verificar_Retorno_INI_18270170(Resposta)
end;

procedure TTestACBrCEPLib.Test_CEP_BuscarPorCEPJSON;
var
  Handle: TLibHandle;
  Resposta: String;
  Tamanho: Longint;
begin
  Exit;
  // Buscando o Endere�o por CEP
  Resposta := space(10240);
  Tamanho := 10240;

  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  AssertEquals('Erro ao Mudar configura��o: '+CChaveTipoResposta, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveTipoResposta, '2')); // JSON
  AssertEquals('Erro ao Mudar configura��o: '+CChaveCodificacaoResposta, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveCodificacaoResposta, '0')); // UTF8
  AssertEquals('Erro ao Mudar configura��o: '+CLibCEPWebService, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoCEP, CChaveWebService, CLibCEPWebService));
  AssertEquals('Erro ao buscar o endere�o por CEP', ErrOk,
    CEP_BuscarPorCEP(Handle, CCEPACBr, PChar(Resposta), Tamanho));
  AssertEquals(ErrOk, CEP_Finalizar(Handle));

  Verificar_Retorno_JSON_18270170(Resposta)
end;

procedure TTestACBrCEPLib.Test_CEP_BuscarPorCEPXML;
var
  Handle: TLibHandle;
  Resposta: String;
  Tamanho: Longint;
begin
  Exit;
  // Buscando o Endere�o por CEP
  Resposta := space(10240);
  Tamanho := 10240;

  AssertEquals(ErrOk, CEP_Inicializar(Handle, '',''));
  AssertEquals('Erro ao Mudar configura��o: '+CChaveTipoResposta, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveTipoResposta, '1')); // XML
  AssertEquals('Erro ao Mudar configura��o: '+CChaveCodificacaoResposta, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoPrincipal, CChaveCodificacaoResposta, '0')); // UTF8
  AssertEquals('Erro ao Mudar configura��o: '+CLibCEPWebService, ErrOk,
    CEP_ConfigGravarValor(Handle, CSessaoCEP, CChaveWebService, CLibCEPWebService));
  AssertEquals('Erro ao buscar o endere�o por CEP', ErrOk,
    CEP_BuscarPorCEP(Handle, CCEPACBr, PChar(Resposta), Tamanho));
  AssertEquals(ErrOk, CEP_Finalizar(Handle));

  Verificar_Retorno_XML_18270170(Resposta)
end;

initialization
  RegisterTest(TTestACBrCEPLib);

end.

