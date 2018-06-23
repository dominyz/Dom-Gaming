#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#IfWinActive, ahk_class D3 Main Window Class

ListLines Off
Process, Priority, , H
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input

#ctrls = 3
SetWorkingDir %A_ScriptDir%

global ColumnCount := 0
, RowCount := 0
, Cycles := 0


IfNotExist, Starpact.ini
FileAppend,
(
[Settings]
Electrocutetimer=1900
Channeltimer=425
Refilltimer=940
Pausetimer=2400
[Hotkeys]
1=5
2=2
3=1
), Starpact.ini

IniRead, Electrocutetimer, Starpact.ini, Settings, Electrocutetimer
IniRead, Channeltimer, Starpact.ini, Settings, Channeltimer
IniRead, Refilltimer, Starpact.ini, Settings, Refilltimer
IniRead, Pausetimer, Starpact.ini, Settings, Pausetimer

GUI, Add, Text, xm, With default settings, you should start the meteor 
GUI, Add, Text, xm, sequence between 2 and 3 o'clock in lightning
GUI, Add, Text, xm, -----------------------------------------------------------------

Loop,% #ctrls 
{
	If (A_Index == 1)
		GUI, Add, Text, xm, Hotkey to hold for Starpact sequence:
		
	If (A_Index == 2)
		GUI, Add, Text, xm, Hotkey for Meteor:
	
	If (A_Index == 3)
		GUI, Add, Text, xm, Hotkey for Wave of Force:
	
	IniRead, savedHK%A_Index%, Starpact.ini, Hotkeys, %A_Index%, %A_Space%	;Check for saved hotkeys in INI file.
	If savedHK1                                      				;Activate saved hotkeys if found.
		Hotkey,% savedHK1, Label1                			;Remove tilde (~) and Win (#) modifiers...
	
	StringReplace, noMods, savedHK%A_Index%, ~                 				;They are incompatible with hotkey controls (cannot be shown).
	GUI, Add, Hotkey, x+5 vHK%A_Index% gGuiLabel, %noMods%        			;Add checkboxes to allow the Windows key (#) as a modifier...
}  
GUI, Add, Text, xm, Electrocute timer [ms]:
GUI, Add, Edit, x+5 Limit4 Number gSubmit vElectrocutetimer, %Electrocutetimer%
GUI, Add, Text, xm, Refill arcane power before channeling timer [ms]:
GUI, Add, Edit, x+5 Limit4 Number gSubmit vRefilltimer, %Refilltimer%
GUI, Add, Text, xm, Channeling timer [ms]:
GUI, Add, Edit, x+5 Limit4 Number gSubmit vChanneltimer, %Channeltimer%
GUI, Add, Text, xm, Refill/pause after 4th meteor 
GUI, Add, Text, xm, to ensure max AP in 1st Arcane[ms]:
GUI, Add, Edit, x+5 Limit4 Number gSubmit vPausetimer, %Pausetimer%
Return

F2::
Sleep 200
GUI, Show,,Starpact script
Return

Submit:
GUIControlGet, Electrocutetimer
IniWrite, %Electrocutetimer%, Starpact.ini, Settings, Electrocutetimer
GUIControlGet, Channeltimer
IniWrite, %Channeltimer%, Starpact.ini, Settings, Channeltimer
GUIControlGet, Refilltimer
IniWrite, %Refilltimer%, Starpact.ini, Settings, Refilltimer
GUIControlGet, Pausetimer
IniWrite, %Pausetimer%, Starpact.ini, Settings, Pausetimer
Return

GuiClose:
GUI, Hide
IfWinExist, ahk_class D3 Main Window Class
	WinActivate, ahk_class D3 Main Window Class
Return

~ESC::Reload
Return

Label1:
IfWinActive, ahk_class D3 Main Window Class
{
IfWinNotActive, CubeConverter Hotkeys
{
Electrocute25 := Electrocutetimer / 4 ;Timer splits for quicker release when key is depressed
Refill50 := Refilltimer / 2
Pause25 := Pausetimer / 4
Channel100 := Channeltimer
StringReplace, SEQKEYCHECK, savedHK1, ~ ;Remove tilde to use hotkeys
StringReplace, METKEYCHECK, savedHK2, ~
StringReplace, WOFKEYCHECK, savedHK3, ~
While GetKeyState(SEQKEYCHECK, "P")
{Loop, 4		
		{
		Send {Shift Down}
		Send %WOFKEYCHECK%
		Send {LButton Down}
		if not GetKeyState(SEQKEYCHECK, "P")
		break
		DllCall("Sleep", UInt, Electrocute25)
		if not GetKeyState(SEQKEYCHECK, "P")
		break
		DllCall("Sleep", UInt, Electrocute25)
		if not GetKeyState(SEQKEYCHECK, "P")
		break
		DllCall("Sleep", UInt, Electrocute25)
		if not GetKeyState(SEQKEYCHECK, "P")
		break
		DllCall("Sleep", UInt, Electrocute25)
		Send %METKEYCHECK%
		DllCall("Sleep", UInt, 20)
		Send {LButton Down}
		if not GetKeyState(SEQKEYCHECK, "P")
		break
		DllCall("Sleep", UInt, Refill50)
		if not GetKeyState(SEQKEYCHECK, "P")
		break
		DllCall("Sleep", UInt, Refill50)
		Send {LButton Up}
		DllCall("Sleep", UInt, 20)
		Send {RButton Down}
		if not GetKeyState(SEQKEYCHECK, "P")
		break
		DllCall("Sleep", UInt, Channel100)
		Send {RButton Up}
		}
Send {LButton Down}
if not GetKeyState(SEQKEYCHECK, "P")
		break
DllCall("Sleep", UInt, Pause25)
if not GetKeyState(SEQKEYCHECK, "P")
		break
DllCall("Sleep", UInt, Pause25)
if not GetKeyState(SEQKEYCHECK, "P")
		break
DllCall("Sleep", UInt, Pause25)
if not GetKeyState(SEQKEYCHECK, "P")
		break
DllCall("Sleep", UInt, Pause25)
}
Send {LButton Up}
Send {RButton Up}
Send {Shift Up}
}}
Return

Label2:
Return
Label3:
Return


GuiLabel:
	If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
		return
	If InStr(%A_GuiControl%,"vk07")            ;vk07 = MenuMaskKey (see below)
		GuiControl,,%A_GuiControl%, % lastHK      ;Reshow the hotkey, because MenuMaskKey clears it.
	Else
		validateHK(A_GuiControl)
return

validateHK(GuiControl) 
{
	global lastHK
	Gui, Submit, NoHide
	lastHK := %GuiControl%                     ;Backup the hotkey, in case it needs to be reshown.
	num := SubStr(GuiControl,3)                ;Get the index number of the hotkey control.
	If (HK%num% != "") 						   ;If the hotkey is not blank...
	{                       
		StringReplace, HK%num%, HK%num%, SC15D, AppsKey      ;Use friendlier names,
		StringReplace, HK%num%, HK%num%, SC154, PrintScreen  ;  instead of these scan codes.
		If CB%num%                                ;  If the 'Win' box is checked, then add its modifier (#).
			HK%num% := "#" HK%num%
		If !RegExMatch(HK%num%,"[#!\^\+]")        ;  If the new hotkey has no modifiers, add the (~) modifier.
			HK%num% := "~" HK%num%                   ;    This prevents any key from being blocked.
		checkDuplicateHK(num)
	}
	If (savedHK%num% || HK%num%)               ;Unless both are empty,
		setHK(num, savedHK%num%, HK%num%)         ;  update INI/GUI
}


checkDuplicateHK(num)
{
	global #ctrls
	Loop,% #ctrls
	If (HK%num% = savedHK%A_Index%) 
	{
		dup := A_Index
		Loop,6 
		{
			GuiControl,% "Disable" b:=!b, HK%dup%   ;Flash the original hotkey to alert the user.
			Sleep,200
		}
		GuiControl,,HK%num%,% HK%num% :=""       ;Delete the hotkey and clear the control.
		break
	}
}

setHK(num,INI,GUI) 
{
	If INI                           ;If previous hotkey exists,
		Hotkey, %INI%, Label%num%, Off  ;  disable it.
	If GUI                           ;If new hotkey exists,
		Hotkey, %GUI%, Label%num%, On   ;  enable it.
	IniWrite,% GUI ? GUI:null, Starpact.ini, Hotkeys, %num%
	savedHK%num%  := HK%num%
}

#MenuMaskKey vk07                 ;Requires AHK_L 38+
#If ctrl := HotkeyCtrlHasFocus()
	*AppsKey::                       ;Add support for these special keys,
	*BackSpace::                     ;  which the hotkey control does not normally allow.
	*Delete::
	*Enter::
	*Escape::
	*Pause::
	*PrintScreen::
	*Space::
	*Tab::
	modifier := ""
	If GetKeyState("Shift","P")
		modifier .= "+"
	If GetKeyState("Ctrl","P")
		modifier .= "^"
	If GetKeyState("Alt","P")
		modifier .= "!"
	Gui, Submit, NoHide             ;If BackSpace is the first key press, Gui has never been submitted.
	If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)   ;If the control has text but no modifiers held,
		GuiControl,,%ctrl%                                       ;  allow BackSpace to clear that text.
	Else                                                     ;Otherwise,
		GuiControl,,%ctrl%, % modifier SubStr(A_ThisHotkey,2)  ;  show the hotkey.
	validateHK(ctrl)
	return
#If

HotkeyCtrlHasFocus() 
{
	GuiControlGet, ctrl, Focus       ;ClassNN
	If InStr(ctrl,"hotkey") 
	{
		GuiControlGet, ctrl, FocusV     ;Associated variable
	Return, ctrl
	}
}


