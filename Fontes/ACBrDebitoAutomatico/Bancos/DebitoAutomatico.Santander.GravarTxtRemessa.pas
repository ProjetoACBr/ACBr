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

unit DebitoAutomatico.Santander.GravarTxtRemessa;

interface

uses
  SysUtils, Classes,
  ACBrDebitoAutomaticoClass, Febraban150.GravarTxtRemessa;

type
 { TArquivoW_Santander }

  TArquivoW_Santander = class(TArquivoW_Febraban150)
  protected
    procedure GerarRegistroA; override;
  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrDebitoAutomaticoConversao;

{ TArquivoW_Santander }

procedure TArquivoW_Santander.GerarRegistroA;
begin
  FpLinha := '';

  GravarCampo('A', 1, tcStr);
  GravarCampo(TipoArquivoToStr(DebitoAutomatico.Geral.TipoArquivo), 1, tcStr);
//  GravarCampo(BancoToStr(DebitoAutomatico.Geral.Banco), 3, tcStr); //N�o faz jun��o correta
  GravarCampo(DebitoAutomatico.RegistroA.CodigoConvenio, 20, tcStrZero); //Alterado para 20
  GravarCampo(DebitoAutomatico.RegistroA.NomeEmpresa, 20, tcStr);
  GravarCampo(DebitoAutomatico.RegistroA.CodigoBanco, 3, tcInt);
  GravarCampo(DebitoAutomatico.RegistroA.NomeBanco, 20, tcStr);
  GravarCampo(DebitoAutomatico.RegistroA.Geracao, 8, tcDatISO);
  GravarCampo(DebitoAutomatico.RegistroA.NSA, 6, tcInt);
  GravarCampo(LayoutVersaoToStr(DebitoAutomatico.RegistroA.LayoutVersao), 2, tcStr);
  GravarCampo(IDENTIFICACAOSERVICO, 17, tcStr);
  GravarCampo(' ', 52, tcStr);

  ValidarLinha('A');
  IncluirLinha;
end;

end.
