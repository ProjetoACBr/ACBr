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

unit Pronim.Provider;

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
  ACBrNFSeXProviderABRASFv1,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase,
  ACBrNFSeXWebservicesResponse,
  PadraoNacional.Provider;

type
  TACBrNFSeXWebservicePronim = class(TACBrNFSeXWebserviceSoap11)

  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderPronim = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  end;

  TACBrNFSeXWebservicePronim202 = class(TACBrNFSeXWebserviceSoap11)
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

  TACBrNFSeProviderPronim202 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  end;

  TACBrNFSeProviderPronim203 = class (TACBrNFSeProviderPronim202)
  protected
    procedure Configuracao; override;

  end;

  TACBrNFSeXWebservicePronimAPIPropria = class(TACBrNFSeXWebservicePadraoNacional)
  protected

  public

  end;

  TACBrNFSeProviderPronimAPIPropria = class(TACBrNFSeProviderPadraoNacional)
  private

  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure LerNFSe(NFSeXml: string);

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;

    procedure PrepararEnviarEvento(Response: TNFSeEnviarEventoResponse); override;
    procedure TratarRetornoEnviarEvento(Response: TNFSeEnviarEventoResponse); override;

    function PrepararArquivoEnvio(const aXml: string; aMetodo: TMetodo): string; override;
  end;

implementation

uses
  ACBrJSON,
  ACBrCompress,
  synacode,
  ACBrUtil.XMLHTML,
  ACBrUtil.Strings,
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  ACBrDFeException,
  ACBrNFSeX,
  ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXConsts,
  Pronim.GravarXml,
  Pronim.LerXml;

{ TACBrNFSeProviderPronim }

procedure TACBrNFSeProviderPronim.Configuracao;
begin
  inherited Configuracao;

  ConfigAssinar.LoteRps := True;

  with ConfigGeral do
  begin
    Identificador      := 'id';
    UseCertificateHTTP := False;
  end;

  with ConfigMsgDados do
  begin
    DadosCabecalho := '<tem:cabecalho versao="1.00">' +
                        '<tem:versaoDados>1.00</tem:versaoDados>' +
                      '</tem:cabecalho>';
  end;
end;

function TACBrNFSeProviderPronim.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Pronim.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderPronim.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Pronim.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderPronim.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebservicePronim.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderPronim.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
begin
  inherited ValidarSchema(Response, aMetodo);

  Response.ArquivoEnvio := StringReplace(Response.ArquivoEnvio,
    ' xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"', '', [rfReplaceAll]);
end;

{ TACBrNFSeXWebservicePronim }

