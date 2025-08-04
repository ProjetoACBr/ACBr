unit Principal;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Buttons, ExtCtrls, Spin, Grids, ACBrCupomVerde, ACBrNFe, ACBrNFeDANFeESCPOS,
  ACBrDFe, ACBrPosPrinter, ACBrDFeReport, ACBrDFeDANFeReport,
  ACBrNFeDANFEClass, ACBrBase, ACBrSocket;

const
  CURL_ACBR = 'https://projetoacbr.com.br';

type

  TFluxoStatusVenda = (fsvVendendo, fsvFinalizada, fsvCancelada, fsvErro);

  { TfrPrincipal }

  TfrPrincipal = class(TForm)
    ACBrCupomVerde1: TACBrCupomVerde;
    ACBrNFe1: TACBrNFe;
    ACBrNFCeDANFeESCPOS1: TACBrNFeDANFeESCPOS;
    ACBrPosPrinter1: TACBrPosPrinter;
    btAcharXML: TSpeedButton;
    btAdicionar: TButton;
    btCancelar: TButton;
    btConfigLogArq: TSpeedButton;
    btConfigProxySenha: TSpeedButton;
    btConsultar: TButton;
    btEnviar: TButton;
    btFluxoNovaVenda: TBitBtn;
    btFluxoVendaCancelar: TBitBtn;
    btFluxoItemExcluir: TBitBtn;
    btFluxoItemIncluir: TBitBtn;
    btFluxoFinalizar: TBitBtn;
    btLimpar: TButton;
    btApagarLog: TButton;
    btConfigCancelar: TButton;
    btConfigSalvar: TButton;
    cbConfigAmbiente: TComboBox;
    cbConfigWebserviceUF: TComboBox;
    cbConfigWebserviceNFCeAmbiente: TComboBox;
    cbConfigLogNivel: TComboBox;
    cbConfigEmitenteTipoEmpresa: TComboBox;
    cbConfigEscPosCortarPapel: TCheckBox;
    cbConfigEscPosModelo: TComboBox;
    cbConfigEscPosPagCodigo: TComboBox;
    cbConfigEscPosPorta: TComboBox;
    edChave: TEdit;
    edCodDocumento: TEdit;
    edCodOperador: TEdit;
    edConfigEmitenteCNPJ: TEdit;
    edConfigEmitenteComplemento: TEdit;
    edConfigGeralIdToken: TEdit;
    edConfigGeralNFCeUlt: TEdit;
    edConfigGeralSerie: TEdit;
    edConfigGeralToken: TEdit;
    edConfigLogArq: TEdit;
    edConfigProxyHost: TEdit;
    edConfigProxyPorta: TSpinEdit;
    edConfigProxySenha: TEdit;
    edConfigProxyUsuario: TEdit;
    edConfigTimeout: TSpinEdit;
    edConfigxAPIKey: TEdit;
    edConfigOperador: TEdit;
    edCPF: TEdit;
    edCPF1: TEdit;
    edDescricao: TEdit;
    edFluxoClienteDoc: TEdit;
    edFluxoClienteNome: TEdit;
    edFluxoItemDescricao: TEdit;
    edFluxoItemEAN: TEdit;
    edFluxoItemValor: TEdit;
    edParcelas: TEdit;
    edConfigEmitenteBairro: TEdit;
    edConfigEmitenteCEP: TEdit;
    edConfigEmitenteCidade: TEdit;
    edConfigEmitenteCodCidade: TEdit;
    edConfigEmitenteFantasia: TEdit;
    edConfigEmitenteFone: TEdit;
    edConfigEmitenteIE: TEdit;
    edConfigEmitenteLogradouro: TEdit;
    edConfigEmitenteNumero: TEdit;
    edConfigEmitenteRazaoSocial: TEdit;
    edConfigEmitenteUF: TEdit;
    edConfigCertificadoCaminho: TEdit;
    edConfigCertificadoSenha: TEdit;
    edValorTotal: TEdit;
    edXML: TEdit;
    gbComprovantes: TGroupBox;
    gbConfigCertificado: TGroupBox;
    gbConfigGeral: TGroupBox;
    gbConfigWebservice: TGroupBox;
    gbConfigLog: TGroupBox;
    gbConfigProxy: TGroupBox;
    gbConfigEscPos: TGroupBox;
    gbFluxoCliente: TGroupBox;
    gbFluxoItens: TGroupBox;
    gbFluxoStatus: TGroupBox;
    gbFluxoTotal: TGroupBox;
    gdFluxoItens: TStringGrid;
    gbEndpointsLog: TGroupBox;
    gpCupomVerde: TGroupBox;
    gpConfigEmitente: TGroupBox;
    lbConfigCertificadoCaminho: TLabel;
    lbConfigCertificadoSenha: TLabel;
    lbConfigEmitenteComplemento: TLabel;
    lbConfigEmitenteIE: TLabel;
    lbConfigEmitenteRazaoSocial: TLabel;
    lbConfigEmitenteFantasia: TLabel;
    lbConfigEmitenteLogradouro: TLabel;
    lbConfigEmitenteNumero: TLabel;
    lbConfigEmitenteBairro: TLabel;
    lbConfigEmitenteCodCidade: TLabel;
    lbConfigEmitenteCidade: TLabel;
    lbConfigGeralIdToken: TLabel;
    lbConfigGeralNFCeUlt: TLabel;
    lbConfigGeralSerie: TLabel;
    lbConfigEscPosModelo: TLabel;
    lbConfigEscPosPagCodigo: TLabel;
    lbConfigEscPosColunas: TLabel;
    lbConfigEscPosEspacoLinhas: TLabel;
    lbConfigEscPosLinhasPular: TLabel;
    lbConfigGeralToken: TLabel;
    lbConfigWebserviceNFCeAmbiente: TLabel;
    lbConfigEmitenteUF: TLabel;
    lbConfigEmitenteCEP: TLabel;
    lbConfigEmitenteFone: TLabel;
    lbConfigEmitenteTipoEmpresa: TLabel;
    lbConfigAmbiente: TLabel;
    lbConfigEmitenteCNPJ: TLabel;
    lbConfigLogArq: TLabel;
    lbConfigLogNivel: TLabel;
    lbConfigNFCeAmbiente1: TLabel;
    lbConfigNFCeAmbiente2: TLabel;
    lbConfigProxyHost: TLabel;
    lbConfigProxyPorta: TLabel;
    lbConfigProxySenha: TLabel;
    lbConfigProxyUsuario: TLabel;
    lbConfigTimeout: TLabel;
    lbConfigEscPosPorta: TLabel;
    lbConfigxAPIKey: TLabel;
    lbConfigOperador: TLabel;
    lbFluxoClienteDoc: TLabel;
    lbFluxoClienteSempreVerde: TLabel;
    lbFluxoClienteNome: TLabel;
    lbFluxoItemDescricao: TLabel;
    lbFluxoItemEAN: TLabel;
    lbFluxoItemValor: TLabel;
    lbChave: TLabel;
    lbCodDocumento: TLabel;
    lbCodOperador: TLabel;
    lbComprovantes: TLabel;
    lbCPF: TLabel;
    lbCPF1: TLabel;
    lbDescricao: TLabel;
    lbParcelas: TLabel;
    lbValorTotal: TLabel;
    lbXML2: TLabel;
    mmLog: TMemo;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    pnConfigEscPos: TPanel;
    pnConfig2: TPanel;
    pgConfig: TPageControl;
    pgEndpoints: TPageControl;
    pnConfigCertificado: TPanel;
    pnConfigGeral: TPanel;
    pnConfigWebservice: TPanel;
    pnConfigCupomVerde: TPanel;
    pnConfigNFCe: TPanel;
    pnConfigLog: TPanel;
    pnConfigProxy: TPanel;
    pnEndpointsLog: TPanel;
    pnConfigRodape: TPanel;
    pgPrincipal: TPageControl;
    pnFluxoBackground: TPanel;
    pnFluxoBotoes: TPanel;
    pnFluxoBotoesPrincipais: TPanel;
    pnFluxoBotoesRight: TPanel;
    pnFluxoCliente: TPanel;
    pnFluxoDadosItem: TPanel;
    pnFluxoDiv1: TPanel;
    pnFluxoDiv2: TPanel;
    pnFluxoDiv3: TPanel;
    pnFluxoPagto: TPanel;
    pnFluxoRodape: TPanel;
    pnFluxoStatus: TPanel;
    pnFluxoTotal: TPanel;
    pnFluxoTotalStr: TPanel;
    pnPSP: TPanel;
    pnConfigEmitente: TPanel;
    btConfigCertificado: TSpeedButton;
    edConfigWebserviceTimeout: TSpinEdit;
    edConfigEscPosColunas: TSpinEdit;
    edConfigEscPosEspLinhas: TSpinEdit;
    edConfigEscPosLinhasPular: TSpinEdit;
    tmCupomSempreVerde: TTimer;
    tsConfigCupomVerde: TTabSheet;
    tsConfigNFCe: TTabSheet;
    tsConfig: TTabSheet;
    tsCancelarDocumento: TTabSheet;
    tsConsultarCPF: TTabSheet;
    tsEndpoints: TTabSheet;
    tsEnviarXML: TTabSheet;
    tsFluxo: TTabSheet;
    procedure ACBrNFe1Transmitted(const XML: String; HTTPResultCode: Integer);
    procedure btAdicionarClick(Sender: TObject);
    procedure btApagarLogClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btConfigSalvarClick(Sender: TObject);
    procedure btConsultarClick(Sender: TObject);
    procedure btEnviarClick(Sender: TObject);
    procedure btAcharXMLClick(Sender: TObject);
    procedure btFluxoFinalizarClick(Sender: TObject);
    procedure btFluxoItemExcluirClick(Sender: TObject);
    procedure btFluxoItemIncluirClick(Sender: TObject);
    procedure btFluxoNovaVendaClick(Sender: TObject);
    procedure btFluxoVendaCancelarClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure edFluxoClienteDocExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmCupomSempreVerdeTimer(Sender: TObject);
    procedure SetCupomSempreVerde(AValue: Boolean);
  private
    fCupomSempreVerde: Boolean;
    fFluxoStatusVenda: TFluxoStatusVenda;

    procedure LerConfiguracao;
    procedure GravarConfiguracao;
    procedure AplicarConfiguracao;
    procedure InicializarComponentesDefault;

    procedure AdicionarLinhaLog(AMensagem: String);
    procedure TratarException(Sender: TObject; E: Exception);
                             
    procedure FluxoReiniciar;
    procedure FluxoEnviarNFCe;
    procedure FluxoAlimentarNFCe;
    procedure FluxoInicializarGrid;
    procedure FluxoLimparInterface;
    procedure FluxoAvaliarInterface;
    procedure FluxoAtualizarValorTotal;
    procedure FluxoExibirErro(const aMsg: String);
    procedure FluxoCupomVerde(const aXML: AnsiString);
    procedure FluxoExcluirItemGrid(aGrid: TStringGrid; aIndex: Integer);
    procedure FluxoAdicionarItemGrid(aEan, aDescricao: String; aValor: Double);

    procedure PrepararImpressao;
    procedure AtualizarUltimaNFCe(aUltNFCe: Integer);
    procedure ExibirQRCodeCupomVerde(aQRCode: String);
    procedure AtualizarStatus(aStatus: TFluxoStatusVenda = fsvVendendo);

    function FluxoValorTotal: Double;
    function CarregarXML: AnsiString;
    function ConsultarCupomSempreVerde: Boolean;
    function GetNomeArquivoConfiguracao: String;
    function FormatarJSON(const AJSON: String): String;
  public      
    property NomeArquivoConfiguracao: String read GetNomeArquivoConfiguracao;
    property CupomSempreVerde: Boolean read fCupomSempreVerde write SetCupomSempreVerde;
    property FluxoStatusVenda: TFluxoStatusVenda read fFluxoStatusVenda;

    procedure ImprimirNFCeAtual;
    procedure ImprimirCupomVerdeNFCeAtual;
  end;

