{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit ACBrNF3eDANF3eClass;

interface

uses
  SysUtils, Classes, ACBrBase,
  ACBrNF3eClass, pcnConversao, ACBrDFeReport;

type

  { TACBrNF3eDANF3eClass }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNF3eDANF3eClass = class( TACBrDFeReport )
  private
    procedure SetACBrNF3e(const Value: TComponent);
    procedure ErroAbstract(const NomeProcedure: String);

  protected
   function GetSeparadorPathPDF(const aInitialPath: String): String; override;

  protected
    FACBrNF3e: TComponent;
    FTipoDANF3e: TpcnTipoImpressao;
    FProtocolo: String;
    FCancelada: Boolean;
    FViaConsumidor: Boolean;
    FImprimeNomeFantasia: Boolean;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDANF3e(NF3e: TNF3e = nil); virtual;
    procedure ImprimirDANF3eCancelado(NF3e: TNF3e = nil); virtual;
    procedure ImprimirDANF3eResumido(NF3e: TNF3e = nil); virtual;
    procedure ImprimirDANF3ePDF(NF3e: TNF3e = nil); virtual;
    procedure ImprimirDANF3eResumidoPDF(NF3e: TNF3e = nil); virtual;
    procedure ImprimirEVENTO(NF3e: TNF3e = nil); virtual;
    procedure ImprimirEVENTOPDF(NF3e: TNF3e = nil); virtual;

    function CaractereQuebraDeLinha: String;

  published
    property ACBrNF3e: TComponent          read FACBrNF3e            write SetACBrNF3e;
    property TipoDANF3e: TpcnTipoImpressao read FTipoDANF3e          write FTipoDANF3e;
    property Protocolo: String             read FProtocolo           write FProtocolo;
    property Cancelada: Boolean            read FCancelada           write FCancelada;
    property ViaConsumidor: Boolean        read FViaConsumidor       write FViaConsumidor;
    property ImprimeNomeFantasia: Boolean  read FImprimeNomeFantasia write FImprimeNomeFantasia;
  end;

implementation

uses
  ACBrNF3e;

{ TACBrNF3eDANF3eClass }

constructor TACBrNF3eDANF3eClass.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  FACBrNF3e    := nil;

  FProtocolo    := '';
  FCancelada := False;
  FViaConsumidor := True;
  FImprimeNomeFantasia := False;
end;

destructor TACBrNF3eDANF3eClass.Destroy;
begin

  inherited Destroy;
end;

procedure TACBrNF3eDANF3eClass.ImprimirDANF3e(NF3e : TNF3e = nil);
begin
  ErroAbstract('ImprimirDANF3e');
end;

procedure TACBrNF3eDANF3eClass.ImprimirDANF3eCancelado(NF3e: TNF3e);
begin
  ErroAbstract('ImprimirDANF3eCancelado');
end;

procedure TACBrNF3eDANF3eClass.ImprimirDANF3eResumido(NF3e : TNF3e = nil);
begin
  ErroAbstract('ImprimirDANF3eResumido');
end;

procedure TACBrNF3eDANF3eClass.ImprimirDANF3ePDF(NF3e : TNF3e = nil);
begin
  ErroAbstract('ImprimirDANF3ePDF');
end;

procedure TACBrNF3eDANF3eClass.ImprimirDANF3eResumidoPDF(NF3e: TNF3e);
begin
  ErroAbstract('ImprimirDANF3eResumidoPDF');
end;

procedure TACBrNF3eDANF3eClass.ImprimirEVENTO(NF3e: TNF3e);
begin
  ErroAbstract('ImprimirEVENTO');
end;

procedure TACBrNF3eDANF3eClass.ImprimirEVENTOPDF(NF3e: TNF3e);
begin
  ErroAbstract('ImprimirEVENTOPDF');
end;

procedure TACBrNF3eDANF3eClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrNF3e <> nil) and (AComponent is TACBrNF3e) then
    FACBrNF3e := nil;
end;

procedure TACBrNF3eDANF3eClass.SetACBrNF3e(const Value: TComponent);
  Var OldValue : TACBrNF3e;
begin
  if Value <> FACBrNF3e then
  begin
    if Value <> nil then
      if not (Value is TACBrNF3e) then
        raise EACBrNF3eException.Create('ACBrDANF3e.NF3e deve ser do tipo TACBrNF3e');

    if Assigned(FACBrNF3e) then
      FACBrNF3e.RemoveFreeNotification(Self);

    OldValue := TACBrNF3e(FACBrNF3e);   // Usa outra variavel para evitar Loop Infinito
    FACBrNF3e := Value;                 // na remo��o da associa��o dos componentes

    if Assigned(OldValue) then
      if Assigned(OldValue.DANF3e) then
        OldValue.DANF3e := nil;

    if Value <> nil then
    begin
      Value.FreeNotification(self);
      TACBrNF3e(Value).DANF3e := self;
    end;
  end;
end;

procedure TACBrNF3eDANF3eClass.ErroAbstract(const NomeProcedure: String);
begin
  raise EACBrNF3eException.Create(NomeProcedure + ' n�o implementado em: ' + ClassName);
end;

function TACBrNF3eDANF3eClass.GetSeparadorPathPDF(const aInitialPath: String): String;
var
  dhEmissao: TDateTime;
  DescricaoModelo: String;
  ANF3e: TNF3e;
begin
  Result := aInitialPath;
  
  if Assigned(ACBrNF3e) then  // Se tem o componente ACBrNF3e
  begin
    if TACBrNF3e(ACBrNF3e).NotasFiscais.Count > 0 then  // Se tem alguma Nota carregada
    begin
      ANF3e := TACBrNF3e(ACBrNF3e).NotasFiscais.Items[0].NF3e;
      if TACBrNF3e(ACBrNF3e).Configuracoes.Arquivos.EmissaoPathNF3e then
        dhEmissao := ANF3e.Ide.dhEmi
      else
        dhEmissao := Now;

      DescricaoModelo := 'NF3e';

      Result := TACBrNF3e(FACBrNF3e).Configuracoes.Arquivos.GetPath(
                         Result,
                         DescricaoModelo,
                         ANF3e.Emit.CNPJ,
                         ANF3e.Emit.IE,
                         dhEmissao,
                         DescricaoModelo);
    end;
  end;
end;

function TACBrNF3eDANF3eClass.CaractereQuebraDeLinha: String;
begin
  Result := '|';
  if Assigned(FACBrNF3e) and (FACBrNF3e is TACBrNF3e) then
    Result := TACBrNF3e(FACBrNF3e).Configuracoes.WebServices.QuebradeLinha;
end;

end.
