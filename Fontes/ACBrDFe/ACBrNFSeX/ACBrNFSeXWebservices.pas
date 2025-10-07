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

unit ACBrNFSeXWebservices;

interface

uses
  Classes, SysUtils,
  ACBrNFSeXWebservicesResponse;

type

  { TWebServices }
  TWebServices = class
  private
    FGerar: TNFSeEmiteResponse;
    FEmite: TNFSeEmiteResponse;
    FConsultaSituacao: TNFSeConsultaSituacaoResponse;
    FConsultaLoteRps: TNFSeConsultaLoteRpsResponse;
    FConsultaNFSeporRps: TNFSeConsultaNFSeporRpsResponse;
    FConsultaNFSe: TNFSeConsultaNFSeResponse;
    FConsultaLinkNFSe: TNFSeConsultaLinkNFSeResponse;
    FCancelaNFSe: TNFSeCancelaNFSeResponse;
    FSubstituiNFSe: TNFSeSubstituiNFSeResponse;
    FGerarToken: TNFSeGerarTokenResponse;
    FEnviarEvento: TNFSeEnviarEventoResponse;
    FConsultarEvento: TNFSeConsultarEventoResponse;
    FConsultarDFe: TNFSeConsultarDFeResponse;
    FConsultarParam: TNFSeConsultarParamResponse;
    FConsultarSeqRps: TNFSeConsultarSeqRpsResponse;
    FObterDANFSE: TNFSeObterDANFSEResponse;

  public
    constructor Create;
    destructor Destroy; override;

    property Gerar: TNFSeEmiteResponse read FGerar;
    property Emite: TNFSeEmiteResponse read FEmite;
    property ConsultaSituacao: TNFSeConsultaSituacaoResponse read FConsultaSituacao;
    property ConsultaLoteRps: TNFSeConsultaLoteRpsResponse read FConsultaLoteRps;
    property ConsultaNFSeporRps: TNFSeConsultaNFSeporRpsResponse read FConsultaNFSeporRps;
    property ConsultaNFSe: TNFSeConsultaNFSeResponse read FConsultaNFSe;
    property ConsultaLinkNFSe: TNFSeConsultaLinkNFSeResponse read FConsultaLinkNFSe;
    property CancelaNFSe: TNFSeCancelaNFSeResponse read FCancelaNFSe;
    property SubstituiNFSe: TNFSeSubstituiNFSeResponse read FSubstituiNFSe;
    property GerarToken: TNFSeGerarTokenResponse read FGerarToken;
    property EnviarEvento: TNFSeEnviarEventoResponse read FEnviarEvento;
    property ConsultarEvento: TNFSeConsultarEventoResponse read FConsultarEvento;
    property ConsultarDFe: TNFSeConsultarDFeResponse read FConsultarDFe;
    property ConsultarParam: TNFSeConsultarParamResponse read FConsultarParam;
    property ConsultarSeqRps: TNFSeConsultarSeqRpsResponse read FConsultarSeqRps;
    property ObterDANFSE: TNFSeObterDANFSEResponse read FObterDANFSE;

  end;

implementation

{ TWebServices }
constructor TWebServices.Create;
begin
  FGerar := TNFSeEmiteResponse.Create;
  FEmite := TNFSeEmiteResponse.Create;
  FConsultaSituacao := TNFSeConsultaSituacaoResponse.Create;
  FConsultaLoteRps := TNFSeConsultaLoteRpsResponse.Create;
  FConsultaNFSeporRps := TNFSeConsultaNFSeporRpsResponse.Create;
  FConsultaNFSe := TNFSeConsultaNFSeResponse.Create;
  FConsultaLinkNFSe := TNFSeConsultaLinkNFSeResponse.Create;
  FCancelaNFSe := TNFSeCancelaNFSeResponse.Create;
  FSubstituiNFSe := TNFSeSubstituiNFSeResponse.Create;
  FGerarToken := TNFSeGerarTokenResponse.Create;
  FEnviarEvento := TNFSeEnviarEventoResponse.Create;
  FConsultarEvento := TNFSeConsultarEventoResponse.Create;
  FConsultarDFe := TNFSeConsultarDFeResponse.Create;
  FConsultarParam := TNFSeConsultarParamResponse.Create;
  FConsultarSeqRps := TNFSeConsultarSeqRpsResponse.Create;
  FObterDANFSE := TNFSeObterDANFSEResponse.Create;
end;

destructor TWebServices.Destroy;
begin
  FGerar.Free;
  FEmite.Free;
  FConsultaSituacao.Free;
  FConsultaLoteRps.Free;
  FConsultaNFSeporRps.Free;
  FConsultaNFSe.Free;
  FConsultaLinkNFSe.Free;
  FCancelaNFSe.Free;
  FSubstituiNFSe.Free;
  FGerarToken.Free;
  FEnviarEvento.Free;
  FConsultarEvento.Free;
  FConsultarDFe.Free;
  FConsultarParam.Free;
  FConsultarSeqRps.Free;
  FObterDANFSE.Free;

  inherited Destroy;
end;

end.
