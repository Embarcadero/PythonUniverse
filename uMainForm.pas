unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, DosCommand, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Vcl.ComCtrls, System.IOUtils;

type
  TMainForm = class(TForm)
    UniverseImage: TImage;
    PyScripterButton: TButton;
    VideoTutorialsButton: TButton;
    eBookButton: TButton;
    PythonButton: TButton;
    RADStudioButton: TButton;
    DelphiVCLButton: TButton;
    DelphiFMXButton: TButton;
    CMD: TDosCommand;
    NetHTTPClient: TNetHTTPClient;
    ProgressBar: TProgressBar;
    procedure PyScripterButtonClick(Sender: TObject);
    procedure VideoTutorialsButtonClick(Sender: TObject);
    procedure eBookButtonClick(Sender: TObject);
    procedure DelphiVCLButtonClick(Sender: TObject);
    procedure DelphiFMXButtonClick(Sender: TObject);
    procedure RADStudioButtonClick(Sender: TObject);
    procedure PythonButtonClick(Sender: TObject);
    procedure NetHTTPClientRequestCompleted(const Sender: TObject;
      const AResponse: IHTTPResponse);
    procedure NetHTTPClientRequestError(const Sender: TObject;
      const AError: string);
    procedure NetHTTPClientRequestException(const Sender: TObject;
      const AError: Exception);
    procedure NetHTTPClientReceiveData(const Sender: TObject; AContentLength,
      AReadCount: Int64; var AAbort: Boolean);
  private
    { Private declarations }
    FFilename: String;
    procedure AsyncInstall(AURL: string; AFilename: string);
    procedure EnableDownloads(AMessage: string);
    procedure DisableDownloads;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.AsyncInstall(AURL: string; AFilename: string);
begin
  DisableDownloads;
  NetHTTPClient.Asynchronous := True;
  FFilename := TPath.Combine(TPath.GetDownloadsPath,AFilename);
  NetHTTPClient.Get(AURL);
end;

procedure TMainForm.EnableDownloads(AMessage: string);
begin
  MainForm.Caption := MainForm.Hint + ': ' + AMessage;
  ProgressBar.Visible := False;
  PyScripterButton.Enabled := True;
  VideoTutorialsButton.Enabled := True;
  eBookButton.Enabled := True;
  PythonButton.Enabled := True;
  RADStudioButton.Enabled := True;
  DelphiVCLButton.Enabled := True;
  DelphiFMXButton.Enabled := True;
end;

procedure TMainForm.DisableDownloads;
begin
  PyScripterButton.Enabled := False;
  VideoTutorialsButton.Enabled := False;
  eBookButton.Enabled := False;
  PythonButton.Enabled := False;
  RADStudioButton.Enabled := False;
  DelphiVCLButton.Enabled := False;
  DelphiFMXButton.Enabled := False;
  ProgressBar.Visible := True;
end;

procedure TMainForm.DelphiFMXButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "'+DelphiFMXButton.Hint+'"';
  CMD.Execute;
end;

procedure TMainForm.DelphiVCLButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "'+DelphiVCLButton.Hint+'"';
  CMD.Execute;
end;

procedure TMainForm.eBookButtonClick(Sender: TObject);
begin
  AsyncInstall(eBookButton.Hint,'Getting_Started_with_Python_GUI_Development.pdf');
end;

procedure TMainForm.NetHTTPClientReceiveData(const Sender: TObject;
  AContentLength, AReadCount: Int64; var AAbort: Boolean);
begin
  TThread.Synchronize(nil,procedure begin
    ProgressBar.StepIt;
  end);
end;

procedure TMainForm.NetHTTPClientRequestCompleted(const Sender: TObject;
  const AResponse: IHTTPResponse);
begin
  var LMemoryStream := TMemoryStream.Create;
  try
    LMemoryStream.LoadFromStream(AResponse.ContentStream);
    LMemoryStream.SaveToFile(FFilename);
  finally
    LMemoryStream.Free;
  end;

  EnableDownloads('Download complete!');

  CMD.CommandLine := 'cmd /c "'+FFilename+'"';
  CMD.Execute;
end;

procedure TMainForm.NetHTTPClientRequestError(const Sender: TObject;
  const AError: string);
begin
  EnableDownloads(AError);
end;

procedure TMainForm.NetHTTPClientRequestException(const Sender: TObject;
  const AError: Exception);
begin
  EnableDownloads(AError.Message);
end;

procedure TMainForm.PyScripterButtonClick(Sender: TObject);
begin
  ASyncInstall(PyScripterButton.Hint,'PyScripter-4.1.1-x86-Setup.exe');
end;

procedure TMainForm.PythonButtonClick(Sender: TObject);
begin
  ASyncInstall(PythonButton.Hint,'python-3.10.5-amd64.exe');
end;

procedure TMainForm.RADStudioButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "start '+RADStudioButton.Hint+'"';
  CMD.Execute;
end;

procedure TMainForm.VideoTutorialsButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "start '+VideoTutorialsButton.Hint+'"';
  CMD.Execute;
end;

end.
