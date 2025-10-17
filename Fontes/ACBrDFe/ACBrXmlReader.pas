{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Rafael Teno Dias                               }
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

unit ACBrXmlReader;

interface

uses
  Classes, SysUtils,
  ACBrDFe.Conversao,
  ACBrXmlBase,
  ACBrXmlDocument;

type
  { TACBrXmlReader }
  TACBrXmlReader = class
  private
    FArquivo: String;

  protected
    FDocument: TACBrXmlDocument;

  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean; virtual; abstract;
    function CarregarArquivo(const CaminhoArquivo: string): boolean; overload;
    function CarregarArquivo(const Stream: TStream): boolean; overload;
    function ObterCNPJCPF(const ANode: TACBrXmlNode): string;
    function ObterConteudo(const ANode: TACBrXmlNode; const Tipo: TACBrTipoCampo): variant;

    property Document: TACBrXmlDocument read FDocument;
    property Arquivo: String read FArquivo write FArquivo;

  end;

implementation

uses
  synautil;

{ TACBrXmlReader }
constructor TACBrXmlReader.Create;
begin
  FDocument := TACBrXmlDocument.Create();
end;

destructor TACBrXmlReader.Destroy;
begin
  if FDocument <> nil then FDocument.Free;
  inherited Destroy;
end;

function TACBrXmlReader.CarregarArquivo(const CaminhoArquivo: string): boolean;
var
  ArquivoXML: TStringList;
begin
  //NOTA: Carrega o arquivo xml na mem�ria para posterior leitura de sua tag's
  ArquivoXML := TStringList.Create;
  try
    ArquivoXML.LoadFromFile(CaminhoArquivo);
    FArquivo := ArquivoXML.Text;
    Result := True;
  finally
    ArquivoXML.Free;
  end;
end;

function TACBrXmlReader.CarregarArquivo(const Stream: TStream): boolean;
begin
  //NOTA: Carrega o arquivo xml na mem�ria para posterior leitura de sua tag's
  FArquivo := ReadStrFromStream(Stream, Stream.Size);
  Result := True;
end;

function TACBrXmlReader.ObterCNPJCPF(const ANode: TACBrXmlNode): string;
begin
  Result := ObterConteudo(ANode.Childrens.Find('CNPJ'), tcStr);
  if Trim(Result) = '' then
    Result := ObterConteudo(ANode.Childrens.Find('CPF'), tcStr);
end;

function TACBrXmlReader.ObterConteudo(const ANode: TACBrXmlNode;
  const Tipo: TACBrTipoCampo): variant;
begin
  Result := ObterConteudoTag(ANode, Tipo);
end;

end.

