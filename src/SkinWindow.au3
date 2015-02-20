
#include-once
#include <Array.au3>
#include <Global.au3>
#include <GDIPlus.au3>
#include <Constants.au3>
#include <Constants.au3>
#include <TransWinAPI.au3>
#include <SendMessage.au3>
#include <GUIConstantsEx.au3>
Opt("WinDetectHiddenText",1)

;==> Skin Windows Array <=================================================================================================================================
Global $SkinWindows[1][5]

Global Const $GUI_TOP = 0,$GUI_LEFT = 1,$GUI_RIGHT = 2,$GUI_BOTTOM = 3
Global Const $GUI_PARENT = 4

;==> Interal Helpers Varibles <============================================================================================================================
Global Const $Cursor_Vertical = 13, $Cursor_Horizontal = 11, $Cursor_LeftRight = 10, $Cursor_RightLeft = 12, $Cursor_Default = 2
Global Const $SKIN_TOP = 1, $SKIN_RIGHT = 2, $SKIN_LEFT = 3, $SKIN_BOTTOM = 4, $SKIN_MAXIMIZEDTOP = 5
Global Const $MIN_HOVER = 1, $MIN_CLICKED = 2, $MAX_HOVER = 3, $MAX_CLICKED = 4, $CLOSE_HOVER = 5, $CLOSE_CLICKED = 6
Global Const $SIZE_UP = 1, $SIZE_LEFT = 2, $SIZE_RIGHT = 3, $SIZE_DN = 3, $SIZE_DNLEFT = 3, $SIZE_DNRIGHT = 3
Global Const $STYLEID_RIGHT = $WS_EX_RTLREADING, $STYLEID_LEFT = $WS_EX_LEFTSCROLLBAR, $STYLEID_BOTTOM = $WS_EX_NOINHERITLAYOUT
Global Const $STYLEID_ANY = BitOR($STYLEID_BOTTOM, $STYLEID_LEFT, $STYLEID_RIGHT)
Global Const $BLUR_VER = 1, $BLUR_HORI = 2
Global Const $ThemesFolder = @ScriptDir & "\Themes\"

Global $NewBMP , $TopBlurImage , $TopBlurClone,$NewTextBMP
Global $TopBlurCloneInfo , $MiddleBlurGraphics , $MiddleBlurImg,$MiddleBlurCloneGraphics,$MiddleBlurCloneImage,$NewGraphics6
Global $MemDC,$TopBlurImg, $TopBlurGraphics, $TopBlurClone, $TopBlurCloneGraphics, $NewGraphics3,$TextDC

Global $xAdd = 0, $yAdd = 0, $WidthAdd = 0, $HeightAdd = 0
Global $MovinghWnd = 0, $HoverWnd = 0

;Theme Files --------------------------------------------------------------------------------------
Global $Reflection, $ReflectionIMG, $ReflectionDC, $ReflectionWidth, $ReflectionHeight, $ReflectionPos,$BlurPos
Global $TopLeft, $TopLeftIMG, $TopLeftDC, $TopLeftWidth, $TopLeftHeight
Global $Top, $TopIMG, $TopDC, $TopWidth, $TopHeight
Global $MaximizedTop, $MaximizedTopIMG, $MaximizedTopDC, $MaximizedTopWidth, $MaximizedTopHeight
Global $TopRight, $TopRightIMG, $TopRightDC, $TopRightWidth, $TopRightHeight
Global $Left, $LeftIMG, $LeftDC, $LeftWidth, $LeftHeight
Global $Right, $RightIMG, $RightDC, $RightWidth, $RightHeight
Global $BottomLeft, $BottomLeftIMG, $BottomLeftDC, $BottomLeftWidth, $BottomLeftHeight
Global $Bottom, $BottomIMG, $BottomDC, $BottomWidth, $BottomHeight
Global $BottomRight, $BottomRightIMG, $BottomRightDC, $BottomRightWidth, $BottomRightHeight
Global $MinButton, $MinButtonIMG, $MinButtonDC, $MinButtonWidth, $MinButtonHeight, $MinButtonPos
Global $MaxButton, $MaxButtonIMG, $MaxButtonDC, $MaxButtonWidth, $MaxButtonHeight, $MaxButtonPos
Global $CloseButton, $CloseButtonIMG, $CloseButtonDC, $CloseButtonWidth, $CloseButtonHeight, $CloseButtonPos
Global $ResButton, $ResButtonIMG, $ResButtonDC, $ResButtonWidth, $ResButtonHeight, $ResButtonPos
Global $FontName, $FontSize, $FontPos, $FontColor, $IconPos, $IconSize

Global $Blur = 0, $BlurValue = 1, $Reflection = 0, $ThemeName = "Default", $FontName = "Arial", $FontSize = 13, $FontColor = 0xFFFFFF ;Default Settings

