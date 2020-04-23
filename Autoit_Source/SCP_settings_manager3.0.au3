#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=./Logo.ico
#AutoIt3Wrapper_outfile=../SCP_settings_manager.exe
#AutoIt3Wrapper_Res_Comment=Changes the settings for the scprompt application
#AutoIt3Wrapper_Res_Description=Changes the INI settings for the scprompt application
#AutoIt3Wrapper_Res_Fileversion=3.11.4.8
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=Various UltraVNC Forum members
#AutoIt3Wrapper_Res_SaveSource=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.0.0
	Author: MyName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <Date.au3>
#include <Misc.au3>
;#include <Color_picker_for_settings_manager.au3>
#include <GUIConstants.au3>
;#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
Opt("MustDeclareVars", 0)
Opt("GUICoordMode", 1)
Opt("GuiResizeMode", $GUI_DOCKALL)
; ========================================
; Predefine variables
; ========================================
Global Const $s_Title = ' SCPrompt2011 Settings Manager V3 '
Global $SCPrompt_ini = (@ScriptDir & "\scprompt\scprompt.ini")
Global $SCPrompt_exe = (@ScriptDir & "\scprompt\scprompt.exe")
;Global $Pre_Color = "0x"
Global $SCName_0, $SCIP_0, $SCPort_0, $SCID_0, $SCName_1, $SCIP_1, $SCPort_1, $SCID_1, $SCName_2, $SCIP_2, $SCPort_2, $SCID_2, $SCName_3, $SCIP_3, $SCPort_3, $SCID_3
Global $SCName_4, $SCIP_4, $SCPort_4, $SCID_4, $SCName_5, $SCIP_5, $SCPort_5, $SCID_5, $SCName_6, $SCIP_6, $SCPort_6, $SCID_6, $SCName_7, $SCIP_7, $SCPort_7, $SCID_7
Global $SCName_8, $SCIP_8, $SCPort_8, $SCID_8, $SCName_9, $SCIP_9, $SCPort_9, $SCID_9, $SCName_10, $SCIP_10, $SCPort_10, $SCID_10, $SCName_11, $SCIP_11, $SCPort_11, $SCID_11
Global $GUI_Tab[6], $INI_SCPrompt_SC, $INI_SCPrompt_Colour
Global $DebugLevel = 9, $YTS_EventDisplay, $YTS_EventLog, $DEBUGLOG, $TimeStampLoop
Global $gui_type
Global $INI_SCPrompt_Common, $INI_SCPrompt_GUI
Global $INI_SCPrompt_Common_read = IniReadSection($SCPrompt_ini, "COMMON")
Global $radioval1
Global $colourTEXT1 = IniRead($SCPrompt_ini, "Colour", "COLORTEXT1", ""), $colourTEXT2 = IniRead($SCPrompt_ini, "Colour", "COLORTEXT2", ""), $colourTEXT3 = IniRead($SCPrompt_ini, "Colour", "COLORTEXT3", ""), $colourTEXT4 = IniRead($SCPrompt_ini, "Colour", "COLORTEXT4", "")


; check if INI exists, ask for location if not
If Not FileExists($SCPrompt_ini) Then
	YTS_EventLog('GUI - SCPrompt.ini not found, asking user where it is ...', $YTS_EventDisplay, 7)
	$SCPrompt_ini = FileOpenDialog("Please Location scprompt.ini, so we can edit it", @ScriptDir, "INI (scprompt.ini)|ALL (*.*)", 1, "scprompt.ini")
	If @error = 1 Then Exit
EndIf

If @Compiled Then
	TraySetToolTip("Settings Manager " & IniRead($SCPrompt_ini, "Common", "APPName", "SCPrompt 2011") & " - " & FileGetVersion(@ScriptFullPath))
Else
	Opt("TrayIconDebug", 1) ;If enabled shows the current script line in the tray icon tip to help debugging.               0 = no debug information (default)      1 = show debug
EndIf
Opt("TrayIconHide", 0) ;Hides the AutoIt tray icon. Note: The icon will still initially appear ~750 milliseconds.               0 = show icon (default) 1 = hide icon


; ========================================
; GUI - Main Application
; ========================================

$YTS_EventDisplay = YTS_EventLog('Creating GUI')
GUICreate($s_Title, 360, 650)

$btn_Apply = GUICtrlCreateButton('A&pply new settings', 20, 615, 150, 25)
$btn_Test = GUICtrlCreateButton('T&est new settings', 190, 615, 150, 25)
$bt_Mn_Close = GUICtrlCreateButton('&Close', 20, 585, 320, 25)


$GUI_Tab[1] = GUICtrlCreateTab(10, 0, 340, 580)

; ========================================
; ++++++++++++++++++++++++++++++++++++++++
; ========================================
$YTS_EventDisplay = YTS_EventLog('Creating GUI Design TAB')
$GUI_Tab[3] = GUICtrlCreateTabItem("  GUI Design  ")
; ========================================
; GUI - Button Type Group
; ========================================
YTS_EventLog('Creating GUI Type')
$GTTop = 25
$group_1 = GUICtrlCreateGroup("GUI Type", 15, $GTTop, 330, 145) ;15, 288, 330, 80
GUICtrlSetFont(-1, 9, 800) ; make group title bold
$radio_1 = GUICtrlCreateRadio("Button ", 30, $GTTop + 20, 80, 20)
$radio_2 = GUICtrlCreateRadio("Combo ", 30, $GTTop + 40, 80, 20)
$radio_3 = GUICtrlCreateRadio("Radio ", 30, $GTTop + 60, 80, 20)
$radio_4 = GUICtrlCreateRadio("Manual ", 30, $GTTop + 80, 80, 20)
$radio_5 = GUICtrlCreateRadio("Automatic ", 30, $GTTop + 100, 80, 20)
$radio_6 = GUICtrlCreateRadio("Repeater ", 30, $GTTop + 120, 80, 20)
GUICtrlSetState(-1, $GUI_DISABLE)

$INI_Set_logo = IniRead($SCPrompt_ini, "GUI", "Set_logo", "0")
;GUICtrlCreateLabel("Set logo: ", 220, 40, 60, 20)
$GUI_Set_logo = GUICtrlCreateCheckbox("Enable logo", 150, 40, 120, 15)
If $INI_Set_logo = "1" Then
	GUICtrlSetState(-1, $GUI_CHECKED)
EndIf

$INI_Set_photo = IniRead($SCPrompt_ini, "GUI", "Set_photo", "0")
;GUICtrlCreateLabel("Set photo: ", 220, 60, 80, 20)
$GUI_Set_photo = GUICtrlCreateCheckbox("Enable Photo", 150, 60, 120, 15)
If $INI_Set_photo = "1" Then
	GUICtrlSetState(-1, $GUI_CHECKED)
EndIf

$INI_Set_webpage = IniRead($SCPrompt_ini, "GUI", "Set_webpage", "0")
;GUICtrlCreateLabel("Set webpage: ", 220, 80, 80, 20)
$GUI_Set_webpage = GUICtrlCreateCheckbox("Enable Webpage", 150, 80, 120, 15)
If $INI_Set_webpage = "1" Then
	GUICtrlSetState(-1, $GUI_CHECKED)
EndIf

$INI_disable_manual = IniRead($SCPrompt_ini, "GUI", "DisableManualConnections", "0")
;GUICtrlCreateLabel("Show MANUAL Button: ", 25, $DefaultsTop+82, 145, 18)
$GUI_disable_manual = GUICtrlCreateCheckbox("Enable MANUAL Button", 150, 100, 150, 15)
If $INI_disable_manual = "0" Then
	GUICtrlSetState(-1, $GUI_CHECKED)
EndIf


; ========================================
; GUI - Colours Group
; ========================================
$ColoursTop = 170
YTS_EventLog('Creating Colour Selections')
$gr_SC_Ini = GUICtrlCreateGroup('Colors', 15, $ColoursTop, 330, 250) ; 15, 370, 330, 170
GUICtrlSetFont(-1, 9, 800) ; make group title bold

$ColoursTop = $ColoursTop +20
$INI_BG_Color1 = IniRead($SCPrompt_ini, "Colour", "BGCOLOR", "")
$GUI_Label_Color1 = GUICtrlCreateLabel("Background Color GUI : ", 25, $ColoursTop, 200, 25)
$colour_Picker_BG_Color1 = GUICtrlCreateButton("BGCOLOR", 235, $ColoursTop-5, 100, 23)
GUICtrlSetBkColor($colour_Picker_BG_Color1, $INI_BG_Color1)