var
  frPrincipal: TfrPrincipal;

implementation

uses
  {$IfDef FPC}
   fpjson, jsonparser, jsonscanner,
  {$Else}
    {$IFDEF DELPHIXE2_UP}JSON,{$ENDIF}
  {$EndIf}
  synautil, synacode, IniFiles, blcksock, TypInfo,
  CupomVerdeQRCode,
  pcnConversao,
  pcnConversaoNFe,
  ACBrDFeUtil,
  ACBrDFeSSL,
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.FilesIO, Math;

{$R *.dfm}

{ TfrPrincipal }

procedure TfrPrincipal.btConsultarClick(Sender: TObject);
begin
  if EstaVazio(edCPF.Text) then
  begin
    ShowMessage('Preencha o CPF');
    Exit;
  end;

  if ACBrCupomVerde1.ConsultarCPF(edCPF.Text) then
    mmLog.Lines.Text := FormatarJSON(ACBrCupomVerde1.RespostaConsulta.AsJSON)
  else
    mmLog.Lines.Text := FormatarJSON(ACBrCupomVerde1.RespostaErro.AsJSON);
end;

procedure TfrPrincipal.btEnviarClick(Sender: TObject);
begin  
  if EstaVazio(edXML.Text) then
  begin
    ShowMessage('Preencha os Dados');
    Exit;
  end;

  ACBrCupomVerde1.ArqLOG := '_Log.txt';
  ACBrCupomVerde1.NivelLog := 4;
  ACBrCupomVerde1.XMLEnviado.xml := CarregarXML;
  ACBrCupomVerde1.XMLEnviado.cpf := edCPF1.Text;
  ACBrCupomVerde1.XMLEnviado.codigoOperador := edCodOperador.Text;
  ACBrCupomVerde1.XMLEnviado.codDocumento := edCodDocumento.Text;
  if ACBrCupomVerde1.EnviarXML then
  begin
    ShowMessage('Enviado com Sucesso!');
    mmLog.Lines.Text := FormatarJSON(ACBrCupomVerde1.RespostaConsulta.AsJSON)
  end
  else
  begin
    mmLog.Lines.Text := FormatarJSON(ACBrCupomVerde1.RespostaErro.AsJSON);
    ShowMessage('Erro ao enviar: ' + ACBrCupomVerde1.RespostaErro.message);
  end;
