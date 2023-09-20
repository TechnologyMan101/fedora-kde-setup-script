# Fedora KDE Setup Script
Bash script to set up a fresh install of Fedora KDE.


# Documentation

Version 5.10

Supported Fedora KDE Versions: 38

Recommended Free Space: 40 GB

**Please Run Script After Following Instructions Here**

<ins>_**Make sure to update your system using the system’s software center and reboot before performing any tasks here and running the script. Failing to do so may result in severe breakage!!!**_</ins>

**The Extras folder also contains other tools you may want.**


Please install .rpm files and files using other types of installation formats using files manually (if you have them).

Please add yourself to `vboxusers` using `sudo usermod -aG vboxusers $USER` and then reboot. Only do this if you have VirtualBox installed. As the RPMFusion Free repository includes VirtualBox, the full install option in this script will install VirtualBox, thus, this part of setup will be automated within the script. This command should only be manually used if the user uses the minimal install option and installs VirtualBox manually. 


# Keyboard Shortcuts:

Change “Switch to next desktop” to “Ctrl+Meta+Right Arrow”

Change “Switch to previous desktop” to “Ctrl+Meta+Left Arrow”

Change “Make Window Fullscreen” to “Meta+F11”


# Plasma Widgets:

This is to be done after running the script!!!

Simple Overview Pager by tuxg0d – replace default pager in taskbar


# Run Script:

Mark the script as executable by changing it in file properties or running `chmod +x /path/to/file`. Then run it in Terminal with `bash /path/to/file`


# VM Users

Minimal Install is recommended. VM Tools can be found at https://mega.nz/folder/sBwwxBTR#zf6d3UaJYnNGl5tXaN63ag in Extras or at https://github.com/TechnologyMan101/script-extras/releases.


# Other Notes

Switching to the X11 session is recommended for IBus to work properly. The session switcher is located on the login screen near the bottom left corner. 


# Fixes

If the mouse cursor appears very large on the login screen, run `sudo nano /etc/sddm.conf.d/kde_settings.conf` and add “CursorSize=XX” to the “[Theme]” section of the file. Replace XX with the size you want. Usually, it would be 24. 
