# YCEInnoInstaller
YCE Inno Installer

Built using Inno Script Studio

## Brief

This is an installer "template" to be used for Youcanevent in Inno setup.

The installer's function is to download a zip file from an amazon bucket and unzip it in the specified folder in the configuration settings of the script

Inno setup uses Pascal language and Inno setup library.

## Dependencies

* [Inno Download Plugin (IDP)](https://mitrichsoftware.wordpress.com/inno-setup-tools/inno-download-plugin/)
* [VCL Styles Inno](https://theroadtodelphi.com/2013/12/11/vcl-styles-for-inno-setup/)

The needed dlls should already be in the same folder where it is needed, but in any case.


## Installation

Downloading the [Inno script Studio](https://www.kymoto.org/products/inno-script-studio/) is the best way to handle the inno script

## How to use it

The installer is pretty much documented at this point, and each step of the installer tells what it does:

1. The installer loads the skin defined by VCLStyle. By default has "MetroBlue.vsf"
> #define VCLStyle "MetroBlue.vsf" 
2. After that, it will check the hardware specs. In any chance the computer does not have the required specs, it will show you the specs that you are missing. 
    1. If the user doesn't have enough disk space, the installer will fail. 
    2. If not, the user can opt to continue with the installation, wheter or not he has the minimum specs. 
3. After that, the user will be prompted with the express or custom installer
    1. If the user chooses the express installation, will be skipped to the download
    2. Otherwise, the user will have to go through the steps of choosing path and group folder
3. The installer downloads a zip specified in MyAppURL + MyAppOS + MyAppZip
4. After downloading, it will unzip the file
5. Finally, the installer will try to get the UE4Prerequisites that is in the extras folder
6. After installing, the user will be promted with the finish screen. Clicking finish opens the app

If the installer needs files to be included with it, put them in YCEDependencies
> #define YCEDependencies ".\dependencies\oset"

If you want to change the skin, there is already a set of predefined skins, made by VCLStyle, located in styles folder

### Editable sections

The installer has defined several objects to work on OSET. But for next projects, it should be edited in order to work correctly

```pascal
// This one defines the name of the installer
#define MyAppName "OSET 2020 Installer - Click Here"
// This one defines the shortcut name
#define MyAppShortCut "OSET2020"
// This is the app version
#define MyAppVersion "1.1.0.0"
// This is the app publisher. This will be the folder in ProgramFiles
#define MyAppPublisher "Youcanevent"
// This is the companies page
#define MyAppURL "https://www.youcanevent.com/"
// The name of the executable the installer will try to run at the end of the installation
#define MyAppExeName "OSET2020.exe"
// This is the subfolder that will be inside the MyAppPublisher, to have different versions
#define MYAppSubFolder "OSET"
// This is the folder to find in the aws bucket
#define MyAppOS "Win64"
// This is the bucket to find
#define MyAppURL "https://d1hvcan3unaihg.cloudfront.net/game"
// If the installer needs to download several files, this is the name of the file to save all // the files to install
#define FileList "FileList.txt"
// The zip to find
#define MyAppZip "YCE_OSET_Win64.zip"



// This dll is loaded so we can download things
#include <idp.iss>

// This is for skins
#define VCLStyle "MetroBlue.vsf"

```

The application has a specific GUID. This guid should be defined per installer. If the installer is to be used for another application, it should be regenerated

> AppId={{5ACBA2B4-A874-461C-A898-863DCC1EDC21}}