Func SkinComponentsLoad($ThemeName, ByRef Const $EffectsSettings, ByRef Const $FontSettings)
	LoadGlobalSkin($ThemeName)
	
	If IsArray($EffectsSettings) Then Global $Blur = $EffectsSettings[0], $BlurValue = $EffectsSettings[1], $Reflection = $EffectsSettings[2]
	If IsArray($FontSettings) Then Global $FontName = $FontSettings[0], $FontSize = $FontSettings[1], $FontColor = StringSplit($FontSettings[2], ",")
	If $BlurValue = 0 Then $BlurValue = 1
	Global $NewBMP = CreateNewDC(@DesktopWidth + 400,@DesktopHeight + 400), $NewTextBMP = CreateNewDC(@DesktopWidth + 400,@DesktopHeight + 400)
	Global $TopBlurImage = CreateNewGDIGraphics(@DesktopWidth + 400,$TopHeight), $TopBlurCloneInfo = CreateNewGDIGraphics(@DesktopWidth + 400,$TopHeight)
	Global $MiddleBlurImage = CreateNewGDIGraphics($RightWidth,@DesktopHeight + 100), $MiddleBlurCloneInfo = CreateNewGDIGraphics($RightWidth,@DesktopHeight + 100)
	Global $MemDC = $NewBMP[1],$TextDC = $NewTextBMP[1];,$hFont = _WinAPI_CreateFont(0,0,
	_WinAPI_SetBkMode($MemDC,$TRANSPARENT)
	_WinAPI_SetBkMode($TextDC,$TRANSPARENT)
	
	_WinAPI_SetTextColor($TextDC,ColorGetRGBHex($FontColor[1], $FontColor[2], $FontColor[3]))
	
	Global $TopBlurImg = $TopBlurImage[0], $TopBlurGraphics = $TopBlurImage[1]
	Global $TopBlurClone = $TopBlurCloneInfo[0], $TopBlurCloneGraphics = $TopBlurCloneInfo[1]
	
	Global $MiddleBlurImg = $MiddleBlurImage[0], $MiddleBlurGraphics = $MiddleBlurImage[1]
	Global $MiddleBlurCloneImage = $MiddleBlurCloneInfo[0], $MiddleBlurCloneGraphics = $MiddleBlurCloneInfo[1]
	
	$CaptionMetrics = _WinAPI_GetSystemMetrics($SM_CYCAPTION)
	$FrameMetrics = _WinAPI_GetSystemMetrics($SM_CXFIXEDFRAME)
	$CaptionHeight = $CaptionMetrics + $FrameMetrics
	Global $xAdd = $FrameMetrics - $LeftWidth, $yAdd = $CaptionHeight - $TopHeight
	Global $WidthAdd = ($RightWidth + $LeftWidth) - ($FrameMetrics * 2),$HeightAdd = ($FrameMetrics * 2) + $BottomHeight + $TopHeight
	
	$TopBlurGraphicsDC = _GDIPlus_GraphicsGetDC($TopBlurGraphics)
	Global $NewGraphics3 = _GDIPlus_GraphicsCreateFromHDC($TopBlurGraphicsDC)
	_GDIPlus_GraphicsReleaseDC($TopBlurGraphics, $TopBlurGraphicsDC)
	
	$MiddleBlurGraphicsDC = _GDIPlus_GraphicsGetDC($MiddleBlurGraphics)
	Global $NewGraphics6 = _GDIPlus_GraphicsCreateFromHDC($MiddleBlurGraphicsDC)
	_GDIPlus_GraphicsReleaseDC($MiddleBlurGraphics, $MiddleBlurGraphicsDC)
	
	GUIRegisterMsg($WM_ACTIVATE, "SkinWindowActivate")
	GUIRegisterMsg($WM_LBUTTONDOWN, "SkinWindowClick")
	GUIRegisterMsg($WM_LBUTTONDBLCLK, "SkinWindowDblClick")
	GUIRegisterMsg($WM_RBUTTONDOWN, "SkinWindowRightClick")
	GUIRegisterMsg($WM_MOUSEMOVE, "SkinWindowMouseHover")
	GUIRegisterMsg($WM_MOUSELEAVE, "SkinWindowMouseLeave")
EndFunc   ;==>SkinWindowStart

Func SkinComponentsUnLoad()
	UnLoadGlobalSkin()
	Local $DeleteDC = _WinAPI_DeleteDC($NewBMP[1]), $DeleteIMG = _WinAPI_DeleteObject($NewBMP[0])
	Local $DeleteDC = _WinAPI_DeleteDC($NewTextBMP[1]), $DeleteIMG = _WinAPI_DeleteObject($NewTextBMP[0])
	Local $DeleteGraphics = _GDIPlus_GraphicsDispose($TopBlurImage[1]), $DeleteIMG = _GDIPlus_ImageDispose($TopBlurImage[0])
	Local $DeleteGraphics = _GDIPlus_GraphicsDispose($TopBlurCloneInfo[1]), $DeleteIMG = _GDIPlus_ImageDispose($TopBlurCloneInfo[0])
	Local $DeleteGraphics = _GDIPlus_GraphicsDispose($NewGraphics3)
EndFunc   ;==>SkinWindowStart

Func SkinWindowCreate($hWnd)
	$Title = WinGetTitle($hWnd)
	If Not IsHWnd($hWnd) Or ($Title = "Program Manager") Then Return -1
	
	$BorderExStyle = BitOR($WS_EX_LAYERED, $WS_EX_TOOLWINDOW)
	$ChildExStyle = BitOR($BorderExStyle,$WS_EX_MDICHILD)
	
	Local $State = @SW_SHOW
	;If Not _WinAPI_IsWindowVisible($State) Then $State = @SW_HIDE
	
	$TopGUI = SkinWindowCreateBorder($SKIN_TOP, 0, 0, 0, 0, $Cursor_Default, $BorderExStyle, $hWnd,$State)
	$LeftGUI = SkinWindowCreateBorder($SKIN_LEFT, 0, 0, 0, 0,$Cursor_Vertical, BitOR($ChildExStyle, $STYLEID_LEFT), $hWnd,$State)
	$RightGUI = SkinWindowCreateBorder($SKIN_RIGHT, 0, 0, 0, 0, $Cursor_Vertical, BitOR($ChildExStyle, $STYLEID_RIGHT), $hWnd,$State)
	$BottomGUI = SkinWindowCreateBorder($SKIN_BOTTOM, 0, 0, 0, 0, $Cursor_Horizontal, BitOR($ChildExStyle, $STYLEID_BOTTOM), $hWnd,$State)
	
	Local $GUIs[4] = [$TopGUI,$LeftGUI,$RightGUI,$BottomGUI]
	SkinWindowAddNew($GUIs, $hWnd)
	
	Local $Pos = WinGetPos($hWnd)
	SkinWindowMove($GUIs, $Pos[0], $Pos[1], $Pos[2], $Pos[3],1)	
	Return $TopGUI
EndFunc   ;==>SkinWindowCreate

Func SkinWindowCreateBorder($SKIN_TYPE, $X, $Y, $Width, $Height, $Cursor_Type = $Cursor_Default, $ExStyle = Default, $hWndParent = Default, $State = @SW_SHOW)
	$BorderGUI = GUICreate("", 0, 0, 0, 0, $WS_POPUP , $ExStyle, $hWndParent)
	WinMove($BorderGUI, "", $X, $Y, $Width, $Height)
	SkinWindowRePaint($BorderGUI, $SKIN_TYPE)
	GUISetCursor($Cursor_Type, 1, $BorderGUI)
	GUISetState($State)
	Return $BorderGUI
EndFunc   ;==>SkinWindowCreateBorder

Func SkinWindowAddNew($hGUIs, $Win)
	$ArrayMaxN = UBound($SkinWindows)
	ReDim $SkinWindows[$ArrayMaxN + 1][5]
	$SkinWindows[$ArrayMaxN][0] = $hGUIs[0]
	$SkinWindows[$ArrayMaxN][1] = $hGUIs[1]
	$SkinWindows[$ArrayMaxN][2] = $hGUIs[2]
	$SkinWindows[$ArrayMaxN][3] = $hGUIs[3]
	$SkinWindows[$ArrayMaxN][4] = $Win
	Return 1
EndFunc   ;==>AddNew

Func SkinWindowDelete($SkinGUI)
	Local $SkinIndex = 0
	For $i = 0 To UBound($SkinWindows) - 1
		If $SkinWindows[$i][$GUI_TOP] = $SkinGUI Or $SkinWindows[$i][$GUI_LEFT] = $SkinGUI Or $SkinWindows[$i][$GUI_RIGHT] = $SkinGUI Or _
			$SkinWindows[$i][$GUI_BOTTOM] = $SkinGUI Then 
			$SkinIndex = $i
			ExitLoop
		EndIf
	Next
	_ArrayDelete($SkinWindows,$SkinIndex)
	Return 1
EndFunc   ;==>AddNew

Func SkinWindowGetParent($SkinGUI)
	For $i = 0 To UBound($SkinWindows) - 1
		If $SkinWindows[$i][$GUI_TOP] = $SkinGUI Or $SkinWindows[$i][$GUI_LEFT] = $SkinGUI Or $SkinWindows[$i][$GUI_RIGHT] = $SkinGUI Or _
			$SkinWindows[$i][$GUI_BOTTOM] = $SkinGUI Then Return $SkinWindows[$i][$GUI_PARENT]
	Next
	Return 0
EndFunc   ;==>SearchHWnd

Func SkinWindowGetFromParent($hWnd)
	For $i = 0 To UBound($SkinWindows) - 1
		If $SkinWindows[$i][$GUI_PARENT] = $hWnd Then Return $SkinWindows[$i][$GUI_TOP]
	Next
	Return 0
EndFunc   ;==>SkinWindowGetFromParent

Func SkinWindowGetBorders($TopGUI)
	For $i = 0 To UBound($SkinWindows) - 1
		If $SkinWindows[$i][$GUI_TOP] = $TopGUI Then 
			Local $aGUIs[4] = [$SkinWindows[$i][$GUI_TOP], $SkinWindows[$i][$GUI_LEFT], $SkinWindows[$i][$GUI_RIGHT], $SkinWindows[$i][$GUI_BOTTOM]]
			Return $aGUIs
		EndIf
	Next
	Return 0
EndFunc   ;==>SkinWindowGetBorders

Func SkinWindowGetType($hWnd)
	Local $WndExStyle = _WinAPI_GetWindowLong($hWnd, $GWL_EXSTYLE)
	If Not BitAND($WndExStyle, $STYLEID_ANY) Then Return $SKIN_TOP
	If BitAND($WndExStyle, $STYLEID_LEFT) Then Return $SKIN_LEFT
	If BitAND($WndExStyle, $STYLEID_RIGHT) Then Return $SKIN_RIGHT
	If BitAND($WndExStyle, $STYLEID_BOTTOM) Then Return $SKIN_BOTTOM
	Return 0
EndFunc   ;==>SkinWindowGetType

Func SkinWindowRemove($SkinGUI)
	$hParentWindow = _WinAPI_GetParent($SkinGUI)
	_WinAPI_SetWindowRgn($hParentWindow, 0, 1)
	_SendMessage($hParentWindow, $WM_THEMECHANGED)
	_WinAPI_SetWindowPos($hParentWindow, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOZORDER, $SWP_NOACTIVATE, $SWP_NOREPOSITION, $SWP_FRAMECHANGED))
	GUIDelete($SkinGUI)
