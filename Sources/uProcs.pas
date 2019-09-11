unit uProcs;

interface

uses
  Windows, Messages, SysUtils, uData;

procedure DBG(Msg: String);

function GetProps: TProps;
procedure SaveProps(P: TProps);
function GetNoteParams(Id: String): TNoteParamsRec;

procedure UnregisterHotKeys;
procedure RegisterHotKeys;

function GetTimeString(Value: DWord): String;

function GetNotesArray: TStringArray;

function GetIntVersion(Version: String): Integer;

function GetDesktopWallpaperXY: DWORD;
procedure SetDesktopWallpaperXY(XY: DWORD);

function GetWindowsStartup: Boolean;
procedure SetWindowsStartup(Startup: Boolean);

function NewVersionAvailable: Boolean;

procedure DoTrayCommand(ID, SCAction: DWORD; DeleteTrayIcon: Boolean);

function GetIconHandleFromFileName(FName: String): HICON;

implementation

uses
  ActiveX, ShellAPI, ShlObj, WinSock, WinINet, CommCtrl, RegStr,
  uCommonTools, uBeep, uCProcs, uRegLite, uProcesses, uWindows, uTaskBar;

procedure DBG(Msg: String);
begin
{$IFDEF DEBUG}
  OutputDebugString(PChar(PROG_NAME + ': ' + Msg));
{$ENDIF}
end;

function GetDefaultProps: TProps;
begin
  Result.Size := SizeOf(TProps);
  Result.TrayIconDelay := 1000;
  Result.LastPropPage := 0;
  Result.CheckNewVersion := True;

  Result.SmartMouse.Active := True;
  Result.SmartMouse.SystemKeys := False;
  Result.SmartMouse.FunctionalKeys := False;
  Result.SmartMouse.NavigationKeys := False;
  Result.SmartMouse.CursorNormal := True;
  Result.SmartMouse.CursorIBeam := True;
  Result.SmartMouse.CursorWait := False;
  Result.SmartMouse.CursorCross := True;
  Result.SmartMouse.CursorHand := False;
  Result.SmartMouse.CursorAppStarting := False;
  Result.SmartMouse.AutoHideInterval := 3000;

  Result.ScreenSaver.UsePauseKey := True;
  Result.ScreenSaver.UseMouse := True;
  Result.ScreenSaver.Delay := GetDoubleClickTime;
  Result.ScreenSaver.RunCorner := ssRCTopLeft;
  Result.ScreenSaver.RunSize := 5;
  Result.ScreenSaver.HotKey.VKey := 0;
  Result.ScreenSaver.HotKey.Modifiers := 0;

  Result.EndSession.Action := esaShutDown;
  Result.EndSession.Confirm := True;
  Result.EndSession.HotKey.VKey := 0;
  Result.EndSession.HotKey.Modifiers := 0;

  Result.Note.DefaultParams.Left := 10;
  Result.Note.DefaultParams.Top := 10;
  Result.Note.DefaultParams.Width := 200;
  Result.Note.DefaultParams.Height := 150;
  Result.Note.DefaultParams.Font.Name := 'Courier New';
  Result.Note.DefaultParams.Font.Color := RGB(0, 0, 128);
  Result.Note.DefaultParams.Font.Size := 10;
  Result.Note.DefaultParams.Font.Style.Bold := False;
  Result.Note.DefaultParams.Font.Style.Italic := False;
  Result.Note.DefaultParams.Font.Style.Underline := False;
  Result.Note.DefaultParams.Font.Style.StrikeOut := False;
  Result.Note.DefaultParams.Font.CharSet := DEFAULT_CHARSET;
  Result.Note.DefaultParams.Color := RGB(192, 220, 192);
  Result.Note.DefaultParams.AutoShow := False;
  Result.Note.DefaultParams.StayOnTop := True;
  Result.Note.DefaultParams.WordWrap := True;
  Result.Note.DefaultParams.Transparency := 0;
  Result.Note.DefaultParams.Protect := False;
  Result.Note.DefaultParams.Autoheight := False;
  Result.Note.HotKey.VKey := 0;
  Result.Note.HotKey.Modifiers := 0;

  Result.ScreenInfo.Left := 10;
  Result.ScreenInfo.Top := 400;
  Result.ScreenInfo.LupeFactor := 1;
  Result.ScreenInfo.HotKey.VKey := 0;
  Result.ScreenInfo.HotKey.Modifiers := 0;
  Result.ScreenInfo.LastPage := 0;

  Result.Dispix.Invert := False;
  Result.Dispix.Left := 100;
  Result.Dispix.Top := 100;
  Result.Dispix.Width := 200;
  Result.Dispix.Height := 100;
  Result.Dispix.BlockSize := 5;
  Result.Dispix.PageSize := 8;
  Result.Dispix.Border := 2;
  Result.Dispix.CopyPause := 500;

  Result.Empty.RecycleBinHotKey.VKey := 0;
  Result.Empty.RecycleBinHotKey.Modifiers := 0;
  Result.Empty.ClipboardHotKey.VKey := 0;
  Result.Empty.ClipboardHotKey.Modifiers := 0;

  Result.MemoryOptimizer.Enabled := True;
  Result.MemoryOptimizer.Interval := 1;
