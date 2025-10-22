unit Principal;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, Grids, Spin, blcksock, ACBrSocket, OpenSSLExt;

type

  { TfrPrincipal }

  TfrPrincipal = class(TForm)
    btEnviar: TBitBtn;
    btGravarINI: TBitBtn;
    btLerINI: TBitBtn;
    btLimpar: TBitBtn;
    btHeadersAdd: TButton;
    btHeadersClear: TButton;
    btCertificado: TSpeedButton;
    btCertificadosChave: TSpeedButton;
    btPFX: TSpeedButton;
    btPath: TButton;
    btQueryAdd: TButton;
    btQueryClear: TButton;
    btBodyParamsAdd: TButton;
    btBodyParamsClear: TButton;
    cbBasicAuth: TCheckBox;
    cbPFX: TCheckBox;
    cbBearerAuth: TCheckBox;
    cbCertificadosChave: TCheckBox;
    cbBody: TCheckBox;
    cbProtocolo: TComboBox;
    cbMetodo: TComboBox;
    cbBodyTipo: TComboBox;
    edBasicAuthPass: TEdit;
    edBasicAuthUser: TEdit;
    edBearerAuthToken: TEdit;
    edHeadersKey: TEdit;
    edHeadersValue: TEdit;
    edCertificado: TEdit;
    edCertificadosChave: TEdit;
    edPFX: TEdit;
    edURL: TEdit;
    edPath: TEdit;
    edQueryKey: TEdit;
    edQueryValue: TEdit;
    edBodyParamsKey: TEdit;
    edBodyParamsValue: TEdit;
    edPFXSenha: TEdit;
    edProxyHost: TEdit;
    edProxySenha: TEdit;
    edProxyUsuario: TEdit;
    gbBasicAuth: TGroupBox;
    gbHeaders: TGroupBox;
    gbPFX: TGroupBox;
    gbBearerAuth: TGroupBox;
    gbCertificadosChave: TGroupBox;
    gbGeral: TGroupBox;
    gbPath: TGroupBox;
    gbProxy: TGroupBox;
    gbQuery: TGroupBox;
    gbBody: TGroupBox;
    ImageList1: TImageList;
    lbHeadersKey: TLabel;
    lbHeadersValue: TLabel;
    lbProxyUsuario: TLabel;
    lbProxySenha: TLabel;
    lbProxyHost: TLabel;
    lbProxyPorta: TLabel;
    lbBasicAuthPass: TLabel;
    lbBasicAuthUser: TLabel;
    lbBearerAuthToken: TLabel;
    lbCertificado: TLabel;
    lbCertificadosChave: TLabel;
    lbPFX: TLabel;
    lbPFXSenha: TLabel;
    lbProtocolo: TLabel;
    lbMetodo: TLabel;
    lbBodyTipo: TLabel;
    lbURL: TLabel;
    lbPath: TLabel;
    lbQueryKey: TLabel;
    lbQueryValue: TLabel;
    lbBodyParamsKey: TLabel;
    lbBodyParamsValue: TLabel;
    lbResposta: TLabel;
    mmPath: TMemo;
    mmBody: TMemo;
    mmResposta: TMemo;
    OpenDialog1: TOpenDialog;
    pcPrincipal: TPageControl;
    pnHeaders: TPanel;
    pnHeaders2: TPanel;
    pnHeadersCabecalho: TPanel;
    pnCertificadosChave: TPanel;
    pnPFX: TPanel;
    pnParametros: TPanel;
    pnPath: TPanel;
    pnProxy: TPanel;
    pnQuery: TPanel;
    pnBody: TPanel;
    pnBodyCabecalho: TPanel;
    pnBodyParams: TPanel;
    pnBody2: TPanel;
    pnBasicAuth: TPanel;
    pnBearerAuth: TPanel;
    pnGeralConfig: TPanel;
    pnGeral: TPanel;
    pnPrincipal: TPanel;
    pnRodape: TPanel;
    pnResposta: TPanel;
    edProxyPorta: TSpinEdit;
    sgHeaders: TStringGrid;
    sgQuery: TStringGrid;
    sgBody: TStringGrid;
    tsHeaders: TTabSheet;
    tsProxy: TTabSheet;
    tsGeral: TTabSheet;
    tsAuth: TTabSheet;
    tsCertificados: TTabSheet;
    procedure btBodyParamsAddClick(Sender: TObject);
    procedure btBodyParamsClearClick(Sender: TObject);
    procedure btCertificadoClick(Sender: TObject);
    procedure btCertificadosChaveClick(Sender: TObject);
    procedure btEnviarClick(Sender: TObject);
    procedure btGravarINIClick(Sender: TObject);
    procedure btHeadersAddClick(Sender: TObject);
    procedure btHeadersClearClick(Sender: TObject);
    procedure btLerINIClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure btPathClick(Sender: TObject);
    procedure btPFXClick(Sender: TObject);
    procedure btQueryAddClick(Sender: TObject);
    procedure btQueryClearClick(Sender: TObject);
    procedure cbBasicAuthChange(Sender: TObject);
    procedure cbBearerAuthChange(Sender: TObject);
    procedure cbBodyChange(Sender: TObject);
    procedure cbBodyTipoChange(Sender: TObject);
    procedure cbCertificadosChaveChange(Sender: TObject);
    procedure cbPFXChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LerINI;
    procedure GravarINI;
    procedure LimparRequisicao;
    procedure InicializarBitmaps;

    procedure ConfigurarProxy(aHTTP: TACBrHTTP);

    procedure ConfigurarPFX(aHTTP: TACBrHTTP);  
    procedure ConfigurarCertificado(aHTTP: TACBrHTTP);
    procedure ConfigurarChavePrivada(aHTTP: TACBrHTTP);

    procedure ConfigurarBasicAuth(aHTTP: TACBrHTTP);
    procedure ConfigurarBearerAuth(aHTTP: TACBrHTTP);
    
    procedure ConfigurarHeaders(aHTTP: TACBrHTTP);
    procedure ConfigurarPathParams(aHTTP: TACBrHTTP);
    procedure ConfigurarQueryParams(aHTTP: TACBrHTTP);

    procedure ConfigurarBody(aHTTP: TACBrHTTP);
    procedure ConfigurarBodyText(aHTTP: TACBrHTTP);
    procedure ConfigurarBodyJSON(aHTTP: TACBrHTTP);
    procedure ConfigurarBodyUrlEncoded(aHTTP: TACBrHTTP);
    
    function IsJson(aStr: AnsiString): Boolean;
    function FormatarJSON(const AJSON: String): String;
  public
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
  synautil, IniFiles, StrUtils, synacode,
  ACBrUtil.FilesIO,
  ACBrUtil.Base;
      
