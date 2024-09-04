{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Andr� Ferreira de Moraes                       }
{                               Wemerson Souto                                 }
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

unit ACBrDFeWebService;

interface

uses
  Classes, SysUtils,
  {$IFNDEF NOGUI}
   {$IFDEF CLX}
     QDialogs,
   {$ELSE}
     {$IFDEF FMX}
       FMX.Dialogs,
     {$ELSE}
       Dialogs,
     {$ENDIF}
   {$ENDIF}
  {$ENDIF}
  ACBrDFeConfiguracoes, ACBrIntegrador, ACBrDFe,
  pcnGerador, ACBrXmlWriter;

const
  CErroSemResposta = 'Erro ao obter resposta do webservice.';

type

  { TDFeWebService }

  TDFeWebService = class
  private
    function TemIntegrador: Boolean;
  protected
    FPSoapVersion: String;
    FPSoapEnvelopeAtributtes: String;
    FPHeaderElement: String;
    FPBodyElement: String;

    FPCabMsg: String;
    FPDadosMsg: String;
    FPEnvelopeSoap: String;
    FPRetornoWS: String;
    FPRetWS: String;
    FPMsg: String;
    FPURL: String;
    FPVersaoServico: String;
    FPConfiguracoes: TConfiguracoes;
    FPDFeOwner: TACBrDFe;
    FPArqEnv: String;
    FPArqResp: String;
    FPServico: String;
    FPSoapAction: String;
    FPMimeType: String;
    FPAuthorizationHeader: string;
    FPValidateReturnCode: Boolean;
  protected
    procedure FazerLog(const Msg: String; Exibir: Boolean = False); virtual;
    procedure GerarException(const Msg: String; E: Exception = nil); virtual;
    procedure AjustarOpcoes(AOpcoes: TGeradorOpcoes); overload;
    procedure AjustarOpcoes(AOpcoes: TACBrXmlWriterOptions); overload;

    procedure InicializarServico; virtual;
    procedure DefinirServicoEAction; virtual;
    procedure DefinirURL; virtual;
    procedure DefinirDadosMsg; virtual;
    procedure DefinirDadosIntegrador; virtual;
    procedure DefinirEnvelopeSoap; virtual;
    procedure SalvarEnvio; virtual;
    procedure EnviarDados; virtual;
    function TratarResposta: Boolean; virtual;
    procedure SalvarResposta; virtual;
    procedure FinalizarServico; virtual;
    procedure VerificarSemResposta; virtual;

    function GetUrlWsd: String; virtual;

    procedure AssinarXML(const AXML, docElement, infElement: String;
      MsgErro: String; const SignatureNode: String = '';
      const SelectionNamespaces: String = ''; const IdSignature: String = '' ); virtual;

    function GerarMsgLog: String; virtual;
    function GerarMsgErro(E: Exception): String; virtual;
    function GerarCabecalhoSoap: String; virtual;
    function GerarVersaoDadosSoap: String; virtual;
    function GerarUFSoap: String; virtual;
    function GerarPrefixoArquivo: String; virtual;
  public
    constructor Create(AOwner: TACBrDFe); virtual;
    procedure Clear; virtual;

    function Executar: Boolean; virtual;

    property SoapVersion: String read FPSoapVersion;
    property SoapEnvelopeAtributtes: String read FPSoapEnvelopeAtributtes;

    property HeaderElement: String read FPHeaderElement;
    property BodyElement: String read FPBodyElement;

    property Servico: String read FPServico;
    property SoapAction: String read FPSoapAction;
    property MimeType: String read FPMimeType;
    property AuthorizationHeader: String read FPAuthorizationHeader;
    property URL: String read FPURL;
    property VersaoServico: String read FPVersaoServico;
    property CabMsg: String read FPCabMsg;
    property DadosMsg: String read FPDadosMsg;
    property EnvelopeSoap: String read FPEnvelopeSoap;
    property RetornoWS: String read FPRetornoWS;
    property RetWS: String read FPRetWS;
    property Msg: String read FPMsg;
    property ArqEnv: String read FPArqEnv;
    property ArqResp: String read FPArqResp;
    property ValidateReturnCode: Boolean read FPValidateReturnCode;
  end;