end;

function GetProps: TProps;
begin
  if not RegGetBinary(HKEY_CURRENT_USER, REG_APP_KEY, 'Properties', @Result, SizeOf(Result)) or (Result.Size <> SizeOf(TProps)) then begin
    Result := GetDefaultProps;
    SaveProps(Result);
    PostMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amFirstRun), 0);
  end;
end;

procedure SaveProps(P: TProps);
begin
  RegSetBinary(HKEY_CURRENT_USER, REG_APP_KEY, 'Properties', @P, SizeOf(P));
end;

function GetNoteParams(Id: String): TNoteParamsRec;
begin
  if not RegGetBinary(HKEY_CURRENT_USER, REG_NOTES_KEY + '\' + Id, 'Params', @Result, SizeOf(Result)) then FillChar(Result, SizeOf(Result), 0);
end;

procedure UnregisterHotKeys;
 var I: Integer;
begin
  for I := 1 to MAX_HOTKEY_ID do UnregisterHotKey(PMemFile^.GlobalData.WndMain, I);
end;

procedure RegisterHotKeys;
begin
  UnregisterHotKeys;
  RegisterHotKey(PMemFile^.GlobalData.WndMain, HOTKEY_ENDSESSION_ID, PMemFile^.Props.EndSession.HotKey.Modifiers, PMemFile^.Props.EndSession.HotKey.VKey);
  RegisterHotKey(PMemFile^.GlobalData.WndMain, HOTKEY_NOTE_ID, PMemFile^.Props.Note.HotKey.Modifiers, PMemFile^.Props.Note.HotKey.VKey);
  RegisterHotKey(PMemFile^.GlobalData.WndMain, HOTKEY_EMPTY_RB, PMemFile^.Props.Empty.RecycleBinHotKey.Modifiers, PMemFile^.Props.Empty.RecycleBinHotKey.VKey);
  RegisterHotKey(PMemFile^.GlobalData.WndMain, HOTKEY_EMPTY_CBD, PMemFile^.Props.Empty.ClipboardHotKey.Modifiers, PMemFile^.Props.Empty.ClipboardHotKey.VKey);
  RegisterHotKey(PMemFile^.GlobalData.WndMain, HOTKEY_SCREEN_INFO, PMemFile^.Props.ScreenInfo.HotKey.Modifiers, PMemFile^.Props.ScreenInfo.HotKey.VKey);
  if not PMemFile^.Props.ScreenSaver.UsePauseKey then RegisterHotKey(PMemFile^.GlobalData.WndMain, HOTKEY_SCREENSAVER, PMemFile^.Props.ScreenSaver.HotKey.Modifiers, PMemFile^.Props.ScreenSaver.HotKey.VKey);
end;

function GetTimeString(Value: DWORD): String;
 var
   Hr, Min, Sec: Integer;
   stHr, stMin, stSec: String;
begin
  Sec :=  Value div 1000;
  Hr := Sec div 3600;
  Min := (Sec - Hr * 3600) div 60;
  Sec := Sec - Hr * 3600 - Min * 60;
  stHr := IntToStr(Hr);
  if Length(stHr) < 2 then stHr := '0' + stHr;
  stMin := IntToStr(Min);
  if Length(stMin) < 2 then stMin := '0' + stMin;
  stSec := IntToStr(Sec);
  if Length(stSec) < 2 then stSec := '0' + stSec;
  Result := stHr + ':' + stMin + ':' + stSec;
end;

function GetNotesArray: TStringArray;
 var
   hCurrentKey: HKEY;
   lpBuf: TBuf;
   dwIndex, lpcbBuf: DWord;
begin
  if RegOpenKeyEx(HKEY_CURRENT_USER, REG_NOTES_KEY, 0, KEY_READ, hCurrentKey) = ERROR_SUCCESS then begin
    dwIndex := 0;
    lpcbBuf := MAX_BUFFER;
    while RegEnumKeyEx(hCurrentKey, dwIndex, lpBuf, lpcbBuf, nil, nil, nil, nil) = ERROR_SUCCESS do begin
      if Length(String(lpBuf)) > 0 then begin
        SetLength(Result, dwIndex + 1);
        Result[dwIndex] := String(lpBuf);
      end;
      Inc(dwIndex);
      lpcbBuf := MAX_BUFFER;
    end;
    RegCloseKey(hCurrentKey);
  end;
end;

procedure IncSystemTime(var ST: TSystemTime; T: DWORD);
 var TempST: TSystemTime;
begin
  DateTimeToSystemTime(SystemTimeToDateTime(ST) + T, TempST);
  ST.wHour := TempST.wHour;
  ST.wMinute := TempST.wMinute;
  ST.wSecond := TempST.wSecond;
  ST.wMilliseconds := TempST.wMilliseconds;
end;

function GetIntVersion(Version: String): Integer;
begin
  while Pos('.', Version) <> 0 do Delete(Version, Pos('.', Version), 1);
  Result := StrToInt(Version);
end;

function GetDesktopWallpaperXY: DWORD;
begin
  Result := MakeLong(StrToInt(RegGetString(HKEY_CURRENT_USER, REGSTR_PATH_DESKTOP, 'WallpaperOriginX')), StrToInt(RegGetString(HKEY_CURRENT_USER, REGSTR_PATH_DESKTOP, 'WallpaperOriginY')));
end;

procedure SetDesktopWallpaperXY(XY: DWORD);
begin
  RegSetString(HKEY_CURRENT_USER, REGSTR_PATH_DESKTOP, 'WallpaperOriginX', IntToStr(LoWord(XY)));
  RegSetString(HKEY_CURRENT_USER, REGSTR_PATH_DESKTOP, 'WallpaperOriginY', IntToStr(HiWord(XY)));
  SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, nil, SPIF_SENDCHANGE);
