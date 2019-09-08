unit uMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Forms, Menus,
  uForm, uData, ICSTrayIcon, ICSLanguages, ICSCatcher, ImgList, StdCtrls,
  System.ImageList;

type
  TfrmMain = class(TfrmForm)
    ICSTrayIcon1: TICSTrayIcon;
    PopupMenuMain: TPopupMenu;
    N1: TMenuItem;
    ItemProps: TMenuItem;
    ItemAbout: TMenuItem;
    ItemClose: TMenuItem;
    Timer1: TTimer;
    ImageListMain: TImageList;
    ImageListTrayIconsXP: TImageList;
    TimerSmartMouseAutoHide: TTimer;
    TimerGetCurrentCursorPos: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ItemCloseClick(Sender: TObject);
    procedure ItemAboutClick(Sender: TObject);
    procedure ItemPropsClick(Sender: TObject);
    procedure ICSTrayIcon1BalloonClick(Sender: TObject);
    procedure ICSTrayIcon1BalloonHide(Sender: TObject);
    procedure ICSTrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerSmartMouseAutoHideTimer(Sender: TObject);
    procedure TimerGetCurrentCursorPosTimer(Sender: TObject);
  private
    FKeyLoggerBuffer: String;
    procedure OnWMInput(var Msg: TMessage); message WM_INPUT;
    procedure OnCommon(var Msg: TMessage); message PM_COMMON;
    procedure OnAction(var Msg: TMessage); message PM_ACTION;
    procedure OnTray(var Msg: TMessage); message PM_TRAYICON;
    procedure OnPropsChange(var Msg: TMessage); message PM_PROPSCHANGE;
    procedure OnHotKey(var Msg: TMessage); message WM_HOTKEY;
    procedure LoadTrayIcons;
    procedure Initialize;
    procedure Finallize;
    procedure SetTrayIcon(TI: TTrayIcon; WithThread: Boolean);
    procedure OnPauseKey;
    procedure OnSSRunPause;
    procedure OnSSRun;
    procedure OnSSEnableDisable;
    procedure OnEmptyClipboard;
    procedure OnEmptyRecycleBin;
    procedure OnEndSession(ESA: TEndSessionAction);
    procedure OnCloseAllNotes(All: Boolean);
    procedure OnDeleteNotProtectedNotes;
    procedure OnShowAutoShowNotes;
    procedure OnSystemTrayInfo(STI: TSystemTrayInfo);
    procedure OnProps(ImprintMode: Boolean);
    procedure OnScreenInfo;
    procedure OnTerminateProcessFromId(Id: Integer);
    procedure KeyboardProc(bKeyDown: Boolean; VKey: WORD);
    procedure MouseProc(const ShiftX, ShiftY: Integer);
    function SetAppHooks(Active: Boolean): Boolean;
    procedure HideSystemCursors;
    procedure ShowSystemCursors;
    procedure ResetTimerSmartMouseAutoHide;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  CommCtrl, ShellAPI, uRawInput, uCommonTools, uProcs, uCProcs, uFormProcs,
  uThreads, uRegLite, uWindows, uProcesses, uTaskBar,
  uAPPForm, uProps, uScreenInfo, uNotes, uTools, uVCLTools;

{$R *.DFM}

function TfrmMain.SetAppHooks(Active: Boolean): Boolean;
begin
  Result := RegisterRawInput(PMemFile^.GlobalData.WndMain);
end;

procedure TfrmMain.OnWMInput(var Msg: TMessage);
 var
   Ri: tagRAWINPUT;
   Size: Cardinal;
begin
  Ri.header.dwSize := SizeOf(RAWINPUTHEADER);
  Size := SizeOf(RAWINPUTHEADER);
  GetRawInputData(HRAWINPUT(Msg.LParam), RID_INPUT, nil, Size, SizeOf(RAWINPUTHEADER));
  if GetRawInputData(HRAWINPUT(Msg.LParam), RID_INPUT, @Ri, Size, SizeOf(RAWINPUTHEADER)) = Size then begin
    if (Ri.header.dwType = RIM_TYPEKEYBOARD) then begin
      KeyboardProc((Ri.keyboard.Message = WM_KEYDOWN), Ri.keyboard.VKey)
    end else if (Ri.header.dwType = RIM_TYPEMOUSE) then begin
      MouseProc(Ri.mouse.lLastX, Ri.mouse.lLastY);
    end;
  end;
  inherited;
