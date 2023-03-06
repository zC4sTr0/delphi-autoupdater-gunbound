unit FormUpdater;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, XPMan, IniFiles, jpeg, Buttons, Gauges,
  AbBase, AbBrowse,  AbUnzper, idhttp, AbZBrows, IdBaseComponent,
   Math,  Mem_util, Hash, blaks256, ThreadDownload, shellapi,tlhelp32,
  pngimage,ufunc;
const
  config  =  'updater.ini';
  downloadstr2= 'http://gitzwc.com/attfetchGP2/';
  downloadstr3= 'http://gunprotect.com.br/gunbound/...';

type
TStringArray = array of string;
  TfmrUpdate = class(TForm)
    lblSpeedValue: TLabel;
    lblTimeValue: TLabel;
    mmoLog: TMemo;
    tmrInicio: TTimer;
    imgBG: TImage;
    lblSizeText: TLabel;
    lblTimeText: TLabel;
    lblSpeedText: TLabel;
    lblSizeValue: TLabel;
    tmrDownload: TTimer;
    lblInfo: TLabel;
    imgMinimizar: TImage;
    imgClose: TImage;
    gPartial: TGauge;
    gTotal: TGauge;
    AbUnZipper1: TAbUnZipper;
    mmoFileList: TMemo;
    lblStatusNow: TLabel;
    tmrConnection: TTimer;
    tmrTimeoutRelease: TTimer;
    tmrFinish: TTimer;
    mmoUpdaterini: TMemo;
    XPM: TXPManifest;
      procedure FormCreate(Sender: TObject);

    procedure imgBGMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure tmrDownloadTimer(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure imgMinimizarClick(Sender: TObject);
    procedure tmrInicioTimer(Sender: TObject);
    procedure fase2();
    procedure MLAppend(const s: ansistring);
procedure readPositions;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmrConnectionTimer(Sender: TObject);
    procedure tmrTimeoutReleaseTimer(Sender: TObject);
    procedure tmrFinishTimer(Sender: TObject);



    {-Append a line to file data result string}
  private
    BlakeHashBuffer: array[1..$F000] of byte;   {File read buffer}
    FData: string;                  {Check sums of a file as string}
    bStopHashingFlag: boolean;

            StartTime: Cardinal;
    { Private declarations }
    procedure download(wwwurl, tempFileName: string);
    procedure OnThreadWork(Sender: TThread; AWorkCount: Integer);
    procedure OnThreadWorkBegin(Sender: TThread; AWorkCountMax: Integer);
    procedure DownResultHandle(Sender: TObject; ResponseCode: Integer);

  public
    { Public declarations }
    procedure ProcessFiles(const FName: string; var blkcnt: longint); // faz hash dos arquivos.


  end;

var
  fmrUpdate: TfmrUpdate;
  updConfig : TIniFile;
  vStatusStr:array [0..5] of string;
  LanguageCode      : string = 'en';        // pt/en/es, ou seja o idioma, defaut=en
  numfiles: integer; // numero de arquivos pra baixar
  currentcodefile: integer;
  ultimamsg: string;
  gProgressTotal : longint;
  destrava,restart: Boolean;
  retrymirror1: Cardinal=0;
  retrymirror2:cardinal=0;
  fase: integer=0;

  updatelimite:byte;
  connection: Boolean=false;
  downloadlist, filenamelist : tstringlist;
  totaldownload: int64;

  downloadstr: string='http://pagcob.com.br/GunProtect_Updater2/';
  UpdaterPath: string;

    codedownNOW, lastcodedown: cardinal;
      TUpdateDownloadThread: TDownThread;


implementation

{$R *.DFM}

var
  AverageSpeed: Double = 0;

  
function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName)) then  begin
      if UpperCase(ExeFileName) = 'GITZGAME.EXE' then begin

         If  MessageDlg(updConfig.ReadString(pChar(LanguageCode),  'GITZISRUNNIN',''),mtConfirmation,[mbyes,mbno],0)=mryes
         then begin

          Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));

         end;
                                          end;
                                    end;
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure TfmrUpdate.readPositions;
begin
  imgBG.Height   :=  337;
  imgBG.Width    :=  540;
  fmrUpdate.Height    :=  377;
  fmrUpdate.Width     :=  540;
  gPartial.Left     :=  0;
  gPartial.Top      :=  337;
  gPartial.Width    :=  540;
  gPartial.Height   :=  20;
  gTotal.Left     :=  0;
  gTotal.Top      :=  357;
  gTotal.Width    :=  540;
  gTotal.Height   :=  20;
  lblSizeText.Top   :=  210;
  lblSizeValue.Top     :=  210;
  lblSizeText.Left  :=  7;
  lblTimeText.Left := 7;
  lblSpeedText.left := 7;
  lblTimeText.Top   :=  232;
  lblTimeValue.Top     :=  232;
  lblSpeedText.Top      :=  255;
  lblSpeedValue.Top     :=  255;
  lblInfo.top      :=  205;
  lblInfo.left     :=  293;
  lblStatusNow.left     :=  289;
  lblStatusNow.top      :=  181;
  imgMinimizar.left     :=  476;
  imgMinimizar.top      :=  0;
  imgClose.left     :=  504;
  imgClose.top      :=  0;
  lblInfo.Font.size  :=  9;
  fmrUpdate.Font.size   :=  9;
end;