$ColoursTop = $ColoursTop +25
$INI_BG_Color3 = IniRead($SCPrompt_ini, "Colour", "BGCOLOR3", "")
$GUI_Label_Color3 = GUICtrlCreateLabel("Background Color of line 1 at top of GUI: ", 25, $ColoursTop, 200, 25)
;$colour_Picker_BG_Color3 = _GUIColorPicker_Create('', 240, 410, 50, 23, IniRead($SCPrompt_ini, "Colour", "BGCOLOR3", ""), BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $colouraPalette, 8, 4, '', 'More...');GUICtrlCreateInput($INI_BG_Color3, 240, 414, 90, 20)
$colour_Picker_BG_Color3 = GUICtrlCreateButton("BGCOLOR3", 235, $ColoursTop-5, 100, 23)
GUICtrlSetBkColor($colour_Picker_BG_Color3, $INI_BG_Color3)

$ColoursTop = $ColoursTop +25
$INI_BG_Color2 = IniRead($SCPrompt_ini, "Colour", "BGCOLOR2", "")
$GUI_Label_Color2 = GUICtrlCreateLabel("Background Color of line 2 at top of GUI: ", 25, $ColoursTop, 200, 25)
;$colour_Picker_BG_Color2 = _GUIColorPicker_Create('', 240, 435, 50, 23, IniRead($SCPrompt_ini, "Colour", "BGCOLOR2", ""), BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $colouraPalette, 8, 4, '', 'More...');GUICtrlCreateInput($INI_BG_Color2, 240, 389, 90, 20)
$colour_Picker_BG_Color2 = GUICtrlCreateButton("BGCOLOR2", 235, $ColoursTop-5, 100, 23)
GUICtrlSetBkColor($colour_Picker_BG_Color2, $INI_BG_Color2)

$ColoursTop = $ColoursTop +25
$INI_TextBGColor1 = IniRead($SCPrompt_ini, "Colour", "Text1BGColor", "")
$GUI_Label_Color4 = GUICtrlCreateLabel("Color of line 1 at top of Button GUI : ", 25, $ColoursTop, 200, 25)
;$colour_Picker_Text_BG_Color1 = _GUIColorPicker_Create('', 240, 460, 50, 23, IniRead($SCPrompt_ini, "Colour", "Text1BGColor", ""), BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $colouraPalette, 8, 4, '', 'More...');GUICtrlCreateInput($INI_TextBGColor1, 240, 439, 90, 20)
$colour_Picker_Text_BG_Color1 = GUICtrlCreateButton("Text1BGColor", 235, $ColoursTop-5, 100, 23)
GUICtrlSetBkColor($colour_Picker_Text_BG_Color1, $INI_TextBGColor1)

$ColoursTop = $ColoursTop +25
$INI_TextBGColor2 = IniRead($SCPrompt_ini, "Colour", "Text2BGColor", "")
$GUI_Label_Color5 = GUICtrlCreateLabel("Color of line 2 at top of Button GUI : ", 25, $ColoursTop, 200, 25)
;$colour_Picker_Text_BG_Color2 = _GUIColorPicker_Create('', 240, 485, 50, 23, IniRead($SCPrompt_ini, "Colour", "Text2BGColor", ""), BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $colouraPalette, 8, 4, '', 'More...');GUICtrlCreateInput($INI_TextBGColor2, 240, 464, 90, 20)
$colour_Picker_Text_BG_Color2 = GUICtrlCreateButton("Text2BGColor", 235, $ColoursTop-5, 100, 23)
GUICtrlSetBkColor($colour_Picker_Text_BG_Color2, $INI_TextBGColor2)

$ColoursTop = $ColoursTop +25
$GUI_Label_Color6 = GUICtrlCreateLabel("Color of lines at bottom of Button GUI : ", 25, $ColoursTop, 200, 20)
;$colour_Picker_Text_Color3 = _GUIColorPicker_Create('', 240, 510, 50, 23, IniRead($SCPrompt_ini, "Colour", "COLORTEXT3", ""), BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $colouraPalette, 8, 4, '', 'More...');GUICtrlCreateInput($INI_TextBGColor2, 240, 464, 90, 20)
$colour_Picker_Text_Color3 = GUICtrlCreateButton("ColorText3", 235, $ColoursTop-5, 100, 23)
GUICtrlSetBkColor($colour_Picker_Text_Color3, $colourTEXT3)

$ColoursTop = $ColoursTop +25
$GUI_Label_Color7 = GUICtrlCreateLabel("Address, Port & ServiceMode Labels : ", 25, $ColoursTop, 200, 20)
$colour_Picker_Text_Color1 = GUICtrlCreateButton("ColorText1", 235, $ColoursTop-5, 100, 23)
GUICtrlSetBkColor($colour_Picker_Text_Color1, $colourTEXT1)

$ColoursTop = $ColoursTop +25
$GUI_Label_Color8 = GUICtrlCreateLabel("Color of Radio Button GUI Labels: ", 25, $ColoursTop, 200, 20)
;$colour_Picker_Text_Color3 = _GUIColorPicker_Create('', 240, 510, 50, 23, IniRead($SCPrompt_ini, "Colour", "COLORTEXT3", ""), BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $colouraPalette, 8, 4, '', 'More...');GUICtrlCreateInput($INI_TextBGColor2, 240, 464, 90, 20)
$colour_Picker_Text_Color2 = GUICtrlCreateButton("ColorText2", 235, $ColoursTop-5, 100, 23)
GUICtrlSetBkColor($colour_Picker_Text_Color2, $colourTEXT2)

$ColoursTop = $ColoursTop +25
$GUI_Label_Color9 = GUICtrlCreateLabel("Color of Text4 on the Button GUI : ", 25, $ColoursTop, 200, 20)
;$colour_Picker_Text_Color3 = _GUIColorPicker_Create('', 240, 510, 50, 23, IniRead($SCPrompt_ini, "Colour", "COLORTEXT3", ""), BitOR($CP_FLAG_CHOOSERBUTTON, $CP_FLAG_ARROWSTYLE, $CP_FLAG_MOUSEWHEEL), $colouraPalette, 8, 4, '', 'More...');GUICtrlCreateInput($INI_TextBGColor2, 240, 464, 90, 20)
$colour_Picker_Text_Color4 = GUICtrlCreateButton("ColorText4", 235, $ColoursTop-5, 100, 23)
GUICtrlSetBkColor($colour_Picker_Text_Color4, $colourTEXT4)


; ========================================
; ++++++++++++++++++++++++++++++++++++++++
; ========================================
$YTS_EventDisplay = YTS_EventLog('Creating Common Settings TAB')
$GUI_Tab[5] = GUICtrlCreateTabItem("  Labels  ")
; ========================================
; GUI - Labels Group
; ========================================
$LabelsTop = 25
$gr_SC_Ini = GUICtrlCreateGroup('Labels', 15, $LabelsTop, 330, 165)
GUICtrlSetFont(-1, 9, 800) ; make group title bold

$LabelsTop = $LabelsTop +20
$INI_APPName = IniRead($SCPrompt_ini, "Common", "APPName", "")
GUICtrlCreateLabel("Application Name: ", 25, $LabelsTop, 120, 20)
$APPName = GUICtrlCreateInput($INI_APPName, 150, $LabelsTop-2, 180, 18)

$LabelsTop = $LabelsTop +20
$Text_line1 = IniRead($SCPrompt_ini, "GUI", "TEXT1", "")
$Text_line1_Label = GUICtrlCreateLabel("Text 1: ", 25, $LabelsTop, 50, 20)
$Text_line1 = GUICtrlCreateInput($Text_line1, 100, $LabelsTop-2, 230, 18)

$LabelsTop = $LabelsTop +20
$Text_line2 = IniRead($SCPrompt_ini, "GUI", "TEXT2", "")
$Text_line2_Label = GUICtrlCreateLabel("Text 2: ", 25, $LabelsTop, 50, 20)
$Text_line2 = GUICtrlCreateInput($Text_line2, 100, $LabelsTop-2, 230, 18)

$LabelsTop = $LabelsTop +20
$Text_line3 = IniRead($SCPrompt_ini, "GUI", "TEXT3", "")
$Text_line3_Label = GUICtrlCreateLabel("Text 3: ", 25, $LabelsTop, 50, 20)
$Text_line3 = GUICtrlCreateInput($Text_line3, 100, $LabelsTop-2, 230, 18)

$LabelsTop = $LabelsTop +20
$Text_line4 = IniRead($SCPrompt_ini, "GUI", "TEXT4", "")
$Text_line4_Label = GUICtrlCreateLabel("Text 4: ", 25, $LabelsTop, 50, 20)
$Text_line4 = GUICtrlCreateInput($Text_line4, 100, $LabelsTop-2, 230, 18)

