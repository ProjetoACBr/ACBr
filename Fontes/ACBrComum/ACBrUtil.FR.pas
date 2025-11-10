{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }


{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }

{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }

{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrUtil.FR;

interface
uses
  frxClass,
{$IFDEF FPC}
  BufDataset
{$ELSE}
  DBClient
{$ENDIF}
;

type
  TACBrFRDataSet = {$IFDEF FPC}TBufDataset{$ELSE}TClientDataSet{$ENDIF};

{$IFDEF FPC}
{ THBufDataset }
  THBufDataset = class helper for TBufDataset // Cria-se o helper
  public
    procedure EmptyDataSet; // Declaração dos novos métodos
  end;

{$ENDIF}
  procedure SetDefaultPrinter(var frxReport : TfrxReport);
  procedure RemoveExportFastReportPDFDuplicate;

implementation
uses
  SysUtils,
  frxDsgnIntf,
  Classes,
  Printers;

{$IFDEF FPC}
{ THBufDataset }
procedure THBufDataset.EmptyDataSet;
begin
  TBufDataset(Self).Active := True;
  TBufDataset(Self).First;
  while not TBufDataset(Self).EOF do TBufDataset(Self).Delete;
  TBufDataset(Self).Close;
  TBufDataset(Self).Open;
end;
{$ENDIF}

procedure RemoveExportFastReportPDFDuplicate;
var
  LCount, I: Integer;
begin
  //Remove do menu, exportações de PDF "duplicadas"
  //FastReport varre a aplicação por RTTI buscando TfrxPDFExport
  //Para cada TfrxPDFExport é criado um item no menu
  //Este processo varre os plugins de exportação deixando apenas 1 (o ultimo) TfrxPDFExport por rtti
  //Inserir na chamada do metodo Imprimir do Relatório
  //proposto por Marcos R Weimer / compatibilizado por BigWings
  LCount := 0;

  for i := Pred(frxExportFilters.Count) downto 0 do
  begin
    if AnsiUpperCase(frxExportFilters[i].Filter.ClassName) = 'TFRXPDFEXPORT' then
    begin
      if LCount > 0 then
        frxExportFilters.Delete(i)
      else
        Inc(LCount);
    end;
  end;
end;

procedure SetDefaultPrinter(var frxReport : TfrxReport);
begin
  try
    frxReport.PrintOptions.Clear;
    Printer.PrinterIndex := -1;
    if Printer.PrinterIndex >= 0 then
      frxReport.PrintOptions.Printer := Printer.Printers.Strings[Printer.PrinterIndex];
  except
    //caso ocorrer erro ao setar a impressora padrão, silenciar a exception
  end;
end;

initialization
begin

end;

end.
