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

unit ACBrBoletoW_Asaas;

interface

uses
  Classes,
  SysUtils,
  ACBrBoletoConversao,
  ACBrBoletoWS,
  ACBrBoletoWS.Rest,
  ACBrJSON;

type

  { TBoletoW_Asaas }
  EACBrBoletoWSAsaasException = class(Exception);
  TBoletoW_Asaas = class(TBoletoWSREST)
  private
    procedure DefinirAuthorization; override;
  protected
    function DefinirParametros: string;

    procedure DefinirURL; override;
    procedure DefinirContentType; override;
    procedure GerarHeader; override;
    procedure GerarDados; override;
    procedure DefinirKeyUser;
    procedure RequisicaoIncluir;
    procedure RequisicaoAlterar;
    procedure RequisicaoConsulta;
    procedure RequisicaoConsultaDetalhe;
    procedure GerarDadosMulta(var AJSON : TACBrJSONObject);
    procedure GerarDadosJuro(var AJSON : TACBrJSONObject);
    procedure GerarDadosDesconto(var AJSON : TACBrJSONObject);

  public
    constructor Create(ABoletoWS: TBoletoWS); override;

    function GerarRemessa: string; override;
    function Enviar: boolean; override;
  end;

const
  C_URL_PROD          = 'https://api.asaas.com/v3';
  C_URL_SANDBOX       = 'https://api-sandbox.asaas.com/v3';

  C_URL_CUSTOMER_PROD    = C_URL_PROD + '/customers';
  C_URL_CUSTOMER_SANDBOX = C_URL_SANDBOX + '/customers';

  C_CONTENT_TYPE    = 'application/json';
  C_ACCEPT          = C_CONTENT_TYPE;
  C_ACCEPT_ENCODING = '';
  C_CHARSET         = 'utf-8';
  C_ACCEPT_CHARSET  = C_CHARSET;

implementation

uses
  StrUtils,
  synautil,
  DateUtils,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  ACBrBoleto,
  ACBrBoletoWS.Rest.OAuth;

const C_ID_OBRIGATORIO =  'Id Asaas não informado na propriedade Nosso Número Correspondente';
{ TBoletoW_Asaas }
procedure TBoletoW_Asaas.DefinirURL;
var
  LNossoNumeroCorrespondente: string;
begin
  if (ATitulo <> nil) then
    LNossoNumeroCorrespondente := ATitulo.NossoNumeroCorrespondente;

  case Boleto.Configuracoes.WebService.Ambiente of
    tawsProducao    : FPURL.URLProducao    := C_URL_PROD;
    tawsHomologacao : FPURL.URLHomologacao := C_URL_SANDBOX;
    tawsSandBox     : FPURL.URLSandBox     := C_URL_SANDBOX;
  end;

  case Boleto.Configuracoes.WebService.Operacao of
    tpInclui:
      FPURL.SetPathURI( '/payments' );
    tpConsulta:
      FPURL.SetPathURI( '/payments' + DefinirParametros );
    tpBaixa,tpCancelar:
      begin
        if (LNossoNumeroCorrespondente <> '') then
          FPURL.SetPathURI( '/payments/' + LNossoNumeroCorrespondente )
        else
          raise EACBrBoletoWSAsaasException.Create(C_ID_OBRIGATORIO);
      end;
    tpConsultaDetalhe:
      begin
        if (LNossoNumeroCorrespondente <> '') then
          FPURL.SetPathURI( '/payments/' + LNossoNumeroCorrespondente)
        else
          raise EACBrBoletoWSAsaasException.Create(C_ID_OBRIGATORIO);
      end;
    tpPIXConsultar :
      begin
        if (LNossoNumeroCorrespondente <> '') then
          FPURL.SetPathURI( '/payments/' + LNossoNumeroCorrespondente + '/billingInfo')
        else
          raise EACBrBoletoWSAsaasException.Create(C_ID_OBRIGATORIO);
      end;
  end;
end;

procedure TBoletoW_Asaas.DefinirContentType;
begin
  FPContentType := C_CONTENT_TYPE;
end;

procedure TBoletoW_Asaas.DefinirKeyUser;
begin
  FPKeyUser := C_ACCESS_TOKEN + ': ' +  Boleto.Cedente.CedenteWS.KeyUser;
end;

