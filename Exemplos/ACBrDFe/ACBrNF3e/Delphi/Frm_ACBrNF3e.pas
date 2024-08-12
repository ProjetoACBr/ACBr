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

unit Frm_ACBrNF3e;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, Buttons, ComCtrls, OleCtrls, SHDocVw,
  ShellAPI, XMLIntf, XMLDoc, zlib,
  ACBrDFe, ACBrDFeReport, ACBrBase,
  ACBrPosPrinter, ACBrNF3eDANF3eClass, ACBrNF3eDANF3eESCPOS, ACBrNF3e, ACBrMail,
  ACBrNF3e.DANF3ERLClass;

type
  TfrmACBrNF3e = class(TForm)
    pnlMenus: TPanel;
    pnlCentral: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    PageControl4: TPageControl;
    TabSheet3: TTabSheet;
    lSSLLib: TLabel;
    lCryptLib: TLabel;
    lHttpLib: TLabel;
    lXmlSign: TLabel;
    gbCertificado: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    sbtnCaminhoCert: TSpeedButton;
    Label25: TLabel;
    sbtnGetCert: TSpeedButton;
    sbtnNumSerie: TSpeedButton;
    edtCaminho: TEdit;
    edtSenha: TEdit;
    edtNumSerie: TEdit;
    btnDataValidade: TButton;
    btnNumSerie: TButton;
    btnSubName: TButton;
    btnCNPJ: TButton;
    btnIssuerName: TButton;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    btnSha256: TButton;
    cbAssinar: TCheckBox;
    btnHTTPS: TButton;
    btnLeituraX509: TButton;
    cbSSLLib: TComboBox;
    cbCryptLib: TComboBox;
    cbHttpLib: TComboBox;
    cbXmlSignLib: TComboBox;
    TabSheet4: TTabSheet;
    GroupBox3: TGroupBox;
    sbtnPathSalvar: TSpeedButton;
    Label29: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label42: TLabel;
    spPathSchemas: TSpeedButton;
    edtPathLogs: TEdit;
    ckSalvar: TCheckBox;
    cbFormaEmissao: TComboBox;
    cbxAtualizarXML: TCheckBox;
    cbxExibirErroSchema: TCheckBox;
    edtFormatoAlerta: TEdit;
    cbxRetirarAcentos: TCheckBox;
    cbVersaoDF: TComboBox;
    edtPathSchemas: TEdit;
    TabSheet7: TTabSheet;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    lTimeOut: TLabel;
    lSSLLib1: TLabel;
    cbxVisualizar: TCheckBox;
    cbUF: TComboBox;
    rgTipoAmb: TRadioGroup;
    cbxSalvarSOAP: TCheckBox;
    seTimeOut: TSpinEdit;
    cbSSLType: TComboBox;
    gbProxy: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edtProxyHost: TEdit;
    edtProxyPorta: TEdit;
    edtProxyUser: TEdit;
    edtProxySenha: TEdit;
    gbxRetornoEnvio: TGroupBox;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    cbxAjustarAut: TCheckBox;
    edtTentativas: TEdit;
    edtIntervalo: TEdit;
    edtAguardar: TEdit;
    TabSheet12: TTabSheet;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    edtEmitCNPJ: TEdit;
    edtEmitIE: TEdit;
    edtEmitRazao: TEdit;
    edtEmitFantasia: TEdit;
    edtEmitFone: TEdit;
    edtEmitCEP: TEdit;
    edtEmitLogradouro: TEdit;
    edtEmitNumero: TEdit;
    edtEmitComp: TEdit;
    edtEmitBairro: TEdit;
    edtEmitCodCidade: TEdit;
    edtEmitCidade: TEdit;
    edtEmitUF: TEdit;
    TabSheet13: TTabSheet;
    sbPathNF3e: TSpeedButton;
    Label35: TLabel;
    Label47: TLabel;
    sbPathEvento: TSpeedButton;
    cbxSalvarArqs: TCheckBox;
    cbxPastaMensal: TCheckBox;
    cbxAdicionaLiteral: TCheckBox;
    cbxEmissaoPathNF3e: TCheckBox;
    cbxSalvaPathEvento: TCheckBox;
    cbxSepararPorCNPJ: TCheckBox;
    edtPathNF3e: TEdit;
    edtPathEvento: TEdit;
    cbxSepararPorModelo: TCheckBox;
    TabSheet2: TTabSheet;
    Label7: TLabel;
    sbtnLogoMarca: TSpeedButton;
    edtLogoMarca: TEdit;
    rgTipoDANF3e: TRadioGroup;
    TabSheet14: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    edtSmtpHost: TEdit;
    edtSmtpPort: TEdit;
    edtSmtpUser: TEdit;
    edtSmtpPass: TEdit;
    edtEmailAssunto: TEdit;
    cbEmailSSL: TCheckBox;
    mmEmailMsg: TMemo;
    btnSalvarConfig: TBitBtn;
    lblColaborador: TLabel;
    lblPatrocinador: TLabel;
    lblDoar1: TLabel;
    lblDoar2: TLabel;
    pgcBotoes: TPageControl;
    tsEnvios: TTabSheet;
    tsConsultas: TTabSheet;
    tsEventos: TTabSheet;
    btnCriarEnviar: TButton;
    btnConsultar: TButton;
    btnConsultarChave: TButton;
    btnConsultarRecibo: TButton;
    btnValidarRegrasNegocio: TButton;
    btnGerarXML: TButton;
    btnValidarXML: TButton;
    btnEnviarEmail: TButton;
    btnAdicionarProtocolo: TButton;
    btnCarregarXMLEnviar: TButton;
    btnValidarAssinatura: TButton;
    btnCancelarXML: TButton;
    btnCancelarChave: TButton;
    btnImprimirEvento: TButton;
    btnEnviarEventoEmail: TButton;
    tsDistribuicao: TTabSheet;
    btnDistribuicaoDFe: TButton;
    pgRespostas: TPageControl;
    TabSheet5: TTabSheet;
    MemoResp: TMemo;
    TabSheet6: TTabSheet;
    WBResposta: TWebBrowser;
    TabSheet8: TTabSheet;
    memoLog: TMemo;
    TabSheet9: TTabSheet;
    trvwDocumento: TTreeView;
    TabSheet10: TTabSheet;
    memoRespWS: TMemo;
    Dados: TTabSheet;
    MemoDados: TMemo;
    ACBrPosPrinter1: TACBrPosPrinter;
    ACBrMail1: TACBrMail;
    OpenDialog1: TOpenDialog;
    gbEscPos: TGroupBox;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    btSerial: TBitBtn;
    cbxModeloPosPrinter: TComboBox;
    cbxPorta: TComboBox;
    cbxPagCodigo: TComboBox;
    seColunas: TSpinEdit;
    seEspLinhas: TSpinEdit;
    seLinhasPular: TSpinEdit;
    cbCortarPapel: TCheckBox;
    btnImprimirDANF3E: TButton;
    btnImprimirDANF3EOffline: TButton;
    rgDANF3E: TRadioGroup;
    btnStatusServ: TButton;
    ACBrNF3e1: TACBrNF3e;
    ACBrNF3eDANF3eESCPOS1: TACBrNF3eDANF3eESCPOS;
    ACBrNF3eDANF3eRL1: TACBrNF3eDANF3eRL;
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarConfigClick(Sender: TObject);
    procedure sbPathNF3eClick(Sender: TObject);
    procedure sbPathEventoClick(Sender: TObject);
    procedure sbtnCaminhoCertClick(Sender: TObject);
    procedure sbtnNumSerieClick(Sender: TObject);
    procedure sbtnGetCertClick(Sender: TObject);
    procedure btnDataValidadeClick(Sender: TObject);
    procedure btnNumSerieClick(Sender: TObject);
    procedure btnSubNameClick(Sender: TObject);
    procedure btnCNPJClick(Sender: TObject);
    procedure btnIssuerNameClick(Sender: TObject);
    procedure btnSha256Click(Sender: TObject);
    procedure btnHTTPSClick(Sender: TObject);
    procedure btnLeituraX509Click(Sender: TObject);
    procedure sbtnPathSalvarClick(Sender: TObject);
    procedure spPathSchemasClick(Sender: TObject);
    procedure sbtnLogoMarcaClick(Sender: TObject);
    procedure PathClick(Sender: TObject);
    procedure cbSSLTypeChange(Sender: TObject);
    procedure cbSSLLibChange(Sender: TObject);
    procedure cbCryptLibChange(Sender: TObject);
    procedure cbHttpLibChange(Sender: TObject);
    procedure cbXmlSignLibChange(Sender: TObject);
    procedure lblColaboradorClick(Sender: TObject);
    procedure lblPatrocinadorClick(Sender: TObject);
    procedure lblDoar1Click(Sender: TObject);
    procedure lblDoar2Click(Sender: TObject);
    procedure lblMouseEnter(Sender: TObject);
    procedure lblMouseLeave(Sender: TObject);
    procedure btnStatusServClick(Sender: TObject);
    procedure btnGerarXMLClick(Sender: TObject);
    procedure btnCriarEnviarClick(Sender: TObject);
    procedure btnCarregarXMLEnviarClick(Sender: TObject);
    procedure btnValidarRegrasNegocioClick(Sender: TObject);
    procedure btnValidarXMLClick(Sender: TObject);
    procedure btnValidarAssinaturaClick(Sender: TObject);
    procedure btnAdicionarProtocoloClick(Sender: TObject);
    procedure btnEnviarEmailClick(Sender: TObject);
    procedure btnConsultarReciboClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnConsultarChaveClick(Sender: TObject);
    procedure btnCancelarXMLClick(Sender: TObject);
    procedure btnCancelarChaveClick(Sender: TObject);
    procedure btnImprimirEventoClick(Sender: TObject);
    procedure btnEnviarEventoEmailClick(Sender: TObject);
    procedure btnDistribuicaoDFeClick(Sender: TObject);
    procedure btSerialClick(Sender: TObject);
    procedure btnImprimirDANF3EClick(Sender: TObject);
    procedure btnImprimirDANF3EOfflineClick(Sender: TObject);
    procedure ACBrNF3e1GerarLog(const ALogLine: String;
      var Tratado: Boolean);
    procedure ACBrNF3e1StatusChange(Sender: TObject);
  private
    { Private declarations }
    procedure GravarConfiguracao;
    procedure LerConfiguracao;
    procedure ConfigurarComponente;
    procedure ConfigurarEmail;
    Procedure AlimentarComponente(NumDFe: String);
    procedure LoadXML(RetWS: String; MyWebBrowser: TWebBrowser);
    procedure AtualizarSSLLibsCombo;
    procedure PrepararImpressao;
  public
    { Public declarations }
  end;

var
  frmACBrNF3e: TfrmACBrNF3e;

implementation

