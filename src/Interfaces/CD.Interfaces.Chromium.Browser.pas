unit CD.Interfaces.Chromium.Browser;

interface

uses
  CD.Interfaces.Chromium.User;

type
  IChromiumBrowser = interface
  ['{5E8E408A-59A9-4376-8B3A-D84C1D0F57AD}']
    procedure OpenChromiumTab(const AUrl: string; Sender: IChromiumUser);
    procedure CloseChromiumTab(Sender: IChromiumUser);
  end;

implementation

end.