{$IfDef FPC}
  {$R *.lfm}
{$Else}
  {$R *.dfm}
{$EndIf}

{ TfrPrincipal }

procedure TfrPrincipal.btPathClick(Sender: TObject);
begin
  mmPath.Lines.Add(edPath.Text);
  edPath.Text := EmptyStr;
end;

procedure TfrPrincipal.btPFXClick(Sender: TObject);
begin
  OpenDialog1.FileName := edPFX.Text;
  if OpenDialog1.Execute then
    edPFX.Text := OpenDialog1.FileName;
end;

procedure TfrPrincipal.btBodyParamsAddClick(Sender: TObject);
var
  i: Integer;
begin
  i := sgBody.RowCount;
  sgBody.RowCount := i+1;
  sgBody.Cells[0, i] := edBodyParamsKey.Text;
  sgBody.Cells[1, i] := edBodyParamsValue.Text;
  edBodyParamsKey.Text := EmptyStr;
  edBodyParamsValue.Text := EmptyStr;
end;

procedure TfrPrincipal.btBodyParamsClearClick(Sender: TObject);
begin
  sgBody.RowCount := 1;
end;

procedure TfrPrincipal.btCertificadoClick(Sender: TObject);
begin
  OpenDialog1.FileName := edCertificado.Text;
  if OpenDialog1.Execute then
    edCertificado.Text := OpenDialog1.FileName;
