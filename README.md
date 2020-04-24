# SCPrompt
An Autoit Application which opens a reverse VNC connection from a UVNC server to a listening UVNC viewer. 

SCPrompt allows for customisation of the GUI to suit your business needs.

[SCPrompt on UVNC forums](https://forum.ultravnc.net/viewtopic.php?f=15&t=14809)
[SCPrompt Blog](https://www.securetech.com.au/projects/scprompt)


SCPrompt readme

<*>	About
<*> Quick Setup
<*> Custom Setup
<*>	Manually configure
<*>	test
<*>	build
<*>	feedback and future
<*> Changelog
<*> Roadmap


**********  ABOUT  **********

http://forum.ultravnc.info/viewtopic.php?t=14809

SCPrompt was a small project that was started by Dwalf back in 2005.
	this original project was a very simple application that launched the SC application (with commandline arguments) and then exited
	(not waiting for the SC application to error or anything similar)

The updated application now stays running while the connection is running (it just minimises when start button pressed),
	and will restart the server if it fails (server has autoreconnection anyway).

In addition to this, the application also offers pre-defined connections, which allow a support person to setup connections for quick use.
	the manual part is still available with the pre-defined connections, and is just as easy to use as the orirginal.

SCPrompt has the ability to select from one of several different GUI Types (by setting the GUI_Type in the "scprompt.INI")
SCPrompt Supports Direct Connections and Repeater Connections.
SCPrompt has the ability to run in a "Service Mode" which installs UVNC Server as a service, and allows for better support in Vista & above.


**********  Quick Setup  **********
Running 'Build_SCPrompt.exe' will prompt you to with the following questions ...

This will Create the 7zip EXE from the scprompt sub-directory, do you wish to continue ???
  |___ NO - *EXIT*
  |___ YES - have you setup the application using settings manager yet ???
    |___ NO - *RUN* 'Settings_Manager.exe' and wait till close - Continue
    |___ YES & after 'Settings_manager.exe' - Have you tested your application yet ???
	  |___ NO - *RUN* 'scprompt\scprompt.exe' and wait till close - Did the application run as expected ???
		|___ NO - *EXIT*
	    |___ YES - Continue
	  |___ YES - Compress the scprompt directory
	    |___ OK - Building complete, time to test ...
		  |___ OK - *RUN* Finished 7zip EXE (scprompt_0.X.X.X.exe) - Exit (no wait)

Suggested path is:
YES
  |___ Yes
    |___ NO & us settings manager.
	  |___ NO & test it works as expected.
	    |___ Check that all needed files are compressed & click OK
	      |___ OK & check application is setup as required and works correctly.

Distribute application to clients after testing

**********  Custom Setup with Batch Scripts  **********

"build_via_batch_iexpress.bat" Can be used to create a custom IExpress build.
Before executing the batch file, manually edit it and the "SCPrompt.SED" file found in the "build_resources" directory.

"build_via_batch_7zip.cmd" Can be used to create a custom 7zip build.
Before executing the batch file, manually edit it as it creates a EXE based on the contents of the "scprompt" sub-directory.
You can change the icon (created by this method) by editing the "7z_v2m.sfx" (in a resource editor such as reshacker), which is found in the "build_resources" Directory.
This script also uses the "7z_sfx_config.txt" file found in the "build_resources" Directory, This file governs what is executed after extraction of the 7zip SFX EXE.


**********  Manual Configure  **********
All customisable files are located in the scprompt directory, anything altered outside of this directory is at you own risk ...

Settings_Manager.exe is launched by Build_SCPrompt_7zip.exe (second question) if needed,
	and this application creates all the settings that are needed to run scprompt without manually editing any INI files.

scprompt.ini file (scprompt\scprompt.ini)
	This file contains many settings that can help people customise the look and feel of scprompt

Logo Files (scprompt\Logo.jpg & scprompt\Logo[X].jpg)
	If predefined connections are used, the GUI resizes to allow for Logo images, additonal text labels and inputs to be added.
	The Logo Images are the same size as the original SC ones (196 x 181) and can be customised as you see fit.
	If Logo.jpg file exists (and pre-defined connections setup), it is loaded on application start
	(or if no connection specific Logo[X].jpg file can be found).

No Image File (scprompt\NoImage.jpg)
	If Logo files are not available, a NoImage file can be setup (is included in this RYO distrobution).

Selectable GUI_type
	The scprompt.INI contains the ability to setup several different types of GUI:
	1) scprompt Original (similar to the original)
	2) scprompt Combo (has a drop-box with predefined connections listed in it and manual {optional})
	3) scprompt Radio (has radio items for the predefined connections and manual {optional})
	4) scprompt Button (has big easy-to-press buttons for the predefined connections)
	5) scprompt connect (has a count-down timer window that automatically connects to whatever predefined connection you want)

	GUI #1 can be enabled by setting UsePredefined=0 within the scprompt.INI (SC Section)
	GUI #2 can be enabled by setting UsePredefined=1 within the scprompt.INI (SC Section) and GUI_Type=Combo within the scprompt.INI (GUI Section)
	GUI #3 can be enabled by setting UsePredefined=1 within the scprompt.INI (SC Section) and GUI_Type=Radio within the scprompt.INI (GUI Section)
	GUI #4 can be enabled by setting UsePredefined=1 within the scprompt.INI (SC Section) and GUI_Type=Button within the scprompt.INI (GUI Section)

