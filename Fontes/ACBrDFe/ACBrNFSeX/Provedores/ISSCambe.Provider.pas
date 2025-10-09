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

unit ISSCambe.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceISSCambe = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetCabecalho: string;
  public
    function GerarNFSe(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;

    property Cabecalho: string read GetCabecalho;
  end;

  TACBrNFSeProviderISSCambe = class (TACBrNFSeProviderProprio)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function PrepararRpsParaLote(const aXml: string): string; override;
    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = 'ListaMensagemRetorno';
                                     const AMessageTag: string = 'MensagemRetorno'); override;
  public
    function TipoPessoaToStr(const t: TTipoPessoa): string; override;
    function StrToTipoPessoa(out ok: boolean; const s: string): TTipoPessoa; override;

    function SituacaoTribToStr(const t: TSituacaoTrib): string; override;
    function StrToSituacaoTrib(out ok: boolean; const s: string): TSituacaoTrib; override;
  end;

implementation

uses
  ACBrDFe.Conversao,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConsts, ACBrNFSeXConfiguracoes, ACBrNFSeXNotasFiscais,
  ISSCambe.GravarXml, ISSCambe.LerXml;

{ TACBrNFSeXWebserviceISSCambe }

function TACBrNFSeXWebserviceISSCambe.GetCabecalho: string;
begin
  with TACBrNFSeX(FPDFeOwner).Configuracoes.Geral do
  begin
    Result := '<auth:authentication xmlns:auth="http://www.cambe.pr.gov.br.com/nfse-ws/security">' +
                '<auth:username>' + Emitente.WSUser + '</auth:username>' +
                '<auth:password>' + Emitente.WSSenha + '</auth:password>' +
                '<auth:CNPJ>' + OnlyNumber(Emitente.CNPJ) + '</auth:CNPJ>' +
              '</auth:authentication>';
  end;

end;

function TACBrNFSeXWebserviceISSCambe.GerarNFSe(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<GeracaoNFSeRequest xmlns="http://www.cambe.pr.gov.br.com/nfse-ws/xmlschema/v1_0">' +
                AMSG +
             '</GeracaoNFSeRequest>';

  Result := Executar('', Request, Cabecalho, [], []);
end;

function TACBrNFSeXWebserviceISSCambe.ConsultarNFSePorFaixa(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNFSeRequest xmlns="http://www.cambe.pr.gov.br.com/nfse-ws/xmlschema/v1_0">' +
                AMSG +
             '</ConsultarNFSeRequest>';

  Result := Executar('', Request, Cabecalho, [], []);
end;


function TACBrNFSeXWebserviceISSCambe.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverPrefixosDesnecessarios(Result);
  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll]);
end;

{ TACBrNFSeProviderISSCambe }

procedure TACBrNFSeProviderISSCambe.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := '';
    UseCertificateHTTP := False;
    ModoEnvio := meUnitario;
    ConsultaNFSe := False;

    Autenticacao.RequerCertificado := False;
    Autenticacao.RequerLogin := True;

    ServicosDisponibilizados.EnviarUnitario := True;
    ServicosDisponibilizados.ConsultarFaixaNfse := True;
  end;

  SetNomeXSD('nfse-cambe-schema-v1_0.xsd');
  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderISSCambe.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ISSCambe.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSCambe.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ISSCambe.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSCambe.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceISSCambe.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderISSCambe.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := aXml;
end;

procedure TACBrNFSeProviderISSCambe.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
begin
  Response.ArquivoEnvio := Params.Xml;
end;

