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

{$I ACBr.inc}

unit ACBrLibExtratoAPIConfig;

interface

uses
  Classes, SysUtils, IniFiles,
  ACBrLibConfig, ACBrExtratoAPI,
  ACBrUtil.FilesIO;

type
  { TExtratoAPIHTTPConfig }
  TExtratoAPIHTTPConfig = class
  private
    FArquivoCertificado: String;
    FArquivoChavePrivada: String;
  public
    property ArquivoCertificado: String read FArquivoCertificado write FArquivoCertificado;
    property ArquivoChavePrivada: String read FArquivoChavePrivada write FArquivoChavePrivada;
  end;

  { TACBrExtratoAPIBancoClass }
  TExtratoAPIBancoConfig = class(TExtratoAPIHTTPConfig)
  private
    FClientID: String;
    FClientSecret: String;
  public
    property ClientID: String read FClientID write FClientID;
    property ClientSecret: String read FClientSecret write FClientSecret;
  end;

  { TExtratoAPIBBConfig }
  TExtratoAPIBBConfig = class(TExtratoAPIBancoConfig)
  private
    FDeveloperApplicationKey: String;
    FxMCITeste: String;
  public
    constructor Create;

    procedure LerIni(const AIni: TCustomIniFile);
    procedure GravarIni(const AIni: TCustomIniFile);

    property DeveloperApplicationKey: String read FDeveloperApplicationKey write FDeveloperApplicationKey;
    property xMCITeste: String read FxMCITeste write FxMCITeste; // Apenas para Homologação
  end;

  { TExtratoAPIInterConfig }
  TExtratoAPIInterConfig = class(TExtratoAPIBancoConfig)
  public
    constructor Create;

    procedure LerIni(const AIni: TCustomIniFile);
    procedure GravarIni(const AIni: TCustomIniFile);
  end;

  { TExtratoAPISicoobConfig }
  TExtratoAPISicoobConfig = class(TExtratoAPIBancoConfig)
  public
    constructor Create;

    procedure LerIni(const AIni: TCustomIniFile);
    procedure GravarIni(const AIni: TCustomIniFile);
  end;

  { TExtratoAPIConfig }
  TExtratoAPIConfig = class
  private
    FAmbiente: TACBrExtratoAPIAmbiente;
    FArqLOG: String;
    FNivelLog: Byte;
    FBancoConsulta: TACBrExtratoAPIBancoConsulta;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LerIni(const AIni: TCustomIniFile);
    procedure GravarIni(const AIni: TCustomIniFile);

    property Ambiente: TACBrExtratoAPIAmbiente read FAmbiente write FAmbiente;
    property ArqLog: String read FArqLOG write FArqLOG;
    property NivelLog: Byte read FNivelLog write FNivelLog;
    property BancoConsulta: TACBrExtratoAPIBancoConsulta read FBancoConsulta write FBancoConsulta;
  end;

  { TLibExtratoAPIConfig }
  TLibExtratoAPIConfig = class(TLibConfig)
  private
    FExtratoAPIConfig: TExtratoAPIConfig;
    FExtratoAPIBBConfig: TExtratoAPIBBConfig;
    FExtratoAPIInterConfig: TExtratoAPIInterConfig;
    FExtratoAPISicoobConfig: TExtratoAPISicoobConfig;
  protected
    function AtualizarArquivoConfiguracao: Boolean; override;

    procedure INIParaClasse; override;
    procedure ClasseParaINI; override;
    procedure ClasseParaComponentes; override;

    procedure Travar; override;
    procedure Destravar; override;
  public
    constructor Create(AOwner: TObject; ANomeArquivo: String = ''; AChaveCrypt: AnsiString = ''); override;
    destructor Destroy; override;

    property ExtratoAPIConfig: TExtratoAPIConfig read FExtratoAPIConfig;
    property ExtratoAPIBBConfig: TExtratoAPIBBConfig read FExtratoAPIBBConfig write FExtratoAPIBBConfig;
    property ExtratoAPIInterConfig: TExtratoAPIInterConfig read FExtratoAPIInterConfig write FExtratoAPIInterConfig;
    property ExtratoAPISicoobConfig: TExtratoAPISicoobConfig read FExtratoAPISicoobConfig write FExtratoAPISicoobConfig;
  end;

implementation

uses
  ACBrLibExtratoAPIBase, ACBrLibExtratoAPIConsts, ACBrLibConsts;