Automatic Connections (GUI #5 above)
	The application can be setup to automatically connect to a pre-defined connection (gives a count down timer for 5 seconds with a stop button)
	this is done using commandline arguments "-c [X]" where [X] is the predefined connection number.
	eg "-c 0" connects to the first connection
	eg "-c 1" connects to the second connection, and so on...

the testing builder is setup to ask for commandline arguments. If none are needed, ignore this option.


**********  Testing  **********
The Builder gives the option to run the application during the build process.
	If this test is unsuccessful, you can close the builder before actually building the distrobution app.

All testing is done by starting the application either normally (by double clicking on the app in the scprompt directory)
	or by using the command prompt to change directory (cd) into the scprompt directory and run the arguments required (eg "scprompt -c 0")

**********  Build  **********
there are two options when building:
	1) Build_SCPrompt_7zip.exe
	2) build_with_7zip.cmd

Option 1) is the new "Build_SCPrompt_7zip.exe" executable which is a multipurpose 7zip self executing exe builder
	(customised by using "Build_7z_exe.ini"). this is a fairly simple builder which is very crude, but it works well for most people (at least those that have commented).
	This uses the build_resources\7-zip32.dll & build_resources\7z_v2m.sfx & build_resources\upx.exe but builds its own temp\sfx_config.txt file from the options in INI (or asked of user)

Option 2) is the old school batch script which is left in the package to make it much easier for most people to understand 
	the build process and customise to their needs. This uses the build_resources\7za.exe & build_resources\7z_v2m.sfx & build_resources\7z_sfx_config.txt


**********  Feedback and Future  **********
All feedback can be directed to JDaus by means of:
	a forum post on ultravnc website (forum.ultravnc.info),
	by posting or PM on the vnc2me website (www.vnc2me.org). the choice is yours...

as for the future ... no imediate plans for changing things, but will see what people can come up with, and what i like.

if you want to change something in the source, be my guest, i enjoy seeing where others take my humble beginnings ...
all i ask is that you send me your code, so i can learn how you have done things, and see if i want to include the changes.

enjoy the work i and others have done.
JDaus


**********  History  **********
0.9.9.30
	-	Source is now included in all Alpha releases as a resource (open reshacker, and take a look around) - will try to remember to remove for betas ... 
	-	Added TraySetStateShow ([GUI] Section) 'readonly' INI setting that allows flexability icon displaying (showing, flashing or even hiding) - these should be set to the appropriate number for the AutoIT 'TraySetState()' function
	-	Added TraySetStateFlash ([GUI] Section) 'readonly' INI setting that allows flexability icon displaying (showing, flashing or even hiding) - these should be set to the appropriate number for the AutoIT 'TraySetState()' function
	-	Added AppReRunTimer ([Common] Section) 'readonly' INI setting that allows flexability in re-runnning the vnc server after it closes. (default 30 seconds)
	-	App now waits 30 seconds (default - see above timer setting) before starting the icon tray flashing ... (bi-product of above coding ... but i like it)
	-	Added autoreconnect ([Common] Section) 'readonly' INI setting that allows users to disable the automatic reconnection feature if required
	-	Added Encryption support if fileexists(MSRC4Plugin.dsm) in the same directory and UseSC_Server = 0 (untested)
	-	Added translations 
	-	Made v2m_lang.ini a UTF-8 format to support any language characters.

