unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, DosCommand, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, Vcl.ComCtrls, System.IOUtils, Registry;

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
    PythonComboBox: TComboBox;
    PyScripterComboBox: TComboBox;
    PythonGUIButton: TButton;
    ConsoleMemo: TMemo;
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
    procedure FormCreate(Sender: TObject);
    procedure PythonComboBoxSelect(Sender: TObject);
    procedure PyScripterComboBoxSelect(Sender: TObject);
    procedure PythonGUIButtonClick(Sender: TObject);
    procedure CMDNewLine(ASender: TObject; const ANewLine: string;
      AOutputType: TOutputType);
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

function ReadPythonPath(RegistryKey: String): String;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    if Reg.OpenKey(RegistryKey, False) then
    begin
      try
        if Reg.ValueExists('') then
        begin
          Result := Reg.ReadString('');
        end
        else
          Result := '';
      finally
        Reg.CloseKey;
      end;
    end
    else
      Result := '';
  finally
    Reg.Free;
  end;

end;

function GetPythonPath: String;
begin
  var InstallPath := ReadPythonPath('\SOFTWARE\Python\PythonCore\3.11\InstallPath');
  if InstallPath='' then
    InstallPath := ReadPythonPath('\SOFTWARE\Python\PythonCore\3.10\InstallPath');
  if InstallPath='' then
    InstallPath := ReadPythonPath('\SOFTWARE\Python\PythonCore\3.9\InstallPath');
  if InstallPath='' then
    InstallPath := ReadPythonPath('\SOFTWARE\Python\PythonCore\3.8\InstallPath');
  if InstallPath='' then
    InstallPath := ReadPythonPath('\SOFTWARE\Python\PythonCore\3.7\InstallPath');
  if InstallPath='' then
    InstallPath := ReadPythonPath('\SOFTWARE\Python\PythonCore\3.6\InstallPath');
  Result := InstallPath;
end;

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
  PythonGUIButton.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if (TOSVersion.Architecture = arIntelX86) OR (TOSVersion.Architecture = arARM32) then
  begin
    PyScripterComboBox.ItemIndex := 1;
    PyScripterComboBoxSelect(Self);
    PythonComboBox.ItemIndex := 1;
    PythonComboBoxSelect(Self);
  end
  else if (TOSVersion.Architecture = arIntelX64) OR (TOSVersion.Architecture = arARM64) then
  begin
    PyScripterComboBox.ItemIndex := 0;
    PyScripterComboBoxSelect(Self);
    PythonComboBox.ItemIndex := 0;
    PythonComboBoxSelect(Self);
  end;
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
  PythonGUIButton.Enabled := False;
  ProgressBar.Visible := True;
end;

procedure TMainForm.PythonGUIButtonClick(Sender: TObject);
begin
  CMD.CommandLine := 'cmd /c "start '+PythonGUIButton.Hint+'"';
  CMD.Execute;
end;

procedure TMainForm.CMDNewLine(ASender: TObject; const ANewLine: string;
  AOutputType: TOutputType);
begin
  ConsoleMemo.Lines.Append(ANewLine);
end;

procedure TMainForm.DelphiFMXButtonClick(Sender: TObject);
begin
  ConsoleMemo.Visible := True;
  CMD.CommandLine := 'cmd /c "'+GetPythonPath+'python -m '+DelphiFMXButton.Hint+'"';
  CMD.Execute;
end;

procedure TMainForm.DelphiVCLButtonClick(Sender: TObject);
begin
  ConsoleMemo.Visible := True;
  CMD.CommandLine := 'cmd /c "'+GetPythonPath+'python -m '+DelphiVCLButton.Hint+'"';
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
  ASyncInstall(PyScripterButton.Hint,PyScripterComboBox.Items[PyScripterComboBox.ItemIndex]);
end;

procedure TMainForm.PyScripterComboBoxSelect(Sender: TObject);
begin
  case PyScripterComboBox.ItemIndex of
    0: PyScripterButton.Hint := 'https://downloads.sourceforge.net/project/pyscripter/PyScripter-v4.2/PyScripter-4.2.5-x64-Setup.exe?ts=gAAAAABkZRVS7pmQa1H5KZU4j6ceDjzYW9Amh5qeDpuH_KhrXaDPBs3KuZ5kmWJqUutPvC_S7xru9PkhdUu-jV7nFWXzlu9RFg%3D%3D&use_mirror=gigenet&r=';
    1: PyScripterButton.Hint := 'https://downloads.sourceforge.net/project/pyscripter/PyScripter-v4.2/PyScripter-4.2.5-x86-Setup.exe?ts=gAAAAABkZRXPGyi6Sb5fBk3euOs1lZuIlG6ljIHq_EW3bs2NETTw2Ti9fVnYuEmaSFaocd9eSawhQsTSAwWTZVtwTbDwWM-SgA%3D%3D&use_mirror=versaweb&r=';
  end;
end;

procedure TMainForm.PythonButtonClick(Sender: TObject);
begin
  ASyncInstall(PythonButton.Hint,PythonComboBox.Items[PythonComboBox.ItemIndex]);
end;

procedure TMainForm.PythonComboBoxSelect(Sender: TObject);
begin
  case PythonComboBox.ItemIndex of
    0: PythonButton.Hint := 'https://www.python.org/ftp/python/3.11.3/python-3.11.3-amd64.exe';
    1: PythonButton.Hint := 'https://www.python.org/ftp/python/3.11.3/python-3.11.3.exe';
    3: PythonButton.Hint := 'https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe';
    4: PythonButton.Hint := 'https://www.python.org/ftp/python/3.10.11/python-3.10.11.exe';
    5: PythonButton.Hint := 'https://www.python.org/ftp/python/3.10.5/python-3.10.5-amd64.exe';
    6: PythonButton.Hint := 'https://www.python.org/ftp/python/3.10.5/python-3.10.5.exe';
  end;
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
