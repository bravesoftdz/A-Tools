unit uThreads;

interface

uses
  Windows, Classes;

type
  TQTThread = class(TThread)
  private
    FWndNotify: HWND;
  public
    constructor Create(Wnd: HWND; P: TThreadPriority);
    property WndNotify: HWND read FWndNotify;
  end;

  TTrayIconThread = class(TQTThread)
  protected
    procedure Execute; override;
  end;

  TSSThread = class(TQTThread)
  protected
    procedure Execute; override;
  end;

  TRecycleBinThread = class(TQTThread)
  protected
    procedure Execute; override;
  end;

  TCheckThread = class(TQTThread)
  protected
    procedure Execute; override;
  end;

procedure ShutdownThreads;

implementation

uses
  Messages, MMSystem, CommCtrl, ShellAPI,
  uData, uCProcs, uProcs, uCommonTools, uWindows, uRegLite;

const
  MAIN_THREAD_SLEEP_PAUSE = 100;

var
//  TrayIconThread: TTrayIconThread = nil;
//  SSThread: TSSThread = nil;
//  RecycleBinThread: TRecycleBinThread = nil;
//  SynchronizeThread: TSynchronizeThread = nil;
//  EnumWindowsThread: TEnumWindowsThread = nil;
  CheckThread: TCheckThread = nil;

procedure ShutdownThread(T: TQTThread);
begin
  if Assigned(T) then T.Terminate;
end;

procedure ShutdownThreads;
begin
  ShutdownThread(CheckThread);
//  ShutdownThread(TrayIconThread);
//  ShutdownThread(SSThread);
//  ShutdownThread(RecycleBinThread);
//  ShutdownThread(SynchronizeThread);
//  ShutdownThread(EnumWindowsThread);
end;

{ TQTThread }

constructor TQTThread.Create(Wnd: HWND; P: TThreadPriority);
begin
  inherited Create;
  FWndNotify := Wnd;
  Priority := P;
  FreeOnTerminate := True;
end;

{ TTrayIconThread }

procedure TTrayIconThread.Execute;
 var TI: TTrayIcon;
begin
  PMemFile^.GlobalData.TrayIcon.Busy := True;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_COMMON, Ord(cmTrayIcon), Ord(PMemFile^.GlobalData.TrayIcon.Icon));
  TI := PMemFile^.GlobalData.TrayIcon.Icon;
  while not Terminated and PMemFile^.GlobalData.TrayIcon.Busy and (GetTickCount - PMemFile^.GlobalData.TrayIcon.Counter <= PMemFile^.Props.TrayIconDelay) do begin
    if TI <> PMemFile^.GlobalData.TrayIcon.Icon then begin
      TI := PMemFile^.GlobalData.TrayIcon.Icon;
      SendMessage(PMemFile^.GlobalData.WndMain, PM_COMMON, Ord(cmTrayIcon), Ord(PMemFile^.GlobalData.TrayIcon.Icon));
    end;
    Sleep(1);
  end;
  PMemFile^.GlobalData.TrayIcon.Icon := tiMain;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_COMMON, Ord(cmTrayIcon), Ord(PMemFile^.GlobalData.TrayIcon.Icon));
  PMemFile^.GlobalData.TrayIcon.Busy := False;
end;

{ TSSThread }

procedure TSSThread.Execute;
 var Counter: DWord;
begin
  PMemFile^.GlobalData.ScreenSaver.Wait := True;
  Counter := GetTickCount;
  while not Terminated and PMemFile^.GlobalData.ScreenSaver.Wait and (GetTickCount - Counter <= PMemFile^.Props.ScreenSaver.Delay) do Sleep(MAIN_THREAD_SLEEP_PAUSE);
  if not Terminated and PMemFile^.GlobalData.ScreenSaver.Wait then PostMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amSSRun), 0);
  PMemFile^.GlobalData.ScreenSaver.Wait := False;
end;

{ TRecycleBinThread }

procedure TRecycleBinThread.Execute;
begin
  if SHEmptyRecycleBin(PMemFile^.GlobalData.WndMain, nil, SHERB_NOCONFIRMATION or SHERB_NOSOUND) = S_OK then SendMessage(PMemFile^.GlobalData.WndMain, PM_COMMON, Ord(cmOk), Integer(False))
  else SendMessage(PMemFile^.GlobalData.WndMain, PM_COMMON, Ord(cmCancel), Integer(True));
end;

{ TCheckThread }

procedure TCheckThread.Execute;
 const
   THREAD_SLEEP_PAUSE           = 200;
   THREAD_SEC_ITEM              = 1000 div THREAD_SLEEP_PAUSE;

   NEW_VERSION_POINTS           = 28800; // 8 hours

 var
   Counter, NewVersionCounter, MemoryOptimizerCounter: DWORD;
   PrivPrevState: Boolean;
begin
  CheckThread := Self;

  icsSetPrivilege(SE_DEBUG_NAME, True, PrivPrevState);

  NewVersionCounter := NEW_VERSION_POINTS - 10;
  MemoryOptimizerCounter := 0;

  repeat

    if PMemFile^.Props.CheckNewVersion then begin
      Inc(NewVersionCounter);
      if not Terminated and (NewVersionCounter >= NEW_VERSION_POINTS) then begin
        NewVersionCounter := 0;
        if NewVersionAvailable then PostMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amSystemTrayInfo), Ord(stiNewVersion));
      end;
    end;

    if PMemFile^.Props.MemoryOptimizer.Enabled then begin
      Inc(MemoryOptimizerCounter);
      if not Terminated and (MemoryOptimizerCounter >= PMemFile^.Props.MemoryOptimizer.Interval) then begin
        MemoryOptimizerCounter := 0;
        DoOptimizeMemory;
      end;
    end;

    Counter := 0;
    while not Terminated and (Counter < THREAD_SEC_ITEM) do begin
      Sleep(THREAD_SLEEP_PAUSE);
      Inc(Counter);
    end;

  until Terminated;

  icsSetPrivilege(SE_DEBUG_NAME, PrivPrevState, PrivPrevState);
end;

end.