procedure TBoletoW_Asaas.GerarHeader;
begin
  DefinirContentType;
  DefinirKeyUser;
end;

procedure TBoletoW_Asaas.GerarDados;
begin
  if Assigned(Boleto) then
    DefinirURL;

  case Boleto.Configuracoes.WebService.Operacao of
    tpInclui:
      begin
        FMetodoHTTP := htPOST;
        RequisicaoIncluir;
      end;
    tpAltera:
      begin
         FMetodoHTTP := htPUT;
         RequisicaoAlterar;
      end;
    tpCancelar,
    tpBaixa:
      begin
        FMetodoHTTP := htDELETE;
      end;
    tpConsulta,
    tpConsultaDetalhe,
    tpPixConsultar:
      begin
        FMetodoHTTP := htGET;
      end;
  else
    raise EACBrBoletoWSException.Create(ClassName + Format(S_OPERACAO_NAO_IMPLEMENTADO,[TipoOperacaoToStr(Boleto.Configuracoes.WebService.Operacao)]));
  end;
end;

procedure TBoletoW_Asaas.GerarDadosDesconto(var AJSON: TACBrJSONObject);
var LJSONDesconto : TACBrJSONObject;
begin
  if ATitulo.TipoDesconto <> tdNaoConcederDesconto then
  begin
    LJSONDesconto := TACBrJSONObject.Create;
    LJSONDesconto.AddPair('value', ATitulo.ValorDesconto);
    LJSONDesconto.AddPair('dueDateLimitDays', DaysBetween(ATitulo.Vencimento,ATitulo.DataDesconto));
    case ATitulo.TipoDesconto of
      tdValorFixoAteDataInformada  : LJSONDesconto.AddPair('type', 'FIXED');
      tdPercentualAteDataInformada : LJSONDesconto.AddPair('type', 'PERCENTAGE');
      else
        raise EACBrBoletoWSAsaasException.Create('Tipo de Desconto não permitido');
    end;
    AJSON.AddPair('discount', LJSONDesconto);
  end;
end;

procedure TBoletoW_Asaas.GerarDadosJuro(var AJSON: TACBrJSONObject);
var LJSONJuros : TACBrJSONObject;
begin
  if ATitulo.ValorMoraJuros > 0 then
  begin
    LJSONJuros := TACBrJSONObject.Create;
    LJSONJuros.AddPair('value', ATitulo.ValorMoraJuros);
    AJSON.AddPair('interest', LJSONJuros);
  end;
end;

procedure TBoletoW_Asaas.GerarDadosMulta(var AJSON: TACBrJSONObject);
var LJSONMulta : TACBrJSONObject;
begin
  if ATitulo.PercentualMulta > 0 then
  begin
    LJSONMulta := TACBrJSONObject.Create;
    if ATitulo.MultaValorFixo  then begin
      LJSONMulta.AddPair('value', ATitulo.PercentualMulta);
      LJSONMulta.AddPair('type', 'FIXED');
    end else begin
      LJSONMulta.AddPair('value', ATitulo.PercentualMulta);
      LJSONMulta.AddPair('type', 'PERCENTAGE');
    end;
    AJSON.AddPair('fine', LJSONMulta);
  end;
end;

procedure TBoletoW_Asaas.DefinirAuthorization;
begin
  FPAuthorization := FPKeyUser;
end;

function TBoletoW_Asaas.DefinirParametros: string;
var
  LFiltro: TStringList;
