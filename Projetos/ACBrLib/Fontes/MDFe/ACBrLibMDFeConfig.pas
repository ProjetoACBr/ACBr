﻿{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
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

unit ACBrLibMDFeConfig;

interface

uses
  Classes, SysUtils, IniFiles, pcnConversao,
  ACBrMDFeConfiguracoes,
  {$IfNDef NOREPORT}
  ACBrMDFeDAMDFeRLClass,
  {$EndIf}
  ACBrMDFeDAMDFeFPDF, ACBrDFeReport,
  DFeReportConfig, ACBrLibComum, ACBrLibConfig;

type

  { TDAMDFeConfig }
  TDAMDFeConfig = class(TDFeReportConfig<TACBrDFeReport>)
  private
    FImprimeHoraSaida: Boolean;
    FImprimeHoraSaida_Hora: String;
    FTipoDAMDFe: TpcnTipoImpressao;
    FTamanhoPapel: TpcnTamanhoPapel;
    FProtocolo: String;
    FCancelada: Boolean;
    FEncerrado: Boolean;
    FExibirMunicipioDescarregamento: Boolean;

  protected
    procedure DefinirValoresPadroesChild; override;
    procedure LerIniChild(const AIni: TCustomIniFile); override;
    procedure GravarIniChild(const AIni: TCustomIniFile); override;
    procedure ApplyChild(const DFeReport: TACBrDFeReport; const Lib: TACBrLib); override;

  public
    constructor Create;

    property ImprimeHoraSaida: Boolean read FImprimeHoraSaida write FImprimeHoraSaida;
    property ImprimeHoraSaida_Hora: String read FImprimeHoraSaida_Hora write FImprimeHoraSaida_Hora;
    property TipoDAMDFe: TpcnTipoImpressao read FTipoDAMDFe write FTipoDAMDFe;
    property TamanhoPapel: TpcnTamanhoPapel read FTamanhoPapel write FTamanhoPapel;
    property Protocolo: String read FProtocolo write FProtocolo;
    property Cancelada: Boolean read FCancelada write FCancelada;
    property Encerrado: Boolean read FEncerrado write FEncerrado;
    property ExibirMunicipioDescarregamento: Boolean read FExibirMunicipioDescarregamento write FExibirMunicipioDescarregamento;
  end;

  { TLibMDFeConfig }
  TLibMDFeConfig = class(TLibConfig)
  private
    FDAMDFeConfig: TDAMDFeConfig;
    FMDFeConfig: TConfiguracoesMDFe;

  protected
    procedure INIParaClasse; override;
    procedure ClasseParaINI; override;
    procedure ClasseParaComponentes; override;

    procedure Travar; override;
    procedure Destravar; override;

  public
    constructor Create(AOwner: TObject; ANomeArquivo: String = ''; AChaveCrypt: AnsiString = ''); override;
    destructor Destroy; override;

    property MDFe: TConfiguracoesMDFe read FMDFeConfig;
    property DAMDFe: TDAMDFeConfig read FDAMDFeConfig;
  end;

implementation

uses
  blcksock, pcnAuxiliar, pmdfeConversaoMDFe,
  ACBrLibMDFeBase, ACBrLibMDFeConsts, ACBrLibConsts,
  ACBrUtil.FilesIO, ACBrUtil.Strings;

{ TDAMDFeConfig }
constructor TDAMDFeConfig.Create;
begin
  inherited Create(CSessaoDAMDFe);
end;

procedure TDAMDFeConfig.DefinirValoresPadroesChild;
begin
  FImprimeHoraSaida := False;
  FImprimeHoraSaida_Hora := '';
  FProtocolo := '';
  FCancelada := False;
  FEncerrado := False;
  FTipoDAMDFe := tiRetrato;
  FTamanhoPapel := tpA4;
  FExibirMunicipioDescarregamento := False;
end;

procedure TDAMDFeConfig.LerIniChild(const AIni: TCustomIniFile);
begin
  FImprimeHoraSaida := AIni.ReadBool(FSessao, CChaveImprimeHoraSaida, FImprimeHoraSaida);
  FImprimeHoraSaida_Hora := AIni.ReadString(FSessao, CChaveImprimeHoraSaida_Hora, FImprimeHoraSaida_Hora);
  FTipoDAMDFe := TpcnTipoImpressao(AIni.ReadInteger(FSessao, CChaveTipoDAMDFe, Integer(FTipoDAMDFe)));
  FTamanhoPapel := TpcnTamanhoPapel(AIni.ReadInteger(FSessao, CChaveTamanhoPapel, Integer(FTamanhoPapel)));
  FProtocolo := AIni.ReadString(FSessao, CChaveProtocolo, FProtocolo);
  FCancelada := AIni.ReadBool(FSessao, CChaveCancelada, FCancelada);
  FEncerrado := AIni.ReadBool(FSessao, CChaveEncerrado, FEncerrado);
  FExibirMunicipioDescarregamento := AIni.ReadBool(FSessao, CChaveExibirMunicipioDescar, ExibirMunicipioDescarregamento);
end;

procedure TDAMDFeConfig.GravarIniChild(const AIni: TCustomIniFile);
begin
  AIni.WriteBool(FSessao, CChaveImprimeHoraSaida, FImprimeHoraSaida);
  AIni.WriteString(FSessao, CChaveImprimeHoraSaida_Hora, FImprimeHoraSaida_Hora);
  AIni.WriteInteger(FSessao, CChaveTipoDAMDFe, Integer(FTipoDAMDFe));
  AIni.WriteInteger(FSessao, CChaveTamanhoPapel, Integer(FTamanhoPapel));
  AIni.WriteString(FSessao, CChaveProtocolo, FProtocolo);
  AIni.WriteBool(FSessao, CChaveCancelada, FCancelada);
  AIni.WriteBool(FSessao, CChaveEncerrado, FEncerrado);
  AIni.WriteBool(FSessao, CChaveExibirMunicipioDescar, FExibirMunicipioDescarregamento);
end;

procedure TDAMDFeConfig.ApplyChild(const DFeReport: TACBrDFeReport; const Lib: TACBrLib);
var
   {$ifNDef NOREPORT}
     LDAMDFe: TACBrMDFeDAMDFeRL;
   {$Else}
     LDAMDFe: TACBrMDFeDAMDFeFPDF;
   {$EndIf}
begin
  {$ifNDef NOREPORT}
     LDAMDFe := TACBrMDFeDAMDFeRL(DFeReport);
   {$Else}
     LDAMDFe := TACBrMDFeDAMDFeFPDF(DFeReport);
   {$EndIf}
   with LDAMDFe do
   begin
     ImprimeHoraSaida := FImprimeHoraSaida;
     ImprimeHoraSaida_Hora := FImprimeHoraSaida_Hora;
     TipoDAMDFe := FTipoDAMDFe;
     TamanhoPapel := FTamanhoPapel;
     Protocolo := FProtocolo;
     Cancelada := FCancelada;
     Encerrado := FEncerrado;
     ExibirMunicipioDescarregamento := FExibirMunicipioDescarregamento;
   end;
end;

{ TLibMDFeConfig }
constructor TLibMDFeConfig.Create(AOwner: TObject; ANomeArquivo: String; AChaveCrypt: AnsiString);
begin
  inherited Create(AOwner, ANomeArquivo, AChaveCrypt);

  FMDFeConfig := TConfiguracoesMDFe.Create(nil);
  FMDFeConfig.ChaveCryptINI := AChaveCrypt;

  FDAMDFeConfig := TDAMDFeConfig.Create;
end;

destructor TLibMDFeConfig.Destroy;
begin
  FMDFeConfig.Destroy;
  FDAMDFeConfig.Free;

  inherited Destroy;
end;

procedure TLibMDFeConfig.INIParaClasse;
begin
  inherited INIParaClasse;

  FMDFeConfig.ChaveCryptINI := ChaveCrypt;

  FMDFeConfig.LerIni(Ini);
  FDAMDFeConfig.LerIni(Ini);
end;

procedure TLibMDFeConfig.ClasseParaINI;
begin
  inherited ClasseParaINI;

  FMDFeConfig.ChaveCryptINI := ChaveCrypt;

  FMDFeConfig.GravarIni(Ini);
  FDAMDFeConfig.GravarIni(Ini);
end;

procedure TLibMDFeConfig.ClasseParaComponentes;
begin
  FMDFeConfig.ChaveCryptINI := ChaveCrypt;

  if Assigned(Owner) then
    TACBrLibMDFe(Owner).MDFeDM.AplicarConfiguracoes;
end;

procedure TLibMDFeConfig.Travar;
begin
  if Assigned(Owner) then
  begin
    with TACBrLibMDFe(Owner) do
      MDFeDM.Travar;
  end;
end;

procedure TLibMDFeConfig.Destravar;
begin
  if Assigned(Owner) then
  begin
    with TACBrLibMDFe(Owner) do
      MDFeDM.Destravar;
  end;
end;

end.

