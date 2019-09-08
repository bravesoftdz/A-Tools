unit uScreenInfo;

interface

uses
  Windows, Messages, StdCtrls, ExtCtrls, Controls, Graphics, Classes,
  SysUtils, Forms, ComCtrls,
  uData, uForm, Buttons,
  uAPPForm, ICSLanguages;


type
  TfrmScreenInfo = class(TfrmAPPForm)
    Timer1: TTimer;
    ImageWin: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    LabelWinCaptionText: TLabel;
    LabelWinClassText: TLabel;
    LabelHandle: TLabel;
    EditWinCaption: TEdit;
    EditWinClass: TEdit;
    EditHandle: TEdit;
    TabSheet2: TTabSheet;
    PaintBoxLupe: TPaintBox;
    Shape1: TShape;
    LabelColor: TLabel;
    Label2: TLabel;
    LabelGrayscale: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    ShapeRGB: TShape;
    ShapeGray: TShape;
    ShapeR: TShape;
    ShapeG: TShape;
    ShapeB: TShape;
    LabelFactor: TLabel;
    ShapeLF: TShape;
    UpDownLupe: TUpDown;
    EditColor: TEdit;
    EditR: TEdit;
    EditGrayScale: TEdit;
    EditG: TEdit;
    EditB: TEdit;
    TabSheet3: TTabSheet;
    LabelPos: TLabel;
    ImageDispix: TImage;
    EditPosition: TEdit;
    ButtonCopy: TButton;
    CBBorder: TCheckBox;
    CBInvert: TCheckBox;
    ImageWinIcon: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpDownLupeChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EditWinCaptionChange(Sender: TObject);
    procedure ButtonCopyClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FTitle: WideString;
    procedure OnCommonMsg(var Msg: TMessage); message PM_COMMON;
    procedure CloseDispixForm;
    procedure OnAppSetLanguageMsg(var Msg: TMessage); message ICS_SETLANGUAGE_MSG;
  end;

var
  frmScreenInfo: TfrmScreenInfo = nil;

implementation

uses
  Math,
  uProcs, uCommonTools, uFormProcs, uRuler, uCProcs;

{$R *.DFM}

{ TfrmwindowInfo }

function RGBToGrayscale(RGB: TRGB): Byte;
begin
  with RGB do Result := HiByte(R * 77 + G * 151 + B * 28); //Trunc(R * 0.3 + G * 0.59 + B * 0.11)
end;

function GrayscaleToColor(GS: Byte): TColor;
begin
  Result := GS * $10000 + GS * $100 + GS;
end;

procedure TfrmScreenInfo.Timer1Timer(Sender: TObject);
 var
   P, ClientP: TPoint;
   Wnd: HWND;
   hIco: HICON;
   DC: HDC;
   LF: Integer;
   Cl: TColor;
   RGB: TRGB;
   GrayScale: Byte;
begin
  inherited;
  GetCursorPos(P);
  Caption := FTitle + ' - [' + Format('%d,%d', [P.x, P.y]) + ']';
  case PMemFile^.Props.ScreenInfo.LastPage of
    0: begin
      ClientP := P;
      Wnd := WindowFromPoint(P);
      Windows.ScreenToClient(Wnd, ClientP);
      EditHandle.Text := WideFormat('%d', [Wnd]);

      EditWinCaption.Text := icsGetWindowCaption(Wnd);
      EditWinClass.Text := icsGetWindowClassName(Wnd);

      if ImageWinIcon.Tag <> Integer(Wnd) then begin
        if icsGetLastParentWnd(Wnd) = Handle then ImageWinIcon.Picture.Icon.Assign(Application.Icon) else begin
          hIco := icsGetWindowIcon(Wnd);
          if hIco = 0 then ImageWinIcon.Picture.Icon.Assign(ImageWin.Picture.Icon) else ImageWinIcon.Picture.Icon.Handle := hIco;
        end;
        ImageWinIcon.Tag := Wnd;
      end;
    end;
    1: begin
      DC := GetDC(0);
      Cl := GetPixel(DC, P.x, P.y);
      RGB := GetRGB(Cl);
      GrayScale := RGBToGrayscale(RGB);

      EditColor.Text := WideFormat('%.2x%.2x%.2x', [RGB.R, RGB.G, RGB.B]);
      EditR.Text := WideFormat('%d', [RGB.R]);
      EditG.Text := WideFormat('%d', [RGB.G]);
      EditB.Text := WideFormat('%d', [RGB.B]);
      EditGrayScale.Text := WideFormat('%d', [GrayScale]);

      ShapeRGB.Brush.Color := Cl;
      ShapeGray.Brush.Color := GrayscaleToColor(GrayScale);
      ShapeR.Brush.Color := RGB.R;
      ShapeG.Brush.Color := RGB.G * $100;
      ShapeB.Brush.Color := RGB.B * $10000;

      LF := PMemFile^.Props.ScreenInfo.LupeFactor * 3;
      StretchBlt(PaintBoxLupe.Canvas.Handle, 0, 0, PaintBoxLupe.Width, PaintBoxLupe.Height, DC, P.x - PaintBoxLupe.Width div (LF * 2), P.y - PaintBoxLupe.Height div (LF * 2), PaintBoxLupe.Width div LF, PaintBoxLupe.Height div LF, SRCCOPY);
      PaintBoxLupe.Canvas.Pixels[PaintBoxLupe.Width div 2, PaintBoxLupe.Height div 2] := GetBlackOrWhite(Cl);
      LabelFactor.Caption := WideFormat('%dx', [LF]);
