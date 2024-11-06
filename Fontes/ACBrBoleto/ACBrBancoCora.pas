{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

//incluido
unit ACBrBancoCora;

interface

uses
  ACBrBoleto,
  Classes,
  SysUtils;

type

  { TACBrBancoCora }
  EACBrBoletoCoraException = class(Exception);
  TACBrBancoCora = class(TACBrBancoClass)
  private
    function MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;
  public
    constructor create(AOwner: TACBrBanco);
    function GerarRegistroHeader240(NumeroRemessa : Integer): String;    override;
    procedure GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList);  override;
    Procedure LerRetorno400(ARetorno:TStringList); override;
    Procedure LerRetorno240(ARetorno:TStringList); override;
    function MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String; override;
  end;

implementation

uses
  ACBrUtil.Strings,
  StrUtils, ACBrUtil.Base;

const METODO_NAO_IMPLEMENTADO = 'ESSE METODO %s %s N�O EST� IMPLEMENTADO NESSA CLASSE';
{ TACBrBancoCora }

constructor TACBrBancoCora.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                 := 9;
   fpNome                   := 'CORA';
   fpNumero                 := 403;
   fpTamanhoMaximoNossoNum  := 10;
   fpTamanhoCarteira        := 2;
end;

function TACBrBancoCora.MontarCampoCodigoCedente(
  const ACBrTitulo: TACBrTitulo): String;
begin
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia;
end;

function TACBrBancoCora.MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String;
begin
  Result := Copy(onlyNumber(ACBrTitulo.ACBrBoleto.Cedente.CNPJCPF), 1, 8)
            + ACBrTitulo.NossoNumero;
end;

function TACBrBancoCora.MontarCodigoBarras(const ACBrTitulo : TACBrTitulo): String;
begin
  Result := IntToStrZero(ACBrTitulo.ACBrBoleto.Banco.Numero, 3)
           + '9'
           + CalcularFatorVencimento(ACBrTitulo.Vencimento)
           + IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10)
           + Poem_Zeros('0',5)
           + MontarCampoNossoNumero(ACBrTitulo)
           + ACBrTitulo.Carteira;
  Result:= Copy( Result, 1, 4) + CalcularDigitoCodigoBarras(Result) + Copy( Result, 5, 44) ;
end;

function TACBrBancoCora.GerarRegistroHeader240(NumeroRemessa: Integer): String;
begin
  raise EACBrBoletoCoraException.Create(Format(METODO_NAO_IMPLEMENTADO, [ClassName, 'Remessa 240']));
end;

procedure TACBrBancoCora.GerarRegistroHeader400(NumeroRemessa: Integer;
  ARemessa: TStringList);
begin
  raise EACBrBoletoCoraException.Create(Format(METODO_NAO_IMPLEMENTADO, [ClassName, 'Remessa 400']));
end;

procedure TACBrBancoCora.LerRetorno240(ARetorno: TStringList);
begin
  raise EACBrBoletoCoraException.Create(Format(METODO_NAO_IMPLEMENTADO, [ClassName, 'Retorno 240']));
end;

procedure TACBrBancoCora.LerRetorno400(ARetorno: TStringList);
begin
  raise EACBrBoletoCoraException.Create(Format(METODO_NAO_IMPLEMENTADO, [ClassName, 'Retorno 400']));
end;

end.


