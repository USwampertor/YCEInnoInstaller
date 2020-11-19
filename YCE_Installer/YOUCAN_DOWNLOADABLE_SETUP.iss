; This is for the downloader
#pragma include __INCLUDE__ + ";" + ReadReg(HKLM, "Software\Mitrich Software\Inno Download Plugin", "InstallDir")

; Defines for the application
#define MyAppName "OSET Installer"
#define MyAppShortCut "OSET Launcher"
#define MyAppVersion "1.1.0.0"
#define MyAppPublisher "Youcanevent"
#define MyAppURL "https://www.youcanevent.com/"
#define MyAppExeName "YCE.exe"
#define MYAppSubFolder "OSET"
#define MyAppOS "Win64"
#define MyAppURL "https://d1hvcan3unaihg.cloudfront.net/game"
#define FileList "FileList.txt"
#define MyAppZip "YCE_OSET_Win64.zip"

; This so we can download things
#include <idp.iss>

; This is for skins
#define VCLStyle "Windows10Dark.vsf"

; Fill this out with the path to your built launchpad binaries.
#define YCEDependencies ".\dependencies"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
; SignTool=MSign $f
; App ID for Latino Leaders
; AppId={{6FDB17A1-9AE3-4460-94E3-1801594998F4}
; App ID for OSET
AppId={{5ACBA2B4-A874-461C-A898-863DCC1EDC21}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName}                
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={commonpf}\{#MyAppPublisher}\{#MyAppSubFolder}
DefaultGroupName={#MyAppPublisher}
OutputDir=.\installer\{#MyAppSubFolder}
OutputBaseFilename={#MyAppName}
SetupIconFile=.\YCEBanner.ico
Compression=lzma
SolidCompression=yes
UninstallDisplayIcon={app}\{#MyAppExeName}
PrivilegesRequired=none
ExtraDiskSpaceRequired=500048576
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyPage=yes

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
; Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Files]
; This is the executable to include
; Source: "{#LaunchpadReleaseDir}\{#MyAppExeName}"; DestDir: "{app}";
; This is all that should be included in folders
; Source: "{#LaunchpadReleaseDir}\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs
; This are for download setup files
; Source: "{tmp}\FileList.txt"; DestDir: "{app}"; Flags: external; ExternalSize: 1048576
; This is for the reskinner
Source: VclStylesinno.dll; DestDir: {app}; Flags: dontcopy
Source: .\Styles\{#VCLStyle}; DestDir: {app}; Flags: dontcopy
; This is for extra dependencies

[CustomMessages]
authentication_form_Caption=SQL Server Database Setup
authentication_form_Description=Choose SQL Server database you will be using (ask your administrator about its parameters)
authentication_form_Label1_Caption0=Server Name:
authentication_form_Label2_Caption0=Enter Path to SQL Server (e.g. .\SQLEXPRESS; DEVSERVER)
authentication_form_Label3_Caption0=User name:
authentication_form_Label4_Caption0=Password:
authentication_form_ServerNameEdit_Text0=
authentication_form_WindowsRadioButton_Caption0=Use Windows Authentication
authentication_form_SqlRadioButton_Caption0=Use SQL Authentication
authentication_form_UserEdit_Text0=
authentication_form_PasswordEdit_Text0=

[Icons]
Name: "{group}\{#MyAppShortCut}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppShortCut}"; Filename: "{app}\{#MyAppExeName}"
; Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Dirs]
Name: "{app}\"; Permissions: everyone-modify

[UninstallDelete]
Type: files; Name: "{app}\{#MyAppZip}"

[Run]
; Filename: "{app}\Engine\Extras\Redist\en-us\UE4PrereqSetup_x64.exe"; Parameters: "/install /quiet /norestart /silent"; Flags: runascurrentuser nowait postinstall
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: runascurrentuser nowait postinstall 
// skipifsilent

[Code]

var FileList: TStringList;
var size: Int64;

const
  SHCONTCH_NOPROGRESSBOX = 4;
  SHCONTCH_AUTORENAME = 8;
  SHCONTCH_RESPONDYESTOALL = 16;
  SHCONTF_INCLUDEHIDDEN = 128;
  SHCONTF_FOLDERS = 32;
  SHCONTF_NONFOLDERS = 64;

// Import the LoadVCLStyle function from VclStylesInno.DLL
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall';
// Import the UnLoadVCLStyles function from VclStylesInno.DLL
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall';


// Queueries through the WMIC database
function WbemQuery(WbemServices: Variant; Query: string): Variant;
var
  WbemObjectSet: Variant;
begin
  Result := Null;
  WbemObjectSet := WbemServices.ExecQuery(Query);
  if not VarIsNull(WbemObjectSet) and (WbemObjectSet.Count > 0) then
  begin
    Result := WbemObjectSet.ItemIndex(0);
  end;
end;

// This is to check min specs in the computer to see if it is worth to install
// The app on the computer in PC
function CollectInformation : Boolean;
var
  Query: string;
  WbemLocator, WbemServices: Variant;
  ComputerSystem, OperatingSystem, Processor, NetworkAdapters, NetworkAdapter: Variant;
  IPAddresses: array of string;
  I, I2 : Integer;
  RAM, Disk, ClockSpeed : Extended;
  // TempValue : string;
  MinRAM, MinDisk, MinClockSpeed : Extended;
begin

  MinRAM := 8000000000.00;
  MinDisk := 800000000.00;
  MinClockSpeed := 1200.00;

  Result:=True;
  WbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  WbemServices := WbemLocator.ConnectServer('.', 'root\CIMV2');

  Query := 'SELECT TotalPhysicalMemory FROM Win32_ComputerSystem';
  ComputerSystem := WbemQuery(WbemServices, Query);
  if not VarIsNull(ComputerSystem) then
  begin
    Log(Format('TotalPhysicalMemory=%s', [ComputerSystem.TotalPhysicalMemory]));

    // TempValue := Format('%s', [ComputerSystem.TotalPhysicalMemory]);
    RAM := StrToFloat(Format('%s', [ComputerSystem.TotalPhysicalMemory]));
    // Log(Format('TempValue is %f', [RAM]));
  
    if RAM < MinRAM then
    begin
      if SuppressibleMsgBox('Your Machine has less than the minimum RAM '     + 
                            'required for the application to run properly. '  + 
                            '(You have ' + 
                            Format('%.0f GB', [RAM / (1000*1000*1000)]) + 
                            ' and min required is ' + 
                            Format('%.0f GB', [MinRAM / (1000*1000*1000)])      + 
                            ')Are you sure you want to continue?', mbError, MB_YESNO, IDYES) = IDNO then
      begin
        Result := False;
      end;
    end;
  end;

  Query := 'SELECT FreeSpace FROM Win32_LogicalDisk';
  OperatingSystem := WbemQuery(WbemServices, Query);
  if not VarIsNull(OperatingSystem) then
  begin
    Log(Format('FreeSpace=%s', [OperatingSystem.FreeSpace]));
    
    Disk := StrToFloat(Format('%s', [OperatingSystem.FreeSpace]));

    if Disk < MinDisk then
    begin
      if SuppressibleMsgBox('Your Machine has less than the required Disk Space ' + 
                            'to install the application '  + 
                            '(You have ' + 
                            Format('%.0f MB', [Disk / (1000*1000)]) + 
                            ' and min required is ' + 
                            Format('%.0f MB', [MinDisk / (1000*1000)])      + 
                            ') Please free up some space', mbCriticalError, MB_OK, MB_OK) = IDOK then
      begin
        Result := False;
      end;
    end;
  end;

  Query := 'SELECT Caption FROM Win32_OperatingSystem';
  OperatingSystem := WbemQuery(WbemServices, Query);
  if not VarIsNull(OperatingSystem) then
  begin
    Log(Format('OperatingSystem=%s', [OperatingSystem.Caption]));
  end;

  Query := 'SELECT Name, MaxClockSpeed FROM Win32_Processor';
  Processor := WbemQuery(WbemServices, Query);
  if not VarIsNull(Processor) then
  begin
    Log(Format('Processor=%s', [Processor.Name]));
    Log(Format('MaxClockSpeed=%s', [Processor.MaxClockSpeed]));

    ClockSpeed := StrToFloat(Format('%s', [Processor.MaxClockSpeed]));

    if ClockSpeed < MinClockSpeed then
    begin
      if SuppressibleMsgBox('Your Machines Processor is less than the ' + 
                            'required Processor '  + 
                            '(You have an ' + 
                            Format('%s', [Processor.Name]) + 
                            ' with Clock Speed of ' + 
                            Format('%.0f GH', [ClockSpeed / 100])      + 
                            ') Please get in contact with your event' + 
                            ' provider', mbCriticalError, MB_OK, MB_OK) = IDOK then
      begin
        Result := False;
      end;
    end;
  end;
  (*
  Query :=
    'SELECT IPEnabled, IPAddress, MACAddress FROM Win32_NetworkAdapterConfiguration';
  NetworkAdapters := WbemServices.ExecQuery(Query);
  if not VarIsNull(NetworkAdapters) then
  begin
    for I := 0 to NetworkAdapters.Count - 1 do
    begin
      NetworkAdapter := NetworkAdapters.ItemIndex(I);
      if (not VarIsNull(NetworkAdapter.MACAddress)) and NetworkAdapter.IPEnabled then
      begin
        Log(Format('Adapter %d MAC=%s', [I, NetworkAdapter.MACAddress]));
        if not VarIsNull(NetworkAdapter.IPAddress) then
        begin
          IPAddresses := NetworkAdapter.IPAddress;
          for I2 := 0 to GetArrayLength(IPAddresses) - 1 do
          begin
            Log(Format('Adapter %d IP %d=%s', [I, I2, IPAddresses[I2]]));
          end;
        end;
      end;
    end;
  end;
    *)
end;

var
  Label1: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  ServerNameEdit: TEdit;
  WindowsRadioButton: TRadioButton;
  SqlRadioButton: TRadioButton;
  UserEdit: TEdit;
  PasswordEdit: TEdit;
  CustomButtom: TButton;
  SimpleButton: TButton;

function authentication_form_NextButtonClick(Page: TWizardPage): Boolean;
begin
  Result := True;
  if ServerNameEdit.Text <> ''   then
    begin
       if SqlRadioButton.Checked then
       begin
          if UserEdit.Text = ''  then
          begin
             MsgBox('You should enter user name', mbError, MB_OK);
             Result := False;
          end
          else
          begin
            if PasswordEdit.Text = '' then
            begin
               MsgBox('You should enter password', mbError, MB_OK);
               Result := False;
            end
          end
       end
    end
    else
    begin
    MsgBox('You should enter path to SQL Server Database', mbError, MB_OK);
    Result := False;
    end;
end;

function authentication_form_CreatePage(PreviousPageId: Integer): Integer;
var
  Page: TWizardPage;
begin
  Page := CreateCustomPage(
    PreviousPageId,
    ExpandConstant('{cm:authentication_form_Caption}'),
    ExpandConstant('{cm:authentication_form_Description}')
  );

  Label1 := TLabel.Create(Page);
  with Label1 do
  begin
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:authentication_form_Label1_Caption0}');
    Left := ScaleX(16);
    Top := ScaleY(0);
    Width := ScaleX(84);
    Height := ScaleY(17);
  end;
 
  Label2 := TLabel.Create(Page);
  with Label2 do
  begin
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:authentication_form_Label2_Caption0}');
    Left := ScaleX(16);
    Top := ScaleY(56);
    Width := ScaleX(300);
    Height := ScaleY(17);
  end;
 
  Label3 := TLabel.Create(Page);
  with Label3 do
  begin
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:authentication_form_Label3_Caption0}');
    Left := ScaleX(56);
    Top := ScaleY(136);
    Width := ScaleX(70);
    Height := ScaleY(17);
  end;
 
  Label4 := TLabel.Create(Page);
  with Label4 do
  begin
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:authentication_form_Label4_Caption0}');
    Left := ScaleX(56);
    Top := ScaleY(168);
    Width := ScaleX(63);
    Height := ScaleY(17);
  end;
 
  ServerNameEdit := TEdit.Create(Page);
  with ServerNameEdit do
  begin
    Parent := Page.Surface;
    Left := ScaleX(16);
    Top := ScaleY(24);
    Width := ScaleX(257);
    Height := ScaleY(25);
    TabOrder := 0;
    Text := ExpandConstant('{cm:authentication_form_ServerNameEdit_Text0}');
  end;
 
  WindowsRadioButton := TRadioButton.Create(Page);
  with WindowsRadioButton do
  begin
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:authentication_form_WindowsRadioButton_Caption0}');
    Left := ScaleX(16);
    Top := ScaleY(88);
    Width := ScaleX(225);
    Height := ScaleY(17);
    Checked := True;
    TabOrder := 1;
    TabStop := True;
  end;
 
  SqlRadioButton := TRadioButton.Create(Page);
  with SqlRadioButton do
  begin
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:authentication_form_SqlRadioButton_Caption0}');
    Left := ScaleX(16);
    Top := ScaleY(112);
    Width := ScaleX(193);
    Height := ScaleY(17);
    TabOrder := 2;
  end;
 
  UserEdit := TEdit.Create(Page);
  with UserEdit do
  begin
    Parent := Page.Surface;
    Left := ScaleX(136);
    Top := ScaleY(136);
    Width := ScaleX(121);
    Height := ScaleY(25);
    TabOrder := 3;
    Text := ExpandConstant('{cm:authentication_form_UserEdit_Text0}');
  end;
 
  PasswordEdit := TEdit.Create(Page);
  with PasswordEdit do
  begin
    Parent := Page.Surface;
    Left := ScaleX(136);
    Top := ScaleY(168);
    Width := ScaleX(121);
    Height := ScaleY(25);
    TabOrder := 4;
    PasswordChar := '*';
    Text := ExpandConstant('{cm:authentication_form_PasswordEdit_Text0}');
  end;

  with Page do
  begin
    OnNextButtonClick := @authentication_form_NextButtonClick;
  end;

  Result := Page.ID;