//      ShapeLF.Pen.Width := LF div 2;

      ReleaseDC(0, DC);
    end;
    2: if Assigned(frmRuler) then with frmRuler do Self.EditPosition.Text := WideFormat('%d,%d - %dx%d', [Left, Top, Width, Height]);
  end;
end;

procedure TfrmScreenInfo.FormCreate(Sender: TObject);
begin
  inherited;
  SetBounds(PMemFile^.Props.ScreenInfo.Left, PMemFile^.Props.ScreenInfo.Top, Width, Height);
  ClientWidth := PageControl1.Width + PageControl1.Left * 2;
  ClientHeight := PageControl1.Height + PageControl1.Top * 2;
  UpDownLupe.Position := PMemFile^.Props.ScreenInfo.LupeFactor;
  CBBorder.State := TCheckBoxState(PMemFile^.Props.Dispix.Border);
  CBInvert.Checked := PMemFile^.Props.Dispix.Invert;
  FTitle := Caption;
  if PMemFile^.Props.ScreenInfo.LastPage in [0..PageControl1.PageCount - 1] then PageControl1.ActivePageIndex := PMemFile^.Props.ScreenInfo.LastPage else PageControl1.ActivePageIndex := 0;
end;

procedure TfrmScreenInfo.OnCommonMsg(var Msg: TMessage);
begin
  case TCommonMsg(Msg.WParam) of
    cmSIStartStop: begin
      Timer1.Enabled := not Timer1.Enabled;
      if not Timer1.Enabled then Caption := Caption + ' - ' + ICSLanguages1.CurrentStrings[13];
    end;
    cmShowRuler: begin
      if not Assigned(frmRuler) then frmRuler := TfrmRuler.Create(Application);
      frmRuler.Show;
    end;
  end;
end;

procedure TfrmScreenInfo.FormDestroy(Sender: TObject);
begin
  frmScreenInfo := nil;
  inherited;
end;

procedure TfrmScreenInfo.UpDownLupeChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  inherited;
  if not Timer1.Enabled then Exit;
  AllowChange := (NewValue in [UpDownLupe.Min..UpDownLupe.Max]);
  if AllowChange then PMemFile^.Props.ScreenInfo.LupeFactor := NewValue;
end;

procedure TfrmScreenInfo.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = 27 then Close else
end;

procedure TfrmScreenInfo.CloseDispixForm;
begin
  if Assigned(frmRuler) then frmRuler.Close;
end;

procedure TfrmScreenInfo.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  CloseDispixForm;
  if Visible then begin
    PMemFile^.Props.ScreenInfo.Left := Left;
    PMemFile^.Props.ScreenInfo.Top := Top;
  end;
end;

procedure TfrmScreenInfo.EditWinCaptionChange(Sender: TObject);
begin
  inherited;
  (Sender as TEdit).SelectAll;
end;

procedure TfrmScreenInfo.ButtonCopyClick(Sender: TObject);
begin
  inherited;
  if Assigned(frmRuler) then with frmRuler do begin
    case (Sender as TComponent).Tag of
      10: Copy;
      11: Invert;
      12: Border;
    end;
    BringToFront;
  end;
end;

procedure TfrmScreenInfo.PageControl1Change(Sender: TObject);
begin
  inherited;
  Timer1.Enabled := True;
  PMemFile^.Props.ScreenInfo.LastPage := PageControl1.ActivePageIndex;
  if PageControl1.ActivePageIndex <> 2 then CloseDispixForm else PostMessage(Handle, PM_COMMON, Ord(cmShowRuler), 0);
  if Visible then case PageControl1.ActivePageIndex of
    0: EditWinCaption.SetFocus;
    1: EditColor.SetFocus;
    2: EditPosition.SetFocus;
  end;
end;

procedure TfrmScreenInfo.OnAppSetLanguageMsg(var Msg: TMessage);
 const MIN_SPACE            = 8;
begin
  inherited;
  EditWinCaption.Left := LabelWinCaptionText.Left + LabelWinCaptionText.Width + MIN_SPACE;
  EditWinCaption.Width := TabSheet1.Width - EditWinCaption.Left - MIN_SPACE;

  EditWinClass.Left := LabelWinClassText.Left + LabelWinClassText.Width + MIN_SPACE;
  EditWinClass.Width := TabSheet1.Width - EditWinClass.Left - MIN_SPACE;

  EditHandle.Left := LabelHandle.Left + LabelHandle.Width + MIN_SPACE;
  EditHandle.Width := TabSheet1.Width - EditHandle.Left - MIN_SPACE;

  EditColor.Left := LabelColor.Left + LabelColor.Width + MIN_SPACE;
  EditGrayScale.Left := LabelGrayscale.Left + LabelGrayscale.Width + MIN_SPACE;

  EditPosition.Left := LabelPos.Left + LabelPos.Width + MIN_SPACE;
  EditPosition.Width := ButtonCopy.Left - EditPosition.Left - MIN_SPACE;
end;

procedure TfrmScreenInfo.FormActivate(Sender: TObject);
begin
  inherited;
  if not Assigned(frmRuler) then PageControl1Change(nil);
end;

end.
