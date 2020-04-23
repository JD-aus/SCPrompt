#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\scprompt\logo.ico
#AutoIt3Wrapper_Outfile=..\scprompt\scprompt.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=SCPrompt - Creates reverse VNC connections to a viewer or repeater, using settings in SCPrompt.INI
#AutoIt3Wrapper_Res_Description=SCPrompt - Creates reverse VNC connections to a viewer or repeater, using settings in SCPrompt.INI
#AutoIt3Wrapper_Res_Fileversion=2.12.7.52
#AutoIt3Wrapper_Res_LegalCopyright="© www.securetech.com.au (Secure Technology Group) 2009-2010 (AGPL)"
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Icon_Add=..\scprompt\icon1.ico
#AutoIt3Wrapper_Res_Icon_Add=..\scprompt\icon2.ico
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponlyincludes
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region Compiler Options ;**** Directives created by AutoIt3Wrapper_GUI ****
Global $DebugLevel = "9", $DEBUGLOG = 0, $return, $AppINI = @ScriptDir & "\scprompt.ini", $TimeStampLoop[3], $INI_RemoteINI
Global $V2M_EventDisplay, $V2M_VNC_UVNC = "winvnc.exe", $V2M_VNC_VWR, $V2M_VNC_SVR, $V2M_VNC_SC
; New translation stuff - uses inireadsection
Global $INI_CommonSection = IniReadSection($AppINI, "Common")
Global $INI_GUISection = IniReadSection($AppINI, "GUI")
Global $INI_ColourSection = IniReadSection($AppINI, "Colour")
Global $INI_SCSection = IniReadSection($AppINI, "SC")
Global $KnownVncFlavour = ''
Const $DWM_EC_DISABLECOMPOSITION = 0x00000000
Const $DWM_EC_ENABLECOMPOSITION = 0x00000001
Global $V2M_Exit
Global Const $AC_SRC_ALPHA = 1
Global $STG_Language_File, $V2M_GUI_Language, $GUIActiveX, $INI_Translation_Section
Global $OSLangNames1[163][2] = [[163, 2], ['0000', 'LANG_NEUTRAL'], ['007f', 'LANG_INVARIANT'], ['0400', 'LANG_NEUTRAL'], ['0401', 'LANG_ARABIC'], ['0402', 'LANG_BULGARIAN'], ['0403', 'LANG_CATALAN'], ['0404', 'LANG_CHINESE_TRADITIONAL'], ['0405', 'LANG_CZECH'], ['0406', 'LANG_DANISH'], ['0407', 'LANG_GERMAN'], ['0408', 'LANG_GREEK'], ['0409', 'LANG_ENGLISH'], ['040b', 'LANG_FINNISH'], ['040c', 'LANG_FRENCH'], ['040d', 'LANG_HEBREW'], ['040e', 'LANG_HUNGARIAN'], ['040f', 'LANG_ICELANDIC'], ['0410', 'LANG_ITALIAN'], ['0411', 'LANG_JAPANESE'], ['0412', 'LANG_KOREAN'], ['0413', 'LANG_DUTCH'], ['0414', 'LANG_NORWEGIAN'], ['0415', 'LANG_POLISH'], ['0416', 'LANG_PORTUGUESE'], ['0417', 'LANG_ROMANSH'], ['0418', 'LANG_ROMANIAN'], ['0419', 'LANG_RUSSIAN'], ['041a', 'LANG_CROATIAN'], ['041a', 'LANG_CROATIAN'], ['041b', 'LANG_SLOVAK'], ['041c', 'LANG_ALBANIAN'], ['041d', 'LANG_SWEDISH'], ['041d', 'LANG_SWEDISH'], ['041e', 'LANG_THAI'], ['041f', 'LANG_TURKISH'], ['0420', 'LANG_URDU'], ['0421', 'LANG_INDONESIAN'], ['0422', 'LANG_UKRAINIAN'], ['0423', 'LANG_BELARUSIAN'], ['0424', 'LANG_SLOVENIAN'], ['0425', 'LANG_ESTONIAN'], ['0426', 'LANG_LATVIAN'], ['0427', 'LANG_LITHUANIAN'], ['0428', 'LANG_TAJIK'], ['0429', 'LANG_FARSI'], ['042a', 'LANG_VIETNAMESE'], ['042b', 'LANG_ARMENIAN'], ['042c', 'LANG_AZERI'], ['042d', 'LANG_BASQUE'], ['042e', 'LANG_UPPER_SORBIAN'], ['042f', 'LANG_MACEDONIAN'], ['0432', 'LANG_TSWANA'], ['0434', 'LANG_XHOSA'], ['0435', 'LANG_ZULU'], ['0436', 'LANG_AFRIKAANS'], ['0437', 'LANG_GEORGIAN'], ['0438', 'LANG_FAEROESE'], ['0439', 'LANG_HINDI'], ['043a', 'LANG_MALTESE'], ['043b', 'LANG_SAMI'], ['043e', 'LANG_MALAY'], ['043f', 'LANG_KAZAK'], ['0440', 'LANG_KYRGYZ'], ['0441', 'LANG_SWAHILI'], ['0442', 'LANG_TURKMEN'], ['0443', 'LANG_UZBEK'], ['0444', 'LANG_TATAR'], ['0445', 'LANG_BENGALI'], ['0446', 'LANG_PUNJABI'], ['0447', 'LANG_GUJARATI'], ['0448', 'LANG_ORIYA'], ['0449', 'LANG_TAMIL'], ['044a', 'LANG_TELUGU'], ['044b', 'LANG_KANNADA'], ['044c', 'LANG_MALAYALAM'], ['044d', 'LANG_ASSAMESE'], ['044e', 'LANG_MARATHI'], ['044f', 'LANG_SANSKRIT'], ['0450', 'LANG_MONGOLIAN'], ['0451', 'LANG_TIBETAN'], ['0452', 'LANG_WELSH'], ['0453', 'LANG_KHMER'], ['0454', 'LANG_LAO'], ['0456', 'LANG_GALICIAN'], ['0457', 'LANG_KONKANI'], ['045a', 'LANG_SYRIAC'], ['045b', 'LANG_SINHALESE'], ['045d', 'LANG_INUKTITUT'], ['045e', 'LANG_AMHARIC'], ['0461', 'LANG_NEPALI'], ['0462', 'LANG_FRISIAN'], ['0463', 'LANG_PASHTO'], ['0464', 'LANG_FILIPINO'], ['0465', 'LANG_DIVEHI'], ['0468', 'LANG_HAUSA'], ['046a', 'LANG_YORUBA'], ['046b', 'LANG_QUECHUA'], ['046c', 'LANG_SOTHO'], ['046d', 'LANG_BASHKIR'], ['046e', 'LANG_LUXEMBOURGISH'], ['046f', 'LANG_GREENLANDIC'], ['0470', 'LANG_IGBO'], ['0478', 'LANG_YI'], ['047a', 'LANG_MAPUDUNGUN'], ['047c', 'LANG_MOHAWK'], ['047e', 'LANG_BRETON'], ['0480', 'LANG_UIGHUR'], ['0481', 'LANG_MAORI'], ['0482', 'LANG_OCCITAN'], ['0483', 'LANG_CORSICAN'], ['0484', 'LANG_ALSATIAN'], ['0485', 'LANG_YAKUT'], ['0486', 'LANG_KICHE'], ['0487', 'LANG_KINYARWANDA'], ['0488', 'LANG_WOLOF'], ['048c', 'LANG_DARI'], ['0800', 'LANG_NEUTRAL'], ['0801', 'LANG_ARABIC'], ['0804', 'LANG_CHINESE_SIMPLIFIED'], ['0807', 'LANG_GERMAN'], ['0809', 'LANG_ENGLISH'], ['080a', 'LANG_SPANISH'], ['080c', 'LANG_FRENCH'], ['0810', 'LANG_ITALIAN'], ['0813', 'LANG_DUTCH'], ['0814', 'LANG_NORWEGIAN'], ['0816', 'LANG_PORTUGUESE'], ['0816', 'LANG_PORTUGUESE'], ['081a', 'LANG_SERBIAN'], ['081d', 'LANG_SWEDISH'], ['0820', 'LANG_URDU'], ['082c', 'LANG_AZERI'], ['082e', 'LANG_LOWER_SORBIAN'], ['083b', 'LANG_SAMI'], ['083c', 'LANG_IRISH'], ['083e', 'LANG_MALAY'], ['0843', 'LANG_UZBEK'], ['0850', 'LANG_MONGOLIAN'], ['085d', 'LANG_INUKTITUT'], ['085f', 'LANG_TAMAZIGHT'], ['086b', 'LANG_QUECHUA'], ['0C00', 'LANG_NEUTRAL'], ['0c01', 'LANG_ARABIC'], ['0c04', 'LANG_CHINESE'], ['0c07', 'LANG_GERMAN'], ['0c09', 'LANG_ENGLISH'], ['0c0a', 'LANG_SPANISH'], ['0c0c', 'LANG_FRENCH'], ['0c1a', 'LANG_SERBIAN'], ['0c3b', 'LANG_SAMI'], ['0c6b', 'LANG_QUECHUA'], ['1000', 'LANG_NEUTRAL'], ['1001', 'LANG_ARABIC'], ['1004', 'LANG_CHINESE'], ['1007', 'LANG_GERMAN'], ['1009', 'LANG_ENGLISH'], ['100a', 'LANG_SPANISH'], ['100c', 'LANG_FRENCH'], ['101a', 'LANG_CROATIAN'], ['103b', 'LANG_SAMI'], ['1400', 'LANG_NEUTRAL'], ['1401', 'LANG_ARABIC']]
Global $OSLangNames2[55][2] = [[55, 2], ['1404', 'LANG_CHINESE'], ['1407', 'LANG_GERMAN'], ['1409', 'LANG_ENGLISH'], ['140a', 'LANG_SPANISH'], ['140c', 'LANG_FRENCH'], ['141a', 'LANG_BOSNIAN'], ['143b', 'LANG_SAMI'], ['1801', 'LANG_ARABIC'], ['1809', 'LANG_ENGLISH'], ['1809', 'LANG_ENGLISH'], ['180a', 'LANG_SPANISH'], ['180c', 'LANG_FRENCH'], ['181a', 'LANG_SERBIAN'], ['183b', 'LANG_SAMI'], ['1c01', 'LANG_ARABIC'], ['1c09', 'LANG_ENGLISH'], ['1c0a', 'LANG_SPANISH'], ['1c3b', 'LANG_SAMI'], ['2001', 'LANG_ARABIC'], ['2009', 'LANG_ENGLISH'], ['200a', 'LANG_SPANISH'], ['201a', 'LANG_BOSNIAN'], ['203b', 'LANG_SAMI'], ['2401', 'LANG_ARABIC'], ['2409', 'LANG_ENGLISH'], ['240a', 'LANG_SPANISH'], ['243b', 'LANG_SAMI'], ['2801', 'LANG_ARABIC'], ['2809', 'LANG_ENGLISH'], ['280a', 'LANG_SPANISH'], ['2c01', 'LANG_ARABIC'], ['2c09', 'LANG_ENGLISH'], ['2c0a', 'LANG_SPANISH'], ['3001', 'LANG_ARABIC'], ['3009', 'LANG_ENGLISH'], ['300a', 'LANG_SPANISH'], ['3401', 'LANG_ARABIC'], ['3409', 'LANG_ENGLISH'], ['340a', 'LANG_SPANISH'], ['3801', 'LANG_ARABIC'], ['380a', 'LANG_SPANISH'], ['3c01', 'LANG_ARABIC'], ['3c0a', 'LANG_SPANISH'], ['4001', 'LANG_ARABIC'], ['4009', 'LANG_ENGLISH'], ['400a', 'LANG_SPANISH'], ['4409', 'LANG_ENGLISH'], ['440a', 'LANG_SPANISH'], ['4809', 'LANG_ENGLISH'], ['480a', 'LANG_SPANISH'], ['4c0a', 'LANG_SPANISH'], ['500a', 'LANG_SPANISH'], ['781a', 'LANG_BOSNIAN_NEUTRAL'], ['7c1a', 'LANG_SERBIAN_NEUTRAL']]
#EndRegion Compiler Options ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>; this is where the magic happens, people
#include <WinAPI.au3>
#include <GuiComboBox.au3>
#include <File.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <Date.au3>

#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <StaticConstants.au3>
#include <Process.au3>
#include <Date.au3>
#include <winapi.au3>
;#include "..\Services.au3"
#include <misc.au3>
#include <EditConstants.au3>
#include <IE.au3>
;#include "_Zip.au3"
AutoItSetOption("MustDeclareVars", 1)
#Region IsAdmin
If Not IsAdmin() Then
	If _IsAdministrator() Then
		;		If MsgBox(4, "Question", "Do you want to run as admin ?") = 6 Then
		If @Compiled Then
			TraySetState(2)
			ShellExecuteWait(@AutoItExe, "", "", "runas")
			;			MsgBox(64, "", "IsAdmin() = " & IsAdmin())
			Exit
		Else
			TraySetState(2)
			ShellExecuteWait(@AutoItExe, ' /AutoIt3ExecuteScript "' & @ScriptFullPath & '"', "", "runas")
			;			MsgBox(64, "", "IsAdmin() = " & IsAdmin())
			Exit
		EndIf
		;		EndIf
	EndIf
EndIf
#EndRegion IsAdmin
V2M_EventLog(' ', "", "0")
V2M_EventLog('App Launch', "", "0")
V2M_EventLog(' ', "", "0")

#include "..\_v2m_common_funcs.au3"
_Language()
$TimeStampLoop[1] = _NowCalc()
_StopKnownVNCFlavour(0, $AppINI, $V2M_VNC_UVNC)
;Exit

#Region RemoteINI
$INI_RemoteINI = _RSC_INIReadSection_key($INI_CommonSection, "RemoteINI", "")
If $INI_RemoteINI = "" Then
	V2M_EventLog("INI - Using Local INI File", "", "7")
	;make App_INI the same as above
	$AppINI = $AppINI
	;	MsgBox(0, "", "Using default INI", 2)