uses
  strutils, math, TypInfo, DateUtils, synacode, blcksock, FileCtrl, Grids,
  IniFiles, Printers,
  ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.XMLHTML, ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrDFeUtil, ACBrDFeSSL, ACBrDFeOpenSSL,
  ACBrXmlBase,
  pcnAuxiliar, pcnConversao,
  ACBrNF3eConversao,
  Frm_Status, Frm_SelecionarCertificado, Frm_ConfiguraSerial;

const
  SELDIRHELP = 1000;

{$R *.dfm}

{ TfrmACBrNF3e }

procedure TfrmACBrNF3e.AlimentarComponente(NumDFe: String);
var
  i: Integer;
begin
  ACBrNF3e1.NotasFiscais.Clear;

  with ACBrNF3e1.NotasFiscais.Add.NF3e do
  begin
    // Dados de Identifica��o do NF3-e
    //
    Ide.cUF := UFtoCUF(edtEmitUF.Text);

    // TpcnTipoAmbiente = (taProducao, taHomologacao);
    case rgTipoAmb.ItemIndex of
      0: Ide.tpAmb := TACBrTipoAmbiente.taProducao;
      1: Ide.tpAmb := TACBrTipoAmbiente.taHomologacao;
    end;

    Ide.modelo := 66;
    Ide.serie  := 1;
    Ide.nNF    := StrToIntDef(NumDFe, 0);
    {
      A fun��o GerarCodigoDFe possui 2 par�metros:
      sendo que o primeiro (obrigat�rio) � o numero do documento
      e o segundo (opcional) � a quantidade de digitos que o c�digo tem.
      Os valores aceitos para o segundo par�mentros s�o: 7 ou 8 (padr�o)
    }
    Ide.cNF := GerarCodigoDFe(Ide.nNF, 7);

    Ide.dhEmi  := Now;
    // TpcnTipoEmissao = (teNormal, teOffLine);
    Ide.tpEmis  := TACBrTipoEmissao.teNormal;
//    Ide.nSiteAutoriz := sa0;
    Ide.cMunFG  := 3503208;
    Ide.finNF3e := fnNormal;
    Ide.verProc := '1.0.0.0'; //Vers�o do seu sistema

    // Alimentar os 2 campos abaixo s� em caso de conting�ncia
//   Ide.dhCont  := Now;
//   Ide.xJust   := 'Motivo da Conting�ncia';

    // Dados do
    //
    Emit.CNPJ  := edtEmitCNPJ.Text;
    Emit.IE    := edtEmitIE.Text;
    Emit.xNome := edtEmitRazao.Text;
    Emit.xFant := edtEmitFantasia.Text;

    Emit.EnderEmit.xLgr    := edtEmitLogradouro.Text;
    Emit.EnderEmit.Nro     := edtEmitNumero.Text;
    Emit.EnderEmit.xCpl    := edtEmitComp.Text;
    Emit.EnderEmit.xBairro := edtEmitBairro.Text;
    Emit.EnderEmit.cMun    := StrToInt(edtEmitCodCidade.Text);
    Emit.EnderEmit.xMun    := edtEmitCidade.Text;
    Emit.EnderEmit.CEP     := StrToIntDef(edtEmitCEP.Text, 0);
    Emit.EnderEmit.UF      := edtEmitUF.Text;
    Emit.EnderEmit.fone    := edtEmitFone.Text;
    Emit.enderEmit.email   := 'endereco@provedor.com.br';

    // Dados do Destinat�rio
    //
    Dest.xNome     := edtEmitRazao.Text;
    Dest.CNPJCPF   := edtEmitCNPJ.Text;
    Dest.indIEDest := inNaoContribuinte;
    Dest.IE        := edtEmitIE.Text;
    Dest.IM        := '';
    Dest.cNIS      := '123456789012345';

    Dest.EnderDest.xLgr    := edtEmitLogradouro.Text;
    Dest.EnderDest.Nro     := edtEmitNumero.Text;
    Dest.EnderDest.xCpl    := edtEmitComp.Text;
    Dest.EnderDest.xBairro := edtEmitBairro.Text;
    Dest.EnderDest.cMun    := StrToInt(edtEmitCodCidade.Text);
    Dest.EnderDest.xMun    := edtEmitCidade.Text;
    Dest.EnderDest.CEP     := StrToIntDef(edtEmitCEP.Text, 0);
    Dest.EnderDest.UF      := edtEmitUF.Text;
    Dest.EnderDest.fone    := edtEmitFone.Text;
    Dest.EnderDest.email   := 'endereco@provedor.com.br';

    // Dados do acessante
    //
    acessante.idAcesso     := '123456';
    acessante.idCodCliente := '1234567890';
    acessante.tpAcesso     := taGerador;
    acessante.xNomeUC      := 'Nome da Unidade Consumidora';
    acessante.tpClasse     := tcComercial;
    acessante.tpSubClasse  := tscComercial;
    acessante.tpFase       := tfTrifasico;
    acessante.tpGrpTensao  := tgtA1;
    acessante.tpModTar     := tmtConvencionalMonomia;
    acessante.latGPS       := '20.904346';
    acessante.longGPS      := '18.624526';
//    [0-9]\.[0-9]{6}|[1-8][0-9]\.[0-9]{6}|90\.[0-9]{6}
//    acessante.longGPS      := '9.1.2.180.3';

//    [0-9]\.[0-9]{6}|[1-9][0-9]\.[0-9]{6}|1[0-7][0-9]\.[0-9]{6}|180\.[0-9]{6}

    // Dados do Detalhamento da nota fiscal
    //
    with NFDet.New do
    begin
      with Det.New do
      begin
        nItem := 1;

        with detItem do
        begin
          with Prod do
          begin
            indOrigemQtd := ioMedia;

            gMedicao.nMed := 10;
            gMedicao.nContrat := 0;

            gMedicao.tpGrMed   := tgmDemanda;
            gMedicao.cPosTarif := tptPonta;
            gMedicao.uMed      := umfkWh;
            gMedicao.vMedAnt   := 100.00;
            gMedicao.vMedAtu   := 120.00;
            gMedicao.vConst    := 1;
            gMedicao.vMed      := (gMedicao.vMedAtu - gMedicao.vMedAnt) * gMedicao.vConst;

            cProd        := '123';
            xProd        := 'Descricao do Produto';
            cClass       := 4562032;
            CFOP         := 1234;
            uMed         := umfkWh;
            qFaturada    := 50;
            vItem        := 2;
            vProd        := qFaturada * vItem;
            indDevolucao := tiNao;
            indPrecoACL  := tiNao;
          end;

          with Imposto do
          begin
            with ICMS do
            begin
              CST   := cst00;
              vBC   := 100;
              pICMS := 18;
              vICMS := vBC * pICMS / 100;
            end;

            with PIS do
            begin
              CST  := pis01;
              vBC  := 100;
              pPIS := 2;
              vPIS := vBC * pPIS / 100;
            end;

            with COFINS do
            begin
              CST     := cof01;
              vBC     := 100;
              pCOFINS := 1.5;
              vCOFINS := vBC * pCOFINS / 100;
            end;
          end;
        end;

      end;
    end;

    with Total do
    begin
      vProd      := 100;
      vBC        := 100;
      vICMS      := 18;
      vICMSDeson := 0;
      vFCP       := 0;
      vBCST      := 0;
      vST        := 0;
      vFCPST     := 0;
      vCOFINS    := 1.5;
      vPIS       := 2;
      vNF        := 100;
    end;

    with gFat do
    begin
      CompetFat    := StrToDate('01/10/2019');
      dVencFat     := StrToDate('10/11/2019');
      dApresFat    := StrToDate('25/10/2019');
      dProxLeitura := StrToDate('25/11/2019');
      nFat         := '123456';
      codBarras    := '123456789012345678901234567890123456789012345678';
      codDebAuto   := '12345678';
    end;

    with gANEEL do
    begin
      with gHistFat.New do
      begin
        xGrandFat := 'Nome da Grandeza Faturada';

        // O grupo gGrandFat possui 13 ocorrencias no XML.
        for i := 1 to 13 do
        begin
          with gGrandFat.New do
          begin
            CompetFat := StrToDate('01/10/2019');
            vFat      := 1;
            uMed      := umfkWh;
            qtdDias   := 2;
          end;
        end;
      end;
    end;

    // Autorizados para o Download do XML do NF3e
    //
    (*
    with autXML.New do
    begin
      CNPJCPF := '00000000000000';
    end;

    with autXML.New do
    begin
      CNPJCPF := '11111111111111';
    end;
    *)

    // Informa��es Adicionais
    //

    infAdic.infAdFisco := '';
    infAdic.infCpl     := 'Informa��es Complementares';

    with infRespTec do
    begin
      CNPJ     := '18760540000139';
      xContato := 'Nome do Contato';
      email    := 'nome@provedor.com.br';
      fone     := '33445566';
    end;
  end;

  ACBrNF3e1.NotasFiscais.GerarNF3e;
end;

procedure TfrmACBrNF3e.AtualizarSSLLibsCombo;
begin
  cbSSLLib.ItemIndex     := Integer(ACBrNF3e1.Configuracoes.Geral.SSLLib);
  cbCryptLib.ItemIndex   := Integer(ACBrNF3e1.Configuracoes.Geral.SSLCryptLib);
  cbHttpLib.ItemIndex    := Integer(ACBrNF3e1.Configuracoes.Geral.SSLHttpLib);
  cbXmlSignLib.ItemIndex := Integer(ACBrNF3e1.Configuracoes.Geral.SSLXmlSignLib);

  cbSSLType.Enabled := (ACBrNF3e1.Configuracoes.Geral.SSLHttpLib in [httpWinHttp, httpOpenSSL]);
end;

procedure TfrmACBrNF3e.btnAdicionarProtocoloClick(Sender: TObject);
var
  NomeArq: String;
begin
  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
    ACBrNF3e1.Consultar;

    ShowMessage(ACBrNF3e1.WebServices.Consulta.Protocolo);

    MemoResp.Lines.Text := ACBrNF3e1.WebServices.Consulta.RetWS;
    memoRespWS.Lines.Text := ACBrNF3e1.WebServices.Consulta.RetornoWS;
    LoadXML(ACBrNF3e1.WebServices.Consulta.RetornoWS, WBResposta);
    NomeArq := OpenDialog1.FileName;

    if pos(UpperCase('-NF3e.xml'), UpperCase(NomeArq)) > 0 then
       NomeArq := StringReplace(NomeArq, '-NF3e.xml', '-procNF3e.xml', [rfIgnoreCase]);

    ACBrNF3e1.NotasFiscais.Items[0].GravarXML(NomeArq);
    ShowMessage('Arquivo gravado em: ' + NomeArq);
    memoLog.Lines.Add('Arquivo gravado em: ' + NomeArq);
  end;
end;

