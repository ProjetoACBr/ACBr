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

unit VersaTecnologia.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrNFSeXGravarXml_ABRASFv2;

type
  { TNFSeW_VersaTecnologia200 }

  TNFSeW_VersaTecnologia200 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

  end;

  { TNFSeW_VersaTecnologia201 }

  TNFSeW_VersaTecnologia201 = class(TNFSeW_VersaTecnologia200)
  protected
    procedure Configuracao; override;
  end;

  { TNFSeW_VersaTecnologia202 }

  TNFSeW_VersaTecnologia202 = class(TNFSeW_VersaTecnologia200)
  protected
    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     VersaTecologia
//==============================================================================

{ TNFSeW_VersaTecnologia200 }

procedure TNFSeW_VersaTecnologia200.Configuracao;
begin
  inherited Configuracao;

  DivAliq100 := True;

  NrOcorrValorPis := 1;
  NrOcorrValorCofins := 1;
  NrOcorrValorInss := 1;
  NrOcorrValorIr := 1;
  NrOcorrValorCsll := 1;
  NrOcorrValorIss := 1;
  NrOcorrOutrasRet := 1;
  NrOcorrDescIncond := 1;
  NrOcorrDescCond := 1;
  NrOcorrRespRetencao := 1;
  NrOcorrCodigoPaisServico := 1;
  NrOcorrRazaoSocialInterm := 1;
end;

{ TNFSeW_VersaTecnologia201 }

procedure TNFSeW_VersaTecnologia201.Configuracao;
begin
  inherited Configuracao;

  TagTomador := 'TomadorServico';
end;

{ TNFSeW_VersaTecnologia202 }

procedure TNFSeW_VersaTecnologia202.Configuracao;
begin
  inherited Configuracao;

  TagTomador := 'Tomador';
end;

end.
