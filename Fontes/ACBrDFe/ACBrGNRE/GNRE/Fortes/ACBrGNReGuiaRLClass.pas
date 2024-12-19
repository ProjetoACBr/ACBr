{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrGNReGuiaRLClass;

interface

uses
  Forms, 
  SysUtils, 
  Classes, 
  RLTypes,
  ACBrBase, 
  ACBrGNREGuiaClass, 
  pgnreGNRERetorno;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrGNREGuiaRL = class(TACBrGNREGuiaClass)
  private
  protected
    FPrintDialog: Boolean;  
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirGuia(AGNRE: TGNRERetorno=nil); override;
    procedure ImprimirGuiaPDF(AGNRE: TGNRERetorno=nil); override;
  published
    property PrintDialog: Boolean read FPrintDialog write FPrintDialog;
end;

implementation

uses
  ACBrUtil.Strings, 
  ACBrUtil.FilesIO,
  ACBrGNRE2, 
  ACBrGNREGuiaRLRetrato;

constructor TACBrGNREGuiaRL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPrintDialog := True;
end;

destructor TACBrGNREGuiaRL.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrGNREGuiaRL.ImprimirGuia(AGNRE: TGNRERetorno = nil);
var
  i: integer;
  frlGuiaRLRetrato: TfrlGuiaRLRetrato;
begin
  frlGuiaRLRetrato := TfrlGuiaRLRetrato.Create(Self);

  try
    frlGuiaRLRetrato.RLGNRe.PageSetup.PaperSize   :=fpA4;
    frlGuiaRLRetrato.RLGNRe.PageSetup.PaperHeight :=297.0;
    frlGuiaRLRetrato.RLGNRe.PageSetup.PaperWidth  :=210.0;

    if AGNRE = nil then
    begin
      for i:=0 to TACBrGNRE(ACBrGNRE).GuiasRetorno.Count -1 do
      begin
        frlGuiaRLRetrato.Imprimir(Self,
           TACBrGNRE(ACBrGNRE).GuiasRetorno.Items[i].GNRE,
           Email,
           Fax,
           NumCopias,
           Sistema,
           Site,
           Usuario,
           MostrarPreview,
           MargemSuperior,
           MargemInferior,
           MargemEsquerda,
           MargemDireita,
           Impressora,
           PrintDialog);
      end;
    end
    else
    begin
      frlGuiaRLRetrato.Imprimir(Self,
           AGNRE,
           Email,
           Fax,
           NumCopias,
           Sistema,
           Site,
           Usuario,
           MostrarPreview,
           MargemSuperior,
           MargemInferior,
           MargemEsquerda,
           MargemDireita,
           Impressora,
           PrintDialog);
    end;
  finally
    frlGuiaRLRetrato.Free;
  end;
end;

procedure TACBrGNReGuiaRL.ImprimirGuiaPDF(AGNRE: TGNRERetorno = nil);
var
  NomeArq: string;
  i: integer;
  frlGuiaRLRetrato: TfrlGuiaRLRetrato;
begin
  frlGuiaRLRetrato := TfrlGuiaRLRetrato.Create(Self);

  if AGNRE = nil then
  begin
    for i := 0 to TACBrGNRE(ACBrGNRE).GuiasRetorno.Count -1 do
    begin
      NomeArq := DefinirNomeArquivo(Self.PathPDF,
                 OnlyNumber(TACBrGNRE(ACBrGNRE).GuiasRetorno.Items[i].GNRE.IdentificadorGuia) +
                 '-guia.pdf', Self.ArquivoPDF);

      frlGuiaRLRetrato.SavePDF(Self,
          NomeArq,
          TACBrGNRE(ACBrGNRE).GuiasRetorno.Items[i].GNRE,
          Email,
          Fax,
          NumCopias,
          Sistema,
          Site,
          Usuario,
          MargemSuperior,
          MargemInferior,
          MargemEsquerda,
          MargemDireita);
    end;
  end
  else
  begin
    NomeArq := DefinirNomeArquivo(Self.PathPDF,
                                 OnlyNumber(AGNRE.IdentificadorGuia) + '-guia.pdf',
                                 Self.ArquivoPDF);

    frlGuiaRLRetrato.SavePDF(Self,
          NomeArq,
          AGNRE,
          Email,
          Fax,
          NumCopias,
          Sistema,
          Site,
          Usuario,
          MargemSuperior,
          MargemInferior,
          MargemEsquerda,
          MargemDireita);
  end;

  if frlGuiaRLRetrato.RLGNRe <> nil then
    frlGuiaRLRetrato.Free;
end;

end.