function countlines(text:tcaption):integer;
var
k:integer;
begin
result:=0;
  for k:=0 to Length(text)-1 do
    if text[k]=#13then inc(result);
inc(result);
end;

procedure Replace(params: PChar);
begin
ShellExecute(Application.Handle,'open', 'UpdaterReplacer.exe', PChar(params),'',SW_SHOWNORMAL);
end;

 procedure StartGB(params: PChar);
begin
  ShellExecute(Application.Handle,'open', 'NyxLauncher.exe', PChar(params),'',SW_SHOWNORMAL);
end;
         {
function URLsize(const URL : string) : integer;
var
  Http: TIdHTTP;
begin
  OutputDebugStringA('GunProtect] Getting sizes...');
  Http := TIdHTTP.Create(nil);
  try
    Application.ProcessMessages; //melhor q fmrUpdate.update nesse caso
    Http.Head(URL);
    result := round(Http.Response.ContentLength );
  finally
    Http.Free;
  end;
end;                            }

function ReadIni(StrIniPath : pchar; StrSection : pchar; StrItem : pchar; StrDefault : pchar) : String;
var
RetAmount : Integer;
StrTemp : String;
StrRet : string;
begin
  SetLength(StrTemp,50);
  RetAmount := GetPrivateProfileString(StrSection, StrItem, StrDefault, pchar(StrTemp), 50, StrIniPath);
  StrRet    := Copy(StrTemp,1,RetAmount);
  Result    := StrRet;
end;

{---------------------------------------------------------------------------}
function HexString(const x: array of byte): ansistring;
  {-HEX string from memory}
begin
  Result := HexStr(@x, sizeof(x));
end;


{---------------------------------------------------------------------------}
procedure TfmrUpdate.MLAppend(const s: ansistring);
  {-Append a line to file data result string}
begin
  FData := FData+{$ifdef D12Plus} string {$endif}(s)+#13#10;
end;


{---------------------------------------------------------------------------}
procedure TfmrUpdate.ProcessFiles(const FName: string; var blkcnt: longint);
  {-Process one file}
var
  n: integer;
  Blaks_256Context: THashContext;  Blaks_256Digest: TBlake2S_256Digest;
  f: file;

  procedure Mwriteln(const s: ansistring);
    {-Writeln a line to richedit}
  begin
    MLAppend(s);
    MLAppend('');
    mmoLog.Text := mmoLog.Text+#10+{$ifdef D12Plus} string {$endif}(s);
  end;

  function RB(A: longint): longint;
    {-rotate byte of longint}
  begin
    RB := (A shr 24) or ((A shr 8) and $FF00) or ((A shl 8) and $FF0000) or (A shl 24);
  end;

begin
  MLAppend({$ifdef D12Plus} ansistring {$endif}(FName));
  filemode := 0;
  blkcnt := 0;
  if not FileExists(FName) then begin
    OutputDebugStringA('GunProtect] file not found');
    exit;
  end;
  assignfile(f,FName);
  system.reset(f,1);
  if IOresult<>0 then begin
   OutputDebugStringA('GunProtect] file could not be opened');
    exit;
 end;
  Blaks256Init(Blaks_256Context);
 // gPartial.maxvalue := round(filesize(f) / sizeof(BlakeHashBuffer));
  repeat
    application.ProcessMessages;
    if bStopHashingFlag then exit;
    blockread(f,BlakeHashBuffer,sizeof(BlakeHashBuffer),n);
    if IOResult<>0 then begin
      Mwriteln('*** read error');
      break;
    end;
    if n<>0 then begin
     { if ((blkcnt mod 128) = 0) then begin
       gPartial.progress := blkcnt;
      end;}

      inc(blkcnt);
      Blaks256Update(Blaks_256Context,@BlakeHashBuffer,n);
    end;
  until n<>sizeof(BlakeHashBuffer);
  closefile(f);
  IOResult;
  Blaks256Final(Blaks_256Context,Blaks_256Digest);
  fdata := Base64Str(@Blaks_256Digest, sizeof(Blaks_256Digest));
end;


function _GetCountryFlag(): string;
var
  Buffer : PChar;
  Size : integer;
begin
  Size := GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SISO639LANGNAME, nil, 0);
  GetMem(Buffer, Size);
  try
    GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_SISO639LANGNAME, Buffer, Size);
    Result := Copy(Buffer,0,2); { return US / use  Result := Buffer to return USA }
  finally
    FreeMem(Buffer);
  end;
end;




function ConvertBytes(i: Int64): string;
begin
  if i < Power(1024, 1) then
    Result := IntToStr(i) + ' Bytes';

  if (i >= Power(1024, 1)) and (i < Power(1024, 2)) then
    Result := Format('%7.2f', [i / Power(1024, 1)]) + ' KB';

  if (i >= Power(1024, 2)) and (i < Power(1024, 3)) then
    Result := Format('%7.2f', [i / Power(1024, 2)]) + ' MB';

  if (i >= Power(1024, 3)) and (i < Power(1024, 4)) then
    Result := Format('%7.2f', [i / Power(1024, 3)]) + ' GB';

  Result := Trim(Result);
end;

Function FormatSeconds(TotalSeconds : Double; WholeSecondsOnly : Boolean = True; DisplayAll : Boolean = False): String;
Var
  Centuries,Years,Months,Minutes,Hours,Days,Weeks : Word;
  Secs : Double;
  TmpStr: Array[1..8] of String;
  SecondsPerCentury: Int64;
  FS : String;
