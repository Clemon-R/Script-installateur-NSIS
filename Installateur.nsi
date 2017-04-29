!define DOSSIER "C:\Users\raphael\OneDrive\Documents\Source Installateur\installateur"
!define UPLAUNCHER "UpDater"
!define ICON_INSTAL "${DOSSIER}\favicon.ico"
!define ICON_UN "${DOSSIER}\1384072156_27842.ico"
!define HEADER "${DOSSIER}\owny-welcome.bmp"
!define HEADER_HAUT "${DOSSIER}\1-1.bmp"
!define HEADER_LEFT "${DOSSIER}\1th_Ad_for_Dofus_mag_12_by_virak.bmp"
!define DROIT "${DOSSIER}\LICENSE-FR.txt"
!define PRODUCT "ElySium"
!define VERSION "1"
!define URLInfoAbout "http://elysium-game.fr/"
!define YourName "ElySium"
!define LANG "French"

!include "MUI.nsh"

NAME "ElySium"
CRCCheck On
SetCompressor lzma

OutFile "Installateur.exe"
BRANDINGTEXT "${PRODUCT} (c) Tout droit réservé"

InstallDir "$PROGRAMFILES\${PRODUCT}"
InstallDirRegKey HKCU "Software\${PRODUCT}" ""
RequestExecutionLevel admin
!define MUI_ICON "${ICON_INSTAL}"
!define MUI_UNICON "${ICON_UN}"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${HEADER_LEFT}"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${HEADER_LEFT}"
;!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_LICENSE "${DROIT}"
!insertmacro MUI_PAGE_INSTFILES

!define MUI_ABORTWARNING



Function LaunchLink
  ExecShell "" "$INSTDIR\${UPLAUNCHER}.exe"
FunctionEnd

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Lancer ${PRODUCT}"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "${LANG}"

Function .onInit
  SetOutPath $TEMP
  File /oname=spltmp.bmp "${HEADER}"

; optional
; File /oname=spltmp.wav "my_splashshit.wav"

  advsplash::show 1500 600 400 -1 $TEMP\spltmp

  Pop $0 ; $0 has '1' if the user closed the splash screen early,
         ; '0' if everything closed normally, and '-1' if some error occurred.

  Delete "$TEMP\spltmp.bmp"
;  Delete $TEMP\spltmp.wav
FunctionEnd
Section
setOutPath "$INSTDIR"
FILE "${DOSSIER}\${UPLAUNCHER}.exe"
SectionEnd
Section "Bureau"
CreateShortCut "$DESKTOP\${YourName}.lnk" "$INSTDIR\${UPLAUNCHER}.exe" "" "$INSTDIR\${UPLAUNCHER}.exe" 0
SectionEnd
Section "Menu Démarrer"
createDirectory "$SMPROGRAMS\${PRODUCT}"
createShortCut "$SMPROGRAMS\${PRODUCT}\${YourName}.lnk" "$PROGRAMFILES\${PRODUCT}\${UPLAUNCHER}.exe" "" "$PROGRAMFILES\${PRODUCT}\${UPLAUNCHER}.exe" 0
SectionEnd
Section
 CreateShortCut "$SMPROGRAMS\${PRODUCT}\Uninstall.lnk" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0
 WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayName" "${PRODUCT}"
 WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayVersion" "${VERSION}"
 WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "URLInfoAbout" "${URLInfoAbout}"
 WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "Publisher" "${YourName}"
 WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "UninstallString" "$INSTDIR\Uninst.exe"
 WriteRegStr HKCU "Software\${PRODUCT}" "" $INSTDIR
 WriteUninstaller "$INSTDIR\Uninst.exe"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "${PRODUCT} a étais supprimer de ton ordinnateur.."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Tu est sur de vouloir supprimer ${PRODUCT} et tout sais composant ?" IDYES +2
  Abort
FunctionEnd

Section "Uninstall"

Delete "$INSTDIR\*.*"

Delete "$SMPROGRAMS\${PRODUCT}\*.*"
Delete "$DESKTOP\${UPLAUNCHER}.lnk"
RmDir "$SMPROGRAMS\${PRODUCT}"
DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${PRODUCT}"
DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}"
RMDir /r "$INSTDIR"
DeleteRegKey /ifempty HKCU "Software\${PRODUCT}"

SectionEnd