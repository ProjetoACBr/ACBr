{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:  J�ter Rabelo Ferreira                          }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrBoletoW_Santander_API;

interface

uses
  ACBrJSON,
  ACBrBoleto,
  ACBrBoletoWS,
  ACBrBoletoWS.Rest;

type

  { TBoletoW_Santander_API }
  TBoletoW_Santander_API = class(TBoletoWSREST)
  private
    function GetNsu: string;
  protected
    procedure DefinirURL; override;
    procedure DefinirContentType; override;
    procedure GerarHeader; override;
    procedure GerarDados; override;
    procedure DefinirAuthorization; override;
    procedure DefinirParamOAuth; override;
    procedure DefinirIdentificador;
    procedure RequisicaoJson;
    procedure RequisicaoConsulta;
    procedure RequisicaoConsultaDetalhe;
    procedure RequisicaoBaixa;
    procedure RequisicaoProtestar;
    procedure RequisicaoAltera;
    procedure RequisicaoAlterarDesconto(AJson: TACBrJSONObject);
    procedure GerarPagador(AJson: TACBrJSONObject);
    procedure GerarSacadorAvalista(AJson: TACBrJSONObject);
    procedure GerarDesconto(AJson: TACBrJSONObject);
    procedure GerarMulta(AJson: TACBrJSONObject);
    procedure GerarJuros(AJson: TACBrJSONObject);
    procedure GerarProtesto(AJson: TACBrJSONObject);
    procedure GerarRecebimentoDivergente(AJson: TACBrJSONObject);
    procedure GerarPIX(AJson: TACBrJSONObject);
    procedure GerarMensagens(AJson: TACBrJSONObject);

    function GerarTokenAutenticacao: string; override;
    function ValidaAmbiente: string;
    function DefinirParametros:String;
    function retornaTipoDesconto(ATipo: TACBrTipoDesconto): string;
  public
    constructor Create(ABoletoWS: TBoletoWS); override;

    function GerarRemessa: string; override;
    function Enviar: boolean; override;

  end;
