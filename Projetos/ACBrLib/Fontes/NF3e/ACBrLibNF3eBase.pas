{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Antonio Carlos Junior                           }
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

unit ACBrLibNF3eBase;

interface

uses
  Classes, SysUtils, Forms, ACBrUtil.FilesIO,
  ACBrLibComum, ACBrLibNF3eDataModule, ACBrDFeException;

type
  { TACBrLibNF3e }
  TACBrLibNF3e = class(TACBrLib)
    private
      FNF3eDM: TLibNF3eDM;

    protected
      procedure CriarConfiguracao(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
      procedure Executar; Override;

    public
      constructor Create(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
      destructor Destroy; override;

      property NF3eDM: TLibNF3eDM read FNF3eDM;
  end;

implementation

Uses
  ACBrNF3e, ACBrUtil.Base, ACBrUtil.Strings, ACBrDFeUtil, ACBrXmlBase, pcnConversao, ACBrNF3eConversao,
  ACBrLibConsts, ACBrLibConfig, ACBrLibResposta,
  ACBrLibNF3eConsts, ACBrLibNF3eConfig, ACBrLibNF3eRespostas, ACBrLibHelpers, ACBrLibCertUtils;

{ TACBrLibNF3e }

procedure TACBrLibNF3e.CriarConfiguracao(ArqConfig: string;
  ChaveCrypt: ansistring);
begin
  fpConfig := TLibNF3eConfig.Create(Self, ArqConfig, ChaveCrypt);
end;

procedure TACBrLibNF3e.Executar;
begin
  inherited Executar;
  FNF3eDM.AplicarConfiguracoes;
end;

constructor TACBrLibNF3e.Create(ArqConfig: string; ChaveCrypt: ansistring);
begin
  inherited Create(ArqConfig, ChaveCrypt);

  FNF3eDM := TLibNF3eDM.Create(Nil);
  FNF3eDM.Lib := Self;
end;

destructor TACBrLibNF3e.Destroy;
begin
  FNF3eDM.Free;
  inherited Destroy;
end;

end.