end;

procedure TfrmMain.KeyboardProc(bKeyDown: Boolean; VKey: WORD);
begin
  if bKeyDown and (VKey <> VK_MENU) and (VKey < VK_OEM_CLEAR) then begin

    if PMemFile^.Props.ScreenSaver.UsePauseKey and (VKey = VK_PAUSE) then PostMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amPauseKey), 0)
    else if PMemFile^.Props.SmartMouse.Active and not PMemFile^.GlobalData.SmartMouse.IsBlankCursor then begin

      if (PMemFile^.Props.SmartMouse.FunctionalKeys or not (VKey in [VK_F1..VK_F24])) and
         (PMemFile^.Props.SmartMouse.SystemKeys or not (VKey in [VK_SHIFT..VK_ESCAPE])) and
         (PMemFile^.Props.SmartMouse.NavigationKeys or not (VKey in [VK_PRIOR..VK_DOWN])) then HideSystemCursors;

    end;

  end;
end;

procedure TfrmMain.MouseProc(const ShiftX, ShiftY: Integer);
begin
  ResetTimerSmartMouseAutoHide;
  if PMemFile^.GlobalData.SmartMouse.IsBlankCursor then ShowSystemCursors;
end;

procedure TfrmMain.HideSystemCursors;
begin
  if PMemFile^.Props.SmartMouse.CursorNormal then SetSystemCursor(LoadCursor(HInstance, APP_RES_CURSOR_BLANK), OCR_NORMAL);
  if PMemFile^.Props.SmartMouse.CursorIBeam then SetSystemCursor(LoadCursor(HInstance, APP_RES_CURSOR_BLANK), OCR_IBEAM);
  if PMemFile^.Props.SmartMouse.CursorWait then SetSystemCursor(LoadCursor(HInstance, APP_RES_CURSOR_BLANK), OCR_WAIT);
  if PMemFile^.Props.SmartMouse.CursorCross then SetSystemCursor(LoadCursor(HInstance, APP_RES_CURSOR_BLANK), OCR_CROSS);
  if PMemFile^.Props.SmartMouse.CursorHand then SetSystemCursor(LoadCursor(HInstance, APP_RES_CURSOR_BLANK), OCR_HAND);
  if PMemFile^.Props.SmartMouse.CursorAppStarting then SetSystemCursor(LoadCursor(HInstance, APP_RES_CURSOR_BLANK), OCR_APPSTARTING);
  PMemFile^.GlobalData.SmartMouse.IsBlankCursor := True;
end;

procedure TfrmMain.ShowSystemCursors;
begin
  SystemParametersInfo(SPI_SETCURSORS, 0, nil, WM_SETTINGCHANGE or SPIF_UPDATEINIFILE);
  PMemFile^.GlobalData.SmartMouse.IsBlankCursor := False;
  if PMemFile^.Props.SmartMouse.Active and (PMemFile^.Props.SmartMouse.AutoHideInterval > 0) then TimerSmartMouseAutoHide.Enabled := True;
end;

procedure TfrmMain.ResetTimerSmartMouseAutoHide;
begin
  if TimerSmartMouseAutoHide.Enabled then begin
    TimerSmartMouseAutoHide.Enabled := False;
    TimerSmartMouseAutoHide.Enabled := True;
  end;
end;

procedure TfrmMain.TimerGetCurrentCursorPosTimer(Sender: TObject);
 var P: TPoint;
