unit CD.Url.List;

interface

uses
  System.Classes, System.SysUtils, CD.Constants;

type
  TUrlList = class(TStringList)
  private
    FIndex: Integer;
  public
    constructor Create();
    destructor Destroy(); override;

    function GetNextUrl(): string;
  end;

implementation

{ TUrlList }

constructor TUrlList.Create;
begin
  inherited Create();
  FIndex := 0;
  Self.LoadFromFile(URLS_PATH);
end;

destructor TUrlList.Destroy;
begin

  inherited Destroy();
end;

function TUrlList.GetNextUrl: string;
begin
  Result := '';

  if (FIndex < Self.Count) then
  begin
    Result := Self[FIndex];
    Inc(FIndex);
  end;
end;

end.