end;

procedure TfrPrincipal.btAdicionarClick(Sender: TObject);
begin
  with ACBrCupomVerde1.XMLEnviado.comprovantesPagamento.New do
  begin
    descricao := edDescricao.Text;
    parcelas := StrToIntDef(edParcelas.Text, 0);
    valorTotal := StrToFloatDef(edValorTotal.Text, 0);
  end;
  lbComprovantes.Caption := 'Comprovantes: ' + IntToStr(ACBrCupomVerde1.XMLEnviado.comprovantesPagamento.Count);
end;

procedure TfrPrincipal.ACBrNFe1Transmitted(const XML: AnsiString; HTTPResultCode: Integer);
var
  wCV: Boolean;
begin
  if ACBrNFe1.NotasFiscais[0].Confirmada then
  begin
    wCV := CupomSempreVerde or (MessageDlg('Deseja Cupom Verde?', mtConfirmation, [mbYes,mbNo], 0) = mrYes);
    if (not wCV) then
      ImprimirNFCeAtual
    else
      FluxoCupomVerde(ACBrNFe1.NotasFiscais[0].XML);
  end;
end;

procedure TfrPrincipal.btApagarLogClick(Sender: TObject);
begin
  mmLog.Lines.Clear;
end;

procedure TfrPrincipal.btCancelarClick(Sender: TObject);
begin
  if EstaVazio(edChave.Text) then
  begin
    ShowMessage('Preencha a Chave');
    Exit;
  end;

  if ACBrCupomVerde1.CancelarDocumento(edChave.Text) then
    ShowMessage('Cancelado com Sucesso!')
  else
    ShowMessage('Erro ao cancelar: ' + FormatarJSON(ACBrCupomVerde1.RespostaErro.message));
end;

procedure TfrPrincipal.btConfigSalvarClick(Sender: TObject);
begin
  GravarConfiguracao;
  AplicarConfiguracao;
end;

procedure TfrPrincipal.btAcharXMLClick(Sender: TObject);
begin
  if NaoEstaVazio(edXML.Text) then
    OpenDialog1.FileName := edXML.Text;
  if OpenDialog1.Execute then
    edXML.Text := OpenDialog1.FileName;
end;

procedure TfrPrincipal.btFluxoFinalizarClick(Sender: TObject);
begin
  try
    FluxoEnviarNFCe;
  finally
    AtualizarUltimaNFCe(ACBrNFe1.NotasFiscais[0].NFe.Ide.nNF);
    if (fFluxoStatusVenda <> fsvErro) then
      AtualizarStatus(fsvFinalizada);
  end;
end;

procedure TfrPrincipal.btFluxoItemExcluirClick(Sender: TObject);
begin
  if (MessageDlg('Deseja realmente excluir o Item?', mtConfirmation, mbOKCancel, 0) = mrNo) then
    Exit;

  FluxoExcluirItemGrid(gdFluxoItens, gdFluxoItens.Row);

  FluxoAtualizarValorTotal;
  FluxoAvaliarInterface;
end;

procedure TfrPrincipal.btFluxoItemIncluirClick(Sender: TObject);
var
  wValor: Double;
begin
  wValor := StrToFloatDef(edFluxoItemValor.Text, 1);

  if EstaVazio(edFluxoItemDescricao.Text) then
  begin
    ShowMessage('Informe a Descrição do Item');
    edFluxoItemDescricao.SetFocus;
  end
  else if EstaVazio(edFluxoItemEAN.Text) then
  begin
    ShowMessage('Informe o Código EAN do Item');
    edFluxoItemEAN.SetFocus;
  end
  else
  begin
    FluxoAdicionarItemGrid(
      Trim(edFluxoItemEAN.Text),
      Trim(edFluxoItemDescricao.Text),
      wValor);

    FluxoAtualizarValorTotal;
  end;

  FluxoAvaliarInterface;
end;

procedure TfrPrincipal.btFluxoNovaVendaClick(Sender: TObject);
begin
  FluxoReiniciar;
end;

procedure TfrPrincipal.btFluxoVendaCancelarClick(Sender: TObject);
var
  wChave, wCNPJ, wnProt: String;
begin
  if EstaZerado(ACBrNFe1.NotasFiscais.Count) then
  begin
    ShowMessage('Nenhuma NFCe a ser cancelada');
    Exit;
  end;
  
  wChave := OnlyNumber(ACBrNFe1.NotasFiscais[0].NFe.infNFe.ID);
  wCNPJ := Copy(wChave, 7, 14);
  wnProt := ACBrNFe1.NotasFiscais[0].NFe.procNFe.nProt;

  ACBrNFe1.NotasFiscais.Clear;
  ACBrNFe1.EventoNFe.Evento.Clear;
  with ACBrNFe1.EventoNFe.Evento.New do
  begin
    infEvento.CNPJ := wCNPJ;
    infEvento.chNFe := wChave;
    infEvento.dhEvento := Now;
    infEvento.tpEvento := teCancelamento;
    infEvento.detEvento.xJust := 'Cancelamento de documento pelo ACBrCupomVerdeTeste';
    infEvento.detEvento.nProt := wnProt;
  end;

  try
    if ACBrNFe1.EnviarEvento(1) then
    begin
      ACBrCupomVerde1.CancelarDocumento(wChave);
      ShowMessage('NFCe cancelada com sucesso' + sLineBreak + 'nProt: ' + wnProt);
      AtualizarStatus(fsvCancelada);
    end
    else
      ShowMessage('Erro ao cancelar NFCe');
  except
    on e: Exception do
      FluxoExibirErro('Erro ao cancelar NFCe:' + sLineBreak + e.Message);
  end;
