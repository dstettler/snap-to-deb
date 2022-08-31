#!/bin/sh

if [ 0 != $(id -u) ]; then echo "This script must be run as root."; exit 1; fi

install() {
	# Hook and git directory
	cp "05snap-check-update" "/etc/apt/apt.conf.d"
	cd ..
	
	mkdir "/opt/authy-deb-generator"
	echo $PWD > "/opt/authy-deb-generator/snap-check-update-pref"
	cp "./hook-stuff/check-updates.sh" "/opt/authy-deb-generator"

	# In case the script is not already marked as executable
	chmod +x "/opt/authy-deb-generator/check-updates.sh"
	
	echo "Installed successfully!"
	echo ""
	echo ""
	echo "!!! PLEASE DO NOT DELETE THE AUTHY-DEB-GENERATOR FOLDER! IT IS REQUIRED TO KEEP THE UPDATER SERVICE WORKING !!!"
	exit 0
}

uninstall() {
	rm "/etc/apt/apt.conf.d/05snap-check-update"
	rm -rf "/opt/authy-deb-generator"
	echo "Removed successfully!"
	exit 0
}

if [ "$(ls -la "/etc/apt/apt.conf.d" | grep 05snap-check-update)" = "" ]; then
	echo "Install the apt hook to check for updates? (Y/n)"
	read update
	case $update in
		"n")
			exit 0
			;;
		"N")
			exit 0
			;;
		*)
			install
			;;
	esac
else
	echo "Uninstall the apt hook to check for updates? (Y/n)"
	read update
	case $update in
		"n")
			exit 0
			;;
		"N")
			exit 0
			;;
		*)
			uninstall
			;;
	esac
fi
