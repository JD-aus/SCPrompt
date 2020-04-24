;This is just a template. You need some coding by yourself with it.
RequestExecutionLevel user
ShowInstDetails "nevershow"


!define PRODUCT_NAME "SCPrompt"
!define PRODUCT_DIR "scprompt"
!define PRODUCT_APPLICATION "scprompt"
!define PRODUCT_VERSION "0.10.11.44"
!define PRODUCT_PUBLISHER "Secure Technology Group"
!define PRODUCT_WEB_SITE "www.vnc2me.org/scprompt/"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKCU"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_NAME}"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"

VIProductVersion "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" ""
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "${PRODUCT_PUBLISHER}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "Secure Technology Group Pty Ltd"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" ""
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${PRODUCT_VERSION}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "InternalName" "${INTERNAL_NAME}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "${PRODUCT_NAME} is a trademark of ${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "${PRODUCT_NAME} is a trademark of Secure Technology Group Pty Ltd"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "OriginalFilename" "${ORIGINAL_FILENAME}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "PrivateBuild" "${PRIVATE_BUILD}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "SpecialBuild" "${SPECIAL_BUILD}"


;!include "MUI2.nsh"

;SetCompressor "bzip2"
;SetCompressor LZMA
SetCompressor /SOLID lzma
;Page directory
UninstPage uninstConfirm


;--------------------------------
VAR APPLICATION_COMMON_FOLDER

; The stuff to install
Section "Appdatatool (compulsory)"

  SectionIn RO  

  Call GetParameters
  Pop $0
  
  ; Retrieving CommonApplicationData path (in $1)
  System::Call "shfolder::SHGetFolderPath(i $HWNDPARENT, i 0x0023, i 0, i 0, t.r1)"
  StrCpy $APPLICATION_COMMON_FOLDER "$1\$0"
  
  
;  CreateDirectory $APPLICATION_COMMON_FOLDER
  
  # Make the directory "$APPLICATION_COMMON_FOLDER\application name"
  # read write delete accessible by all users
  ; SID instead of BU as users (it works also on Windows 2000)
;	AccessControl::GrantOnFile \
;	"$APPLICATION_COMMON_FOLDER" "(S-1-5-32-545)" 
;	"GenericRead + GenericWrite + Delete"
SectionEnd

Name "${PRODUCT_NAME} - ${PRODUCT_VERSION}"
ReserveFile "..\${PRODUCT_DIR}\scprompt.ini"
OutFile "..\${PRODUCT_NAME}_${PRODUCT_VERSION}.exe"
;InstallDir "$APPLICATION_COMMON_FOLDER\${PRODUCT_NAME}"
;InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
InstallDir "$LOCALAPPDATA\${PRODUCT_NAME}"

Icon "..\${PRODUCT_DIR}\Logo.ico"
UninstallIcon "..\${PRODUCT_DIR}\Logo.ico"
;LicenseText " "
LicenseData "..\${PRODUCT_DIR}\License.txt"
;DirText " "
ShowInstDetails "nevershow"
;ShowInstDetails show
ShowUnInstDetails show



Section "Main"
	HideWindow
	SetSilent silent
	SetOutPath "$INSTDIR"
	File "..\${PRODUCT_DIR}\*" ;write here path to your program file
	;File "";write here path to your program other files

;create the uninstaller application
	WriteUninstaller "$INSTDIR\${PRODUCT_APPLICATION}_Uninst.exe"

;create desktop shortcut
	CreateShortCut "$DESKTOP\Start ${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_APPLICATION}.exe" ""
	CreateShortCut "$DESKTOP\Remove ${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_APPLICATION}_Uninst.exe" "" "$INSTDIR\${PRODUCT_APPLICATION}_Uninst.exe" 0

;create start-menu items
;	CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
;	CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
;	CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe" "" "$INSTDIR\${PRODUCT_NAME}.exe" 0

;write uninstall information to the registry
;	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME} (remove only)"
;	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\Uninstall.exe"

;	WriteUninstaller "$INSTDIR\Uninstall.exe"
	ExecWait '"$INSTDIR\${PRODUCT_APPLICATION}.exe"'
	IfErrors DONE
	;Delete Files 
	RMDir /r "$INSTDIR\*.*"    
	;Remove the installation directory
	RMDir "$INSTDIR"
	;Delete Application Shortcuts
	Delete "$DESKTOP\Start ${PRODUCT_NAME}.lnk"
	Delete "$DESKTOP\Remove ${PRODUCT_NAME}.lnk"
	
	done:
	SetAutoClose true

SectionEnd


Section "Uninstall"
;Delete Files 
	RMDir /r "$INSTDIR\*.*"

;Remove the installation directory
	RMDir "$INSTDIR"
 
;Delete Start Menu Shortcuts
	Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
	Delete "$SMPROGRAMS\${PRODUCT_NAME}\*.*"
	RmDir  "$SMPROGRAMS\${PRODUCT_NAME}"
 
;Delete Uninstaller And Unistall Registry Entries
;	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${PRODUCT_NAME}"
;	DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"  

SetAutoClose true
SectionEnd


; GetParameters
; input, none
; output, top of stack (replaces, with e.g. whatever)
; modifies no other variables.
 
Function GetParameters
 
	Push $R0
	Push $R1
	Push $R2
	Push $R3
   
	StrCpy $R2 1
	StrLen $R3 $CMDLINE
   
	;Check for quote or space
	StrCpy $R0 $CMDLINE $R2
	StrCmp $R0 '"' 0 +3
		StrCpy $R1 '"'
		Goto loop
	StrCpy $R1 " "
   
	loop:
		IntOp $R2 $R2 + 1
		StrCpy $R0 $CMDLINE 1 $R2
		StrCmp $R0 $R1 get
		StrCmp $R2 $R3 get
		Goto loop
   
	get:
		IntOp $R2 $R2 + 1
		StrCpy $R0 $CMDLINE 1 $R2
		StrCmp $R0 " " get
		StrCpy $R0 $CMDLINE "" $R2

	Pop $R3
	Pop $R2
	Pop $R1
	Exch $R0

FunctionEnd

;Load INI to read vars from ...
Function .onInit

  ;Extract InstallOptions files
  ;$PLUGINSDIR will automatically be removed when the installer closes
  
	InitPluginsDir
	File /oname=$PLUGINSDIR\scprompt.ini "..\${PRODUCT_DIR}\scprompt.ini"
;	ReadINIStr ${PRODUCT_NAME} "$PLUGINSDIR\scprompt.ini" "Common" "APPName"
  
FunctionEnd
