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

unit ACBrDFeComum.SignatureClass;

interface

uses
  SysUtils, Classes;

type

  { TSignature }

  TSignature = class(TPersistent)
  private
    FURI: string;
    FDigestValue: string;
    FSignatureValue: string;
    FX509Certificate: string;
    FIdSignature: string;
    FIdSignatureValue: string;
  public
    procedure Assign(Source: TPersistent); override;

    function GerarXML: string;

    procedure Clear;
  published
    property URI: string              read FURI              write FURI;
    property DigestValue: string      read FDigestValue      write FDigestValue;
    property SignatureValue: string   read FSignatureValue   write FSignatureValue;
    property X509Certificate: string  read FX509Certificate  write FX509Certificate;
    property IdSignature: string      read FIdSignature      write FIdSignature;
    property IdSignatureValue: string read FIdSignatureValue write FIdSignatureValue;
  end;

implementation

{ TSignature }

procedure TSignature.Clear;
begin
  FURI := '';
  FDigestValue := '';
  FSignatureValue := '';
  FX509Certificate := '';
  FIdSignature := '';
  FIdSignatureValue := '';
end;

function TSignature.GerarXML: string;
begin
  Result :=
  '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#"' + IdSignature + '>' +
    '<SignedInfo>' +
      '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />' +
      '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />' +
      '<Reference URI="' + URI + '">' +
        '<Transforms>' +
          '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />' +
          '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />' +
        '</Transforms>' +
        '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>' +
        '<DigestValue>' + DigestValue + '</DigestValue>' +
      '</Reference>' +
    '</SignedInfo>' +
    '<SignatureValue' + IdSignatureValue + '>' + SignatureValue + '</SignatureValue>' +
    '<KeyInfo>' +
      '<X509Data>' +
        '<X509Certificate>' + X509Certificate + '</X509Certificate>'+
      '</X509Data>' +
    '</KeyInfo>'+
  '</Signature>';
end;

procedure TSignature.Assign(Source: TPersistent);
begin
  if Source is TSignature then
  begin
    URI := TSignature(Source).URI;
    DigestValue := TSignature(Source).DigestValue;
    SignatureValue := TSignature(Source).SignatureValue;
    X509Certificate := TSignature(Source).X509Certificate;
    IdSignature := TSignature(Source).IdSignature;
    IdSignatureValue := TSignature(Source).IdSignatureValue;
  end
  else
    inherited; 
end;

end.

