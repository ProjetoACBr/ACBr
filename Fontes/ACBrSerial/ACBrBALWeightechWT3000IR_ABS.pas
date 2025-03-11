{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andre Adami                                     }
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

unit ACBrBALWeightechWT3000IR_ABS;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type

  TACBrBALWeightechWT3000IR_ABS = class(TACBrBALClass)
  private
  public
    constructor Create(AOwner: TComponent);

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end;

implementation

Uses
  SysUtils, ACBrConsts, ACBrBALWeightechWT3000IR_ABS_Fm1Fm2Fm9,
  {$IFDEF COMPILER6_UP}
   DateUtils, StrUtils
  {$ELSE}
   ACBrD5, Windows
  {$ENDIF};

{ TACBrBALWeightechWT3000IR_ABSWT3000IR }

constructor TACBrBALWeightechWT3000IR_ABS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fpModeloStr := 'Weightech WT3000IR_ABS';
end;

function TACBrBALWeightechWT3000IR_ABS.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
begin
  Result := 0;

  if TFormatoFm1Fm2Fm9Util.InterpretarResposta(aResposta, Result) then
  begin
    fpUltimoPesoLido := Result;
    Exit; // caso tenha mais implementa��es futuramente
  end;

end;

end.
