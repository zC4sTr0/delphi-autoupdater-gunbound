program UpdaterReplacer;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  tlhelp32,
  windows,
  dialogs;


function killtask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: boolean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

 procedure StartGB(filename: PChar);
var
  lpStartupInfo: STARTUPINFO;
  lpProcessInformation: PROCESS_INFORMATION;
begin
  ZeroMemory(@lpStartupInfo, SizeOf(STARTUPINFO));
  lpStartupInfo.cb := SizeOf(STARTUPINFO);
  CreateProcess(filename, pchar(ParamStr(0)), nil, nil, False, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, lpStartupInfo, lpProcessInformation);
end;

begin
  OutputDebugStringA('THIS PROGRAM IS MADE BY GUNPROTECT');
  //if ((paramstr(1) <> 'updater') or (ParamStr(1) <> 'restart')) then begin outputdebugstring('Not authorized'); exitprocess(0); end;
  OutputDebugStringA('GunProtect Replacer. v1.2');
  if fileexists('Updater.exe.tmp') then begin
    OutputDebugStringA('GunProtect] file does exists.');
    killtask('Updater.exe');
    OutputDebugStringA('GunProtect] task finished.');
    Sleep(2000);
    if not deletefile('updater.exe') then
    MessageDlg('Replace error! Contact support.', mtError, [mbOK], 0);

    if not sysutils.renamefile('Updater.exe.tmp','Updater.exe') then
    MessageDlg('Rename error! Contact support.', mtError, [mbOK], 0);

    sysutils.renamefile('Updater.exe.tmp','Updater.exe');
    OutputDebugStringA('GunProtect] Starting updater.');
    Sleep(1000);
    StartGB('Updater.exe');
  end else begin
   OutputDebugStringA('GunProtect] file does  NOT exists.');
   killtask('Updater.exe');
   OutputDebugStringA('GunProtect] task finished.');
   StartGB('Updater.exe');
   if not sysutils.renamefile('Updater.exe.tmp','Updater.exe') then
   OutputDebugStringA('Rename attempt failed');
   Sleep(1000);
   StartGB('Updater.exe');
  end;
  end.
