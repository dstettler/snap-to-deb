#!/bin/sh

if [ 0 != $(id -u) ]; then echo "This script must be run as root."; exit 1; fi

dir=$(<"/opt/authy-deb-generator/snap-check-update-pref")

cd "$dir"

git fetch

out1=$(git log origin/main -n 1)
out2=$(git log -n 1)

if [ "$out1" = "$out2" ]; then
	echo "Snap package up to date!"
else
	git pull
	echo "Snap package not up to date. Download update now? (Y/n)"
	read update
	case $update in
		"n")
			exit 0
			;;
		"N")
			exit 0
			;;
		*)
			./authy-install.sh
			;;
	esac
fi

exit 0
