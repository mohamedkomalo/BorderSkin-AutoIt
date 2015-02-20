#include-once
#include <WinAPI.au3>
#include <GDIPlus.au3>
#include <TransWinAPI.au3>

Func CreateStruct($Struct, $Initial1, $Initial2, $Initial3, $Initial4)
	$NewStruct = DllStructCreate($Struct)
	For $i = 1 To 4
		$SetData = DllStructSetData($NewStruct, $i, Eval("Initial" & $i))
	Next
	Return $NewStruct
EndFunc   ;==>CreateStruct

Func _ReduceMemory()
	Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func SetRegion($hWnd)
	Local Const $i_SM_CXFIXEDFRAME = 7, $i_SM_CXVSCROLL = 2, $i_SM_CYCAPTION = 4
	Local $aCaption_Metrics, $aFrame_Metrics, $iCaption_Height, $aClient_Size, $aRectRgn
	
	$aCaption_Metrics = _WinAPI_GetSystemMetrics($i_SM_CYCAPTION)
	$aFrame_Metrics = _WinAPI_GetSystemMetrics($i_SM_CXFIXEDFRAME)
	
	$iCaption_Height = $aCaption_Metrics + $aFrame_Metrics
	$aClient_Size = WinGetPos($hWnd)
	
	$aRectRgn = _WinAPI_CreateRectRgn($aFrame_Metrics, $aCaption_Metrics + $aFrame_Metrics, $aClient_Size[2] - $aFrame_Metrics, $aClient_Size[3] - $aFrame_Metrics)
	$SetRect = _WinAPI_SetWindowRgn($hWnd, $aRectRgn, 1)
	Return $SetRect
EndFunc   ;==>SetRegion

Func _CreateSplashWindow($sImageFile,$Width,$Heigth,$iInterval = 1000)
	$hSplashWnd = GUICreate("", $Width,$Heigth, -1, -1, $WS_POPUP + $WS_BORDER,$WS_EX_TOOLWINDOW)
	GUICtrlCreatePic($sImageFile, 0, 0, $Width,$Heigth)
	_WinAPI_AnimateWindow($hSplashWnd,200,0x00080000)
	Sleep($iInterval)
	_WinAPI_AnimateWindow($hSplashWnd,200,0x00090000)
	GUIDelete($hSplashWnd)
EndFunc

Func WinGetIcon($hWnd)
	Local $hIcon = _SendMessage($hWnd, $WM_GETICON, $ICON_SMALL, 0)
	If Not $hIcon Then $hIcon = _SendMessage($hWnd, $WM_GETICON, $ICON_SMALL2, 0)
	If Not $hIcon Then $hIcon = _WinAPI_GetClassLong($hWnd, $GCL_HICON)
	If Not $hIcon Then $hIcon = _SendMessage($hWnd, $WM_QUERYDRAGICON, 0, 0)
	Return $hIcon
EndFunc

Func Short($iInt)
	Local $tFloat, $tInt
	$tInt = DllStructCreate("int")
	$tFloat = DllStructCreate("short", DllStructGetPtr($tInt))
	DllStructSetData($tInt, 1, $iInt)
	Return DllStructGetData($tFloat, 1)
EndFunc   ;==>_WinAPI_IntToFloat

Func CreateNewDC($Width = @DesktopWidth,$Height = @DesktopHeight)
	Local $hScrDC, $hBMP, $hDC,$aResult[2]
	$hScrDC = _WinAPI_GetDC(0)
	$aResult[0] = _WinAPI_CreateCompatibleBitmap($hScrDC, $Width, $Height )
	$aResult[1] = _WinAPI_CreateCompatibleDC($hScrDC)
	_WinAPI_SelectObject($aResult[1], $aResult[0])
	$hScrDC = _WinAPI_ReleaseDC(0, $hScrDC)
	Return $aResult
EndFunc   ;==>CreateNewBitmap

Func CreateNewGDIGraphics($Width = @DesktopWidth,$Height = 100)
	Local $aResult[2]
	$hScrDC = _WinAPI_GetDC(0)
	$TempBMP = _WinAPI_CreateCompatibleBitmap($hScrDC, $Width , $Height)
	$aResult[0] = _GDIPlus_BitmapCreateFromHBITMAP($TempBMP)
	$aResult[1] = _GDIPlus_ImageGetGraphicsContext($aResult[0])
	DllCall("gdiplus.dll", "int", "GdipSetInterpolationMode", "hwnd", $aResult[1], "int", $InterpolationModeHighQualityBilinear)
	_WinAPI_DeleteObject($TempBMP)
	$hScrDC = _WinAPI_ReleaseDC(0, $hScrDC)
	Return $aResult
EndFunc   ;==>IntializeGDIBitmap