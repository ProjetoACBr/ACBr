{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliomar Marchetti                              }
{                              Claudemir Vitor Pereira                         }
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

unit pgnreConsResLoteGNRE;

interface

uses
  SysUtils, Classes,
  ACBrDFeConsts,
  pcnConversao, pcnGerador;

type
  TConsResLoteGNRE = class(TObject)
  private
    FGerador: TGerador;
    Fambiente: TpcnTipoAmbiente;
    FnumeroRecibo: string;
    FIncluirPDFGuias: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: boolean;

    property Gerador: TGerador read FGerador write FGerador;
    property ambiente: TpcnTipoAmbiente read Fambiente write Fambiente;
    property numeroRecibo: string read FnumeroRecibo write FnumeroRecibo;
    property IncluirPDFGuias: Boolean read FIncluirPDFGuias write FIncluirPDFGuias;
  end;

const
  DSC_NREC = 'Numero do recibo';

implementation

{ TConsResLoteGNRE }

constructor TConsResLoteGNRE.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TConsResLoteGNRE.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TConsResLoteGNRE.GerarXML: boolean;
begin
  Gerador.ArquivoFormatoXML := '';

  Gerador.wGrupo('TConsLote_GNRE ' + NAME_SPACE_GNRE);

  Gerador.wCampo(tcStr, '', 'ambiente    ', 01, 01, 1, tpAmbToStr(FAmbiente), DSC_TPAMB);
  Gerador.wCampo(tcNumStr, '', 'numeroRecibo', 10, 14, 1, FnumeroRecibo, DSC_NREC);

  if IncluirPDFGuias then
    Gerador.wCampo(tcStr, '', 'incluirPDFGuias', 1, 1, 1, 'S', '');

  Gerador.wGrupo('/TConsLote_GNRE');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.
 