const
  {URL Produ��o}
  C_URL = 'https://trust-open.api.santander.com.br/collection_bill_management/v2';
  C_URL_OAUTH_PROD = 'https://trust-open.api.santander.com.br/auth/oauth/v2/token';

  {Para homologacao existe 2 end points SandBox e Open-h }

  {URL SandBOX - nao devolve todas as informa��es necess�rias no retorno}
  //C_URL_HOM = 'https://trust-sandbox.api.santander.com.br/collection_bill_management/v2';
  //C_URL_OAUTH_HOM = 'https://trust-sandbox.api.santander.com.br/auth/oauth/v2/token';


  {URL Homologa��o open-h
  Aten��o !
  Para habilitar este endpoint contatar o banco, pois este endpoint retorna completo as respostas e qrcode.
  (SandBox n�o faz isso segundo banco.  }
  C_URL_HOM = 'https://trust-open-h.api.santander.com.br/collection_bill_management/v2';
  C_URL_OAUTH_HOM = 'https://trust-open-h.api.santander.com.br/auth/oauth/v2/token';


implementation

uses
  Classes,
  SysUtils,
  StrUtils,
  pcnConversao,
  ACBrBoletoConversao,
  ACBrPixBase,
  ACBrUtil.Strings;

{ TBoletoW_Santander_API }

procedure TBoletoW_Santander_API.DefinirURL;
begin
  FPURL := IfThen(Boleto.Configuracoes.WebService.Ambiente = taProducao, C_URL, C_URL_HOM);
  case Boleto.Configuracoes.WebService.Operacao of
     tpInclui         : FPURL := FPURL + '/workspaces/' + Boleto.Cedente.CedenteWS.KeyUser + '/bank_slips';
     tpAltera         : FPURL := FPURL + '/workspaces/' + Boleto.Cedente.CedenteWS.KeyUser + '/bank_slips';
     tpConsulta       : FPURL := FPURL + '/bills?' +  DefinirParametros;
     tpConsultaDetalhe: FPURL := FPURL + '/bills' +  DefinirParametros;
     tpBaixa          : FPURL := FPURL + '/workspaces/' + Boleto.Cedente.CedenteWS.KeyUser + '/bank_slips';
  end;
end;

procedure TBoletoW_Santander_API.DefinirContentType;
begin
  FPContentType := 'application/json';
end;

procedure TBoletoW_Santander_API.DefinirIdentificador;
begin
  if Assigned(ATitulo) then
    FPIdentificador := 'X-Application-Key: ' + ATitulo.ACBrBoleto.Cedente.CedenteWS.ClientID;
end;

procedure TBoletoW_Santander_API.GerarHeader;
begin
  Self.FPHeaders.Clear;
  Self.FPHeaders.Add('Accept-Encoding: gzip, deflate, compress');
  DefinirContentType;
  DefinirIdentificador;
end;

procedure TBoletoW_Santander_API.GerarDados;
begin
  if Assigned(ATitulo) then
  begin
    case Boleto.Configuracoes.WebService.Operacao of
      tpInclui:
        begin
          FMetodoHTTP := htPOST;
          RequisicaoJson;
        end;
      tpAltera:
        begin
          FMetodoHTTP := htPATCH; // Define M�todo PATCH conforme manual do banco
          RequisicaoAltera;
        end;
      tpBaixa :
        begin
          FMetodoHTTP := htPATCH; // Define M�todo PATCH conforme manual do banco
          RequisicaoBaixa;
        end;

      tpConsultaDetalhe:
        begin
          FMetodoHTTP := htGET; // Define M�todo GET Consulta
          RequisicaoConsultaDetalhe;
        end;
    else
      raise EACBrBoletoWSException.Create(ClassName + Format( S_OPERACAO_NAO_IMPLEMENTADO, [TipoOperacaoToStr(Boleto.Configuracoes.WebService.Operacao)]));
    end;
  end else
  if Boleto.Configuracoes.WebService.Operacao = tpConsulta then
    RequisicaoConsulta;
end;

procedure TBoletoW_Santander_API.DefinirAuthorization;
begin
  FPAuthorization := C_AUTHORIZATION + ': Bearer ' + GerarTokenAutenticacao;
end;

function TBoletoW_Santander_API.GerarTokenAutenticacao: string;
begin
  OAuth.Payload := True;
  Result := inherited GerarTokenAutenticacao;
end;

function TBoletoW_Santander_API.GetNsu: string;
begin
  Result := ATitulo.NossoNumero;
  {so utilizar se for sandbox}
//  if Boleto.Configuracoes.WebService.Ambiente = taHomologacao then
//     Result := 'TST' + Result;
end;

function TBoletoW_Santander_API.DefinirParametros: String;
var
  LConsultaList: TStringList;
  LNossoNumero: String;
begin
  if Assigned(Boleto.Configuracoes.WebService.Filtro) then
  begin
    {
    1. default: Pesquisa padr�o, trazendo somente dados b�sicos do boleto
    2. duplicate: Pesquisa de dados para emiss�o de segunda via de boleto
    3. bankslip: Pesquisa para dados completos do boleto
    4. settlement: Pesquisa para informa��es de baixas/liquida��es do boleto
    5. registry: Pesquisa de informa��es de cart�rio do boleto
    }
    if Assigned(ATitulo) then
      LNossoNumero := ATitulo.NossoNumero;

    LConsultaList := TStringList.Create;
    try
    //bankslip: Pesquisa para informa��es do boleto
    // nao retorna juros
    if Boleto.Cedente.CedenteWS.IndicadorPix then
    begin
      LConsultaList.Add('/'+Boleto.Cedente.Convenio + '.' + LNossoNumero);
      LConsultaList.Add('tipoConsulta=bankslip');  // 2 via
      LConsultaList.Delimiter := '?';
    end else
    begin
      if Boleto.Configuracoes.WebService.Filtro.indicadorSituacao = isbBaixado then
      begin
        LConsultaList.Add('/'+Boleto.Cedente.Convenio + '.' + LNossoNumero);
        LConsultaList.Add('tipoConsulta=settlement');    // data pgto
        LConsultaList.Delimiter := '?';
      end else
      begin
        //Consulta Nosso Numero
        LConsultaList.Add('?beneficiaryCode='+ Boleto.Cedente.Convenio);
        LConsultaList.Add('bankNumber='+ LNossoNumero); // juros
        LConsultaList.Delimiter := '&';
      end;
    end;
    finally
      Result := LConsultaList.DelimitedText;
      LConsultaList.Free;
    end;
  end;
end;

procedure TBoletoW_Santander_API.DefinirParamOAuth;
begin
  FParamsOAuth := C_GRANT_TYPE
                + '=client_credentials'
                + '&client_id=' + Boleto.Cedente.CedenteWS.ClientID
                + '&client_secret=' + Boleto.Cedente.CedenteWS.ClientSecret;
end;

function TBoletoW_Santander_API.ValidaAmbiente: string;
begin
   {Deixado apenas como produ��o, orientado pelo SUPORTECONECTIVIDADE
    Data: 08/01/2024, 12:57 anexado na TK 4804 }
//  if Boleto.Configuracoes.WebService.Ambiente = taProducao then
    Result := 'PRODUCAO'
//  else
//    Result :=  'TESTE';
end;

procedure TBoletoW_Santander_API.RequisicaoAltera;
var
  LJsonObject: TACBrJSONObject;
begin
 if Assigned(ATitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('covenantCode', Boleto.Cedente.Convenio);
      LJsonObject.AddPair('bankNumber', ATitulo.NossoNumero);

      case ATitulo.OcorrenciaOriginal.Tipo of
        toRemessaConcederAbatimento:
          begin
            LJsonObject.AddPair('deductionValue', StringReplace(FormatFloat('0.00', ATitulo.ValorAbatimento), ',', '.', [rfReplaceAll]));
          end;
        toRemessaCancelarAbatimento:
          begin
            LJsonObject.AddPair('deductionValue', StringReplace(FormatFloat('0.00', 0), ',', '.', [rfReplaceAll]));
          end;
        toRemessaConcederDesconto:
          begin
            RequisicaoAlterarDesconto(LJsonObject)
          end;
        toRemessaAlterarVencimento:
          begin
             LJsonObject.AddPair('dueDate', FormatDateTime('yyyy-mm-dd', ATitulo.Vencimento));
          end;
        toRemessaProtestar:
          begin
             LJsonObject.AddPair('operation', 'PROTESTAR');
          end;
        toRemessaSustarProtesto:
          begin
             LJsonObject.AddPair('operation', 'BAIXAR');
          end;
        toRemessaCancelarInstrucaoProtesto:
          begin
             LJsonObject.AddPair('operation', 'CANCELAR_PROTESTO');
          end;
        toRemessaDispensarJuros:
          begin
            LJsonObject.AddPair('interestPercentage', StringReplace(FormatFloat('0.00', 0), ',', '.', [rfReplaceAll]));
          end;
        toRemessaAlterarSeuNumero :
          begin
            LJsonObject.AddPair('clientNumber', ATitulo.NumeroDocumento); // seu n�mero ou numero documento
          end;
        toRemessaAlterarNumeroDiasProtesto:
          begin
             LJsonObject.AddPair('protestQuatilyDays', IntToStr(ATitulo.DiasDeProtesto));
          end;
        toRemessaAlterarMulta:
          begin
             if ATitulo.PercentualMulta > 0 then
              begin
                if ATitulo.MultaValorFixo then
                  raise Exception.Create('Permitido multa apenas como percentual!');

                LJsonObject.AddPair('finePercentage', StringReplace(FormatFloat('0.00', ATitulo.PercentualMulta), ',', '.', [rfReplaceAll]));
                LJsonObject.AddPair('FineDate', FormatDateTime('yyyy-mm-dd', ATitulo.DataMulta));
              end
          end;
        toRemessaDispensarMulta:
          begin
             LJsonObject.AddPair('finePercentage', StringReplace(FormatFloat('0.00', 0), ',', '.', [rfReplaceAll]));
          end;
        toRemessaAlterarDesconto:
          begin
            RequisicaoAlterarDesconto(LJsonObject);
          end;
        toRemessaNaoConcederDesconto:
          begin
            RequisicaoAlterarDesconto(LJsonObject);
          end;
      end;
      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Santander_API.RequisicaoBaixa;
var
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('covenantCode', Boleto.Cedente.Convenio);
      LJsonObject.AddPair('bankNumber', ATitulo.NossoNumero);
      LJsonObject.AddPair('operation', 'BAIXAR');
      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Santander_API.RequisicaoConsulta;
begin
  raise EACBrBoletoWSException.Create(ACBrStr(ClassName + Format( S_METODO_NAO_IMPLEMENTADO, [C_LER_LISTA_RETORNO] )));
end;

procedure TBoletoW_Santander_API.RequisicaoConsultaDetalhe;
begin
  // Sem Payload - Define M�todo GET
end;

procedure TBoletoW_Santander_API.RequisicaoJson;
var
  LEspecieDoc: string;
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    if AnsiSameText(ATitulo.EspecieDoc,'DM') then
       LEspecieDoc:= 'DUPLICATA_MERCANTIL'
    else if AnsiSameText(ATitulo.EspecieDoc, 'NP') then
       LEspecieDoc:= 'NOTA_PROMISSORIA'
    else if AnsiSameText(ATitulo.EspecieDoc, 'NS') then
       LEspecieDoc:= 'DUPLICATA_SERVICO'
    else if AnsiSameText(ATitulo.EspecieDoc, 'REC') then
       LEspecieDoc:= 'RECIBO'
    else
       LEspecieDoc:= 'OUTROS';

    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('nsuCode', GetNsu);
      LJsonObject.AddPair('environment', ValidaAmbiente);
      LJsonObject.AddPair('nsuDate', FormatDateTime('yyyy-mm-dd', Now));
      LJsonObject.AddPair('covenantCode', Boleto.Cedente.Convenio);
      LJsonObject.AddPair('bankNumber', ATitulo.NossoNumero);
      LJsonObject.AddPair('clientNumber', ATitulo.NumeroDocumento);
      LJsonObject.AddPair('dueDate', FormatDateTime('yyyy-mm-dd', ATitulo.Vencimento));
      LJsonObject.AddPair('issueDate', FormatDateTime('yyyy-mm-dd', Now));
      LJsonObject.AddPair('nominalValue', StringReplace(FormatFloat('0.00', ATitulo.ValorDocumento), ',', '.', [rfReplaceAll]));

      GerarPagador(LJsonObject);
      GerarSacadorAvalista(LJsonObject);

      LJsonObject.AddPair('documentKind', LEspecieDoc);
      if ATitulo.ValorDesconto > 0 then
         GerarDesconto(LJsonObject);

      GerarMulta(LJsonObject);
      GerarJuros(LJsonObject);

      if ATitulo.ValorAbatimento > 0 then
        LJsonObject.AddPair('deductionValue', StringReplace(FormatFloat('0.00', ATitulo.ValorAbatimento), ',', '.', [rfReplaceAll]));

      GerarProtesto(LJsonObject);
      GerarRecebimentoDivergente(LJsonObject);
      GerarPix(LJsonObject);

      if ATitulo.QrCode.txId <> '' then
        LJsonObject.AddPair('txId', ATitulo.QrCode.txId);
      GerarMensagens(LJsonObject);

      FPDadosMsg := LJsonObject.ToJson;
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Santander_API.RequisicaoProtestar;
var
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('covenantCode', Boleto.Cedente.Convenio);
      LJsonObject.AddPair('bankNumber', ATitulo.NossoNumero);
      LJsonObject.AddPair('operation', 'PROTESTAR');
      GerarMensagens(LJsonObject);

      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
    end;
  end;
end;

function TBoletoW_Santander_API.retornaTipoDesconto(ATipo: TACBrTipoDesconto): string;
begin
  result := '';
    case ATipo of
      tdNaoConcederDesconto:
        Result := 'ISENTO';
      tdValorFixoAteDataInformada:
        Result := 'VALOR_DATA_FIXA';
      tdValorAntecipacaoDiaCorrido:
        Result := 'VALOR_DIA_CORRIDO';
      tdValorAntecipacaoDiaUtil:
        Result := 'VALOR_DIA_UTIL ';
      else
        raise Exception.Create('Modalidade de desconto n�o permitida');
    end;
end;

procedure TBoletoW_Santander_API.GerarPagador(AJson: TACBrJSONObject);
var
  LJsonObject: TACBrJSONObject;
  LCnpjCpf: string;
  LCEP: string;
begin
  if Assigned(ATitulo) and Assigned(AJson) then
  begin
    LCnpjCpf := OnlyNumber(ATitulo.Sacado.CNPJCPF);

    LJsonObject := TACBrJSONObject.Create;

    LJsonObject.AddPair('name', Copy(ATitulo.Sacado.NomeSacado, 1, 40));
    if Length(LCnpjCpf) <= 11 then
      LJsonObject.AddPair('documentType', 'CPF')
    else
      LJsonObject.AddPair('documentType', 'CNPJ');
    LJsonObject.AddPair('documentNumber', LCnpjCpf);
    LJsonObject.AddPair('address', Trim(Copy(ATitulo.Sacado.Logradouro + ' ' + ATitulo.Sacado.Numero, 1, 40)));
    LJsonObject.AddPair('neighborhood', Copy(ATitulo.Sacado.Bairro, 1, 30));
    LJsonObject.AddPair('city', Copy(ATitulo.Sacado.Cidade, 1, 20));
    LJsonObject.AddPair('state', ATitulo.Sacado.UF);

    LCEP := ACBrUtil.Strings.PadLeft(OnlyNumber(ATitulo.Sacado.CEP), 8, '0');

    LJsonObject.AddPair('zipCode', Copy(LCEP, 1, 5) + '-' + Copy(LCEP, 6, 3));

    AJson.AddPair('payer',LJsonObject);
  end;
end;

procedure TBoletoW_Santander_API.GerarPIX(AJson: TACBrJSONObject);
var
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) and Assigned(AJson) then
  begin
    if ATitulo.ACBrBoleto.Cedente.PIX.TipoChavePIX = tchNenhuma then
      Exit;

    LJsonObject := TACBrJSONObject.Create;

    case ATitulo.ACBrBoleto.Cedente.PIX.TipoChavePIX of
      tchEmail: LJsonObject.AddPair('type', 'EMAIL');
      tchCPF: LJsonObject.AddPair('type', 'CPF');
      tchCNPJ: LJsonObject.AddPair('type', 'CNPJ');
      tchCelular: LJsonObject.AddPair('type', 'CELULAR');
      tchAleatoria: LJsonObject.AddPair('type', 'EVP');
    end;
    LJsonObject.AddPair('dictKey', ATitulo.ACBrBoleto.Cedente.PIX.Chave);
    AJson.AddPair('key', LJsonObject);
  end;
end;

procedure TBoletoW_Santander_API.GerarProtesto(AJson: TACBrJSONObject);
begin
  if Assigned(ATitulo) and Assigned(AJson) then
  begin
    if ATitulo.DiasDeProtesto = 0 then
    begin
      AJson.AddPair('protestType', 'SEM_PROTESTO');
    end else
    begin
      case ATitulo.TipoDiasProtesto of
        diCorridos:
          AJson.AddPair('protestType', 'DIAS_CORRIDOS');
        diUteis:
          AJson.AddPair('protestType', 'DIAS_UTEIS');
      end;
      AJson.AddPair('protestQuantityDays', IntToStr(ATitulo.DiasDeProtesto));
    end;
    //prazo de baixa/devolu��o em dias, opcional
    if (ATitulo.DataBaixa <> 0) and ((ATitulo.DataBaixa - ATitulo.Vencimento) > 0) then
      AJson.AddPair('writeOffQuantityDays', IntToStr(trunc(ATitulo.DataBaixa - ATitulo.Vencimento)));
  end;
end;

procedure TBoletoW_Santander_API.GerarSacadorAvalista(AJson: TACBrJSONObject);
var
  LJsonObject : TACBrJSONObject;
  LCnpjCpf: string;
begin
  if Assigned(ATitulo) and Assigned(AJson) then
  begin

    LCnpjCpf := OnlyNumber(ATitulo.Sacado.SacadoAvalista.CNPJCPF);

    if LCnpjCpf = EmptyStr then
      Exit;
    LJsonObject := TACBrJSONObject.Create;

    LJsonObject.AddPair('name', ATitulo.Sacado.SacadoAvalista.NomeAvalista);

    if Length(LCnpjCpf) <= 11 then
      LJsonObject.AddPair('documentType', 'CPF')
    else
      LJsonObject.AddPair('documentType', 'CNPJ');

    LJsonObject.AddPair('documentNumber', LCnpjCpf);

    AJson.AddPair('beneficiary', LJsonObject);
  end;
end;

procedure TBoletoW_Santander_API.GerarMensagens(AJson: TACBrJSONObject);
var
  LJsonArray: TACBrJSONArray;
  I: Integer;
begin
  if Assigned(ATitulo) and Assigned(AJson) then
    if ATitulo.Mensagem.Count > 0 then
    begin
      LJsonArray := TACBrJSONArray.Create;
      for I := 0 to Pred(ATitulo.Mensagem.Count) do
        LJsonArray.AddElement(ATitulo.Mensagem[I]);
      AJson.AddPair('messages',LJsonArray);
    end;
end;

procedure TBoletoW_Santander_API.GerarMulta(AJson: TACBrJSONObject);
begin
  if Assigned(ATitulo) and Assigned(AJson) then
  begin
    if ATitulo.PercentualMulta > 0 then
    begin
      if ATitulo.MultaValorFixo then
        raise Exception.Create('Permitido multa apenas como percentual!');
      AJson.AddPair('finePercentage', StringReplace(FormatFloat('0.00', ATitulo.PercentualMulta), ',', '.', [rfReplaceAll]));
      if ATitulo.DataMulta > 0 then
        AJson.AddPair('fineQuantityDays', IntToStr(Abs(Trunc(ATitulo.Vencimento - ATitulo.DataMulta))))
      else
        AJson.AddPair('fineQuantityDays', '0');
    end else
    begin
      AJson.AddPair('finePercentage', '0');
      AJson.AddPair('fineQuantityDays', '0');
    end;
  end;
end;

procedure TBoletoW_Santander_API.GerarJuros(AJson: TACBrJSONObject);
begin
  if Assigned(ATitulo) and Assigned(AJson) then
  begin
    if not (ATitulo.CodigoMoraJuros in [cjTaxaMensal, cjIsento]) then
      raise Exception.Create('Permitido apenas taxa mensal de juros');
    AJson.AddPair('interestPercentage', StringReplace(FormatFloat('0.00', ATitulo.ValorMoraJuros), ',', '.', [rfReplaceAll]));
  end;
end;

procedure TBoletoW_Santander_API.RequisicaoAlterarDesconto(AJson: TACBrJSONObject);
var
  LJsonObjectDesconto : TACBrJSONObject;
  LValorDesconto1, LValorDesconto2, LValorDesconto3, LTipo1 : string;
begin
  if Assigned(ATitulo) and Assigned(AJson) then
  begin
    LJsonObjectDesconto := TACBrJSONObject.Create;

    if ATitulo.DataDesconto > 0 then
    begin
      case ATitulo.OcorrenciaOriginal.Tipo of
        toRemessaCancelarDesconto,
        toRemessaNaoConcederDesconto :
          begin
            LValorDesconto1:='0.00';
            LValorDesconto2:='0.00';
            LValorDesconto3:='0.00';
            LTipo1 :=  'ISENTO';
            //LTipo2 :=  'ISENTO';
            //LTipo3 :=  'ISENTO';
          end;
        toRemessaConcederDesconto,
        toRemessaAlterarDesconto :
          begin
           LValorDesconto1 := IfThen(ATitulo.TipoDesconto=tdNaoConcederDesconto,'0.00',
                                     StringReplace(FormatFloat('0.00', ATitulo.ValorDesconto), ',', '.', [rfReplaceAll]));
           LValorDesconto2 := IfThen(ATitulo.TipoDesconto2=tdNaoConcederDesconto,'0.00',
                                     StringReplace(FormatFloat('0.00', ATitulo.ValorDesconto2), ',', '.', [rfReplaceAll]));
           LValorDesconto3 := IfThen(ATitulo.TipoDesconto3=tdNaoConcederDesconto,'0.00',
                                     StringReplace(FormatFloat('0.00', ATitulo.ValorDesconto3), ',', '.', [rfReplaceAll]));
           LTipo1 := retornaTipoDesconto(ATitulo.TipoDesconto);
           //LTipo2 := retornaTipoDesconto(ATitulo.TipoDesconto2);
           //LTipo3 := retornaTipoDesconto(ATitulo.TipoDesconto3);
          end;
      end;
      LJsonObjectDesconto.AddPair('type',LTipo1);
      LJsonObjectDesconto.AddPair('disconuntOne',
                                                 TACBrJSONObject.Create
                                                                .AddPair('value', LValorDesconto1)
                                                                .AddPair('limitDate', FormatDateTime('yyyy-mm-dd', ATitulo.DataDesconto))
                                  );
    end;
    if ATitulo.DataDesconto2 > 0 then
    begin
      LJsonObjectDesconto.AddPair('discountTwo',
                                           TACBrJSONObject.Create
                                                          .AddPair('value', LValorDesconto2)
                                                          .AddPair('limitDate', FormatDateTime('yyyy-mm-dd', ATitulo.DataDesconto2))
                            );
    end;

    if ATitulo.DataDesconto3 > 0 then
    begin
      LJsonObjectDesconto.AddPair('discountThree',
                                     TACBrJSONObject.Create
                                                    .AddPair('value', LValorDesconto3)
                                                    .AddPair('limitDate', FormatDateTime('yyyy-mm-dd', ATitulo.DataDesconto3))
                      );

    end;

    AJson.AddPair('discount',LJsonObjectDesconto);
  end;
end;

procedure TBoletoW_Santander_API.GerarDesconto(AJson: TACBrJSONObject);
var
  LJsonObjectDesconto : TACBrJSONObject;
  LValorDesconto1, LValorDesconto2, LValorDesconto3, LTipo1 : string;
begin
  if Assigned(ATitulo) and Assigned(AJson) then
  begin
    LJsonObjectDesconto := TACBrJSONObject.Create;

    if ATitulo.DataDesconto > 0 then
    begin
      case ATitulo.OcorrenciaOriginal.Tipo of
        toRemessaCancelarDesconto,
        toRemessaNaoConcederDesconto :
          begin
            LValorDesconto1:='0.00';
            LValorDesconto2:='0.00';
            LValorDesconto3:='0.00';
            LTipo1 :=  'ISENTO';
            //LTipo2 :=  'ISENTO';
            //LTipo3 :=  'ISENTO';
          end;
        toRemessaConcederDesconto,
        toRemessaAlterarDesconto :
          begin
           LValorDesconto1 := IfThen(ATitulo.TipoDesconto=tdNaoConcederDesconto,'0.00',
                                     StringReplace(FormatFloat('0.00', ATitulo.ValorDesconto), ',', '.', [rfReplaceAll]));
           LValorDesconto2 := IfThen(ATitulo.TipoDesconto2=tdNaoConcederDesconto,'0.00',
                                     StringReplace(FormatFloat('0.00', ATitulo.ValorDesconto2), ',', '.', [rfReplaceAll]));
           LValorDesconto3 := IfThen(ATitulo.TipoDesconto3=tdNaoConcederDesconto,'0.00',
                                     StringReplace(FormatFloat('0.00', ATitulo.ValorDesconto3), ',', '.', [rfReplaceAll]));
           LTipo1 := retornaTipoDesconto(ATitulo.TipoDesconto);
           //LTipo2 := retornaTipoDesconto(ATitulo.TipoDesconto2);
           //LTipo3 := retornaTipoDesconto(ATitulo.TipoDesconto3);
          end;
      end;
      LJsonObjectDesconto.AddPair('type',LTipo1);
      LJsonObjectDesconto.AddPair('disconuntOne',
                                                 TACBrJSONObject.Create
                                                                .AddPair('value', LValorDesconto1)
                                                                .AddPair('limitDate', FormatDateTime('yyyy-mm-dd', ATitulo.DataDesconto))
                                  );
    end;
    if ATitulo.DataDesconto2 > 0 then
    begin
      LJsonObjectDesconto.AddPair('discountTwo',
                                           TACBrJSONObject.Create
                                                          .AddPair('value', LValorDesconto2)
                                                          .AddPair('limitDate', FormatDateTime('yyyy-mm-dd', ATitulo.DataDesconto2))
                            );
    end;

    if ATitulo.DataDesconto3 > 0 then
    begin
      LJsonObjectDesconto.AddPair('discountThree',
                                     TACBrJSONObject.Create
                                                    .AddPair('value', LValorDesconto3)
                                                    .AddPair('limitDate', FormatDateTime('yyyy-mm-dd', ATitulo.DataDesconto3))
                      );

    end;

    AJson.AddPair('discount',LJsonObjectDesconto);
  end;
end;

procedure TBoletoW_Santander_API.GerarRecebimentoDivergente(AJson: TACBrJSONObject);
begin
  if Assigned(ATitulo) and Assigned(AJson) then
  begin
    (*Nota 15: Tipo de Pagamento (paymentType):
              Informa��o obrigat�ria que indica o tipo de pagamento a ser atribu�do para o boleto:
              Informar:
              � REGISTRO: Permitir� o pagamento do boleto somente pelo valor nominal calculado (juros, multa, desconto e abatimento);
              � DIVERGENTE: Permitir� o pagamento do boleto por um range de valor, sendo definido no registro um valor/percentual m�nimo e m�ximo;
              � PARCIAL: Permitir� at� 99 pagamentos para o mesmo boleto, por um range de valor, sendo definido no registro um valor/percentual m�nimo e m�ximo;

    Nota 16: Quantidade de Parciais (parcelsQuantity):
             Campo num�rico obrigat�rio para os boletos onde houve a indica��o do tipo de pagamento �PARCIAL�, indica a quantidade de pagamentos que ser� permitida para o mesmo boleto, sendo o m�ximo de 99.

    Nota 17: Tipo de Valor (valueType):
             Campo obrigat�rio para os boletos onde houve a indica��o do tipo de pagamento �DIVERGENTE� ou �PARCIAL�. Esse campo definir� se os valores m�nimo e m�ximo para pagamento do boleto ser�o expressos em valor ou percentual.
             Informar:
             � PERCENTUAL
             � VALOR

    Nota 18: Valor m�nimo ou percentual m�nimo do boleto (minValueOrPercentage):
             Identifica o valor m�nimo ou percentual m�nimo do boleto:
             � Quando o tipo de valor informado for PERCENTUAL considerar a seguinte formata��o 9(10)V99999
             � Quando o tipo de valor informado for VALOR considerar a seguinte formata��o 9(10)V99000

    Nota 19: Valor m�ximo ou percentual m�ximo do boleto (maxValueOrPercentage):
             Identifica o valor m�ximo ou percentual m�ximo do boleto:
             � Quando o tipo de valor informado for PERCENTUAL considerar a seguinte formata��o 9(10)V99999
             � Quando o tipo de valor informado for VALOR considerar a seguinte formata��o 9(10)V99000

    obs.: Implementado apenas a op��o de pagamento do boleto, sem valor parcial ou parcelas*)

    AJson.AddPair('paymentType', 'REGISTRO');
  end;
end;

constructor TBoletoW_Santander_API.Create(ABoletoWS: TBoletoWS);
begin
  inherited Create(ABoletoWS);
  FPAccept := '';

  if Assigned(OAuth) then
  begin
    if OAuth.Ambiente = taHomologacao then
      OAuth.URL := C_URL_OAUTH_HOM
    else
      OAuth.URL := C_URL_OAUTH_PROD;

    OAuth.Payload := True;
  end;
end;

function TBoletoW_Santander_API.GerarRemessa: string;
begin
  Result := inherited GerarRemessa;
end;

function TBoletoW_Santander_API.Enviar: boolean;
var
  LEnvioPrincipal, LEnvioAuxiliar, LEnvioComplementar : String;
begin
  //Feito assim consulta subsequentes, pois conversado com o banco
  //onde os endpoints est�o incompetos, precisando pegar informa��es em 3 lugares
  //por exemplo o valor do pagamento s� vem na consulta nosso numero
  //consulta do emv s� vem na consulta bankslip e a data pagamento vem settlement

  Result := inherited Enviar;
  LEnvioPrincipal := FRetornoWS;

  if Boleto.Cedente.CedenteWS.IndicadorPix and (Boleto.Configuracoes.WebService.Operacao = tpConsultaDetalhe) then
  begin
    try
      Boleto.Cedente.CedenteWS.IndicadorPix := False;
      Boleto.Configuracoes.WebService.Filtro.indicadorSituacao := isbNenhum;
      inherited Enviar;
      LEnvioAuxiliar := ',' + FRetornoWS;
    finally
      Boleto.Cedente.CedenteWS.IndicadorPix := True;
    end;
  end;

  if (pos('LIQUIDADO',AnsiUpperCase(LEnvioPrincipal) ) > 0) or
     (pos('LIQUIDADO',AnsiUpperCase(LEnvioComplementar) ) > 0) or
     (pos('BAIXADO'  ,AnsiUpperCase(LEnvioPrincipal) ) > 0) or
     (pos('BAIXADO'  ,AnsiUpperCase(LEnvioComplementar) ) > 0)  then
  begin
    Boleto.Cedente.CedenteWS.IndicadorPix := False;
    Boleto.Configuracoes.WebService.Filtro.indicadorSituacao := isbBaixado;
    Result := inherited Enviar;
    LEnvioComplementar := ',' + FRetornoWS;
    Boleto.Cedente.CedenteWS.IndicadorPix := true;
    Boleto.Configuracoes.WebService.Filtro.indicadorSituacao := isbNenhum;
  end;

  FRetornoWS := '[ ' + LEnvioPrincipal + LEnvioAuxiliar + LEnvioComplementar + '  ]';
end;
end.
