#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=.\VNC2Me_sc\Logo.ico
#AutoIt3Wrapper_Outfile=Build_exe.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Builds Custom Self Extracting EXE using NSIS, 7zip or IExpress
#AutoIt3Wrapper_Res_Description=Builds Custom Self Extracting EXE using NSIS, 7zip or IExpress
#AutoIt3Wrapper_Res_Fileversion=0.12.5.30
#AutoIt3Wrapper_Res_LegalCopyright=Secure Technology Group Pty Ltd (Aus) 2009-2010 (AGPL)
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_Field=PRODUCT_WEB_SITE|www.vnc2me.org
#AutoIt3Wrapper_Res_Icon_Add=.\VNC2Me_sc\icon1.ico
#AutoIt3Wrapper_Res_Icon_Add=.\VNC2Me_sc\icon2.ico
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
AutoItSetOption("MustDeclareVars", 1)
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.2.12.1
	Author:         JDaus

	Script Function:
	A setup script for building custom NSIS / 7zip / IExpress self extracting executables

#ce ----------------------------------------------------------------------------
; VARs
#include <Date.au3>
#include <File.au3>
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
Global $V2M_GUI_Language = "Lang_English"

;#Region IsAdmin
;If Not IsAdmin() Then
;	If _IsAdministrator() Then
;		If @Compiled Then
;			TraySetState(2)
;			ShellExecuteWait(@AutoItExe, "", "", "runas")
;			;			MsgBox(64, "", "IsAdmin() = " & IsAdmin())
;			Exit
;		Else
;			TraySetState(2)
;			ShellExecuteWait(@AutoItExe, ' /AutoIt3ExecuteScript "' & @ScriptFullPath & '"', "", "runas")
;			;			MsgBox(64, "", "IsAdmin() = " & IsAdmin())
;			Exit
;		EndIf
;	EndIf
;EndIf
Global $hDLL_7ZIP, $Disable_7zip
Global $YTS_EventLog, $YTS_EventDisplay, $DebugLevel = "10", $DEBUGLOG = 0
Global $YTS_LogFile = StringTrimRight(@ScriptFullPath, 4) & "_LOG.txt"
;MsgBox(0, "", "Load DLL = " & @ScriptDir & "\build_resources\7-zip32.dll")

Global $B7E_FileList, $BIE_FileFoundWinVNC
Global $AppINI = @ScriptDir & "\Build_exe.ini"

Global $B7E_Name = _IniReadWrite($AppINI, "Customise", "Name", "Build Custom exe")
Global $B7E_Description = _IniReadWrite($AppINI, "Customise", "Description", "This will create a 'self executing' Compressed EXE, from a sub-directory of files.\n\nDo you want to continue")
If StringInStr($B7E_Description, "\n") Then
	$B7E_Description = StringReplace($B7E_Description, "\n", @CRLF)
EndIf
;Global $B7E_Description2 = _IniReadWrite($AppINI, "Customise", "Description2", "Do you want to continue")
Global $B7E_Directory = _IniReadWrite($AppINI, "Customise", "Directory", "NULL")
Global $B7E_Application = _IniReadWrite($AppINI, "Customise", "Application", "NULL")
Global $B7E_FileName = _IniReadWrite($AppINI, "Customise", "FileName", "custom")
Global $B7E_use_upx = _IniReadWrite($AppINI, "Customise", "UseUPX", "0")
Global $B7E_use_cmdline = _IniReadWrite($AppINI, "Customise", "UseCMDline", "1")
Global $B7E_cmdline_for_exe
Global $B7E_use_reshacker = _IniReadWrite($AppINI, "Customise", "UseReshacker", "1"), $URL_Reshacker = "http://www.angusj.com/resourcehacker/"
Global $B7E_ReshackerExists = FileExists(@ScriptDir & "\build_resources\ResHacker.exe")
Global $B7E_Date_Time = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC
Global $INI_ShortcutStartPre = IniRead($AppINI, "NSIS", "ShortcutStartPre", "")
Global $INI_ShortcutStartPost = IniRead($AppINI, "NSIS", "ShortcutStartPost", "")
Global $INI_ShortcutRemovePre = IniRead($AppINI, "NSIS", "ShortcutRemovePre", "")
Global $INI_ShortcutRemovePost = IniRead($AppINI, "NSIS", "ShortcutRemovePost", "")
If $INI_ShortcutStartPre <> "" Then
	$INI_ShortcutStartPre = $INI_ShortcutStartPre & " "
EndIf
If $INI_ShortcutStartPost <> "" Then
	$INI_ShortcutStartPost = " " & $INI_ShortcutStartPost
EndIf
If $INI_ShortcutRemovePre <> "" Then
	$INI_ShortcutRemovePre = $INI_ShortcutRemovePre & " "
EndIf
If $INI_ShortcutRemovePost <> "" Then
	$INI_ShortcutRemovePost = " " & $INI_ShortcutRemovePost
ElseIf $INI_ShortcutRemovePre = "" And $INI_ShortcutRemovePost = "" Then
	$INI_ShortcutRemovePost = " -"
EndIf

;Global $B7E_FileName = $B7E_FileName & ".exe"

#Region Vista Mods
;=========================================================================================================================================================
;=================== Vista Modifications to allow better vista support
;=========================================================================================================================================================
;V2M_EventLog("CORE - @OSVersion = " & @OSVersion, $V2M_EventDisplay, '7')
;If @OSVersion = "WIN_VISTA" Then
If RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentVersion") >= 6 Then
	$YTS_EventDisplay = YTS_EventLog("CORE - @OSVersion >= WIN_VISTA", $YTS_EventDisplay, "2")
EndIf
#EndRegion Vista Mods
Global $OSComSpecStart, $OSComSpec
If @OSType = 'WIN32_NT' Or @OSType = "WIN32_WINDOWS" Then
	$OSComSpecStart = @ComSpec & ' /c start "" '
	$OSComSpec = @ComSpec & ' /c "" '
Else
	$OSComSpecStart = @ComSpec & ' /c start '
	$OSComSpec = @ComSpec & ' /c '
EndIf

;YTS_EventLog('@SystemDir = ' & @SystemDir, $YTS_EventDisplay, 7)
;MsgBox(0, "", "$hDLL_7ZIP = '" & $hDLL_7ZIP & "'")
Beep(1000, 50)
Beep(2000, 50)

Global $MsgBox
$MsgBox = MsgBox(36, $B7E_Name, $B7E_Description, 60)
$YTS_EventDisplay = YTS_EventLog('msgbox - ' & $B7E_Description, $YTS_EventDisplay, 7)
If $MsgBox = 7 Then
	Exit
EndIf

If StringRight(@SystemDir, 2) = "64" Then
	;If DetectInfrastructure() = "X64" Then
	YTS_EventLog('Error - "7-zip32.dll" cannot be used as this is a 64 Bit OS', $YTS_EventDisplay, 7)
	MsgBox(0, $B7E_Name & " Error", '"7-zip32.dll" Cannot be used' & @CRLF & @CRLF & "As that is a 32Bit DLL," & @CRLF & "and this is a 64 Bit OS" & @CRLF & @CRLF & "7-Zip Packaging is disabled on this OS", 60)
	$Disable_7zip = 1
ElseIf $hDLL_7ZIP = -1 Then
	YTS_EventLog('Error - "7-zip32.dll" doesnt exist', $YTS_EventDisplay, 7)
	MsgBox(0, $B7E_Name & " Error", "DLLOpen Error" & @CRLF & "Make sure the DLL exists:" & @CRLF & @ScriptDir & "\build_resources\7-zip32.dll" & @CRLF & @CRLF & "7-Zip is now disabled", 60)
	YTS_EventLog('Error - DLLOpen Error - Make sure the DLL exists:" & @CRLF & @ScriptDir & "\build_resources\7-zip32.dll', $YTS_EventDisplay, 7)
	$Disable_7zip = 1
Else
	YTS_EventLog('7-zip32.dll loaded.', $YTS_EventDisplay, 7)
	$Disable_7zip = 0
