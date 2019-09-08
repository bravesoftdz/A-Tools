program atools;

{$R 'at_resources.res' 'at_resources.rc'}

uses
  Forms,
  Windows,
  Messages,
  SysUtils,
  uRegLite,
  uMain in 'uMain.pas' {frmMain},
  uAPPForm in 'uAPPForm.pas' {frmAPPForm},
  uProps in 'uProps.pas' {frmProps},
  uScreenInfo in 'uScreenInfo.pas' {frmScreenInfo},
  uNotes in 'uNotes.pas' {frmNote},
  uRuler in 'uRuler.pas' {frmRuler},
  uCProcs in 'uCProcs.pas',
  uData in 'uData.pas',
  uFormProcs in 'uFormProcs.pas',
  uThreads in 'uThreads.pas',
  uProcs in 'uProcs.pas',
  uForm in 'P:\Repository\uForm.pas' {frmForm},
  uTools in 'uTools.pas' {frmTools};

{$R *.RES}
{$R Resources\XPIcons.res}

procedure PostInstallProg;
begin
  SetWindowsStartup(True);
  SaveProps(GetProps);
end;

procedure ShutdownProg;
begin
  if IsWindow(PMemFile^.GlobalData.WndMain) then SendMessage(PMemFile^.GlobalData.WndMain, WM_SYSCOMMAND, SC_CLOSE, 0);
end;

procedure PreUninstallProg;
begin
  ShutdownProg;
  SetWindowsStartup(False);
end;

var
  H: THandle;

begin
  if CreateOrOpenSharedFile then try
    if ParamStr(1) = PARAM_INSTALL then PostInstallProg
    else if ParamStr(1) = PARAM_UNINSTALL then PreUninstallProg
    else if ParamStr(1) = PARAM_SHUTDOWN then ShutdownProg
    else begin
      H := CreateMutex(nil, True, PROG_CLSID);
      if GetLastError = 0 then try
        Randomize;
        RegSetString(HKEY_LOCAL_MACHINE, REG_APP_KEY, '', ExtractFilePath(ParamStr(0)));
//        ICSCurrentLanguageString := RegGetString(HKEY_LOCAL_MACHINE, REG_APP_KEY, REG_LANGUAGE_VALUE);
        SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  Application.Title := 'A-Tools';
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

      finally
        ReleaseMutex(H);
      end else begin
        SetForegroundWindow(PMemFile.GlobalData.WndMain);
      end;
    end;
  finally
    CloseSharedFile;
  end;
end.
