{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
{                              Wemerson Souto                                  }
{                              Wiliam Zacarias da Silva Rosa                   }
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

unit ACBrCTeDACTEClass;

interface

uses
  SysUtils, Classes,
  ACBrBase, ACBrDFeReport,
  pcteCTE, pcnConversao;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}

  { TACBrCTeDACTEClass }

  TACBrCTeDACTEClass = class(TACBrDFeReport)
  private
    FPosCanhotoLayout: TPosReciboLayout;
    procedure SetACBrCTE(const Value: TComponent);
    procedure ErroAbstract(const NomeProcedure: string);

  protected
    FACBrCTE: TComponent;
    FImprimirHoraSaida: boolean;
    FImprimirHoraSaida_Hora: string;
    FTipoDACTE: TpcnTipoImpressao;
    FTamanhoPapel: TpcnTamanhoPapel;
    FProtocolo: string;
    FCancelada: boolean;
    FResumoCanhoto: boolean;
    FEPECEnviado: boolean;
    FPosCanhoto: TPosRecibo;
    FImprimirDescPorc: boolean;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetSeparadorPathPDF(const aInitialPath: String): string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDACTe(ACTE: TCTE = nil); virtual;
    procedure ImprimirDACTePDF(ACTE: TCTE = nil); overload; virtual;
    procedure ImprimirDACTePDF(AStream: TStream; ACTe: TCTe = nil); overload; virtual;

    procedure ImprimirEVENTO(ACTE: TCTe = nil); virtual;
    procedure ImprimirEVENTOPDF(ACTE: TCTe = nil); overload; virtual;
    procedure ImprimirEVENTOPDF(AStream: TStream; ACTe: TCTe = nil); overload; virtual;

    procedure ImprimirINUTILIZACAO(ACTE: TCTe = nil); virtual;
    procedure ImprimirINUTILIZACAOPDF(ACTE: TCTe = nil); virtual;

    function CaractereQuebraDeLinha: String;
  published
    property ACBrCTE: TComponent read FACBrCTE write SetACBrCTE;
    property ImprimirHoraSaida: boolean read FImprimirHoraSaida write FImprimirHoraSaida;
    property ImprimirHoraSaida_Hora: string read FImprimirHoraSaida_Hora write FImprimirHoraSaida_Hora;
    property TipoDACTE: TpcnTipoImpressao read FTipoDACTE write FTipoDACTE;
    property TamanhoPapel: TpcnTamanhoPapel read FTamanhoPapel write FTamanhoPapel;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Cancelada: boolean read FCancelada write FCancelada;
    property ExibeResumoCanhoto: boolean read FResumoCanhoto write FResumoCanhoto;
    property EPECEnviado: boolean read FEPECEnviado write FEPECEnviado;
    property PosCanhoto: TPosRecibo read FPosCanhoto write FPosCanhoto default prCabecalho;
    property PosCanhotoLayout: TPosReciboLayout read FPosCanhotoLayout write FPosCanhotoLayout default prlPadrao;
    property ImprimeDescPorc: boolean read FImprimirDescPorc write FImprimirDescPorc;
  end;

implementation

uses
  ACBrCTe;

constructor TACBrCTeDACTEClass.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FACBrCTE := nil;
  FImprimirHoraSaida := False;
  FImprimirHoraSaida_Hora := '';
  FProtocolo := '';
  FCancelada := False;
  FResumoCanhoto := False;
  FEPECEnviado := False;
  FPosCanhoto := prCabecalho;
  FPosCanhotoLayout := prlPadrao;
end;

destructor TACBrCTeDACTEClass.Destroy;
begin

  inherited Destroy;
end;

procedure TACBrCTeDACTEClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrCTE <> nil) and (AComponent is TACBrCTE) then
    FACBrCTE := nil;
end;

procedure TACBrCTeDACTEClass.SetACBrCTE(const Value: TComponent);
var
  OldValue: TACBrCTE;
