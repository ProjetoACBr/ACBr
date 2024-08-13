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

unit ACBrDCe.DACERLRetrato;

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, Qt, QStdCtrls,
  {$ELSE}
  Graphics, Controls, Forms,
  {$ENDIF}
  RLReport,
  {$IFDEF BORLAND}
   {$IF CompilerVersion > 22}
    Vcl.Imaging.jpeg,
   {$ELSE}
    jpeg,
   {$IFEND}
  {$ENDIF}
  ACBrDCe.DACERL, RLBarcode, RLFilters, RLPDFFilter, DB;

type

  { TfrlDADCeRLRetrato }

  TfrmDADCeRLRetrato = class(TfrmDADCeRL)
    rlbIdentificacaoRemDest: TRLBand;
    rliEmitente: TRLDraw;
    RLDraw6: TRLDraw;
    RLDraw8: TRLDraw;
    rliChave3: TRLDraw;
    rlbCabecalhoItens: TRLBand;
    rlbDadosAdicionais: TRLBand;
    rlsRectProdutos: TRLDraw;
    RLDraw50: TRLDraw;
    RLLabel23: TRLLabel;
    RLDraw51: TRLDraw;
    rlsDivProd: TRLDraw;
    rlsDivProd10: TRLDraw;
    RLLabel28: TRLLabel;
    RLLabel29: TRLLabel;
    RLLabel77: TRLLabel;
    RLLabel78: TRLLabel;
    lblQuantidade: TRLLabel;
    rllCidadeRem: TRLLabel;
    rllEnderecoRem: TRLLabel;
    rlmDadosAdicionais: TRLMemo;
    rllEmitente: TRLLabel;
    rlbIdentificacaoFisco: TRLBand;
    RLLabel32: TRLLabel;
    rllNomeFisco: TRLLabel;
    RLLabel33: TRLLabel;
    rllCNPJFisco: TRLLabel;
    RLDraw16: TRLDraw;
    RLDraw19: TRLDraw;
    RLDraw15: TRLDraw;
    rlbValorTotal: TRLBand;
    rllHomologacao: TRLLabel;
    LinhaDCSuperior: TRLDraw;
    LinhaDCInferior: TRLDraw;
    LinhaDCEsquerda: TRLDraw;
    LinhaDCDireita: TRLDraw;
    rllUsuario: TRLLabel;
    rllSistema: TRLLabel;
    RLDraw4: TRLDraw;
    rlbCanceladaDenegada: TRLBand;
    RLLCanceladaDenegada: TRLLabel;
    subItens: TRLSubDetail;
    rlbItens: TRLBand;
    LinhaValorICMS: TRLDraw;
    LinhaDescricao: TRLDraw;
    LinhaFimItens: TRLDraw;
    rlmDescricao: TRLMemo;
    txtCodigo: TRLMemo;
    txtQuantidade: TRLLabel;
    txtValor: TRLLabel;
    LinhaCodigo: TRLDraw;
    LinhaFinal: TRLDraw;
    LinhaItem: TRLDraw;
    rlmDadosFisco: TRLMemo;
    rlbDadosDACE: TRLBand;
    rllDANFE: TRLLabel;
    rllDocumento1: TRLLabel;
    rllDocumento2: TRLLabel;
    rllNumero: TRLLabel;
    rllSerie: TRLLabel;
    rllLastPage: TRLSystemInfo;
    rllPageNumber: TRLSystemInfo;
    RLDraw1: TRLDraw;
    rlbCodigoBarras: TRLBarcode;
    rllXmotivo: TRLLabel;
    rllChave: TRLLabel;
    rliChave2: TRLDraw;
    rllDadosVariaveis3_Descricao: TRLLabel;
    rllDadosVariaveis3: TRLLabel;
    RLDraw25: TRLDraw;
    RLLabel34: TRLLabel;
    rllEmissao: TRLLabel;
    RLLabel38: TRLLabel;
    rllModalidadeTransp: TRLLabel;
    RLDraw26: TRLDraw;
    RLLabel31: TRLLabel;
    rllCNPJRem: TRLLabel;
    RLDraw27: TRLDraw;
    RLLabel4: TRLLabel;
    rllNomeRem: TRLLabel;
    RLLabel9: TRLLabel;
    RLDraw31: TRLDraw;
    RLLabel10: TRLLabel;
    rllCNPJDest: TRLLabel;
    RLDraw9: TRLDraw;
    RLLabel11: TRLLabel;
    rllNomeDest: TRLLabel;
    RLLabel12: TRLLabel;
    rllCidadeDest: TRLLabel;
    RLLabel13: TRLLabel;
    rllEnderecoDest: TRLLabel;
    RLLabel14: TRLLabel;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel5: TRLLabel;
    RLDraw3: TRLDraw;
    RLDraw5: TRLDraw;
    RLLabel6: TRLLabel;
    rllValorTotal: TRLLabel;
    imgQRCode: TRLImage;
    RLDraw2: TRLDraw;
    RLDraw7: TRLDraw;
    RLLabel7: TRLLabel;
    rlmObservacoes: TRLMemo;
    RLDraw10: TRLDraw;

    procedure RLDCeBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLDCeDataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var EOF: Boolean; var RecordAction: TRLRecordAction);

    procedure rlbValorTotalBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbIdentificacaoRemDestBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbItensAfterPrint(Sender: TObject);
    procedure rlbDadosAdicionaisBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure subItensDataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var EOF: Boolean; var RecordAction: TRLRecordAction);
    procedure rlbIdentificacaoFiscoBeforePrint(Sender: TObject;
      var PrintIt: Boolean);
    procedure rlbDadosDACEBeforePrint(Sender: TObject; var PrintIt: Boolean);

  private
    FNumItem: Integer;

    procedure InicializarDados;
  end;

