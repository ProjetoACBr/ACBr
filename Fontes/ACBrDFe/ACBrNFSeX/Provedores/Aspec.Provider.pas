{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Willian Delan de Oliveira                       }
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

unit Aspec.Provider;

interface

uses
  SysUtils, Classes, Variants, StrUtils,
  ACBrBase, ACBrDFeSSL,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio, ACBrJSON,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type

  TACBrNFSeXWebserviceAspec = class(TACBrNFSeXWebserviceRest)
  protected
    procedure SetHeaders(aHeaderReq: THTTPHeader); override;

  public
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderAspec = class (TACBrNFSeProviderProprio)
  private
    FpPath: string;
    FpMethod: string;
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function PrepararRpsParaLote(const aXml: string): string; override;

    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;

    procedure PrepararConsultaNFSeporNumero(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSeporNumero(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure PrepararSubstituiNFSe(Response: TNFSeSubstituiNFSeResponse); override;
    procedure TratarRetornoSubstituiNFSe(Response: TNFSeSubstituiNFSeResponse); override;

    procedure ProcessarMensagemDeErros(LJson: TACBrJSONObject;
                                     Response: TNFSeWebserviceResponse);
  end;

implementation

uses
  synacode,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  Aspec.GravarJson, Aspec.LerJson;

{ TACBrNFSeProviderAspec }

procedure TACBrNFSeProviderAspec.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
    ModoEnvio := meUnitario;
    ConsultaNFSe := False;
    FormatoArqEnvio := tfaJson;
    FormatoArqRetorno := tfaJson;
    FormatoArqEnvioSoap := tfaJson;
    FormatoArqRetornoSoap := tfaJson;
    FormatoArqRecibo := tfaJson;
    FormatoArqNota := tfaJson;

    Autenticacao.RequerCertificado := False;
    Autenticacao.RequerChaveAutorizacao := True;

    ServicosDisponibilizados.EnviarUnitario := True;
    ServicosDisponibilizados.ConsultarRps := True;
    ServicosDisponibilizados.ConsultarNfse := True;
    ServicosDisponibilizados.CancelarNfse := True;
    ServicosDisponibilizados.SubstituirNFSe := True;
  end;

  SetXmlNameSpace('');

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderAspec.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Aspec.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderAspec.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Aspec.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderAspec.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
  begin
    URL := URL + FpPath;
    Result := TACBrNFSeXWebserviceaspec.Create(FAOwner, AMetodo, URL, FpMethod);
  end
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderAspec.ProcessarMensagemDeErros(
  LJson: TACBrJSONObject; Response: TNFSeWebserviceResponse);
var
  JSonErro: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  i: Integer;
  xDetailError: String;
begin
  JSonErro := LJson.AsJSONObject['Message'];

  if not Assigned(JSonErro) then Exit;

  for i := 0 to JSonErro.AsJSONArray['DetailError'].Count - 1 do
    xDetailError := JSonErro.AsJSONArray['DetailError'].Items[i] + #13 + xDetailError;

  AErro := Response.Erros.New;
  AErro.Codigo := Trim(Copy(JSonErro.AsString['Code'], 6, 3));
  AErro.Descricao := TrimRight(JSonErro.AsString['Message'] + #13 +
                               JSonErro.AsString['MessageDev']);
  AErro.Correcao :=  TrimRight(JSonErro.AsString['Detail'] + #13 +
                               JSonErro.AsString['DetailDev'] + #13 +
                               xDetailError);
end;

function TACBrNFSeProviderAspec.PrepararRpsParaLote(const aXml: string): string;
begin
  Result := aXml;
end;

procedure TACBrNFSeProviderAspec.GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
  Params: TNFSeParamsResponse);
begin
  Response.ArquivoEnvio := Params.Xml;
  FpMethod := 'POST';
  FpPath := '';
end;

procedure TACBrNFSeProviderAspec.TratarRetornoEmitir
  (Response: TNFSeEmiteResponse);
var
  jDocument, jNfse: TACBrJSONObject;
  JSONArray: TACBrJSONArray;
  AErro: TNFSeEventoCollectionItem;
  AJsonString: string;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := ACBrStr(Desc201);
    Exit
  end;

  if (Copy(Response.ArquivoRetorno, 1, 1) = '[') then
  begin
    Try
      AJsonString := Response.ArquivoRetorno;
      if (AJsonString[1] = '[') and (AJsonString[Length(AJsonString)] = ']') then
        AJsonString := Copy(AJsonString, 2, Length(AJsonString) - 2);
      jDocument := TACBrJSONObject.Create;
      try
        jDocument := TACBrJSONObject.Parse(AJsonString);
        AErro := Response.Erros.New;
        AErro.Descricao := UTF8ToAnsi(jDocument.AsString['msg']);
      finally
        jDocument.Free;
      end;
      Response.Sucesso := (Response.Erros.Count = 0);
      Exit;
    Except
      AErro := Response.Erros.New;
      AErro.Descricao := Response.ArquivoRetorno;
      Response.Sucesso := (Response.Erros.Count = 0);
    End;
  end;

  if (Copy(Response.ArquivoRetorno, 1, 1) = '{') then
  begin
    jDocument := TACBrJSONObject.Parse(Response.ArquivoRetorno);

    try
      try
        ProcessarMensagemDeErros(jDocument, Response);
        Response.Sucesso := (Response.Erros.Count = 0);

        if Response.Sucesso then
        begin
          with Response do
          begin
            NumeroNota := jDocument.AsString['numeroNFSe'];
            CodigoVerificacao := jDocument.AsString['codigoVerificacao'];

            if AnsiPos('AMBIENTE DE TESTE', jDocument.AsString['msg'] ) > 0 then
            begin
              Sucesso := false;
              NumeroNota := '';
              DescSituacao := 'ATEN��O! AMBIENTE DE TESTE PARA VALIDA��O DE INTEGRA��O.';

              AErro := Response.Erros.New;
              AErro.Codigo := Cod999;
              AErro.Descricao := ACBrStr(jDocument.AsString['Mensagem']);
              AErro.Correcao :=  'ENTRAR EM CONTATO COM A PREFEITURA PARA PEDIR A MUDAN�A PARA AMBIENTE EM PRODU��O DO CNPJ DO EMISSOR';
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          Response.Sucesso := False;
          AErro := Response.Erros.New;
          AErro.Codigo := Cod999;
          AErro.Descricao := ACBrStr(Desc999 + E.Message);
        end;
      end;
    finally
      FreeAndNil(jDocument);
    end;
  end;
end;

procedure TACBrNFSeProviderAspec.PrepararConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  if EstaVazio(Response.NumeroRps) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod102;
    AErro.Descricao := ACBrStr(Desc102);
    Exit;
  end;

  Response.ArquivoEnvio := '?NumeroRps=' +
    Response.NumeroRps;

  FpPath := Response.ArquivoEnvio;
  FpMethod := 'GET';
end;

procedure TACBrNFSeProviderAspec.TratarRetornoConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  jDocument, jRps, jNfse, jCancel: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  NumRps: string;
  ANota: TNotaFiscal;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := ACBrStr(Desc201);
    Exit
  end;

  jDocument := TACBrJSONObject.Parse(Response.ArquivoRetorno);

  try
    try
      ProcessarMensagemDeErros(jDocument, Response);
      Response.Sucesso := (Response.Erros.Count = 0);

      if Response.Sucesso then
      begin
        jNfse := jDocument.AsJSONObject['DadosNfse'];
        jRps := jNfse.AsJSONObject['Rps'];
        NumRps := jRps.AsString['Numero'];

        if Assigned(jNfse) then
        begin
          with Response do
          begin
            NumeroNota := jNfse.AsString['NumeroNfse'];
            SerieNota := jRps.AsString['Serie'];
            Data := jNfse.AsISODateTime['DataEmissao'];
            Link := jNfse.AsString['LinkNfse'];
            Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
            Protocolo := jNfse.AsString['CodigoValidacao'];
            Situacao := jNfse.AsString['SituacaoNfse'];
            NumeroLote := NumRps;

            if Situacao = '2' then
            begin
              DescSituacao := 'Cancelada';
              jCancel := jNfse.AsJSONObject['Cancelamento'];
              DataCanc := jCancel.AsISODate['Data'];
            end
            else
              DescSituacao := 'Normal';
          end;

          if NumRps <> '' then
            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps)
          else
            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(Response.NumeroNota);

          ANota := CarregarXmlNfse(ANota, Response.ArquivoRetorno);
          SalvarXmlNfse(ANota);
        end;
      end;
    except
      on E: Exception do
      begin
        Response.Sucesso := False;
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(jDocument);
  end;
