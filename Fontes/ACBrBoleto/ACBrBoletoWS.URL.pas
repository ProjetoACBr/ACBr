{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Victor H Goznales - Pandaa                     }
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

//Incluido em 06/05/2025
{$I ACBr.inc}
unit ACBrBoletoWS.URL;

interface

uses
  ACBrBoletoConversao,
  ACBrBoleto,
  SysUtils;

type
  EACBrBoletoWSException = class(Exception);
  TACBrBoletoWebServiceURL = class
  private
    FBoletoWS: TACBrWebService;
    FURLProducao: String;
    FURLHomologacao: String;
    FURLSandBox: String;
    FPathURI : String;
  public
    constructor Create(ABoletoWS: TACBrWebService);
    function GetURL : String;
    procedure SetPathURI (const APathURI : String);
    procedure Clear;
    property URLProducao: String read FURLProducao write FURLProducao;
    property URLHomologacao: String read FURLHomologacao write FURLHomologacao;
    property URLSandBox: String read FURLSandBox write FURLSandBox;
  end;

implementation

uses
  ACBrUtil;

{ TACBrBoletoWebServiceURL }
procedure TACBrBoletoWebServiceURL.Clear;
begin
  FURLProducao    := '';
  FURLHomologacao := '';
  FURLSandBox     := '';
  FPathURI         := '';
end;

constructor TACBrBoletoWebServiceURL.Create(ABoletoWS: TACBrWebService);
begin
  inherited Create;
  FBoletoWS := ABoletoWS;
  Self.Clear;
end;

function TACBrBoletoWebServiceURL.GetURL : String;
var LURL : String;
begin
  Result := '';

  case FBoletoWS.Ambiente of
    tawsProducao    : LURL := FURLProducao;
    tawsHomologacao : LURL := FURLHomologacao;
    tawsSandBox     : LURL := FURLSandBox;
  end;

  if Trim(LURL) = '' then
    raise EACBrBoletoWSException.Create(Format( 'A URL %s n�o foi definida para o metodo' ,
                                        [AmbienteBoletoWSToStr( FBoletoWS.Ambiente )]));

  Result := LURL + FPathURI;
end;

procedure TACBrBoletoWebServiceURL.SetPathURI(const APathURI: String);
begin
  FPathURI := APathURI;
end;

end.
