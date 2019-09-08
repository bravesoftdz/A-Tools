unit uProps;

interface

uses
  Windows, Messages, ComCtrls, StdCtrls, Graphics,
  Buttons, ExtCtrls, Controls, Classes, Forms,
  uForm, uData, ImgList, Dialogs, ICSTrackBar,
  ICSSpinEdit, uAPPForm, ICSLanguages, OleCtrls, SHDocVw,
  System.ImageList, uTrackBarEx, ICSFrame;

type
  TfrmProps = class(TfrmAPPForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    TimerFlashSSRunPanel: TTimer;
    SaveDialog1: TSaveDialog;
    ICSListViewMenu: TListView;
    ImageListTitle: TImageList;
    Panel1: TPanel;
    ShapeMain: TShape;
    Image6: TImage;
    Image18: TImage;
    Image22: TImage;
    CBWinStartup: TCheckBox;
    CBNewVersion: TCheckBox;
    Shape2: TShape;
    Panel2: TPanel;
    ShapeNote: TShape;
    LabelHKNotes: TLabel;
    ImageNHotKey: TImage;
    Image8: TImage;
    LabelNoteLayered: TLabel;
    Image9: TImage;
    Image17: TImage;
    HotKeyNotes: THotKey;
    CBNAutoShow: TCheckBox;
    ChTrackBarNLayered: TICSTrackBar;
    CBNWordWrap: TCheckBox;
    CBNStayOnTop: TCheckBox;
    CBNProtect: TCheckBox;
    Panel3: TPanel;
    ImagePause: TImage;
    LabelMouseDelay: TLabel;
    Image10: TImage;
    LabelSSRunSquare: TLabel;
    ImageMonitor: TImage;
    LabelHKSS: TLabel;
    TBSSDelay: TICSTrackBar;
    CBSSPauseKey: TCheckBox;
    CBSSMouse: TCheckBox;
    TBSSRunSize: TICSTrackBar;
    PanelSSCorners: TPanel;
    RBSSRCTopLeft: TRadioButton;
    RBSSRCTopRight: TRadioButton;
    RBSSRCBottomLeft: TRadioButton;
    RBSSRCBottomRight: TRadioButton;
    PanelSSPrewiew: TPanel;
    HotKeySS: THotKey;
    btnNColor: TBitBtn;
    PanelSSRun: TStaticText;
    LabelVersion: TLabel;
    LabelNoteText: TLabel;
    CBNAutoheight: TCheckBox;
    btnNFont: TBitBtn;
    btnNSaveAll: TBitBtn;
    ShapeTop: TShape;
    Image42: TImage;
    Image2: TImage;
    LabelHome: TLabel;
    Label1: TLabel;
    PanelImprint: TPanel;
    BitBtnNewVer: TBitBtn;
    ImageSSHK: TImage;
    Image3: TImage;
    Image4: TImage;
    btnNDeleteAll: TBitBtn;
    Shape1: TShape;
    Shape3: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape15: TShape;
    ImageESHotKey: TImage;
    LabelHKES: TLabel;
    Image16: TImage;
    LabelESType: TLabel;
    Shape4: TShape;
    CBESConfirm: TCheckBox;
    CBESType: TComboBox;
    HotKeyES: THotKey;
    Panel4: TPanel;
    Image19: TImage;
    Image25: TImage;
    LabelHKClipboard: TLabel;
    LabelHKRecycleBin: TLabel;
    Image11: TImage;
    LabelScreenInfo: TLabel;
    HotKeyClipboard: THotKey;
    HotKeyRecycleBin: THotKey;
    HotKeyScreenInfo: THotKey;
    cbSmartMouse: TCheckBox;
    Image1: TImage;
    cbSMUseSystemKeys: TCheckBox;
    cbSMUseFunctionalKeys: TCheckBox;
    cbSMUseNavigationKeys: TCheckBox;
    cbSMHideNormalCursor: TCheckBox;
    cbSMHideBeamCursor: TCheckBox;
    cbSMHideWaitCursor: TCheckBox;
    cbSMHideHandCursor: TCheckBox;
    cbSMHideAppStartingCursor: TCheckBox;
    cbSMAutoHide: TCheckBox;
    ICSTrackBarSM: TICSTrackBar;
    cbSMHideCrossCursor: TCheckBox;
    ICSFrame1: TICSFrame;
    Image5: TImage;
    LabelLang: TLabel;
    CBLang: TComboBox;
    Image7: TImage;
    CBMOEnabled: TCheckBox;
    procedure CBWinStartupClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ChLabelHomepageMouseEnter(Sender: TObject);
    procedure ChLabelHomepageMouseLeave(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnApplyClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure CBSSMouseClick(Sender: TObject);
    procedure RBSSRCTopLeftClick(Sender: TObject);
    procedure TimerFlashSSRunPanelTimer(Sender: TObject);
    procedure XPanelSSRunMouseEnter(Sender: TObject);
    procedure XPanelSSRunMouseLeave(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ICSListViewMenuChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnNFontClick(Sender: TObject);
    procedure btnNColorClick(Sender: TObject);
    procedure btnNSaveAllClick(Sender: TObject);
    procedure LabelHomeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtnNewVerClick(Sender: TObject);
    procedure CBLangChange(Sender: TObject);
    procedure ICSListViewMenuChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure btnNDeleteAllClick(Sender: TObject);
    procedure Label1MouseEnter(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
    procedure Label1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure OnSettingChange(var Msg: TMessage); message WM_SETTINGCHANGE;
    procedure OnAppSetLanguageMsg(var Msg: TMessage); message ICS_SETLANGUAGE_MSG;
    procedure SetImprintMode(const Value: Boolean);
  private
    SSInstalled: Boolean;
    FImprintMode: Boolean;
    procedure SetImages;
    procedure SetControlsFromProps;
    procedure SetPropsFromControls;
    procedure SetControlEnable;
    procedure SetControlFont(F: TFont);
    function GetControlColor(C: TColor): TColor;
    procedure RunSSPrewiew;
    procedure TerminateSSPrewirew;
    procedure FillCBLang;
    procedure OnPageChange(Idx: Integer);
    procedure FillComboBoxes;
    procedure SetListViewCaptions;
  public
    property ImprintMode: Boolean read FImprintMode write SetImprintMode;
  end;

var
  frmProps: TfrmProps = nil;

implementation

uses
  UITypes, ShellAPI, uRegLite, uRegistry, CommCtrl, Math, MMSystem, RegStr, uWindows,
  WinINet, SysUtils, uCProcs, uFormProcs, uCommonTools, uProcs, uMain, uRegExport, uDownload,
  uNotes;

{$R *.DFM}

{ TfrmProps }

const
  PANEL_COUNT = 4;

procedure TfrmProps.FormCreate(Sender: TObject);
 var I: Integer;
begin
  inherited;
  for I := 0 to PANEL_COUNT - 1 do with ICSListViewMenu.Items.Add do ImageIndex := I;

  SetImages;
  FillCBLang;
  
  FImprintMode := False;
end;

procedure TfrmProps.FormDestroy(Sender: TObject);
begin
  frmProps := nil;
  inherited;
end;

procedure TfrmProps.CBWinStartupClick(Sender: TObject);
begin
  inherited;
  btnApply.Enabled := True;
end;

procedure TfrmProps.FormShow(Sender: TObject);
begin
  inherited;

  SetControlsFromProps;
  Perform(WM_SETTINGCHANGE, 0, 0);

  SetListViewCaptions;
  if FImprintMode then PanelImprint.Visible := True else if PMemFile^.Props.LastPropPage < ICSListViewMenu.Items.Count then begin
    ICSListViewMenu.Selected := ICSListViewMenu.Items[PMemFile^.Props.LastPropPage];
    ICSListViewMenu.Selected.Focused := True;
  end;

  btnApply.Enabled := False;
end;

procedure TfrmProps.Label1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  SetImprintMode(True);
end;

procedure TfrmProps.Label1MouseEnter(Sender: TObject);
begin
  inherited;
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style + [fsUnderline];
end;

procedure TfrmProps.Label1MouseLeave(Sender: TObject);
begin
  inherited;
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style - [fsUnderline];
end;

procedure TfrmProps.btnCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmProps.ChLabelHomepageMouseEnter(Sender: TObject);
begin
  inherited;
  (Sender as TLabel).Font.Color := clMaroon;
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style + [fsUnderline];
end;

procedure TfrmProps.ChLabelHomepageMouseLeave(Sender: TObject);
begin
  inherited;
  (Sender as TLabel).Font.Color := clNavy;
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style - [fsUnderline];
end;

procedure TfrmProps.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if ActiveControl is THotKey then CBWinStartupClick(nil);
end;

procedure TfrmProps.SetImages;
begin
  ImageESHotKey.Picture.Icon.Assign(ImageNHotKey.Picture.Icon);
//  ImageTMHotKey.Picture.Icon.Assign(ImageNHotKey.Picture.Icon);
end;

procedure TfrmProps.SetControlsFromProps;
// var DW: DWORD;
begin
  CBWinStartup.Checked := GetWindowsStartup;
  CBNewVersion.Checked := PMemFile^.Props.CheckNewVersion;

  CBNAutoShow.Checked := PMemFile^.Props.Note.DefaultParams.AutoShow;
  CBNStayOnTop.Checked := PMemFile^.Props.Note.DefaultParams.StayOnTop;
  CBNWordWrap.Checked := PMemFile^.Props.Note.DefaultParams.WordWrap;
  CBNProtect.Checked := PMemFile^.Props.Note.DefaultParams.Protect;
  CBNAutoheight.Checked := PMemFile^.Props.Note.DefaultParams.Autoheight;
  HotKeyNotes.HotKey := HotKeyToShortCut(PMemFile^.Props.Note.HotKey);
  ChTrackBarNLayered.Position := PMemFile^.Props.Note.DefaultParams.Transparency;
  ShapeNote.Brush.Color := PMemFile^.Props.Note.DefaultParams.Color;
  ShapeNote.Pen.Color := GetDarkColor(ShapeNote.Brush.Color, 30);
  SetVCLFontFromProgFont(LabelNoteText.Font, PMemFile^.Props.Note.DefaultParams.Font);

  CBSSMouse.Checked := PMemFile^.Props.ScreenSaver.UseMouse;
  case PMemFile^.Props.ScreenSaver.RunCorner of
    ssRCTopLeft: RBSSRCTopLeft.Checked := True;
    ssRCTopRight: RBSSRCTopRight.Checked := True;
    ssRCBottomLeft: RBSSRCBottomLeft.Checked := True;
    ssRCBottomRight: RBSSRCBottomRight.Checked := True;
  end;
  TBSSDelay.Position := PMemFile^.Props.ScreenSaver.Delay;
  TBSSRunSize.Position := PMemFile^.Props.ScreenSaver.RunSize;
  CBSSPauseKey.Checked := PMemFile^.Props.ScreenSaver.UsePauseKey;
  HotKeySS.HotKey := HotKeyToShortCut(PMemFile^.Props.ScreenSaver.HotKey);

  CBESType.ItemIndex := Ord(PMemFile^.Props.EndSession.Action) - 1;
  CBESConfirm.Checked := PMemFile^.Props.EndSession.Confirm;
  HotKeyES.HotKey := HotKeyToShortCut(PMemFile^.Props.EndSession.HotKey);

  HotKeyClipboard.HotKey := HotKeyToShortCut(PMemFile^.Props.Empty.ClipboardHotKey);
  HotKeyRecycleBin.HotKey := HotKeyToShortCut(PMemFile^.Props.Empty.RecycleBinHotKey);
  HotKeyScreenInfo.HotKey := HotKeyToShortCut(PMemFile^.Props.ScreenInfo.HotKey);

  cbSmartMouse.Checked := PMemFile^.Props.SmartMouse.Active;
  cbSMUseSystemKeys.Checked := PMemFile^.Props.SmartMouse.SystemKeys;
  cbSMUseFunctionalKeys.Checked := PMemFile^.Props.SmartMouse.FunctionalKeys;
  cbSMUseNavigationKeys.Checked := PMemFile^.Props.SmartMouse.NavigationKeys;
  cbSMHideNormalCursor.Checked := PMemFile^.Props.SmartMouse.CursorNormal;
  cbSMHideBeamCursor.Checked := PMemFile^.Props.SmartMouse.CursorIBeam;
  cbSMHideWaitCursor.Checked := PMemFile^.Props.SmartMouse.CursorWait;
  cbSMHideCrossCursor.Checked := PMemFile^.Props.SmartMouse.CursorCross;
  cbSMHideHandCursor.Checked := PMemFile^.Props.SmartMouse.CursorHand;
  cbSMHideAppStartingCursor.Checked := PMemFile^.Props.SmartMouse.CursorAppStarting;
  cbSMAutoHide.Checked := (PMemFile^.Props.SmartMouse.AutoHideInterval > 0);
  ICSTrackBarSM.Position := PMemFile^.Props.SmartMouse.AutoHideInterval div 1000;

  CBMOEnabled.Checked := PMemFile^.Props.MemoryOptimizer.Enabled;
end;

procedure TfrmProps.SetPropsFromControls;
begin
  SetWindowsStartup(CBWinStartup.Checked);
  PMemFile^.Props.CheckNewVersion := CBNewVersion.Checked;

  PMemFile^.Props.ScreenSaver.UsePauseKey := CBSSPauseKey.Checked;
  PMemFile^.Props.ScreenSaver.UseMouse := CBSSMouse.Checked;
  PMemFile^.Props.ScreenSaver.Delay := TBSSDelay.Position;
  if RBSSRCTopLeft.Checked then PMemFile^.Props.ScreenSaver.RunCorner := ssRCTopLeft
  else if RBSSRCTopRight.Checked then PMemFile^.Props.ScreenSaver.RunCorner := ssRCTopRight
  else if RBSSRCBottomLeft.Checked then PMemFile^.Props.ScreenSaver.RunCorner := ssRCBottomLeft
  else if RBSSRCBottomRight.Checked then PMemFile^.Props.ScreenSaver.RunCorner := ssRCBottomRight;
  PMemFile^.Props.ScreenSaver.RunSize := TBSSRunSize.Position;
  PMemFile^.Props.ScreenSaver.HotKey := ShortCutToHotKey(HotKeySS.HotKey);

  PMemFile^.Props.EndSession.Action := TEndSessionAction(CBESType.ItemIndex + 1);
  PMemFile^.Props.EndSession.Confirm := CBESConfirm.Checked;
  PMemFile^.Props.EndSession.HotKey := ShortCutToHotKey(HotKeyES.HotKey);

  PMemFile^.Props.Note.DefaultParams.Font := VCLFontToProgFont(LabelNoteText.Font);
  PMemFile^.Props.Note.DefaultParams.Color := ShapeNote.Brush.Color;
  PMemFile^.Props.Note.DefaultParams.AutoShow := CBNAutoShow.Checked;
  PMemFile^.Props.Note.DefaultParams.StayOnTop := CBNStayOnTop.Checked;
  PMemFile^.Props.Note.DefaultParams.WordWrap := CBNWordWrap.Checked;
  PMemFile^.Props.Note.DefaultParams.Transparency := ChTrackBarNLayered.Position;
  PMemFile^.Props.Note.DefaultParams.Protect := CBNProtect.Checked;
  PMemFile^.Props.Note.DefaultParams.Autoheight := CBNAutoheight.Checked;
  PMemFile^.Props.Note.HotKey := ShortCutToHotKey(HotKeyNotes.HotKey);

  PMemFile^.Props.Empty.RecycleBinHotKey := ShortCutToHotKey(HotKeyRecycleBin.HotKey);
  PMemFile^.Props.Empty.ClipboardHotKey := ShortCutToHotKey(HotKeyClipboard.HotKey);
  PMemFile^.Props.ScreenInfo.HotKey := ShortCutToHotKey(HotKeyScreenInfo.HotKey);

  PMemFile^.Props.SmartMouse.Active := cbSmartMouse.Checked;
  PMemFile^.Props.SmartMouse.SystemKeys := cbSMUseSystemKeys.Checked;
  PMemFile^.Props.SmartMouse.FunctionalKeys := cbSMUseFunctionalKeys.Checked;
  PMemFile^.Props.SmartMouse.NavigationKeys := cbSMUseNavigationKeys.Checked;
  PMemFile^.Props.SmartMouse.CursorNormal := cbSMHideNormalCursor.Checked;
  PMemFile^.Props.SmartMouse.CursorIBeam := cbSMHideBeamCursor.Checked;
  PMemFile^.Props.SmartMouse.CursorWait := cbSMHideWaitCursor.Checked;
  PMemFile^.Props.SmartMouse.CursorCross := cbSMHideCrossCursor.Checked;
  PMemFile^.Props.SmartMouse.CursorHand := cbSMHideHandCursor.Checked;
  PMemFile^.Props.SmartMouse.CursorAppStarting := cbSMHideAppStartingCursor.Checked;
  if cbSMAutoHide.Checked then PMemFile^.Props.SmartMouse.AutoHideInterval := ICSTrackBarSM.Position * 1000 else PMemFile^.Props.SmartMouse.AutoHideInterval := 0;

  PMemFile^.Props.MemoryOptimizer.Enabled := CBMOEnabled.Checked;
end;

procedure TfrmProps.SetControlEnable;
 var I: Integer;
begin
  CBSSMouse.Enabled := SSInstalled;
  for I := 0 to PanelSSCorners.ControlCount - 1 do PanelSSCorners.Controls[I].Enabled := CBSSMouse.Checked and SSInstalled;
  LabelMouseDelay.Enabled := CBSSMouse.Checked and SSInstalled;
  TBSSDelay.Enabled := CBSSMouse.Checked and SSInstalled;
  LabelSSRunSquare.Enabled := CBSSMouse.Checked and SSInstalled;
  TBSSRunSize.Enabled := CBSSMouse.Checked and SSInstalled;
  PanelSSRun.Visible := CBSSMouse.Checked and SSInstalled;
  TimerFlashSSRunPanel.Enabled := CBSSMouse.Checked;
  CBSSPauseKey.Enabled := SSInstalled;
  LabelHKSS.Enabled := not CBSSPauseKey.Checked and SSInstalled;
  HotKeySS.Enabled := not CBSSPauseKey.Checked and SSInstalled;

  LabelESType.Enabled := not CBESConfirm.Checked;
  CBESType.Enabled := not CBESConfirm.Checked;

  cbSMUseSystemKeys.Enabled := cbSmartMouse.Checked;
  cbSMUseFunctionalKeys.Enabled := cbSmartMouse.Checked;
  cbSMUseNavigationKeys.Enabled := cbSmartMouse.Checked;
  cbSMHideNormalCursor.Enabled := cbSmartMouse.Checked;
  cbSMHideBeamCursor.Enabled := cbSmartMouse.Checked;
  cbSMHideWaitCursor.Enabled := cbSmartMouse.Checked;
  cbSMHideCrossCursor.Enabled := cbSmartMouse.Checked;
  cbSMHideHandCursor.Enabled := cbSmartMouse.Checked;
  cbSMHideAppStartingCursor.Enabled := cbSmartMouse.Checked;
  cbSMAutoHide.Enabled := cbSmartMouse.Checked;
  ICSTrackBarSM.Enabled := cbSmartMouse.Checked and cbSMAutoHide.Checked;
end;

procedure TfrmProps.btnApplyClick(Sender: TObject);
 var I: Integer;
begin
  inherited;
  SetPropsFromControls;

  ICSCurrentLanguageString := ICSLanguages1.CurrentLanguageString;
  RegSetString(HKEY_LOCAL_MACHINE, REG_APP_KEY, 'Lang', ICSCurrentLanguageString);
  for I := 0 to Screen.FormCount - 1 do begin
    SendMessage(Screen.Forms[I].Handle, ICS_SETLANGUAGE_MSG, ICSLanguages1.CurrentLanguageID, 0);
    SendMessage(Screen.Forms[I].Handle, PM_PROPSCHANGE, 0, 0);
  end;

  SaveProps(PMemFile^.Props);

  btnApply.Enabled := False;
end;

procedure TfrmProps.btnOkClick(Sender: TObject);
begin
  inherited;
  if btnApply.Enabled then btnApplyClick(nil);
  btnCancelClick(nil);
end;

procedure TfrmProps.SetControlFont(F: TFont);
begin
  FontDialog1.Font.Assign(F);
  if FontDialog1.Execute then begin
    F.Assign(FontDialog1.Font);
    btnApply.Enabled := True;
  end;
end;

function TfrmProps.GetControlColor(C: TColor): TColor;
begin
  ColorDialog1.Color := C;
  if ColorDialog1.Execute then btnApply.Enabled := True;
  Result := ColorDialog1.Color;
end;

procedure TfrmProps.CBSSMouseClick(Sender: TObject);
begin
  inherited;
  SetControlEnable;
  CBWinStartupClick(nil);
end;

procedure TfrmProps.RBSSRCTopLeftClick(Sender: TObject);
 var
   I, L, T: Integer;
   S: String;
begin
  inherited;
  L := 0;
  T := 0;
  for I := 0 to PanelSSCorners.ControlCount - 1 do if (PanelSSCorners.Controls[I] as TRadioButton).Checked then begin
    S := (PanelSSCorners.Controls[I] as TRadioButton).Name;
    if S = 'RBSSRCTopLeft' then begin L := PanelSSPrewiew.Left; T := PanelSSPrewiew.Top; end
    else if S = 'RBSSRCTopRight' then begin L := PanelSSPrewiew.Left + PanelSSPrewiew.Width - TBSSRunSize.Position; T := PanelSSPrewiew.Top; end
    else if S = 'RBSSRCBottomLeft' then begin L := PanelSSPrewiew.Left; T := PanelSSPrewiew.Top + PanelSSPrewiew.Height - TBSSRunSize.Position; end
    else if S = 'RBSSRCBottomRight' then begin L := PanelSSPrewiew.Left + PanelSSPrewiew.Width - TBSSRunSize.Position; T := PanelSSPrewiew.Top + PanelSSPrewiew.Height - TBSSRunSize.Position; end;
    Break;
  end;
  PanelSSRun.SetBounds(L, T, TBSSRunSize.Position, TBSSRunSize.Position);
  CBWinStartupClick(nil);
end;

procedure TfrmProps.RunSSPrewiew;
begin
  if icsStartProcess(icsGetCurrentSSFileName, '/P ' + IntToStr(PanelSSPrewiew.Handle), '', SW_SHOW, True) > 32 then PanelSSPrewiew.Visible := True;
end;

procedure TfrmProps.TerminateSSPrewirew;
begin
  SendMessage(GetWindow(PanelSSPrewiew.Handle, GW_CHILD), WM_SYSCOMMAND, SC_CLOSE, 0);
  PanelSSPrewiew.Visible := False;
end;

procedure TfrmProps.TimerFlashSSRunPanelTimer(Sender: TObject);
begin
  inherited;
  if Boolean(TimerFlashSSRunPanel.Tag) then PanelSSRun.Color := clBlack else PanelSSRun.Color := clWhite;
  TimerFlashSSRunPanel.Tag := Integer(not Boolean(TimerFlashSSRunPanel.Tag));
end;

procedure TfrmProps.XPanelSSRunMouseEnter(Sender: TObject);
 var
   P: TPoint;
   Counter: DWord;
   R: TRect;
begin
  inherited;
  R.TopLeft := PanelSSPrewiew.ClientToScreen(PanelSSPrewiew.ClientRect.TopLeft);
  R.BottomRight := PanelSSPrewiew.ClientToScreen(PanelSSPrewiew.ClientRect.BottomRight);
  ClipCursor(@R);
  Counter := GetTickCount;
  repeat
    Sleep(1);
    Application.ProcessMessages;
    GetCursorPos(P);
  until (GetTickCount - Counter > DWord(TBSSDelay.Position)) or (WindowFromPoint(P) <> PanelSSRun.Handle);
  if WindowFromPoint(P) = PanelSSRun.Handle then RunSSPrewiew;
end;

procedure TfrmProps.XPanelSSRunMouseLeave(Sender: TObject);
begin
  inherited;
  TerminateSSPrewirew;
  ClipCursor(nil);
end;

procedure TfrmProps.OnSettingChange(var Msg: TMessage);
begin
  inherited;
  SSInstalled := FileExists(icsGetCurrentSSFileName);
  SetControlEnable;
end;

procedure TfrmProps.FillCBLang;
 var I: Integer;
begin
  CBLang.Items.Clear;
  for I := 0 to ICSLanguages1.Languages.Count - 1 do begin
    CBLang.Items.Add(ICSLanguages1.Languages[I].LocaleName);
    if I = ICSLanguages1.CurrentLanguageID then CBLang.ItemIndex := I;
  end;
end;

procedure TfrmProps.OnAppSetLanguageMsg(var Msg: TMessage);
 const
   MIN_SPACE            = 8;
   PANEL_BLAT_WIDTH     = 401;
 var
   L: Integer;
begin
  inherited;

  LabelVersion.Caption := LabelVersion.Caption + ' ' + icsGetFileVersion(ParamStr(0));

  L := LabelLang.Left + LabelLang.Width + MIN_SPACE;
  with CBLang do SetBounds(L, Top, Panel1.Width - L - MIN_SPACE, Height);

  FillComboBoxes;
  SetListViewCaptions;

  L := LabelHKNotes.Left + LabelHKNotes.Width + MIN_SPACE;
  with HotKeyNotes do SetBounds(L, Top, Panel2.Width - L - MIN_SPACE, Height);

  L := LabelHKSS.Left + LabelHKSS.Width + MIN_SPACE;
  with HotKeySS do SetBounds(L, Top, Panel3.Width - L - MIN_SPACE, Height);

  L := LabelESType.Left + LabelESType.Width + MIN_SPACE;
  with CBESType do SetBounds(L, Top, (Parent as TPanel).Width - L - MIN_SPACE, Height);
  L := LabelHKES.Left + LabelHKES.Width + MIN_SPACE;
  with HotKeyES do SetBounds(L, Top, (Parent as TPanel).Width - L - MIN_SPACE, Height);

  L := LabelScreenInfo.Left + MaxX([LabelScreenInfo.Width, LabelHKClipboard.Width, LabelHKRecycleBin.Width]) + MIN_SPACE;
  with HotKeyScreenInfo do SetBounds(L, Top, (Parent as TPanel).Width - L - MIN_SPACE, Height);
  with HotKeyClipboard do SetBounds(L, Top, (Parent as TPanel).Width - L - MIN_SPACE, Height);
  with HotKeyRecycleBin do SetBounds(L, Top, (Parent as TPanel).Width - L - MIN_SPACE, Height);
end;

procedure TfrmProps.ICSListViewMenuChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  inherited;
  if Change = ctState then begin
    OnPageChange(Item.Index);
    PMemFile^.Props.LastPropPage := Item.Index;
  end;
end;

procedure TfrmProps.OnPageChange(Idx: Integer);
 var I: Integer;
begin
  for I := 0 to ControlCount - 1 do if (Controls[I] is TPanel) and ((Controls[I] as TComponent).Tag >= 0) then (Controls[I] as TPanel).Visible := ((Controls[I] as TComponent).Tag = Idx);
  TimerFlashSSRunPanel.Enabled := (Idx = 2);
end;

procedure TfrmProps.btnNFontClick(Sender: TObject);
begin
  inherited;
  SetControlFont(LabelNoteText.Font);
end;

procedure TfrmProps.btnNColorClick(Sender: TObject);
begin
  inherited;
  ShapeNote.Brush.Color := GetControlColor(ShapeNote.Brush.Color);
  ShapeNote.Pen.Color := GetDarkColor(ShapeNote.Brush.Color, 30);
end;

procedure TfrmProps.btnNSaveAllClick(Sender: TObject);
begin
  inherited;
  SaveDialog1.DefaultExt := 'reg';
  SaveDialog1.Filter := ICSLanguages1.CurrentStrings[37];
  SaveDialog1.FileName := PROG_NAME;
  if SaveDialog1.Execute then ExportRegistryBranch(HKEY_CURRENT_USER, REG_NOTES_KEY, SaveDialog1.FileName);
end;

procedure TfrmProps.LabelHomeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  ShellExecute(Handle, nil, PChar((Sender as TLabel).Caption), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmProps.BitBtnNewVerClick(Sender: TObject);
begin
  inherited;
  Screen.Cursor := crHourGlass;
  Screen.Cursor := crDefault;
  if NewVersionAvailable then begin
    if MessageBoxW(Handle, PWChar(ICSLanguages1.CurrentStrings[133]), PROG_NAME, MB_YESNO or MB_ICONQUESTION) = IdYes then begin
      Close;
      PostMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amDoUpdate), 0);
    end;
  end else MessageBoxW(Handle, PWChar(ICSLanguages1.CurrentStrings[134]), PROG_NAME, MB_OK or MB_ICONINFORMATION);
end;

procedure TfrmProps.FillComboBoxes;
 var I, Ind: Integer;
begin
  Ind := CBESType.ItemIndex;
  CBESType.Items.Clear;
  for I := Ord(esaShutdown) to Ord(High(TEndSessionAction)) do CBESType.Items.Add(ICSLanguages1.CurrentStrings[PROPS_FIRST_ESACTION_ID + I]);
  CBESType.ItemIndex := Ind;
end;

procedure TfrmProps.CBLangChange(Sender: TObject);
begin
  inherited;
  Perform(ICS_SETLANGUAGE_MSG, CBLang.ItemIndex, 0);
end;

procedure TfrmProps.SetListViewCaptions;
 var I: Integer;
begin
  for I := 0 to ICSListViewMenu.Items.Count - 1 do ICSListViewMenu.Items[I].Caption := ICSLanguages1.CurrentStrings[I + 2];
end;

procedure TfrmProps.ICSListViewMenuChanging(Sender: TObject;
  Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
  inherited;
  AllowChange := Visible;
end;

procedure TfrmProps.SetImprintMode(const Value: Boolean);
begin
  FImprintMode := Value;
  if FImprintMode then begin
    if Assigned(ICSListViewMenu.Selected) then begin
      ICSListViewMenu.Selected.Focused := False;
      ICSListViewMenu.Selected := nil;
    end;
    OnPageChange(PanelImprint.Tag);
  end else if Visible then begin
    ICSListViewMenu.Selected := ICSListViewMenu.Items[PMemFile^.Props.LastPropPage];
    ICSListViewMenu.Selected.Focused := True;
  end;
end;

procedure TfrmProps.btnNDeleteAllClick(Sender: TObject);
begin
  inherited;
  if MessageBox(Handle, PChar(ICSLanguages1.CurrentStrings[39]), PROG_NAME, MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) = IdYes then begin
    CloseAllNotes(True);
    RegDeleteKeyTree(HKEY_CURRENT_USER, REG_NOTES_KEY, False);
    PostMessage(Handle, PM_COMMON, Ord(cmOk), Integer(True));
  end;
end;

end.

