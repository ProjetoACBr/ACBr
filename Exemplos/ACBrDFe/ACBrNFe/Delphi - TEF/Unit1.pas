{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
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

unit Unit1;

interface

uses IniFiles, ShellAPI, pcnRetConsReciDFe, ACBrTEFDClass, ACBrTEFDCliSiTef,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, OleCtrls, SHDocVw,
  ACBrNFe, pcnConversao, ACBrUtil, ACBrNFeDANFEClass, ACBrNFeDANFeESCPOS,
  ACBrBase, ACBrDFe, XMLIntf, XMLDoc, zlib, ACBrDevice,
  ACBrMail, ACBrNFeDANFeRLClass, ACBrDANFCeFortesFr, ACBrTEFD, ACBrDFeReport,
  ACBrDFeDANFeReport;

type
  tEstadoEcfSimulado = (tpsLivre, tpsVenda, tpsSubTotal, tpsTotalPagar, tpsPagamento, tpsRelatorio);
  tpPagamento = (tpDinheiro, tpCartao);
  { TForm1 }

  TForm1 = class(TForm)
    Panel1: TPanel;
    OpenDialog1: TOpenDialog;
    btnSalvarConfig: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    pgRespostas: TPageControl;
    TabSheet5: TTabSheet;
    MemoResp: TMemo;
    TabSheet6: TTabSheet;
    WBResposta: TWebBrowser;
    ACBrNFe1: TACBrNFe;
    TabSheet8: TTabSheet;
    memoLog: TMemo;
    TabSheet9: TTabSheet;
    trvwNFe: TTreeView;
    lblColaborador: TLabel;
    lblPatrocinador: TLabel;
    lblDoar1: TLabel;
    lblDoar2: TLabel;
    TabSheet10: TTabSheet;
    memoRespWS: TMemo;
    Dados: TTabSheet;
    MemoDados: TMemo;
    TabSheet11: TTabSheet;
    TreeViewRetornoConsulta: TTreeView;
    PageControl3: TPageControl;
    tsNFe: TTabSheet;
    tsNFCe: TTabSheet;
    btnImprimir: TButton;
    btnConsultar: TButton;
    btnValidarXML: TButton;
    btnStatusServ: TButton;
    btnCancNF: TButton;
    btnCriarEnviar: TButton;
    btnInutilizar: TButton;
    btnGerarNFE: TButton;
    btnConsCad: TButton;
    btnGerarPDF: TButton;
    btnEnviarEmail: TButton;
    btnConsultarRecibo: TButton;
    btnImportarXML: TButton;
    btnConsultarChave: TButton;
    btnCancelarChave: TButton;
    btnGerarTXT: TButton;
    btnAdicionarProtNFe: TButton;
    btnCarregarXMLEnviar: TButton;
    btnCartadeCorrecao: TButton;
    btnValidarAssinatura: TButton;
    btnManifDestConfirmacao: TButton;
    btnNfeDestinadas: TButton;
    btnImprimirCCe: TButton;
    btnEnviarEvento: TButton;
    btnCriarEnviarNFCe: TButton;
    btnDistribuicaoDFe: TButton;
    ACBrNFeDANFeESCPOS1: TACBrNFeDANFeESCPOS;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PageControl4: TPageControl;
    TabSheet3: TTabSheet;
    gbCertificado: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    sbtnCaminhoCert: TSpeedButton;
    Label25: TLabel;
    sbtnGetCert: TSpeedButton;
    edtCaminho: TEdit;
    edtSenha: TEdit;
    edtNumSerie: TEdit;
    TabSheet4: TTabSheet;
    GroupBox3: TGroupBox;
    sbtnPathSalvar: TSpeedButton;
    Label29: TLabel;
    edtPathLogs: TEdit;
    ckSalvar: TCheckBox;
    cbFormaEmissao: TComboBox;
    TabSheet7: TTabSheet;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    cbxVisualizar: TCheckBox;
    cbUF: TComboBox;
    rgTipoAmb: TRadioGroup;
    gbProxy: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edtProxyHost: TEdit;
    edtProxyPorta: TEdit;
    edtProxyUser: TEdit;
    edtProxySenha: TEdit;
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
    Label7: TLabel;
    edtLogoMarca: TEdit;
    sbtnLogoMarca: TSpeedButton;
    rgTipoDanfe: TRadioGroup;
    cbxAtualizarXML: TCheckBox;
    cbxExibirErroSchema: TCheckBox;
    Label31: TLabel;
    edtFormatoAlerta: TEdit;
    Label30: TLabel;
    cbModeloDF: TComboBox;
    cbxRetirarAcentos: TCheckBox;
    Label32: TLabel;
    cbVersaoDF: TComboBox;
    Label33: TLabel;
    Label34: TLabel;
    edtIdToken: TEdit;
    edtToken: TEdit;
    cbxSalvarSOAP: TCheckBox;
    gbxRetornoEnvio: TGroupBox;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    cbxAjustarAut: TCheckBox;
    edtTentativas: TEdit;
    edtIntervalo: TEdit;
    edtAguardar: TEdit;
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
    cbxSalvarArqs: TCheckBox;
    cbxPastaMensal: TCheckBox;
    cbxAdicionaLiteral: TCheckBox;
    cbxEmissaoPathNFe: TCheckBox;
    cbxSalvaPathEvento: TCheckBox;
    cbxSepararPorCNPJ: TCheckBox;
    sbPathNFe: TSpeedButton;
    Label35: TLabel;
    Label39: TLabel;
    sbPathCan: TSpeedButton;
    Label46: TLabel;
    sbPathCCe: TSpeedButton;
    edtPathCCe: TEdit;
    edtPathNFe: TEdit;
    edtPathCan: TEdit;
    Label40: TLabel;
    sbPathInu: TSpeedButton;
    Label41: TLabel;
    sbPathDPEC: TSpeedButton;
    Label47: TLabel;
    sbPathEvento: TSpeedButton;
    edtPathInu: TEdit;
    edtPathDPEC: TEdit;
    edtPathEvento: TEdit;
    cbxSepararPorModelo: TCheckBox;
    Label42: TLabel;
    edtPathSchemas: TEdit;
    spPathSchemas: TSpeedButton;
    ACBrMail1: TACBrMail;
    cbTipoEmissao: TComboBox;
    Label43: TLabel;
    Label44: TLabel;
    btnInutilizarImprimir: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Button5: TButton;
    cbAssinar: TCheckBox;
    tsNFCETef: TTabSheet;
    ACBrTEFD1: TACBrTEFD;
    Panel4: TPanel;
    sECF: TShape;
    lECFName: TLabel;
    sTEFDial: TShape;
    sTEFDisc: TShape;
    sHiperTEF: TShape;
    sCliSiTef: TShape;
    sVSPague: TShape;
    sAuttar: TShape;
    ckTEFDIAL: TCheckBox;
    ckTEFDISC: TCheckBox;
    ckHIPERTEF: TCheckBox;
    ckCliSiTef: TCheckBox;
    bCancelarResp: TButton;
    ckVSPague: TCheckBox;
    ckAuttar: TCheckBox;
    PageControl2: TPageControl;
    tsConfig: TTabSheet;
    Panel5: TPanel;
    gbConfigTEF: TGroupBox;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    bInicializar: TButton;
    ckAutoAtivar: TCheckBox;
    cbxGP: TComboBox;
    bAtivarGP: TButton;
    ckMultiplosCartoes: TCheckBox;
    ckAutoFinalizarCupom: TCheckBox;
    ckAutoEfetuarPagamento: TCheckBox;
    edEsperaSleep: TEdit;
    edEsperaSTS: TEdit;
    tsOperacao: TTabSheet;
    gbCupomECF: TGroupBox;
    gbComandosTEF: TGroupBox;
    bADM: TButton;
    cbxGP1: TComboBox;
    StatusBar1: TStatusBar;
    TabSheetCupomTef: TTabSheet;
    MemoCupomTEF: TMemo;
    GroupBoxDadosDaVenda: TGroupBox;
    edValorVenda: TEdit;
    Label50: TLabel;
    EditNumNFCe: TEdit;
    Label45: TLabel;
    ButtonIniciaVenda: TButton;
    GroupBoxFechamento: TGroupBox;
    GroupBox1: TGroupBox;
    EditTotalPago: TEdit;
    EditSaldoRestante: TEdit;
    labelDescricaoTotalRecebido: TLabel;
    Label51: TLabel;
    edValorPagamento: TEdit;
    Label55: TLabel;
    ButtonPagarEmCartao: TButton;
    ButtonPagarEmDinheiro: TButton;
    ButtonCancelarVenda: TButton;
    pMensagem: TPanel;
    pMensagemOperador: TPanel;
    lMensagemOperador: TLabel;
    Label48: TLabel;
    pMensagemCliente: TPanel;
    Label49: TLabel;
    lMensagemCliente: TLabel;
    ACBrNFeDANFCeFortes1: TACBrNFeDANFCeFortes;
    ACBrNFeDANFeRL1: TACBrNFeDANFeRL;
    procedure sbtnCaminhoCertClick(Sender: TObject);
    procedure sbtnLogoMarcaClick(Sender: TObject);
    procedure sbtnPathSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarConfigClick(Sender: TObject);
    procedure btnStatusServClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnCancNFClick(Sender: TObject);
    procedure btnValidarXMLClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnCriarEnviarClick(Sender: TObject);
    procedure btnInutilizarClick(Sender: TObject);
    procedure ACBrNFe1StatusChange(Sender: TObject);
    procedure sbtnGetCertClick(Sender: TObject);
    procedure btnGerarNFEClick(Sender: TObject);
    procedure btnConsCadClick(Sender: TObject);
    procedure btnGerarPDFClick(Sender: TObject);
    procedure btnEnviarEmailClick(Sender: TObject);
    procedure btnConsultarReciboClick(Sender: TObject);
    procedure ACBrNFe1GerarLog(const Mensagem: String);
    procedure btnImportarXMLClick(Sender: TObject);
    procedure lblMouseEnter(Sender: TObject);
    procedure lblMouseLeave(Sender: TObject);
    procedure lblColaboradorClick(Sender: TObject);
    procedure lblPatrocinadorClick(Sender: TObject);
    procedure lblDoar1Click(Sender: TObject);
    procedure btnConsultarChaveClick(Sender: TObject);
    procedure btnCancelarChaveClick(Sender: TObject);
    procedure btnGerarTXTClick(Sender: TObject);
    procedure btnAdicionarProtNFeClick(Sender: TObject);
    procedure btnCarregarXMLEnviarClick(Sender: TObject);
    procedure btnCartadeCorrecaoClick(Sender: TObject);
    procedure btnValidarAssinaturaClick(Sender: TObject);
    procedure btnManifDestConfirmacaoClick(Sender: TObject);
    procedure btnNfeDestinadasClick(Sender: TObject);
    procedure btnImprimirCCeClick(Sender: TObject);
    procedure btnEnviarEventoClick(Sender: TObject);
    procedure btnCriarEnviarNFCeClick(Sender: TObject);
    procedure btnDistribuicaoDFeClick(Sender: TObject);
    procedure PathClick(Sender: TObject);
    procedure sbPathNFeClick(Sender: TObject);
    procedure sbPathCanClick(Sender: TObject);
    procedure sbPathCCeClick(Sender: TObject);
    procedure sbPathInuClick(Sender: TObject);
    procedure sbPathDPECClick(Sender: TObject);
    procedure sbPathEventoClick(Sender: TObject);
    procedure spPathSchemasClick(Sender: TObject);
    procedure cbTipoEmissaoChange(Sender: TObject);
    procedure btnInutilizarImprimirClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ButtonPagarEmCartaoClick(Sender: TObject);
    procedure bInicializarClick(Sender: TObject);
    procedure bAtivarGPClick(Sender: TObject);
    procedure ckAutoAtivarClick(Sender: TObject);
    procedure ckMultiplosCartoesClick(Sender: TObject);
    procedure ckAutoEfetuarPagamentoClick(Sender: TObject);
    procedure ckAutoFinalizarCupomClick(Sender: TObject);
    procedure edEsperaSleepChange(Sender: TObject);
    procedure edEsperaSTSChange(Sender: TObject);
    procedure ACBrTEFD1ExibeMsg(Operacao: TACBrTEFDOperacaoMensagem; Mensagem: string; var AModalResult: TModalResult);
    procedure ACBrTEFD1ComandaECF(Operacao: TACBrTEFDOperacaoECF; Resp: TACBrTEFDResp; var RetornoECF: Integer);
    procedure ACBrTEFD1ComandaECFAbreVinculado(COO, IndiceECF: string; Valor: Double; var RetornoECF: Integer);
    procedure ACBrTEFD1ComandaECFImprimeVia(TipoRelatorio: TACBrTEFDTipoRelatorio; Via: Integer; ImagemComprovante: TStringList; var RetornoECF: Integer);
    procedure ACBrTEFD1InfoECF(Operacao: TACBrTEFDInfoECF; var RetornoECF: string);
    procedure ACBrTEFD1CliSiTefExibeMenu(Titulo: string; Opcoes: TStringList; var ItemSelecionado: Integer; var VoltarMenu: Boolean);
    procedure ACBrTEFD1CliSiTefObtemCampo(Titulo: string; TamanhoMinimo,
        TamanhoMaximo, TipoCampo: Integer; Operacao:
        TACBrTEFDCliSiTefOperacaoCampo; var Resposta: AnsiString; var Digitado,
        VoltarMenu: Boolean);
    procedure bADMClick(Sender: TObject);
    procedure cbxGPChange(Sender: TObject);
    procedure bAbreVendeSubTotaliza3Click(Sender: TObject);
    procedure bAbreVendeSubTotaliza2Click(Sender: TObject);
    procedure ButtonIniciaVendaClick(Sender: TObject);
    procedure ACBrTEFD1ComandaECFSubtotaliza(DescAcre: Double; var RetornoECF: Integer);
    procedure ButtonPagarEmDinheiroClick(Sender: TObject);
    procedure ButtonCancelarVendaClick(Sender: TObject);
    
  private
    { Private declarations }

    IndiceTransacaoTef : Integer;
    estadoSimuladoEcf : tEstadoEcfSimulado;
    procedure GravarConfiguracao ;
    procedure LerConfiguracao ;
    procedure ConfigurarEmail;
    procedure GerarNFe(NumNFe : String);
    procedure GerarNFCe(NumNFe : String);
    procedure LoadXML(RetWS: String; MyWebBrowser: TWebBrowser);

    procedure LoadConsulta201(XML: String);
    procedure GerarNFCeTEF(NumNFe: String; valorVenda: Currency; emissaoOffLine: Boolean);
    procedure AvaliaTEFs;
    function verificarSaldoRestante: Currency;
    procedure EfetuaPagamento(formaPagamento: tpPagamento);
    procedure travarComponentesTEF(abriuVenda: Boolean);
    function enviarNFCeTEF(numeroNFce: string; out StrDescMensagem: string): boolean;
    procedure finalizarCupomNFCe;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  strutils, math, TypInfo, DateUtils, ufrmStatus, synacode, ACBrNFe.Classes,
  pcnConversaoNFe, ACBrDFeConfiguracoes, pcnAuxiliar, ACBrDFeSSL, pcnNFeRTXT,
  FileCtrl, Unit4, Unit5;

const
  SELDIRHELP = 1000;

{$R *.dfm}

procedure TForm1.GravarConfiguracao;
Var IniFile : String ;
    Ini     : TIniFile ;
    StreamMemo : TMemoryStream;
begin
  IniFile := ChangeFileExt( Application.ExeName, '.ini') ;

  Ini := TIniFile.Create( IniFile );
  try
      Ini.WriteInteger( 'Certificado','TipoEmissao' , cbTipoEmissao.ItemIndex) ;
      Ini.WriteString( 'Certificado','Caminho' ,edtCaminho.Text) ;
      Ini.WriteString( 'Certificado','Senha'   ,edtSenha.Text) ;
      Ini.WriteString( 'Certificado','NumSerie',edtNumSerie.Text) ;

      Ini.WriteBool(   'Geral','AtualizarXML'      ,ckSalvar.Checked) ;
      Ini.WriteBool(   'Geral','ExibirErroSchema'      ,ckSalvar.Checked) ;
      Ini.WriteString( 'Geral','FormatoAlerta'  ,edtFormatoAlerta.Text) ;
      Ini.WriteInteger( 'Geral','FormaEmissao',cbFormaEmissao.ItemIndex) ;
      Ini.WriteInteger( 'Geral','ModeloDF',cbModeloDF.ItemIndex) ;
      Ini.WriteInteger( 'Geral','VersaoDF',cbVersaoDF.ItemIndex) ;
      Ini.WriteString( 'Geral','IdToken'  ,edtIdToken.Text) ;
      Ini.WriteString( 'Geral','Token'  ,edtToken.Text) ;
      Ini.WriteBool(   'Geral','RetirarAcentos'      ,cbxRetirarAcentos.Checked) ;
      Ini.WriteBool(   'Geral','Salvar'      ,ckSalvar.Checked) ;
      Ini.WriteString( 'Geral','PathSalvar'  ,edtPathLogs.Text) ;
      Ini.WriteString( 'Geral','PathSchemas'  ,edtPathSchemas.Text) ;

      Ini.WriteString( 'WebService','UF'        ,cbUF.Text) ;
      Ini.WriteInteger( 'WebService','Ambiente'  ,rgTipoAmb.ItemIndex) ;
      Ini.WriteBool(   'WebService','Visualizar',cbxVisualizar.Checked) ;
      Ini.WriteBool(   'WebService','SalvarSOAP',cbxSalvarSOAP.Checked) ;
      Ini.WriteBool(   'WebService','AjustarAut',cbxAjustarAut.Checked) ;
      Ini.WriteString( 'WebService','Aguardar'    ,edtAguardar.Text) ;
      Ini.WriteString( 'WebService','Tentativas'  ,edtTentativas.Text) ;
      Ini.WriteString( 'WebService','Intervalo'  ,edtIntervalo.Text) ;

      Ini.WriteString( 'Proxy','Host'   ,edtProxyHost.Text) ;
      Ini.WriteString( 'Proxy','Porta'  ,edtProxyPorta.Text) ;
      Ini.WriteString( 'Proxy','User'   ,edtProxyUser.Text) ;
      Ini.WriteString( 'Proxy','Pass'   ,edtProxySenha.Text) ;

      Ini.WriteBool(   'Arquivos','Salvar'          ,cbxSalvarArqs.Checked) ;
      Ini.WriteBool(   'Arquivos','PastaMensal'     ,cbxPastaMensal.Checked) ;
      Ini.WriteBool(   'Arquivos','AddLiteral'      ,cbxAdicionaLiteral.Checked) ;
      Ini.WriteBool(   'Arquivos','EmissaoPathNFe'  ,cbxEmissaoPathNFe.Checked) ;
      Ini.WriteBool(   'Arquivos','SalvarPathEvento',cbxSalvaPathEvento.Checked) ;
      Ini.WriteBool(   'Arquivos','SepararPorCNPJ'  ,cbxSepararPorCNPJ.Checked) ;
      Ini.WriteBool(   'Arquivos','SepararPorModelo',cbxSepararPorModelo.Checked) ;
      Ini.WriteString( 'Arquivos','PathNFe'    ,edtPathNFe.Text) ;
      Ini.WriteString( 'Arquivos','PathCan'    ,edtPathCan.Text) ;
      Ini.WriteString( 'Arquivos','PathInu'    ,edtPathInu.Text) ;
      Ini.WriteString( 'Arquivos','PathDPEC'   ,edtPathDPEC.Text) ;
      Ini.WriteString( 'Arquivos','PathCCe'    ,edtPathCCe.Text) ;
      Ini.WriteString( 'Arquivos','PathEvento' ,edtPathEvento.Text) ;

      Ini.WriteString( 'Emitente','CNPJ'       ,edtEmitCNPJ.Text) ;
      Ini.WriteString( 'Emitente','IE'         ,edtEmitIE.Text) ;
      Ini.WriteString( 'Emitente','RazaoSocial',edtEmitRazao.Text) ;
      Ini.WriteString( 'Emitente','Fantasia'   ,edtEmitFantasia.Text) ;
      Ini.WriteString( 'Emitente','Fone'       ,edtEmitFone.Text) ;
      Ini.WriteString( 'Emitente','CEP'        ,edtEmitCEP.Text) ;
      Ini.WriteString( 'Emitente','Logradouro' ,edtEmitLogradouro.Text) ;
      Ini.WriteString( 'Emitente','Numero'     ,edtEmitNumero.Text) ;
      Ini.WriteString( 'Emitente','Complemento',edtEmitComp.Text) ;
      Ini.WriteString( 'Emitente','Bairro'     ,edtEmitBairro.Text) ;
      Ini.WriteString( 'Emitente','CodCidade'  ,edtEmitCodCidade.Text) ;
      Ini.WriteString( 'Emitente','Cidade'     ,edtEmitCidade.Text) ;
      Ini.WriteString( 'Emitente','UF'         ,edtEmitUF.Text) ;

      Ini.WriteString( 'Email','Host'    ,edtSmtpHost.Text) ;
      Ini.WriteString( 'Email','Port'    ,edtSmtpPort.Text) ;
      Ini.WriteString( 'Email','User'    ,edtSmtpUser.Text) ;
      Ini.WriteString( 'Email','Pass'    ,edtSmtpPass.Text) ;
      Ini.WriteString( 'Email','Assunto' ,edtEmailAssunto.Text) ;
      Ini.WriteBool(   'Email','SSL'     ,cbEmailSSL.Checked ) ;
      StreamMemo := TMemoryStream.Create;
      mmEmailMsg.Lines.SaveToStream(StreamMemo);
      StreamMemo.Seek(0,soFromBeginning);
      Ini.WriteBinaryStream( 'Email','Mensagem',StreamMemo) ;
      StreamMemo.Free;

      Ini.WriteInteger( 'DANFE','Tipo'       ,rgTipoDanfe.ItemIndex) ;
      Ini.WriteString( 'DANFE','LogoMarca'   ,edtLogoMarca.Text) ;

  finally
     Ini.Free ;
  end;

end;

procedure TForm1.LerConfiguracao;
Var IniFile  : String ;
    Ini     : TIniFile ;
    Ok : Boolean;
    StreamMemo : TMemoryStream;
begin
  IniFile := ChangeFileExt( Application.ExeName, '.ini') ;

  Ini := TIniFile.Create( IniFile );
  try
     cbTipoEmissao.ItemIndex:= Ini.ReadInteger( 'Certificado','TipoEmissao' ,0) ;
     edtCaminho.Text  := Ini.ReadString( 'Certificado','Caminho' ,'') ;
     edtSenha.Text    := Ini.ReadString( 'Certificado','Senha'   ,'') ;
     edtNumSerie.Text := Ini.ReadString( 'Certificado','NumSerie','') ;
     ACBrNFe1.Configuracoes.Certificados.ArquivoPFX  := edtCaminho.Text;
     ACBrNFe1.Configuracoes.Certificados.Senha       := edtSenha.Text;
     ACBrNFe1.Configuracoes.Certificados.NumeroSerie := edtNumSerie.Text;

      cbxAtualizarXML.Checked    := Ini.ReadBool(   'Geral','AtualizarXML',True) ;
      cbxExibirErroSchema.Checked    := Ini.ReadBool(   'Geral','ExibirErroSchema',True) ;
      edtFormatoAlerta.Text    := Ini.ReadString( 'Geral','FormatoAlerta'  ,'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.') ;
      cbFormaEmissao.ItemIndex := Ini.ReadInteger( 'Geral','FormaEmissao',0) ;
      cbModeloDF.ItemIndex := Ini.ReadInteger( 'Geral','ModeloDF',0) ;
      cbVersaoDF.ItemIndex := Ini.ReadInteger( 'Geral','VersaoDF',0) ;
      edtIdToken.Text      := Ini.ReadString( 'Geral','IdToken'  ,'') ;
      edtToken.Text        := Ini.ReadString( 'Geral','Token'  ,'') ;
      ckSalvar.Checked     := Ini.ReadBool(   'Geral','Salvar'      ,True) ;
      cbxRetirarAcentos.Checked := Ini.ReadBool(   'Geral','RetirarAcentos',True) ;
      edtPathLogs.Text     := Ini.ReadString( 'Geral','PathSalvar'  ,PathWithDelim(ExtractFilePath(Application.ExeName))+'Logs') ;
      edtPathSchemas.Text  := Ini.ReadString( 'Geral','PathSchemas'  ,PathWithDelim(ExtractFilePath(Application.ExeName))+'Schemas\'+GetEnumName(TypeInfo(TpcnVersaoDF), integer(cbVersaoDF.ItemIndex) )) ;

      with ACBrNFe1.Configuracoes.Geral do
       begin
         ExibirErroSchema := cbxExibirErroSchema.Checked;
         RetirarAcentos   := cbxRetirarAcentos.Checked;
         FormatoAlerta    := edtFormatoAlerta.Text;
         FormaEmissao     := TpcnTipoEmissao(cbFormaEmissao.ItemIndex);
         ModeloDF         := TpcnModeloDF(cbModeloDF.ItemIndex);
         VersaoDF         := TpcnVersaoDF(cbVersaoDF.ItemIndex);
         IdCSC            := edtIdToken.Text;
         CSC              := edtToken.Text;
         Salvar           := ckSalvar.Checked;
       end;

      cbUF.ItemIndex        := cbUF.Items.IndexOf(Ini.ReadString( 'WebService','UF','SP')) ;
      rgTipoAmb.ItemIndex   := Ini.ReadInteger( 'WebService','Ambiente'  ,0) ;
      cbxVisualizar.Checked  := Ini.ReadBool(    'WebService','Visualizar',False) ;
      cbxSalvarSOAP.Checked := Ini.ReadBool(    'WebService','SalvarSOAP',False) ;
      cbxAjustarAut.Checked  := Ini.ReadBool(   'WebService','AjustarAut' ,False) ;
      edtAguardar.Text       := Ini.ReadString( 'WebService','Aguardar'  ,'0') ;
      edtTentativas.Text     := Ini.ReadString( 'WebService','Tentativas','5') ;
      edtIntervalo.Text      := Ini.ReadString( 'WebService','Intervalo' ,'0') ;
      edtProxyHost.Text  := Ini.ReadString( 'Proxy','Host'   ,'') ;
      edtProxyPorta.Text := Ini.ReadString( 'Proxy','Porta'  ,'') ;
      edtProxyUser.Text  := Ini.ReadString( 'Proxy','User'   ,'') ;
      edtProxySenha.Text := Ini.ReadString( 'Proxy','Pass'   ,'') ;

      with ACBrNFe1.Configuracoes.WebServices do
       begin
         UF         := cbUF.Text;
         Ambiente   := StrToTpAmb(Ok,IntToStr(rgTipoAmb.ItemIndex+1));
         Visualizar := cbxVisualizar.Checked;
         Salvar     := cbxSalvarSOAP.Checked;
         AjustaAguardaConsultaRet := cbxAjustarAut.Checked;
         if NaoEstaVazio(edtAguardar.Text)then
            AguardarConsultaRet := ifThen(StrToInt(edtAguardar.Text)<1000,StrToInt(edtAguardar.Text)*1000,StrToInt(edtAguardar.Text))
         else
            edtAguardar.Text := IntToStr(AguardarConsultaRet);

         if NaoEstaVazio(edtTentativas.Text) then
            Tentativas          := StrToInt(edtTentativas.Text)
         else
            edtTentativas.Text := IntToStr(Tentativas);

         if NaoEstaVazio(edtIntervalo.Text) then
            IntervaloTentativas := ifThen(StrToInt(edtIntervalo.Text)<1000,StrToInt(edtIntervalo.Text)*1000,StrToInt(edtIntervalo.Text))
         else
            edtIntervalo.Text := IntToStr(ACBrNFe1.Configuracoes.WebServices.IntervaloTentativas);            

         ProxyHost := edtProxyHost.Text;
         ProxyPort := edtProxyPorta.Text;
         ProxyUser := edtProxyUser.Text;
         ProxyPass := edtProxySenha.Text;
       end;

      cbxSalvarArqs.Checked       := Ini.ReadBool(   'Arquivos','Salvar'     ,false);
      cbxPastaMensal.Checked      := Ini.ReadBool(   'Arquivos','PastaMensal',false);
      cbxAdicionaLiteral.Checked  := Ini.ReadBool(   'Arquivos','AddLiteral' ,false);
      cbxEmissaoPathNFe.Checked   := Ini.ReadBool(   'Arquivos','EmissaoPathNFe',false);
      cbxSalvaPathEvento.Checked  := Ini.ReadBool(   'Arquivos','SalvarPathEvento',false);
      cbxSepararPorCNPJ.Checked   := Ini.ReadBool(   'Arquivos','SepararPorCNPJ',false);
      cbxSepararPorModelo.Checked := Ini.ReadBool(   'Arquivos','SepararPorModelo',false);
      edtPathNFe.Text             := Ini.ReadString( 'Arquivos','PathNFe'    ,'') ;
      edtPathCan.Text             := Ini.ReadString( 'Arquivos','PathCan'    ,'') ;
      edtPathInu.Text             := Ini.ReadString( 'Arquivos','PathInu'    ,'') ;
      edtPathDPEC.Text            := Ini.ReadString( 'Arquivos','PathDPEC'   ,'') ;
      edtPathCCe.Text             := Ini.ReadString( 'Arquivos','PathCCe'   ,'') ;
      edtPathEvento.Text          := Ini.ReadString( 'Arquivos','PathEvento','') ;

      with ACBrNFe1.Configuracoes.Arquivos do
       begin
         Salvar             := cbxSalvarArqs.Checked;
         SepararPorMes      := cbxPastaMensal.Checked;
         AdicionarLiteral   := cbxAdicionaLiteral.Checked;
         EmissaoPathNFe     := cbxEmissaoPathNFe.Checked;
         SalvarEvento       := cbxSalvaPathEvento.Checked;
         SepararPorCNPJ     := cbxSepararPorCNPJ.Checked;
         SepararPorModelo   := cbxSepararPorModelo.Checked;
         PathSalvar         := edtPathLogs.Text;
         PathSchemas        := edtPathSchemas.Text;
         PathNFe            := edtPathNFe.Text;
         PathInu            := edtPathInu.Text;
         PathEvento         := edtPathEvento.Text;
       end;

      edtEmitCNPJ.Text       := Ini.ReadString( 'Emitente','CNPJ'       ,'') ;
      edtEmitIE.Text         := Ini.ReadString( 'Emitente','IE'         ,'') ;
      edtEmitRazao.Text      := Ini.ReadString( 'Emitente','RazaoSocial','') ;
      edtEmitFantasia.Text   := Ini.ReadString( 'Emitente','Fantasia'   ,'') ;
      edtEmitFone.Text       := Ini.ReadString( 'Emitente','Fone'       ,'') ;
      edtEmitCEP.Text        := Ini.ReadString( 'Emitente','CEP'        ,'') ;
      edtEmitLogradouro.Text := Ini.ReadString( 'Emitente','Logradouro' ,'') ;
      edtEmitNumero.Text     := Ini.ReadString( 'Emitente','Numero'     ,'') ;
      edtEmitComp.Text       := Ini.ReadString( 'Emitente','Complemento','') ;
      edtEmitBairro.Text     := Ini.ReadString( 'Emitente','Bairro'     ,'') ;
      edtEmitCodCidade.Text  := Ini.ReadString( 'Emitente','CodCidade'  ,'') ;
      edtEmitCidade.Text     :=Ini.ReadString( 'Emitente','Cidade'     ,'') ;
      edtEmitUF.Text         := Ini.ReadString( 'Emitente','UF'         ,'') ;

      edtSmtpHost.Text      := Ini.ReadString( 'Email','Host'   ,'') ;
      edtSmtpPort.Text      := Ini.ReadString( 'Email','Port'   ,'') ;
      edtSmtpUser.Text      := Ini.ReadString( 'Email','User'   ,'') ;
      edtSmtpPass.Text      := Ini.ReadString( 'Email','Pass'   ,'') ;
      edtEmailAssunto.Text  := Ini.ReadString( 'Email','Assunto','') ;
      cbEmailSSL.Checked    := Ini.ReadBool(   'Email','SSL'    ,False) ;
      StreamMemo := TMemoryStream.Create;
      Ini.ReadBinaryStream( 'Email','Mensagem',StreamMemo) ;
      mmEmailMsg.Lines.LoadFromStream(StreamMemo);
      StreamMemo.Free;

      rgTipoDanfe.ItemIndex     := Ini.ReadInteger( 'DANFE','Tipo'       ,0) ;
      edtLogoMarca.Text         := Ini.ReadString( 'DANFE','LogoMarca'   ,'') ;
      if ACBrNFe1.DANFE <> nil then
       begin
         ACBrNFe1.DANFE.TipoDANFE  := StrToTpImp(OK,IntToStr(rgTipoDanfe.ItemIndex+1));
         ACBrNFe1.DANFE.Logo       := edtLogoMarca.Text;
       end;      
  finally
     Ini.Free ;
  end;

end;

procedure TForm1.LoadConsulta201(XML: String);
var
  DOM: IXMLDocument;
  lXML: String;

  procedure AddNodes(XMLNode: IXMLNode; TreeNode: TTreeNode);
  var
    Index: Integer;
    NewNode: TTreeNode;
    Value: string;
  begin
    if XMLNode.nodeType in [ntTEXT, ntCDATA, ntCOMMENT] then
      Value := XMLNode.text
    else
      Value := XMLNode.nodeName;
    NewNode := TreeViewRetornoConsulta.Items.AddChild(TreeNode, {XMLNode.NodeName +} '�' + Value);
    for Index := 0 to XMLNode.childNodes.Count - 1 do
      AddNodes(XMLNode.childNodes[Index], NewNode);
  end;

  function ReplaceStr( Fonte, De, Para:String ):String;
  begin
    result:=fonte;
    while pos(de,result) <> 0 do
      result:=copy(result, 1, pos(de,result)-1 )+Para+copy(result,pos(de,result)+length(de),length(result) );
  end;

  function LimpaXML(XML: String; TagRemover:String): String;
  begin
    Result := XML;
    while pos('<'+TagRemover,Result) <> 0 do
    begin
      Result := ReplaceStr(Result,
                           '<'+TagRemover+
                              RetornarConteudoEntre(Result,'<'+TagRemover,'</'+TagRemover+'>')+
                           '</'+TagRemover+'>','');
    end;
  end;
begin
  DOM := TXMLDocument.Create(nil);
  try
    lXML := LimpaXML(UTF8Decode(XML),'Signature');
    DOM.LoadFromXML(lXML);
    DOM.Active := True;
    TreeViewRetornoConsulta.Items.BeginUpdate;
    TreeViewRetornoConsulta.Items.Clear;
    AddNodes(dom.DocumentElement, nil);
    TreeViewRetornoConsulta.TopItem := TreeViewRetornoConsulta.Items[0];
  finally
    TreeViewRetornoConsulta.Items.EndUpdate;
  end;
end;

procedure TForm1.LoadXML(RetWS: String; MyWebBrowser: TWebBrowser);
begin
  ACBrUtil.WriteToTXT( PathWithDelim(ExtractFileDir(application.ExeName))+'temp.xml',
                        ACBrUtil.ConverteXMLtoUTF8( RetWS ), False, False);
  MyWebBrowser.Navigate(PathWithDelim(ExtractFileDir(application.ExeName))+'temp.xml');
end;

procedure TForm1.sbtnCaminhoCertClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione o Certificado';
  OpenDialog1.DefaultExt := '*.pfx';
  OpenDialog1.Filter := 'Arquivos PFX (*.pfx)|*.pfx|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);
  if OpenDialog1.Execute then
  begin
    edtCaminho.Text := OpenDialog1.FileName;
  end;
end;

procedure TForm1.sbtnLogoMarcaClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione o Logo';
  OpenDialog1.DefaultExt := '*.bmp';
  OpenDialog1.Filter := 'Arquivos BMP (*.bmp)|*.bmp|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);
  if OpenDialog1.Execute then
  begin
    edtLogoMarca.Text := OpenDialog1.FileName;
  end;
end;

procedure TForm1.sbtnPathSalvarClick(Sender: TObject);
begin
 PathClick(edtPathLogs);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 T : TSSLLib;
 I : TpcnTipoEmissao ;
 J : TpcnModeloDF;
 K : TpcnVersaoDF;
 C : TACBrTEFDTipo;
begin
  cbTipoEmissao.Items.Clear ;
  For T := Low(TSSLLib) to High(TSSLLib) do
    cbTipoEmissao.Items.Add( GetEnumName(TypeInfo(TSSLLib), integer(T) ) ) ;
  cbTipoEmissao.ItemIndex := 0 ;

  cbFormaEmissao.Items.Clear ;
  For I := Low(TpcnTipoEmissao) to High(TpcnTipoEmissao) do
     cbFormaEmissao.Items.Add( GetEnumName(TypeInfo(TpcnTipoEmissao), integer(I) ) ) ;
  cbFormaEmissao.Items[0] := 'teNormal' ;
  cbFormaEmissao.ItemIndex := 0 ;

  cbModeloDF.Items.Clear ;
  For J := Low(TpcnModeloDF) to High(TpcnModeloDF) do
     cbModeloDF.Items.Add( GetEnumName(TypeInfo(TpcnModeloDF), integer(J) ) ) ;
  cbModeloDF.Items[0] := 'moNFe' ;
  cbModeloDF.ItemIndex := 0 ;

  cbVersaoDF.Items.Clear ;
  For K := Low(TpcnVersaoDF) to High(TpcnVersaoDF) do
     cbVersaoDF.Items.Add( GetEnumName(TypeInfo(TpcnVersaoDF), integer(K) ) ) ;
  cbVersaoDF.Items[0] := 've200' ;
  cbVersaoDF.ItemIndex := 0 ;

  LerConfiguracao;
  PageControl3.ActivePage := tsNFe;
  pgRespostas.ActivePageIndex := 2;

  ACBrNFe1.Configuracoes.WebServices.Salvar := true;

  if cbTipoEmissao.ItemIndex <> -1 then
    ACBrNFe1.Configuracoes.Geral.SSLLib := TSSLLib(cbTipoEmissao.ItemIndex);

  cbxGP.Items.Clear ;
  For C := Low(TACBrTEFDTipo) to High(TACBrTEFDTipo) do
     cbxGP.Items.Add( GetEnumName(TypeInfo(TACBrTEFDTipo), integer(C) ) ) ;
  cbxGP.Items[0] := 'Todos' ;
  cbxGP.ItemIndex := 0 ;

  cbxGP1.Items.Assign(cbxGP.Items);
  cbxGP1.ItemIndex := 0 ;

  travarComponentesTEF(False);
end;


procedure TForm1.btnSalvarConfigClick(Sender: TObject);
begin
 GravarConfiguracao;
 LerConfiguracao;
end;

procedure TForm1.btnStatusServClick(Sender: TObject);
begin
 ACBrNFe1.WebServices.StatusServico.Executar;

 MemoResp.Lines.Text := ACBrNFe1.WebServices.StatusServico.RetWS;
 memoRespWS.Lines.Text := ACBrNFe1.WebServices.StatusServico.RetornoWS;
 LoadXML(ACBrNFe1.WebServices.StatusServico.RetornoWS, WBResposta);

 pgRespostas.ActivePageIndex := 1;

 MemoDados.Lines.Add('');
 MemoDados.Lines.Add('Status Servi�o');
 MemoDados.Lines.Add('tpAmb: '    +TpAmbToStr(ACBrNFe1.WebServices.StatusServico.tpAmb));
 MemoDados.Lines.Add('verAplic: ' +ACBrNFe1.WebServices.StatusServico.verAplic);
 MemoDados.Lines.Add('cStat: '    +IntToStr(ACBrNFe1.WebServices.StatusServico.cStat));
 MemoDados.Lines.Add('xMotivo: '  +ACBrNFe1.WebServices.StatusServico.xMotivo);
 MemoDados.Lines.Add('cUF: '      +IntToStr(ACBrNFe1.WebServices.StatusServico.cUF));
 MemoDados.Lines.Add('dhRecbto: ' +DateTimeToStr(ACBrNFe1.WebServices.StatusServico.dhRecbto));
 MemoDados.Lines.Add('tMed: '     +IntToStr(ACBrNFe1.WebServices.StatusServico.TMed));
 MemoDados.Lines.Add('dhRetorno: '+DateTimeToStr(ACBrNFe1.WebServices.StatusServico.dhRetorno));
 MemoDados.Lines.Add('xObs: '     +ACBrNFe1.WebServices.StatusServico.xObs);
end;

procedure TForm1.btnConsultarClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if OpenDialog1.Execute then
  begin
    ACBrNFe1.NotasFiscais.Clear;
    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
    ACBrNFe1.Consultar;
    ShowMessage(ACBrNFe1.WebServices.Consulta.Protocolo);
    MemoResp.Lines.Text := ACBrNFe1.WebServices.Consulta.RetWS;
    memoRespWS.Lines.Text := ACBrNFe1.WebServices.Consulta.RetornoWS;
    LoadXML(ACBrNFe1.WebServices.Consulta.RetornoWS, WBResposta);
    LoadConsulta201(ACBrNFe1.WebServices.Consulta.RetWS);
  end;
end;

procedure TForm1.btnCancNFClick(Sender: TObject);
var
  idLote,vAux : String;
begin
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if OpenDialog1.Execute then
  begin
    ACBrNFe1.NotasFiscais.Clear;
    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);

    idLote := '1';
    if not(InputQuery('WebServices Eventos: Cancelamento', 'Identificador de controle do Lote de envio do Evento', idLote)) then
       exit;
    if not(InputQuery('WebServices Eventos: Cancelamento', 'Justificativa', vAux)) then
       exit;
    ACBrNFe1.EventoNFe.Evento.Clear;
    ACBrNFe1.EventoNFe.idLote := StrToInt(idLote) ;
    with ACBrNFe1.EventoNFe.Evento.Add do
    begin
     infEvento.dhEvento := now;
     infEvento.tpEvento := teCancelamento;
     infEvento.detEvento.xJust := vAux;
    end;
    ACBrNFe1.EnviarEvento(StrToInt(idLote));

    MemoResp.Lines.Text := ACBrNFe1.WebServices.EnvEvento.RetWS;
    memoRespWS.Lines.Text := ACBrNFe1.WebServices.EnvEvento.RetornoWS;
    LoadXML(ACBrNFe1.WebServices.EnvEvento.RetornoWS, WBResposta);
    ShowMessage(IntToStr(ACBrNFe1.WebServices.EnvEvento.cStat));
    ShowMessage(ACBrNFe1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.nProt);
  end;
end;

procedure TForm1.btnValidarXMLClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
// Configuração padrão para exibição dos erros de validação
//  ACBrNFe1.Configuracoes.Geral.ExibirErroSchema := True;
//  ACBrNFe1.Configuracoes.Geral.FormatoAlerta := 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.';
// ACBrNFe1.Configuracoes.Geral.RetirarAcentos

// Sugest�o de configura��o para apresenta��o de mensagem mais amig�vel ao usu�rio final
  ACBrNFe1.Configuracoes.Geral.ExibirErroSchema := False;
  ACBrNFe1.Configuracoes.Geral.FormatoAlerta := 'Campo:%DESCRICAO% - %MSG%';

  if OpenDialog1.Execute then
   begin
     ACBrNFe1.NotasFiscais.Clear;
     ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName, True);
     try
        ACBrNFe1.NotasFiscais.Validar;
        if ACBrNFe1.NotasFiscais.Items[0].Alertas <> '' then
          MemoDados.Lines.Add('Alertas: '+ACBrNFe1.NotasFiscais.Items[0].Alertas);
        ShowMessage('Nota Fiscal Eletr�nica Valida');
     except
        on E: Exception do
        begin
          pgRespostas.ActivePage := Dados;
          MemoDados.Lines.Add('Exception: '+E.Message);
          MemoDados.Lines.Add('Erro: '+ACBrNFe1.NotasFiscais.Items[0].ErroValidacao);
          MemoDados.Lines.Add('Erro Completo: '+ACBrNFe1.NotasFiscais.Items[0].ErroValidacaoCompleto); //Útil para gravar em arquivos de LOG
        end;
     end;
   end;