EndIf

Global $GUI_Main, $GUI_Group, $GUI_Radio1 = 1, $GUI_Radio2 = 1, $GUI_Radio3 = 1, $GUI_ButtonContinue, $msg, $B7E_Method, $TimeStampLoop[3]
$GUI_Main = GUICreate($B7E_Name, 200, 200)
$GUI_Group = GUICtrlCreateGroup("Type", 5, 5, 190, 160)
$GUI_Radio1 = GUICtrlCreateRadio("NSIS", 15, 25, 100)
$GUI_Radio2 = GUICtrlCreateRadio("IExpress", 15, 45, 100)
$GUI_Radio3 = GUICtrlCreateRadio("7-Zip", 15, 65, 100)
If $Disable_7zip = 1 Then
	GUICtrlSetState(-1, $GUI_DISABLE)
	;	$GUI_Radio3 = 1
	;Else
EndIf
$GUI_ButtonContinue = GUICtrlCreateButton("Continue", 10, 170, 180, 20, $BS_DEFPUSHBUTTON)
GUICtrlSetState($GUI_Radio1, $GUI_CHECKED)
GUISetState() ; will display an  dialog box with 1 checkbox
; Run the GUI until the dialog is closed or timer runs out
$TimeStampLoop[1] = _DateAdd('s', 10 - 1, _NowCalc()) ;sleep for 29 more seconds (30 in total)
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
			;		Case $GUI_Radio1 And BitAND(GUICtrlRead($GUI_Radio1), $GUI_CHECKED) = $GUI_CHECKED
			;			YTS_EventLog('GUI - NSIS Radio is selected', $YTS_EventDisplay, 7)
			;		Case $GUI_Radio2 And BitAND(GUICtrlRead($GUI_Radio2), $GUI_CHECKED) = $GUI_CHECKED
			;			YTS_EventLog('GUI - IExpress Radio is selected', $YTS_EventDisplay, 7)
			;		Case $GUI_Radio3 And BitAND(GUICtrlRead($GUI_Radio3), $GUI_CHECKED) = $GUI_CHECKED
			;			YTS_EventLog('GUI - 7-Zip Radio is selected', $YTS_EventDisplay, 7)
		Case $GUI_ButtonContinue
			YTS_EventLog('GUI - Continue Button was clicked', $YTS_EventDisplay, 7)
			ExitLoop
	EndSwitch
	If _DateDiff('s', $TimeStampLoop[1], _NowCalc()) >= 1 Then ExitLoop
WEnd
If BitAND(GUICtrlRead($GUI_Radio1), $GUI_CHECKED) = $GUI_CHECKED Then
	$B7E_Method = "nsis"
ElseIf BitAND(GUICtrlRead($GUI_Radio2), $GUI_CHECKED) = $GUI_CHECKED Then
	$B7E_Method = "iexpress"
Else
	$B7E_Method = "7zip"
EndIf
GUIDelete($GUI_Main)
YTS_EventLog('Packager Method - Method used is: ' & $B7E_Method, $YTS_EventDisplay, 7)
;MsgBox(64, 'Info:', '$B7E_Method = "' & $B7E_Method & '"', 30)
;Exit


;$MsgBox = MsgBox(36, $B7E_Name, "Do you want to build with IExpress ???" & @CRLF & @CRLF & "Answer no to build with 7zip!", 60)
;MsgBox(0, "", '$MsgBox = ' & $MsgBox, 10)
;If $MsgBox = 7 Then
Global $B7E_Product_Version
Global $dir2archive, $file2execute, $retResult, $sfx_config, $FilesLoop = 0, $YTS_Files[3], $NSIS_Install_Icon, $NSIS_UnInstall_Icon, $NSIS_LicenseData
Global $NSIS_Config1, $NSIS_Config2, $NSIS_Config3, $NSIS_Config4, $NSIS_Config5, $NSIS_Config6, $sed_config

