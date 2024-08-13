﻿{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibIBGERespostas;

interface

uses
  SysUtils, Classes, ACBrLibResposta, ACBrLibConfig, ACBrIBGE;

type

  { TLibIBGEResposta }
  TLibIBGEResposta = class(TACBrLibRespostaBase)
  private
    FUF: string;
    FCodUF: string;
    FMunicipio: string;
    FCodMunicipio: string;
    FArea: string;
  public
    constructor Create(const AId: Integer; const ATipo: TACBrLibRespostaTipo;
      const AFormato: TACBrLibCodificacao); reintroduce;

    procedure Processar(Item: TACBrIBGECidade);

  published
    property UF: string read FUF write FUF;
    property CodUF: string read FCodUF write FCodUF;
    property Municipio: string read FMunicipio write FMunicipio;
    property CodMunicipio: string read FCodMunicipio write FCodMunicipio;
    property Area: string read FArea write FArea;
  end;

implementation

uses
  ACBrLibIBGEConsts;

{ TLibIBGEResposta }
constructor TLibIBGEResposta.Create(const AId: Integer;
  const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsulta + IntToStr(AId), ATipo, AFormato);
end;

procedure TLibIBGEResposta.Processar(Item: TACBrIBGECidade);
begin
  UF := Item.UF;
  CodUF := IntToStr(Item.CodUF);
  Municipio := Item.Municipio;
  CodMunicipio:= IntToStr(Item.CodMunicipio);
  Area:= FloatToStr(Item.Area);
end;

end.

