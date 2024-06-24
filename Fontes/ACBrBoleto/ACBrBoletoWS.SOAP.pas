{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Jos� M S Junior, Victor H Gonzales - Pandaaa   }
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
unit ACBrBoletoWS.SOAP;

interface

uses
  Classes,
  ACBrBoletoWS,
  pcnLeitor,
  pcnGerador,
  ACBrDFeSSL,
  ACBrBoleto;

type
    { TBoletoWSSOAP }    //Bancos que utilizam XML
{$IFDEF RTL230_UP}
  [ ComponentPlatformsAttribute(pidWin32 or pidWin64) ]
{$ENDIF RTL230_UP}

  TBoletoWSSOAP = class(TBoletoWSClass)
  private
    FPHeaderElement: String;

  protected
    FPSoapVersion           : String;
    FPSoapEnvelopeAtributtes: String;
    FPEnvelopeSoap          : String;
    FPURL                   : String;
    FPVersaoServico         : String;
    FPServico               : String;
    FPSoapAction            : String;
    FPContentType           : String;
    FPMimeType              : String;
    FPRootElement           : String;
    FPCloseRootElement      : String;
    FPAuthorization         : String;
    FSSLDigest              : TSSLDgst;
    FSSLHashOutput          : TSSLHashOutput;

    procedure DefinirEnvelopeSoap; virtual;
    procedure DefinirURL; virtual;
    procedure DefinirServicoEAction; virtual;
    procedure DefinirContentType; virtual;
    procedure DefinirMimeType; virtual;
    procedure DefinirRootElement; virtual;
    procedure DefinirAuthorization; virtual;

    procedure GerarHeader; virtual;
    procedure GerarDados; virtual;

    function DefinirSOAPAtributtes: string; virtual;
    function CalcularHash(AAut: String): String; virtual;
    function GerarRemessa: String; override;
    function Enviar: Boolean; override;

    procedure Executar;

  public
    constructor Create(ABoletoWS: TBoletoWS); override;

  end;

    { TRetornoEnvioSOAP }  //Retorno Bancos que utilizam XML
{$IFDEF RTL230_UP}
  [ ComponentPlatformsAttribute(pidWin32 or pidWin64) ]
{$ENDIF RTL230_UP}

  TRetornoEnvioSOAP = class(TRetornoEnvioClass)
  private

  protected
    function RetornoEnvio(const AIndex: Integer): Boolean; Override;
  public
    constructor Create(ABoletoWS: TACBrBoleto); Override;

  end;

implementation

uses
  SysUtils,
  ACBrUtil.Strings,
  pcnConversao,
  synacode,
  synautil,
  ACBrJSON,
  ACBrBoletoConversao,
  ACBrBoletoRetorno,
  dateutils,
  strutils,
  ACBrUtil.Base,
  ACBrUtil.FilesIO,
  ACBrUtil.XMLHTML;
  { TRetornoEnvioSoap }

constructor TRetornoEnvioSOAP.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);
end;

function TRetornoEnvioSOAP.RetornoEnvio(const AIndex: Integer): Boolean;
begin
  leitor.Arquivo := ParseText(RetWS);
  if (ACBrBoleto.ListadeBoletos.Count > 0) then
    Result := LerRetorno(ACBrBoleto.ListadeBoletos[ AIndex ].RetornoWeb)
  else
    Result := LerListaRetorno;
end;

  { TBoletoWSSOAP }

procedure TBoletoWSSOAP.DefinirEnvelopeSoap;
begin
  raise EACBrBoletoWSException.Create(ACBrStr(ClassName + Format(S_METODO_NAO_IMPLEMENTADO, [ C_DEFINIR_ENVELOPE_SOAP ])));
end;

procedure TBoletoWSSOAP.DefinirURL;
begin
  raise EACBrBoletoWSException.Create(ACBrStr(ClassName + Format(S_METODO_NAO_IMPLEMENTADO, [ C_DEFINIR_URL ])));
end;

procedure TBoletoWSSOAP.DefinirServicoEAction;
begin
  raise EACBrBoletoWSException.Create(ACBrStr(ClassName + Format(S_METODO_NAO_IMPLEMENTADO, [ C_DEFINIR_SERVICO_EACTION ])));
end;

function TBoletoWSSOAP.DefinirSOAPAtributtes: string;
begin
  raise EACBrBoletoWSException.Create(ACBrStr(ClassName + Format(S_METODO_NAO_IMPLEMENTADO, [ C_DEFINIR_SERVICO_EACTION ])));
end;

procedure TBoletoWSSOAP.DefinirContentType;
begin
  if FPContentType = '' then
    FPContentType := S_CONTENT_TYPE;
end;

procedure TBoletoWSSOAP.DefinirMimeType;
begin
  if FPMimeType = '' then
    FPMimeType := S_MIME_TYPE;
end;

procedure TBoletoWSSOAP.DefinirRootElement;
begin
  raise EACBrBoletoWSException.Create(ACBrStr(ClassName + Format(S_METODO_NAO_IMPLEMENTADO, [ C_DEFINIR_ROOT_ELEMENT ])));
end;

procedure TBoletoWSSOAP.DefinirAuthorization;
begin
  raise EACBrBoletoWSException.Create(ACBrStr(ClassName + Format(S_METODO_NAO_IMPLEMENTADO, [ C_AUTHORIZATION ])));
end;

procedure TBoletoWSSOAP.GerarHeader;
begin
  raise EACBrBoletoWSException.Create(ACBrStr(ClassName + Format(S_METODO_NAO_IMPLEMENTADO, [ C_GERAR_HEADER ])));
