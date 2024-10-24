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

unit ACBrNFComDANFComClass;

interface

uses
  SysUtils, Classes, ACBrBase,
  ACBrNFComClass,
  pcnConversao,
  ACBrDFeReport;

type

  { TACBrNFComDANFComClass }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNFComDANFComClass = class( TACBrDFeReport )
  private
    procedure SetNFCom(const Value: TComponent);
    procedure ErroAbstract(const NomeProcedure: string);

  protected
   function GetSeparadorPathPDF(const aInitialPath: string): string; override;

  protected
    FACBrNFCom: TComponent;
    FTipoDANFCom: TpcnTipoImpressao;
    FProtocolo: string;
    FCancelada: Boolean;
    FViaConsumidor: Boolean;
    FImprimeNomeFantasia: Boolean;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDANFCom(NFCom: TNFCom = nil); virtual;
    procedure ImprimirDANFComCancelado(NFCom: TNFCom = nil); virtual;
    procedure ImprimirDANFComResumido(NFCom: TNFCom = nil); virtual;
    procedure ImprimirDANFComPDF(NFCom: TNFCom = nil); overload; virtual;
    procedure ImprimirDANFComPDF(AStream: TStream; NFCom: TNFCom = nil); overload; virtual;

    procedure ImprimirDANFComResumidoPDF(NFCom: TNFCom = nil); virtual;
    procedure ImprimirEVENTO(NFCom: TNFCom = nil); virtual;
    procedure ImprimirEVENTOPDF(NFCom: TNFCom = nil); overload; virtual;
    procedure ImprimirEVENTOPDF(AStream: TStream; NFCom: TNFCom = nil); overload; virtual;

  published
    property ACBrNFCom: TComponent read FACBrNFCom write SetNFCom;
    property TipoDANFCom: TpcnTipoImpressao read FTipoDANFCom write FTipoDANFCom;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Cancelada: Boolean read FCancelada write FCancelada;
    property ViaConsumidor: Boolean read FViaConsumidor write FViaConsumidor;
    property ImprimeNomeFantasia: Boolean  read FImprimeNomeFantasia write FImprimeNomeFantasia;
  end;

implementation

uses
  ACBrNFCom;

{ TACBrNFComDANFComClass }

constructor TACBrNFComDANFComClass.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  FACBrNFCom := nil;

  FProtocolo := '';
  FCancelada := False;
  FViaConsumidor := True;
  FImprimeNomeFantasia := False;
end;

destructor TACBrNFComDANFComClass.Destroy;
begin

  inherited Destroy;
end;

procedure TACBrNFComDANFComClass.ImprimirDANFCom(NFCom : TNFCom = nil);
begin
  ErroAbstract('ImprimirDANFCom');
end;

procedure TACBrNFComDANFComClass.ImprimirDANFComCancelado(NFCom: TNFCom);
begin
  ErroAbstract('ImprimirDANFComCancelado');
end;

procedure TACBrNFComDANFComClass.ImprimirDANFComResumido(NFCom : TNFCom = nil);
begin
  ErroAbstract('ImprimirDANFComResumido');
end;

procedure TACBrNFComDANFComClass.ImprimirDANFComPDF(NFCom : TNFCom = nil);
begin
  ErroAbstract('ImprimirDANFComPDF');
end;

procedure TACBrNFComDANFComClass.ImprimirDANFComPDF(AStream: TStream;
  NFCom: TNFCom);
begin
  ErroAbstract('ImprimirDANFComPDF');
end;

procedure TACBrNFComDANFComClass.ImprimirDANFComResumidoPDF(NFCom: TNFCom);
begin
  ErroAbstract('ImprimirDANFComResumidoPDF');
end;

procedure TACBrNFComDANFComClass.ImprimirEVENTO(NFCom: TNFCom);
begin
  ErroAbstract('ImprimirEVENTO');
end;

procedure TACBrNFComDANFComClass.ImprimirEVENTOPDF(NFCom: TNFCom);
begin
  ErroAbstract('ImprimirEVENTOPDF');
end;

procedure TACBrNFComDANFComClass.ImprimirEVENTOPDF(AStream: TStream;
  NFCom: TNFCom);
begin
  ErroAbstract('ImprimirEVENTOPDF');
end;

procedure TACBrNFComDANFComClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrNFCom <> nil) and (AComponent is TACBrNFCom) then
    FACBrNFCom := nil;
end;

procedure TACBrNFComDANFComClass.SetNFCom(const Value: TComponent);
  Var OldValue : TACBrNFCom;
begin
  if Value <> FACBrNFCom then
  begin
    if Value <> nil then
      if not (Value is TACBrNFCom) then
        raise EACBrNFComException.Create('ACBrDANFCom.NFCom deve ser do tipo TACBrNFCom');

    if Assigned(FACBrNFCom) then
      FACBrNFCom.RemoveFreeNotification(Self);

    OldValue := TACBrNFCom(FACBrNFCom); // Usa outra variavel para evitar Loop Infinito
    FACBrNFCom := Value;                // na remo��o da associa��o dos componentes

    if Assigned(OldValue) then
      if Assigned(OldValue.DANFCom) then
        OldValue.DANFCom := nil;

    if Value <> nil then
    begin
      Value.FreeNotification(self);
      TACBrNFCom(Value).DANFCom := self;
    end;
  end;
end;

procedure TACBrNFComDANFComClass.ErroAbstract(const NomeProcedure: string);
begin
  raise EACBrNFComException.Create(NomeProcedure + ' n�o implementado em: ' + ClassName);
end;

function TACBrNFComDANFComClass.GetSeparadorPathPDF(const aInitialPath: string): string;
var
  dhEmissao: TDateTime;
  DescricaoModelo: string;
  ANFCom: TNFCom;
begin
  Result := aInitialPath;
  
  if Assigned(ACBrNFCom) then  // Se tem o componente ACBrNFCom
  begin
    if TACBrNFCom(ACBrNFCom).NotasFiscais.Count > 0 then  // Se tem alguma Nota carregada
    begin
      ANFCom := TACBrNFCom(ACBrNFCom).NotasFiscais.Items[0].NFCom;

      if TACBrNFCom(ACBrNFCom).Configuracoes.Arquivos.EmissaoPathNFCom then
        dhEmissao := ANFCom.Ide.dhEmi
      else
        dhEmissao := Now;

      DescricaoModelo := 'NFCom';

      Result := TACBrNFCom(FACBrNFCom).Configuracoes.Arquivos.GetPath(
                           Result,
                           DescricaoModelo,
                           ANFCom.Emit.CNPJ,
                           ANFCom.Emit.IE,
                           dhEmissao,
                           DescricaoModelo);
    end;
  end;
end;

end.
