unit CD.Dialog.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  CD.Thread.Manager, CD.Chromium.Browser;

type
  TDialogMain = class(TForm)
    BtnStart: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OnBtnStartClick(Sender: TObject);
  private
    FChromiumBrower: TChromiumBrower;
    FThreadManager: TThreadManager;

    procedure OnThreadManagerTerminate(Sender: TObject);
  public
    { Public declarations }
  end;

var
  DialogMain: TDialogMain;

implementation

{$R *.dfm}

procedure TDialogMain.FormCreate(Sender: TObject);
begin
  // works in main thread. Used by work threads to communicate with TChromium
  FChromiumBrower := TChromiumBrower.Create();
end;

procedure TDialogMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FChromiumBrower);
  if Assigned(FThreadManager) then
    FreeAndNil(FThreadManager);
end;

procedure TDialogMain.OnBtnStartClick(Sender: TObject);
begin
  // all work is done in work threads. Manager thread is used to control work threads
  FThreadManager := TThreadManager.Create();
  FThreadManager.OnTerminate := OnThreadManagerTerminate;
end;

procedure TDialogMain.OnThreadManagerTerminate(Sender: TObject);
begin
  FThreadManager := nil;
end;

end.