function TACBrNFSeXWebservicePronim.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:RecepcionarLoteRps>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:RecepcionarLoteRps>';

  Result := Executar('http://tempuri.org/INFSEGeracao/RecepcionarLoteRps', Request,
                     ACabecalho,
                     ['RecepcionarLoteRpsResult', 'EnviarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim.ConsultarSituacao(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarSituacaoLoteRps>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarSituacaoLoteRps>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarSituacaoLoteRps', Request,
                     ACabecalho,
                     ['ConsultarSituacaoLoteRpsResult', 'ConsultarSituacaoLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarLoteRps>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarLoteRps>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarLoteRps', Request,
                     ACabecalho,
                     ['ConsultarLoteRpsResult', 'ConsultarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfsePorRps>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarNfsePorRps>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarNfsePorRps', Request,
                     ACabecalho,
                     ['ConsultarNfsePorRpsResult', 'ConsultarNfseRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim.ConsultarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfse>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarNfse>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarNfse', Request,
                     ACabecalho,
                     ['ConsultarNfseResult', 'ConsultarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:CancelarNfse>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:CancelarNfse>';

  Result := Executar('http://tempuri.org/INFSEGeracao/CancelarNfse', Request,
                     ACabecalho,
                     ['CancelarNfseResult', 'CancelarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverIdentacao(Result);
end;

{ TACBrNFSeProviderPronim202 }

procedure TACBrNFSeProviderPronim202.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    LoteRps := True;
    RpsGerarNFSe := True;
    CancelarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.02';
    VersaoAtrib := '202';
  end;

  with ConfigMsgDados do
  begin
    DadosCabecalho := '<tem:cabecalho versao="' + ConfigWebServices.VersaoAtrib + '">' +
                      '<tem:versaoDados>' + ConfigWebServices.VersaoDados + '</tem:versaoDados>' +
                      '</tem:cabecalho>';
  end;
end;

function TACBrNFSeProviderPronim202.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Pronim202.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderPronim202.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Pronim202.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderPronim202.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebservicePronim202.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderPronim202.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
begin
  inherited ValidarSchema(Response, aMetodo);

  Response.ArquivoEnvio := StringReplace(Response.ArquivoEnvio,
              ' xmlns="http://www.abrasf.org.br/nfse.xsd"', '', [rfReplaceAll]);
end;

{ TACBrNFSeProviderPronim203 }

procedure TACBrNFSeProviderPronim203.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    LoteRps := True;
    RpsGerarNFSe := True;
    CancelarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.03';
    VersaoAtrib := '203';
  end;

  with ConfigMsgDados do
  begin
    DadosCabecalho := '<tem:cabecalho versao="' + ConfigWebServices.VersaoAtrib + '">' +
                      '<tem:versaoDados>' + ConfigWebServices.VersaoDados + '</tem:versaoDados>' +
                      '</tem:cabecalho>';
  end;
end;

{ TACBrNFSeXWebservicePronim202 }

function TACBrNFSeXWebservicePronim202.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:RecepcionarLoteRps>';
  Request := Request + '<tem:xmlEnvio>' + IncluirCDATA(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:RecepcionarLoteRps>';

  Result := Executar('http://tempuri.org/INFSEGeracao/RecepcionarLoteRps', Request,
                     ACabecalho,
                     ['RecepcionarLoteRpsResult', 'EnviarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim202.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:EnviarLoteRpsSincrono>';
  Request := Request + '<tem:xmlEnvio>' + IncluirCDATA(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:EnviarLoteRpsSincrono>';

  Result := Executar('http://tempuri.org/INFSEGeracao/EnviarLoteRpsSincrono', Request,
                     ACabecalho,
                     ['EnviarLoteRpsSincronoResult', 'EnviarLoteRpsSincronoResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim202.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:GerarNfse>';
  Request := Request + '<tem:xmlEnvio>' + IncluirCDATA(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:GerarNfse>';

  Result := Executar('http://tempuri.org/INFSEGeracao/GerarNfse', Request,
                     ACabecalho,
                     ['GerarNfseResponseResult', 'GerarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
 {
   Alterado de GerarNfseResult para GerarNfseResponseResult
   Versão 2.03
 }
end;

function TACBrNFSeXWebservicePronim202.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarLoteRps>';
  Request := Request + '<tem:xmlEnvio>' + IncluirCDATA(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarLoteRps>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarLoteRps', Request,
                     ACabecalho,
                     ['ConsultarLoteRpsResult', 'ConsultarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim202.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfsePorFaixa>';
  Request := Request + '<tem:xmlEnvio>' + IncluirCDATA(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarNfsePorFaixa>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarNfsePorFaixa', Request,
                     ACabecalho,
                     ['ConsultarNfseResult', 'ConsultarNfseFaixaResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim202.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfsePorRps>';
  Request := Request + '<tem:xmlEnvio>' + IncluirCDATA(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarNfsePorRps>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarNfsePorRps', Request,
                     ACabecalho,
                     ['ConsultarNfsePorRpsResult', 'ConsultarNfseRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim202.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfseServicoPrestado>';
  Request := Request + '<tem:xmlEnvio>' + IncluirCDATA(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarNfseServicoPrestado>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarNfseServicoPrestado', Request,
                     ACabecalho,
                     ['ConsultarNfseServicoPrestadoResult', 'ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim202.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfseServicoTomado>';
  Request := Request + '<tem:xmlEnvio>' + IncluirCDATA(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarNfseServicoTomado>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarNfseServicoTomado', Request,
                     ACabecalho,
                     ['ConsultarNfseServicoTomadoResult', 'ConsultarNfseServicoTomadoResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim202.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:CancelarNfse>';
  Request := Request + '<tem:xmlEnvio>' + IncluirCDATA(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:CancelarNfse>';

  Result := Executar('http://tempuri.org/INFSEGeracao/CancelarNfse', Request,
                     ACabecalho,
                     ['CancelarNfseResult', 'CancelarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim202.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:SubstituirNfse>';
  Request := Request + '<tem:xmlEnvio>' + IncluirCDATA(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:SubstituirNfse>';

  Result := Executar('http://tempuri.org/INFSEGeracao/SubstituirNfse', Request,
                     ACabecalho,
                     ['SubstituirNfseResult', 'SubstituirNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebservicePronim202.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := RemoverCaracteresDesnecessarios(Result);
  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverIdentacao(Result);
end;

{ TACBrNFSeProviderPronimAPIPropria }

procedure TACBrNFSeProviderPronimAPIPropria.Configuracao;
begin
  inherited Configuracao;

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderPronimAPIPropria.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_PronimAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderPronimAPIPropria.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_PronimAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderPronimAPIPropria.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
  begin
    URL := URL + Path;

    Result := TACBrNFSeXWebservicePronimAPIPropria.Create(FAOwner, AMetodo, URL, Method)
  end
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderPronimAPIPropria.LerNFSe(NFSeXml: string);
begin

end;

procedure TACBrNFSeProviderPronimAPIPropria.PrepararEmitir(
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

procedure TACBrNFSeProviderPronimAPIPropria.TratarRetornoEmitir(
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

procedure TACBrNFSeProviderPronimAPIPropria.PrepararConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  CnpjCpf: string;
begin
  if EstaVazio(Response.NumeroRps) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod102;
    AErro.Descricao := ACBrStr(Desc102);
    Exit;
  end;

  if EstaVazio(Response.SerieRps) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod103;
    AErro.Descricao := ACBrStr(Desc103);
    Exit;
  end;

  CnpjCpf := OnlyAlphaNum(TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.CNPJ);

  Path := '/ConsultarDPS/' + CnpjCpf + '/' + Response.SerieRps + '/' +
          Response.NumeroRps;
  Response.ArquivoEnvio := Path;
  Method := 'GET';
end;

procedure TACBrNFSeProviderPronimAPIPropria.TratarRetornoConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  Document, JSon: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  JSonLote: TACBrJSONArray;
  i: Integer;
  AResumo: TNFSeResumoCollectionItem;
  NFSeXml: string;
  DocumentXml: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  NumNFSe, NumDps, CodVerif: string;
  DataAut: TDateTime;
  ANota: TNotaFiscal;

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

  try
    try
      ProcessarMensagemDeErros(Document, Response);
      Response.Sucesso := (Response.Erros.Count = 0);

      JSonLote := Document.AsJSONArray['notas'];

      if JSonLote.Count > 0 then
      begin
        for i := 0 to JSonLote.Count-1 do
        begin
          JSon := JSonLote.ItemAsJSONObject[i];

          AResumo := Response.Resumos.New;
          AResumo.Link := JSon.AsString['chave'];

          NFSeXml := JSon.AsString['xmlGZipB64'];

          if NFSeXml <> '' then
          begin
            NFSeXml := DeCompress(DecodeBase64(NFSeXml));

            AResumo.XmlRetorno := NFSeXml;

            LerNFSe(NFSeXml);
          end;
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

procedure TACBrNFSeProviderPronimAPIPropria.PrepararEnviarEvento(
  Response: TNFSeEnviarEventoResponse);
var
  AErro: TNFSeEventoCollectionItem;
  xEvento, xUF, xAutorEvento, IdAttr, xCamposEvento, nomeArq, CnpjCpf: string;
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
      xAutorEvento := '<CPFAutor>' +
                        CnpjCpf +
                      '</CPFAutor>';
    end
    else
    begin
      xAutorEvento := '<CNPJAutor>' +
                        CnpjCpf +
                      '</CNPJAutor>';
    end;

    ID := chNFSe + OnlyNumber(tpEventoToStr(tpEvento)) +
              FormatFloat('000', nPedRegEvento);

    IdAttr := 'Id="' + 'PRE' + ID + '"';

    case tpEvento of
      teCancelamento:
        xCamposEvento := '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                         '<xMotivo>' + xMotivo + '</xMotivo>';

      teCancelamentoSubstituicao:
        xCamposEvento := '<cMotivo>' + Formatfloat('00', cMotivo) + '</cMotivo>' +
                         '<xMotivo>' + xMotivo + '</xMotivo>' +
                         '<chSubstituta>' + chSubstituta + '</chSubstituta>';

      teAnaliseParaCancelamento:
        xCamposEvento := '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                         '<xMotivo>' + xMotivo + '</xMotivo>';

      teRejeicaoPrestador:
        xCamposEvento := '<infRej>' +
                           '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                           '<xMotivo>' + xMotivo + '</xMotivo>' +
                         '</infRej>';

      teRejeicaoTomador:
        xCamposEvento := '<infRej>' +
                           '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                           '<xMotivo>' + xMotivo + '</xMotivo>' +
                         '</infRej>';

      teRejeicaoIntermediario:
        xCamposEvento := '<infRej>' +
                           '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                           '<xMotivo>' + xMotivo + '</xMotivo>' +
                         '</infRej>';
    else
      // teConfirmacaoPrestador, teConfirmacaoTomador,
      // ConfirmacaoIntermediario
      xCamposEvento := '';
    end;

    xEvento := '<pedRegEvento xmlns="' + ConfigMsgDados.EnviarEvento.xmlns +
                           '" versao="' + ConfigWebServices.VersaoAtrib + '">' +
                 '<infPedReg ' + IdAttr + '>' +
                   '<tpAmb>' + IntToStr(tpAmb) + '</tpAmb>' +
                   '<verAplic>' + verAplic + '</verAplic>' +
                   '<dhEvento>' +
                     FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', dhEvento) +
                     GetUTC(xUF, dhEvento) +
                   '</dhEvento>' +
                   xAutorEvento +
                   '<chNFSe>' + chNFSe + '</chNFSe>' +
                   '<nPedRegEvento>' +
                     FormatFloat('000', nPedRegEvento) +
                   '</nPedRegEvento>' +
                   '<' + tpEventoToStr(tpEvento) + '>' +
                     '<xDesc>' + tpEventoToDesc(tpEvento) + '</xDesc>' +
                     xCamposEvento +
                   '</' + tpEventoToStr(tpEvento) + '>' +
                 '</infPedReg>' +
               '</pedRegEvento>';

    xEvento := ConverteXMLtoUTF8(xEvento);
    xEvento := ChangeLineBreak(xEvento, '');

    Response.ArquivoEnvio := xEvento;

    nomeArq := '';
    SalvarXmlEvento(ID + '-pedRegEvento', Response.ArquivoEnvio, nomeArq);
    Response.PathNome := nomeArq;
  end;
end;

procedure TACBrNFSeProviderPronimAPIPropria.TratarRetornoEnviarEvento(
  Response: TNFSeEnviarEventoResponse);
var
  Document, JSon: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  EventoXml, IDEvento, nomeArq: string;
  DocumentXml: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  Ok: Boolean;
  JSonLote: TACBrJSONArray;
  i: Integer;
  AResumo: TNFSeResumoCollectionItem;

  procedure LerEvento(EventoXml: string);
  begin
    if EventoXml = '' then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod211;
      AErro.Descricao := ACBrStr(Desc211);
      Exit
    end;

    DocumentXml := TACBrXmlDocument.Create;

    try
      try
        DocumentXml.LoadFromXml(EventoXml);

        ANode := DocumentXml.Root.Childrens.FindAnyNs('infEvento');

        IDEvento := OnlyNumber(ObterConteudoTag(ANode.Attributes.Items['Id']));

        Response.nSeqEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('nSeqEvento'), tcInt);
        Response.Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhProc'), tcDatHor);
        Response.idEvento := IDEvento;
        Response.tpEvento := StrTotpEvento(Ok, Copy(IDEvento, 51, 6));
        Response.XmlRetorno := EventoXml;

        case Response.tpEvento of
          teCancelamento:
            begin
              Response.SucessoCanc := True;
              Response.DescSituacao := 'Nota Cancelada';
            end
        else
          begin
            Response.SucessoCanc := False;
            Response.DescSituacao := '';
          end;
        end;

        ANode := ANode.Childrens.FindAnyNs('pedRegEvento');
        ANode := ANode.Childrens.FindAnyNs('infPedReg');

        Response.idNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('chNFSe'), tcStr);

        nomeArq := '';
        SalvarXmlEvento(IDEvento + '-procEveNFSe', EventoXml, nomeArq);
        Response.PathNome := nomeArq;
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

      EventoXml := JSon.AsString['xmlGZipB64'];

      if EventoXml <> '' then
      begin
        EventoXml := DeCompress(DecodeBase64(EventoXml));

        AResumo.XmlRetorno := EventoXml;

        LerEvento(EventoXml);
      end;
    end;
  end;
end;

function TACBrNFSeProviderPronimAPIPropria.PrepararArquivoEnvio(
  const aXml: string; aMetodo: TMetodo): string;
begin
  if aMetodo in [tmGerar, tmEnviarEvento] then
  begin
    Result := ChangeLineBreak(aXml, '');

    if aMetodo = tmEnviarEvento then
      Result := EncodeBase64(GZipCompress(Result));

    case aMetodo of
      tmGerar,
      tmEnviarEvento:
        begin
          Result := '{"loteXmlGZipB64":["' + Result + '"]}';
          Path := '/EnviarSincrono';
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

end.
