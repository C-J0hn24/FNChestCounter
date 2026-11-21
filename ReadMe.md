# FNChestCounter

A tiny Super lite QML CPP based native windows app to count FN Chests. Bc I can't count more than 10...

![FNChestCounter](img/icon.ico)

## ✨ What It Does

- 🎮 Counts chest opens using a custom keybind.
- ⏱️ Supports two counting modes:
  - **Hold**: *(Default Mode)* counts once after holding the key for 250ms.
  - **Rapid**: counts once per key press, checked every 100ms to avoid spamming.
- 👁️ Automatically pauses when the game/client is not in the foreground/focus.
- 🧠 Live status indicator in app shows which client is focused:
  - `Fortnite in Focus`
  - `GFN in Focus`
- 🪶 Runs quietly in the system tray.
- 🖱️ Hover the tray icon to see the current chest count live-ish.
- 📋 Tray menu options yay:
  - **Show Counter**
  - **Exit**
- ✨ Soft pulse glow every time a chest is counted.
- 💾 Remembers your count, keybind, and stroke mode across restarts.
- 📝 Resetting the counter writes a timestamped log file next to the exe.
- 🔁 Singleinstance only!!!

## 🎯 Supported Clients As of Now

- Fortnite
- GeForce NOW

> Note: GeForce NOW support detects the GeForce NOW client itself.  
> It does not know which game is being streamed inside the client yet.

## 🧰 Requirements

- Windows 10 or 11,64bit
- Fortnite or GeForce NOW
- No administrator perms required :)

## 📦 Installationsssss

### Portable (Recommended)

Just extract the FNChestCounter.v1.0.1_portable.zip
and run the exe..
No Installer needed :)


### Installer

Installer
Run FNChesticleCounter-Setup-1.0.1.exe -> wizard -> done.
Or grab the portable folder and double tap the exe.

## 💾 Files Created by the app

- Settings / count INI file:  
  `AppData\Roaming\FNChestCounter`

- Reset log file:  
  `Chesticle_Counter.txt`  

# Extra Note
Creates count ini file (in appdata) and Log file `Chesticle_Counter.txt`(same folder as exe)

## 🕹️ Usage

1. Open FNChestCounter.
2. Click **Set** under Keybind.
3. Press the key you want to use for counting chests
(Usually same keybind you use for interactions in game).
4. Choose **Hold** *(Default Mode)* or **Rapid** stroke mode.
5. Open Fortnite or GeForce NOW.
6. Press your bound key when opening a chest.
7. Minimize the app to send it to the tray.
8. Hover the tray icon to check your count.

## Why This Exists

To count chests on fn ofc..

## 📜 Credit

Made by **C-J0hn24**.
