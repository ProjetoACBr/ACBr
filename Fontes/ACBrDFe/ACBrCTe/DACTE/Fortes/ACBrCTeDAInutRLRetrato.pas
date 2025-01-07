{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                              Juliomar Marchetti                              }
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

unit ACBrCTeDAInutRLRetrato;


interface

uses
  SysUtils, Variants, Classes, StrUtils,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt,
  {$ELSE}
  Graphics, Controls, Forms, Dialogs, ExtCtrls,
  {$ENDIF}
  ACBrCTe.Classes, pcnConversao, ACBrCTe, ACBrCTeDAInutRL,
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts,
  {$IFDEF BORLAND} DBClient, {$ELSE} BufDataset, {$ENDIF} DB;

type

  { TfrmCTeDAInutRLRetrato }

  TfrmCTeDAInutRLRetrato = class(TfrmCTeDAInutRL)
    rlb_01_Titulo: TRLBand;
    rllProtocolo: TRLLabel;
    rllOrgao: TRLLabel;
    rllDescricao: TRLLabel;
    rlLabel2: TRLLabel;
    rlLabel78: TRLLabel;
    rllModelo: TRLLabel;
    rlb_07_Rodape: TRLBand;
    rlb_03_Inutilizacao: TRLBand;
    rlsLinhaV10: TRLDraw;
    rlsLinhaV09: TRLDraw;
    rlsLinhaH04: TRLDraw;
    rlsLinhaV01: TRLDraw;
    rllLinha3: TRLLabel;
    rllLinha2: TRLLabel;
    rllLinha1: TRLLabel;
    rlShape88: TRLDraw;
    rllTituloEvento: TRLLabel;
    rlShape48: TRLDraw;
    rlLabel9: TRLLabel;
    rllTipoAmbiente: TRLLabel;
    rlLabel6: TRLLabel;
    rllSerie: TRLLabel;
    rlLabel28: TRLLabel;
    rllAno: TRLLabel;
    rlLabel17: TRLLabel;
    rllNumeracao: TRLLabel;
    rlShape49: TRLDraw;
    rlShape50: TRLDraw;
    rlLabel18: TRLLabel;
    rllStatus: TRLLabel;
    rlb_02_Emitente: TRLBand;
    rlsLinhaH07: TRLDraw;
    rlsLinhaH06: TRLDraw;
    rllRazaoEmitente: TRLLabel;
    rllMunEmitente: TRLLabel;
    rllInscEstEmitente: TRLLabel;
    rllEnderecoEmitente: TRLLabel;
    rllCNPJEmitente: TRLLabel;
    rllCEPEmitente: TRLLabel;
    rlLabel98: TRLLabel;
    rlLabel93: TRLLabel;
    rlLabel24: TRLLabel;
    rlLabel22: TRLLabel;
    rlLabel16: TRLLabel;
    rlLabel13: TRLLabel;
    rlLabel12: TRLLabel;
    rlShape51: TRLDraw;
    rlShape53: TRLDraw;
    rlShape82: TRLDraw;
    rlShape99: TRLDraw;
    rlLabel4: TRLLabel;
    rllBairroEmitente: TRLLabel;
    rlShape108: TRLDraw;
    rlLabel5: TRLLabel;
    rllFoneEmitente: TRLLabel;
    rlShape109: TRLDraw;
    rllblSistema: TRLLabel;
    rlShape1: TRLDraw;
    rlLabel15: TRLLabel;
    rlShape2: TRLDraw;
    rlLabel1: TRLLabel;
    rllJustificativa: TRLMemo;
    procedure RLInutBeforePrint(Sender: TObject; var PrintReport: boolean);
    procedure rlb_03_InutilizacaoBeforePrint(Sender: TObject; var PrintBand: boolean);
    procedure rlb_07_RodapeBeforePrint(Sender: TObject; var PrintBand: boolean);
  private
  public
  end;

implementation

uses
  DateUtils, ACBrUtil.Strings, ACBrDFeUtil;

{$IFnDEF FPC}
  {$R *.dfm}

{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmCTeDAInutRLRetrato.RLInutBeforePrint(Sender: TObject;
  var PrintReport: boolean);
begin
  inherited;
  RLCTeInut.Title := ACBrStr('Inutiliza��o');
end;

procedure TfrmCTeDAInutRLRetrato.rlb_03_InutilizacaoBeforePrint(Sender: TObject;
  var PrintBand: boolean);
begin
  inherited;

  with fpInutCTe do
  begin
    rllOrgao.Caption := IntToStr(RetInutCTe.cUF);

    case tpAmb of
      taProducao: rllTipoAmbiente.Caption := ACBrStr('PRODU��O');
      taHomologacao: rllTipoAmbiente.Caption := ACBrStr('HOMOLOGA��O - SEM VALOR FISCAL');
    end;

    rllAno.Caption := IntToStr(RetInutCTe.ano);
    rllModelo.Caption := IntToStr(RetInutCTe.Modelo);
    rllSerie.Caption := IntToStr(RetInutCTe.Serie);
    rllNumeracao.Caption := IntToStr(RetInutCTe.nCTIni) + ' a ' + IntToStr(RetInutCTe.nCTFin);
    rllStatus.Caption := IntToStr(RetInutCTe.cStat) + ' - ' + RetInutCTe.xMotivo;
    rllProtocolo.Caption := RetInutCTe.nProt + ' ' + DateTimeToStr(RetInutCTe.dhRecbto);
    rllJustificativa.Lines.Text := RetInutCTe.xJust;
  end;
end;

procedure TfrmCTeDAInutRLRetrato.rlb_07_RodapeBeforePrint(Sender: TObject;
  var PrintBand: boolean);
begin
  inherited;
  if (fpDACTe.Sistema <> EmptyStr) or (fpDACTe.Usuario <> EmptyStr) then
    rllblSistema.Caption := fpDACTe.Sistema + ' - ' + fpDACTe.Usuario;
end;

end.
