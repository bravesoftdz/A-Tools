unit uTools;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  uAPPForm, ICSLanguages, ComCtrls, ToolWin,
  uForm, Menus, ActnList, ImgList,
  StdCtrls, Buttons, ExtCtrls, uData, System.Actions,
  System.ImageList, PngImageList;

type
  TfrmTools = class(TfrmAPPForm)
    ActionList1: TActionList;
    ActionNewNote: TAction;
    MenuNotes: TPopupMenu;
    ActionSSEnableDisable: TAction;
    ActionEmptyClipboard: TAction;
    ActionEmptyRB: TAction;
    ActionScreenInfo: TAction;
    MenuProcesses: TPopupMenu;
    ActionESShutdown: TAction;
    MenuEndSession: TPopupMenu;
    ActionESReboot: TAction;
    ActionESHibernate: TAction;
    ActionESStandby: TAction;
    ICSImageListProcesses: TPngImageList;
    ItemNDeleteUnprotected: TMenuItem;
    ICSImageListMain: TImageList;
    ActionESLogoff: TAction;
    ActionNShowAll: TAction;
    ActionNCloseAll: TAction;
    ActionNDeleteUnprotected: TAction;
    ItemESLogoff: TMenuItem;
    N10: TMenuItem;
    ItemESStandby: TMenuItem;
    ItemESHibernate: TMenuItem;
    ItemESReboot: TMenuItem;
    ItemESShutdown: TMenuItem;
    ActionEndSession: TAction;
    ToolBar1: TToolBar;
    btnNotes: TToolButton;
    ToolButton10: TToolButton;
    btnSSDisable: TToolButton;
    ToolButton1: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton11: TToolButton;
    ToolButton7: TToolButton;
    btnTerminate: TToolButton;
    ToolButton50: TToolButton;
    ToolButton60: TToolButton;
    ToolButton30: TToolButton;
    ToolButton2: TToolButton;
    Timer1: TTimer;
    ToolButton3: TToolButton;
    ToolButton13: TToolButton;
    ToolButtonHold: TToolButton;
    ActionHold: TAction;
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuProcessesPopup(Sender: TObject);
    procedure MenuNotesPopup(Sender: TObject);
    procedure ActionNewNoteExecute(Sender: TObject);
    procedure ActionSSEnableDisableExecute(Sender: TObject);
    procedure ActionEmptyClipboardExecute(Sender: TObject);
    procedure ActionEmptyRBExecute(Sender: TObject);
    procedure ActionScreenInfoExecute(Sender: TObject);
    procedure ActionESShutdownExecute(Sender: TObject);
    procedure ActionESRebootExecute(Sender: TObject);
    procedure ActionESHibernateExecute(Sender: TObject);
    procedure ActionESStandbyExecute(Sender: TObject);
    procedure ActionESLogoffExecute(Sender: TObject);
    procedure ActionEndSessionExecute(Sender: TObject);
    procedure ActionNShowAllExecute(Sender: TObject);
    procedure ActionNCloseAllExecute(Sender: TObject);
    procedure ActionNDeleteUnprotectedExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActionEmptyClipboardUpdate(Sender: TObject);
    procedure ActionEmptyRBUpdate(Sender: TObject);
    procedure ActionCopyDisksUpdate(Sender: TObject);
    procedure ActionESHibernateUpdate(Sender: TObject);
    procedure ActionESStandbyUpdate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ActionNCloseAllUpdate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActionHoldExecute(Sender: TObject);
    procedure ActionTerminateUpdate(Sender: TObject);
  private
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
  private
    procedure OnAppSetLanguageMsg(var Msg: TMessage); message ICS_SETLANGUAGE_MSG;
  private
    procedure OnProcessTerminateClick(Sender: TObject);
    procedure OnNoteClick(Sender: TObject);
  end;

var
  frmTools: TfrmTools = nil;

implementation

{$R *.dfm}

uses
  uProcesses, uCommonTools, uProcs, uRegLite, uWindows,
  uNotes;

procedure TfrmTools.FormDestroy(Sender: TObject);
begin
  inherited;
  frmTools := nil;
end;

procedure TfrmTools.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfrmTools.WMActivate(var Msg: TWMActivate);
begin
  inherited;
  if Visible and not ActionHold.Checked and (Msg.Active = WA_INACTIVE) then Close;
end;

procedure TfrmTools.MenuProcessesPopup(Sender: TObject);
 var
   Ico: TIcon;
   I: Integer;
   MI: TMenuItem;
begin
  inherited;
  MenuProcesses.Items.Clear;
  ICSImageListProcesses.Clear;
  Ico := TIcon.Create;
  Ico.Transparent := True;
  try
    if ProcessRefresh(False, False) then for I := 0 to ProcessList.Count - 1 do if (ProcessList.Processes[I].FileName <> '') and (ProcessList.Processes[I].FileName[1] <> '\') then begin
      MI := TMenuItem.Create(Self);
      MI.Caption := ProcessList.Processes[I].FileName;
      MI.Tag := ProcessList.Processes[I].Id;

      Ico.Handle := GetIconHandleFromFileName(ProcessList.Processes[I].FileName);
      MI.ImageIndex := ICSImageListProcesses.AddIcon(Ico);
      DestroyIcon(Ico.Handle);

      MI.OnClick := OnProcessTerminateClick;
      MenuProcesses.Items.Add(MI);
    end;
  finally
    Ico.Free;
  end;
end;

procedure TfrmTools.OnProcessTerminateClick(Sender: TObject);
begin
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amTerminateProcessFromId), (Sender as TComponent).Tag);
end;

