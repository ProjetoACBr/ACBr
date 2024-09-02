{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Peterson de Cerqueira Matos                     }
{                              Wemerson Souto                                  }
{                              Daniel Simoes de Almeida                        }
{                              Andr� Ferreira de Moraes                        }
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

unit ACBrNFeDANFeEventoRLRetrato;

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
   QGraphics, QControls, QForms, Qt,
  {$ELSE}
   Graphics, Controls, Forms,
  {$ENDIF}
  RLReport, RLBarcode,
  ACBrNFeDANFeEventoRL, RLFilters, RLPDFFilter;

type
  TfrlDANFeEventoRLRetrato = class(TfrlDANFeEventoRL)
    rlbUsuario: TRLBand;
    rlbEvento: TRLBand;
    rllNomeEvento: TRLLabel;
    RLLabel32: TRLLabel;
    rllOrgao: TRLLabel;
    RLLabel35: TRLLabel;
    rllEvento: TRLLabel;
    RLLabel39: TRLLabel;
    rllStatusEvento: TRLLabel;
    RLLabel40: TRLLabel;
    rllProtocoloEvento: TRLLabel;
    RLLabel36: TRLLabel;
    rllDescrEvento: TRLLabel;
    RLLabel33: TRLLabel;
    rllAmbiente: TRLLabel;
    RLLabel37: TRLLabel;
    rllSeqEvento: TRLLabel;
    RLLabel42: TRLLabel;
    rllDataHoraRegistro: TRLLabel;
    RLLabel38: TRLLabel;
    rllVersaoEvento: TRLLabel;
    RLDraw16: TRLDraw;
    RLDraw17: TRLDraw;
    RLDraw22: TRLDraw;
    RLDraw20: TRLDraw;
    RLDraw19: TRLDraw;
    RLDraw24: TRLDraw;
    RLDraw21: TRLDraw;
    RLDraw15: TRLDraw;
    rlbNFe: TRLBand;
    RLLabel20: TRLLabel;
    RLLabel44: TRLLabel;
    rllModeloNF: TRLLabel;
    RLLabel45: TRLLabel;
    rllSerieNF: TRLLabel;
    RLLabel46: TRLLabel;
    rllMesAnoEmissaoNF: TRLLabel;
    RLDraw30: TRLDraw;
    RLDraw32: TRLDraw;
    RLDraw31: TRLDraw;
    RLDraw29: TRLDraw;
    RLDraw37: TRLDraw;
    rlbCondUso: TRLBand;
    RLLabel21: TRLLabel;
    rlbCabecalho: TRLBand;
    RLDraw3: TRLDraw;
    rliLogo: TRLImage;
    rllTitulo: TRLLabel;
    rllCabecalhoLinha1: TRLLabel;
    rllCabecalhoLinha2: TRLLabel;
    rlbCodigoBarras: TRLBarcode;
    rllChaveNFe: TRLLabel;
    RLLabel4: TRLLabel;
    RLDraw4: TRLDraw;
    rllDataHoraEvento: TRLLabel;
    RLLabel5: TRLLabel;
    RLDraw5: TRLDraw;
    RLDraw50: TRLDraw;
    rlmCondUso: TRLMemo;
    rllUsuario: TRLLabel;
    rllSistema: TRLLabel;
    rlbJustificativa: TRLBand;
    RLLabel3: TRLLabel;
    rlmJustificativa: TRLMemo;
    RLDraw1: TRLDraw;
    RLDraw2: TRLDraw;
    RLDraw6: TRLDraw;
    rlbCorrecao: TRLBand;
    RLLabel6: TRLLabel;
    rlmCorrecao: TRLMemo;
    RLLabel1: TRLLabel;
    RLDraw8: TRLDraw;
    rllNumNF: TRLLabel;
    rlbDestinatario: TRLBand;
    RLDraw9: TRLDraw;
    RLLabel18: TRLLabel;
    RLLabel2: TRLLabel;
    rllDestNome: TRLLabel;
    RLLabel7: TRLLabel;
    rllDestEndereco: TRLLabel;
    RLLabel8: TRLLabel;
    rllDestCidade: TRLLabel;
    RLLabel9: TRLLabel;
    rllDestFone: TRLLabel;
    RLLabel10: TRLLabel;
    rllDestBairro: TRLLabel;
    RLLabel41: TRLLabel;
    rllDestUF: TRLLabel;
    RLLabel11: TRLLabel;
    rllDestCNPJ: TRLLabel;
    RLLabel12: TRLLabel;
    rllDestCEP: TRLLabel;
    RLLabel13: TRLLabel;
    rllDestIE: TRLLabel;
    RLDraw10: TRLDraw;
    RLDraw11: TRLDraw;
    RLDraw12: TRLDraw;
    RLDraw23: TRLDraw;
    RLDraw13: TRLDraw;
    RLDraw14: TRLDraw;
    RLDraw18: TRLDraw;
    RLDraw25: TRLDraw;
    rlbEmitente: TRLBand;
    RLDraw26: TRLDraw;
    RLLabel14: TRLLabel;
    RLLabel15: TRLLabel;
    rllEmitNome: TRLLabel;
    RLLabel17: TRLLabel;
    rllEmitEndereco: TRLLabel;
    RLLabel22: TRLLabel;
    rllEmitCidade: TRLLabel;
    RLLabel24: TRLLabel;
    rllEmitFone: TRLLabel;
    RLLabel26: TRLLabel;
    rllEmitBairro: TRLLabel;
    RLLabel28: TRLLabel;
    rllEmitUF: TRLLabel;
    RLLabel30: TRLLabel;
    rllEmitCNPJ: TRLLabel;
    RLLabel34: TRLLabel;
    rllEmitCEP: TRLLabel;
    RLLabel47: TRLLabel;
    rllEmitIE: TRLLabel;
    RLDraw27: TRLDraw;
    RLDraw28: TRLDraw;
    RLDraw33: TRLDraw;
    RLDraw34: TRLDraw;
    RLDraw35: TRLDraw;
    RLDraw36: TRLDraw;
    RLDraw38: TRLDraw;
    RLDraw39: TRLDraw;
    rliMarcaDagua1: TRLImage;
    procedure RLEventoBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    procedure InicializarDados;
    procedure AjustarLayout;
  public

  end;

