unit uNotes;

interface

uses
  Windows, Messages, Classes, ImgList, Menus, Controls, StdCtrls,
  ExtCtrls, Forms, SysUtils, Graphics, Dialogs, StdActns, ActnList,
  uData, uForm, ComCtrls,
  uAPPForm, ICSLanguages, ICSTrayIcon, System.Actions, System.ImageList,
  SynEditHighlighter, SynHighlighterURI, SynEdit, SynURIOpener,
  SynEditMiscClasses, SynEditSearch, SynEditPrint, SynEditOptionsDialog;

type
  TfrmNote = class(TfrmAPPForm)
    PopupMenuNote: TPopupMenu;
    ItemMinimize: TMenuItem;
    N3: TMenuItem;
    ItemPrintNote: TMenuItem;
    ItemDeleteNote: TMenuItem;
    N1: TMenuItem;
    ItemClose: TMenuItem;
    ChImageClose: TImage;
    LabelCaption: TLabel;
    ChImageMin: TImage;
    ChImageMenu: TImage;
    ItemAutoShow: TMenuItem;
    N4: TMenuItem;
    ItemNewNote: TMenuItem;
    N2: TMenuItem;
    ItemWordWrap: TMenuItem;
    PrintDialog1: TPrintDialog;
    ItemDefaultSize: TMenuItem;
    ColorDialog1: TColorDialog;
    ItemColor: TMenuItem;
    ItemStayOnTop: TMenuItem;
    ItemRename: TMenuItem;
    EditCaption: TEdit;
    SaveDialog1: TSaveDialog;
    ItemSaveNote: TMenuItem;
    ImageList1: TImageList;
    N5: TMenuItem;
    FontDialog1: TFontDialog;
    ItemRestore: TMenuItem;
    ItemParams: TMenuItem;
    ItemEdit: TMenuItem;
    ItemCopy: TMenuItem;
    ItemPaste: TMenuItem;
    ItemDelete: TMenuItem;
    ItemCut: TMenuItem;
    N7: TMenuItem;
    ItemSelectAll: TMenuItem;
    N6: TMenuItem;
    ItemUndo: TMenuItem;
    ActionList1: TActionList;
    ItemProtect: TMenuItem;
    ItemEMail: TMenuItem;
    N9: TMenuItem;
    ImageListActions: TImageList;
    ActionEMail: TAction;
    ActionProtect: TAction;
    ActionCancelRename: TAction;
    ActionDefaultSize: TAction;
    ActionColor: TAction;
    ActionAutoShow: TAction;
    ActionWordWrap: TAction;
    ActionStayOnTop: TAction;
    ActionClose: TAction;
    ActionRename: TAction;
    ActionDelete: TAction;
    ActionPrint: TAction;
    ActionSaveTo: TAction;
    ActionMinimize: TAction;
    ActionRestore: TAction;
    ActionNew: TAction;
    EditSelectAll1: TEditSelectAll;
    EditDelete1: TEditDelete;
    EditUndo1: TEditUndo;
    EditPaste1: TEditPaste;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    ItemMinOnDeactivate: TMenuItem;
    ActionMinOnDeactivate: TAction;
    PopupMenuMemo: TPopupMenu;
    ItemUndo2: TMenuItem;
    N11: TMenuItem;
    ItemCut2: TMenuItem;
    ItemCopy2: TMenuItem;
    ItemPaste2: TMenuItem;
    ItemDelete2: TMenuItem;
    N10: TMenuItem;
    ItemSelectAll2: TMenuItem;
    ICSTrayIcon1: TICSTrayIcon;
    N8: TMenuItem;
    SynURISyn1: TSynURISyn;
    SynEditSearch1: TSynEditSearch;
    SynURIOpener1: TSynURIOpener;
    MemoNote: TSynEdit;
    SynEditOptionsDialog1: TSynEditOptionsDialog;
    SynEditPrint1: TSynEditPrint;
    procedure FormResize(Sender: TObject);
    procedure ChImageMenuClick(Sender: TObject);
    procedure PopupMenuNotePopup(Sender: TObject);
    procedure ChImageMenuMouseEnter(Sender: TObject);
    procedure ChImageMenuMouseLeave(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EditCaptionExit(Sender: TObject);
    procedure EditCaptionKeyPress(Sender: TObject; var Key: Char);
    procedure FontDialog1Apply(Sender: TObject; Wnd: HWND);
    procedure ActionNewExecute(Sender: TObject);
    procedure ActionRestoreExecute(Sender: TObject);
    procedure ActionMinimizeExecute(Sender: TObject);
    procedure ActionSaveToExecute(Sender: TObject);
    procedure ActionPrintExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure ActionRenameExecute(Sender: TObject);
    procedure ActionCloseExecute(Sender: TObject);
    procedure ActionStayOnTopExecute(Sender: TObject);
    procedure ActionWordWrapExecute(Sender: TObject);
    procedure ActionAutoShowExecute(Sender: TObject);
    procedure ActionColorExecute(Sender: TObject);
    procedure ActionDefaultSizeExecute(Sender: TObject);
    procedure ChImageMinClick(Sender: TObject);
    procedure ActionCancelRenameExecute(Sender: TObject);
    procedure ActionProtectExecute(Sender: TObject);
    procedure ActionEMailExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure MemoNoteLinkClick(const Value: String);
    procedure ActionMinOnDeactivateExecute(Sender: TObject);
  private
    Id: String;
    Params: TNoteParamsRec;
    PreviousHeight: Integer;
    MinHeight: Integer;
    IsSaveOnClose: Boolean;
    Ico: TIcon;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
    procedure WMNCLButtonDblClk(var Msg: TMessage); message WM_NCLBUTTONDBLCLK;
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure MinimizeHeight;
    procedure NormalizeHeight;
  private
    procedure OnTrayIcon(var Msg: TMessage); message PM_TRAYICON;
    procedure OnAppSetLanguageMsg(var Msg: TMessage); message ICS_SETLANGUAGE_MSG;
  protected
  public
    procedure CreateParams(var Params: TCreateParams); override;
    function GetTitle(Full: Boolean): String;
    procedure SetColor;
    procedure SetFont;
    procedure DeleteNote;
    procedure SaveNote;
    procedure SetStayOnTop(StayOnTop: Boolean);
    procedure RestoreNote;
    procedure OnClose;
    procedure UpdateActions; override;
  end;

procedure ShowNoteFromId(Id: String);
procedure MakeNewNote;
procedure ShowAllNotes(AutoShow: Boolean);
procedure CloseAllNotes(All: Boolean);
function GetOpenNoteCount: Integer;
function GetNoteIdFromPosition(P: Integer): String;

implementation

{$R *.DFM}

uses
  ShellAPI, RichEdit, UITypes,
  uProcs, uWindows, uCProcs, uFormProcs, uCommonTools, uRegistry,
  uRegLite, uVCLTools, uTaskBar;

function TimeStampToString(TS: TTimeStamp): String;
 var
   S: String;
   I: Integer;
begin
  Result := IntToStr(TS.Date);
  S := IntToStr(TS.Time);
  for I := Length(S) to 7 do S := '0' + S;
  Result := Result + S;
end;

function StringToTimeStamp(S: String): TTimeStamp;
begin
  Result.Date := StrToIntDef(Copy(S, 1, Length(S) - 8), 0);
  Result.Time := StrToIntDef(Copy(S, Length(S) - 7, Length(S)), 0);
end;

function GetTimeString: String;
begin
  Result := TimeStampToString(DateTimeToTimeStamp(Now));
end;

function GetDateTimeString(Id: String): String;
begin
  Result := FormatDateTime('dd.mm.yyyy"," hh:mm:ss', TimeStampToDateTime(StringToTimeStamp(Id)));
end;

procedure ShowNote(NP: TNoteParamsRec; NId, NCaption, NText: String);
begin
  with TfrmNote.Create(Application) do begin
    Params := NP;
    PreviousHeight := Params.Height;
    Id := NId;
    Caption := NCaption;
    MemoNote.WordWrap := Params.WordWrap;

    MemoNote.Text := NText;

    LabelCaption.Caption := GetTitle(False);
    SetBounds(Params.Left, Params.Top, Params.Width, Params.Height);
    SetStayOnTop(Params.StayOnTop);
    AlphaBlendValue := icsGetLayerAlpha(Params.Transparency);
    AlphaBlend := (AlphaBlendValue < 255);
    SetColor;
    SetFont;
    Show;
  end;
end;

procedure ShowNoteFromId(Id: String);
 var
   I: Integer;
   NP: TNoteParamsRec;
   NCaption, NText: String;
   R: TRect;
begin
  for I := 0 to Screen.FormCount - 1 do if (Screen.Forms[I] is TfrmNote) and ((Screen.Forms[I] as TfrmNote).Id = Id) then begin
    (Screen.Forms[I] as TfrmNote).RestoreNote;
    (Screen.Forms[I] as TfrmNote).Show;
    Exit;
  end;

  NP := PMemFile^.Props.Note.DefaultParams;

  FillChar(R, SizeOf(TRect), 0);
  if not SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0) then begin
    R.Right := Screen.WorkAreaWidth;
    R.Bottom := Screen.WorkAreaHeight;
  end;

  NP.Left := R.Left + Random(R.Right - R.Left - NP.Width - 1) + 1;
  NP.Top := R.Top + Random(R.Bottom - R.Top - NP.Height - 1) + 1;
  NCaption := GetDateTimeString(Id);
  NText := '';

  if RegKeyExists(HKEY_CURRENT_USER, REG_NOTES_KEY + '\' + Id) then begin
    RegGetBinary(HKEY_CURRENT_USER, REG_NOTES_KEY + '\' + Id, 'Params', @NP, SizeOf(NP));
    NCaption := RegGetString(HKEY_CURRENT_USER, REG_NOTES_KEY + '\' + Id, 'Caption');
    NText := RegGetString(HKEY_CURRENT_USER, REG_NOTES_KEY + '\' + Id, 'Text');
  end;

  ShowNote(NP, Id, NCaption, NText);
end;

procedure MakeNewNote;
begin
  ShowNoteFromId(GetTimeString);
end;

procedure ShowAllNotes(AutoShow: Boolean);
 var
   SL: TStringList;
   I: Integer;
   B: Boolean;
   NP: TNoteParamsRec;
begin
  SL := TStringList.Create;
  try
    RegGetSubKeyNames(HKEY_CURRENT_USER, REG_NOTES_KEY, SL, False);
    for I := 0 to SL.Count - 1 do begin
      B := not AutoShow;
      if not B then begin
        NP := GetNoteParams(SL[I]);
        B := NP.AutoShow;
      end;
      if B then ShowNoteFromId(SL[I]);
    end;
  finally
    SL.Free;
  end;
end;

procedure CloseAllNotes(All: Boolean);
 var
   I: Integer;
   B: Boolean;
begin
  for I := 0 to Screen.FormCount - 1 do if Screen.Forms[I] is TfrmNote then begin
    B := All;
    if not B then B := not (Screen.Forms[I] as TfrmNote).Params.Protect;
    if B then Screen.Forms[I].Close;
  end;
end;

function GetOpenNoteCount: Integer;
 var I: Integer;
begin
  Result := 0;
  for I := 0 to Screen.FormCount - 1 do if Screen.Forms[I] is TfrmNote then Inc(Result);
end;

function GetNoteIdFromPosition(P: Integer): String;
 var
   A: TStringArray;
   I :Integer;
begin
  Result := '';
  A := GetNotesArray;
  for I := 0 to High(A) do if I >= P then begin
    Result := A[I];
    Break;
  end;
end;

// ************************************

procedure TfrmNote.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW;
end;

procedure TfrmNote.FormCreate(Sender: TObject);
begin
  inherited;
  PreviousHeight := 0;
  MinHeight := LabelCaption.Height + LabelCaption.Top * 2;
  MemoNote.SetBounds(4, MinHeight, MemoNote.Width, MemoNote.Height);
  Ico := TIcon.Create;
  ImageList1.GetIcon(0, Ico);
  ChImageMenu.Picture.Icon.Assign(Ico);
  ImageList1.GetIcon(1, Ico);
  ChImageMin.Picture.Icon.Assign(Ico);
  ImageList1.GetIcon(2, Ico);
  ChImageClose.Picture.Icon.Assign(Ico);
  DoubleBuffered := True;
  IsSaveOnClose := False;
end;

procedure TfrmNote.FormShow(Sender: TObject);
begin
  inherited;
  FormResize(Sender);
  DragAcceptFiles(Handle, True);
end;

procedure TfrmNote.WMNCHitTest(var Msg: TWMNCHitTest);
 const Corner = 10;
 var P, WP: TPoint;
begin
  inherited;
  WP.x := Msg.XPos;
  WP.y := Msg.YPos;
  P := LabelCaption.ScreenToClient(WP);
  if (P.x >= 0) and (P.x <= LabelCaption.Width) and (P.y >= 0) and (P.y <= LabelCaption.Height) then Msg.Result := HTCAPTION else begin
    P := ScreenToClient(WP);
    if P.y >= ChImageMenu.Top + ChImageMenu.Height then begin
      if (P.x >= 0) and (P.x <= MemoNote.Left) then Msg.Result := HTLEFT;
      if (P.x >= Width - MemoNote.Left) and (P.x <= Width) then Msg.Result := HTRIGHT;
      if (P.y >= Height - MemoNote.Left) and (P.y <= Height) then Msg.Result := HTBOTTOM;
      if (P.x >= 0) and (P.x <= Corner) and (P.y <= Height) and (P.y >= Height - Corner) then Msg.Result := HTBOTTOMLEFT;
      if (P.x <= Width) and (P.x >= Width - Corner) and (P.y <= Height) and (P.y >= Height - Corner) then Msg.Result := HTBOTTOMRIGHT;
      if (P.x >= ChImageMin.Left) and (P.x <= ChImageMin.Left + ChImageMin.Width) and (P.y >= ChImageMin.Top) and (P.y <= ChImageMin.Top + ChImageMin.Height) then Msg.Result := HTMINBUTTON;
    end;
  end;
end;

procedure TfrmNote.WMActivate(var Msg: TWMActivate);
begin
  inherited;
  if Visible then begin
    MemoNote.SetFocus;
    if Msg.Active <> WA_INACTIVE then begin
      LabelCaption.Font.Style := LabelCaption.Font.Style + [fsUnderline];
      if Params.Autoheight then NormalizeHeight;
    end else begin
      LabelCaption.Font.Style := LabelCaption.Font.Style - [fsUnderline];
      SaveNote;
      if Params.Autoheight then MinimizeHeight;
    end;
  end;
end;

procedure TfrmNote.FormResize(Sender: TObject);
begin
  inherited;
  ChImageClose.Left := Width - ChImageClose.Width - ChImageMenu.Left;
  ChImageMin.Left := ChImageClose.Left - ChImageMin.Width - 2;
  LabelCaption.Width := ChImageMin.Left - 2 - LabelCaption.Left;
  EditCaption.SetBounds(LabelCaption.Left, LabelCaption.Top, LabelCaption.Width, LabelCaption.Height);
  MemoNote.SetBounds(MemoNote.Left, MemoNote.Top, ClientWidth - MemoNote.Left * 2, ClientHeight - MemoNote.Top - MemoNote.Left);
  LabelCaption.Caption := GetTitle(False);
  Params.Width := Width;
  Params.Height := Height;
end;

procedure TfrmNote.ChImageMenuMouseEnter(Sender: TObject);
begin
  inherited;
  case (Sender as TImage).Tag of
    0: ImageList1.GetIcon(3, Ico);
    3: ImageList1.GetIcon(4, Ico);
    26: ImageList1.GetIcon(5, Ico);
  end;
 (Sender as TImage).Picture.Icon.Assign(Ico);
end;

procedure TfrmNote.ChImageMenuMouseLeave(Sender: TObject);
begin
  inherited;
  case (Sender as TImage).Tag of
    0: ImageList1.GetIcon(0, Ico);
    3: ImageList1.GetIcon(1, Ico);
    26: ImageList1.GetIcon(2, Ico);
  end;
 (Sender as TImage).Picture.Icon.Assign(Ico);
end;

function ProgFontStylesToVCLFontStyle(FS: TProgFontStyles): TFontStyles;
begin
  Result := [];
  if FS.Bold then Include(Result, fsBold);
  if FS.Italic then Include(Result, fsItalic);
  if FS.Underline then Include(Result, fsUnderline);
  if FS.StrikeOut then Include(Result, fsStrikeOut);
end;

procedure SetFont(F: TFont; PF: TProgFont);
begin
  F.Color := PF.Color;
  F.Size := PF.Size;
  F.Name := PF.Name;
  F.Style := [];
  if PF.Style.Bold then F.Style := F.Style + [fsBold];
  if PF.Style.Italic then F.Style := F.Style + [fsItalic];
  if PF.Style.Underline then F.Style := F.Style + [fsUnderline];
  if PF.Style.StrikeOut then F.Style := F.Style + [fsStrikeOut];
  F.Charset := PF.CharSet;
end;

procedure TfrmNote.ChImageMenuClick(Sender: TObject);
 var P: TPoint;
begin
  if ActiveControl <> MemoNote then MemoNote.SetFocus;
  P.x := ChImageMenu.Left;
  P.y := ChImageMenu.Top + ChImageMenu.Height;
  P := ClientToScreen(P);
  PopupMenuNote.Popup(P.x, P.y);
  GetCursorPos(P);
  P := ChImageMenu.ScreenToClient(P);
  if not ((P.x >= 0) and (P.x <= ChImageMenu.Width) and (P.y >= 0) and (P.y <= ChImageMenu.Height)) then ChImageMenu.Perform(CM_MOUSELEAVE, 0, 0);
end;

procedure TfrmNote.PopupMenuNotePopup(Sender: TObject);
begin
  if not Visible then UpdateActions;
end;

procedure TfrmNote.DeleteNote;
begin
  MemoNote.Lines.Clear;
  Close;
end;

function TfrmNote.GetTitle(Full: Boolean): String;
begin
  Result := Caption;
  if not Full and (LabelCaption.Canvas.TextWidth(Result) >= LabelCaption.Width) then begin
    while (LabelCaption.Canvas.TextWidth(Result + '...') >= LabelCaption.Width) and (Length(Result) > 0) do Result := Copy(Result, 1, Length(Result) - 1);
    Result := Result + '...';
  end;
end;

function LPad(S: String; Len: Integer; Ch: Char): String;
begin
  Result := S;
  while Length(Result) < Len do Result := Ch + Result;
end;

procedure TfrmNote.WMDropFiles(var Msg: TMessage);
 var FName: String;
begin
  inherited;
  if DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 0) > 0 then begin
    SetLength(FName, DragQueryFile(Msg.WParam, 0, nil, 0) + 1);
    if DragQueryFile(Msg.WParam, 0, PChar(FName), Length(FName)) > 0 then begin
      if MemoNote.Lines.Count = 0 then begin
        Caption := ExtractFileName(FName);
        LabelCaption.Caption := GetTitle(False);
      end;
      MemoNote.WordWrap := False;
      MemoNote.Lines.LoadFromFile(FName);
      MemoNote.WordWrap := Params.WordWrap;
    end;
  end;
  DragFinish(Msg.WParam);
end;

procedure TfrmNote.WMNCLButtonDblClk(var Msg: TMessage);
begin
  inherited;
  if (Msg.WParam = HTCAPTION) and not Params.Autoheight then begin
    if ClientHeight <= MinHeight then NormalizeHeight else MinimizeHeight;
  end;
end;

procedure TfrmNote.MinimizeHeight;
begin
  PreviousHeight := ClientHeight;
  ClientHeight := MinHeight;
end;

procedure TfrmNote.NormalizeHeight;
begin
  if PreviousHeight <= MinHeight then PreviousHeight := PMemFile^.Props.Note.DefaultParams.Height;
  ClientHeight := PreviousHeight;
end;

procedure TfrmNote.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  inherited;
  if Visible then begin
    Msg.MinMaxInfo^.ptMinTrackSize.x := 100;
    Msg.MinMaxInfo^.ptMinTrackSize.y := LabelCaption.Height + LabelCaption.Top * 2;
  end;
end;

procedure TfrmNote.SetColor;
begin
  MemoNote.Color := Params.Color;
  Color := GetDarkColor(Params.Color, 30);
  MemoNote.Gutter.Color := Color;
end;

procedure TfrmNote.SetFont;
begin
  if MemoNote.Lines.Text = '' then SetVCLFontFromProgFont(MemoNote.Font, Params.Font);
  Font.Charset := Params.Font.CharSet;
  LabelCaption.Font.Charset := Params.Font.CharSet;
  EditCaption.Font.Charset := Params.Font.CharSet;
end;

procedure TfrmNote.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if ActiveControl = EditCaption then begin
    if Key = #27 then ActionCancelRename.Execute;
    if Key = #13 then begin
      if EditCaption.Text = '' then EditCaption.Text := '#';
      MemoNote.SetFocus;
    end;
  end;
end;

procedure TfrmNote.EditCaptionExit(Sender: TObject);
begin
  inherited;
  EditCaption.Visible := False;
  EditCaption.Text := Trim(EditCaption.Text);
  if EditCaption.Text = '#' then EditCaption.Text := GetDateTimeString(Id);
  if EditCaption.Text <> '' then Caption := EditCaption.Text;
  LabelCaption.Caption := GetTitle(False);
  SaveNote;
  MemoNote.SetFocus;
end;

procedure TfrmNote.EditCaptionKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if CharInSet(Key, [#13, #27]) then Key := #0;
end;

procedure TfrmNote.WMSysCommand(var Msg: TWMSysCommand);
begin
  inherited;
  if Msg.CmdType = SC_KEYMENU then begin
    ChImageMenuMouseEnter(ChImageMenu);
    ChImageMenuClick(nil);
  end;
end;

procedure TfrmNote.SaveNote;
begin
  RegSetBinary(HKEY_CURRENT_USER, REG_NOTES_KEY + '\' + Id, 'Params', @Params, SizeOf(TNoteParamsRec));
  RegSetString(HKEY_CURRENT_USER, REG_NOTES_KEY + '\' + Id, 'Caption', Caption);
  if MemoNote.Modified then RegSetString(HKEY_CURRENT_USER, REG_NOTES_KEY + '\' + Id, 'Text', MemoNote.Text);
end;

procedure TfrmNote.FontDialog1Apply(Sender: TObject; Wnd: HWND);
begin
  inherited;
  Params.Font := VCLFontToProgFont(FontDialog1.Font);
  SetFont;
end;

procedure TfrmNote.SetStayOnTop(StayOnTop: Boolean);
begin
  if StayOnTop then begin
    SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TOPMOST);
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSENDCHANGING or SWP_NOSIZE);
  end else begin
    SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) and not WS_EX_TOPMOST);
    SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSENDCHANGING or SWP_NOSIZE);
  end;
end;

procedure TfrmNote.ActionNewExecute(Sender: TObject);
begin
  inherited;
  MakeNewNote;
end;

procedure TfrmNote.ActionRestoreExecute(Sender: TObject);
begin
  inherited;
  TaskBarDeleteIcon(Handle);
  Visible := True;
  SetForegroundWindow(Handle);
end;

procedure TfrmNote.ActionMinimizeExecute(Sender: TObject);
 var I: Integer;
begin
  inherited;
  ActionCancelRename.Execute;
  Visible := False;
  TaskBarAddIcon(Handle, Handle, Icon.Handle, PM_TRAYICON, PChar(String(Caption)));
  for I := 0 to Screen.FormCount - 1 do if (Screen.Forms[I] is TfrmNote) and Screen.Forms[I].Visible then begin
    SetForegroundWindow(Screen.Forms[I].Handle);
    Break;
  end;
  UpdateActions;
end;

procedure TfrmNote.ActionSaveToExecute(Sender: TObject);
 const BadChars = ';,=+<>|"[]:\ ';
 var
   I: Integer;
   S: String;
   B: Boolean;
begin
  inherited;
  B := Params.Autoheight;
  Params.Autoheight := False;
  SetStayOnTop(False);
  try
    SaveDialog1.InitialDir := GetProgPath;
    S := Caption;
    for I := 1 to Length(BadChars) do S := icsGetReplacedString(S, BadChars[I], '-');
    if ExtractFileExt(S) <> SaveDialog1.DefaultExt then S := S + SaveDialog1.DefaultExt;
    SaveDialog1.FileName := S;
    if SaveDialog1.Execute then MemoNote.Lines.SaveToFile(SaveDialog1.FileName);
  finally
    SetStayOnTop(Params.StayOnTop);
    Params.Autoheight := B;
  end;
end;

procedure TfrmNote.ActionPrintExecute(Sender: TObject);
 var B: Boolean;
begin
  inherited;
  B := Params.Autoheight;
  Params.Autoheight := False;
  SetStayOnTop(False);
  try
    if PrintDialog1.Execute(Handle) then begin
      SynEditPrint1.SynEdit := MemoNote;
      SynEditPrint1.Print;
    end;
  finally
    SetStayOnTop(Params.StayOnTop);
    Params.Autoheight := B;
  end;
end;

procedure TfrmNote.ActionDeleteExecute(Sender: TObject);
 var B: Boolean;
begin
  inherited;
  B := Params.Autoheight;
  Params.Autoheight := False;
  if MessageBoxW(Handle, PWChar(ICSLanguages1.CurrentStrings[27]), PROG_NAME, MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) = IdYes then DeleteNote else Params.Autoheight := B;
end;

procedure TfrmNote.ActionRenameExecute(Sender: TObject);
begin
  inherited;
  EditCaption.Text := GetTitle(True);
  EditCaption.Visible := True;
  EditCaption.SetFocus;
end;

procedure TfrmNote.ActionCloseExecute(Sender: TObject);
begin
  inherited;
  OnClose;
  Close;
end;

procedure TfrmNote.ActionStayOnTopExecute(Sender: TObject);
begin
  inherited;
  Params.StayOnTop := not Params.StayOnTop;
  SetStayOnTop(Params.StayOnTop);
end;

procedure TfrmNote.ActionWordWrapExecute(Sender: TObject);
begin
  inherited;
  Params.WordWrap := not Params.WordWrap;
  MemoNote.WordWrap := Params.WordWrap;
end;

procedure TfrmNote.ActionAutoShowExecute(Sender: TObject);
begin
  inherited;
  Params.AutoShow := not Params.AutoShow;
end;

procedure TfrmNote.ActionColorExecute(Sender: TObject);
 var B: Boolean;
begin
  inherited;
  B := Params.Autoheight;
  Params.Autoheight := False;
  SetStayOnTop(False);
  try
    ColorDialog1.Color := MemoNote.Color;
    if ColorDialog1.Execute then begin
      Params.Color := ColorDialog1.Color;
      SetColor;
    end;
  finally
    SetStayOnTop(Params.StayOnTop);
    Params.Autoheight := B;
  end;
end;

procedure TfrmNote.ActionDefaultSizeExecute(Sender: TObject);
begin
  inherited;
  PMemFile^.Props.Note.DefaultParams.Width := Width;
  PMemFile^.Props.Note.DefaultParams.Height := Height;
  PostMessage(PMemFile^.GlobalData.WndMain, PM_COMMON, Ord(cmOk), Integer(True));
end;

procedure TfrmNote.ChImageMinClick(Sender: TObject);
begin
  inherited;
  if ActiveControl = EditCaption then ActionCancelRename.Execute;
  ActionMinimize.Execute;
end;

procedure TfrmNote.ActionCancelRenameExecute(Sender: TObject);
begin
  inherited;
  if ActiveControl = EditCaption then begin
    EditCaption.Text := '';
    MemoNote.SetFocus;
  end;
end;

procedure TfrmNote.RestoreNote;
begin
  ActionRestore.Execute;
end;

procedure TfrmNote.ActionProtectExecute(Sender: TObject);
begin
  inherited;
  Params.Protect := not Params.Protect;
end;

procedure TfrmNote.ActionEMailExecute(Sender: TObject);
 const MAX_URL_LENGTH = 2019;
 var S: String;
begin
  inherited;
  S := 'mailto:' + '?subject=' + icsURLEncode(String(Caption), False) + '&Body=' + icsURLEncode(String(MemoNote.Lines.Text), False);
  if Length(S) > MAX_URL_LENGTH then SetLength(S, MAX_URL_LENGTH);
  if ShellExecute(Handle, nil, PChar(S), nil, nil, SW_SHOWNORMAL) > 32 then PostMessage(PMemFile^.GlobalData.WndMain, PM_COMMON, Ord(cmOk), Integer(True)) else PostMessage(PMemFile^.GlobalData.WndMain, PM_COMMON, Ord(cmCancel), Integer(True));
end;

procedure TfrmNote.OnClose;
begin
  if Visible then begin
    Params.Left := Left;;
    Params.Top := Top;
  end;
  if not IsSaveOnClose then begin
    IsSaveOnClose := True;
    if MemoNote.Lines.Text = '' then RegDeleteKey(HKEY_CURRENT_USER, PChar(REG_NOTES_KEY + '\' + Id)) else SaveNote;
  end;
  TaskBarDeleteIcon(Handle);
end;

procedure TfrmNote.UpdateActions;
begin
  inherited;
  ActionPrint.Enabled := Visible and (Length(Trim(MemoNote.Lines.Text)) > 0);
  ActionEMail.Enabled := ActionPrint.Enabled;
  ActionSaveTo.Enabled := ActionPrint.Enabled;
  ActionAutoShow.Checked := Params.AutoShow;
  ActionWordWrap.Checked := MemoNote.WordWrap;
  ActionStayOnTop.Checked := Params.StayOnTop;
  ActionProtect.Checked := Params.Protect;
  ActionRestore.Enabled := not Visible;
  ActionMinimize.Enabled := Visible;
  ActionRename.Enabled := Visible;
  ActionRestore.Enabled := not Visible;
  ActionMinimize.Enabled := Visible;
  ActionMinOnDeactivate.Checked := Params.Autoheight;
  ActionDelete.Enabled := (MemoNote.Lines.Text <> '');

  ItemEdit.Enabled := Visible;
  ItemParams.Enabled := Visible;
  if Visible then ItemClose.Default := True else ItemRestore.Default := True;
end;

procedure TfrmNote.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  OnClose;
  inherited;
end;

procedure TfrmNote.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  OnClose;
  inherited;
end;

procedure TfrmNote.FormDestroy(Sender: TObject);
begin
  Ico.Free;
  inherited;
end;

procedure TfrmNote.TrayIcon1Click(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  ActionRestore.Execute;
end;

procedure TfrmNote.OnTrayIcon(var Msg: TMessage);
 var P: TPoint;
begin
  case Msg.lParam of
    WM_LBUTTONUP: ActionRestore.Execute;
    WM_RBUTTONDOWN: begin
      SetForegroundWindow(Handle);
      GetCursorPos(P);
      PopupMenuNote.Popup(P.X, P.Y);
      PostMessage(Handle, WM_NULL, 0, 0);
    end;
  end;
end;

procedure TfrmNote.OnAppSetLanguageMsg(var Msg: TMessage);
begin
  inherited;
  EditCut1.Caption := ICSLanguages1.CurrentStrings[EditCut1.Tag];
  EditCopy1.Caption := ICSLanguages1.CurrentStrings[EditCopy1.Tag];
  EditPaste1.Caption := ICSLanguages1.CurrentStrings[EditPaste1.Tag];
  EditSelectAll1.Caption := ICSLanguages1.CurrentStrings[EditSelectAll1.Tag];
  EditUndo1.Caption := ICSLanguages1.CurrentStrings[EditUndo1.Tag];
  EditDelete1.Caption := ICSLanguages1.CurrentStrings[EditDelete1.Tag];
end;

procedure TfrmNote.MemoNoteLinkClick(const Value: String);
begin
  inherited;
  ShellExecuteW(Handle, nil, PWChar(Value), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmNote.ActionMinOnDeactivateExecute(Sender: TObject);
begin
  inherited;
  Params.Autoheight := not Params.Autoheight;
end;

end.

