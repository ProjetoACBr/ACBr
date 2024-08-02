{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrDCe.DACEClass;

interface

uses
  SysUtils, Classes,
  ACBrBase, ACBrDFeReport, ACBrDCe.Classes, pcnConversao;

type
  TDadosExtrasDCe = (deValorTotal, deRelacaoDFe);
  TConjuntoDadosExtrasDCe = Set of TDadosExtrasDCe;

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrDCeDACEClass = class(TACBrDFeReport)
   private
    procedure SetACBrDCe(const Value: TComponent);
    procedure ErroAbstract(const NomeProcedure: String);

  protected
    FACBrDCe: TComponent;
    FImprimirHoraSaida: Boolean;
    FImprimirHoraSaida_Hora: String;
    FTipoDACE: TpcnTipoImpressao;
    FTamanhoPapel: TpcnTamanhoPapel;
    FProtocoloDCe: String;
    FDCeCancelada: Boolean;
    FDCeEncerrado: Boolean;
    FImprimeDadosExtras: TConjuntoDadosExtrasDCe;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetSeparadorPathPDF(const aInitialPath: String): String; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDACE(ADCe: TDCe = nil); virtual;
    procedure ImprimirDACEPDF(ADCe: TDCe = nil); virtual;
    procedure ImprimirEVENTO(ADCe: TDCe = nil); virtual;
    procedure ImprimirEVENTOPDF(ADCe: TDCe = nil); virtual;
  published
    property ACBrDCe: TComponent            read FACBrDCe                write SetACBrDCe;
    property ImprimeHoraSaida: Boolean      read FImprimirHoraSaida      write FImprimirHoraSaida;
    property ImprimeHoraSaida_Hora: String  read FImprimirHoraSaida_Hora write FImprimirHoraSaida_Hora;
    property TipoDACE: TpcnTipoImpressao    read FTipoDACE               write FTipoDACE;
    property TamanhoPapel: TpcnTamanhoPapel read FTamanhoPapel           write FTamanhoPapel;
    property Protocolo: String              read FProtocoloDCe           write FProtocoloDCe;
    property Cancelada: Boolean             read FDCeCancelada           write FDCeCancelada;
    property Encerrado: Boolean             read FDCeEncerrado           write FDCeEncerrado;

    property ImprimeDadosExtras: TConjuntoDadosExtrasDCe read FImprimeDadosExtras write FImprimeDadosExtras;
  end;

implementation

uses
  ACBrDCe;

constructor TACBrDCeDACEClass.Create(AOwner: TComponent);
begin
  inherited create(AOwner);

  FACBrDCe := nil;
  FImprimirHoraSaida := False;
  FImprimirHoraSaida_Hora := '';
  FProtocoloDCe := '';
  FDCeCancelada := False;
  FDCeEncerrado := False;
  FImprimeDadosExtras := [deValorTotal, deRelacaoDFe];
end;

destructor TACBrDCeDACEClass.Destroy;
begin

  inherited Destroy;
end;

procedure TACBrDCeDACEClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrDCe <> nil) and (AComponent is TACBrDCe) then
     FACBrDCe := nil;
end;

procedure TACBrDCeDACEClass.SetACBrDCe(const Value: TComponent);
var
  OldValue: TACBrDCe;
begin
  if Value <> FACBrDCe then
  begin
    if Value <> nil then
      if not (Value is TACBrDCe) then
        raise Exception.Create('DACE deve ser do tipo TACBrDCe');

    if Assigned(FACBrDCe) then
      FACBrDCe.RemoveFreeNotification(Self);

    OldValue := TACBrDCe(FACBrDCe);   // Usa outra variavel para evitar Loop Infinito
    FACBrDCe := Value;                 // na remo��o da associa��o dos componentes

    if Assigned(OldValue) then
      if Assigned(OldValue.DACE) then
        OldValue.DACE := nil;

    if Value <> nil then
    begin
      Value.FreeNotification(self);
      TACBrDCe(Value).DACE := self;
    end;
  end;
end;

procedure TACBrDCeDACEClass.ErroAbstract(const NomeProcedure: String);
begin
  raise Exception.Create(NomeProcedure);
end;

procedure TACBrDCeDACEClass.ImprimirDACE(ADCe: TDCe = nil);
begin
  ErroAbstract('ImprimirDACE');
end;

procedure TACBrDCeDACEClass.ImprimirDACEPDF(ADCe: TDCe = nil);
begin
  ErroAbstract('ImprimirDACEPDF');
end;

procedure TACBrDCeDACEClass.ImprimirEVENTO(ADCe: TDCe);
begin
  ErroAbstract('ImprimirEVENTO');
end;

procedure TACBrDCeDACEClass.ImprimirEVENTOPDF(ADCe: TDCe);
begin
  ErroAbstract('ImprimirEVENTOPDF');
end;

function TACBrDCeDACEClass.GetSeparadorPathPDF(const aInitialPath: String): String;
var
  dhEmissao: TDateTime;
  DescricaoModelo: String;
  ADCe: TDCe;
begin
  Result := aInitialPath;

  if Assigned(ACBrDCe) then  // Se tem o componente ACBrDCe
  begin
    if TACBrDCe(ACBrDCe).Declaracoes.Count > 0 then  // Se tem alguma Declara��o carregada
    begin
     ADCe := TACBrDCe(ACBrDCe).Declaracoes.Items[0].DCe;

     if TACBrDCe(ACBrDCe).Configuracoes.Arquivos.EmissaoPathDCe then
       dhEmissao := ADCe.Ide.dhEmi
     else
       dhEmissao := Now;

     DescricaoModelo := 'DCe';

     Result := TACBrDCe(FACBrDCe).Configuracoes.Arquivos.GetPath(
                       Result,
                       DescricaoModelo,
                       ADCe.Emit.CNPJCPF,
                       '',
                       dhEmissao,
                       DescricaoModelo);
    end;
  end;
end;

end.
