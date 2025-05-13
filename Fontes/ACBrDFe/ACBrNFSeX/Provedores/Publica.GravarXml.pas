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

unit Publica.GravarXml;

interface

uses
  SysUtils, Classes, StrUtils,
  IniFiles,
  ACBrXmlBase,
  ACBrXmlDocument,
  ACBrNFSeXGravarXml_ABRASFv1;

type
  { TNFSeW_Publica }

  TNFSeW_Publica = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

    function GerarCondicaoPagamento: TACBrXmlNode; override;
    function GerarParcelas: TACBrXmlNodeArray; override;

    procedure GerarINISecaoParcelas(const AINIRec: TMemIniFile); override;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrNFSeXConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Publica
//==============================================================================

{ TNFSeW_Publica }

procedure TNFSeW_Publica.Configuracao;
begin
  inherited Configuracao;

  DivAliq100 := True;

  if FpAOwner.ConfigGeral.Params.TemParametro('NaoDividir100') then
    DivAliq100 := False;

  NrOcorrCodigoCnae := -1;
  NrOcorrCodTribMun := -1;

  NrOcorrInformacoesComplemetares := 0;
  NrOcorrRegimeEspecialTributacao := -1;
end;

function TNFSeW_Publica.GerarCondicaoPagamento: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := nil;

  if (NFSe.CondicaoPagamento.Parcelas.Count > 0) then
  begin
    Result := CreateElement('CondicaoPagamento');

    nodeArray := GerarParcelas;
    for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

function TNFSeW_Publica.GerarParcelas: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.CondicaoPagamento.Parcelas.Count);

  for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
  begin
    Result[i] := CreateElement('Parcelas');

    Result[i].AppendChild(AddNode(tcStr, '#53', 'Condicao', 1, 15, 1,
      FpAOwner.CondicaoPagToStr(NFSe.CondicaoPagamento.Parcelas.Items[i].Condicao), DSC_TPAG));

    Result[i].AppendChild(AddNode(tcStr, '#54', 'Parcela', 1, 03, 1,
                  NFSe.CondicaoPagamento.Parcelas.Items[i].Parcela, DSC_NPARC));

    Result[i].AppendChild(AddNode(tcDe2, '#55', 'Valor', 1, 18, 1,
                    NFSe.CondicaoPagamento.Parcelas.Items[i].Valor, DSC_VPARC));

    Result[i].AppendChild(AddNode(tcDat, '#56', 'DataVencimento', 10, 10, 1,
           NFSe.CondicaoPagamento.Parcelas.Items[i].DataVencimento, DSC_DVENC));
  end;

  if NFSe.CondicaoPagamento.Parcelas.Count > 10 then
    wAlerta('#54', 'Parcelas', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

procedure TNFSeW_Publica.GerarINISecaoParcelas(const AINIRec: TMemIniFile);
var
  I: Integer;
  sSecao: string;
begin
  for I := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
  begin
    sSecao:= 'Parcelas' + IntToStrZero(I + 1, 2);

    AINIRec.WriteString(sSecao, 'Parcela', NFSe.CondicaoPagamento.Parcelas.Items[I].Parcela);
    AINIRec.WriteDate(sSecao, 'DataVencimento', NFSe.CondicaoPagamento.Parcelas.Items[I].DataVencimento);
    AINIRec.WriteFloat(sSecao, 'Valor', NFSe.CondicaoPagamento.Parcelas.Items[I].Valor);
    AINIRec.WriteString(sSecao, 'Condicao', FpAOwner.CondicaoPagToStr(NFSe.CondicaoPagamento.Parcelas.Items[I].Condicao));
  end;
end;

end.
