{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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

unit ACBrDebitoAutomaticoGravarTxt;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrDebitoAutomaticoInterface, ACBrDebitoAutomaticoClass, ACBrDebitoAutomaticoConversao;

type

  TArquivoWClass = class
  private
    FDebitoAutomatico: TDebitoAutomatico;
    FBanco: TBanco;
  protected
    FpAOwner: IACBrDebitoAutomaticoProvider;

    FpLinha: string;
    FConteudoTxt: TStringList;

    procedure Configuracao; virtual;

    procedure GravarCampo(Campo: Variant; Tamanho: Integer;
      Tipo: TTipoCampo; aTirarAcentos: Boolean = False);
 public
    constructor Create(AOwner: IACBrDebitoAutomaticoProvider); virtual;
    destructor Destroy; override;

    function ObterNomeArquivo: String;
    function GerarTxt: Boolean; virtual;
    function ConteudoTxt: String;

    property DebitoAutomatico: TDebitoAutomatico read FDebitoAutomatico write FDebitoAutomatico;
    property Banco: TBanco   read FBanco  write FBanco;
  end;

implementation

uses
  Variants, DateUtils,
  ACBrUtil.Base, ACBrUtil.Strings,
  ACBrDFeException;

{ TArquivoWClass }

constructor TArquivoWClass.Create(AOwner: IACBrDebitoAutomaticoProvider);
begin
  inherited Create;

  FpAOwner := AOwner;

  FConteudoTxt := TStringList.Create;
  FConteudoTxt.Clear;

  Configuracao;
end;

procedure TArquivoWClass.Configuracao;
begin
//  inherited Configuracao;
end;

function TArquivoWClass.ConteudoTxt: String;
begin
  Result := FConteudoTxt.Text;
end;

destructor TArquivoWClass.Destroy;
begin
  FConteudoTxt.Free;

  inherited Destroy;
end;

function TArquivoWClass.ObterNomeArquivo: String;
begin
  Result := '';
end;

function TArquivoWClass.GerarTxt: Boolean;
begin
  Result := False;
  raise EACBrDFeException.Create(ClassName + '.GerarTxt, n�o implementado');
end;

procedure TArquivoWClass.GravarCampo(Campo: Variant; Tamanho: Integer;
  Tipo: TTipoCampo; aTirarAcentos: Boolean = False);
var
  xCampo: string;
  valorDbl: Double;
  xDataHora: TDateTime;
  valorInt, Fator: Integer;
  valorInt64: Int64;
begin
  case Tipo of
    tcStr:
      begin
        xCampo := PadRight(Trim(VarToStr(Campo)), Tamanho);
      end;

    tcStrZero:
      begin
        xCampo := TBStrZero(Trim(VarToStr(Campo)), Tamanho);
      end;

    tcDat:
      begin
        xDataHora := VarToDateTime(Campo);

        if xDataHora = 0 then
          xCampo := '00000000'
        else
          xCampo := FormatDateTime('ddmmyyyy', xDataHora);
      end;

    tcDatISO:
      begin
        xDataHora := VarToDateTime(Campo);

        if xDataHora = 0 then
          xCampo := '00000000'
        else
          xCampo := FormatDateTime('yyyymmdd', xDataHora);
      end;

    tcHor:
      begin
        xDataHora := VarToDateTime(Campo);

        if xDataHora = 0 then
          xCampo := '000000'
        else
          xCampo := FormatDateTime('hhnnss', xDataHora);
      end;

    tcDe2, tcDe5, tcDe8:
      begin
        case Tipo of
          tcDe2: Fator := 100;
          tcDe5: Fator := 100000;
          tcDe8: Fator := 100000000;
        else
          Fator := 1;
        end;

        try
          valorDbl := Campo; // Converte Variant para Double
          xCampo := TBStrZero(FloatToStr(valorDbl * Fator), Tamanho);
        except
          valorDbl := 0;
          xCampo := TBStrZero(FloatToStr(valorDbl), Tamanho);
        end;
      end;

    tcInt:
      begin
        try
          valorInt := StrToInt(VarToStr(Campo));
          xCampo := TBStrZero(IntToStr(valorInt), Tamanho);
        except
          valorInt := 0;
          xCampo := TBStrZero(IntToStr(valorInt), Tamanho);
        end;
      end;

    tcInt64:
      begin
        try
          valorInt64 := StrToInt64(VarToStr(Campo));
          xCampo := TBStrZero(IntToStr(valorInt64), Tamanho);
        except
          valorInt64 := 0;
          xCampo := TBStrZero(IntToStr(valorInt64), Tamanho);
        end;
      end;
  else
    raise Exception.Create('Campo com conte�do inv�lido. ');
  end;

  if aTirarAcentos then
    xCampo := TiraAcentos(xCampo);

  FpLinha := FpLinha + Copy(xCampo, 1, Tamanho);
end;

end.