end;

procedure TACBrNFSeProviderAspec.PrepararConsultaNFSeporNumero(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  if EstaVazio(Response.InfConsultaNFSe.NumeroIniNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  Response.ArquivoEnvio := '?NumeroNfse=' +
    Response.InfConsultaNFSe.NumeroIniNFSe;

  FpPath := Response.ArquivoEnvio;
  FpMethod := 'GET';
end;

procedure TACBrNFSeProviderAspec.TratarRetornoConsultaNFSeporNumero
  (Response: TNFSeConsultaNFSeResponse);
var
  jDocument, jRps, jNfse, jCancel: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  NumRps: string;
  ANota: TNotaFiscal;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := ACBrStr(Desc201);
    Exit
  end;

  if Response.InfConsultaNFSe.tpRetorno = trXml then
  begin
    jDocument := TACBrJSONObject.Parse(Response.ArquivoRetorno);

    try
      try
        ProcessarMensagemDeErros(jDocument, Response);
        Response.Sucesso := (Response.Erros.Count = 0);

        if Response.Sucesso then
        begin
          jNfse := jDocument.AsJSONObject['DadosNfse'];
          jRps := jNfse.AsJSONObject['Rps'];
          NumRps := jRps.AsString['Numero'];

          if Assigned(jNfse) then
          begin
            with Response do
            begin
              NumeroNota := jNfse.AsString['NumeroNfse'];
              SerieNota := jRps.AsString['Serie'];
              Data := jNfse.AsISODateTime['DataEmissao'];
              Link := jNfse.AsString['LinkNfse'];
              Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
              Protocolo := jNfse.AsString['CodigoValidacao'];
              Situacao := jNfse.AsString['SituacaoNfse'];
              NumeroLote := NumRps;

              if Situacao = '2' then
              begin
                DescSituacao := 'Cancelada';
                jCancel := jNfse.AsJSONObject['Cancelamento'];
                DataCanc := jCancel.AsISODate['Data'];
              end
              else
                DescSituacao := 'Normal';
            end;

            if NumRps <> '' then
              ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps)
            else
              ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(Response.NumeroNota);

            ANota := CarregarXmlNfse(ANota, Response.ArquivoRetorno);
            SalvarXmlNfse(ANota);
          end;
        end;
      except
        on E: Exception do
        begin
          Response.Sucesso := False;
          AErro := Response.Erros.New;
          AErro.Codigo := Cod999;
          AErro.Descricao := ACBrStr(Desc999 + E.Message);
        end;
      end;
    finally
      FreeAndNil(jDocument);
    end;
  end;
end;

procedure TACBrNFSeProviderAspec.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  jo: TACBrJSONObject;
begin
  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.MotCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod110;
    AErro.Descricao := ACBrStr(Desc110);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  jo := TACBrJSONObject.Create;
  try
    with Response.InfCancelamento do
      jo
        .AddPairJSONObject('DadosNota', EmptyStr)
        .AsJSONObject['DadosNota']
          .AddPair('Numero', StrToIntDef(NumeroNFSe, 0))
          .AddPair('Cancelamento', TACBrJSONObject.Create
                                     .AddPair('Motivo', MotCancelamento))
          .AddPair('Prestador', TACBrJSONObject.Create
                                  .AddPair('InscricaoMunicipal', StrToIntDef(OnlyNumber(Emitente.InscMun), 0)));
    Response.ArquivoEnvio := jo.ToJSON;
  finally
    jo.Free;
  end;

  FpMethod := 'POST';
  FpPath := '';
end;

procedure TACBrNFSeProviderAspec.TratarRetornoCancelaNFSe
  (Response: TNFSeCancelaNFSeResponse);
var
  jDocument, jNfse: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
//  ANota: TNotaFiscal;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := ACBrStr(Desc201);
    Exit
  end;

  jDocument := TACBrJSONObject.Parse(Response.ArquivoRetorno);

  try
    try
      ProcessarMensagemDeErros(jDocument, Response);
      Response.Sucesso := (Response.Erros.Count = 0);

      if Response.Sucesso then
      begin
        jNfse := jDocument.AsJSONObject['DadosNfse'];

        if Assigned(jNfse) then
        begin
          with Response do
          begin
            NumeroNota := jNfse.AsString['Numero'];
            DataCanc := jNfse.AsISODate['DataCancelamento'];
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        Response.Sucesso := False;
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(jDocument);
  end;
end;

procedure TACBrNFSeProviderAspec.PrepararSubstituiNFSe(
  Response: TNFSeSubstituiNFSeResponse);
begin
  inherited;

end;

procedure TACBrNFSeProviderAspec.TratarRetornoSubstituiNFSe(
  Response: TNFSeSubstituiNFSeResponse);
begin
  inherited;

end;

{ TACBrNFSeXWebserviceaspec }

procedure TACBrNFSeXWebserviceaspec.SetHeaders(aHeaderReq: THTTPHeader);
begin
//  aHeaderReq.AddHeader('Authorization',
//             TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente.WSChaveAutoriz);
end;

function TACBrNFSeXWebserviceaspec.GerarNFSe(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceaspec.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceaspec.ConsultarNFSe(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceaspec.Cancelar(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceaspec.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceaspec.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := RemoverDeclaracaoXML(Result);
  Result := StringReplace(Result, '"}"}', '"}}', [rfReplaceAll]);
end;

end.
