unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, Buttons, Spin, ACBrIMendes, ACBrSocket;

const
  CURL_ACBR = 'https://projetoacbr.com.br';

type

  { TfrPrincipal }

  TfrPrincipal = class(TForm)
    ACBrIMendes1: TACBrIMendes;
    btConfigCancelar: TSpeedButton;
    btConfigLogArq: TSpeedButton;
    btConfigProxySenha: TSpeedButton;
    btConfigSalvar: TSpeedButton;
    btConsultarAlterados: TButton;
    btConsultarDescricao: TButton;
    btConsultarRegimesEspeciais: TButton;
    btEndpointsLimparLog: TSpeedButton;
    btConfigSenha: TSpeedButton;
    btHistoricoAcessoConsultar: TButton;
    btSaneamentoEnviar: TButton;
    cbConfigAmbiente: TComboBox;
    cbConfigLogNivel: TComboBox;
    edConfigCNPJ: TEdit;
    edConfigLogArq: TEdit;
    edConfigProxyHost: TEdit;
    edConfigProxyPorta: TSpinEdit;
    edConfigProxySenha: TEdit;
    edConfigProxyUsuario: TEdit;
    edConfigSenha: TEdit;
    edConfigTimeout: TSpinEdit;
    edConsultaAlteradosUF: TEdit;
    edConsultaDescricaoDescricao: TEdit;
    edConsultarRegimesEspeciaisUF: TEdit;
    gbConfigLog: TGroupBox;
    gbConfigProxy: TGroupBox;
    gbEndpointsLog: TGroupBox;
    gpConfigImendes: TGroupBox;
    gbConsultaDescricao: TGroupBox;
    gbConsultarAlterados: TGroupBox;
    gbRegimesEspeciais: TGroupBox;
    gbSaneamentoGrades: TGroupBox;
    gbHistoricoAcesso: TGroupBox;
    ImageList1: TImageList;
    lbConsultaAlteradosUF: TLabel;
    lbConsultaDescricaoDescricao: TLabel;
    lbConfigAmbiente: TLabel;
    lbConfigCNPJ: TLabel;
    lbConfigLogArq: TLabel;
    lbConfigLogNivel: TLabel;
    lbConfigProxyHost: TLabel;
    lbConfigProxyPorta: TLabel;
    lbConfigProxySenha: TLabel;
    lbConfigProxyUsuario: TLabel;
    lbConfigSenha: TLabel;
    lbConfigTimeout: TLabel;
    lbConsultarRegimesEspeciaisUF: TLabel;
    mmLog: TMemo;
    mmSaneamentoGrades: TMemo;
    pnSaneamentoGrades: TPanel;
    pnConsultaDescricao: TPanel;
    pnConsultarAlterados: TPanel;
    pnRegimesEspeciais: TPanel;
    pnHistoricoAcesso: TPanel;
    pnConsultarDescricao: TPanel;
    pgEndpoints: TPageControl;
    pgImendes: TPageControl;
    pnConfig: TPanel;
    pnConfigIMendes: TPanel;
    pnConfigLog: TPanel;
    pnConfigProxy: TPanel;
    pnConfigRodape: TPanel;
    pnEndpointsLog: TPanel;
    tsSaneamentoGrades: TTabSheet;
    tsConsultarDescricao: TTabSheet;
    tsEndpoints: TTabSheet;
    tsConfig: TTabSheet;
    procedure btConfigCancelarClick(Sender: TObject);
    procedure btConfigLogArqClick(Sender: TObject);
    procedure btConfigProxySenhaClick(Sender: TObject);
    procedure btConfigSalvarClick(Sender: TObject);
    procedure btConsultarAlteradosClick(Sender: TObject);
    procedure btConsultarDescricaoClick(Sender: TObject);
    procedure btConsultarRegimesEspeciaisClick(Sender: TObject);
    procedure btEndpointsLimparLogClick(Sender: TObject);
    procedure btConfigSenhaClick(Sender: TObject);
    procedure btSaneamentoEnviarClick(Sender: TObject);
    procedure btHistoricoAcessoConsultarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function NomeArquivoConfiguracao: String;
    function ConfiguracaoValida: Boolean;
    function FormatarJSON(const AJSON: String): String;

    procedure LerConfiguracao;
    procedure GravarConfiguracao;
    procedure AplicarConfiguracao;
    procedure SolicitarConfiguracao;

    procedure InicializarComponentesDefault;
    procedure RegistrarLogTela(aMensagem: String);
  public

  end;

function f: integer;

var
  frPrincipal: TfrPrincipal;

implementation

uses 
  {$IfDef FPC}
   fpjson, jsonparser, jsonscanner,
  {$Else}
    {$IFDEF DELPHIXE6_UP}JSON,{$ENDIF}
  {$EndIf}
  IniFiles, synacode, TypInfo,
  ACBrUtil.Base,
  ACBrUtil.FilesIO;
     
  {$IfDef FPC}
    {$R *.lfm}
  {$Else}
    {$R *.dfm}
  {$EndIf}

  { TfrPrincipal }

