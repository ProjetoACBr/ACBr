{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliomar Marchetti                              }
{                              Claudemir Vitor Pereira                         }
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

unit ACBrGNREGuiaClass;

interface

uses
  Forms, SysUtils, Classes, ACBrBase, pcnConversao, pgnreGNRERetorno;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrGNREGuiaClass = class( TACBrComponent )
  private
    procedure SetGNRE(const Value: TComponent);
    procedure ErroAbstract( NomeProcedure : String );
    function GetPathPDF: String;
    procedure SetPathPDF(const Value: String);
  protected
    FACBrGNRE : TComponent;
    FSistema:String;
    FUsuario:String;
    FPathPDF : String;
    FArquivoPDF : string;
    FImpressora : String;
    FMostrarPreview : Boolean;
    FMostrarStatus: Boolean;
//    FTamanhoPapel: TpcnTamanhoPapel;
    FNumCopias : Integer;
    FFax  : String;
    FSite : String;
    FEmail: String;
    FMargemInferior: Double;
    FMargemSuperior: Double;
    FMargemEsquerda: Double;
    FMargemDireita: Double;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirGuia(AGNRE: TGNRERetorno = nil); virtual;
    procedure ImprimirGuiaPDF(AGNRE: TGNRERetorno = nil); virtual;
  published
    property ACBrGNRE : TComponent  read FACBrGNRE write SetGNRE;
    property Sistema: String read FSistema write FSistema;
    property Usuario: String read FUsuario write FUsuario;
    property PathPDF: String read GetPathPDF write SetPathPDF;
    property ArquivoPDF: String read FArquivoPDF write FArquivoPDF;
    property Impressora: String read FImpressora write FImpressora;
    property MostrarPreview: Boolean read FMostrarPreview write FMostrarPreview;
    property MostrarStatus: Boolean read FMostrarStatus write FMostrarStatus;
//    property TamanhoPapel: TpcnTamanhoPapel read FTamanhoPapel write FTamanhoPapel;
    property NumCopias: Integer read FNumCopias write FNumCopias;
    property Fax  : String read FFax   write FFax;
    property Site : String read FSite  write FSite;
    property Email: String read FEmail write FEmail;
    property MargemInferior: Double read FMargemInferior write FMargemInferior;
    property MargemSuperior: Double read FMargemSuperior write FMargemSuperior;
    property MargemEsquerda: Double read FMargemEsquerda write FMargemEsquerda;
    property MargemDireita: Double read FMargemDireita write FMargemDireita;
  end;

implementation

uses
  ACBrGNRE2,
  ACBrUtil.Base, ACBrUtil.FilesIO,
  ACBrDFeUtil;

constructor TACBrGNREGuiaClass.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  FACBrGNRE   := nil;
  FSistema    := '';
  FUsuario    := '';
  FPathPDF    := '';
  FArquivoPDF := '';
  FImpressora := '';

  FMostrarPreview := True;
  FMostrarStatus  := True;
  FNumCopias      := 1;

  FFax   := '';
  FSite  := '';
  FEmail := '';

  FMargemInferior := 8;
  FMargemSuperior := 8;
  FMargemEsquerda := 6;
  FMargemDireita  := 5.1;
end;

destructor TACBrGNREGuiaClass.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrGNREGuiaClass.ImprimirGuia(AGNRE: TGNRERetorno = nil);
begin
  ErroAbstract('Imprimir');
end;

procedure TACBrGNREGuiaClass.ImprimirGuiaPDF(AGNRE: TGNRERetorno = nil);
begin
  ErroAbstract('ImprimirPDF');
end;

procedure TACBrGNREGuiaClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrGNRE <> nil) and (AComponent is TACBrGNRE) then
    FACBrGNRE := nil;
end;

procedure TACBrGNREGuiaClass.SetGNRE(const Value: TComponent);
var
  OldValue: TACBrGNRE;
begin
  if Value <> FACBrGNRE then
  begin
    if Value <> nil then
      if not (Value is TACBrGNRE) then
        raise Exception.Create('ACBrGNREGuia.GNRE deve ser do tipo TACBrGNRE');

    if Assigned(FACBrGNRE) then
      FACBrGNRE.RemoveFreeNotification(Self);

    OldValue := TACBrGNRE(FACBrGNRE);   // Usa outra variavel para evitar Loop Infinito
    FACBrGNRE := Value;                 // na remo��o da associa��o dos componentes

    if Assigned(OldValue) then
      if Assigned(OldValue.GNREGuia) then
        OldValue.GNREGuia := nil;

    if Value <> nil then
    begin
      Value.FreeNotification(Self);
      TACBrGNRE(Value).GNREGuia := Self;
    end;
  end;
end;

procedure TACBrGNREGuiaClass.ErroAbstract(NomeProcedure: String);
begin
  raise Exception.Create( NomeProcedure );
end;

function TACBrGNREGuiaClass.GetPathPDF: String;
var
  aPath: string;
begin
  if (csDesigning in ComponentState) then
  begin
    Result := FPathPDF;
    Exit;
  end;

  aPath := Trim(FPathPDF);

  if EstaVazio(aPath) then  // Se n�o pode definir o Parth, use o Path da Aplica�ao
    aPath := PathWithDelim( ExtractFilePath(ParamStr(0))) + 'pdf';

  if NaoEstaVazio(aPath) then
    if not DirectoryExists(aPath) then
      ForceDirectories(aPath);

  Result := PathWithDelim( aPath );
  {
  if EstaVazio(FPathPDF) then
    if Assigned(FACBrGNRE) then
      FPathPDF := TACBrGNRE(FACBrGNRE).Configuracoes.Arquivos.PathSalvar;

  if NaoEstaVazio(FPathPDF) then
    if not DirectoryExists(FPathPDF) then
      ForceDirectories(FPathPDF);

  Result := PathWithDelim(FPathPDF);
  }
end;


procedure TACBrGNREGuiaClass.SetPathPDF(const Value: String);
begin
  FPathPDF := PathWithDelim(Value);
end;
end.
