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

unit Thema.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceThema = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderThema = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure LerCancelamento(ANode: TACBrXmlNode;
      Response: TNFSeWebserviceResponse); override;
  public
    function NaturezaOperacaoDescricao(const t: TnfseNaturezaOperacao): string; override;
  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts, ACBrNFSeXNotasFiscais,
  Thema.GravarXml, Thema.LerXml;

{ TACBrNFSeXWebserviceThema }

function TACBrNFSeXWebserviceThema.Recepcionar(const ACabecalho, AMSG: String): string;
var
  Request, Servico: string;
begin
  // Para o provedor Thema devemos utilizar esse servi�o caso a quantidade
  // de RPS no lote seja superior a 3, ou seja, 4 ou mais

  Servico := 'recepcionarLoteRps';

  if TACBrNFSeX(FPDFeOwner).NotasFiscais.Count <= 3 then
    Servico := 'recepcionarLoteRpsLimitado';

  FPMsgOrig := AMSG;

  Request := '<' + Servico + ' xmlns="http://server.nfse.thema.inf.br">';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</' + Servico + '>';

  Result := Executar('urn:' + Servico, Request,
                     ['return', 'EnviarLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceThema.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request, Servico: string;
begin
  // Para o provedor Thema devemos utilizar esse servi�o caso a quantidade
  // de RPS no lote seja inferior a 4.

  Servico := 'recepcionarLoteRpsLimitado';

  if TACBrNFSeX(FPDFeOwner).NotasFiscais.Count >= 4 then
    Servico := 'recepcionarLoteRps';

  FPMsgOrig := AMSG;

  Request := '<' + Servico + ' xmlns="http://server.nfse.thema.inf.br">';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</' + Servico + '>';

  Result := Executar('urn:' + Servico, Request,
                     ['return', 'EnviarLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceThema.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<consultarLoteRps xmlns="http://server.nfse.thema.inf.br">';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</consultarLoteRps>';

  Result := Executar('urn:consultarLoteRps', Request,
                     ['return', 'ConsultarLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceThema.ConsultarSituacao(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<consultarSituacaoLoteRps xmlns="http://server.nfse.thema.inf.br">';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</consultarSituacaoLoteRps>';

  Result := Executar('urn:consultarSituacaoLoteRps', Request,
                     ['return', 'ConsultarSituacaoLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceThema.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<consultarNfsePorRps xmlns="http://server.nfse.thema.inf.br">';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</consultarNfsePorRps>';

  Result := Executar('urn:consultarNfsePorRps', Request,
                     ['return', 'ConsultarNfseRpsResposta'], []);
end;

function TACBrNFSeXWebserviceThema.ConsultarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<consultarNfse xmlns="http://server.nfse.thema.inf.br">';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</consultarNfse>';

  Result := Executar('urn:consultarNfse', Request,
                     ['return', 'ConsultarNfseResposta'], []);
end;

function TACBrNFSeXWebserviceThema.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<cancelarNfse xmlns="http://server.nfse.thema.inf.br">';
  Request := Request + '<xml>' + XmlToStr(AMSG) + '</xml>';
  Request := Request + '</cancelarNfse>';

  Result := Executar('urn:cancelarNfse', Request,
                     ['return', 'CancelarNfseResposta'], []);
end;

function TACBrNFSeXWebserviceThema.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverIdentacao(Result);
  Result := RemoverPrefixosDesnecessarios(Result);
end;

{ TACBrNFSeProviderThema }

procedure TACBrNFSeProviderThema.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.Identificador := 'id';

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
  end;

  ConfigMsgDados.LoteRpsSincrono.DocElemento := 'EnviarLoteRpsEnvio';
end;

function TACBrNFSeProviderThema.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Thema.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderThema.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Thema.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderThema.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceThema.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderThema.LerCancelamento(ANode: TACBrXmlNode;
  Response: TNFSeWebserviceResponse);
var
  AuxNodeCanc, ANodeNfseCancelamento: TACBrXmlNode;
begin
  ANodeNfseCancelamento := ANode.Childrens.FindAnyNs('NfseCancelamento');

  if ANodeNfseCancelamento <> nil then
  begin
    AuxNodeCanc := ANodeNfseCancelamento.Childrens.FindAnyNs('Confirmacao');

    if AuxNodeCanc <> nil then
    begin
      Response.DataCanc := ObterConteudoTag(AuxNodeCanc.Childrens.FindAnyNs('DataHoraCancelamento'), FpFormatoDataHora);

      Response.SucessoCanc := Response.DataCanc > 0;
    end;

    Response.DescSituacao := '';

    if (Response.DataCanc > 0) and (Response.SucessoCanc) then
      Response.DescSituacao := 'Nota Cancelada';
  end;
end;

function TACBrNFSeProviderThema.NaturezaOperacaoDescricao(
  const t: TnfseNaturezaOperacao): string;
begin
  case t of
    no63 : Result := '6.3 - Tributa��o fora do municipio com reten��o de ISS';
    no64 : Result := '6.4 - Tributacao fora do municipio sem reten��o de ISS';
  else
    Result := inherited NaturezaOperacaoDescricao(t);
  end;
end;

procedure TACBrNFSeProviderThema.PrepararEmitir(Response: TNFSeEmiteResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  Nota: TNotaFiscal;
  Versao, IdAttr, NameSpace, NameSpaceLote, ListaRps, xRps,
  TagEnvio, Prefixo, PrefixoTS: string;
  I: Integer;
begin
  if not (Response.ModoEnvio in [meLoteSincrono, meUnitario, meTeste]) then
  begin
    inherited PrepararEmitir(Response);
    Exit;
  end;

  if TACBrNFSeX(FAOwner).NotasFiscais.Count <= 0 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod002;
    AErro.Descricao := ACBrStr(Desc002);
    Exit;
  end;

  if TACBrNFSeX(FAOwner).NotasFiscais.Count > Response.MaxRps then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod003;
    AErro.Descricao := ACBrStr('Conjunto de RPS transmitidos (m�ximo de ' +
                       IntToStr(Response.MaxRps) + ' RPS)' +
                       ' excedido. Quantidade atual: ' +
                       IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count));
    Exit;
  end;

  if ConfigAssinar.IncluirURI then
    IdAttr := ConfigGeral.Identificador
  else
    IdAttr := 'ID';

  ListaRps := '';
  Prefixo := '';
  PrefixoTS := '';

  TagEnvio := ConfigMsgDados.LoteRpsSincrono.DocElemento;

  if EstaVazio(ConfigMsgDados.LoteRpsSincrono.xmlns) then
    NameSpace := ''
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.LoteRpsSincrono.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' +
                               ConfigMsgDados.LoteRpsSincrono.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.LoteRpsSincrono.xmlns then
    begin
      if ConfigMsgDados.PrefixoTS = '' then
        NameSpace := NameSpace + ' xmlns="' + ConfigMsgDados.XmlRps.xmlns + '"'
      else
      begin
        NameSpace := NameSpace+ ' xmlns:' + ConfigMsgDados.PrefixoTS + '="' +
                                            ConfigMsgDados.XmlRps.xmlns + '"';
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
      end;
    end
    else
    begin
      if ConfigMsgDados.PrefixoTS <> '' then
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
    end;
  end;

  for I := 0 to TACBrNFSeX(FAOwner).NotasFiscais.Count -1 do
  begin
    Nota := TACBrNFSeX(FAOwner).NotasFiscais.Items[I];

    Nota.GerarXML;

    Nota.XmlRps := ConverteXMLtoUTF8(Nota.XmlRps);
    Nota.XmlRps := ChangeLineBreak(Nota.XmlRps, '');

    if ConfigAssinar.Rps then
    begin
      Nota.XmlRps := FAOwner.SSL.Assinar(Nota.XmlRps,
                                         PrefixoTS + ConfigMsgDados.XmlRps.DocElemento,
                                         ConfigMsgDados.XmlRps.InfElemento, '', '', '', IdAttr);
    end;

    SalvarXmlRps(Nota);

    xRps := RemoverDeclaracaoXML(Nota.XmlRps);
    xRps := PrepararRpsParaLote(xRps);

    ListaRps := ListaRps + xRps;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  ListaRps := ChangeLineBreak(ListaRps, '');

  if ConfigMsgDados.GerarNSLoteRps then
    NameSpaceLote := NameSpace
  else
    NameSpaceLote := '';

  if ConfigWebServices.AtribVerLote <> '' then
    Versao := ' ' + ConfigWebServices.AtribVerLote + '="' +
              ConfigWebServices.VersaoDados + '"'
  else
    Versao := '';

  if ConfigGeral.Identificador <> '' then
    IdAttr := ' ' + ConfigGeral.Identificador + '="Lote_' + Response.NumeroLote + '"'
  else
    IdAttr := '';

  Response.ArquivoEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                         '<' + Prefixo + 'LoteRps' + NameSpaceLote + IdAttr  + Versao + '>' +
                           '<' + PrefixoTS + 'NumeroLote>' + Response.NumeroLote + '</' + PrefixoTS + 'NumeroLote>' +
                           '<' + PrefixoTS + 'Cnpj>' + OnlyNumber(Emitente.CNPJ) + '</' + PrefixoTS + 'Cnpj>' +
                           GetInscMunic(Emitente.InscMun, PrefixoTS) +
                           '<' + PrefixoTS + 'QuantidadeRps>' +
                              IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count) +
                           '</' + PrefixoTS + 'QuantidadeRps>' +
                           '<' + PrefixoTS + 'ListaRps>' + ListaRps + '</' + PrefixoTS + 'ListaRps>' +
                         '</' + Prefixo + 'LoteRps>' +
                       '</' + Prefixo + TagEnvio + '>';
end;

procedure TACBrNFSeProviderThema.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  ANota: TNotaFiscal;
  NumRps: String;
  I: Integer;
begin
  if not (Response.ModoEnvio in [meLoteSincrono, meUnitario, meTeste]) then
  begin
    inherited TratarRetornoEmitir(Response);
    Exit;
  end;

  Document := TACBrXmlDocument.Create;
  try
    try
      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response);
      ProcessarMensagemErros(Document.Root, Response, 'ListaMensagemRetornoLote');

      ANode := Document.Root;

      Response.Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataRecebimento'), tcDatHor);
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Protocolo'), tcStr);

      ANode := Document.Root.Childrens.FindAnyNs('ListaNfse');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod202;
        AErro.Descricao := ACBrStr(Desc202);
        Exit;
      end;

      ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := ACBrStr(Desc203);
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('Nfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('IdentificacaoRps');
        AuxNode := AuxNode.Childrens.FindAnyNs('Numero');
        NumRps := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
        SalvarXmlNfse(ANota);
      end;

      Response.Sucesso := (Response.Erros.Count = 0);
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

end.
