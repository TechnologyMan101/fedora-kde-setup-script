#!/bin/bash
clear
# Start of Function Cluster
tput setaf 3
echo "Initializing functions..."
sleep 1.5
tput setaf 10
checkcompatibility () {
	# Set variables
	. /etc/os-release
	isfedora="false"
	kernelarch=$(uname -m)
	
	# Check distro
	if ! echo $PRETTY_NAME | grep -qi "Fedora"
	then
		sysreqfail
	fi
	isfedora="true"
	iskde="false"
	
	# Check KDE
	if ! echo $PRETTY_NAME | grep -qi "KDE Plasma"
	then
		sysreqfail
	fi
	iskde="true"

	# Check for 41
	if ! echo $VERSION_ID | grep -qi "41"
	then
		sysreqfail
	fi
	
	# Check kernel architecture
	if ! uname -m | grep -qi "x86_64"
	then
		sysreqfail
	fi
}
echo "Loaded checkcompatibility."
checkfreespace () {
	min_free_space=40
	free_space=$(df -h / | awk 'NR==2{print $4}' | sed 's/[^0-9.]//g')
	if [ $(echo "$free_space < $min_free_space" | bc) -eq 1 ]; then
		spacewarning
	fi
}
echo "Loaded checkfreespace."
spacewarning () {
	clear
	tput setaf 9
	echo "The script has detected that there is less than 40 GB of storage available on the root volume."
	tput setaf 3
	echo "For an ideal experience, it is recommended that the root volume has at least 40 GB of space available."
	tput setaf 10
	echo "Your current free space: $free_space GB"
	tput setaf 3
	echo "Press <return> to continue at your own risk (for re-running the script)"
	echo "Press any other key to quit"
	tput sgr0
	echo "Enter your selection:"
	IFS=""
	read -sN1 answer
	case $(echo "$answer" | tr A-Z a-z) in
		"")	mainmenu;;
		*)	quitscript;;
	esac
}
echo "Loaded spacewarning."
sysreqfail () {
	clear
	tput setaf 9
	echo "System requirements not met. This script supports the x86_64 version of Fedora 41 KDE!!!"
	tput setaf 3
	echo "If your error is not caused by a wrong Fedora version or OS architecture, please check to see if I have published a script for your system."
	tput setaf 10
	echo "Your current distro is $PRETTY_NAME."
	# Display Fedora codename if Fedora
	if echo $isfedora | grep -qi "true"
	then
		echo "Your current Fedora version is $VERSION_ID."
		echo "Fedora Edition is KDE: $iskde"
	fi
	echo "Your current OS architecture is $kernelarch."
	tput sgr0
	echo "Hit any key to exit:"
	IFS=""
	read -sN1 answer
	quitscript
}
echo "Loaded sysreqfail."
mainmenu () {
	clear
 	tput setaf 3
	echo "======================================"
	echo " --- Fedora KDE Setup Script 5.20 ---"
	echo "======================================"
	echo "Supported Fedora KDE Versions (x86_64): 41"
	echo "Recommended Free Space: 40 GB"
	tput setaf 10
	echo "Your current distro is $PRETTY_NAME."
	echo "Your current Fedora version is $VERSION_ID."
	echo "Fedora Edition is KDE: $iskde"
	echo "Your current OS architecture is $kernelarch."
	echo "Your current free space: $free_space GB"
tput setaf 3
	echo "Script may prompt you or ask you for your password once in a while. Please monitor your computer until the script is done."
	echo "This script will show terminal output. This is normal."
	echo "You can open this script in a text editor to view all functions."
	tput setaf 10
	echo "You are encouraged to modify this script for your own needs."
	tput setaf 9
	echo "System will automatically reboot after the script is run!!!"
	tput setaf 10
	echo "Please run this script again after a major system upgrade."
	tput setaf 9
	echo "Make sure you have a stable and fast Internet connection before proceeding!!!"
	tput setaf 3
	echo "Press 1 to perform a Full Install (All User Packages)"
	echo "Press 2 to perform a Minimal Install (Essentials)"
	echo "Press 3 to view instructions for setting up a multi-user system"
	tput setaf 9
	echo "Press Q to quit"
	tput sgr0
	echo "Enter your selection:"
	IFS=""
	read -sN1 answer
	case $(echo "$answer" | tr A-Z a-z) in
		1)	full;;
		2)	minimal;;
		3)	multiusermenu;;
		q)	quitscript;;
		*)	badoption;;
	esac
}
echo "Loaded mainmenu."
multiusermenu () {
	clear
 	tput setaf 3
	echo "==========================================="
	echo " --- Instructions for Multi-User Setup ---"
	echo "==========================================="
	tput setaf 9
	echo "If you want to set up multiple user accounts on your computer, please run the script again with the same options on each new user account. Make sure that additional user accounts are set to Administrator. You can set accounts back to Standard after completing setup."
	tput sgr0
	echo "Hit any key to return to the main menu:"
	IFS=""
	read -sN1 answer
	mainmenu
}
echo "Loaded multiusermenu."
quitscript () {
	tput sgr0
	clear
	exit
}
echo "Loaded quitscript."
badoption () {
	clear
	tput setaf 9
	echo "Invalid Option!"
	tput setaf 3
	echo "Returning to Main Menu..."
	tput sgr0
	sleep 3
	mainmenu
}
echo "Loaded badoption."
finish () {
	clear
	tput setaf 10
	echo "Done..."
	tput setaf 9
	echo "Rebooting..."
	tput sgr0
	sleep 3
	clear
	sudo reboot
}
echo "Loaded finish."
full () {
	clear
	tput setaf 3
	echo "Full Install/All User Packages..."
	tput sgr0
	sleep 3
	clear
	runcheck sudo dnf install -y fedora-workstation-repositories
	runcheck sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	runcheck sudo dnf config-manager -y setopt fedora-cisco-openh264.enabled=1
	runcheck sudo dnf config-manager -y setopt google-chrome.enabled=1
	runcheck sudo dnf config-manager -y setopt copr:copr.fedorainfracloud.org:phracek:PyCharm.enabled=1
	runcheck sudo dnf config-manager -y setopt rpmfusion-nonfree-nvidia-driver.enabled=1
	runcheck sudo dnf config-manager -y setopt rpmfusion-nonfree-steam.enabled=1
	runcheck sudo dnf update -y @core
	runcheck sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
	runcheck sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
	runcheck sudo dnf install -y rpmfusion-free-release-tainted
	runcheck sudo dnf install -y libdvdcss
	runcheck sudo dnf install -y rpmfusion-nonfree-release-tainted
	runcheck flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	runcheck sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig
	runcheck sudo dnf install -y "https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm"
	runcheck sudo dnf install -y alien remmina bleachbit frozen-bubble asunder k3b libburn cdrskin pavucontrol easyeffects solaar gparted vlc p7zip* lame gpart fastfetch fastfetch-bash-completion ffmpeg httrack tree android-tools kwave kamoso supertux dconf-editor ffmpegthumbs krita gimp htop transmission-qt qbittorrent curl git handbrake-gui minetest discord java-latest-openjdk gstreamer-plugins* gstreamer1-plugins* pip python3 google-chrome-stable kernel-headers kernel-devel gcc glibc-headers make dkms cpu-x libheif libquicktime gdk-pixbuf2 kf5-kimageformats kcharselect kweather mcomix3 VirtualBox gscan2pdf supertuxkart unzip gsmartcontrol dvdstyler skanlite kdenlive kid3 skanpage kclock krename filelight gnome-disk-utility viewnior aria2 simple-scan qt hugin kalk
	javamenu
	runcheck sudo dnf copr enable -y g3tchoo/prismlauncher
	runcheck sudo dnf install -y prismlauncher
	runcheck sudo dnf update -y --refresh
	runcheck sudo dnf autoremove -y
	runcheck flatpak install -y flathub org.audacityteam.Audacity
	runcheck flatpak install -y flathub org.musescore.MuseScore
	runcheck flatpak install -y flathub org.inkscape.Inkscape
	runcheck flatpak install -y flathub com.github.jeromerobert.pdfarranger
	runcheck flatpak install -y flathub com.github.muriloventuroso.pdftricks
	runcheck flatpak install -y flathub com.github.tchx84.Flatseal
	runcheck flatpak install -y flathub org.onlyoffice.desktopeditors
	runcheck flatpak install -y flathub com.obsproject.Studio
	runcheck flatpak install -y flathub org.telegram.desktop
	runcheck flatpak install -y flathub net.lutris.Lutris
	runcheck flatpak install -y flathub org.kde.subtitlecomposer
	runcheck flatpak install -y flathub io.missioncenter.MissionCenter
	runcheck flatpak install -y flathub com.calibre_ebook.calibre
	runcheck flatpak install -y flathub info.febvre.Komikku
	runcheck flatpak install -y flathub io.github.diegoivan.pdf_metadata_editor
	runcheck flatpak update -y
	runcheck flatpak uninstall -y --unused --delete-data
	runcheck python3 -m ensurepip
	runcheck python3 -m pip install pip wheel -U
	runcheck python3 -m pip install --pre yt-dlp[default] -U
    runcheck python3 -m pip cache purge
	echo "Adding current user to cdrom group..."
	runcheck sudo usermod -aG cdrom $USER
	echo "Adding current user to vboxusers group..."
	runcheck sudo usermod -aG vboxusers $USER
	echo "Removing Solaar autostart file..."
	sudo rm /etc/xdg/autostart/solaar.desktop
	appendbashrc1
	autofontinstall
	installmiscdrivers
	finish
}
echo "Loaded full."
minimal () {
	clear
	tput setaf 3
	echo "Minimal Install/Essentials..."
	tput sgr0
	sleep 3
	clear
	runcheck sudo dnf install -y fedora-workstation-repositories
	runcheck sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	runcheck sudo dnf config-manager -y setopt fedora-cisco-openh264.enabled=1
	runcheck sudo dnf config-manager -y setopt google-chrome.enabled=1
	runcheck sudo dnf config-manager -y setopt copr:copr.fedorainfracloud.org:phracek:PyCharm.enabled=1
	runcheck sudo dnf config-manager -y setopt rpmfusion-nonfree-nvidia-driver.enabled=1
	runcheck sudo dnf config-manager -y setopt rpmfusion-nonfree-steam.enabled=1
	runcheck sudo dnf update -y @core
	runcheck sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
	runcheck sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
	runcheck sudo dnf install -y rpmfusion-free-release-tainted
	runcheck sudo dnf install -y libdvdcss
	runcheck sudo dnf install -y rpmfusion-nonfree-release-tainted
	runcheck flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	runcheck sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig
	runcheck sudo dnf install -y "https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm"
	runcheck sudo dnf install -y alien pavucontrol gparted p7zip* gpart fastfetch fastfetch-bash-completion ffmpeg dconf-editor ffmpegthumbs htop curl git gstreamer-plugins* gstreamer1-plugins* pip python3 google-chrome-stable kernel-headers kernel-devel gcc glibc-headers make dkms easyeffects cpu-x libheif libquicktime gdk-pixbuf2 kf5-kimageformats kcharselect mcomix3 gscan2pdf unzip gsmartcontrol krename filelight gnome-disk-utility skanlite skanpage kclock kweather viewnior aria2 simple-scan qt hugin kalk
	runcheck sudo dnf update -y --refresh
	runcheck sudo dnf autoremove -y
	runcheck flatpak install -y flathub com.github.jeromerobert.pdfarranger
	runcheck flatpak install -y flathub com.github.muriloventuroso.pdftricks
	runcheck flatpak install -y flathub com.github.tchx84.Flatseal
	runcheck flatpak install -y flathub org.onlyoffice.desktopeditors
	runcheck flatpak install -y flathub io.missioncenter.MissionCenter
	runcheck flatpak install -y flathub info.febvre.Komikku
	runcheck flatpak install -y flathub io.github.diegoivan.pdf_metadata_editor
	runcheck flatpak update -y
	runcheck flatpak uninstall -y --unused --delete-data
	runcheck python3 -m ensurepip
	runcheck python3 -m pip install pip wheel -U
	runcheck python3 -m pip cache purge
	appendbashrc2
	autofontinstall
	installmiscdrivers
	finish
}
echo "Loaded minimal."
javamenu () {
	clear
 	tput setaf 3
	echo "============================"
	echo " --- Java Configuration ---"
	echo "============================"
	echo "On the next screen, you will be prompted to select the default Java version. Please select the option with java-latest-openjdk. This is usually option 2."
	tput sgr0
	echo "Press any key to continue"
	IFS=""
	read -sN1 answer
	clear
	runcheck sudo alternatives --config java
	clear
	java --version
	sleep 3
	clear
}
echo "Loaded javamenu."
appendbashrcinfo () {
	clear
 	tput setaf 3
	echo "===================================="
	echo " --- Information on CLI Aliases ---"
	echo "===================================="
	echo "The 'sysupdate' alias will be added to your user profile. This is an alias that updates the computer more thoroughly. It is recommended to run this every week. This alias does not handle major system upgrades. To use this alias, run 'sysupdate' in a terminal."
	tput sgr0
	echo "Press any key to continue"
	IFS=""
	read -sN1 answer
	clear
}
echo "Loaded appendbashrcinfo."
appendbashrc1 () {
	appendbashrcinfo
	echo "Adding sysupdate alias and fastfetch to .bashrc..."
	runcheck sed -i '/sysupdate/d' ~/.bashrc
	runcheck echo 'alias sysupdate="sudo dnf update -y --refresh && sudo dnf autoremove -y && flatpak update -y && flatpak uninstall -y --unused --delete-data && python3 -m pip install pip wheel -U && python3 -m pip install --pre yt-dlp[default] -U && python3 -m pip cache purge"' >> ~/.bashrc
	runcheck sed -i '/fastfetch/d' ~/.bashrc
	runcheck echo 'fastfetch' >> ~/.bashrc
}
echo "Loaded appendbashrc1."
appendbashrc2 () {
	appendbashrcinfo
	echo "Adding sysupdate alias and fastfetch to .bashrc..."
	runcheck sed -i '/sysupdate/d' ~/.bashrc
	runcheck echo 'alias sysupdate="sudo dnf update -y --refresh && sudo dnf autoremove -y && flatpak update -y && flatpak uninstall -y --unused --delete-data && python3 -m pip install pip wheel -U && python3 -m pip cache purge"' >> ~/.bashrc
	runcheck sed -i '/fastfetch/d' ~/.bashrc
	runcheck echo 'fastfetch' >> ~/.bashrc
}
echo "Loaded appendbashrc2."
autofontinstall () {
	echo "Installing the Essential Font Pack..."
	runcheck sudo wget -O "/tmp/fontinstall.zip" "https://github.com/TechnologyMan101/script-extras/releases/download/20240122-2030/Essential.Font.Pack.zip"
	sudo rm -rf "/usr/share/fonts/Essential Font Pack"
	runcheck sudo unzip -o "/tmp/fontinstall.zip" -d "/usr/share/fonts"
	runcheck sudo chmod -R 755 "/usr/share/fonts/Essential Font Pack"
	runcheck sudo rm "/tmp/fontinstall.zip"
}
echo "Loaded autofontinstall."
installmiscdrivers () {
	echo "Installing miscellaneous drivers from RPM Fusion..."
	runcheck sudo dnf install -y intel-media-driver libva-intel-driver nvidia-vaapi-driver
	runcheck sudo dnf --repo=rpmfusion-nonfree-tainted install -y "*-firmware"
}
echo "Loaded installmiscdrivers."
runcheck () {
	IFS=$'\n'
	command="$*"
	retval=1
	attempt=1
	until [[ $retval -eq 0 ]] || [[ $attempt -gt 5 ]]; do
		(
			set +e
			$command
		)
		retval=$?
		attempt=$(( $attempt + 1 ))
		if [[ $retval -ne 0 ]]; then
			clear
			tput setaf 9
			echo "Oops! Something went wrong! Retrying in 3 seconds..."
			tput sgr0
			sleep 3
			clear
		fi
	done
	if [[ $retval -ne 0 ]] && [[ $attempt -gt 5 ]]; then
		clear
		tput setaf 9
		echo "Oops! A fatal error has occurred and the program cannot continue. Returning to the main menu in 10 seconds..."
		tput setaf 3
		echo "Please try again later or if the problem persists, create an issue on GitHub."
		tput sgr0
		sleep 10
		clear
		mainmenu
	fi
	IFS=""
}
echo "Loaded runcheck."
tput setaf 3
echo "Continuing..."
tput sgr0
sleep 1.5
# End of Function Cluster
# Start of Main Script
while true
do
	checkcompatibility
	checkfreespace
	mainmenu
done
# End of Main Script
