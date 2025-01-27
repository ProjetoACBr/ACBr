{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Renato Tanchela Rubinho                         }
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

unit Prescon.Provider;

interface

uses
  SysUtils, StrUtils, Classes, Variants,
  ACBrDFeSSL, ACBrUtil.XMLHTML, StrUtilsEx,
  ACBrXmlBase, ACBrXmlDocument, ACBrJSON,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebservicePrescon = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;
    function GerarToken(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderPrescon = class (TACBrNFSeProviderProprio)
  private
    function GetDescricaoErro(codigo: string): string;
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function PrepararRpsParaLote(const aXml: string): string; override;

    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure PrepararGerarToken(Response: TNFSeGerarTokenResponse); override;
    procedure TratarRetornoGerarToken(Response: TNFSeGerarTokenResponse); override;

    function AplicarLineBreak(const AXMLRps: string; const ABreak: string): string; override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = '';
                                     const AMessageTag: string = ''); override;
  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  Prescon.GravarJson, Prescon.LerJson, ACBrNFSeXProviderBase,
  ACBrNFSeXParametros;

{ TACBrNFSeProviderPrescon }

procedure TACBrNFSeProviderPrescon.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    ModoEnvio := meLoteSincrono;
    CancPreencherMotivo := True;
    FormatoArqRecibo := tfaJson;
    FormatoArqNota := tfaJson;

    Autenticacao.RequerLogin := True;
    Autenticacao.RequerChaveAutorizacao := True;

    ServicosDisponibilizados.EnviarLoteAssincrono := True;
    ServicosDisponibilizados.ConsultarRps := True;
    ServicosDisponibilizados.ConsultarFaixaNfse := True;
    ServicosDisponibilizados.CancelarNfse := True;
    ServicosDisponibilizados.GerarToken := True;
  end;

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderPrescon.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Prescon.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderPrescon.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Prescon.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderPrescon.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebservicePrescon.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderPrescon.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse;
  const AListTag, AMessageTag: string);
var
  I: Integer;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  vRetorno: string;
begin
  ANodeArray := RootNode.Childrens.FindAllAnyNs(AListTag);

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    // O provedor devolve Erros, Token, "Pr�ximo N�mero de NFSe" ou json sempre na mesma tag "retorno"
    vRetorno := Trim(ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('retorno'), tcStr));

    if vRetorno <> '' then
    begin
      // Retornos de emiss�o e cancelamento com sucesso
      if (Copy(vRetorno, 1, 7) = 'Sucesso') or
         (vRetorno = 'Notas canceladas com sucesso') then
        vRetorno := ''

      // Se o retorno for um json, n�o � erro
      else if (Copy(vRetorno, 1, 2) = '[{') or (Copy(vRetorno, 1, 2) = '{"') then
        vRetorno := ''

      // Para o m�todo que retorna o token, verifica se retornou um valor v�lido, sen�o � um erro
      else if AListTag = 'getTokenResponse' then
      begin
        if (Length(vRetorno) = 32) and (StringReplace(vRetorno,' ', '', [rfReplaceAll]) = vRetorno) then
          vRetorno := '';
      end

      // Para o m�todo que retorna o pr�ximo n�mero de NFe, verifica se retornou um n�mero v�lido, sen�o � um erro
      else if AListTag = 'getNextInvoiceResponse' then
      begin
        if StrToIntDef(vRetorno,0) > 0 then
          vRetorno := '';
      end;    

      if vRetorno <> '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := vRetorno;
        AErro.Descricao := GetDescricaoErro(vRetorno);
        AErro.Correcao := '';
      end;
    end;
  end;
end;

function TACBrNFSeProviderPrescon.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := aXml;
end;

