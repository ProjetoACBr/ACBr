{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Jefferson                                      }
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

unit ACBrTaxaDolar;

interface

uses
  SysUtils, Classes, ACBrSocket;

type

  EACBrTaxaDolarException = class ( Exception );

  { TACBrTaxaDolar }

  TACBrTaxaDolar = class(TACBrHTTP)
  private
    FTaxaDeVenda: Double;
    FTaxaDeCompra: Double;
    FData: TDateTime;
    FTermoResponsabilidade: String;
  protected
  public
    function Consulta(): Boolean;
  published
    property Data: TDateTime Read FData;
    property TaxaDeCompra: Double Read FTaxaDeCompra;
    property TaxaDeVenda: Double Read FTaxaDeVenda;
    property TermoResponsabilidade : String Read FTermoResponsabilidade;
  end;

implementation

uses
  ACBrUtil.Strings;

function TACBrTaxaDolar.Consulta: Boolean;
var
  Buffer: String;
begin
  Self.HTTPGet('http://www4.bcb.gov.br/pec/taxas/batch/taxas.asp');
  Buffer := StripHTML(DecodeToString(HTTPResponse, RespIsUTF8));

  //DEBUG
  //WriteToTXT( 'c:\temp\bobo.txt', Buffer, False)

  (*Html := StringReplace(Html, #13#10, '', [rfReplaceAll]);

  if Trim(Html) <> '' then
  begin
    Result                 := True;
    Html:= StrEntreStr(Html, '<!--TAG_CONTEUDO_INICIO-->', '<!--TAG_CONTEUDO_FIM-->');
    FConteudoHtml := Html;
    FData                  := GetData;
    FTaxaDeVenda           := GetTaxaDeVenda;
    FTaxaDeCompra          := GetTaxaDeCompra;
    FTermoResponsabilidade := GetTermoResponsabilidade;
    if (FData = 0) then
      raise EACBrTaxaDolarException.Create('N�o foi poss�vel obter os dados.');
  end
  else
  begin
    raise EACBrTaxaDolarException.Create(Html);
  end;*)
end;

end.

function TACBrTaxaDolar.GetData: TDateTime;
var
  S: String;
begin
  S := Html;
  S := StrEntreStr(S, '<td ALIGN="CENTER" class="fundoPadraoBClaro2">', '</td>');
  Result := StrToDate(S);
end;

function TACBrTaxaDolar.GetTaxaDeCompra: Double;
var
  S: String;
begin
  S := Html;
  S := StrEntreStr(S, '<td ALIGN="right" class="fundoPadraoBClaro2">', '</td>');
  Result := StrToFloatDef(S,0);
end;

function TACBrTaxaDolar.GetTaxaDeVenda: Double;
var
  S: String;
begin
  S := Html;
  S := StrPularStr(S, '<td ALIGN="right" class="fundoPadraoBClaro2">');
  S := StrEntreStr(S, '<td ALIGN="right" class="fundoPadraoBClaro2">', '</td>');
  Result := StrToFloatDef(S,0);
end;

function TACBrTaxaDolar.GetTermoResponsabilidade: String;
var
  S: String;
begin
  S := Html;
  S := StrPularStr(S, '</blockquote>');
  S := StrEntreStr(S, '<img src="http://www.bcb.gov.br/img/BulletAzul2.gif" alt=" ">', '</div>');
  S := StringReplace(S, '&nbsp;', '', [rfReplaceAll]);
  Result := S;
end;


function StrPularStr(Str, StrPular: String): String;
  var
    Ini: Integer;
begin
  Ini:= Pos(StrPular, Str);
  if Ini > 0 then
    Result:= Copy(Str, Ini + Length(StrPular), Length(Str))
  else
    Result:= Str;
end;

function StrEntreStr(Str, StrInicial, StrFinal: String; ComecarDe: Integer = 1): String;
var
  Ini, Fim: Integer;
begin
  Ini:= PosEx(StrInicial, Str, ComecarDe) + Length(StrInicial);
  if Ini > 0 then
  begin
    Fim:= PosEx(StrFinal, Str, Ini);
    if Fim > 0 then
      Result:= Copy(Str, Ini, Fim - Ini)
    else
      Result:= '';
  end
  else
    Result:= '';
end;


function GetURLSepara(URL: String): String;
var
  I, R: Integer;
  MyUrl : String;
begin
  MyUrl := URL;
  R:= Length(MyUrl);
  try
    for I := 0 to Length(MyUrl) do
      if Copy(MyUrl, i, 1) = '/' then
        R:= I;
  except
  end;
  Result:= Copy(URL, 1, R);
end;