begin
  inherited;
  if GetCursorPos(P) then begin

    if PMemFile^.Props.ScreenSaver.UseMouse then begin
      if PointInSSRunSquare(P) then begin
        if PMemFile^.GlobalData.ScreenSaver.SSCanStart then begin
          PMemFile^.GlobalData.ScreenSaver.SSCanStart := False;
          PostMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amSSRunPause), 0);
        end;
      end else begin
        if PMemFile^.GlobalData.TrayIcon.Icon = tiSSEnabled then begin
          PMemFile^.GlobalData.TrayIcon.Busy := False;
          PMemFile^.GlobalData.ScreenSaver.Wait := False;
        end;
        if not PMemFile^.GlobalData.ScreenSaver.SSCanStart then PMemFile^.GlobalData.ScreenSaver.SSCanStart := True;
      end;
    end;

    if PMemFile^.Props.SmartMouse.Active and (PMemFile^.GlobalData.LastCursorPos <> P) then begin
      if PMemFile^.GlobalData.SmartMouse.IsBlankCursor then ShowSystemCursors else ResetTimerSmartMouseAutoHide;
    end;

    PMemFile^.GlobalData.LastCursorPos := P;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  inherited;
  PMemFile^.GlobalData.WndMain := Handle;
  PMemFile^.Props := GetProps;

  Caption := Application.Title;
  LoadTrayIcons;
  ICSTrayIcon1.Hint := Application.Title;
  ICSTrayIcon1.Icons := ImageListTrayIconsXP;
  ICSTrayIcon1.Active := True;
  FKeyLoggerBuffer := '';

  AlignToSystemTray := True;
  Initialize;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Finallize;
end;

procedure TfrmMain.OnCommon(var Msg: TMessage);
begin
  case TCommonMsg(Msg.WParam) of
    cmTrayIcon: SetTrayIcon(TTrayIcon(Msg.LParam), False);
    cmChangeTrayIcon: SetTrayIcon(TTrayIcon(Msg.LParam), True);
    cmCancel: begin
      PostMessage(Handle, PM_COMMON, Ord(cmChangeTrayIcon), Ord(tiCancel));
      if Boolean(Msg.LParam) then MessageBeep(MB_ICONEXCLAMATION);
    end;
    cmOk: begin
      PostMessage(Handle, PM_COMMON, Ord(cmChangeTrayIcon), Ord(tiOk));
      if Boolean(Msg.LParam) then MessageBeep(MB_ICONINFORMATION);;
    end;
    cmGetOpenNoteCount: Msg.Result := GetOpenNoteCount;
  end;
end;

procedure TfrmMain.Initialize;
begin
  SetTrayIcon(tiBusy, False);
  if not SetAppHooks(True) then Windows.Beep(300, 100);
  OnShowAutoShowNotes;
  Perform(PM_PROPSCHANGE, 0, 0);
  TCheckThread.Create(Handle, tpIdle);
//  RegSetString(HKEY_LOCAL_MACHINE, REG_APP_KEY, '', ExtractFilePath(ParamStr(0)));
end;

procedure TfrmMain.Finallize;
 var I: Integer;
begin
  Timer1.Enabled := False;
  for I := Screen.FormCount - 1 downto 0 do if Screen.Forms[I].Handle <> Handle then SendMessage(Screen.Forms[I].Handle, WM_SYSCOMMAND, SC_CLOSE, 0);
  SaveProps(PMemFile^.Props);
  UnregisterHotKeys;
  ShowSystemCursors;
  ShutdownThreads;
end;

procedure TfrmMain.SetTrayIcon(TI: TTrayIcon; WithThread: Boolean);
begin
  ICSTrayIcon1.IconIndex := Ord(TI);
  if WithThread then begin
    PMemFile^.GlobalData.TrayIcon.Icon := TI;
    PMemFile^.GlobalData.TrayIcon.Counter := GetTickCount;
    if not PMemFile^.GlobalData.TrayIcon.Busy then TTrayIconThread.Create(Handle, tpNormal);
  end;
end;

procedure TfrmMain.OnShowAutoShowNotes;
 var
   A: TStringArray;
   I: Integer;
   NP: TNoteParamsRec;
begin
  A := GetNotesArray;
  if Length(A) > 0 then for I := 0 to High(A) do begin
    NP := GetNoteParams(A[I]);
    if NP.AutoShow then ShowNoteFromId(A[I]);
  end;