begin
  (** Suppress the decimal part if Whole Seconds Only is desired **)
  If WholeSecondsOnly then
    FS:='%.0f'
  else
    FS:='%.2f';

  (** Split the calculation to avoid an overflow **)
  SecondsPerCentury:= 36500*24;
  SecondsPerCentury:= SecondsPerCentury * 3600;
  SecondsPerCentury:= SecondsPerCentury + ( {4 Leap years per century} 4 * 24 * 3600);
  (** Get centuries **)
  Centuries:=Trunc(TotalSeconds / SecondsPerCentury);
  TotalSeconds:=TotalSeconds-(Centuries * SecondsPerCentury);

  (** Get years **)
  Years:=Trunc(TotalSeconds / (SecondsPerCentury / 100));
  TotalSeconds:=TotalSeconds-(Years * (SecondsPerCentury / 100));

  (** Get months **)
  Months:=Trunc(TotalSeconds / (SecondsPerCentury / 1200));
  TotalSeconds:=TotalSeconds-(Months * (SecondsPerCentury / 1200));

  (** Get weeks **)
  Weeks:=Trunc(TotalSeconds / (24 * 3600 * 7));
  TotalSeconds:=TotalSeconds-(Weeks * (24 * 3600 * 7));

  (** Get days **)
  Days:=Trunc(TotalSeconds / (24 * 3600));
  TotalSeconds:=TotalSeconds-(Days * (24 * 3600));

  (** Get Hours **)
  Hours:=Trunc(TotalSeconds / 3600);
  TotalSeconds:=TotalSeconds-(Hours * 3600);

  (** Get minutes **)
  Minutes:=Trunc(TotalSeconds / 60);
  TotalSeconds:=TotalSeconds-(Minutes * 60);

  (** Get seconds **)
  If WholeSecondsOnly then
    Secs:=Trunc(TotalSeconds)
  else
    Secs:=TotalSeconds;

  (** Deal with single values **)
  if Centuries = 1 then
    TmpStr[1] := ' '+   updConfig.ReadString(pChar(LanguageCode),'Century','') +', '
  else
    TmpStr[1] := ' '+ updConfig.ReadString(pChar(LanguageCode),'Centuries','') +', ';

  if Years = 1 then
    TmpStr[2] := ' '+ updConfig.ReadString(pChar(LanguageCode),'Year','')+', '
  else
    TmpStr[2] := ' '+ updConfig.ReadString(pChar(LanguageCode),'Years','')+', ';

  if Months = 1 then
    TmpStr[3] := ' '+updConfig.ReadString(pChar(LanguageCode),'Month','')+', '
  else
    TmpStr[3] :=' '+updConfig.ReadString(pChar(LanguageCode),'Months','')+', ';

  if Weeks = 1 then
    TmpStr[4] := ' '+updConfig.ReadString(pChar(LanguageCode),'Week','')+', '
  else
    TmpStr[4] := ' '+updConfig.ReadString(pChar(LanguageCode),'Weeks','')+', ';

  if Days = 1 then
    TmpStr[5] := ' '+updConfig.ReadString(pChar(LanguageCode),'Day','')+', '
  else
    TmpStr[5] := ' '+updConfig.ReadString(pChar(LanguageCode),'Days','')+', ';

  if Hours = 1 then
    TmpStr[6] :=' '+updConfig.ReadString(pChar(LanguageCode),'Hour','')+', '
  else
    TmpStr[6]:=' '+updConfig.ReadString(pChar(LanguageCode),'Hours','')+', ';

  if Minutes = 1 then
    TmpStr[7] :=' '+updConfig.ReadString(pChar(LanguageCode),'Minute','')+', '
  else
    TmpStr[7]:=' '+updConfig.ReadString(pChar(LanguageCode),'Minutes','')+', ';

  if Secs = 1 then
    TmpStr[8] :=' '+updConfig.ReadString(pChar(LanguageCode),'Second','')+'.'
  else
    TmpStr[8]:=' '+updConfig.ReadString(pChar(LanguageCode),'Seconds','')+'.';

  If DisplayAll then
   Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s', [Centuries,TmpStr[1],Years,TmpStr[2],Months,TmpStr[3],Weeks,TmpStr[4],Days,TmpStr[5],Hours,TmpStr[6],Minutes,TmpStr[7],Secs,TmpStr[8]])
  else
    begin
      if Centuries >= 1 then
       begin
         Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s', [Centuries,TmpStr[1],Years,TmpStr[2],Months,TmpStr[3],Weeks,TmpStr[4],Days,TmpStr[5],Hours,TmpStr[6],Minutes,TmpStr[7],Secs,TmpStr[8]]);
         Exit;
       end;

      if Years >= 1 then
       begin
         Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',[Years,TmpStr[2],Months,TmpStr[3],Weeks,TmpStr[4],Days,TmpStr[5],Hours,TmpStr[6],Minutes,TmpStr[7],Secs,TmpStr[8]]);
         Exit;
       end;

      if Months >= 1 then
       begin
         Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s',[Months,TmpStr[3],Weeks,TmpStr[4],Days,TmpStr[5],Hours,TmpStr[6],Minutes,TmpStr[7],Secs,TmpStr[8]]);
         Exit;
       end;

      if Weeks >= 1 then
       begin
         Result:= Format('%.0d%s%.0d%s%.0d%s%.0d%s' + FS + '%s', [Weeks,TmpStr[4],Days,TmpStr[5],Hours,TmpStr[6],Minutes,TmpStr[7],Secs,TmpStr[8]]);
         Exit;
       end;

      if Days >= 1 then
       begin
         Result:= Format('%.0d%s%.0d%s%.0d%s' + FS + '%s', [Days,TmpStr[5],Hours,TmpStr[6],Minutes,TmpStr[7],Secs,TmpStr[8]]);
         Exit;
       end;

      if Hours >= 1 then
       begin
         Result:= Format('%.0d%s%.0d%s' + FS + '%s', [Hours,TmpStr[6],Minutes,TmpStr[7],Secs,TmpStr[8]]);
         Exit;
       end;

      if Minutes >= 1 then
       begin
         Result:= Format('%.0d%s' + FS + '%s', [Minutes,TmpStr[7],Secs,TmpStr[8]]);
         exit;
       end;

      Result:= Format(FS + '%s', [Secs,TmpStr[8]]);
    end;