procedure TfrPrincipal.btConfigSenhaClick(Sender: TObject);
begin
  {$IfDef FPC}
  if btConfigSenha.Down then
    edConfigSenha.EchoMode := emNormal
  else
    edConfigSenha.EchoMode := emPassword;
  {$Else}
  if btConfigSenha.Down then
    edConfigSenha.PasswordChar := #0
  else
    edConfigSenha.PasswordChar := '*';
  {$EndIf}
end;

procedure TfrPrincipal.btSaneamentoEnviarClick(Sender: TObject);
begin
  if (not ConfiguracaoValida) then
    SolicitarConfiguracao;

  ACBrIMendes1.SaneamentoGradesRequest.AsJSON := mmSaneamentoGrades.Lines.Text;

  if ACBrIMendes1.SaneamentoGrades then
    RegistrarLogTela(FormatarJSON(ACBrIMendes1.SaneamentoGradesResponse.AsJSON))
  else
    RegistrarLogTela(FormatarJSON(ACBrIMendes1.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btHistoricoAcessoConsultarClick(Sender: TObject);
begin
  if (not ConfiguracaoValida) then
    SolicitarConfiguracao;

  if ACBrIMendes1.HistoricoAcesso(edConfigCNPJ.Text) then
    RegistrarLogTela(FormatarJSON(ACBrIMendes1.HistoricoAcessoResponse.AsJSON))
  else
    RegistrarLogTela(FormatarJSON(ACBrIMendes1.RespostaErro.AsJSON))
end;

procedure TfrPrincipal.FormCreate(Sender: TObject);
begin
  InicializarComponentesDefault;
  LerConfiguracao;
  if ConfiguracaoValida then
    pgImendes.ActivePage := tsEndpoints
  else
    pgImendes.ActivePage := tsConfig;
end;

function TfrPrincipal.NomeArquivoConfiguracao: String;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

procedure TfrPrincipal.LerConfiguracao;
var
  wIni: TIniFile;
begin
  RegistrarLogTela('- LerConfiguracao: ' + NomeArquivoConfiguracao);
  wIni := TIniFile.Create(NomeArquivoConfiguracao);
  try
    edConfigCNPJ.Text := wIni.ReadString('IMendes', 'CNPJ', EmptyStr);
    edConfigSenha.Text := StrCrypt(
      DecodeBase64(wIni.ReadString('IMendes', 'Senha', EmptyStr)), CURL_ACBR);
    cbConfigAmbiente.ItemIndex := wIni.ReadInteger('IMendes', 'Ambiente', 0);
    edConfigTimeout.Value := wIni.ReadInteger('IMendes', 'Timeout', 9000);

    edConfigProxyHost.Text := wIni.ReadString('Proxy', 'Host', EmptyStr);
    edConfigProxyPorta.Value := wIni.ReadInteger('Proxy', 'Porta', 0);
    edConfigProxyUsuario.Text := wIni.ReadString('Proxy', 'Usuario', EmptyStr);
    edConfigProxySenha.Text :=
      StrCrypt(DecodeBase64(wIni.ReadString('Proxy', 'Senha', EmptyStr)), CURL_ACBR);

    edConfigLogArq.Text := wIni.ReadString('Log', 'Arquivo', EmptyStr);
    cbConfigLogNivel.ItemIndex := wIni.ReadInteger('Log', 'Nivel', 0);
  finally
    wIni.Free;
  end;
  AplicarConfiguracao;
end;

procedure TfrPrincipal.GravarConfiguracao;
var
  wIni: TIniFile;
begin
  RegistrarLogTela('- GravarConfiguracao: ' + NomeArquivoConfiguracao);
  wIni := TIniFile.Create(NomeArquivoConfiguracao);
  try
    wIni.WriteString('IMendes', 'CNPJ', edConfigCNPJ.Text);
    wIni.WriteString('IMendes', 'Senha',
      EncodeBase64(StrCrypt(edConfigSenha.Text, CURL_ACBR)));
    wIni.WriteInteger('IMendes', 'Ambiente', cbConfigAmbiente.ItemIndex);
    wIni.WriteInteger('IMendes', 'Timeout', edConfigTimeout.Value);

    wIni.WriteString('Proxy', 'Host', edConfigProxyHost.Text);
    wIni.WriteInteger('Proxy', 'Porta', edConfigProxyPorta.Value);
    wIni.WriteString('Proxy', 'Usuario', edConfigProxyUsuario.Text);
    wIni.WriteString('Proxy', 'Senha',
      EncodeBase64(StrCrypt(edConfigProxySenha.Text, CURL_ACBR)));

    wIni.WriteString('Log', 'Arquivo', edConfigLogArq.Text);
    wIni.WriteInteger('Log', 'Nivel', cbConfigLogNivel.ItemIndex);
  finally
    wIni.Free;
  end;
  AplicarConfiguracao;
end;

procedure TfrPrincipal.AplicarConfiguracao;
begin
  ACBrIMendes1.CNPJ := edConfigCNPJ.Text;
  ACBrIMendes1.Senha := edConfigSenha.Text;
  ACBrIMendes1.TimeOut := edConfigTimeout.Value;
  ACBrIMendes1.Ambiente := TACBrIMendesAmbiente(cbConfigAmbiente.ItemIndex);

  ACBrIMendes1.ProxyHost := edConfigProxyHost.Text;
  ACBrIMendes1.ProxyPort := edConfigProxyPorta.Text;
  ACBrIMendes1.ProxyUser := edConfigProxyUsuario.Text;
  ACBrIMendes1.ProxyPass := edConfigProxySenha.Text;

  ACBrIMendes1.ArqLOG := edConfigLogArq.Text;
  ACBrIMendes1.NivelLog := cbConfigLogNivel.ItemIndex;
end;

procedure TfrPrincipal.SolicitarConfiguracao;
begin
  pgImendes.ActivePage := tsConfig;
  ShowMessage('Efetue a configuração do componente ACBrIMendes');
  Abort;
end;

function TfrPrincipal.ConfiguracaoValida: Boolean;
begin
  Result :=
    NaoEstaVazio(ACBrIMendes1.CNPJ) and NaoEstaVazio(ACBrIMendes1.Senha) and
    (ACBrIMendes1.Ambiente <> imaNenhum);
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

procedure TfrPrincipal.InicializarComponentesDefault;
var
  i: TACBrIMendesAmbiente;
begin
  cbConfigAmbiente.Items.Clear;
  for i := Low(TACBrIMendesAmbiente) to High(TACBrIMendesAmbiente) do
    cbConfigAmbiente.Items.Add(GetEnumName(TypeInfo(TACBrIMendesAmbiente), Integer(i)));
end;

procedure TfrPrincipal.RegistrarLogTela(aMensagem: String);
begin
  mmLog.Lines.Add(aMensagem);
end;

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

procedure TfrPrincipal.btConfigSalvarClick(Sender: TObject);
begin
  GravarConfiguracao;
end;

procedure TfrPrincipal.btConsultarAlteradosClick(Sender: TObject);
begin
  if (not ConfiguracaoValida) then
    SolicitarConfiguracao;

  if ACBrIMendes1.ConsultarAlterados(edConsultaAlteradosUF.Text, edConfigCNPJ.Text) then
    RegistrarLogTela(FormatarJSON(ACBrIMendes1.ConsultarAlteradosResponse.AsJSON))
  else
    RegistrarLogTela(FormatarJSON(ACBrIMendes1.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btConsultarDescricaoClick(Sender: TObject);
begin
  if (not ConfiguracaoValida) then
    SolicitarConfiguracao;

  if ACBrIMendes1.ConsultarDescricao(edConsultaDescricaoDescricao.Text, edConfigCNPJ.Text) then
    RegistrarLogTela(FormatarJSON(ACBrIMendes1.ConsultarDescricaoResponse.AsJSON))
  else
    RegistrarLogTela(FormatarJSON(ACBrIMendes1.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btConsultarRegimesEspeciaisClick(Sender: TObject);
begin
  if (not ConfiguracaoValida) then
    SolicitarConfiguracao;

  if ACBrIMendes1.ConsultarRegimesEspeciais(edConsultarRegimesEspeciaisUF.Text) then
    RegistrarLogTela(FormatarJSON(ACBrIMendes1.ConsultarRegimeEspecialResponse.AsJSON))
  else
    RegistrarLogTela(FormatarJSON(ACBrIMendes1.RespostaErro.AsJSON));
end;

procedure TfrPrincipal.btEndpointsLimparLogClick(Sender: TObject);
begin
  mmLog.Clear;
end;

procedure TfrPrincipal.btConfigLogArqClick(Sender: TObject);
var
  wFileLog: String;
begin
  if EstaVazio(edConfigLogArq.Text) then
  begin
    MessageDlg('Arquivo de Log não informado', mtError, [mbOK], 0);
    Exit;
  end;

  if (Pos(PathDelim, edConfigLogArq.Text) = 0) then
    wFileLog := ApplicationPath + edConfigLogArq.Text
  else
    wFileLog := edConfigLogArq.Text;

  if (not FileExists(wFileLog)) then
    MessageDlg('Arquivo ' + wFileLog + ' não encontrado', mtError, [mbOK], 0)
  else
    OpenURL(wFileLog);
end;

procedure TfrPrincipal.btConfigCancelarClick(Sender: TObject);
begin

  LerConfiguracao;
end;

function f(): integer;
begin
  Result := 0;
end;

end.
