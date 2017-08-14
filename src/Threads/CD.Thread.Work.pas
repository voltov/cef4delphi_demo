unit CD.Thread.Work;

interface

uses
  System.Classes, System.SysUtils;

type
  TWorkThread = class(TThread)
  protected
    procedure Execute(); override;
  public
    constructor Create();
    destructor Destroy(); override;
  end;

implementation

{ TWorkThread }

constructor TWorkThread.Create;
begin

end;

destructor TWorkThread.Destroy;
begin

  inherited Destroy();
end;

procedure TWorkThread.Execute;
begin

end;

end.