begin
  if Value <> FACBrCTE then
  begin
    if Value <> nil then
      if not (Value is TACBrCTE) then
        raise Exception.Create('DACTE deve ser do tipo TACBrCTE');

    if Assigned(FACBrCTE) then
      FACBrCTE.RemoveFreeNotification(Self);

    OldValue := TACBrCTE(FACBrCTE);   // Usa outra variavel para evitar Loop Infinito
    FACBrCTE := Value;                // na remo��o da associa��o dos componentes

    if Assigned(OldValue) then
      if Assigned(OldValue.DACTE) then
        OldValue.DACTE := nil;

    if Value <> nil then
    begin
      Value.FreeNotification(self);
      TACBrCTE(Value).DACTE := self;
    end;
  end;
end;

procedure TACBrCTeDACTEClass.ErroAbstract(const NomeProcedure: string);
begin
  raise Exception.Create(NomeProcedure);
end;

procedure TACBrCTeDACTEClass.ImprimirDACTe(ACTE: TCTE = nil);
begin
  ErroAbstract('ImprimirDACTE');
end;

procedure TACBrCTeDACTEClass.ImprimirDACTePDF(ACTE: TCTE = nil);
begin
  ErroAbstract('ImprimirDACTEPDF');
end;

procedure TACBrCTeDACTEClass.ImprimirDACTePDF(AStream: TStream; ACTe: TCTe);
begin
  ErroAbstract('ImprimirDACTEPDF');
end;

procedure TACBrCTeDACTEClass.ImprimirEVENTO(ACTE: TCTe);
begin
  ErroAbstract('ImprimirEVENTO');
end;

procedure TACBrCTeDACTEClass.ImprimirEVENTOPDF(ACTE: TCTe);
begin
  ErroAbstract('ImprimirEVENTOPDF');
end;

procedure TACBrCTeDACTEClass.ImprimirEVENTOPDF(AStream: TStream; ACTe: TCTe);
begin
  ErroAbstract('ImprimirEVENTOPDF');
end;

procedure TACBrCTeDACTEClass.ImprimirINUTILIZACAO(ACTE: TCTe);
begin
  ErroAbstract('ImprimirINUTILIZACAO');
end;

procedure TACBrCTeDACTEClass.ImprimirINUTILIZACAOPDF(ACTE: TCTe);
begin
  ErroAbstract('ImprimirINUTILIZACAOPDF');
end;

function TACBrCTeDACTEClass.GetSeparadorPathPDF(const aInitialPath: String): string;
var
  dhEmissao: TDateTime;
  DescricaoModelo: string;
  ACTe: TCTe;
begin
  Result := aInitialPath;

  // Se tem o componente ACBrCTe
  if Assigned(ACBrCTe) then
  begin
    // Se tem algum Conhecimento carregado
    if TACBrCTe(ACBrCTe).Conhecimentos.Count > 0 then
    begin
      ACTe := TACBrCTe(ACBrCTe).Conhecimentos.Items[0].CTe;
      if TACBrCTe(ACBrCTe).Configuracoes.Arquivos.EmissaoPathCTe then
        dhEmissao := ACTe.Ide.dhEmi
      else
        dhEmissao := Now;

      DescricaoModelo := '';
      if TACBrCTe(ACBrCTe).Configuracoes.Arquivos.AdicionarLiteral then
      begin
        case ACTe.Ide.modelo of
          0: DescricaoModelo := TACBrCTe(FACBrCTe).GetNomeModeloDFe;
          57: DescricaoModelo := 'CTe';
          67: DescricaoModelo := 'CTeOS';
        end;
      end;

      Result := TACBrCTe(FACBrCTe).Configuracoes.Arquivos.GetPath(Result,
        DescricaoModelo, ACTe.Emit.CNPJ, ACTe.Emit.IE, dhEmissao, DescricaoModelo);
    end;
  end;
end;

function TACBrCTeDACTEClass.CaractereQuebraDeLinha: String;
begin
  Result := '|';
  if Assigned(FACBrCTE) and (FACBrCTe is TACBrCTe) then
  begin
    Result := TACBrCTe(FACBrCTe).Configuracoes.WebServices.QuebradeLinha;
  end;
end;

end.
