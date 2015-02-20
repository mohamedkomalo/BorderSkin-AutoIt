#NoTrayIcon
#include <Misc.au3>
#include <File.au3>
#include <Array.au3>
#include <SkinWindow.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)


$SettingsWnd = GUICreate("WinSkin Configurations", 512, 562, -1, -1, $GUI_SS_DEFAULT_GUI)

$MainTab = GUICtrlCreateTab(8, 8, 497, 505, $TCS_MULTILINE)

$SkinTab = GUICtrlCreateTabItem("      Skin      ")
$SkinGroup = GUICtrlCreateGroup("SkinGroup", 48, 379, 424, 120)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$SkinsList = GUICtrlCreateCombo("", 152, 403, 289, 25)
GUICtrlSetOnEvent(-1, "SkinListClick")
$InstallSkin = GUICtrlCreateButton("Install Skin", 81, 463, 185, 25, 0)
GUICtrlSetOnEvent(-1, "SkinInstall")
$DeleteSkin = GUICtrlCreateButton("Delete Skin", 272, 463, 185, 25, 0)
GUICtrlSetOnEvent(-1, "SkinDelete")
$Label1 = GUICtrlCreateLabel("Skin Name", 80, 406, 56, 17)
$Label2 = GUICtrlCreateLabel("Skin Author", 80, 430, 59, 17)
$SkinAuthor = GUICtrlCreateLabel(" Appears Here", 152, 431, 290, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$BlurTab = GUICtrlCreateTabItem("      Blur      ")
$Group1 = GUICtrlCreateGroup("Blur", 48, 379, 424, 120)
$BlurGroup = GUICtrlCreateGroup("", 72, 435, 153, 49)
$BlurSlider = GUICtrlCreateSlider(80, 451, 137, 25, BitOR($TBS_AUTOTICKS, $TBS_ENABLESELRANGE))
GUICtrlSetLimit(-1, 20, 2)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TransRadio = GUICtrlCreateRadio("Transparency", 80, 404, 129, 17)
GUICtrlSetOnEvent(-1, "Trans_OnClick")
$BlurRadio = GUICtrlCreateRadio("Blur", 82, 436, 41, 17)
GUICtrlSetOnEvent(-1, "Blur_OnClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$FontTab = GUICtrlCreateTabItem("      Font      ")
$Group2 = GUICtrlCreateGroup("Font", 48, 379, 424, 120)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Label4 = GUICtrlCreateLabel("Font Name : ", 80, 403, 65, 17)
$Label5 = GUICtrlCreateLabel("Font Size    : ", 80, 431, 66, 17)
$Label13 = GUICtrlCreateLabel("Font Color   : ", 264, 431, 61, 17)
$ChangeFontButton = GUICtrlCreateButton("Change Font", 256, 462, 145, 25, $WS_DISABLED)
GUICtrlSetOnEvent(-1, "Font_OnClick")
$FontNameLabel = GUICtrlCreateLabel(" Appears Here", 146, 403, 260, 17)
$FontSizeLabel = GUICtrlCreateLabel(" Appears Here", 146, 431, 72, 17)
$FontColorLabel = GUICtrlCreateLabel(" Appears Here", 326, 431, 72, 17)
$UseSkinFont = GUICtrlCreateCheckbox("Use font installed with the skin", 80, 466, 169, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "UseSkinFont")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$EffectsTab = GUICtrlCreateTabItem("      Effects      ")
$Group4 = GUICtrlCreateGroup("Effects", 48, 379, 424, 120)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$ReflectionRadio = GUICtrlCreateCheckbox("Reflections", 80, 411, 177, 17)
GUICtrlSetOnEvent(-1, "Reflection_OnClick")
$VistaExplorer = GUICtrlCreateCheckbox("Vista Explorer", 80, 429, 177, 17, $WS_DISABLED)
GUICtrlSetOnEvent(-1, "Reflection_OnClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$WallpaperTab = GUICtrlCreateTabItem("      Wallpaper      ")
$Group7 = GUICtrlCreateGroup("Wallpaper", 48, 379, 424, 120, $WS_DISABLED)
$Combo2 = GUICtrlCreateCombo(" ", 184, 403, 265, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button8 = GUICtrlCreateButton("Browse For Wallpaper", 272, 463, 185, 25, $WS_DISABLED)
$Label6 = GUICtrlCreateLabel("Wallpaper Name", 80, 406, 83, 17, $WS_DISABLED)
$Label7 = GUICtrlCreateLabel("Wallpaper Location", 80, 430, 96, 17, $WS_DISABLED)
$Label8 = GUICtrlCreateInput("", 184, 429, 266, 17, $WS_DISABLED)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$SettingsTab = GUICtrlCreateTabItem("    Program Settings    ")
$Group5 = GUICtrlCreateGroup("Settings", 48, 379, 424, 120)
$SplashCheck = GUICtrlCreateCheckbox("Don't Show Splash Window", 80, 403, 225, 17)
$StartupCheck = GUICtrlCreateCheckbox("Run Automatically at Windows Startup", 80, 423, 225, 17)
$Label19 = GUICtrlCreateLabel("Language Name", 80, 446, 83, 17, $WS_DISABLED)
$LangList = GUICtrlCreateCombo("", 200, 443, 241, 25, $WS_DISABLED)

GUICtrlCreateGroup("", -99, -99, 1, 1)

$AboutTab = GUICtrlCreateTabItem("      About      ")
$Group8 = GUICtrlCreateGroup("About", 48, 379, 424, 120)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Label9 = GUICtrlCreateLabel("WinSkin", 72, 398, 99, 29)
GUICtrlSetFont(-1, 16, 800, 0, "Georgia")
$Label10 = GUICtrlCreateLabel("Version 0.1 Beta Release", 176, 415, 158, 18)
GUICtrlSetFont(-1, 8, 800, 2, "Georgia")
$Label11 = GUICtrlCreateLabel("Windows Border Skining Utility", 176, 431, 200, 18)
GUICtrlSetFont(-1, 8, 800, 2, "Georgia")
$Label12 = GUICtrlCreateLabel("Updates        :", 176, 479, 88, 18)
GUICtrlSetFont(-1, 8, 800, 2, "Georgia")
$WinSkinPage = GUICtrlCreateLabel("www.komalosoft.com/winskin", 264, 479, 197, 18)
GUICtrlSetOnEvent(-1, "WinSkinPage")
GUICtrlSetFont(-1, 8, 800, 4, "Georgia")
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetCursor(-1, 0)
$KomaloSoftPage = GUICtrlCreateLabel("www.komalosoft.com", 264, 463, 140, 18)
GUICtrlSetOnEvent(-1, "KomaloSoftPage")
GUICtrlSetFont(-1, 8, 800, 4, "Georgia")
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetCursor(-1, 0)
$Label15 = GUICtrlCreateLabel("Komalo Soft :", 176, 463, 88, 18)
GUICtrlSetFont(-1, 8, 800, 2, "Georgia")
$Pic3 = GUICtrlCreatePic("Icon.jpg", 75, 424, 85, 73)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$Label16 = GUICtrlCreateLabel("Programed By Mohamed Kamal", 176, 447, 203, 18)
GUICtrlSetFont(-1, 8, 800, 2, "Georgia")
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateTabItem("")

$MoniterImage = GUICtrlCreatePic("File.jpg", 48, 56, 430, 320)
$WallpaperImage = GUICtrlCreatePic(_GetDesktopWallpaper(), 70, 76, 387, 220)
$Button4 = GUICtrlCreateButton("OK", 8, 520, 161, 33, 0)
$Button5 = GUICtrlCreateButton("Cancel", 176, 520, 161, 33, 0)
$Button6 = GUICtrlCreateButton("Quit", 344, 520, 161, 33, 0)

Global $HideSplash = Number(IniRead("Settings.ini", "Settings", "HideSplash", ""))
Local $EffectSettings[3], $FontSettings
$EffectSettings[0] = Number(IniRead("Settings.ini", "Settings", "BlurEnabled", ""))
$EffectSettings[1] = IniRead("Settings.ini", "Settings", "BlurStrength", "")
$EffectSettings[2] = Number(IniRead("Settings.ini", "Settings", "Reflection", ""))
If Not IniRead("Settings.ini", "Settings", "UseSkinFont", "") Then
	Global $FontSettings[3]
	$FontSettings[0] = IniRead("Settings.ini", "Settings", "FontName", "")
	$FontSettings[1] = IniRead("Settings.ini", "Settings", "FontSize", "")
	$FontSettings[2] = IniRead("Settings.ini", "Settings", "FontColor", "")
EndIf

Global $Blur = Number(IniRead("Settings.ini", "Settings", "BlurEnabled", ""))
Global $BlurValue = IniRead("Settings.ini", "Settings", "BlurStrength", "")
Global $Reflection = Number(IniRead("Settings.ini", "Settings", "Reflection", ""))
Global $FontName = IniRead("Settings.ini", "Settings", "FontName", "")
Global $FontSize = IniRead("Settings.ini", "Settings", "FontSize", "")
Global $FontColor = IniRead("Settings.ini", "Settings", "FontColor", "")
Global $HideSplash = Number(IniRead("Settings.ini", "Settings", "HideSplash", ""))

Local $ThemeName = IniRead("Settings.ini", "Settings", "ThemeName", "")

UpdateSettings()

_GDIPlus_Startup()

SkinComponentsLoad($ThemeName, $EffectSettings, $FontSettings)

$hPreviewWindow = GUICreate("Active Window Example", 340, 150, 100, 90, BitOR($WS_DISABLED, $WS_CLIPSIBLINGS, $WS_POPUP), BitOR($WS_EX_MDICHILD,$WS_EX_LAYERED), $SettingsWnd)
GUISetState(@SW_SHOWNOACTIVATE, $hPreviewWindow)
GUISetState(@SW_SHOW, $SettingsWnd)
$hSkinWindowPreview = SkinWindowCreate($hPreviewWindow)
SkinWindowShow($hSkinWindowPreview, @SW_DISABLE)
SkinWindowShow($hSkinWindowPreview, @SW_SHOWNOACTIVATE)
UpdatePreviewWindow()

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit", $SettingsWnd)
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "Slide_OnChange", $SettingsWnd)

While 1
	Sleep(100000000)
WEnd

Func _Exit()
	SkinComponentsUnLoad()
	Exit
EndFunc   ;==>_Exit

Func Slide_OnChange()
	$CursorInfo = GUIGetCursorInfo(@GUI_WinHandle)
	If $CursorInfo[4] = $BlurSlider Then
		Do
			UpdatePreviewWindow()
			$CursorInfo = GUIGetCursorInfo(@GUI_WinHandle)
		Until $CursorInfo[2] = 0
	EndIf
EndFunc   ;==>Slide_OnChange

Func Cancel_OnClick()
	GUISetState(@SW_HIDE, $SettingsWnd)
EndFunc   ;==>Cancel_OnClick

Func Reflection_OnClick()
	UpdatePreviewWindow()
EndFunc   ;==>Reflection_OnClick

Func Font_OnClick()
	Local $Color = GUICtrlRead($FontColorLabel)
	$Color = StringSplit($Color, ",")
	Local $FontDialgue = _ChooseFont(GUICtrlRead($FontNameLabel), GUICtrlRead($FontSizeLabel), ColorGetColorRef($Color[1], $Color[2], $Color[3]), 0, False, False, False, $SettingsWnd)
	If @error Then Return
	GUICtrlSetData($FontNameLabel, $FontDialgue[2])
	GUICtrlSetData($FontSizeLabel, $FontDialgue[3])
	GUICtrlSetData($FontColorLabel, GetRGB($FontDialgue[7]))
	GUICtrlSetColor($FontColorLabel, $FontDialgue[7])
	UpdatePreviewWindow()
EndFunc   ;==>Font_OnClick

Func GetRGB($iColorRef)
	Local $hex = Hex($iColorRef, 6)
	Local $HexRed = StringMid($hex, 1, 2), $HexGreen = StringMid($hex, 3, 2), $HexBlue = StringMid($hex, 5, 2)
	Return Dec($HexRed) & "," & Dec($HexGreen) & "," & Dec($HexBlue)
EndFunc   ;==>GetRGB

Func UseSkinFont()
	Local $ControlState = $GUI_ENABLE
	If BitAND(GUICtrlRead(@GUI_CtrlId), $GUI_CHECKED) Then $ControlState = $GUI_DISABLE
	GUICtrlSetState($ChangeFontButton, $ControlState)
	
EndFunc   ;==>UseSkinFont

Func Blur_OnClick()
	GUICtrlSetState($BlurGroup, $GUI_ENABLE)
	GUICtrlSetState($BlurSlider, $GUI_ENABLE)
	UpdatePreviewWindow()
EndFunc   ;==>Blur_OnClick

Func Trans_OnClick()
	GUICtrlSetState($BlurGroup, $GUI_DISABLE)
	GUICtrlSetState($BlurSlider, $GUI_DISABLE)
	UpdatePreviewWindow()
EndFunc   ;==>Trans_OnClick

Func SkinInstall()
	$SelectedFile = FileOpenDialog("Open Skin ...", @DesktopDir, "All (*.*)", 1 + 2, "")
EndFunc   ;==>SkinInstall

Func SkinDelete()
	Local Const $ReturnYes = 6, $ReturnNo = 7, $DeleteSkinFolder = $ThemesFolder & GUICtrlRead($SkinsList)
	$ConfirmDelete = MsgBox(32 + 4 + 256, "Delete Skin", 'Are you sure you want to delete "' & GUICtrlRead($SkinsList) & '" ?', 0, $SettingsWnd)
	If $ConfirmDelete = $ReturnNo Then Return
	;If FileExists($ThemesFolder & GUICtrlRead($SkinsList)) Then DirRemove($ThemesFolder & GUICtrlRead($SkinsList),1)
EndFunc   ;==>SkinDelete

Func SkinListClick()
	;UpdatePreviewWindow()
	GUISetCursor(1,1,$SettingsWnd)
	UnLoadGlobalSkin()
	LoadGlobalSkin(GUICtrlRead($SkinsList))
	SkinWindowUpdate($hSkinWindowPreview,1)
	GUICtrlSetData($SkinAuthor, IniRead($ThemesFolder & GUICtrlRead($SkinsList) & "\" & "ThemeSettings.ini", "SkinInfo", "Author", "Not Included With Skin"))
	GUISetCursor(2,1,$SettingsWnd)
EndFunc   ;==>SkinListClick

Func OK_OnClick()
	IniWrite("Settings.ini", "Settings", "BlurEnabled", BitAND(GUICtrlRead($BlurRadio), $GUI_CHECKED))
	IniWrite("Settings.ini", "Settings", "BlurStrength", GUICtrlRead($BlurSlider))
	IniWrite("Settings.ini", "Settings", "Reflection", Number($Reflection))
	IniWrite("Settings.ini", "Settings", "FontName", GUICtrlRead($FontNameLabel))
	IniWrite("Settings.ini", "Settings", "FontSize", GUICtrlRead($FontSizeLabel))
	IniWrite("Settings.ini", "Settings", "UseSkinFont", BitAND(GUICtrlRead($UseSkinFont), $GUI_CHECKED))
	IniWrite("Settings.ini", "Settings", "HideSplash", BitAND(GUICtrlRead($SplashCheck), $GUI_CHECKED))
	
	If BitAND(GUICtrlRead($StartupCheck), $GUI_CHECKED) Then RegWrite("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Border Blur", "REG_SZ", @ScriptFullPath)
	If BitAND(GUICtrlRead($StartupCheck), $GUI_UNCHECKED) Then RegDelete("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Border Blur");HKEY_LOCAL_MACHINE
	_Exit()
EndFunc   ;==>OK_OnClick

Func UpdateSettings()
	GUICtrlSetData($BlurSlider, $BlurValue)
	
	GUICtrlSetState($BlurGroup, $GUI_DISABLE)
	GUICtrlSetState($BlurSlider, $GUI_DISABLE)
	If $Blur Then
		GUICtrlSetState($BlurRadio, $GUI_CHECKED)
		GUICtrlSetState($BlurGroup, $GUI_ENABLE)
		GUICtrlSetState($BlurSlider, $GUI_ENABLE)
	EndIf
	
	If $Reflection Then GUICtrlSetState($ReflectionRadio, $GUI_CHECKED)
	
	GUICtrlSetData($FontNameLabel, $FontName)
	GUICtrlSetData($FontSizeLabel, $FontSize)
	GUICtrlSetData($FontColorLabel, $FontColor)
	
	$Startup = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "WinSkin")
	If Not ($Startup = "") Then GUICtrlSetState($StartupCheck, $GUI_CHECKED)
	If Number($HideSplash) Then GUICtrlSetState($SplashCheck, $GUI_CHECKED)
	
	$Skins = _FileListToArray($ThemesFolder, "*", 2)
	$Skins = _ArrayToString($Skins, "|", 1)
	GUICtrlSetData($SkinsList, $Skins, $ThemeName)
	GUICtrlSetData($SkinAuthor, IniRead($ThemesFolder & GUICtrlRead($SkinsList) & "\" & "ThemeSettings.ini", "SkinInfo", "Author", ""))
EndFunc   ;==>UpdateSettings

Func UpdatePreviewWindow()
	Local $CustomSettings[6]
	Global $Blur = BitAND(GUICtrlRead($BlurRadio), $GUI_CHECKED)
	Global $BlurValue = GUICtrlRead($BlurSlider)
	Global $Reflection = BitAND(GUICtrlRead($ReflectionRadio), $GUI_CHECKED)
	Global $FontName = GUICtrlRead($FontNameLabel)
	Global $FontSize = GUICtrlRead($FontSizeLabel)
	Global $FontColor = GUICtrlRead($FontColorLabel)
	;$hFont = _WinAPI_CreateFont(0, 0, 0, 0, 500, 0, 0, 0, 0, 0, 0, 0, 0, $FontName)
	$hFont = _WinAPI_CreateFont($FontSize * 2, 0, 0, 0, $FW_BOLD , False, False, False, $HANGEUL_CHARSET, $OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $ANTIALIASED_QUALITY, $FF_DECORATIVE, $FontName)
	_WinAPI_DeleteObject(_WinAPI_SelectObject($TextDC,$hFont))
	$Color = StringSplit(GUICtrlRead($FontColorLabel),",")
	_WinAPI_SetTextColor($TextDC,ColorGetRGBHex($Color[1],$Color[2],$Color[3]))
	SkinWindowUpdate($hSkinWindowPreview,1)
	;SkinWindowUpdate($hPreviewWindow, False, True, $CustomSettings)
EndFunc   ;==>UpdatePreviewWindow

Func WinSkinPage()
	ShellExecute("www.komalosoft.com/winskin")
EndFunc   ;==>WinSkinPage

Func KomaloSoftPage()
	ShellExecute("www.komalosoft.com")
EndFunc   ;==>KomaloSoftPage

Func _GetDesktopWallpaper()
	Local $aResult = RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "Wallpaper")
	Return $aResult
EndFunc   ;==>_GetDesktopWallpaper