$LabelsTop = $LabelsTop +20
;$GUI_WebPage = IniRead($SCPrompt_ini, "GUI", "WebPage", "")
$GUI_WebPageLabel = GUICtrlCreateLabel("Address of WebPage: ", 25, $LabelsTop, 120, 20)
$GUI_WebPage = GUICtrlCreateInput(IniRead($SCPrompt_ini, "GUI", "WebPage", ""), 150, $LabelsTop-2, 180, 18)

$LabelsTop = $LabelsTop +20
$INI_Nr_Tel = IniRead($SCPrompt_ini, "Common", "Tel", "")
$Nr_Tel_Label = GUICtrlCreateLabel("Tel: ", 25, $LabelsTop, 100, 18)
$Nr_Tel = GUICtrlCreateInput($INI_Nr_Tel, 150, $LabelsTop-2, 180, 18)



; ========================================
; GUI - Manual Button Defaults Group
; ========================================
$DefaultsTop = 190
$group_1 = GUICtrlCreateGroup("Manual Input Defaults", 15, $DefaultsTop, 330, 100) ;15, 288, 330, 80
GUICtrlSetFont(-1, 9, 800) ; make group title bold

$INI_ManualAddress = IniRead($SCPrompt_ini, "SC", "ManualAddress", "")
$GUI_ManualAddressLabel = GUICtrlCreateLabel("Manual Address: ", 25, $DefaultsTop + 22, 125, 20)
$GUI_ManualAddress = GUICtrlCreateInput($INI_ManualAddress, 150, $DefaultsTop + 20, 180, 18)

$INI_ManualPort = IniRead($SCPrompt_ini, "SC", "ManualPort", "")
$GUI_ManualPortLabel = GUICtrlCreateLabel("Manual Port: ", 25, $DefaultsTop + 42, 125, 20)
$GUI_ManualPort = GUICtrlCreateInput($INI_ManualPort, 150, $DefaultsTop + 40, 180, 18)

$INI_ManualID = IniRead($SCPrompt_ini, "SC", "ManualID", "")
$GUI_ManualIDLabel = GUICtrlCreateLabel("Manual ID: ", 25, $DefaultsTop + 62, 125, 20)
$GUI_ManualID = GUICtrlCreateInput($INI_ManualID, 150, $DefaultsTop + 60, 90, 18)






; ========================================
; ++++++++++++++++++++++++++++++++++++++++
; ========================================
$YTS_EventDisplay = YTS_EventLog('Creating Predefined Connections TAB')
$GUI_Tab[4] = GUICtrlCreateTabItem("  Connections  ")
; ========================================
; GUI - Predefined connections Group
; ========================================
YTS_EventLog('Creating Predefined Connections')
$gr_Common_Ini = GUICtrlCreateGroup('User Predifined Connections', 15, 25, 330, 550)
GUICtrlSetFont(-1, 9, 800) ; make group title bold

Global $curtop = 65, $curleft = 20, $loopcount = 0

Do
	GUICtrlCreateLabel("Name " & $loopcount & ": ", $curleft, $curtop, 70, 25)
	Assign("SCName_" & $loopcount & "", GUICtrlCreateInput(IniRead($SCPrompt_ini, "SC", "SCName_" & $loopcount, ""), $curleft + 60, $curtop - 3, 110, 20))

	GUICtrlCreateLabel("ID" & $loopcount & ": ", $curleft + 195, $curtop, 40, 20)
	Assign("SCID_" & $loopcount & "", GUICtrlCreateInput(IniRead($SCPrompt_ini, "SC", "SCID_" & $loopcount, ""), $curleft + 235, $curtop - 3, 40, 20))

	GUICtrlCreateLabel("IP" & $loopcount & ": ", $curleft, $curtop + 25, 40, 20)
	Assign("SCIP_" & $loopcount & "", GUICtrlCreateInput(IniRead($SCPrompt_ini, "SC", "SCIP_" & $loopcount, ""), $curleft + 60, $curtop + 22, 110, 20))

	GUICtrlCreateLabel("Port" & $loopcount & ": ", $curleft + 195, $curtop + 25, 40, 20)
	Assign("SCPort_" & $loopcount & "", GUICtrlCreateInput(IniRead($SCPrompt_ini, "SC", "SCPort_" & $loopcount, ""), $curleft + 235, $curtop + 22, 40, 20))

	$loopcount = $loopcount + 1 ;increment the loop
	$curtop = $curtop + 50 ;move the next iteration down the page ...
Until $loopcount >= 10

;$INI_UsePredefined = IniRead($SCPrompt_ini, "SC", "UsePredefined", "")
;;GUICtrlCreateLabel("UsePredefined: ", $curleft + 30, $curtop - 20, 75, 20)
;;$GUI_UsePredefined = GUICtrlCreateCheckbox("Use Predefined Connections", $curleft + 10, 43, 300, 15)
;If $INI_UsePredefined <> "" And $INI_UsePredefined <> "0" Then
;	GUICtrlSetState(-1, $GUI_CHECKED)
;	SCP_Predef_EnableDisable("Enable")
;Else
;	SCP_Predef_EnableDisable("Disable")
;EndIf

$INI_GUI_Type = IniRead($SCPrompt_ini, "GUI", "GUI_Type", "")
YTS_EventLog('$INI_GUI_Type = ' & $INI_GUI_Type)
;If IniRead($SCPrompt_ini, "SC", "UsePredefined", "") <> "1" Then
;	$INI_GUI_Type = "Manual"
;EndIf
GUIEnableDisable($INI_GUI_Type)
;$radioval2 = 2

; ========================================
; ++++++++++++++++++++++++++++++++++++++++
; ========================================
$YTS_EventDisplay = YTS_EventLog('Creating Advanced Settings TAB')
$GUI_Tab[2] = GUICtrlCreateTabItem("  Advanced  ")
; ========================================
; GUI - Advanced Group
; ========================================
$AdvancedTop = 25
$gr_Common_Ini = GUICtrlCreateGroup('Advanced', 15, $AdvancedTop, 330, 165)
GUICtrlSetFont(-1, 9, 800) ; make group title bold

$AdvancedTop = $AdvancedTop +20
$LANGUAGE = IniRead($SCPrompt_ini, "Common", "LANGUAGE", "")
GUICtrlCreateLabel("Application Language:  ", 25, $AdvancedTop, 120, 20)
$GUI_LANGUAGE = GUICtrlCreateInput($LANGUAGE, 150, $AdvancedTop-2, 110, 18, $GUI_DISABLE)
If $LANGUAGE = "" Then GUICtrlSetState($GUI_LANGUAGE, $GUI_DISABLE)
$Auto_Lang = GUICtrlCreateCheckbox("Automatic: ", 265, $AdvancedTop, 70, 15)
If $LANGUAGE = "" Then GUICtrlSetState(-1, $GUI_CHECKED)

$AdvancedTop = $AdvancedTop +20
$INI_Enable_Sonar = IniRead($SCPrompt_ini, "Common", "MAIN_ENABLE_SONAR", "0")
;GUICtrlCreateLabel("Enable Mouse Sonar: ", 60, $AdvancedTop+60, 120, 20)
$GUI_Enable_Sonar = GUICtrlCreateCheckbox("Enable Mouse Sonar: ", 40, $AdvancedTop-2, 300, 15)
If $INI_Enable_Sonar = "1" Then
	GUICtrlSetState(-1, $GUI_CHECKED)
EndIf

$AdvancedTop = $AdvancedTop +20
$INI_Disable_UAC = IniRead($SCPrompt_ini, "Common", "MAIN_DISABLE_UAC", "0")
;GUICtrlCreateLabel("Disable UAC in Vista & 7: ", 60, $AdvancedTop+80, 200, 20)
$GUI_Disable_UAC = GUICtrlCreateCheckbox("Disable UAC in Vista & 7: ", 40, $AdvancedTop-2, 300, 15)
If $INI_Disable_UAC = "1" Then
	GUICtrlSetState(-1, $GUI_CHECKED)
EndIf

$AdvancedTop = $AdvancedTop +20
$INI_InetUpdate = IniRead($SCPrompt_ini, "Common", "INETUPDATE", "0")
;GUICtrlCreateLabel("Enable Checking for Updates: ", 60, $AdvancedTop+100, 200, 20)
$GUI_InetUpdate = GUICtrlCreateCheckbox("Enable Checking for Updates: ", 40, $AdvancedTop-2, 300, 15)

