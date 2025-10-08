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

unit ACBrLibNF3eConfig;

interface

uses
  Classes, SysUtils, IniFiles, synachar,
  ACBrLibComum, ACBrLibConfig, ACBrNF3e, ACBrNF3e.DANF3ERLClass,
  ACBrNF3eConversao, ACBrNF3eConfiguracoes, ACBrXmlBase, DFeReportConfig, ACBrDFeReport;

type

  { TDANF3eReportConfig }
  TDANF3eReportConfig = class(TDFeReportConfig<TACBrDFeReport>)
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

  { TLibNF3eConfig }
  TLibNF3eConfig = class(TLibConfig)
    private
      FNF3eConfig: TConfiguracoesNF3e;
      FDANF3eConfig: TDANF3eReportConfig;

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

      property NF3eConfig: TConfiguracoesNF3e read FNF3eConfig;
      property DANF3eConfig: TDANF3eReportConfig read FDANF3eConfig;
  end;

implementation

Uses
  ACBrLibNF3eBase, ACBrLibNF3eConsts, ACBrLibConsts, ACBrUtil.FilesIO;

{ TDANF3eReportConfig }

procedure TDANF3eReportConfig.LerIniChild(const AIni: TCustomIniFile);
begin
  FMostraPreview := AIni.ReadBool(CSessaoDANF3e, CChaveMostraPreview, FMostraPreview);
  FMargemInferior := AIni.ReadFloat(CSessaoDANF3e, CChaveMargemInferior, FMargemInferior);
  FMargemSuperior := AIni.ReadFloat(CSessaoDANF3e, CChaveMargemSuperior, FMargemSuperior);
  FMargemEsquerda := AIni.ReadFloat(CSessaoDANF3e, CChaveMargemEsquerda, FMargemEsquerda);
  FMargemDireita := AIni.ReadFloat(CSessaoDANF3e, CChaveMargemDireita, FMargemDireita);
end;

procedure TDANF3eReportConfig.GravarIniChild(const AIni: TCustomIniFile);
begin
  AIni.WriteBool(CSessaoDANF3e, CChaveMostraPreview, FMostraPreview);
  AIni.WriteFloat(CSessaoDANF3e, CChaveMargemInferior, FMargemInferior);
  AIni.WriteFloat(CSessaoDANF3e, CChaveMargemSuperior, FMargemSuperior);
  AIni.WriteFloat(CSessaoDANF3e, CChaveMargemEsquerda, FMargemEsquerda);
  AIni.WriteFloat(CSessaoDANF3e, CChaveMargemDireita, FMargemDireita);
end;

procedure TDANF3eReportConfig.ApplyChild(const DFeReport: TACBrDFeReport;
  const Lib: TACBrLib);
var
  LDANF3e: TACBrNF3eDANF3eRL;
begin
  LDANF3e := TACBrNF3eDANF3eRL(DFeReport);
  with LDANF3e do
  begin
    MostraPreview := FMostraPreview;
    MargemInferior := FMargemInferior;
    MargemSuperior := FMargemSuperior;
    MargemEsquerda := FMargemEsquerda;
    MargemDireita  := FMargemDireita;
  end;
end;

procedure TDANF3eReportConfig.DefinirValoresPadroesChild;
begin
  FMostraPreview := False;
  FMargemInferior := 0;
  FMargemSuperior := 0;
  FMargemEsquerda := 0;
  FMargemDireita := 0;
end;

constructor TDANF3eReportConfig.Create;
begin
  inherited Create(CSessaoDANF3e);
end;

destructor TDANF3eReportConfig.Destroy;
begin
  inherited Destroy;
end;

{ TLibNF3eConfig }

function TLibNF3eConfig.AtualizarArquivoConfiguracao: Boolean;
var
  Versao: String;
begin
  Versao := Ini.ReadString(CSessaoVersao, CLibNF3eNome, '0');
  Result := (CompareVersions(CLibNF3eVersao, Versao) > 0) or
            (inherited AtualizarArquivoConfiguracao);
end;

procedure TLibNF3eConfig.INIParaClasse;
begin
  inherited INIParaClasse;

  FNF3eConfig.ChaveCryptINI := ChaveCrypt;
  FNF3eConfig.LerIni(Ini);
  FDANF3eConfig.LerIni(Ini);
end;

procedure TLibNF3eConfig.ClasseParaINI;
begin
  inherited ClasseParaINI;

  FNF3eConfig.ChaveCryptINI := ChaveCrypt;
  FNF3eConfig.GravarIni(Ini);
  FDANF3eConfig.GravarIni(Ini);
end;

procedure TLibNF3eConfig.ClasseParaComponentes;
begin
  FNF3eConfig.ChaveCryptINI := ChaveCrypt;

  if Assigned(Owner) then
    TACBrLibNF3e(Owner).NF3eDM.AplicarConfiguracoes;
end;

procedure TLibNF3eConfig.Travar;
begin
  if Assigned(Owner) then
    TACBrLibNF3e(Owner).NF3eDM.Travar;
end;

procedure TLibNF3eConfig.Destravar;
begin
  if Assigned(Owner) then
    TACBrLibNF3e(Owner).NF3eDM.Destravar;
end;

constructor TLibNF3eConfig.Create(AOwner: TObject; ANomeArquivo: String;
  AChaveCrypt: AnsiString);
begin
  inherited Create(AOwner, ANomeArquivo, AChaveCrypt);
  FNF3eConfig := TConfiguracoesNF3e.Create(nil);
  FNF3eConfig.ChaveCryptINI := AChaveCrypt;
  FDANF3eConfig := TDANF3eReportConfig.Create;
end;

destructor TLibNF3eConfig.Destroy;
begin
  FNF3eConfig.Free;
  FDANF3eConfig.Free;
  inherited Destroy;
end;

end.