implementation

uses
  DateUtils, StrUtils, Math,
  ACBrDCe.DACERLClass, ACBrDFeUtil, ACBrValidador,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime,
  ACBrDFeReportFortes, ACBrImage, ACBrDelphiZXingQRCode,
  ACBrXmlBase,
  ACBrDCe.Classes, ACBrDCe.Conversao, pcnConversao, ACBrDCe;

{$IfNDef FPC}
 {$R *.dfm}
{$Else}
 {$R *.lfm}
{$EndIf}

procedure TfrmDADCeRLRetrato.RLDCeBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  InicializarDados;

  RLDCe.Title := OnlyNumber(fpDCe.InfDCe.Id);
end;

procedure TfrmDADCeRLRetrato.RLDCeDataRecord(Sender: TObject; RecNo, CopyNo: Integer; var EOF: Boolean; var RecordAction: TRLRecordAction);
begin
  inherited;

  EOF := (RecNo > 1);
  RecordAction := raUseIt;
end;

procedure TfrmDADCeRLRetrato.rlbValorTotalBeforePrint(
  Sender: TObject; var PrintIt: Boolean);
begin
  rllValorTotal.Caption := fpDADCe.FormatarQuantidade(fpDCe.total.vDC);
end;

procedure TfrmDADCeRLRetrato.rlbIdentificacaoFiscoBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  case fpDCe.Ide.tpEmit of
    teFisco:
      begin
        rllCNPJFisco.Caption := FormatarCNPJouCPF(fpDCe.Fisco.CNPJ);
        rllNomeFisco.Caption := fpDCe.Fisco.xOrgao + '/' + fpDCe.Fisco.UF;
      end;

    teMarketplace:
      begin
        rllCNPJFisco.Caption := FormatarCNPJouCPF(fpDCe.Marketplace.CNPJ);
        rllNomeFisco.Caption := fpDCe.Marketplace.xNome;
      end;

    teEmissorProprio:
      begin
        rllCNPJFisco.Caption := FormatarCNPJouCPF(fpDCe.EmpEmisProp.CNPJ);
        rllNomeFisco.Caption := fpDCe.EmpEmisProp.xNome;
      end;

    teTransportadora:
      begin
        rllCNPJFisco.Caption := FormatarCNPJouCPF(fpDCe.Transportadora.CNPJ);
        rllNomeFisco.Caption := fpDCe.Transportadora.xNome;
      end;
  end;
