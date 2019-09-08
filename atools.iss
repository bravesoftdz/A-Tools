[Setup]
AppName=A-Tools
AppId=1D95C059-AFA9-4550-B7AD-C5E00ED31F14
AppVerName=A-Tools
AppPublisher=Chensky IT-Services
AppPublisherURL=http://www.a-tools.com/
AppVersion=4.3
AppCopyright=Copyright (C) 1992 - 2019 Chensky IT-Services.

DefaultDirName={pf}\A-Tools
DefaultGroupName=A-Tools
UninstallDisplayIcon={app}\atools.exe
UninstallDisplayName=A-Tools
OutputDir=P:\Programs\A-Tools
OutputBaseFilename=atsetup
ShowLanguageDialog=no
Compression=lzma/ultra
SolidCompression=yes
LanguageDetectionMethod=uilanguage
DisableProgramGroupPage=yes
DisableReadyPage=yes

VersionInfoVersion=4.3
VersionInfoCompany=Chensky IT-Services
VersionInfoCopyright=Copyright (C) 1992 - 2019 Chensky EDV-Services.
VersionInfoDescription=A-Tools
VersionInfoProductName=A-Tools
VersionInfoProductVersion=4.3
VersionInfoTextVersion=4.3

MinVersion=5.0
WizardImageFile=compiler:WizModernImage-IS.bmp
WizardSmallImageFile=P:\Programs\A-Tools\atools.bmp

[Languages]
Name: ENU; MessagesFile: "compiler:Default.isl"; LicenseFile: "P:\Programs\A-Tools\license.rtf"
Name: DEU; MessagesFile: "compiler:Languages\German.isl"; LicenseFile: "P:\Programs\A-Tools\license.rtf"
Name: RUS; MessagesFile: "compiler:Languages\Russian.isl"; LicenseFile: "P:\Programs\A-Tools\license.rtf"

[Messages]
ENU.BeveledLabel=Chensky IT-Services
DEU.BeveledLabel=Chensky IT-Services
RUS.BeveledLabel=Chensky IT-Services

[CustomMessages]

[Files]
Source: "P:\Programs\A-Tools\atools.exe"; DestDir: "{app}";

[Icons]
Name: "{group}\A-Tools"; Filename: "{app}\atools.exe"; WorkingDir: "{app}"

[Registry]
Root: HKLM; Subkey: "Software\A-Tools"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\A-Tools"; ValueName: ""; ValueType: string; ValueData: "{app}"
Root: HKLM; Subkey: "Software\A-Tools"; ValueName: "Lang"; ValueType: string; ValueData: "{language}"
Root: HKCU; Subkey: "Software\A-Tools"; Flags: uninsdeletekey

[Run]
Filename: "{app}\atools.exe"; Parameters: "/install"; WorkingDir: "{app}"; Flags: waituntilterminated
Filename: "{app}\atools.exe"; Description: "A-Tools"; WorkingDir: "{app}"; Flags: postinstall nowait

[UninstallRun]
Filename: "{app}\atools.exe"; Parameters: "/uninstall"; WorkingDir: "{app}"; Flags: waituntilterminated
