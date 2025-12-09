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

unit Citta.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeX,
  ACBrNFSeXClass,
  ACBrNFSeXConversao,
  ACBrNFSeXConfiguracoes,
  ACBrNFSeXGravarXml,
  ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase,
  ACBrNFSeXWebservicesResponse,
  PadraoNacional.Provider;

type
  TACBrNFSeXWebserviceCitta203 = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(const ACabecalho, AMSG: String): string; override;
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoPrestado(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoTomado(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(const ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderCitta203 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;

  public
    function StrToSituacaoTributaria(out ok: boolean; const s: string): TnfseSituacaoTributaria; override;
  end;

  TACBrNFSeXWebserviceCittaAPIPropria = class(TACBrNFSeXWebservicePadraoNacional)
  protected

  public

  end;

  TACBrNFSeProviderCittaAPIPropria = class(TACBrNFSeProviderPadraoNacional)
  private

  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  end;

implementation

uses
  synacode,
  ACBrJSON,
  ACBrCompress,
  ACBrDFeException,
  ACBrDFe.Conversao,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXConsts,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  Citta.GravarXml,
  Citta.LerXml;

{ TACBrNFSeProviderCitta203 }

procedure TACBrNFSeProviderCitta203.Configuracao;
begin
  inherited Configuracao;

  with ConfigWebServices do
  begin
    VersaoDados := '2.03';
    VersaoAtrib := '2.03';
    AtribVerLote := 'versao';
  end;
end;

function TACBrNFSeProviderCitta203.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Citta203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCitta203.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Citta203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCitta203.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceCitta203.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderCitta203.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
var
  Xml: string;
begin
  inherited ValidarSchema(Response, aMetodo);

  Xml := Response.ArquivoEnvio;

  Xml := StringReplace(Xml,
              ' xmlns="http://www.abrasf.org.br/nfse.xsd"', '', [rfReplaceAll]);

  case aMetodo of
    tmRecepcionar:
      begin
        Xml := StringReplace(Xml,
              'EnviarLoteRpsEnvio', 'nfse:RecepcionarLoteRpsEnvio', [rfReplaceAll]);
        Xml := StringReplace(Xml,
                            '<Rps><InfDecla', '<rps><InfDecla', [rfReplaceAll]);
        Xml := StringReplace(Xml,
                            'Servico></Rps>', 'Servico></rps>', [rfReplaceAll]);
      end;

    tmRecepcionarSincrono:
      begin
        Xml := StringReplace(Xml,
              'EnviarLoteRpsSincronoEnvio', 'nfse:RecepcionarLoteRpsSincronoEnvio', [rfReplaceAll]);
        Xml := StringReplace(Xml,
                            '<Rps><InfDecla', '<rps><InfDecla', [rfReplaceAll]);
        Xml := StringReplace(Xml,
                            'Servico></Rps>', 'Servico></rps>', [rfReplaceAll]);
      end;

    tmGerar:
      begin
        Xml := StringReplace(Xml,
              'GerarNfseEnvio', 'nfse:GerarNfseEnvio', [rfReplaceAll]);
      end;

    tmConsultarLote:
      begin
        Xml := StringReplace(Xml,
              'ConsultarLoteRpsEnvio', 'nfse:ConsultarLoteRpsEnvio', [rfReplaceAll]);
      end;

    tmConsultarNFSePorRps:
      begin
        Xml := StringReplace(Xml,
              'ConsultarNfseRpsEnvio', 'nfse:ConsultarNfseRpsEnvio', [rfReplaceAll]);
      end;

    tmConsultarNFSePorFaixa:
      begin
        Xml := StringReplace(Xml,
              'ConsultarNfseFaixaEnvio', 'nfse:ConsultarNfsePorFaixaEnvio', [rfReplaceAll]);
      end;

    tmConsultarNFSeServicoPrestado:
      begin
        Xml := StringReplace(Xml,
              'ConsultarNfseServicoPrestadoEnvio', 'nfse:ConsultarNfseServicoPrestadoEnvio', [rfReplaceAll]);
      end;

    tmConsultarNFSeServicoTomado:
      begin
        Xml := StringReplace(Xml,
              'ConsultarNfseServicoTomadoEnvio', 'nfse:ConsultarNfseServicoTomadoEnvio', [rfReplaceAll]);
      end;

    tmCancelarNFSe:
      begin
        Xml := StringReplace(Xml,
              'CancelarNfseEnvio', 'nfse:CancelarNfseEnvio', [rfReplaceAll]);
      end;

    tmSubstituirNFSe:
      begin
        Xml := StringReplace(Xml,
              'SubstituirNfseEnvio', 'nfse:SubstituirNfseEnvio', [rfReplaceAll]);
      end;
  else
    Response.ArquivoEnvio := Xml;
  end;

  Response.ArquivoEnvio := Xml;
end;

function TACBrNFSeProviderCitta203.StrToSituacaoTributaria(out ok: boolean;
  const s: string): TnfseSituacaoTributaria;
begin
  Result := StrToEnumerado(ok, s,
                             ['1', '0', '2', ''],
                             [stRetencao, stNormal, stSubstituicao, stNenhum]);
end;

{ TACBrNFSeXWebserviceCitta203 }

function TACBrNFSeXWebserviceCitta203.Recepcionar(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/RecepcionarLoteRps', AMSG,
                     [], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/RecepcionarLoteRpsSincrono', AMSG,
                     [], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.GerarNFSe(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/GerarNfse', AMSG,
                     [], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.ConsultarLote(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/ConsultarLoteRps', AMSG,
                     [], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfsePorFaixa', AMSG,
                     [], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfsePorRps', AMSG,
                     [], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfseServicoPrestado', AMSG,
                     [], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfseServicoTomado', AMSG,
                     [], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.Cancelar(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/CancelarNfse', AMSG,
                     [], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/SubstituirNfse', AMSG,
                     [], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

{ TACBrNFSeProviderCittaAPIPropria }

procedure TACBrNFSeProviderCittaAPIPropria.Configuracao;
var
  VersaoDFe: string;
begin
  inherited Configuracao;

  VersaoDFe := VersaoNFSeToStr(TACBrNFSeX(FAOwner).Configuracoes.Geral.Versao);

  with ConfigGeral do
  begin
    QuebradeLinha := '|';
    ModoEnvio := meUnitario;
    ConsultaLote := False;
    FormatoArqEnvio := tfaJson;
    FormatoArqRetorno := tfaJson;
    FormatoArqEnvioSoap := tfaJson;
    FormatoArqRetornoSoap := tfaJson;
    {
    ServicosDisponibilizados.EnviarUnitario := True;
    ServicosDisponibilizados.ConsultarNfseChave := True;
    ServicosDisponibilizados.ConsultarRps := True;
    ServicosDisponibilizados.EnviarEvento := True;
    ServicosDisponibilizados.ConsultarEvento := True;
    ServicosDisponibilizados.ConsultarDFe := True;
    ServicosDisponibilizados.ConsultarParam := True;
    ServicosDisponibilizados.ObterDANFSE := True;
    }
    Particularidades.AtendeReformaTributaria := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := VersaoDFe;
    VersaoAtrib := VersaoDFe;

    AtribVerLote := 'versao';
  end;

  SetXmlNameSpace('http://www.sped.fazenda.gov.br/nfse');

  with ConfigMsgDados do
  begin
    UsarNumLoteConsLote := False;

    DadosCabecalho := GetCabecalho('');

    XmlRps.InfElemento := 'infNFSe';
    XmlRps.DocElemento := 'NFSe';

    EnviarEvento.InfElemento := 'infPedReg';
    EnviarEvento.DocElemento := 'pedRegEvento';
  end;

  with ConfigAssinar do
  begin
    RpsGerarNFSe := True;
    EnviarEvento := True;
  end;

  SetNomeXSD('***');

  with ConfigSchemas do
  begin
    GerarNFSe := 'DPS_v' + VersaoDFe + '.xsd';
    ConsultarNFSe := 'DPS_v' + VersaoDFe + '.xsd';
    ConsultarNFSeRps := 'DPS_v' + VersaoDFe + '.xsd';
    EnviarEvento := 'pedRegEvento_v' + VersaoDFe + '.xsd';
    ConsultarEvento := 'DPS_v' + VersaoDFe + '.xsd';

    Validar := False;
  end;
end;

function TACBrNFSeProviderCittaAPIPropria.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_CittaAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCittaAPIPropria.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_CittaAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCittaAPIPropria.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceCittaAPIPropria.Create(FAOwner, AMetodo, URL, Method)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderCittaAPIPropria.PrepararEmitir(
  Response: TNFSeEmiteResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Nota: TNotaFiscal;
  IdAttr, ListaDps: string;
  I: Integer;
begin
  if TACBrNFSeX(FAOwner).NotasFiscais.Count <= 0 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod002;
    AErro.Descricao := ACBrStr(Desc002);
  end;

  Response.MaxRps := 50;

  if TACBrNFSeX(FAOwner).NotasFiscais.Count > Response.MaxRps then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod003;
    AErro.Descricao := ACBrStr('Conjunto de DPS transmitidos (máximo de ' +
                       IntToStr(Response.MaxRps) + ' DPS)' +
                       ' excedido. Quantidade atual: ' +
                       IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count));
  end;

  if Response.Erros.Count > 0 then Exit;

  ListaDps := '';

  if ConfigAssinar.IncluirURI then
    IdAttr := ConfigGeral.Identificador
  else
    IdAttr := 'ID';

  for I := 0 to TACBrNFSeX(FAOwner).NotasFiscais.Count -1 do
  begin
    Nota := TACBrNFSeX(FAOwner).NotasFiscais.Items[I];

    Nota.GerarXML;

    Nota.XmlRps := ConverteXMLtoUTF8(Nota.XmlRps);
    Nota.XmlRps := ChangeLineBreak(Nota.XmlRps, '');

    if (ConfigAssinar.Rps and (Response.ModoEnvio in [meLoteAssincrono, meLoteSincrono])) or
       (ConfigAssinar.RpsGerarNFSe and (Response.ModoEnvio = meUnitario)) then
    begin
      Nota.XmlRps := FAOwner.SSL.Assinar(Nota.XmlRps,
                                         ConfigMsgDados.XmlRps.DocElemento,
                                         ConfigMsgDados.XmlRps.InfElemento, '', '', '', IdAttr);

      Response.ArquivoEnvio := Nota.XmlRps;
    end;

    SalvarXmlRps(Nota);

    Nota.XmlRps := EncodeBase64(GZipCompress(Nota.XmlRps));
    ListaDps := ListaDps + Nota.XmlRps;
  end;

  Response.ArquivoEnvio := ListaDps;
end;

procedure TACBrNFSeProviderCittaAPIPropria.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
var
  Document, JSon: TACBrJSONObject;
  JSonLote: TACBrJSONArray;
  AErro: TNFSeEventoCollectionItem;
  NFSeXml: string;
  DocumentXml: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  NumNFSe, NumDps, CodVerif: string;
  DataAut: TDateTime;
  ANota: TNotaFiscal;
  i: Integer;
  AResumo: TNFSeResumoCollectionItem;

  procedure LerNFSe(NFSeXml: string);
  begin
    if NFSeXml = '' then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod203;
      AErro.Descricao := ACBrStr(Desc203);
      Exit
    end;

    DocumentXml := TACBrXmlDocument.Create;

    try
      try
        DocumentXml.LoadFromXml(NFSeXml);

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
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := ACBrStr(Desc201);
    Exit
  end;

  Document := TACBrJsonObject.Parse(Response.ArquivoRetorno);

  Response.Data := Document.AsISODateTime['dataHoraProcessamento'];

  JSonLote := Document.AsJSONArray['lote'];

  if JSonLote.Count > 0 then
  begin
    for i := 0 to JSonLote.Count-1 do
    begin
      JSon := JSonLote.ItemAsJSONObject[i];

      ProcessarMensagemDeErros(JSon, Response);
      Response.Sucesso := (Response.Erros.Count = 0);

      AResumo := Response.Resumos.New;
      AResumo.idNota := JSon.AsString['id'];
      AResumo.Link := JSon.AsString['chaveAcesso'];

      NFSeXml := JSon.AsString['xmlGZipB64'];

      if NFSeXml <> '' then
      begin
        NFSeXml := DeCompress(DecodeBase64(NFSeXml));

        AResumo.XmlRetorno := NFSeXml;

        LerNFSe(NFSeXml);
      end;
    end;
  end;
end;

procedure TACBrNFSeProviderCittaAPIPropria.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
begin
  if aMetodo in [tmGerar, tmEnviarEvento] then
  begin
//    inherited ValidarSchema(Response, aMetodo);

    Response.ArquivoEnvio := ChangeLineBreak(Response.ArquivoEnvio, '');

    case aMetodo of
      tmGerar:
        begin
          Response.ArquivoEnvio := '{"LoteXmlGZipB64":["' + Response.ArquivoEnvio + '"]}'
        end;

      tmEnviarEvento:
        begin
          Response.ArquivoEnvio := '{"pedidoRegistroEventoXmlGZipB64":"' + Response.ArquivoEnvio + '"}';
          Path := '/nfse/' + Chave + '/eventos';
        end;
    else
      begin
        Response.ArquivoEnvio := '';
        Path := '';
      end;
    end;

    Method := 'POST';
  end;
end;

end.
