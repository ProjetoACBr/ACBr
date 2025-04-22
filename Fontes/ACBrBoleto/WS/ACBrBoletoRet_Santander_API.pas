{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{ Colaboradores nesse arquivo:  J�ter Rabelo Ferreira                          }
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

unit ACBrBoletoRet_Santander_API;

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
  { TRetornoEnvio_Santander }

  TRetornoEnvio_Santander_API = class(TRetornoEnvioREST)
  private
    function RetornaCodigoOcorrencia(pSituacaoGeralBoleto: string): String;

  public
    constructor Create(ABoletoWS: TACBrBoleto); override;
    destructor  Destroy; Override;
    function LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean; override;
    function LerListaRetorno: Boolean; override;
    function RetornoEnvio(const AIndex: Integer): Boolean; override;
  end;


implementation

uses
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  ACBrBoletoConversao,
  StrUtils, ACBrUtil.Base;

{ TRetornoEnvio_Santander_API }

constructor TRetornoEnvio_Santander_API.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);
end;

destructor TRetornoEnvio_Santander_API.Destroy;
begin
  inherited Destroy;
end;

function TRetornoEnvio_Santander_API.LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean;
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
                  200,
                  201 :
                  begin
                    LJSONObject := LJsonArray.ItemAsJSONObject[0];
                    if LJSONObject.ValueExists('barCode') then
                      ARetornoWS.DadosRet.IDBoleto.CodBarras                     := LJSONObject.AsString['barCode']
                    else
                      ARetornoWS.DadosRet.IDBoleto.CodBarras                     := LJSONObject.AsString['barcode'];
                    ARetornoWS.DadosRet.IDBoleto.LinhaDig                      := LJSONObject.AsString['digitableLine'];
                    ARetornoWS.DadosRet.IDBoleto.NossoNum                      := LJSONObject.AsString['bankNumber'];

                    ARetornoWS.DadosRet.TituloRet.Vencimento                   := StringToDateTimeDef(LJSONObject.AsString['dueDate'], 0, 'yyyy-mm-dd');
                    ARetornoWS.DadosRet.TituloRet.NossoNumero                  := LJSONObject.AsString['bankNumber'];
                    ARetornoWS.DadosRet.TituloRet.SeuNumero                    := LJSONObject.AsString['clientNumber'];
                    ARetornoWS.DadosRet.TituloRet.CodBarras                    := ARetornoWS.DadosRet.IDBoleto.CodBarras;
                    ARetornoWS.DadosRet.TituloRet.LinhaDig                     := LJSONObject.AsString['digitableLine'];
                    ARetornoWS.DadosRet.TituloRet.DataProcessamento            := StringToDateTimeDef(LJSONObject.AsString['entryDate'], 0, 'yyyy-mm-dd');
                    ARetornoWS.DadosRet.TituloRet.DataDocumento                :=  StringToDateTimeDef(LJSONObject.AsString['issueDate'], 0, 'yyyy-mm-dd');
                    ARetornoWS.DadosRet.TituloRet.ValorDocumento               := StrToFloatDef( LJSONObject.AsString['nominalValue'], 0);
                    ARetornoWS.DadosRet.TituloRet.EMV                          := LJSONObject.AsString['qrCodePix'];
                    ARetornoWS.DadosRet.TituloRet.UrlPix                       := LJSONObject.AsString['qrCodeUrl'];
                    ARetornoWS.DadosRet.TituloRet.TxId                         := LJSONObject.AsString['txId'];

                    LJSONObject := LJsonArray.ItemAsJSONObject[0].AsJSONObject['payer'];
                    ARetornoWS.DadosRet.TituloRet.Sacado.CNPJCPF               := LJSONObject.AsString['documentNumber'];
                    ARetornoWS.DadosRet.TituloRet.Sacado.NomeSacado            := LJSONObject.AsString['name'];
                    ARetornoWS.DadosRet.TituloRet.Sacado.Logradouro            := LJSONObject.AsString['address'];
                    ARetornoWS.DadosRet.TituloRet.Sacado.Bairro                := LJSONObject.AsString['neighborhood'];
                    ARetornoWS.DadosRet.TituloRet.Sacado.Cidade                := LJSONObject.AsString['city'];
                    ARetornoWS.DadosRet.TituloRet.Sacado.UF                    := LJSONObject.AsString['state'];
                    ARetornoWS.DadosRet.TituloRet.Sacado.Cep                   := LJSONObject.AsString['zipCode'];

                    LJSONObject := LJsonArray.ItemAsJSONObject[0].AsJSONObject['beneficiary'];
                    ARetornoWS.DadosRet.TituloRet.SacadoAvalista.CNPJCPF       := LJSONObject.AsString['documentNumber'];
                    ARetornoWS.DadosRet.TituloRet.SacadoAvalista.NomeAvalista  := LJSONObject.AsString['name'];
                  end;
                end;
              end;
            tpConsultaDetalhe :
              begin
                case HTTPResultCode of
                  200 :
                    begin
                      LTotalObjetos := LJsonArray.Count;
                      LJSONObject := LJsonArray.ItemAsJSONObject[0];
                      ARetornoWS.DadosRet.TituloRet.NossoNumero          := LJSONObject.AsString['bankNumber'];
                      ARetornoWS.DadosRet.TituloRet.SeuNumero            := LJSONObject.AsString['clientNumber'];
                      ARetornoWS.DadosRet.TituloRet.Vencimento           := StringToDateTimeDef(LJSONObject.AsString['dueDate'], 0, 'yyyy-mm-dd');
                      ARetornoWS.DadosRet.TituloRet.DataDocumento        := StringToDateTimeDef(LJSONObject.AsString['issueDate'], 0, 'yyyy-mm-dd');
                      ARetornoWS.DadosRet.TituloRet.ValorDocumento       := LJSONObject.AsFloat['nominalValue'];
                      ARetornoWS.DadosRet.TituloRet.EstadoTituloCobranca := LJSONObject.AsString['status'];
                      ARetornoWS.DadosRet.TituloRet.CodigoEstadoTituloCobranca := RetornaCodigoOcorrencia(LJSONObject.AsString['status']);

                      if LJSONObject.ValueExists('bankSlipData') then
                      begin
                        LExisteBankSlip := true;
                        LJSONObject := LJsonArray.ItemAsJSONObject[0].AsJSONObject['bankSlipData'];
                        ARetornoWS.DadosRet.TituloRet.DataProcessamento     := StringToDateTimeDef(LJSONObject.AsString['processingDate'], 0, 'yyyy-mm-dd');
                        ARetornoWS.DadosRet.TituloRet.DataRegistro          := StringToDateTimeDef(LJSONObject.AsString['entryDate'], 0, 'yyyy-mm-dd');
                        ARetornoWS.DadosRet.TituloRet.DiasDeProtesto        := LJSONObject.AsInteger['protestQuantityDays'];
                        ARetornoWS.DadosRet.TituloRet.QtdeParcelas          := LJSONObject.AsInteger['parcelsQuantity'];
                        ARetornoWS.DadosRet.TituloRet.QtdePagamentoParcial  := LJSONObject.AsInteger['paidParcelsQuantity'];
                        ARetornoWS.DadosRet.TituloRet.ValorRecebido         := LJSONObject.AsFloat['amountReceived'];
                        ARetornoWS.DadosRet.TituloRet.ValorMoraJuros        := LJSONObject.AsFloat['interestPercentage'];
                        ARetornoWS.DadosRet.TituloRet.LinhaDig              := LJSONObject.AsString['digitableLine'];
                        if LJSONObject.ValueExists('barCode') then
                          ARetornoWS.DadosRet.TituloRet.CodBarras           := LJSONObject.AsString['barCode']
                        else
                          ARetornoWS.DadosRet.TituloRet.CodBarras           := LJSONObject.AsString['barcode'];
                        // payerData
                        LJSONObject := LJsonArray.ItemAsJSONObject[0].AsJSONObject['payerData'];
                        ARetornoWS.DadosRet.TituloRet.Sacado.CNPJCPF    := LJSONObject.AsString['payerDocumentNumber'];
                        ARetornoWS.DadosRet.TituloRet.Sacado.NomeSacado := LJSONObject.AsString['payerName'];
                        ARetornoWS.DadosRet.TituloRet.Sacado.Logradouro := LJSONObject.AsString['payerAddress'];
                        ARetornoWS.DadosRet.TituloRet.Sacado.Bairro     := LJSONObject.AsString['payerNeighborhood'];
                        ARetornoWS.DadosRet.TituloRet.Sacado.Cidade     := LJSONObject.AsString['payerCounty'];
                        ARetornoWS.DadosRet.TituloRet.Sacado.UF         := LJSONObject.AsString['payerStateAbbreviation'];
                        ARetornoWS.DadosRet.TituloRet.Sacado.Cep        := LJSONObject.AsString['payerZipCode'];
                        if LJsonArray.ItemAsJSONObject[0].ValueExists('qrCodeData') then
                        begin
                          LJSONObject := LJsonArray.ItemAsJSONObject[0].AsJSONObject['qrCodeData'];
                          ARetornoWS.DadosRet.TituloRet.EMV               := LJSONObject.AsString['qrCode'];
                        end;
                      end;
                      //consulta nosso numero  NN
                      //Se a qtde objeto da resposta > 1 a lista para ler _content = 1
                      //caso exista apenas um obj na resposta a lista inicia no 0
                      if LExisteBankSlip then
                         nIndiceOBJ := strtoint(IfThen(LTotalObjetos>1,'1','0'))
                      else
                         nIndiceOBJ := 0;
                      LJSONObject := LJsonArray.ItemAsJSONObject[nIndiceOBJ];
                      if nIndiceOBJ = 0 then
                      begin
                        ARetornoWS.DadosRet.TituloRet.NossoNumero                 := LJSONObject.AsString['bankNumber'];
                        ARetornoWS.DadosRet.TituloRet.SeuNumero                   := LJSONObject.AsString['clientNumber'];
                        if ARetornoWS.DadosRet.TituloRet.Vencimento = 0 then
                         ARetornoWS.DadosRet.TituloRet.Vencimento                  := StringToDateTimeDef(LJSONObject.AsString['dueDate'], 0, 'yyyy-mm-dd');
                        if ARetornoWS.DadosRet.TituloRet.DataDocumento = 0 then
                         ARetornoWS.DadosRet.TituloRet.DataDocumento               := StringToDateTimeDef(LJSONObject.AsString['issueDate'], 0, 'yyyy-mm-dd');
                        if ARetornoWS.DadosRet.TituloRet.ValorDocumento = 0 then
                         ARetornoWS.DadosRet.TituloRet.ValorDocumento              := LJSONObject.AsFloat['nominalValue'];
                        if NaoEstaVazio(ARetornoWS.DadosRet.TituloRet.EstadoTituloCobranca) then
                         ARetornoWS.DadosRet.TituloRet.CodigoEstadoTituloCobranca := RetornaCodigoOcorrencia(LJSONObject.AsString['status']);
                      end;

                      if EstaVazio(ARetornoWS.DadosRet.TituloRet.CodigoEstadoTituloCobranca) then
                       ARetornoWS.DadosRet.TituloRet.CodigoEstadoTituloCobranca := RetornaCodigoOcorrencia(LJSONObject.AsString['status']);

                      ARetornoWS.DadosRet.TituloRet.ValorDesconto               := LJSONObject.AsFloat['discountValue'];
                      ARetornoWS.DadosRet.TituloRet.ValorPago                   := LJSONObject.AsFloat['paidValue'];
                      ARetornoWS.DadosRet.TituloRet.ValorMoraJuros              := LJSONObject.AsFloat['interestValue'];
                      ARetornoWS.DadosRet.TituloRet.ValorAbatimento             := LJSONObject.AsFloat['deductionValue'];

                      if LExisteBankSlip then
                         nIndiceOBJ := strtoint(IfThen(LTotalObjetos>2,'2','1'))
                      else
                         nIndiceOBJ := strtoint(IfThen(LTotalObjetos>1,'1','0'));
                      //settlementData consulta para pegar data do pagamento
                      if (LJsonArray.ItemAsJSONObject[nIndiceOBJ].AsJSONArray['settlementData'].Count > 0) then
                      begin
                        if LJsonArray.ItemAsJSONObject[nIndiceOBJ].ValueExists('settlementData') then
                        begin
                          LJSONObject := LJsonArray.ItemAsJSONObject[nIndiceOBJ].AsJSONArray['settlementData'].ItemAsJSONObject[0];
                          if ARetornoWS.DadosRet.TituloRet.DataCredito = 0 then
                           ARetornoWS.DadosRet.TituloRet.DataCredito := StringToDateTimeDef(LJSONObject.AsString['settlementCreditDate'], 0, 'yyyy-mm-dd');
                          if ARetornoWS.DadosRet.TituloRet.DataMovimento = 0 then
                           ARetornoWS.DadosRet.TituloRet.DataMovimento := StringToDateTimeDef(LJSONObject.AsString['settlementDate'], 0, 'yyyy-mm-dd');
                          if ARetornoWS.DadosRet.TituloRet.DataBaixa = 0 then
                           ARetornoWS.DadosRet.TituloRet.DataBaixa := StringToDateTimeDef(LJSONObject.AsString['settlementDate'], 0, 'yyyy-mm-dd');
                           ARetornoWS.DadosRet.TituloRet.ValorPago := LJSONObject.AsCurrency['settlementCreditedValue'];
                          if EstaVazio(ARetornoWS.DadosRet.TituloRet.CodigoEstadoTituloCobranca) then
                            ARetornoWS.DadosRet.TituloRet.CodigoEstadoTituloCobranca := RetornaCodigoOcorrencia(LJSONObject.AsString['status']);
                          if EstaVazio(ARetornoWS.DadosRet.TituloRet.EstadoTituloCobranca) then
                           ARetornoWS.DadosRet.TituloRet.EstadoTituloCobranca := LJSONObject.AsString['status'];
                          ARetornoWS.DadosRet.TituloRet.ValorTarifa :=  LJSONObject.AsFloat['settlementDutyValue'];
                        end;
                      end;
                      if (LJsonArray.ItemAsJSONObject[nIndiceOBJ].AsJSONArray['writeOffData'].Count > 0) then
                      begin
                        if LJsonArray.ItemAsJSONObject[nIndiceOBJ].ValueExists('writeOffData') then
                        begin
                          LJSONObject := LJsonArray.ItemAsJSONObject[nIndiceOBJ].AsJSONArray['writeOffData'].ItemAsJSONObject[0];
                          if ARetornoWS.DadosRet.TituloRet.DataBaixa = 0 then
                           ARetornoWS.DadosRet.TituloRet.DataBaixa := StringToDateTimeDef(LJSONObject.AsString['writeOffDate'], 0, 'yyyy-mm-dd');
                          if ARetornoWS.DadosRet.TituloRet.ValorPago = 0 then
                           ARetornoWS.DadosRet.TituloRet.ValorPago := LJSONObject.AsFloat['writeOffValue'];
                          if EstaVazio(ARetornoWS.DadosRet.TituloRet.CodigoEstadoTituloCobranca) then
                           ARetornoWS.DadosRet.TituloRet.CodigoEstadoTituloCobranca := RetornaCodigoOcorrencia(LJSONObject.AsString['status']);
                        end;
                      end;
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