end;

procedure TfrPrincipal.btCertificadosChaveClick(Sender: TObject);
begin
  OpenDialog1.FileName := edCertificadosChave.Text;
  if OpenDialog1.Execute then
    edCertificadosChave.Text := OpenDialog1.FileName;
end;

procedure TfrPrincipal.btEnviarClick(Sender: TObject);
var
  http: TACBrHTTP;
  resp: AnsiString;
begin
  http := TACBrHTTP.Create(Nil);
  try
    http.ArqLOG := ApplicationPath + '_log.txt';
    http.NivelLog := 4;

    http.LimparHTTP;
    http.HTTPSend.Protocol := cbProtocolo.Text;

    ConfigurarProxy(http);
    ConfigurarPFX(http);
    ConfigurarCertificado(http);
    ConfigurarChavePrivada(http);
    ConfigurarHeaders(http);
    ConfigurarBasicAuth(http);
    ConfigurarBearerAuth(http);
    ConfigurarPathParams(http);
    ConfigurarQueryParams(http);
    ConfigurarBody(http);

    try
      http.HTTPMethod(cbMetodo.Text, edURL.Text);
    except
      on e: Exception do
      begin
        mmResposta.Lines.Text := e.Message;
        Exit;
      end;
    end;

    resp := http.HTTPResponse;
    mmResposta.Lines.Add('HTTPResultCode: ' + IntToStr(http.HTTPResultCode) + sLineBreak);
    mmResposta.Lines.Add('HTTPResponse: ' + sLineBreak);
    mmResposta.Lines.Add(IfThen(IsJson(resp), FormatarJSON(resp), resp));
  finally
    http.Free;
  end;
end;

procedure TfrPrincipal.btGravarINIClick(Sender: TObject);
begin
  GravarINI;
end;

procedure TfrPrincipal.btHeadersAddClick(Sender: TObject);
var
  i: Integer;
begin
  i := sgHeaders.RowCount;
  sgHeaders.RowCount := i+1;
  sgHeaders.Cells[0, i] := edHeadersKey.Text;
  sgHeaders.Cells[1, i] := edHeadersValue.Text;
  edHeadersKey.Text := EmptyStr;
  edHeadersValue.Text := EmptyStr;
end;

procedure TfrPrincipal.btHeadersClearClick(Sender: TObject);
begin
  sgHeaders.RowCount := 1;
end;

procedure TfrPrincipal.btLerINIClick(Sender: TObject);
begin
  LerINI;
end;

procedure TfrPrincipal.btLimparClick(Sender: TObject);
begin
  LimparRequisicao;
end;

procedure TfrPrincipal.btQueryAddClick(Sender: TObject);
var
  i: Integer;
begin
  i := sgQuery.RowCount;
  sgQuery.RowCount := i+1;
  sgQuery.Cells[0, i] := edQueryKey.Text;
  sgQuery.Cells[1, i] := edQueryValue.Text;
  edQueryKey.Text := EmptyStr;
  edQueryValue.Text := EmptyStr;
end;

procedure TfrPrincipal.btQueryClearClick(Sender: TObject);
begin
  sgQuery.RowCount := 1;
end;

procedure TfrPrincipal.cbBasicAuthChange(Sender: TObject);
begin
  pnBasicAuth.Enabled := cbBasicAuth.Checked;
  if cbBasicAuth.Checked then
    cbBearerAuth.Checked := False;
end;

procedure TfrPrincipal.cbBearerAuthChange(Sender: TObject);
begin
  pnBearerAuth.Enabled := cbBearerAuth.Checked;
  if cbBearerAuth.Checked then
    cbBasicAuth.Checked := False;
end;

