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

unit ACBrDFeComum.Proc;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase;

type

  TProcDFe = class(TObject)
  private
    FpVersao: string;
    FpNameSpace: string;
    FptagGrupo: string;
    FptagDFe: string;

    FPathDFe: string;
    FPathRetConsReciDFe: string;
    FPathRetConsSitDFe: string;

    FId: string;
    FtpAmb: TACBrTipoAmbiente;
    FverAplic: string;
    FchDFe: string;
    FdhRecbto: TDateTime;
    FnProt: string;
    FdigVal: string;
    FcStat: Integer;
    FxMotivo: string;
    FcMsg: Integer;
    FxMsg: string;

    // Usando na Montagem do DFe
    FXML_DFe: string;
    FXML_prot: string;
  public
    constructor Create(const AVersao, ANameSpace, AtagGrupo, AtagDFe: string);
    destructor Destroy; override;

    procedure Assign(Source: TProcDFe);
    function GerarXML: string;

    property PathDFe: string            read FPathDFe            write FPathDFe;
    property PathRetConsReciDFe: string read FPathRetConsReciDFe write FPathRetConsReciDFe;
    property PathRetConsSitDFe: string  read FPathRetConsSitDFe  write FPathRetConsSitDFe;

    property Id: string               read FId       write FId;
    property tpAmb: TACBrTipoAmbiente read FtpAmb    write FtpAmb;
    property verAplic: string         read FverAplic write FverAplic;
    property chDFe: string            read FchDFe    write FchDFe;
    property dhRecbto: TDateTime      read FdhRecbto write FdhRecbto;
    property nProt: string            read FnProt    write FnProt;
    property digVal: string           read FdigVal   write FdigVal;
    property cStat: Integer           read FcStat    write FcStat;
    property xMotivo: string          read FxMotivo  write FxMotivo;
    property cMsg: Integer            read FcMsg     write FcMsg;
    property xMsg: string             read FxMsg     write FxMsg;

    // Usando na Montagem do DFeProc
    property XML_DFe: string  read FXML_DFe  write FXML_DFe;
    property XML_prot: string read FXML_prot write FXML_prot;
  end;

implementation

uses
  ACBrDFeConsts,
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  ACBrXmlDocument;

{ TProcDFe }

constructor TProcDFe.Create(const AVersao, ANameSpace, AtagGrupo, AtagDFe: string);
begin
  inherited Create;

  FpVersao := AVersao;
  FpNameSpace := ANameSpace;
  FptagGrupo := AtagGrupo;
  FptagDFe := AtagDFe;

  FnProt   := '';
end;

destructor TProcDFe.Destroy;
begin

  inherited;
end;

function TProcDFe.GerarXML: string;

  function PreencherTAG(const TAG: string; Texto: string): string;
  begin
    result := '<' + TAG + '>' + RetornarConteudoEntre(Texto, '<' + TAG + '>', '</' + TAG + '>') + '</' + TAG + '>';
  end;

var
  XMLDFe: TStringList;
  XMLinfProt: TStringList;
  XMLinfProt2: TStringList;
  wCstat: string;
  xProtDFe: string;
  nProtLoc: string;
  xUF: string;
  i: Integer;
  ProtLido: Boolean; //Protocolo lido do arquivo
  Document: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
