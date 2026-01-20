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

unit Betha.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXClass,
  ACBrDFe.Conversao,
  ACBrNFSeXConversao,
  ACBrNFSeXGravarXml,
  ACBrNFSeXLerXml,
  ACBrNFSeXWebserviceBase,
  ACBrNFSeXWebservicesResponse,
  ACBrNFSeXProviderABRASFv1,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXProviderProprio,
  PadraoNacional.Provider;

type
  TACBrNFSeXWebserviceBetha = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetSubVersao: Integer;

  protected
    property SubVersao: Integer read GetSubVersao;
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderBetha = class (TACBrNFSeProviderABRASFv1)
  private
    function GetSubVersao: Integer;
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure PrepararConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;
    procedure PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure AssinarCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    property SubVersao: Integer read GetSubVersao;
  public
    function CondicaoPagToStr(const t: TnfseCondicaoPagamento): string; override;
    function StrToCondicaoPag(out ok: boolean; const s: string): TnfseCondicaoPagamento; override;
  end;

  TACBrNFSeXWebserviceBetha202 = class(TACBrNFSeXWebserviceSoap11)

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

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderBetha202 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function DefinirIDLote(const ID: string): string; override;
  end;

  TACBrNFSeXWebserviceBethaAPIPropria = class(TACBrNFSeXWebserviceSoap11)
  protected

  public
    function GerarNFSe(const ACabecalho, AMSG: string): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function EnviarEvento(const ACabecalho, AMSG: string): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: string): string; override;
    function ConsultarNFSePorChave(const ACabecalho, AMSG: string): string; override;
    function ConsultarEvento(const ACabecalho, AMSG: string): string; override;
    function ConsultarDFe(const ACabecalho, AMSG: string): string; override;
    function ConsultarParam(const ACabecalho, AMSG: string): string; override;
    function ObterDANFSE(const ACabecalho, AMSG: string): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderBethaAPIPropria = class(TACBrNFSeProviderPadraoNacional)
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
                                     const AListTag: string = 'listaMensagens';
                                     const AMessageTag: string = 'mensagem'); override;

    function PrepararArquivoEnvio(const aXml: string; aMetodo: TMetodo): string; override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;
    procedure TratarRetornoConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;

    procedure PrepararEnviarEvento(Response: TNFSeEnviarEventoResponse); override;
    procedure TratarRetornoEnviarEvento(Response: TNFSeEnviarEventoResponse); override;
  public
    function GetSchemaPath: string; override;
  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime,
  ACBrDFeException,
  ACBrNFSeX,
  ACBrNFSeXConfiguracoes,
  ACBrNFSeXConsts,
  ACBrNFSeXNotasFiscais,
  Betha.GravarXml,
  Betha.LerXml;

{ TACBrNFSeXWebserviceBetha }

function TACBrNFSeXWebserviceBetha.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := StringReplace(Result, '&amp;', '\s\n', [rfReplaceAll]);
  Result := ParseText(Result);
  Result := RemoverPrefixosDesnecessarios(Result);
  Result := RemoverCaracteresDesnecessarios(Result);

  if Pos('CancelarNfseReposta', Result) > 0 then
    Result := StringReplace(Result, 'CancelarNfseReposta', 'CancelarNfseResposta', [rfReplaceAll]);
end;

function TACBrNFSeXWebserviceBetha.GetSubVersao: Integer;
begin
  Result := StrToIntDef(TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.Params.ValorParametro('SubVersao'), 0);
end;