procedure TfrmACBrNF3e.btnCancelarChaveClick(Sender: TObject);
var
  Chave, idLote, CNPJ, Protocolo, Justificativa: string;
begin
  if not(InputQuery('WebServices Eventos: Cancelamento', 'Chave da NF-e', Chave)) then
     exit;
  Chave := Trim(OnlyNumber(Chave));
  idLote := '1';
  if not(InputQuery('WebServices Eventos: Cancelamento', 'Identificador de controle do Lote de envio do Evento', idLote)) then
     exit;
  CNPJ := copy(Chave,7,14);
  if not(InputQuery('WebServices Eventos: Cancelamento', 'CNPJ ou o CPF do autor do Evento', CNPJ)) then
     exit;
  Protocolo:='';
  if not(InputQuery('WebServices Eventos: Cancelamento', 'Protocolo de Autoriza��o', Protocolo)) then
     exit;
  Justificativa := 'Justificativa do Cancelamento';
  if not(InputQuery('WebServices Eventos: Cancelamento', 'Justificativa do Cancelamento', Justificativa)) then
     exit;

  ACBrNF3e1.EventoNF3e.Evento.Clear;

  with ACBrNF3e1.EventoNF3e.Evento.New do
  begin
    infEvento.chNF3e := Chave;
    infEvento.CNPJ   := CNPJ;
    infEvento.dhEvento := now;
    infEvento.tpEvento := teCancelamento;
    infEvento.detEvento.xJust := Justificativa;
    infEvento.detEvento.nProt := Protocolo;
  end;

  ACBrNF3e1.EnviarEvento(StrToInt(idLote));

  MemoResp.Lines.Text := ACBrNF3e1.WebServices.EnvEvento.RetWS;
  memoRespWS.Lines.Text := ACBrNF3e1.WebServices.EnvEvento.RetornoWS;
  LoadXML(ACBrNF3e1.WebServices.EnvEvento.RetornoWS, WBResposta);
  (*
  ACBrNF3e1.WebServices.EnvEvento.EventoRetorno.TpAmb
  ACBrNF3e1.WebServices.EnvEvento.EventoRetorno.verAplic
  ACBrNF3e1.WebServices.EnvEvento.EventoRetorno.cStat
  ACBrNF3e1.WebServices.EnvEvento.EventoRetorno.xMotivo
  ACBrNF3e1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.chNF3e
  ACBrNF3e1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento
  ACBrNF3e1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.nProt
  *)
end;

procedure TfrmACBrNF3e.btnCancelarXMLClick(Sender: TObject);
var
  idLote, vAux: String;
begin
  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);

    idLote := '1';
    if not(InputQuery('WebServices Eventos: Cancelamento', 'Identificador de controle do Lote de envio do Evento', idLote)) then
       exit;

    if not(InputQuery('WebServices Eventos: Cancelamento', 'Justificativa', vAux)) then
       exit;

    ACBrNF3e1.EventoNF3e.Evento.Clear;
    ACBrNF3e1.EventoNF3e.idLote := StrToInt(idLote);

    with ACBrNF3e1.EventoNF3e.Evento.New do
    begin
      infEvento.dhEvento := now;
      infEvento.tpEvento := teCancelamento;
      infEvento.detEvento.xJust := vAux;
    end;

    ACBrNF3e1.EnviarEvento(StrToInt(idLote));

    MemoResp.Lines.Text := ACBrNF3e1.WebServices.EnvEvento.RetWS;
    memoRespWS.Lines.Text := ACBrNF3e1.WebServices.EnvEvento.RetornoWS;
    LoadXML(ACBrNF3e1.WebServices.EnvEvento.RetornoWS, WBResposta);
    ShowMessage(IntToStr(ACBrNF3e1.WebServices.EnvEvento.cStat));
    ShowMessage(ACBrNF3e1.WebServices.EnvEvento.EventoRetorno.RetInfEvento.nProt);
  end;
end;

procedure TfrmACBrNF3e.btnCarregarXMLEnviarClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName, False);

    with ACBrNF3e1.NotasFiscais.Items[0].NF3e do
    begin
      Emit.CNPJ              := edtEmitCNPJ.Text;
      Emit.IE                := edtEmitIE.Text;
      Emit.xNome             := edtEmitRazao.Text;
      Emit.xFant             := edtEmitFantasia.Text;

      Emit.EnderEmit.fone    := edtEmitFone.Text;
      Emit.EnderEmit.CEP     := StrToInt(edtEmitCEP.Text);
      Emit.EnderEmit.xLgr    := edtEmitLogradouro.Text;
      Emit.EnderEmit.nro     := edtEmitNumero.Text;
      Emit.EnderEmit.xCpl    := edtEmitComp.Text;
      Emit.EnderEmit.xBairro := edtEmitBairro.Text;
      Emit.EnderEmit.cMun    := StrToInt(edtEmitCodCidade.Text);
      Emit.EnderEmit.xMun    := edtEmitCidade.Text;
      Emit.EnderEmit.UF      := edtEmitUF.Text;
    end;

    ACBrNF3e1.Enviar(1);

    MemoResp.Lines.Text := ACBrNF3e1.WebServices.Retorno.RetWS;
    memoRespWS.Lines.Text := ACBrNF3e1.WebServices.Retorno.RetornoWS;
    LoadXML(ACBrNF3e1.WebServices.Retorno.RetornoWS, WBResposta);

    MemoDados.Lines.Add('');
    MemoDados.Lines.Add('Envio NF3e');
    MemoDados.Lines.Add('tpAmb: '+ TipoAmbienteToStr(ACBrNF3e1.WebServices.Retorno.TpAmb));
    MemoDados.Lines.Add('verAplic: '+ ACBrNF3e1.WebServices.Retorno.verAplic);
    MemoDados.Lines.Add('cStat: '+ IntToStr(ACBrNF3e1.WebServices.Retorno.cStat));
    MemoDados.Lines.Add('cUF: '+ IntToStr(ACBrNF3e1.WebServices.Retorno.cUF));
    MemoDados.Lines.Add('xMotivo: '+ ACBrNF3e1.WebServices.Retorno.xMotivo);
    MemoDados.Lines.Add('cMsg: '+ IntToStr(ACBrNF3e1.WebServices.Retorno.cMsg));
    MemoDados.Lines.Add('xMsg: '+ ACBrNF3e1.WebServices.Retorno.xMsg);
    MemoDados.Lines.Add('Recibo: '+ ACBrNF3e1.WebServices.Retorno.Recibo);
    MemoDados.Lines.Add('Protocolo: '+ ACBrNF3e1.WebServices.Retorno.Protocolo);
  end;
end;

procedure TfrmACBrNF3e.btnCNPJClick(Sender: TObject);
begin
  ShowMessage(ACBrNF3e1.SSL.CertCNPJ);
end;

procedure TfrmACBrNF3e.btnConsultarChaveClick(Sender: TObject);
var
  vChave: String;
begin
  if not(InputQuery('WebServices Consultar', 'Chave da NF-e:', vChave)) then
    exit;

  ACBrNF3e1.NotasFiscais.Clear;
  ACBrNF3e1.WebServices.Consulta.NF3eChave := vChave;
  ACBrNF3e1.WebServices.Consulta.Executar;

  MemoResp.Lines.Text := ACBrNF3e1.WebServices.Consulta.RetWS;
  memoRespWS.Lines.Text := ACBrNF3e1.WebServices.Consulta.RetornoWS;
  LoadXML(ACBrNF3e1.WebServices.Consulta.RetornoWS, WBResposta);
end;

procedure TfrmACBrNF3e.btnConsultarClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
    ACBrNF3e1.Consultar;

    ShowMessage(ACBrNF3e1.WebServices.Consulta.Protocolo);
    MemoResp.Lines.Text := ACBrNF3e1.WebServices.Consulta.RetWS;
    memoRespWS.Lines.Text := ACBrNF3e1.WebServices.Consulta.RetornoWS;
    LoadXML(ACBrNF3e1.WebServices.Consulta.RetornoWS, WBResposta);
  end;
end;

procedure TfrmACBrNF3e.btnConsultarReciboClick(Sender: TObject);
var
  aux: String;
begin
  if not(InputQuery('Consultar Recibo Lote', 'N�mero do Recibo', aux)) then
    exit;

  ACBrNF3e1.WebServices.Recibo.Recibo := aux;
  ACBrNF3e1.WebServices.Recibo.Executar;

  MemoResp.Lines.Text := ACBrNF3e1.WebServices.Recibo.RetWS;
  memoRespWS.Lines.Text := ACBrNF3e1.WebServices.Recibo.RetornoWS;
  LoadXML(ACBrNF3e1.WebServices.Recibo.RetornoWS, WBResposta);

  pgRespostas.ActivePageIndex := 1;

  MemoDados.Lines.Add('');
  MemoDados.Lines.Add('Consultar Recibo');
  MemoDados.Lines.Add('tpAmb: ' + TpAmbToStr(ACBrNF3e1.WebServices.Recibo.tpAmb));
  MemoDados.Lines.Add('versao: ' + ACBrNF3e1.WebServices.Recibo.versao);
  MemoDados.Lines.Add('verAplic: ' + ACBrNF3e1.WebServices.Recibo.verAplic);
  MemoDados.Lines.Add('cStat: ' + IntToStr(ACBrNF3e1.WebServices.Recibo.cStat));
  MemoDados.Lines.Add('xMotivo: ' + ACBrNF3e1.WebServices.Recibo.xMotivo);
  MemoDados.Lines.Add('cUF: ' + IntToStr(ACBrNF3e1.WebServices.Recibo.cUF));
  MemoDados.Lines.Add('xMsg: ' + ACBrNF3e1.WebServices.Recibo.xMsg);
  MemoDados.Lines.Add('cMsg: ' + IntToStr(ACBrNF3e1.WebServices.Recibo.cMsg));
  MemoDados.Lines.Add('Recibo: ' + ACBrNF3e1.WebServices.Recibo.Recibo);
end;

procedure TfrmACBrNF3e.btnCriarEnviarClick(Sender: TObject);
var
  vAux, vNumLote, vSincrono: String;
  Sincrono: Boolean;