implementation

uses
  strutils,
  ACBrDFeConsts,
  ACBrDFeUtil, ACBrDFeException,
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  ACBrUtil.XMLHTML,
  synacode;

{ TDFeWebService }

constructor TDFeWebService.Create(AOwner: TACBrDFe);
begin
  FPDFeOwner := AOwner;
  if Assigned(AOwner) then
    FPConfiguracoes := AOwner.Configuracoes;

  FPSoapVersion := 'soap12';
  FPHeaderElement := 'nfeCabecMsg';
  FPBodyElement := 'nfeDadosMsg';
  FPSoapEnvelopeAtributtes :=
    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
    'xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' +
    'xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"';

  FPCabMsg := '';
  FPURL := '';
  FPVersaoServico := '';
  FPArqEnv := '';
  FPArqResp := '';
  FPServico := '';
  FPSoapAction := '';
  FPMimeType := '';  // Vazio, usar� por default: 'application/soap+xml'
  FPAuthorizationHeader := '';
  FPValidateReturnCode := True;

  Clear;
end;

procedure TDFeWebService.Clear;
begin
  FPDadosMsg := '';
  FPRetornoWS := '';
  FPRetWS := '';
  FPMsg := '';
  if TemIntegrador then
    FPDFeOwner.Integrador.Clear;
end;

function TDFeWebService.Executar: Boolean;
var
  ErroMsg: String;
begin
  { Sobrescrever apenas se realmente necess�rio }

  FazerLog('Inicio '+ClassName, False);
  InicializarServico;
  try
    DefinirDadosMsg;
    if TemIntegrador then
      DefinirDadosIntegrador;

    DefinirEnvelopeSoap;
    SalvarEnvio;

    try
      EnviarDados;
      try
        Result := TratarResposta;
      finally
        FazerLog(GerarMsgLog, True);
        SalvarResposta;
      end;
    except
      on E: Exception do
      begin
        Result := False;
        ErroMsg := GerarMsgErro(E);
        GerarException(ErroMsg, E);
      end;
    end;
  finally
    FinalizarServico;
  end;
end;

procedure TDFeWebService.InicializarServico;
begin
  { Sobrescrever apenas se necess�rio }
  Clear;

  DefinirURL;
  if URL = '' then
    GerarException( ACBrStr('URL n�o definida para: ') + ClassName);

  DefinirServicoEAction;
  if Servico = '' then
    GerarException( ACBrStr('Servico n�o definido para: ')+ ClassName);

  if SoapAction = '' then
    GerarException( ACBrStr('SoapAction n�o definido para: ') + ClassName);

  // Alguns provedores de NFS-e n�o possui um SoapAction para os seus servi�os,
  // sendo assim � atribuido o caracter "*" no arquivo INI desses provedores.
  if SoapAction = '*' then
    FPSoapAction := '';
end;

procedure TDFeWebService.DefinirServicoEAction;
begin
  { sobrescrever, OBRIGATORIAMENTE }

  FPServico := '';
  FPSoapAction := '';

  GerarException(ACBrStr('DefinirServicoEAction n�o implementado para: ') + ClassName);
end;

procedure TDFeWebService.DefinirURL;
begin
  { sobrescrever OBRIGATORIAMENTE.
    Voc� tamb�m pode mudar apenas o valor de "FLayoutServico" na classe
    filha e chamar: Inherited;     }

  GerarException(ACBrStr('DefinirURL n�o implementado para: ') + ClassName);
end;


procedure TDFeWebService.DefinirDadosMsg;
begin
  { sobrescrever, OBRIGATORIAMENTE }

  FPDadosMsg := '';

  GerarException(ACBrStr('DefinirDadosMsg n�o implementado para: ') + ClassName);
end;

procedure TDFeWebService.DefinirDadosIntegrador;
begin
  if not TemIntegrador then Exit;

  FPDFeOwner.Integrador.Clear;
  FPDFeOwner.Integrador.Parametros.Values['versaoDados'] := FPVersaoServico;
  FPDFeOwner.Integrador.Parametros.Values['cUF'] := IntToStr(FPConfiguracoes.WebServices.UFCodigo);

  { Sobrescrever nas classes filhas, para informar NomeComponente, NomeMetodo }
