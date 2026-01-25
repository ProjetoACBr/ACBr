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

unit Fiorilli.Provider;

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
  PadraoNacional.Provider;

type
  TACBrNFSeXWebserviceFiorilli200 = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetDadosUsuario: string;
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

    property DadosUsuario: string read GetDadosUsuario;
  end;

  TACBrNFSeProviderFiorilli200 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
  end;

  TACBrNFSeXWebserviceFiorilliAPIPropria = class(TACBrNFSeXWebserviceSoap11)
  protected

  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(const ACabecalho, AMSG: String): string; override;
    function GerarNFSe(const ACabecalho, AMSG: string): string; override;
    {
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function EnviarEvento(const ACabecalho, AMSG: string): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: string): string; override;
    function ConsultarNFSePorChave(const ACabecalho, AMSG: string): string; override;
    function ConsultarEvento(const ACabecalho, AMSG: string): string; override;
    function ConsultarDFe(const ACabecalho, AMSG: string): string; override;
    function ConsultarParam(const ACabecalho, AMSG: string): string; override;
    function ObterDANFSE(const ACabecalho, AMSG: string): string; override;
    }

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderFiorilliAPIPropria = class(TACBrNFSeProviderPadraoNacional)
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
                                     const AListTag: string = 'ListaMensagens';
                                     const AMessageTag: string = 'Mensagem'); override;

    function PrepararArquivoEnvio(const aXml: string; aMetodo: TMetodo): string; override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;
    {

    procedure PrepararConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;
    procedure TratarRetornoConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;

    procedure PrepararEnviarEvento(Response: TNFSeEnviarEventoResponse); override;
    procedure TratarRetornoEnviarEvento(Response: TNFSeEnviarEventoResponse); override;
    }
  public

  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrNFSeXConsts,
  ACBrDFeException,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  ACBrNFSeX,
  ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais,
  Fiorilli.GravarXml,
  Fiorilli.LerXml;

{ TACBrNFSeProviderFiorilli200 }

procedure TACBrNFSeProviderFiorilli200.Configuracao;
var
  NaoAssinar: Boolean;
begin
  inherited Configuracao;

  ConfigGeral.QuebradeLinha := '\s\n';
  ConfigGeral.ConsultaPorFaixaPreencherNumNfseFinal := true;

  ConfigGeral.Autenticacao.RequerLogin := True;

  NaoAssinar := ConfigGeral.Params.ParamTemValor('Assinar', 'NaoAssinar');

  if (ConfigAssinar.Assinaturas = taConfigProvedor) and not NaoAssinar then
  begin
    with ConfigAssinar do
    begin
      Rps := True;
      LoteRps := True;
      CancelarNFSe := True;
      RpsGerarNFSe := True;
      RpsSubstituirNFSe := True;
      SubstituirNFSe := True;
    end;
  end;
end;

function TACBrNFSeProviderFiorilli200.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Fiorilli200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderFiorilli200.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Fiorilli200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderFiorilli200.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceFiorilli200.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderFiorilli200.PrepararEmitir(
  Response: TNFSeEmiteResponse);
begin
  // O provedor Fiorilli exige que o numero do lote seja numerico e que não
  // não tenha zeros a esquerda.
  Response.NumeroLote := IntToStr(StrToIntDef(Trim(Response.NumeroLote), 0));

  inherited PrepararEmitir(Response);
end;

{ TACBrNFSeXWebserviceFiorilli200 }

function TACBrNFSeXWebserviceFiorilli200.GetDadosUsuario: string;
begin
  with TACBrNFSeX(FPDFeOwner).Configuracoes.Geral do
  begin
    Result := '<username>' + Emitente.WSUser + '</username>' +
              '<password>' + Emitente.WSSenha + '</password>';
  end;
end;

function TACBrNFSeXWebserviceFiorilli200.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:recepcionarLoteRps>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</ws:recepcionarLoteRps>';

  Result := Executar('recepcionarLoteRps', Request,
                     ['EnviarLoteRpsResposta'],
                     ['xmlns:ws="http://ws.issweb.fiorilli.com.br/"']);
end;

