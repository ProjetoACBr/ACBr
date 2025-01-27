{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit ACBrNF3eDANF3eESCPOS;

interface

uses
  Classes, SysUtils, {$IFDEF FPC} LResources, {$ENDIF}
  ACBrBase, ACBrPosPrinter,
  ACBrNF3eClass, ACBrNF3eDANF3eClass, ACBrNF3eEnvEvento;

type
  { TACBrNF3eDANF3eESCPOS }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNF3eDANF3eESCPOS = class(TACBrNF3eDANF3eClass)
  private
    FPosPrinter: TACBrPosPrinter;

    procedure MontarEnviarDANF3e(NF3e: TNF3e);
    procedure SetPosPrinter(AValue: TACBrPosPrinter);
  protected
    FpNF3e: TNF3e;
    FpEvento: TEventoNF3e;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure AtivarPosPrinter;
    procedure GerarMensagemContingencia(CaracterDestaque: Char);

    procedure GerarCabecalhoEmitente;
    procedure GerarIdentificacaodoDANF3e;
    procedure GerarInformacoesAcessanteDestinatario;
    procedure GerarInformacoesIdentificacaoNF3e;
    procedure GerarInformacoesItens;
    procedure GerarTotalTributos;
    procedure GerarInformacoesConsultaChaveAcesso;
    procedure GerarInformacoesQRCode(Cancelamento: Boolean = False);
    procedure GerarMensagemFiscal;
    procedure GerarMensagemInteresseContribuinte;
    procedure GerarInformacoesValoresContratados;
    procedure GerarInformacoesAreaContribuinte;
    procedure GerarRodape;

    procedure GerarDadosEvento;
    procedure GerarObservacoesEvento;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDANF3e(NF3e: TNF3e = nil); override;
    procedure ImprimirDANF3eCancelado(NF3e: TNF3e = nil); override;
    procedure ImprimirEVENTO(NF3e: TNF3e = nil);override;

    procedure ImprimirRelatorio(const ATexto: TStrings; const AVias: Integer = 1;
      const ACortaPapel: Boolean = True; const ALogo: Boolean = True);
  published
    property PosPrinter: TACBrPosPrinter read FPosPrinter write SetPosPrinter;
  end;

implementation

uses
  strutils, Math,
  ACBrUtil.Strings, ACBrUtil.Base,
  ACBrDFeUtil,
  ACBrXmlBase,
  ACBrValidador,
  ACBrNF3e, ACBrNF3eConversao;

{ TACBrNF3eDANF3eESCPOS }

constructor TACBrNF3eDANF3eESCPOS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPosPrinter := Nil;
end;

destructor TACBrNF3eDANF3eESCPOS.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrNF3eDANF3eESCPOS.SetPosPrinter(AValue: TACBrPosPrinter);
begin
  if AValue <> FPosPrinter then
  begin
    if Assigned(FPosPrinter) then
      FPosPrinter.RemoveFreeNotification(Self);

    FPosPrinter := AValue;

    if AValue <> nil then
      AValue.FreeNotification(self);
  end;
end;

procedure TACBrNF3eDANF3eESCPOS.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) then
  begin
    if (AComponent is TACBrPosPrinter) and (FPosPrinter <> nil) then
      FPosPrinter := nil;
  end;
end;

procedure TACBrNF3eDANF3eESCPOS.AtivarPosPrinter;
begin
  if not Assigned( FPosPrinter ) then
    raise Exception.Create('Componente PosPrinter n�o associado');

  FPosPrinter.Ativar;
end;

procedure TACBrNF3eDANF3eESCPOS.GerarMensagemContingencia(CaracterDestaque: Char);
begin
  // se homologa��o imprimir o texto de homologa��o
  if (FpNF3e.ide.tpAmb = TACBrTipoAmbiente(taHomologacao)) then
  begin
    FPosPrinter.Buffer.Add(ACBrStr('</ce><c><n>EMITIDA EM AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL</n>'));
  end;

  // se diferente de normal imprimir a emiss�o em conting�ncia
  if (FpNF3e.ide.tpEmis <> TACBrTipoEmissao(teNormal)) and
     EstaVazio(FpNF3e.procNF3e.nProt) then
  begin
    FPosPrinter.Buffer.Add(ACBrStr('</c></ce><e><n>EMITIDA EM CONTING�NCIA</n></e>'));
    FPosPrinter.Buffer.Add(ACBrStr('<c><n>' + PadCenter('Pendente de autoriza��o',
                                               FPosPrinter.ColunasFonteCondensada,
                                               CaracterDestaque) + '</n>'));
  end;
