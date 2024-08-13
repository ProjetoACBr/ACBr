{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit Giap.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrBase, ACBrDFeSSL,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceGiap = class(TACBrNFSeXWebserviceNoSoap)
  protected
    procedure SetHeaders(aHeaderReq: THTTPHeader); override;
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderGiap = class (TACBrNFSeProviderProprio)
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

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = '';
                                     const AMessageTag: string = 'Erro'); override;

  public
    function SituacaoTributariaToStr(const t: TnfseSituacaoTributaria): string; override;
    function StrToSituacaoTributaria(out ok: boolean; const s: string): TnfseSituacaoTributaria; override;
    function SituacaoTributariaDescricao(const t: TnfseSituacaoTributaria): string; override;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.FilesIO,
  ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  Giap.GravarXml, Giap.LerXml;

{ TACBrNFSeProviderGiap }

procedure TACBrNFSeProviderGiap.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := '';
    QuebradeLinha := sLineBreak;
    UseCertificateHTTP := False;
    UseAuthorizationHeader := True;
    ModoEnvio := meLoteAssincrono;
    ConsultaLote := False;
    ConsultaNFSe := False;

    Autenticacao.RequerCertificado := False;
    Autenticacao.RequerChaveAutorizacao := True;

    ServicosDisponibilizados.EnviarLoteAssincrono := True;
    ServicosDisponibilizados.ConsultarRps := True;
    ServicosDisponibilizados.CancelarNfse := True;

    Particularidades.PermiteTagOutrasInformacoes := True;
  end;

  SetXmlNameSpace('');

  with ConfigMsgDados do
  begin
    XmlRps.InfElemento := 'notaFiscal';
    XmlRps.DocElemento := 'nfe';

    LoteRps.InfElemento := 'notaFiscal';
    LoteRps.DocElemento := 'nfe';
  end;

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderGiap.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Giap.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderGiap.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Giap.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderGiap.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceGiap.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderGiap.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse;
  const AListTag, AMessageTag: string);

  function ObterValor(ANode: TACBrXmlNode; const ATag: string): string;
  var
    Node: TACBrXmlNode;
    Attr: TACBrXmlAttribute;
  begin
    Attr := ANode.Attributes.Items[ATag];
    if Attr <> nil then
      Result := ObterConteudoTag(Attr)
    else
    begin
      Node := ANode.Childrens.FindAnyNs(ATag);
      if Node <> nil then
        Result := ObterConteudoTag(Node, tcStr)
      else
        Result := '';
    end;
  end;

var
  I: Integer;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
begin
  ANode := RootNode.Document.Root.Childrens.FindAnyNs('notaFiscal');

  if not Assigned(ANode) then exit;

  if ObterConteudoTag(ANode.Childrens.FindAnyNs('statusEmissao'), tcInt) <> 200 then
  begin
    ANodeArray := ANode.Childrens.FindAllAnyNs('messages');

    for I := Low(ANodeArray) to High(ANodeArray) do
    begin
      ANode := ANodeArray[I];

      AErro := Response.Erros.New;
      AErro.Codigo := ObterValor(ANode, 'code');
      AErro.Descricao := ObterValor(ANode, 'message');
      AErro.Correcao := '';
    end;
  end;
end;

function TACBrNFSeProviderGiap.SituacaoTributariaDescricao(
  const t: TnfseSituacaoTributaria): string;
begin
  case t of
    stNormal:   Result := '0 - N�o' ;
    stRetencao: Result := '1 - Sim' ;
  else
    Result := '';
  end;
end;

function TACBrNFSeProviderGiap.SituacaoTributariaToStr(
  const t: TnfseSituacaoTributaria): string;
begin
  Result := EnumeradoToStr(t, ['0', '1'], [stNormal, stRetencao]);
end;

function TACBrNFSeProviderGiap.StrToSituacaoTributaria(out ok: boolean;
  const s: string): TnfseSituacaoTributaria;
begin
  Result := StrToEnumerado(ok, s, ['0', '1'], [stNormal, stRetencao]);
end;

function TACBrNFSeProviderGiap.PrepararRpsParaLote(const aXml: string): string;
begin
  Result := aXml;
end;

procedure TACBrNFSeProviderGiap.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
begin
  Response.ArquivoEnvio := '<nfe>' + Params.Xml + '</nfe>';
end;

procedure TACBrNFSeProviderGiap.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  AResumo: TNFSeResumoCollectionItem;
  ANodeArray: TACBrXmlNodeArray;
  ANode: TACBrXmlNode;
  i: Integer;
  ANota: TNotaFiscal;
  aNumeroNota, aCodigoVerificacao, aSituacao, aLink, aNumeroRps: string;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', '');

      Response.Sucesso := (Response.Erros.Count = 0);

      if Response.Sucesso then
      begin
        ANode := Document.Root;
        ANodeArray := ANode.Childrens.FindAllAnyNs('notaFiscal');

        if not Assigned(ANodeArray) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod203;
          AErro.Descricao := ACBrStr(Desc203);
          Exit;
        end;

        for I := Low(ANodeArray) to High(ANodeArray) do
        begin
          ANode := ANodeArray[I];

          aNumeroNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('numeroNota'), tcStr);
          aCodigoVerificacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('codigoVerificacao'), tcStr);
          aSituacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('statusEmissao'), tcStr);
          aLink := ObterConteudoTag(ANode.Childrens.FindAnyNs('link'), tcStr);
          aLink := StringReplace(aLink, '&amp;', '&', [rfReplaceAll]);
          aNumeroRps := ObterConteudoTag(ANode.Childrens.FindAnyNs('numeroRps'), tcStr);

          with Response do
          begin
            NumeroNota := aNumeroNota;
            CodigoVerificacao := aCodigoVerificacao;
            Situacao := aSituacao;
            Link := aLink;
            NumeroRps := aNumeroRps;
          end;

          AResumo := Response.Resumos.New;
          AResumo.NumeroNota := aNumeroNota;
          AResumo.CodigoVerificacao := aCodigoVerificacao;
          AResumo.NumeroRps := aNumeroRps;
          AResumo.Link := aLink;
          AResumo.Situacao := aSituacao;

          // GIAP N�o retorna o XML da Nota sendo necess�rio imprimir a Nota j�
          // gerada. Se N�o der erro, passo a Nota de Envio para ser impressa j�
          // que n�o deu erro na emiss�o.

          ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(aNumeroRps);
          ANota := CarregarXmlNfse(ANota, Response.XmlEnvio);

          {
           Carregando dados da NFS-e emitida que n�o constam no XML de envio e
           s� retornam no Response
          }
          with ANota.NFSe do
          begin
             Numero := aNumeroNota;
             CodigoVerificacao := aCodigoVerificacao;
             Link := aLink;
             IdentificacaoRps.Numero := aNumeroRps;
             ANota.LerXML(ANota.GerarXML);
          end;

          SalvarXmlNfse(ANota);
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