end;

function addinfo(proxmsg: string):string;
var
  i,cmsgs : integer;
begin
 cmsgs := 0;
 result := '';
  for i:=0 to 5 do begin    // conta as msg
   if vStatusStr[i] = '' then break;
   cmsgs := cmsgs+1;
  end;
  if (cmsgs < 6) then begin
   vstatusStr[cmsgs] := proxmsg;
  end else begin
    for i:=0 to 4 do begin
      vStatusStr[i] := vStatusStr[i+1];
    end;
    vStatusStr[5] := proxmsg;
  end;

  for i:=0 to 5 do begin    // conta as msg
   if vStatusStr[i] = '' then break;
    if (result <>'') then  // n tem nada
      result := result + #13+#10+vstatusstr[i]
    else
     result := vstatusstr[i];
  end;

end;

procedure TfmrUpdate.OnThreadWork(Sender: TThread; AWorkCount: Integer);
var
  speed: single;
begin
 if currentcodefile <> 0 then begin


   gPartial.Progress:= AWorkCount;
   speed := AWorkCount/(GetTickCount - StartTime + 1);
   updatelimite:=updatelimite+1;
   if updatelimite=5 then begin
    lblSpeedValue.caption := Format('%.2f KB/s', [speed]);
    lblSizeValue.caption := ConvertBytes( (sender as TDownThread).WorkCountMax);
    lblTimeValue.caption := Format('%f s', [(((Sender as TDownThread).WorkCountMax-AWorkCount)/1000)/speed]);
    //fmrUpdate.update;
    updatelimite:=0;
   end;



   gTotal.progress := gTotal.Progress + (AWorkCount - gProgressTotal);
   gProgressTotal := AWorkCount;


   end;
end;

function TempFolder: String;
var
  bufFolder: array [0..MAX_PATH] of Char;
begin
  GetTempPath(SizeOf(bufFolder), bufFolder);
  Result := IncludeTrailingPathDelimiter(String(bufFolder));
end;


procedure TfmrUpdate.OnThreadWorkBegin(Sender: TThread; AWorkCountMax: Integer);
begin

  if ((currentcodefile <> 0) and (codedownNOW<90)) then begin      //está baixando um arquivo normal q n é
    gPartial.MaxValue := AWorkCountMax;
    updatelimite:=0;
   StartTime := GetTickCount;
   lblStatusNow.Caption := downloadlist.Strings[codedownNOW-1] + ' (' +inttostr(codedownnow)+'/'+inttostr(downloadlist.Count)+')';
   lblInfo.Caption :=  addinfo(updConfig.ReadString(pChar(LanguageCode),  'Downloading data','')) + ' (' +inttostr(codedownnow)+'/'+inttostr(downloadlist.Count)+')';
  end;
  if ((codedownnow=100) or (codedownnow=145)) then begin //está baixando o updater.gp
   gPartial.MaxValue := AWorkCountMax;
   gTotal.MaxValue :=AWorkCountMax;
   StartTime := GetTickCount;
   lblStatusNow.Caption := downloadlist.Strings[codedownNOW-1] + ' (' +inttostr(codedownnow)+'/'+inttostr(downloadlist.Count)+')' ;
   lblInfo.Caption :=  addinfo(updConfig.ReadString(pChar(LanguageCode),  'Downloading Updater','')) + ' (' +inttostr(1)+'/'+inttostr(1)+')';
  end;
  end;


procedure TfmrUpdate.download(wwwurl, tempFileName: string);
var
  path: string;
begin
 OutputDebugStringa(PAnsiChar('GunProtect] Starting download: '+tempfilename));
  gPartial.progress := 0;
  gProgressTotal := 0;
  path := UpdaterPath + tempFileName;

  TUpdateDownloadThread := TDownThread.Create(true);
  with TUpdateDownloadThread do
    begin
     FreeOnTerminate := true;
     OnWork := OnThreadWork;
     OnWorkBegin := OnThreadWorkBegin;
     OnFinish := DownResultHandle;
     URL := wwwurl;
     FileName := path;
     Resume;
     OutputDebugStringa('download resumed');
    end;

end;


procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings) ;
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;

procedure tfmrUpdate.fase2();
var
  i: integer;
  depois, antes, filename, filesize: string;
  intHashLoop: Cardinal;
  ValidHashList: TStringList;
  SizeList:TStringList;
  blkcnt:integer;
  isValidHashFound: Boolean;