end;

procedure TForm1.cbTipoEmissaoChange(Sender: TObject);
begin
  if cbTipoEmissao.ItemIndex <> -1 then
    ACBrNFe1.Configuracoes.Geral.SSLLib := TSSLLib(cbTipoEmissao.ItemIndex);

  Label44.Visible :=  ACBrNFe1.Configuracoes.Geral.SSLLib = libCapicom;
end;

procedure TForm1.cbxGPChange(Sender: TObject);
begin
  if not (Sender is TComboBox) then exit ;

  try
    ACBrTEFD1.GPAtual := TACBrTEFDTipo(  TComboBox(Sender).ItemIndex ) ;
  finally
    AvaliaTEFs;
  end;
end;

procedure TForm1.ckAutoAtivarClick(Sender: TObject);
begin
   ACBrTEFD1.AutoAtivarGP := ckAutoAtivar.Checked;
end;

procedure TForm1.ckAutoEfetuarPagamentoClick(Sender: TObject);
begin
  ACBrTEFD1.AutoEfetuarPagamento := ckAutoEfetuarPagamento.Checked;
end;

procedure TForm1.ckAutoFinalizarCupomClick(Sender: TObject);
begin
  ACBrTEFD1.AutoFinalizarCupom := ckAutoFinalizarCupom.Checked;
end;

procedure TForm1.ckMultiplosCartoesClick(Sender: TObject);
begin
  try
    ACBrTEFD1.MultiplosCartoes := TCheckBox(Sender).Checked ;
  finally
    ckMultiplosCartoes.Checked := ACBrTEFD1.MultiplosCartoes ;
  end;
end;

procedure TForm1.ConfigurarEmail;
begin
  ACBrMail1.Host := edtSmtpHost.Text;
  ACBrMail1.Port := edtSmtpPort.Text;
  ACBrMail1.Username := edtSmtpUser.Text;
  ACBrMail1.Password := edtSmtpPass.Text;
  ACBrMail1.From := edtSmtpUser.Text;
  ACBrMail1.SetSSL := cbEmailSSL.Checked; // SSL - Conexão Segura
  ACBrMail1.SetTLS := cbEmailSSL.Checked; // Auto TLS
  ACBrMail1.ReadingConfirmation := False; //Pede confirmação de leitura do email
  ACBrMail1.UseThread := False;           //Aguarda Envio do Email(não usa thread)
  ACBrMail1.FromName := 'Projeto ACBr - ACBrNFe';
end;

procedure TForm1.edEsperaSleepChange(Sender: TObject);
begin
   ACBrTEFD1.EsperaSleep := StrToInt(edEsperaSleep.Text);
end;

procedure TForm1.edEsperaSTSChange(Sender: TObject);
begin
   ACBrTEFD1.EsperaSTS := StrToInt(edEsperaSTS.Text);
end;

procedure TForm1.btnManifDestConfirmacaoClick(Sender: TObject);
var
 Chave, idLote, CNPJ: string;
 lMsg: string;
begin
  Chave:='';
  if not(InputQuery('WebServices Eventos: Manif. Destinatario - Conf. Operacao', 'Chave da NF-e', Chave)) then
     exit;
  Chave := Trim(OnlyNumber(Chave));
  idLote := '1';
  if not(InputQuery('WebServices Eventos: Manif. Destinatario - Conf. Operacao', 'Identificador de controle do Lote de envio do Evento', idLote)) then
     exit;
  CNPJ := '';
  if not(InputQuery('WebServices Eventos: Manif. Destinatario - Conf. Operacao', 'CNPJ ou o CPF do autor do Evento', CNPJ)) then
     exit;

  ACBrNFe1.EventoNFe.Evento.Clear;
  with ACBrNFe1.EventoNFe.Evento.Add do
   begin
     InfEvento.cOrgao   := 91;
     infEvento.chNFe    := Chave;
     infEvento.CNPJ     := CNPJ;
     infEvento.dhEvento := now;
     infEvento.tpEvento := teManifDestConfirmacao;
   end;
  ACBrNFe1.EnviarEvento(StrToInt(IDLote));

  with AcbrNFe1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento do
  begin
    lMsg:=
    'Id: '+Id+#13+
    'tpAmb: '+TpAmbToStr(tpAmb)+#13+
    'verAplic: '+verAplic+#13+
    'cOrgao: '+IntToStr(cOrgao)+#13+
    'cStat: '+IntToStr(cStat)+#13+
    'xMotivo: '+xMotivo+#13+
    'chNFe: '+chNFe+#13+
    'tpEvento: '+TpEventoToStr(tpEvento)+#13+
    'xEvento: '+xEvento+#13+
    'nSeqEvento: '+IntToStr(nSeqEvento)+#13+
    'CNPJDest: '+CNPJDest+#13+
    'emailDest: '+emailDest+#13+
    'dhRegEvento: '+DateTimeToStr(dhRegEvento)+#13+
    'nProt: '+nProt;
  end;
  ShowMessage(lMsg);

  MemoResp.Lines.Text := ACBrNFe1.WebServices.EnvEvento.RetWS;
  memoRespWS.Lines.Text := ACBrNFe1.WebServices.EnvEvento.RetornoWS;
