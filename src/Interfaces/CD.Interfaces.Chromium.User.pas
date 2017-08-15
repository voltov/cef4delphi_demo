unit CD.Interfaces.Chromium.User;

interface

type
  IChromiumUser = interface
  ['{CF625562-CE4E-4D55-BC87-F67A8382AA75}']
    procedure OnPageSourceAvailable(const APageSrc: string);
  end;

implementation

end.