Else
	V2M_EventLog("INI - Using RemoteINI Settings", "", "7")
	;download Remote_INI, and make it App_INI

	TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011") & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_APP_START_TITLE", "APP_START_TITLE"), _FindReplaceNewLine(_RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_CONFIG_DOWNLOAD", "Downloading Configuration File")), 30)
	If StringLeft($INI_RemoteINI, 2) = "\\" Then
		FileCopy($INI_RemoteINI, @ScriptDir & "\scprompt_remote.ini")
		$AppINI = @ScriptDir & "\scprompt_remote.ini"
	ElseIf StringLeft($INI_RemoteINI, 7) = "http://" Or StringLeft($INI_RemoteINI, 8) = "https://" Then
		Local $s_GetVersFile = InetGet($INI_RemoteINI, @ScriptDir & "\scprompt_remote.ini", 1)
		If $s_GetVersFile = 0 Then ; INI file or internet not available
			MsgBox(262160, StringTrimRight(@ScriptName, 4) & _RSC_INIReadSection_key($INI_Translation_Section, "MSG_REMOTE_CFG_FAIL_TITLE", " ERROR"), _RSC_INIReadSection_key($INI_Translation_Section, "MSG_REMOTE_CFG_FAIL_TEXT1", "REMOTE CONFIG DOWNLOAD FAILED") & @CRLF & @CRLF & _RSC_INIReadSection_key($INI_Translation_Section, "MSG_REMOTE_CFG_FAIL_TEXT2", "Possible cause: Connection issues / website offline or Config file not found.  Try again later."))
			$AppINI = $AppINI
		Else
			$AppINI = @ScriptDir & "\scprompt_remote.ini"
		EndIf
	Else
		MsgBox(262160, StringTrimRight(@ScriptName, 4) & _RSC_INIReadSection_key($INI_Translation_Section, "MSG_REMOTE_CFG_FAIL_TITLE", " ERROR"), _RSC_INIReadSection_key($INI_Translation_Section, "MSG_REMOTE_CFG_FAIL_TEXT1", "REMOTE CONFIG DOWNLOAD FAILED") & @CRLF & @CRLF & _RSC_INIReadSection_key($INI_Translation_Section, "MSG_REMOTE_CFG_FAIL_TEXT2", "Possible cause: Connection issues / website offline or Config file not found.  Try again later."))
		;		MsgBox(0, "", "Remote INI address not valid URL or SMB," & @CRLF & @CRLF & "Using Standard INI", 10)
		V2M_EventLog("INI - Error Occured getting remoteINI ... Using Local INI File", "", "7")
		$AppINI = $AppINI
	EndIf
EndIf
#EndRegion RemoteINI

#Region Options and includes
Global $s_GetVersFile
Global $V2M_Exit = 0

If @Compiled Then
	TraySetToolTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011") & " - " & FileGetVersion(@ScriptFullPath))
Else
	Opt("TrayIconDebug", 1) ;If enabled shows the current script line in the tray icon tip to help debugging.               0 = no debug information (default)      1 = show debug
EndIf
Opt("TrayIconHide", 0) ;Hides the AutoIt tray icon. Note: The icon will still initially appear ~750 milliseconds.               0 = show icon (default) 1 = hide icon
Opt("TrayMenuMode", 9) ;Extend the behaviour of the script tray icon/menu. This can be done with a combination (adding) of the following values.                0 = default menu items (Script Paused/Exit) are appended to the usercreated menu; usercreated checked items will automatically unchecked; if you double click the tray icon then the controlid is returned which has the "Default"-style (default).             1 = no default menu             2 = user created checked items will not automatically unchecked if you click it         4 = don't return the menuitemID which has the "default"-style in the main contextmenu if you double click the tray icon         8 = turn off auto check of radio item groups
;Opt("OnExitFunc", "")
OnAutoItExitRegister("OnAutoItExit")

#EndRegion Options and includes
#Region Debuglog
If $DEBUGLOG = 1 Or StringInStr($CmdLineRaw, "-debuglog") Then
	If FileExists(@ScriptFullPath & "_LOG.txt") Then
		;		$V2M_EventDisplay = V2M_EventLog("Log File Exists ...", $V2M_EventDisplay, 8)
		;		$return = MsgBox(1, @ScriptName, "Log File Exists ..." & @CRLF & @CRLF & "Log will now be deleted ...", 10)
		;		If $return = 1 Or $return = -1 Then
		FileDelete(@ScriptFullPath & "_LOG.txt")
		;		EndIf
	EndIf
	;	$TrayMenuLog = TrayCreateItem("Disable Log")
	;Else
	;	$TrayMenuLog = 1
	$DEBUGLOG = 1
EndIf
#EndRegion Debuglog
#Region Delete superceeded INI settings
If _RSC_INIReadSection_key($INI_SCSection, "SCNumberConnections", "") <> "" Then
	IniDelete($AppINI, "SC", "SCNumberConnections")
	V2M_EventLog("Settings - Deleted superceeded INI settings", $V2M_EventDisplay, "7")
EndIf
If IniRead($AppINI, "languages", "LANG_COUNT", "") <> "" Then
	IniDelete(@ScriptDir & "\v2m_lang.ini", "languages", "LANG_COUNT")
	V2M_EventLog("Settings - Deleted superceeded INI settings", $V2M_EventDisplay, "7")
EndIf
#EndRegion Delete superceeded INI settings

Global $Disclaimer_Return = _Disclaimer_GUI()
$V2M_EventDisplay = V2M_EventLog("DISCLAIMER - Diclaimer GUI returned: " & $Disclaimer_Return, $V2M_EventDisplay, "9")
If $Disclaimer_Return = "EXIT" Or $Disclaimer_Return = "REJECT" Then
	$V2M_Exit = 1
Else
	; $Disclaimer_Return = "TIMEOUT" Or $Disclaimer_Return = "ACCEPT" Or $Disclaimer_Return = "NOFILE"
EndIf

#Region Variables Declarations
;Global $INI_GUI_TYPE = _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio")
;Vista Aero variables
Global $INI_ManualConnectionName = _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_DROPDEFAULT", "MANUAL")
Global $INI_DisableManualConnections = _RSC_INIReadSection_key($INI_ColourSection, "DisableManualConnections", "0")
Global $INI_text1 = _RSC_INIReadSection_key($INI_GUISection, "TEXT1", "Select the Connection Name")
Global $INI_text2 = _RSC_INIReadSection_key($INI_GUISection, "TEXT2", "From the list")
Global $INI_text3 = _RSC_INIReadSection_key($INI_GUISection, "TEXT3", "SCPrompt 2011")
Global $INI_text4 = _RSC_INIReadSection_key($INI_GUISection, "TEXT4", "Provided by YTS")
Global $INI_text1BGColor = _RSC_INIReadSection_key($INI_ColourSection, "Text1BGColor", "0xefefef")
Global $INI_text2BGColor = _RSC_INIReadSection_key($INI_ColourSection, "Text2BGColor", "0xDedbe7")
Global $INI_bg_color1 = _RSC_INIReadSection_key($INI_ColourSection, "BGCOLOR", " ")
Global $INI_bg_color2 = _RSC_INIReadSection_key($INI_ColourSection, "BGCOLOR2", " ")
Global $INI_bg_color3 = _RSC_INIReadSection_key($INI_ColourSection, "BGCOLOR3", " ")
Global $INI_ServiceMode = _RSC_INIReadSection_key($INI_CommonSection, "ServiceMode", "0")
Global $INI_Tel = _RSC_INIReadSection_key($INI_ColourSection, "TEL", "")
Global $INI_WebPage = _RSC_INIReadSection_key($INI_ColourSection, "WebPage", "")
Global $INI_colortext1 = _RSC_INIReadSection_key($INI_ColourSection, "COLORTEXT1", 0)
Global $INI_colortext2 = _RSC_INIReadSection_key($INI_ColourSection, "COLORTEXT2", 0)
Global $INI_colortext3 = _RSC_INIReadSection_key($INI_ColourSection, "COLORTEXT3", "0x848484")
Global $INI_colortext4 = _RSC_INIReadSection_key($INI_ColourSection, "COLORTEXT4", "0x848484")
Global $INI_SetPhoto = _RSC_INIReadSection_key($INI_ColourSection, "Set_photo", "1")
Global $INI_SetLogo = _RSC_INIReadSection_key($INI_ColourSection, "Set_logo", "1")
Global $INI_Set_webpage = _RSC_INIReadSection_key($INI_ColourSection, "Set_webpage", "0")
Global $INI_AutoReconnect = _RSC_INIReadSection_key($INI_CommonSection, "autoreconnect", "1")
Global $INI_UseSC_Server = _RSC_INIReadSection_key($INI_CommonSection, "UseSC_Server", "1")
Global $GUI, $test, $hImage, $width, $height, $controlGui, $GUI_Label, $StopButton, $V2M_Status[15], $test, $V2M_LogoPic, $V2M_GUI_Width, $V2M_GUI_Height, $comboitem1, $comboitem2, $V2M_GUI, $tcpipitem, $tcpipitemLabel, $portitem, $portitemLabel, $idsitem, $V2M_Tray[9]
Global $V2M_NoGUI = 0, $curVal = "", $curtop = 10, $v2m_AdditionalHeight = 0, $v2m_AdditionalWidth = 0, $subitem = 1, $canitem = 1, $DisplayManual = 0, $Use_UVNC_Server = 1
Global $radio_0 = 1, $radio_1 = 1, $radio_2 = 1, $radio_3 = 1, $radio_4 = 1, $radio_5 = 1, $radio_6 = 1, $radio_7 = 1, $radio_8 = 1, $radio_9 = 1, $radio_Manual = 1, $V2M_which_radio = "0"

Global $button_Manual = 1, $button_0 = 1, $button_1 = 1, $button_2 = 1, $button_3 = 1, $button_4 = 1, $button_5 = 1, $button_6 = 1, $button_7 = 1, $button_8 = 1, $button_9 = 1, $button_10 = 1, $space_width, $space_height
Global $SetPhoto_BG, $Help_LogoPic, $Supporters, $GUI_WebPage = 1, $close, $site_Start, $bkgr_color, $SCNumberConnections
Global $YTS_AdminCheckbox = 1, $YTS_NumPredefined = V2M_UVNC_NumberPredefConnect()
Global $YTS_Cleanup = 0, $UVNC_RunTimes, $INI_StopAfter
Global $Use_UVNC_Server_CmdLine[6], $Use_UVNC_Connect_Colon
Global $RemoteDrivers = "http://sc.uvnc.com/drivers.zip", $UVNC_ExistingService = 0, $UVNC_ServiceRegRead, $UVNC_Installed_Path
Global $Current_CompositionState

Global $YTS_WD_dc, $YTS_WD_obj_orig, $YTS_WD_pen, $YTS_WD_BGImage, $YTS_WD_Mouse_X, $YTS_WD_Mouse_Y, $YTS_WD_Mouse_X_Old, $YTS_WD_Mouse_Y_Old, $YTS_WD_Mouse_pos, $YTS_WD_radius, $YTS_WD_Colour
Global $voice = ObjCreate("Sapi.SpVoice")
Global $YTS_BS_Checkbox1, $YTS_BS_Checkbox2, $YTS_BS_Checkbox3, $YTS_BS_Label, $Beacon_Start_Button, $gui2, $getpos, $Beacon_Exit_Button, $YTS_BS_Label
Global $CM_Beacon, $CM_CheckUpdate, $CM_ForceExit, $CM_Menu, $CM_WhiteBoard
Global $GUIActiveX
Global $VNC_KillCount = 0


If FileExists(@ScriptDir & "\winvnc.exe") Then
	$V2M_VNC_UVNC = "winvnc.exe"
ElseIf FileExists(@ScriptDir & "\uvnc.exe") Then
	$V2M_VNC_UVNC = "uvnc.exe"
EndIf
;Vista Aero variables
;Const $DWM_EC_DISABLECOMPOSITION = 0x00000000
;Const $DWM_EC_ENABLECOMPOSITION = 0x00000001

Const $SPI_SETMOUSESONAR = 4125
Const $SPIF_DONT_UPDATE_PROFILE = 0
Const $SPIF_SENDCHANGE = 2
Const $SPIF_SENDWININICHANGE = 2
Const $SPIF_UPDATEINIFILE = 1
#EndRegion Variables Declarations
#Region Commandline
If $V2M_Exit <> 1 Then
	If $cmdline[0] > 0 Then
		_SCP_cmdline()
	Else
		V2M_EventLog("No CmdLine" & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_APP_START_LINE1", "APP_START_TITLE"), $V2M_EventDisplay, "1")
		TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011") & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_APP_START_TITLE", "APP_START_TITLE"), _FindReplaceNewLine(_RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_APP_START_LINE1", "")), 10)
	EndIf
EndIf
#EndRegion Commandline
#Region Existing VNC Service
If $V2M_Exit <> 1 Then
	$UVNC_ServiceRegRead = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\uvnc_service", "ImagePath")
	Global $UVNC_Path_Split, $UVNC_ServiceVersion, $loopcount
	If $UVNC_ServiceRegRead <> '' Then
		$V2M_EventDisplay = V2M_EventLog("SERVICE - Existing UVNC_SERVICE was found ...", $V2M_EventDisplay, "4")
		$V2M_EventDisplay = V2M_EventLog("SERVICE - Found installed @ '" & $UVNC_ServiceRegRead & "'", $V2M_EventDisplay, "9")
		$UVNC_ExistingService = 1
		$UVNC_Path_Split = StringSplit($UVNC_ServiceRegRead, "\")
		Do
			$loopcount = $loopcount + 1
			$UVNC_Installed_Path = $UVNC_Installed_Path & $UVNC_Path_Split[$loopcount] & "\"
		Until $loopcount + 1 >= $UVNC_Path_Split[0]
		$UVNC_Installed_Path = StringTrimRight(StringTrimLeft($UVNC_Installed_Path, 1), 1)
		$V2M_EventDisplay = V2M_EventLog("SERVICE - Found installed @ '" & $UVNC_Installed_Path & "'", $V2M_EventDisplay, "9")
		$UVNC_ServiceVersion = FileGetVersion($UVNC_Installed_Path & "\" & $UVNC_Path_Split[$UVNC_Path_Split[0] - 1])
		$V2M_EventDisplay = V2M_EventLog("SERVICE - Found Version: '" & $UVNC_ServiceVersion & "' was found", $V2M_EventDisplay, "9")
	EndIf
EndIf
#EndRegion Existing VNC Service
Global $Service_QueryStatus = _Service_QueryStatus("uvnc_service")
$V2M_EventDisplay = V2M_EventLog("SERVICE - _Service_QueryStatus('uvnc_service') = " & $Service_QueryStatus[0] & "$Service_QueryStatus[1] = " & $Service_QueryStatus[1], $V2M_EventDisplay, "8")

#Region Mouse Sonar
If $V2M_Exit <> 1 Then
	If _RSC_INIReadSection_key($INI_CommonSection, "MAIN_ENABLE_SONAR", 1) = 1 Then
		DllCall("User32", "int", "SystemParametersInfo", _
				"int", $SPI_SETMOUSESONAR, _
				"int", 0, _
				"int", 1, _
				"int", BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE) _
				)
		$V2M_EventDisplay = V2M_EventLog("Usability - Sonar is now enabled", $V2M_EventDisplay, "2")
	EndIf
EndIf
#EndRegion Mouse Sonar

#Region Check if already running
If $V2M_Exit <> 1 Then
	If _MutexExists(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt")) Then
		; We know the script is already running. Let the user know.
		$return = MsgBox(1, _RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SCPROMPT"), "This Application has already been started once" & @CRLF & @CRLF & "If you want to open another copy, click 'OK'," & @CRLF & "Otherwise this application will close shortly", 10)
		If $return = -1 Or $return = 2 Then
			Exit (1)
		EndIf
	EndIf
EndIf
#EndRegion Check if already running

#Region Vista Mods
;=========================================================================================================================================================
;=================== Vista Modifications to allow faster vista support
;=========================================================================================================================================================
V2M_EventLog("CORE - @OSVersion = " & @OSVersion, $V2M_EventDisplay, '7')
;If @OSVersion = "WIN_VISTA" Then
If $V2M_Exit <> 1 Then
	If (@OSVersion = "WIN_VISTA") Then
		;	Or RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentVersion") >= 6 Then
		$V2M_EventDisplay = V2M_EventLog("CORE - @OSVersion >= WIN_VISTA", $V2M_EventDisplay, "2")
		;Get current Aero State
		$Current_CompositionState = Vista_GetComposition()
		V2M_EventLog("USABILITY - $Current_CompositionState = " & $Current_CompositionState, $V2M_EventDisplay, " 9")
		;disable UAC
		Vista_ControlUAC("Disable")
		;disable Aero
		Vista_ControlAero("Disable")
	ElseIf @OSVersion = "WIN_7" Or @OSVersion = "WIN_2008" Or @OSVersion = "WIN_2008R2" Then
		$V2M_EventDisplay = V2M_EventLog("CORE - @OSVersion = WIN_7 / WIN_2008 / WIN_2008R2", $V2M_EventDisplay, "2")
		;Get current Aero State
		$Current_CompositionState = Vista_GetComposition()
		V2M_EventLog("USABILITY - $Current_CompositionState = " & $Current_CompositionState, $V2M_EventDisplay, " 9")
		;disable UAC
		Vista_ControlUAC("Disable")
		;disable Aero
		WIN7_ControlAero("Disable")
	EndIf
EndIf
#EndRegion Vista Mods
#Region TrayIcon setup
If $V2M_Exit <> 1 Then
	If @Compiled Then
		TraySetIcon(@ScriptFullPath, "-1")
	Else
		TraySetIcon("logo.ico")
	EndIf
	$V2M_Tray[2] = TrayCreateItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_ABOUT", "ABOUT"))
	$V2M_Tray[3] = TrayCreateMenu(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_TOOLS", "TOOLS"))
	$V2M_Tray[4] = TrayCreateItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_TOOLS_FORCEEXIT", "FORCE UNINSTALL"), $V2M_Tray[3])
	If (_RSC_INIReadSection_key($INI_CommonSection, "INETUPDATE", 0) = 1 Or _RSC_INIReadSection_key($INI_CommonSection, "TESTUPDATE", 0) = 1) Then
		$V2M_Tray[5] = TrayCreateItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_TOOLS_CHECKUPDATES", "CHECK FOR UPDATES"), $V2M_Tray[3])
	Else
		$V2M_Tray[5] = 1
	EndIf
	$V2M_Tray[7] = TrayCreateItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_TOOLS_WHITEBOARD", "Start WhiteBoard"), $V2M_Tray[3])
	$V2M_Tray[8] = TrayCreateItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_TOOLS_BEACON", "Start Beacon"), $V2M_Tray[3])

	TrayItemSetState($V2M_Tray[2], $TRAY_ENABLE + $TRAY_DEFAULT)
	TrayCreateItem("")
	$V2M_Tray[1] = TrayCreateItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_EXIT", "EXIT"))
	TraySetState(_RSC_INIReadSection_key($INI_ColourSection, "TraySetStateShow", 9))
	;TraySetState()
	TraySetClick(8)
	#EndRegion TrayIcon setup

	#Region video driver checks
	;UVNC_FindMirrorDriverInstalled()
	;$UVNC_DriverStatus = RunWait(@SystemDir & '\driverquery.exe /nh /si | find "mv video hook driver2"', "", @SW_HIDE)
	;If @error Then
	$V2M_Tray[6] = TrayCreateItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_TOOLS_INSTALLDRIVERS", "Mirror Drivers"), $V2M_Tray[3])
	;	;	MsgBox(0, "Debug", "Mirror Driver not found" & @CRLF & @CRLF & @SystemDir & '\driverquery.exe')
	;Else
	;	$V2M_Tray[6] = 1
	;	;	TrayItemSetState($V2M_Tray[6], $TRAY_DISABLE)
	;	;	TrayItemSetText($V2M_Tray[6], _RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_DRIVERSINSTALLED", "DRIVER INSTALLED"))
	;	;	MsgBox(0, "Debug", "Mirror Driver found" & @CRLF & @CRLF & @SystemDir & '\driverquery.exe')
	;EndIf
	#EndRegion video driver checks

	#Region Check for Predefined Connections and setup GUI size accordingly
	;check for predefined connections
	If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") <> "Manual" Then
		$V2M_EventDisplay = V2M_EventLog("GUI - Start with Predefined Connections", $V2M_EventDisplay, "6")
		If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Auto" Or _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Automatic" Then
			$V2M_EventDisplay = V2M_EventLog("GUI - Automatic GUI Version", $V2M_EventDisplay, "4")
			_createAutoGUI()
		ElseIf _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Button" Then
			$V2M_EventDisplay = V2M_EventLog("GUI - Predefined GUI - Button Version", $V2M_EventDisplay, "4")
			$V2M_GUI_Width = 620
			$V2M_GUI_Height = 320
			_createButtonGUI()
		ElseIf _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Combo" Then
			$V2M_EventDisplay = V2M_EventLog("GUI - Predefined GUI - Combo Version", $V2M_EventDisplay, "4")
			$V2M_GUI_Width = 350
			$V2M_GUI_Height = 290
			_createGUI()
		ElseIf _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Repeater" Then
			$V2M_EventDisplay = V2M_EventLog("GUI - Predefined GUI - Repeater Version", $V2M_EventDisplay, "4")
			$V2M_GUI_Width = 350
			$V2M_GUI_Height = 290
			MsgBox(0, ":D", "No repeater GUI yet cheeky", 10)
			$V2M_Exit = 1
			;		_createGUI()
		Else
			$V2M_EventDisplay = V2M_EventLog("GUI - Predefined GUI - Radio Version", $V2M_EventDisplay, "4")
			$V2M_GUI_Width = 350
			$V2M_GUI_Height = 290
			_createGUI()
		EndIf
	ElseIf _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Manual" Then
		$V2M_EventDisplay = V2M_EventLog("GUI - Manual SCPrompt GUI", $V2M_EventDisplay, "4")
		$V2M_GUI_Width = 200
		$V2M_GUI_Height = 130
		_createMiniGUI()
	Else
		;no GUI will be created
		$V2M_Exit = 1
	EndIf
EndIf
#EndRegion Check for Predefined Connections and setup GUI size accordingly

#Region Start the main While loop
;=========================================================================================================================================================
;=================== Main while loop for application
;=========================================================================================================================================================
While $V2M_Exit = 0
	;       do the following every cycle (imediate action)
	If _DateDiff('s', $TimeStampLoop[1], _NowCalc()) >= 1 Then
		;       Loop through the following every 1 second (allows for things that DONT need imediate actions to not chew the CPU.
		$TimeStampLoop[1] = _NowCalc()
		;		$TimeStampLoop[1] = _DateAdd('s', INIRead($INI_File, "AppSleepTime", "30") - 1, $TimeStampLoop[1]) ;sleep for 29 more seconds (30 in total)
		If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Combo" Then
			If GUICtrlRead($comboitem1) = $INI_ManualConnectionName Then
				GUICtrlSetState($tcpipitem, $GUI_SHOW)
				GUICtrlSetState($tcpipitemLabel, $GUI_SHOW)
				GUICtrlSetState($portitem, $GUI_SHOW)
				GUICtrlSetState($portitemLabel, $GUI_SHOW)
				GUICtrlSetState($comboitem2, $GUI_SHOW)
				If GUICtrlRead($comboitem2) = "-ID" Then
					GUICtrlSetState($idsitem, $GUI_SHOW)
				Else
					GUICtrlSetState($idsitem, $GUI_HIDE)
				EndIf
				GUICtrlSetImage($V2M_LogoPic, "")
			Else
				GUICtrlSetState($tcpipitem, $GUI_HIDE)
				GUICtrlSetState($tcpipitemLabel, $GUI_HIDE)
				GUICtrlSetState($portitem, $GUI_HIDE)
				GUICtrlSetState($portitemLabel, $GUI_HIDE)
				GUICtrlSetState($comboitem2, $GUI_HIDE)
				GUICtrlSetState($idsitem, $GUI_HIDE)

				If FileExists(@ScriptDir & "\Logo" & V2M_UVNC_NamesNumber(GUICtrlRead($comboitem1)) & ".jpg") Then
					GUICtrlSetImage($V2M_LogoPic, @ScriptDir & "\Logo" & V2M_UVNC_NamesNumber(GUICtrlRead($comboitem1)) & ".jpg")
					$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: Logo" & V2M_UVNC_NamesNumber(GUICtrlRead($comboitem1)) & ".jpg", $V2M_EventDisplay, "7")
				ElseIf FileExists(@ScriptDir & "\NoImage.jpg") Then
					GUICtrlSetImage($V2M_LogoPic, @ScriptDir & "\NoImage.jpg")
					$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: NoImage.jpg", $V2M_EventDisplay, "7")
				ElseIf FileExists(@ScriptDir & "\Logo.jpg") Then
					GUICtrlSetImage($V2M_LogoPic, @ScriptDir & "\Logo.jpg")
					$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: Logo.jpg", $V2M_EventDisplay, "7")
				Else
					GUICtrlSetImage($V2M_LogoPic, "")
					$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: ''", $V2M_EventDisplay, "7")
				EndIf
			EndIf
		ElseIf $V2M_which_radio = $INI_ManualConnectionName Or _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Manual" Then
			If GUICtrlRead($comboitem2) = "-ID" Then
				GUICtrlSetState($idsitem, $GUI_SHOW)
			Else
				GUICtrlSetState($idsitem, $GUI_HIDE)
			EndIf
		EndIf
		If $V2M_Status[11] Then ;uvncwanted
			;			If $UVNC_RunTimes >= $INI_StopAfter Then
			;				V2M_EventLog("$UVNC_RunTimes >= $INI_StopAfter", $V2M_EventDisplay, "8")
			;				$V2M_Status[11] = 0
			;				GUISetState(@SW_RESTORE, $V2M_GUI)
			;				GUISetState(@SW_SHOWDEFAULT, $V2M_GUI)
			;			Else
			If $INI_AutoReconnect = 0 And $V2M_Status[12] = 1 And Not ProcessExists($V2M_VNC_UVNC) Then ;no reconnect, UVNC is meant to be started, but process not exist.
				V2M_EventLog("Exit - App should now exit due to autoreconnect = 0", $V2M_EventDisplay, "3")
				$V2M_Exit = 1
				$V2M_Status[11] = 0
				TraySetState(_RSC_INIReadSection_key($INI_ColourSection, "TraySetStateShow", 9))
			ElseIf $INI_UseSC_Server = 1 And $INI_ServiceMode <> 1 And ProcessExists($V2M_VNC_UVNC) And ($V2M_Status[12] <> 1) And $VNC_KillCount < 20 Then
				V2M_EventLog($V2M_VNC_UVNC & " Application exists ... trying to kill", $V2M_EventDisplay, "3")
				_StopKnownVNCFlavour(0, $AppINI, $V2M_VNC_UVNC)
				Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -kill", @ScriptDir, @SW_HIDE)
				$VNC_KillCount = $VNC_KillCount + 1
			ElseIf $INI_UseSC_Server = 1 And $INI_ServiceMode <> 1 And ProcessExists("winvnc.exe") And ($V2M_Status[12] <> 1) And $VNC_KillCount < 20 Then
				V2M_EventLog("winvnc.exe Application exists ... trying to kill - " & $INI_UseSC_Server, $V2M_EventDisplay, "3")
				Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -kill", @ScriptDir, @SW_HIDE)
				_StopKnownVNCFlavour(0, $AppINI, $V2M_VNC_UVNC)
				$VNC_KillCount = $VNC_KillCount + 1
			ElseIf $INI_UseSC_Server = 1 And $INI_ServiceMode <> 1 And ProcessExists($V2M_VNC_UVNC) And ($V2M_Status[12] <> 1) And $VNC_KillCount >= 20 Then
				V2M_EventLog($V2M_VNC_UVNC & " Application exists ... trying to kill", $V2M_EventDisplay, "3")
				Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -kill", @ScriptDir, @SW_HIDE)
				_StopKnownVNCFlavour(1, $AppINI, $V2M_VNC_UVNC) ; force winvnc.exe processclose()
				$VNC_KillCount = 0
			ElseIf Not ProcessExists($V2M_VNC_UVNC) And ($INI_UseSC_Server = 0 Or Not ProcessExists("winvnc.exe")) Then
				V2M_EventLog("UVNC - 'SC' Connection wanted but not started", $V2M_EventDisplay, "3")
				_VNCRun()
				$TimeStampLoop[1] = _DateAdd('s', _RSC_INIReadSection_key($INI_CommonSection, "AppReRunTimer", "30") - 1, $TimeStampLoop[1]) ;sleep for 29 more seconds (30 in total)
				$V2M_Status[12] = 1
				TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011") & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_TITLE", ""), _FindReplaceNewLine(_RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_LINE1", "")) & @CR & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_LINE2", ""), 10)
			ElseIf $INI_ServiceMode <> 1 And Not ProcessExists($V2M_VNC_UVNC) And ($INI_UseSC_Server = 1 Or Not ProcessExists("winvnc.exe")) Then
				V2M_EventLog("UVNC - 'User Mode' Server Connection wanted but not started", $V2M_EventDisplay, "3")
				_VNCRun()
				$TimeStampLoop[1] = _DateAdd('s', _RSC_INIReadSection_key($INI_CommonSection, "AppReRunTimer", "30") - 1, $TimeStampLoop[1]) ;sleep for 29 more seconds (30 in total)
				$V2M_Status[12] = 1
				TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011") & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_TITLE", ""), _FindReplaceNewLine(_RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_LINE1", "")) & @CR & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_LINE2", ""), 10)
			ElseIf $INI_ServiceMode = 1 And $V2M_Status[12] <> 1 Then
				V2M_EventLog("UVNC - 'Service Mode' Server Connection wanted but not started", $V2M_EventDisplay, "3")
				_VNCRun()
				$TimeStampLoop[1] = _DateAdd('s', _RSC_INIReadSection_key($INI_CommonSection, "AppReRunTimer", "30") - 1, $TimeStampLoop[1]) ;sleep for 29 more seconds (30 in total)
				$V2M_Status[12] = 1
				TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011") & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_TITLE", ""), _FindReplaceNewLine(_RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_LINE1", "")) & @CR & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_LINE2", ""), 10)
			Else
				$V2M_EventDisplay = V2M_EventLog("UVNC started", $V2M_EventDisplay, "3")
				TraySetState(_RSC_INIReadSection_key($INI_GUISection, "TraySetStateFlash", 4))
				;				TraySetState(4) ;start icon flashing
			EndIf
		EndIf

	EndIf
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			$V2M_EventDisplay = V2M_EventLog("GUI - Exiting (Window Close)", $V2M_EventDisplay, "1")
			TraySetState(_RSC_INIReadSection_key($INI_ColourSection, "TraySetStateShow", 9))
			;			TraySetState(8) ;stop icon flashing
			$V2M_Exit = 1
			$V2M_Status[11] = 0
			GUISetState(@SW_HIDE, $V2M_GUI)
		Case $canitem
			$V2M_EventDisplay = V2M_EventLog("GUI - Exiting (button)", $V2M_EventDisplay, "1")
			$V2M_Exit = 1
			$V2M_Status[11] = 0
			TraySetState(_RSC_INIReadSection_key($INI_ColourSection, "TraySetStateShow", 9))
			;			TraySetState(8) ;stop icon flashing
			GUISetState(@SW_HIDE, $V2M_GUI)
		Case $subitem
			$V2M_EventDisplay = V2M_EventLog("GUI - Connecting", $V2M_EventDisplay, "1")
			$V2M_Status[11] = 1
			GUISetState(@SW_MINIMIZE, $V2M_GUI)
		Case $radio_Manual
			_ChangeRadioSelection($INI_ManualConnectionName)
		Case $radio_0
			_ChangeRadioSelection("0")
		Case $radio_1
			_ChangeRadioSelection("1")
		Case $radio_2
			_ChangeRadioSelection("2")
		Case $radio_3
			_ChangeRadioSelection("3")
		Case $radio_4
			_ChangeRadioSelection("4")
		Case $radio_5
			_ChangeRadioSelection("5")
		Case $radio_6
			_ChangeRadioSelection("6")
		Case $radio_7
			_ChangeRadioSelection("7")
		Case $radio_8
			_ChangeRadioSelection("8")
		Case $radio_9
			_ChangeRadioSelection("9")
		Case $button_Manual
			_ChangeButtonSelection($INI_ManualConnectionName)
		Case $button_0
			_ChangeRadioSelection("0")
		Case $button_1
			_ChangeRadioSelection("1")
		Case $button_2
			_ChangeRadioSelection("2")
		Case $button_3
			_ChangeRadioSelection("3")
		Case $button_4
			_ChangeRadioSelection("4")
		Case $button_5
			_ChangeRadioSelection("5")
		Case $button_6
			_ChangeRadioSelection("6")
		Case $button_7
			_ChangeRadioSelection("7")
		Case $button_8
			_ChangeRadioSelection("8")
		Case $button_9
			_ChangeRadioSelection("9")
		Case $GUI_WebPage
			$V2M_EventDisplay = V2M_EventLog("GUI - webpage clicked", $V2M_EventDisplay, "7")
			If $INI_Set_webpage = "1" Then
				$V2M_EventDisplay = V2M_EventLog("GUI - webpage start", $V2M_EventDisplay, "7")
				_StartSite($INI_WebPage)
			Else
				$V2M_EventDisplay = V2M_EventLog("GUI - webpage start not on", $V2M_EventDisplay, "7")
			EndIf
		Case $YTS_AdminCheckbox
			$V2M_EventDisplay = V2M_EventLog("GUI - Service Mode Clicked", $V2M_EventDisplay, "7")
			If GUICtrlRead($YTS_AdminCheckbox) = 1 Then
				$INI_ServiceMode = 1
			Else
				$INI_ServiceMode = 0
			EndIf
		Case $CM_Beacon
			$V2M_EventDisplay = V2M_EventLog("Context Menu - $CM_Beacon", $V2M_EventDisplay, "1")
			Beacon_GUI()

		Case $CM_CheckUpdate
			$V2M_EventDisplay = V2M_EventLog("Context Menu - $CM_CheckUpdate", $V2M_EventDisplay, "1")
			V2M_Update("scprompt", "INETUPDATE")

		Case $CM_ForceExit
			$V2M_EventDisplay = V2M_EventLog("Context Menu - $CM_ForceExit", $V2M_EventDisplay, "1")
			_VNCServiceMode("Uninstall")
			$return = IniDelete($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline")
			If $return <> 0 Then
				IniWrite($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline", "")
				$return = IniDelete($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline")
				If $return <> 0 Then
					IniWrite($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline", "")
				EndIf
			EndIf

		Case $CM_WhiteBoard
			$V2M_EventDisplay = V2M_EventLog("Context Menu - $CM_WhiteBoard", $V2M_EventDisplay, "1")
			Start_Whiteboard()

			;		Case $CM_MirrorDrivers
			;			$V2M_EventDisplay = V2M_EventLog("Context Menu - $CM_MirrorDrivers", $V2M_EventDisplay, "1")
			;			UVNC_DownloadExtractMirrorDrivers()

	EndSwitch
	Switch TrayGetMsg()
		Case $V2M_Tray[1] ; Exit
			$V2M_EventDisplay = V2M_EventLog("Tray - Exit", $V2M_EventDisplay, "1")
			$V2M_Exit = 1
		Case $V2M_Tray[2] ; About
			$V2M_EventDisplay = V2M_EventLog("Tray - About", $V2M_EventDisplay, "1")
			V2MAboutBox()
		Case $V2M_Tray[4] ; Force Remove UVNC Service
			$V2M_EventDisplay = V2M_EventLog("Tray - Tools > Force Remove Service Mode", $V2M_EventDisplay, "1")
			_VNCServiceMode("Uninstall")
			$return = IniDelete($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline")
			If $return <> 0 Then
				IniWrite($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline", "")
				$return = IniDelete($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline")
				If $return <> 0 Then
					IniWrite($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline", "")
				EndIf
			EndIf
			;			$V2M_Exit = 1
		Case $V2M_Tray[5] ; Check for Updates
			$V2M_EventDisplay = V2M_EventLog("Tray - Tools > Check for updates", $V2M_EventDisplay, "1")
			V2M_Update("scprompt", "INETUPDATE")
		Case $V2M_Tray[6] ; Install Mirror Drivers
			$V2M_EventDisplay = V2M_EventLog("Tray - Tools > Download and Install UVNC Drivers", $V2M_EventDisplay, "1")
			UVNC_DownloadExtractMirrorDrivers()
		Case $V2M_Tray[7] ; Whiteboard
			$V2M_EventDisplay = V2M_EventLog("Tray - Tools > Start / Stop WhiteBoard", $V2M_EventDisplay, "1")
			Start_Whiteboard()
		Case $V2M_Tray[8] ; Beacon
			$V2M_EventDisplay = V2M_EventLog("Tray - Tools > PC Beacon", $V2M_EventDisplay, "1")
			Beacon_GUI()
		Case Default ; About
			$V2M_EventDisplay = V2M_EventLog("GUI - Tray Default", $V2M_EventDisplay, "1")
			V2MAboutBox()
	EndSwitch

WEnd

GUIDelete()
#EndRegion Start the main While loop

#Region SCPrompt Func
;===============================================================================
;
; Description:          Creates a short message about the application
; Parameter(s):         none
; Requirement(s):
; Return Value(s):      none
; Author(s):            YTS_Jim
; Note(s):
;
;===============================================================================
Func V2MAboutBox()
	$V2M_EventDisplay = V2M_EventLog("FUNC - V2MAboutBox()", $V2M_EventDisplay, "8")
	MsgBox(0, "About " & _RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011"), _RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011") & @CRLF & "Creates a connection to a Listening VNC viewer / UVNC repeater" & @CRLF & @CRLF & "visit: www.vnc2me.org/scprompt/ for further details" & @CRLF & @CRLF & "© 2009-2011 www.securetech.com.au (Secure Technology Group).")
EndFunc   ;==>V2MAboutBox

;
;===============================================================================
;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            YTS_Jim
; Note(s):
;===============================================================================
Func _createButtonGUI()
	$V2M_EventDisplay = V2M_EventLog("FUNC - _createButtonGUI()", $V2M_EventDisplay, "8")
	;       If $V2M_Exit = 0 And $V2M_NoGUI <> 1 Then
	$V2M_GUI = GUICreate(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SCPROMPT"), $V2M_GUI_Width, $V2M_GUI_Height)
	GUICtrlSetBkColor(-1, $INI_text1BGColor)
	GUISetIcon("logo.ico")
	; Button GUI
	GUICtrlCreateLabel("", 6, 5, 610, 30)
	GUICtrlSetBkColor(-1, $INI_bg_color3)
	GUICtrlCreateLabel("", 6, 35, 610, 20)
	GUICtrlSetBkColor(-1, $INI_bg_color2)

	GUICtrlCreateLabel("", 5, 165, 610, 58) ;achtergrondkleur onder_bovenste deel
	GUICtrlSetBkColor(-1, $INI_bg_color2)
	GUICtrlCreateLabel("", 5, 235, 610, 38) ;achtergrondkleur onder_onderste deel
	GUICtrlSetBkColor(-1, $INI_bg_color2)
	GUICtrlCreateLabel("", 5, 223, 230, 15) ;achtergrondkleur onder_voor sitevermelding
	GUICtrlSetBkColor(-1, $INI_bg_color2)
	GUICtrlCreateLabel("", 385, 223, 230, 15) ;achtergrondkleur onder_achter sitevermelding
	GUICtrlSetBkColor(-1, $INI_bg_color2)
	;    GUICtrlCreateLabel("", 60, 190, 85, 66)  ; kader achter foto
	;    GuiCtrlSetBkColor(-1, $INI_text1BGColor)
	_setphoto()

	;    If $INI_SetPhoto = "1" Then
	;        $SetPhoto_BG = GUICtrlCreateLabel("", 50, 172, 106, 96)
	;        GUICtrlSetBkColor($SetPhoto_BG, $INI_bg_color2)
	;        $V2M_LogoPic = GUICtrlCreatePic("", 53, 175, 100, 90)
	;        GUICtrlSetImage($V2M_LogoPic, @ScriptDir & "\NoImage.jpg")
	;    EndIf

	If $INI_SetLogo = "1" Then
		$Help_LogoPic = GUICtrlCreatePic("", 465, 175, 100, 90)
		GUICtrlSetImage($Help_LogoPic, @ScriptDir & "\logo.jpg")
	EndIf

	$Supporters = GUICtrlCreateGroup('Select Service Man', 5, 60, 610, 100, $WS_THICKFRAME) ;$WS_SIZEBOX)

	V2M_UVNC_CreateButton()

	;Site annotation

	If ($INI_Set_webpage = "1") And ($INI_WebPage <> "") Then
		$GUI_WebPage = GUICtrlCreateLabel(($INI_WebPage), 225, 220, 165, 15, $SS_CENTER)
		GUICtrlSetFont(-1, 9, 400, 4)
		GUICtrlSetBkColor(-1, $INI_bg_color2)
		GUICtrlSetColor(-1, 0x0000ff)
		GUICtrlSetCursor(-1, 0)
	EndIf

	$v2m_AdditionalHeight = 10
	$v2m_AdditionalWidth = 20

	; BUTTONS
	$subitem = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_BTN_START", "CONNECT"), 10, $V2M_GUI_Height - 40, 195, 30)
	GUICtrlSetBkColor(-1, 0x81ff81)
	GUICtrlSetColor(-1, 0x424242)
	GUICtrlSetFont(-1, 10, 600)
	GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_BTN_START_TIP", "TIP NOT TRANSLATED"))
	$canitem = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_BTN_EXIT", "EXIT"), 410, $V2M_GUI_Height - 40, 195, 30)
	GUICtrlSetBkColor(-1, 0xff8181)
	GUICtrlSetColor(-1, 0x424242)
	GUICtrlSetFont(-1, 10, 600)
	GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_BTN_EXIT_TIP", "TIP NOT TRANSLATED"))

	; PERSONALIZATION
	If $INI_Tel <> "" Then
		GUICtrlCreateLabel($INI_text1 & " :  " & $INI_Tel, $V2M_GUI_Width - 510, 7, 400, 30, $SS_CENTER)
	Else
		GUICtrlCreateLabel($INI_text1, $V2M_GUI_Width - 510, 7, 400, 30, $SS_CENTER)
	EndIf

	GUICtrlSetBkColor(-1, $INI_bg_color3)
	If $INI_text1BGColor <> 0 Then GUICtrlSetColor(-1, $INI_text1BGColor)
	GUICtrlSetFont(-1, 14, 800, 4)
	;   GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_LBL_TEXT2", "Then select the available technician"), $V2M_GUI_Width - 510, 35, 400, 20, $SS_CENTER)
	GUICtrlCreateLabel($INI_text2, $V2M_GUI_Width - 510, 35, 400, 20, $SS_CENTER)

	GUICtrlSetBkColor(-1, $INI_bg_color2)
	If $INI_text2BGColor <> 0 Then GUICtrlSetColor(-1, $INI_text2BGColor)
	GUICtrlSetFont(-1, 10, 600)
	GUICtrlCreateLabel($INI_text3, $V2M_GUI_Width - 395, $V2M_GUI_Height - 40, 165, 20, $SS_CENTER)
	If $INI_colortext3 <> 0 Then GUICtrlSetColor(-1, $INI_colortext3)
	GUICtrlCreateLabel($INI_text4, $V2M_GUI_Width - 375, $V2M_GUI_Height - 25, 135, 20, $SS_CENTER)
	If $INI_colortext4 <> 0 Then GUICtrlSetColor(-1, $INI_colortext4)
	;                               EndIf
	;                       EndIf

	;               EndIf
	;EndIf
	_RSC_CreateContextMenus()
	GUICtrlSetState($button_0, $GUI_CHECKED + $GUI_FOCUS)
	If _RSC_INIReadSection_key($INI_ColourSection, "BGCOLOR", 0) <> 0 Then GUISetBkColor((_RSC_INIReadSection_key($INI_ColourSection, "BGCOLOR", 0)))

	; SERVICE MODE
	If IsAdmin() And $INI_UseSC_Server = "1" Then
		$V2M_EventDisplay = V2M_EventLog("GUI - Display the 'Service Mode' checkbox", $V2M_EventDisplay, "7")
		$YTS_AdminCheckbox = GUICtrlCreateCheckbox(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_SERVICEMODE", "Service Mode"), 10, $V2M_GUI_Height - 50, 196, 14)
		If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
		If $INI_ServiceMode <> 0 Then GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_SERVICEMODE_TIP", "TIP NOT TRANSLATED"))
	EndIf

	GUISetState()

	;       Else
	;               $V2M_GUI = GUICreate(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SCPROMPT"), $V2M_GUI_Width, $V2M_GUI_Height, 0, 0, $WS_MINIMIZE)
	;               GUISetState(@SW_HIDE)
	;       EndIf
EndFunc   ;==>_createButtonGUI


;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            pheonix
; Note(s):
;===============================================================================
Func _setphoto()
	$V2M_EventDisplay = V2M_EventLog("FUNC - _setphoto()", $V2M_EventDisplay, "8")
	If $INI_SetPhoto = "1" Then
		$SetPhoto_BG = GUICtrlCreateLabel("", 50, 172, 106, 96)
		GUICtrlSetBkColor($SetPhoto_BG, $INI_bg_color3)
		$V2M_LogoPic = GUICtrlCreatePic("", 53, 175, 100, 90)
		GUICtrlSetImage($V2M_LogoPic, @ScriptDir & "\NoImage.jpg")
	EndIf
EndFunc   ;==>_setphoto


;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            pheonix / YTS_Jim
; Note(s):
;===============================================================================
Func V2M_UVNC_CreateButton($loopcount = 0, $height = 80, $width = 10)
	$V2M_EventDisplay = V2M_EventLog("FUNC - V2M_UVNC_CreateButton()", $V2M_EventDisplay, "8")
	Local $count, $button_heigth, $button_width, $width1, $width2, $width3, $doubble_row, $smaller_buttons
	$count = $YTS_NumPredefined
	If ($INI_DisableManualConnections = "") Or ($INI_DisableManualConnections = "0") Then
		$DisplayManual = 1
	EndIf
	If $count > 0 And $count < 5 Then
		$button_width = (($V2M_GUI_Width - (($count + 4) * $width)) / ($count + $DisplayManual))
		$button_heigth = 65
		$space_width = ($button_width + $width)
		$space_height = 0
		$width1 = $width + 10
		$width2 = (($width + $space_width) * 4) - ($width * 2)
	ElseIf $count > 4 And $count < 8 Then
		$doubble_row = 1
		;$button_width = (($V2M_GUI_Width - (($count + 4) * $width)) / (($count + $DisplayManual) / 2))
		$button_width = (($V2M_GUI_Width - 70) / 4)
		$button_heigth = 30
		$space_width = ($button_width + $width)
		$space_height = 35
		$width1 = $width + 10
		$width3 = $width1

	Else
		$smaller_buttons = 1
		;$button_width = (($V2M_GUI_Width - (($count + 8) * $width)) / (($count + $DisplayManual) / 2))
		$button_width = (($V2M_GUI_Width - 90) / 6)
		$button_heigth = 30
		$space_width = ($button_width + $width)
		$space_height = 35
		$width1 = $width + 10
		$width3 = $width1

	EndIf

	Local $V2M_UVNC_ConnectNames = ''
	Do
		;       While (_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "") <> "")
		;               Assign("button_" & $loopcount, GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), ($width1), $height, $button_width, $button_heigth)
		If $loopcount = 0 Then
			$button_0 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), ($width1), $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			$height = $height
			$width = $width + $width + $space_width
		ElseIf $loopcount = 1 Then
			$button_1 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $width, $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			$height = $height
			$width = $width + $space_width
		ElseIf $loopcount = 2 Then
			$button_2 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $width, $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			If $doubble_row = 1 Then
				$width = $width + $space_width
			Else
				$height = $height
				$width = $width + $space_width
			EndIf
		ElseIf $loopcount = 3 Then
			$button_3 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $width, $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			If $doubble_row = 1 Then
				$height = $height + $space_height
				$width = $width3
			Else
				$height = $height
				$width = $width + $space_width
			EndIf
		ElseIf $loopcount = 4 Then
			$button_4 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $width, $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			$height = $height
			$width = $width + $space_width
		ElseIf $loopcount = 5 Then
			$button_5 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $width, $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			If $smaller_buttons = 1 Then
				$height = $height + $space_height
				$width = $width3
			Else
				$height = $height
				$width = $width + $space_width
			EndIf
		ElseIf $loopcount = 6 Then
			$button_6 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $width, $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			$height = $height
			$width = $width + $space_width
		ElseIf $loopcount = 7 Then
			$button_7 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $width, $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			$height = $height
			$width = $width + $space_width
		ElseIf $loopcount = 8 Then
			$button_8 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $width, $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			$height = $height
			$width = $width + $space_width
		ElseIf $loopcount = 9 Then
			$button_9 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $width, $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			$height = $height
			$width = $width + $space_width
		ElseIf $loopcount = 10 Then
			$button_10 = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $width, $height, $button_width, $button_heigth)
			GUICtrlSetFont(-1, 10, 600)
			$height = $height
			$width = $width + $space_width
		EndIf
		V2M_EventLog('V2M_UVNC_CreateButton() loopcount = ' & $loopcount, $V2M_EventDisplay, "8")
		$loopcount = $loopcount + 1 ; increment loopcount
		If _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "") = "" Then
			ExitLoop
		EndIf
		;       WEnd
	Until $loopcount = $YTS_NumPredefined
	If $INI_DisableManualConnections <> "1" Then
		If $smaller_buttons = 1 Then
			$button_Manual = GUICtrlCreateButton($INI_ManualConnectionName, $V2M_GUI_Width - $space_width - 12, $height, $button_width, $button_heigth)
		Else
			$button_Manual = GUICtrlCreateButton($INI_ManualConnectionName, $V2M_GUI_Width - $space_width - 10, $height, $button_width, $button_heigth)
		EndIf
	EndIf
	GUICtrlSetFont(-1, 10, 600)
EndFunc   ;==>V2M_UVNC_CreateButton

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            Pheonix
; Note(s):
;===============================================================================
Func _ChangeButtonSelection($what)
	$V2M_EventDisplay = V2M_EventLog("FUNC - _ChangeButtonSelection()", $V2M_EventDisplay, "8")
	If $what = $INI_ManualConnectionName Then
		GUICtrlCreateLabel("", 50, 172, 106, 96)
		GUICtrlSetBkColor(-1, $INI_bg_color1)

		; INPUT
		$curtop = 175
		$tcpipitem = GUICtrlCreateInput(_RSC_INIReadSection_key($INI_SCSection, "ManualAddress", ""), 80 + $v2m_AdditionalWidth, $curtop, 130, 25)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetState(-1, $GUI_HIDE)

		$tcpipitemLabel = GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD", "TCP/IP"), 10, $curtop + 3, 60 + $v2m_AdditionalWidth, 15 + $v2m_AdditionalHeight)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetBkColor(-1, $INI_bg_color2)
		If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
		GUICtrlSetState(-1, $GUI_HIDE)

		$curtop = $curtop + 22 + $v2m_AdditionalHeight
		$portitem = GUICtrlCreateInput(_RSC_INIReadSection_key($INI_SCSection, "ManualPort", "5500"), 80 + $v2m_AdditionalWidth, $curtop, 130, 25)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_PORT_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetState(-1, $GUI_HIDE)

		$portitemLabel = GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_PORT", "PORT"), 10, $curtop + 3, 60 + $v2m_AdditionalWidth, 15 + $v2m_AdditionalHeight)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_PORT_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetBkColor(-1, $INI_bg_color2)
		If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
		GUICtrlSetState(-1, $GUI_HIDE)

		$curtop = $curtop + 22 + $v2m_AdditionalHeight
		$idsitem = GUICtrlCreateInput(_RSC_INIReadSection_key($INI_SCSection, "ManualID", ""), 80 + $v2m_AdditionalWidth, $curtop, 120, 20)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ID_TIP", "TIP NOT TRANSLATED"))

		;		GUICtrlSetBkColor($SetPhoto_BG, $GUI_BKCOLOR_TRANSPARENT)
		;		GUICtrlDelete($SetPhoto_BG)


		If (_RSC_INIReadSection_key($INI_SCSection, "ManualID", "") = "") Then
			$comboitem2 = GUICtrlCreateCombo("", 10 + $v2m_AdditionalWidth, $curtop, 40, 60)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD_TIP", "TIP NOT TRANSLATED"))
			GUICtrlSetData(-1, " |-ID", "")
		Else
			$comboitem2 = GUICtrlCreateCombo("-ID", 10 + $v2m_AdditionalWidth, $curtop, 40, 60)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD_TIP", "TIP NOT TRANSLATED"))
			GUICtrlSetData(-1, " ", "")
		EndIf
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlSetState($idsitem, $GUI_HIDE)

		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlSetState($tcpipitem, $GUI_SHOW)
		GUICtrlSetState($tcpipitemLabel, $GUI_SHOW)
		GUICtrlSetState($portitem, $GUI_SHOW)
		GUICtrlSetState($portitemLabel, $GUI_SHOW)
		GUICtrlSetState($comboitem2, $GUI_SHOW)
		If GUICtrlRead($comboitem2) = "-ID" Then
			GUICtrlSetState($idsitem, $GUI_SHOW)
		Else
			GUICtrlSetState($idsitem, $GUI_HIDE)
		EndIf
		GUICtrlSetImage($V2M_LogoPic, "")
		$V2M_which_radio = $INI_ManualConnectionName
		V2M_EventLog('GUI - Button changed selection to: ' & $what, $V2M_EventDisplay, "7")
	Else
		;		GUICtrlSetBkColor($SetPhoto_BG, $INI_bg_color2)
	EndIf
EndFunc   ;==>_ChangeButtonSelection


;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            YTS_Jim
; Note(s):
;===============================================================================
Func _createGUI()
	$V2M_EventDisplay = V2M_EventLog("FUNC - _createGUI()", $V2M_EventDisplay, "8")
	If $V2M_Exit = 0 And $V2M_NoGUI <> 1 Then
		$V2M_GUI = GUICreate(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SCPROMPT"), $V2M_GUI_Width, $V2M_GUI_Height)
		GUISetIcon("logo.ico")
		_RSC_CreateContextMenus()

		If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") <> "Manual" Then
			$V2M_EventDisplay = V2M_EventLog("GUI - UsePredefined > 0", $V2M_EventDisplay, "7")
			;                       $INI_SetLogo = _RSC_INIReadSection_key($INI_CommonSection, "Set_logo", "")
			If $INI_SetLogo = "1" Then
				$V2M_EventDisplay = V2M_EventLog("GUI - $INI_SetLogo = 1", $V2M_EventDisplay, "7")
				$V2M_LogoPic = GUICtrlCreatePic("", 5, $V2M_GUI_Height - 233, 196, 181)
				If FileExists(@ScriptDir & "\Logo.jpg") Then
					GUICtrlSetImage($V2M_LogoPic, @ScriptDir & "\Logo.jpg")
					$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: Logo.jpg", $V2M_EventDisplay, "7")
				ElseIf FileExists(@ScriptDir & "\NoImage.jpg") Then
					GUICtrlSetImage($V2M_LogoPic, @ScriptDir & "\NoImage.jpg")
					$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: NoImage.jpg", $V2M_EventDisplay, "7")
				Else
					GUICtrlSetImage($V2M_LogoPic, "")
					$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: ''", $V2M_EventDisplay, "7")
				EndIf
			EndIf

			;Site annotation
			;$INI_WebPage = _RSC_INIReadSection_key($INI_ColourSection, "WebPage", "")
			If ($INI_Set_webpage = "1") And ($INI_WebPage <> "") Then
				$V2M_EventDisplay = V2M_EventLog("GUI - $INI_Set_webpage = 1", $V2M_EventDisplay, "7")
				$GUI_WebPage = GUICtrlCreateLabel(($INI_WebPage), 5, $V2M_GUI_Height - 16, 185, 181, $SS_CENTER)
				GUICtrlSetFont(-1, 9, 400, 4)
				GUICtrlSetColor(-1, 0x0000ff)
				GUICtrlSetCursor(-1, 0)
			Else
				$V2M_EventDisplay = V2M_EventLog("GUI - Webpage not displayed: $INI_WebPage = " & $INI_WebPage & ", $INI_Set_webpage = " & $INI_Set_webpage, $V2M_EventDisplay, "1")
			EndIf

			$v2m_AdditionalHeight = 10
			$v2m_AdditionalWidth = 20

			$V2M_EventDisplay = V2M_EventLog("GUI - _RSC_INIReadSection_key($INI_GUISection, 'GUI_Type', 'Radio') = " & _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio"), $V2M_EventDisplay, "7")
			If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Combo" Then
				; Predefined connections COMBO box
				$comboitem1 = GUICtrlCreateCombo(_RSC_INIReadSection_key($INI_SCSection, "SCName_0", " "), 210, $curtop + 50, $V2M_GUI_Width - 225, 30)
				GUICtrlSetData($comboitem1, V2M_UVNC_CreateCombos(1), '')
				$curtop = $curtop + 100 ;50
			Else
				GUIStartGroup()
				V2M_UVNC_CreateRadios()
				$curtop = $curtop + 100 ;30
			EndIf
		EndIf


		; INPUTS
		$V2M_EventDisplay = V2M_EventLog("GUI - Creating Manual Inputs, Labels & Tips", $V2M_EventDisplay, "7")
		$tcpipitem = GUICtrlCreateInput(_RSC_INIReadSection_key($INI_SCSection, "ManualAddress", ""), 60 + $v2m_AdditionalWidth, $curtop, 120, 20)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetState(-1, $GUI_HIDE)

		$tcpipitemLabel = GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD", "TCP/IP"), 10, $curtop, 40 + $v2m_AdditionalWidth, 30 + $v2m_AdditionalHeight)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD_TIP", "TIP NOT TRANSLATED"))
		If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
		GUICtrlSetState(-1, $GUI_HIDE)

		$curtop = $curtop + 30 + $v2m_AdditionalHeight
		$portitem = GUICtrlCreateInput(_RSC_INIReadSection_key($INI_SCSection, "ManualPort", "5500"), 60 + $v2m_AdditionalWidth, $curtop, 120, 20)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_PORT_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetState(-1, $GUI_HIDE)

		$portitemLabel = GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_PORT", "PORT"), 10, $curtop + 3, 40 + $v2m_AdditionalWidth, 20 + $v2m_AdditionalHeight)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_PORT_TIP", "TIP NOT TRANSLATED"))
		If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
		GUICtrlSetState(-1, $GUI_HIDE)

		$curtop = $curtop + 30 + $v2m_AdditionalHeight
		$idsitem = GUICtrlCreateInput(_RSC_INIReadSection_key($INI_SCSection, "ManualID", ""), 60 + $v2m_AdditionalWidth, $curtop, 120, 20)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ID_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetState(-1, $GUI_HIDE)

		;ID COMBO box
		If (_RSC_INIReadSection_key($INI_SCSection, "ManualID", "") = "") Then
			$comboitem2 = GUICtrlCreateCombo("", 10 + $v2m_AdditionalWidth, $curtop, 40, 60)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ID_TIP", "TIP NOT TRANSLATED"))
			GUICtrlSetData(-1, " |-ID", "")
		Else
			$comboitem2 = GUICtrlCreateCombo("-ID", 10 + $v2m_AdditionalWidth, $curtop, 40, 60)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ID_TIP", "TIP NOT TRANSLATED"))
			GUICtrlSetData(-1, " ", "")
		EndIf
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlSetState($idsitem, $GUI_HIDE)

		$curtop = $curtop + 25 + $v2m_AdditionalHeight

		; SERVICE MODE
		If IsAdmin() And $INI_UseSC_Server = "1" Then
			$V2M_EventDisplay = V2M_EventLog("GUI - Display the 'Service Mode' checkbox", $V2M_EventDisplay, "7")
			$YTS_AdminCheckbox = GUICtrlCreateCheckbox(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_SERVICEMODE", "Service Mode"), 5, $V2M_GUI_Height - 50, 196, 14)
			If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
			If $INI_ServiceMode <> 0 Then GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_SERVICEMODE_TIP", "TIP NOT TRANSLATED"))
		EndIf

		;		$tcpipitemLabel = GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD", "TCP/IP"), 10, $curtop, 40 + $v2m_AdditionalWidth, 30 + $v2m_AdditionalHeight)
		;		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD_TIP", "TIP NOT TRANSLATED"))
		;		If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
		;		GUICtrlSetState(-1, $GUI_HIDE)
		;
		; BUTTONS
		$subitem = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_BTN_START", "CONNECT"), 5, $V2M_GUI_Height - 35, 120, 20)
		GUICtrlSetBkColor(-1, 0x81ff81)
		GUICtrlSetColor(-1, 0x424242)
		GUICtrlSetFont(-1, 10, 600)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_BTN_START_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetState($subitem, $GUI_DEFBUTTON)
		$canitem = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_BTN_EXIT", "EXIT"), 130, $V2M_GUI_Height - 35, 70, 20)
		GUICtrlSetBkColor(-1, 0xff8181)
		GUICtrlSetColor(-1, 0x424242)
		GUICtrlSetFont(-1, 10, 600)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_BTN_EXIT_TIP", "TIP NOT TRANSLATED"))

		; PERSONALIZATION
		If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") <> "Manual" Then
			$V2M_EventDisplay = V2M_EventLog("GUI - UsePredefined > 0", $V2M_EventDisplay, "7")
			If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Combo" Or "Radio" Then
				;	GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_LBL_TEXT1", "Call first: ") & $INI_Tel, $V2M_GUI_Width - 345, $V2M_GUI_Height - 285, 340, 25, $SS_CENTER)
				If $INI_Tel <> "" Then
					$V2M_EventDisplay = V2M_EventLog("GUI - Displaying Tel", $V2M_EventDisplay, "7")
					GUICtrlCreateLabel($INI_text1 & " :  " & $INI_Tel, $V2M_GUI_Width - 345, $V2M_GUI_Height - 285, 340, 25, $SS_CENTER)
				Else
					GUICtrlCreateLabel($INI_text1, $V2M_GUI_Width - 345, $V2M_GUI_Height - 285, 340, 25, $SS_CENTER)
				EndIf
				GUICtrlSetBkColor(-1, $INI_bg_color3)
				If $INI_text1BGColor <> 0 Then GUICtrlSetColor(-1, $INI_text1BGColor)
				GUICtrlSetFont(-1, 14, 800, 4)
				;	GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_LBL_TEXT2", "Then select the available technician"), $V2M_GUI_Width - 345, $V2M_GUI_Height - 260, 340, 20, $SS_CENTER)
				GUICtrlCreateLabel($INI_text2, $V2M_GUI_Width - 345, $V2M_GUI_Height - 260, 340, 20, $SS_CENTER)

				GUICtrlSetBkColor(-1, $INI_bg_color2)
				If $INI_text2BGColor <> 0 Then GUICtrlSetColor(-1, $INI_text2BGColor)
				GUICtrlSetFont(-1, 10, 600)
				GUICtrlCreateLabel($INI_text3, $V2M_GUI_Width - 135, $V2M_GUI_Height - 35, 135, 20, $SS_CENTER)
				If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
				GUICtrlCreateLabel($INI_text4, $V2M_GUI_Width - 135, $V2M_GUI_Height - 18, 135, 20, $SS_CENTER)
				If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
			EndIf
			If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Combo" Then
				GUICtrlSetState($comboitem1, $GUI_FOCUS)
			Else
				GUICtrlSetState($radio_0, $GUI_CHECKED + $GUI_FOCUS)
			EndIf
		Else
			GUICtrlSetState($tcpipitem, $GUI_SHOW)
			GUICtrlSetState($tcpipitemLabel, $GUI_SHOW)
			GUICtrlSetState($portitem, $GUI_SHOW)
			GUICtrlSetState($portitemLabel, $GUI_SHOW)
			GUICtrlSetState($comboitem2, $GUI_SHOW)
			If GUICtrlRead($comboitem2) = "-ID" Then
				GUICtrlSetState($idsitem, $GUI_SHOW)
			Else
				GUICtrlSetState($idsitem, $GUI_HIDE)
			EndIf
			GUICtrlSetState($tcpipitem, $GUI_FOCUS)
		EndIf

		If _RSC_INIReadSection_key($INI_ColourSection, "BGCOLOR", 0) <> 0 Then GUISetBkColor(_RSC_INIReadSection_key($INI_ColourSection, "BGCOLOR", 0))

		GUISetState()

	Else
		$V2M_GUI = GUICreate(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SCPROMPT"), 10, 10, 0, 0, $WS_MINIMIZE)
		GUISetState(@SW_HIDE)
	EndIf
EndFunc   ;==>_createGUI


;===============================================================================
; Description:			Creates the Automatic GUI, which has a count-down timer
; Parameter(s):			NULL
; Requirement(s):		Requires Predefined Connections to be setup
; Return Value(s):		NULL
; Author(s):            YTS_Jim
; Note(s):
;===============================================================================
Func _createAutoGUI($ConnectionNumber = 0)
	V2M_EventLog("GUI - Automatic GUI selected", $V2M_EventDisplay, "4")
	If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") <> "Manual" Then
		$V2M_Status[1] = $ConnectionNumber
		$V2M_Status[2] = _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $V2M_Status[1], "")
		$V2M_Status[3] = _RSC_INIReadSection_key($INI_SCSection, "SCIP_" & $V2M_Status[1], "")
		$V2M_Status[4] = _RSC_INIReadSection_key($INI_SCSection, "SCPort_" & $V2M_Status[1], "")
		$V2M_Status[5] = _RSC_INIReadSection_key($INI_SCSection, "SCID_" & $V2M_Status[1], "")
		V2M_EventLog("UVNC Connections settings: name=" & $V2M_Status[2] & ", IP=" & $V2M_Status[3] & ", Port=" & $V2M_Status[4] & ", ID=" & $V2M_Status[5], $V2M_EventDisplay, "7")
		If $V2M_Status[2] <> "" Then
			$test = LoadApp($V2M_Status[2])
			If $test <> 1 Then
				;							MsgBox(0, "Error", "User canceled")
				$V2M_NoGUI = 0
				$V2M_Exit = 1
			Else
				$V2M_NoGUI = 1
				$V2M_Status[11] = 1
				$V2M_Exit = 0
				TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011") & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_TITLE", ""), _FindReplaceNewLine(_RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_LINE1", "")) & @CR & $V2M_Status[2] & @CR & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_SC_START_LINE2", ""), 10)
			EndIf
		EndIf
	Else
		MsgBox(0, "Error", "Predefined connection #" & $ConnectionNumber & " wanted, but no predefined connections configured", 30)
		$V2M_NoGUI = 0
		$V2M_Exit = 1
	EndIf
EndFunc   ;==>_createAutoGUI


;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            YTS_Jim
; Note(s):
;===============================================================================
Func _createMiniGUI()
	Local $curtop = 5
	$V2M_EventDisplay = V2M_EventLog("FUNC - _createMiniGUI()", $V2M_EventDisplay, "8")
	If $V2M_Exit = 0 And $V2M_NoGUI <> 1 Then
		$V2M_GUI = GUICreate(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011"), $V2M_GUI_Width, $V2M_GUI_Height)
		GUISetIcon("logo.ico")

		; INPUT
		$tcpipitem = GUICtrlCreateInput(_RSC_INIReadSection_key($INI_SCSection, "ManualAddress", ""), 60 + $v2m_AdditionalWidth, $curtop, 130, 20)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetState(-1, $GUI_HIDE)

		$tcpipitemLabel = GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD", "TCP/IP"), 10, $curtop, 40 + $v2m_AdditionalWidth, 30 + $v2m_AdditionalHeight)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ADD_TIP", "TIP NOT TRANSLATED"))
		If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
		GUICtrlSetState(-1, $GUI_HIDE)

		$curtop = $curtop + 25 + $v2m_AdditionalHeight
		$portitem = GUICtrlCreateInput(_RSC_INIReadSection_key($INI_SCSection, "ManualPort", "5500"), 60 + $v2m_AdditionalWidth, $curtop, 130, 20)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_PORT_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetState(-1, $GUI_HIDE)

		$portitemLabel = GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_PORT", "PORT"), 10, $curtop, 40 + $v2m_AdditionalWidth, 20 + $v2m_AdditionalHeight)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_PORT_TIP", "TIP NOT TRANSLATED"))
		If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
		GUICtrlSetState(-1, $GUI_HIDE)

		$curtop = $curtop + 25 + $v2m_AdditionalHeight
		$idsitem = GUICtrlCreateInput(_RSC_INIReadSection_key($INI_SCSection, "ManualID", ""), 60 + $v2m_AdditionalWidth, $curtop, 120, 20)
		GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ID_TIP", "TIP NOT TRANSLATED"))
		GUICtrlSetState(-1, $GUI_HIDE)

		If (_RSC_INIReadSection_key($INI_SCSection, "ManualID", "") = "") Then
			$comboitem2 = GUICtrlCreateCombo("", 10 + $v2m_AdditionalWidth, $curtop, 40, 60)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ID_TIP", "TIP NOT TRANSLATED"))
			GUICtrlSetData(-1, " |-ID", "")
		Else
			$comboitem2 = GUICtrlCreateCombo("-ID", 10 + $v2m_AdditionalWidth, $curtop, 40, 60)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_ID_TIP", "TIP NOT TRANSLATED"))
			GUICtrlSetData(-1, " ", "")
		EndIf
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlSetState($idsitem, $GUI_HIDE)

		$curtop = $curtop + 25 + $v2m_AdditionalHeight

		; SERVICE MODE
		If IsAdmin() And $INI_UseSC_Server = "1" Then
			$V2M_EventDisplay = V2M_EventLog("GUI - Display the 'Service Mode' checkbox", $V2M_EventDisplay, "7")
			$YTS_AdminCheckbox = GUICtrlCreateCheckbox(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_SERVICEMODE", "Service Mode"), 10, $V2M_GUI_Height - 50, 196, 14)
			If $INI_colortext1 <> 0 Then GUICtrlSetColor(-1, $INI_colortext1)
			If $INI_ServiceMode <> 0 Then GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_SERVICEMODE_TIP", "TIP NOT TRANSLATED"))
		EndIf


		;		; BUTTONS
		;		$subitem = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_BTN_START", "CONNECT"), 5, $V2M_GUI_Height - 35, 120, 20)
		;		GUICtrlSetBkColor(-1, 0xb8e2b8)
		;		GUICtrlSetColor(-1, 0x424242)
		;		GUICtrlSetFont(-1, 10, 600)
		;		$canitem = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_BTN_EXIT", "EXIT"), 130, $V2M_GUI_Height - 35, 70, 20)
		;		GUICtrlSetBkColor(-1, 0xc3d7ef)
		;		GUICtrlSetColor(-1, 0x424242)
		;		GUICtrlSetFont(-1, 10, 600)
		;		GUICtrlSetState($subitem, $GUI_DEFBUTTON)


		GUICtrlSetState($tcpipitem, $GUI_SHOW)
		GUICtrlSetState($tcpipitemLabel, $GUI_SHOW)
		GUICtrlSetState($portitem, $GUI_SHOW)
		GUICtrlSetState($portitemLabel, $GUI_SHOW)
		GUICtrlSetState($comboitem2, $GUI_SHOW)
		If GUICtrlRead($comboitem2) = "-ID" Then
			GUICtrlSetState($idsitem, $GUI_SHOW)
		Else
			GUICtrlSetState($idsitem, $GUI_HIDE)
		EndIf
		GUICtrlSetState($tcpipitem, $GUI_FOCUS)

		If _RSC_INIReadSection_key($INI_ColourSection, "BGCOLOR", 0) <> 0 Then GUISetBkColor(_RSC_INIReadSection_key($INI_ColourSection, "BGCOLOR", 0))

		;Site annotation
		;$INI_WebPage = _RSC_INIReadSection_key($INI_ColourSection, "WebPage", "")
		If ($INI_Set_webpage = "1") And ($INI_WebPage <> "") Then
			$V2M_EventDisplay = V2M_EventLog("GUI - $INI_Set_webpage = 1", $V2M_EventDisplay, "7")
			; BUTTONS
			$subitem = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_BTN_START", "CONNECT"), 5, $V2M_GUI_Height - 35, 120, 20)
			GUICtrlSetBkColor(-1, 0x81ff81)
			GUICtrlSetColor(-1, 0x424242)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_BTN_START_TIP", "TIP NOT TRANSLATED"))
			GUICtrlSetState($subitem, $GUI_DEFBUTTON)
			$canitem = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_BTN_EXIT", "EXIT"), 130, $V2M_GUI_Height - 35, 65, 20)
			GUICtrlSetBkColor(-1, 0xff8181)
			GUICtrlSetColor(-1, 0x424242)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_BTN_EXIT_TIP", "TIP NOT TRANSLATED"))
			$GUI_WebPage = GUICtrlCreateLabel(($INI_WebPage), 5, $V2M_GUI_Height - 16, 185, 181, $SS_CENTER)
			GUICtrlSetFont(-1, 9, 400, 4)
			GUICtrlSetColor(-1, 0x0000ff)
			GUICtrlSetCursor(-1, 0)
		Else
			$V2M_EventDisplay = V2M_EventLog("GUI - Webpage not displayed: $INI_WebPage = " & $INI_WebPage & ", $INI_Set_webpage = " & $INI_Set_webpage, $V2M_EventDisplay, "1")
			; BUTTONS
			$subitem = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_BTN_START", "CONNECT"), 5, $V2M_GUI_Height - 30, 120, 20)
			GUICtrlSetBkColor(-1, 0x81ff81)
			GUICtrlSetColor(-1, 0x424242)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_UVNC_BTN_START_TIP", "TIP NOT TRANSLATED"))
			GUICtrlSetState($subitem, $GUI_DEFBUTTON)
			$canitem = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_BTN_EXIT", "EXIT"), 130, $V2M_GUI_Height - 30, 65, 20)
			GUICtrlSetBkColor(-1, 0xff8181)
			GUICtrlSetColor(-1, 0x424242)
			GUICtrlSetTip(-1, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_BTN_EXIT_TIP", "TIP NOT TRANSLATED"))
		EndIf

		_RSC_CreateContextMenus()
		GUISetState()

	Else
		$V2M_GUI = GUICreate(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011"), 10, 10, 0, 0, $WS_MINIMIZE)
		GUISetState(@SW_HIDE)
	EndIf
EndFunc   ;==>_createMiniGUI

;===============================================================================
; Description:			If commandline arguements are present, this function is called
;						which then handles the commandline arguements appropriately
; Parameter(s):			NULL
; Requirement(s):		NULL
; Return Value(s):		NULL
; Author(s):            YTS_Jim
; Note(s):
;===============================================================================
Func _SCP_cmdline()
	V2M_EventLog("FUNC - _SCP_cmdline()", "", "8")
	Local $Local_loop = 0
	Do
		ConsoleWrite("$cmdline[0] = " & $cmdline[0] & "$local_loop = " & $Local_loop & @CRLF)
		V2M_EventLog("$cmdline[0] = " & $cmdline[0] & "$local_loop = " & $Local_loop, $V2M_EventDisplay, "8")
		$Local_loop = $Local_loop + 1
		;       $V2M_SCP_cmdline[1] = StringLower($cmdline[1])
		V2M_EventLog("$cmdline[" & $Local_loop & "] = " & $cmdline[$Local_loop], "", "7")
		Switch StringLower($cmdline[$Local_loop])
			Case "install", "-i", "/i"
				V2M_EventLog("CMDLINE - INSTALL Arguement found", "", "4")
				;                       InstallService()
				;                       $V2M_Exit = 1
			Case "servicemode", "-servicemode", "/sm", "-sm"
				V2M_EventLog("CMDLINE - SERVICEMODE Arguement found", "", "4")
				;				If ($Local_loop + 1) = 0 Or ($Local_loop + 1) = 1 Then
				$INI_ServiceMode = $cmdline[$Local_loop + 1]
				$Local_loop = $Local_loop + 1
				;				EndIf
			Case "remove", "-u", "/u", "uninstall"
				V2M_EventLog("CMDLINE - REMOVE Arguement found", $V2M_EventDisplay, "4")
				;                       RemoveService()
				;                       $V2M_Exit = 1
			Case "/connect", "-c", "/c", "-connect"
				V2M_EventLog("CMDLINE - CONNECT Arguement found", $V2M_EventDisplay, "4")
				If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") <> "Manual" Then
					_createAutoGUI($cmdline[$Local_loop + 1])
					;					$V2M_Status[1] = $cmdline[$Local_loop + 1]
					;					$V2M_Status[2] = _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $V2M_Status[1], "")
					;					$V2M_Status[3] = _RSC_INIReadSection_key($INI_SCSection, "SCIP_" & $V2M_Status[1], "")
					;					$V2M_Status[4] = _RSC_INIReadSection_key($INI_SCSection, "SCPort_" & $V2M_Status[1], "")
					;					$V2M_Status[5] = _RSC_INIReadSection_key($INI_SCSection, "SCID_" & $V2M_Status[1], "")
					;					V2M_EventLog("UVNC Connections settings: name=" & $V2M_Status[2] & ", IP=" & $V2M_Status[3] & ", Port=" & $V2M_Status[4] & ", ID=" & $V2M_Status[5], $V2M_EventDisplay, "7")
					;					If $V2M_Status[2] <> "" Then
					;						$test = LoadApp($V2M_Status[2])
					;						If $test <> 1 Then
					;							;							MsgBox(0, "Error", "User canceled")
					;							$V2M_NoGUI = 0
					;							$V2M_Exit = 0
					;						Else
					;							$V2M_NoGUI = 1
					;							$V2M_Status[11] = 1
					;							$V2M_Exit = 0
					;						EndIf
					;					EndIf
					;					$Local_loop = $cmdline[0]
				Else
					MsgBox(0, "Error", "Predefined connection #" & $cmdline[$Local_loop + 1] & " wanted, but no predefined connections configured", 30)
					$V2M_NoGUI = 0
					$V2M_Exit = 0
				EndIf
				;                       $V2M_Status[12] = 1
				; when launched with connect string, port setting (and if defined server, user & pass) are read from the INI file.
				;                       $V2M_Exit = 1
				;                       $V2M_NoGUI = 1
			Case "/?", "-help", "-h"
				V2M_EventLog("CMDLINE - HELP Arguement found", $V2M_EventDisplay, 4)
				ConsoleWrite(" - - - Help - - - " & @CRLF)
				ConsoleWrite("params : " & @CRLF)
				ConsoleWrite("  -c 	: Read predefined connection from INI and connect [-c x] where x is connection number (0 is first)" & @CRLF)
				ConsoleWrite("  -sm : Set service mode checkbox(next argument needs to be 0 or 1 for checked)" & @CRLF)
				ConsoleWrite("  -h 	: Show this help" & @CRLF)
				;                       ConsoleWrite("  -i : install service" & @CRLF)
				;                       ConsoleWrite("  -u : remove service" & @CRLF)
				ConsoleWrite(" - - - - - - - - " & @CRLF)
				;                       $V2M_Exit = 1
			Case "/rerun", "-rerun", "/r", "-r"
				V2M_EventLog("CMDLINE - ReRun Arguement found", $V2M_EventDisplay, 4)
			Case Else
				$V2M_EventDisplay = V2M_EventLog("Cmdline Arguements not recognised", $V2M_EventDisplay, "7")
				TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011") & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_APP_START_TITLE", "APP_START_TITLE"), _FindReplaceNewLine(_RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_APP_START_LINE1", "")) & @CR & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_APP_START_LINE2", ""), 10)
		EndSwitch
		Sleep(100)
	Until $Local_loop = $cmdline[0]
