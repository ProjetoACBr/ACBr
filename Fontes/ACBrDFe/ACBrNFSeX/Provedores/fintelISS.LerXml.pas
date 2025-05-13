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

unit fintelISS.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  IniFiles,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_fintelISS200 }

  TNFSeR_fintelISS200 = class(TNFSeR_ABRASFv2)
  protected

  public

  end;

  { TNFSeR_fintelISS202 }

  TNFSeR_fintelISS202 = class(TNFSeR_ABRASFv2)
  protected

    procedure LerINISecaoItemValores(const AINIRec: TMemIniFile); override;
  public

  end;

  { TNFSeR_fintelISS204 }

  TNFSeR_fintelISS204 = class(TNFSeR_ABRASFv2)
  protected

  public

  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrNFSeXClass;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     fintelISS
//==============================================================================

{ TNFSeR_fintelISS202 }

procedure TNFSeR_fintelISS202.LerINISecaoItemValores(
  const AINIRec: TMemIniFile);
var
  i: Integer;
  sSecao, sFim: string;
  Item: TItemServicoCollectionItem;
begin
  i := 1;
  while true do
  begin
    sSecao := 'Itens' + IntToStrZero(i, 3);
    sFim := AINIRec.ReadString(sSecao, 'Descricao', 'FIM');

    if (sFim = 'FIM') then
      break;

    Item := NFSe.Servico.ItemServico.New;

    Item.Descricao := ChangeLineBreak(AINIRec.ReadString(sSecao, 'Descricao', ''), FpAOwner.ConfigGeral.QuebradeLinha);
    Item.ValorTotal := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorTotal', ''), 0);
    Item.ValorDeducoes := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorDeducoes', ''), 0);
    Item.ValorISS := StringToFloatDef(AINIRec.ReadString(sSecao, 'ValorISS', ''), 0);
    Item.Aliquota := StringToFloatDef(AINIRec.ReadString(sSecao, 'Aliquota', ''), 0);
    Item.BaseCalculo := StringToFloatDef(AINIRec.ReadString(sSecao, 'BaseCalculo', ''), 0);

    Inc(i);
  end;
end;

end.
