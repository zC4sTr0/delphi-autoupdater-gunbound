unit frmHash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,  Mem_util, Hash, blaks256, ExtCtrls;

type
  TForm1 = class(TForm)
    btn1: TButton;
    edt1: TEdit;
    dlgOpen1: TOpenDialog;
    tmr1: TTimer;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
        procedure ProcessFiles(const FName: string; var blkcnt: longint); // faz hash dos arquivos.
  end;

var
  Form1: TForm1;
  blkcnt: longint;
   buf: array[1..$F000] of byte;   {File read buffer}
    FData: string;                  {Check sums of a file as string}
    bailout: boolean;
    Hashing: boolean;

implementation

{$R *.dfm}



{---------------------------------------------------------------------------}
procedure TForm1.ProcessFiles(const FName: string; var blkcnt: longint);
  {-Process one file}
var
  n: integer;
  Blaks_256Context: THashContext;  Blaks_256Digest: TBlake2S_256Digest;
  f: file;

  function RB(A: longint): longint;
    {-rotate byte of longint}
  begin
    RB := (A shr 24) or ((A shr 8) and $FF00) or ((A shl 8) and $FF0000) or (A shl 24);
  end;

begin

  filemode := 0;
  blkcnt := 0;
  if not FileExists(FName) then
    exit;

  assignfile(f,FName);
  system.reset(f,1);
  if IOresult<>0 then
    exit;

  Blaks256Init(Blaks_256Context);
 // gauge1.maxvalue := round(filesize(f) / sizeof(buf));
  repeat
    application.ProcessMessages;
    if bailout then exit;
    blockread(f,buf,sizeof(buf),n);
    if IOResult<>0 then begin
      break;
    end;
    if n<>0 then begin
     { if ((blkcnt mod 128) = 0) then begin
       gauge1.progress := blkcnt;
      end;}

      inc(blkcnt);
      Blaks256Update(Blaks_256Context,@buf,n);
    end;
  until n<>sizeof(buf);
  closefile(f);
  IOResult;
  Blaks256Final(Blaks_256Context,Blaks_256Digest);
  fdata := Base64Str(@Blaks_256Digest, sizeof(Blaks_256Digest));
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
 if dlgOpen1.execute then
  ProcessFiles(dlgOpen1.filename,blkcnt);
  edt1.text := fdata;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
fdata :='';
end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
 edt1.text := fdata;
end;

end.
