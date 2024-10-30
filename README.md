# Fedora KDE Setup Script
Bash script to set up a fresh install of Fedora KDE.


# Documentation

Version 5.20

Supported Fedora KDE Versions: 41

Recommended Free Space: 40 GB

**Please Run Script After Following Instructions Here**

<ins>_**Make sure to update your system using the system’s software center and reboot before performing any tasks here and running the script. Failing to do so may result in severe breakage!!!**_</ins>

**The Extras folder also contains other tools you may want.**


Please install .rpm files and files using other types of installation formats using files manually (if you have them).

Please add yourself to `vboxusers` using `sudo usermod -aG vboxusers $USER` and then reboot. Only do this if you have VirtualBox installed. As the RPMFusion Free repository includes VirtualBox, the full install option in this script will install VirtualBox, thus, this part of setup will be automated within the script. This command should only be manually used if the user uses the minimal install option and installs VirtualBox manually. 


# Keyboard Shortcuts:

Add shortcut for “Decrease Microphone Volume” using the keys “Meta+Ctrl+Alt+Down”

Add shortcut for “Decrease Volume” using the keys “Ctrl+Alt+Down”

Add shortcut for “Increase Microphone Volume” using the keys “Meta+Ctrl+Alt+Up”

Add shortcut for “Increase Volume” using the keys “Ctrl+Alt+Up”

Add shortcut for “Mute” using the keys “Ctrl+Alt+Shift+Down”

Add shortcut for “Mute Microphone” using the keys “Meta+Ctrl+Alt+Shift+Down”

Add shortcut for “Media playback next” using the keys “Ctrl+Alt+End”

Add shortcut for “Media playback previous” using the keys “Ctrl+Alt+Home”

Add shortcut for “Play/Pause media playback” using the keys “Ctrl+Alt+Shift+Up”

Add shortcut for “Make Window Fullscreen” using the keys “Meta+F11”

Enable default shortcut for “Switch One Desktop to the Left”

Enable default shortcut for “Switch One Desktop to the Right”


# Firefox Users:

In `about:config`, set `widget.use-xdg-desktop-portal.file-picker` to `1` in order to make the browser use the KDE’s native file picker instead of the one from GTK. 


# Flatpak Applications and Cursor Themes:

This issue mainly affects users on Wayland, which is the only session available on Fedora 40 KDE and above. If a Flatpak application displays a incorrect cursor theme or size, run `mkdir -p ~/.local/share/icons/default/ && nano ~/.local/share/icons/default/index.theme` in Terminal and type `[Icon Theme]`, then press Enter and type `Inherits=breeze_cursors`. Save the file by pressing Ctrl+X, then `y`, and then Enter. Make sure to change these variable values as appropriate to your system, as these follow KDE defaults. For example, if you use the white variant of the default Breeze cursors, change the value of the `Inherits` property to `Breeze_Light`. 


# Overview Shortcut:

Mark the `KDE Overview Shortcut.desktop` file as executable by changing permissions in file properties or running `chmod +x /path/to/file`. Then drag the file to the panel between the Application Launcher icon and the first application shortcut. This adds the shortcut as a widget. Note that the shortcut will not work until the script has been run due to dependencies. If you do not want to use the default workspace pager in addition to this shortcut, remove the default workspace pager. 


# Run Script:

Mark the script as executable by changing it in file properties or running `chmod +x /path/to/file`. Then run it in Terminal with `bash /path/to/file`


# VM Users

Minimal Install is recommended. VM Tools can be found at https://mega.nz/folder/sBwwxBTR#zf6d3UaJYnNGl5tXaN63ag in Extras or at https://github.com/TechnologyMan101/script-extras/releases.