function TRetornoEnvio_Santander_API.LerListaRetorno: Boolean;
var
  LJsonObject, LItemObject, LPagObject, LPaginacaoObject, LErrosObject, LPayerObject: TACBrJSONObject;
  LJsonArray, LJsonArrayErros: TACBrJSONArray;
  LListaRetorno: TACBrBoletoRetornoWS;
  LMensagemRejeicao: TACBrBoletoRejeicao;
  I: Integer;
begin
  Result := True;

  LListaRetorno := ACBrBoleto.CriarRetornoWebNaLista;
  LListaRetorno.HTTPResultCode := HTTPResultCode;
  LListaRetorno.JSONEnvio      := EnvWs;

  if RetWS <> '' then
  begin
    try
      LJsonObject := TACBrJSONObject.Parse(RetWS);
      try
        LListaRetorno.JSON           := LJsonObject.ToJSON;
        //retorna quando houver erro

        case HTTPResultCode of
          400, 410 :
          begin
            if LJsonObject.IsJSONArray('_errors') then
            begin
              LJsonArrayErros := LJsonObject.AsJSONArray['_errors'];
              for I := 0 to Pred(LJsonArrayErros.Count) do
              begin
                LErrosObject                 := LJsonArray.ItemAsJSONObject[I];
                LMensagemRejeicao            := LListaRetorno.CriarRejeicaoLista;
                LMensagemRejeicao.Codigo     := LErrosObject.AsString['_code'];
                LMensagemRejeicao.Versao     := LErrosObject.AsString['_field'];
                LMensagemRejeicao.Mensagem   := LErrosObject.AsString['_message'];
                LMensagemRejeicao.Ocorrencia := LErrosObject.AsString['_field'];
              end;
            end;
          end;

          401,403,406,500 :
          begin
            LMensagemRejeicao            := LListaRetorno.CriarRejeicaoLista;
            case HTTPResultCode of
            401: LMensagemRejeicao.Mensagem   := LErrosObject.AsString['Unauthorized'];
            403: LMensagemRejeicao.Mensagem   := LErrosObject.AsString['Forbidden'];
            406: LMensagemRejeicao.Mensagem   := LErrosObject.AsString['Not Acceptable'];
            500: LMensagemRejeicao.Mensagem   := LErrosObject.AsString['Internal Server Error'];
            end;
            LMensagemRejeicao.Codigo     := inttostr(HTTPResultCode);
          end;
        end;

        //retorna quando tiver sucesso
        if (LListaRetorno.ListaRejeicao.Count = 0) then
        begin
          LPaginacaoObject := LJsonObject.AsJSONObject['_pageable'];
          //utilizando campos _offset, _pageElements e _totalElements pois os campos _pageNumber e _totalPages est�o voltando sempre null
          if (LPaginacaoObject.AsInteger['_offset'] + LPaginacaoObject.AsInteger['_pageElements']) < LPaginacaoObject.AsInteger['_totalElements'] then
          begin
            LListaRetorno.indicadorContinuidade := True;
            LListaRetorno.proximoIndice := (Trunc(ACBrBoleto.Configuracoes.WebService.Filtro.indiceContinuidade)+1)
          end
          else
          begin
            LListaRetorno.indicadorContinuidade := False;
            LListaRetorno.proximoIndice := 0;
          end;

          LJsonArray := LJsonObject.AsJSONArray['_content'];
          //LListaRetorno.indicadorContinuidade := LJsonObject.AsBoolean['hasNext'];
          for I := 0 to Pred(LJsonArray.Count) do
          begin
            if I > 0 then
              LListaRetorno := ACBrBoleto.CriarRetornoWebNaLista;

            LItemObject  := LJsonArray.ItemAsJSONObject[I];

            LListaRetorno.DadosRet.IDBoleto.CodBarras      := '';
            LListaRetorno.DadosRet.IDBoleto.LinhaDig       := '';
            LListaRetorno.DadosRet.IDBoleto.NossoNum       := LItemObject.AsString['bankNumber'];
            LListaRetorno.DadosRet.TituloRet.Contrato      := LItemObject.AsString['covenantCode'];
            LListaRetorno.DadosRet.TituloRet.CodigoEstadoTituloCobranca  :=  RetornaCodigoOcorrencia(LItemObject.AsString['status']);
            LListaRetorno.DadosRet.TituloRet.EstadoTituloCobranca        :=  LItemObject.AsString['status'] +' - '+ LItemObject.AsString['statusComplement'];

            LListaRetorno.DadosRet.IDBoleto.CodBarras := LItemObject.AsString['barcode'];
            LListaRetorno.DadosRet.IDBoleto.LinhaDig  := LItemObject.AsString['digitableLine'];

            LListaRetorno.DadosRet.TituloRet.CodBarras      := LListaRetorno.DadosRet.IDBoleto.CodBarras;
            LListaRetorno.DadosRet.TituloRet.LinhaDig       := LListaRetorno.DadosRet.IDBoleto.LinhaDig;
            LListaRetorno.DadosRet.TituloRet.SeuNumero      := LItemObject.AsString['clientNumber'];
            LListaRetorno.DadosRet.TituloRet.NossoNumero    := LListaRetorno.DadosRet.IDBoleto.NossoNum;

            LListaRetorno.DadosRet.TituloRet.Vencimento     := StringToDateTimeDef(LItemObject.AsString['dueDate'], 0, 'yyyy-mm-dd');
            LListaRetorno.DadosRet.TituloRet.DataDocumento  := StringToDateTimeDef(LItemObject.AsString['issueDate'], 0, 'yyyy-mm-dd');
            LListaRetorno.DadosRet.TituloRet.DataRegistro   := StringToDateTimeDef(LItemObject.AsString['issueDate'], 0, 'yyyy-mm-dd');

            LListaRetorno.DadosRet.TituloRet.valorAtual     := LItemObject.AsFloat['nominalValue'];
            LListaRetorno.DadosRet.TituloRet.ValorDocumento := LItemObject.AsFloat['nominalValue'];

            LPagObject := LJsonArray.ItemAsJSONObject[I].AsJSONObject['payment'];
            LListaRetorno.DadosRet.TituloRet.DataBaixa      := StringToDateTimeDef(LPagObject.AsString['date'], 0, 'yyyy-mm-dd');
            LListaRetorno.DadosRet.TituloRet.DataMovimento  := StringToDateTimeDef(LPagObject.AsString['date'], 0, 'yyyy-mm-dd');
            LListaRetorno.DadosRet.TituloRet.DataProcessamento := StringToDateTimeDef(LPagObject.AsString['date'], 0, 'yyyy-mm-dd');
            LListaRetorno.DadosRet.TituloRet.DataCredito       := StringToDateTimeDef(LPagObject.AsString['date'], 0, 'yyyy-mm-dd');

            LListaRetorno.DadosRet.TituloRet.ValorRecebido              := LPagObject.AsFloat['paidValue'];
            LListaRetorno.DadosRet.TituloRet.ValorPago                  := LPagObject.AsFloat['paidValue'];
            //LListaRetorno.DadosRet.TituloRet.ValorRecebido              := LPagObject.AsFloat['valorLiquidado'];
            LListaRetorno.DadosRet.TituloRet.ValorMulta                 := LPagObject.AsFloat['fineValue'];
            LListaRetorno.DadosRet.TituloRet.ValorMoraJuros             := LPagObject.AsFloat['interestValue'];

            LListaRetorno.DadosRet.TituloRet.ValorAbatimento            := LPagObject.AsFloat['deductionValue'];
            LListaRetorno.DadosRet.TituloRet.ValorDesconto              := LPagObject.AsFloat['rebateValue'];
            LListaRetorno.DadosRet.TituloRet.ValorIOF                   := LPagObject.AsFloat['iofValue'];
            LListaRetorno.DadosRet.TituloRet.LiquidadoBanco             := strtoint(LPagObject.AsString['bankCode']);

            LPayerObject := LJsonArray.ItemAsJSONObject[I].AsJSONObject['payer'];
            LListaRetorno.DadosRet.TituloRet.Sacado.NomeSacado := LPayerObject.AsString['name'];
            LListaRetorno.DadosRet.TituloRet.Sacado.CNPJCPF    := LPayerObject.AsString['documentNumber'];
          end;
        end;
      finally
        LJsonObject.free;
      end;
    except
      Result := False;
    end;
  end else
  begin
    case HTTPResultCode of
      400 :
        begin
          LMensagemRejeicao            := LListaRetorno.CriarRejeicaoLista;
          LMensagemRejeicao.Codigo     := '400';
          LMensagemRejeicao.Mensagem   := Msg;
        end;
      404 :
        begin
          LMensagemRejeicao            := LListaRetorno.CriarRejeicaoLista;
          LMensagemRejeicao.Codigo     := '404';
          LMensagemRejeicao.Mensagem   := 'N�O ENCONTRADO. O servidor n�o conseguiu encontrar o recurso solicitado.';
        end;
      503 :
        begin
          LMensagemRejeicao            := LListaRetorno.CriarRejeicaoLista;
          LMensagemRejeicao.Codigo     := '503';
          LMensagemRejeicao.Versao     := 'ERRO INTERNO SICREDI';
          LMensagemRejeicao.Mensagem   := 'SERVI�O INDISPON�VEL. O servidor est� impossibilitado de lidar com a requisi��o no momento. Tente mais tarde.';
          LMensagemRejeicao.Ocorrencia := 'ERRO INTERNO nos servidores do Sicredi.';
        end;
    end;
  end;
end;


function TRetornoEnvio_Santander_API.RetornoEnvio(const AIndex: Integer): Boolean;
begin
  Result:=inherited RetornoEnvio(AIndex);
end;

function TRetornoEnvio_Santander_API.RetornaCodigoOcorrencia(pSituacaoGeralBoleto: string) : String;
begin
  if (pSituacaoGeralBoleto  = 'ATIVO') then
    Result := '02'
  else if (pSituacaoGeralBoleto  = 'LIQUIDADO') then
    Result := '06'
  else if (pSituacaoGeralBoleto  = 'BAIXADO') then
    Result := '09'
  else
    Result := '99';
end;


end.

