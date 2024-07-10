{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

unit ACBrMDFeDAEventoRLRetrato;

interface

uses
  SysUtils, 
  Variants, 
  Classes, 
  Graphics, 
  Controls, 
  Forms, 
  ExtCtrls,
  RLReport, 
  RLPDFFilter, 
  RLBarcode, 
  RLFilters,
  ACBrMDFeDAEventoRL, 
  ACBrDFeReportFortes,
  pcnConversao, 
  DB;

type

  { TfrmMDFeDAEventoRLRetrato }

  TfrmMDFeDAEventoRLRetrato = class(TfrmMDFeDAEventoRL)
    RLBarcode1: TRLBarcode;
    rlb_09_Itens: TRLBand;
    rldbtTpDoc1: TRLDBText;
    rldbtCnpjEmitente1: TRLDBText;
    rldbtDocumento1: TRLDBText;
    rldbtDocumento2: TRLDBText;
    rldbtCnpjEmitente2: TRLDBText;
    rldbtTpDoc2: TRLDBText;
    rlb_01_Titulo: TRLBand;
    rllProtocolo: TRLLabel;
    rllOrgao: TRLLabel;
    rllDescricao: TRLLabel;
    rlLabel2: TRLLabel;
    rlLabel78: TRLLabel;
    rllDescricaoEvento: TRLLabel;
    rlb_08_HeaderItens: TRLBand;
    rlb_10_Sistema: TRLBand;
    rlb_05_Evento: TRLBand;
    rlLabel13: TRLLabel;
    rlLabel16: TRLLabel;
    rlLabel22: TRLLabel;
    rlLabel24: TRLLabel;
    rllRazaoEmitente: TRLLabel;
    rllEnderecoEmitente: TRLLabel;
    rllMunEmitente: TRLLabel;
    rllCNPJEmitente: TRLLabel;
    rlLabel93: TRLLabel;
    rllInscEstEmitente: TRLLabel;
    rllCEPEmitente: TRLLabel;
    rlLabel98: TRLLabel;
    rlb_03_Emitente: TRLBand;
    rlb_04_Tomador: TRLBand;
    rlb_06_Descricao: TRLBand;
    rlLabel38: TRLLabel;
    rlLabel44: TRLLabel;
    rlmGrupoAlterado: TRLMemo;
    rlLabel46: TRLLabel;
    rlmCampoAlterado: TRLMemo;
    rlLabel42: TRLLabel;
    rlmValorAlterado: TRLMemo;
    rlLabel45: TRLLabel;
    rlmNumItemAlterado: TRLMemo;
    rlShape18: TRLDraw;
    rlShape17: TRLDraw;
    rlShape15: TRLDraw;
    rlShape19: TRLDraw;
    rlLabel59: TRLLabel;
    rlShape5: TRLDraw;
    rlmDescricao: TRLMemo;
    rlsQuadro01: TRLDraw;
    rlsQuadro02: TRLDraw;
    rlsQuadro04: TRLDraw;
    rlsQuadro05: TRLDraw;
    rlsLinhaV10: TRLDraw;
    rlsLinhaV09: TRLDraw;
    rlsLinhaH04: TRLDraw;
    rlsLinhaV01: TRLDraw;
    rlsLinhaH06: TRLDraw;
    rlsLinhaH07: TRLDraw;
    rlShape10: TRLDraw;
    rlLabel65: TRLLabel;
    rlShape2: TRLDraw;
    rlb_07_Correcao: TRLBand;
    rlShape46: TRLDraw;
    rllLinha3: TRLLabel;
    rllLinha2: TRLLabel;
    rllLinha1: TRLLabel;
    rlb_02_Documento: TRLBand;
    rlShape81: TRLDraw;
    rlShape88: TRLDraw;
    rlsQuadro03: TRLDraw;
    rlLabel8: TRLLabel;
    rllModelo: TRLLabel;
    rlLabel21: TRLLabel;
    rllSerie: TRLLabel;
    rlLabel23: TRLLabel;
    rllNumMDFe: TRLLabel;
    rlsLinhaV05: TRLDraw;
    rlsLinhaV06: TRLDraw;
    rlsLinhaV08: TRLDraw;
    rlLabel33: TRLLabel;
    rllEmissao: TRLLabel;
    rlsLinhaV07: TRLDraw;
    rlLabel74: TRLLabel;
    rllChave: TRLLabel;
    rllTituloEvento: TRLLabel;
    rlShape48: TRLDraw;
    rlLabel9: TRLLabel;
    rllTipoAmbiente: TRLLabel;
    rlLabel6: TRLLabel;
    rllEmissaoEvento: TRLLabel;
    rlLabel28: TRLLabel;
    rllTipoEvento: TRLLabel;
    rlLabel17: TRLLabel;
    rllSeqEvento: TRLLabel;
    rlShape49: TRLDraw;
    rlShape50: TRLDraw;
    rlLabel18: TRLLabel;
    rllStatus: TRLLabel;
    rlLabel12: TRLLabel;
    rlShape51: TRLDraw;
    rlLabel1: TRLLabel;
    rlShape52: TRLDraw;
    rlShape53: TRLDraw;
    rlShape82: TRLDraw;
    rlShape99: TRLDraw;
    rlLabel4: TRLLabel;
    rllBairroEmitente: TRLLabel;
    rlShape108: TRLDraw;
    rlLabel5: TRLLabel;
    rllFoneEmitente: TRLLabel;
    rlShape109: TRLDraw;
    rlLabel14: TRLLabel;
    rllRazaoTomador: TRLLabel;
    rlLabel25: TRLLabel;
    rllEnderecoTomador: TRLLabel;
    rlLabel27: TRLLabel;
    rllMunTomador: TRLLabel;
    rlLabel30: TRLLabel;
    rllCNPJTomador: TRLLabel;
    rlLabel32: TRLLabel;
    rllBairroTomador: TRLLabel;
    rlLabel35: TRLLabel;
    rllCEPTomador: TRLLabel;
    rlLabel37: TRLLabel;
    rllFoneTomador: TRLLabel;
    rlLabel40: TRLLabel;
    rllInscEstTomador: TRLLabel;
    rlShape7: TRLDraw;
    rlShape8: TRLDraw;
    rlShape9: TRLDraw;
    rlShape55: TRLDraw;
    rlShape56: TRLDraw;
    rlShape58: TRLDraw;
    rlShape59: TRLDraw;
    rllMsgTeste: TRLLabel;
    rlLabel15: TRLLabel;
    rlSysData1: TRLSysteminfo;
    rllblSistema: TRLLabel;
    procedure rlEventoBeforePrint(Sender: TObject; var PrintReport: boolean);
    procedure rlb_01_TituloBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_02_DocumentoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_05_EventoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_03_EmitenteBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_04_TomadorBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_06_DescricaoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_07_CorrecaoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_08_HeaderItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_09_ItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_10_SistemaBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    procedure Itens;

  end;

implementation

uses
  DateUtils,
  ACBrDFeUtil,
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrValidador;

{$ifdef FPC}
 {$R *.lfm}
{$else}
 {$R *.dfm}
{$endif}

procedure TfrmMDFeDAEventoRLRetrato.Itens;
begin
  // Itens
end;

procedure TfrmMDFeDAEventoRLRetrato.rlEventoBeforePrint(Sender: TObject; var PrintReport: boolean);
begin
  inherited;

  Itens;

  RLMDFeEvento.Title := 'Evento: ' + FormatFloat('000,000,000', fpEventoMDFe.InfEvento.nSeqEvento);
  TDFeReportFortes.AjustarMargem(RLMDFeEvento, fpDAMDFe);
end;

procedure TfrmMDFeDAEventoRLRetrato.rlb_01_TituloBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  case fpEventoMDFe.InfEvento.tpEvento of
    teCancelamento:
    begin
      rllLinha1.Caption := 'CANCELAMENTO';
      rllLinha2.Caption := ACBrStr(
        'N�o possui valor fiscal, simples representa��o do Cancelamento indicado abaixo.');
      rllLinha3.Caption := 'CONSULTE A AUTENTICIDADE DO CANCELAMENTO NO SITE DA SEFAZ AUTORIZADORA.';
    end;

    teEncerramento:
    begin
      rllLinha1.Caption := 'ENCERRAMENTO';
      rllLinha2.Caption := ACBrStr(
        'N�o possui valor fiscal, simples representa��o do Encerramento indicado abaixo.');
      rllLinha3.Caption := 'CONSULTE A AUTENTICIDADE DO ENCERRAMENTO NO SITE DA SEFAZ AUTORIZADORA.';
    end;

    teInclusaoCondutor:
    begin
      rllLinha1.Caption := ACBrStr('INCLUS�O DE CONDUTOR');
      rllLinha2.Caption := ACBrStr(
        'N�o possui valor fiscal, simples representa��o da Inclus�o de Condutor indicada abaixo.');
      rllLinha3.Caption := ACBrStr(
        'CONSULTE A AUTENTICIDADE DA INCLUS�O DE CONDUTOR NO SITE DA SEFAZ AUTORIZADORA.');
    end;

    teInclusaoDFe:
    begin
      rllLinha1.Caption := ACBrStr('INCLUS�O DE DOCUMENTOS FISCAIS ELETR�NICOS');
      rllLinha2.Caption := ACBrStr(
        'N�o possui valor fiscal, simples representa��o do Pagamento da Opera��o de Transporte indicada abaixo.');
      rllLinha3.Caption := ACBrStr(
        'CONSULTE A AUTENTICIDADE DA INCLUS�O DE DF-e NO SITE DA SEFAZ AUTORIZADORA.');
    end;

    tePagamentoOperacao:
    begin
      rllLinha1.Caption := ACBrStr('PAGAMENTO DA OPERA��O DE TRANSPORTE');
      rllLinha2.Caption := ACBrStr(
        'N�o possui valor fiscal, simples representa��o do Pagamento da Opera��o de Transporte indicada abaixo.');
      rllLinha3.Caption := ACBrStr(
        'CONSULTE A AUTENTICIDADE DO PAGAMENTO DA OPERA��O NO SITE DA SEFAZ AUTORIZADORA.');
    end;

    teAlteracaoPagtoServMDFe:
    begin
      rllLinha1.Caption := ACBrStr('CANCELAMENTO DO PAGAMENTO DA OPERA��O DE TRANSPORTE');
      rllLinha2.Caption := ACBrStr(
        'N�o possui valor fiscal, simples representa��o do Cancelamento do Pag. da Opera��o de Transp. indicada abaixo.');
      rllLinha3.Caption := ACBrStr(
        'CONSULTE A AUTENTICIDADE DO CANCELAMENTO DO PAG. DA OPERA��O NO SITE DA SEFAZ AUTORIZADORA.');
    end;

    teConfirmaServMDFe:
    begin
      rllLinha1.Caption := ACBrStr('CONFIRMA��O DO SERVI�O DE TRANSPORTE');
      rllLinha2.Caption := ACBrStr(
        'N�o possui valor fiscal, simples representa��o da Confirma��o do Servi�o de Transp. indicada abaixo.');
      rllLinha3.Caption := ACBrStr(
        'CONSULTE A AUTENTICIDADE DA CONFIRMA��O DO SERVI�O DE TRANSPORTE NO SITE DA SEFAZ AUTORIZADORA.');
    end;
  end;
end;

procedure TfrmMDFeDAEventoRLRetrato.rlb_02_DocumentoBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  chave: String;
begin
  inherited;
  if fpMDFe <> nil then
  begin
    PrintIt := True;

    rllModelo.Caption := fpMDFe.ide.modelo;
    rllSerie.Caption := IntToStr(fpMDFe.ide.serie);
    rllNumMDFe.Caption := FormatFloat('000,000,000', fpMDFe.Ide.nMDF);
    rllEmissao.Caption := FormatDateTimeBr(fpMDFe.Ide.dhEmi);
    chave := Copy(fpMDFe.InfMDFe.Id, 5, 44);
    rllChave.Caption := FormatarChaveAcesso(chave);
    RLBarcode1.Caption := chave;
  end
  else
    PrintIt := False;
end;

procedure TfrmMDFeDAEventoRLRetrato.rlb_05_EventoBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  with fpEventoMDFe do
  begin
    case InfEvento.tpEvento of
      teCancelamento: rllTituloEvento.Caption := 'CANCELAMENTO';
      teEncerramento: rllTituloEvento.Caption := 'ENCERRAMENTO';
      teInclusaoCondutor: rllTituloEvento.Caption := ACBrStr('INCLUS�O DE CONDUTOR');
      teInclusaoDFe: rllTituloEvento.Caption := ACBrStr('INCLUS�O DE DF-e');
      tePagamentoOperacao: rllTituloEvento.Caption := ACBrStr('PAGAMENTO DA OPERA��O DE TRANSPORTE');
      teAlteracaoPagtoServMDFe: rllTituloEvento.Caption := ACBrStr('CANCELAMENTO DO PAG. DA OPERA��O DE TRANSP.');
      teConfirmaServMDFe: rllTituloEvento.Caption := ACBrStr('CONFIRMA��O DO SERVI�O DE TRANSPORTE');
    end;

    rllOrgao.Caption := IntToStr(InfEvento.cOrgao);

    case InfEvento.tpAmb of
      taProducao: rllTipoAmbiente.Caption := ACBrStr('PRODU��O');
      taHomologacao: rllTipoAmbiente.Caption := ACBrStr('HOMOLOGA��O - SEM VALOR FISCAL');
    end;

    rllEmissaoEvento.Caption := FormatDateTimeBr(InfEvento.dhEvento);
    rllTipoEvento.Caption := InfEvento.TipoEvento;
    rllDescricaoEvento.Caption := InfEvento.DescEvento;
    rllSeqEvento.Caption := IntToStr(InfEvento.nSeqEvento);
    rllStatus.Caption := IntToStr(RetInfEvento.cStat) + ' - ' +
      RetInfEvento.xMotivo;
    rllProtocolo.Caption := RetInfEvento.nProt + ' ' +
      FormatDateTimeBr(RetInfEvento.dhRegEvento);
  end;
end;

procedure TfrmMDFeDAEventoRLRetrato.rlb_03_EmitenteBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  printIt := False;

  if fpMDFe <> nil then
  begin
    printIt := True;

    rllRazaoEmitente.Caption := fpMDFe.emit.xNome;
    rllCNPJEmitente.Caption := FormatarCNPJouCPF(fpMDFe.emit.CNPJCPF);
    rllEnderecoEmitente.Caption := fpMDFe.emit.EnderEmit.xLgr + ', ' + fpMDFe.emit.EnderEmit.nro;
    rllBairroEmitente.Caption := fpMDFe.emit.EnderEmit.xBairro;
    rllCEPEmitente.Caption := FormatarCEP(fpMDFe.emit.EnderEmit.CEP);
    rllMunEmitente.Caption := fpMDFe.emit.EnderEmit.xMun + ' - ' + fpMDFe.emit.EnderEmit.UF;
    rllFoneEmitente.Caption := FormatarFone(fpMDFe.emit.enderEmit.fone);
    rllInscEstEmitente.Caption := fpMDFe.emit.IE;
  end;
end;

procedure TfrmMDFeDAEventoRLRetrato.rlb_04_TomadorBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  printIt := False;
end;

procedure TfrmMDFeDAEventoRLRetrato.rlb_06_DescricaoBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  Exibir: Boolean;
  i: Integer;
begin
  inherited;

  Exibir := (fpEventoMDFe.InfEvento.tpEvento = teCancelamento) or
            (fpEventoMDFe.InfEvento.tpEvento = teEncerramento) or
            (fpEventoMDFe.InfEvento.tpEvento = teInclusaoCondutor) or
            (fpEventoMDFe.InfEvento.tpEvento = teInclusaoDFe) or
            (fpEventoMDFe.InfEvento.tpEvento = tePagamentoOperacao) or
            (fpEventoMDFe.InfEvento.tpEvento = teAlteracaoPagtoServMDFe) or
            (fpEventoMDFe.InfEvento.tpEvento = teConfirmaServMDFe);

  printIt := Exibir or (fpEventoMDFe.InfEvento.tpAmb = taHomologacao);

  rllMsgTeste.Visible := False;
  rllMsgTeste.Enabled := False;

  if fpEventoMDFe.InfEvento.tpAmb = taHomologacao then
  begin
    rllMsgTeste.Caption := ACBrStr('AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL');
    rllMsgTeste.Visible := True;
    rllMsgTeste.Enabled := True;
  end;

  rlmDescricao.Visible := Exibir;
  rlmDescricao.Enabled := Exibir;

  rlmDescricao.Lines.Clear;
  case fpEventoMDFe.InfEvento.tpEvento of
    teCancelamento:
    begin
      rlmDescricao.Lines.Add('Protocolo do MDFe Cancelado: ' + fpEventoMDFe.InfEvento.detEvento.nProt);
      rlmDescricao.Lines.Add('Motivo do Cancelamento     : ' + fpEventoMDFe.InfEvento.detEvento.xJust);
    end;

    teEncerramento:
    begin
      rlmDescricao.Lines.Add('Protocolo do MDFe Encerrado: ' + fpEventoMDFe.InfEvento.detEvento.nProt);
      rlmDescricao.Lines.Add('Data do Encerramento       : ' +
        DateToStr(fpEventoMDFe.InfEvento.detEvento.dtEnc));
      rlmDescricao.Lines.Add(ACBrStr('C�digo da UF               : ') +
        IntToStr(fpEventoMDFe.InfEvento.detEvento.cUF));
      rlmDescricao.Lines.Add(ACBrStr('C�digo do Munic�pio        : ') +
        IntToStr(fpEventoMDFe.InfEvento.detEvento.cMun));
    end;

    teInclusaoCondutor:
    begin
      rlmDescricao.Lines.Add('Dados do Motorista');
      rlmDescricao.Lines.Add('CPF : ' + fpEventoMDFe.InfEvento.detEvento.CPF);
      rlmDescricao.Lines.Add('Nome: ' + fpEventoMDFe.InfEvento.detEvento.xNome);
    end;

    teInclusaoDFe:
    begin
      rlmDescricao.Lines.Add('Chaves das NF-e - Local de Carregamento: ' + fpEventoMDFe.InfEvento.detEvento.xMunCarrega);

      for i := 0 to fpEventoMDFe.InfEvento.detEvento.infDoc.Count - 1 do
      begin
        rlmDescricao.Lines.Add(fpEventoMDFe.InfEvento.detEvento.infDoc.Items[i].chNFe + ' - ' +
                               fpEventoMDFe.InfEvento.detEvento.infDoc.Items[i].xMunDescarga);
      end;
    end;

    tePagamentoOperacao:
    begin
      rlmDescricao.Lines.Add('Protocolo do MDFe Pago: ' + fpEventoMDFe.InfEvento.detEvento.nProt);
    end;

    teAlteracaoPagtoServMDFe:
    begin
      rlmDescricao.Lines.Add('Protocolo de Altera��o do MDFe Pago: ' + fpEventoMDFe.InfEvento.detEvento.nProt);
    end;

    teConfirmaServMDFe:
    begin
      rlmDescricao.Lines.Add('Protocolo de Confirma��o do Servi�o: ' + fpEventoMDFe.InfEvento.detEvento.nProt);
    end;
  end;
end;

procedure TfrmMDFeDAEventoRLRetrato.rlb_07_CorrecaoBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  printIt := False;
end;

procedure TfrmMDFeDAEventoRLRetrato.rlb_08_HeaderItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;
  // Imprime os Documentos Origin�rios se o Tipo de MDFe for Normal
end;

procedure TfrmMDFeDAEventoRLRetrato.rlb_09_ItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  rlb_09_Itens.Enabled := True;
end;

procedure TfrmMDFeDAEventoRLRetrato.rlb_10_SistemaBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  rllblSistema.Caption := fpDAMDFe.Sistema + ' - ' + fpDAMDFe.Usuario;
end;

end.
