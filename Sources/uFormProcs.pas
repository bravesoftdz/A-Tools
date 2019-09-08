unit uFormProcs;

interface

uses
  Windows, Graphics, Classes, Controls, ImgList,
  uData;

function RGBToColor(RGB: TRGB): TColor;
function GetRGB(C: DWord): TRGB;
function GetDarkColor(C: TColor; DarkValue: Byte): TColor;
function GetBlackOrWhite(C: TColor): TColor;

function VCLFontToProgFont(F: TFont): TProgFont;
procedure SetVCLFontFromProgFont(VCLF: TFont; PF: TProgFont);

function HotKeyToShortCut(HotKey: THotKeyRec): TShortCut;
function ShortCutToHotKey(ShortCut: TShortCut): THotKeyRec;

procedure DoUpdate;

//procedure MoveWndToTray(Wnd: HWND);
//procedure NormalizeMinTrayIcons;

procedure ConvertTo32BitImageList(const ImageList: TImageList);

implementation

uses
  UITypes, Messages, CommCtrl, RegStr, uCommonTools, SysUtils, uDownload;

function RGBToColor(RGB: TRGB): TColor;
begin
  with RGB do Result := B * $10000 + G * $100 + R;
end;

function GetRGB(C: DWord): TRGB;
begin
  Result.R := C;
  Result.G := C div $100;
  Result.B := C div $10000;
end;

function GetDarkColor(C: TColor; DarkValue: Byte): TColor;
 var RGBRec: TRGB;
begin
  RGBRec := GetRGB(C);
  with RGBRec do begin
    if R > DarkValue then R := R - DarkValue else R := 0;
    if G > DarkValue then G := G - DarkValue else G := 0;
    if B > DarkValue then B := B - DarkValue else B := 0;
    Result := RGB(R, G, B);
  end;
end;

function GetBlackOrWhite(C: TColor): TColor;
 var R, G, B: Byte;
begin
  R := C;
  G := C div $100;
  B := C div $10000;
  if HiByte(R * 77 + G * 151 + B * 28) > 140 then Result := clBlack else Result := clWhite;
end;

{function GetBlackOrWhite(RGB: TRGB): TColor;
 const E = 256 * 256 * 3/2;
//!! const E = 140;
begin
  with RGB do if (R * R + G * G + B * B) > E then Result := clBlack else Result := clWhite;
//!!  if RGBToGrayscale(RGB) > E then Result := clBlack else Result := clWhite;
//!!  with RGB do Result := DWord($FF - B) * $10000 + DWord($FF - G) * $100 + DWord($FF - R);
end;}

function VCLFontToProgFont(F: TFont): TProgFont;
begin
  Result.Color := F.Color;
  lstrcpy(Result.Name, PChar(F.Name));
  Result.Style.Bold := fsBold in F.Style;
  Result.Style.Italic := fsItalic in F.Style;
  Result.Style.Underline := fsUnderline in F.Style;
  Result.Style.StrikeOut := fsStrikeOut in F.Style;
  Result.Size := F.Size;
  Result.CharSet := F.Charset;
end;

procedure SetVCLFontFromProgFont(VCLF: TFont; PF: TProgFont);
begin
  VCLF.Color := PF.Color;
  VCLF.Name := PF.Name;
  VCLF.Style := [];
  if PF.Style.Bold then VCLF.Style := VCLF.Style + [fsBold];
  if PF.Style.Italic then VCLF.Style := VCLF.Style + [fsItalic];
  if PF.Style.Underline then VCLF.Style := VCLF.Style + [fsUnderline];
  if PF.Style.StrikeOut then VCLF.Style := VCLF.Style + [fsStrikeOut];
  VCLF.Size := PF.Size;
  VCLF.Charset := PF.CharSet;
end;

function HotKeyToShortCut(HotKey: THotKeyRec): TShortCut;
begin
  Result := HotKey.VKey;
  if HotKey.Modifiers and MOD_SHIFT = MOD_SHIFT then Inc(Result, scShift);
  if HotKey.Modifiers and MOD_CONTROL = MOD_CONTROL then Inc(Result, scCtrl);
  if HotKey.Modifiers and MOD_ALT = MOD_ALT then Inc(Result, scAlt);
end;

function ShortCutToHotKey(ShortCut: TShortCut): THotKeyRec;
begin
  Result.VKey := ShortCut and not (scShift + scCtrl + scAlt);
  Result.Modifiers := 0;
  if ShortCut and scShift <> 0 then Result.Modifiers := Result.Modifiers or MOD_SHIFT;
  if ShortCut and scCtrl <> 0 then Result.Modifiers := Result.Modifiers or MOD_CONTROL;
  if ShortCut and scAlt <> 0 then Result.Modifiers := Result.Modifiers or MOD_ALT;
end;

procedure DoUpdate;
 var S: String;
begin
  S := icsGetTempFileName('.tmp');
  if DownloadINetFile(HOST_GET_DATA_URL + '?' + HOST_DATA_PARAM + '=' + HOST_DATA_PARAM_UPDATE, S, PROG_NAME) then begin
    SendMessage(PMemFile^.GlobalData.WndMain, WM_SYSCOMMAND, SC_CLOSE, 0);
    icsStartProcess(S);
  end;
end;

procedure ConvertTo32BitImageList(const ImageList: TImageList);
 const Mask: array[Boolean] of Longint = (0, ILC_MASK);
 var TempList: TImageList;
begin
  if Assigned(ImageList) then begin
    TempList := TImageList.Create(nil);
    try
      TempList.Assign(ImageList);
      with ImageList do Handle := ImageList_Create(Width, Height, ILC_COLOR32 or Mask[Masked], 0, AllocBy);
      Imagelist.AddImages(TempList);
    finally
      FreeAndNil(TempList);
    end;
  end;
end;

end.
