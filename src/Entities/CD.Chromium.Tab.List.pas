unit CD.Chromium.Tab.List;

interface

uses
  CD.Chromium.Tab, System.Generics.Collections, CD.Interfaces.Chromium.User;

type
  TChromiumTabList = class(TList<TChromiumTabRec>)
  public
    constructor Create();
    destructor Destroy(); override;

    function GetTab(AChromium: TObject): TChromiumTabRec; overload;
    function GetTab(AUser: IChromiumUser): TChromiumTabRec; overload;
    function GetTab(AId: Integer): TChromiumTabRec; overload;
  end;

implementation

{ TChromiumTabList }

constructor TChromiumTabList.Create;
begin
  inherited Create();
end;

destructor TChromiumTabList.Destroy;
begin
  inherited Destroy();
end;

function TChromiumTabList.GetTab(AChromium: TObject): TChromiumTabRec;
var
  i: Integer;
begin
  Result := TChromiumTabRec.Create();

  for i := 0 to Self.Count - 1 do
  begin
    if Self[i].Chromium = AChromium then
      Exit(Self[i]);
  end;
end;

function TChromiumTabList.GetTab(AId: Integer): TChromiumTabRec;
var
  i: Integer;
begin
  Result := TChromiumTabRec.Create();

  for i := 0 to Self.Count - 1 do
  begin
    if Self[i].Id = AId then
      Exit(Self[i]);
  end;
end;

function TChromiumTabList.GetTab(AUser: IChromiumUser): TChromiumTabRec;
var
  i: Integer;
begin
  Result := TChromiumTabRec.Create();

  for i := 0 to Self.Count - 1 do
  begin
    if Self[i].User = AUser then
      Exit(Self[i]);
  end;
end;

end.
