; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "DevLauncher"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "sihorton"
!define PRODUCT_WEB_SITE "http://github.com/sihorton/appjs-deskshell/"

!define COMMON_DIR "..\common"
!include "${COMMON_DIR}\register-extensions.nsh"
!include "..\updater\deskshell-updater-supportfn.nsi"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"


var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "Deskshell"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
;!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
;!insertmacro MUI_PAGE_INSTFILES

; Welcome page
;!insertmacro MUI_PAGE_WELCOME
; License page
;!insertmacro MUI_PAGE_LICENSE "c:\path\to\licence\YourSoftwareLicence.txt"
; Instfiles page
;!insertmacro MUI_PAGE_INSTFILES
; Finish page
;!define MUI_FINISHPAGE_RUN "$INSTDIR\AppMainExe.exe"
;!insertmacro MUI_PAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "..\dev-assoc.exe"
InstallDir "$PROGRAMFILES\DevLauncher"

ShowInstDetails hide
ShowUnInstDetails hide

Section "MainSection" SEC01
 Var /GLOBAL MyPath
 
  
   Push "$EXEPATH"
    Call GetParent
    Call GetParent
    Call GetParent
    Pop $MyPath

  ${registerExtension} "$MyPath\deskshell.exe" ".desk" "DeskShell Application"
  ${registerExtension} "$MyPath\deskshell_debug.exe" ".desk-debug" "DeskShell Application Debug"
  ${registerExtension} "$MyPath\deskshell_debug.exe" ".desk-back" "DeskShell Backend Application"
  
SectionEnd

Section -Post
  SetShellVarContext all
  Push "$EXEPATH"
  Call GetParent
  Pop $MyPath

  WriteUninstaller "$MyPath\dev-remove-assoc.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\deskshell.exe"

  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallDir" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\deskshell.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  IfSilent +2 0
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
IfSilent silent noisy
  noisy:
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
  goto ok

  silent:
  SetAutoClose true

  ok:

FunctionEnd

Section Uninstall
  SetShellVarContext all
  
   ${unregisterExtension} ".desk" "DeskShell Application"
   ${unregisterExtension} ".desk-debug" "DeskShell Application Debug"
   ${unregisterExtension} ".desk-back" "DeskShell Backend Application"

 SetAutoClose false
SectionEnd