EndFunc   ;==>SkinWindowRemove

Func SkinWindowRemoveAll()
	$List = WinList("[CLASS:AutoIt v3 GUI]")
	For $i = 1 To $List[0][0]
		If _WinAPI_GetParent($List[$i][1]) Then SkinWindowRemove($List[$i][1])
	Next
	Return 0
EndFunc   ;==>SkinWindowRemoveAll

Func SkinWindowUpdate($hWnd,$Activated = Default)
	$Borders = SkinWindowGetBorders($hWnd)
	If Not IsArray($Borders) Then Return 0
	SkinWindowRePaint($Borders[0], $SKIN_TOP,0,$Activated)
	SkinWindowRePaint($Borders[1], $SKIN_LEFT,0,$Activated)
	SkinWindowRePaint($Borders[2], $SKIN_RIGHT,0,$Activated)
	SkinWindowRePaint($Borders[3], $SKIN_BOTTOM,0,$Activated)
EndFunc   ;==>SkinWindowRemoveAll

Func SkinWindowShow($hWnd,$State)
	$Borders = SkinWindowGetBorders($hWnd)
	If Not IsArray($Borders) Then Return 0
	GUISetState($State, $Borders[0])
	GUISetState($State, $Borders[1])
	GUISetState($State, $Borders[2])
	GUISetState($State, $Borders[3])
