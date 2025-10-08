{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit CTAConsult.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceCTAConsult = class(TACBrNFSeXWebserviceSoap11)
  public
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderCTAConsult = class (TACBrNFSeProviderProprio)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function PrepararRpsParaLote(const aXml: string): string; override;

    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = 'erros';
                                     const AMessageTag: string = 'erro'); override;

  public
    function TributacaoToStr(const t: TTributacao): string; override;
    function StrToTributacao(out ok: boolean; const s: string): TTributacao; override;
    function TributacaoDescricao(const t: TTributacao): String; override;
  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrUtil.XMLHTML, ACBrUtil.Strings,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  CTAConsult.GravarXml, CTAConsult.LerXml;

{ TACBrNFSeProviderCTAConsult }

procedure TACBrNFSeProviderCTAConsult.Configuracao;
var
  aAmbiente: string;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
    ModoEnvio := meUnitario;
    DetalharServico := True;
    ConsultaLote := False;
    ConsultaNFSe := False;

    Autenticacao.RequerCertificado := False;
    Autenticacao.RequerChaveAutorizacao := True;

    ServicosDisponibilizados.EnviarUnitario := True;
    ServicosDisponibilizados.CancelarNfse := True;
  end;

  ConfigMsgDados.UsarNumLoteConsLote := True;

  SetXmlNameSpace('http://www.ctaconsult.com/nfse');

  if ConfigGeral.Ambiente = taProducao then
    aAmbiente := '1'
  else
    aAmbiente := '2';

  ConfigMsgDados.DadosCabecalho := '<cabecalhoNfseLote xmlns="http://www.ctaconsult.com/nfse">' +
                                     '<versao>1.00</versao>' +
                                     '<ambiente>' + aAmbiente + '</ambiente>' +
                                   '</cabecalhoNfseLote>';

  SetNomeXSD('***');

  with ConfigSchemas do
  begin
    GerarNFSe := 'RecepcaoNFSe_v1.00.xsd';
    CancelarNFSe := 'CancelamentoNFSe_v1.00.xsd';
  end;
end;

function TACBrNFSeProviderCTAConsult.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_CTAConsult.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCTAConsult.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_CTAConsult.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCTAConsult.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceCTAConsult.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderCTAConsult.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse;
  const AListTag, AMessageTag: string);
var
  I: Integer;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if (ANode = nil) then
    ANode := RootNode;

  ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('codigo'), tcStr);
    AErro.Descricao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('descricao'), tcStr);
    AErro.Correcao := '';
  end;
end;

function TACBrNFSeProviderCTAConsult.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := SeparaDados(aXml, 'nfse');
end;

procedure TACBrNFSeProviderCTAConsult.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
  CodMun: Integer;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  CodMun := TACBrNFSeX(FAOwner).Configuracoes.Geral.CodigoMunicipio;

  with Params do
  begin
    Response.ArquivoEnvio := '<nfseLote xmlns="http://www.ctaconsult.com/nfse">' +
                               '<codigoMunicipio>' +
                                  CodIBGEToCodTOM(CodMun) +
                               '</codigoMunicipio>' +
                               '<dtEmissao>' +
                                  FormatDateTime('YYYY-MM-DD', Now) +
                                  'T' +
                                  FormatDateTime('HH:NN:SS', Now) +
                               '</dtEmissao>' +
                               '<notaIntermediada>' +
                                  '2' +
                               '</notaIntermediada>' +
                               '<autenticacao>' +
                                 '<token>' +
                                    Emitente.WSChaveAutoriz +
                                 '</token>' +
                               '</autenticacao>' +
                                 Xml +
                             '</nfseLote>';
  end;
end;

procedure TACBrNFSeProviderCTAConsult.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
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

      ANode := Document.Root;

      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('protocolo'), tcStr);
      Response.Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('codigoStatus'), tcStr);
      Response.NumeroNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('numeroNota'), tcStr);
      Response.Link := ObterConteudoTag(ANode.Childrens.FindAnyNs('linkPdfNota'), tcStr);
      Response.CodigoVerificacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('chaveSeguranca'), tcStr);

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      // Precisamos de um retorno sem erros para terminar a implementa��o da
      // leitura do retorno
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

