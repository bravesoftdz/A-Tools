unit uData;

interface

uses
  Windows, Messages;

const
  COMPANY                       = 'Chensky IT-Services';
  PROG_NAME                     = 'A-Tools';
  PROG_CLSID                    = '{9B660C29-DFF4-4530-8713-638D62D16FB4}';

const
  PARAM_INSTALL                 = '/install';
  PARAM_UNINSTALL               = '/uninstall';
  PARAM_SHUTDOWN                = '/shutdown';

const
  MAX_BUFFER                    = 1024;
  SHORT_FNAME_LENGTH            = 12;
  MAX_URL_LENGTH                = 128;
  MAX_URL_RESULT_LENGTH         = 32;

const
  PM_COMMON            = WM_USER + $0FF;
  PM_ACTION            = WM_USER + $100;
  PM_TRAYICON          = WM_USER + $101;
  PM_PROPSCHANGE       = WM_USER + $102;
  PM_MOUSEUP           = WM_USER + $103;
  PM_ACTIVATEWND       = WM_USER + $104;

const
  PROG_HOST                     = 'www.a-tools.com';
  HOST_GET_DATA_URL             = 'http://' + PROG_HOST + '/getdata.php';
  HOST_DATA_PARAM               = 'p';
  HOST_DATA_PARAM_VERSION       = 'v';
  HOST_DATA_PARAM_UPDATE        = 'u';

const
  REG_APP_KEY                  = 'Software\' + COMPANY + '\' + PROG_NAME;
  REG_RECYCLEBIN_SOUND_KEY     = 'AppEvents\Schemes\Apps\Explorer\EmptyRecycleBin\.Current';
  REG_NOTES_KEY                = REG_APP_KEY + '\Notes';
  REG_HISTORY_KEY              = REG_APP_KEY + '\History';

  REG_SSSAVED_VALUE            = 'SSSaved';
  REG_LANGUAGE_VALUE           = 'Lang';

const
  TRAYICON_RESID_COUNT         = 14;
  TRAYICON_XP_RESID_FIRST      = 1001;

const
  MAX_HOTKEY_ID                = 9;

  HOTKEY_NONE_ID               = 1;
  HOTKEY_NOT_USED_ID_1         = 2;
  HOTKEY_ENDSESSION_ID         = 3;
  HOTKEY_NOTE_ID               = 5;
  HOTKEY_EMPTY_RB              = 6;
  HOTKEY_EMPTY_CBD             = 7;
  HOTKEY_SCREEN_INFO           = 8;
  HOTKEY_SCREENSAVER           = 9;

const
  PROPS_FIRST_ESACTION_ID      = 100;
//  PROPS_FIRST_KBLAYOUTKEY_ID   = 108;

const
  APP_RES_CURSOR_BLANK         = 'ATCRBLANK';

type
  TCommonMsg = (cmTrayIcon, cmChangeTrayIcon, cmCancel, cmOk, cmGetOpenNoteCount, cmSIStartStop, cmShowRuler);

  TActionMsg = (amTemp, amClose,
                amPauseKey, amSSRunPause, amSSRun, amSSEnableDisable,
                amEmptyClipboard, amEmptyRecycleBin, amEndSession,
                amNewNote, amNoteFromId, amShowAllNotes, amDeleteAllNotes, amCloseAllNotes,
                amShowAutoShowNotes, amDeleteUnprotectedNotes, amTerminateProcessFromId,
                amScreenInfo, amProps, amAbout, amSystemTrayInfo, amDoUpdate,
                amFirstRun);

  TTrayIcon = (tiWindows, tiMain, tiBusy, tiSSEnabled, tiSSDisabled, tiRecicleBin, tiOk, tiCancel);
  TThreadAction = (taCreate, taFree);
  TSSRunCorner = (ssRCTopLeft, ssRCTopRight, ssRCBottomLeft, ssRCBottomRight);

type
  TEndSessionAction = (esaFromProps, esaShutDown, esaReboot, esaHibernate, esaStandby, esaLogOff);
  TSystemTrayInfo = (stiNone, stiNewVersion);

type
  TRGB = record
    R, G, B: Byte;
  end;

  TStringArray = array of String;

