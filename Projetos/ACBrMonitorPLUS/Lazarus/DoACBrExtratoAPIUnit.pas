{*******************************************************************************}
{ Projeto: Componentes ACBr                                                     }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa-  }
{ mentos de Automação Comercial utilizados no Brasil                            }
{                                                                               }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida                }
{                                                                               }
{ Colaboradores nesse arquivo: Renato Rubinho                                   }
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

unit DoACBrExtratoAPIUnit;

interface

uses
  Classes, SysUtils, CmdUnit, ACBrExtratoAPI, ACBrMonitorConfig;

type
  { TACBrObjetoExtratoAPI }
  TACBrObjetoExtratoAPI = class(TACBrObjetoDFe)
  private
    FACBrExtratoAPI: TACBrExtratoAPI;
  public
    constructor Create(AConfig: TMonitorConfig; AACBrExtratoAPI: TACBrExtratoAPI); reintroduce;
    procedure Executar(ACmd: TACBrCmd); override;

    property ACBrExtratoAPI: TACBrExtratoAPI read fACBrExtratoAPI;
  end;

  { TMetodoEXTRATOAPIConsultarExtrato}
  TMetodoEXTRATOAPIConsultarExtrato = class(TACBrMetodo)
  public
    procedure Executar; override;
  end;

  { TMetodoEXTRATOAPISelecionaBanco}
  TMetodoEXTRATOAPISelecionaBanco = class(TACBrMetodo)
  public
    procedure Executar; override;
  end;

implementation

uses
  ACBrLibExtratoAPIRespostas, ACBrMonitorConsts, ACBrLibResposta, DoACBrUnit,
  ACBrLibConfig;

{ TMetodoEXTRATOAPIConsultarExtrato }
procedure TMetodoEXTRATOAPIConsultarExtrato.Executar;
var
  LAgencia: String;
  LConta: String;
  LDataInicio: TDateTime;
  LDataFim: TDateTime;
  LPagina: Integer;
  LRegistrosPorPag: Integer;
  wResp: TExtratoResposta;
begin
  LAgencia := fpCmd.Params(0);
  LConta := fpCmd.Params(1);
  LDataInicio := StrToDateTimeDef(fpCmd.Params(2), now);
  LDataFim := StrToDateTimeDef(fpCmd.Params(3), now);
  LPagina := StrToIntDef(fpCmd.Params(4), 1);
  LRegistrosPorPag := StrToIntDef(fpCmd.Params(5), 50);

  with TACBrObjetoExtratoAPI(fpObjetoDono) do
  begin
    if ACBrExtratoAPI.ConsultarExtrato(LAgencia, LConta, LDataInicio, LDataFim, LPagina, LRegistrosPorPag) then
    begin
      wResp := TExtratoResposta.Create(TpResp, codUTF8);
      try
        wResp.Processar(ACBrExtratoAPI);
        fpCmd.Resposta := sLineBreak + wResp.Gerar;
      finally
        wResp.Free;
      end;
    end;
  end;
end;

{ TMetodoEXTRATOAPISelecionaBanco }
procedure TMetodoEXTRATOAPISelecionaBanco.Executar;
var
  LBanco: String;
  LBancoInt: Integer;
  LBancoMax: Integer;
begin
  LBanco := fpCmd.Params(0);
  LBancoInt := StrToIntDef(LBanco,-1);
  LBancoMax := Integer(High(TACBrExtratoAPIBancoConsulta));

  if ((LBancoInt < 0) or
      (LBancoInt > LBancoMax)) then
    raise Exception.Create('Banco inválido [' + LBanco + '], valores válidos [' +
      '0..' + IntToStr(LBancoMax) + ']');

  with TACBrObjetoExtratoAPI(fpObjetoDono) do
  begin
    with MonitorConfig.ExtratoAPI do
      BancoConsulta := LBancoInt;

    MonitorConfig.SalvarArquivo;
  end;
end;

{ TACBrObjetoExtratoAPI }
constructor TACBrObjetoExtratoAPI.Create(AConfig: TMonitorConfig; AACBrExtratoAPI: TACBrExtratoAPI);
begin
  inherited Create(AConfig);

  FACBrExtratoAPI := AACBrExtratoAPI;

  ListaDeMetodos.Add(CMetodoConsultarExtrato);
  ListaDeMetodos.Add(CMetodoSelecionaBanco);
end;

procedure TACBrObjetoExtratoAPI.Executar(ACmd: TACBrCmd);
var
  wMetodoClass: TACBrMetodoClass;
  CmdNum: Integer;
  wMetodo: TACBrMetodo;
  wACBrUnit: TACBrObjetoACBr;
begin
  inherited Executar(ACmd);

  CmdNum := ListaDeMetodos.IndexOf(LowerCase(ACmd.Metodo));
  wMetodoClass := nil;

  case CmdNum of
    0: wMetodoClass := TMetodoExtratoAPIConsultarExtrato;
    1: wMetodoClass := TMetodoEXTRATOAPISelecionaBanco;
  else
    wACBrUnit := TACBrObjetoACBr.Create(nil); //Instancia DoACBrUnit para validar métodos padrão para todos os objetos
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

