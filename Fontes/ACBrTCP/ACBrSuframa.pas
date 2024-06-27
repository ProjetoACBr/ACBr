{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrSuframa;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils,
  ACBrBase,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  ACBrSocket, ACBrValidador;

type
  EACBrSuframa = class( Exception );

  TACBrSuframaSituacao = class
  private
    FCodigo: Integer;
    function GetDescricao: string;
  public
    constructor Create;
    procedure Clear;
  //published
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: string read GetDescricao;
  end;

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrSuframa = class( TACBrHTTP )
  private
    fOnBuscaEfetuada: TNotifyEvent ;
    FSituacao: TACBrSuframaSituacao;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy ; override;
    procedure ConsultarSituacao(const ASuframa, ACnpj: AnsiString);
  published
    property Situacao: TACBrSuframaSituacao read FSituacao;
    property OnBuscaEfetuada: TNotifyEvent read fOnBuscaEfetuada write fOnBuscaEfetuada;
  end;

implementation

uses
  synautil;

const
  URL_WEBSERVICE = 'https://servicos.suframa.gov.br/cadastroWS/services/CadastroWebService';

{ TACBrSuframaSituacao }

procedure TACBrSuframaSituacao.Clear;
begin
  FCodigo := 0;
end;

constructor TACBrSuframaSituacao.Create;
begin
  Self.Clear;
end;

function TACBrSuframaSituacao.GetDescricao: string;
begin
  case FCodigo of
    0: Result := 'Ocorreu erro na conex�o com o webservice';
    1: Result := 'Empresa n�o habilitada';
    2: Result := 'Empresa habilitada';
    3: Result := 'Empresa n�o encontrada (CNPJ ou a Inscri��o Suframa est�o incorretos ou n�o existem no sistema)';
  else
    Result := 'Descri��o da situa��o ainda n�o implementada';
  end;
end;

{ TACBrSuframa }

constructor TACBrSuframa.Create(AOwner: TComponent);
begin
  inherited;
  FSituacao := TACBrSuframaSituacao.Create;
  fOnBuscaEfetuada := Nil;
end;

destructor TACBrSuframa.Destroy;
begin
  FSituacao.Free;
  inherited;
end;

procedure TACBrSuframa.ConsultarSituacao(const ASuframa, ACnpj: AnsiString);
var
  Acao: String;
  ParametrosConsulta: String;
  ErroCodigo, ErroMsg: String;
  Retorno, aux: String;
begin
  FSituacao.Clear;

  ErroMsg := ValidarSuframa( AnsiString( OnlyNumber( ASuframa ) ) );
  if ErroMsg <> '' then
    raise EACBrSuframa.Create( 'Erro de valida��o: ' + sLineBreak + String( ErroMsg ) );

  if ACnpj <> '' then
  begin
    ErroMsg := ValidarCNPJ( ACNPJ );
    if ErroMsg <> '' then
      raise EACBrSuframa.Create( 'Erro de valida��o: ' + sLineBreak + String( ErroMsg ) );
  end;

  if ACNPJ = '' then
  begin
    ParametrosConsulta :=
      '<con:consultarSituacaoInscsuf soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' +
        '<inscsuf>' + OnlyNumber( ASuframa ) + '</inscsuf>' +
      '</con:consultarSituacaoInscsuf>';
  end
  else
  begin
    ParametrosConsulta :=
      '<con:consultarSituacaoInscCnpj soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' +
        '<cnpj>' + OnlyNumber( ACNPJ ) + '</cnpj>' +
        '<inscsuf>' + OnlyNumber( ASuframa ) + '</inscsuf>' +
      '</con:consultarSituacaoInscCnpj>';
  end;

  Acao :=
    '<?xml version="1.0" encoding="utf-8"?>' +
    '<soapenv:Envelope ' +
      'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
      'xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' +
      'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
      'xmlns:con="http://consultas.ws.cadastro.fucapi.br">' +
      '<soapenv:Header/>' +
      '<soapenv:Body>' + ParametrosConsulta + '</soapenv:Body>' +
    '</soapenv:Envelope>';

  try
    Self.HTTPSend.Clear;
    WriteStrToStream(Self.HTTPSend.Document, Acao);
    Self.HTTPSend.Headers.Add( 'SOAPAction: "' + URL_WEBSERVICE + '"' );
    Self.HTTPPost(URL_WEBSERVICE);

    aux := ParseText(HTTPResponse, True, RespIsUTF8);
    if ACNPJ <> '' then
      Retorno := String(SeparaDados(aux, 'ns1:consultarSituacaoInscCnpjReturn'))
    else
      Retorno := String(SeparaDados(aux, 'ns1:consultarSituacaoInscsufReturn'));

    if Retorno <> '' then
      FSituacao.Codigo := StrToInt(Retorno)
    else
    begin
      ErroCodigo := String(SeparaDados(aux, 'faultcode'));
      if ErroCodigo <> EmptyStr then
      begin
        ErroMsg := String(SeparaDados(aux, 'faultstring'));
        raise EACBrSuframa.Create(ErroCodigo + sLineBreak + '  - ' + ErroMsg);
      end;

      if SameText(aux, Acao) then
        raise EACBrSuframa.Create('Resposta do webservice n�o foi recebida.');
    end;

    if Assigned(fOnBuscaEfetuada) then
      OnBuscaEfetuada( Self );
  except
    on E: Exception do
    begin
      raise EACBrSuframa.Create(
        'Ocorreu o seguinte erro ao consumir o webService Suframa:' + sLineBreak +
        '  - ' + E.Message);
    end;
  end;
end;

end.

