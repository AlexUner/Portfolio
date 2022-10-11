//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
#include <Windows.h>

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
#include <commctrl.h>
#include <winuser.h>
TForm1 *Form1;
int kol = 25;
double mas_g[25];
//---------------------------------------------------------------------------
HWND GetDesktopListViewHWND()
{
    HWND hDesktopListView = NULL;
    HWND hWorkerW = NULL;
    HWND hProgman = FindWindow(_T("Progman"), 0);
    HWND hDesktopWnd = GetDesktopWindow();

    if (hProgman) {
        HWND hShellViewWin = FindWindowEx(hProgman, 0, _T("SHELLDLL_DefView"), 0);
        if (hShellViewWin) {
            hDesktopListView = FindWindowEx(hShellViewWin, 0, _T("SysListView32"), 0);
        } else {
            do {
                hWorkerW = FindWindowEx( hDesktopWnd, hWorkerW, _T("WorkerW"), NULL );
                hShellViewWin = FindWindowEx(hWorkerW, 0, _T("SHELLDLL_DefView"), 0);
            } while (hShellViewWin == NULL && hWorkerW != NULL);
        }

        hDesktopListView = FindWindowEx(hShellViewWin, 0, _T("SysListView32"), 0);
    }

    return hDesktopListView;
}
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void mov(int x0, int y0, int x1, int y1)
{
	mouse_event(MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE, x0*Form1->kx,y0*Form1->ky, 0, 0);
	mouse_event(MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_ABSOLUTE, x0, y0, 0, 0);
	for (int i = 10; i > 0; --i){
		mouse_event(MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE, (x1/i)*Form1->kx,y1*Form1->ky, 0, 0);
		Sleep(1);
	}
	mouse_event(MOUSEEVENTF_LEFTUP | MOUSEEVENTF_ABSOLUTE, x1, y1, 0, 0);
}
//---------------------------------------------------------------------------
double funk(double x)
{
	return pow((x - 3),2);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
	Form1->Visible = false;
	/*
	keybd_event(VK_LWIN, 0, 0, 0);
	keybd_event(VK_CONTROL, 0, 0, 0);
	keybd_event(68, 0, 0, 0);
	keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0);
	keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
	keybd_event(68, 0, KEYEVENTF_KEYUP, 0);
    */
	AnsiString s;
	int start = 1-(kol/2), s1;             // shag rascheta
	int w = round(1860.0/kol);              // otmetki po shirine ekrana
    w_g = w;

	s1 = start;
	double mas[kol];

	for (int i = 0; i < kol; i++) {       // raschet funk
		mas[i] = funk(s1);
		++s1;
	}

	double 	max = mas[0],
			min = mas[0],
			length;

	for (int i = 0; i < kol; i++)         // minmax massiva funk
	{
		if (mas[i] > max) max = mas[i];
		if (mas[i] < min) min = mas[i];
	}
	length = max-min;

	for (int i = 0; i < kol; i++) {       // raschet procentov
		if (mas[i] < 0) {
			mas[i] = (abs(min - mas[i])/length)*910;
		}
		else
		{
            mas[i] = (abs(mas[i] - max)/length)*910;
        }
		++s1;
	}

	for (int i = 0; i < kol; i++) {
		s = "C:\\Users\\alexa\\Desktop\\p" + IntToStr(i);
		CreateDir(s);
		//mov(30,30,w*(i+2), mas[i]);
	}
	memcpy(mas_g, mas, sizeof(mas));
    Sleep(3000);
    Button3->Click();
	Form1->Visible = true;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
	Label1->Caption = "Положение мыши: "+(String)Mouse->CursorPos.x+"; "+(String)Mouse->CursorPos.y;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    AnsiString s;
	for (int i = 0; i < kol; i++) {
		s = "C:\\Users\\alexa\\Desktop\\p" + IntToStr(i);
		RemoveDir(s);
    }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button3Click(TObject *Sender)
{
	HWND hDesktop = GetDesktopListViewHWND();
	/*if(!hDesktop)
    {
		ShowMessage("HWND not found");
	}
	else
	{
		DWORD ProcessID;
		HANDLE Process;
		TPoint *PointBuf;
		TPoint p;
        DWORD nReadWritten;
		int count;

		PLVItem PRemoteItem;
		PChar PRemoteText;
		LV_ITEM localItem;
		char localText[128];

		//int cnt = SendMessage(hDesktop,LVM_GETITEMCOUNT,0,0);
		//ShowMessage(IntToStr(cnt));

		GetWindowThreadProcessId(hDesktop, &ProcessID);
		Process = OpenProcess(PROCESS_VM_OPERATION | PROCESS_VM_READ |
										PROCESS_VM_WRITE, false, ProcessID);
		PointBuf = static_cast<TPoint*>(VirtualAllocEx(Process, 0, sizeof(TPoint), MEM_RESERVE |
										MEM_COMMIT, PAGE_READWRITE));

		count = SendMessage(hDesktop, LVM_GETITEMCOUNT, 0, 0);
		TPoint XYold[count];

		PRemoteItem = static_cast<PLVItem>(VirtualAllocEx(Process, 0, sizeof(LV_ITEM), MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE));
		PRemoteText = static_cast<PChar>(VirtualAllocEx(Process, 0, 128, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE));

		localItem.cchTextMax = 128;
		localItem.pszText = PRemoteText;
		localItem.iSubItem = 0;

		if (!WriteProcessMemory(Process, PRemoteItem, &localItem,
			sizeof(LV_ITEM), &nReadWritten))
		{
		  ShowMessage("error writing memory");
		}

		for (int K = 0; K < count; K++)
		{
			Memo1->Lines->Text += ("\n" + IntToStr(K) + ")");
			/*SendMessage(hDesktop, LVM_GETITEMTEXT, K - 1, (long)PRemoteItem);
			ReadProcessMemory(Process, PRemoteText, &localText, sizeof(localText), &nReadWritten);
			Memo1->Lines->Add((String)localText);


			if (SendMessage(hDesktop, LVM_GETITEMPOSITION, K - 1,
				(long)PointBuf) && ReadProcessMemory(Process, PointBuf, &p,
				sizeof(TPoint), &nReadWritten))
			{
				XYold[K] = p;
				Memo1->Lines->Add((String)XYold[K].x + ":" + (String)XYold[K].y);
			}
		}
		//XYold[1].x+=85;
		//SendMessage(hDesktop, LVM_SETITEMTEXT, 1, &XYold[1]);
		VirtualFreeEx(Process, PointBuf, 0, MEM_RELEASE);
        VirtualFreeEx(Process, PRemoteItem, 0, MEM_RELEASE);
		VirtualFreeEx(Process, PRemoteText, 0, MEM_RELEASE);
		CloseHandle(Process);
							 */
		for (int i = 0; i < kol+1; i++) {
			ListView_SetItemPosition(hDesktop, i, w_g*(i), mas_g[i]);
		}

	//}
}
//---------------------------------------------------------------------------

