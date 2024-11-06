{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{ Colaboradores nesse arquivo: Willian Delan, HelioNeto, Lucio Bittes,         }
{ Jhonlenon Ribeiro, rafabarzotto                                              }
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
//incluido em COLOCAR A DATA

{$I ACBr.inc}
unit ACBrBoletoW_Bradesco;

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  DateUtils,
  Math,

  ACBrBoletoWS,
  pcnConversao,
  ACBrBoletoConversao,
  ACBrBoleto,
  ACBrBoletoWS.Rest,
  ACBrJSON,
  ACBrBoletoWS.SOAP;

type

  { TBoletoW_Bradesco}
  TBoletoW_Bradesco = class(TBoletoWSREST)
    FUnixTime : Int64;
  private
    procedure AlteracaoDesconto(AJsonObject: TACBrJSONObject);
    procedure AlteraDataVencimento(AJsonObject: TACBrJSONObject);
    procedure AlterarEspecie(AJsonObject: TACBrJSONObject);
    procedure AlterarProtesto(AJsonObject: TACBrJSONObject);
    procedure AtribuirAbatimento(AJsonObject: TACBrJSONObject);
    procedure AtribuirDesconto(AJsonObject: TACBrJSONObject);
    function DateTimeToDateBradesco( const AValue:TDateTime ):String;
  protected
    procedure DefinirURL; override;
    procedure DefinirContentType; override;
    procedure GerarHeader; override;
    procedure GerarDados; override;
    procedure DefinirAuthorization; override;
    function GerarTokenAutenticacao: string; override;
    function DefinirParametros: String;
    procedure DefinirParamOAuth; override;
    procedure DefinirKeyUser;
    function ValidaAmbiente: Integer;

    procedure DefinirAutenticacao;
    procedure RequisicaoJson;
    procedure RequisicaoAltera;
    procedure RequisicaoBaixa;
    procedure RequisicaoConsultaDetalhe;

    procedure GerarBenificiarioFinal(AJsonObject: TACBrJSONObject);
    procedure GerarJuros(AJsonObject: TACBrJSONObject);
    procedure GerarMulta(AJsonObject: TACBrJSONObject);
    procedure GerarDesconto(AJsonObject: TACBrJSONObject);

  public
    constructor Create(ABoletoWS: TBoletoWS; AACBrBoleto : TACBrBoleto); reintroduce;
    function GerarRemessa: string; override;
    function Enviar: boolean; override;
  end;

const
  C_URL             = 'https://openapi.bradesco.com.br';
  C_URL_HOM         = 'https://proxy.api.prebanco.com.br';
  URI_REG_BOLETO    = '/v1/boleto-hibrido/registrar-boleto';

  C_URL_OAUTH_PROD  = 'https://openapi.bradesco.com.br/auth/server/v%s/token';
  C_URL_OAUTH_HOM   = 'https://proxy.api.prebanco.com.br/auth/server/v%s/token';

  C_CONTENT_TYPE    = 'application/x-www-form-urlencoded';
  C_ACCEPT          = '*/*';
  C_AUTHORIZATION   = 'Authorization';

  C_ACCEPT_ENCODING = 'gzip, deflate, br';

  C_CHARSET         = 'utf-8';
  C_ACCEPT_CHARSET  = 'UTF8';

implementation

uses
  synacode,
  httpsend,

  ACBrDFeSSL,
  ACBrUtil.FilesIO,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  ACBrUtil.Base,
  pcnAuxiliar,
  ACBrBoletoWS.Rest.OAuth;

{ TBoletoW_Bradesco}

procedure TBoletoW_Bradesco.DefinirURL;
begin
  FPURL := IfThen(Boleto.Configuracoes.WebService.Ambiente = tawsProducao, C_URL,C_URL_HOM);
  case Boleto.Configuracoes.WebService.Operacao of
    tpInclui: FPURL := FPURL + URI_REG_BOLETO;
    tpAltera:
    begin
       if ATitulo.OcorrenciaOriginal.Tipo = ACBrBoleto.toRemessaBaixar then
         FPURL := FPURL + '/v1/boleto/titulo-baixar'
       else if aTitulo.OcorrenciaOriginal.Tipo = ACBrBoleto.toRemessaAlterarVencimento then
         FPURL := FPURL + '/v1/boleto/alterar-titulo';
    end;
    tpConsultaDetalhe:  FPURL := FPURL + '/v1/boleto/titulo-consultar';
    tpBaixa:  FPURL := FPURL + '/v1/boleto/titulo-baixar';
  end;
end;

procedure TBoletoW_Bradesco.DefinirContentType;
begin
  FPContentType := C_CONTENT_TYPE;
end;

procedure TBoletoW_Bradesco.GerarHeader;
var
  LDataAtual: TDateTime;
  LIntMiliSegundos: Int64;
  LStrTimeStamp:string ;
  LStrRequestAssinado: string;
  LStrConteudo:string;
begin
  FPHeaders.Clear;
  DefinirContentType;
  DefinirKeyUser;
  if FPDadosMsg <> '' then
  begin
     FPHeaders.Add('Accept-Encoding: ' + C_ACCEPT_ENCODING);
     FPHeaders.Add('Content-Type: application/json');
     FPHeaders.Add('X-Brad-Signature: ' + OAuth.Token);
     FPHeaders.Add('X-Brad-Nonce: ' + IntToStr(FUnixTime * 1000));
     FPHeaders.Add('X-Brad-Timestamp: ' + IntToStr(FUnixTime));
     FPHeaders.Add('X-Brad-Algorithm: SHA256');
     FPHeaders.Add('acess-token: ' + Boleto.Cedente.CedenteWS.ClientID);
     FPHeaders.Add('cpf-cnpj: ' + OnlyNumber(Boleto.Cedente.CNPJCPF));
     FPHeaders.Add(FPDadosMsg);
  end;
end;

procedure TBoletoW_Bradesco.GerarDados;
begin
  if Assigned(Boleto) then
    DefinirURL;
  case Boleto.Configuracoes.WebService.Operacao of
    tpInclui:
    begin
      FMetodoHTTP := htPOST;//Define M�todo POST para Incluir.
      RequisicaoJson;
      GerarHeader//Necess�rio o Json do boleto para usar no Header na assinatura.
    end;
    tpAltera:
    begin
      FMetodoHTTP := htPATCH;//Define M�todo PATCH para Altera��o.
      RequisicaoAltera;
    end;
    tpBaixa:
    begin
      FMetodoHTTP := htPATCH;//Define M�todo PATCH para Baixa.
      RequisicaoBaixa;
    end;
    tpConsultaDetalhe:
    begin
      FMetodoHTTP := htGET;//Define M�todo GET Consulta Detalhe.
      RequisicaoConsultaDetalhe;
    end;
  else
    raise EACBrBoletoWSException.Create(ClassName + Format(S_OPERACAO_NAO_IMPLEMENTADO,
                                        [TipoOperacaoToStr(Boleto.Configuracoes.WebService.Operacao)]));
  end;
end;

procedure TBoletoW_Bradesco.DefinirAuthorization;
begin
  FPAuthorization := Format( '%s: Bearer %s',[C_Authorization , GerarTokenAutenticacao] );
end;

function TBoletoW_Bradesco.GerarTokenAutenticacao: string;
const PARAMS_OAUTH = '{"aud": "%s","sub": "%s","iat": "%s","exp": "%s","jti": "%s","ver": "%s"}';
var
  LVersao, LURL : String;
begin
  OAuth.Payload := True;
  result:= '';
  if Boleto.Cedente.CedenteWS.IndicadorPix then
    LVersao := '1.2'
  else
    LVersao := '1.1';

  FUnixTime := DateTimeToUnix(Now, False);

  if  Boleto.Configuracoes.WebService.Ambiente = tawsProducao then
    LURL := Format(OAuth.URL,['1.1']) //p�gina 7
  else
    LURL := Format(OAuth.URL,[LVersao]);

  if Assigned(OAuth) then
  begin
    OAuth.GrantType   := 'urn:ietf:params:oauth:grant-type:jwt-bearer';
    OAuth.ParamsOAuth := Format(PARAMS_OAUTH,
                                [LURL,
                                 Boleto.Cedente.CedenteWS.ClientID,
                                 IntToStr(FUnixTime),
                                 IntToStr(FUnixTime + 3600),
                                 IntToStr(FUnixTime * 1000),
                                 LVersao]);
    OAuth.AddHeaderParam('Accept-Encoding', C_ACCEPT_ENCODING);
    OAuth.AddHeaderParam('Accept-Charset' , C_ACCEPT_CHARSET);
    OAuth.AddHeaderParam('Accept','*/*');
    if OAuth.GerarToken then
      result := OAuth.Token
    else
      raise EACBrBoletoWSException.Create(ClassName + Format( S_ERRO_GERAR_TOKEN_AUTENTICACAO, [OAuth.ErroComunicacao] ));
  end;
end;

procedure TBoletoW_Bradesco.DefinirKeyUser;
begin
  if Assigned(aTitulo) then
    FPKeyUser := '';
end;

function TBoletoW_Bradesco.DefinirParametros: String;
var
  LConsulta: TStringList;
begin
  if Assigned(Boleto.Configuracoes.WebService.Filtro) then
  begin
    LConsulta := TStringList.Create;
    try
      LConsulta.Delimiter := '&';
      LConsulta.Add( 'agencia='+Boleto.Cedente.Agencia);
      LConsulta.Add( 'conta='+Boleto.Cedente.Conta);
      result := LConsulta.DelimitedText;
    finally
      LConsulta.Free;
    end;
  end;
end;

procedure TBoletoW_Bradesco.DefinirParamOAuth;
begin
  FParamsOAuth := Format( 'grant_type=%s&assertion=%s', ['urn:ietf:params:oauth:grant-type:jwt-bearer', FPKeyUser] );
end;

function TBoletoW_Bradesco.DateTimeToDateBradesco(const AValue: TDateTime): String;
begin
   result := FormatDateBr(AValue, 'DD.MM.YYYY');
end;

function TBoletoW_Bradesco.ValidaAmbiente: Integer;
begin
  result := StrToIntDef(IfThen(Boleto.Configuracoes.WebService.Ambiente = tawsProducao, '1','2'), 2);
end;

procedure TBoletoW_Bradesco.DefinirAutenticacao;
begin
  FPAuthorization := Format( '%s: %s', [C_ACCESS_TOKEN , GerarTokenAutenticacao]);
end;

procedure TBoletoW_Bradesco.RequisicaoBaixa;
var
  LJsonObject: TACBrJSONObject;
begin
   if Assigned(aTitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('numeroContrato',aTitulo.ACBrBoleto.Cedente.CodigoCedente);
      LJsonObject.AddPair('modalidade',aTitulo.ACBrBoleto.Cedente.Modalidade);
      LJsonObject.AddPair('nossoNumero',OnlyNumber(aTitulo.ACBrBoleto.Banco.MontarCampoNossoNumero(aTitulo)));
      LJsonObject.AddPair('seuNumero', IfThen(ATitulo.SeuNumero <> '',
                                                      ATitulo.SeuNumero,
                                                      IfThen(ATitulo.NumeroDocumento <> '',
                                                        ATitulo.NumeroDocumento,
                                                        OnlyNumber(aTitulo.ACBrBoleto.Banco.MontarCampoNossoNumero(aTitulo))
                                                      )
                                                    ));

      FPDadosMsg := Format('[%s]',[LJsonObject.ToJSON]);
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Bradesco.RequisicaoJson;
var
  LJsonObject: TACBrJSONObject;
begin
  //*OBS: Todos os campos devem ser informados conforme layout, entretanto, para os tipos n�o obrigat�rios,
  //devem ser preenchidos com zeros para campo num�rico, ou espa�os para campo alfanum�rico.
  if Assigned(aTitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('registrarTitulo', 1); //1 = Registrar o t�tulo 2 = Somente consistir dados do t�tulo
      LJsonObject.AddPair('codUsuario', 'APISERVIC');//FIXO.
      LJsonObject.AddPair('nroCpfCnpjBenef', OnlyNumber(Boleto.Cedente.CNPJCPF));
      LJsonObject.AddPair('filCpfCnpjBenef', 57);
      LJsonObject.AddPair('digCpfCnpjBenef', IfThen(Boleto.Cedente.TipoInscricao = pJuridica,
                                             Copy(OnlyNumber(Boleto.Cedente.CNPJCPF), 13, 2),
                                             Copy(OnlyNumber(Boleto.Cedente.CNPJCPF), 10, 2)));
      LJsonObject.AddPair('tipoAcesso', 2);//FIXO.
      LJsonObject.AddPair('cpssoaJuridContr', 0);//FIXO.
      LJsonObject.AddPair('ctpoContrNegoc', 0);//FIXO.
      LJsonObject.AddPair('nseqContrNegoc', 0);//FIXO.
      LJsonObject.AddPair('cidtfdProdCobr', RemoveZerosEsquerda(aTitulo.Carteira));
      LJsonObject.AddPair('cnegocCobr', Boleto.Cedente.Agencia + Boleto.Cedente.Conta);
      LJsonObject.AddPair('codigoBanco', 237);//FIXO.
      LJsonObject.AddPair('filler', '');//FIXO.
      LJsonObject.AddPair('eNseqContrNegoc', 0);//FIXO.
      //tipoRegistro: 1-T�tulo 2-T�tulo com Instru��o de Protesto 3-T�tulo com Instru��o de Protesto Falimentar.
      LJsonObject.AddPair('tipoRegistro', 1);//N�O Obrigat�rio;
      LJsonObject.AddPair('cprodtServcOper', 0);//FIXO.
      LJsonObject.AddPair('ctitloCobrCdent', OnlyNumber(aTitulo.NossoNumero));//N�O Obrigat�rio;

      //ctitloCliCdent: Identificador do t�tulo pelo benefici�rio(Seu N�mero).
      LJsonObject.AddPair('ctitloCliCdent', IfThen(ATitulo.NumeroDocumento <> '',
                                             ATitulo.NumeroDocumento,
                                             IfThen(ATitulo.SeuNumero <> '',
                                                    ATitulo.SeuNumero,
                                                    OnlyNumber(aTitulo.NossoNumero))));
      LJsonObject.AddPair('demisTitloCobr', DateTimeToDateBradesco(aTitulo.DataDocumento));
      LJsonObject.AddPair('dvctoTitloCobr', DateTimeToDateBradesco(aTitulo.Vencimento));
      LJsonObject.AddPair('cidtfdTpoVcto', 0);//FIXO.
      LJsonObject.AddPair('cindcdEconmMoeda', '00006');
      LJsonObject.AddPair('vnmnalTitloCobr', aTitulo.ValorDocumento);
      LJsonObject.AddPair('qmoedaNegocTitlo', 0);//FIXO.
      LJsonObject.AddPair('cespceTitloCobr', aTitulo.EspecieDoc);
      LJsonObject.AddPair('cindcdAceitSacdo', 'N');
     //ctpoProteTitlo: Tipo de protesto autom�tico do t�tulo: 1 = Dias corridos | 2 = Dias �teis.
      LJsonObject.AddPair('ctpoProteTitlo', 0);//N�O Obrigat�rio;
      //Quantidade de dias ap�s o vencimento, para protesto autom�tico. Obrigat�rio? Sim, caso informado ctpoProteTitlo.
      LJsonObject.AddPair('ctpoPrzProte', 0);
      //Tipo decurso de protesto: 1 = Dias corridos | 2 = Dias �teis. Obrigat�rio? Sim, caso informado ctpoProteTitlo.
      LJsonObject.AddPair('ctpoProteDecurs', 0);
      LJsonObject.AddPair('ctpoPrzDecurs', 0);//FIXO.
      LJsonObject.AddPair('cctrlPartcTitlo', 0);//N�O Obrigat�rio;
      LJsonObject.AddPair('cformaEmisPplta', 2);//FIXO.
      LJsonObject.AddPair('cindcdPgtoParcial', 'N�o');//FIXO.
      LJsonObject.AddPair('qtdePgtoParcial', 000);//FIXO.
      LJsonObject.AddPair('filler1', '');//FIXO.

      GerarJuros(LJsonObject);
      GerarMulta(LJsonObject);
      GerarDesconto(LJsonObject);

      //Tipo de prazo desconto/bonifica��o: 1 = Dias corridos | 2 = Dias �teis. Obrigat�rio? Sim, caso informado valor ou percentual de desconto/bonifica��o.
      LJsonObject.AddPair('ctpoPrzCobr', 1);
      LJsonObject.AddPair('pdescBonifPgto', 0);//N�O Obrigat�rio;
      LJsonObject.AddPair('vdescBonifPgto', 0);//N�O Obrigat�rio;
      LJsonObject.AddPair('dlimBonifPgto', '0');// 'Exemplo 01.01.2001';Caso informado o acima.
      LJsonObject.AddPair('vabtmtTitloCobr', 0);//N�O Obrigat�rio;
      LJsonObject.AddPair('viofPgtoTitlo', 0);//N�O Obrigat�rio;
      LJsonObject.AddPair('filler2', '');//FIXO.
      LJsonObject.AddPair('isacdoTitloCobr', Copy(aTitulo.Sacado.NomeSacado, 1, 70));
      LJsonObject.AddPair('elogdrSacdoTitlo', Copy(aTitulo.Sacado.Logradouro, 1, 40));
      LJsonObject.AddPair('enroLogdrSacdo', aTitulo.Sacado.Numero);
      LJsonObject.AddPair('ecomplLogdrSacdo', Copy(aTitulo.Sacado.Complemento, 1, 15));
      LJsonObject.AddPair('ccepSacdoTitlo', Copy(aTitulo.Sacado.CEP, 1, 5));
      LJsonObject.AddPair('ccomplCepSacdo', Copy(aTitulo.Sacado.CEP, 6, 8));
      LJsonObject.AddPair('ebairoLogdrSacdo', Copy(aTitulo.Sacado.Bairro, 1, 40));
      LJsonObject.AddPair('imunSacdoTitlo', Copy(aTitulo.Sacado.Cidade, 1, 30));
      LJsonObject.AddPair('csglUfSacdo', Copy(aTitulo.Sacado.UF, 1, 2));
      LJsonObject.AddPair('indCpfCnpjSacdo', IfThen(aTitulo.Sacado.Pessoa = pJuridica, '2', '1'));
      LJsonObject.AddPair('nroCpfCnpjSacdo', OnlyNumber(aTitulo.Sacado.CNPJCPF));
      LJsonObject.AddPair('renderEletrSacdo', Copy(aTitulo.Sacado.Email, 1, 70));
      LJsonObject.AddPair('cdddFoneSacdo', Copy(OnlyNumber(aTitulo.Sacado.Fone), 1, 3));//N�O Obrigat�rio;
      LJsonObject.AddPair('cfoneSacdoTitlo', Copy(OnlyNumber(aTitulo.Sacado.Fone), 1, 11));//N�O Obrigat�rio;
      LJsonObject.AddPair('bancoDeb', 0);//C�digo do Banco para d�bito autom�tico. -> N�O Obrigat�rio;
      LJsonObject.AddPair('agenciaDeb', 0);//N�mero da ag�ncia para d�bito autom�tico. -> N�O Obrigat�rio;
      LJsonObject.AddPair('agenciaDebDv', 0);//D�gito verificador da Ag�ncia para d�bito autom�tico. -> Caso informado agenciaDeb;
      LJsonObject.AddPair('contaDeb', 0);//N�mero da conta para d�bito autom�tico. -> Caso informado agenciaDeb;
      LJsonObject.AddPair('bancoCentProt', 0);//FIXO.
      LJsonObject.AddPair('agenciaDvCentPr', 0);//FIXO.

      GerarBenificiarioFinal(LJsonObject);

      LJsonObject.AddPair('filler3', '');//FIXO.
      LJsonObject.AddPair('fase', 1);//FIXO.
      LJsonObject.AddPair('cindcdCobrMisto', 'S');//FIXO.
      LJsonObject.AddPair('ialiasAdsaoCta', '');//Chave Pix do benefici�rio. Manter em branco.
      LJsonObject.AddPair('iconcPgtoSpi', '');//TXID do t�tulo. Manter em branco.
      LJsonObject.AddPair('caliasAdsaoCta', '');//C�digos de erro na gera��o do QR Code pelo BSPI. Manter em branco.
      LJsonObject.AddPair('ilinkGeracQrcd', '');//Identifica��o do location do QR Code gerado pelo BSPI. Manter em branco.
      LJsonObject.AddPair('wqrcdPdraoMercd', '');//C�digo EMV do QR Code gerado pelo BSPI. Manter em branco.
      LJsonObject.AddPair('validadeAposVencimento', '');//Quantidade de dias ap�s vencimento, que o t�tulo � v�lido para pagamento via Pix. Manter em branco.
      LJsonObject.AddPair('filler4', '');//Manter em branco.

      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Bradesco.RequisicaoAltera;
var
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(aTitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('numeroContrato',aTitulo.ACBrBoleto.Cedente.CodigoCedente);
      LJsonObject.AddPair('modalidade',aTitulo.ACBrBoleto.Cedente.Modalidade);
      LJsonObject.AddPair('nossoNumero',OnlyNumber(aTitulo.ACBrBoleto.Banco.MontarCampoNossoNumero(aTitulo)));

      case Integer(aTitulo.ACBrBoleto.ListadeBoletos.Objects[0].OcorrenciaOriginal.Tipo) of
         1 : // Baixa
          begin
            LJsonObject.AddPair('seuNumero', IfThen(ATitulo.SeuNumero <> '',
                                                      ATitulo.SeuNumero,
                                                      IfThen(ATitulo.NumeroDocumento <> '',
                                                        ATitulo.NumeroDocumento,
                                                        OnlyNumber(aTitulo.ACBrBoleto.Banco.MontarCampoNossoNumero(aTitulo))
                                                      )
                                                    ));
          end;
        5: //RemessaConcederDesconto
          begin
            AtribuirDesconto(LJsonObject);
          end;
        7: //RemessaAlterarVencimento
          begin
            AlteraDataVencimento(LJsonObject);
          end;
        9:  //RemessaProtestar
          begin
            FMetodoHTTP := htPOST;
            AlterarProtesto(LJsonObject);
          end;
        10:  //RemessaSustarProtesto
          begin
            FMetodoHTTP :=  htDELETE;
            AlterarProtesto(LJsonObject);
          end;
        37: //RemessaCobrarJurosMora
          begin
            GerarJuros(LJsonObject);
          end;
        50:  //RemessaAlterarMulta
          begin
            GerarMulta(LJsonObject);
          end;
        52: //RemessaAlterarDesconto
          begin
            AlteracaoDesconto(LJsonObject);
          end;
        54: //RemessaAlterarAbatimento
          begin
           AtribuirAbatimento(LJsonObject);
          end;
        64:  //Alterar Especie
          begin
            AlterarEspecie(LJsonObject);
          end;
      end;

      FPDadosMsg := Format('[%s]',[LJsonObject.ToJSON]);
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Bradesco.RequisicaoConsultaDetalhe;
begin
  //Implementar
end;

procedure TBoletoW_Bradesco.GerarBenificiarioFinal(AJsonObject: TACBrJSONObject);
begin
  //*Nenhum desses campos s�o obrigat�rios, mas caso informado "Nome" do avalista, deve informar os demais abaixo.
  if Assigned(aTitulo) then
  begin
    if Assigned(AJsonObject) then
    begin
      AJsonObject.AddPair('isacdrAvalsTitlo', Copy(aTitulo.Sacado.SacadoAvalista.NomeAvalista, 1, 40));
      AJsonObject.AddPair('nroCpfCnpjSacdr', Copy(OnlyNumber(aTitulo.Sacado.SacadoAvalista.CNPJCPF), 1, 14));
      AJsonObject.AddPair('ccepSacdrTitlo', Copy(aTitulo.Sacado.SacadoAvalista.CEP, 1, 5));
      AJsonObject.AddPair('ccomplCepSacdr', Copy(aTitulo.Sacado.SacadoAvalista.CEP, 6, 8));
      AJsonObject.AddPair('elogdrSacdrAvals', Copy(aTitulo.Sacado.SacadoAvalista.Logradouro, 1, 10));
      AJsonObject.AddPair('enroLogdrSacdr', aTitulo.Sacado.SacadoAvalista.Numero);
      AJsonObject.AddPair('ecomplLogdrSacdr', Copy(aTitulo.Sacado.SacadoAvalista.Complemento, 1, 15));
      AJsonObject.AddPair('ebairoLogdrSacdr', Copy(aTitulo.Sacado.SacadoAvalista.Bairro, 1, 40));
      AJsonObject.AddPair('imunSacdrAvals', Copy(aTitulo.Sacado.SacadoAvalista.Cidade, 1, 40));
      AJsonObject.AddPair('csglUfSacdr', Copy(aTitulo.Sacado.SacadoAvalista.UF, 1, 2));
      AJsonObject.AddPair('indCpfCnpjSacdr', IfThen(aTitulo.Sacado.SacadoAvalista.Pessoa = pJuridica, '2', '1'));
      AJsonObject.AddPair('renderEletrSacdr', Copy(aTitulo.Sacado.SacadoAvalista.Email, 1, 70));
      AJsonObject.AddPair('cdddFoneSacdr', Copy(OnlyNumber(aTitulo.Sacado.SacadoAvalista.Fone), 1, 3));//N�O Obrigat�rio;
      AJsonObject.AddPair('cfoneSacdrTitlo', Copy(OnlyNumber(aTitulo.Sacado.SacadoAvalista.Fone), 1, 11));//N�O Obrigat�rio;
    end;
  end;
end;

procedure TBoletoW_Bradesco.GerarJuros(AJsonObject: TACBrJSONObject);
begin
 if Assigned(aTitulo) then
  begin
    if Assigned(AJsonObject) then
    begin
      if ATitulo.CodigoMora = '' then
      begin
        case aTitulo.CodigoMoraJuros of
          cjValorDia   : aTitulo.CodigoMora := '1';
          cjTaxaMensal : aTitulo.CodigoMora := '2';
          cjIsento     : aTitulo.CodigoMora := '3';
          else
            aTitulo.CodigoMora := '3';
        end;
      end;
      //qdiaInicJuro: Quantidade de dias ap�s o vencimento, para incid�ncia de juros
      case (StrToIntDef(aTitulo.CodigoMora, 0)) of
        0,3:    // Isento
          begin
            AJsonObject.AddPair('vdiaJuroMora', 0);
            AJsonObject.AddPair('ptxJuroVcto', 0);
            AJsonObject.AddPair('qdiaInicJuro', 0);
          end;
        1:     // Dia
          begin
            AJsonObject.AddPair('qdiaInicJuro', DaysBetween(aTitulo.Vencimento, aTitulo.DataMoraJuros));
            AJsonObject.AddPair('vdiaJuroMora', aTitulo.ValorMoraJuros);
            AJsonObject.AddPair('ptxJuroVcto', 0);
          end;
        2: // M�s
          begin
            AJsonObject.AddPair('qdiaInicJuro', DaysBetween(aTitulo.Vencimento, aTitulo.DataMoraJuros));
            AJsonObject.AddPair('ptxJuroVcto', aTitulo.ValorMoraJuros);
            AJsonObject.AddPair('vdiaJuroMora', 0);
          end;
      end;
    end;
  end;
end;

procedure TBoletoW_Bradesco.GerarMulta(AJsonObject: TACBrJSONObject);
var
  LCodMulta: Integer;
  LDataMulta : TDateTime;
begin
  if Assigned(aTitulo) then
  begin
    if Assigned(AJsonObject) then
    begin
      if aTitulo.PercentualMulta > 0 then
      begin
        if aTitulo.MultaValorFixo then
          LCodMulta := 1
        else
          LCodMulta := 2;
      end
      else
        LCodMulta := 3;
      if (aTitulo.DataMulta > 0) then
        LDataMulta :=  aTitulo.DataMulta
      else
        LDataMulta  := ATitulo.DataMoraJuros;
      case LCodMulta of
        1:
        begin
          AJsonObject.AddPair('qdiaInicMulta', DateTimeToDateBradesco(LDataMulta));
          AJsonObject.AddPair('vmultaAtrsoPgto', aTitulo.PercentualMulta);
          AJsonObject.AddPair('pmultaAplicVcto', 0);
        end;
        2:
        begin
          AJsonObject.AddPair('qdiaInicMulta', DateTimeToDateBradesco(LDataMulta));
          AJsonObject.AddPair('pmultaAplicVcto', aTitulo.PercentualMulta);
          AJsonObject.AddPair('vmultaAtrsoPgto', 0);
        end;
        3:
        begin
          AJsonObject.AddPair('qdiaInicMulta', 0);
          AJsonObject.AddPair('pmultaAplicVcto', 0);
          AJsonObject.AddPair('vmultaAtrsoPgto', 0);
        end;
      end;
    end;
  end;
end;

constructor TBoletoW_Bradesco.Create(ABoletoWS: TBoletoWS; AACBrBoleto : TACBrBoleto);
begin
  inherited Create(ABoletoWS);

  FPAccept := C_ACCEPT;

  if Assigned(OAuth) then
  begin
    if OAuth.Ambiente = tawsProducao then
      OAuth.URL := C_URL_OAUTH_PROD
    else
      OAuth.URL := C_URL_OAUTH_HOM;


    if AACBrBoleto.Cedente.CedenteWS.IndicadorPix then
      OAuth.URL := Format(OAuth.URL, ['1.2'])
    else
      OAuth.URL := Format(OAuth.URL, ['1.1']);

    OAuth.Payload := True;
    OAuth.ContentType       := 'application/x-www-form-urlencoded';
    OAuth.AuthorizationType := atJWT;
  end;
end;

function TBoletoW_Bradesco.GerarRemessa: string;
begin
  DefinirCertificado;
  result := inherited GerarRemessa;
end;

function TBoletoW_Bradesco.Enviar: boolean;
begin
  DefinirCertificado;
  result := inherited Enviar;
end;

procedure TBoletoW_Bradesco.GerarDesconto(AJsonObject: TACBrJSONObject);
begin
 if Assigned(aTitulo) then
  begin
    if Assigned(AJsonObject) then
    begin
      // '1'  =  Valor em Reais;
      // '2'  =  Percentual;
      // '3'  =  Isento.
      if Integer(aTitulo.TipoDesconto) <> 0 then
      begin
        if Integer(aTitulo.TipoDesconto) = 1 then
        begin
          AJsonObject.AddPair('vdescBonifPgto01', aTitulo.ValorDesconto);
          AJsonObject.AddPair('pdescBonifPgto01', 0);
        end
        else
        begin
          AJsonObject.AddPair('pdescBonifPgto01', aTitulo.ValorDesconto);
          AJsonObject.AddPair('vdescBonifPgto01', 0);
        end;
        AJsonObject.AddPair('dlimDescBonif1', DateTimeToDateBradesco(aTitulo.Vencimento));
      end
      else
      begin
        AJsonObject.AddPair('vdescBonifPgto01', 0);
        AJsonObject.AddPair('pdescBonifPgto01', 0);
        AJsonObject.AddPair('dlimDescBonif1', 0);
      end;
      if Integer(aTitulo.TipoDesconto2) <> 0 then
      begin
        if Integer(aTitulo.TipoDesconto2) = 1 then
        begin
          AJsonObject.AddPair('vdescBonifPgto02', aTitulo.ValorDesconto);
          AJsonObject.AddPair('pdescBonifPgto02', 0);
        end
        else
        begin
          AJsonObject.AddPair('pdescBonifPgto02', aTitulo.ValorDesconto);
          AJsonObject.AddPair('vdescBonifPgto02', 0);
        end;
        AJsonObject.AddPair('dlimDescBonif2', DateTimeToDateBradesco(aTitulo.Vencimento));
      end
      else
      begin
        AJsonObject.AddPair('vdescBonifPgto02', 0);
        AJsonObject.AddPair('pdescBonifPgto02', 0);
        AJsonObject.AddPair('dlimDescBonif2', 0);
      end;
      if Integer(aTitulo.TipoDesconto3) <> 0 then
      begin
        if Integer(aTitulo.TipoDesconto3) = 1 then
        begin
          AJsonObject.AddPair('vdescBonifPgto03', aTitulo.ValorDesconto);
          AJsonObject.AddPair('pdescBonifPgto03', 0);
        end
        else
        begin
          AJsonObject.AddPair('pdescBonifPgto03', aTitulo.ValorDesconto);
          AJsonObject.AddPair('vdescBonifPgto03', 0);
        end;
        AJsonObject.AddPair('dlimDescBonif3', DateTimeToDateBradesco(aTitulo.Vencimento));
      end
      else
      begin
        AJsonObject.AddPair('vdescBonifPgto03', 0);
        AJsonObject.AddPair('pdescBonifPgto03', 0);
        AJsonObject.AddPair('dlimDescBonif3', 0);
      end;
    end;
  end;
end;

procedure TBoletoW_Bradesco.AlteraDataVencimento(AJsonObject: TACBrJSONObject);
begin
 if Assigned(ATitulo) then
  begin
    if Assigned(AJsonObject) then
    begin
        if (ATitulo.Vencimento > 0) then
        begin
          AJsonObject.AddPair('dataVencimento',DateTimeToDateBradesco(aTitulo.Vencimento));
        end;
    end;
  end;
end;

procedure TBoletoW_Bradesco.AtribuirAbatimento(AJsonObject: TACBrJSONObject);
begin
  if Assigned(ATitulo) then
  begin
    if Assigned(AJsonObject) then
    begin
        if (ATitulo.Vencimento > 0) then
        begin
          AJsonObject.AddPair('valorAbatimento',aTitulo.ValorAbatimento);
        end;
    end;
  end;
end;

procedure TBoletoW_Bradesco.AlterarEspecie(AJsonObject: TACBrJSONObject);
begin
  if Assigned(ATitulo) then
  begin
    if Assigned(AJsonObject) then
    begin
        if (ATitulo.Vencimento > 0) then
        begin
          AJsonObject.AddPair('especieDocumento',aTitulo.EspecieDoc);
        end;
    end;
  end;
end;

procedure TBoletoW_Bradesco.AtribuirDesconto(AJsonObject: TACBrJSONObject);
begin
  if Assigned(aTitulo) then
  begin
    if Assigned(AJsonObject) then
    begin
      GerarDesconto(AJsonObject);
    end;
  end;
end;

procedure TBoletoW_Bradesco.AlteracaoDesconto(AJsonObject: TACBrJSONObject);
begin
 if Assigned(ATitulo) then
  begin
    if Assigned(AJsonObject) then
    begin
       GerarDesconto(AJsonObject);
    end;
  end;
end;

procedure TBoletoW_Bradesco.AlterarProtesto(AJsonObject: TACBrJSONObject);
begin
  // S� Precisa de Numero de Contrato, Modalidade e Nosso Numero

  // J� preenchidos
end;

end.