end;

procedure TfrPrincipal.btLimparClick(Sender: TObject);
begin
  ACBrCupomVerde1.XMLEnviado.xml := EmptyStr;
  ACBrCupomVerde1.XMLEnviado.cpf := EmptyStr;
  ACBrCupomVerde1.XMLEnviado.codigoOperador := EmptyStr;
  ACBrCupomVerde1.XMLEnviado.codDocumento := EmptyStr;
  ACBrCupomVerde1.XMLEnviado.comprovantesPagamento.Clear;
end;

procedure TfrPrincipal.edFluxoClienteDocExit(Sender: TObject);
begin
  tmCupomSempreVerde.Enabled := True;
end;

procedure TfrPrincipal.FormCreate(Sender: TObject);
begin
  CupomSempreVerde := False;
  InicializarComponentesDefault;
  LerConfiguracao;
  FluxoReiniciar;
end;

procedure TfrPrincipal.tmCupomSempreVerdeTimer(Sender: TObject);
begin
  tmCupomSempreVerde.Enabled := False;
  CupomSempreVerde := ConsultarCupomSempreVerde;
end;

function TfrPrincipal.GetNomeArquivoConfiguracao: String;
begin
  Result := ChangeFileExt(Application.ExeName,'.ini');
end;

function TfrPrincipal.FormatarJSON(const AJSON: String): String;
{$IfDef FPC}
var
  jpar: TJSONParser;
  jdata: TJSONData;
  ms: TMemoryStream;
{$ELSE}
  {$IFDEF DELPHIXE2_UP}
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
      {$IFDEF DELPHIXE2_UP}
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
  AdicionarLinhaLog('- LerConfiguracao: ' + NomeArquivoConfiguracao);
  wIni := TIniFile.Create(NomeArquivoConfiguracao);
  try
    edConfigxAPIKey.Text := wIni.ReadString('CupomVerde', 'xAPIKey', '');
    edConfigOperador.Text := wIni.ReadString('CupomVerde', 'Operador', '');
    cbConfigAmbiente.ItemIndex := wIni.ReadInteger('CupomVerde', 'Ambiente', 0);
    edConfigTimeout.Value := wIni.ReadInteger('CupomVerde', 'Timeout', cHTTPTimeOutDef);

    edConfigProxyHost.Text := wIni.ReadString('Proxy', 'Host', '');
    edConfigProxyPorta.Text := wIni.ReadString('Proxy', 'Porta', '');
    edConfigProxyUsuario.Text := wIni.ReadString('Proxy', 'User', '');
    edConfigProxySenha.Text := StrCrypt(DecodeBase64(wIni.ReadString('Proxy', 'Pass', '')), CURL_ACBR);

    edConfigLogArq.Text := wIni.ReadString('Log', 'Arquivo', '');
    cbConfigLogNivel.ItemIndex := wIni.ReadInteger('Log', 'Nivel', 1);

    edConfigEmitenteCNPJ.Text := wIni.ReadString('Emitente', 'CNPJ', EmptyStr);
    edConfigEmitenteIE.Text := wIni.ReadString('Emitente', 'IE', EmptyStr);
    edConfigEmitenteFantasia.Text := wIni.ReadString('Emitente', 'Fantasia', EmptyStr);
    edConfigEmitenteRazaoSocial.Text := wIni.ReadString('Emitente', 'RazaoSocial', EmptyStr);
    cbConfigEmitenteTipoEmpresa.ItemIndex := wIni.ReadInteger('Emitente', 'Tipo', -1);
    edConfigEmitenteFone.Text := wIni.ReadString('Emitente', 'Fone', EmptyStr);
    edConfigEmitenteCEP.Text := wIni.ReadString('Emitente', 'CEP', EmptyStr);
    edConfigEmitenteLogradouro.Text := wIni.ReadString('Emitente', 'Logradouro', EmptyStr);
    edConfigEmitenteNumero.Text := wIni.ReadString('Emitente', 'Numero', EmptyStr);
    edConfigEmitenteBairro.Text := wIni.ReadString('Emitente', 'Bairro', EmptyStr);
    edConfigEmitenteCidade.Text := wIni.ReadString('Emitente', 'Cidade', EmptyStr);
    edConfigEmitenteUF.Text := wIni.ReadString('Emitente', 'UF', EmptyStr);
    edConfigEmitenteCodCidade.Text := wIni.ReadString('Emitente', 'CodCidade', EmptyStr);
    edConfigEmitenteComplemento.Text := wIni.ReadString('Emitente', 'Complemento', EmptyStr);

    edConfigCertificadoCaminho.Text := wIni.ReadString('Certificado', 'Caminho', EmptyStr);
    edConfigCertificadoSenha.Text := wIni.ReadString('Certificado', 'Senha', EmptyStr);

    cbConfigWebserviceUF.Text := wIni.ReadString('Webservice', 'UF', EmptyStr);
    cbConfigWebserviceNFCeAmbiente.ItemIndex := wIni.ReadInteger('Webservice', 'Ambiente', 1);
    edConfigWebserviceTimeout.Text := wIni.ReadString('Webservice', 'Timeout', EmptyStr);

    edConfigGeralSerie.Text := wIni.ReadString('NFCe', 'Serie', EmptyStr);
    edConfigGeralNFCeUlt.Text := wIni.ReadString('NFCe', 'NFCeUltima', EmptyStr);
    edConfigGeralIdToken.Text := wIni.ReadString('NFCe', 'IdToken', EmptyStr);
    edConfigGeralToken.Text := wIni.ReadString('NFCe', 'Token', EmptyStr);
    
    cbConfigEscPosModelo.ItemIndex := wIni.ReadInteger('EscPos', 'Modelo', Integer(ACBrPosPrinter1.Modelo));
    cbConfigEscPosPagCodigo.ItemIndex := wIni.ReadInteger('EscPos', 'PagCodigo', Integer(ACBrPosPrinter1.PaginaDeCodigo));
    cbConfigEscPosPorta.Text := wIni.ReadString('EscPos', 'Porta', ACBrPosPrinter1.Porta);
    edConfigEscPosColunas.Value := wIni.ReadInteger('EscPos', 'Colunas', ACBrPosPrinter1.Colunas);
    edConfigEscPosEspLinhas.Value := wIni.ReadInteger('EscPos', 'EspLinhas', ACBrPosPrinter1.EspacoEntreLinhas);
    edConfigEscPosLinhasPular.Value := wIni.ReadInteger('EscPos', 'LinhasPular', ACBrPosPrinter1.LinhasEntreCupons);
    cbConfigEscPosCortarPapel.Checked := wIni.ReadBool('EscPos', 'CortarPapel', True);
  finally
    wIni.Free;
  end;

  AplicarConfiguracao;