begin
  if not(InputQuery('WebServices Enviar', 'Numero da Nota', vAux)) then
    exit;

  if not(InputQuery('WebServices Enviar', 'Numero do Lote', vNumLote)) then
    exit;

  vNumLote := OnlyNumber(vNumLote);
  Sincrono := False;

  if Trim(vNumLote) = '' then
  begin
    MessageDlg('N�mero do Lote inv�lido.', mtError,[mbok], 0);
    exit;
  end;

  AlimentarComponente(vAux);

  vSincrono := '1';
  if not(InputQuery('WebServices Enviar', 'Envio S�ncrono(1=Sim, 0=N�o)', vSincrono)) then
    exit;

  if (Trim(vSincrono) <> '1') and (Trim(vSincrono) <> '0') then
  begin
    MessageDlg('Valor Inv�lido.', mtError,[mbok], 0);
    exit;
  end;

  if Trim(vSincrono) = '1' then
    Sincrono := True
  else
    Sincrono := False;

  ACBrNF3e1.Enviar(vNumLote, True, Sincrono);

  pgRespostas.ActivePageIndex := 1;

  if not Sincrono then
  begin
    MemoResp.Lines.Text := ACBrNF3e1.WebServices.Retorno.RetWS;
    memoRespWS.Lines.Text := ACBrNF3e1.WebServices.Retorno.RetornoWS;
    LoadXML(ACBrNF3e1.WebServices.Retorno.RetWS, WBResposta);

    MemoDados.Lines.Add('');
    MemoDados.Lines.Add('Envio NF3e');
    MemoDados.Lines.Add('tpAmb: ' + TipoAmbienteToStr(ACBrNF3e1.WebServices.Retorno.TpAmb));
    MemoDados.Lines.Add('verAplic: ' + ACBrNF3e1.WebServices.Retorno.verAplic);
    MemoDados.Lines.Add('cStat: ' + IntToStr(ACBrNF3e1.WebServices.Retorno.cStat));
    MemoDados.Lines.Add('cUF: ' + IntToStr(ACBrNF3e1.WebServices.Retorno.cUF));
    MemoDados.Lines.Add('xMotivo: ' + ACBrNF3e1.WebServices.Retorno.xMotivo);
    MemoDados.Lines.Add('cMsg: ' + IntToStr(ACBrNF3e1.WebServices.Retorno.cMsg));
    MemoDados.Lines.Add('xMsg: ' + ACBrNF3e1.WebServices.Retorno.xMsg);
    MemoDados.Lines.Add('Recibo: ' + ACBrNF3e1.WebServices.Retorno.Recibo);
    MemoDados.Lines.Add('Protocolo: ' + ACBrNF3e1.WebServices.Retorno.Protocolo);
  end
  else
  begin
    MemoResp.Lines.Text := ACBrNF3e1.WebServices.Enviar.RetWS;
    memoRespWS.Lines.Text := ACBrNF3e1.WebServices.Enviar.RetornoWS;
    LoadXML(ACBrNF3e1.WebServices.Enviar.RetWS, WBResposta);

    MemoDados.Lines.Add('');
    MemoDados.Lines.Add('Envio NF3e');
    MemoDados.Lines.Add('tpAmb: ' + TpAmbToStr(ACBrNF3e1.WebServices.Enviar.TpAmb));
    MemoDados.Lines.Add('verAplic: ' + ACBrNF3e1.WebServices.Enviar.verAplic);
    MemoDados.Lines.Add('cStat: ' + IntToStr(ACBrNF3e1.WebServices.Enviar.cStat));
    MemoDados.Lines.Add('cUF: ' + IntToStr(ACBrNF3e1.WebServices.Enviar.cUF));
    MemoDados.Lines.Add('xMotivo: ' + ACBrNF3e1.WebServices.Enviar.xMotivo);
    MemoDados.Lines.Add('Recibo: '+ ACBrNF3e1.WebServices.Enviar.Recibo);
  end;
  (*
  ACBrNF3e1.WebServices.Retorno.NF3eRetorno.ProtNF3e.Items[0].tpAmb
  ACBrNF3e1.WebServices.Retorno.NF3eRetorno.ProtNF3e.Items[0].verAplic
  ACBrNF3e1.WebServices.Retorno.NF3eRetorno.ProtNF3e.Items[0].chNF3e
  ACBrNF3e1.WebServices.Retorno.NF3eRetorno.ProtNF3e.Items[0].dhRecbto
  ACBrNF3e1.WebServices.Retorno.NF3eRetorno.ProtNF3e.Items[0].nProt
  ACBrNF3e1.WebServices.Retorno.NF3eRetorno.ProtNF3e.Items[0].digVal
  ACBrNF3e1.WebServices.Retorno.NF3eRetorno.ProtNF3e.Items[0].cStat
  ACBrNF3e1.WebServices.Retorno.NF3eRetorno.ProtNF3e.Items[0].xMotivo
  *)
end;

procedure TfrmACBrNF3e.btnDataValidadeClick(Sender: TObject);
begin
  ShowMessage(FormatDateBr(ACBrNF3e1.SSL.CertDataVenc));
end;

procedure TfrmACBrNF3e.btnDistribuicaoDFeClick(Sender: TObject);
var
  cUFAutor, CNPJ, ultNSU, ANSU: string;
begin
  cUFAutor := '';
  if not(InputQuery('WebServices Distribui��o Documentos Fiscais', 'C�digo da UF do Autor', cUFAutor)) then
     exit;

  CNPJ := '';
  if not(InputQuery('WebServices Distribui��o Documentos Fiscais', 'CNPJ/CPF do interessado no DF-e', CNPJ)) then
     exit;

  ultNSU := '';
  if not(InputQuery('WebServices Distribui��o Documentos Fiscais', '�ltimo NSU recebido pelo ator', ultNSU)) then
     exit;

  ANSU := '';
  if not(InputQuery('WebServices Distribui��o Documentos Fiscais', 'NSU espec�fico', ANSU)) then
     exit;

  if ANSU = '' then
    ACBrNF3e1.DistribuicaoDFePorUltNSU(StrToInt(cUFAutor), CNPJ, ultNSU)
  else
    ACBrNF3e1.DistribuicaoDFePorNSU(StrToInt(cUFAutor), CNPJ, ANSU);

  MemoResp.Lines.Text := ACBrNF3e1.WebServices.DistribuicaoDFe.RetWS;
  memoRespWS.Lines.Text := ACBrNF3e1.WebServices.DistribuicaoDFe.RetornoWS;

  LoadXML(ACBrNF3e1.WebServices.DistribuicaoDFe.RetWS, WBResposta);
end;

procedure TfrmACBrNF3e.btnEnviarEmailClick(Sender: TObject);
var
  Para: String;
  CC: Tstrings;
begin
  if not(InputQuery('Enviar Email', 'Email de destino', Para)) then
    exit;

  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if not OpenDialog1.Execute then
    Exit;

  ACBrNF3e1.NotasFiscais.Clear;
  ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);

  CC := TStringList.Create;
  try
    //CC.Add('email_1@provedor.com'); // especifique um email valido
    //CC.Add('email_2@provedor.com.br');    // especifique um email valido
    ConfigurarEmail;
    ACBrNF3e1.NotasFiscais.Items[0].EnviarEmail( Para, edtEmailAssunto.Text,
                                             mmEmailMsg.Lines
                                             , True  // Enviar PDF junto
                                             , CC    // Lista com emails que serao enviado copias - TStrings
                                             , nil); // Lista de anexos - TStrings
  finally
    CC.Free;
  end;
end;

procedure TfrmACBrNF3e.btnEnviarEventoEmailClick(Sender: TObject);
var
  Para: String;
  CC, Evento: Tstrings;
begin
  if not(InputQuery('Enviar Email', 'Email de destino', Para)) then
    exit;

  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
  end;

  OpenDialog1.Title := 'Selecione ao Evento';
  OpenDialog1.DefaultExt := '*.XML';
  OpenDialog1.Filter := 'Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if not OpenDialog1.Execute then
    Exit;

  Evento := TStringList.Create;
  CC := TStringList.Create;
  try
    Evento.Clear;
    Evento.Add(OpenDialog1.FileName);
    ACBrNF3e1.EventoNF3e.Evento.Clear;
    ACBrNF3e1.EventoNF3e.LerXML(OpenDialog1.FileName);

    //CC.Add('email_1@provedor.com'); // especifique um email valido
    //CC.Add('email_2@provedor.com.br');    // especifique um email valido
    ConfigurarEmail;
    ACBrNF3e1.EnviarEmailEvento(Para
      , edtEmailAssunto.Text
      , mmEmailMsg.Lines
      , CC // Lista com emails que serao enviado copias - TStrings
      , nil // Lista de anexos - TStrings
      , nil  // ReplyTo
      );
  finally
    CC.Free;
    Evento.Free;
  end;
end;

procedure TfrmACBrNF3e.btnGerarXMLClick(Sender: TObject);
var
  vAux: String;
begin
  if not(InputQuery('WebServices Enviar', 'Numero da Nota', vAux)) then
    exit;

  ACBrNF3e1.NotasFiscais.Clear;

  AlimentarComponente(vAux);

  ACBrNF3e1.NotasFiscais.Assinar;
  ACBrNF3e1.NotasFiscais.Validar;

//  ACBrNF3e1.NotasFiscais.Items[0].GravarXML();

  ShowMessage('Arquivo gerado em: ' + ACBrNF3e1.NotasFiscais.Items[0].NomeArq);
  MemoDados.Lines.Add('Arquivo gerado em: ' + ACBrNF3e1.NotasFiscais.Items[0].NomeArq);

  MemoResp.Lines.LoadFromFile(ACBrNF3e1.NotasFiscais.Items[0].NomeArq);

  LoadXML(MemoResp.Text, WBResposta);

  pgRespostas.ActivePageIndex := 1;
end;

procedure TfrmACBrNF3e.btnHTTPSClick(Sender: TObject);
var
  Acao: String;
  OldUseCert: Boolean;
begin
  Acao := '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' +
     '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
     'xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/"> ' +
     ' <soapenv:Header/>' +
     ' <soapenv:Body>' +
     ' <cli:consultaCEP>' +
     ' <cep>18270-170</cep>' +
     ' </cli:consultaCEP>' +
     ' </soapenv:Body>' +
     ' </soapenv:Envelope>';

  OldUseCert := ACBrNF3e1.SSL.UseCertificateHTTP;
  ACBrNF3e1.SSL.UseCertificateHTTP := False;

  try
    MemoResp.Lines.Text := ACBrNF3e1.SSL.Enviar(Acao, 'https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente?wsdl', '');
  finally
    ACBrNF3e1.SSL.UseCertificateHTTP := OldUseCert;
  end;

  pgRespostas.ActivePageIndex := 0;
end;

procedure TfrmACBrNF3e.btnImprimirDANF3EClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    if ACBrNF3e1.DANF3E = ACBrNF3eDANF3eESCPOS1 then
      PrepararImpressao;

    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName,False);
    ACBrNF3e1.NotasFiscais.Imprimir;
  end;
end;

procedure TfrmACBrNF3e.btnImprimirDANF3EOfflineClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    if ACBrNF3e1.DANF3E = ACBrNF3eDANF3eESCPOS1 then
      PrepararImpressao;

    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName,False);
    ACBrNF3e1.NotasFiscais.Imprimir;
  end;
end;