EndFunc   ;==>SkinWindowRemoveAll

Func SkinWindowRePaint($hSkinWindow, $Type, $HoverType = 0,$Activated = Default, $X = Default,$Y = Default,$Width = Default, $Height = Default)
	Local $hParentWindow = _WinAPI_GetParent($hSkinWindow)
	$PosSize = WinGetPos($hSkinWindow)
	If Not IsArray($PosSize) Then Return
	If IsKeyword($X) Then $X = $PosSize[0]
	If IsKeyword($Y) Then $Y = $PosSize[1]
	If IsKeyword($Width) Then $Width = $PosSize[2]
	If IsKeyword($Height) Then $Height = $PosSize[3]
	Local $State = WinGetState($hParentWindow)
	If IsKeyword($Activated) Then $Activated = BitAND($State,8)
	Local $SrcDC = _WinAPI_GetDC(0), $tBlend = CreateStruct($tagBLENDFUNCTION, $AC_SRC_OVER, 0, 0xFF, $AC_SRC_ALPHA),$MaximizedState = BitAND($State,32)
	Local $tSize = CreateStruct($tagSIZE, $Width, $Height, "", ""), $tSource = CreateStruct($tagPOINT, 0, 0, "", ""), $tRect = CreateStruct($tagRECT, 0,0, $Width - ($MinButtonWidth + $MaxButtonWidth + $CloseButtonWidth), $TopHeight)
	Local $tPTDest = CreateStruct($tagPOINT, $X, $Y, "", ""), $tRect = CreateStruct($tagRECT, $FontPos[1], $FontPos[2], $Width - ($MinButtonWidth + $MaxButtonWidth + $CloseButtonWidth), $TopHeight)
	Local $pBlend = DllStructGetPtr($tBlend), $pSize = DllStructGetPtr($tSize), $pSource = DllStructGetPtr($tSource), $pPTDest = DllStructGetPtr($tPTDest)
	Local $TLeftY = 0, $TopY = 0, $TRightY = 0, $RightY = 0, $LeftY = 0, $BLeftY = 0, $BottomY = 0, $BRightY = 0
	If Not $Activated Then Local $TLeftY = $TopLeftHeight, $TopY = $TopHeight, $TRightY = $TopRightHeight, $RightY = $RightHeight , _
				$LeftY = $LeftHeight, $BLeftY = $BottomLeftHeight, $BottomY = $BottomHeight, $BRightY = $BottomRightHeight
	_WinAPI_BitBlt($MemDC, 0, 0, $Width + 50, $Height + 50, $TextDC, 0, 0, $BLACKNESS) ; clear $MemDC for repainting
	Switch $Type
		Case $SKIN_TOP
			Local $Title = WinGetTitle($hParentWindow), $SetStruct = DllStructSetData($tSize, "Y", $TopHeight)
			_WinAPI_BitBlt($MemDC, 0, 0, $Width + 50, $Height + 50, $TextDC, 0, 0, $BLACKNESS) ; clear $MemDC for repainting
			If $Blur Then PaintBlur($MemDC, $BlurPos[1], $BlurPos[2], $Width - $BlurPos[3], $Height,$SrcDC, $X + $BlurPos[1], $Y + $BlurPos[2], $pBlend)
			_WinAPI_AlphaBlend($MemDC, 0, 0, $TopLeftWidth, $TopLeftHeight, $TopLeftDC, 0, $TLeftY, $TopLeftWidth, $TopLeftHeight, $pBlend);top-left
			_WinAPI_AlphaBlend($MemDC, $TopLeftWidth, 0, $Width - ($TopLeftWidth + $TopRightWidth), $TopHeight, $TopDC, 0, $TopY, $TopWidth, $TopHeight, $pBlend) ; Top
			_WinAPI_AlphaBlend($MemDC, $Width - $TopLeftWidth, 0, $TopRightWidth, $TopRightHeight, $TopRightDC, 0, $TRightY, $TopRightWidth, $TopRightHeight, $pBlend);top-right
			If $Reflection And $Activated Then
				Local $XReflect = $ReflectionPos[1], $YReflect = $ReflectionPos[2], $XPos = $X, $YPos = $Y
				If $X < 0 Then Dim $XReflect = ($X * - 1), $XPos = 0
				If $Y < 0 Then Dim $YReflect = ($Y * - 1), $YPos = 0
				_WinAPI_AlphaBlend($MemDC, $XReflect, $YReflect, $Width - $ReflectionPos[3], 30, $ReflectionDC, $XPos, $YPos, $Width - $ReflectionPos[3], 30, $pBlend) ;draw reflection lines
			EndIf
			PaintButtons($MemDC, $Width, $HoverType,$MaximizedState,$Activated, $pBlend)
			
			_WinAPI_BitBlt($TextDC,0,0,$Width - ($MinButtonWidth + $MaxButtonWidth + $CloseButtonWidth), $TopHeight,$TopDC,0,0,$BLACKNESS)
			_WinAPI_DrawText($TextDC, $Title, $tRect, $DT_END_ELLIPSIS)
			_WinAPI_AlphaBlend($MemDC, 0, 0, $Width - ($MinButtonWidth + $MaxButtonWidth + $CloseButtonWidth), $TopHeight, $TextDC, 0, 0,$Width - ($MinButtonWidth + $MaxButtonWidth + $CloseButtonWidth), $TopHeight, $pBlend);right
			
			$hIcon = WinGetIcon($hParentWindow)
			If $hIcon Then _WinAPI_DrawIconEx($MemDC,$IconPos[1],$IconPos[2],$hIcon,$IconSize[1],$IconSize[2])
			
		Case $SKIN_LEFT
			DllStructSetData($tSize, "X", $LeftWidth)
			DllStructSetData($tSize, "Y", $Height)
			;If $Blur Then PaintBlur($MemDC, $BlurPos[1], 0, $LeftWidth, $Height,$SrcDC, $X + $BlurPos[1], $Y, $pBlend ,$BLUR_VER)
			_WinAPI_AlphaBlend($MemDC, 0, 0, $LeftWidth, $Height, $LeftDC, 0, $LeftY, $LeftWidth, $LeftHeight, $pBlend);right
			
		Case $SKIN_RIGHT
			DllStructSetData($tSize, "X", $RightWidth)
			DllStructSetData($tSize, "Y", $Height)
			;If $Blur Then PaintBlur($MemDC, 0, 0, $RightWidth , $Height,$SrcDC, $X, $Y, $pBlend ,$BLUR_VER)
			_WinAPI_AlphaBlend($MemDC, 0, 0, $RightWidth, $Height, $RightDC, 0, $RightY, $RightWidth, $RightHeight, $pBlend);left
			
		Case $SKIN_BOTTOM
			DllStructSetData($tSize, "Y", $BottomHeight)
			;If $Blur Then PaintBlur($MemDC, $BlurPos[1], 0, $Width - $BlurPos[3], $Height - $BlurPos[4],$SrcDC, $X + $BlurPos[1], $Y, $pBlend)
			_WinAPI_AlphaBlend($MemDC, 0, 0, $BottomLeftWidth, $BottomLeftHeight, $BottomLeftDC, 0, $BLeftY, $BottomLeftWidth, $BottomLeftHeight, $pBlend) ; bottom-left
			_WinAPI_AlphaBlend($MemDC, $BottomLeftWidth, 0, $Width - ($BottomRightWidth + $BottomLeftWidth), $BottomHeight, $BottomDC, 0, $BottomY, $BottomWidth, $BottomHeight, $pBlend);bottom
			_WinAPI_AlphaBlend($MemDC, $Width - $BottomRightWidth, 0, $BottomRightWidth, $BottomRightHeight, $BottomRightDC, 0, $BRightY, $BottomRightWidth, $BottomRightHeight, $pBlend) ;bottom-right
	EndSwitch
	
	$iReturn = _WinAPI_UpdateLayeredWindow($hSkinWindow, $SrcDC, $pPTDest, $pSize, $MemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $SrcDC)
	Return $iReturn
