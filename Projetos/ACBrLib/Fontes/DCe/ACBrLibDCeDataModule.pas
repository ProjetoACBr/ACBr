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

unit ACBrLibDCeDataModule;

{$IfDef FPC}
{$mode delphi}
{$EndIf}

interface

uses
  Classes, SysUtils, ACBrLibComum, ACBrLibDataModule,
  ACBrDCe.DACERLClass,
  ACBrDCe,
  ACBrMail;

type

  { TLibDCeDM }

  TLibDCeDM = class(TLibDataModule)
    ACBrDCe1: TACBrDCe;
    FDACeFortes: TACBrDCeDACERL;
    ACBrMail1: TACBrMail;

  protected
    procedure FreeReports;

  public
    procedure AplicarConfiguracoes; override;
    procedure AplicarConfigMail;
    procedure ConfigurarImpressao(NomeImpressora: String = ''; GerarPDF: Boolean = False;
                                  MostrarPreview: String = '');
    procedure FinalizarImpressao;
  end;

var
  LibDCeDM: TLibDCeDM;

implementation

uses
  pcnConversao, ACBrLibConfig, ACBrLibDCeConfig, ACBrUtil.Base, ACBrUtil.FilesIO;

{$R *.lfm}

{ TLibDCeDM }

procedure TLibDCeDM.FreeReports;
begin
  ACBrDCe1.DACE := nil;
  if Assigned(FDACeFortes) then FreeAndNil(FDACeFortes);
end;

procedure TLibDCeDM.AplicarConfiguracoes;
var
  pLibDCeConfig: TLibDCeConfig;
begin
  ACBrDCe1.SSL.DescarregarCertificado;
  pLibDCeConfig := TLibDCeConfig(Lib.Config);
  ACBrDCe1.Configuracoes.Assign(pLibDCeConfig.DCeConfig);
  ACBrDCe1.DACE := FDACeFortes;

  {$IFDEF Demo}
  GravarLog('Modo DEMO - Forçando ambiente para Homologação', logNormal);
  ACBrDCe1.Configuracoes.WebServices.Ambiente := taHomologacao;
  {$ENDIF}

  AplicarConfigMail;
end;

procedure TLibDCeDM.AplicarConfigMail;
begin
  with ACBrMail1 do
  begin
    Attempts             := Lib.Config.Email.Tentativas;
    SetTLS               := Lib.Config.Email.TLS;
    DefaultCharset       := Lib.Config.Email.Codificacao;
    From                 := Lib.Config.Email.Conta;
    FromName             := Lib.Config.Email.Nome;
    SetSSL               := Lib.Config.Email.SSL;
    Host                 := Lib.Config.Email.Servidor;
    IDECharset           := Lib.Config.Email.Codificacao;
    IsHTML               := Lib.Config.Email.IsHTML;
    Password             := Lib.Config.Email.Senha;
    Port                 := IntToStr(Lib.Config.Email.Porta);
    Priority             := Lib.Config.Email.Priority;
    ReadingConfirmation  := Lib.Config.Email.Confirmacao;
    DeliveryConfirmation := Lib.Config.Email.ConfirmacaoEntrega;
    TimeOut              := Lib.Config.Email.TimeOut;
    Username             := Lib.Config.Email.Usuario;
    UseThread            := Lib.Config.Email.SegundoPlano;
  end;
end;

procedure TLibDCeDM.ConfigurarImpressao(NomeImpressora: String;
  GerarPDF: Boolean; MostrarPreview: String);
var
  LibConfig: TLibDCeConfig;
begin
  LibConfig := TLibDCeConfig(Lib.Config);

  GravarLog('ConfigurarImpressao - Iniciado', logNormal);

  FDACeFortes := TACBrDCeDACERL.Create(Nil);
  ACBrDCe1.DACE := FDACeFortes;

  if GerarPDF then
  begin
    if (LibConfig.DACeConfig.PathPDF <> '') then
      if not DirectoryExists(PathWithDelim(LibConfig.DACeConfig.PathPDF))then
        ForceDirectories(PathWithDelim(LibConfig.DACeConfig.PathPDF));
  end;

  LibConfig.DACeConfig.Apply(FDACeFortes, Lib);

  if NaoEstaVazio(NomeImpressora) then
    FDACeFortes.Impressora := NomeImpressora;

  if NaoEstaVazio(MostrarPreview) then
    FDACeFortes.MostraPreview := StrToBoolDef(MostrarPreview, False);

  GravarLog('ConfigurarImpressao - Feito', logNormal);
end;

procedure TLibDCeDM.FinalizarImpressao;
begin
  GravarLog('FinalizarImpressao - Iniciado', logNormal);
  FreeReports;
  GravarLog('FinalizarImpressao - Feito', logNormal);
end;

end.