procedure TfrmACBrNF3e.btnImprimirEventoClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
  end;

  OpenDialog1.Title := 'Selecione o Evento';
  OpenDialog1.DefaultExt := '*.XML';
  OpenDialog1.Filter := 'Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNF3e1.EventoNF3e.Evento.Clear;
    ACBrNF3e1.EventoNF3e.LerXML(OpenDialog1.FileName);
    ACBrNF3e1.ImprimirEvento;
  end;
end;

procedure TfrmACBrNF3e.btnIssuerNameClick(Sender: TObject);
begin
 ShowMessage(ACBrNF3e1.SSL.CertIssuerName + sLineBreak + sLineBreak +
             'Certificadora: ' + ACBrNF3e1.SSL.CertCertificadora);
end;

procedure TfrmACBrNF3e.btnLeituraX509Click(Sender: TObject);
//var
//  Erro, AName: String;
begin
  with ACBrNF3e1.SSL do
  begin
     CarregarCertificadoPublico(MemoDados.Lines.Text);
     MemoResp.Lines.Add(CertIssuerName);
     MemoResp.Lines.Add(CertRazaoSocial);
     MemoResp.Lines.Add(CertCNPJ);
     MemoResp.Lines.Add(CertSubjectName);
     MemoResp.Lines.Add(CertNumeroSerie);

    //MemoDados.Lines.LoadFromFile('c:\temp\teste2.xml');
    //MemoResp.Lines.Text := Assinar(MemoDados.Lines.Text, 'Entrada', 'Parametros');
    //Erro := '';
    //if VerificarAssinatura(MemoResp.Lines.Text, Erro, 'Parametros' ) then
    //  ShowMessage('OK')
    //else
    //  ShowMessage('ERRO: '+Erro)

    pgRespostas.ActivePageIndex := 0;
  end;
end;

procedure TfrmACBrNF3e.btnNumSerieClick(Sender: TObject);
begin
  ShowMessage(ACBrNF3e1.SSL.CertNumeroSerie);
end;

procedure TfrmACBrNF3e.btnSalvarConfigClick(Sender: TObject);
begin
  GravarConfiguracao;
end;

procedure TfrmACBrNF3e.btnSha256Click(Sender: TObject);
var
  Ahash: AnsiString;
begin
  Ahash := ACBrNF3e1.SSL.CalcHash(Edit1.Text, dgstSHA256, outBase64, cbAssinar.Checked);
  MemoResp.Lines.Add( Ahash );
  pgRespostas.ActivePageIndex := 0;
end;

procedure TfrmACBrNF3e.btnStatusServClick(Sender: TObject);
begin
  ACBrNF3e1.WebServices.StatusServico.Executar;

  MemoResp.Lines.Text := ACBrNF3e1.WebServices.StatusServico.RetWS;
  memoRespWS.Lines.Text := ACBrNF3e1.WebServices.StatusServico.RetornoWS;
  LoadXML(ACBrNF3e1.WebServices.StatusServico.RetornoWS, WBResposta);

  pgRespostas.ActivePageIndex := 1;

  MemoDados.Lines.Add('');
  MemoDados.Lines.Add('Status Servi�o');
  MemoDados.Lines.Add('tpAmb: '    +TpAmbToStr(ACBrNF3e1.WebServices.StatusServico.tpAmb));
  MemoDados.Lines.Add('verAplic: ' +ACBrNF3e1.WebServices.StatusServico.verAplic);
  MemoDados.Lines.Add('cStat: '    +IntToStr(ACBrNF3e1.WebServices.StatusServico.cStat));
  MemoDados.Lines.Add('xMotivo: '  +ACBrNF3e1.WebServices.StatusServico.xMotivo);
  MemoDados.Lines.Add('cUF: '      +IntToStr(ACBrNF3e1.WebServices.StatusServico.cUF));
  MemoDados.Lines.Add('dhRecbto: ' +DateTimeToStr(ACBrNF3e1.WebServices.StatusServico.dhRecbto));
  MemoDados.Lines.Add('tMed: '     +IntToStr(ACBrNF3e1.WebServices.StatusServico.TMed));
  MemoDados.Lines.Add('dhRetorno: '+DateTimeToStr(ACBrNF3e1.WebServices.StatusServico.dhRetorno));
  MemoDados.Lines.Add('xObs: '     +ACBrNF3e1.WebServices.StatusServico.xObs);
end;

procedure TfrmACBrNF3e.btnSubNameClick(Sender: TObject);
begin
  ShowMessage(ACBrNF3e1.SSL.CertSubjectName + sLineBreak + sLineBreak +
              'Raz�o Social: ' + ACBrNF3e1.SSL.CertRazaoSocial);
end;

procedure TfrmACBrNF3e.btnValidarAssinaturaClick(Sender: TObject);
var
  Msg: String;
begin
  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
    pgRespostas.ActivePageIndex := 0;
    MemoResp.Lines.Add('');
    MemoResp.Lines.Add('');

    if not ACBrNF3e1.NotasFiscais.VerificarAssinatura(Msg) then
      MemoResp.Lines.Add('Erro: '+Msg)
    else
    begin
      MemoResp.Lines.Add('OK: Assinatura V�lida');
      ACBrNF3e1.SSL.CarregarCertificadoPublico( ACBrNF3e1.NotasFiscais[0].NF3e.signature.X509Certificate );
      MemoResp.Lines.Add('Assinado por: '+ ACBrNF3e1.SSL.CertRazaoSocial);
      MemoResp.Lines.Add('CNPJ: '+ ACBrNF3e1.SSL.CertCNPJ);
      MemoResp.Lines.Add('Num.S�rie: '+ ACBrNF3e1.SSL.CertNumeroSerie);

      ShowMessage('ASSINATURA V�LIDA');
    end;
  end;
end;

procedure TfrmACBrNF3e.btnValidarRegrasNegocioClick(Sender: TObject);
var
  Msg, Tempo: String;
  Inicio: TDateTime;
  Ok: Boolean;
begin
  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
    Inicio := Now;
    Ok := ACBrNF3e1.NotasFiscais.ValidarRegrasdeNegocios(Msg);
    Tempo := FormatDateTime('hh:nn:ss:zzz', Now - Inicio);

    if not Ok then
    begin
      MemoDados.Lines.Add('Erro: ' + Msg);
      ShowMessage('Erros encontrados' + sLineBreak + 'Tempo: ' + Tempo);
    end
    else
      ShowMessage('Tudo OK' + sLineBreak + 'Tempo: ' + Tempo);
  end;
end;

procedure TfrmACBrNF3e.btnValidarXMLClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NF3e';
  OpenDialog1.DefaultExt := '*-NF3e.XML';
  OpenDialog1.Filter := 'Arquivos NF3e (*-NF3e.XML)|*-NF3e.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ACBrNF3e1.Configuracoes.Arquivos.PathSalvar;

  // Sugest�o de configura��o para apresenta��o de mensagem mais amig�vel ao usu�rio final
  ACBrNF3e1.Configuracoes.Geral.ExibirErroSchema := False;
  ACBrNF3e1.Configuracoes.Geral.FormatoAlerta := 'Campo:%DESCRICAO% - %MSG%';

  if OpenDialog1.Execute then
  begin
    ACBrNF3e1.NotasFiscais.Clear;
    ACBrNF3e1.NotasFiscais.LoadFromFile(OpenDialog1.FileName, True);

    try
      ACBrNF3e1.NotasFiscais.Validar;

      if ACBrNF3e1.NotasFiscais.Items[0].Alertas <> '' then
        MemoDados.Lines.Add('Alertas: '+ACBrNF3e1.NotasFiscais.Items[0].Alertas);

      ShowMessage('Nota Fiscal Eletr�nica Valida');
    except
      on E: Exception do
      begin
        pgRespostas.ActivePage := Dados;
        MemoDados.Lines.Add('Exception: ' + E.Message);
        MemoDados.Lines.Add('Erro: ' + ACBrNF3e1.NotasFiscais.Items[0].ErroValidacao);
        MemoDados.Lines.Add('Erro Completo: ' + ACBrNF3e1.NotasFiscais.Items[0].ErroValidacaoCompleto);
      end;
    end;
  end;
end;

procedure TfrmACBrNF3e.btSerialClick(Sender: TObject);
begin
  frmConfiguraSerial.Device.Porta        := ACBrPosPrinter1.Device.Porta;
  frmConfiguraSerial.cmbPortaSerial.Text := cbxPorta.Text;
  frmConfiguraSerial.Device.ParamsString := ACBrPosPrinter1.Device.ParamsString;

  if frmConfiguraSerial.ShowModal = mrOk then
  begin
    cbxPorta.Text := frmConfiguraSerial.Device.Porta;
    ACBrPosPrinter1.Device.ParamsString := frmConfiguraSerial.Device.ParamsString;
  end;
end;

procedure TfrmACBrNF3e.cbCryptLibChange(Sender: TObject);
begin
  try
    if cbCryptLib.ItemIndex <> -1 then
      ACBrNF3e1.Configuracoes.Geral.SSLCryptLib := TSSLCryptLib(cbCryptLib.ItemIndex);
  finally
    AtualizarSSLLibsCombo;
  end;
end;

procedure TfrmACBrNF3e.cbHttpLibChange(Sender: TObject);
begin
  try
    if cbHttpLib.ItemIndex <> -1 then
      ACBrNF3e1.Configuracoes.Geral.SSLHttpLib := TSSLHttpLib(cbHttpLib.ItemIndex);
  finally
    AtualizarSSLLibsCombo;
  end;
end;

procedure TfrmACBrNF3e.cbSSLLibChange(Sender: TObject);
begin
  try
    if cbSSLLib.ItemIndex <> -1 then
      ACBrNF3e1.Configuracoes.Geral.SSLLib := TSSLLib(cbSSLLib.ItemIndex);
  finally
    AtualizarSSLLibsCombo;
  end;
end;

procedure TfrmACBrNF3e.cbSSLTypeChange(Sender: TObject);
begin
  if cbSSLType.ItemIndex <> -1 then
     ACBrNF3e1.SSL.SSLType := TSSLType(cbSSLType.ItemIndex);
end;

procedure TfrmACBrNF3e.cbXmlSignLibChange(Sender: TObject);
begin
  try
    if cbXmlSignLib.ItemIndex <> -1 then
      ACBrNF3e1.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib(cbXmlSignLib.ItemIndex);
  finally
    AtualizarSSLLibsCombo;
  end;
end;

procedure TfrmACBrNF3e.FormCreate(Sender: TObject);
var
  T: TSSLLib;
  I: TpcnTipoEmissao;
  K: TVersaoNF3e;
  U: TSSLCryptLib;
  V: TSSLHttpLib;
  X: TSSLXmlSignLib;
  Y: TSSLType;
  N: TACBrPosPrinterModelo;
  O: TACBrPosPaginaCodigo;
  l: Integer;