begin
 mmoFileList.Lines.LoadFromFile(UpdaterPath+'filelist.dat');
 downloadlist := tstringlist.Create;
 filenamelist := tstringlist.create;
 ValidHashList:= TStringList.Create;
 SizeList :=TStringList.Create;
 OutputDebugStringA('GunProtect] Starting Hashing procedures: Blake2s, 256 bits...');

 for i:=0 to mmoFileList.lines.count-1 do begin
  depois := Copy(mmoFileList.lines.strings[i], Pos(';', mmoFileList.lines.strings[i]) + 1, Length(mmoFileList.lines.strings[i]));  //extrai depois do char ;
  antes := Copy(mmoFileList.lines.strings[i], 0, Pos(';', mmoFileList.lines.strings[i])-1); //extrai tudo antes do char ';'
  filename := Copy(antes, 0, Pos('#', antes)-1); //extrai tudo antes do char '#'
  filesize := Copy(antes, Pos('#', antes) + 1, Length(antes));
  isValidHashFound:=false;
  lblInfo.caption := addinfo(updConfig.ReadString(pChar(LanguageCode),  'VERIFICAARQ','')+ ' ' + filename);
  if not fileexists(filename) then begin
  //   OutputdebugstringA(filename);
   OutputdebugstringA(pchar('GunProtect] File: "'+filename+'" not found! This file has been added to download list'));
   downloadlist.Add(Copy(filename, 0, Pos('.', filename)-1) + '.gp'); //adiciona tudo com .gp no final
   filenamelist.Add(filename);
   SizeList.Add(filesize);
  end else begin
   FData := '';

   ProcessFiles(filename,blkcnt);
   if bStopHashingFlag then break;

   Split('|',depois,ValidHashList);
   OutputDebugStringA(PChar('GunProtect] Valid Hash count for +' + filename + ' is: ' + inttostr(ValidHashList.Count)));

   for intHashLoop:=0 to ValidHashList.Count-1 do begin
    if (ValidHashList[intHashLoop] = fdata)then begin
      isValidHashFound:=true;
      break;
    end;
   end;

   if not isValidHashFound then begin
    OutputdebugstringA(pchar('GunProtect] File hash of "'+filename+'" is "'+fdata+'" but it seems like is supposed to be "'+depois+'". This file is outdated and/or corrupted! It has been added to download list'));
    downloadlist.Add(Copy(filename, 0, Pos('.', filename)-1) + '.gp'); //adiciona tudo com .gp no final
    filenamelist.Add(filename);
    sizelist.Add(filesize);
    end;
  end;
 end;

  if ((downloadlist.Count = 0)) then begin      // n falta nad
   OutputDebugStringA('GunProtect] All files are updated! Starting GunBound...');
   //tem que apagar o filelist.dat
   lblInfo.caption := updConfig.ReadString(pChar(LanguageCode),  'FINISH','');
   lblStatusNow.caption := addinfo('Status: ' +  updConfig.ReadString(pChar(LanguageCode),  'FINISH',''));
   if FileExists(UpdaterPath+'filelist.dat') then begin
    if not DeleteFile(UpdaterPath+'filelist.dat') then MessageDlg('Exception code: 0xD2D. Permission denied.', mtError,[mbOk],0);
   end;
   lblStatusNow.Caption := 'Status: ' + lblSizeText.Caption;
   lblTimeText.caption := '';
   gPartial.MaxValue := 100;
   gPartial.progress := 100;
   gTotal.MaxValue := 100;
   gTotal.progress := 100;
   gPartial.ForeColor := clLime;
   gTotal.ForeColor := clLime;
   sleep(2000);
   OutputDebugStringA('GunProtect] DONE! QUITTING.');
   StartGB('updater');
   exitprocess(0);
  end else begin; // tem que baixar arquivos
   OutputDebugStringA('GunProtect] There are outdated files. Getting sizes and connecting with HTTP server.');
   for i:=0 to downloadlist.Count-1 do begin //colocar em thread
     if (downloadlist.Strings[i] <> '') then begin
     totaldownload := totaldownload +  strtoint(sizelist.Strings[i]);
     totaldownload := totaldownload + ((downloadlist.count)-1);
    end;
   end;
   gTotal.MaxValue := totaldownload;
   gPartial.Progress := 0;
   gTotal.progress := 0;
   lblSpeedText.Caption := updConfig.ReadString(pChar(LanguageCode),  'SPEED','');
   lblTimeText.Caption := updConfig.ReadString(pChar(LanguageCode),  'TIME','');
   lblSizeText.Caption := updConfig.ReadString(pChar(LanguageCode),  'SIZE','');
   codedownnow:=0;
   lastcodedown :=0;
   destrava := true;
   tmrDownload.enabled := true;
  end;
end;

procedure showform();
var
   valueIdioma,i : integer;
 gitzConfig : TIniFile;
