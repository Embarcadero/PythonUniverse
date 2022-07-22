unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, DosCommand, Vcl.Imaging.pngimage;

type
  TMainForm = class(TForm)
    PyScripterButton: TButton;
    VideoTutorialsButton: TButton;
    eBookButton: TButton;
    RADStudioButton: TButton;
    DelphiVCLButton: TButton;
    DelphiFMXButton: TButton;
    CMD: TDosCommand;
    UniverseImage: TImage;
    Button1: TButton;
    Image1: TImage;
    procedure PyScripterButtonClick(Sender: TObject);
    procedure VideoTutorialsButtonClick(Sender: TObject);
    procedure eBookButtonClick(Sender: TObject);
    procedure DelphiVCLButtonClick(Sender: TObject);
    procedure DelphiFMXButtonClick(Sender: TObject);
    procedure RADStudioButtonClick(Sender: TObject);
    procedure RADExporterButtonClick(Sender: TObject);
    procedure Python4DelphiButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.Python4DelphiButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "start https://github.com/pyscripter/MultiInstaller/blob/master/Bin/MultiInstaller.exe"';
  CMD.Execute;
end;

procedure TMainForm.DelphiFMXButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "pip install delphifmx"';
  CMD.Execute;
end;

procedure TMainForm.DelphiVCLButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "pip install delphivcl"';
  CMD.Execute;
end;

procedure TMainForm.eBookButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "start https://lp.embarcadero.com/PythonGUIgettingStarted?utm_source=launcher&utm_medium=link&utm_campaign=python"';
  CMD.Execute;
end;

procedure TMainForm.PyScripterButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "start https://sourceforge.net/projects/pyscripter/files/latest/download"';
  CMD.Execute;
end;

procedure TMainForm.RADExporterButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "start https://github.com/Embarcadero/Delphi4PythonExporter/releases"';
  CMD.Execute;
end;

procedure TMainForm.RADStudioButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "start https://www.embarcadero.com/products/rad-studio/start-for-free?utm_source=launcher&utm_medium=link&utm_campaign=python"';
  CMD.Execute;
end;

procedure TMainForm.VideoTutorialsButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "start https://www.youtube.com/playlist?list=PLwUPJvR9mZHiD7yZTZrArAjb0yLsRoZP9"';
  CMD.Execute;
end;

end.
