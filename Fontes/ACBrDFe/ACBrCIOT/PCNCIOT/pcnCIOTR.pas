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

unit pcnCIOTR;

interface

uses
  SysUtils, Classes,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  ACBrUtil.Strings,
  pcnLeitor, ACBrCIOTConversao, pcnCIOT;

type

  TCIOTR = class(TPersistent)
  private
    FLeitor: TLeitor;
    FCIOT: TCIOT;
  public
    constructor Create(AOwner: TCIOT);
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property CIOT: TCIOT       read FCIOT    write FCIOT;
  end;

implementation

{ TCIOTR }

constructor TCIOTR.Create(AOwner: TCIOT);
begin
  inherited Create;
  FLeitor := TLeitor.Create;
  FCIOT := AOwner;
end;

destructor TCIOTR.Destroy;
begin
  FLeitor.Free;

  inherited Destroy;
end;

function TCIOTR.LerXml: Boolean;
begin
  Leitor.Grupo := Leitor.Arquivo;

//  CIOT.usuario := Leitor.rCampo(tcStr, 'usuario');
//  CIOT.senha   := Leitor.rCampo(tcStr, 'senha');
//  CIOT.codatm  := Leitor.rCampo(tcStr, 'codatm');
//
//  CIOT.xmlDFe := Leitor.rCampo(tcStr, 'xmlCTe');
//
//  if CIOT.xmlDFe = '' then
//    CIOT.xmlDFe := Leitor.rCampo(tcStr, 'xmlNFe');
//
//  if CIOT.xmlDFe = '' then
//    CIOT.xmlDFe := Leitor.rCampo(tcStr, 'xmlMDFe');
//
//  CIOT.xmlDFe := StringReplace(CIOT.xmlDFe, '<![CDATA[', '', [rfReplaceAll]);
//  CIOT.xmlDFe := StringReplace(CIOT.xmlDFe, ']]>', '', [rfReplaceAll]);
//
//  CIOT.aplicacao     := Leitor.rCampo(tcStr, 'aplicacao');
//  CIOT.assunto       := Leitor.rCampo(tcStr, 'assunto');
//  CIOT.remetentes    := Leitor.rCampo(tcStr, 'remetentes');
//  CIOT.destinatarios := Leitor.rCampo(tcStr, 'destinatarios');
//  CIOT.corpo         := Leitor.rCampo(tcStr, 'corpo');
//  CIOT.chave         := Leitor.rCampo(tcStr, 'chave');
//  CIOT.chaveresp     := Leitor.rCampo(tcStr, 'chaveresp');

  Result := True;
end;

end.