implementation

uses
  pcnConversao,
  ACBrDFeUtil, ACBrNFeDANFeRLClass, ACBrValidador,
  ACBrDFeReportFortes,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime;

{$IfNDef FPC}
  {$R *.dfm}
{$Else}
  {$R *.lfm}
{$EndIf}

procedure TfrlDANFeEventoRLRetrato.InicializarDados;
var
  CarregouLogo: Boolean;
  i: Integer;
begin
  // Carrega logomarca
  CarregouLogo := TDFeReportFortes.CarregarLogo(rliLogo, fpDANFe.Logo);

  // Centraliza as linhas do cabe�alho caso o logo n�o seja informado
  if (CarregouLogo) then
  begin
    rllTitulo.Left := 88;
    rllCabecalhoLinha1.Left := 88;
    rllCabecalhoLinha2.Left := 88;

    rllTitulo.Width := 650;
    rllCabecalhoLinha1.Width := 650;
    rllCabecalhoLinha2.Width := 650;
  end
  else
  begin
    rllTitulo.Left := 8;
    rllCabecalhoLinha1.Left := 8;
    rllCabecalhoLinha2.Left := 8;

    rllTitulo.Width := 730;
    rllCabecalhoLinha1.Width := 730;
    rllCabecalhoLinha2.Width := 730;
  end;

  // Carrega marca d'�gua
  if (fpDANFe.MarcaDagua <> '') and FileExists(fpDANFe.MarcaDagua) then
    rliMarcaDagua1.Picture.LoadFromFile(fpDANFe.MarcaDagua);

  with fpEventoNFe do
  begin
    // Preeche os campos - Quadro NF-e
    rllModeloNF.Caption := Copy(InfEvento.chNFe, 21, 2);
    rllSerieNF.Caption := Copy(InfEvento.chNFe, 23, 3);
    rllNumNF.Caption := Copy(InfEvento.chNFe, 26, 3) + '.' +
      Copy(InfEvento.chNFe, 29, 3) + '.' +
      Copy(InfEvento.chNFe, 32, 3);
    rllMesAnoEmissaoNF.Caption := Copy(InfEvento.chNFe, 5, 2) + '/' +
      Copy(InfEvento.chNFe, 3, 2);
    rllChaveNFe.Caption := FormatarChaveAcesso(InfEvento.chNFe);
    rlbCodigoBarras.Caption := InfEvento.chNFe;

    // Preenche os campos - Quadro Evento
    rllOrgao.Caption := IntToStr(InfEvento.cOrgao);
    case InfEvento.tpAmb of
      taProducao:
        rllAmbiente.Caption := ACBrStr('PRODU��O');
      taHomologacao:
        rllAmbiente.Caption := ACBrStr('HOMOLOGA��O - SEM VALOR FISCAL');
    end;

    rllDataHoraEvento.Caption := FormatDateTimeBr(InfEvento.dhEvento);
    rllEvento.Caption := InfEvento.TipoEvento;
    rllDescrEvento.Caption := ACBrStr(InfEvento.DescEvento);
    rllSeqEvento.Caption := IntToStr(InfEvento.nSeqEvento);
    rllVersaoEvento.Caption := InfEvento.versaoEvento;
    rllStatusEvento.Caption := IntToStr(RetInfEvento.cStat) + ' - ' + RetInfEvento.xMotivo;

    if RetInfEvento.cStat = 0 then
      rllStatusEvento.Visible := False
    else
      rllStatusEvento.Visible := True;

    rllProtocoloEvento.Caption := RetInfEvento.nProt;
    rllDataHoraRegistro.Caption := FormatDateTimeBr(RetInfEvento.dhRegEvento);

    if RetInfEvento.dhRegEvento < StrToDate( '01/01/1900' ) then
      rllDataHoraRegistro.Visible := False
    else
      rllDataHoraRegistro.Visible := True;


    // Se o XML da NF-e foi carregado, preenche os campos
    // do Emitente e do Destinat�rio
    if (fpNFe <> nil) then
    begin
      with fpNFe do
      begin
        // 1.) Preenche os campos do Emitente
        rllEmitNome.Caption := Emit.xNome;
        rllEmitCNPJ.Caption := FormatarCNPJouCPF(Emit.CNPJCPF);
        if NaoEstaVazio(Emit.EnderEmit.xCpl) then
          rllEmitEndereco.Caption := Emit.EnderEmit.xLgr + ', ' + Emit.EnderEmit.nro + ' ' + Emit.EnderEmit.xCpl
        else
          rllEmitEndereco.Caption := Emit.EnderEmit.xLgr + ', ' + Emit.EnderEmit.nro;

        rllEmitBairro.Caption := Emit.EnderEmit.xBairro;
        rllEmitCEP.Caption := FormatarCEP(Emit.EnderEmit.CEP);
        rllEmitCidade.Caption := Emit.EnderEmit.xMun;
        rllEmitFone.Caption := FormatarFone(Emit.EnderEmit.fone);
        rllEmitUF.Caption := Emit.EnderEmit.UF;
        rllEmitIE.Caption := Emit.IE;

        // 2.) Preenche os campos do Destinat�rio
        rllDestNome.Caption := Dest.xNome;
        rllDestCNPJ.Caption := FormatarCNPJouCPF(Dest.CNPJCPF);
        if NaoEstaVazio(Dest.EnderDest.xCpl) then
          rllDestEndereco.Caption := Dest.EnderDest.xLgr + ', ' + Dest.EnderDest.nro + ' ' + Dest.EnderDest.xCpl
        else
          rllDestEndereco.Caption := Dest.EnderDest.xLgr + ', ' + Dest.EnderDest.nro;

        rllDestBairro.Caption := Dest.EnderDest.xBairro;
        rllDestCEP.Caption := FormatarCEP(Dest.EnderDest.CEP);
        rllDestCidade.Caption := Dest.EnderDest.xMun;
        rllDestFone.Caption := FormatarFone(Dest.EnderDest.fone);
        rllDestUF.Caption := Dest.EnderDest.UF;
        rllDestIE.Caption := Dest.IE;
      end; // with NFe
    end; // if fpNFe <> nil

    RLDraw50.Visible := True;
    RLLabel21.Visible := True;
    rlmCondUso.Visible := True;

    rlbCorrecao.Visible := True;
    RLLabel6.Visible := True;
    rlmCorrecao.Visible := True;
    // Preenche os campos espec�ficos de acordo com o evento
    case InfEvento.tpEvento of
      teCCe:
      begin
        rllTitulo.Caption := ACBrStr('CARTA DE CORRE��O ELETR�NICA');

        // Preenche os campos - "Condi��es de uso"
        RLLabel21.Caption := ACBrStr('CONDI��ES DE USO');
        rlmCondUso.Lines.Clear;
        rlmCondUso.Lines.Add(StringReplace(InfEvento.detEvento.xCondUso, fpDANFe.CaractereQuebraDeLinha, slineBreak, [rfReplaceAll]));
        rlmCondUso.Lines.Text := StringReplace(rlmCondUso.Lines.Text, ': I', ':'+slineBreak+'I', [rfReplaceAll]);

        // Prrenche os campos - "Corre��o"
        rlmCorrecao.Lines.Add(StringReplace(InfEvento.detEvento.xCorrecao, fpDANFe.CaractereQuebraDeLinha, slineBreak, [rfReplaceAll]));
      end;

      teCancelamento:
      begin
        rllTitulo.Caption := 'CANCELAMENTO DE NF-E';
        rlmJustificativa.Lines.Text := InfEvento.detEvento.xJust;
      end;

      teCancSubst:
      begin
        rllTitulo.Caption := ACBrStr('CANCELAMENTO DE NF-E POR SUBSTITUI��O');
        rlmJustificativa.Lines.Text := InfEvento.detEvento.xJust + sLineBreak +
                                    InfEvento.detEvento.chNFeRef;
      end;

      teManifDestConfirmacao:
      begin
        rllTitulo.Caption := ACBrStr('CONFIRMA��O DA OPERA��O');
      end;

      teManifDestCiencia:
      begin
        rllTitulo.Caption := ACBrStr('CI�NCIA DA EMISS�O/OPERA��O');
      end;

      teManifDestDesconhecimento:
      begin
        rllTitulo.Caption := ACBrStr('DESCONHECIMENTO DA OPERA��O');
      end;

      teManifDestOperNaoRealizada:
      begin
        rllTitulo.Caption := ACBrStr('OPERA��O N�O REALIZADA');
        rlmJustificativa.Lines.Text := InfEvento.detEvento.xJust;
      end;

      teEPECNFe:
      begin
        rllTitulo.Caption := ACBrStr('EVENTO PR�VIO DE EMISS�O EM CONTING�NCIA - EPEC');
        RLLabel21.Caption := ACBrStr('DESCRI��O');
        rlmCondUso.Lines.Clear;
        rlmCondUso.Lines.Add('Destinat�rio    : ' + InfEvento.detEvento.dest.CNPJCPF);
        rlmCondUso.Lines.Add('Valor da Nota   : ' + FormatFloatBr(msk13x2, InfEvento.detEvento.vNF));
        rlmCondUso.Lines.Add('Valor do ICMS   : ' + FormatFloatBr(msk13x2, InfEvento.detEvento.vICMS));
        rlmCondUso.Lines.Add('Valor do ICMS ST: ' + FormatFloatBr(msk13x2, InfEvento.detEvento.vST));
      end;

      tePedProrrog1,
      tePedProrrog2:
      begin
        rllTitulo.Caption := ACBrStr('EVENTO DE PEDIDO DE PRORROGA��O');
      end;

      teCanPedProrrog1,
      teCanPedProrrog2:
      begin
        rllTitulo.Caption := ACBrStr('EVENTO DE CANCELAMENTO DO PEDIDO DE PRORROGA��O');
        RLLabel21.Caption := ACBrStr('Identifica��o do Pedido Cancelado');
        rlmCondUso.Lines.Clear;
        rlmCondUso.Lines.Add(InfEvento.detEvento.idPedidoCancelado);
      end;

      teComprEntregaNFe:
      begin
        rllTitulo.Caption := ACBrStr('EVENTO DE COMPROVANTE DE ENTREGA');
        RLLabel21.Caption := ACBrStr('DESCRI��O');
        rlmCondUso.Lines.Clear;
        rlmCondUso.Lines.Add('Destinat�rio: ' + InfEvento.detEvento.xNome);
        rlmCondUso.Lines.Add('Data/Hora   : ' + DateTimeTodh(InfEvento.detEvento.dhEntrega));
        rlmCondUso.Lines.Add('Num. Doc.   : ' + InfEvento.detEvento.nDoc);
      end;

      teCancComprEntregaNFe:
      begin
        rllTitulo.Caption := ACBrStr('EVENTO DE CANCELAMENTO DO COMPROVANTE DE ENTREGA');
      end;

      teAtorInteressadoNFe:
      begin
        rllTitulo.Caption := ACBrStr('EVENTO DE ATOR INTERESSADO');
        RLLabel21.Caption := ACBrStr('ATOR');
        rlmCondUso.Lines.Clear;

        for i := 0 to InfEvento.detEvento.autXML.Count -1 do
          rlmCondUso.Lines.Add('CNPJ/CPF: ' + InfEvento.detEvento.autXML[i].CNPJCPF);
      end;

      teInsucessoEntregaNFe:
      begin
        rllTitulo.Caption := ACBrStr('INSUCESSO DE ENTREGA DE NFE');
        rlmJustificativa.Lines.Text := InfEvento.detEvento.xJustMotivo;

        RLDraw50.Visible := False;
        RLLabel21.Visible := False;
        rlmCondUso.Visible := False;

        rlbCorrecao.Visible := False;
        RLLabel6.Visible := False;
        rlmCorrecao.Visible := False;
      end;

      teCancInsucessoEntregaNFe:
      begin
        rllTitulo.Caption := ACBrStr('CANCELAMENTO DE INSUCESSO DE ENTREGA DE NFE');
        rlmJustificativa.Lines.Text := InfEvento.detEvento.xJustMotivo;

        RLDraw50.Visible := False;
        RLLabel21.Visible := False;
        rlmCondUso.Visible := False;

        rlbCorrecao.Visible := False;
        RLLabel6.Visible := False;
        rlmCorrecao.Visible := False;
      end;

      teConcFinanceira:
      begin
        // Evento ainda n�o dispon�vel
      end;

      teCancConcFinanceira:
      begin
        // Evento ainda n�o dispon�vel
      end;
    end; // case InfEvento.tpEvento

    rllNomeEvento.Caption := rllTitulo.Caption;
  end; // with fpEventoNFe.Evento.Items[FItemAtual].InfEvento


  // Exibe o desenvolvedor do sistema
  if NaoEstaVazio(fpDANFe.Sistema) then
  begin
    rllSistema.Caption := fpDANFe.Sistema;
    rllSistema.Visible := True;
  end
  else
    rllSistema.Visible := False;

  // Exibe o nome do usu�rio
  if NaoEstaVazio(fpDANFe.Usuario) then
  begin
    rllUsuario.Caption := ACBrStr('DATA / HORA DA IMPRESS�O: ') +
      FormatDateTimeBr(Now) + ' - ' + fpDANFe.Usuario;
    rllUsuario.Visible := True;
  end
  else
    rllUsuario.Visible := False;
