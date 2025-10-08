{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{ - Elias César Vieira                                                         }
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

unit Principal;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, Spin, ExtDlgs,
  ACBrTEFSmartTEFInterface,
  ACBrTEFSmartTEFSchemas,
  ACBrTEFSmartTEFAPI, ImgList
  {$IfDef FPC}
  , DateTimePicker
  {$EndIf};

const
  CURL_ACBR = 'https://projetoacbr.com.br/tef/';

type

  { TfrPrincipal }

  TfrPrincipal = class(TForm)
    ACBrSmartTEF: TACBrSmartTEF;
    btIntegradorCriarLoja: TBitBtn;
    btConfigLerParametros: TBitBtn;
    btConfigSalvar: TBitBtn;
    btEndpointsLogLimpar: TBitBtn;
    btIntegradorCriarLojaSenha: TSpeedButton;
    btPoolingConsultar: TBitBtn;
    btOrdemImpressaoCancelar: TBitBtn;
    btOrdemImpressaoConsultar: TBitBtn;
    btTerminaisListar: TBitBtn;
    btUsuariosListar: TBitBtn;
    btTerminaisNickname: TBitBtn;
    btTerminaisDesbloquear: TBitBtn;
    btTerminaisBloquear: TBitBtn;
    btOrdemImpressaoCriar: TBitBtn;
    btOrdemPagamentoEstornar: TBitBtn;
    btOrdemPagamentoCriar: TBitBtn;
    btOrdemPagamentoConsultar: TBitBtn;
    btOrdemPagamentoCancelar: TBitBtn;
    btUsuariosCriar: TBitBtn;
    btLojaConsultar: TBitBtn;
    btLojaConfigConsultar: TBitBtn;
    cbConfigLogNivel: TComboBox;
    cbUsuariosCriarTipo: TComboBox;
    cbOrdemPagamentoCriarDetalhes: TCheckBox;
    cbOrdemPagamentoCriarTipoJuros: TComboBox;
    cbOrdemPagamentoCriarTipoOrdem: TComboBox;
    cbOrdemImpressaoCriarTipoOrdem: TComboBox;
    cbOrdemPagamentoCriarTipoPagamento: TComboBox;
    edPoolingConsultarData: TDateTimePicker;
    edConfigSmartTEFJWTToken: TEdit;
    edConfigProxyHost: TEdit;
    edConfigProxySenha: TEdit;
    edConfigProxyUsuario: TEdit;
    edConfigSmartTEFCNPJIntegrador: TEdit;
    edConfigSmartTEFCNPJLoja: TEdit;
    edConfigSmartTEFTokenLoja: TEdit;
    edConfigSmartTEFTokenIntegrador: TEdit;
    edConfigLogArquivo: TEdit;
    edIntegradorCriarLojaSenha: TEdit;
    edIntegradorCriarLojaCNPJIntegrador: TEdit;
    edIntegradorCriarLojaCNPJ: TEdit;
    edIntegradorCriarLojaEmail: TEdit;
    edIntegradorCriarLojaNome: TEdit;
    edIntegradorCriarLojaNomeLoja: TEdit;
    edUsuariosCriarNome: TEdit;
    edTerminaisNicknameSerialPos: TEdit;
    edTerminaisNickname: TEdit;
    edTerminaisBloqueioSerialPos: TEdit;
    edOrdemImpressaoCriarArquivo: TEdit;
    edOrdemImpressaoCancelarPrintIdentifier: TEdit;
    edOrdemImpressaoConsultarPrintIdentifier: TEdit;
    edOrdemImpressaoCriarIdUsuario: TEdit;
    edOrdemImpressaoCriarPrintId: TEdit;
    edOrdemImpressaoCriarSerialPOS: TEdit;
    edOrdemPagamentoEstornarPaymentIdentifier: TEdit;
    edOrdemPagamentoCriarCNPJ: TEdit;
    edOrdemPagamentoCriarCPF: TEdit;
    edOrdemPagamentoCriarChargeId: TEdit;
    edOrdemPagamentoConsultarChargeId: TEdit;
    edOrdemPagamentoCancelarPaymentIdentifier: TEdit;
    edOrdemPagamentoConsultarPaymentIdentifier: TEdit;
    edOrdemPagamentoCriarIdUsuario: TEdit;
    edOrdemPagamentoCriarNome: TEdit;
    edOrdemPagamentoCriarParcelas: TSpinEdit;
    edOrdemPagamentoCriarSerialPOS: TEdit;
    edOrdemPagamentoCriarValor: TEdit;
    edUsuariosCriarEmail: TEdit;
    gbPooling: TGroupBox;
    gbOrdemPagamentoCriarDetalhes: TGroupBox;
    gbTerminaisListar: TGroupBox;
    gbLojaConfigConsultar: TGroupBox;
    gbUsuariosListar: TGroupBox;
    gbTerminaisNickname: TGroupBox;
    gbTerminaisBloqueio: TGroupBox;
    gbUsuariosCriar: TGroupBox;
    gbLojaConsultar: TGroupBox;
    lbConfigSmartTEFJWTToken: TLabel;
    gbConfigProxy: TGroupBox;
    gbConfigSmartTEF: TGroupBox;
    gbConfigLog: TGroupBox;
    ImageList1: TImageList;
    lbIntegradorCriarLojaCNPJIntegrador: TLabel;
    lbIntegradorCriarLojaCNPJ: TLabel;
    lbIntegradorCriarLojaEmail: TLabel;
    lbIntegradorCriarLojaSenha: TLabel;
    lbIntegradorCriarLojaNome: TLabel;
    lbIntegradorCriarLojaNomeLoja: TLabel;
    lbConfigLogArquivo: TLabel;
    lbConfigLogNivel: TLabel;
    lbConfigProxyUsuario: TLabel;
    lbConfigSmartTEFTokenIntegrador: TLabel;
    lbConfigSmartTEFTokenLoja: TLabel;
    lbConfigSmartTEFCNPJIntegrador: TLabel;
    lbConfigProxySenha: TLabel;
    lbConfigSmartTEFCNPJLoja: TLabel;
    lbConfigProxyHost: TLabel;
    lbConfigProxyPorta: TLabel;
    lbEndpointsLog: TLabel;
    lbOrdemImpressaoCancelarPrintIdentifier: TLabel;
    lbOrdemImpressaoConsultarPrintIdentifier: TLabel;
    lbUsuariosCriarTipo: TLabel;
    lbUsuariosCriarNome: TLabel;
    lbTerminaisNicknameSerialPos: TLabel;
    lbTerminaisNickname: TLabel;
    lbTerminaisBloqueioSerialPos: TLabel;
    lbOrdemImpressaoCriarIdUsuario: TLabel;
    lbOrdemImpressaoCriarPrintId: TLabel;
    lbOrdemImpressaoCriarSerialPOS: TLabel;
    lbOrdemImpressaoCriarTipoOrdem: TLabel;
    lbOrdemImpressaoCriarArquivo: TLabel;
    lbOrdemPagamentoEstornarPaymentIdentifier: TLabel;
    lbOrdemPagamentoCriarCNPJ: TLabel;
    lbOrdemPagamentoCriarCPF: TLabel;
    lbOrdemPagamentoCriarChargeId: TLabel;
    lbOrdemPagamentoConsultarChargeId: TLabel;
    lbOrdemPagamentoCancelarPaymentIdentifier: TLabel;
    lbOrdemPagamentoConsultarPaymentIdentifier: TLabel;
    lbOrdemPagamentoCriarIdUsuario: TLabel;
    lbOrdemPagamentoCriarNome: TLabel;
    lbOrdemPagamentoCriarParcelas: TLabel;
    lbOrdemPagamentoCriarSerialPOS: TLabel;
    lbOrdemPagamentoCriarTipoJuros: TLabel;
    lbOrdemPagamentoCriarTipoOrdem: TLabel;
    lbOrdemPagamentoCriarTipoPagamento: TLabel;
    lbOrdemPagamentoCriarValor: TLabel;
    lbUsuariosCriarEmail: TLabel;
    lbPoolingConsultarData: TLabel;
    lURLTEF: TLabel;
    mmEndpointsLog: TMemo;
    OpenPictureDialog1: TOpenPictureDialog;
    pnPoolingConsultar: TPanel;
    pnPooling: TPanel;
    pnUsuarios: TPanel;
    pnTerminaisListar: TPanel;
    pnLoja: TPanel;
    pnUsuariosListar: TPanel;
    pnTerminaisNickname: TPanel;
    pnTerminaisBloqueio: TPanel;
    pcOrdemImpressao: TPageControl;
    pnOrdemImpressaoCancelar: TPanel;
    pnOrdemImpressaoConsultar: TPanel;
    pnTerminais: TPanel;
    pnOrdemImpressaoCriar: TPanel;
    pnOrdemPagamentoEstornar: TPanel;
    pnOrdemPagamentoConsultar: TPanel;
    pnOrdemPagamentoCancelar: TPanel;
    pnOrdemPagamentoCriar: TPanel;
    pnIntegradorCriarLoja: TPanel;
    pcERP: TPageControl;
    pcIntegrador: TPageControl;
    pcEndpoints: TPageControl;
    pcOrdemPagamento: TPageControl;
    pnConfigRodape: TPanel;
    pnConfigPainel: TPanel;
    pcPrincipal: TPageControl;
    pnConfig: TPanel;
    pnConfigProxy: TPanel;
    pnConfigSmartTEF: TPanel;
    btConfigProxySenha: TSpeedButton;
    edConfigProxyPorta: TSpinEdit;
    pnConfigLog: TPanel;
    btConfigLogArquivo: TSpeedButton;
    pnEndpointsLog: TPanel;
    pnEndpointsLogRodape: TPanel;
    pnOrdemPagamentoCriarDetalhes: TPanel;
    btOrdemImpressaoCriarArquivo: TSpeedButton;
    pnUsuariosCriar: TPanel;
    pnLojaConsultar: TPanel;
    pnLojaConfigConsultar: TPanel;
    Splitter1: TSplitter;
    tsPooling: TTabSheet;
    tsLoja: TTabSheet;
    tsUsuarios: TTabSheet;
    tsOrdemImpressaoCancelar: TTabSheet;
    tsOrdemImpressaoConsultar: TTabSheet;
    tsOrdemImpressaoCriar: TTabSheet;
    tsOrdemPagamentoEstornar: TTabSheet;
    tsOrdemPagamentoCancelar: TTabSheet;
    tsOrdemPagamentoConsultar: TTabSheet;
    tsOrdemPagamento: TTabSheet;
    tsOrdemImpressao: TTabSheet;
    tsTerminais: TTabSheet;
    tsIntegradorCriarLoja: TTabSheet;
    tsIntegrador: TTabSheet;
    tsERP: TTabSheet;
    tsEndpoints: TTabSheet;
    tsConfig: TTabSheet;
    tsOrdemPagamentoCriar: TTabSheet;
    procedure btConfigLerParametrosClick(Sender: TObject);
    procedure btConfigProxySenhaClick(Sender: TObject);
    procedure btConfigSalvarClick(Sender: TObject);
    procedure btEndpointsLogLimparClick(Sender: TObject);
    procedure btIntegradorCriarLojaSenhaClick(Sender: TObject);
    procedure btPoolingConsultarClick(Sender: TObject);
    procedure btOrdemImpressaoCancelarClick(Sender: TObject);
    procedure btOrdemImpressaoCriarArquivoClick(Sender: TObject);
    procedure btOrdemImpressaoCriarClick(Sender: TObject);
    procedure btOrdemPagamentoCancelarClick(Sender: TObject);
    procedure btOrdemImpressaoConsultarClick(Sender: TObject);
    procedure btOrdemPagamentoConsultarClick(Sender: TObject);
    procedure btOrdemPagamentoCriarClick(Sender: TObject);
    procedure btOrdemPagamentoEstornarClick(Sender: TObject);
    procedure btTerminaisBloquearClick(Sender: TObject);
    procedure btTerminaisDesbloquearClick(Sender: TObject);
    procedure btTerminaisListarClick(Sender: TObject);
    procedure btTerminaisNicknameClick(Sender: TObject);
    procedure btUsuariosCriarClick(Sender: TObject);
    procedure btLojaConsultarClick(Sender: TObject);
    procedure btLojaConfigConsultarClick(Sender: TObject);
    procedure btUsuariosListarClick(Sender: TObject);
    procedure cbOrdemPagamentoCriarDetalhesChange(Sender: TObject);
    procedure cbOrdemPagamentoCriarTipoPagamentoSelect(Sender: TObject);
    procedure lURLTEFClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);
  private
    function FormatarJSON(const AJSON: String): String;

    procedure LerConfiguracao;
    procedure GravarConfiguracao;
    procedure AplicarConfiguracao;
    procedure InicializarBitmaps; 
    procedure InicializarComponentesDefault;
    procedure AdicionarLog(aMsg: String);
  public
    function NomeArquivoConfig: String;
  end;

