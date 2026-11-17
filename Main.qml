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

        background: Rectangle{radius: bgRad;

            border.width: 1;
            border.color: hovered ?"#94CBFF" : "#6D31C0";

            gradient: Gradient{
                GradientStop{position:0.0; color: hovered ?   "#274858" : "#2F1135";
                    Behavior on color{
                        ColorAnimation{duration: 350; easing.type:Easing.InOutCubic }
                    }
                }
                GradientStop{position:0.25; color: hovered ?  "#0C1422" : "#180C22" ;
                    Behavior on color{
                        ColorAnimation{duration: 350; easing.type:Easing.InOutCubic }
                    }
                }
                GradientStop{position:0.50; color: hovered ?  "#0A161B" : "#0F0A1B" ;
                    Behavior on color{
                        ColorAnimation{duration: 350; easing.type:Easing.InOutCubic }
                    }
                }
                GradientStop{position:0.85; color: hovered ? "#111F2E": "#16112E" ;
                    Behavior on color{
                        ColorAnimation{duration: 350; easing.type:Easing.InOutCubic }
                    }
                }
                GradientStop{position:1.0; color: hovered ?  "#152C38" : "#191538" ;
                    Behavior on color{
                        ColorAnimation{duration: 350; easing.type:Easing.InOutCubic }
                    }
                }
            }
        }
    }

    //maincards
    Column{
        spacing: 20
        anchors.centerIn: parent

        //reset chestflashing
        Timer{id:chestPulse; interval:200; repeat: false
                onTriggered: chest.resetChestPulse();
        }
        Connections{target: chest
            function onChestPulse_Changed(){
                if(chest.chestAdded){chestPulse.restart();}
            }
        }

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
            border.color: chest.chestAdded?"#94CBFF" : "#6D31C0";
            Behavior on border.color{
                ColorAnimation{duration: 300; easing.type:Easing.InOutCubic }
            }

            //bg
            gradient: Gradient{
                GradientStop{position:0.0; color: chest.chestAdded ?   "#274858" : "#2F1135";
                    Behavior on color{
                        ColorAnimation{duration: 200; easing.type:Easing.InOutCubic }
                    }
                }
                GradientStop{position:0.25; color: chest.chestAdded ?  "#0C1422" : "#180C22" ;
                    Behavior on color{
                        ColorAnimation{duration: 200; easing.type:Easing.InOutCubic }
                    }
                }
                GradientStop{position:0.50; color: chest.chestAdded ?  "#0A161B" : "#0F0A1B" ;
                    Behavior on color{
                        ColorAnimation{duration: 200; easing.type:Easing.InOutCubic }
                    }
                }
                GradientStop{position:0.85; color: chest.chestAdded ? "#111F2E": "#16112E" ;
                    Behavior on color{
                        ColorAnimation{duration: 200; easing.type:Easing.InOutCubic }
                    }
                }
                GradientStop{position:1; color: chest.chestAdded ?  "#274858" : "#191538" ;
                    Behavior on color{
                        ColorAnimation{duration: 200; easing.type:Easing.InOutCubic }
                    }
                }
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
                        RegText{opacity: chest.gameinFocus ? 1 : 0.75; font.family:fntL0.name; font.bold:false; font.pixelSize: 8
                                color: chest.gameinFocus ? "#FFFFFF" : "#AAAAAA"
                                text: chest.gameinFocus ? "Game in Focus || Counter Running":"Game out of Focus || Counter Stopped";

                                Behavior on opacity{
                                    NumberAnimation{duration: 300; easing.type:Easing.InOutCubic }
                                }
                                Behavior on color{
                                    ColorAnimation{duration: 300; easing.type:Easing.InOutCubic }
                                }
                        }

                        border.width: 1;
                        border.color: chest.gameinFocus?"#94CBFF" : "#6D31C0";
                        Behavior on border.color{
                            ColorAnimation{duration: 300; easing.type:Easing.InOutCubic }
                        }

                        gradient: Gradient{
                            orientation: Gradient.Horizontal
                            GradientStop{position:0.0; color: chest.gameinFocus ?  "#173F4A" : "#3A174A";
                                Behavior on color{
                                    ColorAnimation{duration: 300; easing.type:Easing.InOutCubic }
                                }
                            }
                            GradientStop{position:0.10; color: chest.gameinFocus ? "#0D0F21" : "#190D21";
                                Behavior on color{
                                    ColorAnimation{duration: 300; easing.type:Easing.InOutCubic }
                                }
                            }
                            GradientStop{position:0.90; color: chest.gameinFocus ? "#101E2E" : "#24102E";
                                Behavior on color{
                                    ColorAnimation{duration: 300; easing.type:Easing.InOutCubic }
                                }
                            }
                            GradientStop{position:1.0; color: chest.gameinFocus ? "#162E46" : "#371646";
                                Behavior on color{
                                    ColorAnimation{duration: 300; easing.type:Easing.InOutCubic }
                                }
                            }
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

        //bottom header
        Rectangle{id: rec4; width:170; height: 20; visible:true; radius: 15;
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 1;
            border.color: "#6D31C0"
            color: "#0F0A1B"

            Row{
                anchors.centerIn: parent
                spacing:4

                //txt
                Text{text: "Chesticle By C-J0hn24"; font.family: fntL0.name; font.pixelSize: 10
                    color: "#FFFFFF"; opacity: .5
                    anchors.verticalCenter: parent.verticalCenter
                }
                Rectangle{
                    border.width: 1;
                    border.color: "#A118D8"
                    width: 12; height: 12; radius: 15
                    color: "#A118D8"; opacity: .5
                    anchors.verticalCenter: parent.verticalCenter

                    Image{
                        anchors.centerIn: parent
                        width: 15; height: 15
                        fillMode: Image.PreserveAspectFit
                        source: "img/github.png"
                    }
                }
            }
        }
    }
}
