program Cef4DelphiDemo;

uses
  Vcl.Forms,
  uCEFApplication,
  uCEFTypes,
  CD.Dialog.Main in 'src\Dialogs\CD.Dialog.Main.pas' {DialogMain},
  CD.Thread.Manager in 'src\Threads\CD.Thread.Manager.pas',
  CD.Thread.Work in 'src\Threads\CD.Thread.Work.pas',
  CD.Constants in 'src\Threads\CD.Constants.pas',
  CD.Url.List in 'src\Entities\CD.Url.List.pas',
  CD.Chromium.Browser in 'src\Chromium\CD.Chromium.Browser.pas',
  CD.Interfaces.Chromium.Browser in 'src\Interfaces\CD.Interfaces.Chromium.Browser.pas',
  CD.Interfaces.Chromium.User in 'src\Interfaces\CD.Interfaces.Chromium.User.pas',
  CD.Chromium.Tab.List in 'src\Entities\CD.Chromium.Tab.List.pas',
  CD.Chromium.Tab in 'src\Entities\CD.Chromium.Tab.pas',
  CD.Dialog.MsgListener in 'src\Dialogs\CD.Dialog.MsgListener.pas' {DialogMsgListener};

{$R *.res}

procedure CreateChromium();
begin
  GlobalCEFApp                      := TCefApplication.Create;

  GlobalCEFApp.FlashEnabled := True;
  GlobalCEFApp.FastUnload   := True; // tabs are closed faster

  GlobalCEFApp.FrameworkDirPath     := 'cef_bin';
  GlobalCEFApp.ResourcesDirPath     := 'cef_bin';
  GlobalCEFApp.LocalesDirPath       := 'cef_bin\locales';
  GlobalCEFApp.cache                := 'cef_bin\cache';
  GlobalCEFApp.cookies              := 'cef_bin\cookies';
  GlobalCEFApp.UserDataPath         := 'cef_bin\User Data';

  GlobalCEFApp.LogFile              := 'chromium.log';
  {$IFDEF DEBUG}
  GlobalCEFApp.LogSeverity          := LOGSEVERITY_VERBOSE;
  {$ELSE}
  GlobalCEFApp.LogSeverity          := LOGSEVERITY_ERROR;
  {$ENDIF}
end;

procedure CreateApplication();
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDialogMain, DialogMain);
  Application.Run;
end;

begin
  CreateChromium();

  if GlobalCEFApp.StartMainProcess() then
    CreateApplication();

  GlobalCEFApp.Free;
end.
