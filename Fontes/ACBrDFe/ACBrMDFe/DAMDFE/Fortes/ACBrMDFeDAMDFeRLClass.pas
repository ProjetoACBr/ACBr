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

unit ACBrMDFeDAMDFeRLClass;

interface

uses
  Forms, SysUtils, Classes,
  ACBrBase, ACBrMDFeDAMDFeClass, pmdfeMDFe;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}

  { TACBrMDFeDAMDFeRL }

  TACBrMDFeDAMDFeRL = class(TACBrMDFeDAMDFeClass)
  private
  protected
    FPrintDialog: Boolean;  
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDAMDFe(AMDFe: TMDFe = nil); override;

    procedure ImprimirDAMDFePDF(AMDFe: TMDFe = nil); override;
    procedure ImprimirDAMDFePDF(AStream: TStream; AMDFe: TMDFe = nil); override;

    procedure ImprimirEVENTO(AMDFe: TMDFe = nil); override;

    procedure ImprimirEVENTOPDF(AMDFe: TMDFe = nil); override;
    procedure ImprimirEVENTOPDF(AStream: TStream; AMDFe: TMDFe = nil); override;
  published
    property PrintDialog: Boolean read FPrintDialog write FPrintDialog;
end;

implementation

uses
  ACBrUtil.FilesIO,
  ACBrUtil.Strings,
  ACBrMDFe, 
  pmdfeEnvEventoMDFe,
  ACBrMDFeDAMDFeRLRetrato, 
  ACBrMDFeDAEventoRL, 
  ACBrMDFeDAEventoRLRetrato;

constructor TACBrMDFeDAMDFeRL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPrintDialog := True;
end;

destructor TACBrMDFeDAMDFeRL.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrMDFeDAMDFeRL.ImprimirDAMDFe(AMDFe: TMDFe);
var
  i: Integer;
  Manifestos: array of TMDFe;
begin
  if (AMDFe = nil) then
  begin
    SetLength(Manifestos, TACBrMDFe(ACBrMDFe).Manifestos.Count);

    for i := 0 to (TACBrMDFe(ACBrMDFe).Manifestos.Count - 1) do
      Manifestos[i] := TACBrMDFe(ACBrMDFe).Manifestos.Items[i].MDFe;
  end
  else
  begin
    SetLength(Manifestos, 1);
    Manifestos[0] := AMDFe;
  end;

  TfrlDAMDFeRLRetrato.Imprimir(Self, Manifestos);
end;

procedure TACBrMDFeDAMDFeRL.ImprimirDAMDFePDF(AMDFe: TMDFe);
var
  i: integer;
  ArqPDF: String;

  function ImprimirDAMDFEPDFTipo(AMDFe: TMDFe): String;
  begin
    Result := DefinirNomeArquivo(Self.PathPDF,
                                 OnlyNumber(AMDFe.infMDFe.ID) + '-mdfe.pdf',
                                 Self.NomeDocumento);

    TfrlDAMDFeRLRetrato.SalvarPDF(Self, AMDFe, Result);
  end;

begin
  FPArquivoPDF := '';

  if AMDFe = nil then
  begin
    for i := 0 to TACBrMDFe(ACBrMDFe).Manifestos.Count - 1 do
    begin
      ArqPDF := ImprimirDAMDFEPDFTipo(TACBrMDFe(ACBrMDFe).Manifestos.Items[i].MDFe);

      FPArquivoPDF := ArqPDF;

      // o componente n�o tem a propriedade NomeArqPDF
//      TACBrMDFe(ACBrMDFe).Manifestos.Items[i].NomeArqPDF := FPArquivoPDF;
    end;
  end
  else
    FPArquivoPDF := ImprimirDAMDFEPDFTipo(AMDFe);
end;

procedure TACBrMDFeDAMDFeRL.ImprimirDAMDFePDF(AStream: TStream; AMDFe: TMDFe);
var
  i: Integer;

  procedure StreamDAMDFEPDFTipo(AMDFe: TMDFe; const AStream: TStream);
  begin
    AStream.Size := 0;
    TfrlDAMDFeRLRetrato.SalvarPDF(Self, AMDFe, AStream);
  end;

begin
  if not Assigned(AStream) then
    raise EACBrMDFeException.Create('AStream precisa estar definido');

  if (AMDFe = nil) then
  begin
    for i := 0 to (TACBrMDFe(ACBrMDFe).Manifestos.Count - 1) do
      StreamDAMDFEPDFTipo(TACBrMDFe(ACBrMDFe).Manifestos.Items[i].MDFe, AStream);
  end
  else
    StreamDAMDFEPDFTipo(AMDFe, AStream);
end;

procedure TACBrMDFeDAMDFeRL.ImprimirEVENTO(AMDFe: TMDFe);
var
  i, j: integer;
  Impresso: boolean;
