{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Victor Hugo Gonzales - Panda                   }
{                               Leandro do Couto                               }
{                               Fernando Henrique                              }
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

unit ACBrBoletoRet_Sicredi_APIECOMM;

interface

uses
  Classes,
  SysUtils,
  ACBrBoleto,
  ACBrBoletoWS,
  ACBrBoletoRetorno,
  Jsons,
  DateUtils,
  pcnConversao,
  ACBrUtil.DateTime,
  ACBrBoletoWS.Rest;

type

{ TRetornoEnvio_Sicredi_APIECOMM }

 TRetornoEnvio_Sicredi_APIECOMM = class(TRetornoEnvioREST)
 private
   function DateSicrediToDateTime(Const AValue : String) : TDateTime;
 public
   constructor Create(ABoletoWS: TACBrBoleto); override;
   destructor  Destroy; Override;
   function LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean; override;
   function LerListaRetorno: Boolean; override;
   function RetornoEnvio(const AIndex: Integer): Boolean; override;

 end;

implementation

uses
  ACBrBoletoConversao;

resourcestring
  C_LIQUIDADO = 'LIQUIDADO';
  C_BAIXADO_POS_SOLICITACAO = 'BAIXADO POR SOLICITACAO';

{ TRetornoEnvio }

constructor TRetornoEnvio_Sicredi_APIECOMM.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);

end;

function TRetornoEnvio_Sicredi_APIECOMM.DateSicrediToDateTime(
  const AValue: String): TDateTime;
begin
  Result :=EncodeDataHora(StringReplace(AValue,'-','/',[rfReplaceAll]));
end;

destructor TRetornoEnvio_Sicredi_APIECOMM.Destroy;
begin
  inherited Destroy;
end;

function TRetornoEnvio_Sicredi_APIECOMM.LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean;
var
  //Retorno: TRetEnvio;
  AJson: TJson;
  AJSonObject: TJsonObject;
  ARejeicao: TACBrBoletoRejeicao;
  AJsonBoletos: TJsonArray;
  TipoOperacao : TOperacao;
begin
  Result := True;
  TipoOperacao := ACBrBoleto.Configuracoes.WebService.Operacao;
  ARetornoWS.HTTPResultCode := HTTPResultCode;
  ARetornoWS.JSONEnvio      := EnvWs;
  ARetornoWS.Header.Operacao := TipoOperacao;
  if RetWS <> '' then
  begin
    //Retorno := ACBrBoleto.CriarRetornoWebNaLista;
    try
      AJSon := TJson.Create;
      try
        AJSon.Parse(RetWS);
        ARetornoWS.JSON := AJson.Stringify;

        case HttpResultCode of
          400, 404 : begin

            if ( AJson.StructType = jsObject ) then
              if( AJson.Values['codigo'].asString <> '' ) then
              begin
                ARejeicao            := ARetornoWS.CriarRejeicaoLista;
                ARejeicao.Codigo     := AJson.Values['codigo'].AsString;
                ARejeicao.Versao     := AJson.Values['parametro'].AsString;
                ARejeicao.Mensagem   := AJson.Values['mensagem'].AsString;
              end;

          end;

        end;

        //retorna quando tiver sucesso
        if (ARetornoWS.ListaRejeicao.Count = 0) then
        begin
          if (TipoOperacao = tpInclui) then
          begin

            ARetornoWS.DadosRet.IDBoleto.CodBarras      := AJson.Values['codigoBarra'].AsString;
            ARetornoWS.DadosRet.IDBoleto.LinhaDig       := AJson.Values['linhaDigitavel'].AsString;
            ARetornoWS.DadosRet.IDBoleto.NossoNum       := AJson.Values['nossoNumero'].AsString;

            ARetornoWS.DadosRet.TituloRet.CodBarras     := ARetornoWS.DadosRet.IDBoleto.CodBarras;
            ARetornoWS.DadosRet.TituloRet.LinhaDig      := ARetornoWS.DadosRet.IDBoleto.LinhaDig;
            ARetornoWS.DadosRet.TituloRet.NossoNumero   := ARetornoWS.DadosRet.IDBoleto.NossoNum;

          end else
          if (TipoOperacao in [tpConsultaDetalhe,tpConsulta]) then
          begin
            AJsonBoletos := TJsonArray.Create;
            try
              AJsonBoletos.Parse( AJson.Stringify );
              if (AJsonBoletos.Count > 0) then
              begin
                AJSonObject  := AJsonBoletos[0].AsObject;

                ARetornoWS.DadosRet.IDBoleto.CodBarras       := '';
                ARetornoWS.DadosRet.IDBoleto.LinhaDig        := '';
                ARetornoWS.DadosRet.IDBoleto.NossoNum        := AJSonObject.Values['nossoNumero'].AsString;
                ARetornoWS.indicadorContinuidade             := false;
                ARetornoWS.DadosRet.TituloRet.CodBarras      := ARetornoWS.DadosRet.IDBoleto.CodBarras;
                ARetornoWS.DadosRet.TituloRet.LinhaDig       := ARetornoWS.DadosRet.IDBoleto.LinhaDig;

                ARetornoWS.DadosRet.TituloRet.NossoNumero                := ARetornoWS.DadosRet.IDBoleto.NossoNum;
                ARetornoWS.DadosRet.TituloRet.Vencimento                 := DateSicrediToDateTime(AJSonObject.Values['dataVencimento'].AsString);
                ARetornoWS.DadosRet.TituloRet.ValorDocumento             := AJSonObject.Values['valor'].AsNumber;
                ARetornoWS.DadosRet.TituloRet.ValorAtual                 := AJSonObject.Values['valor'].AsNumber;
                ARetornoWS.DadosRet.TituloRet.EstadoTituloCobranca       := AJSonObject.Values['situacao'].AsString;
                ARetornoWS.DadosRet.TituloRet.SeuNumero                  := AJSonObject.Values['seuNumero'].AsString;

                if( AJSonObject.Values['situacao'].asString = C_LIQUIDADO ) or
                   ( AJSonObject.Values['situacao'].asString = C_BAIXADO_POS_SOLICITACAO ) then
                begin
                  ARetornoWS.DadosRet.TituloRet.ValorPago                  := AJSonObject.Values['valorLiquidado'].AsNumber;
                  ARetornoWS.DadosRet.TituloRet.DataCredito                := DateSicrediToDateTime(AJSonObject.Values['dataliquidacao'].AsString);
                end;

              end;
            finally
              AJsonBoletos.free;
            end;
          end else
          if (TipoOperacao = tpBaixa) then
          begin
            // n�o possui dados de retorno..
          end else
          if (TipoOperacao = tpAltera) then
          begin
            // n�o possui dados de retorno..
          end;
        end;

      finally
        AJson.free;
      end;

    except
      Result := False;
    end;

  end;