procedure TfrPrincipal.cbBodyChange(Sender: TObject);
begin
  pnBody.Enabled := cbBody.Checked;
end;

procedure TfrPrincipal.cbBodyTipoChange(Sender: TObject);
var
  urlEncoded: Boolean;
begin
  urlEncoded := (cbBodyTipo.ItemIndex = 2);
  pnBodyParams.Visible := urlEncoded;
  sgBody.Visible := urlEncoded;
  mmBody.Visible := (not urlEncoded);
end;

procedure TfrPrincipal.cbCertificadosChaveChange(Sender: TObject);
begin
  pnCertificadosChave.Enabled := cbCertificadosChave.Checked;
  if cbCertificadosChave.Checked then
    cbPFX.Checked := False;
end;

procedure TfrPrincipal.cbPFXChange(Sender: TObject);
begin
  pnPFX.Enabled := cbPFX.Checked;
  if cbPFX.Checked then
    cbCertificadosChave.Checked := False;
end;

procedure TfrPrincipal.FormCreate(Sender: TObject);
begin
  LimparRequisicao;
  LerINI;
  pcPrincipal.ActivePageIndex := 0;
  InicializarBitmaps;
end;

procedure TfrPrincipal.LerINI;
var
  i: Integer;
  ini: TIniFile;
  queryParams, bodyUrlEnc, headers: TStringList;
begin
  LimparRequisicao;
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    edURL.Text := ini.ReadString('Geral', 'URL', EmptyStr);
    cbMetodo.ItemIndex := ini.ReadInteger('Geral', 'Metodo', 0);
    cbProtocolo.ItemIndex := ini.ReadInteger('Geral', 'Protocolo', 2);
    mmPath.Lines.Text := DecodeBase64(ini.ReadString('PathParam', 'Value', EmptyStr));

    if ini.SectionExists('QueryParam') then
    begin
      queryParams := TStringList.Create;
      try
        ini.ReadSectionValues('QueryParam', queryParams);
        sgQuery.RowCount := queryParams.Count + 1;
        for i := 0 to queryParams.Count-1 do
        begin
          sgQuery.Cells[0, i+1] := queryParams.Names[i];
          sgQuery.Cells[1, i+1] := queryParams.ValueFromIndex[i];
        end;
      finally
        queryParams.Free;
      end;
    end;

    cbBodyTipo.ItemIndex := ini.ReadInteger('Body', 'Tipo', 1);
    mmBody.Text := DecodeBase64(ini.ReadString('Body', 'Text', EmptyStr));
    if ini.SectionExists('BodyUrlEnc') then
    begin
      bodyUrlEnc := TStringList.Create;
      try
        ini.ReadSectionValues('BodyUrlEnc', bodyUrlEnc);
        sgBody.RowCount := bodyUrlEnc.Count + 1;
        for i := 0 to bodyUrlEnc.Count-1 do
        begin
          sgBody.Cells[0, i+1] := bodyUrlEnc.Names[i];
          sgBody.Cells[1, i+1] := bodyUrlEnc.ValueFromIndex[i];
        end;
      finally
        bodyUrlEnc.Free;
      end;
    end;

    if ini.SectionExists('Headers') then
    begin
      headers := TStringList.Create;
      try
        ini.ReadSectionValues('Headers', headers);
        sgHeaders.RowCount := headers.Count + 1;
        for i := 0 to headers.Count-1 do
        begin
          sgHeaders.Cells[0, i+1] := headers.Names[i];
          sgHeaders.Cells[1, i+1] := headers.ValueFromIndex[i];
        end;
      finally
        headers.Free;
      end;
    end;

    cbBasicAuth.Checked := ini.ReadBool('BasicAuth', 'Check', False);
    edBasicAuthUser.Text := ini.ReadString('BasicAuth', 'User', EmptyStr);
    edBasicAuthPass.Text := ini.ReadString('BasicAuth', 'Pass', EmptyStr);

    cbBearerAuth.Checked := ini.ReadBool('BearerAuth', 'Check', False);
    edBearerAuthToken.Text := ini.ReadString('BearerAuth', 'Token', EmptyStr);

    cbPFX.Checked := ini.ReadBool('PFX', 'Check', False);
    edPFX.Text := ini.ReadString('PFX', 'Arquivo', EmptyStr);
    edPFXSenha.Text := ini.ReadString('PFX', 'Senha', EmptyStr);

    cbCertificadosChave.Checked := ini.ReadBool('CertificadoChave', 'Check', False);
    edCertificadosChave.Text := ini.ReadString('CertificadoChave', 'ChaveArquivo', EmptyStr);
    edCertificado.Text := ini.ReadString('CertificadoChave', 'Arquivo', EmptyStr);

    edProxyHost.Text := ini.ReadString('Proxy', 'Host', EmptyStr);
    edProxyUsuario.Text := ini.ReadString('Proxy', 'User', EmptyStr);
    edProxySenha.Text := ini.ReadString('Proxy', 'Pass', EmptyStr);
    edProxyPorta.Value := ini.ReadInteger('Proxy', 'Porta', 0);
  finally
    ini.Free;
  end;
