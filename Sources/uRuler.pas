unit uRuler;

interface

uses
  Windows, Messages, Controls, Classes, ExtCtrls,
  Graphics, Forms, StdCtrls, SysUtils,
  uForm, uAPPForm, ICSLanguages;

type
  TfrmRuler = class(TfrmAPPForm)
    ShapeLeftTop: TShape;
    ShapeRightTop: TShape;
    ShapeLeftCenter: TShape;
    ShapeRightBottom: TShape;
    ShapeTopCenter: TShape;
    ShapeLeftBottom: TShape;
    ShapeBottomCenter: TShape;
    ShapeRightCenter: TShape;
    ImageCenter: TImage;
    ShapeMain: TShape;
    ImageBlack: TImage;
    ImageWhite: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    procedure OnWMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure OnWMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
  private
    function GetMinWidthHeight: Integer;
    procedure SetThisBounds(L, T, W, H: Integer);
    procedure AllControlsOff;
    procedure OnPropsChange;
  public
    procedure Copy;
    procedure GoToCenter;
    procedure Border;
    procedure Invert;
  end;

var
  frmRuler: TfrmRuler;

implementation

uses
  Clipbrd,
  uData, uProcs, uFormProcs, uCommonTools;

{$R *.DFM}

const
  FRAME_WIDTH = 1;

{ TfrmDispix }

procedure TfrmRuler.OnWMNCHitTest(var Msg: TWMNCHitTest);

  function _InObject(C: TControl; P: TPoint): Boolean;
  begin
    Result := (P.x >= C.Left) and (P.x <= C.Left + C.Width) and (P.y >= C.Top) and (P.y <= C.Top + C.Height);
  end;

 var P: TPoint;
begin
  inherited;
  P.x := Msg.XPos;
  P.y := Msg.YPos;
  P := ScreenToClient(P);
  if _InObject(ShapeLeftTop, P) then Msg.Result := HTTOPLEFT
  else if _InObject(ShapeRightTop, P) then Msg.Result := HTTOPRIGHT
  else if _InObject(ShapeLeftBottom, P) then Msg.Result := HTBOTTOMLEFT
  else if _InObject(ShapeRightBottom, P) then Msg.Result := HTBOTTOMRIGHT
  else if _InObject(ShapeTopCenter, P) then Msg.Result := HTTOP
  else if _InObject(ShapeLeftCenter, P) then Msg.Result := HTLEFT
  else if _InObject(ShapeRightCenter, P) then Msg.Result := HTRIGHT
  else if _InObject(ShapeBottomCenter, P) then Msg.Result := HTBOTTOM
  else Msg.Result := HTCAPTION;
end;

procedure TfrmRuler.OnWMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  inherited;
  Msg.MinMaxInfo^.ptMinTrackSize.x := GetMinWidthHeight;
  Msg.MinMaxInfo^.ptMinTrackSize.y := Msg.MinMaxInfo^.ptMinTrackSize.x;
end;

procedure TfrmRuler.FormCreate(Sender: TObject);
 var I: Integer;