function TACBrNFSeXWebserviceBetha.Recepcionar(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, ['EnviarLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceBetha.ConsultarLote(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  if SubVersao = 1 then
    Result := Executar('', AMSG, ['return', 'ConsultarLoteRpsResposta'], [])
  else
    Result := Executar('', AMSG, ['ConsultarLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceBetha.ConsultarSituacao(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  if SubVersao = 1 then
    Result := Executar('', AMSG, ['return', 'ConsultarSituacaoLoteRpsResposta'], [])
  else
    Result := Executar('', AMSG, ['ConsultarSituacaoLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceBetha.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  if SubVersao = 1 then
    Result := Executar('', AMSG, ['return', 'ConsultarNfseRpsResposta'], [])
  else
    Result := Executar('', AMSG, ['ConsultarNfseRpsResposta'], []);
end;

function TACBrNFSeXWebserviceBetha.ConsultarNFSe(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, ['ConsultarNfseResposta'], []);
end;

function TACBrNFSeXWebserviceBetha.Cancelar(const ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, ['CancelarNfseResposta'], []);
end;

{ TACBrNFSeProviderBetha }

procedure TACBrNFSeProviderBetha.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.DetalharServico := True;

  ConfigGeral.Particularidades.PermiteTagOutrasInformacoes := True;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
  end;

  SetXmlNameSpace('http://www.betha.com.br/e-nota-contribuinte-ws');

  with ConfigMsgDados do
  begin
    ConsultarNFSeRps.DocElemento := 'ConsultarNfsePorRpsEnvio';
    XmlRps.xmlns := '';
  end;

  if SubVersao = 1 then
    SetNomeXSD('nfse_betha_v01.xsd')
  else
  begin
    SetNomeXSD('***');

    with ConfigSchemas do
    begin
      Recepcionar := 'servico_enviar_lote_rps_envio_v01.xsd';
      ConsultarSituacao := 'servico_consultar_situacao_lote_rps_envio_v01.xsd';
      ConsultarLote := 'servico_consultar_lote_rps_envio_v01.xsd';
      ConsultarNFSeRps := 'servico_consultar_nfse_rps_envio_v01.xsd';
      ConsultarNFSe := 'servico_consultar_nfse_envio_v01.xsd';
      CancelarNFSe := 'servico_cancelar_nfse_envio_v01.xsd';
    end;
  end;
end;

function TACBrNFSeProviderBetha.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Betha.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderBetha.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Betha.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderBetha.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceBetha.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderBetha.GetSubVersao: Integer;
begin
  Result := StrToIntDef(ConfigGeral.Params.ValorParametro('SubVersao'), 0);
end;

procedure TACBrNFSeProviderBetha.PrepararEmitir(Response: TNFSeEmiteResponse);
var
  aXml: string;
begin
  ConfigMsgDados.Prefixo := '';

  inherited PrepararEmitir(Response);

  aXml := RetornarConteudoEntre(Response.ArquivoEnvio,
   '<EnviarLoteRpsEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">',
   '</EnviarLoteRpsEnvio>', False);

  if SubVersao = 1 then
  begin
    Response.ArquivoEnvio := '<EnviarLoteRpsEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</EnviarLoteRpsEnvio>';
  end
  else
  begin
    Response.ArquivoEnvio := '<ns3:EnviarLoteRpsEnvio xmlns:ns3="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</ns3:EnviarLoteRpsEnvio>';

    ConfigMsgDados.Prefixo := 'ns3';
  end;
end;

procedure TACBrNFSeProviderBetha.PrepararConsultaSituacao(
  Response: TNFSeConsultaSituacaoResponse);
var
  aXml: string;
begin
  ConfigMsgDados.Prefixo := '';

  inherited PrepararConsultaSituacao(Response);

  aXml := RetornarConteudoEntre(Response.ArquivoEnvio,
   '<ConsultarSituacaoLoteRpsEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">',
   '</ConsultarSituacaoLoteRpsEnvio>', False);


  if SubVersao = 1 then
  begin
    Response.ArquivoEnvio := '<ConsultarSituacaoLoteRpsEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</ConsultarSituacaoLoteRpsEnvio>';
  end
  else
  begin
    Response.ArquivoEnvio := '<ns3:ConsultarSituacaoLoteRpsEnvio xmlns:ns3="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</ns3:ConsultarSituacaoLoteRpsEnvio>';

    ConfigMsgDados.Prefixo := 'ns3';
  end;
end;

procedure TACBrNFSeProviderBetha.PrepararConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  aXml: string;
begin
  ConfigMsgDados.Prefixo := '';

  inherited PrepararConsultaLoteRps(Response);

  aXml := RetornarConteudoEntre(Response.ArquivoEnvio,
   '<ConsultarLoteRpsEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">',
   '</ConsultarLoteRpsEnvio>', False);

  if SubVersao = 1 then
  begin
    Response.ArquivoEnvio := '<ConsultarLoteRpsEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</ConsultarLoteRpsEnvio>';
  end
  else
  begin
    Response.ArquivoEnvio := '<ns3:ConsultarLoteRpsEnvio xmlns:ns3="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</ns3:ConsultarLoteRpsEnvio>';

    ConfigMsgDados.Prefixo := 'ns3';
  end;
end;

procedure TACBrNFSeProviderBetha.PrepararConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  aXml: string;
begin
  ConfigMsgDados.Prefixo := '';

  inherited PrepararConsultaNFSeporRps(Response);

  aXml := RetornarConteudoEntre(Response.ArquivoEnvio,
   '<ConsultarNfsePorRpsEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">',
   '</ConsultarNfsePorRpsEnvio>', False);

  if SubVersao = 1 then
  begin
    Response.ArquivoEnvio := '<ConsultarNfseRpsEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</ConsultarNfseRpsEnvio>';
  end
  else
  begin
    Response.ArquivoEnvio := '<ns3:ConsultarNfsePorRpsEnvio xmlns:ns3="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</ns3:ConsultarNfsePorRpsEnvio>';

    ConfigMsgDados.Prefixo := 'ns3';
  end;
end;

procedure TACBrNFSeProviderBetha.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  aXml: string;
begin
  ConfigMsgDados.Prefixo := '';

  inherited PrepararConsultaNFSe(Response);

  aXml := RetornarConteudoEntre(Response.ArquivoEnvio,
   '<ConsultarNfseEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">',
   '</ConsultarNfseEnvio>', False);

  if SubVersao = 1 then
  begin
    Response.ArquivoEnvio := '<ConsultarNfseEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</ConsultarNfseEnvio>';
  end
  else
  begin
    Response.ArquivoEnvio := '<ns3:ConsultarNfseEnvio xmlns:ns3="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</ns3:ConsultarNfseEnvio>';

    ConfigMsgDados.Prefixo := 'ns3';
  end;
end;

procedure TACBrNFSeProviderBetha.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  aXml: string;
begin
  ConfigMsgDados.Prefixo := '';

  inherited PrepararCancelaNFSe(Response);

  aXml := RetornarConteudoEntre(Response.ArquivoEnvio,
   '<CancelarNfseEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">',
   '</CancelarNfseEnvio>', False);

  if SubVersao = 1 then
  begin
    Response.ArquivoEnvio := '<CancelarNfseEnvio xmlns="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                aXml +
                             '</CancelarNfseEnvio>';
  end
  else
  begin
    Response.ArquivoEnvio := aXml;

    ConfigMsgDados.Prefixo := 'ns3';
  end;
end;

procedure TACBrNFSeProviderBetha.AssinarCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
begin
  inherited AssinarCancelaNFSe(Response);

  if SubVersao = 0 then
    Response.ArquivoEnvio := '<ns3:CancelarNfseEnvio xmlns:ns3="http://www.betha.com.br/e-nota-contribuinte-ws">' +
                                Response.ArquivoEnvio +
                             '</ns3:CancelarNfseEnvio>';
end;

function TACBrNFSeProviderBetha.CondicaoPagToStr(
  const t: TnfseCondicaoPagamento): string;
begin
  Result := EnumeradoToStr(t,
                           ['A_VISTA', 'NA_APRESENTACAO', 'A_PRAZO', 'CARTAO_DEBITO',
                            'CARTAO_CREDITO'],
                           [cpAVista, cpNaApresentacao, cpAPrazo, cpCartaoDebito,
                            cpCartaoCredito]);
end;

function TACBrNFSeProviderBetha.StrToCondicaoPag(out ok: boolean;
  const s: string): TnfseCondicaoPagamento;
begin
  Result := StrToEnumerado(ok, s,
                           ['A_VISTA', 'NA_APRESENTACAO', 'A_PRAZO', 'CARTAO_DEBITO',
                            'CARTAO_CREDITO'],
                           [cpAVista, cpNaApresentacao, cpAPrazo, cpCartaoDebito,
                            cpCartaoCredito])
end;

{ TACBrNFSeProviderBetha202 }

procedure TACBrNFSeProviderBetha202.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.UseCertificateHTTP := False;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.02';
    VersaoAtrib := '2.02';
  end;

  SetXmlNameSpace('http://www.betha.com.br/e-nota-contribuinte-ws');

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');

  SetNomeXSD('nfse_v202.xsd');
end;

function TACBrNFSeProviderBetha202.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Betha202.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderBetha202.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Betha202.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderBetha202.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceBetha202.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderBetha202.DefinirIDLote(const ID: string): string;
begin
  if ConfigGeral.Identificador <> '' then
    Result := ' ' + ConfigGeral.Identificador + '="lote' + ID + '"'
  else
    Result := '';
end;

{ TACBrNFSeXWebserviceBetha202 }

function TACBrNFSeXWebserviceBetha202.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:RecepcionarLoteRps>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:RecepcionarLoteRps>';

  Result := Executar('RecepcionarLoteRpsEnvio', Request,
                     ['return', 'EnviarLoteRpsResposta'],
                ['xmlns:tns="http://www.betha.com.br/e-nota-contribuinte-ws"']);
end;

function TACBrNFSeXWebserviceBetha202.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:RecepcionarLoteRpsSincrono>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:RecepcionarLoteRpsSincrono>';

  Result := Executar('RecepcionarLoteRpsSincronoEnvio', Request,
                     ['return', 'EnviarLoteRpsSincronoResposta'],
                ['xmlns:tns="http://www.betha.com.br/e-nota-contribuinte-ws"']);
end;

function TACBrNFSeXWebserviceBetha202.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:GerarNfse>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:GerarNfse>';

  Result := Executar('GerarNfseEnvio', Request,
                     ['return', 'GerarNfseResposta'],
                ['xmlns:tns="http://www.betha.com.br/e-nota-contribuinte-ws"']);
end;

function TACBrNFSeXWebserviceBetha202.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:ConsultarLoteRps>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:ConsultarLoteRps>';

  Result := Executar('ConsultarLoteRpsEnvio', Request,
                     ['return', 'ConsultarLoteRpsResposta'],
                ['xmlns:tns="http://www.betha.com.br/e-nota-contribuinte-ws"']);
end;

function TACBrNFSeXWebserviceBetha202.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:ConsultarNfseFaixa>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:ConsultarNfseFaixa>';

  Result := Executar('ConsultarNfseFaixaEnvio', Request,
                     ['return', 'ConsultarNfseFaixaResposta'],
                ['xmlns:tns="http://www.betha.com.br/e-nota-contribuinte-ws"']);
end;

function TACBrNFSeXWebserviceBetha202.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:ConsultarNfsePorRps>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:ConsultarNfsePorRps>';

  Result := Executar('ConsultarNfseRpsEnvio', Request,
                     ['return', 'ConsultarNfseRpsResposta'],
                ['xmlns:tns="http://www.betha.com.br/e-nota-contribuinte-ws"']);
end;

function TACBrNFSeXWebserviceBetha202.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:ConsultarNfseServicoPrestado>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:ConsultarNfseServicoPrestado>';

  Result := Executar('ConsultarNfseServicoPrestadoEnvio', Request,
                     ['return', 'ConsultarNfseServicoPrestadoResposta'],
                ['xmlns:tns="http://www.betha.com.br/e-nota-contribuinte-ws"']);
end;

function TACBrNFSeXWebserviceBetha202.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:ConsultarNfseServicoTomado>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:ConsultarNfseServicoTomado>';

  Result := Executar('ConsultarNfseServicoTomadoEnvio', Request,
                     ['return', 'ConsultarNfseServicoTomadoResposta'],
                ['xmlns:tns="http://www.betha.com.br/e-nota-contribuinte-ws"']);
end;

function TACBrNFSeXWebserviceBetha202.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:CancelarNfse>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:CancelarNfse>';

  Result := Executar('CancelarNfseEnvio', Request,
                     ['return', 'CancelarNfseResposta'],
                ['xmlns:tns="http://www.betha.com.br/e-nota-contribuinte-ws"']);
end;

function TACBrNFSeXWebserviceBetha202.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tns:SubstituirNfse>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</tns:SubstituirNfse>';

  {
    O WebService gera a tag com a grafia errada
    <SubstutuirNfseResposta> em vez de <SubstituirNfseResposta>
  }
  Result := Executar('SubstituirNfseEnvio', Request,
                     ['return', 'SubstutuirNfseResposta'],
                ['xmlns:tns="http://www.betha.com.br/e-nota-contribuinte-ws"']);
end;

function TACBrNFSeXWebserviceBetha202.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := StringReplace(Result, '&amp;', '\s\n', [rfReplaceAll]);
  Result := RemoverCaracteresDesnecessarios(Result);
  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverIdentacao(Result);
end;

{ TACBrNFSeXWebserviceBethaAPIPropria }

function TACBrNFSeXWebserviceBethaAPIPropria.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

//  Result := RemoverCaracteresDesnecessarios(Result);
//  Result := ParseText(Result);
//  Result := RemoverDeclaracaoXML(Result);

  Result := RemoverPrefixosDesnecessarios(Result);
end;

function TACBrNFSeXWebserviceBethaAPIPropria.GerarNFSe(const ACabecalho,
  AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := RemoverDeclaracaoXML(AMSG);

  Request := RetornarConteudoEntre(Request,
    '<dps:DPS xmlns:dps="http://www.sped.fazenda.gov.br/nfse" versao="1.01">',
    '</dps:DPS>', False);

  Request := '<dps:RecepcionarDpsEnvio>' +
               '<dps:DPS versao="1.0">' +
                  Request +
               '</dps:DPS>' +
             '</dps:RecepcionarDpsEnvio>';

  Result := Executar('http://www.betha.com.br/e-nota-dps-service/RecepcionarDps',
    Request, [], ['xmlns:dps="http://www.betha.com.br/e-nota-dps"']);
end;

function TACBrNFSeXWebserviceBethaAPIPropria.ConsultarSituacao(
  const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig :=
    '<dps:ConsultarStatusDpsEnvio xmlns:dps="http://www.betha.com.br/e-nota-dps">' +
       AMSG +
    '</dps:ConsultarStatusDpsEnvio>';

  Request := FPMsgOrig;

  Result := Executar('http://www.betha.com.br/e-nota-dps-service/ConsultarStatusDpsEnvio',
    Request, [], []);
end;

function TACBrNFSeXWebserviceBethaAPIPropria.EnviarEvento(const ACabecalho,
  AMSG: string): string;
var
  Request, aTag: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

   if Pos('e105102', Request) > 0 then
    aTag := 'RecepcionarEventoSubstituicaoEnvio'
  else
    aTag := 'RecepcionarEventoCancelamentoEnvio';

  Request := '<evt:' + aTag + '>' +
                AMSG +
             '</evt:' + aTag + '>';

  Result := Executar('http://www.betha.com.br/e-nota-dps-service/' + aTag,
    Request, [], ['xmlns:evt="http://www.betha.com.br/e-nota-dps"']);
end;

function TACBrNFSeXWebserviceBethaAPIPropria.ConsultarNFSePorRps(
  const ACabecalho, AMSG: string): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', FPMsgOrig, [], []);
end;

function TACBrNFSeXWebserviceBethaAPIPropria.ConsultarNFSePorChave(
  const ACabecalho, AMSG: string): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', FPMsgOrig, [], []);
end;

function TACBrNFSeXWebserviceBethaAPIPropria.ConsultarDFe(
  const ACabecalho, AMSG: string): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', FPMsgOrig, [], []);
end;

function TACBrNFSeXWebserviceBethaAPIPropria.ConsultarEvento(
  const ACabecalho, AMSG: string): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', FPMsgOrig, [], []);
end;

function TACBrNFSeXWebserviceBethaAPIPropria.ConsultarParam(
  const ACabecalho, AMSG: string): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', FPMsgOrig, [], []);
end;

function TACBrNFSeXWebserviceBethaAPIPropria.ObterDANFSE(
  const ACabecalho, AMSG: string): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', FPMsgOrig, [], []);
end;

{ TACBrNFSeProviderPadraoNacionalAPIPropria }

procedure TACBrNFSeProviderBethaAPIPropria.Configuracao;
var
  VersaoDFe: string;
begin
  inherited Configuracao;

  VersaoDFe := VersaoNFSeToStr(TACBrNFSeX(FAOwner).Configuracoes.Geral.Versao);

  with ConfigGeral do
  begin
    Layout := loPadraoNacional;
    Identificador := 'id';
    QuebradeLinha := '|';
    ConsultaLote := False;
    FormatoArqEnvio := tfaXml;
    FormatoArqRetorno := tfaXml;
    FormatoArqEnvioSoap := tfaXml;
    FormatoArqRetornoSoap := tfaXml;

    ServicosDisponibilizados.EnviarUnitario := True;
    ServicosDisponibilizados.ConsultarSituacao := True;
    ServicosDisponibilizados.ConsultarNfseChave := True;
    ServicosDisponibilizados.ConsultarRps := True;
    ServicosDisponibilizados.EnviarEvento := True;
    ServicosDisponibilizados.ConsultarEvento := True;
    ServicosDisponibilizados.ConsultarDFe := True;
    ServicosDisponibilizados.ConsultarParam := True;
    ServicosDisponibilizados.ObterDANFSE := True;

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

    XmlRps.InfElemento := 'infDPS';
    XmlRps.DocElemento := 'DPS';

    EnviarEvento.InfElemento := 'infEvento';
    EnviarEvento.DocElemento := 'evento';
  end;

  with ConfigAssinar do
  begin
    RpsGerarNFSe := True;
    EnviarEvento := True;
  end;

  SetNomeXSD('SchemaDPS.xsd');
  {
  with ConfigSchemas do
  begin
    GerarNFSe := 'DPS_v' + VersaoDFe + '.xsd';
    ConsultarNFSe := 'DPS_v' + VersaoDFe + '.xsd';
    ConsultarNFSeRps := 'DPS_v' + VersaoDFe + '.xsd';
    EnviarEvento := 'pedRegEvento_v' + VersaoDFe + '.xsd';
    ConsultarEvento := 'DPS_v' + VersaoDFe + '.xsd';

    Validar := False;
  end;
  }
  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderBethaAPIPropria.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_BethaAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderBethaAPIPropria.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_BethaAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderBethaAPIPropria.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL, AMimeType: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if AMetodo in [tmGerar, tmEnviarEvento, tmConsultarSituacao] then
    AMimeType := 'text/xml'
  else
    AMimeType := 'application/json';

  if URL <> '' then
  begin
    URL := URL + Path;

    Result := TACBrNFSeXWebserviceBethaAPIPropria.Create(FAOwner, AMetodo, URL,
      Method, AMimeType);
  end
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderBethaAPIPropria.GetSchemaPath: string;
begin
  with TACBrNFSeX(FAOwner).Configuracoes do
  begin
    Result := PathWithDelim(Arquivos.PathSchemas + Geral.xProvedor);

    Result := PathWithDelim(Result + VersaoNFSeToStr(Geral.Versao));
  end;
end;

function TACBrNFSeProviderBethaAPIPropria.VerificarAlerta(
  const ACodigo, AMensagem, ACorrecao: string): Boolean;
begin
  Result := ((AMensagem <> '') or (ACorrecao <> '')) and (Pos('L000', ACodigo) > 0);
end;

function TACBrNFSeProviderBethaAPIPropria.VerificarErro(const ACodigo,
  AMensagem, ACorrecao: string): Boolean;
begin
  Result := ((AMensagem <> '') or (ACorrecao <> '')) and (Pos('L000', ACodigo) = 0);
end;

procedure TACBrNFSeProviderBethaAPIPropria.ProcessarMensagemErros(
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
  Correcao := ObterConteudoTag(ErrorNode.Childrens.FindAnyNs('correcao'), tcStr);

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
        Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('codigo'), tcStr);
        Mensagem := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('mensagem'), tcStr);

        ProcessarErro(ANodeArray[I], Codigo, Mensagem);
      end;
    end
    else
    begin
      Codigo := ObterConteudoTag(ANode.Childrens.FindAnyNs('codigo'), tcStr);
      Mensagem := ObterConteudoTag(ANode.Childrens.FindAnyNs('mensagem'), tcStr);

      ProcessarErro(ANode, Codigo, Mensagem);
    end;
  end;
end;

begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  ProcessarErros;

  ANode := RootNode.Childrens.FindAnyNs('ListaMensagemAlertaRetorno');

  if Assigned(ANode) then
  begin
    ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

    if Assigned(ANodeArray) then
    begin
      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        Mensagem := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('mensagem'), tcStr);

        if Mensagem <> '' then
        begin
          AAlerta := Response.Alertas.New;
          AAlerta.Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('codigo'), tcStr);
          AAlerta.Descricao := Mensagem;
          AAlerta.Correcao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('correcao'), tcStr);
        end;
      end;
    end
    else
    begin
      Mensagem := ObterConteudoTag(ANode.Childrens.FindAnyNs('mensagem'), tcStr);

      if Mensagem <> '' then
      begin
        AAlerta := Response.Alertas.New;
        AAlerta.Codigo := ObterConteudoTag(ANode.Childrens.FindAnyNs('codigo'), tcStr);
        AAlerta.Descricao := Mensagem;
        AAlerta.Correcao := ObterConteudoTag(ANode.Childrens.FindAnyNs('correcao'), tcStr);
      end;
    end;
  end;
end;

function TACBrNFSeProviderBethaAPIPropria.PrepararArquivoEnvio(
  const aXml: string; aMetodo: TMetodo): string;
begin
  if aMetodo in [tmGerar, tmEnviarEvento] then
    Result := ChangeLineBreak(aXml, '');
end;

procedure TACBrNFSeProviderBethaAPIPropria.PrepararEmitir(
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

    ListaDps := ListaDps + Nota.XmlRps;
  end;

  Response.ArquivoEnvio := ListaDps;
  Path := '';
  Method := 'POST';
end;

procedure TACBrNFSeProviderBethaAPIPropria.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode,AuxNode: TACBrXmlNode;
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

      Response.Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhRecebimento'), tcDatHor);
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('protocolo'), tcStr);
      Response.Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('status'), tcStr);

      AuxNode := ANode.Childrens.FindAnyNs('emissao');
      if Assigned(AuxNode) then
      begin
        Response.idRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('idDps'), tcStr);
        Response.idNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('chaveAcesso'), tcStr);
        Response.NumeroRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numeroDps'), tcStr);
        Response.SerieRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('serieDps'), tcStr);
        Response.NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numeroNotaFiscal'), tcStr);
        Response.Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('linkPdf'), tcStr);
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