EndFunc   ;==>SkinWindowRePaint

Func ColorGetColorRef($iRed, $iGreen, $iBlue)
	Local $HexRGB, $iColorRef
	$HexRGB = ColorGetRGBHex($iRed, $iGreen, $iBlue)
	$iColorRef = StringTrimLeft($HexRGB,2)
    $iColorRef = StringMid($iColorRef, 5, 2) & StringMid($iColorRef, 3, 2) & StringMid($iColorRef, 1, 2)
    $iColorRef = Dec($iColorRef)
	Return $iColorRef
EndFunc

Func ColorGetRGBHex($iRed, $iGreen, $iBlue)
	Local $HexRed, $HexGreen, $HexBlue, $HexRGB
    $HexRed = Hex($iRed,2)
    $HexGreen = Hex($iGreen,2)
    $HexBlue = Hex($iBlue,2)
    $HexRGB = '0x' & $HexRed & $HexGreen & $HexBlue
	Return $HexRGB
EndFunc

Func PaintButtons($hDC, $Width, $Type, $MaximizedState, $Activated,$pBlend)
	Local $MinY = 0, $MaxY = 0, $ResY = 0, $CloseY = 0
	If Not $Activated Then Local $MinY = $CloseButtonHeight * 3, $MaxY = $CloseButtonHeight * 3, $ResY = $ResButtonHeight * 3, $CloseY = $CloseButtonHeight * 3
	_WinAPI_AlphaBlend($hDC, $Width - ($CloseButtonWidth + $CloseButtonPos[1]), $CloseButtonPos[2], $CloseButtonWidth, $CloseButtonHeight, $CloseButtonDC, 0, $CloseY, $CloseButtonWidth, $CloseButtonHeight, $pBlend)
	If Not $MaximizedState Then _WinAPI_AlphaBlend($hDC, $Width - ($MaxButtonWidth + $MaxButtonPos[1]), $MaxButtonPos[2], $MaxButtonWidth, $MaxButtonHeight, $MaxButtonDC, 0, $MaxY, $MaxButtonWidth, $MaxButtonHeight, $pBlend)
	If $MaximizedState Then _WinAPI_AlphaBlend($hDC, $Width - ($ResButtonWidth + $ResButtonPos[1]), $ResButtonPos[2], $ResButtonWidth, $ResButtonHeight, $ResButtonDC, 0, $ResY, $ResButtonWidth, $ResButtonHeight, $pBlend)
	_WinAPI_AlphaBlend($hDC, $Width - ($MinButtonWidth + $MinButtonPos[1]), $MinButtonPos[2], $MinButtonWidth, $MinButtonHeight, $MinButtonDC, 0, $MinY, $MinButtonWidth, $MinButtonHeight, $pBlend)
	Local $MinHover = $MinButtonHeight, $MaxHover = $MaxButtonHeight, $CloseHover = $CloseButtonHeight,$ResHover = $ResButtonHeight
	Switch $Type
		Case $CLOSE_HOVER
			_WinAPI_AlphaBlend($hDC, $Width - ($CloseButtonWidth + $CloseButtonPos[1]), $CloseButtonPos[2], $CloseButtonWidth, $CloseButtonHeight, $CloseButtonDC, 0, $MinHover, $CloseButtonWidth, $CloseButtonHeight, $pBlend)
		Case $MAX_HOVER
			If $MaximizedState Then _WinAPI_AlphaBlend($hDC, $Width - ($ResButtonWidth + $ResButtonPos[1]), $ResButtonPos[2], $ResButtonWidth, $ResButtonHeight, $ResButtonDC, 0, $ResHover, $ResButtonWidth, $ResButtonHeight, $pBlend)
			If Not $MaximizedState Then _WinAPI_AlphaBlend($hDC, $Width - ($MaxButtonWidth + $MaxButtonPos[1]), $MaxButtonPos[2], $MaxButtonWidth, $MaxButtonHeight, $MaxButtonDC, 0, $MaxHover, $MaxButtonWidth, $MaxButtonHeight, $pBlend)
		Case $MIN_HOVER
			_WinAPI_AlphaBlend($hDC, $Width - ($MinButtonWidth + $MinButtonPos[1]), $MinButtonPos[2], $MinButtonWidth, $MinButtonHeight, $MinButtonDC, 0, $CloseHover, $MinButtonWidth, $MinButtonHeight, $pBlend)
	EndSwitch
