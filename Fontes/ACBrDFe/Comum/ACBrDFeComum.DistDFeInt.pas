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

unit ACBrDFeComum.DistDFeInt;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrDFe.Conversao,
  pcnConversao;

type

  { TDistDFeInt }

  TDistDFeInt = class
  private
    FtpAmb: TpcnTipoAmbiente;
    FcUFAutor: Integer;
    FCNPJCPF: string;
    FultNSU: string;
    FNSU: string;
    FChave: string;

    FpVersao: string;
    FpNameSpace: string;
    FptagGrupoMsg: string;
    FptagconsChDFe: string;
    FptagchDFe: string;
    FpGerarcUFAutor: Boolean;
  public
    constructor Create(const AVersao, ANameSpace, AtagGrupoMsg, AtagconsChDFe,
      AtagchDFe: string; AGerarcUFAutor: Boolean);
    destructor Destroy; override;

    function GerarXML: string;
    function ObterNomeArquivo: string;

    property tpAmb: TpcnTipoAmbiente read FtpAmb    write FtpAmb;
    property cUFAutor: Integer       read FcUFAutor write FcUFAutor;
    property CNPJCPF: string         read FCNPJCPF  write FCNPJCPF;
    property ultNSU: string          read FultNSU   write FultNSU;
    // Usado no Grupo de informa��es para consultar um DF-e a partir de um
    // NSU espec�fico.
    property NSU: string             read FNSU      write FNSU;
    // Usado no Grupo de informa��es para consultar um DF-e a partir de uma
    // chave espec�fica.
    property Chave: string           read FChave    write FChave;
  end;

implementation

uses
  ACBrDFeConsts,
  ACBrUtil.Strings;

{ TDistDFeInt }

constructor TDistDFeInt.Create(const AVersao, ANameSpace, AtagGrupoMsg,
  AtagconsChDFe, AtagchDFe: string; AGerarcUFAutor: Boolean);
begin
  FpVersao := AVersao;
  FpNameSpace := ANameSpace;
  FptagGrupoMsg := AtagGrupoMsg;
  FptagconsChDFe := AtagconsChDFe;
  FptagchDFe := AtagchDFe;
  FpGerarcUFAutor := AGerarcUFAutor;
end;

destructor TDistDFeInt.Destroy;
begin

  inherited;
end;

function TDistDFeInt.ObterNomeArquivo: string;
begin
  Result := FormatDateTime('yyyymmddhhnnss', Now) + '-con-dist-dfe.xml';
end;

function TDistDFeInt.GerarXML: string;
var
 sNSU, sTagGrupoMsgIni, sTagGrupoMsgFim,
 xUFAutor, xDoc, xConsulta: string;
begin
  sTagGrupoMsgIni := '';
  sTagGrupoMsgFim := '';
  xUFAutor := '';

  if FptagGrupoMsg <> '' then
  begin
    sTagGrupoMsgIni := '<' + FptagGrupoMsg + '>';
    sTagGrupoMsgFim := '</' + FptagGrupoMsg + '>';
  end;

  if FpGerarcUFAutor then
    xUFAutor := '<cUFAutor>' + IntToStr(cUFAutor) + '</cUFAutor>';

  if Length(OnlyAlphaNum(CNPJCPF)) = 14 then
    xDoc := '<CNPJ>' + OnlyAlphaNum(CNPJCPF) + '</CNPJ>'
  else
    xDoc := '<CPF>' + OnlyNumber(CNPJCPF) + '</CPF>';

  if NSU = '' then
  begin
    if Chave = '' then
    begin
      sNSU := Poem_Zeros(StrToIntDef(ultNSU, 0), 15);
      xConsulta := '<distNSU>' + '<ultNSU>' + sNSU + '</ultNSU>' + '</distNSU>';
    end
    else
    begin
      xConsulta := '<' + FptagconsChDFe +'>' +
                     '<' + FptagchDFe + '>' + Chave + '</' + FptagchDFe + '>' +
                   '</' + FptagconsChDFe + '>';
    end;
  end
  else
  begin
    sNSU := Poem_Zeros(StrToIntDef(NSU, 0), 15);
    xConsulta := '<consNSU>' + '<NSU>' + sNSU + '</NSU>' + '</consNSU>';
  end;

  Result := sTagGrupoMsgIni +
              '<distDFeInt ' + FpNameSpace + ' versao="' + FpVersao + '">' +
                '<tpAmb>' + TpAmbToStr(tpAmb) + '</tpAmb>' +
                xUFAutor +
                xDoc +
                xConsulta +
              '</distDFeInt>' +
            sTagGrupoMsgFim;
end;

end.

