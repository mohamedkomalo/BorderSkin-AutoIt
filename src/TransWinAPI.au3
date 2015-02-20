#include-once
#Include <WinAPI.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <SendMessage.au3>

Global Const $tagTRACKMOUSEEVENT = "dword Size;dword Flags;hwnd hWndTrack;dword HoverTime"

Global Const $TME_CANCEL = 0x80000000
Global Const $TME_HOVER = 0x1
Global Const $TME_LEAVE = 0x2
Global Const $TME_NONCLIENT = 0x10
Global Const $TME_QUERY = 0x40000000

Global Const $WS_EX_NOINHERITLAYOUT	= 0x100000
Global Const $AC_SRC_OVER 		= 0x00
Global Const $AC_SRC_ALPHA 		= 0x01



Global Const $WA_INACTIVE		= 0
Global Const $WA_ACTIVE			= 1
Global Const $WA_CLICKACTIVE	= 2
Global Const $SM_CXFIXEDFRAME	= 7
;Global Const $SM_CYCAPTION		= 4
;Global Const $WM_MOVING 		= 0x0216
;Global Const $WM_ENTERIDLE 		= 0x0121
;Global Const $WM_RBUTTONDOWN	= 0x0204 



Global Const $SC_UPSIZE			= 0xf003
Global Const $SC_LEFTSIZE		= 0xf001
Global Const $SC_RIGHTSIZE		= 0xf002
Global Const $SC_DNSIZE			= 0xf006
Global Const $SC_DNLEFTSIZE		= 0xf007
Global Const $SC_DNRIGHTSIZE	= 0xf008

Global Const $ICON_SMALL		= 0
Global Const $ICON_BIG			= 1
Global Const $ICON_SMALL2		= 2
Global Const $GCL_CBCLSEXTRA	= -20
Global Const $GCL_CBWNDEXTRA	= -18
Global Const $GCL_HBRBACKGROUND	= -10
Global Const $GCL_HCURSOR		= -12
Global Const $GCL_HICON			= -14
Global Const $GCL_HICONSM		= -34
Global Const $GCL_HMODULE		= -16
Global Const $GCL_MENUNAME		= -8
Global Const $GCL_STYLE			= -26
Global Const $GCL_WNDPROC		= -24
Global Const $MSGF_DIALOGBOX	= 0
Global Const $LAYOUT_RTL		= 0x00000001

Global Const $SIZE_RESTORED		= 0
Global Const $SIZE_MINIMIZED	= 1
Global Const $SIZE_MAXIMIZED	= 2
Global Const $SIZE_MAXSHOW		= 3
Global Const $SIZE_MAXHIDE		= 4

Global Const $HSHELL_WINDOWCREATED = 1;
Global Const $HSHELL_WINDOWDESTROYED = 2;
Global Const $HSHELL_ACTIVATESHELLWINDOW = 3;
Global Const $HSHELL_WINDOWACTIVATED = 4;
Global Const $HSHELL_GETMINRECT = 5;
Global Const $HSHELL_REDRAW = 6;
Global Const $HSHELL_TASKMAN = 7;
Global Const $HSHELL_LANGUAGE = 8;
Global Const $HSHELL_SYSMENU = 9;
Global Const $HSHELL_ENDTASK = 10;
Global Const $HSHELL_ACCESSIBILITYSTATE = 11;
Global Const $HSHELL_APPCOMMAND = 12;
Global Const $HSHELL_WINDOWREPLACED = 13;
Global Const $HSHELL_WINDOWREPLACING = 14;
Global Const $HSHELL_RUDEAPPACTIVATED = 32772;
Global Const $HSHELL_FLASH 			= 32774
;GDIPlus Varibles
Global Const $InterpolationModeHighQualityBilinear = 6;

Func _WinAPI_SetSystemCursor($hCur, $iId)
    Local $Ret = DllCall("user32.dll", "int", "SetSystemCursor", "hwnd", $hCur, "DWORD", $iId)
    Return $Ret[0]
EndFunc

Func _WinAPI_LoadCursor($hInstance, $lpCursorName)
    Local $Ret = DllCall("user32.dll", "hwnd", "LoadCursor", "ptr", $hInstance, "str", $lpCursorName)
    Return $Ret[0]
EndFunc

Func _WinAPI_WindowFromPointMode($iX, $iY)
    Local $Ret = DllCall("user32.dll", "int", "WindowFromPoint", "long", $iX, "long", $iY)
    Return HWnd($Ret[0])
EndFunc

Func _WinAPI_SetLayout($hDC,$dwLayout)
	Local $aResult = DllCall("gdi32.dll", "dword", "SetLayout", "hwnd", $hDC, "dword", $dwLayout)
	Return $aResult[0] <> 0
