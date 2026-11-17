#ifndef CHESTCOUNTER_H
#define CHESTCOUNTER_H

#include <QSettings>
#include <QObject>
#include <QQmlEngine>
#include <QTimer>
#include <windows.h>
#include <QFile>
#include <QTextStream>
#include <QDateTime>
#include <QKeySequence>
#include <QElapsedTimer>

class ChestCounter: public QObject
{
    Q_OBJECT//coms inits uwu
    QML_ELEMENT//qml as element reads the file as qml library smht

    //var expose for qml
    Q_PROPERTY(int chest_count READ getChests NOTIFY c_opened)
    Q_PROPERTY(QString key_name READ getKeyName NOTIFY KeyBind_Changed)
    Q_PROPERTY(QString stroke_mode READ getChestStrokeMode NOTIFY chestStroke_Changed)
    Q_PROPERTY(bool gameinFocus READ getGameFocus NOTIFY gameFocus_Changed)
    Q_PROPERTY(bool chestAdded READ getChestAdded NOTIFY chestPulse_Changed)

private:
    int chest_opened=0;
    int cap_key=0;
    int Qt_cap_key=0;
    int chestStroke_mode=1;
    int holdChest_Delay=250;//ms

    bool bigChestHeld=false;
    bool was_pressed=true;
    bool gameFocus=false;
    bool chest_added=false;

    void checkKey();

    std::wstring target_win=L"FortniteClient-Win64-Shipping.exe";

    QElapsedTimer holonChest;
    QTimer *timer=new QTimer(this);
    QSettings *mem =new QSettings(QSettings::IniFormat,QSettings::UserScope,"FNChestCounter","ChesticleCounter",this);

public:
    //fetch
    int getChests(){return chest_opened;}
    int getCurrentKey(){return cap_key;}
    void checkActiveWindow();

    //chestadded pulse
    bool getChestAdded()const{return chest_added;}

    //active focused window
    bool getGameFocus()const {return gameFocus;}

    //keybind state func
    QString getKeyName()const{
        return Qt_cap_key ? QKeySequence(Qt_cap_key).toString()
                          : QStringLiteral("Not Set");
    }

    //storkestate
    QString getChestStrokeMode()const{
        return chestStroke_mode ? QStringLiteral("Hold"):QStringLiteral("Rapid");
    }

    //setting the captured key for stroking
    Q_INVOKABLE void set_cap_key(int qt_key){
        //raw qt key adds
        Qt_cap_key=qt_key;

        //matching keys from qt to cpp no conversion
        if((qt_key>=Qt::Key_A && qt_key<=Qt::Key_Z)||
            (qt_key>=Qt::Key_0 && qt_key<=Qt::Key_9)){
            cap_key=qt_key;
        }
        //special keys translations ima ask ai for ts if extras are needed
        else if(qt_key==Qt::Key_Space)cap_key=VK_SPACE;
        else if(qt_key==Qt::Key_Shift)cap_key=VK_SHIFT;
        else if(qt_key==Qt::Key_Control)cap_key=VK_CONTROL;
        else if(qt_key==Qt::Key_Escape)cap_key=VK_ESCAPE;

        //mouse input side butts gonna add maybe later
        else if(qt_key==900)cap_key=VK_LBUTTON;
        else if(qt_key==901)cap_key=VK_RBUTTON;

        //me lazy not adding unsupported key
        else cap_key=0;

        //stroking status
        was_pressed = true;

        //update ui
        emit KeyBind_Changed();
    };

    Q_INVOKABLE void reset_BigChestsCount(){

        //log onreset
        if(chest_opened!=0){
            QFile file{"Chesticle_Counter.txt"};
            if(!file.open(QIODevice::Append | QIODevice::Text))
                return;
            QTextStream out(&file);
            out << QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss")
                << " | Chesticle Grabbed = "<<chest_opened<<" | KeyBind = "<<getKeyName()
                <<" | Qtk/wink = "<<Qt_cap_key<<"/"<<cap_key<<"\n";
            file.close();
        };

        //update counter
        chest_opened=0; emit c_opened();
    }

    //keyreset
    Q_INVOKABLE void reset_keyBind(){cap_key=0; Qt_cap_key=0; emit KeyBind_Changed();};

    //chest strokeHold
    Q_INVOKABLE void chestStrokeState(){
        //real deal toggle uwu
        chestStroke_mode=!chestStroke_mode;
        holdChest_Delay=chestStroke_mode ? 250 : 0;

        emit chestStroke_Changed();
    }

    //reset chest pulse
    Q_INVOKABLE void resetChestPulse(){chest_added=false; emit chestPulse_Changed();}

    //class counter constructor call
    explicit ChestCounter(QObject *parent = nullptr);

//qml signal
signals:
    void c_opened();
    void KeyBind_Changed();
    void chestStroke_Changed();
    void gameFocus_Changed();
    void chestPulse_Changed();
};

#endif // CHESTCOUNTER_H