end;

procedure TfrmMain.OnAction(var Msg: TMessage);
begin
  case TActionMsg(Msg.WParam) of
    amTemp: ;
    amPauseKey: OnPauseKey;
    amSSRunPause: OnSSRunPause;
    amSSRun: OnSSRun;
    amSSEnableDisable: OnSSEnableDisable;
    amEmptyClipboard: OnEmptyClipboard;
    amEmptyRecycleBin: OnEmptyRecycleBin;
    amEndSession: OnEndSession(TEndSessionAction(Msg.LParam));
    amNewNote: MakeNewNote;
    amShowAllNotes: ShowAllNotes(False);
    amScreenInfo: OnScreenInfo;
    amProps: OnProps(False);
    amAbout: OnProps(True);
    amShowAutoShowNotes: OnShowAutoShowNotes;
    amCloseAllNotes: OnCloseAllNotes(True);
    amDeleteUnprotectedNotes: OnDeleteNotProtectedNotes;
    amSystemTrayInfo: OnSystemTrayInfo(TSystemTrayInfo(Msg.LParam));
    amDoUpdate: DoUpdate;
    amTerminateProcessFromId: OnTerminateProcessFromId(Msg.LParam);
  end;
end;

procedure TfrmMain.OnPropsChange(var Msg: TMessage);
begin
  RegisterHotKeys;
  SetTrayIcon(tiMain, False);
  ShowSystemCursors;
  TimerSmartMouseAutoHide.Interval := PMemFile^.Props.SmartMouse.AutoHideInterval;
  TimerSmartMouseAutoHide.Enabled := PMemFile^.Props.SmartMouse.Active and (PMemFile^.Props.SmartMouse.AutoHideInterval > 0);
end;

procedure TfrmMain.OnTray(var Msg: TMessage);
 var
   P: TPoint;
   hTraySysMenu: HMENU;
   I: Integer;
   ItemCmd: DWORD;
begin
  case Msg.LParam of
    WM_LBUTTONUP, NIN_KEYSELECT: DoTrayCommand(Msg.WParam, SC_RESTORE, True);
    WM_RBUTTONUP, WM_CONTEXTMENU: begin
      SetForegroundWindow(Handle);
      GetCursorPos(P);
      hTraySysMenu := GetSystemMenu(HWND(Msg.WParam), False);
      for I := 0 to GetMenuItemCount(hTraySysMenu) - 1 do case GetMenuItemID(hTraySysMenu, I) of
        SC_SIZE, SC_MOVE, SC_MINIMIZE: EnableMenuItem(hTraySysMenu, I, MF_BYPOSITION or MF_DISABLED or MF_GRAYED);
        SC_RESTORE, SC_CLOSE: EnableMenuItem(hTraySysMenu, I, MF_BYPOSITION or MF_ENABLED);
        SC_MAXIMIZE: if (GetWindowLong(Msg.WParam, GWL_STYLE) and WS_MAXIMIZEBOX) = WS_MAXIMIZEBOX then EnableMenuItem(hTraySysMenu, I, MF_BYPOSITION or MF_ENABLED) else EnableMenuItem(hTraySysMenu, I, MF_BYPOSITION or MF_DISABLED or MF_GRAYED);
        else EnableMenuItem(hTraySysMenu, I, MF_BYPOSITION or MF_DISABLED or MF_GRAYED);
      end;
      SetMenuDefaultItem(hTraySysMenu, SC_RESTORE, 0);
      ItemCmd := DWORD(TrackPopupMenuEx(hTraySysMenu, TPM_NONOTIFY or TPM_RETURNCMD, P.x, P.y, Handle, nil));
      PostMessage(Handle, WM_NULL, 0, 0);
      if ItemCmd > 0 then DoTrayCommand(Msg.WParam, ItemCmd, True) else TaskBarSetFocus(Msg.WParam);
    end;
  end;
end;