begin
 gitzConfig := nil;
 for i:=0 to 5 do vStatusStr[i] := '';
 fmrUpdate.mmoLog.Lines.Add('[INICIAL LOG]');
 fmrUpdate.mmoLog.Lines.Add('INICIAL DATE='+DateToStr(now));
 fmrUpdate.mmoLog.Lines.Add('INICIAL TIME='+TimeToStr(now));
 fmrUpdate.mmoLog.Lines.Add('');
 fmrUpdate.mmoLog.Lines.Add('[UPDATER LOG]');
 try
  OutputDebugStringA('GunProtect] Reading .ini files');
  updConfig :=  TIniFile.Create(UpdaterPath + config);
  gitzConfig := TIniFile.Create(UpdaterPath + 'GitzConfig.ini');
  OutputDebugStringA('GunProtect] Getting Language...');
  updConfig.WriteInteger('CONFIG','FirstTime',1);

  LanguageCode  :=  _GetCountryFlag;
  if  LanguageCode  = 'pt'  then
  begin
   GitzConfig.WriteInteger('Config','Idioma',1);
   OutputDebugStringA('GunProtect] Language found! Portuguese.');
  end else begin
   if LanguageCode = 'es' then begin
    GitzConfig.WriteInteger('Config','Idioma',2);
    OutputDebugStringA('GunProtect] Language found! Spanish.');
    end else begin
    GitzConfig.WriteInteger('Config','Idioma',3); //ingles
    OutputDebugStringA(pchar('GunProtect] Language not found! CountryFlag = '+LanguageCode + ' | English language has been set.'));
   end;
  end;


  if not fileexists(UpdaterPath + 'GitzConfig.ini') then begin
   LanguageCode  :=  _GetCountryFlag;
   if  LanguageCode  = 'pt'  then begin
    GitzConfig.WriteInteger('Config','Idioma',1);
   end else begin
    if LanguageCode = 'es' then begin
     GitzConfig.WriteInteger('Config','Idioma',2);
    end else begin
     GitzConfig.WriteInteger('Config','Idioma',3); //ingles
    end;
   end;
  end else begin
   valueidioma:= (gitzConfig.ReadInteger('Config','Idioma',0));
   if valueidioma = 1 then  begin
    LanguageCode := 'pt';
   end else begin
    if valueidioma = 2 then begin
     LanguageCode := 'es';
    end else begin
     LanguageCode := 'en';
    end;
   end;
  end;

  
     if  not isElevated  then
      begin
        if LanguageCode = 'pt' then begin
          MessageBox(0,'Esse programa precisa ser executado como administrador.'+#13+#10+
                     'Execute o Gitz como administrador e tente novamente!','GunProtect Updater',mb_IconError);

         end else begin
          if LanguageCode = 'es' then begin
            MessageBox(0,'Este programa necessita ser ejecutado como administrador.'+#13+#10+
                     'Abra él Gitz como administrador y intenta nuevamente!','GunProtect Updater',mb_IconError);

          end else begin
            MessageBox(0,'This program needs to be executed as administrator.'+#13+#10+
                     'Open Gitz as administrator and try again.','GunProtect Updater',mb_IconError);

          end;
        end;
        Application.Terminate;
      end;
 // fmrUpdate.mmoLauncherIni.Lines.SaveToFile(UpdaterPath+'NyxLauncher.dll');
  fmrUpdate.lblSpeedText.Caption := '';
  fmrUpdate.lblTimeText.Caption := '';
  fmrUpdate.lblSizeText.Caption := '';
  fmrUpdate.lblSizeValue.Caption := '';
  fmrUpdate.lblTimeValue.Caption := '';
  fmrUpdate.lblSpeedValue.Caption := '';
  fmrUpdate.gPartial.progress := 0;
  fmrUpdate.Visible := true;
  fmrUpdate.tmrInicio.Enabled := true;
  fmrUpdate.lblStatusNow.Caption := updConfig.ReadString(pChar(LanguageCode),'Connecting','');
  fmrUpdate.lblInfo.Caption := addinfo(updConfig.ReadString(pChar(LanguageCode),'Connecting',''));
 finally
  GitzConfig.Free;
  fmrUpdate.Visible := true;
 end;
end;

procedure TfmrUpdate.DownResultHandle(Sender: TObject; ResponseCode: Integer);
begin
  if ResponseCode <> 200 then downloadstr := downloadstr2;
 if (connection=false) then begin
  connection := true;   //para o timeout
  OutputDebugStringA('GunProtect] Connection found!');
  lblInfo.Caption := addinfo(updConfig.ReadString(pChar(LanguageCode),'Decoding',''));
  lblStatusNow.Caption := updConfig.ReadString(pChar(LanguageCode),'Decoding','');
 end;
 //OutputdebugStringA('GunProtect] Last download is done.');
 if fase =2 then begin
  fase2;
 end;

 if fase > 2 then lastcodedown := lastcodedown +1;
 if ((currentcodefile <> 0)) then begin  //não é o filelist
  lblInfo.Caption :=  addinfo(updConfig.ReadString(pChar(LanguageCode),  'End download data',''));
  lblSizeValue.Caption := '';
  lblTimeValue.Caption := '';
  lblSpeedValue.Caption := '';
  gPartial.progress := 0;
  if  FileExists(UpdaterPath + 'updater.log') then begin
   if not DeleteFile(UpdaterPath + 'updater.log') then MessageDlg('Exception code: 0xD2D. Permission denied.', mtError,[mbOk],0);
  end;
   mmoLog.Lines.Add('');
   mmoLog.Lines.Add('[FINAL LOG]');
   mmoLog.Lines.Add('FINAL DATE='+DateToStr(now));
   mmoLog.Lines.Add('FINAL TIME='+TimeToStr(now));
   OutputdebugstringA(pchar('GunProtect] Update file download just ended with code: '+(inttostr(responsecode))));
   destrava := true;
 end else OutputdebugstringA(pchar('GunProtect] Filelist.dat download just ended with code: '+(inttostr(responsecode))));
