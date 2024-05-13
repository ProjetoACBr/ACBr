{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Arimateia Jr - https://nuvemfiscal.com.br       }
{                              Victor H. Gonzales - Pandaaa                    }
{                                                                              }
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

unit ACBrSATExtratoUtilsFPDF;

interface

uses
  Classes,
  SysUtils,
  StrUtils,

  pcnCFe,
  pcnConversao,
  ACBrSATExtratoClass,
  StrUtilsEx;

type
  TLogoAlign = (laLeft, laCenter, laRight, laFull);

  TPosRecibo = (prCabecalho, prRodape, prEsquerda);

  TCFeUtilsFPDF = class
  private
    FSATExtratoClassOwner: TACBrSATExtratoClass;
    FCFe: TCFe;
    FFormatSettings: TFormatSettings;
  public
    property SATExtratoClassOwner: TACBrSATExtratoClass read FSATExtratoClassOwner;
    property CFe: TCFe read FCFe;
  public
    constructor Create(ACFe: TCFe; ASATExtratoClassOwner: TACBrSATExtratoClass);
    destructor Destroy; override;
    property FormatSettings: TFormatSettings read FFormatSettings write FFormatSettings;
  end;

implementation

{ TNFeUtilsFPDF }

constructor TCFeUtilsFPDF.Create(ACFe: TCFe; ASATExtratoClassOwner: TACBrSATExtratoClass);
begin
  inherited Create;
  FCFe := ACFe;
  FSATExtratoClassOwner := ASATExtratoClassOwner;
end;

destructor TCFeUtilsFPDF.Destroy;
begin
  inherited;
end;

end.