begin
  XMLDFe := TStringList.Create;
  XMLinfProt := TStringList.Create;
  XMLinfProt2 := TStringList.Create;

  try
    if (XML_DFe = '') and (XML_prot = '') then
    begin
      ProtLido := False;
      xProtDFe := '';
      nProt := OnlyNumber(nProt);

      // Arquivo DFe
      if not FileExists(PathDFe) then
        raise Exception.Create(ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
      else
        XMLDFe.LoadFromFile(PathDFe);

      chDFe := RetornarConteudoEntre(XMLDFe.Text, 'Id="' + FptagDFe, '"');

      if trim(chDFe) = '' then
        raise Exception.Create('Numero da chave da DFe:' + ERR_MSG_VAZIO);

      if (PathRetConsReciDFe = '') and (PathRetConsSitDFe = '') then
      begin
        if (chDFe = '') and (nProt = '') then
          raise Exception.Create(ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
        else
          ProtLido := True;
      end;

      // Gerar arquivo pelo Recibo da DFe
      if (PathRetConsReciDFe <> '') and (PathRetConsSitDFe = '') and (not ProtLido) then
      begin
        if not FileExists(PathRetConsReciDFe) then
          raise Exception.Create(ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
        else
        begin
          Document := TACBrXmlDocument.Create;

          try
            XMLinfProt.LoadFromFile(PathRetConsReciDFe);
            XML_prot := XMLinfProt.Text; // carregar o arquivo do disco
            Document.LoadFromXml(XML_prot);

            ANode := Document.Root;

            if ANode <> nil then
            begin
              ANodes := ANode.Childrens.FindAllAnyNs('prot' + FptagDFe);

              for i := 0 to Length(ANodes) - 1 do
              begin
                if ObterConteudoTag(ANodes[i].Childrens.FindAnyNs('ch' + FptagDFe), tcStr) = chDFe then
                  nProt := ObterConteudoTag(ANodes[i].Childrens.FindAnyNs('nProt'), tcStr);

                if Trim(nProt) = '' then
                  raise Exception.Create(ERR_MSG_VAZIO)
                else
                begin
                 xProtDFe := ANodes[i].OuterXml;
                 Break
                end;
              end;
            end;

            FreeAndNil(Document);
            Result := xProtDFe;
          except
            Result := '';
          end;
        end;
      end;

      // Gerar arquivo pelo arquivo de consulta da situa��o da DFe
      if (PathRetConsReciDFe = '') and (PathRetConsSitDFe <> '') and (not ProtLido) then
      begin
        if not FileExists(PathRetConsSitDFe) then
          raise Exception.Create(ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
        else
        begin
          XMLinfProt.LoadFromFile(PathRetConsSitDFe);

          wCstat := RetornarConteudoEntre(XMLinfProt.text, '<cStat>', '</cStat>');

          if ((trim(wCstat) = '101') or
              (trim(wCstat) = '151') or
              (trim(wCstat) = '155')) then //esta cancelada
            XMLinfProt2.Text := RetornarConteudoEntre(XMLinfProt.text, '<infCanc', '</infCanc>')
          else
            XMLinfProt2.Text := RetornarConteudoEntre(XMLinfProt.text, '<infProt', '</infProt>');

          nProtLoc := RetornarConteudoEntre(XMLinfProt2.text, '<nProt>', '</nProt>');

          xProtDFe := '<prot' + FptagDFe + ' versao="' + FpVersao + '">' +
                       '<infProt Id="ID'+ nProtLoc +'">'+
                        PreencherTAG('tpAmb', XMLinfProt.text) +
                        PreencherTAG('verAplic', XMLinfProt.text) +
                        PreencherTAG('ch' + FptagDFe, XMLinfProt.text) +
                        PreencherTAG('dhRecbto', XMLinfProt2.text) +
                        PreencherTAG('nProt', XMLinfProt2.text) +
                        PreencherTAG('digVal', XMLinfProt.text) +
                        PreencherTAG('cStat', XMLinfProt.text) +
                        PreencherTAG('xMotivo', XMLinfProt.text) +
                        PreencherTAG('cMsg', XMLinfProt.text) +
                        PreencherTAG('xMsg', XMLinfProt.text) +
                       '</infProt>' +
                      '</prot' + FptagDFe + '>';
        end;
      end;

      if ProtLido then
      begin
        if Copy(verAplic, 1, 2) = 'SV' then
          xUF := CodigoUFparaUF(StrToIntDef(Copy(chDFe, 1, 2), 0))
        else
          xUF := Copy(verAplic, 1, 2);

        xProtDFe := '<prot' + FptagDFe + ' versao="' + FPVersao + '">' +
                      '<infProt Id="' + 'ID' + nProt + '">' +
                        '<tpAmb>' + TipoAmbienteToStr(tpAmb) + '</tpAmb>' +
                        '<verAplic>' + verAplic + '</verAplic>' +
                        '<ch' + FptagDFe + '>' + chDFe + '</ch' + FptagDFe + '>' +
                        '<dhRecbto>' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', dhRecbto) +
                                       GetUTC(xUF, dhRecbto) +
                        '</dhRecbto>'+
                        '<nProt>' + nProt + '</nProt>' +
                        '<digVal>' + digVal + '</digVal>' +
                        '<cStat>' + IntToStr(cStat) + '</cStat>' +
                        '<xMotivo>' + xMotivo + '</xMotivo>' +
                        '<cMsg>' + IntToStr(cMsg) + '</cMsg>' +
                        '<xMsg>' + xMsg + '</xMsg>' +
                      '</infProt>' +
                    '</prot' + FptagDFe + '>';
      end;

      XML_DFe := XMLDFe.Text;
      XML_prot := xProtDFe;
    end;

    // Gerar arquivo
    if (XML_DFe <> '') and (XML_prot <> '') then
      Result := '<' + FptagGrupo + ' ' + FpNameSpace + ' versao="' + FpVersao + '">' +
                  '<' + FptagDFe + ' xmlns' +
                    RetornarConteudoEntre(FXML_DFe, '<' + FptagDFe + ' xmlns',
                                                    '</' + FptagDFe + '>') +
                  '</' + FptagDFe + '>' +
                  XML_prot +
                '</' + FptagGrupo + '>'
    else
      Result := '';
  finally
    XMLDFe.Free;
    XMLinfProt.Free;
    XMLinfProt2.Free;
  end;
end;

procedure TProcDFe.Assign(Source: TProcDFe);
begin
  PathDFe            := Source.PathDFe;
  PathRetConsReciDFe := Source.PathRetConsReciDFe;
  PathRetConsSitDFe  := Source.PathRetConsSitDFe;

  Id       := Source.Id;
  tpAmb    := Source.tpAmb;
  verAplic := Source.verAplic;
  chDFe    := Source.chDFe;
  dhRecbto := Source.dhRecbto;
  nProt    := Source.nProt;
  digVal   := Source.digVal;
  cStat    := Source.cStat;
  xMotivo  := Source.xMotivo;
  cMsg     := Source.cMsg;
  xMsg     := Source.xMsg;

  XML_DFe  := Source.XML_DFe;
  XML_prot := Source.XML_prot;
end;

end.

