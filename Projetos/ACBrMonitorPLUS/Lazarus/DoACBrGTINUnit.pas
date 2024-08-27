{*******************************************************************************}
{ Projeto: ACBrMonitor                                                          }
{  Executavel multiplataforma que faz uso do conjunto de componentes ACBr para  }
{ criar uma interface de comunicação com equipamentos de automacao comercial.   }
{                                                                               }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida                }
{                                                                               }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr     }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr       }
{                                                                               }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la  }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela   }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério)  }
{ qualquer versão posterior.                                                    }
{                                                                               }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM    }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU       }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor }
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)               }
{                                                                               }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto }
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,   }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.           }
{ Você também pode obter uma copia da licença em:                               }
{ http://www.opensource.org/licenses/gpl-license.php                            }
{                                                                               }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br }
{        Rua Cel.Aureliano de Camargo, 963 - Tatuí - SP - 18270-170             }
{                                                                               }
{*******************************************************************************}

{$I ACBr.inc}

unit DoACBrGTINUnit;

interface

uses
  Classes, SysUtils, CmdUnit, ACBrGTIN, ACBrMonitorConfig;

type

{ TACBrObjetoGTIN }

TACBrObjetoGTIN = class(TACBrObjetoDFe)
private
  fACBrGTIN: TACBrGTIN;
public
  constructor Create(AConfig: TMonitorConfig; aACBrGTIN: TACBrGTIN); reintroduce;
  procedure Executar(ACmd: TACBrCmd); override;

  property ACBrGTIN: TACBrGTIN read fACBrGTIN;
end;

{ TMetodoGTINConsultar}

TMetodoGTINConsultar = class(TACBrMetodo)
public
  procedure Executar; override;
end;

implementation

uses
  ACBrLibGTINRespostas, ACBrMonitorConsts, ACBrLibResposta, DoACBrUnit,
  ACBrLibConfig;

{ TMetodoGTINConsultar }

procedure TMetodoGTINConsultar.Executar;
var
  wGTIN: String;
  wResp: TGTINResposta;
begin
  wGTIN := fpCmd.Params(0);

  with TACBrObjetoGTIN(fpObjetoDono) do
  begin
    if ACBrGTIN.Consultar(wGTIN) then
    begin
      wResp := TGTINResposta.Create(TpResp, codUTF8);
      try
        wResp.Processar(ACBrGTIN);
        fpCmd.Resposta := sLineBreak + wResp.Gerar;
      finally
        wResp.Free;
      end;
    end;
  end;
end;

{ TACBrObjetoGTIN }

constructor TACBrObjetoGTIN.Create(AConfig: TMonitorConfig; aACBrGTIN: TACBrGTIN);
begin
  inherited Create(AConfig);

  fACBrGTIN := aACBrGTIN;

  ListaDeMetodos.Add(CMetodoConsultar);
end;

procedure TACBrObjetoGTIN.Executar(ACmd: TACBrCmd);
var
  wMetodoClass: TACBrMetodoClass;
  CmdNum: Integer;
  wMetodo: TACBrMetodo;
  wACBrUnit: TACBrObjetoACBr;
begin
  inherited Executar(ACmd);

  CmdNum := ListaDeMetodos.IndexOf(LowerCase(ACmd.Metodo));
  wMetodoClass := Nil;

  case CmdNum of
    0: wMetodoClass := TMetodoGTINConsultar;
  else
    wACBrUnit := TACBrObjetoACBr.Create(Nil); //Instancia DoACBrUnit para validar métodos padrão para todos os objetos
    try
      wACBrUnit.Executar(ACmd);
    finally
      wACBrUnit.Free;
    end;
  end;

  if Assigned(wMetodoClass) then
  begin
    wMetodo := wMetodoClass.Create(ACmd, Self);
    try
      wMetodo.Executar;
    finally
      wMetodo.Free;
    end;
  end;
end;

end.

