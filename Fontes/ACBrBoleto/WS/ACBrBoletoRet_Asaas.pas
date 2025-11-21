{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor Hugo Gonzales - Pandaaa                  }
{                                                                              }
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

//incluido em : 04/10/2025

unit ACBrBoletoRet_Asaas;

interface

uses
  SysUtils,
  ACBrBoleto,
  ACBrBoletoWS.Rest,
  ACBrBoletoRetorno;

type

{ TRetornoEnvio_Asaas }

  EACBrBoletoWSRetAsaasException = class(Exception);
  TRetornoEnvio_Asaas = class(TRetornoEnvioREST)
  private
    function StrDatetoTDateTime(const AValue : String) : TDateTime;
  public
    constructor Create(ABoletoWS: TACBrBoleto); override;
    destructor Destroy; override;
    function LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean; override;
    function LerListaRetorno: Boolean; override;
    function RetornoEnvio(const AIndex: Integer): Boolean; override;
    function RetornaCodigoOcorrencia(const ASituacaoBoleto: string) : String;

  end;

implementation

uses
  ACBrBoletoConversao,
  ACBrJSON,
  ACBrUtil.DateTime;

{ TRetornoEnvio }

constructor TRetornoEnvio_Asaas.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);
end;

destructor TRetornoEnvio_Asaas.Destroy;
begin
  inherited Destroy;
end;

function TRetornoEnvio_Asaas.LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean;
var
  LJson, LJsonObject: TACBrJSONObject;
  LJsonArray : TACBrJSONArray;
  ARejeicao: TACBrBoletoRejeicao;
  TipoOperacao: TOperacao;
  I: Integer;
