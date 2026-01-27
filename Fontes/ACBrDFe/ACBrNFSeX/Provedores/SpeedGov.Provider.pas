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

unit SpeedGov.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml, ACBrNFSeXWebservicesResponse,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceSpeedGov = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderSpeedGov = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;

    procedure GerarMsgDadosConsultaSituacao(Response: TNFSeConsultaSituacaoResponse;
      Params: TNFSeParamsResponse); override;

    procedure GerarMsgDadosConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse;
      Params: TNFSeParamsResponse); override;

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure GerarMsgDadosConsultaNFSe(Response: TNFSeConsultaNFSeResponse;
      Params: TNFSeParamsResponse); override;

    procedure GerarMsgDadosConsultaporRps(Response: TNFSeConsultaNFSeporRpsResponse;
      Params: TNFSeParamsResponse); override;

    procedure GerarMsgDadosCancelaNFSe(Response: TNFSeCancelaNFSeResponse;
      Params: TNFSeParamsResponse); override;

  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrUtil.Strings,
  ACBrUtil.Base,
  ACBrDFe.Conversao,
  ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  ACBrNFSeXNotasFiscais, SpeedGov.GravarXml, SpeedGov.LerXml;

{ TACBrNFSeXWebserviceSpeedGov }

function TACBrNFSeXWebserviceSpeedGov.Recepcionar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:RecepcionarLoteRps>';
  Request := Request + '<header>' + IncluirCDATA(ACabecalho) + '</header>';
  Request := Request + '<parameters>' + IncluirCDATA(AMSG) + '</parameters>';
  Request := Request + '</nfse:RecepcionarLoteRps>';

  Result := Executar('', Request,
                     ['return', 'RecepcionarLoteRpsResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"']);
end;

function TACBrNFSeXWebserviceSpeedGov.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarLoteRps>';
  Request := Request + '<header>' + IncluirCDATA(ACabecalho) + '</header>';
  Request := Request + '<parameters>' + IncluirCDATA(AMSG) + '</parameters>';
  Request := Request + '</nfse:ConsultarLoteRps>';

  Result := Executar('', Request,
                     ['return', 'ConsultarLoteRpsResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"']);
end;

