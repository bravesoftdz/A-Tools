unit uCProcs;

interface

uses
  Windows, Messages, uData;

function CreateOrOpenSharedFile: Boolean;
procedure CloseSharedFile;

function PointInSSRunSquare(var P: TPoint): Boolean;

function GetProgPath: String;

procedure DBG(sMsg: String); overload;
procedure DBG(iMsg: Integer); overload;

implementation

uses
  uCommonTools, uRegLite, SysUtils;

const
  SHARED_MEM_FILE = 'ATData_File_' + PROG_CLSID + '.mem';

var
  hMapFileObject: THandle = 0;

function CreateOrOpenSharedFile: Boolean;   // not needed now. stay from Hooks and DLLs versions
 var Init: Boolean;
begin
  hMapFileObject := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, SizeOf(TMemFile), SHARED_MEM_FILE);
  Result := (hMapFileObject <> 0);
  if Result then begin
    Init := (GetLastError = 0);
    PMemFile := MapViewOfFile(hMapFileObject, FILE_MAP_ALL_ACCESS, 0, 0, 0);
    Result := (PMemFile <> nil);
    if Result and Init then FillChar(PMemFile^, SizeOf(TMemFile), 0);
  end;
end;

procedure CloseSharedFile;
begin
  if PMemFile <> nil then UnmapViewOfFile(PMemFile);
  if hMapFileObject <> 0 then CloseHandle(hMapFileObject);
end;

function PointInSSRunSquare(var P: TPoint): Boolean;
begin
  with PMemFile^.Props.ScreenSaver do case RunCorner of
    ssRCTopLeft: Result := (P.x < RunSize) and (P.y < RunSize);
    ssRCTopRight: Result := (P.x >= GetSystemMetrics(SM_CXSCREEN) - RunSize) and (P.y < RunSize);
    ssRCBottomLeft: Result := (P.x < RunSize) and (P.y >= GetSystemMetrics(SM_CYSCREEN) - RunSize);
    ssRCBottomRight: Result := (P.x >= GetSystemMetrics(SM_CXSCREEN) - RunSize) and (P.y >= GetSystemMetrics(SM_CYSCREEN) - RunSize);
    else Result := False;
  end;
end;

function GetProgPath: String;
begin
  Result := RegGetString(HKEY_LOCAL_MACHINE, REG_APP_KEY, '');
  if Length(Result) > 0 then if Result[Length(Result)] = '\' then Delete(Result, Length(Result), 1);
end;

procedure DBG(sMsg: String);
begin
  OutputDebugString(PChar(PROG_NAME + ': ' + sMsg));
end;

procedure DBG(iMsg: Integer);
begin
  OutputDebugString(PChar(PROG_NAME + ': ' + IntToStr(iMsg)));
end;

end.