procedure TACBrNFSeProviderPrescon.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  I: Integer;
begin
  Response.Clear;

  // Se o n�mero da NFSe n�o foi preenchido, alerta que para este provedor precisa consultar o n�mero a ser utilizado, atrav�s do m�todo ConsultarNFSePorFaixa.
  for i:=0 to TACBrNFSeX(FAOwner).NotasFiscais.Count - 1 do
  begin
    if StrToIntDef(TACBrNFSeX(FAOwner).NotasFiscais.Items[i].NFSe.Numero,0) = 0 then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod999;
      AErro.Descricao := ACBrStr('N�mero da NFSe n�o informado. Utilize o ConsultarNFSePorFaixa para receber o pr�ximo n�mero do provedor.');
      Exit;
    end;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  if EstaVazio(Emitente.WSChaveAutoriz) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod125;
    AErro.Descricao := ACBrStr(Desc125);
    Exit;
  end;

  Response.ArquivoEnvio := '<setInvoice soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' +
                             '<strJsonInvoice xsi:type="xsd:string">' +
                               Params.Xml +
                             '</strJsonInvoice>' +
                             '<strToken xsi:type="xsd:string">' +
                               Emitente.WSChaveAutoriz +
                             '</strToken>' +
                           '</setInvoice>';
end;

procedure TACBrNFSeProviderPrescon.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  AuxNode: TACBrXmlNode;
  retorno: String;
  str: String;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Document.LoadFromXml('<grupo>' + Response.ArquivoRetorno + '</grupo>');

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'setInvoiceResponse', 'retorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('setInvoiceResponse');

      if not Assigned(AuxNode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod202;
        AErro.Descricao := ACBrStr(Desc202);
        Exit;
      end;

      if Response.Sucesso then
      begin
        with Response do
        begin
          // Exemplo de retorno com sucesso:
          // Sucesso | Nota: 1234 cod.Autentica��o: 12ab34 |
          retorno := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('retorno'), tcStr);

          // Extrai o n�mero da Nota
          I := Pos('Nota:',retorno);
          if I > 0 then
          begin
            str := Trim(Copy(retorno,I+5,Length(retorno)));

            I := Pos(' ',str);

            str := Copy(str,1,I-1);

            if StrToIntDef(str,0) > 0 then
              NumeroNota := str;
          end;

          // Extrai o c�digo de verifica��o
          I := Pos('cod.Autentica��o:',retorno);
          if I > 0 then
          begin
            str := Trim(Copy(retorno,I+17,Length(retorno)));

            I := Pos(' ',str);

            str := Copy(str,1,I-1);

            CodigoVerificacao := str;
          end;

          // Gera o link
          if (NumeroNota <> '') and (CodigoVerificacao <> '') then
            Link := TACBrNFSeX(FAOwner).LinkNFSe(NumeroNota, CodigoVerificacao);
        end;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderPrescon.PrepararConsultaNFSeporFaixa(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;                                           
begin
  Response.Clear;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  if EstaVazio(Emitente.WSChaveAutoriz) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod125;
    AErro.Descricao := ACBrStr(Desc125);
    Exit;
  end;

  Response.Metodo := tmConsultarNFSePorFaixa;

  Response.ArquivoEnvio := '<getNextInvoice soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' +
                             '<strToken xsi:type="xsd:string">' +
                               Emitente.WSChaveAutoriz +
                             '</strToken>' +
                           '</getNextInvoice>';
end;

procedure TACBrNFSeProviderPrescon.TratarRetornoConsultaNFSeporFaixa(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  AuxNode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Document.LoadFromXml('<grupo>' + Response.ArquivoRetorno + '</grupo>');

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'getNextInvoiceResponse', 'retorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('getNextInvoiceResponse');

      if not Assigned(AuxNode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod213;
        AErro.Descricao := ACBrStr(Desc213);
        Exit;
      end;

      if Response.Sucesso then
      begin
        with Response do
        begin
          NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('retorno'), tcStr);

          Sucesso := (NumeroNota <> '');
        end;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderPrescon.PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  if EstaVazio(Emitente.WSChaveAutoriz) then
  begin
    AErro := Response.Erros.New;
    AErro.codigo := Cod125;
    AErro.Descricao := ACBrStr(Desc125);
    Exit;
  end;

  if EstaVazio(Response.CodigoVerificacao) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod117;
    AErro.Descricao := ACBrStr(Desc117);
    Exit;
  end;
end;

procedure TACBrNFSeProviderPrescon.TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANota: TNotaFiscal;
  ANode: TACBrXmlNode;
  NumNFSe: string;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + 'Webservice n�o retornou informa��es');
        Exit;
      end;

      NumNFSe := ObterConteudoTag(ANode.Childrens.FindAnyNs('numeroNota'), tcStr);

      ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumNFSe);

      ANota := CarregarXmlNfse(ANota, ANode.OuterXml);

      SalvarXmlNfse(ANota);

      Response.Sucesso := (Response.Erros.Count = 0);
    except
      on E: Exception do
      begin
        AErro := Response.Erros.New;
        AErro.codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderPrescon.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  LJSonArray: TACBrJSONArray;
  AJSon: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  jsonText: string;
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

  if EstaVazio(Emitente.WSChaveAutoriz) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod125;
    AErro.Descricao := ACBrStr(Desc125);
    Exit;
  end;

  if EstaVazio(Emitente.InscMun) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod129;
    AErro.Descricao := ACBrStr(Desc129);
    Exit;
  end;

  AJSon := TACBrJsonObject.Create;
  LJSonArray := TACBrJSONArray.Create;

  try
    AJSon
      .AddPair('im', Emitente.InscMun)
      .AddPair('numeroNota', Response.InfCancelamento.NumeroNFSe)
      .AddPair('motivoCancelamento', Response.InfCancelamento.MotCancelamento);

    LJSonArray
      .AddElementJSON( AJSon );

    jsonText := LJSonArray.ToJSON;
  finally
    LJSonArray.Free;
  end;

  Response.ArquivoEnvio := '<setCancelNfeOnly soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' +
                             '<strJsonCancelInvoice xsi:type="xsd:string">' +
                               jsonText +
                             '</strJsonCancelInvoice>' +
                             '<strToken xsi:type="xsd:string">' +
                               Emitente.WSChaveAutoriz +
                             '</strToken>' +
                           '</setCancelNfeOnly>';