begin
  if AMDFe = nil then
  begin
    for i := 0 to (TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Count - 1) do
    begin
      Impresso := False;
      for j := 0 to (TACBrMDFe(ACBrMDFe).Manifestos.Count - 1) do
      begin
        if OnlyNumber(TACBrMDFe(ACBrMDFe).Manifestos.Items[j].MDFe.infMDFe.ID) =
            TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i].InfEvento.chMDFe then
        begin
          TfrmMDFeDAEventoRLRetrato.Imprimir(Self,
              TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i],
              TACBrMDFe(ACBrMDFe).Manifestos.Items[j].MDFe);
          Impresso := True;
          Break;
        end;
      end;

      if not Impresso then
      begin
        TfrmMDFeDAEventoRLRetrato.Imprimir(Self, TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i]);
      end;
    end;
  end
  else
  begin
    for i := 0 to (TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Count - 1) do
    begin
      TfrmMDFeDAEventoRLRetrato.Imprimir(Self, TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i], AMDFe);
    end;
  end;
end;

procedure TACBrMDFeDAMDFeRL.ImprimirEVENTOPDF(AMDFe: TMDFe);
var
  Impresso: Boolean;
  I, J: Integer;
  NumID, ArqPDF: String;

  function ImprimirEVENTOPDFTipo(EventoMDFeItem: TInfEventoCollectionItem; AMDFe: TMDFe): String;
  begin
    Result := DefinirNomeArquivo(Self.PathPDF,
                                 OnlyNumber(EventoMDFeItem.InfEvento.id) + '-procEventoMDFe.pdf',
                                 Self.NomeDocumento);

    // TipoDAMDFE ainda n�o est� sendo utilizado no momento
    TfrmMDFeDAEventoRLRetrato.SalvarPDF(Self, EventoMDFeItem, Result, AMDFe);
  end;

begin
  FPArquivoPDF := '';

  with TACBrMDFe(ACBrMDFe) do
  begin
    if (AMDFe = nil) and (Manifestos.Count > 0) then
    begin
      for i := 0 to (EventoMDFe.Evento.Count - 1) do
      begin
        Impresso := False;
        ArqPDF := '';
        for j := 0 to (Manifestos.Count - 1) do
        begin
          NumID := OnlyNumber(Manifestos.Items[j].MDFe.infMDFe.ID);
          if (NumID = OnlyNumber(EventoMDFe.Evento.Items[i].InfEvento.chMDFe)) then
          begin
            ArqPDF := ImprimirEVENTOPDFTipo(EventoMDFe.Evento.Items[i], Manifestos.Items[j].MDFe);
            Impresso := True;
            Break;
          end;
        end;

        if (not Impresso) then
          ArqPDF := ImprimirEVENTOPDFTipo(EventoMDFe.Evento.Items[i], nil);

        FPArquivoPDF := FPArquivoPDF + ArqPDF;
        if (i < (EventoMDFe.Evento.Count - 1)) then
          FPArquivoPDF := FPArquivoPDF + sLinebreak;
      end;
    end
    else
    begin
      for i := 0 to (EventoMDFe.Evento.Count - 1) do
      begin
        ArqPDF := ImprimirEVENTOPDFTipo(EventoMDFe.Evento.Items[i], AMDFe);
        FPArquivoPDF := FPArquivoPDF + ArqPDF;
        if (i < (EventoMDFe.Evento.Count - 1)) then
          FPArquivoPDF := FPArquivoPDF + sLinebreak;
      end;
    end;
  end;
end;

procedure TACBrMDFeDAMDFeRL.ImprimirEVENTOPDF(AStream: TStream; AMDFe: TMDFe);
var
  Impresso: Boolean;
  I, J: Integer;
  NumID: String;
begin
  if not Assigned(AStream) then
    raise EACBrMDFeException.Create('AStream precisa estar definido');

  with TACBrMDFe(ACBrMDFe) do
  begin
    if (AMDFe = nil) and (Manifestos.Count > 0) then
    begin
      for i := 0 to (EventoMDFe.Evento.Count - 1) do
      begin
        Impresso := False;
        for j := 0 to (Manifestos.Count - 1) do
        begin
          NumID := OnlyNumber(Manifestos.Items[j].MDFe.infMDFe.ID);
          if (NumID = OnlyNumber(EventoMDFe.Evento.Items[i].InfEvento.chMDFe)) then
          begin
            TfrmMDFeDAEventoRLRetrato.SalvarPDF(Self, EventoMDFe.Evento.Items[i],
              AStream, Manifestos.Items[j].MDFe);

            Impresso := True;
            Break;
          end;
        end;

        if not Impresso and (EventoMDFe.Evento.Count >0 ) then
          TfrmMDFeDAEventoRLRetrato.SalvarPDF(Self, EventoMDFe.Evento.Items[0], AStream, nil);
      end;
    end
    else
    begin
      NumID := OnlyNumber(AMDFe.infMDFe.Id);
      Impresso := False;

      for i := 0 to (EventoMDFe.Evento.Count - 1) do
      begin
        if (NumID = OnlyNumber(EventoMDFe.Evento.Items[i].InfEvento.chMDFe)) then
        begin
          TfrmMDFeDAEventoRLRetrato.SalvarPDF(Self, EventoMDFe.Evento.Items[i], AStream, AMDFe);
          Impresso := True;
          Break;
        end;
      end;

      if not Impresso and (EventoMDFe.Evento.Count > 0) then
        TfrmMDFeDAEventoRLRetrato.SalvarPDF(Self, EventoMDFe.Evento.Items[0], AStream, nil);
    end;
  end;
end;

end.