procedure TACBrNFSeProviderISSCambe.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  NumNFSe: String;
  ANota: TNotaFiscal;
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

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('ListaDadosNFSeInfo');

      if not Assigned(AuxNode) then Exit;

      AuxNode := AuxNode.Childrens.FindAnyNs('DadosNFSe');

      if not Assigned(AuxNode) then Exit;

      AuxNode := AuxNode.Childrens.FindAnyNs('EspelhoXML');

      if not Assigned(AuxNode) then Exit;

      AuxNode := AuxNode.Childrens.FindAnyNs('NFSe');

      if not Assigned(AuxNode) then Exit;

      AuxNode := AuxNode.Childrens.FindAnyNs('identificacaoNFSe');

      if not Assigned(AuxNode) then Exit;

      NumNFSe := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numero'), tcStr);

      Response.NumeroNota := NumNFSe;
      Response.Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('linkImpressao'), tcStr);
      Response.Link := StringReplace(Response.Link, '&amp;', '&', [rfReplaceAll]);

      ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumNFSe);

      ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
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
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderISSCambe.PrepararConsultaNFSeporFaixa(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  xDataI, xDataF, xFaixaData: string;
  wAno, wMes, wDia: Word;
begin
  case Response.InfConsultaNFSe.tpConsulta of
    tcPorFaixa:
      begin
        if EstaVazio(Response.InfConsultaNFSe.NumeroIniNFSe) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod105;
          AErro.Descricao := ACBrStr(Desc105);
          Exit;
        end;

        if EstaVazio(Response.InfConsultaNFSe.NumeroFinNFSe) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod106;
          AErro.Descricao := ACBrStr(Desc106);
          Exit;
        end;

        Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

        Response.Metodo := tmConsultarNFSePorFaixa;

        Response.ArquivoEnvio := '<servicosTomados>2</servicosTomados>'+ {1=SIM / 2=N�O :  Consulta de NFSe tomada n�o deve ser filtrada por faixa de n�mero}
                                 '<faixaNumero>' +
                                   '<numeroInicial>' +
                                     Response.InfConsultaNFSe.NumeroIniNFSe +
                                   '</numeroInicial>' +
                                   '<numeroFinal>' +
                                     Response.InfConsultaNFSe.NumeroFinNFSe +
                                   '</numeroFinal>' +
                                   '<tipoFaixa>' +
                                     '1' +  // NFSe
                                   '</tipoFaixa>' +
                                 '</faixaNumero>'+
                                 '<dadosPrestador>' +
                                    '<prestadorCMC>' +
                                      OnlyNumber(Emitente.InscMun) +
                                    '</prestadorCMC>' +
                                 '</dadosPrestador>';
      end;

    tcPorPeriodo:
      begin
        Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

        Response.Metodo := tmConsultarNFSePorFaixa;

        xDataI := '';
        xDataF := '';

        if Response.InfConsultaNFSe.DataInicial > 0 then
        begin
          DecodeDate(VarToDateTime(Response.InfConsultaNFSe.DataInicial), wAno, wMes, wDia);
          xDataI := FormatFloat('0000', wAno) + '-' +
                    FormatFloat('00', wMes) + '-' + FormatFloat('00', wDia);
        end;

        if Response.InfConsultaNFSe.DataFinal > 0 then
        begin
          DecodeDate(VarToDateTime(Response.InfConsultaNFSe.DataFinal), wAno, wMes, wDia);
          xDataF := FormatFloat('0000', wAno) + '-' +
                    FormatFloat('00', wMes) + '-' + FormatFloat('00', wDia);
        end;

        if (xDataI <> '') and (xDataF <> '') then
        begin
          xFaixaData := '<faixaData>' +
                          '<dataInicial>' + xDataI + '</dataInicial>' +
                          '<dataFinal>' + xDataF + '</dataFinal>' +
                          '<tipoFaixa>' +
                            '1' +  // Per�odo de Emiss�o
                          '</tipoFaixa>' +
                        '</faixaData>';
        end;

        Response.ArquivoEnvio := '<servicosTomados>2</servicosTomados>'+ {1=SIM / 2=N�O}
                                 xFaixaData +
                                 '<dadosPrestador>' +
                                   '<prestadorCMC>' +
                                     OnlyNumber(Emitente.InscMun) +
                                   '</prestadorCMC>' +
                                 '</dadosPrestador>';
      end;
  end;
end;

procedure TACBrNFSeProviderISSCambe.TratarRetornoConsultaNFSeporFaixa(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  NumNFSe: String;
  ANota: TNotaFiscal;
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

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('ListaDadosNFSeInfo');

      if not Assigned(AuxNode) then Exit;

      AuxNode := AuxNode.Childrens.FindAnyNs('DadosNFSe');

      if not Assigned(AuxNode) then Exit;

      AuxNode := AuxNode.Childrens.FindAnyNs('EspelhoXML');

      if not Assigned(AuxNode) then Exit;

      AuxNode := AuxNode.Childrens.FindAnyNs('NFSe');

      if not Assigned(AuxNode) then Exit;

      AuxNode := AuxNode.Childrens.FindAnyNs('identificacaoNFSe');

      if not Assigned(AuxNode) then Exit;

      NumNFSe := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numero'), tcStr);

      Response.NumeroNota := NumNFSe;
      Response.Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('linkImpressao'), tcStr);
      Response.Link := StringReplace(Response.Link, '&amp;', '&', [rfReplaceAll]);

      ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumNFSe);

      ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
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
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderISSCambe.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse; const AListTag,
  AMessageTag: string);
var
  I: Integer;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  Mensagem: string;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if not Assigned(ANode) then Exit;

  ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    Mensagem := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Mensagem'), tcStr);

    if Mensagem <> '' then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Codigo'), tcStr);
      AErro.Descricao := Mensagem;
      AErro.Correcao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Correcao'), tcStr);
    end;
  end;
end;

function TACBrNFSeProviderISSCambe.TipoPessoaToStr(
  const t: TTipoPessoa): string;
begin
  Result := EnumeradoToStr(t,
                           ['1', '2', '3', '4', '5'],
                           [tpPJdoMunicipio, tpPJforaMunicipio, tpPF,
                            tpPFNaoIdentificada, tpPJforaPais]);
end;

function TACBrNFSeProviderISSCambe.StrToTipoPessoa(out ok: boolean;
  const s: string): TTipoPessoa;
begin
  Result := StrToEnumerado(ok, s,
                           ['1', '2', '3', '4', '5'],
                           [tpPJdoMunicipio, tpPJforaMunicipio, tpPF,
                            tpPFNaoIdentificada, tpPJforaPais]);
end;

function TACBrNFSeProviderISSCambe.SituacaoTribToStr(
  const t: TSituacaoTrib): string;
begin
  Result := EnumeradoToStr(t, ['1', '2', '3', '4', '5', '5', '6'],
                         [tsTributadaNoPrestador, tsFixo, tsTibutadaNoTomador,
                          tsOutroMunicipio, tsIsenta, tsImune, tsNaoTributada]);
end;

function TACBrNFSeProviderISSCambe.StrToSituacaoTrib(out ok: boolean;
  const s: string): TSituacaoTrib;
begin
  Result := StrToEnumerado(ok, s, ['1', '2', '3', '4', '5', '5', '6'],
                         [tsTributadaNoPrestador, tsFixo, tsTibutadaNoTomador,
                          tsOutroMunicipio, tsIsenta, tsImune, tsNaoTributada]);
end;

end.
