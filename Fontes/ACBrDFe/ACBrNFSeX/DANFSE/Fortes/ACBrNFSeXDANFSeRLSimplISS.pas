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

unit ACBrNFSeXDANFSeRLSimplISS;

interface

uses
  SysUtils, 
  Variants, 
  Classes, 
  Graphics, 
  Controls, 
  Forms, 
  ExtCtrls,
  RLFilters, 
  RLPDFFilter, 
  RLReport,
  ACBrDelphiZXingQRCode,
  ACBrNFSeXConversao, 
  ACBrNFSeXDANFSeRL;

type

  { TfrlXDANFSeRLSimplISS }

  TfrlXDANFSeRLSimplISS = class(TfrlXDANFSeRL)
    rlbCabecalho: TRLBand;
    RLDraw2: TRLDraw;
    RLDraw3: TRLDraw;
    RLDraw70: TRLDraw;
    rllNumNF0: TRLLabel;
    RLLabel13: TRLLabel;
    rliLogo: TRLImage;
    rllEmissao: TRLLabel;
    rllCodVerificacao: TRLLabel;
    rlmPrefeitura: TRLMemo;
    rlbPrestador: TRLBand;
    rllPrestMunicipio: TRLLabel;
    rllPrestInscMunicipal: TRLLabel;
    rllPrestEndereco: TRLLabel;
    rllPrestCNPJ: TRLLabel;
    rllPrestNome: TRLLabel;
    rllPrestUF: TRLLabel;
    rllPrestComplemento: TRLLabel;
    rllPrestTelefone: TRLLabel;
    rllPrestEmail: TRLLabel;
    rlbTomador: TRLBand;
    rllTomaCNPJ: TRLLabel;
    rllTomaInscMunicipal: TRLLabel;
    rllTomaNome: TRLLabel;
    rllTomaEndereco: TRLLabel;
    rllTomaMunicipio: TRLLabel;
    rllTomaUF: TRLLabel;
    rllTomaEmail: TRLLabel;
    rllTomaComplemento: TRLLabel;
    rllTomaTelefone: TRLLabel;
    rlbHeaderItens: TRLBand;
    rlbItens: TRLBand;
    rlbISSQN: TRLBand;
    rbOutrasInformacoes: TRLBand;
    RLLabel60: TRLLabel;
    rllTomaInscEstadual: TRLLabel;
    rlbHeaderItensDetalhado: TRLBand;
    subItens: TRLSubDetail;
    rlbItensServico: TRLBand;
    txtServicoQtde: TRLLabel;
    rlmServicoDescricao: TRLMemo;
    txtServicoUnitario: TRLLabel;
    txtServicoTotal: TRLLabel;
    rllPrestInscEstadual: TRLLabel;
    RLLabel70: TRLLabel;
    rllNFSeSerie: TRLLabel;
    RLLabel71: TRLLabel;
    RLLabel72: TRLLabel;
    RLDraw12: TRLDraw;
    RLDraw18: TRLDraw;
    RLLabel12: TRLLabel;
    RLDraw19: TRLDraw;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel32: TRLLabel;
    RLLabel31: TRLLabel;
    RLLabel29: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel22: TRLLabel;
    rllPrestNomeFantasia: TRLLabel;
    RLLabel74: TRLLabel;
    RLLabel9: TRLLabel;
    RLLabel23: TRLLabel;
    RLLabel24: TRLLabel;
    RLLabel4: TRLLabel;
    RLDraw20: TRLDraw;
    RLLabel15: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel17: TRLLabel;
    RLLabel19: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel61: TRLLabel;
    RLLabel25: TRLLabel;
    RLLabel21: TRLLabel;
    RLLabel27: TRLLabel;
    RLLabel14: TRLLabel;
    RLLabel66: TRLLabel;
    RLLabel87: TRLLabel;
    RLLabel65: TRLLabel;
    RLLabel68: TRLLabel;
    RLLabel67: TRLLabel;
    RLDraw25: TRLDraw;
    RLDraw22: TRLDraw;
    RLDraw23: TRLDraw;
    RLDraw24: TRLDraw;
    txtServicoTributavel: TRLLabel;
    RLDraw26: TRLDraw;
    RLDraw27: TRLDraw;
    RLDraw28: TRLDraw;
    RLDraw29: TRLDraw;
    RLLabel90: TRLLabel;
    rllValorTributavel: TRLLabel;
    RLLabel91: TRLLabel;
    rllValorNaoTributavel: TRLLabel;
    RLLabel116: TRLLabel;
    rllValorServicos1: TRLLabel;
    RLLabel96: TRLLabel;
    rllValorDeducoes: TRLLabel;
    rllDescIncondicionado: TRLLabel;
    RLLabel95: TRLLabel;
    rllDescCondicionado: TRLLabel;
    RLLabel100: TRLLabel;
    rllBaseCalc: TRLLabel;
    RLLabel98: TRLLabel;
    rllAliquota: TRLLabel;
    RLLabel102: TRLLabel;
    rllValorISS: TRLLabel;
    RLLabel104: TRLLabel;
    RLLabel105: TRLLabel;
    rllValorPIS: TRLLabel;
    rllValorCOFINS: TRLLabel;
    RLLabel107: TRLLabel;
    rllValorINSS: TRLLabel;
    RLLabel108: TRLLabel;
    rllValorIR: TRLLabel;
    RLLabel110: TRLLabel;
    rllValorCSLL: TRLLabel;
    RLLabel113: TRLLabel;
    rllOutrasRetencoes: TRLLabel;
    RLLabel115: TRLLabel;
    rllValorLiquido: TRLLabel;
    RLLabel118: TRLLabel;
    RLLabel120: TRLLabel;
    rlmCodServico: TRLMemo;
    RLDraw53: TRLDraw;
    RLDraw32: TRLDraw;
    RLDraw33: TRLDraw;
    RLDraw34: TRLDraw;
    RLDraw35: TRLDraw;
    RLDraw30: TRLDraw;
    RLDraw31: TRLDraw;
    RLDraw13: TRLDraw;
    RLDraw17: TRLDraw;
    RLDraw6: TRLDraw;
    RLDraw14: TRLDraw;
    RLLabel16: TRLLabel;
    RLLabel34: TRLLabel;
    RLLabel36: TRLLabel;
    RLLabel56: TRLLabel;
    RLLabel40: TRLLabel;
    RLLabel106: TRLLabel;
    rllDataHoraImpressao: TRLLabel;
    rllCNAE: TRLLabel;
    rllIncentivador: TRLLabel;
    rllRecolhimento: TRLLabel;
    rllCompetencia: TRLLabel;
    RLLabel93: TRLLabel;
    rllMunicipioPrestacaoServico: TRLLabel;
    RLLabel89: TRLLabel;
    rllRegimeEspecial: TRLLabel;
    rllOpcaoSimples: TRLLabel;
    lblNatOperacao: TRLLabel;
    rllNatOperacao: TRLLabel;
    RLLabel55: TRLLabel;
    rllSistema: TRLLabel;
    RLLabel41: TRLLabel;
    RLLabel42: TRLLabel;
    RLLabel103: TRLLabel;
    RLLabel44: TRLLabel;
    rllDataGeracao: TRLLabel;
    rllNumeroRps: TRLLabel;
    rllSerieRps: TRLLabel;
    rllNumNFSeSubstituida: TRLLabel;
    RLLabel46: TRLLabel;
    RLSystemInfo3: TRLSystemInfo;
    RLLabel47: TRLLabel;
    RLSystemInfo4: TRLSystemInfo;
    rllTituloConstCivil: TRLLabel;
    rllCodigoObra: TRLLabel;
    rllCodObra: TRLLabel;
    rllCodigoArt: TRLLabel;
    rllCodART: TRLLabel;
    RLDraw15: TRLDraw;
    rlsLinhaH1: TRLDraw;
    RLDraw52: TRLDraw;
    rlbCanhoto: TRLBand;
    RLLabel26: TRLLabel;
    rllPrestNomeEnt: TRLLabel;
    RLLabel28: TRLLabel;
    RLLabel59: TRLLabel;
    RLLabel58: TRLLabel;
    RLDraw7: TRLDraw;
    RLLabel33: TRLLabel;
    RLLabel57: TRLLabel;
    rllNumNF0Ent: TRLLabel;
    RLLabel6: TRLLabel;
    rllCodVerificacao2: TRLLabel;
    RLDraw5: TRLDraw;
    RLDraw1: TRLDraw;
    RLLabel3: TRLLabel;
    rllMsgTeste: TRLLabel;
    RLDraw4: TRLDraw;
    rlmDescricao: TRLMemo;
    rliPrestLogo: TRLImage;
    RLLabel38: TRLLabel;
    rlmDadosAdicionais: TRLMemo;

    procedure rlbCabecalhoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbItensServicoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbPrestadorBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbTomadorBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbISSQNBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rbOutrasInformacoesBeforePrint(Sender: TObject;
      var PrintIt: Boolean);
    procedure RLNFSeBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure subItensDataRecord(Sender: TObject; RecNo: Integer;
       CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure rlbHeaderItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    { Private declarations }
    FNumItem: Integer;
  public
    { Public declarations }
    class procedure QuebradeLinha(const sQuebradeLinha: String); override;
  end;

var
  frlXDANFSeRLSimplISS: TfrlXDANFSeRLSimplISS;

implementation

uses
  StrUtils, DateUtils,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime,
  ACBrNFSeX, ACBrNFSeXClass, ACBrNFSeXInterface,
  ACBrValidador, ACBrDFeReportFortes;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

var
  FQuebradeLinha: String;

{ TfrlXDANFSeRLSimplISS }

class procedure TfrlXDANFSeRLSimplISS.QuebradeLinha(const sQuebradeLinha: String);
begin
  FQuebradeLinha := sQuebradeLinha;
end;

procedure TfrlXDANFSeRLSimplISS.rbOutrasInformacoesBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
  QrCode: TDelphiZXingQRCode;
  QrCodeBitmap: TBitmap;
  QRCodeData: String;
  rlImgQrCode: TRLImage;
  Row, Column: Integer;
begin
  inherited;

  rlmDadosAdicionais.Lines.BeginUpdate;
  rlmDadosAdicionais.Lines.Clear;

  if fpNFSe.OutrasInformacoes <> '' then
    rlmDadosAdicionais.Lines.Add(StringReplace(fpNFSe.OutrasInformacoes, FQuebradeLinha, #13#10, [rfReplaceAll]))
  else
    if fpDANFSe.OutrasInformacaoesImp <> '' then
      rlmDadosAdicionais.Lines.Add(StringReplace(fpDANFSe.OutrasInformacaoesImp, ';', #13#10, [rfReplaceAll]));

  if fpNFSe.InformacoesComplementares <> '' then
    rlmDadosAdicionais.Lines.Add(StringReplace(fpNFSe.InformacoesComplementares, FQuebradeLinha, #13#10, [rfReplaceAll]));

  if fpNFSe.Link <> '' then
  begin
    rlmDadosAdicionais.Width := 643;

    rlImgQrCode          := TRLImage.Create(rbOutrasInformacoes);
    rlImgQrCode.Parent   := rbOutrasInformacoes;
    rlImgQrCode.Stretch  := True;
    rlImgQrCode.AutoSize := False;
    rlImgQrCode.Center   := true;
    rlImgQrCode.SetBounds(648, 3, 90, 90);
    rlImgQrCode.BringToFront;

    QRCodeData   := fpNFSe.Link;
    QRCode       := TDelphiZXingQRCode.Create;
    QRCodeBitmap := TBitmap.Create;
    try
      QRCode.Encoding  := qrUTF8NoBOM;
      QRCode.QuietZone := 1;
      QRCode.Data      := WideString(QRCodeData);

      QRCodeBitmap.Width  := QRCode.Columns;
      QRCodeBitmap.Height := QRCode.Rows;

      for Row := 0 to QRCode.Rows - 1 do
      begin
        for Column := 0 to QRCode.Columns - 1 do
        begin
          if (QRCode.IsBlack[Row, Column]) then
            QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack
          else
            QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;

      rlImgQrCode.Picture.Bitmap.Assign(QRCodeBitmap);
    finally
      QRCode.Free;
      QRCodeBitmap.Free;
    end;
  end;

  rlmDadosAdicionais.Lines.EndUpdate;

  {
  rllDataHoraImpressao.Visible := NaoEstaVazio(fpDANFSe.Usuario);
  rllDataHoraImpressao.Caption := ACBrStr('DATA / HORA DA IMPRESS�O: ') +
                               FormatDateTimeBr(Now) + ' - ' + fpDANFSe.Usuario;

  rllSistema.Visible := NaoEstaVazio(fpDANFSe.Sistema);
  rllSistema.Caption := Format('Desenvolvido por %s', [fpDANFSe.Sistema]);
  }
  //Exibe canhoto
  rlbCanhoto.Visible := fpDANFSe.ImprimeCanhoto;
end;

procedure TfrlXDANFSeRLSimplISS.rlbCabecalhoBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  TDFeReportFortes.CarregarLogo(rliLogo, fpDANFSe.Logo);

  rlmPrefeitura.Lines.Clear;
  rlmPrefeitura.Lines.Add(StringReplace(fpDANFSe.Prefeitura, ';', #13#10, [rfReplaceAll,rfIgnoreCase]));

  With fpNFSe do
  begin
    rllNumNF0.Caption := FormatFloat('00000000000', StrToFloatDef(Numero, 0));
    rllEmissao.Caption := FormatDateTime('dd/mm/yyyy hh:nn', DataEmissao);
    rllCodVerificacao.Caption := CodigoVerificacao;

    rllCompetencia.Caption := IfThen(Competencia > 0, FormatDateTime('mm/yyyy', Competencia), '');

    rllNumeroRPS.Caption := IdentificacaoRps.Numero;
    rllNumNFSeSubstituida.Caption := NfseSubstituida;

    rllMunicipioPrestacaoServico.Caption := Servico.MunicipioPrestacaoServico;

    rllNFSeSerie.Caption := 'E';//SeriePrestacao; //estava pegando serie rps
  end;
end;

procedure TfrlXDANFSeRLSimplISS.rlbHeaderItensBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  inherited;
  rlmDescricao.Lines.Clear;
  rlmDescricao.Lines.Add(fpNFSe.Servico.Discriminacao);

  rllMsgTeste.Visible := (fpDANFSe.Producao = snNao);
  rllMsgTeste.Enabled := (fpDANFSe.Producao = snNao);

  if fpDANFSe.Cancelada or (fpNFSe.NfseCancelamento.DataHora <> 0) or
    (fpNFSe.SituacaoNfse = snCancelado) or (fpNFSe.StatusRps = srCancelado) then
  begin
    rllMsgTeste.Caption := 'NFS-e CANCELADA';
    rllMsgTeste.Visible := True;
    rllMsgTeste.Enabled := True;
  end;

  rllMsgTeste.Repaint;
end;

procedure TfrlXDANFSeRLSimplISS.rlbItensServicoBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  with fpNFSe.Servico.ItemServico.Items[FNumItem] do
  begin
    txtServicoQtde.Caption := FormatFloatBr(Quantidade);
    rlmServicoDescricao.Lines.Clear;
    rlmServicoDescricao.Lines.Add(Descricao);
    txtServicoUnitario.Caption := FormatFloatBr(ValorUnitario);

    if ValorTotal = 0.0 then
      ValorTotal := Quantidade * ValorUnitario;

    txtServicoTotal.Caption := FormatFloatBr(ValorTotal);

    if (Tributavel = snSim) then
      txtServicoTributavel.Caption := 'Sim'
    else
      txtServicoTributavel.Caption := 'N�o';
  end;
end;

procedure TfrlXDANFSeRLSimplISS.rlbISSQNBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  MostrarObra, MostrarNaturezaOperacao: Boolean;
  FProvider: IACBrNFSeXProvider;
begin
  inherited;

  RLLabel16.Visible := False;

  FProvider := ACBrNFSe.Provider;

  With fpNFSe do
  begin
    rllNatOperacao.Caption    := ACBrStr(FProvider.NaturezaOperacaoDescricao(NaturezaOperacao));
    MostrarNaturezaOperacao   := rllNatOperacao.Caption<>'';
    lblNatOperacao.Visible    := MostrarNaturezaOperacao;
    rllRegimeEspecial.Caption := ACBrStr(FProvider.RegimeEspecialTributacaoDescricao(RegimeEspecialTributacao));
    rllOpcaoSimples.Caption   := ACBrStr(FProvider.SimNaoDescricao(OptanteSimplesNacional));
    rllIncentivador.Caption   := ACBrStr(FProvider.SimNaoDescricao(IncentivadorCultural));
    rllCodObra.Caption        := ConstrucaoCivil.CodigoObra;
    rllCodART.Caption         := ConstrucaoCivil.Art;

    MostrarObra := (rllCodObra.Caption <> '') or (rllCodART.Caption <> '');

    RLDraw52.Visible            := MostrarObra;
    rllTituloConstCivil.Visible := MostrarObra;
    rllCodigoObra.Visible       := MostrarObra;
    rllCodObra.Visible          := MostrarObra;
    rllCodigoArt.Visible        := MostrarObra;
    rllCodART.Visible           := MostrarObra;

    if (MostrarObra) then
      rlbISSQN.Height:= 272
    else
      rlbISSQN.Height:= 240;

    rlmCodServico.Lines.Clear;

    if Servico.xItemListaServico <> '' then
    begin
      RLLabel16.Visible := True;

      if fpDANFSe.Atividade <> '' then
        rlmCodServico.Lines.Append('Atividade: ' + fpDANFSe.Atividade);

      rlmCodServico.Lines.Append(Servico.ItemListaServico + ' - '+ Servico.xItemListaServico);

      rlmCodServico.Height := Trunc(rlmCodServico.Height * 2.5);
    end
    else
    begin
      if fpDANFSe.Atividade <> '' then
      begin
        RLLabel16.Visible := True;
        RLLabel16.Caption := 'Atividade:';
        rlmCodServico.Lines.Append(fpDANFSe.Atividade);
      end
    end;

    rllValorTributavel.Caption    := FormatFloat(',0.00', Servico.Valores.BaseCalculo);
    rllValorNaoTributavel.Caption := '0,00'; // ToDo
    rllValorPIS.Caption           := FormatFloat(',0.00', Servico.Valores.ValorPis);
    rllValorCOFINS.Caption        := FormatFloat(',0.00', Servico.Valores.ValorCofins);
    rllValorIR.Caption            := FormatFloat(',0.00', Servico.Valores.ValorIr);
    rllValorINSS.Caption          := FormatFloat(',0.00', Servico.Valores.ValorInss);
    rllValorCSLL.Caption          := FormatFloat(',0.00', Servico.Valores.ValorCsll);
    rllValorServicos1.Caption     := FormatFloat(',0.00', Servico.Valores.ValorServicos);
    rllDescIncondicionado.Caption := FormatFloat(',0.00', Servico.Valores.DescontoIncondicionado);
    rllDescCondicionado.Caption   := FormatFloat(',0.00', Servico.Valores.DescontoCondicionado);
    rllOutrasRetencoes.Caption    := FormatFloat(',0.00', Servico.Valores.OutrasRetencoes);
    rllValorLiquido.Caption       := FormatFloat(',0.00', Servico.Valores.ValorLiquidoNfse);
    rllValorDeducoes.Caption      := FormatFloat(',0.00', Servico.Valores.ValorDeducoes);
    rllBaseCalc.Caption           := FormatFloat(',0.00', Servico.Valores.BaseCalculo);
    rllAliquota.Caption           := fpDANFSe.FormatarAliquota(Servico.Valores.Aliquota);
    rllValorISS.Caption           := FormatFloat(',0.00',Servico.Valores.ValorIss);

    rllCNAE.Caption := fpNFSe.Servico.CodigoCnae;
    rllDataGeracao.Caption := FormatDateTime('dd/mm/yyyy hh:nn', DataEmissao);
    case Servico.Valores.IssRetido of
      stRetencao:
        rllRecolhimento.Caption := 'Com Reten��o';
      stNormal:
        rllRecolhimento.Caption := 'Sem Reten��o';
      stSubstituicao:
        rllRecolhimento.Caption := 'Substitui��o';
    else
      rllRecolhimento.Caption := '';
    end;
  end;

  rllDataHoraImpressao.Caption := FormatDateTime('dd/mm/yyyy hh:nn',Now);

  if fpDANFSe.Usuario <> '' then
    rllDataHoraImpressao.Caption := Format(ACBrStr('%s   USU�RIO: %s'),
      [rllDataHoraImpressao.Caption, fpDANFSe.Usuario]);

  if fpDANFSe.Sistema <> '' then
    rllSistema.Caption := Format('Desenvolvido por %s %s' , [fpDANFSe.Sistema, fpDANFSe.Site])
  else
    rllSistema.Caption := '';
end;

procedure TfrlXDANFSeRLSimplISS.rlbItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

//  rlmDescricao.Lines.Clear;
//  rlmDescricao.Lines.Add(StringReplace(fpNFSe.Servico.Discriminacao,
//                          FQuebradeLinha, #13#10, [rfReplaceAll, rfIgnoreCase]));
end;

procedure TfrlXDANFSeRLSimplISS.rlbPrestadorBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  xEndereco, xNumero, xComplemento, xBairro, xMunic, xUF, xCEP, xFone,
  xEmail: string;
begin
  inherited;

  TDFeReportFortes.CarregarLogo(rliPrestLogo, fpDANFSe.Prestador.Logo);

  rllPrestNome.Caption := fpDANFSe.Prestador.RazaoSocial;
  rllPrestNomeFantasia.Caption := fpDANFSe.Prestador.NomeFantasia;
  rllPrestNomeEnt.Caption := rllPrestNome.Caption;

  rllPrestCNPJ.Caption := FormatarCNPJouCPF(fpDANFSe.Prestador.CNPJ);
  rllPrestInscMunicipal.Caption := fpDANFSe.Prestador.InscricaoMunicipal;
  rllPrestInscEstadual.Caption := fpDANFSe.Prestador.InscricaoEstadual;

  xEndereco := Trim(fpDANFSe.Prestador.Endereco);
  xNumero := Trim(fpDANFSe.Prestador.Numero);

  if xNumero <> '' then
    xEndereco := xEndereco + ', ' + xNumero;

  xComplemento := Trim(fpDANFSe.Prestador.Complemento);
  xBairro := Trim(fpDANFSe.Prestador.Bairro);
  xMunic := Trim(fpDANFSe.Prestador.Municipio);
  xUF := Trim(fpDANFSe.Prestador.UF);
  xCEP := Trim(fpDANFSe.Prestador.CEP);

  if xCEP <> '' then
    xCEP := ' CEP: ' + FormatarCEP(xCEP);

  xFone := Trim(fpDANFSe.Prestador.Fone);

  if xFone <> '' then
    xFone := FormatarFone(xFone);

  xEmail := Trim(fpDANFSe.Prestador.Email);

  rllPrestEndereco.Caption :=  xEndereco + ' ' + xBairro + ' - ' + xCEP + #13;
  rllPrestComplemento.Caption := xComplemento;
  rllPrestMunicipio.Caption := xMunic;
  rllPrestUF.Caption := xUF;
  rllPrestTelefone.Caption := xFone;
  rllPrestEmail.Caption := xEmail;

  rllNumNF0Ent.Caption := FormatFloat('00000000000', StrToFloatDef(fpNFSe.Numero, 0));
  rllCodVerificacao2.Caption := fpNFSe.CodigoVerificacao;
end;

procedure TfrlXDANFSeRLSimplISS.rlbTomadorBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  inherited;

  with fpNFSe.Tomador do
  begin
    rllTomaNome.Caption := RazaoSocial;

    if Length(IdentificacaoTomador.CpfCnpj)<=11 then
      rllTomaCNPJ.Caption := FormatarCPF(IdentificacaoTomador.CpfCnpj)
    else
      rllTomaCNPJ.Caption := FormatarCNPJ(IdentificacaoTomador.CpfCnpj);

    rllTomaInscMunicipal.Caption := IfThen(IdentificacaoTomador.InscricaoMunicipal <> '' ,
      IdentificacaoTomador.InscricaoMunicipal , fpDANFSe.Tomador.InscricaoMunicipal);

    rllTomaInscEstadual.Caption := IfThen(IdentificacaoTomador.InscricaoEstadual <> '',
      IdentificacaoTomador.InscricaoEstadual, fpDANFSe.Tomador.InscricaoEstadual);

    if Endereco.Endereco <> '' then
    begin
      rllTomaEndereco.Caption :=  Trim(Endereco.Endereco) + ', '  +
                                  Trim(Endereco.Numero)  + ' - ' +
                                  Trim(Endereco.Bairro)  + ' - CEP: ' +
                                  FormatarCEP(Endereco.CEP);
    end
    else
     rllTomaEndereco.Caption := Trim(fpDANFSe.Tomador.Endereco) + ' - CEP: ' +
                                FormatarCEP(Endereco.CEP);

    rllTomaComplemento.Caption := IfThen(Endereco.Complemento <> '' ,
      Endereco.Complemento , fpDANFSe.Tomador.Complemento);

    rllTomaMunicipio.Caption := Endereco.xMunicipio;

    rllTomaUF.Caption := Endereco.UF;

    rllTomaTelefone.Caption := IfThen(Contato.Telefone <> '' ,
      FormatarFone(Contato.Telefone) , FormatarFone(fpDANFSe.Tomador.Fone));
    rllTomaEmail.Caption    := IfThen(Contato.Email    <> '' ,
      Contato.Email , fpDANFSe.Tomador.Email);
  end;
end;

procedure TfrlXDANFSeRLSimplISS.RLNFSeBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
  Detalhar: Boolean;
begin
  inherited;

  //Detalhar := ACBrNFSe.Provider.ConfigGeral.DetalharServico;
  Detalhar := fpDANFSe.DetalharServico;
  RLNFSe.Title := 'NFS-e: ' + fpNFSe.Numero;
  TDFeReportFortes.AjustarMargem(RLNFSe, fpDANFSe);
  rlbItens.Visible := not Detalhar;
  rlbHeaderItensDetalhado.Visible := Detalhar;
  subItens.Visible := Detalhar;

//  rlbItens.Visible := not (fpDANFSe.DetalharServico);
//  rlbHeaderItensDetalhado.Visible := fpDANFSe.DetalharServico;
//  subItens.Visible := fpDANFSe.DetalharServico;

  // Estudar a melhor forma de n�o especificar o provedor.
  RLLabel65.Visible := not (ACBrNFSe.Configuracoes.Geral.Provedor in [proSimple]);
  txtServicoQtde.Visible := not (ACBrNFSe.Configuracoes.Geral.Provedor in [proSimple]);
end;

procedure TfrlXDANFSeRLSimplISS.subItensDataRecord(Sender: TObject;
   RecNo: Integer; CopyNo: Integer; var Eof: Boolean;
   var RecordAction: TRLRecordAction);
begin
  inherited;

  FNumItem := RecNo - 1;
  Eof := (RecNo > fpNFSe.Servico.ItemServico.Count);
  RecordAction := raUseIt;
end;

end.
