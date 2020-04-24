#include-once
#include "Services.au3"
;#include "V2M_GlobalVars.au3"
;=========================================================================================================================================================
;=========================================================================================================================================================
;=========================================================================================================================================================
#Region languages
;_Language()
#EndRegion languages
#Region Declare the functions
;Global $AppINI, $V2M_VNC_UVNC, $V2M_EventDisplay




;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):	NULL
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Func _StopKnownVNCFlavour($AppINI, $V2M_VNC_UVNC, $force = 0)
	V2M_EventLog('FUNC - _StopKnownVNCFlavour()', '', "8")
	Local $INI_VNCFlavourSection = IniReadSection($AppINI, "VNCFlavours"), $Flavour = 1, $return = ""
	Run(@ScriptDir & "\winvnc.exe -kill", @ScriptDir, @SW_HIDE)
	If IsArray($INI_VNCFlavourSection) Then
		While $Flavour < UBound($INI_VNCFlavourSection)
			If _Service_Exists($INI_VNCFlavourSection[$Flavour][1]) Then
				V2M_EventLog('_StopKnownVNCFlavour - Found ' & $INI_VNCFlavourSection[$Flavour][1] & ' Service', '', "8")
				V2M_EventLog("_GetServiceState($INI_VNCFlavourSection[$Flavour][1]) = " & _GetServiceState($INI_VNCFlavourSection[$Flavour][1]))
				If _Service_QueryStatus($INI_VNCFlavourSection[$Flavour][1]) Then
					V2M_EventLog('_StopKnownVNCFlavour - Found ' & $INI_VNCFlavourSection[$Flavour][1] & ' Service is Running - trying to stop', '', "6")
					_Service_Stop($INI_VNCFlavourSection[$Flavour][1])
;					Dim $KnownVncFlavour = $INI_VNCFlavourSection[$Flavour][1]
					$return &= $INI_VNCFlavourSection[$Flavour][1]
					ExitLoop
				Else
					V2M_EventLog('_StopKnownVNCFlavour - Found ' & $INI_VNCFlavourSection[$Flavour][1] & ' Service is NOT Running', '', "6")
				EndIf
			EndIf
			$Flavour = $Flavour + 1
		WEnd
	EndIf
	If $force = 1 Then
		ProcessClose('winvnc.exe')
		ProcessClose($V2M_VNC_UVNC)
	EndIf
	Return $return
EndFunc   ;==>_StopKnownVNCFlavour


;===============================================================================
; Description:		I
; Parameter(s):
; Requirement(s):
; Return Value(s):	NULL
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Func _StartStopedVNCFlavour($Flavour = "uvnc_service")
	V2M_EventLog('FUNC - _StartKnownVNCFlavour()', '', "8")
	Local $LocalReturn = "", $local_ServiceStatus
	$local_ServiceStatus = _Service_QueryStatus($Flavour)
	If $local_ServiceStatus[1] = 4 Then
		V2M_EventLog('_StartKnownVNCFlavour - Found ' & $Flavour & ' Service is already Running', '', "6")
		$LocalReturn = "Started"
	Else
		V2M_EventLog('_StopKnownVNCFlavour - Found ' & $Flavour & ' Service is NOT Running, lets start it', '', "6")
		_Service_Start($Flavour)
		$LocalReturn = "Starting"
	EndIf
	Return $Flavour & " " & $LocalReturn
EndFunc   ;==>_StartStopedVNCFlavour
;===============================================================================
; Description:		Creates a Disclaimer GUI which shows disclaimer.htm
; Parameter(s):		NULL
; Requirement(s):	disclaimer.htm needs to exist in the same directory
; Return Value(s):	NULL
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
;Global $V2M_GUI_Language
Global $GUI
Func _Disclaimer_GUI()
	If Not IsDeclared("V2M_EventDisplay") Then
#		dim $V2M_EventDisplay
	EndIf
	$V2M_EventDisplay= V2M_EventLog("FUNC - _Disclaimer_GUI()", $V2M_EventDisplay, "8")
	Local $LocalReturn
	Local $oIE, $GUI_Disclaimer, $GUI_Disclaimer_Accept, $GUI_Disclaimer_Exit, $GUI_Disclaimer_Reject
	Local $V2M_GUI_DisclaimerWidth = 580
	;
	;=========================================================================================================================================================
	; Create the Disclaimer GUI
#	dim $V2M_GUI_Language
	If (FileExists(@ScriptDir & "\disclaimer.htm")) Or (FileExists(@ScriptDir & "\disclaimer_" & $V2M_GUI_Language & ".htm")) Then
		_IEErrorHandlerRegister()

		$oIE = _IECreateEmbedded()
		$GUI_Disclaimer = GUICreate(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "SCPrompt"), $V2M_GUI_DisclaimerWidth, @DesktopHeight - 100, (@DesktopWidth - $V2M_GUI_DisclaimerWidth) / 2, 10, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_CLIPCHILDREN, BitOR(128, 8))
		$GUIActiveX = GUICtrlCreateObj($oIE, 10, 10, $V2M_GUI_DisclaimerWidth - 20, @DesktopHeight - 150)

		Local $CurLeft = 20
		$GUI_Disclaimer_Accept = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "BTN_DISCLAIMER_ACCEPT", "ACCEPT"), $CurLeft, @DesktopHeight - 124, 80, 20)
		$CurLeft = $CurLeft + 90
		$GUI_Disclaimer_Reject = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "BTN_DISCLAIMER_REJECT", "REJECT"), $CurLeft, @DesktopHeight - 124, 60, 20)
		$CurLeft = $CurLeft + 80
		$GUI_Disclaimer_Exit = GUICtrlCreateButton(_RSC_INIReadSection_key($INI_Translation_Section, "BTN_DISCLAIMER_EXIT", "EXIT") & " " & _RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me"), $CurLeft, @DesktopHeight - 124, 160, 20)
		If FileExists(@ScriptDir & "\disclaimer_" & $V2M_GUI_Language & ".htm") Then
			$V2M_EventDisplay = V2M_EventLog("_Disclaimer_GUI() - '" & @ScriptDir & "\disclaimer_" & $V2M_GUI_Language & ".htm' exists, so using that ...", $V2M_EventDisplay, "9")
			_IENavigate($oIE, @ScriptDir & "\disclaimer_" & $V2M_GUI_Language & ".htm")
		Else
			$V2M_EventDisplay = V2M_EventLog("_Disclaimer_GUI() - '" & @ScriptDir & "\disclaimer.htm' exists, so using that ...", $V2M_EventDisplay, "9")
			_IENavigate($oIE, @ScriptDir & "\disclaimer.htm")
		EndIf
		GUISetState(@SW_SHOWDEFAULT, $GUI_Disclaimer) ;Show GUI
		$TimeStampLoop[1] = _NowCalc()
		$TimeStampLoop[1] = _DateAdd('s', 60 - 1, $TimeStampLoop[1]) ;sleep for 59 more seconds (60 in total)
		While 1
			Switch GUIGetMsg()
				Case $GUI_Disclaimer_Accept
					$LocalReturn = "ACCEPT"
					ExitLoop
				Case $GUI_Disclaimer_Reject
					$LocalReturn = "REJECT"
					ExitLoop
				Case $GUI_Disclaimer_Exit
					$LocalReturn = "EXIT"
					ExitLoop
			EndSwitch
			If _DateDiff('s', $TimeStampLoop[1], _NowCalc()) >= 1 Then
				$LocalReturn = "TIMEOUT"
				ExitLoop
			EndIf
		WEnd
		GUIDelete($GUI_Disclaimer)
	Else
		;		$GUIActiveX = 0
		$LocalReturn = "NOFILE"
	EndIf
	$TimeStampLoop[1] = _NowCalc()
	Return $LocalReturn
EndFunc   ;==>_Disclaimer_GUI

;===============================================================================
; URL:					http://www.autoitscript.com/forum/index.php?showtopic=25162
; Description:			Control Services
; Parameter(s):			$s_pc = computer to be controlled, $service = Service to be controlled
;						$State = "Boot" Or "System" Or "Automatic" Or "Manual" Or "Disabled" Or "Stop" Or "Start" Or "Restart" Or "Pause" Or "Resume" Or "Delete"
; Requirement(s):		$s_pc needs to respond to a ping request
; Return Value(s):		"Success", "Not supported", "Access denied", "Dependent services running",
;					"Invalid service control", "Service cannot accept control", "Service not active", "Service request timeout",
;					"Unknown failure", "Path not found", "Service already stopped", "Service database locked", "Service dependency deleted",
;					"Service dependency failure", "Service disabled", "Service logon failed", "Service marked for deletion", "Service no thread",
;					"Status circular dependency", "Status duplicate name", "Status - invalid name", "Status - invalid parameter",
;					"Status - invalid service account", "Status - service exists", "Service already paused", -1
; Author(s):            GaryFrost/YTS_Jim
; Note(s):
;===============================================================================
Func _SetServiceState($service, $State, $s_pc = "localhost")
	$V2M_EventDisplay = V2M_EventLog("FUNC - _SetServiceState(" & $service & "," & $State & "," & $s_pc & ")", $V2M_EventDisplay, "8")
	Local Const $wbemFlagReturnImmediately = 0x10
	Local Const $wbemFlagForwardOnly = 0x20

	Local $colItems = "", $objItem, $ret_status = -1
	Local $a_status[25] = ["Success", "Not supported", "Access denied", "Dependent services running", _
			"Invalid service control", "Service cannot accept control", "Service not active", "Service request timeout", _
			"Unknown failure", "Path not found", "Service already stopped", "Service database locked", "Service dependency deleted", _
			"Service dependency failure", "Service disabled", "Service logon failed", "Service marked for deletion", "Service no thread", _
			"Status circular dependency", "Status duplicate name", "Status - invalid name", "Status - invalid parameter", _
			"Status - invalid service account", "Status - service exists", "Service already paused"]
	If Ping($s_pc) Then
		Local $objWMIService = ObjGet("winmgmts:\\" & $s_pc & "\root\CIMV2")
		If @error Then
			MsgBox(16, "_SetServiceState", "ObjGet Error: winmgmts")
			Return
		EndIf
		$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Service", "WQL", _
				$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
		$V2M_EventDisplay = V2M_EventLog("_SetServiceState - $colItems = " & $colItems, $V2M_EventDisplay, "8")
		If @error Then
			MsgBox(16, "_SetServiceState", "ExecQuery Error: SELECT * FROM Win32_Service")
			Return
		EndIf
		If IsObj($colItems) Then
			$V2M_EventDisplay = V2M_EventLog("_SetServiceState - $colItems is an object", $V2M_EventDisplay, "9")
			For $objItem In $colItems
				If $objItem.Name = $service Then
					Select
						Case $State = "Boot" Or $State = "System" Or $State = "Automatic" Or $State = "Manual" Or $State = "Disabled"
							$ret_status = $objItem.ChangeStartMode($State)
						Case $State = "Stop"
							$ret_status = $objItem.StopService()
						Case $State = "Start"
							$ret_status = $objItem.StartService()
						Case $State = "Restart"
							$ret_status = $objItem.StopService()
							$ret_status = $objItem.StartService()
						Case $State = "Pause"
							$ret_status = $objItem.PauseService()
						Case $State = "Resume"
							$ret_status = $objItem.ResumeService()
						Case $State = "Delete"
							$ret_status = $objItem.Delete()
					EndSelect
					ExitLoop
				EndIf
			Next
		Else
			$V2M_EventDisplay = V2M_EventLog("_SetServiceState - $colItems is NOT an object", $V2M_EventDisplay, "9")
		EndIf
	EndIf
	If $ret_status <> -1 Then
		Return $a_status[$ret_status]
	Else
		SetError(1)
		Return $ret_status
	EndIf
EndFunc   ;==>_SetServiceState

;===============================================================================
; Description:		Checks if the Application is already running
; Parameter(s):		$sOccurenceName = Application Name
; Requirement(s):	kernel32.dll
; Return Value(s):
; Author(s):		??? (found on autoit Forums ?)
; Note(s):
;===============================================================================
Func _MutexExists($sOccurenceName)
	$V2M_EventDisplay = V2M_EventLog("FUNC - _MutexExists()", $V2M_EventDisplay, "8")
	Local $ERROR_ALREADY_EXISTS = 183, $lastError

	$sOccurenceName = StringReplace($sOccurenceName, "\", ""); to avoid error
	DllCall("kernel32.dll", "int", "CreateMutex", "int", 0, "long", 1, "str", $sOccurenceName)

	$lastError = DllCall("kernel32.dll", "int", "GetLastError")
	Return $lastError[0] = $ERROR_ALREADY_EXISTS

EndFunc   ;==>_MutexExists


;===============================================================================
;
; Description:          Eventlog handler, sends logs to std windows debug (via dll) and LogFile if needed
; Parameter(s):         $V2M_EventLog   =       Text string to send to log
;						$Local_debug_level =	0, text is display in statusbar. else, only sent to debug dll
; Requirement(s):
; Return Value(s):      $V2M_EventDisplay
; Author(s):            YTS_Jim
; Note(s):
;
;===============================================================================
Func V2M_EventLog($V2M_EventLog = '', $V2M_EventDisplay = '', $Local_debug_level = "8")
	If $DebugLevel >= $Local_debug_level Then
		If $V2M_EventLog <> $V2M_EventDisplay Then
			; view the following output from sysinternals debuger "DebugView" or similar
			DllCall("kernel32.dll", "none", "OutputDebugString", "str", "V2M - " & $V2M_EventLog)
			$V2M_EventDisplay = $V2M_EventLog
			If ($DEBUGLOG = 1 Or StringInStr($CmdLineRaw, "-debuglog")) Then FileWrite(@ScriptFullPath & "_LOG.txt", $TimeStampLoop[1] & " - " & $V2M_EventLog & @CRLF)
		EndIf
	EndIf
	Return $V2M_EventDisplay
EndFunc   ;==>V2M_EventLog

;=========================================================================================================================================================

;===============================================================================
;
; Description:          Exits all v2m vnc apps, and updates log
; Parameter(s):         none
; Requirement(s):       none
; Return Value(s):      none
; Author(s):            YTS_Jim
; Note(s):                      none
;
;===============================================================================
Func V2MExitVNC($Mode = "SCPrompt")
	Local $local_loop_count = 0
	$V2M_EventDisplay = V2M_EventLog("FUNC - V2MExitVNC()", $V2M_EventDisplay, "8")
	If $Mode = "SCPrompt" Then
		If (_RSC_INIReadSection_key($INI_CommonSection, "ServiceMode", "0") <> "0") Then ;Service Mode
			;		If ($YTS_Cleanup = 1) Then
			;		EndIf
			If IsAdmin() Then
				;				_VNCServiceMode("Stop")
				;			_VNCServiceMode("Uninstall")
			EndIf
		Else ;User Mode
			Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -kill", @ScriptDir)
			$V2M_EventDisplay = V2M_EventLog("Run(" & @ScriptDir & '\' & $V2M_VNC_UVNC & " -kill, " & @ScriptDir & ")", $V2M_EventDisplay, "8")
			Sleep(1000)
			If ProcessExists($V2M_VNC_UVNC) Then
				While ProcessExists($V2M_VNC_UVNC) Or $local_loop_count < 4
					ProcessWaitClose($V2M_VNC_UVNC, 3)
					If ProcessExists($V2M_VNC_UVNC) Then
						Run(@ScriptDir & "\" & $V2M_VNC_UVNC & " -kill", @ScriptDir)
						ProcessClose($V2M_VNC_UVNC)
						$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_UVNC & ' Closed Forcibly', $V2M_EventDisplay, "7")
					Else
						$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_UVNC & ' Closed Cleanly', $V2M_EventDisplay, "7")
					EndIf
					$local_loop_count = $local_loop_count + 1
				WEnd
			Else
				$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_UVNC & ' Closed Cleanly', $V2M_EventDisplay, "7")
			EndIf
		EndIf
	Else
		While ProcessExists($V2M_VNC_VWR)
			ProcessWaitClose($V2M_VNC_VWR, 3)
			If ProcessExists($V2M_VNC_VWR) Then
				ProcessClose($V2M_VNC_VWR)
				$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_VWR & ' Closed Forcibly', $V2M_EventDisplay, '8')
			Else
				$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_VWR & ' Closed Cleanly', $V2M_EventDisplay, '8')
			EndIf
		WEnd
		While ProcessExists($V2M_VNC_SC)
			ProcessWaitClose($V2M_VNC_SC, 3)
			If ProcessExists($V2M_VNC_SC) Then
				ProcessClose($V2M_VNC_SC)
				$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_SC & ' Closed Forcibly', $V2M_EventDisplay, '8')
			Else
				$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_SC & ' Closed Cleanly', $V2M_EventDisplay, '8')
			EndIf
		WEnd
		While ProcessExists($V2M_VNC_SVR)
			ProcessWaitClose($V2M_VNC_SVR, 3)
			If ProcessExists($V2M_VNC_SVR) Then
				ProcessClose($V2M_VNC_SVR)
				$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_SVR & ' Closed Forcibly', $V2M_EventDisplay, '8')
			Else
				$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_SVR & ' Closed Cleanly', $V2M_EventDisplay, '8')
			EndIf
		WEnd
		While ProcessExists($V2M_VNC_UVNC)
			ProcessWaitClose($V2M_VNC_UVNC, 3)
			If ProcessExists($V2M_VNC_UVNC) Then
				ProcessClose($V2M_VNC_UVNC)
				$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_UVNC & ' Closed Forcibly', $V2M_EventDisplay, '8')
			Else
				$V2M_EventDisplay = V2M_EventLog('VNC - ' & $V2M_VNC_UVNC & ' Closed Cleanly', $V2M_EventDisplay, '8')
			EndIf
		WEnd
		ProcessClose($V2M_VNC_VWR)
		ProcessClose($V2M_VNC_SC)
		ProcessClose($V2M_VNC_SVR)
	EndIf
	$V2M_EventDisplay = V2M_EventLog('VNC - All VNCs closed', $V2M_EventDisplay, "0")
	_RefreshSystemTray(50)
