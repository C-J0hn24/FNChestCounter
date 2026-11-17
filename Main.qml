import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import FNChestCounter

ApplicationWindow {
    id: window
    width: 440
    height: 515
    minimumWidth: 440
    minimumHeight: 515
    maximumWidth: 440
    maximumHeight: 515
    visible: true
    title: qsTr("Chesticle Counter")

    //cppstuff
    ChestCounter{id:chest}

    //main font
    FontLoader { id: fntL0; source: "fonts/Comfortaa-Light.ttf" }
    FontLoader { id: fntL1; source: "fonts/Comfortaa-Bold.ttf" }
    FontLoader { id: fntL2; source: "fonts/DigitalNumbers-Regular.ttf" }

    //background
    Rectangle{
    anchors.fill: parent; z:-1;
        gradient: Gradient{
            GradientStop{position:0.0; color:"#281A48";}
            GradientStop{position:0.05; color:"#170F29";}
            GradientStop{position:0.85; color:"#130A27";}
            GradientStop{position:1.0; color:"#290D3B";}
        }
    }

    //text align
    component RegText:Text{
        //width:10
        anchors.centerIn: parent;
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "Comfortaa"
        color: "#FFFFFF"
    }

    //Butt
    component BigButt:Button{
        property int bgRad:10;

        scale: pressed? 0.8:hovered ? 1.08:1.0
        anchors.verticalCenter: parent.verticalCenter;

        Behavior on scale {NumberAnimation{duration:350;easing.type:Easing.OutBack}}

        background: Rectangle{radius: bgRad; border.width: 1;border.color: "#6D31C0"

            gradient: Gradient{
                GradientStop{position:0.0; color:"#2F1135";}
                GradientStop{position:0.25; color:"#180C22";}
                GradientStop{position:0.50; color:"#0F0A1B";}
                GradientStop{position:0.85; color:"#16112E";}
                GradientStop{position:1.0; color:"#191538";}
            }
        }
    }

    //maincards
    Column{
        spacing: 20
        anchors.centerIn: parent

        //top header
        Rectangle{id: rec1; width:210; height: 42; visible:true; radius: 15;
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 1;
            border.color: "#6D31C0"
            color: "#0F0A1B"

            //txt
            RegText{ text:"Chesticle Counter"; font.bold:true; font.pixelSize: 18}
        }

        //middle counter card
        Rectangle{id: rec2; width:375; height: 235; visible:true; radius: 20;
            border.width: 1;
            border.color: "#6D31C0"
            //bg
            gradient: Gradient{
                GradientStop{position:0.0; color:"#2F1135";}
                GradientStop{position:0.25; color:"#180C22";}
                GradientStop{position:0.50; color:"#0F0A1B";}
                GradientStop{position:0.85; color:"#16112E";}
                GradientStop{position:1.0; color:"#191538";}
            }

            //contents
            Column{
                spacing: 30
                anchors.centerIn: parent

                //txt
                Rectangle{id: rec2_1; width:180; height: 42; visible:true; radius: 15;
                    anchors.horizontalCenter: parent.horizontalCenter
                    border.width: 1;
                    border.color: "#6D31C0"
                    color: "#0F0A1B"

                    RegText{font.family:fntL2.name; text:"Chests Opened"; font.bold:false; font.pixelSize: 14}
                }

                //counter
                Rectangle{id: rec2_2; width:200; height: 65; visible:true; radius:5;
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "transparent"

                    RegText{font.family:fntL2.name; text:chest.chest_count.toString().padStart(7,"0"); font.pixelSize: 48}
                }

                //reset
                Row{
                    spacing:20
                    anchors.horizontalCenter: parent.horizontalCenter
                    //est per hr WIP
                    Rectangle{id: rec2_3; width:200; height: 35; visible:true; radius:10;
                        RegText{opacity: .75; font.family:fntL0.name; text:"Window FN"; font.bold:true; font.pixelSize: 14}

                        border.width: 1;
                        border.color: "#6D31C0"

                        gradient: Gradient{
                            orientation: Gradient.Horizontal
                            GradientStop{position:0.0; color:"#3A174A";}
                            GradientStop{position:0.10; color:"#190D21";}
                            GradientStop{position:0.90; color:"#24102E";}
                            GradientStop{position:1.0; color:"#371646";}
                        }

                    }
                    //chest counter reset
                    BigButt{id: bt1; width:80; height: 35; visible:true;
                        RegText{font.family:fntL1.name; text:"Reset"; font.bold:true; font.pixelSize: 18}
                        onClicked:chest.reset_BigChestsCount();

                    }
                }
            }

        }

        //bottom keybind card
        Rectangle{id: rec3; width:375; height: 130; visible:true; radius: 20;
            border.width: 1;
            border.color: "#6D31C0"
            //bg
            gradient: Gradient{
                GradientStop{position:0.0; color:"#0F0A1B";}
                GradientStop{position:0.40; color:"#0F0A1B";}
                GradientStop{position:0.95; color:"#1D173F";}
            }

            Column{
                spacing:12
                anchors.centerIn: parent

                Row{
                    spacing:12
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle{id: rec3_1; width:130; height: 20; visible:true; radius:5;
                        color: "transparent"
                        RegText{font.family:fntL2.name; text:"Keybind"; font.pixelSize: 18}
                    }

                    Rectangle{id:rec3_1_1;width: 100;height: 15; visible:true;
                        anchors.verticalCenter: parent.verticalCenter
                        color:"transparent"

                        RegText{opacity: .50; font.family:fntL0.name; text:"Stroke Mode :"; font.pixelSize: 14}
                    }
                    //keybind reset
                    BigButt{bgRad:6; id: bt3_1_1; width:80; height: 25; visible:true;
                        RegText{font.family:fntL1.name; text:chest.stroke_mode; font.bold:false; font.pixelSize: 12}
                        onClicked:{chest.chestStrokeState();}
                    }
                }

                //keybind setup
                Row{
                    id:keyRow
                    spacing:12
                    anchors.horizontalCenter: parent.horizontalCenter
                    property bool isListening:false;

                    Rectangle{id: rec3_2; width:150; height: 40; visible:true; radius:10;
                        border.width: 1;
                        border.color: "#6D31C0"

                        gradient: Gradient{
                            orientation: Gradient.Horizontal
                            GradientStop{position:0.0; color:"#110A17";}
                            GradientStop{position:0.60; color:"#24102E";}
                            GradientStop{position:1.0; color:"#4C1C60";}
                        }

                        RegText{font.family:fntL0.name; text:keyRow.isListening? "Capturing.." : "Key rn : "+chest.key_name; font.pixelSize: 12; opacity: .75;}
                        focus: true;
                        Keys.onPressed: (event)=>{
                                            if(keyRow.isListening){
                                                chest.set_cap_key(event.key);
                                                keyRow.isListening=false;
                                                event.accepted = true;
                                            }
                                        }
                    }

                    //keybind set
                    BigButt{id: bt3_1; width:80; height: 35; visible:true;
                        RegText{font.family:fntL1.name; text:"Set"; font.bold:true; font.pixelSize: 18}
                        onClicked: {keyRow.isListening=true; rec3_2.forceActiveFocus();}
                    }
                    //keybind reset
                    BigButt{id: bt3_2; width:80; height: 35; visible:true;
                        RegText{font.family:fntL1.name; text:"Reset"; font.bold:true; font.pixelSize: 18}
                        onClicked:{chest.reset_keyBind();}
                    }
                }

                Rectangle{id: rec3_3; width:355; height: 15; visible:true; radius:5;

                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "transparent"
                    RegText{opacity: .50; font.family:fntL0.name; text:"Press key to add chest, Don’t Forget to set it up first UwU"; font.pixelSize: 10}
                }
            }


        }
    }
}
