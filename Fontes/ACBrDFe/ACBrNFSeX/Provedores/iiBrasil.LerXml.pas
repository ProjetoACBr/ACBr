{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit iiBrasil.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  IniFiles,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_iiBrasil204 }

  TNFSeR_iiBrasil204 = class(TNFSeR_ABRASFv2)
  protected

    procedure LerINISecaoQuartos(const AINIRec: TMemIniFile); override;
  public

  end;

implementation

uses
  ACBrUtil.Base;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     iiBrasil
//==============================================================================

{ TNFSeR_iiBrasil204 }

procedure TNFSeR_iiBrasil204.LerINISecaoQuartos(const AINIRec: TMemIniFile);
var
  I: Integer;
  sSecao, sFim: string;
begin
  i := 1;
  while true do
  begin
    sSecao := 'Quartos' + IntToStrZero(i, 3);
    sFim := AINIRec.ReadString(sSecao, 'CodigoInternoQuarto', 'FIM');

    if(Length(sFim) <= 0) or (sFim = 'FIM')then
      break;

    with NFSe.Quartos.New do
    begin
      CodigoInternoQuarto := StrToIntDef(sFim, 0);
      QtdHospedes := AINIRec.ReadInteger(sSecao, 'QtdHospedes', 0);
      CheckIn := AINIRec.ReadDateTime(sSecao, 'CheckIn', 0);
      QtdDiarias := AINIRec.ReadInteger(sSecao, 'QtdDiarias', 0);
      ValorDiaria := StrToFloatDef(AINIRec.ReadString(sSecao, 'ValorDiaria', ''), 0);
    end;

    Inc(i);
  end;
end;

end.
