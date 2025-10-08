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

unit ABase.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceABase201 = class(TACBrNFSeXWebserviceSoap11)

  public
    function Recepcionar(const ACabecalho, AMSG: String): string; override;
    function ConsultarLote(const ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(const ACabecalho, AMSG: String): string; override;
    function Cancelar(const ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderABase201 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
  end;

implementation

uses
  ACBrUtil.XMLHTML, ACBrUtil.Strings, ACBrDFeException,
  ACBrDFe.Conversao,
  ACBrNFSeXConsts, ACBrNFSeX, ACBrNFSeXNotasFiscais,
  ABase.GravarXml, ABase.LerXml;

{ TACBrNFSeXWebserviceABase201 }

function TACBrNFSeXWebserviceABase201.Recepcionar(const ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:RecepcionarLoteRps' +
                ' xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';

  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:RecepcionarLoteRps>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/RecepcionarLoteRps',
                     Request,
                     ['RecepcionarLoteRpsResult', 'EnviarLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceABase201.ConsultarLote(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:ConsultaLoteRps' +
                ' xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';

  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:ConsultaLoteRps>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/ConsultaLoteRps',
                     Request,
                     ['ConsultaLoteRpsResult', 'ConsultarLoteRpsResposta'], []);
end;

function TACBrNFSeXWebserviceABase201.ConsultarNFSePorRps(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:ConsultaNfseRps xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:ConsultaNfseRps>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/ConsultaNfseRps',
                     Request,
                     ['ConsultaNfseRpsResult', 'ConsultarNfseRpsResposta'], []);
end;

function TACBrNFSeXWebserviceABase201.Cancelar(const ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:CancelaNfse xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:CancelaNfse>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/CancelaNfse',
                     Request,
                     ['CancelaNfseResult', 'CancelarNfseResposta'], []);
end;

{ TACBrNFSeProviderABase201 }

procedure TACBrNFSeProviderABase201.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
    ModoEnvio := meLoteAssincrono;
    ConsultaNFSe := False;

    ServicosDisponibilizados.EnviarLoteSincrono := False;
    ServicosDisponibilizados.EnviarUnitario := False;
    ServicosDisponibilizados.ConsultarFaixaNfse := False;
    ServicosDisponibilizados.ConsultarServicoPrestado := False;
    ServicosDisponibilizados.ConsultarServicoTomado := False;
    ServicosDisponibilizados.SubstituirNfse := False;

    Particularidades.PermiteTagOutrasInformacoes := True;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
    RpsSubstituirNFSe := True;
  end;

  SetXmlNameSpace('http://nfse.abase.com.br/nfse.xsd');

  with ConfigWebServices do
  begin
    VersaoDados := '2.01';
    VersaoAtrib := '2.01';
  end;

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');
end;

function TACBrNFSeProviderABase201.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ABase201.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderABase201.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ABase201.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderABase201.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceABase201.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderABase201.TratarRetornoConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode, AuxNodeConf: TACBrXmlNode;
  AErro: TNFSeEventoCollectionItem;
  ANota: TNotaFiscal;
  NumNFSe, NumRps: String;
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

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root.Childrens.FindAnyNs('ListaNfse');

      if ANode = nil then
        ANode := Document.Root.Childrens.FindAnyNs('CompNfse')
      else
        ANode := ANode.Childrens.FindAnyNs('CompNfse');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := ACBrStr(Desc203);
        Exit;
      end;

      AuxNode := ANode.Childrens.FindAnyNs('NfseCancelamento');

      if AuxNode <> nil then
      begin
        AuxNodeConf := AuxNode.Childrens.FindAnyNs('Confirmacao');

        if AuxNodeConf = nil then
          AuxNodeConf := AuxNode.Childrens.FindAnyNs('ConfirmacaoCancelamento');
        if not Assigned(AuxNodeConf) then Exit;

//        Response.DataCanc := LerDatas(ObterConteudoTag(AuxNodeConf.Childrens.FindAnyNs('DataHora'), tcStr));
        Response.DataCanc := ObterConteudoTag(AuxNodeConf.Childrens.FindAnyNs('DataHora'), FpFormatoDataHora);
        Response.DescSituacao := '';

        if Response.DataCanc > 0 then
          Response.DescSituacao := 'Nota Cancelada';
      end;

      AuxNode := ANode.Childrens.FindAnyNs('Nfse');

      if AuxNode <> nil then
      begin
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        if not Assigned(AuxNode) then Exit;

        NumNFSe := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);

        with Response do
        begin
          NumeroNota := NumNFSe;
          CodigoVerificacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CodigoVerificacao'), tcStr);
          Data := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('DataEmissao'), FpFormatoDataEmissao);
        end;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumNFSe);

        if ANota = nil then
        begin
          AuxNode := AuxNode.Childrens.FindAnyNs('IdentificacaoRps');
          if not Assigned(AuxNode) then Exit;

          NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);

          ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);
        end;

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

function TACBrNFSeXWebserviceABase201.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(Result);
  Result := RemoverDeclaracaoXML(Result);
end;

end.