begin
  Result                     := True;
  TipoOperacao               := ACBrBoleto.Configuracoes.WebService.Operacao;
  ARetornoWS.HTTPResultCode  := HTTPResultCode;
  ARetornoWS.JSONEnvio       := EnvWs;
  ARetornoWS.Header.Operacao := TipoOperacao;

  if RetWS <> '' then
  begin
    LJson := TACBrJSONObject.Parse(RetWS);
    try
      try
        ARetornoWS.JSON := LJson.ToJSON;
        if HttpResultCode >= 400 then
        begin
          LJsonArray := LJson.AsJSONArray['errors'];
          for I := 0 to Pred(LJsonArray.Count) do
          begin
            ARejeicao          := ARetornoWS.CriarRejeicaoLista;
            ARejeicao.Codigo   := LJsonArray.ItemAsJSONObject[I].AsString['code'];
            if LJsonArray.ItemAsJSONObject[I].ValueExists('message') then
              ARejeicao.Mensagem := LJsonArray.ItemAsJSONObject[I].AsString['message']
            else
            if LJsonArray.ItemAsJSONObject[I].ValueExists('description') then
              ARejeicao.Mensagem := LJsonArray.ItemAsJSONObject[I].AsString['description'];
          end;
        end;

        if (ARetornoWS.ListaRejeicao.Count = 0) then
        begin
          case TipoOperacao of
            tpInclui,
            tpAltera :
              begin
                ARetornoWS.DadosRet.TituloRet.SeuNumero   := LJson.AsString['externalReference'];
                ARetornoWS.DadosRet.IDBoleto.IDBoleto     := LJson.AsString['id'];
                ARetornoWS.DadosRet.TituloRet.NossoNumeroCorrespondente := LJson.AsString['id'];
                ARetornoWS.DadosRet.TituloRet.DataDocumento := StrDatetoTDateTime(LJson.AsString['dateCreated']);
                ARetornoWS.DadosRet.TituloRet.CodigoCliente := LJson.AsString['customer'];
                ARetornoWS.DadosRet.TituloRet.ValorDocumento := LJson.AsFloat['value'];
                ARetornoWS.DadosRet.TituloRet.Mensagem.Text  := LJson.AsString['description'];
                ARetornoWS.DadosRet.TituloRet.Vencimento     := StrDatetoTDateTime(LJson.AsString['dueDate']);
                ARetornoWS.DadosRet.IDBoleto.NossoNum        := LJson.AsString['nossoNumero'];
                ARetornoWS.DadosRet.IDBoleto.URLPDF       := LJson.AsString['bankSlipUrl'];
                ARetornoWS.DadosRet.TituloRet.URL         := ARetornoWS.DadosRet.IDBoleto.URLPDF;
                ARetornoWS.DadosRet.TituloRet.NossoNumero := ARetornoWS.DadosRet.IDBoleto.NossoNum;
                ARetornoWS.DadosRet.IDBoleto.CodBarras    := ACBrBoleto.Banco.MontarCodigoBarras(ACBrTitulo);
                ARetornoWS.DadosRet.TituloRet.CodBarras   := ARetornoWS.DadosRet.IDBoleto.CodBarras;
                ARetornoWS.DadosRet.IDBoleto.LinhaDig     := ACBrBoleto.Banco.ConverterCodigoBarrasITF25ParaLinhaDigitavel(ARetornoWS.DadosRet.IDBoleto.CodBarras);
                ARetornoWS.DadosRet.TituloRet.LinhaDig    := ARetornoWS.DadosRet.IDBoleto.LinhaDig;
              end;
            tpBaixa,
            tpCancelar :
              begin
                ARetornoWS.DadosRet.ControleNegocial.Retorno := BoolToStr(LJson.AsBoolean['deleted']);
                ARetornoWS.DadosRet.ControleNegocial.CodRetorno := IntToStr(HTTPResultCode);
                ARetornoWS.DadosRet.IDBoleto.IDBoleto     := LJson.AsString['id'];
                ARetornoWS.DadosRet.TituloRet.NossoNumeroCorrespondente := LJson.AsString['id'];
              end;
            tpConsultaDetalhe :
              begin
                ARetornoWS.DadosRet.IDBoleto.IDBoleto     := LJson.AsString['id'];
                ARetornoWS.DadosRet.TituloRet.NossoNumeroCorrespondente := LJson.AsString['id'];

                ARetornoWS.DadosRet.TituloRet.DataDocumento := StrDatetoTDateTime(LJson.AsString['dateCreated']);
                ARetornoWS.DadosRet.TituloRet.CodigoCliente := LJson.AsString['customer'];

                ARetornoWS.DadosRet.IDBoleto.NossoNum     := LJson.AsString['nossoNumero'];
                ARetornoWS.DadosRet.TituloRet.NossoNumero := ARetornoWS.DadosRet.IDBoleto.NossoNum;

                ARetornoWS.DadosRet.IDBoleto.URLPDF       := LJson.AsString['bankSlipUrl'];
                ARetornoWS.DadosRet.TituloRet.URL         := ARetornoWS.DadosRet.IDBoleto.URLPDF;

                ARetornoWS.DadosRet.TituloRet.SeuNumero   := LJson.AsString['externalReference'];
                ARetornoWS.DadosRet.TituloRet.Vencimento     := StrDatetoTDateTime(LJson.AsString['dueDate']);
                ARetornoWS.DadosRet.TituloRet.ValorDocumento := LJSON.AsFloat['value'];
                ARetornoWS.DadosRet.TituloRet.ValorAtual     := LJSON.AsFloat['value'];
                ARetornoWS.DadosRet.TituloRet.ValorPago      := LJSON.AsFloat['originalValue'];
                ARetornoWS.DadosRet.TituloRet.ValorRecebido  := LJSON.AsFloat['netValue'];

                if LJSON.AsJSONObject['fine'].AsFloat['value'] > 0 then
                begin
                  ARetornoWS.DadosRet.TituloRet.ValorMulta := LJSON.AsJSONObject['fine'].AsFloat['value'];
                end else
                begin
                  ARetornoWS.DadosRet.TituloRet.PercentualMulta := 0;
                  ARetornoWS.DadosRet.TituloRet.ValorMulta      := 0;
                end;

                if LJSON.AsJSONObject['interest'].AsFloat['value'] > 0  then
                begin
                  ARetornoWS.DadosRet.TituloRet.ValorMoraJuros := LJSON.AsJSONObject['interest'].AsFloat['value'];
                  ARetornoWS.DadosRet.TituloRet.CodigoMoraJuros := cjValorDia;
                end else
                begin
                  ARetornoWS.DadosRet.TituloRet.ValorMoraJuros := 0;
                  ARetornoWS.DadosRet.TituloRet.CodigoMoraJuros := cjIsento;
                end;

                ARetornoWS.DadosRet.TituloRet.ValorDesconto  := LJSON.AsJSONObject['discount'].AsFloat['value'];

                if LJSON.AsJSONObject['discount'].AsString['type'] = 'FIXED'  then
                  ARetornoWS.DadosRet.TituloRet.CodigoDesconto := cdValorFixo
                else if LJSON.AsJSONObject['discount'].AsString['type'] = 'PERCENTAGE' then
                  ARetornoWS.DadosRet.TituloRet.CodigoDesconto := cdPercentual
                else
                begin
                  ARetornoWS.DadosRet.TituloRet.ValorDesconto  := 0;
                  ARetornoWS.DadosRet.TituloRet.CodigoDesconto := cdSemDesconto;
                end;
                ARetornoWS.DadosRet.TituloRet.EstadoTituloCobranca := LJSON.AsString['status'];
                ARetornoWS.DadosRet.TituloRet.CodigoEstadoTituloCobranca := RetornaCodigoOcorrencia(ARetornoWS.DadosRet.TituloRet.EstadoTituloCobranca);
                ARetornoWS.DadosRet.TituloRet.DataCredito          := StrDatetoTDateTime(LJSON.AsString['clientPaymentDate']);
              end;
            tpPIXConsultar :
              begin
                if LJSON.IsJSONObject('pix') then
                begin
                  LJsonObject := LJSON.AsJSONObject['pix'];

                  ARetornoWS.DadosRet.TituloRet.UrlPix := LJsonObject.AsString['payload'];
                  ARetornoWS.DadosRet.TituloRet.EMV := ARetornoWS.DadosRet.TituloRet.UrlPix;
                end;

                if LJSON.IsJSONObject('bankSlip') then
                begin
                  LJsonObject := LJSON.AsJSONObject['bankSlip'];

                  if LJsonObject.ValueExists('nossoNumero') then
                  begin
                    ARetornoWS.DadosRet.IDBoleto.NossoNum := LJsonObject.AsString['nossoNumero'];
                    ARetornoWS.DadosRet.TituloRet.NossoNumero := ARetornoWS.DadosRet.IDBoleto.NossoNum;
                  end;

                  if LJsonObject.ValueExists('barCode') then
                  begin
                    ARetornoWS.DadosRet.IDBoleto.CodBarras := LJsonObject.AsString['barCode'];
                    ARetornoWS.DadosRet.TituloRet.CodBarras := ARetornoWS.DadosRet.IDBoleto.CodBarras;
                  end;

                  if LJsonObject.ValueExists('identificationField') then
                  begin
                    ARetornoWS.DadosRet.IDBoleto.LinhaDig := LJsonObject.AsString['identificationField'];
                    ARetornoWS.DadosRet.TituloRet.LinhaDig := ARetornoWS.DadosRet.IDBoleto.LinhaDig;
                  end;

                  if LJsonObject.ValueExists('bankSlipUrl') then
                  begin
                    ARetornoWS.DadosRet.IDBoleto.URLPDF := LJsonObject.AsString['bankSlipUrl'];
                    ARetornoWS.DadosRet.TituloRet.URL := ARetornoWS.DadosRet.IDBoleto.URLPDF;
                  end;
                end;
              end;
            else
              raise EACBrBoletoWSRetAsaasException.Create('TipoOperacao não mapeada para '+ ClassName);
          end;
        end;
      except
        Result := False;
      end;
    finally
      LJson.free;
    end;
  end;