{ TLibExtratoAPIConfig }
constructor TLibExtratoAPIConfig.Create(AOwner: TObject; ANomeArquivo: String; AChaveCrypt: AnsiString);
begin
  inherited Create(AOwner, ANomeArquivo, AChaveCrypt);

  FExtratoAPIConfig := TExtratoAPIConfig.Create;
  FExtratoAPIBBConfig := TExtratoAPIBBConfig.Create;
  FExtratoAPIInterConfig := TExtratoAPIInterConfig.Create;
  FExtratoAPISicoobConfig := TExtratoAPISicoobConfig.Create;
end;

destructor TLibExtratoAPIConfig.Destroy;
begin
  FExtratoAPIConfig.Free;
  FExtratoAPIBBConfig.Free;
  FExtratoAPIInterConfig.Free;
  FExtratoAPISicoobConfig.Free;

  inherited Destroy;
end;

procedure TLibExtratoAPIConfig.INIParaClasse;
begin
  inherited INIParaClasse;

  FExtratoAPIConfig.LerIni(Ini);
  FExtratoAPIBBConfig.LerIni(Ini);
  FExtratoAPIInterConfig.LerIni(Ini);
  FExtratoAPISicoobConfig.LerIni(Ini);
end;

procedure TLibExtratoAPIConfig.ClasseParaINI;
begin
  inherited ClasseParaINI;

  Ini.WriteString(CSessaoVersao, CLibExtratoAPINome, CLibExtratoAPIVersao);

  FExtratoAPIConfig.GravarIni(Ini);
  FExtratoAPIBBConfig.GravarIni(Ini);
  FExtratoAPIInterConfig.GravarIni(Ini);
  FExtratoAPISicoobConfig.GravarIni(Ini);
end;

procedure TLibExtratoAPIConfig.ClasseParaComponentes;
begin
  if Assigned(Owner) then
    TACBrLibExtratoAPI(Owner).ExtratoAPIDM.AplicarConfiguracoes;
end;

function TLibExtratoAPIConfig.AtualizarArquivoConfiguracao: Boolean;
var
  Versao: String;
begin
  Versao := Ini.ReadString(CSessaoVersao, CLibExtratoAPINome, '0');
  Result := (CompareVersions(CLibExtratoAPIVersao, Versao) > 0 ) or
             (inherited AtualizarArquivoConfiguracao);
end;

procedure TLibExtratoAPIConfig.Travar;
begin
  if Assigned(Owner) then
    TACBrLibExtratoAPI(Owner).ExtratoAPIDM.Travar;
end;

procedure TLibExtratoAPIConfig.Destravar;
begin
  if Assigned(Owner) then
    TACBrLibExtratoAPI(Owner).ExtratoAPIDM.Destravar;
end;

constructor TExtratoAPIBBConfig.Create;
begin
  inherited Create;

  FArquivoCertificado := EmptyStr;
  FArquivoChavePrivada := EmptyStr;
  FClientID := EmptyStr;
  FClientSecret := EmptyStr;
  FDeveloperApplicationKey := EmptyStr;
  FxMCITeste := EmptyStr;
end;

{ TExtratoAPIBBConfig }
procedure TExtratoAPIBBConfig.LerIni(const AIni: TCustomIniFile);
begin
  ArquivoCertificado := AIni.ReadString(CSessaoExtratoAPIBBConfig, CArquivoCertificado, ArquivoCertificado);
  ArquivoChavePrivada := AIni.ReadString(CSessaoExtratoAPIBBConfig, CArquivoChavePrivada, ArquivoChavePrivada);
  ClientID := AIni.ReadString(CSessaoExtratoAPIBBConfig, CClientID, ClientID);
  ClientSecret := AIni.ReadString(CSessaoExtratoAPIBBConfig, CClientSecret, ClientSecret);
  DeveloperApplicationKey := AIni.ReadString(CSessaoExtratoAPIBBConfig, CDeveloperApplicationKey, DeveloperApplicationKey);
  xMCITeste := AIni.ReadString(CSessaoExtratoAPIBBConfig, CxMCITeste, xMCITeste);
end;

procedure TExtratoAPIBBConfig.GravarIni(const AIni: TCustomIniFile);
begin
  AIni.WriteString(CSessaoExtratoAPIBBConfig, CArquivoCertificado, ArquivoCertificado);
  AIni.WriteString(CSessaoExtratoAPIBBConfig, CArquivoChavePrivada, ArquivoChavePrivada);
  AIni.WriteString(CSessaoExtratoAPIBBConfig, CClientID, ClientID);
  AIni.WriteString(CSessaoExtratoAPIBBConfig, CClientSecret, ClientSecret);
  AIni.WriteString(CSessaoExtratoAPIBBConfig, CDeveloperApplicationKey, DeveloperApplicationKey);
  AIni.WriteString(CSessaoExtratoAPIBBConfig, CxMCITeste, xMCITeste);
end;

