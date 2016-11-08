# OpenCC4Aegisub
OpenCC Automation Plugin For Aegisub

This is for windows only,I only build [opencc](https://github.com/BYVoid/OpenCC/releases/tag/ver.1.0.4) and write this automation script for windows.

###Enviroment
- Aegisub 3.2.x or highter than this is required.
- You must install [Visual C++ Redistributable for Visual Studio 2015](https://www.microsoft.com/en-us/download/details.aspx?id=48145),if your computer don't have one.

###How to install
####Portable  Aegisub
Put all files in Aegisub root path.

###Notice
There is something not right in *.json file definition,mainly are ocd filename,I just copy from OpenCC Source file,not fix it.
if you want to use you own translate rule,just go to offical [OpenCC repo](https://github.com/BYVoid/OpenCC),
find how to create a ocd file,and use a json file to load it.you can simply put json file and related ocd file in opencc folder,
the automation will automatic load it.