end;

procedure TfrPrincipal.GravarINI;
var
  ini: TIniFile;
  i: Integer;
begin
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    ini.WriteString('Geral', 'URL', edURL.Text);
    ini.WriteInteger('Geral', 'Metodo', cbMetodo.ItemIndex);
    ini.WriteInteger('Geral', 'Protocolo', cbProtocolo.ItemIndex);
    ini.WriteString('PathParam', 'Value', EncodeBase64(mmPath.Lines.Text));

    ini.EraseSection('QueryParam');
    for i := 1 to sgQuery.RowCount - 1 do
      ini.WriteString('QueryParam', sgQuery.Cells[0, i], sgQuery.Cells[1, i]);

    ini.WriteInteger('Body', 'Tipo', cbBodyTipo.ItemIndex);
    ini.WriteString('Body', 'Text', EncodeBase64(mmBody.Lines.Text));
    ini.EraseSection('BodyUrlEnc');
    for i := 1 to sgBody.RowCount-1 do
      ini.WriteString('BodyUrlEnc', sgBody.Cells[0, i], sgBody.Cells[1, i]);
                                
    ini.EraseSection('Headers');
    for i := 1 to sgHeaders.RowCount-1 do
      ini.WriteString('Headers', sgHeaders.Cells[0, i], sgHeaders.Cells[1, i]);

    ini.WriteBool('BasicAuth', 'Check', cbBasicAuth.Checked);
    ini.WriteString('BasicAuth', 'User', edBasicAuthUser.Text);
    ini.WriteString('BasicAuth', 'Pass', edBasicAuthPass.Text);

    ini.WriteBool('BearerAuth', 'Check', cbBearerAuth.Checked);
    ini.WriteString('BearerAuth', 'Token', edBearerAuthToken.Text);

    ini.WriteBool('PFX', 'Check', cbPFX.Checked);
    ini.WriteString('PFX', 'Arquivo', edPFX.Text);
    ini.WriteString('PFX', 'Senha', edPFXSenha.Text);

    ini.WriteBool('CertificadoChave', 'Check', cbPFX.Checked);
    ini.WriteString('CertificadoChave', 'ChaveArquivo', edCertificadosChave.Text);
    ini.WriteString('CertificadoChave', 'Arquivo', edCertificado.Text);

    ini.WriteString('Proxy', 'Host', edProxyHost.Text);
    ini.WriteString('Proxy', 'User', edProxyUsuario.Text);
    ini.WriteString('Proxy', 'Pass', edProxySenha.Text);
    ini.WriteInteger('Proxy', 'Porta', edProxyPorta.Value);
  finally
    ini.Free;
  end;
end;

