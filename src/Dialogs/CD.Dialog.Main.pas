unit CD.Dialog.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  CD.Thread.Manager;

type
  TDialogMain = class(TForm)
    BtnStart: TButton;
    BtnStop: TButton;

    procedure OnBtnStartClick(Sender: TObject);
    procedure OnBtnStopClick(Sender: TObject);
  private
    FThreadManager: TThreadManager;
  public
    { Public declarations }
  end;

var
  DialogMain: TDialogMain;

implementation

{$R *.dfm}

procedure TDialogMain.OnBtnStopClick(Sender: TObject);
begin
  //FChromium.CloseBrowser(True);
end;

procedure TDialogMain.OnBtnStartClick(Sender: TObject);
begin
  FThreadManager := TThreadManager.Create();
end;

end.
