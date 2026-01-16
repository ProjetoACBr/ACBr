{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit ABase.Provider;

interface

uses
  SysUtils, Classes,
  ACBrBase,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXClass,
  ACBrNFSeXConversao,
  ACBrNFSeXGravarXml,
  ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase,
  ACBrNFSeXWebservicesResponse,
  PadraoNacional.Provider;

type
  TACBrNFSeXWebserviceABase201 = class(TACBrNFSeXWebserviceSoap11)

  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderABase201 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
  end;

  TACBrNFSeXWebserviceABaseAPIPropria = class(TACBrNFSeXWebserviceRest)
  protected
    procedure SetHeaders(aHeaderReq: THTTPHeader); override;

  public
    function GerarNFSe(const ACabecalho, AMSG: string): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorChave(const ACabecalho, AMSG: string): string; override;

    // Cancelamento sendo implementado pelo provedor

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderABaseAPIPropria = class(TACBrNFSeProviderPadraoNacional)
  private

  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function VerificarAlerta(const ACodigo, AMensagem, ACorrecao: string): Boolean;
    function VerificarErro(const ACodigo, AMensagem, ACorrecao: string): Boolean;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = 'Erros';
                                     const AMessageTag: string = 'Erro'); override;

    function PrepararArquivoEnvio(const aXml: string; aMetodo: TMetodo): string; override;

    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;

    procedure PrepararConsultaNFSeporChave(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSeporChave(Response: TNFSeConsultaNFSeResponse); override;

    // Cancelamento sendo implementado pelo provedor
  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrUtil.Strings,
  ACBrUtil.Base,
  ACBrDFeException,
  ACBrDFe.Conversao,
  ACBrNFSeXConsts,
  ACBrNFSeX,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXConfiguracoes,
  ABase.GravarXml,
  ABase.LerXml;

{ TACBrNFSeXWebserviceABase201 }

function TACBrNFSeXWebserviceABase201.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:RecepcionarLoteRps' +
                ' xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';

  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:RecepcionarLoteRps>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/RecepcionarLoteRps',
                     Request,
                     ['RecepcionarLoteRpsResult', 'EnviarLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceABase201.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:ConsultaLoteRps' +
                ' xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';

  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:ConsultaLoteRps>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/ConsultaLoteRps',
                     Request,
                     ['ConsultaLoteRpsResult', 'ConsultarLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceABase201.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:ConsultaNfseRps xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:ConsultaNfseRps>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/ConsultaNfseRps',
                     Request,
                     ['ConsultaNfseRpsResult', 'ConsultarNfseRpsResposta'], []);
end;

function TACBrNFSeXWebserviceABase201.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:CancelaNfse xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:CancelaNfse>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/CancelaNfse',
                     Request,
                     ['CancelaNfseResult', 'CancelarNfseResposta'], []);
end;

{ TACBrNFSeProviderABase201 }

procedure TACBrNFSeProviderABase201.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
    ModoEnvio := meLoteAssincrono;
    ConsultaNFSe := False;

    ServicosDisponibilizados.EnviarLoteSincrono := False;
    ServicosDisponibilizados.EnviarUnitario := False;
    ServicosDisponibilizados.ConsultarFaixaNfse := False;
    ServicosDisponibilizados.ConsultarServicoPrestado := False;
    ServicosDisponibilizados.ConsultarServicoTomado := False;
    ServicosDisponibilizados.SubstituirNfse := False;

    Particularidades.PermiteTagOutrasInformacoes := True;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
    RpsSubstituirNFSe := True;
  end;

  SetXmlNameSpace('http://nfse.abase.com.br/nfse.xsd');

  with ConfigWebServices do
  begin
    VersaoDados := '2.01';
    VersaoAtrib := '2.01';
  end;

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');
end;

function TACBrNFSeProviderABase201.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ABase201.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderABase201.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ABase201.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderABase201.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceABase201.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderABase201.TratarRetornoConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode, AuxNodeConf: TACBrXmlNode;
  AErro: TNFSeEventoCollectionItem;
  ANota: TNotaFiscal;
  NumNFSe, NumRps: String;
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

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root.Childrens.FindAnyNs('ListaNfse');

      if ANode = nil then
        ANode := Document.Root.Childrens.FindAnyNs('CompNfse')
      else
        ANode := ANode.Childrens.FindAnyNs('CompNfse');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := ACBrStr(Desc203);
        Exit;
      end;

      AuxNode := ANode.Childrens.FindAnyNs('NfseCancelamento');

      if AuxNode <> nil then
      begin
        AuxNodeConf := AuxNode.Childrens.FindAnyNs('Confirmacao');

        if AuxNodeConf = nil then
          AuxNodeConf := AuxNode.Childrens.FindAnyNs('ConfirmacaoCancelamento');
        if not Assigned(AuxNodeConf) then Exit;

//        Response.DataCanc := LerDatas(ObterConteudoTag(AuxNodeConf.Childrens.FindAnyNs('DataHora'), tcStr));
        Response.DataCanc := ObterConteudoTag(AuxNodeConf.Childrens.FindAnyNs('DataHora'), FpFormatoDataHora);
        Response.DescSituacao := '';

        if Response.DataCanc > 0 then
          Response.DescSituacao := 'Nota Cancelada';
      end;

      AuxNode := ANode.Childrens.FindAnyNs('Nfse');

      if AuxNode <> nil then
      begin
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        if not Assigned(AuxNode) then Exit;

        NumNFSe := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);

        with Response do
        begin
          NumeroNota := NumNFSe;
          CodigoVerificacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CodigoVerificacao'), tcStr);
          Data := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('DataEmissao'), FpFormatoDataEmissao);
        end;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumNFSe);

        if ANota = nil then
        begin
          AuxNode := AuxNode.Childrens.FindAnyNs('IdentificacaoRps');
          if not Assigned(AuxNode) then Exit;

          NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);

          ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);
        end;

        ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
        SalvarXmlNfse(ANota);
      end
      else
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := ACBrStr(Desc203);
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

