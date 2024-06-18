unit FormPrincipal;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, Spin, ComCtrls, Grids, ExtDlgs, ACBrAbecsPinPad, 
  ACBrBase, ImgList, AppEvnts, ImageList;

const
  CSerialSection = 'Serial';
  CLogSection = 'Log';
  CPinPadSection = 'PinPad';

type

  { TfrMain }

  TfrMain = class(TForm)
    ACBrAbecsPinPad1: TACBrAbecsPinPad;
    btActivate: TBitBtn;
    btCancel: TButton;
    btCEX: TButton;
    btCLO: TButton;
    btDSP: TButton;
    btCLX: TButton;
    btDEX: TButton;
    btDMF: TButton;
    btDSI: TButton;
    btDSPClear: TButton;
    btDEXClear: TButton;
    btGCD: TButton;
    btGIN: TButton;
    btGIX: TButton;
    btGKY: TButton;
    btLMF: TButton;
    btMediaLoad: TButton;
    btMNU: TButton;
    btRMC: TButton;
    btSendQRCode: TButton;
    btOPN: TButton;
    btReadParms: TBitBtn;
    btSaveParams: TBitBtn;
    btSearchSerialPorts: TSpeedButton;
    btSearchSerialPorts1: TSpeedButton;
    btSerial: TSpeedButton;
    btACBrPinPadCapabilities: TButton;
    btPaintQRCode: TButton;
    cbCEXVerifyICCRemoval: TCheckBox;
    cbCEXVerifyCTLSPresence: TCheckBox;
    cbCEXVerifyMagnetic: TCheckBox;
    cbCEXVerifyICCInsertion: TCheckBox;
    cbSecure: TCheckBox;
    cbxMsgAlign: TComboBox;
    cbxGCD: TComboBox;
    cbxPort: TComboBox;
    cbGIXAll: TCheckBox;
    cbMsgWordWrap: TCheckBox;
    cbMNUHotKey: TCheckBox;
    cbCEXVerifyKey: TCheckBox;
    edGIXValue: TEdit;
    edMNUTitle: TEdit;
    edLogFile: TEdit;
    edMediaLoad: TEdit;
    edQRCodeImgName: TEdit;
    edtCLOMsg1: TEdit;
    edtCLOMsg2: TEdit;
    edtRMCMsg1: TEdit;
    edtRMCMsg2: TEdit;
    edtDSPMsg1: TEdit;
    edtDSPMsg2: TEdit;
    gbCLX: TGroupBox;
    gbDSX: TGroupBox;
    gbConfig: TGroupBox;
    gbConfig1: TGroupBox;
    gbExponent: TGroupBox;
    gbGKY: TGroupBox;
    gbModulus: TGroupBox;
    gbCLO: TGroupBox;
    gbMNU: TGroupBox;
    gbCEX: TGroupBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    gbDSP: TGroupBox;
    gbGIN: TGroupBox;
    gbGIX: TGroupBox;
    gbACBrPinPadCapabilities: TGroupBox;
    gbGCD: TGroupBox;
    imgMedia: TImage;
    imgQRCode: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbCLXMedias: TListBox;
    lbLMFMedias: TListBox;
    lbGIXParams: TListBox;
    mCLX: TMemo;
    mDEX: TMemo;
    mACBrPinPadCapabilities: TMemo;
    mCEXResponse: TMemo;
    mMNU: TMemo;
    mGIXResponse: TMemo;
    mGINResponse: TMemo;
    mExponent: TMemo;
    mLog: TMemo;
    mModulus: TMemo;
    mQRCode: TMemo;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    pGCDResponse: TPanel;
    pGKYResponse: TPanel;
    pMNUResponse: TPanel;
    pgMedia: TPageControl;
    pGINIDX: TPanel;
    pGIXParams: TPanel;
    pLMFMediaTitle: TPanel;
    pCLXMediaTitle: TPanel;
    pgCLX: TPageControl;
    pCommands: TPanel;
    pCancelar: TPanel;
    pConfigLogMsg: TPanel;
    pgcCommands: TPageControl;
    pKeys: TPanel;
    pLogs: TPanel;
    pMedia: TPanel;
    pMediaFile: TPanel;
    pMediaInfo: TPanel;
    pMediaLoad: TPanel;
    pMFButtons: TPanel;
    pQREGerado: TPanel;
    pQREMemo: TPanel;
    sbCleanMemoLog: TSpeedButton;
    sbGenerateKeys: TSpeedButton;
    sbMedia: TScrollBox;
    sbResponse: TStatusBar;
    sbShowLogFile: TSpeedButton;
    seMNUTimeOut: TSpinEdit;
    seGIN_ACQIDX: TSpinEdit;
    seLogLevel: TSpinEdit;
    seGCDTimeOut: TSpinEdit;
    seCEXTimeOut: TSpinEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    tsImage: TTabSheet;
    tsQRCode: TTabSheet;
    tsCLOLines: TTabSheet;
    tsCLOMedia: TTabSheet;
    tsAskEvent: TTabSheet;
    tsDisplay: TTabSheet;
    tsClose: TTabSheet;
    tsConfig: TTabSheet;
    tsGIX: TTabSheet;
    tsMultimidia: TTabSheet;
    tsOpen: TTabSheet;
    ApplicationEvents1: TApplicationEvents;
    ImageList1: TImageList;
    btDetectPinPad: TBitBtn;
    procedure ACBrAbecsPinPad1EndCommand(Sender: TObject);
    procedure ACBrAbecsPinPad1StartCommand(Sender: TObject);
    procedure ACBrAbecsPinPad1WaitForResponse(var Cancel: Boolean);
    procedure ACBrAbecsPinPad1WriteLog(const ALogLine: String;
      var Tratado: Boolean);
    procedure btACBrPinPadCapabilitiesClick(Sender: TObject);
    procedure btActivateClick(Sender: TObject);
    procedure btCEXClick(Sender: TObject);
    procedure btCLOClick(Sender: TObject);
    procedure btCLXClick(Sender: TObject);
    procedure btDEXClick(Sender: TObject);
    procedure btDMFClick(Sender: TObject);
    procedure btDSIClick(Sender: TObject);
    procedure btDEXClearClick(Sender: TObject);
    procedure btDSPClearClick(Sender: TObject);
    procedure btDSPClick(Sender: TObject);
    procedure btGCDClick(Sender: TObject);
    procedure btGINClick(Sender: TObject);
    procedure btGIXClick(Sender: TObject);
    procedure btGKYClick(Sender: TObject);
    procedure btMediaLoadClick(Sender: TObject);
    procedure btLMFClick(Sender: TObject);
    procedure btMNUClick(Sender: TObject);
    procedure btOPNClick(Sender: TObject);
    procedure btReadParmsClick(Sender: TObject);
    procedure btSearchSerialPorts1Click(Sender: TObject);
    procedure btSearchSerialPortsClick(Sender: TObject);
    procedure btRMCClick(Sender: TObject);
    procedure btSaveParamsClick(Sender: TObject);
    procedure btSendQRCodeClick(Sender: TObject);
    procedure btSerialClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btPaintQRCodeClick(Sender: TObject);
    procedure cbSecureChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbCleanMemoLogClick(Sender: TObject);
    procedure sbGenerateKeysClick(Sender: TObject);
    procedure sbShowLogFileClick(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure cbGIXAllClick(Sender: TObject);
    procedure cbMNUHotKeyClick(Sender: TObject);
    procedure btDetectPinPadClick(Sender: TObject);
  protected
    function ConfigFileName: String;
    procedure SaveParams;
    procedure ReadParams;

    procedure FindSerialPorts(AStringList: TStrings);
    procedure ShowResponseStatusBar;
    procedure AddStrToLog(const AStr: String);
    procedure ConfigPanelsCommands(IsActive: Boolean);
    procedure ConfigPanelCancel(IsCancel: Boolean);
    procedure ConfigACBrAbecsPinPad;

    procedure LoadMediaNames;
    procedure ShowMediaDimensions;
  public

  end;

var
  frMain: TfrMain;

implementation

uses
  TypInfo, IniFiles, DateUtils, Math,
  configuraserial,
  ACBrImage, ACBrDelphiZXingQRCode,
  ACBrUtiL.FilesIO,
  ACBrUtil.Strings;

{$R *.dfm}

{ TfrMain }

procedure TfrMain.FormCreate(Sender: TObject);
var
  i: TACBrAbecsMsgAlign;
  j: TACBrAbecsMSGIDX;
begin
  pCancelar.Visible := False;
  ConfigPanelCancel(False);
  ConfigPanelsCommands(False);
  pgcCommands.ActivePageIndex := 0;
  pgCLX.ActivePageIndex := 0;
  pgMedia.ActivePageIndex := 0;
  FindSerialPorts(cbxPort.Items);

  cbxMsgAlign.Items.Clear;
  For i := Low(TACBrAbecsMsgAlign) to High(TACBrAbecsMsgAlign) do
    cbxMsgAlign.Items.Add( GetEnumName(TypeInfo(TACBrAbecsMsgAlign), integer(i) ) ) ;

  cbxGCD.Items.Clear;
  For j := Low(TACBrAbecsMSGIDX) to High(TACBrAbecsMSGIDX) do
    cbxGCD.Items.Add( GetEnumName(TypeInfo(TACBrAbecsMSGIDX), integer(j) ) ) ;

  ReadParams;
  ShowMediaDimensions;
  mQRCode.Lines.Text := '00020126360014br.gov.bcb.pix0114187605400001395204000053039865406100'+
                        '.005802BR5912PROJETO ACBR6005Tatui61081827017062070503***63048F90';
  btPaintQRCode.Click;
end;

procedure TfrMain.sbCleanMemoLogClick(Sender: TObject);
begin
  mLog.Lines.Clear;
end;

procedure TfrMain.sbGenerateKeysClick(Sender: TObject);
begin
  // TODO: Generate new Keys
end;

procedure TfrMain.sbShowLogFileClick(Sender: TObject);
var
  AFileLog: String;
begin
  if pos(PathDelim,edLogFile.Text) = 0 then
    AFileLog := ApplicationPath + edLogFile.Text
  else
    AFileLog := edLogFile.Text;

  OpenURL( AFileLog );
end;

function TfrMain.ConfigFileName: String;
begin
  Result := ChangeFileExt( Application.ExeName,'.ini' ) ;
end;

procedure TfrMain.SaveParams;
Var
  ini: TIniFile ;
begin
  AddStrToLog('- SaveParams');

  ini := TIniFile.Create(ConfigFileName);
  try
    ini.WriteString(CSerialSection, 'Port', cbxPort.Text);
    ini.WriteString(CSerialSection,'ParamsString', ACBrAbecsPinPad1.Device.ParamsString);
    ini.WriteString(CLogSection, 'File', edLogFile.Text);
    ini.WriteInteger(CLogSection, 'Level', seLogLevel.Value);
    ini.WriteInteger(CPinPadSection, 'MsgAlign', cbxMsgAlign.ItemIndex);
    ini.WriteBool(CPinPadSection, 'MsgWordWrap', cbMsgWordWrap.Checked);
  finally
    ini.Free ;
  end ;
end;

procedure TfrMain.ReadParams;
Var
  ini: TIniFile ;
begin
  AddStrToLog('- ReadParams');

  ini := TIniFile.Create(ConfigFileName);
  try
    cbxPort.Text := ini.ReadString(CSerialSection, 'Port', '');
    ACBrAbecsPinPad1.Device.ParamsString := ini.ReadString(CSerialSection,'ParamsString', '');
    edLogFile.Text := ini.ReadString(CLogSection, 'File', '');
    seLogLevel.Value := ini.ReadInteger(CLogSection, 'Level', 2);
    cbxMsgAlign.ItemIndex := ini.ReadInteger(CPinPadSection, 'MsgAlign', 3);
    cbMsgWordWrap.Checked := ini.ReadBool(CPinPadSection, 'MsgWordWrap', True);
  finally
    ini.Free ;
  end ;
end;

procedure TfrMain.FindSerialPorts(AStringList: TStrings);
begin
  AStringList.Clear;
  ACBrAbecsPinPad1.Device.AcharPortasSeriais( AStringList );
  {$IfNDef MSWINDOWS}
   AStringList.Add('/dev/ttyS0') ;
   AStringList.Add('/dev/ttyUSB0') ;
  {$EndIf}
end;

procedure TfrMain.ShowResponseStatusBar;
begin
  sbResponse.Panels[0].Text := Format('STAT: %d', [ACBrAbecsPinPad1.Response.STAT]);
  sbResponse.Panels[1].Text := ReturnStatusCodeDescription(ACBrAbecsPinPad1.Response.STAT);
end;

procedure TfrMain.AddStrToLog(const AStr: String);
begin
  mLog.Lines.Add(AStr);
end;

procedure TfrMain.ConfigPanelsCommands(IsActive: Boolean);
var
  i: Integer;
begin
  if IsActive then
  begin
    btActivate.Caption := 'Desativar';
    btActivate.Tag := 1;
  end
  else
  begin
    btActivate.Caption := 'Ativar';
    btActivate.Tag := 0;
  end;

  for i := 1 to pgcCommands.PageCount-1 do
    pgcCommands.Pages[i].Enabled := IsActive;
end;

procedure TfrMain.ConfigPanelCancel(IsCancel: Boolean);
var
  i: Integer;
begin
  pCancelar.Visible := IsCancel;
  for i := 1 to pgcCommands.PageCount-1 do
    pgcCommands.Pages[i].Enabled := not IsCancel;
end;


procedure TfrMain.ConfigACBrAbecsPinPad;
begin
  ACBrAbecsPinPad1.LogFile := edLogFile.Text;
  ACBrAbecsPinPad1.LogLevel := seLogLevel.Value;
  ACBrAbecsPinPad1.Port := cbxPort.Text;
  ACBrAbecsPinPad1.MsgAlign := TACBrAbecsMsgAlign(cbxMsgAlign.ItemIndex);
  ACBrAbecsPinPad1.MsgWordWrap := cbMsgWordWrap.Checked;
end;

procedure TfrMain.LoadMediaNames;
var
  sl: TStringList;
begin
  ACBrAbecsPinPad1.LMF;

  sl := TStringList.Create;
  try
    ACBrAbecsPinPad1.Response.GetResponseFromTagValue(PP_MFNAME, sl);
    lbLMFMedias.Items.Assign(sl);
    if (sl.Count < 1) then
      pLMFMediaTitle.Caption := 'No media files'
    else
      pLMFMediaTitle.Caption := Format('%d media file(s)', [sl.Count]);

    pCLXMediaTitle.Caption := pLMFMediaTitle.Caption;
    lbCLXMedias.Items.Assign(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrMain.ShowMediaDimensions;
begin
  pMediaInfo.Caption := Format('w:%d x h:%d', [imgMedia.Picture.Width, imgMedia.Picture.Height]);
end;


procedure TfrMain.btSerialClick(Sender: TObject);
var
  frConfiguraSerial: TfrConfiguraSerial;
begin
  frConfiguraSerial := TfrConfiguraSerial.Create(self);
  try
    frConfiguraSerial.Device.Porta        := ACBrAbecsPinPad1.Device.Porta ;
    frConfiguraSerial.cmbPortaSerial.Text := cbxPort.Text ;
    frConfiguraSerial.Device.ParamsString := ACBrAbecsPinPad1.Device.ParamsString ;

    if frConfiguraSerial.ShowModal = mrOk then
    begin
      cbxPort.Text := frConfiguraSerial.cmbPortaSerial.Text ;
      ACBrAbecsPinPad1.Device.ParamsString := frConfiguraSerial.Device.ParamsString ;
    end ;
  finally
    FreeAndNil( frConfiguraSerial ) ;
  end ;
end;

procedure TfrMain.btSearchSerialPortsClick(Sender: TObject);
begin
  FindSerialPorts(cbxPort.Items);
  if (cbxPort.ItemIndex < 0) and (cbxPort.Items.Count>0) then
    cbxPort.ItemIndex := 0;
end;

procedure TfrMain.btActivateClick(Sender: TObject);
begin
  if not ACBrAbecsPinPad1.IsEnabled then
  begin
    SaveParams;
    ConfigACBrAbecsPinPad;
  end;

  ACBrAbecsPinPad1.IsEnabled := (btActivate.Tag = 0);
  ConfigPanelsCommands(ACBrAbecsPinPad1.IsEnabled);
  if ACBrAbecsPinPad1.IsEnabled then
  begin
    if (ACBrAbecsPinPad1.PinPadCapabilities.DisplayGraphicPixels.Rows > 0) then
      LoadMediaNames;
    pgcCommands.ActivePageIndex := 1;
  end;
end;

procedure TfrMain.ACBrAbecsPinPad1EndCommand(Sender: TObject);
begin
  ConfigPanelCancel(False);
  ShowResponseStatusBar;
end;

procedure TfrMain.ACBrAbecsPinPad1StartCommand(Sender: TObject);
begin
  if ACBrAbecsPinPad1.Command.IsBlocking then
    ConfigPanelCancel(True);
end;

procedure TfrMain.ACBrAbecsPinPad1WaitForResponse(var Cancel: Boolean);
begin
  Application.ProcessMessages;
  Cancel := not pCancelar.Visible;
end;

procedure TfrMain.ACBrAbecsPinPad1WriteLog(const ALogLine: String;
  var Tratado: Boolean);
begin
  AddStrToLog(ALogLine);
  Tratado := False;
end;

procedure TfrMain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  AddStrToLog('');
  AddStrToLog('** '+E.ClassName+' **');
  AddStrToLog(E.Message);
  ShowResponseStatusBar;
end;

procedure TfrMain.btACBrPinPadCapabilitiesClick(Sender: TObject);
begin
  with ACBrAbecsPinPad1.PinPadCapabilities do
  begin
    mACBrPinPadCapabilities.Lines.Add('SerialNumber: '+SerialNumber);
    mACBrPinPadCapabilities.Lines.Add('PartNumber: '+PartNumber);
    mACBrPinPadCapabilities.Lines.Add('Model: '+Model);
    mACBrPinPadCapabilities.Lines.Add('Memory: '+Memory);
    mACBrPinPadCapabilities.Lines.Add('Manufacturer: '+Manufacturer);
    mACBrPinPadCapabilities.Lines.Add('SupportContactless: '+BoolToStr(SupportContactless, True));
    mACBrPinPadCapabilities.Lines.Add('DisplayIsGraphic: '+BoolToStr(DisplayIsGraphic, True));
    mACBrPinPadCapabilities.Lines.Add('DisplayIsColor: '+BoolToStr(DisplayIsColor, True));
    mACBrPinPadCapabilities.Lines.Add('SpecificationVersion: '+FloatToStr(SpecificationVersion));
    mACBrPinPadCapabilities.Lines.Add('DisplayTextModeDimensions.Rows: '+IntToStr(DisplayTextModeDimensions.Rows));
    mACBrPinPadCapabilities.Lines.Add('DisplayTextModeDimensions.Cols: '+IntToStr(DisplayTextModeDimensions.Cols));
    mACBrPinPadCapabilities.Lines.Add('DisplayGraphicPixels.Rows: '+IntToStr(DisplayGraphicPixels.Rows));
    mACBrPinPadCapabilities.Lines.Add('DisplayGraphicPixels.Cols: '+IntToStr(DisplayGraphicPixels.Cols));
    mACBrPinPadCapabilities.Lines.Add('MediaPNGisSupported: '+BoolToStr(MediaPNGisSupported, True));
    mACBrPinPadCapabilities.Lines.Add('MediaJPGisSupported: '+BoolToStr(MediaJPGisSupported, True));
    mACBrPinPadCapabilities.Lines.Add('MediaGIFisSupported: '+BoolToStr(MediaGIFisSupported, True));
  end;
end;

procedure TfrMain.btCEXClick(Sender: TObject);
var
  s: String;

  procedure AddResponseToLog(t: Word);
  var
    v: AnsiString;
  begin
    v := ACBrAbecsPinPad1.Response.GetResponseFromTagValue(t);
    if (Trim(v) = '') then
      Exit;

    mCEXResponse.Lines.Add(PP_ToStr(t)+' => '+v);
  end;
begin
  s := '';
  if cbCEXVerifyKey.Checked then
    s := s + 'Press Key'+CR;
  if cbCEXVerifyMagnetic.Checked then
    s := s + 'Swipe the card'+CR;
  if cbCEXVerifyICCInsertion.Checked then
    s := s + 'Insert card'+CR;
  if cbCEXVerifyICCRemoval.Checked then
    s := s + 'Remove card'+CR;
  if cbCEXVerifyCTLSPresence.Checked then
    s := s + 'Bring card closer'+CR;

  s := Trim(s);
  mCEXResponse.Lines.Add('------------------------------');
  mCEXResponse.Lines.Add(s);
  ACBrAbecsPinPad1.DEX(s);
  try
    ACBrAbecsPinPad1.CEX( cbCEXVerifyKey.Checked,
                          cbCEXVerifyMagnetic.Checked,
                          cbCEXVerifyICCInsertion.Checked,
                          cbCEXVerifyICCRemoval.Checked,
                          cbCEXVerifyCTLSPresence.Checked,
                          seCEXTimeOut.Value);
  except
    On E: EACBrAbecsPinPadTimeout do
    begin
      ACBrAbecsPinPad1.DEX('TIMEOUT');
      mCEXResponse.Lines.Add('* TIMEOUT *');
      Exit;
    end
    else
    begin
      ACBrAbecsPinPad1.DEX();
      raise;
    end;
  end;

  mCEXResponse.Lines.Add('');
  AddResponseToLog(PP_EVENT);
  AddResponseToLog(PP_VALUE);
  AddResponseToLog(PP_DATAOUT);
  AddResponseToLog(PP_CARDTYPE);
  AddResponseToLog(PP_PAN);
  AddResponseToLog(PP_PANSEQNO);
  AddResponseToLog(PP_CHNAME);
  AddResponseToLog(PP_LABEL);
  AddResponseToLog(PP_ISSCNTRY);
  AddResponseToLog(PP_CARDEXP);
  AddResponseToLog(PP_DEVTYPE);
  AddResponseToLog(PP_TRK1INC);
  AddResponseToLog(PP_TRK2INC);
  AddResponseToLog(PP_TRK3INC);

  s := Trim(ACBrAbecsPinPad1.Response.GetResponseFromTagValue(PP_EVENT));
  if (s <> '') then
    s := 'Event: '+s;
  ACBrAbecsPinPad1.DEX(s);
end;

procedure TfrMain.btDEXClick(Sender: TObject);
begin
  ACBrAbecsPinPad1.DEX(mDEX.Lines.Text);
end;

procedure TfrMain.btDMFClick(Sender: TObject);
var
  sl: TStringList;
  s: String;
  i: Integer;
begin
  if (lbLMFMedias.SelCount < 1) then
    raise Exception.Create('No Media selected');

  if (MessageDlg( Format('Delete %d Media file(s)',[lbLMFMedias.SelCount]),
                  mtConfirmation,
                  [mbYes,mbNo], 0) <> mrYes) then
    Exit;

  s := '';
  for i := 0 to lbLMFMedias.Items.Count - 1 do
  begin
    if lbLMFMedias.Selected[i] then
    begin
      if (s = '') then
        s := lbLMFMedias.Items[i]
      else
        s := s + CR+LF + lbLMFMedias.Items[i];
    end;
  end;

  if (lbLMFMedias.SelCount = 1) then
    ACBrAbecsPinPad1.DMF(s)
  else
  begin
    sl := TStringList.Create;
    try
      sl.Text := s;
      ACBrAbecsPinPad1.DMF(sl);
    finally
      sl.Free;
    end;
  end;

  LoadMediaNames;
end;

procedure TfrMain.btDSIClick(Sender: TObject);
var
  i: Integer;
begin
  if (lbLMFMedias.SelCount < 1) then
    raise Exception.Create('No Media selected');

  for i := 0 to lbLMFMedias.Count-1 do
  begin
    if (lbLMFMedias.Selected[i]) then
      ACBrAbecsPinPad1.DSI(lbLMFMedias.Items[i])
  end;
end;

procedure TfrMain.btDetectPinPadClick(Sender: TObject);
var
  sl: TStringList;
  PortFound: String;
  i: Integer;
begin
  sl := TStringList.Create;
  try
    ACBrAbecsPinPad1.Device.AcharPortasSeriais( sl );
    i := 0;
    PortFound := '';
    while (i < sl.Count) and (PortFound = '') do
    begin
      try
        ACBrAbecsPinPad1.Disable;
        ACBrAbecsPinPad1.Port := sl[i];
        ACBrAbecsPinPad1.Enable;
        try
          ACBrAbecsPinPad1.OPN;
          ACBrAbecsPinPad1.CLO;
          PortFound := ACBrAbecsPinPad1.Port;
        finally
          ACBrAbecsPinPad1.Disable;
        end;
      except
      end;
      Inc(i);
    end;

    if (PortFound <> '') then
    begin
      ShowMessage('PinPad Found on '+PortFound);
      cbxPort.Items.Assign(sl);
      cbxPort.Text := PortFound;
    end
    else
      ShowMessage('PinPad not Found');
  finally
    sl.Free;
  end;
end;

procedure TfrMain.btDEXClearClick(Sender: TObject);
begin
  ACBrAbecsPinPad1.DEX();
end;

procedure TfrMain.btDSPClearClick(Sender: TObject);
begin
  ACBrAbecsPinPad1.DSP();
end;

procedure TfrMain.btDSPClick(Sender: TObject);
begin
  ACBrAbecsPinPad1.DSP(edtDSPMsg1.Text, edtDSPMsg2.Text);
end;

procedure TfrMain.btGCDClick(Sender: TObject);
var
  s: String;
begin
  pGCDResponse.Caption := cbxGCD.Items[cbxGCD.ItemIndex];
  try
    s := ACBrAbecsPinPad1.GCD(TACBrAbecsMSGIDX(cbxGCD.ItemIndex), seGCDTimeOut.Value);
    pGCDResponse.Caption := s;
  except
    On E: EACBrAbecsPinPadTimeout do
      pGCDResponse.Caption := 'USER TIMEOUT';
    else
      raise;
  end;
end;

procedure TfrMain.btGINClick(Sender: TObject);
begin
  ACBrAbecsPinPad1.GIN(seGIN_ACQIDX.Value);
  mGINResponse.Lines.Text := ACBrAbecsPinPad1.Response.GetResponseData;
end;

procedure TfrMain.btGIXClick(Sender: TObject);
var
  i: Integer;
  p: Word;
  PP_DATA: Array of Word;
  sl: TStringList;
  s, n: String;

  procedure AddParam(AParam: Word);
  var
    l: Integer;
  begin
    l := Length(PP_DATA);
    SetLength(PP_DATA, l+1);
    PP_DATA[l] := AParam;
  end;

begin
  if (lbGIXParams.Count < 1) then
    ACBrAbecsPinPad1.GIX
  else
  begin
    for i := 0 to lbGIXParams.Count-1 do
    begin
      if (lbGIXParams.Selected[i]) then
       AddParam(PP_StrToInt(lbGIXParams.Items[i]));
    end;

    if (edGIXValue.Text <> '') then
    begin
      p := StrToIntDef(edGIXValue.Text, 0);
      if (p > 0) then
        AddParam(p);
    end;

    ACBrAbecsPinPad1.GIX(PP_DATA);
  end;

  mGIXResponse.Lines.Clear;
  sl := TStringList.Create;
  try
    ACBrAbecsPinPad1.Response.GetResponseAsValues(sl);
    for i := 0 to sl.Count-1 do
    begin
      n := sl.Names[i];
      p := StrToIntDef(n, -1);
      if (p > 0) then
        s := PP_ToStr(p)
      else
        s := n;

      mGIXResponse.Lines.Add(s+' => '+sl.Values[n]);
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrMain.btGKYClick(Sender: TObject);
var
  i: Integer;
  s: String;
begin
  i := 0;
  s := 'PRESS FUNCTION KEY';
  pGKYResponse.Caption := s;
  ACBrAbecsPinPad1.DSP(s);

  try
    i := ACBrAbecsPinPad1.GKY;
  except
    On E: EACBrAbecsPinPadTimeout do
      pGKYResponse.Caption := 'USER TIMEOUT';
    else
      raise;
  end;

  s := Format('Key Number: %d',[i]);
  ACBrAbecsPinPad1.DSP(s);
  pGKYResponse.Caption := s;
end;

procedure TfrMain.btMediaLoadClick(Sender: TObject);
var
  ms: TMemoryStream;
  tini, tfim: TDateTime;
begin
  ms := TMemoryStream.Create;
  try
    imgMedia.Picture.Graphic.SaveToStream(ms);
    try
      tini := Now;
      mLog.Lines.Add('Start Loading '+edMediaLoad.Text);
      mLog.Lines.BeginUpdate;
      ACBrAbecsPinPad1.LoadMedia( edMediaLoad.Text,
                                  ms,
                                  TACBrAbecsPinPadMediaType(imgMedia.Tag) );
    finally
      mLog.Lines.EndUpdate;
    end;

    tfim := Now;
    LoadMediaNames;
    ACBrAbecsPinPad1.DSI(edMediaLoad.Text);
    mLog.ScrollBy(0, mLog.Lines.Count);
    mLog.Lines.Add('Done Loading '+edMediaLoad.Text+', '+FormatFloat('##0.000',SecondSpan(tini,tfim))+' seconds' );
  finally
    ms.Free;
  end;
end;

procedure TfrMain.btLMFClick(Sender: TObject);
begin
  LoadMediaNames;
end;

procedure TfrMain.btMNUClick(Sender: TObject);
var
  s: String;
begin
  s := '';
  pMNUResponse.Caption := 'SELECT ON PINPAD';
  try
    s := ACBrAbecsPinPad1.MNU(mMNU.Lines,edMNUTitle.Text, seMNUTimeOut.Value);
  except
    On E: EACBrAbecsPinPadTimeout do
      pMNUResponse.Caption := 'USER TIMEOUT';
    else
      raise;
  end;

  pMNUResponse.Caption := s;
end;

procedure TfrMain.btOPNClick(Sender: TObject);
begin
  if not cbSecure.Checked then
    ACBrAbecsPinPad1.OPN
  else
    ACBrAbecsPinPad1.OPN( Trim(mModulus.Text), Trim(mExponent.Text) );
end;

procedure TfrMain.btRMCClick(Sender: TObject);
begin
  ACBrAbecsPinPad1.RMC(edtRMCMsg1.Text, edtRMCMsg2.Text);
end;

procedure TfrMain.btSaveParamsClick(Sender: TObject);
begin
  SaveParams;
end;

procedure TfrMain.btSendQRCodeClick(Sender: TObject);
var
  ms: TMemoryStream;
  tini, tfim: TDateTime;
  png: TPngImage;
  qrsize: Integer;
begin
  ms := TMemoryStream.Create;
  png := TPngImage.Create;
  try
    qrsize := min( ACBrAbecsPinPad1.PinPadCapabilities.DisplayGraphicPixels.Cols,
                   ACBrAbecsPinPad1.PinPadCapabilities.DisplayGraphicPixels.Rows) - 20;
    png.Assign(imgQRCode.Picture.Bitmap);
    png.Resize(qrsize, qrsize);
    png.Canvas.StretchDraw(png.Canvas.ClipRect, imgQRCode.Picture.Bitmap);
    //png.SaveToFile('c:\temp\qrcode.png');
    png.SaveToStream(ms);
    imgQRCode.Picture.Assign(png);
    try
      tini := Now;
      mLog.Lines.Add('Start Loading '+edQRCodeImgName.Text);
      mLog.Lines.BeginUpdate;
      ACBrAbecsPinPad1.LoadMedia( edQRCodeImgName.Text, ms, mtPNG);
    finally
      mLog.Lines.EndUpdate;
    end;

    tfim := Now;
    LoadMediaNames;
    ACBrAbecsPinPad1.DSI(edQRCodeImgName.Text);
    mLog.ScrollBy(0, mLog.Lines.Count);
    mLog.Lines.Add('Done Loading '+edQRCodeImgName.Text+', '+FormatFloat('##0.000',SecondSpan(tini,tfim))+' seconds' );
  finally
    ms.Free;
     png.Free;
  end;
end;

procedure TfrMain.btReadParmsClick(Sender: TObject);
begin
  ReadParams;
end;

procedure TfrMain.btSearchSerialPorts1Click(Sender: TObject);
var
  filename, ext: String;
begin
  if OpenPictureDialog1.Execute then
  begin
    ext := LowerCase(ExtractFileExt(OpenPictureDialog1.FileName));
    filename := StringReplace(ExtractFileName(OpenPictureDialog1.FileName), ext, '', []);
    edMediaLoad.Text := ACBrAbecsPinPad1.FormatSPE_MFNAME( filename );
    imgMedia.Picture := nil;
    imgMedia.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    ShowMediaDimensions;
    if (ext = '.gif') then
      imgMedia.Tag := Integer(mtGIF)
    else if (ext = '.png') then
      imgMedia.Tag := Integer(mtPNG)
    else
      imgMedia.Tag := Integer(mtJPG);
  end;
end;

procedure TfrMain.btCancelClick(Sender: TObject);
begin
  ConfigPanelCancel(False);
end;

procedure TfrMain.btPaintQRCodeClick(Sender: TObject);
begin
  PintarQRCode(mQRCode.Lines.Text, imgQRCode.Picture.Bitmap, qrUTF8BOM);
end;

procedure TfrMain.cbGIXAllClick(Sender: TObject);
begin
  if (cbGIXAll.Checked) then
  begin
    lbGIXParams.ClearSelection;
    lbGIXParams.Enabled := False;
    edGIXValue.Enabled := False;
  end
  else
  begin
    lbGIXParams.Enabled := True;
    edGIXValue.Enabled := True;
  end;
end;

procedure TfrMain.cbSecureChange(Sender: TObject);
begin
  pKeys.Enabled := cbSecure.Checked;
end;

procedure TfrMain.cbMNUHotKeyClick(Sender: TObject);
var
  i: Integer;
  s: String;
begin
  if cbMNUHotKey.Checked then
  begin
    for i := 0 to min(mMNU.Lines.Count-1, 8) do
    begin
      s := mMNU.Lines[i];
      if (StrToIntDef(copy(s, 1, 1), 0) < 1) then
      begin
        s := IntToStr(i+1) + ' ' + s;
        mMNU.Lines[i] := s;
      end;
    end;
  end
  else
  begin
    for i := 0 to min(mMNU.Lines.Count-1, 8) do
    begin
      s := mMNU.Lines[i];
      if (StrToIntDef(copy(s, 1, 1), 0) > 0) then
      begin
        s := Trim(copy(s, 2, Length(s)));
        mMNU.Lines[i] := s;
      end;
    end;
  end;
end;

procedure TfrMain.btCLOClick(Sender: TObject);
begin
  ACBrAbecsPinPad1.CLO(edtCLOMsg1.Text, edtCLOMsg2.Text);
end;

procedure TfrMain.btCLXClick(Sender: TObject);
begin
  if (pgCLX.ActivePageIndex = 0) then
    ACBrAbecsPinPad1.CLX(mCLX.Lines.Text)
  else
  begin
    if (lbCLXMedias.ItemIndex >= 0) then
      ACBrAbecsPinPad1.CLX(lbCLXMedias.Items[lbCLXMedias.ItemIndex]);
  end;
end;

end.