end;

procedure TACBrNF3eDANF3eESCPOS.GerarCabecalhoEmitente;
begin
  // Divis�o I - Informa��es do Cabe�alho: Dados do Emitente

  FPosPrinter.Buffer.Add('</zera></ce></logo>');

  if (Trim(FpNF3e.Emit.xFant) <> '') and ImprimeNomeFantasia then
     FPosPrinter.Buffer.Add('</ce><c><n>' +  FpNF3e.Emit.xFant + '</n>');

  FPosPrinter.Buffer.Add('</ce><c>'+ FpNF3e.Emit.xNome);
  FPosPrinter.Buffer.Add('</ce><c>'+ FormatarCNPJ(FpNF3e.Emit.CNPJ) + ' I.E.: ' +
                         FormatarIE(FpNF3e.Emit.IE, FpNF3e.Emit.EnderEmit.UF));

  FPosPrinter.Buffer.Add('<c>' + QuebraLinhas(Trim(FpNF3e.Emit.EnderEmit.xLgr) + ', ' +
    Trim(FpNF3e.Emit.EnderEmit.nro) + '  ' +
    Trim(FpNF3e.Emit.EnderEmit.xCpl) + '  ' +
    Trim(FpNF3e.Emit.EnderEmit.xBairro) +  ' ' +
    Trim(FpNF3e.Emit.EnderEmit.xMun) + '-' + Trim(FpNF3e.Emit.EnderEmit.UF)
    , FPosPrinter.ColunasFonteCondensada));

   if not EstaVazio(FpNF3e.Emit.EnderEmit.fone) then
     FPosPrinter.Buffer.Add('</ce></fn><c>Fone: <n>' + FormatarFone(FpNF3e.Emit.EnderEmit.fone) +
                            '</n> I.E.: ' + FormatarIE(FpNF3e.Emit.IE, FpNF3e.Emit.EnderEmit.UF))
   else
     FPosPrinter.Buffer.Add('</ce></fn><c>I.E.: ' + FormatarIE(FpNF3e.Emit.IE, FpNF3e.Emit.EnderEmit.UF));

  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarIdentificacaodoDANF3e;
begin
  FPosPrinter.Buffer.Add('</ce><c><n>' +
    QuebraLinhas(ACBrStr('Documento Auxiliar da Nota Fiscal de Energia El�trica Eletr�nica'), FPosPrinter.ColunasFonteCondensada) +
    '</n>');

  FPosPrinter.Buffer.Add('</linha_simples>');
  GerarMensagemContingencia('=');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarInformacoesAcessanteDestinatario;
var
  sCNPJCPF, sidMedidor: String;
  qFaturada: Double;
  dMedAtu, dMedAnt: TDateTime;