EndFunc   ;==>_SCP_cmdline

;===============================================================================
; Description:          This is executed when Autoit exits
; Parameter(s):         none
; Requirement(s):       none
; Return Value(s):      none
; Author(s):            YTS_Jim
; Note(s):                      Function name can be renamed, but only if ;Opt("OnExitFunc", "OnAutoItExit") is set (and OnAutoItExit is changed to new name)
;
;===============================================================================
Func OnAutoItExit()
	$V2M_EventDisplay = V2M_EventLog("FUNC - OnAutoItExit()", $V2M_EventDisplay, "8")
	Local $timer, $return
	;	Global $YTS_Cleanup, $UVNC_Installed_Path
	$V2M_EventDisplay = V2M_EventLog("FUNC - @exitCode = " & @exitCode, $V2M_EventDisplay, "8")
	If @Compiled And (@exitCode >= 3) Then
		$V2M_EventDisplay = V2M_EventLog("FUNC - @Compiled And (@exitCode >= 3) so we create shortcut in: " & @StartupDir, $V2M_EventDisplay, "8")
		;		FileCreateShortcut(@ScriptFullPath, @StartupDir & "\" & _RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SCPROMPT") & ".lnk", @ScriptDir, "", "This Will Start " & _RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SCPROMPT") & " the next time this user logs on.", @ScriptDir & "\Logo.ico")
		SetError(1)
	Else
		TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt 2011") & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_APP_EXITING_TITLE", "APP_EXITING_TITLE"), _FindReplaceNewLine(_RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_APP_EXITING_LINE1", "")) & @CR & _RSC_INIReadSection_key($INI_Translation_Section, "TRAYTIP_APP_EXITING_LINE2", ""), 30)
		If @OSVersion = "WIN_VISTA" Or @OSVersion = "WIN_7" Or @OSVersion = "WIN_2008" Or @OSVersion = "WIN_2008R2" Then
			V2M_EventLog("EXIT - @OSVersion = " & @OSVersion, $V2M_EventDisplay, "7")
			V2M_EventLog("EXIT - AERO test (Before Enable) = " & Vista_GetComposition(), $V2M_EventDisplay, "6")
			Vista_ControlAero("Enable")
			V2M_EventLog("EXIT - VISTA AERO test (After Enable) = " & Vista_GetComposition(), $V2M_EventDisplay, "6")
			If (_RSC_INIReadSection_key($INI_CommonSection, "MAIN_DISABLE_UAC", 1) = 1) And $YTS_Cleanup = 1 Then
				Vista_ControlUAC("Restore")
			EndIf
		EndIf
		;stop vnc connections
		V2MExitVNC()

		;turn off mouse sonar
		#Region Mouse Sonar
		If _RSC_INIReadSection_key($INI_CommonSection, "MAIN_ENABLE_SONAR", 1) = 1 Then
			DllCall("User32", "int", "SystemParametersInfo", _
					"int", $SPI_SETMOUSESONAR, _
					"int", 0, _
					"int", 0, _
					"int", BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE) _
					)
			$V2M_EventDisplay = V2M_EventLog("Usability - Sonar is now disabled", $V2M_EventDisplay, "1")
		EndIf
		#EndRegion Mouse Sonar

		;turn the wallpaper back on ...
		If $YTS_Cleanup <> 0 Then
			$V2M_EventDisplay = V2M_EventLog("Usability - Wallpaper is being restored", $V2M_EventDisplay, "1")
			DllCall("user32.dll", "int", "SystemParametersInfo", "int", 20, "int", 0, "str", RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "Wallpaper"), "int", 3)
			If StringInStr(@ScriptDir, FileGetLongName(@TempDir)) Then
				V2M_EventLog("EXIT - Path is in the %temp% directory", $V2M_EventDisplay, "4")
				If @Compiled Then
					V2M_EventLog("EXIT - Application is Compiled, the whole directory (and sub-directories) will now be deleted", $V2M_EventDisplay, "4")
					_SelfDelete(5)
				EndIf
			Else
				V2M_EventLog("EXIT - Path is NOT in the %temp% directory, VNC2Me must be installed or not using 7z or other self executing packaging, will NOT delete files", $V2M_EventDisplay, "4")
				V2M_EventLog("DEBUG - @ScriptDir = " & @ScriptDir & ", FileGetLongName(@TempDir) = " & FileGetLongName(@TempDir) & "$UVNC_Installed_Path = " & $UVNC_Installed_Path, $V2M_EventDisplay, "9")
			EndIf
		EndIf
		If FileExists(@StartupDir & "\" & _RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SCPROMPT") & ".lnk") Then FileDelete(@StartupDir & "\" & _RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SCPROMPT") & ".lnk")
		SetError(0)
	EndIf
	;	_StartStopedVNCFlavour()
	DirRemove(@TempDir & "\uvnc", 1)
	_RefreshSystemTray(50)
	$V2M_EventDisplay = V2M_EventLog(' ')
	;	Exit