end;

function InitializeSetup(): Boolean;
begin
	ExtractTemporaryFile('{#VCLStyle}');
	LoadVCLStyle(ExpandConstant('{tmp}\{#VCLStyle}'));
  Result := True;
  if not CollectInformation then
  begin
    SuppressibleMsgBox('OSET was not able to install on your PC', mbError, MB_OK, MB_OK);
    Result := False;
  end;
end;

procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;


// This is to start downloading
procedure InitializeWizard();
var i: Integer;

begin
  authentication_form_CreatePage(wpLicense);
  idpSetOption('InvalidCert', 'ShowDlg');
  // idpDownloadFile('{#MyAppURL}/{#MyAppOS}/GameVersion.txt', ExpandConstant('{app}\GameVersion.txt'));
  idpAddFile('{#MyAppURL}/{#MyAppOS}/{#MyAppZip}', ExpandConstant('{tmp}\{#MyAppZip}'));
  idpDownloadAfter(wpReady);
end;

// This is to unzip
procedure unzip(ZipFile, TargetFldr: PAnsiChar);
var
  shellobj: variant;
  ZipFileV, TargetFldrV: variant;
  SrcFldr, DestFldr: variant;
  shellfldritems: variant;
begin
  if FileExists(ZipFile) then begin
    ForceDirectories(TargetFldr);
    shellobj := CreateOleObject('Shell.Application');
    ZipFileV := string(ZipFile);
    TargetFldrV := string(TargetFldr);
    SrcFldr := shellobj.NameSpace(ZipFileV);
    DestFldr := shellobj.NameSpace(TargetFldrV);
    shellfldritems := SrcFldr.Items;
    DestFldr.CopyHere(shellfldritems, SHCONTCH_NOPROGRESSBOX or SHCONTCH_RESPONDYESTOALL);  
  end;
