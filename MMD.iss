; MMD installer (Inno Setup 6), built by the Windows workflow.
; The samples are not in the repository (licence). Put "Библиотека сэмплов.vdl" (and, if you
; like, the "Пресеты" folder and preset.json) next to "MMD Setup.exe": the installer copies
; them to Documents\VST DRUMM, so the plugin works on that computer without the sample drive.

#define BuildDir "..\build\VSTDrumm_artefacts\Release"

[Setup]
AppId={{014DF36C-39FB-4521-B604-6CFBB88B43D8}
AppName=MMD
AppVersion=1.0
AppPublisher=Nikola
DefaultDirName={autopf}\MMD
DefaultGroupName=MMD
DisableProgramGroupPage=yes
OutputDir=..\out
OutputBaseFilename=MMD Setup
SetupIconFile=mmd.ico
UninstallDisplayIcon={app}\MMD.exe
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
UninstallDisplayName=MMD

[Languages]
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "Ярлык программы на рабочем столе"; GroupDescription: "Дополнительно:"

[Dirs]
Name: "{userdocs}\VST DRUMM"

[Files]
; the VST3 plugin for Cubase
Source: "{#BuildDir}\VST3\MMD.vst3\*"; DestDir: "{commoncf64}\VST3\MMD.vst3"; Flags: ignoreversion recursesubdirs createallsubdirs
; the standalone program
Source: "{#BuildDir}\Standalone\MMD.exe"; DestDir: "{app}"; DestName: "MMD.exe"; Flags: ignoreversion
; the samples and presets lying next to the installer
Source: "{src}\Библиотека сэмплов.vdl"; DestDir: "{userdocs}\VST DRUMM"; Flags: external skipifsourcedoesntexist ignoreversion
Source: "{src}\Пресеты\*"; DestDir: "{userdocs}\VST DRUMM\Пресеты"; Flags: external skipifsourcedoesntexist recursesubdirs createallsubdirs onlyifdoesntexist
Source: "{src}\preset.json"; DestDir: "{userdocs}\VST DRUMM"; Flags: external skipifsourcedoesntexist onlyifdoesntexist

[Icons]
Name: "{group}\MMD"; Filename: "{app}\MMD.exe"
Name: "{group}\Удалить MMD"; Filename: "{uninstallexe}"
Name: "{autodesktop}\MMD"; Filename: "{app}\MMD.exe"; Tasks: desktopicon

; the program used to be called DRUMSCORE / VST DRUMM: remove the old copies so Cubase
; does not see the plugin twice and the old shortcuts go away
[InstallDelete]
Type: filesandordirs; Name: "{commoncf64}\VST3\VST DRUMM.vst3"
Type: filesandordirs; Name: "{autopf}\DRUMSCORE"
Type: files; Name: "{commondesktop}\DRUMSCORE.lnk"
Type: files; Name: "{userdesktop}\DRUMSCORE.lnk"
Type: files; Name: "{userdesktop}\MMD.lnk"
Type: filesandordirs; Name: "{commonprograms}\DRUMSCORE"
Type: files; Name: "{userprograms}\MMD.lnk"

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
  if not FileExists(ExpandConstant('{src}\Библиотека сэмплов.vdl')) then
    Result := MsgBox('Рядом с установщиком нет файла «Библиотека сэмплов.vdl».' + #13#10 +
                     'Плагин установится, но звуки будет искать на диске с сэмплами.' + #13#10#13#10 +
                     'Продолжить?', mbConfirmation, MB_YESNO) = IDYES;
end;