constructor TExtratoAPIInterConfig.Create;
begin
  inherited Create;

  FArquivoCertificado := EmptyStr;
  FArquivoChavePrivada := EmptyStr;
  FClientID := EmptyStr;
  FClientSecret := EmptyStr;
end;

{ TExtratoAPIInterConfig }
procedure TExtratoAPIInterConfig.LerIni(const AIni: TCustomIniFile);
begin
  ArquivoCertificado := AIni.ReadString(CSessaoExtratoAPIInterConfig, CArquivoCertificado, ArquivoCertificado);
  ArquivoChavePrivada := AIni.ReadString(CSessaoExtratoAPIInterConfig, CArquivoChavePrivada, ArquivoChavePrivada);
  ClientID := AIni.ReadString(CSessaoExtratoAPIInterConfig, CClientID, ClientID);
  ClientSecret := AIni.ReadString(CSessaoExtratoAPIInterConfig, CClientSecret, ClientSecret);
end;

procedure TExtratoAPIInterConfig.GravarIni(const AIni: TCustomIniFile);
begin
  AIni.WriteString(CSessaoExtratoAPIInterConfig, CArquivoCertificado, ArquivoCertificado);
  AIni.WriteString(CSessaoExtratoAPIInterConfig, CArquivoChavePrivada, ArquivoChavePrivada);
  AIni.WriteString(CSessaoExtratoAPIInterConfig, CClientID, ClientID);
  AIni.WriteString(CSessaoExtratoAPIInterConfig, CClientSecret, ClientSecret);
end;

constructor TExtratoAPISicoobConfig.Create;
begin
  inherited Create;

  FArquivoCertificado := EmptyStr;
  FArquivoChavePrivada := EmptyStr;
  FClientID := EmptyStr;
  FClientSecret := EmptyStr;
end;

{ TExtratoAPISicoobConfig }
procedure TExtratoAPISicoobConfig.LerIni(const AIni: TCustomIniFile);
begin
  ArquivoCertificado := AIni.ReadString(CSessaoExtratoAPISicoobConfig, CArquivoCertificado, ArquivoCertificado);
  ArquivoChavePrivada := AIni.ReadString(CSessaoExtratoAPISicoobConfig, CArquivoChavePrivada, ArquivoChavePrivada);
  ClientID := AIni.ReadString(CSessaoExtratoAPISicoobConfig, CClientID, ClientID);
end;

procedure TExtratoAPISicoobConfig.GravarIni(const AIni: TCustomIniFile);
begin
  AIni.WriteString(CSessaoExtratoAPISicoobConfig, CArquivoCertificado, ArquivoCertificado);
  AIni.WriteString(CSessaoExtratoAPISicoobConfig, CArquivoChavePrivada, ArquivoChavePrivada);
  AIni.WriteString(CSessaoExtratoAPISicoobConfig, CClientID, ClientID);
end;

{ TExtratoAPIConfig }
constructor TExtratoAPIConfig.Create;
begin
  inherited;
  FAmbiente := eamNenhum;
  FArqLOG := '';
  FNivelLog := 1;
  FBancoConsulta := bccNenhum;
end;

destructor TExtratoAPIConfig.Destroy;
begin
  inherited Destroy
end;

procedure TExtratoAPIConfig.LerIni(const AIni: TCustomIniFile);
var
  LRetorno: Integer;
begin
  Ambiente := TACBrExtratoAPIAmbiente(AIni.ReadInteger(CSessaoExtratoAPIConfig, CChaveAmbiente, integer(Ambiente)));
  ArqLog := AIni.ReadString(CSessaoExtratoAPIConfig, CChaveArqLogExtratoAPI, ArqLog);
  NivelLog := AIni.ReadInteger(CSessaoExtratoAPIConfig, CChaveNivelLog, NivelLog);
  LRetorno := AIni.ReadInteger(CSessaoExtratoAPIConfig, CBancoConsulta, Integer(BancoConsulta));
  if ((LRetorno >= 0) and (LRetorno <= Integer(High(TACBrExtratoAPIBancoConsulta)))) then
    BancoConsulta := TACBrExtratoAPIBancoConsulta(LRetorno);
end;

procedure TExtratoAPIConfig.GravarIni(const AIni: TCustomIniFile);
begin
  AIni.WriteInteger(CSessaoExtratoAPIConfig, CChaveAmbiente, integer(Ambiente));
  AIni.WriteString(CSessaoExtratoAPIConfig, CChaveArqLogExtratoAPI, ArqLog);
  AIni.WriteInteger(CSessaoExtratoAPIConfig, CChaveNivelLog, NivelLog);
  AIni.WriteInteger(CSessaoExtratoAPIConfig, CBancoConsulta, Integer(BancoConsulta));
end;

end.