end;

procedure TfrmDADCeRLRetrato.rlbIdentificacaoRemDestBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  rllCNPJRem.Caption := FormatarCNPJouCPF(fpDCe.emit.CNPJCPF);
  rllNomeRem.Caption := fpDCe.emit.xNome;
  rllCidadeRem.Caption := fpDCe.emit.enderEmit.xMun + '/' +
                          fpDCe.emit.enderEmit.UF;
  rllEnderecoRem.Caption := fpDCe.emit.enderEmit.xLgr + ', ' +
                            fpDCe.emit.enderEmit.nro;

  rllCNPJDest.Caption := FormatarCNPJouCPF(fpDCe.dest.CNPJCPF);
  rllNomeDest.Caption := fpDCe.dest.xNome;
  rllCidadeDest.Caption := fpDCe.dest.enderDest.xMun + '/' +
                           fpDCe.dest.enderDest.UF;
  rllEnderecoDest.Caption := fpDCe.dest.enderDest.xLgr + ', ' +
                             fpDCe.dest.enderDest.nro;
end;

procedure TfrmDADCeRLRetrato.InicializarDados;
var
  h, iAlturaCanhoto, vWidthAux, vLeftAux, iAlturaMinLinha: Integer;
  CarregouLogo: Boolean;
begin
  TDFeReportFortes.AjustarMargem(RLDCe, fpDADCe);
  rlbCanceladaDenegada.Visible := False;

  rllSistema.Visible := NaoEstaVazio(fpDADCe.Sistema);
  rllSistema.Caption := fpDADCe.Sistema;

  rllUsuario.Visible := NaoEstaVazio(fpDADCe.Usuario);
  rllUsuario.Caption := ACBrStr('DATA / HORA DA IMPRESS�O: ') + FormatDateTimeBr(Now) +
    ' - ' + fpDADCe.Usuario;

  rllHomologacao.Visible := (fpDCe.Ide.tpAmb = TACBrTipoAmbiente.taHomologacao);
  rllHomologacao.Caption := ACBrStr('AMBIENTE DE HOMOLOGA��O - DC-E SEM VALOR FISCAL');

  rllDadosVariaveis3_Descricao.Visible := True;
  rlbCodigoBarras.Visible := False;

  rllXmotivo.Visible := True;
  rlbCanceladaDenegada.Visible := fpDADCe.Cancelada;

  if rlbCanceladaDenegada.Visible then
  begin
    rllDadosVariaveis3_Descricao.Caption := ACBrStr('PROTOCOLO DE HOMOLOGA��O DE CANCELAMENTO');
    rllXmotivo.Caption := 'DC-e CANCELADA';
    RLLCanceladaDenegada.Caption := 'DC-e CANCELADA';
  end
  else
  begin
    if (fpDCe.procDCe.cStat > 0) then
    begin
      case fpDCe.procDCe.cStat of
        100:
        begin
          rlbCodigoBarras.Visible := True;
          rllXMotivo.Visible := False;
          rllDadosVariaveis3_Descricao.Caption := ACBrStr('PROTOCOLO DE AUTORIZA��O DE USO');
        end;

        101, 135, 151, 155:
        begin
          rllXmotivo.Caption := 'DC-e CANCELADA';
          rllDadosVariaveis3_Descricao.Caption := ACBrStr('PROTOCOLO DE HOMOLOGA��O DE CANCELAMENTO');
          rlbCanceladaDenegada.Visible := True;
          RLLCanceladaDenegada.Caption := 'DC-e CANCELADA';
        end;

        110, 205, 301, 302:
        begin
          rllXmotivo.Caption := 'DC-e DENEGADA';
          rllDadosVariaveis3_Descricao.Caption := ACBrStr('PROTOCOLO DE DENEGA��O DE USO');
          rlbCanceladaDenegada.Visible := True;
          RLLCanceladaDenegada.Caption := 'DC-e DENEGADA';
        end;

        else
        begin
          rllXmotivo.Caption := fpDCe.procDCe.xMotivo;
          rllDadosVariaveis3_Descricao.Visible := False;
          rllDadosVariaveis3.Visible := False;
        end;
      end;
    end
    else
    begin
      if (fpDCe.Ide.tpEmis = TACBrTipoEmissao.teNormal) then
      begin
        rllXmotivo.Caption := ACBrStr('DC-E N�O ENVIADA PARA SEFAZ');
        rllDadosVariaveis3_Descricao.Visible := False;
        rllDadosVariaveis3.Visible := False;
        rllHomologacao.Visible := true;
        rllHomologacao.Caption := ACBrStr('DC-e N�O PROTOCOLADA NA SEFAZ - SEM VALOR FISCAL')
      end;
    end;
  end;
