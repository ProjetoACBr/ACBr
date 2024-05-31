{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrNFe.ConsSit;

interface

uses
  SysUtils, Classes,
  pcnConversao;

type

  TConsSitNFe = class
  private
    FtpAmb: TpcnTipoAmbiente;
    FchNFe: string;
    FVersao: string;
  public
    constructor Create;
    destructor Destroy; override;

    function GerarXML: string;
    function ObterNomeArquivo: string;

    property tpAmb: TpcnTipoAmbiente read FtpAmb  write FtpAmb;
    property chNFe: string           read FchNFe  write FchNFe;
    property Versao: string          read FVersao write FVersao;
  end;

implementation

uses
  pcnNFeConsts,
  ACBrUtil.Strings;

{ TConsSitNFe }

constructor TConsSitNFe.Create;
begin
  inherited Create;

end;

destructor TConsSitNFe.Destroy;
begin

  inherited;
end;

function TConsSitNFe.ObterNomeArquivo: string;
begin
  Result := OnlyNumber(FchNFe) + '-ped-sit.xml';
end;

function TConsSitNFe.GerarXML: string;
begin
  Result := '<consSitNFe ' + NAME_SPACE + ' versao="' + versao + '">' +
              '<tpAmb>' + tpAmbToStr(tpAmb) + '</tpAmb>' +
              '<xServ>CONSULTAR</xServ>' +
              '<chNFe>' + chNFe + '</chNFe>' +
            '</consSitNFe>';
end;

end.

