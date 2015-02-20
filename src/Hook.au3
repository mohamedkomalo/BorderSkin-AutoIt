#include-once
#NoTrayIcon
#include <Misc.au3>
#include <Constants.au3>
#include <SkinWindow.au3>
#include <GDIPlus.au3>
#include <TransWinAPI.au3>
#include <SendMessage.au3>
#include <GuiConstantsEx.au3>

Global Const $WM_ACTIVATED_NOTIFY = $WM_USER + 1
Global Const $WM_DEACTIVATED_NOTIFY = $WM_USER + 8
Global Const $WM_SETTEXT_NOTIFY = $WM_USER + 2
Global Const $WM_SETICON_NOTIFY = $WM_USER + 3
Global Const $WM_DESTROY_NOTIFY = $WM_USER + 4
Global Const $MINMAXRES_NOTIFY = $WM_USER + 5
Global Const $WM_SIZE_NOTIFY = $WM_USER + 6
Global Const $WM_MOVE_NOTIFY = $WM_USER + 7
Global Const $WM_SHOWWINDOW_NOTIFY = $WM_USER + 9
Global Const $WM_WINDOWPOSCHANGED_NOTIFY = $WM_USER + 10
Global Const $WM_WINSKIN = _WinAPI_RegisterWindowMessage("WinSkinHook")
Global Const $HOOK_DLL_FILE = @ScriptDir & "\Hook DLL.dll"
Global $HOOK_DLL, $hMsgGUI

Func HookProcStart()
	Global $HOOK_DLL = DllOpen($HOOK_DLL_FILE)
	Global $hMsgGUI = GUICreate("BorderBlur Message Handler GUI")
	SetCallWndHook(1)
	
	GUIRegisterMsg($WM_ACTIVATED_NOTIFY, "MsgProc")
	GUIRegisterMsg($WM_DEACTIVATED_NOTIFY, "MsgProc")
	GUIRegisterMsg($WM_SETTEXT_NOTIFY, "MsgProc")
	GUIRegisterMsg($WM_SETICON_NOTIFY, "MsgProc")
	GUIRegisterMsg($WM_DESTROY_NOTIFY, "MsgProc")
	GUIRegisterMsg($WM_MOVE_NOTIFY, "MsgProc")
	GUIRegisterMsg($WM_SIZE_NOTIFY, "MsgProc")
	GUIRegisterMsg($WM_SHOWWINDOW_NOTIFY, "MsgProc")
	GUIRegisterMsg($WM_WINDOWPOSCHANGED_NOTIFY, "MsgProc")
EndFunc

Func HookProcEnd()
	SetCallWndHook(0)
	If $HOOK_DLL Then DllClose($HOOK_DLL)
EndFunc