end;


procedure TDFeWebService.DefinirEnvelopeSoap;
var
  Texto: String;
begin
  { Sobrescrever apenas se necess�rio }

  {$IFDEF FPC}
   Texto := '<' + ENCODING_UTF8 + '>';    // Envelope j� est� sendo montado em UTF8
  {$ELSE}
   Texto := '';  // Isso for�ar� a convers�o para UTF8, antes do envio
  {$ENDIF}

  Texto := Texto + '<' + FPSoapVersion + ':Envelope ' + FPSoapEnvelopeAtributtes + '>';
  if NaoEstaVazio(FPHeaderElement) then
  begin
    Texto := Texto + '<' + FPSoapVersion + ':Header>';
    Texto := Texto + '<' + FPHeaderElement + ' xmlns="' + Servico + '">';
    Texto := Texto + GerarCabecalhoSoap;
    Texto := Texto + '</' + FPHeaderElement + '>';
    Texto := Texto + '</' + FPSoapVersion + ':Header>';
  end;
  Texto := Texto + '<' + FPSoapVersion + ':Body>';
  Texto := Texto + '<' + FPBodyElement + ' xmlns="' + Servico + '">';
  Texto := Texto + DadosMsg;
  Texto := Texto + '</' + FPBodyElement + '>';
  Texto := Texto + '</' + FPSoapVersion + ':Body>';
  Texto := Texto + '</' + FPSoapVersion + ':Envelope>';

  FPEnvelopeSoap := Texto;
end;

function TDFeWebService.GerarUFSoap: String;
begin
  Result := '<cUF>' + IntToStr(FPConfiguracoes.WebServices.UFCodigo) + '</cUF>';
end;

function TDFeWebService.GerarVersaoDadosSoap: String;
begin
  { sobrescrever, OBRIGATORIAMENTE }

  Result := '';
  GerarException(ACBrStr('GerarVersaoDadosSoap n�o implementado para: ') + ClassName);
end;

procedure TDFeWebService.EnviarDados;
Var
  Tentar, Tratado, TemCertificadoConfigurado: Boolean;
  HTTPResultCode, InternalErrorCode: Integer;
