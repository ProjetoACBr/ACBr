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

unit ACBrDFeComum.RetEnvio;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase, ACBrXmlBase;

type

  TInfRec = class(TObject)
  private
    FnRec: string;
    FdhRecbto: TDateTime;
    FtMed: Integer;
  public
    property nRec: string        read FnRec     write FnRec;
    property dhRecbto: TDateTime read FdhRecbto write FdhRecbto;
    property tMed: Integer       read FtMed     write FtMed;
  end;

  TretEnvDFe = class(TObject)
  private
    Fversao: string;
    FtpAmb: TACBrTipoAmbiente;
    FcStat: Integer;
    FcUF: Integer;
    FverAplic: string;
    FxMotivo: string;
    FinfRec: TInfRec;
    FXmlRetorno: string;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;

    property versao: string           read Fversao    write Fversao;
    property tpAmb: TACBrTipoAmbiente read FtpAmb    write FtpAmb;
    property verAplic: string         read FverAplic write FverAplic;
    property cStat: Integer           read FcStat    write FcStat;
    property xMotivo: string          read FxMotivo  write FxMotivo;
    property cUF: Integer             read FcUF      write FcUF;
    property infRec: TInfRec          read FinfRec   write FinfRec;

    property XmlRetorno: string read FXmlRetorno write FXmlRetorno;
  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrXmlDocument;

{ TretEnvDFe }

constructor TretEnvDFe.Create;
begin
  inherited Create;

  FinfRec := TInfREC.Create
end;

destructor TretEnvDFe.Destroy;
begin
  FinfRec.Free;

  inherited;
end;

function TretEnvDFe.LerXml: Boolean;
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
        tpAmb := StrToTipoAmbiente(ok, ObterConteudoTag(Anode.Childrens.FindAnyNs('tpAmb'), tcStr));
        cUF := ObterConteudoTag(Anode.Childrens.FindAnyNs('cUF'), tcInt);
        verAplic := ObterConteudoTag(ANode.Childrens.FindAnyNs('verAplic'), tcStr);
        cStat := ObterConteudoTag(ANode.Childrens.FindAnyNs('cStat'), tcInt);
        xMotivo := ObterConteudoTag(ANode.Childrens.FindAnyNs('xMotivo'), tcStr);

        AuxNode := ANode.Childrens.FindAnyNs('infRec');

        if AuxNode <> nil then
        begin
          infRec.nRec := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nRec'), tcStr);
          infRec.dhRecbto := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('dhRecbto'), tcDatHor);
          infRec.tMed := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('tMed'), tcInt);
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

