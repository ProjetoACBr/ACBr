{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }


{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{  Algumas fun�oes dessa Unit foram extraidas de outras Bibliotecas, veja no   }
{ cabe�alho das Fun�oes no c�digo abaixo a origem das informa�oes, e autores...}

{******************************************************************************}

{$I ACBr.inc}



unit ACBrUtil.FR;

interface
uses
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
    procedure EmptyDataSet; // Declara��o dos novos m�todos
  end;

{$ENDIF}

implementation

uses
  SysUtils,
  frxClass,
  frxDsgnIntf;

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

procedure RemoveExportPDFDup;
var
  LCount, I: Integer;
begin
  //Remove do menu, exporta��es de PDF "duplicadas"
  //FastReport varre a aplica��o por RTTI buscando TfrxPDFExport
  //Para cada TfrxPDFExport � criado um item no menu
  //Este processo varre os plugins de exporta��o deixando apenas 1 (o ultimo) TfrxPDFExport por rtti
  //Inserir na chamada do metodo Imprimir do Relat�rio
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

end.