begin
  cbSSLLib.Items.Clear;
  for T := Low(TSSLLib) to High(TSSLLib) do
    cbSSLLib.Items.Add( GetEnumName(TypeInfo(TSSLLib), integer(T) ) );
  cbSSLLib.ItemIndex := 0;

  cbCryptLib.Items.Clear;
  for U := Low(TSSLCryptLib) to High(TSSLCryptLib) do
    cbCryptLib.Items.Add( GetEnumName(TypeInfo(TSSLCryptLib), integer(U) ) );
  cbCryptLib.ItemIndex := 0;

  cbHttpLib.Items.Clear;
  for V := Low(TSSLHttpLib) to High(TSSLHttpLib) do
    cbHttpLib.Items.Add( GetEnumName(TypeInfo(TSSLHttpLib), integer(V) ) );
  cbHttpLib.ItemIndex := 0;

  cbXmlSignLib.Items.Clear;
  for X := Low(TSSLXmlSignLib) to High(TSSLXmlSignLib) do
    cbXmlSignLib.Items.Add( GetEnumName(TypeInfo(TSSLXmlSignLib), integer(X) ) );
  cbXmlSignLib.ItemIndex := 0;

  cbSSLType.Items.Clear;
  for Y := Low(TSSLType) to High(TSSLType) do
    cbSSLType.Items.Add( GetEnumName(TypeInfo(TSSLType), integer(Y) ) );
  cbSSLType.ItemIndex := 0;

  cbFormaEmissao.Items.Clear;
  for I := Low(TpcnTipoEmissao) to High(TpcnTipoEmissao) do
     cbFormaEmissao.Items.Add( GetEnumName(TypeInfo(TpcnTipoEmissao), integer(I) ) );
  cbFormaEmissao.ItemIndex := 0;

  cbVersaoDF.Items.Clear;
  for K := Low(TVersaoNF3e) to High(TVersaoNF3e) do
     cbVersaoDF.Items.Add( GetEnumName(TypeInfo(TVersaoNF3e), integer(K) ) );
  cbVersaoDF.ItemIndex := 0;

  cbxModeloPosPrinter.Items.Clear ;
  for N := Low(TACBrPosPrinterModelo) to High(TACBrPosPrinterModelo) do
    cbxModeloPosPrinter.Items.Add( GetEnumName(TypeInfo(TACBrPosPrinterModelo), integer(N) ) ) ;

  cbxPagCodigo.Items.Clear ;
  for O := Low(TACBrPosPaginaCodigo) to High(TACBrPosPaginaCodigo) do
     cbxPagCodigo.Items.Add( GetEnumName(TypeInfo(TACBrPosPaginaCodigo), integer(O) ) ) ;

  cbxPorta.Items.Clear;
  ACBrPosPrinter1.Device.AcharPortasSeriais( cbxPorta.Items );
  cbxPorta.Items.Add('LPT1') ;
  cbxPorta.Items.Add('LPT2') ;
  cbxPorta.Items.Add('\\localhost\Epson') ;
  cbxPorta.Items.Add('c:\temp\ecf.txt') ;
  cbxPorta.Items.Add('TCP:192.168.0.31:9100') ;

  for l := 0 to Printer.Printers.Count-1 do
    cbxPorta.Items.Add('RAW:'+Printer.Printers[l]);

  cbxPorta.Items.Add('/dev/ttyS0') ;
  cbxPorta.Items.Add('/dev/ttyS1') ;
  cbxPorta.Items.Add('/dev/ttyUSB0') ;
  cbxPorta.Items.Add('/dev/ttyUSB1') ;
  cbxPorta.Items.Add('/tmp/ecf.txt') ;

  LerConfiguracao;
  pgRespostas.ActivePageIndex := 2;
end;

procedure TfrmACBrNF3e.GravarConfiguracao;
var
  IniFile: String;
  Ini: TIniFile;
  StreamMemo: TMemoryStream;
begin
  IniFile := ChangeFileExt(Application.ExeName, '.ini');

  Ini := TIniFile.Create(IniFile);
  try
    Ini.WriteInteger('Certificado', 'SSLLib',     cbSSLLib.ItemIndex);
    Ini.WriteInteger('Certificado', 'CryptLib',   cbCryptLib.ItemIndex);
    Ini.WriteInteger('Certificado', 'HttpLib',    cbHttpLib.ItemIndex);
    Ini.WriteInteger('Certificado', 'XmlSignLib', cbXmlSignLib.ItemIndex);
    Ini.WriteString( 'Certificado', 'Caminho',    edtCaminho.Text);
    Ini.WriteString( 'Certificado', 'Senha',      edtSenha.Text);
    Ini.WriteString( 'Certificado', 'NumSerie',   edtNumSerie.Text);

    Ini.WriteBool(   'Geral', 'AtualizarXML',     cbxAtualizarXML.Checked);
    Ini.WriteBool(   'Geral', 'ExibirErroSchema', cbxExibirErroSchema.Checked);
    Ini.WriteString( 'Geral', 'FormatoAlerta',    edtFormatoAlerta.Text);
    Ini.WriteInteger('Geral', 'FormaEmissao',     cbFormaEmissao.ItemIndex);
    Ini.WriteInteger('Geral', 'VersaoDF',         cbVersaoDF.ItemIndex);
    Ini.WriteBool(   'Geral', 'RetirarAcentos',   cbxRetirarAcentos.Checked);
    Ini.WriteBool(   'Geral', 'Salvar',           ckSalvar.Checked);
    Ini.WriteString( 'Geral', 'PathSalvar',       edtPathLogs.Text);
    Ini.WriteString( 'Geral', 'PathSchemas',      edtPathSchemas.Text);

    Ini.WriteString( 'WebService', 'UF',         cbUF.Text);
    Ini.WriteInteger('WebService', 'Ambiente',   rgTipoAmb.ItemIndex);
    Ini.WriteBool(   'WebService', 'Visualizar', cbxVisualizar.Checked);
    Ini.WriteBool(   'WebService', 'SalvarSOAP', cbxSalvarSOAP.Checked);
    Ini.WriteBool(   'WebService', 'AjustarAut', cbxAjustarAut.Checked);
    Ini.WriteString( 'WebService', 'Aguardar',   edtAguardar.Text);
    Ini.WriteString( 'WebService', 'Tentativas', edtTentativas.Text);
    Ini.WriteString( 'WebService', 'Intervalo',  edtIntervalo.Text);
    Ini.WriteInteger('WebService', 'TimeOut',    seTimeOut.Value);
    Ini.WriteInteger('WebService', 'SSLType',    cbSSLType.ItemIndex);

    Ini.WriteString('Proxy', 'Host',  edtProxyHost.Text);
    Ini.WriteString('Proxy', 'Porta', edtProxyPorta.Text);
    Ini.WriteString('Proxy', 'User',  edtProxyUser.Text);
    Ini.WriteString('Proxy', 'Pass',  edtProxySenha.Text);

    Ini.WriteBool(  'Arquivos', 'Salvar',           cbxSalvarArqs.Checked);
    Ini.WriteBool(  'Arquivos', 'PastaMensal',      cbxPastaMensal.Checked);
    Ini.WriteBool(  'Arquivos', 'AddLiteral',       cbxAdicionaLiteral.Checked);
    Ini.WriteBool(  'Arquivos', 'EmissaoPathNF3e',  cbxEmissaoPathNF3e.Checked);
    Ini.WriteBool(  'Arquivos', 'SalvarPathEvento', cbxSalvaPathEvento.Checked);
    Ini.WriteBool(  'Arquivos', 'SepararPorCNPJ',   cbxSepararPorCNPJ.Checked);
    Ini.WriteBool(  'Arquivos', 'SepararPorModelo', cbxSepararPorModelo.Checked);
    Ini.WriteString('Arquivos', 'PathNF3e',         edtPathNF3e.Text);
    Ini.WriteString('Arquivos', 'PathEvento',       edtPathEvento.Text);

    Ini.WriteString('Emitente', 'CNPJ',        edtEmitCNPJ.Text);
    Ini.WriteString('Emitente', 'IE',          edtEmitIE.Text);
    Ini.WriteString('Emitente', 'RazaoSocial', edtEmitRazao.Text);
    Ini.WriteString('Emitente', 'Fantasia',    edtEmitFantasia.Text);
    Ini.WriteString('Emitente', 'Fone',        edtEmitFone.Text);
    Ini.WriteString('Emitente', 'CEP',         edtEmitCEP.Text);
    Ini.WriteString('Emitente', 'Logradouro',  edtEmitLogradouro.Text);
    Ini.WriteString('Emitente', 'Numero',      edtEmitNumero.Text);
    Ini.WriteString('Emitente', 'Complemento', edtEmitComp.Text);
    Ini.WriteString('Emitente', 'Bairro',      edtEmitBairro.Text);
    Ini.WriteString('Emitente', 'CodCidade',   edtEmitCodCidade.Text);
    Ini.WriteString('Emitente', 'Cidade',      edtEmitCidade.Text);
    Ini.WriteString('Emitente', 'UF',          edtEmitUF.Text);

    Ini.WriteString('Email', 'Host',    edtSmtpHost.Text);
    Ini.WriteString('Email', 'Port',    edtSmtpPort.Text);
    Ini.WriteString('Email', 'User',    edtSmtpUser.Text);
    Ini.WriteString('Email', 'Pass',    edtSmtpPass.Text);
    Ini.WriteString('Email', 'Assunto', edtEmailAssunto.Text);
    Ini.WriteBool(  'Email', 'SSL',     cbEmailSSL.Checked );

    StreamMemo := TMemoryStream.Create;
    mmEmailMsg.Lines.SaveToStream(StreamMemo);
    StreamMemo.Seek(0,soFromBeginning);

    Ini.WriteBinaryStream('Email', 'Mensagem', StreamMemo);

    StreamMemo.Free;

    Ini.WriteInteger('DANF3e', 'Tipo',       rgTipoDANF3e.ItemIndex);
    Ini.WriteString( 'DANF3e', 'LogoMarca',  edtLogoMarca.Text);
    Ini.WriteInteger('DANF3e', 'TipoDANF3E', rgDANF3E.ItemIndex);

    INI.WriteInteger('PosPrinter', 'Modelo',            cbxModeloPosPrinter.ItemIndex);
    INI.WriteString( 'PosPrinter', 'Porta',             cbxPorta.Text);
    INI.WriteInteger('PosPrinter', 'PaginaDeCodigo',    cbxPagCodigo.ItemIndex);
    INI.WriteString( 'PosPrinter', 'ParamsString',      ACBrPosPrinter1.Device.ParamsString);
    INI.WriteInteger('PosPrinter', 'Colunas',           seColunas.Value);
    INI.WriteInteger('PosPrinter', 'EspacoLinhas',      seEspLinhas.Value);
    INI.WriteInteger('PosPrinter', 'LinhasEntreCupons', seLinhasPular.Value);
    Ini.WriteBool(   'PosPrinter', 'CortarPapel',       cbCortarPapel.Checked );

    ConfigurarComponente;
    ConfigurarEmail;
  finally
    Ini.Free;
  end;
