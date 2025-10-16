{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Renato Rubinho                                  }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibExtratoAPIBase;

interface

uses
  Classes, SysUtils, ACBrLibComum,
  ACBrUtil.FilesIO, ACBrUtil.Strings,
  ACBrExtratoAPI, ACBrLibExtratoAPIDataModule;

type
  { TACBrLibExtratoAPI }
  TACBrLibExtratoAPI = class(TACBrLib)
  private
    FExtratoAPIDM: TLibExtratoAPIDM;

  protected
    procedure CriarConfiguracao(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    procedure Executar; Override;
  public
    constructor Create(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    destructor Destroy; override;

    property ExtratoAPIDM: TLibExtratoAPIDM read FExtratoAPIDM;

    function ConsultarExtrato(AAgencia, AConta: PAnsiChar; ADataInicio, ADataFim: TDateTime; APagina, ARegistrosPorPag: integer;
      const sResposta: PAnsiChar; var esTamanho: integer): longint;
  end;

implementation

uses
  ACBrLibConsts, ACBrLibConfig,
  ACBrLibExtratoAPIConfig, ACBrLibExtratoAPIRespostas;

{ TACBrLibExtratoAPI }
constructor TACBrLibExtratoAPI.Create(ArqConfig: string; ChaveCrypt: ansistring);
begin
  inherited Create(ArqConfig, ChaveCrypt);

  FExtratoAPIDM := TLibExtratoAPIDM.Create(nil);
  FExtratoAPIDM.Lib := Self;
end;

destructor TACBrLibExtratoAPI.Destroy;
begin
  FExtratoAPIDM.Free;

  inherited Destroy;
end;

function TACBrLibExtratoAPI.ConsultarExtrato(AAgencia, AConta: PAnsiChar; ADataInicio, ADataFim: TDateTime; APagina, ARegistrosPorPag: integer;
  const sResposta: PAnsiChar; var esTamanho: integer): longint;
var
  Resp: TExtratoResposta;
  Agencia: String;
  Conta: String;
  Resposta: AnsiString;
begin
  try
    Agencia := ConverterStringEntrada(AAgencia);
    Conta := ConverterStringEntrada(AConta);

    if Config.Log.Nivel > logNormal then
      GravarLog('ExtratoAPI_ConsultarExtrato(' + Agencia + ',' + Conta + ',' + DateToStr(ADataInicio) + ',' + DateToStr(ADataFim) + ',' +
        IntToStr(APagina) + ',' + IntToStr(ARegistrosPorPag) + ' )', logCompleto, True)
    else
      GravarLog('ExtratoAPI_ConsultarExtrato', logNormal);

    ExtratoAPIDM.Travar;
    try
      ExtratoAPIDM.ACBrExtratoAPI1.ConsultarExtrato(Agencia, Conta, ADataInicio, ADataFim, APagina, ARegistrosPorPag);

      Resp := TExtratoResposta.Create(Config.TipoResposta, Config.CodResposta);
      try
        Resp.Processar(ExtratoAPIDM.ACBrExtratoAPI1);

        Resposta := Resp.Gerar;
      finally
        Resp.Free;
      end;

      MoverStringParaPChar(Resposta, sResposta, esTamanho);
      Result := SetRetorno(ErrOK, Resposta);
    finally
      ExtratoAPIDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, ConverterStringSaida(E.Message));

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, ConverterStringSaida(E.Message));
  end;
end;

procedure TACBrLibExtratoAPI.CriarConfiguracao(ArqConfig: string; ChaveCrypt: ansistring);
begin
  fpConfig := TLibExtratoAPIConfig.Create(Self, ArqConfig, ChaveCrypt);
end;

procedure TACBrLibExtratoAPI.Executar;
begin
  inherited Executar;
  FExtratoAPIDM.AplicarConfiguracoes;
end;

end.

