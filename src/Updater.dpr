program Updater;

uses
  Forms,
  dialogs,
  windows,
  
  FormUpdater in 'FormUpdater.pas' {fmrUpdate},
  ThreadDownload in 'ThreadDownload.pas';

{$R *.res}
var
  handle:thandle;
begin
 OutputdebugStringA('THIS PROGRAM IS MADE BY GUNPROTECT');
 OutputdebugStringA('LICENSED TO GITZWC');
 OutputdebugStringA('www.gitzwc.in');
 OutputdebugStringA('GunProtect Updater v2.1c');

  handle := FindWindow(nil,'GunProtect - Auto updater');
   if Handle<>0 then begin
   OutputDebugStringA('GunProtect] Updater is already running. Quitting.');
   if not ISWindowVisible(Handle) then
    showWindow (handle, sw_restore);
    setForegroundWindow(handle);
    Application.Terminate;
  end;


  Application.Initialize;
  Application.CreateForm(TfmrUpdate, fmrUpdate);
  Application.Run;
end.
