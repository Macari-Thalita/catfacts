program Catfacts;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmCats};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCats, frmCats);
  Application.Run;
end.
