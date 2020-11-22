; This is for the downloader
#pragma include __INCLUDE__ + ";" + ReadReg(HKLM, "Software\Mitrich Software\Inno Download Plugin", "InstallDir")

; Defines for the application
#define MyAppName "OSET 2020 Installer"
#define MyAppShortCut "OSET2020"
#define MyAppVersion "1.1.0.0"
#define MyAppPublisher "Youcanevent"
#define MyAppURL "https://www.youcanevent.com/"
#define MyAppExeName "OSET2020.exe"
#define MYAppSubFolder "OSET"
#define MyAppOS "Win64"
#define MyAppURL "https://d1hvcan3unaihg.cloudfront.net/game"
#define FileList "FileList.txt"
#define MyAppZip "YCE_OSET_Win64.zip"

; This so we can download things
#include <idp.iss>

; This is for skins
#define VCLStyle "MetroBlue.vsf"

; Fill this out with the path to your built launchpad binaries.
#define YCEDependencies ".\dependencies"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
; App ID for Latino Leaders
; AppId={{6FDB17A1-9AE3-4460-94E3-1801594998F4}
; App ID for OSET
//SignTool=MsSign
AppId={{5ACBA2B4-A874-461C-A898-863DCC1EDC21}}
AppName={#MyAppShortcut}
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
SetupIconFile={#YCEDependencies}\oset.ico
Compression=lzma
SolidCompression=yes
UninstallDisplayIcon={app}\{#MyAppExeName}
PrivilegesRequired=none
ExtraDiskSpaceRequired=500048576
DisableWelcomePage=no
DisableDirPage=no
DisableProgramGroupPage=no
DisableReadyPage=no
WizardSmallImageFile={#YCEDependencies}\osetsmall.bmp
WizardImageFile={#YCEDependencies}\osetBanner.bmp

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
Source: .\{#YCEDependencies}\pikachu.bmp; Flags: dontcopy
Source: .\{#YCEDependencies}\batman.bmp; Flags: dontcopy
Source: .\{#YCEDependencies}\osetlarge.bmp; Flags: dontcopy
; This is for extra dependencies

[Messages]
WelcomeLabel1=Welcome to the OSET2020 Setup Wizard!
WelcomeLabel2=We can't wait to see you! %n%n This wizard installs OSET 2020 Digital on your computer. %n%n Please close all other applications before continuing the install.

[CustomMessages]
installation_form_Caption=OSET 2020 Installation setup
installation_form_Description=Choose which type of installation you want to have
installation_form_WindowsRadioButton_Caption0=Express Install
installation_form_SqlRadioButton_Caption0=Custom Install Location
installation_form_Label1=Type the new Path to install the application
installation_form_Edit1=DefaultDirName
custom_install_form_Description=Choose which path where the app will install

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
  AdvanceInstall: TRadioButton;
  ExpressInstall: TRadioButton;
  useCustomInstall: Boolean;
  ExpressImage: TBitmapImage;
  CustomImage: TBitmapImage;
  Page: TInputFileWizardPage;

function check_install_click(Page: TWizardPage) : Boolean;
begin
  useCustomInstall := False;
  if AdvanceInstall.Checked then
  begin
    useCustomInstall := True;
  end;
  Result := True;
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
var 
  i: Integer;
  
begin
  ExtractTemporaryFile('osetlarge.bmp');


  Page := CreateInputFilePage(
  wpWelcome, 'OSET 2020 Setup Wizard', 'Select Express Install or Custom Install location to choose where to install. Then click Next to continue',
  '' );

  Page.OnNextButtonClick := @check_install_click;

  useCustomInstall := False;
   
  ExpressImage := TBitmapImage.Create(Page);
  with ExpressImage do
  begin
    Parent := Page.Surface;
    Bitmap.LoadFromFile(ExpandConstant('{tmp}')+'\osetlarge.bmp');
    //AutoSize := True;
    Stretch := True;
    Left := 0;
    Top := 50;
    Width := Page.SurfaceWidth;
    Height := 200;
  end;
 (*
  CustomImage := TBitmapImage.Create(Page);
  with CustomImage do
  begin
    Parent := Page.Surface;
    Bitmap.LoadFromFile(ExpandConstant('{tmp}')+'\pikachu.bmp');
    //AutoSize := True;
    Stretch := True;
    Left := ScaleX(225);
    Top := ScaleY(50);
    Width := ScaleX(200);
    Height := ScaleY(200);
  end;*)

  ExpressInstall := TRadioButton.Create(Page);
  with ExpressInstall do
  begin
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:installation_form_WindowsRadioButton_Caption0}');
    Left := ScaleX(0);
    Top := ScaleY(20);
    Width := ScaleX(225);
    Height := ScaleY(17);
    Checked := True;
    TabOrder := 1;
    TabStop := True;
  end;
 
  AdvanceInstall := TRadioButton.Create(Page);
  with AdvanceInstall do
  begin
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:installation_form_SqlRadioButton_Caption0}');
    Left := ScaleX(225);
    Top := ScaleY(20);
    Width := ScaleX(193);
    Height := ScaleY(17);
    TabOrder := 2;
  end;
  
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

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  { initialize result to not skip any page (not necessary, but safer) }
  Result := False;
  { if the page that is asked to be skipped is your custom page, then... }
  if (PageID = wpSelectDir) and (not useCustomInstall) then
  begin
    { if the component is not selected, skip the page }
    Result := True;
  end;
  if (PageID = wpReady) and (not useCustomInstall) then
  begin
    Result := True;
  end;
  if (PageID = wpSelectProgramGroup) and (not useCustomInstall) then
  begin
    { if the component is not selected, skip the page }
    Result := True;
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
  begin
    WizardForm.RunList.Visible := False;
  end;
end;