//  ACBrNFe1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].XXXX
  LoadXML(ACBrNFe1.WebServices.EnvEvento.RetornoWS, WBResposta);
end;

procedure TForm1.btnNfeDestinadasClick(Sender: TObject);
//var
// CNPJ, IndNFe, IndEmi, ultNSU: string;
// ok: boolean;
begin
  ShowMessage('Desativado nesse exemplo.');
//  CNPJ := '';
//  if not(InputQuery('WebServices Consulta NFe Destinadas', 'CNPJ do destinat�rio da NFe', CNPJ)) then
//     exit;
//
//  (*veja NT 2012/002 p�g. 11 para identificar os valores poss�veis
//  Indicador de NF-e consultada:
//  0=Todas as NF-e;
//  1=Somente as NF-e que ainda n�o tiveram manifesta��o do destinat�rio
//    (Desconhecimento da opera��o, Opera��o n�o Realizada ou Confirma��o da Opera��o);
//  2=Idem anterior, incluindo as NF-e que tamb�m n�o tiveram a Ci�ncia da Opera��o.*)
//  indNFe := '0';
//  if not(InputQuery('WebServices Consulta NFe Destinadas', 'Indicador de NF-e consultada', indNFe)) then
//     exit;
//
//  (*veja NT 2012/002 p�g. 11 para identificar os valores poss�veis
//  Indicador do Emissor da NF-e:
//  0=Todos os Emitentes / Remetentes;
//  1=Somente as NF-e emitidas por emissores / remetentes que n�o tenham a mesma
//    raiz do CNPJ do destinat�rio (para excluir as notas fiscais de transfer�ncia
//    entre filiais).*)
//  IndEmi := '0';
//  if not(InputQuery('WebServices Consulta NFe Destinadas', 'Indicador do Emissor da NF-e', IndEmi)) then
//     exit;
//
//  (*veja NT 2012/002 p�g. 11 para identificar os valores poss�veis
//   �ltimo NSU recebido pela Empresa.
//   Caso seja informado com zero, ou com um NSU muito antigo, a consulta retornar�
//   unicamente as notas fiscais que tenham sido recepcionadas nos �ltimos 15 dias.*)
//  ultNSU := '0';
//  if not(InputQuery('WebServices Consulta NFe Destinadas', '�ltimo NSU recebido pela Empresa', ultNSU)) then
//     exit;
//
//  ACBrNFe1.ConsultaNFeDest(CNPJ,
//                           StrToIndicadorNFe(ok,indNFe),
//                           StrToIndicadorEmissor(ok,IndEmi),
//                           UltNSu);
//
//  //AcbrNFe1.WebServices.ConsNFeDest.retConsNFeDest
//
//
//
//  MemoResp.Lines.Text := ACBrNFe1.WebServices.ConsNFeDest.RetWS;
//  memoRespWS.Lines.Text := ACBrNFe1.WebServices.ConsNFeDest.RetornoWS;
////  ACBrNFe1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].XXXX
//  LoadXML(ACBrNFe1.WebServices.ConsNFeDest.RetornoWS, WBResposta);
//

end;

procedure TForm1.btnImprimirClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNFe1.NotasFiscais.Clear;
    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName,False);
    ACBrNFe1.NotasFiscais.Imprimir;
  end;
end;

procedure TForm1.btnCriarEnviarClick(Sender: TObject);
var
 vAux, vNumLote : String;