EndFunc

Func _WinAPI_GetSystemMenu($hWnd, $fRevert = False)
	Local $aResult = DllCall("User32.dll", "hwnd", "GetSystemMenu", "hwnd", $hWnd, "int", $fRevert)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_GetSystemMenu

Func _WinAPI_SetStretchBltMode($hDC,$iStretchMode)
	Local $aResult = DllCall("GDI32.dll", "int", "SetStretchBltMode", "hwnd", $hDC, "int", $iStretchMode)
	Return $aResult[0] <> 0
EndFunc

Func _WinAPI_StretchBlt($hDestDC, $iXDest, $iYDest, $iWidthDest, $iHeightDest, $hSrcDC, $iXSrc, $iYSrc, $iWidthSrc, $iHeightSrc, $iROP)
	Local $aResult = DllCall("GDI32.dll", "int", "StretchBlt", _
			"hwnd", $hDestDC, "int", $iXDest, "int", $iYDest, "int", $iWidthDest, "int", $iHeightDest, _
			"hwnd", $hSrcDC, "int", $iXSrc, "int", $iYSrc, "int", $iWidthSrc, "int", $iHeightSrc, "int", $iROP)
	If @error Then Return SetError(@error, 0, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_WinAPI_StretchBlt

Func _WinAPI_SetMenu($hWnd, $hMenu)
	Local $aResult = DllCall("user32.dll", "int", "SetMenu", "hwnd", $hWnd, "hwnd", $hMenu)
	If @error Then Return SetError(@error, 0, False)
	Return $aResult[0] <> 0
EndFunc   ;==>_WinAPI_StretchBlt

Func _WinAPI_GetMenu($hWnd)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetMenu", "hwnd", $hWnd)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_StretchBlt

Func _WinAPI_IsMenu($hMenu)
	Local $aResult = DllCall("user32.dll", "int", "IsMenu", "hwnd", $hMenu)
	Return $aResult[0] <> 0
EndFunc   ;==>_WinAPI_StretchBlt

Func _WinAPI_AlphaBlend ($hdcDest, $nXOriginDest, $nYOriginDest, $nWidthDest, $nHeightDest, _
						 $hdcSrc,  $nXOriginSrc,  $nYOriginSrc,  $nWidthSrc,  $nHeightSrc, $blendFunction )
	If IsDllStruct($blendFunction) Then
		Local $data = DllStructCreate("dword",DllStructGetPtr($blendFunction))
		$data = DllStructGetData($data,1)
	ElseIf IsPtr($blendFunction) Then
		Local $data = DllStructCreate("dword",$blendFunction)
		$data = DllStructGetData($data,1)
	Else
		$data = $blendFunction
	EndIf
	Local $aRes = DllCall ("Msimg32.dll", 'int', 'AlphaBlend', _
												'hwnd', $hdcDest,      _  ;  // handle to destination DC
												'int', $nXOriginDest, _  ;  // x-coord of upper-left corner
												'int', $nYOriginDest, _  ;  // y-coord of upper-left corner
												'int', $nWidthDest,   _  ;  // destination width
												'int', $nHeightDest,  _  ;  // destination height
												'hwnd', $hdcSrc,       _  ;  // handle to source DC
												'int', $nXOriginSrc,  _  ;  // x-coord of upper-left corner
												'int', $nYOriginSrc,  _  ;  // y-coord of upper-left corner
												'int', $nWidthSrc,    _  ;  // source width
												'int', $nHeightSrc,   _  ;  // source height
												'dword', $data);$blendFunction)   ;  // alpha-blending function
	Return $aRes[0]

EndFunc

Func _WinAPI_TrackMouseEvent($pTrackMouseEvent)
	$aResult = DllCall("user32.dll", "int", "TrackMouseEvent", "ptr", $pTrackMouseEvent)
	Return $aResult[0]
EndFunc

Func AddImageToMenu($ParentMenu, $IndexType, $MenuIndex, $BitmapMenu)
    $hBmpMenu = DllCall("user32.dll", "hwnd", "LoadImage", "hwnd", 0, _
                                                           "str", $BitmapMenu, _
                                                           "int", $IMAGE_BITMAP, _
                                                           "int", 0, _
                                                           "int", 0, _
                                                           "int", BitOR($LR_LOADFROMFILE, $LR_LOADMAP3DCOLORS))
    $hBmpMenu = $hBmpMenu[0]
    DllCall("user32.dll", "int", "SetMenuItemBitmaps", "hwnd", GUICtrlGetHandle($ParentMenu), _
                                                       "int",  $MenuIndex, _
                                                       "int",  $IndexType, _
                                                       "hwnd", $hBmpMenu, _
                                                       "hwnd", $hBmpMenu)