procedure TACBrNFSeProviderBethaAPIPropria.PrepararConsultaSituacao(
  Response: TNFSeConsultaSituacaoResponse);
var
  aXml: string;
  Emitente: TEmitenteConfNFSe;
  ACodMun, ATpAmbiente, ATpIntegracao: string;
begin
  ConfigMsgDados.Prefixo := '';
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  ACodMun := IntToStr(TACBrNFSeX(FAOwner).Configuracoes.Geral.CodigoMunicipio);
  ATpAmbiente := '1';

  if ConfigGeral.Ambiente = taHomologacao then
   ATpAmbiente := '2';

  case Response.tpEvento of
    teCancelamento: ATpIntegracao := 'CANCELAMENTO';
    teCancelamentoSubstituicao: ATpIntegracao := 'CANCELAMENTO_POR_SUBSTICAO';
  else
    ATpIntegracao := 'EMISSAO' ;
  end;

  Response.ArquivoEnvio :=
         '<dps:tpAmb>' + ATpAmbiente + '</dps:tpAmb>' +
         '<dps:codigoIbge>' + ACodMun + '</dps:codigoIbge>' +
         '<dps:cpfCnpjPrestador>' + Emitente.CNPJ + '</dps:cpfCnpjPrestador>' +
         '<dps:protocolo>' + Response.Protocolo + '</dps:protocolo>' +
         '<dps:tipoIntegracao>' + ATpIntegracao + '</dps:tipoIntegracao>';
  Path := '';
  Method := 'POST';