begin
  inherited;
  TransparentColor := (Win32MajorVersion >= 5);
  SetBounds(PMemFile^.Props.Dispix.Left, PMemFile^.Props.Dispix.Top, PMemFile^.Props.Dispix.Width, PMemFile^.Props.Dispix.Height);
  for I := 0 to ComponentCount - 1 do if (Components[I] is TShape) and ((Components[I] as TShape).Tag >= 0) then begin
    (Components[I] as TShape).Width := PMemFile^.Props.Dispix.BlockSize;
    (Components[I] as TShape).Height := PMemFile^.Props.Dispix.BlockSize;
  end;
  ShapeLeftTop.SetBounds(FRAME_WIDTH, FRAME_WIDTH, PMemFile^.Props.Dispix.BlockSize, PMemFile^.Props.Dispix.BlockSize);
  ShapeRightTop.SetBounds(Width - PMemFile^.Props.Dispix.BlockSize - FRAME_WIDTH, FRAME_WIDTH, PMemFile^.Props.Dispix.BlockSize, PMemFile^.Props.Dispix.BlockSize);
  ShapeLeftBottom.SetBounds(FRAME_WIDTH, Height - PMemFile^.Props.Dispix.BlockSize - FRAME_WIDTH, PMemFile^.Props.Dispix.BlockSize, PMemFile^.Props.Dispix.BlockSize);
  ShapeRightBottom.SetBounds(Width - PMemFile^.Props.Dispix.BlockSize - FRAME_WIDTH, Height - PMemFile^.Props.Dispix.BlockSize - FRAME_WIDTH, PMemFile^.Props.Dispix.BlockSize, PMemFile^.Props.Dispix.BlockSize);
  ShapeTopCenter.SetBounds((Width - PMemFile^.Props.Dispix.BlockSize) div 2, FRAME_WIDTH, PMemFile^.Props.Dispix.BlockSize, PMemFile^.Props.Dispix.BlockSize);
  ShapeLeftCenter.SetBounds(FRAME_WIDTH, (Height - PMemFile^.Props.Dispix.BlockSize) div 2, PMemFile^.Props.Dispix.BlockSize, PMemFile^.Props.Dispix.BlockSize);
  ShapeRightCenter.SetBounds(Width - PMemFile^.Props.Dispix.BlockSize - FRAME_WIDTH, (Height - PMemFile^.Props.Dispix.BlockSize) div 2, PMemFile^.Props.Dispix.BlockSize, PMemFile^.Props.Dispix.BlockSize);
  ShapeBottomCenter.SetBounds((Width - PMemFile^.Props.Dispix.BlockSize) div 2, Height - PMemFile^.Props.Dispix.BlockSize - FRAME_WIDTH, PMemFile^.Props.Dispix.BlockSize, PMemFile^.Props.Dispix.BlockSize);
  ImageCenter.SetBounds((Width - ImageCenter.Width) div 2, (Height - ImageCenter.Height) div 2, ImageCenter.Width, ImageCenter.Height);

  OnPropsChange;
end;

procedure TfrmRuler.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  PMemFile^.Props.Dispix.Left := Left;
  PMemFile^.Props.Dispix.Top := Top;
  PMemFile^.Props.Dispix.Width := Width;
  PMemFile^.Props.Dispix.Height := Height;
end;

function TfrmRuler.GetMinWidthHeight: Integer;
begin
  Result := PMemFile^.Props.Dispix.BlockSize * 3 + FRAME_WIDTH * 2;
end;

procedure TfrmRuler.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
 var L, T, W, H: Integer;
begin
  inherited;
  L := Left; T := Top; W := Width; H := Height;
  if (MousePos.x < L) or (MousePos.x > L + W) or (MousePos.y < T) or (MousePos.y > T + H) then Exit;
  if WheelDelta > 0 then begin
    if Shift = [ssShift] then begin
      L := L - PMemFile^.Props.Dispix.PageSize; T := T - PMemFile^.Props.Dispix.PageSize; W := W + PMemFile^.Props.Dispix.PageSize * 2; H := H + PMemFile^.Props.Dispix.PageSize * 2;
    end else begin
      L := L - 1; T := T - 1; W := W + 2; H := H + 2;
    end;
  end else begin
    if Shift = [ssShift] then begin
      L := L + PMemFile^.Props.Dispix.PageSize; T := T + PMemFile^.Props.Dispix.PageSize; W := W - PMemFile^.Props.Dispix.PageSize * 2; H := H - PMemFile^.Props.Dispix.PageSize * 2;
    end else begin
      L := L + 1; T := T + 1; W := W - 2; H := H - 2;
    end;
  end;
  SetThisBounds(L, T, W, H);
end;

procedure TfrmRuler.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
 var L, T, W, H: Integer;
begin
  inherited;
  case Key of
    33..40: begin  // Navigation
      L := Left; T := Top; W := Width; H := Height;
      case Key of
        37: begin
          if Shift = [] then L := L - 1 else if Shift = [ssShift] then L := L - PMemFile^.Props.Dispix.PageSize;
          if ssCtrl in Shift then begin
            if ssShift in Shift then W := W - PMemFile^.Props.Dispix.PageSize else W := W - 1;
          end;
        end;
        38: begin
          if Shift = [] then T := T - 1 else if Shift = [ssShift] then T := T - PMemFile^.Props.Dispix.PageSize;
          if ssCtrl in Shift then begin
            if ssShift in Shift then H := H - PMemFile^.Props.Dispix.PageSize else H := H - 1;
          end;
        end;
        39: begin
          if Shift = [] then L := L + 1 else if Shift = [ssShift] then L := L + PMemFile^.Props.Dispix.PageSize;
          if ssCtrl in Shift then begin
            if ssShift in Shift then W := W + PMemFile^.Props.Dispix.PageSize else W := W + 1;
          end;
        end;
        40: begin
          if Shift = [] then T := T + 1 else if Shift = [ssShift] then T := T + PMemFile^.Props.Dispix.PageSize;
          if ssCtrl in Shift then begin
            if ssShift in Shift then H := H + PMemFile^.Props.Dispix.PageSize else H := H + 1;
          end;
        end;
      end;
      SetThisBounds(L, T, W, H);
    end;
    67: if Shift = [ssCtrl] then Copy;
  end;
