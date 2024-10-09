{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrANe.ProviderProprio;

interface

uses
  SysUtils, Classes,
  ACBrXmlDocument,
  ACBrANe.ProviderBase, ACBrANe.WebServicesResponse;

type

  { TACBrANeProviderProprio }

  TACBrANeProviderProprio = class(TACBrANeProvider)
  protected
    procedure Configuracao; override;

    procedure PrepararEnviar(Response: TANeEnviarResponse); override;
    procedure GerarMsgDadosEnviar(Response: TANeEnviarResponse;
      Params: TANeParamsResponse); override;
    procedure TratarRetornoEnviar(Response: TANeEnviarResponse); override;

    procedure PrepararConsultar(Response: TANeConsultarResponse); override;
    procedure GerarMsgDadosConsultar(Response: TANeConsultarResponse;
      Params: TANeParamsResponse); override;
    procedure TratarRetornoConsultar(Response: TANeConsultarResponse); override;

    function AplicarXMLtoUTF8(const AXMLRps: string): string; virtual;
    function AplicarLineBreak(const AXMLRps: string; const ABreak: string): string; virtual;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TANeWebserviceResponse;
                                     const AListTag: string = 'ListaMensagemRetorno';
                                     const AMessageTag: string = 'MensagemRetorno'); virtual;

  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrANe, ACBrANeDocumentos, ACBrANe.Consts, ACBrANe.Conversao,
  ACBrANe.WebServicesBase;

{ TACBrANeProviderProprio }

procedure TACBrANeProviderProprio.Configuracao;
begin
  inherited Configuracao;

end;

procedure TACBrANeProviderProprio.PrepararEnviar(Response: TANeEnviarResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
  TACBrANe(FAOwner).SetStatus(stANeIdle);
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

procedure TACBrANeProviderProprio.GerarMsgDadosEnviar(
  Response: TANeEnviarResponse; Params: TANeParamsResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrANeProviderProprio.TratarRetornoEnviar(Response: TANeEnviarResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrANeProviderProprio.PrepararConsultar(Response: TANeConsultarResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
  TACBrANe(FAOwner).SetStatus(stANeIdle);
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

procedure TACBrANeProviderProprio.GerarMsgDadosConsultar(
  Response: TANeConsultarResponse; Params: TANeParamsResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrANeProviderProprio.TratarRetornoConsultar(Response: TANeConsultarResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

function TACBrANeProviderProprio.AplicarXMLtoUTF8(const AXMLRps: string): string;
begin
  Result := ConverteXMLtoUTF8(AXMLRps);
end;

function TACBrANeProviderProprio.AplicarLineBreak(const AXMLRps: string; const ABreak: string): string;
begin
  Result := ChangeLineBreak(AXMLRps, ABreak);
end;

procedure TACBrANeProviderProprio.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TANeWebserviceResponse;
  const AListTag: string; const AMessageTag: string);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

end.
