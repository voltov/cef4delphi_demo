unit CD.Thread.Work;

interface

uses
  System.Classes, System.SysUtils, CD.Chromium.Browser,
  CD.Interfaces.Chromium.User;

type
  TWorkThread = class(TThread, IChromiumUser)
  private
    FUrl: string;
    FIsWaitingForChromium: Boolean;
    FPageSource: string;

    procedure WritePageSource(const APageSource: string);

    // IChromiumUser
    procedure OnPageSourceAvailable(const APageSrc: string);
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  protected
    procedure Execute(); override;
  public
    constructor Create(const AUrl: string); reintroduce;
    destructor Destroy(); override;
  end;

implementation

{ TWorkThread }

constructor TWorkThread.Create(const AUrl: string);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FUrl := AUrl;
end;

destructor TWorkThread.Destroy;
begin

  inherited Destroy();
end;

procedure TWorkThread.Execute;
begin
  FIsWaitingForChromium := True;

  Synchronize(
    procedure
    begin
      TChromiumBrower.GetInstance().OpenChromiumTab(FUrl, Self);
    end
  );

  while FIsWaitingForChromium do
    Sleep(80);

  WritePageSource(FPageSource);

  Synchronize(
    procedure
    begin
      TChromiumBrower.GetInstance().CloseChromiumTab(Self);
    end
  );
end;

procedure TWorkThread.OnPageSourceAvailable(const APageSrc: string);
begin
  FPageSource := APageSrc;
  FIsWaitingForChromium := False;
end;

function TWorkThread.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

procedure TWorkThread.WritePageSource(const APageSource: string);
var
  vStrList: TStringList;
begin
  vStrList := TStringList.Create();
  try
    vStrList.Text := FPageSource;
    vStrList.SaveToFile(IntToStr(Self.ThreadID) + '.html');
  finally
    FreeAndNil(vStrList);
  end;
end;

function TWorkThread._AddRef: Integer;
begin
  Result := -1;
end;

function TWorkThread._Release: Integer;
begin
  Result := -1;
end;

end.