end;

procedure TBoletoWSSOAP.GerarDados;
begin
  raise EACBrBoletoWSException.Create(ACBrStr(ClassName + Format(S_METODO_NAO_IMPLEMENTADO, [ C_GERAR_DADOS ])));
end;

procedure TBoletoWSSOAP.Executar;
var
  Stream: TMemoryStream;
begin
  try
    if FPAuthorization = '' then //Se Existir Autentica��o deve utilizar HTTPMetod, anexando Token de Autoriza��o no Header
      FRetornoWS := DFeSSL.Enviar(FPEnvelopeSoap, FPURL, FPSoapAction, FPMimeType)
    else
    begin
      try
        DFeSSL.SSLHttpClass.Clear;
        DFeSSL.SSLHttpClass.SoapAction := FPSoapAction;
        DFeSSL.SSLHttpClass.MimeType   := FPMimeType;
        with DFeSSL.SSLHttpClass.HeaderReq do
        begin
          Clear;
          Add(FPAuthorization);
          Add(C_CONTENT_TYPE + ': ' + FPContentType);
        end;

        Stream := TMemoryStream.Create;
        try
          WriteStrToStream(Stream, FPEnvelopeSoap);
          DFeSSL.SSLHttpClass.DataReq.LoadFromStream(Stream);
          DFeSSL.HTTPMethod(MetodoHTTPToStr(htPOST), FPURL);
        finally
          Stream.Free;
        end;

      finally
        DFeSSL.SSLHttpClass.DataResp.Position := 0;
        FRetornoWS                            := ReadStrFromStream(DFeSSL.SSLHttpClass.DataResp, DFeSSL.SSLHttpClass.DataResp.Size);

      end;
    end;

  finally
    BoletoWS.RetornoBanco.CodRetorno := DFeSSL.InternalErrorCode;
    BoletoWS.RetornoBanco.Msg        := 'HTTP_Code=' + IntToStr(DFeSSL.HTTPResultCode);

  end;

end;

constructor TBoletoWSSOAP.Create(ABoletoWS: TBoletoWS);
begin
  inherited Create(ABoletoWS);
  FTipoRegistro            := C_XML;
  FPSoapVersion            := S_SOAP_VERSION;
  FPMimeType               := S_MIME_TYPE;
  FPContentType            := S_CONTENT_TYPE;
  FPHeaderElement          := '';
  FPDadosMsg               := '';
  FPRootElement            := '';
  FPCloseRootElement       := '';
  FPEnvelopeSoap           := '';
  FPURL                    := '';
  FPVersaoServico          := '';
  FPServico                := '';
  FPAuthorization          := '';
  FSSLDigest               := dgstSHA256;
  FSSLHashOutput           := outBase64;
  FPSoapAction             := TipoOperacaoToStr(tpInclui);
  FPSoapEnvelopeAtributtes := DefinirSOAPAtributtes;
end;

function TBoletoWSSOAP.CalcularHash(AAut: String): String;
begin
  Result := DFeSSL.CalcHash(AAut, FSSLDigest, FSSLHashOutput);
end;

function TBoletoWSSOAP.GerarRemessa: String;
begin
  Result := '';
  Gerador.ListaDeAlertas.Clear;
  Gerador.ArquivoFormatoXML := '';

    //Gera nameSpace Raiz do XML, implementado na classe do Banco selecionado
  DefinirRootElement;

  if NaoEstaVazio(FPRootElement) then
    Gerador.wGrupo(FPRootElement);

    //Gera o Cabe�alho XML, implementado na classe do Banco selecionado
  GerarHeader;
    //Gera os dados XML, implementado na classe do Banco selecionado
  GerarDados;

  if NaoEstaVazio(FPCloseRootElement) then
    Gerador.wGrupo('/' + FPCloseRootElement);

  FPDadosMsg := Gerador.ArquivoFormatoXML;
  Result     := FPDadosMsg;

end;

function TBoletoWSSOAP.Enviar: Boolean;
begin
  BoletoWS.RetornoBanco.CodRetorno := 0;
  BoletoWS.RetornoBanco.Msg        := '';
  FPAuthorization                  := '';

  DefinirURL;
  DefinirEnvelopeSoap;
  FPEnvelopeSoap := UTF8ToNativeString(FPEnvelopeSoap);
    //Grava xml gerado
  BoletoWS.DoLog('Comando Enviar: ' + Self.ClassName, logSimples);
  BoletoWS.DoLog('Envelope Enviar: ' + FPEnvelopeSoap, logParanoico);

  try
    Executar;
  finally
    Result := (DFeSSL.HTTPResultCode in [ 200, 201, 202 ]);
    BoletoWS.DoLog('Retorno Envio: ' + Self.ClassName, logSimples);
    BoletoWS.DoLog('C�digo do Envio: ' + IntToStr(BoletoWS.RetornoBanco.HTTPResultCode), logSimples);

    if Result then //Grava retorno
      BoletoWS.DoLog('Retorno Envio: ' + FRetornoWS, logParanoico)
    else
      BoletoWS.DoLog('Retorno Envio: ' + IfThen(BoletoWS.RetornoBanco.CodRetorno > 0,
          sLineBreak + 'ErrorCode=' + IntToStr(BoletoWS.RetornoBanco.CodRetorno), '') + sLineBreak + 'Result=' + NativeStringToAnsi(FRetornoWS), logParanoico);
  end;
end;
end.