EndFunc   ;==>PaintButtons

Func PaintBlur($DestDC, $XDest, $YDest, $Width, $Height,$SrcDC, $XSrc, $YSrc, $pBlend, $Type = $BLUR_HORI)
	Local $Graphics = $TopBlurGraphics,$Image = $TopBlurImg, $ImageClone = $TopBlurClone, $GrahpicsClone = $TopBlurCloneGraphics,$FinalGraphics = $NewGraphics3
	If $Type = $BLUR_VER Then Local $Graphics = $MiddleBlurGraphics,$Image = $MiddleBlurImg, $GrahpicsClone = $MiddleBlurCloneGraphics, $ImageClone = $MiddleBlurCloneImage,$FinalGraphics = $NewGraphics6
	$ToDC = _GDIPlus_GraphicsGetDC($Graphics)
	_WinAPI_BitBlt($ToDC, 0, 0, $Width + 30, $Height + 30, $SrcDC, $XSrc - 5, $YSrc - 5, $SRCCOPY)
	_GDIPlus_GraphicsReleaseDC($Graphics, $ToDC)
	_GDIPlus_GraphicsDrawImageRectRect($GrahpicsClone, $Image, 0, 0, $Width + 30, $Height + 30, 0, 0, ($Width + 30) / $BlurValue, ($Height + 30) / $BlurValue)
	_GDIPlus_GraphicsDrawImageRectRect($Graphics, $ImageClone, 0, 0, ($Width + 30) / $BlurValue, ($Height + 30) / $BlurValue, 0, 0, $Width + 30, $Height + 30)
	_GDIPlus_GraphicsDrawImage($FinalGraphics, $Image, 0, 0)
	$ImageDC = _GDIPlus_GraphicsGetDC($FinalGraphics);get the dc of the source image
	_WinAPI_BitBlt($DestDC, $XDest ,$YDest, $Width , $Height , $ImageDC, 5, 5, $SRCCOPY) ;bitblt from image dc to the gdi32 dc
	_GDIPlus_GraphicsReleaseDC($FinalGraphics, $ImageDC) ;release the dc of the source image
EndFunc   ;==>PaintBlur

Func SkinWindowMove($hGUIs, $X, $Y, $Width, $Height,$Activated = 1)
	Local $TopGUI = $hGUIs[0], $LeftGUI = $hGUIs[1], $RightGUI = $hGUIs[2], $BottomGUI = $hGUIs[3]
	
	$CaptionMetrics = _WinAPI_GetSystemMetrics($SM_CYCAPTION)
	$FrameMetrics = _WinAPI_GetSystemMetrics($SM_CXFIXEDFRAME)
	$CaptionHeight = $CaptionMetrics + $FrameMetrics
	
	$X = ($X + $FrameMetrics) - $LeftWidth
	$Y = ($Y + $CaptionHeight) - $TopHeight
	$Width = ($Width - ($FrameMetrics * 2) ) + $RightWidth + $LeftWidth
	$Height = ($Height + ($FrameMetrics * 2) )
	
	SkinWindowRePaint($TopGUI, $SKIN_TOP,0,$Activated,$X, $Y, $Width, $TopHeight)
	SkinWindowRePaint($LeftGUI, $SKIN_LEFT,0,$Activated,$X, ($TopHeight + $Y), $LeftWidth, $Height - ($TopHeight + $BottomHeight))
	SkinWindowRePaint($RightGUI, $SKIN_RIGHT,0,$Activated,($Width - $RightWidth) + $X, ($TopHeight + $Y), $RightWidth, $Height -  ($TopHeight + $BottomHeight) )
	SkinWindowRePaint($BottomGUI, $SKIN_BOTTOM,0,$Activated,$X, ($Y + $Height) - $BottomHeight, $Width, $BottomHeight)
EndFunc   ;==>SkinWindowMove

;========================================================> SKIN_WINDOW MESSAGES FUNCTIONS <======================================================================

Func SkinWindowActivate($hWnd, $iMsg, $iwParam, $ilParam)
	If ($iwParam = $WA_ACTIVE) Or ($iwParam = $WA_CLICKACTIVE) Then
		;_WinAPI_SetWindowPos(SkinWindowGetParent($hWnd), 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOZORDER, $SWP_NOREPOSITION, $SWP_NOCOPYBITS))
	EndIf
EndFunc   ;==>WM_ACTIVATE

Func SkinWindowMouseLeave($hWnd, $iMsg, $iwParam, $ilParam)
	$Style = _WinAPI_GetWindowLong($hWnd, $GWL_EXSTYLE)
	If BitAND($Style, $STYLEID_ANY) Then Return
	SkinWindowRePaint($hWnd, $SKIN_TOP)
EndFunc   ;==>SkinWindowMouseLeave