end;

procedure TfrPrincipal.GravarConfiguracao;
var
  wIni: TIniFile;
begin
  AdicionarLinhaLog('- LerConfiguracao: ' + NomeArquivoConfiguracao);
  wIni := TIniFile.Create(NomeArquivoConfiguracao);
  try
    wIni.WriteString('CupomVerde', 'xAPIKey', edConfigxAPIKey.Text);
    wIni.WriteString('CupomVerde', 'Operador', edConfigOperador.Text);
    wIni.WriteInteger('CupomVerde', 'Ambiente', cbConfigAmbiente.ItemIndex);
    wIni.WriteInteger('CupomVerde', 'Timeout', edConfigTimeout.Value);

    wIni.WriteString('Proxy', 'Host', edConfigProxyHost.Text);
    wIni.WriteString('Proxy', 'Porta', edConfigProxyPorta.Text);
    wIni.WriteString('Proxy', 'Usuario', edConfigProxyUsuario.Text);
    wIni.WriteString('Proxy', 'Senha', EncodeBase64(StrCrypt(edConfigProxySenha.Text, CURL_ACBR)));

    wIni.WriteString('Log', 'Arquivo', edConfigLogArq.Text);
    wIni.WriteInteger('Log', 'Nivel', cbConfigLogNivel.ItemIndex);

    wIni.WriteString('Emitente', 'CNPJ', edConfigEmitenteCNPJ.Text);
    wIni.WriteString('Emitente', 'IE', edConfigEmitenteIE.Text);
    wIni.WriteString('Emitente', 'Fantasia', edConfigEmitenteFantasia.Text);
    wIni.WriteString('Emitente', 'RazaoSocial', edConfigEmitenteRazaoSocial.Text);
    wIni.WriteInteger('Emitente', 'Tipo', cbConfigEmitenteTipoEmpresa.ItemIndex);
    wIni.WriteString('Emitente', 'Fone', edConfigEmitenteFone.Text);
    wIni.WriteString('Emitente', 'CEP', edConfigEmitenteCEP.Text);
    wIni.WriteString('Emitente', 'Logradouro', edConfigEmitenteLogradouro.Text);
    wIni.WriteString('Emitente', 'Numero', edConfigEmitenteNumero.Text);
    wIni.WriteString('Emitente', 'Bairro', edConfigEmitenteBairro.Text);
    wIni.WriteString('Emitente', 'Cidade', edConfigEmitenteCidade.Text);
    wIni.WriteString('Emitente', 'UF', edConfigEmitenteUF.Text);
    wIni.WriteString('Emitente', 'CodCidade', edConfigEmitenteCodCidade.Text);
    wIni.WriteString('Emitente', 'Complemento', edConfigEmitenteComplemento.Text);

    wIni.WriteString('Certificado', 'Caminho', edConfigCertificadoCaminho.Text);
    wIni.WriteString('Certificado', 'Senha', edConfigCertificadoSenha.Text);

    wIni.WriteString('Webservice', 'UF', cbConfigWebserviceUF.Text);
    wIni.WriteInteger('Webservice', 'Ambiente', cbConfigWebserviceNFCeAmbiente.ItemIndex);
    wIni.WriteString('Webservice', 'Timeout', edConfigWebserviceTimeout.Text);

    wIni.WriteString('NFCe', 'Serie', edConfigGeralSerie.Text);
    wIni.WriteString('NFCe', 'NFCeUltima', edConfigGeralNFCeUlt.Text);
    wIni.WriteString('NFCe', 'IdToken', edConfigGeralIdToken.Text);
    wIni.WriteString('NFCe', 'Token', edConfigGeralToken.Text);

    wIni.WriteInteger('EscPos', 'Modelo', cbConfigEscPosModelo.ItemIndex);
    wIni.WriteInteger('EscPos', 'PagCodigo', cbConfigEscPosPagCodigo.ItemIndex);
    wIni.WriteString('EscPos', 'Porta', cbConfigEscPosPorta.Text);
    wIni.WriteInteger('EscPos', 'Colunas', edConfigEscPosColunas.Value);
    wIni.WriteInteger('EscPos', 'EspLinhas', edConfigEscPosEspLinhas.Value);
    wIni.WriteInteger('EscPos', 'LinhasPular', edConfigEscPosLinhasPular.Value);
    wIni.WriteBool('EscPos', 'CortarPapel', cbConfigEscPosCortarPapel.Checked);
  finally
    wIni.Free;
  end;
end;

procedure TfrPrincipal.AplicarConfiguracao;
var
  Ok: boolean;
