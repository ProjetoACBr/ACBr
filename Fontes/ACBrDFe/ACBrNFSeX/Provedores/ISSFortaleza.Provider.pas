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

unit ISSFortaleza.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceISSFortaleza = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNameSpace: string;
  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;

    property NameSpace: string read GetNameSpace;
  end;

  TACBrNFSeProviderISSFortaleza = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  ACBrDFeException, ACBrXmlDocument,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  ISSFortaleza.GravarXml, ISSFortaleza.LerXml;

{ TACBrNFSeProviderISSFortaleza }

procedure TACBrNFSeProviderISSFortaleza.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.QuebradeLinha := ';';

  with ConfigMsgDados do
  begin
    Prefixo := 'ns3';
    PrefixoTS := 'ns4';

    DadosCabecalho := '<ns2:cabecalho versao="3" xmlns:ns2="http://www.ginfes.com.br/cabecalho_v03.xsd">' +
                      '<versaoDados>3</versaoDados>' +
                      '</ns2:cabecalho>';

    XmlRps.xmlns := 'http://www.ginfes.com.br/tipos_v03.xsd';

    LoteRps.xmlns := 'http://www.ginfes.com.br/servico_enviar_lote_rps_envio_v03.xsd';

    ConsultarSituacao.xmlns := 'http://www.ginfes.com.br/servico_consultar_situacao_lote_rps_envio_v03.xsd';

    ConsultarLote.xmlns := 'http://www.ginfes.com.br/servico_consultar_lote_rps_envio_v03.xsd';

    ConsultarNFSeRps.xmlns := 'http://www.ginfes.com.br/servico_consultar_nfse_rps_envio_v03.xsd';

    ConsultarNFSe.xmlns := 'http://www.ginfes.com.br/servico_consultar_nfse_envio_v03.xsd';

    CancelarNFSe.xmlns := 'http://www.ginfes.com.br/servico_cancelar_nfse_envio';
    CancelarNFSe.InfElemento := 'Prestador';
    CancelarNFSe.DocElemento := 'CancelarNfseEnvio';
  end;

  with ConfigAssinar do
  begin
    LoteRps := True;
    ConsultarSituacao := True;
    ConsultarLote := True;
    ConsultarNFSeRps := True;
    ConsultarNFSe := True;
    CancelarNFSe := True;
  end;

  SetNomeXSD('***');

  with ConfigSchemas do
  begin
    Recepcionar := 'servico_enviar_lote_rps_envio_v03.xsd';
    ConsultarSituacao := 'servico_consultar_situacao_lote_rps_envio_v03.xsd';
    ConsultarLote := 'servico_consultar_lote_rps_envio_v03.xsd';
    ConsultarNFSeRps := 'servico_consultar_nfse_rps_envio_v03.xsd';
    ConsultarNFSe := 'servico_consultar_nfse_envio_v03.xsd';
    CancelarNFSe := 'servico_cancelar_nfse_envio_v02.xsd';
  end;
end;

function TACBrNFSeProviderISSFortaleza.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ISSFortaleza.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSFortaleza.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ISSFortaleza.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSFortaleza.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceISSFortaleza.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderISSFortaleza.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  InfoCanc: TInfCancelamento;
  IdAttr, NameSpace, Prefixo, PrefixoTS: string;
begin
  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  Prefixo := '';
  PrefixoTS := '';

  InfoCanc := Response.InfCancelamento;

  if ConfigGeral.Identificador <> '' then
    IdAttr := ' ' + ConfigGeral.Identificador + '="Canc_' +
                      OnlyNumber(Emitente.CNPJ) + OnlyNumber(Emitente.InscMun) +
                      InfoCanc.NumeroNFSe + '"'
  else
    IdAttr := '';

  if EstaVazio(ConfigMsgDados.CancelarNFSe.xmlns) then
    NameSpace := ''
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.CancelarNFSe.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.CancelarNFSe.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.CancelarNFSe.xmlns then
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

  NameSpace := StringReplace(NameSpace, '_v03.xsd', '', [rfReplaceAll]);

  Response.ArquivoEnvio := '<' + Prefixo + 'CancelarNfseEnvio' + NameSpace + '>' +
                         '<' + Prefixo + 'Prestador>' +
                           '<' + PrefixoTS + 'Cnpj>' +
                             OnlyNumber(Emitente.CNPJ) +
                           '</' + PrefixoTS + 'Cnpj>' +
                           GetInscMunic(Emitente.InscMun, PrefixoTS) +
                         '</' + Prefixo + 'Prestador>' +
                         '<' + Prefixo + 'NumeroNfse>' +
                           InfoCanc.NumeroNFSe +
                         '</' + Prefixo + 'NumeroNfse>' +
                       '</' + Prefixo + 'CancelarNfseEnvio>';