Func SkinWindowMouseHover($hWnd, $iMsg, $iwParam, $ilParam)
	_TrackMouseEvent($hWnd)
	If Not (SkinWindowGetType($hWnd) = $SKIN_TOP) Then Return
	$Style = _WinAPI_GetWindowLong(_WinAPI_GetParent($hWnd), $GWL_STYLE)
	Local $MousePos = GUIGetCursorInfo($hWnd), $WinPos = WinGetPos($hWnd)
	Local $Width = $WinPos[2], $Height = $WinPos[3]
	If ($MousePos[0] > ($Width - ($MinButtonPos[1] + $MinButtonWidth))) And ($MousePos[0] < ($Width - ($MinButtonPos[1] + $MinButtonWidth)) + $MinButtonWidth) And BitAND($Style, $WS_MINIMIZEBOX) Then Return EnterHoverState($hWnd, $Width, $MIN_HOVER)
	If ($MousePos[0] > ($Width - ($MaxButtonPos[1] + $MaxButtonWidth))) And ($MousePos[0] < ($Width - ($MaxButtonPos[1] + $MaxButtonWidth)) + $MaxButtonWidth) And BitAND($Style, $WS_MAXIMIZEBOX) Then Return EnterHoverState($hWnd, $Width, $MAX_HOVER)
	If ($MousePos[0] > ($Width - ($CloseButtonPos[1] + $CloseButtonWidth))) And ($MousePos[0] < ($Width - ($CloseButtonPos[1] + $CloseButtonWidth)) + $CloseButtonWidth) Then Return EnterHoverState($hWnd, $Width, $CLOSE_HOVER)
EndFunc   ;==>SkinWindowMouseHover

Func _TrackMouseEvent($hWnd)
	Local $pMouseEvent, $iResult, $iMouseEvent
	$tMouseEvent = DllStructCreate($tagTRACKMOUSEEVENT)
	DllStructSetData($tMouseEvent, "hWndTrack", $hWnd)
	DllStructSetData($tMouseEvent, "Flags", $TME_LEAVE)
	DllStructSetData($tMouseEvent, "HoverTime", 0xFFFFFFFF)
	DllStructSetData($tMouseEvent, "Size", DllStructGetSize($tMouseEvent))
	$iResult = _WinAPI_TrackMouseEvent(DllStructGetPtr($tMouseEvent))
	Return $iResult <> 0
EndFunc   ;==>_TrackMouseEvent

Func EnterHoverState($hWnd, $Width, $Type)
	If $Type = $MIN_HOVER Then Local $ButtonPos = $MinButtonPos, $ButtonWidth = $MinButtonWidth
	If $Type = $MAX_HOVER Then Local $ButtonPos = $MaxButtonPos, $ButtonWidth = $MaxButtonWidth
	If $Type = $CLOSE_HOVER Then Local $ButtonPos = $CloseButtonPos, $ButtonWidth = $CloseButtonWidth
	SkinWindowRePaint($hWnd, $SKIN_TOP, $Type)
	Do
		$MousePos = GUIGetCursorInfo($hWnd)
		If IsArray($MousePos) And $MousePos[2] Then ExitLoop
		#cs
		If IsArray($MousePos) And $MousePos[2] Then
			SkinWindowRePaint($hWnd, $SKIN_TOP, $MAX_HOVER)
			Do
				$MousePos = GUIGetCursorInfo($hWnd)
			Until $MousePos[2] = 0
			ExitLoop
		EndIf
		#ce
		Sleep(10)
	Until Not (($MousePos[0] > ($Width - ($ButtonPos[1] + $ButtonWidth))) And ($MousePos[0] < ($Width - ($ButtonPos[1] + $ButtonWidth)) + $ButtonWidth))
	SkinWindowRePaint($hWnd, $SKIN_TOP)
EndFunc   ;==>EnterHoverState

Func SkinWindowClick($hWnd, $iMsg, $iwParam, $ilParam)
	Local $Type = SkinWindowGetType($hWnd)
	If Not $Type Then Return
	
	$hParentWindow = SkinWindowGetParent($hWnd)
	If Not BitAND(WinGetState($hParentWindow), 2) Then Return
	Local $MaximizedState = BitAND(WinGetState($hParentWindow), 32)
	Local $MousePos = GUIGetCursorInfo($hWnd), $WinPos = WinGetPos($hWnd), $Style = _WinAPI_GetWindowLong($hParentWindow, $GWL_STYLE)
	Local $Width = $WinPos[2], $Height = $WinPos[3], $Activated = WinActive($hParentWindow)
	
	If BitAND($Style, $WS_DISABLED) Then Return
	If ($Type = $SKIN_TOP) Then
		If ($MousePos[0] > ($Width - ($MinButtonPos[1] + $MinButtonWidth))) And ($MousePos[0] < ($Width - ($MinButtonPos[1] + $MinButtonWidth)) + $MinButtonWidth) And BitAND($Style, $WS_MINIMIZEBOX) Then Return WinSetState($hParentWindow, "", @SW_MINIMIZE)
		If ($MousePos[0] > ($Width - ($MaxButtonPos[1] + $MaxButtonWidth))) And ($MousePos[0] < ($Width - ($MaxButtonPos[1] + $MaxButtonWidth)) + $MaxButtonWidth) And BitAND($Style, $WS_MAXIMIZEBOX) Then 
			If $MaximizedState Then Return WinSetState($hParentWindow, "", @SW_RESTORE)
			If Not $MaximizedState Then Return WinSetState($hParentWindow, "", @SW_MAXIMIZE)
		EndIf
		If ($MousePos[0] > ($Width - ($CloseButtonPos[1] + $CloseButtonWidth))) And ($MousePos[0] < ($Width - ($CloseButtonPos[1] + $CloseButtonWidth)) + $CloseButtonWidth) Then Return WinClose($hParentWindow)
		Return _WinAPI_DefWindowProc($hParentWindow, $WM_NCLBUTTONDOWN, $HTCAPTION, 0)
	EndIf
	_WinAPI_SetWindowPos($hParentWindow, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOZORDER, $SWP_NOREPOSITION, $SWP_NOCOPYBITS))
	If ($Type = $SKIN_RIGHT) Then Return _WinAPI_DefWindowProc($hParentWindow, $WM_NCLBUTTONDOWN, $HTRIGHT, 0)
	If ($Type = $SKIN_LEFT) Then Return _WinAPI_DefWindowProc($hParentWindow, $WM_NCLBUTTONDOWN, $HTLEFT, 0)
	If ($Type = $SKIN_BOTTOM) Then Return _WinAPI_DefWindowProc($hParentWindow, $WM_NCLBUTTONDOWN, $HTBOTTOM, 0)
