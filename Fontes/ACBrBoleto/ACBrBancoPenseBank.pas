{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Ederson Selvati                                 }
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

unit ACBrBancoPenseBank;

interface

uses
  Classes, SysUtils, Contnrs,
  ACBrBoleto, ACBrBoletoConversao, ACBrBancoBrasil;

const
  CACBrBancoPense_Versao = '0.0.1';

type
  { TACBrBancoPenseBank}

  TACBrBancoPenseBank = class(TACBrBancoBrasil)
  private
    function FormataNossoNumero(const ACBrTitulo :TACBrTitulo): String; reintroduce;
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo) :string; override;
  public
   Constructor create(AOwner: TACBrBanco);
   function MontarCodigoBarras(const ACBrTitulo : TACBrTitulo): String; override;
   function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String; override;
   function MontarCampoCarteira(const ACBrTitulo: TACBrTitulo): String; override;

  end;

implementation

uses {$IFDEF COMPILER6_UP} DateUtils {$ELSE} ACBrD5, FileCtrl {$ENDIF},
  StrUtils, Variants, ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.Strings,
  ACBrUtil.DateTime, Math;

constructor TACBrBancoPenseBank.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                := 9;
   fpNome                  := 'Pense Bank';
   fpNumero                := 001;
   fpTamanhoMaximoNossoNum := 0;
   fpTamanhoConta          := 12;
   fpTamanhoAgencia        := 4;
   fpTamanhoCarteira       := 2;
   fpCodigosMoraAceitos    := '0123';

end;

function TACBrBancoPenseBank.FormataNossoNumero(const ACBrTitulo: TACBrTitulo): String;
begin
  Result:= '000' + inherited FormataNossoNumero(ACBrTitulo);
end;

function TACBrBancoPenseBank.MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): String;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras :String;
  ANossoNumero, AConvenio: String;
  wTamNossNum: Integer;
begin
   AConvenio    := ACBrTitulo.ACBrBoleto.Cedente.Convenio;
   ANossoNumero := FormataNossoNumero(ACBrTitulo);
   wTamNossNum  := CalcularTamMaximoNossoNumero(ACBrTitulo.Carteira,
                                                ACBrTitulo.NossoNumero);

   {Codigo de Barras}
   with ACBrTitulo.ACBrBoleto do
   begin
      FatorVencimento := CalcularFatorVencimento(ACBrTitulo.Vencimento);

      ANossoNumero := Copy(ANossoNumero,4,Length(ANossoNumero));

      if ((ACBrTitulo.Carteira = '18') or (ACBrTitulo.Carteira = '16')) and
         (Length(AConvenio) = 6) and (wTamNossNum = 17) then
       begin
         CodigoBarras := IntToStrZero(Banco.Numero, 3) +
                         '9' +
                         FatorVencimento +
                         IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10) +
                         AConvenio + ANossoNumero + '21';
       end
      else
       begin
         CodigoBarras := IntToStrZero(Banco.Numero, 3) +
                         '9' +
                         FatorVencimento +
                         IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10) +
                         IfThen((Length(AConvenio) = 7), '000000', '') +
                         ANossoNumero +
                         IfThen((Length(AConvenio) < 7), PadLeft(OnlyNumber(Cedente.Agencia), 4, '0'), '') +
                         IfThen((Length(AConvenio) < 7), IntToStrZero(StrToIntDef(OnlyNumber(Cedente.Conta),0),8), '') +
                         ACBrTitulo.Carteira;
       end;


      DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);
   end;

   Result:= copy( CodigoBarras, 1, 4) + DigitoCodBarras + copy( CodigoBarras, 5, 44) ;
end;

function TACBrBancoPenseBank.MontarCampoCarteira(const ACBrTitulo: TACBrTitulo): String;
begin
  Result := ACBrTitulo.Carteira;
end;

function TACBrBancoPenseBank.MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String;
begin
  Result := Trim(ACBrTitulo.ACBrBoleto.Cedente.Agencia)+'/'+
             IntToStr(StrToIntDef(ACBrTitulo.ACBrBoleto.Cedente.Conta,0)); // mesmo padr�o de impress�o do pense bank
end;

function TACBrBancoPenseBank.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string;
begin
  Result:= '000' + inherited MontarCampoNossoNumero(ACBrTitulo);
end;

end.
