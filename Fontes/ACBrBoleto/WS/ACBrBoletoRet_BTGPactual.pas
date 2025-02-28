{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor H Gonzales - Panda                       }
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

//incluido em::
{$I ACBr.inc}

unit ACBrBoletoRet_BTGPactual;

interface

uses
  Classes,
  SysUtils,
  ACBrBoleto,
  ACBrBoletoWS,
  ACBrBoletoRetorno,
  ACBrJSON,
  DateUtils,
  ACBrBoletoWS.Rest;

type
  { TRetornoEnvio_BTGPactual }

  TRetornoEnvio_BTGPactual = class(TRetornoEnvioREST)
  private

  public
    constructor Create(ABoletoWS: TACBrBoleto); override;
    destructor  Destroy; Override;
    function LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean; override;
    function RetornoEnvio(const AIndex: Integer): Boolean; override;
  end;


implementation

uses
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  ACBrBoletoConversao,
  StrUtils,
  ACBrUtil.Base;

{ TRetornoEnvio_BTGPactual }

constructor TRetornoEnvio_BTGPactual.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);
end;

destructor TRetornoEnvio_BTGPactual.Destroy;
begin
  inherited Destroy;
end;

function TRetornoEnvio_BTGPactual.LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean;
var
  LJsonArray, LJsonErrorArray: TACBrJSONArray;
  LJsonObject : TACBrJSONObject;
  LRejeicao: TACBrBoletoRejeicao;
  I: Integer;
  TipoOperacao : TOperacao;
  LTotalObjetos, nIndiceOBJ : integer;
  LExisteBankSlip : boolean;