EndFunc   ;==>OnAutoItExit

;===============================================================================
;
; Description:          Reads the INI predefined connection, to determine how many connections exist ...
; Parameter(s):         NULL
; Requirement(s):       Predefined connections need to be setup in the INI file
;                                       Two (or more) predefined connections cannot have the same name
; Return Value(s):      $return (number of predefined connections)
; Author(s):            YTS_Jim
; Note(s):
;
;===============================================================================
Func V2M_UVNC_NumberPredefConnect()
	$V2M_EventDisplay = V2M_EventLog("FUNC - V2M_UVNC_NumberPredefConnect()", $V2M_EventDisplay, "8")
	Local $return = '', $loopcount = 0
	While (Not _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "") = "")
		$V2M_EventDisplay = V2M_EventLog('UVNC Predefined Connections loopcount = ' & $loopcount, $V2M_EventDisplay, "8")
		If _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount + 1, "") = "" Then
			$return = $loopcount + 1
			ExitLoop
		Else
			$loopcount = $loopcount + 1 ; increment loopcount
		EndIf
	WEnd
	$V2M_EventDisplay = V2M_EventLog('UVNC - Number Predefined Connections = ' & $return, $V2M_EventDisplay, "7")
	Return $return
	;       Local $return = '', $loopcount = 0
	;       While (_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "") <> "")
	;               V2M_EventLog('UVNC Number Predefined Connections = ' & $loopcount)
	;               $loopcount = $loopcount + 1 ; increment loopcount
	;       WEnd
	;       Return $loopcount - 1
