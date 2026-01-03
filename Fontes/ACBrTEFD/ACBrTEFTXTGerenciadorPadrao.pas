{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2026 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrTEFTXTGerenciadorPadrao;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils,
  ACBrTEFComum, ACBrTEFTXTComum;

const
  CACBRTEFTXT_NomeGerenciadorPadrao = 'Gerenciador Padrão';
  CACBRTEFTXT_CMD_ATV = 'ATV';
  CACBRTEFTXT_CMD_ADM = 'ADM';
  CACBRTEFTXT_CMD_CHQ = 'CHQ';
  CACBRTEFTXT_CMD_CRT = 'CRT';
  CACBRTEFTXT_CMD_CNC = 'CNC';
  CACBRTEFTXT_CMD_CNF = 'CNF';
  CACBRTEFTXT_CMD_NCN = 'NCN';

type

  { TACBrTEFTXTGerenciadorPadrao }

  TACBrTEFTXTGerenciadorPadrao = class( TACBrTEFTXTBaseClass )
  private
    fEnviarATV: Boolean;
  protected
    function RespostaTransacaoComSucesso: Boolean;
    procedure RespostaRelatorio(sl: TStringList); virtual;
    function AjustarLinhaRelatorio(const ALinha: String): String;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure PrepararRequisicao(const AHeader: String); override;
    procedure ATV;
    function ADM: Boolean;

    property Enviar_ATV_Antes: Boolean read fEnviarATV write fEnviarATV default True;
  end;


implementation

uses
  Math,
  ACBrUtil.Strings;

{ TACBrTEFTXTGerenciadorPadrao }

constructor TACBrTEFTXTGerenciadorPadrao.Create;
begin
  inherited;
  fEnviarATV := True;
end;

destructor TACBrTEFTXTGerenciadorPadrao.Destroy;
begin
  inherited Destroy;
end;

function TACBrTEFTXTGerenciadorPadrao.RespostaTransacaoComSucesso: Boolean;
begin
  Result := (Resp.Campo[9,0].AsString = '0');
end;

procedure TACBrTEFTXTGerenciadorPadrao.RespostaRelatorio(sl: TStringList);
var
  nLin, i: Integer;
  s: String;
begin
  sl.Clear;
  nLin := Resp.Campo[28,0].AsInteger;  // QUANTIDADE DE LINHAS DO COMPROVANTE
  if (nLin > 0) then
  begin
    sl := TStringList.Create;
    try
      i := 1;
      while i <= nLin do
      begin
        s := Resp.Campo[29,i].AsString;   // IMAGEM DE CADA LINHA DO COMPROVANTE
        sl.Add( AjustarLinhaRelatorio(s) );
      end;
    finally
      sl.Free;
    end;
  end;
end;

function TACBrTEFTXTGerenciadorPadrao.AjustarLinhaRelatorio(const ALinha: String): String;
var
  l: Integer;
begin
  Result := ALinha;
  if copy(Result, 1, 1) = '"' then
    Delete(Result, 1, 1);

  l := Length(Result);
  if copy(Result, l, 1) = '"' then
    Delete(Result, l, 1);
end;

procedure TACBrTEFTXTGerenciadorPadrao.PrepararRequisicao(const AHeader: String);
begin
  if (AHeader <> CACBRTEFTXT_CMD_ATV) then
    ATV;

  inherited PrepararRequisicao(AHeader);
end;

procedure TACBrTEFTXTGerenciadorPadrao.ATV;
begin
  PrepararRequisicao(CACBRTEFTXT_CMD_ATV);
  EnviarRequisicao;
end;

function TACBrTEFTXTGerenciadorPadrao.ADM: Boolean;
begin
  PrepararRequisicao(CACBRTEFTXT_CMD_ADM);
  EnviarRequisicao;

  Result := RespostaTransacaoComSucesso;
end;

end.