end;

procedure TACBrNFSeProviderBethaAPIPropria.TratarRetornoConsultaSituacao(
  Response: TNFSeConsultaSituacaoResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode,AuxNode: TACBrXmlNode;
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

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      if (ANode.Name <> 'ConsultarStatusDpsResposta') and
         (ANode.Name <> 'ConsultarStatusDpsEmissaoResposta') then
      begin
        ANode := ANode.Childrens.FindAnyNs('ConsultarStatusDpsEmissaoResposta');
        if ANode = nil then
          ANode := Document.Root.Childrens.FindAnyNs('ConsultarStatusDpsResposta');
      end;

      if ANode = nil then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := 'Resposta DPS fora do padrão esperado';
        Exit;
      end;

      ProcessarMensagemErros(ANode, Response);

      Response.Protocolo :=
        ObterConteudoTag(ANode.Childrens.FindAnyNs('protocolo'), tcStr);

      Response.NumeroLote :=
        ObterConteudoTag(ANode.Childrens.FindAnyNs('idDps'), tcStr);

      Response.Situacao :=
        ObterConteudoTag(ANode.Childrens.FindAnyNs('statusProcessamento'), tcStr);

      Response.Data :=
        ObterConteudoTag(ANode.Childrens.FindAnyNs('dataHoraRecebimento'), tcDatHor);

      AuxNode := ANode.Childrens.FindAnyNs('emissao');
      if Assigned(AuxNode) then
      begin
        Response.idRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('idDps'), tcStr);
        Response.idNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('chaveAcesso'), tcStr);
        Response.NumeroRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numeroDps'), tcStr);
        Response.SerieRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('serieDps'), tcStr);
        Response.NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numeroNotaFiscal'), tcStr);
        Response.Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('linkPdf'), tcStr);
      end;

      Response.Sucesso := (Response.Erros.Count = 0);
    except
      on E: Exception do
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

