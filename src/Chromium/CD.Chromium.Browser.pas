unit CD.Chromium.Browser;

interface

uses
  System.Classes, System.SysUtils, CD.Interfaces.Chromium.Browser,
  CD.Interfaces.Chromium.User, System.SyncObjs, CD.Chromium.Tab.List,
  CD.Dialog.MsgListener, CD.Constants, uCEFChromium, CD.Chromium.Tab,
  uCEFInterfaces, Winapi.Windows;

type
  TChromiumBrower = class(TObject, IChromiumBrowser)
  private
    FCurrUserId: Integer;
    FCriticalSection: TCriticalSection;
    FChromiumTabList: TChromiumTabList;
    FMsgListener: TDialogMsgListener; // used only to catch Windows Messages

    procedure CreateMsgListenerForm();

    // IChromiumBrowser
    procedure OpenChromiumTab(const AUrl: string; Sender: IChromiumUser);
    procedure CloseChromiumTab(Sender: IChromiumUser);
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;

    procedure OnChromiumLoadEnd(Sender: TObject; const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
    procedure OnChromiumTextResultAvailable(Sender: TObject; const aText: string);
    procedure OnChromiumClose(Sender: TObject; const browser: ICefBrowser; out Result: Boolean);
    procedure OnTabCloseMsg(AId: Integer);
  public
    constructor Create();
    destructor Destroy(); override;

    class function GetInstance(): IChromiumBrowser;
  end;

implementation

var
  Instance: TChromiumBrower = nil;

{ TChromiumBrower }

procedure TChromiumBrower.CloseChromiumTab(Sender: IChromiumUser);
var
  vChromiumTabRec: TChromiumTabRec;
begin
  FCriticalSection.Enter();
  try
    vChromiumTabRec := FChromiumTabList.GetTab(Sender);
    if (not vChromiumTabRec.IsEmpty) then
      vChromiumTabRec.Chromium.CloseBrowser(True);
  finally
    FCriticalSection.Leave();
  end;
end;

constructor TChromiumBrower.Create;
begin
  inherited Create();

  Instance := Self;
  FCurrUserId := 0;
  FCriticalSection := TCriticalSection.Create();
  FChromiumTabList := TChromiumTabList.Create();

  CreateMsgListenerForm();
end;

procedure TChromiumBrower.CreateMsgListenerForm;
begin
  FMsgListener := TDialogMsgListener.Create(nil);
  FMsgListener.OnTabCloseCallback := OnTabCloseMsg;
end;

destructor TChromiumBrower.Destroy;
begin
  FreeAndNil(FMsgListener);
  FreeAndNil(FChromiumTabList);
  FreeAndNil(FCriticalSection);
  inherited;
end;

class function TChromiumBrower.GetInstance: IChromiumBrowser;
begin
  if Assigned(Instance) then
    Exit(Instance);

  Instance := TChromiumBrower.Create();
  Result := Instance;
end;

procedure TChromiumBrower.OnChromiumClose(Sender: TObject;
  const browser: ICefBrowser; out Result: Boolean);
var
  vChromiumTabRec: TChromiumTabRec;
begin
  FCriticalSection.Enter();
  try
    vChromiumTabRec := FChromiumTabList.GetTab(Sender);
    if (not vChromiumTabRec.IsEmpty()) then
      PostMessage(FMsgListener.Handle, CHROMIUM_CLOSE, 0, vChromiumTabRec.Id);
  finally
    FCriticalSection.Leave();
  end;
end;

procedure TChromiumBrower.OnChromiumLoadEnd(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
var
  vChromiumTabRec: TChromiumTabRec;
begin
  if frame.IsMain then
  begin
    FCriticalSection.Enter();
    try
      vChromiumTabRec := FChromiumTabList.GetTab(Sender);

      if (not vChromiumTabRec.IsEmpty) then
        vChromiumTabRec.Chromium.RetrieveHTML();
    finally
      FCriticalSection.Leave();
    end;
  end;
end;

procedure TChromiumBrower.OnChromiumTextResultAvailable(Sender: TObject;
  const aText: string);
var
  vChromiumTabRec: TChromiumTabRec;
begin
  FCriticalSection.Enter();
  try
    vChromiumTabRec := FChromiumTabList.GetTab(Sender);

    if (not vChromiumTabRec.IsEmpty) then
      vChromiumTabRec.User.OnPageSourceAvailable(aText);
  finally
    FCriticalSection.Leave();
  end;
end;

procedure TChromiumBrower.OnTabCloseMsg(AId: Integer);
var
  vChromiumTabRec: TChromiumTabRec;
begin
  FCriticalSection.Enter();
  try
    vChromiumTabRec := FChromiumTabList.GetTab(AId);
    if (not vChromiumTabRec.IsEmpty()) then
    begin
      vChromiumTabRec.Chromium.Free;
      FChromiumTabList.Remove(vChromiumTabRec);
    end;
  finally
    FCriticalSection.Leave();
  end;
end;

procedure TChromiumBrower.OpenChromiumTab(const AUrl: string;
  Sender: IChromiumUser);
var
  vChromium: TChromium;
  vChromiumTabRec: TChromiumTabRec;
begin
  FCriticalSection.Enter();
  try
    // generate unique ID
    Inc(FCurrUserId);
    if (FCurrUserId = MaxInt) then
      FCurrUserId := 1; // just in case

    // create tab
    vChromium := TChromium.Create(nil);
    vChromium.DefaultUrl := AUrl;
    vChromium.OnLoadEnd := OnChromiumLoadEnd;
    vChromium.OnTextResultAvailable := OnChromiumTextResultAvailable;
    vChromium.OnClose := OnChromiumClose;

    // remember this tab
    vChromiumTabRec.Id := FCurrUserId;
    vChromiumTabRec.User := Sender;
    vChromiumTabRec.Chromium := vChromium;
    vChromiumTabRec.Url := AUrl;
    FChromiumTabList.Add(vChromiumTabRec);

    // start tab
    vChromium.CreateBrowser(nil, '');
  finally
    FCriticalSection.Leave();
  end;
end;

function TChromiumBrower.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TChromiumBrower._AddRef: Integer;
begin
  Result := -1;
end;

function TChromiumBrower._Release: Integer;
begin
  Result := -1;
end;

end.
