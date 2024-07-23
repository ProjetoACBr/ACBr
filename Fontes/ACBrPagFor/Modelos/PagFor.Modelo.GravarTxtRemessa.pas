{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit PagFor.Modelo.GravarTxtRemessa;

interface

uses
  SysUtils, Classes,
  ACBrPagForClass,
  CNAB240.GravarTxtRemessa;

type
 { TArquivoW_Modelo }

  TArquivoW_Modelo = class(TArquivoW_CNAB240)
  protected
    {
    procedure GeraRegistro0; override;

    procedure GeraRegistro1(I: Integer); override;

    procedure GeraRegistro5(I: Integer); override;

    procedure GeraRegistro9; override;

    procedure GeraSegmentoA(I: Integer); override;

    procedure GeraSegmentoB(mSegmentoBList: TSegmentoBList); override;

    procedure GeraSegmentoC(mSegmentoCList: TSegmentoCList); override;

    procedure GeraSegmentoJ(I: Integer); override;

    procedure GeraSegmentoJ52(mSegmentoJ52List: TSegmentoJ52List); override;

    procedure GeraSegmentoJ53(mSegmentoJ53List: TSegmentoJ53List); override;

    procedure GeraSegmentoN1(I: Integer); override;

    procedure GeraSegmentoN2(I: Integer); override;

    procedure GeraSegmentoN3(I: Integer); override;

    procedure GeraSegmentoN4(I: Integer); override;

    procedure GeraSegmentoN567(I: Integer); override;

    procedure GeraSegmentoN8(I: Integer); override;

    procedure GeraSegmentoN9(I: Integer); override;

    procedure GeraSegmentoO(I: Integer); override;

    procedure GeraSegmentoW(mSegmentoWList: TSegmentoWList); override;

    procedure GeraSegmentoZ(mSegmentoZList: TSegmentoZList); override;
    }
  end;

implementation

end.