procedure TACBrNFSeProviderCTAConsult.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  CodMun: Integer;
begin
  if Response.InfCancelamento.NumeroNFSe = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  if Response.InfCancelamento.ChaveNFSe = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod118;
    AErro.Descricao := ACBrStr(Desc118);
    Exit;
  end;

  if Response.InfCancelamento.DataEmissaoNFSe = 0 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod122;
    AErro.Descricao := ACBrStr(Desc122);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  CodMun := TACBrNFSeX(FAOwner).Configuracoes.Geral.CodigoMunicipio;

  Response.ArquivoEnvio := '<cancelamentoNfseLote xmlns="http://www.ctaconsult.com/nfse">' +
                             '<codigoMunicipio>' +
                                CodIBGEToCodTOM(CodMun) +
                             '</codigoMunicipio>' +
                             '<dtEmissao>' +
                                FormatDateTime('YYYY-MM-DD', Response.InfCancelamento.DataEmissaoNFSe) +
                                'T' +
                                FormatDateTime('HH:NN:SS', Response.InfCancelamento.DataEmissaoNFSe) +
                             '</dtEmissao>' +
                             '<autenticacao>' +
                               '<token>' +
                                  Emitente.WSChaveAutoriz +
                               '</token>' +
                             '</autenticacao>' +
                             '<numeroNota>' +
                                Response.InfCancelamento.NumeroNFSe +
                             '</numeroNota>' +
                             '<chaveSeguranca>' +
                                Response.InfCancelamento.ChaveNFSe +
                             '</chaveSeguranca>' +
                           '</cancelamentoNfseLote>';
end;

procedure TACBrNFSeProviderCTAConsult.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
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

      ANode := Document.Root;

      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('protocolo'), tcStr);
      Response.Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('codigoStatus'), tcStr);

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      // Precisamos de um retorno sem erros para terminar a implementa��o da
      // leitura do retorno
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

function TACBrNFSeProviderCTAConsult.StrToTributacao(out ok: boolean;
  const s: string): TTributacao;
begin
  Result := StrToEnumerado(ok, s,
                           ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
                           [ttIsentaISS, ttImune, ttExigibilidadeSusp,
                            ttTributavel, ttNaoIncidencianoMunic,
                            ttTributavelSN, ttTributavelFixo, ttNaoTributavel,
                            ttMEI]);
end;

function TACBrNFSeProviderCTAConsult.TributacaoDescricao(
  const t: TTributacao): String;
begin
  case t of
    ttIsentaISS           : Result := '1 - Isenta de ISS';
    ttImune               : Result := '2 - Imune';
    ttExigibilidadeSusp   : Result := '3 - Exigibilidade Susp.Dec.J/Proc.A';
    ttTributavel          : Result := '4 - Tribut�vel';
    ttNaoIncidencianoMunic: Result := '5 - N�o Incid�ncia no Munic�pio';
    ttTributavelSN        : Result := '6 - Tribut�vel S.N.';
    ttTributavelFixo      : Result := '7 - Tribut�vel Fixo';
    ttNaoTributavel       : Result := '8 - N�o Tribut�vel';
    ttMEI                 : Result := '9 - Micro Empreendedor Individual(MEI)';
  else
    Result := '';
  end;
end;

function TACBrNFSeProviderCTAConsult.TributacaoToStr(
  const t: TTributacao): string;
begin
  Result := EnumeradoToStr(t,
                           ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
                           [ttIsentaISS, ttImune, ttExigibilidadeSusp,
                            ttTributavel, ttNaoIncidencianoMunic,
                            ttTributavelSN, ttTributavelFixo, ttNaoTributavel,
                            ttMEI]);
end;

{ TACBrNFSeXWebserviceCTAConsult }

function TACBrNFSeXWebserviceCTAConsult.GerarNFSe(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:executar>';
  Request := Request + '<arg0>' + XmlToStr(ACabecalho) + '</arg0>';
  Request := Request + '<arg1>' + XmlToStr(AMSG) + '</arg1>';
  Request := Request + '</wsn:executar>';

  Result := Executar('', Request, ['return', 'retornoNfseLote'],
                     ['xmlns:wsn="http://wsnfselote.ctaconsult.com.br/"']);
end;

function TACBrNFSeXWebserviceCTAConsult.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request, xCabecalho: string;
begin
  FPMsgOrig := AMSG;

  xCabecalho := StringReplace(ACabecalho, 'cabecalhoNfseLote',
                     'cabecalhoCancelamentoNfseLote', [rfReplaceAll]);
  Request := '<wsn:executar>';
  Request := Request + '<arg0>' + XmlToStr(xCabecalho) + '</arg0>';
  Request := Request + '<arg1>' + XmlToStr(AMSG) + '</arg1>';
  Request := Request + '</wsn:executar>';

  Result := Executar('', Request, ['return', 'retornoCancelamentoNfseLote'],
                     ['xmlns:wsn="http://wsnfselote.ctaconsult.com.br/"']);
end;

function TACBrNFSeXWebserviceCTAConsult.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
  Result := RemoverPrefixosDesnecessarios(Result);
end;

end.