function TACBrNFSeXWebserviceABase201.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
end;

{ TACBrNFSeProviderABaseAPIPropria }

procedure TACBrNFSeProviderABaseAPIPropria.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    ConsultaLote := True;

    FormatoArqEnvio := tfaXml;
    FormatoArqRetorno := tfaXml;
    FormatoArqEnvioSoap := tfaXml;
    FormatoArqRetornoSoap := tfaXml;

    ServicosDisponibilizados.ConsultarLote := True;
  end;
end;

function TACBrNFSeProviderABaseAPIPropria.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ABaseAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderABaseAPIPropria.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ABaseAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderABaseAPIPropria.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
  begin
    URL := URL + Path;

    Result := TACBrNFSeXWebserviceABaseAPIPropria.Create(FAOwner, AMetodo, URL,
      Method, 'application/xml');
  end
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderABaseAPIPropria.VerificarAlerta(const ACodigo,
  AMensagem, ACorrecao: string): Boolean;
begin
  Result := ((AMensagem <> '') or (ACorrecao <> '')) and (Pos('L000', ACodigo) > 0);
end;

function TACBrNFSeProviderABaseAPIPropria.VerificarErro(const ACodigo,
  AMensagem, ACorrecao: string): Boolean;
begin
  Result := ((AMensagem <> '') or (ACorrecao <> '')) and (Pos('L000', ACodigo) = 0);
end;

procedure TACBrNFSeProviderABaseAPIPropria.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse; const AListTag,
  AMessageTag: string);
var
  I: Integer;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AAlerta: TNFSeEventoCollectionItem;
  Codigo, Mensagem: string;

procedure ProcessarErro(ErrorNode: TACBrXmlNode; const ACodigo, AMensagem: string);
var
  Item: TNFSeEventoCollectionItem;
  Correcao: string;