end;

function GetWindowsStartup: Boolean;
begin
  Result := (UpperCase(ParamStr(0)) = UpperCase(RegGetString(HKEY_CURRENT_USER, REGSTR_PATH_RUN, PROG_NAME)));
end;

procedure SetWindowsStartup(Startup: Boolean);
begin
  if Startup then RegSetString(HKEY_CURRENT_USER, REGSTR_PATH_RUN, PROG_NAME, ParamStr(0)) else RegDelValue(HKEY_CURRENT_USER, REGSTR_PATH_RUN, PROG_NAME);
end;

function NewVersionAvailable: Boolean;
 var S: String;
begin
  S := String(icsGetINetString(HOST_GET_DATA_URL + '?' + HOST_DATA_PARAM + '=' + HOST_DATA_PARAM_VERSION));
  Result := (S <> '') and (GetIntVersion(S) > GetIntVersion(icsGetFileVersion(ParamStr(0))));
end;

procedure DoTrayCommand(ID, SCAction: DWORD; DeleteTrayIcon: Boolean);
begin
  ShowWindow(HWND(ID), SW_SHOW);
  case SCAction of
    SC_MAXIMIZE: SendMessage(HWND(ID), WM_SYSCOMMAND, SC_MAXIMIZE, 0);
    SC_RESTORE: SendMessage(HWND(ID), WM_SYSCOMMAND, SC_RESTORE, 0);
    SC_CLOSE: PostMessage(HWND(ID), WM_SYSCOMMAND, SC_CLOSE, 0);
  end;
  if SCAction <> SC_MINIMIZE then SetForegroundWindow(HWND(ID));
  if DeleteTrayIcon then TaskBarDeleteIcon(ID);
end;

function GetIconHandleFromFileName(FName: String): HICON;
 var shInfo: TSHFileInfo;
begin
  SHGetFileInfo(PChar(FName), 0, shInfo, SizeOf(shInfo), SHGFI_ICON or SHGFI_OPENICON or SHGFI_SHELLICONSIZE or SHGFI_SMALLICON or SHGFI_SYSICONINDEX);
  Result := shInfo.hIcon;
end;

end.