procedure TACBrNFSeProviderBethaAPIPropria.PrepararEnviarEvento(
  Response: TNFSeEnviarEventoResponse);
var
  AErro: TNFSeEventoCollectionItem;
  xEvento, xUF, xAutorEvento, IdAttrPRE, IdAttrEVT, xCamposEvento, nomeArq,
  CnpjCpf: string;
begin
  with Response.InfEvento.pedRegEvento do
  begin
    if chNFSe = '' then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod004;
      AErro.Descricao := ACBrStr(Desc004);
    end;

    if Response.Erros.Count > 0 then Exit;

    xUF := TACBrNFSeX(FAOwner).Configuracoes.WebServices.UF;

    CnpjCpf := OnlyAlphaNum(TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.CNPJ);
    if Length(CnpjCpf) < 14 then
    begin
      xAutorEvento := '<evt:CPFAutor>' +
                        CnpjCpf +
                      '</evt:CPFAutor>';
    end
    else
    begin
      xAutorEvento := '<evt:CNPJAutor>' +
                        CnpjCpf +
                      '</evt:CNPJAutor>';
    end;

    ID := chNFSe + OnlyNumber(tpEventoToStr(tpEvento));
    // +
      //        FormatFloat('000', nPedRegEvento);

    IdAttrPRE := 'id="' + 'PRE' + ID + '"';
    IdAttrEVT := 'id="' + 'EVT' + ID + '"';

    case tpEvento of
      teCancelamento,
      teAnaliseParaCancelamento:
        xCamposEvento := '<evt:cMotivo>' + IntToStr(cMotivo) + '</evt:cMotivo>' +
                         '<evt:xMotivo>' + xMotivo + '</evt:xMotivo>';

      teCancelamentoSubstituicao:
        xCamposEvento := '<evt:cMotivo>' + Formatfloat('00', cMotivo) + '</evt:cMotivo>' +
                         '<evt:xMotivo>' + xMotivo + '</evt:xMotivo>' +
                         '<evt:chSubstituta>' + chSubstituta + '</evt:chSubstituta>';

      teRejeicaoPrestador,
      teRejeicaoTomador,
      teRejeicaoIntermediario:
        xCamposEvento := '<evt:infRej>' +
                           '<evt:cMotivo>' + IntToStr(cMotivo) + '</evt:cMotivo>' +
                           '<evt:xMotivo>' + xMotivo + '</evt:xMotivo>' +
                         '</evt:infRej>';
    else
      // teConfirmacaoPrestador, teConfirmacaoTomador,
      // ConfirmacaoIntermediario
      xCamposEvento := '';
    end;

    xEvento := '<evt:pedRegEvento versao="' + ConfigWebServices.VersaoAtrib + '">' +
                 '<evt:infPedReg ' + IdAttrPRE + '>' +
                   '<evt:chNFSe>' + chNFSe + '</evt:chNFSe>' +
                   xAutorEvento +
                   '<evt:dhEvento>' +
                     FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', dhEvento) +
                     GetUTC(xUF, dhEvento) +
                   '</evt:dhEvento>' +
                   '<evt:tpAmb>' + IntToStr(tpAmb) + '</evt:tpAmb>' +
                   '<evt:verAplic>' + verAplic + '</evt:verAplic>' +
                   '<evt:' + tpEventoToStr(tpEvento) + '>' +
                     '<evt:xDesc>' + tpEventoToDesc(tpEvento) + '</evt:xDesc>' +
                     xCamposEvento +
                   '</evt:' + tpEventoToStr(tpEvento) + '>' +
                 '</evt:infPedReg>' +
               '</evt:pedRegEvento>';

    xEvento := '<evt:evento xmlns:evt="http://www.betha.com.br/e-nota-dps"' +
                   ' versao="' + ConfigWebServices.VersaoAtrib + '">' +
                 '<evt:infEvento ' + IdAttrEVT + '>' +
                   '<evt:verAplic>' + verAplic + '</evt:verAplic>' +
                   '<evt:ambGer>' + '1' + '</evt:ambGer>' +
                   '<evt:nSeqEvento>' + '001' + '</evt:nSeqEvento>' +
                   '<evt:dhProc>' +
                     FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', dhEvento) +
                     GetUTC(xUF, dhEvento) +
                   '</evt:dhProc>' +
                   '<evt:nDFe>' + '0' + '</evt:nDFe>' +
                   xEvento +
                 '</evt:infEvento>' +
               '</evt:evento>';

    //xEvento := ConverteXMLtoUTF8(xEvento);
    xEvento := ChangeLineBreak(xEvento, '');
    Response.ArquivoEnvio := xEvento;

    nomeArq := '';
    SalvarXmlEvento(ID + '-pedRegEvento', Response.ArquivoEnvio, nomeArq);
    Response.PathNome := nomeArq;
    Path := '';
    Method := 'POST';
  end;
end;

procedure TACBrNFSeProviderBethaAPIPropria.TratarRetornoEnviarEvento(
  Response: TNFSeEnviarEventoResponse);
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

      Response.Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhRecebimento'), tcDatHor);
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('protocolo'), tcStr);
      Response.Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('status'), tcStr);
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