begin
  Correcao := ObterConteudoTag(ErrorNode.Childrens.FindAnyNs('Correcao'), tcStr);

  if (ACodigo = '') and (AMensagem = '') then
    Exit;

  if VerificarAlerta(ACodigo, AMensagem, Correcao) then
    Item := Response.Alertas.New
  else if VerificarErro(ACodigo, AMensagem, Correcao) then
    Item := Response.Erros.New
  else
    Exit;

  Item.Codigo := ACodigo;
  Item.Descricao := AMensagem;
  Item.Correcao := Correcao;
end;

procedure ProcessarErros;
var
  I: Integer;
begin
  if Assigned(ANode) then
  begin
    ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

    if Assigned(ANodeArray) then
    begin
      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Codigo'), tcStr);
        Mensagem := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Descricao'), tcStr);

        ProcessarErro(ANodeArray[I], Codigo, Mensagem);
      end;
    end
    else
    begin
      Codigo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Codigo'), tcStr);
      Mensagem := ObterConteudoTag(ANode.Childrens.FindAnyNs('Descricao'), tcStr);

      ProcessarErro(ANode, Codigo, Mensagem);
    end;
  end;
end;

begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  ProcessarErros;

  ANode := RootNode.Childrens.FindAnyNs('Erros');

  if Assigned(ANode) then
  begin
    ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

    if Assigned(ANodeArray) then
    begin
      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        Mensagem := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Descricao'), tcStr);

        if Mensagem <> '' then
        begin
          AAlerta := Response.Alertas.New;
          AAlerta.Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Codigo'), tcStr);
          AAlerta.Descricao := Mensagem;
          AAlerta.Correcao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Correcao'), tcStr);
        end;
      end;
    end
    else
    begin
      Mensagem := ObterConteudoTag(ANode.Childrens.FindAnyNs('Erro'), tcStr);

      if Mensagem <> '' then
      begin
        AAlerta := Response.Alertas.New;
        AAlerta.Codigo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Codigo'), tcStr);
        AAlerta.Descricao := Mensagem;
        AAlerta.Correcao := ObterConteudoTag(ANode.Childrens.FindAnyNs('Correcao'), tcStr);
      end;
    end;
  end;
end;

function TACBrNFSeProviderABaseAPIPropria.PrepararArquivoEnvio(
  const aXml: string; aMetodo: TMetodo): string;
begin
  if aMetodo in [tmGerar, tmEnviarEvento] then
  begin
    Result := ChangeLineBreak(aXml, '');

    case aMetodo of
      tmGerar:
        begin
          Path := '/recepcionardps';
        end;

      tmEnviarEvento:
        begin
          Result := '{"pedidoRegistroEventoXmlGZipB64":"' + Result + '"}';
          Path := '/nfse/' + Chave + '/eventos';
        end;
    else
      begin
        Result := '';
        Path := '';
      end;
    end;

    Method := 'POST';
  end;
end;

procedure TACBrNFSeProviderABaseAPIPropria.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
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

      ProcessarMensagemErros(Document.Root, Response);

      ANode := Document.Root;

      Response.Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataHoraRecebimento'), tcDatHor);
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Protocolo'), tcStr);
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

procedure TACBrNFSeProviderABaseAPIPropria.PrepararConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  if EstaVazio(Response.protocolo) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod101;
    AErro.Descricao := ACBrStr(Desc101);
    Exit;
  end;

  Path := '/consultarlotedps/' + Response.protocolo;
  Response.ArquivoEnvio := Path;
  Method := 'GET';
end;

procedure TACBrNFSeProviderABaseAPIPropria.TratarRetornoConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
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

      ProcessarMensagemErros(Document.Root, Response);

      ANode := Document.Root;

      Response.Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataHoraRecebimento'), tcDatHor);
      Response.Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('Situacao'), tcStr);
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