procedure TACBrNFSeProviderGiap.PrepararConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if EstaVazio(Response.CodigoVerificacao) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod117;
    AErro.Descricao := ACBrStr(Desc117);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.ArquivoEnvio := '<consulta>' +
                              '<inscricaoMunicipal>' +
                                OnlyNumber(Emitente.InscMun) +
                              '</inscricaoMunicipal>' +
                              '<codigoVerificacao>' +
                                Response.CodigoVerificacao +
                              '</codigoVerificacao>' +
                           '</consulta>';
end;

procedure TACBrNFSeProviderGiap.TratarRetornoConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', '');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      if ANode <> nil then
      begin
        Response.CodigoVerificacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('codigoVerificacao'), tcStr);

        if ObterConteudoTag(ANode.Childrens.FindAnyNs('notaExiste'), tcStr) = 'Sim' then
          Response.DescSituacao := ACBrStr('Nota Autorizada')
        else
        if ObterConteudoTag(ANode.Childrens.FindAnyNs('notaExiste'), tcStr) = 'Cancelada' then
        begin
          Response.DescSituacao := ACBrStr('Nota Cancelada');
          Response.Cancelamento.DataHora := ObterConteudoTag(ANode.Childrens.FindAnyNs('dataCancelamento'), tcDatVcto);
          Response.Cancelamento.Motivo := ACBrStr('Nota Cancelada');
        end
        else
          Response.DescSituacao := ACBrStr('Nota n�o Encontrada');

        Response.NumeroNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('numeroNota'), tcStr);
        Response.Link := ObterConteudoTag(ANode.Childrens.FindAnyNs('wsLink'), tcStr);
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

procedure TACBrNFSeProviderGiap.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  if EstaVazio(Response.InfCancelamento.CodCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod109;
    AErro.Descricao := ACBrStr(Desc109);
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  Response.ArquivoEnvio := '<nfe>' +
                             '<cancelaNota>' +
                               '<codigoMotivo>' +
                                  Response.InfCancelamento.CodCancelamento +
                               '</codigoMotivo>' +
                               '<numeroNota>' +
                                  Response.InfCancelamento.NumeroNFSe +
                               '</numeroNota>' +
                             '</cancelaNota>' +
                           '</nfe>';
end;

procedure TACBrNFSeProviderGiap.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  I: Integer;
  NumRps: String;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', '');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      Response.NumeroLote := ObterConteudoTag(ANode.Childrens.FindAnyNs('NumeroLote'), tcStr);

      ANodeArray := ANode.Childrens.FindAllAnyNs('notaFiscal');

      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := ACBrStr(Desc203);
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];

        if ANode <> nil then
          NumRps := ObterConteudoTag(ANode.Childrens.FindAnyNs('numeroRps'), tcStr);

        // Ele n�o retorna o XML por isso nao posso salvar o retorno,
        // se n�o ira sobreescrever o XML de envio.
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

{ TACBrNFSeXWebserviceGiap }

procedure TACBrNFSeXWebserviceGiap.SetHeaders(aHeaderReq: THTTPHeader);
var
  Auth, Token: string;
begin
  with TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente do
  begin
    Token := WSChaveAutoriz;
    Auth := InscMun + '-' + Token;
//    Auth := InscMun + '-' + UpperCase(EncodeBase64(Token));
  end;

  aHeaderReq.AddHeader('Authorization', Auth);
  aHeaderReq.AddHeader('postman-token', Token);
end;

function TACBrNFSeXWebserviceGiap.TratarXmlRetornado(
  const aXML: string): string;
begin
  if StringIsXML(aXML) then
  begin
    Result := inherited TratarXmlRetornado(aXML);

//    Result := String(NativeStringToUTF8(Result));
    Result := ParseText(Result);
    Result := RemoverDeclaracaoXML(Result);
    Result := RemoverIdentacao(Result);
    Result := RemoverCaracteresDesnecessarios(Result);
    Result := Trim(StringReplace(Result, '&', '&amp;', [rfReplaceAll]));
  end
  else
  begin
    Result := '<nfeReposta>' +
                '<notaFiscal>' +
                  '<messages>' +
                    '<code>' + '</code>' +
                    '<message>' + aXML + '</message>' +
                    '<Correcao>' + '</Correcao>' +
                  '</messages>' +
                '</notaFiscal>' +
              '</nfeReposta>';

    Result := ParseText(Result);
//    Result := String(NativeStringToUTF8(Result));
  end;
end;

function TACBrNFSeXWebserviceGiap.Recepcionar(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceGiap.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceGiap.Cancelar(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

end.