type
  TPath = array[0..MAX_PATH - 1] of Char;
  TBuf = array[0..MAX_BUFFER - 1] of Char;
  TShortFName = array[0..SHORT_FNAME_LENGTH - 1] of Char;

  TProgFontStyles = packed record
    Bold: Boolean;
    Italic: Boolean;
    Underline: Boolean;
    StrikeOut: Boolean;
  end;
  TProgFont = packed record
    Name: array[0..LF_FACESIZE - 1] of Char;
    Color: Integer;
    Size: Integer;
    Style: TProgFontStyles;
    CharSet: DWord;
  end;

  THotKeyRec = packed record
    VKey: Integer;
    Modifiers: Integer;
  end;

  TTrayIconRec = packed record
    Counter: DWord;
    Icon: TTrayIcon;
    Busy: Boolean;
  end;
  TSmartMouseRec = packed record
    IsBlankCursor: Boolean;
  end;
  TScreenSaverRec = packed record
    SSCanStart: Boolean;
    Wait: Boolean;
  end;
  TGlobalData = packed record
    WndMain: HWND;
    TrayIcon: TTrayIconRec;
    SmartMouse: TSmartMouseRec;
    ScreenSaver: TScreenSaverRec;
    DiskOperationInProgress: Boolean;
    OnlineTimeCounter: DWord;
    WorkMessage: DWORD;
    LastCursorPos: TPoint;
  end;

  TScreenSaverP = packed record
    UsePauseKey: Boolean;
    UseMouse: Boolean;
    Delay: DWord;
    RunCorner: TSSRunCorner;
    RunSize: Integer;
    HotKey: THotKeyRec;
  end;
  TEndSessionP = packed record
    Action: TEndSessionAction;
    Confirm: Boolean;
    HotKey: THotKeyRec;
  end;
  TNoteParamsRec = packed record
    Left, Top, Width, Height: SmallInt;
    Font: TProgFont;
    Color: COLORREF;
    AutoShow: Boolean;
    StayOnTop: Boolean;
    WordWrap: Boolean;
    Transparency: Byte;
    Protect: Boolean;
    Autoheight: Boolean;
  end;
  TNoteP = packed record
    DefaultParams: TNoteParamsRec;
    HotKey: THotKeyRec;
  end;
  TSmartMouseP = packed record
    Active: Boolean;
    SystemKeys: Boolean;
    FunctionalKeys: Boolean;
    NavigationKeys: Boolean;
    CursorNormal: Boolean;
    CursorIBeam: Boolean;
    CursorWait: Boolean;
    CursorCross: Boolean;
    CursorHand: Boolean;
    CursorAppStarting: Boolean;
    AutoHideInterval: DWORD;
  end;
  TScreenInfoP = packed record
    Left: SmallInt;
    Top: SmallInt;
    LupeFactor: Integer;
    HotKey: THotKeyRec;
    LastPage: Integer;
  end;
  TDispixP = packed record
    Invert: Boolean;
    Left: SmallInt;
    Top: SmallInt;
    Width: SmallInt;
    Height: SmallInt;
    BlockSize: Integer;
    PageSize: Integer;
    Border: Integer;
    CopyPause: DWord;
  end;
  TEmptyP = packed record
    RecycleBinHotKey: THotKeyRec;
    ClipboardHotKey: THotKeyRec;
  end;
  TGUIDP = packed record
    HotKey: THotKeyRec;
  end;
  TMemoryOptimizerP = packed record
    Enabled: Boolean;
    Interval: DWORD;
  end;

  TProps = packed record
    Size: DWORD;
    TrayIconDelay: DWord;
    LastPropPage: Integer;
    CheckNewVersion: Boolean;

    SmartMouse: TSmartMouseP;
    ScreenSaver: TScreenSaverP;
    EndSession: TEndSessionP;
    Note: TNoteP;
    ScreenInfo: TScreenInfoP;
    Dispix: TDispixP;
    Empty: TEmptyP;
    MemoryOptimizer: TMemoryOptimizerP;
  end;

  TMemFile = packed record
    GlobalData: TGlobalData;
    Props: TProps;
  end;

var
  PMemFile: ^TMemFile = nil;

implementation

end.