begin
  if Assigned(Boleto.Configuracoes.WebService.Filtro) then
  begin
    LFiltro := TStringList.Create;
    LFiltro.Delimiter := '&';
    try
      LFiltro.Add('billingType=BOLETO');
      if Boleto.Configuracoes.WebService.Filtro.indiceContinuidade > 0 then
        LFiltro.Add('offset='+ IntToStr(Trunc(Boleto.Configuracoes.WebService.Filtro.indiceContinuidade)));
      LFiltro.Add('limit=100');

      if Boleto.Configuracoes.WebService.Filtro.dataVencimento.DataInicio > 0 then
      begin
        LFiltro.Add('dueDate%5Bge%5D=' + FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataVencimento.DataInicio,'YYYY-MM-DD'));
        LFiltro.Add('dueDate%5Ble%5D=' + FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataVencimento.DataFinal,'YYYY-MM-DD'));
      end;
      if Boleto.Configuracoes.WebService.Filtro.dataMovimento.DataInicio > 0 then
      begin
        LFiltro.Add('paymentDate%5Bge%5D=' + FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataMovimento.DataInicio,'YYYY-MM-DD'));
        LFiltro.Add('paymentDate%5Ble%5D=' + FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataMovimento.DataFinal,'YYYY-MM-DD'));
      end;
      if Boleto.Configuracoes.WebService.Filtro.dataRegistro.DataInicio > 0 then
      begin
        LFiltro.Add('dateCreated%5Bge%5D=' + FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataRegistro.DataInicio,'YYYY-MM-DD'));
        LFiltro.Add('dateCreated%5Ble%5D=' + FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataRegistro.DataFinal,'YYYY-MM-DD'));
      end;
    finally
      if LFiltro.DelimitedText <> '' then
        Result := '?' + LFiltro.DelimitedText;
      LFiltro.Free;
    end;
  end;
end;

procedure TBoletoW_Asaas.RequisicaoIncluir;
  function Customer : String; //função para criar ou retornar o código do customer da API
    var
      LURL, LCustomerID : string;
      LStream : TStringStream;
      LJSON: TACBrJSONObject;
  begin
    LCustomerID := '';
    httpsend.Timeout := Boleto.Configuracoes.WebService.TimeOut;

    case Boleto.Configuracoes.WebService.Ambiente of
      tawsProducao : LURL := C_URL_CUSTOMER_PROD;
      tawsSandbox  : LURL := C_URL_CUSTOMER_SANDBOX;
    end;

    LStream  := TStringStream.Create('');
    try
      httpsend.OutputStream := LStream;
      httpsend.Headers.Clear;
      httpsend.MimeType := FPContentType;
      httpsend.Headers.Text := FPKeyUser;
      httpsend.Document.Clear;
      //necessario consultar se já existe, pois o portal permite duplicação de cadastros
      httpsend.HTTPMethod('GET', LURL + Format('?cpfCnpj=', [ATitulo.Sacado.CNPJCPF]));
      httpsend.Document.Position := 0;
      if (httpsend.ResultCode = 200) and (LStream.Size > 0) then
      begin
        LStream.Position := 0;
        LJSON := TACBrJSONObject.Parse(ReadStrFromStream(LStream, LStream.Size));
        try
          if LJSON.AsJSONArray['data'].Count > 0 then
            LCustomerID := LJSON.AsJSONArray['data'].ItemAsJSONObject[0].AsString['id'];
        finally
          LJSON.Free;
        end;
      end;
    finally
      httpsend.OutputStream := nil;
      LStream.Free;
    end;

    //não existe o cadastro do cliente no portal, necessário criar antes de enviar a cobrança
    if LCustomerID = '' then
    begin
      LStream  := TStringStream.Create('');
      try
        httpsend.OutputStream := LStream;
        httpsend.Headers.Clear;
        httpsend.MimeType := FPContentType;
        httpsend.Headers.Text := FPKeyUser;
        httpsend.Document.Clear;
        try
          LJSON := TACBrJSONObject.Create
                     .AddPair('name', ATitulo.Sacado.NomeSacado)
                     .AddPair('cpfCnpj', OnlyNumber(ATitulo.Sacado.CNPJCPF))
                     .AddPair('email', ATitulo.Sacado.Email)
                     .AddPair('phone', ATitulo.Sacado.Fone)
                     .AddPair('address', ATitulo.Sacado.Logradouro)
                     .AddPair('addressNumber', ATitulo.Sacado.Numero)
                     .AddPair('complement', ATitulo.Sacado.Complemento)
                     .AddPair('province', ATitulo.Sacado.Bairro)
                     .AddPair('postalCode', OnlyNumber(ATitulo.Sacado.CEP));

          WriteStrToStream(httpsend.Document, NativeStringToUTF8(LJSON.ToJSON));
          httpsend.HTTPMethod('POST', LURL);
        finally
          LJSON.Free;
        end;
        if (httpsend.ResultCode = 200) and (LStream.Size > 0) then
        begin
          LStream.Position := 0;
          try
            LJSON := TACBrJSONObject.Parse(ReadStrFromStream(LStream, LStream.Size));
            LCustomerID := LJSON.AsString['id'];
          finally
            LJSON.Free;
          end;
        end;
      finally
        httpsend.OutputStream := nil;
        LStream.Free;
      end;
    end;
    Result := LCustomerID;
  end;
