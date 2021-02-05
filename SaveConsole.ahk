#SingleInstance, force
Menu, Tray, NoStandard
Menu, Tray, Add, &History, OpenHistory
Menu, Tray, Add 
Menu, Tray, Add, &Salir, ExitApplication
; Sets up the hook to tell Windows to run ShellMessage function in this script when a Shell Hook event occurs
DllCall( "RegisterShellHookWindow", UInt, A_ScriptHwnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage" )
Return

ExitApplication:
ExitApp
return

OpenHistory:
EnvGet, vUserProfile, USERPROFILE
Run, %vUserProfile%/command_history.log
return

ShellMessage( wParam,lParam )	; Gets all Shell Hook messages
{
	If ( wParam = 1 ) ;  HSHELL_WINDOWCREATED := 1 ; Only act on Window Created messages
	{
		wId:= lParam				; wID is Window Handle
		WinGetTitle, wTitle, ahk_id %wId%	; wTitle is Window Title
		WinGetClass, wClass, ahk_id %wId%	; wClass is Window Class
		WinGet, wExe, ProcessName, ahk_id %wId%	; wExe is Window Execute
		if (wClass = "ConsoleWindowClass" || wExe = "cmd.exe")			; Only act on the specific Window
		{
			DisableCloseButton(wId)
			Sleep, 100
			DisableCloseButton(wId)
			Hotkey, IfWinActive, ahk_class ConsoleWindowClass
			Hotkey, !F4, SinkClose
		}
	}
}

; Skan (https://autohotkey.com/board/topic/80593-how-to-disable-grey-out-the-close-button/)
DisableCloseButton(hWnd) 
{
	hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE)
	nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
	DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-1,"Uint","0x400")
	DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-2,"Uint","0x400")
	DllCall("DrawMenuBar","Int",hWnd)
	Return 
}

SinkClose:
wId:=WinExist("A")
SendInput,^c
ControlSend,,exit, ahk_id %wId%
Sleep, 100
ControlSend,,{Enter}, ahk_id %wId%
Sleep, 100
WinClose, ahk_id %wId%
WinKill, ahk_id %wId%
return

#If (WinActive("ahk_class ConsoleWindowClass") && WM_NCHITTEST("CLOSE"))
LButton::
GoSub, SinkClose
return
#If

WM_NCHITTEST(test="")
{
   CoordMode, Mouse, Screen
   MouseGetPos, x, y, z
   SendMessage, 0x84, 0, (x&0xFFFF)|(y&0xFFFF)<<16,, ahk_id %z%
   RegExMatch("ERROR TRANSPARENT NOWHERE CLIENT CAPTION SYSMENU SIZE MENU HSCROLL VSCROLL MINBUTTON MAXBUTTON LEFT RIGHT TOP TOPLEFT TOPRIGHT BOTTOM BOTTOMLEFT BOTTOMRIGHT BORDER OBJECT CLOSE HELP", "(?:\w+\s+){" . ErrorLevel+2&0xFFFFFFFF . "}(?<AREA>\w+\b)", HT)
   if(test=="")
      Return   HTAREA
   Else
      Return   (HTAREA==test? 1 : 0)
}