end;

procedure TfrlDANFeEventoRLRetrato.AjustarLayout;
var
  b, i: Integer;
begin
  TDFeReportFortes.AjustarMargem(RLEvento, fpDANFe);

  // Ajuste da fonte
  case fpDANFe.Fonte.Nome of
    nfArial:
      for b := 0 to (RLEvento.ControlCount - 1) do
        for i := 0 to (TRLBand(RLEvento.Controls[b]).ControlCount - 1) do
          TRLLabel(TRLBand(RLEvento.Controls[b]).Controls[i]).Font.Name := 'Arial';

    nfCourierNew:
    begin
      for b := 0 to (RLEvento.ControlCount - 1) do
        for i := 0 to (TRLBand(RLEvento.Controls[b]).ControlCount - 1) do
        begin
          TRLLabel(TRLBand(RLEvento.Controls[b]).Controls[i]).Font.Name := 'Courier New';
          TRLLabel(TRLBand(RLEvento.Controls[b]).Controls[i]).Font.Size :=
            TRLLabel((TRLBand(RLEvento.Controls[b])).Controls[i]).Font.Size - 1;
        end;
    end;

    nfTimesNewRoman:
      for b := 0 to (RLEvento.ControlCount - 1) do
        for i := 0 to (TRLBand(RLEvento.Controls[b]).ControlCount - 1) do
          TRLLabel((TRLBand(RLEvento.Controls[b])).Controls[i]).Font.Name := 'Times New Roman';
  end;

  // Dados em negrito
  if fpDANFe.Fonte.Negrito then
  begin
    for b := 0 to (RLEvento.ControlCount - 1) do
      for i := 0 to (TRLBand(RLEvento.Controls[b]).ControlCount - 1) do
      begin
        if (TRLLabel(TRLBand(RLEvento.Controls[b]).Controls[i]).Tag = 70) then
          TRLLabel(TRLBand(RLEvento.Controls[b]).Controls[i]).Font.Style := [fsBold];
      end;
  end
  else
  begin
    for b := 0 to (RLEvento.ControlCount - 1) do
      for i := 0 to (TRLBand(RLEvento.Controls[b]).ControlCount - 1) do
      begin
        if (TRLLabel(TRLBand(RLEvento.Controls[b]).Controls[i]).Tag = 70) then
          TRLLabel(TRLBand(RLEvento.Controls[b]).Controls[i]).Font.Style := [];
      end;
  end;

  // Se o XML da NF-e foi carregado tamb�m, exibe os quadros
  // "Emitente" e "Destinat�rio"
  if (fpNFe <> nil) then
  begin
    rlbEmitente.Visible := True;
    rlbDestinatario.Visible := True;
  end
  else
  begin
    rlbEmitente.Visible := False;
    rlbDestinatario.Visible := False;
  end;

  // Exibe os itens espec�ficos de cada evento e ajusta a posi��o
  // da marca d�gua, de acordo com o evento
  case fpEventoNFe.InfEvento.tpEvento of
    teCCe:
    begin
      rlbJustificativa.Visible := False;
      rlbCondUso.Visible := True;
      RLLabel6.Visible := True;
      rlbCorrecao.Visible := True;
      rliMarcaDagua1.Top := ((rlbCorrecao.Top + rlbCorrecao.Height) div 2) - (rliMarcaDagua1.Height div 2);
    end;

  teEPECNFe:
  begin
    rlbJustificativa.Visible := False;
    rlbCondUso.Visible := True;
    RLLabel6.Visible := False;
    rlbCorrecao.Visible := False;
    rliMarcaDagua1.Top := ((rlbCorrecao.Top + rlbCorrecao.Height) div 2) - (rliMarcaDagua1.Height div 2);
  end;

    teCancelamento, teManifDestConfirmacao, teManifDestCiencia, teManifDestDesconhecimento, teManifDestOperNaoRealizada:
    begin
      rlbJustificativa.Visible := True;
      rlbCondUso.Visible := False;
      rlbCorrecao.Visible := False;
      rliMarcaDagua1.Top := ((rlbDestinatario.Top + rlbDestinatario.Height) div 2) - (rliMarcaDagua1.Height div 2);
    end;
  end; // case fpEventoNFe.Evento.Items[0].InfEvento.tpEvento

  rliMarcaDagua1.Left := (RLEvento.Width div 2) - (rliMarcaDagua1.Width div 2);
end;

procedure TfrlDANFeEventoRLRetrato.RLEventoBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  AjustarLayout;
  InicializarDados;
end;

end.
