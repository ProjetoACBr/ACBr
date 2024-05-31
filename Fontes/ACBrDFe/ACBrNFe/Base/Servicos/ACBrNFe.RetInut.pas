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

unit ACBrNFe.RetInut;

interface

uses
  SysUtils, Classes,
  pcnConversao,
  ACBrXmlBase;

type

  TRetInutNFe = class(TObject)
  private
    Fversao: string;
    FId: string;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: string;
    FcStat: Integer;
    FxMotivo: string;
    FxJust: string;
    FcUF: Integer;
    Fano: Integer;
    FCNPJ: string;
    FModelo: Integer;
    FSerie: Integer;
    FnNFIni: Integer;
    FnNFFin: Integer;
    FdhRecbto: TDateTime;
    FnProt: string;
    FXmlRetorno: string;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;

    property versao: string          read Fversao   write Fversao;
    property Id: string              read FId       write FId;
    property tpAmb: TpcnTipoAmbiente read FtpAmb    write FtpAmb;
    property verAplic: string        read FverAplic write FverAplic;
    property cStat: Integer          read FcStat    write FcStat;
    property xMotivo: string         read FxMotivo  write FxMotivo;
    property xJust: string           read FxJust    write FxJust;
    property cUF: Integer            read FcUF      write FcUF;
    property ano: Integer            read Fano      write Fano;
    property CNPJ: string            read FCNPJ     write FCNPJ;
    property Modelo: Integer         read FModelo   write FModelo;
    property Serie: Integer          read FSerie    write FSerie;
    property nNFIni: Integer         read FnNFIni   write FnNFIni;
    property nNFFin: Integer         read FnNFFin   write FnNFFin;
    property dhRecbto: TDateTime     read FdhRecbto write FdhRecbto;
    property nProt: string           read FnProt    write FnProt;

    property XmlRetorno: string read FXmlRetorno write FXmlRetorno;
  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrXmlDocument;

{ TRetInutNFe }

constructor TRetInutNFe.Create;
begin
  inherited Create;
end;

destructor TRetInutNFe.Destroy;
begin
  inherited;
end;

function TRetInutNFe.LerXml: Boolean;
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ok: Boolean;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if XmlRetorno = '' then Exit;

      Document.LoadFromXml(XmlRetorno);

      ANode := Document.Root;

      if ANode <> nil then
      begin
        versao := ObterConteudoTag(ANode.Attributes.Items['versao']);

        AuxNode := ANode.Childrens.FindAnyNs('retInutNFe');

        if AuxNode = nil then
          AuxNode := ANode.Childrens.FindAnyNs('infInut');

        if AuxNode <> nil then
        begin
          Id := ObterConteudoTag(AuxNode.Attributes.Items['Id']);
          tpAmb := StrToTpAmb(ok, ObterConteudoTag(AuxNode.Childrens.FindAnyNs('tpAmb'), tcStr));
          verAplic := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('verAplic'), tcStr);
          cStat := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('cStat'), tcInt);
          xMotivo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('xMotivo'), tcStr);
          cUF := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('cUF'), tcInt);
          ano := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('ano'), tcInt);
          CNPJ := ObterConteudoTagCNPJCPF(AuxNode);
          modelo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('mod'), tcInt);
          serie := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('serie'), tcInt);
          nNFIni := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nNFIni'), tcInt);
          nNFFin := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nNFFin'), tcInt);
          dhRecbto := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhRecbto'), tcDatHor);
          nProt := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nProt'), tcStr);
          xJust := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('xJust'), tcStr);
        end;
      end;

      Result := True;
    except
      Result := False;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

end.