procedure TfrPrincipal.LimparRequisicao;
begin
  edURL.Text := EmptyStr;
  cbMetodo.ItemIndex := 0;
  cbProtocolo.ItemIndex := 2;
  edPath.Text := EmptyStr;
  mmPath.Lines.Text := EmptyStr;
  edQueryKey.Text := EmptyStr;  
  edQueryValue.Text := EmptyStr;
  sgQuery.RowCount := 1;
  cbBody.Checked := False;
  cbBodyTipo.ItemIndex := 0;
  edBodyParamsKey.Text := EmptyStr;
  edBodyParamsValue.Text := EmptyStr;
  mmBody.Lines.Text := EmptyStr;
  sgBody.RowCount := 1;
  mmResposta.Lines.Text := EmptyStr;
  edHeadersKey.Text := EmptyStr;
  edHeadersValue.Text := EmptyStr;
  sgHeaders.RowCount := 1;
  cbBasicAuth.Checked := False;
  edBasicAuthUser.Text := EmptyStr;
  edBasicAuthPass.Text := EmptyStr;
  cbBearerAuth.Checked := False;
  edBearerAuthToken.Text := EmptyStr;
  cbPFX.Checked := False;
  edPFX.Text := EmptyStr;
  edPFXSenha.Text := EmptyStr;
  cbCertificadosChave.Checked := False;
  edCertificadosChave.Text := EmptyStr;
  edCertificado.Text := EmptyStr;
end;

procedure TfrPrincipal.InicializarBitmaps;
begin
  ImageList1.GetBitmap(10, btGravarINI.Glyph);
  ImageList1.GetBitmap(11, btLerINI.Glyph);
  ImageList1.GetBitmap(18, btLimpar.Glyph);
  ImageList1.GetBitmap(14, btEnviar.Glyph);
  ImageList1.GetBitmap(9, btPFX.Glyph);
  ImageList1.GetBitmap(9, btCertificado.Glyph);
  ImageList1.GetBitmap(9, btCertificadosChave.Glyph);
end;

procedure TfrPrincipal.ConfigurarProxy(aHTTP: TACBrHTTP);
begin
  if (not Assigned(aHTTP)) then
    Exit;

  aHTTP.ProxyHost := edProxyHost.Text;
  aHTTP.ProxyUser := edProxyUsuario.Text;
  aHTTP.ProxyPass := edProxySenha.Text;
  if NaoEstaZerado(edProxyPorta.Value) then
    aHTTP.ProxyPort := IntToStr(edProxyPorta.Value);
end;

procedure TfrPrincipal.ConfigurarPFX(aHTTP: TACBrHTTP);
begin
  if (not (Assigned(aHTTP) and cbPFX.Checked))  then
    Exit;

  if NaoEstaVazio(edPFX.Text) then
    aHTTP.ArquivoPFX := edPFX.Text;

  if NaoEstaVazio(edPFXSenha.Text) then
    aHTTP.SenhaPFX := edPFXSenha.Text;
end;

procedure TfrPrincipal.ConfigurarCertificado(aHTTP: TACBrHTTP);
begin
  if (not (Assigned(aHTTP) and cbCertificadosChave.Checked)) then
    Exit;

  if NaoEstaVazio(edCertificado.Text) then
    aHTTP.ArquivoCertificado := edCertificado.Text;

  if NaoEstaVazio(edPFXSenha.Text) then
    aHTTP.SenhaPFX := edPFXSenha.Text;
end;

procedure TfrPrincipal.ConfigurarChavePrivada(aHTTP: TACBrHTTP);
begin
  if (not (Assigned(aHTTP) and cbCertificadosChave.Checked)) then
    Exit;

end;

procedure TfrPrincipal.ConfigurarBasicAuth(aHTTP: TACBrHTTP);
begin
  if (not (Assigned(aHTTP) and cbBasicAuth.Checked)) then
    Exit;

  if NaoEstaVazio(edBasicAuthUser.Text) then
    aHTTP.HTTPSend.UserName := edBasicAuthUser.Text;

  if NaoEstaVazio(edBasicAuthPass.Text) then
    aHTTP.HTTPSend.Password := edBasicAuthPass.Text;
