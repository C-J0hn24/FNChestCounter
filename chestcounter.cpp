#include "ChestCounter.h"
#include <QTimer>
#include <QCoreApplication>

//cppbrdigetowin
static ChestCounter* g_bigChest_inst=nullptr;
//plane C callback for winswitch notifier
VOID CALLBACK WinEventProcCallback(
    HWINEVENTHOOK hWinEventHook,DWORD event,HWND hwnd,LONG idObject,
    LONG idChild,DWORD dwEventThread,DWORD dwmsEventTime)
{
    if(g_bigChest_inst){
        g_bigChest_inst->checkActiveWindow();
    }
}

//trig once
ChestCounter::ChestCounter(QObject *parent): QObject(parent) {

    //checks active win on first boot
    checkActiveWindow();

    //loop
    timer->setInterval(100);//update ms
    connect(timer,&QTimer::timeout,this, &ChestCounter::checkKey);//procks checkkey every 100ms

    //init timer
    if(gameFocus){was_pressed=true; timer->start();}
    else{timer->stop();}

    //address
    g_bigChest_inst=this;

    //focused win via eventhook
    SetWinEventHook(
        EVENT_SYSTEM_FOREGROUND,EVENT_SYSTEM_FOREGROUND,
        NULL,WinEventProcCallback,0,0,WINEVENT_OUTOFCONTEXT
        );

    //save 2 mem on close
    connect(qApp,&QCoreApplication::aboutToQuit,this,[this](){
        mem->setValue("Big_Chests_Grabbed_Without_Consent",chest_opened);
        mem->setValue("Active_KeyBind",cap_key);
        mem->setValue("Stroke_Mode", chestStroke_mode);
        mem->setValue("Qt_Key",Qt_cap_key);
    });

    //for next boot load BigChest Vals n key
    chest_opened=mem->value("Big_Chests_Grabbed_Without_Consent",0).toInt();
    cap_key=mem->value("Active_KeyBind",0).toInt();
    Qt_cap_key=mem->value("Qt_Key").toInt();
    chestStroke_mode=mem->value("Stroke_Mode",1).toInt();
    chestStroke_mode=chestStroke_mode ? 1:0;
    holdChest_Delay=chestStroke_mode ? 250:0;
}

//focus whindow check fn for windows
void ChestCounter::checkActiveWindow(){

    bool oldGameFocus=gameFocus;
    gameFocus=false;

    //checks current focuswindow
    HWND active_win=GetForegroundWindow();
    if(!active_win){timer->stop();return;}

    //gets current focused window's PID n save it;
    DWORD active_winpid=0;
    GetWindowThreadProcessId(active_win,&active_winpid);

    //politecat way to ask for proc path uwu
    HANDLE hProcess =OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION,FALSE,active_winpid);
    if(!hProcess)return;

    //read path of activefocus proc
    wchar_t buffer[MAX_PATH]; //path
    DWORD size = MAX_PATH;//wordcount in path

    //comparision active_proc to target
    if(QueryFullProcessImageNameW(hProcess,0,buffer,&size)){
        //cpp conversion
        std::wstring full_path(buffer);
        size_t last_slash=full_path.find_last_of(L"\\");//grabs last slice of path
        //chopchop unwantedpath aside from last exe_str
        std::wstring exe_name=full_path.substr(last_slash+1);

        //mainthing
        if(exe_name==target_win){gameFocus=true;}
        else{gameFocus=false;}
    }

    //qml updater on change
    if(gameFocus!=oldGameFocus)emit gameFocus_Changed();

    //init timer
    if(gameFocus){was_pressed=true; timer->start();}
    else{timer->stop();}

    //close on done
    CloseHandle(hProcess);
}

void ChestCounter:: checkKey(){

    //counts only on fn
    if(gameFocus){
        //do nun if key is set
        if(cap_key==0)return;
        //key pressed
        bool is_pressed=(GetAsyncKeyState(cap_key)&0x8000)!=0;
        //the real deal
        if (is_pressed && !was_pressed){
            holonChest.start();
            bigChestHeld=false;
        }
        if(is_pressed && holonChest.isValid() && !bigChestHeld){
            //if held for ms
            if(holonChest.elapsed()>=holdChest_Delay){
                ++chest_opened;
                chest_added=true;
                emit c_opened(); emit chestPulse_Changed();
                bigChestHeld=true;
            }
        }
        if(!is_pressed){holonChest.invalidate();}

        was_pressed=is_pressed;
    }
}