function TACBrNFSeXWebserviceSpeedGov.ConsultarSituacao(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarSituacaoLoteRps>';
  Request := Request + '<header>' + IncluirCDATA(ACabecalho) + '</header>';
  Request := Request + '<parameters>' + IncluirCDATA(AMSG) + '</parameters>';
  Request := Request + '</nfse:ConsultarSituacaoLoteRps>';

  Result := Executar('', Request,
                     ['return', 'ConsultarSituacaoLoteRpsResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"']);
end;

function TACBrNFSeXWebserviceSpeedGov.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfsePorRps>';
  Request := Request + '<header>' + IncluirCDATA(ACabecalho) + '</header>';
  Request := Request + '<parameters>' + IncluirCDATA(AMSG) + '</parameters>';
  Request := Request + '</nfse:ConsultarNfsePorRps>';

  Result := Executar('', Request,
                     ['return', 'ConsultarNfseRpsResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"']);
end;

function TACBrNFSeXWebserviceSpeedGov.ConsultarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfse>';
  Request := Request + '<header>' + IncluirCDATA(ACabecalho) + '</header>';
  Request := Request + '<parameters>' + IncluirCDATA(AMSG) + '</parameters>';
  Request := Request + '</nfse:ConsultarNfse>';

  Result := Executar('', Request,
                     ['return', 'ConsultarNfseResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"']);
end;

function TACBrNFSeXWebserviceSpeedGov.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:CancelarNfse>';
  Request := Request + '<header>' + IncluirCDATA(ACabecalho) + '</header>';
  Request := Request + '<parameters>' + IncluirCDATA(AMSG) + '</parameters>';
  Request := Request + '</nfse:CancelarNfse>';

  Result := Executar('', Request,
                     ['return', 'CancelarNfseResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"']);
end;

function TACBrNFSeXWebserviceSpeedGov.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverPrefixosDesnecessarios(Result);
end;

{ TACBrNFSeProviderSpeedGov }

procedure TACBrNFSeProviderSpeedGov.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.UseCertificateHTTP := False;

  with ConfigMsgDados do
  begin
    GerarNSLoteRps := True;
    //Prefixo := 'p';
    //PrefixoTS := 'p1';

    //XmlRps.xmlns := 'http://ws.speedgov.com.br/tipos_v1.xsd';

    LoteRps.xmlns := 'http://ws.speedgov.com.br/enviar_lote_rps_envio_v1.xsd';

    ConsultarSituacao.xmlns := 'http://ws.speedgov.com.br/consultar_situacao_lote_rps_envio_v1.xsd';

    ConsultarLote.xmlns := 'http://ws.speedgov.com.br/consultar_lote_rps_envio_v1.xsd';

    ConsultarNfseRps.xmlns := 'http://ws.speedgov.com.br/consultar_nfse_rps_envio_v1.xsd';

    ConsultarNfse.xmlns := 'http://ws.speedgov.com.br/consultar_nfse_envio_v1.xsd';

    CancelarNfse.xmlns := 'http://ws.speedgov.com.br/cancelar_nfse_envio_v1.xsd';

    DadosCabecalho := '<cabecalho xmlns="http://ws.speedgov.com.br/cabecalho_v1.xsd" versao="1">' +
                      '<versaoDados xmlns="">1</versaoDados>' +
                      '</cabecalho>';
  end;

  with ConfigGeral do
  begin
    Particularidades.AtendeReformaTributaria := True;
  end;

  SetNomeXSD('***');

  with ConfigSchemas do
  begin
    Validar := True;
    Recepcionar := 'enviar_lote_rps_envio_v1.xsd';
    ConsultarSituacao := 'consultar_situacao_lote_rps_envio_v1.xsd';
    ConsultarLote := 'consultar_lote_rps_envio_v1.xsd';
    ConsultarNFSeRps := 'consultar_nfse_rps_envio_v1.xsd';
    ConsultarNFSe := 'consultar_nfse_envio_v1.xsd';
    CancelarNFSe := 'cancelar_nfse_envio_v1.xsd';
  end;

  with ConfigAssinar do
  begin
    Rps := False;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
    RpsSubstituirNFSe := True;
    SubstituirNFSe := True;
  end;
end;

function TACBrNFSeProviderSpeedGov.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SpeedGov.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSpeedGov.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SpeedGov.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSpeedGov.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceSpeedGov.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderSpeedGov.GerarMsgDadosCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
  InfoCanc: TInfCancelamento;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  InfoCanc := Response.InfCancelamento;

  with Params do
  begin
    NameSpace2 := ' xmlns=""';
    Response.ArquivoEnvio := '<' + Prefixo + 'CancelarNfseEnvio' + NameSpace + '>' +
                           '<' + Prefixo + 'Pedido' + Params.NameSpace2 + '>' +
                             '<' + Prefixo2 + 'InfPedidoCancelamento' + IdAttr + '>' +
                               '<' + Prefixo2 + 'IdentificacaoNfse>' +
                                 '<' + Prefixo2 + 'Numero>' +
                                   InfoCanc.NumeroNFSe +
                                 '</' + Prefixo2 + 'Numero>' +
                                 '<' + Prefixo2 + 'Cnpj>' +
                                   OnlyNumber(Emitente.CNPJ) +
                                 '</' + Prefixo2 + 'Cnpj>' +
                                 GetInscMunic(Emitente.InscMun, Prefixo2) +
                                 '<' + Prefixo2 + 'CodigoMunicipio>' +
                                    ConfigGeral.CodIBGE +
                                 '</' + Prefixo2 + 'CodigoMunicipio>' +
                               '</' + Prefixo2 + 'IdentificacaoNfse>' +
                               '<' + Prefixo2 + 'CodigoCancelamento>' +
                                  InfoCanc.CodCancelamento +
                               '</' + Prefixo2 + 'CodigoCancelamento>' +
                               Motivo +
                             '</' + Prefixo2 + 'InfPedidoCancelamento>' +
                           '</' + Prefixo + 'Pedido>' +
                         '</' + Prefixo + 'CancelarNfseEnvio>';
  end;
end;

procedure TACBrNFSeProviderSpeedGov.GerarMsgDadosConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  with Params do
  begin
    NameSpace := Params.NameSpace + ' xmlns:tipos="http://ws.speedgov.com.br/tipos_v1.xsd"';
    NameSpace2 := ' xmlns=""';
    Response.ArquivoEnvio := '<' + Prefixo + 'ConsultarLoteRpsEnvio' + NameSpace + '>' +
                           '<' + Prefixo + 'Prestador' + NameSpace2 + '>' +
                             '<' + Prefixo2 + 'Cnpj>' +
                               OnlyNumber(Emitente.CNPJ) +
                             '</' + Prefixo2 + 'Cnpj>' +
                             GetInscMunic(Emitente.InscMun, Prefixo2) +
                           '</' + Prefixo + 'Prestador>' +
                           '<' + Prefixo + 'Protocolo'+ NameSpace2 +'>' +
                             Response.Protocolo +
                           '</' + Prefixo + 'Protocolo>' +
                         '</' + Prefixo + 'ConsultarLoteRpsEnvio>';
  end;
end;

procedure TACBrNFSeProviderSpeedGov.GerarMsgDadosConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  with Params do
  begin
    Response.ArquivoEnvio := '<'+ TagEnvio + NameSpace + '>' +
                           '<Prestador'+ NameSpace2 + '>' +
                             '<Cnpj>' +
                               OnlyNumber(Emitente.CNPJ) +
                             '</Cnpj>' +
                             GetInscMunic(Emitente.InscMun, '') +
                           '</Prestador>' +
                           Xml +
                         '</'+ TagEnvio + '>';
  end;
end;

procedure TACBrNFSeProviderSpeedGov.GerarMsgDadosConsultaporRps(
  Response: TNFSeConsultaNFSeporRpsResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  with Params do
  begin
    NameSpace2 := ' xmlns=""';
    Response.ArquivoEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                           '<' + Prefixo + 'IdentificacaoRps' + Params.NameSpace2 + '>' +
                             '<' + Prefixo2 + 'Numero>' +
                               Response.NumeroRps +
                             '</' + Prefixo2 + 'Numero>' +
                             '<' + Prefixo2 + 'Serie>' +
                               Response.SerieRps +
                             '</' + Prefixo2 + 'Serie>' +
                             '<' + Prefixo2 + 'Tipo>' +
                               Response.TipoRps +
                             '</' + Prefixo2 + 'Tipo>' +
                           '</' + Prefixo + 'IdentificacaoRps>' +
                           '<' + Prefixo + 'Prestador' + Params.NameSpace2  + '>' +
                             '<' + Prefixo2 + 'Cnpj>' +
                               OnlyNumber(Emitente.CNPJ) +
                             '</' + Prefixo2 + 'Cnpj>' +
                             GetInscMunic(Emitente.InscMun, Prefixo2) +
                           '</' + Prefixo + 'Prestador>' +
                         '</' + Prefixo + TagEnvio + '>';
  end;
end;

procedure TACBrNFSeProviderSpeedGov.GerarMsgDadosConsultaSituacao(
  Response: TNFSeConsultaSituacaoResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  with Params do
  begin
    NameSpace := Params.NameSpace + ' xmlns:tipos="http://ws.speedgov.com.br/tipos_v1.xsd"';
    NameSpace2 := ' xmlns=""';
    Response.ArquivoEnvio := '<' + Prefixo + 'ConsultarSituacaoLoteRpsEnvio' + NameSpace + '>' +
                           '<' + Prefixo + 'Prestador' + NameSpace2 + '>' +
                             '<' + Prefixo2 + 'Cnpj>' +
                               OnlyNumber(Emitente.CNPJ) +
                             '</' + Prefixo2 + 'Cnpj>' +
                             GetInscMunic(Emitente.InscMun, Prefixo2) +
                           '</' + Prefixo + 'Prestador>' +
                           '<' + Prefixo + 'Protocolo'+ NameSpace2 +'>' +
                             Response.Protocolo +
                           '</' + Prefixo + 'Protocolo>' +
                         '</' + Prefixo + 'ConsultarSituacaoLoteRpsEnvio>';
  end;
end;

procedure TACBrNFSeProviderSpeedGov.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
begin
  Params.NameSpace2 := ' xmlns=""';
  inherited GerarMsgDadosEmitir(Response, Params);
end;

procedure TACBrNFSeProviderSpeedGov.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  aParams: TNFSeParamsResponse;
  XmlConsulta, RazaoInter: string;
begin
  aParams := TNFSeParamsResponse.Create;
  try
    aParams.Clear;

    case Response.InfConsultaNFSe.tpConsulta of
      tcPorFaixa: Response.Metodo := tmConsultarNFSePorFaixa;
      tcServicoTomado: Response.Metodo := tmConsultarNFSeServicoTomado;
      tcServicoPrestado: Response.Metodo := tmConsultarNFSeServicoPrestado;
      tcPorChave: Response.Metodo := tmConsultarNFSePorChave;
    else
      Response.Metodo := tmConsultarNFSe;
    end;

    if Response.InfConsultaNFSe.tpConsulta in [tcPorFaixa, tcServicoTomado,
       tcServicoPrestado, tcPorChave, tcPorCodigoVerificacao] then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod001;
      AErro.Descricao := ACBrStr(Desc001);
      Exit;
    end;

    aParams.Prefixo := '';
    aParams.Prefixo2 := '';
    aParams.NameSpace2 := ' xmlns=""';

    if EstaVazio(ConfigMsgDados.ConsultarNFSe.xmlns) then
      aParams.NameSpace := ''
    else
    begin
      if ConfigMsgDados.Prefixo = '' then
        aParams.NameSpace := ' xmlns="' + ConfigMsgDados.ConsultarNFSe.xmlns + '"'
      else
      begin
        aParams.NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.ConsultarNFSe.xmlns + '"';
        aParams.Prefixo := ConfigMsgDados.Prefixo + ':';
      end;
    end;

    if ConfigMsgDados.XmlRps.xmlns <> '' then
    begin
      if (ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.ConsultarNFSe.xmlns) and
         ((ConfigMsgDados.Prefixo <> '') or (ConfigMsgDados.PrefixoTS <> '')) then
      begin
        if ConfigMsgDados.PrefixoTS = '' then
          aParams.NameSpace := aParams.NameSpace + ' xmlns="' + ConfigMsgDados.XmlRps.xmlns + '"'
        else
        begin
          aParams.NameSpace := aParams.NameSpace+ ' xmlns:' + ConfigMsgDados.PrefixoTS + '="' +
                                              ConfigMsgDados.XmlRps.xmlns + '"';
        end;
      end
      else
      begin
        if ConfigMsgDados.PrefixoTS <> '' then
          aParams.Prefixo2 := ConfigMsgDados.PrefixoTS + ':';
      end;
    end;
    aParams.NameSpace := aParams.NameSpace + ' xmlns:tipos="http://ws.speedgov.com.br/tipos_v1.xsd"';

    if OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) <> '' then
      XmlConsulta := '<NumeroNfse'+ aParams.NameSpace2 + '>' +
                        OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) +
                     '</NumeroNfse>'
    else
      XmlConsulta := '';

    if (Response.InfConsultaNFSe.DataInicial > 0) and (Response.InfConsultaNFSe.DataFinal > 0) then
      XmlConsulta := XmlConsulta +
                       '<PeriodoEmissao' + aParams.NameSpace2 + '>' +
                         '<DataInicial>' +
                            FormatDateTime('yyyy-mm-dd', Response.InfConsultaNFSe.DataInicial) +
                         '</DataInicial>' +
                         '<DataFinal>' +
                            FormatDateTime('yyyy-mm-dd', Response.InfConsultaNFSe.DataFinal) +
                         '</DataFinal>' +
                       '</PeriodoEmissao>';

    if NaoEstaVazio(Response.InfConsultaNFSe.CNPJTomador) then
    begin
      XmlConsulta := XmlConsulta +
                       '<Tomador' + aParams.NameSpace2 + '>' +
                         '<CpfCnpj>' +
                            GetCpfCnpj(Response.InfConsultaNFSe.CNPJTomador, '') +
                         '</CpfCnpj>' +
                         GetInscMunic(Response.InfConsultaNFSe.IMTomador, '') +
                       '</Tomador>';
    end;

    if NaoEstaVAzio(Response.InfConsultaNFSe.CNPJInter) then
    begin
      if NaoEstaVazio(Response.InfConsultaNFSe.RazaoInter) then
        RazaoInter := '<RazaoSocial>' +
                         OnlyNumber(Response.InfConsultaNFSe.RazaoInter) +
                      '</RazaoSocial>'
      else
        RazaoInter := '';

      XmlConsulta := XmlConsulta +
                       '<IntermediarioServico' +  aParams.NameSpace2 + '>' +
                         RazaoInter +
                         '<CpfCnpj>' +
                            GetCpfCnpj(Response.InfConsultaNFSe.CNPJInter, '') +
                         '</CpfCnpj>' +
                         GetInscMunic(Response.InfConsultaNFSe.IMInter, '') +
                       '</IntermediarioServico>';
    end;

    aParams.TagEnvio := ConfigMsgDados.ConsultarNFSe.DocElemento;

    GerarMsgDadosConsultaNFSe(Response, aParams);
  finally
    aParams.Free;
  end;
end;

end.
