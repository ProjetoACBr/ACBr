{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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
//incluido 05/07/2023

{$I ACBr.inc}

unit ACBrBancoAthenaBradesco;

interface

uses
  Classes, SysUtils, ACBrBoleto, ACBrBancoBradesco;

type

  { TACBrBancoAthenaBradesco }

  TACBrBancoAthenaBradesco = class(TACBrBancoBradesco)
  public
    procedure GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList);  override;
    procedure GerarRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList); override;
  end;

implementation

uses {$IFDEF COMPILER6_UP} dateutils {$ELSE} ACBrD5 {$ENDIF},
   ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.Strings;


procedure TACBrBancoAthenaBradesco.GerarRegistroHeader400(NumeroRemessa: Integer; ARemessa: TStringList);
var
  wLinha: String;
begin
  with ACBrBanco.ACBrBoleto.Cedente do
  begin
    wLinha:= '0'                                                +  { ID do Registro }
             '1'                                                +  { ID do Arquivo( 1 - Remessa) }
             'REMESSA'                                          +  { Literal de Remessa }
             '01'                                               +  { C�digo do Tipo de Servi�o }
             PadRight('COBRANCA', 15)                           +  { Descri��o do tipo de servi�o }
             PadLeft(CodigoCedente, 20, '0')                    +  { Codigo da Empresa no Banco }
             PadRight(Nome, 30)                                 +  { Nome da Empresa }
             IntToStrZero(0, 3)                                 +  { C�digo do Banco 000 }
             PadRight('ATHENABANCO', 15)                        +  { Nome do Banco }
             FormatDateTime('ddmmyy',Now)                       +  { Data de gera��o do arquivo }
             Space(07)                                          +  { brancos }
             PadLeft(fpCodParametroMovimento, 3 )               +  { C�d. Par�m. Movto }
             IntToStrZero(NumeroRemessa, 7)                     +  { Nr. Sequencial de Remessa  }
             Space(277)                                         +  { brancos }
             IntToStrZero(1, 6);                                   { Nr. Sequencial de Remessa + brancos + Contador }

    ARemessa.Add(UpperCase(wLinha));
  end;

end;

procedure TACBrBancoAthenaBradesco.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  LLinha : String;
begin
   LLinha := GerarLinhaRegistroTransacao400(ACBrTitulo, aRemessa);
   LLinha := Copy(LLinha, 1, 20) +  PadLeft('', 17, '0') + Copy(LLinha, 38,LengthNativeString(LLinha));  // 021 a 037 Identificacao da Empresa Cedente no Banco - Preencher com zeros

   aRemessa.Add(UpperCase(LLinha));
end;

end.