procedure TfrmMain.OnHotKey(var Msg: TMessage);
begin
  inherited;
  case Msg.WParam of
    HOTKEY_ENDSESSION_ID: OnEndSession(esaFromProps);
    HOTKEY_NOTE_ID: MakeNewNote;
    HOTKEY_EMPTY_RB: OnEmptyrecycleBin;
    HOTKEY_EMPTY_CBD: OnEmptyClipboard;
    HOTKEY_SCREEN_INFO: OnScreenInfo;
    HOTKEY_SCREENSAVER: OnSSRun;
  end;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  inherited;
  Application.RestoreTopMosts;
end;

procedure TfrmMain.TimerSmartMouseAutoHideTimer(Sender: TObject);
begin
  inherited;
  TimerSmartMouseAutoHide.Enabled := False;
  HideSystemCursors;
end;

procedure TfrmMain.ItemCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmMain.OnPauseKey;
begin
  if icsGetCurrentSSFileName <> '' then OnSSRun else SetTrayIcon(tiSSDisabled, True);
end;

procedure TfrmMain.OnSSRunPause;
begin
  if icsGetCurrentSSFileName <> '' then begin
    SetTrayIcon(tiSSEnabled, True);
    TSSThread.Create(Handle, tpNormal);
  end else SetTrayIcon(tiSSDisabled, True);
end;

procedure TfrmMain.OnSSRun;
begin
  PostMessage(GetDesktopWindow, WM_SYSCOMMAND, SC_SCREENSAVE, 0);
end;

procedure TfrmMain.OnSSEnableDisable;
 var SSCurrent, SSSaved: String;
begin
  SSCurrent := icsGetCurrentSSFileName;
  SSSaved := RegGetString(HKEY_CURRENT_USER, REG_APP_KEY, REG_SSSAVED_VALUE);
  if (SSCurrent = '') and (SSSaved <> '') then begin
    icsSetCurrentSSFileName(SSSaved);
    RegSetString(HKEY_CURRENT_USER, REG_APP_KEY, REG_SSSAVED_VALUE, '');
    SetTrayIcon(tiSSEnabled, True);
  end else if (SSCurrent <> '') then begin
    RegSetString(HKEY_CURRENT_USER, REG_APP_KEY, REG_SSSAVED_VALUE, SSCurrent);
    icsSetCurrentSSFileName('');
    SetTrayIcon(tiSSDisabled, True);
  end else SetTrayIcon(tiCancel, True);
end;

procedure TfrmMain.OnEmptyClipboard;
begin
  if not icsIsClipboardEmpty(Handle) then if OpenClipboard(Handle) and EmptyClipboard then begin
    CloseClipboard;
    PostMessage(Handle, PM_COMMON, Ord(cmOk), Integer(True));
  end else PostMessage(Handle, PM_COMMON, Ord(cmCancel), Integer(True));
end;

procedure TfrmMain.OnEmptyRecycleBin;
begin
  if icsGetRecycleBinItemCount > 0 then begin
    PostMessage(Handle, PM_COMMON, Ord(cmTrayIcon), Ord(tiRecicleBin));
    TRecycleBinThread.Create(Handle, tpIdle);
  end else PostMessage(Handle, PM_COMMON, Ord(cmChangeTrayIcon), Ord(tiCancel));
end;

procedure TfrmMain.OnEndSession(ESA: TEndSessionAction);

  procedure _EndSession(ESA: TEndSessionAction);
   var Cmd: Integer;
  begin
    case ESA of
      esaShutDown: Cmd := EWX_SHUTDOWN or EWX_POWEROFF;
      esaReboot: Cmd := EWX_REBOOT;
      esaHibernate: Cmd := Integer(True);
      esaStandby: Cmd := Integer(False);
      esaLogoff: Cmd := EWX_LOGOFF;
      else Cmd := 0;
    end;
    if ESA in [esaShutDown, esaReboot, esaLogoff] then icsDoWindowsShutdown(Cmd)
    else if ESA in [esaHibernate, esaStandby] then begin
      if (Boolean(Cmd) and IsPwrHibernateAllowed) or (not Boolean(Cmd) and IsPwrSuspendAllowed) then SetSuspendState(Boolean(Cmd), False, False) else PostMessage(Handle, PM_COMMON, Ord(cmCancel), Integer(True));
    end;
  end;

 var Wnd: HWND;