end;

procedure TACBrNFSeProviderISSFortaleza.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Document: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  Ret: TRetCancelamento;
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

      Response.Sucesso := (Response.Erros.Count = 0);

      Ret :=  Response.RetCancelamento;
      Ret.Sucesso := ObterConteudoTag(ANode.Childrens.FindAnyNs('Sucesso'), tcBool);
      Ret.DataHora := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataHora'), tcDatHor);
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

{ TACBrNFSeXWebserviceISSFortaleza }

function TACBrNFSeXWebserviceISSFortaleza.GetNameSpace: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 2 then
    Result := 'http://homologacao.issfortaleza.com.br'
  else
    Result := 'http://producao.issfortaleza.com.br';

  Result := ' xmlns:ns1="' + Result + '"';
end;

function TACBrNFSeXWebserviceISSFortaleza.Recepcionar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:RecepcionarLoteRpsV3' + NameSpace + '>';
  Request := Request + '<Cabecalho>' + XmlToStr(ACabecalho) + '</Cabecalho>';
  Request := Request + '<EnviarLoteRpsEnvio>' + XmlToStr(AMSG) + '</EnviarLoteRpsEnvio>';
  Request := Request + '</ns1:RecepcionarLoteRpsV3>';

  Result := Executar('', Request,
                     ['EnviarLoteRpsResposta', 'EnviarLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSFortaleza.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:ConsultarLoteRpsV3' + NameSpace + '>';
  Request := Request + '<Cabecalho>' + XmlToStr(ACabecalho) + '</Cabecalho>';
  Request := Request + '<ConsultarLoteRpsEnvio>' + XmlToStr(AMSG) + '</ConsultarLoteRpsEnvio>';
  Request := Request + '</ns1:ConsultarLoteRpsV3>';

  Result := Executar('', Request,
                     ['ConsultarLoteRpsResposta', 'ConsultarLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSFortaleza.ConsultarSituacao(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:ConsultarSituacaoLoteRpsV3' + NameSpace + '>';
  Request := Request + '<Cabecalho>' + XmlToStr(ACabecalho) + '</Cabecalho>';
  Request := Request + '<ConsultarSituacaoLoteRpsEnvio>' + XmlToStr(AMSG) + '</ConsultarSituacaoLoteRpsEnvio>';
  Request := Request + '</ns1:ConsultarSituacaoLoteRpsV3>';

  Result := Executar('', Request,
                     ['ConsultarSituacaoLoteRpsResposta', 'ConsultarSituacaoLoteRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSFortaleza.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:ConsultarNfsePorRpsV3' + NameSpace + '>';
  Request := Request + '<Cabecalho>' + XmlToStr(ACabecalho) + '</Cabecalho>';
  Request := Request + '<ConsultarNfseRpsEnvio>' + XmlToStr(AMSG) + '</ConsultarNfseRpsEnvio>';
  Request := Request + '</ns1:ConsultarNfsePorRpsV3>';

  Result := Executar('', Request,
                     ['ConsultarNfseRpsResposta', 'ConsultarNfseRpsResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSFortaleza.ConsultarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:ConsultarNfseV3' + NameSpace + '>';
  Request := Request + '<Cabecalho>' + XmlToStr(ACabecalho) + '</Cabecalho>';
  Request := Request + '<ConsultarNfseEnvio>' + XmlToStr(AMSG) + '</ConsultarNfseEnvio>';
  Request := Request + '</ns1:ConsultarNfseV3>';

  Result := Executar('', Request,
                     ['ConsultarNfseResposta', 'ConsultarNfseResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSFortaleza.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ns1:CancelarNfse' + NameSpace + '>';
  Request := Request + '<CancelarNfseEnvio>' + XmlToStr(AMSG) + '</CancelarNfseEnvio>';
  Request := Request + '</ns1:CancelarNfse>';

  Result := Executar('', Request,
                     ['CancelarNfseResposta', 'CancelarNfseResposta'],
                     []);
end;

function TACBrNFSeXWebserviceISSFortaleza.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := ConverteANSIparaUTF8(aXML);

  Result := inherited TratarXmlRetornado(Result);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverIdentacao(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
  Result := RemoverPrefixosDesnecessarios(Result);
end;

end.
