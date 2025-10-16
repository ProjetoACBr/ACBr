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

unit ACBrLibExtratoAPIDataModule;

interface

uses
  Classes, SysUtils, FileUtil,
  ACBrUtil.Base, ACBrLibComum, ACBrLibDataModule, ACBrExtratoAPI,
  ACBrLibExtratoAPIConfig, ACBrExtratoAPIBB, ACBrExtratoAPIInter,
  ACBrExtratoAPISicoob;

type
  { TLibExtratoAPIDM }
  TLibExtratoAPIDM = class(TLibDataModule)
    ACBrExtratoAPI1: TACBrExtratoAPI;
  protected
    procedure DoCreate; override;
  public
    procedure AplicarConfiguracoes; override;
    procedure AplicarConfiguracoesBB(ABanco: TACBrExtratoAPIBB; ALibExtratoAPIConfig: TLibExtratoAPIConfig);
    procedure AplicarConfiguracoesInter(ABanco: TACBrExtratoAPIInter; ALibExtratoAPIConfig: TLibExtratoAPIConfig);
    procedure AplicarConfiguracoesSicoob(ABanco: TACBrExtratoAPISicoob; ALibExtratoAPIConfig: TLibExtratoAPIConfig);
  end;

implementation

{$R *.lfm}

{ TLibExtratoAPIDM }

procedure TLibExtratoAPIDM.DoCreate;
begin
  inherited DoCreate;
end;

procedure TLibExtratoAPIDM.AplicarConfiguracoes;
var
  LLibExtratoAPIConfig: TLibExtratoAPIConfig;
begin
  LLibExtratoAPIConfig := TLibExtratoAPIConfig(Lib.Config);

  ACBrExtratoAPI1.Ambiente := LLibExtratoAPIConfig.ExtratoAPIConfig.Ambiente;
  ACBrExtratoAPI1.LogArquivo := LLibExtratoAPIConfig.ExtratoAPIConfig.ArqLog;
  ACBrExtratoAPI1.LogNivel := LLibExtratoAPIConfig.ExtratoAPIConfig.NivelLog;
  ACBrExtratoAPI1.BancoConsulta := LLibExtratoAPIConfig.ExtratoAPIConfig.BancoConsulta;

  case ACBrExtratoAPI1.BancoConsulta of
    bccBancoDoBrasil: AplicarConfiguracoesBB(TACBrExtratoAPIBB(ACBrExtratoAPI1.Banco), LLibExtratoAPIConfig);
    bccInter: AplicarConfiguracoesInter(TACBrExtratoAPIInter(ACBrExtratoAPI1.Banco), LLibExtratoAPIConfig);
    bccSicoob: AplicarConfiguracoesSicoob(TACBrExtratoAPISicoob(ACBrExtratoAPI1.Banco), LLibExtratoAPIConfig);
  end;

  ACBrExtratoAPI1.Banco.ProxyPort := IntToStr(Lib.Config.ProxyInfo.Porta);
  if ACBrExtratoAPI1.Banco.ProxyPort <> '0' then
  begin
    ACBrExtratoAPI1.Banco.ProxyHost := Lib.Config.ProxyInfo.Servidor;
    ACBrExtratoAPI1.Banco.ProxyUser := Lib.Config.ProxyInfo.Usuario;
    ACBrExtratoAPI1.Banco.ProxyPass := Lib.Config.ProxyInfo.Senha;
  end;

  {$IFDEF Demo}
  ACBrExtratoAPI1.Ambiente := eamHomologacao;
  {$ENDIF}
end;

procedure TLibExtratoAPIDM.AplicarConfiguracoesBB(ABanco: TACBrExtratoAPIBB; ALibExtratoAPIConfig: TLibExtratoAPIConfig);
begin
  ABanco.ClientID := ALibExtratoAPIConfig.ExtratoAPIBBConfig.ClientID;
  ABanco.ClientSecret := ALibExtratoAPIConfig.ExtratoAPIBBConfig.ClientSecret;
  ABanco.ArquivoCertificado := ALibExtratoAPIConfig.ExtratoAPIBBConfig.ArquivoCertificado;
  ABanco.ArquivoChavePrivada := ALibExtratoAPIConfig.ExtratoAPIBBConfig.ArquivoChavePrivada;
  ABanco.DeveloperApplicationKey := ALibExtratoAPIConfig.ExtratoAPIBBConfig.DeveloperApplicationKey;
  if (ACBrExtratoAPI1.Ambiente = eamHomologacao) then
    ABanco.xMCITeste := ALibExtratoAPIConfig.ExtratoAPIBBConfig.xMCITeste;
end;

procedure TLibExtratoAPIDM.AplicarConfiguracoesInter(ABanco: TACBrExtratoAPIInter; ALibExtratoAPIConfig: TLibExtratoAPIConfig);
begin
  ABanco.ClientID := ALibExtratoAPIConfig.ExtratoAPIInterConfig.ClientID;
  ABanco.ClientSecret := ALibExtratoAPIConfig.ExtratoAPIInterConfig.ClientSecret;
  ABanco.ArquivoCertificado := ALibExtratoAPIConfig.ExtratoAPIInterConfig.ArquivoCertificado;
  ABanco.ArquivoChavePrivada := ALibExtratoAPIConfig.ExtratoAPIInterConfig.ArquivoChavePrivada;
end;

procedure TLibExtratoAPIDM.AplicarConfiguracoesSicoob(ABanco: TACBrExtratoAPISicoob; ALibExtratoAPIConfig: TLibExtratoAPIConfig);
begin
  ABanco.ClientID := ALibExtratoAPIConfig.ExtratoAPISicoobConfig.ClientID;
  ABanco.ArquivoCertificado := ALibExtratoAPIConfig.ExtratoAPISicoobConfig.ArquivoCertificado;
  ABanco.ArquivoChavePrivada := ALibExtratoAPIConfig.ExtratoAPISicoobConfig.ArquivoChavePrivada;
end;

end.