begin
  AdicionarLinhaLog('- AplicarConfiguracao');
  ACBrCupomVerde1.xApiKey := edConfigxAPIKey.Text;
  ACBrCupomVerde1.Ambiente := TACBrCupomVerdeAmbiente(cbConfigAmbiente.ItemIndex+1);
  ACBrCupomVerde1.TimeOut := edConfigTimeout.Value;

  ACBrCupomVerde1.ProxyHost := edConfigProxyHost.Text;
  ACBrCupomVerde1.ProxyPort := edConfigProxyPorta.Text;
  ACBrCupomVerde1.ProxyUser := edConfigProxyUsuario.Text;
  ACBrCupomVerde1.ProxyPass := edConfigProxySenha.Text;

  ACBrCupomVerde1.ArqLOG := edConfigLogArq.Text;
  ACBrCupomVerde1.NivelLog := cbConfigLogNivel.ItemIndex;

  ACBrNFe1.Configuracoes.Certificados.ArquivoPFX  := edConfigCertificadoCaminho.Text;
  ACBrNFe1.Configuracoes.Certificados.Senha := edConfigCertificadoSenha.Text;
  ACBrNFe1.SSL.DescarregarCertificado;

  ACBrNFe1.Configuracoes.Geral.SSLLib := libOpenSSL;
  ACBrNFe1.Configuracoes.Geral.FormaEmissao := teNormal;
  ACBrNFe1.Configuracoes.Geral.ModeloDF := moNFCe;
  ACBrNFe1.Configuracoes.Geral.VersaoDF := ve400;
  ACBrNFe1.Configuracoes.Geral.IdCSC := edConfigGeralIdToken.Text;
  ACBrNFe1.Configuracoes.Geral.CSC := edConfigGeralToken.Text;

  ACBrNFe1.Configuracoes.WebServices.UF := cbConfigWebserviceUF.Text;
  ACBrNFe1.Configuracoes.WebServices.Ambiente := StrToTpAmb(Ok, IntToStr(cbConfigWebserviceNFCeAmbiente.ItemIndex+1));

  ACBrNFe1.Configuracoes.WebServices.TimeOut   := edConfigWebserviceTimeout.Value;
  ACBrNFe1.Configuracoes.WebServices.ProxyHost := edConfigProxyHost.Text;
  ACBrNFe1.Configuracoes.WebServices.ProxyPort := edConfigProxyPorta.Text;
  ACBrNFe1.Configuracoes.WebServices.ProxyUser := edConfigProxyUsuario.Text;
  ACBrNFe1.Configuracoes.WebServices.ProxyPass := edConfigProxySenha.Text;
end;

procedure TfrPrincipal.InicializarComponentesDefault;
var
  i: TACBrPosPrinterModelo;
  j: TACBrPosPaginaCodigo;
begin
  cbConfigEscPosModelo.Items.Clear;
  for i := Low(TACBrPosPrinterModelo) to High(TACBrPosPrinterModelo) do
    cbConfigEscPosModelo.Items.Add(GetEnumName(TypeInfo(TACBrPosPrinterModelo), Integer(i)));

  cbConfigEscPosPagCodigo.Items.Clear;
  for j := Low(TACBrPosPaginaCodigo) to High(TACBrPosPaginaCodigo) do
    cbConfigEscPosPagCodigo.Items.Add(GetEnumName(TypeInfo(TACBrPosPaginaCodigo), Integer(j)));

  cbConfigEscPosPorta.Items.Clear;
  ACBrPosPrinter1.Device.AcharPortasSeriais(cbConfigEscPosPorta.Items);
  ACBrPosPrinter1.Device.AcharPortasRAW(cbConfigEscPosPorta.Items);

  {$IfDef MSWINDOWS}
  cbConfigEscPosPorta.Items.Add('LPT1');
  cbConfigEscPosPorta.Items.Add('\\localhost\Epson');
  cbConfigEscPosPorta.Items.Add('c:\temp\ecf.txt');
  {$EndIf}
  cbConfigEscPosPorta.Items.Add('TCP:192.168.0.31:9100');
end;

procedure TfrPrincipal.AdicionarLinhaLog(AMensagem: String);
begin
  if Assigned(mmLog) then
    mmLog.Lines.Add(AMensagem);
end;

procedure TfrPrincipal.SetCupomSempreVerde(AValue: Boolean);
begin
  fCupomSempreVerde := AValue;
  if fCupomSempreVerde then
    gbFluxoCliente.Caption := 'CLIENTE SEMPRE VERDE'
  else
    gbFluxoCliente.Caption := 'CLIENTE';
end;

procedure TfrPrincipal.TratarException(Sender: TObject; E: Exception);
begin
  AdicionarLinhaLog('');
  AdicionarLinhaLog('***************' + E.ClassName + '***************');
  AdicionarLinhaLog(E.Message);
  AdicionarLinhaLog('');

  if (pgPrincipal.ActivePage = tsConfig) then
    MessageDlg(E.Message, mtError, [mbOK], 0);
end;

procedure TfrPrincipal.FluxoEnviarNFCe;
begin
  ACBrNFe1.NotasFiscais.Clear;
  FluxoAlimentarNFCe;
  PrepararImpressao;
  try
    ACBrNFe1.Enviar(1, False, True);
  except
    on e: Exception do
      FluxoExibirErro('Erro ao enviar NFCe: ' + sLineBreak + e.Message);
  end;
end;

procedure TfrPrincipal.FluxoAlimentarNFCe;
var
  wVal, wTot, wTotICMS: Double;
  wCod: String;
  i: Integer;