end;

procedure DeleteFiles(APath, AFileSpec: string);
var
 lSearchRec:TSearchRec;
 lPath:string;
begin
 lPath := IncludeTrailingPathDelimiter(APath);
 if FindFirst(lPath+AFileSpec,faAnyFile,lSearchRec) = 0 then begin
  try
   repeat
    SysUtils.DeleteFile(lPath+lSearchRec.Name);
   until SysUtils.FindNext(lSearchRec) <> 0;
  finally
   SysUtils.FindClose(lSearchRec);  // Free resources on successful find
  end;
  end;
end;

procedure TfmrUpdate.FormCreate(Sender: TObject);
begin
 UpdaterPath  := ExtractFilePath(ParamStr(0));
 OutputDebugStringA(PChar('GunProtect] Updater file path found: "'+ UpdaterPath+'"... Checking parameters.'));
 if ((paramstr(1) = 'nocheck') or (paramstr(1) = '-nocheck')) then begin
  OutputDebugStringA(pchar('GunProtect] nocheck command requested! param: "' + paramstr(1)+'". Starting NyxLauncher...'));
  StartGB('updater');
  OutputDebugStringA('GunProtect] NyxLauncher Started!');
  ExitProcess(0);
 end;

 //ele verifica se tem a imagem na pasta GunProtectUGUI.dat
 //se tiver, ele usa
 //se nao tiver, ele continua com a que está com ele.

 if FileExists(UpdaterPath+'GunProtectBG.png') then begin
   //existe img
   OutputDebugStringA('GunProtect] Loading background picture...');
   imgBG.Picture.LoadFromFile(UpdaterPath+'GunProtectBG.png');
 end else OutputDebugStringA('GunProtect]I couldnt load background picture. File doesnt exists!');

 restart := false;
 killtask('GitzGame.exe');
 killtask('NyxLauncher.exe');
 killtask('UpdaterReplacer.exe');
 killtask('GbSet.exe');
 readPositions;  //posiciona componentes
 currentcodefile := 0;
 DeleteFiles(UpdaterPath,'*.tmp');
 DeleteFiles(UpdaterPath,'*.bak');
 DeleteFiles(UpdaterPath,'*.gp');
 if fileexists('replacelist.dat') then begin
  if not deletefile('replacelist.dat') then MessageDlg('Exception code: 0xD2D. Permission denied.', mtError,[mbOk],0);
 end;
 if fileexists('filelist.dat') then begin
  if not deletefile('filelist.dat') then MessageDlg('Exception code: 0xD2E. Permission denied.', mtError,[mbOk],0);
 end;
 OutPutdebugstringA('GunProtect] Creating Window');

 //if not fileexists(config) then begin    //nao tem updater.ini
  mmoUpdaterini.Lines.SaveToFile(config);
  OutPutdebugstringA('GunProtect] Saving Updater.ini...');
// end ;

  fase :=2;
  OutPutdebugstringA('GunProtect] Updater.ini found. Drawing form.');
  showform;

end;

procedure TfmrUpdate.imgBGMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
   sc_DragMove = $F012;
begin
  ReleaseCapture;
  Perform(wm_SysCommand, sc_DragMove, 0);
end;

procedure TfmrUpdate.SpeedButton1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfmrUpdate.tmrDownloadTimer(Sender: TObject);
var
  i:cardinal;
begin
 fase := 3;
 currentcodefile := 1;
 updConfig :=  TIniFile.Create(UpdaterPath + config);
 if destrava then begin
  if (codedownNOW < Cardinal(downloadlist.Count))  then begin
   if (lastcodedown=codedownNOW) then begin
    OutputDebugStringA(PAnsiChar('GunProtect] File Check ('+IntToStr(codedownnow)+')): "'+downloadlist.Strings[codedownNOW] +'"' ));
    if (((LowerCase(filenamelist.Strings[codedownNOW]) = 'updaterreplacer.exe') or
    (LowerCase(filenamelist.Strings[codedownNOW]) = 'updater.exe')) and (not restart)) then //verifica se é um arquivo crítico
    begin
     OutputDebugStringA('GunProtect] Restart configuration has been set.');
     restart := true;   //restart no fim da extração
    end;
    codedownNOW:=codedownNOW+1;
    download(downloadstr + downloadlist.Strings[codedownNOW-1],downloadlist[codedownNOW-1]);
    destrava := false;
    exit;
   end ;
  end ;
 end else
 exit;
 tmrDownload.enabled:=false;
 abUnZipper1.TempDirectory := TempFolder;
 lblTimeText.caption := '';
 lblSizeText.Caption := '';
 lblStatusNow.Caption := 'Status: ' +  updConfig.ReadString(pChar(LanguageCode),  'DECODING','');
 lblSpeedText.Caption := '';
 lblInfo.Caption := addinfo(updConfig.ReadString(pChar(LanguageCode),  'EXTRACT',''));
 {for i:=0 to filenamelist.Count-1 do begin
  if LowerCase(filenamelist[i]) <> 'updater.exe' then begin //delete todos os arquivos originais antigos
   if FileExists(filenamelist[i]) then begin
    OutputDebugStringA(pansichar('Attempting to delete file: '+ filenamelist[i]));
    if not deletefile(filenamelist.Strings[i]) then MessageDlg('Exception code: 20. Permission denied.', mtError,[mbOk],0); //existe e n deletou
   end;
  end;
 end;    }
 for i:=0 to downloadlist.Count-1 do begin
  //lblSizeText.Caption := updConfig.ReadString(pChar(LanguageCode),  'EXTRACT','');

  lblInfo.Caption := addinfo(updConfig.ReadString(pChar(LanguageCode),  'EXTRACT',''));
  lblStatusNow.Caption := updConfig.ReadString(pChar(LanguageCode),  'EXTRACT','');
  lblInfo.Caption := addinfo(downloadlist.Strings[i] + ' (' +inttostr(i+1)+'/'+inttostr(downloadlist.Count)+')');
  OutputdebugStringA(PAnsiChar('GunProtect] Attempting to extract file: "'+downloadlist[i]+'"'));
  With AbUnZipper1 do begin
   FileName :=  downloadlist.strings[i];
   BaseDirectory := ExtractFilePath(ParamStr(0) );
   ExtractFiles('*.*');
  end;
 end;
 lblInfo.caption := updConfig.ReadString(pChar(LanguageCode),  'FINISH','');
 lblStatusNow.caption := 'Status: ' +  updConfig.ReadString(pChar(LanguageCode),  'FINISH','');
 tmrFinish.enabled := true;