procedure TACBrNFSeProviderABaseAPIPropria.PrepararConsultaNFSeporChave(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  if EstaVazio(Response.NumeroRps) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod126;
    AErro.Descricao := ACBrStr(Desc126);
    Exit;
  end;

  Path := '/consultarnfsedps/' + Response.NumeroRps;
  Response.ArquivoEnvio := Path;
  Method := 'GET';
end;

procedure TACBrNFSeProviderABaseAPIPropria.TratarRetornoConsultaNFSeporChave(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  aXML: string;
  DocumentXml: TACBrXmlDocument;
  NFSeXml, NumNFSe, NumDps, CodVerif: string;
  DataAut: TDateTime;
  ANota: TNotaFiscal;
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

      ProcessarMensagemErros(Document.Root, Response);

      ANode := Document.Root;

      Response.Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataHoraRecebimento'), tcDatHor);
      Response.Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('StatusProcessamento'), tcStr);
      Response.idNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('ChaveAcesso'), tcStr);
      aXML := SepararDados(ANode.OuterXml, '<NFSe ', True);

      if aXml <> '' then
      begin
        try
          try
            DocumentXml.LoadFromXml(aXml);

            ANode := DocumentXml.Root.Childrens.FindAnyNs('infNFSe');

            CodVerif := OnlyNumber(ObterConteudoTag(ANode.Attributes.Items['Id']));
            NumNFSe := ObterConteudoTag(ANode.Childrens.FindAnyNs('nNFSe'), tcStr);
            DataAut := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhProc'), tcDatHor);

            ANode := ANode.Childrens.FindAnyNs('DPS');
            ANode := ANode.Childrens.FindAnyNs('infDPS');
            NumDps := ObterConteudoTag(ANode.Childrens.FindAnyNs('nDPS'), tcStr);

            with Response do
            begin
              NumeroNota := NumNFSe;
              Data := DataAut;
              XmlRetorno := NFSeXml;
            end;

            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumDps);

            ANota := CarregarXmlNfse(ANota, DocumentXml.Root.OuterXml);
            SalvarXmlNfse(ANota);
          except
            on E:Exception do
            begin
              AErro := Response.Erros.New;
              AErro.Codigo := Cod999;
              AErro.Descricao := ACBrStr(Desc999 + E.Message);
            end;
          end;
        finally
          FreeAndNil(DocumentXml);
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

{ TACBrNFSeXWebserviceABaseAPIPropria }

function TACBrNFSeXWebserviceABaseAPIPropria.GerarNFSe(const ACabecalho,
  AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

function TACBrNFSeXWebserviceABaseAPIPropria.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

function TACBrNFSeXWebserviceABaseAPIPropria.ConsultarNFSePorChave(
  const ACabecalho, AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

procedure TACBrNFSeXWebserviceABaseAPIPropria.SetHeaders(
  aHeaderReq: THTTPHeader);
var
  Auth: string;
begin
  Auth := 'Bearer ' +
               TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente.WSChaveAcesso;

  aHeaderReq.AddHeader('Authorization', Auth);
end;

function TACBrNFSeXWebserviceABaseAPIPropria.TratarXmlRetornado(
  const aXML: string): string;
var
  aMsg: string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := RemoverCaracteresDesnecessarios(Result);
  Result := ParseText(Result);
  Result := RemoverIdentacao(Result);
  Result := RemoverDeclaracaoXML(Result);

  Result := RemoverPrefixosDesnecessarios(Result);

  if Pos('<Erro>', Result) = 1 then
  begin
    aMsg := LerTagXML(Result, 'Erro');
    Result := '<a>' +
                '<Erros>' +
                  '<Erro>' +
                    '<Codigo></Codigo>' +
                    '<Descricao>' + aMsg + '</Descricao>' +
                  '</Erro>' +
                '</Erros>' +
              '</a>';
  end;
end;

end.
