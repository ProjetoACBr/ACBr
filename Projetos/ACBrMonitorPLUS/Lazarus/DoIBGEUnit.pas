{*******************************************************************************}
{ Projeto: ACBrMonitor                                                          }
{  Executavel multiplataforma que faz uso do conjunto de componentes ACBr para  }
{ criar uma interface de comunica��o com equipamentos de automacao comercial.   }
{                                                                               }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida                }
{                                                                               }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr     }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr       }
{                                                                               }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la  }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela   }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio)  }
{ qualquer vers�o posterior.                                                    }
{                                                                               }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM    }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU       }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor }
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)               }
{                                                                               }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto }
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,   }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.           }
{ Voc� tamb�m pode obter uma copia da licen�a em:                               }
{ http://www.opensource.org/licenses/gpl-license.php                            }
{                                                                               }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br }
{        Rua Cel.Aureliano de Camargo, 963 - Tatu� - SP - 18270-170             }
{                                                                               }
{*******************************************************************************}
{$I ACBr.inc}

unit DoIBGEUnit;

interface

uses
  Classes, TypInfo, SysUtils, CmdUnit, ACBrUtil.FilesIO, ACBrUtil.Strings,
  ACBrIBGE, ACBrMonitorConsts, ACBrMonitorConfig, ACBrLibIBGERespostas, ACBrLibResposta;

type

{ TACBrObjetoIBGE }

TACBrObjetoIBGE = class(TACBrObjetoDFe)
private
  fACBrIBGE: TACBrIBGE;
public
  constructor Create(AConfig: TMonitorConfig; ACBrIBGE: TACBrIBGE); reintroduce;
  procedure Executar(ACmd: TACBrCmd); override;

  procedure RespostaItensConsulta(ItemID: integer = 0);

  property ACBrIBGE: TACBrIBGE read fACBrIBGE;
end;

{ TMetodoBuscarPorCodigo}
TMetodoBuscarPorCodigo = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoBuscarPorNome}
TMetodoBuscarPorNome = class(TACBrMetodo)
public
  procedure Executar; override;
end;

implementation

uses
  ACBrLibConfig;

{ TACBrObjetoIBGE }

constructor TACBrObjetoIBGE.Create(AConfig: TMonitorConfig; ACBrIBGE: TACBrIBGE);
begin
  inherited Create(AConfig);

  fACBrIBGE := ACBrIBGE;

  ListaDeMetodos.Add(CMetodoBuscarPorCodigo);
  ListaDeMetodos.Add(CMetodoBuscarPorNome);
end;

procedure TACBrObjetoIBGE.Executar(ACmd: TACBrCmd);
var
  AMetodoClass: TACBrMetodoClass;
  CmdNum: Integer;
  Ametodo: TACBrMetodo;
begin
  inherited Executar(ACmd);

  CmdNum := ListaDeMetodos.IndexOf(LowerCase(ACmd.Metodo));
  AMetodoClass := Nil;

  case CmdNum of
    0  : AMetodoClass := TMetodoBuscarPorCodigo;
    1  : AMetodoClass := TMetodoBuscarPorNome;
  end;

  if Assigned(AMetodoClass) then
  begin
    Ametodo := AMetodoClass.Create(ACmd, Self);
    try
      Ametodo.Executar;
    finally
      Ametodo.Free;
    end;
  end;
end;

procedure TACBrObjetoIBGE.RespostaItensConsulta(ItemID: integer);
var
  Resp: TLibIBGEResposta;
begin
  Resp := TLibIBGEResposta.Create(ItemID +1, TpResp, codUTF8);
  try
    with fACBrIBGE.Cidades[ItemID] do
    begin
      Resp.UF := UF;
      Resp.CodUF := IntToStr(CodUF);
      Resp.Municipio := Municipio;
      Resp.CodMunicipio := IntToStr(CodMunicipio);
      Resp.Area := FloatToStr(Area);

      fpCmd.Resposta := fpCmd.Resposta + Resp.Gerar;
    end;
  finally
    Resp.Free;
  end;
end;

{ TMetodoBuscarPorCodigo }

{ Params: 0 - String com o codigo IBGE da Cidade
}
procedure TMetodoBuscarPorCodigo.Executar;
var
  I: Integer;
begin
  with TACBrObjetoIBGE(fpObjetoDono) do
  begin
    ACBrIBGE.BuscarPorCodigo( StrToInt( fpCmd.Params(0) ) );

    if ACBrIBGE.Cidades.Count < 1 then
       raise Exception.Create( 'Nenhuma Cidade encontrada' );

    for I := 0 to ACBrIBGE.Cidades.Count-1 do
      RespostaItensConsulta(I);
  end;
end;

{ TMetodoBuscarPorNome }

{ Params: 0 - String com o nome da cidade
}
procedure TMetodoBuscarPorNome.Executar;
var
  I: Integer;
begin
  with TACBrObjetoIBGE(fpObjetoDono) do
  begin
    ACBrIBGE.BuscarPorNome( fpCmd.Params(0) );

    if ACBrIBGE.Cidades.Count < 1 then
      raise Exception.Create( 'Nenhuma Cidade encontrada' );

    for I := 0 to ACBrIBGE.Cidades.Count-1 do
      RespostaItensConsulta(I);
  end;
end;

end.