end;

procedure TfmrUpdate.imgCloseClick(Sender: TObject);
begin
 OutPutdebugstringA('GunProtect] CloseQuery asked');
 If  MessageDlg(updConfig.ReadString(pChar(LanguageCode),  'SAIR',''),mtConfirmation,[mbyes,mbno],0)=mryes
 then begin
  freeandnil(updConfig);
  ExitProcess(0);
 end;
end;

procedure TfmrUpdate.imgMinimizarClick(Sender: TObject);
begin
 application.minimize;
end;


procedure TfmrUpdate.tmrInicioTimer(Sender: TObject);
begin
 tmrInicio.Enabled := false;
 OutputdebugStringA('GunProtect] Attempting to download file: "filelist.dat"...');
 lblStatusNow.Caption := lblStatusNow.Caption + ' ' + lowercase(lblSizeText.Caption);
 codedownnow:=0;  //simboliza que está no filelist
 fase := 2;
 OutputdebugStringA('GunProtect] Checking connection...');
 connection := false;
 download(downloadstr+'filelist.dat','filelist.dat');
 tmrConnection.enabled := true;
 OutputdebugStringA('GunProtect] Connecting...');
end;

procedure TfmrUpdate.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 OutputDebugStringA('GunProtect] Exit at closequery');
 ExitProcess(0);
end;

procedure TfmrUpdate.tmrConnectionTimer(Sender: TObject);
begin
// tmrConnection.Enabled := false;

 if (connection = False) then begin
   retrymirror1 := retrymirror1+1;
   tmrConnection.Interval := 3000;
  if retrymirror1>3 then begin
     lblInfo.Caption := addinfo(updConfig.ReadString(pChar(LanguageCode),  'Redirecting',''));
     downloadstr := downloadstr2;
     outputdebugstringa(pchar('GunProtect] TIMEOUT: Connection not found. Retrying Mirror : 1' {+ downloadstr}));
     end else begin
     lblInfo.Caption := addinfo(updConfig.ReadString(pChar(LanguageCode),  'Finding resources',''));
     outputdebugstringa(pchar('GunProtect] TIMEOUT: Connection not found. Retrying Mirror : 2'{+downloadstr}));
  end;

  download(downloadstr+'filelist.dat','filelist.dat');
    if retrymirror1>6 then begin
  tmrTimeoutRelease.enabled := true;
  end;
 end;
end;

procedure TfmrUpdate.tmrTimeoutReleaseTimer(Sender: TObject);
begin
 tmrTimeoutRelease.enabled:=False;
 if (connection = False) then begin
  OutputDebugStringA(pchar('GunProtect] TIMEOUT! NO CONNECTION FOUND. Trying to start game.'));
  StartGB('updater');
  OutputDebugStringA('GunProtect] NyxLauncher Started!');
  exitprocess(0);
 end;
end;

procedure TfmrUpdate.tmrFinishTimer(Sender: TObject);
var i: cardinal;
begin
 //tem que apagar o filelist.dat
 tmrFinish.Enabled := false;
 if FileExists(UpdaterPath+'filelist.dat') then begin
  DeleteFile(UpdaterPath+'filelist.dat');  //esse vai sem if
 end;
 lblTimeText.caption := '';
 gTotal.maxvalue:=100;
 gTotal.progress :=gTotal.maxvalue;
 gPartial.MaxValue:=100;
 gPartial.Progress :=gPartial.maxvalue;
 gPartial.ForeColor := clLime;
 gTotal.ForeColor := clLime;
 Sleep(1000);
 for i:=0 to downloadlist.Count-1 do DeleteFile(downloadlist[i]);
 if restart then begin
  OutputDebugStringA('GunProtect] Restart');
  Replace('restart');
  Sleep(1000);
  exitprocess(0);
 end;
 OutputdebugStringA('GunProtect] UPDATE PROCESS COMPLETE! STARTING NYXLAUNCHER');
 StartGB('updater');
 ExitProcess(0);
end;

end.