var
  frPrincipal: TfrPrincipal;

implementation

uses
  {$IfDef FPC}
   fpjson, jsonparser, jsonscanner,
  {$Else}
    {$IFDEF DELPHIXE6_UP}JSON,{$ENDIF}
  {$EndIf}
  synautil, DateUtils,
  IniFiles, synacode,
  ACBrUtil.Base,
  ACBrUtil.FilesIO;

{$R *.dfm}

{ TfrPrincipal }

procedure TfrPrincipal.btConfigProxySenhaClick(Sender: TObject);
begin
  {$IfDef FPC}
  if btConfigProxySenha.Down then
    edConfigProxySenha.EchoMode := emNormal
  else
    edConfigProxySenha.EchoMode := emPassword;
  {$Else}
  if btConfigProxySenha.Down then
    edConfigProxySenha.PasswordChar := #0
  else
    edConfigProxySenha.PasswordChar := '*';
  {$EndIf}
end;

procedure TfrPrincipal.btConfigLerParametrosClick(Sender: TObject);
begin
  LerConfiguracao;
end;

procedure TfrPrincipal.btConfigSalvarClick(Sender: TObject);
begin
  GravarConfiguracao;
  AplicarConfiguracao;
end;

procedure TfrPrincipal.btEndpointsLogLimparClick(Sender: TObject);
begin
  mmEndpointsLog.Lines.Clear;
