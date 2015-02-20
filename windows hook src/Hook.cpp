
#pragma once
#include <windows.h>

HWND hWnd;
HHOOK hHook;
HINSTANCE hModule;
UINT WM_WINSKIN = RegisterWindowMessage("WinSkinHook");

extern "C" {
 __declspec(dllexport) int SetHook(void);
 __declspec(dllexport) int RemoveHook(void);
}
LRESULT CALLBACK CallWndProc(int nCode,WPARAM wParam,LPARAM lParam);

BOOL WINAPI DllMain( HINSTANCE Module, unsigned long  ul_reason_for_call,void* lpReserved )
{
	hModule = Module ;
    switch (ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH:
			 hWnd = FindWindow("AutoIt v3 GUI","BorderBlur Message Handler GUI");
			 break;
		case DLL_THREAD_ATTACH:
			 break;
		case DLL_THREAD_DETACH:
			 break;
		case DLL_PROCESS_DETACH:
			break;
    }
    return TRUE;
}

int SetHook(void)
{
	if (hHook == NULL)
	{
		SendMessage(hWnd,WM_USER+109,0,10);
		hHook = SetWindowsHookEx(WH_CALLWNDPROC,HOOKPROC(CallWndProc),hModule,0); 
		if (hHook != NULL)
			return 1;
	}
	return 0;
}

int RemoveHook(void)
{
	int result = 0;
	if (hHook != NULL)
	{
		result = UnhookWindowsHookEx(hHook);
		if (result)
			hHook = NULL;
	}
	return result;
}

LRESULT CALLBACK CallWndProc(int nCode,WPARAM wParam,LPARAM lParam)
{

	if( (lParam!=NULL) && (nCode == HC_ACTION) && (lParam != NULL) )
	{
		CWPSTRUCT *CwpStruct = (CWPSTRUCT *) lParam;
		long style = GetWindowLong(CwpStruct->hwnd, GWL_STYLE);

		if ( (!(style & WS_CAPTION)) || (style & WS_CHILD) )
			return CallNextHookEx(hHook,nCode,wParam,lParam);

		if (CwpStruct->message == WM_WINSKIN)
		{
			HRGN rgn;
			tagRECT MainFormRect;
			int aCaption_Metrics = GetSystemMetrics(SM_CYCAPTION);
			int aFrame_Metrics	 = GetSystemMetrics(SM_CXFIXEDFRAME);
			int iCaption_Height  = aCaption_Metrics + aFrame_Metrics;

			GetWindowRect(HWND(CwpStruct->wParam),&MainFormRect);
			rgn = CreateRectRgn	(	aFrame_Metrics,
									aCaption_Metrics + aFrame_Metrics ,
									(MainFormRect.right - MainFormRect.left) - 2,
									(MainFormRect.bottom - MainFormRect.top) - 2);
			SetWindowRgn(HWND(CwpStruct->wParam),rgn,true);
			return CallNextHookEx(hHook,nCode,wParam,lParam);
		}

		switch(CwpStruct->message)
		{

			case WM_ACTIVATE:
				if ( (LOWORD(CwpStruct->wParam) == WA_ACTIVE) || (LOWORD(CwpStruct->wParam) == WA_CLICKACTIVE) )
					SendMessage(hWnd,WM_USER + 1,WPARAM(CwpStruct->lParam),LPARAM(CwpStruct->hwnd));
				
				if ( LOWORD(CwpStruct->wParam) == WA_INACTIVE )
					SendMessage(hWnd,WM_USER + 8,WPARAM(CwpStruct->lParam),LPARAM(CwpStruct->hwnd));
				break;

			case WM_SETTEXT:
				SendMessageTimeout(hWnd,WM_USER + 2,WPARAM(CwpStruct->lParam),LPARAM(CwpStruct->hwnd),SMTO_ABORTIFHUNG,100,0);
				break;

			case WM_SETICON:
				SendMessageTimeout(hWnd,WM_USER + 3,WPARAM(CwpStruct->lParam),LPARAM(CwpStruct->hwnd),SMTO_ABORTIFHUNG,100,0);
				break;/**/

			case WM_CLOSE:
			case WM_QUIT:
			case WM_DESTROY:
				SendMessageTimeout(hWnd,WM_USER + 4,0,LPARAM(CwpStruct->hwnd),SMTO_ABORTIFHUNG,100,0);
				break;

			case WM_SIZE:
				SendMessageTimeout(hWnd,WM_USER + 6,WPARAM(CwpStruct->lParam),LONG(CwpStruct->hwnd),SMTO_ABORTIFHUNG,100,0);

				break;

			case WM_MOVE:
				SendMessageTimeout(hWnd,WM_USER + 7,WPARAM(CwpStruct->lParam),LPARAM(CwpStruct->hwnd),SMTO_ABORTIFHUNG,100,0);
				break;

			case WM_ENTERSIZEMOVE:
				SendMessageTimeout(hWnd,WM_USER + 9,WPARAM(CwpStruct->wParam),LPARAM(CwpStruct->hwnd),SMTO_ABORTIFHUNG,100,0);
				break;

			case WM_WINDOWPOSCHANGED:
				WINDOWPOS *WindowPos = (WINDOWPOS *) CwpStruct->lParam;
				PostMessage(hWnd,WM_USER + 10,WPARAM(WindowPos->flags),LPARAM(CwpStruct->hwnd));
				break;/*aa*/
		}
	}
	return CallNextHookEx(hHook,nCode,wParam,lParam);
}