end;

procedure InstallFramework;
var
  StatusText: string;
  ResultCode: Integer;
begin
  StatusText := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption := 'Installing UE4 Prerequisites...';
  WizardForm.ProgressGauge.Style := npbstMarquee;
  try
    if not Exec(ExpandConstant('{app}\Engine\Extras\Redist\en-us\UE4PrereqSetup_x64.exe'), '/install /quiet /norestart /q', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
    begin
      { you can interact with the user that the installation failed }
      MsgBox('UE4 Prerequisites failed with code: ' + IntToStr(ResultCode) + '.',
              mbError, 
              MB_OK);
    end;
  finally
    WizardForm.StatusLabel.Caption := StatusText;
    WizardForm.ProgressGauge.Style := npbstNormal;
  end;
end;

// This procedure is called per each file downloaded
procedure CurStepChanged(CurStep: TSetupStep);
// var i: Integer;
var
  Shell: Variant;
  ZipFile: Variant;
  TargetFolder: Variant;
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then 
  begin
    unzip(ExpandConstant('{tmp}\{#MyAppZip}'), ExpandConstant('{app}\'));
    InstallFramework();
    // Exec(ExpandConstant('{app}\Engine\Extras\Redist\en-us\UE4PrereqSetup_x64.exe'), '/install /quiet /norestart', ExpandConstant('{app}'), SHCONTCH_RESPONDYESTOALL, ewWaitUntilTerminated, ResultCode);
  end;
end;

// This is to leave everything without checkboxes
procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then
    WizardForm.RunList.Visible := False;
end;