function TACBrNFSeXWebserviceFiorilli200.RecepcionarSincrono(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:recepcionarLoteRpsSincrono>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</ws:recepcionarLoteRpsSincrono>';

  Result := Executar('recepcionarLoteRpsSincrono', Request,
                     ['EnviarLoteRpsSincronoResposta'],
                     ['xmlns:ws="http://ws.issweb.fiorilli.com.br/"']);
end;

function TACBrNFSeXWebserviceFiorilli200.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:gerarNfse>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</ws:gerarNfse>';

  Result := Executar('gerarNfse', Request,
                     ['GerarNfseResposta'],
                     ['xmlns:ws="http://ws.issweb.fiorilli.com.br/"']);
end;

function TACBrNFSeXWebserviceFiorilli200.ConsultarLote(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:consultarLoteRps>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</ws:consultarLoteRps>';

  Result := Executar('consultarLoteRps', Request,
                     ['ConsultarLoteRpsResposta'],
                     ['xmlns:ws="http://ws.issweb.fiorilli.com.br/"']);
end;

function TACBrNFSeXWebserviceFiorilli200.ConsultarNFSePorFaixa(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:consultarNfsePorFaixa>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</ws:consultarNfsePorFaixa>';

  Result := Executar('consultarNfsePorFaixa', Request,
                     ['ConsultarNfseFaixaResposta'],
                     ['xmlns:ws="http://ws.issweb.fiorilli.com.br/"']);
end;

function TACBrNFSeXWebserviceFiorilli200.ConsultarNFSePorRps(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:consultarNfsePorRps>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</ws:consultarNfsePorRps>';

  Result := Executar('consultarNfsePorRps', Request,
                     ['ConsultarNfseRpsResposta'],
                     ['xmlns:ws="http://ws.issweb.fiorilli.com.br/"']);
end;

function TACBrNFSeXWebserviceFiorilli200.ConsultarNFSeServicoPrestado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:consultarNfseServicoPrestado>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</ws:consultarNfseServicoPrestado>';

  Result := Executar('consultarNfseServicoPrestado', Request,
                     ['ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns:ws="http://ws.issweb.fiorilli.com.br/"']);
end;

function TACBrNFSeXWebserviceFiorilli200.ConsultarNFSeServicoTomado(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:consultarNfseServicoTomado>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</ws:consultarNfseServicoTomado>';

  Result := Executar('consultarNfseServicoTomado', Request,
                     ['ConsultarNfseServicoTomadoResposta'],
                     ['xmlns:ws="http://ws.issweb.fiorilli.com.br/"']);
end;

function TACBrNFSeXWebserviceFiorilli200.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:cancelarNfse>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</ws:cancelarNfse>';

  Result := Executar('cancelarNfse', Request,
                     ['CancelarNfseResposta'],
                     ['xmlns:ws="http://ws.issweb.fiorilli.com.br/"']);
end;

function TACBrNFSeXWebserviceFiorilli200.SubstituirNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:substituirNfse>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</ws:substituirNfse>';

  Result := Executar('substituirNfse', Request,
                     ['SubstituirNfseResposta'],
                     ['xmlns:ws="http://ws.issweb.fiorilli.com.br/"']);
end;

function TACBrNFSeXWebserviceFiorilli200.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := ConverteANSItoUTF8(aXml);
  Result := RemoverDeclaracaoXML(Result);

  Result := inherited TratarXmlRetornado(Result);

  Result := StringReplace(Result, '&#xd;\s\n', '\s\n', [rfReplaceAll]);
  Result := StringReplace(Result, '&#xd;', '\s\n', [rfReplaceAll]);
  Result := StringReplace(Result, ''#$A'', '\s\n', [rfReplaceAll]);
  Result := ParseText(Result);
  Result := RemoverPrefixosDesnecessarios(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll]);
end;

{ TACBrNFSeProviderFiorilliAPIPropria }

procedure TACBrNFSeProviderFiorilliAPIPropria.Configuracao;
var
  VersaoDFe: string;
begin
  inherited Configuracao;

  VersaoDFe := VersaoNFSeToStr(TACBrNFSeX(FAOwner).Configuracoes.Geral.Versao);

  with ConfigGeral do
  begin
    Layout := loPadraoNacional;
    QuebradeLinha := '|';
    ModoEnvio := meUnitario;
    ConsultaLote := False;
    FormatoArqEnvio := tfaXml;
    FormatoArqRetorno := tfaXml;
    FormatoArqEnvioSoap := tfaXml;
    FormatoArqRetornoSoap := tfaXml;

    ServicosDisponibilizados.EnviarUnitario := True;
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

  SetXmlNameSpace('http://www.fiorilli.com.br/nfse-nacional');

  with ConfigMsgDados do
  begin
    Prefixo := 'nfse1';

    UsarNumLoteConsLote := False;

    DadosCabecalho := GetCabecalho('');

    XmlRps.InfElemento := 'infDPS';
    XmlRps.DocElemento := 'DPS';
    xmlRps.xmlns := 'http://www.sped.fazenda.gov.br/nfse';

    EnviarEvento.InfElemento := 'infPedReg';
    EnviarEvento.DocElemento := 'pedRegEvento';
  end;

  with ConfigAssinar do
  begin
    Rps := True;
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

function TACBrNFSeProviderFiorilliAPIPropria.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_FiorilliAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderFiorilliAPIPropria.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_FiorilliAPIPropria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderFiorilliAPIPropria.CriarServiceClient(
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

    Result := TACBrNFSeXWebserviceFiorilliAPIPropria.Create(FAOwner, AMetodo, URL,
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

function TACBrNFSeProviderFiorilliAPIPropria.VerificarAlerta(
  const ACodigo, AMensagem, ACorrecao: string): Boolean;
begin
  Result := ((AMensagem <> '') or (ACorrecao <> '')) and (Pos('L000', ACodigo) > 0);
end;

function TACBrNFSeProviderFiorilliAPIPropria.VerificarErro(const ACodigo,
  AMensagem, ACorrecao: string): Boolean;
begin
  Result := ((AMensagem <> '') or (ACorrecao <> '')) and (Pos('L000', ACodigo) = 0);
end;

procedure TACBrNFSeProviderFiorilliAPIPropria.ProcessarMensagemErros(
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
  Correcao := Correcao + ' ' + ObterConteudoTag(ErrorNode.Childrens.FindAnyNs('IdDPS'), tcStr);

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

function TACBrNFSeProviderFiorilliAPIPropria.PrepararArquivoEnvio(
  const aXml: string; aMetodo: TMetodo): string;
begin
  if aMetodo in [tmGerar, tmEnviarEvento] then
    Result := ChangeLineBreak(aXml, '');
end;

procedure TACBrNFSeProviderFiorilliAPIPropria.PrepararEmitir(
  Response: TNFSeEmiteResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Nota: TNotaFiscal;
  IdAttr, ListaDps: string;
  I: Integer;
  Emitente: TEmitenteConfNFSe;
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
       (ConfigAssinar.RpsGerarNFSe and (Response.ModoEnvio in [meUnitario, meAutomatico])) then
    begin
      Nota.XmlRps := FAOwner.SSL.Assinar(Nota.XmlRps,
                               'nfse:' + ConfigMsgDados.XmlRps.DocElemento,
                              ConfigMsgDados.XmlRps.InfElemento, '', '', '',
                              IdAttr);

      Response.ArquivoEnvio := Nota.XmlRps;
    end;

    SalvarXmlRps(Nota);

    ListaDps := ListaDps + Nota.XmlRps;
  end;

  if Response.ModoEnvio = meUnitario then
  begin
    Response.ArquivoEnvio := ListaDps;
  end
  else
  begin
    Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

    Response.ArquivoEnvio :=
      '<nfse:LoteDps xmlns:nfse="http://www.fiorilli.com.br/nfse-nacional">' +
        '<nfse:NumeroLote>' + Response.NumeroLote + '</nfse:NumeroLote>' +
        '<nfse:CNPJ>' + Emitente.CNPJ + '</nfse:CNPJ>' +
        '<nfse:IM>' + Emitente.InscMun + '</nfse:IM>' +
        '<nfse:QuantidadeDps>' +
           IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count) +
        '</nfse:QuantidadeDps>' +
        '<nfse:ListaDps>' + ListaDps + '</nfse:ListaDps>' +
       '</nfse:LoteDps>';
  end;

  Path := '';
  Method := 'POST';
end;

procedure TACBrNFSeProviderFiorilliAPIPropria.TratarRetornoEmitir(
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

      Response.Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataRecebimento'), tcDatHor);
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('protocolo'), tcStr);
      Response.Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('Status'), tcStr);

//      Implementar a leitura do elemento NFSe
      {
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
      }
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

{ TACBrNFSeXWebserviceFiorilliAPIPropria }

function TACBrNFSeXWebserviceFiorilliAPIPropria.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMSgOrig := RemoverDeclaracaoXML(AMSG);

  Request := '<nfse:RecepcionarLoteDpsEnvio>' +
                FPMsgOrig +
             '</nfse:RecepcionarLoteDpsEnvio>';

  Result := Executar('recepcionarLoteDps',
    Request, [], ['xmlns:nfse="http://www.fiorilli.com.br/nfse-nacional"',
    'xmlns:nfse1="http://www.sped.fazenda.gov.br/nfse"']);
end;

function TACBrNFSeXWebserviceFiorilliAPIPropria.RecepcionarSincrono(
  const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMSgOrig := RemoverDeclaracaoXML(AMSG);

  Request := '<nfse:RecepcionarLoteDpsSincronoEnvio>' +
                FPMsgOrig +
             '</nfse:RecepcionarLoteDpsSincronoEnvio>';

  Result := Executar('recepcionarLoteDpsSincrono',
    Request, [], ['xmlns:nfse="http://www.fiorilli.com.br/nfse-nacional"',
    'xmlns:nfse1="http://www.sped.fazenda.gov.br/nfse"']);
end;

function TACBrNFSeXWebserviceFiorilliAPIPropria.GerarNFSe(const ACabecalho,
  AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := RemoverDeclaracaoXML(AMSG);

  Request := '<nfse:RecepcionarDpsEnvio>' +
                Request +
             '</nfse:RecepcionarDpsEnvio>';

  Result := Executar('recepcionarDPS',
    Request, [], ['xmlns:nfse="http://www.fiorilli.com.br/nfse-nacional"',
    'xmlns:nfse1="http://www.sped.fazenda.gov.br/nfse"']);
end;

function TACBrNFSeXWebserviceFiorilliAPIPropria.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := ConverteANSItoUTF8(aXML);

  Result := inherited TratarXmlRetornado(Result);

  Result := RemoverCaracteresDesnecessarios(Result);
  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverIdentacao(Result);
  Result := RemoverPrefixosDesnecessarios(Result);
end;

end.