begin
  { Sobrescrever apenas se necess�rio }

  FPRetWS     := '';
  FPRetornoWS := '';

  TemCertificadoConfigurado := (FPConfiguracoes.Certificados.NumeroSerie <> '') or
                               (FPConfiguracoes.Certificados.DadosPFX <> '') or
                               (FPConfiguracoes.Certificados.ArquivoPFX <> '');

  if TemCertificadoConfigurado then
    if FPConfiguracoes.Certificados.VerificarValidade then
       if (FPDFeOwner.SSL.CertDataVenc < Now) then
         raise EACBrDFeException.Create('Data de Validade do Certificado j� expirou: '+
                                            FormatDateBr(FPDFeOwner.SSL.CertDataVenc));

  { Verifica se precisa converter o Envelope para UTF8 antes de ser enviado.
     Entretanto o Envelope pode j� ter sido convertido antes, como por exemplo,
     para assinatura.
     Se o XML est� assinado, n�o deve modificar o conte�do

     Quando FPMimeType = multipart/form-data � bin�rio e n�o deve sofrer encoding
                         Apenas se MimeType for do tipo XML deve tentar converter

     https://www.w3schools.com/tags/att_form_enctype.asp
  }

  if (EstaVazio(FPMimeType) or (Pos('xml',LowerCase(FPMimeType)) > 0 )) and
     ( not XmlEstaAssinado(FPEnvelopeSoap)) and (not EstaVazio(FPEnvelopeSoap)) then
  begin
    FPEnvelopeSoap := ConverteXMLtoUTF8(FPEnvelopeSoap);
  end;

  Tentar := True;
  while Tentar do
  begin
    Tentar  := False;
    Tratado := False;
    FPRetWS     := '';
    FPRetornoWS := '';
    HTTPResultCode := 0;
    InternalErrorCode := 0;

    try
      if Assigned(FPDFeOwner.OnTransmit) then  // Envio por Evento... Aplica��o cuidar� do envio
      begin
        FPDFeOwner.OnTransmit( FPEnvelopeSoap, FPURL, FPSoapAction,
                               FPMimeType, FPRetornoWS, HTTPResultCode, InternalErrorCode);
        if (InternalErrorCode <> 0) then
          raise EACBrDFeException.Create('Erro ao Transmitir');
      end

      else if Assigned( FPDFeOwner.Integrador ) then   // Envio pelo Integrador Fiscal (CE)
      begin
        FPDFeOwner.Integrador.Parametros.Values['dados'] := EncodeBase64(FPEnvelopeSoap);
        FPDFeOwner.Integrador.Enviar(True);
        if (FPDFeOwner.Integrador.Respostas.Count >= 6) then
        begin
          if StrIsBase64(FPDFeOwner.Integrador.Respostas[6]) then
            FPRetornoWS := DecodeBase64(AnsiString(FPDFeOwner.Integrador.Respostas[6]))
          else
            FPRetornoWS := FPDFeOwner.Integrador.Respostas[6];
        end
        else
        begin
          if (FPDFeOwner.Integrador.Respostas.Count >= 2) then
            raise EACBrDFeException.Create(FPDFeOwner.Integrador.Respostas[2])
          else
            raise EACBrDFeException.Create('Resposta do Integrador inv�lida');
        end;
      end

      else   // Envio interno, por TDFeSSL
      begin
        try
          FPRetornoWS := FPDFeOwner.SSL.Enviar(FPEnvelopeSoap, FPURL, FPSoapAction,
                                 FPMimeType, FPAuthorizationHeader, FPValidateReturnCode);
        finally
          HTTPResultCode := FPDFeOwner.SSL.HTTPResultCode;
          InternalErrorCode := FPDFeOwner.SSL.InternalErrorCode;
        end;
      end;
    except
      if Assigned(FPDFeOwner.OnTransmitError) then
        FPDFeOwner.OnTransmitError( HTTPResultCode, InternalErrorCode,
                                    FPURL, FPEnvelopeSoap, FPSoapAction,
                                    Tentar, Tratado) ;

      if not (Tentar or Tratado) then
        raise;
    end;
  end;
end;

function TDFeWebService.GerarPrefixoArquivo: String;
begin
  Result := FormatDateTime('yyyymmddhhnnss', Now);
end;

procedure TDFeWebService.SalvarEnvio;
var
  Prefixo, ArqEnv_temp: String;
  IsUTF8: Boolean;
begin
  { Sobrescrever apenas se necess�rio }

  if FPArqEnv = '' then
    exit;

  Prefixo := GerarPrefixoArquivo;

  if FPConfiguracoes.Geral.Salvar then
  begin
    ArqEnv_temp := Prefixo + '-' + FPArqEnv + '.xml';

    IsUTF8  := XmlEstaAssinado(FPDadosMsg);
    FPDFeOwner.Gravar(ArqEnv_temp, FPDadosMsg, '', IsUTF8);
  end;

  if FPConfiguracoes.WebServices.Salvar then
  begin
    ArqEnv_temp := Prefixo + '-' + FPArqEnv + '-soap.xml';

    IsUTF8  := XmlEstaAssinado(FPEnvelopeSoap);
    FPDFeOwner.Gravar(ArqEnv_temp, FPEnvelopeSoap, '', IsUTF8);
  end;
end;

procedure TDFeWebService.SalvarResposta;
var
  Prefixo, ArqResp_temp: String;
begin
  { Sobrescrever apenas se necess�rio }

  if FPArqResp = '' then
    exit;

  Prefixo := GerarPrefixoArquivo;

  if FPConfiguracoes.Geral.Salvar then
  begin
    ArqResp_temp := Prefixo + '-' + FPArqResp + '.xml';
    FPDFeOwner.Gravar(ArqResp_temp, FPRetWS);  // FPRetWS j� est� em UTF8
  end;

  if FPConfiguracoes.WebServices.Salvar then
  begin
    ArqResp_temp := Prefixo + '-' + FPArqResp + '-soap.xml';
    FPDFeOwner.Gravar(ArqResp_temp, FPRetornoWS );   // FPRetornoWS j� est� em UTF8
  end;
end;

function TDFeWebService.GerarMsgLog: String;
begin
  { sobrescrever, se quiser Logar }

  Result := '';
