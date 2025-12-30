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

unit Coplan.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXClass,
  ACBrNFSeXConversao,
  ACBrNFSeXGravarXml,
  ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase,
  ACBrNFSeXWebservicesResponse,
  ACBrNFSeXProviderProprio;

type
  TACBrNFSeXWebserviceCoplan201 = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNamespace: string;

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

    property Namespace: string read GetNamespace;
  end;

  TACBrNFSeProviderCoplan201 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;
  end;

  TACBrNFSeXWebserviceCoplanAPIPropria = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNamespace: string;
  public
    function RecepcionarSincrono(const ACabecalho, AMSG: string): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: string): string; override;
    function GerarNFSe(const ACabecalho, AMSG: string): string; override;
    function Cancelar(const ACabecalho, AMSG: string): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;

    property Namespace: string read GetNamespace;
  end;

  TACBrNFSeProviderCoplanAPIPropria = class(TACBrNFSeProviderProprio)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function VerificarAlerta(const ACodigo, AMensagem, ACorrecao: string): Boolean;
    function VerificarErro(const ACodigo, AMensagem, ACorrecao: string): Boolean;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = 'ListaMensagemRetorno';
                                     const AMessageTag: string = 'MensagemRetorno'); override;

    function PrepararRpsParaLote(const aXml: string): string; override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
    procedure GerarMsgDadosConsultaporRps(Response: TNFSeConsultaNFSeporRpsResponse; Params: TNFSeParamsResponse); override;
    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure GerarMsgDadosCancelaNFSe(Response: TNFSeCancelaNFSeResponse; Params: TNFSeParamsResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
  end;

implementation

uses
  StrUtilsEx,
  synacode,
  ACBrUtil.Base,
  ACBrJSON,
  ACBrCompress,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  ACBrDFe.Conversao,
  ACBrDFeException,
  ACBrNFSeX,
  ACBrNFSeXConsts,
  ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais,
  Coplan.GravarXml,
  Coplan.LerXml;

{ TACBrNFSeProviderCoplan201 }

procedure TACBrNFSeProviderCoplan201.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.ConsultaPorFaixaPreencherNumNfseFinal := True;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
    RpsSubstituirNFSe := True;
    SubstituirNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.01';
    VersaoAtrib := '2.01';
  end;

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');
end;

function TACBrNFSeProviderCoplan201.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Coplan201.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCoplan201.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Coplan201.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCoplan201.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceCoplan201.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceCoplan201 }

function TACBrNFSeXWebserviceCoplan201.GetNamespace: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
    Result := 'Tributario_PRODUCAO_FULL'
  else
    Result := 'TributarioGx16New';

  Result := 'xmlns:trib1="' + Result + '"';
end;