begin
  if ESA = esaFromProps then begin
    Wnd := 0;
    if PMemFile^.Props.EndSession.Confirm then begin
      Wnd := FindWindow('Shell_TrayWnd', '');
      if Wnd <> 0 then begin
        SetForegroundWindow(Wnd);
        PostMessage(Wnd, WM_SYSCOMMAND, SC_CLOSE, 0);
      end;
    end;
    if Wnd = 0 then _EndSession(PMemFile^.Props.EndSession.Action);
  end else _EndSession(ESA);
end;

procedure TfrmMain.OnCloseAllNotes(All: Boolean);
begin
  CloseAllNotes(True);
end;

procedure TfrmMain.OnDeleteNotProtectedNotes;
 var
   A: TStringArray;
   I: Integer;
begin
  if MessageBoxW(Handle, PWChar(ICSLanguages1.CurrentStrings[41]), PROG_NAME, MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) = IdYes then begin
    CloseAllNotes(False);
    A := GetNotesArray;
    for I := 0 to High(A) do if not GetNoteParams(A[I]).Protect then RegDeleteKey(HKEY_CURRENT_USER, PChar(REG_NOTES_KEY + '\' + A[I]));
    PostMessage(Handle, PM_COMMON, Ord(cmOk), Integer(True));
  end;
end;

procedure TfrmMain.OnSystemTrayInfo(STI: TSystemTrayInfo);
begin
  ICSTrayIcon1.Tag := Ord(STI);
  case STI of
    stiNewVersion: ICSTrayIcon1.BalloonHint(PROG_NAME, icsGetReplacedString(ICSLanguages1.CurrentStrings[39], '#', #13), btInfo);
  end;
end;

procedure TfrmMain.OnProps(ImprintMode: Boolean);
begin
  if not Assigned(frmProps) then frmProps := TfrmProps.Create(Application);
  frmProps.ImprintMode := ImprintMode;
  frmProps.Show;
end;

procedure TfrmMain.ItemAboutClick(Sender: TObject);
begin
  inherited;
  OnProps(True);
end;

procedure TfrmMain.OnScreenInfo;
begin
  if not Assigned(frmScreenInfo) then frmScreenInfo := TfrmScreenInfo.Create(Application);
  frmScreenInfo.Show;
end;

procedure TfrmMain.ItemPropsClick(Sender: TObject);
begin
  inherited;
  OnProps(False);
end;

procedure TfrmMain.LoadTrayIcons;
 var I: Integer;
begin
  ImageListTrayIconsXP.Clear;
  for I := TRAYICON_XP_RESID_FIRST to TRAYICON_XP_RESID_FIRST + TRAYICON_RESID_COUNT do icsImageListLoadFromRecources(ImageListTrayIconsXP, I);
end;

procedure TfrmMain.OnTerminateProcessFromId(Id: Integer);
 var Idx: Integer;
begin
  Idx := ProcessList.IndexFromPID(Id);
  if (Idx >= 0) and ProcessList.Processes[Idx].Terminate then PostMessage(Handle, PM_COMMON, Ord(cmOk), Integer(True)) else PostMessage(Handle, PM_COMMON, Ord(cmCancel), Integer(True));
end;

procedure TfrmMain.ICSTrayIcon1BalloonClick(Sender: TObject);
begin
  inherited;
  case TSystemTrayInfo(ICSTrayIcon1.Tag) of
    stiNewVersion: DoUpdate;
  end;
end;

procedure TfrmMain.ICSTrayIcon1BalloonHide(Sender: TObject);
begin
  inherited;
  ICSTrayIcon1.Tag := Ord(stiNone);
end;

procedure TfrmMain.ICSTrayIcon1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then begin
    if not Assigned(frmTools) then frmTools := TfrmTools.Create(Application);
    frmTools.Show;
  end;
end;

end.