EndFunc   ;==>SkinWindowClick

Func SkinWindowDblClick($hWnd, $iMsg, $iwParam, $ilParam)
	Local $Type = SkinWindowGetType($hWnd)
	If Not ($Type = $SKIN_TOP) Then Return
	
	$hParentWindow = SkinWindowGetParent($hWnd)
	Local $MaximizedState = BitAND(WinGetState($hParentWindow), 32)
	Local $MousePos = GUIGetCursorInfo($hWnd), $WinPos = WinGetPos($hWnd), $Style = _WinAPI_GetWindowLong($hParentWindow, $GWL_STYLE)
	Local $Width = $WinPos[2], $Height = $WinPos[3]
	If BitAND($Style, $WS_DISABLED) Then Return
	
	If Not BitAND($Style, $WS_MAXIMIZEBOX) Then Return
	If $MousePos[1] < $TopHeight Then
		If Not $MaximizedState Then WinSetState($hParentWindow,"",@SW_MAXIMIZE);SkinWindowMaximize($hWnd)
		If $MaximizedState Then WinSetState($hParentWindow,"",@SW_RESTORE) ;SkinWindowRestore($hWnd)
	EndIf
EndFunc   ;==>SkinWindowDblClick

Func SkinWindowRightClick($hWnd, $iMsg, $iwParam, $ilParam)
	Local $Type = SkinWindowGetType($hWnd)
	If Not ($Type = $SKIN_TOP) Then Return
	$hParentWindow = SkinWindowGetParent($hWnd)
	Local Const $WM_GETSYSMENU = 0x0313
	_SendMessage($hParentWindow, $WM_GETSYSMENU, 0, _WinAPI_MakeDWord(MouseGetPos(0), MouseGetPos(1)))
EndFunc   ;==>SkinWindowRightClick

;==========================================================> LOAD AND UNLOAD GLOBAL SKIN <==================================================================

Func LoadGlobalSkin($ThemeName)
	Local $ThemeINI = $ThemesFolder & $ThemeName & "\ThemeSettings.ini", $ThemeImageInfo, $hScrDC = _WinAPI_GetDC(0)
	Local Const $ThemeStructure[13] = ["TopLeft", "Top", "TopRight", "Left", "Right", "BottomLeft", "Bottom", "BottomRight", "Reflection", _
			"MinButton", "MaxButton", "ResButton", "CloseButton"]
	For $i = 0 To 12
		Local $CurrentImageName = $ThemeStructure[$i], $ImageCount = 2
		Local $CurrentImageFile = $ThemesFolder & $ThemeName & "\" & $CurrentImageName & ".png"
		
		If StringInStr($CurrentImageName, "Button") Then Local $ImageCount = 6
		If $CurrentImageName = "Reflection" Then Local $ImageCount = 1
		
		$LoadedImg = _GDIPlus_ImageLoadFromFile($CurrentImageFile)
		Assign($CurrentImageName & "IMG", _GDIPlus_BitmapCreateHBITMAPFromBitmap($LoadedImg))
		Assign($CurrentImageName & "DC", _WinAPI_CreateCompatibleDC($hScrDC))
		Assign($CurrentImageName & "Width", _GDIPlus_ImageGetWidth($LoadedImg))
		Assign($CurrentImageName & "Height", _GDIPlus_ImageGetHeight($LoadedImg) / $ImageCount)
		Assign($CurrentImageName & "Pos", StringSplit(IniRead($ThemeINI, $CurrentImageName, "Position", "0,0,0"), ","))
		
		_WinAPI_SelectObject(Eval($CurrentImageName & "DC"), Eval($CurrentImageName & "IMG"))
		_GDIPlus_ImageDispose($LoadedImg)
	Next
	
	$IconPos = StringSplit(IniRead($ThemeINI, "Icon", "Position", "0,0"), ",")
	$IconSize = StringSplit(IniRead($ThemeINI, "Icon", "Size", "0,0"), ",")
	
	$FontPos = StringSplit(IniRead($ThemeINI, "Caption", "FontPosition", "0,0"), ",")
	$FontName = IniRead($ThemeINI, "Caption", "FontName", "Arial")
	$FontSize = IniRead($ThemeINI, "Caption", "FontSize", "10")
	$FontColor = IniRead($ThemeINI, "Caption", "FontColor", "255,255,255")
	
	$BlurPos = StringSplit(IniRead($ThemeINI, "Blur", "Margins", "0,0,0,0"), ",")
	
	$ReflectionPos = StringSplit(IniRead($ThemeINI, "Reflection", "Margins", "0,0,0"), ",")
	
	_WinAPI_ReleaseDC(0, $hScrDC)
EndFunc   ;==>LoadGlobalSkin

Func UnLoadGlobalSkin()
	Local Const $ThemeStructure[13] = ["TopLeft", "Top", "TopRight", "Left", "Right", "BottomLeft", "Bottom", "BottomRight", "Reflection", _
			"MinButton", "MaxButton", "ResButton", "CloseButton"]
	For $i = 0 To 12
		Local $CurrentImageName = $ThemeStructure[$i]
		_WinAPI_DeleteDC(Eval($CurrentImageName & "DC"))
		_WinAPI_DeleteObject(Eval($CurrentImageName & "IMG"))
	Next
EndFunc   ;==>LoadGlobalSkin