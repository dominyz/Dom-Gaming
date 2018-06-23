#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, , H ;if unstable, comment or remove this line
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
wintitle = Diablo III
SetTitleMatchMode, 2
#SingleInstance Force

toggle = 0
toggle2 = 0

#MaxThreadsPerHotkey 3

    ;Lag and paragon settings
    sleepTimer := 60 ;Sleep timer change based on ping
    vitTimer := 60 ;Sleep timer change for ping just for vit clicks
	;Settings for damage
    dmgMainStat := 52 ;Value for mainstat to put in
    dmgVitality := 0 ;Value for vitality to put in
    dmgMovement := 0 ;Value for vitality to put in
    dmgResource := 25 ;Value for vitality to put in
	;Settings for survival
    zdmgMainStat := 0 ;Value for mainstat to put in
    zdmgVitality := 52 ;Value for vitality to put in
    zdmgMovement := 25 ;Value for vitality to put in
    zdmgResource := 0 ;Value for vitality to put in

    ;Defense tab settings
    defensesTabX := 1070 ;Defense tab X coordinate
    defenseseTabY := 100 ;Defense tab Y coordinate
    defenseResetX := 956 ;Defense Reset button X coordinate
    defenseResetY := 732 ;Defense Reset button Y coordinate
    regenSetX := 1274 ;Regen button X coordinate
    regenSetY := 610 ;Regen button Y coordinate

    ;Core tab settings Current settings --- 1920x1080
    coreTabX := 808 ;Core Tab X coordinate
    coreTabY := 145 ;Core Y coordinate
    coreResetX := 1274 ;Core Reset button X coordinate
    coreResetY := 974 ;Core Reset button Y coordinate
    vitX := 1702 ;Vit button X coordinate
    vitY := 569 ;Vit button Y coordinate
    dexX := 1702 ;Dex button X coordinate
    dexY := 448 ;Dex button Y coordinate
    movX := 1702 ;mov button X coordinate
    movY := 692 ;mov button Y coordinate
    sprtX := 1702 ;spirit button X coordinate
    sprtY := 815 ;spirit button Y coordinate

    acceptX := 1102 ;Accept button X coordinate
    acceptY := 1086 ;Accept button Y coordinate

#ifWinActive Diablo III
{

F1::
    BlockInput On

;Paragon script
    MouseGetPos, mouseX, mouseY
    Send x
    Send p
    Sleep, sleepTimer
    MouseClick, Left, coreTabX, coreTabY ;click core tab
    Sleep, sleepTimer
    MouseClick, Left, coreResetX, coreResetY ;click core reset
    Sleep, 120

    Send, {Shift Down}
    Sleep, vitTimer
    Loop %dmgResource% ;set the max resource
    {
        MouseClick, Left, sprtX, sprtY
    }

    Send, {Shift Up}
    Sleep, vitTimer
    Send, {Ctrl Down}
    Sleep, vitTimer
    Loop %dmgMainStat% ;set the main stat
    {
        MouseClick, Left, dexX, dexY
    }
    Sleep, 60
    Send, {Ctrl Up}
    MouseClick, Left, acceptX, acceptY ;click accept
    MouseMove, mouseX, mouseY, 0
    BlockInput Off
return

}

#ifWinActive Diablo III
{

F3::
    BlockInput On

;Paragon script
    MouseGetPos, mouseX, mouseY
    Send x
    Send p
    Sleep, sleepTimer
    MouseClick, Left, coreTabX, coreTabY ;click core tab
    Sleep, sleepTimer
    MouseClick, Left, coreResetX, coreResetY ;click core reset
    Sleep, 120

    Send, {Shift Down}
    Sleep, vitTimer
    Loop %zdmgMovement% ;set the movement
    {
        MouseClick, Left, movX, movY
    }

    Send, {Shift Up}
    Sleep, vitTimer
    Send, {Ctrl Down}
   
    Sleep, vitTimer
    Loop %zdmgVitality% ;set the vitality
    {
        MouseClick, Left, vitX, vitY
    }

    Sleep, 60
    Send, {Ctrl Up}
    MouseClick, Left, acceptX, acceptY ;click accept
    MouseMove, mouseX, mouseY, 0
    BlockInput Off
return

}