var
  LJSON : TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    LJSON := TACBrJSONObject.Create;
    try
      if ATitulo.NossoNumero = '' then
        ATitulo.NossoNumero := '0';

      if not ((ATitulo.NossoNumero = '0') or
              (ATitulo.NossoNumero = Poem_Zeros('',Boleto.Banco.TamanhoMaximoNossoNum)) ) then
        raise Exception.Create('Campo NossoNumero é inválido obrigatóriamente deve ser informado valor 0!');

      if ATitulo.DataBaixa = 0 then
        ATitulo.DataBaixa := IncMonth(ATitulo.Vencimento, 1);

      LJSON.AddPair('customer', Customer);
      LJSON.AddPair('billingType', 'BOLETO');
      LJSON.AddPair('value', ATitulo.ValorDocumento);
      LJSON.AddPair('dueDate', FormatDateTimeBr(ATitulo.Vencimento,'YYYY-MM-DD'));
      LJSON.AddPair('description', Copy(Trim(ATitulo.Mensagem.Text),1,500));
      LJSON.AddPair('daysAfterDueDateToRegistrationCancellation', DaysBetween(ATitulo.Vencimento, ATitulo.DataBaixa));
      LJSON.AddPair('externalReference', Trim(ATitulo.SeuNumero));

      GerarDadosDesconto(LJSON);
      GerarDadosMulta(LJSON);
      GerarDadosJuro(LJSON);

      FPDadosMsg := LJSON.ToJSON;
    finally
      LJSON.Free;
    end;
  end;
end;

procedure TBoletoW_Asaas.RequisicaoAlterar;
var
  LJSON, LJSONDesconto, LJSONJuros, LJSONMulta : TACBrJSONObject;
begin
if Assigned(ATitulo) then
  begin
    LJSON := TACBrJSONObject.Create;
    try
      if ATitulo.NossoNumeroCorrespondente = '' then
        ATitulo.NossoNumeroCorrespondente := '0';

      if (ATitulo.NossoNumeroCorrespondente = '0') then
        raise Exception.Create(C_ID_OBRIGATORIO);

      if ATitulo.DataBaixa = 0 then
        ATitulo.DataBaixa := IncMonth(ATitulo.Vencimento, 1);

      LJSON.AddPair('id', ATitulo.NossoNumeroCorrespondente);
      LJSON.AddPair('billingType', 'BOLETO');
      LJSON.AddPair('value', ATitulo.ValorDocumento);
      LJSON.AddPair('dueDate', FormatDateTimeBr(ATitulo.Vencimento,'YYYY-MM-DD'));
      LJSON.AddPair('description', Copy(Trim(ATitulo.Mensagem.Text),1,500));
      LJSON.AddPair('daysAfterDueDateToRegistrationCancellation', DaysBetween(ATitulo.Vencimento, ATitulo.DataBaixa));
      LJSON.AddPair('externalReference', Trim(ATitulo.SeuNumero));

      GerarDadosDesconto(LJSON);
      GerarDadosMulta(LJSON);
      GerarDadosJuro(LJSON);

      FPDadosMsg := LJSON.ToJSON;
    finally
      LJSON.Free;
    end;
  end;
end;

procedure TBoletoW_Asaas.RequisicaoConsulta;
begin
  // Sem Payload - Define Método GET
end;

procedure TBoletoW_Asaas.RequisicaoConsultaDetalhe;
begin
  // Sem Payload - Define Método GET
end;

constructor TBoletoW_Asaas.Create(ABoletoWS: TBoletoWS);
begin
  inherited Create(ABoletoWS);
  FPAccept := C_ACCEPT;

  if Assigned(OAuth) then
  begin
    OAuth.AuthorizationType  := atApiKey;
    OAuth.ExigirClientSecret := False;
  end;
end;

function TBoletoW_Asaas.GerarRemessa: string;
begin
  Result := inherited GerarRemessa;
end;

function TBoletoW_Asaas.Enviar: boolean;
begin
  GerarHeader;
  Result := inherited Enviar;
end;

end.
