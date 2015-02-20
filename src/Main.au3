#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\WinSkin Icon.ico
#AutoIt3Wrapper_Res_Comment=Beta Edition
#AutoIt3Wrapper_Res_Description=WinSkin
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Company|Komalo Soft
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#NoTrayIcon
#include <Hook.au3>
#include <Global.au3>
#include <SkinWindow.au3>

HotKeySet("{ESC}", "EndProgram")
Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
_GDIPlus_Startup()

Global Const $SETTINGS_EXE = "Config.exe"
Global Const $SPLASH_FILE = @TempDir & "\WinSkinSplash.jpg"

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
Local $HideSplash = Number(IniRead("Settings.ini", "Settings", "HideSplash", ""))
Local $ThemeName = IniRead("Settings.ini", "Settings", "ThemeName", "")

FileInstall("D:\Aero Emulation Project\BorderBluring ( WinSkin Workshop )\Main With Themes\Resources\WinSkinSplash.jpg", $SPLASH_FILE)
If Not $HideSplash Then _CreateSplashWindow($SPLASH_FILE, 491, 178);_ShowSplashWindow(1000)
If FileExists($SPLASH_FILE) Then FileDelete($SPLASH_FILE)

SkinComponentsLoad($ThemeName, $EffectSettings, $FontSettings)
HookProcStart()

TrayCreateItem("WinSkin 0.1 Beta")
TrayItemSetState(-1, $TRAY_DEFAULT)
TrayCreateItem("")

$BlurCheck = TrayCreateItem("Configurations")
TrayItemSetOnEvent(-1, "OpenConfigurations")
TrayCreateItem("")

TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "EndProgram")

TraySetClick(8)
TraySetState()

While 1
	Sleep(10000000)
WEnd

Func OpenConfigurations()
	If Not FileExists($SETTINGS_EXE) Then Return MsgBox(48, "WinSkinConfig.exe Not Found", '"' & $SETTINGS_EXE & '" is not found in the program folder')
	Run($SETTINGS_EXE)
EndFunc   ;==>OpenConfigurations

Func EndProgram()
	HookProcEnd()
	SkinWindowRemoveAll()
	SkinComponentsUnLoad()
	_GDIPlus_Shutdown()
	If FileExists($SPLASH_FILE) Then FileDelete($SPLASH_FILE)
	Exit
EndFunc   ;==>EndProgram