begin
  // Divis�o II � Informa��es do Acessante / Destinat�rio

  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace('N. do Cliente', 20, '') +
                         PadSpace('Vencimento', 20, '') +
                         PadSpace('Total em Reais', 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace(FpNF3e.acessante.idAcesso, 20, '') +
                         PadSpace(DateToStr(FpNF3e.gFat.dVencFat), 20, '') +
                         PadSpace(FormatFloatBr(FpNF3e.Total.vNF), 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace('Medidor', 20, '') +
                         PadSpace('Referencia', 20, '') +
                         PadSpace('Consumo', 24, '') +
                         '</n>');

  if FpNF3e.gMed.Count > 0 then
  begin
    sidMedidor := FpNF3e.gMed.Items[0].idMedidor;
    dMedAtu := FpNF3e.gMed.items[0].dMedAtu;
    dMedAnt := FpNF3e.gMed.items[0].dMedAnt;
  end
  else
  begin
    sidMedidor := '';
    dMedAtu := Date;
    dMedAnt := Date;
  end;

  qFaturada := 0;
  if FpNF3e.NFDet.Count > 0 then
    if FpNF3e.NFDet.Items[0].Det.Count > 0 then
      qFaturada := FpNF3e.NFDet.Items[0].Det.Items[0].detItem.Prod.qFaturada;

  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace(sidMedidor, 20, '') +
                         PadSpace(copy(DateToStr(FpNF3e.gFat.CompetFat), 4, 7), 20, '') +
                         PadSpace(FormatFloatBr(qFaturada), 24, '') +
                         '</n>');

  sCNPJCPF := FpNF3e.Dest.CNPJCPF;
  if sCNPJCPF = '' then
    sCNPJCPF := FpNF3e.Dest.idOutros
  else
    sCNPJCPF := FormatarCNPJouCPF(sCNPJCPF);

  FPosPrinter.Buffer.Add('</ce><c>'+ FpNF3e.Dest.xNome + ' (' + sCNPJCPF + ')');

  FPosPrinter.Buffer.Add('<c>' + QuebraLinhas(Trim(FpNF3e.Dest.EnderDest.xLgr) + ', ' +
    Trim(FpNF3e.Dest.EnderDest.nro) + '  ' +
    Trim(FpNF3e.Dest.EnderDest.xCpl) + '  ' +
    Trim(FpNF3e.Dest.EnderDest.xBairro) +  ' ' +
    Trim(FpNF3e.Dest.EnderDest.xMun) + '-' + Trim(FpNF3e.Dest.EnderDest.UF)
    , FPosPrinter.ColunasFonteCondensada));

  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace('Classe', 40, '') +
                         PadSpace('Fase', 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace(tpClasseToDesc(FpNF3e.acessante.tpClasse), 40, '') +
                         PadSpace(tpFaseToDesc(FpNF3e.acessante.tpFase), 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace('Leitura: ' + DateToStr(dMedAtu), 20, '') +
                         PadSpace('Leitura: ' + DateToStr(dMedAnt), 20, '') +
                         PadSpace('Proxima Leitura Prevista', 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace(FormatFloatBr(FpNF3e.NFDet[0].Det[0].detItem.Prod.gMedicao.vMedAtu), 20, '') +
                         PadSpace(FormatFloatBr(FpNF3e.NFDet[0].Det[0].detItem.Prod.gMedicao.vMedAnt), 20, '') +
                         PadSpace(DateToStr(FpNF3e.gFat.dProxLeitura), 24, '') +
                         '</n>');

  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarInformacoesIdentificacaoNF3e;
//var
//  Via: String;
begin
  // Divis�o III � Informa��es de identifica��o da NF3e e do
  // Protocolo de Autoriza��o

  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace('N. Nota Fiscal', 40, '') +
                         PadSpace('S�rie', 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace(IntToStrZero(FpNF3e.Ide.nNF, 9), 40, '') +
                         PadSpace(IntToStrZero(FpNF3e.Ide.serie, 3), 24, '') +
                         '</n>');

  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace('Emiss�o', 40, '') +
                         PadSpace('Apresenta��o', 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace(DateTimeToStr(FpNF3e.ide.dhEmi), 40, '') +
                         PadSpace(DateTimeToStr(FpNF3e.gFat.dApresFat), 24, '') +
                         '</n>');

  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace('Numero da Fatura', 40, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace(FpNF3e.gFat.nFat, 40, '') +
                         '</n>');

  // protocolo de autoriza��o
  if (FpNF3e.Ide.tpEmis <> TACBrTipoEmissao(teOffLine)) or
     NaoEstaVazio(FpNF3e.procNF3e.nProt) or
     (FpNF3e.procNF3e.dhRecbto <> 0) then
  begin
    FPosPrinter.Buffer.Add('</ce><c><n>' +
                           PadSpace('Protocolo de Autoriza��o', 40, '') +
                           '</n>');
    FPosPrinter.Buffer.Add('</ce><c><n>' +
                           PadSpace(FpNF3e.procNF3e.nProt, 40, '') +
                           PadSpace(DateTimeToStr(FpNF3e.procNF3e.dhRecbto), 24, '') +
                           '</n>');
  end;

  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarInformacoesItens;
var
  i, j: Integer;
  nTamDescricao: Integer;
  VlrTotal: Double;
//  VlrAcrescimo, VlrLiquido}: Double;
  sItem, sQuantidade, sUnidade, sVlrUnitario, sVlrProduto, LinhaCmd: String;
  sDescricaoAd: String;
  posQuebra, posDescricao: Integer;

const
  tagDescricao = '[DesProd]';
begin
  // Divis�o IV � Informa��es dos itens do DANF3E
  FPosPrinter.Buffer.Add('</ae><c>' +
    ACBrStr(PadSpace('Itens da Fatura|Unid.|Quant.|Pre�o Unit.R$|Valor R$',
                                     FPosPrinter.ColunasFonteCondensada, '|')));

  VlrTotal  := 0.0;

  for i := 0 to FpNF3e.NFDet.Count - 1 do
  begin
    for j := 0 to FpNF3e.NFDet.Items[i].Det.Count - 1 do
    begin
      with FpNF3e.NFDet.Items[i].Det.Items[j].detItem.Prod do
      begin
        sItem        := Trim(xProd);
        sUnidade     := uMedFatToDesc(uMed);
        sQuantidade  := FormatarQuantidade(qFaturada, False );
        sVlrUnitario := FormatarValorUnitario(vItem);
        sVlrProduto  := FormatFloatBr(vProd);

        VlrTotal := VlrTotal + vProd;

        LinhaCmd := tagDescricao + ' ' + sUnidade + ' ' + sQuantidade + ' X ' +
                    sVlrUnitario + ' ' + sVlrProduto;

        // prepara impress�o da segunda linha da descri��o (informa��o adicional)
        posQuebra := Pos(sLineBreak, sItem);
        posDescricao := Pos(tagDescricao, LinhaCmd);

        if posQuebra > 0 then
        begin
          sDescricaoAd := Copy(sItem, posQuebra + Length(sLineBreak), MaxInt);
          sItem := Copy(sItem, 1, posQuebra - 1);
        end;

        // acerta tamanho da descri��o
        nTamDescricao := FPosPrinter.ColunasFonteCondensada - Length(LinhaCmd) + Length(tagDescricao);
        sItem := PadRight(Copy(sItem, 1, nTamDescricao), nTamDescricao);

        LinhaCmd := StringReplace(LinhaCmd, tagDescricao, sItem, [rfReplaceAll]);
        if sDescricaoAd <> '' then
          LinhaCmd := LinhaCmd + sLineBreak + StringOfChar(' ', posDescricao - 1) + sDescricaoAd;
        FPosPrinter.Buffer.Add('</ae><c>' + LinhaCmd);
      end;
    end;
  end;

  FPosPrinter.Buffer.Add('<c>' + PadSpace('Sub Total R$|' +
     FormatFloatBr(VlrTotal), FPosPrinter.ColunasFonteCondensada, '|'));

  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarTotalTributos;
//var
//  MsgTributos: String;
begin
  // Divis�o V � Informa��es dos Tributos

  FPosPrinter.Buffer.Add('<c>' + PadSpace('Tributos (Valores inclu�dos no pre�o)',
                                       FPosPrinter.ColunasFonteCondensada, ''));
  FPosPrinter.Buffer.Add(' ');

  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace('ICMS Base de C�lculo (R$)', 40, '') +
                         PadSpace('ICMS', 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace(FormatFloatBr(FpNF3e.Total.vBC), 40, '') +
                         PadSpace(FormatFloatBr(FpNF3e.Total.vICMS), 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace('ICMS ST Base de C�lculo (R$)', 40, '') +
                         PadSpace('ICMS ST ', 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace(FormatFloatBr(FpNF3e.Total.vBCST), 40, '') +
                         PadSpace(FormatFloatBr(FpNF3e.Total.vST), 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace('PIS Conf.Res.ANEEL n. 234/2005', 40, '') +
                         PadSpace('COFINS Conf.Res.ANEEL n. 234/2005', 24, '') +
                         '</n>');
  FPosPrinter.Buffer.Add('</ce><c><n>' +
                         PadSpace(FormatFloatBr(FpNF3e.Total.vPIS), 40, '') +
                         PadSpace(FormatFloatBr(FpNF3e.Total.vCOFINS), 24, '') +
                         '</n>');

  FPosPrinter.Buffer.Add('</linha_simples>');
{
  if FpNF3e.Imp.vTotTrib > 0 then
  begin
    MsgTributos:= 'Tributos Totais Incidentes(Lei Federal 12.741/12): R$ %s';
    FPosPrinter.Buffer.Add('<c>' + QuebraLinhas(Format(MsgTributos,[FormatFloatBr(FpNF3e.Imp.vTotTrib)]),
                         FPosPrinter.ColunasFonteCondensada));
  end;
  }
end;

procedure TACBrNF3eDANF3eESCPOS.GerarInformacoesConsultaChaveAcesso;
begin
  // Divis�o VI � Informa��es da consulta via chave de acesso

  FPosPrinter.Buffer.Add('</ce><c><n>Consulte pela Chave de Acesso em</n>');
  FPosPrinter.Buffer.Add('</ce><c>'+TACBrNF3e(ACBrNF3e).GetURLConsultaNF3e(FpNF3e.ide.cUF, FpNF3e.ide.tpAmb, 1.0));
  FPosPrinter.Buffer.Add('</ce><c>' + FormatarChaveAcesso(OnlyNumber(FpNF3e.infNF3e.ID)));

  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarInformacoesQRCode(Cancelamento: Boolean = False);
var
  qrcode: AnsiString;
  ConfigQRCodeErrorLevel: Integer;
begin
  // Divis�o VII � Informa��es da consulta via QR Code
   
  if Cancelamento then
  begin
    FPosPrinter.Buffer.Add('</fn></linha_simples>');
    FPosPrinter.Buffer.Add('</ce>Consulta via leitor de QR Code');
  end;

  if EstaVazio(Trim(FpNF3e.infNF3eSupl.qrCodNF3e)) then
    qrcode := TACBrNF3e(ACBrNF3e).GetURLQRCode(
      FpNF3e.ide.cUF,
      FpNF3e.ide.tpAmb,
      FpNF3e.Ide.tpEmis,
      FpNF3e.infNF3e.ID,
      1.00)
  else
    qrcode := FpNF3e.infNF3eSupl.qrCodNF3e;

  ConfigQRCodeErrorLevel := FPosPrinter.ConfigQRCode.ErrorLevel;

  // impress�o do qrcode
  FPosPrinter.Buffer.Add( '<qrcode_error>0</qrcode_error>'+
                          '<qrcode>'+qrcode+'</qrcode>'+
                          '<qrcode_error>'+IntToStr(ConfigQRCodeErrorLevel)+'</qrcode_error>');


  if Cancelamento then
  begin
    FPosPrinter.Buffer.Add(ACBrStr('<c>Protocolo de Autoriza��o'));
    FPosPrinter.Buffer.Add('<c>'+Trim(FpNF3e.procNF3e.nProt) + ' ' +
       IfThen(FpNF3e.procNF3e.dhRecbto <> 0, DateTimeToStr(FpNF3e.procNF3e.dhRecbto),
              '') + '</fn>');
  end;

  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarMensagemFiscal;
var
  TextoObservacao: AnsiString;
begin
  // Divis�o VIII � �rea de Mensagem Fiscal

  TextoObservacao := Trim(FpNF3e.InfAdic.infAdFisco);
  if TextoObservacao <> '' then
  begin
    FPosPrinter.Buffer.Add('<c>' + PadSpace('Reservado ao Fisco',
                                         FPosPrinter.ColunasFonteCondensada, ''));
    FPosPrinter.Buffer.Add(' ');

    TextoObservacao := StringReplace(FpNF3e.InfAdic.infAdFisco, CaractereQuebraDeLinha , sLineBreak, [rfReplaceAll]);
    FPosPrinter.Buffer.Add('<c>' + TextoObservacao);

    FPosPrinter.Buffer.Add('</linha_simples>');
  end;
end;

procedure TACBrNF3eDANF3eESCPOS.GerarMensagemInteresseContribuinte;
var
  TextoObservacao: AnsiString;
begin
  // Divis�o IX � Mensagem de Interesse do Contribuinte

  TextoObservacao := Trim(FpNF3e.InfAdic.infCpl);
  if TextoObservacao <> '' then
  begin
    TextoObservacao := StringReplace(FpNF3e.InfAdic.infCpl, CaractereQuebraDeLinha, sLineBreak, [rfReplaceAll]);
    FPosPrinter.Buffer.Add('<c>' + TextoObservacao);
  end;

  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarInformacoesValoresContratados;
begin
  // Divis�o X � Informa��es dos valores contratados (Apenas Alta Tens�o)

//  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarInformacoesAreaContribuinte;
begin
  // Divis�o XI � �rea do Contribuinte e Determina��es da ANEEL

//  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarRodape;
begin
  // sistema
  if Sistema <> '' then
    FPosPrinter.Buffer.Add('</ce><c>' + Sistema);

  if Site <> '' then
    FPosPrinter.Buffer.Add('</ce><c>' + Site);

  // pular linhas e cortar o papel
  if FPosPrinter.CortaPapel then
    FPosPrinter.Buffer.Add('</corte_total>')
  else
    FPosPrinter.Buffer.Add('</pular_linhas>')
end;

procedure TACBrNF3eDANF3eESCPOS.MontarEnviarDANF3e(NF3e: TNF3e);
begin
  if NF3e = nil then
  begin
    if not Assigned(ACBrNF3e) then
      raise Exception.Create(ACBrStr('Componente ACBrNF3e n�o atribu�do'));

    FpNF3e := TACBrNF3e(ACBrNF3e).NotasFiscais.Items[0].NF3e;
  end
  else
    FpNF3e := NF3e;

  GerarCabecalhoEmitente;
  GerarIdentificacaodoDANF3e;
  GerarInformacoesAcessanteDestinatario;
  GerarInformacoesIdentificacaoNF3e;
  GerarInformacoesItens;
  GerarTotalTributos;
  GerarInformacoesConsultaChaveAcesso;
  GerarInformacoesQRCode;
  GerarMensagemFiscal;
  GerarMensagemInteresseContribuinte;
  GerarInformacoesValoresContratados;
  GerarInformacoesAreaContribuinte;
  GerarRodape;

  FPosPrinter.Imprimir('',False,True,True,NumCopias);
end;

procedure TACBrNF3eDANF3eESCPOS.ImprimirDANF3e(NF3e: TNF3e);
begin
  AtivarPosPrinter;
  MontarEnviarDANF3e(NF3e);
end;

procedure TACBrNF3eDANF3eESCPOS.GerarDadosEvento;
const
  TAMCOLDESCR = 11;
begin
  // dados da nota eletr�nica

  FPosPrinter.Buffer.Add('</fn></ce><n>Nota Fiscal de Energia El�trica Eletr�nica</n>');
  FPosPrinter.Buffer.Add(ACBrStr('N�mero: ' + IntToStrZero(FpNF3e.ide.nNF, 9) +
                                 ' S�rie: ' + IntToStrZero(FpNF3e.ide.serie, 3)));
  FPosPrinter.Buffer.Add(ACBrStr('Emiss�o: ' + DateTimeToStr(FpNF3e.ide.dhEmi)) + '</n>');
  FPosPrinter.Buffer.Add(' ');
  FPosPrinter.Buffer.Add('<c>CHAVE ACESSO');
  FPosPrinter.Buffer.Add(FormatarChaveAcesso(OnlyNumber(FpNF3e.infNF3e.ID)));
  FPosPrinter.Buffer.Add('</linha_simples>');

  // dados do evento
  FPosPrinter.Buffer.Add('</fn><n>EVENTO</n>');
  FPosPrinter.Buffer.Add('</fn></ae>' + PadRight('Evento:', TAMCOLDESCR) +
     FpEvento.Evento[0].Infevento.TipoEvento );
  FPosPrinter.Buffer.Add( ACBrStr( PadRight('Descri��o:', TAMCOLDESCR)) +
     FpEvento.Evento[0].Infevento.DescEvento);
  FPosPrinter.Buffer.Add( ACBrStr( PadRight('Org�o:', TAMCOLDESCR)) +
     IntToStr(FpEvento.Evento[0].Infevento.cOrgao) );
  FPosPrinter.Buffer.Add( ACBrStr( PadRight('Ambiente:', TAMCOLDESCR) +
     IfThen(FpEvento.Evento[0].RetInfevento.tpAmb = taProducao,
            'PRODUCAO', 'HOMOLOGA��O - SEM VALOR FISCAL') ));
  FPosPrinter.Buffer.Add( ACBrStr( PadRight('Emiss�o:', TAMCOLDESCR)) +
     DateTimeToStr(FpEvento.Evento[0].InfEvento.dhEvento) );
  FPosPrinter.Buffer.Add( PadRight('Sequencia:', TAMCOLDESCR) +
     IntToStr(FpEvento.Evento[0].InfEvento.nSeqEvento) );
  FPosPrinter.Buffer.Add( PadRight('Status:', TAMCOLDESCR) +
     FpEvento.Evento[0].RetInfEvento.xMotivo );
  FPosPrinter.Buffer.Add( PadRight('Protocolo:', TAMCOLDESCR) +
     FpEvento.Evento[0].RetInfEvento.nProt );
  FPosPrinter.Buffer.Add( PadRight('Registro:', TAMCOLDESCR) +
     DateTimeToStr(FpEvento.Evento[0].RetInfEvento.dhRegEvento) );
  
  FPosPrinter.Buffer.Add('</linha_simples>');
end;

procedure TACBrNF3eDANF3eESCPOS.GerarObservacoesEvento;
begin
  if FpEvento.Evento[0].InfEvento.detEvento.xJust <> '' then
  begin
    FPosPrinter.Buffer.Add('</linha_simples>');
    FPosPrinter.Buffer.Add('</fn></ce><n>JUSTIFICATIVA</n>');
    FPosPrinter.Buffer.Add('</fn></ae>' +
       FpEvento.Evento[0].InfEvento.detEvento.xJust );
  end;
end;

procedure TACBrNF3eDANF3eESCPOS.ImprimirDANF3eCancelado(NF3e: TNF3e);
begin
  if NF3e = nil then
  begin
    if not Assigned(ACBrNF3e) then
      raise Exception.Create(ACBrStr('Componente ACBrNF3e n�o atribu�do'));

    if TACBrNF3e(ACBrNF3e).NotasFiscais.Count <= 0 then
      raise Exception.Create(ACBrStr('XML do NF3e n�o informado, obrigat�rio para o modelo ESCPOS'))
    else
      FpNF3e := TACBrNF3e(ACBrNF3e).NotasFiscais.Items[0].NF3e;
  end
  else
    FpNF3e := NF3e;

  FpEvento := TACBrNF3e(ACBrNF3e).EventoNF3e;
  if not Assigned(FpEvento) then
    raise Exception.Create('Arquivo de Evento n�o informado!');

  AtivarPosPrinter;
  GerarCabecalhoEmitente;
  GerarDadosEvento;
  GerarObservacoesEvento;
  GerarInformacoesQRCode(True);
  GerarRodape;

  FPosPrinter.Imprimir;
end;

procedure TACBrNF3eDANF3eESCPOS.ImprimirEVENTO(NF3e: TNF3e);
begin
  ImprimirDANF3eCancelado(NF3e);
end;

procedure TACBrNF3eDANF3eESCPOS.ImprimirRelatorio(const ATexto: TStrings; const AVias: Integer = 1;
      const ACortaPapel: Boolean = True; const ALogo: Boolean = True);
var
  LinhaCmd: String;
begin
  LinhaCmd := '</zera>';

  if ALogo then
    LinhaCmd := LinhaCmd + '</ce></logo>';

  LinhaCmd := LinhaCmd + '</ae>';
  FPosPrinter.Buffer.Add(LinhaCmd);

  FPosPrinter.Buffer.AddStrings( ATexto );

  if ACortaPapel then
    FPosPrinter.Buffer.Add('</corte_parcial>')
  else
    FPosPrinter.Buffer.Add('</pular_linhas>');

  FPosPrinter.Imprimir('', True, True, True, AVias);
end;

{$IFDEF FPC}

initialization
{$I ACBrNF3eDANF3eESCPOS.lrs}
{$ENDIF}

end.