end;

procedure TfrPrincipal.btIntegradorCriarLojaSenhaClick(Sender: TObject);
begin
  {$IfDef FPC}
  if btIntegradorCriarLojaSenha.Down then
    edIntegradorCriarLojaSenha.EchoMode := emNormal
  else
    edIntegradorCriarLojaSenha.EchoMode := emPassword;
  {$Else}
  if btIntegradorCriarLojaSenha.Down then
    edIntegradorCriarLojaSenha.PasswordChar := #0
  else
    edIntegradorCriarLojaSenha.PasswordChar := '*';
  {$EndIf}
end;

procedure TfrPrincipal.btPoolingConsultarClick(Sender: TObject);
var
  wIni, wFim: TDateTime;
  resp: IACBrSmartTEFPoolingResponse;
begin
  wIni := StartOfTheDay(edPoolingConsultarData.DateTime);
  wFim := EndOfTheDay(edPoolingConsultarData.DateTime);

  if ACBrSmartTEF.Pooling(wIni, wFim, resp) then
  begin
    AdicionarLog('[CONSULTADO]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Consulta efetuada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btOrdemImpressaoCancelarClick(Sender: TObject);
var
  resp: IACBrSmartTEFPrintDetailsResponse;
begin
  if EstaVazio(edOrdemImpressaoCancelarPrintIdentifier.Text) then
  begin
    ShowMessage('Informe o Print Identifier para cancelamento');
    Exit;
  end;

  if ACBrSmartTEF.OrdemImpressao.Cancelar(edOrdemImpressaoCancelarPrintIdentifier.Text, resp) then
  begin
    AdicionarLog('[CANCELADO]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Ordem cancelada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.OrdemImpressao.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btOrdemImpressaoCriarArquivoClick(Sender: TObject);
begin
  OpenPictureDialog1.FileName := edOrdemImpressaoCriarArquivo.Text;
  if OpenPictureDialog1.Execute then
    edOrdemImpressaoCriarArquivo.Text := OpenPictureDialog1.FileName;
end;

procedure TfrPrincipal.btOrdemImpressaoCriarClick(Sender: TObject);
var
  wBase64: String;
  wFs: TFileStream;
  resp: IACBrSmartTEFPrintResponse;
begin
  if EstaVazio(edOrdemImpressaoCriarArquivo.Text) then
  begin
    ShowMessage('Informe o caminho do arquivo');
    Exit;
  end;

  // Convertendo o arquivo de imagem para Base64
  if NaoEstaVazio(edOrdemImpressaoCriarArquivo.Text) then
  begin
    // Lê conteúdo do arquivo e converte para Base64
    wFs := TFileStream.Create(edOrdemImpressaoCriarArquivo.Text, fmOpenRead or fmShareDenyWrite);
    try
      wFs.Position := 0;
      wBase64 := EncodeBase64(ReadStrFromStream(wFs, wFs.Size));
    finally
      wFs.Free;
    end;
  end;

  with ACBrSmartTEF.OrdemImpressao.OrdemImpressaoSolicitada do
  begin
    user_id := StrToIntDef(edOrdemImpressaoCriarIdUsuario.Text, 0);
    serial_pos := edOrdemImpressaoCriarSerialPOS.Text;
    order_type := TACBrSmartTEFOrderType(cbOrdemImpressaoCriarTipoOrdem.ItemIndex);
    print_id :=  edOrdemImpressaoCriarPrintId.Text;
    file_.name := ExtractFileName(edOrdemImpressaoCriarArquivo.Text);
    file_.data := wBase64;
  end;

  if ACBrSmartTEF.OrdemImpressao.Criar(resp) then
  begin
    AdicionarLog('[ORDEM CRIADA]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Ordem criada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.OrdemImpressao.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btOrdemPagamentoCancelarClick(Sender: TObject);
var
  resp: IACBrSmartTEFOrderResponse;
begin
  if EstaVazio(edOrdemPagamentoCancelarPaymentIdentifier.Text) then
  begin
    ShowMessage('Informe o Payment Identifier para cancelamento');
    Exit;
  end;

  if ACBrSmartTEF.OrdemPagamento.Cancelar(edOrdemPagamentoCancelarPaymentIdentifier.Text, resp) then
  begin
    AdicionarLog('[CANCELADO]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Ordem cancelada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.OrdemPagamento.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btOrdemImpressaoConsultarClick(Sender: TObject);
var
  resp: IACBrSmartTEFPrintDetailsResponse;
begin
  if EstaVazio(edOrdemImpressaoConsultarPrintIdentifier.Text) then
  begin
    ShowMessage('Informe o Print Identifier para consulta');
    Exit;
  end;

  if ACBrSmartTEF.OrdemImpressao.Consultar(edOrdemImpressaoConsultarPrintIdentifier.Text, resp) then
  begin
    AdicionarLog('[CONSULTADO]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Consulta efetuada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.OrdemImpressao.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btOrdemPagamentoConsultarClick(Sender: TObject);
var
  resp: IACBrSmartTEFCardDetailsListResponse;
begin
  if EstaVazio(edOrdemPagamentoConsultarChargeId.Text) and
     EstaVazio(edOrdemPagamentoConsultarPaymentIdentifier.Text) then
  begin
    ShowMessage('Informe um dos valores para consulta');
    Exit;
  end;

  if ACBrSmartTEF.OrdemPagamento.Consultar(
       edOrdemPagamentoConsultarPaymentIdentifier.Text, resp,
       edOrdemPagamentoConsultarChargeId.Text) then
  begin
    AdicionarLog('[CONSULTADO]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Consulta efetuada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.OrdemPagamento.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btOrdemPagamentoCriarClick(Sender: TObject);
var
  wValor: Double;
  resp: IACBrSmartTEFOrderResponse;
begin
  wValor := StrToFloatDef(edOrdemPagamentoCriarValor.Text, 0);
  if EstaZerado(wValor) then
  begin
    ShowMessage('Informe um valor válido!');
    Exit;
  end;

  with ACBrSmartTEF.OrdemPagamento.OrdemPagamentoSolicitada do
  begin
    value := wValor;
    installments := edOrdemPagamentoCriarParcelas.Value;
    charge_id := edOrdemPagamentoCriarChargeId.Text;
    user_id := StrToIntDef(edOrdemPagamentoCriarIdUsuario.Text, 0);
    serial_pos := edOrdemPagamentoCriarSerialPOS.Text;
    order_type := TACBrSmartTEFOrderType(cbOrdemPagamentoCriarTipoOrdem.ItemIndex);
    payment_type := TACBrSmartTEFPaymentType(cbOrdemPagamentoCriarTipoPagamento.ItemIndex);
    fee_type := TACBrSmartTEFFeeType(cbOrdemPagamentoCriarTipoJuros.ItemIndex);
    has_details := cbOrdemPagamentoCriarDetalhes.Checked;
    extras.CPF := edOrdemPagamentoCriarCPF.Text;
    extras.CNPJ := edOrdemPagamentoCriarCNPJ.Text;
    extras.Nome := edOrdemPagamentoCriarNome.Text;
  end;

  if ACBrSmartTEF.OrdemPagamento.Criar(resp) then
  begin
    AdicionarLog('[ORDEM CRIADA]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Ordem criada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.OrdemPagamento.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btOrdemPagamentoEstornarClick(Sender: TObject);
var
  resp: IACBrSmartTEFOrderResponse;
begin
  if EstaVazio(edOrdemPagamentoEstornarPaymentIdentifier.Text) then
  begin
    ShowMessage('Informe o Payment Identifier para estono');
    Exit;
  end;

  if ACBrSmartTEF.OrdemPagamento.Estornar(edOrdemPagamentoEstornarPaymentIdentifier.Text, resp) then
  begin
    AdicionarLog('[SOLICITACAO ENVIADA]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Solicitação de estorno enviada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.OrdemPagamento.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btTerminaisBloquearClick(Sender: TObject);
begin
  if EstaVazio(edTerminaisBloqueioSerialPos.Text) then
  begin
    ShowMessage('Informe o SerialPos para efetuar o bloqueio');
    Exit;
  end;

  if ACBrSmartTEF.Terminais.AlterarBloqueio(edTerminaisBloqueioSerialPos.Text, True) then
    ShowMessage('Bloqueado com Sucesso')
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.Terminais.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btTerminaisDesbloquearClick(Sender: TObject);
begin
  if EstaVazio(edTerminaisBloqueioSerialPos.Text) then
  begin
    ShowMessage('Informe o SerialPos para efetuar o desbloqueio');
    Exit;
  end;

  if ACBrSmartTEF.Terminais.AlterarBloqueio(edTerminaisBloqueioSerialPos.Text, False) then
    ShowMessage('Desbloqueado com Sucesso')
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.Terminais.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btTerminaisListarClick(Sender: TObject);
var
  resp: IACBrSmartTEFTerminalListResponse;
begin
  if ACBrSmartTEF.Terminais.Listar(resp) then
  begin
    AdicionarLog('[CONSULTADO]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Consulta efetuada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.Terminais.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btTerminaisNicknameClick(Sender: TObject);
begin
  if EstaVazio(edTerminaisNickname.Text) and EstaVazio(edTerminaisNicknameSerialPos.Text) then
  begin
    ShowMessage('Informe o SerialPos e Nickname');
    Exit;
  end;

  if ACBrSmartTEF.Terminais.AlterarNickname(edTerminaisNicknameSerialPos.Text, edTerminaisNickname.Text) then
    ShowMessage('Nickname alterado com Sucesso')
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.Terminais.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btUsuariosCriarClick(Sender: TObject);
var
  resp: IACBrSmartTEFUserCreateResponse;
begin
  if EstaVazio(edUsuariosCriarNome.Text) or
     EstaVazio(edUsuariosCriarEmail.Text) or
     EstaZerado(cbUsuariosCriarTipo.ItemIndex) then
  begin
    ShowMessage('Informe os dados para incluir o usuario');
    Exit;
  end;

  with ACBrSmartTEF.Usuarios.UsuarioSolicitado do
  begin
    name := edUsuariosCriarNome.Text;
    email := edUsuariosCriarEmail.Text;
    user_type := TACBrSmartTEFUserType(cbUsuariosCriarTipo.ItemIndex);
  end;

  if ACBrSmartTEF.Usuarios.Criar(resp) then
  begin
    AdicionarLog('[USUARIO CRIADO]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Usuario criado com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.Usuarios.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btLojaConsultarClick(Sender: TObject);
var
  resp: IACBrSmartTEFStoreResponse;
begin
  if ACBrSmartTEF.Loja.ConsultarLoja(resp) then
  begin
    AdicionarLog('[CONSULTADO]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Consulta efetuada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.Loja.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btLojaConfigConsultarClick(Sender: TObject);
var
  resp: IACBrSmartTEFStoreSettingsListResponse;
begin
  if ACBrSmartTEF.Loja.ConsultarConfiguracao(resp) then
  begin
    AdicionarLog('[CONSULTADO]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Consulta efetuada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.Loja.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btUsuariosListarClick(Sender: TObject);
var
  resp: IACBrSmartTEFUserListResponse;
begin
  if ACBrSmartTEF.Usuarios.Listar(resp) then
  begin
    AdicionarLog('[CONSULTADO]' + sLineBreak + FormatarJSON(resp.ToJson));
    ShowMessage('Consulta efetuada com Sucesso');
  end
  else
    AdicionarLog(FormatarJSON(ACBrSmartTEF.Usuarios.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.cbOrdemPagamentoCriarDetalhesChange(Sender: TObject);
begin
  gbOrdemPagamentoCriarDetalhes.Enabled := cbOrdemPagamentoCriarDetalhes.Checked;
end;

procedure TfrPrincipal.cbOrdemPagamentoCriarTipoPagamentoSelect(Sender: TObject);
var
  wCredito: Boolean;
begin
  wCredito := (cbOrdemPagamentoCriarTipoPagamento.ItemIndex = 1);
  lbOrdemPagamentoCriarParcelas.Enabled := wCredito;
  edOrdemPagamentoCriarParcelas.Enabled := wCredito;
end;

procedure TfrPrincipal.FormCreate(Sender: TObject);
begin
  InicializarBitmaps;
  InicializarComponentesDefault;
  LerConfiguracao;
end;

procedure TfrPrincipal.lURLTEFClick(Sender: TObject);
begin
  OpenURL(CURL_ACBR);
end;

function TfrPrincipal.FormatarJSON(const AJSON: String): String;
{$IfDef FPC}
var
  jpar: TJSONParser;
  jdata: TJSONData;
  ms: TMemoryStream;
{$ELSE}
  {$IFDEF DELPHIXE6_UP}
  var
    wJsonValue: TJSONValue;
  {$ENDIF}
{$ENDIF}
begin
  Result := AJSON;
  try
    {$IFDEF FPC}
    ms := TMemoryStream.Create;
    try
      ms.Write(Pointer(AJSON)^, Length(AJSON));
      ms.Position := 0;
      jpar := TJSONParser.Create(ms, [joUTF8]);
      jdata := jpar.Parse;
      if Assigned(jdata) then
        Result := jdata.FormatJSON;
    finally
      ms.Free;
      if Assigned(jpar) then
        jpar.Free;
      if Assigned(jdata) then
        jdata.Free;
    end;
    {$ELSE}
      {$IFDEF DELPHIXE6_UP}
      wJsonValue := TJSONObject.ParseJSONValue(AJSON);
      try
        if Assigned(wJsonValue) then
        begin
          Result := wJsonValue.Format(2);
        end;
      finally
        wJsonValue.Free;
      end;
      {$ENDIF}
    {$ENDIF}
  except
    Result := AJSON;
  end;
end;

procedure TfrPrincipal.LerConfiguracao;
var
  wIni: TIniFile;
begin
  AdicionarLog('- LerConfiguracao: ' + NomeArquivoConfig);
  wIni := TIniFile.Create(NomeArquivoConfig);
  try
    edConfigSmartTEFCNPJLoja.Text := wIni.ReadString('SmartTEF', 'CNPJLoja', '');
    edConfigSmartTEFTokenLoja.Text := wIni.ReadString('SmartTEF', 'TokenLoja', '');
    edConfigSmartTEFCNPJIntegrador.Text := wIni.ReadString('SmartTEF', 'CNPJIntegrador', '');
    edConfigSmartTEFTokenIntegrador.Text := wIni.ReadString('SmartTEF', 'TokenIntegrador', '');
    edConfigSmartTEFJWTToken.Text := wIni.ReadString('SmartTEF', 'JWTToken', '');

    edConfigProxyHost.Text := wIni.ReadString('Proxy', 'Host', '');
    edConfigProxyPorta.Text := wIni.ReadString('Proxy', 'Porta', '');
    edConfigProxyUsuario.Text := wIni.ReadString('Proxy', 'Usuario', '');
    edConfigProxySenha.Text := StrCrypt(DecodeBase64(wIni.ReadString('Proxy', 'Senha', '')), CURL_ACBR);

    edConfigLogArquivo.Text := wIni.ReadString('Log', 'Arquivo', '');
    cbConfigLogNivel.ItemIndex := wIni.ReadInteger('Log', 'Nivel', 4);
  finally
    wIni.Free;
  end;

  AplicarConfiguracao;
end;

procedure TfrPrincipal.GravarConfiguracao;
var
  wIni: TIniFile;
begin
  AdicionarLog('- GravarConfiguracao: ' + NomeArquivoConfig);
  wIni := TIniFile.Create(NomeArquivoConfig);
  try
    wIni.WriteString('SmartTEF', 'CNPJLoja', edConfigSmartTEFCNPJLoja.Text);
    wIni.WriteString('SmartTEF', 'TokenLoja', edConfigSmartTEFTokenLoja.Text);
    wIni.WriteString('SmartTEF', 'CNPJIntegrador', edConfigSmartTEFCNPJIntegrador.Text);
    wIni.WriteString('SmartTEF', 'TokenIntegrador', edConfigSmartTEFTokenIntegrador.Text);
    wIni.WriteString('SmartTEF', 'JWTToken', edConfigSmartTEFJWTToken.Text);

    wIni.WriteString('Proxy', 'Host', edConfigProxyHost.Text);
    wIni.WriteString('Proxy', 'Porta', edConfigProxyPorta.Text);
    wIni.WriteString('Proxy', 'Usuario', edConfigProxyUsuario.Text);
    wIni.WriteString('Proxy', 'Senha', EncodeBase64(StrCrypt(edConfigProxySenha.Text, CURL_ACBR)));

    wIni.WriteString('Log', 'Arquivo', edConfigLogArquivo.Text);
    wIni.WriteInteger('Log', 'Nivel', cbConfigLogNivel.ItemIndex);
  finally
    wIni.Free;
  end;

  AplicarConfiguracao;
end;

procedure TfrPrincipal.AplicarConfiguracao;
begin
  AdicionarLog('  - ConfigurarACBrPIXCD');

  ACBrSmartTEF.CNPJLoja := edConfigSmartTEFCNPJLoja.Text;
  ACBrSmartTEF.GWTokenLoja := edConfigSmartTEFTokenLoja.Text;
  ACBrSmartTEF.CNPJIntegrador := edConfigSmartTEFCNPJIntegrador.Text;
  ACBrSmartTEF.GWTokenIntegrador := edConfigSmartTEFTokenIntegrador.Text;
  ACBrSmartTEF.JWTTokenIntegrador := edConfigSmartTEFJWTToken.Text;

  ACBrSmartTEF.ProxyHost := edConfigProxyHost.Text;
  ACBrSmartTEF.ProxyPort := edConfigProxyPorta.Text;
  ACBrSmartTEF.ProxyUser := edConfigProxyUsuario.Text;
  ACBrSmartTEF.ProxyPass := edConfigProxySenha.Text;

  ACBrSmartTEF.ArqLOG := edConfigLogArquivo.Text;
  ACBrSmartTEF.NivelLog := cbConfigLogNivel.ItemIndex;
end;

procedure TfrPrincipal.InicializarBitmaps;
begin
  ImageList1.GetBitmap(7, btConfigProxySenha.Glyph);
  ImageList1.GetBitmap(9, btConfigLogArquivo.Glyph);
  ImageList1.GetBitmap(10, btConfigSalvar.Glyph);
  ImageList1.GetBitmap(11, btConfigLerParametros.Glyph);
  ImageList1.GetBitmap(18, btEndpointsLogLimpar.Glyph);

  ImageList1.GetBitmap(7, btIntegradorCriarLojaSenha.Glyph);
  ImageList1.GetBitmap(16, btIntegradorCriarLoja.Glyph);
  
  ImageList1.GetBitmap(8, btOrdemPagamentoConsultar.Glyph);
  ImageList1.GetBitmap(12, btOrdemPagamentoEstornar.Glyph);
  ImageList1.GetBitmap(16, btOrdemPagamentoCriar.Glyph);
  ImageList1.GetBitmap(17, btOrdemPagamentoCancelar.Glyph);

  ImageList1.GetBitmap(8, btOrdemImpressaoConsultar.Glyph);
  ImageList1.GetBitmap(16, btOrdemImpressaoCriar.Glyph);
  ImageList1.GetBitmap(17, btOrdemImpressaoCancelar.Glyph);

  ImageList1.GetBitmap(8, btTerminaisListar.Glyph);
  ImageList1.GetBitmap(11, btTerminaisNickname.Glyph);
  ImageList1.GetBitmap(16, btTerminaisDesbloquear.Glyph);
  ImageList1.GetBitmap(17, btTerminaisBloquear.Glyph);

  ImageList1.GetBitmap(8, btUsuariosListar.Glyph);
  ImageList1.GetBitmap(16, btUsuariosCriar.Glyph);

  ImageList1.GetBitmap(8, btLojaConsultar.Glyph);
  ImageList1.GetBitmap(8, btLojaConfigConsultar.Glyph);
  ImageList1.GetBitmap(8, btPoolingConsultar.Glyph);
end;

procedure TfrPrincipal.InicializarComponentesDefault;
var
  i, j, k, l: Integer;
begin
  cbOrdemPagamentoCriarTipoPagamento.Items.Clear;
  for i := 0 to Integer(High(TACBrSmartTEFPaymentType)) do
    cbOrdemPagamentoCriarTipoPagamento.Items.Add(SmartTEFPaymentTypeToString(TACBrSmartTEFPaymentType(i)));
  cbOrdemPagamentoCriarTipoPagamento.ItemIndex := 0;

  cbOrdemPagamentoCriarTipoOrdem.Items.Clear;
  cbOrdemImpressaoCriarTipoOrdem.Items.Clear;
  for j := 0 to Integer(High(TACBrSmartTEFOrderType)) do
  begin
    cbOrdemPagamentoCriarTipoOrdem.Items.Add(SmartTEFOrderTypeToString(TACBrSmartTEFOrderType(j)));
    cbOrdemImpressaoCriarTipoOrdem.Items.Add(SmartTEFOrderTypeToString(TACBrSmartTEFOrderType(j)));
  end;
  cbOrdemPagamentoCriarTipoOrdem.ItemIndex := 0;
  cbOrdemImpressaoCriarTipoOrdem.ItemIndex := 0;

  cbOrdemPagamentoCriarTipoJuros.Items.Clear;
  for k := 0 to Integer(High(TACBrSmartTEFFeeType)) do
    cbOrdemPagamentoCriarTipoJuros.Items.Add(SmartTEFFeeTypeToString(TACBrSmartTEFFeeType(k)));
  cbOrdemPagamentoCriarTipoJuros.ItemIndex := 0;

  cbUsuariosCriarTipo.Items.Clear;
  for l := 0 to Integer(High(TACBrSmartTEFUserType)) do
    cbUsuariosCriarTipo.Items.Add(SmartTEFUserTypeToString(TACBrSmartTEFUserType(l)));
  cbUsuariosCriarTipo.ItemIndex := 0;

  edPoolingConsultarData.DateTime := Today;
end;

procedure TfrPrincipal.AdicionarLog(aMsg: String);
begin
  if Assigned(mmEndpointsLog) then
    mmEndpointsLog.Lines.Add(aMsg);
end;

function TfrPrincipal.NomeArquivoConfig: String;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

end.

