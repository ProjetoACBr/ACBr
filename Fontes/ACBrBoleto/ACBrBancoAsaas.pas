{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor Hugo Gonzales - Pandaaa                  }
{                                                                              }
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

//incluido em : 04/10/2025

unit ACBrBancoAsaas;

interface

uses
  ACBrBoleto,
  Classes,
  SysUtils;

type
  { TACBrBancoAsaas }
  EACBrBoletoAsaasException = class(Exception);
  TACBrBancoAsaas = class(TACBrBancoClass)
  protected
    function DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;

  public
    constructor Create(AOwner: TACBrBanco);

    function GerarRegistroHeader240(NumeroRemessa : Integer): String;    override;
    function MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String; override;
    procedure GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList);  override;
    Procedure LerRetorno400(ARetorno:TStringList); override;
    Procedure LerRetorno240(ARetorno:TStringList); override;
    procedure EhObrigatorioAgenciaDV; override;
  end;

implementation

uses
  ACBrUtil.Strings,
  StrUtils, ACBrUtil.Base, ACBrCompress, ACBrJSON, ACBrBoletoWS.URL, synautil;

const METODO_NAO_IMPLEMENTADO = 'ESSE METODO %s %s NÃO ESTÁ IMPLEMENTADO NESSA CLASSE';
{ TACBrBancoAsaas }

constructor TACBrBancoAsaas.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpNome                   := 'ASAAS';
   fpNumero                 := 461;
   fpDigito                 := 8;
   fpTamanhoMaximoNossoNum  := 8;
   fpTamanhoConta           := 6;
   fpTamanhoCarteira        := 2;
end;

function TACBrBancoAsaas.MontarCampoCodigoCedente(
  const ACBrTitulo: TACBrTitulo): String;
begin
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia +
            ' / ' +
            RemoveZerosEsquerda(ACBrTitulo.ACBrBoleto.Cedente.Conta) +
            '-' +
            ACBrTitulo.ACBrBoleto.Cedente.ContaDigito;
end;

function TACBrBancoAsaas.MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String;
begin
  Result := ACBrTitulo.NossoNumero;
end;

function TACBrBancoAsaas.GerarRegistroHeader240(NumeroRemessa: Integer): String;
begin
  raise EACBrBoletoAsaasException.Create(Format(METODO_NAO_IMPLEMENTADO, [ClassName, 'Remessa CNAB240']));
end;

procedure TACBrBancoAsaas.GerarRegistroHeader400(NumeroRemessa: Integer;
  ARemessa: TStringList);
begin
  raise EACBrBoletoAsaasException.Create(Format(METODO_NAO_IMPLEMENTADO, [ClassName, 'Remessa CNAB400']));
end;

procedure TACBrBancoAsaas.LerRetorno240(ARetorno: TStringList);
begin
  raise EACBrBoletoAsaasException.Create(Format(METODO_NAO_IMPLEMENTADO, [ClassName, 'Retorno CNAB240']));
end;

procedure TACBrBancoAsaas.LerRetorno400(ARetorno: TStringList);
begin
  raise EACBrBoletoAsaasException.Create(Format(METODO_NAO_IMPLEMENTADO, [ClassName, 'Retorno CNAB400']));
end;

function TACBrBancoAsaas.DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String;
begin
  Result := '111' + //fixo não falaram o que é na documentação
            Poem_Zeros('0',12) +  //fixo não falaram o que é na documentação
            ACBrTitulo.NossoNumero +
            ACBrTitulo.Carteira; // geralmente 01
end;

procedure TACBrBancoAsaas.EhObrigatorioAgenciaDV;
begin
  // removido a validação
end;

end.