EndFunc   ;==>V2M_UVNC_NumberPredefConnect


;===============================================================================
;
; Description:          Changes the Logos and hides the manual connection inputs or shows, dependant on radiobutton selection
; Parameter(s):         $what = what radio button was selected
; Requirement(s):       Needs the RadioButton GUI to be in use
; Return Value(s):      NULL, but Global $V2M_which_radio contains $what after running.
; Author(s):            YTS_Jim
; Note(s):
;
;===============================================================================
Func _ChangeRadioSelection($what)
	$V2M_EventDisplay = V2M_EventLog("FUNC - _ChangeRadioSelection()", $V2M_EventDisplay, "8")
	If $what <> $INI_ManualConnectionName Then
		If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Button" Then _setphoto()
		GUICtrlSetState($tcpipitem, $GUI_HIDE)
		GUICtrlSetState($tcpipitemLabel, $GUI_HIDE)
		GUICtrlSetState($portitem, $GUI_HIDE)
		GUICtrlSetState($portitemLabel, $GUI_HIDE)
		GUICtrlSetState($comboitem2, $GUI_HIDE)
		GUICtrlSetState($idsitem, $GUI_HIDE)
		If FileExists(@ScriptDir & "\Logo" & $what & ".jpg") Then
			GUICtrlSetImage($V2M_LogoPic, @ScriptDir & "\Logo" & $what & ".jpg")
			$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: Logo" & $what & ".jpg", $V2M_EventDisplay, "4")
		ElseIf FileExists(@ScriptDir & "\NoImage.jpg") Then
			GUICtrlSetImage($V2M_LogoPic, @ScriptDir & "\NoImage.jpg")
			$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: NoImage.jpg", $V2M_EventDisplay, "4")
		ElseIf FileExists(@ScriptDir & "\Logo.jpg") Then
			GUICtrlSetImage($V2M_LogoPic, @ScriptDir & "\Logo.jpg")
			$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: Logo.jpg", $V2M_EventDisplay, "4")
		Else
			GUICtrlSetImage($V2M_LogoPic, "")
			$V2M_EventDisplay = V2M_EventLog("GUI - Set image to: ''", $V2M_EventDisplay, "4")
		EndIf
		$V2M_which_radio = $what
		;		$V2M_EventDisplay = V2M_EventLog('GUI - ' & _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") & ' "' & $what & '" Selected.', $V2M_EventDisplay, "4")
	ElseIf $what = $INI_ManualConnectionName Then
		GUICtrlSetState($tcpipitem, $GUI_SHOW)
		GUICtrlSetState($tcpipitemLabel, $GUI_SHOW)
		GUICtrlSetState($portitem, $GUI_SHOW)
		GUICtrlSetState($portitemLabel, $GUI_SHOW)
		GUICtrlSetState($comboitem2, $GUI_SHOW)
		If GUICtrlRead($comboitem2) = "-ID" Then
			GUICtrlSetState($idsitem, $GUI_SHOW)
		Else
			GUICtrlSetState($idsitem, $GUI_HIDE)
		EndIf
		;		If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Button" And $INI_SetPhoto = "1" Then
		;			GUICtrlSetBkColor($SetPhoto_BG, $INI_text1BGColor)
		;                       GUICtrlSetState($SetPhoto_BG, $GUI_DISABLE)
		;set the logo BG to be  GUI BG colour ...
		;		EndIf
		GUICtrlSetImage($V2M_LogoPic, "")
		$V2M_which_radio = $INI_ManualConnectionName
		V2M_EventLog('GUI - ' & _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") & ' changed selection to: ' & $what, $V2M_EventDisplay, "4")
	EndIf
EndFunc   ;==>_ChangeRadioSelection

;===============================================================================
;
; Description:          Creates a batch script that is run (at program exit) which pauses, then deletes the directory that was running the app
; Parameter(s):         $iDelay = how long do you want to pause for (how long will it take application to exit) before trying to delete the whole directory.
; Requirement(s):
; Return Value(s):      $V2M_EventDisplay
; Author(s):            ??? / YTS_Jim         (can't remmember where i got it from, and i think its been modified since then)
; Note(s):                      If deletion fails after first attempt, the script will return to the start, and re-run
;                                       (pausing again for the set amount of time.
;
;===============================================================================
Func _SelfDelete($iDelay = 4)
	$V2M_EventDisplay = V2M_EventLog("FUNC - _SelfDelete()", $V2M_EventDisplay, "8")
	If @Compiled Then
		Local $sCmdFile
		FileDelete(@TempDir & "\scratch.bat")
		$sCmdFile = 'title=Removing UVNC Prompt' & @CRLF _
				 & ':loop' & @CRLF _
				 & 'ping -n ' & $iDelay & ' 127.0.0.1 > nul' & @CRLF _
				 & 'rmdir "' & @ScriptDir & '" /S /Q' & @CRLF _
				 & 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
				 & 'del ' & @TempDir & '\scratch.bat'
		FileWrite(@TempDir & "\scratch.bat", $sCmdFile)
		Run(@TempDir & "\scratch.bat", @TempDir, @SW_MINIMIZE)
	EndIf
EndFunc   ;==>_SelfDelete


;===============================================================================
;
; Description:          Creates the ComboBox List of names from the scprompt.ini (for predefined connections)
; Parameter(s):         $loopcount = what predefined connection number do you want to start at.
;                                       (we once started at 0, but now we start at 1, as 0 name is added in combobox creation)
;                                       Adds the manual connection name at the bottom (if not disabled)
; Requirement(s):
; Return Value(s):      $V2M_EventDisplay
; Author(s):            YTS_Jim
; Note(s):
;
;===============================================================================
Func V2M_UVNC_CreateCombos($loopcount = 0)
	$V2M_EventDisplay = V2M_EventLog("FUNC - V2M_UVNC_CreateCombos()", $V2M_EventDisplay, "8")
	Local $return = '', $V2M_UVNC_ConnectNames = ''
	While (Not _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount - 1, "") = "")
		; While $loopcount < $iniCount
		$V2M_EventDisplay = V2M_EventLog('GUI - V2M_UVNC_CreateCombos() loopcount = ' & $loopcount, $V2M_EventDisplay, "8")
		If $V2M_UVNC_ConnectNames = "" Then
			$V2M_UVNC_ConnectNames = _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "")
		Else
			$V2M_UVNC_ConnectNames = $V2M_UVNC_ConnectNames & "|" & _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "")
		EndIf
		$loopcount = $loopcount + 1 ; increment loopcount
		If _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "") = "" Then
			ExitLoop
		EndIf
	WEnd
	If $INI_DisableManualConnections <> "1" Then
		If $V2M_UVNC_ConnectNames = "" Then
			$V2M_UVNC_ConnectNames = $INI_ManualConnectionName
		Else
			$V2M_UVNC_ConnectNames = $V2M_UVNC_ConnectNames & "|" & $INI_ManualConnectionName
			;       $V2M_UVNC_ConnectNames = $V2M_UVNC_ConnectNames & ""
		EndIf
	EndIf
	$return = $V2M_UVNC_ConnectNames
	$V2M_EventDisplay = V2M_EventLog('GUI - Combo - $V2M_UVNC_ConnectNames = ' & $V2M_UVNC_ConnectNames, $V2M_EventDisplay, "7")
	Return $return
