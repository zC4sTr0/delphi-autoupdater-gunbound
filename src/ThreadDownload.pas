unit ThreadDownload;

interface

uses
  Windows, SysUtils, Classes, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdSSLOpenSSL, IdBaseComponent,dialogs;

type
  //external prototypes
  TOnWorkBeginEvent = procedure(Sender: TThread; AWorkCountMax: Integer) of object;
  TOnWorkEvent = procedure(Sender: TThread; AWorkCount: Integer) of object;
  TOnFinish = procedure(Sender: TObject; ResponseCode: Integer) of object;

  TDownThread = class(TThread)
  private
    { Private declarations }
    HTTP: TIdHTTP;
    FOnWorkBeginEvent: TOnWorkBeginEvent;
    FOnWorkEvent: TOnWorkEvent;
    FOnFinish: TOnFinish;
    cancel:boolean;

    FResponseCode: Integer;
    FURL: string;
    FFileName: String;
    FWorkCountMax: Integer;
    FWorkCount: Integer;
    procedure InternalOnWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
    procedure InternalOnWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
    procedure DoNotifyFinish;
    procedure DoNotifyWorkBegin;
    procedure DoNotifyWork;
  protected
    procedure Execute; override;
  public
    { Public declarations }
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    property URL: String read FURL write FURL;
    property FileName: String read FFileName write FFileName;
    property WorkCountMax: Integer read FWorkCountMax;
    property OnWork: TOnWorkEvent read FOnWorkEvent write FOnWorkEvent;
    property OnWorkBegin: TOnWorkBeginEvent read FOnWorkBeginEvent write FOnWorkBeginEvent;
    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
  end;

implementation

uses FormUpdater;

constructor TDownThread.Create;
begin
  inherited Create(True);
  HTTP := TIdHTTP.Create(nil); // HTTP-Kompo wird dynamisch erstellt
  with HTTP do
  begin
    RecvBufferSize := 1024;
   // SendBufferSize := 512;
    OnWorkBegin := InternalOnWorkBegin;
    Request.UserAgent :=  'Softnyx AutoFetch'; //acho que ele quer usar o proprio updater
    OnWork := InternalOnWork;
// HTTP.IOHandler.RecvBufferSize:=4096; //löst AccessViolation aus !?!
  end;
end;

destructor TDownThread.Destroy;
begin
  cancel := true;
  inherited Destroy;
end;

procedure TDownThread.Execute;
var
  lStream: TFileStream;

begin
  lStream:=TFileStream.Create(FileName, fmCreate or fmShareDenyNone);
  try
    HTTP.Get(FURL, lStream);
    FResponseCode := HTTP.ResponseCode;
  finally
    if Assigned(lStream) then freeandnil(lstream);
  end;
  Synchronize(DoNotifyFinish);
  freeandnil(lstream);
end;

procedure TDownThread.DoNotifyFinish;
begin
  if Assigned(OnFinish) then OnFinish(Self, FResponseCode);
end;
//##############################################################################
procedure TDownThread.InternalOnWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const  AWorkCountMax: Integer);
begin
  FWorkCountMax := AWorkCountMax;
  Synchronize(DoNotifyWorkBegin);
end;

procedure TDownThread.DoNotifyWorkBegin;
begin
  if Assigned(OnWorkBegin) then OnWorkBegin(Self, FWorkCountMax);
end;
//##############################################################################
procedure TDownThread.InternalOnWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
   if cancel then begin
   http.disconnect;
  end;
  FWorkCount := AWorkCount;
  Synchronize(DoNotifyWork);

end;

procedure TDownThread.DoNotifyWork;
begin
  if Assigned(OnWork) then OnWork(Self, FWorkCount);
end;

end.
