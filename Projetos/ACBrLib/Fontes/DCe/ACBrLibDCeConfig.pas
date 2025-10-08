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

{$I ACBr.inc}

unit ACBrLibDCeConfig;

interface

uses
  Classes, SysUtils, IniFiles, synachar,
  ACBrLibComum, ACBrLibConfig, ACBrDCe, ACBrDCe.DACERLClass,
  ACBrDCe.Conversao, ACBrDCeConfiguracoes, ACBrXmlBase, DFeReportConfig, ACBrDFeReport;

type

{ TDACeReportConfig }
TDACeReportConfig = class(TDFeReportConfig<TACBrDFeReport>)
  private
    FMostraPreview: Boolean;
    FMargemInferior: Double;
    FMargemSuperior: Double;
    FMargemEsquerda: Double;
    FMargemDireita: Double;

  protected
    procedure LerIniChild(const AIni: TCustomIniFile); override;
    procedure GravarIniChild(const AIni: TCustomIniFile); override;
    procedure ApplyChild(const DFeReport: TACBrDFeReport; const Lib: TACBrLib); override;
    procedure DefinirValoresPadroesChild; override;

  public
    constructor Create;
    destructor Destroy; override;

    property MostraPreview: Boolean read FMostraPreview write FMostraPreview;
    property MargemInferior: Double read FMargemInferior write FMargemInferior;
    property MargemSuperior: Double read FMargemSuperior write FMargemSuperior;
    property MargemEsquerda: Double read FMargemEsquerda write FMargemEsquerda;
    property MargemDireita: Double read FMargemDireita write FMargemDireita;
end;

{ TLibDCeConfig }
TLibDCeConfig = class(TLibConfig)
  private
    FDCeConfig: TConfiguracoesDCe;
    FDACeConfig: TDACeReportConfig;

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

    property DCeConfig: TConfiguracoesDCe read FDCeConfig;
    property DACeConfig: TDACeReportConfig read FDACeConfig;
end;

implementation

uses
  ACBrLibDCeBase, ACBrLibDCeConsts, ACBrLibConsts, ACBrUtil.FilesIO;

{ TDACeReportConfig }

procedure TDACeReportConfig.LerIniChild(const AIni: TCustomIniFile);
begin
  FMostraPreview := AIni.ReadBool(CSessaoDACe, CChaveMostraPreview, FMostraPreview);
  FMargemInferior := AIni.ReadFloat(CSessaoDACe, CChaveMargemInferior, FMargemInferior);
  FMargemSuperior := AIni.ReadFloat(CSessaoDACe, CChaveMargemSuperior, FMargemSuperior);
  FMargemEsquerda := AIni.ReadFloat(CSessaoDACe, CChaveMargemEsquerda, FMargemEsquerda);
  FMargemDireita := AIni.ReadFloat(CSessaoDACe, CChaveMargemDireita, FMargemDireita);
end;

procedure TDACeReportConfig.GravarIniChild(const AIni: TCustomIniFile);
begin
  AIni.WriteBool(CSessaoDACe, CChaveMostraPreview, FMostraPreview);
  AIni.WriteFloat(CSessaoDACe, CChaveMargemInferior, FMargemInferior);
  AIni.WriteFloat(CSessaoDACe, CChaveMargemSuperior, FMargemSuperior);
  AIni.WriteFloat(CSessaoDACe, CChaveMargemEsquerda, FMargemEsquerda);
  AIni.WriteFloat(CSessaoDACe, CChaveMargemDireita, FMargemDireita);
end;

procedure TDACeReportConfig.ApplyChild(const DFeReport: TACBrDFeReport;
  const Lib: TACBrLib);
var
  LDACe: TACBrDCeDACERL;
begin
  LDACe := TACBrDCeDACERL(DFeReport);
  with LDACe do
  begin
    MostraPreview := FMostraPreview;
    MargemInferior := FMargemInferior;
    MargemSuperior := FMargemSuperior;
    MargemEsquerda := FMargemEsquerda;
    MargemDireita  := FMargemDireita;
  end;
end;

procedure TDACeReportConfig.DefinirValoresPadroesChild;
begin
  FMostraPreview := False;
  FMargemInferior := 0;
  FMargemSuperior := 0;
  FMargemEsquerda := 0;
  FMargemDireita := 0;
end;

constructor TDACeReportConfig.Create;
begin
  inherited Create(CSessaoDACe)
end;

destructor TDACeReportConfig.Destroy;
begin
  inherited Destroy;
end;

{ TLibDCeConfig }

function TLibDCeConfig.AtualizarArquivoConfiguracao: Boolean;
var
  Versao: String;
begin
  Versao := Ini.ReadString(CSessaoVersao, CLibDCeNome, '0');
  Result := (CompareVersions(CLibDCeVersao, Versao) > 0) or
            (inherited AtualizarArquivoConfiguracao);
end;

procedure TLibDCeConfig.INIParaClasse;
begin
  inherited INIParaClasse;

  FDCeConfig.ChaveCryptINI := ChaveCrypt;
  FDCeConfig.LerIni(Ini);
  FDACeConfig.LerIni(Ini);
end;

procedure TLibDCeConfig.ClasseParaINI;
begin
  inherited ClasseParaINI;

  FDCeConfig.ChaveCryptINI := ChaveCrypt;
  FDCeConfig.GravarIni(Ini);
  FDACeConfig.GravarIni(Ini);
end;

procedure TLibDCeConfig.ClasseParaComponentes;
begin
  FDCeConfig.ChaveCryptINI := ChaveCrypt;

  if Assigned(Owner) then
    TACBrLibDCe(Owner).DCeDM.AplicarConfiguracoes;
end;

procedure TLibDCeConfig.Travar;
begin
  if Assigned(Owner) then
    TACBrLibDCe(Owner).DCeDM.Travar;
end;

procedure TLibDCeConfig.Destravar;
begin
  if Assigned(Owner) then
  TACBrLibDCe(Owner).DCeDM.Destravar;
end;

constructor TLibDCeConfig.Create(AOwner: TObject; ANomeArquivo: String;
  AChaveCrypt: AnsiString);
begin
  inherited Create(AOwner, ANomeArquivo, AChaveCrypt);
  FDCeConfig := TConfiguracoesDCe.Create(nil);
  FDCeConfig.ChaveCryptINI := AChaveCrypt;
  FDACeConfig := TDACeReportConfig.Create;
end;

destructor TLibDCeConfig.Destroy;
begin
  FDCeConfig.Free;
  FDACeConfig.Free;
  inherited Destroy;
end;

end.