EndFunc   ;==>V2M_UVNC_CreateCombos



;===============================================================================
;
; Description:          Creates radio buttons for each predefined connection
; Parameter(s):         $loopcount      =       if 0, it starts at predefined connection 0 (the first), else it starts whereever you want it
; Requirement(s):
; Return Value(s):
; Author(s):            YTS_Jim
; Note(s):
;
;===============================================================================
Func V2M_UVNC_CreateRadios($loopcount = 0, $height = 55)
	$V2M_EventDisplay = V2M_EventLog("FUNC - V2M_UVNC_CreateRadios($loopcount = " & $loopcount & ", $height = " & $height & ")", $V2M_EventDisplay, "8")
	Local $V2M_UVNC_ConnectNames = ''
	While (_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "") <> "")
		Assign("radio_" & $loopcount, GUICtrlCreateRadio(_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, ""), $V2M_GUI_Width - 135, $height, 135, 20))
		$height = $height + 18
		If $INI_colortext2 <> 0 Then GUICtrlSetColor(-1, $INI_colortext2)
		V2M_EventLog('V2M_UVNC_CreateRadios() loopcount = ' & $loopcount, $V2M_EventDisplay, "8")
		$loopcount = $loopcount + 1 ; increment loopcount
		If _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "") = "" Then
			ExitLoop
		EndIf
	WEnd
	$V2M_EventDisplay = V2M_EventLog('GUI - Radio - Predefined Radio Buttons Created', $V2M_EventDisplay, "7")
	If $INI_DisableManualConnections <> "1" Then
		$V2M_EventDisplay = V2M_EventLog('GUI - Radio - ' & $INI_ManualConnectionName & ' Radio Button Created', $V2M_EventDisplay, "7")
		$radio_Manual = GUICtrlCreateRadio($INI_ManualConnectionName, $V2M_GUI_Width - 135, $height, 135, 20)
		If $INI_colortext2 <> 0 Then GUICtrlSetColor(-1, $INI_colortext2)
	EndIf