begin
  {$IfDef FPC}
  wVal := 0;
  wTot := 0;
  {$EndIf}

  wTotICMS := 0;
  with ACBrNFe1.NotasFiscais.Add.NFe do
  begin
    Ide.natOp     := 'VENDA';
    Ide.indPag    := ipVista;
    Ide.modelo    := 65;
    Ide.serie     := StrToIntDef(edConfigGeralSerie.Text, 1);
    Ide.nNF       := StrToIntDef(edConfigGeralNFCeUlt.Text, 0) + 1;
    Ide.cNF       := GerarCodigoDFe(1);
    Ide.dEmi      := Now;
    Ide.dSaiEnt   := Now;
    Ide.hSaiEnt   := Now;
    Ide.tpNF      := tnSaida;
    Ide.tpEmis    := teNormal;
    Ide.tpAmb     := TpcnTipoAmbiente(cbConfigWebserviceNFCeAmbiente.ItemIndex);
    Ide.cUF       := 35;
    Ide.cMunFG    := 3554003;
    Ide.finNFe    := fnNormal;
    Ide.tpImp     := tiNFCe;
    Ide.indFinal  := cfConsumidorFinal;
    Ide.indPres   := pcPresencial;
    Ide.indIntermed := iiSemOperacao;
    Emit.CRT               := TpcnCRT(cbConfigEmitenteTipoEmpresa.ItemIndex);
    Emit.IE                := edConfigEmitenteIE.Text;
    Emit.CNPJCPF           := edConfigEmitenteCNPJ.Text;
    Emit.xNome             := edConfigEmitenteRazaoSocial.Text;
    Emit.xFant             := edConfigEmitenteFantasia.Text;
    Emit.EnderEmit.fone    := edConfigEmitenteFone.Text;
    Emit.EnderEmit.CEP     := StrToIntDef(OnlyNumber(edConfigEmitenteCEP.Text), 0);
    Emit.EnderEmit.xLgr    := edConfigEmitenteLogradouro.Text;
    Emit.EnderEmit.nro     := edConfigEmitenteNumero.Text;
    Emit.EnderEmit.xCpl    := edConfigEmitenteComplemento.Text;
    Emit.EnderEmit.xBairro := edConfigEmitenteBairro.Text;
    Emit.EnderEmit.cMun    := StrToIntDef(edConfigEmitenteCodCidade.Text, 0);
    Emit.EnderEmit.xMun    := edConfigEmitenteCidade.Text;
    Emit.EnderEmit.UF      := edConfigEmitenteUF.Text;
    Emit.enderEmit.cPais   := 1058;
    Emit.enderEmit.xPais   := 'BRASIL';

    for i := 1 to gdFluxoItens.RowCount-1 do
    begin
      if EstaZerado(i) then
        Continue;

      wCod := gdFluxoItens.Cells[0, i];
      wVal := StrToFloatDef(gdFluxoItens.Cells[2, i], 1);
      with Det.New do
      begin
        Prod.nItem     := i;
        Prod.cProd     := wCod;
        Prod.cEAN      := wCod;
        Prod.xProd     := gdFluxoItens.Cells[1, i];
        Prod.NCM       := '61051000';
        Prod.EXTIPI    := EmptyStr;
        Prod.CFOP      := '5101';
        Prod.uCom      := 'UN';
        Prod.qCom      := 1;
        Prod.vUnCom    := wVal;
        Prod.vProd     := wVal;
        Prod.cEANTrib  := wCod;
        Prod.uTrib     := 'UN';
        Prod.qTrib     := 1;
        Prod.vUnTrib   := wVal;
        Prod.cBarra    := wCod;
               
        if Emit.CRT in [crtSimplesExcessoReceita, crtRegimeNormal] then
          Imposto.ICMS.CST := cst00
        else
          Imposto.ICMS.CSOSN := csosn102;

        Imposto.ICMS.orig := oeNacional;
        Imposto.ICMS.modBC := dbiValorOperacao;
        Imposto.ICMS.vBC := wVal;
        Imposto.ICMS.pICMS := 18;
        Imposto.ICMS.vICMS := (Imposto.ICMS.vBC * Imposto.ICMS.pICMS)/100;
        Imposto.ICMS.modBCST := dbisMargemValorAgregado;
        Imposto.ICMS.pCredSN := 5;
        Imposto.ICMS.vCredICMSSN := 50;
        Imposto.ICMS.vBCFCPST := 1;
        Imposto.ICMS.pFCPST := 2;
        Imposto.ICMS.vFCPST := 2;
        Imposto.ICMS.motDesICMSST := mdiOutros;

        Imposto.PIS.CST := pis99;
        Imposto.PISST.IndSomaPISST := ispNenhum;
        Imposto.COFINS.CST := cof99;
        Imposto.COFINSST.indSomaCOFINSST :=  iscNenhum;

        wTot := wTot + wVal;
        wTotICMS := wTotICMS + Imposto.ICMS.vICMS;
      end;
    end;

    Total.ICMSTot.vBC     := wTot;
    Total.ICMSTot.vICMS   := wTotICMS;
    Total.ICMSTot.vProd   := wTot;
    Total.ICMSTot.vNF     := wTot;
    Transp.modFrete := mfSemFrete;

    with pag.New do
    begin
      tPag := fpDinheiro;
      vPag := wTot;
    end;
  end;

  ACBrNFe1.NotasFiscais.GerarNFe;
end;

procedure TfrPrincipal.ImprimirNFCeAtual;
begin
  if NaoEstaZerado(ACBrNFe1.NotasFiscais.Count) then
    ACBrNFe1.NotasFiscais[0].Imprimir;
end;

procedure TfrPrincipal.ImprimirCupomVerdeNFCeAtual;
begin
  if NaoEstaZerado(ACBrNFe1.NotasFiscais.Count) then
    ACBrNFe1.DANFE.ImprimirCupomVerde(ACBrCupomVerde1.RespostaEnviar.qrCode, ACBrCupomVerde1.RespostaEnviar.mensagem);
end;

procedure TfrPrincipal.FluxoCupomVerde(const aXML: AnsiString);
var
  wCPF: String;
begin
  wCPF := OnlyNumber(edFluxoClienteDoc.Text);
  if (not CupomSempreVerde) then
    InputQuery('Cupom Verde', 'Informe o CPF e/ou tecle <enter> para avançar', wCPF);

  // Deve ser preenchida a propriedade XMLEnviado
  ACBrCupomVerde1.XMLEnviado.xml := aXML;

  if NaoEstaVazio(edConfigOperador.Text) then
    ACBrCupomVerde1.XMLEnviado.codigoOperador := edConfigOperador.Text;
  //ACBrCupomVerde1.XMLEnviado.codDocumento := '';    // Caso exista

  if NaoEstaVazio(wCPF) then
    ACBrCupomVerde1.XMLEnviado.cpf := wCPF;
  
  if ACBrCupomVerde1.EnviarXML then
  begin
    if CupomSempreVerde then
      ShowMessage('Consumidor optante pelo Cupom Sempre Verde' + sLineBreak + 'Cupom Fiscal enviado com Sucesso!')
    else
    case ACBrCupomVerde1.RespostaEnviar.impressao of
      cviCompleto: ImprimirNFCeAtual;
      cviNaoImprimir: ExibirQRCodeCupomVerde(ACBrCupomVerde1.RespostaEnviar.qrCode);
      cviReduzido:
      begin
        ImprimirCupomVerdeNFCeAtual;
        ExibirQRCodeCupomVerde(ACBrCupomVerde1.RespostaEnviar.qrCode);
      end;
    end;

    mmLog.Lines.Text := ACBrCupomVerde1.RespostaConsulta.AsJSON;
  end
  else
  begin
    mmLog.Lines.Text := ACBrCupomVerde1.RespostaErro.AsJSON;
    ShowMessage('Erro ao enviar: ' + ACBrCupomVerde1.RespostaErro.message);
  end;
end;

procedure TfrPrincipal.AtualizarStatus(aStatus: TFluxoStatusVenda);

  procedure AtualizarPanelPrincipal(aTexto: String; aCor: TColor);
  begin
    pnFluxoStatus.Color := aCor;
    pnFluxoStatus.Caption := aTexto;
  end;

begin
  fFluxoStatusVenda := aStatus;
  FluxoAvaliarInterface;
  case fFluxoStatusVenda of
    fsvFinalizada: AtualizarPanelPrincipal('PAGAMENTO FINALIZADO', $0009E31F);
    fsvVendendo: AtualizarPanelPrincipal('VENDENDO', clMenuHighlight);
    fsvCancelada: AtualizarPanelPrincipal('CANCELADO', clRed)
  else
    AtualizarPanelPrincipal('ERRO', clRed);
  end;