EndFunc   ;==>V2MExitVNC

;=========================================================================================================================================================
;============================================================== Vista Functions ==========================================================================
;=========================================================================================================================================================

;===============================================================================
; Description:		Controls Aero in Vista. Helps with slow screen updates.
; Parameter(s):		$control = Enable / Disable
; Requirement(s):	NULL
; Return Value(s):	NULL
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Func Vista_ControlAero($control = "Enable")
	$V2M_EventDisplay = V2M_EventLog("FUNC - Vista_ControlAero()", $V2M_EventDisplay, "8")
	Local $DWMdll = DllOpen("dwmapi.dll")
	If $control = "Disable" Then
		DllCall($DWMdll, "int", "DwmEnableComposition", "uint", $DWM_EC_ENABLECOMPOSITION)
		$V2M_EventDisplay = V2M_EventLog("Vista - 'DwmEnableComposition' has been enabled (Aero turned off)", $V2M_EventDisplay, "2")
	ElseIf $control = "Enable" Then
		DllCall($DWMdll, "int", "DwmEnableComposition", "uint", $DWM_EC_DISABLECOMPOSITION)
		$V2M_EventDisplay = V2M_EventLog("Vista - 'DwmEnableComposition' has been disabled (Aero turned on)", $V2M_EventDisplay, "2")
	EndIf
EndFunc   ;==>Vista_ControlAero

;===============================================================================
; Description:		Controls Aero in WIN_7. Helps with slow screen updates.
; Parameter(s):		$control = Enable / Disable
; Requirement(s):	NULL
; Return Value(s):	NULL
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Func WIN7_ControlAero($control = "Enable")
	;	Local $DWMdll = DllOpen("dwmapi.dll")
	If $control = "Disable" Then
		DllCall("dwmapi.dll", "hwnd", "DwmEnableComposition", "uint", $DWM_EC_DISABLECOMPOSITION)
	Else
		DllCall("dwmapi.dll", "hwnd", "DwmEnableComposition", "uint", $DWM_EC_ENABLECOMPOSITION)
	EndIf
EndFunc   ;==>WIN7_ControlAero

;===============================================================================
; Description:		Gets the Transparency values from Vista ...
; Parameter(s):		NULL
; Requirement(s):	NULL
; Return Value(s):	$status[0] = the value of composition state
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Func Vista_GetComposition()
	$V2M_EventDisplay = V2M_EventLog("FUNC - Vista_GetComposition()", $V2M_EventDisplay, "8")
	Local $DWMdll = DllOpen("dwmapi.dll")
	Local $status[10]
	$status = DllCall($DWMdll, "int", "DwmIsCompositionEnabled", "int*", "")
	Return $status[1]
EndFunc   ;==>Vista_GetComposition