end;

procedure TfrmDADCeRLRetrato.rlbDadosAdicionaisBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  rlmDadosAdicionais.Lines.Clear;
  rlmDadosAdicionais.Lines.Text := StringReplace(fpDCe.infAdic.infCpl, ';', slineBreak, [rfReplaceAll]);

  rlmDadosFisco.Lines.Clear;
  rlmDadosFisco.Lines.Text := StringReplace(fpDCe.infAdic.infAdFisco, ';', slineBreak, [rfReplaceAll]);

  PintarQRCode(fpDCe.infDCeSupl.qrCode, imgQRCode.Picture.Bitmap, qrUTF8NoBOM);

  rlmObservacoes.Lines.Clear;
  rlmObservacoes.Lines.Text := fpDCe.infDec.xObs1 + #13 + fpDCe.infDec.xObs2;
end;

procedure TfrmDADCeRLRetrato.rlbDadosDACEBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  with fpDCe.InfDCe, fpDCe.Ide do
  begin
    rllChave.Caption := FormatarChaveAcesso(fpDCe.InfDCe.Id);
    rllChave.AutoSize := True;

    rlbCodigoBarras.Visible := True;
    rlbCodigoBarras.Caption := OnlyNumber(fpDCe.InfDCe.Id);

    rllNumero.Caption := ACBrStr('N� ') + FormatarNumeroDocumentoFiscal(IntToStr(nDC));
    rllSerie.Caption := ACBrStr('S�RIE ') + PadLeft(IntToStr(Serie), 3, '0');

    rllEmissao.Caption := FormatDateTimeBr(dhEmi);
    rllModalidadeTransp.Caption := ModTransToDesc(fpDCe.transp.modTrans);

    // Configura��o inicial
    rllDadosVariaveis3_Descricao.Caption := ACBrStr('PROTOCOLO DE AUTORIZA��O DE USO');
  end;

  if rlbCodigoBarras.Visible then
    rllChave.Holder := rlbCodigoBarras;
end;

procedure TfrmDADCeRLRetrato.subItensDataRecord(Sender: TObject; RecNo, CopyNo: Integer; var EOF: Boolean; var RecordAction: TRLRecordAction);
begin
  inherited;

  FNumItem := RecNo - 1;
  EOF := (RecNo > fpDCe.Det.Count);
  RecordAction := raUseIt;
end;

procedure TfrmDADCeRLRetrato.rlbItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  with fpDCe.Det[FNumItem] do
  begin
    txtCodigo.Lines.Text := IntToStr(Prod.nItem);
    rlmDescricao.Lines.Text := Prod.xProd;
    txtQuantidade.Caption := fpDADCe.FormatarQuantidade(Prod.qCom);
    txtValor.Caption := fpDADCe.FormatarQuantidade(Prod.vProd);
  end;
end;

procedure TfrmDADCeRLRetrato.rlbItensAfterPrint(Sender: TObject);
begin
  //C�digo removido
end;

end.
