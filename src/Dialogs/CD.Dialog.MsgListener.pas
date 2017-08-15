unit CD.Dialog.MsgListener;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CD.Constants;

type
  TIntNotifyEvent = procedure(AId: Integer) of object;

  TDialogMsgListener = class(TForm)
  private
    FOnTabCloseCallback: TIntNotifyEvent;

    procedure OnTabCloseMsg(var aMessage : TMessage); message CHROMIUM_CLOSE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property OnTabCloseCallback: TIntNotifyEvent write FOnTabCloseCallback;
  end;

implementation

{$R *.dfm}

{ TDialogMsgListener }

constructor TDialogMsgListener.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDialogMsgListener.Destroy;
begin
  inherited Destroy();
end;

procedure TDialogMsgListener.OnTabCloseMsg(var aMessage: TMessage);
begin
  if Assigned(FOnTabCloseCallback) then
    FOnTabCloseCallback(aMessage.LParam);
end;

end.