If $B7E_Method = "7zip" Then
	YTS_EventLog('Packager Method - Entering 7-Zip Method routine', $YTS_EventDisplay, 7)

	If FileExists(@ScriptDir & "\SCP_settings_manager.exe") Then
		YTS_EventLog('FileExists - SCP_settings_manager.exe is located, ask to use it', $YTS_EventDisplay, 7)
		$MsgBox = MsgBox(4, $B7E_Name, "Have you Setup your Application using the settings manager yet ???", 60)
		If $MsgBox = 7 Then
			YTS_EventLog('settings_manager - User wants to run it', $YTS_EventDisplay, 7)
			RunWait(@ScriptDir & "\SCP_settings_manager.exe")
		Else
			YTS_EventLog('settings_manager - User doesnt want to run it', $YTS_EventDisplay, 7)
		EndIf
	EndIf

	If FileExists(@ScriptDir & "\V2M_settings_manager.exe") Then
		YTS_EventLog('FileExists - V2M_settings_manager.exe is located, ask user to use it', $YTS_EventDisplay, 7)
		$MsgBox = MsgBox(4, $B7E_Name, "Have you Setup your Application using the settings manager yet ???", 60)
		If $MsgBox = 7 Then
			YTS_EventLog('V2M_settings_manager - User wants to run it', $YTS_EventDisplay, 7)
			RunWait(@ScriptDir & "\V2M_settings_manager.exe")
		Else
			YTS_EventLog('V2M_settings_manager - User doesnt want to run it', $YTS_EventDisplay, 7)
		EndIf
	EndIf

	If FileExists(@ScriptDir & "\SCP_settings_manager.exe") Then
		YTS_EventLog('FileExists - SCP_settings_manager.exe is located, ask user to use it', $YTS_EventDisplay, 7)
		$MsgBox = MsgBox(4, $B7E_Name, "Have you Setup your Application using the settings manager yet ???", 60)
		If $MsgBox = 7 Then
			YTS_EventLog('SCP_settings_manager - User wants to run it', $YTS_EventDisplay, 7)
			RunWait(@ScriptDir & "\SCP_settings_manager.exe")
		Else
			YTS_EventLog('SCP_settings_manager - User doesnt want to run it', $YTS_EventDisplay, 7)
		EndIf
	EndIf

	If $B7E_ReshackerExists = "0" Then
		$YTS_EventDisplay = YTS_EventLog('$B7E_ReshackerExists = "0"', $YTS_EventDisplay, 7)
		If $B7E_use_reshacker = "1" Then
			$YTS_EventDisplay = YTS_EventLog('$B7E_use_reshacker = "1"', $YTS_EventDisplay, 7)
			$MsgBox = MsgBox(4 + 32 + 256, $B7E_Name, "Do You want to download ResHacker ???" & @CRLF & @CRLF & "Reshacker allows replacment of ICONs in the Built EXE" & @CRLF & "(The One you send to clients)", 60)
			If $MsgBox = 6 Then
				$YTS_EventDisplay = YTS_EventLog('Choice - User chose to download reshacker', $YTS_EventDisplay, 7)
				_StartSite($URL_Reshacker)
				Sleep(3000)
				MsgBox(48 + 262144, $B7E_Name, "ResHacker.exe should be placed into the 'build_resources' directory for this application to be used ..." & @CRLF & @CRLF & $B7E_Name & " will now exit. Re-run builder once Reshacker has downloaded", 30)
				Exit 1
			EndIf
		EndIf
	Else
	EndIf

	If $B7E_Directory = "NULL" Then
		YTS_EventLog('Directory - INI doesnt contain a directory to 7zip, so user needs to choose one', $YTS_EventDisplay, 7)
		$dir2archive = FileSelectFolder("Choose the folder to archive.", @ScriptDir, 2, @ScriptDir & "\scprompt")
		YTS_EventLog('VAR - $dir2archive = ' & $dir2archive, $YTS_EventDisplay, 7)
		If @error = 1 Then Exit
	Else
		$dir2archive = $B7E_Directory
		YTS_EventLog('VAR - $dir2archive = ' & $B7E_Directory, $YTS_EventDisplay, 7)
	EndIf

	If $B7E_Application = "NULL" Then
		YTS_EventLog('Application - INI doesnt contain a executable to run after extraction, so user needs to choose one', $YTS_EventDisplay, 7)
		$file2execute = FileOpenDialog("Application to launch (must be in archive)", $dir2archive, "EXE (*.exe)|ALL (*.*)", 1, "scprompt.exe")
		If @error = 1 Then Exit
		$file2execute = StringReplace($file2execute, $dir2archive & "\", "")
		YTS_EventLog('$VAR - $file2execute = ' & $file2execute, $YTS_EventDisplay, 7)

		If $B7E_use_cmdline = 1 Then
			YTS_EventLog('Cmdline - INI doesnt contain option to disable CmdLine options input, so lets create the inputbox for user.', $YTS_EventDisplay, 7)
			$MsgBox = InputBox($B7E_Name, "Do you want to add commandline arguements to your 'Launched' application ???" & @CRLF & "If your unsure, press cancel")
		EndIf
		If @error = 0 Then
			If $MsgBox <> "" Then
				If StringLeft($MsgBox, 1) = " " Then
					$file2execute = $file2execute & $MsgBox
				Else
					$file2execute = $file2execute & " " & $MsgBox
				EndIf
			EndIf
			$B7E_cmdline_for_exe = $MsgBox
			YTS_EventLog('Cmdline - new Cmdline options are : ' & $MsgBox, $YTS_EventDisplay, 7)
		EndIf
	Else
		$file2execute = $B7E_Application
	EndIf

	$dir2archive = StringReplace($dir2archive, @ScriptDir & "\", "")

	$MsgBox = MsgBox(4, $B7E_Name, "Have you tested your Application yet ???", 60)
	If $MsgBox = 7 Then
		YTS_EventLog('Testing - Launch Application for a test', $YTS_EventDisplay, 7)
		RunWait(@ScriptDir & "\" & $dir2archive & "\" & $file2execute)
		$MsgBox = MsgBox(4, $B7E_Name, "Did the application run as expected ???", 60)
		If $MsgBox <> 6 Then
			YTS_EventLog('Testing - Application did not run as expected during testing.', $YTS_EventDisplay, 7)
			Exit
		EndIf
	EndIf

	If $B7E_FileName = "custom" Then
		$B7E_FileName = StringTrimRight($file2execute, 4)
	EndIf
	$B7E_FileName = $B7E_FileName & "_" & FileGetVersion(@ScriptDir & "\" & $dir2archive & "\" & $file2execute) & "_" & $B7E_Date_Time

	$retResult = _7ZipAdd(0, @ScriptDir & "\temp\" & $B7E_FileName & ".7z", @ScriptDir & "\" & $dir2archive)
	If @error Then
		YTS_EventLog('Error - Zip error occured', $YTS_EventDisplay, 7)
		MsgBox(64, $B7E_Name & " 7Zip Error", "Error occurred" & @LF & $retResult)
	Else
		YTS_EventLog('Archive - Zip created successfully', $YTS_EventDisplay, 7)
		MsgBox(64, $B7E_Name & " - Added Files", "Archive created successfully" & @LF & $retResult, 30)
	EndIf

	$sfx_config = '' & _
			';!@Install@!UTF-8!' & @CRLF & _
			'Title="Self Executing Builder"' & @CRLF & _
			'GUIMode="1"' & @CRLF & _
			'OverwriteMode="0"' & @CRLF & _
			'SelfDelete="1"' & @CRLF & _
			'Progress="no"' & @CRLF & _
			'RunProgram="' & $dir2archive & "\" & $file2execute & '"' & @CRLF & _
			';!@InstallEnd@!'

	FileWrite(@ScriptDir & "\temp\sfx_config_" & $B7E_Date_Time & ".txt", $sfx_config)

	RunWait($OSComSpec & 'copy /b ' & @ScriptDir & '\build_resources\7z_v2m.sfx + ' & @ScriptDir & '\temp\sfx_config_' & $B7E_Date_Time & '.txt + ' & @ScriptDir & '\temp\' & $B7E_FileName & '.7z ' & @ScriptDir & '\temp\' & $B7E_FileName & '.exe', @ScriptDir, @SW_MINIMIZE)

	Sleep(500)

	If Not FileExists(@ScriptDir & '\temp\' & $B7E_FileName & '.exe') Then
		RunWait($OSComSpec & 'copy /b build_resources\7z_v2m.sfx + temp\sfx_config_' & $B7E_Date_Time & '.txt + temp\' & $B7E_FileName & '.7z temp\' & $B7E_FileName & '.exe', @ScriptDir, @SW_SHOW)
	EndIf

	If Not FileExists(@ScriptDir & '\temp\' & $B7E_FileName & '.exe') Then
		MsgBox(0, $B7E_Name & " - Error", "Error creating 'temp\" & $B7E_FileName & ".exe' from '\temp\" & $B7E_FileName & ".7z'")
		Exit
	EndIf

	If $B7E_ReshackerExists Then
		YTS_EventLog('Reshacker - FileExists Reshacker.exe', $YTS_EventDisplay, 7)
		YTS_EventLog('RunWait(' & @ScriptDir & "\build_resources\ResHacker.exe -addoverwrite " & @ScriptDir & "\" & $B7E_FileName & ".exe, " & @ScriptDir & "\" & $B7E_FileName & "_ico.exe, " & @ScriptDir & "\" & $dir2archive & "\Logo.ico, ICONGROUP,159,2057" & ', @ScriptDir & "\build_resources", @SW_SHOW)', $YTS_EventDisplay, 9)
		RunWait(@ScriptDir & "\build_resources\ResHacker.exe -addoverwrite " & @ScriptDir & "\" & $B7E_FileName & ".exe, " & @ScriptDir & "\" & $B7E_FileName & ".exe, " & @ScriptDir & "\" & $dir2archive & "\Logo.ico, ICONGROUP,MAINICON,7162", @ScriptDir & "\build_resources", @SW_SHOW)
	Else
		YTS_EventLog('$VAR - $B7E_ReshackerExists = ' & $B7E_ReshackerExists, $YTS_EventDisplay, 7)
	EndIf

	If $B7E_use_upx = 1 Then
		YTS_EventLog('UPX - Compressing created EXE using UPX', $YTS_EventDisplay, 7)
		RunWait($OSComSpec & @ScriptDir & " \build_resources\upx - 9 - f - k - o " & @ScriptDir & " \" & $B7E_FileName & " .exe " & @ScriptDir & " \temp\" & $B7E_FileName & " .exe", @ScriptDir, @SW_MINIMIZE)
	Else
		YTS_EventLog('UPX - Copying file without using UPX', $YTS_EventDisplay, 7)
		FileCopy(@ScriptDir & "\temp\" & $B7E_FileName & ".exe", @ScriptDir & "\" & $B7E_FileName & ".exe")
		Sleep(2000)
	EndIf

ElseIf $B7E_Method = "iexpress" Then
	YTS_EventLog('Packager Method - Entering IExpress Method routine', $YTS_EventDisplay, 7)

	If FileExists(@ScriptDir & "\SCP_settings_manager.exe") Then
		YTS_EventLog('FileExists - SCP_settings_manager.exe is located, ask to use it', $YTS_EventDisplay, 7)
		$MsgBox = MsgBox(4, $B7E_Name, "Have you Setup your Application using the settings manager yet ???", 60)
		If $MsgBox = 7 Then
			YTS_EventLog('settings_manager - User wants to run it', $YTS_EventDisplay, 7)
			RunWait(@ScriptDir & "\SCP_settings_manager.exe")
		Else
			YTS_EventLog('settings_manager - User doesnt want to run it', $YTS_EventDisplay, 7)
		EndIf
	EndIf

	If $B7E_ReshackerExists = "0" Then
		$YTS_EventDisplay = YTS_EventLog('$B7E_ReshackerExists = "0"', $YTS_EventDisplay, 7)
		If $B7E_use_reshacker = "1" Then
			$YTS_EventDisplay = YTS_EventLog('$B7E_use_reshacker = "1"', $YTS_EventDisplay, 7)
			$MsgBox = MsgBox(4 + 32 + 256, $B7E_Name, "Do You want to download ResHacker ???" & @CRLF & @CRLF & "Reshacker allows replacment of ICONs in the Built EXE" & @CRLF & "(The One you send to clients)", 60)
			If $MsgBox = 6 Then
				$YTS_EventDisplay = YTS_EventLog('Choice - User chose to download reshacker', $YTS_EventDisplay, 7)
				_StartSite($URL_Reshacker)
				Sleep(3000)
				MsgBox(48 + 262144, $B7E_Name, "ResHacker.exe should be placed into the 'build_resources' directory for this application to be used ..." & @CRLF & @CRLF & $B7E_Name & " will now exit. Re-run builder once Reshacker has downloaded", 30)
				Exit 1
			EndIf
		EndIf
	Else
	EndIf


	If $B7E_Directory = "NULL" Then
		YTS_EventLog('Directory - INI doesnt contain a directory to 7zip, so user needs to choose one', $YTS_EventDisplay, 7)
		$dir2archive = FileSelectFolder("Choose the folder to archive.", @ScriptDir, 2, @ScriptDir & "\scprompt")
		YTS_EventLog('VAR - $dir2archive = ' & $dir2archive, $YTS_EventDisplay, 7)
		If @error = 1 Then Exit
	Else
		$dir2archive = $B7E_Directory
		YTS_EventLog('VAR - $dir2archive = ' & $B7E_Directory, $YTS_EventDisplay, 7)
	EndIf

	If $B7E_Application = "NULL" Then
		YTS_EventLog('Application - INI doesnt contain a executable to run after extraction, so user needs to choose one', $YTS_EventDisplay, 7)
		$file2execute = FileOpenDialog("Application to launch (must be in archive)", $dir2archive, "EXE (*.exe)|ALL (*.*)", 1, "scprompt.exe")
		If @error = 1 Then Exit
		$file2execute = StringReplace($file2execute, $dir2archive & "\", "")
		YTS_EventLog('$VAR - $file2execute = ' & $file2execute, $YTS_EventDisplay, 7)

		If $B7E_use_cmdline = 1 Then
			YTS_EventLog('Cmdline - INI doesnt contain option to disable CmdLine options input, so lets create the inputbox for user.', $YTS_EventDisplay, 7)
			$MsgBox = InputBox($B7E_Name, "Do you want to add commandline arguements to your 'Launched' application ???" & @CRLF & "If your unsure, press cancel")
		EndIf
		If @error = 0 Then
			If $MsgBox <> "" Then $file2execute = $file2execute & " " & $MsgBox
			YTS_EventLog('Cmdline - new Cmdline options are : ' & $MsgBox, $YTS_EventDisplay, 7)
		EndIf
	Else
		$file2execute = $B7E_Application
	EndIf

	$dir2archive = StringReplace($dir2archive, @ScriptDir & "\", "")

	$MsgBox = MsgBox(4, $B7E_Name, "Have you tested your Application yet ???", 60)
	If $MsgBox = 7 Then
		YTS_EventLog('Testing - Launch Application for a test', $YTS_EventDisplay, 7)
		RunWait(@ScriptDir & "\" & $dir2archive & "\" & $file2execute)
		$MsgBox = MsgBox(4, $B7E_Name, "Did the application run as expected ???", 60)
		If $MsgBox <> 6 Then
			YTS_EventLog('Testing - Application did not run as expected during testing.', $YTS_EventDisplay, 7)
			Exit
		EndIf
	EndIf

	If $B7E_FileName = "custom" Then
		$B7E_FileName = StringTrimRight($file2execute, 4)
	EndIf
	$B7E_FileName = $B7E_FileName & "_" & FileGetVersion(@ScriptDir & "\" & $dir2archive & "\" & $file2execute) & "_" & $B7E_Date_Time

	$B7E_FileList = _FileListToArray(@ScriptDir & "\" & $dir2archive, "*", 1)
	If @error = 1 Then
		MsgBox(0, "", "No Folders Found.")
		Exit
	EndIf
	If @error = 4 Then
		MsgBox(0, "", "No Files Found.")
		Exit
	EndIf

	Do
		;		If $B7E_FileList[$FilesLoop + 1] = "winvnc.exe" Then
		;			$BIE_FileFoundWinVNC = 1
		;		Else
		;			$BIE_FileFoundWinVNC = 0
		;		EndIf
		$YTS_Files[1] = $YTS_Files[1] & 'FILE' & $FilesLoop & '="' & $B7E_FileList[$FilesLoop + 1] & '"' & @CRLF
		$YTS_Files[2] = $YTS_Files[2] & '%FILE' & $FilesLoop & '%=' & @CRLF
		$FilesLoop = $FilesLoop + 1
	Until $FilesLoop + 1 > $B7E_FileList[0]
	;	If $BIE_FileFoundWinVNC <> 1 Then
	;		$YTS_Files[1] = $YTS_Files[1] & 'FILE' & $FilesLoop & '="winvnc.exe"' & @CRLF
	;		$YTS_Files[2] = $YTS_Files[2] & '%FILE' & $FilesLoop & '%=' & @CRLF
	;	EndIf
	;	_ArrayDisplay($B7E_FileList, "$B7E_FileList")


	;	$retResult = _7ZipAdd(0, @ScriptDir & "\temp\" & $B7E_FileName & ".7z", @ScriptDir & "\" & $dir2archive)
	;	If @error Then
	;		YTS_EventLog('Error - Zip error occured', $YTS_EventDisplay, 7)
	;		MsgBox(64, $B7E_Name & " 7Zip Error", "Error occurred" & @LF & $retResult)
	;	Else
	;		YTS_EventLog('Archive - Zip created successfully', $YTS_EventDisplay, 7)
	;		MsgBox(64, $B7E_Name & " - Added Files", "Archive created successfully" & @LF & $retResult, 30)
	;	EndIf

	;FileDelete(@ScriptDir & "\temp\sfx_config.txt")
	$sed_config = '' & _
			'[Version]' & @CRLF & _
			'Class=IEXPRESS' & @CRLF & _
			'SEDVersion=3' & @CRLF & _
			'[Options]' & @CRLF & _
			'PackagePurpose=InstallApp' & @CRLF & _
			'ShowInstallProgramWindow=0' & @CRLF & _
			'HideExtractAnimation=1' & @CRLF & _
			'UseLongFileName=1' & @CRLF & _
			'InsideCompressed=0' & @CRLF & _
			'CAB_FixedSize=0' & @CRLF & _
			'CAB_ResvCodeSigning=0' & @CRLF & _
			'RebootMode=N' & @CRLF & _
			'InstallPrompt=%InstallPrompt%' & @CRLF & _
			'DisplayLicense=%DisplayLicense%' & @CRLF & _
			'FinishMessage=%FinishMessage%' & @CRLF & _
			'TargetName=%TargetName%' & @CRLF & _
			'FriendlyName=%FriendlyName%' & @CRLF & _
			'AppLaunched=%AppLaunched%' & @CRLF & _
			'PostInstallCmd=%PostInstallCmd%' & @CRLF & _
			'AdminQuietInstCmd=%AdminQuietInstCmd%' & @CRLF & _
			'UserQuietInstCmd=%UserQuietInstCmd%' & @CRLF & _
			'SourceFiles=SourceFiles' & @CRLF & _
			'[Strings]' & @CRLF & _
			'InstallPrompt=' & @CRLF & _
			'DisplayLicense=' & @CRLF & _
			'FinishMessage=' & @CRLF & _
			'TargetName=.\' & $B7E_FileName & '.exe' & @CRLF & _
			'FriendlyName=' & StringTrimRight($file2execute, 4) & '' & @CRLF & _
			'AppLaunched=' & $file2execute & @CRLF & _
			'PostInstallCmd=<None>' & @CRLF & _
			'AdminQuietInstCmd=' & @CRLF & _
			'UserQuietInstCmd=' & @CRLF & _
			$YTS_Files[1] & _
			'[SourceFiles]' & @CRLF & _
			'SourceFiles0=' & $dir2archive & '\' & @CRLF & _
			'[SourceFiles0]' & @CRLF & _
			$YTS_Files[2]

	FileWrite(@ScriptDir & "\temp\sed_config_" & $B7E_Date_Time & ".sed", $sed_config)

	RunWait($OSComSpec & 'iexpress.exe /N ' & @ScriptDir & '\temp\sed_config_' & $B7E_Date_Time & '.sed', @ScriptDir, @SW_HIDE)

	Sleep(2000)

	If Not FileExists(@ScriptDir & '\' & $B7E_FileName & '.exe') Then
		MsgBox(0, $B7E_Name & " - Error", "Error creating '" & $B7E_FileName & ".exe'" & @CRLF & "From '" & $B7E_Directory & "' Directory, launching: " & $B7E_Application, 60)
		;		MsgBox(0, $B7E_Name & " - Error", "Error creating '" & $B7E_FileName & ".exe' from '" & $B7E_Directory & "'")
		Exit
	EndIf

	If $B7E_ReshackerExists Then
		YTS_EventLog('Reshacker - FileExists Reshacker.exe', $YTS_EventDisplay, 7)
		If $B7E_use_reshacker = "1" Then
			$YTS_EventDisplay = YTS_EventLog('$B7E_use_reshacker = "1"', $YTS_EventDisplay, 7)
			;		YTS_EventLog('RunWait(' & @ScriptDir & "\build_resources\ResHacker.exe -addoverwrite " & @ScriptDir & "\" & $B7E_FileName & ".exe, " & @ScriptDir & "\" & $B7E_FileName & "_ico.exe, " & @ScriptDir & "\" & $dir2archive & "\Logo.ico, ICONGROUP,159,2057" & ', @ScriptDir & "\build_resources", @SW_SHOW)', $YTS_EventDisplay, 9)
			;		RunWait(@ScriptDir & "\build_resources\ResHacker.exe -addoverwrite " & @ScriptDir & "\" & $B7E_FileName & ".exe, " & @ScriptDir & "\" & $B7E_FileName & "_new.exe, " & @ScriptDir & "\" & $dir2archive & "\Logo.ico,  ICONGROUP,3000,1033", @ScriptDir & "\build_resources", @SW_SHOW)
			YTS_EventLog('RunWait(' & @ScriptDir & "\build_resources\ResHacker.exe -addoverwrite " & @ScriptDir & "\" & $B7E_FileName & ".exe, " & @ScriptDir & "\" & $B7E_FileName & "_ico.exe, " & @ScriptDir & "\" & $dir2archive & "\Logo.ico, ICONGROUP,159,2057" & ', @ScriptDir & "\build_resources", @SW_SHOW)', $YTS_EventDisplay, 9)
			RunWait(@ScriptDir & "\build_resources\ResHacker.exe -addoverwrite " & @ScriptDir & "\" & $B7E_FileName & ".exe, " & @ScriptDir & "\" & $B7E_FileName & "_rc.exe, " & @ScriptDir & "\versioninfo.rc, VERSIONINFO,1,1033", @ScriptDir & "\build_resources", @SW_SHOW)
		EndIf
	Else
		YTS_EventLog('$VAR - $B7E_ReshackerExists = ' & $B7E_ReshackerExists, $YTS_EventDisplay, 7)
	EndIf

	Sleep(2000)

	If $B7E_use_upx = 1 Then
		YTS_EventLog('UPX - Compressing created EXE using UPX', $YTS_EventDisplay, 7)
		RunWait($OSComSpec & @ScriptDir & "\build_resources\upx -9 -f -k -o " & @ScriptDir & "\" & $B7E_FileName & ".exe " & @ScriptDir & "\temp\" & $B7E_FileName & ".exe", @ScriptDir, @SW_MINIMIZE)
	EndIf

	Sleep(500)

Else
	YTS_EventLog('Packager Method - Entering NSIS Method routine', $YTS_EventDisplay, 7)
	If FileExists(@ScriptDir & "\SCP_settings_manager.exe") Then
		YTS_EventLog('FileExists - SCP_settings_manager.exe is located, ask to use it', $YTS_EventDisplay, 7)
		$MsgBox = MsgBox(4, $B7E_Name, "Have you Setup your Application using the settings manager yet ???", 60)
		If $MsgBox = 7 Then
			YTS_EventLog('settings_manager - User wants to run it', $YTS_EventDisplay, 7)
			RunWait(@ScriptDir & "\SCP_settings_manager.exe")
		Else
			YTS_EventLog('settings_manager - User doesnt want to run it', $YTS_EventDisplay, 7)
		EndIf
	EndIf

	;	If $B7E_ReshackerExists = "0" Then
	;		$YTS_EventDisplay = YTS_EventLog('$B7E_ReshackerExists = "0"', $YTS_EventDisplay, 7)
	;		If $B7E_use_reshacker = "1" Then
	;			$YTS_EventDisplay = YTS_EventLog('$B7E_use_reshacker = "1"', $YTS_EventDisplay, 7)
	;			$MsgBox = MsgBox(4 + 32 + 256, $B7E_Name, "Do You want to download ResHacker ???" & @CRLF & @CRLF & "Reshacker allows replacment of ICONs in the Built EXE" & @CRLF & "(The One you send to clients)", 60)
	;			If $MsgBox = 6 Then
	;				$YTS_EventDisplay = YTS_EventLog('Choice - User chose to download reshacker', $YTS_EventDisplay, 7)
	;				_StartSite($URL_Reshacker)
	;				Sleep(3000)
	;				MsgBox(48 + 262144, $B7E_Name, "ResHacker.exe should be placed into the 'build_resources' directory for this application to be used ..." & @CRLF & @CRLF & $B7E_Name & " will now exit. Re-run builder once Reshacker has downloaded", 30)
	;				Exit 1
	;			EndIf
	;		EndIf
	;	Else
	;	EndIf


	If $B7E_Directory = "NULL" Then
		YTS_EventLog('Directory - INI doesnt contain a directory to Package, so user needs to choose one', $YTS_EventDisplay, 7)
		$dir2archive = FileSelectFolder("Choose the folder to archive.", @ScriptDir, 2, @ScriptDir & "\scprompt")
		YTS_EventLog('VAR - $dir2archive = ' & $dir2archive, $YTS_EventDisplay, 7)
		If @error = 1 Then Exit
	Else
		$dir2archive = $B7E_Directory
		YTS_EventLog('VAR - $dir2archive = ' & $B7E_Directory, $YTS_EventDisplay, 7)
	EndIf

	If $B7E_Application = "NULL" Then
		YTS_EventLog('Application - INI doesnt contain a executable to run after extraction, so user needs to choose one', $YTS_EventDisplay, 7)
		$file2execute = FileOpenDialog("Application to launch (must be in archive)", $dir2archive, "EXE (*.exe)|ALL (*.*)", 1, "scprompt.exe")
		If @error = 1 Then Exit
		$file2execute = StringReplace($file2execute, $dir2archive & "\", "")
		YTS_EventLog('$VAR - $file2execute = ' & $file2execute, $YTS_EventDisplay, 7)

		If $B7E_use_cmdline = 1 Then
			YTS_EventLog('Cmdline - INI doesnt contain option to disable CmdLine options input, so lets create the inputbox for user.', $YTS_EventDisplay, 7)
			$MsgBox = InputBox($B7E_Name, "Do you want to add commandline arguements to your 'Launched' application ???" & @CRLF & "If your unsure, press cancel")
		EndIf
		If @error = 0 Then
			If $MsgBox <> "" Then $file2execute = $file2execute & " " & $MsgBox
			YTS_EventLog('Cmdline - new Cmdline options are : ' & $MsgBox, $YTS_EventDisplay, 7)
		EndIf
	Else
		$file2execute = $B7E_Application
	EndIf

	$dir2archive = StringReplace($dir2archive, @ScriptDir & "\", "")

	$MsgBox = MsgBox(4, $B7E_Name, "Have you tested your Application yet ???", 60)
	If $MsgBox = 7 Then
		YTS_EventLog('Testing - Launch Application for a test', $YTS_EventDisplay, 7)
		RunWait(@ScriptDir & "\" & $dir2archive & "\" & $file2execute)
		$MsgBox = MsgBox(4, $B7E_Name, "Did the application run as expected ???", 60)
		If $MsgBox <> 6 Then
			YTS_EventLog('Testing - Application did not run as expected during testing.', $YTS_EventDisplay, 7)
			Exit
		EndIf
	EndIf

	If $B7E_FileName = "custom" Then
		$B7E_FileName = StringTrimRight($file2execute, 4)
	EndIf

	$B7E_Product_Version = FileGetVersion(@ScriptDir & "\" & $dir2archive & "\" & $file2execute)
	$NSIS_Config1 = 'RequestExecutionLevel user' & @CRLF & _
			'ShowInstDetails "nevershow"' & @CRLF & _
			'!define PRODUCT_NAME "' & $B7E_FileName & '"' & @CRLF & _
			'!define PRODUCT_DIR "' & $dir2archive & '"' & @CRLF & _
			'!define PRODUCT_APPLICATION "' & $B7E_FileName & '"' & @CRLF & _
			'!define PRODUCT_VERSION "' & $B7E_Product_Version & '"' & @CRLF & _
			'!define PRODUCT_PUBLISHER "Built with STG Packager by: Secure Technology Group"' & @CRLF & _
			'!define PRODUCT_WEB_SITE "www.securetech.com.au"' & @CRLF & _
			'!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"' & @CRLF & _
			'!define PRODUCT_UNINST_ROOT_KEY "HKCU"' & @CRLF & _
			'!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_NAME}"' & @CRLF & _
			'LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"' & @CRLF & _
			'VIProductVersion "${PRODUCT_VERSION}"' & @CRLF & _
			'VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${PRODUCT_NAME}"' & @CRLF & _
			'VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" ""' & @CRLF & _
			'VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "${PRODUCT_PUBLISHER}"' & @CRLF & _
			';VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "${PRODUCT_PUBLISHER}"' & @CRLF & _
			'VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "${PRODUCT_NAME}"' & @CRLF & _
			'VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" ""' & @CRLF & _
			'VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${PRODUCT_VERSION}"' & @CRLF & _
			'VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${PRODUCT_VERSION}"' & @CRLF & _
			'VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "${PRODUCT_NAME} maybe a trademark of the company that produces it."' & @CRLF & _
			'SetCompressor /SOLID lzma' & @CRLF & _
			'UninstPage uninstConfirm' & @CRLF & _
			'VAR APPLICATION_COMMON_FOLDER' & @CRLF

	If FileExists($dir2archive & "\License.txt") Then
		$NSIS_LicenseData = 'LicenseData "..\${PRODUCT_DIR}\License.txt"' & @CRLF
	Else
		$NSIS_LicenseData = ""
	EndIf
	If FileExists($dir2archive & "\Logo.ico") Then
		$NSIS_Install_Icon = 'Icon "..\${PRODUCT_DIR}\Logo.ico"' & @CRLF
		$NSIS_UnInstall_Icon = 'UninstallIcon "..\${PRODUCT_DIR}\Logo.ico"' & @CRLF
	ElseIf FileExists($dir2archive & "\icon1.ico") Then
		$NSIS_Install_Icon = 'Icon "..\${PRODUCT_DIR}\icon1.ico"' & @CRLF
		$NSIS_UnInstall_Icon = 'UninstallIcon "..\${PRODUCT_DIR}\icon1.ico"' & @CRLF
	ElseIf FileExists($dir2archive & "\icon2.ico") Then
		$NSIS_Install_Icon = 'Icon "..\${PRODUCT_DIR}\icon2.ico"' & @CRLF
		$NSIS_UnInstall_Icon = 'UninstallIcon "..\${PRODUCT_DIR}\icon2.ico"' & @CRLF
	Else
		$NSIS_Install_Icon = ''
		$NSIS_UnInstall_Icon = ''
	EndIf

	$NSIS_Config2 = 'Section "Appdatatool (compulsory)"' & @CRLF & _
			'  SectionIn RO' & @CRLF & _
			'  Call GetParameters' & @CRLF & _
			'  Pop $0' & @CRLF & _
			'  System::Call "shfolder::SHGetFolderPath(i $HWNDPARENT, i 0x0023, i 0, i 0, t.r1)"' & @CRLF & _
			'  StrCpy $APPLICATION_COMMON_FOLDER "$1\$0"' & @CRLF & _
			';	AccessControl::GrantOnFile \' & @CRLF & _
			';	"$APPLICATION_COMMON_FOLDER" "(S-1-5-32-545)"' & @CRLF & _
			';	"GenericRead + GenericWrite + Delete"' & @CRLF & _
			'SectionEnd' & @CRLF & _
			'Name "${PRODUCT_NAME} - ${PRODUCT_VERSION}"' & @CRLF & _
			';ReserveFile "..\${PRODUCT_DIR}\scprompt.ini"' & @CRLF & _
			'OutFile "..\${PRODUCT_NAME}_${PRODUCT_VERSION}_' & $B7E_Date_Time & '.exe"' & @CRLF & _
			'InstallDir "$LOCALAPPDATA\${PRODUCT_NAME}"' & @CRLF & _
			$NSIS_Install_Icon & _
			$NSIS_UnInstall_Icon & _
			$NSIS_LicenseData & _
			'ShowInstDetails "nevershow"' & @CRLF & _
			'ShowUnInstDetails show' & @CRLF

	$NSIS_Config3 = 'Section "Main"' & @CRLF & _
			'	HideWindow' & @CRLF & _
			'	SetSilent silent' & @CRLF & _
			'	SetOutPath "$INSTDIR"' & @CRLF & _
			'	File "..\${PRODUCT_DIR}\*" ;write here path to your program file' & @CRLF & _
			'	;File "";write here path to your program other files' & @CRLF & _
			'	WriteUninstaller "$INSTDIR\${PRODUCT_APPLICATION}_Uninst.exe"' & @CRLF & _
			'	CreateShortCut "$DESKTOP\' & $INI_ShortcutStartPre & '${PRODUCT_NAME}' & $INI_ShortcutStartPost & '.lnk" "$INSTDIR\${PRODUCT_APPLICATION}.exe" ""' & @CRLF & _
			'	CreateShortCut "$DESKTOP\' & $INI_ShortcutRemovePre & '${PRODUCT_NAME}' & $INI_ShortcutRemovePost & '.lnk" "$INSTDIR\${PRODUCT_APPLICATION}_Uninst.exe" "" "$INSTDIR\${PRODUCT_APPLICATION}_Uninst.exe" 0' & @CRLF & _
			'	ExecWait  ' & "'" & '"$INSTDIR\${PRODUCT_APPLICATION}.exe"' & "'" & @CRLF & _
			'	IfErrors DONE' & @CRLF & _
			'	RMDir /r "$INSTDIR\*.*"' & @CRLF & _
			'	RMDir "$INSTDIR"' & @CRLF & _
			'	Delete "$DESKTOP\' & $INI_ShortcutStartPre & '${PRODUCT_NAME}' & $INI_ShortcutStartPost & '.lnk"' & @CRLF & _
			'	Delete "$DESKTOP\' & $INI_ShortcutRemovePre & '${PRODUCT_NAME}' & $INI_ShortcutRemovePost & '.lnk"' & @CRLF & _
			'	done:' & @CRLF & _
			'	SetAutoClose true' & @CRLF & _
			'SectionEnd' & @CRLF

	$NSIS_Config4 = 'Section "Uninstall"' & @CRLF & _
			'	RMDir /r "$INSTDIR\*.*"' & @CRLF & _
			'	RMDir "$INSTDIR"' & @CRLF & _
			'	Delete "$DESKTOP\' & $INI_ShortcutStartPre & '${PRODUCT_NAME}' & $INI_ShortcutStartPost & '.lnk"' & @CRLF & _
			'	Delete "$DESKTOP\' & $INI_ShortcutRemovePre & '${PRODUCT_NAME}' & $INI_ShortcutRemovePost & '.lnk"' & @CRLF & _
			'	Delete "$SMPROGRAMS\${PRODUCT_NAME}\*.*"' & @CRLF & _
			'	RmDir  "$SMPROGRAMS\${PRODUCT_NAME}"' & @CRLF & _
			'	SetAutoClose true' & @CRLF & _
			'SectionEnd' & @CRLF

	$NSIS_Config5 = 'Function GetParameters' & @CRLF & _
			'	Push $R0' & @CRLF & _
			'	Push $R1' & @CRLF & _
			'	Push $R2' & @CRLF & _
			'	Push $R3' & @CRLF & _
			'	StrCpy $R2 1' & @CRLF & _
			'	StrLen $R3 $CMDLINE' & @CRLF & _
			'	StrCpy $R0 $CMDLINE $R2' & @CRLF & _
			'	StrCmp $R0 ' & "'" & '"' & "'" & ' 0 +3' & @CRLF & _
			'		StrCpy $R1 ' & "'" & '"' & "'" & @CRLF & _
			'		Goto loop' & @CRLF & _
			'	StrCpy $R1 " "' & @CRLF & _
			'	loop:' & @CRLF & _
			'		IntOp $R2 $R2 + 1' & @CRLF & _
			'		StrCpy $R0 $CMDLINE 1 $R2' & @CRLF & _
			'		StrCmp $R0 $R1 get' & @CRLF & _
			'		StrCmp $R2 $R3 get' & @CRLF & _
			'		Goto loop' & @CRLF & _
			'	get:' & @CRLF & _
			'		IntOp $R2 $R2 + 1' & @CRLF & _
			'		StrCpy $R0 $CMDLINE 1 $R2' & @CRLF & _
			'		StrCmp $R0 " " get' & @CRLF & _
			'		StrCpy $R0 $CMDLINE "" $R2' & @CRLF & _
			'	Pop $R3' & @CRLF & _
			'	Pop $R2' & @CRLF & _
			'	Pop $R1' & @CRLF & _
			'	Exch $R0' & @CRLF & _
			'FunctionEnd' & @CRLF

	$NSIS_Config6 = ';Function .onInit' & @CRLF & _
			';	InitPluginsDir' & @CRLF & _
			';	File /oname=$PLUGINSDIR\scprompt.ini "..\${PRODUCT_DIR}\scprompt.ini"' & @CRLF & _
			';FunctionEnd' & @CRLF
	FileWrite(@ScriptDir & "\temp\nsis_config_" & $B7E_Date_Time & ".nsi", $NSIS_Config1 & $NSIS_Config2 & $NSIS_Config3 & $NSIS_Config4 & $NSIS_Config5 & $NSIS_Config6)

	RunWait($OSComSpecStart & @ScriptDir & '\build_resources\makensis.exe /V2 ' & @ScriptDir & "\temp\nsis_config_" & $B7E_Date_Time & ".nsi", @ScriptDir, @SW_HIDE)

	;	RunWait($OSComSpec & 'iexpress.exe /N ' & @ScriptDir & '\temp\sed_config_' & $B7E_Date_Time & '.sed', @ScriptDir, @SW_HIDE)

	Sleep(2000)

	If Not FileExists(@ScriptDir & '\' & $B7E_FileName & '_' & $B7E_Product_Version & '_' & $B7E_Date_Time & '.exe') Then
		MsgBox(0, $B7E_Name & " - Error", "Error creating '" & $B7E_FileName & '_' & $B7E_Product_Version & '_' & $B7E_Date_Time & ".exe'" & @CRLF & "From '" & $B7E_Directory & "' Directory, launching: " & $B7E_Application, 60)
		Exit
	EndIf

	If $B7E_use_upx = 1 Then
		YTS_EventLog('UPX - Compressing created EXE using UPX', $YTS_EventDisplay, 7)
		RunWait($OSComSpec & @ScriptDir & "\build_resources\upx -9 -f -k -o " & @ScriptDir & "\" & $B7E_FileName & '_' & $B7E_Product_Version & '_' & $B7E_Date_Time & "_upx.exe " & @ScriptDir & "\temp\" & $B7E_FileName & '_' & $B7E_Product_Version & '_' & $B7E_Date_Time & ".exe", @ScriptDir, @SW_MINIMIZE)
	EndIf
	;
	;	Sleep(500)
EndIf

;$MsgBox = MsgBox(4, $B7E_Name, "Did the application run as expected ???", 60)
If MsgBox(4, $B7E_Name, "Building complete, time to test ...", 20) <> 6 Then
	YTS_EventLog('Testing - Application did not run as expected during testing.', $YTS_EventDisplay, 7)
	Exit
EndIf
Run(@ScriptDir & '\' & $B7E_FileName & '_' & $B7E_Product_Version & '_' & $B7E_Date_Time & '.exe')

; #FUNCTION# ====================================================================================================================
; Name...........: _IniReadWrite
; Description ...: Reads a value from a standard format .ini file. If returned value = "" it writes default value to INI.
;		If no default given, it writes a space (which should mean it doesn't return back
; Syntax.........: _IniReadWrite ($LocalFilename, $LocalSection, $LocalKey, $LocalDefault = ' ')
;
; Parameters ....:	$LocalFilename -	The filename of the .ini file.
;					$LocalSection -		The section name in the .ini file.
;					$LocalKey -			The key name in the in the .ini file.
;					$LocalDefault -		The default value to return (and write to INI) if the requested key is not found.
;
; Return values .:	Success -			Returns the requested key value read from INI. ($LocalRead)
;					Failure -			Returns the default string if requested key not found. ($LocalDefault)
;										Writes the $LocalDefault
; Author ........:	JDaus
; ===============================================================================================================================
Func _IniReadWrite($LocalFilename, $LocalSection, $LocalKey, $LocalDefault = ' ')
	YTS_EventLog("Func _IniReadWrite(" & $LocalFilename & ", " & $LocalSection & ", " & $LocalKey & ", " & $LocalDefault & ")", $YTS_EventDisplay, 9)
	Local $LocalRead, $LocalWrite, $return
	$LocalRead = IniRead($LocalFilename, $LocalSection, $LocalKey, '')
	If $LocalRead = '' Then
		SetError(1)
		$LocalWrite = IniWrite($LocalFilename, $LocalSection, $LocalKey, $LocalDefault)
		If $LocalWrite = 0 Then
			$return = 0
		Else
			$return = $LocalDefault
		EndIf
	Else
		$return = $LocalRead
	EndIf
	Return $return
EndFunc   ;==>_IniReadWrite


; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipAdd
; Description ...: Adds files to archive
; Syntax.........: _7ZipAdd($hWnd, $sArcName, $sFileName[, $sHide = 0[, $sCompress = 5[, $sRecurse = 1[, $sIncludeFile = 0[, _
;				   $sExcludeFile = 0[, $sPassword = 0[, $sSFX = 0[, $sVolume = 0[, $sWorkDir = 0]]]]]]]]])
; Parameters ....: $hWnd         - Handle to parent or owner window
;				   $sArcName     - Archive file name
;				   $sFileName    - File names to archive up
;				   $sHide        - Use this switch if you want the CallBack function to be called
;				   $sCompress    - Compress level 0-9
;				   $sRecurse     - Recursion method: 0 - Disable recursion
;													 1 - Enable recursion
;													 2 - Enable recursion only for wildcard names
;				   $sIncludeFile - Include filenames, specifies filenames and wildcards or list file that specify processed files
;				   $sExcludeFile - Exclude filenames, specifies what filenames or (and) wildcards must be excluded from operation
;				   $sPassword    - Specifies password
;				   $sSFX         - Creates self extracting archive
;				   $sVolume      - Specifies volumes sizes
;				   $sWorkDir     - Sets working directory for temporary base archive
; Return values .: Success       - Returns the string with results
;                  Failure       - Returns 0 and and sets the @error flag to 1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipAdd($hWnd, $sArcName, $sFileName, $sHide = 0, $sCompress = 5, $sRecurse = 1, $sIncludeFile = 0, $sExcludeFile = 0, _
		$sPassword = 0, $sSFX = 0, $sVolume = 0, $sWorkDir = 0)

	YTS_EventLog("Func _7ZipAdd(" & $hWnd & ", " & $sArcName & ", " & $sFileName & ", " & $sHide & ", " & $sCompress & ", " & $sRecurse & ", " & $sIncludeFile & ", " & $sExcludeFile & ", " & $sPassword & ", " & $sSFX & ", " & $sVolume & ", " & $sWorkDir & ")", $YTS_EventDisplay, 9)

	$sArcName = '"' & $sArcName & '"'
	$sFileName = '"' & $sFileName & '"'

	Local $iSwitch = ""

	If $sHide Then $iSwitch &= " -hide"

	$iSwitch &= " -mx" & $sCompress
	$iSwitch &= _RecursionSet($sRecurse)

	;	If $sIncludeFile Then $iSwitch &= _IncludeFileSet($sIncludeFile)
	;	If $sExcludeFile Then $iSwitch &= _ExcludeFileSet($sExcludeFile)

	If $sPassword Then $iSwitch &= " -p" & $sPassword

	If FileExists($sSFX) Then $iSwitch &= " -sfx" & $sSFX

	If $sVolume Then $iSwitch &= " -v" & $sVolume

	If $sWorkDir Then $iSwitch &= " -w" & $sWorkDir

	Local $tOutBuffer = DllStructCreate("char[32768]")

	Local $aRet = DllCall($hDLL_7ZIP, "int", "SevenZip", _
			"hwnd", $hWnd, _
			"str", "a " & $sArcName & " " & $sFileName & " " & $iSwitch, _
			"ptr", DllStructGetPtr($tOutBuffer), _
			"int", DllStructGetSize($tOutBuffer))

	If Not $aRet[0] Then Return SetError(0, 0, DllStructGetData($tOutBuffer, 1))
	Return SetError(1, 0, 0)
EndFunc   ;==>_7ZipAdd

; #FUNCTIONS FOR INTERNAL USE# ==================================================================================================
Func _RecursionSet($sVal)
	YTS_EventLog("Func _RecursionSet(" & $sVal & ")", $YTS_EventDisplay, 9)
	Switch $sVal
		Case 1
			Return " -r"
		Case 2
			Return " -r0"
		Case Else
			Return " -r-"
	EndSwitch
EndFunc   ;==>_RecursionSet

Func _ChangeIcon()
	YTS_EventLog("Func _ChangeIcon()", $YTS_EventDisplay, 9)
	RunWait(@ScriptDir & "\build_resources\ResHacker.exe -addoverwrite " & @ScriptDir & "\" & $B7E_FileName & ".exe, " & @ScriptDir & "\" & $B7E_FileName & ".exe, " & @ScriptDir & "\" & $dir2archive & "\Logo.ico,  ICONGROUP,159,2057", @ScriptDir & "\build_resources", @SW_SHOW)
EndFunc   ;==>_ChangeIcon


;===============================================================================
; Description:
; Parameter(s):
; Requirement(s):
; Return Value(s):
; Author(s):            YTS_Jim
; Note(s):
;===============================================================================
Func _StartSite($INI_Set_webpage)
	YTS_EventLog("Func _StartSite(" & $INI_Set_webpage & ")", $YTS_EventDisplay, 9)
	;	$V2M_EventDisplay = V2M_EventLog("FUNC - _StartSite()", $V2M_EventDisplay, "8")
	;	If @OSType = 'WIN32_NT' Or @OSType = "WIN32_WINDOWS" Then
	;		$OSComSpecStart = @ComSpec & ' /c start "" '
	;	Else
	;		$OSComSpecStart = @ComSpec & ' /c start '
	;	EndIf
	Run($OSComSpecStart & $INI_Set_webpage, '', @SW_HIDE)
EndFunc   ;==>_StartSite

;===============================================================================
;
; Description:          Eventlog handler, sends logs to std windows debug (via dll)
;                                       and GUI Statusbars
; Parameter(s):         $YTS_EventLog   =       Text string to send to log
;                       $LocalDbgLvl	=		0, text is display in statusbar. else, only sent to debug dll
; Requirement(s):
; Return Value(s):      $YTS_EventDisplay
; Author(s):            YTS_Jim
; Note(s):
;
;===============================================================================

Func YTS_EventLog($YTS_EventLog = '', $YTS_EventDisplay = '', $LocalDbgLvl = '8')
	;	Local $DebugLevel
	If $DebugLevel > $LocalDbgLvl Then
		If $YTS_EventLog <> $YTS_EventDisplay Then
			;			If IniRead(@ScriptDir & "\scprompt.ini", "Common", "EnableDebug", "0") Then
			; view the following output from sysinternals debuger "DebugView" or similar
			DllCall("kernel32.dll", "none", "OutputDebugString", "str", "B7E - " & $YTS_EventLog)
			ConsoleWrite($YTS_EventLog & @CRLF)
			$YTS_EventDisplay = $YTS_EventLog
			;			EndIf
			If $DEBUGLOG = 1 Then FileWrite($YTS_LogFile, " - " & $YTS_EventLog & @CRLF)
		EndIf
	EndIf

	Return $YTS_EventDisplay
EndFunc   ;==>YTS_EventLog

Func _IsAdministrator($sUser = @UserName, $sCompName = ".")
	YTS_EventLog("Func _IsAdministrator($sUser = @UserName, $sCompName = '.')", $YTS_EventDisplay, 9)
	Local $aCall = DllCall("netapi32.dll", "long", "NetUserGetInfo", "wstr", $sCompName, "wstr", $sUser, "dword", 1, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, False)
	Local $fPrivAdmin = DllStructGetData(DllStructCreate("ptr;ptr;dword;dword;ptr;ptr;dword;ptr", $aCall[4]), 4) = 2
	DllCall("netapi32.dll", "long", "NetApiBufferFree", "ptr", $aCall[4])
	Return $fPrivAdmin
EndFunc   ;==>_IsAdministrator


Func DetectInfrastructure() ; http://www.autoitscript.com/forum/topic/34138-how-to-detect-a-64-bit-os/
	YTS_EventLog("Func DetectInfrastructure()", $YTS_EventDisplay, 9)
	Local $Local_Return
	If @OSType = 'WIN32_NT' Or @OSType = "WIN32_WINDOWS" Then ;If @OSType = "WIN32_NT" Then
		$Local_Return = "WIN_NT"
		;		MsgBox(0,"Error","Unsupported Windows version."&@CRLF&"Use only a 32 bit OS for full support.")
		;		Exit 1
	Else
		$Local_Return = @OSArch
		;		If @ProcessorArch = "X86" Then
		;			$HKLM = "HKEY_LOCAL_MACHINE"
		;			$devcon = $devcon32
		;			If @OSVersion = "WIN_XP" Then _AddLineBox("Detecting Windows version - Windows XP x32")
		;			If @OSVersion = "WIN_2000" Then _AddLineBox("Detecting Windows version - Windows 2000 x32")
		;			If @OSVersion = "WIN_2003" Then _AddLineBox("Detecting Windows version - Windows 2003 x32")
		;		EndIf
		;		If @ProcessorArch = "X64" Then
		;			$HKLM = "HKEY_LOCAL_MACHINE64"
		;			$devcon = $devcon64
		;			If @OSVersion = "WIN_XP" Then _AddLineBox("Detecting Windows version - Windows XP x64")
		;			If @OSVersion = "WIN_2000" Then _AddLineBox("Detecting Windows version - Windows 2000 x64")
		;			If @OSVersion = "WIN_2003" Then _AddLineBox("Detecting Windows version - Windows 2003 x64")
		;		EndIf
	EndIf
	YTS_EventLog("$Local_Return = " & $Local_Return, $YTS_EventDisplay, 9)
	Return $Local_Return
EndFunc   ;==>DetectInfrastructure