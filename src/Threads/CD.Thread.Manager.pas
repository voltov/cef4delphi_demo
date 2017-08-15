unit CD.Thread.Manager;

interface

uses
  System.Classes, System.SysUtils, System.SyncObjs, CD.Thread.Work,
  CD.Constants, System.Generics.Collections, CD.Url.List;

type
  TThreadManager = class(TThread)
  private
    FUrlList: TUrlList;
    FCriticalSection: TCriticalSection;
    FRunningThreadList: TList<TWorkThread>;

    procedure DestroyWorkThreads();
    procedure OnWorkThreadTerminate(Sender: TObject);
  protected
    procedure Execute(); override;
  public
    constructor Create();
    destructor Destroy(); override;
  end;

implementation

{ TThreadManager }

constructor TThreadManager.Create;
begin
  inherited Create(False);

  FreeOnTerminate := True;
  FCriticalSection := TCriticalSection.Create();
  FRunningThreadList := TList<TWorkThread>.Create();
  FUrlList := TUrlList.Create();
end;

destructor TThreadManager.Destroy;
begin
  DestroyWorkThreads();
  FreeAndNil(FCriticalSection);
  FreeAndNil(FUrlList);
  inherited Destroy();
end;

procedure TThreadManager.Execute;
var
  vUrl: string;
  vWorkThread: TWorkThread;
begin
  while (not Terminated) do
  begin
    // we don't want to exceed MAX_THREAD_COUNT
    while (FRunningThreadList.Count >= MAX_THREAD_COUNT) do
      Sleep(80);

    // get next URL for Chromium
    vUrl := FUrlList.GetNextUrl();
    if vUrl.IsEmpty then
    begin
      Terminate();
      Exit();
    end;

    // create Chromium wrapper
    vWorkThread := TWorkThread.Create(vUrl); // FreeOnTerminate := True
    vWorkThread.OnTerminate := OnWorkThreadTerminate;

    // track running "Chromium tabs"
    FCriticalSection.Enter();
    try
      FRunningThreadList.Add(vWorkThread);
    finally
      FCriticalSection.Leave();
    end;

    // start work
    vWorkThread.Start();
  end;
end;

procedure TThreadManager.OnWorkThreadTerminate(Sender: TObject);
begin
  // Chromium wrapper finished work - we can proceed with next URL
  FCriticalSection.Enter();
  try
    if (Sender is TWorkThread) then
      FRunningThreadList.Remove(TWorkThread(Sender));
  finally
    FCriticalSection.Leave();
  end;
end;

procedure TThreadManager.DestroyWorkThreads;
var
  i: Integer;
begin
  for i := 0 to FRunningThreadList.Count - 1 do
    FRunningThreadList[i].Terminate();
  FreeAndNil(FRunningThreadList);
end;

end.
