{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

{$I ACBr.inc}

unit ACBrCIOTConfiguracoes;

interface

uses
  Classes, SysUtils, IniFiles,
  ACBrDFeConfiguracoes,
  ACBrCIOTConversao;

type

  { TGeralConfCIOT }

  TGeralConfCIOT = class(TGeralConf)
  private
    FIntegradora: TCIOTIntegradora;
    FVersaoDF: TVersaoCIOT;
    FUsuario: String;
    FSenha: String;
    FCNPJEmitente: String;
    FHashIntegrador: String;

    procedure SetVersaoDF(const Value: TVersaoCIOT);
  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeGeralConfCIOT: TGeralConfCIOT); reintroduce;

    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;
  published
    property Integradora: TCIOTIntegradora read FIntegradora write FIntegradora;
    property VersaoDF: TVersaoCIOT read FVersaoDF write SetVersaoDF default ve500;
    property Usuario: String read FUsuario write FUsuario;
    property Senha: String read FSenha write FSenha;
    property CNPJEmitente: String read FCNPJEmitente write FCNPJEmitente;
    property HashIntegrador: String read FHashIntegrador write FHashIntegrador;
  end;

  { TArquivosConfCIOT }

  TArquivosConfCIOT = class(TArquivosConf)
  private
    FEmissaoPathCIOT: boolean;
    FPathCIOT: String;
  public
    constructor Create(AOwner: TConfiguracoes); override;
    destructor Destroy; override;
    procedure Assign(DeArquivosConfCIOT: TArquivosConfCIOT); reintroduce;

    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

    function GetPathCIOT(Data: TDateTime = 0; const CNPJ: String = ''): String;
  published
    property EmissaoPathCIOT: boolean read FEmissaoPathCIOT
      write FEmissaoPathCIOT default False;
    property PathCIOT: String read FPathCIOT write FPathCIOT;
  end;

  { TConfiguracoesCIOT }

  TConfiguracoesCIOT = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfCIOT;
    function GetGeral: TGeralConfCIOT;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(DeConfiguracoesCIOT: TConfiguracoesCIOT); reintroduce;

  published
    property Geral: TGeralConfCIOT read GetGeral;
    property Arquivos: TArquivosConfCIOT read GetArquivos;
    property WebServices;
    property Certificados;
  end;

implementation

uses
  ACBrUtil.Strings, DateUtils;

{ TConfiguracoesCIOT }

constructor TConfiguracoesCIOT.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPSessaoIni := 'CIOT';
  WebServices.ResourceName := 'ACBrCIOTServicos';
end;

function TConfiguracoesCIOT.GetArquivos: TArquivosConfCIOT;
begin
  Result := TArquivosConfCIOT(FPArquivos);
end;

function TConfiguracoesCIOT.GetGeral: TGeralConfCIOT;
begin
  Result := TGeralConfCIOT(FPGeral);
end;

procedure TConfiguracoesCIOT.CreateGeralConf;
begin
  FPGeral := TGeralConfCIOT.Create(Self);
end;

procedure TConfiguracoesCIOT.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfCIOT.Create(self);
end;

procedure TConfiguracoesCIOT.Assign(DeConfiguracoesCIOT: TConfiguracoesCIOT);
begin
  Geral.Assign(DeConfiguracoesCIOT.Geral);
  WebServices.Assign(DeConfiguracoesCIOT.WebServices);
  Certificados.Assign(DeConfiguracoesCIOT.Certificados);
  Arquivos.Assign(DeConfiguracoesCIOT.Arquivos);
end;

{ TGeralConfCIOT }

procedure TGeralConfCIOT.Assign(DeGeralConfCIOT: TGeralConfCIOT);
begin
  inherited Assign(DeGeralConfCIOT);

  FVersaoDF := DeGeralConfCIOT.VersaoDF;
end;

constructor TGeralConfCIOT.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FVersaoDF := ve500;
  FIntegradora := ieFrete;
  FUsuario := '';
  FSenha := '';
  FCNPJEmitente := '';
  FHashIntegrador := '';
end;

procedure TGeralConfCIOT.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'Integradora', Integer(Integradora));
  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF));
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'Usuario', Usuario);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'Senha', Senha);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'CNPJEmitente', CNPJEmitente);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'HashIntegrador', HashIntegrador);
end;

procedure TGeralConfCIOT.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  Integradora := TCIOTIntegradora(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'Integradora', Integer(Integradora)));
  VersaoDF := TVersaoCIOT(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF)));
  Usuario := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Usuario', Usuario);
  Senha := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Senha', Senha);
  CNPJEmitente := AIni.ReadString(fpConfiguracoes.SessaoIni, 'CNPJEmitente', CNPJEmitente);
  HashIntegrador := AIni.ReadString(fpConfiguracoes.SessaoIni, 'HashIntegrador', HashIntegrador);
end;

procedure TGeralConfCIOT.SetVersaoDF(const Value: TVersaoCIOT);
begin
  FVersaoDF := Value;
end;

{ TArquivosConfCIOT }

procedure TArquivosConfCIOT.Assign(DeArquivosConfCIOT: TArquivosConfCIOT);
begin
  inherited Assign(DeArquivosConfCIOT);

  FEmissaoPathCIOT := DeArquivosConfCIOT.EmissaoPathCIOT;
  FPathCIOT        := DeArquivosConfCIOT.PathCIOT;
end;

constructor TArquivosConfCIOT.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FEmissaoPathCIOT := False;
  FPathCIOT := '';
end;

destructor TArquivosConfCIOT.Destroy;
begin

  inherited;
end;

function TArquivosConfCIOT.GetPathCIOT(Data: TDateTime = 0;
  const CNPJ: String = ''): String;
begin
  Result := GetPath(FPathCIOT, 'CIOT', CNPJ, '', Data);
end;

procedure TArquivosConfCIOT.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'EmissaoPathCIOT', EmissaoPathCIOT);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathCIOT', PathCIOT);
end;

procedure TArquivosConfCIOT.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  EmissaoPathCIOT := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'EmissaoPathCIOT', EmissaoPathCIOT);
  PathCIOT := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathCIOT', PathCIOT);
end;

end.