end;

function TDFeWebService.TratarResposta: Boolean;
begin
  { sobrescrever, OBRIGATORIAMENTE }

  Result := False;
  GerarException(ACBrStr('TratarResposta n�o implementado para: ') + ClassName);
end;

function TDFeWebService.TemIntegrador: Boolean;
begin
  Result := (Assigned(FPDFeOwner) and Assigned(FPDFeOwner.Integrador));
end;

procedure TDFeWebService.FazerLog(const Msg: String; Exibir: Boolean);
var
  Tratado: Boolean;
begin
  if (Msg <> '') then
  begin
    FPDFeOwner.FazerLog(Msg, Tratado);

    if Tratado then
      exit;

    {$IFNDEF NOGUI}
    if Exibir and FPConfiguracoes.WebServices.Visualizar then
      ShowMessage(Msg);
    {$ENDIF}
  end;
end;

procedure TDFeWebService.GerarException(const Msg: String; E: Exception);
begin
  FPDFeOwner.GerarException(Msg, E);
end;

procedure TDFeWebService.AjustarOpcoes(AOpcoes: TGeradorOpcoes);
begin
  AOpcoes.FormatoAlerta := FPDFeOwner.Configuracoes.Geral.FormatoAlerta;
  AOpcoes.RetirarAcentos := FPDFeOwner.Configuracoes.Geral.RetirarAcentos;
  AOpcoes.RetirarEspacos := FPDFeOwner.Configuracoes.Geral.RetirarEspacos;
  AOpcoes.IdentarXML := FPDFeOwner.Configuracoes.Geral.IdentarXML;
  TimeZoneConf.Assign( FPDFeOwner.Configuracoes.WebServices.TimeZoneConf );
  AOpcoes.QuebraLinha := FPDFeOwner.Configuracoes.WebServices.QuebradeLinha;
end;

procedure TDFeWebService.AjustarOpcoes(AOpcoes: TACBrXmlWriterOptions);
begin
  AOpcoes.FormatoAlerta := FPDFeOwner.Configuracoes.Geral.FormatoAlerta;
  AOpcoes.RetirarAcentos := FPDFeOwner.Configuracoes.Geral.RetirarAcentos;
  AOpcoes.RetirarEspacos := FPDFeOwner.Configuracoes.Geral.RetirarEspacos;
  AOpcoes.IdentarXML := FPDFeOwner.Configuracoes.Geral.IdentarXML;
  AOpcoes.QuebraLinha := FPDFeOwner.Configuracoes.WebServices.QuebradeLinha;
end;

function TDFeWebService.GerarMsgErro(E: Exception): String;
begin
  { Sobrescrever com mensagem adicional, se desejar }
  Result := '';
end;

function TDFeWebService.GerarCabecalhoSoap: String;
begin
  { Sobrescrever apenas se necess�rio }

  Result := GerarUFSoap + GerarVersaoDadosSoap;
end;

procedure TDFeWebService.FinalizarServico;
begin
  { Sobrescrever apenas se necess�rio }

end;

procedure TDFeWebService.VerificarSemResposta;
begin
  { Sobrescrever apenas se necess�rio }
  if EstaVazio(FPRetWS) then
    raise EACBrDFeException.Create( CErroSemResposta +
          ifthen(NaoEstaVazio(FPRetornoWS),sLineBreak+
          FPRetornoWS,''));
end;

function TDFeWebService.GetUrlWsd: String;
begin
  Result := FPDFeOwner.GetNameSpaceURI+'/wsdl/';
end;

procedure TDFeWebService.AssinarXML(const AXML, docElement, infElement: String;
  MsgErro: String; const SignatureNode: String; const SelectionNamespaces: String;
  const IdSignature: String);
begin
  try
    FPDadosMsg := FPDFeOwner.SSL.Assinar(AXML, docElement, infElement,
                     SignatureNode, SelectionNamespaces, IdSignature);
  except
    On E: Exception do
    begin
      if NaoEstaVazio(MsgErro) then
        MsgErro := MsgErro + sLineBreak ;

      MsgErro := MsgErro + E.Message;
      GerarException(MsgErro);
    end
  end;
end;

end.

