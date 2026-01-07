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
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXProviderProprio;

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
  {
    function ConsultarNFSePorRps(const ACabecalho, AMSG: string): string; override;
    function ConsultarNFSePorChave(const ACabecalho, AMSG: string): string; override;
    function EnviarEvento(const ACabecalho, AMSG: string): string; override;
    function ConsultarEvento(const ACabecalho, AMSG: string): string; override;
    function ConsultarDFe(const ACabecalho, AMSG: string): string; override;
    function ConsultarParam(const ACabecalho, AMSG: string): string; override;
    function ObterDANFSE(const ACabecalho, AMSG: string): string; override;
    }

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderBethaAPIPropria = class(TACBrNFSeProviderProprio)
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

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;
    {
    procedure PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;

    procedure PrepararConsultaNFSeporChave(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSeporChave(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararEnviarEvento(Response: TNFSeEnviarEventoResponse); override;
    procedure TratarRetornoEnviarEvento(Response: TNFSeEnviarEventoResponse); override;

    procedure PrepararConsultarEvento(Response: TNFSeConsultarEventoResponse); override;
    procedure TratarRetornoConsultarEvento(Response: TNFSeConsultarEventoResponse); override;

    procedure PrepararConsultarDFe(Response: TNFSeConsultarDFeResponse); override;
    procedure TratarRetornoConsultarDFe(Response: TNFSeConsultarDFeResponse); override;

    procedure PrepararConsultarParam(Response: TNFSeConsultarParamResponse); override;
    procedure TratarRetornoConsultarParam(Response: TNFSeConsultarParamResponse); override;

    procedure PrepararObterDANFSE(Response: TNFSeObterDANFSEResponse); override;
    procedure TratarRetornoObterDANFSE(Response: TNFSeObterDANFSEResponse); override;

    }
  public
    function RegimeEspecialTributacaoToStr(const t: TnfseRegimeEspecialTributacao): string; override;
    function StrToRegimeEspecialTributacao(out ok: boolean; const s: string): TnfseRegimeEspecialTributacao; override;
    function RegimeEspecialTributacaoDescricao(const t: TnfseRegimeEspecialTributacao): string; override;
  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrUtil.Strings, ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  ACBrNFSeXNotasFiscais, Betha.GravarXml, Betha.LerXml;

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
    {
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

    XmlRps.InfElemento := 'infDPS';
    XmlRps.DocElemento := 'DPS';

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
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceBethaAPIPropria.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
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

procedure TACBrNFSeProviderBethaAPIPropria.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
begin
  if aMetodo in [tmGerar, tmEnviarEvento] then
  begin
    inherited ValidarSchema(Response, aMetodo);

    Response.ArquivoEnvio := ChangeLineBreak(Response.ArquivoEnvio, '');
  end;
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
end;

procedure TACBrNFSeProviderBethaAPIPropria.TratarRetornoEmitir(
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

function TACBrNFSeProviderBethaAPIPropria.RegimeEspecialTributacaoToStr(
  const t: TnfseRegimeEspecialTributacao): string;
begin
  Result := EnumeradoToStr(t,
                         ['0', '1', '2', '3', '4', '5', '6'],
                         [retNenhum, retCooperativa, retEstimativa,
                         retMicroempresaMunicipal, retNotarioRegistrador,
                         retISSQNAutonomos, retSociedadeProfissionais]);
end;

function TACBrNFSeProviderBethaAPIPropria.StrToRegimeEspecialTributacao(
  out ok: boolean; const s: string): TnfseRegimeEspecialTributacao;
begin
  Result := StrToEnumerado(ok, s,
                        ['0', '1', '2', '3', '4', '5', '6'],
                        [retNenhum, retCooperativa, retEstimativa,
                         retMicroempresaMunicipal, retNotarioRegistrador,
                         retISSQNAutonomos, retSociedadeProfissionais]);
end;

function TACBrNFSeProviderBethaAPIPropria.RegimeEspecialTributacaoDescricao(
  const t: TnfseRegimeEspecialTributacao): string;
begin
  case t of
    retNenhum:                 Result := '0 - Nenhum';
    retCooperativa:            Result := '1 - Cooperativa';
    retEstimativa:             Result := '2 - Estimativa';
    retMicroempresaMunicipal:  Result := '3 - Microempresa Municipal';
    retNotarioRegistrador:     Result := '4 - Notário ou Registrador';
    retISSQNAutonomos:         Result := '5 - Profissional Autônomo';
    retSociedadeProfissionais: Result := '6 - Sociedade de Profissionais';
  else
    Result := '';
  end;
end;

end.