end;

procedure TfrmRuler.Copy;
 var
   Bmp: TBitmap;
   DC: HDC;
   ClipboardFormat: Word;
   AData: THandle;
   APalette: HPALETTE;
begin
  Visible := False;
  DC := GetDC(0);
  try
    Bmp := TBitmap.Create;
    try
      Bmp.Width := Width;
      Bmp.Height := Height;
      Sleep(PMemFile^.Props.Dispix.CopyPause);
      if BitBlt(Bmp.Canvas.Handle, 0, 0, Width, Height, DC, Left, Top, SRCCOPY) then begin
        Bmp.SaveToClipboardFormat(ClipboardFormat, AData, APalette);
        ClipBoard.SetAsHandle(ClipboardFormat, AData);
        PostMessage(PMemFile^.GlobalData.WndMain, PM_COMMON, Ord(cmOk), Integer(True));
      end else PostMessage(PMemFile^.GlobalData.WndMain, PM_COMMON, Ord(cmCancel), Integer(True));
      SetForegroundWindow(Handle);
    finally
      Bmp.Free;
    end;
  finally
    ReleaseDC(Handle, DC);
    Visible := True;
  end;
end;

procedure TfrmRuler.SetThisBounds(L, T, W, H: Integer);
 var MinWH: Integer;
begin
  MinWH := GetMinWidthHeight;
  if (W >= MinWH) and (H >= MinWH) then SetBounds(L, T, W, H);
end;

procedure TfrmRuler.AllControlsOff;
 var I :Integer;
begin
  for I := 0 to ComponentCount - 1 do if (Components[I] is TShape) and ((Components[I] as TShape).Tag >= 0) then if PMemFile^.Props.Dispix.Invert then begin
    (Components[I] as TShape).Brush.Color := clBlack;
    (Components[I] as TShape).Pen.Color := clWhite;
  end else begin
    (Components[I] as TShape).Brush.Color := clWhite;
    (Components[I] as TShape).Pen.Color := clBlack;
  end;
end;

procedure TfrmRuler.GoToCenter;
begin
  SetBounds((Screen.Width - Width) div 2, (Screen.Height - Height) div 2, Width, Height);
  SetForegroundWindow(Handle);
end;

procedure TfrmRuler.Border;
begin
  if TCheckBoxState(PMemFile^.Props.Dispix.Border) = cbUnchecked then PMemFile^.Props.Dispix.Border := Ord(cbGrayed)
  else if TCheckBoxState(PMemFile^.Props.Dispix.Border) = cbGrayed then PMemFile^.Props.Dispix.Border := Ord(cbChecked)
  else PMemFile^.Props.Dispix.Border := Ord(cbUnchecked);
  OnPropsChange;
end;

procedure TfrmRuler.OnPropsChange;
begin
  case TCheckBoxState(PMemFile^.Props.Dispix.Border) of
    cbUnchecked: ShapeMain.Pen.Style := psClear;
    cbChecked: ShapeMain.Pen.Style := psSolid;
    cbGrayed: ShapeMain.Pen.Style := psDot;
  end;
  if PMemFile^.Props.Dispix.Invert then begin
    ImageCenter.Picture.Assign(ImageWhite.Picture);
    ShapeMain.Pen.Color := clWhite;
    if not TransparentColor then Color := clGray;
  end else begin
    ImageCenter.Picture.Assign(ImageBlack.Picture);
    ShapeMain.Pen.Color := clBlack;
    if not TransparentColor then Color := clSilver;
  end;
  AllControlsOff;
end;

procedure TfrmRuler.Invert;
begin
  PMemFile^.Props.Dispix.Invert := not PMemFile^.Props.Dispix.Invert;
  OnPropsChange;
end;

procedure TfrmRuler.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfrmRuler.FormDestroy(Sender: TObject);
begin
  inherited;
  frmRuler := nil;
end;

end.