EndFunc   ;==>V2M_UVNC_CreateRadios

;===============================================================================
;
; Description:          Reads the ComboBox, and relates it to a Predefined connection number
; Parameter(s):         $name   =       Text string to compaire with predined connections
; Requirement(s):       Predefined connections need to be setup in the INI file
;                                       Two (or more) predefined connections cannot have the same name
; Return Value(s):      $return (predefined connection number)
; Author(s):            YTS_Jim
; Note(s):
;
;===============================================================================
Func V2M_UVNC_NamesNumber($name = 'NULL')
	$V2M_EventDisplay = V2M_EventLog("FUNC - V2M_UVNC_NamesNumber()", $V2M_EventDisplay, "8")
	Local $return = '', $loopcount = 0
	If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Combo" Then
		While (_RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "") <> "")
			;       While $loopcount < $iniCount
			$V2M_EventDisplay = V2M_EventLog('UVNC Names $loopcount = ' & $loopcount & ', $name = ' & $name, $V2M_EventDisplay, "8")
			If $name = _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $loopcount, "") Then
				$return = $loopcount
				ExitLoop
			EndIf
			$loopcount = $loopcount + 1 ; increment loopcount
		WEnd
	EndIf
	;       $V2M_UVNC_ConnectNames = $V2M_UVNC_ConnectNames & ""
	;       $return = $V2M_UVNC_ConnectNames
	Return $return
EndFunc   ;==>V2M_UVNC_NamesNumber

