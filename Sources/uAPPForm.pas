unit uAPPForm;

interface

uses
  Windows, Messages, Forms, Controls, Classes, Graphics,
  uForm, uData, ICSLanguages;

type
  TfrmAPPForm = class(TfrmForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    procedure WMDisplayChange(var Msg: TWMDisplayChange); message WM_DISPLAYCHANGE;
  protected
    Bmp: TBitmap;
    procedure NormalizeWindow;
  end;

var
  frmAPPForm: TfrmAPPForm;

implementation

uses uCProcs, uCommonTools;

{$R *.DFM}

{ TfrmAPPForm }

procedure TfrmAPPForm.WMDisplayChange(var Msg: TWMDisplayChange);
begin
  inherited;
  NormalizeWindow;
end;

procedure TfrmAPPForm.FormCreate(Sender: TObject);
begin
  inherited;
  Bmp := TBitmap.Create;
end;

procedure TfrmAPPForm.FormDestroy(Sender: TObject);
begin
  Bmp.Free;
  inherited;
end;

procedure TfrmAPPForm.FormPaint(Sender: TObject);
begin
  inherited;
  Application.RestoreTopMosts;
end;

procedure TfrmAPPForm.FormShow(Sender: TObject);
begin
  inherited;
  icsBringToTop(Application.Handle);
end;

procedure TfrmAPPForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  inherited;
end;

procedure TfrmAPPForm.NormalizeWindow;
 var
   L, T, W, H: Integer;
   M: TMonitor;
begin
  L := Left; T := Top; W := Width; H := Height;
  M := Screen.MonitorFromWindow(Handle);
  if W > M.Width then W := M.Width;
  if H > M.Height then H := M.Height;
  if L < M.Left then L := M.Left else if L > M.BoundsRect.Right then L := M.Width - W;
  if L + W > M.BoundsRect.Right then L := M.BoundsRect.Right - W;
  if T < M.Top then T := M.Top else if T > M.BoundsRect.Bottom then T := M.Height - H;
  if T + H > M.BoundsRect.Bottom then T := M.BoundsRect.Bottom - H;
  SetBounds(L, T, W, H);
end;

procedure TfrmAPPForm.FormActivate(Sender: TObject);
begin
  inherited;
  NormalizeWindow;
end;

end.