end;

function TRetornoEnvio_Sicredi_APIECOMM.LerListaRetorno: Boolean;
var
  ListaRetorno: TACBrBoletoRetornoWS;
  AJson: TJson;
  AJSonObject: TJsonObject;
  ARejeicao: TACBrBoletoRejeicao;
  AJsonBoletos: TJsonArray;
  I: Integer;
begin
  Result := True;
  ListaRetorno := ACBrBoleto.CriarRetornoWebNaLista;
  ListaRetorno.HTTPResultCode := HTTPResultCode;
  ListaRetorno.JSONEnvio      := EnvWs;
  if RetWS <> '' then
  begin
    
    try
      AJSon := TJson.Create;
      try
        AJSon.Parse(RetWS);

        ListaRetorno.JSON:= RetWS;

        case HTTPResultCode of
          400, 404 : begin
            if ( AJson.StructType = jsObject ) then
              if( AJson.Values['codigo'].asString <> '' ) then
              begin
                ARejeicao            := ListaRetorno.CriarRejeicaoLista;
                ARejeicao.Codigo     := AJson.Values['codigo'].AsString;
                ARejeicao.Versao     := AJson.Values['parametro'].AsString;
                ARejeicao.Mensagem   := AJson.Values['mensagem'].AsString;
              end;
          end;
        end;

        //retorna quando tiver sucesso
        if (ListaRetorno.ListaRejeicao.Count = 0) then
        begin
          AJsonBoletos := TJsonArray.Create;
          try
            AJsonBoletos.Parse( AJson.Stringify );
            for I := 0 to Pred(AJsonBoletos.Count) do
            begin
              if I > 0 then
                ListaRetorno := ACBrBoleto.CriarRetornoWebNaLista;

              AJSonObject  := AJsonBoletos[I].AsObject;

              ListaRetorno.DadosRet.IDBoleto.CodBarras       := '';
              ListaRetorno.DadosRet.IDBoleto.LinhaDig        := '';
              ListaRetorno.DadosRet.IDBoleto.NossoNum        := AJSonObject.Values['nossoNumero'].AsString;
              ListaRetorno.indicadorContinuidade             := false;
              ListaRetorno.DadosRet.TituloRet.CodBarras      := ListaRetorno.DadosRet.IDBoleto.CodBarras;
              ListaRetorno.DadosRet.TituloRet.LinhaDig       := ListaRetorno.DadosRet.IDBoleto.LinhaDig;


              ListaRetorno.DadosRet.TituloRet.NossoNumero                := ListaRetorno.DadosRet.IDBoleto.NossoNum;
              ListaRetorno.DadosRet.TituloRet.Vencimento                 := DateSicrediToDateTime(AJSonObject.Values['dataVencimento'].AsString);
              ListaRetorno.DadosRet.TituloRet.ValorDocumento             := AJSonObject.Values['valor'].AsNumber;
              ListaRetorno.DadosRet.TituloRet.ValorAtual                 := AJSonObject.Values['valor'].AsNumber;

              ListaRetorno.DadosRet.TituloRet.DataRegistro               := DateSicrediToDateTime(AJSonObject.Values['dataemissao'].AsString);
              ListaRetorno.DadosRet.TituloRet.EstadoTituloCobranca       := AJSonObject.Values['situacao'].AsString;
              ListaRetorno.DadosRet.TituloRet.SeuNumero                  := AJSonObject.Values['seuNumero'].AsString;

              if( AJSonObject.Values['situacao'].asString = C_LIQUIDADO ) or
                 ( AJSonObject.Values['situacao'].asString = C_BAIXADO_POS_SOLICITACAO ) then
              begin
                 ListaRetorno.DadosRet.TituloRet.ValorPago                  := AJSonObject.Values['valorLiquidado'].AsNumber;
                 ListaRetorno.DadosRet.TituloRet.DataCredito                := DateSicrediToDateTime(AJSonObject.Values['dataliquidacao'].AsString);
              end;

            end;
          finally
            AJsonBoletos.free;
          end;
        end;

      finally
        AJson.free;
      end;

    except
      Result := False;
    end;

  end;
end;

function TRetornoEnvio_Sicredi_APIECOMM.RetornoEnvio(const AIndex: Integer): Boolean;
begin

  Result:=inherited RetornoEnvio(AIndex);

end;

end.

