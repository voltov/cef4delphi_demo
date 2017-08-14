unit CD.Thread.Manager;

interface

uses
  System.Classes, System.SysUtils, System.SyncObjs, CD.Thread.Work;

type
  TThreadManager = class(TThread)
  private
    FUrlList: TStringList;
    FCriticalSection: TCriticalSection;
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

  FUrlList := TStringList.Create();
  FUrlList.LoadFromFile('Urls.txt');
end;

destructor TThreadManager.Destroy;
begin
  FreeAndNil(FCriticalSection);
  FreeAndNil(FUrlList);
  inherited Destroy();
end;

procedure TThreadManager.Execute;
begin

  while (not Terminated) do
  begin



    FCriticalSection.Enter();
    try

    finally
      FCriticalSection.Leave();
    end;

  end;
end;

end.
