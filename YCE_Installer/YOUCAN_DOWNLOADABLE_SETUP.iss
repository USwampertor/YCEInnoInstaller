; This is for the downloader
#pragma include __INCLUDE__ + ";" + ReadReg(HKLM, "Software\Mitrich Software\Inno Download Plugin", "InstallDir")

; Defines for the application
#define MyAppName "OSET Installer"
#define MyAppShortCut "OSET Launcher"
#define MyAppVersion "1.0.0.2"
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
#define LaunchpadReleaseDir ".\Win64\OSET"

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

function InitializeSetup(): Boolean;
begin
	ExtractTemporaryFile('{#VCLStyle}');
	LoadVCLStyle(ExpandConstant('{tmp}\{#VCLStyle}'));
	Result := True;
end;

procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;


// This is to start downloading
procedure InitializeWizard();
var i: Integer;

begin
  idpSetOption('InvalidCert', 'ShowDlg');

  idpAddFile('https://d1hvcan3unaihg.cloudfront.net/game/Win64/{#MyAppZip}', ExpandConstant('{tmp}\{#MyAppZip}'));
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