$AdvancedTop = $AdvancedTop +20
$INI_UpdateURL = IniRead($SCPrompt_ini, "Common", "UpdateURL", "")
GUICtrlCreateLabel("Update INI URL: ", 25, $AdvancedTop, 120, 20)
$GUI_UpdateURL = GUICtrlCreateInput($INI_UpdateURL, 150, $AdvancedTop-2, 180, 18)

If $INI_InetUpdate = "1" Then
	GUICtrlSetState($GUI_InetUpdate, $GUI_CHECKED)
Else
	GUICtrlSetState($GUI_UpdateURL, $GUI_DISABLE)
EndIf


; Set accelerators for Ctrl+y and Ctrl+n
Dim $AccelKeys[2][2]=[["^s", $btn_Apply], ["^t", $btn_Test]]
GUISetAccelerators($AccelKeys)

GUISetState()
YTS_EventLog('GUI Creation Complete')
; ========================================
While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			YTS_EventLog('GUI - Main Window Closed, Exiting')
			Exit
		Case $GUI_EVENT_MINIMIZE
			YTS_EventLog('GUI - Main Window Minimised')
		Case $GUI_EVENT_MAXIMIZE
			YTS_EventLog('GUI - Main Window Maximised')
		Case $bt_Mn_Close
			YTS_EventLog('GUI - Main Window Exit Button Pressed, Exiting')
			Exit
		Case $btn_Apply
			$gui_type = ("Radio " & $radioval1)
			TrayTip("SCPrompt Settings Manager", "Settings Applied", 30)
			Apply()
		Case $btn_Test
			TrayTip("SCPrompt Settings Manager", "Testing new settings", 30)
			If FileExists($SCPrompt_exe) Then
				RunWait($SCPrompt_exe & " -testing")
			Else
				YTS_EventLog('GUI - SCPrompt.exe not found, asking user where it is ...', $YTS_EventDisplay, 7)
				$SCPrompt_exe = FileOpenDialog("Please Location scprompt.exe, so we can test it", StringReplace($SCPrompt_ini, "\scprompt.ini", ""), "EXE (*.exe)|ALL (*.*)", 1, "scprompt.exe")
				If @error = 1 Then
					Sleep(100)
				Else
					RunWait($SCPrompt_exe)
				EndIf
			EndIf
			TrayTip("SCPrompt Settings Manager", "", 10)
		Case $msg >= $radio_1 And $msg <= $radio_6
			If $msg = $radio_1 Then
				GUIEnableDisable("Button")
				$radioval1 = $msg - $radio_1
			ElseIf $msg = $radio_2 Then
				GUIEnableDisable("Combo")
				$radioval1 = $msg - $radio_1
			ElseIf $msg = $radio_3 Then
				GUIEnableDisable("Radio")
				$radioval1 = $msg - $radio_1
			ElseIf $msg = $radio_4 Then
				GUIEnableDisable("Manual")
				$radioval1 = $msg - $radio_1
			ElseIf $msg = $radio_5 Then
				GUIEnableDisable("Auto")
				$radioval1 = $msg - $radio_1
			ElseIf $msg = $radio_6 Then
				GUIEnableDisable("Repeater")
				$radioval1 = $msg - $radio_1
			EndIf
		Case $Auto_Lang
			If GUICtrlRead($Auto_Lang) = 1 Then
				; disable the Language input box
				GUICtrlSetState($GUI_LANGUAGE, $GUI_DISABLE)
			Else
				; enable the Language input box
				GUICtrlSetState($GUI_LANGUAGE, $GUI_ENABLE)
			EndIf
		Case $GUI_InetUpdate
			YTS_EventLog('$GUI_InetUpdate Pressed')
			If GUICtrlRead($GUI_InetUpdate) = 1 Then
				; enable the Language input box
				GUICtrlSetState($GUI_UpdateURL, $GUI_ENABLE)
			Else
				; disable the Language input box
				GUICtrlSetState($GUI_UpdateURL, $GUI_DISABLE)
			EndIf
		Case $GUI_disable_manual
			YTS_EventLog('$GUI_disable_manual Pressed')
			If GUICtrlRead($GUI_disable_manual) = 1 Then
				; enable
				GUICtrlSetState($GUI_ManualAddressLabel, $GUI_ENABLE)
				GUICtrlSetState($GUI_ManualAddress, $GUI_ENABLE)
				GUICtrlSetState($GUI_ManualPortLabel, $GUI_ENABLE)
				GUICtrlSetState($GUI_ManualPort, $GUI_ENABLE)
				GUICtrlSetState($GUI_ManualIDLabel, $GUI_ENABLE)
				GUICtrlSetState($GUI_ManualID, $GUI_ENABLE)
			Else
				; disable
				GUICtrlSetState($GUI_ManualAddressLabel, $GUI_DISABLE)
				GUICtrlSetState($GUI_ManualAddress, $GUI_DISABLE)
				GUICtrlSetState($GUI_ManualPortLabel, $GUI_DISABLE)
				GUICtrlSetState($GUI_ManualPort, $GUI_DISABLE)
				GUICtrlSetState($GUI_ManualIDLabel, $GUI_DISABLE)
				GUICtrlSetState($GUI_ManualID, $GUI_DISABLE)
			EndIf
			GUICtrlSetState($GUI_disable_manual, $GUI_ENABLE)

		Case $colour_Picker_BG_Color1
			YTS_EventLog('$colour_Picker_BG_Color1 button Pressed')
			$colour = ""
			$colour = _ChooseColor(2, $INI_BG_Color1, 2)
			YTS_EventLog('$colour = ' & $colour)
			GUICtrlSetBkColor($colour_Picker_BG_Color1, $colour)
			$INI_BG_Color1 = $colour
		Case $colour_Picker_BG_Color2
			YTS_EventLog('$colour_Picker_BG_Color2 button Pressed')
			$colour = ""
			$colour = _ChooseColor(2, $INI_BG_Color2, 2)
			YTS_EventLog('$colour = ' & $colour)
			GUICtrlSetBkColor($colour_Picker_BG_Color2, $colour)
			$INI_BG_Color2 = $colour
		Case $colour_Picker_BG_Color3
			YTS_EventLog('$colour_Picker_BG_Color3 button Pressed')
			$colour = ""
			$colour = _ChooseColor(2, $INI_BG_Color3, 2)
			YTS_EventLog('$colour = ' & $colour)
			GUICtrlSetBkColor($colour_Picker_BG_Color3, $colour)
			$INI_BG_Color3 = $colour
		Case $colour_Picker_Text_BG_Color1
			YTS_EventLog('$colour_Picker_Text_BG_Color1 button Pressed')
			$colour = ""
			$colour = _ChooseColor(2, $INI_TextBGColor1, 2)
			YTS_EventLog('$colour = ' & $colour)
			GUICtrlSetBkColor($colour_Picker_Text_BG_Color1, $colour)
			$INI_TextBGColor1 = $colour
		Case $colour_Picker_Text_BG_Color2
			YTS_EventLog('$colour_Picker_Text_BG_Color2 button Pressed')
			$colour = ""
			$colour = _ChooseColor(2, $INI_TextBGColor2, 2)
			YTS_EventLog('$colour = ' & $colour)
			GUICtrlSetBkColor($colour_Picker_Text_BG_Color2, $colour)
			$INI_TextBGColor2 = $colour
		Case $colour_Picker_Text_Color3
			YTS_EventLog('$colour_Picker_Text_Color3 button Pressed')
			$colour = ""
			$colour = _ChooseColor(2, $colourTEXT3, 2)
			YTS_EventLog('$colour = ' & $colour)
			GUICtrlSetBkColor($colour_Picker_Text_Color3, $colour)
			$colourTEXT3 = $colour
		Case $colour_Picker_Text_Color1
			YTS_EventLog('$colour_Picker_Text_Color1 button Pressed')
			$colour = ""
			$colour = _ChooseColor(2, $colourTEXT1, 2)
			YTS_EventLog('$colour = ' & $colour)
			GUICtrlSetBkColor($colour_Picker_Text_Color1, $colour)
			$colourTEXT1 = $colour
		Case $colour_Picker_Text_Color2
			YTS_EventLog('$colour_Picker_Text_Color2 button Pressed')
			$colour = ""
			$colour = _ChooseColor(2, $colourTEXT2, 2)
			YTS_EventLog('$colour = ' & $colour)
			GUICtrlSetBkColor($colour_Picker_Text_Color2, $colour)
			$colourTEXT2 = $colour
		Case $colour_Picker_Text_Color4
			YTS_EventLog('$colour_Picker_Text_Color4 button Pressed')
			$colour = ""
			$colour = _ChooseColor(2, $colourTEXT4, 2)
			YTS_EventLog('$colour = ' & $colour)
			GUICtrlSetBkColor($colour_Picker_Text_Color4, $colour)
			$colourTEXT4 = $colour