begin
  if not(InputQuery('WebServices Enviar', 'Numero da Nota', vAux)) then
    exit;

  if not(InputQuery('WebServices Enviar', 'Numero do Lote', vNumLote)) then
    exit;

  vNumLote := OnlyNumber(vNumLote);

  if Trim(vNumLote) = '' then
   begin
     MessageDlg('N�mero do Lote inv�lido.',mtError,[mbok],0);
     exit;
   end;

  ACBrNFe1.NotasFiscais.Clear;

  ACBrNFe1.Configuracoes.Geral.ModeloDF := moNFe;
  ACBrNFe1.Configuracoes.Geral.VersaoDF :=  TpcnVersaoDF(cbVersaoDF.ItemIndex);
  GerarNFe(vAux);

  ACBrNFe1.NotasFiscais.GerarNFe;

  ACBrNFe1.Enviar(vNumLote,True);

  MemoResp.Lines.Text := ACBrNFe1.WebServices.Retorno.RetWS;
  memoRespWS.Lines.Text := ACBrNFe1.WebServices.Retorno.RetornoWS;
  LoadXML(ACBrNFe1.WebServices.Retorno.RetornoWS, WBResposta);

  pgRespostas.ActivePageIndex := 1;

  MemoDados.Lines.Add('');
  MemoDados.Lines.Add('Envio NFe');
  MemoDados.Lines.Add('tpAmb: '+ TpAmbToStr(ACBrNFe1.WebServices.Retorno.TpAmb));
  MemoDados.Lines.Add('verAplic: '+ ACBrNFe1.WebServices.Retorno.verAplic);
  MemoDados.Lines.Add('cStat: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cStat));
  MemoDados.Lines.Add('cUF: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cUF));
  MemoDados.Lines.Add('xMotivo: '+ ACBrNFe1.WebServices.Retorno.xMotivo);
  MemoDados.Lines.Add('cMsg: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cMsg));
  MemoDados.Lines.Add('xMsg: '+ ACBrNFe1.WebServices.Retorno.xMsg);
  MemoDados.Lines.Add('Recibo: '+ ACBrNFe1.WebServices.Retorno.Recibo);
  MemoDados.Lines.Add('Protocolo: '+ ACBrNFe1.WebServices.Retorno.Protocolo);
// MemoDados.Lines.Add('cStat: '+ ACBrNFe1.WebServices.Retorno.NFeRetorno;

{ ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtNFe.Items[0].tpAmb
 ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtNFe.Items[0].verAplic
 ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtNFe.Items[0].chNFe
 ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtNFe.Items[0].dhRecbto
 ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtNFe.Items[0].nProt
 ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtNFe.Items[0].digVal
 ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtNFe.Items[0].cStat
 ACBrNFe1.WebServices.Retorno.NFeRetorno.ProtNFe.Items[0].xMotivo }

  ACBrNFe1.NotasFiscais.Clear;
end;

procedure TForm1.btnInutilizarClick(Sender: TObject);
var
 Modelo, Serie, Ano, NumeroInicial, NumeroFinal, Justificativa : String;
begin
 if not(InputQuery('WebServices Inutiliza��o ', 'Ano',    Ano)) then
    exit;
 if not(InputQuery('WebServices Inutiliza��o ', 'Modelo', Modelo)) then
    exit;
 if not(InputQuery('WebServices Inutiliza��o ', 'Serie',  Serie)) then
    exit;
 if not(InputQuery('WebServices Inutiliza��o ', 'N�mero Inicial', NumeroInicial)) then
    exit;
 if not(InputQuery('WebServices Inutiliza��o ', 'N�mero Inicial', NumeroFinal)) then
    exit;
 if not(InputQuery('WebServices Inutiliza��o ', 'Justificativa', Justificativa)) then
    exit;
  ACBrNFe1.WebServices.Inutiliza(edtEmitCNPJ.Text, Justificativa, StrToInt(Ano), StrToInt(Modelo), StrToInt(Serie), StrToInt(NumeroInicial), StrToInt(NumeroFinal));
  MemoResp.Lines.Text :=  ACBrNFe1.WebServices.Inutilizacao.RetWS;
  memoRespWS.Lines.Text :=  ACBrNFe1.WebServices.Inutilizacao.RetornoWS;
  LoadXML(ACBrNFe1.WebServices.Inutilizacao.RetornoWS, WBResposta);

  pgRespostas.ActivePageIndex := 1;

  MemoDados.Lines.Add('');
  MemoDados.Lines.Add('Inutiliza��o');
  MemoDados.Lines.Add('tpAmb: '    +TpAmbToStr(ACBrNFe1.WebServices.Inutilizacao.tpAmb));
  MemoDados.Lines.Add('verAplic: ' +ACBrNFe1.WebServices.Inutilizacao.verAplic);
  MemoDados.Lines.Add('cStat: '    +IntToStr(ACBrNFe1.WebServices.Inutilizacao.cStat));
  MemoDados.Lines.Add('xMotivo: '  +ACBrNFe1.WebServices.Inutilizacao.xMotivo);
  MemoDados.Lines.Add('cUF: '      +IntToStr(ACBrNFe1.WebServices.Inutilizacao.cUF));
  MemoDados.Lines.Add('Ano: '      +IntToStr(ACBrNFe1.WebServices.Inutilizacao.Ano));
  MemoDados.Lines.Add('CNPJ: '      +ACBrNFe1.WebServices.Inutilizacao.CNPJ);
  MemoDados.Lines.Add('Modelo: '      +IntToStr(ACBrNFe1.WebServices.Inutilizacao.Modelo));
  MemoDados.Lines.Add('Serie: '      +IntToStr(ACBrNFe1.WebServices.Inutilizacao.Serie));
  MemoDados.Lines.Add('NumeroInicial: '      +IntToStr(ACBrNFe1.WebServices.Inutilizacao.NumeroInicial));
  MemoDados.Lines.Add('NumeroInicial: '      +IntToStr(ACBrNFe1.WebServices.Inutilizacao.NumeroFinal));
  MemoDados.Lines.Add('dhRecbto: ' +DateTimeToStr(ACBrNFe1.WebServices.Inutilizacao.dhRecbto));
  MemoDados.Lines.Add('Protocolo: '      +ACBrNFe1.WebServices.Inutilizacao.Protocolo);

end;

procedure TForm1.btnInutilizarImprimirClick(Sender: TObject);
begin
//  OpenDialog1.Title := 'Selecione a NFE';
//  OpenDialog1.DefaultExt := '*.XML';
//  OpenDialog1.Filter := 'Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
//  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
//  if OpenDialog1.Execute then
//  begin
//    ACBrNFe1.NotasFiscais.Clear;
//    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
//  end;

  OpenDialog1.Title := 'Selecione o Inutiliza��o';
  OpenDialog1.DefaultExt := '*.XML';
  OpenDialog1.Filter := 'Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if OpenDialog1.Execute then
  begin
    ACBrNFe1.InutNFe.LerXML(OpenDialog1.FileName);
    ACBrNFe1.ImprimirInutilizacao;
  end;
end;

procedure TForm1.ACBrNFe1StatusChange(Sender: TObject);
begin
  case ACBrNFe1.Status of
    stIdle :
    begin
      if ( frmStatus <> nil ) then
        frmStatus.Hide;
    end;
    stNFeStatusServico :
    begin
      if ( frmStatus = nil ) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Verificando Status do servico...';
      frmStatus.Show;
      frmStatus.BringToFront;
    end;
    stNFeRecepcao :
    begin
      if ( frmStatus = nil ) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Enviando dados da NFe...';
      frmStatus.Show;
      frmStatus.BringToFront;
    end;
    stNfeRetRecepcao :
    begin
      if ( frmStatus = nil ) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Recebendo dados da NFe...';
      frmStatus.Show;
      frmStatus.BringToFront;
    end;
    stNfeConsulta :
    begin
      if ( frmStatus = nil ) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Consultando NFe...';
      frmStatus.Show;
      frmStatus.BringToFront;
    end;
    stNfeCancelamento :
    begin
      if ( frmStatus = nil ) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Enviando cancelamento de NFe...';
      frmStatus.Show;
      frmStatus.BringToFront;
    end;
    stNfeInutilizacao :
    begin
      if ( frmStatus = nil ) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Enviando pedido de Inutiliza��o...';
      frmStatus.Show;
      frmStatus.BringToFront;
    end;
    stNFeRecibo :
    begin
      if ( frmStatus = nil ) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Consultando Recibo de Lote...';
      frmStatus.Show;
      frmStatus.BringToFront;
    end;
    stNFeCadastro :
    begin
      if ( frmStatus = nil ) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Consultando Cadastro...';
      frmStatus.Show;
      frmStatus.BringToFront;
    end;
    stNFeEmail :
    begin
      if ( frmStatus = nil ) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Enviando Email...';
      frmStatus.Show;
      frmStatus.BringToFront;
    end;
    stNFeCCe :
    begin
      if ( frmStatus = nil ) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Enviando Carta de Corre��o...';
      frmStatus.Show;
      frmStatus.BringToFront;
    end;
    stNFeEvento :
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

procedure TForm1.ACBrTEFD1CliSiTefExibeMenu(Titulo: string; Opcoes: TStringList; var ItemSelecionado: Integer; var VoltarMenu: Boolean);
Var
  AForm : TForm4 ;
  MR    : TModalResult ;
begin
  AForm := TForm4.Create(self);
  try
    AForm.Panel1.Caption := Titulo;
    AForm.ListBox1.Items.AddStrings(Opcoes);

    MR := AForm.ShowModal ;

    VoltarMenu := (MR = mrRetry) ;

    if (MR = mrOK) then
      ItemSelecionado := AForm.ListBox1.ItemIndex;
  finally
    AForm.Free;
  end;
end;

procedure TForm1.ACBrTEFD1CliSiTefObtemCampo(Titulo: string; TamanhoMinimo,
    TamanhoMaximo, TipoCampo: Integer; Operacao:
    TACBrTEFDCliSiTefOperacaoCampo; var Resposta: AnsiString; var Digitado,
    VoltarMenu: Boolean);
Var
  AForm : TForm5 ;
  MR    : TModalResult ;
begin
  AForm := TForm5.Create(self);
  try
    AForm.Panel1.Caption := Titulo;
    AForm.TamanhoMaximo  := TamanhoMaximo;
    AForm.TamanhoMinimo  := TamanhoMinimo;
    AForm.Operacao       := Operacao;
    AForm.TipoCampo      := TipoCampo;
    AForm.Edit1.Text     := Resposta; { Para usar Valores Previamente informados }

    MR := AForm.ShowModal ;

    Digitado   := (MR = mrOK) ;
    VoltarMenu := (MR = mrRetry) ;

    if Digitado then
       Resposta := AForm.Edit1.Text;
  finally
    AForm.Free;
  end;
end;

procedure TForm1.ACBrTEFD1ComandaECF(Operacao: TACBrTEFDOperacaoECF; Resp: TACBrTEFDResp; var RetornoECF: Integer);
begin
  try
    case Operacao of
      opeAbreGerencial :
         MemoCupomTEF.Lines.Add('Abre Gerencial') {ACBrECF1.AbreRelatorioGerencial} ;

      opeFechaCupom :
         estadoSimuladoEcf := tpsLivre;

      opeSubTotalizaCupom :
         MemoCupomTEF.Lines.Add('Sub Totaliza');

      opeFechaGerencial, opeFechaVinculado :
         estadoSimuladoEcf := tpsRelatorio;

      opePulaLinhas :
        begin
          MemoCupomTEF.Lines.Add('PulaLinhas');
          Sleep(200);
        end;

      opeImprimePagamentos :
        begin
          MemoCupomTEF.Lines.Add('ImprimePagamentos');
        end;
    end;
    RetornoECF := 1 ;
  except
    RetornoECF := 0 ;
  end;
end;

procedure TForm1.ACBrTEFD1ComandaECFAbreVinculado(COO, IndiceECF: string; Valor: Double; var RetornoECF: Integer);
begin
  try
     RetornoECF := 1 ;
  except
     RetornoECF := 0 ;
  end;
end;

procedure TForm1.ACBrTEFD1ComandaECFImprimeVia(TipoRelatorio: TACBrTEFDTipoRelatorio; Via: Integer; ImagemComprovante: TStringList; var RetornoECF: Integer);
begin
  try
     case TipoRelatorio of
       trGerencial :
         MemoCupomTEF.Lines.Add('GERENCIAL:' + ImagemComprovante.Text);
       trVinculado :
         MemoCupomTEF.Lines.Add('VINCULADO:' + ImagemComprovante.Text);
     end;

     RetornoECF := 1 ;
  except
     RetornoECF := 0 ;
  end;
end;

procedure TForm1.ACBrTEFD1ComandaECFSubtotaliza(DescAcre: Double; var RetornoECF: Integer);
begin
  estadoSimuladoEcf := tpsPagamento;
  RetornoECF := 1 ;
end;

procedure TForm1.ACBrTEFD1ExibeMsg(Operacao: TACBrTEFDOperacaoMensagem; Mensagem: string; var AModalResult: TModalResult);
var
   Fim : TDateTime;
   OldMensagem : String;
begin
  StatusBar1.Panels[1].Text := '' ;
  StatusBar1.Panels[2].Text := '' ;

  case Operacao of

    opmOK :
       AModalResult := MessageDlg( Mensagem, mtInformation, [mbOK], 0);

    opmYesNo :
       AModalResult := MessageDlg( Mensagem, mtConfirmation, [mbYes,mbNo], 0);

    opmExibirMsgOperador, opmRemoverMsgOperador :
         lMensagemOperador.Caption := Mensagem ;

    opmExibirMsgCliente, opmRemoverMsgCliente :
         lMensagemCliente.Caption := Mensagem ;

    opmDestaqueVia :
       begin
         OldMensagem := lMensagemOperador.Caption ;
         try
            lMensagemOperador.Caption := Mensagem ;
            pMensagemOperador.Visible := True ;
            pMensagem.Visible         := True ;

            { Aguardando 3 segundos }
            Fim := IncSecond( now, 3)  ;
            repeat
               sleep(200) ;
               lMensagemOperador.Caption := Mensagem + ' ' + IntToStr(SecondsBetween(Fim,now));
               Application.ProcessMessages;
            until (now > Fim) ;

         finally
            lMensagemOperador.Caption := OldMensagem ;
         end;
       end;
  end;

  pMensagemOperador.Visible := (lMensagemOperador.Caption <> '') ;
  pMensagemCliente.Visible  := (lMensagemCliente.Caption <> '') ;

  pMensagem.Visible := pMensagemOperador.Visible or pMensagemCliente.Visible;
  Application.ProcessMessages;
end;

procedure TForm1.ACBrTEFD1InfoECF(Operacao: TACBrTEFDInfoECF; var RetornoECF: string);
var
   ASubTotal: Double;
begin
   case Operacao of
     ineSubTotal :
       begin
         ASubTotal := StringToFloatDef(edValorVenda.Text, 0);
         //ASubTotal := ASubTotal - StringToFloatDef(EditTotalPago.Text, 0){ + Tratar Desconto e Acrescimo aqui: StringToFloatDef(edValorDescAcre.Text, 0)};
         RetornoECF := FloatToStr(ASubTotal);
         if estadoSimuladoEcf = tpsPagamento then
           RetornoECF := FloatToStr(0);
       end;

     ineTotalAPagar :
       RetornoECF := '0';

     ineEstadoECF :
       begin
         Case estadoSimuladoEcf of
           tpsLivre     : RetornoECF := 'L' ;
           tpsVenda     : RetornoECF := 'V' ;
           tpsPagamento : RetornoECF := 'P' ;
           tpsRelatorio : RetornoECF := 'R' ;
         else
           RetornoECF := 'O' ;
         end;
       end;
   end;
end;

procedure TForm1.sbtnGetCertClick(Sender: TObject);
begin
  edtNumSerie.Text := ACBrNFe1.SSL.SelecionarCertificado;
end;

procedure TForm1.btnGerarNFEClick(Sender: TObject);
var
 vAux : String;
begin
if not(InputQuery('WebServices Enviar', 'Numero da Nota', vAux)) then
    exit;

  ACBrNFe1.NotasFiscais.Clear;

  GerarNFe(vAux);

  ACBrNFe1.NotasFiscais.Assinar;

  ACBrNFe1.NotasFiscais.Items[0].GravarXML();
  ShowMessage('Arquivo gerado em: '+ACBrNFe1.NotasFiscais.Items[0].NomeArq);
  MemoDados.Lines.Add('Arquivo gerado em: '+ACBrNFe1.NotasFiscais.Items[0].NomeArq);
  MemoResp.Lines.LoadFromFile(ACBrNFe1.NotasFiscais.Items[0].NomeArq);
  LoadXML(MemoResp.Text, WBResposta);
  pgRespostas.ActivePageIndex := 1;
end;

procedure TForm1.btnConsCadClick(Sender: TObject);
var
 UF, Documento : String;
begin
 if not(InputQuery('WebServices Consulta Cadastro ', 'UF do Documento a ser Consultado:',    UF)) then
    exit;
 if not(InputQuery('WebServices Consulta Cadastro ', 'Documento(CPF/CNPJ)',    Documento)) then
    exit;
  Documento :=  Trim(OnlyNumber(Documento));

  ACBrNFe1.WebServices.ConsultaCadastro.UF  := UF;
  if Length(Documento) > 11 then
     ACBrNFe1.WebServices.ConsultaCadastro.CNPJ := Documento
  else
     ACBrNFe1.WebServices.ConsultaCadastro.CPF := Documento;
  ACBrNFe1.WebServices.ConsultaCadastro.Executar;

  MemoResp.Lines.Text := ACBrNFe1.WebServices.ConsultaCadastro.RetWS;
  memoRespWS.Lines.Text := ACBrNFe1.WebServices.ConsultaCadastro.RetornoWS;
  LoadXML(ACBrNFe1.WebServices.ConsultaCadastro.RetornoWS, WBResposta);

  pgRespostas.ActivePageIndex := 1;

  MemoDados.Lines.Add('');
  MemoDados.Lines.Add('Consulta Cadastro');
 MemoDados.Lines.Add('versao: ' +ACBrNFe1.WebServices.ConsultaCadastro.versao);
  MemoDados.Lines.Add('verAplic: ' +ACBrNFe1.WebServices.ConsultaCadastro.verAplic);
  MemoDados.Lines.Add('cStat: '    +IntToStr(ACBrNFe1.WebServices.ConsultaCadastro.cStat));
  MemoDados.Lines.Add('xMotivo: '  +ACBrNFe1.WebServices.ConsultaCadastro.xMotivo);
  MemoDados.Lines.Add('DhCons: ' +DateTimeToStr(ACBrNFe1.WebServices.ConsultaCadastro.DhCons));

end;

procedure TForm1.btnGerarPDFClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  ACBrNFe1.NotasFiscais.Clear;
  if OpenDialog1.Execute then
    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);

  ACBrNFe1.NotasFiscais.ImprimirPDF;
end;

procedure TForm1.btnGerarTXTClick(Sender: TObject);
var
   vAux, vNumLote : String;
begin
  if not(InputQuery('WebServices Enviar', 'Numero da Nota', vAux)) then
    exit;

  if not(InputQuery('WebServices Enviar', 'Numero do Lote', vNumLote)) then
    exit;

  vNumLote := OnlyNumber(vNumLote);

  if Trim(vNumLote) = '' then
   begin
     MessageDlg('N�mero do Lote inv�lido.',mtError,[mbok],0);
     exit;
   end;

  ACBrNFe1.NotasFiscais.Clear;

  GerarNFe(vAux);

  ACBrNFe1.NotasFiscais.GravarTXT({caminho e nome do arquivo TXT});
end;

procedure TForm1.btnEnviarEmailClick(Sender: TObject);
var
 Para : String;
 CC: Tstrings;
begin
  if not(InputQuery('Enviar Email', 'Email de destino', Para)) then
    exit;

  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;

  if not OpenDialog1.Execute then
    Exit;

  ACBrNFe1.NotasFiscais.Clear;
  ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
  CC:=TstringList.Create;
  try
    //CC.Add('email_1@provedor.com'); //especifique um email v�lido
    //CC.Add('email_2@provedor.com.br');    //especifique um email v�lido
    ConfigurarEmail;
    ACBrNFe1.NotasFiscais.Items[0].EnviarEmail(Para
      , edtEmailAssunto.Text
      , mmEmailMsg.Lines
      , True  // Enviar PDF junto
      , CC    // Lista com emails que serão enviado cópias - TStrings
      , nil // Lista de anexos - TStrings
      );
  finally
    CC.Free;
  end;
end;

procedure TForm1.btnConsultarReciboClick(Sender: TObject);
var
  aux : String;
begin
  if not(InputQuery('Consultar Recibo Lote', 'N�mero do Recibo', aux)) then
    exit;
  ACBrNFe1.WebServices.Recibo.Recibo := aux;;
  ACBrNFe1.WebServices.Recibo.Executar;

  MemoResp.Lines.Text := ACBrNFe1.WebServices.Recibo.RetWS;
  memoRespWS.Lines.Text := ACBrNFe1.WebServices.Recibo.RetornoWS;
  LoadXML(ACBrNFe1.WebServices.Recibo.RetornoWS, WBResposta);

  pgRespostas.ActivePageIndex := 1;

  MemoDados.Lines.Add('');
  MemoDados.Lines.Add('Consultar Recibo');
  MemoDados.Lines.Add('tpAmb: '    +TpAmbToStr(ACBrNFe1.WebServices.Recibo.tpAmb));
  MemoDados.Lines.Add('versao: ' +ACBrNFe1.WebServices.Recibo.versao);
  MemoDados.Lines.Add('verAplic: ' +ACBrNFe1.WebServices.Recibo.verAplic);
  MemoDados.Lines.Add('cStat: '    +IntToStr(ACBrNFe1.WebServices.Recibo.cStat));
  MemoDados.Lines.Add('xMotivo: '  +ACBrNFe1.WebServices.Recibo.xMotivo);
  MemoDados.Lines.Add('cUF: '    +IntToStr(ACBrNFe1.WebServices.Recibo.cUF));
  MemoDados.Lines.Add('xMsg: ' +ACBrNFe1.WebServices.Recibo.xMsg);
  MemoDados.Lines.Add('cMsg: '    +IntToStr(ACBrNFe1.WebServices.Recibo.cMsg));
  MemoDados.Lines.Add('Recibo: ' +ACBrNFe1.WebServices.Recibo.Recibo);
end;

procedure TForm1.ACBrNFe1GerarLog(const Mensagem: String);
begin
 memoLog.Lines.Add(Mensagem);
end;

procedure TForm1.btnImportarXMLClick(Sender: TObject);
var
  i, j, k, n  : integer;
  Nota, Node, NodePai, NodeItem: TTreeNode;
  NFeRTXT: TNFeRTXT;
begin
  OpenDialog1.FileName  :=  '';
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Arquivos TXT (*.TXT)|*.TXT|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if OpenDialog1.Execute then
  begin
    ACBrNFe1.NotasFiscais.Clear;
    //tenta TXT
    ACBrNFe1.NotasFiscais.Add;
    NFeRTXT := TNFeRTXT.Create(ACBrNFe1.NotasFiscais.Items[0].NFe);
    NFeRTXT.CarregarArquivo(OpenDialog1.FileName);
    if NFeRTXT.LerTxt then
       NFeRTXT.Free
    else
    begin
       NFeRTXT.Free;
       //tenta XML
       ACBrNFe1.NotasFiscais.Clear;
       try
          ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
       except
          ShowMessage('Arquivo NFe Inv�lido');
          exit;
       end;
    end;

    trvwNFe.Items.Clear;

    for n:=0 to ACBrNFe1.NotasFiscais.Count-1 do
    begin
    with ACBrNFe1.NotasFiscais.Items[n].NFe do
     begin

       Nota := trvwNFe.Items.Add(nil,infNFe.ID);
       trvwNFe.Items.AddChild(Nota,'ID= ' +infNFe.ID);
       Node := trvwNFe.Items.AddChild(Nota,'procNFe');
       trvwNFe.Items.AddChild(Node,'tpAmb= '     +TpAmbToStr(procNFe.tpAmb));
       trvwNFe.Items.AddChild(Node,'verAplic= '  +procNFe.verAplic);
       trvwNFe.Items.AddChild(Node,'chNFe= '     +procNFe.chNFe);
       trvwNFe.Items.AddChild(Node,'dhRecbto= '  +DateTimeToStr(procNFe.dhRecbto));
       trvwNFe.Items.AddChild(Node,'nProt= '     +procNFe.nProt);
       trvwNFe.Items.AddChild(Node,'digVal= '    +procNFe.digVal);
       trvwNFe.Items.AddChild(Node,'cStat= '     +IntToStr(procNFe.cStat));
       trvwNFe.Items.AddChild(Node,'xMotivo= '   +procNFe.xMotivo);

       Node := trvwNFe.Items.AddChild(Nota,'Ide');
       trvwNFe.Items.AddChild(Node,'cNF= '     +IntToStr(Ide.cNF));
       trvwNFe.Items.AddChild(Node,'natOp= '   +Ide.natOp );
       trvwNFe.Items.AddChild(Node,'indPag= '  +IndpagToStr(Ide.indPag));
       trvwNFe.Items.AddChild(Node,'modelo= '  +IntToStr(Ide.modelo));
       trvwNFe.Items.AddChild(Node,'serie= '   +IntToStr(Ide.serie));
       trvwNFe.Items.AddChild(Node,'nNF= '     +IntToStr(Ide.nNF));
       trvwNFe.Items.AddChild(Node,'dEmi= '    +DateToStr(Ide.dEmi));
       trvwNFe.Items.AddChild(Node,'dSaiEnt= ' +DateToStr(Ide.dSaiEnt));
       trvwNFe.Items.AddChild(Node,'hSaiEnt= ' +DateToStr(Ide.hSaiEnt));
       trvwNFe.Items.AddChild(Node,'tpNF= '    +tpNFToStr(Ide.tpNF));
       trvwNFe.Items.AddChild(Node,'finNFe= '  +FinNFeToStr(Ide.finNFe));
       trvwNFe.Items.AddChild(Node,'verProc= ' +Ide.verProc);
       trvwNFe.Items.AddChild(Node,'cUF= '     +IntToStr(Ide.cUF));
       trvwNFe.Items.AddChild(Node,'cMunFG= '  +IntToStr(Ide.cMunFG));
       trvwNFe.Items.AddChild(Node,'tpImp= '   +TpImpToStr(Ide.tpImp));
       trvwNFe.Items.AddChild(Node,'tpEmis= '  +TpEmisToStr(Ide.tpEmis));
       trvwNFe.Items.AddChild(Node,'cDV= '     +IntToStr(Ide.cDV));
       trvwNFe.Items.AddChild(Node,'tpAmb= '   +TpAmbToStr(Ide.tpAmb));
       trvwNFe.Items.AddChild(Node,'finNFe= '  +FinNFeToStr(Ide.finNFe));
       trvwNFe.Items.AddChild(Node,'procEmi= ' +procEmiToStr(Ide.procEmi));
       trvwNFe.Items.AddChild(Node,'verProc= ' +Ide.verProc);
       trvwNFe.Items.AddChild(Node,'dhCont= '  +DateTimeToStr(Ide.dhCont));
       trvwNFe.Items.AddChild(Node,'xJust= '   +Ide.xJust);

       for i:=0 to Ide.NFref.Count-1 do
        begin
          if Ide.NFref.Items[i].refNFe <> '' then
          begin
            Node := trvwNFe.Items.AddChild(Node,'NFRef'+IntToStrZero(i+1,3));
            trvwNFe.Items.AddChild(Node,'refNFe= ' +Ide.NFref.Items[i].refNFe);
            trvwNFe.Items.AddChild(Node,'cUF= '    +IntToStr(Ide.NFref.Items[i].RefNF.cUF));
            trvwNFe.Items.AddChild(Node,'AAMM= '   +Ide.NFref.Items[i].RefNF.AAMM);
            trvwNFe.Items.AddChild(Node,'CNPJ= '   +Ide.NFref.Items[i].RefNF.CNPJ);
            trvwNFe.Items.AddChild(Node,'modelo= ' +IntToStr(Ide.NFref.Items[i].RefNF.modelo));
            trvwNFe.Items.AddChild(Node,'serie= '  +IntToStr(Ide.NFref.Items[i].RefNF.serie));
            trvwNFe.Items.AddChild(Node,'nNF= '    +IntToStr(Ide.NFref.Items[i].RefNF.nNF));
          end;

          if Ide.NFref.Items[i].RefECF.nCOO <> '' then
          begin
            Node := trvwNFe.Items.AddChild(Node,'refECF'+IntToStrZero(i+1,3));
            trvwNFe.Items.AddChild(Node,'mod= '  +ECFModRefToStr(Ide.NFref.Items[i].RefECF.modelo));
            trvwNFe.Items.AddChild(Node,'nECF= ' +Ide.NFref.Items[i].RefECF.nECF);
            trvwNFe.Items.AddChild(Node,'nCOO= ' +Ide.NFref.Items[i].RefECF.nCOO);
          end;
        end;

       Node := trvwNFe.Items.AddChild(Nota,'Emit');
       trvwNFe.Items.AddChild(Node,'CNPJCPF= ' +Emit.CNPJCPF);
       trvwNFe.Items.AddChild(Node,'IE='       +Emit.IE);
       trvwNFe.Items.AddChild(Node,'xNome='    +Emit.xNome);
       trvwNFe.Items.AddChild(Node,'xFant='    +Emit.xFant );
       trvwNFe.Items.AddChild(Node,'IEST='     +Emit.IEST);
       trvwNFe.Items.AddChild(Node,'IM='       +Emit.IM);
       trvwNFe.Items.AddChild(Node,'CNAE='     +Emit.CNAE);
       trvwNFe.Items.AddChild(Node,'CRT='      +CRTToStr(Emit.CRT));

       Node := trvwNFe.Items.AddChild(Node,'EnderEmit');
       trvwNFe.Items.AddChild(Node,'Fone='    +Emit.EnderEmit.fone);
       trvwNFe.Items.AddChild(Node,'CEP='     +IntToStr(Emit.EnderEmit.CEP));
       trvwNFe.Items.AddChild(Node,'xLgr='    +Emit.EnderEmit.xLgr);
       trvwNFe.Items.AddChild(Node,'nro='     +Emit.EnderEmit.nro);
       trvwNFe.Items.AddChild(Node,'xCpl='    +Emit.EnderEmit.xCpl);
       trvwNFe.Items.AddChild(Node,'xBairro=' +Emit.EnderEmit.xBairro);
       trvwNFe.Items.AddChild(Node,'cMun='    +IntToStr(Emit.EnderEmit.cMun));
       trvwNFe.Items.AddChild(Node,'xMun='    +Emit.EnderEmit.xMun);
       trvwNFe.Items.AddChild(Node,'UF'       +Emit.EnderEmit.UF);
       trvwNFe.Items.AddChild(Node,'cPais='   +IntToStr(Emit.EnderEmit.cPais));
       trvwNFe.Items.AddChild(Node,'xPais='   +Emit.EnderEmit.xPais);

       if Avulsa.CNPJ  <> '' then
        begin
          Node := trvwNFe.Items.AddChild(Nota,'Avulsa');
          trvwNFe.Items.AddChild(Node,'CNPJ='    +Avulsa.CNPJ);
          trvwNFe.Items.AddChild(Node,'xOrgao='  +Avulsa.xOrgao);
          trvwNFe.Items.AddChild(Node,'matr='    +Avulsa.matr );
          trvwNFe.Items.AddChild(Node,'xAgente=' +Avulsa.xAgente);
          trvwNFe.Items.AddChild(Node,'fone='    +Avulsa.fone);
          trvwNFe.Items.AddChild(Node,'UF='      +Avulsa.UF);
          trvwNFe.Items.AddChild(Node,'nDAR='    +Avulsa.nDAR);
          trvwNFe.Items.AddChild(Node,'dEmi='    +DateToStr(Avulsa.dEmi));
          trvwNFe.Items.AddChild(Node,'vDAR='    +FloatToStr(Avulsa.vDAR));
          trvwNFe.Items.AddChild(Node,'repEmi='  +Avulsa.repEmi);
          trvwNFe.Items.AddChild(Node,'dPag='    +DateToStr(Avulsa.dPag));
        end;
       Node := trvwNFe.Items.AddChild(Nota,'Dest');
       trvwNFe.Items.AddChild(Node,'CNPJCPF= ' +Dest.CNPJCPF);
       trvwNFe.Items.AddChild(Node,'IE='       +Dest.IE);
       trvwNFe.Items.AddChild(Node,'ISUF='     +Dest.ISUF);
       trvwNFe.Items.AddChild(Node,'xNome='    +Dest.xNome);
       trvwNFe.Items.AddChild(Node,'email='    +Dest.Email);

       Node := trvwNFe.Items.AddChild(Node,'EnderDest');
       trvwNFe.Items.AddChild(Node,'Fone='    +Dest.EnderDest.Fone);
       trvwNFe.Items.AddChild(Node,'CEP='     +IntToStr(Dest.EnderDest.CEP));
       trvwNFe.Items.AddChild(Node,'xLgr='    +Dest.EnderDest.xLgr);
       trvwNFe.Items.AddChild(Node,'nro='     +Dest.EnderDest.nro);
       trvwNFe.Items.AddChild(Node,'xCpl='    +Dest.EnderDest.xCpl);
       trvwNFe.Items.AddChild(Node,'xBairro=' +Dest.EnderDest.xBairro);
       trvwNFe.Items.AddChild(Node,'cMun='    +IntToStr(Dest.EnderDest.cMun));
       trvwNFe.Items.AddChild(Node,'xMun='    +Dest.EnderDest.xMun);
       trvwNFe.Items.AddChild(Node,'UF='      +Dest.EnderDest.UF );
       trvwNFe.Items.AddChild(Node,'cPais='   +IntToStr(Dest.EnderDest.cPais));
       trvwNFe.Items.AddChild(Node,'xPais='   +Dest.EnderDest.xPais);

       {if Retirada.CNPJ <> '' then
        begin
          Node := trvwNFe.Items.AddChild(Nota,'Retirada');
          trvwNFe.Items.AddChild(Node,'CNPJ='    +Retirada.CNPJ);
          trvwNFe.Items.AddChild(Node,'xLgr='    +Retirada.xLgr);
          trvwNFe.Items.AddChild(Node,'nro='     +Retirada.nro);
          trvwNFe.Items.AddChild(Node,'xCpl='    +Retirada.xCpl);
          trvwNFe.Items.AddChild(Node,'xBairro=' +Retirada.xBairro);
          trvwNFe.Items.AddChild(Node,'cMun='    +IntToStr(Retirada.cMun));
          trvwNFe.Items.AddChild(Node,'xMun='    +Retirada.xMun);
          trvwNFe.Items.AddChild(Node,'UF='      +Retirada.UF);
        end;

       if Entrega.CNPJ <> '' then
        begin
          Node := trvwNFe.Items.AddChild(Nota,'Entrega');
          trvwNFe.Items.AddChild(Node,'CNPJ='    +Entrega.CNPJ);
          trvwNFe.Items.AddChild(Node,'xLgr='    +Entrega.xLgr);
          trvwNFe.Items.AddChild(Node,'nro='     +Entrega.nro);
          trvwNFe.Items.AddChild(Node,'xCpl='    +Entrega.xCpl);
          trvwNFe.Items.AddChild(Node,'xBairro=' +Entrega.xBairro);
          trvwNFe.Items.AddChild(Node,'cMun='    +IntToStr(Entrega.cMun));
          trvwNFe.Items.AddChild(Node,'xMun='    +Entrega.xMun);
          trvwNFe.Items.AddChild(Node,'UF='      +Entrega.UF);
        end;}

       for I := 0 to Det.Count-1 do
        begin
          with Det.Items[I] do
           begin
               NodeItem := trvwNFe.Items.AddChild(Nota,'Produto'+IntToStrZero(I+1,3));
               trvwNFe.Items.AddChild(NodeItem,'nItem='  +IntToStr(Prod.nItem) );
               trvwNFe.Items.AddChild(NodeItem,'cProd='  +Prod.cProd );
               trvwNFe.Items.AddChild(NodeItem,'cEAN='   +Prod.cEAN);
               trvwNFe.Items.AddChild(NodeItem,'xProd='  +Prod.xProd);
               trvwNFe.Items.AddChild(NodeItem,'NCM='    +Prod.NCM);
               trvwNFe.Items.AddChild(NodeItem,'EXTIPI=' +Prod.EXTIPI);
               //trvwNFe.Items.AddChild(NodeItem,'genero=' +IntToStr(Prod.genero));
               trvwNFe.Items.AddChild(NodeItem,'CFOP='   +Prod.CFOP);
               trvwNFe.Items.AddChild(NodeItem,'uCom='   +Prod.uCom);
               trvwNFe.Items.AddChild(NodeItem,'qCom='   +FloatToStr(Prod.qCom)) ;
               trvwNFe.Items.AddChild(NodeItem,'vUnCom=' +FloatToStr(Prod.vUnCom)) ;
               trvwNFe.Items.AddChild(NodeItem,'vProd='  +FloatToStr(Prod.vProd)) ;

               trvwNFe.Items.AddChild(NodeItem,'cEANTrib=' +Prod.cEANTrib);
               trvwNFe.Items.AddChild(NodeItem,'uTrib='    +Prod.uTrib);
               trvwNFe.Items.AddChild(NodeItem,'qTrib='    +FloatToStr(Prod.qTrib));
               trvwNFe.Items.AddChild(NodeItem,'vUnTrib='  +FloatToStr(Prod.vUnTrib)) ;

               trvwNFe.Items.AddChild(NodeItem,'vFrete='      +FloatToStr(Prod.vFrete)) ;
               trvwNFe.Items.AddChild(NodeItem,'vSeg='        +FloatToStr(Prod.vSeg)) ;
               trvwNFe.Items.AddChild(NodeItem,'vDesc='       +FloatToStr(Prod.vDesc)) ;
               trvwNFe.Items.AddChild(NodeItem,'vOutro='      +FloatToStr(Prod.vOutro)) ;
               trvwNFe.Items.AddChild(NodeItem,'indTot='      +indTotToStr(Prod.IndTot)) ;
               trvwNFe.Items.AddChild(NodeItem,'xPed='        +Prod.xPed) ;
               trvwNFe.Items.AddChild(NodeItem,'nItemPedido=' +Prod.nItemPed) ;

               trvwNFe.Items.AddChild(NodeItem,'infAdProd=' +infAdProd);

               for J:=0 to Prod.DI.Count-1 do
                begin
                  if Prod.DI.Items[j].nDi <> '' then
                   begin
                     with Prod.DI.Items[j] do
                      begin
                        NodePai := trvwNFe.Items.AddChild(NodeItem,'DI'+IntToStrZero(J+1,3));
                        trvwNFe.Items.AddChild(NodePai,'nDi='         +nDi);
                        trvwNFe.Items.AddChild(NodePai,'dDi='         +DateToStr(dDi));
                        trvwNFe.Items.AddChild(NodePai,'xLocDesemb='  +xLocDesemb);
                        trvwNFe.Items.AddChild(NodePai,'UFDesemb='    +UFDesemb);
                        trvwNFe.Items.AddChild(NodePai,'dDesemb='     +DateToStr(dDesemb));
                        trvwNFe.Items.AddChild(NodePai,'cExportador=' +cExportador);;

                        for K:=0 to adi.Count-1 do
                         begin
                           with adi.Items[K] do
                            begin
                              Node := trvwNFe.Items.AddChild(NodePai,'LADI'+IntToStrZero(K+1,3));
                              trvwNFe.Items.AddChild(Node,'nAdicao='     +IntToStr(nAdicao)) ;
                              trvwNFe.Items.AddChild(Node,'nSeqAdi='     +IntToStr(nSeqAdi)) ;
                              trvwNFe.Items.AddChild(Node,'cFabricante=' +cFabricante);
                              trvwNFe.Items.AddChild(Node,'vDescDI='     +FloatToStr(vDescDI));
                            end;
                         end;
                      end;
                   end
                  else
                    Break;
                end;

              if Prod.veicProd.chassi <> '' then
               begin
                 Node := trvwNFe.Items.AddChild(NodeItem,'Veiculo');
                 with Prod.veicProd do
                  begin
                    trvwNFe.Items.AddChild(Node,'tpOP='     +tpOPToStr(tpOP));
                    trvwNFe.Items.AddChild(Node,'chassi='   +chassi) ;
                    trvwNFe.Items.AddChild(Node,'cCor='     +cCor);
                    trvwNFe.Items.AddChild(Node,'xCor='     +xCor);
                    trvwNFe.Items.AddChild(Node,'pot='      +pot);
                    trvwNFe.Items.AddChild(Node,'Cilin='      +Cilin);
                    trvwNFe.Items.AddChild(Node,'pesoL='    +pesoL);
                    trvwNFe.Items.AddChild(Node,'pesoB='    +pesoB);
                    trvwNFe.Items.AddChild(Node,'nSerie='   +nSerie);
                    trvwNFe.Items.AddChild(Node,'tpComb='   +tpComb);
                    trvwNFe.Items.AddChild(Node,'nMotor='   +nMotor);
                    trvwNFe.Items.AddChild(Node,'CMT='     +CMT);
                    trvwNFe.Items.AddChild(Node,'dist='     +dist);
                    //trvwNFe.Items.AddChild(Node,'RENAVAM='  +RENAVAM);
                    trvwNFe.Items.AddChild(Node,'anoMod='   +IntToStr(anoMod));
                    trvwNFe.Items.AddChild(Node,'anoFab='   +IntToStr(anoFab));
                    trvwNFe.Items.AddChild(Node,'tpPint='   +tpPint);
                    trvwNFe.Items.AddChild(Node,'tpVeic='   +IntToStr(tpVeic));
                    trvwNFe.Items.AddChild(Node,'espVeic='  +IntToStr(espVeic));
                    trvwNFe.Items.AddChild(Node,'VIN='      +VIN);
                    trvwNFe.Items.AddChild(Node,'condVeic=' +condVeicToStr(condVeic));
                    trvwNFe.Items.AddChild(Node,'cMod='     +cMod);
                  end;
               end;

               for J:=0 to Prod.med.Count-1 do
                begin
                  Node := trvwNFe.Items.AddChild(NodeItem,'Medicamento'+IntToStrZero(J+1,3) );
                  with Prod.med.Items[J] do
                   begin
                     trvwNFe.Items.AddChild(Node,'nLote=' +nLote) ;
                     trvwNFe.Items.AddChild(Node,'qLote=' +FloatToStr(qLote)) ;
                     trvwNFe.Items.AddChild(Node,'dFab='  +DateToStr(dFab)) ;
                     trvwNFe.Items.AddChild(Node,'dVal='  +DateToStr(dVal)) ;
                     trvwNFe.Items.AddChild(Node,'vPMC='  +FloatToStr(vPMC)) ;
                    end;
                end;

               for J:=0 to Prod.arma.Count-1 do
                begin
                  Node := trvwNFe.Items.AddChild(NodeItem,'Arma'+IntToStrZero(J+1,3));
                  with Prod.arma.Items[J] do
                   begin
                     trvwNFe.Items.AddChild(Node,'nSerie=' +nSerie) ;
                     trvwNFe.Items.AddChild(Node,'tpArma=' +tpArmaToStr(tpArma)) ;
                     trvwNFe.Items.AddChild(Node,'nCano='  +nCano) ;
                     trvwNFe.Items.AddChild(Node,'descr='  +descr) ;
                    end;
                end;

               if (Prod.comb.cProdANP > 0) then
                begin
                 NodePai := trvwNFe.Items.AddChild(NodeItem,'Combustivel');
                 with Prod.comb do
                  begin
                    trvwNFe.Items.AddChild(NodePai,'cProdANP=' +IntToStr(cProdANP)) ;
                    trvwNFe.Items.AddChild(NodePai,'CODIF='    +CODIF) ;
                    trvwNFe.Items.AddChild(NodePai,'qTemp='    +FloatToStr(qTemp)) ;
                    trvwNFe.Items.AddChild(NodePai,'UFcons='    +UFcons) ;                    

                    Node := trvwNFe.Items.AddChild(NodePai,'CIDE'+IntToStrZero(I+1,3));
                    trvwNFe.Items.AddChild(Node,'qBCprod='   +FloatToStr(CIDE.qBCprod)) ;
                    trvwNFe.Items.AddChild(Node,'vAliqProd=' +FloatToStr(CIDE.vAliqProd)) ;
                    trvwNFe.Items.AddChild(Node,'vCIDE='     +FloatToStr(CIDE.vCIDE)) ;

                    Node := trvwNFe.Items.AddChild(NodePai,'ICMSComb'+IntToStrZero(I+1,3));
                    trvwNFe.Items.AddChild(Node,'vBCICMS='   +FloatToStr(ICMS.vBCICMS)) ;
                    trvwNFe.Items.AddChild(Node,'vICMS='     +FloatToStr(ICMS.vICMS)) ;
                    trvwNFe.Items.AddChild(Node,'vBCICMSST=' +FloatToStr(ICMS.vBCICMSST)) ;
                    trvwNFe.Items.AddChild(Node,'vICMSST='   +FloatToStr(ICMS.vICMSST)) ;

                    if (ICMSInter.vBCICMSSTDest>0) then
                     begin
                       Node := trvwNFe.Items.AddChild(NodePai,'ICMSInter'+IntToStrZero(I+1,3));
                       trvwNFe.Items.AddChild(Node,'vBCICMSSTDest=' +FloatToStr(ICMSInter.vBCICMSSTDest)) ;
                       trvwNFe.Items.AddChild(Node,'vICMSSTDest='   +FloatToStr(ICMSInter.vICMSSTDest)) ;
                     end;

                    if (ICMSCons.vBCICMSSTCons>0) then
                     begin
                       Node := trvwNFe.Items.AddChild(NodePai,'ICMSCons'+IntToStrZero(I+1,3));
                       trvwNFe.Items.AddChild(Node,'vBCICMSSTCons=' +FloatToStr(ICMSCons.vBCICMSSTCons)) ;
                       trvwNFe.Items.AddChild(Node,'vICMSSTCons='   +FloatToStr(ICMSCons.vICMSSTCons)) ;
                       trvwNFe.Items.AddChild(Node,'UFCons='        +ICMSCons.UFcons) ;
                     end;
                  end;
               end;

               with Imposto do
                begin
                   NodePai := trvwNFe.Items.AddChild(NodeItem,'Imposto');

                   if ISSQN.cSitTrib = ISSQNcSitTribVazio then
                   begin
                     Node := trvwNFe.Items.AddChild(NodePai,'ICMS');
                     with ICMS do
                      begin
                        trvwNFe.Items.AddChild(Node,'CST=' +CSTICMSToStr(CST));
                        trvwNFe.Items.AddChild(Node,'CSOSN=' +CSOSNIcmsToStr(CSOSN));
                        trvwNFe.Items.AddChild(Node,'orig='  +OrigToStr(ICMS.orig));
                        trvwNFe.Items.AddChild(Node,'modBC=' +modBCToStr(ICMS.modBC));
                        trvwNFe.Items.AddChild(Node,'pRedBC=' +FloatToStr(ICMS.pRedBC));
                        trvwNFe.Items.AddChild(Node,'vBC='   +FloatToStr(ICMS.vBC));
                        trvwNFe.Items.AddChild(Node,'pICMS=' +FloatToStr(ICMS.pICMS));
                        trvwNFe.Items.AddChild(Node,'vICMS=' +FloatToStr(ICMS.vICMS));
                        trvwNFe.Items.AddChild(Node,'modBCST='  +modBCSTToStr(ICMS.modBCST));
                        trvwNFe.Items.AddChild(Node,'pMVAST='   +FloatToStr(ICMS.pMVAST));
                        trvwNFe.Items.AddChild(Node,'pRedBCST=' +FloatToStr(ICMS.pRedBCST));
                        trvwNFe.Items.AddChild(Node,'vBCST='    +FloatToStr(ICMS.vBCST));
                        trvwNFe.Items.AddChild(Node,'pICMSST='  +FloatToStr(ICMS.pICMSST));
                        trvwNFe.Items.AddChild(Node,'vICMSST='  +FloatToStr(ICMS.vICMSST));
                        trvwNFe.Items.AddChild(Node,'vBCSTRet='   +FloatToStr(ICMS.vBCSTRet));
                        trvwNFe.Items.AddChild(Node,'vICMSSTRet=' +FloatToStr(ICMS.vICMSSTRet));
                        trvwNFe.Items.AddChild(Node,'pCredSN='   +FloatToStr(ICMS.pCredSN));
                        trvwNFe.Items.AddChild(Node,'vCredICMSSN='   +FloatToStr(ICMS.vCredICMSSN));
                      end;

                      Node := trvwNFe.Items.AddChild(NodePai,'ICMSUFDest');
                      with ICMSUFDest do
                      begin
                        trvwNFe.Items.AddChild(Node,'vBCUFDest='   +FloatToStr(vBCUFDest));
                        trvwNFe.Items.AddChild(Node,'pFCPUFDest='   +FloatToStr(pFCPUFDest));
                        trvwNFe.Items.AddChild(Node,'pICMSUFDest='   +FloatToStr(pICMSUFDest));
                        trvwNFe.Items.AddChild(Node,'pICMSInter='   +FloatToStr(pICMSInter));
                        trvwNFe.Items.AddChild(Node,'pICMSInterPart='   +FloatToStr(pICMSInterPart));
                        trvwNFe.Items.AddChild(Node,'vFCPUFDest='   +FloatToStr(vFCPUFDest));
                        trvwNFe.Items.AddChild(Node,'vICMSUFDest='   +FloatToStr(vICMSUFDest));
                        trvwNFe.Items.AddChild(Node,'vICMSUFRemet='   +FloatToStr(vICMSUFRemet));
                      end;
                   end
                   else
                   begin
                     Node := trvwNFe.Items.AddChild(NodePai,'ISSQN');
                     with ISSQN do
                      begin
                        trvwNFe.Items.AddChild(Node,'vBC='       +FloatToStr(vBC));
                        trvwNFe.Items.AddChild(Node,'vAliq='     +FloatToStr(vAliq));
                        trvwNFe.Items.AddChild(Node,'vISSQN='    +FloatToStr(vISSQN));
                        trvwNFe.Items.AddChild(Node,'cMunFG='    +IntToStr(cMunFG));
                        trvwNFe.Items.AddChild(Node,'cListServ=' +cListServ);
                      end;
                   end;

                   if (IPI.vBC > 0) then
                    begin
                      Node := trvwNFe.Items.AddChild(NodePai,'IPI');
                      with IPI do
                       begin
                         trvwNFe.Items.AddChild(Node,'CST='       +CSTIPIToStr(CST)) ;
                         trvwNFe.Items.AddChild(Node,'clEnq='    +clEnq);
                         trvwNFe.Items.AddChild(Node,'CNPJProd=' +CNPJProd);
                         trvwNFe.Items.AddChild(Node,'cSelo='    +cSelo);
                         trvwNFe.Items.AddChild(Node,'qSelo='    +IntToStr(qSelo));
                         trvwNFe.Items.AddChild(Node,'cEnq='     +cEnq);

                         trvwNFe.Items.AddChild(Node,'vBC='    +FloatToStr(vBC));
                         trvwNFe.Items.AddChild(Node,'qUnid='  +FloatToStr(qUnid));
                         trvwNFe.Items.AddChild(Node,'vUnid='  +FloatToStr(vUnid));
                         trvwNFe.Items.AddChild(Node,'pIPI='   +FloatToStr(pIPI));
                         trvwNFe.Items.AddChild(Node,'vIPI='   +FloatToStr(vIPI));
                       end;
                    end;

                   if (II.vBc > 0) then
                    begin
                      Node := trvwNFe.Items.AddChild(NodePai,'II');
                      with II do
                       begin
                         trvwNFe.Items.AddChild(Node,'vBc='      +FloatToStr(vBc));
                         trvwNFe.Items.AddChild(Node,'vDespAdu=' +FloatToStr(vDespAdu));
                         trvwNFe.Items.AddChild(Node,'vII='      +FloatToStr(vII));
                         trvwNFe.Items.AddChild(Node,'vIOF='     +FloatToStr(vIOF));
                       end;
                    end;

                   Node := trvwNFe.Items.AddChild(NodePai,'PIS');
                   with PIS do
                    begin
                      trvwNFe.Items.AddChild(Node,'CST=' +CSTPISToStr(CST));

                      if (CST = pis01) or (CST = pis02) then
                       begin
                         trvwNFe.Items.AddChild(Node,'vBC='  +FloatToStr(PIS.vBC));
                         trvwNFe.Items.AddChild(Node,'pPIS=' +FloatToStr(PIS.pPIS));
                         trvwNFe.Items.AddChild(Node,'vPIS=' +FloatToStr(PIS.vPIS));
                       end
                      else if CST = pis03 then
                       begin
                         trvwNFe.Items.AddChild(Node,'qBCProd='   +FloatToStr(PIS.qBCProd));
                         trvwNFe.Items.AddChild(Node,'vAliqProd=' +FloatToStr(PIS.vAliqProd));
                         trvwNFe.Items.AddChild(Node,'vPIS='      +FloatToStr(PIS.vPIS));
                       end
                      else if CST = pis99 then
                       begin
                         trvwNFe.Items.AddChild(Node,'vBC='       +FloatToStr(PIS.vBC));
                         trvwNFe.Items.AddChild(Node,'pPIS='      +FloatToStr(PIS.pPIS));
                         trvwNFe.Items.AddChild(Node,'qBCProd='   +FloatToStr(PIS.qBCProd));
                         trvwNFe.Items.AddChild(Node,'vAliqProd=' +FloatToStr(PIS.vAliqProd));
                         trvwNFe.Items.AddChild(Node,'vPIS='      +FloatToStr(PIS.vPIS));
                       end;
                    end;

                   if (PISST.vBc>0) then
                    begin
                      Node := trvwNFe.Items.AddChild(NodePai,'PISST');
                      with PISST do
                       begin
                         trvwNFe.Items.AddChild(Node,'vBc='       +FloatToStr(vBc));
                         trvwNFe.Items.AddChild(Node,'pPis='      +FloatToStr(pPis));
                         trvwNFe.Items.AddChild(Node,'qBCProd='   +FloatToStr(qBCProd));
                         trvwNFe.Items.AddChild(Node,'vAliqProd=' +FloatToStr(vAliqProd));
                         trvwNFe.Items.AddChild(Node,'vPIS='      +FloatToStr(vPIS));
                       end;
                      end;

                   Node := trvwNFe.Items.AddChild(NodePai,'COFINS');
                   with COFINS do
                    begin
                      trvwNFe.Items.AddChild(Node,'CST=' +CSTCOFINSToStr(CST));

                      if (CST = cof01) or (CST = cof02)   then
                       begin
                         trvwNFe.Items.AddChild(Node,'vBC='     +FloatToStr(COFINS.vBC));
                         trvwNFe.Items.AddChild(Node,'pCOFINS=' +FloatToStr(COFINS.pCOFINS));
                         trvwNFe.Items.AddChild(Node,'vCOFINS=' +FloatToStr(COFINS.vCOFINS));
                       end
                      else if CST = cof03 then
                       begin
                         trvwNFe.Items.AddChild(Node,'qBCProd='   +FloatToStr(COFINS.qBCProd));
                         trvwNFe.Items.AddChild(Node,'vAliqProd=' +FloatToStr(COFINS.vAliqProd));
                         trvwNFe.Items.AddChild(Node,'vCOFINS='   +FloatToStr(COFINS.vCOFINS));
                       end
                      else if CST = cof99 then
                       begin
                         trvwNFe.Items.AddChild(Node,'vBC='       +FloatToStr(COFINS.vBC));
                         trvwNFe.Items.AddChild(Node,'pCOFINS='   +FloatToStr(COFINS.pCOFINS));
                         trvwNFe.Items.AddChild(Node,'qBCProd='   +FloatToStr(COFINS.qBCProd));
                         trvwNFe.Items.AddChild(Node,'vAliqProd=' +FloatToStr(COFINS.vAliqProd));
                         trvwNFe.Items.AddChild(Node,'vCOFINS='   +FloatToStr(COFINS.vCOFINS));
                       end;
                    end;

                   if (COFINSST.vBC > 0) then
                    begin
                      Node := trvwNFe.Items.AddChild(NodePai,'COFINSST');
                      with COFINSST do
                       begin
                         trvwNFe.Items.AddChild(Node,'vBC='       +FloatToStr(vBC));
                         trvwNFe.Items.AddChild(Node,'pCOFINS='   +FloatToStr(pCOFINS));
                         trvwNFe.Items.AddChild(Node,'qBCProd='   +FloatToStr(qBCProd));
                         trvwNFe.Items.AddChild(Node,'vAliqProd=' +FloatToStr(vAliqProd));
                         trvwNFe.Items.AddChild(Node,'vCOFINS='   +FloatToStr(vCOFINS));
                       end;
                    end;
                end;
             end;
          end ;

       NodePai := trvwNFe.Items.AddChild(Nota,'Total');
       Node := trvwNFe.Items.AddChild(NodePai,'ICMSTot');
       trvwNFe.Items.AddChild(Node,'vBC='     +FloatToStr(Total.ICMSTot.vBC));
       trvwNFe.Items.AddChild(Node,'vICMS='   +FloatToStr(Total.ICMSTot.vICMS)) ;
       trvwNFe.Items.AddChild(Node,'vBCST='   +FloatToStr(Total.ICMSTot.vBCST)) ;
       trvwNFe.Items.AddChild(Node,'vST='     +FloatToStr(Total.ICMSTot.vST)) ;
       trvwNFe.Items.AddChild(Node,'vProd='   +FloatToStr(Total.ICMSTot.vProd)) ;
       trvwNFe.Items.AddChild(Node,'vFrete='  +FloatToStr(Total.ICMSTot.vFrete)) ;
       trvwNFe.Items.AddChild(Node,'vSeg='    +FloatToStr(Total.ICMSTot.vSeg)) ;
       trvwNFe.Items.AddChild(Node,'vDesc='   +FloatToStr(Total.ICMSTot.vDesc)) ;
       trvwNFe.Items.AddChild(Node,'vII='     +FloatToStr(Total.ICMSTot.vII)) ;
       trvwNFe.Items.AddChild(Node,'vIPI='    +FloatToStr(Total.ICMSTot.vIPI)) ;
       trvwNFe.Items.AddChild(Node,'vPIS='    +FloatToStr(Total.ICMSTot.vPIS)) ;
       trvwNFe.Items.AddChild(Node,'vCOFINS=' +FloatToStr(Total.ICMSTot.vCOFINS)) ;
       trvwNFe.Items.AddChild(Node,'vOutro='  +FloatToStr(Total.ICMSTot.vOutro)) ;
       trvwNFe.Items.AddChild(Node,'vNF='     +FloatToStr(Total.ICMSTot.vNF)) ;
       trvwNFe.Items.AddChild(Node,'vFCPUFDest='   +FloatToStr(Total.ICMSTot.vFCPUFDest)) ;
       trvwNFe.Items.AddChild(Node,'vICMSUFDest='  +FloatToStr(Total.ICMSTot.vICMSUFDest)) ;
       trvwNFe.Items.AddChild(Node,'vICMSUFRemet=' +FloatToStr(Total.ICMSTot.vICMSUFRemet)) ;

       if Total.ISSQNtot.vServ > 0 then
        begin
          Node := trvwNFe.Items.AddChild(NodePai,'ISSQNtot');
          trvwNFe.Items.AddChild(Node,'vServ='   +FloatToStr(Total.ISSQNtot.vServ)) ;
          trvwNFe.Items.AddChild(Node,'vBC='     +FloatToStr(Total.ISSQNTot.vBC)) ;
          trvwNFe.Items.AddChild(Node,'vISS='    +FloatToStr(Total.ISSQNTot.vISS)) ;
          trvwNFe.Items.AddChild(Node,'vPIS='    +FloatToStr(Total.ISSQNTot.vPIS)) ;
          trvwNFe.Items.AddChild(Node,'vCOFINS=' +FloatToStr(Total.ISSQNTot.vCOFINS)) ;
        end;

       Node := trvwNFe.Items.AddChild(NodePai,'retTrib');
       trvwNFe.Items.AddChild(Node,'vRetPIS='   +FloatToStr(Total.retTrib.vRetPIS)) ;
       trvwNFe.Items.AddChild(Node,'vRetCOFINS='+FloatToStr(Total.retTrib.vRetCOFINS)) ;
       trvwNFe.Items.AddChild(Node,'vRetCSLL='  +FloatToStr(Total.retTrib.vRetCSLL)) ;
       trvwNFe.Items.AddChild(Node,'vBCIRRF='   +FloatToStr(Total.retTrib.vBCIRRF)) ;
       trvwNFe.Items.AddChild(Node,'vIRRF='     +FloatToStr(Total.retTrib.vIRRF)) ;
       trvwNFe.Items.AddChild(Node,'vBCRetPrev='+FloatToStr(Total.retTrib.vBCRetPrev)) ;
       trvwNFe.Items.AddChild(Node,'vRetPrev='  +FloatToStr(Total.retTrib.vRetPrev)) ;

       NodePai := trvwNFe.Items.AddChild(Nota,'Transp');
       Node := trvwNFe.Items.AddChild(NodePai,'Transporta');
       trvwNFe.Items.AddChild(Node,'modFrete=' +modFreteToStr(Transp.modFrete));
       trvwNFe.Items.AddChild(Node,'CNPJCPF='  +Transp.Transporta.CNPJCPF);
       trvwNFe.Items.AddChild(Node,'xNome='    +Transp.Transporta.xNome);
       trvwNFe.Items.AddChild(Node,'IE='       +Transp.Transporta.IE);
       trvwNFe.Items.AddChild(Node,'xEnder='   +Transp.Transporta.xEnder);
       trvwNFe.Items.AddChild(Node,'xMun='     +Transp.Transporta.xMun);
       trvwNFe.Items.AddChild(Node,'UF='       +Transp.Transporta.UF);

       Node := trvwNFe.Items.AddChild(NodePai,'retTransp');
       trvwNFe.Items.AddChild(Node,'vServ='    +FloatToStr(Transp.retTransp.vServ)) ;
       trvwNFe.Items.AddChild(Node,'vBCRet='   +FloatToStr(Transp.retTransp.vBCRet)) ;
       trvwNFe.Items.AddChild(Node,'pICMSRet=' +FloatToStr(Transp.retTransp.pICMSRet)) ;
       trvwNFe.Items.AddChild(Node,'vICMSRet=' +FloatToStr(Transp.retTransp.vICMSRet)) ;
       trvwNFe.Items.AddChild(Node,'CFOP='     +Transp.retTransp.CFOP);
       trvwNFe.Items.AddChild(Node,'cMunFG='   +FloatToStr(Transp.retTransp.cMunFG));

       Node := trvwNFe.Items.AddChild(NodePai,'veicTransp');
       trvwNFe.Items.AddChild(Node,'placa='  +Transp.veicTransp.placa);
       trvwNFe.Items.AddChild(Node,'UF='     +Transp.veicTransp.UF);
       trvwNFe.Items.AddChild(Node,'RNTC='   +Transp.veicTransp.RNTC);

       for I:=0 to Transp.Reboque.Count-1 do
        begin
          Node := trvwNFe.Items.AddChild(NodePai,'Reboque'+IntToStrZero(I+1,3));
          with Transp.Reboque.Items[I] do
           begin
             trvwNFe.Items.AddChild(Node,'placa=' +placa) ;
             trvwNFe.Items.AddChild(Node,'UF='    +UF) ;
             trvwNFe.Items.AddChild(Node,'RNTC='  +RNTC) ;
           end;
        end;

       for I:=0 to Transp.Vol.Count-1 do
        begin
          Node := trvwNFe.Items.AddChild(NodePai,'Volume'+IntToStrZero(I+1,3));
          with Transp.Vol.Items[I] do
           begin
             trvwNFe.Items.AddChild(Node,'qVol='  +IntToStr(qVol)) ;
             trvwNFe.Items.AddChild(Node,'esp='   +esp);
             trvwNFe.Items.AddChild(Node,'marca=' +marca);
             trvwNFe.Items.AddChild(Node,'nVol='  +nVol);
             trvwNFe.Items.AddChild(Node,'pesoL=' +FloatToStr(pesoL)) ;
             trvwNFe.Items.AddChild(Node,'pesoB'  +FloatToStr(pesoB)) ;

             for J:=0 to Lacres.Count-1 do
              begin
                Node := trvwNFe.Items.AddChild(Node,'Lacre'+IntToStrZero(I+1,3)+IntToStrZero(J+1,3) );
                trvwNFe.Items.AddChild(Node,'nLacre='+Lacres.Items[J].nLacre) ;
              end;
           end;
        end;

       NodePai := trvwNFe.Items.AddChild(Nota,'Cobr');
       Node    := trvwNFe.Items.AddChild(NodePai,'Fat');
       trvwNFe.Items.AddChild(Node,'nFat='  +Cobr.Fat.nFat);
       trvwNFe.Items.AddChild(Node,'vOrig=' +FloatToStr(Cobr.Fat.vOrig)) ;
       trvwNFe.Items.AddChild(Node,'vDesc=' +FloatToStr(Cobr.Fat.vDesc)) ;
       trvwNFe.Items.AddChild(Node,'vLiq='  +FloatToStr(Cobr.Fat.vLiq)) ;

       for I:=0 to Cobr.Dup.Count-1 do
        begin
          Node    := trvwNFe.Items.AddChild(NodePai,'Duplicata'+IntToStrZero(I+1,3));
          with Cobr.Dup.Items[I] do
           begin
             trvwNFe.Items.AddChild(Node,'nDup='  +nDup) ;
             trvwNFe.Items.AddChild(Node,'dVenc=' +DateToStr(dVenc));
             trvwNFe.Items.AddChild(Node,'vDup='  +FloatToStr(vDup)) ;
           end;
        end;

       NodePai := trvwNFe.Items.AddChild(Nota,'InfAdic');
       trvwNFe.Items.AddChild(NodePai,'infCpl='     +InfAdic.infCpl);
       trvwNFe.Items.AddChild(NodePai,'infAdFisco=' +InfAdic.infAdFisco);

       for I:=0 to InfAdic.obsCont.Count-1 do
        begin
          Node := trvwNFe.Items.AddChild(NodePai,'obsCont'+IntToStrZero(I+1,3));
          with InfAdic.obsCont.Items[I] do
           begin
             trvwNFe.Items.AddChild(Node,'xCampo=' +xCampo) ;
             trvwNFe.Items.AddChild(Node,'xTexto=' +xTexto);
           end;
        end;

         for I:=0 to InfAdic.obsFisco.Count-1 do
          begin
            Node := trvwNFe.Items.AddChild(NodePai,'obsFisco'+IntToStrZero(I+1,3));
            with InfAdic.obsFisco.Items[I] do
             begin
                trvwNFe.Items.AddChild(Node,'xCampo=' +xCampo) ;
                trvwNFe.Items.AddChild(Node,'xTexto=' +xTexto);
             end;
          end;

         for I:=0 to InfAdic.procRef.Count-1 do
          begin
            Node := trvwNFe.Items.AddChild(NodePai,'procRef'+IntToStrZero(I+1,3));
            with InfAdic.procRef.Items[I] do
             begin
               trvwNFe.Items.AddChild(Node,'nProc='   +nProc) ;
               trvwNFe.Items.AddChild(Node,'indProc=' +indProcToStr(indProc));
             end;
          end;

         if (exporta.UFembarq <> '') then
          begin
            Node := trvwNFe.Items.AddChild(Nota,'exporta');
            trvwNFe.Items.AddChild(Node,'UFembarq='   +exporta.UFembarq) ;
            trvwNFe.Items.AddChild(Node,'xLocEmbarq=' +exporta.xLocEmbarq);
          end;

         if (compra.xNEmp <> '') then
          begin
            Node := trvwNFe.Items.AddChild(Nota,'compra');
            trvwNFe.Items.AddChild(Node,'xNEmp=' +compra.xNEmp) ;
            trvwNFe.Items.AddChild(Node,'xPed='  +compra.xPed);
            trvwNFe.Items.AddChild(Node,'xCont=' +compra.xCont);
          end;
     end;
       pgRespostas.ActivePageIndex := 3;
     end;

  end;
end;

procedure TForm1.lblMouseEnter(Sender: TObject);
begin
 TLabel(Sender).Font.Style := [fsBold,fsUnderline];
end;

procedure TForm1.lblMouseLeave(Sender: TObject);
begin
 TLabel(Sender).Font.Style := [fsBold];
end;

procedure TForm1.lblColaboradorClick(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/5');
end;

procedure TForm1.lblPatrocinadorClick(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/35');
end;

procedure TForm1.lblDoar1Click(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/14');
end;

procedure TForm1.GerarNFe(NumNFe : String);
begin
  with ACBrNFe1.NotasFiscais.Add.NFe do
   begin
     Ide.cNF       := StrToInt(NumNFe); //Caso n�o seja preenchido ser� gerado um n�mero aleat�rio pelo componente
     Ide.natOp     := 'VENDA PRODUCAO DO ESTAB.';
     Ide.indPag    := ipVista;
     Ide.modelo    := 55;
     Ide.serie     := 1;
     Ide.nNF       := StrToInt(NumNFe);
     Ide.dEmi      := Date;
     Ide.dSaiEnt   := Date;
     Ide.hSaiEnt   := Now;
     Ide.tpNF      := tnSaida;
     Ide.tpEmis    := TpcnTipoEmissao(cbFormaEmissao.ItemIndex); ;
     Ide.tpAmb     := taHomologacao;  //Lembre-se de trocar esta vari�vel quando for para ambiente de produ��o
     Ide.verProc   := '1.0.0.0'; //Vers�o do seu sistema
     Ide.cUF       := UFtoCUF(edtEmitUF.Text);
     Ide.cMunFG    := StrToInt(edtEmitCodCidade.Text);
     Ide.finNFe    := fnNormal;
     if  Assigned( ACBrNFe1.DANFE ) then
        Ide.tpImp     := ACBrNFe1.DANFE.TipoDANFE;

//     Ide.dhCont := date;
//     Ide.xJust  := 'Justificativa Contingencia';

//Para NFe referenciada use os campos abaixo
{     with Ide.NFref.Add do
      begin
        refNFe       := ''; //NFe Eletronica

        RefNF.cUF    := 0;  // |
        RefNF.AAMM   := ''; // |
        RefNF.CNPJ   := ''; // |
        RefNF.modelo := 1;  // |- NFe Modelo 1/1A
        RefNF.serie  := 1;  // |
        RefNF.nNF    := 0;  // |

        RefNFP.cUF     := 0;  // |
        RefNFP.AAMM    := ''; // |
        RefNFP.CNPJCPF := ''; // |
        RefNFP.IE      := ''; // |- NF produtor Rural
        RefNFP.modelo  := ''; // |
        RefNFP.serie   := 1;  // |
        RefNFP.nNF     := 0;  // |

        RefECF.modelo  := ECFModRef2B; // |
        RefECF.nECF    := '';          // |- Cupom Fiscal
        RefECF.nCOO    := '';          // |
      end;
}
      Emit.CNPJCPF           := edtEmitCNPJ.Text;
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
      Emit.enderEmit.cPais   := 1058;
      Emit.enderEmit.xPais   := 'BRASIL';

      Emit.IEST              := '';
      Emit.IM                := '2648800'; // Preencher no caso de existir servi�os na nota
      Emit.CNAE              := '6201500'; // Verifique na cidade do emissor da NFe se � permitido
                                    // a inclus�o de servi�os na NFe
      Emit.CRT               := crtRegimeNormal;// (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)

//Para NFe Avulsa preencha os campos abaixo
{      Avulsa.CNPJ    := '';
      Avulsa.xOrgao  := '';
      Avulsa.matr    := '';
      Avulsa.xAgente := '';
      Avulsa.fone    := '';
      Avulsa.UF      := '';
      Avulsa.nDAR    := '';
      Avulsa.dEmi    := now;
      Avulsa.vDAR    := 0;
      Avulsa.repEmi  := '';
      Avulsa.dPag    := now;             }

      Dest.CNPJCPF           := '05481336000137';
      Dest.IE                := '687138770110';
      Dest.ISUF              := '';
      Dest.xNome             := 'D.J. COM. E LOCA��O DE SOFTWARES LTDA - ME';

      Dest.EnderDest.Fone    := '1532599600';
      Dest.EnderDest.CEP     := 18270170;
      Dest.EnderDest.xLgr    := 'Rua Coronel Aureliano de Camargo';
      Dest.EnderDest.nro     := '973';
      Dest.EnderDest.xCpl    := '';
      Dest.EnderDest.xBairro := 'Centro';
      Dest.EnderDest.cMun    := 3554003;
      Dest.EnderDest.xMun    := 'Tatui';
      Dest.EnderDest.UF      := 'SP';
      Dest.EnderDest.cPais   := 1058;
      Dest.EnderDest.xPais   := 'BRASIL';

//Use os campos abaixo para informar o endere�o de retirada quando for diferente do Remetente/Destinat�rio
{      Retirada.CNPJCPF := '';
      Retirada.xLgr    := '';
      Retirada.nro     := '';
      Retirada.xCpl    := '';
      Retirada.xBairro := '';
      Retirada.cMun    := 0;
      Retirada.xMun    := '';
      Retirada.UF      := '';}

//Use os campos abaixo para informar o endere�o de entrega quando for diferente do Remetente/Destinat�rio
{      Entrega.CNPJCPF := '';
      Entrega.xLgr    := '';
      Entrega.nro     := '';
      Entrega.xCpl    := '';
      Entrega.xBairro := '';
      Entrega.cMun    := 0;
      Entrega.xMun    := '';
      Entrega.UF      := '';}

//Adicionando Produtos
      with Det.Add do
       begin
         Prod.nItem    := 1; // N�mero sequencial, para cada item deve ser incrementado
         Prod.cProd    := '123456';
         Prod.cEAN     := '7896523206646';
         Prod.xProd    := 'TESTE DE PRODUTO';
         Prod.NCM      := '94051010'; // Tabela NCM dispon�vel em  http://www.receita.fazenda.gov.br/Aliquotas/DownloadArqTIPI.htm
         Prod.EXTIPI   := '';
         Prod.CFOP     := '5101';
         Prod.uCom     := 'UN';
         Prod.qCom     := 1 ;
         Prod.vUnCom   := 100;
         Prod.vProd    := 100 ;

         Prod.cEANTrib  := '7896523206646';
         Prod.uTrib     := 'UN';
         Prod.qTrib     := 1;
         Prod.vUnTrib   := 100;

         Prod.vOutro    := 0;
         Prod.vFrete    := 0;
         Prod.vSeg      := 0;
         Prod.vDesc     := 0;

         Prod.CEST := '1111111';

         infAdProd      := 'Informacao Adicional do Produto';

//Declara��o de Importa��o. Pode ser adicionada v�rias atrav�s do comando Prod.DI.Add
{         with Prod.DI.Add do
          begin
            nDi         := '';
            dDi         := now;
            xLocDesemb  := '';
            UFDesemb    := '';
            dDesemb     := now;
            cExportador := '';

            with adi.Add do
             begin
               nAdicao     := 1;
               nSeqAdi     := 1;
               cFabricante := '';
               vDescDI     := 0;
             end;
          end;
}
//Campos para venda de ve�culos novos
{         with Prod.veicProd do
          begin
            tpOP    := toVendaConcessionaria;
            chassi  := '';
            cCor    := '';
            xCor    := '';
            pot     := '';
            Cilin   := '';
            pesoL   := '';
            pesoB   := '';
            nSerie  := '';
            tpComb  := '';
            nMotor  := '';
            CMT     := '';
            dist    := '';
            RENAVAM := '';
            anoMod  := 0;
            anoFab  := 0;
            tpPint  := '';
            tpVeic  := 0;
            espVeic := 0;
            VIN     := '';
            condVeic := cvAcabado;
            cMod    := '';
          end;
}
//Campos espec�ficos para venda de medicamentos
{         with Prod.med.Add do
          begin
            nLote := '';
            qLote := 0 ;
            dFab  := now ;
            dVal  := now ;
            vPMC  := 0 ;
          end;  }
//Campos espec�ficos para venda de armamento
{         with Prod.arma.Add do
          begin
            nSerie := 0;
            tpArma := taUsoPermitido ;
            nCano  := 0 ;
            descr  := '' ;
          end;      }
//Campos espec�ficos para venda de combust�vel(distribuidoras)
{         with Prod.comb do
          begin
            cProdANP := 0;
            CODIF    := '';
            qTemp    := 0;
            UFcons   := '';

            CIDE.qBCprod   := 0 ;
            CIDE.vAliqProd := 0 ;
            CIDE.vCIDE     := 0 ;

            ICMS.vBCICMS   := 0 ;
            ICMS.vICMS     := 0 ;
            ICMS.vBCICMSST := 0 ;
            ICMS.vICMSST   := 0 ;

            ICMSInter.vBCICMSSTDest := 0 ;
            ICMSInter.vICMSSTDest   := 0 ;

            ICMSCons.vBCICMSSTCons := 0 ;
            ICMSCons.vICMSSTCons   := 0 ;
            ICMSCons.UFcons        := '' ;
          end;}

         with Imposto do
          begin
            // lei da transparencia nos impostos
            vTotTrib := 0;

            with ICMS do
             begin
               CST          := cst00;
               ICMS.orig    := oeNacional;
               ICMS.modBC   := dbiValorOperacao;
               ICMS.vBC     := 100;
               ICMS.pICMS   := 18;
               ICMS.vICMS   := 18;
               ICMS.modBCST := dbisMargemValorAgregado;
               ICMS.pMVAST  := 0;
               ICMS.pRedBCST:= 0;
               ICMS.vBCST   := 0;
               ICMS.pICMSST := 0;
               ICMS.vICMSST := 0;
               ICMS.pRedBC  := 0;


               // partilha do ICMS e fundo de probreza
               with ICMSUFDest do
                begin
                  vBCUFDest      := 0.00;
                  pFCPUFDest     := 0.00;
                  pICMSUFDest    := 0.00;
                  pICMSInter     := 0.00;
                  pICMSInterPart := 0.00;
                  vFCPUFDest     := 0.00;
                  vICMSUFDest    := 0.00;
                  vICMSUFRemet   := 0.00;
                end;
             end;

    {        with IPI do
             begin
               CST      := ipi99 ;
               clEnq    := '999';
               CNPJProd := '';
               cSelo    := '';
               qSelo    := 0;
               cEnq     := '';

               vBC    := 100;
               qUnid  := 0;
               vUnid  := 0;
               pIPI   := 5;
               vIPI   := 5;
             end;    }
{
            with II do
             begin
               vBc      := 0;
               vDespAdu := 0;
               vII      := 0;
               vIOF     := 0;
             end;

            with PIS do
             begin
               CST      := pis99;
               PIS.vBC  := 0;
               PIS.pPIS := 0;
               PIS.vPIS := 0;

               PIS.qBCProd   := 0;
               PIS.vAliqProd := 0;
               PIS.vPIS      := 0;
             end;

            with PISST do
             begin
               vBc       := 0;
               pPis      := 0;
               qBCProd   := 0;
               vAliqProd := 0;
               vPIS      := 0;
             end;

            with COFINS do
             begin
               CST            := cof99;
               COFINS.vBC     := 0;
               COFINS.pCOFINS := 0;
               COFINS.vCOFINS := 0;

               COFINS.qBCProd   := 0;
               COFINS.vAliqProd := 0;
             end;

            with COFINSST do
             begin
               vBC       := 0;
               pCOFINS   := 0;
               qBCProd   := 0;
               vAliqProd := 0;
               vCOFINS   := 0;
             end;
}
//Grupo para servi�os
{            with ISSQN do
             begin
               vBC       := 0;
               vAliq     := 0;
               vISSQN    := 0;
               cMunFG    := 0;
               cListServ := 1402; // Preencha este campo usando a tabela dispon�vel
                               // em http://www.planalto.gov.br/Ccivil_03/LEIS/LCP/Lcp116.htm
             end;}
         end;
       end ;
 {
//Adicionando Servi�os
      with Det.Add do
       begin
         Prod.nItem    := 1; // N�mero sequencial, para cada item deve ser incrementado
         Prod.cProd    := '123457';
         Prod.cEAN     := '';
         Prod.xProd    := 'Descri��o do Servi�o';
         Prod.NCM      := '99';
         Prod.EXTIPI   := '';
         Prod.CFOP     := '5933';
         Prod.uCom     := 'UN';
         Prod.qCom     := 1 ;
         Prod.vUnCom   := 100;
         Prod.vProd    := 100 ;

         Prod.cEANTrib  := '';
         Prod.uTrib     := 'UN';
         Prod.qTrib     := 1;
         Prod.vUnTrib   := 100;

         Prod.vFrete    := 0;
         Prod.vSeg      := 0;
         Prod.vDesc     := 0;

         infAdProd      := 'Informa��o Adicional do Servi�o';

//Grupo para servi�os
            with Imposto.ISSQN do
             begin
               cSitTrib  := ISSQNcSitTribNORMAL; 
               vBC       := 100;
               vAliq     := 2;
               vISSQN    := 2;
               cMunFG    := 3554003;
               cListServ := '1402'; // Preencha este campo usando a tabela dispon�vel
                               // em http://www.planalto.gov.br/Ccivil_03/LEIS/LCP/Lcp116.htm
             end;
       end ;       }

      Total.ICMSTot.vBC     := 100;
      Total.ICMSTot.vICMS   := 18;
      Total.ICMSTot.vBCST   := 0;
      Total.ICMSTot.vST     := 0;
      Total.ICMSTot.vProd   := 100;
      Total.ICMSTot.vFrete  := 0;
      Total.ICMSTot.vSeg    := 0;
      Total.ICMSTot.vDesc   := 0;
      Total.ICMSTot.vII     := 0;
      Total.ICMSTot.vIPI    := 0;
      Total.ICMSTot.vPIS    := 0;
      Total.ICMSTot.vCOFINS := 0;
      Total.ICMSTot.vOutro  := 0;
      Total.ICMSTot.vNF     := 100;

      // lei da transparencia de impostos
      Total.ICMSTot.vTotTrib := 0;

      // partilha do icms e fundo de probreza
      Total.ICMSTot.vFCPUFDest   := 0.00;
      Total.ICMSTot.vICMSUFDest  := 0.00;
      Total.ICMSTot.vICMSUFRemet := 0.00;


  {    Total.ISSQNtot.vServ   := 100;
      Total.ISSQNTot.vBC     := 100;
      Total.ISSQNTot.vISS    := 2;
      Total.ISSQNTot.vPIS    := 0;
      Total.ISSQNTot.vCOFINS := 0;

      Total.retTrib.vRetPIS    := 0;
      Total.retTrib.vRetCOFINS := 0;
      Total.retTrib.vRetCSLL   := 0;
      Total.retTrib.vBCIRRF    := 0;
      Total.retTrib.vIRRF      := 0;
      Total.retTrib.vBCRetPrev := 0;
      Total.retTrib.vRetPrev   := 0;}

      Transp.modFrete := mfContaEmitente;
      Transp.Transporta.CNPJCPF  := '';
      Transp.Transporta.xNome    := '';
      Transp.Transporta.IE       := '';
      Transp.Transporta.xEnder   := '';
      Transp.Transporta.xMun     := '';
      Transp.Transporta.UF       := '';

{      Transp.retTransp.vServ    := 0;
      Transp.retTransp.vBCRet   := 0;
      Transp.retTransp.pICMSRet := 0;
      Transp.retTransp.vICMSRet := 0;
      Transp.retTransp.CFOP     := '';
      Transp.retTransp.cMunFG   := 0;         }

      Transp.veicTransp.placa := '';
      Transp.veicTransp.UF    := '';
      Transp.veicTransp.RNTC  := '';
//Dados do Reboque
{      with Transp.Reboque.Add do
       begin
         placa := '';
         UF    := '';
         RNTC  := '';
       end;}

      with Transp.Vol.Add do
       begin
         qVol  := 1;
         esp   := 'Especie';
         marca := 'Marca';
         nVol  := 'Numero';
         pesoL := 100;
         pesoB := 110;

         //Lacres do volume. Pode ser adicionado v�rios
         //Lacres.Add.nLacre := '';
       end;

      Cobr.Fat.nFat  := 'Numero da Fatura';
      Cobr.Fat.vOrig := 100 ;
      Cobr.Fat.vDesc := 0 ;
      Cobr.Fat.vLiq  := 100 ;

      with Cobr.Dup.Add do
       begin
         nDup  := '1234';
         dVenc := now+10;
         vDup  := 50;
       end;

      with Cobr.Dup.Add do
       begin
         nDup  := '1235';
         dVenc := now+10;
         vDup  := 50;
       end;


      InfAdic.infCpl     :=  '';
      InfAdic.infAdFisco :=  '';

      with InfAdic.obsCont.Add do
       begin
         xCampo := 'ObsCont';
         xTexto := 'Texto';
       end;

      with InfAdic.obsFisco.Add do
       begin
         xCampo := 'ObsFisco';
         xTexto := 'Texto';
       end;
//Processo referenciado
{     with InfAdic.procRef.Add do
       begin
         nProc := '';
         indProc := ipSEFAZ;
       end;                 }

      exporta.UFembarq   := '';;
      exporta.xLocEmbarq := '';

      compra.xNEmp := '';
      compra.xPed  := '';
      compra.xCont := '';
   end;

  ACBrNFe1.NotasFiscais.GerarNFe;
end;

procedure TForm1.GerarNFCe(NumNFe: String);
begin
  with ACBrNFe1.NotasFiscais.Add.NFe do
   begin
     Ide.cNF       := StrToInt(NumNFe); //Caso n�o seja preenchido ser� gerado um n�mero aleat�rio pelo componente
     Ide.natOp     := 'VENDA';
     Ide.indPag    := ipVista;
     Ide.modelo    := 65;
     Ide.serie     := 1;
     Ide.nNF       := StrToInt(NumNFe);
     Ide.dEmi      := now;
     Ide.dSaiEnt   := now;
     Ide.hSaiEnt   := now;
     Ide.tpNF      := tnSaida;
     Ide.tpEmis    := TpcnTipoEmissao(cbFormaEmissao.ItemIndex); ;
     Ide.tpAmb     := taHomologacao;  //Lembre-se de trocar esta variável quando for para ambiente de produção
     Ide.cUF       := UFtoCUF(edtEmitUF.Text);
     Ide.cMunFG    := StrToInt(edtEmitCodCidade.Text);
     Ide.finNFe    := fnNormal;
     Ide.tpImp     := tiNFCe;
     Ide.indFinal  := cfConsumidorFinal;
     Ide.indPres   := pcPresencial;

//     Ide.dhCont := date;
//     Ide.xJust  := 'Justificativa Contingencia';

      Emit.CNPJCPF           := edtEmitCNPJ.Text;
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
      Emit.enderEmit.cPais   := 1058;
      Emit.enderEmit.xPais   := 'BRASIL';

      Emit.IEST              := '';
//      Emit.IM                := '2648800'; // Preencher no caso de existir servi�os na nota
//      Emit.CNAE              := '6201500'; // Verifique na cidade do emissor da NFe se � permitido
                                    // a inclus�o de servi�os na NFe
      Emit.CRT               := crtRegimeNormal;// (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)

      Dest.CNPJCPF           := '05481336000137';
//      Dest.IE                := '687138770110'; //NFC-e n�o aceita IE
      Dest.ISUF              := '';
      Dest.xNome             := 'D.J. COM. E LOCA��O DE SOFTWARES LTDA - ME';

      Dest.indIEDest    := inNaoContribuinte;
      Dest.EnderDest.Fone    := '1533243333';
      Dest.EnderDest.CEP     := 18270170;
      Dest.EnderDest.xLgr    := 'Rua Coronel Aureliano de Camargo';
      Dest.EnderDest.nro     := '973';
      Dest.EnderDest.xCpl    := '';
      Dest.EnderDest.xBairro := 'Centro';
      Dest.EnderDest.cMun    := 3554003;
      Dest.EnderDest.xMun    := 'Tatu�';
      Dest.EnderDest.UF      := 'SP';
      Dest.EnderDest.cPais   := 1058;
      Dest.EnderDest.xPais   := 'BRASIL';

//Use os campos abaixo para informar o endere�o de retirada quando for diferente do Remetente/Destinat�rio
{      Retirada.CNPJCPF := '';
      Retirada.xLgr    := '';
      Retirada.nro     := '';
      Retirada.xCpl    := '';
      Retirada.xBairro := '';
      Retirada.cMun    := 0;
      Retirada.xMun    := '';
      Retirada.UF      := '';}

//Use os campos abaixo para informar o endere�o de entrega quando for diferente do Remetente/Destinat�rio
{      Entrega.CNPJCPF := '';
      Entrega.xLgr    := '';
      Entrega.nro     := '';
      Entrega.xCpl    := '';
      Entrega.xBairro := '';
      Entrega.cMun    := 0;
      Entrega.xMun    := '';
      Entrega.UF      := '';}

//Adicionando Produtos
      with Det.Add do
       begin
         Prod.nItem    := 1; // N�mero sequencial, para cada item deve ser incrementado
         Prod.cProd    := '123456';
         Prod.cEAN     := '7896523206646';
         Prod.xProd    := 'Descri��o do Produto';
         Prod.NCM      := '94051010'; // Tabela NCM dispon�vel em  http://www.receita.fazenda.gov.br/Aliquotas/DownloadArqTIPI.htm
         Prod.EXTIPI   := '';
         Prod.CFOP     := '5101';
         Prod.uCom     := 'UN';
         Prod.qCom     := 1 ;
         Prod.vUnCom   := 100;
         Prod.vProd    := 100 ;

         Prod.cEANTrib  := '7896523206646';
         Prod.uTrib     := 'UN';
         Prod.qTrib     := 1;
         Prod.vUnTrib   := 100;

         Prod.vOutro    := 0;
         Prod.vFrete    := 0;
         Prod.vSeg      := 0;
         Prod.vDesc     := 0;

         Prod.CEST := '1111111';

//         infAdProd      := 'Informa��o Adicional do Produto';

         with Imposto do
          begin
            // lei da transparencia nos impostos
            vTotTrib := 0;

            with ICMS do
             begin
               CST          := cst00;
               ICMS.orig    := oeNacional;
               ICMS.modBC   := dbiValorOperacao;
               ICMS.vBC     := 100;
               ICMS.pICMS   := 18;
               ICMS.vICMS   := 18;
               ICMS.modBCST := dbisMargemValorAgregado;
               ICMS.pMVAST  := 0;
               ICMS.pRedBCST:= 0;
               ICMS.vBCST   := 0;
               ICMS.pICMSST := 0;
               ICMS.vICMSST := 0;
               ICMS.pRedBC  := 0;

               // partilha do ICMS e fundo de probreza
               with ICMSUFDest do
                begin
                  vBCUFDest      := 0.00;
                  pFCPUFDest     := 0.00;
                  pICMSUFDest    := 0.00;
                  pICMSInter     := 0.00;
                  pICMSInterPart := 0.00;
                  vFCPUFDest     := 0.00;
                  vICMSUFDest    := 0.00;
                  vICMSUFRemet   := 0.00;
                end;
             end;
{            with PIS do
             begin
               CST      := pis99;
               PIS.vBC  := 0;
               PIS.pPIS := 0;
               PIS.vPIS := 0;

               PIS.qBCProd   := 0;
               PIS.vAliqProd := 0;
               PIS.vPIS      := 0;
             end;

            with PISST do
             begin
               vBc       := 0;
               pPis      := 0;
               qBCProd   := 0;
               vAliqProd := 0;
               vPIS      := 0;
             end;

            with COFINS do
             begin
               CST            := cof99;
               COFINS.vBC     := 0;
               COFINS.pCOFINS := 0;
               COFINS.vCOFINS := 0;

               COFINS.qBCProd   := 0;
               COFINS.vAliqProd := 0;
             end;

            with COFINSST do
             begin
               vBC       := 0;
               pCOFINS   := 0;
               qBCProd   := 0;
               vAliqProd := 0;
               vCOFINS   := 0;
             end;
}
//Grupo para servi�os
{            with ISSQN do
             begin
               vBC       := 0;
               vAliq     := 0;
               vISSQN    := 0;
               cMunFG    := 0;
               cListServ := 1402; // Preencha este campo usando a tabela dispon�vel
                               // em http://www.planalto.gov.br/Ccivil_03/LEIS/LCP/Lcp116.htm
      {       end;}
          end;
       end ;

//Adicionando Servi�os
{      with Det.Add do
       begin
         Prod.nItem    := 1; // N�mero sequencial, para cada item deve ser incrementado
         Prod.cProd    := '123457';
         Prod.cEAN     := '';
         Prod.xProd    := 'Descri��o do Servi�o';
         Prod.NCM      := '99';
         Prod.EXTIPI   := '';
         Prod.CFOP     := '5933';
         Prod.uCom     := 'UN';
         Prod.qCom     := 1 ;
         Prod.vUnCom   := 100;
         Prod.vProd    := 100 ;

         Prod.cEANTrib  := '';
         Prod.uTrib     := 'UN';
         Prod.qTrib     := 1;
         Prod.vUnTrib   := 100;

         Prod.vFrete    := 0;
         Prod.vSeg      := 0;
         Prod.vDesc     := 0;

         infAdProd      := 'Informa��o Adicional do Servi�o';

//Grupo para servi�os
            with Imposto.ISSQN do
             begin
               cSitTrib  := ISSQNcSitTribNORMAL;
               vBC       := 100;
               vAliq     := 2;
               vISSQN    := 2;
               cMunFG    := 3554003;
               cListServ := 1402; // Preencha este campo usando a tabela dispon�vel
                               // em http://www.planalto.gov.br/Ccivil_03/LEIS/LCP/Lcp116.htm
             end;
       end ;
}
      Total.ICMSTot.vBC     := 100;
      Total.ICMSTot.vICMS   := 18;
      Total.ICMSTot.vBCST   := 0;
      Total.ICMSTot.vST     := 0;
      Total.ICMSTot.vProd   := 100;
      Total.ICMSTot.vFrete  := 0;
      Total.ICMSTot.vSeg    := 0;
      Total.ICMSTot.vDesc   := 0;
      Total.ICMSTot.vII     := 0;
      Total.ICMSTot.vIPI    := 0;
      Total.ICMSTot.vPIS    := 0;
      Total.ICMSTot.vCOFINS := 0;
      Total.ICMSTot.vOutro  := 0;
      Total.ICMSTot.vNF     := 100;

      // partilha do icms e fundo de probreza
      Total.ICMSTot.vFCPUFDest   := 0.00;
      Total.ICMSTot.vICMSUFDest  := 0.00;
      Total.ICMSTot.vICMSUFRemet := 0.00;

      Total.ISSQNtot.vServ   := 0;
      Total.ISSQNTot.vBC     := 0;
      Total.ISSQNTot.vISS    := 0;
      Total.ISSQNTot.vPIS    := 0;
      Total.ISSQNTot.vCOFINS := 0;

{      Total.retTrib.vRetPIS    := 0;
      Total.retTrib.vRetCOFINS := 0;
      Total.retTrib.vRetCSLL   := 0;
      Total.retTrib.vBCIRRF    := 0;
      Total.retTrib.vIRRF      := 0;
      Total.retTrib.vBCRetPrev := 0;
      Total.retTrib.vRetPrev   := 0;}

      Transp.modFrete := mfSemFrete; // NFC-e n�o pode ter FRETE

{      Cobr.Fat.nFat  := 'Numero da Fatura';
      Cobr.Fat.vOrig := 100 ;
      Cobr.Fat.vDesc := 0 ;
      Cobr.Fat.vLiq  := 100 ;

      with Cobr.Dup.Add do
       begin
         nDup  := '1234';
         dVenc := now+10;
         vDup  := 50;
       end;

      with Cobr.Dup.Add do
       begin
         nDup  := '1235';
         dVenc := now+10;
         vDup  := 50;
       end;
 }

      with pag.Add do //PAGAMENTOS apenas para NFC-e
       begin
         tPag := fpDinheiro;
         vPag := 100;
       end;

      InfAdic.infCpl     :=  '';
      InfAdic.infAdFisco :=  '';

{      with InfAdic.obsCont.Add do
       begin
         xCampo := 'ObsCont';
         xTexto := 'Texto';
       end;

      with InfAdic.obsFisco.Add do
       begin
         xCampo := 'ObsFisco';
         xTexto := 'Texto';
       end; }
   end;

   ACBrNFe1.NotasFiscais.GerarNFe;
end;

procedure TForm1.btnConsultarChaveClick(Sender: TObject);
var
 vChave : String;
begin
  if not(InputQuery('WebServices Consultar', 'Chave da NF-e:', vChave)) then
    exit;

  ACBrNFe1.NotasFiscais.Clear;
  ACBrNFe1.WebServices.Consulta.NFeChave := vChave;
  ACBrNFe1.WebServices.Consulta.Executar;

  MemoResp.Lines.Text := ACBrNFe1.WebServices.Consulta.RetWS;
  memoRespWS.Lines.Text := ACBrNFe1.WebServices.Consulta.RetornoWS;
  LoadXML(ACBrNFe1.WebServices.Consulta.RetornoWS, WBResposta);
  LoadConsulta201(ACBrNFe1.WebServices.Consulta.RetWS);
end;

procedure TForm1.btnCancelarChaveClick(Sender: TObject);
var
 Chave, idLote, CNPJ, Protocolo, Justificativa : string;
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

  ACBrNFe1.EventoNFe.Evento.Clear;
//  ACBrNFe1.EvnvEvento.EnvEventoNFe.idLote := StrToInt(idLote) ;
  with ACBrNFe1.EventoNFe.Evento.Add do
   begin
     infEvento.chNFe := Chave;
     infEvento.CNPJ   := CNPJ;
     infEvento.dhEvento := now;
     infEvento.tpEvento := teCancelamento;
     infEvento.detEvento.xJust := Justificativa;
     infEvento.detEvento.nProt := Protocolo;
   end;
  ACBrNFe1.EnviarEvento(StrToInt(idLote));

  MemoResp.Lines.Text := ACBrNFe1.WebServices.EnvEvento.RetWS;
  memoRespWS.Lines.Text := ACBrNFe1.WebServices.EnvEvento.RetornoWS;
  LoadXML(ACBrNFe1.WebServices.EnvEvento.RetornoWS, WBResposta);

  {ACBrNFe1.WebServices.EnvEvento.EventoRetorno.TpAmb
  ACBrNFe1.WebServices.EnvEvento.EventoRetorno.verAplic
  ACBrNFe1.WebServices.EnvEvento.EventoRetorno.cStat
  ACBrNFe1.WebServices.EnvEvento.EventoRetorno.xMotivo
  ACBrNFe1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.chNFe
  ACBrNFe1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento
  ACBrNFe1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].RetInfEvento.nProt}
end;

procedure TForm1.bAbreVendeSubTotaliza2Click(Sender: TObject);
begin
   ACBrTEFD1.ConfirmarTransacoesPendentes;
end;

procedure TForm1.bAbreVendeSubTotaliza3Click(Sender: TObject);
begin
   ACBrTEFD1.ImprimirTransacoesPendentes;
end;

procedure TForm1.bADMClick(Sender: TObject);
begin
  if estadoSimuladoEcf <> tpsLivre then
    raise Exception.Create('Estado do Simulador ECF deve ser Livre');

  ACBrTEFD1.ADM(TACBrTEFDTipo(cbxGP1.ItemIndex ));
  MemoCupomTEF.Lines.Add('Administrativo TEF');
end;

procedure TForm1.bAtivarGPClick(Sender: TObject);
begin
  ACBrTEFD1.AtivarGP( TACBrTEFDTipo( cbxGP.ItemIndex ) );
  AvaliaTEFs;
  MemoCupomTEF.Lines.Add('AtivarGP');
end;

function TForm1.verificarSaldoRestante : Currency;
begin
  EditSaldoRestante.Text := CurrToStr(StringToFloatDef(edValorVenda.Text, 0) - StringToFloatDef(EditTotalPago.Text, 0));

  Result := StringToFloatDef(EditTotalPago.Text, 0);

  if StringToFloatDef(EditTotalPago.Text, 0) = StringToFloatDef(edValorVenda.Text, 0) then
    Result := 0;
end;

procedure TForm1.ButtonPagarEmCartaoClick(Sender: TObject);
begin
  EfetuaPagamento(tpCartao);
end;

procedure TForm1.ButtonPagarEmDinheiroClick(Sender: TObject);
begin
  EfetuaPagamento(tpDinheiro);
end;

procedure TForm1.EfetuaPagamento(formaPagamento : tpPagamento);
var
  StatusTransacao : Boolean;
begin

  if StrToCurrDef(Trim(EditSaldoRestante.Text), 0) <= 0 then
    raise Exception.Create('Todos os Valores foram totalizados');

  if StrToCurrDef(Trim(edValorPagamento.Text), 0) <= 0 then
    raise Exception.Create('Valores de pagamento n�o deve ser Zero');

  if formaPagamento = tpDinheiro then
  begin
    MemoCupomTEF.Lines.Add('Pagamento [Dinheiro:' + edValorPagamento.Text + ']');
    {Tratar com sua rotina em dinheiro}
  end
  else if formaPagamento = tpCartao then
  begin

    if not(ACBrTEFD1.Inicializado(TACBrTEFDTipo( cbxGP.ItemIndex ))) then
      raise Exception.Create('ACBrTEFD n�o inicializado.');

    StatusTransacao := ACBrTEFD1.CRT( StringToFloatDef(edValorPagamento.Text, 0) , '02', trim(EditNumNFCe.Text));

    if StatusTransacao then
    begin
      Inc(IndiceTransacaoTef);

      if not(ACBrTEFD1.AutoFinalizarCupom) then
        MemoCupomTEF.Lines.Add('Pagamento [Cartao:' + edValorPagamento.Text + '][NSU:'+ACBrTEFD1.RespostasPendentes[IndiceTransacaoTef].NSU + '][Rede:'+ACBrTEFD1.RespostasPendentes[IndiceTransacaoTef].Rede+ ']');

      Application.MessageBox('Transa��o aprovada, Favor Travar o dados do comprovante', 'Informa��o', MB_OK + MB_ICONINFORMATION);
    end
    else
    begin
      MemoCupomTEF.Lines.Add('Transa��o Negada');
      Application.MessageBox('Transa��o Negada', 'Informa��o', MB_OK + MB_ICONWARNING);
      Exit;
    end;
  end;

  EditTotalPago.Text := FloatToStr(StringToFloatDef(EditTotalPago.Text, 0) + StringToFloatDef(edValorPagamento.Text, 0));

  if verificarSaldoRestante = 0 then
  begin
    finalizarCupomNFCe;
    //Limpar campos
    edValorVenda.Text       := '0';
    edValorPagamento.Text   := '0';
    EditTotalPago.Text      := '0';
    EditSaldoRestante.Text  := '0';
    MemoCupomTEF.Lines.Add('Venda Conclu�da');
    MemoCupomTEF.Lines.Add('');
    EditNumNFCe.Text := IntToStr(StrToIntDef(EditNumNFCe.Text, 0) + 1);
    Application.MessageBox('Venda Conclu�da', 'Informa��o', MB_OK + MB_ICONINFORMATION);
  end
  else
    edValorPagamento.Text := EditSaldoRestante.Text;
end;

procedure TForm1.finalizarCupomNFCe;
var
  StrDescMensagem : string;
begin
  travarComponentesTEF(False);

  if not(enviarNFCeTEF(EditNumNFCe.Text, StrDescMensagem)) {Tenta emitir a NFCe em Modo Normal}then
  begin
    Application.MessageBox(pchar('Ocorreu um erro ao enviar a NFCe em modo normal.' + sLineBreak +
                           'Sistema emitir� em modo "OFFLINE/CONTING�NCIA"  ' + sLineBreak +
                           '#Programador tratar sua aplica��o para envio das NFCes emitidas off-line para SEFAZ Estadual' + sLineBreak +
                           StrDescMensagem), 'Informa��o', MB_OK + MB_ICONERROR);

    GerarNFCeTEF(EditNumNFCe.Text, StringToFloatDef(EditTotalPago.Text, 0), True);

    //Para offline deve Assinar e Validar e quardar o xml assinado para envio posterior
    //Imprimir NFCe em 2 vias quando offline
    MemoCupomTEF.Lines.Add('NFCe Off-Line');
    ACBrNFe1.NotasFiscais.Assinar;
    ACBrNFe1.NotasFiscais.Validar;
  end;

  MemoCupomTEF.Lines.Add('Imprimindo NFCe');
  if  Assigned( ACBrNFe1.DANFE ) then
    ACBrNFe1.NotasFiscais.Imprimir;

  MemoCupomTEF.Lines.Add('Imprimindo Transa��es/Comprovante TEF');
  ACBrTEFD1.ImprimirTransacoesPendentes;
  estadoSimuladoEcf := tpsLivre;
end;


procedure TForm1.travarComponentesTEF(abriuVenda : Boolean);
begin
  EditNumNFCe.Enabled           := not(abriuVenda);
  edValorVenda.Enabled          := not(abriuVenda);
  ButtonIniciaVenda.Enabled     := not(abriuVenda);

  ButtonCancelarVenda.Enabled   := abriuVenda;
  edValorPagamento.Enabled      := abriuVenda;
  ButtonPagarEmDinheiro.Enabled := abriuVenda;
  ButtonPagarEmCartao.Enabled   := abriuVenda;
end;

procedure TForm1.bInicializarClick(Sender: TObject);
begin
  if bInicializar.Caption = 'Inicializar' then
  begin
    edValorPagamento.Clear;
    travarComponentesTEF(False);
    estadoSimuladoEcf := tpsLivre;
    ACBrTEFD1.Inicializar( TACBrTEFDTipo( cbxGP.ItemIndex ) );
    pgRespostas.ActivePage := TabSheetCupomTef;
    MemoCupomTEF.Lines.Add('Inicializar');
     bInicializar.Caption := 'DesInicializar' ;
  end
  else
  begin
    ACBrTEFD1.DesInicializar( TACBrTEFDTipo( cbxGP.ItemIndex ) );
    MemoCupomTEF.Lines.Add('ACBrTEFD.DesInicializar Executado' );
    bInicializar.Caption := 'Inicializar' ;
  end;

  AvaliaTEFs;

end;

procedure TForm1.AvaliaTEFs;
begin
  if ACBrTEFD1.TEFDial.Inicializado then
     sTEFDial.Brush.Color := clLime
  else
     sTEFDial.Brush.Color := clRed ;
  ckTEFDIAL.Checked := ACBrTEFD1.TEFDial.Habilitado;

  if ACBrTEFD1.TEFDisc.Inicializado then
     sTEFDisc.Brush.Color := clLime
  else
     sTEFDisc.Brush.Color := clRed ;
  ckTEFDISC.Checked := ACBrTEFD1.TEFDisc.Habilitado;

  if ACBrTEFD1.TEFHiper.Inicializado then
     sHiperTEF.Brush.Color := clLime
  else
     sHiperTEF.Brush.Color := clRed ;
  ckHIPERTEF.Checked := ACBrTEFD1.TEFHiper.Habilitado;

  if ACBrTEFD1.TEFCliSiTef.Inicializado then
     sCliSiTef.Brush.Color := clLime
  else
     sCliSiTef.Brush.Color := clRed ;
  ckCliSiTef.Checked := ACBrTEFD1.TEFCliSiTef.Habilitado;

  if ACBrTEFD1.TEFVeSPague.Inicializado then
     sVSPague.Brush.Color := clLime
  else
     sVSPague.Brush.Color := clRed ;
  ckVSPague.Checked := ACBrTEFD1.TEFVeSPague.Habilitado;


  if ACBrTEFD1.TEFAuttar.Inicializado then
     sAuttar.Brush.Color := clLime
  else
     sAuttar.Brush.Color := clRed ;
  ckAuttar.Checked := ACBrTEFD1.TEFAuttar.Habilitado;

  cbxGP.ItemIndex  := Integer( ACBrTEFD1.GPAtual ) ;
  cbxGP1.ItemIndex := cbxGP.ItemIndex ;
end;

procedure TForm1.btnAdicionarProtNFeClick(Sender: TObject);
var
  NomeArq : String;
begin
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if OpenDialog1.Execute then
  begin
    ACBrNFe1.NotasFiscais.Clear;
    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
    ACBrNFe1.Consultar;
    ShowMessage(ACBrNFe1.WebServices.Consulta.Protocolo);
    MemoResp.Lines.Text := ACBrNFe1.WebServices.Consulta.RetWS;
    memoRespWS.Lines.Text := ACBrNFe1.WebServices.Consulta.RetornoWS;
    LoadXML(ACBrNFe1.WebServices.Consulta.RetornoWS, WBResposta);
    NomeArq := OpenDialog1.FileName;
    if pos(UpperCase('-nfe.xml'),UpperCase(NomeArq)) > 0 then
       NomeArq := StringReplace(NomeArq,'-nfe.xml','-procNfe.xml',[rfIgnoreCase]);
    ACBrNFe1.NotasFiscais.Items[0].GravarXML(NomeArq);
    ShowMessage('Arquivo gravado em: '+NomeArq);
    memoLog.Lines.Add('Arquivo gravado em: '+NomeArq);
  end;
end;

procedure TForm1.btnCarregarXMLEnviarClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if OpenDialog1.Execute then
  begin
    ACBrNFe1.NotasFiscais.Clear;
    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName, False);

 {   with ACBrNFe1.NotasFiscais.Items[0].NFe do
     begin
       Emit.CNPJCPF           := edtEmitCNPJ.Text;
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
       Emit.enderEmit.cPais   := 1058;
       Emit.enderEmit.xPais   := 'BRASIL';

       Emit.IEST              := '';
       Emit.IM                := ''; // Preencher no caso de existir servi�os na nota
       Emit.CNAE              := ''; // Verifique na cidade do emissor da NFe se � permitido
                                    // a inclus�o de servi�os na NFe
       Emit.CRT               := crtRegimeNormal;// (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)
    end;}
    //ACBrNFe1.NotasFiscais.GerarNFe;
    //ACBrNFe1.NotasFiscais.GravarXML('c:\temp\teste.xml');
    ACBrNFe1.Enviar(1,True);

    MemoResp.Lines.Text := ACBrNFe1.WebServices.Retorno.RetWS;
    memoRespWS.Lines.Text := ACBrNFe1.WebServices.Retorno.RetornoWS;
    LoadXML(ACBrNFe1.WebServices.Retorno.RetornoWS, WBResposta);

   MemoDados.Lines.Add('');
   MemoDados.Lines.Add('Envio NFe');
   MemoDados.Lines.Add('tpAmb: '+ TpAmbToStr(ACBrNFe1.WebServices.Retorno.TpAmb));
   MemoDados.Lines.Add('verAplic: '+ ACBrNFe1.WebServices.Retorno.verAplic);
   MemoDados.Lines.Add('cStat: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cStat));
   MemoDados.Lines.Add('cUF: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cUF));
   MemoDados.Lines.Add('xMotivo: '+ ACBrNFe1.WebServices.Retorno.xMotivo);
   MemoDados.Lines.Add('cMsg: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cMsg));
   MemoDados.Lines.Add('xMsg: '+ ACBrNFe1.WebServices.Retorno.xMsg);
   MemoDados.Lines.Add('Recibo: '+ ACBrNFe1.WebServices.Retorno.Recibo);
   MemoDados.Lines.Add('Protocolo: '+ ACBrNFe1.WebServices.Retorno.Protocolo);
  end;
end;

procedure TForm1.btnCartadeCorrecaoClick(Sender: TObject);
var
 Chave, idLote, CNPJ, nSeqEvento, Correcao : string;
begin
  if not(InputQuery('WebServices Eventos: Carta de Corre��o', 'Chave da NF-e', Chave)) then
     exit;
  Chave := Trim(OnlyNumber(Chave));
  idLote := '1';
  if not(InputQuery('WebServices Eventos: Carta de Corre��o', 'Identificador de controle do Lote de envio do Evento', idLote)) then
     exit;
  CNPJ := copy(Chave,7,14);
  if not(InputQuery('WebServices Eventos: Carta de Corre��o', 'CNPJ ou o CPF do autor do Evento', CNPJ)) then
     exit;
  nSeqEvento := '1';
  if not(InputQuery('WebServices Eventos: Carta de Corre��o', 'Sequencial do evento para o mesmo tipo de evento', nSeqEvento)) then
     exit;
  Correcao := 'Corre��o a ser considerada, texto livre. A corre��o mais recente substitui as anteriores.';
  if not(InputQuery('WebServices Eventos: Carta de Corre��o', 'Corre��o a ser considerada', Correcao)) then
     exit;
  ACBrNFe1.EventoNFe.Evento.Clear;
//  ACBrNFe1.EnvEvento.EnvEventoNFe..idLote := StrToInt(idLote) ;
  with ACBrNFe1.EventoNFe.Evento.Add do
   begin
     infEvento.chNFe := Chave;
     infEvento.CNPJ   := CNPJ;
     infEvento.dhEvento := now;
     infEvento.tpEvento := teCCe;
     infEvento.nSeqEvento := StrToInt(nSeqEvento);
     infEvento.detEvento.xCorrecao := Correcao;
   end;
  ACBrNFe1.EnviarEvento(StrToInt(idLote));

  MemoResp.Lines.Text := ACBrNFe1.WebServices.EnvEvento.RetWS;
  //memoRespWS.Lines.Text := ACBrNFe1.WebServices.EnvEvento.EventoRetorno;
//  ACBrNFe1.WebServices.EnvEvento.EventoRetorno.retEvento.Items[0].XXXX
  LoadXML(ACBrNFe1.WebServices.EnvEvento.RetWS, WBResposta);
end;

procedure TForm1.btnValidarAssinaturaClick(Sender: TObject);
var
  Msg : String;
begin
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*-nfe.XML';
  OpenDialog1.Filter := 'Arquivos NFE (*-nfe.XML)|*-nfe.XML|Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if OpenDialog1.Execute then
  begin
    ACBrNFe1.NotasFiscais.Clear;
    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
    if not ACBrNFe1.NotasFiscais.VerificarAssinatura(Msg) then
      MemoDados.Lines.Add('Erro: '+Msg)
    else
      ShowMessage('Assinatura V�lida');  
  end;
end;

procedure TForm1.btnImprimirCCeClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*.XML';
  OpenDialog1.Filter := 'Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if OpenDialog1.Execute then
  begin
    ACBrNFe1.NotasFiscais.Clear;
    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
  end;

  OpenDialog1.Title := 'Selecione o Evento';
  OpenDialog1.DefaultExt := '*.XML';
  OpenDialog1.Filter := 'Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if OpenDialog1.Execute then
  begin
    ACBrNFe1.EventoNFe.Evento.Clear;
    ACBrNFe1.EventoNFe.LerXML(OpenDialog1.FileName) ;
    ACBrNFe1.ImprimirEvento;
  end;
//  LoadXML(MemoResp, WBResposta);
end;

procedure TForm1.btnEnviarEventoClick(Sender: TObject);
var
 Para : String;
 CC, Evento: Tstrings;
begin
  if not(InputQuery('Enviar Email', 'Email de destino', Para)) then
    exit;
    
  OpenDialog1.Title := 'Selecione a NFE';
  OpenDialog1.DefaultExt := '*.XML';
  OpenDialog1.Filter := 'Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if OpenDialog1.Execute then
  begin
    ACBrNFe1.NotasFiscais.Clear;
    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
  end;

  OpenDialog1.Title := 'Selecione ao Evento';
  OpenDialog1.DefaultExt := '*.XML';
  OpenDialog1.Filter := 'Arquivos XML (*.XML)|*.XML|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFe1.Configuracoes.Arquivos.PathSalvar;
  if not OpenDialog1.Execute then
    Exit;

  Evento := TStringList.Create;
  CC := TStringList.Create;
  try
    Evento.Clear;
    Evento.Add(OpenDialog1.FileName);
    ACBrNFe1.EventoNFe.Evento.Clear;
    ACBrNFe1.EventoNFe.LerXML(OpenDialog1.FileName) ;

    //CC.Add('email_1@provedor.com'); //especifique um email v�lido
    //CC.Add('email_2@provedor.com.br');    //especifique um email v�lido
    ConfigurarEmail;
    ACBrNFe1.EnviarEmailEvento(Para
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

procedure TForm1.btnCriarEnviarNFCeClick(Sender: TObject);
var
 vAux, vNumLote, vSincrono : String;
 Sincrono : boolean;
begin

  if not(InputQuery('WebServices Enviar', 'Numero da Nota', vAux)) then
    exit;

  if not(InputQuery('WebServices Enviar', 'Numero do Lote', vNumLote)) then
    exit;

  vSincrono := '1';
  if not(InputQuery('WebServices Enviar', 'Envio S�ncrono(1=Sim, 0=N�o)', vSincrono)) then
    exit;

  vNumLote := OnlyNumber(vNumLote);

  if Trim(vNumLote) = '' then
   begin
     MessageDlg('N�mero do Lote inv�lido.',mtError,[mbok],0);
     exit;
   end;

  if (Trim(vSincrono) <> '1') and
     (Trim(vSincrono) <> '0') then
   begin
     MessageDlg('Valor Inv�lido.',mtError,[mbok],0);
     exit;
   end;

  if (Trim(vSincrono) = '1') then
    Sincrono := True
  else
    Sincrono := False;

  ACBrNFe1.NotasFiscais.Clear;

  ACBrNFe1.Configuracoes.Geral.ModeloDF := moNFCe;
  ACBrNFe1.Configuracoes.Geral.VersaoDF := ve310;
  GerarNFCe(vAux);

  ACBrNFe1.Enviar(vNumLote,True,Sincrono);

  if not Sincrono then
  begin
    MemoResp.Lines.Text := ACBrNFe1.WebServices.Retorno.RetWS;
    memoRespWS.Lines.Text := ACBrNFe1.WebServices.Retorno.RetornoWS;
    LoadXML(ACBrNFe1.WebServices.Retorno.RetWS, WBResposta);

    MemoDados.Lines.Add('');
    MemoDados.Lines.Add('Envio NFCe');
    MemoDados.Lines.Add('tpAmb: '+ TpAmbToStr(ACBrNFe1.WebServices.Retorno.TpAmb));
    MemoDados.Lines.Add('verAplic: '+ ACBrNFe1.WebServices.Retorno.verAplic);
    MemoDados.Lines.Add('cStat: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cStat));
    MemoDados.Lines.Add('cUF: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cUF));
    MemoDados.Lines.Add('xMotivo: '+ ACBrNFe1.WebServices.Retorno.xMotivo);
    MemoDados.Lines.Add('cMsg: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cMsg));
    MemoDados.Lines.Add('xMsg: '+ ACBrNFe1.WebServices.Retorno.xMsg);
    MemoDados.Lines.Add('Recibo: '+ ACBrNFe1.WebServices.Retorno.Recibo);
    MemoDados.Lines.Add('Protocolo: '+ ACBrNFe1.WebServices.Retorno.Protocolo);
  end
  else
  begin
    MemoResp.Lines.Text := ACBrNFe1.WebServices.Enviar.RetWS;
    memoRespWS.Lines.Text := ACBrNFe1.WebServices.Enviar.RetornoWS;
    LoadXML(ACBrNFe1.WebServices.Enviar.RetWS, WBResposta);

    MemoDados.Lines.Add('');
    MemoDados.Lines.Add('Envio NFCe');
    MemoDados.Lines.Add('tpAmb: '+ TpAmbToStr(ACBrNFe1.WebServices.Enviar.TpAmb));
    MemoDados.Lines.Add('verAplic: '+ ACBrNFe1.WebServices.Enviar.verAplic);
    MemoDados.Lines.Add('cStat: '+ IntToStr(ACBrNFe1.WebServices.Enviar.cStat));
    MemoDados.Lines.Add('cUF: '+ IntToStr(ACBrNFe1.WebServices.Enviar.cUF));
    MemoDados.Lines.Add('xMotivo: '+ ACBrNFe1.WebServices.Enviar.xMotivo);
    //MemoDados.Lines.Add('cMsg: '+ IntToStr(ACBrNFe1.WebServices.Enviar.cMsg));
    //MemoDados.Lines.Add('xMsg: '+ ACBrNFe1.WebServices.Enviar.xMsg);
    MemoDados.Lines.Add('Recibo: '+ ACBrNFe1.WebServices.Enviar.Recibo);
    //MemoDados.Lines.Add('Protocolo: '+ ACBrNFe1.WebServices.Enviar.Protocolo);
  end;

  ACBrNFe1.NotasFiscais.Clear;
end;

procedure TForm1.btnDistribuicaoDFeClick(Sender: TObject);
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

   ACBrNFe1.DistribuicaoDFe(StrToInt(cUFAutor),CNPJ,ultNSU,ANSU);

  MemoResp.Lines.Text := ACBrNFe1.WebServices.DistribuicaoDFe.RetWS;
  memoRespWS.Lines.Text := ACBrNFe1.WebServices.DistribuicaoDFe.RetornoWS;

  LoadXML(ACBrNFe1.WebServices.DistribuicaoDFe.RetWS, WBResposta);

  ACBrNFe1.Free;
end;

procedure TForm1.PathClick(Sender: TObject);
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

procedure TForm1.sbPathNFeClick(Sender: TObject);
begin
 PathClick(edtPathNFe);
end;

procedure TForm1.sbPathCanClick(Sender: TObject);
begin
 PathClick(edtPathCan);
end;

procedure TForm1.sbPathCCeClick(Sender: TObject);
begin
 PathClick(edtPathCCe);
end;

procedure TForm1.sbPathInuClick(Sender: TObject);
begin
 PathClick(edtPathInu);
end;

procedure TForm1.sbPathDPECClick(Sender: TObject);
begin
 PathClick(edtPathDPEC);
end;

procedure TForm1.sbPathEventoClick(Sender: TObject);
begin
 PathClick(edtPathEvento);
end;

procedure TForm1.spPathSchemasClick(Sender: TObject);
begin
 PathClick(edtPathSchemas);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage( FormatDateBr(ACBrNFe1.SSL.CertDataVenc) );
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowMessage( ACBrNFe1.SSL.CertNumeroSerie );
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ShowMessage( ACBrNFe1.SSL.CertSubjectName + sLineBreak + sLineBreak +
               'Raz�o Social: '+ACBrNFe1.SSL.CertRazaoSocial);   
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ShowMessage( ACBrNFe1.SSL.CertCNPJ );
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  Ahash: String;
begin
  Ahash := ACBrNFe1.SSL.CalcHash(Edit1.Text, dgstSHA256, outBase64, cbAssinar.Checked);
  MemoResp.Lines.Add( Ahash );
end;

procedure TForm1.Button6Click(Sender: TObject);
var
 vAux, vNumLote, vSincrono : String;
 Sincrono : boolean;
 valorPagamento : Currency;
begin

  valorPagamento := StrToCurr(Trim(edValorPagamento.Text));

  if valorPagamento = 0 then
    raise Exception.Create('Valor de pagamento inv�lido');

  if not(InputQuery('WebServices Enviar', 'Numero da Nota', vAux)) then
    exit;

  vAux := trim(EditNumNFCe.Text);

  if vAux = '' then
    raise Exception.Create('N�m. NFCe inv�lido');

  vNumLote := '0';
  if not(InputQuery('WebServices Enviar', 'Numero do Lote', vNumLote)) then
    exit;

  vSincrono := '1';
  if not(InputQuery('WebServices Enviar', 'Envio S�ncrono(1=Sim, 0=N�o)', vSincrono)) then
    exit;

  vNumLote := OnlyNumber(vNumLote);

  if Trim(vNumLote) = '' then
   begin
     MessageDlg('N�mero do Lote inv�lido.',mtError,[mbok],0);
     exit;
   end;

  if (Trim(vSincrono) <> '1') and
     (Trim(vSincrono) <> '0') then
   begin
     MessageDlg('Valor Inv�lido.',mtError,[mbok],0);
     exit;
   end;

  if (Trim(vSincrono) = '1') then
    Sincrono := True
  else
    Sincrono := False;

  ACBrNFe1.NotasFiscais.Clear;

  ACBrNFe1.Configuracoes.Geral.ModeloDF := moNFCe;
  ACBrNFe1.Configuracoes.Geral.VersaoDF := ve310;
  GerarNFCeTEF(vAux, valorPagamento, False);

  ACBrNFe1.Enviar(vNumLote,True,Sincrono);

  if not Sincrono then
  begin
    MemoResp.Lines.Text := ACBrNFe1.WebServices.Retorno.RetWS;
    memoRespWS.Lines.Text := ACBrNFe1.WebServices.Retorno.RetornoWS;
    LoadXML(ACBrNFe1.WebServices.Retorno.RetWS, WBResposta);

    MemoDados.Lines.Add('');
    MemoDados.Lines.Add('Envio NFCe');
    MemoDados.Lines.Add('tpAmb: '+ TpAmbToStr(ACBrNFe1.WebServices.Retorno.TpAmb));
    MemoDados.Lines.Add('verAplic: '+ ACBrNFe1.WebServices.Retorno.verAplic);
    MemoDados.Lines.Add('cStat: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cStat));
    MemoDados.Lines.Add('cUF: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cUF));
    MemoDados.Lines.Add('xMotivo: '+ ACBrNFe1.WebServices.Retorno.xMotivo);
    MemoDados.Lines.Add('cMsg: '+ IntToStr(ACBrNFe1.WebServices.Retorno.cMsg));
    MemoDados.Lines.Add('xMsg: '+ ACBrNFe1.WebServices.Retorno.xMsg);
    MemoDados.Lines.Add('Recibo: '+ ACBrNFe1.WebServices.Retorno.Recibo);
    MemoDados.Lines.Add('Protocolo: '+ ACBrNFe1.WebServices.Retorno.Protocolo);
  end
  else
  begin
    MemoResp.Lines.Text := ACBrNFe1.WebServices.Enviar.RetWS;
    memoRespWS.Lines.Text := ACBrNFe1.WebServices.Enviar.RetornoWS;
    LoadXML(ACBrNFe1.WebServices.Enviar.RetWS, WBResposta);

    MemoDados.Lines.Add('');
    MemoDados.Lines.Add('Envio NFCe');
    MemoDados.Lines.Add('tpAmb: '+ TpAmbToStr(ACBrNFe1.WebServices.Enviar.TpAmb));
    MemoDados.Lines.Add('verAplic: '+ ACBrNFe1.WebServices.Enviar.verAplic);
    MemoDados.Lines.Add('cStat: '+ IntToStr(ACBrNFe1.WebServices.Enviar.cStat));
    MemoDados.Lines.Add('cUF: '+ IntToStr(ACBrNFe1.WebServices.Enviar.cUF));
    MemoDados.Lines.Add('xMotivo: '+ ACBrNFe1.WebServices.Enviar.xMotivo);
    //MemoDados.Lines.Add('cMsg: '+ IntToStr(ACBrNFe1.WebServices.Enviar.cMsg));
    //MemoDados.Lines.Add('xMsg: '+ ACBrNFe1.WebServices.Enviar.xMsg);
    MemoDados.Lines.Add('Recibo: '+ ACBrNFe1.WebServices.Enviar.Recibo);
    //MemoDados.Lines.Add('Protocolo: '+ ACBrNFe1.WebServices.Enviar.Protocolo);
  end;

  ACBrNFe1.NotasFiscais.Clear;
end;

procedure TForm1.ButtonCancelarVendaClick(Sender: TObject);
begin
  edValorPagamento.Clear;
  MemoCupomTEF.Lines.Add('Venda Cancelada');
  travarComponentesTEF(False);
end;

procedure TForm1.ButtonIniciaVendaClick(Sender: TObject);
begin
  if StrToIntDef(EditNumNFCe.Text, 0) = 0 then
    raise Exception.Create('Informe o n�mero NFce');

  if StrToIntDef(edValorVenda.Text, 0) = 0 then
    raise Exception.Create('Informe o valor total da venda');

  MemoCupomTEF.Lines.Add('#################### NFCE:' + EditNumNFCe.Text + ' ####################');

  pgRespostas.ActivePage := TabSheetCupomTef;
  estadoSimuladoEcf := tpsVenda;
  EditTotalPago.Text := '0';
  EditSaldoRestante.Text := edValorVenda.Text;
  IndiceTransacaoTef     := -1;
  MemoCupomTEF.Lines.Add('Inicia Venda [Valor:' + edValorVenda.Text + ']');
  travarComponentesTEF(True);
end;

procedure TForm1.GerarNFCeTEF(NumNFe: String; valorVenda : Currency; emissaoOffLine: Boolean);
begin
  with ACBrNFe1.NotasFiscais.Add.NFe do
   begin
     Ide.cNF       := StrToInt(NumNFe); //Caso n�o seja preenchido ser� gerado um n�mero aleat�rio pelo componente
     Ide.natOp     := 'VENDA';
     Ide.indPag    := ipVista;
     Ide.modelo    := 65;
     Ide.serie     := 1;
     Ide.nNF       := StrToInt(NumNFe);
     Ide.dEmi      := now;
     Ide.dSaiEnt   := now;
     Ide.hSaiEnt   := now;
     Ide.tpNF      := tnSaida;
     Ide.tpEmis    := TpcnTipoEmissao(cbFormaEmissao.ItemIndex); ;
     Ide.tpAmb     := taHomologacao;  //Lembre-se de trocar esta variável quando for para ambiente de produção
     Ide.cUF       := UFtoCUF(edtEmitUF.Text);
     Ide.cMunFG    := StrToInt(edtEmitCodCidade.Text);
     Ide.finNFe    := fnNormal;
     Ide.tpImp     := tiNFCe;
     Ide.indFinal  := cfConsumidorFinal;
     Ide.indPres   := pcPresencial;

     if emissaoOffLine then
     begin
       Ide.dhCont := NOW;
       Ide.xJust  := 'Problemas t�cnicos no envio do cupom eletr�nico';
       Ide.tpEmis := teOffLine;
       ACBrNFe1.Configuracoes.Geral.FormaEmissao := teOffLine;
     end
     else
     begin
       Ide.tpEmis    := teNormal;
       ACBrNFe1.Configuracoes.Geral.FormaEmissao := teNormal;
     end;

//     Ide.dhCont := date;
//     Ide.xJust  := 'Justificativa Contingencia';

      Emit.CNPJCPF           := edtEmitCNPJ.Text;
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
      Emit.enderEmit.cPais   := 1058;
      Emit.enderEmit.xPais   := 'BRASIL';

      Emit.IEST              := '';
//      Emit.IM                := '2648800'; // Preencher no caso de existir servi�os na nota
//      Emit.CNAE              := '6201500'; // Verifique na cidade do emissor da NFe se � permitido
                                    // a inclus�o de servi�os na NFe
      Emit.CRT               := crtRegimeNormal;// (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)

      Dest.CNPJCPF           := '05481336000137';
//      Dest.IE                := '687138770110'; //NFC-e n�o aceita IE
      Dest.ISUF              := '';
      Dest.xNome             := 'D.J. COM. E LOCA��O DE SOFTWARES LTDA - ME';

      Dest.indIEDest    := inNaoContribuinte;
      Dest.EnderDest.Fone    := '1533243333';
      Dest.EnderDest.CEP     := 18270170;
      Dest.EnderDest.xLgr    := 'Rua Coronel Aureliano de Camargo';
      Dest.EnderDest.nro     := '973';
      Dest.EnderDest.xCpl    := '';
      Dest.EnderDest.xBairro := 'Centro';
      Dest.EnderDest.cMun    := 3554003;
      Dest.EnderDest.xMun    := 'Tatu�';
      Dest.EnderDest.UF      := 'SP';
      Dest.EnderDest.cPais   := 1058;
      Dest.EnderDest.xPais   := 'BRASIL';

//Use os campos abaixo para informar o endere�o de retirada quando for diferente do Remetente/Destinat�rio
{      Retirada.CNPJCPF := '';
      Retirada.xLgr    := '';
      Retirada.nro     := '';
      Retirada.xCpl    := '';
      Retirada.xBairro := '';
      Retirada.cMun    := 0;
      Retirada.xMun    := '';
      Retirada.UF      := '';}

//Use os campos abaixo para informar o endere�o de entrega quando for diferente do Remetente/Destinat�rio
{      Entrega.CNPJCPF := '';
      Entrega.xLgr    := '';
      Entrega.nro     := '';
      Entrega.xCpl    := '';
      Entrega.xBairro := '';
      Entrega.cMun    := 0;
      Entrega.xMun    := '';
      Entrega.UF      := '';}

//Adicionando Produtos
      with Det.Add do
       begin
         Prod.nItem    := 1; // N�mero sequencial, para cada item deve ser incrementado
         Prod.cProd    := '123456';
         Prod.cEAN     := '7896523206646';
         Prod.xProd    := 'Descri��o do Produto';
         Prod.NCM      := '94051010'; // Tabela NCM dispon�vel em  http://www.receita.fazenda.gov.br/Aliquotas/DownloadArqTIPI.htm
         Prod.EXTIPI   := '';
         Prod.CFOP     := '5101';
         Prod.uCom     := 'UN';
         Prod.qCom     := 1 ;
         Prod.vUnCom   := valorVenda;
         Prod.vProd    := valorVenda;

         Prod.cEANTrib  := '7896523206646';
         Prod.uTrib     := 'UN';
         Prod.qTrib     := 1;
         Prod.vUnTrib   := valorVenda;

         Prod.vOutro    := 0;
         Prod.vFrete    := 0;
         Prod.vSeg      := 0;
         Prod.vDesc     := 0;

         Prod.CEST := '1111111';

//         infAdProd      := 'Informa��o Adicional do Produto';

         with Imposto do
          begin
            // lei da transparencia nos impostos
            vTotTrib := 0;

            with ICMS do
             begin
               CST          := cst40;
               ICMS.orig    := oeNacional;
               ICMS.modBC   := dbiValorOperacao;
               ICMS.vBC     := 0;
               ICMS.pICMS   := 0;
               ICMS.vICMS   := 0;
               ICMS.modBCST := dbisMargemValorAgregado;
               ICMS.pMVAST  := 0;
               ICMS.pRedBCST:= 0;
               ICMS.vBCST   := 0;
               ICMS.pICMSST := 0;
               ICMS.vICMSST := 0;
               ICMS.pRedBC  := 0;

               // partilha do ICMS e fundo de probreza
               with ICMSUFDest do
                begin
                  vBCUFDest      := 0.00;
                  pFCPUFDest     := 0.00;
                  pICMSUFDest    := 0.00;
                  pICMSInter     := 0.00;
                  pICMSInterPart := 0.00;
                  vFCPUFDest     := 0.00;
                  vICMSUFDest    := 0.00;
                  vICMSUFRemet   := 0.00;
                end;
             end;
{            with PIS do
             begin
               CST      := pis99;
               PIS.vBC  := 0;
               PIS.pPIS := 0;
               PIS.vPIS := 0;

               PIS.qBCProd   := 0;
               PIS.vAliqProd := 0;
               PIS.vPIS      := 0;
             end;

            with PISST do
             begin
               vBc       := 0;
               pPis      := 0;
               qBCProd   := 0;
               vAliqProd := 0;
               vPIS      := 0;
             end;

            with COFINS do
             begin
               CST            := cof99;
               COFINS.vBC     := 0;
               COFINS.pCOFINS := 0;
               COFINS.vCOFINS := 0;

               COFINS.qBCProd   := 0;
               COFINS.vAliqProd := 0;
             end;

            with COFINSST do
             begin
               vBC       := 0;
               pCOFINS   := 0;
               qBCProd   := 0;
               vAliqProd := 0;
               vCOFINS   := 0;
             end;
}
//Grupo para servi�os
{            with ISSQN do
             begin
               vBC       := 0;
               vAliq     := 0;
               vISSQN    := 0;
               cMunFG    := 0;
               cListServ := 1402; // Preencha este campo usando a tabela dispon�vel
                               // em http://www.planalto.gov.br/Ccivil_03/LEIS/LCP/Lcp116.htm
      {       end;}
          end;
       end ;

//Adicionando Servi�os
{      with Det.Add do
       begin
         Prod.nItem    := 1; // N�mero sequencial, para cada item deve ser incrementado
         Prod.cProd    := '123457';
         Prod.cEAN     := '';
         Prod.xProd    := 'Descri��o do Servi�o';
         Prod.NCM      := '99';
         Prod.EXTIPI   := '';
         Prod.CFOP     := '5933';
         Prod.uCom     := 'UN';
         Prod.qCom     := 1 ;
         Prod.vUnCom   := 100;
         Prod.vProd    := 100 ;

         Prod.cEANTrib  := '';
         Prod.uTrib     := 'UN';
         Prod.qTrib     := 1;
         Prod.vUnTrib   := 100;

         Prod.vFrete    := 0;
         Prod.vSeg      := 0;
         Prod.vDesc     := 0;

         infAdProd      := 'Informa��o Adicional do Servi�o';

//Grupo para servi�os
            with Imposto.ISSQN do
             begin
               cSitTrib  := ISSQNcSitTribNORMAL;
               vBC       := 100;
               vAliq     := 2;
               vISSQN    := 2;
               cMunFG    := 3554003;
               cListServ := 1402; // Preencha este campo usando a tabela dispon�vel
                               // em http://www.planalto.gov.br/Ccivil_03/LEIS/LCP/Lcp116.htm
             end;
       end ;
}
      Total.ICMSTot.vBC     := 0;
      Total.ICMSTot.vICMS   := 0;
      Total.ICMSTot.vBCST   := 0;
      Total.ICMSTot.vST     := 0;
      Total.ICMSTot.vProd   := valorVenda;
      Total.ICMSTot.vFrete  := 0;
      Total.ICMSTot.vSeg    := 0;
      Total.ICMSTot.vDesc   := 0;
      Total.ICMSTot.vII     := 0;
      Total.ICMSTot.vIPI    := 0;
      Total.ICMSTot.vPIS    := 0;
      Total.ICMSTot.vCOFINS := 0;
      Total.ICMSTot.vOutro  := 0;
      Total.ICMSTot.vNF     := valorVenda;

      // partilha do icms e fundo de probreza
      Total.ICMSTot.vFCPUFDest   := 0.00;
      Total.ICMSTot.vICMSUFDest  := 0.00;
      Total.ICMSTot.vICMSUFRemet := 0.00;

      Total.ISSQNtot.vServ   := 0;
      Total.ISSQNTot.vBC     := 0;
      Total.ISSQNTot.vISS    := 0;
      Total.ISSQNTot.vPIS    := 0;
      Total.ISSQNTot.vCOFINS := 0;

{      Total.retTrib.vRetPIS    := 0;
      Total.retTrib.vRetCOFINS := 0;
      Total.retTrib.vRetCSLL   := 0;
      Total.retTrib.vBCIRRF    := 0;
      Total.retTrib.vIRRF      := 0;
      Total.retTrib.vBCRetPrev := 0;
      Total.retTrib.vRetPrev   := 0;}

      Transp.modFrete := mfSemFrete; // NFC-e n�o pode ter FRETE

{      Cobr.Fat.nFat  := 'Numero da Fatura';
      Cobr.Fat.vOrig := 100 ;
      Cobr.Fat.vDesc := 0 ;
      Cobr.Fat.vLiq  := 100 ;

      with Cobr.Dup.Add do
       begin
         nDup  := '1234';
         dVenc := now+10;
         vDup  := 50;
       end;

      with Cobr.Dup.Add do
       begin
         nDup  := '1235';
         dVenc := now+10;
         vDup  := 50;
       end;
 }

      with pag.Add do //PAGAMENTOS apenas para NFC-e
       begin

         tPag := fpDinheiro;
         vPag := valorVenda;
       end;

      InfAdic.infCpl     :=  '';
      InfAdic.infAdFisco :=  '';

{      with InfAdic.obsCont.Add do
       begin
         xCampo := 'ObsCont';
         xTexto := 'Texto';
       end;

      with InfAdic.obsFisco.Add do
       begin
         xCampo := 'ObsFisco';
         xTexto := 'Texto';
       end; }
   end;

   ACBrNFe1.NotasFiscais.GerarNFe;
end;

function TForm1.enviarNFCeTEF(numeroNFce : string; out StrDescMensagem : string) : boolean;
begin
  ACBrNFe1.NotasFiscais.Clear;
  ACBrNFe1.Configuracoes.Geral.ModeloDF := moNFCe;
  ACBrNFe1.Configuracoes.Geral.VersaoDF := ve310;

  GerarNFCeTEF(numeroNFce, StringToFloatDef(edValorVenda.Text, 0), False);
  try
    ACBrNFe1.Enviar(numeroNFce, True, False);
  except
    on e : Exception do
    begin
      StrDescMensagem := e.Message;
      Result := False;
      Exit;
    end;
  end;

  MemoDados.Lines.Add('');
  MemoDados.Lines.Add('Envio NFCe');

  MemoResp.Lines.Text := ACBrNFe1.WebServices.Enviar.RetWS;
  memoRespWS.Lines.Text := ACBrNFe1.WebServices.Enviar.RetornoWS;
  LoadXML(ACBrNFe1.WebServices.Enviar.RetWS, WBResposta);

  MemoDados.Lines.Add('');
  MemoDados.Lines.Add('Envio NFCe');
  MemoDados.Lines.Add('tpAmb: '+ TpAmbToStr(ACBrNFe1.WebServices.Enviar.TpAmb));
  MemoDados.Lines.Add('verAplic: '+ ACBrNFe1.WebServices.Enviar.verAplic);
  MemoDados.Lines.Add('cStat: '+ IntToStr(ACBrNFe1.WebServices.Enviar.cStat));
  MemoDados.Lines.Add('cUF: '+ IntToStr(ACBrNFe1.WebServices.Enviar.cUF));
  MemoDados.Lines.Add('xMotivo: '+ ACBrNFe1.WebServices.Enviar.xMotivo);
  //MemoDados.Lines.Add('cMsg: '+ IntToStr(ACBrNFe1.WebServices.Enviar.cMsg));
  //MemoDados.Lines.Add('xMsg: '+ ACBrNFe1.WebServices.Enviar.xMsg);
  MemoDados.Lines.Add('Recibo: '+ ACBrNFe1.WebServices.Enviar.Recibo);
  //MemoDados.Lines.Add('Protocolo: '+ ACBrNFe1.WebServices.Enviar.Protocolo);

  ACBrNFe1.NotasFiscais.Clear;

  Result := True;
end;

end.