begin
  Result := True;
  LExisteBankSlip := false;

  TipoOperacao := ACBrBoleto.Configuracoes.WebService.Operacao;

  ARetornoWs.JSONEnvio       := EnvWs;
  ARetornoWS.HTTPResultCode  := HTTPResultCode;
  ARetornoWS.Header.Operacao := TipoOperacao;

  if RetWS <> '' then
  begin
    LJsonArray := TACBrJSONArray.Parse(RetWS);
    try
      try
        ARetornoWS.JSON := LJsonArray.ToJSON;
        if HTTPResultCode < 300 then
        begin
          case TipoOperacao of
            tpInclui:
              begin
                case HTTPResultCode of
                  202 :
                  begin
                    LTotalObjetos := LJsonArray.Count;
                    LJSONObject := LJsonArray.ItemAsJSONObject[0];
                    ARetornoWS.DadosRet.TituloRet.NossoNumero          := LJSONObject.AsString['ourNumber'] + LJSONObject.AsString['ourNumberDigit'];
                    ARetornoWS.DadosRet.TituloRet.SeuNumero            := LJSONObject.AsString['bankSlipId'];
                    ARetornoWS.DadosRet.TituloRet.Vencimento           := StringToDateTimeDef(LJSONObject.AsString['dueDate'], 0, 'yyyy-mm-dd');
                    ARetornoWS.DadosRet.TituloRet.DataDocumento        := StringToDateTimeDef(LJSONObject.AsString['createdAt'], 0, 'yyyy-mm-dd');
                    ARetornoWS.DadosRet.TituloRet.ValorDocumento       := LJSONObject.AsFloat['amount'];
                    ARetornoWS.DadosRet.TituloRet.EstadoTituloCobranca := LJSONObject.AsString['status'];

                    ARetornoWS.DadosRet.TituloRet.LinhaDig             := LJSONObject.AsString['digitableLine'];
                    ARetornoWS.DadosRet.TituloRet.CodBarras            := LJSONObject.AsString['barCode'];

                    if LJSONObject.AsString['correlationId'] <> '' then
                      ARetornoWS.DadosRet.TituloRet.NossoNumeroCorrespondente  := LJSONObject.AsString['correlationId'];

                    ARetornoWS.DadosRet.TituloRet.EMV                  := LJSONObject.AsString['pixInfo'];
                    ARetornoWS.DadosRet.IDBoleto.IDBoleto              := ARetornoWS.DadosRet.TituloRet.NossoNumeroCorrespondente;
                    ARetornoWS.DadosRet.IDBoleto.CodBarras             := ARetornoWS.DadosRet.TituloRet.CodBarras;
                    ARetornoWS.DadosRet.IDBoleto.LinhaDig              := ARetornoWS.DadosRet.TituloRet.LinhaDig;
                    ARetornoWS.DadosRet.IDBoleto.NossoNum              := ARetornoWS.DadosRet.TituloRet.NossoNumero;
                  end;
                end;
              end;
            tpConsultaDetalhe,
            tpConsulta :
              begin
                case HTTPResultCode of
                  200 :
                    begin
                      LTotalObjetos := LJsonArray.Count;
                      LJSONObject := LJsonArray.ItemAsJSONObject[0];
                      ARetornoWS.DadosRet.TituloRet.NossoNumero          := LJSONObject.AsString['ourNumber'];
                      ARetornoWS.DadosRet.TituloRet.SeuNumero            := LJSONObject.AsString['bankSlipId'];
                      ARetornoWS.DadosRet.TituloRet.Vencimento           := StringToDateTimeDef(LJSONObject.AsString['dueDate'], 0, 'yyyy-mm-dd');
                      ARetornoWS.DadosRet.TituloRet.DataDocumento        := StringToDateTimeDef(LJSONObject.AsString['createdAt'], 0, 'yyyy-mm-dd');
                      ARetornoWS.DadosRet.TituloRet.ValorDocumento       := LJSONObject.AsFloat['amount'];
                      ARetornoWS.DadosRet.TituloRet.EstadoTituloCobranca := LJSONObject.AsString['status'];

                      ARetornoWS.DadosRet.TituloRet.LinhaDig             := LJSONObject.AsString['digitableLine'];
                      ARetornoWS.DadosRet.TituloRet.CodBarras            := LJSONObject.AsString['barCode'];

                      if LJSONObject.AsString['correlationId'] <> '' then
                        ARetornoWS.DadosRet.TituloRet.NossoNumeroCorrespondente  := LJSONObject.AsString['correlationId'];

                      ARetornoWS.DadosRet.IDBoleto.IDBoleto              := ARetornoWS.DadosRet.TituloRet.NossoNumeroCorrespondente;
                      ARetornoWS.DadosRet.IDBoleto.CodBarras             := ARetornoWS.DadosRet.TituloRet.CodBarras;
                      ARetornoWS.DadosRet.IDBoleto.LinhaDig              := ARetornoWS.DadosRet.TituloRet.LinhaDig;
                      ARetornoWS.DadosRet.IDBoleto.NossoNum              := ARetornoWS.DadosRet.TituloRet.NossoNumero;
                    end;
                end;
              end;
          end;
        end else
        begin
          LJsonErrorArray := LJsonArray.ItemAsJSONObject[0].AsJSONArray['_errors'];
          if LJsonErrorArray.Count > 0  then
          begin
            ARetornoWS.CodRetorno := LJsonArray.ItemAsJSONObject[0].AsString['_errorCode'];
            ARetornoWS.MsgRetorno := LJsonArray.ItemAsJSONObject[0].AsString['_message'];
            for I := 0 to Pred(LJsonErrorArray.Count) do
            begin
              LRejeicao          := ARetornoWS.CriarRejeicaoLista;

              LRejeicao.Codigo   := LJsonErrorArray.ItemAsJSONObject[I].AsString['_code'];
              LRejeicao.Campo    := LJsonErrorArray.ItemAsJSONObject[I].AsString['_field'];
              LRejeicao.Mensagem := LJsonErrorArray.ItemAsJSONObject[I].AsString['_message'];
              LRejeicao.Valor    := '';
            end;
          end;
        end;
      except
        Result := False;
      end;
    finally
     LJsonArray.free;
    end;
  end
  else
  begin
    case HTTPResultCode of
      401 :
      begin
        LRejeicao            := ARetornoWS.CriarRejeicaoLista;
        LRejeicao.Codigo     := '401';
        LRejeicao.Mensagem   := 'N�o autorizado/Autenticado';
        LRejeicao.Ocorrencia := '401 - N�o autorizado/Autenticado';
      end;
      403 :
      begin
        LRejeicao            := ARetornoWS.CriarRejeicaoLista;
        LRejeicao.Codigo     := '403';
        LRejeicao.Mensagem   := 'N�o Autorizado';
        LRejeicao.Ocorrencia := '403 - N�o Autorizado';
      end;
      404 :
      begin
        LRejeicao            := ARetornoWS.CriarRejeicaoLista;
        LRejeicao.Codigo     := '404';
        LRejeicao.Mensagem   := 'Informa��o n�o encontrada';
        LRejeicao.Ocorrencia := '404 - Informa��o n�o encontrada';
      end;
      406 :
      begin
        LRejeicao            := ARetornoWS.CriarRejeicaoLista;
        LRejeicao.Codigo     := '406';
        LRejeicao.Mensagem   := 'O recurso de destino n�o possui uma representa��o atual que seria aceit�vel';
        LRejeicao.Ocorrencia := '406 - O recurso de destino n�o possui uma representa��o atual que seria aceit�vel';
      end;
      500 :
      begin
        LRejeicao            := ARetornoWS.CriarRejeicaoLista;
        LRejeicao.Codigo     := '500';
        LRejeicao.Mensagem   := 'Erro de Servidor, Aplica��o est� fora';
        LRejeicao.Ocorrencia := '500 - Erro de Servidor, Aplica��o est� fora';
      end;
      501 :
      begin
        LRejeicao            := ARetornoWS.CriarRejeicaoLista;
        LRejeicao.Codigo     := '501';
        LRejeicao.Mensagem   := 'Erro de Servidor, Aplica��o est� fora';
        LRejeicao.Ocorrencia := '501 - O servidor n�o oferece suporte � funcionalidade necess�ria para atender � solicita��o';
      end;
    end;
  end;
end;
function TRetornoEnvio_BTGPactual.RetornoEnvio(const AIndex: Integer): Boolean;
begin
  Result:=inherited RetornoEnvio(AIndex);
end;

end.

