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

{$I ACBr.inc}

unit ACBrMDFeDAMDFeClass;

interface

uses
  SysUtils, Classes,
  ACBrBase, ACBrDFeReport, pmdfeMDFe, pcnConversao;

type
  TDadosExtrasMDFe = (deValorTotal, deRelacaoDFe);
  TConjuntoDadosExtrasMDFe = Set of TDadosExtrasMDFe;

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}

  { TACBrMDFeDAMDFeClass }

  TACBrMDFeDAMDFeClass = class(TACBrDFeReport)
   private
    procedure SetACBrMDFe(const Value: TComponent);
    procedure ErroAbstract(const NomeProcedure: String);

  protected
    FACBrMDFe: TComponent;
    FImprimirHoraSaida: Boolean;
    FImprimirHoraSaida_Hora: String;
    FTipoDAMDFe: TpcnTipoImpressao;
    FTamanhoPapel: TpcnTamanhoPapel;
    FProtocoloMDFe: String;
    FMDFeCancelada: Boolean;
    FMDFeEncerrado: Boolean;
    FImprimeDadosExtras: TConjuntoDadosExtrasMDFe;
    FExibirMunicipioDescarregamento: Boolean;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetSeparadorPathPDF(const aInitialPath: String): String; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDAMDFe(AMDFe: TMDFe = nil); virtual;

    procedure ImprimirDAMDFePDF(AMDFe: TMDFe = nil); overload; virtual;
    procedure ImprimirDAMDFePDF(AStream: TStream; AMDFe: TMDFe = nil); overload; virtual;

    procedure ImprimirEVENTO(AMDFe: TMDFe = nil); virtual;

    procedure ImprimirEVENTOPDF(AMDFe: TMDFe = nil); overload; virtual;
    procedure ImprimirEVENTOPDF(AStream: TStream; AMDFe: TMDFe = nil); overload; virtual;

    function CaractereQuebraDeLinha: String;
  published
    property ACBrMDFe: TComponent           read FACBrMDFe               write SetACBrMDFe;
    property ImprimeHoraSaida: Boolean      read FImprimirHoraSaida      write FImprimirHoraSaida;
    property ImprimeHoraSaida_Hora: String  read FImprimirHoraSaida_Hora write FImprimirHoraSaida_Hora;
    property TipoDAMDFe: TpcnTipoImpressao  read FTipoDAMDFe             write FTipoDAMDFe;
    property TamanhoPapel: TpcnTamanhoPapel read FTamanhoPapel           write FTamanhoPapel;
    property Protocolo: String              read FProtocoloMDFe          write FProtocoloMDFe;
    property Cancelada: Boolean             read FMDFeCancelada          write FMDFeCancelada;
    property Encerrado: Boolean             read FMDFeEncerrado          write FMDFeEncerrado;

    property ImprimeDadosExtras: TConjuntoDadosExtrasMDFe read FImprimeDadosExtras write FImprimeDadosExtras;
    property ExibirMunicipioDescarregamento: Boolean read FExibirMunicipioDescarregamento write FExibirMunicipioDescarregamento;
  end;

implementation

uses
  ACBrMDFe;

constructor TACBrMDFeDAMDFeClass.Create(AOwner: TComponent);
begin
  inherited create(AOwner);

  FACBrMDFe := nil;
  FImprimirHoraSaida := False;
  FImprimirHoraSaida_Hora := '';
  FProtocoloMDFe := '';
  FMDFeCancelada := False;
  FMDFeEncerrado := False;
  FImprimeDadosExtras := [deValorTotal, deRelacaoDFe];
  FExibirMunicipioDescarregamento := False;
end;

destructor TACBrMDFeDAMDFeClass.Destroy;
begin

  inherited Destroy;
end;

procedure TACBrMDFeDAMDFeClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrMDFe <> nil) and (AComponent is TACBrMDFe) then
     FACBrMDFe := nil;
end;

procedure TACBrMDFeDAMDFeClass.SetACBrMDFe(const Value: TComponent);
var
  OldValue: TACBrMDFe;
begin
  if Value <> FACBrMDFe then
  begin
     if Value <> nil then
        if not (Value is TACBrMDFe) then
           raise Exception.Create('DAMDFe deve ser do tipo TACBrMDFe');

     if Assigned(FACBrMDFe) then
        FACBrMDFe.RemoveFreeNotification(Self);

     OldValue := TACBrMDFe(FACBrMDFe);   // Usa outra variavel para evitar Loop Infinito
     FACBrMDFe := Value;                 // na remo��o da associa��o dos componentes

     if Assigned(OldValue) then
        if Assigned(OldValue.DAMDFe) then
           OldValue.DAMDFe := nil;

     if Value <> nil then
     begin
        Value.FreeNotification(self);
        TACBrMDFe(Value).DAMDFe := self;
     end;
  end;
end;

procedure TACBrMDFeDAMDFeClass.ErroAbstract(const NomeProcedure: String);
begin
  raise Exception.Create(NomeProcedure);
end;

procedure TACBrMDFeDAMDFeClass.ImprimirDAMDFe(AMDFe: TMDFe = nil);
begin
  ErroAbstract('ImprimirDAMDFe');
end;

procedure TACBrMDFeDAMDFeClass.ImprimirDAMDFePDF(AMDFe: TMDFe = nil);
begin
  ErroAbstract('ImprimirDAMDFePDF');
end;

procedure TACBrMDFeDAMDFeClass.ImprimirDAMDFePDF(AStream: TStream;
  AMDFe: TMDFe);
begin
  ErroAbstract('ImprimirDAMDFePDF');
end;

procedure TACBrMDFeDAMDFeClass.ImprimirEVENTO(AMDFe: TMDFe);
begin
  ErroAbstract('ImprimirEVENTO');
end;

procedure TACBrMDFeDAMDFeClass.ImprimirEVENTOPDF(AMDFe: TMDFe);
begin
  ErroAbstract('ImprimirEVENTOPDF');
end;

procedure TACBrMDFeDAMDFeClass.ImprimirEVENTOPDF(AStream: TStream; AMDFe: TMDFe);
begin
  ErroAbstract('ImprimirEVENTOPDF');
end;

function TACBrMDFeDAMDFeClass.GetSeparadorPathPDF(const aInitialPath: String): String;
var
  dhEmissao: TDateTime;
  DescricaoModelo: String;
  AMDFe: TMDFe;
begin
  Result := aInitialPath;

  if Assigned(ACBrMDFe) then  // Se tem o componente ACBrMDFe
  begin
     if TACBrMDFe(ACBrMDFe).Manifestos.Count > 0 then  // Se tem algum Manifesto carregado
     begin
       AMDFe := TACBrMDFe(ACBrMDFe).Manifestos.Items[0].MDFe;
       if TACBrMDFe(ACBrMDFe).Configuracoes.Arquivos.EmissaoPathMDFe then
         dhEmissao := AMDFe.Ide.dhEmi
       else
         dhEmissao := Now;

       DescricaoModelo := 'MDFe';

       Result := TACBrMDFe(FACBrMDFe).Configuracoes.Arquivos.GetPath(
                         Result,
                         DescricaoModelo,
                         AMDFe.Emit.CNPJCPF,
                         AMDFe.emit.IE,
                         dhEmissao,
                         DescricaoModelo);
     end;
  end;
end;

function TACBrMDFeDAMDFeClass.CaractereQuebraDeLinha: String;
begin
  Result := '|';
  if Assigned(FACBrMDFe) and (FACBrMDFe is TACBrMDFe) then
    Result := TACBrMDFe(FACBrMDFe).Configuracoes.WebServices.QuebradeLinha;
end;

end.