;===============================================================================
; Description:		Controls Service mode in SCPrompt.
; Parameter(s):		$mode = Start / Stop / Uninstall
; Requirement(s):	?
; Return Value(s):	NULL
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Func _VNCServiceMode($mode = "Start")
	$V2M_EventDisplay = V2M_EventLog("FUNC - _VNCServiceMode($mode = " & $mode & ")", $V2M_EventDisplay, "8")
	Local $x = 0, $UVNC_Path_Split, $LocalReturn, $Local_loop = 0
	If $mode = "Uninstall" Then
		V2M_EventLog("SERVICE - Uninstall has been Requested", $V2M_EventDisplay, "4")
		$V2M_EventDisplay = V2M_EventLog('Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -uninstall", @ScriptDir)', $V2M_EventDisplay, "7")
		RunWait(@ScriptDir & "\" & $V2M_VNC_UVNC & " -uninstall", @ScriptDir)
		Sleep(1000)
		;		If _Service_StopOK("uvnc_service") Then
		If _Service_Stop("uvnc_service") Then
			_Service_Delete("uvnc_service")
		EndIf
		;		EndIf
		RunWait(@ComSpec & " /c sc stop uvnc_service", @ScriptDir, @SW_MINIMIZE)
		RunWait(@ComSpec & " /c sc stop uvnc_service", @ScriptDir, @SW_MINIMIZE)
		RunWait(@ComSpec & " /c sc delete uvnc_service", @ScriptDir, @SW_MINIMIZE)
		RunWait(@ComSpec & " /c sc delete uvnc_service", @ScriptDir, @SW_MINIMIZE)
	ElseIf $mode = "Stop" Then
		$V2M_EventDisplay = V2M_EventLog("SERVICE - Stopping...", $V2M_EventDisplay, "4")
		V2M_EventLog("SERVICE - User has exited application, cleanup of settings, files and services will be unregistered", $V2M_EventDisplay, "4")
		$YTS_Cleanup = 1
		If StringInStr(FileGetLongName(@ScriptDir), FileGetLongName($UVNC_Installed_Path)) Then
			V2M_EventLog("SERVICE - cleanup our service mode, by removing the service", $V2M_EventDisplay, "4")
			$V2M_EventDisplay = V2M_EventLog('Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -uninstall", @ScriptDir)', $V2M_EventDisplay, "7")
			Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -uninstall", @ScriptDir)
		ElseIf $UVNC_Installed_Path <> "" Then
			V2M_EventLog("SERVICE - cleanup existing UVNC install settings, such as removing 'service_commandline' settings from existing UVNC install", $V2M_EventDisplay, "4")
			$LocalReturn = IniDelete($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline")
			If $LocalReturn <> 0 And IniRead($UVNC_Installed_Path & "\ultravnc.ini", "admin", "scprompt_service_commandline", "") <> "" Then
				IniWrite($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline", IniRead($UVNC_Installed_Path & "\ultravnc.ini", "admin", "scprompt_service_commandline", ""))
				$LocalReturn = IniDelete($UVNC_Installed_Path & "\ultravnc.ini", "admin", "scprompt_service_commandline")
				If $LocalReturn <> 0 Then
					IniWrite($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline", "")
				EndIf
			Else
				Do
					$LocalReturn = IniDelete($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline")
					Sleep(250)
					$Local_loop = $Local_loop + 1
				Until $LocalReturn = 1 Or $Local_loop >= 10
				$Local_loop = 0
			EndIf
			;Local $Service_QueryStatus = _Service_QueryStatus("uvnc_service")
			$V2M_EventDisplay = V2M_EventLog("SERVICE - _Service_QueryStatus('uvnc_service') = " & $Service_QueryStatus[0] & "$Service_QueryStatus[1] = " & $Service_QueryStatus[1], $V2M_EventDisplay, "8")
			If $Service_QueryStatus[0] Then
				Do
					$LocalReturn = _Service_Stop("uvnc_service")
					;				$LocalReturn = _SetServiceState("uvnc_service", "Stop")
					$V2M_EventDisplay = V2M_EventLog("SERVICE - Stopping Service, $LocalReturn = " & $LocalReturn & ", $Local_loop = " & $Local_loop & ", _Service_Stop('uvnc_service') = " & $LocalReturn & ", _Service_QueryStatus('uvnc_service') = " & _Service_QueryStatus("uvnc_service"), $V2M_EventDisplay, "8")
					Sleep(250)
					$Local_loop = $Local_loop + 1
				Until $LocalReturn = "Success" Or $Local_loop >= 10
			Else
				$V2M_EventDisplay = V2M_EventLog("SERVICE - _Service_QueryStatus('uvnc_service') = " & _Service_QueryStatus("uvnc_service"), $V2M_EventDisplay, "8")
			EndIf
			$Local_loop = 0
			$V2M_EventDisplay = V2M_EventLog("SERVICE - Stoped state = " & $LocalReturn, $V2M_EventDisplay, "7")
			$V2M_EventDisplay = V2M_EventLog("SERVICE - Starting service ...", $V2M_EventDisplay, "4")
			;			$V2M_EventDisplay = V2M_EventLog("SERVICE - Start state = " & _SetServiceState("uvnc_service", "Start"), $V2M_EventDisplay, "7")
			Do
				$LocalReturn = _Service_Start("uvnc_service")
				;				$LocalReturn = _SetServiceState("uvnc_service", "Start")
				$V2M_EventDisplay = V2M_EventLog("SERVICE - Starting Service, $LocalReturn = " & $LocalReturn & ", $Local_loop = " & $Local_loop, $V2M_EventDisplay, "8")
				Sleep(250)
				$Local_loop = $Local_loop + 1
			Until $LocalReturn = "Success" Or $Local_loop >= 10
			$Local_loop = 0
		ElseIf (IniRead($UVNC_Installed_Path & "\ultravnc.ini", "admin", "scprompt_Installed_Service", "0") = 1) Or (IniRead(@ScriptDir & "\ultravnc.ini", "admin", "scprompt_Installed_Service", "0") = 1) Then
			V2M_EventLog("SERVICE - Removing UVNC service (as we installed it)", $V2M_EventDisplay, "4")
			Do
				$LocalReturn = _Service_Stop("uvnc_service")
				;				$LocalReturn = _SetServiceState("uvnc_service", "Stop")
				V2M_EventLog("SERVICE - Attempt to stop service, return: " & $LocalReturn, $V2M_EventDisplay, "8")
				$V2M_EventDisplay = V2M_EventLog("SERVICE - Stopping Service, $LocalReturn = " & $LocalReturn & ", $Local_loop = " & $Local_loop & ", _Service_QueryStatus('uvnc_service') = " & _Service_QueryStatus("uvnc_service"), $V2M_EventDisplay, "8")
				Sleep(250)
				$Local_loop = $Local_loop + 1
			Until $LocalReturn = "Success" Or $Local_loop >= 10 Or $LocalReturn = -1
			$Local_loop = 0
			$V2M_EventDisplay = V2M_EventLog("SERVICE - Stoped state = " & $LocalReturn, $V2M_EventDisplay, "7")
			$V2M_EventDisplay = V2M_EventLog('Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -uninstall", @ScriptDir)', $V2M_EventDisplay, "9")
			$Local_loop = 0
			Do
				If FileExists($UVNC_Installed_Path & "\ultravnc.ini") Then
					$LocalReturn = IniDelete($UVNC_Installed_Path & "\ultravnc.ini", "admin", "scprompt_Installed_Service")
				ElseIf FileExists(@ScriptDir & "\ultravnc.ini") Then
					$LocalReturn = IniDelete($UVNC_Installed_Path & "\ultravnc.ini", "admin", "scprompt_Installed_Service")
				EndIf
				Sleep(250)
				$Local_loop = $Local_loop + 1
			Until $LocalReturn = 1 Or $Local_loop >= 10
			Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -uninstall", @ScriptDir)
		EndIf
		;		EndIf
		;		;		Sleep(10000)
		;		;		$V2M_EventDisplay = V2M_EventLog("SERVICE - Starting service ...", $V2M_EventDisplay, "4")
		;		;		$V2M_EventDisplay = V2M_EventLog("SERVICE - Started state = " & _SetServiceState("uvnc_service", "Start"), $V2M_EventDisplay, "7")
		;		;		_SetServiceState("uvnc_service", "Start")
	Else ;start
		$V2M_EventDisplay = V2M_EventLog("SERVICE - Starting...", $V2M_EventDisplay, "4")
		If $UVNC_ExistingService <> 0 Then
			$V2M_EventDisplay = V2M_EventLog("SERVICE - Existing UVNC_SERVICE was found ... lets use it ...", $V2M_EventDisplay, "4")
			$V2M_EventDisplay = V2M_EventLog("SERVICE - UVNC_SERVICE path is: '" & $UVNC_Installed_Path & "'", $V2M_EventDisplay, "9")
			If IniRead($UVNC_Installed_Path & "\ultravnc.ini", "admin", "scprompt_service_commandline", "") <> "" Then
				;scprompt has run before, without cleaning up ...
				$V2M_EventDisplay = V2M_EventLog("SERVICE - SCPrompt failed to cleanup INI on last run ...", $V2M_EventDisplay, "7")
			ElseIf IniRead($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline", "") <> "" Then
				; service_commandline is being used in the current Ultravnc installation, lets save it for later restoral ...
				$LocalReturn = IniWrite($UVNC_Installed_Path & "\ultravnc.ini", "admin", "scprompt_service_commandline", IniRead($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline", ""))
				If $LocalReturn <> 1 Then MsgBox(0, "ERROR", "Can't write to '" & $UVNC_Installed_Path & "\ultravnc.ini'", 60)
				$V2M_EventDisplay = V2M_EventLog("SERVICE - SCPrompt saving original UltraVNC.ini settings for later restoral ...", $V2M_EventDisplay, "7")
			Else
				$V2M_EventDisplay = V2M_EventLog("SERVICE - Failed to read the INI file", $V2M_EventDisplay, "7")
			EndIf
			IniWrite($UVNC_Installed_Path & "\ultravnc.ini", "admin", "service_commandline", $Use_UVNC_Server_CmdLine[1] & $Use_UVNC_Server_CmdLine[2] & $Use_UVNC_Server_CmdLine[3] & " -connect " & $V2M_Status[3] & $Use_UVNC_Connect_Colon & $V2M_Status[4] & $Use_UVNC_Server_CmdLine[4])
			$V2M_EventDisplay = V2M_EventLog("IniWrite(" & $UVNC_Installed_Path & "\ultravnc.ini" & "," & "admin" & "," & "service_commandline" & "," & $Use_UVNC_Server_CmdLine[1] & $Use_UVNC_Server_CmdLine[2] & $Use_UVNC_Server_CmdLine[3] & " -connect " & $V2M_Status[3] & $Use_UVNC_Connect_Colon & $V2M_Status[4] & $Use_UVNC_Server_CmdLine[4] & ")", $V2M_EventDisplay, "7")
			;		$service = "uvnc_service"
			$V2M_EventDisplay = V2M_EventLog("SERVICE - Stopping service ...", $V2M_EventDisplay, "4")
			$V2M_EventDisplay = V2M_EventLog("SERVICE - Stopping Service, $LocalReturn = " & $LocalReturn & ", $Local_loop = " & $Local_loop & ", _Service_QueryStatus('uvnc_service') = " & _Service_QueryStatus("uvnc_service"), $V2M_EventDisplay, "8")
			;			_SetServiceState("uvnc_service", "Stop")
			_Service_Stop("uvnc_service", "Start")
			Sleep(5000)
			$V2M_EventDisplay = V2M_EventLog("SERVICE - Starting service ...", $V2M_EventDisplay, "4")
			$V2M_EventDisplay = V2M_EventLog("SERVICE - Started state = " & _Service_Start("uvnc_service", "Start"), $V2M_EventDisplay, "7")
			;			_SetServiceState("uvnc_service", "Start")
			Sleep(5000)
			;			$V2M_EventDisplay = V2M_EventLog('Run(' & $UVNC_Installed_Path & "\winvnc.exe" & " -connect " & $V2M_Status[3] & $Use_UVNC_Connect_Colon & $V2M_Status[4] & ', $UVNC_Installed_Path, @SW_HIDE)', $V2M_EventDisplay, "7")
			;			Run($UVNC_Installed_Path & "\winvnc.exe" & " -connect " & $V2M_Status[3] & $Use_UVNC_Connect_Colon & $V2M_Status[4], $UVNC_Installed_Path, @SW_HIDE)
			IniWrite($UVNC_Installed_Path & "\ultravnc.ini", "admin", "scprompt_Installed_Service", "0")
		Else ; $UVNC_ExistingService = 0
			;		MsgBox(0, "", "no uvnc_service found", 2)
			V2M_EventLog('Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -install", @ScriptDir)', $V2M_EventDisplay, "7")
			IniWrite(@ScriptDir & "\ultravnc.ini", "admin", "service_commandline", $Use_UVNC_Server_CmdLine[1] & $Use_UVNC_Server_CmdLine[2] & $Use_UVNC_Server_CmdLine[3] & " -connect " & $V2M_Status[3] & $Use_UVNC_Connect_Colon & $V2M_Status[4])
			Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -install", @ScriptDir)
			$V2M_EventDisplay = V2M_EventLog("MODE - SCPrompt has not found existing service ... Installing one now ...", $V2M_EventDisplay, "7")
			IniWrite($UVNC_Installed_Path & "\ultravnc.ini", "admin", "scprompt_Installed_Service", "1")
		EndIf
	EndIf
EndFunc   ;==>_VNCServiceMode

;===============================================================================
; Description:			Reads all info needed to start the VNC connection
; Parameter(s):			NULL
; Requirement(s):		SCPrompt GUI
; Return Value(s):		NULL
; Author(s):            YTS_Jim
; Note(s):
;===============================================================================
Func _VNCRun()
	$V2M_EventDisplay = V2M_EventLog("FUNC - _VNCRun()", $V2M_EventDisplay, "8")
	If $cmdline[0] = 0 Then
		If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") <> "Manual" Then
			If _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") = "Combo" And GUICtrlRead($comboitem1) <> $INI_ManualConnectionName Then
				V2M_EventLog("VNC - Using '$comboitem1' selection to start UVNC", $V2M_EventDisplay, "4")
				$V2M_Status[1] = V2M_UVNC_NamesNumber(GUICtrlRead($comboitem1))
				$V2M_Status[2] = _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $V2M_Status[1], "")
				$V2M_Status[3] = _RSC_INIReadSection_key($INI_SCSection, "SCIP_" & $V2M_Status[1], "")
				$V2M_Status[4] = _RSC_INIReadSection_key($INI_SCSection, "SCPort_" & $V2M_Status[1], "")
				$V2M_Status[5] = _RSC_INIReadSection_key($INI_SCSection, "SCID_" & $V2M_Status[1], "")
			ElseIf _RSC_INIReadSection_key($INI_GUISection, "GUI_Type", "Radio") <> "Combo" And $V2M_which_radio <> $INI_ManualConnectionName Then
				If $V2M_NoGUI <> 1 Then
					V2M_EventLog("VNC - Using '$V2M_which_radio' selection to start UVNC", $V2M_EventDisplay, "4")
					$V2M_Status[1] = $V2M_which_radio
				Else
					V2M_EventLog("VNC - Using Commandline '-c " & $V2M_Status[1] & "' to start UVNC", $V2M_EventDisplay, "4")
				EndIf
				$V2M_Status[2] = _RSC_INIReadSection_key($INI_SCSection, "SCName_" & $V2M_Status[1], "")
				$V2M_Status[3] = _RSC_INIReadSection_key($INI_SCSection, "SCIP_" & $V2M_Status[1], "")
				$V2M_Status[4] = _RSC_INIReadSection_key($INI_SCSection, "SCPort_" & $V2M_Status[1], "")
				$V2M_Status[5] = _RSC_INIReadSection_key($INI_SCSection, "SCID_" & $V2M_Status[1], "")
			Else
				V2M_EventLog("VNC - Using '" & $INI_ManualConnectionName & "' selection to start UVNC", $V2M_EventDisplay, "4")
				$V2M_Status[2] = $INI_ManualConnectionName
				$V2M_Status[3] = GUICtrlRead($tcpipitem)
				$V2M_Status[4] = GUICtrlRead($portitem)
				$V2M_Status[5] = GUICtrlRead($idsitem)
			EndIf
			V2M_EventLog("UVNC Connections settings: name=" & $V2M_Status[2] & ", IP=" & $V2M_Status[3] & ", Port=" & $V2M_Status[4] & ", ID=" & $V2M_Status[5], $V2M_EventDisplay, "7")
		Else
			V2M_EventLog("VNC - Using SCPrompt selections to start UVNC", $V2M_EventDisplay, "4")
			$V2M_Status[2] = $INI_ManualConnectionName
			$V2M_Status[3] = GUICtrlRead($tcpipitem)
			$V2M_Status[4] = GUICtrlRead($portitem)
			$V2M_Status[5] = GUICtrlRead($idsitem)
		EndIf
	Else
		V2M_EventLog("VNC - Using $Cmdline Options to start VNC", $V2M_EventDisplay, "4")
	EndIf
	If _RSC_INIReadSection_key($INI_CommonSection, "UseSC_Prompt", "1") = 1 Then
		If $INI_ServiceMode <> 0 And ($UVNC_ExistingService <> 0) Then
			If ($UVNC_Installed_Path <> "") And (_RSC_INIReadSection_key($INI_CommonSection, "Use_Existing_sc_prompt", 0) <> 1) Then
				V2M_EventLog("VNC - NOT using -sc_prompt (ServiceMode, Existing Service, Use_Existing_sc_prompt=0)", $V2M_EventDisplay, "7")
				$Use_UVNC_Server_CmdLine[1] = ""
			Else
				$V2M_EventDisplay = V2M_EventLog("SERVICE - UVNC_SERVICE path is: '" & $UVNC_Installed_Path & "'", $V2M_EventDisplay, "7")
				V2M_EventLog("VNC - Using -sc_prompt (ServiceMode, Existing Service, Use_Existing_sc_prompt=1)", $V2M_EventDisplay, "7")
				$Use_UVNC_Server_CmdLine[1] = " -sc_prompt"
			EndIf
		ElseIf $INI_ServiceMode = 0 Then
			V2M_EventLog("VNC - using -sc_prompt (UserMode)", $V2M_EventDisplay, "7")
			$Use_UVNC_Server_CmdLine[1] = " -sc_prompt"
		Else
			V2M_EventLog("VNC - NOT using -sc_prompt", $V2M_EventDisplay, "7")
			$Use_UVNC_Server_CmdLine[1] = ""
		EndIf
	Else
		V2M_EventLog("VNC - NOT using -sc_prompt (by INI)", $V2M_EventDisplay, "7")
		$Use_UVNC_Server_CmdLine[1] = ""
	EndIf
	If $INI_UseSC_Server = 1 Then
		V2M_EventLog("VNC - Using Ultr@VNC Server instead of SC", $V2M_EventDisplay, "7")
		If $INI_AutoReconnect = 1 Then
			V2M_EventLog("VNC - SERVER - Using -autoreconnect", $V2M_EventDisplay, "7")
			$Use_UVNC_Server_CmdLine[2] = " -autoreconnect"
		Else
			V2M_EventLog("VNC - SERVER - NOT using -autoreconnect", $V2M_EventDisplay, "7")
			$Use_UVNC_Server_CmdLine[2] = ""
		EndIf
		If $INI_ServiceMode <> 1 Then
			V2M_EventLog("VNC - SERVER - Using -run, 'Service Mode' not selected", $V2M_EventDisplay, "7")
			$Use_UVNC_Server_CmdLine[4] = " -run"
		EndIf
	Else
		If FileExists(@ScriptDir & "\MSRC4Plugin.dsm") Then
			V2M_EventLog("VNC - SC - Using -plugin", $V2M_EventDisplay, "7")
			$Use_UVNC_Server_CmdLine[1] = " -plugin" & $Use_UVNC_Server_CmdLine[1]
		EndIf
		$Use_UVNC_Server_CmdLine[2] = ""
		$Use_UVNC_Server_CmdLine[4] = " -noregistry"
	EndIf
	If $V2M_Status[5] <> "" Then
		V2M_EventLog("VNC - Using Repeater Connection", $V2M_EventDisplay, "7")
		$Use_UVNC_Server_CmdLine[3] = " -id:" & $V2M_Status[5]
		$Use_UVNC_Connect_Colon = ":"
	Else
		V2M_EventLog("VNC - NOT Using Repeater Connection", $V2M_EventDisplay, "7")
		$Use_UVNC_Server_CmdLine[3] = ""
		$Use_UVNC_Connect_Colon = "::"
	EndIf
	If $INI_ServiceMode <> 0 Then
		V2M_EventLog("VNC - Starting 'Service Mode'", $V2M_EventDisplay, "4")
		_VNCServiceMode("Start")
	Else
		V2M_EventLog("VNC - Starting 'User Mode'", $V2M_EventDisplay, "4")
		V2M_EventLog("Run('" & @ScriptDir & "\" & $V2M_VNC_UVNC & $Use_UVNC_Server_CmdLine[1] & $Use_UVNC_Server_CmdLine[2] & $Use_UVNC_Server_CmdLine[3] & " -connect " & $V2M_Status[3] & $Use_UVNC_Connect_Colon & $V2M_Status[4] & $Use_UVNC_Server_CmdLine[4] & " -multi" & "'," & @ScriptDir & "," & @SW_HIDE & ")", $V2M_EventDisplay, "7")
		Run(@ScriptDir & "\" & $V2M_VNC_UVNC & $Use_UVNC_Server_CmdLine[1] & $Use_UVNC_Server_CmdLine[2] & $Use_UVNC_Server_CmdLine[3] & " -connect " & $V2M_Status[3] & $Use_UVNC_Connect_Colon & $V2M_Status[4] & $Use_UVNC_Server_CmdLine[4] & " -multi", @ScriptDir, @SW_HIDE)
	EndIf
EndFunc   ;==>_VNCRun
#EndRegion SCPrompt Func