EndFunc

Func _WinAPI_TransparentBlt($hDestDC, $iXDest, $iYDest, $iWidthDest, $iHeightDest, $hSrcDC, $iXSrc, $iYSrc, $iWidthSrc, $iHeightSrc, $crTransparent )
	Local $aResult = DllCall("Msimg32.dll", "int", "TransparentBlt", _
			"hwnd", $hDestDC, "int", $iXDest, "int", $iYDest, "int", $iWidthDest, "int", $iHeightDest, _
			"hwnd", $hSrcDC, "int", $iXSrc, "int", $iYSrc, "int", $iWidthSrc, "int", $iHeightSrc, "uint", $crTransparent )
	Return @error;$aResult[0]
EndFunc   ;==>_WinAPI_StretchBlt

Func _WinAPI_TextOut($hDC, $iXStart, $iYStart, $lpString)
	Local $aResult = DllCall("Gdi32.dll", "int", "TextOut", _
			"hwnd", $hDC, "int", $iXStart, "int", $iYStart, "str*", $lpString, "int", StringLen($lpString))
	Return $aResult[0]
EndFunc   ;==>_WinAPI_StretchBlt


Func _WinAPI_GetUpdateRgn($hWnd,$hRgn,$bRedraw)
    Local $aResult = DllCall("User32.dll", "int", "GetUpdateRgn", "hwnd", $hWnd, "hwnd", $hRgn,"int", $bRedraw)
	Return $aResult[0]
EndFunc

Func _WinAPI_ValidateRgn($hWnd,$hRgn)
    Local $aResult = DllCall("User32.dll", "int", "ValidateRgn", "hwnd", $hWnd, "hwnd", $hRgn)
	Return $aResult[0]
EndFunc

Func _WinAPI_InvalidateRgn($hWnd,$hRgn,$bErase)
    Local $aResult = DllCall("User32.dll", "int", "InvalidateRgn", "hwnd", $hWnd, "hwnd", $hRgn,"int",$bErase)
	Return $aResult[0]
EndFunc

Func _WinAPI_GetClassLong($hWnd,$nIndex)
    Local $aResult = DllCall("User32.dll", "dword", "GetClassLong", "hwnd", $hWnd, "int", $nIndex)
	Return $aResult[0]
EndFunc

Func _WinAPI_SetWindowTheme($hWnd,$pszSubAppName,$pszSubIdList)
    Local $aResult = DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", $hWnd, "wstr", $pszSubAppName, "wstr", $pszSubIdList)
	Return $aResult[0]
EndFunc

Func _WinAPI_DrawIconExMod($hDC, $iX, $iY, $hIcon, $iWidth = 0, $iHeight = 0, $iStep = 0, $hBrush = 0, $iFlags = 3)
	Local $iOptions, $aResult
	Switch $iFlags
		Case 1
			$iOptions = $__WINAPCONSTANT_DI_MASK
		Case 2
			$iOptions = $__WINAPCONSTANT_DI_IMAGE
		Case 3
			$iOptions = $__WINAPCONSTANT_DI_NORMAL
		Case 4
			$iOptions = $__WINAPCONSTANT_DI_COMPAT
		Case 5
			$iOptions = $__WINAPCONSTANT_DI_DEFAULTSIZE
		Case Else
			$iOptions = $__WINAPCONSTANT_DI_NOMIRROR
	EndSwitch
	$aResult = DllCall("User32.dll", "int", "DrawIconEx", "hwnd", $hDC, "int", $iX, "int", $iY, "hwnd", $hIcon, "int", $iWidth, _
			"int", $iHeight, "uint", $iStep, "hwnd", $hBrush, "uint", $iOptions)
	Return $aResult[0] <> 0
EndFunc   ;==>_WinAPI_DrawIconEx

Func _WinAPI_RealChildWindowFromPoint($hwndParent,$iX,$iY)
	$aResult = DllCall("User32.dll", "hwnd", "RealChildWindowFromPoint", "hwnd", $hwndParent, "int", $iX, "int", $iY)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_WindowFromPoint

Func _WinAPI_SetActiveWindow($hWnd)
	$aResult = DllCall("User32.dll", "hwnd", "SetActiveWindow", "hwnd", $hWnd)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_WindowFromPoint

Func _WinAPI_AnimateWindow($hWnd,$dwTime,$dwFlags)
	$aResult = DllCall("User32.dll", "int", "AnimateWindow", "hwnd", $hWnd,"int",$dwTime,"int",$dwFlags)
	Return $aResult[0] <> 0
EndFunc   ;==>_WinAPI_WindowFromPoint