end;

procedure TfrPrincipal.FluxoReiniciar;
begin
  ACBrNFe1.NotasFiscais.Clear;
  ACBrNFe1.EventoNFe.Evento.Clear;
  FluxoLimparInterface;
  FluxoAtualizarValorTotal;
  AtualizarStatus(fsvVendendo);
  lbFluxoClienteSempreVerde.Visible := False;
end;

procedure TfrPrincipal.FluxoInicializarGrid;
begin
  with gdFluxoItens do
  begin
    RowCount := 1;
    ColWidths[0] := 175;
    ColWidths[1] := 300;
    ColWidths[2] := 120;

    Cells[0,0] := 'EAN';
    Cells[1,0] := 'Descrição';
    Cells[2,0] := 'Valor';

    FluxoAdicionarItemGrid('0123456789012', 'Batata Doce', 3.69);
  end;
end;

procedure TfrPrincipal.FluxoAvaliarInterface;
var
  wVendendo: Boolean;
begin
  wVendendo := (fFluxoStatusVenda = fsvVendendo);
  gbFluxoCliente.Enabled := wVendendo;
  gbFluxoItens.Enabled := wVendendo;

  btFluxoFinalizar.Visible := wVendendo and (FluxoValorTotal > 0);
  btFluxoVendaCancelar.Visible := (fFluxoStatusVenda = fsvFinalizada);
  btFluxoNovaVenda.Visible := (not wVendendo);

  if gbFluxoItens.Enabled then
  begin
    btFluxoItemIncluir.Enabled := wVendendo;
    btFluxoItemExcluir.Enabled := wVendendo and (gdFluxoItens.RowCount > 1);
  end;
end;

procedure TfrPrincipal.FluxoAtualizarValorTotal;
var
  I: Integer;
  wTot: Double;
begin
  wTot := 0;
  for I := 1 to Pred(gdFluxoItens.RowCount) do
    wTot := wTot + StrToCurrDef(StringReplace(gdFluxoItens.Cells[2, I], '.', '', []), 0);
  pnFluxoTotalStr.Caption := FormatFloatBr(wTot, 'R$ ,0.00');
end;

procedure TfrPrincipal.FluxoLimparInterface;
begin
  edFluxoClienteDoc.Text := EmptyStr;
  edFluxoClienteNome.Text := EmptyStr;
  edFluxoItemEAN.Clear;
  edFluxoItemValor.Clear;
  edFluxoItemDescricao.Clear;
  FluxoInicializarGrid;
end;

procedure TfrPrincipal.FluxoExibirErro(const aMsg: String);
begin
  AtualizarStatus(fsvErro);
  ShowMessage(aMsg);
end;

procedure TfrPrincipal.FluxoExcluirItemGrid(aGrid: TStringGrid; aIndex: Integer);
var
  I, J: Integer;
begin
  with aGrid do
  begin
    for I := aIndex to RowCount - 2 do
      for J := 0 to ColCount - 1 do
        Cells[J, I] := Cells[J, I+1];

    RowCount := RowCount - 1
  end;
end;

procedure TfrPrincipal.FluxoAdicionarItemGrid(aEan, aDescricao: String; aValor: Double);
begin
  with gdFluxoItens do
  begin
    RowCount := RowCount + 1;
    Cells[0, RowCount-1] := aEAN;
    Cells[1, RowCount-1] := aDescricao;
    Cells[2, RowCount-1] := FormatFloatBr(aValor);
  end;
end;

function TfrPrincipal.FluxoValorTotal: Double;
begin
  Result := StrToFloatDef(RemoveString('R$ ', pnFluxoTotalStr.Caption), 0);
end;

procedure TfrPrincipal.PrepararImpressao;
begin
  ACBrPosPrinter1.Desativar;
  ACBrPosPrinter1.Porta := cbConfigEscPosPorta.Text;
  ACBrPosPrinter1.Modelo := TACBrPosPrinterModelo(cbConfigEscPosModelo.ItemIndex);
  ACBrPosPrinter1.PaginaDeCodigo := TACBrPosPaginaCodigo(cbConfigEscPosPagCodigo.ItemIndex);
  ACBrPosPrinter1.ColunasFonteNormal := edConfigEscPosColunas.Value;
  ACBrPosPrinter1.LinhasEntreCupons := edConfigEscPosLinhasPular.Value;
  ACBrPosPrinter1.EspacoEntreLinhas := edConfigEscPosEspLinhas.Value;
  ACBrPosPrinter1.CortaPapel := cbConfigEscPosCortarPapel.Checked;
  ACBrPosPrinter1.Ativar;
end;

procedure TfrPrincipal.AtualizarUltimaNFCe(aUltNFCe: Integer);
begin
  edConfigGeralNFCeUlt.Text := IntToStr(aUltNFCe);
  GravarConfiguracao;
end;

procedure TfrPrincipal.ExibirQRCodeCupomVerde(aQRCode: String);
var
  wFormQrcode: TfrQRCodeCupomVerde;
begin
  wFormQrcode := TfrQRCodeCupomVerde.Create(Self);
  try
    wFormQrcode.QRCode := aQRCode;
    wFormQrcode.ShowModal;
  finally
    wFormQrcode.Free;
  end;
end;

function TfrPrincipal.CarregarXML: AnsiString;
var
  fs: TFileStream;
  wXML: AnsiString;
  wFile: String;
begin
  Result := EmptyStr;
  wFile := edXML.Text;
  if EstaVazio(wFile) or (not FileExists(wFile)) then
    Exit;

  fs := TFileStream.Create(wFile, fmOpenRead or fmShareDenyWrite);
  try
    fs.Position := 0;
    wXML := ReadStrFromStream(fs, fs.Size);
    Result := wXML;
  finally
    fs.Free;
  end;
end;

function TfrPrincipal.ConsultarCupomSempreVerde: Boolean;
var
  wCPF: String;
begin
  Result := False;
  lbFluxoClienteSempreVerde.Visible := False;
  wCPF := OnlyNumber(edFluxoClienteDoc.Text);
  if EstaVazio(wCPF) or (Length(wCPF) <> 11) then
    Exit;

  Result := ACBrCupomVerde1.ConsultarCPF(wCPF) and ACBrCupomVerde1.RespostaConsulta.cupomSempreVerde;
  lbFluxoClienteSempreVerde.Visible := Result;
end;

end.