procedure TfrmTools.MenuNotesPopup(Sender: TObject);
 var
   I: Integer;
   A: TStringArray;
   MI: TMenuItem;
begin
  inherited;
  for I := MenuNotes.Items.Count - 1 downto 0 do if MenuNotes.Items[I].Hint <> '' then MenuNotes.Items.Delete(I);
  A := GetNotesArray;
  if Length(A) > 0 then begin
    MenuNotes.Items.NewTopLine;
    for I := 0 to High(A) do begin
      MI := TMenuItem.Create(Self);
      MI.Hint := A[I];
      MI.Caption := RegGetString(HKEY_CURRENT_USER, REG_NOTES_KEY + '\' + A[I], 'Caption');
      if GetNoteParams(A[I]).Protect then MI.ImageIndex := 13;
      MI.OnClick := OnNoteClick;
      MenuNotes.Items.Insert(I, MI);
    end;
  end;
  ActionNDeleteUnprotected.Visible := (Length(A) > 0);
end;

procedure TfrmTools.ActionNewNoteExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amNewNote), 0);
end;

procedure TfrmTools.OnNoteClick(Sender: TObject);
begin
  ShowNoteFromId((Sender as TMenuItem).Hint);
end;

procedure TfrmTools.ActionSSEnableDisableExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amSSEnableDisable), 0);
end;

procedure TfrmTools.ActionTerminateUpdate(Sender: TObject);
begin
  inherited;
  (Sender as TAction).Enabled := True;
end;

procedure TfrmTools.ActionEmptyClipboardExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amEmptyClipboard), 0);
end;

procedure TfrmTools.ActionEmptyRBExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amEmptyRecycleBin), 0);
end;

procedure TfrmTools.ActionScreenInfoExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amScreenInfo), 0);
end;

procedure TfrmTools.ActionESShutdownExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amEndSession), Ord(esaShutdown));
end;

procedure TfrmTools.ActionESRebootExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amEndSession), Ord(esaReboot));
end;

procedure TfrmTools.ActionESHibernateExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amEndSession), Ord(esaHibernate));
end;

procedure TfrmTools.ActionESStandbyExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amEndSession), Ord(esaStandby));
end;

procedure TfrmTools.ActionESLogoffExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amEndSession), Ord(esaLogoff));
end;

procedure TfrmTools.ActionEndSessionExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amEndSession), Ord(esaFromProps));
end;

procedure TfrmTools.ActionNShowAllExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amShowAllNotes), 0);
end;

procedure TfrmTools.ActionNCloseAllExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amCloseAllNotes), 0);
end;

procedure TfrmTools.ActionNDeleteUnprotectedExecute(Sender: TObject);
begin
  inherited;
  SendMessage(PMemFile^.GlobalData.WndMain, PM_ACTION, Ord(amDeleteUnprotectedNotes), 0);
end;

procedure TfrmTools.FormShow(Sender: TObject);
begin
//  ClientWidth := Separator1.Left + Separator1.Width;
  ClientWidth := ToolButtonHold.Left + ToolButtonHold.Width;
  ClientHeight := ToolBar1.Height;
  inherited;
  AlignToSystemTray := True;
  Timer1Timer(Sender);
end;

procedure TfrmTools.OnAppSetLanguageMsg(var Msg: TMessage);
 var I: Integer;
begin
  inherited;
  ItemESLogoff.Caption := ItemESLogoff.Caption + ' ' + icsGetCurrentUserName;
  for I := 0 to ToolBar1.ControlCount - 1 do if (ToolBar1.Controls[I] is TToolButton) and Assigned((ToolBar1.Controls[I] as TToolButton).Action) then (ToolBar1.Controls[I] as TToolButton).Hint := TAction((ToolBar1.Controls[I] as TToolButton).Action).Caption;
  ToolBar1.BorderWidth := 1;
end;

procedure TfrmTools.ActionEmptyClipboardUpdate(Sender: TObject);
begin
  inherited;
  (Sender as TAction).Enabled := not icsIsClipboardEmpty(Handle);
end;

procedure TfrmTools.ActionEmptyRBUpdate(Sender: TObject);
begin
  inherited;
  (Sender as TAction).Enabled := (icsGetRecycleBinItemCount > 0);
end;

procedure TfrmTools.ActionCopyDisksUpdate(Sender: TObject);
begin
  inherited;
  (Sender as TAction).Enabled := not PMemFile^.GlobalData.DiskOperationInProgress;
end;

procedure TfrmTools.ActionESHibernateUpdate(Sender: TObject);
begin
  inherited;
  (Sender as TAction).Enabled := IsPwrHibernateAllowed;
end;

procedure TfrmTools.ActionESStandbyUpdate(Sender: TObject);
begin
  inherited;
  (Sender as TAction).Enabled := IsPwrSuspendAllowed;
end;

procedure TfrmTools.Timer1Timer(Sender: TObject);
 var I: Integer;
begin
  inherited;
  for I := 0 to ActionList1.ActionCount - 1 do ActionList1.Actions[I].Update;
end;

procedure TfrmTools.ActionNCloseAllUpdate(Sender: TObject);
begin
  inherited;
  (Sender as TAction).Enabled := (GetOpenNoteCount > 0);
end;

procedure TfrmTools.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift = []) and (Key = VK_ESCAPE) then Close;
end;

procedure TfrmTools.ActionHoldExecute(Sender: TObject);
begin
  inherited;
  (Sender as TAction).Checked := not (Sender as TAction).Checked;
end;

end.