end;

procedure TfrPrincipal.ConfigurarBearerAuth(aHTTP: TACBrHTTP);
begin
  if (not (Assigned(aHTTP) and cbBearerAuth.Checked)) then
    Exit;

  if NaoEstaVazio(edBearerAuthToken.Text) then
    aHTTP.HTTPSend.Headers.Add(cHTTPHeaderAuthorization + ' ' +
      cHTTPAuthorizationBearer + ' ' + edBearerAuthToken.Text);
end;

procedure TfrPrincipal.ConfigurarHeaders(aHTTP: TACBrHTTP);
var
  i: Integer;
begin
  if (not Assigned(aHTTP)) or (sgHeaders.RowCount <= 1) then
    Exit;

  for i := 1 to sgHeaders.RowCount-1 do
    SetHeaderValue(sgHeaders.Cells[0, i], sgHeaders.Cells[1, i], aHTTP.HTTPSend.Headers);
end;

procedure TfrPrincipal.ConfigurarPathParams(aHTTP: TACBrHTTP);
var
  i: Integer;
begin
  if (not Assigned(aHTTP)) or EstaZerado(mmPath.Lines.Count) then
    Exit;

  for i := 0 to mmPath.Lines.Count-1 do
    aHTTP.URLPathParams.Add(mmPath.Lines[i]);
end;

procedure TfrPrincipal.ConfigurarQueryParams(aHTTP: TACBrHTTP);
var
  i: Integer;
begin
  if (not Assigned(aHTTP)) or (sgQuery.RowCount <= 1) then
    Exit;

  for i := 1 to sgQuery.RowCount-1 do
    aHTTP.URLQueryParams.Values[sgQuery.Cells[0, i]] := sgQuery.Cells[1, i];
end;

procedure TfrPrincipal.ConfigurarBody(aHTTP: TACBrHTTP);
begin
  case cbBodyTipo.ItemIndex of
    0: ConfigurarBodyText(aHTTP);
    1: ConfigurarBodyJSON(aHTTP);
    2: ConfigurarBodyUrlEncoded(aHTTP);
  end;
end;

procedure TfrPrincipal.ConfigurarBodyText(aHTTP: TACBrHTTP);
begin
  if (not Assigned(aHTTP)) then
    Exit;
                
  // IMPORTANTE:
  aHTTP.HTTPSend.MimeType := cContentTypeTextPlain;
  WriteStrToStream(aHTTP.HTTPSend.Document, mmBody.Text);
end;

procedure TfrPrincipal.ConfigurarBodyJSON(aHTTP: TACBrHTTP);
begin
  if (not Assigned(aHTTP)) then
    Exit;

  // IMPORTANTE:
  aHTTP.HTTPSend.MimeType := CContentTypeApplicationJSon;
  WriteStrToStream(aHTTP.HTTPSend.Document, mmBody.Text);
end;

procedure TfrPrincipal.ConfigurarBodyUrlEncoded(aHTTP: TACBrHTTP);
var
  i: Integer;
  body: TACBrHTTPQueryParams;
begin
  if (not Assigned(aHTTP)) then
    Exit;

  // IMPORTANTE:
  aHTTP.HTTPSend.MimeType := cContentTypeApplicationWwwFormUrlEncoded;

  body := TACBrHTTPQueryParams.Create;
  try
    for i := 1 to sgBody.RowCount-1 do
      body.Values[sgBody.Cells[0, i]] := sgBody.Cells[1, i];
    WriteStrToStream(aHTTP.HTTPSend.Document, body.AsURL);
  finally
    body.Free;
  end;
end;

function TfrPrincipal.IsJson(aStr: AnsiString): Boolean;
var
  s: String;
  t: Integer;
begin
  s := Trim(aStr);
  t := Length(s);
  Result := ((s[1] = #91) and (s[t] = #93)) or
            ((s[1] = #123) and (s[t] = #125));
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

end.