Func MsgProc($hWnd, $MsgID, $WParam, $LParam)
	Local $SkinGUI = SkinWindowGetFromParent($LParam)
	If Not $SkinGUI And ( ($MsgID = $WM_ACTIVATED_NOTIFY) ) Then
		_SendMessage($LParam,$WM_WINSKIN,$LParam,0)
		SkinWindowCreate($LParam)
		_WinAPI_SetWindowPos($LParam, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOZORDER, $SWP_NOREPOSITION))
		Return
	EndIf
	If Not $SkinGUI Then Return
	Switch $MsgID
		Case $WM_WINDOWPOSCHANGED_NOTIFY
			If BitAND($WParam,$SWP_HIDEWINDOW) Then SkinWindowShow($SkinGUI,@SW_HIDE)
			If BitAND($WParam,$SWP_SHOWWINDOW) Then SkinWindowShow($SkinGUI,@SW_SHOWNOACTIVATE)
			
		Case $WM_SHOWWINDOW_NOTIFY
			;FileWriteLine("Logss.txt",1)
			;If Not BitAND($WParam,$SWP_NOACTIVATE) Then SkinWindowUpdate($SkinGUI,1)
			
		Case $WM_ACTIVATED_NOTIFY
			$Borders = SkinWindowGetBorders($SkinGUI)
			If $WParam = $Borders[0] Or $WParam = $Borders[1] Or $WParam = $Borders[2] Or $WParam = $Borders[3] Then Return
			;SkinWindowUpdate($SkinGUI,1)
			
			Local $Pos = WinGetPos($LParam)
			$Borders = SkinWindowGetBorders($SkinGUI)
			SkinWindowMove($Borders,$Pos[0],$Pos[1],$Pos[2] ,$Pos[3],1)
			
		Case $WM_DEACTIVATED_NOTIFY
			$Borders = SkinWindowGetBorders($SkinGUI)
			If $WParam = $Borders[0] Or $WParam = $Borders[1] Or $WParam = $Borders[2] Or $WParam = $Borders[3] Then Return
			;SkinWindowUpdate($SkinGUI,0)
			
			Local $Pos = WinGetPos($LParam)
			$Borders = SkinWindowGetBorders($SkinGUI)
			SkinWindowMove($Borders,$Pos[0],$Pos[1],$Pos[2] ,$Pos[3],0)
			
		Case $WM_DESTROY_NOTIFY
			$Borders = SkinWindowGetBorders($SkinGUI)
			GUIDelete($Borders[0])
			GUIDelete($Borders[1])
			GUIDelete($Borders[2])
			GUIDelete($Borders[3])
			SkinWindowDelete($SkinGUI)
			
		Case $WM_SIZE_NOTIFY
			_SendMessage($LParam,$WM_WINSKIN,$LParam,0)
			Local $Pos = WinGetPos($LParam)
			$Borders = SkinWindowGetBorders($SkinGUI)
			SkinWindowMove($Borders,$Pos[0],$Pos[1],$Pos[2] ,$Pos[3])
			
		Case $WM_MOVE_NOTIFY
			Local $Pos = WinGetPos($LParam)
			$Borders = SkinWindowGetBorders($SkinGUI)
			SkinWindowMove($Borders,$Pos[0],$Pos[1],$Pos[2] ,$Pos[3])
			
		Case $WM_SETTEXT_NOTIFY,$WM_SETICON_NOTIFY
			;SkinWindowUpdate($SkinGUI,1)
			
			Local $Pos = WinGetPos($LParam)
			$Borders = SkinWindowGetBorders($SkinGUI)
			SkinWindowMove($Borders,$Pos[0],$Pos[1],$Pos[2] ,$Pos[3],1)
		#cs	
		Case $WM_SETTEXT_NOTIFY
			Local $Pos = WinGetPos($LParam)
			$Borders = SkinWindowGetBorders($SkinGUI)
			
			$aCaption_Metrics = _WinAPI_GetSystemMetrics($SM_CYCAPTION)
			$aFrame_Metrics = _WinAPI_GetSystemMetrics($SM_CXFIXEDFRAME)
			$iCaption_Height = $aCaption_Metrics + $aFrame_Metrics
			Local $X = ($Pos[0] + $aFrame_Metrics) - $LeftWidth, $Y = ($Pos[1] + $iCaption_Height) - $TopHeight
			Local $Width = ($Pos[2] - ($aFrame_Metrics * 2) ) + $RightWidth + $LeftWidth ,$Height = ($Pos[3] + ($aFrame_Metrics * 2) ) + $BottomHeight + $TopHeight
			;SkinWindowMove($Borders,$X,$Y,$Width,$Height)
			
			SkinWindowUpdate($SkinGUI,1)
			;SkinWindowUpdate($SkinGUI,Default)
			;$Borders = SkinWindowGetBorders($SkinGUI)
			;If IsArray($Borders) Then ;SkinWindowRepaint($Borders[0],$SKIN_TOP,0,Default)
			
		Case $WM_SETICON_NOTIFY
			;SkinWindowUpdate($SkinGUI,1)
			;SkinWindowRepaint($SkinGUI,$SKIN_TOP)
			#ce
	EndSwitch
EndFunc   ;==>CHECKALL

Func SetCallWndHook($bFlag)
	Local $sFunc = 'RemoveHook'
	If $bFlag Then $sFunc = 'SetHook'
	Local $aRet = DllCall($HOOK_DLL, 'int', $sFunc)
	
	If IsArray($aRet) Then Return $aRet[0]
	Return $aRet
EndFunc   ;==>_SetHook