;===============================================================================
; Description:		Controls UAC in VISTA, but not WIN7
; Parameter(s):		$control = Restore / Disable
; Requirement(s):	NULL
; Return Value(s):	NULL
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Func Vista_ControlUAC($control = "Restore")
	$V2M_EventDisplay = V2M_EventLog("FUNC - Vista_ControlUAC()", $V2M_EventDisplay, "8")
	Local $curVal
	If $control = "Disable" Then
		If RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "PromptOnSecureDesktop_V2M") = "" Then ; if the value doesn't exist
			$V2M_EventDisplay = V2M_EventLog("VISTA - Disabling PromptOnSecureDesktop", $V2M_EventDisplay, "4")
			$curVal = RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "PromptOnSecureDesktop")
			RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "PromptOnSecureDesktop_V2M", "REG_DWORD", $curVal)
			RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "PromptOnSecureDesktop", "REG_DWORD", 0)
		EndIf
		If RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin_V2M") = "" Then ; if the value doesn't exist
			$V2M_EventDisplay = V2M_EventLog("VISTA - Disabling ConsentPromptBehaviorAdmin", $V2M_EventDisplay, "4")
			$curVal = RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin")
			RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin_V2M", "REG_DWORD", $curVal)
			RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin", "REG_DWORD", 0)
		EndIf
	ElseIf $control = "Restore" Then
		$curVal = RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "PromptOnSecureDesktop_V2M")
		If $curVal = 0 Or $curVal = 1 Then
			$V2M_EventDisplay = V2M_EventLog("VISTA - Restoring PromptOnSecureDesktop Settings", $V2M_EventDisplay, "4")
			RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "PromptOnSecureDesktop", "REG_DWORD", $curVal)
			RegDelete("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "PromptOnSecureDesktop_V2M")
		EndIf

		$curVal = RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin_V2M")
		If $curVal = 0 Or $curVal = 1 Or $curVal = 2 Then
			$V2M_EventDisplay = V2M_EventLog("VISTA - Restoring ConsentPromptBehaviorAdmin Settings", $V2M_EventDisplay, "4")
			RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin", "REG_DWORD", $curVal)
			RegDelete("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin_V2M")
		EndIf
	EndIf
EndFunc   ;==>Vista_ControlUAC


;===============================================================================
;
; Description: gets an INI file from the vnc2me.org website. checks the values against the information in the app, and alerts if its a different number
; Parameter(s): $Local_App (what INI section to read from)
; Requirement(s):
; Return Value(s):
; Author(s):            YTS_Jim
; Note(s):
;
;===============================================================================

Func V2M_Update($Local_App = "VNC2Me", $Local_UpdateType = "")
	$V2M_EventDisplay = V2M_EventLog("FUNC - V2M_Update()", $V2M_EventDisplay, "8")
	Local $s_GetVersFile, $Local_loop, $local_loop_count, $msgbox_new_testing, $msgbox_new_beta
	If (_RSC_INIReadSection_key($INI_CommonSection, "INETUPDATE", 1) = 1 Or _RSC_INIReadSection_key($INI_CommonSection, "TESTUPDATE", 0) = 1 Or $Local_UpdateType = "INETUPDATE" Or $Local_UpdateType = "TESTUPDATE") And @Compiled Then
		; needs translation friendly
		TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SC"), "Checking for Updates via the internet" & @CRLF & "Please Wait", 10)
		$V2M_EventDisplay = V2M_EventLog("Updates - Checking for updates from " & _RSC_INIReadSection_key($INI_CommonSection, "UpdateURL", "http://www.vnc2me.org/files/latestversion.ini"), $V2M_EventDisplay, "4")
		;#######################################################################################
		; check for old version control file and delete it
		;#######################################################################################
		If FileExists(@TempDir & "\v2m_latestversion.ini") Then
			If Not FileDelete(@TempDir & "\v2m_latestversion.ini") Then ; problem deleting old version control file
				$V2M_EventDisplay = V2M_EventLog("Updates - Cannot delete '" & @TempDir & "\v2m_latestversion.ini'", $V2M_EventDisplay, "7")
				MsgBox(262160, StringTrimRight(@ScriptName, 4) & " ERROR", "UPDATE CHECK FAILED" & @CRLF & @CRLF & "Possible cause: Old VCF file cannot be overwritten (may be read only).")
				Return SetError(3, 0, "262160|" & StringTrimRight(@ScriptName, 4) & " ERROR|UPDATE CHECK FAILED|Possible cause: Old VCF file cannot be overwritten (may be read only).")
			Else
				$V2M_EventDisplay = V2M_EventLog("Updates - Deleted '" & @TempDir & "\v2m_latestversion.ini'", $V2M_EventDisplay, "7")
			EndIf
		Else
			$V2M_EventDisplay = V2M_EventLog("Updates - VNC2Me update appears not to have previously been run on this computer", $V2M_EventDisplay, "7")
		EndIf
		;#######################################################################################
		; download version control file from web to temp dir
		;#######################################################################################
		$s_GetVersFile = InetGet(_RSC_INIReadSection_key($INI_CommonSection, "UpdateURL", "http://www.vnc2me.org/files/latestversion.ini"), @TempDir & "\v2m_latestversion.ini", 1)
		If $s_GetVersFile = 0 Then ; version file or internet not available
			$V2M_EventDisplay = V2M_EventLog("Updates - Unable to get the version information from the internet", $V2M_EventDisplay, "7")
			MsgBox(262160, StringTrimRight(@ScriptName, 4) & " ERROR", "UPDATE CHECK FAILED" & @CRLF & @CRLF & "Possible cause: Connection issues / website offline or version file not found.  Try again later.")
			Return SetError(4, 0, "262160|" & StringTrimRight(@ScriptName, 4) & " ERROR|UPDATE CHECK FAILED|Possible cause: Connection issues / website offline or version file not found.  Try again later.")
		Else
			$V2M_EventDisplay = V2M_EventLog("Updates - Downloaded latest version information to '" & @TempDir & "\v2m_latestversion.ini'", $V2M_EventDisplay, "7")
		EndIf
		While $Local_loop = 0
			Sleep(250) ; create a delay loop to ensure that file has been downloaded and saved before continuing
			If FileExists(@TempDir & "\v2m_latestversion.ini") Then $Local_loop = 1 ; when file exists, exit the loop (could use exitloop(), but i like this way)
			$local_loop_count = $local_loop_count + 1
			If $local_loop_count > 20 Then $Local_loop = 1 ; if file doesn't exist in 5 seconds, continue anyway.
		WEnd

		;#######################################################################################
		; Check for latest release
		;#######################################################################################
		If _RSC_INIReadSection_key($INI_CommonSection, "INETUPDATE", 1) = 1 Then
			$V2M_EventDisplay = V2M_EventLog("Updates - checking the downloaded version file, and comparing version numbers", $V2M_EventDisplay, "7")
			If IniRead(@TempDir & "\v2m_latestversion.ini", $Local_App, "LatestBeta", FileGetVersion(@ScriptFullPath)) <> FileGetVersion(@ScriptFullPath) Then
				$V2M_EventDisplay = V2M_EventLog("Updates - Version of App and version in file differ, this (usually) means an update is available.", $V2M_EventDisplay, "7")
				$msgbox_new_beta = MsgBox(4, "VNC2Me Updates", "Latest release available on the project website" & @CRLF & "www.vnc2me.org" & @CRLF & @CRLF & "Do you want to download now ???")
				If $msgbox_new_beta = 6 Then Run(@ComSpec & " /c start /w www.vnc2me.org/downloads.html", @ScriptDir, @SW_HIDE)
			Else
				$V2M_EventDisplay = V2M_EventLog("Updates - Latest Version of App.", $V2M_EventDisplay, "7")
			EndIf
		EndIf

		;#######################################################################################
		; check for testing release
		;#######################################################################################
		If _RSC_INIReadSection_key($INI_CommonSection, "TESTUPDATE", 0) = 1 Then
			$V2M_EventDisplay = V2M_EventLog("Updates - TEST - checking the downloaded version file, and comparing version numbers.", $V2M_EventDisplay, "7")
			If IniRead(@TempDir & "\v2m_latestversion.ini", $Local_App, "LatestTesting", FileGetVersion(@ScriptFullPath)) <> FileGetVersion(@ScriptFullPath) Then
				$V2M_EventDisplay = V2M_EventLog("Updates - TEST - Version of App and version in file differ, this (usually) means an update is available.", $V2M_EventDisplay, "7")
				$msgbox_new_testing = MsgBox(4, "VNC2Me Updates", "There is an updated Testing version available" & @CRLF & "Thankyou for helping test VNC2Me products" & @CRLF & @CRLF & "Do you want to download now ???", 10)
				If $msgbox_new_testing = 6 Then Run(@ComSpec & " /c start /w www.vnc2me.org/files/releases/testing/", @ScriptDir, @SW_HIDE)
			Else
				$V2M_EventDisplay = V2M_EventLog("Updates - TEST - Latest Version of App.", $V2M_EventDisplay, "7")
				TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SC") & " " & "Updates", "You are using the latest TESTING version", 10)
				Sleep(1000)
			EndIf
		EndIf
	EndIf
	TrayTip(_RSC_INIReadSection_key($INI_CommonSection, "APPName", "VNC2Me SC") & " " & "clears any tray tip", "", 0)
EndFunc   ;==>V2M_Update

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            YTS_Jim
; Note(s):
;===============================================================================
;if not IsDeclared("GUI_Label") Then
;	Global $GUI_Label, $pngSrc, $hImage, $width, $height, $GUI, $controlGui, $StopButton
;EndIf
Func LoadApp($LocalName = "Test", $pngSrc = "")
	$V2M_EventDisplay = V2M_EventLog("FUNC - LoadApp()", $V2M_EventDisplay, "8")
	Local $sCountDown = 5, $return

	; Load PNG file as GDI bitmap
	_GDIPlus_Startup()
	If $pngSrc = "" Then
		$pngSrc = @ScriptDir & "\QC_Skin_Border.png"
	EndIf
	$hImage = _GDIPlus_ImageLoadFromFile($pngSrc)

	; Extract image width and height from PNG
	$width = _GDIPlus_ImageGetWidth($hImage)
	$height = _GDIPlus_ImageGetHeight($hImage)

	; Create layered window
	$GUI = GUICreate("SC Prompt", $width, $height, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
	SetBitmap($GUI, $hImage, 0)
	; Register notification messages
	GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
	GUISetState()
	WinSetOnTop($GUI, "", 1)
	;fade in png background
	For $i = 0 To 255 Step 5
		SetBitmap($GUI, $hImage, $i)
	Next


	; create child MDI gui window to hold controls
	; this part could use some work - there is some flicker sometimes...
	$controlGui = GUICreate("ControlGUI", $width, $height, 0, 0, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $GUI)
	_RSC_CreateContextMenus()

	; child window transparency is required to accomplish the full effect, so $WS_EX_LAYERED above, and
	; I think the way this works is the transparent window color is based on the image you set here:
	GUICtrlCreatePic(@ScriptDir & "\QC_Skin_BG.gif", 0, 0, $width, $height)
	GUICtrlSetState(-1, $GUI_DISABLE)

	; just a text label

	$GUI_Label = GUICtrlCreateLabel(_RSC_INIReadSection_key($INI_Translation_Section, "MAIN_AUTO_MESSAGE1", "Starting Connection to") & " " & $LocalName & _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_AUTO_MESSAGE2", " in ") & " " & $sCountDown & " " & _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_AUTO_MESSAGE3", " Seconds"), 50, 30, 140, 50)
	;	$GUI_Label = GUICtrlCreateLabel("Starting Connection to " & $LocalName & " in 5 Seconds", 50, 30, 140, 50)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0xFFFFFF)

	; set default button for Enter key activation - renders outside GUI window
	$StopButton = GUICtrlCreateButton("Stop", 210, 34, 250, -1, $BS_DEFPUSHBUTTON)

	GUISetState()

	$TimeStampLoop[1] = _NowCalc()
	While $V2M_Exit = 0
		;               $msg = GUIGetMsg()
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				$return = 0
				$V2M_Exit = 1
			Case $StopButton
				$return = 0
				$V2M_Exit = 1
		EndSwitch
		If _DateDiff('s', $TimeStampLoop[1], _NowCalc()) >= 1 Then
			$TimeStampLoop[1] = _NowCalc()
			$sCountDown = $sCountDown - 1
			If _RSC_INIReadSection_key($INI_CommonSection, "GUIAUTOSILENT", 0) <> 1 Then
				Beep(1000, 50)
				Beep(2000, 50)
			EndIf
			;			GUICtrlSetData($GUI_Label, "Starting Connection to " & $LocalName & " in " & $sCountDown & " Seconds")
			GUICtrlSetData($GUI_Label, _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_AUTO_MESSAGE1", "Starting Connection to") & " " & $LocalName & " " & _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_AUTO_MESSAGE2", "in") & " " & $sCountDown & " " & _RSC_INIReadSection_key($INI_Translation_Section, "MAIN_AUTO_MESSAGE3", " Seconds"))
			If $sCountDown < 0 Then
				$return = 1
				ExitLoop
			EndIf
		EndIf
	WEnd

	;       If $runthis <> "" Then
	;               If FileExists($launchDir & "\" & $runthis) Then
	;                       Beep(1000, 50)
	;                       Beep(2000, 50)
	;                       _ShellExecute($runthis, "", $launchDir)
	;               EndIf
	;       EndIf

	GUIDelete($controlGui)
	;fade out png background
	For $i = 255 To 0 Step -5
		SetBitmap($GUI, $hImage, $i)
	Next

	; Release resources
	_WinAPI_DeleteObject($hImage)
	_GDIPlus_Shutdown()
	GUIDelete($GUI)
	Return $return
EndFunc   ;==>LoadApp


;Func GoAutoComplete()
;    _GUICtrlComboBox_AutoComplete($Combo)
;EndFunc   ;==>GoAutoComplete

; ====================================================================================================
; Handle the WM_NCHITTEST for the layered window so it can be dragged by clicking anywhere on the image.
; ====================================================================================================

;===============================================================================
; Description:		Allows Moving of count-down GUI (transparent Background)
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Func WM_NCHITTEST($hWnd, $iMsg)
	$V2M_EventDisplay = V2M_EventLog("FUNC - WM_NCHITTEST()", $V2M_EventDisplay, "8")
	If ($hWnd = $GUI) And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
EndFunc   ;==>WM_NCHITTEST

; ====================================================================================================

; SetBitMap
; ====================================================================================================

;===============================================================================
; Description:		Setup Background Transparency on the CountDown GUI
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
#include <StructureConstants.au3>
Func SetBitmap($hGUI, $hImage, $iOpacity)
	$V2M_EventDisplay = V2M_EventLog("FUNC - SetBitmap()", $V2M_EventDisplay, "8")
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
	_WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap



;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            YTS_Jim
; Note(s):
;===============================================================================
Func _StartSite($INI_Set_webpage)
	Local $site_Start
	$V2M_EventDisplay = V2M_EventLog("FUNC - _StartSite()", $V2M_EventDisplay, "8")
	If @OSType = 'WIN32_NT' Then
		$site_Start = @ComSpec & ' /c start "" '
	Else
		$site_Start = @ComSpec & ' /c start '
	EndIf
	Run($site_Start & $INI_Set_webpage, '', @SW_HIDE)
EndFunc   ;==>_StartSite


; ===================================================================
; http://www.autoitscript.com/forum/index.php?showtopic=7404&hl=_RefreshSystemTray()
; _RefreshSystemTray($nDelay = 1000)
;
; Removes any dead icons from the notification area.
; Parameters:
;    $nDelay - IN/OPTIONAL - The delay to wait for the notification area to expand with Windows XP's
;        "Hide Inactive Icons" feature (In milliseconds).
; Returns:
;    Sets @error on failure:
;        1 - Tray couldn't be found.
;        2 - DllCall error.
; ===================================================================
Func _RefreshSystemTray($nDelay = 1000)
	$V2M_EventDisplay = V2M_EventLog("FUNC - _RefreshSystemTray()", $V2M_EventDisplay, "8")
	; Save Opt settings
	Local $oldMatchMode = Opt("WinTitleMatchMode", 4)
	Local $oldChildMode = Opt("WinSearchChildren", 1)
	Local $error = 0
	Do; Pseudo loop
		Local $hWnd = WinGetHandle("classname=TrayNotifyWnd")
		If @error Then
			$error = 1
			ExitLoop
		EndIf

		Local $hControl = ControlGetHandle($hWnd, "", "Button1")

		; We're on XP and the Hide Inactive Icons button is there, so expand it
		If $hControl <> "" And ControlCommand($hWnd, "", $hControl, "IsVisible") Then
			ControlClick($hWnd, "", $hControl)
			Sleep($nDelay)
		EndIf

		Local $posStart = MouseGetPos()
		Local $posWin = WinGetPos($hWnd)

		Local $y = $posWin[1]
		While $y < $posWin[3] + $posWin[1]
			Local $x = $posWin[0]
			While $x < $posWin[2] + $posWin[0]
				DllCall("user32.dll", "int", "SetCursorPos", "int", $x, "int", $y)
				If @error Then
					$error = 2
					ExitLoop 3; Jump out of While/While/Do
				EndIf
				$x = $x + 8
			WEnd
			$y = $y + 8
		WEnd
		DllCall("user32.dll", "int", "SetCursorPos", "int", $posStart[0], "int", $posStart[1])
		; We're on XP so we need to hide the inactive icons again.
		If $hControl <> "" And ControlCommand($hWnd, "", $hControl, "IsVisible") Then
			ControlClick($hWnd, "", $hControl)
		EndIf
	Until 1

	; Restore Opt settings
	Opt("WinTitleMatchMode", $oldMatchMode)
	Opt("WinSearchChildren", $oldChildMode)
	SetError($error)
EndFunc   ;==>_RefreshSystemTray

;for future use ....


;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            JohnMC
; Note(s):
;===============================================================================
Func _aptlist($APPGETURL, $path, $GETAPPDESC, ByRef $command_data)
	$V2M_EventDisplay = V2M_EventLog("FUNC - _aptlist()", $V2M_EventDisplay, "8")
	Local $nMsg, $selected, $Desc, $App, $PREFIX = "aptget_", $SUFFIX = ".zip", $DESCSUFFIX = ".txt", $RETURN_FIX = 0, $PATH_DIR = $path, $PATH_FILE = "aptget_list.txt", $PATH_FULL = $PATH_DIR & "\" & $PATH_FILE
	DirCreate($PATH_DIR)
	;       _cfl("Checking " & $APPGETURL)
	;	Local $Size = InetGetSize($APPGETURL)
	If @error Then
		;               _cfl("Cant Connect")
		Return 0
	EndIf
	;       _cfl("Getting Source Of " & $APPGETURL)
	InetGet($APPGETURL, $PATH_FULL, 1, 0)
	If @error Then
		;               _cfl("Cant Download Source")
		Return 0
	EndIf
	;       _cfl("Reading File")
	Local $File_data = FileRead($PATH_FULL)
	If @error Then
		;               _cfl("Cant Read File")
		Return 0
	EndIf
	Opt("GUIResizeMode", 1024)
	Local $Form1 = GUICreate("APTGet Lister", 394, 283, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
	Local $List1 = GUICtrlCreateListView("Application|Description", 0, 0, 393, 258, BitOR(0x0008, 0x0004, 0x0080), BitOR(0x00000001, 0x00000020))
	GUICtrlSendMsg(-1, 0x101E, 1, 275)
	GUICtrlCreateLabel("Parameters:", 1, 265, 55, 21)
	Local $Input1 = GUICtrlCreateInput("", 60, 260, 75, 21, 0)
	Local $Button1 = GUICtrlCreateButton("Select", 140, 258, 75, 25, BitOR(0x0001, 0x08000000))
	Local $Button2 = GUICtrlCreateButton("Cancel", 218, 258, 75, 25, 0x08000000)
	GUISetState(@SW_SHOW)
	;       _cfl("Finding Links And Getting Descriptions")
	$File_data = StringReplace(StringReplace($File_data, @LF, " "), @CR, " ")
	While StringInStr($File_data, "<A HREF=""")
		$File_data = StringTrimLeft($File_data, StringInStr($File_data, "<A HREF=""") + 8)
		$App = StringReplace(StringLeft($File_data, StringInStr($File_data, """>") - 1), "%20", " ")
		If StringInStr($App, "/") = 0 Then
			If StringInStr($App, $PREFIX) > 0 Then
				$App = StringTrimLeft($App, StringLen($PREFIX))
				If StringInStr($App, $SUFFIX) > 0 Then
					$App = StringTrimRight($App, StringLen($SUFFIX))
					If $GETAPPDESC = 1 Then
						$Desc = _RSC_INetGetSource($APPGETURL & "/" & $PREFIX & $App & $DESCSUFFIX)
						If StringInStr($Desc, "404 Not Found") Then $Desc = ""
					Else
						$Desc = ""
					EndIf
					GUICtrlCreateListViewItem($App & "|" & $Desc, $List1)
				EndIf
			EndIf
		EndIf
	WEnd
	GUICtrlSetState($Button1, 64)
	GUICtrlSetState($Button2, 64)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case -3, $Button2
				GUIDelete($Form1)
				Return 0
			Case $Button1
				GUISetState(@SW_HIDE)
				$selected = StringSplit(GUICtrlRead(GUICtrlRead($List1)), "|")
				If $RETURN_FIX = 1 Then $selected = $PREFIX & $selected[1] & $SUFFIX
				If GUICtrlRead($Input1) <> "" Then
					;                                       _cfl("Set Data: " & GUICtrlRead($Input1))
					$command_data = GUICtrlRead($Input1)
				EndIf
				GUIDelete($Form1)
				Return $selected[1]
		EndSwitch
	WEnd
EndFunc   ;==>_aptlist


;;===============================================================================
;; Description:
;; Parameter(s):
;; Requirement(s):
;; Return Value(s):
;; Author(s):            JohnMC
;; Note(s):
;;===============================================================================
;Func _aptget($APPGETURL, $App, $PARAMS = "", $EXEC = 1, $EXIT = 0, $path = @TempDir)
;	$V2M_EventDisplay = V2M_EventLog("FUNC - _aptget()", $V2M_EventDisplay, "8")
;	Local $PATH_DIR = $path & "\aptget_" & $App
;	Local $PATH_FILE = "aptget_" & $App & ".zip"
;	Local $PATH_FULL = $PATH_DIR & "\" & $PATH_FILE
;	Local $PATH_AU3 = $PATH_DIR & "\default.au3"
;	Local $URL = $APPGETURL & "/" & $PATH_FILE
;	Local $Form1 = GUICreate("APTGet Download Progress", 264, 45, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
;	Local $Button1 = GUICtrlCreateButton("Cancel", 212, 19, 50, 25)
;	Local $Progress1 = GUICtrlCreateProgress(0, 23, 210, 17)
;	Local $Label1 = GUICtrlCreateLabel("Downloading: " & $App, 1, 2, 260, 17)
;	GUISetState(@SW_SHOW)
;	;       _cfl("Checking " & $APPGETURL)
;	Local $Size = InetGetSize($APPGETURL)
;	If @error Then
;		;               _cfl("Cant Connect To Repository")
;		GUIDelete($Form1)
;		Return -21
;	EndIf
;	;       _cfl("Getting Size Of " & $URL)
;	Local $Size = InetGetSize($URL)
;	If @error Then
;		;               _cfl("Package Doesnt Exist")
;		GUIDelete($Form1)
;		Return -2
;	EndIf
;	If FileExists($PATH_DIR) Then
;		;               _cfl("Deleting Existing APP Folder: " & $PATH_DIR)
;		If DirRemove($PATH_DIR, 1) = 0 Then
;			;                       _cfl("Nothing Could Be Deleted, Proccess Running?")
;			GUIDelete($Form1)
;			Return -92
;		EndIf
;	EndIf
;	;       _cfl("Creating APP Folder")
;	If DirCreate($PATH_DIR) = 0 Then
;		;               _cfl("Couldnt Create App Directory")
;		GUIDelete($Form1)
;		Return -9
;	EndIf
;	;       _cfl("Downloading (" & $Size & ")")
;	InetGet($URL, $PATH_FULL, 1, 1)
;	If @error Then
;		;               _cfl("Download Error 1")
;		GUIDelete($Form1)
;		Return -7
;	EndIf
;	While 1
;		Local $Read = @InetGetBytesRead
;		GUICtrlSetData($Progress1, Int($Read / $Size * 100))
;		If GUIGetMsg() = $Button1 Then
;			_cfl("Canceled")
;			GUIDelete($Form1)
;			Return 0
;		EndIf
;		If @InetGetBytesRead = -1 Then
;			_cfl("Download Error 2")
;			GUIDelete($Form1)
;			Return -1
;		EndIf
;		If $Read = $Size Then ExitLoop
;		Sleep(10)
;	WEnd
;	If FileExists($PATH_FULL) = 0 Then
;		;               _cfl("ZIP Doesnt Exist")
;		GUIDelete($Form1)
;		Return -8
;	EndIf
;	;       _cfl("Extracting")
;;	_Zip_UnzipAll($PATH_FULL, $PATH_DIR & "\", 0)
;	If @error Then
;		;               _cfl("Unzip Error")
;		GUIDelete($Form1)
;		Return -3
;	EndIf
;	If FileExists($PATH_AU3) = 0 Then
;		;               _cfl("AU3 File Doesnt Exist")
;		GUIDelete($Form1)
;		Return -4
;	EndIf
;	If $EXEC = 1 Then
;		;               _cfl("Executing Default.au3")
;		GUIDelete($Form1)
;		If Run(@AutoItExe & " /AutoIt3ExecuteScript """ & $PATH_AU3 & """ " & $PARAMS) = 0 Then
;			;                       _cfl("Execute Error " & @error)
;			Return -61
;		EndIf
;	EndIf
;	;       _cfl("Success")
;	GUIDelete($Form1)
;	If $EXIT = 1 Then Exit
;	Return 1
;EndFunc   ;==>_aptget
;

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            JohnMC
; Note(s):
;===============================================================================
Func _cfl($text, $nnl = 0)
	$V2M_EventDisplay = V2M_EventLog("FUNC - _cfl()", $V2M_EventDisplay, "8")
	Local $line
	If $nnl = 1 Then
		$line = $text
	Else
		$line = @CRLF & @HOUR & ":" & @MIN & ":" & @SEC & "> " & $text
	EndIf
	ConsoleWrite($line)
	If Eval("DEBUGLOG") = 1 Or StringInStr($CmdLineRaw, "-debug") Then FileWrite(@ScriptFullPath & "_LOG.txt", $line)
	If $text == "OPEN" Then ShellExecute(@ScriptFullPath & "_LOG.txt")
	Return $text
EndFunc   ;==>_cfl


;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):
; Note(s):
;===============================================================================
Func _RSC_INetGetSource($s_URL, $s_Header = '')
	$V2M_EventDisplay = V2M_EventLog("FUNC - _RSC_INetGetSource()", $V2M_EventDisplay, "8")
	If StringLeft($s_URL, 7) <> 'http://' And StringLeft($s_URL, 8) <> 'https://' Then $s_URL = 'http://' & $s_URL
	Local $h_DLL = DllOpen("wininet.dll")
	Local $ai_IRF, $s_Buf = ''
	Local $ai_IO = DllCall($h_DLL, 'int', 'InternetOpen', 'str', "AutoIt v3", 'int', 0, 'int', 0, 'int', 0, 'int', 0)
	If @error Or $ai_IO[0] = 0 Then
		DllClose($h_DLL)
		SetError(1)
		Return ""
	EndIf
	Local $ai_IOU = DllCall($h_DLL, 'int', 'InternetOpenUrl', 'int', $ai_IO[0], 'str', $s_URL, 'str', $s_Header, 'int', StringLen($s_Header), 'int', 0x80000000, 'int', 0)
	If @error Or $ai_IOU[0] = 0 Then
		DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IO[0])
		DllClose($h_DLL)
		SetError(1)
		Return ""
	EndIf
	Local $v_Struct = DllStructCreate('udword')
	DllStructSetData($v_Struct, 1, 1)
	While DllStructGetData($v_Struct, 1) <> 0
		$ai_IRF = DllCall($h_DLL, 'int', 'InternetReadFile', 'int', $ai_IOU[0], 'str', '', 'int', 256, 'ptr', DllStructGetPtr($v_Struct))
		$s_Buf &= StringLeft($ai_IRF[2], DllStructGetData($v_Struct, 1))
	WEnd
	DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IOU[0])
	DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IO[0])
	DllClose($h_DLL)
	Return $s_Buf
EndFunc   ;==>_RSC_INetGetSource




;$sServiceToCheck = "ALG"
;MsgBox(0, $sServiceToCheck, _GetServiceState($sServiceToCheck))


;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):
; Note(s):
;===============================================================================
Func _GetServiceState($sServiceName)
	$V2M_EventDisplay = V2M_EventLog("FUNC - _GetServiceState(" & $sServiceName & ")", $V2M_EventDisplay, "8")
	Local $aTemp, $a_services
	$a_services = _RetrieveServices(@ComputerName)
	If Not @error And IsArray($a_services) Then
		For $x = 1 To $a_services[0]
			$aTemp = StringSplit($a_services[$x], "|")
			If $aTemp[1] = $sServiceName Then
				Return $aTemp[2]
			EndIf
		Next
		Return "Service not found"
	EndIf
EndFunc   ;==>_GetServiceState

;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):
; Note(s):
;===============================================================================
Func _RetrieveServices($s_Machine)
	$V2M_EventDisplay = V2M_EventLog("FUNC - _RetrieveServices(" & $s_Machine & ")", $V2M_EventDisplay, "8")
	Local Const $wbemFlagReturnImmediately = 0x10
	Local Const $wbemFlagForwardOnly = 0x20
	Local $colItems = "", $objItem, $services
	Local $objWMIService = ObjGet("winmgmts:\\" & $s_Machine & "\root\CIMV2")
	If @error Then
		MsgBox(16, "_RetrieveServices", "ObjGet Error: winmgmts")
		Return
	EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Service", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		MsgBox(16, "_RetrieveServices", "ExecQuery Error: SELECT * FROM Win32_Service")
		Return
	EndIf
	If IsObj($colItems) Then
		For $objItem In $colItems
			If IsArray($services) Then
				ReDim $services[UBound($services) + 1]
			Else
				Dim $services[2]
			EndIf
			$services[0] = UBound($services) - 1
;~             $services[UBound($services) - 1] = $objItem.Name
			$services[UBound($services) - 1] = $objItem.Name & "|" & $objItem.State
		Next
		Return $services
	EndIf
EndFunc   ;==>_RetrieveServices


ConsoleWrite(_ServiceCurrentState(@ComputerName, "spooler") & @LF)

Func _ServiceCurrentState($sComputerName, $sServiceName)
	Local $hAdvapi32
	Local $hSCM
	Local $hService
	Local $bDllRet, $cDllRet
	Local $SERVICE_STATUS, $SERVICE_QUERY_STATUS
	Local $nState = 0

	$sComputerName = $sComputerName
	$bDllRet = DllCall($hAdvapi32, "long", "OpenService", _
			"long", $hSCM, _
			"str", $sServiceName, _
			"long", $SERVICE_QUERY_STATUS)
	If IsArray($bDllRet) Then
		If $bDllRet[0] <> 0 Then
			$hService = $bDllRet[0]
			ConsoleWrite("hService=" & $hService & @LF)
			$SERVICE_STATUS = DllStructCreate("dword;dword;dword;dword;dword;dword;dword")
			If Not @error Then
				$cDllRet = DllCall($hAdvapi32, "int", "QueryServiceStatus", _
						"long", $hService, _
						"ptr", DllStructGetPtr($SERVICE_STATUS))
				If Not @error And $cDllRet[0] > 0 Then $nState = DllStructGetData($SERVICE_STATUS, 2)
				;				DllStructDelete($SERVICE_STATUS)
			EndIf
			DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hService)
		EndIf
	EndIf
	DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hSCM)
	Return $nState
EndFunc   ;==>_ServiceCurrentState

Func _ListAllServices($sComputerName = @ComputerName)
	Local $hAdvapi32
	Local $hSCM
	;	Local $hService
	Local $aDllRet, $SC_MANAGER_CONNECT

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$aDllRet = DllCall($hAdvapi32, "long", "OpenSCManager", _
			"str", $sComputerName, _
			"str", "ServicesActive", _
			"long", $SC_MANAGER_CONNECT)
	If $aDllRet[0] <> 0 Then
		$hSCM = $aDllRet[0]
		ConsoleWrite("hSCM=" & $hSCM & @LF)
	EndIf
	DllClose($hAdvapi32)
	Return $aDllRet
EndFunc   ;==>_ListAllServices

;===============================================================================
; Description:		Checks if Mirror Driver is installed
; Parameter(s):		NULL
; Requirement(s):	NULL
; Return Value(s):	1 if driver found, else 0
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Func UVNC_FindMirrorDriverInstalled()
	$V2M_EventDisplay = V2M_EventLog("FUNC - UVNC_FindMirrorDriverInstalled()", $V2M_EventDisplay, "8")
	Local $aDevice, $i = 0, $LocalReturn
	While 1
		$aDevice = _WinAPI_EnumDisplayDevices("", $i)
		If Not $aDevice[0] Then
			;			ConsoleWrite("$aDevice[0] = " & $aDevice[0] & @CRLF)
			$LocalReturn = 0
			ExitLoop
		ElseIf Not $aDevice[1] Then
			;			ConsoleWrite("$aDevice[1] = " & $aDevice[1] & @CRLF)
			$LocalReturn = 0
			ExitLoop
		ElseIf StringInStr($aDevice[2], "mv video hook driver2") Then
			$V2M_EventDisplay = V2M_EventLog("UVNC - Mirror Driver Found", $V2M_EventDisplay, "8")
			;			ConsoleWrite("Mirror Driver Found ..." & @CRLF)
			;			MsgBox(0,"Found", "The Mirror Driver has been found ...", 5)
			$LocalReturn = 1
			ExitLoop
		EndIf
		;		ConsoleWrite("$i = " & $i & @CRLF & "$aDevice[3] = " & $aDevice[3] & @CRLF)
		$i += 1
	WEnd
	Return ($LocalReturn)
EndFunc   ;==>UVNC_FindMirrorDriverInstalled

;===============================================================================
; Description:		Uses Windows API to extract Files, no external DLL or EXE required
; Parameter(s):		$sZip = location & name of Zip to be extracted, $sDest = Destination to extract Zip to
; Requirement(s):	Windows XP or above, <winapi.au3>
; Return Value(s):	see comments for errors returned
; Author(s):		??? (found on autoit forums)
; Note(s):			only works if winzip or similar is not installed ...
;===============================================================================
Func _UnZip($sZip, $sDest)
	Local $oDest
	; if autoit version doesn't support this method, return error 1
	If Not StringLen(Chr(0)) Then Return SetError(1)
	; if zip file doesn't exist, return error 2
	If Not FileExists($sZip) Then Return SetError(2)
	Local $oShell = ObjCreate('Shell.Application')
	; if com object cannot be created, return error 3
	If @error Or Not IsObj($oShell) Then Return SetError(3)
	Local $oFolder = $oShell.NameSpace($sZip)
	;	Local $oDest.$oShell.Namespace(@TempDir)
	; if com object doesn't exist, return error 4
	If @error Or Not IsObj($oFolder) Then Return SetError(4)
	Local $oItems = $oFolder.Items()
	; if com object doesn't exist, return error 5
	If @error Or Not IsObj($oItems) Then Return SetError(5)
	If Not FileExists($sDest) Then
		; if directory cannot be created, return error 7
		If DirCreate($sDest) <> 1 Then Return SetError(7)
	EndIf
	$oDest = $oShell.NameSpace($sDest)
	; if com object doesn't exist, return error 6
	If @error Or Not IsObj($oDest) Then Return SetError(6)
	$oDest.CopyHere($oItems)
EndFunc   ;==>_UnZip


;===============================================================================
; Description:		Downloads and extracts mirror drivers zip
; Parameter(s):		NULL
; Requirement(s):	NULL
; Return Value(s):	NULL
; Author(s):		YTS_Jim
; Note(s):			Is not translated yet ... only in beta stages
;===============================================================================
Func UVNC_DownloadExtractMirrorDrivers($UVNC_Drivers_URL = "http://sc.uvnc.com/drivers.zip", $UVNC_Drivers_Filename = "drivers.zip")
	Local $Local_UnZip = 0, $Local_InetGet
	If Not FileExists(@ScriptDir & "\" & $UVNC_Drivers_Filename) Then
		SplashTextOn("YTS: Downloading Drivers", "Please wait... This may take a few moments.", "400", "100", -1, -1)
		$Local_InetGet = InetGet($UVNC_Drivers_URL, @TempDir & "\" & $UVNC_Drivers_Filename)
		InetGetInfo($Local_InetGet, 0)
		InetClose($Local_InetGet) ; Close the handle to release resourcs.
		;_Download("http://sc.uvnc.com/drivers.zip")
	Else
		FileCopy(@ScriptDir & "\" & $UVNC_Drivers_Filename, @TempDir & "\" & $UVNC_Drivers_Filename)
	EndIf

	$Local_UnZip = _UnZip(@TempDir & "\" & $UVNC_Drivers_Filename, @TempDir & "\uvnc")
	;MsgBox(0,"debug", "@OSArch = " & @OSArch & @CRLF & "@OSBuild = " & @OSBuild & @CRLF & "@OSType = " & @OSType & @CRLF & "@OSVersion = " & @OSVersion)
	SplashOff()
	If $Local_UnZip <> 0 Then
		Run(@ComSpec & " /c " & @TempDir & "\" & $UVNC_Drivers_Filename, @ScriptDir, @SW_MINIMIZE)
	Else
		Run(@WindowsDir & "\explorer.exe " & @TempDir & "\uvnc\driver")
	EndIf
EndFunc   ;==>UVNC_DownloadExtractMirrorDrivers

;===============================================================================
; Description:		Checks if the user is a member of the administrators group on the given computer
; Parameter(s):		$sUser =		the username of the user to check (Blank = @UserName)
;					$sCompName =	the computer name of the computer to check on (Blank = ".")
; Requirement(s):	NULL
; Return Value(s):	NULL
; Author(s):		trancexx
; Note(s):			https://www.autoitscript.com/forum/topic/113611-if-isadmin-not-detected-as-admin/?do=findComment&comment=794771
;===============================================================================
Func _IsAdministrator_old($sUser = @UserName, $sCompName = ".")
	Local $aCall = DllCall("netapi32.dll", "long", "NetUserGetInfo", "wstr", $sCompName, "wstr", $sUser, "dword", 1, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, False)
	Local $fPrivAdmin = DllStructGetData(DllStructCreate("ptr;ptr;dword;dword;ptr;ptr;dword;ptr", $aCall[4]), 4) = 2
	DllCall("netapi32.dll", "long", "NetApiBufferFree", "ptr", $aCall[4])
	Return $fPrivAdmin
EndFunc   ;==>_IsAdministrator

;===============================================================================
; Description:		Checks if the user is a member of the administrators group on the given computer
; Parameter(s):		$sUser =		the username of the user to check (Blank = @UserName)
;					$sCompName =	the computer name of the computer to check on (Blank = ".")
; Requirement(s):	NULL
; Return Value(s):	NULL
; Author(s):		zorphnog
; Note(s):			https://www.autoitscript.com/forum/topic/113611-if-isadmin-not-detected-as-admin/?do=findComment&comment=794920
;===============================================================================
Func _IsAdministrator($sUser = @UserName, $sCompName = ".")
    Local $aGroup, $aMember, $bAdmin = False

    $aGroup = ObjGet("WinNT://" & $sCompName & "/Administrators")
    If @error Then Return SetError(1, 0, -1)

    For $aMember In $aGroup.Members
        If $aMember.Name = $sUser Then
            $bAdmin = True
            ExitLoop
        EndIf
    Next
    $aGroup = 0
    Return $bAdmin
EndFunc

Global $YTS_WD_BGImage, $YTS_WD_dc, $YTS_WD_obj_orig, $YTS_WD_pen, $YTS_WD_Colour, $YTS_WD_Mouse_pos, $YTS_WD_Mouse_X, $YTS_WD_Mouse_X_Old, $YTS_WD_Mouse_Y
Global $YTS_WD_Mouse_Y_Old, $YTS_WD_radius, $WB_pngSrc
Func Start_Whiteboard($BoardName = "VNC2Me")
	Local $sCountDown = 15, $return

	; Load PNG file as GDI bitmap
	_GDIPlus_Startup()
	If $WB_pngSrc = "" Then
		$WB_pngSrc = @ScriptDir & "\Skin_WhiteBoard.png"
	EndIf
	$YTS_WD_BGImage = _GDIPlus_ImageLoadFromFile($WB_pngSrc)

	; Extract image width and height from PNG
	$width = _GDIPlus_ImageGetWidth($YTS_WD_BGImage)
	$height = _GDIPlus_ImageGetHeight($YTS_WD_BGImage)

	; Create layered window
	$GUI = GUICreate($BoardName, $width, $height, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
	SetBitmap($GUI, $YTS_WD_BGImage, 50)
	GUISetState()
	WinSetOnTop($GUI, "", 1)

	$TimeStampLoop[1] = _NowCalc()
	Global $YTS_Exit = 0
	While $YTS_Exit = 0
		;		Global $hnd = _WinAPI_GetDesktopWindow()
		If _IsPressed(1) Then
			While _IsPressed(1)
				;				Local $firstPos = MouseGetPos()
				draw_dot()
				;				DrawBox($firstPos[0],$firstPos[1],$firstPos[0]+1,$firstPos[1]+1)
			WEnd
		EndIf
		;               $msg = GUIGetMsg()
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				$return = 0
				ExitLoop
		EndSwitch
		If _DateDiff('s', $TimeStampLoop[1], _NowCalc()) >= 1 Then
			$TimeStampLoop[1] = _NowCalc()
			$sCountDown = $sCountDown - 1
			;			If $sCountDown < 0 Then
			;				$return = 1
			;				ExitLoop
			;			EndIf
		EndIf
	WEnd

	; Release resources
	GUIDelete($GUI)
	Return $return
	; clear resources
	_WinAPI_SelectObject($YTS_WD_dc, $YTS_WD_obj_orig)
	_WinAPI_DeleteObject($YTS_WD_pen)
	_WinAPI_DeleteObject($YTS_WD_BGImage)
	_WinAPI_ReleaseDC(0, $YTS_WD_dc)
	_GDIPlus_Shutdown()
	; refresh desktop (clear cross)
	_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)

EndFunc   ;==>Start_Whiteboard

;===============================================================================
; Description:		Draws a line between two points
; Parameter(s):		NILL
; Requirement(s):	NILL
; Return Value(s):	NILL
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Func draw_dot()

	If $YTS_WD_Mouse_X = "" Or $YTS_WD_Mouse_Y = "" Then
		$YTS_WD_Mouse_pos = MouseGetPos()
		$YTS_WD_Mouse_X = $YTS_WD_Mouse_pos[0]
		$YTS_WD_Mouse_Y = $YTS_WD_Mouse_pos[1]
		Return
	EndIf
	$YTS_WD_Mouse_X_Old = $YTS_WD_Mouse_X
	$YTS_WD_Mouse_Y_Old = $YTS_WD_Mouse_Y
	$YTS_WD_Mouse_pos = MouseGetPos()
	$YTS_WD_Mouse_X = $YTS_WD_Mouse_pos[0]
	$YTS_WD_Mouse_Y = $YTS_WD_Mouse_pos[1]
	MouseUp("Left")
	;	$YTS_WD_dc = DllCall("user32.dll", "int", "GetDC", "hwnd", "")
	$YTS_WD_dc = _WinAPI_GetWindowDC(0) ; DC of entire screen (desktop)
	$YTS_WD_pen = _WinAPI_CreatePen($PS_SOLID, $YTS_WD_radius, $YTS_WD_Colour)
	;	DllCall("gdi32.dll", "int", "SelectObject", "int", $YTS_WD_dc[0], "int", $YTS_WD_pen[0])
	$YTS_WD_obj_orig = _WinAPI_SelectObject($YTS_WD_dc, $YTS_WD_pen)
	;	DllCall("GDI32.dll", "int", "MoveToEx", "hwnd", $YTS_WD_dc[0], "int", $YTS_WD_Mouse_X_Old, "int", $YTS_WD_Mouse_Y_Old, "int", 0)
	_WinAPI_MoveTo($YTS_WD_dc, $YTS_WD_Mouse_X_Old, $YTS_WD_Mouse_Y_Old)
	;	DllCall("GDI32.dll", "int", "LineTo", "hwnd", $YTS_WD_dc[0], "int", $YTS_WD_Mouse_X, "int", $YTS_WD_Mouse_Y)
	_WinAPI_LineTo($YTS_WD_dc, $YTS_WD_Mouse_X, $YTS_WD_Mouse_Y)
	;	DllCall("user32.dll", "int", "ReleaseDC", "hwnd", 0, "int", $YTS_WD_dc[0])
	_WinAPI_ReleaseDC(0, $YTS_WD_dc)
EndFunc   ;==>draw_dot


;===============================================================================
; Description:		Creates a GUI giving options for starting the Beacon GUI.
; Parameter(s):		NILL
; Requirement(s):	NILL
; Return Value(s):	NILL
; Author(s):		YTS_Jim
; Note(s):
;===============================================================================
Global $YTS_BS_Checkbox1, $YTS_BS_Checkbox2, $YTS_BS_Checkbox3, $YTS_BS_Label
Func Beacon_GUI()
	Local $font = "Comic Sans MS", $Beacon_Enable_Sounds, $Beacon_Enable_Messages, $Beacon_Text, $Beacon_Talk_Enable, $YTS_BS_Gui1
	$YTS_BS_Gui1 = GUICreate("", 300, 200, -1, -1, $WS_POPUP, $WS_EX_TOPMOST)
	;	GUISetBkColor(0xFF0000, $YTS_BS_Gui1)
	$YTS_BS_Checkbox1 = GUICtrlCreateCheckbox("Enable Audio", 10, 10, 130, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$YTS_BS_Checkbox2 = GUICtrlCreateCheckbox("Speek Message Below", 10, 40, 130, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$YTS_BS_Checkbox3 = GUICtrlCreateCheckbox("Display Message Below", 10, 70, 130, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$YTS_BS_Label = GUICtrlCreateEdit("Attention Required", 10, 100, 280, 50, $ES_CENTER)
	GUICtrlSetData($YTS_BS_Label, "Attention Required")
	GUICtrlSetFont($YTS_BS_Label, 14, 900)
	;		GUISetBkColor(0x00FF00, $YTS_BS_Label)
	dim $Beacon_Start_Button = GUICtrlCreateButton("Start", 10, 170, 280, 20, $BS_DEFPUSHBUTTON)
	GUICtrlSetFont($Beacon_Start_Button, 10, 800, "", $font)
	GUISetState(@SW_SHOW, $YTS_BS_Gui1)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $Beacon_Start_Button
				If GUICtrlRead($YTS_BS_Checkbox1) = 1 Then
					$Beacon_Enable_Sounds = 1
					If GUICtrlRead($YTS_BS_Checkbox2) = 1 Then
						$Beacon_Talk_Enable = 1
					Else
						$Beacon_Talk_Enable = 0
					EndIf
				Else
					$Beacon_Enable_Sounds = 0
				EndIf
				If GUICtrlRead($YTS_BS_Checkbox3) = 1 Then
					$Beacon_Enable_Messages = 1
					$Beacon_Text = GUICtrlRead($YTS_BS_Label)
				Else
					$Beacon_Enable_Messages = 0
				EndIf
				;				Beacon_Start(1, 1, "SC Prompt 2011", 1, 10, 1, "Exit")
				Beacon_Start($Beacon_Enable_Sounds, $Beacon_Enable_Messages, $Beacon_Text, $Beacon_Talk_Enable, 10, 1, "Exit")
				ExitLoop
			Case $YTS_BS_Checkbox1 ; enable audio
				If GUICtrlRead($YTS_BS_Checkbox1) = 1 Then
					GUICtrlSetState($YTS_BS_Label, $GUI_ENABLE)
					GUICtrlSetState($YTS_BS_Checkbox2, $GUI_ENABLE)
				Else
					If GUICtrlRead($YTS_BS_Checkbox3) = 4 Then
						GUICtrlSetState($YTS_BS_Label, $GUI_DISABLE)
					EndIf
					GUICtrlSetState($YTS_BS_Checkbox2, $GUI_DISABLE)
				EndIf
			Case $YTS_BS_Checkbox2 ; enable speech
				If GUICtrlRead($YTS_BS_Checkbox2) = 1 Then
					GUICtrlSetState($YTS_BS_Label, $GUI_ENABLE)
				Else
					GUICtrlSetState($YTS_BS_Label, $GUI_DISABLE)
				EndIf
			Case $YTS_BS_Checkbox3 ; enable Display
				If GUICtrlRead($YTS_BS_Checkbox3) = 1 Then
					GUICtrlSetState($YTS_BS_Label, $GUI_ENABLE)
				Else
					If GUICtrlRead($YTS_BS_Checkbox1) = 4 Then
						GUICtrlSetState($YTS_BS_Label, $GUI_DISABLE)
					EndIf
				EndIf
		EndSwitch
	WEnd
	;	Sleep(10000)
	GUIDelete($YTS_BS_Gui1)
EndFunc   ;==>Beacon_GUI

;===============================================================================
; Description:			Displays a Fullscreen GUI with a stop button and edit control (with $Beacon_Text inside)
;							This GUI Changes from red to green every $Beacon_Flash_WaitTime seconds (Default=1)
;							The Function then speaks the $Beacon_Text (if enabled)
; Parameter(s):			$Beacon_Enable_Sounds		(1 = sounds enabled, 0 = no sounds
;						$Beacon_Enable_Messages		(1 = show the message in the edit control, 0 = no message displayed
;						$Beacon_Text				(what text you want to display and speak)
;						$Beacon_Talk_Enable			(1 = speak the text above, 0 = beep the PC speakers)
;						$Beacon_Talk_WaitTime		(number seconds to wait to speak or beep - behaves best if number is even)
;						$Beacon_Flash_WaitTime		(number seconds to wait to change flashing colour)
;						$Beacon_Button_Text			(text to display on the exit button)
; Requirement(s):		<WindowsConstants.au3>, <Date.au3>, <GUIConstantsEx.au3>, <EditConstants.au3>, <ButtonConstants.au3>
; Return Value(s):		NULL
; Author(s):            YTS_Jim (securetech.com.au)
; Note(s):				Found the original code somewhere in the autoit forum ... not sure where, sorry ...
;===============================================================================
Func Beacon_Start($Beacon_Enable_Sounds = 1, $Beacon_Enable_Messages = 1, $Beacon_Text = "Attention Required", $Beacon_Talk_Enable = 1, $Beacon_Talk_WaitTime = 10, $Beacon_Flash_WaitTime = 1, $Beacon_Button_Text = "Exit")
	Local $SplashScreen = 0, $Beacon_Exit = 0, $TimeStampLoop[3], $font = "Comic Sans MS"
	Local $Beacon_GUI_Width = @DesktopWidth, $Beacon_GUI_Height = @DesktopHeight
	Local $Beacon_GUI_Edit_Width = 300, $Beacon_GUI_Edit_Height = 100, $Beacon_GUI_Button_Height = 30, $YTS_BS_Gui2, $Beacon_Exit_Button, $getpos
	$TimeStampLoop[1] = _NowCalc()
	$TimeStampLoop[2] = _NowCalc()
	$YTS_BS_Gui2 = GUICreate("", $Beacon_GUI_Width, $Beacon_GUI_Height, 0, 0, $WS_POPUP, $WS_EX_TOPMOST)
	GUISetBkColor(0xFF0000, $YTS_BS_Gui2)
	If $Beacon_Enable_Messages = 1 Then
		$YTS_BS_Label = GUICtrlCreateEdit("", ($Beacon_GUI_Width / 2) - ($Beacon_GUI_Edit_Width / 2), ($Beacon_GUI_Height / 2) - ($Beacon_GUI_Edit_Height + 5), $Beacon_GUI_Edit_Width, $Beacon_GUI_Edit_Height, 0x0804 + $ES_CENTER)
		GUICtrlSetData($YTS_BS_Label, $Beacon_Text)
		GUICtrlSetFont($YTS_BS_Label, 14, 900, "", $font)
		;		GUISetBkColor(0x00FF00, $YTS_BS_Label)
	EndIf
	$Beacon_Exit_Button = GUICtrlCreateButton($Beacon_Button_Text, ($Beacon_GUI_Width / 2) - ($Beacon_GUI_Edit_Width / 2), ($Beacon_GUI_Height / 2), $Beacon_GUI_Edit_Width, $Beacon_GUI_Button_Height, $BS_DEFPUSHBUTTON)
	GUICtrlSetFont($Beacon_Exit_Button, 10, 800, "", $font)
	GUISetState(@SW_SHOW, $YTS_BS_Gui2)
	While $Beacon_Exit = 0
		;		do the following every cycle (imediate action)
		If _DateDiff('s', $TimeStampLoop[2], _NowCalc()) >= 1 Then
			;       Loop through the following every 1 second (allows for things that DONT need imediate actions to not chew the CPU.
			$TimeStampLoop[2] = _NowCalc()
			; make sure screen saver doesn't kick in ...
			$getpos = MouseGetPos()
			MouseMove($getpos[0] + 1, $getpos[1], 0)
			Sleep(100)
			MouseMove($getpos[0] - 1, $getpos[1], 0)
			; Change Background Colour
			;			GUISetBkColor(0xFF0000, $YTS_BS_Gui2)
			; if sounds are enabled
			If $Beacon_Enable_Sounds = 1 Then
				;if voice is enabled
				If $Beacon_Talk_Enable = 1 Then
					_Talk($Beacon_Text)
					;					$voice.Rate = 1
					;					$voice.Volume = 100
					;					$voice.Speak($Beacon_Text)
				Else
					Beep(500, 50)
					Beep(1000, 50)
					Beep(2000, 50)
				EndIf
				; add X seconds from the last time we entered loop
			EndIf
			$TimeStampLoop[2] = _DateAdd('s', $Beacon_Talk_WaitTime, $TimeStampLoop[2])
			$TimeStampLoop[1] = _NowCalc()
		ElseIf _DateDiff('s', $TimeStampLoop[1], _NowCalc()) >= $Beacon_Flash_WaitTime Then
			; Loop through the following every X seconds
			; make sure screen saver doesn't kick in ...
			If $SplashScreen = 0 Then
				$SplashScreen = 1
				GUISetBkColor(0xFF0000, $YTS_BS_Gui2)
			Else
				$SplashScreen = 0
				GUISetBkColor(0x00FF00, $YTS_BS_Gui2)
			EndIf
			$TimeStampLoop[1] = _NowCalc()
		Else
			Sleep(100)
		EndIf
		Switch GUIGetMsg()
			Case $Beacon_Exit_Button
				$Beacon_Exit = 1
			Case $GUI_EVENT_CLOSE
				$Beacon_Exit = 1
			Case Else

		EndSwitch
	WEnd
	;	SplashOff()
	GUIDelete($YTS_BS_Gui2)
EndFunc   ;==>Beacon_Start

Global $voice = ObjCreate("Sapi.SpVoice")
Func _Talk($text, $Rate = 1, $Vol = 100)
	$voice.Rate = $Rate
	$voice.Volume = $Vol
	$voice.Speak($text)
EndFunc   ;==>_Talk


; #FUNCTION# ====================================================================================================================
; Name...........:		_RSC_INIReadSection_key()
; Description ...:		Checks if a key exists in the given  first parameter (which is the output from IniReadSection() )
; Syntax.........:		_RSC_INIReadSection($IniReadSection, $Key)
; Parameters ....:		$IniReadSection	=	the output from IniReadSection()
;						$Key			=	the key to find in the above Array
; Return values .:		The Value associated with $Key
; Author ........:		YTS_Jim
; ===============================================================================================================================
Func _RSC_INIReadSection_key($IniReadSection, $Key, $Text_if_not_found = "")
	$V2M_EventDisplay = V2M_EventLog("FUNC - _RSC_INIReadSection_Key($IniReadSection[x][y], '" & $Key & "', '" & $Text_if_not_found & "')", $V2M_EventDisplay, "8")
	Local $Local_Value = "", $i = 1, $exit = 0
	If IsArray($IniReadSection) Then
		$V2M_EventDisplay = V2M_EventLog("_RSC_INIReadSection_Key - Total Keys in this Section = " & $IniReadSection[0][0], $V2M_EventDisplay, "9")
		;		ConsoleWrite("Total Keys in this Section = " & $IniReadSection[0][0] & @CRLF)
		Do
			;			ConsoleWrite("$i = " & $i & @CRLF)
			If $IniReadSection[$i][0] = $Key Then
				$Local_Value = $IniReadSection[$i][1]
				$V2M_EventDisplay = V2M_EventLog("_RSC_INIReadSection_Key - Found $IniReadSection[" & $i & "][0] Contained '" & $Key & "'", $V2M_EventDisplay, "9")
				;				ConsoleWrite("$IniReadSection[$i][1] = " & $IniReadSection[$i][1] & @CRLF)
				;				ConsoleWrite("$Local_Value = " & $Local_Value & @CRLF)
				;			$i = $IniReadSection[0][0]
				$exit = 1
			Else
				$i = $i + 1 ; increment loop
			EndIf
		Until $i > $IniReadSection[0][0] Or $Local_Value <> "" Or $exit = 1
		If $Local_Value = "" And $i > $IniReadSection[0][0] Then
			SetError(1)
			$V2M_EventDisplay = V2M_EventLog("_RSC_INIReadSection_Key - INI Value not found, returning '" & $Text_if_not_found & "'", $V2M_EventDisplay, "8")
			Return $Text_if_not_found
		Else
			If StringLeft($Local_Value, 1) = '"' Then
				$Local_Value = StringRegExpReplace($Local_Value, '"', '')
			ElseIf StringLeft($Local_Value, 1) = "'" Then
				$Local_Value = StringRegExpReplace($Local_Value, "'", '')
			EndIf
			$V2M_EventDisplay = V2M_EventLog("_RSC_INIReadSection_Key - INI Value FOUND, returning '" & $Local_Value & "'", $V2M_EventDisplay, "9")
			Return $Local_Value
		EndIf
	Else
		$V2M_EventDisplay = V2M_EventLog("FUNC - _RSC_INIReadSection_Key(" & $IniReadSection & ", " & $Key & ") called, but first arguement is not an array as was expected.", $V2M_EventDisplay, "9")
		SetError(2)
		Return $Text_if_not_found
	EndIf
EndFunc   ;==>_RSC_INIReadSection_key


; #FUNCTION# ====================================================================================================================
; Name...........:		_RSC_INIReadSection_value()
; Description ...:		Checks if a Value exists in the given first parameter (which is the returned array from IniReadSection() )
; Syntax.........:		_RSC_INIReadSection($IniReadSection, $Value, )
; Parameters ....:		$IniReadSection	=	the returned array from IniReadSection()
;						$Value			=	the key to find in the above Array
;						$Mode			=	find the exact match ("Exact") or stringinstr()
; Return values .:		The Value associated with $Value
; Author ........:		YTS_Jim
; ===============================================================================================================================
Func _RSC_INIReadSection_Value($IniReadSection, $Value, $Mode = "Exact")
	$V2M_EventDisplay = V2M_EventLog("FUNC - _RSC_INIReadSection_Value(" & $IniReadSection & ", " & $Value & ", " & $Mode & ")", $V2M_EventDisplay, "8")
	Local $Local_Value = "", $i = 1, $exit = 0
	ConsoleWrite("Total Keys in this Section = " & $IniReadSection[0][0] & @CRLF)
	Do
		ConsoleWrite("$i = " & $i & @CRLF)
		If $Mode = "Exact" Then
			If $IniReadSection[$i][1] = $Value Then
				$Local_Value = $IniReadSection[$i][0]
				ConsoleWrite("$IniReadSection[$i][1] = " & $IniReadSection[$i][1] & @CRLF)
				ConsoleWrite("$Local_Value = " & $Local_Value & @CRLF)
				$exit = 1
			Else
				$i = $i + 1 ; increment loop
			EndIf
		Else
			If StringInStr($IniReadSection[$i][1], $Value) Then
				$Local_Value = $IniReadSection[$i][0]
				ConsoleWrite("$IniReadSection[$i][0] = " & $IniReadSection[$i][0] & @CRLF)
				ConsoleWrite("$Local_Value = " & $Local_Value & @CRLF)
				$exit = 1
			Else
				$i = $i + 1 ; increment loop
			EndIf
		EndIf
	Until $i > $IniReadSection[0][0] Or $Local_Value <> "" Or $exit = 1
	If $Local_Value = "" And $i > $IniReadSection[0][0] Then SetError(1)
	Return $Local_Value
EndFunc   ;==>_RSC_INIReadSection_Value

; #FUNCTION# ====================================================================================================================
; Name...........:		_RSC_CreateContextMenus()
; Description ...:		Creates context (right mouse click) menus for each GUI that it is called from.
; Syntax.........:		_RSC_CreateContextMenus()
; Parameters ....:		NULL
; Return values .:		NULL
; Author ........:		YTS_Jim
; ===============================================================================================================================
Func _RSC_CreateContextMenus()
	dim $CM_Menu = GUICtrlCreateContextMenu()

	dim $CM_Beacon = GUICtrlCreateMenuItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_TOOLS_BEACON", "Start Beacon"), $CM_Menu)
	dim $CM_WhiteBoard = GUICtrlCreateMenuItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_TOOLS_WHITEBOARD", "Start WhiteBoard"), $CM_Menu)
	GUICtrlCreateMenuItem("", $CM_Menu) ; separator

	If (_RSC_INIReadSection_key($INI_CommonSection, "INETUPDATE", 0) = 1 Or _RSC_INIReadSection_key($INI_CommonSection, "TESTUPDATE", 0) = 1) Then
		dim $CM_CheckUpdate = GUICtrlCreateMenuItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_TOOLS_CHECKUPDATES", "CHECK FOR UPDATES"), $CM_Menu)
	Else
		$CM_CheckUpdate = 1
	EndIf
	dim $CM_ForceExit = GUICtrlCreateMenuItem(_RSC_INIReadSection_key($INI_Translation_Section, "TRAY_MNU_TOOLS_FORCEEXIT", "FORCE UNINSTALL"), $CM_Menu)
EndFunc   ;==>_RSC_CreateContextMenus

; #FUNCTION# ====================================================================================================================
; Name...........:		_OSlangNames()
; Description ...:		Creates context (right mouse click) menus for each GUI that it is called from.
; Syntax.........:		_OSlangNames($Local_OSLangID)
; Parameters ....:		$Local_OSLangID = 	the @OSLang code or something else (default = @OSLang)
; Return values .:		The Primary Language Symbol (Language Name) associated with that lang ID
; Author ........:		YTS_Jim
; ===============================================================================================================================
Func _OSlangNames($Local_OSLangID = @OSLang)
	V2M_EventLog('FUNC - _OSlangNames($Local_OSLangID = ' & $Local_OSLangID & ')', '', "8")
	Local $i, $j, $Local_Lang_Name = "";, $OSLangNames1[200][200], $OSLangNames2[200][200]
	;	ConsoleWrite('$Local_OSLangID = ' & $Local_OSLangID)
	For $i = 0 To UBound($OSLangNames1, 1) - 1
		For $j = 0 To UBound($OSLangNames1, 2) - 1
			ConsoleWrite("$OSLangNames1[" & $i & "][" & $j & "]:=" & $OSLangNames1[$i][$j] & @LF)
		Next
		ConsoleWrite(@LF)
		If $Local_OSLangID = $OSLangNames1[$i][0] Then
			;			MsgBox(0, "Found", "@OSLang is found, and its: " & $OSLangNames1[$i][1], 10)
			$Local_Lang_Name = $OSLangNames1[$i][1]
			ExitLoop
		EndIf
	Next
	If $Local_Lang_Name = "" Then
		For $i = 0 To UBound($OSLangNames2, 1) - 1
			For $j = 0 To UBound($OSLangNames2, 2) - 1
				ConsoleWrite("$OSLangNames2[" & $i & "][" & $j & "]:=" & $OSLangNames2[$i][$j] & @LF)
			Next
			ConsoleWrite(@LF)
			If $Local_OSLangID = $OSLangNames2[$i][0] Then
				;				MsgBox(0, "Found", "@OSLang is found, and its: " & $OSLangNames2[$i][1], 10)
				$Local_Lang_Name = $OSLangNames1[$i][1]
				ExitLoop
			EndIf
		Next
	EndIf
	Return $Local_Lang_Name
EndFunc   ;==>_OSlangNames


; #FUNCTION# ====================================================================================================================
; Name...........:		_Language()
; Description ...:		Gets the OS Language from some Vars and return the name in words
; Syntax.........:		_Language()
; Parameters ....:
; Return values .:		The Primary Language Name
; Author ........:		YTS_Jim
; ===============================================================================================================================
;Global $STG_Language_File
Func _Language()
	V2M_EventLog('FUNC - _Language()', '', "8")
	; new language stuff
	; if INI contains Language then use it, otherwise figure it out!
	If _RSC_INIReadSection_key($INI_CommonSection, "LANGUAGE") = "" Then
		$V2M_GUI_Language = _OSlangNames(@OSLang)
		$V2M_EventDisplay = V2M_EventLog("LANG - Automatic Language is found to be: '" & $V2M_GUI_Language & "'", $V2M_EventDisplay, "8")
	Else
		$V2M_GUI_Language = "LANG_" & _RSC_INIReadSection_key($INI_CommonSection, "LANGUAGE")
		$V2M_EventDisplay = V2M_EventLog("LANG - Manual Language was set to be: '" & $V2M_GUI_Language & "'", $V2M_EventDisplay, "8")
	EndIf
	$V2M_EventDisplay = V2M_EventLog("LANG - $V2M_GUI_Language = '" & $V2M_GUI_Language & "'", $V2M_EventDisplay, "8")
	; if string contains " or ' at the start (as some do when read from INI, clean them out (plus the ones at the end).
	If StringLeft(_RSC_INIReadSection_key($INI_CommonSection, "LANGUAGE"), 1) = '"' Or StringLeft(_RSC_INIReadSection_key($INI_CommonSection, "LANGUAGE"), 1) = "'" Then
		$V2M_EventDisplay = V2M_EventLog("LANG - Stripping un-needed quotes from $V2M_GUI_Language", $V2M_EventDisplay, "8")
		$V2M_GUI_Language = StringRegExpReplace($V2M_GUI_Language, '"', '')
		$V2M_GUI_Language = StringRegExpReplace($V2M_GUI_Language, "'", '')
	EndIf
	; if fileexist, use it as the language file
	;	Local $Write_Translation_file = 0

	If FileExists(@ScriptDir & "\" & $V2M_GUI_Language & ".ini") Then
		$STG_Language_File = (@ScriptDir & "\" & $V2M_GUI_Language & ".ini")
		$V2M_EventDisplay = V2M_EventLog("LANG - $STG_Language_File = '" & $STG_Language_File & "'", $V2M_EventDisplay, "8")
	Else
		If StringInStr($CmdLineRaw, "-testing") Then
			$return = MsgBox(4, "Language file not found", "Your Language file " & @CRLF & "(" & @ScriptDir & "\" & $V2M_GUI_Language & ".ini" & ")" & @CRLF & "was not found," & @CRLF & "Do you want to create create it?", 10)
			If $return = 6 Then
				FileWrite(@ScriptDir & "\" & $V2M_GUI_Language & ".ini", "[" & $V2M_GUI_Language & "]")
				;			Global $Write_Translation_file = 1
			EndIf
		EndIf
		$STG_Language_File = (@ScriptDir & "\LANG_ENGLISH.ini")
		$V2M_EventDisplay = V2M_EventLog("LANG - $STG_Language_File = '" & $STG_Language_File & "'", $V2M_EventDisplay, "8")
	EndIf


	If StringLeft(StringLower($V2M_GUI_Language), 5) = 'lang_' Then
		$V2M_EventDisplay = V2M_EventLog("LANG - Stripping 'LANG_' from $V2M_GUI_Language", $V2M_EventDisplay, "8")
		$V2M_GUI_Language = StringTrimLeft($V2M_GUI_Language, 5)
	EndIf

	$V2M_EventDisplay = V2M_EventLog('LANG - $INI_Translation_Section = IniReadSection(' & $STG_Language_File & ', LANG_' & $V2M_GUI_Language & ')', $V2M_EventDisplay, "8")
	$INI_Translation_Section = IniReadSection($STG_Language_File, "LANG_" & $V2M_GUI_Language)

	If IsArray($INI_Translation_Section) Then
		$V2M_EventDisplay = V2M_EventLog("LANG - $INI_Translation_Section is a " & UBound($INI_Translation_Section, 0) & " dimensional array, with " & UBound($INI_Translation_Section) & " rows & " & UBound($INI_Translation_Section, 2) & " Coloumns.", $V2M_EventDisplay, "8")
	Else
		$V2M_EventDisplay = V2M_EventLog("LANG - $INI_Translation_Section is NOT an array", $V2M_EventDisplay, "8")
	EndIf
EndFunc   ;==>_Language


; #FUNCTION# ====================================================================================================================
; Name...........:		_FindReplaceNewLine()
; Description ...:		Replaces the designated New Line Character "\n" with a carage Return
; Syntax.........:		_FindReplaceNewLine($string)
; Parameters ....:		$string = String to run stringreplace on.
; Return values .:		Nill
; Author ........:		YTS_Jim
; ===============================================================================================================================
Func _FindReplaceNewLine($string)
	Return StringReplace($string, "\n", @CRLF)
EndFunc   ;==>_FindReplaceNewLine

#EndRegion Declare the functions