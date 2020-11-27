; This is a downloader that was made to be as template-ish as possible for YCE
; 
; This is for the downloader
#pragma include __INCLUDE__ + ";" + ReadReg(HKLM, "Software\Mitrich Software\Inno Download Plugin", "InstallDir")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DEFINES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Common Defines for the application
#define MyAppName "OSET 2020 Installer - Click Here"
#define MyAppShortCut "OSET2020"
#define MyAppVersion "1.1.0.0"
#define MyAppPublisher "Youcanevent"
#define MyAppURL "https://www.youcanevent.com/"
#define MyAppExeName "OSET2020.exe"
; This ones to change things easier between projects
#define MYAppSubFolder "OSET"
#define MyAppOS "Win64"
#define MyAppURL "https://d1hvcan3unaihg.cloudfront.net/game"
#define FileList "FileList.txt"
#define MyAppZip "YCE_OSET_Win64.zip"

; This dll is loaded so we can download things
#include <idp.iss>

; This is for skins
#define VCLStyle "MetroBlue.vsf"

; Fill this out with the path to your built resources
#define YCEDependencies ".\dependencies\oset"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup: Wizard variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
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
SetupIconFile={#YCEDependencies}\icon.ico
Compression=lzma
SolidCompression=yes
UninstallDisplayIcon={app}\{#MyAppExeName}
PrivilegesRequired=none
ExtraDiskSpaceRequired=500048576
DisableWelcomePage=no
DisableDirPage=no
DisableProgramGroupPage=no
DisableReadyPage=no
WizardSmallImageFile={#YCEDependencies}\small.bmp
WizardImageFile={#YCEDependencies}\verticalbanner.bmp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UninstallDelete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[UninstallDelete]
Type: filesandordirs; Name: "{app}"
Type: files; Name: "{app}\{#MyAppZip}"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Languages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Files: Needed files for this to work
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
; Here I load the common files needed in general applications
Source: .\{#YCEDependencies}\horizontalbanner.bmp; Flags: dontcopy
; This is for extra dependencies

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Messages: This is to override default messages that exists in the installer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[Messages]
WelcomeLabel1=Welcome to the OSET2020%nSetup Wizard!%n
WelcomeLabel2=We can't wait to see you!%n%nThis wizard installs OSET 2020 Digital on your computer.%n%nPlease close all other applications and File Explorers before continuing the install.
FinishedHeadingLabel=%nOSET2020 Setup Complete
FinishedLabel=The OSET2020 installation is complete.%n%nPlease jois us in the Virtual World by clicking on the OSET2020 application shortcut installed on your computer.
ClickFinish=Click Finish to exit Setup and launch OSET2020
DiskSpaceMBLabel=At least 2000 MB of free disk space is required.
SelectStartMenuFolderDesc=Where should Setup place the OSET2020 application's shortcuts?
WizardSelectDir=Select Destination Location for Custom Install
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CustomMessages: Add custom messages for labelling in the wizard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[CustomMessages]
installation_form_Caption=OSET 2020 Installation setup
installation_form_Description=Choose which type of installation you want to have
installation_form_WindowsRadioButton_Caption0=Express Install
installation_form_SqlRadioButton_Caption0=Custom Install Location
installation_form_Label1=Type the new Path to install the application
installation_form_Edit1=DefaultDirName
installation_form_Notice=Select Express Install unless instructed/advised by Support Staff%nto do a Custom Installation Location.
custom_install_form_Description=Choose which path where the app will install

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Icons: Creates and adds icons in specified folders
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[Icons]
; Application group section shortcut
Name: "{group}\{#MyAppShortCut}"; Filename: "{app}\{#MyAppExeName}"
; Desktop shortcut
Name: "{commondesktop}\{#MyAppShortCut}"; Filename: "{app}\{#MyAppExeName}"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dirs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[Dirs]
Name: "{app}\"; Permissions: everyone-modify

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Run: What it should do when finishing the installer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[Run]
; Filename: "{app}\Engine\Extras\Redist\en-us\UE4PrereqSetup_x64.exe"; Parameters: "/install /quiet /norestart /silent"; Flags: runascurrentuser nowait postinstall
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: runascurrentuser nowait postinstall 
// skipifsilent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code: Start of code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
[Code]

// Global variables
var 
  FileList: TStringList;
  size: Int64;
  AdvanceInstall: TRadioButton;
  ExpressInstall: TRadioButton;
  useCustomInstall: Boolean;
  HorizontalBanner: TBitmapImage;
  CustomImage: TBitmapImage;
  Page: TInputFileWizardPage;
  NoticeLabel : TLabel;

// Const values
const
  SHCONTCH_NOPROGRESSBOX = 4;
  SHCONTCH_AUTORENAME = 8;
  SHCONTCH_RESPONDYESTOALL = 16;
  SHCONTF_INCLUDEHIDDEN = 128;
  SHCONTF_FOLDERS = 32;
  SHCONTF_NONFOLDERS = 64;
  WM_CLOSE = 16;
// This functions are loaded from the VCLSTyle DLL to load custom skins
// @brief: Import the LoadVCLStyle function from VclStylesInno.DLL
// @param: VClStyleFile: String The name of the skin to load
procedure LoadVCLStyle(VClStyleFile: String); external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall';

// @brief: Import the UnLoadVCLStyles function from VclStylesInno.DLL
procedure UnLoadVCLStyles; external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall';

// @brief: Queueries through the WMIC database
// @param: WbemServices: Variant
// @param: Query: String 
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

// @brief: This is to check min specs in the computer to see if it is worth to install
//         The app on the computer in PC
// @return: True if the computer has min specs or better, False if otherwise
function CollectInformation : Boolean;
var
  Query: string;
  WbemLocator, WbemServices: Variant;
  ComputerSystem, OperatingSystem, Processor, NetworkAdapters, NetworkAdapter: Variant;
  IPAddresses: array of string;
  I, I2 : Integer;
  RAM, Disk, ClockSpeed, VRAM : Extended;
  MinRAM, MinDisk, MinClockSpeed, MinVRAM : Extended;
  Name, Substr : string;
  Family: Integer;
begin

  // Minimum RAM required for the application to run in bytes
  MinRAM := 8000000000.00;
  // Minimum Disk space required for the application to be stored
  MinDisk := 2000000000.00;
  // Minimum clock speed of the processor for the app to run
  MinClockSpeed := 2400.00;
  // Minimum VRAM required for the application to run in bytes
  MinVRAM := 2000000000.00;

  // Default declaration of result
  Result:=True;

  WbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  WbemServices := WbemLocator.ConnectServer('.', 'root\CIMV2');

  // CHECK FOR RAM
  Query := 'SELECT TotalPhysicalMemory FROM Win32_ComputerSystem';
  ComputerSystem := WbemQuery(WbemServices, Query);
  
  // If it was able to get the info of RAM in the computer
  if not VarIsNull(ComputerSystem) then
  begin
    Log(Format('TotalPhysicalMemory=%s', [ComputerSystem.TotalPhysicalMemory]));
    RAM := StrToFloat(Format('%s', [ComputerSystem.TotalPhysicalMemory]));
    
    // If the users RAM is less than the required RAM
    if RAM < MinRAM then
    begin
      // The user can still continue with the installation even if the ram is 
      // less than the minimum, but this way we warn the user about it
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

  // Check for DISK SPACE
  Query := 'SELECT FreeSpace FROM Win32_LogicalDisk';
  OperatingSystem := WbemQuery(WbemServices, Query);
  
  // If it was able to get the info of Disk Space in the computer
  if not VarIsNull(OperatingSystem) then
  begin
    Log(Format('FreeSpace=%s', [OperatingSystem.FreeSpace]));
    Disk := StrToFloat(Format('%s', [OperatingSystem.FreeSpace]));

    // If the user has less than the minimum required Disk
    if Disk < MinDisk then
    begin
      // We have to warn the user about it, and that he has to free up some space
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

  // Check for VRAM
  Query := 'SELECT AdapterRAM, Caption FROM Win32_VideoController';
  OperatingSystem := WbemQuery(WbemServices, Query);
  
  // If it was able to get the info of VRAM in the computer
  if not VarIsNull(OperatingSystem) then
  begin
    Log(Format('VRAM=%s', [OperatingSystem.AdapterRAM]));
    Log(Format('Graphics Card=%s', [OperatingSystem.Caption]));
    VRAM := StrToFloat(Format('%s', [OperatingSystem.AdapterRAM]));

    // If the user has less than the minimum required Disk
    if VRAM < MinVRAM then
    begin
      // We have to warn the user about it, and that he has to free up some space
      if SuppressibleMsgBox('Your Machine has less than the required Video Memory ' + 
                            'to install the application '  + 
                            '(You have ' + 
                            Format('%.0f MB', [VRAM / (1000*1000)]) + 
                            ' and min required is ' + 
                            Format('%.0f MB', [MinVRAM / (1000*1000)])      + 
                            ') Are you sure you want to continue?', mbError, MB_YESNO, IDYES) = IDNO then
      begin
        Result := False;
      end;
    end;
  end;

  (*
  Query := 'SELECT Caption FROM Win32_OperatingSystem';
  OperatingSystem := WbemQuery(WbemServices, Query);
  if not VarIsNull(OperatingSystem) then
  begin
    Log(Format('OperatingSystem=%s', [OperatingSystem.Caption]));
  end;
  *)

  // Check for PROCESSOR
  Query := 'SELECT Name, MaxClockSpeed, Family FROM Win32_Processor';
  Processor := WbemQuery(WbemServices, Query);
  
  // If it was able to get info of the processor
  if not VarIsNull(Processor) then
  begin
    Log(Format('Processor=%s', [Processor.Name]));
    Log(Format('MaxClockSpeed=%s', [Processor.MaxClockSpeed]));
    Log(Format('Family=%s', [Processor.Family]));
    ClockSpeed := StrToFloat(Format('%s', [Processor.MaxClockSpeed]));
    Family := StrToInt(Format('%s', [Processor.Family]));
    Name := Format('%s', [Processor.Name]);
    Log(Name);
    // Checks if processor is intel
    if not (Pos('Intel', Name) = 0) then
    begin
      Substr := Copy(Name, Pos('(TM) ', Name) + 5, 2);
      Log(Substr);
    end
    else


    begin

    end;

    // The computer is an i3 or celeron 
    if (Family = 206) or (Family = 199) or (Family < 198) then
    begin
        if SuppressibleMsgBox('Your Processor is less than the '     + 
                              'required Processor '  + 
                              Name +  
                              ' and min required is ' + 
                              'Intel(R) Core(TM) i5 processor) ' + 
                              'Are you sure you want to continue?', mbError, MB_YESNO, IDYES) = IDNO then
      begin
        Result := False;
      end;
    end; 

    // To know if the processor is useful, we check the clock speed
    // If the clock speed is less than the required
    if ClockSpeed < MinClockSpeed then
    begin
      // Is most definetely that the user won't be able to run the app
      if SuppressibleMsgBox('Your Clock Speed is less than the ' + 
                            'required Clock Speed '  + 
                            '(You have an ' + 
                            Format('%s', [Processor.Name]) + 
                            ' with Clock Speed of ' + 
                            Format('%.0f GHz', [ClockSpeed / 1000])      + 
                            ') Are you sure you want to continue?', mbError, MB_YESNO, IDYES) = IDNO then
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

// @brief: Checks if the user decided wheter to make an express or custom install
// @param: Page: TWizardPage the page that has the button that activated this
// @return: True
function check_install_click(Page: TWizardPage) : Boolean;
begin
  useCustomInstall := False;

  // If the user decided to make a custom install
  if AdvanceInstall.Checked then
  begin
    useCustomInstall := True;
  end;
  Result := True;
end;

// @brief: Default Inno setup initialization
function InitializeSetup(): Boolean;

var 
  winHwnd: Longint;
  retVal : Boolean;
  strProg: string;

begin
	ExtractTemporaryFile('{#VCLStyle}');
	LoadVCLStyle(ExpandConstant('{tmp}\{#VCLStyle}'));
  Result := True;

  //If by any chance the hardware doesn't meet the minimum required specs
  if not CollectInformation then
  begin
    // We inform that the application was not able to be installed in its computer
    SuppressibleMsgBox('OSET was not able to install on your PC', mbError, MB_OK, MB_OK);
    Result := False;
  end;

  try
    //Either use FindWindowByClassName. ClassName can be found with Spy++ included with Visual C++. 
    strProg := 'UnrealWindow';
    winHwnd := FindWindowByClassName(strProg);
    //Or FindWindowByWindowName.  If using by Name, the name must be exact and is case sensitive.
    //strProg := 'Youcan - OSET';
    //winHwnd := FindWindowByWindowName(strProg);
    Log('winHwnd: ' + IntToStr(winHwnd));
    if winHwnd <> 0 then
      Result := PostMessage(winHwnd,WM_CLOSE,0,0);
  except
  end;
end;

// @brief: Default Inno setup de-initialization
procedure DeinitializeSetup();
begin
	UnLoadVCLStyles;
end;


// @brief: Default Wizard initialization. This is to start the UI
procedure InitializeWizard();

var 
  i: Integer;
  requiredDiskSpace: TLabel;
  
begin
  // Default variable definitions
  useCustomInstall := False;

  // Extract files
  ExtractTemporaryFile('horizontalbanner.bmp');

  // Define Wizard UI variables
  WizardForm.CancelButton.Top := WizardForm.CancelButton.Top + 3;
  WizardForm.NextButton.Left := WizardForm.NextButton.Left - 5;
  WizardForm.BackButton.Left := WizardForm.BackButton.Left - 10;
  WizardForm.WelcomeLabel1.Font.Style := [fsBold];
  WizardForm.WelcomeLabel1.Font.Size := 14;
  //WizardForm.WelcomeLabel2.Font.Style := [fsBold];
  WizardForm.WelcomeLabel2.Font.Size := 11;
  WizardForm.PageNameLabel.Font.Size := 9;
  WizardForm.PageDescriptionLabel.Font.Size := 9;
  //WizardForm.PageDescriptionLabel.Font.Style := [fsBold];
  WizardForm.FinishedHeadingLabel.Font.Style := [fsBold];
  WizardForm.FinishedHeadingLabel.Font.Size := 14;
  //WizardForm.FinishedLabel.Font.Style := [fsBold]
  WizardForm.FinishedLabel.Font.Size := 11;
  //WizardForm.ClickFinish.Font.Style := [fsBold];
  //WizardForm.ClickFinish.Font.Size := 11;

  // Creating a page for the installation type
  Page := CreateInputFilePage(
  wpWelcome, 'OSET 2020 Setup Wizard', 'Select Express Install or Custom Install location to choose where to install. Then click Next to continue',
  '' );
  
  // Creating the Horizontal Banner in the installer
  HorizontalBanner := TBitmapImage.Create(Page);
  with HorizontalBanner do
  begin
    Parent := Page.Surface;
    Bitmap.LoadFromFile(ExpandConstant('{tmp}')+'\horizontalbanner.bmp');
    //AutoSize := True;
    Stretch := True;
    Left := 0;
    Top := 75;
    Width := Page.SurfaceWidth;
    Height := 175;
  end;

  // Express install radio button option
  ExpressInstall := TRadioButton.Create(Page);
  with ExpressInstall do
  begin
    Font.Size := 9;
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:installation_form_WindowsRadioButton_Caption0}');
    Left := ScaleX(0);
    Top := ScaleY(10);
    Width := ScaleX(230);
    Height := ScaleY(17);
    Checked := True;
    TabOrder := 1;
    TabStop := True;
  end;
 
 // Custom install radio button option
  AdvanceInstall := TRadioButton.Create(Page);
  with AdvanceInstall do
  begin
    Font.Size := 9;
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:installation_form_SqlRadioButton_Caption0}');
    Left := ScaleX(225);
    Top := ScaleY(10);
    Width := ScaleX(200);
    Height := ScaleY(17);
    TabOrder := 2;
  end;
  
  NoticeLabel := TLabel.Create(Page);
  with NoticeLabel do
  begin
    Font.Size := 9;
    Font.Color := clWhite;
    Parent := Page.Surface;
    Caption := ExpandConstant('{cm:installation_form_Notice}');
    Left := ScaleX(0);
    Top := ScaleY(40);
    Width := Page.SurfaceWidth;
    Height := ScaleY(50);
  end;

  // When clicking on next in the installation type setup define if
  // The wizard skips the extra steps if chosen express
  Page.OnNextButtonClick := @check_install_click;


  // Initialize the information in the IDP DLL
  idpSetOption('InvalidCert', 'ShowDlg');
  
  // idpDownloadFile('{#MyAppURL}/{#MyAppOS}/GameVersion.txt', ExpandConstant('{app}\GameVersion.txt'));
  
  idpAddFile('{#MyAppURL}/{#MyAppOS}/{#MyAppZip}', ExpandConstant('{tmp}\{#MyAppZip}'));
  idpDownloadAfter(wpReady);
  
  // Defining the caption and description of the IDP Form
  IDPForm.Page.Caption := 'Downloading OSET2020 Content'; 
  IDPForm.Page.Description := 'Please wait while Setup downloads additional files...';
  
  // Creating a label of the minimum required free space
  requiredDiskSpace := TLabel.Create(IDPForm.Page)
  with requiredDiskSpace do
  begin
    Parent := IDPForm.Page.Surface;
    Caption := 'At least 2000 MB of free disk space is required.';
    Left := ScaleX(0);
    Top := ScaleY(200);
    Font.Size := 9; 
  end;

end;

// @brief: This function is to unzip any file
// @param: ZipFile: PAnsiChar the file to unzip
// @param: TargetFldr: PAnsiChar the directory to save the unzipped files
procedure unzip(ZipFile, TargetFldr: PAnsiChar);
var
  shellobj: variant;
  ZipFileV, TargetFldrV: variant;
  SrcFldr, DestFldr: variant;
  shellfldritems: variant;
  StatusText: string;
  ResultCode: Integer;

begin
  
  StatusText := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption := 'Unzipping file...';
  WizardForm.ProgressGauge.Style := npbstMarquee;


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

    WizardForm.StatusLabel.Caption := StatusText;
    WizardForm.ProgressGauge.Style := npbstNormal;
end;

// @brief Installs any needed prerequisites before launching the Application
procedure InstallFramework;
var
  StatusText: string;
  ResultCode: Integer;

begin
  StatusText := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption := 'Installing UE4 Prerequisites...';
  WizardForm.ProgressGauge.Style := npbstMarquee;
  try
    // Execute the command of the prerequisite
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

// @brief: Inno setup checks if it should skip a page with defined parameters
// @param: PageID: Integer the id of the page to check if should skip
function ShouldSkipPage(PageID: Integer): Boolean;
begin
  { initialize result to not skip any page (not necessary, but safer) }
  Result := False;
  if (PageID = wpSelectDir) and (not useCustomInstall) then
  begin
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