0.9.9.31
	-	Replaced SFX file that contained potential virus

0.9.10.32
	-	Fixed Removal of Temporary files (if @scriptdir contains @tempdir ... then remove the whole directory (be careful not to place in root of temp directory ... else whole temp dir will removed) now just leaves an empty "7zXXXX.tmp" directory in %tmp% dir.
	-	Started implementing "Service Mode" (required "UseSC_Server=1" in [Common] Section, and actual server to be used)
		-	Added GUI components
		-	Added OnAutoitExit() function components
		-	Added "ServiceMode" Setting into the [Common] Section of the INI to allow Service mode checkbox to be ticked by default.
	-	Change the Eventlog function to add debuglog and debuglevel variables ... makes it easier to allow more info in log without too much hassle ...

0.9.10.33
	-	Fixed Repeater connections with double colon "::" problem (REF: $Use_UVNC_Connect_Colon)
	-	Added [Common]RemoteINI setting to INI (allows getting scprompt.ini from HTTP, HTTPS or SMB locations for easy updates of configurations (REF: $RemoteINI)
	-	Added and changed eventlog settings so more info is logged if needed (if $DebugLevel = 9 maximum, if $DebugLevel = 1 minimal logging) (REF: V2M_EventLog(), $DebugLevel)
	-	Changed 'Service Mode' to use existing UltraVNC install when installed (instead of trying to install a new one) (REF: _VNCRun(), _VNCServiceMode()$YTS_ServiceMode, $UVNC_ExistingService, $UVNC_ServiceRegRead, $YTS_AdminCheckbox)

0.9.11.34
	-	Added checks for @ExitCode in OnAutoitExit() to add startup icon if windows shutdown or logoff detected, otherwise, looks for startup icon and removes on normal exit.
	-	Updated VISTA code to support Win7 and future versions of windows.
	
0.9.12.35
	-	Added Service Mode to MinGUI
	-	Added Translation for "Service Mode"

0.10.1.36
	-	Fixed _Language() function to allow manual override of automatic language selections
	-	Added "-sm X" cmdline arguement to change servicemode checkbox (and usage) to be checked (1) or not (0). was a feature request. (X is either 0 or 1)
	-	Added EventLog() function to the builder to help better diagnose problems.

0.10.5.38
	-	Added Iexpress options to builder, allowing for better WIN_7 integration.
	-	Fixed Several 

0.10.6.40
	-	Added Several Settings to Translation System
	-	Added "Tools" TrayMenu with several options:
		1)	"Force Remove" - Uninstalls current Service & removes service_commandline from the Ultravnc.ini in the service directory
		2)	"Driver Install" - is not yet functional, but will install mirror driver upon detection of no.
		3)	"Check for Updates" - is designed to allow users to check for updates easily from the traymenu. (use update URL setting in INI to setup your own update INI location.
	-	"Service Mode" Has been reworked, allowing better integration & error handling.
	-	FIXED problem with building using IEpress "Not including last file"
	-	FIXED "-debuglog" commandline option should work properly now. Will also try to delete the log file on running application with debuglog option set (via commandline or hard coded).
	
0.10.8.41
	-	Fixed Logo resizing issue when switching from manual back to predefined (Radio GUI)
	-	Fixed sc_prompt bug which made no prompt appear at the viewer.
	-	Added "TRAYTIP_CONFIG_DOWNLOAD" to the translation system for when scprompt.ini is downloaded from a website or network share.

0.10.11.45
	-	Changed -Tray icon from user level app, hides if re-runnning as admin (saves two icons being displayed)
	-	Changed - UsePredefined INI setting is now ignored (GUIType=Manual now replaces UsePredefined=0)
	-	Fixed - error with $INI_Use_Existing_sc_prompt=0, was not using -sc_prompt for any service mode, even when we installed the service ourselves