;		Case $GUI_UsePredefined
;			YTS_EventLog('$GUI_UsePredefined Selected, GUICtrlGetState($GUI_UsePredefined) = ' & GUICtrlRead($GUI_UsePredefined))
;			If GUICtrlRead($GUI_UsePredefined) = $GUI_CHECKED Then
;				YTS_EventLog('GUICtrlGetState($GUI_UsePredefined) = $GUI_CHECKED')
;				SCP_Predef_EnableDisable("Enable")
;			Else
;				YTS_EventLog('GUICtrlGetState($GUI_UsePredefined) = $GUI_UNCHECKED')
;				SCP_Predef_EnableDisable("Disable")
;			EndIf
		Case $GUI_Set_webpage
			YTS_EventLog('$GUI_Set_webpage Selected, GUICtrlGetState($GUI_Set_webpage) = ' & GUICtrlRead($GUI_Set_webpage))
			If GUICtrlRead($GUI_Set_webpage) = $GUI_CHECKED Then
				YTS_EventLog('GUICtrlGetState($GUI_Set_webpage) = $GUI_CHECKED')
				GUICtrlSetState($GUI_WebPage, $GUI_ENABLE)
				GUICtrlSetState($GUI_WebPageLabel, $GUI_ENABLE)
				;				SCP_Predef_EnableDisable("Enable")
			Else
				YTS_EventLog('GUICtrlGetState($GUI_Set_webpage) = $GUI_UNCHECKED')
				GUICtrlSetState($GUI_WebPage, $GUI_DISABLE)
				GUICtrlSetState($GUI_WebPageLabel, $GUI_DISABLE)
				;				SCP_Predef_EnableDisable("Disable")
			EndIf
	EndSwitch
	$TimeStampLoop = _NowCalc()
	If _DateDiff('s', $TimeStampLoop, _NowCalc()) >= 1 Then
		;       Loop through the following every 1 second (allows for things that DONT need imediate actions to not chew the CPU.
		$TimeStampLoop = _NowCalc()
	EndIf
WEnd


Func SCP_Predef_EnableDisable($Local_State = "Enable")
	YTS_EventLog('Func SCP_Predef_EnableDisable($Local_State = "' & $Local_State & '")')
	$loopcount = 0
	If $Local_State = "Disable" Then
		$GUI_State = $GUI_DISABLE
	Else
		$GUI_State = $GUI_ENABLE
	EndIf
	Do
		GUICtrlSetState(Eval("SCName_" & $loopcount), $GUI_State)
		GUICtrlSetState(Eval("SCID_" & $loopcount), $GUI_State)
		GUICtrlSetState(Eval("SCIP_" & $loopcount), $GUI_State)
		GUICtrlSetState(Eval("SCPort_" & $loopcount), $GUI_State)
		$loopcount = $loopcount + 1 ;increment the loop
	Until $loopcount = 10
EndFunc   ;==>SCP_Predef_EnableDisable
Func _GuiType()
	YTS_EventLog('Func _GuiType()')
	If $gui_type = "Radio 0" Then
		$write_gui_type = "Button"
		;		$INI_SCPrompt_SC &= "UsePredefined=1"
	ElseIf $gui_type = "Radio 1" Then
		$write_gui_type = "Combo"
		;		$INI_SCPrompt_SC &= "UsePredefined=1"
	ElseIf $gui_type = "Radio 2" Then
		$write_gui_type = "Radio"
		;		$INI_SCPrompt_SC &= "UsePredefined=1"
	ElseIf $gui_type = "Radio 3" Then
		$write_gui_type = "Manual"
		;		$INI_SCPrompt_SC &= "UsePredefined=0"
	ElseIf $gui_type = "Radio 4" Then
		$write_gui_type = "Auto"
		;		$INI_SCPrompt_SC &= "UsePredefined=1"
	Else
		$write_gui_type = "Radio"
		;		$INI_SCPrompt_SC &= "UsePredefined=1"
	EndIf
	YTS_EventLog('Func _GuiType() return = :' & $write_gui_type)
	Return ($write_gui_type)
	;	IniWrite($SCPrompt_ini, "GUI", "GUI_Type", $write_gui_type)
	;	Apply()
EndFunc   ;==>_GuiType

Func Apply()
	YTS_EventLog('Func Apply()')

	;===================
	;===   1st Tab   ===
	;===================
	If GUICtrlRead($Auto_Lang) = 1 Then
		;setup automatic language selection
		$INI_SCPrompt_Common &= "LANGUAGE=" & '""' & @LF
	Else
		;setup manual language selection
		$INI_SCPrompt_Common &= "LANGUAGE=" & GUICtrlRead($LANGUAGE) & @LF
	EndIf
	$INI_SCPrompt_Common &= "APPName=" & GUICtrlRead($APPName) & @LF

	;	$INI_SCPrompt_Common &= "MAIN_ENABLE_SONAR=1" & @LF
	If GUICtrlRead($GUI_Enable_Sonar) = 4 Then ;not checked
		$INI_SCPrompt_Common &= "MAIN_ENABLE_SONAR=0" & @LF
	ElseIf GUICtrlRead($GUI_Enable_Sonar) = 1 Then ;checked
		$INI_SCPrompt_Common &= "MAIN_ENABLE_SONAR=1" & @LF
	EndIf

	;	$INI_SCPrompt_Common &= "MAIN_DISABLE_UAC=0" & @LF
	If GUICtrlRead($GUI_Disable_UAC) = 4 Then ;not checked
		$INI_SCPrompt_Common &= "MAIN_DISABLE_UAC=0" & @LF
	ElseIf GUICtrlRead($GUI_Disable_UAC) = 1 Then ;checked
		$INI_SCPrompt_Common &= "MAIN_DISABLE_UAC=1" & @LF
	EndIf

	;	$INI_SCPrompt_Common &= "INETUPDATE=0" & @LF
	If GUICtrlRead($GUI_InetUpdate) = 4 Then ;not checked
		$INI_SCPrompt_Common &= "INETUPDATE=0" & @LF
	ElseIf GUICtrlRead($GUI_InetUpdate) = 1 Then ;checked
		$INI_SCPrompt_Common &= "INETUPDATE=1" & @LF
	EndIf
	$INI_SCPrompt_Common &= "TESTUPDATE=0" & @LF
	$INI_SCPrompt_Common &= "UpdateURL=" & GUICtrlRead($GUI_UpdateURL) & @LF
	$INI_SCPrompt_Common &= "UseSC_Prompt=1" & @LF
	$INI_SCPrompt_Common &= "UseSC_Server=1" & @LF
	$INI_SCPrompt_Common &= "ServiceMode=1" & @LF
	$INI_SCPrompt_Common &= "autoreconnect=1" & @LF
	$INI_SCPrompt_Common &= "GUIAUTOSILENT=0" & @LF

	$INI_SCPrompt_Common &= "Use_Existing_sc_prompt=0" & @LF
	$INI_SCPrompt_Common &= "AppReRunTimer=30" & @LF


	;===================
	;===   2nd Tab   ===
	;===================
	$INI_SCPrompt_GUI &= "WebPage=" & GUICtrlRead($GUI_WebPage) & @LF
	$INI_SCPrompt_GUI &= "Tel=" & GUICtrlRead($Nr_Tel) & @LF

	$INI_SCPrompt_GUI &= "TEXT1=" & GUICtrlRead($Text_line1) & @LF
	$INI_SCPrompt_GUI &= "TEXT2=" & GUICtrlRead($Text_line2) & @LF
	$INI_SCPrompt_GUI &= "TEXT3=" & GUICtrlRead($Text_line3) & @LF
	$INI_SCPrompt_GUI &= "TEXT4=" & GUICtrlRead($Text_line4) & @LF

	If GUICtrlRead($GUI_Set_logo) = 4 Then ;not checked
		$INI_SCPrompt_GUI &= "Set_logo=0" & @LF
	ElseIf GUICtrlRead($GUI_Set_logo) = 1 Then ;checked
		$INI_SCPrompt_GUI &= "Set_logo=1" & @LF
	EndIf

	If GUICtrlRead($GUI_Set_photo) = 4 Then ;not checked
		$INI_SCPrompt_GUI &= "Set_photo=0" & @LF
	ElseIf GUICtrlRead($GUI_Set_photo) = 1 Then ;checked
		$INI_SCPrompt_GUI &= "Set_photo=1" & @LF
	EndIf

	If GUICtrlRead($GUI_Set_webpage) = 4 Then ;not checked
		$INI_SCPrompt_GUI &= "Set_webpage=0" & @LF
	ElseIf GUICtrlRead($GUI_Set_webpage) = 1 Then ;checked
		$INI_SCPrompt_GUI &= "Set_webpage=1" & @LF
	EndIf

	$INI_SCPrompt_GUI &= "GUI_Type=" & _GuiType() & @LF
	If GUICtrlRead($GUI_disable_manual) = 4 Then ;not checked
		;		IniWrite($SCPrompt_ini, "GUI", "DisableManualConnections", "1")
		$INI_SCPrompt_GUI &= "DisableManualConnections=1" & @LF
	ElseIf GUICtrlRead($GUI_disable_manual) = 1 Then ;checked
		;		IniWrite($SCPrompt_ini, "GUI", "DisableManualConnections", "0")
		$INI_SCPrompt_GUI &= "DisableManualConnections=0" & @LF
	EndIf
	$INI_SCPrompt_GUI &= "TraySetStateShow=9" & @LF
	$INI_SCPrompt_GUI &= "TraySetStateFlash=4" & @LF
	$INI_SCPrompt_GUI &= "RemoteINI" & @LF

	;	$INI_SCPrompt_SC &= "UsePredefined=" & GUICtrlRead($GUI_UsePredefined) & @LF
;	If GUICtrlRead($GUI_UsePredefined) = $GUI_CHECKED Then ;checked
;		$INI_SCPrompt_SC &= "UsePredefined=1" & @LF
;	Else
;		$INI_SCPrompt_SC &= "UsePredefined=0" & @LF
;	EndIf
	$INI_SCPrompt_SC &= "ManualAddress=" & GUICtrlRead($GUI_ManualAddress) & @LF
	$INI_SCPrompt_SC &= "ManualPort=" & GUICtrlRead($GUI_ManualPort) & @LF
	$INI_SCPrompt_SC &= "ManualID=" & GUICtrlRead($GUI_ManualID) & @LF

	$INI_SCPrompt_GUI &= "Chunk_Button_Exit_Left=210" & @LF
	$INI_SCPrompt_GUI &= "Chunk_Button_Exit_Top=34" & @LF
	$INI_SCPrompt_GUI &= "Chunk_Label_Left=210" & @LF
	$INI_SCPrompt_GUI &= "Chunk_Label_Top=34" & @LF

	$INI_SCPrompt_Colour &= "BGCOLOR=" & $INI_BG_Color1 & @LF
	$INI_SCPrompt_Colour &= "BGCOLOR2="& $INI_BG_Color2 & @LF
	$INI_SCPrompt_Colour &= "BGCOLOR3="& $INI_BG_Color3 & @LF
	$INI_SCPrompt_Colour &= "Text1BGColor="& $INI_TextBGColor1 & @LF
	$INI_SCPrompt_Colour &= "Text2BGColor="& $INI_TextBGColor2 & @LF
	$INI_SCPrompt_Colour &= "COLORTEXT1="& $colourTEXT3 & @LF
	$INI_SCPrompt_Colour &= "COLORTEXT2="& $colourTEXT3 & @LF
	$INI_SCPrompt_Colour &= "COLORTEXT3="& $colourTEXT3 & @LF
	$INI_SCPrompt_Colour &= "COLORTEXT4="& $colourTEXT3 & @LF

;	IniWrite($SCPrompt_ini, "Colour", "BGCOLOR", $INI_BG_Color1)
;	IniWrite($SCPrompt_ini, "Colour", "BGCOLOR2", $INI_BG_Color2)
;	IniWrite($SCPrompt_ini, "Colour", "BGCOLOR3", $INI_BG_Color3)
;	IniWrite($SCPrompt_ini, "Colour", "Text1BGColor", $INI_TextBGColor1)
;	IniWrite($SCPrompt_ini, "Colour", "Text2BGColor", $INI_TextBGColor2)
;	IniWrite($SCPrompt_ini, "Colour", "COLORTEXT1", $colourTEXT3)
;	IniWrite($SCPrompt_ini, "Colour", "COLORTEXT2", $colourTEXT3)
;	IniWrite($SCPrompt_ini, "Colour", "COLORTEXT3", $colourTEXT3)
;	IniWrite($SCPrompt_ini, "Colour", "COLORTEXT4", $colourTEXT3)

	;===================
	;===   3rd Tab   ===
	;===================
	;	$INI_SCPrompt_SC = ""
	$loopcount = 0
	Do
		If GUICtrlRead(Eval("SCName_"&$loopcount&"")) <> "" Then
			$INI_SCPrompt_SC &= "SCName_" & $loopcount & "=" & GUICtrlRead(Eval("SCName_" & $loopcount & "")) & @LF
			;		IniWrite($SCPrompt_ini, "SC", "SCName_" & $loopcount, GUICtrlRead(Eval("SCName_" & $loopcount & "")))
			$INI_SCPrompt_SC &= "SCIP_" & $loopcount & "=" & GUICtrlRead(Eval("SCIP_" & $loopcount & "")) & @LF
			;		IniWrite($SCPrompt_ini, "SC", "SCIP_" & $loopcount, GUICtrlRead(Eval("SCIP_" & $loopcount & "")))
			$INI_SCPrompt_SC &= "SCPort_" & $loopcount & "=" & GUICtrlRead(Eval("SCPort_" & $loopcount & "")) & @LF
			;		IniWrite($SCPrompt_ini, "SC", "SCPort_" & $loopcount, GUICtrlRead(Eval("SCPort_" & $loopcount & "")))
			$INI_SCPrompt_SC &= "SCID_" & $loopcount & "=" & GUICtrlRead(Eval("SCID_" & $loopcount & "")) & @LF
			;		IniWrite($SCPrompt_ini, "SC", "SCID_" & $loopcount, GUICtrlRead(Eval("SCID_" & $loopcount & "")))
		Else
			$INI_SCPrompt_SC &= "SCName_" & $loopcount & '=""' & @LF
			$INI_SCPrompt_SC &= "SCIP_" & $loopcount & '=""' & @LF
			$INI_SCPrompt_SC &= "SCPort_" & $loopcount & '=""' & @LF
			$INI_SCPrompt_SC &= "SCID_" & $loopcount & '=""' & @LF
		EndIf
		$loopcount = $loopcount + 1 ;increment the loop
	Until $loopcount >= 10


	;=======================
	;===   Write INI's   ===
	;=======================
	IniWriteSection($SCPrompt_ini, "Common", $INI_SCPrompt_Common)
	$INI_SCPrompt_Common = ""

	IniWriteSection($SCPrompt_ini, "GUI", $INI_SCPrompt_GUI)
	$INI_SCPrompt_GUI = ""

	IniWriteSection($SCPrompt_ini, "Colour", $INI_SCPrompt_Colour)
	$INI_SCPrompt_Colour = ""

	IniWriteSection($SCPrompt_ini, "SC", $INI_SCPrompt_SC)
	$INI_SCPrompt_SC = ""
EndFunc   ;==>Apply

;===============================================================================
;
; Description:          Eventlog handler, sends logs to std windows debug (via dll) and LogFile if needed
; Parameter(s):         $YTS_EventLog   =       Text string to send to log
;						$Local_debug_level =	0, text is display in statusbar. else, only sent to debug dll
; Requirement(s):
; Return Value(s):      $YTS_EventDisplay
; Author(s):            YTS_Jim
; Note(s):
;
;===============================================================================
Func YTS_EventLog($YTS_EventLog = '', $YTS_EventDisplay = '', $Local_debug_level = "8")
	If $DebugLevel > $Local_debug_level Then
		If $YTS_EventLog <> $YTS_EventDisplay Then
			; view the following output from sysinternals debuger "DebugView" or similar
			DllCall("kernel32.dll", "none", "OutputDebugString", "str", "YTS - " & $YTS_EventLog)
			$YTS_EventDisplay = $YTS_EventLog
			If ($DEBUGLOG = 1 Or StringInStr(StringLower($CmdLineRaw), "-debuglog")) Then FileWrite(@ScriptFullPath & "_LOG.txt", $TimeStampLoop & " - " & $YTS_EventLog & @CRLF)
		EndIf
	EndIf
	Return $YTS_EventDisplay
EndFunc   ;==>YTS_EventLog


Func GUIEnableDisable($Local_GUI_Type)
	If $Local_GUI_Type = "Button" Then
		GUICtrlSetState($radio_1, $GUI_CHECKED)
		GUICtrlSetState($GUI_Set_photo, $GUI_ENABLE)
		GUICtrlSetState($GUI_Set_logo, $GUI_ENABLE)
		GUICtrlSetState($GUI_Set_webpage, $GUI_ENABLE)
		GUICtrlSetState($GUI_disable_manual, $GUI_ENABLE)
		If GUICtrlRead($GUI_disable_manual) = 1 Then
			GUICtrlSetState($GUI_ManualAddressLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualAddress, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualPortLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualPort, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualIDLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualID, $GUI_ENABLE)
		Else
			GUICtrlSetState($GUI_ManualAddressLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualAddress, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualPortLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualPort, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualIDLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualID, $GUI_DISABLE)
		EndIf
		;ColorPicker
		GUICtrlSetState($GUI_Label_Color1, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color2, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color3, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color4, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color5, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color6, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color7, $GUI_ENABLE) ; address, port, etc
		GUICtrlSetState($GUI_Label_Color8, $GUI_DISABLE) ; radio button labels
		GUICtrlSetState($GUI_Label_Color9, $GUI_ENABLE) ; text4 on button GUI
		GUICtrlSetState($colour_Picker_BG_Color1, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_BG_Color2, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_BG_Color3, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color1, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color2, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_Color3, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_Color1, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color4, $GUI_ENABLE)
		;Text Lines
		GUICtrlSetState($Text_line1, $GUI_ENABLE)
		GUICtrlSetState($Text_line1_Label, $GUI_ENABLE)
		GUICtrlSetState($Text_line2, $GUI_ENABLE)
		GUICtrlSetState($Text_line2_Label, $GUI_ENABLE)
		GUICtrlSetState($Text_line3, $GUI_ENABLE)
		GUICtrlSetState($Text_line3_Label, $GUI_ENABLE)
		GUICtrlSetState($Text_line4, $GUI_ENABLE)
		GUICtrlSetState($Text_line4_Label, $GUI_ENABLE)
		GUICtrlSetState($Nr_Tel, $GUI_ENABLE)
		GUICtrlSetState($Nr_Tel_Label, $GUI_ENABLE)
		;webpage URL input
		If GUICtrlRead($GUI_Set_webpage) = $GUI_CHECKED Then
			GUICtrlSetState($GUI_WebPage, $GUI_ENABLE)
			GUICtrlSetState($GUI_WebPageLabel, $GUI_ENABLE)
		Else
			GUICtrlSetState($GUI_WebPage, $GUI_DISABLE)
			GUICtrlSetState($GUI_WebPageLabel, $GUI_DISABLE)
		EndIf
;		;Predefined Connections
;		GUICtrlSetState($GUI_UsePredefined, $GUI_CHECKED)
		SCP_Predef_EnableDisable("Enable")
		$radioval1 = 0
	ElseIf $Local_GUI_Type = "Combo" Then
		GUICtrlSetState($radio_2, $GUI_CHECKED)
		GUICtrlSetState($GUI_Set_photo, $GUI_DISABLE)
		GUICtrlSetState($GUI_Set_logo, $GUI_ENABLE)
		GUICtrlSetState($GUI_Set_webpage, $GUI_ENABLE)
		GUICtrlSetState($GUI_disable_manual, $GUI_ENABLE)
		If GUICtrlRead($GUI_disable_manual) = 1 Then
			GUICtrlSetState($GUI_ManualAddressLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualAddress, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualPortLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualPort, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualIDLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualID, $GUI_ENABLE)
		Else
			GUICtrlSetState($GUI_ManualAddressLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualAddress, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualPortLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualPort, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualIDLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualID, $GUI_DISABLE)
		EndIf
		;ColorPicker
		GUICtrlSetState($GUI_Label_Color1, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color2, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color3, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color4, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color5, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color6, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color7, $GUI_ENABLE) ; address, port, etc
		GUICtrlSetState($GUI_Label_Color8, $GUI_DISABLE) ; radio button labels
		GUICtrlSetState($GUI_Label_Color9, $GUI_DISABLE) ; text4 on button GUI
		GUICtrlSetState($colour_Picker_BG_Color1, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_BG_Color2, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_BG_Color3, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color1, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color3, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color1, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color4, $GUI_DISABLE)
		;Text Lines
		GUICtrlSetState($Text_line1, $GUI_ENABLE)
		GUICtrlSetState($Text_line1_Label, $GUI_ENABLE)
		GUICtrlSetState($Text_line2, $GUI_ENABLE)
		GUICtrlSetState($Text_line2_Label, $GUI_ENABLE)
		GUICtrlSetState($Text_line3, $GUI_ENABLE)
		GUICtrlSetState($Text_line3_Label, $GUI_ENABLE)
		GUICtrlSetState($Text_line4, $GUI_ENABLE)
		GUICtrlSetState($Text_line4_Label, $GUI_ENABLE)
		GUICtrlSetState($Nr_Tel, $GUI_ENABLE)
		GUICtrlSetState($Nr_Tel_Label, $GUI_ENABLE)
		;webpage URL input
		If GUICtrlRead($GUI_Set_webpage) = $GUI_CHECKED Then
			GUICtrlSetState($GUI_WebPage, $GUI_ENABLE)
			GUICtrlSetState($GUI_WebPageLabel, $GUI_ENABLE)
		Else
			GUICtrlSetState($GUI_WebPage, $GUI_DISABLE)
			GUICtrlSetState($GUI_WebPageLabel, $GUI_DISABLE)
		EndIf
;		;Predefined Connections
;		GUICtrlSetState($GUI_UsePredefined, $GUI_CHECKED)
		SCP_Predef_EnableDisable("Enable")
		$radioval1 = 1
	ElseIf $Local_GUI_Type = "Radio" Then
		GUICtrlSetState($radio_3, $GUI_CHECKED)
		GUICtrlSetState($GUI_Set_photo, $GUI_DISABLE)
		GUICtrlSetState($GUI_Set_logo, $GUI_ENABLE)
		GUICtrlSetState($GUI_Set_webpage, $GUI_ENABLE)
		GUICtrlSetState($GUI_disable_manual, $GUI_ENABLE)
		If GUICtrlRead($GUI_disable_manual) = 1 Then
			GUICtrlSetState($GUI_ManualAddressLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualAddress, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualPortLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualPort, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualIDLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualID, $GUI_ENABLE)
		Else
			GUICtrlSetState($GUI_ManualAddressLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualAddress, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualPortLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualPort, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualIDLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualID, $GUI_DISABLE)
		EndIf
		;ColorPicker
		GUICtrlSetState($GUI_Label_Color1, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color2, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color3, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color4, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color5, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color6, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color7, $GUI_ENABLE) ; address, port, etc
		GUICtrlSetState($GUI_Label_Color8, $GUI_ENABLE) ; radio button labels
		GUICtrlSetState($GUI_Label_Color9, $GUI_DISABLE) ; text4 on button GUI
		GUICtrlSetState($colour_Picker_BG_Color1, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_BG_Color2, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_BG_Color3, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color1, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color3, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color1, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_Color2, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_Color4, $GUI_DISABLE)
		;Text Lines
		GUICtrlSetState($Text_line1, $GUI_ENABLE)
		GUICtrlSetState($Text_line1_Label, $GUI_ENABLE)
		GUICtrlSetState($Text_line2, $GUI_ENABLE)
		GUICtrlSetState($Text_line2_Label, $GUI_ENABLE)
		GUICtrlSetState($Text_line3, $GUI_ENABLE)
		GUICtrlSetState($Text_line3_Label, $GUI_ENABLE)
		GUICtrlSetState($Text_line4, $GUI_ENABLE)
		GUICtrlSetState($Text_line4_Label, $GUI_ENABLE)
		GUICtrlSetState($Nr_Tel, $GUI_ENABLE)
		GUICtrlSetState($Nr_Tel_Label, $GUI_ENABLE)
		;webpage URL input
		If GUICtrlRead($GUI_Set_webpage) = $GUI_CHECKED Then
			GUICtrlSetState($GUI_WebPage, $GUI_ENABLE)
			GUICtrlSetState($GUI_WebPageLabel, $GUI_ENABLE)
		Else
			GUICtrlSetState($GUI_WebPage, $GUI_DISABLE)
			GUICtrlSetState($GUI_WebPageLabel, $GUI_DISABLE)
		EndIf
;		;Predefined Connections
;		GUICtrlSetState($GUI_UsePredefined, $GUI_CHECKED)
		SCP_Predef_EnableDisable("Enable")
		$radioval1 = 2
	ElseIf $Local_GUI_Type = "Manual" Then
		GUICtrlSetState($radio_4, $GUI_CHECKED)
		GUICtrlSetState($GUI_Set_photo, $GUI_DISABLE)
		GUICtrlSetState($GUI_Set_logo, $GUI_DISABLE)
		GUICtrlSetState($GUI_Set_webpage, $GUI_ENABLE)
		GUICtrlSetState($GUI_disable_manual, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualAddressLabel, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualAddress, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualPortLabel, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualPort, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualIDLabel, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualID, $GUI_DISABLE)
		;ColorPicker
		GUICtrlSetState($GUI_Label_Color1, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color2, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color3, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color4, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color5, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color6, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color7, $GUI_ENABLE) ; address, port, etc
		GUICtrlSetState($GUI_Label_Color8, $GUI_DISABLE) ; radio button labels
		GUICtrlSetState($GUI_Label_Color9, $GUI_DISABLE) ; text4 on button GUI
		GUICtrlSetState($colour_Picker_BG_Color1, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_BG_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_BG_Color3, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color1, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color3, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color1, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_Text_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color4, $GUI_DISABLE)
		;Text Lines
		GUICtrlSetState($Text_line1, $GUI_DISABLE)
		GUICtrlSetState($Text_line1_Label, $GUI_DISABLE)
		GUICtrlSetState($Text_line2, $GUI_DISABLE)
		GUICtrlSetState($Text_line2_Label, $GUI_DISABLE)
		GUICtrlSetState($Text_line3, $GUI_DISABLE)
		GUICtrlSetState($Text_line3_Label, $GUI_DISABLE)
		GUICtrlSetState($Text_line4, $GUI_DISABLE)
		GUICtrlSetState($Text_line4_Label, $GUI_DISABLE)
		GUICtrlSetState($Nr_Tel, $GUI_DISABLE)
		GUICtrlSetState($Nr_Tel_Label, $GUI_DISABLE)
		;webpage URL input
		If GUICtrlRead($GUI_Set_webpage) = $GUI_CHECKED Then
			GUICtrlSetState($GUI_WebPage, $GUI_ENABLE)
			GUICtrlSetState($GUI_WebPageLabel, $GUI_ENABLE)
		Else
			GUICtrlSetState($GUI_WebPage, $GUI_DISABLE)
			GUICtrlSetState($GUI_WebPageLabel, $GUI_DISABLE)
		EndIf
;		;Predefined Connections
;		GUICtrlSetState($GUI_UsePredefined, $GUI_UNCHECKED)
		SCP_Predef_EnableDisable("Disable")
		$radioval1 = 3
	ElseIf $Local_GUI_Type = "Auto" Then
		GUICtrlSetState($radio_5, $GUI_CHECKED)
		GUICtrlSetState($GUI_Set_photo, $GUI_DISABLE)
		GUICtrlSetState($GUI_Set_logo, $GUI_DISABLE)
		GUICtrlSetState($GUI_Set_webpage, $GUI_DISABLE)
		GUICtrlSetState($GUI_disable_manual, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualAddressLabel, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualAddress, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualPortLabel, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualPort, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualIDLabel, $GUI_DISABLE)
		GUICtrlSetState($GUI_ManualID, $GUI_DISABLE)
		;ColorPicker
		GUICtrlSetState($GUI_Label_Color1, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color2, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color3, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color4, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color5, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color6, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color7, $GUI_DISABLE) ; address, port, etc
		GUICtrlSetState($GUI_Label_Color8, $GUI_DISABLE) ; radio button labels
		GUICtrlSetState($GUI_Label_Color9, $GUI_DISABLE) ; text4 on button GUI
		GUICtrlSetState($colour_Picker_BG_Color1, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_BG_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_BG_Color3, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color1, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color3, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color1, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color4, $GUI_DISABLE)
		;Text Lines
		GUICtrlSetState($Text_line1, $GUI_DISABLE)
		GUICtrlSetState($Text_line1_Label, $GUI_DISABLE)
		GUICtrlSetState($Text_line2, $GUI_DISABLE)
		GUICtrlSetState($Text_line2_Label, $GUI_DISABLE)
		GUICtrlSetState($Text_line3, $GUI_DISABLE)
		GUICtrlSetState($Text_line3_Label, $GUI_DISABLE)
		GUICtrlSetState($Text_line4, $GUI_DISABLE)
		GUICtrlSetState($Text_line4_Label, $GUI_DISABLE)
		GUICtrlSetState($Nr_Tel, $GUI_DISABLE)
		GUICtrlSetState($Nr_Tel_Label, $GUI_DISABLE)
		;webpage URL input
		GUICtrlSetState($GUI_WebPage, $GUI_DISABLE)
		GUICtrlSetState($GUI_WebPageLabel, $GUI_DISABLE)
;		;Predefined Connections
;		GUICtrlSetState($GUI_UsePredefined, $GUI_CHECKED)
		SCP_Predef_EnableDisable("Disable")
		GUICtrlSetState($SCName_0, $GUI_ENABLE)
		GUICtrlSetState($SCID_0, $GUI_ENABLE)
		GUICtrlSetState($SCIP_0, $GUI_ENABLE)
		GUICtrlSetState($SCPort_0, $GUI_ENABLE)
		$radioval1 = 4
	Else
		GUICtrlSetState($radio_3, $GUI_CHECKED)
		GUICtrlSetState($GUI_Set_photo, $GUI_DISABLE)
		GUICtrlSetState($GUI_Set_logo, $GUI_DISABLE)
		GUICtrlSetState($GUI_Set_webpage, $GUI_ENABLE)
		GUICtrlSetState($GUI_disable_manual, $GUI_DISABLE)
		If GUICtrlRead($GUI_disable_manual) = 1 Then
			GUICtrlSetState($GUI_ManualAddressLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualAddress, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualPortLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualPort, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualIDLabel, $GUI_ENABLE)
			GUICtrlSetState($GUI_ManualID, $GUI_ENABLE)
		Else
			GUICtrlSetState($GUI_ManualAddressLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualAddress, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualPortLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualPort, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualIDLabel, $GUI_DISABLE)
			GUICtrlSetState($GUI_ManualID, $GUI_DISABLE)
		EndIf
		GUICtrlSetState($GUI_Label_Color1, $GUI_ENABLE)
		GUICtrlSetState($GUI_Label_Color2, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color3, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color4, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color5, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color6, $GUI_DISABLE)
		GUICtrlSetState($GUI_Label_Color7, $GUI_ENABLE) ; address, port, etc
		GUICtrlSetState($GUI_Label_Color8, $GUI_DISABLE) ; radio button labels
		GUICtrlSetState($GUI_Label_Color9, $GUI_DISABLE) ; text4 on button GUI
		GUICtrlSetState($colour_Picker_BG_Color1, $GUI_ENABLE)
		GUICtrlSetState($colour_Picker_BG_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_BG_Color3, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color1, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_BG_Color2, $GUI_DISABLE)
		GUICtrlSetState($colour_Picker_Text_Color3, $GUI_ENABLE)
		;Text Lines
		GUICtrlSetState($Text_line1, $GUI_DISABLE)
		GUICtrlSetState($Text_line1_Label, $GUI_DISABLE)
		GUICtrlSetState($Text_line2, $GUI_DISABLE)
		GUICtrlSetState($Text_line2_Label, $GUI_DISABLE)
		GUICtrlSetState($Text_line3, $GUI_DISABLE)
		GUICtrlSetState($Text_line3_Label, $GUI_DISABLE)
		GUICtrlSetState($Text_line4, $GUI_DISABLE)
		GUICtrlSetState($Text_line4_Label, $GUI_DISABLE)
		GUICtrlSetState($Nr_Tel, $GUI_DISABLE)
		GUICtrlSetState($Nr_Tel_Label, $GUI_DISABLE)
		;webpage URL input
		If GUICtrlRead($GUI_Set_webpage) = $GUI_CHECKED Then
			GUICtrlSetState($GUI_WebPage, $GUI_ENABLE)
			GUICtrlSetState($GUI_WebPageLabel, $GUI_ENABLE)
		Else
			GUICtrlSetState($GUI_WebPage, $GUI_DISABLE)
			GUICtrlSetState($GUI_WebPageLabel, $GUI_DISABLE)
		EndIf
;		;Predefined Connections
;		GUICtrlSetState($GUI_UsePredefined, $GUI_UNCHECKED)
		SCP_Predef_EnableDisable("Disable")
		$radioval1 = 3
	EndIf
EndFunc   ;==>GUIEnableDisable