end;

procedure TACBrNFSeProviderPrescon.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  AuxNode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Document.LoadFromXml('<grupo>' + Response.ArquivoRetorno + '</grupo>');

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'setCancelNfeOnlyResponse', 'retorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('setCancelNfeOnlyResponse');

      if not Assigned(AuxNode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod209;
        AErro.Descricao := ACBrStr(Desc209);
        Exit;
      end;

      if Response.Sucesso then
      begin
        with Response do
        begin
          RetCancelamento.MsgCanc := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('retorno'), tcStr);
        end;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderPrescon.PrepararGerarToken(
  Response: TNFSeGerarTokenResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  Response.Clear;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  if EstaVazio(Emitente.InscMun) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod129;
    AErro.Descricao := ACBrStr(Desc129);
    Exit;
  end;

  if EstaVazio(Emitente.WSSenha) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod120;
    AErro.Descricao := ACBrStr(Desc120);
    Exit;
  end;

  Response.ArquivoEnvio := '<getToken soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' +
                             '<strInscricaoMunicipal xsi:type="xsd:string">' +
                               Emitente.InscMun +
                             '</strInscricaoMunicipal>' +
                             '<strSenha xsi:type="xsd:string">' +
                               Emitente.WSSenha +
                             '</strSenha>' +
                           '</getToken>';
end;

procedure TACBrNFSeProviderPrescon.TratarRetornoGerarToken(
  Response: TNFSeGerarTokenResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  AuxNode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Document.LoadFromXml('<grupo>' + Response.ArquivoRetorno + '</grupo>');

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'getTokenResponse', 'retorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('getTokenResponse');

      if not Assigned(AuxNode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod213;
        AErro.Descricao := ACBrStr(Desc213);
        Exit;
      end;

      if Response.Sucesso then
      begin
        with Response do
        begin
          Token := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('retorno'), tcStr);

          Sucesso := (Token <> '');
        end;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

function TACBrNFSeProviderPrescon.AplicarLineBreak(const AXMLRps: string;
  const ABreak: string): string;
begin
  Result := AXMLRps;
  if Trim(Result) <> '' then
  begin
    Result := ChangeLineBreak(AXMLRps, '&#10;');
    Result := StringReplace(Result, '&amp;#10;', '&#10;', [rfReplaceAll]);
  end;
end;

function TACBrNFSeProviderPrescon.GetDescricaoErro(codigo: string): string;
var
  I: Integer;
  Valor: String;
begin
  I := Pos('-',codigo);
  if I > 0 then
    codigo := Copy(codigo,1,I-1);

  if (Copy(codigo,1,2) = 'DT') or (Copy(codigo,1,2) = 'NF') then
  begin
    I := StrToIntDef(Copy(codigo,3,Length(codigo)),-1);

    if I >= 0 then
    begin
      codigo := Copy(codigo,1,2);
      Valor := Copy(codigo,3,Length(codigo));
    end;
  end
  else if Copy(codigo,1,4) = 'ATV-' then
    codigo := Copy(codigo,1,3);

  case AnsiIndexStr(codigo, ['L001', 'L002', 'S000', 'S000', 'S001', 'S002', 'S003', 'S004', 'S005', 'S006',
                             'S007', 'S008', 'S009', 'S010', 'S011', 'S012', 'S013', 'S014', 'S015', 'S016',
                             'S017', 'S018', 'S019', 'S020', 'S021', 'S022', 'S023', 'S025', 'S026', 'S027',
                             'S028', 'S029', 'S030', 'S031', 'S032', 'S033', 'S034', 'S035', 'S037',
                             'DT', 'NF', 'S9999', 'S045', 'ATV']) of
     0 : Result := 'Usu�rio ou senha inv�lidos.' +
       ' Verificar com o respons�vel do uso do sistema se os dados de usu�rio e senha est�o corretos';
     1 : Result := 'Erro interno.' +
       ' Entrar em contato com o suporte da Prescon Informa�tica.(tributos@presconinformatica.com.br)';
     2 : Result := 'Erro na estrutura do JSON';
     3 : Result := 'Campo im n�o encontrado no arquivo JSON';
     4 : Result := 'Campo NumeroNota n�o encontrado no arquivo JSON';
     5 : Result := 'Campo NumeroNota n�o encontrado no arquivo JSON';
     6 : Result := 'Campo DataEmissao n�o encontrado no arquivo JSON';
     7 : Result := 'Campo NomeTomador n�o encontrado no arquivo JSON';
     8 : Result := 'Campo tipoDocTomador n�o encontrado no arquivo JSON';
     9 : Result := 'Campo documentoTomador n�o encontrado no arquivo JSON';
    10 : Result := 'Campo InscricaoEstadualTomador n�o encontrado no arquivo JSON';
    11 : Result := 'Campo logradouroTomador n�o encontrado no arquivo JSON';
    12 : Result := 'Campo numeroTomador n�o encontrado no arquivo JSON';
    13 : Result := 'Campo complementoTomador n�o encontrado no arquivo JSON';
    14 : Result := 'Campo bairroTomador n�o encontrado no arquivo JSON';
    15 : Result := 'Campo cidadeTomador n�o encontrado no arquivo JSON';
    16 : Result := 'Campo ufTomador n�o encontrado no arquivo JSON';
    17 : Result := 'Campo PAISTomador n�o encontrado no arquivo JSON';
    18 : Result := 'Campo emailTomador n�o encontrado no arquivo JSON';
    19 : Result := 'Campo logradouroServico n�o encontrado no arquivo JSON';
    20 : Result := 'Campo CEPTomador n�o encontrado no arquivo JSON';
    21 : Result := 'Campo numeroServico n�o encontrado no arquivo JSON';
    22 : Result := 'Campo complementoServico n�o encontrado no arquivo JSON';
    23 : Result := 'Campo bairroServico n�o encontrado no arquivo JSON';
    24 : Result := 'Campo cidadeServico n�o encontrado no arquivo JSON';
    25 : Result := 'Campo ufServico n�o encontrado no arquivo JSON';
    26 : Result := 'Campo issRetido n�o encontrado no arquivo JSON';
    27 : Result := 'Campo observa��o n�o encontrado no arquivo JSON';
    28 : Result := 'Campo INSS n�o encontrado no arquivo JSON';
    29 : Result := 'Campo IRPJ n�o encontrado no arquivo JSON';
    30 : Result := 'Campo CSLL n�o encontrado no arquivo JSON';
    31 : Result := 'Campo COFINS n�o encontrado no arquivo JSON';
    32 : Result := 'Campo PISPASEP n�o encontrado no arquivo JSON';
    33 : Result := 'Campo CEPServico n�o encontrado no arquivo JSON';
    34 : Result := 'Campo PAISServico n�o encontrado no arquivo JSON';
    35 : Result := 'Campo descri��o n�o encontrado no arquivo JSON';
    36 : Result := 'Campo atividade n�o encontrado no arquivo JSON';
    37 : Result := 'Campo valor n�o encontrado no arquivo JSON';
    38 : Result := 'Campo deducaoMaterial n�o encontrado no arquivo JSON';
    39 : Result := 'Erro na sequ�ncia das Data onde ' + Valor + ' � o n�mero da NF.' +
      ' Verificar com o respons�vel pela gera��o do arquivo JSON se data de emiss�o est� de forma sequencial.';
    40 : Result := 'Erro na sequ�ncia das Notas Fiscais onde ' + Valor + ' � o n�mero da NF.' +
      ' Verificar com o respons�vel pela gera��o do  arquivo JSON se a numera��o das notas fiscais est�o de forma sequencial.';
    41 : Result := 'Erro no formato do arquivo enviado.' +
      ' Verificar se o JSON enviado est� de acordo, com os campos definidos na documenta��o.';
    42 : Result := 'Consta numera��o no arquivo enviado que j� foi gravada no banco de dados.' +
      ' Verificar o arquivo enviado, se as numera��es contidas no JSON enviado encontram-se gravadas no sistema';
    43 : Result := 'Consta no arquivo enviado notas onde o c�digo de atividade mencionada n�o pertence a empresa.' +
      ' Verificar as atividades que podem ser utilizadas no envio, no menu->Relat�rios->Minhas Atividades, do sistema Web.';
  else
    if UpperCase(codigo) = 'ERRO' then
      Result := 'Ocorreu um erro no provedor, sem retorno do motivo. Entre em contato com o provedor.'
    else
      Result := '';
  end;
end;

{ TACBrNFSeXWebservicePrescon }

function TACBrNFSeXWebservicePrescon.Recepcionar(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [''],
    ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"']);
end;

function TACBrNFSeXWebservicePrescon.ConsultarNFSePorFaixa(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [''],
    ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"']);
end;

function TACBrNFSeXWebservicePrescon.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  CodVerif: string;
begin
  CodVerif := TACBrNFSeX(FPDFeOwner).WebService.ConsultaNFSeporRps.CodigoVerificacao;

  FPMsgOrig := AMSG;
  FPUrl := FPUrl + '?codigo=' + CodVerif + '&nome=xml';
  FPMethod := 'GET';

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebservicePrescon.Cancelar(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [''],
    ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"']);
end;

function TACBrNFSeXWebservicePrescon.GerarToken(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [''],
    ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"']);
end;

function TACBrNFSeXWebservicePrescon.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := aXML;
  // Tratamentos para o xml da NFSe identificando a chave com grafia errada e prevendo a corre��o pelo provedor
  // N�o usar o m�todo herdado, pois a consulta j� devolve apenas o xml da NFe, sem body 
  if (Pos('<NfeCabecario>',Result) = 0) and (Pos('<NfeCabecalho>',Result) = 0) then
    Result := inherited TratarXmlRetornado(Result);

  Result := RemoverIdentacao(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
end;

end.
