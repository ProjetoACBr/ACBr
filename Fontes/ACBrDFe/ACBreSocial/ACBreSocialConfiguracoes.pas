{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 28/08/2017: Leivio Fontenele - leivio@yahoo.com.br
|*  - Implementa��o comunica��o, envelope, status e retorno do componente com webservice.
******************************************************************************}

{$I ACBr.inc}

unit ACBreSocialConfiguracoes;

interface

uses
  Classes, SysUtils, IniFiles,
  ACBrDFeConfiguracoes, pcnConversao,
  pcesConversaoeSocial;

type

  { TGeralConfeSocial }
  TGeralConfeSocial = class(TGeralConf)
  private
    FVersaoDF: TVersaoeSocial;
    FIdTransmissor: string;
    FIdEmpregador: string;
    FTipoEmpregador: TEmpregador;

    procedure SetVersaoDF(const Value: TVersaoeSocial);
    procedure SetTipoEmpregador(const Value: TEmpregador);

  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeGeralConfeSocial: TGeralConfeSocial); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

  published
    property VersaoDF: TVersaoeSocial read FVersaoDF write SetVersaoDF default veS01_01_00;
    property IdEmpregador: string read FIdEmpregador write FIdEmpregador;
    property IdTransmissor: string read FIdTransmissor write FIdTransmissor;
    property TipoEmpregador: TEmpregador read FTipoEmpregador write SetTipoEmpregador default tePessoaJuridica;
  end;

  { TArquivosConfeSocial }
  TArquivosConfeSocial = class(TArquivosConf)
  private
    FEmissaoPatheSocial: Boolean;
    FPatheSocial: String;

  public
    constructor Create(AOwner: TConfiguracoes); override;

    procedure Assign(DeArquivosConfeSocial: TArquivosConfeSocial); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

    function GetPatheSocial(Data: TDateTime = 0; const CNPJ: String = ''): String;

  published
    property EmissaoPatheSocial: Boolean read FEmissaoPatheSocial write FEmissaoPatheSocial default False;
    property PatheSocial: String read FPatheSocial write FPatheSocial;

  end;

  { TConfiguracoeseSocial }
  TConfiguracoeseSocial = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfeSocial;
    function GetGeral: TGeralConfeSocial;

  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;

  public
    constructor Create(AOwner: TComponent); override;

    procedure Assign(DeConfiguracoeseSocial: TConfiguracoeseSocial); reintroduce;

  published
    property Geral: TGeralConfeSocial read GetGeral;
    property Arquivos: TArquivosConfeSocial read GetArquivos;
    property WebServices;
    property Certificados;

  end;

implementation

uses
  ACBreSocial;


{ TConfiguracoeseSocial }

constructor TConfiguracoeseSocial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPSessaoIni := 'eSocial';
  WebServices.ResourceName := 'ACBreSocialServicos';
end;

procedure TConfiguracoeseSocial.Assign(DeConfiguracoeseSocial: TConfiguracoeseSocial);
begin
  Geral.Assign(DeConfiguracoeseSocial.Geral);
  WebServices.Assign(DeConfiguracoeseSocial.WebServices);
  Certificados.Assign(DeConfiguracoeseSocial.Certificados);
  Arquivos.Assign(DeConfiguracoeseSocial.Arquivos);
end;

function TConfiguracoeseSocial.GetArquivos: TArquivosConfeSocial;
begin
  Result := TArquivosConfeSocial(FPArquivos);
end;

function TConfiguracoeseSocial.GetGeral: TGeralConfeSocial;
begin
  Result := TGeralConfeSocial(FPGeral);
end;

procedure TConfiguracoeseSocial.CreateGeralConf;
begin
  FPGeral := TGeralConfeSocial.Create(Self);
end;

procedure TConfiguracoeseSocial.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfeSocial.Create(self);
end;

{ TGeralConfeSocial }

constructor TGeralConfeSocial.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FVersaoDF := veS01_02_00;
  FIdTransmissor := '';
  FIdEmpregador := '';
  FTipoEmpregador := tePessoaJuridica;
end;

procedure TGeralConfeSocial.Assign(DeGeralConfeSocial: TGeralConfeSocial);
begin
  inherited Assign(DeGeralConfeSocial);

  VersaoDF := DeGeralConfeSocial.VersaoDF;
  IdTransmissor := DeGeralConfeSocial.IdTransmissor;
  IdEmpregador := DeGeralConfeSocial.IdEmpregador;
  TipoEmpregador := DeGeralConfeSocial.TipoEmpregador;
end;

procedure TGeralConfeSocial.SetVersaoDF(const Value: TVersaoeSocial);
begin
  FVersaoDF := Value;
end;

procedure TGeralConfeSocial.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF));
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'IdTransmissor', IdTransmissor);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'IdEmpregador', IdEmpregador);
  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'TipoEmpregador', Integer(TipoEmpregador));
end;

procedure TGeralConfeSocial.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  VersaoDF := TVersaoeSocial(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF)));
  IdTransmissor := AIni.ReadString(fpConfiguracoes.SessaoIni, 'IdTransmissor', IdTransmissor);
  IdEmpregador := AIni.ReadString(fpConfiguracoes.SessaoIni, 'IdEmpregador', IdEmpregador);
  TipoEmpregador := TEmpregador(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'TipoEmpregador', Integer(TipoEmpregador)));
end;

procedure TGeralConfeSocial.SetTipoEmpregador(const Value: TEmpregador);
begin
  FTipoEmpregador := Value;
end;

{ TArquivosConfeSocial }

constructor TArquivosConfeSocial.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FEmissaoPatheSocial := False;
  FPatheSocial := '';
end;

procedure TArquivosConfeSocial.Assign(
  DeArquivosConfeSocial: TArquivosConfeSocial);
begin
  inherited Assign(DeArquivosConfeSocial);

  EmissaoPatheSocial := DeArquivosConfeSocial.EmissaoPatheSocial;
  PatheSocial        := DeArquivosConfeSocial.PatheSocial;
end;

function TArquivosConfeSocial.GetPatheSocial(Data: TDateTime;
  const CNPJ: String): String;
begin
  Result := GetPath(PatheSocial, ACBRESOCIAL_MODELODF, CNPJ, '', Data, ACBRESOCIAL_MODELODF);
end;

procedure TArquivosConfeSocial.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'EmissaoPatheSocial', EmissaoPatheSocial);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PatheSocial', PatheSocial);
end;

procedure TArquivosConfeSocial.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  EmissaoPatheSocial := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'EmissaoPatheSocial', EmissaoPatheSocial);
  PatheSocial := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PatheSocial', PatheSocial);
end;

end.