function TACBrNFSeXWebserviceCoplan201.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web_service.RECEPCIONARLOTERPS>';
  Request := Request + '<trib:Recepcionarloterpsrequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Recepcionarloterpsrequest>';
  Request := Request + '</trib:nfse_web_service.RECEPCIONARLOTERPS>';

  Result := Executar('Tributarioaction/ANFSE_WEB_SERVICE.RECEPCIONARLOTERPS', Request,
                     ['Recepcionarloterpsresponse', 'outputXML', 'EnviarLoteRpsResposta'],
                     ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplan201.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web_service.RECEPCIONARLOTERPSSINCRONO>';
  Request := Request + '<trib:Recepcionarloterpssincronorequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Recepcionarloterpssincronorequest>';
  Request := Request + '</trib:nfse_web_service.RECEPCIONARLOTERPSSINCRONO>';

  Result := Executar('Tributarioaction/ANFSE_WEB_SERVICE.RECEPCIONARLOTERPSSINCRONO', Request,
                     ['Recepcionarloterpssincronoresponse', 'outputXML', 'EnviarLoteRpsSincronoResposta'],
                     ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplan201.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web_service.GERARNFSE>';
  Request := Request + '<trib:Gerarnfserequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Gerarnfserequest>';
  Request := Request + '</trib:nfse_web_service.GERARNFSE>';

  Result := Executar('Tributarioaction/ANFSE_WEB_SERVICE.GERARNFSE', Request,
                     ['Gerarnfseresponse', 'outputXML', 'GerarNfseResposta'],
                     ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplan201.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web_service.CONSULTARLOTERPS>';
  Request := Request + '<trib:Consultarloterpsrequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Consultarloterpsrequest>';
  Request := Request + '</trib:nfse_web_service.CONSULTARLOTERPS>';

  Result := Executar('Tributarioaction/ANFSE_WEB_SERVICE.CONSULTARLOTERPS', Request,
                     ['Consultarloterpsresponse', 'outputXML', 'ConsultarLoteRpsResposta'],
                     ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplan201.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web_service.CONSULTARNFSEFAIXA>';
  Request := Request + '<trib:Consultarnfseporfaixarequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Consultarnfseporfaixarequest>';
  Request := Request + '</trib:nfse_web_service.CONSULTARNFSEFAIXA>';

  Result := Executar('Tributarioaction/ANFSE_WEB_SERVICE.CONSULTARNFSEFAIXA', Request,
                     ['Consultarnfseporfaixaresponse', 'outputXML', 'ConsultarNfseFaixaResposta'],
                     ['xmlns:trib="Tributario"', NameSpace]);
  {
    os campos <Codigo>, <Mensagem> e <Correcao> estão dentro do grupo:
       <ConsultarNfseFaixaResposta> em vez de <MensagemRetorno>
    Vai ser necessário estudar a melhor forma de resolver esse problema
  }
end;

function TACBrNFSeXWebserviceCoplan201.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web_service.CONSULTARNFSEPORRPS>';
  Request := Request + '<trib:Consultarnfseporrpsrequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Consultarnfseporrpsrequest>';
  Request := Request + '</trib:nfse_web_service.CONSULTARNFSEPORRPS>';

  Result := Executar('Tributarioaction/ANFSE_WEB_SERVICE.CONSULTARNFSEPORRPS', Request,
                     ['Consultarnfseporrpsresponse', 'outputXML', 'ConsultarNfseRpsResposta'],
                     ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplan201.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web_service.CONSULTARNFSESERVICOPRESTADO>';
  Request := Request + '<trib:Consultarnfseservicoprestadorequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Consultarnfseservicoprestadorequest>';
  Request := Request + '</trib:nfse_web_service.CONSULTARNFSESERVICOPRESTADO>';

  Result := Executar('Tributarioaction/ANFSE_WEB_SERVICE.CONSULTARNFSESERVICOPRESTADO', Request,
                     ['Consultarnfseservicoprestadoresponse', 'outputXML', 'ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplan201.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web_service.CONSULTARNFSESERVICOTOMADO>';
  Request := Request + '<trib:Consultarnfseservicotomadorequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Consultarnfseservicotomadorequest>';
  Request := Request + '</trib:nfse_web_service.CONSULTARNFSESERVICOTOMADO>';

  Result := Executar('Tributarioaction/ANFSE_WEB_SERVICE.CONSULTARNFSESERVICOTOMADO', Request,
                     ['Consultarnfseservicotomadoresponse', 'outputXML', 'ConsultarNfseServicoTomadoResposta'],
                     ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplan201.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web_service.CANCELARNFSE>';
  Request := Request + '<trib:Cancelarnfserequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Cancelarnfserequest>';
  Request := Request + '</trib:nfse_web_service.CANCELARNFSE>';

  Result := Executar('Tributarioaction/ANFSE_WEB_SERVICE.CANCELARNFSE', Request,
                     ['Cancelarnfseresponse', 'outputXML', 'CancelarNfseResposta'],
                     ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplan201.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web_service.SUBSTITUIRNFSE>';
  Request := Request + '<trib:Substituirnfserequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Substituirnfserequest>';
  Request := Request + '</trib:nfse_web_service.SUBSTITUIRNFSE>';

  Result := Executar('Tributarioaction/ANFSE_WEB_SERVICE.SUBSTITUIRNFSE', Request,
                     ['Substituirnfseresponse', 'outputXML', 'SubstituirNfseResposta'],
                     ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplan201.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverCDATA(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
end;

{ TACBrNFSeProviderCoplanAPIPropria }

procedure TACBrNFSeProviderCoplanAPIPropria.Configuracao;
var
  VersaoDFe: string;
begin
  inherited Configuracao;

  VersaoDFe := VersaoNFSeToStr(TACBrNFSeX(FAOwner).Configuracoes.Geral.Versao);

  with ConfigGeral do
  begin
    ServicosDisponibilizados.EnviarUnitario := True;
    ServicosDisponibilizados.EnviarLoteSincrono := True;
    ServicosDisponibilizados.ConsultarRps := True;
    Particularidades.AtendeReformaTributaria := True;
    ModoEnvio := meUnitario;
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
    GerarPrestadorLoteRps := True;
    DadosCabecalho := GetCabecalho('');

    XmlRps.InfElemento := 'infDPS';
    XmlRps.DocElemento := 'DPS';
    ConsultarNFSeRps.DocElemento := 'ConsultarNfseDpsEnvio';
    EnviarEvento.InfElemento := 'infPedReg';
    EnviarEvento.DocElemento := 'pedRegEvento';
    LoteRpsSincrono.InfElemento := 'LoteDps';
    LoteRpsSincrono.DocElemento := 'EnviarLoteDpsSincronoEnvio';
  end;

  with ConfigAssinar do
  begin
    RpsGerarNFSe := True;
    EnviarEvento := True;
    CancelarNFSe := True;
//    LoteRps := True;
//    LoteGerarNFSe := True;
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

function TACBrNFSeProviderCoplanAPIPropria.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_CoplanAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCoplanAPIPropria.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_CoplanAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCoplanAPIPropria.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceCoplanAPIPropria.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderCoplanAPIPropria.VerificarAlerta(const ACodigo,
  AMensagem, ACorrecao: string): Boolean;
begin
  Result := ((AMensagem <> '') or (ACorrecao <> '')) and (Pos('L000', ACodigo) > 0);
end;

function TACBrNFSeProviderCoplanAPIPropria.VerificarErro(const ACodigo,
  AMensagem, ACorrecao: string): Boolean;
begin
  Result := ((AMensagem <> '') or (ACorrecao <> '')) and (Pos('L000', ACodigo) = 0);
end;

procedure TACBrNFSeProviderCoplanAPIPropria.ProcessarMensagemErros(
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
        Mensagem := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Mensagem'), tcStr);

        ProcessarErro(ANodeArray[I], Codigo, Mensagem);
      end;
    end
    else
    begin
      Codigo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Codigo'), tcStr);
      Mensagem := ObterConteudoTag(ANode.Childrens.FindAnyNs('Mensagem'), tcStr);

      ProcessarErro(ANode, Codigo, Mensagem);
    end;
  end;
end;

begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if (ANode = nil) then
    ANode := RootNode.Childrens.FindAnyNs('MensagemRetorno');

  ProcessarErros;

  ANode := RootNode.Childrens.FindAnyNs('ListaMensagemRetornoLote');

  ProcessarErros;

  ANode := RootNode.Childrens.FindAnyNs('ListaMensagemAlertaRetorno');

  if Assigned(ANode) then
  begin
    ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

    if Assigned(ANodeArray) then
    begin
      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        Mensagem := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Mensagem'), tcStr);

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
      Mensagem := ObterConteudoTag(ANode.Childrens.FindAnyNs('Mensagem'), tcStr);

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

function TACBrNFSeProviderCoplanAPIPropria.PrepararRpsParaLote(
  const aXml: string): string;
var
  i: Integer;
  Prefixo: string;
begin
  i := Pos('>', aXml) + 1;

  if ConfigMsgDados.PrefixoTS = '' then
    Prefixo := ''
  else
    Prefixo := ConfigMsgDados.PrefixoTS + ':';

  Result := '<' + Prefixo + 'DPS>' + Copy(aXml, i, Length(aXml));
end;

procedure TACBrNFSeProviderCoplanAPIPropria.PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  aParams: TNFSeParamsResponse;
  Emitente: TEmitenteConfNFSe;
  InfoCanc: TInfCancelamento;
  IdAttr, NameSpace, NameSpaceCanc, xMotivo, xCodVerif, Prefixo, PrefixoTS,
  xSerie: string;
begin
  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.CodCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod109;
    AErro.Descricao := ACBrStr(Desc109);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  InfoCanc := Response.InfCancelamento;
  Prefixo := '';
  PrefixoTS := '';

  if EstaVazio(ConfigMsgDados.CancelarNFSe.xmlns) then
  begin
    NameSpace := '';
    NameSpaceCanc := '';
  end
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.CancelarNFSe.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.CancelarNFSe.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;

    NameSpaceCanc := NameSpace;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if (ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.CancelarNFSe.xmlns) and
       ((ConfigMsgDados.Prefixo <> '') or (ConfigMsgDados.PrefixoTS <> '')) then
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

  IdAttr := DefinirIDCancelamento(OnlyNumber(Emitente.CNPJ),
                                  OnlyNumber(Emitente.InscMun),
                                  InfoCanc.NumeroNFSe);

  if ConfigGeral.CancPreencherSerieNfse then
  begin
    if EstaVazio(InfoCanc.SerieNFSe) then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod112;
      AErro.Descricao := ACBrStr(Desc112);
      Exit;
    end;

    xSerie := '<' + PrefixoTS + 'Serie>' +
                 Trim(InfoCanc.SerieNFSe) +
               '</' + PrefixoTS + 'Serie>';
  end
  else
    xSerie := '';

  if ConfigGeral.CancPreencherMotivo then
  begin
    if EstaVazio(InfoCanc.MotCancelamento) then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod110;
      AErro.Descricao := ACBrStr(Desc110);
      Exit;
    end;

    xMotivo := '<' + Prefixo + 'MotivoCancelamento>' +
                 Trim(InfoCanc.MotCancelamento) +
               '</' + Prefixo + 'MotivoCancelamento>';
  end
  else
    xMotivo := '';

  if ConfigGeral.CancPreencherCodVerificacao then
  begin
    if EstaVazio(InfoCanc.CodVerificacao) then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod117;
      AErro.Descricao := ACBrStr(Desc117);
      Exit;
    end;

    xCodVerif := '<' + Prefixo + 'CodigoVerificacao>' +
                   Trim(InfoCanc.CodVerificacao) +
                 '</' + Prefixo + 'CodigoVerificacao>';
  end
  else
    xCodVerif := '';

  aParams := TNFSeParamsResponse.Create;
  try
    aParams.Clear;
    aParams.Xml := '';
    aParams.TagEnvio := '';
    aParams.Prefixo := Prefixo;
    aParams.Prefixo2 := PrefixoTS;
    aParams.NameSpace := NameSpace;
    aParams.NameSpace2 := NameSpaceCanc;
    aParams.IdAttr := IdAttr;
    aParams.Versao := '';
    aParams.Serie := xSerie;
    aParams.Motivo := xMotivo;
    aParams.CodigoVerificacao := xCodVerif;

    GerarMsgDadosCancelaNFSe(Response, aParams);
  finally
    aParams.Free;
  end;
end;

procedure TACBrNFSeProviderCoplanAPIPropria.PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  aParams: TNFSeParamsResponse;
  NameSpace, TagEnvio, Prefixo, PrefixoTS: string;
begin
  if EstaVazio(Response.NumeroRps) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod102;
    AErro.Descricao := ACBrStr(Desc102);
    Exit;
  end;

  Prefixo := '';
  PrefixoTS := '';

  if EstaVazio(ConfigMsgDados.ConsultarNFSeRps.xmlns) then
    NameSpace := ''
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.ConsultarNFSeRps.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.ConsultarNFSeRps.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if (ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.ConsultarNFSeRps.xmlns) and
       ((ConfigMsgDados.Prefixo <> '') or (ConfigMsgDados.PrefixoTS <> '')) then
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

  TagEnvio := ConfigMsgDados.ConsultarNFSeRps.DocElemento;

  aParams := TNFSeParamsResponse.Create;
  try
    aParams.Clear;
    aParams.Xml := '';
    aParams.TagEnvio := TagEnvio;
    aParams.Prefixo := Prefixo;
    aParams.Prefixo2 := PrefixoTS;
    aParams.NameSpace := NameSpace;
    aParams.NameSpace2 := '';
    aParams.IdAttr := '';
    aParams.Versao := '';

    GerarMsgDadosConsultaporRps(Response, aParams);
  finally
    aParams.Free;
  end;
end;

procedure TACBrNFSeProviderCoplanAPIPropria.PrepararEmitir(
  Response: TNFSeEmiteResponse);
var
  AErro: TNFSeEventoCollectionItem;
  aParams: TNFSeParamsResponse;
  Nota: TNotaFiscal;
  Versao, IdAttr, NameSpace, NameSpaceLote, ListaRps, xRps, IdAttrSig,
  TagEnvio, Prefixo, PrefixoTS: string;
  I: Integer;
begin
  if EstaVazio(Response.NumeroLote) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod111;
    AErro.Descricao := ACBrStr(Desc111);
  end;

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
    AErro.Descricao := ACBrStr('Conjunto de RPS transmitidos (máximo de ' +
                       IntToStr(Response.MaxRps) + ' RPS)' +
                       ' excedido. Quantidade atual: ' +
                       IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count));
  end;

  if (TACBrNFSeX(FAOwner).NotasFiscais.Count < Response.MinRps) and
     (Response.ModoEnvio <> meUnitario) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod005;
    AErro.Descricao := ACBrStr('Conjunto de RPS transmitidos (mínimo de ' +
                       IntToStr(Response.MinRps) + ' RPS)' +
                       '. Quantidade atual: ' +
                       IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count));
  end;

  if Response.Erros.Count > 0 then Exit;

  ListaRps := '';
  Prefixo := '';
  PrefixoTS := '';

  case Response.ModoEnvio of
    meLoteSincrono:
    begin
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
    end;

    meUnitario:
    begin
      TagEnvio := ConfigMsgDados.GerarNFSe.DocElemento;

      if EstaVazio(ConfigMsgDados.GerarNFSe.xmlns) then
        NameSpace := ''
      else
      begin
        if ConfigMsgDados.Prefixo = '' then
          NameSpace := ' xmlns="' + ConfigMsgDados.GerarNFSe.xmlns + '"'
        else
        begin
          NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' +
                                   ConfigMsgDados.GerarNFSe.xmlns + '"';
          Prefixo := ConfigMsgDados.Prefixo + ':';
        end;
      end;
    end;
  else
    begin
      TagEnvio := ConfigMsgDados.LoteRps.DocElemento;

      if EstaVazio(ConfigMsgDados.LoteRps.xmlns) then
        NameSpace := ''
      else
      begin
        if ConfigMsgDados.Prefixo = '' then
          NameSpace := ' xmlns="' + ConfigMsgDados.LoteRps.xmlns + '"'
        else
        begin
          NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' +
                                   ConfigMsgDados.LoteRps.xmlns + '"';
          Prefixo := ConfigMsgDados.Prefixo + ':';
        end;
      end;
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if (ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.LoteRps.xmlns) and
       ((ConfigMsgDados.Prefixo <> '') or (ConfigMsgDados.PrefixoTS <> '')) then
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

    if (ConfigAssinar.Rps and (Response.ModoEnvio in [meLoteAssincrono, meLoteSincrono, meTeste])) or
       (ConfigAssinar.RpsGerarNFSe and (Response.ModoEnvio = meUnitario)) then
    begin
      IdAttrSig := SetIdSignatureValue(Nota.XmlRps,
                                     ConfigMsgDados.XmlRps.DocElemento, IdAttr);

      Nota.XmlRps := FAOwner.SSL.Assinar(Nota.XmlRps,
                                         PrefixoTS + ConfigMsgDados.XmlRps.DocElemento,
                                         ConfigMsgDados.XmlRps.InfElemento, '', '', '',
                                         IdAttr, IdAttrSig);
    end;

    SalvarXmlRps(Nota);

    xRps := RemoverDeclaracaoXML(Nota.XmlRps);
    xRps := PrepararRpsParaLote(xRps);

    ListaRps := ListaRps + xRps;
  end;

  if ConfigMsgDados.GerarNSLoteRps then
    NameSpaceLote := NameSpace
  else
    NameSpaceLote := '';

  if ConfigWebServices.AtribVerLote <> '' then
    Versao := ' ' + ConfigWebServices.AtribVerLote + '="' +
              ConfigWebServices.VersaoDados + '"'
  else
    Versao := '';

  IdAttr := DefinirIDLote(Response.NumeroLote);

  ListaRps := ChangeLineBreak(ListaRps, '');

  aParams := TNFSeParamsResponse.Create;
  try
    aParams.Clear;
    aParams.Xml := ListaRps;
    aParams.TagEnvio := TagEnvio;
    aParams.Prefixo := Prefixo;
    aParams.Prefixo2 := PrefixoTS;
    aParams.NameSpace := NameSpace;
    aParams.NameSpace2 := NameSpaceLote;
    aParams.IdAttr := IdAttr;
    aParams.Versao := Versao;

    GerarMsgDadosEmitir(Response, aParams);
  finally
    aParams.Free;
  end;
end;

procedure TACBrNFSeProviderCoplanAPIPropria.GerarMsgDadosEmitir(Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
  Prestador: string;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  with Params do
  begin
    if Response.ModoEnvio in [meLoteAssincrono, meLoteSincrono, meTeste] then
    begin
      if ConfigMsgDados.GerarPrestadorLoteRps then
      begin
        Prestador := '<' + Prefixo2 + 'Prestador>' +
                       '<' + Prefixo2 + 'CpfCnpj>' +
                         GetCpfCnpj(Emitente.CNPJ, Prefixo2) +
                       '</' + Prefixo2 + 'CpfCnpj>' +
                       GetInscMunic(Emitente.InscMun, Prefixo2) +
                     '</' + Prefixo2 + 'Prestador>'
      end
      else
        Prestador := '<' + Prefixo2 + 'CpfCnpj>' +
                       GetCpfCnpj(Emitente.CNPJ, Prefixo2) +
                     '</' + Prefixo2 + 'CpfCnpj>' +
                     GetInscMunic(Emitente.InscMun, Prefixo2);

      Response.ArquivoEnvio := '<' + Prefixo + TagEnvio + NameSpace + ' xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">' +
                                 '<' + Prefixo + 'LoteDps' + NameSpace2 + IdAttr + Versao + '>' +
                                   '<' + Prefixo2 + 'NumeroLote>' +
                                     Response.NumeroLote +
                                   '</' + Prefixo2 + 'NumeroLote>' +
                                   Prestador +
                                   '<' + Prefixo2 + 'QuantidadeDps>' +
                                     IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count) +
                                   '</' + Prefixo2 + 'QuantidadeDps>' +
                                   '<' + Prefixo2 + 'ListaDps>' +
                                     Xml +
                                   '</' + Prefixo2 + 'ListaDps>' +
                                 '</' + Prefixo + 'LoteDps>' +
                               '</' + Prefixo + TagEnvio + '>';
    end
    else
      Response.ArquivoEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                                 Xml +
                                '</' + Prefixo + TagEnvio + '>';
  end;
end;

procedure TACBrNFSeProviderCoplanAPIPropria.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
var
  NumNFSe, CodVerif, NumRps, SerieRps: string;
  DataAut: TDateTime;
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  AResumo: TNFSeResumoCollectionItem;
  ANode, AuxNode, AuxNode2: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  ANota: TNotaFiscal;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;
  NumRps := '';

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

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      with Response do
      begin
        Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataRecebimento'), tcDat);
        Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Protocolo'), tcStr);
      end;

      if Response.ModoEnvio in [meLoteSincrono, meUnitario] then
      begin
        // Retorno do EnviarLoteRpsSincrono e GerarNfse
        ANode := ANode.Childrens.FindAnyNs('ListaNfse');

        if not Assigned(ANode) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod202;
          AErro.Descricao := ACBrStr(Desc202);
          Exit;
        end;

        ProcessarMensagemErros(ANode, Response);

        ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');

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
          AuxNode := ANode.Childrens.FindAnyNs('Nfse');
          if not Assigned(AuxNode) then Exit;

          AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');

          NumNFSe := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
          CodVerif := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CodigoVerificacao'), tcStr);
          DataAut := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('DataEmissao'), tcDat);

          with Response do
          begin
            NumeroNota := NumNFSe;
            CodigoVerificacao := CodVerif;
            Data := DataAut;
          end;

          AuxNode2 := AuxNode.Childrens.FindAnyNs('DeclaracaoPrestacaoServico');

          // Tem provedor que mudou a tag de <DeclaracaoPrestacaoServico>
          // para <Rps>
          if AuxNode2 = nil then
            AuxNode2 := AuxNode.Childrens.FindAnyNs('Rps');
          if not Assigned(AuxNode2) then Exit;

          AuxNode := AuxNode2.Childrens.FindAnyNs('InfDeclaracaoPrestacaoServico');
          if not Assigned(AuxNode) then Exit;

          AuxNode := AuxNode.Childrens.FindAnyNs('Rps');

          if AuxNode <> nil then
          begin
            AuxNode := AuxNode.Childrens.FindAnyNs('IdentificacaoRps');
            if not Assigned(AuxNode) then Exit;

            NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
            SerieRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Serie'), tcStr);
          end;

          if NumRps <> '' then
            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps)
          else
            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(Response.NumeroNota);

          AResumo := Response.Resumos.New;
          AResumo.NumeroNota := NumNFSe;
          AResumo.CodigoVerificacao := CodVerif;
          AResumo.NumeroRps := NumRps;
          AResumo.SerieRps := SerieRps;

          ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
          SalvarXmlNfse(ANota);

          AResumo.NomeArq := ANota.NomeArq;
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

procedure TACBrNFSeProviderCoplanAPIPropria.GerarMsgDadosConsultaporRps(Response: TNFSeConsultaNFSeporRpsResponse;
  Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
  Prestador: string;
  AWriter: TNFSeWClass;

  function GerarChaveDPS: string;
  var
    cMun, vSerie, vNumero, vCNPJ, tpInsc: string;
  begin
    {
    A regra de formação do identificador de 45 posições da DPS é:
    "DPS" + Cód.Mun (7) + Tipo de Inscrição Federal (1) +
    Inscrição Federal (14 - CPF completar com 000 à esquerda) + Série DPS (5)+ Núm. DPS (15)
    }
    cMun := Poem_Zeros(Emitente.DadosEmitente.CodigoMunicipio, 7);
    vCNPJ := OnlyNumber(Emitente.CNPJ);

    if Length(vCNPJ) = 11 then
	    tpInsc := '1'
    else
      tpInsc := '2';

    vCNPJ := PadLeft(vCNPJ, 14, '0');
    vSerie := Poem_Zeros(Response.SerieRps, 5);
    vNumero := Poem_Zeros(Response.NumeroRps, 15);

    Result := 'DPS' + cMun + tpInsc + vCNPJ + vSerie + vNumero;
  end;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  with Params do
  begin
    Prestador := '<' + Prefixo + 'Prestador>' +
                   '<' + Prefixo2 + 'CpfCnpj>' +
                     GetCpfCnpj(Emitente.CNPJ, Prefixo2) +
                   '</' + Prefixo2 + 'CpfCnpj>' +
                 GetInscMunic(Emitente.InscMun, Prefixo2) +
                 '</' + Prefixo + 'Prestador>';

    Response.ArquivoEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                               '<' + Prefixo + 'IdentificacaoDPS>' +
                                 GerarChaveDPS +
                               '</' + Prefixo + 'IdentificacaoDPS>' +
                               Prestador +
                             '</' + Prefixo + TagEnvio + '>';
  end;
end;

procedure TACBrNFSeProviderCoplanAPIPropria.TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  Ret: TRetCancelamento;
  IdAttr, xCancelamento, xXMLNS, nomeArq: string;
  AErro: TNFSeEventoCollectionItem;
  Inicio, Fim: Integer;
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

      ANode := Document.Root.Childrens.FindAnyNs('RetCancelamento');

      if ANode = nil then
        ANode := Document.Root.Childrens.FindAnyNs('RetornoCancelamento');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod209;
        AErro.Descricao := ACBrStr(Desc209);
        Exit;
      end;

      ProcessarMensagemErros(ANode, Response);

      ANode := ANode.Childrens.FindAnyNs('NfseCancelamento');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod210;
        AErro.Descricao := ACBrStr(Desc210);
        Exit;
      end;

      AuxNode := ANode.Childrens.FindAnyNs('Confirmacao');

      if AuxNode = nil then
        AuxNode := ANode.Childrens.FindAnyNs('ConfirmacaoCancelamento');

      if AuxNode <> nil then
        ANode := AuxNode;

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod204;
        AErro.Descricao := ACBrStr(Desc204);
        Exit;
      end;

      Ret := Response.RetCancelamento;
      Ret.DataHora := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataHora'), tcDatHor);

      if ConfigAssinar.IncluirURI then
        IdAttr := ConfigGeral.Identificador
      else
        IdAttr := 'ID';

      AuxNode := ANode.Childrens.FindAnyNs('Pedido');

      if AuxNode = nil then
        AuxNode := ANode.Childrens.FindAnyNs('PedidoCancelamento');

      if AuxNode <> nil then
        ANode := AuxNode;

      ANode := ANode.Childrens.FindAnyNs('InfPedidoCancelamento');
      if not Assigned(ANode) then Exit;

      Ret.Pedido.InfID.ID := ObterConteudoTag(ANode.Attributes.Items[IdAttr]);
      Ret.Pedido.CodigoCancelamento := ObterConteudoTag(ANode.Childrens.FindAnyNs('CodigoCancelamento'), tcStr);

      ANode := ANode.Childrens.FindAnyNs('IdentificacaoNfse');
      if not Assigned(ANode) then Exit;

      with Ret.Pedido.IdentificacaoNfse do
      begin
        Numero := ObterConteudoTag(ANode.Childrens.FindAnyNs('Numero'), tcStr);

        AuxNode := ANode.Childrens.FindAnyNs('CpfCnpj');

        if AuxNode <> nil then
        begin
          Cnpj := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Cnpj'), tcStr);

          if Cnpj = '' then
            Cnpj := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Cpf'), tcStr);
        end
        else
          Cnpj := ObterConteudoTag(ANode.Childrens.FindAnyNs('Cnpj'), tcStr);

        InscricaoMunicipal := ObterConteudoTag(ANode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
        CodigoMunicipio := ObterConteudoTag(ANode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);
      end;

      if Ret.DataHora > 0 then
      begin
        Ret.Sucesso := 'Sim';
        Ret.Situacao := 'Cancelado';

        Inicio := Pos('CancelarNfseEnvio', Response.ArquivoEnvio) + 16;
        Fim := Pos('>', Response.ArquivoEnvio);

        if Inicio = Fim then
          xXMLNS := ''
        else
          xXMLNS := trim(Copy(Response.ArquivoEnvio, Inicio + 1, Fim - (Inicio + 1)));

        xCancelamento := '<Cancelamento ' + xXMLNS + '>' +
                            SeparaDados(Response.ArquivoEnvio, 'Pedido', True) +
                            SepararDados(Response.ArquivoRetorno, 'DataHora', True) +
                         '</Cancelamento>';

        nomeArq := '';
        SalvarXmlCancelamento(Ret.Pedido.InfID.ID + '-procCancNFSe', xCancelamento, nomeArq);
        Response.PathNome := nomeArq;
      end
      else
      begin
        Ret.Sucesso := '';
        Ret.Situacao := '';
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

procedure TACBrNFSeProviderCoplanAPIPropria.TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  AErro: TNFSeEventoCollectionItem;
  ANota: TNotaFiscal;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := ACBrStr(Desc201);
    Exit
  end;

  Document := TACBrXmlDocument.Create;
  try
    try
      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root.Childrens.FindAnyNs('CompNfse');
      if ANode <> nil then
      begin
        ANode := ANode.Childrens.FindAnyNs('NFSe');
        AuxNode := ANode.Childrens.FindAnyNs('infNFSe');

        Response.CodigoVerificacao := OnlyNumber(ObterConteudoTag(AuxNode.Attributes.Items['Id']));
        Response.NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nNFSe'), tcStr);
        Response.Data := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhProc'), tcDatHor);

        AuxNode := AuxNode.Childrens.FindAnyNs('DPS');
        AuxNode := AuxNode.Childrens.FindAnyNs('infDPS');
        Response.NumeroRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nDPS'), tcStr);

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(Response.NumeroRps);

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

procedure TACBrNFSeProviderCoplanAPIPropria.GerarMsgDadosCancelaNFSe(Response: TNFSeCancelaNFSeResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
  InfoCanc: TInfCancelamento;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  InfoCanc := Response.InfCancelamento;

  with Params do
  begin
    Response.ArquivoEnvio := '<' + Prefixo + 'CancelarNfseEnvio' + NameSpace + '>' +
                               '<' + Prefixo2 + 'Pedido>' +
                                 '<' + Prefixo2 + 'InfPedidoCancelamento' + IdAttr + NameSpace2 + '>' +
                                   '<' + Prefixo2 + 'IdentificacaoNfse>' +
                                     '<' + Prefixo2 + 'Numero>' +
                                       InfoCanc.NumeroNFSe +
                                     '</' + Prefixo2 + 'Numero>' +
                                     '<' + Prefixo2 + 'CpfCnpj>' +
                                       GetCpfCnpj(Emitente.CNPJ, Prefixo2) +
                                     '</' + Prefixo2 + 'CpfCnpj>' +
                                     GetInscMunic(Emitente.InscMun, Prefixo2) +
                                     '<' + Prefixo2 + 'CodigoMunicipio>' +
                                       IntToStr(InfoCanc.CodMunicipio) +
                                     '</' + Prefixo2 + 'CodigoMunicipio>' +
                                   '</' + Prefixo2 + 'IdentificacaoNfse>' +
                                   '<' + Prefixo2 + 'CodigoCancelamento>' +
                                     InfoCanc.CodCancelamento +
                                   '</' + Prefixo2 + 'CodigoCancelamento>' +
                                 '</' + Prefixo2 + 'InfPedidoCancelamento>' +
                               '</' + Prefixo2 + 'Pedido>' +
                             '</' + Prefixo + 'CancelarNfseEnvio>';
  end;
end;

{ TACBrNFSeXWebserviceCoplanAPIPropria }

function TACBrNFSeXWebserviceCoplanAPIPropria.Cancelar(const ACabecalho, AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_ws.CANCELARNFSE>';
  Request := Request + '<trib:Cancelarnfserequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Cancelarnfserequest>';
  Request := Request + '</trib:nfse_ws.CANCELARNFSE>';

  Result := Executar('Tributarioaction/ANFSE_WEB.CANCELARNFSE', Request,
    ['Cancelarnfseresponse', 'outputXML', 'CancelarNfseResposta'],
    ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplanAPIPropria.ConsultarNFSePorRps(const ACabecalho, AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_ws.CONSULTARNFSEPORDPS>';
  Request := Request + '<trib:Consultarnfsepordpsrequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) +
    '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Consultarnfsepordpsrequest>';
  Request := Request + '</trib:nfse_ws.CONSULTARNFSEPORDPS>';

  Result := Executar('Tributarioaction/ANFSE_WS.CONSULTARNFSEPORDPS', Request,
    ['Consultarnfsepordpsresponse', 'outputXML', 'ConsultarNfseRpsResposta'],
    ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplanAPIPropria.GerarNFSe(const ACabecalho, AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web.GERARNFSE>';
  Request := Request + '<trib:Gerarnfserequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Gerarnfserequest>';
  Request := Request + '</trib:nfse_web.GERARNFSE>';

  Result := Executar('Tributarioaction/ANFSE_WEB.GERARNFSE', Request,
    ['Gerarnfseresponse', 'outputXML', 'GerarNfseResposta'],
    ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplanAPIPropria.GetNamespace: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
    Result := 'Tributario_PRODUCAO_FULL'
  else
    Result := 'TributarioGx16New';

  Result := 'xmlns:trib1="' + Result + '"';
end;

function TACBrNFSeXWebserviceCoplanAPIPropria.RecepcionarSincrono(const ACabecalho, AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<trib:nfse_web.RECEPCIONARLOTEDPSSINCRONO>';
  Request := Request + '<trib:Recepcionarlotedpssincronorequest>';
  Request := Request + '<trib1:nfseCabecMsg>' + IncluirCDATA(ACabecalho) + '</trib1:nfseCabecMsg>';
  Request := Request + '<trib1:nfseDadosMsg>' + IncluirCDATA(AMSG) + '</trib1:nfseDadosMsg>';
  Request := Request + '</trib:Recepcionarlotedpssincronorequest>';
  Request := Request + '</trib:nfse_web.RECEPCIONARLOTEDPSSINCRONO>';

  Result := Executar('Tributarioaction/ANFSE_WEB.RECEPCIONARLOTEDPSSINCRONO', Request,
    ['Recepcionarlotedpssincronoresponse', 'outputXML', 'EnviarLoteDpsSincronoResposta'],
    ['xmlns:trib="Tributario"', NameSpace]);
end;

function TACBrNFSeXWebserviceCoplanAPIPropria.TratarXmlRetornado(const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := RemoverDeclaracaoXML(Result, True);
  Result := RemoverCDATA(Result);
  Result := FaststringReplace(Result, 'GX_KB_Tributario_Tributario', '', [rfReplaceAll]);
end;

end.
