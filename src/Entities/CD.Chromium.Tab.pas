unit CD.Chromium.Tab;

interface

uses
  CD.Interfaces.Chromium.User, uCEFChromium;

type
  TChromiumTabRec = record
    Id: Integer; // used in PostMessage()
    User: IChromiumUser;
    Chromium: TChromium;
    Url: string;

    class function Create(): TChromiumTabRec; static;
    function IsEmpty(): Boolean;
  end;

implementation

{ TChromiumTabRec }

class function TChromiumTabRec.Create: TChromiumTabRec;
begin
  Result.Id := 0;
  Result.User := nil;
  Result.Chromium := nil;
  Result.Url := '';
end;

function TChromiumTabRec.IsEmpty: Boolean;
begin
  Result := (Id < 1);
end;

end.