end;

function TRetornoEnvio_Asaas.LerListaRetorno: Boolean;
var
  LJSON, LJSONObject : TACBrJsonObject;
  LJSONArray : TACBrJSONArray;
  ListaRetorno: TACBrBoletoRetornoWS;
  ARejeicao: TACBrBoletoRejeicao;
  I: Integer;
begin
  Result                       := True;
  ListaRetorno                 := ACBrBoleto.CriarRetornoWebNaLista;
  ListaRetorno.HTTPResultCode  := HTTPResultCode;
  ListaRetorno.JSONEnvio       := EnvWs;
  ListaRetorno.Header.Operacao := ACBrBoleto.Configuracoes.WebService.Operacao;

  if RetWS <> '' then
  begin
    try
      LJSON := TACBrJsonObject.Parse(RetWS);
      try
        ListaRetorno.JSON := LJSON.ToJSON;

        if HTTPResultCode >= 400 then
        begin
          if (LJSON.ValueExists('message') and (LJSON.AsString['message'] <> '')) or
             (LJSON.ValueExists('description') and (LJSON.AsString['description'] <> ''))then
          begin
            ARejeicao := ListaRetorno.CriarRejeicaoLista;
            ARejeicao.Codigo   := LJSON.AsString['codigo'];
            ARejeicao.Versao   := LJSON.AsString['parametro'];
            if LJSON.ValueExists('message') then
              ARejeicao.Mensagem := LJSON.AsString['message']
            else if LJSON.ValueExists('description') then
              ARejeicao.Mensagem := LJSON.AsString['description'];
          end;
        end;

        if (ListaRetorno.ListaRejeicao.Count = 0) then
        begin
          if (LJSON.AsBoolean['hasMore']) then
          begin
            ListaRetorno.indicadorContinuidade := True;
            ListaRetorno.proximoIndice := (LJSON.AsInteger['offset'] + 1) * LJSON.AsInteger['limit'];
          end
          else
          begin
            ListaRetorno.indicadorContinuidade := False;
            ListaRetorno.proximoIndice := 0;
          end;

          LJSONArray := LJSON.AsJSONArray['data'];
          for I := 0 to Pred(LJSONArray.Count) do
          begin
            if I > 0 then
              ListaRetorno := ACBrBoleto.CriarRetornoWebNaLista;

            LJSONObject := LJSONArray.ItemAsJSONObject[I];

            ListaRetorno.DadosRet.IDBoleto.IDBoleto     := LJSONObject.AsString['id'];
            ListaRetorno.DadosRet.TituloRet.NossoNumeroCorrespondente := LJSONObject.AsString['id'];

            ListaRetorno.DadosRet.TituloRet.DataDocumento := StrDatetoTDateTime(LJSONObject.AsString['dateCreated']);
            ListaRetorno.DadosRet.TituloRet.DataRegistro  := StrDatetoTDateTime(LJSONObject.AsString['dateCreated']);
            ListaRetorno.DadosRet.TituloRet.CodigoCliente := LJSONObject.AsString['customer'];

            ListaRetorno.DadosRet.IDBoleto.NossoNum     := LJSONObject.AsString['nossoNumero'];
            ListaRetorno.DadosRet.TituloRet.NossoNumero := ListaRetorno.DadosRet.IDBoleto.NossoNum;

            ListaRetorno.DadosRet.IDBoleto.URLPDF       := LJSONObject.AsString['bankSlipUrl'];
            ListaRetorno.DadosRet.TituloRet.URL         := ListaRetorno.DadosRet.IDBoleto.URLPDF;

            ListaRetorno.DadosRet.TituloRet.SeuNumero   := LJSONObject.AsString['externalReference'];
            ListaRetorno.DadosRet.TituloRet.Vencimento     := StrDatetoTDateTime(LJSONObject.AsString['dueDate']);
            ListaRetorno.DadosRet.TituloRet.ValorDocumento := LJSONObject.AsFloat['value'];
            ListaRetorno.DadosRet.TituloRet.ValorAtual     := LJSONObject.AsFloat['value'];
            ListaRetorno.DadosRet.TituloRet.ValorPago      := LJSONObject.AsFloat['originalValue'];
            ListaRetorno.DadosRet.TituloRet.ValorRecebido  := LJSONObject.AsFloat['netValue'];

            if LJSONObject.AsJSONObject['fine'].AsFloat['value'] > 0 then
            begin
              ListaRetorno.DadosRet.TituloRet.ValorMulta := LJSONObject.AsJSONObject['fine'].AsFloat['value'];
            end else
            begin
              ListaRetorno.DadosRet.TituloRet.PercentualMulta := 0;
              ListaRetorno.DadosRet.TituloRet.ValorMulta      := 0;
            end;

            if LJSONObject.AsJSONObject['interest'].AsFloat['value'] > 0  then
            begin
              ListaRetorno.DadosRet.TituloRet.ValorMoraJuros := LJSONObject.AsJSONObject['interest'].AsFloat['value'];
              ListaRetorno.DadosRet.TituloRet.CodigoMoraJuros := cjValorDia;
            end else
            begin
              ListaRetorno.DadosRet.TituloRet.ValorMoraJuros := 0;
              ListaRetorno.DadosRet.TituloRet.CodigoMoraJuros := cjIsento;
            end;

            ListaRetorno.DadosRet.TituloRet.ValorDesconto  := LJSONObject.AsJSONObject['discount'].AsFloat['value'];

            if LJSONObject.AsJSONObject['discount'].AsString['type'] = 'FIXED'  then
              ListaRetorno.DadosRet.TituloRet.CodigoDesconto := cdValorFixo
            else if LJSONObject.AsJSONObject['discount'].AsString['type'] = 'PERCENTAGE' then
              ListaRetorno.DadosRet.TituloRet.CodigoDesconto := cdPercentual
            else
            begin
              ListaRetorno.DadosRet.TituloRet.ValorDesconto  := 0;
              ListaRetorno.DadosRet.TituloRet.CodigoDesconto := cdSemDesconto;
            end;
            ListaRetorno.DadosRet.TituloRet.EstadoTituloCobranca := LJSONObject.AsString['status'];
            ListaRetorno.DadosRet.TituloRet.CodigoEstadoTituloCobranca := RetornaCodigoOcorrencia(ListaRetorno.DadosRet.TituloRet.EstadoTituloCobranca);
            ListaRetorno.DadosRet.TituloRet.DataCredito          := StrDatetoTDateTime(LJSONObject.AsString['clientPaymentDate']);
          end;
        end;
      finally
        LJSON.free;
      end;
    except
      Result := False;
    end;
  end;
end;

function TRetornoEnvio_Asaas.RetornaCodigoOcorrencia(const ASituacaoBoleto: string): String;
var LSituacaoBoleto : String;
begin
  LSituacaoBoleto := AnsiUpperCase(ASituacaoBoleto);

  if (LSituacaoBoleto  = 'PENDING') or
     (LSituacaoBoleto  = 'OVERDUE') then
    Result := '02'
  else if (LSituacaoBoleto = 'CONFIRMED') then
    Result := '06'
  else if (LSituacaoBoleto  = 'REFUNDED') then
    Result := '09'
  else
    Result := '99';
end;

function TRetornoEnvio_Asaas.RetornoEnvio(const AIndex: Integer): Boolean;
begin
  Result := inherited RetornoEnvio(AIndex);
end;

function TRetornoEnvio_Asaas.StrDatetoTDateTime(const AValue: String): TDateTime;
begin
  Result := StringToDateTime(AValue, 'YYYY-MM-DD');
end;

end.