end;

procedure TfrmACBrNF3e.lblColaboradorClick(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/5');
end;

procedure TfrmACBrNF3e.lblDoar1Click(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/14');
end;

procedure TfrmACBrNF3e.lblDoar2Click(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/14');
end;

procedure TfrmACBrNF3e.lblMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Style := [fsBold,fsUnderline];
end;

procedure TfrmACBrNF3e.lblMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Style := [fsBold];
end;

procedure TfrmACBrNF3e.lblPatrocinadorClick(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/5');
end;

procedure TfrmACBrNF3e.LerConfiguracao;
var
  IniFile: String;
  Ini: TIniFile;
  StreamMemo: TMemoryStream;
begin
  IniFile := ChangeFileExt(Application.ExeName, '.ini');

  Ini := TIniFile.Create(IniFile);
  try
    cbSSLLib.ItemIndex     := Ini.ReadInteger('Certificado', 'SSLLib',     0);
    cbCryptLib.ItemIndex   := Ini.ReadInteger('Certificado', 'CryptLib',   0);
    cbHttpLib.ItemIndex    := Ini.ReadInteger('Certificado', 'HttpLib',    0);
    cbXmlSignLib.ItemIndex := Ini.ReadInteger('Certificado', 'XmlSignLib', 0);
    edtCaminho.Text        := Ini.ReadString( 'Certificado', 'Caminho',    '');
    edtSenha.Text          := Ini.ReadString( 'Certificado', 'Senha',      '');
    edtNumSerie.Text       := Ini.ReadString( 'Certificado', 'NumSerie',   '');

    cbxAtualizarXML.Checked     := Ini.ReadBool(   'Geral', 'AtualizarXML',     True);
    cbxExibirErroSchema.Checked := Ini.ReadBool(   'Geral', 'ExibirErroSchema', True);
    edtFormatoAlerta.Text       := Ini.ReadString( 'Geral', 'FormatoAlerta',    'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.');
    cbFormaEmissao.ItemIndex    := Ini.ReadInteger('Geral', 'FormaEmissao',     0);

    cbVersaoDF.ItemIndex      := Ini.ReadInteger('Geral', 'VersaoDF',       0);
    ckSalvar.Checked          := Ini.ReadBool(   'Geral', 'Salvar',         True);
    cbxRetirarAcentos.Checked := Ini.ReadBool(   'Geral', 'RetirarAcentos', True);
    edtPathLogs.Text          := Ini.ReadString( 'Geral', 'PathSalvar',     PathWithDelim(ExtractFilePath(Application.ExeName))+'Logs');
    edtPathSchemas.Text       := Ini.ReadString( 'Geral', 'PathSchemas',    PathWithDelim(ExtractFilePath(Application.ExeName))+'Schemas\'+GetEnumName(TypeInfo(TVersaoNF3e), integer(cbVersaoDF.ItemIndex) ));

    cbUF.ItemIndex := cbUF.Items.IndexOf(Ini.ReadString('WebService', 'UF', 'SP'));

    rgTipoAmb.ItemIndex   := Ini.ReadInteger('WebService', 'Ambiente',   0);
    cbxVisualizar.Checked := Ini.ReadBool(   'WebService', 'Visualizar', False);
    cbxSalvarSOAP.Checked := Ini.ReadBool(   'WebService', 'SalvarSOAP', False);
    cbxAjustarAut.Checked := Ini.ReadBool(   'WebService', 'AjustarAut', False);
    edtAguardar.Text      := Ini.ReadString( 'WebService', 'Aguardar',   '0');
    edtTentativas.Text    := Ini.ReadString( 'WebService', 'Tentativas', '5');
    edtIntervalo.Text     := Ini.ReadString( 'WebService', 'Intervalo',  '0');
    seTimeOut.Value       := Ini.ReadInteger('WebService', 'TimeOut',    5000);
    cbSSLType.ItemIndex   := Ini.ReadInteger('WebService', 'SSLType',    0);

    edtProxyHost.Text  := Ini.ReadString('Proxy', 'Host',  '');
    edtProxyPorta.Text := Ini.ReadString('Proxy', 'Porta', '');
    edtProxyUser.Text  := Ini.ReadString('Proxy', 'User',  '');
    edtProxySenha.Text := Ini.ReadString('Proxy', 'Pass',  '');

    cbxSalvarArqs.Checked       := Ini.ReadBool(  'Arquivos', 'Salvar',           false);
    cbxPastaMensal.Checked      := Ini.ReadBool(  'Arquivos', 'PastaMensal',      false);
    cbxAdicionaLiteral.Checked  := Ini.ReadBool(  'Arquivos', 'AddLiteral',       false);
    cbxEmissaoPathNF3e.Checked  := Ini.ReadBool(  'Arquivos', 'EmissaoPathNF3e',  false);
    cbxSalvaPathEvento.Checked  := Ini.ReadBool(  'Arquivos', 'SalvarPathEvento', false);
    cbxSepararPorCNPJ.Checked   := Ini.ReadBool(  'Arquivos', 'SepararPorCNPJ',   false);
    cbxSepararPorModelo.Checked := Ini.ReadBool(  'Arquivos', 'SepararPorModelo', false);
    edtPathNF3e.Text            := Ini.ReadString('Arquivos', 'PathNF3e',         '');
    edtPathEvento.Text          := Ini.ReadString('Arquivos', 'PathEvento',       '');

    edtEmitCNPJ.Text       := Ini.ReadString('Emitente', 'CNPJ',        '');
    edtEmitIE.Text         := Ini.ReadString('Emitente', 'IE',          '');
    edtEmitRazao.Text      := Ini.ReadString('Emitente', 'RazaoSocial', '');
    edtEmitFantasia.Text   := Ini.ReadString('Emitente', 'Fantasia',    '');
    edtEmitFone.Text       := Ini.ReadString('Emitente', 'Fone',        '');
    edtEmitCEP.Text        := Ini.ReadString('Emitente', 'CEP',         '');
    edtEmitLogradouro.Text := Ini.ReadString('Emitente', 'Logradouro',  '');
    edtEmitNumero.Text     := Ini.ReadString('Emitente', 'Numero',      '');
    edtEmitComp.Text       := Ini.ReadString('Emitente', 'Complemento', '');
    edtEmitBairro.Text     := Ini.ReadString('Emitente', 'Bairro',      '');
    edtEmitCodCidade.Text  := Ini.ReadString('Emitente', 'CodCidade',   '');
    edtEmitCidade.Text     := Ini.ReadString('Emitente', 'Cidade',      '');
    edtEmitUF.Text         := Ini.ReadString('Emitente', 'UF',          '');

    edtSmtpHost.Text     := Ini.ReadString('Email', 'Host',    '');
    edtSmtpPort.Text     := Ini.ReadString('Email', 'Port',    '');
    edtSmtpUser.Text     := Ini.ReadString('Email', 'User',    '');
    edtSmtpPass.Text     := Ini.ReadString('Email', 'Pass',    '');
    edtEmailAssunto.Text := Ini.ReadString('Email', 'Assunto', '');
    cbEmailSSL.Checked   := Ini.ReadBool(  'Email', 'SSL',     False);

    StreamMemo := TMemoryStream.Create;
    Ini.ReadBinaryStream('Email', 'Mensagem', StreamMemo);
    mmEmailMsg.Lines.LoadFromStream(StreamMemo);
    StreamMemo.Free;

    rgTipoDaNF3e.ItemIndex := Ini.ReadInteger('DANF3e', 'Tipo',       0);
    edtLogoMarca.Text      := Ini.ReadString( 'DANF3e', 'LogoMarca',  '');
    rgDANF3E.ItemIndex     := Ini.ReadInteger('DANF3e', 'TipoDANF3E', 0);

    cbxModeloPosPrinter.ItemIndex := INI.ReadInteger('PosPrinter', 'Modelo',            Integer(ACBrPosPrinter1.Modelo));
    cbxPorta.Text                 := INI.ReadString( 'PosPrinter', 'Porta',             ACBrPosPrinter1.Porta);
    cbxPagCodigo.ItemIndex        := INI.ReadInteger('PosPrinter', 'PaginaDeCodigo',    Integer(ACBrPosPrinter1.PaginaDeCodigo));
    seColunas.Value               := INI.ReadInteger('PosPrinter', 'Colunas',           ACBrPosPrinter1.ColunasFonteNormal);
    seEspLinhas.Value             := INI.ReadInteger('PosPrinter', 'EspacoLinhas',      ACBrPosPrinter1.EspacoEntreLinhas);
    seLinhasPular.Value           := INI.ReadInteger('PosPrinter', 'LinhasEntreCupons', ACBrPosPrinter1.LinhasEntreCupons);
    cbCortarPapel.Checked         := Ini.ReadBool(   'PosPrinter', 'CortarPapel',       True);

    ACBrPosPrinter1.Device.ParamsString := INI.ReadString('PosPrinter', 'ParamsString', '');

    ConfigurarComponente;
    ConfigurarEmail;
  finally
    Ini.Free;
  end;
end;

procedure TfrmACBrNF3e.ConfigurarComponente;
var
  Ok: Boolean;
  PathMensal: string;
begin
  ACBrNF3e1.Configuracoes.Certificados.ArquivoPFX  := edtCaminho.Text;
  ACBrNF3e1.Configuracoes.Certificados.Senha       := edtSenha.Text;
  ACBrNF3e1.Configuracoes.Certificados.NumeroSerie := edtNumSerie.Text;

  case rgDANF3E.ItemIndex of
    0: ACBrNF3e1.DANF3E := ACBrNF3eDANF3eRL1;
    1: ACBrNF3e1.DANF3E := ACBrNF3eDANF3eESCPOS1;
  end;

  ACBrNF3e1.SSL.DescarregarCertificado;

  with ACBrNF3e1.Configuracoes.Geral do
  begin
    SSLLib        := TSSLLib(cbSSLLib.ItemIndex);
    SSLCryptLib   := TSSLCryptLib(cbCryptLib.ItemIndex);
    SSLHttpLib    := TSSLHttpLib(cbHttpLib.ItemIndex);
    SSLXmlSignLib := TSSLXmlSignLib(cbXmlSignLib.ItemIndex);

    AtualizarSSLLibsCombo;

    Salvar           := ckSalvar.Checked;
    ExibirErroSchema := cbxExibirErroSchema.Checked;
    RetirarAcentos   := cbxRetirarAcentos.Checked;
    FormatoAlerta    := edtFormatoAlerta.Text;
    FormaEmissao     := TpcnTipoEmissao(cbFormaEmissao.ItemIndex);
    VersaoDF         := TVersaoNF3e(cbVersaoDF.ItemIndex);
  end;

  with ACBrNF3e1.Configuracoes.WebServices do
  begin
    UF         := cbUF.Text;
    Ambiente   := StrToTpAmb(Ok,IntToStr(rgTipoAmb.ItemIndex+1));
    Visualizar := cbxVisualizar.Checked;
    Salvar     := cbxSalvarSOAP.Checked;

    AjustaAguardaConsultaRet := cbxAjustarAut.Checked;

    if NaoEstaVazio(edtAguardar.Text)then
      AguardarConsultaRet := ifThen(StrToInt(edtAguardar.Text) < 1000, StrToInt(edtAguardar.Text) * 1000, StrToInt(edtAguardar.Text))
    else
      edtAguardar.Text := IntToStr(AguardarConsultaRet);

    if NaoEstaVazio(edtTentativas.Text) then
      Tentativas := StrToInt(edtTentativas.Text)
    else
      edtTentativas.Text := IntToStr(Tentativas);

    if NaoEstaVazio(edtIntervalo.Text) then
      IntervaloTentativas := ifThen(StrToInt(edtIntervalo.Text) < 1000, StrToInt(edtIntervalo.Text) * 1000, StrToInt(edtIntervalo.Text))
    else
      edtIntervalo.Text := IntToStr(ACBrNF3e1.Configuracoes.WebServices.IntervaloTentativas);

    TimeOut   := seTimeOut.Value;
    ProxyHost := edtProxyHost.Text;
    ProxyPort := edtProxyPorta.Text;
    ProxyUser := edtProxyUser.Text;
    ProxyPass := edtProxySenha.Text;
  end;

  ACBrNF3e1.SSL.SSLType := TSSLType(cbSSLType.ItemIndex);

  with ACBrNF3e1.Configuracoes.Arquivos do
  begin
    Salvar           := cbxSalvarArqs.Checked;
    SepararPorMes    := cbxPastaMensal.Checked;
    AdicionarLiteral := cbxAdicionaLiteral.Checked;
    EmissaoPathNF3e  := cbxEmissaoPathNF3e.Checked;
    SalvarEvento     := cbxSalvaPathEvento.Checked;
    SepararPorCNPJ   := cbxSepararPorCNPJ.Checked;
    SepararPorModelo := cbxSepararPorModelo.Checked;
    PathSchemas      := edtPathSchemas.Text;
    PathNF3e         := edtPathNF3e.Text;
    PathEvento       := edtPathEvento.Text;
    PathMensal       := GetPathNF3e(0);
    PathSalvar       := PathMensal;
 end;

  if ACBrNF3e1.DANF3e <> nil then
  begin
    ACBrNF3e1.DANF3e.TipoDANF3e := StrToTpImp(OK, IntToStr(rgTipoDaNF3e.ItemIndex + 1));
    ACBrNF3e1.DANF3e.Logo       := edtLogoMarca.Text;
  end;
end;

procedure TfrmACBrNF3e.ConfigurarEmail;
begin
  ACBrMail1.Host := edtSmtpHost.Text;
  ACBrMail1.Port := edtSmtpPort.Text;
  ACBrMail1.Username := edtSmtpUser.Text;
  ACBrMail1.Password := edtSmtpPass.Text;
  ACBrMail1.From := edtSmtpUser.Text;
  ACBrMail1.SetSSL := cbEmailSSL.Checked; // SSL - Conexao Segura
  ACBrMail1.SetTLS := cbEmailSSL.Checked; // Auto TLS
  ACBrMail1.ReadingConfirmation := False; // Pede confirmacao de leitura do email
  ACBrMail1.UseThread := False;           // Aguarda Envio do Email(nao usa thread)
  ACBrMail1.FromName := 'Projeto ACBr - ACBrNF3e';
end;

procedure TfrmACBrNF3e.LoadXML(RetWS: String; MyWebBrowser: TWebBrowser);
begin
  WriteToTXT(PathWithDelim(ExtractFileDir(application.ExeName)) + 'temp.xml',
                      RetWS, False, False);

  MyWebBrowser.Navigate(PathWithDelim(ExtractFileDir(application.ExeName)) + 'temp.xml');

  if ACBrNF3e1.NotasFiscais.Count > 0then
    MemoResp.Lines.Add('Empresa: ' + ACBrNF3e1.NotasFiscais.Items[0].NF3e.Emit.xNome);
end;

procedure TfrmACBrNF3e.PathClick(Sender: TObject);
var
  Dir: string;
begin
  if Length(TEdit(Sender).Text) <= 0 then
     Dir := ExtractFileDir(application.ExeName)
  else
     Dir := TEdit(Sender).Text;

  if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then
    TEdit(Sender).Text := Dir;
end;

procedure TfrmACBrNF3e.PrepararImpressao;
begin
  ACBrPosPrinter1.Desativar;

  ACBrPosPrinter1.Modelo         := TACBrPosPrinterModelo(cbxModeloPosPrinter.ItemIndex);
  ACBrPosPrinter1.PaginaDeCodigo := TACBrPosPaginaCodigo(cbxPagCodigo.ItemIndex);
  ACBrPosPrinter1.Porta          := cbxPorta.Text;

  ACBrPosPrinter1.ColunasFonteNormal := seColunas.Value;
  ACBrPosPrinter1.LinhasEntreCupons  := seLinhasPular.Value;
  ACBrPosPrinter1.EspacoEntreLinhas  := seEspLinhas.Value;
  ACBrPosPrinter1.CortaPapel         := cbCortarPapel.Checked;

  ACBrPosPrinter1.Ativar;
end;

procedure TfrmACBrNF3e.sbPathEventoClick(Sender: TObject);
begin
  PathClick(edtPathEvento);
end;

procedure TfrmACBrNF3e.sbPathNF3eClick(Sender: TObject);
begin
  PathClick(edtPathNF3e);
end;

procedure TfrmACBrNF3e.sbtnCaminhoCertClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione o Certificado';
  OpenDialog1.DefaultExt := '*.pfx';
  OpenDialog1.Filter := 'Arquivos PFX (*.pfx)|*.pfx|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);

  if OpenDialog1.Execute then
    edtCaminho.Text := OpenDialog1.FileName;
end;

procedure TfrmACBrNF3e.sbtnGetCertClick(Sender: TObject);
begin
  edtNumSerie.Text := ACBrNF3e1.SSL.SelecionarCertificado;
end;

procedure TfrmACBrNF3e.sbtnLogoMarcaClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione o Logo';
  OpenDialog1.DefaultExt := '*.bmp';
  OpenDialog1.Filter := 'Arquivos BMP (*.bmp)|*.bmp|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);

  if OpenDialog1.Execute then
    edtLogoMarca.Text := OpenDialog1.FileName;
end;

procedure TfrmACBrNF3e.sbtnNumSerieClick(Sender: TObject);
var
  I: Integer;
  ASerie: String;
  AddRow: Boolean;
begin
  ACBrNF3e1.SSL.LerCertificadosStore;
  AddRow := False;

  with frmSelecionarCertificado.StringGrid1 do
  begin
    ColWidths[0] := 220;
    ColWidths[1] := 250;
    ColWidths[2] := 120;
    ColWidths[3] := 80;
    ColWidths[4] := 150;

    Cells[0, 0] := 'Num.S�rie';
    Cells[1, 0] := 'Raz�o Social';
    Cells[2, 0] := 'CNPJ';
    Cells[3, 0] := 'Validade';
    Cells[4, 0] := 'Certificadora';
  end;

  for I := 0 to ACBrNF3e1.SSL.ListaCertificados.Count-1 do
  begin
    with ACBrNF3e1.SSL.ListaCertificados[I] do
    begin
      ASerie := NumeroSerie;

      if (CNPJ <> '') then
      begin
        with frmSelecionarCertificado.StringGrid1 do
        begin
          if Addrow then
            RowCount := RowCount + 1;

          Cells[0, RowCount-1] := NumeroSerie;
          Cells[1, RowCount-1] := RazaoSocial;
          Cells[2, RowCount-1] := CNPJ;
          Cells[3, RowCount-1] := FormatDateBr(DataVenc);
          Cells[4, RowCount-1] := Certificadora;

          AddRow := True;
        end;
      end;
    end;
  end;

  frmSelecionarCertificado.ShowModal;

  if frmSelecionarCertificado.ModalResult = mrOK then
    edtNumSerie.Text := frmSelecionarCertificado.StringGrid1.Cells[0, frmSelecionarCertificado.StringGrid1.Row];
end;

procedure TfrmACBrNF3e.sbtnPathSalvarClick(Sender: TObject);
begin
  PathClick(edtPathLogs);
end;

procedure TfrmACBrNF3e.spPathSchemasClick(Sender: TObject);
begin
  PathClick(edtPathSchemas);
end;

procedure TfrmACBrNF3e.ACBrNF3e1GerarLog(const ALogLine: String;
  var Tratado: Boolean);
begin
  memoLog.Lines.Add(ALogLine);
  Tratado := True;
end;

procedure TfrmACBrNF3e.ACBrNF3e1StatusChange(Sender: TObject);
begin
  case ACBrNF3e1.Status of
    stIdle:
      begin
        if ( frmStatus <> nil ) then
          frmStatus.Hide;
      end;

    stNF3eStatusServico:
      begin
        if ( frmStatus = nil ) then
          frmStatus := TfrmStatus.Create(Application);

        frmStatus.lblStatus.Caption := 'Verificando Status do servico...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNF3eRecepcao:
      begin
        if ( frmStatus = nil ) then
          frmStatus := TfrmStatus.Create(Application);

        frmStatus.lblStatus.Caption := 'Enviando dados da NF3e...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNF3eRetRecepcao:
      begin
        if ( frmStatus = nil ) then
          frmStatus := TfrmStatus.Create(Application);

        frmStatus.lblStatus.Caption := 'Recebendo dados da NF3e...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNF3eConsulta:
      begin
        if ( frmStatus = nil ) then
          frmStatus := TfrmStatus.Create(Application);

        frmStatus.lblStatus.Caption := 'Consultando NF3e...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNF3eRecibo:
      begin
        if ( frmStatus = nil ) then
          frmStatus := TfrmStatus.Create(Application);

        frmStatus.lblStatus.Caption := 'Consultando Recibo de Lote...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNF3eEmail:
      begin
        if ( frmStatus = nil ) then
          frmStatus := TfrmStatus.Create(Application);

        frmStatus.lblStatus.Caption := 'Enviando Email...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNF3eEvento:
      begin
        if ( frmStatus = nil ) then
          frmStatus := TfrmStatus.Create(Application);

        frmStatus.lblStatus.Caption := 'Enviando Evento...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
  end;

  Application.ProcessMessages;
end;

end.
